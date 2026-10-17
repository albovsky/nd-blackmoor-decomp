"""RT-57: the quick scenario set of the raw 0x1c original-x86 oracle (tests/action_family_1c_runtime_original_oracle.py).

Skips with a clear message when the local original evidence (work/original/GAME.EXE) or Unicorn / Capstone / pefile is absent; the full run
(--workers N), the native-only refusal checks and the planted-mutant sweep (tests/action_family_1c_runtime_mutation_check.py) are done by
hand (see the oracle's docstring)."""
import importlib.util
import shutil
import subprocess
import sys
import unittest
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
ORACLE = PROJECT / 'tests/action_family_1c_runtime_original_oracle.py'


def oracle_ready(test):
    if not (ROOT / 'work/original/GAME.EXE').exists():
        test.skipTest('local original evidence (work/original/GAME.EXE) is not present')
    for module in ('unicorn', 'capstone', 'pefile'):
        if importlib.util.find_spec(module) is None:
            test.skipTest('%s is not installed' % module)
    if shutil.which('cc') is None and shutil.which('clang') is None:
        test.skipTest('no C compiler')


class QuickOracleAgainstTheOriginal(unittest.TestCase):
    def test_quick_scenarios_against_the_original_dispatcher(self):
        oracle_ready(self)
        done = subprocess.run([sys.executable, str(ORACLE), '--quick-only', '--fail-fast'], capture_output=True, text=True,
                              cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-2500:] + done.stderr[-1500:])
        self.assertIn('"mismatches": 0', done.stdout)

    def test_native_only_refusals_match_the_originals_failure_paths(self):
        oracle_ready(self)
        done = subprocess.run([sys.executable, str(ORACLE), '--refusals-only'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-2500:] + done.stderr[-1500:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
