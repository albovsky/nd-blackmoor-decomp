#!/usr/bin/env python3
"""FL-41: instruction-level lifter from the owner's local GAME.EXE bytes of one function to C over the virtual 32-bit address space.

The C that comes out (src/original_methods_fl41.c) is a one-to-one translation: every x86 instruction of the function is one C statement
block, labelled at the jump targets, with the eight 32-bit registers and the five arithmetic flags as locals, every memory access through
the host (`h->rd` / `h->wr` at the original 32-bit address, so the stack of the function is host-visible too) and every direct call to
another function through `h->call`, after the return address was pushed (the host plays the callee; the stack cleanup of the callee, read
from its own `ret N`, is a statement of the translation). It carries no meaning beyond the original instructions; names and structure are
the next step. The translation is only credited after the differential test and the original-only oracle of tests/fl41_world.py.

FL-52 ported the x87 support of FL-51 (scripts/lift_function.py) to this lifter: fld/fild/fst/fstp, the add/sub/mul/div family, fcom/fcomp/fcompp, fnstsw and fchs
run on the model of src/original_methods_fl41_x87.h (a copy of the FL-40 one), a callee's effect on the x87 stack comes from `fpu_net`, and a row that uses the
x87 unit gets FL41_FPU_PROLOGUE / FL41_FPU_EPILOGUE. Rows without an x87 instruction are translated exactly as before.

  lift_fl41.py <va> [<va> ...]     print the C of each function
  lift_fl41.py --census            how many pending game rows at or above 0x480000 the lifter takes, and why the others stay out

Needs the private work/original/GAME.EXE (the bytes are read, never written).
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / "tests"))

import capstone
from capstone import x86_const as X

import original_differential as od

REG32 = ("eax", "ecx", "edx", "ebx", "esp", "ebp", "esi", "edi")
SUB16 = {"ax": "eax", "cx": "ecx", "dx": "edx", "bx": "ebx", "sp": "esp", "bp": "ebp", "si": "esi", "di": "edi"}
SUB8L = {"al": "eax", "cl": "ecx", "dl": "edx", "bl": "ebx"}
SUB8H = {"ah": "eax", "ch": "ecx", "dh": "edx", "bh": "ebx"}
COND = {"e": "zf", "z": "zf", "ne": "!zf", "nz": "!zf", "b": "cf", "c": "cf", "nae": "cf", "ae": "!cf", "nb": "!cf", "nc": "!cf",
        "be": "(cf || zf)", "na": "(cf || zf)", "a": "(!cf && !zf)", "nbe": "(!cf && !zf)",
        "l": "(sf != of)", "nge": "(sf != of)", "ge": "(sf == of)", "nl": "(sf == of)",
        "le": "(zf || sf != of)", "ng": "(zf || sf != of)", "g": "(!zf && sf == of)", "nle": "(!zf && sf == of)",
        "s": "sf", "ns": "!sf", "o": "of", "no": "!of", "p": "pf", "pe": "pf", "np": "!pf", "po": "!pf"}
MASK = {8: "0xffu", 16: "0xffffu", 32: "0xffffffffu"}
SIGN = {8: "0x80u", 16: "0x8000u", 32: "0x80000000u"}


class Unsupported(Exception):
    pass


_MD = None


def md():
    global _MD
    if _MD is None:
        _MD = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        _MD.detail = True
    return _MD


def disasm(va, size):
    pe = od.load_image()
    off = va - pe.image_base
    ins = list(md().disasm(pe.image[off:off + size], va))
    if sum(i.size for i in ins) != size:
        raise Unsupported("disassembly stops at 0x%x" % (va + sum(i.size for i in ins)))
    return ins


# ---- the callees -----------------------------------------------------------------------------------------------------------------

_LEDGER = None
# callees that are not played by the host: `__chkstk` takes its size in eax and lowers esp, so it is translated too (the original bytes run in the oracle)
INLINE_CALLEES = {0x50c920}


def ledger_spans():
    global _LEDGER
    if _LEDGER is None:
        entries = json.load(open(PROJECT / "function-ledger.json"))["entries"]
        _LEDGER = {int(e["va"], 16): e["body_size"] or e["span"] for e in entries}
    return _LEDGER


_ENTRIES = None


def ledger_entry(va):
    global _ENTRIES
    if _ENTRIES is None:
        _ENTRIES = {int(e["va"], 16): e for e in json.load(open(PROJECT / "function-ledger.json"))["entries"]}
    return _ENTRIES.get(va)


def callee_shape(target, depth=0):
    """(bytes the callee pops after the return address, None) of the function at `target`, from its own `ret N` instructions; raises
    Unsupported for a callee that does not follow the usual stack discipline (x87 inside, esp written otherwise, ret N that differ,
    a body that is not a ledger function)."""
    spans = ledger_spans()
    if target not in spans:
        raise Unsupported("callee 0x%x is not a ledger function" % target)
    size = spans[target]
    try:
        ins = disasm(target, size)
    except Unsupported:
        ins = list(md().disasm(od.load_image().image[target - od.load_image().image_base:][:size], target))
    rets = set()
    for i in ins:
        if i.mnemonic == "ret":
            rets.add(i.operands[0].imm if i.operands else 0)
        if i.mnemonic in ("pushfd", "popfd", "pushad", "popad", "int", "sysenter", "enter"):
            raise Unsupported("callee 0x%x uses %s" % (target, i.mnemonic))
        if target in INLINE_CALLEES:
            continue
        if i.mnemonic in ("mov", "xchg", "lea", "sub", "add", "and", "or", "xor") and i.operands and \
                i.operands[0].type == X.X86_OP_REG and i.operands[0].reg == X.X86_REG_ESP:
            if not (i.mnemonic in ("sub", "add") and len(i.operands) == 2 and i.operands[1].type == X.X86_OP_IMM) and \
                    not (i.mnemonic == "mov" and i.operands[1].type == X.X86_OP_REG and i.operands[1].reg == X.X86_REG_EBP):
                raise Unsupported("callee 0x%x writes esp (%s %s)" % (target, i.mnemonic, i.op_str))
    if not rets:
        # a callee without a return (it never comes back, or ends in a tail jump): a tail jump to a thunk is followed once
        last = ins[-1] if ins else None
        if last is not None and last.mnemonic == "jmp" and last.operands[0].type == X.X86_OP_IMM and depth < 3 and \
                last.operands[0].imm != target:
            return callee_shape(last.operands[0].imm, depth + 1)
        return 0
    if len(rets) != 1:
        raise Unsupported("callee 0x%x has several ret sizes %s" % (target, sorted(rets)))
    return rets.pop()


# net change of the x87 stack depth of an instruction (FL-52)
FPU_PUSH = {"fld", "fild", "fld1", "fldz", "fldpi", "fldl2e", "fldln2", "fldl2t", "fldlg2", "fsincos", "fptan", "fxtract"}
FPU_POP = {"fstp", "fistp", "fisttp", "fcomp", "fucomp", "faddp", "fmulp", "fsubp", "fsubrp", "fdivp", "fdivrp", "ficomp", "fpatan", "fyl2x", "fyl2xp1"}
FPU_POP2 = {"fcompp", "fucompp"}
FPU_NEUTRAL = {"fst", "fist", "fadd", "fmul", "fsub", "fsubr", "fdiv", "fdivr", "fiadd", "fimul", "fisub", "fisubr", "fidiv", "fidivr", "fchs", "fabs", "fcom",
               "fucom", "ficom", "fnstsw", "fnstcw", "fldcw", "fwait", "fsqrt", "frndint", "ftst", "fxch", "fxam", "fnclex", "fnstenv", "fldenv", "fprem", "fscale",
               "fsin", "fcos", "f2xm1", "fprem1", "fnop"}
_FPU_NET = {}
_FPU_NET_BULK = {}     # FL-55b: results derived with the permissive BULK assumptions never reach the strict lifts
# C runtime routines whose x87 effect was read from their bytes (the ledger splits some of them into pieces, so a walk of the ledger span would miss their `ret`):
# sqrt, sin and cos take a double on the stack and leave the result in st(0); __ftol takes st(0) and returns edx:eax; atof (0x50ccec) returns its result in st(0)
LIBRARY_FPU_NET = {0x50df94: 1, 0x50e104: 1, 0x50e054: 1, 0x50ce04: -1, 0x50ccec: 1}


def library_fpu_net(target, depth=0):
    """x87 effect of a C runtime routine: the table above, else 0 provided the routine (its bytes up to the first `ret`, at most 400) holds no x87 instruction.
    A thunk (`mov edx, imm; jmp target`) is followed; any other jump or call out of the scan is refused (FL-52 review: 0x50de00 jumps to code that uses the x87 unit)."""
    if target in LIBRARY_FPU_NET:
        return LIBRARY_FPU_NET[target]
    if depth > 3:
        raise Unsupported("library callee 0x%x: jump chain too long" % target)
    img = od.load_image()
    n = 0
    for i in md().disasm(img.image[target - img.image_base:][:400], target):
        if i.mnemonic.startswith("f") and i.mnemonic != "fs":
            raise Unsupported("library callee 0x%x uses %s and is not classified" % (target, i.mnemonic))
        n += 1
        if i.mnemonic == "jmp":
            if i.operands and i.operands[0].type == X.X86_OP_IMM:
                return library_fpu_net(i.operands[0].imm, depth + 1)
            raise Unsupported("library callee 0x%x: indirect jump" % target)
        if i.mnemonic == "ret":
            return 0
    raise Unsupported("library callee 0x%x: no ret within 400 bytes" % target)


def fpu_net(target, depth=0):
    try:
        return _fpu_net(target, depth)
    except Unsupported:
        if not BULK:
            raise
        return 0                                                   # FL-55b bulk: a callee whose x87 effect is not known is taken not to change the x87 stack


def _fpu_net(target, depth=0):
    """Net change of the x87 stack depth that a call of the function at `target` leaves (1: it returns a value in st(0)); raises Unsupported for a callee whose
    paths disagree, that calls through a register, or that uses an x87 instruction the model does not know."""
    cache = _FPU_NET_BULK if BULK else _FPU_NET
    if target in cache:
        return cache[target]
    entry = ledger_entry(target)
    if entry is None or depth > 6:
        raise Unsupported("callee 0x%x is not a ledger function" % target)
    if entry["origin"] != "game":
        cache[target] = library_fpu_net(target)
        return cache[target]
    spans = ledger_spans()
    ins = list(md().disasm(od.load_image().image[target - od.load_image().image_base:][:spans[target]], target))
    by_addr = {i.address: k for k, i in enumerate(ins)}
    seen, rets = {}, set()
    work = [(0, 0)]
    while work:
        k, d = work.pop()
        while k < len(ins):
            i = ins[k]
            if i.address in seen:
                if seen[i.address] != d:
                    raise Unsupported("callee 0x%x: x87 depth differs on two paths at 0x%x" % (target, i.address))
                break
            seen[i.address] = d
            mn = i.mnemonic
            if mn.startswith("f") and mn != "fs":
                if mn in FPU_PUSH:
                    d += 1
                elif mn in FPU_POP:
                    d -= 1
                elif mn in FPU_POP2:
                    d -= 2
                elif mn not in FPU_NEUTRAL:
                    raise Unsupported("callee 0x%x: x87 instruction %s" % (target, mn))
            if mn == "call":
                o = i.operands[0]
                if o.type == X.X86_OP_MEM and not o.mem.base and not o.mem.index and o.mem.disp in import_slots():
                    pass                                    # an import: it does not touch the x87 stack
                elif o.type != X.X86_OP_IMM:
                    if not BULK:
                        raise Unsupported("callee 0x%x: indirect call at 0x%x" % (target, i.address))     # FL-55b bulk: an indirect call is taken not to change the x87 stack
                elif o.imm != target:
                    d += fpu_net(o.imm, depth + 1)
            if mn == "ret":
                rets.add(d)
                break
            if mn == "jmp" and i.operands[0].type == X.X86_OP_MEM and i.operands[0].mem.index and not i.operands[0].mem.base:
                for t in set(jump_table(ins, k, target, target + spans[target])):
                    work.append((by_addr[t], d))
                break
            if mn == "jmp":
                t = i.operands[0].imm if i.operands and i.operands[0].type == X.X86_OP_IMM else None
                if t is None or t not in by_addr:
                    if t is not None and t != target:
                        rets.add(d + fpu_net(t, depth + 1))
                    else:
                        raise Unsupported("callee 0x%x: indirect jump at 0x%x" % (target, i.address))
                    break
                k = by_addr[t]
                continue
            if mn[0] == "j" and i.operands and i.operands[0].type == X.X86_OP_IMM:
                if i.operands[0].imm not in by_addr:
                    raise Unsupported("callee 0x%x: conditional jump out of its span at 0x%x" % (target, i.address))
                work.append((by_addr[i.operands[0].imm], d))
            k += 1
        else:
            raise Unsupported("callee 0x%x: runs off the end of its span" % target)
    if len(rets) != 1:
        raise Unsupported("callee 0x%x: x87 depth at its returns %s" % (target, sorted(rets)))
    cache[target] = rets.pop()
    return cache[target]


# ---- the imports ---------------------------------------------------------------------------------------------------------------

# stdcall argument counts of the Win32 / shell functions the translated rows call through the import table (the documented signatures)
IMPORT_ARGS = {"GetTickCount": 0, "SendMessageA": 4, "GetPrivateProfileIntA": 4, "ShowCursor": 1, "WritePrivateProfileStringA": 4, "GetKeyState": 1,
               "GetAsyncKeyState": 1, "Sleep": 1, "PeekMessageA": 5, "GetPrivateProfileStringA": 6, "CloseHandle": 1, "EnableWindow": 2,
               "SetThreadPriority": 2, "SHGetSpecialFolderPathA": 4, "CreateDirectoryA": 2, "PathAppendA": 2, "CopyFileA": 3, "GetLastError": 0,
               "FormatMessageA": 7, "GetCurrentThreadId": 0, "GetKeyboardLayout": 1, "GetModuleFileNameA": 3, "SystemParametersInfoA": 4,
               "GlobalMemoryStatus": 1, "SuspendThread": 1, "GetThreadPriority": 1, "GetLogicalDrives": 0, "GetSystemTime": 1, "GetComputerNameA": 2,
               "GetSystemInfo": 1, "CreateFileA": 7, "GetFileTime": 4, "FileTimeToLocalFileTime": 2, "FileTimeToDosDateTime": 3, "CopyRect": 2,
               "EqualRect": 2}
_SLOTS = None
sys.path.insert(0, str(Path(__file__).resolve().parent))
from fl55_imports import import_args    # noqa: E402


def import_slots():
    """{address of the import slot: (dll, function)} from the import directory of the pinned image."""
    global _SLOTS
    if _SLOTS is None:
        import struct
        img = od.load_image().image
        e = struct.unpack_from("<I", img, 0x3c)[0]
        imp_rva = struct.unpack_from("<II", img, e + 24 + 96 + 8)[0]
        slots, p = {}, imp_rva
        while True:
            oft, _, _, name, ft = struct.unpack_from("<IIIII", img, p)
            if not name:
                break
            dll = img[name:img.index(b"\0", name)].decode()
            q, slot = oft or ft, ft
            while True:
                v = struct.unpack_from("<I", img, q)[0]
                if not v:
                    break
                fn = "#%d" % (v & 0xffff) if v & 0x80000000 else img[v + 2:img.index(b"\0", v + 2)].decode()
                slots[od.load_image().image_base + slot] = (dll, fn)
                q += 4
                slot += 4
            p += 20
        _SLOTS = slots
    return _SLOTS


# ---- operands --------------------------------------------------------------------------------------------------------------------

def reg_name(i, reg):
    return md().reg_name(reg)


class Ctx:
    def __init__(self, ins, va, size):
        self.ins = ins
        self.va, self.size = va, size
        self.end = va + size
        self.targets = set()
        self.callees = {}
        self.imports = {}
        self.inline = set()
        self.fpret = {}
        self.fs = False
        self.fpu = any(i.mnemonic.startswith('f') and i.mnemonic != 'fs' for i in ins)
        self.lines = []
        self.temp = 0

    def emit(self, text):
        self.lines.append("    " + text)


def mem_addr(i, op):
    m = op.mem
    if m.segment not in (0, X.X86_REG_DS, X.X86_REG_FS):
        raise Unsupported("segment override at 0x%x" % i.address)
    parts = []
    if m.segment == X.X86_REG_FS:
        parts.append("FL41_TIB")
    if m.base:
        parts.append(reg_name(i, m.base))
    if m.index:
        parts.append(reg_name(i, m.index) + ("" if m.scale == 1 else " * %du" % m.scale))
    disp = m.disp & 0xffffffff
    if disp or not parts:
        parts.append("0x%xu" % disp)
    for p in parts[:2]:
        if p.split()[0] not in REG32 and p[0] != "0" and p != "FL41_TIB":
            raise Unsupported("16-bit address register at 0x%x" % i.address)
    return "(uint32_t)(" + " + ".join(parts) + ")"


def get(i, op, bits=None):
    """C expression of an operand's value (zero-extended)."""
    if op.type == X.X86_OP_IMM:
        return "0x%xu" % (op.imm & ((1 << (bits or op.size * 8)) - 1))
    if op.type == X.X86_OP_REG:
        n = reg_name(i, op.reg)
        if n in REG32:
            return n
        if n in SUB16:
            return "(%s & 0xffffu)" % SUB16[n]
        if n in SUB8L:
            return "(%s & 0xffu)" % SUB8L[n]
        if n in SUB8H:
            return "((%s >> 8) & 0xffu)" % SUB8H[n]
        raise Unsupported("register %s at 0x%x" % (n, i.address))
    if op.type == X.X86_OP_MEM:
        return "RD%d(%s)" % ((bits or op.size * 8), mem_addr(i, op))
    raise Unsupported("operand type")


