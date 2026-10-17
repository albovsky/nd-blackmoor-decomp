"""RT-50: raw 0xd0 Piano Puzzle runtime (src/action_family_d0_runtime.c) and its session binding (src/session_bindings_ad0.c).

Facts under test (original GAME.EXE, read from the disassembly of 0x48d914, 0x48d1e8, 0x48d3cb, 0x48d5f4, 0x48d89e, 0x48ded7,
0x48d0e5, 0x48d09c and 0x42ba3a):
 * phase 0 starts the puzzle (active flag, [0x5bb1ca] := 1, the first 15 bytes of the order array cleared, the pending item
   committed, and with a surface name a generic z entry, the CIFTREE image and the entry surface), and ends in phase 1 / state 1;
 * phase 1 is a five-state machine on obj+0x2b: release a pressed key at its 500 ms deadline, idle (the solved check runs here
   only when the body has no surface), arm the win delay, wait for it and start the win sound (or end), wait for the win sound
   and end; the end asks for phase 2;
 * phase 2 applies the exit block (exit asked) or the solved block, then the generic completion 0x42ba3a and the cleanup;
 * the pointer hit-tests the exit rectangle (only while no key is pressed) and then the keys (inclusive), or redraws the pressed
   key; the click shifts the last-L window, copies the key sound over record C, plays it and shows the key text; the render
   callback blits the pressed key or restores the background and runs the solved check.
The unit cases live in tests/action_family_d0_runtime_test.c (synthetic bodies, no original bytes). The original-x86 oracle is a
separate script (needs the private work/ evidence and Unicorn).
"""
import concurrent.futures
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/action_family_d0_runtime_test.c'
KERNEL = 'action_family_d0_runtime.c'
BINDING = 'session_bindings_ad0.c'
SOURCES = [KERNEL, BINDING, 'scene_resource.c', 'hiff.c']
EXPECTED_UNIT_TESTS = 35


def compiler():
    # The repo scripts call `xcrun clang` for macOS; where xcrun is absent (cloud container) use clang, cc or gcc.
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')


SANITIZE = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined']


