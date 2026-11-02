"""FL-66: the tested-equivalent tier (scripts/fl66_tested.py, tasks/fl66-tested-equivalent.json, tests/fl66_scenarios.json).

A tested-equivalent function is PENDING, never ported: its committed translation runs under scenarios that execute every instruction and take both directions of every jump, and agrees with the
original x86 bytes on every one of them. These tests check that the tier stays apart from the verified count, that every row shows full coverage and still names the committed translation,
that the committed scenarios replay (sample, needs Unicorn and the private GAME.EXE), and that a defective translation does NOT replay.
"""
import json
from pathlib import Path
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


if __name__ == '__main__':
    unittest.main()
