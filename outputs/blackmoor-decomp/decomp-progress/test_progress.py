import importlib.util
import json
import pathlib
import re
import shutil
import tempfile
import unittest

HERE = pathlib.Path(__file__).resolve().parent
EVIDENCE = HERE.parent
SPEC = importlib.util.spec_from_file_location("decomp_progress_generate", HERE / "generate.py")
GEN = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GEN)

SHA = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"


def hashlib_sha(text):
    import hashlib
    return hashlib.sha256(text.encode()).hexdigest()


def write(path, value):
    path.write_text(json.dumps(value), encoding="utf-8")


class RepoEvidenceTests(unittest.TestCase):
    """Run against the committed evidence, as the generator does."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.out = pathlib.Path(cls.tmp.name)
        rc = GEN.main(["--out-dir", str(cls.out)])
        assert rc == 0
        cls.model = json.loads((cls.out / "progress.json").read_text())
        # Independent byte-set accounting checks the interval implementation
        # against whichever reviewed batches root has collected in this checkout.
        cls.audited_vas, cls.audited_bytes, cls.legacy_bytes = set(), set(), set()
        for path in sorted((EVIDENCE / "asm").glob("batch-*.json")):
            if not re.fullmatch(r"batch-[0-9]+\.json", path.name):
                continue
            for fn in json.loads(path.read_text())["functions"]:
                cls.audited_vas.add(int(fn["va"], 0))
                code = fn["code"]
                cls.audited_bytes.update(range(code["rva"], code["rva"] + code["size"]))
        for name in GEN.COUNTED_MANIFESTS:
            for fn in json.loads((EVIDENCE / name).read_text())["functions"]:
                cls.legacy_bytes.update(range(fn["rva"], fn["rva"] + fn["size"]))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def test_every_file_byte_is_accounted_once(self):
        t = self.model["totals"]
        self.assertEqual(t["file_bytes"], 1511424)
        self.assertEqual(t["code"] + t["data"], 1511424)
        self.assertEqual(sum(u["size"] for u in self.model["units"]), 1511424)

    def test_playable_schema_and_committed_report_have_not_drifted(self):
        self.assertEqual(self.model["schema"], "blackmoor-decomp-progress/1")
        p = self.model["playable"]
        self.assertEqual(p["schema"], "blackmoor-playable-status/2")
        committed = json.loads((HERE / "progress.json").read_text())["playable"]
        self.assertEqual(p, committed, "Refresh progress after changes to live registrations or evidence")
        self.assertEqual(p["scene_total"], 2078)
        self.assertEqual(p["reached_scenes"], ["S0", "S5900", "S5907", *[f"S{i}" for i in range(5901, 5907)], "S4700"])
        self.assertEqual(p["stop"]["action_type"], "0x35")
        self.assertEqual(p["stop"]["row"], 3)
        self.assertEqual(p["tests"], {"discovered": 961, "passed": 956, "skipped": 5,
                                     "source_field": "current_integration.full_suite"})

    def test_action_body_counts_use_current_source_and_census_records(self):
        a = self.model["playable"]["action_types"]
        self.assertEqual(a["typed"]["records"], 19259)
        self.assertEqual(a["opaque"]["records"], 353)
        self.assertEqual(a["record_total"], 19612)
        self.assertEqual(a["typed"]["type_count"] + a["opaque"]["type_count"], a["type_total"])
        self.assertEqual(set(a["handled"]["types"]) | set(a["unsupported"]["types"]), set(a["typed"]["types"]))
        self.assertFalse(set(a["handled"]["types"]) & set(a["unsupported"]["types"]))
        self.assertEqual(a["handled"]["records"] + a["unsupported"]["records"], a["typed"]["records"])
        for code in ("0x37", "0x97", "0xa1"):
            self.assertIn(code, a["unsupported"]["types"])
            self.assertNotIn(code, a["opaque"]["types"])

    def test_live_registrations_match_derived_handled_list(self):
        a = self.model["playable"]["action_types"]
        self.assertEqual(a["registrations"], {
            "executor": ["0x0a", "0x15", "0x4d", "0x61", "0x64", "0x6a", "0x6b", "0x71"],
            "session_ui": ["0x1d", "0x82"],
            "external": {"0x28": "session_a28_handler", "0x51": "session_a51_handler",
                         "0x62": "session_a62_handler", "0x9f": "native_action_sound_handler"}})
        self.assertEqual(a["handled"]["type_count"], 14)
        derived = GEN.PLAYABLE.derive_actions(EVIDENCE)
        derived.pop("scene_total")
        self.assertEqual(a, derived)
        paths = {s["path"] for s in a["sources"]}
        self.assertTrue({"src/scene_executor.c", "src/action_core.c", "src/scene_session.c",
                         "src/blackmoor_app.mm", "src/session_bindings_a62.c",
                         "src/session_bindings_a51.c", "src/session_bindings_a28.c"} <= paths)
        self.assertTrue(all(p.startswith("src/") or p == "action-census-current.json" for p in paths))

    def test_batches_cover_indexed_spans_without_changing_headline_totals(self):
        index = sorted(int(f["address"], 0) for f in GEN.load_json(EVIDENCE / "function-index.json")["functions"])
        layout = GEN.load_layout(HERE / "layout.json")
        _, atoms = GEN.build_atoms(layout, {"original_sha256": SHA,
                                           "functions": [{"address": hex(va)} for va in index]}, 16384)
        spans = {a["va"]: a["size"] for a in atoms if a["kind"] == "code"}
        functions = [f for batch in ("001", "002")
                     for f in GEN.load_json(EVIDENCE / "asm" / f"batch-{batch}.json")["functions"]]
        self.assertEqual(len(functions), 86)
        self.assertEqual(sum(f["code"]["size"] for f in functions), 33312)
        for f in functions:
            self.assertEqual(f["code"]["size"] + sum(d["size"] for d in f["data_items"]),
                             spans[int(f["va"], 0)], f["function"])
        self.assertEqual(self.model["totals"]["matched_code"], 33326)
        self.assertEqual(self.model["totals"]["functions_complete"], 86)

    def test_report_labels_hotspot_upper_bound_and_test_source(self):
        report = (self.out / "REPORT.md").read_text()
        self.assertIn("upper bound", report)
        self.assertIn("typed_body[0] == 0x0d", report)
        self.assertIn("may differ from the live-run commit", report)
        self.assertIn("f44761b4d0a98f937230be40ea3bc1177dcc9713", report)

    def test_seeded_panel_labels_committed_notes(self):
        # Mutate only the evidence kind, then render through the real template.
        import copy
        model = copy.deepcopy(self.model)
        model["playable"]["evidence"].update(kind="seeded_committed_integration", native_sha256=None)
        html_path = self.out / "seeded.html"
        GEN.write_html(model, HERE / "template.html", html_path)
        html = html_path.read_text()
        self.assertIn('id="playableScope"', html)
        self.assertIn('P.evidence.kind==="seeded_committed_integration"', html)
        self.assertIn("Seeded from committed integration notes", html)
        self.assertIn("upper bound", html)
        self.assertIn("typed_body[0] == 0x0d", html)

    def test_playable_panel_precedes_x86_panel_and_report(self):
        html = (self.out / "index.html").read_text()
        self.assertLess(html.index('id="playable"'), html.index('id="bars"'))
        self.assertIn('aria-labelledby="playableTitle"', html)
        self.assertIn('$("nextBlocker").textContent=P.next_blocker', html)
        report = (self.out / "REPORT.md").read_text()
        self.assertLess(report.index("## Playable build"), report.index("## x86 matching"))
        self.assertIn("S5906 → S4700", report)
        self.assertIn("provider action-kernel", report)
        self.assertIn("961 discovered; 956 passed; 5 skipped", report)

    def test_audited_code_is_added_to_the_legacy_status_baseline(self):
        t = self.model["totals"]
        self.assertTrue(self.audited_vas)
        self.assertEqual(len(self.legacy_bytes), 398)
        self.assertEqual(t["matched_code"], len(self.legacy_bytes | self.audited_bytes))
        self.assertEqual(t["matched_data"], 0)
        self.assertTrue(self.model["evidence"]["crosscheck"]["agrees"])
        self.assertEqual(self.model["evidence"]["crosscheck"]["computed_legacy_matched_code"], 398)
        self.assertEqual(t["functions_complete"], len(self.audited_vas))

    def test_provenance_classes_stay_separate(self):
        bp = self.model["totals"]["by_provenance"]
        self.assertEqual(bp, {"exact_range_compiled_c_partial": 14,
                              "explicit_reconstructed_assembly_source": 384,
                              "tool_assisted_reconstructed_assembly": len(self.audited_bytes - self.legacy_bytes)})
        self.assertEqual(self.model["totals"]["functions_by_provenance"], {
            "exact_range_compiled_c_partial": 0,
            "explicit_reconstructed_assembly_source": 11,
            "tool_assisted_reconstructed_assembly": len(self.audited_vas)})
        self.assertEqual(sum(bp.values()), self.model["totals"]["matched_code"])
        self.assertIn("exact_range_compiled_c_partial", (self.out / "REPORT.md").read_text())

    def test_committed_x86_outputs_have_not_drifted(self):
        committed = json.loads((HERE / "progress.json").read_text())
        for key in ("totals", "groups", "units", "matched_ranges"):
            self.assertEqual(self.model[key], committed[key], "Refresh progress after new audited batches")
        report = (self.out / "REPORT.md").read_text()
        self.assertIn("tool_assisted_reconstructed_assembly", report)
        self.assertIn("Complete function claims", report)

    def test_cpp_candidate_manifest_is_not_counted(self):
        roles = {s["path"]: s["role"] for s in self.model["evidence"]["sources"]}
        self.assertEqual(roles["matches_s08_2.json"], "excluded")
        self.assertEqual(roles["matches_s08.json"], "excluded")
        self.assertEqual(roles["matches_s08_4_x86.json"], "counted")

    def test_bands_stay_inside_their_region(self):
        layout = json.loads((HERE / "layout.json").read_text())
        regions = {r["id"]: r for r in layout["code_regions"]}
        for u in self.model["units"]:
            if u["kind"] != "code":
                continue
            r = regions[u["group"]]
            for va, size, *_ in u["functions"]:
                self.assertGreaterEqual(va, r["start_va"])
                self.assertLessEqual(va + size, r["end_va"])
        self.assertEqual(sum(u.get("function_count", 0) for u in self.model["units"]), 4188)

    def test_progress_json_is_compact_and_round_trips(self):
        text = (self.out / "progress.json").read_text()
        self.assertLess(text.count("\n"), 400)
        self.assertEqual(json.loads(text), self.model)

    def test_html_is_offline_and_embeds_the_model(self):
        html = (self.out / "index.html").read_text()
        self.assertNotIn("__DATA__", html)
        self.assertNotRegex(html, r"https?://(?!www\.w3\.org/2000/svg)")
        self.assertNotRegex(html, r"\b(fetch|XMLHttpRequest|WebSocket)\(")
        blob = re.search(r'id="data">(.*?)</script>', html, re.S).group(1)
        self.assertEqual(json.loads(blob)["totals"], self.model["totals"])

    def test_outputs_carry_no_bytes_only_summaries(self):
        # The model holds addresses and sizes; no field is a byte string.
        text = json.dumps(self.model)
        self.assertNotRegex(text, r'"(bytes|data_hex|payload)"')

    def test_ledger_mode_reproduces_baseline_and_counts_structured_data(self):
        layout = GEN.load_layout(HERE / "layout.json")
        index = GEN.load_json(EVIDENCE / "function-index.json")
        _, atoms = GEN.build_atoms(layout, index, 16384)
        rows, _ = GEN.baseline_evidence(layout, EVIDENCE)
        hit = GEN.merge_intervals([(s, e) for s, e, *_ in rows])
        ranges = []
        for a in atoms:
            lo, hi = a["off"], a["off"] + a["size"]
            if a["kind"] == "data":
                ranges.append({"offset": lo, "size": a["size"], "kind": "data",
                               "class": "structured" if a["unit"] == "headers" else "referenced",
                               **({"provenance": "image_structure"} if a["unit"] == "headers" else {})})
                continue
            pos = lo
            for s, e in hit:
                s, e = max(s, lo), min(e, hi)
                if s >= e:
                    continue
                if s > pos:
                    ranges.append({"offset": pos, "size": s - pos, "kind": "code", "class": "referenced"})
                ranges.append({"offset": s, "size": e - s, "kind": "code", "class": "reconstructed",
                               "provenance": "explicit_reconstructed_assembly_source"})
                pos = e
            if pos < hi:
                ranges.append({"offset": pos, "size": hi - pos, "kind": "code", "class": "referenced"})
        uniq = ranges
        with tempfile.TemporaryDirectory() as d:
            led = pathlib.Path(d) / "ledger.json"
            led.write_text(json.dumps({"schema": GEN.LEDGER_SCHEMA, "original_sha256": SHA,
                                       "file_size": 1511424, "ranges": uniq}))
            out = pathlib.Path(d) / "out"
            self.assertEqual(GEN.main(["--out-dir", str(out), "--ledger", str(led)]), 0)
            m = json.loads((out / "progress.json").read_text())
        self.assertEqual(m["totals"]["matched_code"], self.model["totals"]["matched_code"])
        self.assertEqual(m["totals"]["matched_data"], 4096)
        self.assertEqual(m["totals"]["code"], 1213018)

    def test_report_notes_follow_the_mode(self):
        text = (self.out / "REPORT.md").read_text()
        self.assertIn("tables and padding are excluded", text)
        mini = MiniFixtureReport()
        self.assertNotIn("tables and padding are excluded", mini)

    def test_cross_provenance_overlap_is_rejected(self):
        layout = GEN.load_layout(HERE / "layout.json")
        index = GEN.load_json(EVIDENCE / "function-index.json")
        rows, meta = GEN.baseline_evidence(layout, EVIDENCE)
        a, b, _ = meta["provenance_ranges"][0]
        meta["provenance_ranges"] = meta["provenance_ranges"] + [(a, a + 1, "other_class")]
        with self.assertRaisesRegex(GEN.ProgressError, "provenance classes overlap"):
            GEN.build_model(layout, index, rows, meta, 16384, None, [])

    def test_bind_checks_row_identity(self):
        with tempfile.TemporaryDirectory() as d:
            d = pathlib.Path(d)
            (d / "src").mkdir()
            (d / "build").mkdir()
            (d / "src" / "a.s").write_text("source")
            (d / "build" / "a.obj").write_text("object")
            status = {"matching_s08_2": {"source_sha256": hashlib_sha("source"),
                                         "object_sha256": hashlib_sha("object"),
                                         "complete_functions": 1, "exact_bytes": 1}}
            def man(rva, symbol):
                write(d / "matches_s08_2_x86.json", {"source": "src/a.s", "functions": [
                    {"rva": rva, "size": 1, "object": "build/a.obj", "symbol": symbol}]})
            man(4096, "_FUN_00401000")
            self.assertTrue(GEN.bind_reviewed_artifacts(
                ["matches_s08_2_x86.json"], d, d, status, {0x401000})["matches_s08_2_x86.json"]["bound_to_reviewed_hashes"])
            man(4100, "_FUN_00401000")  # edited RVA, stale symbol
            with self.assertRaisesRegex(GEN.ProgressError, "does not match its RVA"):
                GEN.bind_reviewed_artifacts(["matches_s08_2_x86.json"], d, d, status, {0x401000})
            man(4100, "_FUN_00401004")  # consistent but not a function start
            with self.assertRaisesRegex(GEN.ProgressError, "not an indexed function start"):
                GEN.bind_reviewed_artifacts(["matches_s08_2_x86.json"], d, d, status, {0x401000})

    def test_verify_manifests_gates_on_the_verifier(self):
        with tempfile.TemporaryDirectory() as d:
            d = pathlib.Path(d)
            fake = d / "fake_verify.py"
            fake.write_text(
                "import json,sys\n"
                "m=sys.argv[2]\nrep=sys.argv[sys.argv.index('--report')+1]\n"
                "ok='bad' not in m\n"
                "json.dump({'all_byte_ranges_exact':ok,'exact_byte_range_bytes':1},open(rep,'w'))\n"
                "sys.exit(0 if ok else 1)\n")
            orig = d / "GAME.EXE"
            orig.write_bytes(b"x")
            (d / "good.json").write_text("{}")
            (d / "bad.json").write_text("{}")
            with self.assertRaisesRegex(GEN.ProgressError, "pinned"):
                GEN.verify_manifests(["good.json"], d, orig, fake)
            # relative inputs resolve against the caller, not the verifier's cwd
            import os
            here = os.getcwd()
            os.chdir(d)
            try:
                with self.assertRaisesRegex(GEN.ProgressError, "pinned"):
                    GEN.verify_manifests(["good.json"], pathlib.Path("."), pathlib.Path("GAME.EXE"), fake)
            finally:
                os.chdir(here)
            real_sha = GEN.PINNED_SHA
            GEN.PINNED_SHA = GEN.sha256_file(orig)
            try:
                res = GEN.verify_manifests(["good.json"], d, orig, fake)
                self.assertTrue(res["manifests"]["good.json"]["exact"])
                os.chdir(d)
                try:
                    rel = GEN.verify_manifests(["good.json"], pathlib.Path("."),
                                               pathlib.Path("GAME.EXE"), fake)
                finally:
                    os.chdir(here)
                self.assertTrue(rel["manifests"]["good.json"]["exact"])
                with self.assertRaisesRegex(GEN.ProgressError, "did not confirm"):
                    GEN.verify_manifests(["good.json", "bad.json"], d, orig, fake)
            finally:
                GEN.PINNED_SHA = real_sha

    def test_bind_reviewed_artifacts_rejects_changed_source_or_object(self):
        with tempfile.TemporaryDirectory() as d:
            d = pathlib.Path(d)
            (d / "src").mkdir()
            (d / "build").mkdir()
            (d / "src" / "a.s").write_text("source")
            (d / "build" / "a.obj").write_text("object")
            write(d / "matches_s08_2_x86.json", {"source": "src/a.s", "functions": [
                {"rva": 4096, "size": 1, "object": "build/a.obj", "symbol": "_FUN_00401000"}]})
            status = {"matching_s08_2": {"source_sha256": hashlib_sha("source"),
                                         "object_sha256": hashlib_sha("object"),
                                         "complete_functions": 1, "exact_bytes": 1}}
            ok = GEN.bind_reviewed_artifacts(["matches_s08_2_x86.json"], d, d, status)
            self.assertTrue(ok["matches_s08_2_x86.json"]["bound_to_reviewed_hashes"])
            write(d / "matches_s08_2_x86.json", {"source": "src/a.s", "functions": [
                {"rva": 4096, "size": 1, "object": "build/a.obj"},
                {"rva": 4200, "size": 1, "object": "build/a.obj"}]})
            with self.assertRaisesRegex(GEN.ProgressError, "status.json records"):
                GEN.bind_reviewed_artifacts(["matches_s08_2_x86.json"], d, d, status)
            write(d / "matches_s08_2_x86.json", {"source": "src/a.s", "functions": [
                {"rva": 4096, "size": 1, "object": "build/a.obj", "symbol": "_FUN_00401000"}]})
            (d / "src" / "a.s").write_text("edited")
            with self.assertRaisesRegex(GEN.ProgressError, "reviewed source hash"):
                GEN.bind_reviewed_artifacts(["matches_s08_2_x86.json"], d, d, status)
            (d / "src" / "a.s").write_text("source")
            (d / "build" / "a.obj").write_text("swapped")
            with self.assertRaisesRegex(GEN.ProgressError, "reviewed object hash"):
                GEN.bind_reviewed_artifacts(["matches_s08_2_x86.json"], d, d, status)
            with self.assertRaisesRegex(GEN.ProgressError, "no reviewed hash record"):
                GEN.bind_reviewed_artifacts(["matches_s08_2_x86.json"], d, d, None)
            with self.assertRaisesRegex(GEN.ProgressError, "no reviewed hash record"):
                GEN.bind_reviewed_artifacts(["matches_s08_2_x86.json"], d, d, {})
            write(d / "matches.json", {"source": "src/a.s", "functions": [
                {"rva": 4096, "size": 1, "object": "build/a.obj"}]})
            unbound = GEN.bind_reviewed_artifacts(["matches.json"], d, d, status)
            self.assertFalse(unbound["matches.json"]["bound_to_reviewed_hashes"])

    def test_report_wording_follows_the_verification_state(self):
        base = {"mode": "baseline", "verification": {"run": True}}
        self.assertIn("confirmed byte-exact in this run", GEN.matched_meaning({"evidence": base}))
        base["verification"] = {"run": False}
        self.assertIn("not re-verified", GEN.matched_meaning({"evidence": base}))
        led = {"mode": "ledger", "verification": {"run": False}}
        self.assertIn("declared only", GEN.matched_meaning({"evidence": led}))
        led["verification"] = {"run": True, "kind": "composed image hash"}
        self.assertIn("image hash was checked", GEN.matched_meaning({"evidence": led}))
        self.assertNotIn("byte-exact against", GEN.matched_meaning({"evidence": {"mode": "ledger", "verification": {"run": False}}}))

    def test_table_view_honours_the_matched_only_filter(self):
        html = (HERE / "template.html").read_text()
        self.assertIn("D.units.filter(u=>!state.only || matchedOf(u)>0)", html)
        self.assertIn("else renderTable();", html)


def MiniFixtureReport():
    """Report text for a ledger-mode model with matched data."""
    case = MiniFixture("test_ledger_splits_matched_code_and_data")
    case.setUp()
    try:
        m = case.model_for(case.full_ranges())
        out = case.dir / "REPORT.md"
        GEN.write_report(m, out)
        return out.read_text()
    finally:
        case.tearDown()


class MiniFixture(unittest.TestCase):
    """A 0x200-byte image: 0x100 headers, two functions, 0xc0 trailing data."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.dir = pathlib.Path(self.tmp.name)
        self.layout = {
            "schema": "blackmoor-image-layout/1", "original_sha256": SHA,
            "file_size": 0x200, "image_base": 0x400000,
            "sections": [{"name": ".text", "rva": 0x100, "raw_off": 0x100,
                          "raw_size": 0x100, "virt_size": 0x40}],
            "code_regions": [{"id": "game", "label": "Game", "start_va": 0x400100, "end_va": 0x400140}],
            "data_pieces": [
                {"id": "headers", "group": "headers", "label": "Headers", "file_off": 0, "size": 0x100},
                {"id": "tail", "group": "data", "label": "Tail", "file_off": 0x140, "size": 0xc0}],
            "data_groups": [{"id": "headers", "label": "Headers"}, {"id": "data", "label": "Data"}],
        }
        self.index = {"original_sha256": SHA, "functions": [
            {"address": "0x400100"}, {"address": "0x400120"}]}
        self.layout_path = self.dir / "layout.json"
        write(self.layout_path, self.layout)

    def tearDown(self):
        self.tmp.cleanup()

    def ledger(self, ranges, **over):
        led = {"schema": GEN.LEDGER_SCHEMA, "original_sha256": SHA, "file_size": 0x200, "ranges": ranges}
        led.update(over)
        p = self.dir / "ledger.json"
        write(p, led)
        return p

    def full_ranges(self):
        return [
            {"offset": 0, "size": 0x100, "kind": "data", "class": "structured", "provenance": "image_structure"},
            {"offset": 0x100, "size": 0x20, "kind": "code", "class": "reconstructed", "provenance": "explicit_reconstructed_assembly_source"},
            {"offset": 0x120, "size": 0x20, "kind": "code", "class": "referenced"},
            {"offset": 0x140, "size": 0xc0, "kind": "data", "class": "referenced"},
        ]

    def model_for(self, ranges, allow_partial=False):
        rows, meta = GEN.ledger_evidence(self.layout, self.ledger(ranges), allow_partial)
        return GEN.build_model(self.layout, self.index, rows, meta, 0x4000, None, [])

    def test_ledger_splits_matched_code_and_data(self):
        m = self.model_for(self.full_ranges())
        t = m["totals"]
        self.assertEqual((t["code"], t["data"]), (0x40, 0x1c0))
        self.assertEqual((t["matched_code"], t["matched_data"]), (0x20, 0x100))
        self.assertEqual(t["functions_complete"], 1)

    def test_ledger_provenance_is_kept_and_validated(self):
        r = self.full_ranges()
        r[1]["provenance"] = "tool_assisted_reconstructed_assembly"
        r[0]["provenance"] = "image_structure"
        bp = self.model_for(r)["totals"]["by_provenance"]
        self.assertEqual(bp, {"image_structure": 0x100, "tool_assisted_reconstructed_assembly": 0x20})
        r[1]["provenance"] = "Not Valid!"
        with self.assertRaisesRegex(GEN.ProgressError, "provenance"):
            self.model_for(r)
        r = self.full_ranges()
        del r[1]["provenance"]
        with self.assertRaisesRegex(GEN.ProgressError, "needs a provenance"):
            self.model_for(r)

    def test_referenced_is_never_matched(self):
        r = self.full_ranges()
        r[1]["class"] = "referenced"
        r[0]["class"] = "referenced"
        t = self.model_for(r)["totals"]
        self.assertEqual((t["matched_code"], t["matched_data"]), (0, 0))

    def test_structured_data_inside_code_counts_as_data(self):
        r = self.full_ranges()
        r[1:3] = [
            {"offset": 0x100, "size": 0x30, "kind": "code", "class": "reconstructed", "provenance": "explicit_reconstructed_assembly_source"},
            {"offset": 0x130, "size": 0x10, "kind": "data", "class": "structured", "provenance": "image_structure"},
        ]
        t = self.model_for(r)["totals"]
        self.assertEqual((t["code"], t["matched_code"], t["matched_data"]), (0x30, 0x30, 0x110))
        units = {u["id"]: u for u in self.model_for(r)["units"]}
        self.assertEqual(units["game-400100"]["functions"], [[0x400100, 0x20, 0x20, 0], [0x400120, 0x20, 0x10, 0x10]])

    def test_rejections(self):
        base = self.full_ranges()
        with self.assertRaisesRegex(GEN.ProgressError, "overlap"):
            self.model_for(base + [{"offset": 0x110, "size": 4, "kind": "code", "class": "referenced"}])
        with self.assertRaisesRegex(GEN.ProgressError, "every byte"):
            self.model_for(base[:3])
        self.assertIsNotNone(self.model_for(base[:3], allow_partial=True))
        with self.assertRaisesRegex(GEN.ProgressError, "missing"):
            self.model_for(base[:3] + [{"offset": 0x140, "size": 0xc0, "kind": "data", "class": "missing"}])
        with self.assertRaisesRegex(GEN.ProgressError, "bad ledger"):
            self.model_for([dict(base[0], **{"class": "guessed"})] + base[1:])
        with self.assertRaisesRegex(GEN.ProgressError, "out of bounds"):
            self.model_for(base[:3] + [{"offset": 0x140, "size": 0xc1, "kind": "data", "class": "referenced"}])
        with self.assertRaisesRegex(GEN.ProgressError, "pinned"):
            GEN.ledger_evidence(self.layout, self.ledger(base, original_sha256="0" * 64), False)

    def test_partial_ledger_keeps_full_file_denominator(self):
        m = self.model_for([{"offset": 0, "size": 0x100, "kind": "data", "class": "structured",
                            "provenance": "image_structure"}], allow_partial=True)
        t = m["totals"]
        self.assertEqual(t["file_bytes"], 0x200)
        self.assertEqual(t["classified"], 0x100)
        self.assertEqual(t["unclassified"], 0x100)
        self.assertEqual(t["matched_data"], 0x100)
        # every unit keeps its extent, so uncovered bytes still occupy tiles
        self.assertEqual(sum(u["size"] for u in m["units"]), 0x200)
        tail = next(u for u in m["units"] if u["id"] == "tail")
        self.assertEqual((tail["size"], tail["unclassified"], tail["matched_data"]), (0xc0, 0xc0, 0))

    def test_verify_image_requires_the_pinned_hash(self):
        led = self.ledger(self.full_ranges())
        img = self.dir / "image.exe"
        img.write_bytes(b"not the game")
        lay = self.layout_path
        idx = self.dir / "function-index.json"
        write(idx, self.index)
        base = ["--layout", str(lay), "--evidence-dir", str(self.dir), "--ledger", str(led),
                "--out-dir", str(self.dir / "out")]
        self.assertEqual(GEN.main(base + ["--verify-image", str(img)]), 2)
        self.assertEqual(GEN.main(["--layout", str(lay), "--evidence-dir", str(self.dir),
                                   "--verify-image", str(img)]), 2)
        self.assertEqual(GEN.main(base), 0)
        out = json.loads((self.dir / "out" / "progress.json").read_text())
        self.assertFalse(out["evidence"]["verification"]["run"])
        real = GEN.PINNED_SHA
        GEN.PINNED_SHA = GEN.sha256_file(img)
        try:
            self.assertEqual(GEN.main(base + ["--verify-image", str(img)]), 0)
        finally:
            GEN.PINNED_SHA = real
        out = json.loads((self.dir / "out" / "progress.json").read_text())
        self.assertTrue(out["evidence"]["verification"]["run"])

    def test_layout_gap_is_rejected(self):
        self.layout["data_pieces"][1]["size"] = 0xb0
        with self.assertRaisesRegex(GEN.ProgressError, "gap|covers"):
            GEN.build_atoms(self.layout, self.index, 0x4000)

    def test_function_crossing_region_seam_is_rejected(self):
        self.layout["code_regions"] = [
            {"id": "a", "label": "A", "start_va": 0x400100, "end_va": 0x400110},
            {"id": "b", "label": "B", "start_va": 0x400110, "end_va": 0x400140}]
        with self.assertRaisesRegex(GEN.ProgressError, "crosses"):
            GEN.build_atoms(self.layout, self.index, 0x4000)


