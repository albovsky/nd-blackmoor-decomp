#!/usr/bin/env python3
"""FL-41: original-x86 oracle for the pending game rows of GAME.EXE translated in src/original_methods_fl41.c.

Runs ONLY the original bytes (Unicorn, no native library) on the seeds of tests/fl41_corpus.json, the same seeds and the same world (tests/fl41_world.py) that
tests/test_fl41_differential.py runs the translation on. The hooks are the OS and host boundaries only: a recording stub at the entry of each callee (it
returns scripted values, stores scripted bytes through its pointer arguments, pops the stack the callee itself pops) and the lazily filled memory pages.
Nothing inside a function under test is patched; every compare, jump, index computation and store of the bodies runs as original instructions.

Prints one line per function:  0x<va> instructions <executed>/<total> branch-directions <taken>/<total> scenarios <n> digest <sha256 of everything compared, over
all scenarios>. Exits 0 only when every instruction of every function was executed and both directions of every conditional jump were taken (there is no
allowlist: a row with an untaken direction is not in the corpus). No original bytes or memory dumps are printed. Run from outputs/blackmoor-decomp:
python3 tests/fl41_original_oracle.py

FL-63: the corpus now holds 173 rows (the script text changes whenever the corpus does, so that `record_function_execution.py collect --merge` records a new run).
"""
import hashlib
import json
from pathlib import Path
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
import fl28b_fixtures as F
import fl41_world as W

CORPUS = Path(__file__).resolve().parent / 'fl41_corpus.json'


def rows():
    corpus = json.loads(CORPUS.read_text())
    for key in sorted(corpus, key=lambda k: int(k, 16)):
        c = corpus[key]
        yield key, c, W.row_info(int(key, 16), c['body'], {int(k, 16): v for k, v in c['callees'].items()}, {int(k, 16): v for k, v in c['imports'].items()}, c['fs'])


def main():
    if not od.available():
        print('needs Unicorn and the pinned private work/original/GAME.EXE', file=sys.stderr)
        return 2
    status = 0
    for key, c, row in rows():
        executed, edges = set(), set()
        chain = hashlib.sha256()
        for seed, overrides in c['seeds']:
            t = W.run_original(row, seed, [tuple(x) for x in overrides])
            if t.fault:
                print('%s seed %d faulted: %s' % (key, seed, t.fault), file=sys.stderr)
                status = 1
                continue
            executed |= t.executed
            edges |= t.edges
            chain.update(t.digest().encode())
        total = od.instruction_addresses(row['va'], row['body'])
        missing = sorted(total - executed)
        taken, directions = 0, 0
        untaken = []
        for address, _, target, after in F.conditional_edges(row['va'], row['body']):
            for name, nxt in (('taken', target), ('fall-through', after)):
                directions += 1
                if (address, nxt) in edges:
                    taken += 1
                else:
                    untaken.append((hex(address), name))
        print('%s instructions %d/%d branch-directions %d/%d scenarios %d digest %s' % (key, len(total) - len(missing), len(total), taken, directions,
                                                                                        len(c['seeds']), chain.hexdigest()))
        if missing or untaken:
            print('  never executed: %s; untaken: %s' % (' '.join(hex(a) for a in missing[:16]), untaken[:8]), file=sys.stderr)
            status = 1
    return status


if __name__ == '__main__':
    sys.exit(main())
