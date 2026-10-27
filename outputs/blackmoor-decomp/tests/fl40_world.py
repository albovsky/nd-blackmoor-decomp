"""FL-40: the shared world of the oracle, the differential test and the mutation check for the translated rows of src/original_methods_fl40.c.

A scenario is a seed. From the seed alone (and the row's own code) the world builds: the registers and stack arguments of the call, the writable globals the
function names (patched over the image), and the content of every other page of the 32-bit address space (filled lazily, page by page, from a mixture of
zero, small, magic, pointer-into-the-regions and random dwords; the mixture is one of five styles chosen by the seed). Every callee is a recording stub:
what it returns and which bytes it stores through its pointer arguments or through `this` come from the same seed, in call order, so the original bytes
(Unicorn) and the translation (ctypes, `Mem` below) see exactly the same world. Nothing inside a function under test is patched.

  run_original(row, seed)  runs ONLY the original bytes under Unicorn; returns a Trace.
  run_native(lib, row, seed)  runs the translated C `m<va>_lifted` over the same world; returns a Trace.

A Trace holds the final registers (callee-saved ones included), every write of the function in order (address, size, value; the stack included), the ordered
stub calls (callee, ecx, eax edx ebx esi edi ebp as the call sees them, six stack dwords, what the stub returned and stored) and, for the original, the executed instructions and the (instruction, next
instruction) pairs. `Trace.digest()` hashes everything that is compared.
"""
from __future__ import annotations

import ctypes
import hashlib
from pathlib import Path
import random
import struct
import sys

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(PROJECT / 'scripts'))
import original_differential as od

PAGE = 0x1000
IMAGE_BASE = 0x400000
STACK_BASE, STACK_SIZE = od.STACK_BASE, od.STACK_SIZE
STOP = od.STOP
SP = od.STACK_BASE + od.STACK_SIZE - 0x100 - 4 * 9      # esp at the call: the return address, then ARGS = 8 argument dwords
REGION_BASE, REGION_STEP, REGIONS = 0x20000000, 0x10000, 8
TIB, GDT = 0x7d000000, 0x7d010000        # the thread information block behind fs, and the descriptor table that puts it there
STUB_BASE = od.STUB_BASE
FPSLOT = STUB_BASE + 0x800          # FL-51: where the stub of a callee that returns a value in st(0) leaves the double
FCW = 0x27f                          # the x87 control word of the Win32 process (53-bit precision, round to nearest, every exception masked)
DATA_START = 0x537000          # first writable page of .data (the .rdata ends before it): globals below it are constants and tables
INSTRUCTION_LIMIT = 200000
ARGS = 8                       # stack dwords above the return address
LOGGED = 6                     # stack dwords of a stub call that are logged
REG_OVERRIDE = 0xffff0000        # FL-54: an override at REG_OVERRIDE + 4 * index (eax ecx edx ebx esi edi ebp) sets that start register, e.g. an odd `this` (a seed's own `this` is aligned)
REG_NAMES = ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi', 'ebp')
SENTINELS = dict(eax=0x11111111, ebx=0x22222222, edx=0x44444444, esi=0x55555555, edi=0x66666666, ebp=0x77777777)


class Fault(Exception):
    pass


def magic_of(row):
    return row['magic']


HI_SEEDS = 7000        # seeds from 7000 to TGT_SEEDS - 1 use style 5 only
TGT_SEEDS = 20000      # seeds from here on use style 6 only (FL-42)
LONG_SEEDS = 60000     # seeds from here on fill 15 of 16 pages with bytes that are all nonzero (FL-44): a string scan runs on for tens of thousands of bytes, so a length test against 40000 goes the long way
FLOAT_SEEDS = 100000    # seeds from here on (FL-51) fill the pages with words that are IEEE floats and callees that return a value in st(0) give floats: only rows that use the x87 unit are searched with them
STUB_SEEDS = 40000     # seeds from here on also give the callees' return values and outputs the boundary-value styles 5 and 6 (FL-44): a value that flows from a callee can have a zero low half


def style_of(seed):
    return 7 if seed >= FLOAT_SEEDS else 6 if seed >= TGT_SEEDS else 5 if seed >= HI_SEEDS else seed % 5