def put(i, op, value, bits=None):
    """C statement storing `value` (an expression, already of the operand's width) into the operand."""
    bits = bits or op.size * 8
    if op.type == X.X86_OP_REG:
        n = reg_name(i, op.reg)
        if n in REG32:
            return "%s = %s;" % (n, value)
        if n in SUB16:
            r = SUB16[n]
            return "%s = (%s & 0xffff0000u) | ((%s) & 0xffffu);" % (r, r, value)
        if n in SUB8L:
            r = SUB8L[n]
            return "%s = (%s & 0xffffff00u) | ((%s) & 0xffu);" % (r, r, value)
        if n in SUB8H:
            r = SUB8H[n]
            return "%s = (%s & 0xffff00ffu) | (((%s) & 0xffu) << 8);" % (r, r, value)
        raise Unsupported("register %s at 0x%x" % (n, i.address))
    if op.type == X.X86_OP_MEM:
        return "WR%d(%s, %s);" % (bits, mem_addr(i, op), value)
    raise Unsupported("store operand type")


def sext(expr, bits):
    return {8: "(int32_t)(int8_t)(%s)", 16: "(int32_t)(int16_t)(%s)", 32: "(int32_t)(%s)"}[bits] % expr


# ---- instructions ----------------------------------------------------------------------------------------------------------------

