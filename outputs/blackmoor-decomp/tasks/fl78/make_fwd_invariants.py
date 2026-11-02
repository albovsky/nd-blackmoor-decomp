#!/usr/bin/env python3
"""FL-78: writes tests/fl78_forward_invariants.json (forward-window loop invariants for the error paths of 0x49d945).

The three error paths of 0x49d945 (a counting loop found no entry, then the diagnostics helper 0x4c97b4 returns) all end in an `idiv` by the counter that is still zero:
  0x49da7c fall-through (and 0x49da7e..0x49daa7): [ebp-0x94] == 0, idiv [ebp-0x94] at 0x49dbfb, behind the counting loops at 0x49dac5 and 0x49db68
  0x49db1c fall-through (and 0x49db1e..0x49db47): [ebp-0x70] == 0, idiv [ebp-0x70] at 0x49e06b, behind the loop at 0x49db68 and eight loop headers of the four copy loops
  0x49dbc5 fall-through (and 0x49dbc7..0x49dbf0): [ebp-0x98] == 0, idiv [ebp-0x98] at 0x49e077, behind the eight loop headers
The counter cell keeps its zero through every loop on the way. The three counting loops store through [ebp + counter*k - K]; the bounds 0 <= counter <= i <= 10 keep those stores away from the cells (the prover checks them).
"""
import json
from pathlib import Path

OUT = Path(__file__).resolve().parents[2] / 'tests' / 'fl78_forward_invariants.json'
Z, C, D, I = -0x94, -0x70, -0x98, -0x5c


def cell(off, op, val=None, other=None):
    a = {'mem': ['ebp', off, 4], 'op': op}
    if other is not None:
        a['mem2'] = ['ebp', other, 4]
    else:
        a['val'] = val
    return a


def counter(idx):
    return [cell(I, 'sge', 0), cell(I, 'sle', 10), cell(idx, 'sge', 0), cell(idx, 'sle', other=I)]


BIG = [0x49dc2f, 0x49dc77, 0x49dd3f, 0x49dd93, 0x49de67, 0x49deaf, 0x49df83, 0x49dfd7]
h = lambda a: '0x%x' % a
t1 = {h(0x49dac5): [cell(Z, 'eq', 0)] + counter(C), h(0x49db68): [cell(Z, 'eq', 0)] + counter(D)}
t2 = dict({h(0x49db68): [cell(C, 'eq', 0)] + counter(D)}, **{h(b): [cell(C, 'eq', 0)] for b in BIG})
t3 = {h(b): [cell(D, 'eq', 0)] for b in BIG}
data = {'0x49d945': {'0x49da7c:fall': t1, '0x49da7e:ins': t1, '0x49db1c:fall': t2, '0x49db1e:ins': t2, '0x49dbc5:fall': t3, '0x49dbc7:ins': t3}}
OUT.write_text(json.dumps(data, indent=1, sort_keys=True) + '\n')
