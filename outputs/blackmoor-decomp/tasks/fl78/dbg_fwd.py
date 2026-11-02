import sys
from pathlib import Path
PROJECT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl67_infeasible as P
import fl71_window as Wn
an, dom = Wn.prepare('0x49d945')
sd = Wn.stack_delta(an)
for h in (0x49dc2f, 0x49dc77, 0x49dd3f, 0x49db68, 0x49dac5):
    print(hex(h), sd.get(h))
bad = [hex(b) for b in an.blocks if b not in sd]
print('blocks without delta', bad[:40])

import z3
T = Wn.block_of(an, 0x49db1c, True)
D = 0x49db18
orderA = Wn.window(an, dom, D, T)
orderB = Wn.forward_region(an, T)
M = an.M
start = Wn.run_window(an, orderA, D, T, ('ins', None), True, want_state=True)
tie = Wn.relate(an, D, P.State.start())
inv = Wn.load_forward_invariants(an.va, ('dir', 0x49db1c, 'fall'), T)
orig = Wn.check_forward_invariants
def dbg(an, inv, gen_state, hdr_in, hdr_back, tie=None):
    chk = lambda f: an.check(z3.And(tie, f))[0]
    for h, gs in gen_state.items():
        atoms = inv[h]
        assumed = P.inv_formula(M, gs, atoms)
        for c, st_b in hdr_back.get(h, []):
            for k, part in enumerate(P.inv_parts(M, st_b, atoms)):
                f = z3.And(tie, assumed, c, z3.Not(part))
                s = z3.Solver(); s.set('timeout', 120000); s.add(*M.facts); s.add(f)
                r = s.check()
                if r != z3.unsat:
                    print('FAIL header %#x atom %d: %s' % (h, k, r))
                    if r == z3.sat:
                        m = s.model()
                        for name in ('s_esp', 's_ebp'):
                            for d in m.decls():
                                if d.name() == name: print(name, m[d])
                    return
    print('all ok')
Wn.check_forward_invariants = dbg
try:
    f = Wn.run_forward(an, orderB, T, ('dir', 0x49db1c, 'fall'), True, start=start, inv=inv, tie=tie)
except P.Unsupported as e:
    print('unsupported', e)