ARITH = {"add": "ADD", "sub": "SUB", "adc": "ADC", "sbb": "SBB", "cmp": "CMP", "and": "AND", "or": "OR", "xor": "XOR", "test": "TEST"}


def label(va):
    return "L_%x" % va


BYTE_REGS = {X.X86_REG_AL: "eax", X.X86_REG_CL: "ecx", X.X86_REG_DL: "edx", X.X86_REG_BL: "ebx"}


def jump_table(ins, k, va, end):
    """Targets of the `jmp [index*4 + table]` at ins[k] of the function [va, end): the table has as many entries as the bound the code compares the index with
    (FL-52: the index may be any register that a byte table was read into). Raises Unsupported for a table that leaves the function or has no visible bound."""
    i = ins[k]
    m = i.operands[0].mem
    a = i.address
    table = m.disp & 0xffffffff
    count = None
    window = ins[max(0, k - 14):k]
    index_reg = reg_name(i, m.index)

    def bound_before(upto):
        """imm + 1 of the last `cmp x, imm` before window[upto] that is followed by ja (imm + 1 values) or jae (imm values)."""
        for q in range(upto - 1, 0, -1):
            if window[q].mnemonic in ("ja", "jae") and window[q - 1].mnemonic == "cmp" and window[q - 1].operands[1].type == X.X86_OP_IMM:
                return window[q - 1].operands[1].imm + (1 if window[q].mnemonic == "ja" else 0)
        return None

    # the index comes from a byte table: mov al, byte ptr [reg + IDX]; the entries are the largest byte + 1
    for n, prev in enumerate(window):
        if prev.mnemonic == "mov" and prev.operands[0].type == X.X86_OP_REG and BYTE_REGS.get(prev.operands[0].reg) == index_reg and \
                prev.operands[1].type == X.X86_OP_MEM and prev.operands[1].size == 1 and prev.operands[1].mem.index == 0:
            bound = bound_before(n)
            if bound is not None:
                base_idx = prev.operands[1].mem.disp & 0xffffffff
                raw = od.load_image().image
                count = max(raw[base_idx - od.load_image().image_base:][:bound]) + 1
            break
    if count is None:
        count = bound_before(len(window))
    if count is None:
        raise Unsupported("jump table without a bound at 0x%x" % a)
    img = od.load_image()
    off = table - img.image_base
    import struct
    targets = struct.unpack_from("<%dI" % count, img.image, off)
    if any(not (va <= t < end) for t in targets):
        raise Unsupported("jump table leaves the function at 0x%x" % a)
    return targets


