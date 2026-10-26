#!/usr/bin/env python3
"""FL-61: boundary scenarios for the survivors of a mutation check.

A mutant of the translation (tests/fl40_mutation_check.py) survives when no scenario of the corpus makes its change visible: a compare against a constant needs the value one below, equal to
and one above it, a narrower read needs a value whose upper bytes are not zero, an add turned into a subtract needs a second operand that is not zero, and so on. This script takes every scenario
of a corpus row, finds the memory cells the original reads before it writes them (the inputs of the run), and writes new scenarios that set ONE of those cells to a boundary value of its width
(zero, one, the sign and carry edges, the constants of the row and their neighbours, the value of the cell +-1) on top of the parent. Scenarios that fault in the original are dropped. Nothing is
checked against the translation here: tests/fl40_mutation_check.py --scen guards every scenario (a kill counts only where the unmutated translation equals the original).

  fl61_boundary.py ROW [ROW ...] --out FILE [--cap 3000] [--seed 1]          (run from outputs/blackmoor-decomp)

FILE (JSON) maps each row to [[seed, [[address, size, value], ...]], ...].
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
import fl40_world as W
import lift_function as L

EDGES = {1: (0, 1, 0x7f, 0x80, 0xff), 2: (0, 1, 0x7f, 0x80, 0xff, 0x100, 0x7fff, 0x8000, 0xffff, 0xff00),
         4: (0, 1, 2, 0xff, 0x100, 0x7fff, 0x8000, 0xffff, 0x10000, 0x10001, 0x7fffffff, 0x80000000, 0xffffffff, 0xffff0000, 0xffff8000, 0x00018000, 0x0001ffff, 0xfffffffe)}


DECO = (0x100, 0x8000, 0x10000, 0x1000000, 0xff00, 0x80000000, 0x10001)
REG_EDGES = (0, 1, 2, 0x100, 0x10001, 0x8000, 0xffff, 0x10000, 0x80000000, 0xffffffff)


def input_cells(row, seed, overrides):
    tr = W.run_original(row, seed, [tuple(o) for o in overrides], observe=True)
    if tr.fault:
        return []
    first_write = {}
    for k, (a, n, v) in enumerate(tr.writes):
        for b in range(a, a + n):
            first_write.setdefault(b, k)
    cells = {}
    for a, n, v, wc in tr.reads:
        if W.IMAGE_BASE <= a < W.DATA_START or a >= 0xfff00000 or n not in (1, 2, 4):
            continue
        if any(first_write.get(b, 1 << 30) < wc for b in range(a, a + n)):
            continue
        cells.setdefault((a, n), v)
    return sorted(cells.items())


def candidates(key, corpus, rng, cap, stub_parents=0, regs=False):
    va = int(key, 16)
    spans = L.ledger_spans()
    text, callees, imports, fs, inline = L.lift(va, spans[va])
    row = W.row_info(va, spans[va], callees, imports, fs)
    seeds = [(s[0], s[1]) for s in corpus[key]['seeds']]
    seeds += [(W.STUB_SEEDS + k, []) for k in range(stub_parents)]          # parents whose callee stubs also return boundary values
    magic = [m & 0xffffffff for m in row['magic']]
    out = []
    for seed, ov in seeds:
        for (a, n), v in input_cells(row, seed, ov):
            mask = (1 << (8 * n)) - 1
            values = set(EDGES[n])
            values |= {(m + d) & mask for m in magic for d in (-1, 0, 1)}
            values |= {(v + 1) & mask, (v - 1) & mask, (~v) & mask, v ^ 0x80, v ^ 0x8000}
            # a value that matches a constant of the row in its low byte or half but not above it: a narrower read compares equal where the full-width read does not
            values |= {(m | d) & mask for m in magic for d in DECO} | {(v | d) & mask for d in DECO}
            values.discard(v)
            for new in sorted(values):
                out.append((seed, [list(o) for o in ov] + [[a, n, new]]))
    if regs:
        for seed, ov in seeds:
            for k in range(7):
                for new in REG_EDGES + tuple(m for m in magic[:16]):
                    out.append((seed, [list(o) for o in ov] + [[W.REG_OVERRIDE + 4 * k, 4, new & 0xffffffff]]))
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
    ap.add_argument('--regs', action='store_true', help='also set one start register to a boundary value')
    ap.add_argument('--stub-parents', type=int, default=0, help='also use this many seeds from STUB_SEEDS on as parents (callee return values and outputs get the boundary styles)')
    a = ap.parse_args()
    corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
    out = json.loads(Path(a.out).read_text()) if Path(a.out).exists() else {}
    rng = random.Random(a.seed)
    for key in a.rows:
        t0 = time.time()
        row, picked = candidates(key, corpus, rng, a.cap * 2, a.stub_parents, a.regs)
        good = []
        for seed, ov in picked:
            tr = W.run_original(row, seed, [tuple(o) for o in ov])
            if not tr.fault:
                good.append([seed, ov])
                if len(good) >= a.cap:
                    break
        out[key] = good
        print('%s candidates %d valid %d  %.0fs' % (key, len(picked), len(good), time.time() - t0), flush=True)
        Path(a.out).write_text(json.dumps(out))


if __name__ == '__main__':
    main()
