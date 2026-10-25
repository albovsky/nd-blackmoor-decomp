#!/usr/bin/env python3
"""FL-52: finish the coverage search of the pool rows that scripts/fl41_generate.py left 'incomplete' (instructions all run, one to three jump directions untaken).

The generator's guided search only changes memory cells that fed a compare. A jump after `call; test eax, eax` depends on what a callee stub returned, and no cell holds that;
this search adds, for every callee stub of a run, a return-value override (eax, then ecx and edx) of 0, 1, -1, 0x7fffffff, 0x80000000, 2, 0xff and 0x100, on top of the cell
changes, and keeps a scenario when it runs an instruction or takes a direction not yet seen. The scenario must agree with the translation (the generator's `consider` check).

  fl52_cover.py --rows 0x48e93e,... [--budget 3000] [--jobs 3] --out FILE.json       (run from outputs/blackmoor-decomp)

FILE.json has, per row, the generator's result record (status 'complete' or 'incomplete', seeds, coverage counts), the same shape as tests/fl41_pending.json plus 'seeds'; scripts/fl41_generate.py
writes the C and the corpus from such a record when it is given this file with --cache."""
import argparse
import json
import multiprocessing as mp
from pathlib import Path
import random
import sys
import tempfile

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_world as W
import fl41_generate as G
import lift_fl41 as L

_children = G.children


def children(row, o, overrides, untaken, rng):
    out = list(_children(row, o, overrides, untaken, rng))
    calls = len(o.calls)
    extra = []
    for k in range(calls):
        for r in (0, 1, 2):
            cell = W.STUB_OVR + 16 * k + 4 * r
            for v in (0, 1, 0xffffffff, 0x7fffffff, 0x80000000, 2, 0xff, 0x100):
                extra.append((cell, 4, v))
    rng.shuffle(extra)
    return out[:10] + extra[:14]


G.children = children


def work(args):
    row, libpath, guided = args
    res = G.search_row((row, libpath, 300, guided))[1]
    return row['va'], res


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rows', required=True)
    ap.add_argument('--budget', type=int, default=3000)
    ap.add_argument('--jobs', type=int, default=3)
    ap.add_argument('--out', required=True)
    a = ap.parse_args()
    spans = L.ledger_spans()
    vas = [int(v, 16) for v in a.rows.split(',')]
    texts, rows = {}, {}
    for va in vas:
        text, callees, imports, fs, inline = L.lift(va, spans[va])
        texts[va] = text
        rows[va] = W.row_info(va, spans[va], callees, imports, fs)
    tmp = tempfile.mkdtemp()
    src = Path(tmp) / 'all.c'
    uses_inline = any('FL41_CALL_LIFTED' in t for t in texts.values())
    helper = L.lift(0x50c920, spans[0x50c920])[0] if uses_inline else ''
    src.write_text('#include "original_methods_fl41.h"\n' + helper + '\n'.join(texts[v] for v in vas))
    W.build_library(tmp, [src])
    libpath = str(Path(tmp) / 'fl41.so')
    out = Path(a.out)
    results = json.loads(out.read_text()) if out.is_file() else {}
    todo = [v for v in vas if hex(v) not in results or results[hex(v)]['status'] == 'error']
    with mp.Pool(a.jobs, maxtasksperchild=1) as pool:
        for k, (va, res) in enumerate(pool.imap_unordered(work, [(rows[v], libpath, a.budget) for v in todo])):
            results[hex(va)] = res
            out.write_text(json.dumps(results))
            print('%d/%d 0x%x %s %s' % (k + 1, len(todo), va, res['status'], {x: res[x] for x in ('instructions', 'directions', 'tried', 'untaken') if x in res}), flush=True)


if __name__ == '__main__':
    main()
