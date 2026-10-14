#!/usr/bin/env python3
"""Generate annotated-ready Intel-syntax GNU assembly for original x86 functions.

Packet M03 (Track M, tool-assisted assembly).  For every indexed function this
tool

* splits the function's span (entry up to the next indexed start) into its code
  part, its switch/index tables and its trailing padding by following the
  function's own control flow, never by a linear sweep alone;
* renders the code part as Intel-syntax GNU assembly that reassembles
  byte-exactly with the pinned ``i686-w64-mingw32-as`` 2.43.1, using only
  mnemonics, the ``{load}``/``{store}`` and ``{disp8}``/``{disp32}`` prefixes,
  the ``.d8``/``.d32`` branch suffixes and the five ``.insn`` spellings of
  section 5 of the M0 report;
* renders the tables and padding as separate data items with their own labels;
* in census mode, reassembles all 4,188 functions and reports the exceptions.

Nothing here claims original C++ or compiler provenance.  The tool reads the
owner's local ``GAME.EXE`` and ``llvm-objdump``; it never writes original bytes
to a tracked file (only hashes and mnemonic assembly).
"""

from __future__ import annotations

import argparse
import bisect
import collections
import hashlib
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Iterable, Optional

PROJECT = Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
WORK = REPOSITORY / "work"
ORIGINAL_DEFAULT = WORK / "original/GAME.EXE"
AS_DEFAULT = WORK / "tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
FUNCTION_INDEX = PROJECT / "function-index.json"

ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
ASSEMBLER_VERSION = "2.43.1"
TEXT_VA = 0x401000
TEXT_SIZE = 0x12825A
TEXT_FILE_OFFSET = 0x1000
REGION_VORBIS_START = 0x4FCEF0
REGION_CRT_MFC_START = 0x50BF50

UNFILLED = "<unfilled>"
CLASS_NAME = "tool_assisted_reconstructed_assembly"

# ---------------------------------------------------------------------------
# Original image
# ---------------------------------------------------------------------------


@dataclass
class Image:
    """The ``.text`` bytes and function starts the generator works on."""

    text: bytes
    base: int
    starts: list[int]
    evidence: dict[int, str] = field(default_factory=dict)
    derived_starts: set[int] = field(default_factory=set)
    extra_reader: Any = None  # callable (va, size) -> bytes for other sections

    def __post_init__(self) -> None:
        self.starts = sorted(set(self.starts))

    @property
    def end(self) -> int:
        return self.base + len(self.text)

    def span(self, va: int) -> tuple[int, int]:
        index = bisect.bisect_left(self.starts, va)
        if index >= len(self.starts) or self.starts[index] != va:
            raise KeyError(f"0x{va:08x} is not an indexed function start")
        end = self.starts[index + 1] if index + 1 < len(self.starts) else self.end
        return va, end

    def bytes_at(self, start: int, end: int) -> bytes:
        return self.text[start - self.base : end - self.base]

    def read_anywhere(self, va: int, size: int) -> Optional[bytes]:
        """Bytes at ``va`` in .text or (for jump tables) another section."""

        if self.base <= va and va + size <= self.end:
            return self.bytes_at(va, va + size)
        if self.extra_reader is not None:
            return self.extra_reader(va, size)
        return None


def load_image(
    original: Path = ORIGINAL_DEFAULT,
    index_path: Path = FUNCTION_INDEX,
    expected_sha256: str = ORIGINAL_SHA256,
    strict: bool = True,
) -> Image:
    """Load ``.text`` and the function starts.

    ``strict`` pins the real game's section layout; tests pass ``strict=False``
    with a synthetic PE and index.
    """

    data = original.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    if digest != expected_sha256:
        raise SystemExit(f"{original}: SHA-256 {digest} is not the pinned original")
    pe = struct.unpack_from("<I", data, 0x3C)[0]
    sections = struct.unpack_from("<H", data, pe + 6)[0]
    optional = struct.unpack_from("<H", data, pe + 20)[0]
    image_base = struct.unpack_from("<I", data, pe + 24 + 28)[0]
    table = pe + 24 + optional
    text = None
    base = TEXT_VA
    layout = []
    for i in range(sections):
        name, vsize, va, rsize, rptr = struct.unpack_from("<8sIIII", data, table + 40 * i)
        layout.append((image_base + va, min(vsize, rsize), rptr))
        if name.rstrip(b"\0") == b".text":
            if strict and (va != TEXT_VA - 0x400000 or vsize != TEXT_SIZE or rptr != TEXT_FILE_OFFSET):
                raise SystemExit("unexpected .text layout")
            text = data[rptr : rptr + vsize]
            base = image_base + va
    if text is None:
        raise SystemExit("no .text section")
    index = json.loads(index_path.read_text(encoding="utf-8"))
    if index.get("original_sha256") != expected_sha256:
        raise SystemExit("function-index.json is for a different original")
    starts = [int(item["address"], 16) for item in index["functions"]]
    evidence = {int(item["address"], 16): item.get("evidence_id", UNFILLED) for item in index["functions"]}

    def reader(va: int, size: int) -> Optional[bytes]:
        for sbase, length, ptr in layout:
            if sbase <= va and va + size <= sbase + length:
                return data[ptr + va - sbase : ptr + va - sbase + size]
        return None

    return Image(text=text, base=base, starts=starts, evidence=evidence, extra_reader=reader)


def region_of(va: int) -> str:
    if va < REGION_VORBIS_START:
        return "game"
    if va < REGION_CRT_MFC_START:
        return "vorbis"
    return "crt_mfc"


# ---------------------------------------------------------------------------
# llvm-objdump layer
# ---------------------------------------------------------------------------


def build_elf(text: bytes, base: int, symbols: Iterable[int]) -> bytes:
    """Wrap ``text`` in an ET_REL ELF whose function symbols split the sweep."""

    starts = sorted(set(symbols))
    ends = starts[1:] + [base + len(text)]
    strtab = b"\0"
    entries = [b"\0" * 16]
    for start, end in zip(starts, ends):
        name = b"f%x" % start
        offset = len(strtab)
        strtab += name + b"\0"
        entries.append(struct.pack("<IIIBBH", offset, start - base, end - start, 0x12, 0, 1))
    symtab = b"".join(entries)
    shstr = b"\0.text\0.symtab\0.strtab\0.shstrtab\0"
    off_text = 0x34
    off_sym = (off_text + len(text) + 3) & ~3
    off_str = off_sym + len(symtab)
    off_shs = off_str + len(strtab)
    off_sh = (off_shs + len(shstr) + 3) & ~3

    def section(name, kind, flags, addr, offset, size, link=0, info=0, entsize=0):
        return struct.pack("<IIIIIIIIII", name, kind, flags, addr, offset, size, link, info, 1, entsize)

    headers = (
        section(0, 0, 0, 0, 0, 0)
        + section(1, 1, 6, base, off_text, len(text))
        + section(7, 2, 0, 0, off_sym, len(symtab), 3, 1, 16)
        + section(15, 3, 0, 0, off_str, len(strtab))
        + section(23, 3, 0, 0, off_shs, len(shstr))
    )
    header = b"\x7fELF" + bytes([1, 1, 1, 0]) + b"\0" * 8 + struct.pack(
        "<HHIIIIIHHHHHH", 1, 3, 1, 0, 0, off_sh, 0, 52, 0, 0, 40, 5, 4
    )
    out = bytearray(header) + text
    out += b"\0" * (off_sym - len(out)) + symtab + strtab + shstr
    out += b"\0" * (off_sh - len(out)) + headers
    return bytes(out)


