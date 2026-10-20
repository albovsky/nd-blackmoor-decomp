#!/usr/bin/env python3
"""Track M data sources (packet M-C): ``.rdata`` and ``.data`` as labeled assembler data directives.

The code of GAME.EXE is reconstructed as tool-assisted assembly (``gen_hinted_asm.py``, ``audit_tool_assisted.py``).
This module does the same for initialized data, under the owner ruling of 2026-10-19 (decision card "Count rebuilt
data and resources as matched when they reassemble byte for byte?", answered Yes): the non-code ranges are emitted
from the owner's local ``GAME.EXE`` as one GNU assembly source with machine-named labels, reassembled with the pinned
``i686-w64-mingw32-as`` 2.43.1 and compared byte for byte with the original.

    data_asm.py gen      --out asm_data            write the layout and manifest (committed) and the full source (build output)
    data_asm.py audit    asm_data/data-001.json    regenerate the source, reassemble, compare, write data-001-report.json
    data_asm.py check    asm_data/data-001.json    regenerate the source and require the manifest's hash and layout

What the generator does, and nothing else (no datum is interpreted):

* a run of 4 or more printable ASCII bytes (plus tab, line feed, carriage return) ended by a NUL is a string
  (``.asciz``, label ``STR_<va>``);
* an aligned all-zero run is ``.fill n, 1, 0``;
* an aligned dword whose value lies inside a mapped section of the image is a pointer.  A target inside the
  claimed ranges is written as ``<label> - IMG + <origin>`` so that the assembler resolves it from the real label
  position (a misplaced label changes the bytes); a target elsewhere is a named absolute constant
  (``FUN_<va>`` code entries, ``CODE_<va>``, ``BSS_<va>``, ``IAT_<va>``, ``RSRC_<va>``, ``OUT_<va>``);
* every other aligned dword is ``.long 0x...``; leftover bytes are ``.byte``.

The full source holds the game's own strings, numbers and resource bytes as directive text, so it is a build
output, not a committed file (owner decision of 2026-10-19: "extract at build"): it is regenerated from the owner's
local ``GAME.EXE`` into ``work/asm_data/`` whenever it is audited or composed, and the repository keeps only the
generator, the manifest (ranges, hashes) and the layout.  The layout (``asm_data/data-NNN.layout``) is that source
with every string, numeric dword and byte list masked as ``[length]``: labels, offsets, zero runs, pointer
expressions and the named address constants of pointer targets remain (structure, not a string or number value).  The manifest pins the SHA-256 of the full source and of the
layout, so a build from any other bytes is refused.  Nothing here claims original C provenance.  Batches 001 and 002 (profile ``payloads``) hold payloads; batches 003 and
004 (profile ``structures``, ``gen --structures pe|resource``) hold the PE headers, import tables, resource directory tree and
section zero fill, which the composer's structured groups also generate.
"""

from __future__ import annotations

import argparse
import bisect
import hashlib
import importlib.util
import json
import re
import struct
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Optional

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT = SCRIPT_DIR.parent
REPOSITORY = PROJECT.parent.parent
IMAGE_DIR = PROJECT / "image"
DEFAULT_OUT = PROJECT / "asm_data"
DEFAULT_BUILD = REPOSITORY / "work" / "asm_data"
DEFAULT_ORIGINAL = REPOSITORY / "work" / "original" / "GAME.EXE"
DEFAULT_ASSEMBLER = REPOSITORY / "work" / "tools" / "s08-binutils-2.43.1" / "prefix" / "bin" / "i686-w64-mingw32-as"

SCHEMA = "blackmoor-data-asm/1"
DATA_CLASS = "tool_assisted_reconstructed_data"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
IMAGE_BASE = 0x400000
MIN_STRING = 4
MACHINE_HEADER = "# annotation:  machine"

# Slice 1: the referenced ranges of .rdata and .data (file offsets; the file is section-aligned, so offset == RVA).
DEFAULT_RANGES = ((0x12A54C, 0x134910), (0x137000, 0x16A000))


class DataAsmError(Exception):
    pass


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def file_sha256(path: Path) -> str:
    return sha256(path.read_bytes())


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def hx8(value: int) -> str:
    return f"0x{value:08x}"


# --------------------------------------------------------------------------
# image geometry
# --------------------------------------------------------------------------


@dataclass
class Section:
    name: str
    va: int
    virtual_size: int
    raw_off: int
    raw_size: int


def load_sections(image_dir: Path = IMAGE_DIR) -> list[Section]:
    layout = load_json(image_dir / "layout.json")
    return [
        Section(s["name"], IMAGE_BASE + int(s["virtual_address"], 16), int(s["virtual_size"], 16), int(s["raw_pointer"], 16), int(s["raw_size"], 16))
        for s in layout["sections"]
    ]


HEADERS = "<headers>"
PROFILE_PAYLOADS = "payloads"  # .rdata / .data / resource payloads (the default; manifests of batches 001 and 002 carry no profile)
PROFILE_STRUCTURES = "structures"  # PE headers, import tables, resource directory tree and section padding
PROFILE_TABLES = "jump_tables"  # the jump tables inside .text that no audited function source carries (the two CRT block copies)
PROFILES = (PROFILE_PAYLOADS, PROFILE_STRUCTURES, PROFILE_TABLES)


def containing_section(sections: list[Section], lo: int, hi: int) -> Optional[Section]:
    """The section whose raw data holds ``[lo, hi)``; the file headers (before the first section) are the pseudo-section
    ``<headers>`` at the image base."""
    for s in sections:
        if s.raw_off <= lo and hi <= s.raw_off + s.raw_size:
            return s
    if not sections:
        return None
    first = min(s.raw_off for s in sections)
    if lo >= 0 and hi <= first:
        return Section(HEADERS, IMAGE_BASE, first, 0, first)
    return None


def section_name_at(sections: list[Section], offset: int) -> str:
    sec = containing_section(sections, offset, offset + 1)
    return sec.name if sec is not None else "?"


def load_function_starts(path: Path = PROJECT / "function-index.json") -> set[int]:
    return {int(f["address"], 16) for f in load_json(path)["functions"]}


