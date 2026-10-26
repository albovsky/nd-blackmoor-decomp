#!/usr/bin/env python3
"""FL-65 soundness test of the flag facts of scripts/fl65_cells.py (rule `known flags`): run the ORIGINAL bytes of corpus rows (tests/fl41_corpus.json) under Unicorn on corpus seeds; before every
executed instruction the real (CF, ZF, SF, OF) must agree with one of the tuples that the exploration recorded for that instruction (a recorded None matches both values). The rule `unobserved bits`
(scripts/fl65_diff.py) is checked by the corpus sweep (scripts/fl60_rule_sweep.py + scripts/fl60_soundness_all.py) and by tests/test_fl65_diff.py.

  python3 tests/test_fl65_flags.py [--rows 0x4e0559,...] [--seeds 6]          (run from outputs/blackmoor-decomp; also a unittest on a few rows)
"""
import argparse
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
import fl65_cells as K
from unicorn import x86_const as UX

FLAG_BITS = (('cf', 0), ('zf', 6), ('sf', 7), ('of', 11))


def check_row(key, entry, seeds, facts=None):
    import fl41_world as W
    va = int(key, 16)
    if facts is None:
        facts = K.explore(va, entry['body'])
    if facts is None:
        return None
    f = E.Function(va, entry['body'])
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    bad, checked = [], [0]

    def make(addr):
        ins = f.at[addr]
        rep = ins.mnemonic.startswith(('rep', 'movs', 'stos', 'cmps', 'scas', 'lods'))

        def probe(uc, ensure, wc):
            if addr not in facts.flags:
                bad.append((hex(addr), 'executed but never reached by the exploration'))
                return
            if rep:
                return                    # the hook fires once per repetition and the flags move with it
            eflags = uc.reg_read(UX.UC_X86_REG_EFLAGS)
            actual = tuple(bool(eflags >> b & 1) for _, b in FLAG_BITS)
            checked[0] += 1
            if not any(all(r is None or r == a for r, a in zip(rec, actual)) for rec in facts.flags[addr]):
                bad.append((hex(addr), actual, sorted(map(str, facts.flags[addr]))))
        return probe

    for sd, ov in seeds:
        try:
            W.run_original(row, sd, [tuple(o) for o in ov], probes={a: make(a) for a in f.order})
        except Exception as exc:
            bad.append(('run', repr(exc)[:100]))
    return bad, checked[0]


class Soundness(unittest.TestCase):
    def test_rows(self):
        corpus = json.loads((HERE / 'fl41_corpus.json').read_text())
        n = 0
        for key in ('0x4e0559', '0x4fb0bf', '0x495536'):
            if key not in corpus:
                continue
            res = check_row(key, corpus[key], corpus[key]['seeds'][:6])
            if res is None:
                continue
            n += 1
            self.assertEqual(res[0], [], key)
        self.assertGreater(n, 0)


class Cond(unittest.TestCase):
    def test_cond_of(self):
        self.assertEqual(K.cond_of('if ((!zf && sf == of)) goto L_1;  /* 0x1: jg */'), ('(!zf && sf == of)', 'L_1'))
        self.assertIsNone(K.cond_of('if (foo) goto L_1;'))


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--rows')
    ap.add_argument('--seeds', type=int, default=6)
    a = ap.parse_args()
    corpus = json.loads((HERE / 'fl41_corpus.json').read_text())
    tot = rows = skipped = 0
    failures = []
    for key in sorted(corpus, key=lambda k: int(k, 16)):
        if a.rows and key not in a.rows.split(','):
            continue
        try:
            res = check_row(key, corpus[key], corpus[key]['seeds'][:a.seeds])
        except Exception as exc:
            print(key, 'ERROR', repr(exc)[:200])
            continue
        if res is None:
            skipped += 1
            continue
        rows += 1
        tot += res[1]
        if res[0]:
            failures.append(key)
            print(key, 'UNSOUND', res[0][:3], flush=True)
    print('rows checked %d, skipped %d, flag tuples checked %d, rows with a violation %d' % (rows, skipped, tot, len(failures)))
    sys.exit(1 if failures else 0)
