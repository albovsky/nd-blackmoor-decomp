"""Function names for the Track M sources (scripts/function_names.py): where a name may come from, and what keeps it honest."""

import copy
import json
import re
import sys
import tempfile
import unittest
from pathlib import Path

TESTS = Path(__file__).resolve().parent
SCRIPTS = TESTS.parent / "scripts"
sys.path.insert(0, str(SCRIPTS))

import function_names as names  # noqa: E402


def entry(va, name, status="pending", origin="game", reason=None):
    return {"va": f"0x{va:x}", "name": name, "origin": origin, "status": status, "reason": reason}


def acceptance(va, symbol, cls="native_oracle_verified", note="1:1 with the symbol; every instruction and both jump directions covered."):
    return {"va": f"0x{va:x}", "class": cls, "date": "2026-10-20", "note": note,
            "native_source": {"path": "src/x.c", "symbol": symbol}}


LEDGER = {"entries": [
    entry(0x7f0000, "FUN_007f0000", "ported"),                       # native port
    entry(0x7f0100, "FUN_007f0100", "ported"),                       # shared Vorbis adapter symbol: no name
    entry(0x7f0200, "FUN_007f0200", "ported", origin="library"),     # named by the parity rule
    entry(0x7f0300, "CWnd::GetOwner", "not_needed", "library",
          {"code": "win32_plumbing_no_observable_effect", "text": "[2nd reader agrees] returns the owner HWND, window bookkeeping only"}),
    entry(0x7f0400, "Unwind@007f0400", "pending", "compiler_eh"),
    entry(0x7f0500, "CMFCPropertyPage::CommonInit", "pending", "game"),  # a library name on game code is not trusted
    entry(0x7f0600, "_rand", "ported", "library"),                   # Ghidra name wins over the native symbol
]}
OVERRIDES = {
    "port_acceptances": [
        acceptance(0x7f0000, "m7f0000_init_pair", note="Zeroes the pair and returns this."),
        acceptance(0x7f0100, "his_audio_decode_memory", "host_adapter_tested", "Rule V-PCM-LSB1 output parity only."),
        acceptance(0x7f0200, "his_audio_decode_memory", "host_adapter_tested", "Rule V-PCM-LSB1 output parity only."),
        acceptance(0x7f0600, "session_conditions_crt_rand", "host_adapter_tested", "Same LCG and 15-bit result as the pseudocode."),
    ],
    "vorbis_parity_rule": {"criterion": "the original code (ov_open_callbacks 0x7f0200, ov_read 0x4fe2d0 until the header's count)"},
}
INDEX = {"functions": [{"address": e["va"], "name": e["name"]} for e in LEDGER["entries"]]}


def build():
    return {e["va"]: e for e in names.build(copy.deepcopy(LEDGER), copy.deepcopy(OVERRIDES), copy.deepcopy(INDEX))}


class BuildTests(unittest.TestCase):
    def test_sources_of_names(self) -> None:
        got = build()
        self.assertEqual(got["0x007f0000"]["name"], "m7f0000_init_pair")
        self.assertEqual(got["0x007f0000"]["basis"], "native_port")
        self.assertEqual(got["0x007f0000"]["summary"], "Zeroes the pair and returns this.")
        self.assertIn("src/x.c:m7f0000_init_pair", got["0x007f0000"]["source"])
        self.assertEqual((got["0x007f0200"]["name"], got["0x007f0200"]["basis"]), ("ov_open_callbacks", "parity_rule"))
        self.assertEqual(got["0x007f0400"]["basis"], "ghidra_funclet")
        self.assertIn("exception-unwind funclet", got["0x007f0400"]["summary"])

    def test_the_shared_adapter_symbol_names_no_function(self) -> None:
        self.assertNotIn("0x007f0100", build())

    def test_a_ghidra_function_id_conflict_is_not_a_name(self) -> None:
        ledger = copy.deepcopy(LEDGER)
        ledger["entries"].append(entry(0x7f0700, "FID_conflict:~CHotKeyCtrl", "pending", "library"))
        index = copy.deepcopy(INDEX)
        index["functions"].append({"address": "0x7f0700", "name": "FID_conflict:~CHotKeyCtrl"})
        self.assertNotIn("0x007f0700", {e["va"] for e in names.build(ledger, copy.deepcopy(OVERRIDES), index)})

    def test_a_library_name_on_game_code_is_left_out(self) -> None:
        self.assertNotIn("0x007f0500", build())

    def test_a_reviewed_ledger_reason_becomes_the_summary_without_the_reader_tag(self) -> None:
        got = build()["0x007f0300"]
        self.assertEqual(got["summary"], "returns the owner HWND, window bookkeeping only")
        self.assertIn("win32_plumbing_no_observable_effect", got["source"])

    def test_a_ghidra_name_beats_the_native_symbol_but_keeps_both_in_the_record(self) -> None:
        got = build()["0x007f0600"]
        self.assertEqual((got["name"], got["basis"]), ("_rand", "ghidra_name"))
        self.assertIn("session_conditions_crt_rand", got["source"])
        self.assertEqual(got["summary"], "Same LCG and 15-bit result as the pseudocode.")

    def test_a_placeholder_summary_is_refused(self) -> None:
        bad = copy.deepcopy(OVERRIDES)
        bad["port_acceptances"][0]["note"] = "TODO describe"
        with self.assertRaises(ValueError):
            names.build(copy.deepcopy(LEDGER), bad, copy.deepcopy(INDEX))


