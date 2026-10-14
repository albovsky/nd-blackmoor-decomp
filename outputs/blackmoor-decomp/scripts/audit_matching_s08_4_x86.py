#!/usr/bin/env python3
"""Fail-closed audit of S08-4 complete extents and source/object association."""
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
SOURCE = PROJECT / "src/matching_s08_4_x86.s"
MANIFEST = PROJECT / "matches_s08_4_x86.json"
FUNCTION_INDEX = PROJECT / "function-index.json"
GAS = WORK / "tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
EXPECTED_SOURCE_SHA256 = "34db631d30eb9d2f1a5c5d5fa3154988cd922712515c76641e1af7f69bbc9238"
EXPECTED_MANIFEST_SHA256 = "9d6fe21088d8bc10b9bba34fb7c561fa5fe2d14617e3bda07a166e6b82984ccd"
EXPECTED_FUNCTION_INDEX_SHA256 = "3fc0c2eea03dd93f25d8b6b66f9eaa9a9fbb652839ec7d7584a7a6a37b94aa9d"
EXPECTED_ASSEMBLER_SHA256 = "459ab053b16d25841cf302ece6f5ddd65ebd0f33a91fbbb6c6a665b74de0565b"
BINUTILS_ARCHIVE_SHA512 = "20977ad17729141a2c26d358628f44a0944b84dcfefdec2ba029c2d02f40dfc41cc91c0631044560d2bd6f9a51e1f15846b4b311befbe14f1239f14ff7d57824"
EVIDENCE_ID = "ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619"
EXPECTED = [
    {"name": "field0", "rva": 0x0DAF3F, "va": 0x4DAF3F, "size": 47, "symbol": "_FUN_004daf3f"},
    {"name": "field4", "rva": 0x0DAF6E, "va": 0x4DAF6E, "size": 49, "symbol": "_FUN_004daf6e"},
]
EXPECTED_TOTAL = sum(item["size"] for item in EXPECTED)
PRIOR_S08_3_RANGES = ((0x4DAF9F, 0x4DAFC3), (0x4DAFC3, 0x4DB000), (0x4DB000, 0x4DB04F))


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
        raise RuntimeError(f"cannot import verifier at {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def parse_disassembly(object_path: Path) -> dict[str, list[dict[str, Any]]]:
    result = run(["xcrun", "llvm-objdump", "-d", "--x86-asm-syntax=intel", str(object_path)])
    functions: dict[str, list[dict[str, Any]]] = {}
    current: str | None = None
    label = re.compile(r"^\s*[0-9a-fA-F]+ <([^>]+)>:\s*$")
    instruction = re.compile(
        r"^\s*([0-9a-fA-F]+):\s*((?:[0-9a-fA-F]{2}\s+)+)([A-Za-z][A-Za-z0-9.]*)\s*(.*?)\s*$"
    )
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


def validate_function_index() -> dict[str, Any]:
    data = FUNCTION_INDEX.read_bytes()
    actual_hash = sha256(data)
    if actual_hash != EXPECTED_FUNCTION_INDEX_SHA256:
        raise ValueError(f"function index digest changed: {actual_hash}")
    index = json.loads(data)
    if index.get("original_sha256") != ORIGINAL_SHA256:
        raise ValueError("function index is not pinned to the immutable original executable")
    rows = index.get("functions")
    if not isinstance(rows, list):
        raise ValueError("function index has no function rows")
    entries: dict[int, list[dict[str, Any]]] = {}
    for row in rows:
        try:
            address = int(row["address"], 16)
        except (KeyError, TypeError, ValueError):
            continue
        entries.setdefault(address, []).append(row)
    starts = sorted(entries)
    checks: list[dict[str, Any]] = []
    for item in EXPECTED:
        matches = entries.get(item["va"], [])
        if len(matches) != 1:
            raise ValueError(f"function index entry for {item['symbol']} is absent or ambiguous")
        row = matches[0]
        if row.get("evidence_id") != EVIDENCE_ID:
            raise ValueError(f"function index evidence for {item['symbol']} changed")
        if row.get("name") != f"FUN_{item['va']:08x}":
            raise ValueError(f"function index name for {item['symbol']} changed")
        next_starts = [address for address in starts if address > item["va"]]
        next_start = next_starts[0] if next_starts else None
        if next_start != item["va"] + item["size"]:
            raise ValueError(
                f"indexed boundary for {item['symbol']} ends at {next_start!r}, "
                f"expected 0x{item['va'] + item['size']:x}"
            )
        checks.append({
            "name": item["name"],
            "va": f"0x{item['va']:08x}",
            "rva": f"0x{item['rva']:x}",
            "size": item["size"],
            "indexed_entry": row["address"],
            "next_indexed_entry": f"0x{next_start:08x}",
            "evidence_id": EVIDENCE_ID,
        })
    return {
        "path": display_path(FUNCTION_INDEX),
        "sha256": actual_hash,
        "original_sha256": index["original_sha256"],
        "evidence_id": EVIDENCE_ID,
        "indexed_adjacent_extents_valid": True,
        "functions": checks,
    }


def validate_object(object_path: Path) -> tuple[Any, dict[str, dict[str, Any]]]:
    verifier = load_module("s08_4_object_verifier", PROJECT / "scripts/verify_matches.py")
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
        if terminal["mnemonic"] != "ret" or terminal["operands"]:
            raise ValueError(f"candidate {item['symbol']} must end in plain ret; found {terminal}")
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


def bind_manifest(
    verifier: Any,
    original: Path,
    object_path: Path,
    manifest_path: Path,
) -> tuple[dict[str, Any], str, dict[str, Any]]:
    raw = manifest_path.read_bytes()
    digest = sha256(raw)
    manifest = json.loads(raw)
    if not isinstance(manifest, dict) or manifest.get("original_sha256") != ORIGINAL_SHA256:
        raise ValueError("manifest is not pinned to the immutable original executable")
    rows = manifest.get("functions")
    if not isinstance(rows, list) or len(rows) != len(EXPECTED):
        raise ValueError("manifest must contain exactly the two complete S08-4 functions")
    for got, want in zip(rows, EXPECTED):
        for key, expected in (("rva", want["rva"]), ("va", want["va"]),
                              ("size", want["size"]), ("symbol", want["symbol"])):
            if got.get(key) != expected:
                raise ValueError(f"manifest {key} for {want['symbol']} differs from the pinned extent")
        if got.get("evidence_id") != EVIDENCE_ID:
            raise ValueError(f"manifest evidence for {want['symbol']} differs from retained Ghidra evidence")
        if got.get("object") != "build/matching_s08_4_x86.obj":
            raise ValueError(f"manifest object path for {want['symbol']} is not the canonical build object")
        got["object"] = str(object_path.resolve())
    encoded = json.dumps(manifest, indent=2, sort_keys=True).encode("utf-8") + b"\n"
    with tempfile.TemporaryDirectory(prefix="s08-4-x86-bound-manifest-") as temporary:
        bound = Path(temporary) / "matches-bound.json"
        bound.write_bytes(encoded)
        comparison = verifier.verify(original, bound)
    binding = {
        "path": display_path(manifest_path),
        "sha256": digest,
        "reviewed_manifest_sha256": EXPECTED_MANIFEST_SHA256,
        "matches_reviewed_manifest": manifest_path.resolve() == MANIFEST.resolve() and digest == EXPECTED_MANIFEST_SHA256,
    }
    return comparison, sha256(encoded), binding


def reassemble(source_path: Path) -> tuple[str | None, str | None]:
    with tempfile.TemporaryDirectory(prefix="s08-4-x86-reassembly-") as temporary:
        rebuilt = Path(temporary) / "reassembled.obj"
        try:
            run([str(GAS), "--32", "-o", str(rebuilt), str(source_path)])
        except subprocess.CalledProcessError as exc:
            detail = (exc.stderr or exc.stdout or str(exc)).strip().replace("\n", " ")
            return None, detail[:300]
        return sha256(rebuilt.read_bytes()), None


def compiler_probe(original: Path) -> dict[str, Any]:
    """Compare modern Clang thiscall bodies separately from assembly matching."""
    source_text = """typedef unsigned int u32;
typedef struct InputObject { u32 f00, f04, f08, f0c, f10; } InputObject;
__attribute__((thiscall, noinline)) u32 FUN_004daf3f(InputObject *self) {
    u32 value = self->f00;
    if (value != 0) { self->f00 = 0; self->f0c = 0; }
    return value != 0;
}
__attribute__((thiscall, noinline)) u32 FUN_004daf6e(InputObject *self) {
    u32 value = self->f04;
    if (value != 0) { self->f04 = 0; self->f10 = 0; }
    return value != 0;
}
"""
    variants: list[dict[str, Any]] = []
    try:
        compiler = run(["xcrun", "clang", "--version"]).stdout.splitlines()[0]
        verifier = load_module("s08_4_compiler_probe_verifier", PROJECT / "scripts/verify_matches.py")
        pe = verifier._parse_pe(original.read_bytes())
        with tempfile.TemporaryDirectory(prefix="s08-4-thiscall-probe-") as directory:
            temp = Path(directory)
            source = temp / "input_consume_probe.c"
            source.write_text(source_text, encoding="utf-8")
            for optimization in ("O0", "O1", "O2", "Os", "Oz"):
                object_path = temp / f"{optimization}.obj"
                command = [
                    "xcrun", "clang", "-target", "i686-pc-windows-msvc", "-std=c11",
                    f"-{optimization}", "-fno-omit-frame-pointer", "-fno-stack-protector",
                    "-fno-builtin", "-c", str(source), "-o", str(object_path),
                ]
                run(command)
                obj = verifier._parse_coff_object(object_path.read_bytes())
                text_sections = [section for section in obj.sections if section.name == ".text"]
                if len(text_sections) != 1:
                    raise ValueError(f"{optimization}: expected one compiler .text section")
                section = text_sections[0]
                disassembly = parse_disassembly(object_path)
                function_rows = []
                for item in EXPECTED:
                    symbols = [s for s in obj.symbols if s.name == item["symbol"]]
                    if len(symbols) != 1:
                        raise ValueError(f"{optimization}: symbol {item['symbol']} missing or ambiguous")
                    symbol = symbols[0]
                    code_rows = disassembly.get(item["symbol"], [])
                    returns = [r for r in code_rows if r["mnemonic"] == "ret"]
                    if not returns:
                        raise ValueError(f"{optimization}: no terminal ret in {item['symbol']}")
                    end = returns[-1]["address"] + returns[-1]["size"]
                    candidate_size = end - symbol.value
                    if candidate_size <= 0 or symbol.value + candidate_size > section.raw_size:
                        raise ValueError(f"{optimization}: invalid body extent for {item['symbol']}")
                    candidate = obj.data[section.raw_pointer + symbol.value:section.raw_pointer + end]
                    original_bytes, _raw_offset, _pe_section = pe.rva_bytes(item["rva"], item["size"])
                    differences = [
                        offset for offset in range(max(len(candidate), len(original_bytes)))
                        if offset >= len(candidate) or offset >= len(original_bytes)
                        or candidate[offset] != original_bytes[offset]
                    ]
                    function_rows.append({
                        "method": item["name"],
                        "original_size": item["size"],
                        "candidate_body_size": candidate_size,
                        "candidate_body_sha256": sha256(candidate),
                        "byte_mismatch_count": len(differences),
                        "mismatch_offsets": differences[:24],
                        "exact": candidate == original_bytes,
                        "contains_original_byte_values": False,
                    })
                variants.append({
                    "optimization": optimization,
                    "flags": ["-target i686-pc-windows-msvc", "-std=c11", "-fno-omit-frame-pointer", "-fno-stack-protector", "-fno-builtin"],
                    "object_sha256": sha256(object_path.read_bytes()),
                    "text_size": section.raw_size,
                    "text_relocations": section.relocation_count,
                    "functions": function_rows,
                    "all_exact": all(row["exact"] for row in function_rows),
                })
    except (OSError, ValueError, RuntimeError, subprocess.CalledProcessError) as exc:
        return {
            "status": "compiler_probe_unavailable",
            "error": str(exc),
            "claims_exact_match": False,
            "contains_original_byte_values": False,
        }
    return {
        "status": "completed",
        "compiler": compiler,
        "target": "i686-pc-windows-msvc",
        "source_sha256": sha256(source_text.encode("utf-8")),
        "claims_exact_match": False,
        "variants": variants,
        "contains_original_byte_values": False,
    }


def audit(
    original: Path,
    object_path: Path,
    source_path: Path,
    manifest_path: Path = MANIFEST,
    include_compiler_probe: bool = True,
) -> dict[str, Any]:
    original = original.resolve()
    object_path = object_path.resolve()
    source_path = source_path.resolve()
    manifest_path = manifest_path.resolve()
    original_hash = sha256(original.read_bytes())
    if original_hash != ORIGINAL_SHA256:
        raise ValueError(f"original hash mismatch: {original_hash}")
    if not GAS.is_file():
        raise ValueError(f"pinned assembler is unavailable at {GAS}")

    index_report = validate_function_index()
    assembler_hash = sha256(GAS.read_bytes())
    reviewed_assembler = assembler_hash == EXPECTED_ASSEMBLER_SHA256
    _verifier, candidate_rows = validate_object(object_path)
    verifier = load_module("s08_4_bound_verifier", PROJECT / "scripts/verify_matches.py")
    comparison, bound_manifest_hash, manifest_report = bind_manifest(
        verifier, original, object_path, manifest_path
    )
    functions = comparison.get("functions", [])
    sanitized_functions = [{
        "symbol": row.get("symbol"),
        "rva": row.get("rva"),
        "status": row.get("status"),
        "size": row.get("size"),
        "original_sha256": row.get("original_sha256"),
        "candidate_sha256": row.get("object_sha256"),
        "mismatch_offsets": [int(diff["offset"]) for diff in row.get("differences", [])],
        "mismatch_count": len(row.get("differences", [])),
        "contains_original_byte_values": False,
    } for row in functions]
    exact = (
        bool(comparison.get("all_byte_ranges_exact"))
        and comparison.get("exact_byte_range_count") == len(EXPECTED)
        and comparison.get("exact_byte_range_bytes") == EXPECTED_TOTAL
        and comparison.get("rejected_count") == 0
    )

    object_hash = sha256(object_path.read_bytes())
    source_hash = sha256(source_path.read_bytes())
    fresh_hash, reassembly_error = reassemble(source_path)
    reproduces = fresh_hash == object_hash
    canonical_object = object_path == (PROJECT / "build/matching_s08_4_x86.obj").resolve()
    canonical_source = source_path == SOURCE.resolve()
    reviewed_source = source_hash == EXPECTED_SOURCE_SHA256 and canonical_source
    reviewed = (
        exact and reviewed_source and reproduces and canonical_object
        and manifest_report["matches_reviewed_manifest"]
        and reviewed_assembler
        and index_report["indexed_adjacent_extents_valid"]
    )
    if reviewed:
        classification = "explicit_reconstructed_assembly_source"
        status = "exact_match_from_reviewed_reconstructed_assembly_source"
    elif exact:
        classification = "external_candidate_object"
        status = "external_candidate_exact_byte_match"
    else:
        classification = "external_candidate_object"
        status = "external_candidate_byte_mismatch"

    code_windows = [{
        "name": row.get("symbol"),
        "rva": f"0x{int(row['rva']):x}",
        "size": int(row["size"]),
        "original_sha256": row.get("original_sha256"),
        "candidate_sha256": row.get("candidate_sha256"),
    } for row in sanitized_functions]
    prior_disjoint = all(
        item["va"] + item["size"] <= prior_start or item["va"] >= prior_end
        for item in EXPECTED for prior_start, prior_end in PRIOR_S08_3_RANGES
    )
    if not prior_disjoint:
        raise ValueError("S08-4 selected extents overlap the accepted S08-3 byte ranges")

    return {
        "slice": "S08-4-original-input-consumers-x86",
        "status": status,
        "classification": classification,
        "original": {"path": display_path(original), "sha256": original_hash, "size": original.stat().st_size},
        "function_index": index_report,
        "retained_ghidra_evidence": {
            "provider": "Ghidra 12.1.4 via REA 6.4.0 (retained dossier)",
            "evidence_id": EVIDENCE_ID,
            "fresh_analysis_claim": False,
            "pseudocode_classification": "corroborating analysis only; assembly and return behavior are confirmed from immutable-byte disassembly",
        },
        "source": {
            "path": display_path(source_path),
            "sha256": source_hash,
            "reviewed_source_sha256": EXPECTED_SOURCE_SHA256,
            "canonical_source_path": canonical_source,
            "matches_reviewed_source": reviewed_source,
        },
        "source_object_association": {
            "status": "verified_reassembly_match" if reproduces else "source_reassembly_mismatch",
            "fresh_reassembled_object_sha256": fresh_hash,
            "supplied_object_sha256": object_hash,
            "reassembly_error": reassembly_error,
            "canonical_object_path": canonical_object,
            "historical_compiler_provenance_claim": False,
        },
        "assembler": {
            "version": run([str(GAS), "--version"]).stdout.splitlines()[0],
            "sha256": assembler_hash,
            "reviewed_assembler_sha256": EXPECTED_ASSEMBLER_SHA256,
            "matches_reviewed_assembler": reviewed_assembler,
            "binutils_archive_sha512": BINUTILS_ARCHIVE_SHA512,
        },
        "manifest": manifest_report,
        "comparison_binding": {
            "manifest_sha256": bound_manifest_hash,
            "object_path": display_path(object_path),
            "object_file_sha256": object_hash,
        },
        "object": {"path": display_path(object_path), "sha256": object_hash, "size": object_path.stat().st_size},
        "candidate_functions": candidate_rows,
        "comparison": {
            "function_count": comparison.get("function_count", 0),
            "compared_bytes": comparison.get("exact_byte_range_bytes", 0) + comparison.get("mismatch_bytes", 0),
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
        "unique_exact_bytes": EXPECTED_TOTAL if exact else 0,
        "complete_extent_basis": "indexed starts are adjacent at both exclusive ends; candidate decodes to terminal ret; PE ranges are bounds/relocation checked",
        "previous_s08_3_ranges_disjoint": prior_disjoint,
        "compiler_generated_C_claim": False,
        "compiler_probe": (
            compiler_probe(original) if include_compiler_probe else {
                "status": "skipped_for_focused_audit",
                "claims_exact_match": False,
                "contains_original_byte_values": False,
            }
        ),
        "whole_executable_rebuilt": False,
        "unverified_branches": [
            "Upstream wrappers and frame-level native dispatch remain Boot's integration boundary.",
            "Original source declarations, field names, compiler version, and linker configuration remain unverified.",
            "Whole-file executable reconstruction and complete native gameplay remain open.",
        ],
        "contains_original_byte_values": False,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", type=Path, default=WORK / "original/GAME.EXE")
    parser.add_argument("--object", type=Path, default=PROJECT / "build/matching_s08_4_x86.obj")
    parser.add_argument("--source", type=Path, default=SOURCE)
    parser.add_argument("--manifest", type=Path, default=MANIFEST)
    parser.add_argument("--report", type=Path, default=PROJECT / "build/matching_s08_4_x86-report.json")
    args = parser.parse_args()
    try:
        report = audit(args.original, args.object, args.source, args.manifest)
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    except (OSError, ValueError, RuntimeError, KeyError, subprocess.CalledProcessError) as exc:
        detail = exc.stderr if isinstance(exc, subprocess.CalledProcessError) else str(exc)
        print(f"S08-4 x86 audit failed: {detail}", file=sys.stderr)
        return 1
    comparison = report["comparison"]
    print(
        "S08-4 assembly audit: "
        f"{report['function_count']} complete functions / {report['compared_bytes']} bytes; "
        f"exact {comparison['exact_byte_range_count']}/2; "
        f"{comparison['difference_count']} differing offsets; "
        f"classification={report['classification']}; report excludes original byte values."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
