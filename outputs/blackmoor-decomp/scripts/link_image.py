#!/usr/bin/env python3
"""Inputs of the single GAME.EXE build step (packet M-D): link-form sources, linker script, tool pins, verification.

``scripts/build_game_exe.sh`` is the build: it assembles every committed source with the pinned
``i686-w64-mingw32-as`` 2.43.1, links the objects with the same binutils' ``ld`` and writes the image with its
``objcopy``.  Every output byte is assembler or linker output of text inputs.  This module writes only those *text* inputs
(the data text is generated from the owner's own GAME.EXE by ``data_asm.py``) and checks tools and result:

    link_image.py prepare   pin the tools, extract the data sources from the owner's local GAME.EXE (the one step that
                            reads the original: ``data_asm.py`` regenerates each ``data-NNN.s`` and the committed hash
                            and layout must match), rewrite every audited source to its link form, write the linker
                            script, the response files and the report
    link_image.py verify    compare the linked file with the original's SHA-256 (and optionally the composer's image)

The audited sources are assembled by the audits with ``.org`` positions (every object is as large as its offset in
``.text``) and with every cross-reference folded to a constant at assembly time.  A real link needs relocatable
objects, so ``prepare`` rewrites exactly these forms, and nothing else, in a copy under ``build/game/src``:

* code sources (``asm/FUN_<va>.s``): the first ``.org <va> - 0x401000`` is dropped (the linker places the section),
  later ``.org`` operands become offsets from the function start, ``.text`` becomes the section ``.fn`` (alignment 1),
  ``.set <name>, .text + (<va> - 0x401000)`` (an address of another function) is dropped and becomes a linker-script
  ``PROVIDE`` of the same address, ``<label> - .text + 0x401000`` becomes the label (a relocation the linker resolves);
* data sources (``work/asm_data/data-NNN.s``, generated at build time and never committed): ``.data`` and ``IMG:`` are
  dropped, every ``.org <offset>`` starts a section of its own (``.d<batch>_<n>``, alignment 1) and
  ``<label> - IMG + <origin>`` becomes the label.

Any other form containing ``.text`` or ``IMG`` is an error.  The linker script places each section at its virtual
address inside the output section of its PE section; the placements must tile every PE section's raw data exactly
(no gap, no overlap), and the script asserts that every function symbol ends up at the address in its name, and the gaps ld would fill use a byte (0xdb) no source writes.  Nothing
here claims original source or compiler provenance, and the result is not a claim of a whole-file x86 match.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Any, Optional

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT = SCRIPT_DIR.parent
REPOSITORY = PROJECT.parent.parent
IMAGE_DIR = PROJECT / "image"
DEFAULT_PREFIX = REPOSITORY / "work" / "tools" / "s08-binutils-2.43.1" / "prefix"
DEFAULT_ORIGINAL = REPOSITORY / "work" / "original" / "GAME.EXE"
DEFAULT_BUILD = PROJECT / "build" / "game"
DEFAULT_DATA_BUILD = REPOSITORY / "work" / "asm_data"

ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
ORIGINAL_SIZE = 1511424
IMAGE_BASE = 0x400000
TEXT_BASE = 0x401000
TARGET = "i686-w64-mingw32"
VERSION_LINES = {
    "as": "GNU assembler (GNU Binutils) 2.43.1",
    "ld": "GNU ld (GNU Binutils) 2.43.1",
    "objcopy": "GNU objcopy (GNU Binutils) 2.43.1",
}
CODE_SECTION = ".fn"


class LinkError(Exception):
    pass


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def file_sha256(path: Path) -> str:
    return sha256(path.read_bytes())


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def num(value: Any) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise LinkError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules.setdefault(name, module)
    spec.loader.exec_module(module)
    return module


# --------------------------------------------------------------------------
# tools
# --------------------------------------------------------------------------


def tool_path(prefix: Path, name: str) -> Path:
    return prefix / "bin" / f"{TARGET}-{name}"


def check_tools(prefix: Path) -> dict[str, Any]:
    """The pinned assembler (version line plus its fixed-source self-test, as in the audits) and the linker and
    objcopy of the same binutils 2.43.1 (version lines).  Returns the facts recorded in the report."""
    info: dict[str, Any] = {}
    auditor = load_module("audit_tool_assisted_for_link", PROJECT / "scripts" / "audit_tool_assisted.py")
    problem, as_info = auditor.check_assembler(tool_path(prefix, "as"))
    if problem:
        raise LinkError(f"assembler: {problem}")
    info["as"] = {"version_line": as_info.get("version_line"), "self_test": as_info.get("self_test")}
    for name in ("ld", "objcopy"):
        path = tool_path(prefix, name)
        if not path.is_file():
            raise LinkError(f"{name} is missing at {path}; build binutils 2.43.1 with scripts/bootstrap_matching_s08_2_gas.sh and scripts/bootstrap_binutils_link_tools.sh")
        try:
            out = subprocess.run([str(path), "--version"], capture_output=True, text=True, check=True).stdout
        except (OSError, subprocess.CalledProcessError) as exc:
            raise LinkError(f"{name} cannot report its version: {exc}") from exc
        line = out.splitlines()[0] if out.splitlines() else ""
        if line != VERSION_LINES[name]:
            raise LinkError(f"{name} is {line!r}, not the pinned {VERSION_LINES[name]!r}")
        info[name] = {"version_line": line}
    return info


# --------------------------------------------------------------------------
# image geometry
# --------------------------------------------------------------------------


class Geometry:
    """The image as linker output sections: maximal runs of the PE sections (headers included) whose virtual address
    minus file offset is constant and that follow each other in the file.  Each is (name, VMA, file offset, raw size)."""

    def __init__(self, image_dir: Path = IMAGE_DIR) -> None:
        layout = load_json(image_dir / "layout.json")
        sections = layout["sections"]
        first_raw = min(num(s["raw_pointer"]) for s in sections)
        parts = [("<headers>", IMAGE_BASE, 0, first_raw)]
        for s in sorted(sections, key=lambda s: num(s["raw_pointer"])):
            parts.append((s["name"], IMAGE_BASE + num(s["virtual_address"]), num(s["raw_pointer"]), num(s["raw_size"])))
        self.out: list[dict[str, Any]] = []
        for pe, vma, offset, size in parts:
            last = self.out[-1] if self.out else None
            if last is not None and last["offset"] + last["size"] == offset and last["vma"] - last["offset"] == vma - offset:
                last["size"] += size
                last["pe"] += "+" + pe
                continue
            self.out.append({"name": f".z{len(self.out) + 1}", "pe": pe, "vma": vma, "offset": offset, "size": size})
        self.file_size = max(o["offset"] + o["size"] for o in self.out)

    def section_of_offset(self, offset: int, length: int) -> dict[str, Any]:
        for o in self.out:
            if o["offset"] <= offset and offset + length <= o["offset"] + o["size"]:
                return o
        raise LinkError(f"file range {offset:#x}+{length:#x} lies in no output section")

    def offset_of_va(self, va: int) -> int:
        for o in self.out:
            if o["vma"] <= va < o["vma"] + o["size"]:
                return o["offset"] + (va - o["vma"])
        raise LinkError(f"address {va:#x} lies in no output section")


# --------------------------------------------------------------------------
# rewriting
# --------------------------------------------------------------------------

_ORG = re.compile(r"^\.org (0x[0-9a-f]+) - 0x401000(\s*#.*)?$")
_SET_EXTERNAL = re.compile(r"^\.set ([A-Za-z0-9_]+), \.text \+ \((0x[0-9a-f]+) - 0x401000\)(\s*#.*)?$")
_SET_TABLE_VA = re.compile(r"^\.set ([A-Za-z0-9_]+_VA), ([A-Za-z0-9_]+) - \.text \+ 0x401000(\s*#.*)?$")
_LONG_CASE = re.compile(r"^(\s+\.long )([A-Za-z0-9_]+) - \.text \+ 0x401000(\s*#.*)?$")
_TEXT_TOKEN = re.compile(r"(?<![A-Za-z0-9_])\.text(?![A-Za-z0-9_])")


def code_comment_free(line: str) -> str:
    return line.partition("#")[0]


def rewrite_code(text: str, name: str) -> tuple[str, int, dict[str, int]]:
    """Link form of one audited function source.  Returns (text, start address, {external name: address})."""
    out: list[str] = []
    externals: dict[str, int] = {}
    start: Optional[int] = None
    section_seen = False
    for number, line in enumerate(text.splitlines(), 1):
        if line.startswith("#") or not line.strip():
            out.append(line)
            continue
        if line == ".text":
            if section_seen:
                raise LinkError(f"{name}:{number}: a second .text directive")
            section_seen = True
            out.append(f'.section {CODE_SECTION},"xr0"')
            continue
        m = _ORG.match(line)
        if m:
            address = int(m.group(1), 16)
            if start is None:
                start = address
                continue  # the linker places the section
            if address < start:
                raise LinkError(f"{name}:{number}: .org before the function start")
            out.append(f".org 0x{address - start:x}")
            continue
        m = _SET_EXTERNAL.match(line)
        if m:
            address = int(m.group(2), 16)
            if externals.setdefault(m.group(1), address) != address:
                raise LinkError(f"{name}:{number}: {m.group(1)} is set twice with different addresses")
            continue  # the linker script provides the symbol
        m = _SET_TABLE_VA.match(line)
        if m:
            out.append(f".set {m.group(1)}, {m.group(2)}{m.group(3) or ''}")
            continue
        m = _LONG_CASE.match(line)
        if m:
            out.append(f"{m.group(1)}{m.group(2)}{m.group(3) or ''}")
            continue
        if _TEXT_TOKEN.search(code_comment_free(line)):
            raise LinkError(f"{name}:{number}: a .text reference the link form does not rewrite: {line.strip()[:80]}")
        out.append(line)
    if start is None or not section_seen:
        raise LinkError(f"{name}: no .org / .text found")
    return "\n".join(out) + "\n", start, externals


_DATA_ORG = re.compile(r"^\.org (0x[0-9a-f]+)$")
_DATA_LONG_LABEL = re.compile(r"^(\.long )((?:DAT|STR|WSTR)_[0-9a-f]{8}) - IMG \+ (0x[0-9a-f]+)$")


def rewrite_data(text: str, batch: str, origin: int) -> tuple[str, list[tuple[str, int]]]:
    """Link form of one generated data source.  Returns (text, [(section name, virtual address)] in order)."""
    out: list[str] = []
    sections: list[tuple[str, int]] = []
    for number, line in enumerate(text.splitlines(), 1):
        if line.startswith("#"):
            out.append(line)
            continue
        if line == ".data" or line == "IMG:":
            continue
        m = _DATA_ORG.match(line)
        if m:
            section = f".d{batch}_{len(sections)}"
            sections.append((section, origin + int(m.group(1), 16)))
            out.append(f'.section {section},"dw0"')
            continue
        m = _DATA_LONG_LABEL.match(line)
        if m:
            if int(m.group(3), 16) != origin:
                raise LinkError(f"data-{batch}:{number}: label pointer with a base other than the batch origin")
            out.append(f"{m.group(1)}{m.group(2)}")
            continue
        if re.search(r"(?<![A-Za-z0-9_])IMG(?![A-Za-z0-9_])", line.partition("#")[0]):
            raise LinkError(f"data-{batch}:{number}: an IMG reference the link form does not rewrite")
        if not sections and not line.startswith(".set ") and line != ".intel_syntax noprefix":
            raise LinkError(f"data-{batch}:{number}: content before the first .org: {line[:60]}")
        out.append(line)
    if not sections:
        raise LinkError(f"data-{batch}: no .org found")
    return "\n".join(out) + "\n", sections


# --------------------------------------------------------------------------
# prepare
# --------------------------------------------------------------------------


def span_of(function: dict[str, Any]) -> tuple[int, int]:
    """(first, last+1) file offset... as virtual addresses: the code part and its data items are contiguous."""
    lo = IMAGE_BASE + num(function["code"]["rva"])
    hi = lo + num(function["code"]["size"])
    for item in function.get("data_items", []):
        item_lo = IMAGE_BASE + num(item["rva"])
        lo = min(lo, item_lo)
        hi = max(hi, item_lo + num(item["size"]))
    return lo, hi


def load_function_sources(reconstructed: dict[str, Any]) -> list[dict[str, Any]]:
    """Every function of the audited asm batches, each with its source, VA extent and the audit facts the build needs."""
    functions: list[dict[str, Any]] = []
    for batch in reconstructed.get("asm_batches", []):
        manifest_path = PROJECT / batch["manifest"]
        report_path = PROJECT / batch["report"]
        manifest = load_json(manifest_path)
        report = load_json(report_path)
        if manifest.get("original_sha256") != ORIGINAL_SHA256:
            raise LinkError(f"{batch['manifest']}: describes a different original")
        if report.get("manifest_sha256") != file_sha256(manifest_path) or not report.get("all_accepted") or report.get("errors"):
            raise LinkError(f"{batch['report']}: the audit report is stale or does not accept every function")
        for function in manifest["functions"]:
            source = manifest_path.parent / function["source"]
            if file_sha256(source) != function["source_sha256"]:
                raise LinkError(f"{function['source']}: differs from the audited source hash")
            lo, hi = span_of(function)
            functions.append({"batch": manifest["batch"], "function": function["function"], "source": source, "lo": lo, "hi": hi, "symbol": function["code"]["symbol"]})
    return functions


def extract_data_sources(reconstructed: dict[str, Any], original: bytes, data_build: Path) -> list[dict[str, Any]]:
    """Regenerate each data batch's source from the owner's local original (the only step that reads it), refuse it unless
    the committed hash and layout match, and write it under ``data_build`` (a build output, never committed)."""
    data_asm = load_module("data_asm_for_link", PROJECT / "scripts" / "data_asm.py")
    batches: list[dict[str, Any]] = []
    for batch in reconstructed.get("data_batches", []):
        manifest_path = PROJECT / batch["manifest"]
        report = load_json(PROJECT / batch["report"])
        manifest = load_json(manifest_path)
        if manifest.get("original_sha256") != ORIGINAL_SHA256:
            raise LinkError(f"{batch['manifest']}: describes a different original")
        if report.get("manifest_sha256") != file_sha256(manifest_path) or not report.get("all_accepted") or report.get("errors"):
            raise LinkError(f"{batch['report']}: the audit report is stale or does not accept every byte")
        if not data_asm.safe_batch_names(manifest):
            raise LinkError(f"{batch['manifest']}: source and layout must be plain data-NNN names")
        text = data_asm.regenerate_source(manifest, original)
        if sha256(text.encode("utf-8")) != manifest["source_sha256"]:
            raise LinkError(f"{manifest['source']}: the source regenerated from this GAME.EXE differs from the audited hash")
        issues, _ = data_asm.layout_problems(manifest, manifest_path.parent, text)
        if issues:
            raise LinkError(f"{manifest['layout']}: {issues[0]}")
        lexical, _ = data_asm.audit_source(text, data_asm.source_expectation(manifest, data_asm.load_sections()))
        if lexical:
            raise LinkError(f"{manifest['source']}: {lexical[0]}")
        data_build.mkdir(parents=True, exist_ok=True)
        (data_build / manifest["source"]).write_text(text, encoding="utf-8")
        batches.append({"batch": manifest["batch"], "manifest": manifest, "text": text})
    return batches


def tile_check(geometry: Geometry, placements: list[dict[str, Any]]) -> None:
    """Every output section must be tiled exactly by the placements (no gap, no overlap)."""
    for o in geometry.out:
        mine = sorted((p for p in placements if p["section"] is o), key=lambda p: p["offset"])
        cursor = o["offset"]
        for p in mine:
            if p["offset"] != cursor:
                kind = "gap" if p["offset"] > cursor else "overlap"
                raise LinkError(f"{o['pe']}: {kind} at file offset {cursor:#x} before {p['name']} ({p['offset']:#x})")
            cursor = p["offset"] + p["length"]
        if cursor != o["offset"] + o["size"]:
            raise LinkError(f"{o['pe']}: placements end at {cursor:#x}, the section's raw data ends at {o['offset'] + o['size']:#x}")


def cmd_prepare(args: argparse.Namespace) -> int:
    tools = check_tools(args.prefix)
    reconstructed = load_json(IMAGE_DIR / "reconstructed.json")
    original = args.original.read_bytes()
    if sha256(original) != ORIGINAL_SHA256:
        raise LinkError(f"{args.original} is not the pinned GAME.EXE (SHA-256 mismatch)")
    geometry = Geometry()
    out: Path = args.out
    src_dir, obj_dir = out / "src", out / "obj"
    for d in (src_dir, obj_dir):
        d.mkdir(parents=True, exist_ok=True)
    for stale in src_dir.glob("*.s"):
        stale.unlink()

    placements: list[dict[str, Any]] = []
    externals: dict[str, int] = {}
    stems: list[str] = []

    functions = load_function_sources(reconstructed)
    for f in functions:
        text = f["source"].read_text(encoding="utf-8")
        link_text, start, ext = rewrite_code(text, f["source"].name)
        if start != f["lo"]:
            raise LinkError(f"{f['source'].name}: starts at {start:#x} but its extent starts at {f['lo']:#x}")
        for key, value in ext.items():
            if externals.setdefault(key, value) != value:
                raise LinkError(f"{key} is set to two different addresses")
        stem = f["source"].stem
        (src_dir / f"{stem}.s").write_text(link_text, encoding="utf-8")
        stems.append(stem)
        offset = geometry.offset_of_va(f["lo"])
        placements.append(
            {
                "name": stem,
                "kind": "function",
                "vma": f["lo"],
                "offset": offset,
                "length": f["hi"] - f["lo"],
                "section": geometry.section_of_offset(offset, f["hi"] - f["lo"]),
                "pattern": f"*/{stem}.o({CODE_SECTION})",
                "symbol": f["symbol"],
            }
        )

    data = extract_data_sources(reconstructed, original, args.data_build)
    for d in data:
        manifest = d["manifest"]
        origin = num(manifest["origin_va"])
        link_text, sections = rewrite_data(d["text"], d["batch"], origin)
        ranges = manifest["ranges"]
        groups: list[list[dict[str, Any]]] = [[] for _ in sections]
        for entry in ranges:
            va = num(entry["va"])
            index = max((i for i, (_, section_va) in enumerate(sections) if section_va <= va), default=None)
            if index is None:
                raise LinkError(f"data-{d['batch']}: range {entry['va']} precedes the first .org")
            groups[index].append(entry)
        stem = f"data-{d['batch']}"
        (src_dir / f"{stem}.s").write_text(link_text, encoding="utf-8")
        stems.append(stem)
        for (section, va), members in zip(sections, groups):
            if not members or num(members[0]["va"]) != va:
                raise LinkError(f"{stem}: section {section} at {va:#x} does not start at a manifest range")
            for previous, following in zip(members, members[1:]):
                if num(previous["va"]) + num(previous["length"]) != num(following["va"]) or num(previous["offset"]) + num(previous["length"]) != num(following["offset"]):
                    raise LinkError(f"{stem}: ranges inside section {section} are not contiguous")
            offset = num(members[0]["offset"])
            length = sum(num(m["length"]) for m in members)
            target = geometry.section_of_offset(offset, length)
            if target["vma"] + (offset - target["offset"]) != va:
                raise LinkError(f"{stem}: section {section} is not at the virtual address of its file offset")
            placements.append(
                {
                    "name": f"{stem}:{section}",
                    "kind": "data",
                    "vma": va,
                    "offset": offset,
                    "length": length,
                    "section": target,
                    "pattern": f"*/{stem}.o({section})",
                }
            )

    tile_check(geometry, placements)

    # linker script
    lines = [
        "/* Link script of the single GAME.EXE build (generated by scripts/link_image.py prepare; do not edit). */",
        "/* Each placement is a section of a link-form source; offsets are from the start of the PE section's output section. */",
        "SECTIONS",
        "{",
    ]
    for o in geometry.out:
        lines.append(f"  /* {o['pe']}: file offset {o['offset']:#x}, {o['size']:#x} bytes */")
        lines.append(f"  {o['name']} {o['vma']:#x} :")
        lines.append("  {")
        for p in sorted((p for p in placements if p["section"] is o), key=lambda p: p["offset"]):
            lines.append(f"    . = {p['offset'] - o['offset']:#x}; {p['pattern']}")
        lines.append("  } =0xdb")  # a byte no source writes: a section that is smaller than its slot breaks the hash instead of reading as zero fill
    lines.append("}")
    defined_by_object = {p["symbol"] for p in placements if p["kind"] == "function"}
    for key in sorted(externals):
        if key not in defined_by_object:
            lines.append(f"PROVIDE({key} = {externals[key]:#x});")
    for p in sorted((p for p in placements if p["kind"] == "function"), key=lambda p: p["vma"]):
        lines.append(f'ASSERT({p["symbol"]} == {p["vma"]:#x}, "{p["symbol"]} is not at its address");')
    (out / "link.ld").write_text("\n".join(lines) + "\n", encoding="utf-8")

    ld_args = [
        "--oformat", "pe-i386", "--disable-reloc-section", "--image-base", f"{IMAGE_BASE:#x}", "--entry", f"{TEXT_BASE:#x}",
        "-T", "link.ld", "-Map", "link.map", "-o", "game.pe",
    ]
    (out / "link.rsp").write_text("\n".join(ld_args + [f"obj/{stem}.o" for stem in stems]) + "\n", encoding="utf-8")
    objcopy_args = ["-O", "binary"]
    for o in geometry.out:
        objcopy_args += ["--change-section-lma", f"{o['name']}={o['offset']:#x}"]
    objcopy_args += ["game.pe", "GAME.linked.exe"]
    (out / "objcopy.rsp").write_text("\n".join(objcopy_args) + "\n", encoding="utf-8")
    (out / "assemble.list").write_text("\n".join(stems) + "\n", encoding="utf-8")

    report = {
        "schema": "blackmoor-link-report/1",
        "tools": tools,
        "original_sha256": ORIGINAL_SHA256,
        "functions": len(functions),
        "function_bytes": sum(p["length"] for p in placements if p["kind"] == "function"),
        "data_sources": len(data),
        "data_sections": sum(1 for p in placements if p["kind"] == "data"),
        "data_bytes": sum(p["length"] for p in placements if p["kind"] == "data"),
        "provided_external_symbols": len(externals) - len([k for k in externals if k in defined_by_object]),
        "output_sections": [{"name": o["name"], "pe": o["pe"], "vma": f"{o['vma']:#x}", "offset": f"{o['offset']:#x}", "size": o["size"]} for o in geometry.out],
        "expected_file_size": geometry.file_size,
        "linker_script_sha256": file_sha256(out / "link.ld"),
    }
    (out / "link-report.json").write_text(json.dumps(report, indent=1) + "\n", encoding="utf-8")
    print(
        f"prepared {len(functions):,} function sources and {len(data)} data sources "
        f"({report['function_bytes']:,} + {report['data_bytes']:,} bytes placed, {report['provided_external_symbols']:,} provided symbols)"
    )
    return 0


def cmd_verify(args: argparse.Namespace) -> int:
    data = args.exe.read_bytes()
    digest = sha256(data)
    ok = digest == ORIGINAL_SHA256 and len(data) == ORIGINAL_SIZE
    print(f"linked {len(data):,} bytes; sha256 {digest}")
    print(f"output hash equals the original (build evidence, not an x86 match claim): {ok}")
    if args.compare is not None:
        other = args.compare.read_bytes()
        same = other == data
        print(f"identical to {args.compare}: {same}")
        ok = ok and same
    return 0 if ok else 1


def make_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="cmd", required=True)
    a = sub.add_parser("prepare")
    a.add_argument("--prefix", type=Path, default=DEFAULT_PREFIX, help="binutils 2.43.1 install prefix (bin/i686-w64-mingw32-{as,ld,objcopy})")
    a.add_argument("--original", type=Path, default=DEFAULT_ORIGINAL)
    a.add_argument("--out", type=Path, default=DEFAULT_BUILD)
    a.add_argument("--data-build", type=Path, default=DEFAULT_DATA_BUILD, help="where the extracted data sources go (never committed)")
    a.set_defaults(func=cmd_prepare)
    v = sub.add_parser("verify")
    v.add_argument("exe", type=Path)
    v.add_argument("--compare", type=Path, help="also require byte equality with this file (the composer's image)")
    v.set_defaults(func=cmd_verify)
    return p


def main(argv: Optional[list[str]] = None) -> int:
    args = make_parser().parse_args(argv)
    try:
        return args.func(args)
    except LinkError as exc:
        print(f"link_image: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
