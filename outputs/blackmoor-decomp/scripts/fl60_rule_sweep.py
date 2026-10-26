#!/usr/bin/env python3
"""FL-60: re-run the survivor rules over EVERY compiling mutant of the credited rows of tests/fl41_corpus.json, as if no seed had killed any (a synthetic log), and write the class each mutant gets.

  fl60_rule_sweep.py synth --out DIR [ROW ...]      writes DIR/synthetic.txt (all rows of the corpus when none is named)
  fl60_rule_sweep.py classify --out DIR             runs scripts/fl41_survivors.py on it: DIR/classes.json
  fl60_rule_sweep.py diff OLD.json NEW.json         the mutants whose class changed between two runs of `classify` (the sweep before and after a rule fix)

A credit loses its justification when a mutant it relied on moves from a rule class to unexplained and the real record shows that mutant as a survivor (not killed by a seed):
see scripts/fl60_demote.py. Run from outputs/blackmoor-decomp.
"""
import argparse
import json
from pathlib import Path
import subprocess
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_mutation_check as M
import fl55_rule_soundness as S


def synth(out, rows):
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())
    helper = funcs.get('0x50c920', '')
    corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
    rows = rows or sorted(corpus, key=lambda k: int(k, 16))
    lines = []
    for key in rows:
        muts = S.compiling_mutants(key, funcs[key], helper if 'FL41_CALL_LIFTED' in funcs[key] else '')
        lines.append('%s mutants %d killed 0 survivors %r' % (key, len(muts), [(k, n, 'survives', i) for k, n, i in muts]))
        print(key, len(muts), flush=True)
    out.mkdir(parents=True, exist_ok=True)
    (out / 'synthetic.txt').write_text('\n'.join(lines) + '\n')
    (out / 'empty-o2.json').write_text('{}\n')


def classify(out):
    subprocess.run([sys.executable, str(PROJECT / 'scripts/fl41_survivors.py'), str(out / 'synthetic.txt'), '--equiv', str(out / 'empty-o2.json'), '--out', str(out / 'classes.json')], check=True)


def diff(a, b):
    ca = json.loads(Path(a).read_text())['mutants']
    cb = json.loads(Path(b).read_text())['mutants']
    changed = []
    for row in sorted(ca, key=lambda k: int(k, 16)):
        old = {(k, n, i): c for k, n, i, c in ca[row]}
        new = {(k, n, i): c for k, n, i, c in cb.get(row, [])}
        for key, c in old.items():
            if new.get(key, 'MISSING') != c:
                changed.append((row, key[0], key[1], key[2], c, new.get(key, 'MISSING')))
    for c in changed:
        print(c)
    print('changed mutants: %d' % len(changed))
    return changed


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('cmd', choices=['synth', 'classify', 'diff'])
    ap.add_argument('rest', nargs='*')
    ap.add_argument('--out')
    a = ap.parse_args()
    if a.cmd == 'synth':
        synth(Path(a.out), a.rest)
    elif a.cmd == 'classify':
        classify(Path(a.out))
    else:
        diff(*a.rest)
