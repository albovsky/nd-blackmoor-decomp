"""List the navigation rows of one scene with their rectangles, from scenes.txt (the output of scenedump over the decoded scene resources, see ROUTES.md).
  python3 hot.py S2010
Derived hotspot geometry only; scenes.txt itself is local analysis output and is not committed."""
import sys, struct, re
# usage: hot.py SCENE   -> the navigation rows of the scene with their rectangles
want = sys.argv[1]
txt = open('scenes.txt').read().split('\nSCENE ')
for blk in txt:
    if not blk.startswith(want + ' '): continue
    lines = blk.split('\n'); print(lines[0][:120])
    for ln in lines[1:]:
        m = re.match(r'\s+(\d+) t=(\w\w) s=(\w\w) k=(\d) \'(.*?)\' body=(\w*) deps=(\d+)(.*)', ln)
        if not m: continue
        i, t, st, k, desc, body, nd, deps = m.groups(); b = bytes.fromhex(body)
        if t == '0b' and len(b) >= 24:
            sc = struct.unpack_from('<H', b, 2)[0]; r = struct.unpack_from('<4i', b, 8)
            print(' row %s 0b -> S%d  rect %s  fl=%s%s' % (i, sc, r, b[:2].hex(), deps[:60]))
        elif t == '0c' and len(b) >= 10:
            sc = struct.unpack_from('<H', b, 2)[0]; n = struct.unpack_from('<h', b, 8)[0]
            print(' row %s 0c -> S%d  fl=%s  entries(frame,rect): %s %s' % (i, sc, b[:2].hex(), [ (struct.unpack_from('<H', b, 10+18*j)[0],) + struct.unpack_from('<4i', b, 12+18*j) for j in range(n)], deps[:50]))
        elif t == '62' and len(b) >= 30:
            print(' row %s 62 hotspot rect %s flag=%d' % (i, struct.unpack_from('<4i', b, 14), struct.unpack_from('<H', b, 0)[0]))
        elif t in ('0a',):
            print(' row %s 0a -> S%d %s' % (i, struct.unpack_from('<H', b, 2)[0], deps[:60]))
        elif t not in ('9f','97','4d','4f','61','6b','62'):
            print(' row %s t=%s %s %s' % (i, t, desc, deps[:50]))
    break