@dataclass
class Insn:
    addr: int
    raw: bytes
    mnem: str
    ops: str

    @property
    def end(self) -> int:
        return self.addr + len(self.raw)

    @property
    def text(self) -> str:
        return f"{self.mnem} {self.ops}".strip()


_LINE = re.compile(r"^\s+([0-9a-f]+):\s+((?:[0-9a-f]{2} )*[0-9a-f]{2})\s*\t(.*)$")


def find_objdump() -> list[str]:
    found = shutil.which("llvm-objdump")
    if found:
        return [found]
    return ["xcrun", "llvm-objdump"]


def disassemble(image: Image, symbols: Iterable[int]) -> dict[int, Insn]:
    """Sweep every symbol range with llvm-objdump; return address -> Insn."""

    with tempfile.TemporaryDirectory() as tmp:
        elf = Path(tmp) / "text.elf"
        elf.write_bytes(build_elf(image.text, image.base, symbols))
        result = subprocess.run(
            find_objdump() + ["-d", "--x86-asm-syntax=intel", "--print-imm-hex", str(elf)],
            capture_output=True,
            text=True,
            check=True,
        )
    decoded: dict[int, Insn] = {}
    for line in result.stdout.splitlines():
        match = _LINE.match(line)
        if not match:
            continue
        addr = int(match.group(1), 16)
        raw = bytes.fromhex(match.group(2).replace(" ", ""))
        body = match.group(3).split("#")[0].rstrip()
        mnem, _, ops = body.partition("\t")
        mnem = mnem.strip()
        ops = ops.strip().replace("\t", " ")
        ops = re.sub(r"\s+<[^>]*>$", "", ops)
        decoded[addr] = Insn(addr, raw, mnem, ops)
    return decoded


# ---------------------------------------------------------------------------
# Instruction classification
# ---------------------------------------------------------------------------

_COND_JUMPS = {
    "ja", "jae", "jb", "jbe", "jc", "je", "jg", "jge", "jl", "jle", "jna", "jnae", "jnb", "jnbe",
    "jnc", "jne", "jng", "jnge", "jnl", "jnle", "jno", "jnp", "jns", "jnz", "jo", "jp", "jpe", "jpo",
    "js", "jz", "jecxz", "jcxz", "loop", "loope", "loopne", "loopz", "loopnz",
}
_TERMINAL = {"ret", "retf", "lret", "iret", "iretd", "hlt", "ud2", "ljmp"}
_DIRECT = re.compile(r"^0x([0-9a-f]+)$")
_TABLE_JUMP = re.compile(r"^dword ptr \[(?:4\*(e[a-z]{2})|(e[a-z]{2})\*4) \+ 0x([0-9a-f]+)\]$")
_INDEX_LOAD = re.compile(r"^(e[a-z]{2}|[a-d]l), byte ptr \[(e[a-z]{2}) \+ 0x([0-9a-f]+)\]$")
_CMP_IMM = re.compile(r"^(?:dword ptr \[[^\]]+\]|e[a-z]{2}|[a-d][lx]|[a-d]h), 0x([0-9a-f]+)$")


def direct_target(ins: Insn) -> Optional[int]:
    match = _DIRECT.match(ins.ops)
    if match and (ins.mnem in _COND_JUMPS or ins.mnem in ("jmp", "call")):
        return int(match.group(1), 16)
    return None


def is_cond_jump(ins: Insn) -> bool:
    return ins.mnem in _COND_JUMPS


def is_terminal(ins: Insn) -> bool:
    return ins.mnem in _TERMINAL or ins.mnem == "jmp"


# ---------------------------------------------------------------------------
# Control-flow analysis: code / tables / padding
# ---------------------------------------------------------------------------


@dataclass
class DataItem:
    kind: str  # switch_table | index_table | padding
    va: int
    size: int
    count: int = 0
    targets: list[int] = field(default_factory=list)  # switch_table: case addresses
    values: list[int] = field(default_factory=list)  # index_table: byte values
    fill: int = 0xCC  # padding byte
    lines: list[str] = field(default_factory=list)  # padding made of nop-equivalent instructions

    @property
    def end(self) -> int:
        return self.va + self.size


@dataclass
class Layout:
    va: int
    span_end: int
    code_end: int = 0
    insns: list[Insn] = field(default_factory=list)  # code part in address order
    reachable: set[int] = field(default_factory=set)
    data: list[DataItem] = field(default_factory=list)
    internal_targets: set[int] = field(default_factory=set)
    external_targets: set[int] = field(default_factory=set)
    exceptions: list[str] = field(default_factory=list)
    need_symbols: set[int] = field(default_factory=set)
    notes: list[str] = field(default_factory=list)
    falls_through: bool = False  # last instruction runs into the next function
    derived: bool = False  # entry found by the span split, not in function-index.json
    next_entry: int = 0  # unindexed code starting here ends this layout's span

    @property
    def code_size(self) -> int:
        return self.code_end - self.va

    @property
    def table_bytes(self) -> int:
        return sum(item.size for item in self.data if item.kind != "padding")

    @property
    def padding_bytes(self) -> int:
        return sum(item.size for item in self.data if item.kind == "padding")

    def data_by_kind(self, kind: str) -> list[DataItem]:
        return [item for item in self.data if item.kind == kind]


def _previous(order: list[int], decoded: "Decoded", addr: int, count: int) -> list[Insn]:
    index = bisect.bisect_left(order, addr)
    return [decoded[a] for a in order[max(0, index - count) : index]]


class Decoded:
    """llvm-objdump instructions keyed by address, with a sorted address list."""

    def __init__(self, insns: dict[int, Insn]) -> None:
        self.map = insns
        self.order = sorted(insns)

    def __contains__(self, addr: int) -> bool:
        return addr in self.map

    def get(self, addr: int) -> Optional[Insn]:
        return self.map.get(addr)

    def __getitem__(self, addr: int) -> Insn:
        return self.map[addr]


