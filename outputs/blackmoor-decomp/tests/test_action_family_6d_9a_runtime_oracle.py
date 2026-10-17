"""RT-57: the quick scenario set of the raw 0x6d / raw 0x9a original-x86 oracle
(tests/action_family_6d_9a_runtime_original_oracle.py), the edit-site check of its mutation sweep and one planted native mutant that the
oracle must catch.

Skips with a clear message when the local original evidence (work/original/GAME.EXE) or Unicorn / Capstone is absent; the full run and the
whole planted-mutant sweep (tests/action_family_6d_9a_runtime_mutation_check.py) are done by hand (see the oracle's docstring)."""
import importlib.util
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
ORACLE = PROJECT / 'tests/action_family_6d_9a_runtime_original_oracle.py'
MUTATION = PROJECT / 'tests/action_family_6d_9a_runtime_mutation_check.py'


def need_original(test):
    if not (ROOT / 'work/original/GAME.EXE').exists():
        test.skipTest('local original evidence (work/original/GAME.EXE) is not present')
    for module in ('unicorn', 'capstone', 'pefile'):
        if importlib.util.find_spec(module) is None:
            test.skipTest('%s is not installed' % module)
    if shutil.which('cc') is None and shutil.which('gcc') is None and shutil.which('clang') is None:
        test.skipTest('no C compiler')


class QuickOracleAgainstTheOriginal(unittest.TestCase):
    def test_quick_scenarios_against_the_original_dispatcher(self):
        need_original(self)
        done = subprocess.run([sys.executable, str(ORACLE), '--quick-only', '--fail-fast'], capture_output=True, text=True,
                              cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-1500:] + done.stderr[-1500:])
        self.assertIn('"mismatches": 0', done.stdout)

    def test_scenario_list_covers_both_families(self):
        done = subprocess.run([sys.executable, str(ORACLE), '--list'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stderr[-800:])
        for group in ('a9a_sound', 'a9a_scene', 'a9a_flag', 'a9a_phase', 'a6d_select', 'gate', 'random'):
            self.assertIn('"%s"' % group, done.stdout)


class MutationSweep(unittest.TestCase):
    def test_every_mutation_site_is_found(self):
        done = subprocess.run([sys.executable, str(MUTATION), '--check-sites'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-1500:] + done.stderr[-800:])

    def test_a_planted_stop_loop_mutant_is_killed(self):
        need_original(self)
        source = (PROJECT / 'src/action_family_9a_runtime.c').read_text()
        old = 'channel < STOP_CHANNEL_END'
        self.assertEqual(source.count(old), 1)
        with tempfile.TemporaryDirectory(prefix='rt57_mut_', dir=str(ROOT / 'work')) as tmp:
            for item in (PROJECT / 'src').iterdir():
                if item.suffix in ('.c', '.h'):
                    shutil.copy(item, Path(tmp) / item.name)
            (Path(tmp) / 'action_family_9a_runtime.c').write_text(source.replace(old, 'channel <= STOP_CHANNEL_END'))
            done = subprocess.run([sys.executable, str(ORACLE), '--src', tmp, '--quick-only', '--fail-fast', '--lenient-build'],
                                  capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 1, done.stdout[-800:] + done.stderr[-800:])
        self.assertIn('MISMATCH', done.stdout)


if __name__ == '__main__':
    unittest.main()
