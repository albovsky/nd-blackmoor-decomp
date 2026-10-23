#!/usr/bin/env python3
"""FL-45 soundness test of scripts/fl45_ranges.py: run the ORIGINAL bytes of every translated row under Unicorn on corpus seeds and check, before every executed instruction,
that each register and frame slot the analysis tracks lies inside its interval (32-bit signed value and low 16 bits signed). Rows the analysis does not cover (NoProof) are skipped.

  python3 tests/test_fl45_ranges.py [--rows 0x4f6810,...] [--seeds 6]          (run from outputs/blackmoor-decomp; also a unittest)
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
import fl41_world as W
import fl43_equiv as E
import fl45_ranges as R
from unicorn import x86_const as UX

REG_IDS = {n: getattr(UX, 'UC_X86_REG_' + n.upper()) for n in R.REGS}


def check_row(key, entry, seeds):
    va = int(key, 16)
    try:
        rg = R.Ranges(va, entry['body'])
    except E.NoProof:
        return None
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    bad, checked = [], [0]

    def make(addr):
        st = rg.IN.get(addr)

        def probe(uc, ensure, wc):
            if st is None:
                bad.append((hex(addr), 'executed but the analysis calls it unreachable'))
                return
            for name, v in st.regs.items():
                x = uc.reg_read(REG_IDS[name])
                if not (v[0] <= R.s32(x) <= v[1] and v[2] <= R.s16(x) <= v[3]):
                    bad.append((hex(addr), name, hex(x), v))
            ebp = uc.reg_read(REG_IDS['ebp'])
            for k, v in st.slots.items():
                x = int.from_bytes(bytes(uc.mem_read((ebp + k) & 0xffffffff, 4)), 'little')
                if not (v[0] <= R.s32(x) <= v[1] and v[2] <= R.s16(x) <= v[3]):
                    bad.append((hex(addr), 'slot %d' % k, hex(x), v))
            checked[0] += len(st.regs) + len(st.slots)
        return probe

    for sd, ov in seeds:
        tr = W.run_original(row, sd, [tuple(o) for o in ov], probes={a: make(a) for a in rg.f.order})
        for edge in tr.edges:                                     # an executed edge between two instructions of the function must be one the analysis keeps
            if edge[0] in rg.at and edge[1] in rg.at and edge[1] in rg.f.succ[edge[0]] + [edge[0]] and edge not in rg.feasible:
                bad.append((hex(edge[0]), 'edge executed but pruned', hex(edge[1])))
    return bad, checked[0]


class Soundness(unittest.TestCase):
    def test_rows(self):
        corpus = json.loads((HERE / 'fl41_corpus.json').read_text())
        n = 0
        for key in sorted(corpus, key=lambda k: int(k, 16)):
            res = check_row(key, corpus[key], corpus[key]['seeds'][:6])
            if res is None:
                continue
            n += 1
            self.assertEqual(res[0], [], key)
        self.assertGreater(n, 0)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--rows')
    ap.add_argument('--seeds', type=int, default=6)
    a = ap.parse_args()
    corpus = json.loads((HERE / 'fl41_corpus.json').read_text())
    tot = rows = skipped = 0
    for key in sorted(corpus, key=lambda k: int(k, 16)):
        if a.rows and key not in a.rows.split(','):
            continue
        res = check_row(key, corpus[key], corpus[key]['seeds'][:a.seeds])
        if res is None:
            skipped += 1
            continue
        rows += 1
        tot += res[1]
        if res[0]:
            print(key, 'UNSOUND', res[0][:3])
    print('rows checked %d, skipped %d, facts checked %d' % (rows, skipped, tot))
