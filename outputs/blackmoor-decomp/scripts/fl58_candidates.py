#!/usr/bin/env python3
"""FL-58: which "translated, unverified" upper rows may enter the automated verification pass (and so, if clean, become port credits).

  fl58_candidates.py [--out FILE]      (run from outputs/blackmoor-decomp)

A row is a candidate when all of these hold:
  - it is a game-region row (the ledger never credits CRT, MFC or library rows);
  - its quick run in tests/fl41_translated.json agrees with the original (a coverage gap is listed as `partial`: scripts/fl58_add_rows.py adds the seeds that the FL-41 searches kept in
    tests/fl41_pending.json and the row enters only when together they run every instruction and take both directions of every conditional jump);
  - it is not in the corpus, not ported, and its translation is the one the strict lifter (BULK off) gives, with `__EH_prolog` (0x50f978) allowed as an inline helper: no call through a register
    or pointer (the bytes such a target pops are a guess), no callee of unknown x87 effect, no fragment run on a made-up frame.
Prints the counts by reason and writes the candidate list.
"""
import argparse
import json
from pathlib import Path
import re
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
import lift_fl41 as L


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default=str(PROJECT / 'tasks/fl58-candidates.json'))
    a = ap.parse_args()
    table = json.loads((PROJECT / 'tests/fl41_translated.json').read_text())
    corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
    entries = {e['va']: e for e in json.loads((PROJECT / 'function-ledger.json').read_text())['entries']}
    texts = {}
    for chunk in re.split(r'(?=/\* GAME\.EXE 0x)', (PROJECT / 'translated/original_methods_fl41_translated.c').read_text()):
        m = re.match(r'/\* GAME\.EXE (0x[0-9a-f]+)', chunk)
        if m:
            texts[m.group(1)] = chunk.rstrip('\n') + '\n'
    spans = L.ledger_spans()
    why = {}
    ok = []
    partial = []
    L.INLINE_CALLEES.add(0x50f978)
    for k, t in sorted(table.items(), key=lambda kv: int(kv[0], 16)):
        e = entries[k]
        if e['region'] != 'game':
            why[k] = 'library region'
        elif e['status'] != 'pending' or k in corpus:
            why[k] = 'already credited or in the corpus'
        elif t['status'] != 'agrees':
            why[k] = 'no seed'
        elif t.get('sites') or t.get('frame'):
            why[k] = 'indirect call or made-up frame'
        else:
            L.BULK = False
            try:
                strict = L.lift(int(k, 16), spans[int(k, 16)])[0]
            except L.Unsupported as ex:
                why[k] = 'strict lifter refuses: %s' % str(ex)[:60]
                continue
            finally:
                L.BULK = True
            if strict.rstrip('\n') != texts[k].rstrip('\n'):
                why[k] = 'bulk translation differs from the strict one'
            else:
                ok.append(k)
                if t['instructions'][0] != t['instructions'][1] or t['directions'][0] != t['directions'][1]:
                    partial.append(k)         # the quick seeds leave a gap; fl58_add_rows.py adds the seeds of tests/fl41_pending.json (the FL-41 searches) and decides
    import collections
    print(len(table), 'translated;', len(ok), 'candidates,', len(partial), 'of them with a coverage gap in the quick seeds')
    print(collections.Counter(re.sub(r':.*', '', v) for v in why.values()).most_common())
    Path(a.out).write_text(json.dumps({'candidates': ok, 'partial': partial, 'excluded': why}, indent=1) + '\n')


if __name__ == '__main__':
    main()