# --------------------------------------------------------------------------
# analysis
# --------------------------------------------------------------------------


@dataclass
class Atom:
    start: int  # file offset
    length: int
    kind: str  # str | wstr | zero | dword | byte
    pointer: Optional[int] = None  # dword atoms: the target VA when the dword is a pointer

    @property
    def end(self) -> int:
        return self.start + self.length


def is_text_byte(b: int) -> bool:
    return 0x20 <= b <= 0x7E or b in (9, 10, 13)


def string_length(data: bytes, pos: int, end: int) -> int:
    """Characters of a NUL-terminated printable run starting at ``pos`` (0 when there is none)."""
    i = pos
    while i < end and is_text_byte(data[i]):
        i += 1
    if i < end and data[i] == 0 and i - pos >= MIN_STRING:
        return i - pos
    return 0


def wide_string_length(data: bytes, pos: int, end: int) -> int:
    """Characters of a UTF-16LE (ASCII-only) run ended by a 16-bit NUL starting at ``pos`` (0 when there is none)."""
    i = pos
    while i + 1 < end and is_text_byte(data[i]) and data[i + 1] == 0:
        i += 2
    if i + 1 < end and data[i] == 0 and data[i + 1] == 0 and (i - pos) // 2 >= MIN_STRING:
        return (i - pos) // 2
    return 0


def split_range(data: bytes, lo: int, hi: int) -> list[Atom]:
    """Cut ``[lo, hi)`` into strings, zero runs, aligned dwords and leftover bytes (offset and VA are congruent mod 4)."""
    atoms: list[Atom] = []

    def add(start: int, length: int, kind: str) -> None:
        if atoms and atoms[-1].kind == "byte" and kind == "byte" and atoms[-1].end == start:
            atoms[-1].length += length
        else:
            atoms.append(Atom(start, length, kind))

    pos = lo
    while pos < hi:
        aligned = pos % 4 == 0
        n = string_length(data, pos, hi)
        if n:
            add(pos, n + 1, "str")
            pos += n + 1
            continue
        n = wide_string_length(data, pos, hi)
        if n:
            add(pos, 2 * n + 2, "wstr")
            pos += 2 * n + 2
            continue
        if data[pos] == 0:
            z = 0
            while pos + z < hi and data[pos + z] == 0:
                z += 1
            string_follows = string_length(data, pos + z, hi) > 0 or wide_string_length(data, pos + z, hi) > 0
            if aligned:
                if z >= 4:
                    take = z if (z % 4 == 0 or string_follows) else z - z % 4
                    add(pos, take, "zero")
                    pos += take
                    continue
                if string_follows:
                    add(pos, z, "zero")
                    pos += z
                    continue
            else:
                gap = -pos % 4
                take = z if (string_follows or z < gap) else gap
                add(pos, take, "zero")
                pos += take
                continue
        if aligned and pos + 4 <= hi:
            add(pos, 4, "dword")
            pos += 4
            continue
        # leftover (unaligned or short) bytes up to the next alignment boundary
        take = min(hi - pos, -pos % 4 or 4)
        add(pos, take, "byte")
        pos += take
    return atoms


class Analysis:
    """Atoms, labels and pointers of the claimed ranges."""

    def __init__(self, original: bytes, ranges: tuple[tuple[int, int], ...], sections: list[Section], function_starts: set[int], bias: int, pointers: bool):
        self.original = original
        self.bias = bias  # VA = file offset + bias
        self.pointers = pointers
        self.ranges = ranges
        self.sections = sections
        self.function_starts = function_starts
        self.atoms: list[Atom] = []
        for lo, hi in ranges:
            self.atoms += split_range(original, lo, hi)
        self.starts = [a.start for a in self.atoms]
        if pointers:
            self._find_pointers()
        self._find_labels()

    # -- pointers ---------------------------------------------------------

    def claimed(self, off: int) -> bool:
        return any(lo <= off < hi for lo, hi in self.ranges)

    def section_of_va(self, va: int) -> Optional[Section]:
        for s in self.sections:
            if s.va <= va < s.va + s.virtual_size:
                return s
        return None

    def atom_at(self, off: int) -> Optional[Atom]:
        i = bisect.bisect_right(self.starts, off) - 1
        if i >= 0 and self.atoms[i].start <= off < self.atoms[i].end:
            return self.atoms[i]
        return None

    def labelable(self, off: int) -> bool:
        """A claimed offset can carry a label at an atom start, or anywhere inside a zero or byte run."""
        atom = self.atom_at(off)
        return atom is not None and (atom.start == off or atom.kind in ("zero", "byte"))

    def _find_pointers(self) -> None:
        for atom in self.atoms:
            if atom.kind != "dword":
                continue
            value = struct.unpack_from("<I", self.original, atom.start)[0]
            if self.section_of_va(value) is None:
                continue
            off = value - self.bias
            section = self.section_of_va(value)
            if section.name == ".text" and value not in self.function_starts and all(b == 0 or is_text_byte(b) for b in value.to_bytes(4, "little")):
                continue  # a non-entry code address whose bytes are all printable is far likelier text than a pointer
            if self.claimed(off) and not self.labelable(off):
                continue  # inside a string or a dword: left numeric
            atom.pointer = value

    # -- labels -----------------------------------------------------------

    def _find_labels(self) -> None:
        offs: set[int] = {lo for lo, _ in self.ranges}
        previous: Optional[Atom] = None
        for atom in self.atoms:
            if atom.kind in ("str", "wstr") or (previous is not None and previous.kind in ("str", "wstr")) or previous is None or previous.end != atom.start:
                offs.add(atom.start)
            previous = atom
        for atom in self.atoms:
            if atom.pointer is not None and self.claimed(atom.pointer - self.bias):
                offs.add(atom.pointer - self.bias)
        self.labels = sorted(offs)

    def label_name(self, off: int) -> str:
        atom = self.atom_at(off)
        prefix = "DAT"
        if atom is not None and atom.start == off:
            prefix = {"str": "STR", "wstr": "WSTR"}.get(atom.kind, "DAT")
        return f"{prefix}_{off + self.bias:08x}"

    def external_name(self, va: int) -> str:
        section = self.section_of_va(va)
        if section is None:
            raise DataAsmError(f"pointer target {hx8(va)} is outside every section")
        if section.name == ".text":
            return f"{'FUN' if va in self.function_starts else 'CODE'}_{va:08x}"
        if section.name == ".rsrc":
            return f"RSRC_{va:08x}"
        if section.name == ".data" and va >= section.va + section.raw_size:
            return f"BSS_{va:08x}"
        if section.name == ".rdata" and va < section.va + 0x54C:
            return f"IAT_{va:08x}"
        return f"OUT_{va:08x}"


