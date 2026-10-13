"""Regression checks for the S08-2 accessor source and compiler audit."""
from __future__ import annotations

import json
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
WORK = ROOT / "work"
ORIGINAL = WORK / "original/GAME.EXE"
BUILD = PROJECT / "scripts/build_matching_s08_2.sh"
ORACLE = PROJECT / "tests/matching_s08_2_original_oracle.py"
ORACLE_PYTHON = WORK / "tools/oracle-python/bin/python"
REPORT = WORK / "analysis/slices/S08-2-report.json"
ORACLE_REPORT = WORK / "analysis/slices/S08-2-oracle.json"
EXPECTED_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
EXPECTED = {
    0x0DAE66: (17, "_FUN_004dae66", 0x4DAE66, [1, 2, 3, 13, 14, 15, 16]),
    0x0DAE77: (17, "_FUN_004dae77", 0x4DAE77, [1, 2, 3, 13, 14, 15, 16]),
    0x0DAEF1: (17, "_FUN_004daef1", 0x4DAEF1, [1, 2, 3, 13, 14, 15, 16]),
    0x0DAF02: (22, "_FUN_004daf02", 0x4DAF02, list(range(1, 9)) + list(range(13, 22))),
    0x0DAF18: (17, "_FUN_004daf18", 0x4DAF18, [1, 2, 3, 13, 14, 15, 16]),
    0x0DAF29: (22, "_FUN_004daf29", 0x4DAF29, list(range(1, 9)) + list(range(13, 22))),
}


class MatchingS08SecondBatchTests(unittest.TestCase):
    def test_compiler_audit_pins_complete_ranges_and_exact_mismatches(self) -> None:
        result = subprocess.run(
            ["bash", str(BUILD), str(ORIGINAL)],
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        report = json.loads(REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["original"]["sha256"], EXPECTED_SHA256)
        self.assertEqual(report["original"]["size"], 1_511_424)
        self.assertFalse(report["contains_original_byte_values"])
        baseline = report["comparison"]
        self.assertEqual(baseline["function_count"], 6)
        self.assertEqual(baseline["compared_bytes"], 112)
        self.assertEqual(baseline["exact_byte_range_count"], 0)
        self.assertEqual(baseline["mismatch_count"], 6)
        self.assertEqual(baseline["rejected_count"], 0)
        self.assertEqual(baseline["difference_count"], 62)
        self.assertEqual(baseline["status"], "toolchain_mismatch_reported")

        functions = {int(item["rva"]): item for item in report["functions"]}
        self.assertEqual(set(functions), set(EXPECTED))
        for rva, (size, name, va, mismatches) in EXPECTED.items():
            with self.subTest(function=name):
                item = functions[rva]
                self.assertEqual(item["va"], va)
                self.assertEqual(item["size"], size)
                self.assertEqual(item["symbol"], name)
                audit = item["range_audit"]
                self.assertEqual(audit["next_indexed_start_va"], va + size)
                self.assertEqual(audit["decoded_size"], size)
                self.assertTrue(audit["complete_to_terminal_ret"])
                self.assertEqual(item["baseline"]["mismatch_offsets"], mismatches)
                self.assertEqual(item["baseline"]["mismatch_count"], len(mismatches))
                self.assertTrue(item["original_sha256"])
                self.assertTrue(item["baseline"]["candidate_sha256"])

        variants = {item["name"]: item for item in report["compiler_matrix"]}
        for name in ("C-O0", "C-O1", "C-O2", "C-Os", "C++-O0", "C++-MS-compat", "C-GNU-target-O0"):
            with self.subTest(variant=name):
                self.assertIn(name, variants)
                self.assertEqual(variants[name]["exact_byte_range_count"], 0)

    def test_original_oracle_matches_native_c_and_rejects_mutants(self) -> None:
        result = subprocess.run(
            [str(ORACLE_PYTHON), str(ORACLE), "--original", str(ORIGINAL), "--report", str(ORACLE_REPORT)],
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        report = json.loads(ORACLE_REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["original_sha256"], EXPECTED_SHA256)
        self.assertEqual(report["original_native_cases"], 18)
        self.assertEqual(report["original_native_mismatches"], 0)
        self.assertTrue(report["wrong_field_mutant_detected"])
        self.assertTrue(report["cdecl_getter_mutant_detected"])
        self.assertTrue(report["cdecl_setter_mutant_detected"])
        self.assertEqual(report["original_stack_cleanup"]["getter_bytes"], 4)
        self.assertEqual(report["original_stack_cleanup"]["setter_bytes"], 8)
        self.assertFalse(report["contains_original_byte_values"])


if __name__ == "__main__":
    unittest.main()
