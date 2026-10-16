"""Acceptance and structural mutation checks for the S08-2 assembly lowering."""
from __future__ import annotations

import importlib.util
import hashlib
import json
import subprocess
import tempfile
import unittest
from pathlib import Path

import oracle_support

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
WORK = ROOT / "work"
SOURCE = PROJECT / "src/matching_s08_2_x86.s"
ORIGINAL = WORK / "original/GAME.EXE"
OBJECT = PROJECT / "build/matching_s08_2_x86.obj"
BUILD = PROJECT / "scripts/build_matching_s08_2_x86.sh"
GAS = WORK / "tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
AUDITOR = PROJECT / "scripts/audit_matching_s08_2_x86.py"
ORACLE = PROJECT / "tests/matching_s08_2_x86_oracle.py"
AUDIT_REPORT = WORK / "analysis/slices/S08-2-x86-report.json"
ORACLE_REPORT = WORK / "analysis/slices/S08-2-x86-oracle.json"
EXPECTED_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"


def load_auditor():
    spec = importlib.util.spec_from_file_location("matching_s08_2_x86_audit_test", AUDITOR)
    if spec is None or spec.loader is None:
        raise RuntimeError("unable to load assembly audit")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class MatchingS08SecondX86BatchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        result = subprocess.run(["bash", str(BUILD), str(ORIGINAL)], text=True, capture_output=True, check=False)
        if result.returncode:
            raise AssertionError(result.stdout + result.stderr)

    def test_audit_pins_complete_ranges_and_exact_bytes(self) -> None:
        report = json.loads(AUDIT_REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["original"]["sha256"], EXPECTED_SHA256)
        self.assertEqual(report["original"]["size"], 1_511_424)
        self.assertEqual(report["classification"], "explicit_reconstructed_assembly_source")
        self.assertEqual(report["status"], "exact_match_from_reviewed_reconstructed_assembly_source")
        self.assertFalse(report["compiler_generated_C_claim"])
        self.assertFalse(report["whole_executable_rebuilt"])
        self.assertEqual(report["function_count"], 6)
        self.assertEqual(report["compared_bytes"], 112)
        self.assertEqual(report["comparison"]["exact_byte_range_count"], 6)
        self.assertEqual(report["comparison"]["difference_count"], 0)
        self.assertEqual(report["comparison"]["rejected_count"], 0)
        self.assertTrue(report["assembler"]["version"].startswith("GNU assembler (GNU Binutils) 2.43.1"))
        self.assertTrue(report["source"]["sha256"])
        self.assertTrue(report["object"]["sha256"])
        self.assertEqual(report["object"]["path"], "outputs/blackmoor-decomp/build/matching_s08_2_x86.obj")
        self.assertEqual(report["comparison_binding"]["object_path"], report["object"]["path"])
        self.assertEqual(report["comparison_binding"]["object_file_sha256"], report["object"]["sha256"])
        self.assertEqual(report["source_object_association"]["status"], "verified_reassembly_match")
        self.assertTrue(report["source_object_association"]["matches_canonical_reviewed_source"])
        self.assertTrue(report["source_object_association"]["reassembly_matches_audited_object"])
        self.assertFalse(report["source_object_association"]["historical_provenance_claim"])
        self.assertEqual(report["assembler"]["reproduction_command"][3], "<temporary-object>")
        self.assertNotIn("assembler_command", report["assembler"])
        self.assertTrue(report["manifest"]["sha256"])
        self.assertTrue(report["disassembler"]["candidate_disassembly_sha256"])
        self.assertTrue(report["disassembler"]["original_disassembly_sha256"])
        self.assertTrue(report["build_scripts"]["assembly_sha256"])
        self.assertTrue(report["build_scripts"]["assembler_bootstrap_sha256"])
        self.assertFalse(report["contains_original_byte_values"])
        self.assertEqual(len(report["functions"]), 6)
        for function in report["functions"]:
            with self.subTest(function=function["symbol"]):
                self.assertTrue(function["range_audit"]["complete_to_terminal_ret"])
                candidate = function["candidate_audit"]
                self.assertEqual(candidate["size"], function["size"])
                self.assertEqual(candidate["terminal_mnemonic"], "ret")
                self.assertTrue(candidate["disassembly_sha256"])
                self.assertTrue(function["range_audit"]["disassembly_sha256"])
                self.assertEqual(function["byte_comparison"]["mismatch_offsets"], [])

    def test_alternate_object_is_compared_and_source_object_claims_are_bound(self) -> None:
        original_source_text = SOURCE.read_text(encoding="utf-8")
        mutant_source_text = original_source_text.replace(
            "movl 0x18(%eax), %eax", "movl 0x14(%eax), %eax", 1
        )
        self.assertNotEqual(mutant_source_text, original_source_text)
        with tempfile.TemporaryDirectory(prefix="s08-2-x86-provenance-") as temp_dir:
            temp = Path(temp_dir)
            mutant_source = temp / "wrong-field.s"
            mutant_object = temp / "wrong-field.obj"
            mutant_source.write_text(mutant_source_text, encoding="utf-8")
            built = subprocess.run(
                [str(GAS), "--32", "-o", str(mutant_object), str(mutant_source)],
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(built.returncode, 0, built.stdout + built.stderr)

            def run_audit(label: str, source: Path, obj: Path) -> dict:
                report_path = temp / f"{label}.json"
                result = subprocess.run(
                    [
                        "python3", str(AUDITOR),
                        "--original", str(ORIGINAL),
                        "--source", str(source),
                        "--object", str(obj),
                        "--report", str(report_path),
                    ],
                    text=True,
                    capture_output=True,
                    check=False,
                )
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                return json.loads(report_path.read_text(encoding="utf-8"))

            # A stale/wrong-field object supplied beside the canonical source
            # must be the object actually compared, and cannot inherit the
            # canonical source's exact-match result.
            wrong_object = run_audit("wrong-object", SOURCE, mutant_object)
            self.assertEqual(wrong_object["comparison"]["exact_byte_range_count"], 5)
            self.assertEqual(wrong_object["comparison"]["difference_count"], 1)
            self.assertEqual(wrong_object["source_object_association"]["status"], "unverified_external_candidate")
            self.assertFalse(wrong_object["source_object_association"]["reassembly_matches_audited_object"])
            self.assertEqual(wrong_object["classification"], "external_candidate_object")
            self.assertEqual(wrong_object["status"], "external_candidate_byte_mismatch")
            self.assertIsNotNone(wrong_object["next_blocker"])
            self.assertEqual(wrong_object["object"]["path"], str(mutant_object.resolve()))
            self.assertEqual(wrong_object["object"]["sha256"], hashlib.sha256(mutant_object.read_bytes()).hexdigest())
            self.assertEqual(wrong_object["comparison_binding"]["object_path"], wrong_object["object"]["path"])
            self.assertEqual(wrong_object["comparison_binding"]["object_file_sha256"], wrong_object["object"]["sha256"])
            self.assertEqual(wrong_object["source"]["path"], "outputs/blackmoor-decomp/src/matching_s08_2_x86.s")
            self.assertEqual(wrong_object["source"]["sha256"], hashlib.sha256(SOURCE.read_bytes()).hexdigest())

            # Pairing the stale source with the good object reports the actual
            # good-object match, while explicitly refusing to attribute it to
            # the stale source. Pairing both stale source and its object proves
            # a current reassembly relationship but still reports the field
            # mismatch against the original.
            stale_source = run_audit("stale-source", mutant_source, OBJECT)
            self.assertEqual(stale_source["comparison"]["exact_byte_range_count"], 6)
            self.assertEqual(stale_source["comparison"]["difference_count"], 0)
            self.assertEqual(stale_source["source_object_association"]["status"], "unverified_external_candidate")
            self.assertEqual(stale_source["classification"], "external_candidate_object")
            self.assertEqual(stale_source["status"], "external_candidate_exact_byte_match")
            self.assertIsNotNone(stale_source["next_blocker"])
            self.assertEqual(stale_source["object"]["sha256"], hashlib.sha256(OBJECT.read_bytes()).hexdigest())
            self.assertEqual(stale_source["source"]["path"], str(mutant_source.resolve()))
            self.assertEqual(stale_source["source"]["sha256"], hashlib.sha256(mutant_source.read_bytes()).hexdigest())

            paired_mutants = run_audit("paired-mutants", mutant_source, mutant_object)
            self.assertEqual(paired_mutants["comparison"]["exact_byte_range_count"], 5)
            self.assertEqual(paired_mutants["comparison"]["difference_count"], 1)
            self.assertEqual(paired_mutants["source_object_association"]["status"], "verified_reassembly_match")
            self.assertTrue(paired_mutants["source_object_association"]["reassembly_matches_audited_object"])
            self.assertFalse(paired_mutants["source_object_association"]["matches_canonical_reviewed_source"])
            self.assertEqual(paired_mutants["classification"], "external_candidate_object")
            self.assertEqual(paired_mutants["status"], "external_candidate_byte_mismatch")

    def test_failed_source_reassembly_keeps_exact_object_as_external_candidate(self) -> None:
        with tempfile.TemporaryDirectory(prefix="s08-2-x86-failed-source-") as temp_dir:
            temp = Path(temp_dir)
            failed_source = temp / "invalid.s"
            failed_source.write_text(".text\nthis is not a valid instruction\n", encoding="utf-8")
            report_path = temp / "failed-reassembly.json"
            result = subprocess.run(
                [
                    "python3", str(AUDITOR),
                    "--original", str(ORIGINAL),
                    "--source", str(failed_source),
                    "--object", str(OBJECT),
                    "--report", str(report_path),
                ],
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            report = json.loads(report_path.read_text(encoding="utf-8"))
            self.assertEqual(report["comparison"]["exact_byte_range_count"], 6)
            self.assertEqual(report["comparison"]["difference_count"], 0)
            self.assertEqual(report["classification"], "external_candidate_object")
            self.assertEqual(report["status"], "external_candidate_exact_byte_match")
            self.assertEqual(report["source_object_association"]["status"], "unverified_external_candidate")
            self.assertFalse(report["source_object_association"]["reassembly_matches_audited_object"])
            self.assertFalse(report["source_object_association"]["matches_canonical_reviewed_source"])
            self.assertFalse(report["source_object_association"]["historical_provenance_claim"])
            self.assertTrue(report["source_object_association"]["reassembly_error"])
            self.assertIsNotNone(report["next_blocker"])

    def test_structural_and_abi_mutants_are_rejected(self) -> None:
        auditor = load_auditor()
        original_source = SOURCE.read_text(encoding="utf-8")
        second_block = original_source.index(".globl _FUN_004dae77")
        last_block = original_source.index(".globl _FUN_004daf29")
        mutations = {
            "missing function": original_source[:last_block],
            "short function": original_source.replace("    movl 0x18(%eax), %eax\n", "", 1),
            "extra trailing instruction": original_source + "\nnop\n",
            "alignment gap": original_source.replace(".globl _FUN_004dae77", ".p2align 4\n.globl _FUN_004dae77", 1),
            "instruction gap": original_source.replace("    ret\n\n.globl _FUN_004dae77", "    ret\n    .space 1\n.globl _FUN_004dae77", 1),
            "wrong terminal instruction": original_source.replace("    ret\n\n.globl _FUN_004dae77", "    nop\n\n.globl _FUN_004dae77", 1),
            "wrong setter cleanup": original_source.replace("    ret $4", "    ret $0", 1),
        }
        self.assertLess(second_block, last_block)
        with tempfile.TemporaryDirectory(prefix="s08-2-x86-mutants-") as temp_dir:
            temp = Path(temp_dir)
            for index, (label, source_text) in enumerate(mutations.items()):
                with self.subTest(mutant=label):
                    mutant_source = temp / f"mutant-{index}.s"
                    mutant_object = temp / f"mutant-{index}.obj"
                    mutant_source.write_text(source_text, encoding="utf-8")
                    built = subprocess.run([str(GAS), "--32", "-o", str(mutant_object), str(mutant_source)], text=True, capture_output=True, check=False)
                    self.assertEqual(built.returncode, 0, built.stdout + built.stderr)
                    with self.assertRaises(ValueError):
                        auditor.validate_object(mutant_object)

    def test_original_and_candidate_abi_match_semantic_c_and_mutants_fail(self) -> None:
        oracle_python = oracle_support.require_oracle_python(WORK / "tools/oracle-python/bin/python")
        result = subprocess.run(
            [str(oracle_python), str(ORACLE), "--original", str(ORIGINAL), "--report", str(ORACLE_REPORT)],
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        report = json.loads(ORACLE_REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["original_sha256"], EXPECTED_SHA256)
        self.assertEqual(report["function_count"], 6)
        self.assertEqual(report["comparison_cases"], 42)
        self.assertEqual(report["candidate_original_mismatches"], 0)
        self.assertEqual(report["candidate_native_semantic_mismatches"], 0)
        self.assertEqual(report["candidate_getter_stack_delta"], 4)
        self.assertEqual(report["candidate_setter_stack_delta"], 8)
        self.assertTrue(report["native_semantic_library_sha256"])
        self.assertTrue(report["assembly_tool_sha256"])
        self.assertTrue(report["candidate_restored_EBP"])
        self.assertTrue(report["candidate_uses_ECX_this_and_stack_setter_argument"])
        self.assertTrue(report["wrong_field_assembly_mutant_detected"])
        self.assertTrue(report["cdecl_getter_mutant_detected"])
        self.assertTrue(report["cdecl_setter_mutant_detected"])
        self.assertFalse(report["contains_original_byte_values"])


if __name__ == "__main__":
    unittest.main()
