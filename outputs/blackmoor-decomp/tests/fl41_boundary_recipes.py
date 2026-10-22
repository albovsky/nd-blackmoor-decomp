#!/usr/bin/env python3
"""FL-41: boundary-value scenarios for the machine-translated rows of FL-39 batch d.

usage (from outputs/blackmoor-decomp):  python3 tests/fl41_boundary_recipes.py [--rows 0x4a378a,...] [--per-row 24] [--candidates 120]

The operator-level mutation check (tests/fl41_operator_mutation_check.py) found mutants of the lifted code that the recipes of tests/fl39d_fixtures.py do not tell
from the original (signed against unsigned compares, a sign extension that is never negative, ...). This script makes more scenarios for those rows: each is a
recipe of the fixtures (a seed, values for some atoms, values for some stack arguments) with the values at the edges of their width (0x7fff, 0x8000, 0xffff,
0x7fffffff, 0x80000000, 0xffffffff, ...). A candidate counts only when the ORIGINAL bytes run it without a fault (the fixtures raise otherwise, and a
scenario with an unmapped pointer is dropped); the first --per-row of those are written to tests/fl39d_boundary_recipes.json, which the fixtures append to the
recipes of the row. The differential test then compares the port with the original on them like on every other recipe.
"""
import argparse
import json
import os
from pathlib import Path
import random
import signal
import sys

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import fl39d_fixtures as fx
import test_fl39d_differential as T

OUT = HERE / 'fl39d_boundary_recipes.json'
EDGE = {1: [0x80, 0xff, 0x7f, 0, 1, 0xfe], 2: [0x8000, 0xffff, 0x7fff, 0, 1, 0xfffe, 0x8001],
        4: [0x80000000, 0xffffffff, 0x7fffffff, 0xfffffffe, 0x80000001, 0, 1, 0xffff8000, 0x8000, 0xffff, 0x10000, 0x7fff, 0xffff0000]}
ARG_EDGE = EDGE[4] + [0x12348000, 0xabcdffff, 0x00017fff, 0x1234ffff]


class Timeout(Exception):
    pass


def alarm(signum, frame):
    raise Timeout()


def candidates(key, count, rng):
    row = fx.ROWS[key][1]
    atoms, args = row['atoms'], row['args']
    near = sorted({(c + d) & 0xffffffff for c in row.get('consts', []) for d in (-1, 0, 1)})      # the constants the function compares with, and their neighbours
    for _ in range(count):
        chosen = {}
        for ai, atom in enumerate(atoms):
            if rng.random() > 0.45:
                continue
            pool = EDGE.get(atom.get('w', 4), EDGE[4]) + near * 2
            if atom['k'] == 'mem' and not atom['ptr']:
                chosen[ai] = rng.choice(pool) & ((1 << (8 * atom['w'])) - 1)
            elif atom['k'] == 'glob':
                chosen[ai] = rng.choice(pool) & ((1 << (8 * atom['w'])) - 1)
            elif atom['k'] == 'call':
                chosen[ai] = rng.choice(EDGE[4] + near * 2)
            elif atom['k'] == 'arg' and not atom['ptr']:
                chosen[ai] = rng.choice(ARG_EDGE + near * 2)
        arg_values = {i: rng.choice(ARG_EDGE + near) for i, kind in enumerate(args) if kind == 'val' and rng.random() < 0.6
                      and not any(a['k'] == 'arg' and a['i'] == i for a in atoms)}
        yield {'seed': rng.randrange(1, 1 << 31), 'set': chosen, 'args': arg_values, 'res': {}}


def judge(case, key, row, rec):
    """Runs the scenario on the original (Unicorn) and on the port in a child process: 0 when both ran and agree; 3 when they disagree; 1 when either faults or crashes
    (the port reads outside the exact-size fixture regions, or the original faults), 2 on a hang."""
    pid = os.fork()
    if pid == 0:
        status = 1
        try:
            signal.alarm(20)
            sc = fx.lift_scenario(key, row, rec)
            case.pair(sc, set(), set())
            status = 0
        except AssertionError:
            status = 3
        except Exception:
            status = 1
        os._exit(status)
    _, st = os.waitpid(pid, 0)
    if os.WIFSIGNALED(st):
        return 2 if os.WTERMSIG(st) == signal.SIGALRM else 1
    return os.WEXITSTATUS(st)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rows')
    ap.add_argument('--per-row', type=int, default=24)
    ap.add_argument('--candidates', type=int, default=120)
    a = ap.parse_args()
    keys = [k.replace('0x', '') for k in a.rows.split(',')] if a.rows else list(fx.KEYS)
    out = json.loads(OUT.read_text()) if OUT.exists() else {}
    case = T.Fl39dDifferential('test_48217a_lifted')
    T.Fl39dDifferential.setUpClass()
    for key in keys:
        kind, row = fx.ROWS[key]
        rng = random.Random(int(key, 16) ^ 0x41)
        kept, tried, faults = [], 0, 0
        base = list(row['recipes'])
        for rec in candidates(key, a.candidates, rng):
            tried += 1
            row['recipes'] = base + [rec]
            status = judge(case, key, row, rec)
            if status != 0:
                faults += 1
                if status == 3:
                    print('  0x%s: the port and the original DISAGREE on %s' % (key, rec), flush=True)
                continue
            kept.append({'seed': rec['seed'], 'set': {str(k): v for k, v in rec['set'].items()}, 'args': {str(k): v for k, v in rec['args'].items()}, 'res': {}})
            if len(kept) >= a.per_row:
                break
        row['recipes'] = base
        out[key] = kept
        print('0x%s kept %d of %d tried (%d faulted)' % (key, len(kept), tried, faults), flush=True)
        OUT.write_text(json.dumps(out, indent=1, sort_keys=True) + '\n')


if __name__ == '__main__':
    main()