BULK = False          # FL-55b: the lifts of scripts/fl55_bulk.py (calls through registers and pointers, unknown x87 effect of a callee); the credited rows are lifted with BULK off
PROLOGUE_MN = {"push", "mov", "sub", "lea", "and"}


def indirect_cleanup(c, i):
    """FL-55b heuristic: the bytes the target of an indirect call pops. A caller that cleans up (`add esp, N` within the next instructions, before another call or jump) gives 0; otherwise the callee
    is taken to pop the arguments pushed since the last call, jump, label or esp change, not counting the pushes of the prologue (saved registers)"""
    k = next(n for n, x in enumerate(c.ins) if x.address == i.address)
    for x in c.ins[k + 1:k + 5]:
        if x.mnemonic == "add" and x.operands and x.operands[0].type == X.X86_OP_REG and x.operands[0].reg == X.X86_REG_ESP:
            return 0
        if x.mnemonic in ("call", "ret") or x.mnemonic[0] == "j":
            break
    start = 0
    for n, x in enumerate(c.ins):                                  # the prologue: push ebp / mov ebp, esp / sub esp, N right at the start
        if n < 3 and ((x.mnemonic == "push" and x.operands[0].type == X.X86_OP_REG and x.operands[0].reg == X.X86_REG_EBP) or
                      (x.mnemonic == "mov" and x.operands[0].type == X.X86_OP_REG and x.operands[0].reg == X.X86_REG_EBP) or
                      (x.mnemonic == "sub" and x.operands[0].type == X.X86_OP_REG and x.operands[0].reg == X.X86_REG_ESP)):
            start = n + 1
        else:
            break
    # FL-58: the saved registers are the first K register pushes, K being the run of `pop reg` right before a `ret` (the registers the epilogue restores); any push beyond them is an argument
    saved = set()
    runs = []
    for n, x in enumerate(c.ins):
        if x.mnemonic == "ret":
            j = n - 1
            framed = start > 0 and c.ins[0].mnemonic == "push"
            if framed and j >= 0 and c.ins[j].mnemonic == "leave":
                j -= 1
            elif framed and j >= 0 and c.ins[j].mnemonic == "pop" and c.ins[j].operands[0].type == X.X86_OP_REG and c.ins[j].operands[0].reg == X.X86_REG_EBP:
                j -= 1
                if j >= 0 and c.ins[j].mnemonic == "mov" and c.ins[j].operands[0].type == X.X86_OP_REG and c.ins[j].operands[0].reg == X.X86_REG_ESP:
                    j -= 1
            m = 0
            while j - m >= 0 and c.ins[j - m].mnemonic == "pop" and c.ins[j - m].operands[0].type == X.X86_OP_REG:
                m += 1
            runs.append(m)
    if runs:
        k_saved = min(runs)
        for x in c.ins[start:]:
            if k_saved == 0:
                break
            if x.mnemonic == "push" and x.operands[0].type == X.X86_OP_REG:
                saved.add(x.address)
                k_saved -= 1
    pushes = 0
    for x in reversed(c.ins[start:k]):
        if x.mnemonic in ("call", "ret") or x.mnemonic[0] == "j" or x.mnemonic in ("leave", "pushfd"):
            break
        if x.operands and x.operands[0].type == X.X86_OP_REG and x.operands[0].reg == X.X86_REG_ESP and x.mnemonic in ("add", "sub", "mov", "lea", "and"):
            break
        if x.mnemonic == "push" and x.address not in saved:
            pushes += 1
        if x.address in c.targets:
            break
    return 4 * pushes