def analyze(image: Image, va: int, decoded: "Decoded", span_end: Optional[int] = None, known_targets: frozenset = frozenset()) -> Layout:
    """Split the span of the function at ``va`` into code, tables and padding."""

    if span_end is None:
        start, span_end = image.span(va)
    else:
        start = va
    layout = Layout(va=start, span_end=span_end, derived=va not in image.starts)
    order = decoded.order

    reached: dict[int, Insn] = {}
    work = [start]
    tables: dict[int, dict[str, Any]] = {}  # dword table VA -> info
    index_tables: dict[int, dict[str, Any]] = {}
    exceptions = layout.exceptions

    def bytes_dword(addr: int) -> int:
        return struct.unpack_from("<I", image.text, addr - image.base)[0]

    def add_target(addr: int, origin: str) -> None:
        if not (start <= addr < span_end):
            layout.external_targets.add(addr)
            return
        if addr not in decoded:
            layout.need_symbols.add(addr)
            return
        layout.internal_targets.add(addr)
        work.append(addr)

    def explore() -> None:
        while work:
            addr = work.pop()
            while True:
                if addr in reached:
                    break
                if not (start <= addr < span_end):
                    layout.external_targets.add(addr)
                    break
                ins = decoded.get(addr)
                if ins is None:
                    layout.need_symbols.add(addr)
                    break
                if ins.mnem == "int3":
                    layout.notes.append(f"flow_reaches_int3:0x{addr:08x}")
                    break
                if ins.mnem == "<unknown>" or ins.mnem.startswith("."):
                    exceptions.append(f"reachable_undecodable:0x{addr:08x}")
                    break
                if ins.end > span_end:
                    exceptions.append(f"instruction_crosses_span_end:0x{addr:08x}")
                    break
                reached[addr] = ins
                target = direct_target(ins)
                if is_cond_jump(ins):
                    if target is not None:
                        add_target(target, "jcc")
                    addr = ins.end
                    continue
                if ins.mnem == "jmp":
                    if target is not None:
                        add_target(target, "jmp")
                    else:
                        match = _TABLE_JUMP.match(ins.ops)
                        if match:
                            _register_table(image, start, span_end, order, decoded, ins, match, tables, index_tables, exceptions)
                    break
                if ins.mnem in _TERMINAL:
                    break
                if ins.mnem == "call":
                    # a call is an interprocedural edge: record the callee, do not absorb it into this extent
                    if target is not None:
                        if target == start:
                            layout.internal_targets.add(target)
                        else:
                            layout.external_targets.add(target)
                    nxt = ins.end
                    if nxt >= span_end or image.text[nxt - image.base] == 0xCC or nxt in tables or nxt in index_tables:
                        layout.notes.append(f"call_without_fallthrough:0x{addr:08x}")
                        break
                addr = ins.end
            # table case targets are queued once their size is known
            for info in tables.values():
                if not info["queued"] and info["targets"] is not None:
                    info["queued"] = True
                    for case in info["targets"]:
                        add_target(case, "case")


    explore()
    # Code between reachable instructions that nothing in the function falls or
    # branches into (alternate entries of shared tails, dead branches) is still
    # part of the function: decode it and follow it like any other code.
    gap_checked: set[int] = set()
    while not layout.need_symbols and reached:
        gap_starts = []
        cursor = start
        for a in sorted(reached):
            if a > cursor and cursor not in gap_checked:
                gap_starts.append(cursor)
            cursor = max(cursor, reached[a].end)
        if not gap_starts:
            break
        for lo in gap_starts:
            gap_checked.add(lo)
            if _in_table(lo, tables, index_tables):
                continue
            if lo in decoded:
                layout.notes.append(f"unreachable_code_entry:0x{lo:08x}")
                work.append(lo)
            else:
                layout.need_symbols.add(lo)
        explore()

    if layout.need_symbols:
        return layout  # caller adds resync symbols and runs again

    # --- extent -----------------------------------------------------------
    if not reached:
        exceptions.append("no_reachable_code")
        return layout
    code_end = max(ins.end for ins in reached.values())
    layout.code_end = code_end

    # tables must not overlap reached instructions
    regions: list[tuple[int, int, str]] = []
    for T, info in tables.items():
        if info["targets"] is None:
            exceptions.append(f"switch_table_size_unknown:0x{T:08x}")
            continue
        if info.get("in_text_span", True):
            regions.append((T, T + 4 * len(info["targets"]), "switch_table"))
        else:
            layout.notes.append(f"switch_table_outside_text:0x{T:08x}")
    for IDX, info in index_tables.items():
        if info["values"] is None:
            exceptions.append(f"index_table_size_unknown:0x{IDX:08x}")
            continue
        regions.append((IDX, IDX + len(info["values"]), "index_table"))
    regions.sort()
    for lo, hi, kind in regions:
        if any(lo <= a < hi for a in reached):
            exceptions.append(f"{kind}_overlaps_reachable_code:0x{lo:08x}")
        if lo < code_end:
            exceptions.append(f"{kind}_inside_code_extent:0x{lo:08x}")

    # --- gap code (unreachable instructions between reachable ones) ----------
    insns = dict(reached)
    cursor = start
    for a in sorted(reached):
        if a > cursor:
            gap = _gap_instructions(decoded, cursor, a)
            if gap is None:
                exceptions.append(f"undecodable_gap:0x{cursor:08x}-0x{a:08x}")
            else:
                for g in gap:
                    insns[g.addr] = g
        cursor = max(cursor, reached[a].end)
    layout.reachable = set(reached)
    layout.insns = [insns[a] for a in sorted(insns)]

    # --- tail: tables, padding, or the start of further unindexed code -------
    tail = code_end
    by_start = {lo: (hi, kind) for lo, hi, kind in regions}
    while tail < span_end:
        if tail in by_start:
            hi, kind = by_start[tail]
            info = tables[tail] if kind == "switch_table" else index_tables[tail]
            if kind == "switch_table":
                layout.data.append(DataItem(kind, tail, hi - tail, count=len(info["targets"]), targets=list(info["targets"])))
            else:
                layout.data.append(DataItem(kind, tail, hi - tail, count=len(info["values"]), values=list(info["values"])))
            tail = hi
            continue
        if tail in layout.external_targets or tail in known_targets:
            layout.next_entry = tail  # a direct call or jump enters here: this is a function start, not padding
            layout.span_end = tail
            layout.notes.append(f"further_unindexed_code_at:0x{tail:08x}")
            break
        fill = image.text[tail - image.base]
        if fill in (0xCC, 0x90):
            end = tail
            while end < span_end and image.text[end - image.base] == fill and end not in by_start and end not in layout.external_targets and end not in known_targets:
                end += 1
            layout.data.append(DataItem("padding", tail, end - tail, fill=fill))
            tail = end
            continue
        pad_lines: list[str] = []
        end = tail
        while end < span_end and end not in by_start and end not in layout.external_targets and end not in known_targets:
            found = nop_like(image.text, end - image.base)
            if found is None or end + found[0] > span_end:
                break
            pad_lines.append(found[1])
            end += found[0]
        if pad_lines:
            layout.data.append(DataItem("padding", tail, end - tail, fill=-1, lines=pad_lines))
            tail = end
            continue
        layout.next_entry = tail
        layout.span_end = tail
        layout.notes.append(f"further_unindexed_code_at:0x{tail:08x}")
        break
    if tail > span_end:
        exceptions.append(f"table_beyond_span:0x{tail:08x}")

    # terminal check
    last = max(reached.values(), key=lambda i: i.addr)
    if not (is_terminal(last) or last.mnem == "call" or last.mnem.startswith("int")):
        if last.end == layout.span_end:
            layout.notes.append(f"falls_through_to:0x{layout.span_end:08x}")
            layout.falls_through = True
        else:
            exceptions.append(f"code_not_terminated:0x{last.addr:08x}")
    return layout


_REG32 = ["eax", "ecx", "edx", "ebx", "esp", "ebp", "esi", "edi"]


