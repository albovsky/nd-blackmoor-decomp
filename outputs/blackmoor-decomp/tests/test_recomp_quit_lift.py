"""Static generation checks for the CRT Quit callback; no guest code executes."""
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


PROJECT = Path(__file__).resolve().parents[1]
WORK = Path(os.environ.get('BLACKMOOR_ORIGINAL_WORK', PROJECT.parents[1] / 'work'))
ORIGINAL = WORK / 'original/GAME.EXE'
ORIGINAL_SHA256 = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
HAVE_LIFT_DEPS = all(importlib.util.find_spec(name) is not None
                     for name in ('capstone', 'pefile'))


@unittest.skipUnless(HAVE_LIFT_DEPS, 'Static lifting requires capstone and pefile')
class RecompQuitLiftTests(unittest.TestCase):
    def test_quit_derived_entry_emits_real_body_and_registration(self):
        if not ORIGINAL.is_file():
            self.skipTest('Owner-local GAME.EXE unavailable for static lifting')
        self.assertEqual(hashlib.sha256(ORIGINAL.read_bytes()).hexdigest(), ORIGINAL_SHA256)
        parent = WORK / 'recomp-quit-lift-tests'
        parent.mkdir(parents=True, exist_ok=True)
        # Preserve private generated files for review; never touch the active
        # production build or leave generated game code under tracked outputs.
        output = Path(tempfile.mkdtemp(prefix='lift-', dir=parent))
        print('RECOMP_QUIT_LIFT private_output=' + str(output))
        command = [sys.executable, '-I', str(PROJECT / 'recomp/lift_recomp.py'),
                   str(output), '24']
        result = subprocess.run(command, capture_output=True, text=True, timeout=180)
        (output / 'lift.log').write_text(result.stdout + result.stderr)
        self.assertEqual(result.returncode, 0, (result.stdout + result.stderr)[-4000:])
        census = json.loads((output / 'lift_census.json').read_text())
        self.assertTrue('0x515d1e' in census['lifted'],
                        census['refused'].get('0x515d1e', 'Quit entry was not generated'))
        self.assertNotIn('0x515d1e', census['refused'])
        registration = (output / 'rc_generated.c').read_text()
        self.assertTrue('rc_register(0x515d1eu, m515d1e_lifted);' in registration,
                        'Quit callback was not registered')
        bodies = []
        marker = '/* GAME.EXE 0x515d1e (13 bytes):'
        for path in output.glob('rc_lifted_*.c'):
            text = path.read_text()
            if marker in text:
                bodies.append(text[text.index(marker):].split('\n}\n', 1)[0])
        self.assertEqual(len(bodies), 1, 'expected one real 13-byte callback body')
        self.assertIn('RD32((uint32_t)(0x63cc50u))', bodies[0])
        self.assertIn('FL41_CALL(0x52a1a8u)', bodies[0])
        self.assertIn('/* 0x515d2a: ret', bodies[0])

    def test_inner_int3_is_still_refused_by_instruction_lifter(self):
        sys.path.insert(0, str(PROJECT / 'scripts'))
        import lift_fl41 as lifter
        # Decode one synthetic trap at an interior address. It is never put
        # into the original image, generated native code, or an executing CPU.
        instruction = next(lifter.md().disasm(b'\xcc', 0x600001))
        context = lifter.Ctx([instruction], 0x600000, 3)
        with self.assertRaisesRegex(lifter.Unsupported, 'int3 inside the code at 0x600001'):
            lifter.lift_one(context, instruction)


if __name__ == '__main__':
    unittest.main()
