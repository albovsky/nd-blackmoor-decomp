#!/usr/bin/env python3
"""FL-40 and FL-42: original-x86 oracle for the pending game rows of GAME.EXE translated in src/original_methods_fl40.c (FL-42 added 65 rows to the corpus, FL-44 8 more; FL-46, FL-49, FL-53 and FL-54 credit the rows that pass the exhaustive check, tasks/fl40-held-rows.json holds the rest; FL-49 added killing seeds from scripts/fl49_targeted.py to 40 rows; FL-51 added 39 rows that use the x87 unit; FL-64 credits 3 rows with the cell-range and folded-constant rules).

Runs ONLY the original bytes (Unicorn, no native library) on the seeds of tests/fl40_corpus.json, the same seeds and the same world (tests/fl40_world.py) that
tests/test_fl40_differential.py runs the translation on. The hooks are the OS and host boundaries only: a recording stub at the entry of each callee (it
returns scripted values, stores scripted bytes through its pointer arguments, pops the stack the callee itself pops) and the lazily filled memory pages.
Nothing inside a function under test is patched; every compare, jump, index computation and store of the bodies runs as original instructions.

Prints one line per function:  0x<va> instructions <executed>/<total> branch-directions <taken>/<total> scenarios <n> digest <sha256 of everything compared, over
all scenarios>. Exits 0 only when every instruction of every function was executed and both directions of every conditional jump were taken, except the
directions a corpus row lists as `untaken_ok` (FL-56: no input can take them; each has a mechanical proof by scripts/fl56_untaken.py). No original bytes or memory dumps are printed. Run from outputs/blackmoor-decomp:
python3 tests/fl40_original_oracle.py
"""
import hashlib
import json
from pathlib import Path
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
import fl28b_fixtures as F
import fl40_world as W

CORPUS = Path(__file__).resolve().parent / 'fl40_corpus.json'


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
        allowed = [tuple(x) for x in c.get('untaken_ok', [])]      # FL-56: directions no input can take (scripts/fl56_untaken.py)
        if missing or sorted(untaken) != sorted(allowed):
            print('  never executed: %s; untaken: %s' % (' '.join(hex(a) for a in missing[:16]), untaken[:8]), file=sys.stderr)
            status = 1
    return status


if __name__ == '__main__':
    sys.exit(main())
