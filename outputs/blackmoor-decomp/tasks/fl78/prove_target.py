#!/usr/bin/env python3
"""FL-78: run the dominator-window prover (and the forward "faults later" prover) on single targets of a row, with timing.

  prove_target.py ROW 0xJCC:taken|fall-through ...        directions
  prove_target.py ROW 0xADDR ...                          instructions
Set FL71_VERBOSE=1 to see each window tried.
"""
import sys
import time
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl67_infeasible as P
import fl71_window as Wn


def main():
    key = sys.argv[1]
    an, dom = Wn.prepare(key)
    for t in sys.argv[2:]:
        t0 = time.time()
        if ':' in t:
            a, name = t.split(':')
            a = int(a, 16)
            T = Wn.block_of(an, a, True)
            q = ('dir', 'taken' if name == 'taken' else 'fall')
            r = Wn.prove_target(an, dom, T, q)
            print(t, 'window', r[0], 'S=%s' % (hex(r[2]) if r[2] else None), '%.1fs' % (time.time() - t0), flush=True)
            if r[0] != 'unsat':
                t0 = time.time()
                f = Wn.prove_faults(an, dom, ('dir', a, q[1]))
                print(t, 'faults', f[0], '%.1fs' % (time.time() - t0), flush=True)
        else:
            a = int(t, 16)
            T = Wn.block_of(an, a)
            r = Wn.prove_target(an, dom, T, ('ins', None))
            print(t, 'window', r[0], 'S=%s' % (hex(r[2]) if r[2] else None), '%.1fs' % (time.time() - t0), flush=True)
            if r[0] != 'unsat':
                t0 = time.time()
                f = Wn.prove_faults(an, dom, ('ins', a))
                print(t, 'faults', f[0], '%.1fs' % (time.time() - t0), flush=True)


if __name__ == '__main__':
    main()
