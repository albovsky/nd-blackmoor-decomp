"""S08-3 object binding, exact-range, and original-x86 differential checks."""
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
SOURCE = PROJECT / "src/matching_s08_3_x86.s"
OBJECT = PROJECT / "build/matching_s08_3_x86.obj"
REPORT = PROJECT / "build/matching_s08_3_x86-report.json"
ORACLE_REPORT = PROJECT / "build/matching_s08_3_x86-oracle.json"
BUILD = PROJECT / "scripts/build_matching_s08_3_x86.sh"
GAS = WORK / "tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
AUDITOR_PATH = PROJECT / "scripts/audit_matching_s08_3_x86.py"
ORACLE = PROJECT / "tests/matching_s08_3_x86_oracle.py"
EXPECTED_ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"


def load_auditor():
    spec = importlib.util.spec_from_file_location("s08_3_matching_audit_test", AUDITOR_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError("unable to load S08-3 assembly audit")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class MatchingS08ThirdX86Tests(unittest.TestCase):
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

    def test_manifest_and_actual_object_are_exact_complete_reviewed_ranges(self) -> None:
        report = json.loads(REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["original"]["sha256"], EXPECTED_ORIGINAL_SHA256)
        self.assertEqual(report["status"], "exact_match_from_reviewed_reconstructed_assembly_source")
        self.assertEqual(report["classification"], "explicit_reconstructed_assembly_source")
        self.assertEqual(report["function_count"], 3)
        self.assertEqual(report["compared_bytes"], 176)
        self.assertEqual(report["comparison"]["exact_byte_range_count"], 3)
        self.assertEqual(report["comparison"]["difference_count"], 0)
        self.assertEqual(report["comparison"]["rejected_count"], 0)
        self.assertTrue(report["comparison"]["all_byte_ranges_exact"])
        self.assertEqual(report["source_object_association"]["status"], "verified_reassembly_match")
        self.assertTrue(report["source_object_association"]["canonical_object_path"])
        self.assertFalse(report["source_object_association"]["historical_compiler_provenance_claim"])
        self.assertTrue(report["assembler"]["version"].startswith("GNU assembler (GNU Binutils) 2.43.1"))
        self.assertTrue(report["object"]["sha256"])
        self.assertFalse(report["contains_original_byte_values"])
        self.assertFalse(report["compiler_generated_C_claim"])
        self.assertFalse(report["whole_executable_rebuilt"])

    def test_exact_copy_at_alternate_path_does_not_inherit_source_classification(self) -> None:
        auditor = load_auditor()
        with tempfile.TemporaryDirectory(prefix="s08-3-alternate-object-") as directory:
            alternate = Path(directory) / "same-object.obj"
            shutil.copyfile(OBJECT, alternate)
            report = auditor.audit(ORIGINAL, alternate, SOURCE)
        self.assertEqual(report["classification"], "external_candidate_object")
        self.assertEqual(report["status"], "external_candidate_exact_byte_match")
        self.assertTrue(report["comparison"]["all_byte_ranges_exact"])
        self.assertFalse(report["source_object_association"]["canonical_object_path"])

    def test_unreviewed_equivalent_source_and_stale_object_remain_external(self) -> None:
        auditor = load_auditor()
        with tempfile.TemporaryDirectory(prefix="s08-3-stale-source-") as directory:
            stale = Path(directory) / "stale.s"
            stale.write_text(SOURCE.read_text(encoding="utf-8") + "\n/* unreviewed equivalent */\n", encoding="utf-8")
            report = auditor.audit(ORIGINAL, OBJECT, stale)
        self.assertEqual(report["classification"], "external_candidate_object")
        self.assertEqual(report["status"], "external_candidate_exact_byte_match")
        self.assertEqual(report["source_object_association"]["status"], "verified_reassembly_match")
        self.assertFalse(report["source"]["matches_reviewed_source"])

    def test_mutated_matching_source_stays_external_and_reports_differences(self) -> None:
        auditor = load_auditor()
        with tempfile.TemporaryDirectory(prefix="s08-3-mutated-source-") as directory:
            temp = Path(directory)
            mutant_source = temp / "wrong-store.s"
            mutant_object = temp / "wrong-store.obj"
            mutant_source.write_text(
                SOURCE.read_text(encoding="utf-8").replace(
                    "movl %edx, 0x18(%eax)", "movl %edx, 0x1c(%eax)", 1
                ),
                encoding="utf-8",
            )
            subprocess.run([str(GAS), "--32", "-o", str(mutant_object), str(mutant_source)], check=True)
            report = auditor.audit(ORIGINAL, mutant_object, mutant_source)
        self.assertEqual(report["classification"], "external_candidate_object")
        self.assertEqual(report["source_object_association"]["status"], "verified_reassembly_match")
        self.assertFalse(report["source"]["matches_reviewed_source"])
        self.assertFalse(report["comparison"]["all_byte_ranges_exact"])
        self.assertGreater(report["comparison"]["difference_count"], 0)

    def test_incomplete_terminal_ret_is_rejected_as_malformed_extent(self) -> None:
        auditor = load_auditor()
        with tempfile.TemporaryDirectory(prefix="s08-3-bad-terminal-") as directory:
            temp = Path(directory)
            source = temp / "bad-terminal.s"
            obj = temp / "bad-terminal.obj"
            source.write_text(SOURCE.read_text(encoding="utf-8").replace("ret $8", "ret $4", 1), encoding="utf-8")
            subprocess.run([str(GAS), "--32", "-o", str(obj), str(source)], check=True)
            with self.assertRaises(ValueError):
                auditor.validate_object(obj)

    def test_original_and_candidate_match_state_abi_and_mutation_oracles(self) -> None:
        oracle_python = oracle_support.require_oracle_python(WORK / "tools/oracle-python/bin/python")
        result = subprocess.run(
            [
                str(oracle_python),
                str(ORACLE),
                "--original", str(ORIGINAL),
                "--object", str(OBJECT),
                "--report", str(ORACLE_REPORT),
            ],
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        report = json.loads(ORACLE_REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["original_sha256"], EXPECTED_ORIGINAL_SHA256)
        self.assertEqual(report["function_count"], 3)
        self.assertEqual(report["original_candidate_comparisons"], 421)
        self.assertEqual(report["candidate_original_mismatches"], 0)
        self.assertEqual(report["compared_bytes_per_case"], 0x1000)
        self.assertEqual(report["comparisons_by_method"], {"move": 9, "down": 8, "up": 404})
        self.assertTrue(report["wrong_store_mutant_detected"])
        self.assertTrue(report["wrong_guard_mutant_detected"])
        self.assertIn("EFLAGS", report["compared_context"])
        self.assertFalse(report["contains_original_byte_values"])


if __name__ == "__main__":
    unittest.main()
