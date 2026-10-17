"""RT-53: the quick scenario set of the raw 0xd3 original-x86 oracle (tests/action_family_d3_runtime_original_oracle.py).

Skips with a clear message when the local original evidence (work/original/GAME.EXE) or Unicorn / Capstone is absent; the full run and the
planted-mutant sweep (tests/action_family_d3_runtime_mutation_check.py) are done by hand (see the oracle's docstring)."""
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
        for module in ('unicorn', 'capstone', 'pefile'):
            if importlib.util.find_spec(module) is None:
                self.skipTest('%s is not installed' % module)
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_d3_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-1500:] + done.stderr[-1500:])
        self.assertIn('"mismatches": 0', done.stdout)


class SanitizerFuzz(unittest.TestCase):
    def test_malformed_inputs_under_asan_ubsan(self):
        import shutil
        if shutil.which('gcc') is None and shutil.which('clang') is None:
            self.skipTest('no C compiler')
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_d3_runtime_original_oracle.py'), '--fuzz', '3000'],
                              capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-1500:] + done.stderr[-1500:])
        self.assertIn('fuzz clean', done.stdout)


if __name__ == '__main__':
    unittest.main()
