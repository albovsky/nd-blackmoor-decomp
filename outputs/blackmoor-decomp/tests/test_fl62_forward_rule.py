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


CMP = '{ uint32_t a_ = RD32((uint32_t)(%s)), b_ = 0x%xu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }'


def known(first_jump, second_jump_orig, second_jump_mut, c0=0, c1=1, between=(), slot_b='ecx'):
    lines = ['eax = RD32((uint32_t)(ebp + 0xffffffdcu));', CMP % ('eax + 0x991u', c0), first_jump,
             '%s = RD32((uint32_t)(ebp + 0xffffffdcu));' % slot_b] + list(between) + [CMP % (slot_b + ' + 0x991u', c1), second_jump_orig]
    return S.known_compare_ok(lines, len(lines) - 1, S.stmt_full(second_jump_orig), S.stmt_full(second_jump_mut))


class KnownCompare(unittest.TestCase):
    def test_jne_vs_ja_after_a_nonzero_test(self):
        self.assertTrue(known('if (zf) goto L_4de343;', 'if (!zf) goto L_4de345;', 'if ((!cf && !zf)) goto L_4de345;'))

    def test_a_condition_that_differs_on_a_nonzero_value_survives(self):
        self.assertFalse(known('if (zf) goto L_4de343;', 'if (!zf) goto L_4de345;', 'if (zf) goto L_4de345;'))
        self.assertFalse(known('if (zf) goto L_4de343;', 'if (!zf) goto L_4de345;', 'if ((sf != of)) goto L_4de345;'))

    def test_a_store_a_call_or_a_label_in_between_stops_it(self):
        for between in (('WR32((uint32_t)(0x5b44f4u), 0x1u);',), ('FL41_CALL(0x401000u);',), ('L_4de340:',)):
            self.assertFalse(known('if (zf) goto L_4de343;', 'if (!zf) goto L_4de345;', 'if ((!cf && !zf)) goto L_4de345;', between=between))

    def test_a_different_slot_is_not_the_same_cell(self):
        lines = ['eax = RD32((uint32_t)(ebp + 0xffffffdcu));', CMP % ('eax + 0x991u', 0), 'if (zf) goto L_4de343;', 'ecx = RD32((uint32_t)(ebp + 0xffffffe0u));', CMP % ('ecx + 0x991u', 1),
                 'if (!zf) goto L_4de345;']
        self.assertFalse(S.known_compare_ok(lines, 5, lines[5], 'if ((!cf && !zf)) goto L_4de345;'))

    def test_the_jump_that_was_not_taken_must_exclude_the_value(self):
        self.assertFalse(known('if (!zf) goto L_4de343;', 'if (!zf) goto L_4de345;', 'if ((!cf && !zf)) goto L_4de345;'))

    def test_every_form_of_write_to_the_base_register_or_ebp_stops_it(self):
        for between in ('{ uint32_t r_ = 0u; ecx = (ecx & 0xffff0000u) | ((r_) & 0xffffu); }', 'ecx += 4u;', '{ uint32_t t_ = ecx; ecx = edx; edx = t_; }', '{ uint32_t a_ = ecx; ecx = ~a_; }',
                        'ebp = esp;', 'ebp = RD32(esp); esp += 4u;', 'ebp -= 8u;'):
            self.assertFalse(known('if (zf) goto L_4de343;', 'if (!zf) goto L_4de345;', 'if ((!cf && !zf)) goto L_4de345;', between=(between,)), between)

    def test_a_condition_with_side_effects_or_unknown_names_is_not_a_jump_statement(self):
        self.assertIsNone(S.JUMP_STMT.match('if (--ecx) goto L_1;'))
        self.assertIsNone(S.JUMP_STMT.match('if (pf != (ecx = 3)) goto L_1;'))
        lines = ['eax = RD32((uint32_t)(ebp + 0xffffffdcu));', CMP % ('eax + 0x991u', 0), 'if (pf) goto L_1;', 'ecx = RD32((uint32_t)(ebp + 0xffffffdcu));', CMP % ('ecx + 0x991u', 1), 'if (!zf) goto L_2;']
        self.assertFalse(S.known_compare_safe(lines, 5, lines[5], 'if ((!cf && !zf)) goto L_2;'))

    def test_edge_constants(self):
        for c0, c1 in ((0x80000000, 0x80000000), (0xffffffff, 0), (0, 0xffffffff)):
            for mut in ('if (zf) goto L_4de345;', 'if ((cf)) goto L_4de345;', 'if ((sf != of)) goto L_4de345;', 'if ((!cf && !zf)) goto L_4de345;', 'if ((cf || zf)) goto L_4de345;'):
                got = known('if (zf) goto L_4de343;', 'if (!zf) goto L_4de345;', mut, c0=c0, c1=c1)
                bad = [a for a in range(0, 1 << 32, 0x01000001) if a != c0 and S.cond_eval('!zf', **S.sub_flags(a, c1)) != S.cond_eval(mut[4:mut.index(')) goto') + 1] if mut.startswith('if ((') else mut[4:mut.index(') goto')], **S.sub_flags(a, c1))]
                if got:
                    self.assertFalse(bad, (c0, c1, mut))


if __name__ == '__main__':
    unittest.main()
