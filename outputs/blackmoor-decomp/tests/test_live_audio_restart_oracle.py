#!/usr/bin/env python3
"""RT-11.1: the native pump against the original x86 sound pump (Unicorn).

The full comparison and the oracle half of the mutation checks. Skips when the
pinned GAME.EXE or Unicorn is unavailable; never launches Windows.
"""
from __future__ import annotations

import pathlib
import shutil
import tempfile
import unittest

import live_audio_restart_original_oracle as oracle
import sound_control_original_oracle as base
import test_live_audio_restart as restart

try:
    import unicorn  # noqa: F401
    HAVE_UNICORN = True
except ImportError:
    HAVE_UNICORN = False


@unittest.skipUnless(HAVE_UNICORN and base.DEFAULT_EXE.is_file(), "needs Unicorn and the pinned GAME.EXE")
class RestartOracleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.pe = oracle.load_pe(base.DEFAULT_EXE)
        cls.tmp = pathlib.Path(tempfile.mkdtemp(prefix="rt111-oracle-test-"))
        cls.tree = cls.tmp / "game"
        restart.build_tree(cls.tree)
        built = restart.build("fixture")
        if built.returncode != 0:
            raise RuntimeError(built.stderr[-1500:])
        cls.driver = restart.PROJECT / "build/live_audio_restart_driver"

    @classmethod
    def tearDownClass(cls) -> None:
        shutil.rmtree(cls.tmp, ignore_errors=True)

    def test_every_scenario_agrees_with_the_original(self) -> None:
        compared, _names = oracle.compare_all(self.pe, self.tree, self.driver)
        self.assertGreaterEqual(compared["scenarios"], 160)
        self.assertGreaterEqual(compared["steps"], 1900)
        self.assertGreaterEqual(compared["play_effects"], 200)
        self.assertGreaterEqual(compared["rand_effects"], 21)

    def test_the_oracle_notices_broken_rules(self) -> None:
        for name, target, old, new, _must_fail, scenario_filter in restart.MUTATIONS:
            if scenario_filter is None:
                continue
            with self.subTest(mutation=name):
                text = restart.PROVIDER.read_text()
                self.assertEqual(text.count(old), 1, name)
                mutant_dir = self.tmp / ("mutant-" + name)
                mutant_dir.mkdir()
                mutant = mutant_dir / "live_audio.c"
                mutant.write_text(text.replace(old, new, 1))
                built = restart.build("fixture", build_dir=mutant_dir, provider=mutant)
                self.assertEqual(built.returncode, 0, built.stderr[-1500:])
                with self.assertRaises(base.OracleFailure, msg=f"mutation {name} survived the oracle"):
                    oracle.compare_all(self.pe, self.tree, mutant_dir / "live_audio_restart_driver",
                                       only=scenario_filter)


if __name__ == "__main__":
    unittest.main(verbosity=2)