def nop_like(text: bytes, i: int) -> Optional[tuple[int, str]]:
    """Length and Intel source of an alignment instruction at ``text[i]``.

    The recognised forms are the ones compilers and assemblers emit as
    padding: ``nop``, ``int3``, ``mov r, r`` and ``lea r, [r + 0]`` in its
    encodings, and nothing else.
    """

    n = len(text)
    op = text[i]
    if op == 0x90:
        return 1, "nop"
    if op == 0xCC:
        return 1, "int3"
    if i + 1 >= n:
        return None
    modrm = text[i + 1]
    mod, reg, rm = modrm >> 6, (modrm >> 3) & 7, modrm & 7
    if op in (0x8B, 0x89) and mod == 3 and reg == rm:
        hint = "{load}" if op == 0x8B else "{store}"
        return 2, f"{hint} mov {_REG32[reg]}, {_REG32[reg]}"
    if op == 0x8D and mod != 3:
        r = _REG32[reg]
        if rm != 4 and rm == reg:
            if mod == 0 and rm != 5:
                return 2, f"lea {r}, [{r}]"
            if mod == 1 and i + 2 < n and text[i + 2] == 0:
                return 3, f"{{disp8}} lea {r}, [{r}]"
            if mod == 2 and text[i + 2 : i + 6] == b"\0\0\0\0":
                return 6, f"{{disp32}} lea {r}, [{r}]"
        if rm == 4 and reg == 4 and i + 2 < n and text[i + 2] == 0x24:
            if mod == 0:
                return 3, "lea esp, [esp]"
            if mod == 1 and i + 3 < n and text[i + 3] == 0:
                return 4, "{disp8} lea esp, [esp]"
            if mod == 2 and text[i + 3 : i + 7] == b"\0\0\0\0":
                return 7, "{disp32} lea esp, [esp]"
    return None


def _in_table(addr: int, tables: dict[int, dict[str, Any]], index_tables: dict[int, dict[str, Any]]) -> bool:
    for T, info in tables.items():
        if info["targets"] is not None and info.get("in_text_span", True) and T <= addr < T + 4 * len(info["targets"]):
            return True
    for IDX, info in index_tables.items():
        if info["values"] is not None and IDX <= addr < IDX + len(info["values"]):
            return True
    return False


def _gap_instructions(decoded: dict[int, Insn], lo: int, hi: int) -> Optional[list[Insn]]:
    out = []
    addr = lo
    while addr < hi:
        ins = decoded.get(addr)
        if ins is None or ins.mnem == "<unknown>" or ins.end > hi:
            return None
        out.append(ins)
        addr = ins.end
    return out


def _register_table(image, start, span_end, order, decoded, ins, match, tables, index_tables, exceptions) -> None:
    T = int(match.group(3), 16)
    if T in tables:
        return
    prior = _previous(order, decoded, ins.addr, 12)
    index_load = None
    jump_reg = match.group(1) or match.group(2)
    if prior:
        m = _INDEX_LOAD.match(prior[-1].ops) if prior[-1].mnem in ("movzx", "movsx", "mov") else None
        if m and m.group(1)[-1] == "l" and len(m.group(1)) == 2:
            if "e" + m.group(1)[0] + "x" != jump_reg:
                m = None
        elif m and m.group(1) != jump_reg:
            m = None
        if m:
            index_load = (prior[-1], m)
    guard = None
    for pos in range(len(prior) - 1, -1, -1):
        cand = prior[pos]
        if cand.mnem == "cmp":
            m = _CMP_IMM.match(cand.ops)
            if m:
                # flag-neutral instructions may sit between the compare and its branch
                nxt = pos + 1
                while nxt < len(prior) and prior[nxt].mnem in ("mov", "lea", "push", "pop") and nxt - pos <= 3:
                    nxt += 1
                if nxt < len(prior) and prior[nxt].mnem in ("ja", "jae", "jg", "jge"):
                    guard = (int(m.group(1), 16), prior[nxt].mnem)
                    break
        elif cand.mnem == "and":
            m = re.match(rf"^({jump_reg}), 0x([0-9a-f]+)$", cand.ops)
            if m:
                mask = int(m.group(2), 16)
                if mask & (mask + 1) == 0:
                    guard = (mask, "mask")
                    break
    info: dict[str, Any] = {"queued": False, "targets": None}
    tables[T] = info
    if guard is None:
        exceptions.append(f"switch_guard_not_found:0x{ins.addr:08x}")
        return
    limit, kind = guard
    entries = limit + 1 if kind in ("ja", "jg", "mask") else limit
    if index_load is not None:
        IDX = int(index_load[1].group(3), 16)
        if not (start <= IDX < span_end) or IDX + entries > span_end:
            exceptions.append(f"index_table_outside_span:0x{IDX:08x}")
            return
        values = list(image.bytes_at(IDX, IDX + entries))
        index_tables[IDX] = {"values": values}
        count = max(values) + 1
    else:
        count = entries
    in_text_span = start <= T < span_end
    if in_text_span and T + 4 * count > span_end:
        exceptions.append(f"switch_table_outside_span:0x{T:08x}")
        return
    blob = image.read_anywhere(T, 4 * count)
    if blob is None:
        exceptions.append(f"switch_table_unreadable:0x{T:08x}")
        return
    targets = [struct.unpack_from("<I", blob, 4 * k)[0] for k in range(count)]
    for case in targets:
        if not (start <= case < span_end):
            exceptions.append(f"switch_target_outside_span:0x{T:08x}:0x{case:08x}")
            return
    info["in_text_span"] = in_text_span
    info["targets"] = targets
    if index_load is not None:
        pass


def analyze_all(image: Image, vas: Optional[list[int]] = None, max_rounds: int = 10) -> tuple[dict[int, Layout], "Decoded"]:
    """Analyze functions to a fixpoint of resync symbols and derived entries.

    Returns layouts for the requested functions plus any unindexed function the
    span split discovers (``Layout.derived``).
    """

    # Direct targets from every indexed function matter for tail classification, so the whole index is always
    # analyzed; ``vas`` only names the results the caller wants (all layouts are returned).
    requested = list(dict.fromkeys(list(image.starts) + (list(vas) if vas is not None else [])))
    symbols: set[int] = set(image.starts)
    known: set[int] = set()  # direct call/jump targets seen in any layout, shared across spans
    layouts: dict[int, Layout] = {}
    decoded = Decoded({})
    for _ in range(max_rounds):
        decoded = Decoded(disassemble(image, symbols))
        layouts = {}
        changed = False
        queue: list[tuple[int, Optional[int]]] = [(va, None) for va in requested]
        while queue:
            va, limit = queue.pop(0)
            layout = analyze(image, va, decoded, limit, frozenset(known))
            layouts[va] = layout
            if layout.need_symbols:
                new = layout.need_symbols - symbols
                if new:
                    symbols |= new
                    changed = True
            if layout.next_entry:
                if layout.next_entry not in symbols:
                    symbols.add(layout.next_entry)
                    changed = True
                parent_end = limit if limit is not None else image.span(va)[1]
                queue.append((layout.next_entry, parent_end))
        if not changed:
            targets = {t for lay in layouts.values() if not lay.exceptions for t in lay.external_targets}
            if targets <= known:
                break
            known |= targets  # classify tail padding again knowing every direct entry
    else:
        for layout in layouts.values():
            if layout.need_symbols:
                layout.exceptions.append(f"unresolved_targets:{sorted(hex(a) for a in layout.need_symbols)}")
    image.derived_starts = {va for va, layout in layouts.items() if layout.derived}
    return layouts, decoded


# ---------------------------------------------------------------------------
# Rendering: instruction text -> GNU as (Intel) with encoding hints
# ---------------------------------------------------------------------------

