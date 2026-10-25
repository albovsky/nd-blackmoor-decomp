#!/usr/bin/env python3
"""FL-56: coverage lab for ONE translated lower row whose seeds leave an instruction unrun or a jump direction untaken (tests/fl40_pending.json).

  fl56_cover.py ROW [--scen FILE] [--show N]      (run from outputs/blackmoor-decomp)

Runs the row's kept seeds from tests/fl40_pending.json (or tests/fl40_corpus.json) plus the scenarios of FILE (JSON list of [seed, [[address, size, value], ...]]; address >= 0xffff0000 sets a
start register, see tests/fl40_world.py REG_OVERRIDE) on the original bytes (Unicorn) and on the translation, requires both to agree on every scenario that does not fault in the original, and
prints what is still missing: instructions never run and conditional-jump directions never taken. With --show N it also prints, for each untaken direction, the compare events in front of that jump
seen in N of the runs that reached it (operand values, bit width, address of the operand cell) so that a killing cell override can be written by hand.
Writes the combined scenario list that gives the coverage to FILE.out.json (only scenarios that add coverage are kept).
"""
import argparse
import ctypes
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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('row')
    ap.add_argument('--scen')
    ap.add_argument('--show', type=int, default=0)
    a = ap.parse_args()
    va = int(a.row, 16)
    spans = L.ledger_spans()
    text, callees, imports, fs, inline = L.lift(va, spans[va])
    row = W.row_info(va, spans[va], callees, imports, fs)
    pending = json.loads((PROJECT / 'tests/fl40_pending.json').read_text())
    corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
    base = (pending.get(a.row) or corpus.get(a.row) or {}).get('seeds', [])
    scen = json.loads(Path(a.scen).read_text()) if a.scen else []
    helper = L.lift(0x50c920, spans[0x50c920])[0] if inline else ''
    tmp = tempfile.mkdtemp()
    src = Path(tmp) / 'row.c'
    src.write_text('#include "original_methods_fl40.h"\n' + helper + '\n' + text)
    lib = W.build_library(tmp, [src])
    ex, ed = set(), set()
    kept = []
    shown = {}
    for k, (seed, overrides) in enumerate(list(base) + list(scen)):
        overrides = [tuple(o) for o in overrides]
        o = W.run_original(row, seed, overrides, observe=bool(a.show))
        if o.fault:
            print('scenario %d faults in the original (%s): ignored' % (k, o.fault))
            continue
        if a.show:
            for e in o.events:
                shown.setdefault(e[0], []).append((seed, e))
        if o.executed <= ex and o.edges <= ed:
            continue
        n = W.run_native(lib, row, seed, overrides)
        if n.fault or n.digest() != o.digest():
            print('MISMATCH original vs translation on scenario %d: seed %s overrides %s' % (k, seed, overrides))
            return 1
        kept.append([seed, [list(o_) for o_ in overrides]])
        ex |= o.executed
        ed |= o.edges
    got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
    print('%s instructions %d/%d directions %d/%d scenarios kept %d' % (a.row, got, total, taken, dirs, len(kept)))
    print('never run:', ' '.join(hex(x) for x in missing))
    print('untaken:', [(hex(x), n) for x, n in untaken])
    if a.show:
        wanted = G.jcc_cmp_addresses(row, untaken)
        for address in sorted(wanted):
            print('compare at 0x%x reached in %d runs' % (address, len(shown.get(address, []))))
            for seed, e in shown.get(address, [])[:a.show]:
                print('   seed', seed, 'event (address, bits, a, b, cell_a, cell_b, writes)', e)
    out = Path(a.scen + '.out.json') if a.scen else Path(tempfile.mkdtemp()) / 'out.json'
    out.write_text(json.dumps(kept))
    print('combined scenarios ->', out)
    return 0


if __name__ == '__main__':
    sys.exit(main())
