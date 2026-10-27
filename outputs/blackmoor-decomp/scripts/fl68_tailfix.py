#!/usr/bin/env python3
"""FL-68: make the tail jumps of FL-57 rows leave with esp at the function's own return address.

A `jmp`/`jcc` to another function (or `jmp reg`) is translated as `FL41_CALL(target); esp += N; goto done;`. When the function has pushed words of its own before the jump (`push edx; fnstcw [esp]; ... jmp
0x513ccb`, the x87 math wrappers), the target is entered with those words on top and pops them itself before it returns: its return address is the one at the function's entry esp. The world plays such
a jump that way (tests/fl41_world.py `jump_out`: the stub returns to the word at the entry esp), so the translation must leave with `esp = esp0_ + N` (N = 4 + the bytes the target pops) and hand the host
the call at the entry esp. This patches the listed rows in place (no re-translation: the rest of each row keeps its text):

  fl68_tailfix.py ROW [ROW ...] [--write]
"""
import argparse
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
FILES = [PROJECT / 'translated/original_methods_fl57_translated.c', PROJECT / 'translated/original_methods_fl41_translated.c']
TAIL = re.compile(r'FL41_CALL\(([^)]*)\); esp \+= (\d+)u; goto done;')


def patch_row(text):
    if 'esp0_' in text:
        return text
    new = TAIL.sub(lambda m: 'esp = esp0_; FL41_CALL(%s); esp = esp0_ + %su; goto done;' % (m.group(1), m.group(2)), text)
    if new == text:
        return text
    return new.replace('    FL41_PROLOGUE\n', '    FL41_PROLOGUE\n    uint32_t esp0_ = esp;\n', 1)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--write', action='store_true')
    a = ap.parse_args()
    for f in FILES:
        src = f.read_text()
        changed = 0
        for key in a.rows:
            m = re.search(r'^/\* GAME\.EXE %s \(.*?(?=^/\* GAME\.EXE 0x|\Z)' % re.escape(key), src, re.M | re.S)
            if m is None:
                continue
            new = patch_row(m.group(0))
            if new != m.group(0):
                changed += 1
                print(f.name, key, 'patched')
                src = src[:m.start()] + new + src[m.end():]
        if a.write and changed:
            f.write_text(src)


if __name__ == '__main__':
    main()
