#!/usr/bin/env python3
"""FL-56: bulk analysis of the coverage-incomplete lower rows (tests/fl40_pending.json).

  fl56_bulk.py [--rows a,b] [--scen FILE]      (run from outputs/blackmoor-decomp)

For each pending row with seeds it runs the kept seeds (plus the scenarios of FILE, {row: [[seed, overrides], ...]}) on the original bytes, lists the instructions never run and the jump directions
never taken, tries scripts/fl56_untaken.py on every untaken direction, and removes the proven-impossible edges from the control-flow graph. A row is `provable-complete` when every instruction
left unrun is unreachable once those edges are gone and every untaken direction is proven impossible. Prints one line per row:
  ROW body_bytes missing/total untaken [proved/unproved] verdict
and writes the proved rows with their `untaken_ok` lists to tasks/fl56-provable.json.
"""
import argparse
import json
from pathlib import Path
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
from capstone import x86_const as X
import fl28b_fixtures as F
import fl40_world as W
import lift_function as L
import fl40_generate as G
import fl56_untaken as U


def reachable(ins, removed):
    """addresses reachable from the entry when the (jcc address, 'taken'|'fall-through') edges in `removed` do not exist"""
    by = {i.address: k for k, i in enumerate(ins)}
    seen, work = set(), [ins[0].address]
    while work:
        a = work.pop()
        if a in seen or a not in by:
            continue
        seen.add(a)
        i = ins[by[a]]
        nxt = ins[by[a] + 1].address if by[a] + 1 < len(ins) else None
        is_jump = i.group(X.X86_GRP_JUMP) or i.mnemonic.startswith('loop') or i.mnemonic == 'jecxz'
        if i.mnemonic == 'ret':
            continue
        if is_jump:
            if not (i.operands and i.operands[0].type == X.X86_OP_IMM):
                return None                   # an indirect jump: every address is a possible target
            if i.mnemonic != 'jmp':
                if (a, 'taken') not in removed:
                    work.append(i.operands[0].imm)
                if (a, 'fall-through') not in removed and nxt is not None:
                    work.append(nxt)
            else:
                work.append(i.operands[0].imm)
        elif nxt is not None:
            work.append(nxt)
    return seen


def analyse(key, pending, extra):
    va = int(key, 16)
    spans = L.ledger_spans()
    text, callees, imports, fs, inline = L.lift(va, spans[va])
    row = W.row_info(va, spans[va], callees, imports, fs)
    ex, ed = set(), set()
    n_ok = 0
    for seed, overrides in list(pending[key].get('seeds', [])) + list(extra.get(key, [])):
        o = W.run_original(row, seed, [tuple(x) for x in overrides])
        if o.fault:
            continue
        n_ok += 1
        ex |= o.executed
        ed |= o.edges
    got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
    proved, unproved = [], []
    for a, d in untaken:
        p = U.prove(key, a, d)
        (proved if p else unproved).append((a, d))
    ins = U.disasm(va, spans[va])
    reach = reachable(ins, set(proved))
    live_missing = [m for m in missing if reach is None or m in reach]
    ok = bool(n_ok) and not unproved and not live_missing
    return dict(row=key, body=spans[va], got=got, total=total, untaken=untaken, missing=missing, proved=proved, unproved=unproved, live_missing=live_missing, ok=ok)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rows')
    ap.add_argument('--scen')
    a = ap.parse_args()
    pending = json.loads((PROJECT / 'tests/fl40_pending.json').read_text())
    extra = json.loads(Path(a.scen).read_text()) if a.scen else {}
    keys = a.rows.split(',') if a.rows else [k for k, v in pending.items() if 'seeds' in v]
    out = {}
    for key in sorted(keys, key=lambda k: pending[k].get('body', 0) or int(k, 16)):
        r = analyse(key, pending, extra)
        print('%s %5d missing %d/%d untaken %d [proved %d / unproved %d] live-missing %d %s' % (key, r['body'], r['total'] - r['got'], r['total'], len(r['untaken']), len(r['proved']), len(r['unproved']), len(r['live_missing']),
                                                                                     'PROVABLE-COMPLETE' if r['ok'] else ''), flush=True)
        if r['ok']:
            out[key] = [['0x%x' % x, d] for x, d in r['proved']]
    (PROJECT / 'tasks/fl56-provable.json').write_text(json.dumps(out, indent=1, sort_keys=True) + '\n')


if __name__ == '__main__':
    main()
