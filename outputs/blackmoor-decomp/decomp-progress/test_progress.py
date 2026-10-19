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
        # audited data sources (asm_data/data-NNN.json): initialized data and resource payloads
        cls.data_bytes = set()
        for path in sorted((EVIDENCE / "asm_data").glob("data-[0-9][0-9][0-9].json")):
            for r in json.loads(path.read_text())["ranges"]:
                off = int(r["offset"], 16)
                cls.data_bytes.update(range(off, off + r["length"]))

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
        recorded = json.loads((EVIDENCE / "playable-status.json").read_text())
        self.assertEqual(p["reached_scenes"], recorded["reached_scenes"])
        self.assertEqual(p["reached_scenes"][:10], ["S0", "S5900", "S5907", *[f"S{i}" for i in range(5901, 5907)], "S4700"])
        self.assertEqual(p["stop"], recorded["stop"])
        # RT-20: raw 0x0c has a runtime, so the scripted run ends at the tick limit in S2010.
        self.assertEqual(p["stop"]["kind"], "tick_limit")
        self.assertEqual(p["stop"]["scene"], "S2010")
        self.assertIsNone(p["stop"]["action_type"])
        self.assertEqual(p["tests"], {"discovered": 1269, "passed": 1264, "skipped": 5,
                                     "source_field": "current_integration.full_suite"})

    def test_action_body_counts_use_current_source_and_census_records(self):
        a = self.model["playable"]["action_types"]
        self.assertEqual(a["typed"]["records"], 19611)
        self.assertEqual(a["opaque"]["records"], 1)
        self.assertEqual(a["record_total"], 19612)
        self.assertEqual(a["typed"]["type_count"] + a["opaque"]["type_count"], a["type_total"])
        self.assertEqual(set(a["handled"]["types"]) | set(a["unsupported"]["types"]), set(a["typed"]["types"]))
        self.assertFalse(set(a["handled"]["types"]) & set(a["unsupported"]["types"]))
        self.assertEqual(a["handled"]["records"] + a["unsupported"]["records"], a["typed"]["records"])
        # Typed but without a native handler: still unsupported, never opaque.
        for code in ("0x38",):
            self.assertIn(code, a["unsupported"]["types"])
            self.assertNotIn(code, a["opaque"]["types"])
        # RT-21: raw 0xa1 is typed and handled (registered as aa1_handler).
        self.assertIn("0xa1", a["typed"]["types"])
        self.assertIn("0xa1", a["handled"]["types"])
        self.assertNotIn("0xa1", a["unsupported"]["types"])
        self.assertNotIn("0xa1", a["opaque"]["types"])
        # RT-18: raw 0x37 is typed and handled (registered with the 0x36 handler).
        self.assertIn("0x37", a["typed"]["types"])
        self.assertIn("0x37", a["handled"]["types"])
        self.assertNotIn("0x37", a["unsupported"]["types"])
        self.assertNotIn("0x37", a["opaque"]["types"])

    def test_live_registrations_match_derived_handled_list(self):
        a = self.model["playable"]["action_types"]
        self.assertEqual(a["registrations"], {
            "executor": ["0x0a", "0x15", "0x4d", "0x61", "0x64", "0x6a", "0x6b", "0x71"],
            "session_ui": ["0x1d", "0x82"],
            "external": {"0x0b": "session_a0b_handler", "0x0c": "session_a0c_handler",  # RT-20
                         "0x16": "session_a17_handler", "0x17": "session_a17_handler",
                         "0x28": "session_a28_handler", "0x35": "native_a35_handler", "0x36": "session_a36_handler",
                         "0x37": "session_a36_handler",  # RT-18: second type on the raw 0x36 handler
                         "0x51": "session_a51_handler", "0x62": "session_a62_handler",
                         "0x78": "session_a78_handler",  # RT-19
                         "0x79": "session_a79_handler",
                         "0x83": "native_a83_handler",
                         "0x97": "session_a97_handler", "0x9f": "native_action_sound_handler",
                         "0xa1": "native_aa1_handler"}})  # RT-21
        # Handled = every registered type seen in the census; read both instead of hard-coding a count.
        registered = {int(t, 16) for t in a["registrations"]["executor"] + a["registrations"]["session_ui"]
                      + list(a["registrations"]["external"])}
        census = json.loads((EVIDENCE / "action-census-current.json").read_text())
        observed = {int(r["type"], 16) for r in census["by_raw_type"]}
        self.assertEqual(a["handled"]["type_count"], len(registered & observed))
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
        status = json.loads((EVIDENCE / "status.json").read_text())
        self.assertIn(status["current_integration"]["source_ref"][:40], report)

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
        self.assertIn("S5906 → S4700 → S4710", report)
        self.assertIn("**Current stop:** S2010;", report)
        self.assertIn("1,269 discovered; 1,264 passed; 5 skipped", report)

    def test_audited_code_is_added_to_the_legacy_status_baseline(self):
        t = self.model["totals"]
        self.assertTrue(self.audited_vas)
        self.assertEqual(len(self.legacy_bytes), 398)
        self.assertEqual(t["matched_code"], len(self.legacy_bytes | self.audited_bytes))
        self.assertEqual(t["matched_data"], len(self.data_bytes))
        self.assertTrue(self.model["evidence"]["crosscheck"]["agrees"])
        self.assertEqual(self.model["evidence"]["crosscheck"]["computed_legacy_matched_code"], 398)
        self.assertEqual(t["functions_complete"], len(self.audited_vas))

    def test_provenance_classes_stay_separate(self):
        bp = self.model["totals"]["by_provenance"]
        self.assertEqual(bp, {"exact_range_compiled_c_partial": 14,
                              "explicit_reconstructed_assembly_source": 384,
                              "tool_assisted_reconstructed_assembly": len(self.audited_bytes - self.legacy_bytes),
                              "tool_assisted_reconstructed_data": len(self.data_bytes)})
        self.assertEqual(self.model["totals"]["functions_by_provenance"], {
            "exact_range_compiled_c_partial": 0,
            "explicit_reconstructed_assembly_source": 11,
            "tool_assisted_reconstructed_assembly": len(self.audited_vas)})
        self.assertEqual(sum(bp.values()), self.model["totals"]["matched_code"] + self.model["totals"]["matched_data"])
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

    def create_batch(self, batch, extents, derived=()):
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
                              "evidence_id": ("derived-entry: found by the span split, not in function-index.json; inside the span of "
                                            "FUN_00400120 (+0x18)" if va in derived else "fixture"),
                              "code": code, "data_items": data})
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
            "assembler": {"version_line": "GNU assembler (GNU Binutils) 2.43.1", "self_test": "passed",
                          "sha256": "459ab053b16d25841cf302ece6f5ddd65ebd0f33a91fbbb6c6a665b74de0565b"}})

    def model(self):
        rows, meta = GEN.baseline_evidence(self.layout, self.dir)
        return GEN.build_model(self.layout, self.index, rows, meta, 0x4000,
                               {"unique_matched_bytes": 36}, [])

    def create_data_batch(self, ranges=((0x140, 0x40),), mutate=None):
        """A data source claiming ranges of the fixture's trailing 0xc0 data bytes (a ``.data`` section)."""
        self.layout["sections"].append({"name": ".data", "rva": 0x140, "raw_off": 0x140, "raw_size": 0xc0, "virt_size": 0xc0})
        out = self.dir / "asm_data"
        out.mkdir(exist_ok=True)
        layout = out / "data-001.layout"
        layout.write_text("IMG:\nSTR_00400140:\n.asciz [5]\n")
        entries = [{"offset": hex(off), "length": size, "va": f"0x{0x400000 + off:08x}", "section": ".data",
                    "sha256": hashlib_sha(f"data{off}")} for off, size in ranges]
        manifest = {"schema": GEN.DATA_ASM_SCHEMA, "batch": "001", "class": "tool_assisted_reconstructed_data",
                    "original_sha256": SHA, "source": "data-001.s", "source_sha256": hashlib_sha("generated source"),
                    "layout": "data-001.layout", "layout_sha256": GEN.sha256_file(layout), "ranges": entries}
        write(out / "data-001.json", manifest)
        total = sum(size for _, size in ranges)
        report = {"batch": "001", "class_requested": "tool_assisted_reconstructed_data", "original_sha256": SHA,
                  "manifest_sha256": GEN.sha256_file(out / "data-001.json"),
                  "source": {"path": "data-001.s", "sha256": manifest["source_sha256"]},
                  "layout": {"path": "data-001.layout", "sha256": manifest["layout_sha256"]},
                  "assembler": {"version_line": "GNU assembler (GNU Binutils) 2.43.1", "self_test": "passed",
                                "sha256": "459ab053b16d25841cf302ece6f5ddd65ebd0f33a91fbbb6c6a665b74de0565b"},
                  "ranges": entries, "bytes_total": total, "compared_bytes": total, "relocations": 0,
                  "labels_checked": 3, "errors": [], "all_accepted": True}
        if mutate:
            mutate(report)
        write(out / "data-001-report.json", report)

    def test_audited_data_is_matched_data_in_its_own_provenance_class(self):
        self.create_data_batch()
        model = self.model()
        t = model["totals"]
        self.assertEqual((t["matched_code"], t["matched_data"]), (56, 0x40))
        self.assertEqual(t["by_provenance"]["tool_assisted_reconstructed_data"], 0x40)
        self.assertEqual(t["functions_complete"], 2)  # data is not a function claim
        self.assertEqual(model["evidence"]["tool_assisted_data_batches"][0]["bytes"], 0x40)
        tail = next(u for u in model["units"] if u["id"] == "tail")
        self.assertEqual(tail["matched_data"], 0x40)

    def test_changed_data_layout_or_source_hash_is_not_counted(self):
        self.create_data_batch()
        (self.dir / "asm_data" / "data-001.layout").write_text("# edited after audit\n")
        with self.assertRaisesRegex(GEN.ProgressError, "layout hash"):
            self.model()
        self.setUp()
        self.create_data_batch(mutate=lambda r: r["source"].update(sha256=hashlib_sha("another source")))
        with self.assertRaisesRegex(GEN.ProgressError, "source hash"):
            self.model()

    def test_a_layout_carrying_payload_values_is_not_counted(self):
        def payload(report):
            layout = self.dir / "asm_data" / "data-001.layout"
            layout.write_text('.asciz "Hello"\n')
            sha = GEN.sha256_file(layout)
            report["layout"]["sha256"] = sha
            manifest = json.loads((self.dir / "asm_data" / "data-001.json").read_text())
            manifest["layout_sha256"] = sha
            write(self.dir / "asm_data" / "data-001.json", manifest)
            report["manifest_sha256"] = GEN.sha256_file(self.dir / "asm_data" / "data-001.json")

        self.create_data_batch(mutate=payload)
        with self.assertRaisesRegex(GEN.ProgressError, "payload"):
            self.model()

    def test_unaccepted_or_partial_data_audit_is_not_counted(self):
        for change, why in ((lambda r: r.update(all_accepted=False), "audit not accepted"),
                            (lambda r: r.update(compared_bytes=0x3f), "audit not accepted"),
                            (lambda r: r.update(relocations=2), "audit not accepted"),
                            (lambda r: r["assembler"].update(self_test="failed"), "not pinned"),
                            (lambda r: r.update(ranges=[]), "audited ranges differ")):
            with self.subTest(why=why):
                self.setUp()
                self.create_data_batch(mutate=change)
                with self.assertRaisesRegex(GEN.ProgressError, why):
                    self.model()
                self.tearDown()

    def test_data_outside_its_section_or_overlapping_is_rejected(self):
        self.create_data_batch(ranges=((0x140, 0x40), (0x170, 0x20)))
        with self.assertRaisesRegex(GEN.ProgressError, "overlap"):
            self.model()
        self.tearDown()
        self.setUp()
        self.create_data_batch(ranges=((0x1f0, 0x20),))
        with self.assertRaisesRegex(GEN.ProgressError, "outside its section"):
            self.model()

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

    def test_other_machine_assembler_binary_with_passing_self_test_is_accepted(self):
        self.mutate_report(lambda r: r["assembler"].update(sha256="0" * 64))
        self.assertEqual(self.model()["totals"]["functions_complete"], 2)

    def test_incomplete_or_unpinned_audit_is_rejected(self):
        changes = [
            lambda r: r.update(all_accepted=False),
            lambda r: r.update(errors=["failed audit"]),
            lambda r: r.update(original_sha256="0" * 64),
            lambda r: r.update(accepted_count=1),
            lambda r: r.update(code_bytes_accepted=55),
            lambda r: r["assembler"].update(version_line="Apple assembler"),
            lambda r: r["assembler"].update(self_test="failed"),
            lambda r: r["assembler"].pop("self_test"),
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

    def test_derived_entry_is_matched_code_of_its_span_but_not_a_function(self):
        # 0x400138 lies inside the span of 0x400120 and has no index entry: its 4 bytes add to the matched code
        self.create_batch("002", [(0x400138, 4)], derived=(0x400138,))
        model = self.model()
        self.assertEqual(model["totals"]["matched_code"], 60)
        self.assertEqual(model["totals"]["functions_complete"], 2)
        self.assertFalse(any(r["va"] == 0x400138 for r in model["matched_ranges"]))

    def test_unlisted_audited_code_without_the_derived_evidence_is_rejected(self):
        self.create_batch("002", [(0x400138, 4)])
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
        # 0x38 is typed but has no live handler (0x37 is already registered since RT-18).
        self.assertNotIn("0x38", self.original["handled"]["types"])
        self.change("src/blackmoor_app.mm", "bindings[2].type = SESSION_A51_TYPE;", "bindings[2].type = 0x38;")
        changed = GEN.PLAYABLE.derive_actions(self.out)
        self.assertIn("0x38", changed["handled"]["types"])
        self.assertNotIn("0x51", changed["handled"]["types"])
        self.assertNotEqual(changed, self.original)

    def test_duplicate_type_registration_fails_closed(self):
        # Two handlers for one type are ambiguous; a callback shared by two types (0x36/0x37) is fine.
        self.change("src/blackmoor_app.mm", "bindings[2].type = SESSION_A51_TYPE;", "bindings[2].type = 0x37;")
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "invalid live action binding"):
            GEN.PLAYABLE.derive_actions(self.out)

    def test_removed_parser_layout_moves_typed_records_to_opaque(self):
        census = json.loads((EVIDENCE / "action-census-current.json").read_text())
        counts = {r["type"]: r["count"] for r in census["by_raw_type"]}
        code = "0x6d"
        self.change("src/scene_resource.c", "case 0x6d: fixed_length = 1u; break;", "")
        changed = GEN.PLAYABLE.derive_actions(self.out)
        self.assertEqual(changed["typed"]["records"], self.original["typed"]["records"] - counts[code])
        self.assertEqual(changed["opaque"]["records"], self.original["opaque"]["records"] + counts[code])
        self.assertIn(code, changed["opaque"]["types"])
        self.assertNotEqual(changed, self.original)

    def test_guarded_parser_case_counts_listed_records_as_opaque(self):
        a = self.original
        self.assertIn("0xe0", a["typed"]["types"])
        self.assertEqual(a["typed"]["records"] + a["opaque"]["records"], a["record_total"])

    def test_unlisted_guarded_parser_case_fails_closed(self):
        self.change("src/scene_resource.c", "case 0xd3: fixed_length = 855u; break;",
                    "case 0xd3:\n        if (length < 855u) {\n            return 0;\n        }\n        fixed_length = 855u;\n        break;")
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "guarded parser case"):
            GEN.PLAYABLE.derive_actions(self.out)

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
        doc["stop"]["provider"] = "action-kernel"
        write(path, doc)
        with self.assertRaisesRegex(GEN.PLAYABLE.PlayableError, "stop reports no handler"):
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
        self.change("src/blackmoor_app.mm", "bindings[2].type = SESSION_A51_TYPE;", "bindings[2].type = 0x38;")
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
            ("src/blackmoor_app.mm", re.search(r"config\.action_binding_count = \d+u;", (EVIDENCE / "src/blackmoor_app.mm").read_text())[0]),
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