_PREFIX = {0x66, 0x67, 0xF0, 0xF2, 0xF3, 0x2E, 0x36, 0x3E, 0x26, 0x64, 0x65}
_ONE_MODRM = (
    set(range(0x00, 0x04)) | set(range(0x08, 0x0C)) | set(range(0x10, 0x14)) | set(range(0x18, 0x1C))
    | set(range(0x20, 0x24)) | set(range(0x28, 0x2C)) | set(range(0x30, 0x34)) | set(range(0x38, 0x3C))
    | {0x62, 0x63, 0x69, 0x6B} | set(range(0x80, 0x90)) | {0xC0, 0xC1, 0xC4, 0xC5, 0xC6, 0xC7}
    | set(range(0xD0, 0xD4)) | set(range(0xD8, 0xE0)) | {0xF6, 0xF7, 0xFE, 0xFF}
)
_TWO_NO_MODRM = (
    set(range(0x80, 0x90))
    | {0xA2, 0x31, 0x05, 0x34, 0x35, 0x0B, 0x08, 0x09, 0x77, 0xA0, 0xA1, 0xA8, 0xA9, 0x30, 0x32, 0x33, 0x06, 0x07, 0x0D, 0x0E, 0x0F}
    | set(range(0xC8, 0xD0))
)
_LOAD = {0x8B, 0x8A, 0x86, 0x87, 0x02, 0x03, 0x0A, 0x0B, 0x12, 0x13, 0x1A, 0x1B, 0x22, 0x23, 0x2A, 0x2B, 0x32, 0x33, 0x3A, 0x3B}
_STORE = {0x89, 0x88, 0x00, 0x01, 0x08, 0x09, 0x10, 0x11, 0x18, 0x19, 0x20, 0x21, 0x28, 0x29, 0x30, 0x31, 0x38, 0x39}
_ACC_IMM = {0x05, 0x0D, 0x25, 0x2D, 0x3D}
_R16_TO_R32 = {"ax": "eax", "cx": "ecx", "dx": "edx", "bx": "ebx", "sp": "esp", "bp": "ebp", "si": "esi", "di": "edi"}


class Inexpressible(Exception):
    pass


def _decode_shape(raw: bytes):
    """Return (prefix_count, opcode bytes, modrm or None, disp size, disp value, sib)."""

    i = 0
    while i < len(raw) and raw[i] in _PREFIX:
        i += 1
    if i >= len(raw):
        return i, b"", None, 0, 0, None
    if raw[i] == 0x0F:
        op = raw[i : i + 2]
        has = len(op) == 2 and op[1] not in _TWO_NO_MODRM
        j = i + 2
    else:
        op = raw[i : i + 1]
        has = op[0] in _ONE_MODRM
        j = i + 1
    if not has or j >= len(raw):
        return i, op, None, 0, 0, None
    modrm = raw[j]
    mod, rm = modrm >> 6, modrm & 7
    k = j + 1
    dsz = 0
    sib = None
    if mod != 3:
        if rm == 4 and k < len(raw):
            sib = raw[k]
            k += 1
            if mod == 0 and (sib & 7) == 5:
                dsz = 4
        if mod == 1:
            dsz = 1
        elif mod == 2:
            dsz = 4
        elif mod == 0 and rm == 5:
            dsz = 4
    dv = 0
    if dsz == 1 and k < len(raw):
        dv = struct.unpack_from("<b", raw, k)[0]
    elif dsz == 4 and k + 4 <= len(raw):
        dv = struct.unpack_from("<i", raw, k)[0]
    return i, op, modrm, dsz, dv, sib


_EBP_DISP = re.compile(r"\[ebp(?P<index>(?: \+ (?:[248]\*)?e[a-z]{2})?) (?P<sign>[+-]) 0x(?P<mag>[0-9a-f]+)\]")


def encode_hints(ins: Insn, text: str) -> str:
    """Return the GNU as source for one non-branch instruction, with hints."""

    raw = ins.raw
    nprefix, op, modrm, dsz, dv, sib = _decode_shape(raw)
    has66 = 0x66 in raw[:nprefix]

    # .insn spellings (M0 report, section 5)
    if len(op) == 1 and op[0] in _ACC_IMM and has66 and len(raw) == 4:
        return f".insn 0x66, 0x{op[0]:02x}, 0x{struct.unpack_from('<H', raw, 2)[0]:04x}{{:u16}}"
    if len(op) == 1 and op[0] == 0x05 and not has66 and len(raw) == 5 and struct.unpack_from("<i", raw, 1)[0] in range(-128, 128):
        return f".insn 0x05, 0x{struct.unpack_from('<I', raw, 1)[0]:08x}{{:u32}}"
    if len(op) == 1 and op[0] == 0xDC and modrm == 0xC0:
        return ".insn 0xdc, 0xc0"
    if len(op) == 1 and op[0] == 0x81 and has66 and modrm is not None and len(raw) >= 5:
        imm = struct.unpack_from("<h", raw, len(raw) - 2)[0]
        digit = (modrm >> 3) & 7
        if (modrm >> 6) == 3:
            reg = re.match(r"\w+ (\w+),", text)
            r32 = _R16_TO_R32.get(reg.group(1)) if reg else None
            if r32:
                return f".insn 0x6681/{digit}, {r32}, {imm}{{:s16}}"
        else:
            mem = re.match(r"\w+ word ptr (\[[^\]]+\]),", text)
            if mem:
                return f".insn 0x6681/{digit}, dword ptr {mem.group(1)}, {imm}{{:s16}}"
        raise Inexpressible(f"66 81 form not expressible: {text}")

    hint = ""
    if modrm is not None:
        mod = modrm >> 6
        if mod == 3 and len(op) == 1:
            if op[0] in _LOAD:
                hint = "{load} "
            elif op[0] in _STORE:
                hint = "{store} "
        elif mod == 2 and -128 <= dv < 128 and dsz == 4:
            hint = "{disp32} "
        elif mod == 1 and dv == 0 and dsz == 1:
            hint = "{disp8} "
    return hint + text


def frame_symbol(sign: str, magnitude: int) -> str:
    return f"{'arg' if sign == '+' else 'local'}_{magnitude:x}"


@dataclass
class Rendered:
    text: str
    frame: dict[str, tuple[str, int]]  # symbol -> (sign, magnitude)
    externals: dict[int, str]  # target VA -> symbol
    hint_counts: collections.Counter
    insn_count: int


def label_for(addr: int) -> str:
    return f"L_{addr:08x}"


def external_symbol(image: Image, target: int) -> str:
    if target in image.starts or target in image.derived_starts:
        return f"FUN_{target:08x}"
    return f"LOC_{target:08x}"


def render_instruction(image: Image, layout: Layout, ins: Insn, tables: dict[int, str], externals: dict[int, str],
                       frame: dict[str, tuple[str, int]], hints: collections.Counter) -> str:
    text = ins.text
    target = direct_target(ins)
    if target is not None:
        if layout.va <= target < layout.code_end:
            name = label_for(target)
        else:
            name = externals.setdefault(target, external_symbol(image, target))
        if ins.mnem == "call":
            return f"call {name}"
        if ins.mnem in ("jmp",) or ins.mnem in _COND_JUMPS:
            if ins.mnem in ("jecxz", "jcxz") or ins.mnem.startswith("loop"):
                return f"{ins.mnem} {name}"
            short = ins.raw[0] == 0xEB or 0x70 <= ins.raw[0] <= 0x7F
            suffix = ".d8" if short else ".d32"
            hints[suffix] += 1
            if short and name not in (label_for(target),):
                # GNU as cannot size a short branch to an expression symbol
                # (it falls back to rel32); a location-relative operand keeps
                # the original encoding.  The symbol stays in the comment.
                disp = target - ins.addr
                return f"{ins.mnem}{suffix} . + ({disp})  # -> {name}"
            return f"{ins.mnem}{suffix} {name}"
    rendered = encode_hints(ins, text)
    for key in ("{load}", "{store}", "{disp8}", "{disp32}", ".insn"):
        if rendered.startswith(key):
            hints[key] += 1
    # symbolic tables
    for address, symbol in tables.items():
        literal = f"0x{address:x}"
        if rendered.endswith(f"+ {literal}]") and (ins.mnem in ("jmp", "movzx", "movsx", "mov")):
            rendered = rendered[: -len(f"+ {literal}]")] + f"+ {symbol}]"
    # frame offsets get names
    def repl(m: re.Match) -> str:
        sign, mag = m.group("sign"), int(m.group("mag"), 16)
        name = frame_symbol(sign, mag)
        frame[name] = (sign, mag)
        return f"[ebp{m.group('index')} {sign} {name}]"

    if has_standard_frame(layout):
        rendered = _EBP_DISP.sub(repl, rendered)
    return rendered


