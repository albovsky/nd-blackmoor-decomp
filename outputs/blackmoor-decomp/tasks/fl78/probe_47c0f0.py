import sys, json, struct
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl66_tested as T
from unicorn import x86_const as X
key = '0x47c0f0'
pool = T.pool_of(key); W, G = T.world(T.POOLS[pool]['world']); row = T.row_info(pool, key)
r = json.load(open('tasks/fl78/frame_0x47c0f0.json'))
for s, ov in r['kept']:
    seen = []
    def p(uc, ensure, n):
        edx = uc.reg_read(X.UC_X86_REG_EDX)
        seen.append((edx, uc.mem_read(edx + 0x35b, 1)[0] if True else None))
    try:
        o = W.run_original(row, s, [tuple(x) for x in ov], probes={0x47c746: p})
    except Exception as e:
        print(s, 'ERR', e); continue
    print(s, 0x47c746 in o.executed, [(hex(a), b) for a, b in seen][:3])
