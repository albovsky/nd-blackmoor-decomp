"""RT-22: the original-x86 oracle for the inventory view, run as part of the suite.

The oracle runs the unmodified original under Unicorn (hover 0x4e89eb with the real
0x4ee2a9 and 0x4e8bb4, click 0x4e8dc8 -> 0x4e8e78 with the real remove 0x4ea06c, add
0x4e9e84, rebuild 0x4e812f and close 0x4e7d04, and the rebuild alone) and compares the
ordered effect log, every modeled cell and the view fields with the native kernel for every
case. It takes a few minutes, so it runs fresh every time rather than trusting a stale report.
"""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
ORACLE = PROJECT / 'tests/inventory_view_runtime_original_oracle.py'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
CASES = 5091
HOVER, CLICK, REBUILD = 2408, 2368, 315
REPLACED = ['REPLACE 0x4d36ed screen close notification (host)',
            'REPLACE 0x4e1d34 panel teardown (host UI)',
            'REPLACE 0x4e22fd frame/tab hover control (host UI)',
            'REPLACE 0x4e26fc tab button click (host UI)',
            'REPLACE 0x4edb97 view teardown (host UI)',
            'REPLACE 0x4ee517 frame control click (host UI)',
            'REPLACE 0x4ef2d1 scroll control hover (host UI)',
            'REPLACE 0x4fb2e3 sound manager request (host boundary)']


class OriginalOracleTests(unittest.TestCase):
    def test_native_kernel_matches_the_original_in_every_case(self):
        with tempfile.TemporaryDirectory() as tmp:
            report_path = Path(tmp) / 'oracle.json'
            result = subprocess.run([sys.executable, str(ORACLE), '--report', str(report_path)],
                                    capture_output=True, text=True, timeout=1500)
            self.assertEqual(result.returncode, 0, (result.stdout + result.stderr)[-2500:])
            report = json.loads(report_path.read_text())
        self.assertEqual(report['original_sha256'], EXE_HASH)
        self.assertEqual(report['mismatches'], 0)
        self.assertEqual(report['cases'], CASES)
        self.assertEqual((report['hover']['cases'], report['click']['parity'], report['rebuild']['parity']),
                         (HOVER, CLICK, REBUILD))
        self.assertEqual(report['click']['original_faulted_no_parity'], {})
        self.assertTrue(all(len(w['sha256']) == 64 for w in report['code_windows']))
        self.assertEqual(len(report['code_windows']), 15)
        # Only host boundaries are replaced; the original's decisions all run.
        replaced = sorted(key for key in report['hooks'] if key.startswith('REPLACE'))
        self.assertEqual(replaced, REPLACED)
        for key in ('observe 0x4e89eb hover entry (real code runs)',
                    'observe 0x4e8bb4 slot scan entry (real code runs)',
                    'observe 0x4ee2a9 cursor choice entry (real code runs)',
                    'observe 0x4e8e78 click entry (real code runs)',
                    'observe 0x4e7d04 close entry (real code runs)',
                    'observe 0x4e812f view rebuild entry (real code runs)',
                    'observe 0x4e0559 UI animation entry (real code runs)',
                    'observe 0x4e9e84 add entry', 'observe 0x4ea06c remove entry'):
            self.assertIn(key, report['hooks'])
        # Every leaf of the click decision tree and both hover outcomes were exercised.
        leaves = report['click']['leaves']
        for leaf in ('closed-mode', 'closed-consumed', 'read', 'use', 'pick', 'pick-close', 'put',
                     'put-duplicate', 'none'):
            self.assertGreater(leaves.get(leaf, 0), 50, leaf)
        self.assertGreater(report['hover']['scan_hit'], 200)
        self.assertGreater(report['hover']['scan_ran'] - report['hover']['scan_hit'], 500)
        self.assertGreater(report['hover']['frame_consumed'], 100)
        self.assertGreater(report['hover']['gate_closed'], 100)
        self.assertGreater(report['rebuild']['derived_tabs_refused_by_native'], 100)
        sequences = report['click']['event_sequences']
        self.assertTrue(any(k.startswith('pick,held,visit,count79') and k.endswith('close,close_call')
                            for k in sequences))
        self.assertTrue(any(k.startswith('put,add_flagged,duplicate') for k in sequences))
        self.assertTrue(any('ui,ui_call' in k for k in sequences))
        # The unsafe states: the native kernel refuses each before any persistent effect.
        unsafe = report['unsafe_original_observations']
        self.assertEqual(len(unsafe), 6)
        self.assertTrue(all(row['native_status'] == 'INVVIEW_ERR_BOUNDS' for row in unsafe))


if __name__ == '__main__':
    unittest.main()
