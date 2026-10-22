#!/usr/bin/env python3
"""FL-40: sort the survivors of tests/fl40_mutation_check.py (its log on stdin or as the argument) into the classes the handoff explains and the rows that stay out.

Explained classes (the mutated statement has no effect any seed of the corpus can show, for a reason that is visible in the statement):
  dead reload   a register is reloaded from a frame local that the same register still holds (a callee clobbers ecx and edx, ebx/esi/edi/ebp are kept), so dropping the load changes nothing
  cleanup       the number of bytes a played callee pops after a call: functions that restore esp from ebp never show it
  frame         `ebp = esp` / `esp = ebp`: the frame register of a function that only uses it for its own locals
  local width   a narrower read of a frame local ([ebp +- n]) that holds a loop counter or a small constant, so the upper bytes are zero in every scenario
Everything else (a narrower read through a pointer, a changed literal, a changed register, a changed jump) is unexplained and the row stays pending.

  fl40_survivors.py <mutation log> [--out tasks/fl40-survivors.json]
"""
import json
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl40_mutation_check as M


def classify(kind, full):
    code = re.sub(r'\s*/\*.*', '', full).strip()
    if kind == 'literal' and 'FL40_CALL' in full:
        return 'cleanup'
    if kind == 'drop' and re.match(r'^[a-z]{3} = (RD\d+\(.*\)|\(uint32_t\)\(.*\));$', code):
        return 'dead reload'
    if kind == 'register' and (code.startswith('ebp = ') or code.startswith('esp = ')):
        return 'frame'
    if kind == 'width' and re.search(r'RD\d+\(\(uint32_t\)\(ebp \+ 0x[0-9a-f]+u\)\)', code) and 'WR' not in code.split('=')[0]:
        return 'local width'
    return None


def main():
    log = sys.argv[1]
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl40.c').read_text())
    out = {'rows_with_survivors': {}, 'unexplained_rows': []}
    for line in open(log):
        m = re.match(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)', line)
        if not m:
            continue
        text = funcs[m.group(1)].split('\n')
        items = []
        for kind, n, why in eval(m.group(2)):
            if why == 'survives':
                items.append((kind, classify(kind, text[n]), text[n].strip()[:160]))
        if items:
            out['rows_with_survivors'][m.group(1)] = items
            if any(c is None for _, c, _ in items):
                out['unexplained_rows'].append(m.group(1))
    out['unexplained_rows'].sort(key=lambda k: int(k, 16))
    if '--out' in sys.argv:
        Path(sys.argv[sys.argv.index('--out') + 1]).write_text(json.dumps(out, indent=1) + '\n')
    print('rows with a survivor %d, unexplained %d' % (len(out['rows_with_survivors']), len(out['unexplained_rows'])))


if __name__ == '__main__':
    main()