def has_standard_frame(layout: Layout) -> bool:
    """``push ebp; mov ebp, esp`` within the first few instructions (a hot-patch prefix may precede it)."""

    head = layout.insns[:5]
    for first, second in zip(head, head[1:]):
        if first.mnem == "push" and first.ops == "ebp" and second.mnem == "mov" and second.ops == "ebp, esp":
            return True
    return False


def render_function(image: Image, layout: Layout, label_names: Optional[dict[int, str]] = None) -> Rendered:
    va = layout.va
    tables: dict[int, str] = {}
    for item in layout.data:
        if item.kind == "switch_table":
            tables[item.va] = f"SWTAB_{item.va:08x}_VA"
        elif item.kind == "index_table":
            tables[item.va] = f"IDXTAB_{item.va:08x}_VA"
    frame: dict[str, tuple[str, int]] = {}
    externals: dict[int, str] = {}
    hints: collections.Counter = collections.Counter()

    body: list[str] = []
    labels = set(layout.internal_targets) | {t for item in layout.data_by_kind("switch_table") for t in item.targets}
    for ins in layout.insns:
        target = direct_target(ins)
        if target is not None and layout.va <= target < layout.code_end:
            labels.add(target)
    block_starts = {va} | labels
    for ins in layout.insns:
        if is_cond_jump(ins) or is_terminal(ins):
            block_starts.add(ins.end)
    for ins in layout.insns:
        if ins.addr in labels:
            body.append(f"{label_for(ins.addr)}:")
        if ins.addr in block_starts:
            body.append(f"    # block 0x{ins.addr:08x}: {UNFILLED}")
        line = render_instruction(image, layout, ins, tables, externals, frame, hints)
        body.append(f"    {line:<44} # {ins.addr:08x}")
    return Rendered("\n".join(body), frame, externals, hints, len(layout.insns))


def render_data_items(image: Image, layout: Layout) -> list[str]:
    lines: list[str] = []
    for item in layout.data:
        lines.append(f".org 0x{item.va:08x} - 0x{image.base:x}")
        if item.kind == "switch_table":
            lines.append(f"SWTAB_{item.va:08x}:  # {item.count} case address(es)")
            for case in item.targets:
                lines.append(f"    .long {label_for(case)} - .text + 0x{image.base:x}")
        elif item.kind == "index_table":
            lines.append(f"IDXTAB_{item.va:08x}:  # {item.count} switch index byte(s)")
            for start in range(0, len(item.values), 16):
                chunk = item.values[start : start + 16]
                lines.append("    .byte " + ", ".join(str(v) for v in chunk))
        elif item.kind == "padding":
            if item.lines:
                lines.append(f"PAD_{item.va:08x}:  # {item.size} byte(s) of alignment instructions")
                lines += [f"    {text}" for text in item.lines]
            else:
                kind = "int3" if item.fill == 0xCC else "nop" if item.fill == 0x90 else "fill"
                lines.append(f"PAD_{item.va:08x}:  # {item.size} byte(s) of {kind} padding")
                lines.append(f"    .fill {item.size}, 1, 0x{item.fill:02x}")
        else:
            raise ValueError(item.kind)
    for item in layout.data:
        if item.kind == "switch_table":
            lines.append(f".set SWTAB_{item.va:08x}_VA, SWTAB_{item.va:08x} - .text + 0x{image.base:x}")
        elif item.kind == "index_table":
            lines.append(f".set IDXTAB_{item.va:08x}_VA, IDXTAB_{item.va:08x} - .text + 0x{image.base:x}")
    return lines


def code_hash(image: Image, layout: Layout) -> str:
    return hashlib.sha256(image.bytes_at(layout.va, layout.code_end)).hexdigest()


def header_lines(image: Image, layout: Layout, rendered: Rendered) -> list[str]:
    va = layout.va
    lines = [
        f"# FUN_{va:08x}",
        f"# class:        {CLASS_NAME} (candidate; counts only after audit and review)",
        f"# va:           0x{va:08x}",
        f"# extent:       0x{va:08x}-0x{layout.code_end:08x} ({layout.code_size} code bytes)",
        f"# span:         0x{va:08x}-0x{layout.span_end:08x} (code {layout.code_size}, tables {layout.table_bytes}, padding {layout.padding_bytes})",
        f"# sha256:       {code_hash(image, layout)}",
        f"# evidence:     {image.evidence.get(va, UNFILLED)}",
        f"# region:       {region_of(va)}",
        f"# frame:        {'ebp' if has_standard_frame(layout) else 'none'}",
        f"# name:         {UNFILLED}",
        f"# arguments:    {UNFILLED}",
        f"# locals:       {UNFILLED}",
        f"# fields:       {UNFILLED}",
        f"# callees:      {UNFILLED}",
        f"# track-n:      {UNFILLED}",
        f"# unverified:   {UNFILLED}",
    ]
    for note in layout.notes:
        lines.append(f"# note:         {note}")
    return lines


def render_file(image: Image, layout: Layout) -> str:
    """The standalone ``.s`` file for one function."""

    rendered = render_function(image, layout)
    va = layout.va
    out = header_lines(image, layout, rendered)
    out += [
        ".intel_syntax noprefix",
        ".code32",
        ".text",
        "",
        "# --- frame symbols ---------------------------------------------------",
    ]
    for name, (sign, mag) in sorted(rendered.frame.items(), key=lambda kv: (kv[1][0] == "+", kv[1][1])):
        out.append(f".equ {name}, 0x{mag:x}  # [ebp {sign} 0x{mag:x}]")
    out += ["", "# --- external targets -----------------------------------------------"]
    for target, name in sorted(rendered.externals.items()):
        out.append(f".set {name}, .text + (0x{target:08x} - 0x{image.base:x})")
    out += [
        "",
        f".org 0x{va:08x} - 0x{image.base:x}",
        f".globl FUN_{va:08x}",
        f"FUN_{va:08x}:",
        rendered.text,
    ]
    data = render_data_items(image, layout)
    if data:
        out += ["", "# --- data items (not part of the function) -------------------------"] + data
    return "\n".join(out) + "\n"


def render_census_function(image: Image, layout: Layout, shared_externals: dict[int, str],
                           hint_totals: Optional[collections.Counter] = None) -> str:
    """Function body for the single-file census (no headers, shared externals)."""

    rendered = render_function(image, layout)
    shared_externals.update(rendered.externals)
    if hint_totals is not None:
        hint_totals.update(rendered.hint_counts)
    out = []
    for name, (sign, mag) in rendered.frame.items():
        out.append(f".equ {name}, 0x{mag:x}")
    out += [f".org 0x{layout.va:08x} - 0x{image.base:x}", f".globl FUN_{layout.va:08x}", f"FUN_{layout.va:08x}:", rendered.text]
    out += render_data_items(image, layout)
    return "\n".join(out)


