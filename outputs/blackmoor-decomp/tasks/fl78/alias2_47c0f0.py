"""0x47c0f0 second try: leave `that` = the seed's own [this+0xc] and move `this` (REG_OVERRIDE ecx) so that this+0x1cc+k lies on the byte [that+0x35b]."""
import sys, json, itertools
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl66_tested as T
import fl41_world as W41
key = '0x47c0f0'
pool = T.pool_of(key); W, G = T.world(T.POOLS[pool]['world']); row = T.row_info(pool, key)
r = json.load(open('tasks/fl78/frame_0x47c0f0.json'))
base = [(s, [tuple(x) for x in ov]) for s, ov in r['kept']]
ex0, ed0 = set(), set()
for s0, o0 in base:
    q = W.run_original(row, s0, o0); ex0 |= q.executed; ed0 |= q.edges
that = 0x20060e48
s = 256
ov0 = [tuple(x) for s_, ov in r['kept'] if s_ == s for x in ov]
for k in range(0, 16):
    for off in (0, 1, 2, 3):
        this = that + 0x35b - 0x1cc - k
        for src in (0, 0x100, 0x7fffff00):
            o_ = ov0 + [(W41.REG_OVERRIDE + 4, 4, this), (that + 0x2a1, 4, src), (that + 0x35b, 1, 1)]
            o = W.run_original(row, s, o_)
            g = G.covers(row, ex0 | o.executed, ed0 | o.edges)
            print(k, hex(src), 'fault' if o.fault else '', '746', 0x47c746 in o.executed, 'untaken', [(hex(a), n) for a, n in g[5]], flush=True)
            if not g[5]:
                json.dump([[s, [list(x) for x in o_]]], open('tasks/fl78/hand_47c0f0.json', 'w'))
                print('HIT')
                sys.exit()
        break
