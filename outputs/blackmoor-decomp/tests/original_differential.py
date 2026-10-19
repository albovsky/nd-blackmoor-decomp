"""Run one function of the pinned original GAME.EXE under Unicorn on a fixture, for differential tests.

The native ports of FL-16, FL-17 and later (src/original_methods_fl*.c) are one-to-one with single GAME.EXE functions. A
differential test builds one fixture (object regions at fake addresses, patches to the image's globals, stack arguments),
runs the original bytes on it here and the native function on the same fixture (tests/fl_differential_shim.c, through
ctypes) and compares the memory, the return value and the ordered calls out. Only the callees the port reaches through a host
callback are replaced, by recording stubs at their entry; nothing inside the function under test is hooked.

Needs the Unicorn Python binding and the private work/original/GAME.EXE (pinned by SHA-256); the tests skip without them.
"""
from __future__ import annotations

import hashlib
import struct
import sys
from dataclasses import dataclass, field
from pathlib import Path

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[3]
GAME_EXE = ROOT / 'work/original/GAME.EXE'
EXE_SHA256 = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

try:
    import unicorn
    from unicorn import x86_const as x
    HAVE_UNICORN = True
except ImportError:  # pragma: no cover - depends on the box
    HAVE_UNICORN = False

STACK_BASE, STACK_SIZE = 0x01000000, 0x10000
STOP = 0x7ff00000
STUB_BASE = 0x7e000000
REGION_BASE, REGION_STEP = 0x20000000, 0x00010000


def available():
    """True when Unicorn imports and the pinned original is present."""
    if not HAVE_UNICORN or not GAME_EXE.is_file():
        return False
    return hashlib.sha256(GAME_EXE.read_bytes()).hexdigest() == EXE_SHA256


_IMAGE = None


def load_image():
    global _IMAGE
    if _IMAGE is None:
        sys.path.insert(0, str(Path(__file__).resolve().parent))
        from cif_original_oracle import PEImage
        _IMAGE = PEImage.parse_and_map(GAME_EXE)
    return _IMAGE


def region_va(index):
    return REGION_BASE + index * REGION_STEP


@dataclass
class Stub:
    """A recording replacement for a callee: `args` stack dwords are logged (after ecx when `this`), `cleanup` bytes are popped
    on return (stdcall / thiscall callee cleanup), `result` goes in eax."""
    name: object
    args: int = 0
    this: bool = False
    cleanup: int = 0
    result: int = 0
    results: list = None      # return values in call order (the last one repeats); overrides `result`
    silent: bool = False      # not logged (GetTickCount)
    out: int = None           # a dword the callee stores through its first argument
    deref: tuple = None       # (argument index, nbytes): the bytes behind that pointer argument are appended to the log entry


@dataclass
class Result:
    eax: int
    cleanup: int              # bytes the function itself popped after the return address (ret N)
    memory: dict              # name -> bytes read back after the run
    calls: list               # (name, [ecx], arg0, ...) of every stub entered, in order
    executed: set = field(default_factory=set)   # addresses of the executed instructions of the function under test