class AuditedBatchTests(unittest.TestCase):
    """Small file-backed claims catch inflation, stale audits and span/code confusion."""

    def setUp(self):
        MiniFixture.setUp(self)
        self.asm = self.dir / "asm"
        self.asm.mkdir()
        for name in GEN.COUNTED_MANIFESTS:
            functions = []
            if name == "matches_s08_2_x86.json":
                functions = [{"rva": 0x100, "size": 0x20, "symbol": "_FUN_00400100"}]
            elif name == "matches.json":
                functions = [{"rva": 0x128, "size": 4, "symbol": "_FUN_00400128"}]
            write(self.dir / name, {"original_sha256": SHA, "functions": functions})
        self.create_batch("001", [(0x400100, 0x20), (0x400120, 0x18)])

    tearDown = MiniFixture.tearDown

    def create_batch(self, batch, extents):
        functions, audited = [], []
        for va, size in extents:
            symbol = f"FUN_{va:08x}"
            source = symbol + ".s"
            path = self.asm / source
            path.write_text("# synthetic annotated-source fixture\n")
            source_sha = GEN.sha256_file(path)
            code = {"symbol": symbol, "rva": va - 0x400000, "size": size,
                    "sha256": hashlib_sha(symbol)}
            data = ([{"kind": "padding", "rva": 0x138, "size": 8,
                      "symbol": "PAD_00400138", "sha256": hashlib_sha("padding")}]
                    if va == 0x400120 else [])
            functions.append({"function": symbol, "va": f"0x{va:08x}", "source": source,
                              "source_sha256": source_sha, "region": "game",
                              "evidence_id": "fixture", "code": code, "data_items": data})
            audited.append({"function": symbol, "va": va, "region": "game", "code": code,
                            "data_items": data, "status": "accepted", "reasons": [],
                            "relocations": 0, "compared_bytes": size + sum(d["size"] for d in data),
                            "contains_original_byte_values": False, "basic_blocks": 1,
                            "source": {"path": source, "sha256": source_sha},
                            "object": {"sha256": hashlib_sha("object"), "size": size}})
        manifest = self.asm / f"batch-{batch}.json"
        write(manifest, {"batch": batch, "class": "tool_assisted_reconstructed_assembly",
                         "original_sha256": SHA, "functions": functions})
        write(self.asm / f"batch-{batch}-report.json", {
            "batch": batch, "class_requested": "tool_assisted_reconstructed_assembly",
            "original_sha256": SHA, "manifest_sha256": GEN.sha256_file(manifest),
            "all_accepted": True, "errors": [], "accepted_count": len(audited),
            "code_bytes_accepted": sum(f["code"]["size"] for f in audited),
            "contains_original_byte_values": False, "functions": audited,
            "assembler": {"version_line": "GNU assembler (GNU Binutils) 2.43.1",
                          "sha256": "459ab053b16d25841cf302ece6f5ddd65ebd0f33a91fbbb6c6a665b74de0565b"}})

    def model(self):
        rows, meta = GEN.baseline_evidence(self.layout, self.dir)
        return GEN.build_model(self.layout, self.index, rows, meta, 0x4000,
                               {"unique_matched_bytes": 36}, [])

    def mutate_report(self, change):
        path = self.asm / "batch-001-report.json"
        report = GEN.load_json(path)
        change(report)
        write(path, report)

    def test_overlap_priority_and_code_only_function_completeness(self):
        model = self.model()
        t = model["totals"]
        # 32 explicit + 24 audited, with a 4-byte C range inside the latter.
        self.assertEqual((t["matched_code"], t["matched_data"]), (56, 0))
        self.assertEqual(t["by_provenance"], {
            "exact_range_compiled_c_partial": 4,
            "explicit_reconstructed_assembly_source": 32,
            "tool_assisted_reconstructed_assembly": 20})
        self.assertEqual(t["functions_complete"], 2)
        self.assertEqual(t["functions_by_provenance"], {
            "exact_range_compiled_c_partial": 0,
            "explicit_reconstructed_assembly_source": 1,
            "tool_assisted_reconstructed_assembly": 2})
        self.assertTrue(model["evidence"]["crosscheck"]["agrees"])
        second = next(r for r in model["matched_ranges"] if r["va"] == 0x400120)
        self.assertEqual(second["size"], 24)
        self.assertTrue(second["complete_function"])
        unit = next(u for u in model["units"] if u["kind"] == "code")
        self.assertEqual(unit["functions_complete"], 2)
        self.assertEqual(unit["functions"][1], [0x400120, 32, 24, 0])

    def test_new_batches_are_discovered_and_repeated_claims_are_deduplicated(self):
        self.create_batch("002", [(0x400120, 0x18)])
        model = self.model()
        self.assertEqual(model["totals"]["matched_code"], 56)
        self.assertEqual(model["totals"]["functions_complete"], 2)
        self.assertEqual(model["totals"]["functions_by_provenance"]["tool_assisted_reconstructed_assembly"], 2)
        self.assertEqual(len(model["evidence"]["tool_assisted_batches"]), 2)

    def test_contradictory_code_extents_are_rejected(self):
        self.create_batch("002", [(0x400120, 0x19)])
        with self.assertRaisesRegex(GEN.ProgressError, "conflicting audited"):
            self.model()

    def test_changed_source_is_not_counted(self):
        (self.asm / "FUN_00400120.s").write_text("# edited after audit\n")
        with self.assertRaisesRegex(GEN.ProgressError, "source hash"):
            self.model()

    def test_missing_audit_is_not_counted(self):
        (self.asm / "batch-001-report.json").unlink()
        with self.assertRaises(GEN.ProgressError):
            self.model()

    def test_changed_manifest_is_not_counted(self):
        path = self.asm / "batch-001.json"
        manifest = GEN.load_json(path)
        manifest["functions"][1]["code"]["size"] += 1
        write(path, manifest)
        with self.assertRaisesRegex(GEN.ProgressError, "manifest hash"):
            self.model()

    def test_incomplete_or_unpinned_audit_is_rejected(self):
        changes = [
            lambda r: r.update(all_accepted=False),
            lambda r: r.update(errors=["failed audit"]),
            lambda r: r.update(original_sha256="0" * 64),
            lambda r: r.update(accepted_count=1),
            lambda r: r.update(code_bytes_accepted=55),
            lambda r: r["assembler"].update(version_line="Apple assembler"),
            lambda r: r["assembler"].update(sha256="0" * 64),
            lambda r: r["functions"][1].update(status="rejected"),
            lambda r: r["functions"][1].update(relocations=1),
            lambda r: r["functions"][1].update(compared_bytes=23),
            lambda r: r["functions"][1]["code"].update(size=25),
            lambda r: r["functions"][1]["source"].update(sha256="0" * 64),
            lambda r: r["functions"].pop(),
        ]
        original = (self.asm / "batch-001-report.json").read_text()
        for change in changes:
            with self.subTest(change=change):
                (self.asm / "batch-001-report.json").write_text(original)
                self.mutate_report(change)
                with self.assertRaises(GEN.ProgressError):
                    self.model()

    def test_audited_claim_cannot_cross_an_indexed_function_boundary(self):
        self.create_batch("001", [(0x400100, 0x21)])
        with self.assertRaisesRegex(GEN.ProgressError, "indexed function span"):
            self.model()

    def test_incomplete_audited_span_is_a_partial_claim(self):
        # Keep manifest/report hashes and comparison totals internally valid;
        # the counterexample is the missing (or excessive) data in the span.
        manifest_path = self.asm / "batch-001.json"
        report_path = self.asm / "batch-001-report.json"
        original_manifest = GEN.load_json(manifest_path)
        original_report = GEN.load_json(report_path)
        import copy
        for data_size in (0, 7, 9):
            with self.subTest(data_size=data_size):
                manifest, report = copy.deepcopy(original_manifest), copy.deepcopy(original_report)
                data = manifest["functions"][1]["data_items"]
                if data_size:
                    data[0]["size"] = data_size
                else:
                    data.clear()
                report["functions"][1]["data_items"] = copy.deepcopy(data)
                report["functions"][1]["compared_bytes"] = 24 + data_size
                write(manifest_path, manifest)
                report["manifest_sha256"] = GEN.sha256_file(manifest_path)
                write(report_path, report)
                model = self.model()
                self.assertEqual(model["totals"]["matched_code"], 56)
                self.assertEqual(model["totals"]["functions_complete"], 1)
                self.assertEqual(model["totals"]["functions_by_provenance"][GEN.TOOL_ASSISTED], 1)
                row = next(r for r in model["matched_ranges"] if r["va"] == 0x400120)
                self.assertFalse(row["complete_function"])