# --------------------------------------------------------------------------
# rendering
# --------------------------------------------------------------------------


def escape_string(raw: bytes) -> str:
    out = []
    for b in raw:
        if b == 0x22:
            out.append('\\"')
        elif b == 0x5C:
            out.append("\\\\")
        elif b == 10:
            out.append("\\n")
        elif b == 9:
            out.append("\\t")
        elif b == 13:
            out.append("\\r")
        else:
            out.append(chr(b))
    return "".join(out)


def _not_claimed_lines(profile: Optional[str]) -> list[str]:
    if profile == PROFILE_STRUCTURES:
        return [
            "# Not claimed: original C provenance, that any value is a pointer or a string in the original program, that any field is",
            "# meaningful, or an x86 match of the whole file (code and the other data sources are separate batches).",
        ]
    if profile == PROFILE_TABLES:
        return [
            "# Not claimed: original C provenance, that these tables belong to the functions around them, that any case address is a",
            "# labelled entry of the original program, or an x86 match of the whole file (code and the other data sources are separate batches).",
        ]
    return [
        "# Not claimed: original C provenance, that any value is a pointer or a string in the original program, or an x86",
        "# match of the PE headers, import tables and resources (they are not in this source).",
    ]


def pointer_note(pointers: bool, profile: Optional[str]) -> str:
    if pointers:
        return "detected"
    return "not detected (PE structures)" if profile == PROFILE_STRUCTURES else "not detected (resource payloads)"


def header_lines(ranges: tuple[tuple[int, int], ...], sections: list[Section], origin_va: int, bias: int, pointers: bool, profile: Optional[str] = None) -> list[str]:
    parts = []
    for lo, hi in ranges:
        parts.append(f"{hx8(bias + lo)}-{hx8(bias + hi)} ({section_name_at(sections, lo)})")
    return [
        MACHINE_HEADER,
        "# Machine-generated data source of GAME.EXE (Track M, packet M-C), emitted from the owner's local original by",
        "# scripts/data_asm.py and audited byte for byte with the pinned i686-w64-mingw32-as 2.43.1.  Owner ruling of",
        "# 2026-10-19: rebuilt data with machine-named labels counts as matched.  No datum is interpreted: names state the",
        "# kind found by the generator (STR_ string, WSTR_ UTF-16 string, DAT_ data, FUN_/CODE_/BSS_/IAT_/RSRC_/OUT_ pointer targets) and the VA.",
        f"# original-sha256: {ORIGINAL_SHA256}",
        f"# image-base: {hx8(IMAGE_BASE)}",
        f"# pointers: {pointer_note(pointers, profile)}",
        f"# origin-va: {hx8(origin_va)}",
        f"# ranges: {' '.join(parts)}",
        "# classification: strings are printable ASCII runs of 4 or more bytes ended by a NUL (wide strings: the same in UTF-16LE); pointers are aligned dwords",
        "# that point into a mapped section (a target in these ranges is resolved from its label, any other target is a named",
        "# absolute constant); aligned zero runs are .fill; every other aligned dword is numeric; leftovers are bytes.",
        *_not_claimed_lines(profile),
    ]


def render(analysis: Analysis, origin_va: int, sections: list[Section], profile: Optional[str] = None) -> str:
    original = analysis.original
    labels = set(analysis.labels)
    externals: dict[str, int] = {}
    body: list[str] = []
    cursor_off: Optional[int] = None
    for atom in analysis.atoms:
        start = atom.start
        if cursor_off is None or start != cursor_off:
            body.append(f".org 0x{start + analysis.bias - origin_va:x}")
        cursor_off = atom.end
        # cut points inside the atom (zero and byte runs only; strings and dwords never contain a label)
        first = bisect.bisect_right(analysis.labels, start)
        last = bisect.bisect_left(analysis.labels, atom.end)
        cuts = [start] + analysis.labels[first:last] + [atom.end]
        for a, b in zip(cuts, cuts[1:]):
            if a in labels:
                body.append(f"{analysis.label_name(a)}:")
            span = original[a:b]
            if atom.kind == "str":
                body.append(f'.asciz "{escape_string(span[:-1])}"')
            elif atom.kind == "wstr":
                body.append(f'.string16 "{escape_string(span[0:-2:2])}"')
            elif atom.kind == "zero":
                body.append(f".fill {b - a}, 1, 0")
            elif atom.kind == "dword":
                if atom.pointer is not None:
                    target = atom.pointer
                    if analysis.claimed(target - analysis.bias):
                        body.append(f".long {analysis.label_name(target - analysis.bias)} - IMG + 0x{origin_va:x}")
                    else:
                        name = analysis.external_name(target)
                        externals[name] = target
                        body.append(f".long {name}")
                else:
                    body.append(f".long 0x{struct.unpack('<I', span)[0]:x}")
            else:
                body.append(".byte " + ", ".join(f"0x{x:02x}" for x in span))
    # merge consecutive numeric .long lines (no label between them), at most four per line
    merged: list[str] = []
    for line in body:
        if line.startswith(".long 0x") and merged and merged[-1].startswith(".long 0x") and merged[-1].count(",") < 3:
            merged[-1] += ", " + line[len(".long "):]
        else:
            merged.append(line)
    head = header_lines(analysis.ranges, sections, origin_va, analysis.bias, analysis.pointers, profile)
    lines = head + [".intel_syntax noprefix", ".data"]
    lines += [f".set {name}, 0x{va:x}" for name, va in sorted(externals.items())]
    lines += ["IMG:"] + merged
    return "\n".join(lines) + "\n"


