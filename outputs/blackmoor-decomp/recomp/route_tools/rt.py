"""Build INPUT steps from tokens: c:x,y click, T:x,y a short-hold click (a turn), C:x,y a 4 s hold, s shot, g:ms wait, k:vk key, d:vk keydown, u:vk keyup.
  ANCHOR=S2010.CIF python3 rt.py "T:10,200 c:303,170 s" 8000 [hold_ms]   (default anchor UICELLPOPUP_OVL.CIF)"""
import sys
# usage: rt.py "c:x,y s w:ms k:vk ..." [start_ms] [hold_ms] -> steps anchored on UICELLPOPUP_OVL.CIF (the phone opened once in the base route)
# c:x,y click (move, the click 1 s later, then 5 s of settle time)  s: shot  g:ms / w:ms wait  k:vk key press  d:vk keydown  u:vk keyup
# C:x,y a click with a long 4 s hold (a turn that keeps panning)
import os
P = os.environ.get('ANCHOR', 'UICELLPOPUP_OVL.CIF')
toks = sys.argv[1].split()
t = int(sys.argv[2]) if len(sys.argv) > 2 else 14000
hold = sys.argv[3] if len(sys.argv) > 3 else '600'
out = []
for tk in toks:
    if tk[:2] in ('c:', 'C:', 'T:'):
        xy = tk[2:]
        h = {'c': hold, 'C': '4000', 'T': '150'}[tk[0]]
        out.append('%s+%d:move:%s' % (P, t, xy))
        out.append('%s+%d:click:%s,%s' % (P, t + 1000, xy, h))
        t += 6000
    elif tk == 's':
        out.append('%s+%d:shot:0,0' % (P, t)); t += 500
    elif tk[:2] in ('g:', 'w:'):
        t += int(tk[2:])
    elif tk.startswith('k:'):
        out.append('%s+%d:key:%s' % (P, t, tk[2:])); t += 500
    elif tk.startswith('d:'):
        out.append('%s+%d:keydown:%s' % (P, t, tk[2:])); t += 400
    elif tk.startswith('u:'):
        out.append('%s+%d:keyup:%s' % (P, t, tk[2:])); t += 400
print(';'.join(out))