def mixture(rng, style, magic):
    """One dword. The five styles weigh the sources differently so that some scenarios are mostly zeros and pointers, others mostly large random values."""
    weights = [(28, 'zero'), (10, 'one'), (10, 'small'), (5, 'neg'), (10, 'magic'), (17, 'ptr'), (14, 'rand')]
    if style == 1:
        weights = [(55, 'zero'), (5, 'one'), (5, 'small'), (2, 'neg'), (8, 'magic'), (20, 'ptr'), (5, 'rand')]
    elif style == 2:
        weights = [(8, 'zero'), (12, 'one'), (15, 'small'), (10, 'neg'), (20, 'magic'), (15, 'ptr'), (20, 'rand')]
    elif style == 3:
        weights = [(15, 'zero'), (25, 'one'), (25, 'small'), (3, 'neg'), (12, 'magic'), (15, 'ptr'), (5, 'rand')]
    elif style == 4:
        weights = [(40, 'zero'), (3, 'one'), (3, 'small'), (3, 'neg'), (36, 'magic'), (10, 'ptr'), (5, 'rand')]
    elif style == 5:       # style 5 (seeds from HI_SEEDS on): values whose low half is small or zero and whose upper bytes are not, so that a narrower read of a 32-bit value differs
        weights = [(12, 'zero'), (8, 'one'), (8, 'small'), (28, 'hi16'), (14, 'hi8'), (10, 'ptr'), (10, 'rand'), (10, 'magic')]
    elif style == 6:       # style 6 (seeds from TGT_SEEDS on): a constant of the function or a boundary value, then decorated in the half or byte a narrower access would miss
        weights = [(10, 'zero'), (8, 'one'), (52, 'tgt'), (10, 'ptr'), (10, 'rand'), (10, 'hi16')]
    elif style == 7:       # style 7 (seeds from FLOAT_SEEDS on, FL-51): words that are the bits of a float, mostly small and ordinary ones
        weights = [(6, 'zero'), (46, 'f32'), (8, 'one'), (8, 'small'), (8, 'ptr'), (10, 'rand'), (8, 'magic'), (6, 'f32wild')]
    total = sum(w for w, _ in weights)
    pick = rng.randrange(total)
    for w, kind in weights:
        if pick < w:
            break
        pick -= w
    if kind in ('f32', 'f32wild'):
        return float_bits(rng, kind == 'f32wild')
    if kind == 'zero':
        return 0
    if kind == 'one':
        return 1
    if kind == 'small':
        return rng.randrange(2, 0x41)
    if kind == 'hi16':
        return (1 + rng.randrange(0xffff)) << 16 | rng.choice((0, 0, 0, 1))
    if kind == 'hi8':
        return (1 + rng.randrange(0xff)) << 8 | rng.choice((0, 0, 1))
    if kind == 'tgt':
        base = rng.choice(list(magic or ()) + [0, 1, 2, 3, 4, 8, 0x10, 0x20, 0x7f, 0x80, 0xff, 0x100, 0x7fff, 0x8000, 0xffff, 0x10000])
        base = (base + rng.choice((0, 0, 0, 0, 1, -1))) & 0xffffffff
        deco = rng.randrange(20)
        if deco < 4:
            return base
        if deco < 11:
            return base & 0xffff | (1 + rng.randrange(0xffff)) << 16
        if deco < 14:
            return base & 0xff | (1 + rng.randrange(0xff)) << 8
        if deco < 17:
            return base | 0x80000000
        return (-base) & 0xffffffff
    if kind == 'neg':
        return (-rng.randrange(1, 0x41)) & 0xffffffff
    if kind == 'magic' and magic:
        base = rng.choice(magic)
        return (base + rng.choice((0, 0, 1, -1, 2, -2, 4, -4))) & 0xffffffff
    if kind == 'ptr':
        return REGION_BASE + rng.randrange(REGIONS) * REGION_STEP + rng.randrange(0, 0x2000, 4)
    return rng.getrandbits(32)


def float_bits(rng, wild=False):
    """The bits of a float32 (FL-51): usually a small ordinary value, so that sums, products and compares of two of them come out in all the ways; sometimes a boundary value."""
    k = rng.randrange(12)
    if wild:
        v = rng.choice((float('inf'), -float('inf'), 1e-40, -1e-40, 3.4e38, 1e30, 1e-30, 16777216.0, 16777217.0, 0.1))
    elif k == 0:
        v = 0.0
    elif k < 4:
        v = float(rng.randrange(-6, 7))
    elif k < 6:
        v = rng.choice((0.5, 0.25, 1.5, 2.5, 10.0, 100.0, 255.0, 360.0, 3.14159265, 0.017453292, 57.29578, 0.001, 1000.0))
    else:
        v = rng.uniform(-200.0, 200.0)
    if rng.random() < 0.04:
        v = -v
    return struct.unpack('<I', struct.pack('<f', v))[0]


def fret_bits(rng):
    """The double that a callee leaves in st(0) (FL-51): drawn after the callee's other draws, only for callees that return a value in st(0)."""
    k = rng.randrange(10)
    if k == 0:
        v = 0.0
    elif k < 3:
        v = float(rng.randrange(-8, 9))
    elif k == 3:
        v = rng.choice((0.5, 1.0, 2.0, 0.25, 100.0, -1.0, 3.14159, 1e-9, 1e9))
    elif k < 7:
        v = rng.uniform(-100.0, 100.0)
    elif k == 7:
        v = rng.uniform(-1e6, 1e6)
    elif k == 8:
        v = struct.unpack('<f', struct.pack('<I', rng.getrandbits(32)))[0]
    else:
        return rng.getrandbits(64) & ~(1 << 62) if rng.random() < 0.5 else rng.getrandbits(64)
    if v != v:
        v = 0.0
    return struct.unpack('<Q', struct.pack('<d', v))[0]


