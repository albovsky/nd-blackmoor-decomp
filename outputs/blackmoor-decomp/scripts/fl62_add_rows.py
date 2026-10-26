#!/usr/bin/env python3
"""FL-62 (from fl58_add_rows.py): move "translated, unverified" upper rows (translated/original_methods_fl41_translated.c, tests/fl41_translated.json) into the credited working set: the corpus, the C source and the
differential test of the FL-41 family, so that the automated mutation pass can run on them.

  fl62_add_rows.py ROW [ROW ...] | --candidates FILE | --refused tasks/fl60-added.json [--scen FILE ...]      (run from outputs/blackmoor-decomp)

The scenarios of --scen (the output of scripts/fl62_concolic.py, {row: [[seed, overrides], ...]}) are run after the kept seeds, so they add the coverage that the seeds lack.

For each row it requires the strict lifter (BULK off) to give the text of the table, re-runs the kept seeds on the original bytes and on the translation (they must agree), and requires the
seeds together to run every instruction and take both directions of every conditional jump. The shared helpers `__chkstk` (0x50c920) and `__EH_prolog` (0x50f978) go into the source as one
chunk under the key 0x50c920 (what the mutation scripts look up). Rows that fail stay translated and unverified.
"""
import argparse
import json
from pathlib import Path
import re
import sys
import tempfile

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_world as W
import lift_fl41 as L
import fl41_generate as G
from fl45_merge import split

SOURCE = PROJECT / 'src/original_methods_fl41.c'
CORPUS = PROJECT / 'tests/fl41_corpus.json'
TABLE = PROJECT / 'tests/fl41_translated.json'
TEST = PROJECT / 'tests/test_fl41_differential.py'


def helper_chunk(spans):
    eh = L.lift(0x50f978, spans[0x50f978])[0]
    eh = re.sub(r'^/\* GAME\.EXE 0x50f978 \(', '/* __EH_prolog 0x50f978 (second shared helper; not a row) (', eh)
    return L.lift(0x50c920, spans[0x50c920])[0] + '\n' + eh


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='*')
    ap.add_argument('--candidates')
    ap.add_argument('--refused', help='a tasks/flNN-added.json: its refused rows')
    ap.add_argument('--scen', action='append', default=[])
    ap.add_argument('--out', default='tasks/fl62-added.json')
    ap.add_argument('--dry', action='store_true')
    a = ap.parse_args()
    rows = list(a.rows)
    if a.candidates:
        rows += json.loads(Path(a.candidates).read_text())['candidates']
    if a.refused:
        rows += sorted(json.loads(Path(a.refused).read_text())['refused'])
    scen = {}
    for f in a.scen:
        for k, v in json.loads(Path(f).read_text()).items():
            scen.setdefault(k, []).extend(v)
    table = json.loads(TABLE.read_text())
    corpus = json.loads(CORPUS.read_text())
    spans = L.ledger_spans()
    ledger = {e['va']: e for e in json.loads((PROJECT / 'function-ledger.json').read_text())['entries']}
    source = SOURCE.read_text()
    have = split(source)
    header = source.split('/* GAME.EXE 0x', 1)[0]
    added, refused = [], {}
    new_text = {}
    for key in rows:
        if key in corpus:
            continue
        t = table[key]
        va = int(key, 16)
        if t.get('sites') or t.get('frame'):
            refused[key] = 'indirect call or made-up frame'
            continue
        if ledger[key]['region'] != 'game' or ledger[key]['status'] != 'pending' or t['status'] != 'agrees':
            refused[key] = 'not a pending game row that agrees'
            continue
        text, callees, imports, fs, inline = L.lift(va, spans[va])
        row = W.row_info(va, spans[va], callees, imports, fs)
        if t.get('sites') or t.get('frame'):
            refused[key] = 'indirect call or made-up frame'
            continue
        tmp = tempfile.mkdtemp()
        src = Path(tmp) / 'row.c'
        src.write_text('#include "original_methods_fl41.h"\n' + (helper_chunk(spans) if inline else '') + '\n' + text)
        lib = W.build_library(tmp, [src])
        ex, ed, kept = set(), set(), []
        bad = None
        pend = json.loads((PROJECT / 'tests/fl41_pending.json').read_text()).get(key, {}).get('seeds', [])
        for seed, overrides in list(t['seeds']) + list(pend) + list(scen.get(key, [])):
            overrides = [tuple(o) for o in overrides]
            o = W.run_original(row, seed, overrides)
            if o.fault:
                if [seed, [list(x) for x in overrides]] in [[s_, [list(x) for x in o_]] for s_, o_ in scen.get(key, [])]:
                    continue                 # a generated scenario that faults in the original is dropped
                bad = 'a kept seed faults in the original'
                break
            n = W.run_native(lib, row, seed, overrides)
            if n.fault or n.digest() != o.digest():
                bad = 'MISMATCH on seed %d overrides %s' % (seed, overrides)
                break
            if o.executed <= ex and o.edges <= ed:
                continue
            kept.append([seed, [list(x) for x in overrides]])
            ex |= o.executed
            ed |= o.edges
        if bad:
            refused[key] = bad
            continue
        got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
        if missing or untaken:
            refused[key] = 'coverage incomplete: %d/%d instructions, %d/%d directions' % (got, total, taken, dirs)
            continue
        corpus[key] = {'body': row['body'], 'callees': {hex(k): n for k, n in row['callees'].items()}, 'imports': {hex(k): n for k, n in row['imports'].items()}, 'fs': row['fs'],
                       'seeds': kept, 'instructions': [got, total], 'directions': [taken, dirs]}
        new_text[key] = text
        added.append(key)
        if inline:
            new_text['0x50c920'] = helper_chunk(spans)
    print('added %d rows, refused %d' % (len(added), len(refused)))
    for k, v in refused.items():
        print('  ', k, v)
    if a.dry or not added:
        return 0
    import fcntl
    with open(str(CORPUS) + '.lock', 'w') as lock:          # scripts/fl62_onerow.py adds killers to the corpus under this lock while rows are checked: merge the new rows into the file as it is now
        fcntl.flock(lock, fcntl.LOCK_EX)
        fresh = json.loads(CORPUS.read_text())
        for key in added:
            fresh[key] = corpus[key]
        source_now = SOURCE.read_text()
        have = split(source_now)
        header = source_now.split('/* GAME.EXE 0x', 1)[0]
        have.update({k: v if v.endswith('\n') else v + '\n' for k, v in new_text.items()})
        keys = sorted((k for k in have if k != '0x50c920'), key=lambda x: int(x, 16))
        order = (['0x50c920'] if '0x50c920' in have else []) + keys
        SOURCE.write_text(header + ''.join(have[k] for k in order))
        CORPUS.write_text(json.dumps(fresh, indent=1, sort_keys=True) + '\n')
        TEST.write_text(G.test_source(sorted(int(k, 16) for k in fresh)))
    (PROJECT / a.out).write_text(json.dumps({'added': added, 'refused': refused}, indent=1) + '\n')
    return 0


if __name__ == '__main__':
    sys.exit(main())
