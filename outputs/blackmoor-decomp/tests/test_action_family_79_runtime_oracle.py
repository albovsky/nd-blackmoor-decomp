"""RT-13: the original-x86 oracle and the ASan/UBSan driver, run as part of the suite.

Both take a few seconds, so they run fresh every time rather than trusting a
stale report. The oracle runs the unmodified original (dispatcher arm 0x429486,
0x4eac4c, 0x4ea06c and the real 0x4e812f) under Unicorn and compares the ordered
effect log and every modeled cell with the native kernel for every case; the
sanitizer driver feeds bounded malformed inputs to the kernel and the binding.
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
ROOT = PROJECT.parents[1]
ORACLE = PROJECT / 'tests/action_family_79_runtime_original_oracle.py'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
CASES = 1554
CASES_BY_GROUP = {'corpus': 1330, 'live-S6400-external': 35, 'synthetic': 189}


class OriginalOracleTests(unittest.TestCase):
    def test_native_kernel_matches_the_original_in_every_case(self):
        with tempfile.TemporaryDirectory() as tmp:
            report_path = Path(tmp) / 'oracle.json'
            result = subprocess.run([sys.executable, str(ORACLE), '--report', str(report_path)],
                                    capture_output=True, text=True, timeout=600)
            self.assertEqual(result.returncode, 0, (result.stdout + result.stderr)[-2000:])
            report = json.loads(report_path.read_text())
        self.assertEqual(report['original_sha256'], EXE_HASH)
        self.assertEqual(report['mismatches'], 0)
        self.assertEqual(report['cases'], CASES)
        self.assertEqual(report['cases_by_input_group'], CASES_BY_GROUP)
        self.assertEqual(report['false_gate_cases'] + report['true_gate_cases'], CASES)
        self.assertTrue(all(len(w['sha256']) == 64 for w in report['code_windows']))
        self.assertEqual(len(report['code_windows']), 8)
        # Only the false-gate evaluator is ever replaced; the rebuild runs for real.
        replaced = [key for key in report['hooks_parity_cases'] if key.startswith('REPLACE')]
        self.assertEqual(replaced, ['REPLACE 0x423f57 dependency gate (false-gate cases only)'])
        self.assertIn('observe 0x4e812f view rebuild entry (real code runs)',
                      report['hooks_parity_cases'])


class SanitizerTests(unittest.TestCase):
    def test_kernel_and_binding_are_clean_under_asan_and_ubsan(self):
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',
                   UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1')
        result = subprocess.run(['sh', str(PROJECT / 'scripts/test_action_family_79_runtime_sanitizers.sh')],
                                capture_output=True, text=True, env=env, timeout=600)
        self.assertEqual(result.returncode, 0, (result.stdout + result.stderr)[-3000:])
        counts = {k: int(v) for k, v in re.findall(r'(\w+)=(\d+)', result.stdout)}
        self.assertGreater(counts['kernel_visits'], 1000000)
        self.assertGreater(counts['kernel_rejections'], 0)
        self.assertGreater(counts['handler_ok'], 0)
        self.assertGreater(counts['handler_error'], 0)
        self.assertGreater(counts['begin_ok'], 0)
        self.assertGreater(counts['stub_begin_accepted'], 0)
        self.assertGreater(counts['stub_begin_rejected'], 0)
        self.assertEqual(counts['stub_begin_unreadable'], 3)
        self.assertNotIn('runtime error', result.stderr)
        self.assertNotIn('AddressSanitizer', result.stderr)


if __name__ == '__main__':
    unittest.main()
