#!/usr/bin/env python3
"""FL-58: the hardening step of the exhaustive mutation check, for the rows scripts/fl58_add_rows.py put into the corpus.

  fl58_harden.py ROW [ROW ...] [--jobs 4]      (run from outputs/blackmoor-decomp)

A mutant that no corpus seed kills is retried on 40 extra seeds and, with `harden`, on 600 wide ones; the seeds that kill are returned by tests/fl41_mutation_check.py (`killers`), each only after the
unmutated translation was shown to agree with the original on it. This script adds those seeds to the corpus entry of the row (plain numbered seeds, no overrides) so that the corpus alone kills the
mutants (the credited rows have no 'killed only by an extra seed' lines). No directed search: the seed numbers are the fixed ranges of the checker. Rows whose check errors out or runs past the
alarm are left as they are.
"""
import argparse
import json
import multiprocessing as mp
from pathlib import Path
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl41_mutation_check as M


def one(key):
    corpus = json.loads(M.CORPUS.read_text())
    funcs = M.split_functions(M.SOURCE.read_text())
    helper = funcs.get('0x50c920', '')
    return M.check_row((key, corpus[key], funcs[key], helper if 'FL41_CALL_LIFTED' in funcs[key] else '', 100000, True, True))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--jobs', type=int, default=4)
    a = ap.parse_args()
    results = {}
    with mp.Pool(a.jobs, maxtasksperchild=1) as pool:
        for key, res in pool.imap_unordered(one, a.rows):
            results[key] = res
            if 'error' in res:
                print(key, 'ERROR', res['error'][:200], flush=True)
            else:
                print(key, 'mutants %d killed %d killers %s divergent %s hangs %d budgets %d' % (res['mutants'], res['killed'], res['killers'], res['divergent'], len(res['hangs']), len(res['budgets'])), flush=True)
    corpus = json.loads(M.CORPUS.read_text())
    for key, res in results.items():
        if 'error' in res:
            continue
        have = {sd for sd, _ in corpus[key]['seeds']}
        for sd in res['killers']:
            if sd not in have:
                corpus[key]['seeds'].append([sd, []])
    M.CORPUS.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    (PROJECT / 'tasks/fl58-harden.json').write_text(json.dumps({k: {x: v[x] for x in ('mutants', 'killed', 'killers', 'divergent') if x in v} if 'error' not in v else v for k, v in results.items()}, indent=1) + '\n')


if __name__ == '__main__':
    main()