class Original:
    """One run of one function. `image_patches` is [(va, bytes)] written over the image before the run (globals, tables);
    `regions` is {name: (va, bytes)} of memory outside the image; `read` is {name: (va, length)} to read back."""

    def __init__(self, image_patches=(), regions=None, stubs=None, iat_slots=None):
        pe = load_image()
        self.pe = pe
        self.uc = unicorn.Uc(unicorn.UC_ARCH_X86, unicorn.UC_MODE_32)
        uc = self.uc
        size = (pe.size_of_image + 0xfff) & ~0xfff
        uc.mem_map(pe.image_base, size)
        uc.mem_write(pe.image_base, pe.image)
        for va, data in image_patches:
            uc.mem_write(va, bytes(data))
        self.regions = regions or {}
        for va, data in self.regions.values():
            uc.mem_map(va, (len(data) + 0xfff) & ~0xfff)
            uc.mem_write(va, bytes(data))
        uc.mem_map(STACK_BASE, STACK_SIZE)
        uc.mem_map(STOP & ~0xfff, 0x1000)
        uc.mem_write(STOP, b'\x90' * 16)
        # Stubs: address -> Stub. An import called through [slot] gets a fake entry address written into the slot.
        self.stubs = {}
        self._used = {}
        self.calls = []
        uc.mem_map(STUB_BASE, 0x1000)
        uc.mem_write(STUB_BASE, b'\x90' * 0x1000)
        for va, stub in (stubs or {}).items():
            self.stubs[va] = stub
            uc.hook_add(unicorn.UC_HOOK_CODE, self._stub_hook, begin=va, end=va)
        for i, (slot, stub) in enumerate((iat_slots or {}).items()):
            entry = STUB_BASE + 0x10 * (i + 1)
            uc.mem_write(slot, struct.pack('<I', entry))
            self.stubs[entry] = stub
            uc.hook_add(unicorn.UC_HOOK_CODE, self._stub_hook, begin=entry, end=entry)
        self.executed = set()
        self._r = {n: getattr(x, 'UC_X86_REG_' + n) for n in ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI', 'EBP', 'ESP', 'EIP')}

    def _stub_hook(self, uc, address, _size, _user):
        stub = self.stubs[address]
        esp = uc.reg_read(self._r['ESP'])
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]
        entry = [stub.name]
        if stub.this:
            entry.append(uc.reg_read(self._r['ECX']))
        entry.extend(struct.unpack('<%dI' % stub.args, uc.mem_read(esp + 4, 4 * stub.args)) if stub.args else ())
        if stub.deref is not None:
            index, nbytes = stub.deref
            pointer = entry[-stub.args + index] if stub.args else 0
            entry.append(bytes(uc.mem_read(pointer, nbytes)))
        if stub.out is not None:
            uc.mem_write(struct.unpack('<I', uc.mem_read(esp + 4, 4))[0], struct.pack('<I', stub.out))
        if not stub.silent:
            self.calls.append(tuple(entry))
        result = stub.result
        if stub.results:
            used = self._used.get(address, 0)
            result = stub.results[min(used, len(stub.results) - 1)]
            self._used[address] = used + 1
        uc.reg_write(self._r['EAX'], result)
        uc.reg_write(self._r['ESP'], esp + 4 + stub.cleanup)
        uc.reg_write(self._r['EIP'], ret)

    def _count(self, _uc, address, _size, _user):
        self.executed.add(address)

    def run(self, va, body_size, *, ecx=0x33333333, stack_args=(), read=None, limit=200000):
        uc, r = self.uc, self._r
        esp = STACK_BASE + STACK_SIZE - 0x100
        uc.mem_write(STACK_BASE, b'\x71' * STACK_SIZE)
        frame = struct.pack('<%dI' % (len(stack_args) + 1), STOP, *stack_args)
        sp = esp - len(frame)
        uc.mem_write(sp, frame)
        for name, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=ecx, EDX=0x44444444, ESI=0x55555555,
                                EDI=0x66666666, EBP=0x77777777).items():
            uc.reg_write(r[name], value)
        uc.reg_write(r['ESP'], sp)
        uc.hook_add(unicorn.UC_HOOK_CODE, self._count, begin=va, end=va + body_size - 1)
        uc.emu_start(va, STOP, count=limit)
        if uc.reg_read(r['EIP']) != STOP:
            raise RuntimeError('original did not return (instruction limit?) at 0x%x' % uc.reg_read(r['EIP']))
        memory = {name: bytes(uc.mem_read(a, n)) for name, (a, n) in (read or {}).items()}
        return Result(eax=uc.reg_read(r['EAX']), cleanup=uc.reg_read(r['ESP']) - sp - 4, memory=memory,
                      calls=self.calls, executed=self.executed)


def instruction_addresses(va, size):
    """The addresses of the instructions in [va, va+size), by linear disassembly (functions without data in the body)."""
    import capstone
    pe = load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    off = va - pe.image_base
    return {i.address for i in md.disasm(pe.image[off:off + size], va)}
