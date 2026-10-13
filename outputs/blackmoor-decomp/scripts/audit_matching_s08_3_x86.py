#!/usr/bin/env python3
"""Audit S08-3's actual object, full extents, bytes, and source association."""
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
from typing import Any

PROJECT = Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
WORK = REPOSITORY / "work"
SOURCE = PROJECT / "src/matching_s08_3_x86.s"
MANIFEST = PROJECT / "matches_s08_3_x86.json"
GAS = WORK / "tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
EXPECTED_SOURCE_SHA256 = "b5ed9ea6659e8c179cc796cbcd0c4494b950ddbaadebed185cad92998f98ff44"
BINUTILS_SHA512 = "20977ad17729141a2c26d358628f44a0944b84dcfefdec2ba029c2d02f40dfc41cc91c0631044560d2bd6f9a51e1f15846b4b311befbe14f1239f14ff7d57824"
EVIDENCE_ID = "ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619"
EXPECTED = [
    {"rva": 0x0DAF9F, "va": 0x4DAF9F, "size": 36, "symbol": "_FUN_004daf9f"},
    {"rva": 0x0DAFC3, "va": 0x4DAFC3, "size": 61, "symbol": "_FUN_004dafc3"},
    {"rva": 0x0DB000, "va": 0x4DB000, "size": 79, "symbol": "_FUN_004db000"},
]
EXPECTED_TOTAL = sum(item["size"] for item in EXPECTED)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def json_sha256(value: Any) -> str:
    encoded = json.dumps(value, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return sha256(encoded)


def display_path(path: Path) -> str:
    resolved = path.resolve()
    try:
        return resolved.relative_to(REPOSITORY.resolve()).as_posix()
    except ValueError:
        return str(resolved)


def run(command: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, check=True, capture_output=True, text=True)


def load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load verifier at {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def parse_disassembly(object_path: Path) -> dict[str, list[dict[str, Any]]]:
    result = run(["xcrun", "llvm-objdump", "-d", "--x86-asm-syntax=intel", str(object_path)])
    functions: dict[str, list[dict[str, Any]]] = {}
    current: str | None = None
    label = re.compile(r"^\s*[0-9a-fA-F]+ <([^>]+)>:\s*$")
    instruction = re.compile(r"^\s*([0-9a-fA-F]+):\s*((?:[0-9a-fA-F]{2}\s+)+)([A-Za-z][A-Za-z0-9.]*)\s*(.*?)\s*$")
    for line in result.stdout.splitlines():
        match = label.match(line)
        if match:
            current = match.group(1)
            functions.setdefault(current, [])
            continue
        match = instruction.match(line)
        if match and current is not None:
            functions[current].append({
                "address": int(match.group(1), 16),
                "size": len(match.group(2).split()),
                "mnemonic": match.group(3).lower(),
                "operands": match.group(4).strip(),
            })
    return functions


def validate_object(object_path: Path) -> tuple[Any, dict[str, dict[str, Any]]]:
    verifier = load_module("s08_3_object_verifier", PROJECT / "scripts/verify_matches.py")
    obj = verifier._parse_coff_object(object_path.read_bytes())
    text_sections = [section for section in obj.sections if section.name == ".text"]
    if len(text_sections) != 1:
        raise ValueError(f"candidate must have exactly one .text section, found {len(text_sections)}")
    text = text_sections[0]
    if text.raw_size != EXPECTED_TOTAL:
        raise ValueError(f"candidate .text has {text.raw_size} bytes; expected exactly {EXPECTED_TOTAL}")
    if text.relocation_count:
        raise ValueError("candidate .text contains relocations")
    definitions = [
        symbol for symbol in obj.symbols
        if 1 <= symbol.section_number <= len(obj.sections)
        and obj.sections[symbol.section_number - 1].name == ".text"
        and symbol.name != ".text"
    ]
    names = [symbol.name for symbol in definitions]
    expected_names = [item["symbol"] for item in EXPECTED]
    if sorted(names) != sorted(expected_names):
        raise ValueError(f"candidate .text symbol set differs: expected {expected_names}, found {names}")

    disassembly = parse_disassembly(object_path)
    rows: dict[str, dict[str, Any]] = {}
    cursor = 0
    for item in EXPECTED:
        symbol_rows = [symbol for symbol in definitions if symbol.name == item["symbol"]]
        if len(symbol_rows) != 1:
            raise ValueError(f"candidate symbol {item['symbol']} is missing or ambiguous")
        symbol = symbol_rows[0]
        if symbol.value != cursor:
            raise ValueError(f"candidate symbol {item['symbol']} begins at +0x{symbol.value:x}; expected +0x{cursor:x}")
        code, _offset, _symbol = obj.symbol_bytes(item["symbol"], item["size"])
        instructions = disassembly.get(item["symbol"], [])
        instruction_cursor = symbol.value
        for instruction in instructions:
            if instruction["address"] != instruction_cursor:
                raise ValueError(f"candidate instruction gap in {item['symbol']} at +0x{instruction_cursor:x}")
            instruction_cursor += instruction["size"]
        if not instructions or instruction_cursor != symbol.value + item["size"]:
            raise ValueError(f"candidate {item['symbol']} does not decode across its full {item['size']}-byte extent")
        terminal = instructions[-1]
        if terminal["mnemonic"] != "ret" or terminal["operands"].strip() not in ("0x8", "8"):
            raise ValueError(f"candidate {item['symbol']} must end in ret 8; found {terminal}")
        rows[item["symbol"]] = {
            "object_offset": symbol.value,
            "size": len(code),
            "instruction_count": len(instructions),
            "disassembly_sha256": json_sha256(instructions),
            "terminal_mnemonic": terminal["mnemonic"],
            "terminal_operand": terminal["operands"],
        }
        cursor += item["size"]
    if cursor != EXPECTED_TOTAL:
        raise ValueError(f"function extents total {cursor}; expected {EXPECTED_TOTAL}")
    return verifier, rows


def bind_manifest(verifier: Any, original: Path, object_path: Path) -> tuple[dict[str, Any], str]:
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    if manifest.get("original_sha256") != ORIGINAL_SHA256:
        raise ValueError("manifest original hash is not pinned to the immutable executable")
    rows = manifest.get("functions")
    if not isinstance(rows, list) or len(rows) != len(EXPECTED):
        raise ValueError("manifest function list does not have exactly three methods")
    for got, want in zip(rows, EXPECTED):
        for key in ("rva", "size", "symbol"):
            if got.get(key) != want[key]:
                raise ValueError(f"manifest {key} for {want['symbol']} differs from expected anchor")
        if got.get("evidence_id") != EVIDENCE_ID:
            raise ValueError(f"manifest evidence for {want['symbol']} differs from the pinned REA/Ghidra evidence")
        got["object"] = str(object_path.resolve())
    encoded = json.dumps(manifest, indent=2, sort_keys=True).encode("utf-8") + b"\n"
    with tempfile.TemporaryDirectory(prefix="s08-3-x86-bound-manifest-") as temporary:
        bound = Path(temporary) / "matches-bound.json"
        bound.write_bytes(encoded)
        result = verifier.verify(original, bound)
    return result, sha256(encoded)


def reassemble(source_path: Path) -> tuple[str | None, str | None]:
    with tempfile.TemporaryDirectory(prefix="s08-3-x86-reassembly-") as temporary:
        rebuilt = Path(temporary) / "reassembled.obj"
        try:
            run([str(GAS), "--32", "-o", str(rebuilt), str(source_path)])
        except subprocess.CalledProcessError as exc:
            detail = (exc.stderr or exc.stdout or str(exc)).strip().replace("\n", " ")
            return None, detail[:300]
        return sha256(rebuilt.read_bytes()), None


def audit(original: Path, object_path: Path, source_path: Path) -> dict[str, Any]:
    original = original.resolve()
    object_path = object_path.resolve()
    source_path = source_path.resolve()
    original_hash = sha256(original.read_bytes())
    if original_hash != ORIGINAL_SHA256:
        raise ValueError(f"original hash mismatch: {original_hash}")
    if not GAS.is_file():
        raise ValueError(f"pinned assembler is unavailable at {GAS}")
    assembler_version = run([str(GAS), "--version"]).stdout.splitlines()[0]
    assembler_hash = sha256(GAS.read_bytes())

    _verifier, candidate_rows = validate_object(object_path)
    verifier = load_module("s08_3_bound_verifier", PROJECT / "scripts/verify_matches.py")
    comparison, bound_manifest_hash = bind_manifest(verifier, original, object_path)
    functions = comparison.get("functions", [])
    sanitized_functions = [{
        "symbol": row.get("symbol"),
        "status": row.get("status"),
        "size": row.get("size"),
        "original_sha256": row.get("original_sha256"),
        "candidate_sha256": row.get("object_sha256"),
        "mismatch_offsets": [int(diff["offset"]) for diff in row.get("differences", [])],
        "mismatch_count": len(row.get("differences", [])),
        "contains_original_byte_values": False,
    } for row in functions]
    exact = bool(comparison.get("all_byte_ranges_exact"))

    object_hash = sha256(object_path.read_bytes())
    source_hash = sha256(source_path.read_bytes())
    fresh_hash, reassembly_error = reassemble(source_path)
    reproduces = fresh_hash == object_hash
    reviewed_source = source_hash == EXPECTED_SOURCE_SHA256
    canonical_path = object_path == (PROJECT / "build/matching_s08_3_x86.obj").resolve()
    reviewed = reviewed_source and reproduces and canonical_path
    if reviewed:
        classification = "explicit_reconstructed_assembly_source"
        status = "exact_match_from_reviewed_reconstructed_assembly_source" if exact else "reviewed_reconstructed_assembly_source_byte_mismatch"
    else:
        classification = "external_candidate_object"
        status = "external_candidate_exact_byte_match" if exact else "external_candidate_byte_mismatch"

    return {
        "slice": "S08-3-original-input-methods-x86",
        "status": status,
        "classification": classification,
        "original": {"path": display_path(original), "sha256": original_hash, "size": original.stat().st_size},
        "source": {"path": display_path(source_path), "sha256": source_hash, "canonical_reviewed_source_sha256": EXPECTED_SOURCE_SHA256, "matches_reviewed_source": reviewed_source},
        "source_object_association": {
            "status": "verified_reassembly_match" if reproduces else "source_reassembly_mismatch",
            "fresh_reassembled_object_sha256": fresh_hash,
            "supplied_object_sha256": object_hash,
            "reassembly_error": reassembly_error,
            "canonical_object_path": canonical_path,
            "historical_compiler_provenance_claim": False,
        },
        "assembler": {"version": assembler_version, "sha256": assembler_hash, "binutils_archive_sha512": BINUTILS_SHA512},
        "manifest_sha256": sha256(MANIFEST.read_bytes()),
        "comparison_binding": {"manifest_sha256": bound_manifest_hash, "object_path": display_path(object_path), "object_file_sha256": object_hash},
        "object": {"path": display_path(object_path), "sha256": object_hash, "size": object_path.stat().st_size},
        "candidate_functions": candidate_rows,
        "comparison": {
            "function_count": comparison.get("function_count", 0),
            "compared_bytes": sum(int(row.get("size", 0)) for row in functions if row.get("status") != "rejected"),
            "exact_byte_range_count": comparison.get("exact_byte_range_count", 0),
            "mismatch_count": comparison.get("mismatch_count", 0),
            "rejected_count": comparison.get("rejected_count", 0),
            "difference_count": comparison.get("difference_count", 0),
            "all_byte_ranges_exact": exact,
            "functions": sanitized_functions,
            "contains_original_byte_values": False,
        },
        "function_count": len(EXPECTED),
        "compared_bytes": EXPECTED_TOTAL,
        "compiler_generated_C_claim": False,
        "whole_executable_rebuilt": False,
        "unknowns": [
            "Original source-language declarations, field names, compiler version, and linker configuration remain unverified.",
            "Wrapper behavior and upstream coordinate/input transforms remain outside S08-3.",
            "Whole-file executable reconstruction and complete game behavior remain open.",
        ],
        "contains_original_byte_values": False,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", type=Path, default=WORK / "original/GAME.EXE")
    parser.add_argument("--object", type=Path, default=PROJECT / "build/matching_s08_3_x86.obj")
    parser.add_argument("--source", type=Path, default=SOURCE)
    parser.add_argument("--report", type=Path, default=PROJECT / "build/matching_s08_3_x86-report.json")
    args = parser.parse_args()
    try:
        report = audit(args.original, args.object, args.source)
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    except (OSError, ValueError, RuntimeError, KeyError, subprocess.CalledProcessError) as exc:
        detail = exc.stderr if isinstance(exc, subprocess.CalledProcessError) else str(exc)
        print(f"S08-3 x86 audit failed: {detail}", file=sys.stderr)
        return 1
    comparison = report["comparison"]
    print(
        "S08-3 assembly audit: "
        f"{report['function_count']} full functions / {report['compared_bytes']} bytes; "
        f"exact {comparison['exact_byte_range_count']}/3; "
        f"{comparison['difference_count']} differing offsets; "
        f"classification={report['classification']}; report excludes original byte values."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