class CommittedTableTests(unittest.TestCase):
    def test_every_committed_entry_is_supported_by_the_evidence(self) -> None:
        self.assertEqual(names.check(), [])

    def test_a_changed_entry_is_reported(self) -> None:
        doc = json.loads(names.NAMES.read_text(encoding="utf-8"))
        doc["entries"][0]["name"] = "something_else"
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "names.json"
            path.write_text(json.dumps(doc), encoding="utf-8")
            problems = names.check(path)
        self.assertEqual(len(problems), 1)
        self.assertIn("differs from what the evidence states", problems[0])

    def test_an_entry_the_evidence_no_longer_names_is_reported(self) -> None:
        doc = json.loads(names.NAMES.read_text(encoding="utf-8"))
        doc["entries"].append({"va": "0x007f0000", "name": "invented", "basis": "native_port", "summary": "Invented by hand here.", "source": "x"})
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "names.json"
            path.write_text(json.dumps(doc), encoding="utf-8")
            self.assertTrue(any("no committed evidence names" in p for p in names.check(path)))

    def test_no_hand_annotated_source_has_an_entry_and_every_entry_has_a_machine_source(self) -> None:
        for va in names.load():
            path = names.PROJECT / "asm" / f"FUN_{va:08x}.s"
            head = path.read_text(encoding="utf-8")[:4000]
            self.assertRegex(head, r"(?m)^# annotation:\s+machine\b", path.name)

    def test_names_are_written_into_the_sources_and_counts_add_up(self) -> None:
        doc = json.loads(names.NAMES.read_text(encoding="utf-8"))
        self.assertEqual(doc["counts"]["entries"], len(doc["entries"]))
        self.assertEqual(sum(doc["counts"][b] for b in names.BASES), len(doc["entries"]))
        self.assertNotIn("FID_conflict", " ".join(e["name"] for e in doc["entries"]))
        for e in doc["entries"][:25] + doc["entries"][-25:]:
            text = (names.PROJECT / "asm" / f"FUN_{int(e['va'], 16):08x}.s").read_text(encoding="utf-8")
            self.assertIn(f"# name:         {e['name']}\n", text)
            self.assertIn(f"# naming:       {e['source']}\n", text)
            self.assertIn(f"# name-note:    {e['summary']}\n", text)
            self.assertIn(names.unverified_clause(e), text)
            self.assertFalse(re.search(r"(?m)^# name:\s+fn_", text))

    def test_the_counts_from_the_sources_agree_with_the_audit_reports(self) -> None:
        counts = names.count_sources()
        self.assertEqual(counts["sources"], len(list((names.PROJECT / "asm").glob("FUN_*.s"))))
        lower = counts["named"] + counts["funclet"] + counts["structural"] + counts["inferred"]
        self.assertEqual(lower, len(names.load()))
        self.assertEqual(lower, sum(counts["named_by_basis"].values()))
        tally = {"hand": 0, "named": 0, "funclet": 0, "structural": 0, "inferred": 0, "machine_only": 0}
        for report in sorted((names.PROJECT / "asm").glob("batch-[0-9][0-9][0-9]-report.json")):
            for f in json.loads(report.read_text(encoding="utf-8"))["functions"]:
                tally["hand" if f.get("annotation", "hand") != "machine" else
                      names.tier_of_basis(f["naming"]) if f.get("naming") else "machine_only"] += 1
        self.assertEqual(tally, {k: counts[k] for k in tally})


XREFS = {
    "thunks": [{"va": "0x007f1000", "size": 6, "kind": "import", "import": "DSOUND.dll!#2", "container": "0x007f0f00", "ghidra_thunk": True},
               {"va": "0x007f1010", "size": 5, "kind": "jump", "target": "0x007f2000", "container": "0x007f0f00", "ghidra_thunk": False}],
    "eh_stubs": [{"va": "0x007f1020", "container": "0x007f0f20", "funcinfo": "0x007f3000", "owners": ["0x007f0000"]}],
    "entries": [
        {"va": "0x007f1100", "body_size": 16, "imports": ["KERNEL32.dll!GlobalFree"], "callees": [], "tail_callees": [],
         "indirect_calls": 0, "derived_parts": []},
        {"va": "0x007f1110", "body_size": 16, "imports": ["KERNEL32.dll!GlobalFree"], "callees": ["0x007f0000"], "tail_callees": [],
         "indirect_calls": 0, "derived_parts": []},
    ],
}


