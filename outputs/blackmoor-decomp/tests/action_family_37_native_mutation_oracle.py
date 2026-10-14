#!/usr/bin/env python3
"""Compile real C source mutants and compare constructor calls to original x86."""
from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import importlib.util
import json
import struct
import subprocess
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
ORACLE_PATH = ROOT / "outputs/blackmoor-decomp/tests/action_family_37_original_oracle.py"
SOURCE_PATH = ROOT / "outputs/blackmoor-decomp/src/action_family_37.c"
HEADER_PATH = ROOT / "outputs/blackmoor-decomp/src/action_family_37.h"
EXE_PATH = ROOT / "work/original/GAME.EXE"
CORPUS_PATH = ROOT / "work/analysis/slices/A-37.1-discovery-corpus.json"
MANIFEST_PATH = ROOT / "work/analysis/hiff-resources.json"
WORK_PATH = ROOT / "work/analysis/slices/A-37.2-native-mutants-input_matching_luna6"
EXPECTED_SOURCE_SHA256 = "d7c3931171aaf1ec0afcb7c0cc2dc104ac4a4e597065da7858b16b04ece22a86"
EXPECTED_HEADER_SHA256 = "697456c6ba6f6cfe43b4cb2b131973cd75af3faac90e6bd8d35e79910c7a1aac"
EXPECTED_EXE_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
EXPECTED_CORPUS_SHA256 = "a4253c266d94267a563bc357dbaf3ed69a6e1fbd2ddd5198b0ec71bf5e04296d"
EXPECTED_MANIFEST_SHA256 = "440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c"

