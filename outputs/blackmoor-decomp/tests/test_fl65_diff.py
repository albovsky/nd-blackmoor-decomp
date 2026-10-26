#!/usr/bin/env python3
"""FL-65 tests of the rule `unobserved bits` (scripts/fl65_diff.py) on rows of the private original (skipped without it): a partial-register mask bit that a shift moves out and a narrower read masked by
`and r, 0xffff` are explained; a narrower read whose value is stored, used as an address or tested by a jump is not."""
import json
from pathlib import Path
import sys
import unittest

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl43_equiv as E
import fl65_diff as D

CORPUS = json.loads((HERE / 'fl41_corpus.json').read_text())


def row_lines(key):
    import fl41_mutation_check as M
    text = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text()).get(key)
    return text.split('\n') if text else None


@unittest.skipUnless('0x495536' in CORPUS and (PROJECT.parent.parent / 'work/original/GAME.EXE').exists(), 'needs the private original and the row in the corpus')
class Rule(unittest.TestCase):
    def find(self, lines, addr):
        return next(i for i, l in enumerate(lines) if '/* 0x%x: ' % addr in l)

    def test_mask_bit_shifted_out(self):
        lines = row_lines('0x495536')
        fn = E.Function(0x495536, CORPUS['0x495536']['body'])
        n = self.find(lines, 0x495575)
        mut = lines[n].replace('0xffffff00u', '0xffffff01u')
        self.assertNotEqual(mut, lines[n])
        self.assertTrue(D.unobserved_ok('literal', lines, n, [mut], '0x495536', fn))

    def test_narrower_read_that_is_stored_is_not_explained(self):
        lines = row_lines('0x495536')
        fn = E.Function(0x495536, CORPUS['0x495536']['body'])
        n = self.find(lines, 0x495575)
        mut = lines[n].replace('RD8((uint32_t)(edx + 0x1u))', 'RD8((uint32_t)(edx + 0x2u))')       # another address: every bit of al differs, and al is stored
        self.assertFalse(D.unobserved_ok('literal', lines, n, [mut], '0x495536', fn))

    def test_upper_half_masked_by_and(self):
        if '0x4fb0bf' not in CORPUS:
            self.skipTest('row not in the corpus')
        lines = row_lines('0x4fb0bf')
        fn = E.Function(0x4fb0bf, CORPUS['0x4fb0bf']['body'])
        n = self.find(lines, 0x4fb11a)
        self.assertTrue(D.unobserved_ok('width', lines, n, [lines[n].replace('RD32', 'RD16')], '0x4fb0bf', fn))


class Initial(unittest.TestCase):
    def test_pure_form_bits(self):
        t0, fl = D.initial_difference('    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x1: mov */', '    ecx = RD16((uint32_t)(ebp + 0x8u));  /* 0x1: mov */')
        self.assertEqual(t0['ecx'], 0xffff0000)
        self.assertFalse(fl)

    def test_drop_of_a_move(self):
        t0, fl = D.initial_difference('    ecx = 0x5u;  /* 0x1: mov */', '    ;  /* 0x1: mov */')
        self.assertEqual(t0['ecx'] & 0x5, 0x5)

    def test_flag_statement(self):
        t0, fl = D.initial_difference('    { uint32_t a_ = ecx, b_ = 0x5u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x1: cmp */', '    ;  /* 0x1: cmp */')
        self.assertTrue(fl)
        self.assertFalse(any(t0.values()))


if __name__ == '__main__':
    unittest.main()