class LowerTierTests(unittest.TestCase):
    def test_structural_roles_come_from_the_xrefs_facts(self) -> None:
        got = names.structural_entries(XREFS)
        self.assertEqual(got[0x7f1000]["name"], "import_thunk_DSOUND_ordinal_2")
        self.assertEqual(got[0x7f1010]["name"], "jump_thunk_to_007f2000")
        self.assertEqual(got[0x7f1020]["name"], "eh_handler_stub_of_007f0000")
        self.assertTrue(all(e["basis"] == "structural" for e in got.values()))

    def test_the_import_rule_takes_only_leaf_functions(self) -> None:
        got = names.import_wrapper_entries(XREFS)
        self.assertEqual(list(got), [0x7f1100])
        self.assertEqual(got[0x7f1100]["name"], "inferred_only_call_GlobalFree")
        self.assertEqual(got[0x7f1100]["confidence"], "low")

    def test_a_stronger_tier_is_never_replaced_by_a_lower_one(self) -> None:
        xrefs = copy.deepcopy(XREFS)
        xrefs["thunks"][0]["va"] = "0x007f0000"  # the native port keeps its name
        got = {e["va"]: e for e in names.build(copy.deepcopy(LEDGER), copy.deepcopy(OVERRIDES), copy.deepcopy(INDEX), xrefs)}
        self.assertEqual(got["0x007f0000"]["basis"], "native_port")
        self.assertEqual(got["0x007f1020"]["basis"], "structural")

    def prose(self, **over):
        quote = next(iter(names.load().values()))
        good = next(e for e in names.load().values() if e["basis"] == "inferred_prose")
        entry = copy.deepcopy(good)
        entry.update(over)
        return good, entry

    def test_every_committed_inferred_entry_is_tied_to_its_evidence(self) -> None:
        inferred = [e for e in names.load().values() if e["basis"] in names.INFERRED_BASES]
        self.assertTrue(inferred)
        for e in inferred:
            self.assertTrue(e["name"].startswith("inferred_"), e["name"])
            self.assertEqual(e["confidence"], "low")
            self.assertEqual(names.inferred_problems(e), [], e["name"])

    def test_a_moved_or_misattributed_quote_is_rejected(self) -> None:
        good, entry = self.prose()
        entry["evidence"][0]["quote"] = "a sentence that no file contains"
        self.assertTrue(any("no longer occurs" in p for p in names.inferred_problems(entry)))
        _, other = self.prose(va="0x007f9999")
        self.assertTrue(any("does not contain the address" in p for p in names.inferred_problems(other)))

    def test_an_inferred_name_needs_the_prefix_a_low_confidence_and_a_plain_role(self) -> None:
        _, entry = self.prose(name="scroll_list_loader")
        self.assertTrue(names.inferred_problems(entry))
        _, entry = self.prose(confidence="high")
        self.assertTrue(any("confidence" in p for p in names.inferred_problems(entry)))
        _, entry = self.prose(name="inferred_Bad Name")
        self.assertTrue(names.inferred_problems(entry))

    def test_string_evidence_must_occur_in_the_committed_pseudocode(self) -> None:
        entry = next((e for e in names.load().values() if e["basis"] == "inferred_strings"), None)
        if entry is None:
            self.skipTest("no inferred_strings entry")
        self.assertEqual(names.inferred_problems(entry), [])
        broken = copy.deepcopy(entry)
        broken["evidence"][0]["strings"] = ["s_not_in_this_function_00000000"]
        self.assertTrue(any("does not occur" in p for p in names.inferred_problems(broken)))

    def test_check_refuses_an_inferred_entry_that_shadows_a_stronger_name(self) -> None:
        doc = json.loads(names.NAMES.read_text(encoding="utf-8"))
        good = next(e for e in doc["entries"] if e["basis"] == "inferred_prose")
        port = next(e for e in doc["entries"] if e["basis"] == "native_port")
        doc["entries"].remove(port)
        shadow = copy.deepcopy(good)
        shadow["va"] = port["va"]
        doc["entries"].append(shadow)
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "names.json"
            path.write_text(json.dumps(doc), encoding="utf-8")
            self.assertTrue(any("a stronger tier" in p for p in names.check(path)))


class RefreshTests(unittest.TestCase):
    def test_refresh_rehashes_only_the_changed_source(self) -> None:
        import annotate_machine as machine

        with tempfile.TemporaryDirectory() as tmp:
            asm = Path(tmp)
            (asm / "FUN_00401000.s").write_text("a\n", encoding="utf-8")
            (asm / "FUN_00401010.s").write_text("b\n", encoding="utf-8")
            import hashlib
            sha = lambda t: hashlib.sha256(t.encode()).hexdigest()  # noqa: E731
            manifest = {"functions": [{"source": "FUN_00401000.s", "source_sha256": sha("a\n")},
                                      {"source": "FUN_00401010.s", "source_sha256": sha("b\n")}]}
            (asm / "batch-003.json").write_text(json.dumps(manifest), encoding="utf-8")
            (asm / "FUN_00401010.s").write_text("b2\n", encoding="utf-8")
            machine.cmd_refresh(machine.argparse.Namespace(dir=asm))
            got = json.loads((asm / "batch-003.json").read_text(encoding="utf-8"))["functions"]
            self.assertEqual([f["source_sha256"] for f in got], [sha("a\n"), sha("b2\n")])


if __name__ == "__main__":
    unittest.main()
