#!/usr/bin/env python3
"""FL-55: soundness check of the survivor rules of scripts/fl41_survivors.py (and the liveness / data-flow rules under it) on the rows of tests/fl41_corpus.json.

A rule is unsound when it calls harmless a mutant that some seed of the corpus kills. This script regenerates every compiling mutant of a row (the same list the mutation check builds), lets
fl41_survivors.py classify ALL of them as if no seed had killed any (a synthetic log), and compares with the real survivors of the row's merged mutation log: a mutant that a rule
explains but the real log shows killed (not among the survivors, or listed there only as 'killed only by an extra seed') disproves the rule. Mutants that the compiler proves identical
(`identical code`) are not rules and are left out (no -O2 equivalence file is given).

  fl55_rule_soundness.py MERGED_LOG ROW [ROW ...] --out DIR      (run from outputs/blackmoor-decomp; MERGED_LOG as written by fl52_merge.py)
"""
import argparse
import json
from pathlib import Path
import random
import re
import subprocess
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl41_mutation_check as M


def compiling_mutants(key, text, helper):
    va = int(key, 16)
    muts = M.mutants(text, va, random.Random(va), 100000, True)
    import tempfile
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / 'm.c'
        for _ in range(4):
            src.write_text('#include "original_methods_fl41.h"\n' + helper + text + '\n' + '\n'.join(m[2] for m in muts))
            built = subprocess.run(['cc', '-std=c11', '-O0', '-c', '-fPIC', '-w', '-I%s' % (PROJECT / 'src'), str(src), '-o', str(Path(tmp) / 'm.o')], capture_output=True, text=True)
            if built.returncode == 0:
                break
            bad = {int(x) for x in re.findall(r"m%x_mut(\d+)" % va, built.stderr)}
            if not bad:
                raise RuntimeError(built.stderr[:500])
            muts = [(kind, n, t.replace('m%x_mut%d' % (va, i), 'm%x_mutX' % va)) for i, (kind, n, t) in enumerate(muts) if i not in bad]
            muts = [(kind, n, re.sub(r'm%x_mutX' % va, 'm%x_mut%d' % (va, i), t, count=1)) for i, (kind, n, t) in enumerate(muts)]
    return [(kind, n, M.line_hash(t, n)) for kind, n, t in muts]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('log')
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--out', required=True)
    a = ap.parse_args()
    out = Path(a.out)
    out.mkdir(parents=True, exist_ok=True)
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())
    helper = funcs.get('0x50c920', '')
    real = {}
    for line in Path(a.log).read_text().split('\n'):
        m = re.match(r'^(0x[0-9a-f]+) mutants (\d+) killed (\d+) survivors (\[.*\])$', line)
        if m:
            real[m.group(1)] = {x[3] for x in eval(m.group(4)) if x[2] == 'survives'}
    synthetic, allm = [], {}
    for key in a.rows:
        muts = compiling_mutants(key, funcs[key], helper if 'FL41_CALL_LIFTED' in funcs[key] else '')
        allm[key] = muts
        synthetic.append('%s mutants %d killed 0 survivors %r' % (key, len(muts), [(k, n, 'survives', i) for k, n, i in muts]))
    (out / 'synthetic.txt').write_text('\n'.join(synthetic) + '\n')
    (out / 'empty-o2.json').write_text('{}\n')
    subprocess.run([sys.executable, str(PROJECT / 'scripts/fl41_survivors.py'), str(out / 'synthetic.txt'), '--equiv', str(out / 'empty-o2.json'), '--out', str(out / 'classes.json')], check=True,
                   capture_output=True)
    classes = json.loads((out / 'classes.json').read_text())['mutants']
    bad = []
    claimed = 0
    for key in a.rows:
        for kind, n, ident, cls in classes.get(key, []):
            if cls is None or cls in ('written reason',):
                continue
            claimed += 1
            if key in real and ident not in real[key]:
                bad.append((key, kind, n, ident, cls))
    print('mutants classified harmless by a rule: %d; of them killed by a corpus seed: %d' % (claimed, len(bad)))
    for b in bad:
        print('UNSOUND', b)
    (out / 'unsound.json').write_text(json.dumps(bad))


if __name__ == '__main__':
    main()
