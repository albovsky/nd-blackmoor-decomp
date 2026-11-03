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


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class CalleeFlags(unittest.TestCase):
    """FL-78 (round 12): a callee can hand its arithmetic flags to a caller that reads them (src/original_methods_fl41.h FL41_CALL_F / FL41_FLAGS_OUT, scripts/lift_fl41.py callee_flags_read and FLAG_RETURNERS, the stub override
    STUB_OVR + 16*k + 12 of tests/fl41_world.py). 0x50f462 calls 0x513c65 and tests the ZF that callee returns (`test eax, 0` on its Inf/NaN path) with `je 0x50f525`."""
    KEY, CALLEE = '0x50f462', '0x513c65'

    @classmethod
    def setUpClass(cls):
        import lift_fl41 as L
        cls.L = L
        cls.pool = T.pool_of(cls.KEY)
        cls.p = T.POOLS[cls.pool]
        cls.W, _ = T.world(cls.p['world'])
        cls.row = T.row_info(cls.pool, cls.KEY)
        cls.text = T.row_text(cls.p['source'], cls.KEY)

    def lib_of(self, t):
        with tempfile.TemporaryDirectory() as tmp:
            src = Path(tmp) / 'row.c'
            src.write_text('#include "original_methods_fl41.h"\n' + t)
            return self.W.build_library(tmp, [src])

    def flag_reads(self, code):
        import capstone
        md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        md.detail = True
        ins = list(md.disasm(bytes.fromhex(code), 0x1000))
        k = next(n for n, i in enumerate(ins) if i.mnemonic == 'call')
        return self.L.callee_flags_read(ins, k)

    def test_the_lifter_finds_a_caller_that_reads_the_flags_of_its_callee(self):
        call = 'e8000000009090'            # call +0 (to the next instruction, then two nops: only the instructions after the call matter)
        self.assertEqual(self.flag_reads('e800000000' + '7402' + '9090'), {'ZF'})                      # call; je
        self.assertEqual(self.flag_reads('e800000000' + '7f02' + '9090'), {'ZF', 'SF', 'OF'})          # call; jg
        self.assertEqual(self.flag_reads('e800000000' + '83c404' + '7402' + '9090'), set())            # call; add esp, 4; je: the flags are the add's
        self.assertEqual(self.flag_reads('e800000000' + '85c0' + '7402' + '9090'), set())              # call; test eax, eax; je
        self.assertEqual(self.flag_reads('e800000000' + '40' + '7202' + '9090'), {'CF'})               # call; inc eax; jb: inc leaves CF alone, so the jb reads the callee's
        self.assertEqual(self.flag_reads('e800000000' + '83d000' + '9090'), {'CF'})                    # call; adc eax, 0
        self.assertEqual(self.flag_reads('e800000000' + 'eb02' + '9090' + '7402' + '9090'), {'ZF'})    # call; jmp over; je (a path through a jump)
        self.assertEqual(self.flag_reads('e800000000' + 'c3'), set())                                  # call; ret

    def test_exactly_one_call_of_the_image_reads_the_flags_of_its_callee(self):
        """the scan of every ledger function: 0x50f48c (0x50f462, `je 0x50f525` after `call 0x513c65`) is the only call site; FLAG_RETURNERS is the set of those callees"""
        from capstone import x86_const as X
        L = self.L
        pe = od.load_image()
        found, callees = [], set()
        for va, size in sorted(L.ledger_spans().items()):
            try:
                ins = L.disasm(va, size)
            except L.Unsupported:
                ins = list(od.disasm_code(L.md(), pe.image[va - pe.image_base:va - pe.image_base + size], va))       # the few spans that stop inside data: the instructions that do decode
            for k, i in enumerate(ins):
                if i.mnemonic == 'call' and i.operands and i.operands[0].type == X.X86_OP_IMM and L.callee_flags_read(ins, k):
                    found.append((i.address, i.operands[0].imm))
                    callees.add(i.operands[0].imm)
        self.assertEqual(found, [(0x50f48c, 0x513c65)])
        self.assertEqual(callees, L.FLAG_RETURNERS)

    def test_the_committed_translations_use_the_flag_forms_exactly_where_the_lifter_does(self):
        self.assertEqual(self.text.count('FL41_CALL_F('), 1)
        self.assertIn('FL41_CALL_F(0x513c65u); esp += 4u;  /* 0x50f48c: call 0x513c65 */', self.text)
        callee_text = T.row_text(self.p['source'], self.CALLEE)
        self.assertEqual(callee_text.count('FL41_FLAGS_OUT'), 1)
        was = self.L.BULK
        self.L.BULK = True
        try:
            for key in (self.KEY, self.CALLEE):
                fresh = self.L.lift(int(key, 16), T.pool_table(self.pool)[key]['body'])[0]
                self.assertEqual(fresh.count('FL41_CALL_F('), 1 if key == self.KEY else 0, key)
                self.assertEqual(fresh.count('FL41_FLAGS_OUT'), 1 if key == self.CALLEE else 0, key)
        finally:
            self.L.BULK = was

    def scen(self, flags, callee_index=0, fcw=0x27f, eax=0x3ff00000):
        W = self.W
        ov = [(W.FCW_OVERRIDE, 4, fcw), (W.STUB_OVR + 16 * callee_index, 4, eax)]
        if flags is not None:
            ov.append((W.STUB_OVR + 16 * callee_index + 12, 4, flags))
        return [(1, ov)]

    def test_a_zero_flag_returned_by_the_callee_takes_the_je_after_the_call(self):
        W = self.W
        (seed, ov), = self.scen(0x40)
        o = W.run_original(self.row, seed, ov)
        self.assertIsNone(o.fault)
        self.assertIn((0x50f491, 0x50f525), o.edges)                           # the je is taken ...
        none = W.run_original(self.row, seed, self.scen(None)[0][1])
        self.assertNotIn((0x50f491, 0x50f525), none.edges)                     # ... only because the callee said so
        self.assertIn((0x50f491, 0x50f497), none.edges)
        res = T.check_row(self.KEY, scenarios=self.scen(0x40) + self.scen(0) + self.scen(None))
        self.assertNotEqual(res['status'], 'mismatch')
        self.assertNotIn(['0x50f491', 'taken'], res['untaken'])
        self.assertIn(['0x50f491', 'taken'], T.check_row(self.KEY, scenarios=self.scen(None) + self.scen(0))['untaken'])
        # with the control word changed, the first stub call is 0x513c35 and the 0x513c65 call is the second one
        res = T.check_row(self.KEY, scenarios=self.scen(0x40, 1, 0x37f))
        self.assertNotEqual(res['status'], 'mismatch')
        self.assertNotIn(['0x50f491', 'taken'], res['untaken'])

    def test_a_translation_that_calls_without_the_flag_form_differs_and_the_old_one_agrees_where_nothing_is_returned(self):
        call = 'FL41_CALL_F(0x513c65u);'
        self.assertIn(call, self.text)
        old = self.lib_of(self.text.replace(call, 'FL41_CALL(0x513c65u);'))
        self.assertEqual(T.check_row(self.KEY, scenarios=self.scen(0x40), lib=old)['status'], 'mismatch')          # the defect: the je is not taken
        self.assertEqual(T.check_row(self.KEY, scenarios=self.scen(0x40) + self.scen(None), lib=self.lib_of(self.text))['status'], 'partial')
        # still accepted: without a flags override the stub leaves the flags as the call found them and the two forms agree
        self.assertNotEqual(T.check_row(self.KEY, scenarios=self.scen(None), lib=old)['status'], 'mismatch')
        self.assertNotEqual(T.check_row(self.KEY, scenarios=self.scen(None), lib=self.lib_of(self.text))['status'], 'mismatch')
        # the callee side: a flag value of the override that is not a status bit (IF, DF) is ignored by both sides
        a = self.W.run_original(self.row, 1, self.scen(0x40)[0][1])
        b = self.W.run_original(self.row, 1, self.scen(0x40 | 0x200 | 0x400)[0][1])
        self.assertEqual(a.digest(), b.digest())

    def test_the_callee_hands_its_flags_to_the_cell_and_the_original_leaves_the_same_flags(self):
        """0x513c65 (FL41_FLAGS_OUT): ZF is 0 for a finite operand (its `cmp eax, 0x7ff00000`) and 1 on the Inf/NaN path (`test eax, 0`); the run records the final flags of both sides (trace.regs['flags'])"""
        W = self.W
        pool = T.pool_of(self.CALLEE)
        row = T.row_info(pool, self.CALLEE)
        self.assertTrue(W.flags_out(row))
        text = T.row_text(self.p['source'], self.CALLEE)
        lib = T.library(pool)
        P = 0x20000100
        seen = {}
        for name, hi in (('finite', 0x3ff00000), ('inf', 0x7ff00000), ('nan', 0x7ff80000)):
            scen = [(W.REG_OVERRIDE + 8, 4, P), (P + 4, 4, hi), (P, 4, 0)]
            o, n = W.run_original(row, 1, scen), W.run_native(lib, row, 1, scen)
            self.assertIsNone(o.fault)
            self.assertIsNone(n.fault)
            self.assertEqual(o.digest(), n.digest(), name)
            seen[name] = o.regs['flags']
        self.assertEqual(seen['finite'] & 0x40, 0)
        self.assertEqual(seen['inf'] & 0x40, 0x40)
        self.assertEqual(seen['nan'] & 0x40, 0x40)
        # a translation without FL41_FLAGS_OUT (the cell keeps its empty marker) disagrees with the original on the Inf path; the host without a cell (the game's hosts) is untouched
        lib_without = self.lib_of(text.replace('    FL41_FLAGS_OUT\n', ''))
        scen = [(W.REG_OVERRIDE + 8, 4, P), (P + 4, 4, 0x7ff00000), (P, 4, 0)]
        self.assertNotEqual(W.run_native(lib_without, row, 1, scen).digest(), W.run_original(row, 1, scen).digest())
        # the 0x513c65 row replays with the recorded coverage on its kept scenarios
        res = T.check_row(self.CALLEE, scenarios=[T.norm(s) for s in SCEN[self.CALLEE]])
        self.assertEqual(res['status'], 'tested_equivalent')

    def test_a_host_without_a_cell_gets_the_old_behaviour(self):
        """the game's hosts are brace-initialised and leave callee_flags NULL: FL41_CALL_F then behaves as FL41_CALL (the flags stay) and FL41_FLAGS_OUT does nothing; a C check with such a host"""
        import subprocess
        src = r'''
#include "original_methods_fl41.h"
static void call(void *ctx, uint32_t callee, Fl41Regs *r) { (void)ctx; (void)callee; (void)r; }
static uint32_t rd(void *ctx, uint32_t a, int n) { (void)ctx; (void)a; (void)n; return 0; }
static void wr(void *ctx, uint32_t a, int n, uint32_t v) { (void)ctx; (void)a; (void)n; (void)v; }
static uint64_t fret(void *ctx) { (void)ctx; return 0; }
int main(void)
{
    Fl41Host host = { NULL, rd, wr, call, fret, NULL };
    const Fl41Host *h = &host;
    Fl41Regs rg = {0, 0, 0, 0, 0x1000, 0, 0, 0}, *r = &rg;
    FL41_PROLOGUE
    zf = 1; cf = 0;
    FL41_CALL_F(0x1234u);
    if (!zf || cf) return 2;              /* the flags stayed */
    done:
    FL41_EPILOGUE
    FL41_FLAGS_OUT
    return host.callee_flags == NULL ? 0 : 3;
}
'''
        with tempfile.TemporaryDirectory() as tmp:
            c = Path(tmp) / 'host.c'
            c.write_text(src)
            exe = Path(tmp) / 'host'
            built = subprocess.run(['cc', '-std=c11', '-Wall', '-Werror', '-Wno-unused-label', '-I', str(PROJECT / 'src'), str(c), '-o', str(exe)], capture_output=True, text=True)
            self.assertEqual(built.returncode, 0, built.stderr)
            self.assertEqual(subprocess.run([str(exe)]).returncode, 0)


if __name__ == '__main__':
    unittest.main()
