"""RT-60: the quick scenario set of the raw 0xee original-x86 oracle (tests/action_family_ee_runtime_original_oracle.py).

Skips with a clear message when the local original evidence (work/original/GAME.EXE) or Unicorn / Capstone / pefile is absent; the full run
and the planted-mutant sweep (tests/action_family_ee_runtime_mutation_check.py) are done by hand (see the oracle's docstring)."""
import importlib.util
import json
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_ee_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-1500:] + done.stderr[-1500:])
        summary = json.loads(done.stdout.strip().splitlines()[-1])
        self.assertEqual(summary['mismatches'], 0)
        # the quick set must really exercise the pieces (a vacuous run would pass too)
        self.assertGreater(summary['ticks'], 50)
        self.assertEqual(summary['object_bytes'] % 0x2c4, 0)
        for key in ('phase0_steps', 'phase1_steps', 'phase2_steps', 'deals', 'completions', 'clicks_acting', 'pointer_hits', 'render_calls',
                    'invalidates', 'heap_frees', 'heap_mallocs', 'flipback_expired', 'finish_won'):
            self.assertGreater(summary[key], 0, key)
        for kind in ('ENTER', 'RAND', 'TICK', 'SND_PREPARE', 'SND_PLAY', 'LOAD', 'RELEASE', 'RELEASE_SLOT', 'ALLOC', 'COMPLETE', 'TRANSITION',
                     'CLEAR_ITEM', 'RECENTER', 'START', 'AUTOTEXT', 'CAPTION'):
            self.assertGreater(summary['effect_kinds'].get(kind, 0), 0, kind)
        self.assertGreater(sum(summary['native_checks'].values()), 100)


if __name__ == '__main__':
    unittest.main()
