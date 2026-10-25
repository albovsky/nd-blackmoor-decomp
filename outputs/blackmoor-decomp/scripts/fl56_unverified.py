#!/usr/bin/env python3
"""FL-56: write the lifter's translations of the lower rows that are NOT in the verified corpus into src/original_methods_fl56_unverified.c, with a manifest.

  fl56_unverified.py [--check]      (run from outputs/blackmoor-decomp; needs Unicorn and the private work/original/GAME.EXE)

A row here has a machine translation (scripts/lift_function.py) that compiles and agrees with the original bytes (Unicorn) on every kept seed of tests/fl40_pending.json, but whose seeds do not
run every instruction or take every jump direction, or whose mutation check has not been run. It is a translation, NOT a ported credit: the ledger does not count it, and nothing here
claims that the translation is right on the part of the function the seeds never reach. The manifest tasks/fl56-translated-unverified.json records, per row, the seeds, how much of the function
they cover and the status `translated, unverified`. Rows whose translation disagrees with the original on a seed are listed under `mismatch` and left out of the source.
With --check the committed source and manifest must equal what the lifter writes now.
"""
import json
from pathlib import Path
import sys
import tempfile

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl28b_fixtures as F
import fl40_world as W
import lift_function as L
import fl40_generate as G

SOURCE = PROJECT / 'src/original_methods_fl56_unverified.c'
MANIFEST = PROJECT / 'tasks/fl56-translated-unverified.json'
PENDING = PROJECT / 'tests/fl40_pending.json'
HEADER = '''/* FL-56: GAME.EXE functions below 0x480000, translated instruction by instruction by scripts/lift_function.py (see original_methods_fl40.h for the model).
 * GENERATED: regenerate with scripts/fl56_unverified.py; do not edit by hand. Each symbol `m<va>_lifted` is the original function at <va>.
 * TRANSLATED, UNVERIFIED: these translations compile and agree with the original bytes on the seeds of tasks/fl56-translated-unverified.json, but those seeds do not run
 * every instruction or take every jump direction, and no mutation check was run. They are not ported credits (the function ledger does not count them). */
#include "original_methods_fl40.h"

'''


def compiles(text, helper):
    import subprocess
    tmp = Path(tempfile.mkdtemp())
    src = tmp / 'one.c'
    src.write_text('#include "original_methods_fl40.h"\n' + helper + '\n' + text)
    r = subprocess.run(['cc', '-std=c11', '-O0', '-c', '-w', '-I%s' % (PROJECT / 'src'), str(src), '-o', str(tmp / 'one.o')], capture_output=True, text=True)
    return r.returncode == 0, r.stderr[:300]


def build():
    L.UNVERIFIED = True
    pending = json.loads(PENDING.read_text())
    corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
    spans = L.ledger_spans()
    ledger = json.loads((PROJECT / 'function-ledger.json').read_text())['entries']
    rows = sorted((x['va'] for x in ledger if x['status'] == 'pending' and x['region'] == 'game' and int(x['va'], 16) < 0x480000 and x['va'] not in corpus), key=lambda k: int(k, 16))
    texts, infos, refused, assumed, guessed, indirect = {}, {}, {}, {}, {}, {}
    helper = L.lift(0x50c920, spans[0x50c920])[0]
    for key in rows:
        va = int(key, 16)
        L.ASSUMED_NEUTRAL.clear()
        L.GUESSED_CALLEES.clear()
        del L.INDIRECT_CALLS[:]
        L._FPU_NET.clear()
        try:
            text, callees, imports, fs, inline = L.lift(va, spans[va])
        except L.Unsupported as ex:
            refused[key] = str(ex)
            continue
        ok, err = compiles(text, helper if inline else '')
        if not ok:
            refused[key] = 'does not compile: ' + err
            continue
        texts[key] = text
        assumed[key] = sorted(hex(x) for x in L.ASSUMED_NEUTRAL)
        guessed[key] = sorted(hex(x) for x in L.GUESSED_CALLEES)
        indirect[key] = [[hex(a), n] for a, n in L.INDIRECT_CALLS]
        infos[key] = W.row_info(va, spans[va], callees, imports, fs)
    tmp = tempfile.mkdtemp()
    src = Path(tmp) / 'all.c'
    uses_helper = any('FL40_CALL_LIFTED' in x for x in texts.values())
    src.write_text('#include "original_methods_fl40.h"\n' + (helper if uses_helper else '') + '\n' + '\n'.join(texts[k] for k in texts))
    lib = W.build_library(tmp, [src])
    kept, mismatch, manifest = [], {}, {}
    for key in texts:
        row = infos[key]
        ex, ed = set(), set()
        bad = None
        seeds = (pending.get(key) or {}).get('seeds', [])
        for seed, overrides in seeds:
            overrides = [tuple(o) for o in overrides]
            o = W.run_original(row, seed, overrides)
            if o.fault:
                continue
            n = W.run_native(lib, row, seed, overrides)
            if n.fault or n.digest() != o.digest():
                bad = [seed, [list(x) for x in overrides]]
                break
            ex |= o.executed
            ed |= o.edges
        if bad:
            mismatch[key] = bad
            continue
        got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
        kept.append(key)
        manifest[key] = {'body': row['body'], 'status': 'translated, unverified', 'instructions': [got, total], 'directions': [taken, dirs], 'seeds_checked': len(seeds), 'assumed_x87_neutral': assumed[key], 'guessed_callee_pops': guessed[key], 'indirect_calls_pop_inferred': indirect[key],
                         'callees': {hex(k): n for k, n in row['callees'].items()}, 'imports': {hex(k): n for k, n in row['imports'].items()}, 'fs': row['fs'], 'seeds': seeds}
    source = HEADER + (helper if uses_helper else '') + '\n'.join(texts[k] for k in kept)
    return source, {'note': 'Translated, unverified lower rows (FL-56): not ported credits. See scripts/fl56_unverified.py.', 'rows': manifest, 'mismatch': mismatch, 'refused': refused}


def main():
    if not W.od.available():
        print('needs Unicorn and the pinned private work/original/GAME.EXE', file=sys.stderr)
        return 2
    source, manifest = build()
    text = json.dumps(manifest, indent=1, sort_keys=True) + '\n'
    if '--check' in sys.argv:
        ok = SOURCE.read_text() == source and MANIFEST.read_text() == text
        print('up to date' if ok else 'DIFFERS')
        return 0 if ok else 1
    SOURCE.write_text(source)
    MANIFEST.write_text(text)
    print('translated, unverified rows: %d, mismatch: %d, refused: %d' % (len(manifest['rows']), len(manifest['mismatch']), len(manifest['refused'])))
    return 0


if __name__ == '__main__':
    sys.exit(main())
