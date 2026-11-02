"""FL-77: the documented-exception slice of pending (tasks/fl77-exceptions.json, ledger key documented_exceptions).

A documented exception is PENDING, never ported and never tested equivalent: the project stopped working on it and wrote down why. These tests check the committed manifest against the
committed ledger, and that the ledger validator refuses an exception that is ported, tested equivalent, unknown or counted wrongly.
"""
import copy
import importlib.util
import json
from pathlib import Path
import sys
import unittest

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parent.parent
SPEC = importlib.util.spec_from_file_location("blackmoor_function_ledger", PROJECT / "decomp-progress" / "function_ledger.py")
FL = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(FL)

LEDGER = json.loads((PROJECT / "function-ledger.json").read_text())
ENTRIES = {e["va"]: e for e in LEDGER["entries"]}
MANIFEST = json.loads((PROJECT / FL.DE_FILE).read_text())
DE = LEDGER["documented_exceptions"]
TE = set(LEDGER["tested_equivalent"]["vas"])


class Slice(unittest.TestCase):
    def test_manifest_and_ledger_agree(self):
        self.assertEqual(DE["vas"], sorted(MANIFEST["rows"], key=lambda k: int(k, 16)))
        self.assertEqual(DE["count"], len(MANIFEST["rows"]))
        self.assertEqual(sum(DE["by_reason"].values()), DE["count"])
        for va, row in DE["rows"].items():
            self.assertEqual(row, MANIFEST["rows"][va])
            self.assertIn(row["reason"], MANIFEST["reasons"])

    def test_every_exception_is_pending_and_not_tested_equivalent(self):
        for va in DE["vas"]:
            self.assertEqual(ENTRIES[va]["status"], "pending", va)
            self.assertNotIn(va, TE, va)

    def test_the_slice_never_changes_the_verified_count(self):
        ported = sum(1 for e in LEDGER["entries"] if e["status"] == "ported")
        self.assertEqual(ported, LEDGER["counts"]["status"]["ported"])
        self.assertFalse(set(DE["vas"]) & {v for v, e in ENTRIES.items() if e["status"] != "pending"})

    def test_every_pending_mac_port_function_is_ported_tested_equivalent_or_an_exception(self):
        left = [v for v, e in ENTRIES.items() if e["status"] == "pending" and e["region"] in ("game", "vorbis")
                and v not in TE and v not in DE["rows"]]
        self.assertEqual(left, [])


class Validator(unittest.TestCase):
    def bad(self, change, what):
        de = copy.deepcopy(DE)
        change(de)
        with self.assertRaisesRegex(FL.LedgerError, what):
            FL.validate_documented_exceptions(de, ENTRIES, TE)

    def test_a_valid_slice_passes(self):
        FL.validate_documented_exceptions(copy.deepcopy(DE), ENTRIES, TE)

    def test_refuses_a_ported_function(self):
        ported = next(v for v, e in ENTRIES.items() if e["status"] == "ported")
        def change(de):
            row = next(iter(de["rows"].values()))
            de["vas"] = sorted(de["vas"] + [ported], key=lambda k: int(k, 16))
            de["rows"][ported] = row
            de["count"] += 1
            de["by_reason"][row["reason"]] += 1
        self.bad(change, "not a pending")

    def test_refuses_a_tested_equivalent_function(self):
        te = sorted(TE, key=lambda k: int(k, 16))[0]
        def change(de):
            row = next(iter(de["rows"].values()))
            de["vas"] = sorted(de["vas"] + [te], key=lambda k: int(k, 16))
            de["rows"][te] = row
            de["count"] += 1
            de["by_reason"][row["reason"]] += 1
        self.bad(change, "tested equivalent")

    def test_refuses_an_unknown_reason_and_wrong_counts(self):
        def unknown(de):
            va = de["vas"][0]
            de["rows"][va] = {"reason": "no_such_reason", "note": "x"}
        self.bad(unknown, "unknown reason")
        self.bad(lambda de: de.update(count=de["count"] + 1), "count differs")
        self.bad(lambda de: de["by_reason"].update({next(iter(de["by_reason"])): 999}), "by_reason")
        self.bad(lambda de: de.update(rule="other"), "unknown rule")


if __name__ == "__main__":
    unittest.main()
