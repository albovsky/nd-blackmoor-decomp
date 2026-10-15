#!/usr/bin/env python3
"""RT-22 mutation check: each deliberately broken rule of inventory_view_runtime.c must be
detected by tests/test_inventory_view_runtime.py (compiled separately, never the shipped library)."""
import os
from pathlib import Path
import subprocess
import sys
import tempfile

PROJECT = Path(__file__).resolve().parents[1]
SOURCE = (PROJECT / 'src/inventory_view_runtime.c').read_text()
MUTANTS = [
    ('hot margin x 11 -> 10', '#define HOT_MARGIN_X 11', '#define HOT_MARGIN_X 10'),
    ('hot margin y 10 -> 9', '#define HOT_MARGIN_Y 10', '#define HOT_MARGIN_Y 9'),
    ('right edge exclusive', 'if (px > layout->rect[slot][2]) return 0;', 'if (px >= layout->rect[slot][2]) return 0;'),
    ('event follows held inverted', 'held_item == -1 ? INVVIEW_EVENT_PICK : INVVIEW_EVENT_PUT',
     'held_item != -1 ? INVVIEW_EVENT_PICK : INVVIEW_EVENT_PUT'),
    ('hover scan continues after hit', 'return INVVIEW_OK;                        /* first hit ends the scan */',
     'continue;'),
    ('held not stored on pick up', '*inv->held_item = (int16_t)hot;               /* 0x4e941b: low word of the dword */',
     ''),
    ('pick up sound slot', 'sound(host, INVVIEW_SOUND_PICK, result)', 'sound(host, INVVIEW_SOUND_PUT, result)'),
    ('close flag ignored', 'if (layout->close_flag != 0) {', 'if (0) {'),
    ('aux check dropped in pick up', 'data->aux_a[hot] == 0u &&\n        *inv->held_item == -1', '*inv->held_item == -1'),
    ('put back keeps held', '*inv->held_item = -1;                         /* 0x4e9485 */', ''),
    ('put back sound slot', 'sound(host, INVVIEW_SOUND_PUT, result)', 'sound(host, INVVIEW_SOUND_PICK, result)'),
    ('read branch dropped', 'data->text[hot] != TEXT_NONE_NORMAL && data->aux_a[hot] == 0u', 'data->text[hot] != 0x7fff && data->aux_a[hot] == 7u'),
    ('frame consumed ignored in click', 'frame_consumed != 0) {\n        return INVVIEW_OK;\n    }\n    result->gate_open', 'frame_consumed == 99) {\n        return INVVIEW_OK;\n    }\n    result->gate_open'),
    ('open ignores state', 'if (view->screen_state != INVVIEW_STATE_NONE) {', 'if (0) {'),
    ('rebuild page offset', 'base = view->page * 16;', 'base = view->page * 16 + 1;'),
    ('relative origin ignored', 'const int32_t dx = out->relative != 0 ? origin_x : 0;', 'const int32_t dx = 0;'),
    ('restore held on rejection dropped', '*inv->held_item = old_held;           /* rejected before any effect */', ''),
]


def run(name, old, new, scratch):
    if old not in SOURCE:
        return 'NOT-APPLIED'
    source = scratch / 'inventory_view_runtime.c'
    source.write_text(SOURCE.replace(old, new, 1))
    src = PROJECT / 'src'
    library = scratch / 'lib.dylib'
    compile_ = subprocess.run(
        ['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11', '-O1', '-fPIC', '-dynamiclib',
         '-I', str(src), str(source), str(src / 'action_family_78_runtime.c'),
         str(src / 'action_family_79_runtime.c'), '-o', str(library)], capture_output=True, text=True)
    if compile_.returncode != 0:
        return 'COMPILE-ERROR'
    env = dict(os.environ, INVVIEW_RUNTIME_LIBRARY=str(library), A78_RUNTIME_LIBRARY=str(library))
    tests = subprocess.run([sys.executable, '-m', 'unittest', 'test_inventory_view_runtime'],
                           cwd=PROJECT / 'tests', env=env, capture_output=True, text=True)
    return 'killed' if tests.returncode != 0 else 'SURVIVED'


def main():
    results = {}
    with tempfile.TemporaryDirectory() as directory:
        for name, old, new in MUTANTS:
            results[name] = run(name, old, new, Path(directory))
            print(f'{results[name]:14s} {name}')
    killed = sum(1 for v in results.values() if v == 'killed')
    print(f'killed {killed}/{len(MUTANTS)}')
    return 0 if killed == len(MUTANTS) else 1


if __name__ == '__main__':
    raise SystemExit(main())
