"""ab.py ROW OUT 'EXPR' [files]   (FL-78) absolute-address scenario builder.
EXPR is a python expression -> list of override-sets; an override-set is a list of (addr,size,val). Names: SP, arg(n) = stack address of the n-th dword argument, R(reg,val) register override (eax ecx edx ebx esi edi ebp),
W (world), and ptrs: P0..P7 = 0x20000000+0x10000*i.
Base scenarios: the files' scenarios if files are given (known corpus is NOT used unless ALLKNOWN=1), else plain seeds SEEDS=a-b (default 1-3).
Each set is applied to every base scenario; coverage adders are kept (ALL=1 keeps every non-faulting run; DBG=1 prints faults)."""
import sys, os
sys.path.insert(0, '/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key = sys.argv[1]; out = sys.argv[2]; files = sys.argv[4:]
pool, W, G, row = setup(key)
if os.environ.get('LIM'): W.INSTRUCTION_LIMIT = int(os.environ['LIM'])
SP = W.SP
def arg(n): return SP + 4 + 4 * n
def R(reg, val): return (W.REG_OVERRIDE + 4 * W.REG_NAMES.index(reg), 4, val)
for i in range(8): globals()['P%d' % i] = 0x20000000 + 0x10000 * i
def S(addr, text):
    b = text.encode('latin1') if isinstance(text, str) else bytes(text)
    return [(addr + i, 1, c) for i, c in enumerate(b + b'\0')]
if sys.argv[3].startswith('@'):
    exec(open(sys.argv[3][1:]).read()); sets = SETS
else:
    sets = eval(sys.argv[3])
if files:
    from_files = F.known_scenarios(key, F.POOLS[pool]['world'], files)
    if not os.environ.get('ALLKNOWN'):
        import json as _j
        keep = []
        for f in files:
            d = _j.load(open(f)).get(key) or []
            keep += [(s, [tuple(o) for o in ov]) for s, ov in d]
        from_files = keep
    base = from_files
else:
    a, b = (os.environ.get('SEEDS') or '1-3').split('-')
    base = [(i, []) for i in range(int(a), int(b))]
ex = set(); ed = set(); kept = []
for s, ov in base:
    if not files: break
    tr = run(W, row, s, ov)
    if tr.fault: continue
    if not (tr.executed <= ex and tr.edges <= ed): ex |= tr.executed; ed |= tr.edges; kept.append([s, [list(o) for o in ov]])
print('base', cov(G, row, ex, ed)[:4], len(kept), flush=True)
for si, st in enumerate(sets):
    for s, ov in base:
        cells = [tuple(c) for c in st]
        nov = [list(o) for o in ov if not any(o[0] < c[0] + c[1] and c[0] < o[0] + o[1] for c in cells)] + [list(c) for c in cells]
        try: tr = run(W, row, s, nov)
        except Exception as e:
            if os.environ.get('DBG'): print('exc', si, s, e)
            continue
        gc.collect()
        if tr.fault:
            if os.environ.get('DBG'): print('fault', si, s, tr.fault)
            continue
        if os.environ.get('ALL') or not (tr.executed <= ex and tr.edges <= ed):
            ex |= tr.executed; ed |= tr.edges; kept.append([s, nov]); print('new', si, s, cov(G, row, ex, ed)[:4], flush=True)
got, total, taken, dirs, missing, untaken = cov(G, row, ex, ed)
print('final', got, total, taken, dirs, ' '.join('%x%s' % (a, 'T' if n == 'taken' else 'F') for a, n in untaken))
json.dump({key: kept}, open(out, 'w'))
