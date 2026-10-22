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
DATA_START = 0x537000          # first writable page of .data (the .rdata ends before it): globals below it are constants and tables
INSTRUCTION_LIMIT = 200000
ARGS = 8                       # stack dwords above the return address
LOGGED = 6                     # stack dwords of a stub call that are logged
SENTINELS = dict(eax=0x11111111, ebx=0x22222222, edx=0x44444444, esi=0x55555555, edi=0x66666666, ebp=0x77777777)


class Fault(Exception):
    pass


def magic_of(row):
    return row['magic']


HI_SEEDS = 7000        # seeds from here on use style 5 only


def style_of(seed):
    return 5 if seed >= HI_SEEDS else seed % 5


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
    total = sum(w for w, _ in weights)
    pick = rng.randrange(total)
    for w, kind in weights:
        if pick < w:
            break
        pick -= w
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
    if kind == 'neg':
        return (-rng.randrange(1, 0x41)) & 0xffffffff
    if kind == 'magic' and magic:
        base = rng.choice(magic)
        return (base + rng.choice((0, 0, 1, -1, 2, -2, 4, -4))) & 0xffffffff
    if kind == 'ptr':
        return REGION_BASE + rng.randrange(REGIONS) * REGION_STEP + rng.randrange(0, 0x2000, 4)
    return rng.getrandbits(32)


