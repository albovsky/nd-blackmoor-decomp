"""RT-4: opcode 17 against the real offline live-audio host.

Builds tests/session_conditions_audio_fixture.c (library + live audio + the
RT-4 binding) and runs it over a synthetic CDSound tree; every expected test
must report PASS.
"""
from __future__ import annotations

import pathlib
import subprocess
import tempfile
import unittest

import test_live_audio as live

PROJECT = pathlib.Path(__file__).resolve().parents[1]
EXPECTED = [
    "unloaded_channel_is_idle_with_the_missing_resource_error",
    "real_offline_play_to_completion_control_one",
    "control_zero_after_completion_is_idle_then_restarted_by_the_pump",
    "channel_outside_the_table_and_missing_audio_are_unavailable",
]


class SessionConditionsAudioTests(unittest.TestCase):
    def test_real_offline_host_fixture(self):
        subprocess.run([str(PROJECT / "scripts/build_session_conditions.sh"), "fixture"],
                       check=True, stdout=subprocess.DEVNULL)
        with tempfile.TemporaryDirectory() as tmp:
            live.build_fixture_tree(pathlib.Path(tmp))
            run = subprocess.run(
                [str(PROJECT / "build/session_conditions_audio_fixture"), tmp],
                capture_output=True, text=True, timeout=120)
        results = {}
        for line in run.stdout.splitlines():
            if line.startswith("TEST "):
                parts = line.split(" ", 3)
                results[parts[1]] = (parts[2], parts[3] if len(parts) > 3 else "")
        for name in EXPECTED:
            self.assertIn(name, results, run.stdout + run.stderr[-500:])
            self.assertEqual(results[name][0], "PASS", (name, results[name]))
        self.assertEqual(run.returncode, 0, run.stderr[-500:])


if __name__ == "__main__":
    unittest.main()