def bias_of(sections: list[Section], ranges: tuple[tuple[int, int], ...]) -> int:
    """VA minus file offset shared by every range (the ranges must lie in sections with the same bias)."""
    biases = set()
    for lo, hi in ranges:
        sec = containing_section(sections, lo, hi)
        if sec is None:
            raise DataAsmError(f"range {hx8(lo)}-{hx8(hi)} is not inside one section's raw data")
        biases.add(sec.va - sec.raw_off)
    if len(biases) != 1:
        raise DataAsmError("ranges of one source must share one VA bias")
    return biases.pop()


def generate(
    original: bytes, ranges: tuple[tuple[int, int], ...] = DEFAULT_RANGES, image_dir: Path = IMAGE_DIR, pointers: bool = True, profile: Optional[str] = None
) -> tuple[str, Analysis, int]:
    if sha256(original) != ORIGINAL_SHA256:
        raise DataAsmError("not the pinned GAME.EXE")
    sections = load_sections(image_dir)
    function_starts = load_function_starts(image_dir.parent / "function-index.json")
    bias = bias_of(sections, tuple(ranges))
    origin_va = (bias + ranges[0][0]) & ~0xFFF
    analysis = Analysis(original, tuple(ranges), sections, function_starts, bias, pointers)
    return render(analysis, origin_va, sections, profile), analysis, origin_va


# --------------------------------------------------------------------------
# layout: the committed, payload-free form of a source
# --------------------------------------------------------------------------

LAYOUT_HEADER = (
    "# Layout of a generated GAME.EXE data source (Track M, packet M-C): labels, offsets, zero runs, pointer expressions and named",
    "# constants only.  Every string, numeric dword and byte list is masked as [length]; scripts/data_asm.py regenerates the full source from the owner's local original.",
)
_MASK_STRING = re.compile(r'^\.(asciz|string16) "(.*)"$')
_MASK_LONG = re.compile(r"^\.long 0x[0-9a-f]{1,8}(?:, 0x[0-9a-f]{1,8})*$")
_MASK_BYTE = re.compile(r"^\.byte 0x[0-9a-f]{2}(?:, 0x[0-9a-f]{2})*$")
# Every line shape a layout may carry (an allowlist: anything else, including any value directive, is rejected).
_LAYOUT_LINES = tuple(
    re.compile(pattern)
    for pattern in (
        r"^\.intel_syntax noprefix$",
        r"^\.data$",
        r"^IMG:$",
        r"^(?:DAT|STR|WSTR)_[0-9a-f]{8}:$",
        r"^\.set (?:FUN|CODE|BSS|IAT|RSRC|OUT)_[0-9a-f]{8}, 0x[0-9a-f]+$",
        r"^\.org 0x[0-9a-f]+$",
        r"^\.fill [0-9]+, 1, 0$",
        r"^\.long (?:DAT|STR|WSTR)_[0-9a-f]{8} - IMG \+ 0x[0-9a-f]+$",
        r"^\.long (?:FUN|CODE|BSS|IAT|RSRC|OUT)_[0-9a-f]{8}$",
        r"^\.(?:asciz|string16|long|byte) \[[0-9]+\]$",
        r"^# original-sha256: [0-9a-f]{64}$",
        r"^# image-base: 0x[0-9a-f]{8}$",
        r"^# pointers: (?:detected|not detected \((?:resource payloads|PE structures)\))$",
        r"^# origin-va: 0x[0-9a-f]{8}$",
        r"^# ranges: (?:0x[0-9a-f]{8}-0x[0-9a-f]{8} \((?:\.[a-z]+|<headers>|\?)\)(?: |$))+$",
    )
)


def _unescaped_length(body: str) -> int:
    """Characters of a quoted directive body (an escape such as ``\\n`` or ``\\"`` is one character)."""
    return len(re.sub(r"\\.", "x", body))


def layout_of(text: str) -> str:
    """The full source with every payload value masked; its labels and structure are the source's own."""
    lines = list(LAYOUT_HEADER)
    for line in text.splitlines():
        m = _MASK_STRING.match(line)
        if m:
            lines.append(f".{m.group(1)} [{_unescaped_length(m.group(2))}]")
        elif _MASK_LONG.match(line):
            lines.append(f".long [{line.count(',') + 1}]")
        elif _MASK_BYTE.match(line):
            lines.append(f".byte [{line.count(',') + 1}]")
        else:
            lines.append(line)
    return "\n".join(lines) + "\n"


def _fixed_comments() -> frozenset[str]:
    """The constant prose lines of the layout and source headers (the variable header lines have their own patterns)."""
    variable = r"# (?:original-sha256|image-base|pointers|origin-va|ranges):"
    return frozenset(LAYOUT_HEADER) | frozenset(
        l for profile in (None, PROFILE_STRUCTURES, PROFILE_TABLES) for l in header_lines(((0, 0),), [], 0, 0, True, profile) if not re.match(variable, l)
    )


def audit_layout(text: str) -> list[str]:
    """Problems in a layout file: every line must be a shape the generator's layout can carry, so a string, a numeric
    dword, a byte list (in any spelling) or any other directive is rejected as a payload value."""
    fixed = _fixed_comments()
    return [
        f"line {number}: payload value or unexpected line in the layout: {line[:60]}"
        for number, line in enumerate(text.splitlines(), 1)
        if line not in fixed and not any(pattern.match(line) for pattern in _LAYOUT_LINES)
    ]


def safe_batch_names(manifest: dict[str, Any]) -> bool:
    """The manifest's source and layout names must be plain ``data-NNN`` files (no path)."""
    return re.fullmatch(r"data-[0-9]+\.s", str(manifest.get("source"))) is not None and re.fullmatch(r"data-[0-9]+\.layout", str(manifest.get("layout"))) is not None


# --------------------------------------------------------------------------
# assembling
# --------------------------------------------------------------------------


def load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise DataAsmError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def check_assembler(assembler: Path) -> tuple[Optional[str], dict[str, Any]]:
    """The pinned-assembler check of the code audit (version line plus the fixed-source self-test)."""
    return load_module("audit_tool_assisted_for_data", SCRIPT_DIR / "audit_tool_assisted.py").check_assembler(assembler)


