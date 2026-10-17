"""RT-58: the quick scenario set of the raw 0x76 original-x86 oracle (tests/action_family_76_runtime_original_oracle.py).

Skips with a clear message when the local original evidence (work/original/GAME.EXE) or Unicorn / Capstone is absent; the full run and the
planted-mutant sweep (tests/action_family_76_runtime_mutation_check.py) are done by hand (see the oracle's docstring)."""
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_76_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-1500:] + done.stderr[-1500:])
        summary = json.loads(done.stdout.strip().splitlines()[-1])
        self.assertEqual(summary['mismatches'], 0)
        # the quick set must really exercise the pieces (a vacuous run would pass too)
        self.assertGreater(summary['ticks'], 100)
        self.assertEqual(summary['filter_bytes'], 256)
        for action in ('key', 'pointer', 'click', 'invalidate', 'cleanup', 'new_game', 'render'):
            self.assertGreater(summary['actions'].get(action, 0), 0, action)
        for visit in ('phase0', 'phase1_state_0', 'phase1_state_3', 'phase2_cancel'):
            self.assertGreater(summary['handler_visits'].get(visit, 0), 0, visit)
        self.assertGreater(summary['native_refusal_checks'], 200)


if __name__ == '__main__':
    unittest.main()