def page_fill(seed, magic, page):
    rng = random.Random(seed * 1000003 + page)
    style = style_of(seed)
    if LONG_SEEDS <= seed < FLOAT_SEEDS and rng.randrange(16):
        return bytes(1 + rng.randrange(255) for _ in range(PAGE))
    words = [mixture(rng, style, magic) for _ in range(PAGE // 4)]
    return struct.pack('<%dI' % (PAGE // 4), *words)


def apply_register_overrides(regs, overrides):
    for address, size_, value in overrides:
        if address >= REG_OVERRIDE:
            regs[REG_NAMES[(address - REG_OVERRIDE) // 4]] = value & 0xffffffff

STUB_WR = 0xffd00000       # FL-68 (as FL-48 in fl41_world): overrides at STUB_WR + 16*k (target address) and + 4 (value) make the k-th callee stub also store that dword; both sides honour it
# FL-72: a row may list callees that never return (`row['noreturn']`, tests/fl72_noreturn.json: AfxEndThread ends the thread): the run of both sides ends at such a call, after the callee's record, with esp as the call left it
NORETURN_ESP = 0xfffffff0   # the host hands this esp back to the translation for such a call (the macro `FL40_CALL` then leaves the function)
STUB_OVR = 0xfff00000      # FL-68 (as FL-45 in fl41_world): an override at STUB_OVR + 16*k + {0, 4, 8} sets eax, ecx, edx that the k-th callee stub returns; both sides honour it


def split_stub_overrides(overrides):
    """(memory overrides, {(k, register index): value}) from a scenario's override list"""
    mem, stub = [], {}
    for a, n, v in overrides:
        if STUB_OVR <= a < STUB_OVR + 0x10000:
            stub[((a - STUB_OVR) // 16, ((a - STUB_OVR) % 16) // 4)] = v & 0xffffffff
        elif STUB_WR <= a < STUB_WR + 0x10000:
            stub[((a - STUB_WR) // 16, 8 + ((a - STUB_WR) % 16) // 4)] = v & 0xffffffff
        else:
            mem.append((a, n, v))
    return mem, stub


def apply_stub_overrides(stub, k, eax, ecx_out, edx):
    return stub.get((k, 0), eax), stub.get((k, 1), ecx_out), stub.get((k, 2), edx)


def extra_stub_writes(stub, k):
    """the dword the scenario makes the k-th callee store, as a stub write"""
    if (k, 8) in stub and (k, 9) in stub:
        return [(stub[(k, 8)], struct.pack('<I', stub[(k, 9)]))]
    return []



def initial_state(row, seed):
    """(registers dict, stack arguments, image patches [(address, bytes)]) of the scenario."""
    rng = random.Random(seed * 7919 + row['va'])
    style = style_of(seed)
    magic = row['magic']
    this = REGION_BASE + rng.choice((0, 0, 0, 0x40, 0x100, 0x480, 0x1000))
    r = rng.random()
    if r < 0.06:
        this = rng.choice((0, 1, 0x10, 0x100))
    elif r < 0.12:
        this = rng.getrandbits(32)
    regs = dict(SENTINELS, ecx=this)
    args = [mixture(rng, style, magic) for _ in range(ARGS)]
    patches = []
    for address in row['globals']:
        if rng.random() < 0.85:
            patches.append((address, struct.pack('<I', mixture(rng, style, magic))))
        if rng.random() < 0.3:
            patches.append((address + 4, struct.pack('<I', mixture(rng, style, magic))))
    return regs, args, patches


def stub_effect(rng, magic, ecx, args, seed=0):
    """What a callee does in this world: (eax, ecx, edx, [(address, bytes)]). The draws are in call order, so both sides agree."""
    style = rng.randrange(5)
    if seed >= STUB_SEEDS:
        style = 5 + style % 2
    eax = mixture(rng, style, magic)
    ecx_out = mixture(rng, style, magic)         # a callee clobbers ecx and edx (the caller-saved registers); ebx, esi, edi and ebp are kept
    edx = mixture(rng, style, magic)
    writes = []
    for k in range(3):
        if rng.random() < 0.4 and 0x1000 <= args[k] < 0xffe00000:
            writes.append((args[k] & 0xffffffff, bytes(rng.getrandbits(8) if rng.random() < 0.6 else 0 for _ in range(rng.randrange(1, 33)))))
    if rng.random() < 0.2 and 0x1000 <= ecx < 0xffe00000:
        writes.append(((ecx + 4 * rng.randrange(0, 16)) & 0xffffffff, struct.pack('<I', mixture(rng, style, magic))))
    return eax, ecx_out, edx, writes


class Trace:
    def __init__(self):
        self.regs = {}
        self.writes = []
        self.calls = []
        self.executed = set()
        self.noreturn = False
        self.steps = 0          # FL-46: instructions of the function body the original ran (the step budget of a hang kill)
        self.edges = set()
        self.fault = None

    def digest(self):
        h = hashlib.sha256()
        h.update(repr(sorted(self.regs.items())).encode())
        h.update(repr(self.writes).encode())
        h.update(repr(self.calls).encode())
        return h.hexdigest()


# ---- the original, under Unicorn ----------------------------------------------------------------------------------------------------


def run_original(row, seed, overrides=(), observe=False, setup=None, probes=None, watch=None):
    import unicorn
    from unicorn import x86_const as X
    pe = od.load_image()
    va, size = row['va'], row['body']
    regs, args, patches = initial_state(row, seed)
    overrides, stub_ovr = split_stub_overrides(overrides)
    apply_register_overrides(regs, overrides)
    magic = row['magic']
    uc = unicorn.Uc(unicorn.UC_ARCH_X86, unicorn.UC_MODE_32)
    image = bytearray(pe.image)
    for address, data in patches:
        image[address - IMAGE_BASE:address - IMAGE_BASE + len(data)] = data
    for address, size_, value in overrides:
        if address < REG_OVERRIDE and IMAGE_BASE <= address and address + size_ <= IMAGE_BASE + len(image):
            image[address - IMAGE_BASE:address - IMAGE_BASE + size_] = (value & ((1 << (8 * size_)) - 1)).to_bytes(size_, 'little')
    stubs = {callee: (callee, cleanup) for callee, cleanup in row['callees'].items()}
    fpret = row.get('fpret') or {}        # FL-51: callees that leave a value in st(0) (+1) or take one off it (-1): the stub is a real instruction there
    for callee, net in fpret.items():
        cleanup = row['callees'][callee]
        code = (b'\xdd\x05' + struct.pack('<I', FPSLOT) if net > 0 else b'\xdd\xd8') + (b'\xc2' + struct.pack('<H', cleanup) if cleanup else b'\xc3')
        image[callee - IMAGE_BASE:callee - IMAGE_BASE + len(code)] = code
    for k, (slot, cleanup) in enumerate(sorted(row['imports'].items())):
        entry = STUB_BASE + 0x10 * (k + 1)
        image[slot - IMAGE_BASE:slot - IMAGE_BASE + 4] = struct.pack('<I', entry)
        stubs[entry] = (slot, cleanup)
    uc.mem_map(pe.image_base, (pe.size_of_image + 0xfff) & ~0xfff)
    uc.mem_write(pe.image_base, bytes(image))
    uc.mem_map(STUB_BASE, 0x1000)
    uc.mem_write(STUB_BASE, b'\x90' * 0x1000)
    uc.mem_map(STACK_BASE, STACK_SIZE)
    uc.mem_write(STACK_BASE, b'\x71' * STACK_SIZE)
    uc.mem_map(STOP & ~0xfff, 0x1000)
    uc.mem_write(STOP, b'\x90' * 16)
    if row.get('fpu'):
        uc.reg_write(X.UC_X86_REG_FPCW, FCW)
    trace = Trace()
    mapped = set()
    if row['fs']:
        uc.mem_map(TIB, PAGE)
        uc.mem_write(TIB, page_fill(seed, magic, TIB >> 12))
        mapped.add(TIB >> 12)
        uc.mem_map(GDT, PAGE)

        def seg(base, limit, access, flags):
            return struct.pack('<HHBBBB', limit & 0xffff, base & 0xffff, (base >> 16) & 0xff, access, ((limit >> 16) & 0xf) | (flags << 4), (base >> 24) & 0xff)
        uc.mem_write(GDT, bytes(8) + seg(0, 0xfffff, 0x9b, 0xc) + seg(0, 0xfffff, 0x93, 0xc) + seg(TIB, 0xfff, 0x93, 0x4))
        uc.reg_write(X.UC_X86_REG_GDTR, (0, GDT, 0xfff, 0))
        uc.reg_write(X.UC_X86_REG_CS, 0x08)
        for reg in (X.UC_X86_REG_SS, X.UC_X86_REG_DS, X.UC_X86_REG_ES, X.UC_X86_REG_GS):
            uc.reg_write(reg, 0x10)
        uc.reg_write(X.UC_X86_REG_FS, 0x18)

    def ensure(address):
        page = address >> 12
        if page in mapped:
            return
        mapped.add(page)
        try:
            uc.mem_map(page << 12, PAGE)
        except unicorn.UcError:
            return
        uc.mem_write(page << 12, page_fill(seed, magic, page))

    def unmapped(uc_, access, address, size_, value, user):
        if address >= 0xfff00000:
            return False
        page = address >> 12
        for p in (page, (address + size_ - 1) >> 12):
            if p not in mapped:
                mapped.add(p)
                uc.mem_map(p << 12, PAGE)
                uc.mem_write(p << 12, page_fill(seed, magic, p))
        return True

    uc.hook_add(unicorn.UC_HOOK_MEM_READ_UNMAPPED | unicorn.UC_HOOK_MEM_WRITE_UNMAPPED | unicorn.UC_HOOK_MEM_FETCH_UNMAPPED, unmapped)
    def write_seen(uc_, access, address, size_, value, user):
        value &= (1 << (8 * size_)) - 1
        if size_ == 8:          # FL-51: a qword store of the x87 unit is logged as the two dwords the translation writes
            trace.writes.append((address, 4, value & 0xffffffff))
            trace.writes.append((address + 4, 4, value >> 32))
        else:
            trace.writes.append((address, size_, value))

    uc.hook_add(unicorn.UC_HOOK_MEM_WRITE, write_seen)
    prev = [None]

    def count(uc_, address, size_, user):
        trace.executed.add(address)
        trace.steps += 1
        if prev[0] is not None:
            trace.edges.add((prev[0], address))
        prev[0] = address

    uc.hook_add(unicorn.UC_HOOK_CODE, count, begin=va, end=va + size - 1)
    if observe:
        trace.reads, trace.events, trace.read_pcs = [], [], []          # read_pcs[k] is the address of the instruction that made reads[k]
        def seen_read(uc_, access, address, size_, value, user):
            ensure(address)
            ensure(address + size_ - 1)
            trace.reads.append((address, size_, int.from_bytes(bytes(uc.mem_read(address, size_)), 'little'), len(trace.writes)))
            trace.read_pcs.append(uc.reg_read(X.UC_X86_REG_EIP))

        def seen_cmp(uc_, a, size_, decode):
            trace.events.append(decode(uc, a, len(trace.writes), ensure))
        uc.hook_add(unicorn.UC_HOOK_MEM_READ, seen_read)
        for address, decode in cmp_decoders(row).items():
            uc.hook_add(unicorn.UC_HOOK_CODE, seen_cmp, decode, begin=address, end=address)
    stub_rng = random.Random(seed * 104729 + 13)

    entered = []

    def stub(uc_, address, size_, user):
        if address == va and not entered:        # FL-69 (as FL-68 in the fl41 world): a recursive row lists itself as a callee; its first instruction is the row, only a call to the entry is a stub call
            entered.append(1)
            return
        play(address, *stubs[address])

    def play(address, ident, cleanup):
        esp = uc.reg_read(X.UC_X86_REG_ESP)
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        held = tuple(uc.reg_read(getattr(X, 'UC_X86_REG_' + n)) for n in ('EAX', 'EDX', 'EBX', 'ESI', 'EDI', 'EBP'))
        words = struct.unpack('<%dI' % LOGGED, uc.mem_read(esp + 4, 4 * LOGGED))
        eax, ecx_out, edx, writes = stub_effect(stub_rng, magic, ecx, words, seed)
        eax, ecx_out, edx = apply_stub_overrides(stub_ovr, len(trace.calls), eax, ecx_out, edx)
        writes = writes + extra_stub_writes(stub_ovr, len(trace.calls))
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]            # FL-68: the callee returns to the address it was called from, even when a store of its own lands on that stack slot
        for at, data in writes:
            ensure(at)
            ensure(at + len(data) - 1)
            uc.mem_write(at, data)
        net = fpret.get(address, 0)
        if net > 0:
            bits = fret_bits(stub_rng)
            uc.mem_write(FPSLOT, struct.pack('<Q', bits))
            trace.calls.append((ident, ecx, held, words, eax, ecx_out, edx, writes, bits))
        else:
            trace.calls.append((ident, ecx, held, words, eax, ecx_out, edx, writes))
        uc.reg_write(X.UC_X86_REG_EAX, eax)
        uc.reg_write(X.UC_X86_REG_ECX, ecx_out)
        uc.reg_write(X.UC_X86_REG_EDX, edx)
        if address in row.get('noreturn', ()):
            trace.noreturn = True
            uc.emu_stop()
            return
        if net:
            return              # the instructions at the callee's address (see above) push or pop st(0) and return
        uc.reg_write(X.UC_X86_REG_ESP, esp + 4 + cleanup)
        uc.reg_write(X.UC_X86_REG_EIP, ret)

    for entry in stubs:
        uc.hook_add(unicorn.UC_HOOK_CODE, stub, begin=entry, end=entry)

    def site_hook(uc_, address, size_, user):
        """FL-69 (as FL-58 in the fl41 world): a call through a register or a pointer is a stub call on both sides (the translation cannot run the real code at the target, and a wild pointer in the original runs garbage)"""
        target_of, after, cleanup = user
        target = target_of()
        if target is not None:
            target &= 0xffffffff
        if target is None or target >= 0xfff00000:          # the access, or the fetch at the target, faults in the original (0xffffffff is also the translation's divide-error marker)
            trace.fault = 'access in a call target'
            uc.emu_stop()
            return
        esp = (uc.reg_read(X.UC_X86_REG_ESP) - 4) & 0xffffffff
        uc.mem_write(esp, struct.pack('<I', after))
        trace.writes.append((esp, 4, after))        # the push of the return address, which a real call would log
        uc.reg_write(X.UC_X86_REG_ESP, esp)
        play(target, target, cleanup)

    if row.get('sites'):
        import capstone
        from capstone import x86_const as CX
        md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        md.detail = True
        regmap = {CX.X86_REG_EAX: X.UC_X86_REG_EAX, CX.X86_REG_ECX: X.UC_X86_REG_ECX, CX.X86_REG_EDX: X.UC_X86_REG_EDX, CX.X86_REG_EBX: X.UC_X86_REG_EBX,
                  CX.X86_REG_ESP: X.UC_X86_REG_ESP, CX.X86_REG_EBP: X.UC_X86_REG_EBP, CX.X86_REG_ESI: X.UC_X86_REG_ESI, CX.X86_REG_EDI: X.UC_X86_REG_EDI}

        def target_reader(op):
            if op.type == CX.X86_OP_REG:
                return lambda: uc.reg_read(regmap[op.reg])

            def read():
                m = op.mem
                a = m.disp
                if m.base:
                    a += uc.reg_read(regmap[m.base])
                if m.index:
                    a += uc.reg_read(regmap[m.index]) * m.scale
                if m.segment == CX.X86_REG_FS:
                    a += TIB
                a &= 0xffffffff
                if a + 3 >= 0xfff00000:
                    return None                                  # the access faults
                ensure(a)
                ensure(a + 3)
                return struct.unpack('<I', bytes(uc.mem_read(a, 4)))[0]
            return read
        for site, cleanup in row['sites'].items():
            ins = next(md.disasm(pe.image[site - pe.image_base:site - pe.image_base + 16], site))
            uc.hook_add(unicorn.UC_HOOK_CODE, site_hook, (target_reader(ins.operands[0]), site + ins.size, cleanup), begin=site, end=site)
    for name in ('eax', 'ebx', 'ecx', 'edx', 'esi', 'edi', 'ebp'):
        uc.reg_write(getattr(X, 'UC_X86_REG_' + name.upper()), regs[name])
    sp = STACK_BASE + STACK_SIZE - 0x100 - 4 * (ARGS + 1)
    uc.mem_write(sp, struct.pack('<%dI' % (ARGS + 1), STOP, *args))
    uc.reg_write(X.UC_X86_REG_ESP, sp)
    uc.reg_write(X.UC_X86_REG_EFLAGS, 2)
    for address, size_, value in overrides:
        if address >= REG_OVERRIDE:
            continue
        if not (IMAGE_BASE <= address and address + size_ <= IMAGE_BASE + len(image)):
            ensure(address)
            ensure(address + size_ - 1)
            uc.mem_write(address, (value & ((1 << (8 * size_)) - 1)).to_bytes(size_, 'little'))
    if setup:
        setup(uc)       # FL-44: the range test hooks the emulator here
    if watch:
        watch(uc, ensure, trace, sp)       # FL-61: the concolic generator hooks the run here (it sees the emulator, the page filler, the trace being built and the initial esp)
    for address, fn in (probes or {}).items():             # FL-49: a callback at an instruction, called as fn(uc, ensure, write count) just before it runs
        uc.hook_add(unicorn.UC_HOOK_CODE, lambda uc_, a, s, u, fn=fn: fn(uc, ensure, len(trace.writes)), begin=address, end=address)
    try:
        uc.emu_start(va, STOP, count=INSTRUCTION_LIMIT)
    except unicorn.UcError as ex:
        trace.fault = str(ex)
        return trace
    if uc.reg_read(X.UC_X86_REG_EIP) != STOP and not trace.noreturn:
        trace.fault = 'instruction limit'
        return trace
    trace.regs = {name: uc.reg_read(getattr(X, 'UC_X86_REG_' + name.upper())) for name in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')}
    if row.get('fpu'):
        sw = uc.reg_read(X.UC_X86_REG_FPSW)
        top = (sw >> 11) & 7
        regs80 = []
        for k in range((8 - top) & 7):
            mant, se = uc.reg_read(getattr(X, 'UC_X86_REG_FP%d' % ((top + k) & 7)))
            regs80.append((mant, se))
        trace.regs['fpu'] = (sw, uc.reg_read(X.UC_X86_REG_FPCW), tuple(regs80))
    return trace


# ---- the translation ----------------------------------------------------------------------------------------------------------------


class Regs(ctypes.Structure):
    _fields_ = [(n, ctypes.c_uint32) for n in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')]


RD = ctypes.CFUNCTYPE(ctypes.c_uint32, ctypes.c_void_p, ctypes.c_uint32, ctypes.c_int)
WR = ctypes.CFUNCTYPE(None, ctypes.c_void_p, ctypes.c_uint32, ctypes.c_int, ctypes.c_uint32)
CALL = ctypes.CFUNCTYPE(None, ctypes.c_void_p, ctypes.c_uint32, ctypes.POINTER(Regs))


FRET = ctypes.CFUNCTYPE(ctypes.c_uint64, ctypes.c_void_p)


class Fpu(ctypes.Structure):
    """Fl40Fpu of src/original_methods_fl40_x87.h"""
    _fields_ = [('st', ctypes.c_longdouble * 8), ('sw', ctypes.c_uint16), ('cw', ctypes.c_uint16), ('valid', ctypes.c_uint8 * 8)]


class Host(ctypes.Structure):
    _fields_ = [('ctx', ctypes.c_void_p), ('rd', RD), ('wr', WR), ('call', CALL), ('fret', FRET), ('fpu', ctypes.POINTER(Fpu))]


class Mem:
    """The 32-bit address space of the translation: the patched image, the stack, and the lazily filled pages."""

    def __init__(self, seed, magic, patches):
        pe = od.load_image()
        self.image = bytearray(pe.image)
        for address, data in patches:
            self.image[address - IMAGE_BASE:address - IMAGE_BASE + len(data)] = data
        self.image_end = IMAGE_BASE + len(self.image)
        self.stack = bytearray(b'\x71' * STACK_SIZE)
        self.pages = {STUB_BASE >> 12: bytearray(b'\x90' * PAGE), STOP >> 12: bytearray(b'\x90' * 16 + bytes(PAGE - 16))}      # the pages the original run maps for the call stubs and the return address (FL-42: a pointer into them reads the same)
        self.seed, self.magic = seed, magic

    def _cell(self, address, size):
        if IMAGE_BASE <= address and address + size <= self.image_end:
            return self.image, address - IMAGE_BASE
        if STACK_BASE <= address and address + size <= STACK_BASE + STACK_SIZE:
            return self.stack, address - STACK_BASE
        if address >= 0xfff00000:
            raise Fault('access at 0x%x' % address)
        if (address >> 12) != ((address + size - 1) >> 12):
            raise Fault('access across pages at 0x%x' % address)
        page = address >> 12
        if page not in self.pages:
            self.pages[page] = bytearray(page_fill(self.seed, self.magic, page))
        return self.pages[page], address & 0xfff

    def read(self, address, size):
        address &= 0xffffffff
        if (address >> 12) != ((address + size - 1) >> 12) and not (IMAGE_BASE <= address and address + size <= self.image_end):
            return int.from_bytes(bytes(self.read(address + k, 1) for k in range(size)), 'little')
        buf, off = self._cell(address, size)
        return int.from_bytes(buf[off:off + size], 'little')

    def write(self, address, size, value):
        address &= 0xffffffff
        value &= (1 << (8 * size)) - 1
        data = value.to_bytes(size, 'little')
        if (address >> 12) != ((address + size - 1) >> 12) and not (IMAGE_BASE <= address and address + size <= self.image_end):
            for k in range(size):
                self.write(address + k, 1, data[k])
            return
        buf, off = self._cell(address, size)
        buf[off:off + size] = data

    def write_bytes(self, address, data):
        for k, b in enumerate(data):
            self.write(address + k, 1, b)


def run_native(lib, row, seed, overrides=()):
    va = row['va']
    regs, args, patches = initial_state(row, seed)
    overrides, stub_ovr = split_stub_overrides(overrides)
    apply_register_overrides(regs, overrides)
    magic = row['magic']
    mem = Mem(seed, magic, patches)
    trace = Trace()
    stub_rng = random.Random(seed * 104729 + 13)

    def rd(ctx, address, size):
        try:
            return mem.read(address, size)
        except Fault as ex:
            trace.fault = str(ex)
            return 0

    def wr(ctx, address, size, value):
        try:
            mem.write(address, size, value)
        except Fault as ex:
            trace.fault = str(ex)
            return
        trace.writes.append((address, size, value & ((1 << (8 * size)) - 1)))

    def call(ctx, callee, rr):
        esp = rr.contents.esp
        ecx = rr.contents.ecx
        words = tuple(mem.read(esp + 4 + 4 * k, 4) for k in range(LOGGED))
        if callee == 0xffffffff:
            trace.fault = 'divide error'
            return
        eax, ecx_out, edx, writes = stub_effect(stub_rng, magic, ecx, words, seed)
        eax, ecx_out, edx = apply_stub_overrides(stub_ovr, len(trace.calls), eax, ecx_out, edx)
        writes = writes + extra_stub_writes(stub_ovr, len(trace.calls))
        for at, data in writes:
            mem.write_bytes(at, data)
        held = tuple(getattr(rr.contents, n) for n in ('eax', 'edx', 'ebx', 'esi', 'edi', 'ebp'))
        if fpret.get(callee, 0) > 0:
            fret_last[0] = fret_bits(stub_rng)
            trace.calls.append((callee, ecx, held, words, eax, ecx_out, edx, writes, fret_last[0]))
        else:
            trace.calls.append((callee, ecx, held, words, eax, ecx_out, edx, writes))
        rr.contents.eax = eax
        rr.contents.ecx = ecx_out
        rr.contents.edx = edx
        if callee in row.get('noreturn', ()):
            rr.contents.esp = NORETURN_ESP

    fpret = row.get('fpret') or {}
    fret_last = [0]
    fpu = None
    if row.get('fpu'):
        fpu = Fpu()
        fpu.cw = FCW
    host = Host(None, RD(rd), WR(wr), CALL(call), FRET(lambda ctx: fret_last[0]), ctypes.pointer(fpu) if fpu is not None else None)
    sp = STACK_BASE + STACK_SIZE - 0x100 - 4 * (ARGS + 1)
    for k, v in enumerate([STOP, *args]):
        mem.write(sp + 4 * k, 4, v)
    for address, size_, value in overrides:
        if address < REG_OVERRIDE:
            mem.write(address, size_, value)
    r = Regs(regs['eax'], regs['ecx'], regs['edx'], regs['ebx'], sp, regs['ebp'], regs['esi'], regs['edi'])
    getattr(lib, 'm%x_lifted' % va)(ctypes.byref(r), ctypes.byref(host))
    trace.regs = {n: getattr(r, n) for n in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')}
    if fpu is not None:
        top = (fpu.sw >> 11) & 7
        raw = ctypes.string_at(ctypes.addressof(fpu), 128)
        regs80 = []
        for k in range((8 - top) & 7):
            at = 16 * ((top + k) & 7)
            regs80.append((int.from_bytes(raw[at:at + 8], 'little'), int.from_bytes(raw[at + 8:at + 10], 'little')))
        trace.regs['fpu'] = (fpu.sw, fpu.cw, tuple(regs80))
    return trace


def build_library(directory, sources=None, extra=()):
    """Compiles src/original_methods_fl40.c (or `sources`) into a shared library under `directory`; returns the ctypes handle."""
    import subprocess
    out = Path(directory) / 'fl40.so'
    srcs = sources or [PROJECT / 'src/original_methods_fl40.c']
    cmd = ['cc', '-std=c11', '-O1', '-shared', '-fPIC', '-w', f'-I{PROJECT / "src"}', *map(str, srcs), *extra, '-o', str(out)]
    built = subprocess.run(cmd, capture_output=True, text=True)
    if built.returncode != 0:
        raise AssertionError(built.stderr[:4000])
    return ctypes.CDLL(str(out))


# ---- rows: what a row needs to know to run -------------------------------------------------------------------------------------------


def row_info(va, body, callees, imports=None, fs=False, sites=None):
    """The static facts of a row: its body size, its callees ({address: bytes the callee pops}), the immediates of its code (the magic values), and the writable globals it names."""
    import capstone
    from capstone import x86_const as X
    pe = od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = va - pe.image_base
    magic, globs, rets = set(), set(), set()
    fpu = False
    for i in md.disasm(pe.image[off:off + body], va):
        if i.mnemonic.startswith('f') and i.mnemonic != 'fs':
            fpu = True
        if i.mnemonic == 'ret':
            rets.add(i.operands[0].imm if i.operands else 0)
        for op in i.operands:
            if op.type == X.X86_OP_IMM:
                v = op.imm & 0xffffffff
                if IMAGE_BASE <= v < 0x700000:
                    if v >= DATA_START:
                        globs.add(v)
                elif v > 2:
                    magic.add(v)
                    magic.add(0x100 - v if v < 0x100 else v)
            elif op.type == X.X86_OP_MEM:
                d = op.mem.disp & 0xffffffff
                if IMAGE_BASE <= d < 0x700000 and d >= DATA_START:
                    globs.add(d)
                elif 0 < d < 0x10000 and not op.mem.base:
                    pass
                elif 2 < d < 0x2000:
                    magic.add(d)
    info = {'va': va, 'body': body, 'callees': {int(k): v for k, v in callees.items()}, 'imports': {int(k): v for k, v in (imports or {}).items()}, 'fs': bool(fs), 'ret': sorted(rets), 'magic': sorted(magic)[:24], 'globals': sorted(globs)[:16]}
    if sites:       # FL-69 (as FL-58 in the fl41 world): calls through a register or a pointer ({address: bytes the target pops}); both sides play them as stub calls
        info['sites'] = {int(a): int(n) for a, n in sites.items()}
    if fpu:         # FL-51: the row uses the x87 unit; the callees that leave a value in st(0) or take one off it (scripts/lift_function.py fpu_net)
        import lift_function as L
        info['fpu'] = True
        info['fpret'] = {t: n for t in info['callees'] for n in [L.fpu_net(t)] if n}
    return info


# ---- what the guided search watches: the compares of a function --------------------------------------------------------------------------

_CMP = {}


def cmp_decoders(row):
    """{address of a cmp/test: decode(uc, address, write count)} giving (address, bits, a, b, a_cell, b_cell) with the operand values as they are just before the instruction."""
    if row['va'] in _CMP:
        return _CMP[row['va']]
    import capstone
    from capstone import x86_const as X
    from unicorn import x86_const as UX
    pe = od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = row['va'] - pe.image_base
    full = {n: getattr(UX, 'UC_X86_REG_' + n.upper()) for n in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')}
    sub16 = {'ax': 'eax', 'cx': 'ecx', 'dx': 'edx', 'bx': 'ebx', 'sp': 'esp', 'bp': 'ebp', 'si': 'esi', 'di': 'edi'}
    sub8 = {'al': ('eax', 0), 'cl': ('ecx', 0), 'dl': ('edx', 0), 'bl': ('ebx', 0), 'ah': ('eax', 8), 'ch': ('ecx', 8), 'dh': ('edx', 8), 'bh': ('ebx', 8)}

    def reg_value(uc, name):
        if name in full:
            return uc.reg_read(full[name])
        if name in sub16:
            return uc.reg_read(full[sub16[name]]) & 0xffff
        base, shift = sub8[name]
        return (uc.reg_read(full[base]) >> shift) & 0xff

    def operand(i, op, bits):
        if op.type == X.X86_OP_IMM:
            value = op.imm & ((1 << bits) - 1)
            return lambda uc, ensure: (value, None)
        if op.type == X.X86_OP_REG:
            name = md.reg_name(op.reg)
            return lambda uc, ensure: (reg_value(uc, name), None)
        m = op.mem
        if m.segment not in (0, X.X86_REG_DS):
            return None
        base, index, scale, disp = md.reg_name(m.base) if m.base else None, md.reg_name(m.index) if m.index else None, m.scale, m.disp

        def read(uc, ensure):
            a = (disp + (uc.reg_read(full[base]) if base else 0) + (uc.reg_read(full[index]) * scale if index else 0)) & 0xffffffff
            ensure(a)
            ensure(a + bits // 8 - 1)
            return int.from_bytes(bytes(uc.mem_read(a, bits // 8)), 'little'), (a, bits // 8)
        return read

    out = {}
    for i in md.disasm(pe.image[off:off + row['body']], row['va']):
        if i.mnemonic in ('repe cmpsb', 'repne cmpsb'):        # FL-42: a string compare is one instruction; the guided search needs the whole other string
            def decode_str(uc, address, wc, ensure):
                esi, edi, ecx = (uc.reg_read(full[n]) for n in ('esi', 'edi', 'ecx'))
                n = min(ecx, 64)
                if n == 0:
                    return (address, 'str', esi, b'')
                for a in (esi, esi + n - 1, edi, edi + n - 1):
                    ensure(a)
                return (address, 'str', esi, bytes(uc.mem_read(edi, n)))
            out[i.address] = decode_str
            continue
        if i.mnemonic in ('cmp', 'test') and len(i.operands) == 2:
            bits = i.operands[0].size * 8
            a, b = operand(i, i.operands[0], bits), operand(i, i.operands[1], bits)
            if a is None or b is None:
                continue

            def decode(uc, address, wc, ensure, a=a, b=b, bits=bits):
                (va_, ca), (vb, cb) = a(uc, ensure), b(uc, ensure)
                return (address, bits, va_, vb, ca, cb, wc)
            out[i.address] = decode
    _CMP[row['va']] = out
    return out
