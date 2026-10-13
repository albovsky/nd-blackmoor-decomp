#!/usr/bin/env python3
"""Audit candidate boundaries and emit a byte-value-free S08 report."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import struct
import subprocess
import sys
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
WORK = REPOSITORY / "work"
INDEX_PATH = PROJECT / "function-index.json"
MANIFEST_PATH = PROJECT / "matches_s08.json"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
EVIDENCE_ID = "ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619"


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def disassemble(original: Path, start: int, end: int) -> list[dict[str, object]]:
    result = subprocess.run(
        [
            "xcrun", "llvm-objdump", "-d", "--x86-asm-syntax=intel",
            f"--start-address=0x{start:x}", f"--stop-address=0x{end:x}", str(original),
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    instructions: list[dict[str, object]] = []
    for line in result.stdout.splitlines():
        if ":" not in line:
            continue
        address_text, rest = line.split(":", 1)
        address_text = address_text.strip()
        if not re.fullmatch(r"[0-9a-fA-F]+", address_text):
            continue
        parts = rest.strip().split()
        raw: list[str] = []
        while parts and re.fullmatch(r"[0-9a-fA-F]{2}", parts[0]):
            raw.append(parts.pop(0))
        if not raw or not parts:
            continue
        instructions.append(
            {
                "address": int(address_text, 16),
                "size": len(raw),
                "mnemonic": parts[0].lower(),
                "operand_text": " ".join(parts[1:]),
            }
        )
    return instructions


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def audit(original: Path, verifier_path: Path) -> dict[str, object]:
    original_data = original.read_bytes()
    actual_sha = sha256(original_data)
    if actual_sha != ORIGINAL_SHA256:
        raise ValueError(f"original executable hash mismatch: {actual_sha}")
    verifier = json.loads(verifier_path.read_text(encoding="utf-8"))
    if verifier.get("original_sha256") != ORIGINAL_SHA256:
        raise ValueError("byte verifier report does not name the pinned original")

    index_bytes = INDEX_PATH.read_bytes()
    index = json.loads(index_bytes)
    if index.get("original_sha256") != ORIGINAL_SHA256:
        raise ValueError("Ghidra function index is for a different executable")
    indexed = index.get("functions")
    if not isinstance(indexed, list) or len(indexed) != 4188 or index.get("failures"):
        raise ValueError("Ghidra function inventory count/failures changed")
    indexed_by_va = {int(item["address"], 16): item for item in indexed}
    starts = sorted(indexed_by_va)
    if len(indexed_by_va) != len(indexed):
        raise ValueError("Ghidra function index contains duplicate starts")

    pe_offset = struct.unpack_from("<I", original_data, 0x3C)[0]
    optional_offset = pe_offset + 4 + 20
    image_base = struct.unpack_from("<I", original_data, optional_offset + 28)[0]
    if image_base != 0x400000:
        raise ValueError(f"unexpected PE32 image base 0x{image_base:x}")

    sys.path.insert(0, str(PROJECT / "scripts"))
    import verify_matches  # type: ignore[import-not-found]

    pe = verify_matches._parse_pe(original_data)
    text_section = next(section for section in pe.sections if section.name == ".text")
    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    verifier_functions = {item["rva"]: item for item in verifier.get("functions", [])}
    report_functions: list[dict[str, object]] = []
    for item in manifest["functions"]:
        rva = int(item["rva"])
        va = image_base + rva
        size = int(item["size"])
        symbol = item["symbol"]
        index_item = indexed_by_va.get(va)
        if index_item is None:
            raise ValueError(f"candidate 0x{va:x} is absent from the Ghidra function index")
        index_position = starts.index(va)
        next_va = starts[index_position + 1] if index_position + 1 < len(starts) else None
        if next_va != va + size:
            raise ValueError(
                f"candidate {symbol} size {size} does not end at next Ghidra function start"
            )
        instructions = disassemble(original, va, va + size)
        decoded_size = sum(int(insn["size"]) for insn in instructions)
        cursor = va
        contiguous = bool(instructions)
        for instruction in instructions:
            if int(instruction["address"]) != cursor:
                contiguous = False
                break
            cursor += int(instruction["size"])
        first_ok = bool(instructions) and int(instructions[0]["address"]) == va
        terminal = instructions[-1] if instructions else None
        terminal_ret = bool(
            terminal
            and int(terminal["address"]) + int(terminal["size"]) == va + size
            and str(terminal["mnemonic"]).startswith("ret")
        )
        if not first_ok or not contiguous or cursor != va + size or decoded_size != size or not terminal_ret:
            raise ValueError(
                f"candidate {symbol} does not disassemble completely to a terminal ret"
            )
        comparison = verifier_functions.get(rva)
        if comparison is None or comparison.get("symbol") != symbol:
            raise ValueError(f"byte verifier omitted {symbol}")
        differences = comparison.get("differences", [])
        mismatch_offsets = [int(diff["offset"]) for diff in differences]
        if any("expected" in diff or "actual" in diff for diff in differences):
            # Raw byte values are not retained in the published/private S08 report.
            pass
        report_functions.append(
            {
                "va": va,
                "rva": rva,
                "end_va": va + size,
                "size": size,
                "symbol": symbol,
                "source_file": "outputs/blackmoor-decomp/src/matching_s08.c",
                "evidence_id": item.get("evidence_id"),
                "observed_behavior": item.get("observed_behavior"),
                "range_audit": {
                    "basis": "Ghidra function start and next indexed function start, corroborated by full linear disassembly ending in ret",
                    "next_indexed_start_va": next_va,
                    "decoded_size": decoded_size,
                    "instruction_count": len(instructions),
                    "first_instruction": instructions[0]["mnemonic"],
                    "terminal_instruction": terminal["mnemonic"] + (" " + str(terminal["operand_text"]) if terminal["operand_text"] else ""),
                    "call_count": sum(str(insn["mnemonic"]).startswith("call") for insn in instructions),
                    "branch_count": sum(str(insn["mnemonic"]).startswith(("j", "loop")) for insn in instructions),
                    "complete_to_terminal_ret": True,
                    "evidence_id": index_item["evidence_id"],
                },
                "match_status": comparison["status"],
                "exact_byte_range": bool(comparison["exact_byte_range"]),
                "original_sha256": comparison.get("original_sha256"),
                "object_sha256": comparison.get("object_sha256"),
                "mismatch_count": len(mismatch_offsets),
                "mismatch_offsets": mismatch_offsets,
                "contains_original_byte_values": False,
            }
        )

    starts_digest = sha256("\n".join(f"0x{value:08x}" for value in starts).encode())
    inventory_document = {
        "inventory_kind": "Ghidra function starts from the pinned REA export; not exact extents",
        "provider": "Ghidra 12.1.4 via REA 6.4.0",
        "original_sha256": ORIGINAL_SHA256,
        "source": "outputs/blackmoor-decomp/function-index.json",
        "source_sha256": sha256(index_bytes),
        "indexed_function_count": len(indexed),
        "index_failures": len(index.get("failures", [])),
        "start_address_sha256": starts_digest,
        "starts": [
            {
                "va": item["address"],
                "name": item["name"],
                "pseudocode_file": "outputs/blackmoor-decomp/" + item["file"],
                "evidence_id": item["evidence_id"],
            }
            for item in sorted(indexed, key=lambda entry: int(entry["address"], 16))
        ],
        "extent_note": "The index provides function starts, not end addresses. Only the six audited functions below have complete sizes proven by adjacent indexed starts plus full disassembly through a terminal return. Other treemap spans must be labelled estimates.",
    }
    write_json(WORK / "analysis" / "slices" / "S08-function-inventory.json", inventory_document)

    compiler = subprocess.run(
        ["xcrun", "clang", "--version"], check=True, capture_output=True, text=True
    ).stdout.splitlines()[0]
    exact_count = sum(bool(item["exact_byte_range"]) for item in report_functions)
    mismatch_count = sum(item["match_status"] == "byte-range-mismatch" for item in report_functions)
    rejected_count = sum(item["match_status"] == "rejected" for item in report_functions)
    difference_count = sum(int(item["mismatch_count"]) for item in report_functions)
    return {
        "slice": "S08-x86-matching-build",
        "status": "comparison_complete",
        "whole_executable_rebuilt": False,
        "original": {"sha256": ORIGINAL_SHA256, "size": len(original_data), "path": "work/original/GAME.EXE"},
        "function_inventory": {
            "source": "outputs/blackmoor-decomp/function-index.json",
            "source_sha256": sha256(index_bytes),
            "provider": "Ghidra 12.1.4 via REA 6.4.0",
            "indexed_functions": len(indexed),
            "index_failures": len(index.get("failures", [])),
            "start_address_sha256": starts_digest,
            "function_extent_coverage": "starts-only except for individually audited candidates",
        },
        "toolchain": {
            "compiler": compiler,
            "flags": ["-target", "i686-pc-windows-msvc", "-std=c11", "-O0", "-fno-omit-frame-pointer", "-fno-stack-protector", "-fno-builtin"],
            "optimization": "-O0",
            "object_architecture": "i386 COFF",
            "vc6_equivalence": "not established; no VC6 compiler available",
        },
        "text_section": {
            "virtual_address": text_section.virtual_address,
            "raw_pointer": text_section.raw_pointer,
            "raw_size": text_section.raw_size,
            "virtual_size": text_section.virtual_size,
        },
        "comparison": {
            "source": "outputs/blackmoor-decomp/src/matching_s08.c",
            "object": "outputs/blackmoor-decomp/build/matching_s08.obj",
            "match_scope": "six individually audited complete function byte ranges",
            "function_completeness": "verified for the six ranges below; unverified globally",
            "function_count": len(report_functions),
            "exact_byte_range_count": exact_count,
            "mismatch_count": mismatch_count,
            "rejected_count": rejected_count,
            "difference_count": difference_count,
            "difference_location_count": difference_count,
            "status": "exact" if exact_count == len(report_functions) else "toolchain_mismatch_reported",
            "raw_expected_actual_byte_values_retained": False,
        },
        "functions": report_functions,
        "limitations": [
            "The six functions are source-reconstructed from Ghidra pseudocode, then independently compared as complete instruction ranges.",
            "Clang 21 does not emit the observed Microsoft prologue/epilogue/register allocation for this group; the six-function byte-range mismatch report is not a claim of exact function matches.",
            "Function-start inventory is not an exact 4188-function extent inventory; only the individually audited candidate ranges have complete extents established here.",
            "CRT/import/thunk classification, linker layout, PE sections and whole-executable reconstruction remain out of scope and unverified.",
        ],
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("original", type=Path)
    parser.add_argument("verifier_report", type=Path)
    args = parser.parse_args()
    report = audit(args.original, args.verifier_report)
    out = WORK / "analysis" / "slices" / "S08-matching-report.json"
    write_json(out, report)
    print(
        "comparison complete: "
        f"{report['comparison']['function_count']} candidates, "
        f"{report['comparison']['exact_byte_range_count']} exact, "
        f"{report['comparison']['mismatch_count']} mismatched"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"audit_matching_s08: {exc}", file=sys.stderr)
        raise SystemExit(2)
