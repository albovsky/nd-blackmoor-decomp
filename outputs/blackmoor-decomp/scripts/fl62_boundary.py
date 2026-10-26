#!/usr/bin/env python3
"""FL-62: scripts/fl61_boundary.py on the upper rows (tests/fl41_world.py, tests/fl41_corpus.json).

  fl62_boundary.py ROW [ROW ...] --out FILE [--cap 3000] [--seed 1]          (run from outputs/blackmoor-decomp)

FILE (JSON) maps each row to [[seed, [[address, size, value], ...]], ...]: scenarios of the corpus with ONE input cell set to a boundary value. The original must run them without a fault; nothing is checked
against the translation here (tests/fl41_mutation_check.py --scen guards every scenario).
"""
import argparse
import json
from pathlib import Path
import random
import sys
import time

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl61_boundary as B
import fl41_world as W41
import lift_fl41 as L41

B.W, B.L = W41, L41
STUB_VALUES = (0, 1, 2, 0xffffffff, 0x80000000, 0x7fffffff, 0x10000, 0x100, 0x10001, 0xffff, 0xff)


def candidates(key, corpus, rng, cap):
    """FL-61's candidates (one input cell at an edge value or at a constant of the row +-1) plus, for FL-62: a constant of the row with a high bit pattern above its low 8 or 16 bits (so that a
    narrower read of the cell, `cmp dword [x], 2` as `cmp word [x], 2`, differs), and the eax, ecx, edx that the k-th callee stub returns set to an edge value (STUB_OVR, honoured on both sides)"""
    va = int(key, 16)
    spans = L41.ledger_spans()
    text, callees, imports, fs, inline = L41.lift(va, spans[va])
    row = W41.row_info(va, spans[va], callees, imports, fs)
    seeds = [(s[0], s[1]) for s in corpus[key]['seeds']]
    magic = [m & 0xffffffff for m in row['magic']]
    out = []
    for seed, ov in seeds:
        for (a, n), v in B.input_cells(row, seed, ov):
            mask = (1 << (8 * n)) - 1
            values = set(B.EDGES[n])
            values |= {(m + d) & mask for m in magic for d in (-1, 0, 1)}
            values |= {(v + 1) & mask, (v - 1) & mask, (~v) & mask, v ^ 0x80, v ^ 0x8000}
            if n == 4:
                values |= {(m | 0x10000) & mask for m in magic} | {(m | 0x100) & mask for m in magic} | {(m | 0x80000000) & mask for m in magic} | {(m ^ 0xffff0000) & mask for m in magic}
            values.discard(v)
            for new in sorted(values):
                out.append((seed, [list(o) for o in ov] + [[a, n, new]]))
        tr = W41.run_original(row, seed, [tuple(o) for o in ov])
        if tr.fault:
            continue
        for k in range(min(len(tr.calls), 6)):
            for reg in range(3):
                for val in STUB_VALUES + tuple(m for m in magic[:6]):
                    out.append((seed, [list(o) for o in ov] + [[W41.STUB_OVR + 16 * k + 4 * reg, 4, val]]))
    rng.shuffle(out)
    seen, picked = set(), []
    for seed, ov in out:
        k = (seed, tuple(map(tuple, ov)))
        if k in seen:
            continue
        seen.add(k)
        picked.append((seed, ov))
        if len(picked) >= cap:
            break
    return row, picked


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--out', required=True)
    ap.add_argument('--cap', type=int, default=3000)
    ap.add_argument('--seed', type=int, default=1)
    a = ap.parse_args()
    corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
    out = json.loads(Path(a.out).read_text()) if Path(a.out).exists() else {}
    rng = random.Random(a.seed)
    for key in a.rows:
        t0 = time.time()
        row, picked = candidates(key, corpus, rng, a.cap * 2)
        good = []
        for seed, ov in picked:
            tr = W41.run_original(row, seed, [tuple(o) for o in ov])
            if not tr.fault:
                good.append([seed, ov])
                if len(good) >= a.cap:
                    break
        out[key] = good
        print('%s candidates %d valid %d  %.0fs' % (key, len(picked), len(good), time.time() - t0), flush=True)
        Path(a.out).write_text(json.dumps(out))


if __name__ == '__main__':
    main()
