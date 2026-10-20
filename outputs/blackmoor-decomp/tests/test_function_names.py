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
    entry(0x401000, "FUN_00401000", "ported"),                       # native port
    entry(0x401100, "FUN_00401100", "ported"),                       # shared Vorbis adapter symbol: no name
    entry(0x401200, "FUN_00401200", "ported", origin="library"),     # named by the parity rule
    entry(0x401300, "CWnd::GetOwner", "not_needed", "library",
          {"code": "win32_plumbing_no_observable_effect", "text": "[2nd reader agrees] returns the owner HWND, window bookkeeping only"}),
    entry(0x401400, "Unwind@00401400", "pending", "compiler_eh"),
    entry(0x401500, "CMFCPropertyPage::CommonInit", "pending", "game"),  # a library name on game code is not trusted
    entry(0x401600, "_rand", "ported", "library"),                   # Ghidra name wins over the native symbol
]}
OVERRIDES = {
    "port_acceptances": [
        acceptance(0x401000, "m401000_init_pair", note="Zeroes the pair and returns this."),
        acceptance(0x401100, "his_audio_decode_memory", "host_adapter_tested", "Rule V-PCM-LSB1 output parity only."),
        acceptance(0x401200, "his_audio_decode_memory", "host_adapter_tested", "Rule V-PCM-LSB1 output parity only."),
        acceptance(0x401600, "session_conditions_crt_rand", "host_adapter_tested", "Same LCG and 15-bit result as the pseudocode."),
    ],
    "vorbis_parity_rule": {"criterion": "the original code (ov_open_callbacks 0x401200, ov_read 0x4fe2d0 until the header's count)"},
}
INDEX = {"functions": [{"address": e["va"], "name": e["name"]} for e in LEDGER["entries"]]}


def build():
    return {e["va"]: e for e in names.build(copy.deepcopy(LEDGER), copy.deepcopy(OVERRIDES), copy.deepcopy(INDEX))}


class BuildTests(unittest.TestCase):
    def test_sources_of_names(self) -> None:
        got = build()
        self.assertEqual(got["0x00401000"]["name"], "m401000_init_pair")
        self.assertEqual(got["0x00401000"]["basis"], "native_port")
        self.assertEqual(got["0x00401000"]["summary"], "Zeroes the pair and returns this.")
        self.assertIn("src/x.c:m401000_init_pair", got["0x00401000"]["source"])
        self.assertEqual((got["0x00401200"]["name"], got["0x00401200"]["basis"]), ("ov_open_callbacks", "parity_rule"))
        self.assertEqual(got["0x00401400"]["basis"], "ghidra_name")
        self.assertIn("exception-unwind funclet", got["0x00401400"]["summary"])

    def test_the_shared_adapter_symbol_names_no_function(self) -> None:
        self.assertNotIn("0x00401100", build())

    def test_a_library_name_on_game_code_is_left_out(self) -> None:
        self.assertNotIn("0x00401500", build())

    def test_a_reviewed_ledger_reason_becomes_the_summary_without_the_reader_tag(self) -> None:
        got = build()["0x00401300"]
        self.assertEqual(got["summary"], "returns the owner HWND, window bookkeeping only")
        self.assertIn("win32_plumbing_no_observable_effect", got["source"])

    def test_a_ghidra_name_beats_the_native_symbol_but_keeps_both_in_the_record(self) -> None:
        got = build()["0x00401600"]
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
        doc["entries"].append({"va": "0x00401000", "name": "invented", "basis": "native_port", "summary": "Invented by hand here.", "source": "x"})
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
        for e in doc["entries"][:25] + doc["entries"][-25:]:
            text = (names.PROJECT / "asm" / f"FUN_{int(e['va'], 16):08x}.s").read_text(encoding="utf-8")
            self.assertIn(f"# name:         {e['name']}\n", text)
            self.assertIn(f"# naming:       {e['source']}\n", text)
            self.assertIn(f"# summary:      {e['summary']}\n", text)
            self.assertFalse(re.search(r"(?m)^# name:\s+fn_", text))

    def test_the_counts_from_the_sources_agree_with_the_audit_reports(self) -> None:
        counts = names.count_sources()
        self.assertEqual(counts["sources"], len(list((names.PROJECT / "asm").glob("FUN_*.s"))))
        self.assertEqual(counts["named"], len(names.load()))
        self.assertEqual(counts["named"], sum(counts["named_by_basis"].values()))
        tally = {"hand": 0, "named": 0, "machine_only": 0}
        for report in sorted((names.PROJECT / "asm").glob("batch-[0-9][0-9][0-9]-report.json")):
            for f in json.loads(report.read_text(encoding="utf-8"))["functions"]:
                tally["hand" if f.get("annotation", "hand") != "machine" else "named" if f.get("naming") else "machine_only"] += 1
        self.assertEqual(tally, {k: counts[k] for k in tally})


if __name__ == "__main__":
    unittest.main()