# ---------------------------------------------------------------------------
# Assembly and comparison
# ---------------------------------------------------------------------------


def assembler_path() -> Path:
    path = Path(os.environ.get("M03_AS", AS_DEFAULT))
    if not path.exists():
        raise SystemExit(f"pinned assembler missing: {path} (run scripts/bootstrap_matching_s08_2_gas.sh)")
    return path


def assembler_version(path: Path) -> str:
    out = subprocess.run([str(path), "--version"], capture_output=True, text=True, check=True).stdout
    match = re.search(r"GNU assembler.*? (\d+\.\d+(?:\.\d+)?)", out)
    return match.group(1) if match else out.splitlines()[0]


def assemble(source: Path, obj: Path) -> subprocess.CompletedProcess:
    path = assembler_path()
    version = assembler_version(path)
    if version != ASSEMBLER_VERSION:
        raise SystemExit(f"assembler is {version}, expected {ASSEMBLER_VERSION}")
    return subprocess.run([str(path), "--32", "-o", str(obj), str(source)], capture_output=True, text=True)


def coff_text(obj_bytes: bytes) -> tuple[bytes, int, dict[str, int]]:
    """Return (.text bytes, relocation count, symbol -> offset) of a COFF object."""

    machine, sections, _ts, symptr, symcount = struct.unpack_from("<HHIII", obj_bytes, 0)
    if machine != 0x14C:
        raise ValueError("not an i386 COFF object")
    text = b""
    relocs = 0
    for i in range(sections):
        name, vsize, va, rsize, rptr, relptr, lineptr, nrel, nline, flags = struct.unpack_from("<8sIIIIIIHHI", obj_bytes, 20 + 40 * i)
        relocs += nrel
        if name.rstrip(b"\0") == b".text":
            text = obj_bytes[rptr : rptr + rsize]
    strings = obj_bytes[symptr + 18 * symcount :]
    symbols: dict[str, int] = {}
    index = 0
    while index < symcount:
        raw = obj_bytes[symptr + 18 * index : symptr + 18 * index + 18]
        if raw[:4] == b"\0\0\0\0":
            off = struct.unpack_from("<I", raw, 4)[0]
            end = strings.find(b"\0", off)
            nm = strings[off:end].decode("latin-1")
        else:
            nm = raw[:8].rstrip(b"\0").decode("latin-1")
        value, secnum, _type, _cls, aux = struct.unpack_from("<IhHBB", raw, 8)
        if secnum > 0:
            symbols[nm] = value
        index += 1 + aux
    return text, relocs, symbols


def pre_header() -> list[str]:
    return [".intel_syntax noprefix", ".code32", ".text"]


# ---------------------------------------------------------------------------
# Census
# ---------------------------------------------------------------------------


def run_census(image: Image, out_dir: Path, vas: Optional[list[int]] = None, keep_source: bool = False) -> dict[str, Any]:
    layouts, decoded = analyze_all(image, vas)
    vas = sorted(layouts)
    out_dir.mkdir(parents=True, exist_ok=True)
    src_path = out_dir / "census.s"
    obj_path = out_dir / "census.obj"
    assembly_errors: dict[int, str] = {}
    hint_totals: collections.Counter = collections.Counter()
    rounds = 0
    while True:
        rounds += 1
        shared: dict[int, str] = {}
        hint_totals = collections.Counter()
        chunks: list[tuple[int, str]] = []
        for va in vas:
            layout = layouts[va]
            if layout.exceptions:
                continue
            try:
                chunks.append((va, render_census_function(image, layout, shared, hint_totals)))
            except Inexpressible as exc:
                layout.exceptions.append(f"inexpressible:{exc}")
        defined = {f"FUN_{va:08x}" for va, _ in chunks}
        lines = pre_header()
        for target, name in sorted(shared.items()):
            if name not in defined:
                lines.append(f".set {name}, .text + (0x{target:08x} - 0x{image.base:x})")
        starts: list[tuple[int, int]] = []  # (first line number, va)
        cursor = len(lines) + 1
        for va, chunk in chunks:
            starts.append((cursor, va))
            cursor += chunk.count("\n") + 1
        source = "\n".join(lines + [c for _, c in chunks]) + "\n"
        src_path.write_text(source, encoding="utf-8")
        result = assemble(src_path, obj_path)
        if result.returncode == 0:
            break
        errors = re.findall(r":(\d+): Error: (.*)", result.stderr)
        if not errors or rounds > 60:
            return {"fatal": "assembly failed", "assembler_stderr_head": result.stderr.splitlines()[:20]}
        first_lines = [line for line, _ in starts]
        blamed: dict[int, str] = {}
        seen_org = False
        for line_text, message in errors:
            line = int(line_text)
            pos = bisect.bisect_right(first_lines, line) - 1
            if pos < 0:
                return {"fatal": "assembly failed outside functions", "assembler_stderr_head": result.stderr.splitlines()[:20]}
            if "org backwards" in message:
                if seen_org:
                    continue
                seen_org = True
                if line == first_lines[pos] + 1 and pos > 0:  # the function's own opening .org
                    pos -= 1
            blamed[starts[pos][1]] = message
        for va, message in blamed.items():
            layouts[va].exceptions.append(f"assembler:{message}")
            assembly_errors[va] = message

    report: dict[str, Any] = {
        "assembler_returncode": 0,
        "assembly_rounds": rounds,
        "functions_total": len(vas),
        "assembly_errors": {f"0x{va:08x}": msg for va, msg in assembly_errors.items()},
    }
    obj_bytes = obj_path.read_bytes()
    text, relocs, symbols = coff_text(obj_bytes)
    report["relocations"] = relocs
    by_region: dict[str, collections.Counter] = collections.defaultdict(collections.Counter)
    mismatches = []
    for va in vas:
        layout = layouts[va]
        region = region_of(va)
        counter = by_region[region]
        counter["functions"] += 1
        counter["span_bytes"] += layout.span_end - layout.va
        if layout.exceptions:
            counter["exception_functions"] += 1
            counter["exception_span_bytes"] += layout.span_end - layout.va
            continue
        counter["code_bytes"] += layout.code_size
        counter["switch_table_bytes"] += sum(i.size for i in layout.data_by_kind("switch_table"))
        counter["index_table_bytes"] += sum(i.size for i in layout.data_by_kind("index_table"))
        counter["padding_bytes"] += layout.padding_bytes
        counter["switch_tables"] += len(layout.data_by_kind("switch_table"))
        ok = text[va - image.base : layout.code_end - image.base] == image.bytes_at(va, layout.code_end)
        if ok:
            counter["code_exact_bytes"] += layout.code_size
            counter["functions_exact"] += 1
        else:
            counter["functions_mismatch"] += 1
            mismatches.append(f"0x{va:08x}:code")
        for item in layout.data:
            got = text[item.va - image.base : item.end - image.base]
            if got == image.bytes_at(item.va, item.end):
                counter[f"{item.kind}_exact_bytes"] += item.size
            else:
                mismatches.append(f"0x{item.va:08x}:{item.kind}")
    report["hints"] = dict(sorted(hint_totals.items()))
    report["derived_functions"] = sum(1 for va in vas if layouts[va].derived)
    # evidence for a derived entry: a direct call or jump to it from a classified code part
    referenced = {
        t
        for layout in layouts.values()
        if not layout.exceptions
        for ins in layout.insns
        if (t := direct_target(ins)) is not None
    }
    derived = [va for va in vas if layouts[va].derived]
    report["derived_with_direct_reference"] = sum(1 for va in derived if va in referenced)
    report["derived_without_direct_reference"] = [f"0x{va:08x}" for va in derived if va not in referenced]
    report["fall_through_fragments"] = [f"0x{va:08x}" for va in vas if layouts[va].falls_through]
    report["by_region"] = {k: dict(v) for k, v in sorted(by_region.items())}
    # description for the M02 composer: every code part and data item, hashes only
    report["ranges"] = [
        {
            "function": f"FUN_{va:08x}",
            "va": va,
            "derived": layouts[va].derived,
            "code_size": layouts[va].code_size,
            "code_sha256": code_hash(image, layouts[va]),
            "data_items": [
                {"kind": i.kind, "va": i.va, "size": i.size, "sha256": hashlib.sha256(image.bytes_at(i.va, i.end)).hexdigest()}
                for i in layouts[va].data
            ],
        }
        for va in vas
        if not layouts[va].exceptions
    ]
    report["unsplit_spans"] = [
        {"function": f"FUN_{va:08x}", "va": va, "span_end": layouts[va].span_end, "reasons": layouts[va].exceptions}
        for va in vas
        if layouts[va].exceptions
    ]
    totals: collections.Counter = collections.Counter()
    for counter in by_region.values():
        totals.update(counter)
    report["totals"] = dict(totals)
    report["mismatches"] = mismatches
    report["exceptions"] = {f"0x{va:08x}": layouts[va].exceptions for va in vas if layouts[va].exceptions}
    report["notes"] = {f"0x{va:08x}": layouts[va].notes for va in vas if layouts[va].notes}
    report["source_sha256"] = hashlib.sha256(source.encode()).hexdigest()
    report["object_sha256"] = hashlib.sha256(obj_bytes).hexdigest()
    if not keep_source:
        src_path.unlink()
        obj_path.unlink()
    return report


