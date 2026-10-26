"""FL-62: the survivor rule `forwarded store` (scripts/fl41_survivors.py global_forward_ok): a narrower read of a global that the same straight line stored a small constant to.
Needs capstone, no private files."""
from pathlib import Path
import sys
import unittest

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_survivors as S

STORE = 'WR32((uint32_t)(0x5b44f0u), 0x9u);  /* 0x4a1ea5: mov dword ptr [0x5b44f0], 9 */'
READ = 'edx = RD32((uint32_t)(0x5b44f0u));  /* 0x4a1ec5: mov edx, dword ptr [0x5b44f0] */'
READ16 = READ.replace('RD32', 'RD16')


def verdict(lines, to=16):
    change = S.read_change(S.stmt_full(lines[-1]), S.stmt_full(lines[-1].replace('RD32', 'RD%d' % to)))
    return S.global_forward_ok(lines, len(lines) - 1, change)


class ForwardedStore(unittest.TestCase):
    def test_small_constant_read_back_narrower(self):
        self.assertTrue(verdict([STORE, 'WR32((uint32_t)(0x5b44f4u), 0x1u);', READ]))
        self.assertTrue(verdict([STORE, 'if (!zf) goto L_4a1ef7;', READ], 8))

    def test_constant_too_wide_for_the_narrower_read(self):
        self.assertFalse(verdict([STORE.replace('0x9u', '0x10000u'), READ]))
        self.assertFalse(verdict([STORE.replace('0x9u', '0x100u'), READ], 8))

    def test_an_overlapping_store_a_call_a_label_or_a_register_store_stop_the_scan(self):
        self.assertFalse(verdict([STORE, 'WR32((uint32_t)(0x5b44f2u), ecx);', READ]))
        self.assertFalse(verdict([STORE, 'FL41_CALL(0x401000u);', READ]))
        self.assertFalse(verdict([STORE, 'L_4a1eb0:', READ]))
        self.assertFalse(verdict([STORE, 'WR32((uint32_t)(eax + 0x4u), ecx);', READ]))
        self.assertTrue(verdict([STORE, '{ uint32_t a_ = eax, n_ = 0x5u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }', READ]))
        self.assertFalse(verdict([STORE, '{ uint32_t a_ = eax; WR32((uint32_t)(0x5b44f2u), a_); }', READ]))

    def test_a_barrier_after_the_store_on_its_line_or_before_the_read_on_its_line(self):
        self.assertFalse(verdict([STORE.replace(';  /*', '; FL41_CALL(0x401000u);  /*', 1), READ]))
        self.assertFalse(verdict([STORE, 'esp -= 4u; WR32(esp, 0x5u); ' + READ]))
        self.assertTrue(verdict([STORE, 'WR32((uint32_t)(0x5b44f2u), 0x5u);', 'WR32((uint32_t)(0x5b44f8u), 1u);', READ]) is False)

    def test_sixteen_to_eight(self):
        store16 = STORE.replace('WR32', 'WR16').replace('0x9u', '0x7fu')
        read16 = READ.replace('RD32', 'RD16')
        change = S.read_change(S.stmt_full(read16), S.stmt_full(read16.replace('RD16', 'RD8')))
        self.assertTrue(S.global_forward_ok([store16, read16], 1, change))

    def test_no_store_at_all_or_another_address(self):
        self.assertFalse(verdict([READ]))
        self.assertFalse(verdict([STORE.replace('0x5b44f0u', '0x5b44f4u'), READ]))

    def test_a_store_of_another_width_does_not_count(self):
        self.assertFalse(verdict([STORE.replace('WR32', 'WR16'), READ]))


if __name__ == '__main__':
    unittest.main()