INDIRECT_SITES = {}   # FL-58: {row va: {address of a call through a register or pointer: bytes the target is taken to pop}}; the original side plays such a call as a stub as well (tests/fl41_world.py)


def indirect_call(c, i, op):
    """FL-55b: `call reg`, `call [mem]` (any address): the target is computed before the return address is pushed; the host sees the target address in h->call"""
    cleanup = indirect_cleanup(c, i)
    INDIRECT_SITES.setdefault(c.va, {})[i.address] = cleanup
    c.emit("{ uint32_t t_ = %s; esp -= 4u; WR32(esp, 0x%xu); FL41_CALL(t_); %sesp += 4u; }" % (get(i, op, 32), i.address + i.size, "esp += %du; " % cleanup if cleanup else ""))


def lift_one(c, i):
    mn = i.mnemonic
    ops = i.operands
    a = i.address
    e = c.emit
    prefix = ""
    m = re.match(r"^(rep|repe|repne|lock)\s+(.*)$", mn)
    if m:
        prefix, mn = m.group(1), m.group(2)
    if prefix == "lock":
        raise Unsupported("lock prefix at 0x%x" % a)
    if mn in ("nop", "int3", "cld", "wait"):
        if mn == "int3":
            raise Unsupported("int3 inside the code at 0x%x" % a)
        return
    if mn in ARITH:
        bits = ops[0].size * 8
        dst, src = ops[0], ops[1]
        M = MASK[bits]
        e("{ uint32_t a_ = %s, b_ = %s, r_;" % (get(i, dst, bits), get(i, src, bits)))
        op = ARITH[mn]
        if mn in ("add", "adc"):
            e("  FL41_ADD(a_, b_, %s, r_, %d);" % ("cf" if mn == "adc" else "0u", bits))
        elif mn in ("sub", "sbb", "cmp"):
            e("  FL41_SUB(a_, b_, %s, r_, %d);" % ("cf" if mn == "sbb" else "0u", bits))
        else:
            e("  r_ = %s;" % {"and": "a_ & b_", "test": "a_ & b_", "or": "a_ | b_", "xor": "a_ ^ b_"}[mn])
            e("  FL41_LOGIC(r_, %d);" % bits)
        if mn not in ("cmp", "test"):
            e("  " + put(i, dst, "r_", bits))
        e("}")
        return
    if mn in ("inc", "dec"):
        bits = ops[0].size * 8
        e("{ uint32_t a_ = %s, r_;" % get(i, ops[0], bits))
        e("  r_ = (a_ %s 1u) & %s;" % ("+" if mn == "inc" else "-", MASK[bits]))
        e("  of = %s;" % ("(a_ == %s - 1u)" % SIGN[bits] if mn == "inc" else "(a_ == %s)" % SIGN[bits]))
        e("  FL41_ZSP(r_, %d);" % bits)
        e("  " + put(i, ops[0], "r_", bits))
        e("}")
        return
    if mn == "neg":
        bits = ops[0].size * 8
        e("{ uint32_t a_ = %s, r_;" % get(i, ops[0], bits))
        e("  FL41_SUB(0u, a_, 0u, r_, %d);" % bits)
        e("  " + put(i, ops[0], "r_", bits))
        e("}")
        return
    if mn == "not":
        bits = ops[0].size * 8
        e("{ uint32_t a_ = %s;" % get(i, ops[0], bits))
        e("  " + put(i, ops[0], "(~a_) & %s" % MASK[bits], bits))
        e("}")
        return
    if mn == "mov":
        bits = ops[0].size * 8
        e(put(i, ops[0], get(i, ops[1], bits), bits))
        return
    if mn in ("movzx", "movsx"):
        sbits = ops[1].size * 8
        dbits = ops[0].size * 8
        v = get(i, ops[1], sbits)
        if mn == "movsx":
            v = "((uint32_t)%s) & %s" % (sext(v, sbits), MASK[dbits])
        e(put(i, ops[0], v, dbits))
        return
    if mn == "lea":
        e(put(i, ops[0], mem_addr(i, ops[1]), 32))
        return
    if mn == "xchg":
        bits = ops[0].size * 8
        e("{ uint32_t a_ = %s, b_ = %s;" % (get(i, ops[0], bits), get(i, ops[1], bits)))
        e("  " + put(i, ops[0], "b_", bits))
        e("  " + put(i, ops[1], "a_", bits))
        e("}")
        return
    if mn == "push":
        if ops[0].type != X.X86_OP_IMM and ops[0].size != 4:
            raise Unsupported("16-bit push at 0x%x" % a)
        if ops[0].type == X.X86_OP_REG and reg_name(i, ops[0].reg) == "esp":
            raise Unsupported("push esp at 0x%x" % a)
        if ops[0].type == X.X86_OP_MEM and reg_name(i, ops[0].mem.base) == "esp":   # the operand is read before esp drops
            e("{ uint32_t v_ = %s; esp -= 4u; WR32(esp, v_); }" % get(i, ops[0], 32))
            return
        e("esp -= 4u; WR32(esp, %s);" % get(i, ops[0], 32))
        return
    if mn == "pop":
        if ops[0].size != 4:
            raise Unsupported("16-bit pop at 0x%x" % a)
        if ops[0].type == X.X86_OP_REG and reg_name(i, ops[0].reg) == "esp":
            raise Unsupported("pop esp at 0x%x" % a)
        if ops[0].type == X.X86_OP_MEM:
            e("{ uint32_t v_ = RD32(esp); esp += 4u; %s }" % put(i, ops[0], "v_", 32))
        else:
            e("%s esp += 4u;" % put(i, ops[0], "RD32(esp)", 32))
        return
    if mn == "leave":
        e("esp = ebp; ebp = RD32(esp); esp += 4u;")
        return
    if mn == "ret":
        n = ops[0].imm if ops else 0
        e("esp += %du;" % (4 + n))
        e("goto done;")
        return
    if mn == "call":
        if ops[0].type == X.X86_OP_MEM and not ops[0].mem.base and not ops[0].mem.index and ops[0].mem.segment in (0, X.X86_REG_DS):
            t = ops[0].mem.disp & 0xffffffff
            name = import_slots().get(t)
            count = None if name is None else (IMPORT_ARGS[name[1]] if name[1] in IMPORT_ARGS else import_args(name[1]))
            if count is None:
                if not BULK:
                    raise Unsupported("indirect call through 0x%x at 0x%x" % (t, a))
                return indirect_call(c, i, ops[0])                 # FL-55b: a function pointer kept in a global
            cleanup = 4 * count
            c.imports[t] = cleanup
            e("esp -= 4u; WR32(esp, 0x%xu);  /* call [%s!%s] */" % (a + i.size, name[0], name[1]))
            e("FL41_CALL(0x%xu);" % t)
            if cleanup:
                e("esp += %du;" % cleanup)
            e("esp += 4u;")
            return
        if ops[0].type != X.X86_OP_IMM:
            if BULK:
                return indirect_call(c, i, ops[0])                 # FL-55b: a call through a register or a memory operand
            raise Unsupported("indirect call at 0x%x" % a)
        t = ops[0].imm
        if t == c.va:
            raise Unsupported("recursive call at 0x%x" % a)
        if t in INLINE_CALLEES:
            c.inline.add(t)
            e("esp -= 4u; WR32(esp, 0x%xu);" % (a + i.size))
            e("FL41_CALL_LIFTED(m%x_lifted);" % t)
            return
        cleanup = callee_shape(t)
        c.callees[t] = cleanup
        try:
            net = fpu_net(t) if c.fpu else 0
        except Unsupported:
            if not BULK:
                raise
            net = 0                                                # FL-55b: the callee's effect on the x87 stack is not known
        if net not in (-1, 0, 1):
            raise Unsupported("callee 0x%x changes the x87 stack by %d at 0x%x" % (t, net, a))
        e("esp -= 4u; WR32(esp, 0x%xu);" % (a + i.size))
        e("FL41_CALL(0x%xu);" % t)
        if cleanup:
            e("esp += %du;" % cleanup)
        e("esp += 4u;")
        if net:
            c.fpret[t] = net
            e("fl41_fpush(fp, fl41_ld_f64(fp, h->fret(h->ctx)));" if net > 0 else "fl41_fpop(fp);")
        return
    if mn == "jmp" and ops[0].type == X.X86_OP_MEM:
        m = ops[0].mem
        if m.base or not m.index or m.scale != 4 or m.segment not in (0, X.X86_REG_DS):
            raise Unsupported("indirect jump at 0x%x" % a)
        targets = jump_table(c.ins, c.ins.index(i), c.va, c.end)
        c.targets |= set(targets)
        e("{ uint32_t t_ = RD32(%s);" % mem_addr(i, ops[0]))
        e("  switch (t_) {")
        for t in sorted(set(targets)):
            e("  case 0x%xu: goto %s;" % (t, label(t)))
        e("  default: FL41_TRAP;")
        e("  } }")
        return
    if mn == "jmp":
        if ops[0].type != X.X86_OP_IMM:
            raise Unsupported("indirect jump at 0x%x" % a)
        t = ops[0].imm
        if c.va <= t < c.end:
            e("goto %s;" % label(t))
        else:
            cleanup = callee_shape(t)
            c.callees[t] = cleanup
            e("FL41_CALL(0x%xu);" % t)
            e("esp += %du;" % (4 + cleanup))
            e("goto done;")
        return
    if mn[0] == "j" and mn[1:] in COND:
        t = ops[0].imm
        if not (c.va <= t < c.end):
            raise Unsupported("conditional jump out of the function at 0x%x" % a)
        e("if (%s) goto %s;" % (COND[mn[1:]], label(t)))
        return
    if mn == "jecxz":
        t = ops[0].imm
        if not (c.va <= t < c.end):
            raise Unsupported("jecxz out of the function at 0x%x" % a)
        e("if (ecx == 0u) goto %s;" % label(t))
        return
    if mn.startswith("set") and mn[3:] in COND:
        e("{ uint32_t v_ = (%s) ? 1u : 0u;" % COND[mn[3:]])
        e("  " + put(i, ops[0], "v_", 8))
        e("}")
        return
    if mn.startswith("cmov") and mn[4:] in COND:
        bits = ops[0].size * 8
        e("{ uint32_t v_ = %s;" % get(i, ops[1], bits))
        e("  if (%s) { %s }" % (COND[mn[4:]], put(i, ops[0], "v_", bits)))
        e("}")
        return
    if mn in ("shl", "sal", "shr", "sar", "rol", "ror"):
        bits = ops[0].size * 8
        cnt = "(%s & 0x1fu)" % get(i, ops[1], 8) if ops[1].type != X.X86_OP_IMM else "0x%xu" % (ops[1].imm & 0x1f)
        e("{ uint32_t a_ = %s, n_ = %s, r_;" % (get(i, ops[0], bits), cnt))
        e("  if (n_ != 0u) {")
        e("    FL41_%s(r_, a_, n_, %d);" % ({"sal": "shl"}.get(mn, mn).upper(), bits))
        e("    " + put(i, ops[0], "r_", bits))
        e("  }")
        e("}")
        return
    if mn == "imul":
        if len(ops) == 1:
            bits = ops[0].size * 8
            if bits != 32:
                raise Unsupported("byte/word one-operand imul at 0x%x" % a)
            e("{ int64_t w_ = (int64_t)(int32_t)eax * (int32_t)%s;" % get(i, ops[0], 32))
            e("  eax = (uint32_t)w_; edx = (uint32_t)((uint64_t)w_ >> 32);")
            e("  cf = of = (w_ != (int64_t)(int32_t)eax); FL41_ZSP(eax, 32); }")
            return
        bits = ops[0].size * 8
        if bits != 32:
            raise Unsupported("16-bit imul at 0x%x" % a)
        if len(ops) == 2:
            x, y = get(i, ops[0], 32), get(i, ops[1], 32)
        else:
            x, y = get(i, ops[1], 32), "0x%xu" % (ops[2].imm & 0xffffffff)
        e("{ int64_t w_ = (int64_t)(int32_t)(%s) * (int32_t)(%s); uint32_t r_ = (uint32_t)w_;" % (x, y))
        e("  cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32);")
        e("  " + put(i, ops[0], "r_", 32))
        e("}")
        return
    if mn == "mul":
        if ops[0].size != 4:
            raise Unsupported("byte/word mul at 0x%x" % a)
        e("{ uint64_t w_ = (uint64_t)eax * %s;" % get(i, ops[0], 32))
        e("  eax = (uint32_t)w_; edx = (uint32_t)(w_ >> 32);")
        e("  cf = of = (edx != 0u); FL41_ZSP(eax, 32); }")
        return
    if mn == "cdq":
        e("edx = (eax & 0x80000000u) ? 0xffffffffu : 0u;")
        return
    if mn == "cwde":
        e("eax = (uint32_t)(int32_t)(int16_t)eax;")
        return
    if mn in ("div", "idiv"):
        if ops[0].size != 4:
            raise Unsupported("byte/word %s at 0x%x" % (mn, a))
        e("{ uint32_t d_ = %s;" % get(i, ops[0], 32))
        if mn == "div":
            e("  uint64_t n_ = ((uint64_t)edx << 32) | eax;")
            e("  if (d_ == 0u || n_ / d_ > 0xffffffffull) FL41_TRAP;")
            e("  eax = (uint32_t)(n_ / d_); edx = (uint32_t)(n_ % d_); }")
        else:
            e("  int64_t n_ = (int64_t)(((uint64_t)edx << 32) | eax);")
            e("  if (d_ == 0u || (n_ == INT64_MIN && (int32_t)d_ == -1) || n_ / (int32_t)d_ > INT32_MAX || n_ / (int32_t)d_ < INT32_MIN) FL41_TRAP;")
            e("  eax = (uint32_t)(int32_t)(n_ / (int32_t)d_); edx = (uint32_t)(int32_t)(n_ % (int32_t)d_); }")
        return
    if mn in ("movsb", "movsw", "movsd", "stosb", "stosw", "stosd", "lodsb", "lodsw", "lodsd", "scasb", "scasw", "scasd", "cmpsb", "cmpsw", "cmpsd"):
        return lift_string(c, i, prefix, mn)
    if mn == "std":
        raise Unsupported("std at 0x%x" % a)
    if mn.startswith("f") and mn != "fs":
        return lift_x87(c, i, mn)
    raise Unsupported("%s at 0x%x" % (mn, a))


