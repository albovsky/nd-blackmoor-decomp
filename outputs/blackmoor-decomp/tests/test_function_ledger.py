"""Function ledger core: derivation, strict validation and the build CLI (FL-1b).

Fixture tests run against the synthetic inputs under
decomp-progress/fixtures/function-ledger/ (written in the REAL shapes of
function-xrefs.json, function-evidence.json and the overrides draft by that
directory's make_fixture.py) and mutate scratch copies only. The committed
fixture ledger and the real function-ledger.json are never edited in place. No
original bytes or private evidence are read.
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


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


FL = load("function_ledger", OUT / "decomp-progress" / "function_ledger.py")
XM = load("extract_function_xrefs", OUT / "scripts" / "extract_function_xrefs.py")
EV = load("extract_function_evidence", OUT / "scripts" / "extract_function_evidence.py")

PIN = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
FIXTURE_FUNCTIONS = 30
PREFIX = "outputs/blackmoor-decomp/"
SCRATCH_PARENT = "/private/tmp" if Path("/private/tmp").is_dir() else None


def sha_file(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def sha(text):
    return hashlib.sha256(text if isinstance(text, bytes) else text.encode()).hexdigest()


def hx(va):
    return f"0x{va:x}"


def h8(va):
    return f"0x{va:08x}"


TEXT_U1, TEXT_U2 = sha("fixture-item-U1"), sha("fixture-item-U2")
BLOCKER_U1 = f"FIX-1:{TEXT_U1[:16]}"
BLOCKER_U2 = f"FIX-1:{TEXT_U2[:16]}"

# Hand-checked expectations for the fixture: va -> (status, class, region, seam, origin, reason, rule)
G, V, C = "game", "vorbis", "crt_mfc"
P, N, D = "ported", "not_needed", "pending"
EXPECT = {
    0x401000: (P, "native_oracle_verified", G, False, "game", None, None),
    0x401100: (P, "native_tests_only", G, False, "game", None, None),
    0x401300: (D, "none", G, False, "game", None, None),
    0x401340: (P, "native_oracle_verified", G, False, "game", None, None),
    0x4014c0: (D, "candidate_port", G, False, "game", None, None),
    0x401600: (D, "partial_native", G, False, "game", None, None),
    0x401700: (D, "static_navigation_only", G, False, "game", None, None),
    0x401800: (D, "none", G, False, "game", None, None),
    0x401900: (D, "candidate_port", G, False, "game", None, None),
    0x401a00: (P, "native_oracle_verified", G, False, "game", None, None),
    0x401b00: (N, "nn_reviewed", G, False, "game", "unreachable_no_refs", None),
    0x401c00: (N, "nn_reviewed", G, False, "game", "debug_diagnostic_only", None),
    0x401d00: (N, "nn_reviewed", G, False, "game", "win32_plumbing_no_observable_effect", None),
    0x401e00: (D, "none", G, False, "game", None, None),
    0x404000: (D, "none", V, True, "unknown", None, None),
    0x404800: (D, "none", V, False, "library", None, None),
    0x405c00: (D, "none", V, True, "library", None, None),
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
    0x407a00: (D, "none", C, False, "library", None, None),
}


def fixture_derive(root=FIXTURE, **kw):
    kw.setdefault("expected_functions", FIXTURE_FUNCTIONS)
    return FL.derive(root, **kw)


def by_va(ledger):
    return {int(e["va"], 16): e for e in ledger["entries"]}


def item_record(va, address, text_sha=TEXT_U1, field="unverified_branches", slice_="FIX-1", index=0):
    return {"slice": slice_, "path": f"analysis/slices/{slice_}.handoff.json", "field": field, "index": index,
            "text_sha256": text_sha, "address": hx(address), "interior": address != va}


def pointer(function, kind):
    return next(p for p in function["evidence"] if p["kind"] == kind)


def add_pending_evidence(scratch, blockers):
    """An evidence entry for the pending function 0x401800 (kept sorted by address)."""
    def go(doc):
        doc["functions"].append({"va": "0x401800", "evidence": [], "blockers": blockers, "divergences": []})
        doc["functions"].sort(key=lambda f: int(f["va"], 16))
    scratch.edit("function-evidence.json", go)


class Scratch:
    """A mutable copy of the fixture tree."""

    def __init__(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="fl1b-", dir=SCRATCH_PARENT)
        self.root = Path(self.tmp.name) / "fx"
        shutil.copytree(FIXTURE, self.root)
        (self.root / "function-ledger.json").unlink()      # scratch trees start without a committed ledger

    def cleanup(self):
        self.tmp.cleanup()

    def path(self, rel):
        return self.root / rel

    def edit(self, rel, fn):
        data = json.loads(self.path(rel).read_text())
        fn(data)
        self.path(rel).write_text(json.dumps(data, indent=1) + "\n")

    def text(self, rel, fn):
        p = self.path(rel)
        p.write_text(fn(p.read_text()))

    def resync_evidence_hashes(self):
        """Refresh every evidence pointer and source hash after editing a source or test file."""
        def fix(doc):
            for row in doc["sources"]:
                row["sha256"] = sha_file(self.path(row["path"][len(PREFIX):]))
            for fn in doc["functions"]:
                for p in fn["evidence"]:
                    if p["kind"] in ("native_source", "test", "oracle", "mention") and p.get("path") \
                            and p["path"].startswith(PREFIX):
                        p["sha256"] = sha_file(self.path(p["path"][len(PREFIX):]))
        self.edit("function-evidence.json", fix)

    def resync_pins(self):
        """Refresh the function-index and layout pins after editing those files."""
        index, layout = sha_file(self.path("function-index.json")), sha_file(self.path("decomp-progress/layout.json"))
        self.edit("function-evidence.json", lambda d: d["function_index"].update(sha256=index))

        def xr(doc):
            for i in doc["inputs"]:
                if i["role"] == "function_index":
                    i["sha256"] = index
                if i["role"] == "layout":
                    i["sha256"] = layout
        self.edit("function-xrefs.json", xr)

    def derive(self, **kw):
        return fixture_derive(self.root, **kw)

    def ev(self, va, fn):
        def go(doc):
            for f in doc["functions"]:
                if int(f["va"], 16) == va:
                    fn(f)
        self.edit("function-evidence.json", go)

    def xr(self, va, fn, recount=True):
        def go(doc):
            for e in doc["entries"]:
                if int(e["va"], 16) == va:
                    fn(e)
            if recount:
                doc["counts"] = XM.compute_counts(doc)
        self.edit("function-xrefs.json", go)

    def xdoc(self, fn):
        def go(doc):
            fn(doc)
            doc["counts"] = XM.compute_counts(doc)
        self.edit("function-xrefs.json", go)

    def edge(self, caller, callee, present=True):
        def go(doc):
            by = {int(e["va"], 16): e for e in doc["entries"]}
            for owner, key, other in ((by[caller], "callees", callee), (by[callee], "callers", caller)):
                lst = set(owner[key])
                (lst.add if present else lst.discard)(h8(other))
                owner[key] = sorted(lst)
        self.xdoc(go)

    def funclet(self, va, parent, kind="unwind"):
        """Make ``va`` a funclet of ``parent`` (xrefs stays self-consistent)."""
        def go(doc):
            by = {int(e["va"], 16): e for e in doc["entries"]}
            for e in doc["entries"]:
                e["eh_funclets"] = [x for x in e["eh_funclets"] if int(x, 16) != va]
            by[va].update(origin="compiler_eh", origin_basis="eh_funclet", eh_kind=kind, eh_parent=h8(parent),
                          eh_parents=[h8(parent)], eh_parent_region=by[parent]["region"])
            by[parent]["eh_funclets"] = sorted(set(by[parent]["eh_funclets"]) | {h8(va)})
        self.xdoc(go)

    def not_funclet(self, va, origin="library"):
        def go(doc):
            for e in doc["entries"]:
                e["eh_funclets"] = [x for x in e["eh_funclets"] if int(x, 16) != va]
            next(e for e in doc["entries"] if int(e["va"], 16) == va).update(
                origin=origin, origin_basis="band_library", eh_kind=None, eh_parent=None, eh_parents=[],
                eh_parent_region=None)
        self.xdoc(go)

    def ov(self, fn):
        self.edit("function-ledger-overrides.json", fn)

    def rule(self, rule_id, fn):
        def go(doc):
            for r in doc["not_needed_rules"]:
                if r["id"] == rule_id:
                    fn(r)
        self.ov(go)


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

    def status(self, va, s=None):
        e = by_va((s or self.s).derive())[va]
        return e["status"], e["class"]


# ------------------------------------------------------------------ fixture --

class FixtureDerivationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.notes = []
        cls.ledger = fixture_derive(notes=cls.notes)
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

    def test_origin_seam_region_span_body_parts_come_from_xrefs(self):
        xrefs = json.loads((FIXTURE / "function-xrefs.json").read_text())
        for x in xrefs["entries"]:
            e = self.by_va[int(x["va"], 16)]
            self.assertEqual((e["origin"], e["seam"], e["region"], e["span"], e["body_size"]),
                             (x["origin"], x["seam"], x["region"], x["span"], x["body_size"]))
            self.assertEqual([int(p, 16) for p in e["derived_parts"]], [int(p, 16) for p in x["derived_parts"]])

    def test_body_sizes_parts_blockers_divergences(self):
        e = self.by_va
        self.assertEqual(e[0x401000]["body_size"], 0xf0)
        self.assertEqual(e[0x407a00]["body_size"], 0x1500)
        self.assertEqual(e[0x401340]["derived_parts"], ["0x401380", "0x4013a0"])
        self.assertEqual(e[0x401e00]["derived_parts"], ["0x401e80"])
        self.assertEqual([b["id"] for b in e[0x401900]["blockers"]], [BLOCKER_U1])
        self.assertEqual(e[0x401900]["blockers"][0]["address"], "0x401950")
        self.assertIn(TEXT_U1, e[0x401900]["blockers"][0]["text"])
        self.assertEqual([b["id"] for b in e[0x401a00]["blockers"]], [BLOCKER_U2])
        self.assertEqual([d["id"] for d in e[0x401a00]["divergences"]], [BLOCKER_U2])
        self.assertTrue(e[0x401a00]["divergences"][0]["safety_rejection"])
        self.assertEqual([b["id"] for b in e[0x401e00]["blockers"]], ["census_fall_through_fragment"])
        self.assertEqual(e[0x401e00]["blockers"][0]["address"], "0x401e80")
        self.assertEqual([b["id"] for b in e[0x407a00]["blockers"]], ["census_unsplit_span"])
        self.assertEqual(e[0x401b00]["blockers"], [])

    def test_review_fields(self):
        e = self.by_va
        self.assertEqual(e[0x401000]["review"], {"reviewer": "fixture-reviewer", "date": "2026-10-15", "sample": None})
        self.assertEqual(e[0x406800]["review"]["sample"], sha(b"sample-lib"))
        self.assertEqual(e[0x407300]["review"]["sample"], sha(b"sample-eh"))
        self.assertIsNone(e[0x401800]["review"])
        self.assertEqual(e[0x406800]["reason"]["text"], "library function with no path from or to game code")

    def test_evidence_pointers_by_kind(self):
        kinds = lambda va: [p["kind"] for p in self.by_va[va]["evidence"]]
        self.assertEqual(kinds(0x401000), ["native_source", "oracle", "receipt", "test"])
        self.assertEqual(kinds(0x401700), ["mention", "receipt"])
        self.assertEqual(kinds(0x401800), [])
        oracle = pointer(self.by_va[0x401000], "oracle")
        self.assertEqual(oracle["window"], ["0x401000", "0x401100"])
        self.assertEqual((oracle["use"], oracle["use_basis"], oracle["verified"]), ("entry", "window_start", "recorded_hash"))
        self.assertEqual(oracle["path"], "tests/fixture_core_oracle.py")          # root-relative, not repo-relative
        self.assertEqual(oracle["sha256"], sha_file(FIXTURE / "tests/fixture_core_oracle.py"))
        self.assertEqual(pointer(self.by_va[0x401000], "receipt")["review"], "reviewer_recorded")
        declared = pointer(self.by_va[0x401600], "oracle")
        self.assertEqual((declared["path"], declared["sha256"], declared["verified"], declared["use"]),
                         (None, None, "declared_only", "mapped"))
        for e in self.ledger["entries"]:
            for p in e["evidence"]:
                self.assertFalse({"line", "lines", "line_no"} & set(p))
                self.assertFalse(str(p.get("path") or "").startswith(PREFIX))

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
        self.assertEqual(c["origin"], {"game": 14, "library": 11, "compiler_eh": 3, "import_thunk": 1, "unknown": 1})
        self.assertEqual(c["seam"], 3)
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
            self.assertFalse(i["path"].startswith(PREFIX))

    def test_unverifiable_private_pins_are_reported_not_passed(self):
        text = "\n".join(self.notes)
        self.assertIn("not re-checked", text)
        self.assertIn("ghidra_census", text)
        self.assertIn("span_split_tool", text)
        self.assertIn("private receipts not re-hashed", text)

    def test_fixture_inputs_satisfy_the_extractors_own_validators(self):
        self.assertEqual(XM.validate(json.loads((FIXTURE / "function-xrefs.json").read_text())), [])
        EV.validate_document(json.loads((FIXTURE / "function-evidence.json").read_text()))

    def test_fixture_tree_is_what_the_generator_writes(self):
        proc = subprocess.run([sys.executable, str(FIXTURE / "make_fixture.py"), "--check"],
                              capture_output=True, text=True)
        self.assertEqual(proc.returncode, 0, proc.stderr)

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
    def test_required_inputs_must_exist(self):
        for rel in ("function-index.json", "decomp-progress/layout.json", "asm/census-summary.json",
                    "function-evidence.json", "function-xrefs.json", "function-ledger-overrides.json"):
            with self.subTest(rel=rel):
                s = self.fresh()
                s.path(rel).unlink()
                with self.assertRaises(FL.LedgerError) as ctx:
                    s.derive()
                self.assertIn("missing required input", str(ctx.exception))

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
        self.s.edit("function-index.json", lambda d: d["functions"][3].update(address=d["functions"][2]["address"]))
        self.fails("duplicate start")

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
        self.s.edit("asm/census-summary.json", lambda d: d.update(derived_functions=2))
        self.fails("derived")

    def test_text_end_comes_from_layout(self):
        self.s.edit("decomp-progress/layout.json", lambda d: d["sections"][1].update(virt_size=0x8000 + 0x10))
        self.fails()

    def test_xrefs_must_describe_every_function_once(self):
        self.s.xdoc(lambda d: d["entries"].pop(5))
        self.fails()

    def test_xrefs_region_and_span_must_agree_with_the_index(self):
        self.s.xr(0x401600, lambda e: e.update(span=0x80))
        self.fails("span")
        s = self.fresh()
        s.xr(0x401600, lambda e: e.update(region="vorbis"))
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_xrefs_regions_must_equal_the_layout(self):
        self.s.xdoc(lambda d: (d["regions"][0].update(end_va="0x00403f00"), d["regions"][1].update(start_va="0x00403f00"),
                               d["parameters"].update(boundaries=["0x00403f00", "0x00406000"])))
        self.fails("regions")

    def test_xrefs_incomplete_analysis_must_match_the_census_unsplit_spans(self):
        self.s.xr(0x407a00, lambda e: e.update(analysis_complete=True))
        self.fails("unsplit")

    def test_xrefs_parts_must_match_census_total(self):
        self.s.xr(0x401e00, lambda e: e.update(derived_parts=[]))
        self.s.xdoc(lambda d: d["derived_parts"].pop())
        self.fails("derived")

    def test_xrefs_body_size_past_the_span_is_clamped_with_a_note(self):
        self.s.xr(0x401600, lambda e: e.update(body_size=0x150))
        notes = []
        ledger = self.s.derive(notes=notes)
        self.assertEqual(by_va(ledger)[0x401600]["body_size"], 0x100)
        self.assertTrue(any("clamped" in n and "0x401600" in n for n in notes), notes)

    def test_xrefs_pins_must_match_the_committed_files(self):
        self.s.edit("function-index.json", lambda d: d["functions"][0].update(name="renamed"))
        self.fails("function-index")

    def test_xrefs_own_pins_are_checked_even_when_the_evidence_pin_agrees(self):
        self.s.xdoc(lambda d: next(i for i in d["inputs"] if i["role"] == "function_index").update(sha256="2" * 64))
        self.fails("xrefs pin")
        s = self.fresh()
        s.xdoc(lambda d: next(i for i in d["inputs"] if i["role"] == "layout").update(sha256="2" * 64))
        with self.assertRaises(FL.LedgerError) as ctx:
            s.derive()
        self.assertIn("xrefs pin", str(ctx.exception))

    def test_xrefs_pin_roles_are_required_once(self):
        self.s.xdoc(lambda d: d["inputs"].pop(1))
        self.fails("pin")

    def test_xrefs_original_pin(self):
        self.s.xdoc(lambda d: d["inputs"][0].update(sha256="1" * 64))
        self.fails("GAME.EXE")


# ----------------------------------------------------------- strict schemas --

class SchemaTests(ScratchCase):
    def test_top_level_of_each_input(self):
        required = {"function-evidence.json": "functions", "function-xrefs.json": "entries",
                    "function-ledger-overrides.json": "port_acceptances"}
        for rel, key in required.items():
            for name, fn in {"extra key": lambda d: d.update(extra=1),
                             "schema": lambda d: d.update(schema="x"),
                             "missing key": lambda d, key=key: d.pop(key)}.items():
                with self.subTest(rel=rel, name=name):
                    s = self.fresh()
                    s.edit(rel, fn)
                    with self.assertRaises(FL.LedgerError):
                        s.derive()
        for rel in ("function-evidence.json", "function-xrefs.json"):
            with self.subTest(rel=rel, name="sha"):
                s = self.fresh()
                s.edit(rel, lambda d: d.update(original_sha256="0" * 64))
                with self.assertRaises(FL.LedgerError):
                    s.derive()

    def test_evidence_function_items(self):
        mutations = {
            "extra key": lambda f: f.update(extra=1),
            "missing evidence": lambda f: f.pop("evidence"),
            "missing blockers": lambda f: f.pop("blockers"),
            "bad va": lambda f: f.update(va="401000"),
            "non-index va": lambda f: f.update(va="0x401001"),
            "unknown pointer kind": lambda f: f["evidence"][0].update(kind="guess"),
            "pointer extra key": lambda f: f["evidence"][0].update(extra=3),
            "pointer line number": lambda f: f["evidence"][0].update(line_no=3),
            "bad sha": lambda f: f["evidence"][0].update(sha256="zz"),
            "wrong sha": lambda f: f["evidence"][0].update(sha256="0" * 64),
            "absolute path": lambda f: f["evidence"][0].update(path="/Users/x/src/fixture_core.c"),
            "dotdot path": lambda f: f["evidence"][0].update(path=PREFIX + "../src/fixture_core.c"),
            "windows path": lambda f: f["evidence"][0].update(path="C:/x/fixture_core.c"),
            "backslash path": lambda f: f["evidence"][0].update(path=PREFIX + "src\\fixture_core.c"),
            "root-relative path": lambda f: f["evidence"][0].update(path="src/fixture_core.c"),
            "file not among the pinned sources": lambda f: f["evidence"][0].update(path=PREFIX + "src/fixture_rand.c.x"),
            "empty symbol": lambda f: f["evidence"][0].update(symbol=""),
            "symbol not an identifier": lambda f: f["evidence"][0].update(symbol="a b"),
            "bad use": lambda f: f["evidence"][2].update(use="executed"),
            "bad use_basis": lambda f: f["evidence"][2].update(use_basis="guess"),
            "bad verified": lambda f: f["evidence"][2].update(verified="yes"),
            "bad reading": lambda f: f["evidence"][2].update(reading="cursor"),
            "entry use with declared_only window": lambda f: f["evidence"][2].update(verified="declared_only"),
            "bad window hash": lambda f: f["evidence"][2].update(window_sha256="1"),
            "verified window without a hash": lambda f: f["evidence"][2].update(window_sha256=None),
            "inverted window": lambda f: f["evidence"][2].update(window=["0x401100", "0x401000"]),
            "empty window": lambda f: f["evidence"][2].update(window=["0x401000", "0x401000"]),
            "three element window": lambda f: f["evidence"][2].update(window=["0x401000", "0x401100", "x"]),
            "window as dict": lambda f: f["evidence"][2].update(window={"start": "0x401000", "end": "0x401100"}),
            "oracle path without sha": lambda f: f["evidence"][2].update(sha256=None),
            "receipt unknown path": lambda f: f["evidence"][3].update(path="analysis/slices/NOPE.handoff.json"),
            "receipt wrong sha": lambda f: f["evidence"][3].update(sha256="0" * 64),
            "receipt wrong slice": lambda f: f["evidence"][3].update(slice="FIX-2"),
            "receipt review disagrees": lambda f: f["evidence"][3]["review"].update(state="pending"),
            "receipt review extra": lambda f: f["evidence"][3]["review"].update(extra=1),
        }
        for name, fn in mutations.items():
            with self.subTest(name):
                s = self.fresh()
                s.ev(0x401000, fn)
                with self.assertRaises(FL.LedgerError):
                    s.derive()

    def test_evidence_blocker_records(self):
        # on a pending function: a ported one would reject any open blocker for the wrong reason
        mutations = {
            "blocker missing key": lambda f: f["blockers"].append({"address": "0x401010", "slice": "FIX-1"}),
            "blocker outside span": lambda f: f["blockers"].append(item_record(0x401800, 0x401500)),
            "blocker before span": lambda f: f["blockers"].append(item_record(0x401800, 0x400fff)),
            "blocker interior flag wrong": lambda f: f["blockers"].append(
                {**item_record(0x401800, 0x401010), "interior": False}),
            "blocker exact flag wrong": lambda f: f["blockers"].append(
                {**item_record(0x401800, 0x401800), "interior": True}),
            "blocker interior not bool": lambda f: f["blockers"].append(
                {**item_record(0x401800, 0x401010), "interior": 1}),
            "blocker bad text hash": lambda f: f["blockers"].append(item_record(0x401800, 0x401010, text_sha="12")),
            "blocker negative index": lambda f: f["blockers"].append(item_record(0x401800, 0x401010, index=-1)),
            "blocker absolute path": lambda f: f["blockers"].append(
                {**item_record(0x401800, 0x401010), "path": "/Users/x/FIX-1.json"}),
            "blocker census slice": lambda f: f["blockers"].append(
                item_record(0x401800, 0x401010, slice_="census_fall_through_fragment")),
        }
        for name, fn in mutations.items():
            with self.subTest(name):
                s = self.fresh()
                add_pending_evidence(s, [])
                s.ev(0x401800, fn)
                with self.assertRaises(FL.LedgerError):
                    s.derive()
        ok = self.fresh()
        add_pending_evidence(ok, [item_record(0x401800, 0x401810)])
        e = by_va(ok.derive())[0x401800]
        self.assertEqual((e["status"], len(e["blockers"])), ("pending", 1))

    def test_duplicate_evidence_function(self):
        self.s.edit("function-evidence.json", lambda d: d["functions"].insert(1, copy.deepcopy(d["functions"][0])))
        self.fails()

    def test_evidence_source_rows_are_rehashed(self):
        self.s.edit("function-evidence.json", lambda d: d["sources"][0].update(sha256="0" * 64))
        self.fails("sha256")
        s = self.fresh()
        s.edit("function-evidence.json", lambda d: d["sources"][0].update(role="header"))
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_evidence_pins_the_function_index_and_text_range(self):
        self.s.edit("function-evidence.json", lambda d: d["function_index"].update(sha256="0" * 64))
        self.fails("function-index")
        s = self.fresh()
        s.edit("function-evidence.json", lambda d: d.update(text_range=["0x401000", "0x409001"]))
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_evidence_receipt_rows(self):
        self.s.edit("function-evidence.json", lambda d: d["receipts"][0].update(path="outputs/x.json"))
        self.fails()
        s = self.fresh()
        s.edit("function-evidence.json", lambda d: d["receipts"][0]["review"].update(state="accepted"))
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_va_size_window_on_a_pending_function_never_reaches_the_ledger(self):
        # (va, size) read as end_exclusive < start; the extractor's shape bug must fail, not be carried along.
        self.s.ev(0x4014c0, lambda f: f["evidence"][1].update(window=["0x4014c0", "0x130"]))
        self.fails("end after start")

    def test_unsorted_evidence_is_rejected(self):
        self.s.edit("function-evidence.json", lambda d: d["functions"].reverse())
        self.fails("sorted")

    def test_xrefs_items(self):
        mutations = {
            "non-index va": lambda f: f.update(va="0x00401001"),
            "extra key": lambda f: f.update(extra=1),
            "missing key": lambda f: f.pop("callers"),
            "old field names": lambda f: f.update(data_ref=False),
            "body zero": lambda f: f.update(body_size=0),
            "body float": lambda f: f.update(body_size=1.5),
            "body bool": lambda f: f.update(body_size=True),
            "part outside span": lambda f: f.update(derived_parts=["0x00401200"]),
            "part is the next start": lambda f: f.update(derived_parts=["0x00401100"]),
            "bad caller": lambda f: f.update(callers=["main"]),
            "caller outside text": lambda f: f.update(callers=["0x00800000"]),
            "asymmetric edge": lambda f: f.update(callees=["0x00401100"]),
            "bad import": lambda f: f.update(imports=["bad name"]),
            "import without a dll": lambda f: f.update(imports=["GetTickCount"]),
            "eh parent non-index": lambda f: f.update(eh_parent="0x00401001", eh_kind="unwind"),
            "eh kind without parent": lambda f: f.update(eh_kind="unwind"),
            "bad origin": lambda f: f.update(origin="kernel"),
            "null origin": lambda f: f.update(origin=None),
            "eh origin without funclet proof": lambda f: f.update(origin="compiler_eh"),
            "bad reach": lambda f: f.update(reach="maybe"),
            "seam not bool": lambda f: f.update(seam="yes"),
            "analysis_complete not bool": lambda f: f.update(analysis_complete=1),
            "bad fingerprint": lambda f: f.update(fingerprints=["rot13"]),
        }
        for name, fn in mutations.items():
            with self.subTest(name):
                s = self.fresh()
                s.xr(0x401000, fn, recount=False)
                with self.assertRaises(FL.LedgerError):
                    s.derive()

    def test_xrefs_counts_and_tables_are_checked_by_the_extractors_validator(self):
        self.s.edit("function-xrefs.json", lambda d: d["counts"].update(seam=99))
        self.fails("failed its own validator")
        s = self.fresh()
        s.edit("function-xrefs.json", lambda d: d["entries"].reverse())
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_xrefs_duplicate_and_thunk_tables(self):
        self.s.edit("function-xrefs.json", lambda d: d["entries"].append(copy.deepcopy(d["entries"][0])))
        self.fails()
        for name, fn in {
            "thunk container non-index": lambda t: t.update(container="0x00401001"),
            "thunk outside container": lambda t: t.update(va="0x00401500"),
            "thunk bad kind": lambda t: t.update(kind="direct"),
        }.items():
            with self.subTest(name):
                s = self.fresh()
                s.edit("function-xrefs.json", lambda d: fn(d["thunks"][0]))
                with self.assertRaises(FL.LedgerError):
                    s.derive()

    def test_xrefs_thunk_that_is_not_a_part_or_a_start(self):
        def go(doc):
            doc["derived_parts"] = [d for d in doc["derived_parts"] if d["va"] != "0x00401380"]
            for e in doc["entries"]:
                if e["va"] == "0x00401340":
                    e["derived_parts"] = ["0x004013a0"]
        self.s.xdoc(go)
        self.s.edit("asm/census-summary.json", lambda d: d.update(derived_functions=2))
        self.fails("thunk")

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
            "rule wrong reason": lambda d: d["not_needed_rules"][0].update(reason_code="unreachable_no_refs"),
            "rule old reason key": lambda d: d["not_needed_rules"][0].update(reason="compiler_eh_funclet"),
            "rule duplicate id": lambda d: d["not_needed_rules"].append(copy.deepcopy(d["not_needed_rules"][0])),
            "rule extra key": lambda d: d["not_needed_rules"][0].update(covers="game"),
            "rule accepted not bool": lambda d: d["not_needed_rules"][0].update(accepted="yes"),
            "rule small sample": lambda d: d["not_needed_rules"][0]["review"].update(n=58),
            "rule sample defects": lambda d: d["not_needed_rules"][0]["review"].update(defects=1),
            "rule sample hash": lambda d: d["not_needed_rules"][0]["review"].update(sample_sha256="abc"),
            "rule accepted without sample": lambda d: d["not_needed_rules"][0]["review"].update(sample_sha256=None),
            "rule accepted without reviewer": lambda d: d["not_needed_rules"][0]["review"].update(reviewer=""),
            "rule accepted without review": lambda d: d["not_needed_rules"][0].pop("review"),
            "rule review extra key": lambda d: d["not_needed_rules"][0]["review"].update(notes="x"),
            "rule bad region": lambda d: d["not_needed_rules"][0]["parameters"].update(eh_parent_regions=["kernel"]),
            "rule unknown parameter": lambda d: d["not_needed_rules"][0]["parameters"].update(depth=3),
            "library rule takes no parameter": lambda d: d["not_needed_rules"][1]["parameters"].update(
                eh_parent_regions=["game"]),
            "rule documentation not a list": lambda d: d["not_needed_rules"][0].update(caveats="x"),
            "semantics spec bad selector": lambda d: d["semantics_sensitive"][0]["selectors"].append({"kind": "guess"}),
            "semantics duplicate id": lambda d: d["semantics_sensitive"].append(copy.deepcopy(d["semantics_sensitive"][0])),
            "semantics old va form": lambda d: d["semantics_sensitive"].append({"va": "0x401000", "why": "x"}),
            "allowlist bad name": lambda d: d["win32_import_allowlist"]["names"].append("a b"),
            "allowlist name without dll": lambda d: d["win32_import_allowlist"]["names"].append("GetTickCount"),
            "allowlist no reviewer": lambda d: d["win32_import_allowlist"].update(reviewer=""),
            "unknown top key": lambda d: d.update(not_needed_game_rules=[]),
            "status not text": lambda d: d.update(status=3),
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
                r["review"] = {"reviewer": None, "date": None, "n": None, "defects": None, "sample_sha256": None}
        self.s.ov(draft)
        ledger = self.s.derive()
        self.assertEqual(ledger["counts"]["class"]["nn_rule"], 0)
        by = by_va(ledger)
        self.assertEqual((by[0x406800]["status"], by[0x407300]["status"]), ("pending", "pending"))

    def test_the_fl3_draft_overrides_shape_is_accepted_as_is(self):
        # The committed FL-3 draft (rules accepted:false, no allowlist, spec-shaped semantics_sensitive) must load.
        draft = json.loads((OUT / "function-ledger-overrides.json").read_text())
        self.s.path("function-ledger-overrides.json").write_text(json.dumps(draft, indent=1))
        ledger = self.s.derive()
        self.assertEqual(ledger["counts"]["status"]["ported"], 0)
        self.assertEqual(ledger["counts"]["status"]["not_needed"], 0)


# ----------------------------------------------------- port acceptance (rule 3) --

class PortAcceptanceTests(ScratchCase):
    def acceptance(self, va, fn):
        def go(d):
            for a in d["port_acceptances"]:
                if int(a["va"], 16) == va:
                    fn(a)
        self.s.ov(go)

    def test_fixture_acceptances_are_ported(self):
        self.assertEqual(self.status(0x401a00)[0], "ported")

    def test_lexical_evidence_alone_is_never_ported(self):
        # native_source and test pointers are lexical citations and oracle use=entry is structural:
        # with the evidence complete but no reviewed acceptance, the function is a candidate at most.
        self.s.ov(lambda d: d.update(port_acceptances=[a for a in d["port_acceptances"] if a["va"] != "0x401000"]))
        self.assertEqual(self.status(0x401000), ("pending", "candidate_port"))
        s = self.fresh()
        s.ov(lambda d: d.update(port_acceptances=[a for a in d["port_acceptances"] if a["va"] != "0x401100"],
                                not_needed_entries=[e for e in d["not_needed_entries"] if e["va"] != "0x407500"]))
        self.assertEqual(self.status(0x401100, s), ("pending", "partial_native"))

    def test_an_entry_oracle_window_is_not_a_test(self):
        self.s.ev(0x401000, lambda f: f["evidence"].pop(1))        # keep the covering entry window, drop the test
        self.fails("test")

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
        self.assertEqual(self.status(0x401000)[0], "ported")      # only in the comment above the function

    def test_address_in_body_comment_counts_in_any_hex_spelling(self):
        self.assertEqual(self.status(0x401100)[0], "ported")      # FUN_00401100 inside the body

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

    def test_declared_only_window_never_qualifies(self):
        self.s.ev(0x401340, lambda f: f["evidence"][2].update(use="mapped", verified="declared_only", use_basis="unhashed"))
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

    def test_acceptance_oracle_window_must_match_evidence(self):
        self.acceptance(0x401000, lambda a: a["oracle"].update(window=["0x401000", "0x401200"]))
        self.fails("evidence")

    def test_open_blocker_keeps_the_function_out(self):
        self.s.ev(0x401000, lambda f: f["blockers"].append(item_record(0x401000, 0x401040)))
        self.fails("blocker")

    def test_interior_address_blocker_keeps_the_function_out(self):
        self.s.ev(0x401000, lambda f: f["blockers"].append(item_record(0x401000, 0x4010fe, field="unverified")))
        self.fails("blocker")

    def test_blocker_at_the_exact_start_also_blocks(self):
        self.s.ev(0x401000, lambda f: f["blockers"].append(item_record(0x401000, 0x401000)))
        self.fails("blocker")

    def test_blocker_covered_by_a_non_safety_divergence_still_blocks(self):
        self.s.ev(0x401a00, lambda f: f["divergences"][0].update(field="deliberate_divergences"))
        self.fails("blocker")

    def test_blocker_with_a_matching_safety_divergence_is_allowed(self):
        self.assertEqual(self.status(0x401a00)[0], "ported")

    def test_a_safety_divergence_with_other_text_does_not_clear_the_blocker(self):
        self.s.ev(0x401a00, lambda f: f["divergences"][0].update(text_sha256=sha("another statement")))
        self.fails("blocker")

    def test_a_safety_divergence_from_another_slice_does_not_clear_the_blocker(self):
        self.s.ev(0x401a00, lambda f: f["divergences"][0].update(slice="FIX-2", path="analysis/slices/FIX-2.handoff.json"))
        self.fails("blocker")

    def test_a_statement_listed_as_both_divergence_and_safety_rejection_is_not_cleared(self):
        self.s.ev(0x401a00, lambda f: f["divergences"].append(
            item_record(0x401a00, 0x401a40, text_sha=TEXT_U2, field="deliberate_divergences", index=1)))
        self.fails("blocker")

    def test_derived_part_must_be_accounted(self):
        self.acceptance(0x401340, lambda a: a.update(parts_accounted=["0x401380"]))
        self.fails("0x4013a0")

    def test_thunk_part_must_be_accounted(self):
        self.acceptance(0x401340, lambda a: a.update(parts_accounted=["0x4013a0"]))
        self.fails("0x401380")

    def test_accounting_unknown_parts_is_an_error(self):
        self.acceptance(0x401340, lambda a: a.update(parts_accounted=["0x401380", "0x4013a0", "0x4013b0"]))
        self.fails("0x4013b0")

    def test_derived_code_part_address_must_be_in_the_symbol(self):
        self.s.text("src/fixture_core.c", lambda t: t.replace("0x004013a0", "0x004013a1"))
        self.s.resync_evidence_hashes()
        self.fails("0x4013a0")

    def test_mechanical_parts_need_not_appear_in_the_source(self):
        # 0x401380 is an import thunk: accounted for, yet absent from the symbol's text.
        self.assertNotIn("401380", (FIXTURE / "src/fixture_core.c").read_text())
        self.assertEqual(self.status(0x401340)[0], "ported")

    def test_eh_handler_stub_part_is_mechanical(self):
        def go(doc):
            for d in doc["derived_parts"]:
                if d["va"] == "0x00401380":
                    d["kind"] = "eh_handler_stub"
            doc["thunks"] = [t for t in doc["thunks"] if t["va"] != "0x00401380"]
            for e in doc["entries"]:
                e["contains_thunks"] = [t for t in e["contains_thunks"] if t != "0x00401380"]
        self.s.xdoc(go)
        self.assertEqual(self.status(0x401340)[0], "ported")

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

    def test_unknown_origin_stays_pending(self):
        self.s.xr(0x401100, lambda f: f.update(origin="unknown", origin_basis="seam_unresolved", reach="unknown_origin"))
        self.fails("unknown")

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

    def test_closed_enums(self):
        self.assertEqual(set(FL.REASONS), {
            "win32_plumbing_no_observable_effect", "crt_startup_termination",
            "library_internal_unreached_by_game", "host_libc_standard_contract",
            "debug_diagnostic_only", "unreachable_no_refs", "compiler_eh_funclet"})
        self.assertEqual(set(FL.PREDICATES), {"R-EH", "R-LIB-INTERNAL"})
        self.assertEqual(set(FL.PREDICATES), set(XM.RULE_PREDICATES))
        self.assertEqual(set(FL.PORTED_CLASSES), {"native_oracle_verified", "native_tests_only", "host_adapter_tested"})
        self.assertEqual(set(FL.NOT_NEEDED_CLASSES), {"nn_rule", "nn_reviewed"})
        self.assertEqual(set(FL.PENDING_CLASSES), {"candidate_port", "partial_native", "static_navigation_only", "none"})
        self.assertEqual(set(FL.ORIGINS), set(XM.ORIGINS))
        self.assertEqual(FL.SAMPLE_MIN, 59)

    def test_unreachable_no_refs_needs_zero_callers_and_no_reference(self):
        self.s.edge(0x401000, 0x401b00)
        self.fails("unreachable_no_refs")
        s = self.fresh()
        s.xr(0x401b00, lambda f: f.update(data_refs=1, has_data_ref=True, address_taken=True))
        with self.assertRaises(FL.LedgerError):
            s.derive()
        s = self.fresh()
        s.xr(0x401b00, lambda f: f.update(code_addr_refs=1, address_taken=True))
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_win32_plumbing_import_must_be_allowlisted(self):
        self.s.xr(0x401d00, lambda f: f.update(imports=["KERNEL32.dll!CreateFileA"]))
        self.fails("allowlist")

    def test_win32_plumbing_rejects_pending_or_ported_game_callees(self):
        self.s.edge(0x401d00, 0x401800)
        self.fails("callee")
        s = self.fresh()
        s.edge(0x401d00, 0x401000)
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_win32_plumbing_without_any_allowlist_fails(self):
        self.s.ov(lambda d: d.pop("win32_import_allowlist"))
        self.fails("allowlist")

    def test_win32_plumbing_with_no_imports_fails(self):
        self.s.xr(0x401d00, lambda f: f.update(imports=[]))
        self.fails()

    def test_plumbing_with_indirect_calls_or_jumps_fails(self):
        self.s.xr(0x401d00, lambda f: f.update(indirect_calls=1))
        self.fails("indirect")
        s = self.fresh()
        s.xr(0x401c00, lambda f: f.update(indirect_jumps=1))
        with self.assertRaises(FL.LedgerError) as ctx:
            s.derive()
        self.assertIn("indirect", str(ctx.exception))

    def test_semantics_sensitive_function_cannot_be_waived_as_not_needed(self):
        self.add_entry(0x407900, "host_libc_standard_contract")           # fingerprint x87_ftol
        self.fails("semantics_sensitive")

    def test_rule_rationale_of_realistic_length_derives(self):
        self.s.ov(lambda d: d["not_needed_rules"][0].update(rationale="r" * 405))
        self.s.derive()

    def test_debug_only_needs_debug_imports(self):
        self.s.xr(0x401c00, lambda f: f.update(imports=["KERNEL32.dll!CreateFileA", "KERNEL32.dll!OutputDebugStringA"]))
        self.fails("debug")

    def test_debug_only_rejects_pending_game_callees(self):
        self.s.edge(0x401c00, 0x401800)
        self.fails("callee")

    def test_compiler_eh_entry_needs_a_funclet(self):
        self.add_entry(0x407900, "compiler_eh_funclet")
        self.fails("funclet")

    def test_compiler_eh_entry_loses_its_funclet_proof(self):
        self.s.not_funclet(0x407500)
        self.fails("funclet")

    def test_compiler_eh_entry_with_a_game_parent_needs_the_parent_decided(self):
        self.s.ov(lambda d: d.update(port_acceptances=[a for a in d["port_acceptances"] if a["va"] != "0x401100"]))
        self.fails("neither ported nor not_needed")

    def test_crt_startup_is_not_for_game_code_or_game_called_code(self):
        self.s.edge(0x401000, 0x407700)
        self.fails("crt_startup_termination")
        s = self.fresh()
        self.add_entry(0x401e00, "crt_startup_termination", s=s)
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_host_libc_needs_library_origin_in_crt_region(self):
        self.s.xr(0x407800, lambda f: f.update(origin="game", origin_basis="band_game"))
        self.fails("host_libc_standard_contract")

    def test_library_internal_entry_uses_the_extractors_reachability_proof(self):
        self.add_entry(0x407200, "library_internal_unreached_by_game")   # data referenced
        self.fails("library_internal")
        s = self.fresh()
        self.add_entry(0x407000, "library_internal_unreached_by_game", s=s)   # reaches game code
        with self.assertRaises(FL.LedgerError):
            s.derive()
        s = self.fresh()
        self.add_entry(0x407100, "library_internal_unreached_by_game", s=s)   # called by game
        with self.assertRaises(FL.LedgerError):
            s.derive()

    def test_unsplit_span_and_fall_through_fragment_stay_pending_for_not_needed_too(self):
        for va, fragment in ((0x407a00, "unsplit"), (0x401e00, "fragment")):
            with self.subTest(va=hex(va)):
                s = self.fresh()
                self.add_entry(va, "unreachable_no_refs", s=s)
                with self.assertRaises(FL.LedgerError) as ctx:
                    s.derive()
                self.assertIn(fragment, str(ctx.exception))

    def test_vorbis_stays_pending_for_not_needed_too(self):
        self.add_entry(0x404800, "unreachable_no_refs")
        self.fails("vorbis")

    def test_unknown_origin_seam_functions_stay_pending_for_not_needed_too(self):
        self.s.xr(0x407900, lambda f: f.update(origin="unknown", origin_basis="seam_unresolved", reach="unknown_origin"))
        self.add_entry(0x407900, "unreachable_no_refs")
        self.fails("unknown")

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
        self.s.edge(0x407000, 0x401800, present=False)
        self.s.edge(0x401800, 0x401000, present=False)
        self.s.edge(0x401800, 0x407800, present=False)
        self.s.xr(0x401800, lambda f: f.update(origin="library", origin_basis="band_library", reach="unreached"))
        self.assertEqual(self.status(0x401800)[0], "pending")

    def test_rule_never_selects_vorbis(self):
        self.assertEqual(self.status(0x404800)[0], "pending")      # origin library, no refs, still pending

    def test_rule_excludes_seam_functions(self):
        def go(d):
            d["port_acceptances"] = [a for a in d["port_acceptances"] if a["va"] != "0x406000"]
        self.s.ov(go)
        self.s.edge(0x401000, 0x406000, present=False)
        self.s.xr(0x406000, lambda f: f.update(fingerprints=[], reach="unreached"))
        self.s.ev(0x406000, lambda f: f["evidence"].clear())
        e = by_va(self.s.derive())[0x406000]
        self.assertTrue(e["seam"])
        self.assertEqual(e["status"], "pending")

    def test_rule_excludes_semantics_sensitive(self):
        self.assertEqual(self.status(0x407900), ("pending", "none"))      # fingerprint x87_ftol
        s = self.fresh()
        s.ov(lambda d: d.update(semantics_sensitive=[x for x in d["semantics_sensitive"] if x["id"] != "SS-FTOL"]))
        self.assertEqual(self.status(0x407900, s), ("not_needed", "nn_rule"))

    def test_rule_excludes_functions_whose_parent_is_sensitive(self):
        self.s.xr(0x401000, lambda f: f.update(fingerprints=["lcg_rand"]))
        self.assertEqual(self.status(0x407300)[0], "pending")

    def test_rule_excludes_any_function_with_evidence(self):
        def add(doc):
            doc["functions"].append({"va": "0x406800", "evidence": [
                {"kind": "mention", "path": PREFIX + "src/fixture_core.c", "sha256": sha_file(FIXTURE / "src/fixture_core.c"),
                 "symbol": None, "addresses": ["0x406804"], "via": "citation"}], "blockers": [], "divergences": []})
            doc["functions"].sort(key=lambda f: int(f["va"], 16))
        self.s.edit("function-evidence.json", add)
        self.assertEqual(self.status(0x406800), ("pending", "static_navigation_only"))

    def test_library_rule_follows_the_extractors_reach_fields(self):
        self.s.xr(0x406800, lambda f: f.update(reach="reachable"))
        self.assertEqual(self.status(0x406800)[0], "pending")
        s = self.fresh()
        s.xr(0x406800, lambda f: f.update(reaches_game=True))
        self.assertEqual(self.status(0x406800, s)[0], "pending")
        s = self.fresh()
        s.edge(0x401000, 0x406800)
        self.assertEqual(self.status(0x406800, s)[0], "pending")
        s = self.fresh()
        s.xr(0x406800, lambda f: f.update(data_refs=1, has_data_ref=True, address_taken=True))
        self.assertEqual(self.status(0x406800, s)[0], "pending")
        s = self.fresh()
        s.xr(0x406800, lambda f: f.update(analysis_complete=False))
        with self.assertRaises(FL.LedgerError):                  # incomplete analysis must match the census
            s.derive()

    def test_library_rule_needs_library_origin_from_xrefs(self):
        self.s.xr(0x406800, lambda f: f.update(origin="game", origin_basis="band_game"))
        self.assertEqual(self.status(0x406800)[0], "pending")

    def test_eh_rule_needs_a_decided_game_parent(self):
        self.assertEqual(self.status(0x407300)[0], "not_needed")      # parent 0x401000 is ported
        self.assertEqual(self.status(0x407400)[0], "pending")         # parent 0x401800 is pending

    def test_eh_rule_accepts_a_parent_that_is_not_needed(self):
        self.s.funclet(0x407400, 0x401b00)                            # 0x401b00 is a per-function not_needed entry
        self.assertEqual(self.status(0x407400), ("not_needed", "nn_rule"))

    def test_eh_rule_game_parents_need_game_in_the_rule_regions(self):
        self.s.rule("R-EH", lambda r: r["parameters"].update(eh_parent_regions=["crt_mfc", "vorbis"]))
        self.assertEqual(self.status(0x407300)[0], "pending")
        s = self.fresh()
        s.rule("R-EH", lambda r: r["parameters"].pop("eh_parent_regions"))      # default excludes game
        self.assertEqual(self.status(0x407300, s)[0], "pending")

    def test_eh_rule_library_parent_funclets_follow_the_extractors_predicate(self):
        self.s.funclet(0x407400, 0x407100)                            # a library parent
        self.assertEqual(self.status(0x407400), ("not_needed", "nn_rule"))
        s = self.fresh()
        s.funclet(0x407400, 0x407100)
        s.xr(0x407400, lambda f: f.update(reaches_game=True))
        self.assertEqual(self.status(0x407400, s)[0], "pending")      # library-parent funclet that reaches game code
        s = self.fresh()
        s.funclet(0x407400, 0x406000)                                 # a seam parent
        self.assertEqual(self.status(0x407400, s)[0], "pending")

    def test_eh_rule_never_covers_catch_funclets(self):
        self.s.ov(lambda d: d["not_needed_entries"].pop(3))      # drop the reviewed Catch@ entry
        self.assertEqual(self.status(0x407500)[0], "pending")
        s = self.fresh()
        s.funclet(0x407400, 0x401000, kind="catch")
        self.assertEqual(self.status(0x407400, s)[0], "pending")

    def test_eh_rule_does_not_apply_in_the_game_region(self):
        self.s.funclet(0x401800, 0x401000)
        self.assertEqual(self.status(0x401800)[0], "pending")

    def test_eh_rule_never_covers_a_function_with_evidence(self):
        def add(doc):
            doc["functions"].append({"va": "0x407300", "evidence": [
                {"kind": "mention", "path": PREFIX + "src/fixture_core.c", "sha256": sha_file(FIXTURE / "src/fixture_core.c"),
                 "symbol": None, "addresses": ["0x407304"], "via": "citation"}], "blockers": [], "divergences": []})
            doc["functions"].sort(key=lambda f: int(f["va"], 16))
        self.s.edit("function-evidence.json", add)
        self.assertEqual(self.status(0x407300)[0], "pending")

    def test_rule_sample_gate(self):
        for changes in ({"n": 58}, {"defects": 1}):
            with self.subTest(changes=changes):
                s = self.fresh()
                s.ov(lambda d: d["not_needed_rules"][0]["review"].update(changes))
                with self.assertRaises(FL.LedgerError):
                    s.derive()

    def test_rule_review_is_recorded_in_the_entry(self):
        e = by_va(self.s.derive())[0x407300]
        self.assertEqual(e["review"], {"reviewer": "fixture-reviewer", "date": "2026-10-15", "sample": sha(b"sample-eh")})
        self.assertEqual(e["reason"]["text"], "unwind funclet of a natively ported parent")


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

    def test_unhashed_window_is_partial_not_candidate(self):
        self.s.ev(0x401900, lambda f: f["evidence"][1].update(use="mapped", use_basis="unhashed", verified="declared_only"))
        self.assertEqual(self.cls(0x401900), "partial_native")

    def test_unknown_body_size_cannot_be_a_candidate(self):
        self.s.xr(0x4014c0, lambda f: f.update(body_size=None))
        self.assertEqual(self.cls(0x4014c0), "partial_native")

    def test_a_name_is_never_evidence(self):
        self.s.edit("function-index.json", lambda d: d["functions"][7].update(name="fixture_entry_port"))
        self.s.resync_pins()
        e = by_va(self.s.derive())[0x401800]
        self.assertEqual((e["status"], e["class"], e["name"]), ("pending", "none", "fixture_entry_port"))

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

    def test_blockers_group_per_slice_and_statement(self):
        # The same statement listed in a handoff and a validation receipt is one blocker.
        def go(f):
            f["blockers"].append({**item_record(0x401900, 0x401950), "path": "analysis/slices/FIX-1.validation.json",
                                  "field": "unverified", "index": 2})
        self.s.ev(0x401900, go)
        e = by_va(self.s.derive())[0x401900]
        self.assertEqual(len(e["blockers"]), 1)
        self.assertIn("unverified, unverified_branches", e["blockers"][0]["text"])


# ----------------------------------------------------------- private receipts --

class PrivateReceiptTests(ScratchCase):
    def make_receipts(self, match):
        work = self.s.root / "work"
        (work / "analysis/slices").mkdir(parents=True)
        for slice_ in ("FIX-1", "FIX-2"):
            p = work / f"analysis/slices/{slice_}.handoff.json"
            p.write_bytes((f"r-{slice_}" if match else f"changed-{slice_}").encode())
        return work

    def test_not_checked_by_default(self):
        self.s.derive(work_dir=self.s.root / "no-such-work")

    def test_verify_private_detects_a_changed_receipt(self):
        work = self.make_receipts(match=False)
        self.fails("receipt", work_dir=work, verify_private=True)

    def test_verify_private_passes_when_hashes_match(self):
        work = self.make_receipts(match=True)
        notes = []
        self.s.derive(work_dir=work, verify_private=True, notes=notes)
        self.assertFalse(any("private receipts not re-hashed" in n for n in notes))

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
        self.s.resync_pins()
        self.stale()

    def test_a_changed_overrides_file_makes_it_stale(self):
        self.written()
        self.s.ov(lambda d: d["not_needed_entries"].pop(0))
        self.stale()

    def test_a_regenerated_evidence_file_makes_it_stale(self):
        self.written()
        self.s.ev(0x401700, lambda f: f["evidence"].pop(0))
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
        self.rejects(lambda d: pointer(self.entry(d, 0x401340), "oracle").update(use="mapped"), "mapped")
        self.rejects(lambda d: pointer(self.entry(d, 0x401340), "oracle").update(window=["0x401340", "0x401400"]), "cover")
        self.rejects(lambda d: pointer(self.entry(d, 0x401340), "oracle").update(window_sha256=None, verified="declared_only"))
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
            {"kind": "mention", "path": "src/a.c", "symbol": None, "via": "citation"}), "evidence")

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

    def test_unknown_origin_never_leaves_pending(self):
        def go(d):
            e = self.entry(d, 0x407800)
            e["origin"] = "unknown"
        self.rejects(go, "unknown")

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
        def promote(d):
            e = self.entry(d, 0x401800)
            e["x86_match"] = {"provenance": "tool_assisted_reconstructed_assembly", "complete": True,
                              "manifest": "asm/batch-001.json"}
            e["status"] = "ported"
        self.rejects(promote)
        data = copy.deepcopy(self.good)
        self.entry(data, 0x401800)["x86_match"] = {"provenance": "tool_assisted_reconstructed_assembly",
                                                   "complete": True, "manifest": "asm/batch-001.json"}
        data["counts"]["x86"]["matched"] += 1
        data["counts"]["x86"]["complete"] += 1
        FL.validate(data)

    def test_evidence_pointer_shape_in_ledger(self):
        first = lambda d: self.entry(d, 0x401000)["evidence"][0]
        self.rejects(lambda d: first(d).update(path="/Users/x/y.c"))
        self.rejects(lambda d: first(d).update(line=7))
        self.rejects(lambda d: first(d).update(kind="guess"))
        self.rejects(lambda d: first(d).update(sha256="12"))
        self.rejects(lambda d: self.entry(d, 0x401000)["evidence"].append(
            copy.deepcopy(self.entry(d, 0x401000)["evidence"][0])), "duplicate")
        self.rejects(lambda d: pointer(self.entry(d, 0x401000), "receipt").update(review="accepted"))
        self.rejects(lambda d: pointer(self.entry(d, 0x401000), "oracle").update(use_basis="guess"))
        self.rejects(lambda d: pointer(self.entry(d, 0x401600), "oracle").update(use="entry"))      # declared_only
        self.rejects(lambda d: pointer(self.entry(d, 0x401600), "oracle").update(sha256="0" * 64))   # path null
        self.rejects(lambda d: pointer(self.entry(d, 0x401700), "mention").update(via="guess"))

    def test_evidence_pointers_must_be_sorted(self):
        self.rejects(lambda d: self.entry(d, 0x401000)["evidence"].reverse(), "sorted")

    def test_counts_must_equal_the_entries(self):
        self.rejects(lambda d: d["counts"]["status"].update(ported=4))
        self.rejects(lambda d: d["counts"]["class"].update(none=14))
        self.rejects(lambda d: d["counts"]["region"]["game"].update(ported=3))
        self.rejects(lambda d: d["counts"].update(total=29))
        self.rejects(lambda d: d["counts"].update(seam=2))
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
    """The committed function-ledger.json against the committed inputs (the real extractor outputs)."""

    @classmethod
    def setUpClass(cls):
        cls.path = OUT / "function-ledger.json"
        cls.data = json.loads(cls.path.read_text())

    def test_ledger_is_committed(self):
        self.assertTrue(self.path.exists(), "run scripts/build_function_ledger.py --write")

    def test_validates_and_is_current(self):
        notes = []
        FL.check(OUT, self.path, notes=notes)
        self.assertTrue(any("not re-checked" in n for n in notes), notes)       # private pins are never claimed

    def test_universe(self):
        data = self.data
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
        self.assertNotRegex(text, r'"path": "(?:/|[A-Za-z]:)')

    def test_vorbis_all_pending(self):
        self.assertEqual({e["status"] for e in self.data["entries"] if e["region"] == "vorbis"}, {"pending"})

    def test_origin_seam_and_parts_follow_the_real_xrefs(self):
        xrefs = json.loads((OUT / "function-xrefs.json").read_text())
        by = by_va(self.data)
        self.assertEqual(len(xrefs["entries"]), 4188)
        for x in xrefs["entries"]:
            e = by[int(x["va"], 16)]
            self.assertEqual((e["origin"], e["seam"], e["region"], e["span"]), (x["origin"], x["seam"], x["region"], x["span"]))
        self.assertEqual(self.data["counts"]["origin"], xrefs["counts"]["origin"])
        self.assertEqual(self.data["counts"]["seam"], xrefs["counts"]["seam"])
        self.assertEqual(sum(len(e["derived_parts"]) for e in self.data["entries"]), 564)

    def test_every_function_with_evidence_in_the_extractor_output_carries_it(self):
        evidence = json.loads((OUT / "function-evidence.json").read_text())
        with_evidence = {int(f["va"], 16): f for f in evidence["functions"]}
        by = by_va(self.data)
        self.assertEqual({va for va, e in by.items() if e["evidence"]}, set(with_evidence))
        self.assertEqual(len(with_evidence), evidence["counts"]["functions_with_evidence"])
        for va, f in with_evidence.items():
            self.assertEqual(len(by[va]["evidence"]), len(f["evidence"]))

    def test_unknown_origin_functions_stay_pending(self):
        unknown = [e for e in self.data["entries"] if e["origin"] == "unknown"]
        self.assertEqual([e["va"] for e in unknown], ["0x50bf50", "0x50c028", "0x50c309", "0x50c32e"])
        self.assertEqual({e["status"] for e in unknown}, {"pending"})

    def test_pending_classes_cover_every_pending_function(self):
        c = self.data["counts"]
        self.assertEqual(sum(c["class"][k] for k in FL.PENDING_CLASSES), c["status"]["pending"])

    def test_nothing_is_ported_or_not_needed_without_reviewed_overrides(self):
        ov = json.loads((OUT / "function-ledger-overrides.json").read_text())
        if ov["port_acceptances"] or ov["not_needed_entries"] or any(r["accepted"] for r in ov["not_needed_rules"]):
            self.skipTest("reviewed overrides are present")
        self.assertEqual(self.data["counts"]["status"], {"ported": 0, "not_needed": 0, "pending": 4188})
        self.assertEqual([e for e in self.data["entries"] if e["status"] != "pending"], [])
        self.assertNotIn("win32_import_allowlist", ov)

    def test_the_xrefs_and_evidence_extractor_validators_pass_on_the_committed_files(self):
        self.assertEqual(XM.validate(json.loads((OUT / "function-xrefs.json").read_text())), [])
        EV.validate_document(json.loads((OUT / "function-evidence.json").read_text()))


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
        self.assertIn("not re-checked", proc.stdout)

    def test_write_then_check_on_scratch_copy(self):
        out = self.s.root / "function-ledger.json"
        proc = self.fx("--write")
        self.assertEqual(proc.returncode, 0, proc.stderr)
        self.assertEqual(out.read_text(), FL.render(self.s.derive()))
        self.assertEqual(self.fx("--check").returncode, 0)

    def test_write_twice_is_byte_identical(self):
        out = self.s.root / "function-ledger.json"
        self.fx("--write")
        first = out.read_bytes()
        self.fx("--write")
        self.assertEqual(out.read_bytes(), first)

    def test_check_fails_closed_on_stale_ledger(self):
        self.fx("--write")
        self.s.edit("function-index.json", lambda d: d["functions"][0].update(name="changed"))
        self.s.resync_pins()
        proc = self.fx("--check")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("function ledger stale; rerun scripts/build_function_ledger.py --write", proc.stderr)

    def test_check_fails_on_an_unpinned_index_edit(self):
        self.fx("--write")
        self.s.edit("function-index.json", lambda d: d["functions"][0].update(name="changed"))
        proc = self.fx("--check")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("error:", proc.stderr)

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
