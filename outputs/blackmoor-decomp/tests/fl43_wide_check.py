#!/usr/bin/env python3
"""FL-43: does the translation of a row agree with the original bytes on seeds that are NOT in tests/fl41_corpus.json?

The corpus is chosen to run every instruction and take every jump direction; it does not show that the two stay equal elsewhere. This runs `--seeds` more seeds
(from `--start`) on the original (Unicorn) and on the committed translation and lists every seed on which any observable differs (final registers, ordered writes,
ordered stub calls). A row with a difference is NOT credited: the translation or the world model has a gap that a mutant check cannot see (a mutant that is killed
only because the unmutated translation already differs from the original is not killed by the mutant's change).

  fl43_wide_check.py [--rows 0x4a9f63,...] [--seeds 300] [--start 20000] [--jobs 4] [--out FILE]     (run from outputs/blackmoor-decomp)
"""
import argparse
import ctypes
import json
import multiprocessing as mp
import signal
import sys
import tempfile
from pathlib import Path

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import fl41_world as W

CORPUS = HERE / 'fl41_corpus.json'


def check(args):
    key, entry, seeds = args
    va = int(key, 16)
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    with tempfile.TemporaryDirectory() as tmp:
        lib = W.build_library(tmp)
        bad, ran = [], 0
        for sd in seeds:
            signal.alarm(120)
            try:
                o = W.run_original(row, sd)
                if o.fault:
                    continue
                n = W.run_native(lib, row, sd)
            finally:
                signal.alarm(0)
            ran += 1
            if n.fault or n.digest() != o.digest():
                bad.append(sd)
        return key, ran, bad


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rows')
    ap.add_argument('--seeds', type=int, default=300)
    ap.add_argument('--start', type=int, default=20000)
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--out')
    a = ap.parse_args()
    corpus = json.loads(CORPUS.read_text())
    keys = a.rows.split(',') if a.rows else sorted(corpus, key=lambda k: int(k, 16))
    seeds = list(range(a.start, a.start + a.seeds))
    result = {}
    with mp.Pool(a.jobs, maxtasksperchild=1) as pool:
        for key, ran, bad in pool.imap_unordered(check, [(k, corpus[k], seeds) for k in keys]):
            result[key] = {'seeds_run': ran, 'differing_seeds': bad}
            print('%s ran %d differing %s' % (key, ran, bad[:8]), flush=True)
            if a.out:
                Path(a.out).write_text(json.dumps(result, indent=1, sort_keys=True) + '\n')
    return 1 if any(v['differing_seeds'] for v in result.values()) else 0


if __name__ == '__main__':
    sys.exit(main())