def read_coff(obj: bytes) -> tuple[bytes, int, dict[str, int]]:
    """(``.data`` bytes, relocation count over all sections, symbol -> ``.data`` offset) of a COFF object."""
    machine, sections, _ts, symptr, symcount = struct.unpack_from("<HHIII", obj, 0)
    if machine != 0x14C:
        raise DataAsmError("not an i386 COFF object")
    data = b""
    index_of_data = 0
    relocations = 0
    for i in range(sections):
        name, _vsize, _va, rsize, rptr, _relptr, _lineptr, nrel, _nline, _flags = struct.unpack_from("<8sIIIIIIHHI", obj, 20 + 40 * i)
        relocations += nrel
        if name.rstrip(b"\0") == b".data":
            data = obj[rptr : rptr + rsize]
            index_of_data = i + 1
    strings = obj[symptr + 18 * symcount :]
    symbols: dict[str, int] = {}
    index = 0
    while index < symcount:
        raw = obj[symptr + 18 * index : symptr + 18 * index + 18]
        if raw[:4] == b"\0\0\0\0":
            off = struct.unpack_from("<I", raw, 4)[0]
            nm = strings[off : strings.find(b"\0", off)].decode("latin-1")
        else:
            nm = raw[:8].rstrip(b"\0").decode("latin-1")
        value, secnum, _type, _cls, aux = struct.unpack_from("<IhHBB", raw, 8)
        if secnum == index_of_data:
            symbols[nm] = value
        index += 1 + aux
    return data, relocations, symbols


def assemble(assembler: Path, source: Path) -> tuple[bytes, int, dict[str, int]]:
    with tempfile.TemporaryDirectory(prefix="data-asm-") as tmp:
        obj = Path(tmp) / "data.obj"
        run = subprocess.run([str(assembler), "--32", "-o", str(obj), str(source)], capture_output=True, text=True)
        if run.returncode != 0 or not obj.is_file():
            raise DataAsmError(f"assembly failed: {run.stderr.strip()[:600]}")
        return read_coff(obj.read_bytes())


def assemble_text(assembler: Path, text: str, source: Optional[Path] = None) -> tuple[bytes, int, dict[str, int]]:
    """Assemble a source text (from ``source`` when it is already on disk, else from a temporary file)."""
    if source is not None:
        return assemble(assembler, source)
    with tempfile.TemporaryDirectory(prefix="data-src-") as tmp:
        path = Path(tmp) / "data.s"
        path.write_text(text, encoding="utf-8")
        return assemble(assembler, path)


# --------------------------------------------------------------------------
# lexical audit
# --------------------------------------------------------------------------

_LABEL = re.compile(r"^(?:(DAT|STR|WSTR)_([0-9a-f]{8})|IMG):$")
_SET = re.compile(r"^\.set ((?:FUN|CODE|BSS|IAT|RSRC|OUT)_([0-9a-f]{8})), 0x([0-9a-f]+)$")
_ORG = re.compile(r"^\.org 0x[0-9a-f]+$")
_FILL = re.compile(r"^\.fill (\d+), 1, 0$")
_BYTES = re.compile(r"^\.byte 0x[0-9a-f]{2}(?:, 0x[0-9a-f]{2})*$")
_LONG_NUM = re.compile(r"^\.long 0x[0-9a-f]{1,8}(?:, 0x[0-9a-f]{1,8})*$")
_LONG_LABEL = re.compile(r"^\.long (?:DAT|STR|WSTR)_[0-9a-f]{8} - IMG \+ 0x[0-9a-f]+$")
_LONG_EXT = re.compile(r"^\.long (?:FUN|CODE|BSS|IAT|RSRC|OUT)_[0-9a-f]{8}$")
_ASCIZ = re.compile(r'^\.(?:asciz|string16) "(?:[\x20\x21\x23-\x5b\x5d-\x7e]|\\\\|\\"|\\[ntr])*"$')


def audit_source(text: str, expect: dict[str, Any]) -> tuple[list[str], dict[str, int]]:
    """Reject anything but the directive forms the generator writes; return (problems, counts)."""
    problems: list[str] = []
    counts = {"strings": 0, "pointers": 0, "external_pointers": 0, "zero_runs": 0, "numeric_dwords": 0, "byte_lines": 0, "labels": 0, "constants": 0}
    lines = text.splitlines()
    want = header_lines(tuple(expect["ranges"]), expect["sections"], expect["origin_va"], expect["bias"], expect["pointers"], expect.get("profile"))
    if [line for line in lines if line.startswith("#")][: len(want)] != want:
        problems.append("the machine header does not match the manifest ranges")
    seen_img = False
    constants: dict[str, int] = {}
    for number, raw in enumerate(lines, 1):
        quoted = raw.startswith((".asciz", ".string16"))  # a quoted string may contain '#'
        code = raw.strip() if quoted else raw.partition("#")[0].strip()
        if not code or raw.lstrip().startswith("#"):
            continue
        where = f"line {number}"
        if code in (".intel_syntax noprefix", ".data"):
            continue
        m = _LABEL.match(code)
        if m:
            if m.group(0) == "IMG:":
                seen_img = True
            else:
                counts["labels"] += 1
            continue
        m = _SET.match(code)
        if m:
            if int(m.group(2), 16) != int(m.group(3), 16):
                problems.append(f"{where}: constant {m.group(1)} does not equal the address in its name")
            constants[m.group(1)] = int(m.group(3), 16)
            counts["constants"] += 1
            continue
        if _ORG.match(code):
            continue
        fill = _FILL.match(code)
        if fill:
            if int(fill.group(1)) > expect.get("max_fill", 1 << 20):
                problems.append(f"{where}: .fill count is larger than any claimed range")
            counts["zero_runs"] += 1
        elif _BYTES.match(code):
            counts["byte_lines"] += 1
        elif _LONG_NUM.match(code):
            counts["numeric_dwords"] += code.count(",") + 1
        elif _LONG_LABEL.match(code):
            counts["pointers"] += 1
            if f" + 0x{expect['origin_va']:x}" not in code:
                problems.append(f"{where}: pointer expression does not use the origin {hx8(expect['origin_va'])}")
        elif _LONG_EXT.match(code):
            counts["external_pointers"] += 1
            name = code.split()[1]
            if name not in constants:
                problems.append(f"{where}: {name} is used before its .set")
        elif _ASCIZ.match(code):
            counts["strings"] += 1
        else:
            problems.append(f"{where}: directive form not permitted: {code[:80]}")
    if not seen_img:
        problems.append("the IMG anchor label is missing")
    return problems, counts


