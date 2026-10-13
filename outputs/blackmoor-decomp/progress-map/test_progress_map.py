import hashlib
import importlib.util
import json
import pathlib
import tempfile
import unittest

MODULE = pathlib.Path(__file__).with_name("generate.py")
SPEC = importlib.util.spec_from_file_location("progress_map_generate", MODULE)
GEN = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GEN)

ORIGINAL = GEN.EXPECTED_EXE


class ProgressMapDataTests(unittest.TestCase):
    def write_json(self, path, value):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(value), encoding="utf-8")

    def fixture(self, root):
        project = root / "project"
        evidence = root / "evidence"
        out = project / "outputs/blackmoor-decomp"
        self.write_json(out / "function-index.json", {
            "original_sha256": ORIGINAL,
            "failures": [],
            "functions": [
                {"address": "0x401000", "name": "FUN_00401000", "file": "unverified-pseudocode/401000.c.txt", "evidence_id": "ev-a"},
                {"address": "0x401010", "name": "FUN_00401010", "file": "unverified-pseudocode/401010.c.txt", "evidence_id": "ev-b"},
            ],
        })
        self.write_json(out / "matching-report.json", {
            "functions": [{
                "rva": 0x1000, "compared_bytes": 7, "exact_byte_range": True,
                "function_completeness": "unverified",
            }],
        })
        self.write_json(evidence / "S08-matching-report.json", {
            "status": "comparison_complete",
            "text_section": {"virtual_address": 0x1000, "virtual_size": 0x20, "raw_size": 0x200},
            "functions": [{
                "va": 0x401000, "end_va": 0x401010, "size": 16,
                "range_audit": {"complete_to_terminal_ret": True},
                "match_status": "byte-range-mismatch", "mismatch_count": 2,
            }],
        })
        source = out / "src/scene_executor.c"
        source.parent.mkdir(parents=True, exist_ok=True)
        source.write_text("fixture source\n", encoding="utf-8")
        self.write_json(out / "hotspot-runtime-validation.json", {
            "original_sha256": ORIGINAL, "mismatches": [],
            "scope": "bounded fixture", "native_library_sha256": "native",
            "code_ranges": [{"start": "0x401000", "end_exclusive": "0x401010", "name": "fixture entry"}],
        })
        a64_source = out / "src/action_family_64.c"
        a64_source.write_text("A64 fixture\n", encoding="utf-8")
        a64_sha = hashlib.sha256(a64_source.read_bytes()).hexdigest()
        self.write_json(evidence / "A-64-validation.json", {
            "source_file_sha256": {"src/action_family_64.c": a64_sha},
            "native_arm64_library_sha256": "a64-native",
        })
        self.write_json(evidence / "A-64-original-oracle.json", {
            "original_sha256": ORIGINAL, "mismatches": [], "scope": "bounded A64 fixture",
            "native_library_sha256": "a64-native",
            "code_ranges": [
                {"start": "0x401010", "end_exclusive": "0x401020", "name": "A64 entry"},
                {"start": "0x401008", "end_exclusive": "0x40100c", "name": "interior A64 window"},
            ],
        })
        self.write_json(out / "slice-registry.json", {"slices": [
            {"id": "S03", "title": "AVF", "status": "READY", "packet": "tasks/S03.md"},
            {"id": "S05", "title": "Captions", "status": "READY", "packet": "tasks/S05.md"},
        ]})
        self.write_json(evidence / "S05-claim.json", {
            "slice": "S05", "owner": "Claude", "status": "claimed",
        })
        self.write_json(out / "action-census-current.json", {"parser_sha256": "stale"})
        self.write_json(out / "COORDINATION-STATUS.md", {"unused": "fixture"})
        (project / "work/analysis").mkdir(parents=True, exist_ok=True)
        (project / "work/analysis/slices").symlink_to(evidence, target_is_directory=True)
        return project, evidence

    def test_snapshot_keeps_start_spans_and_exact_extents_distinct(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertEqual(data["inventory"]["indexed_starts"], 2)
        self.assertEqual(data["functions"][0]["size"], 16)
        self.assertEqual(data["functions"][0]["extent_kind"], "complete range audited to terminal return")
        self.assertEqual(data["functions"][0]["address_unit"], "0x0040xxxx")
        self.assertEqual(data["functions"][1]["size"], None)
        self.assertTrue(data["functions"][1]["is_unknown_extent"])
        self.assertEqual(data["inventory"]["text_section"]["unresolved_tail_bytes"], 16)
        self.assertEqual(data["summary"]["exact_selected_bytes"], 7)
        self.assertEqual(data["summary"]["exact_function_completeness"], "unverified")
        self.assertEqual(data["summary"]["s08_compiler_mismatches"], 1)

    def test_report_only_and_source_bound_oracle_records_are_separate(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        first, last = data["functions"]
        self.assertEqual(first["oracle"][0]["kind"], "bounded-report")
        self.assertEqual(first["oracle"][0]["source_binding"], "not source-hash-bound")
        self.assertEqual(first["oracle_ranges"][0]["start"], 0x401008)
        self.assertIn("not full function coverage", first["oracle_ranges"][0]["coverage_location"])
        bound = next(x for x in last["oracle"] if x["kind"] == "oracle-bound")
        self.assertEqual(bound["source_binding_reason"], "Native source and library SHAs match the validation report.")
        self.assertEqual(data["summary"]["bounded_oracle_source_bound_starts"], 1)
        self.assertEqual(data["summary"]["bounded_oracle_report_only_starts"], 1)

    def test_source_match_does_not_hide_native_library_mismatch(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            report_path = evidence / "A-64-original-oracle.json"
            report = json.loads(report_path.read_text(encoding="utf-8"))
            report["native_library_sha256"] = "different-native"
            self.write_json(report_path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        record = next(x for x in data["oracle_reports"] if x["id"] == "action64")
        self.assertEqual(record["source_binding_reason"], "Source SHA matches; native-library SHA differs from the validation report.")
        self.assertEqual(record["source_binding"], "not source-hash-bound")
        self.assertEqual(data["summary"]["bounded_oracle_source_bound_starts"], 0)

    def test_stale_action_census_is_not_used_as_a_metric(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertFalse(data["census"]["included_in_metrics"])
        self.assertIn("suppressed", data["census"]["state"])

    def test_embedded_json_cannot_close_its_script_element(self):
        html = GEN.embed(
            '<script type="application/json">__SNAPSHOT_JSON__</script>',
            {"name": "</script><script>alert(1)</script>"},
        )
        self.assertNotIn("</script><script>alert", html)
        self.assertIn("\\u003c/script\\u003e", html)


if __name__ == "__main__":
    unittest.main()
