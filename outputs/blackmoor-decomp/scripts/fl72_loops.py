#!/usr/bin/env python3
"""FL-72: scenarios for the thread-procedure rows that loop until a flag (the dword behind their first argument) turns non-zero and then end in a call that never returns (AfxEndThread).

Every random scenario of the world spins forever on such a row: the flag stays zero, and only a callee can set it. The world lets the k-th callee stub store one dword (STUB_WR + 16*k: address, + 4: value), so
a scenario is (seed, "the k-th callee stores 1 into the flag"): the loop runs through k calls of random behaviour (the seed decides every branch) and ends at the next test of the flag. Seeds x k give a spread of
paths; the original is the truth, scenarios that do not end are dropped and the kept ones add coverage.

  fl72_loops.py ROW [ROW ...] --out FILE [--seeds N] [--calls N]        (run from outputs/blackmoor-decomp)
"""
import argparse
import json
from pathlib import Path
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl66_tested as T


def build(key, seeds, calls):
    pool = T.pool_of(key)
    W, G = T.world(T.POOLS[pool]['world'])
    row = T.row_info(pool, key)
    W.INSTRUCTION_LIMIT = min(W.INSTRUCTION_LIMIT, 40000)
    ex, ed, kept = set(), set(), []
    # the first calls may also return a chosen value (the loop tests a callee's answer: 0, 1, 2, -1), so each (call, value) pair is a scenario family
    families = [[]] + [[[W.STUB_OVR + 16 * j, 4, v & 0xffffffff]] for j in range(3) for v in (0, 1, 2, -1)]
    done = False
    for seed in range(1, seeds + 1):
        regs, args, patches = W.initial_state(row, seed)
        flag = args[0] & 0xffffffff
        for fam in families:
            for k in range(calls):
                ov = fam + [[W.STUB_WR + 16 * k, 4, flag], [W.STUB_WR + 16 * k + 4, 4, 1]]
                tr = W.run_original(row, seed, [tuple(o) for o in ov])
                if tr.fault:
                    continue
                if not (tr.executed <= ex and tr.edges <= ed):
                    ex |= tr.executed
                    ed |= tr.edges
                    kept.append([seed, ov])
        got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
        if not missing and not untaken:
            break
    print('%s instructions %d/%d directions %d/%d kept %d' % ((key,) + tuple(G.covers(row, ex, ed)[:4]) + (len(kept),)))
    return kept


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--out', required=True)
    ap.add_argument('--seeds', type=int, default=60)
    ap.add_argument('--calls', type=int, default=12)
    a = ap.parse_args()
    out = json.loads(Path(a.out).read_text()) if Path(a.out).exists() else {}
    for key in a.rows:
        out[key] = build(key, a.seeds, a.calls)
        Path(a.out).write_text(json.dumps(out))


if __name__ == '__main__':
    main()
