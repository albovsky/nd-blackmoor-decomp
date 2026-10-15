"""RT-21: the original-x86 oracle and the ASan/UBSan driver, run as part of the suite.

Both take well under a minute, so they run fresh every time rather than trusting a stale
report. The oracle runs the unmodified original (loader arm 0x40f069 / constructor 0x410f99,
then dispatcher arm 0x4297be with the real gate and tree, 0x432d1a and 0x42ba3a) under
Unicorn and compares the ordered effect log, the whole event table, phase, completion and the
scene-change cells with the native kernel for every case; the sanitizer driver feeds bounded
malformed inputs to the constructor, the shared visit and the binding.
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
ORACLE = PROJECT / 'tests/action_family_a1_runtime_original_oracle.py'
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
        self.assertEqual(report['corpus_records'], 565)
        self.assertEqual(report['corpus_keys_missing'], 0)       # every corpus key resolves
        self.assertEqual(report['synthetic_keys_missing'], 6)    # the original fallback text, 3 keys x 2
        self.assertGreaterEqual(report['corpus_lifecycle_cases'], 565)
        self.assertGreater(report['synthetic_event_cases'], 500)
        self.assertGreater(report['visits'], 6000)
        self.assertGreater(report['event_stores'], 900)
        self.assertEqual(report['false_gate_cases'], 12)
        self.assertEqual(report['event_driven_gate_cases'], 3)
        self.assertEqual(report['s6408_row4'], dict(stem='NSHT14', event=1000, value=1,
                                                    scene=6409, channel=13))
        self.assertEqual(len(report['code_windows']), 9)
        self.assertTrue(all(len(w['sha256']) == 64 for w in report['code_windows'].values()))
        # Only OS and host boundaries are replaced; the gate, the phase machine, the event
        # store and the finish all run as original instructions.
        for key in report['runtime_hooks']:
            self.assertRegex(key, r'^0x[0-9a-f]+:(COM:\w+|caption-ui|file-exists|HIS-decode|'
                                  r'allocation\(dependency tree\))$')
        for entry in ('0x4297be', '0x423f57', '0x432d1a', '0x42ba3a', '0x423d33', '0x4f6334'):
            self.assertIn(entry, report['executed_function_entries'])


class SanitizerTests(unittest.TestCase):
    def test_constructor_visit_and_binding_are_clean_under_asan_and_ubsan(self):
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',
                   UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1')
        result = subprocess.run(['sh', str(PROJECT / 'scripts/test_action_family_a1_runtime_sanitizers.sh')],
                                capture_output=True, text=True, env=env, timeout=600)
        self.assertEqual(result.returncode, 0, (result.stdout + result.stderr)[-3000:])
        counts = {k: int(v) for k, v in re.findall(r'(\w+)=(\d+)', result.stdout)}
        for key in ('construct_ok', 'construct_rejected', 'construct_lookup_failed',
                    'construct_missing', 'step_ok', 'step_rejected', 'step_unsupported',
                    'step_event_stores', 'binding_scenes_opened', 'scenes_rejected_by_parser',
                    'begin_ok', 'handler_ok', 'handler_error', 'handler_unsupported',
                    'binding_event_stores'):
            self.assertGreater(counts[key], 0, key)
        self.assertGreater(counts['step_visits'], 9000)
        self.assertNotIn('runtime error', result.stderr)
        self.assertNotIn('AddressSanitizer', result.stderr)


if __name__ == '__main__':
    unittest.main()