class RegistrationDriftTests(unittest.TestCase):
    """Source mutations exercise the independent registration cross-checks."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.out = pathlib.Path(self.tmp.name)
        shutil.copytree(EVIDENCE / "src", self.out / "src")
        shutil.copy2(EVIDENCE / "action-census-current.json", self.out)
        shutil.copy2(EVIDENCE / "playable-status.json", self.out)
        self.status = GEN.load_json(EVIDENCE / "status.json")
        self.original = GEN.PLAYABLE.derive_actions(self.out)

    def tearDown(self):
        self.tmp.cleanup()

    def change(self, path, old, new):
        p = self.out / path
        text = p.read_text()
        self.assertIn(old, text)
        p.write_text(text.replace(old, new, 1))

    def test_missing_live_registration_fails_closed(self):
        self.change("src/blackmoor_app.mm", "bindings[2].type = SESSION_A51_TYPE;", "")
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "binding count drifted"):
            GEN.PLAYABLE.derive_actions(self.out)

    def test_uninstalled_live_array_fails_closed(self):
        self.change("src/blackmoor_app.mm", "config.action_bindings = bindings;", "config.action_bindings = nullptr;")
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "binding count drifted"):
            GEN.PLAYABLE.derive_actions(self.out)

    def test_core_registration_disagreement_fails_closed(self):
        self.change("src/action_core.c", "return type == ACTION_TYPE_SET_VALUE ||", "return")
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "action_core registrations drifted"):
            GEN.PLAYABLE.derive_actions(self.out)

    def test_missing_ui_present_slot_fails_closed(self):
        self.change("src/scene_session.c", "session->bindings[ACTION_TYPE_PHONE].present = 1u;", "")
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "present slots drifted"):
            GEN.PLAYABLE.derive_actions(self.out)

    def test_changed_external_type_changes_report(self):
        self.change("src/blackmoor_app.mm", "bindings[2].type = SESSION_A51_TYPE;", "bindings[2].type = 0x37;")
        changed = GEN.PLAYABLE.derive_actions(self.out)
        self.assertIn("0x37", changed["handled"]["types"])
        self.assertNotIn("0x51", changed["handled"]["types"])
        self.assertNotEqual(changed, self.original)

    def test_new_parser_layout_moves_opaque_records_to_typed(self):
        self.change("src/scene_resource.c", "default:\n        return 0;",
                    "case 0x45: fixed_length = 1u; break;\n    default:\n        return 0;")
        changed = GEN.PLAYABLE.derive_actions(self.out)
        self.assertEqual(changed["typed"]["records"], self.original["typed"]["records"] + 32)
        self.assertIn("0x45", changed["unsupported"]["types"])
        self.assertNotEqual(changed, self.original)

    def test_stale_committed_test_totals_are_rejected(self):
        shutil.copy2(EVIDENCE / "playable-status.json", self.out)
        status = json.loads((EVIDENCE / "status.json").read_text())
        status["current_integration"]["full_suite"]["passed"] -= 1
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "test totals drifted"):
            GEN.PLAYABLE.build_panel(self.out, status)

    def test_handled_stop_is_rejected_even_with_current_source_hashes(self):
        path = self.out / "playable-status.json"
        doc = GEN.load_json(path)
        doc["stop"]["action_type"] = "0x51"
        write(path, doc)
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "stop action.*handled"):
            GEN.PLAYABLE.build_panel(self.out, self.status)

    def test_every_registration_input_hash_is_bound_to_recorded_evidence(self):
        for source in self.original["sources"]:
            path = self.out / source["path"]
            original = path.read_bytes()
            with self.subTest(path=source["path"]):
                # Whitespace leaves registration/census meaning intact.
                path.write_bytes(original + b"\n")
                try:
                    with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError,
                                                "evidence stale; rerun record_playable_status.py"):
                        GEN.PLAYABLE.build_panel(self.out, self.status)
                finally:
                    path.write_bytes(original)

    def test_new_handler_cannot_reuse_old_stop_evidence(self):
        self.change("src/blackmoor_app.mm", "bindings[2].type = SESSION_A51_TYPE;", "bindings[2].type = 0x35;")
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError,
                                    "evidence stale; rerun record_playable_status.py"):
            GEN.PLAYABLE.build_panel(self.out, self.status)

    def test_preprocessor_conditionals_in_registration_functions_fail_closed(self):
        path = self.out / "src/blackmoor_app.mm"
        original = path.read_text()
        registration = "bindings[2].type = SESSION_A51_TYPE;"
        blocks = ["#if 0\n{}\n#endif", "#ifdef CONDITIONAL\n{}\n#endif",
                  "#ifndef CONDITIONAL\n{}\n#endif", "#if 0\n#elif 1\n{}\n#endif",
                  "#if 0\n#else\n{}\n#endif", "#elif 1\n{}", "#else\n{}"]
        for block in blocks:
            with self.subTest(block=block):
                path.write_text(original.replace(registration, block.format(registration), 1))
                with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "preprocessor conditional"):
                    GEN.PLAYABLE.derive_actions(self.out)

    def test_conditional_registrations_fail_closed(self):
        cases = [
            ("src/blackmoor_app.mm", "bindings[2].type = SESSION_A51_TYPE;"),
            ("src/blackmoor_app.mm", "bindings[2].callback = session_a51_handler;"),
            ("src/blackmoor_app.mm", "bindings[0] = action_sound_binding;"),
            ("src/blackmoor_app.mm", "config.action_bindings = bindings;"),
            ("src/blackmoor_app.mm", "config.action_binding_count = 4u;"),
            ("src/scene_session.c", "session->bindings[ACTION_TYPE_PHONE].present = 1u;"),
            ("src/scene_session.c", "session->bindings[ACTION_TYPE_PHONE].callback = ui_action_handler;"),
        ]
        for file, registration in cases:
            path = self.out / file
            original = path.read_text()
            for block in ("if (cond) {{ {} }}", "if (cond) {}", "if (cond) {{ if (other) {{ {} }} }}"):
                with self.subTest(file=file, registration=registration, block=block):
                    path.write_text(original.replace(registration, block.format(registration), 1))
                    try:
                        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "conditional registration"):
                            GEN.PLAYABLE.derive_actions(self.out)
                    finally:
                        path.write_text(original)

    def test_conditional_parser_registration_fails_closed(self):
        self.change("src/scene_resource.c", "switch (type) {", "if (cond) { switch (type) {")
        self.change("src/scene_resource.c", "default:\n        return 0;", "default:\n        return 0; }")
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "conditional registration"):
            GEN.PLAYABLE.derive_actions(self.out)

    def test_conditional_builtin_dispatch_registration_fails_closed(self):
        self.change("src/scene_executor.c", "if (action.type == SCENE_ACTION_CLOCK) {",
                    "if (cond) { if (action.type == SCENE_ACTION_CLOCK) {")
        self.change("src/scene_executor.c", "if (is_action_core_type(action.type)) {",
                    "} if (is_action_core_type(action.type)) {")
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "conditional registration"):
            GEN.PLAYABLE.derive_actions(self.out)


if __name__ == "__main__":
    unittest.main()
