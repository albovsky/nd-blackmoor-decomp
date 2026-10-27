"""FL-71: the dominator-window infeasibility proofs (scripts/fl71_window.py).

A window proof must agree with the whole-function analysis of FL-67 wherever it says `unsat` (a window never rules out something the full analysis finds possible), must prove the cases it exists for
(a constant test at the top of a loop, the same compare twice) and must not prove a target that a store through another pointer can reach. Part 2 (needs Unicorn and the pinned private GAME.EXE) runs the
window proofs on every instruction and jump direction of a sample of fully covered rows: none may be called impossible.
"""
import os
from pathlib import Path
import sys
import unittest

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(PROJECT / 'scripts'))

try:
    import z3  # noqa: F401
    import fl67_infeasible as P
    import fl71_window as Wn
    import test_fl67_infeasible as T67
    HAVE_Z3 = True
except ImportError:
    HAVE_Z3 = False

BASE = 0x401000
PROGRAMS = dict(getattr(T67, 'PROGRAMS', {})) if HAVE_Z3 else {}
if HAVE_Z3:
    # mov ecx,[esp+4]; L: mov eax,1; test eax,eax; je never; dec ecx; jne L; ret; never: ret
    PROGRAMS['loop_const'] = '8b4c2404 b801000000 85c0 7404 49 75f4 c3 c3'.replace(' ', '')
    # mov ecx,[esp+4]; mov edx,[esp+8]; cmp byte [ecx],0; je out; mov byte [edx],0; cmp byte [ecx],0; je never; ret; out: ret; never: ret
    PROGRAMS['store_between'] = '8b4c2404 8b542408 803900 7409 c60200 803900 7402 c3 c3 c3'.replace(' ', '')


def both(name):
    """(full verdicts, window verdicts) per target of the program"""
    code = bytes.fromhex(PROGRAMS[name])
    image = bytes(BASE - P.IMAGE_BASE) + code + bytes(64)
    row = {'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}
    an = P.Analysis(row, image, 20000)
    an.run()
    an2 = P.Analysis(row, image, 20000)
    an2, dom = Wn.from_analysis(an2)
    full, win = {}, {}
    for ins in an.insns:
        full[('i', ins.address)] = an.instruction(ins.address)[0]
        T = Wn.block_of(an2, ins.address)
        win[('i', ins.address)] = Wn.prove_target(an2, dom, T, ('ins', None))[0] if T in an2.reach else 'unsat'
        if ins.mnemonic.startswith('j') and ins.mnemonic != 'jmp':
            for tag, name_, q in (('t', 'taken', 'taken'), ('f', 'fall-through', 'fall')):
                full[(tag, ins.address)] = an.direction(ins.address, name_)[0]
                T = Wn.block_of(an2, ins.address, True)
                win[(tag, ins.address)] = Wn.prove_target(an2, dom, T, ('dir', q))[0] if T in an2.reach else 'unsat'
    return full, win


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Synthetic(unittest.TestCase):
    def test_a_window_never_rules_out_what_the_full_analysis_finds_possible(self):
        for name in PROGRAMS:
            try:
                full, win = both(name)
            except P.Unsupported:
                continue
            for k, v in win.items():
                if v == 'unsat':
                    self.assertEqual(full[k], 'unsat', (name, k))

    def test_a_constant_test_in_front_of_a_jump(self):
        full, win = both('const_branch')
        self.assertEqual(win[('f', BASE + 4)], 'unsat')
        self.assertNotEqual(win[('t', BASE + 4)], 'unsat')

    def test_the_same_compare_twice(self):
        full, win = both('unsigned_pair')
        jbs = sorted(k[1] for k in win if k[0] == 't')
        self.assertEqual(win[('t', jbs[1])], 'unsat')
        self.assertNotEqual(win[('f', jbs[1])], 'unsat')

    def test_a_constant_test_at_the_top_of_a_loop(self):
        full, win = both('loop_const')
        je = BASE + 11
        self.assertEqual(win[('t', je)], 'unsat')                # the loop re-enters the `mov eax, 1` before every test
        self.assertEqual(win[('i', BASE + 17)], 'unsat')         # `never: ret`

    def test_a_store_through_another_pointer_keeps_the_second_compare_possible(self):
        full, win = both('store_between')
        je2 = BASE + 19
        self.assertNotEqual(full[('t', je2)], 'unsat')
        self.assertNotEqual(win[('t', je2)], 'unsat')

    def test_a_loop_that_moves_esp_keeps_its_jump_possible(self):
        full, win = both('gen_loop_moves_esp')
        for k, v in win.items():
            if v == 'unsat':
                self.assertEqual(full[k], 'unsat', k)


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Oracle(unittest.TestCase):
    def test_no_covered_item_of_a_tested_equivalent_row_is_called_impossible(self):
        import fl66_tested as T
        import original_differential as od
        if not od.available():
            self.skipTest('needs Unicorn and the pinned private work/original/GAME.EXE')
        import json
        covered = json.loads(T.MANIFEST.read_text())['rows']
        keys = sorted((k for k in covered if covered[k]['body'] <= 120), key=lambda k: (covered[k]['body'], k))
        image = P.load_image()
        checked = 0
        for k in keys[::max(1, len(keys) // 12)][:12]:
            try:
                an, dom = Wn.prepare(k, image)
            except P.Unsupported:
                continue
            res = Wn.prove_row_windows(an, dom, P.all_targets(an.row))
            self.assertEqual(res['instructions'], {}, k)
            self.assertEqual(res['directions'], {}, k)
            checked += 1
        self.assertGreaterEqual(checked, 5)


if __name__ == '__main__':
    unittest.main()
