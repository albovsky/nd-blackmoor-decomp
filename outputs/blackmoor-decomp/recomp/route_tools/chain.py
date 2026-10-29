"""Turn a list of (scene:row[:frame]) hops into click tokens for rt.py: the centre of each hotspot rectangle (reads scenes.txt).
  python3 chain.py "S3301:5 S3302:11" [shots]"""
import sys, struct, re
from scenes_lib import load_blocks
# usage: chain.py "S3301:5 S3302:11 ..." [shots]  -> route tokens (c:x,y [s]) clicking the centre of the rectangle of each (scene,row) 0b/0c/62 action
blocks = load_blocks()
def rect(scene, row, frame=None):
    for ln in blocks[scene].split('\n')[1:]:
        m = re.match(r'\s+(\d+) t=(\w\w) s=(\w\w) k=(\d) \'(.*?)\' body=(\w*)', ln)
        if not m or int(m.group(1)) != row: continue
        t, b = m.group(2), bytes.fromhex(m.group(6))
        if t == '0b': return struct.unpack_from('<4i', b, 8), struct.unpack_from('<H', b, 2)[0]
        if t == '62': return struct.unpack_from('<4i', b, 14), None
        if t == '0c':
            n = struct.unpack_from('<h', b, 8)[0]
            es = [(struct.unpack_from('<H', b, 10 + 18 * j)[0],) + struct.unpack_from('<4i', b, 12 + 18 * j) for j in range(n)]
            e = [x for x in es if frame is None or x[0] == frame][0]
            return e[1:], struct.unpack_from('<H', b, 2)[0]
    raise SystemExit('no row %s in %s' % (row, scene))
out = []
for hop in sys.argv[1].split():
    parts = hop.split(':')
    sc, row = parts[0], parts[1]; fr = int(parts[2]) if len(parts) > 2 else None      # scene:row[:frame]
    (l, t, r, bt), tgt = rect(sc, int(row), fr)
    out.append('c:%d,%d' % ((l + r) // 2, min((t + bt) // 2, 370)))
    if len(sys.argv) > 2 and sys.argv[2] == 'shots': out.append('s')
print(' '.join(out))
