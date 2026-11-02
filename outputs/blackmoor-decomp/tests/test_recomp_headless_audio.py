"""Finite synthetic PCM consumption/lifecycle/pacing; no game or devices."""
import hashlib
import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
import tempfile
import unittest

HERE = Path(__file__).resolve().parent
PROJECT = Path(os.environ.get("BLACKMOOR_HEADLESS_AUDIO_PROJECT", HERE.parent)).resolve()


class HeadlessAudioTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        retained = os.environ.get("BLACKMOOR_HEADLESS_AUDIO_OUT")
        if retained:
            cls.output = Path(retained)
            cls.output.mkdir(parents=True, exist_ok=False)
        else:
            cls.temporary = tempfile.TemporaryDirectory(prefix="blackmoor-headless-audio-")
            cls.addClassCleanup(cls.temporary.cleanup)
            cls.output = Path(cls.temporary.name)
        cls.receipt = {"commands": [], "results": {}, "game_executed": False, "devices": False}
        cls.binary = cls.output / "headless-audio-fixture"
        compiler = shlex.split(os.environ.get("CC", "xcrun clang" if sys.platform == "darwin" else "cc"))
        fixture = HERE / "recomp_headless_audio_fixture.c"
        module = PROJECT / "recomp"
        command = compiler + ["-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
                   "-I" + str(module), '-DRC_HEADLESS_AUDIO_SOURCE="' + str(module / "rc_headless_audio.c") + '"',
                   str(fixture), "-pthread", "-o", str(cls.binary)]
        cls.run_command("build", command, 30)
        cls.receipt["source_sha256"] = {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in
            (Path(__file__), fixture, module / "rc_headless_audio.c", module / "rc_headless_audio.h")}
        cls.receipt["native_sha256"] = hashlib.sha256(cls.binary.read_bytes()).hexdigest()
        cls.save()

    @classmethod
    def save(cls):
        (cls.output / "receipt.json").write_text(json.dumps(cls.receipt, indent=2) + "\n")

    @classmethod
    def run_command(cls, name, command, timeout):
        cls.receipt["commands"].append(command)
        result = subprocess.run(command, capture_output=True, text=True, timeout=timeout)
        (cls.output / (name + ".log")).write_text(result.stdout + result.stderr)
        cls.receipt["results"][name] = result.returncode
        cls.save()
        if result.returncode:
            raise AssertionError(name + " failed:\n" + result.stdout + result.stderr)
        return result.stdout

    def test_synthetic_consumption_join_restart_and_fixed_deadlines(self):
        for case in ("lifecycle", "deadlines"):
            with self.subTest(case=case):
                text = self.run_command(case, [str(self.binary), case], 10)
                self.assertIn("HEADLESS_AUDIO " + case + " passed", text)


if __name__ == "__main__":
    unittest.main()
