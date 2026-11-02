import sys, unittest
sys.path.insert(0,'scripts'); sys.path.insert(0,'tests')
from unittest import mock
import z3
import fl67_infeasible as P, fl71_window as Wn
import test_fl67_infeasible as t
NAMES = ['test_a_push_of_the_frame_base_after_the_prologue_refuses_the_frame_assumption', 'test_the_stack_discipline_boundaries', 'test_the_stack_discipline_assumption_keeps_only_call_temporaries_apart']
def run(ctx):
    res = {}
    with ctx:
        for n in NAMES:
            r = unittest.TextTestRunner(stream=open('/dev/null', 'w')).run(unittest.TestSuite([t.Fl78Review4(n)]))
            res[n[:30]] = len(r.failures) + len(r.errors)
    return res
orig_ok = P.frame_ok
def ok_any_push(i, first=False): return orig_ok(i, True)
orig_temp = P.Machine.is_temp
def is_temp_le(self, a, n=1):
    L, delta = self.temps
    s_esp, s_ebp = z3.BitVec('s_esp', 32), z3.BitVec('s_ebp', 32)
    c = z3.simplify(z3.substitute(a, (s_esp, s_ebp + P.bv(delta, 32))) - s_ebp)
    c = c.as_long(); c = c - (1 << 32) if c >= 1 << 31 else c
    return c <= -L
orig_string = P.Machine.string
def string_noguard(self, st, ins, base, rep):
    saved = self.temps
    self.temps = None
    try: return orig_string(self, st, ins, base, rep)
    finally: self.temps = saved
muts = {
 'push ebp anywhere': mock.patch.object(P, 'frame_ok', ok_any_push),
 'is_temp <= -L': mock.patch.object(P.Machine, 'is_temp', is_temp_le),
 'is_temp always': mock.patch.object(P.Machine, 'is_temp', lambda self, a, n=1: True),
 'no string guard': mock.patch.object(P.Machine, 'string', string_noguard),
 'delta check off': mock.patch.object(Wn, 'temps_of', lambda an, S: (an.temps_info(), Wn.stack_delta(an).get(S)) if an.temps_info() is not None and Wn.stack_delta(an).get(S) is not None else None),
 'no straddle check': mock.patch.object(P.Machine, 'is_temp', lambda self, a, n=1: orig_temp(self, a, 1)),
 'no temp_value guard': mock.patch.object(P.Machine, 'temp_value', lambda self, v: None),
}
print('baseline', run(mock.patch.object(P, 'frame_ok', orig_ok)))
for k, c in muts.items():
    print(k, run(c))