MUTANTS = [
    {
        "name": "swapped_option_source_mapping",
        "old": """    write_u16_le(constructed.object_bytes + 0x23u, decoded.option_21);\n    write_u16_le(constructed.object_bytes + 0x27u, decoded.option_23);""",
        "new": """    write_u16_le(constructed.object_bytes + 0x23u, decoded.option_23);\n    write_u16_le(constructed.object_bytes + 0x27u, decoded.option_21);""",
        "expected_first_offset": 0x23,
    },
    {
        "name": "wrong_constructor_default",
        "old": "    write_u16_le(object + 0x29u, 1u);",
        "new": "    write_u16_le(object + 0x29u, 2u);",
        "expected_first_offset": 0x29,
    },
    {
        "name": "wrong_width_derivation",
        "old": "    write_u32_le(object + 0x6fau, right - left);",
        "new": "    write_u32_le(object + 0x6fau, right - left + UINT32_C(1));",
        "expected_first_offset": 0x6FA,
    },
]


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_oracle():
    spec = importlib.util.spec_from_file_location("a37_mutation_original_oracle", ORACLE_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError("could not load direct original constructor oracle")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def compile_library(compiler: str, source_path: Path, output_path: Path, include_path: Path):
    command = [
        compiler, "--sdk", "macosx", "clang", "-arch", "arm64", "-std=c11",
        "-Wall", "-Wextra", "-Wpedantic", "-Werror", "-O2", "-fPIC",
        "-dynamiclib", "-I", str(include_path), str(source_path), "-o", str(output_path),
    ]
    try:
        completed = subprocess.run(command, check=True, capture_output=True, text=True)
    except subprocess.CalledProcessError as error:
        raise RuntimeError(f"native mutant compile failed: {error.stderr.strip()}") from error
    return command, completed.stdout, completed.stderr


def fixtures_from_pinned_corpus(oracle):
    corpus_bytes = CORPUS_PATH.read_bytes()
    manifest_bytes = MANIFEST_PATH.read_bytes()
    if sha256(corpus_bytes) != EXPECTED_CORPUS_SHA256:
        raise RuntimeError("A-37.1 census SHA-256 differs from pinned input")
    if sha256(manifest_bytes) != EXPECTED_MANIFEST_SHA256:
        raise RuntimeError("resource manifest SHA-256 differs from pinned input")
    corpus = json.loads(corpus_bytes)
    manifest = json.loads(manifest_bytes)
    if len(corpus["records"]) != 4308:
        raise RuntimeError("pinned corpus record count is not 4,308")
    resources = {int(item["index"]): item for item in manifest["resources"]}
    cache: dict[int, bytes] = {}
    fixtures = []
    for ordinal, row in enumerate(corpus["records"]):
        resource_index = int(row["resource_index"])
        if resource_index not in cache:
            resource = (ROOT / "work/analysis/hiff-resources" / f"{resource_index:04d}.bin").read_bytes()
            meta = resources[resource_index]
            if len(resource) != int(meta["size"]) or sha256(resource) != meta["sha256"]:
                raise RuntimeError(f"resource {resource_index} differs from pinned manifest")
            cache[resource_index] = resource
        resource = cache[resource_index]
        offset = int(row["raw_body_offset"])
        length = int(row["raw_body_length"])
        body = resource[offset:offset + length]
        if len(body) != length or length < oracle.BODY_BYTES:
            raise RuntimeError(f"corpus record {ordinal} has invalid source bounds")
        if offset != int(row["act_payload_offset"]) + 50:
            raise RuntimeError(f"corpus record {ordinal} ACT prefix offset changed")
        if sha256(body[:oracle.BODY_BYTES]) != row["prefix_69_sha256"]:
            raise RuntimeError(f"corpus record {ordinal} prefix hash changed")
        fixtures.append({
            "label": f"corpus-{ordinal}",
            "body": body,
            "payload_offset": 0x32,
            "resource_index": resource_index,
            "action_index": int(row["action_index"]),
        })

    synthetic = oracle.create_body(
        b"mutation-catch", 0x1357, 0x2468,
        (10, 90, 710, 500), (0x10203040, -7, 0x55667788, -0x12345), 2,
    )
    fixtures.append({
        "label": "synthetic-distinct-options-rectangle-and-dependencies",
        "body": synthetic,
        "payload_offset": 0x32,
        "resource_index": None,
        "action_index": None,
    })
    return fixtures, corpus_bytes, manifest_bytes, len(cache)


def expected_offset(mutant_name: str, body: bytes):
    if mutant_name == "swapped_option_source_mapping":
        option_21, option_23 = struct.unpack_from("<HH", body, 0x21)
        return 0x23 if option_21 != option_23 else None
    if mutant_name == "wrong_constructor_default":
        return 0x29
    if mutant_name == "wrong_width_derivation":
        return 0x6FA
    raise ValueError(f"unknown mutant {mutant_name}")


def compare_variant(oracle, lib, uc, hooks, initial, regs, fixtures, variant_name):
    first_offsets: Counter[int] = Counter()
    mismatch_objects = 0
    mismatch_bytes = 0
    expected_detection_objects = 0
    original_bytes_compared = 0
    synthetic = []
    for ordinal, fixture in enumerate(fixtures):
        body = fixture["body"]
        source = (c.c_uint8 * len(body)).from_buffer_copy(body)
        native = oracle.Constructed()
        handle = (0x37000001 + ordinal) & 0xFFFFFFFF
        status = lib.action_family_37_construct(
            source, len(body), fixture["payload_offset"], handle, c.byref(native)
        )
        if status != 0:
            raise RuntimeError(f"{variant_name} constructor rejected {fixture['label']}: status={status}")
        original = oracle.invoke_original(
            uc, regs, initial, body, fixture["payload_offset"]
        )
        native_image = bytes(native.object_bytes)
        original_image = original["object"]
        original_bytes_compared += len(original_image)
        diff = oracle.first_difference(native_image, original_image)
        expected = expected_offset(variant_name, body) if variant_name != "baseline" else None
        if variant_name == "baseline":
            if diff is not None:
                raise RuntimeError(f"fresh baseline source mismatches original at {fixture['label']}:{diff:#x}")
        else:
            if expected is not None:
                expected_detection_objects += 1
                if diff != expected:
                    raise RuntimeError(
                        f"{variant_name} failed planted-defect localization at {fixture['label']}: "
                        f"first={diff!r}, expected={expected:#x}"
                    )
            elif diff is not None:
                raise RuntimeError(
                    f"{variant_name} produced unexpected mismatch at {fixture['label']}:{diff:#x}"
                )
        if diff is not None:
            mismatch_objects += 1
            first_offsets[diff] += 1
            mismatch_bytes += sum(a != b for a, b in zip(native_image, original_image))
        if fixture["resource_index"] is None:
            synthetic.append({
                "label": fixture["label"],
                "first_mismatch_offset": diff,
                "expected_first_offset": expected,
                "different_image_bytes": sum(a != b for a, b in zip(native_image, original_image)),
                "bytes_compared": len(original_image),
            })

    if hooks["allocations"] < len(fixtures):
        raise RuntimeError("original constructor allocation hook did not run for each fixture")
    if variant_name != "baseline" and (expected_detection_objects == 0 or mismatch_objects == 0):
        raise RuntimeError(f"{variant_name} did not produce any detectable native defects")
    return {
        "fixtures": len(fixtures),
        "actual_corpus_fixtures": len(fixtures) - 1,
        "synthetic_fixtures": synthetic,
        "original_constructor_calls": len(fixtures),
        "allocation_hook_calls_cumulative": hooks["allocations"],
        "full_object_bytes_compared": original_bytes_compared,
        "mismatching_objects": mismatch_objects,
        "mismatching_image_bytes": mismatch_bytes,
        "first_mismatch_offsets": {f"0x{k:x}": first_offsets[k] for k in sorted(first_offsets)},
        "fixtures_with_expected_defect_condition": expected_detection_objects,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--work-dir", type=Path, default=WORK_PATH)
    parser.add_argument("--result", type=Path, default=None)
    parser.add_argument("--compiler", default="xcrun")
    args = parser.parse_args()

    if sha256(SOURCE_PATH.read_bytes()) != EXPECTED_SOURCE_SHA256:
        raise RuntimeError("accepted A-37.2 constructor source hash changed")
    if sha256(HEADER_PATH.read_bytes()) != EXPECTED_HEADER_SHA256:
        raise RuntimeError("accepted A-37.2 header hash changed")
    if sha256(EXE_PATH.read_bytes()) != EXPECTED_EXE_SHA256:
        raise RuntimeError("immutable GAME.EXE SHA-256 changed")
    oracle = load_oracle()
    pe = oracle.map_original(EXE_PATH)
    fixtures, corpus_bytes, manifest_bytes, resource_count = fixtures_from_pinned_corpus(oracle)
    uc, hooks, initial, regs = oracle.load_unicorn(pe)

    source_text = SOURCE_PATH.read_text()
    args.work_dir.mkdir(parents=True, exist_ok=True)
    source_dir = args.work_dir / "sources"
    build_dir = args.work_dir / "build"
    source_dir.mkdir(parents=True, exist_ok=True)
    build_dir.mkdir(parents=True, exist_ok=True)
    records = []

    variants = [{"name": "baseline", "old": None, "new": None}]
    variants.extend(MUTANTS)
    for variant in variants:
        name = variant["name"]
        mutated_source = source_text
        if name != "baseline":
            old = variant["old"]
            new = variant["new"]
            count = mutated_source.count(old)
            if count != 1:
                raise RuntimeError(f"{name} source anchor count is {count}, expected exactly 1")
            mutated_source = mutated_source.replace(old, new, 1)
        source_path = source_dir / f"action_family_37_{name}.c"
        library_path = build_dir / f"libactionfamily37_{name}.dylib"
        source_path.write_text(mutated_source)
        command, _stdout, _stderr = compile_library(
            args.compiler, source_path, library_path, SOURCE_PATH.parent
        )
        lib = oracle.load_native(library_path)
        comparison = compare_variant(
            oracle, lib, uc, hooks, initial, regs, fixtures, name
        )
        records.append({
            "name": name,
            "source_path_relative_to_repo": str(source_path),
            "source_sha256": sha256(source_path.read_bytes()),
            "library_path_relative_to_repo": str(library_path),
            "library_sha256": sha256(library_path.read_bytes()),
            "compile_command": command,
            "compile_result": "success",
            "comparison": comparison,
        })

    if hooks["allocations"] != len(variants) * len(fixtures):
        raise RuntimeError(f"expected {len(variants) * len(fixtures)} original calls, got {hooks['allocations']}")
    original_image_bytes = sum(
        record["comparison"]["full_object_bytes_compared"] for record in records
    )
    result = {
        "slice": "A-37.2-native-source-mutation-oracle",
        "status": "passed",
        "immutable_original_exe_sha256": EXPECTED_EXE_SHA256,
        "census_sha256": sha256(corpus_bytes),
        "manifest_sha256": sha256(manifest_bytes),
        "accepted_constructor_source_sha256": sha256(SOURCE_PATH.read_bytes()),
        "accepted_header_sha256": sha256(HEADER_PATH.read_bytes()),
        "corpus_records": 4308,
        "resources_hash_verified": resource_count,
        "source_mutants_executed": len(MUTANTS),
        "variant_count_including_clean_baseline": len(variants),
        "total_original_constructor_calls": hooks["allocations"],
        "total_complete_object_bytes_compared": original_image_bytes,
        "original_allocator_hook_address": "0x51dc43 only",
        "other_original_code_hooks": 0,
        "mutant_sources_are_private_copies": True,
        "original_game_executable_modified": False,
        "comparison_class": "compiled native source mutant constructor outputs compared byte-for-byte with actual original x86 constructor outputs",
        "variants": records,
    }
    result_path = args.result or args.work_dir / "report.json"
    result_path.parent.mkdir(parents=True, exist_ok=True)
    result_path.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({
        "status": "passed",
        "report": str(result_path),
        "corpus_records_per_variant": 4308,
        "synthetic_cases_per_variant": 1,
        "variants": len(variants),
        "original_constructor_calls": hooks["allocations"],
        "full_object_bytes_compared": original_image_bytes,
        "mutant_detected_objects": {
            item["name"]: item["comparison"]["mismatching_objects"]
            for item in records if item["name"] != "baseline"
        },
    }, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:
        print(f"A-37.2 native mutation oracle failed: {error}", file=sys.stderr)
        raise
