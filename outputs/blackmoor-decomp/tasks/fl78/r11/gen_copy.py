"""gen_copy.py OUT.json: scenarios for the CRT block copies 0x50ed50 / 0x50fa90 (memmove / memcpy: dst, src, n at 0x100fee0, 0x100fee4, 0x100fee8): sizes 0..41 and some larger, every alignment of source and destination, disjoint and overlapping both ways"""
import json, sys
A = 0x100fee0
B = 0x20001000
sc = []
def add(dst, src, n, seed=1):
    sc.append([seed, [[A, 4, dst], [A + 4, 4, src], [A + 8, 4, n]]])
sizes = list(range(0, 42)) + [48, 64, 100]
for n in sizes:
    for da in range(4):
        for sa in range(4):
            add(B + 0x400 + da, B + sa, n)                           # disjoint, destination above
            add(B + da, B + 0x400 + sa, n)                           # disjoint, destination below
for n in (1, 2, 3, 4, 5, 7, 8, 9, 12, 16, 17, 24, 32, 33, 40, 64):
    for d in (1, 2, 3, 4, 5, 7, 8, 12, 16, 33):
        for da in range(4):
            add(B + 0x100 + da + d, B + 0x100 + da, n)              # destination inside the source, above it (a backward copy)
            add(B + 0x100 + da, B + 0x100 + da + d, n)              # destination below the source, overlapping
            add(B + 0x100 + da + d, B + 0x100 + da + 1, n)
            add(B + 0x100 + da, B + 0x100 + da + d + 1, n)
json.dump(sc, open(sys.argv[1], 'w'))
print(len(sc))
