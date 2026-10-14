#!/usr/bin/env python3
"""Audit a batch of tool-assisted reconstructed assembly (packet M03).

A function enters the ``tool_assisted_reconstructed_assembly`` class only when
this auditor accepts it *and* root accepts the independent review.  For every
function in a batch manifest the auditor

* reassembles the committed ``.s`` with the pinned ``i686-w64-mingw32-as``
  2.43.1 (never with Xcode's assembler) and rejects an object that carries any
  relocation or that differs from a supplied pre-built object;
* compares the function symbol's bytes with the original *code part*, and each
  emitted data item (switch table, index table, padding) with its original
  bytes separately, through ``verify_matches.py``;
* re-derives the span split (code / tables / padding) from the original with
  the generator's control-flow analysis and requires the manifest to agree, so
  that table bytes are never counted as code;
* rejects raw byte lists and unknown directives outside the permitted forms
  (``.insn`` in the five spellings of the M0 report, ``.long`` of symbolic case
  addresses and ``.byte`` index values and ``.fill`` of ``int3``/``nop``
  inside data items only);
* rejects missing or placeholder annotation fields, unnamed ``[ebp±n]``
  frame offsets and basic blocks without a real comment;
* records source, object, assembler and original-extent hashes (never original
  byte values) in the report.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
import struct
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Optional

PROJECT = Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
WORK = REPOSITORY / "work"
SCRIPTS = PROJECT / "scripts"

BINUTILS_SHA512 = "20977ad17729141a2c26d358628f44a0944b84dcfefdec2ba029c2d02f40dfc41cc91c0631044560d2bd6f9a51e1f15846b4b311befbe14f1239f14ff7d57824"
ASSEMBLER_VERSION_LINE = "GNU assembler (GNU Binutils) 2.43.1"
CLASS_NAME = "tool_assisted_reconstructed_assembly"
BASELINE_MANIFESTS = (
    "matches.json",
    "matches_s08.json",
    "matches_s08_2.json",
    "matches_s08_2_x86.json",
    "matches_s08_3_x86.json",
    "matches_s08_4_x86.json",
)

REQUIRED_FIELDS = (
    "class", "va", "extent", "span", "sha256", "evidence", "region", "frame",
    "name", "arguments", "locals", "fields", "callees", "track-n", "unverified",
)
ANNOTATION_FIELDS = ("name", "arguments", "locals", "fields", "callees", "track-n", "unverified")
PLACEHOLDERS = ("<unfilled>", "todo", "tbd", "fixme", "xxx", "unknown", "n/a", "none yet")


def load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


gen = load_module("gen_hinted_asm_for_audit", SCRIPTS / "gen_hinted_asm.py")
verifier = load_module("verify_matches_for_audit", SCRIPTS / "verify_matches.py")


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


# ---------------------------------------------------------------------------
# Lexical audit of one .s file
# ---------------------------------------------------------------------------

_LABEL = re.compile(r"^([A-Za-z_.][\w.$]*):$")
_HINT = re.compile(r"^\{(load|store|disp8|disp32)\}$")
_ADDRESS_COMMENT = re.compile(r"^[0-9a-f]{8}$")
_INSN_SPELLINGS = (
    re.compile(r"^\.insn 0x66, 0x(?:05|0d|25|2d|3d), 0x[0-9a-f]{1,4}\{:u16\}$"),
    re.compile(r"^\.insn 0x05, 0x[0-9a-f]{1,8}\{:u32\}$"),
    re.compile(r"^\.insn 0xdc, 0xc0$"),
    re.compile(r"^\.insn 0x6681/[0-7], (?:e[a-ds][xip]|e[sd]i|ebp|esp), -?\d+\{:s16\}$"),
    re.compile(r"^\.insn 0x6681/[0-7], dword ptr \[[^\]]+\], -?\d+\{:s16\}$"),
)
_NUMBER = re.compile(r"(?<![\w.])(?:0x[0-9a-fA-F]+|\d+)(?![\w])")
_DEFAULT_FRAME_NAME = re.compile(r"^(?:local|arg)_[0-9a-f]+$")
_TERMINAL = {"ret", "retf", "lret", "iret", "iretd", "hlt", "ud2", "jmp", "ljmp"}
_NOP_LIKE = re.compile(r"^(?:nop|int3|mov (e[a-d]x|e[sd]i|e[sb]p), \1|lea (e[a-d]x|e[sd]i|e[sb]p), \[\2\])$")
_SWTAB_LONG = re.compile(r"^\.long (?:L_[0-9a-f]{8}|[A-Za-z_]\w*) - \.text \+ 0x[0-9a-f]+$")
_ORG = re.compile(r"^\.org 0x[0-9a-f]{8} - 0x[0-9a-f]+$")
_EQU = re.compile(r"^\.equ ([A-Za-z_]\w*), 0x[0-9a-f]+$")
_SET_EXTERNAL = re.compile(r"^\.set ((?:FUN|LOC)_[0-9a-f]{8}), \.text \+ \(0x[0-9a-f]{8} - 0x[0-9a-f]+\)$")
_SET_TABLE = re.compile(r"^\.set ((?:SWTAB|IDXTAB)_[0-9a-f]{8}_VA), (?:SWTAB|IDXTAB)_[0-9a-f]{8} - \.text \+ 0x[0-9a-f]+$")
_FILL = re.compile(r"^\.fill (\d+), 1, 0x(cc|90)$")
_BYTE_LIST = re.compile(r"^\.byte (?:\d{1,3})(?:, \d{1,3})*$")


@dataclass
class Line:
    number: int
    raw: str
    code: str
    comment: str


def split_lines(text: str) -> list[Line]:
    out = []
    for number, raw in enumerate(text.splitlines(), 1):
        code, _, comment = raw.partition("#")
        out.append(Line(number, raw, code.strip(), comment.strip()))
    return out


def meaningful(comment: str) -> bool:
    """A comment that says something, not a generator address or stub."""

    text = comment.strip()
    if not text:
        return False
    if re.match(r"^block 0x[0-9a-f]+:", text):
        text = text.split(":", 1)[1].strip()
    if text.startswith("->"):
        return False
    text = _ADDRESS_COMMENT.sub("", text).strip()
    if "<unfilled>" in text:
        return False
    return len(text) >= 8 and re.search(r"[A-Za-z]{3}", text) is not None


def parse_header(lines: list[Line]) -> dict[str, str]:
    header: dict[str, str] = {}
    for line in lines:
        if line.code:
            break
        match = re.match(r"^([a-z][a-z0-9-]*):\s*(.*)$", line.comment)
        if match:
            header.setdefault(match.group(1), match.group(2).strip())
    return header


def mnemonic_of(code: str) -> str:
    tokens = code.split()
    while tokens and _HINT.match(tokens[0]):
        tokens.pop(0)
    if not tokens:
        return ""
    return re.sub(r"\.d(?:8|32)$", "", tokens[0])


def audit_source(text: str, header_expect: dict[str, Any], code_symbol: str) -> tuple[list[str], dict[str, Any]]:
    """Lexical checks; returns (reasons, facts)."""

    reasons: list[str] = []
    lines = split_lines(text)
    header = parse_header(lines)
    facts: dict[str, Any] = {"header": header}

    if "<unfilled>" in text:
        reasons.append("source still contains <unfilled> placeholders")
    for key in REQUIRED_FIELDS:
        if key not in header:
            reasons.append(f"header field {key!r} is missing")
    for key in ANNOTATION_FIELDS:
        value = header.get(key, "")
        if not value or value.lower() in PLACEHOLDERS or "<unfilled>" in value:
            reasons.append(f"header field {key!r} is empty or a placeholder")
    name = header.get("name", "")
    if name and (not re.match(r"^[A-Za-z_][A-Za-z0-9_:.]*$", name) or re.match(r"^FUN_[0-9a-f]{8}$", name)):
        reasons.append(f"function name {name!r} is not a real name")
    track = header.get("track-n", "")
    if track and track != "host-adapter: none":
        if not re.match(r"^[\w./+-]+:[\w:~]+( .*)?$", track):
            reasons.append("track-n is neither 'host-adapter: none' nor '<repo path>:<symbol>'")
    for key, expected in header_expect.items():
        if header.get(key) != expected:
            reasons.append(f"header {key!r} is {header.get(key)!r}, expected {expected!r}")
    if header.get("class", "").split(" ")[0] != CLASS_NAME:
        reasons.append("header class is not tool_assisted_reconstructed_assembly")

    state = "preamble"  # preamble | code | data
    data_kind = ""
    labels: set[str] = set()
    code_lines: list[Line] = []
    globl_seen = False
    entry_seen = False
    last_code_mnemonic = ""
    ebp_frame = header.get("frame") == "ebp"
    placeholder_frame_names: set[str] = set()
    for line in lines:
        code = line.code
        if not code:
            continue
        if code in (".intel_syntax noprefix", ".code32", ".text"):
            continue
        label = _LABEL.match(code)
        if label:
            name = label.group(1)
            labels.add(name)
            if name == code_symbol:
                entry_seen = True
                state = "code"
            elif state == "code" and name.startswith(("SWTAB_", "IDXTAB_", "PAD_")):
                reasons.append(f"line {line.number}: data label {name} inside the code part (missing .org)")
            elif state == "data" or name.startswith(("SWTAB_", "IDXTAB_", "PAD_")):
                data_kind = name.split("_", 1)[0]
                state = "data"
            if state == "code":
                code_lines.append(line)
            continue
        if code.startswith("."):
            if _EQU.match(code):
                equ = _EQU.match(code).group(1)
                if _DEFAULT_FRAME_NAME.match(equ):
                    reasons.append(f"line {line.number}: frame symbol {equ} still has the generator's default name")
                continue
            if _SET_EXTERNAL.match(code) or _SET_TABLE.match(code):
                continue
            if code.startswith(".globl "):
                if code != f".globl {code_symbol}":
                    reasons.append(f"line {line.number}: unexpected .globl {code}")
                globl_seen = True
                continue
            if _ORG.match(code):
                if state == "code" and entry_seen:
                    state = "data"
                    data_kind = ""
                continue
            if any(pattern.match(code) for pattern in _INSN_SPELLINGS):
                if state != "code":
                    reasons.append(f"line {line.number}: .insn outside the code part")
                else:
                    code_lines.append(line)
                    last_code_mnemonic = ".insn"
                continue
            if state == "data" and data_kind == "SWTAB" and _SWTAB_LONG.match(code):
                continue
            if state == "data" and data_kind == "IDXTAB" and _BYTE_LIST.match(code):
                if any(int(v) > 255 for v in re.findall(r"\d+", code)):
                    reasons.append(f"line {line.number}: index byte out of range")
                continue
            if state == "data" and data_kind == "PAD" and _FILL.match(code):
                continue
            reasons.append(f"line {line.number}: directive or raw data not permitted here: {code.split()[0]}")
            continue
        # instruction
        if state == "data":
            if data_kind == "PAD" and _NOP_LIKE.match(re.sub(r"^(\{[a-z0-9]+\} )+", "", code)):
                continue
            reasons.append(f"line {line.number}: instruction inside a data item: {code}")
            continue
        if state != "code":
            reasons.append(f"line {line.number}: instruction before the function label")
            continue
        code_lines.append(line)
        last_code_mnemonic = mnemonic_of(code)
        if ebp_frame:
            for operand in re.findall(r"\[([^\]]*)\]", code):
                if "ebp" not in operand:
                    continue
                stripped = re.sub(r"(?<![\w.])[1248]\*", "", operand)
                if _NUMBER.search(stripped):
                    reasons.append(f"line {line.number}: unnamed [ebp±n] offset in [{operand}]")
                for token in re.findall(r"[A-Za-z_]\w*", operand):
                    if _DEFAULT_FRAME_NAME.match(token) and token not in placeholder_frame_names:
                        placeholder_frame_names.add(token)
                        reasons.append(f"line {line.number}: frame offset uses placeholder name {token}")
    if not entry_seen:
        reasons.append(f"function label {code_symbol} is missing")
    if not globl_seen:
        reasons.append(f"missing .globl {code_symbol}")
    facts["labels"] = sorted(labels)

    # code part must end at a terminal instruction or tail into data
    if last_code_mnemonic and last_code_mnemonic not in _TERMINAL:
        data_follows = any(
            _LABEL.match(l.code) and _LABEL.match(l.code).group(1).startswith(("SWTAB_", "IDXTAB_", "PAD_"))
            for l in lines
        )
        if not (data_follows and last_code_mnemonic == "call"):
            reasons.append(f"code part ends in {last_code_mnemonic!r}, not a terminal ret/jmp or a tail into data")

    # one real comment per basic block
    reasons_blocks = _block_comment_audit(lines, code_symbol)
    reasons += reasons_blocks[0]
    facts["basic_blocks"] = reasons_blocks[1]
    return reasons, facts


def _block_comment_audit(lines: list[Line], code_symbol: str) -> tuple[list[str], int]:
    """Count basic blocks of the code part and flag those with no real comment."""

    reasons: list[str] = []
    started = False
    in_code = False
    blocks: list[dict[str, Any]] = []
    current: Optional[dict[str, Any]] = None
    pending = 0
    needs_new = True
    for line in lines:
        code = line.code
        label = _LABEL.match(code) if code else None
        if label and label.group(1) == code_symbol:
            started = in_code = True
        if not started:
            continue
        if code and (_ORG.match(code) or (label and label.group(1).startswith(("SWTAB_", "IDXTAB_", "PAD_")))):
            if code.startswith(".org"):
                in_code = False
            if label:
                in_code = False
        if not in_code:
            continue
        if not code:
            if meaningful(line.comment):
                pending += 1
            continue
        if label:
            if current is None or current["insns"] or needs_new:
                current = {"comments": 0, "insns": 0, "line": line.number}
                blocks.append(current)
            current["comments"] += pending
            pending = 0
            needs_new = False
            continue
        if code.startswith(".") and not code.startswith(".insn"):
            continue
        if needs_new or current is None:
            current = {"comments": 0, "insns": 0, "line": line.number}
            blocks.append(current)
            needs_new = False
        current["comments"] += pending + (1 if meaningful(line.comment) else 0)
        pending = 0
        current["insns"] += 1
        mnem = mnemonic_of(code)
        if mnem in _TERMINAL or mnem in gen._COND_JUMPS:
            needs_new = True
    if pending and blocks:
        blocks[-1]["comments"] += pending
    for block in blocks:
        if block["comments"] < 1:
            reasons.append(f"basic block at line {block['line']} has no comment")
    return reasons, len(blocks)


# ---------------------------------------------------------------------------
# Assembler provenance
# ---------------------------------------------------------------------------


def check_assembler(path: Path) -> tuple[Optional[str], dict[str, Any]]:
    info: dict[str, Any] = {"path": str(path)}
    if not path.is_file():
        return f"assembler {path} is missing", info
    try:
        out = subprocess.run([str(path), "--version"], capture_output=True, text=True, check=True).stdout
    except (OSError, subprocess.CalledProcessError) as exc:
        return f"assembler {path} cannot report its version: {exc}", info
    line = out.splitlines()[0] if out.splitlines() else ""
    info["version_line"] = line
    info["sha256"] = sha256(path.read_bytes())
    if line != ASSEMBLER_VERSION_LINE:
        return f"assembler is {line!r}, not the pinned {ASSEMBLER_VERSION_LINE!r}", info
    archive = path.parents[2] / "binutils-2.43.1.tar.xz"
    if archive.is_file():
        digest = hashlib.sha512(archive.read_bytes()).hexdigest()
        info["binutils_archive_sha512"] = digest
        if digest != BINUTILS_SHA512:
            return "binutils source archive does not match the pinned SHA-512", info
    else:
        info["binutils_archive_sha512"] = "archive not present beside the pinned prefix; version line only"
    return None, info


# ---------------------------------------------------------------------------
# Batch audit
# ---------------------------------------------------------------------------


@dataclass
class AuditConfig:
    original: Path = WORK / "original/GAME.EXE"
    index: Path = PROJECT / "function-index.json"
    assembler: Path = gen.AS_DEFAULT
    expected_sha256: str = gen.ORIGINAL_SHA256
    strict_image: bool = True
    repository: Optional[Path] = REPOSITORY
    baseline_dir: Optional[Path] = PROJECT
    image_base: int = 0x400000


def audit_manifest(manifest_path: Path, config: AuditConfig) -> dict[str, Any]:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    report: dict[str, Any] = {
        "batch": manifest.get("batch"),
        "class_requested": manifest.get("class"),
        "manifest_sha256": sha256(manifest_path.read_bytes()),
        "all_accepted": False,
        "contains_original_byte_values": False,
        "functions": [],
        "errors": [],
    }
    if manifest.get("class") != CLASS_NAME:
        report["errors"].append("manifest class is not tool_assisted_reconstructed_assembly")
    if manifest.get("original_sha256") != config.expected_sha256:
        report["errors"].append("manifest original_sha256 is not the pinned original")
    problem, assembler_info = check_assembler(config.assembler)
    report["assembler"] = assembler_info
    if problem:
        report["errors"].append(problem)
        return report
    entries = manifest.get("functions")
    if not isinstance(entries, list) or not entries:
        report["errors"].append("manifest has no functions")
        return report

    image = gen.load_image(config.original, config.index, config.expected_sha256, config.strict_image)
    report["original_sha256"] = config.expected_sha256
    vas = [int(entry["va"], 0) for entry in entries]
    layouts, _decoded = gen.analyze_all(image, vas)
    base_ranges = baseline_ranges(config)
    seen_ranges: list[tuple[int, int, str]] = []

    for entry, va in zip(entries, vas):
        result = audit_function(entry, va, layouts.get(va), image, manifest_path, config)
        report["functions"].append(result)
        if result["status"] == "accepted":
            lo = va
            hi = va + result["code"]["size"]
            for slo, shi, other in seen_ranges:
                if lo < shi and slo < hi:
                    result["status"] = "rejected"
                    result["reasons"].append(f"code range overlaps {other}")
            seen_ranges.append((lo, hi, entry["function"]))

    accepted = [f for f in report["functions"] if f["status"] == "accepted"]
    report["all_accepted"] = len(accepted) == len(report["functions"]) and not report["errors"]
    by_region: dict[str, dict[str, int]] = {}
    handoff = []
    new_code = 0
    overlap_code = 0
    for result in accepted:
        region = result["region"]
        row = by_region.setdefault(region, {"functions": 0, "code_bytes": 0, "data_bytes": 0})
        row["functions"] += 1
        row["code_bytes"] += result["code"]["size"]
        row["data_bytes"] += sum(item["size"] for item in result["data_items"])
        va = result["va"]
        size = result["code"]["size"]
        covered = sum(max(0, min(va + size, bhi) - max(va, blo)) for blo, bhi in base_ranges)
        overlap_code += covered
        new_code += size - covered
        for item in result["data_items"]:
            handoff.append({"function": result["function"], **item})
    report["accepted_count"] = len(accepted)
    report["code_bytes_accepted"] = sum(f["code"]["size"] for f in accepted)
    report["by_region"] = by_region
    report["data_items_for_m02"] = handoff
    report["baseline"] = {
        "manifests": [name for name in BASELINE_MANIFESTS if config.baseline_dir and (config.baseline_dir / name).exists()],
        "baseline_matched_bytes": sum(hi - lo for lo, hi in base_ranges),
        "batch_bytes_overlapping_baseline": overlap_code,
        "batch_bytes_not_in_baseline": new_code,
    }
    report["note"] = (
        "Accepted functions are candidates for the tool_assisted_reconstructed_assembly class; they count "
        "only after root accepts the independent review. No claim is made about original C++ or compiler provenance."
    )
    return report


def baseline_ranges(config: AuditConfig) -> list[tuple[int, int]]:
    ranges: list[tuple[int, int]] = []
    if not config.baseline_dir:
        return ranges
    for name in BASELINE_MANIFESTS:
        path = config.baseline_dir / name
        if not path.exists():
            continue
        data = json.loads(path.read_text(encoding="utf-8"))
        for row in data.get("functions", []):
            ranges.append((config.image_base + int(row["rva"]), config.image_base + int(row["rva"]) + int(row["size"])))
    merged: list[tuple[int, int]] = []
    for lo, hi in sorted(set(ranges)):
        if merged and lo <= merged[-1][1]:
            merged[-1] = (merged[-1][0], max(merged[-1][1], hi))
        else:
            merged.append((lo, hi))
    return merged


def audit_function(entry: dict[str, Any], va: int, layout, image, manifest_path: Path, config: AuditConfig) -> dict[str, Any]:
    name = entry.get("function", f"FUN_{va:08x}")
    result: dict[str, Any] = {
        "function": name,
        "va": va,
        "status": "rejected",
        "reasons": [],
        "region": gen.region_of(va),
        "code": {},
        "data_items": [],
        "contains_original_byte_values": False,
    }
    reasons: list[str] = result["reasons"]
    symbol = f"FUN_{va:08x}"
    if name != symbol:
        reasons.append(f"function name {name!r} does not match its VA {symbol}")
    source_path = (manifest_path.parent / entry["source"]).resolve()
    try:
        source_bytes = source_path.read_bytes()
    except OSError as exc:
        reasons.append(f"source unreadable: {exc}")
        return result
    text = source_bytes.decode("utf-8", "strict")
    result["source"] = {"path": entry["source"], "sha256": sha256(source_bytes)}
    if entry.get("source_sha256") != result["source"]["sha256"]:
        reasons.append("source_sha256 in the manifest is stale")

    # --- expected split from the original -----------------------------------
    if layout is None:
        reasons.append("function is not in the index")
        return result
    if layout.exceptions:
        reasons.append(f"generator cannot split this span: {layout.exceptions[:3]}")
    if getattr(layout, "falls_through", False):
        reasons.append("code part falls through into the next function; not a terminal ret/jmp")
    if layout.exceptions or getattr(layout, "falls_through", False):
        return result
    expected_code = {"rva": va - config.image_base, "size": layout.code_size}
    expected_items = [
        {"kind": item.kind, "rva": item.va - config.image_base, "size": item.size}
        for item in layout.data
    ]
    code = entry.get("code", {})
    if code.get("symbol") != symbol or code.get("rva") != expected_code["rva"] or code.get("size") != expected_code["size"]:
        reasons.append(
            f"manifest code part {code.get('rva')}/{code.get('size')} differs from the span split "
            f"{expected_code['rva']}/{expected_code['size']} (table or padding bytes counted as code?)"
        )
    got_items = [{"kind": i.get("kind"), "rva": i.get("rva"), "size": i.get("size")} for i in entry.get("data_items", [])]
    if got_items != expected_items:
        reasons.append("manifest data items differ from the span split of the original")
    original_hash = gen.code_hash(image, layout)
    if code.get("sha256") != original_hash:
        reasons.append("code sha256 in the manifest does not match the original extent")
    tile_end = layout.va + layout.code_size + sum(i.size for i in layout.data)
    if tile_end != layout.span_end:
        reasons.append("code part and data items do not tile the span")
    result["code"] = {"symbol": symbol, "rva": expected_code["rva"], "size": expected_code["size"], "sha256": original_hash}

    # --- lexical audit -------------------------------------------------------
    header_expect = {
        "va": f"0x{va:08x}",
        "sha256": original_hash,
        "region": gen.region_of(va),
        "extent": f"0x{va:08x}-0x{layout.code_end:08x} ({layout.code_size} code bytes)",
        "frame": "ebp" if gen.has_standard_frame(layout) else "none",
    }
    lexical, facts = audit_source(text, header_expect, symbol)
    reasons += lexical
    result["basic_blocks"] = facts.get("basic_blocks")
    track = facts["header"].get("track-n", "")
    if config.repository and track and track != "host-adapter: none":
        match = re.match(r"^([\w./+-]+):([\w:~]+)", track)
        if match:
            target = (config.repository / match.group(1))
            if not target.is_file():
                reasons.append(f"track-n file {match.group(1)} does not exist")
            elif match.group(2) not in target.read_text(encoding="utf-8", errors="replace"):
                reasons.append(f"track-n symbol {match.group(2)} is not in {match.group(1)}")

    # --- reassemble with the pinned assembler ----------------------------------
    with tempfile.TemporaryDirectory(prefix="m03-audit-") as tmp:
        tmp_path = Path(tmp)
        object_path = tmp_path / f"{symbol}.obj"
        source_copy = tmp_path / f"{symbol}.s"
        source_copy.write_bytes(source_bytes)
        run = subprocess.run([str(config.assembler), "--32", "-o", str(object_path), str(source_copy)], capture_output=True, text=True)
        if run.returncode != 0:
            detail = " ".join(run.stderr.replace(str(tmp_path) + "/", "").split())
            reasons.append("pinned assembler rejected the source: " + detail[:300])
            return result
        object_bytes = object_path.read_bytes()
        result["object"] = {"sha256": sha256(object_bytes), "size": len(object_bytes)}
        try:
            text_bytes, relocations, symbols = gen.coff_text(object_bytes)
        except (ValueError, struct.error) as exc:  # pragma: no cover - defensive
            reasons.append(f"object unreadable: {exc}")
            return result
        result["relocations"] = relocations
        if relocations:
            reasons.append(f"object carries {relocations} relocation(s); every target must resolve at assembly time")
        supplied = entry.get("object")
        if supplied:
            supplied_path = (manifest_path.parent / supplied).resolve()
            if not supplied_path.is_file():
                reasons.append(f"supplied object {supplied} is missing")
            elif supplied_path.read_bytes() != object_bytes:
                reasons.append("supplied object is not the pinned assembler's output for this source")
        # symbol table must hold the code and data symbols at their original offsets
        verify_functions = [
            {"rva": expected_code["rva"], "size": expected_code["size"], "symbol": symbol, "object": str(object_path)}
        ]
        if symbols.get(symbol) != va - image.base:
            reasons.append(f"symbol {symbol} is not at its original section offset")
        for item, expected in zip(entry.get("data_items", []), expected_items):
            sym = item.get("symbol")
            if not sym or sym not in symbols or symbols[sym] != expected["rva"] + config.image_base - image.base:
                reasons.append(f"data symbol {sym!r} is missing or misplaced")
                continue
            verify_functions.append({"rva": expected["rva"], "size": expected["size"], "symbol": sym, "object": str(object_path)})
        if len(verify_functions) != 1 + len(expected_items):
            return result
        verify_manifest = {
            "description": "M03 audit comparison (code part and data items separately)",
            "source": "audit_tool_assisted.py",
            "original_sha256": config.expected_sha256,
            "functions": verify_functions,
        }
        vm_path = tmp_path / "verify.json"
        vm_path.write_text(json.dumps(verify_manifest), encoding="utf-8")
        comparison = verifier.verify(config.original, vm_path)
        if comparison.get("error"):
            reasons.append(f"verify_matches error: {comparison['error']}")
        rows = comparison.get("functions", [])
        for row in rows:
            if row.get("status") != "exact-byte-range":
                where = "code part" if row.get("symbol") == symbol else f"data item {row.get('symbol')}"
                reasons.append(
                    f"{where} is {row.get('status')} ({len(row.get('differences', []))} differing byte(s); "
                    f"{row.get('error', '')})".strip()
                )
        result["compared_bytes"] = sum(r["size"] for r in rows if r.get("status") == "exact-byte-range")
        result["data_items"] = [
            {
                "kind": item["kind"],
                "symbol": entry["data_items"][i].get("symbol"),
                "rva": item["rva"],
                "size": item["size"],
                "sha256": hashlib.sha256(image.bytes_at(item["rva"] + config.image_base, item["rva"] + config.image_base + item["size"])).hexdigest(),
            }
            for i, item in enumerate(expected_items)
        ]
    if not reasons:
        result["status"] = "accepted"
    return result


def main(argv: Optional[list[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--original", type=Path, default=WORK / "original/GAME.EXE")
    parser.add_argument("--assembler", type=Path, default=gen.AS_DEFAULT)
    parser.add_argument("--report", type=Path)
    args = parser.parse_args(argv)
    config = AuditConfig(original=args.original, assembler=args.assembler)
    report = audit_manifest(args.manifest, config)
    encoded = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(encoded, encoding="utf-8")
    rejected = [f for f in report["functions"] if f["status"] != "accepted"]
    print(
        f"M03 audit: {report.get('accepted_count', 0)}/{len(report['functions'])} accepted, "
        f"{report.get('code_bytes_accepted', 0)} code bytes; errors={report['errors']}"
    )
    for f in rejected:
        print(f"  REJECTED {f['function']}: {f['reasons'][:4]}")
    return 0 if report["all_accepted"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
