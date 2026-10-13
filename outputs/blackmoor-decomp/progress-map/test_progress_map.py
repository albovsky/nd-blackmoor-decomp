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
        manifest_path = out / "matches.json"
        self.write_json(manifest_path, {
            "original_sha256": ORIGINAL,
            "functions": [{"rva": 0x1000, "size": 7, "symbol": "_FUN_00401000"}],
        })
        byte_hash = "1" * 64
        self.write_json(out / "matching-report.json", {
            "all_byte_ranges_exact": True,
            "bytes": {"differences": 0, "exact_byte_ranges": 7, "mismatches": 0},
            "counts": {"differences": 0, "exact_byte_ranges": 1, "functions": 1, "mismatches": 0, "rejected": 0},
            "difference_bytes": 0, "difference_count": 0, "errors": [],
            "exact_byte_range_bytes": 7, "exact_byte_range_count": 1,
            "function_completeness": "unverified", "function_count": 1,
            "functions": [{
                "rva": 0x1000, "size": 7, "compared_bytes": 7, "exact_byte_range": True,
                "function_completeness": "unverified", "match_scope": "manifest-selected-byte-range",
                "status": "exact-byte-range", "differences": [], "original_sha256": byte_hash,
                "object_sha256": byte_hash,
            }],
            "manifest": str(manifest_path), "manifest_original_sha256": ORIGINAL,
            "match_scope": "manifest-selected-byte-range", "mismatch_bytes": 0, "mismatch_count": 0,
            "original": str(project / "work/original/GAME.EXE"), "original_sha256": ORIGINAL, "rejected_count": 0,
        })
        self.write_json(evidence / "S08-matching-report.json", {
            "status": "comparison_complete",
            "original": {"sha256": ORIGINAL, "size": 1511424},
            "comparison": {"status": "toolchain_mismatch_reported", "function_count": 1,
                            "mismatch_count": 1, "exact_byte_range_count": 0, "difference_count": 2},
            "text_section": {"virtual_address": 0x1000, "virtual_size": 0x20, "raw_pointer": 0x400, "raw_size": 0x200},
            "functions": [{
                "va": 0x401000, "end_va": 0x401010, "size": 16,
                "range_audit": {"complete_to_terminal_ret": True, "decoded_size": 16},
                "match_status": "byte-range-mismatch", "exact_byte_range": False, "mismatch_count": 2,
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
        self.assertEqual(data["summary"]["exact_selected_ranges"], 1)
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

    def test_quarantined_oracle_reports_do_not_create_direct_or_interior_evidence(self):
        mutations = (
            ("wrong original SHA", lambda report: report.update(original_sha256="0" * 64)),
            ("failed report state", lambda report: report.update(status="comparison_failed")),
            ("nonzero mismatches", lambda report: report.update(mismatches=["mismatch"])),
        )
        for label, mutate in mutations:
            with self.subTest(case=label):
                with tempfile.TemporaryDirectory() as tmp:
                    project, evidence = self.fixture(pathlib.Path(tmp))
                    path = evidence / "A-64-original-oracle.json"
                    report = json.loads(path.read_text(encoding="utf-8"))
                    mutate(report)
                    self.write_json(path, report)
                    data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
                report_row = next(row for row in data["oracle_reports"] if row["id"] == "action64")
                mapped = [window for function in data["functions"]
                          for window in function["oracle"] + function["oracle_ranges"]
                          if window["report_id"] == "action64"]
                self.assertEqual(mapped, [])
                self.assertEqual(report_row["entrypoint_count"], 0)
                self.assertEqual(report_row["quarantined_range_count"], 2)
                self.assertTrue(report_row["status"].startswith("quarantined:"))
                self.assertEqual({row["start"] for row in report_row["quarantined_ranges"]}, {0x401008, 0x401010})

    def test_external_evidence_links_resolve_to_files_whose_hashes_are_shown(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            local_evidence = project / "work/analysis/slices"
            local_evidence.unlink()
            local_evidence.mkdir(parents=True)
            for name in ("S08-matching-report.json", "A-64-original-oracle.json", "A-64-validation.json", "S05-claim.json"):
                (local_evidence / name).write_text('{"wrong":"local collision"}\n', encoding="utf-8")
            artifact = pathlib.Path(tmp) / "canonical-artifact-root"
            artifact.mkdir()
            (artifact / "outputs").symlink_to(project / "outputs", target_is_directory=True)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z", artifact_root=artifact)
            outdir = artifact / "outputs/blackmoor-decomp/progress-map"
            a64 = next(row for row in data["oracle_reports"] if row["id"] == "action64")
            s05 = next(row for row in data["slices"] if row["id"] == "S05")["claims"][0]
            s08_binding = data["report_bindings"][2]
            linked = (
                ("S08 snapshot", data["s08"]["report_link"], data["s08"]["report_sha256"]),
                ("S08 lineage", s08_binding["link"], s08_binding["sha256"]),
                ("A64 report", a64["report_link"], a64["report_sha256"]),
                ("A64 validation", a64["binding_report_link"], a64["binding_report_sha256"]),
                ("claim receipt", s05["link"], s05["sha256"]),
                ("project source", data["report_bindings"][0]["link"], data["report_bindings"][0]["sha256"]),
            )
            for label, link, expected_hash in linked:
                with self.subTest(input=label):
                    linked_path = outdir / link
                    resolved = linked_path.resolve()
                    if label == "project source":
                        self.assertTrue(linked_path.absolute().is_relative_to(artifact.absolute()))
                    else:
                        self.assertTrue(resolved.is_relative_to(evidence.resolve()))
                    self.assertEqual(hashlib.sha256(resolved.read_bytes()).hexdigest(), expected_hash)

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

    def test_wrong_executable_matching_report_is_quarantined(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = project / "outputs/blackmoor-decomp/matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["original_sha256"] = "0" * 64
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertEqual(data["summary"]["exact_selected_bytes"], 0)
        self.assertEqual(data["summary"]["exact_selected_ranges"], 0)
        self.assertEqual(data["functions"][0]["exact_ranges"], [])
        self.assertFalse(data["matching_validation"]["valid"])
        self.assertIn("quarantined", data["report_bindings"][1]["note"])

    def test_wrong_executable_manifest_cannot_pass_report_binding(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = project / "outputs/blackmoor-decomp/matches.json"
            manifest = json.loads(path.read_text(encoding="utf-8"))
            manifest["original_sha256"] = "0" * 64
            self.write_json(path, manifest)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertFalse(data["matching_validation"]["valid"])
        self.assertEqual(data["summary"]["exact_selected_bytes"], 0)
        self.assertIn("manifest original SHA", data["matching_validation"]["reason"])

    def test_failed_matching_state_is_quarantined_even_with_exact_row_flags(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = project / "outputs/blackmoor-decomp/matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["status"] = "comparison_failed"
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertEqual(data["summary"]["exact_selected_bytes"], 0)
        self.assertFalse(data["matching_validation"]["valid"])

    def test_stale_matching_state_is_quarantined(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = project / "outputs/blackmoor-decomp/matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["status"] = "stale"
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertFalse(data["matching_validation"]["valid"])
        self.assertEqual(data["summary"]["exact_selected_bytes"], 0)

    def test_per_range_flag_and_digest_must_be_exact(self):
        mutations = (
            ("non-boolean exact flag", lambda row: row.update(exact_byte_range="true")),
            ("different per-range digest", lambda row: row.update(original_sha256="2" * 64)),
        )
        for label, mutate in mutations:
            with self.subTest(case=label):
                with tempfile.TemporaryDirectory() as tmp:
                    project, evidence = self.fixture(pathlib.Path(tmp))
                    path = project / "outputs/blackmoor-decomp/matching-report.json"
                    report = json.loads(path.read_text(encoding="utf-8"))
                    mutate(report["functions"][0])
                    self.write_json(path, report)
                    data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
                self.assertEqual(data["summary"]["exact_selected_bytes"], 0)
                if data["matching_validation"]["valid"]:
                    self.assertEqual(len(data["matching_validation"]["rejected_ranges"]), 1)

    def test_wrong_executable_s08_report_cannot_promote_audited_extents(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = evidence / "S08-matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["original"]["sha256"] = "0" * 64
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertFalse(data["s08"]["validation"]["valid"])
        self.assertEqual(data["summary"]["s08_audited_extents"], 0)
        self.assertTrue(all(f["s08_audit"] is None for f in data["functions"]))
        self.assertIsNone(data["inventory"]["text_section"]["unresolved_tail_bytes"])
        self.assertIn("quarantined", data["report_bindings"][2]["note"])

    def test_out_of_function_exact_range_is_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            out = project / "outputs/blackmoor-decomp"
            manifest_path = out / "matches.json"
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            manifest["functions"][0].update(rva=0x100F, size=2)
            self.write_json(manifest_path, manifest)
            path = out / "matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["functions"][0].update(rva=0x100F, size=2, compared_bytes=2)
            report["exact_byte_range_bytes"] = 2
            report["bytes"]["exact_byte_ranges"] = 2
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertTrue(data["matching_validation"]["valid"])
        self.assertEqual(data["summary"]["exact_selected_bytes"], 0)
        self.assertEqual(len(data["matching_validation"]["rejected_ranges"]), 1)

    def test_s08_out_of_bounds_range_quarantines_audit(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = evidence / "S08-matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["functions"][0]["end_va"] = 0x401021
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertFalse(data["s08"]["validation"]["valid"])
        self.assertEqual(data["summary"]["s08_audited_extents"], 0)

    def test_partial_report_mismatch_does_not_discard_individually_exact_range(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            out = project / "outputs/blackmoor-decomp"
            manifest_path = out / "matches.json"
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            manifest["functions"].append({"rva": 0x1010, "size": 1, "symbol": "mismatch"})
            self.write_json(manifest_path, manifest)
            path = out / "matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["status"] = "partial_comparison"
            report["functions"].append({
                "rva": 0x1010, "size": 1, "compared_bytes": 1,
                "exact_byte_range": False, "status": "byte-range-mismatch",
                "differences": [{"offset": 0}],
            })
            report.update(function_count=2, mismatch_count=1, difference_count=1,
                          mismatch_bytes=1, difference_bytes=1, all_byte_ranges_exact=False)
            report["counts"].update(functions=2, mismatches=1, differences=1)
            report["bytes"].update(mismatches=1, differences=1)
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertTrue(data["matching_validation"]["valid"])
        self.assertEqual(data["summary"]["exact_selected_bytes"], 7)
        self.assertEqual(data["functions"][0]["exact_ranges"][0]["bytes"], 7)

    def test_overlapping_exact_ranges_count_covered_bytes_once(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            out = project / "outputs/blackmoor-decomp"
            manifest_path = out / "matches.json"
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            manifest["functions"].append({"rva": 0x1004, "size": 4, "symbol": "overlap"})
            self.write_json(manifest_path, manifest)
            path = out / "matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            item = dict(report["functions"][0], rva=0x1004, size=4, compared_bytes=4)
            report["functions"].append(item)
            report["function_count"] = 2
            report["exact_byte_range_count"] = 2
            report["exact_byte_range_bytes"] = 11
            report["counts"].update(functions=2, exact_byte_ranges=2)
            report["bytes"]["exact_byte_ranges"] = 11
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertEqual(data["summary"]["exact_source_ranges"], 2)
        self.assertEqual(data["summary"]["exact_selected_ranges"], 1)
        self.assertEqual(data["summary"]["exact_selected_bytes"], 8)
        self.assertEqual(data["functions"][0]["exact_ranges"][0]["size"], 8)

    def test_embedded_json_cannot_close_its_script_element(self):
        html = GEN.embed(
            '<script type="application/json">__SNAPSHOT_JSON__</script>',
            {"name": "</script><script>alert(1)</script>"},
        )
        self.assertNotIn("</script><script>alert", html)
        self.assertIn("\\u003c/script\\u003e", html)


if __name__ == "__main__":
    unittest.main()