def st_index(i, op):
    if op.type != X.X86_OP_REG or not (X.X86_REG_ST0 <= op.reg <= X.X86_REG_ST7):
        raise Unsupported("x87 operand at 0x%x" % i.address)
    return op.reg - X.X86_REG_ST0


def mem64(i, op):
    """(low dword read, high dword read) of a qword operand"""
    addr = mem_addr(i, op)
    return "RD32(%s)" % addr, "RD32((uint32_t)(%s + 4u))" % addr


def f_load(i, op, kind):
    """C expression of the long double that the memory operand holds as float / double / int16 / int32 / int64"""
    if op.type != X.X86_OP_MEM:
        raise Unsupported("x87 operand at 0x%x" % i.address)
    n = op.size
    if kind == "f":
        if n == 4:
            return "fl41_ld_f32(fp, RD32(%s))" % mem_addr(i, op)
        if n == 8:
            lo, hi = mem64(i, op)
            return "fl41_ld_f64(fp, ((uint64_t)%s << 32) | %s)" % (hi, lo)
    else:
        if n == 2:
            return "fl41_ld_i16(fp, RD16(%s))" % mem_addr(i, op)
        if n == 4:
            return "fl41_ld_i32(fp, RD32(%s))" % mem_addr(i, op)
        if n == 8:
            lo, hi = mem64(i, op)
            return "fl41_ld_i64(fp, ((uint64_t)%s << 32) | %s)" % (hi, lo)
    raise Unsupported("x87 memory operand of %d bytes at 0x%x" % (n, i.address))


