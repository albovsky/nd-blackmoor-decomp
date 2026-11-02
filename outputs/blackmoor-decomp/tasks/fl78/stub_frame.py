#!/usr/bin/env python3
"""FL-78 experiment: which window proves a target when the frame assumption is forced on (frame_safe stubbed True), and which frame-address instructions can run before that window."""
import sys
from pathlib import Path
PROJECT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl67_infeasible as P
import fl71_window as Wn

key = sys.argv[1]
an, dom = Wn.prepare(key)
print('esc', [hex(a) for a in an.esc_addrs])
an.frame_safe = lambda S, region: an.split_ok
for t in sys.argv[2:]:
    if ':' in t:
        a, name = t.split(':')
        a = int(a, 16)
        T = Wn.block_of(an, a, True)
        r = Wn.prove_target(an, dom, T, ('dir', 'taken' if name == 'taken' else 'fall'))
    else:
        a = int(t, 16)
        T = Wn.block_of(an, a)
        r = Wn.prove_target(an, dom, T, ('ins', None))
    print(t, r[0], hex(r[2]) if r[2] else None)
    S = r[2]
    if S:
        esc = {b for b, blk in an.blocks.items() if any(i.address in an.esc_addrs for i in blk['insns'])}
        seen, work = {S}, [S]
        while work:
            n = work.pop()
            for p in an.pred[n]:
                if p not in seen:
                    seen.add(p)
                    work.append(p)
        order = Wn.window(an, dom, S, T)
        print('  escape blocks that reach S:', sorted(hex(b) for b in esc & seen), ' in the window:', sorted(hex(b) for b in esc & set(order)))