FIXTURE_LEDGER = HERE / "fixtures" / "function-ledger"
FIXTURE_FUNCTIONS = 30
SCRATCH_PARENT = "/private/tmp" if pathlib.Path("/private/tmp").is_dir() else None
BROWSER = pathlib.Path(__import__("os").environ.get("BLACKMOOR_PREVIEW_BROWSER") or
                       pathlib.Path.home() / "Library/Caches/ms-playwright/chromium_headless_shell-1243/"
                       "chrome-headless-shell-mac-arm64/chrome-headless-shell")
ABSOLUTE_PATH = re.compile(r"/Users/|/private/|/home/|/tmp/|/var/folders/|file://|[A-Za-z]:\\\\")


def generate(out, *extra):
    """Run the generator on the committed evidence; returns (exit code, stderr text)."""
    import contextlib
    import io
    err = io.StringIO()
    with contextlib.redirect_stderr(err), contextlib.redirect_stdout(io.StringIO()):
        rc = GEN.main(["--out-dir", str(out), *map(str, extra)])
    return rc, err.getvalue()


class LedgerScratch:
    """A mutable copy of the fixture ledger tree (inputs, committed ledger included)."""

    def __init__(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="fl4-", dir=SCRATCH_PARENT)
        self.root = pathlib.Path(self.tmp.name) / "fx"
        shutil.copytree(FIXTURE_LEDGER, self.root)

    def edit(self, rel, fn):
        p = self.root / rel
        data = json.loads(p.read_text())
        fn(data)
        p.write_text(json.dumps(data, indent=1) + "\n")

    def text(self, rel, fn):
        p = self.root / rel
        p.write_text(fn(p.read_text()))

    def ledger_entry(self, va, fn):
        """Edit one entry of the committed ledger text in place (one entry per line)."""
        lines = (self.root / "function-ledger.json").read_text().split("\n")
        for i, line in enumerate(lines):
            if f'"va": "{va}"' in line:
                body = line.rstrip(",")
                entry = json.loads(body)
                fn(entry)
                lines[i] = json.dumps(entry, separators=(", ", ": ")) + ("," if line.endswith(",") else "")
                break
        else:
            raise AssertionError(va)
        (self.root / "function-ledger.json").write_text("\n".join(lines))

    def generate(self, out=None):
        target = out or pathlib.Path(self.tmp.name) / "out"
        return generate(target, "--function-ledger-root", self.root, "--ledger-functions", FIXTURE_FUNCTIONS)