# --------------------------------------------------------------------------
# manifest, audit, check
# --------------------------------------------------------------------------


def build_manifest(
    source_name: str,
    source_text: str,
    layout_name: str,
    layout_text: str,
    original: bytes,
    ranges: tuple[tuple[int, int], ...],
    origin_va: int,
    sections: list[Section],
    batch: str,
    pointers: bool,
    profile: Optional[str] = None,
) -> dict[str, Any]:
    bias = bias_of(sections, ranges)
    entries = []
    for lo, hi in ranges:
        sec = containing_section(sections, lo, hi)
        if sec is None:
            raise DataAsmError(f"range {hx8(lo)}-{hx8(hi)} is not inside one section's raw data")
        entries.append(
            {"offset": f"0x{lo:x}", "length": hi - lo, "va": hx8(bias + lo), "section": sec.name, "sha256": sha256(original[lo:hi])}
        )
    description = (
        "PE headers, import tables, resource directory tree and section padding as labeled data directives, regenerated from the local original at build time (owner ruling of 2026-10-19)"
        if profile == PROFILE_STRUCTURES
        else "jump tables inside .text (case addresses of the two CRT block copies) as labeled data directives, regenerated from the local original at build time"
        if profile == PROFILE_TABLES
        else "initialized data or resource payloads as labeled data directives, regenerated from the local original at build time (owner ruling of 2026-10-19)"
    )
    manifest = {
        "schema": SCHEMA,
        "batch": batch,
        "class": DATA_CLASS,
        "original_sha256": ORIGINAL_SHA256,
        "description": description,
        "image_base": hx8(IMAGE_BASE),
        "va_bias": hx8(bias),
        "pointers": pointers,
        "origin_va": hx8(origin_va),
        "source": source_name,
        "source_sha256": sha256(source_text.encode("utf-8")),
        "layout": layout_name,
        "layout_sha256": sha256(layout_text.encode("utf-8")),
        "ranges": entries,
    }
    if profile is not None:
        manifest["profile"] = profile
    return manifest


def manifest_ranges(manifest: dict[str, Any]) -> tuple[tuple[int, int], ...]:
    return tuple((int(e["offset"], 16), int(e["offset"], 16) + e["length"]) for e in manifest["ranges"])


def source_expectation(manifest: dict[str, Any], sections: list[Section]) -> dict[str, Any]:
    ranges = manifest_ranges(manifest)
    return {
        "ranges": ranges,
        "sections": sections,
        "origin_va": int(manifest["origin_va"], 16),
        "bias": int(manifest["va_bias"], 16),
        "pointers": bool(manifest["pointers"]),
        "profile": manifest.get("profile"),
        "max_fill": max(hi - lo for lo, hi in ranges),
    }


def regenerate_source(manifest: dict[str, Any], original: bytes, image_dir: Path = IMAGE_DIR) -> str:
    """The full source of a manifest, regenerated from the local original (the committed layout and hashes pin it)."""
    text, _analysis, _origin = generate(original, manifest_ranges(manifest), image_dir, pointers=bool(manifest["pointers"]), profile=manifest.get("profile"))
    return text


def write_build_source(manifest: dict[str, Any], text: str, build_dir: Path) -> Path:
    build_dir.mkdir(parents=True, exist_ok=True)
    path = build_dir / manifest["source"]
    path.write_text(text, encoding="utf-8")
    return path


def layout_problems(manifest: dict[str, Any], manifest_dir: Path, text: str) -> tuple[list[str], str]:
    """Problems of the committed layout against a source text; the second value is the layout file's SHA-256."""
    if not safe_batch_names(manifest):
        raise DataAsmError("the manifest's source and layout must be plain data-NNN.s and data-NNN.layout names")
    layout_path = manifest_dir / manifest["layout"]
    if not layout_path.is_file():
        raise DataAsmError(f"{manifest['layout']}: the layout file is missing")
    have = layout_path.read_text(encoding="utf-8")
    problems = [f"layout: {p}" for p in audit_layout(have)]
    if sha256(have.encode("utf-8")) != manifest["layout_sha256"]:
        problems.append("the layout differs from the manifest hash")
    if layout_of(text) != have:
        problems.append("the source does not have the committed layout")
    return problems, file_sha256(layout_path)


