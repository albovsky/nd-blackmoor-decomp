import importlib.util
import json
import pathlib
import re
import tempfile
import unittest

HERE = pathlib.Path(__file__).resolve().parent
EVIDENCE = HERE.parent
SPEC = importlib.util.spec_from_file_location("decomp_progress_generate", HERE / "generate.py")
GEN = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GEN)

SHA = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"


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

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def test_every_file_byte_is_accounted_once(self):
        t = self.model["totals"]
        self.assertEqual(t["file_bytes"], 1511424)
        self.assertEqual(t["code"] + t["data"], 1511424)
        self.assertEqual(sum(u["size"] for u in self.model["units"]), 1511424)

    def test_matched_bytes_agree_with_status_json(self):
        t = self.model["totals"]
        self.assertEqual(t["matched_code"], 398)
        self.assertEqual(t["matched_data"], 0)
        self.assertTrue(self.model["evidence"]["crosscheck"]["agrees"])
        self.assertEqual(t["functions_complete"], 11)

    def test_provenance_classes_stay_separate(self):
        bp = self.model["totals"]["by_provenance"]
        self.assertEqual(bp, {"exact_range_compiled_c_partial": 14,
                              "explicit_reconstructed_assembly_source": 384})
        self.assertNotIn("tool_assisted_reconstructed_assembly", bp)
        self.assertIn("exact_range_compiled_c_partial", (self.out / "REPORT.md").read_text())

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
                               "class": "structured" if a["unit"] == "headers" else "referenced"})
                continue
            pos = lo
            for s, e in hit:
                s, e = max(s, lo), min(e, hi)
                if s >= e:
                    continue
                if s > pos:
                    ranges.append({"offset": pos, "size": s - pos, "kind": "code", "class": "referenced"})
                ranges.append({"offset": s, "size": e - s, "kind": "code", "class": "reconstructed"})
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
        self.assertEqual(m["totals"]["matched_code"], 398)
        self.assertEqual(m["totals"]["matched_data"], 4096)
        self.assertEqual(m["totals"]["code"], 1213018)

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
            {"offset": 0, "size": 0x100, "kind": "data", "class": "structured"},
            {"offset": 0x100, "size": 0x20, "kind": "code", "class": "reconstructed"},
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
        self.assertEqual(self.model_for(self.full_ranges())["totals"]["by_provenance"], {"unspecified": 0x120})

    def test_referenced_is_never_matched(self):
        r = self.full_ranges()
        r[1]["class"] = "referenced"
        r[0]["class"] = "referenced"
        t = self.model_for(r)["totals"]
        self.assertEqual((t["matched_code"], t["matched_data"]), (0, 0))

    def test_structured_data_inside_code_counts_as_data(self):
        r = self.full_ranges()
        r[1:3] = [
            {"offset": 0x100, "size": 0x30, "kind": "code", "class": "reconstructed"},
            {"offset": 0x130, "size": 0x10, "kind": "data", "class": "structured"},
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
        m = self.model_for([{"offset": 0, "size": 0x100, "kind": "data", "class": "structured"}],
                           allow_partial=True)
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


if __name__ == "__main__":
    unittest.main()