def dump_dom(html_path, query=""):
    import subprocess
    with tempfile.TemporaryDirectory(prefix="fl4-dom-", dir=SCRATCH_PARENT) as profile:
        run = subprocess.run([str(BROWSER), "--headless", "--no-sandbox", "--disable-gpu", "--no-first-run",
                              "--disable-background-networking", f"--user-data-dir={profile}/p",
                              "--virtual-time-budget=2000", "--dump-dom",
                              pathlib.Path(html_path).resolve().as_uri() + query],
                             capture_output=True, timeout=60)
    return run.stdout.decode("utf-8", "replace")


def dom_text(dom, element_id):
    m = re.search(r'id="%s"[^>]*>(.*?)</(?:div|p|span)>' % element_id, dom, re.S)
    return re.sub(r"<[^>]+>", "", m.group(1)).strip() if m else None


class FunctionLedgerTests(unittest.TestCase):
    """The Function ledger panel: strict validation, re-derivation and fail-closed behaviour."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory(prefix="fl4-out-", dir=SCRATCH_PARENT)
        base = pathlib.Path(cls.tmp.name)
        cls.real_out, cls.fx_out, cls.none_out = base / "real", base / "fixture", base / "none"
        assert generate(cls.real_out)[0] == 0
        assert generate(cls.fx_out, "--function-ledger-root", FIXTURE_LEDGER, "--ledger-functions", FIXTURE_FUNCTIONS)[0] == 0
        empty = base / "empty"
        empty.mkdir()
        assert generate(cls.none_out, "--function-ledger-root", empty)[0] == 0
        load = lambda out: json.loads((out / "progress.json").read_text())
        cls.real, cls.fx, cls.none = load(cls.real_out), load(cls.fx_out), load(cls.none_out)
        cls.real_ledger = json.loads((EVIDENCE / "function-ledger.json").read_text())
        cls.fx_ledger = json.loads((FIXTURE_LEDGER / "function-ledger.json").read_text())

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    # ---- committed ledger equals re-derived; counts ----
    def test_committed_ledger_equals_rederived_and_pins_4188(self):
        fresh = GEN.FNL.check(EVIDENCE, expected_functions=4188)
        self.assertEqual(fresh, self.real_ledger)
        p = self.real["function_ledger"]
        self.assertEqual(p["total"], 4188)
        self.assertEqual(len(p["rows"]), 4188)
        self.assertEqual(p["ledger_sha256"], GEN.sha256_file(EVIDENCE / "function-ledger.json"))
        regions = {r: sum(p["counts"]["region"][r].values()) for r in p["regions"]}
        self.assertEqual(regions, {"game": 2507, "vorbis": 178, "crt_mfc": 1503})
        self.assertEqual(sum(regions.values()), 4188)
        self.assertEqual(sum(r[1] for r in p["rows"]), 1213018)

    def test_fixture_counts_sum_per_region(self):
        p = self.fx["function_ledger"]
        self.assertEqual(p["total"], FIXTURE_FUNCTIONS)
        per_region = {r: sum(1 for e in self.fx_ledger["entries"] if e["region"] == r) for r in p["regions"]}
        for r in p["regions"]:
            self.assertEqual(sum(p["counts"]["region"][r].values()), per_region[r])
        self.assertEqual(sum(per_region.values()), FIXTURE_FUNCTIONS)

    def test_panel_counts_equal_ledger_counts(self):
        for panel, ledger in ((self.real["function_ledger"], self.real_ledger),
                              (self.fx["function_ledger"], self.fx_ledger)):
            self.assertEqual(panel["counts"], ledger["counts"])
            rows = panel["rows"]
            for i, s in enumerate(panel["statuses"]):
                self.assertEqual(sum(1 for r in rows if r[3] == i), ledger["counts"]["status"][s])
            for i, c in enumerate(panel["classes"]):
                self.assertEqual(sum(1 for r in rows if r[4] == i), ledger["counts"]["class"][c])
            for ri, region in enumerate(panel["regions"]):
                for si, s in enumerate(panel["statuses"]):
                    self.assertEqual(sum(1 for r in rows if r[2] == ri and r[3] == si),
                                     ledger["counts"]["region"][region][s])
            cross = panel["crosstab"]
            self.assertEqual(sum(sum(v.values()) for v in cross.values()), panel["total"])
            self.assertEqual(sum(cross["complete"].values()), ledger["counts"]["x86"]["complete"])
            self.assertEqual(cross["complete"]["ported"], ledger["counts"]["x86"]["complete_ported"])

    def test_real_ledger_counts_reach_the_report(self):
        c = self.real["function_ledger"]["counts"]
        self.assertEqual(c["total"], 4188)
        self.assertEqual(sum(c["status"].values()), 4188)
        self.assertGreater(c["status"]["pending"] * 5, c["total"] * 4)
        report = (self.real_out / "REPORT.md").read_text()
        s = c["status"]
        self.assertIn(f"{s['ported']:,} ported, {s['not_needed']:,} not needed, {s['pending']:,} pending", report)
        self.assertIn("More than 80% of functions", report)

    def test_rows_are_compact_and_match_the_ledger_entries(self):
        for panel, ledger in ((self.real["function_ledger"], self.real_ledger),
                              (self.fx["function_ledger"], self.fx_ledger)):
            self.assertEqual(len(panel["rows"]), len(ledger["entries"]))
            for row, e in zip(panel["rows"], ledger["entries"]):
                self.assertEqual(len(row), 6)
                va, span, region_i, status_i, class_i, ev_i = row
                self.assertEqual((va, span), (int(e["va"], 16), e["span"]))
                self.assertEqual(panel["regions"][region_i], e["region"])
                self.assertEqual(panel["statuses"][status_i], e["status"])
                self.assertEqual(panel["classes"][class_i], e["class"])
                self.assertEqual(panel["class_status"][class_i], status_i)
                self.assertTrue(0 <= ev_i < len(panel["details"]))
                self.assertEqual(ev_i != 0, bool(e["evidence"] or e["blockers"] or e["divergences"] or e["reason"]
                                                 or e["review"] or e["x86_match"] or e["seam"]))
        self.assertEqual([r[0] for r in self.real["function_ledger"]["rows"]],
                         sorted(r[0] for r in self.real["function_ledger"]["rows"]))

    def test_committed_progress_json_carries_the_current_ledger_panel(self):
        committed = json.loads((HERE / "progress.json").read_text())
        self.assertEqual(committed["function_ledger"], self.real["function_ledger"],
                         "Refresh progress after changes to function-ledger.json")

    # ---- panel placement, wording, offline, no leaks ----
    def test_panel_sits_after_playable_and_before_bars(self):
        for out in (self.real_out, self.fx_out):
            html = (out / "index.html").read_text()
            self.assertLess(html.index('id="playable"'), html.index('id="ledger"'))
            self.assertLess(html.index('id="ledger"'), html.index('id="bars"'))
            self.assertRegex(html, r'<section class="ledger"[^>]*id="ledger" hidden>')
            report = (out / "REPORT.md").read_text()
            self.assertLess(report.index("## Playable build"), report.index("## Function ledger"))
            self.assertLess(report.index("## Function ledger"), report.index("## x86 matching"))

    def test_caveats_are_on_the_page_and_in_the_report(self):
        phrases = ["reviewed claim, not an x86 match", "weaker evidence", "tables, padding and thunks",
                   "a few hundred bytes", "not re-hashed at build time"]
        for out in (self.real_out, self.fx_out):
            report = (out / "REPORT.md").read_text()
            blob = json.loads((out / "progress.json").read_text())["function_ledger"]["caveats"]
            self.assertEqual(len(blob), 5)
            for phrase in phrases:
                self.assertIn(phrase, report)
                self.assertTrue(any(phrase in c for c in blob), phrase)
            self.assertIn('id="lgCaveats"', (out / "index.html").read_text())

    def test_html_is_offline_with_no_absolute_paths(self):
        for out in (self.real_out, self.fx_out, self.none_out):
            html = (out / "index.html").read_text()
            self.assertNotRegex(html, r"https?://(?!www\.w3\.org/2000/svg)")
            self.assertNotRegex(html, r"\b(fetch|XMLHttpRequest|WebSocket|importScripts)\(")
            self.assertNotRegex(html, r"""(?:src|href)=["']?(?:https?:|//)""")
            self.assertIsNone(ABSOLUTE_PATH.search(html), ABSOLUTE_PATH.search(html))
            for name in ("progress.json", "REPORT.md"):
                self.assertIsNone(ABSOLUTE_PATH.search((out / name).read_text()), name)

    def test_private_receipts_are_shown_as_name_and_sha_only(self):
        panel = self.real["function_ledger"]
        self.assertTrue(panel["receipts"])
        for row in panel["receipts"]:
            self.assertEqual(len(row), 3)       # slice, sha256, review state: no path
            self.assertRegex(row[1], r"^[0-9a-f]{64}$")
        for out in (self.real_out, self.fx_out):
            for name in ("index.html", "progress.json", "REPORT.md"):
                self.assertNotIn("analysis/slices", (out / name).read_text(), name)
        for p in panel["paths"] + self.fx["function_ledger"]["paths"]:
            self.assertRegex(p, r"^[A-Za-z0-9_][A-Za-z0-9_./-]*$")
            self.assertFalse(p.startswith(("analysis/", "work/", "/")))
            self.assertNotIn("..", p)

    def test_no_original_bytes_or_dumps_in_the_panel(self):
        text = json.dumps(self.real["function_ledger"])
        self.assertNotRegex(text, r'"(bytes|data_hex|payload|disassembly)"')
        self.assertLess(len(text), 600_000)

    def test_panel_hidden_and_generation_works_without_a_ledger(self):
        self.assertNotIn("function_ledger", self.none)
        self.assertEqual(self.none["totals"], self.real["totals"])
        report = (self.none_out / "REPORT.md").read_text()
        self.assertNotIn("## Function ledger", report)
        self.assertLess(report.index("## Playable build"), report.index("## x86 matching"))
        html = (self.none_out / "index.html").read_text()
        self.assertRegex(html, r'id="ledger" hidden>')
        self.assertIn("if(D.function_ledger){", html)      # only unhidden when the model has a panel
        self.assertNotIn('"function_ledger"', re.search(r'id="data">(.*?)</script>', html, re.S).group(1))

    def test_other_outputs_are_unchanged_by_the_ledger(self):
        for key in ("totals", "groups", "units", "matched_ranges", "playable", "evidence"):
            self.assertEqual(self.none[key], self.real[key], key)

    # ---- generation reads committed files only ----
    def test_generation_does_not_read_private_files_or_the_original(self):
        calls = []
        real = GEN.FNL.derive

        def spy(root, **kwargs):
            calls.append(kwargs)
            return real(root, **kwargs)
        GEN.FNL.derive = spy
        try:
            self.assertIsNotNone(GEN.function_ledger_panel(FIXTURE_LEDGER, FIXTURE_FUNCTIONS))
        finally:
            GEN.FNL.derive = real
        self.assertEqual(len(calls), 1)
        self.assertEqual(calls[0].get("expected_functions"), FIXTURE_FUNCTIONS)
        self.assertFalse(calls[0].get("verify_private"))
        self.assertIsNone(calls[0].get("work_dir"))
        source = (HERE / "generate.py").read_text()
        self.assertNotIn("work/analysis", source)
        self.assertNotIn("game-source.json", source)

    def test_function_ledger_does_not_touch_the_range_ledger_option(self):
        self.assertEqual(GEN.LEDGER_SCHEMA, "blackmoor-range-ledger/1")
        self.assertEqual(GEN.FNL.SCHEMA, "blackmoor-function-ledger/1")

    # ---- fail-closed mutations (the committed ledger stays; one input or entry changes) ----
    def fails(self, scratch, expect=None):
        rc, err = scratch.generate()
        self.assertEqual(rc, 2, err)
        self.assertTrue(err.startswith("error: function ledger"), err)
        if expect:
            self.assertIn(expect, err)
        return err

    def test_fixture_tree_generates_cleanly_before_mutation(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        self.assertEqual(s.generate()[0], 0)

    def test_stale_ledger_names_the_rebuild_command(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        s.ledger_entry("0x401300", lambda e: e.update(name="FUN_renamed"))      # valid, but not what the inputs derive
        self.assertEqual(self.fails(s).strip(),
                         "error: function ledger stale; rerun scripts/build_function_ledger.py --write")

    def test_new_audited_batch_makes_the_ledger_stale(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        manifest = json.loads((s.root / "asm/batch-001.json").read_text())
        manifest["batch"] = "002"
        (s.root / "asm/batch-002.json").write_text(json.dumps(manifest, indent=1))
        report = json.loads((s.root / "asm/batch-001-report.json").read_text())
        report.update(batch="002", manifest_sha256=GEN.sha256_file(s.root / "asm/batch-002.json"))
        (s.root / "asm/batch-002-report.json").write_text(json.dumps(report, indent=1))
        self.assertEqual(self.fails(s).strip(),
                         "error: function ledger stale; rerun scripts/build_function_ledger.py --write")

    def test_unaudited_batch_or_new_manifest_fails_closed(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        shutil.copy2(s.root / "asm/batch-001.json", s.root / "asm/batch-002.json")
        self.fails(s)
        s2 = LedgerScratch()
        self.addCleanup(s2.tmp.cleanup)
        s2.text("matches_s08_2_x86.json", lambda t: t + "\n")
        self.fails(s2, "stale")

    def test_deleted_citation_fails_closed(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        s.edit("function-evidence.json", lambda d: next(
            f for f in d["functions"] if f["va"] == "0x401000")["evidence"].pop(0))
        self.fails(s)

    def test_interior_address_blocker_fails_closed(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        record = {"slice": "FIX-1", "path": "analysis/slices/FIX-1.handoff.json", "field": "unverified",
                  "index": 7, "text_sha256": hashlib_sha("fixture-item-U9"), "address": "0x4010fe", "interior": True}
        s.edit("function-evidence.json", lambda d: next(
            f for f in d["functions"] if f["va"] == "0x401000")["blockers"].append(record))
        self.fails(s)

    def test_mapped_only_oracle_window_fails_closed(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        s.edit("function-evidence.json", lambda d: next(
            p for f in d["functions"] if f["va"] == "0x401340" for p in f["evidence"]
            if p["kind"] == "oracle").update(use="mapped"))
        self.fails(s)

    def test_va_size_window_fails_closed(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        s.edit("function-evidence.json", lambda d: next(
            p for f in d["functions"] if f["va"] == "0x401000" for p in f["evidence"]
            if p["kind"] == "oracle").update(window=["0x401000", "0xf0"]))
        self.fails(s)

    def test_non_index_acceptance_fails_closed(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        s.edit("function-ledger-overrides.json", lambda d: next(
            a for a in d["port_acceptances"] if a["va"] == "0x401000").update(va="0x401004"))
        self.fails(s)

    def test_ported_and_not_needed_at_once_fails_closed(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        s.edit("function-ledger-overrides.json", lambda d: d["not_needed_entries"].insert(
            0, {"va": "0x401000", "reason": "unreachable_no_refs", "text": "x", "reviewer": "r", "date": "2026-10-15"}))
        self.fails(s, "both")

    def test_edited_test_file_fails_closed(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        s.text("tests/fixture_core_tests.py", lambda t: t + "\n# edited\n")
        self.fails(s)

    def test_rule_based_not_needed_in_the_game_region_fails_closed(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        sample = hashlib_sha("fixture-sample")

        def rule(e):
            e.update(**{"class": "nn_rule"})
            e["reason"].update(code="library_internal_unreached_by_game", rule="R-LIB-INTERNAL")
            e["review"]["sample"] = sample
        s.ledger_entry("0x401b00", rule)
        self.fails(s, "game")

    def test_ledger_edits_that_are_not_derived_fail_closed(self):
        edits = {
            "ported without evidence": ("0x401300", lambda e: e.update(status="ported", **{"class": "native_tests_only"},
                                                                       review={"reviewer": "r", "date": "2026-10-15", "sample": None})),
            "vorbis ported": ("0x404800", lambda e: e.update(status="ported", **{"class": "host_adapter_tested"},
                                                             review={"reviewer": "r", "date": "2026-10-15", "sample": None})),
            "status class mismatch": ("0x401300", lambda e: e.update(**{"class": "nn_reviewed"})),
            "extra field": ("0x401300", lambda e: e.update(note="x")),
            "non-index address": ("0x401300", lambda e: e.update(va="0x401304")),
            "unknown reason": ("0x401b00", lambda e: e["reason"].update(code="because")),
        }
        for label, (va, fn) in edits.items():
            with self.subTest(label):
                s = LedgerScratch()
                self.addCleanup(s.tmp.cleanup)
                s.ledger_entry(va, fn)
                self.fails(s)

    def test_tampered_counts_fail_closed(self):
        s = LedgerScratch()
        self.addCleanup(s.tmp.cleanup)
        s.text("function-ledger.json", lambda t: t.replace('"ported": 5', '"ported": 6', 1))
        self.fails(s)

    def test_wrong_pinned_function_count_fails_closed(self):
        rc, err = generate(self.tmp.name + "/wrong", "--function-ledger-root", FIXTURE_LEDGER)   # default pin is 4,188
        self.assertEqual(rc, 2)
        self.assertTrue(err.startswith("error: function ledger"), err)

    def test_rows_that_disagree_with_counts_are_refused(self):
        ledger = json.loads(json.dumps(self.fx_ledger))
        ledger["entries"][0]["status"] = "ported" if ledger["entries"][0]["status"] != "ported" else "pending"
        with self.assertRaisesRegex(GEN.ProgressError, "disagree"):
            GEN.compact_function_ledger(ledger, "0" * 64)

    def test_each_count_dimension_is_cross_checked_against_the_rows(self):
        def tampered(fn):
            ledger = json.loads(json.dumps(self.fx_ledger))
            fn(ledger["entries"][0])
            return ledger
        other_region = lambda e: e.update(region="crt_mfc" if e["region"] != "crt_mfc" else "game")
        other_class = lambda e: e.update(**{"class": "candidate_port" if e["class"] != "candidate_port" else "none"})
        for label, fn in (("region", other_region), ("class", other_class)):
            with self.subTest(label), self.assertRaisesRegex(GEN.ProgressError, "disagree"):
                GEN.compact_function_ledger(tampered(fn), "0" * 64)
        for field in ("complete_ported", "matched", "complete"):
            with self.subTest(field):
                ledger = json.loads(json.dumps(self.fx_ledger))
                ledger["counts"]["x86"][field] += 1
                with self.assertRaisesRegex(GEN.ProgressError, "cross-tab"):
                    GEN.compact_function_ledger(ledger, "0" * 64)
        ledger = json.loads(json.dumps(self.fx_ledger))
        ledger["entries"].pop()
        with self.assertRaisesRegex(GEN.ProgressError, "disagree"):
            GEN.compact_function_ledger(ledger, "0" * 64)

    # ---- rendered panel (headless browser, when available) ----
    @unittest.skipUnless(BROWSER.is_file(), "headless browser not installed")
    def test_rendered_panel_numbers_equal_the_ledger(self):
        for out, ledger, n in ((self.real_out, self.real_ledger, 4188), (self.fx_out, self.fx_ledger, FIXTURE_FUNCTIONS)):
            dom = dump_dom(out / "index.html")
            c = ledger["counts"]
            self.assertNotRegex(re.search(r'<section class="ledger"[^>]*>', dom).group(0), r"\bhidden\b")
            first = lambda element: dom_text(dom, element).split()[0].replace(",", "")
            self.assertEqual(int(first("lgPorted")), c["status"]["ported"])
            self.assertEqual(int(first("lgNotNeeded")), c["status"]["not_needed"])
            self.assertEqual(int(first("lgPending")), c["status"]["pending"])
            self.assertIn(f"of {n:,}", dom_text(dom, "lgPorted"))
            self.assertEqual(dom_text(dom, "lgCount"), f"{n:,} of {n:,} functions")
            self.assertIn(f"Candidate port {c['class']['candidate_port']:,}", dom_text(dom, "lgPendingSplit"))
            self.assertIn("Oracle-verified %d" % c["class"]["native_oracle_verified"], dom_text(dom, "lgPortedSplit"))
            for region in ("game", "vorbis", "crt_mfc"):
                r = c["region"][region]
                self.assertIn(f"{r['ported']:,} ported · {r['not_needed']:,} not needed · {r['pending']:,} pending", dom)
            for phrase in ("reviewed claim, not an x86 match", "weaker evidence", "tables, padding and thunks",
                           "a few hundred bytes", "not re-hashed at build time"):
                self.assertIn(phrase, dom)
        base = dom_text(dump_dom(self.real_out / "index.html"), "lgBaseline")
        self.assertIn("are still pending", base)
        self.assertIn("More than 80% of functions", base)

    @unittest.skipUnless(BROWSER.is_file(), "headless browser not installed")
    def test_rendered_table_filters_pages_and_links(self):
        dom = dump_dom(self.fx_out / "index.html")
        self.assertEqual(dom_text(dom, "lgPage"), "rows 1–25 · page 1 of 2")
        body = re.search(r'<tbody>(.*?)</tbody>', dom.split('id="lgTable"')[1], re.S).group(1)
        self.assertEqual(body.count("<tr"), 25)
        ported = dump_dom(self.fx_out / "index.html", "?lgstatus=ported")
        self.assertEqual(dom_text(ported, "lgCount"), f"5 of {FIXTURE_FUNCTIONS} functions")
        self.assertEqual(dom_text(ported, "lgPage"), "rows 1–5 · page 1 of 1")
        found = dump_dom(self.fx_out / "index.html", "?lgq=401a00")
        self.assertEqual(dom_text(found, "lgCount"), f"1 of {FIXTURE_FUNCTIONS} functions")
        inside = dump_dom(self.fx_out / "index.html", "?lgq=401a10")       # an address inside the span finds the function
        self.assertEqual(dom_text(inside, "lgCount"), f"1 of {FIXTURE_FUNCTIONS} functions")
        opened = dump_dom(self.fx_out / "index.html", "?lgstatus=ported&lgopen=0x401000,0x401100")
        self.assertIn("Native source: ", opened)
        self.assertIn('href="../src/fixture_core.c"', opened)
        self.assertIn('href="../tests/fixture_core_tests.py"', opened)
        self.assertRegex(opened, r"Private receipt FIX-1 · sha256 <span class=\"mono\">[0-9a-f]{64}</span>")
        self.assertNotIn("analysis/slices", opened)
        hrefs = re.findall(r'<a [^>]*href="([^"]*)"', opened.split('id="lgTable"')[1])
        self.assertTrue(hrefs)
        for href in hrefs:
            self.assertRegex(href, r"^\.\./(src|tests)/[A-Za-z0-9_./-]+$")
        empty = dump_dom(self.none_out / "index.html")
        self.assertRegex(re.search(r'<section class="ledger"[^>]*>', empty).group(0), r"\bhidden\b")


if __name__ == "__main__":
    unittest.main()