def audit_manifest(
    manifest_path: Path, original_path: Path, assembler: Path, image_dir: Path = IMAGE_DIR, source_path: Optional[Path] = None, build_dir: Optional[Path] = None
) -> dict[str, Any]:
    """Audit one batch.  The source is regenerated from the original (and written to ``build_dir`` when given) unless
    ``source_path`` names a source to audit instead (the mutant tests do)."""
    manifest = load_json(manifest_path)
    if not safe_batch_names(manifest):
        raise DataAsmError("the manifest's source and layout must be plain data-NNN.s and data-NNN.layout names")
    problems: list[str] = []
    original = original_path.read_bytes()
    if manifest.get("schema") != SCHEMA or manifest.get("class") != DATA_CLASS:
        problems.append("the manifest is not a data-asm manifest of this class")
    profile = manifest.get("profile", PROFILE_PAYLOADS)
    if profile not in PROFILES:
        problems.append(f"unknown profile {profile!r}")
    elif profile == PROFILE_STRUCTURES and manifest_ranges(manifest) not in (structure_ranges("pe", image_dir), structure_ranges("resource", image_dir)):
        problems.append("a structures manifest must claim exactly the ranges structure_ranges() derives")
    elif profile == PROFILE_TABLES and manifest_ranges(manifest) != table_ranges(image_dir):
        problems.append("a jump_tables manifest must claim exactly the ranges table_ranges() derives")
    if sha256(original) != ORIGINAL_SHA256 or manifest.get("original_sha256") != ORIGINAL_SHA256:
        problems.append("the original is not the pinned GAME.EXE")
    if source_path is None:
        text = regenerate_source(manifest, original, image_dir)
        source_path = write_build_source(manifest, text, build_dir) if build_dir is not None else None
    else:
        text = source_path.read_text(encoding="utf-8")
    # hash and layout problems do not stop the reassembly, so that a report names every difference
    pinned, layout_sha = layout_problems(manifest, manifest_path.parent, text)
    if sha256(text.encode("utf-8")) != manifest["source_sha256"]:
        pinned.append("the source differs from the manifest hash")
    sections = load_sections(image_dir)
    ranges = manifest_ranges(manifest)
    origin_va = int(manifest["origin_va"], 16)
    bias = int(manifest["va_bias"], 16)
    if bias != bias_of(sections, ranges):
        problems.append("the manifest VA bias does not match the section table")
    lexical, counts = audit_source(text, source_expectation(manifest, sections))
    problems += lexical
    problem, assembler_info = check_assembler(assembler)
    if problem:
        problems.append(f"assembler: {problem}")
    compared = 0
    labels_checked = 0
    relocations = -1
    if not problems:
        data, relocations, symbols = assemble_text(assembler, text, source_path)
        if relocations:
            problems.append(f"the object carries {relocations} relocations")
        for entry in manifest["ranges"]:
            lo = int(entry["offset"], 16)
            a = bias + lo - origin_va
            got = data[a : a + entry["length"]]
            want = original[lo : lo + entry["length"]]
            if entry["sha256"] != sha256(want):
                problems.append(f"manifest hash of {entry['va']} differs from the original")
            if got != want:
                first = next((i for i, (x, y) in enumerate(zip(got, want)) if x != y), min(len(got), len(want)))
                problems.append(f"range {entry['va']} differs from the original at +{first:#x}")
            else:
                compared += entry["length"]
        for name, off in symbols.items():
            m = re.fullmatch(r"(?:DAT|STR|WSTR)_([0-9a-f]{8})", name)
            if m:
                labels_checked += 1
                if int(m.group(1), 16) != origin_va + off:
                    problems.append(f"label {name} sits at {hx8(origin_va + off)}, not at the address in its name")
    problems = pinned + problems
    total = sum(e["length"] for e in manifest["ranges"])
    return {
        "schema": SCHEMA + "/report",
        "batch": manifest.get("batch"),
        "class_requested": DATA_CLASS,
        "original_sha256": ORIGINAL_SHA256,
        "manifest_sha256": file_sha256(manifest_path),
        "source": {"path": manifest["source"], "sha256": sha256(text.encode("utf-8"))},
        "layout": {"path": manifest["layout"], "sha256": layout_sha},
        "assembler": assembler_info,
        "ranges": [dict(e) for e in manifest["ranges"]],
        "bytes_total": total,
        "compared_bytes": compared,
        "relocations": relocations,
        "labels_checked": labels_checked,
        "directives": counts,
        "errors": problems,
        "all_accepted": not problems and compared == total,
    }


def resource_ranges(image_dir: Path = IMAGE_DIR) -> tuple[tuple[int, int], ...]:
    """File-offset ranges of the resource leaf payloads (the tree and padding are generated by the composer)."""
    resources = load_json(image_dir / "resources.json")
    section = next(s for s in load_sections(image_dir) if s.name == ".rsrc")
    spans = sorted((section.raw_off + int(e["rva"], 16) - (section.va - IMAGE_BASE), e["size"]) for e in resources["data_entries"])
    merged: list[list[int]] = []
    for off, size in spans:
        if merged and merged[-1][1] == off:
            merged[-1][1] = off + size
        else:
            merged.append([off, off + size])
    return tuple((a, b) for a, b in merged)


def structure_ranges(kind: str, image_dir: Path = IMAGE_DIR) -> tuple[tuple[int, int], ...]:
    """File-offset ranges of the bytes the composer's structured groups generate (batches 003 and 004).

    ``pe``: the file headers up to the first section, the zero fill after the end of ``.text``, and ``.rdata`` outside the
    ranges of the payload batch (the import address table at its start; the import directory, hint/name entries and zero fill
    at its end).  ``resource``: the resource directory tree and the zero fill between the resource payloads.
    """
    sections = {s.name: s for s in load_sections(image_dir)}
    if kind == "resource":
        section = sections[".rsrc"]
        out: list[tuple[int, int]] = []
        cursor = section.raw_off
        for lo, hi in resource_ranges(image_dir):
            if lo > cursor:
                out.append((cursor, lo))
            cursor = hi
        if cursor < section.raw_off + section.raw_size:
            out.append((cursor, section.raw_off + section.raw_size))
        return tuple(out)
    if kind != "pe":
        raise DataAsmError(f"unknown structure kind {kind!r}")
    text, rdata = sections[".text"], sections[".rdata"]
    payload_lo, payload_hi = DEFAULT_RANGES[0]
    return (
        (0, min(s.raw_off for s in sections.values())),
        (text.raw_off + text.virtual_size, text.raw_off + text.raw_size),
        (rdata.raw_off, payload_lo),
        (payload_hi, rdata.raw_off + rdata.raw_size),
    )


def table_ranges(image_dir: Path = IMAGE_DIR) -> tuple[tuple[int, int], ...]:
    """File-offset ranges of the switch jump tables in ``.text`` that no audited function source carries.

    ``text_data.json`` lists every jump table; the audited M03 batches (``asm_batches`` of ``reconstructed.json``) carry
    all but the 14 tables (240 bytes) that lie between the code runs of the two CRT block-copy routines, which are cut
    into separate entries.  Adjacent tables are one range.
    """
    text = next(s for s in load_sections(image_dir) if s.name == ".text")
    project = image_dir.parent
    carried: set[int] = set()
    for batch in load_json(image_dir / "reconstructed.json").get("asm_batches", []):
        for function in load_json(project / batch["manifest"])["functions"]:
            for item in function.get("data_items", []):
                if item["kind"] == "switch_table":
                    carried.add(text.raw_off + int(item["rva"]) - (text.va - IMAGE_BASE))
    spans = sorted(
        (int(t["offset"], 16), int(t["offset"], 16) + 4 * len(t["entries"]))
        for t in load_json(image_dir / "text_data.json")["jump_tables"]
        if t.get("kind") == "dword" and int(t["offset"], 16) not in carried
    )
    merged: list[list[int]] = []
    for lo, hi in spans:
        if merged and merged[-1][1] == lo:
            merged[-1][1] = hi
        else:
            merged.append([lo, hi])
    return tuple((a, b) for a, b in merged)