FARITH = {"fadd": ("add", False), "fsub": ("sub", False), "fsubr": ("sub", True), "fmul": ("mul", False), "fdiv": ("div", False), "fdivr": ("div", True)}


def lift_x87(c, i, mn):
    e = c.emit
    ops = i.operands
    a = i.address
    if mn == "fld":
        if ops[0].type == X.X86_OP_MEM:
            e("fl41_fpush(fp, %s);" % f_load(i, ops[0], "f"))
        else:
            e("fl41_fpush(fp, FL41_FST(fp, %d));" % st_index(i, ops[0]))
        return
    if mn == "fild":
        e("fl41_fpush(fp, %s);" % f_load(i, ops[0], "i"))
        return
    if mn in ("fst", "fstp"):
        if ops[0].type != X.X86_OP_MEM:
            raise Unsupported("%s to a register at 0x%x" % (mn, a))
        pop = "fl41_fpop(fp)" if mn == "fstp" else "FL41_FST(fp, 0)"
        if ops[0].size == 4:
            e("{ long double v_ = %s; WR32(%s, fl41_st_f32(fp, v_)); }" % (pop, mem_addr(i, ops[0])))
        elif ops[0].size == 8:
            e("{ long double v_ = %s; uint64_t w_ = fl41_st_f64(fp, v_); WR32(%s, (uint32_t)w_); WR32((uint32_t)(%s + 4u), (uint32_t)(w_ >> 32)); }" % (pop, mem_addr(i, ops[0]), mem_addr(i, ops[0])))
        else:
            raise Unsupported("%s of %d bytes at 0x%x" % (mn, ops[0].size, a))
        return
    base = mn[:-1] if mn.endswith("p") and mn[:-1] in FARITH else mn
    if base in FARITH:
        op, reverse = FARITH[base]
        pop = mn != base
        if ops and ops[0].type == X.X86_OP_MEM:
            dst, src = "FL41_FST(fp, 0)", f_load(i, ops[0], "f")
        else:
            di = st_index(i, ops[0]) if ops else 1
            si = st_index(i, ops[1]) if len(ops) > 1 else 0
            if not ops or (len(ops) == 1 and not pop):
                raise Unsupported("%s form at 0x%x" % (mn, a))
            dst, src = "FL41_FST(fp, %d)" % di, "FL41_FST(fp, %d)" % si
        e("{ long double d_ = %s, s_ = %s; %s = fl41_fx_%s(fp, %s, %s); }" % (dst, src, dst, op, "s_" if reverse else "d_", "d_" if reverse else "s_"))
        if pop:
            e("fl41_fpop(fp);")
        return
    if mn == "fchs":
        e("FL41_FST(fp, 0) = fl41_fchs(FL41_FST(fp, 0));")
        return
    if mn in ("fcom", "fcomp"):
        if ops and ops[0].type == X.X86_OP_MEM:
            e("fl41_fx_cmp(fp, FL41_FST(fp, 0), %s);" % f_load(i, ops[0], "f"))
        else:
            e("fl41_fx_cmp(fp, FL41_FST(fp, 0), FL41_FST(fp, %d));" % (st_index(i, ops[0]) if ops else 1))
        if mn == "fcomp":
            e("fl41_fpop(fp);")
        return
    if mn == "fcompp":
        e("fl41_fx_cmp(fp, FL41_FST(fp, 0), FL41_FST(fp, 1));")
        e("fl41_fpop(fp); fl41_fpop(fp);")
        return
    if mn == "fnstsw":
        if not (ops and ops[0].type == X.X86_OP_REG and reg_name(i, ops[0].reg) == "ax"):
            raise Unsupported("fnstsw operand at 0x%x" % a)
        e("eax = (eax & 0xffff0000u) | (uint32_t)fp->sw;")
        return
    raise Unsupported("%s at 0x%x" % (mn, a))


