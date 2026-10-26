#!/usr/bin/env python3
"""FL-63: scripts/fl43_equiv.py ends the facts about memory at a string instruction, not at `movsx` (which only starts with `movs`)."""
from pathlib import Path
import sys
import unittest

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl43_equiv as E


class StringOps(unittest.TestCase):
    def test_real_string_instructions(self):
        for m in ('movsb', 'movsw', 'movsd', 'stosb', 'stosd', 'cmpsb', 'cmpsw', 'scasb', 'scasd', 'lodsb', 'lodsd', 'rep movsd', 'rep stosb', 'repne scasb', 'repe cmpsb'):
            self.assertTrue(E.is_string_op(m), m)

    def test_register_moves_are_not(self):
        for m in ('movsx', 'movzx', 'mov', 'lea', 'cmp', 'call', 'stc'):
            self.assertFalse(E.is_string_op(m), m)

    def test_movsx_keeps_the_reload_fact(self):
        # 0x4dd28d: `mov edx, [ecx + 0xee]` (0x4dd2ca), `movsx eax, word [edx + 0x1c2]` (0x4dd2d0), `mov ecx, [ebp - 4]` (0x4dd2d7), `mov edx, [ecx + 0xee]` (0x4dd2da): the last one repeats the first
        proofs = E.prove(0x4dd28d, 236, [0x4dd2da, 0x4dd344])
        self.assertTrue(proofs[0x4dd2da] and proofs[0x4dd2da].startswith('repeat'))
        self.assertTrue(proofs[0x4dd344] and proofs[0x4dd344].startswith('repeat'))


if __name__ == '__main__':
    unittest.main()