def compile_c(output, main_c, sources, src_dir=SRC, extra=(), optimize='-O1', cc=None):
    cmd = [cc or compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', optimize, '-g',
           f'-I{src_dir}', *extra, str(main_c), *[str(Path(src_dir) / s) for s in sources],
           '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


def run_unit(binary):
    done = subprocess.run([str(binary)], capture_output=True, text=True)
    results = {}
    for line in done.stdout.splitlines():
        status, _, rest = line.partition(' ')
        if status in ('PASS', 'FAIL'):
            name, _, message = rest.partition(': ')
            results[name] = (status, message)
    return done.returncode, results


# Each mutant breaks one recovered rule; the unit cases must fail on every one of them. Anchors are unique source fragments.
MUTANTS = {
    KERNEL: {
        # --- body validation ---------------------------------------------------------------------------------------------
        'validate accepts a longer body': ('length != D0_BODY_BYTES', 'length < D0_BODY_BYTES'),
        'validate accepts a shorter body': ('length != D0_BODY_BYTES', 'length > D0_BODY_BYTES'),
        'validate name check one byte short': ('memchr(body, 0, D0_NAME_BYTES) == NULL', 'memchr(body, 0, D0_NAME_BYTES - 1u) == NULL'),
        'validate name check one byte long': ('memchr(body, 0, D0_NAME_BYTES) == NULL', 'memchr(body, 0, D0_NAME_BYTES + 1u) == NULL'),
        'validate key count 0 refused': ('(n = rd_s16(body, B_COUNT)) < 0', '(n = rd_s16(body, B_COUNT)) < 1'),
        'validate key count 16 accepted': ('n > D0_MAX_KEYS)', 'n > D0_MAX_KEYS + 1)'),
        'validate key count 15 refused': ('n > D0_MAX_KEYS)', 'n >= D0_MAX_KEYS)'),
        'validate key count unsigned': ('(n = rd_s16(body, B_COUNT)) < 0', '(n = rd_s16(body, B_COUNT)) < -32768'),
        'validate solution length 0 accepted': ('(l = rd_s16(body, B_SOLUTION_LEN)) < 1', '(l = rd_s16(body, B_SOLUTION_LEN)) < 0'),
        'validate solution length 16 accepted': ('l > D0_MAX_KEYS) {', 'l > D0_MAX_KEYS + 1) {'),
        'validate solution length 15 refused': ('l > D0_MAX_KEYS) {', 'l >= D0_MAX_KEYS) {'),
        'validate checks one key too many': ('i < n && why == NULL', 'i <= n && why == NULL'),
        'validate checks one key too few': ('i < n && why == NULL', 'i < n - 1 && why == NULL'),
        'validate sound name one byte short': ('memchr(rec, 0, KEY_TEXT) == NULL', 'memchr(rec, 0, KEY_TEXT - 1) == NULL'),
        'validate text key one byte short': ('memchr(rec + KEY_TEXT, 0, KEY_TEXT) == NULL', 'memchr(rec + KEY_TEXT, 0, KEY_TEXT - 1) == NULL'),
        'validate text key checks the sound again': ('memchr(rec + KEY_TEXT, 0, KEY_TEXT) == NULL', 'memchr(rec, 0, KEY_TEXT) == NULL'),
        'validate sound name unchecked': ('memchr(rec, 0, KEY_TEXT) == NULL)\n                why = "0xd0-key-sound-unterminated";', '0)\n                why = "0xd0-key-sound-unterminated";'),
        'validate failure text lost': ('if (failure != NULL) *failure = why;\n    return why == NULL', 'return why == NULL'),
        'validate stride': ('body + B_KEYS + (size_t)i * KEY_STRIDE', 'body + B_KEYS + (size_t)i * 0x21u'),
        # --- the solved check --------------------------------------------------------------------------------------------
        'solved needs one key less': ('if (i >= l) {', 'if (i >= l - 1) {'),
        'solved needs one key more': ('if (i >= l) {', 'if (i > l) {'),
        'solved compares the first key only': ('while (i < l && o->order[i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)) ++i;', 'while (i < 1 && o->order[i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)) ++i;\n    if (i == 1) i = l;'),
        'solved compares unequal': ('o->order[i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)) ++i;', 'o->order[i] != rd_s16(body, B_SOLUTION + (size_t)i * 2u)) ++i;'),
        'solved solution stride': ('B_SOLUTION + (size_t)i * 2u)) ++i;', 'B_SOLUTION + (size_t)i * 1u)) ++i;'),
        'solved window offset': ('o->order[i] == rd_s16', 'o->order[i + 1] == rd_s16'),
        'solved state not moved': ('o->state = D0_STATE_START_WIN;\n        fx(host, D0_FX_STATE, o->state, 0);\n        o->solved = 1;', 'o->solved = 1;'),
        'solved state wrong': ('o->state = D0_STATE_START_WIN;\n        fx(host, D0_FX_STATE, o->state, 0);\n        o->solved = 1;', 'o->state = D0_STATE_WAIT_WIN;\n        fx(host, D0_FX_STATE, o->state, 0);\n        o->solved = 1;'),
        'solved flag not set': ('fx(host, D0_FX_STATE, o->state, 0);\n        o->solved = 1;', 'fx(host, D0_FX_STATE, o->state, 0);'),
        'solved check not announced': ('fx(host, D0_FX_SOLVED_CHECK, 0, 0);', '(void)0;'),
        # --- finish blocks -----------------------------------------------------------------------------------------------
        'block scene test inverted': ('if (rd_s16(blk, SB_SCENE) != D0_NO_SCENE) {', 'if (rd_s16(blk, SB_SCENE) == D0_NO_SCENE) {'),
        'block scene unsigned': ('t.scene = rd_s16(blk, SB_SCENE);', 't.scene = (int16_t)(uint16_t)(rd_s16(blk, SB_SCENE) & 0x7fff);'),
        'block word 1 from word 2': ('t.word[0] = rd_s16(blk, SB_W1);', 't.word[0] = rd_s16(blk, SB_W2);'),
        'block word 2 from word 3': ('t.word[1] = rd_s16(blk, SB_W2);', 't.word[1] = rd_s16(blk, SB_W3);'),
        'block word 3 from word 1': ('t.word[2] = rd_s16(blk, SB_W3);', 't.word[2] = rd_s16(blk, SB_W1);'),
        'block dword 1 from dword 2': ('t.dword[0] = rd_s32(blk, SB_D1);', 't.dword[0] = rd_s32(blk, SB_D2);'),
        'block dword 2 from dword 3': ('t.dword[1] = rd_s32(blk, SB_D2);', 't.dword[1] = rd_s32(blk, SB_D3);'),
        'block dword 3 from dword 1': ('t.dword[2] = rd_s32(blk, SB_D3);', 't.dword[2] = rd_s32(blk, SB_D1);'),
        'block transition failure ignored': ('HOST(host->transition(host->context, &t));', '(void)host->transition(host->context, &t);'),
        'block start flag stores 1 for 1': ('world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) == 1 ? 1 : 0;'),
        'block start flag stores 0 for 0': ('world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 0 ? 1 : 0;'),
        'block start flag from the wrong word': ('rd_s16(blk, SB_START) != 1', 'rd_s16(blk, SB_FLAG) != 1'),
        'block engine mode not announced': ('fx(host, D0_FX_ENGINE_MODE, 4, 0);', '(void)0;'),
        'block flag 0 is none': ('if (flag != D0_NO_FLAG) {', 'if (flag > 0) {'),
        'block flag -1 is a flag': ('if (flag != D0_NO_FLAG) {', 'if (1) {'),
        'block flag value wrong': ('store_event_flag(host->context, flag, blk[SB_VALUE])', 'store_event_flag(host->context, flag, blk[SB_VALUE] + 1u)'),
        'block flag value signed': ('store_event_flag(host->context, flag, blk[SB_VALUE])', 'store_event_flag(host->context, flag, (uint32_t)(int8_t)blk[SB_VALUE])'),
        'block flag store failure ignored': ('HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE]));', '(void)host->store_event_flag(host->context, flag, blk[SB_VALUE]);'),
        # --- phase 0 -----------------------------------------------------------------------------------------------------
        'phase 0 row not stored': ('o->row = row;\n    o->active = 1;', 'o->active = 1;'),
        'phase 0 not active': ('o->active = 1;\n    fx(host, D0_FX_ACTIVE, 1, 0);', 'fx(host, D0_FX_ACTIVE, 1, 0);'),
        'phase 0 pressed kept': ('o->pressed = 0;\n    o->check = 0;\n    o->dirty = 0;\n    o->surface = 0u;', 'o->check = 0;\n    o->dirty = 0;\n    o->surface = 0u;'),
        'phase 0 check kept': ('o->pressed = 0;\n    o->check = 0;\n    o->dirty = 0;\n    o->surface = 0u;', 'o->pressed = 0;\n    o->dirty = 0;\n    o->surface = 0u;'),
        'phase 0 dirty kept': ('o->pressed = 0;\n    o->check = 0;\n    o->dirty = 0;\n    o->surface = 0u;', 'o->pressed = 0;\n    o->check = 0;\n    o->surface = 0u;'),
        'phase 0 surface kept': ('o->dirty = 0;\n    o->surface = 0u;', 'o->dirty = 0;'),
        'phase 0 start flag not set': ('world->start_flag_5bb1ca = 1;\n    fx(host, D0_FX_START_FLAG, 1, 0);\n    HOST(host->clear_pending_item', 'HOST(host->clear_pending_item'),
        'phase 0 item not cleared': ('HOST(host->clear_pending_item(host->context));', '(void)0;'),
        'phase 0 order clears six words': ('for (int k = 0; k < 7; ++k) o->order[k] = 0;', 'for (int k = 0; k < 6; ++k) o->order[k] = 0;'),
        'phase 0 order clears eight words': ('for (int k = 0; k < 7; ++k) o->order[k] = 0;', 'for (int k = 0; k < 8; ++k) o->order[k] = 0;'),
        'phase 0 order clears the whole array': ('for (int k = 0; k < 7; ++k) o->order[k] = 0;', 'for (int k = 0; k < D0_MAX_KEYS; ++k) o->order[k] = 0;'),
        'phase 0 order byte not cleared': ('o->order[7] = (int16_t)(o->order[7] & (int16_t)0xff00);', '(void)0;'),
        'phase 0 order byte clears the word': ('o->order[7] = (int16_t)(o->order[7] & (int16_t)0xff00);', 'o->order[7] = 0;'),
        'phase 0 order byte clears the high byte': ('o->order[7] = (int16_t)(o->order[7] & (int16_t)0xff00);', 'o->order[7] = (int16_t)(o->order[7] & (int16_t)0x00ff);'),
        'phase 0 exit kept': ('o->exit_taken = 0;\n    o->solved = 0;\n    if (body[0] == 0) {', 'o->solved = 0;\n    if (body[0] == 0) {'),
        'phase 0 solved kept': ('o->exit_taken = 0;\n    o->solved = 0;\n    if (body[0] == 0) {', 'o->exit_taken = 0;\n    if (body[0] == 0) {'),
        'phase 0 empty name test inverted': ('if (body[0] == 0) {\n        o->has_surface = 0;', 'if (body[0] != 0) {\n        o->has_surface = 0;'),
        'phase 0 surface flag lost': ('o->has_surface = 1;\n        HOST(host->alloc_slot', 'HOST(host->alloc_slot'),
        'phase 0 slot not stored': ('o->slot = slot;\n        fx(host, D0_FX_SLOT, slot, 0);', 'fx(host, D0_FX_SLOT, slot, 0);'),
        'phase 0 label wrong': ('"PIANO PUZZLE OVERLAYS"));', '"PIANO PUZZLE"));'),
        'phase 0 loads the wrong name': ('host->load_surface(host->context, (const char *)body, &surface)', 'host->load_surface(host->context, (const char *)body + 1, &surface)'),
        'phase 0 surface not stored': ('o->surface = surface;\n            fx(host, D0_FX_SURFACE_LOAD', 'fx(host, D0_FX_SURFACE_LOAD'),
        'phase 0 slot surface wrong': ('host->set_slot_surface(host->context, slot, o->surface)', 'host->set_slot_surface(host->context, slot, 0u)'),
        'phase 0 state not idle': ('o->state = D0_STATE_IDLE;\n    fx(host, D0_FX_STATE, o->state, 0);\n    return D0_OK;', 'o->state = D0_STATE_RELEASE;\n    fx(host, D0_FX_STATE, o->state, 0);\n    return D0_OK;'),
        'phase 0 register failure ignored': ('HOST(host->register_slot(host->context, slot, "PIANO PUZZLE OVERLAYS"));', '(void)host->register_slot(host->context, slot, "PIANO PUZZLE OVERLAYS");'),
        'phase 0 alloc failure ignored': ('HOST(host->alloc_slot(host->context, &slot));', '(void)host->alloc_slot(host->context, &slot);'),
        'phase 0 load failure ignored': ('HOST(host->load_surface(host->context, (const char *)body, &surface));', '(void)host->load_surface(host->context, (const char *)body, &surface);'),
        'phase 0 slot surface failure ignored': ('HOST(host->set_slot_surface(host->context, slot, o->surface));', '(void)host->set_slot_surface(host->context, slot, o->surface);'),
        'phase 0 clear failure ignored': ('HOST(host->clear_pending_item(host->context));', '(void)host->clear_pending_item(host->context);'),
        # --- phase 1 -----------------------------------------------------------------------------------------------------
        'release waits one tick too long': ('if (now >= o->deadline) {\n            HOST(host->sound_stop', 'if (now > o->deadline) {\n            HOST(host->sound_stop'),
        'release one tick early': ('if (now >= o->deadline) {\n            HOST(host->sound_stop', 'if (now + 1u >= o->deadline) {\n            HOST(host->sound_stop'),
        'release stops the win sound': ('host->sound_stop(host->context, body + B_KEY_SOUND)', 'host->sound_stop(host->context, body + B_WIN_SOUND)'),
        'release state not idle': ('o->state = D0_STATE_IDLE;\n            fx(host, D0_FX_STATE, o->state, 0);\n            o->dirty = 1;', 'o->dirty = 1;'),
        'release dirty lost': ('o->dirty = 1;\n            o->check = 1;\n            o->pressed = 0;', 'o->check = 1;\n            o->pressed = 0;'),
        'release check lost': ('o->check = 1;\n            o->pressed = 0;', 'o->pressed = 0;'),
        'release pressed kept': ('o->check = 1;\n            o->pressed = 0;', 'o->check = 1;'),
        'release stop failure ignored': ('HOST(host->sound_stop(host->context, body + B_KEY_SOUND));', '(void)host->sound_stop(host->context, body + B_KEY_SOUND);'),
        'idle check with a surface': ('if (o->has_surface == 0) solved_check(o, body, host);', 'solved_check(o, body, host);'),
        'idle check never': ('if (o->has_surface == 0) solved_check(o, body, host);', '(void)0;'),
        'idle check inverted': ('if (o->has_surface == 0) solved_check(o, body, host);', 'if (o->has_surface != 0) solved_check(o, body, host);'),
        'delay in tenths': ('(uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000)', '(uint32_t)((int32_t)rd_s16(body, B_DELAY) * 100)'),
        'delay unsigned': ('(uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000)', '(uint32_t)((int32_t)(uint16_t)rd_s16(body, B_DELAY) * 1000)'),
        'delay from the wrong offset': ('rd_s16(body, B_DELAY)', 'rd_s16(body, B_DELAY - 1)'),
        'delay not added to now': ('o->deadline = now + (uint32_t)', 'o->deadline = 0u + (uint32_t)'),
        'delay state wrong': ('o->state = D0_STATE_WAIT_WIN;\n        fx(host, D0_FX_STATE, o->state, 0);\n        break;', 'o->state = D0_STATE_WIN_SOUND;\n        fx(host, D0_FX_STATE, o->state, 0);\n        break;'),
        'win wait one tick too long': ('if (now >= o->deadline) {\n            if (!no_sound', 'if (now > o->deadline) {\n            if (!no_sound'),
        'win wait one tick early': ('if (now >= o->deadline) {\n            if (!no_sound', 'if (now + 1u >= o->deadline) {\n            if (!no_sound'),
        'win sound test inverted': ('if (!no_sound(body + B_WIN_SOUND)) {', 'if (no_sound(body + B_WIN_SOUND)) {'),
        'win sound always': ('if (!no_sound(body + B_WIN_SOUND)) {', 'if (1) {'),
        'win sound never': ('if (!no_sound(body + B_WIN_SOUND)) {', 'if (0) {'),
        'win sound channel from the key channel': ('const int16_t ch = rd_s16(body, B_WIN_CHANNEL);\n                HOST(host->sound_prepare', 'const int16_t ch = rd_s16(body, B_KEY_CHANNEL);\n                HOST(host->sound_prepare'),
        'win sound prepares the key record': ('host->sound_prepare(host->context, body + B_WIN_SOUND)', 'host->sound_prepare(host->context, body + B_KEY_SOUND)'),
        'win sound state wrong': ('o->state = D0_STATE_WIN_SOUND;\n                fx(host, D0_FX_STATE, o->state, 0);', 'o->state = D0_STATE_IDLE;\n                fx(host, D0_FX_STATE, o->state, 0);'),
        'win sound prepare failure ignored': ('HOST(host->sound_prepare(host->context, body + B_WIN_SOUND));', '(void)host->sound_prepare(host->context, body + B_WIN_SOUND);'),
        'win sound play failure ignored': ('HOST(host->sound_play(host->context, ch));\n                fx(host, D0_FX_SOUND_PLAY, ch, 0);\n                o->state', '(void)host->sound_play(host->context, ch);\n                fx(host, D0_FX_SOUND_PLAY, ch, 0);\n                o->state'),
        'no win sound keeps waiting': ('} else {\n                *row_phase = 2u;', '} else {\n                *row_phase = 1u;'),
        'win busy channel wrong': ('const int16_t ch = rd_s16(body, B_WIN_CHANNEL);\n        int32_t busy = 0;', 'const int16_t ch = rd_s16(body, B_KEY_CHANNEL);\n        int32_t busy = 0;'),
        'win busy test inverted': ('if (busy == 0) {\n            HOST(host->sound_stop(host->context, body + B_WIN_SOUND));', 'if (busy != 0) {\n            HOST(host->sound_stop(host->context, body + B_WIN_SOUND));'),
        'win busy stops the key record': ('host->sound_stop(host->context, body + B_WIN_SOUND));\n            fx(host, D0_FX_SOUND_STOP, B_WIN_SOUND', 'host->sound_stop(host->context, body + B_KEY_SOUND));\n            fx(host, D0_FX_SOUND_STOP, B_WIN_SOUND'),
        'win busy phase not asked': ('fx(host, D0_FX_SOUND_STOP, B_WIN_SOUND, 0);\n            *row_phase = 2u;', 'fx(host, D0_FX_SOUND_STOP, B_WIN_SOUND, 0);'),
        'win busy failure ignored': ('HOST(host->sound_busy(host->context, ch, &busy));\n        fx(host, D0_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST', '(void)host->sound_busy(host->context, ch, &busy);\n        fx(host, D0_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST'),
        'win busy stop failure ignored': ('HOST(host->sound_stop(host->context, body + B_WIN_SOUND));\n            fx(host, D0_FX_SOUND_STOP, B_WIN_SOUND, 0);\n            *row_phase', '(void)host->sound_stop(host->context, body + B_WIN_SOUND);\n            fx(host, D0_FX_SOUND_STOP, B_WIN_SOUND, 0);\n            *row_phase'),
        # --- phase 2 and the visit ---------------------------------------------------------------------------------------
        'phase 2 start flag not set': ('world->start_flag_5bb1ca = 1;\n    fx(host, D0_FX_START_FLAG, 1, 0);\n    if (o->exit_taken', 'if (o->exit_taken'),
        'phase 2 solved before exit': ('if (o->exit_taken != 0) return apply_block(body + B_EXIT, world, host);\n    if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);', 'if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);\n    if (o->exit_taken != 0) return apply_block(body + B_EXIT, world, host);'),
        'phase 2 exit ignored': ('if (o->exit_taken != 0) return apply_block(body + B_EXIT, world, host);', '(void)0;'),
        'phase 2 solved ignored': ('if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);', '(void)0;'),
        'phase 2 always applies the solved block': ('if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);', 'return apply_block(body + B_SOLVED, world, host);'),
        'step phase 0 row 0 refused': ('if (row < 0) {', 'if (row <= 0) {'),
        'step negative row accepted': ('if (row < 0) {', 'if (0) {'),
        'step phase 1 without active': ('if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xd0-phase-1-without-init";', 'if (object->row != row) {\n            if (failure != NULL) *failure = "0xd0-phase-1-without-init";'),
        'step phase 1 any row': ('if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xd0-phase-1-without-init";', 'if (object->active == 0) {\n            if (failure != NULL) *failure = "0xd0-phase-1-without-init";'),
        'step phase 2 without active': ('if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xd0-phase-2-without-init";', 'if (object->row != row) {\n            if (failure != NULL) *failure = "0xd0-phase-2-without-init";'),
        'step phase 2 any row': ('if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xd0-phase-2-without-init";', 'if (object->active == 0) {\n            if (failure != NULL) *failure = "0xd0-phase-2-without-init";'),
        'step flag precheck skipped': ('if (flag != D0_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (0) {'),
        'step flag precheck on none': ('if (flag != D0_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (host->event_flag_invalid(host->context, flag) != 0) {'),
        'step flag precheck always': ('if (flag != D0_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (flag != D0_NO_FLAG) {'),
        'step flag precheck solved block first': ('object->exit_taken != 0 ? body + B_EXIT : (object->solved != 0 ? body + B_SOLVED : NULL)', 'object->solved != 0 ? body + B_SOLVED : (object->exit_taken != 0 ? body + B_EXIT : NULL)'),
        'step flag precheck wrong text': ('"0xd0-event-flag-index"', '"0xd0-flag"'),
        'step completion not reported': ('result->completed = 1u;', '(void)0;'),
        'step completion phase kept': ('row_phase = 0u; /* 0x42ba3a stores phase 0 */', '(void)0;'),
        'step no cleanup after the finish': ('rc = d0_cleanup(object, host);', '(void)0;'),
        'step completion not announced': ('fx(host, D0_FX_COMPLETE, row, 0);', '(void)0;'),
        'step phase 1 announced': ('fx(host, D0_FX_PHASE, 1, 0);\n            result->initialized = 1u;', 'result->initialized = 1u;'),
        'step initialisation not reported': ('result->initialized = 1u;', '(void)0;'),
        'step phase 0 not advanced': ('row_phase = 1u;\n            fx(host, D0_FX_PHASE, 1, 0);', 'fx(host, D0_FX_PHASE, 1, 0);'),
        'step host failure text lost': ('if (rc != D0_OK && failure != NULL && *failure == NULL) *failure = "0xd0-host";', '(void)0;'),
        'step phase after lost': ('result->phase_after = row_phase;\n    return rc;', 'return rc;'),
        'step other phases act as phase 1': ('} else {\n        rc = D0_OK; /* 0x48d95f: any other phase falls out of the switch */', '} else if (object->active != 0 && object->row == row) {\n        rc = phase1(object, body, &row_phase, host);\n    } else {\n        rc = D0_OK; /* 0x48d95f: any other phase falls out of the switch */'),
        'step host check lost': ('host->mark_dirty != NULL && host->view_origin != NULL', 'host->view_origin != NULL'),
        'step body validation lost': ('if (d0_validate_body(body, body_length, &why) != D0_OK) {\n        if (failure != NULL) *failure = why;', 'if (0) {\n        if (failure != NULL) *failure = why;'),
    },
}
MUTANTS[KERNEL].update({
        # --- pointer -----------------------------------------------------------------------------------------------------
        'rect top exclusive': ('return rd_s32(body, rect + 4) <= y &&', 'return rd_s32(body, rect + 4) < y &&'),
        'rect bottom exclusive': ('y <= rd_s32(body, rect + 12) &&', 'y < rd_s32(body, rect + 12) &&'),
        'rect left exclusive': ('rd_s32(body, rect) <= x &&', 'rd_s32(body, rect) < x &&'),
        'rect right exclusive': ('x <= rd_s32(body, rect + 8);', 'x < rd_s32(body, rect + 8);'),
        'rect right edge wrong offset': ('x <= rd_s32(body, rect + 8);', 'x <= rd_s32(body, rect + 12);'),
        'rect top edge wrong offset': ('rd_s32(body, rect + 4) <= y &&', 'rd_s32(body, rect) <= y &&'),
        'cursor writer marks no redraw': ('out->candidate = candidate;\n    o->dirty = 1;', 'out->candidate = candidate;'),
        'cursor writer candidate lost': ('out->candidate = candidate;\n    o->dirty = 1;', 'o->dirty = 1;'),
        'cursor writer sub wrong': ('out->cursor_sub = 1;', 'out->cursor_sub = 0;'),
        'cursor writer not flagged': ('out->cursor_written = 1u;\n    out->cursor_sub', 'out->cursor_sub'),
        'cursor writer exit kind wrong': ('out->cursor_kind = D0_CURSOR_EXIT;', 'out->cursor_kind = 0;'),
        'cursor writer exit keeps the hover': ('out->cursor_kind = D0_CURSOR_EXIT;\n        o->hover = -1;', 'out->cursor_kind = D0_CURSOR_EXIT;'),
        'cursor writer hover while pressed': ('if (o->pressed == 0) o->hover = key;', 'o->hover = key;'),
        'cursor writer hover never': ('if (o->pressed == 0) o->hover = key;', '(void)0;'),
        'cursor writer hover inverted': ('if (o->pressed == 0) o->hover = key;', 'if (o->pressed != 0) o->hover = key;'),
        'cursor region A top': ('if (top >= rd_s32(body, B_REGION_A + 4) &&', 'if (top > rd_s32(body, B_REGION_A + 4) &&'),
        'cursor region A bottom': ('bottom <= rd_s32(body, B_REGION_A + 12) &&', 'bottom < rd_s32(body, B_REGION_A + 12) &&'),
        'cursor region A left': ('left >= rd_s32(body, B_REGION_A) &&', 'left > rd_s32(body, B_REGION_A) &&'),
        'cursor region A right': ('right <= rd_s32(body, B_REGION_A + 8))', 'right < rd_s32(body, B_REGION_A + 8))'),
        'cursor region A kind': ('out->cursor_kind = rd_s16(body, B_KIND_A);', 'out->cursor_kind = rd_s16(body, B_KIND_B);'),
        'cursor region B top': ('else if (top >= rd_s32(body, B_REGION_B + 4) &&', 'else if (top > rd_s32(body, B_REGION_B + 4) &&'),
        'cursor region B bottom': ('bottom <= rd_s32(body, B_REGION_B + 12) &&', 'bottom < rd_s32(body, B_REGION_B + 12) &&'),
        'cursor region B left': ('left >= rd_s32(body, B_REGION_B) &&', 'left > rd_s32(body, B_REGION_B) &&'),
        'cursor region B right': ('right <= rd_s32(body, B_REGION_B + 8))', 'right < rd_s32(body, B_REGION_B + 8))'),
        'cursor region B kind': ('out->cursor_kind = rd_s16(body, B_KIND_B);', 'out->cursor_kind = rd_s16(body, B_KIND_A);'),
        'cursor region none is kind A': ('else\n            out->cursor_kind = 0;', 'else\n            out->cursor_kind = rd_s16(body, B_KIND_A);'),
        'cursor hit rectangle stride': ('const size_t h = B_HIT + (size_t)key * 16u;', 'const size_t h = B_HIT + (size_t)key * 8u;'),
        'pointer inactive acts': ('if (object->active == 0) return D0_OK;', '(void)0;'),
        'pointer hot spot not truncated': ('x = (int16_t)x; /* movsx word */\n    y = (int16_t)y;', '(void)0;'),
        'pointer y not truncated': ('y = (int16_t)y;', '(void)0;'),
        'pointer exit while pressed': ('if (object->pressed == 0 && in_rect(body, B_EXIT_RECT, x, y)) {', 'if (in_rect(body, B_EXIT_RECT, x, y)) {'),
        'pointer exit never': ('if (object->pressed == 0 && in_rect(body, B_EXIT_RECT, x, y)) {', 'if (0) {'),
        'pointer exit inverted': ('if (object->pressed == 0 && in_rect(body, B_EXIT_RECT, x, y)) {', 'if (object->pressed != 0 && in_rect(body, B_EXIT_RECT, x, y)) {'),
        'pointer exit candidate wrong': ('cursor_write(object, body, D0_CANDIDATE_EXIT, 0, out);', 'cursor_write(object, body, D0_CANDIDATE_KEY, 0, out);'),
        'pointer exit does not claim': ('cursor_write(object, body, D0_CANDIDATE_EXIT, 0, out);\n        out->hit = 1u;', 'cursor_write(object, body, D0_CANDIDATE_EXIT, 0, out);'),
        'pointer key candidate wrong': ('cursor_write(object, body, D0_CANDIDATE_KEY, i, out);', 'cursor_write(object, body, D0_CANDIDATE_EXIT, i, out);'),
        'pointer key does not claim': ('cursor_write(object, body, D0_CANDIDATE_KEY, i, out);\n            out->hit = 1u;', 'cursor_write(object, body, D0_CANDIDATE_KEY, i, out);'),
        'pointer key hit rectangle stride': ('if (in_rect(body, B_HIT + (size_t)i * 16u, x, y)) {', 'if (in_rect(body, B_HIT + (size_t)i * 8u, x, y)) {'),
        'pointer key scan one key short': ('for (int16_t i = 0; i < n; ++i) {\n        if (in_rect(body, B_HIT', 'for (int16_t i = 0; i < n - 1; ++i) {\n        if (in_rect(body, B_HIT'),
        'pointer key scan one key long': ('for (int16_t i = 0; i < n; ++i) {\n        if (in_rect(body, B_HIT', 'for (int16_t i = 0; i <= n; ++i) {\n        if (in_rect(body, B_HIT'),
        'pointer redraw without a pressed key': ('if (object->pressed != 0) {\n        for (int16_t i = 0; i < n; ++i) {', 'if (1) {\n        for (int16_t i = 0; i < n; ++i) {'),
        'pointer redraw never': ('if (object->pressed != 0) {\n        for (int16_t i = 0; i < n; ++i) {', 'if (0) {\n        for (int16_t i = 0; i < n; ++i) {'),
        'pointer redraw of any key': ('in_rect(body, B_KEYRECT + (size_t)i * 16u, x, y) && i == object->hover', 'in_rect(body, B_KEYRECT + (size_t)i * 16u, x, y)'),
        'pointer redraw of the wrong rectangle': ('in_rect(body, B_KEYRECT + (size_t)i * 16u, x, y) && i == object->hover', 'in_rect(body, B_HIT + (size_t)i * 16u, x, y) && i == object->hover'),
        'pointer redraw stops at the first rectangle': ('if (in_rect(body, B_KEYRECT + (size_t)i * 16u, x, y) && i == object->hover) {\n                object->dirty = 1;\n                return D0_OK;\n            }', 'if (in_rect(body, B_KEYRECT + (size_t)i * 16u, x, y)) {\n                if (i == object->hover) object->dirty = 1;\n                return D0_OK;\n            }'),
        'pointer redraw not requested': ('object->dirty = 1;\n                return D0_OK;', 'return D0_OK;'),
        'pointer result not cleared': ('memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (object->active == 0)', 'out->candidate = -1;\n    if (object->active == 0)'),
        'pointer candidate default': ('out->candidate = -1;\n    if (object->active == 0)', 'out->candidate = 0;\n    if (object->active == 0)'),
        'pointer body not validated': ('if (object == NULL || body == NULL || out == NULL || d0_validate_body(body, body_length, NULL) != D0_OK)\n        return D0_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->candidate = -1;', 'if (object == NULL || body == NULL || out == NULL)\n        return D0_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->candidate = -1;'),
        # --- click -------------------------------------------------------------------------------------------------------
        'click gate ignores the active flag': ('if (!(object->active != 0 && object->state == D0_STATE_IDLE && row_phase == 1u)) return D0_OK;', 'if (!(object->state == D0_STATE_IDLE && row_phase == 1u)) return D0_OK;'),
        'click gate ignores the state': ('if (!(object->active != 0 && object->state == D0_STATE_IDLE && row_phase == 1u)) return D0_OK;', 'if (!(object->active != 0 && row_phase == 1u)) return D0_OK;'),
        'click gate ignores the row phase': ('if (!(object->active != 0 && object->state == D0_STATE_IDLE && row_phase == 1u)) return D0_OK;', 'if (!(object->active != 0 && object->state == D0_STATE_IDLE)) return D0_OK;'),
        'click gate any state but release': ('if (!(object->active != 0 && object->state == D0_STATE_IDLE && row_phase == 1u)) return D0_OK;', 'if (!(object->active != 0 && object->state != D0_STATE_RELEASE && row_phase == 1u)) return D0_OK;'),
        'click new phase not carried': ('memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;\n    if (!(', 'memset(out, 0, sizeof(*out));\n    if (!('),
        'click exit not taken': ('object->exit_taken = 1;\n        out->exit_asked = 1u;', 'out->exit_asked = 1u;'),
        'click exit not reported': ('out->exit_asked = 1u;\n        out->new_phase = 2u;', 'out->new_phase = 2u;'),
        'click exit phase wrong': ('out->new_phase = 2u;\n        fx(host, D0_FX_PHASE, 2, 0);', 'out->new_phase = 1u;\n        fx(host, D0_FX_PHASE, 2, 0);'),
        'click exit phase not announced': ('out->new_phase = 2u;\n        fx(host, D0_FX_PHASE, 2, 0);', 'out->new_phase = 2u;'),
        'click key range upper bound': ('if (key < 0 || key >= n) return D0_ERR_BOUNDS;\n        out->key_pressed', 'if (key < 0 || key > n) return D0_ERR_BOUNDS;\n        out->key_pressed'),
        'click key range lower bound': ('if (key < 0 || key >= n) return D0_ERR_BOUNDS;\n        out->key_pressed', 'if (key < -1 || key >= n) return D0_ERR_BOUNDS;\n        out->key_pressed'),
        'click key range unchecked': ('if (key < 0 || key >= n) return D0_ERR_BOUNDS;\n        out->key_pressed', 'if (0) return D0_ERR_BOUNDS;\n        out->key_pressed'),
        'click key not reported': ('out->key_pressed = 1u;\n        if (object->has_surface', 'if (object->has_surface'),
        'click pressed without a surface': ('if (object->has_surface != 0) object->pressed = 1;', 'object->pressed = 1;'),
        'click pressed never': ('if (object->has_surface != 0) object->pressed = 1;', '(void)0;'),
        'click last key not stored': ('object->last = key;', '(void)0;'),
        'click window shifts one too far': ('for (int16_t i = 0; i < l - 1; ++i) object->order[i] = object->order[i + 1];', 'for (int16_t i = 0; i < l; ++i) object->order[i] = object->order[i + 1];'),
        'click window shifts one too little': ('for (int16_t i = 0; i < l - 1; ++i) object->order[i] = object->order[i + 1];', 'for (int16_t i = 0; i < l - 2; ++i) object->order[i] = object->order[i + 1];'),
        'click window shifts the wrong way': ('object->order[i] = object->order[i + 1];', 'object->order[i + 1] = object->order[i];'),
        'click window stores past the end': ('object->order[l - 1] = key;', 'object->order[l] = key;'),
        'click window stores at the start': ('object->order[l - 1] = key;', 'object->order[0] = key;'),
        'click window ignores the length': ('for (int16_t i = 0; i < l - 1; ++i) object->order[i] = object->order[i + 1];\n        object->order[l - 1] = key;', 'for (int16_t i = 0; i < D0_MAX_KEYS - 1; ++i) object->order[i] = object->order[i + 1];\n        object->order[D0_MAX_KEYS - 1] = key;'),
        'click record stride': ('rec = body + B_KEYS + (size_t)key * KEY_STRIDE;\n        memcpy', 'rec = body + B_KEYS + (size_t)key * 0x21u;\n        memcpy'),
        'click record copy drops the NUL': ('strlen((const char *)rec) + 1u);', 'strlen((const char *)rec));'),
        'click record copy to the win sound': ('memcpy(body + B_KEY_SOUND, rec,', 'memcpy(body + B_WIN_SOUND, rec,'),
        'click sound without the process flag': ('if (start_flag != 0 && !no_sound(body + B_KEY_SOUND)) {', 'if (!no_sound(body + B_KEY_SOUND)) {'),
        'click sound ignores the record': ('if (start_flag != 0 && !no_sound(body + B_KEY_SOUND)) {', 'if (start_flag != 0) {'),
        'click sound flag inverted': ('if (start_flag != 0 && !no_sound(body + B_KEY_SOUND)) {', 'if (start_flag == 0 && !no_sound(body + B_KEY_SOUND)) {'),
        'click sound flag is 1': ('if (start_flag != 0 && !no_sound(body + B_KEY_SOUND)) {', 'if (start_flag == 1 && !no_sound(body + B_KEY_SOUND)) {'),
        'click sound record test inverted': ('if (start_flag != 0 && !no_sound(body + B_KEY_SOUND)) {', 'if (start_flag != 0 && no_sound(body + B_KEY_SOUND)) {'),
        'click sound channel wrong': ('const int16_t ch = rd_s16(body, B_KEY_CHANNEL);\n            int32_t busy = 0;', 'const int16_t ch = rd_s16(body, B_WIN_CHANNEL);\n            int32_t busy = 0;'),
        'click sound busy test inverted': ('if (busy == 0) {\n                uint32_t now;', 'if (busy != 0) {\n                uint32_t now;'),
        'click sound ignores busy': ('if (busy == 0) {\n                uint32_t now;', 'if (1) {\n                uint32_t now;'),
        'click sound prepares the win record': ('host->sound_prepare(host->context, body + B_KEY_SOUND)', 'host->sound_prepare(host->context, body + B_WIN_SOUND)'),
        'click sound not marked played': ('out->sound_played = 1u;\n                object->dirty = 1;', 'object->dirty = 1;'),
        'click sound no redraw': ('out->sound_played = 1u;\n                object->dirty = 1;', 'out->sound_played = 1u;'),
        'click deadline 501 ms': ('object->deadline = now + 500u;', 'object->deadline = now + 501u;'),
        'click deadline 499 ms': ('object->deadline = now + 500u;', 'object->deadline = now + 499u;'),
        'click deadline not set': ('object->deadline = now + 500u;', '(void)now;'),
        'click busy failure ignored': ('HOST(host->sound_busy(host->context, ch, &busy));\n            fx(host, D0_FX_SOUND_BUSY, ch, busy);\n            if (busy == 0) {\n                uint32_t now;', '(void)host->sound_busy(host->context, ch, &busy);\n            fx(host, D0_FX_SOUND_BUSY, ch, busy);\n            if (busy == 0) {\n                uint32_t now;'),
        'click prepare failure ignored': ('HOST(host->sound_prepare(host->context, body + B_KEY_SOUND));', '(void)host->sound_prepare(host->context, body + B_KEY_SOUND);'),
        'click play failure ignored': ('HOST(host->sound_play(host->context, ch));\n                fx(host, D0_FX_SOUND_PLAY, ch, 0);\n                out->sound_played', '(void)host->sound_play(host->context, ch);\n                fx(host, D0_FX_SOUND_PLAY, ch, 0);\n                out->sound_played'),
        'click lookup failure ignored': ('HOST(host->text_lookup(host->context, (const char *)rec + KEY_TEXT, &text));', '(void)host->text_lookup(host->context, (const char *)rec + KEY_TEXT, &text);'),
        'click lookup of the sound name': ('host->text_lookup(host->context, (const char *)rec + KEY_TEXT, &text)', 'host->text_lookup(host->context, (const char *)rec, &text)'),
        'click lookup result not announced': ('fx(host, D0_FX_TEXT_LOOKUP, key, text != NULL ? 1 : 0);', '(void)0;'),
        'click text always shown': ('if (text != NULL) {\n            const size_t len', 'if (1) {\n            const size_t len'),
        'click text length at the limit refused': ('if (len > D0_TEXT_LIMIT) return D0_ERR_BOUNDS;', 'if (len >= D0_TEXT_LIMIT) return D0_ERR_BOUNDS;'),
        'click text length one past the limit shown': ('if (len > D0_TEXT_LIMIT) return D0_ERR_BOUNDS;', 'if (len > D0_TEXT_LIMIT + 1u) return D0_ERR_BOUNDS;'),
        'click long text unchecked': ('if (len > D0_TEXT_LIMIT) return D0_ERR_BOUNDS;', '(void)0;'),
        'click text at the maximum skipped': ('if (len <= D0_TEXT_MAX) {', 'if (len < D0_TEXT_MAX) {'),
        'click text beyond the maximum shown': ('if (len <= D0_TEXT_MAX) {', 'if (1) {'),
        'click text suffix lost': ('memcpy(buf + len, "<e>", 4);', 'memcpy(buf + len, "\\0\\0\\0", 4);'),
        'click text suffix without the NUL': ('memcpy(buf + len, "<e>", 4);', 'memcpy(buf + len, "<e>", 3); buf[len + 3] = 1;'),
        'click text body lost': ('memcpy(buf, text, len);', 'memset(buf, 0, len);'),
        'click text show failure ignored': ('HOST(host->text_show(host->context, buf));', '(void)host->text_show(host->context, buf);'),
        'click text not reported': ('out->text_shown = 1u;', '(void)0;'),
        'click text length announced wrong': ('fx(host, D0_FX_TEXT_SHOW, (int32_t)(len + 3u), 0);', 'fx(host, D0_FX_TEXT_SHOW, (int32_t)len, 0);'),
        'click body not validated': ('if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        d0_validate_body(body, body_length, NULL) != D0_OK)\n        return D0_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->new_phase', 'if (object == NULL || body == NULL || out == NULL || !host_complete(host))\n        return D0_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->new_phase'),
        # --- invalidate and cleanup --------------------------------------------------------------------------------------
        'invalidate inactive': ('if (object->active != 0 && object->slot != D0_NO_SLOT) HOST', 'if (object->slot != D0_NO_SLOT) HOST'),
        'invalidate without a slot': ('if (object->active != 0 && object->slot != D0_NO_SLOT) HOST', 'if (object->active != 0) HOST'),
        'invalidate never': ('if (object->active != 0 && object->slot != D0_NO_SLOT) HOST(host->mark_dirty(host->context, object->slot));', '(void)0;'),
        'invalidate wrong slot': ('host->mark_dirty(host->context, object->slot)', 'host->mark_dirty(host->context, 0)'),
        'invalidate failure ignored': ('HOST(host->mark_dirty(host->context, object->slot));', '(void)host->mark_dirty(host->context, object->slot);'),
        'cleanup surface always released': ('if (object->surface != 0u) {\n        const uint32_t surface', 'if (1) {\n        const uint32_t surface'),
        'cleanup surface never released': ('if (object->surface != 0u) {\n        const uint32_t surface', 'if (0) {\n        const uint32_t surface'),
        'cleanup surface kept': ('HOST(host->release_surface(host->context, surface));\n        object->surface = 0u;', 'HOST(host->release_surface(host->context, surface));'),
        'cleanup surface failure ignored': ('HOST(host->release_surface(host->context, surface));', '(void)host->release_surface(host->context, surface);'),
        'cleanup slot always released': ('if (object->slot != D0_NO_SLOT) {\n        const int16_t slot', 'if (1) {\n        const int16_t slot'),
        'cleanup slot never released': ('if (object->slot != D0_NO_SLOT) {\n        const int16_t slot', 'if (0) {\n        const int16_t slot'),
        'cleanup slot failure ignored': ('HOST(host->release_slot(host->context, slot));', '(void)host->release_slot(host->context, slot);'),
        'cleanup slot kept': ('object->slot = D0_NO_SLOT; /* 0x48d067 */', '(void)0;'),
        'cleanup row kept': ('object->row = -1;\n    object->active = 0;', 'object->active = 0;'),
        'cleanup stays active': ('object->active = 0;\n    object->exit_taken = 0;', 'object->exit_taken = 0;'),
        'cleanup exit kept': ('object->exit_taken = 0;\n    object->solved = 0;\n    return D0_OK;', 'object->solved = 0;\n    return D0_OK;'),
        'cleanup solved kept': ('object->exit_taken = 0;\n    object->solved = 0;\n    return D0_OK;', 'object->exit_taken = 0;\n    return D0_OK;'),
        'cleanup wipes the object': ('object->slot = D0_NO_SLOT; /* 0x48d067 */', 'object->slot = D0_NO_SLOT; object->hover = 0; object->state = 0;'),
        # --- render ------------------------------------------------------------------------------------------------------
        'render without a slot': ('if (object->slot == D0_NO_SLOT) return D0_OK;\n    out->valid = 1u;', 'out->valid = 1u;'),
        'render valid flag lost': ('out->valid = 1u;\n    if (object->dirty == 0', 'if (object->dirty == 0'),
        'render ignores the redraw request': ('if (object->dirty == 0 || object->has_surface == 0) return D0_OK;', 'if (object->has_surface == 0) return D0_OK;'),
        'render ignores the missing surface': ('if (object->dirty == 0 || object->has_surface == 0) return D0_OK;', 'if (object->dirty == 0) return D0_OK;'),
        'render needs both': ('if (object->dirty == 0 || object->has_surface == 0) return D0_OK;', 'if (object->dirty == 0 && object->has_surface == 0) return D0_OK;'),
        'render pressed without the hover test': ('if (object->pressed != 0 && object->hover != -1) {', 'if (object->pressed != 0) {'),
        'render pressed never': ('if (object->pressed != 0 && object->hover != -1) {', 'if (0) {'),
        'render pressed or hover': ('if (object->pressed != 0 && object->hover != -1) {', 'if (object->pressed != 0 || object->hover != -1) {'),
        'render pressed key unchecked': ('if (key < 0 || key >= n) return D0_ERR_BOUNDS;\n        HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 1u;', 'HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 1u;'),
        'render pressed key upper bound': ('if (key < 0 || key >= n) return D0_ERR_BOUNDS;\n        HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 1u;', 'if (key < 0 || key > n) return D0_ERR_BOUNDS;\n        HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 1u;'),
        'render restore key unchecked': ('if (key < 0 || key >= n) return D0_ERR_BOUNDS;\n        HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 2u;', 'HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 2u;'),
        'render restore key upper bound': ('if (key < 0 || key >= n) return D0_ERR_BOUNDS;\n        HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 2u;', 'if (key < 0 || key > n) return D0_ERR_BOUNDS;\n        HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 2u;'),
        'render origin failure ignored (pressed)': ('HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 1u;', '(void)host->view_origin(host->context, &vx, &vy);\n        out->blit = 1u;'),
        'render origin failure ignored (restore)': ('HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 2u;', '(void)host->view_origin(host->context, &vx, &vy);\n        out->blit = 2u;'),
        'render pressed key not reported': ('out->blit = 1u;\n        out->key = key;', 'out->key = key;'),
        'render pressed key lost': ('out->blit = 1u;\n        out->key = key;', 'out->blit = 1u;'),
        'render pressed surface lost': ('out->src_surface = object->surface;', 'out->src_surface = 0u;'),
        'render pressed source from the key rectangle': ('rd_s32(body, B_PRESSED + (size_t)key * 16u + (size_t)k * 4u);', 'rd_s32(body, B_KEYRECT + (size_t)key * 16u + (size_t)k * 4u);'),
        'render pressed source stride': ('B_PRESSED + (size_t)key * 16u + (size_t)k * 4u', 'B_PRESSED + (size_t)key * 8u + (size_t)k * 4u'),
        'render destination left without the origin': ('out->dst[0] = (int32_t)((uint32_t)rd_s32(body, d) + (uint32_t)vx);\n        out->dst[1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vy);\n        out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 1);', 'out->dst[0] = rd_s32(body, d);\n        out->dst[1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vy);\n        out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 1);'),
        'render destination swaps the origin': ('out->dst[1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vy);\n        out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 1);', 'out->dst[1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vx);\n        out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 1);'),
        'render destination right edge wrong offset': ('out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 1);', 'out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 1);'),
        'render destination bottom without the origin': ('out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 1);', 'out->dst[3] = rd_s32(body, d + 12);\n        fx(host, D0_FX_BLIT, key, 1);'),
        'render pressed state not release': ('fx(host, D0_FX_BLIT, key, 1);\n        object->state = D0_STATE_RELEASE;', 'fx(host, D0_FX_BLIT, key, 1);\n        object->state = D0_STATE_IDLE;'),
        'render pressed state kept': ('object->state = D0_STATE_RELEASE;\n        fx(host, D0_FX_STATE, object->state, 0);', '(void)0;'),
        'render restore without the check': ('} else if (object->check != 0 && object->last != -1) {', '} else if (object->last != -1) {'),
        'render restore without the last key': ('} else if (object->check != 0 && object->last != -1) {', '} else if (object->check != 0) {'),
        'render restore never': ('} else if (object->check != 0 && object->last != -1) {', '} else if (0) {'),
        'render restore not reported': ('out->blit = 2u;\n        out->key = key;', 'out->key = key;'),
        'render restore surface set': ('out->src_surface = 0u; /* the host\'s generic entry 1 surface (0x5d15e3) */', 'out->src_surface = object->surface;'),
        'render restore source from the pressed rectangle': ('out->src[k] = rd_s32(body, d + (size_t)k * 4u);', 'out->src[k] = rd_s32(body, B_PRESSED + (size_t)key * 16u + (size_t)k * 4u);'),
        'render restore destination without the origin': ('out->dst[0] = (int32_t)((uint32_t)rd_s32(body, d) + (uint32_t)vx);\n        out->dst[1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vy);\n        out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 2);', 'out->dst[0] = rd_s32(body, d);\n        out->dst[1] = rd_s32(body, d + 4);\n        out->dst[2] = rd_s32(body, d + 8);\n        out->dst[3] = rd_s32(body, d + 12);\n        fx(host, D0_FX_BLIT, key, 2);'),
        'render restore check kept': ('object->check = 0;\n        out->solved_check = 1u;', 'out->solved_check = 1u;'),
        'render restore check not reported': ('out->solved_check = 1u;\n        solved_check(object, body, host);', 'solved_check(object, body, host);'),
        'render restore skips the solved check': ('out->solved_check = 1u;\n        solved_check(object, body, host);', 'out->solved_check = 1u;'),
        'render redraw request kept': ('object->dirty = 0;\n    return D0_OK;\n}', 'return D0_OK;\n}'),
        'render body not validated': ('if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        d0_validate_body(body, body_length, NULL) != D0_OK)\n        return D0_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot', 'if (object == NULL || body == NULL || out == NULL || !host_complete(host))\n        return D0_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot'),
        # --- the object reset ---------------------------------------------------------------------------------------------
        'reset slot': ('object->slot = D0_NO_SLOT;\n    object->row = -1;\n}', 'object->row = -1;\n}'),
        'reset row': ('object->slot = D0_NO_SLOT;\n    object->row = -1;\n}', 'object->slot = D0_NO_SLOT;\n}'),
        'reset keeps the storage': ('memset(object, 0, sizeof(*object));\n    object->slot', 'object->slot'),
})
BINDING_MUTANTS = {
        'rows of other types copied': ('if (info.type != SESSION_AD0_TYPE) continue;', '(void)0;'),
        'bad body accepted': ('if (d0_validate_body(info.typed_body, info.typed_body_length, &why) != D0_OK) {', 'if (0) {'),
        'bad body failure text lost': ('binding->failure = why;\n            return D0_ERR_BODY;', 'binding->failure = "none";\n            return D0_ERR_BODY;'),
        'previous scene not cleared': ('if (d0_cleanup(&binding->object, &binding->host.kernel) != D0_OK) {\n        free(rows);\n        binding->failure = "0xd0-scene-clear";', 'if (0) {\n        free(rows);\n        binding->failure = "0xd0-scene-clear";'),
        'clear failure ignored': ('binding->failure = "0xd0-scene-clear";\n        return D0_ERR_HOST;', 'binding->failure = "0xd0-scene-clear";\n        return D0_OK;'),
        'rows not replaced': ('binding->rows = rows;\n    binding->count = count;', 'free(rows);'),
        'destroy does not clear': ('(void)d0_cleanup(&binding->object, &binding->host.kernel);\n    free(binding->rows);', 'free(binding->rows);'),
        'row copy skipped': ('memcpy(rows[i].body, info.typed_body, D0_BODY_BYTES);\n        rows[i].present = 1u;', 'rows[i].present = 1u;'),
        'row not marked present': ('rows[i].present = 1u;', '(void)0;'),
        'foreign row accepted': ('action->type != SESSION_AD0_TYPE ||', '0 ||'),
        'absent row accepted': ('|| binding->rows[index].present == 0u) {', ') {'),
        'row index unchecked': ('index >= binding->count ||', '0 ||'),
        'handler uses the wrong body': ('binding->rows[index].body, D0_BODY_BYTES, (int16_t)index', 'binding->rows[0].body, D0_BODY_BYTES, (int16_t)index'),
        'handler uses the wrong row number': ('D0_BODY_BYTES, (int16_t)index, before->phase', 'D0_BODY_BYTES, 1, before->phase'),
        'unsupported becomes an error': ('if (status == D0_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;', 'if (status == D0_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_ERROR;'),
        'errors are accepted': ('if (status != D0_OK) return SCENE_ACTION_HANDLER_ERROR;', '(void)0;'),
        'world stored only on init': ('(result.initialized != 0u || result.completed != 0u) &&', '(result.initialized != 0u) &&'),
        'world stored only on completion': ('(result.initialized != 0u || result.completed != 0u) &&', '(result.completed != 0u) &&'),
        'world stored on every visit': ('(result.initialized != 0u || result.completed != 0u) &&', '1 &&'),
        'phase before kept': ('out->phase = result.phase_after;', 'out->phase = before->phase;'),
        'completion left pending': ('result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_PENDING'),
        'every visit completes': ('result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_COMPLETED'),
        'failure text lost': ('binding->failure = why != NULL ? why : "none";', 'binding->failure = "none";'),
        'pointer on an inactive puzzle': ('if (binding->object.active == 0) return D0_OK; /* 0x48d1e8 returns 0 without touching anything */', '(void)0;'),
        'pointer result not cleared': ('memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (binding->object.active == 0) return D0_OK; /* 0x48d1e8', 'out->candidate = -1;\n    if (binding->object.active == 0) return D0_OK; /* 0x48d1e8'),
        'pointer candidate default': ('out->candidate = -1;\n    if (binding->object.active == 0) return D0_OK; /* 0x48d1e8', 'out->candidate = 0;\n    if (binding->object.active == 0) return D0_OK; /* 0x48d1e8'),
        'pointer uses the wrong body': ('return d0_pointer(&binding->object, body, D0_BODY_BYTES, x, y, out);', 'return d0_pointer(&binding->object, binding->rows[1].body, D0_BODY_BYTES, x, y, out);'),
        'click on an inactive puzzle': ('out->new_phase = row_phase;\n    if (binding->object.active == 0) return D0_OK;', 'out->new_phase = row_phase;'),
        'click result not cleared': ('memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;\n    if (binding->object.active == 0) return D0_OK;', 'out->new_phase = row_phase;\n    if (binding->object.active == 0) return D0_OK;'),
        'click new phase not carried': ('out->new_phase = row_phase;\n    if (binding->object.active == 0) return D0_OK;', 'if (binding->object.active == 0) return D0_OK;'),
        'click failure text': ('binding->failure = status == D0_OK ? "none" : "0xd0-click";', 'binding->failure = "none";'),
        'click row phase passed wrong': ('D0_BODY_BYTES, row_phase, candidate, start_flag', 'D0_BODY_BYTES, 1u, candidate, start_flag'),
        'click start flag dropped': ('D0_BODY_BYTES, row_phase, candidate, start_flag', 'D0_BODY_BYTES, row_phase, candidate, 0'),
        'click works on a copy': ('status = d0_click(&binding->object, body, D0_BODY_BYTES,', 'uint8_t scratch[D0_BODY_BYTES]; memcpy(scratch, body, D0_BODY_BYTES); status = d0_click(&binding->object, scratch, D0_BODY_BYTES,'),
        'invalidate dropped': ('return d0_invalidate(&binding->object, &binding->host.kernel);', 'return D0_OK;'),
        'render without a slot': ('if (binding->object.slot == D0_NO_SLOT) return D0_OK; /* no render entry: 0x48ded7 is never called */', '(void)0;'),
        'render result not cleared': ('memset(out, 0, sizeof(*out));\n    if (binding->object.slot == D0_NO_SLOT)', 'if (binding->object.slot == D0_NO_SLOT)'),
        'render uses the wrong body': ('return d0_render(&binding->object, body, D0_BODY_BYTES, &binding->host.kernel, out);', 'return d0_render(&binding->object, binding->rows[1].body, D0_BODY_BYTES, &binding->host.kernel, out);'),
        'registered always': ('return binding != NULL && binding->object.slot != D0_NO_SLOT ? 1u : 0u;', 'return binding != NULL ? 1u : 0u;'),
        'unbound failure text': ('"0xd0-binding-unbound"', '"none"'),
}
MUTANTS[BINDING] = {'binding ' + name: change for name, change in BINDING_MUTANTS.items()}


def mutated_copy(root, key, filename, old, new):
    original = (SRC / filename).read_text()
    if original.count(old) != 1:
        raise AssertionError(f'mutation anchor drifted ({original.count(old)} matches): {old[:70]!r}')
    work = Path(root) / key
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir(parents=True)
    for item in SRC.iterdir():
        if item.suffix in ('.c', '.h'):
            shutil.copy(item, work / item.name)
    (work / filename).write_text(original.replace(old, new, 1))
    return work


# Mutants that cannot change observable behaviour; each entry needs a written reason.
EQUIVALENT = {
    'click window shifts one too far': 'the extra iteration copies order[l] into order[l - 1], which the next statement overwrites with '
                                       'the key; only an out-of-bounds read at L = 15 differs and no sanitizer flags a trailing array',
}


def sanitizer_compiler(tmp):
    """The first compiler that builds the unit cases with ASan + UBSan, or None. Memory-unsafe mutants (an unchecked row
    index, a loop one past the array) are only visible to a sanitizer build."""
    for cc in (compiler(), shutil.which('gcc')):
        if cc is not None and compile_c(Path(tmp) / 'probe_san', TEST_C, SOURCES, extra=SANITIZE, cc=cc).returncode == 0:
            return cc
    return None


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'ad0_test'
        built = compile_c(cls.binary, TEST_C, SOURCES, extra=('-Werror', '-Wno-error=type-limits'))
        assert built.returncode == 0, built.stderr

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def test_unit_cases_pass(self):
        code, results = run_unit(self.binary)
        self.assertGreaterEqual(len(results), EXPECTED_UNIT_TESTS)
        for name, (status, message) in sorted(results.items()):
            with self.subTest(name):
                self.assertEqual(status, 'PASS', message)
        self.assertEqual(code, 0)

    def test_sanitizers_on_the_unit_cases(self):
        """ASan + UBSan (and leak checking) over the same cases: rejected bodies, failed host calls, re-init, scene changes."""
        for cc in (compiler(), shutil.which('gcc')):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'ad0_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined',
                   f'-I{SRC}', str(TEST_C), *[str(SRC / s) for s in SOURCES], '-lm', '-o', str(out)]
            if subprocess.run(cmd, capture_output=True, text=True).returncode != 0:
                continue
            env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1')
            done = subprocess.run([str(out)], capture_output=True, text=True, env=env)
            self.assertEqual(done.returncode, 0, done.stdout[-400:] + done.stderr[-400:])
            self.assertGreaterEqual(done.stdout.count('PASS'), EXPECTED_UNIT_TESTS)
            return
        self.skipTest('no compiler with an ASan/UBSan runtime in this environment')

    def test_mutations_are_detected(self):
        """The cases must fail when a recovered rule is deliberately broken (every non-equivalent mutant is killed)."""
        jobs = []
        for filename, mutations in MUTANTS.items():
            for name, (old, new) in mutations.items():
                if name not in EQUIVALENT:
                    jobs.append((filename, name, old, new))

        san_cc = sanitizer_compiler(self.tmp.name)
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1')

        def build_and_run(index_job):
            index, (filename, name, old, new) = index_job
            work = mutated_copy(self.tmp.name, f'mut{index}', filename, old, new)
            binary = work / 'mut_test'
            built = compile_c(binary, TEST_C, SOURCES, src_dir=work, optimize='-O0',
                              extra=SANITIZE if san_cc else (), cc=san_cc)
            if built.returncode != 0:
                return name, 'build', built.stderr[-300:]
            done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=120, env=env)
            shutil.rmtree(work, ignore_errors=True)
            return name, 'killed' if done.returncode != 0 else 'survived', ''

        with concurrent.futures.ThreadPoolExecutor(max_workers=min(8, os.cpu_count() or 2)) as pool:
            outcomes = list(pool.map(build_and_run, enumerate(jobs)))
        self.assertEqual(len({name for _, name, _, _ in jobs}), len(jobs), 'duplicate mutant names')
        killed = sum(1 for _, verdict, _ in outcomes if verdict == 'killed')
        for name, verdict, detail in outcomes:
            with self.subTest(name):
                self.assertEqual(verdict, 'killed', f'mutant {verdict}: {name} {detail}')
        print(f'mutants killed: {killed} of {len(jobs)} ({len(EQUIVALENT)} recorded equivalent, not run)')


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_d0_runtime.sh')],
                              capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())


class Registration(unittest.TestCase):
    def test_module_is_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        self.assertIn(' action_family_d0_runtime session_bindings_ad0', build)


if __name__ == '__main__':
    unittest.main()