def lift_string(c, i, prefix, mn):
    e = c.emit
    kind, width = mn[:-1], {"b": 1, "w": 2, "d": 4}[mn[-1]]
    bits = width * 8
    body = {"movs": ["WR%d(edi, RD%d(esi));" % (bits, bits), "esi += %du; edi += %du;" % (width, width)],
            "stos": ["WR%d(edi, %s);" % (bits, {1: "eax & 0xffu", 2: "eax & 0xffffu", 4: "eax"}[width]), "edi += %du;" % width],
            "lods": ["%s" % {1: "eax = (eax & 0xffffff00u) | RD8(esi);", 2: "eax = (eax & 0xffff0000u) | RD16(esi);", 4: "eax = RD32(esi);"}[width],
                     "esi += %du;" % width],
            "scas": ["{ uint32_t a_ = %s, b_ = RD%d(edi), r_;" % ({1: "eax & 0xffu", 2: "eax & 0xffffu", 4: "eax"}[width], bits),
                     "  FL41_SUB(a_, b_, 0u, r_, %d); }" % bits, "edi += %du;" % width],
            "cmps": ["{ uint32_t a_ = RD%d(esi), b_ = RD%d(edi), r_;" % (bits, bits),
                     "  FL41_SUB(a_, b_, 0u, r_, %d); }" % bits, "esi += %du; edi += %du;" % (width, width)]}[kind]
    if not prefix:
        for line in body:
            e(line)
        return
    if prefix != "rep" and kind not in ("scas", "cmps"):
        raise Unsupported("%s with %s at 0x%x" % (prefix, mn, i.address))
    e("while (ecx != 0u) {")
    for line in body:
        e("    " + line)
    e("    ecx -= 1u;")
    if prefix == "repe":
        e("    if (!zf) break;")
    elif prefix == "repne":
        e("    if (zf) break;")
    e("}")


def lift(va, body_size):
    """(C source of m<va>_lifted, {callee va: bytes it pops}) or raises Unsupported."""
    ins = disasm(va, body_size)
    INDIRECT_SITES.pop(va, None)
    c = Ctx(ins, va, body_size)
    for i in ins:
        if i.mnemonic in ("jmp",) or (i.mnemonic[0] == "j") or i.mnemonic == "jecxz":
            if i.operands and i.operands[0].type == X.X86_OP_IMM and va <= i.operands[0].imm < c.end:
                c.targets.add(i.operands[0].imm)
    scratch = Ctx(ins, va, body_size)
    scratch.targets = set(c.targets)
    for i in ins:
        lift_one(scratch, i)          # first pass: collects the jump-table targets
    c.targets = scratch.targets
    for i in ins:
        if i.address in c.targets:
            c.lines.append("%s:" % label(i.address))
        mark = len(c.lines)
        lift_one(c, i)
        chunk = [x.strip() for x in c.lines[mark:]]
        del c.lines[mark:]
        note = "/* 0x%x: %s %s */" % (i.address, i.mnemonic, i.op_str.replace("*/", "* /"))
        if not chunk:
            c.emit(note)
        elif len(chunk) == 1 or (not any(x.startswith(("while", "switch", "case", "default", "fl41_f", "FL41_FST")) for x in chunk) and sum(len(x) for x in chunk) < 200):
            c.emit(" ".join(chunk) + "  " + note)
        else:
            c.emit(note)
            c.lines.extend("    " + x for x in chunk)
    head = ["/* GAME.EXE 0x%x (%d bytes): machine translation of the original instructions, see the note at the top of this file. */" % (va, body_size),
            "void m%x_lifted(Fl41Regs *r, const Fl41Host *h)" % va, "{",
            "    FL41_PROLOGUE",
            ] + (["    FL41_FPU_PROLOGUE"] if c.fpu else [])
    tail = ["done:", "    FL41_EPILOGUE"] + (["    FL41_FPU_EPILOGUE"] if c.fpu else []) + ["}"]
    fs = any(any(op.type == X.X86_OP_MEM and op.mem.segment == X.X86_REG_FS for op in i.operands) for i in ins)
    return "\n".join(head + c.lines + tail) + "\n", dict(c.callees), dict(c.imports), fs, set(c.inline)


def census():
    entries = json.load(open(PROJECT / "function-ledger.json"))["entries"]
    reasons, ok = {}, []
    for e in entries:
        va = int(e["va"], 16)
        if e["status"] != "pending" or e["region"] != "game" or va < 0x480000:
            continue
        if e["derived_parts"]:
            reasons[e["va"]] = "derived parts"
            continue
        try:
            lift(va, e["body_size"] or e["span"])
            ok.append(e["va"])
        except Unsupported as ex:
            reasons[e["va"]] = str(ex)
    print("lifted:", len(ok))
    import collections
    print(collections.Counter(re.sub(r"0x[0-9a-f]+", "N", v) for v in reasons.values()).most_common(40))
    return ok, reasons


if __name__ == "__main__":
    if sys.argv[1:] == ["--census"]:
        census()
    else:
        for arg in sys.argv[1:]:
            va = int(arg, 16)
            print(lift(va, ledger_spans()[va])[0])
