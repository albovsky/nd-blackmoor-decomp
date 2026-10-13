"""Source-to-byte report regression for the first S08 matching batch."""
from __future__ import annotations

import json
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
WORK = REPOSITORY / "work"
BUILD_SCRIPT = PROJECT / "scripts" / "build_matching_s08.sh"
REPORT = WORK / "analysis" / "slices" / "S08-matching-report.json"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
EXPECTED = {
    0x0DAE66: (17, "_FUN_004dae66", 0x4DAE66),
    0x0DAE77: (17, "_FUN_004dae77", 0x4DAE77),
    0x0DAEF1: (17, "_FUN_004daef1", 0x4DAEF1),
    0x0DAF02: (22, "_FUN_004daf02", 0x4DAF02),
    0x0DAF18: (17, "_FUN_004daf18", 0x4DAF18),
    0x0DAF29: (22, "_FUN_004daf29", 0x4DAF29),
}


class MatchingS08Tests(unittest.TestCase):
    def test_completed_build_reports_each_complete_function_comparison(self) -> None:
        game_source = json.loads((WORK / "analysis" / "game-source.json").read_text())
        original = Path(game_source["game_dir"]) / "GAME.EXE"
        result = subprocess.run(
            ["bash", str(BUILD_SCRIPT), str(original)],
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("comparison complete", result.stdout.lower())
        report = json.loads(REPORT.read_text())
        self.assertEqual(report["original"]["sha256"], ORIGINAL_SHA256)
        self.assertFalse(report["whole_executable_rebuilt"])
        inventory = report["function_inventory"]
        self.assertEqual(inventory["source"], "outputs/blackmoor-decomp/function-index.json")
        self.assertEqual(inventory["indexed_functions"], 4188)
        self.assertEqual(inventory["index_failures"], 0)
        comparison = report["comparison"]
        self.assertEqual(comparison["function_count"], len(EXPECTED))
        self.assertEqual(comparison["exact_byte_range_count"], 0)
        self.assertEqual(comparison["mismatch_count"], 6)
        self.assertEqual(comparison["difference_count"], 62)
        self.assertEqual(comparison["status"], "toolchain_mismatch_reported")
        self.assertEqual(
            comparison["exact_byte_range_count"] + comparison["mismatch_count"],
            len(EXPECTED),
        )
        self.assertEqual(comparison["rejected_count"], 0)
        self.assertEqual(comparison["difference_count"], comparison["difference_location_count"])
        self.assertIn("i686-pc-windows-msvc", report["toolchain"]["flags"])
        self.assertEqual(report["toolchain"]["optimization"], "-O0")

        actual = {item["rva"]: item for item in report["functions"]}
        self.assertEqual(set(actual), set(EXPECTED))
        for rva, (size, symbol, va) in EXPECTED.items():
            with self.subTest(symbol=symbol):
                entry = actual[rva]
                self.assertEqual(entry["va"], va)
                self.assertEqual(entry["size"], size)
                self.assertEqual(entry["symbol"], symbol)
                self.assertTrue(entry["range_audit"]["complete_to_terminal_ret"])
                self.assertEqual(entry["range_audit"]["decoded_size"], size)
                self.assertEqual(entry["range_audit"]["next_indexed_start_va"], va + size)
                self.assertEqual(entry["range_audit"]["evidence_id"],
                                 "ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619")
                self.assertEqual(entry["mismatch_count"], len(entry["mismatch_offsets"]))
                self.assertGreater(entry["mismatch_count"], 0)
                self.assertEqual(entry["match_status"], "byte-range-mismatch")
                self.assertTrue(entry["original_sha256"])
                self.assertTrue(entry["object_sha256"])
                self.assertFalse(entry["contains_original_byte_values"])


if __name__ == "__main__":
    unittest.main()
