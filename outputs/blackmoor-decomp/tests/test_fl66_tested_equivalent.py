"""FL-66: the tested-equivalent tier (scripts/fl66_tested.py, tasks/fl66-tested-equivalent.json, tests/fl66_scenarios.json).

A tested-equivalent function is PENDING, never ported: its committed translation runs under scenarios that execute every instruction and take both directions of every jump, and agrees with the
original x86 bytes on every one of them. These tests check that the tier stays apart from the verified count, that every row shows full coverage and still names the committed translation,
that the committed scenarios replay (sample, needs Unicorn and the private GAME.EXE), and that a defective translation does NOT replay.
"""
import json
from pathlib import Path
import struct
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl66_tested as T
import original_differential as od

MANIFEST = json.loads(T.MANIFEST.read_text())
SCEN = json.loads(T.SCENARIOS.read_text())
LEDGER = json.loads((PROJECT / 'function-ledger.json').read_text())
ENTRIES = {e['va']: e for e in LEDGER['entries']}


class Tier(unittest.TestCase):
    def test_manifest_scenarios_and_ledger_agree(self):
        rows = MANIFEST['rows']
        self.assertEqual(set(rows), set(SCEN))
        te = LEDGER['tested_equivalent']
        proved = te.get('proved', {}).get('vas', [])             # FL-67: rows cleared by impossibility proofs (tests/test_fl67_infeasible.py) join the same tier
        self.assertEqual(te['vas'], sorted(set(rows) | set(proved), key=lambda k: int(k, 16)))
        self.assertEqual(te['count'], len(rows) + len(proved))
        self.assertFalse(set(rows) & set(proved))

    def test_tier_is_pending_and_never_counted_as_ported(self):
        for k in MANIFEST['rows']:
            self.assertEqual(ENTRIES[k]['status'], 'pending', k)
        ported = sum(1 for e in LEDGER['entries'] if e['status'] == 'ported')
        self.assertEqual(LEDGER['counts']['status']['ported'], ported)
        self.assertFalse({k for k in MANIFEST['rows']} & {e['va'] for e in LEDGER['entries'] if e['status'] == 'ported'})

    def test_every_row_shows_full_coverage_and_a_scenario(self):
        for k, r in MANIFEST['rows'].items():
            self.assertEqual(r['instructions'][0], r['instructions'][1], k)
            self.assertEqual(r['directions'][0], r['directions'][1], k)
            self.assertGreaterEqual(r['scenarios_run'], r['scenarios_kept'], k)
            self.assertEqual(len(SCEN[k]), r['scenarios_kept'], k)
            self.assertGreaterEqual(len(SCEN[k]), 1, k)

    def test_every_row_names_the_committed_translation(self):
        texts = {}
        for k, r in MANIFEST['rows'].items():
            text = texts.setdefault(r['source'], (PROJECT / r['source']).read_text())
            self.assertEqual(T.translation_sha_of(text, k), r['translation_sha256'], k)

    def test_the_pools_do_not_overlap_the_verified_rows(self):
        for k in MANIFEST['rows']:
            self.assertNotEqual(ENTRIES[k]['class'], 'native_oracle_verified')

    def test_status_line(self):
        v, t, o, p, tr = T.counts()
        self.assertEqual(v, LEDGER['counts']['status']['ported'])
        self.assertEqual(t, LEDGER['tested_equivalent']['count'])
        self.assertEqual(o + t, tr)


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Replay(unittest.TestCase):
    def test_sample_of_rows_replays_with_the_recorded_coverage(self):
        keys = sorted(MANIFEST['rows'], key=lambda k: int(k, 16))
        sample = keys[::max(1, len(keys) // 24)]
        for k in sample:
            r = T.check_row(k, scenarios=[T.norm(s) for s in SCEN[k]])
            self.assertEqual(r['status'], 'tested_equivalent', k)
            self.assertEqual(r['instructions'], MANIFEST['rows'][k]['instructions'], k)
            self.assertEqual(r['directions'], MANIFEST['rows'][k]['directions'], k)

    def test_a_defective_translation_is_caught(self):
        """Change one instruction of a translated row (a push that moves esp by 8 instead of 4): the scenarios that cover it must disagree with the original."""
        for k in sorted(MANIFEST['rows'], key=lambda k: int(k, 16)):
            r = MANIFEST['rows'][k]
            if r['pool'] != 'held':
                continue
            text = T.row_text(r['source'], k)
            if 'esp -= 4u; WR32(esp, ebp);' not in text:
                continue
            bad = text.replace('esp -= 4u; WR32(esp, ebp);', 'esp -= 8u; WR32(esp, ebp);', 1)
            with tempfile.TemporaryDirectory() as tmp:
                src = Path(tmp) / 'bad.c'
                src.write_text('#include "original_methods_fl40.h"\n' + bad)
                W, _ = T.world(40)
                lib = W.build_library(tmp, [src])
                res = T.check_row(k, scenarios=[T.norm(s) for s in SCEN[k]], lib=lib)
            self.assertEqual(res['status'], 'mismatch', k)
            return
        self.fail('no held row with a frame push found')

    def test_a_jump_out_of_the_body_is_an_edge_and_both_sides_must_take_the_same_one(self):
        """FL-78: `jne 0x51aaf7` of 0x51aa23 leaves the body for a callee the world plays as a stub (a tail call). The original side records the edge; the translation must make the same tail call, else the call records differ."""
        key = '0x51aa23'
        pool = T.pool_of(key)
        p = T.POOLS[pool]
        W, _ = T.world(p['world'])
        row = T.row_info(pool, key)
        taken = W.run_original(row, 1, [])
        self.assertIn((0x51aabc, 0x51aaf7), taken.edges)                       # esi != 0x110: the jump is taken
        self.assertNotIn((0x51aabc, 0x51aaf7), W.run_original(row, 1, [(2004318087, 4, 272)]).edges)       # esi == 0x110: the call and the `jmp` at the end, no edge from the jne
        text = T.row_text(p['source'], key)

        def lib_of(t):
            with tempfile.TemporaryDirectory() as tmp:
                src = Path(tmp) / 'row.c'
                src.write_text('#include "original_methods_fl41.h"\n' + t)
                return W.build_library(tmp, [src])
        res = T.check_row(key, scenarios=[(1, [])], lib=lib_of(text))
        self.assertNotEqual(res['status'], 'mismatch')
        self.assertNotIn(['0x51aabc', 'taken'], res['untaken'])                 # the direction is covered now
        jump = '{ FL41_CALL(0x51aaf7u); esp = esp0_ + 24u; goto done; }  /* 0x51aabc'
        self.assertIn(jump, text)
        bad = text.replace(jump, jump.replace('0x51aaf7u', '0x51a8d3u'))          # the translation jumps to another callee
        self.assertEqual(T.check_row(key, scenarios=[(1, [])], lib=lib_of(bad))['status'], 'mismatch')

    def test_a_call_to_the_next_instruction_only_pushes_the_address(self):
        """FL-78: `call 0x510f8c` at 0x510f87 (an SEH epilog idiom, the target is the next instruction) is a push of 0x510f8c, not a call to a stub: as a stub it plays the `jmp` at 0x510f8c twice and the run
        returns into garbage (the original faulted on every scenario of 0x510eda and 0x510f3b). The lifter lists no callee there, the committed table agrees, the rows run, and the old table (with the stub) faults."""
        import lift_fl41 as L
        for key, nxt, size in (('0x510f3b', 0x510f8c, 86), ('0x510eda', 0x510f36, 97)):
            pool = T.pool_of(key)
            table = T.pool_table(pool)[key]
            self.assertEqual(table['body'], size, key)
            was = L.BULK
            L.BULK = True
            try:
                text, callees, _, _, _ = L.lift(int(key, 16), table['body'])
            finally:
                L.BULK = was
            self.assertNotIn(nxt, callees, key)
            self.assertNotIn('FL41_CALL(0x%xu)' % nxt, text, key)
            self.assertIn('esp -= 4u; WR32(esp, 0x%xu);' % nxt, text, key)
            self.assertNotIn(hex(nxt), table['callees'], key)
            W, _ = T.world(T.POOLS[pool]['world'])
            row = T.row_info(pool, key)
            self.assertIsNone(W.run_original(row, 0, []).fault, key)
            old = dict(table, callees=dict(table['callees'], **{hex(nxt): 0}))
            was_table = T.pool_table
            T.pool_table = lambda name, old=old, key=key, was_table=was_table: dict(was_table(name), **{key: old})
            try:
                self.assertIsNotNone(W.run_original(T.row_info(pool, key), 0, []).fault, key)
            finally:
                T.pool_table = was_table


    def test_a_jump_to_the_instruction_after_it_lands_in_the_function(self):
        """FL-78 (round 10): `jmp eax` at 0x50c660 (0x50c82b: `jmp [ebx+0x18]` at 0x50c895) jumps to the address of the next instruction when the caller passes that address (an unwinder's resume jump): the original runs the code there
        (tests/fl41_world.py site_hook), the translation has a label and compares the target (lift_fl41.indirect_tail_jump); a translation that plays the target as a stub differs."""
        P_, NEWSP, A, STOP = 0x20000100, 0x20000400, 0x20000800, 0x7ff00000
        cases = (('0x50c635', 0x50c662, [(1, [(0x100fee0, 4, 0x50c662), (0x100fee4, 4, P_), (P_ - 4, 4, NEWSP), (P_ + 0x10, 4, STOP)])]),
                 ('0x50c82b', 0x50c898, [(1, [(0x100fee0, 4, A), (A + 4, 4, 0), (0x100fee4, 4, P_), (P_ + 0x24, 4, 1), (P_ + 0x18, 4, 0x50c898), (P_ + 0x1c, 4, NEWSP), (P_ + 0x20, 4, 0x20000900), (NEWSP + 16, 4, STOP)])]))
        for key, nxt, scen in cases:
            pool = T.pool_of(key)
            p = T.POOLS[pool]
            W, _ = T.world(p['world'])
            row = T.row_info(pool, key)
            self.assertIn(nxt, W.run_original(row, scen[0][0], scen[0][1]).executed, key)           # the original runs the code at the target
            text = T.row_text(p['source'], key)
            dispatch = 'if (t_ == 0x%xu) goto L_%x;' % (nxt, nxt)
            self.assertIn(dispatch, text, key)
            self.assertIn('L_%x:' % nxt, text, key)

            def lib_of(t):
                with tempfile.TemporaryDirectory() as tmp:
                    src = Path(tmp) / 'row.c'
                    src.write_text('#include "original_methods_fl41.h"\n' + t)
                    return W.build_library(tmp, [src])
            res = T.check_row(key, scenarios=scen, lib=lib_of(text))
            self.assertNotEqual(res['status'], 'mismatch', key)
            self.assertNotIn(hex(nxt), res.get('missing', []), key)                                       # the landing is covered
            self.assertEqual(T.check_row(key, scenarios=scen, lib=lib_of(text.replace(dispatch + ' ', '')))['status'], 'mismatch', key)


    def test_the_block_copy_translation_follows_the_direction_flag_and_its_tables(self):
        """FL-78 (round 11): 0x50fa90 (the CRT memcpy: `std; rep movsd; cld` for a copy that overlaps with the destination above the source, and jump tables inside .text that the lifter reads from asm_data/data-005.json):
        the translation keeps the direction flag in df_ and steps backwards while it is set; a translation that ignores `std` (or whose table switch lacks a case) differs from the original on the overlapping copies."""
        key = '0x50fa90'
        pool = T.pool_of(key)
        p = T.POOLS[pool]
        W, _ = T.world(p['world'])
        B, A = 0x20001000, 0x100fee0
        scen = [(1, [(A, 4, B + 0x104 + da), (A + 4, 4, B + 0x100 + da), (A + 8, 4, n)]) for n in (8, 40, 64, 100) for da in range(4)] + \
               [(1, [(A, 4, B + 0x400), (A + 4, 4, B + 0x100 + sa), (A + 8, 4, n)]) for n in (0, 1, 2, 3, 5, 9, 33) for sa in range(4)]
        text = T.row_text(p['source'], key)
        self.assertIn('df_ = 1u;', text)
        self.assertIn('(df_ ? 4294967292u : 4u)', text)

        def lib_of(t):
            with tempfile.TemporaryDirectory() as tmp:
                src = Path(tmp) / 'row.c'
                src.write_text('#include "original_methods_fl41.h"\n' + t)
                return W.build_library(tmp, [src])
        res = T.check_row(key, scenarios=scen, lib=lib_of(text))
        self.assertNotEqual(res['status'], 'mismatch')
        bad = text.replace('df_ = 1u;', 'df_ = 0u;')                                             # `std` has no effect
        self.assertEqual(T.check_row(key, scenarios=scen, lib=lib_of(bad))['status'], 'mismatch')
        cases = [l for l in text.splitlines() if 'case 0x50fbf0u' in l]
        self.assertTrue(cases)                                                                    # a table case of the 0x50fbd8 range
        bad = text.replace(cases[0], '')
        self.assertEqual(T.check_row(key, scenarios=scen, lib=lib_of(bad))['status'], 'mismatch')


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class StartStateOverrides(unittest.TestCase):
    """FL-78 (round 10): a scenario can set the entry EFLAGS, the entry FPCW, the entry x87 stack and the st(0) a stubbed callee returns (tests/fl41_world.py EFLAGS_OVERRIDE, FCW_OVERRIDE, ST_OVERRIDE, FPRET_OVERRIDE)."""
    KEY = '0x50df9d'

    @classmethod
    def setUpClass(cls):
        cls.pool = T.pool_of(cls.KEY)
        cls.W, _ = T.world(T.POOLS[cls.pool]['world'])
        cls.row = T.row_info(cls.pool, cls.KEY)
        cls.lib = T.library(cls.pool)

    def both(self, scen, row=None, lib=None):
        W = self.W
        o = W.run_original(row or self.row, 1, scen)
        n = W.run_native(lib or self.lib, row or self.row, 1, scen)
        self.assertIsNone(o.fault)
        self.assertIsNone(n.fault)
        self.assertEqual(o.digest(), n.digest())
        return o, n

    def test_the_entry_flags_open_the_taken_direction_of_the_je_after_fnstcw(self):
        W = self.W
        base, _ = self.both([])
        zf, _ = self.both([(W.EFLAGS_OVERRIDE, 4, 0x40)])
        self.assertNotIn(0x50dff9, base.executed)
        self.assertIn(0x50dff9, zf.executed)
        self.assertIn((0x50dfa6, 0x50dff9), zf.edges)
        self.assertNotIn((0x50dfa6, 0x50dff9), base.edges)
        r = T.check_row(self.KEY, scenarios=[(1, []), (1, [(W.EFLAGS_OVERRIDE, 4, 0x40)])])
        self.assertNotEqual(r['status'], 'mismatch')
        self.assertNotIn(['0x50dfa6', 'taken'], r['untaken'])
        self.assertIn(['0x50dfa6', 'taken'], T.check_row(self.KEY, scenarios=[(1, [])])['untaken'])
        # a native side that does not get the flags disagrees: the override is seen by both sides, not just by the original
        n_without = W.run_native(self.lib, self.row, 1, [])
        self.assertNotEqual(n_without.digest(), zf.digest())

    def test_the_entry_flags_other_than_the_status_bits_are_ignored(self):
        W = self.W
        a, _ = self.both([(W.EFLAGS_OVERRIDE, 4, 0x40)])
        b, _ = self.both([(W.EFLAGS_OVERRIDE, 4, 0x40 | 0x200 | 0x400 | 0x10000)])            # IF, DF, RF are not start state
        self.assertEqual(a.digest(), b.digest())

    def test_the_entry_fpcw_opens_the_fall_through_of_the_compare_with_0x27f(self):
        W = self.W
        base, _ = self.both([])
        cw, _ = self.both([(W.FCW_OVERRIDE, 4, 0x37f)])
        self.assertNotIn(0x50dfb0, base.executed)
        self.assertIn(0x50dfb0, cw.executed)
        self.assertEqual(cw.regs['fpu'][1], 0x37f)                                                  # the control word the row finishes with is the one it started with
        r = T.check_row(self.KEY, scenarios=[(1, []), (1, [(W.FCW_OVERRIDE, 4, 0x37f)])])
        self.assertNotIn(['0x50dfae', 'fall-through'], r['untaken'])
        self.assertIn(['0x50dfae', 'fall-through'], T.check_row(self.KEY, scenarios=[(1, [])])['untaken'])
        self.assertNotEqual(W.run_native(self.lib, self.row, 1, []).digest(), cw.digest())

    def test_the_entry_x87_stack_is_set_and_both_sides_hold_the_same_values(self):
        W = self.W
        bits = lambda d: struct.unpack('<Q', struct.pack('<d', d))[0]
        base, _ = self.both([])
        self.assertEqual(base.regs['fpu'][2], ())                                                   # empty stack by default
        o, n = self.both([(W.ST_OVERRIDE, 8, bits(4.0))])
        self.assertEqual(len(o.regs['fpu'][2]), 1)                                                  # the pushed st(0) is still there at the end
        self.assertEqual(o.regs['fpu'][2], n.regs['fpu'][2])
        self.assertNotEqual(o.digest(), base.digest())
        o2, n2 = self.both([(W.ST_OVERRIDE, 8, bits(4.0)), (W.ST_OVERRIDE + 16, 8, bits(-3.5))])
        self.assertEqual(len(o2.regs['fpu'][2]), 2)
        self.assertNotEqual(o2.regs['fpu'][2], o.regs['fpu'][2])
        with self.assertRaises(ValueError):                                                         # st(1) without st(0)
            W.run_original(self.row, 1, [(W.ST_OVERRIDE + 16, 8, bits(1.0))])

    def test_a_stubbed_callee_can_return_a_chosen_st0(self):
        key = '0x4f9d18'                                                                            # calls 0x50df94 (an x87 wrapper the world stubs)
        pool = T.pool_of(key)
        W2, _ = T.world(T.POOLS[pool]['world'])
        row = T.row_info(pool, key)
        lib = T.library(pool)
        i = sorted(row['callees']).index(0x50df94)
        bits = lambda d: struct.unpack('<Q', struct.pack('<d', d))[0]
        recorded = {}
        for v in (25.0, 0.0):
            o, n = self.both([(W2.FPRET_OVERRIDE + 16 * i, 8, bits(v))], row=row, lib=lib)
            calls = [c for c in o.calls if c[0] == 0x50df94]
            self.assertTrue(calls)
            recorded[v] = calls[0][-1]
        self.assertNotEqual(recorded[25.0], recorded[0.0])                                          # the value shows in the call record
        self.assertNotEqual(self.W.run_original(row, 1, [(W2.FPRET_OVERRIDE + 16 * i, 8, bits(25.0))]).digest(), self.W.run_original(row, 1, [(W2.FPRET_OVERRIDE + 16 * i, 8, bits(0.0))]).digest())
        with self.assertRaises(ValueError):                                                         # the row has fewer callees than that
            W2.run_original(row, 1, [(W2.FPRET_OVERRIDE + 16 * len(row['callees']), 8, bits(1.0))])


if __name__ == '__main__':
    unittest.main()
