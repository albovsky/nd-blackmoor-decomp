#!/usr/bin/env python3
"""Audit the human-reconstructed six-function x86 assembly boundary."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any

PROJECT = Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
WORK = REPOSITORY / "work"
SOURCE = PROJECT / "src/matching_s08_2_x86.s"
MANIFEST = PROJECT / "matches_s08_2_x86.json"
GAS = WORK / "tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
BINUTILS_SHA512 = "20977ad17729141a2c26d358628f44a0944b84dcfefdec2ba029c2d02f40dfc41cc91c0631044560d2bd6f9a51e1f15846b4b311befbe14f1239f14ff7d57824"
EXPECTED = [
    {"rva": 0x0DAE66, "va": 0x4DAE66, "size": 17, "symbol": "_FUN_004dae66", "kind": "getter", "field_offset": 0x18},
    {"rva": 0x0DAE77, "va": 0x4DAE77, "size": 17, "symbol": "_FUN_004dae77", "kind": "getter", "field_offset": 0x1C},
    {"rva": 0x0DAEF1, "va": 0x4DAEF1, "size": 17, "symbol": "_FUN_004daef1", "kind": "getter", "field_offset": 0x0C},
    {"rva": 0x0DAF02, "va": 0x4DAF02, "size": 22, "symbol": "_FUN_004daf02", "kind": "setter", "field_offset": 0x0C},
    {"rva": 0x0DAF18, "va": 0x4DAF18, "size": 17, "symbol": "_FUN_004daf18", "kind": "getter", "field_offset": 0x10},
    {"rva": 0x0DAF29, "va": 0x4DAF29, "size": 22, "symbol": "_FUN_004daf29", "kind": "setter", "field_offset": 0x10},
]
EXPECTED_TOTAL = sum(item["size"] for item in EXPECTED)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def json_sha256(value: Any) -> str:
    encoded = json.dumps(value, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return sha256(encoded)


def run(command: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, check=True, capture_output=True, text=True)


def load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def parse_object_disassembly(object_path: Path) -> dict[str, list[dict[str, Any]]]:
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
            encoded = match.group(2).split()
            functions[current].append({
                "address": int(match.group(1), 16),
                "size": len(encoded),
                "mnemonic": match.group(3).lower(),
                "operands": match.group(4).strip(),
            })
    return functions


def validate_object(object_path: Path) -> tuple[Any, dict[str, dict[str, Any]]]:
    verifier = load_module("s08_2_x86_verifier", PROJECT / "scripts/verify_matches.py")
    obj = verifier._parse_coff_object(object_path.read_bytes())
    text_sections = [section for section in obj.sections if section.name == ".text"]
    if len(text_sections) != 1:
        raise ValueError(f"candidate must contain exactly one .text section, found {len(text_sections)}")
    text = text_sections[0]
    if text.raw_size != EXPECTED_TOTAL:
        raise ValueError(f"candidate .text has {text.raw_size} bytes; expected exactly {EXPECTED_TOTAL} (extra/alignment/truncation rejected)")
    if text.relocation_count:
        raise ValueError("candidate .text contains relocations")

    expected_names = [item["symbol"] for item in EXPECTED]
    definitions = [
        symbol for symbol in obj.symbols
        if 1 <= symbol.section_number <= len(obj.sections)
        and obj.sections[symbol.section_number - 1].name == ".text"
        and symbol.name != ".text"
    ]
    names = [symbol.name for symbol in definitions]
    if sorted(names) != sorted(expected_names):
        raise ValueError(f"candidate .text symbol set differs: expected {expected_names}, got {names}")

    disassembly = parse_object_disassembly(object_path)
    rows: dict[str, dict[str, Any]] = {}
    cursor = 0
    for item in EXPECTED:
        name = item["symbol"]
        matches = [symbol for symbol in definitions if symbol.name == name]
        if len(matches) != 1:
            raise ValueError(f"candidate symbol {name} is missing or ambiguous")
        symbol = matches[0]
        if symbol.value != cursor:
            raise ValueError(f"candidate symbol {name} starts at +0x{symbol.value:x}; expected contiguous +0x{cursor:x} (gap/alignment rejected)")
        size = item["size"]
        obj.symbol_bytes(name, size)
        instructions = disassembly.get(name, [])
        instruction_cursor = symbol.value
        for instruction in instructions:
            if instruction["address"] != instruction_cursor:
                raise ValueError(f"candidate disassembly gap in {name} at +0x{instruction_cursor:x}")
            instruction_cursor += instruction["size"]
        if not instructions or instruction_cursor != symbol.value + size:
            raise ValueError(f"candidate symbol {name} does not decode over its complete {size}-byte extent")
        terminal = instructions[-1]
        if terminal["mnemonic"] != "ret":
            raise ValueError(f"candidate symbol {name} has no terminal ret")
        cleanup = terminal["operands"]
        if item["kind"] == "getter" and cleanup:
            raise ValueError(f"candidate getter {name} has unexpected stack cleanup {cleanup!r}")
        if item["kind"] == "setter" and cleanup not in ("0x4", "4"):
            raise ValueError(f"candidate setter {name} must end in ret 4, found {cleanup!r}")
        rows[name] = {
            "object_offset": symbol.value,
            "size": size,
            "instruction_count": len(instructions),
            "disassembly_sha256": json_sha256(instructions),
            "terminal_mnemonic": terminal["mnemonic"],
            "terminal_operand": cleanup,
            "instructions": instructions,
        }
        cursor += size
    if cursor != EXPECTED_TOTAL:
        raise ValueError(f"candidate function sum is {cursor}, expected {EXPECTED_TOTAL}")
    return verifier, rows


def sanitize_comparison(raw: dict[str, Any]) -> dict[str, Any]:
    return {
        "function_count": raw.get("function_count", 0),
        "compared_bytes": sum(int(row.get("size", 0)) for row in raw.get("functions", []) if row.get("status") != "rejected"),
        "exact_byte_range_count": raw.get("exact_byte_range_count", 0),
        "mismatch_count": raw.get("mismatch_count", 0),
        "rejected_count": raw.get("rejected_count", 0),
        "difference_count": raw.get("difference_count", 0),
        "all_byte_ranges_exact": bool(raw.get("all_byte_ranges_exact")),
        "functions": [
            {
                "symbol": row.get("symbol"),
                "status": row.get("status"),
                "size": row.get("size"),
                "original_sha256": row.get("original_sha256"),
                "candidate_sha256": row.get("object_sha256"),
                "mismatch_offsets": [int(diff["offset"]) for diff in row.get("differences", [])],
                "mismatch_count": len(row.get("differences", [])),
                "contains_original_byte_values": False,
            }
            for row in raw.get("functions", [])
        ],
    }


def audit(original: Path, object_path: Path) -> dict[str, Any]:
    data = original.read_bytes()
    original_hash = sha256(data)
    if original_hash != ORIGINAL_SHA256:
        raise ValueError(f"original SHA-256 mismatch: {original_hash}")
    if not GAS.is_file():
        raise ValueError(f"pinned GNU assembler is missing: {GAS}; run bootstrap_matching_s08_2_gas.sh")
    version = run([str(GAS), "--version"]).stdout.splitlines()[0]
    assembler_hash = sha256(GAS.read_bytes())

    verifier, candidate_rows = validate_object(object_path)
    report = verifier.verify(original, MANIFEST)
    comparison = sanitize_comparison(report)

    range_module = load_module("s08_2_x86_range_audit", PROJECT / "scripts/audit_matching_s08_2.py")
    original_ranges, inventory = range_module.audit_ranges(
        data, PROJECT / "function-index.json", MANIFEST, original
    )
    original_disassembly = []
    for item in EXPECTED:
        row = next(row for row in original_ranges if row["rva"] == item["rva"])
        row["candidate_audit"] = candidate_rows[item["symbol"]]
        row["range_audit"]["disassembly_sha256"] = json_sha256(row["range_audit"]["instructions"])
        original_disassembly.append({
            "symbol": item["symbol"],
            "instructions": row["range_audit"]["instructions"],
        })
        cmp_row = next(row for row in comparison["functions"] if row["symbol"] == item["symbol"])
        row["byte_comparison"] = cmp_row

    exact = comparison["all_byte_ranges_exact"]
    return {
        "slice": "S08-2-x86-assembly-lowering",
        "classification": "human_reconstructed_x86_assembly_lowering",
        "status": "exact_six_function_match" if exact else "assembly_source_valid_but_byte_mismatch",
        "compiler_generated_C_claim": False,
        "whole_executable_rebuilt": False,
        "original": {"sha256": original_hash, "size": len(data), "path": "work/original/GAME.EXE"},
        "range_inventory": inventory,
        "assembler": {
            "version": version,
            "binary_sha256": assembler_hash,
            "source_release": "GNU Binutils 2.43.1 official sourceware release",
            "source_archive_url": "https://sourceware.org/pub/binutils/releases/binutils-2.43.1.tar.xz",
            "source_archive_sha512": BINUTILS_SHA512,
            "source_archive": "work/tools/s08-binutils-2.43.1/binutils-2.43.1.tar.xz",
            "configured_prefix": "work/tools/s08-binutils-2.43.1/prefix",
            "configure": [
                "--target=i686-w64-mingw32", "--disable-nls", "--disable-werror",
                "--disable-gdb", "--disable-gprof", "--disable-gold", "--disable-ld",
                "--disable-sim", "--disable-libdecnumber", "--disable-readline",
                "--enable-deterministic-archives", "--with-system-zlib",
            ],
            "build_targets": ["make -j2 MAKEINFO=true all-gas", "make MAKEINFO=true install-gas"],
            "assembler_command": [str(GAS), "--32", "-o", str(object_path), str(SOURCE)],
            "pseudo_prefixes": "GNU as {load} source spellings select original MOV load-form register encodings",
        },
        "disassembler": {
            "version": run(["xcrun", "llvm-objdump", "--version"]).stdout.splitlines()[0],
            "candidate_disassembly_sha256": json_sha256([
                {"symbol": item["symbol"], "instructions": candidate_rows[item["symbol"]]["instructions"]}
                for item in EXPECTED
            ]),
            "original_disassembly_sha256": json_sha256(original_disassembly),
            "summary_format": "addresses, sizes, mnemonics, and operands only; no instruction byte values",
        },
        "source": {"path": "outputs/blackmoor-decomp/src/matching_s08_2_x86.s", "sha256": sha256(SOURCE.read_bytes())},
        "manifest": {"path": "outputs/blackmoor-decomp/matches_s08_2_x86.json", "sha256": sha256(MANIFEST.read_bytes())},
        "build_scripts": {
            "assembly_sha256": sha256((PROJECT / "scripts/build_matching_s08_2_x86.sh").read_bytes()),
            "assembler_bootstrap_sha256": sha256((PROJECT / "scripts/bootstrap_matching_s08_2_gas.sh").read_bytes()),
            "audit_sha256": sha256(Path(__file__).read_bytes()),
        },
        "object": {"path": "outputs/blackmoor-decomp/build/matching_s08_2_x86.obj", "sha256": sha256(object_path.read_bytes()), "size": object_path.stat().st_size},
        "comparison": comparison,
        "function_count": len(EXPECTED),
        "compared_bytes": EXPECTED_TOTAL,
        "functions": original_ranges,
        "semantic_C_and_CPP": {
            "C_source": "outputs/blackmoor-decomp/src/matching_s08.c",
            "C_plus_plus_source": "outputs/blackmoor-decomp/src/matching_s08_2.cpp",
            "compiler_matrix_evidence": "work/analysis/slices/S08-2-report.json",
            "C_O0_exact_ranges": 0,
            "C_O0_difference_count": 62,
            "C_plus_plus_O0_exact_ranges": 0,
            "C_plus_plus_O0_difference_count": 66,
            "semantic_evidence_remains_separate": True,
        },
        "unknowns": [
            "Original source files, source field names, class declarations, and compiler version remain unverified.",
            "Original linker configuration, CRT/import/thunk boundaries, globals, and whole-PE reconstruction remain unverified.",
            "The earlier 14-byte initial_functions ranges remain range-only and completeness-unproven; they are outside this slice.",
        ],
        "next_blocker": None if exact else "Available local LLVM and Apple cctools assemblers canonicalize MOV register forms; the pinned GNU as {load} form is being tested for exact encoding. Any remaining differences are reported per complete function.",
        "contains_original_byte_values": False,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", type=Path, default=WORK / "original/GAME.EXE")
    parser.add_argument("--object", type=Path, default=PROJECT / "build/matching_s08_2_x86.obj")
    parser.add_argument("--report", type=Path, default=WORK / "analysis/slices/S08-2-x86-report.json")
    args = parser.parse_args()
    try:
        result = audit(args.original.resolve(), args.object.resolve())
        args.report.resolve().parent.mkdir(parents=True, exist_ok=True)
        args.report.resolve().write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    except (OSError, ValueError, RuntimeError, KeyError, subprocess.CalledProcessError) as exc:
        detail = exc.stderr if isinstance(exc, subprocess.CalledProcessError) else str(exc)
        print(f"S08-2 x86 audit failed: {detail}", file=sys.stderr)
        return 1
    comparison = result["comparison"]
    print(
        "S08-2 assembly audit: "
        f"{result['function_count']} full functions / {result['compared_bytes']} bytes; "
        f"exact {comparison['exact_byte_range_count']}/6; "
        f"{comparison['difference_count']} differing offsets; "
        "range/terminal-ret/ABI extents validated; report has no byte values."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
