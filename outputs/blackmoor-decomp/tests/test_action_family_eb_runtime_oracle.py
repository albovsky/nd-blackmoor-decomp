#!/usr/bin/env python3
"""RT-56: the raw 0xeb kernel against the unmodified original (Unicorn): the quick scenario subset must report 0 mismatches.

Skipped when the owner's original executable (work/original/GAME.EXE) or the emulation modules are not available. The full scenario set and
the mutation check are separate commands (see action_family_eb_runtime_original_oracle.py and action_family_eb_runtime_mutation_check.py).
"""
import importlib.util
import subprocess
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
ORACLE = HERE / 'action_family_eb_runtime_original_oracle.py'
EXE = ROOT / 'work' / 'original' / 'GAME.EXE'


def missing():
    if not EXE.exists():
        return 'original executable not present'
    for mod in ('unicorn', 'capstone', 'numpy'):
        if importlib.util.find_spec(mod) is None:
            return mod + ' not installed'
    return None


class ActionFamilyEbRuntimeOracle(unittest.TestCase):
    def test_quick_scenarios_match_original(self):
        why = missing()
        if why:
            self.skipTest(why)
        done = subprocess.run([sys.executable, str(ORACLE), '--quick-only', '--fail-fast', '--workers', '1'], capture_output=True, text=True,
                              cwd=str(HERE), timeout=900)
        self.assertEqual(done.returncode, 0, (done.stdout + done.stderr)[-3000:])
        self.assertIn('"mismatches": 0', done.stdout)

    def test_mutation_script_sites_resolve(self):
        done = subprocess.run([sys.executable, str(HERE / 'action_family_eb_runtime_mutation_check.py'), '--check-sites'], capture_output=True,
                              text=True, cwd=str(HERE), timeout=120)
        self.assertEqual(done.returncode, 0, done.stdout[-2000:])


if __name__ == '__main__':
    unittest.main()
