#!/usr/bin/env python3
"""FL-41: which survivors of tests/fl41_mutation_check.py compile to identical `gcc -O2` code as the translation they mutate.

usage (from outputs/blackmoor-decomp):  python3 scripts/fl41_o2_classify.py <mutation log> [--out tasks/fl41-o2-identical.json] [--jobs 4] [--per-row 30]

A survivor is a mutant of one line of `m<va>_lifted` that no seed of the row tells from the original bytes. When the function with that line mutated and the function as
committed give the same assembly under `gcc -O2 -S` (compiled alone, symbol names normalised), the mutated line is dead or masked code (a flag nobody reads, a register that is
overwritten before it is read, ...): the two functions do the same thing, so the survivor is explained by the compiler, not by the seeds. The mutants are rebuilt exactly as the
check made them (same operators, same random stream seeded with the row address, the same --per-row).

The result is {row: [[kind, line], ...]}: the survivors with identical code. fl41_survivors.py reads it.
"""
import json
import multiprocessing as mp
from pathlib import Path
import random
import re
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl41_mutation_check as M

PER_ROW = int(sys.argv[sys.argv.index('--per-row') + 1]) if '--per-row' in sys.argv else 30      # the --per-row the mutation check ran with


def asm(text, name, helper, tmp):
    src = Path(tmp) / 'f.c'
    src.write_text('#include "original_methods_fl41.h"\n' + helper + text.replace(name, 'fl41_fn'))
    done = subprocess.run(['gcc', '-std=c11', '-O2', '-S', '-fno-asynchronous-unwind-tables', '-fno-ident', '-w', '-I%s' % (PROJECT / 'src'), str(src), '-o', '-'],
                          capture_output=True, text=True)
    if done.returncode != 0:
        return None
    return '\n'.join(l for l in done.stdout.split('\n') if not l.lstrip().startswith(('.file', '.ident', '#')))


def classify_row(args):
    va, text, helper, wanted = args
    muts = M.mutants(text, int(va, 16), random.Random(int(va, 16)), PER_ROW)
    found = {}
    for kind, n, t in muts:          # two mutants of one (kind, line) are possible: the survivor is identical only if every candidate is
        found.setdefault((kind, n), []).append(t)
    same = []
    with tempfile.TemporaryDirectory() as tmp:
        base = asm(text, 'm%x_lifted' % int(va, 16), helper, tmp)
        if base is None:
            return va, same
        for kind, n in wanted:
            texts = found.get((kind, n))
            if not texts:
                continue
            ok = True
            for t in texts:
                name = re.search(r'm%x_mut\d+' % int(va, 16), t).group(0)
                other = asm(t, name, helper, tmp)
                ok = ok and other is not None and other == base
            if ok:
                same.append([kind, n])
    return va, same


def main():
    log = sys.argv[1]
    jobs = int(sys.argv[sys.argv.index('--jobs') + 1]) if '--jobs' in sys.argv else 4
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())
    helper = funcs.get('0x50c920', '')
    work = []
    for line in open(log):
        m = re.match(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)', line)
        if not m:
            continue
        wanted = [(kind, n) for kind, n, why in eval(m.group(2)) if why == 'survives']
        if wanted:
            work.append((m.group(1), funcs[m.group(1)], helper if 'FL41_CALL_LIFTED' in funcs[m.group(1)] else '', wanted))
    out = {}
    with mp.Pool(jobs) as pool:
        for va, same in pool.imap_unordered(classify_row, work):
            out[va] = same
    total = sum(len(w[3]) for w in work)
    print('rows %d, survivors %d, identical -O2 code %d' % (len(work), total, sum(len(v) for v in out.values())))
    if '--out' in sys.argv:
        Path(sys.argv[sys.argv.index('--out') + 1]).write_text(json.dumps(dict(sorted(out.items(), key=lambda kv: int(kv[0], 16))), indent=1) + '\n')


if __name__ == '__main__':
    main()
