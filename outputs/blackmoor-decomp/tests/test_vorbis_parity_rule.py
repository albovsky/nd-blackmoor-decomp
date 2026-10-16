#!/usr/bin/env python3
"""FL-12: the Vorbis parity rule, its recorded numbers and the adapter's citation of the original functions."""

from __future__ import annotations

import hashlib
import json
import pathlib
import re
import unittest


PROJECT = pathlib.Path(__file__).resolve().parents[1]
ADAPTER = PROJECT / "src/his_audio.c"


def leading_comment(symbol: str) -> str:
    """The block comment directly above the definition of ``symbol`` in the adapter source."""
    text = ADAPTER.read_text(encoding="utf-8")
    match = re.search(r"/\*(?:(?!\*/).)*\*/\s*int " + re.escape(symbol) + r"\(", text, re.S)
    if match is None:
        raise AssertionError(f"no leading comment above {symbol}")
    return match.group(0)


class VorbisParityRuleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.ledger = json.loads((PROJECT / "function-ledger.json").read_text(encoding="utf-8"))
        cls.vorbis = [e for e in cls.ledger["entries"] if e["region"] == "vorbis"]

    def test_adapter_comment_cites_every_vorbis_function_and_part(self) -> None:
        cited = set(re.findall(r"0x[0-9a-f]{6}\b", leading_comment("his_audio_decode_memory")))
        starts = {e["va"] for e in self.vorbis}
        parts = {p for e in self.vorbis for p in e["derived_parts"]}
        self.assertEqual(cited, starts | parts)
        self.assertEqual(len(self.vorbis), 178)

    def test_comment_and_ledger_record_the_same_parity_numbers(self) -> None:
        comment = leading_comment("his_audio_decode_memory")
        rule = self.ledger["vorbis_parity_rule"]
        evidence = rule["evidence"]
        self.assertIn(f"{evidence['byte_equal']} byte-equal", comment)
        self.assertIn(f"{evidence['within_one_lsb']:,} within exactly 1 LSB", comment)
        self.assertIn(f"all {evidence['files']:,} Ogg-bearing HIS files", comment)
        self.assertEqual(evidence["beyond_one_lsb"] + evidence["native_failures"] + evidence["original_failures"], 0)
        harness = PROJECT / evidence["harness"]
        self.assertEqual(hashlib.sha256(harness.read_bytes()).hexdigest(), evidence["harness_sha256"])

    def test_vorbis_functions_are_ported_only_as_adapter_tested(self) -> None:
        self.assertEqual({(e["status"], e["class"]) for e in self.vorbis}, {("ported", "host_adapter_tested")})


if __name__ == "__main__":
    unittest.main()
