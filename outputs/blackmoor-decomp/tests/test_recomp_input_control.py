"""Finite FIFO/parser/capture host tests; no guest, app or device executes."""
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
# Candidate-only validation may point at the actual production project before
# these test files are collected. Installed tests use their normal parent.
PROJECT = Path(os.environ.get("BLACKMOOR_CONTROL_TEST_PROJECT", HERE.parent)).resolve()
MODULE = PROJECT / "recomp"
SCENARIOS = (
    "ordered", "split-worker-tail", "missing-hwnd", "shot-failure",
    "partial-eof", "empty-writer-eof", "active-eof", "finish-eof",
    "finish-then-host-error", "early-exit", "malformed", "duplicate",
    "out-of-order", "id-overflow", "id-leading-zero", "after-finish",
    "partial-after-finish", "delayed-after-finish", "nul", "crlf",
    "max-batch", "oversize", "step-limit", "max-requests", "open-guards",
)


class InputControlTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        retained = os.environ.get("BLACKMOOR_CONTROL_TEST_OUT")
        if retained:
            cls.build = Path(retained)
            cls.build.mkdir(parents=True, exist_ok=False)
        else:
            cls.temporary = tempfile.TemporaryDirectory(prefix="blackmoor-input-control-")
            cls.addClassCleanup(cls.temporary.cleanup)
            cls.build = Path(cls.temporary.name)
        cls.receipt = {"commands": [], "results": {}, "game_executed": False,
                       "devices": False, "scenario_count": len(SCENARIOS),
                       "max_polls_per_scenario": 200000, "process_timeout_seconds": 2}
        cls.protocol = cls.build / "input-control-fixture"
        cls.capture = cls.build / "control-capture-fixture"
        compiler = shlex.split(os.environ.get("CC", "xcrun clang" if sys.platform == "darwin" else "cc"))
        common = compiler + ["-std=gnu11", "-O2", "-Wall", "-Wextra", "-Werror",
                             "-I" + str(MODULE), "-I" + str(PROJECT / "src")]
        fixture = HERE / "recomp_input_control_fixture.c"
        capture_fixture = HERE / "recomp_control_capture_fixture.c"
        cls.compile("protocol-build", common + [str(fixture), str(MODULE / "rc_input_control.c"),
                    str(MODULE / "rc_input_script.c"), "-o", str(cls.protocol)])
        dead_strip = "-Wl,-dead_strip" if sys.platform == "darwin" else "-Wl,--gc-sections"
        cls.compile("capture-build", common + ["-Wno-unused-parameter", "-ffunction-sections",
                    "-fdata-sections", '-DRC_CONTROL_HEADLESS_SOURCE="' + str(MODULE / "rc_headless.c") + '"',
                    str(capture_fixture), dead_strip, "-o", str(cls.capture)])
        sources = [Path(__file__), fixture, capture_fixture] + [MODULE / name for name in
                   ("rc_input_control.c", "rc_input_control.h", "rc_input_script.c", "rc_input_script.h",
                    "rc_headless.c", "rc_internal.h", "rc.h", "rc_platform.h", "rc_pointer_input.h",
                    "diagnostic_result.h")]
        cls.receipt["source_sha256"] = {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}
        cls.receipt["native_sha256"] = {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in (cls.protocol, cls.capture)}
        cls.save_receipt()

    @classmethod
    def save_receipt(cls):
        (cls.build / "receipt.json").write_text(json.dumps(cls.receipt, indent=2) + "\n")

    @classmethod
    def compile(cls, name, command):
        cls.receipt["commands"].append(command)
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        (cls.build / (name + ".log")).write_text(result.stdout + result.stderr)
        cls.receipt["results"][name] = {"exit_code": result.returncode}
        cls.save_receipt()
        if result.returncode:
            raise AssertionError(name + " failed:\n" + result.stdout + result.stderr)

    def run_fixture(self, name, binary, arguments):
        command = [str(binary)] + arguments
        self.receipt["commands"].append(command)
        result = subprocess.run(command, capture_output=True, text=True, timeout=2)
        (self.build / (name + ".log")).write_text(result.stdout + result.stderr)
        self.receipt["results"][name] = {"exit_code": result.returncode}
        self.save_receipt()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("INPUT_CONTROL ", result.stdout)

    def test_fifo_protocol_batches_and_explicit_completion(self):
        for scenario in SCENARIOS:
            with self.subTest(scenario=scenario):
                directory = self.build / scenario
                directory.mkdir()
                self.run_fixture(scenario, self.protocol, [scenario, str(directory)])

    def test_actual_headless_capture_close_unique_files_and_live_ack_flush(self):
        directory = self.build / "capture"
        directory.mkdir()
        self.run_fixture("capture", self.capture, [str(directory)])


if __name__ == "__main__":
    unittest.main()
