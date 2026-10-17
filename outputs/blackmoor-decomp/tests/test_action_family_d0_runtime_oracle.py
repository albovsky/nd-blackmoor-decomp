"""RT-50: the quick scenario set of the raw 0xd0 original-x86 oracle (tests/action_family_d0_runtime_original_oracle.py).

Skips with a clear message when the local original evidence (work/original/GAME.EXE) or Unicorn is absent; the full run and the
planted-mutant sweep are done by hand (see the oracle's docstring)."""
import importlib.util
import subprocess
import sys
import unittest
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]


class QuickOracleAgainstTheOriginal(unittest.TestCase):
    def test_quick_scenarios_against_the_original_dispatcher(self):
        if not (ROOT / 'work/original/GAME.EXE').exists():
            self.skipTest('local original evidence (work/original/GAME.EXE) is not present')
        for module in ('unicorn', 'capstone', 'numpy'):
            if importlib.util.find_spec(module) is None:
                self.skipTest('%s is not installed' % module)
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_d0_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-1500:] + done.stderr[-1500:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
