#!/usr/bin/env python3
"""RT-22 follow-up mutation check: each deliberately broken rule of inventory_button_runtime.c
must be detected by tests/test_inventory_button_runtime.py (compiled separately, never the
shipped library)."""
import os
from pathlib import Path
import subprocess
import sys
import tempfile

PROJECT = Path(__file__).resolve().parents[1]
SOURCE = (PROJECT / 'src/inventory_button_runtime.c').read_text()
MUTANTS = [
    ('rect left uses top field', 'rd_i32(r + 0x96), top = rd_i32(r + 0x9a)', 'rd_i32(r + 0x9a), top = rd_i32(r + 0x96)'),
    ('origin applied without the relative flag', 'if (b->relative != 0) {', 'if (1) {'),
    ('origin ignored with the relative flag', 'b->rect[0] = (int32_t)((uint32_t)left + (uint32_t)origin_x);', 'b->rect[0] = left;'),
    ('no-sound name compare too short', 'memcmp(r + 0xbe, no_sound, TASKBAR_SOUND_NAME_BYTES) != 0', 'memcmp(r + 0xbe, no_sound, 2) != 0'),
    ('lock kind 1 ignored', 'if (lock->kind == 1) {                       /* 0x4e1919 */', 'if (0) {'),
    ('unlock without kind 2', 'state == TASKBAR_STATE_LOCKED && lock->kind == 2)', 'state == TASKBAR_STATE_LOCKED)'),
    ('lock range upper bound exclusive', 'scene_request <= lock->hi[k]', 'scene_request < lock->hi[k]'),
    ('lock range lower bound exclusive', 'scene_request >= lock->lo[k]', 'scene_request > lock->lo[k]'),
    ('hover bottom edge exclusive', 'y <= l->rect[3] && x >= l->rect[0]', 'y < l->rect[3] && x >= l->rect[0]'),
    ('hover right edge exclusive', 'x <= l->rect[2]) {', 'x < l->rect[2]) {'),
    ('hover top edge exclusive', 'y >= l->rect[1] && y <= l->rect[3]', 'y > l->rect[1] && y <= l->rect[3]'),
    ('pressed button may hover', 'b->state != TASKBAR_STATE_LOCKED) return 0;', 'b->state != TASKBAR_STATE_LOCKED && b->state != TASKBAR_STATE_PRESSED) return 0;'),
    ('locked hover changes state', 'l->hover_changes_state != 0 && b->state != TASKBAR_STATE_LOCKED', 'l->hover_changes_state != 0'),
    ('miss keeps hover state', 'if (b->state == TASKBAR_STATE_HOVER) b->state = TASKBAR_STATE_NORMAL;', ''),
    ('cursor flag ignored', 'if (l->cursor_flag != 0) {', 'if (0) {'),
    ('hover keeps scanning after a hit', 'bar->hover_id = layout->button[i].id;\n            break;', 'bar->hover_id = layout->button[i].id;'),
    ('bar cursor bounds right edge', 'pointer_rect[2] <= layout->bounds[2]', 'pointer_rect[2] < layout->bounds[2]'),
    ('hot point taken before the bar cursor', 'bar->cursor_index = TASKBAR_BAR_CURSOR_INDEX;       /* 0x4e07ab */', ''),
    ('hot point not added', 'result->x = (int32_t)((uint32_t)pointer_rect[0] + (uint32_t)dx);', 'result->x = pointer_rect[0];'),
    ('click works without a hover', 'if (b->hovered && !b->click_flag &&', 'if (!b->click_flag &&'),
    ('click ignores a pending flag', 'if (b->hovered && !b->click_flag &&', 'if (b->hovered &&'),
    ('click presses a locked button', '(b->state == TASKBAR_STATE_NORMAL || b->state == TASKBAR_STATE_HOVER)) {', '(b->state != TASKBAR_STATE_DISABLED)) {'),
    ('deadline without delay', 'b->deadline = now + l->delay_ms;', 'b->deadline = now;'),
    ('sound request skipped', 'if (host->request_sound(host->context, l->sound_name, l->sound_slot) != 0)', 'if (0)'),
    ('locked click not swallowed', 'if (b->hovered && b->state == TASKBAR_STATE_LOCKED) {', 'if (0) {'),
    ('deadline inclusive', 'if (!(now > b->deadline)) return TASKBAR_OK;', 'if (now < b->deadline) return TASKBAR_OK;'),
    ('busy sound ignored', 'if (busy != 0) return TASKBAR_OK;', ''),
    ('stage 0 completes immediately', 'if (b->stage == 0) { b->stage = 1; return TASKBAR_OK; }', 'b->stage = 1;'),
    ('completed button keeps the pressed state', 'b->state = TASKBAR_STATE_NORMAL;                                 /* 0x4e2b10 */', ''),
    ('flag not cleared before consuming', 'memset(bar->flag, 0, sizeof(bar->flag));                    /* 0x4e0ee1.. */', ''),
    ('consume keeps the click flag', 'bar->button[i].click_flag = 0;\n                bar->flag[i] = 1;', 'bar->flag[i] = 1;'),
    ('flag index shifted', 'bar->flag[i] = 1;', 'bar->flag[(i + 1) % TASKBAR_BUTTONS] = 1;'),
    ('first process call runs the buttons', 'if (bar->state == 0) {                                          /* 0x4e0e6b */\n        bar->state = 1;\n        result->loaded = 1;\n        return TASKBAR_OK;', 'if (bar->state == 0) {\n        bar->state = 1;\n        result->loaded = 1;'),
    ('hover runs while not started', 'if (bar->state != 1) return TASKBAR_OK;          /* 0x4e0767 */', ''),
    ('click runs while not started', 'if (bar->state != 1) return TASKBAR_OK;          /* 0x4e0994 */', ''),
    ('event not reset by the hover', 'bar->event = TASKBAR_EVENT_NONE;                 /* 0x4d308b */', ''),
]


def run(name, old, new, scratch):
    if old not in SOURCE:
        return 'NOT-APPLIED'
    source = scratch / 'inventory_button_runtime.c'
    source.write_text(SOURCE.replace(old, new, 1))
    src = PROJECT / 'src'
    library = scratch / 'lib.dylib'
    compile_ = subprocess.run(
        ['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11', '-O1', '-fPIC', '-dynamiclib',
         '-I', str(src), str(source), '-o', str(library)], capture_output=True, text=True)
    if compile_.returncode != 0:
        return 'COMPILE-ERROR'
    env = dict(os.environ, INVBUTTON_RUNTIME_LIBRARY=str(library))
    tests = subprocess.run([sys.executable, '-m', 'unittest', 'test_inventory_button_runtime'],
                           cwd=PROJECT / 'tests', env=env, capture_output=True, text=True)
    return 'killed' if tests.returncode != 0 else 'SURVIVED'


def main():
    results = {}
    with tempfile.TemporaryDirectory() as directory:
        for name, old, new in MUTANTS:
            results[name] = run(name, old, new, Path(directory))
            print(f'{results[name]:14s} {name}')
    bad = [n for n, r in results.items() if r != 'killed']
    print(f'{len(results) - len(bad)}/{len(results)} mutants killed')
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
