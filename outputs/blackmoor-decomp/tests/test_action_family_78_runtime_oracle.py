"""RT-19: the original-x86 oracle and the ASan/UBSan driver, run as part of the suite.

Both take under a minute, so they run fresh every time rather than trusting a stale
report. The oracle runs the unmodified original (loader arm 0x40e56a / constructor
0x4e9c2f, then dispatcher arm 0x42944b, 0x4eaadc, 0x4e8d96, 0x4e9e84, 0x4ea06c, the real
0x4e812f and the real 0x4e0559) under Unicorn and compares the ordered effect log and every
modeled cell with the native kernel for every case; the sanitizer driver feeds bounded
malformed inputs to the kernel and the binding.
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
ORACLE = PROJECT / 'tests/action_family_78_runtime_original_oracle.py'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
CASES = 3646
CASES_BY_GROUP = {'corpus': 763, 'live-S6453': 26, 'synthetic': 2857}


class OriginalOracleTests(unittest.TestCase):
    def test_native_kernel_matches_the_original_in_every_case(self):
        with tempfile.TemporaryDirectory() as tmp:
            report_path = Path(tmp) / 'oracle.json'
            result = subprocess.run([sys.executable, str(ORACLE), '--report', str(report_path)],
                                    capture_output=True, text=True, timeout=900)
            self.assertEqual(result.returncode, 0, (result.stdout + result.stderr)[-2000:])
            report = json.loads(report_path.read_text())
        self.assertEqual(report['original_sha256'], EXE_HASH)
        self.assertEqual(report['mismatches'], 0)
        self.assertEqual(report['cases'], CASES)
        self.assertEqual(report['cases_by_input_group'], CASES_BY_GROUP)
        self.assertEqual(report['false_gate_cases'] + report['true_gate_cases'], CASES)
        self.assertEqual(report['corpus_rows'], 466)
        self.assertGreater(report['loader_cases'], 600)
        self.assertGreater(report['unsafe_cases_rejected_by_native'], 0)
        self.assertEqual(report['live_row4_object'], [23, 0, 1])
        self.assertTrue(all(len(w['sha256']) == 64 for w in report['code_windows']))
        self.assertEqual(len(report['code_windows']), 16)
        # Only the false-gate evaluator and the sound manager boundary are replaced;
        # the rebuild and the UI animation run for real.
        replaced = sorted(key for key in report['hooks_parity_cases'] if key.startswith('REPLACE'))
        self.assertEqual(replaced, ['REPLACE 0x423f57 dependency gate (false-gate cases only)',
                                    'REPLACE 0x4fb2e3 sound manager request (host boundary)'])
        for key in ('observe 0x4e812f view rebuild entry (real code runs)',
                    'observe 0x4e0559 UI animation entry (real code runs)',
                    'observe 0x4e8d96 put back entry', 'observe 0x4e9e84 add entry',
                    'observe 0x4e9edc duplicate exit', 'observe 0x4ea06c remove entry'):
            self.assertIn(key, report['hooks_parity_cases'])
        # Every branch of the decision tree appears in the ordered logs.
        sequences = ','.join(report['event_sequences'])
        for name in ('putback', 'duplicate', 'sound', 'ui', 'visit', 'held', 'count79', 'count,list'):
            self.assertIn(name, sequences)


class SanitizerTests(unittest.TestCase):
    def test_kernel_and_binding_are_clean_under_asan_and_ubsan(self):
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',
                   UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1')
        result = subprocess.run(['sh', str(PROJECT / 'scripts/test_action_family_78_runtime_sanitizers.sh')],
                                capture_output=True, text=True, env=env, timeout=600)
        self.assertEqual(result.returncode, 0, (result.stdout + result.stderr)[-3000:])
        counts = {k: int(v) for k, v in re.findall(r'(\w+)=(\d+)', result.stdout)}
        self.assertGreater(counts['kernel_visits'], 1000000)
        self.assertGreater(counts['kernel_rejections'], 0)
        self.assertGreater(counts['kernel_completed'], 0)
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