# ---------------------------------------------------------------------------
# Command line
# ---------------------------------------------------------------------------


def parse_va(value: str) -> int:
    return int(value, 0)


def main(argv: Optional[list[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--original", type=Path, default=ORIGINAL_DEFAULT)
    sub = parser.add_subparsers(dest="command", required=True)
    gen = sub.add_parser("gen", help="write one annotated-ready .s per function")
    gen.add_argument("vas", nargs="+", type=parse_va)
    gen.add_argument("--out", type=Path, required=True, help="directory for FUN_<va>.s files")
    gen.add_argument("--data-manifest", type=Path, help="write the data-item description for M02")
    man = sub.add_parser("manifest", help="write the batch manifest for the auditor")
    man.add_argument("vas", nargs="+", type=parse_va)
    man.add_argument("--sources", type=Path, required=True, help="directory holding FUN_<va>.s")
    man.add_argument("--batch", required=True)
    man.add_argument("--description", required=True)
    man.add_argument("--out", type=Path, required=True)
    cen = sub.add_parser("census", help="reassemble every indexed function and report")
    cen.add_argument("--out", type=Path, required=True, help="private output directory (stays under work/)")
    cen.add_argument("--vas", nargs="*", type=parse_va)
    cen.add_argument("--keep-source", action="store_true")
    args = parser.parse_args(argv)

    image = load_image(args.original)
    if args.command == "gen":
        layouts, _decoded = analyze_all(image, args.vas)
        args.out.mkdir(parents=True, exist_ok=True)
        status = 0
        manifest = []
        for va in args.vas:
            layout = layouts[va]
            if layout.exceptions:
                print(f"0x{va:08x}: exceptions {layout.exceptions}", file=sys.stderr)
                status = 1
                continue
            path = args.out / f"FUN_{va:08x}.s"
            path.write_text(render_file(image, layout), encoding="utf-8")
            print(f"wrote {path}")
            manifest.append(describe_layout(image, layout))
        if args.data_manifest:
            args.data_manifest.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
        return status
    if args.command == "manifest":
        layouts, _decoded = analyze_all(image, args.vas)
        manifest = build_manifest(
            image, layouts, args.vas, args.sources, args.batch, args.description, manifest_dir=args.out.resolve().parent
        )
        args.out.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
        print(f"wrote {args.out} ({len(manifest['functions'])} functions)")
        return 0
    report = run_census(image, args.out, args.vas, args.keep_source)
    path = args.out / "census.json"
    path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    t = report.get("totals", {})
    if "fatal" in report:
        print(json.dumps(report, indent=1))
        return 2
    print(json.dumps({k: report[k] for k in report if k in ("assembler_returncode", "relocations", "functions_total", "assembly_rounds")}))
    print(json.dumps(t, sort_keys=True))
    print(f"exceptions: {len(report.get('exceptions', {}))}  mismatches: {len(report.get('mismatches', []))}")
    return 0 if report.get("assembler_returncode") == 0 and not report.get("mismatches") else 1


def data_symbol(item: DataItem) -> str:
    prefix = {"switch_table": "SWTAB", "index_table": "IDXTAB", "padding": "PAD"}[item.kind]
    return f"{prefix}_{item.va:08x}"


def build_manifest(
    image: Image,
    layouts: dict[int, Layout],
    vas: list[int],
    source_dir: Path,
    batch: str,
    description: str,
    image_base: int = 0x400000,
    original_sha256: str = ORIGINAL_SHA256,
    manifest_dir: Optional[Path] = None,
) -> dict[str, Any]:
    """Batch manifest for ``audit_tool_assisted.py`` from generated/annotated sources."""

    functions = []
    for va in vas:
        layout = layouts[va]
        if layout.exceptions:
            raise SystemExit(f"FUN_{va:08x}: {layout.exceptions}")
        source = source_dir / f"FUN_{va:08x}.s"
        functions.append(
            {
                "function": f"FUN_{va:08x}",
                "va": f"0x{va:08x}",
                "source": os.path.relpath(source, manifest_dir or source_dir),
                "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
                "region": region_of(va),
                "evidence_id": image.evidence.get(va, UNFILLED),
                "code": {
                    "symbol": f"FUN_{va:08x}",
                    "rva": va - image_base,
                    "size": layout.code_size,
                    "sha256": code_hash(image, layout),
                },
                "data_items": [
                    {
                        "kind": item.kind,
                        "symbol": data_symbol(item),
                        "rva": item.va - image_base,
                        "size": item.size,
                    }
                    for item in layout.data
                ],
            }
        )
    return {
        "batch": batch,
        "class": CLASS_NAME,
        "description": description,
        "original_sha256": original_sha256,
        "generator": "scripts/gen_hinted_asm.py",
        "functions": functions,
    }


def describe_layout(image: Image, layout: Layout) -> dict[str, Any]:
    return {
        "function": f"FUN_{layout.va:08x}",
        "va": layout.va,
        "code_size": layout.code_size,
        "code_sha256": code_hash(image, layout),
        "span_end": layout.span_end,
        "data_items": [
            {
                "kind": item.kind,
                "va": item.va,
                "size": item.size,
                "sha256": hashlib.sha256(image.bytes_at(item.va, item.end)).hexdigest(),
            }
            for item in layout.data
        ],
    }


if __name__ == "__main__":
    raise SystemExit(main())
