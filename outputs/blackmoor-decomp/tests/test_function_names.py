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
            self.assertIn(names.NAMED_CLAUSE, text)
            self.assertFalse(re.search(r"(?m)^# name:\s+fn_", text))

    def test_the_counts_from_the_sources_agree_with_the_audit_reports(self) -> None:
        counts = names.count_sources()
        self.assertEqual(counts["sources"], len(list((names.PROJECT / "asm").glob("FUN_*.s"))))
        self.assertEqual(counts["named"] + counts["funclet"], len(names.load()))
        self.assertEqual(counts["named"] + counts["funclet"], sum(counts["named_by_basis"].values()))
        tally = {"hand": 0, "named": 0, "funclet": 0, "machine_only": 0}
        for report in sorted((names.PROJECT / "asm").glob("batch-[0-9][0-9][0-9]-report.json")):
            for f in json.loads(report.read_text(encoding="utf-8"))["functions"]:
                tally["hand" if f.get("annotation", "hand") != "machine" else "funclet" if f.get("naming") == "ghidra_funclet" else "named" if f.get("naming") else "machine_only"] += 1
        self.assertEqual(tally, {k: counts[k] for k in tally})


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