def page_fill(seed, magic, page):
    rng = random.Random(seed * 1000003 + page)
    style = style_of(seed)
    words = [mixture(rng, style, magic) for _ in range(PAGE // 4)]
    return struct.pack('<%dI' % (PAGE // 4), *words)


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


def stub_effect(rng, magic, ecx, args):
    """What a callee does in this world: (eax, ecx, edx, [(address, bytes)]). The draws are in call order, so both sides agree."""
    style = rng.randrange(5)
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
        self.edges = set()
        self.fault = None

    def digest(self):
        h = hashlib.sha256()
        h.update(repr(sorted(self.regs.items())).encode())
        h.update(repr(self.writes).encode())
        h.update(repr(self.calls).encode())
        return h.hexdigest()


# ---- the original, under Unicorn ----------------------------------------------------------------------------------------------------


def run_original(row, seed, overrides=(), observe=False):
    import unicorn
    from unicorn import x86_const as X
    pe = od.load_image()
    va, size = row['va'], row['body']
    regs, args, patches = initial_state(row, seed)
    magic = row['magic']
    uc = unicorn.Uc(unicorn.UC_ARCH_X86, unicorn.UC_MODE_32)
    image = bytearray(pe.image)
    for address, data in patches:
        image[address - IMAGE_BASE:address - IMAGE_BASE + len(data)] = data
    for address, size_, value in overrides:
        if IMAGE_BASE <= address and address + size_ <= IMAGE_BASE + len(image):
            image[address - IMAGE_BASE:address - IMAGE_BASE + size_] = (value & ((1 << (8 * size_)) - 1)).to_bytes(size_, 'little')
    stubs = {callee: (callee, cleanup) for callee, cleanup in row['callees'].items()}
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
    uc.hook_add(unicorn.UC_HOOK_MEM_WRITE, lambda uc_, access, address, size_, value, user: trace.writes.append((address, size_, value & ((1 << (8 * size_)) - 1))))
    prev = [None]

    def count(uc_, address, size_, user):
        trace.executed.add(address)
        if prev[0] is not None:
            trace.edges.add((prev[0], address))
        prev[0] = address

    uc.hook_add(unicorn.UC_HOOK_CODE, count, begin=va, end=va + size - 1)
    if observe:
        trace.reads, trace.events = [], []
        def seen_read(uc_, access, address, size_, value, user):
            ensure(address)
            ensure(address + size_ - 1)
            trace.reads.append((address, size_, int.from_bytes(bytes(uc.mem_read(address, size_)), 'little'), len(trace.writes)))

        def seen_cmp(uc_, a, size_, decode):
            trace.events.append(decode(uc, a, len(trace.writes), ensure))
        uc.hook_add(unicorn.UC_HOOK_MEM_READ, seen_read)
        for address, decode in cmp_decoders(row).items():
            uc.hook_add(unicorn.UC_HOOK_CODE, seen_cmp, decode, begin=address, end=address)
    stub_rng = random.Random(seed * 104729 + 13)

    def stub(uc_, address, size_, user):
        esp = uc.reg_read(X.UC_X86_REG_ESP)
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        held = tuple(uc.reg_read(getattr(X, 'UC_X86_REG_' + n)) for n in ('EAX', 'EDX', 'EBX', 'ESI', 'EDI', 'EBP'))
        words = struct.unpack('<%dI' % LOGGED, uc.mem_read(esp + 4, 4 * LOGGED))
        eax, ecx_out, edx, writes = stub_effect(stub_rng, magic, ecx, words)
        for at, data in writes:
            ensure(at)
            ensure(at + len(data) - 1)
            uc.mem_write(at, data)
        ident, cleanup = stubs[address]
        trace.calls.append((ident, ecx, held, words, eax, ecx_out, edx, writes))
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]
        uc.reg_write(X.UC_X86_REG_EAX, eax)
        uc.reg_write(X.UC_X86_REG_ECX, ecx_out)
        uc.reg_write(X.UC_X86_REG_EDX, edx)
        uc.reg_write(X.UC_X86_REG_ESP, esp + 4 + cleanup)
        uc.reg_write(X.UC_X86_REG_EIP, ret)

    for entry in stubs:
        uc.hook_add(unicorn.UC_HOOK_CODE, stub, begin=entry, end=entry)
    for name in ('eax', 'ebx', 'ecx', 'edx', 'esi', 'edi', 'ebp'):
        uc.reg_write(getattr(X, 'UC_X86_REG_' + name.upper()), regs[name])
    sp = STACK_BASE + STACK_SIZE - 0x100 - 4 * (ARGS + 1)
    uc.mem_write(sp, struct.pack('<%dI' % (ARGS + 1), STOP, *args))
    uc.reg_write(X.UC_X86_REG_ESP, sp)
    uc.reg_write(X.UC_X86_REG_EFLAGS, 2)
    for address, size_, value in overrides:
        if not (IMAGE_BASE <= address and address + size_ <= IMAGE_BASE + len(image)):
            ensure(address)
            ensure(address + size_ - 1)
            uc.mem_write(address, (value & ((1 << (8 * size_)) - 1)).to_bytes(size_, 'little'))
    try:
        uc.emu_start(va, STOP, count=INSTRUCTION_LIMIT)
    except unicorn.UcError as ex:
        trace.fault = str(ex)
        return trace
    if uc.reg_read(X.UC_X86_REG_EIP) != STOP:
        trace.fault = 'instruction limit'
        return trace
    trace.regs = {name: uc.reg_read(getattr(X, 'UC_X86_REG_' + name.upper())) for name in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')}
    return trace


# ---- the translation ----------------------------------------------------------------------------------------------------------------


class Regs(ctypes.Structure):
    _fields_ = [(n, ctypes.c_uint32) for n in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')]


RD = ctypes.CFUNCTYPE(ctypes.c_uint32, ctypes.c_void_p, ctypes.c_uint32, ctypes.c_int)
WR = ctypes.CFUNCTYPE(None, ctypes.c_void_p, ctypes.c_uint32, ctypes.c_int, ctypes.c_uint32)
CALL = ctypes.CFUNCTYPE(None, ctypes.c_void_p, ctypes.c_uint32, ctypes.POINTER(Regs))


class Host(ctypes.Structure):
    _fields_ = [('ctx', ctypes.c_void_p), ('rd', RD), ('wr', WR), ('call', CALL)]


class Mem:
    """The 32-bit address space of the translation: the patched image, the stack, and the lazily filled pages."""

    def __init__(self, seed, magic, patches):
        pe = od.load_image()
        self.image = bytearray(pe.image)
        for address, data in patches:
            self.image[address - IMAGE_BASE:address - IMAGE_BASE + len(data)] = data
        self.image_end = IMAGE_BASE + len(self.image)
        self.stack = bytearray(b'\x71' * STACK_SIZE)
        self.pages = {}
        self.seed, self.magic = seed, magic

    def _cell(self, address, size):
        if IMAGE_BASE <= address and address + size <= self.image_end:
            return self.image, address - IMAGE_BASE
        if STACK_BASE <= address and address + size <= STACK_BASE + STACK_SIZE:
            return self.stack, address - STACK_BASE
        if STOP <= address < STOP + 16:
            return bytearray(b'\x90' * 16), 0
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
        eax, ecx_out, edx, writes = stub_effect(stub_rng, magic, ecx, words)
        for at, data in writes:
            mem.write_bytes(at, data)
        held = tuple(getattr(rr.contents, n) for n in ('eax', 'edx', 'ebx', 'esi', 'edi', 'ebp'))
        trace.calls.append((callee, ecx, held, words, eax, ecx_out, edx, writes))
        rr.contents.eax = eax
        rr.contents.ecx = ecx_out
        rr.contents.edx = edx

    host = Host(None, RD(rd), WR(wr), CALL(call))
    sp = STACK_BASE + STACK_SIZE - 0x100 - 4 * (ARGS + 1)
    for k, v in enumerate([STOP, *args]):
        mem.write(sp + 4 * k, 4, v)
    for address, size_, value in overrides:
        mem.write(address, size_, value)
    r = Regs(regs['eax'], regs['ecx'], regs['edx'], regs['ebx'], sp, regs['ebp'], regs['esi'], regs['edi'])
    getattr(lib, 'm%x_lifted' % va)(ctypes.byref(r), ctypes.byref(host))
    trace.regs = {n: getattr(r, n) for n in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')}
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


def row_info(va, body, callees, imports=None, fs=False):
    """The static facts of a row: its body size, its callees ({address: bytes the callee pops}), the immediates of its code (the magic values), and the writable globals it names."""
    import capstone
    from capstone import x86_const as X
    pe = od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = va - pe.image_base
    magic, globs, rets = set(), set(), set()
    for i in md.disasm(pe.image[off:off + body], va):
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
    return {'va': va, 'body': body, 'callees': {int(k): v for k, v in callees.items()}, 'imports': {int(k): v for k, v in (imports or {}).items()}, 'fs': bool(fs), 'ret': sorted(rets), 'magic': sorted(magic)[:24], 'globals': sorted(globs)[:16]}


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
