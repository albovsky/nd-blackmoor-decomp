#!/usr/bin/env python3
"""FL-78: directed scenario fuzzer for a partial row: mutate this-fields (the displacements the function reads) of the kept scenarios, keep a mutant when it covers a still-missing instruction or direction.
usage: fuzz_row.py ROW SCENFILE OUT ROUNDS [THIS]"""
import sys, json, random, struct, time
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl66_tested as T
import fl67_infeasible as P
key, scen_file, out_file, rounds = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
THIS = int(sys.argv[5], 16) if len(sys.argv) > 5 else 0x20000000
base = [tuple(x) for x in json.load(open(scen_file))[key]]
an = P.Analysis(P.row_of(key), P.load_image(), 20000)
disps = sorted({o.mem.disp for i in an.insns for o in i.operands if o.type == 3 and o.mem.base and i.reg_name(o.mem.base) not in ('ebp', 'esp') and 0 <= o.mem.disp < 0x2000})
f = lambda x: struct.unpack('<I', struct.pack('<f', x))[0]
pool = [0, 1, 2, 3, 4, 8, 0xffffffff, 0x80000000, 0x7fffffff, 0x7fff, 0xffff, 0x8000, 100, 1000, f(1.0), f(100.0), f(0.0), f(-1.0), f(0.5), f(1e9)]
pool_ = T.pool_of(key); W, G = T.world(T.POOLS[pool_]['world']); rowi = T.row_info(pool_, key)
rnd = random.Random(int(sys.argv[6]) if len(sys.argv) > 6 else 7)
res = T.check_row(key, scenarios=base, max_scen=4000)
miss, unt = set(res['missing']), {tuple(x) for x in res['untaken']}
print('start', len(miss), len(unt), flush=True)
corpus = list(base)
kept = []
t0 = time.time()
for r in range(rounds):
    s, ov = rnd.choice(corpus)
    ov = [list(x) for x in ov]
    for _ in range(rnd.choice((1, 1, 2, 3))):
        d = rnd.choice(disps)
        v = rnd.choice(pool)
        if rnd.random() < 0.25 and ov:                                           # relational: a field gets the value of another field that the scenario already sets (or of one of its neighbours)
            src = rnd.choice(ov)
            ov.append([THIS + d, 4, (src[2] + rnd.choice((0, 0, 1, -1))) & 0xffffffff])
        elif rnd.random() < 0.3:
            d2 = rnd.choice(disps)
            ov.append([THIS + d, 4, rnd.choice(pool)])
            ov.append([THIS + d2, 4, rnd.choice(pool)])
        else:
            ov.append([THIS + d, 4, v])
    if rnd.random() < 0.3:
        s = rnd.randrange(0, 60)
    if rnd.random() < 0.4:                                                       # equalise: pre-set fields to the values the run itself writes there (so a compare of the old and the new value sees equal, or off by one)
        try:
            o = W.run_original(rowi, s, ov)
            wr = [(a, v) for a, sz, v in o.writes if THIS <= a < THIS + 0x2000 and sz == 4]
        except Exception:
            wr = []
        for a, v in rnd.sample(wr, min(len(wr), rnd.choice((1, 2, 3, 4)))):
            ov = [x for x in ov if x[0] != a] + [[a, 4, (v + rnd.choice((0, 0, 0, 1))) & 0xffffffff]]
    cand = (s, ov)
    try:
        c = T.check_row(key, scenarios=[cand], max_scen=1)
    except Exception as e:
        continue
    cm, cu = set(c['missing']), {tuple(x) for x in c['untaken']}
    new = (miss - cm) | (unt - cu)
    if new:
        miss &= cm
        unt &= cu
        corpus.append(cand)
        kept.append(cand)
        json.dump({key: base + kept}, open(out_file, 'w'))
        print(r, 'new', len(new), '-> missing', len(miss), 'untaken', len(unt), '%.0fs' % (time.time() - t0), flush=True)
    if not miss and not unt:
        break
print('done', len(miss), len(unt), sorted(unt))
