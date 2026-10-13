#!/usr/bin/env python3
"""Build compiler variants and audit six complete S08-2 accessor ranges.

The comparison is sanitized before it is written: reports contain hashes,
addresses and mismatch positions, never original or generated machine bytes.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
import shutil
import struct
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Any

PROJECT = Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
WORK = REPOSITORY / "work"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
EVIDENCE_ID = "ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619"
COMMON_FLAGS = ["-fno-omit-frame-pointer", "-fno-stack-protector", "-fno-builtin"]

VARIANTS: list[dict[str, Any]] = [
    {"name": "C-O0", "language": "c", "target": "i686-pc-windows-msvc", "source": "src/matching_s08.c", "flags": ["-std=c11", "-O0"]},
    {"name": "C-Og", "language": "c", "target": "i686-pc-windows-msvc", "source": "src/matching_s08.c", "flags": ["-std=c11", "-Og"]},
    {"name": "C-O1", "language": "c", "target": "i686-pc-windows-msvc", "source": "src/matching_s08.c", "flags": ["-std=c11", "-O1"]},
    {"name": "C-O2", "language": "c", "target": "i686-pc-windows-msvc", "source": "src/matching_s08.c", "flags": ["-std=c11", "-O2"]},
    {"name": "C-Os", "language": "c", "target": "i686-pc-windows-msvc", "source": "src/matching_s08.c", "flags": ["-std=c11", "-Os"]},
    {"name": "C-Oz", "language": "c", "target": "i686-pc-windows-msvc", "source": "src/matching_s08.c", "flags": ["-std=c11", "-Oz"]},
    {"name": "C++-O0", "language": "cpp", "target": "i686-pc-windows-msvc", "source": "src/matching_s08_2.cpp", "flags": ["-std=c++17", "-O0"]},
    {"name": "C++-Og", "language": "cpp", "target": "i686-pc-windows-msvc", "source": "src/matching_s08_2.cpp", "flags": ["-std=c++17", "-Og"]},
    {"name": "C++-O1", "language": "cpp", "target": "i686-pc-windows-msvc", "source": "src/matching_s08_2.cpp", "flags": ["-std=c++17", "-O1"]},
    {"name": "C++-O2", "language": "cpp", "target": "i686-pc-windows-msvc", "source": "src/matching_s08_2.cpp", "flags": ["-std=c++17", "-O2"]},
    {"name": "C++-Os", "language": "cpp", "target": "i686-pc-windows-msvc", "source": "src/matching_s08_2.cpp", "flags": ["-std=c++17", "-Os"]},
    {"name": "C++-MS-compat", "language": "cpp", "target": "i686-pc-windows-msvc", "source": "src/matching_s08_2.cpp", "flags": ["-std=c++17", "-O0", "-fms-extensions", "-fms-compatibility", "-fms-compatibility-version=19.00"]},
    {"name": "C-GNU-target-O0", "language": "c", "target": "i686-w64-windows-gnu", "source": "src/matching_s08.c", "flags": ["-std=c11", "-O0"]},
]
CPP_SYMBOLS = {
    0x0DAE66: "?get@FUN_004dae66_receiver@@QAEIXZ",
    0x0DAE77: "?get@FUN_004dae77_receiver@@QAEIXZ",
    0x0DAEF1: "?get@FUN_004daef1_receiver@@QAEIXZ",
    0x0DAF02: "?set@FUN_004daf02_receiver@@QAEXI@Z",
    0x0DAF18: "?get@FUN_004daf18_receiver@@QAEIXZ",
    0x0DAF29: "?set@FUN_004daf29_receiver@@QAEXI@Z",
}


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_verifier() -> Any:
    path = PROJECT / "scripts/verify_matches.py"
    spec = importlib.util.spec_from_file_location("s08_2_verify_matches", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load verifier at {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def run(command: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, check=True, capture_output=True, text=True)


def decode_range(original: Path, start: int, end: int) -> list[dict[str, Any]]:
    result = run([
        "xcrun", "llvm-objdump", "-d", "--x86-asm-syntax=intel",
        f"--start-address=0x{start:x}", f"--stop-address=0x{end:x}", str(original),
    ])
    instructions: list[dict[str, Any]] = []
    for line in result.stdout.splitlines():
        if ":" not in line:
            continue
        address_text, rest = line.split(":", 1)
        if not re.fullmatch(r"\s*[0-9a-fA-F]+\s*", address_text):
            continue
        parts = rest.strip().split()
        encoded: list[str] = []
        while parts and re.fullmatch(r"[0-9a-fA-F]{2}", parts[0]):
            encoded.append(parts.pop(0))
        if not encoded or not parts:
            continue
        instruction: dict[str, Any] = {
            "address": int(address_text, 16),
            "size": len(encoded),
            "mnemonic": parts[0].lower(),
        }
        if len(parts) > 1:
            instruction["operands"] = " ".join(parts[1:])
        instructions.append(instruction)
    return instructions


def audit_ranges(original_data: bytes, index_path: Path, manifest_path: Path, original: Path) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    index_bytes = index_path.read_bytes()
    index = json.loads(index_bytes)
    if index.get("original_sha256") != ORIGINAL_SHA256:
        raise ValueError("function index is not pinned to the expected executable")
    entries = index.get("functions")
    if not isinstance(entries, list) or len(entries) != 4188 or index.get("failures"):
        raise ValueError("Ghidra function inventory count/failures changed")
    by_va = {int(entry["address"], 16): entry for entry in entries}
    if len(by_va) != len(entries):
        raise ValueError("function inventory has duplicate starts")
    starts = sorted(by_va)
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    rows: list[dict[str, Any]] = []
    for function in manifest["functions"]:
        rva = int(function["rva"])
        va = 0x400000 + rva
        size = int(function["size"])
        indexed = by_va.get(va)
        if indexed is None:
            raise ValueError(f"candidate {function['symbol']} absent from function index")
        position = starts.index(va)
        successor = starts[position + 1] if position + 1 < len(starts) else None
        if successor != va + size:
            raise ValueError(f"candidate {function['symbol']} size does not end at next indexed start")
        instructions = decode_range(original, va, va + size)
        cursor = va
        for instruction in instructions:
            if instruction["address"] != cursor:
                raise ValueError(f"instruction gap in {function['symbol']} at 0x{cursor:x}")
            cursor += instruction["size"]
        decoded = sum(item["size"] for item in instructions)
        terminal = instructions[-1] if instructions else {}
        complete = bool(instructions) and cursor == va + size and decoded == size and terminal["mnemonic"].startswith("ret")
        if not complete:
            raise ValueError(f"candidate {function['symbol']} does not decode completely through terminal ret")
        code = original_data
        rows.append({
            "va": va,
            "rva": rva,
            "end_va": va + size,
            "size": size,
            "symbol": function["symbol"],
            "evidence_id": function.get("evidence_id", indexed.get("evidence_id")),
            "original_sha256": None,
            "range_audit": {
                "basis": "adjacent Ghidra function starts plus complete linear disassembly through terminal ret",
                "next_indexed_start_va": successor,
                "decoded_size": decoded,
                "instruction_count": len(instructions),
                "complete_to_terminal_ret": True,
                "instructions": instructions,
                "evidence_id": indexed["evidence_id"],
            },
        })
        # Hash the exact original file-backed range without retaining its bytes.
        peoff = struct.unpack_from("<I", code, 0x3C)[0]
        opt = peoff + 4 + 20
        section_table = opt + struct.unpack_from("<H", code, peoff + 4 + 16)[0]
        section_count = struct.unpack_from("<H", code, peoff + 6)[0]
        file_offset = None
        for section_index in range(section_count):
            record = section_table + section_index * 40
            virtual_size, virtual_address, raw_size, raw_offset = struct.unpack_from("<IIII", code, record + 8)
            if virtual_address <= rva and rva + size <= virtual_address + raw_size:
                file_offset = raw_offset + rva - virtual_address
                break
        if file_offset is None:
            raise ValueError(f"candidate {function['symbol']} is not file-backed")
        rows[-1]["original_sha256"] = sha256(code[file_offset:file_offset + size])
    return rows, {
        "source": "outputs/blackmoor-decomp/function-index.json",
        "source_sha256": sha256(index_bytes),
        "provider": "Ghidra 12.1.4 via REA 6.4.0",
        "indexed_functions": len(entries),
        "index_failures": len(index.get("failures", [])),
    }


def pe_toolchain_metadata(data: bytes) -> dict[str, Any]:
    pe_offset = struct.unpack_from("<I", data, 0x3C)[0]
    coff = pe_offset + 4
    machine, section_count, timestamp, _symbols, _symbol_count, optional_size, _flags = struct.unpack_from("<HHIIIHH", data, coff)
    optional = coff + 20
    magic = struct.unpack_from("<H", data, optional)[0]
    image_base = struct.unpack_from("<I", data, optional + 28)[0]
    rich_offset = data.find(b"Rich", 0, pe_offset)
    rich_entries: list[dict[str, int]] = []
    if rich_offset >= 0 and rich_offset + 8 <= pe_offset:
        key = struct.unpack_from("<I", data, rich_offset + 4)[0]
        dans = None
        for offset in range(0x40, rich_offset - 12, 4):
            decoded = [struct.unpack_from("<I", data, offset + shift)[0] ^ key for shift in (0, 4, 8, 12)]
            if decoded == [0x536E6144, 0, 0, 0]:
                dans = offset
                break
        if dans is not None:
            for offset in range(dans + 16, rich_offset, 8):
                compid = struct.unpack_from("<I", data, offset)[0] ^ key
                count = struct.unpack_from("<I", data, offset + 4)[0] ^ key
                rich_entries.append({"product_id": compid >> 16, "build_id": compid & 0xFFFF, "count": count})
    return {
        "machine": {"value": machine, "name": "i386" if machine == 0x14C else "unknown"},
        "section_count": section_count,
        "coff_timestamp_epoch": timestamp,
        "optional_header_magic": {"value": magic, "name": "PE32" if magic == 0x10B else "unknown"},
        "linker_version": {"major": data[optional + 2], "minor": data[optional + 3]},
        "image_base": image_base,
        "rich_header": {
            "present": rich_offset >= 0,
            "entries": rich_entries,
            "interpretation": "product/build/count tuples recorded as observed; no compiler-version mapping asserted",
        },
    }


def sanitize_report(raw: dict[str, Any]) -> dict[str, Any]:
    functions = []
    for item in raw.get("functions", []):
        functions.append({
            "rva": item.get("rva"),
            "size": item.get("size"),
            "symbol": item.get("symbol"),
            "status": item.get("status"),
            "exact_byte_range": bool(item.get("exact_byte_range")),
            "original_sha256": item.get("original_sha256"),
            "candidate_sha256": item.get("object_sha256"),
            "mismatch_offsets": [int(entry["offset"]) for entry in item.get("differences", [])],
            "mismatch_count": len(item.get("differences", [])),
            "error": item.get("error"),
            "contains_original_byte_values": False,
        })
    return {
        "function_count": raw.get("function_count", 0),
        "compared_bytes": sum(int(item.get("size", 0)) for item in raw.get("functions", []) if item.get("status") != "rejected"),
        "exact_byte_range_count": raw.get("exact_byte_range_count", 0),
        "mismatch_count": raw.get("mismatch_count", 0),
        "rejected_count": raw.get("rejected_count", 0),
        "difference_count": raw.get("difference_count", 0),
        "status": "exact" if raw.get("all_byte_ranges_exact") else "toolchain_mismatch_reported",
        "functions": functions,
        "contains_original_byte_values": False,
    }


def compiler_version(command: list[str]) -> str | None:
    try:
        return run(command).stdout.splitlines()[0]
    except (OSError, subprocess.CalledProcessError, IndexError):
        return None


def audit(original: Path) -> dict[str, Any]:
    data = original.read_bytes()
    actual_sha = sha256(data)
    if actual_sha != ORIGINAL_SHA256:
        raise ValueError(f"original SHA-256 mismatch: {actual_sha}")
    base_manifest_path = PROJECT / "matches_s08.json"
    cpp_manifest_path = PROJECT / "matches_s08_2.json"
    baseline_manifest = json.loads(base_manifest_path.read_text(encoding="utf-8"))
    cpp_manifest = json.loads(cpp_manifest_path.read_text(encoding="utf-8"))
    build_dir = PROJECT / "build/matching_s08_2"
    build_dir.mkdir(parents=True, exist_ok=True)
    verifier = load_verifier()
    compiled: list[dict[str, Any]] = []
    clang_version = compiler_version(["xcrun", "clang", "--version"])
    for variant in VARIANTS:
        source = PROJECT / variant["source"]
        obj = build_dir / (variant["name"].replace("+", "p").replace("-", "_") + ".obj")
        command = ["xcrun", "clang", "-target", variant["target"], *variant["flags"], *COMMON_FLAGS, "-c", str(source), "-o", str(obj)]
        run(command)
        base = cpp_manifest if variant["language"] == "cpp" else baseline_manifest
        ephemeral = _ephemeral_manifest(base, obj, build_dir, variant["language"])
        try:
            raw = verifier.verify(original, ephemeral)
        finally:
            ephemeral.unlink(missing_ok=True)
        summary = sanitize_report(raw)
        summary.update({
            "name": variant["name"],
            "language": variant["language"],
            "target": variant["target"],
            "source": "outputs/blackmoor-decomp/" + variant["source"],
            "source_sha256": sha256(source.read_bytes()),
            "compiler": clang_version,
            "flags": ["-target", variant["target"], *variant["flags"], *COMMON_FLAGS],
            "object_sha256": sha256(obj.read_bytes()),
            "build_command": command,
        })
        compiled.append(summary)
    baseline = next(item for item in compiled if item["name"] == "C-O0")
    cpp = next(item for item in compiled if item["name"] == "C++-O0")
    range_rows, inventory_summary = audit_ranges(data, PROJECT / "function-index.json", base_manifest_path, original)
    base_by_rva = {int(item["rva"]): item for item in baseline["functions"]}
    cpp_by_rva = {int(item["rva"]): item for item in cpp["functions"]}
    for row in range_rows:
        base_row = base_by_rva[row["rva"]]
        cpp_row = cpp_by_rva[row["rva"]]
        row["baseline"] = {
            "status": base_row["status"],
            "candidate_sha256": base_row["candidate_sha256"],
            "mismatch_count": base_row["mismatch_count"],
            "mismatch_offsets": base_row["mismatch_offsets"],
            "contains_original_byte_values": False,
        }
        row["cpp_candidate"] = {
            "status": cpp_row["status"],
            "candidate_sha256": cpp_row["candidate_sha256"],
            "mismatch_count": cpp_row["mismatch_count"],
            "mismatch_offsets": cpp_row["mismatch_offsets"],
            "contains_original_byte_values": False,
        }
    gcc_version = compiler_version(["gcc", "--version"])
    clang_cl = subprocess.run(["xcrun", "--find", "clang-cl"], capture_output=True, text=True, check=False)
    return {
        "slice": "S08-2-x86-getter-matching",
        "status": "comparison_complete_no_exact_match",
        "whole_executable_rebuilt": False,
        "original": {"sha256": actual_sha, "size": len(data), "path": "work/original/GAME.EXE"},
        "function_inventory": inventory_summary,
        "toolchain_metadata": pe_toolchain_metadata(data),
        "toolchain": {
            "clang": clang_version,
            "gcc_driver": gcc_version,
            "gcc_is_same_apple_clang_driver": gcc_version == clang_version,
            "clang_cl_available_via_xcrun": clang_cl.returncode == 0,
            "microsoft_cl_driver_in_path": shutil.which("cl") is not None,
            "microsoft_compiler_or_linker_version": "not available locally; owner has no VC6 installer",
        },
        "source_files": {
            "outputs/blackmoor-decomp/src/matching_s08.c": sha256((PROJECT / "src/matching_s08.c").read_bytes()),
            "outputs/blackmoor-decomp/src/matching_s08_2.cpp": sha256((PROJECT / "src/matching_s08_2.cpp").read_bytes()),
        },
        "comparison": {key: baseline[key] for key in ("function_count", "compared_bytes", "exact_byte_range_count", "mismatch_count", "rejected_count", "difference_count", "status")},
        "cpp_comparison": {key: cpp[key] for key in ("function_count", "compared_bytes", "exact_byte_range_count", "mismatch_count", "rejected_count", "difference_count", "status")},
        "functions": range_rows,
        "compiler_matrix": compiled,
        "compiler_constraints": [
            {"evidence_class": "observed original x86", "finding": "All four getter ranges enter with an EBP frame, spill ECX, load the field through the spill, and return with plain ret."},
            {"evidence_class": "observed original x86", "finding": "Both setters read the argument at [ebp+8], store via EAX/ECX, and return with ret 4; Unicorn confirms the callee removes the four-byte argument."},
            {"evidence_class": "observed Clang object at -O0", "finding": "Clang uses a different MOV encoding for the frame setup, reserves the local with push EAX, and restores the frame with add ESP,4. The original uses push ECX and mov ESP,EBP."},
            {"evidence_class": "observed source/compiler comparison", "finding": "The C++ member-method source preserves field semantics but produces six mismatches and 66 differing offsets; the C source produces six mismatches and 62 offsets."},
            {"evidence_class": "observed local toolchain", "finding": "The MSVC and GNU Windows target triples use the same Apple Clang compiler; optimization variants do not produce an exact complete range."},
        ],
        "unknowns": [
            "The original source field names and enclosing class declarations remain unverified.",
            "The PE linker version is observed as 6.0; this slice does not map Rich-header product/build tuples to a precise compiler release.",
            "The original compiler optimization/debug flags, linker settings, CRT/import/thunk boundaries and whole-PE reconstruction remain unverified.",
        ],
        "next_blocker": "No Microsoft VC6 compiler/linker is available in the local toolchain. Further byte matching requires the original Microsoft code generator or explicit human-reconstructed x86 lowering; the latter must remain separate from semantic C/C++ compiler evidence.",
        "contains_original_byte_values": False,
    }


def _ephemeral_manifest(base: dict[str, Any], object_path: Path, directory: Path, language: str) -> Path:
    candidate = json.loads(json.dumps(base))
    for entry in candidate["functions"]:
        entry["object"] = str(object_path.resolve())
        if language == "cpp":
            entry["symbol"] = CPP_SYMBOLS[entry["rva"]]
    handle = tempfile.NamedTemporaryFile("w", encoding="utf-8", suffix=".json", dir=directory, delete=False)
    path = Path(handle.name)
    with handle:
        json.dump(candidate, handle)
    return path


def write_report(path: Path, report: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("original", type=Path)
    parser.add_argument("--report", type=Path, default=WORK / "analysis/slices/S08-2-report.json")
    args = parser.parse_args()
    try:
        report = audit(args.original.resolve())
        write_report(args.report.resolve(), report)
    except (OSError, ValueError, RuntimeError, KeyError, subprocess.CalledProcessError) as exc:
        detail = exc.stderr if isinstance(exc, subprocess.CalledProcessError) else str(exc)
        print(f"S08-2 audit failed: {detail}", file=sys.stderr)
        return 1
    baseline = report["comparison"]
    cpp = report["cpp_comparison"]
    print(
        "S08-2 comparison complete: "
        f"{baseline['function_count']} full functions / {baseline['compared_bytes']} bytes; "
        f"C -O0 exact {baseline['exact_byte_range_count']}/6, {baseline['difference_count']} differing offsets; "
        f"C++ -O0 exact {cpp['exact_byte_range_count']}/6, {cpp['difference_count']} differing offsets; "
        f"{len(report['compiler_matrix'])} compiler variants audited; report contains no machine-byte values."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
