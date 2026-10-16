"""Fail-closed source/object provenance and original-x86 checks for S08-4."""
from __future__ import annotations

import importlib.util
import json
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

import oracle_support

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
WORK = ROOT / "work"
ORIGINAL = WORK / "original/GAME.EXE"
SOURCE = PROJECT / "src/matching_s08_4_x86.s"
OBJECT = PROJECT / "build/matching_s08_4_x86.obj"
REPORT = PROJECT / "build/matching_s08_4_x86-report.json"
ORACLE_REPORT = PROJECT / "build/matching_s08_4_x86-oracle.json"
BUILD = PROJECT / "scripts/build_matching_s08_4_x86.sh"
GAS = WORK / "tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
AUDITOR_PATH = PROJECT / "scripts/audit_matching_s08_4_x86.py"
ORACLE = PROJECT / "tests/matching_s08_4_x86_oracle.py"
EXPECTED_ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"


def load_auditor():
    spec = importlib.util.spec_from_file_location("s08_4_matching_audit_test", AUDITOR_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError("unable to load S08-4 assembly audit")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class MatchingS08FourthX86Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        REPORT.parent.mkdir(parents=True, exist_ok=True)
        result = subprocess.run(
            ["bash", str(BUILD), str(ORIGINAL), str(REPORT)],
            text=True,
            capture_output=True,
            check=False,
        )
        if result.returncode:
            raise AssertionError(result.stdout + result.stderr)

    def test_reviewed_manifest_binds_both_complete_extents_and_current_source_object(self) -> None:
        report = json.loads(REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["original"]["sha256"], EXPECTED_ORIGINAL_SHA256)
        self.assertEqual(report["status"], "exact_match_from_reviewed_reconstructed_assembly_source")
        self.assertEqual(report["classification"], "explicit_reconstructed_assembly_source")
        self.assertEqual(report["function_count"], 2)
        self.assertEqual(report["compared_bytes"], 96)
        self.assertEqual(report["unique_exact_bytes"], 96)
        self.assertEqual(report["comparison"]["exact_byte_range_count"], 2)
        self.assertEqual(report["comparison"]["difference_count"], 0)
        self.assertEqual(report["comparison"]["rejected_count"], 0)
        self.assertTrue(report["comparison"]["all_byte_ranges_exact"])
        self.assertEqual(report["source_object_association"]["status"], "verified_reassembly_match")
        self.assertTrue(report["source_object_association"]["canonical_object_path"])
        self.assertFalse(report["source_object_association"]["historical_compiler_provenance_claim"])
        self.assertTrue(report["assembler"]["matches_reviewed_assembler"])
        self.assertEqual(report["candidate_functions"]["_FUN_004daf3f"]["size"], 47)
        self.assertEqual(report["candidate_functions"]["_FUN_004daf6e"]["size"], 49)
        self.assertTrue(report["previous_s08_3_ranges_disjoint"])
        self.assertTrue(report["assembler"]["version"].startswith("GNU assembler (GNU Binutils) 2.43.1"))
        self.assertFalse(report["contains_original_byte_values"])
        self.assertFalse(report["compiler_generated_C_claim"])
        self.assertFalse(report["whole_executable_rebuilt"])

    def test_modern_thiscall_C_mismatches_are_reported_separately(self) -> None:
        report = json.loads(REPORT.read_text(encoding="utf-8"))
        probe = report["compiler_probe"]
        self.assertEqual(probe["status"], "completed")
        self.assertFalse(probe["claims_exact_match"])
        self.assertGreaterEqual(len(probe["variants"]), 4)
        for variant in probe["variants"]:
            self.assertFalse(variant["all_exact"])
            self.assertTrue(all(function["byte_mismatch_count"] > 0 for function in variant["functions"]))

    def test_alternate_object_and_unreviewed_manifest_remain_external(self) -> None:
        auditor = load_auditor()
        with tempfile.TemporaryDirectory(prefix="s08-4-alternate-evidence-") as directory:
            temp = Path(directory)
            alternate_object = temp / "same-object.obj"
            shutil.copyfile(OBJECT, alternate_object)
            alternate_report = auditor.audit(
                ORIGINAL, alternate_object, SOURCE, include_compiler_probe=False
            )
            self.assertEqual(alternate_report["classification"], "external_candidate_object")
            self.assertEqual(alternate_report["status"], "external_candidate_exact_byte_match")
            self.assertFalse(alternate_report["source_object_association"]["canonical_object_path"])

            alternate_manifest = temp / "copied-manifest.json"
            shutil.copyfile(PROJECT / "matches_s08_4_x86.json", alternate_manifest)
            manifest_report = auditor.audit(
                ORIGINAL, OBJECT, SOURCE, alternate_manifest, include_compiler_probe=False
            )
            self.assertEqual(manifest_report["classification"], "external_candidate_object")
            self.assertTrue(manifest_report["comparison"]["all_byte_ranges_exact"])
            self.assertFalse(manifest_report["manifest"]["matches_reviewed_manifest"])

    def test_unreviewed_equivalent_source_and_stale_object_do_not_gain_reviewed_claim(self) -> None:
        auditor = load_auditor()
        with tempfile.TemporaryDirectory(prefix="s08-4-unreviewed-source-") as directory:
            stale_source = Path(directory) / "equivalent.s"
            stale_source.write_text(
                SOURCE.read_text(encoding="utf-8") + "\n/* unreviewed equivalent */\n",
                encoding="utf-8",
            )
            report = auditor.audit(
                ORIGINAL, OBJECT, stale_source, include_compiler_probe=False
            )
        self.assertEqual(report["classification"], "external_candidate_object")
        self.assertEqual(report["status"], "external_candidate_exact_byte_match")
        self.assertEqual(report["source_object_association"]["status"], "verified_reassembly_match")
        self.assertTrue(report["source_object_association"]["fresh_reassembled_object_sha256"])
        self.assertFalse(report["source"]["matches_reviewed_source"])

    def test_malformed_extent_manifest_and_incomplete_return_extent_are_rejected(self) -> None:
        auditor = load_auditor()
        with tempfile.TemporaryDirectory(prefix="s08-4-malformed-evidence-") as directory:
            temp = Path(directory)
            manifest_path = temp / "bad-manifest.json"
            manifest = json.loads((PROJECT / "matches_s08_4_x86.json").read_text(encoding="utf-8"))
            manifest["functions"][0]["size"] -= 1
            manifest_path.write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaises(ValueError):
                auditor.audit(ORIGINAL, OBJECT, SOURCE, manifest_path, include_compiler_probe=False)

            bad_source = temp / "bad-terminal.s"
            bad_object = temp / "bad-terminal.obj"
            bad_source.write_text(
                SOURCE.read_text(encoding="utf-8").replace("    popl %ebp\n    ret", "    popl %ebp\n    ret $4", 1),
                encoding="utf-8",
            )
            assembled = subprocess.run(
                [str(GAS), "--32", "-o", str(bad_object), str(bad_source)],
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(assembled.returncode, 0, assembled.stdout + assembled.stderr)
            with self.assertRaises(ValueError):
                auditor.validate_object(bad_object)

    def test_full_original_candidate_register_stack_and_mutant_oracle(self) -> None:
        oracle_python = oracle_support.require_oracle_python(WORK / "tools/oracle-python/bin/python")
        result = subprocess.run(
            [
                str(oracle_python), str(ORACLE),
                "--original", str(ORIGINAL), "--object", str(OBJECT),
                "--report", str(ORACLE_REPORT),
            ],
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        report = json.loads(ORACLE_REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["original_sha256"], EXPECTED_ORIGINAL_SHA256)
        self.assertEqual(report["original_candidate_comparisons"], 76)
        self.assertEqual(report["candidate_original_mismatches"], 0)
        self.assertEqual(report["compared_state_bytes_per_call"], 0x1000)
        self.assertEqual(report["comparisons_by_method"], {"field0": 38, "field4": 38})
        self.assertTrue(report["mutation_detection"]["wrong_clear_detected"])
        self.assertTrue(report["mutation_detection"]["wrong_result_detected"])
        self.assertIn("EFLAGS", report["compared_context"])
        self.assertIn("ESP", report["compared_context"])
        self.assertFalse(report["contains_original_byte_values"])


if __name__ == "__main__":
    unittest.main()
