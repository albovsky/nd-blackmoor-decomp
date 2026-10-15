"""Function ledger core: derivation, strict validation and the build CLI.

Fixture tests run against the synthetic inputs under
decomp-progress/fixtures/function-ledger/ and mutate scratch copies only. The
committed fixture ledger and the real function-ledger.json are never edited in
place. No original bytes or private evidence are read.
"""

import copy
import hashlib
import importlib.util
import json
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE.parent
FIXTURE = OUT / "decomp-progress" / "fixtures" / "function-ledger"
SCRIPT = OUT / "scripts" / "build_function_ledger.py"
SPEC = importlib.util.spec_from_file_location("function_ledger", OUT / "decomp-progress" / "function_ledger.py")
FL = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(FL)

PIN = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
FIXTURE_FUNCTIONS = 30
SCRATCH_PARENT = "/private/tmp" if Path("/private/tmp").is_dir() else None


def sha_file(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def hx(va):
    return f"0x{va:x}"


# Hand-checked expectations for the fixture: va -> (status, class, region, seam, origin, reason, rule)
G, V, C = "game", "vorbis", "crt_mfc"
P, N, D = "ported", "not_needed", "pending"
EXPECT = {
    0x401000: (P, "native_oracle_verified", G, False, "unknown", None, None),
    0x401100: (P, "native_tests_only", G, False, "unknown", None, None),
    0x401300: (D, "none", G, False, "unknown", None, None),
    0x401340: (P, "native_oracle_verified", G, False, "unknown", None, None),
    0x4014c0: (D, "candidate_port", G, False, "unknown", None, None),
    0x401600: (D, "partial_native", G, False, "unknown", None, None),
    0x401700: (D, "static_navigation_only", G, False, "unknown", None, None),
    0x401800: (D, "none", G, False, "unknown", None, None),
    0x401900: (D, "candidate_port", G, False, "unknown", None, None),
    0x401a00: (P, "native_oracle_verified", G, False, "unknown", None, None),
    0x401b00: (N, "nn_reviewed", G, False, "game", "unreachable_no_refs", None),
    0x401c00: (N, "nn_reviewed", G, False, "game", "debug_diagnostic_only", None),
    0x401d00: (N, "nn_reviewed", G, False, "game", "win32_plumbing_no_observable_effect", None),
    0x401e00: (D, "none", G, True, "unknown", None, None),
    0x404000: (D, "none", V, True, "unknown", None, None),
    0x404800: (D, "none", V, False, "library", None, None),
    0x405c00: (D, "none", V, True, "unknown", None, None),
    0x406000: (P, "host_adapter_tested", C, True, "library", None, None),
    0x406800: (N, "nn_rule", C, False, "library", "library_internal_unreached_by_game", "R-LIB-INTERNAL"),
    0x407000: (D, "none", C, False, "library", None, None),
    0x407100: (D, "none", C, False, "library", None, None),
    0x407200: (D, "none", C, False, "library", None, None),
    0x407300: (N, "nn_rule", C, False, "compiler_eh", "compiler_eh_funclet", "R-EH"),
    0x407400: (D, "none", C, False, "compiler_eh", None, None),
    0x407500: (N, "nn_reviewed", C, False, "compiler_eh", "compiler_eh_funclet", None),
    0x407600: (D, "none", C, False, "import_thunk", None, None),
    0x407700: (N, "nn_reviewed", C, False, "library", "crt_startup_termination", None),
    0x407800: (N, "nn_reviewed", C, False, "library", "host_libc_standard_contract", None),
    0x407900: (D, "none", C, False, "library", None, None),
    0x407a00: (D, "none", C, False, "unknown", None, None),
}


def fixture_derive(root=FIXTURE, **kw):
    kw.setdefault("expected_functions", FIXTURE_FUNCTIONS)
    return FL.derive(root, **kw)


def by_va(ledger):
    return {int(e["va"], 16): e for e in ledger["entries"]}


class Scratch:
    """A mutable copy of the fixture tree."""

    def __init__(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="fl1-", dir=SCRATCH_PARENT)
        self.root = Path(self.tmp.name) / "fx"
        shutil.copytree(FIXTURE, self.root)

    def cleanup(self):
        self.tmp.cleanup()

    def path(self, rel):
        return self.root / rel

    def edit(self, rel, fn):
        data = json.loads(self.path(rel).read_text())
        out = fn(data)
        self.path(rel).write_text(json.dumps(data if out is None else out, indent=1) + "\n")

    def text(self, rel, fn):
        p = self.path(rel)
        p.write_text(fn(p.read_text()))

    def resync_evidence_hashes(self):
        """Refresh every evidence pointer hash after editing a source or test file."""
        def fix(doc):
            for fn in doc["functions"]:
                for p in fn["evidence"]:
                    if p["kind"] in ("native_source", "test", "oracle"):
                        p["sha256"] = sha_file(self.path(p["path"]))
        self.edit("function-evidence.json", fix)

    def derive(self, **kw):
        return fixture_derive(self.root, **kw)

    def _fn(self, rel, va, fn):
        def go(doc):
            for f in doc["functions"]:
                if int(f["va"], 16) == va:
                    fn(f)
        self.edit(rel, go)

    def ev(self, va, fn):
        self._fn("function-evidence.json", va, fn)

    def xr(self, va, fn):
        self._fn("function-xrefs.json", va, fn)

    def ov(self, fn):
        self.edit("function-ledger-overrides.json", fn)


class ScratchCase(unittest.TestCase):
    def setUp(self):
        self.s = Scratch()
        self.addCleanup(self.s.cleanup)

    def fresh(self):
        s = Scratch()
        self.addCleanup(s.cleanup)
        return s

    def fails(self, fragment=None, **kw):
        with self.assertRaises(FL.LedgerError) as ctx:
            self.s.derive(**kw)
        if fragment:
            self.assertIn(fragment, str(ctx.exception))
        return ctx.exception


# ------------------------------------------------------------------ fixture --

class FixtureDerivationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.ledger = fixture_derive()
        cls.by_va = by_va(cls.ledger)

    def test_universe_and_spans(self):
        self.assertEqual(len(self.ledger["entries"]), FIXTURE_FUNCTIONS)
        self.assertEqual(sorted(self.by_va), list(self.by_va))
        self.assertEqual(sorted(self.by_va), sorted(EXPECT))
        self.assertEqual(sum(e["span"] for e in self.ledger["entries"]), 0x8000)
        self.assertEqual(self.by_va[0x401340]["span"], 0x180)
        self.assertEqual(self.by_va[0x407a00]["span"], 0x1600)   # to the end of .text
        self.assertEqual(self.ledger["original_sha256"], PIN)
        self.assertEqual(self.ledger["schema"], "blackmoor-function-ledger/1")

    def test_hand_checked_entries(self):
        for va, (status, cls, region, seam, origin, reason, rule) in EXPECT.items():
            with self.subTest(va=hx(va)):
                e = self.by_va[va]
                self.assertEqual((e["status"], e["class"], e["region"], e["seam"], e["origin"]),
                                 (status, cls, region, seam, origin))
                self.assertEqual(e["reason"] and e["reason"]["code"], reason)
                self.assertEqual(e["reason"] and e["reason"]["rule"], rule)
                self.assertEqual(e["name"], f"FUN_{va:08x}")

    def test_body_sizes_parts_blockers_divergences(self):
        e = self.by_va
        self.assertEqual(e[0x401000]["body_size"], 0xf0)
        self.assertEqual(e[0x407a00]["body_size"], 0x1500)
        self.assertEqual(e[0x401340]["derived_parts"], ["0x401380", "0x4013a0"])
        self.assertEqual(e[0x401e00]["derived_parts"], ["0x401e80"])
        self.assertEqual([b["id"] for b in e[0x401900]["blockers"]], ["U1"])
        self.assertEqual(e[0x401900]["blockers"][0]["address"], "0x401950")
        self.assertEqual([b["id"] for b in e[0x401a00]["blockers"]], ["U2"])
        self.assertEqual([d["id"] for d in e[0x401a00]["divergences"]], ["U2"])
        self.assertEqual([b["id"] for b in e[0x401e00]["blockers"]], ["census_fall_through_fragment"])
        self.assertEqual(e[0x401e00]["blockers"][0]["address"], "0x401e80")
        self.assertEqual([b["id"] for b in e[0x407a00]["blockers"]], ["census_unsplit_span"])
        self.assertEqual(e[0x401b00]["blockers"], [])

    def test_review_fields(self):
        e = self.by_va
        self.assertEqual(e[0x401000]["review"], {"reviewer": "fixture-reviewer", "date": "2026-10-15", "sample": None})
        self.assertEqual(e[0x406800]["review"]["sample"], hashlib.sha256(b"sample-lib").hexdigest())
        self.assertEqual(e[0x407300]["review"]["sample"], hashlib.sha256(b"sample-eh").hexdigest())
        self.assertIsNone(e[0x401800]["review"])
        self.assertEqual(e[0x406800]["reason"]["text"], "library function with no path from or to game code")

    def test_evidence_pointers_by_kind(self):
        kinds = lambda va: [p["kind"] for p in self.by_va[va]["evidence"]]
        self.assertEqual(kinds(0x401000), ["native_source", "oracle", "receipt", "test"])
        self.assertEqual(kinds(0x401700), ["mention", "receipt"])
        self.assertEqual(kinds(0x401800), [])
        oracle = [p for p in self.by_va[0x401000]["evidence"] if p["kind"] == "oracle"][0]
        self.assertEqual(oracle["window"], ["0x401000", "0x401100"])
        self.assertEqual(oracle["use"], "entry")
        self.assertEqual(oracle["sha256"], sha_file(FIXTURE / "tests/fixture_core_oracle.py"))
        for e in self.ledger["entries"]:
            for p in e["evidence"]:
                self.assertFalse({"line", "lines", "line_no"} & set(p))

    def test_x86_match_is_recorded_but_orthogonal(self):
        e = self.by_va
        self.assertEqual(e[0x401100]["x86_match"],
                         {"provenance": "tool_assisted_reconstructed_assembly", "complete": True,
                          "manifest": "asm/batch-001.json"})
        self.assertEqual(e[0x401a00]["x86_match"],
                         {"provenance": "explicit_reconstructed_assembly_source", "complete": True,
                          "manifest": "matches_s08_2_x86.json"})
        self.assertEqual(e[0x401300]["x86_match"],
                         {"provenance": "exact_range_compiled_c_partial", "complete": False,
                          "manifest": "matches.json"})
        self.assertEqual([va for va, x in e.items() if x["x86_match"]], [0x401100, 0x401300, 0x401a00])

    def test_counts(self):
        c = self.ledger["counts"]
        self.assertEqual(c["total"], 30)
        self.assertEqual(c["status"], {"ported": 5, "not_needed": 8, "pending": 17})
        self.assertEqual(c["class"], {
            "native_oracle_verified": 3, "native_tests_only": 1, "host_adapter_tested": 1,
            "nn_rule": 2, "nn_reviewed": 6,
            "candidate_port": 2, "partial_native": 1, "static_navigation_only": 1, "none": 13})
        self.assertEqual(c["region"], {
            "game": {"ported": 4, "not_needed": 3, "pending": 7},
            "vorbis": {"ported": 0, "not_needed": 0, "pending": 3},
            "crt_mfc": {"ported": 1, "not_needed": 5, "pending": 7}})
        self.assertEqual(c["reason"], {
            "win32_plumbing_no_observable_effect": 1, "crt_startup_termination": 1,
            "library_internal_unreached_by_game": 1, "host_libc_standard_contract": 1,
            "debug_diagnostic_only": 1, "unreachable_no_refs": 1, "compiler_eh_funclet": 2})
        self.assertEqual(c["origin"], {"game": 3, "library": 9, "compiler_eh": 3, "import_thunk": 1, "unknown": 14})
        self.assertEqual(c["seam"], 4)
        self.assertEqual(c["x86"], {"matched": 3, "complete": 2, "matched_ported": 2, "complete_ported": 2})
        self.assertEqual(sum(c["span_bytes"].values()), 0x8000)

    def test_inputs_are_pinned_and_relative(self):
        inputs = {i["path"]: i for i in self.ledger["inputs"]}
        for path in ("function-index.json", "decomp-progress/layout.json", "asm/census-summary.json",
                     "function-evidence.json", "function-xrefs.json", "function-ledger-overrides.json",
                     "src/fixture_core.c", "src/fixture_rand.c", "tests/fixture_core_tests.py",
                     "tests/fixture_core_oracle.py", "matches.json", "matches_s08_2_x86.json",
                     "asm/batch-001.json", "asm/batch-001-report.json"):
            self.assertIn(path, inputs)
            self.assertEqual(inputs[path]["sha256"], sha_file(FIXTURE / path), path)
        # Absent optional manifests are pinned as absent so that adding one makes the ledger stale.
        self.assertIsNone(inputs["matches_s08_3_x86.json"]["sha256"])
        self.assertEqual([i["path"] for i in self.ledger["inputs"]], sorted(inputs))
        for i in self.ledger["inputs"]:
            self.assertFalse(i["path"].startswith("/") or ".." in i["path"].split("/"))

    def test_committed_fixture_ledger_matches_derivation_and_validates(self):
        text = (FIXTURE / "function-ledger.json").read_text()
        self.assertEqual(text, FL.render(self.ledger))
        FL.validate(json.loads(text))
        FL.check(FIXTURE, FIXTURE / "function-ledger.json", expected_functions=FIXTURE_FUNCTIONS)

    def test_render_is_deterministic_one_entry_per_line(self):
        text = FL.render(self.ledger)
        self.assertEqual(text, FL.render(fixture_derive()))
        self.assertTrue(text.endswith("\n"))
        self.assertEqual(json.loads(text), self.ledger)
        lines = [l for l in text.splitlines() if l.startswith('{"va"')]
        self.assertEqual(len(lines), FIXTURE_FUNCTIONS)
        self.assertNotIn("/Users/", text)

    def test_no_evidence_leaks_absolute_paths(self):
        self.assertNotRegex(FL.render(self.ledger), r'"path": "(?:/|[A-Za-z]:)')


class MissingInputsTests(ScratchCase):
    def test_absent_optional_inputs_are_empty(self):
        for rel in ("function-evidence.json", "function-xrefs.json", "function-ledger-overrides.json"):
            self.s.path(rel).unlink()
        ledger = self.s.derive()
        c = ledger["counts"]
        self.assertEqual(c["status"], {"ported": 0, "not_needed": 0, "pending": FIXTURE_FUNCTIONS})
        self.assertEqual(c["class"]["none"], FIXTURE_FUNCTIONS)
        self.assertEqual(c["origin"]["unknown"], FIXTURE_FUNCTIONS)
        inputs = {i["path"]: i["sha256"] for i in ledger["inputs"]}
        for rel in ("function-evidence.json", "function-xrefs.json", "function-ledger-overrides.json"):
            self.assertIsNone(inputs[rel])
        self.assertTrue(all(e["body_size"] is None for e in ledger["entries"]))
        # The census still supplies the span/region facts; fragments are still listed as blockers.
        FL.validate(ledger)

    def test_adding_the_inputs_later_makes_the_empty_ledger_stale(self):
        self.s.path("function-evidence.json").unlink()
        empty = self.s.derive()
        (self.s.root / "function-ledger.json").write_text(FL.render(empty))
        FL.check(self.s.root, self.s.root / "function-ledger.json", expected_functions=FIXTURE_FUNCTIONS)
        shutil.copy(FIXTURE / "function-evidence.json", self.s.path("function-evidence.json"))
        with self.assertRaises(FL.LedgerError) as ctx:
            FL.check(self.s.root, self.s.root / "function-ledger.json", expected_functions=FIXTURE_FUNCTIONS)
        self.assertIn("function ledger stale", str(ctx.exception))

    def test_required_inputs_must_exist(self):
        for rel in ("function-index.json", "decomp-progress/layout.json", "asm/census-summary.json"):
            with self.subTest(rel=rel):
                s = self.fresh()
                s.path(rel).unlink()
                with self.assertRaises(FL.LedgerError):
                    s.derive()

    def test_x86_manifests_never_feed_status(self):
        base = self.s.derive()
        for rel in ("matches.json", "matches_s08_2_x86.json", "asm/batch-001.json", "asm/batch-001-report.json"):
            self.s.path(rel).unlink()
        none = self.s.derive()
        self.assertEqual([e["x86_match"] for e in none["entries"] if e["x86_match"]], [])
        strip = lambda l: [{k: v for k, v in e.items() if k != "x86_match"} for e in l["entries"]]
        self.assertEqual(strip(base), strip(none))

    def test_unaccepted_batch_is_an_error_not_a_silent_skip(self):
        self.s.edit("asm/batch-001-report.json", lambda d: d.update(all_accepted=False))
        self.fails("batch")


# ----------------------------------------------------------- universe rules --

class UniverseTests(ScratchCase):
    def test_count_is_pinned(self):
        with self.assertRaises(FL.LedgerError) as ctx:
            self.s.derive(expected_functions=FIXTURE_FUNCTIONS + 1)
        self.assertIn("function", str(ctx.exception))

    def test_duplicate_index_start(self):
        self.s.edit("function-index.json", lambda d: d["functions"].append(copy.deepcopy(d["functions"][3])))
        self.fails()

    def test_index_must_describe_pinned_original(self):
        self.s.edit("function-index.json", lambda d: d.update(original_sha256="0" * 64))
        self.fails("pinned")

    def test_region_seam_crossing_function(self):
        def move(d):
            d["code_regions"][0]["end_va"] = 0x401f00
            d["code_regions"][1]["start_va"] = 0x401f00
        self.s.edit("decomp-progress/layout.json", move)
        self.fails()

    def test_census_region_span_mismatch(self):
        self.s.edit("asm/census-summary.json", lambda d: d["by_region"]["vorbis"].update(span_bytes=1))
        self.fails("census")

    def test_census_derived_count_mismatch(self):
        self.s.edit("asm/census-summary.json", lambda d: d.update(derived_functions=3))
        self.fails("derived")

    def test_text_end_comes_from_layout(self):
        self.s.edit("decomp-progress/layout.json", lambda d: d["sections"][1].update(virt_size=0x8000 + 0x10))
        self.fails()


# ----------------------------------------------------------- strict schemas --

class SchemaTests(ScratchCase):
    def test_top_level_of_each_input(self):
        for rel in ("function-evidence.json", "function-xrefs.json", "function-ledger-overrides.json"):
            for name, fn in {"extra key": lambda d: d.update(extra=1),
                             "schema": lambda d: d.update(schema="x")}.items():
                with self.subTest(rel=rel, name=name):
                    s = self.fresh()
                    s.edit(rel, fn)
                    with self.assertRaises(FL.LedgerError):
                        s.derive()
        for rel in ("function-evidence.json", "function-xrefs.json"):
            for name, fn in {"sha": lambda d: d.update(original_sha256="0" * 64),
                             "functions": lambda d: d.pop("functions")}.items():
                with self.subTest(rel=rel, name=name):
                    s = self.fresh()
                    s.edit(rel, fn)
                    with self.assertRaises(FL.LedgerError):
                        s.derive()

    def test_evidence_function_items(self):
        mutations = {
            "extra key": lambda f: f.update(extra=1),
            "missing evidence": lambda f: f.pop("evidence"),
            "bad va": lambda f: f.update(va="401000"),
            "non-index va": lambda f: f.update(va="0x401001"),
            "unknown pointer kind": lambda f: f["evidence"][0].update(kind="guess"),
            "pointer extra key": lambda f: f["evidence"][0].update(extra=3),
            "pointer line number": lambda f: f["evidence"][0].update(line_no=3),
            "bad sha": lambda f: f["evidence"][0].update(sha256="zz"),
            "absolute path": lambda f: f["evidence"][0].update(path="/Users/x/src/fixture_core.c"),
            "dotdot path": lambda f: f["evidence"][0].update(path="../src/fixture_core.c"),
            "windows path": lambda f: f["evidence"][0].update(path="C:/x/fixture_core.c"),
            "backslash path": lambda f: f["evidence"][0].update(path="src\\fixture_core.c"),
            "empty symbol": lambda f: f["evidence"][0].update(symbol=""),
            "bad use": lambda f: f["evidence"][2].update(use="executed"),
            "bad window hash": lambda f: f["evidence"][2].update(window_sha256="1"),
            "inverted window": lambda f: f["evidence"][2].update(window=["0x401100", "0x401000"]),
            "empty window": lambda f: f["evidence"][2].update(window=["0x401000", "0x401000"]),
            "three element window": lambda f: f["evidence"][2].update(window=["0x401000", "0x401100", "x"]),
            "window as dict": lambda f: f["evidence"][2].update(window={"start": "0x401000", "end": "0x401100"}),
            "blocker without id": lambda f: f["blockers"].append({"address": "0x401010", "text": "x"}),
            "blocker outside span": lambda f: f["blockers"].append({"address": "0x401500", "id": "Z", "text": "x"}),
            "blocker before span": lambda f: f["blockers"].append({"address": "0x400fff", "id": "Z", "text": "x"}),
            "duplicate blocker id": lambda f: f["blockers"].extend(
                [{"address": "0x401010", "id": "Z", "text": "x"}, {"address": "0x401020", "id": "Z", "text": "y"}]),
            "divergence flag not bool": lambda f: f["divergences"].append({"id": "D", "text": "x", "safety_rejection": 1}),
            "receipt review long": lambda f: f["evidence"].append(
                {"kind": "receipt", "slice": "X", "path": "analysis/a.json", "sha256": "0" * 64, "review": "x" * 500}),
        }
        for name, fn in mutations.items():
            with self.subTest(name):
                s = self.fresh()
                s.ev(0x401000, fn)
                with self.assertRaises(FL.LedgerError):
                    s.derive()

    def test_duplicate_evidence_function(self):
        self.s.edit("function-evidence.json", lambda d: d["functions"].append(copy.deepcopy(d["functions"][0])))
        self.fails()

    def test_unsorted_evidence_is_rejected(self):
        self.s.edit("function-evidence.json", lambda d: d["functions"].reverse())
        self.fails("sorted")

    def test_xrefs_items(self):
        mutations = {
            "non-index va": lambda f: f.update(va="0x401001"),
            "extra key": lambda f: f.update(extra=1),
            "missing key": lambda f: f.pop("callers"),
            "body zero": lambda f: f.update(body_size=0),
            "body past span": lambda f: f.update(body_size=0x101),
            "body float": lambda f: f.update(body_size=1.5),
            "body bool": lambda f: f.update(body_size=True),
            "part outside span": lambda f: f.update(derived_parts=["0x401200"]),
            "part is the start": lambda f: f.update(derived_parts=["0x401000"]),
            "part is the next start": lambda f: f.update(derived_parts=["0x401100"]),
            "bad caller": lambda f: f.update(callers=["main"]),
            "caller outside text": lambda f: f.update(callers=["0x500000000"]),
            "bad import": lambda f: f.update(imports=["bad name"]),
            "data_ref not bool": lambda f: f.update(data_ref=1),
            "eh parent non-index": lambda f: f.update(eh_parent="0x401001", eh_kind="unwind"),
            "eh parent self": lambda f: f.update(eh_parent="0x401000", eh_kind="unwind"),
            "eh kind without parent": lambda f: f.update(eh_kind="unwind"),
            "eh parent without kind": lambda f: f.update(eh_parent="0x401100", eh_kind=None),
            "bad eh kind": lambda f: f.update(eh_parent="0x401100", eh_kind="finally"),
            "bad origin": lambda f: f.update(origin="kernel"),
            "null origin": lambda f: f.update(origin=None),
            "thunk flag with game origin": lambda f: f.update(thunk=True, origin="game"),
            "eh origin without parent": lambda f: f.update(origin="compiler_eh"),
        }
        for name, fn in mutations.items():
            with self.subTest(name):
                s = self.fresh()
                s.xr(0x401000, fn)
                with self.assertRaises(FL.LedgerError):
                    s.derive()

    def test_xrefs_duplicate_and_inner_thunks(self):
        self.s.edit("function-xrefs.json", lambda d: d["functions"].append(copy.deepcopy(d["functions"][0])))
        self.fails()
        for name, fn in {
            "thunk parent non-index": lambda t: t.update(parent="0x401001"),
            "thunk outside parent span": lambda t: t.update(va="0x401500"),
            "thunk is an index start": lambda t: t.update(va="0x401100", parent="0x401000"),
            "thunk extra key": lambda t: t.update(x=1),
            "thunk bad import": lambda t: t.update({"import": ""}),
        }.items():
            with self.subTest(name):
                s = self.fresh()
                s.edit("function-xrefs.json", lambda d: fn(d["inner_thunks"][0]))
                with self.assertRaises(FL.LedgerError):
                    s.derive()

    def test_xrefs_parts_must_match_census_total(self):
        self.s.xr(0x401e00, lambda f: f.update(derived_parts=[]))
        self.fails("derived")

    def test_overrides_items(self):
        mutations = {
            "acceptance extra key": lambda d: d["port_acceptances"][0].update(extra=1),
            "acceptance bad class": lambda d: d["port_acceptances"][0].update({"class": "native_everything"}),
            "acceptance pending class": lambda d: d["port_acceptances"][0].update({"class": "candidate_port"}),
            "acceptance no reviewer": lambda d: d["port_acceptances"][0].update(reviewer=""),
            "acceptance bad date": lambda d: d["port_acceptances"][0].update(date="15/10/2026"),
            "acceptance no tests": lambda d: d["port_acceptances"][0].update(tests=[]),
            "acceptance duplicate va": lambda d: d["port_acceptances"].append(copy.deepcopy(d["port_acceptances"][0])),
            "acceptance non-index": lambda d: d["port_acceptances"][0].update(va="0x401001"),
            "entry bad reason": lambda d: d["not_needed_entries"][0].update(reason="because"),
            "entry has rule key": lambda d: d["not_needed_entries"][0].update(rule="R-LIB-INTERNAL"),
            "entry empty text": lambda d: d["not_needed_entries"][0].update(text=""),
            "entry duplicate va": lambda d: d["not_needed_entries"].append(copy.deepcopy(d["not_needed_entries"][0])),
            "entry non-index": lambda d: d["not_needed_entries"][0].update(va="0x401b01"),
            "rule unknown predicate": lambda d: d["not_needed_rules"][0].update(predicate="R-ANY"),
            "rule wrong reason": lambda d: d["not_needed_rules"][0].update(reason="unreachable_no_refs"),
            "rule duplicate id": lambda d: d["not_needed_rules"].append(copy.deepcopy(d["not_needed_rules"][0])),
            "rule extra key": lambda d: d["not_needed_rules"][0].update(covers="game"),
            "rule accepted not bool": lambda d: d["not_needed_rules"][0].update(accepted="yes"),
            "rule small sample": lambda d: d["not_needed_rules"][0]["sample_review"].update(n=58),
            "rule sample defects": lambda d: d["not_needed_rules"][0]["sample_review"].update(defects=1),
            "rule sample hash": lambda d: d["not_needed_rules"][0]["sample_review"].update(sample_sha256="abc"),
            "rule accepted without sample": lambda d: d["not_needed_rules"][0].update(sample_review=None),
            "rule accepted without reviewer": lambda d: d["not_needed_rules"][0].update(reviewer=""),
            "semantics non-index": lambda d: d["semantics_sensitive"].append({"va": "0x401001", "why": "x"}),
            "semantics duplicate": lambda d: d["semantics_sensitive"].append(copy.deepcopy(d["semantics_sensitive"][0])),
            "allowlist bad name": lambda d: d["win32_import_allowlist"]["names"].append("a b"),
            "allowlist no reviewer": lambda d: d["win32_import_allowlist"].update(reviewer=""),
            "unknown top key": lambda d: d.update(not_needed_game_rules=[]),
            "rule params on the library rule": lambda d: d["not_needed_rules"][0].update(
                parents_without_native_exception_path=[]),
        }
        for name, fn in mutations.items():
            with self.subTest(name):
                s = self.fresh()
                s.ov(fn)
                with self.assertRaises(FL.LedgerError):
                    s.derive()

    def test_unaccepted_rules_are_inert_drafts(self):
        def draft(d):
            for r in d["not_needed_rules"]:
                r["accepted"] = False
                r["sample_review"] = None
        self.s.ov(draft)
        ledger = self.s.derive()
        self.assertEqual(ledger["counts"]["class"]["nn_rule"], 0)
        by = by_va(ledger)
        self.assertEqual((by[0x406800]["status"], by[0x407300]["status"]), ("pending", "pending"))


# ----------------------------------------------------- port acceptance (rule 3) --

class PortAcceptanceTests(ScratchCase):
    def acceptance(self, va, fn):
        def go(d):
            for a in d["port_acceptances"]:
                if int(a["va"], 16) == va:
                    fn(a)
        self.s.ov(go)

    def status(self, va):
        return by_va(self.s.derive())[va]["status"]

    def test_fixture_acceptances_are_ported(self):
        self.assertEqual(self.status(0x401a00), "ported")

    def test_deleting_the_evidence_citation_fails_closed(self):
        self.s.ev(0x401000, lambda f: f["evidence"].pop(0))
        self.fails("native_source")

    def test_deleting_the_test_citation_fails_closed(self):
        self.s.ev(0x401100, lambda f: f["evidence"].pop(1))
        self.fails("test")

    def test_deleting_the_oracle_pointer_fails_closed(self):
        self.s.ev(0x401000, lambda f: f["evidence"].pop(2))
        self.fails("oracle")

    def test_oracle_class_needs_an_oracle(self):
        self.acceptance(0x401000, lambda a: a.update(oracle=None))
        self.fails("oracle")

    def test_other_classes_must_not_name_an_oracle(self):
        self.acceptance(0x401100, lambda a: a.update(
            oracle={"path": "tests/fixture_core_oracle.py", "window": ["0x401100", "0x401300"]}))
        self.fails()

    def test_address_missing_from_the_symbol_fails(self):
        self.acceptance(0x401000, lambda a: a["native_source"].update(symbol="fixture_partial"))
        self.s.ev(0x401000, lambda f: f["evidence"][0].update(symbol="fixture_partial"))
        self.fails("0x401000")

    def test_address_only_in_another_symbol_is_not_enough(self):
        self.acceptance(0x401100, lambda a: a["native_source"].update(symbol="fixture_entry"))
        self.s.ev(0x401100, lambda f: f["evidence"][0].update(symbol="fixture_entry"))
        self.fails("0x401100")

    def test_address_in_leading_comment_counts(self):
        self.assertEqual(self.status(0x401000), "ported")      # only in the comment above the function

    def test_address_in_body_comment_counts_in_any_hex_spelling(self):
        self.assertEqual(self.status(0x401100), "ported")      # FUN_00401100 inside the body

    def test_interior_address_does_not_satisfy_the_citation(self):
        self.s.text("src/fixture_core.c", lambda t: t.replace(
            "Native port of 0x401000 (fixture entry point)", "Native port of 0x401004 (fixture entry point)"))
        self.s.resync_evidence_hashes()
        self.fails("0x401000")

    def test_symbol_must_exist(self):
        self.acceptance(0x401000, lambda a: a["native_source"].update(symbol="no_such_symbol"))
        self.s.ev(0x401000, lambda f: f["evidence"][0].update(symbol="no_such_symbol"))
        self.fails("no_such_symbol")

    def test_preprocessor_conditional_in_scanned_symbol_is_rejected(self):
        self.s.text("src/fixture_core.c", lambda t: t.replace(
            "    return value + 1u;", "#if 1\n    return value + 1u;\n#endif"))
        self.s.resync_evidence_hashes()
        self.fails("preprocessor")

    def test_test_must_reference_symbol_or_module(self):
        self.acceptance(0x401000, lambda a: a.update(tests=[
            {"path": "tests/fixture_core_tests.py", "test_id": "test_unrelated"}]))
        self.s.ev(0x401000, lambda f: f["evidence"][1].update(test_id="test_unrelated"))
        self.fails("reference")

    def test_test_id_must_exist_in_the_file(self):
        self.acceptance(0x401000, lambda a: a.update(tests=[
            {"path": "tests/fixture_core_tests.py", "test_id": "test_missing"}]))
        self.s.ev(0x401000, lambda f: f["evidence"][1].update(test_id="test_missing"))
        self.fails("test_missing")

    def test_acceptance_test_must_be_in_the_evidence(self):
        self.acceptance(0x401000, lambda a: a["tests"][0].update(test_id="test_with_parts"))
        self.fails("evidence")

    def test_edited_test_file_goes_stale(self):
        self.s.text("tests/fixture_core_tests.py", lambda t: t + "\n# edited\n")
        self.fails("sha256")

    def test_edited_source_file_goes_stale(self):
        self.s.text("src/fixture_core.c", lambda t: t + "\n/* edited */\n")
        self.fails("sha256")

    def test_edited_oracle_file_goes_stale(self):
        self.s.text("tests/fixture_core_oracle.py", lambda t: t + "\n# edited\n")
        self.fails("sha256")

    def test_mapped_only_window_never_qualifies(self):
        self.s.ev(0x401340, lambda f: f["evidence"][2].update(use="mapped"))
        self.fails("mapped")

    def test_unknown_use_value_is_not_accepted(self):
        self.s.ev(0x401340, lambda f: f["evidence"][2].update(use="covers"))
        self.fails()

    def test_window_must_cover_the_whole_body(self):
        self.s.ev(0x401000, lambda f: f["evidence"][2].update(window=["0x401000", "0x4010ef"]))
        self.acceptance(0x401000, lambda a: a["oracle"].update(window=["0x401000", "0x4010ef"]))
        self.fails("cover")

    def test_window_must_start_at_or_before_the_function(self):
        self.s.ev(0x401000, lambda f: f["evidence"][2].update(window=["0x401001", "0x401100"]))
        self.acceptance(0x401000, lambda a: a["oracle"].update(window=["0x401001", "0x401100"]))
        self.fails("cover")

    def test_va_size_window_shape_is_rejected(self):
        # A (va, size) pair reads as end_exclusive < start; it must never be accepted.
        self.s.ev(0x401000, lambda f: f["evidence"][2].update(window=["0x401000", "0xf0"]))
        self.acceptance(0x401000, lambda a: a["oracle"].update(window=["0x401000", "0xf0"]))
        self.fails()

    def test_oracle_class_needs_a_known_body_size(self):
        self.s.xr(0x401000, lambda f: f.update(body_size=None))
        self.fails("body_size")

    def test_oracle_class_without_xrefs_fails(self):
        self.s.path("function-xrefs.json").unlink()
        self.fails()

    def test_acceptance_oracle_window_must_match_evidence(self):
        self.acceptance(0x401000, lambda a: a["oracle"].update(window=["0x401000", "0x401200"]))
        self.fails("evidence")

    def test_open_blocker_keeps_the_function_out(self):
        self.s.ev(0x401000, lambda f: f["blockers"].append(
            {"address": "0x401040", "id": "U9", "text": "interior branch unverified"}))
        self.fails("blocker")

    def test_blocker_at_the_exact_start_also_blocks(self):
        self.s.ev(0x401000, lambda f: f["blockers"].append({"address": "0x401000", "id": "U9", "text": "x"}))
        self.fails("blocker")

    def test_blocker_covered_by_a_non_safety_divergence_still_blocks(self):
        self.s.ev(0x401a00, lambda f: f["divergences"][0].update(safety_rejection=False))
        self.fails("blocker")

    def test_blocker_with_a_matching_safety_divergence_is_allowed(self):
        self.assertEqual(self.status(0x401a00), "ported")

    def test_derived_part_must_be_accounted(self):
        self.acceptance(0x401340, lambda a: a.update(parts_accounted=["0x401380"]))
        self.fails("0x4013a0")

    def test_thunk_part_must_be_accounted(self):
        self.acceptance(0x401340, lambda a: a.update(parts_accounted=["0x4013a0"]))
        self.fails("0x401380")

    def test_accounting_unknown_parts_is_an_error(self):
        self.acceptance(0x401340, lambda a: a.update(parts_accounted=["0x401380", "0x4013a0", "0x4013b0"]))
        self.fails("0x4013b0")

    def test_derived_part_address_must_be_in_the_symbol(self):
        self.s.text("src/fixture_core.c", lambda t: t.replace("0x004013a0", "0x004013a1"))
        self.s.resync_evidence_hashes()
        self.fails("0x4013a0")

    def test_tests_only_and_adapter_need_a_test(self):
        self.s.ev(0x406000, lambda f: f["evidence"].pop(1))
        self.fails("test")

    def test_non_index_acceptance(self):
        self.acceptance(0x401000, lambda a: a.update(va="0x401004"))
        self.fails()

    def add_acceptance(self, va):
        def go(d):
            a = copy.deepcopy(d["port_acceptances"][1])
            a["va"] = hx(va)
            d["port_acceptances"].append(a)
            d["port_acceptances"].sort(key=lambda x: int(x["va"], 16))
        self.s.ov(go)

    def test_vorbis_stays_pending(self):
        self.add_acceptance(0x404800)
        self.fails("vorbis")

    def test_unsplit_span_and_fall_through_fragment_stay_pending(self):
        for va in (0x407a00, 0x401e00):
            with self.subTest(va=hex(va)):
                s = self.fresh()
                self.s = s
                self.add_acceptance(va)
                with self.assertRaises(FL.LedgerError):
                    s.derive()

    def test_ported_and_not_needed_at_once(self):
        self.s.ov(lambda d: d["not_needed_entries"].insert(
            0, {"va": "0x401000", "reason": "unreachable_no_refs", "text": "x",
                "reviewer": "r", "date": "2026-10-15"}))
        self.fails("both")


# ------------------------------------------------ not_needed entries and rules --

class NotNeededTests(ScratchCase):
    def add_entry(self, va, reason, text="reviewed", s=None):
        def go(d):
            d["not_needed_entries"].append({"va": hx(va), "reason": reason, "text": text,
                                            "reviewer": "r", "date": "2026-10-15"})
            d["not_needed_entries"].sort(key=lambda e: int(e["va"], 16))
        (s or self.s).ov(go)

    def status(self, va, s=None):
        e = by_va((s or self.s).derive())[va]
        return e["status"], e["class"]

    def test_closed_enums(self):
        self.assertEqual(set(FL.REASONS), {
            "win32_plumbing_no_observable_effect", "crt_startup_termination",
            "library_internal_unreached_by_game", "host_libc_standard_contract",
            "debug_diagnostic_only", "unreachable_no_refs", "compiler_eh_funclet"})
        self.assertEqual(set(FL.PREDICATES), {"R-EH", "R-LIB-INTERNAL"})
        self.assertEqual(set(FL.PORTED_CLASSES), {"native_oracle_verified", "native_tests_only", "host_adapter_tested"})
        self.assertEqual(set(FL.NOT_NEEDED_CLASSES), {"nn_rule", "nn_reviewed"})
        self.assertEqual(set(FL.PENDING_CLASSES), {"candidate_port", "partial_native", "static_navigation_only", "none"})
        self.assertEqual(FL.SAMPLE_MIN, 59)

    def test_unreachable_no_refs_needs_zero_callers_and_no_data_ref(self):
        self.s.xr(0x401b00, lambda f: f.update(callers=["0x401000"]))
        self.fails("unreachable_no_refs")
        s = self.fresh()
        s.xr(0x401b00, lambda f: f.update(data_ref=True))
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_not_needed_needs_xrefs_to_prove_its_precondition(self):
        self.s.path("function-xrefs.json").unlink()
        self.fails()

    def test_win32_plumbing_import_must_be_allowlisted(self):
        self.s.xr(0x401d00, lambda f: f.update(imports=["CreateFileA"]))
        self.fails("allowlist")

    def test_win32_plumbing_rejects_pending_or_ported_game_callees(self):
        self.s.xr(0x401d00, lambda f: f.update(callees=["0x401800"]))
        self.fails("callee")
        s = self.fresh()
        s.xr(0x401d00, lambda f: f.update(callees=["0x401000"]))
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_win32_plumbing_without_any_allowlist_fails(self):
        self.s.ov(lambda d: d.pop("win32_import_allowlist"))
        self.fails("allowlist")

    def test_win32_plumbing_with_no_imports_fails(self):
        self.s.xr(0x401d00, lambda f: f.update(imports=[]))
        self.fails()

    def test_debug_only_needs_debug_imports(self):
        self.s.xr(0x401c00, lambda f: f.update(imports=["OutputDebugStringA", "CreateFileA"]))
        self.fails("debug")

    def test_debug_only_rejects_pending_game_callees(self):
        self.s.xr(0x401c00, lambda f: f.update(callees=["0x401800"]))
        self.fails("callee")

    def test_compiler_eh_entry_needs_a_funclet(self):
        self.add_entry(0x407900, "compiler_eh_funclet")
        self.fails("funclet")

    def test_compiler_eh_entry_loses_its_funclet_proof(self):
        self.s.xr(0x407500, lambda f: f.update(eh_parent=None, eh_kind=None, origin="library"))
        self.fails("funclet")

    def test_crt_startup_is_not_for_game_code_or_game_called_code(self):
        self.s.xr(0x407700, lambda f: f.update(callers=["0x401000"]))
        self.fails("crt_startup_termination")
        s = self.fresh()
        self.add_entry(0x401e00, "crt_startup_termination", s=s)
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_host_libc_needs_library_origin_in_crt_region(self):
        self.s.xr(0x407800, lambda f: f.pop("origin"))
        self.fails("host_libc_standard_contract")

    def test_library_internal_entry_uses_the_same_reachability_proof(self):
        self.add_entry(0x407200, "library_internal_unreached_by_game")   # data referenced
        self.fails("library_internal")
        s = self.fresh()
        self.add_entry(0x407000, "library_internal_unreached_by_game", s=s)   # reaches game code
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_vorbis_stays_pending_for_not_needed_too(self):
        self.add_entry(0x404800, "unreachable_no_refs")
        self.fails("vorbis")

    def test_entry_and_rule_on_the_same_function_conflict(self):
        self.add_entry(0x406800, "library_internal_unreached_by_game")
        self.fails("rule")

    def test_entry_non_index(self):
        self.s.ov(lambda d: d["not_needed_entries"][0].update(va="0x401b01"))
        self.fails()

    def test_game_region_entries_stay_per_function_nn_reviewed(self):
        by = by_va(self.s.derive())
        for va in (0x401b00, 0x401c00, 0x401d00):
            self.assertEqual((by[va]["region"], by[va]["class"]), ("game", "nn_reviewed"))
            self.assertIsNone(by[va]["reason"]["rule"])

    def test_rule_never_selects_game_code_even_with_perfect_library_evidence(self):
        self.s.xr(0x401800, lambda f: f.update(origin="library", callers=[], callees=[], data_ref=False))
        self.assertEqual(self.status(0x401800)[0], "pending")

    def test_rule_never_selects_vorbis(self):
        self.assertEqual(self.status(0x404800)[0], "pending")      # origin library, no refs, still pending

    def test_rule_excludes_seam_functions(self):
        def go(d):
            d["port_acceptances"] = [a for a in d["port_acceptances"] if a["va"] != "0x406000"]
            d["semantics_sensitive"] = [x for x in d["semantics_sensitive"] if x["va"] != "0x406000"]
        self.s.ov(go)
        self.s.xr(0x406000, lambda f: f.update(callers=[]))
        self.s.ev(0x406000, lambda f: f["evidence"].clear())
        e = by_va(self.s.derive())[0x406000]
        self.assertTrue(e["seam"])
        self.assertEqual(e["status"], "pending")

    def test_rule_excludes_semantics_sensitive(self):
        self.s.xr(0x407900, lambda f: f.update(origin="library"))
        self.assertEqual(self.status(0x407900), ("pending", "none"))
        s = self.fresh()
        s.ov(lambda d: d["semantics_sensitive"].pop(1))
        self.assertEqual(self.status(0x407900, s), ("not_needed", "nn_rule"))

    def test_rule_excludes_any_function_with_evidence(self):
        def add(doc):
            doc["functions"].append({"va": "0x406800", "evidence": [
                {"kind": "mention", "path": "src/fixture_core.c", "symbol": None}], "blockers": [], "divergences": []})
            doc["functions"].sort(key=lambda f: int(f["va"], 16))
        self.s.edit("function-evidence.json", add)
        self.assertEqual(self.status(0x406800), ("pending", "static_navigation_only"))

    def test_library_rule_excludes_reached_from_game_and_path_back_to_game(self):
        self.assertEqual(self.status(0x407100)[0], "pending")      # called by a game function
        self.assertEqual(self.status(0x407000)[0], "pending")      # calls back into game code
        self.assertEqual(self.status(0x407200)[0], "pending")      # data referenced

    def test_library_rule_follows_transitive_callees_from_game(self):
        self.s.xr(0x407100, lambda f: f.update(callees=["0x406800"]))     # game -> 0x407100 -> 0x406800
        self.assertEqual(self.status(0x406800)[0], "pending")

    def test_library_rule_follows_a_path_back_to_game_through_a_chain(self):
        self.s.xr(0x406800, lambda f: f.update(callees=["0x407200"]))
        self.s.xr(0x407200, lambda f: f.update(callees=["0x401800"]))
        self.assertEqual(self.status(0x406800)[0], "pending")

    def test_data_referenced_function_acts_as_a_root(self):
        self.s.xr(0x407200, lambda f: f.update(callees=["0x406800"]))     # may run through the data reference
        self.assertEqual(self.status(0x406800)[0], "pending")

    def test_library_rule_needs_library_origin_from_xrefs(self):
        self.s.xr(0x406800, lambda f: f.pop("origin"))
        self.assertEqual(self.status(0x406800)[0], "pending")

    def test_eh_rule_needs_a_ported_parent_or_a_ruled_parent(self):
        self.assertEqual(self.status(0x407300)[0], "not_needed")      # parent 0x401000 is ported
        self.assertEqual(self.status(0x407400)[0], "pending")         # parent 0x401800 is pending

        def rule(d):
            for r in d["not_needed_rules"]:
                if r["id"] == "R-EH":
                    r["parents_without_native_exception_path"] = ["0x401800"]
        self.s.ov(rule)
        self.assertEqual(self.status(0x407400), ("not_needed", "nn_rule"))

    def test_eh_rule_ruled_parent_must_be_an_index_start(self):
        def rule(d):
            for r in d["not_needed_rules"]:
                if r["id"] == "R-EH":
                    r["parents_without_native_exception_path"] = ["0x401801"]
        self.s.ov(rule)
        self.fails()

    def test_eh_rule_never_covers_catch_funclets(self):
        self.s.ov(lambda d: d["not_needed_entries"].pop(3))      # drop the reviewed Catch@ entry
        self.assertEqual(self.status(0x407500)[0], "pending")

    def test_eh_rule_does_not_apply_in_the_game_region(self):
        self.s.xr(0x401800, lambda f: f.update(eh_parent="0x401000", eh_kind="unwind", origin="compiler_eh"))
        self.assertEqual(self.status(0x401800)[0], "pending")

    def test_rule_sample_gate(self):
        for changes in ({"n": 58}, {"defects": 1}):
            with self.subTest(changes=changes):
                s = self.fresh()
                s.ov(lambda d: d["not_needed_rules"][0]["sample_review"].update(changes))
                with self.assertRaises(FL.LedgerError):
                    s.derive()


class PendingClassTests(ScratchCase):
    def cls(self, va):
        return by_va(self.s.derive())[va]["class"]

    def test_class_precedence(self):
        self.assertEqual(self.cls(0x4014c0), "candidate_port")
        self.s.ev(0x4014c0, lambda f: f["evidence"].pop(0))      # drop the citation: only a mapped window remains
        self.assertEqual(self.cls(0x4014c0), "partial_native")

    def test_short_window_is_partial_not_candidate(self):
        self.s.ev(0x401900, lambda f: f["evidence"][1].update(window=["0x401900", "0x401950"]))
        self.assertEqual(self.cls(0x401900), "partial_native")

    def test_unknown_body_size_cannot_be_a_candidate(self):
        self.s.xr(0x4014c0, lambda f: f.update(body_size=None))
        self.assertEqual(self.cls(0x4014c0), "partial_native")

    def test_a_name_is_never_evidence(self):
        self.s.edit("function-index.json", lambda d: d["functions"][7].update(name="fixture_entry_port"))
        e = by_va(self.s.derive())[0x401800]
        self.assertEqual((e["status"], e["class"]), ("pending", "none"))

    def test_receipt_only_is_static_navigation(self):
        self.s.ev(0x401700, lambda f: f["evidence"].pop(0))
        self.assertEqual(self.cls(0x401700), "static_navigation_only")

    def test_unverified_blocker_does_not_change_pending_class(self):
        e = by_va(self.s.derive())[0x401900]
        self.assertEqual(e["class"], "candidate_port")
        self.assertEqual(len(e["blockers"]), 1)

    def test_pending_entries_have_no_reason_or_review(self):
        for e in self.s.derive()["entries"]:
            if e["status"] == "pending":
                self.assertIsNone(e["reason"])
                self.assertIsNone(e["review"])


# ----------------------------------------------------------- private receipts --

class PrivateReceiptTests(ScratchCase):
    def make_receipts(self, match):
        work = self.s.root / "work"
        (work / "analysis/slices").mkdir(parents=True)
        for slice_ in ("FIX-1", "FIX-2"):
            p = work / f"analysis/slices/{slice_}.handoff.json"
            p.write_bytes(f"r-{slice_}".encode())
            if match:
                def fix(doc, slice_=slice_, p=p):
                    for f in doc["functions"]:
                        for ptr in f["evidence"]:
                            if ptr["kind"] == "receipt" and ptr["slice"] == slice_:
                                ptr["sha256"] = sha_file(p)
                self.s.edit("function-evidence.json", fix)
        return work

    def test_not_checked_by_default(self):
        self.s.derive(work_dir=self.s.root / "no-such-work")

    def test_verify_private_detects_a_changed_receipt(self):
        work = self.make_receipts(match=False)
        self.fails("receipt", work_dir=work, verify_private=True)

    def test_verify_private_passes_when_hashes_match(self):
        work = self.make_receipts(match=True)
        self.s.derive(work_dir=work, verify_private=True)

    def test_verify_private_missing_receipt(self):
        self.fails("receipt", work_dir=self.s.root / "work", verify_private=True)


# ------------------------------------------------------- committed-ledger checks --

class StaleLedgerTests(ScratchCase):
    def written(self):
        path = self.s.root / "function-ledger.json"
        path.write_text(FL.render(self.s.derive()))
        return path

    def check(self, path=None):
        FL.check(self.s.root, path or self.s.root / "function-ledger.json", expected_functions=FIXTURE_FUNCTIONS)

    def stale(self):
        with self.assertRaises(FL.LedgerError) as ctx:
            self.check()
        self.assertIn("function ledger stale; rerun scripts/build_function_ledger.py --write", str(ctx.exception))

    def test_fresh_ledger_passes(self):
        self.written()
        self.check()

    def test_new_batch_makes_it_stale(self):
        self.written()
        batch = json.loads(self.s.path("asm/batch-001.json").read_text())
        batch["batch"] = "002"
        fn = batch["functions"][0]
        fn.update(function="FUN_00401340", va="0x00401340")
        fn["code"].update(symbol="FUN_00401340", rva=0x1340, size=0x170)
        fn["data_items"] = []
        self.s.path("asm/batch-002.json").write_text(json.dumps(batch, indent=1) + "\n")
        self.s.path("asm/batch-002-report.json").write_text(json.dumps({
            "batch": "002", "original_sha256": PIN, "class_requested": "tool_assisted_reconstructed_assembly",
            "manifest_sha256": sha_file(self.s.path("asm/batch-002.json")), "all_accepted": True, "errors": []}))
        self.stale()

    def test_edited_test_file_fails_closed(self):
        self.written()
        self.s.text("tests/fixture_core_tests.py", lambda t: t + "\n# edit\n")
        with self.assertRaises(FL.LedgerError):
            self.check()

    def test_any_changed_input_makes_it_stale(self):
        self.written()
        self.s.edit("function-index.json", lambda d: d["functions"][0].update(name="renamed"))
        self.stale()

    def test_hand_edited_entries_are_rejected(self):
        path = self.written()
        data = json.loads(path.read_text())
        data["entries"][2]["name"] = "FUN_hand_edited"
        path.write_text(json.dumps(data))
        with self.assertRaises(FL.LedgerError):
            self.check(path)

    def test_unparseable_or_missing_ledger(self):
        path = self.s.root / "function-ledger.json"
        with self.assertRaises(FL.LedgerError):
            self.check(path)
        path.write_text("{")
        with self.assertRaises(FL.LedgerError):
            self.check(path)


# --------------------------------------------------------- ledger-only validator --

class ValidatorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.good = fixture_derive()

    def entry(self, data, va):
        return by_va(data)[va]

    def rejects(self, fn, fragment=None):
        data = copy.deepcopy(self.good)
        out = fn(data)
        data = data if out is None else out
        with self.assertRaises(FL.LedgerError) as ctx:
            FL.validate(data)
        if fragment:
            self.assertIn(fragment, str(ctx.exception))

    def test_good_ledger_validates(self):
        self.assertEqual(FL.validate(copy.deepcopy(self.good))["schema"], "blackmoor-function-ledger/1")

    def test_top_level_shape(self):
        self.rejects(lambda d: d.update(extra=1))
        self.rejects(lambda d: d.update(schema="blackmoor-function-ledger/2"))
        self.rejects(lambda d: d.update(original_sha256="0" * 64))
        self.rejects(lambda d: d.pop("counts"))
        self.rejects(lambda d: d.update(entries={}))

    def test_entry_shape(self):
        self.rejects(lambda d: d["entries"][0].update(extra=1))
        self.rejects(lambda d: d["entries"][0].pop("seam"))
        self.rejects(lambda d: d["entries"][0].update(va="401000"))
        self.rejects(lambda d: d["entries"][0].update(span=0))
        self.rejects(lambda d: d["entries"][0].update(span=True))
        self.rejects(lambda d: d["entries"][0].update(region="mfc"))
        self.rejects(lambda d: d["entries"][0].update(origin="vendor"))
        self.rejects(lambda d: d["entries"][0].update(seam="no"))
        self.rejects(lambda d: d["entries"][0].update(status="done"))

    def test_sorted_unique_and_contiguous(self):
        self.rejects(lambda d: d["entries"].reverse(), "sorted")
        self.rejects(lambda d: d["entries"].append(copy.deepcopy(d["entries"][-1])))
        self.rejects(lambda d: d["entries"].pop(3), "span")
        self.rejects(lambda d: d["entries"][3].update(span=d["entries"][3]["span"] + 1), "span")

    def test_regions_are_ordered(self):
        self.rejects(lambda d: self.entry(d, 0x404800).update(region="game"), "region")

    def test_status_class_pairs(self):
        self.rejects(lambda d: self.entry(d, 0x401000).update(status="pending"))
        self.rejects(lambda d: self.entry(d, 0x401800).update({"class": "native_tests_only"}))
        self.rejects(lambda d: self.entry(d, 0x401b00).update({"class": "candidate_port"}))
        self.rejects(lambda d: self.entry(d, 0x401800).update(status="ported"))
        self.rejects(lambda d: self.entry(d, 0x401800).update(status="not_needed", reason=None))

    def test_ported_needs_its_evidence(self):
        def drop(kind):
            def go(d):
                e = self.entry(d, 0x401000)
                e["evidence"] = [p for p in e["evidence"] if p["kind"] != kind]
            return go
        self.rejects(drop("native_source"))
        self.rejects(drop("test"))
        self.rejects(drop("oracle"))
        self.rejects(lambda d: self.entry(d, 0x401340)["evidence"][1].update(use="mapped"), "mapped")
        self.rejects(lambda d: self.entry(d, 0x401340)["evidence"][1].update(window=["0x401340", "0x401400"]), "cover")
        self.rejects(lambda d: self.entry(d, 0x401000).update(review=None))
        self.rejects(lambda d: self.entry(d, 0x401000).update(reason={"code": "x", "text": "x", "rule": None}))

    def test_open_blocker_on_ported_entry(self):
        self.rejects(lambda d: self.entry(d, 0x401000)["blockers"].append(
            {"address": "0x401040", "id": "U9", "text": "x"}), "blocker")

    def test_blocker_with_non_safety_divergence_on_ported_entry(self):
        self.rejects(lambda d: self.entry(d, 0x401a00)["divergences"][0].update(safety_rejection=False), "blocker")

    def test_blocker_address_must_be_in_span(self):
        self.rejects(lambda d: self.entry(d, 0x401900)["blockers"][0].update(address="0x402000"), "span")
        self.rejects(lambda d: self.entry(d, 0x401900)["blockers"][0].update(address="0x4018ff"), "span")

    def test_derived_parts_inside_span_and_sorted(self):
        self.rejects(lambda d: self.entry(d, 0x401340).update(derived_parts=["0x401500"]))
        self.rejects(lambda d: self.entry(d, 0x401340).update(derived_parts=["0x4013a0", "0x401380"]), "sorted")

    def test_body_size_bounds(self):
        self.rejects(lambda d: self.entry(d, 0x401000).update(body_size=0x101))
        self.rejects(lambda d: self.entry(d, 0x401000).update(body_size=0))

    def test_rule_based_not_needed_never_in_game_region(self):
        def go(d):
            e = self.entry(d, 0x401b00)
            e.update({"class": "nn_rule"})
            e["reason"]["rule"] = "R-LIB-INTERNAL"
            e["review"]["sample"] = "a" * 64
        self.rejects(go, "game")

    def test_rule_based_not_needed_never_on_seam_or_with_evidence_or_vorbis(self):
        self.rejects(lambda d: self.entry(d, 0x406800).update(seam=True), "seam")
        self.rejects(lambda d: self.entry(d, 0x406800)["evidence"].append(
            {"kind": "mention", "path": "src/a.c", "symbol": None}), "evidence")

        def vorbis(d):
            e = self.entry(d, 0x404800)
            e.update(status="not_needed")
            e.update({"class": "nn_rule"})
            e["reason"] = {"code": "library_internal_unreached_by_game", "text": "x", "rule": "R-LIB-INTERNAL"}
            e["review"] = {"reviewer": "r", "date": "2026-10-15", "sample": "a" * 64}
        self.rejects(vorbis, "vorbis")

    def test_vorbis_never_leaves_pending(self):
        def go(d):
            e = self.entry(d, 0x404800)
            e["status"] = "ported"
            e["class"] = "native_tests_only"
        self.rejects(go, "vorbis")

    def test_reason_and_rule_consistency(self):
        self.rejects(lambda d: self.entry(d, 0x406800)["reason"].update(code="unreachable_no_refs"))
        self.rejects(lambda d: self.entry(d, 0x406800)["reason"].update(rule=None))
        self.rejects(lambda d: self.entry(d, 0x401b00)["reason"].update(rule="R-EH"))
        self.rejects(lambda d: self.entry(d, 0x406800)["reason"].update(rule="R-NOPE"))
        self.rejects(lambda d: self.entry(d, 0x401b00)["reason"].update(code="because"))
        self.rejects(lambda d: self.entry(d, 0x406800)["review"].update(sample=None))
        self.rejects(lambda d: self.entry(d, 0x401b00)["review"].update(sample="a" * 64))

    def test_compiler_eh_rule_only_for_eh_origin(self):
        self.rejects(lambda d: self.entry(d, 0x407300).update(origin="library"))

    def test_x86_match_shape_and_orthogonality(self):
        self.rejects(lambda d: self.entry(d, 0x401100)["x86_match"].update(complete="yes"))
        self.rejects(lambda d: self.entry(d, 0x401100)["x86_match"].update(extra=1))
        self.rejects(lambda d: self.entry(d, 0x401100)["x86_match"].update(manifest="/abs/batch.json"))
        # An x86 match neither promotes nor demotes a function.
        self.rejects(lambda d: (self.entry(d, 0x401800).update(
            x86_match={"provenance": "tool_assisted_reconstructed_assembly", "complete": True,
                       "manifest": "asm/batch-001.json"}), self.entry(d, 0x401800).update(status="ported")))
        data = copy.deepcopy(self.good)
        self.entry(data, 0x401800)["x86_match"] = {"provenance": "tool_assisted_reconstructed_assembly",
                                                   "complete": True, "manifest": "asm/batch-001.json"}
        data["counts"]["x86"]["matched"] += 1
        data["counts"]["x86"]["complete"] += 1
        FL.validate(data)

    def test_evidence_pointer_shape_in_ledger(self):
        self.rejects(lambda d: self.entry(d, 0x401000)["evidence"][0].update(path="/Users/x/y.c"))
        self.rejects(lambda d: self.entry(d, 0x401000)["evidence"][0].update(line=7))
        self.rejects(lambda d: self.entry(d, 0x401000)["evidence"][0].update(kind="guess"))
        self.rejects(lambda d: self.entry(d, 0x401000)["evidence"][0].update(sha256="12"))
        self.rejects(lambda d: self.entry(d, 0x401000)["evidence"].append(
            copy.deepcopy(self.entry(d, 0x401000)["evidence"][0])), "duplicate")

    def test_counts_must_equal_the_entries(self):
        self.rejects(lambda d: d["counts"]["status"].update(ported=4))
        self.rejects(lambda d: d["counts"]["class"].update(none=14))
        self.rejects(lambda d: d["counts"]["region"]["game"].update(ported=3))
        self.rejects(lambda d: d["counts"].update(total=29))
        self.rejects(lambda d: d["counts"].update(seam=3))
        self.rejects(lambda d: d["counts"]["x86"].update(matched=2))
        self.rejects(lambda d: d["counts"]["reason"].update(unreachable_no_refs=0))
        self.rejects(lambda d: d["counts"]["origin"].update(game=0))
        self.rejects(lambda d: d["counts"]["span_bytes"].update(ported=1))
        self.rejects(lambda d: d["counts"].update(extra=1))
        self.rejects(lambda d: d["counts"]["status"].pop("pending"))

    def test_inputs_shape(self):
        self.rejects(lambda d: d["inputs"][0].update(path="/abs/x.json"))
        self.rejects(lambda d: d["inputs"][0].update(sha256="x"))
        self.rejects(lambda d: d["inputs"][0].update(extra=1))
        self.rejects(lambda d: d["inputs"].append(copy.deepcopy(d["inputs"][0])))
        self.rejects(lambda d: d["inputs"].reverse(), "sorted")

    def test_ported_entry_cannot_carry_a_not_needed_reason(self):
        self.rejects(lambda d: self.entry(d, 0x401000).update(
            reason={"code": "unreachable_no_refs", "text": "x", "rule": None}))

    def test_json_types_are_exact(self):
        self.rejects(lambda d: self.entry(d, 0x401000).update(span=256.0))
        self.rejects(lambda d: d["counts"].update(total=30.0))


# ------------------------------------------------------------- real repository --

class RepositoryLedgerTests(unittest.TestCase):
    """The committed function-ledger.json against the committed inputs."""

    @classmethod
    def setUpClass(cls):
        cls.path = OUT / "function-ledger.json"

    def test_ledger_is_committed(self):
        self.assertTrue(self.path.exists(), "run scripts/build_function_ledger.py --write")

    def test_validates_and_is_current(self):
        FL.check(OUT, self.path)

    def test_universe(self):
        data = json.loads(self.path.read_text())
        FL.validate(data)
        self.assertEqual(len(data["entries"]), 4188)
        self.assertEqual(data["counts"]["total"], 4188)
        self.assertEqual(sum(e["span"] for e in data["entries"]), 1213018)
        regions = {r: sum(1 for e in data["entries"] if e["region"] == r) for r in ("game", "vorbis", "crt_mfc")}
        self.assertEqual(regions, {"game": 2507, "vorbis": 178, "crt_mfc": 1503})
        last = data["entries"][-1]
        self.assertEqual(last["span"], 0x52925a - int(last["va"], 16))
        self.assertEqual(data["original_sha256"], PIN)

    def test_one_entry_per_line_sorted_by_va(self):
        text = self.path.read_text()
        lines = [l for l in text.splitlines() if l.startswith('{"va"')]
        self.assertEqual(len(lines), 4188)
        vas = [int(json.loads(l.rstrip(","))["va"], 16) for l in lines]
        self.assertEqual(vas, sorted(vas))
        self.assertNotIn("/Users/", text)

    def test_vorbis_all_pending(self):
        data = json.loads(self.path.read_text())
        self.assertEqual({e["status"] for e in data["entries"] if e["region"] == "vorbis"}, {"pending"})

    def test_baseline_without_extractor_inputs(self):
        data = json.loads(self.path.read_text())
        absent = [p for p in ("function-evidence.json", "function-xrefs.json", "function-ledger-overrides.json")
                  if not (OUT / p).exists()]
        if len(absent) != 3:
            self.skipTest("extractor inputs have landed; the v0 baseline no longer applies")
        self.assertEqual(data["counts"]["status"], {"ported": 0, "not_needed": 0, "pending": 4188})
        self.assertEqual(data["counts"]["class"]["none"], 4188)
        self.assertEqual({e["origin"] for e in data["entries"]}, {"unknown"})
        self.assertTrue(all(e["evidence"] == [] and e["body_size"] is None for e in data["entries"]))

    def test_nothing_is_ported_or_not_needed_without_overrides(self):
        data = json.loads(self.path.read_text())
        if (OUT / "function-ledger-overrides.json").exists():
            self.skipTest("overrides present")
        self.assertEqual([e for e in data["entries"] if e["status"] != "pending"], [])


# ------------------------------------------------------------------------ CLI --

class CliTests(ScratchCase):
    def run_cli(self, *args):
        return subprocess.run([sys.executable, str(SCRIPT), *args], capture_output=True, text=True)

    def fx(self, *args):
        return self.run_cli("--root", str(self.s.root), "--expected-functions", "30", *args)

    def test_check_real_repository(self):
        proc = self.run_cli("--check")
        self.assertEqual(proc.returncode, 0, proc.stderr + proc.stdout)
        self.assertIn("4188", proc.stdout)

    def test_write_then_check_on_scratch_copy(self):
        out = self.s.root / "function-ledger.json"
        proc = self.fx("--write")
        self.assertEqual(proc.returncode, 0, proc.stderr)
        self.assertEqual(out.read_text(), FL.render(self.s.derive()))
        self.assertEqual(self.fx("--check").returncode, 0)

    def test_check_fails_closed_on_stale_ledger(self):
        self.fx("--write")
        self.s.edit("function-index.json", lambda d: d["functions"][0].update(name="changed"))
        proc = self.fx("--check")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("function ledger stale; rerun scripts/build_function_ledger.py --write", proc.stderr)

    def test_check_fails_when_the_ledger_is_missing(self):
        proc = self.fx("--check")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("error:", proc.stderr)

    def test_write_refuses_invalid_inputs_and_leaves_the_old_file(self):
        out = self.s.root / "function-ledger.json"
        self.fx("--write")
        before = out.read_text()
        self.s.ov(lambda d: d["port_acceptances"][0].update(va="0x401004"))
        proc = self.fx("--write")
        self.assertEqual(proc.returncode, 1)
        self.assertEqual(out.read_text(), before)

    def test_exactly_one_mode_is_required(self):
        self.assertNotEqual(self.run_cli().returncode, 0)
        self.assertNotEqual(self.run_cli("--write", "--check").returncode, 0)

    def test_write_to_explicit_out_path_leaves_default_untouched(self):
        out = self.s.root / "elsewhere.json"
        proc = self.fx("--write", "--out", str(out))
        self.assertEqual(proc.returncode, 0, proc.stderr)
        self.assertTrue(out.exists())
        self.assertFalse((self.s.root / "function-ledger.json").exists())

    def test_default_check_does_not_modify_the_committed_ledger(self):
        path = OUT / "function-ledger.json"
        before = path.read_bytes() if path.exists() else None
        self.run_cli("--check")
        self.assertEqual(path.read_bytes() if path.exists() else None, before)


if __name__ == "__main__":
    unittest.main()
