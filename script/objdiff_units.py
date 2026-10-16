#!/usr/bin/env python3
"""Build objdiff units for the x86 matching progress of GAME.EXE.

One objdiff unit per function of the original ``.text``, as split by the M03
census (``gen_hinted_asm.py census``): 4,750 split functions (indexed plus
derived) and the two unsplit CRT spans.

* Target objects (``build/objdiff/target/<region>/FUN_<va>.obj``) are minimal
  i386 COFF objects written here from the owner's local ``work/original/GAME.EXE``:
  one ``.text`` section holding exactly the function's code part, one global
  function symbol at offset 0.  They are build products under the git-ignored
  ``build/`` and are never committed.
* Base objects (``build/objdiff/base/<region>/FUN_<va>.obj``) exist only for
  functions in the class ``tool_assisted_reconstructed_assembly``: accepted in
  an audited batch report (``outputs/blackmoor-decomp/asm/batch-*-report.json``)
  whose committed ``.s`` still has the audited SHA-256.  Each is assembled from
  that ``.s`` with the pinned ``i686-w64-mingw32-as`` 2.43.1.  The one change to
  the assembled object: the data-item labels after the code part
  (``SWTAB_``/``IDXTAB_``/``PAD_``) are re-marked from COFF storage class LABEL
  (6) to STATIC (3).  objdiff ignores LABEL symbols when it infers COFF symbol
  sizes, so without this the function symbol would extend over its own switch
  tables and padding and be compared as code against bytes the target does not
  contain.  No byte of the section changes.

Functions without a base object count as unmatched.  objdiff compares branch
destinations relative to the symbol start, so the target's offset-0 placement
and the base's ``.org`` placement compare equal when the bytes are equal.

Writes ``objdiff.json`` at the repository root (deterministic) and the objects.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import struct
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "outputs" / "blackmoor-decomp"
ORIGINAL = ROOT / "work" / "original" / "GAME.EXE"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
CENSUS = ROOT / "work" / "analysis" / "slices" / "M03-census" / "census.json"
ASM_DIR = PROJECT / "asm"
ASSEMBLER = ROOT / "work" / "tools" / "s08-binutils-2.43.1" / "prefix" / "bin" / "i686-w64-mingw32-as"
ASSEMBLER_VERSION_LINE = "GNU assembler (GNU Binutils) 2.43.1"
OUT = ROOT / "build" / "objdiff"
CONFIG = ROOT / "objdiff.json"

REGION_VORBIS_START = 0x4FCEF0
REGION_CRT_MFC_START = 0x50BF50
CATEGORIES = [
    {"id": "game", "name": "Game code"},
    {"id": "vorbis", "name": "libvorbis/libogg"},
    {"id": "crt_mfc", "name": "CRT and MFC"},
]
DATA_ITEM_LABEL = re.compile(r"(SWTAB|IDXTAB|PAD)_[0-9a-f]{8}$")
COFF_CLASS_STATIC = 3
COFF_CLASS_LABEL = 6


def region_of(va: int) -> str:
    if va < REGION_VORBIS_START:
        return "game"
    if va < REGION_CRT_MFC_START:
        return "vorbis"
    return "crt_mfc"


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def text_reader(exe: bytes):
    pe = struct.unpack_from("<I", exe, 0x3C)[0]
    nsec = struct.unpack_from("<H", exe, pe + 6)[0]
    opt = struct.unpack_from("<H", exe, pe + 20)[0]
    image_base = struct.unpack_from("<I", exe, pe + 24 + 28)[0]
    for i in range(nsec):
        name, vsize, rva, rsize, rptr = struct.unpack_from("<8sIIII", exe, pe + 24 + opt + 40 * i)
        if name.rstrip(b"\0") == b".text":
            start = image_base + rva

            def read(va: int, size: int) -> bytes:
                if not (start <= va and va + size <= start + min(vsize, rsize)):
                    raise ValueError(f"0x{va:08x}+{size} outside .text")
                return exe[rptr + va - start : rptr + va - start + size]

            return read
    raise ValueError("no .text section")


def write_coff(path: Path, symbol: str, code: bytes) -> None:
    """i386 COFF: one .text section (code at offset 0), section symbol, one function symbol."""
    strtab = bytearray()

    def name_field(name: str) -> bytes:
        raw = name.encode()
        if len(raw) <= 8:
            return raw.ljust(8, b"\0")
        offset = 4 + len(strtab)
        strtab.extend(raw + b"\0")
        return struct.pack("<II", 0, offset)

    raw_ptr = 20 + 40
    symbols = bytearray()
    symbols += name_field(".text") + struct.pack("<IhHBB", 0, 1, 0, COFF_CLASS_STATIC, 1)
    symbols += struct.pack("<IHHIHB3x", len(code), 0, 0, 0, 0, 0)
    symbols += name_field(symbol) + struct.pack("<IhHBB", 0, 1, 0x20, 2, 0)
    out = bytearray(struct.pack("<HHIIIHH", 0x14C, 1, 0, raw_ptr + len(code), 3, 0, 0))
    out += b".text\0\0\0" + struct.pack("<IIIIIIHHI", 0, 0, len(code), raw_ptr, 0, 0, 0, 0, 0x60500020)
    out += code + symbols + struct.pack("<I", 4 + len(strtab)) + strtab
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(bytes(out))


def relabel_data_items(obj: bytes) -> bytes:
    data = bytearray(obj)
    _, _, _, symoff, nsym, _, _ = struct.unpack_from("<HHIIIHH", data, 0)
    strtab = symoff + 18 * nsym
    i = 0
    while i < nsym:
        entry = symoff + 18 * i
        if data[entry : entry + 4] == b"\0\0\0\0":
            off = strtab + struct.unpack_from("<I", data, entry + 4)[0]
            name = data[off : data.index(b"\0", off)].decode()
        else:
            name = data[entry : entry + 8].rstrip(b"\0").decode()
        if DATA_ITEM_LABEL.match(name) and data[entry + 16] == COFF_CLASS_LABEL:
            data[entry + 16] = COFF_CLASS_STATIC
        i += 1 + data[entry + 17]
    return bytes(data)


def accepted_functions() -> dict[str, dict]:
    """Functions accepted by an audited batch whose committed source is unchanged."""
    accepted: dict[str, dict] = {}
    for report_path in sorted(ASM_DIR.glob("batch-*-report.json")):
        report = json.loads(report_path.read_text())
        for item in report["functions"]:
            if item.get("status") != "accepted":
                continue
            source = ASM_DIR / item["source"]["path"]
            if not source.is_file() or sha256(source.read_bytes()) != item["source"]["sha256"]:
                print(f"warning: {item['function']}: source changed since audit, not counted", file=sys.stderr)
                continue
            accepted[item["function"]] = {**item, "batch": report["batch"]}
    return accepted


def assemble(source: Path, out: Path) -> None:
    out.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run([str(ASSEMBLER), "-o", str(out), str(source)], check=True)
    out.write_bytes(relabel_data_items(out.read_bytes()))


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--config-only", action="store_true", help="write objdiff.json only")
    args = parser.parse_args(argv)

    census = json.loads(CENSUS.read_text())
    accepted = accepted_functions()

    functions = [(r["va"], r["function"], r["code_size"], r["code_sha256"]) for r in census["ranges"]]
    # The two unsplit CRT spans: unclassified code with embedded tables, counted
    # whole (never reconstructed yet), so the denominator is not understated.
    for span in census["unsplit_spans"]:
        functions.append((span["va"], span["function"], span["span_end"] - span["va"], None))
    functions.sort()

    units = []
    for va, name, size, _ in functions:
        region = region_of(va)
        unit = {"name": f"{region}/{name}", "target_path": f"build/objdiff/target/{region}/{name}.obj"}
        metadata = {"progress_categories": [region]}
        if name in accepted:
            unit["base_path"] = f"build/objdiff/base/{region}/{name}.obj"
            metadata["complete"] = True
            metadata["source_path"] = f"outputs/blackmoor-decomp/asm/{name}.s"
        unit["metadata"] = metadata
        units.append(unit)
    config = {
        "$schema": "https://raw.githubusercontent.com/encounter/objdiff/v3.8.2/config.schema.json",
        "build_target": False,
        "build_base": False,
        "progress_categories": CATEGORIES,
        "units": units,
    }
    # One unit per line keeps the generated file diffable.
    head = json.dumps({k: v for k, v in config.items() if k != "units"}, indent=1)[:-2]
    lines = ",\n  ".join(json.dumps(unit) for unit in units)
    CONFIG.write_text(f'{head},\n "units": [\n  {lines}\n ]\n}}\n')
    if args.config_only:
        return 0

    exe = ORIGINAL.read_bytes()
    if sha256(exe) != ORIGINAL_SHA256:
        raise SystemExit(f"{ORIGINAL} is not the recorded original")
    version = subprocess.run([str(ASSEMBLER), "--version"], capture_output=True, text=True, check=True).stdout
    if version.splitlines()[0] != ASSEMBLER_VERSION_LINE:
        raise SystemExit(f"assembler is not {ASSEMBLER_VERSION_LINE}")
    read = text_reader(exe)

    total = matched_candidates = 0
    for va, name, size, code_sha in functions:
        region = region_of(va)
        code = read(va, size)
        if code_sha is not None and sha256(code) != code_sha:
            raise SystemExit(f"{name}: original code part differs from the census")
        write_coff(OUT / "target" / region / f"{name}.obj", name, code)
        total += size
        if name in accepted:
            assemble(ASM_DIR / f"{name}.s", OUT / "base" / region / f"{name}.obj")
            matched_candidates += accepted[name]["code"]["size"]
    print(f"units {len(functions)}, code bytes {total}, with base {len(accepted)} ({matched_candidates} bytes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
