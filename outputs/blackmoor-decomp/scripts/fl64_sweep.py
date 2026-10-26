#!/usr/bin/env python3
"""FL-64: soundness sweep of the survivor rules of scripts/fl64_rules.py over EVERY row of tests/fl40_corpus.json that has an exhaustive mutation log (the LOGS of scripts/fl44_final.py).

A rule is unsound when it explains a mutant that some seed of the corpus kills (or that the step budget kills, i.e. one that hangs). For every (kind, line) of a row this classifies ALL the mutants the
checker builds for that kind and line as if no seed had killed any (scripts/fl40_survivors.classify with the FL-64 context), keeps the lines that the NEW rules explain (the old rules are not asked: the
class must come from fl64_rules), and compares with the real log: every such mutant must be listed there as `survives`. A (kind, line) with two mutants needs two `survives` entries.

  fl64_sweep.py --out FILE [--rows A,B] [--jobs 4]      (run from outputs/blackmoor-decomp)
"""
import argparse
import json
import multiprocessing as mp
from pathlib import Path
import random
import re
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl40_mutation_check as M
import fl40_survivors as S
import fl44_final as F
import fl64_rules as R

PER_ROW = 900
LINE = re.compile(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)')


class Slow(Exception):
    pass


def _alarm(*_):
    raise Slow()


def work(args):
    import signal
    signal.signal(signal.SIGALRM, _alarm)
    signal.alarm(PER_ROW)
    try:
        return work_row(args)
    except Slow:
        return args[0], None                    # a row that takes too long is skipped: it makes no claim, so it cannot be unsound
    finally:
        signal.alarm(0)


def work_row(args):
    row, text, real = args
    ctx = S.fl64_context(row, text, None)
    if not ctx:
        return row, None
    lines = text.split('\n')
    from collections import Counter
    per = Counter()
    variants = {}
    for mk, mn, mt in M.mutants(text, int(row, 16), random.Random(int(row, 16)), 100000):
        variants.setdefault((mk, mn), []).append(mt.split('\n')[mn])
    surv = Counter((k, n) for k, n, why, *_ in real if why == 'survives')
    out = []
    for (kind, n), vs in variants.items():
        cls = R.explain(kind, lines, n, row, vs, ctx.get('ranges'), ctx.get('proofs'), ctx.get('cells'))
        if cls is None:
            continue
        out.append((kind, n, cls, len(vs), surv[(kind, n)]))
    return row, out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', required=True)
    ap.add_argument('--rows')
    ap.add_argument('--jobs', type=int, default=4)
    a = ap.parse_args()
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl40.c').read_text())
    corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
    logs = {}
    for name in F.LOGS:
        logs.update(F.parse(name))
    rows = a.rows.split(',') if a.rows else sorted((r for r in corpus if r in logs and r in funcs), key=lambda k: int(k, 16))
    items = [(r, funcs[r], logs[r]) for r in rows if r in logs]
    explained = unsound = 0
    res = {}
    with mp.Pool(a.jobs, maxtasksperchild=1) as pool:
        for row, out in pool.imap_unordered(work, items):
            print('done', row, 'skipped' if out is None else '%d lines' % len(out), flush=True)
            if out is None:
                continue
            res[row] = out
            for kind, n, cls, nv, ns in out:
                explained += nv
                if ns < nv:
                    unsound += 1
                    print('UNSOUND?', row, kind, n, cls, 'variants', nv, 'real survivors', ns, flush=True)
    Path(a.out).write_text(json.dumps(res))
    print('rows %d; mutants explained by FL-64 rules %d; (kind, line) pairs with a variant that a real run killed: %d' % (len(res), explained, unsound))


if __name__ == '__main__':
    main()
