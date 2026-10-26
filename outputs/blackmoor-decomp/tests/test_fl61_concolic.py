"""FL-61: the concolic coverage generator (scripts/fl61_concolic.py).

- the shadow's arithmetic helpers agree with plain integer arithmetic;
- the cone-of-influence slicing keeps exactly the constraints that share variables with the goal;
- (needs Unicorn, z3 and the private original) the generator completes the coverage of one small row that the guided search left at one missing jump direction, and every scenario it keeps is a
  scenario the original and the translation agree on;
"""
import json
from pathlib import Path
import random
import sys
import unittest

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(PROJECT / 'scripts'))
import original_differential as od

try:
    import z3
    import fl61_concolic as C
    HAVE = True
except ImportError:                 # pragma: no cover - depends on the box
    HAVE = False


@unittest.skipUnless(HAVE, 'needs z3, capstone and unicorn')
class ShadowArithmetic(unittest.TestCase):
    def test_helpers_match_integer_arithmetic(self):
        rng = random.Random(61)
        for _ in range(300):
            s = rng.choice((1, 2, 4))
            mask = (1 << (8 * s)) - 1
            a, b = rng.getrandbits(8 * s), rng.getrandbits(8 * s)
            for fn, ref in ((C.op_add, lambda x, y: x + y), (C.op_sub, lambda x, y: x - y), (C.op_and, lambda x, y: x & y), (C.op_or, lambda x, y: x | y), (C.op_xor, lambda x, y: x ^ y),
                            (C.op_mul, lambda x, y: x * y)):
                want = ref(a, b) & mask
                self.assertEqual(C.binop(fn, a, b, s), want)
                got = z3.simplify(C.binop(fn, C.E(a, s), C.E(b, s) if rng.random() < 0.5 else z3.BitVec('v', 8 * s), s))
                if z3.is_bv_value(got):
                    self.assertEqual(got.as_long(), want)
            self.assertEqual(C.sext(a, s, 4), (a - (1 << (8 * s)) if a >> (8 * s - 1) else a) & 0xffffffff)
            self.assertEqual(C.zext(a, s, 4), a)
            self.assertEqual(C.trunc(a | (1 << 40), s), a)

    def test_slices_keep_only_connected_constraints(self):
        x, y, z, w = (z3.BitVec(n, 8) for n in 'xyzw')
        keep = [x == 1, y == 2, z > x, x < y, w == 3, x < 9]          # the expressions stay alive: the variable cache is keyed by AST id
        C._var_cache.clear()
        sl = C.Slices()
        for c in keep[:3]:
            sl.add(c)
        self.assertEqual(len(sl.group(keep[3])), 3)          # x ~ y joins the three
        sl2 = C.Slices()
        sl2.add(keep[0])
        sl2.add(keep[1])
        self.assertEqual(len(sl2.group(keep[4])), 0)
        self.assertEqual(len(sl2.group(keep[5])), 1)


@unittest.skipUnless(HAVE and od.available(), 'needs z3, Unicorn and the pinned private work/original/GAME.EXE')
class GeneratorOnRealRows(unittest.TestCase):
    def test_a_small_row_reaches_full_coverage(self):
        # 0x45eadc: a loop that sums a table and compares the sum with three times a field; the guided search left one direction (the sum equal to the field) untaken
        row = C.Row('0x45eadc')
        res = C.explore(row, C.starting_seeds('0x45eadc'), budget_s=120, max_runs=400, fresh_seeds=8, log=lambda *_: None)
        self.assertEqual(res['missing'], [])
        self.assertEqual(res['untaken'], [])
        self.assertEqual(res['mismatch'], [])
        self.assertTrue(res['kept'])


if __name__ == '__main__':
    unittest.main()
