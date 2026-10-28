"""winlong.py ROW JCC taken|fall-through STEP_MS: window proof with a long per-query solver budget; prints the verdicts per window start"""
import sys; sys.path.insert(0,'scripts'); sys.path.insert(0,'tests'); sys.dont_write_bytecode=True
import fl71_window as Wn
key=sys.argv[1]; a=int(sys.argv[2],16); name=sys.argv[3]; Wn.STEP_MS=int(sys.argv[4]); Wn.VERBOSE=True
an,dom=Wn.prepare(key)
out=Wn.prove_row_windows(an,dom,{'untaken':[[a,name]],'missing':[]})
print(out)
