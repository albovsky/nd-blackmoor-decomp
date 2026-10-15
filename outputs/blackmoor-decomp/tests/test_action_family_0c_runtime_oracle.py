"""RT-20: the original-x86 oracle and the ASan/UBSan driver for raw 0x0c, run as part of the suite.

Both take a few seconds, so they run fresh every time rather than trusting a stale report. The
oracle runs the unmodified original (loader arm 0x40bafd, dispatcher arm 0x427c4e, the real gate
0x423f57 and the real handler 0x42b2e4, the pointer cascade's type-0x0c hover case 0x4f2033) under
Unicorn and compares the ordered effect stream and every modeled cell with the native
kernel/binding/session; the sanitizer driver feeds bounded malformed inputs to the kernel and the
binding.
"""
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
ORACLE = PROJECT / 'tests/action_family_0c_runtime_original_oracle.py'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'


class OriginalOracleTests(unittest.TestCase):
    def test_native_runtime_matches_the_original_in_every_case(self):
        with tempfile.TemporaryDirectory() as tmp:
            report_path = Path(tmp) / 'oracle.json'
            result = subprocess.run([sys.executable, str(ORACLE), '--report', str(report_path)],
                                    capture_output=True, text=True, timeout=900)
            self.assertEqual(result.returncode, 0, (result.stdout + result.stderr)[-2000:])
            report = json.loads(report_path.read_text())
        self.assertEqual(report['original_sha256'], EXE_HASH)
        self.assertEqual(report['mismatches'], 0)
        self.assertEqual(report['corpus_bodies'], 43)
        self.assertEqual(report['loader_cases'], 1554)
        self.assertEqual(report['session_sequences'], 1500)
        self.assertEqual(report['kernel_dispatcher_cases'], 2160)
        self.assertGreater(report['session_0c_scene_changes'], 400)
        self.assertGreater(report['events_compared'], 40000)
        self.assertGreater(report['cascade']['family_hits'], 100)
        self.assertEqual(len(report['code_windows']), 19)
        self.assertTrue(all(len(w['sha256']) == 64 for w in report['code_windows']))
        # Only the false-gate evaluator and the allocator stand-in are ever replaced.
        replaced = sorted(key for key in report['hooks'] if key.startswith('REPLACE'))
        self.assertEqual(replaced, ['REPLACE 0x423f57 dependency gate (false-gate rows only)',
                                    'REPLACE 0x51dc43 allocator (loader runs only)'])
        self.assertIn('observe 0x42b2e4 handler entry (raw 0x0c rows)', report['hooks'])
        self.assertGreaterEqual(len(report['unsafe_original_observations']), 3)


class SanitizerTests(unittest.TestCase):
    def test_kernel_and_binding_are_clean_under_asan_and_ubsan(self):
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',
                   UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1')
        result = subprocess.run(['sh', str(PROJECT / 'scripts/test_action_family_0c_runtime_sanitizers.sh')],
                                capture_output=True, text=True, env=env, timeout=600)
        self.assertEqual(result.returncode, 0, (result.stdout + result.stderr)[-3000:])
        counts = {k: int(v) for k, v in re.findall(r'(\w+)=(\d+)', result.stdout)}
        self.assertGreater(counts['accepted'], 0)
        self.assertGreater(counts['rejected'], 0)
        self.assertGreater(counts['finished'], 0)
        self.assertGreater(counts['handler_ok'], 0)
        self.assertGreater(counts['handler_error'], 0)
        self.assertGreater(counts['begin_ok'], 0)
        self.assertEqual(counts['stub_scene_failing_begins'], 4)


if __name__ == '__main__':
    unittest.main()