def cmd_gen(args: argparse.Namespace) -> int:
    original = args.original.read_bytes()
    profile = PROFILE_STRUCTURES if args.structures else PROFILE_TABLES if args.jump_tables else None
    if args.jump_tables:
        if args.structures or args.range or args.resources or args.batch is None:
            raise DataAsmError("--jump-tables needs an explicit --batch and cannot be combined with --structures, --range or --resources")
        ranges = table_ranges()
    elif args.structures:
        if args.range or args.resources or args.batch is None:
            raise DataAsmError("--structures needs an explicit --batch and cannot be combined with --range or --resources")
        ranges = structure_ranges(args.structures)
        args.no_pointers = True
    else:
        ranges = resource_ranges() if args.resources else tuple(args.range) if args.range else DEFAULT_RANGES
    if args.resources:
        args.no_pointers = True
    text, analysis, origin_va = generate(original, ranges, pointers=not args.no_pointers, profile=profile)
    args.out.mkdir(parents=True, exist_ok=True)
    args.build_dir.mkdir(parents=True, exist_ok=True)
    args.batch = args.batch or "001"
    name = f"data-{args.batch}"
    (args.build_dir / f"{name}.s").write_text(text, encoding="utf-8")
    layout_text = layout_of(text)
    (args.out / f"{name}.layout").write_text(layout_text, encoding="utf-8")
    manifest = build_manifest(f"{name}.s", text, f"{name}.layout", layout_text, original, ranges, origin_va, load_sections(), args.batch, not args.no_pointers, profile)
    (args.out / f"{name}.json").write_text(json.dumps(manifest, indent=1) + "\n", encoding="utf-8")
    kinds: dict[str, int] = {}
    for atom in analysis.atoms:
        kinds[atom.kind] = kinds.get(atom.kind, 0) + 1
    print(f"{name}.s: {len(text.splitlines()):,} lines, {len(analysis.labels):,} labels, atoms {kinds}, pointers {sum(1 for a in analysis.atoms if a.pointer is not None):,}")
    return 0


def cmd_audit(args: argparse.Namespace) -> int:
    report = audit_manifest(args.manifest, args.original, args.assembler, build_dir=args.build_dir)
    out = args.report or args.manifest.with_name(args.manifest.stem + "-report.json")
    out.write_text(json.dumps(report, indent=1) + "\n", encoding="utf-8")
    print(f"{args.manifest.name}: {'accepted' if report['all_accepted'] else 'REJECTED'}; {report['compared_bytes']:,} of {report['bytes_total']:,} bytes identical; relocations {report['relocations']}")
    for problem in report["errors"][:20]:
        print("  " + problem, file=sys.stderr)
    return 0 if report["all_accepted"] else 1


def cmd_check(args: argparse.Namespace) -> int:
    manifest = load_json(args.manifest)
    text = regenerate_source(manifest, args.original.read_bytes())
    problems, _layout_sha = layout_problems(manifest, args.manifest.parent, text)
    if sha256(text.encode("utf-8")) != manifest["source_sha256"]:
        problems.append("the regenerated source differs from the manifest hash")
    for problem in problems:
        print(f"{manifest['source']}: {problem}", file=sys.stderr)
    if problems:
        return 1
    print(f"{manifest['source']}: regenerates with the committed layout and hash")
    return 0


def make_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="cmd", required=True)
    g = sub.add_parser("gen")
    g.add_argument("--original", type=Path, default=DEFAULT_ORIGINAL)
    g.add_argument("--out", type=Path, default=DEFAULT_OUT, help="where the manifest and layout (committed files) go")
    g.add_argument("--build-dir", type=Path, default=DEFAULT_BUILD, help="where the full source (a build output, never committed) goes")
    g.add_argument("--batch", default=None, help="batch number (default 001 unless --structures)")
    g.add_argument("--no-pointers", action="store_true", help="resource payloads: do not detect pointers")
    g.add_argument("--resources", action="store_true", help="the resource leaf payloads of image/resources.json (implies --no-pointers)")
    g.add_argument("--structures", choices=("pe", "resource"), help="the bytes the composer's structured groups generate: PE headers, import tables and padding (pe), or the resource directory tree and padding (resource)")
    g.add_argument("--jump-tables", action="store_true", help="the jump tables inside .text that no audited function source carries (the two CRT block copies)")
    g.add_argument("--range", type=lambda s: tuple(int(x, 16) for x in s.split(":")), action="append", help="LO:HI file offsets in hex (default: the .rdata and .data ranges)")
    g.set_defaults(func=cmd_gen)
    a = sub.add_parser("audit")
    a.add_argument("manifest", type=Path)
    a.add_argument("--original", type=Path, default=DEFAULT_ORIGINAL)
    a.add_argument("--assembler", type=Path, default=DEFAULT_ASSEMBLER)
    a.add_argument("--report", type=Path)
    a.add_argument("--build-dir", type=Path, default=DEFAULT_BUILD, help="where the regenerated full source is written")
    a.set_defaults(func=cmd_audit)
    c = sub.add_parser("check")
    c.add_argument("manifest", type=Path)
    c.add_argument("--original", type=Path, default=DEFAULT_ORIGINAL)
    c.set_defaults(func=cmd_check)
    return p


def main(argv: Optional[list[str]] = None) -> int:
    args = make_parser().parse_args(argv)
    try:
        return args.func(args)
    except DataAsmError as exc:
        print(f"data_asm: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
