#!/usr/bin/env python3
"""FL-68: re-translate single rows of the FL-57 table with the current lifter (scripts/lift_fl41.py BULK mode) and splice the new text into translated/original_methods_fl57_translated.c.

scripts/fl57_bulk.py rewrites the whole file; this replaces only the rows listed, so every other row keeps its text (the tested-equivalent manifest pins the text of each row by hash). The table entry
(tests/fl57_translated.json) gets the new callees, imports, fs and guessed pops; its seeds, coverage and status are kept.

  fl68_relift.py ROW [ROW ...] [--write]        (run from outputs/blackmoor-decomp; without --write only reports which rows would change)
"""
import argparse
import json
from pathlib import Path
import re
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_world as W
import lift_fl41 as L
import fl57_bulk as B

SOURCE = PROJECT / 'translated/original_methods_fl57_translated.c'
TABLE = PROJECT / 'tests/fl57_translated.json'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--write', action='store_true')
    a = ap.parse_args()
    L.BULK = True
    src = SOURCE.read_text()
    table = json.loads(TABLE.read_text())
    changed = []
    for key in a.rows:
        va = int(key, 16)
        old = table[key]
        L.GUESSED_CALLEES.clear()
        L.ASSUMED_MATH.clear()
        L._FPU_NET.clear()
        L._FPU_NET_BULK.clear()
        text, callees, imports, fs, inline = L.lift(va, old['body'])
        m = re.search(r'^/\* GAME\.EXE %s \(.*?(?=^/\* GAME\.EXE 0x|\Z)' % re.escape(key), src, re.M | re.S)
        if m is None:
            print(key, 'not in the file')
            continue
        was = m.group(0)
        new_text = text.rstrip('\n') + '\n' + ('\n' if was.endswith('\n\n') else '')
        if new_text == was and {hex(k): v for k, v in callees.items()} == old['callees']:
            continue
        changed.append(key)
        print(key, 'changes: callees', old['callees'], '->', {hex(k): v for k, v in callees.items()}, 'guessed', old.get('guessed_callee_pops'), '->', sorted(hex(x) for x in L.GUESSED_CALLEES))
        if a.write:
            src = src[:m.start()] + new_text + src[m.end():]
            old['callees'] = {hex(k): v for k, v in callees.items()}
            old['imports'] = {hex(k): v for k, v in imports.items()}
            old['fs'] = fs
            old['guessed_callee_pops'] = sorted(hex(x) for x in L.GUESSED_CALLEES)
            old['assumed_x87_math'] = {hex(k): v for k, v in sorted(L.ASSUMED_MATH.items())}
    if a.write and changed:
        SOURCE.write_text(src)
        TABLE.write_text(json.dumps(table, indent=1, sort_keys=True) + '\n')
    print('%d rows change' % len(changed))


if __name__ == '__main__':
    main()
