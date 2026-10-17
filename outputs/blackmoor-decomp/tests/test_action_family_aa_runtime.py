"""RT-52: raw 0xaa Alarm Clock runtime (src/action_family_aa_runtime.c) and its session binding (src/session_bindings_aaa.c).

Facts under test (original GAME.EXE, read from the disassembly of 0x44da08, 0x44d28c, 0x44d597, 0x44d624, 0x44e035, 0x44d9b5,
0x44d19d, 0x44d154, 0x44d107, 0x44d711, 0x44d8ad, 0x44d946 and 0x42ba3a):
 * phase 0 reads the game time (hour word 0x585d51, minute word 0x585d4f) into the displayed time and a proposed alarm, sets
   [0x5bb1ca] := 1, allocates the generic z entry, loads the clock image once, prepares the button sound and ends in phase 1;
 * phase 1 is a nine-state machine on obj+0x2d: time and alarm mode, a pressed button until its deadline, hour step up and
   down, the set button's delay, the final sound and its end, the cancel button;
 * phase 2 stops the button sound, applies the cancel block or (after a set) writes the alarm into the game clock and applies
   the set block, then the generic completion 0x42ba3a and the cleanup;
 * the pointer hit-tests the live buttons of the current state (inclusive rectangles) and writes the cursor cells and the
   candidate 0x276e; the click plays the button sound and starts the press deadline; the render callback blits the digits, the
   AM/PM overlay, the mode light, and the pressed button or the six restored buttons.
The unit cases live in tests/action_family_aa_runtime_test.c (synthetic bodies, no original bytes). The original-x86 oracle is a
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
TEST_C = PROJECT / 'tests/action_family_aa_runtime_test.c'
KERNEL = 'action_family_aa_runtime.c'
BINDING = 'session_bindings_aaa.c'
SOURCES = [KERNEL, BINDING, 'scene_resource.c', 'hiff.c']
EXPECTED_UNIT_TESTS = 38
CORPUS_C = PROJECT / 'tests/action_family_aa_runtime_corpus.c'
RESOURCES = PROJECT.parents[1] / 'work/analysis/hiff-resources'


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


MUTANTS = {KERNEL: {}, BINDING: {}}


def add(table, name, old, new):
    assert name not in MUTANTS[table], name
    MUTANTS[table][name] = (old, new)


def k(name, old, new):
    add(KERNEL, name, old, new)


# Each mutant breaks one recovered rule; the unit cases must fail on every one of them. Anchors are unique source fragments.
# --- body validation ---------------------------------------------------------------------------------------------------------
k('validate accepts a longer body', 'length != ALC_BODY_BYTES', 'length < ALC_BODY_BYTES')
k('validate accepts a shorter body', 'length != ALC_BODY_BYTES', 'length > ALC_BODY_BYTES')
k('validate accepts a null body', 'body == NULL || length != ALC_BODY_BYTES', 'length != ALC_BODY_BYTES')
k('validate name one byte short', 'memchr(body, 0, ALC_NAME_BYTES) == NULL', 'memchr(body, 0, ALC_NAME_BYTES - 1u) == NULL')
k('validate name one byte long', 'memchr(body, 0, ALC_NAME_BYTES) == NULL', 'memchr(body, 0, ALC_NAME_BYTES + 1u) == NULL')
k('validate button sound one byte short', 'memchr(body + B_BUTTON_SOUND, 0, ALC_NAME_BYTES) == NULL',
  'memchr(body + B_BUTTON_SOUND, 0, ALC_NAME_BYTES - 1u) == NULL')
k('validate button sound one byte long', 'memchr(body + B_BUTTON_SOUND, 0, ALC_NAME_BYTES) == NULL',
  'memchr(body + B_BUTTON_SOUND, 0, ALC_NAME_BYTES + 1u) == NULL')
k('validate final sound one byte short', 'memchr(body + B_FINAL_SOUND, 0, ALC_NAME_BYTES) == NULL',
  'memchr(body + B_FINAL_SOUND, 0, ALC_NAME_BYTES - 1u) == NULL')
k('validate final sound one byte long', 'memchr(body + B_FINAL_SOUND, 0, ALC_NAME_BYTES) == NULL',
  'memchr(body + B_FINAL_SOUND, 0, ALC_NAME_BYTES + 1u) == NULL')
k('validate button sound unchecked', 'memchr(body + B_BUTTON_SOUND, 0, ALC_NAME_BYTES) == NULL', '0')
k('validate final sound unchecked', 'memchr(body + B_FINAL_SOUND, 0, ALC_NAME_BYTES) == NULL', '0')
k('validate name unchecked', 'memchr(body, 0, ALC_NAME_BYTES) == NULL', '0')
k('validate button sound at the final offset', 'memchr(body + B_BUTTON_SOUND, 0, ALC_NAME_BYTES) == NULL',
  'memchr(body + B_FINAL_SOUND, 0, ALC_NAME_BYTES) == NULL')
k('validate final sound at the button offset', 'memchr(body + B_FINAL_SOUND, 0, ALC_NAME_BYTES) == NULL',
  'memchr(body + B_BUTTON_SOUND, 0, ALC_NAME_BYTES) == NULL')
k('validate failure text lost', 'if (failure != NULL) *failure = why;\n    return why == NULL', 'return why == NULL')
k('validate always ok', 'return why == NULL ? ALC_OK : ALC_ERR_BODY;', 'return ALC_OK;')
k('validate length text', '"0xaa-body-length"', '"x"')
k('validate name text', '"0xaa-name-unterminated"', '"x"')
k('validate button sound text', '"0xaa-button-sound-unterminated"', '"x"')
k('validate final sound text', '"0xaa-final-sound-unterminated"', '"x"')
# --- the object reset --------------------------------------------------------------------------------------------------------
k('reset slot', 'object->slot = ALC_NO_SLOT;\n    object->row = -1;\n}', 'object->row = -1;\n}')
k('reset row', 'object->slot = ALC_NO_SLOT;\n    object->row = -1;\n}', 'object->slot = ALC_NO_SLOT;\n}')
k('reset keeps the storage', 'memset(object, 0, sizeof(*object));\n    object->slot', 'object->slot')
# --- the time reader ---------------------------------------------------------------------------------------------------------
k('time AM not preset', 'o->time_am = 1;\n    if (hour == 0 || hour == 0x18) {', 'if (hour == 0 || hour == 0x18) {')
k('time hour 0 is not midnight', 'if (hour == 0 || hour == 0x18) {', 'if (hour == 0x18) {')
k('time hour 24 is not midnight', 'if (hour == 0 || hour == 0x18) {', 'if (hour == 0) {')
k('time hour 1 is midnight', 'if (hour == 0 || hour == 0x18) {', 'if (hour == 0 || hour == 0x18 || hour == 1) {')
k('time noon hour', 'else if (hour == 0xc) {', 'else if (hour == 0xb) {')
k('time noon is AM', 'o->time_hour = 0xb;\n        o->time_am = 0;', 'o->time_hour = 0xb;')
k('time noon index', 'o->time_hour = 0xb;\n        o->time_am = 0;', 'o->time_hour = 0xa;\n        o->time_am = 0;')
k('time midnight index', 'o->time_hour = 0xb;\n    } else if', 'o->time_hour = 0;\n    } else if')
k('time morning boundary', 'else if (hour < 0xc) {', 'else if (hour <= 0xc) {')
k('time morning boundary low', 'else if (hour < 0xc) {', 'else if (hour < 0xb) {')
k('time morning index', 'o->time_hour = (int16_t)(hour - 1);', 'o->time_hour = (int16_t)hour;')
k('time afternoon index', 'o->time_hour = (int16_t)(hour - 0xd);', 'o->time_hour = (int16_t)(hour - 0xc);')
k('time afternoon is AM', 'o->time_hour = (int16_t)(hour - 0xd);\n        o->time_am = 0;', 'o->time_hour = (int16_t)(hour - 0xd);')
k('time quarter 0 upper', 'minute >= 0 && minute <= 0xf', 'minute >= 0 && minute <= 0xe')
k('time quarter 0 upper high', 'minute >= 0 && minute <= 0xf', 'minute >= 0 && minute <= 0x10')
k('time quarter 0 accepts negatives', 'minute >= 0 && minute <= 0xf', 'minute <= 0xf')
k('time quarter 1 lower', 'minute >= 0x10 && minute <= 0x1e', 'minute >= 0x11 && minute <= 0x1e')
k('time quarter 1 upper', 'minute >= 0x10 && minute <= 0x1e', 'minute >= 0x10 && minute <= 0x1f')
k('time quarter 2 lower', 'minute >= 0x1f && minute <= 0x2d', 'minute >= 0x20 && minute <= 0x2d')
k('time quarter 2 upper', 'minute >= 0x1f && minute <= 0x2d', 'minute >= 0x1f && minute <= 0x2e')
k('time quarter 3 lower', 'minute >= 0x2e && minute <= 0x3b', 'minute >= 0x2f && minute <= 0x3b')
k('time quarter 3 upper', 'minute >= 0x2e && minute <= 0x3b', 'minute >= 0x2e && minute <= 0x3c')
k('time quarter 3 upper low', 'minute >= 0x2e && minute <= 0x3b', 'minute >= 0x2e && minute <= 0x3a')
k('time quarter 0 value', 'o->time_quarter = 0;\n    else if (minute >= 0x10', 'o->time_quarter = 1;\n    else if (minute >= 0x10')
k('time quarter 1 value', 'o->time_quarter = 1;\n    else if (minute >= 0x1f', 'o->time_quarter = 2;\n    else if (minute >= 0x1f')
k('time quarter 2 value', 'o->time_quarter = 2;\n    else if (minute >= 0x2e', 'o->time_quarter = 3;\n    else if (minute >= 0x2e')
k('time quarter 3 value', 'o->time_quarter = 3;\n    o->alarm_am', 'o->time_quarter = 2;\n    o->alarm_am')
k('alarm AM from nothing', 'o->alarm_am = o->time_am;\n', 'o->alarm_am = 0;\n')
k('alarm after the first quarter', 'if (o->time_quarter > 0) {', 'if (o->time_quarter > 1) {')
k('alarm after the zeroth quarter', 'if (o->time_quarter > 0) {', 'if (o->time_quarter >= 0) {')
k('alarm quarter kept', 'o->alarm_quarter = 0;\n        o->alarm_hour', 'o->alarm_quarter = o->time_quarter;\n        o->alarm_hour')
k('alarm hour two ahead', '((int32_t)o->time_hour + 1) % 12', '((int32_t)o->time_hour + 2) % 12')
k('alarm hour unwrapped', '((int32_t)o->time_hour + 1) % 12', '((int32_t)o->time_hour + 1) % 13')
k('alarm hour 12 flips nothing', 'if (o->alarm_hour == 0xb) o->alarm_am = o->time_am == 0;', 'if (o->alarm_hour == 0xa) o->alarm_am = o->time_am == 0;')
k('alarm hour 12 keeps AM', 'o->alarm_am = o->time_am == 0;', 'o->alarm_am = o->time_am != 0;')
k('alarm hour 12 never flips', 'if (o->alarm_hour == 0xb) o->alarm_am = o->time_am == 0;', '(void)0;')
k('alarm on the hour quarter', 'o->alarm_quarter = o->time_quarter;', 'o->alarm_quarter = 0;')
k('alarm on the hour hour', 'o->alarm_hour = o->time_hour;', 'o->alarm_hour = 0;')
# --- the hour step -----------------------------------------------------------------------------------------------------------
k('step increase inverted', 'if (increase != 0) {', 'if (increase == 0) {')
k('step increase by two', 'o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour + 1) % 12);\n        if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am == 0;',
  'o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour + 2) % 12);\n        if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am == 0;')
k('step increase unwrapped', '((int32_t)o->alarm_hour + 1) % 12', '((int32_t)o->alarm_hour + 1) % 13')
k('step increase flips at ten', 'if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am == 0;', 'if (o->alarm_hour == 0xa) o->alarm_am = o->alarm_am == 0;')
k('step increase never flips', 'if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am == 0;', '(void)0;')
k('step increase keeps', 'if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am == 0;', 'if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am != 0;')
k('step decrease from zero', 'if (o->alarm_hour == 0)\n            o->alarm_hour = 0xb;', 'if (o->alarm_hour == 1)\n            o->alarm_hour = 0xb;')
k('step decrease from zero lands wrong', 'o->alarm_hour = 0xb;\n        else', 'o->alarm_hour = 0xa;\n        else')
k('step decrease by two', '((int32_t)o->alarm_hour - 1) % 12', '((int32_t)o->alarm_hour - 2) % 12')
k('step decrease flips at eleven', 'if (o->alarm_hour == 0xa) o->alarm_am = o->alarm_am == 0;', 'if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am == 0;')
k('step decrease flips at nine', 'if (o->alarm_hour == 0xa) o->alarm_am = o->alarm_am == 0;', 'if (o->alarm_hour == 9) o->alarm_am = o->alarm_am == 0;')
k('step decrease never flips', 'if (o->alarm_hour == 0xa) o->alarm_am = o->alarm_am == 0;', '(void)0;')
k('step decrease keeps', 'if (o->alarm_hour == 0xa) o->alarm_am = o->alarm_am == 0;', 'if (o->alarm_hour == 0xa) o->alarm_am = o->alarm_am != 0;')
# --- the alarm writer --------------------------------------------------------------------------------------------------------
k('alarm writer AM inverted', 'if (o->alarm_am == 0)\n        hour = o->alarm_hour == 0xb', 'if (o->alarm_am != 0)\n        hour = o->alarm_hour == 0xb')
k('alarm writer PM noon hour', 'hour = o->alarm_hour == 0xb ? 0xc : (int16_t)(o->alarm_hour + 0xd);', 'hour = o->alarm_hour == 0xa ? 0xc : (int16_t)(o->alarm_hour + 0xd);')
k('alarm writer PM noon value', 'hour = o->alarm_hour == 0xb ? 0xc : (int16_t)(o->alarm_hour + 0xd);', 'hour = o->alarm_hour == 0xb ? 0xd : (int16_t)(o->alarm_hour + 0xd);')
k('alarm writer PM offset', 'hour = o->alarm_hour == 0xb ? 0xc : (int16_t)(o->alarm_hour + 0xd);', 'hour = o->alarm_hour == 0xb ? 0xc : (int16_t)(o->alarm_hour + 0xc);')
k('alarm writer AM midnight hour', 'hour = o->alarm_hour == 0xb ? 0 : (int16_t)(o->alarm_hour + 1);', 'hour = o->alarm_hour == 0xa ? 0 : (int16_t)(o->alarm_hour + 1);')
k('alarm writer AM midnight value', 'hour = o->alarm_hour == 0xb ? 0 : (int16_t)(o->alarm_hour + 1);', 'hour = o->alarm_hour == 0xb ? 0x18 : (int16_t)(o->alarm_hour + 1);')
k('alarm writer AM offset', 'hour = o->alarm_hour == 0xb ? 0 : (int16_t)(o->alarm_hour + 1);', 'hour = o->alarm_hour == 0xb ? 0 : (int16_t)(o->alarm_hour + 2);')
k('alarm writer hour not stored', 'world->hour_585d51 = hour;', '(void)0;')
k('alarm writer hour not announced', 'fx(host, ALC_FX_HOUR_STORE, hour, 0);', '(void)0;')
k('alarm writer minute kept', 'world->minute_585d4f = 0;', '(void)0;')
k('alarm writer minute not announced', 'fx(host, ALC_FX_MINUTE_STORE, 0, 0);', '(void)0;')
# --- the finish blocks -------------------------------------------------------------------------------------------------------
k('block scene test inverted', 'if (rd_s16(blk, SB_SCENE) != ALC_NO_SCENE) {', 'if (rd_s16(blk, SB_SCENE) == ALC_NO_SCENE) {')
k('block scene from the wrong word', 't.scene = rd_s16(blk, SB_SCENE);', 't.scene = rd_s16(blk, SB_W1);')
k('block scene unsigned', 't.scene = rd_s16(blk, SB_SCENE);', 't.scene = (int16_t)(uint16_t)(rd_s16(blk, SB_SCENE) & 0x7fff);')
k('block word 1 from word 2', 't.word[0] = rd_s16(blk, SB_W1);', 't.word[0] = rd_s16(blk, SB_W2);')
k('block word 2 from word 3', 't.word[1] = rd_s16(blk, SB_W2);', 't.word[1] = rd_s16(blk, SB_W3);')
k('block word 3 from word 1', 't.word[2] = rd_s16(blk, SB_W3);', 't.word[2] = rd_s16(blk, SB_W1);')
k('block dword 1 from dword 2', 't.dword[0] = rd_s32(blk, SB_D1);', 't.dword[0] = rd_s32(blk, SB_D2);')
k('block dword 2 from dword 3', 't.dword[1] = rd_s32(blk, SB_D2);', 't.dword[1] = rd_s32(blk, SB_D3);')
k('block dword 3 from dword 1', 't.dword[2] = rd_s32(blk, SB_D3);', 't.dword[2] = rd_s32(blk, SB_D1);')
k('block transition failure ignored', 'HOST(host->transition(host->context, &t));', '(void)host->transition(host->context, &t);')
k('block scene effect lost', 'fx(host, ALC_FX_XFER_5BB57B, t.scene, 0);', '(void)0;')
k('block word 1 effect lost', 'fx(host, ALC_FX_XFER_5BB599, t.word[0], 0);', '(void)0;')
k('block word 2 effect lost', 'fx(host, ALC_FX_XFER_5BB595, t.word[1], 0);', '(void)0;')
k('block word 3 effect lost', 'fx(host, ALC_FX_XFER_5C39FF, t.word[2], 0);', '(void)0;')
k('block dword 1 effect lost', 'fx(host, ALC_FX_XFER_5BB59B, t.dword[0], 0);', '(void)0;')
k('block dword 2 effect lost', 'fx(host, ALC_FX_XFER_5BB59F, t.dword[1], 0);', '(void)0;')
k('block dword 3 effect lost', 'fx(host, ALC_FX_XFER_5BB5A3, t.dword[2], 0);', '(void)0;')
k('block start flag stores 1 for 1', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) == 1 ? 1 : 0;')
k('block start flag stores 0 for 0', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 0 ? 1 : 0;')
k('block start flag from the wrong word', 'rd_s16(blk, SB_START) != 1', 'rd_s16(blk, SB_FLAG) != 1')
k('block start flag not announced', 'fx(host, ALC_FX_START_FLAG, world->start_flag_5bb1ca, 0);', '(void)0;')
k('block engine mode not announced', 'fx(host, ALC_FX_ENGINE_MODE, 4, 0);', '(void)0;')
k('block engine mode wrong', 'fx(host, ALC_FX_ENGINE_MODE, 4, 0);', 'fx(host, ALC_FX_ENGINE_MODE, 3, 0);')
k('block flag 0 is none', 'if (flag != ALC_NO_FLAG) {', 'if (flag > 0) {')
k('block flag -1 is a flag', 'if (flag != ALC_NO_FLAG) {', 'if (1) {')
k('block flag from the wrong word', 'const int16_t flag = rd_s16(blk, SB_FLAG);\n        if (flag != ALC_NO_FLAG) {',
  'const int16_t flag = rd_s16(blk, SB_START);\n        if (flag != ALC_NO_FLAG) {')
k('block flag value wrong', 'store_event_flag(host->context, flag, blk[SB_VALUE])', 'store_event_flag(host->context, flag, blk[SB_VALUE] + 1u)')
k('block flag value signed', 'store_event_flag(host->context, flag, blk[SB_VALUE])', 'store_event_flag(host->context, flag, (uint32_t)(int8_t)blk[SB_VALUE])')
k('block flag store failure ignored', 'HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE]));', '(void)host->store_event_flag(host->context, flag, blk[SB_VALUE]);')
k('block flag not announced', 'fx(host, ALC_FX_EVENT_FLAG, flag, blk[SB_VALUE]);', '(void)0;')
# --- phase 0 -----------------------------------------------------------------------------------------------------------------
k('phase 0 row not stored', 'o->row = row;\n    o->active = 1;', 'o->active = 1;')
k('phase 0 not active', 'o->active = 1;\n    read_time(o, world);', 'read_time(o, world);')
k('phase 0 time not read', 'read_time(o, world);\n    o->dirty = 1;', 'o->dirty = 1;')
k('phase 0 dirty lost', 'o->dirty = 1;\n    world->start_flag_5bb1ca = 1;', 'world->start_flag_5bb1ca = 1;')
k('phase 0 start flag not set', 'world->start_flag_5bb1ca = 1;\n    fx(host, ALC_FX_START_FLAG, 1, 0);\n    o->restore = 0;', 'fx(host, ALC_FX_START_FLAG, 1, 0);\n    o->restore = 0;')
k('phase 0 start flag not announced', 'fx(host, ALC_FX_START_FLAG, 1, 0);\n    o->restore = 0;', 'o->restore = 0;')
k('phase 0 restore kept', 'o->restore = 0;\n    o->state = ALC_STATE_TIME;', 'o->state = ALC_STATE_TIME;')
k('phase 0 state kept', 'o->state = ALC_STATE_TIME;\n    o->over = 0;', 'o->over = 0;')
k('phase 0 state wrong', 'o->state = ALC_STATE_TIME;\n    o->over = 0;', 'o->state = ALC_STATE_ALARM;\n    o->over = 0;')
k('phase 0 over kept', 'o->over = 0;\n    HOST(host->alloc_slot', 'HOST(host->alloc_slot')
k('phase 0 slot not stored', 'o->slot = slot;\n    fx(host, ALC_FX_SLOT, slot, 0);', 'fx(host, ALC_FX_SLOT, slot, 0);')
k('phase 0 slot not announced', 'fx(host, ALC_FX_SLOT, slot, 0);', '(void)0;')
k('phase 0 label wrong', '"ALARM CLOCK OVERLAYS"));', '"ALARM CLOCK"));')
k('phase 0 register not announced', 'fx(host, ALC_FX_SLOT_REGISTER, slot, 0);', '(void)0;')
k('phase 0 surface test inverted', 'if (o->surface == 0u) {\n        uint32_t surface = 0;', 'if (o->surface != 0u) {\n        uint32_t surface = 0;')
k('phase 0 surface always loaded', 'if (o->surface == 0u) {\n        uint32_t surface = 0;', 'if (1) {\n        uint32_t surface = 0;')
k('phase 0 loads the wrong name', 'host->load_surface(host->context, (const char *)body, &surface)', 'host->load_surface(host->context, (const char *)body + 1, &surface)')
k('phase 0 surface not stored', 'o->surface = surface;\n        fx(host, ALC_FX_SURFACE_LOAD', 'fx(host, ALC_FX_SURFACE_LOAD')
k('phase 0 surface not announced', 'fx(host, ALC_FX_SURFACE_LOAD, (int32_t)surface, 0);', '(void)0;')
k('phase 0 slot surface wrong', 'host->set_slot_surface(host->context, slot, o->surface)', 'host->set_slot_surface(host->context, slot, 0u)')
k('phase 0 slot surface slot wrong', 'host->set_slot_surface(host->context, slot, o->surface)', 'host->set_slot_surface(host->context, 0, o->surface)')
k('phase 0 slot surface not announced', 'fx(host, ALC_FX_SLOT_SURFACE, slot, (int32_t)o->surface);', '(void)0;')
k('phase 0 sound test inverted', 'if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_prepare', 'if (no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_prepare')
k('phase 0 sound always', 'if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_prepare', 'if (1) {\n        HOST(host->sound_prepare')
k('phase 0 prepares the final record', 'HOST(host->sound_prepare(host->context, body + B_BUTTON_SOUND));', 'HOST(host->sound_prepare(host->context, body + B_FINAL_SOUND));')
k('phase 0 prepare not announced', 'fx(host, ALC_FX_SOUND_PREPARE, B_BUTTON_SOUND, 0);', '(void)0;')
k('phase 0 set kept', 'o->set = 0;\n    o->canceled = 0;\n    return ALC_OK;', 'o->canceled = 0;\n    return ALC_OK;')
k('phase 0 canceled kept', 'o->set = 0;\n    o->canceled = 0;\n    return ALC_OK;', 'o->set = 0;\n    return ALC_OK;')
k('phase 0 alloc failure ignored', 'HOST(host->alloc_slot(host->context, &slot));', '(void)host->alloc_slot(host->context, &slot);')
k('phase 0 register failure ignored', 'HOST(host->register_slot(host->context, slot, "ALARM CLOCK OVERLAYS"));', '(void)host->register_slot(host->context, slot, "ALARM CLOCK OVERLAYS");')
k('phase 0 load failure ignored', 'HOST(host->load_surface(host->context, (const char *)body, &surface));', '(void)host->load_surface(host->context, (const char *)body, &surface);')
k('phase 0 slot surface failure ignored', 'HOST(host->set_slot_surface(host->context, slot, o->surface));', '(void)host->set_slot_surface(host->context, slot, o->surface);')
k('phase 0 prepare failure ignored', 'HOST(host->sound_prepare(host->context, body + B_BUTTON_SOUND));', '(void)host->sound_prepare(host->context, body + B_BUTTON_SOUND);')
# --- the sound record test ---------------------------------------------------------------------------------------------------
k('no sound compares eight bytes', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8) == 0;')
k('no sound compares ten bytes', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 10) == 0;')
k('no sound wording', "'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0", "'N', 'O', '_', 'S', 'O', 'U', 'N', 'D', 0")
k('no sound inverted', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k) != 0;')
# --- phase 1 -----------------------------------------------------------------------------------------------------------------
k('cancel state not taken', 'o->canceled = 1;\n        *row_phase = 2u;', '*row_phase = 2u;')
k('cancel phase not asked', 'o->canceled = 1;\n        *row_phase = 2u;', 'o->canceled = 1;\n        *row_phase = 1u;')
k('cancel phase not announced', 'o->canceled = 1;\n        *row_phase = 2u;\n        fx(host, ALC_FX_PHASE, 2, 0);', 'o->canceled = 1;\n        *row_phase = 2u;')
k('pressed one tick too late', 'if (now >= o->press_deadline) {', 'if (now > o->press_deadline) {')
k('pressed one tick early', 'if (now >= o->press_deadline) {', 'if (now + 1u >= o->press_deadline) {')
k('pressed deadline signed', 'if (now >= o->press_deadline) {', 'if ((int32_t)now >= (int32_t)o->press_deadline) {')
k('pressed state not the button', 'o->state = o->button;\n            o->restore = 1;', 'o->state = ALC_STATE_ALARM;\n            o->restore = 1;')
k('pressed restore lost', 'o->state = o->button;\n            o->restore = 1;', 'o->state = o->button;')
k('pressed tick not announced', 'const uint32_t now = host->tick(host->context);\n        fx(host, ALC_FX_TICK, (int32_t)now, 0);\n        if (now >= o->press_deadline)',
  'const uint32_t now = host->tick(host->context);\n        if (now >= o->press_deadline)')
k('idle redraw lost', 'case ALC_STATE_ALARM:\n        o->dirty = 1;\n        break;', 'case ALC_STATE_ALARM:\n        break;')
k('time mode is not a mode', 'case ALC_STATE_TIME:\n    case ALC_STATE_ALARM:', 'case ALC_STATE_ALARM:')
k('alarm mode is not a mode', 'case ALC_STATE_TIME:\n    case ALC_STATE_ALARM:', 'case ALC_STATE_TIME:')
k('step state wrong direction', 'step_hour(o, o->state == ALC_STATE_INCREASE);', 'step_hour(o, o->state == ALC_STATE_DECREASE);')
k('step state decrease is increase', 'step_hour(o, o->state == ALC_STATE_INCREASE);', 'step_hour(o, 1);')
k('step state redraw lost', 'step_hour(o, o->state == ALC_STATE_INCREASE);\n        o->dirty = 1;', 'step_hour(o, o->state == ALC_STATE_INCREASE);')
k('step state does not return to alarm', 'o->dirty = 1;\n        o->state = ALC_STATE_ALARM;\n        break;', 'o->dirty = 1;\n        break;')
k('step state returns to time', 'o->dirty = 1;\n        o->state = ALC_STATE_ALARM;\n        break;', 'o->dirty = 1;\n        o->state = ALC_STATE_TIME;\n        break;')
k('step increase state lost', 'case ALC_STATE_INCREASE:\n    case ALC_STATE_DECREASE:', 'case ALC_STATE_DECREASE:')
k('step decrease state lost', 'case ALC_STATE_INCREASE:\n    case ALC_STATE_DECREASE:', 'case ALC_STATE_INCREASE:')
k('set delay in tenths', '(int32_t)rd_s16(body, B_FINAL_DELAY) * 1000', '(int32_t)rd_s16(body, B_FINAL_DELAY) * 100')
k('set delay unsigned', '(int32_t)rd_s16(body, B_FINAL_DELAY) * 1000', '(int32_t)(uint16_t)rd_s16(body, B_FINAL_DELAY) * 1000')
k('set delay from the wrong offset', 'rd_s16(body, B_FINAL_DELAY)', 'rd_s16(body, B_PRESS_DELAY)')
k('set delay not added to now', 'o->final_deadline = now + (uint32_t)', 'o->final_deadline = 0u + (uint32_t)')
k('set not marked', 'o->set = 1;\n        o->state = ALC_STATE_WAIT_SET;', 'o->state = ALC_STATE_WAIT_SET;')
k('set state wrong', 'o->set = 1;\n        o->state = ALC_STATE_WAIT_SET;', 'o->set = 1;\n        o->state = ALC_STATE_FINAL_SOUND;')
k('set tick not announced', 'const uint32_t now = host->tick(host->context);\n        fx(host, ALC_FX_TICK, (int32_t)now, 0);\n        o->final_deadline',
  'const uint32_t now = host->tick(host->context);\n        o->final_deadline')
k('wait one tick too late', 'if (now >= o->final_deadline) {', 'if (now > o->final_deadline) {')
k('wait one tick early', 'if (now >= o->final_deadline) {', 'if (now + 1u >= o->final_deadline) {')
k('wait deadline signed', 'if (now >= o->final_deadline) {', 'if ((int32_t)now >= (int32_t)o->final_deadline) {')
k('wait tick not announced', 'const uint32_t now = host->tick(host->context);\n        fx(host, ALC_FX_TICK, (int32_t)now, 0);\n        if (now >= o->final_deadline)',
  'const uint32_t now = host->tick(host->context);\n        if (now >= o->final_deadline)')
k('final sound test inverted', 'if (!no_sound(body + B_FINAL_SOUND)) {\n                const int16_t ch', 'if (no_sound(body + B_FINAL_SOUND)) {\n                const int16_t ch')
k('final sound always', 'if (!no_sound(body + B_FINAL_SOUND)) {\n                const int16_t ch', 'if (1) {\n                const int16_t ch')
k('final sound never', 'if (!no_sound(body + B_FINAL_SOUND)) {\n                const int16_t ch', 'if (0) {\n                const int16_t ch')
k('final sound channel from the button channel', 'const int16_t ch = rd_s16(body, B_FINAL_CHANNEL);\n                HOST(host->sound_prepare', 'const int16_t ch = rd_s16(body, B_BUTTON_CHANNEL);\n                HOST(host->sound_prepare')
k('final sound prepares the button record', 'HOST(host->sound_prepare(host->context, body + B_FINAL_SOUND));', 'HOST(host->sound_prepare(host->context, body + B_BUTTON_SOUND));')
k('final sound prepare not announced', 'fx(host, ALC_FX_SOUND_PREPARE, B_FINAL_SOUND, 0);', '(void)0;')
k('final sound play not announced', 'fx(host, ALC_FX_SOUND_PLAY, ch, 0);\n                o->state', 'o->state')
k('final sound state wrong', 'o->state = ALC_STATE_FINAL_SOUND;\n            } else {', 'o->state = ALC_STATE_WAIT_SET;\n            } else {')
k('final sound prepare failure ignored', 'HOST(host->sound_prepare(host->context, body + B_FINAL_SOUND));', '(void)host->sound_prepare(host->context, body + B_FINAL_SOUND);')
k('final sound play failure ignored', 'HOST(host->sound_play(host->context, ch));\n                fx(host, ALC_FX_SOUND_PLAY, ch, 0);\n                o->state',
  '(void)host->sound_play(host->context, ch);\n                fx(host, ALC_FX_SOUND_PLAY, ch, 0);\n                o->state')
k('no final sound keeps waiting', '} else {\n                *row_phase = 2u;', '} else {\n                *row_phase = 1u;')
k('no final sound phase not announced', '} else {\n                *row_phase = 2u;\n                fx(host, ALC_FX_PHASE, 2, 0);', '} else {\n                *row_phase = 2u;')
k('final busy channel wrong', 'const int16_t ch = rd_s16(body, B_FINAL_CHANNEL);\n        int32_t busy = 0;', 'const int16_t ch = rd_s16(body, B_BUTTON_CHANNEL);\n        int32_t busy = 0;')
k('final busy test inverted', 'if (busy == 0) {\n            HOST(host->sound_stop(host->context, body + B_FINAL_SOUND));', 'if (busy != 0) {\n            HOST(host->sound_stop(host->context, body + B_FINAL_SOUND));')
k('final busy stops the button record', 'HOST(host->sound_stop(host->context, body + B_FINAL_SOUND));', 'HOST(host->sound_stop(host->context, body + B_BUTTON_SOUND));')
k('final busy stop not announced', 'fx(host, ALC_FX_SOUND_STOP, B_FINAL_SOUND, 0);', '(void)0;')
k('final busy phase not asked', 'fx(host, ALC_FX_SOUND_STOP, B_FINAL_SOUND, 0);\n            *row_phase = 2u;', 'fx(host, ALC_FX_SOUND_STOP, B_FINAL_SOUND, 0);')
k('final busy phase not announced', '*row_phase = 2u;\n            fx(host, ALC_FX_PHASE, 2, 0);\n        }\n        break;\n    }\n    default:', '*row_phase = 2u;\n        }\n        break;\n    }\n    default:')
k('final busy not announced', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_stop', 'if (busy == 0) {\n            HOST(host->sound_stop')
k('final busy failure ignored', 'HOST(host->sound_busy(host->context, ch, &busy));\n        fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_stop', '(void)host->sound_busy(host->context, ch, &busy);\n        fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_stop')
k('final busy stop failure ignored', 'HOST(host->sound_stop(host->context, body + B_FINAL_SOUND));', '(void)host->sound_stop(host->context, body + B_FINAL_SOUND);')
k('states above eight do something', 'default:\n        break;\n    }\n    return ALC_OK;\n}\n\n/* 0x44ddc4', 'default:\n        o->dirty = 1;\n        break;\n    }\n    return ALC_OK;\n}\n\n/* 0x44ddc4')
# --- phase 2 and the visit ---------------------------------------------------------------------------------------------------
k('phase 2 start flag not set', 'world->start_flag_5bb1ca = 1;\n    fx(host, ALC_FX_START_FLAG, 1, 0);\n    if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop',
  'fx(host, ALC_FX_START_FLAG, 1, 0);\n    if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop')
k('phase 2 start flag not announced', 'fx(host, ALC_FX_START_FLAG, 1, 0);\n    if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop', 'if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop')
k('phase 2 sound test inverted', 'if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop', 'if (no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop')
k('phase 2 sound always stopped', 'if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop', 'if (1) {\n        HOST(host->sound_stop')
k('phase 2 stops the final record', 'HOST(host->sound_stop(host->context, body + B_BUTTON_SOUND));', 'HOST(host->sound_stop(host->context, body + B_FINAL_SOUND));')
k('phase 2 stop not announced', 'fx(host, ALC_FX_SOUND_STOP, B_BUTTON_SOUND, 0);', '(void)0;')
k('phase 2 stop failure ignored', 'HOST(host->sound_stop(host->context, body + B_BUTTON_SOUND));', '(void)host->sound_stop(host->context, body + B_BUTTON_SOUND);')
k('phase 2 cancel ignored', 'if (o->canceled != 0) return apply_block(body + B_CANCEL_BLOCK, world, host);', '(void)0;')
k('phase 2 cancel block wrong', 'if (o->canceled != 0) return apply_block(body + B_CANCEL_BLOCK, world, host);', 'if (o->canceled != 0) return apply_block(body + B_SET_BLOCK, world, host);')
k('phase 2 set block wrong', 'return apply_block(body + B_SET_BLOCK, world, host);\n    }\n    return ALC_OK;', 'return apply_block(body + B_CANCEL_BLOCK, world, host);\n    }\n    return ALC_OK;')
k('phase 2 set before cancel', 'if (o->canceled != 0) return apply_block(body + B_CANCEL_BLOCK, world, host);\n    if (o->set != 0) {\n        write_alarm(o, world, host);\n        return apply_block(body + B_SET_BLOCK, world, host);\n    }',
  'if (o->set != 0) {\n        write_alarm(o, world, host);\n        return apply_block(body + B_SET_BLOCK, world, host);\n    }\n    if (o->canceled != 0) return apply_block(body + B_CANCEL_BLOCK, world, host);')
k('phase 2 set ignored', 'if (o->set != 0) {\n        write_alarm(o, world, host);', 'if (0) {\n        write_alarm(o, world, host);')
k('phase 2 always sets', 'if (o->set != 0) {\n        write_alarm(o, world, host);', 'if (1) {\n        write_alarm(o, world, host);')
k('phase 2 alarm not written', 'write_alarm(o, world, host);\n        return', 'return')
k('step host check lost', 'host->mark_dirty != NULL && host->view_origin != NULL', 'host->view_origin != NULL')
k('step idle timer check lost', 'host->touch_idle_timer != NULL', '1')
k('step observer required', 'if (host->observe != NULL) host->observe', 'if (1) host->observe')
k('step phase 0 row 0 refused', 'if (row < 0) {', 'if (row <= 0) {')
k('step negative row accepted', 'if (row < 0) {', 'if (0) {')
k('step row failure text', '"0xaa-row"', '"x"')
k('step argument text', '"0xaa-argument"', '"x"')
k('step phase 1 without active', 'if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xaa-phase-1-without-init";', 'if (object->row != row) {\n            if (failure != NULL) *failure = "0xaa-phase-1-without-init";')
k('step phase 1 any row', 'if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xaa-phase-1-without-init";', 'if (object->active == 0) {\n            if (failure != NULL) *failure = "0xaa-phase-1-without-init";')
k('step phase 2 without active', 'if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xaa-phase-2-without-init";', 'if (object->row != row) {\n            if (failure != NULL) *failure = "0xaa-phase-2-without-init";')
k('step phase 2 any row', 'if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xaa-phase-2-without-init";', 'if (object->active == 0) {\n            if (failure != NULL) *failure = "0xaa-phase-2-without-init";')
k('step phase 1 text', '"0xaa-phase-1-without-init"', '"x"')
k('step phase 2 text', '"0xaa-phase-2-without-init"', '"x"')
k('step flag precheck skipped', 'if (flag != ALC_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (0) {')
k('step flag precheck on none', 'if (flag != ALC_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (host->event_flag_invalid(host->context, flag) != 0) {')
k('step flag precheck always', 'if (flag != ALC_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (flag != ALC_NO_FLAG) {')
k('step flag precheck set block first', 'object->canceled != 0 ? body + B_CANCEL_BLOCK : (object->set != 0 ? body + B_SET_BLOCK : NULL)', 'object->set != 0 ? body + B_SET_BLOCK : (object->canceled != 0 ? body + B_CANCEL_BLOCK : NULL)')
k('step flag precheck wrong block', 'object->canceled != 0 ? body + B_CANCEL_BLOCK : (object->set != 0 ? body + B_SET_BLOCK : NULL)', 'object->canceled != 0 ? body + B_SET_BLOCK : (object->set != 0 ? body + B_SET_BLOCK : NULL)')
k('step flag precheck always a block', 'object->canceled != 0 ? body + B_CANCEL_BLOCK : (object->set != 0 ? body + B_SET_BLOCK : NULL)', 'object->canceled != 0 ? body + B_CANCEL_BLOCK : body + B_SET_BLOCK')
k('step flag precheck text', '"0xaa-event-flag-index"', '"x"')
k('step flag precheck status', 'return ALC_ERR_BOUNDS;\n                }\n            }\n        }\n        rc = phase2', 'return ALC_ERR_HOST;\n                }\n            }\n        }\n        rc = phase2')
k('step completion not reported', 'result->completed = 1u;', '(void)0;')
k('step completion phase kept', 'row_phase = 0u; /* 0x42ba3a stores phase 0 */', '(void)0;')
k('step no cleanup after the finish', 'rc = alc_cleanup(object, host);\n        }\n    } else {', 'rc = ALC_OK;\n        }\n    } else {')
k('step completion not announced', 'fx(host, ALC_FX_COMPLETE, object->row, 0);', '(void)0;')
k('step completion row wrong', 'fx(host, ALC_FX_COMPLETE, object->row, 0);', 'fx(host, ALC_FX_COMPLETE, 0, 0);')
k('step phase 1 announced', 'fx(host, ALC_FX_PHASE, 1, 0);\n            result->initialized = 1u;', 'result->initialized = 1u;')
k('step initialisation not reported', 'result->initialized = 1u;', '(void)0;')
k('step phase 0 not advanced', 'row_phase = 1u;\n            fx(host, ALC_FX_PHASE, 1, 0);', 'fx(host, ALC_FX_PHASE, 1, 0);')
k('step host failure text lost', 'if (rc != ALC_OK && failure != NULL && *failure == NULL) *failure = "0xaa-host";', '(void)0;')
k('step phase after lost', 'result->phase_after = row_phase;\n    return rc;', 'return rc;')
k('step result not cleared', 'memset(result, 0, sizeof(*result));\n    result->phase_after = phase;', 'result->phase_after = phase;')
k('step phase after not preset', 'result->phase_after = phase;\n    if (alc_validate_body', 'if (alc_validate_body')
k('step other phases act as phase 1', '} else {\n        rc = ALC_OK; /* 0x44da53: any other phase falls out of the switch */', '} else if (object->active != 0 && object->row == row) {\n        rc = phase1(object, body, &row_phase, host);\n    } else {\n        rc = ALC_OK; /* 0x44da53: any other phase falls out of the switch */')
k('step body validation lost', 'if (alc_validate_body(body, body_length, &why) != ALC_OK) {\n        if (failure != NULL) *failure = why;', 'if (0) {\n        if (failure != NULL) *failure = why;')
k('step body failure text lost', 'if (alc_validate_body(body, body_length, &why) != ALC_OK) {\n        if (failure != NULL) *failure = why;', 'if (alc_validate_body(body, body_length, &why) != ALC_OK) {\n        if (failure != NULL) *failure = NULL;')
k('step failure not cleared', 'if (failure != NULL) *failure = NULL;\n    if (object == NULL', 'if (object == NULL')
# --- the pointer -------------------------------------------------------------------------------------------------------------
k('rect top exclusive', 'return rd_s32(body, rect + 4) <= y &&', 'return rd_s32(body, rect + 4) < y &&')
k('rect bottom exclusive', 'y <= rd_s32(body, rect + 12) &&', 'y < rd_s32(body, rect + 12) &&')
k('rect left exclusive', 'rd_s32(body, rect) <= x &&', 'rd_s32(body, rect) < x &&')
k('rect right exclusive', 'x <= rd_s32(body, rect + 8);', 'x < rd_s32(body, rect + 8);')
k('rect right edge wrong offset', 'x <= rd_s32(body, rect + 8);', 'x <= rd_s32(body, rect + 12);')
k('rect top edge wrong offset', 'rd_s32(body, rect + 4) <= y &&', 'rd_s32(body, rect) <= y &&')
k('rect bottom edge wrong offset', 'y <= rd_s32(body, rect + 12) &&', 'y <= rd_s32(body, rect + 8) &&')
k('rect left edge wrong offset', 'rd_s32(body, rect) <= x &&', 'rd_s32(body, rect + 4) <= x &&')
k('press cursor kind wrong', 'out->cursor_kind = rd_s16(body, B_CURSOR_KIND);', 'out->cursor_kind = rd_s16(body, B_PRESS_DELAY);')
k('press cursor unsigned', 'out->cursor_kind = rd_s16(body, B_CURSOR_KIND);', 'out->cursor_kind = (uint16_t)rd_s16(body, B_CURSOR_KIND);')
k('press cursor not flagged', 'out->cursor_written = 1u;\n    out->cursor_kind', 'out->cursor_kind')
k('press cursor sub wrong', 'out->cursor_sub = 1;', 'out->cursor_sub = 0;')
k('press candidate wrong', 'out->candidate = ALC_CANDIDATE_BUTTON;', 'out->candidate = 0;')
k('press redraw lost', 'o->dirty = 1;\n    o->button = button;', 'o->button = button;')
k('press button lost', 'o->button = button;\n}', '(void)button;\n}')
k('pointer result not cleared', 'memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (object->active == 0) {', 'out->candidate = -1;\n    if (object->active == 0) {')
k('pointer candidate default', 'out->candidate = -1;\n    if (object->active == 0) {', 'out->candidate = 0;\n    if (object->active == 0) {')
k('pointer inactive acts', 'if (object->active == 0) {\n        object->dirty = 0;\n        return ALC_OK;\n    }', '(void)0;')
k('pointer inactive keeps the redraw', 'object->dirty = 0;\n        return ALC_OK;\n    }\n    x = (int16_t)x;', 'return ALC_OK;\n    }\n    x = (int16_t)x;')
k('pointer x not truncated', 'x = (int16_t)x; /* movsx word */', '(void)0;')
k('pointer y not truncated', 'y = (int16_t)y;', '(void)0;')
k('pointer redraw lost', 'y = (int16_t)y;\n    object->dirty = 1;', 'y = (int16_t)y;')
k('pointer right bound', 'if (x > rd_s32(body, B_INCREASE_BTN + 8)', 'if (x >= rd_s32(body, B_INCREASE_BTN + 8)')
k('pointer right bound from the wrong rectangle', 'if (x > rd_s32(body, B_INCREASE_BTN + 8)', 'if (x > rd_s32(body, B_DECREASE_BTN + 8)')
k('pointer right bound unchecked', 'if (x > rd_s32(body, B_INCREASE_BTN + 8) ||', 'if (')
k('pointer bottom bound', '|| y > rd_s32(body, B_CANCEL_BTN + 12)', '|| y >= rd_s32(body, B_CANCEL_BTN + 12)')
k('pointer bottom bound from the wrong rectangle', '|| y > rd_s32(body, B_CANCEL_BTN + 12)', '|| y > rd_s32(body, B_SET_BTN + 12)')
k('pointer bottom bound unchecked', '|| y > rd_s32(body, B_CANCEL_BTN + 12) ||', '||')
k('pointer left bound', '|| x < rd_s32(body, B_TIME_BTN)) {', '|| x <= rd_s32(body, B_TIME_BTN)) {')
k('pointer left bound from the wrong rectangle', '|| x < rd_s32(body, B_TIME_BTN)) {', '|| x < rd_s32(body, B_ALARM_BTN)) {')
k('pointer left bound unchecked', '|| x < rd_s32(body, B_TIME_BTN)) {', ') {')
k('pointer outside keeps over', 'object->over = 0;\n        return ALC_OK;\n    }\n    object->over = 1;', 'return ALC_OK;\n    }\n    object->over = 1;')
k('pointer inside leaves over', 'object->over = 1;\n    if (object->state == ALC_STATE_TIME', 'if (object->state == ALC_STATE_TIME')
k('pointer alarm button in any state', 'if (object->state == ALC_STATE_TIME && in_rect(body, B_ALARM_BTN, x, y)) {', 'if (in_rect(body, B_ALARM_BTN, x, y)) {')
k('pointer alarm button never', 'if (object->state == ALC_STATE_TIME && in_rect(body, B_ALARM_BTN, x, y)) {', 'if (0) {')
k('pointer alarm button in alarm state', 'if (object->state == ALC_STATE_TIME && in_rect(body, B_ALARM_BTN, x, y)) {', 'if (object->state == ALC_STATE_ALARM && in_rect(body, B_ALARM_BTN, x, y)) {')
k('pointer alarm button number', 'press(object, body, 1, out);', 'press(object, body, 0, out);')
k('pointer alarm button does not claim', 'press(object, body, 1, out);\n        out->hit = 1u;', 'press(object, body, 1, out);')
k('pointer alarm state test', 'if (object->state == ALC_STATE_ALARM) {\n        static const', 'if (object->state != ALC_STATE_TIME) {\n        static const')
k('pointer alarm state never', 'if (object->state == ALC_STATE_ALARM) {\n        static const', 'if (0) {\n        static const')
k('pointer time button number', '{B_TIME_BTN, 0}', '{B_TIME_BTN, 1}')
k('pointer increase button number', '{B_INCREASE_BTN, 3}', '{B_INCREASE_BTN, 4}')
k('pointer decrease button number', '{B_DECREASE_BTN, 4}', '{B_DECREASE_BTN, 3}')
k('pointer set button number', '{B_SET_BTN, 6}', '{B_SET_BTN, 5}')
k('pointer button order', '{B_TIME_BTN, 0}, {B_INCREASE_BTN, 3}', '{B_INCREASE_BTN, 3}, {B_TIME_BTN, 0}')
k('pointer button order decrease', '{B_INCREASE_BTN, 3}, {B_DECREASE_BTN, 4}', '{B_DECREASE_BTN, 4}, {B_INCREASE_BTN, 3}')
k('pointer button order set', '{B_DECREASE_BTN, 4}, {B_SET_BTN, 6}', '{B_SET_BTN, 6}, {B_DECREASE_BTN, 4}')
k('pointer button scan one short', 'i < sizeof(order) / sizeof(order[0]); ++i) {\n            if (in_rect', 'i + 1 < sizeof(order) / sizeof(order[0]); ++i) {\n            if (in_rect')
k('pointer button does not claim', 'press(object, body, order[i].button, out);\n                out->hit = 1u;', 'press(object, body, order[i].button, out);')
k('pointer cancel button rectangle', 'if (in_rect(body, B_CANCEL_BTN, x, y)) {', 'if (in_rect(body, B_SET_BTN, x, y)) {')
k('pointer cancel button never', 'if (in_rect(body, B_CANCEL_BTN, x, y)) {', 'if (0) {')
k('pointer cancel button live only in the alarm state', 'if (in_rect(body, B_CANCEL_BTN, x, y)) {', 'if (object->state == ALC_STATE_ALARM && in_rect(body, B_CANCEL_BTN, x, y)) {')
k('pointer cancel button number', 'press(object, body, 8, out);', 'press(object, body, 7, out);')
k('pointer cancel button does not claim', 'press(object, body, 8, out);\n        out->hit = 1u;', 'press(object, body, 8, out);')
k('pointer minute digits not redrawn', 'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {',
  'if (in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {')
k('pointer hour digits not redrawn', 'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {',
  'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {')
k('pointer light not redrawn', 'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {',
  'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y)) {')
k('pointer am/pm redrawn', 'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {',
  'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y) || in_rect(body, B_AMPM_DST, x, y)) {')
k('pointer digits claim', 'object->dirty = 1;\n        return ALC_OK;\n    }\n    object->dirty = 0;', 'object->dirty = 1;\n        out->hit = 1u;\n        return ALC_OK;\n    }\n    object->dirty = 0;')
k('pointer elsewhere keeps the redraw', 'object->dirty = 0;\n    return ALC_OK;\n}\n\nint alc_click', 'return ALC_OK;\n}\n\nint alc_click')
k('pointer body not validated', 'if (object == NULL || body == NULL || out == NULL || alc_validate_body(body, body_length, NULL) != ALC_OK)\n        return ALC_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->candidate = -1;',
  'if (object == NULL || body == NULL || out == NULL)\n        return ALC_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->candidate = -1;')
# --- the click ---------------------------------------------------------------------------------------------------------------
k('click gate ignores the active flag', 'if (!(object->active != 0 && object->canceled == 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;', 'if (!(object->canceled == 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;')
k('click gate ignores the canceled flag', 'if (!(object->active != 0 && object->canceled == 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;', 'if (!(object->active != 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;')
k('click gate ignores the pointer', 'if (!(object->active != 0 && object->canceled == 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;', 'if (!(object->active != 0 && object->canceled == 0 && row_phase == 1u)) return ALC_OK;')
k('click gate ignores the row phase', 'if (!(object->active != 0 && object->canceled == 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;', 'if (!(object->active != 0 && object->canceled == 0 && object->over != 0)) return ALC_OK;')
k('click gate canceled inverted', 'object->canceled == 0 && object->over != 0 && row_phase == 1u', 'object->canceled != 0 && object->over != 0 && row_phase == 1u')
k('click gate any phase above zero', 'object->over != 0 && row_phase == 1u', 'object->over != 0 && row_phase >= 1u')
k('click sound without the process flag', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {', 'if (!no_sound(body + B_BUTTON_SOUND)) {')
k('click sound ignores the record', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {', 'if (world->start_flag_5bb1ca != 0) {')
k('click sound flag inverted', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {', 'if (world->start_flag_5bb1ca == 0 && !no_sound(body + B_BUTTON_SOUND)) {')
k('click sound flag is 1', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {', 'if (world->start_flag_5bb1ca == 1 && !no_sound(body + B_BUTTON_SOUND)) {')
k('click sound flag positive', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {', 'if (world->start_flag_5bb1ca > 0 && !no_sound(body + B_BUTTON_SOUND)) {')
k('click sound record test inverted', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {', 'if (world->start_flag_5bb1ca != 0 && no_sound(body + B_BUTTON_SOUND)) {')
k('click sound channel wrong', 'const int16_t ch = rd_s16(body, B_BUTTON_CHANNEL);\n        int32_t busy = 0;', 'const int16_t ch = rd_s16(body, B_FINAL_CHANNEL);\n        int32_t busy = 0;')
k('click sound busy test inverted', 'if (busy == 0) {\n            HOST(host->sound_play(host->context, ch));\n            fx(host, ALC_FX_SOUND_PLAY, ch, 0);\n            out->sound_played', 'if (busy != 0) {\n            HOST(host->sound_play(host->context, ch));\n            fx(host, ALC_FX_SOUND_PLAY, ch, 0);\n            out->sound_played')
k('click sound ignores busy', 'if (busy == 0) {\n            HOST(host->sound_play', 'if (1) {\n            HOST(host->sound_play')
k('click sound busy not announced', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_play', 'if (busy == 0) {\n            HOST(host->sound_play')
k('click sound play not announced', 'fx(host, ALC_FX_SOUND_PLAY, ch, 0);\n            out->sound_played', 'out->sound_played')
k('click sound not marked played', 'out->sound_played = 1u;', '(void)0;')
k('click busy failure ignored', 'HOST(host->sound_busy(host->context, ch, &busy));\n        fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_play', '(void)host->sound_busy(host->context, ch, &busy);\n        fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_play')
k('click play failure ignored', 'HOST(host->sound_play(host->context, ch));\n            fx(host, ALC_FX_SOUND_PLAY, ch, 0);\n            out->sound_played', '(void)host->sound_play(host->context, ch);\n            fx(host, ALC_FX_SOUND_PLAY, ch, 0);\n            out->sound_played')
k('click state not pressed', 'object->state = ALC_STATE_PRESSED;\n    {\n        const uint32_t now', '{\n        const uint32_t now')
k('click state wrong', 'object->state = ALC_STATE_PRESSED;\n    {\n        const uint32_t now', 'object->state = ALC_STATE_ALARM;\n    {\n        const uint32_t now')
k('click tick not announced', 'const uint32_t now = host->tick(host->context);\n        fx(host, ALC_FX_TICK, (int32_t)now, 0);\n        object->press_deadline', 'const uint32_t now = host->tick(host->context);\n        object->press_deadline')
k('click deadline in seconds', '(int32_t)rd_s16(body, B_PRESS_DELAY) * 100)', '(int32_t)rd_s16(body, B_PRESS_DELAY) * 1000)')
k('click deadline in ten ms', '(int32_t)rd_s16(body, B_PRESS_DELAY) * 100)', '(int32_t)rd_s16(body, B_PRESS_DELAY) * 10)')
k('click deadline unsigned', '(int32_t)rd_s16(body, B_PRESS_DELAY) * 100)', '(int32_t)(uint16_t)rd_s16(body, B_PRESS_DELAY) * 100)')
k('click deadline from the wrong word', 'rd_s16(body, B_PRESS_DELAY)', 'rd_s16(body, B_CURSOR_KIND)')
k('click deadline not added to now', 'object->press_deadline = now + (uint32_t)', 'object->press_deadline = 0u + (uint32_t)')
k('click redraw lost', 'object->dirty = 1;\n    out->fired = 1u;', 'out->fired = 1u;')
k('click not reported', 'out->fired = 1u;', '(void)0;')
k('click result not cleared', 'memset(out, 0, sizeof(*out));\n    if (!(object->active', 'if (!(object->active')
k('click body not validated', 'if (object == NULL || body == NULL || world == NULL || out == NULL || !host_complete(host) ||\n        alc_validate_body(body, body_length, NULL) != ALC_OK)\n        return ALC_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (!(object->active',
  'if (object == NULL || body == NULL || world == NULL || out == NULL || !host_complete(host))\n        return ALC_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (!(object->active')
k('click world not required', 'if (object == NULL || body == NULL || world == NULL || out == NULL || !host_complete(host) ||\n        alc_validate_body(body, body_length, NULL) != ALC_OK)\n        return ALC_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (!(object->active',
  'if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        alc_validate_body(body, body_length, NULL) != ALC_OK)\n        return ALC_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (!(object->active')
# --- invalidate and cleanup --------------------------------------------------------------------------------------------------
k('invalidate inactive', 'if (object->active != 0 && object->slot != ALC_NO_SLOT) HOST', 'if (object->slot != ALC_NO_SLOT) HOST')
k('invalidate without a slot', 'if (object->active != 0 && object->slot != ALC_NO_SLOT) HOST', 'if (object->active != 0) HOST')
k('invalidate slot zero', 'object->slot != ALC_NO_SLOT) HOST', 'object->slot > 0) HOST')
k('invalidate never', 'if (object->active != 0 && object->slot != ALC_NO_SLOT) HOST(host->mark_dirty(host->context, object->slot));', '(void)0;')
k('invalidate wrong slot', 'host->mark_dirty(host->context, object->slot)', 'host->mark_dirty(host->context, 0)')
k('invalidate failure ignored', 'HOST(host->mark_dirty(host->context, object->slot));', '(void)host->mark_dirty(host->context, object->slot);')
k('invalidate host check lost', 'if (object == NULL || host == NULL || host->mark_dirty == NULL) return ALC_ERR_ARGUMENT;', 'if (object == NULL || host == NULL) return ALC_ERR_ARGUMENT;')
k('cleanup surface always released', 'if (object->surface != 0u) {\n        const uint32_t surface', 'if (1) {\n        const uint32_t surface')
k('cleanup surface never released', 'if (object->surface != 0u) {\n        const uint32_t surface', 'if (0) {\n        const uint32_t surface')
k('cleanup surface kept', 'HOST(host->release_surface(host->context, surface));\n        object->surface = 0u;', 'HOST(host->release_surface(host->context, surface));')
k('cleanup surface not announced', 'fx(host, ALC_FX_RELEASE_SURFACE, (int32_t)surface, 0);', '(void)0;')
k('cleanup surface failure ignored', 'HOST(host->release_surface(host->context, surface));', '(void)host->release_surface(host->context, surface);')
k('cleanup slot always released', 'if (object->slot != ALC_NO_SLOT) {\n        const int16_t slot', 'if (1) {\n        const int16_t slot')
k('cleanup slot never released', 'if (object->slot != ALC_NO_SLOT) {\n        const int16_t slot', 'if (0) {\n        const int16_t slot')
k('cleanup slot zero kept', 'if (object->slot != ALC_NO_SLOT) {\n        const int16_t slot', 'if (object->slot > 0) {\n        const int16_t slot')
k('cleanup slot not announced', 'fx(host, ALC_FX_RELEASE_SLOT, slot, 0);', '(void)0;')
k('cleanup slot failure ignored', 'HOST(host->release_slot(host->context, slot));', '(void)host->release_slot(host->context, slot);')
k('cleanup row kept', 'object->row = -1; /* 0x44d107 */', '(void)0;')
k('cleanup slot kept', 'object->slot = ALC_NO_SLOT;\n    object->active = 0;', 'object->active = 0;')
k('cleanup stays active', 'object->active = 0;\n    object->canceled = 0;', 'object->canceled = 0;')
k('cleanup canceled kept', 'object->canceled = 0;\n    object->set = 0;\n    HOST(host->touch_idle_timer', 'object->set = 0;\n    HOST(host->touch_idle_timer')
k('cleanup set kept', 'object->set = 0;\n    HOST(host->touch_idle_timer', 'HOST(host->touch_idle_timer')
k('cleanup wipes the object', 'object->set = 0;\n    HOST(host->touch_idle_timer', 'object->set = 0;\n    object->state = 0;\n    HOST(host->touch_idle_timer')
k('cleanup wipes the digits', 'object->set = 0;\n    HOST(host->touch_idle_timer', 'object->set = 0;\n    object->alarm_hour = 0;\n    HOST(host->touch_idle_timer')
k('cleanup idle timer failure ignored', 'HOST(host->touch_idle_timer(host->context));', '(void)host->touch_idle_timer(host->context);')
k('cleanup idle timer not touched', 'HOST(host->touch_idle_timer(host->context));\n    fx(host, ALC_FX_IDLE_TIMER, 0, 0);', 'fx(host, ALC_FX_IDLE_TIMER, 0, 0);')
k('cleanup idle timer not announced', 'fx(host, ALC_FX_IDLE_TIMER, 0, 0);', '(void)0;')
k('cleanup host check lost', 'host->release_surface == NULL || host->release_slot == NULL ||\n        host->touch_idle_timer == NULL', 'host->release_surface == NULL || host->release_slot == NULL')
k('cleanup surface check lost', 'host->release_surface == NULL || host->release_slot == NULL ||\n        host->touch_idle_timer == NULL', 'host->release_slot == NULL ||\n        host->touch_idle_timer == NULL')
k('cleanup slot check lost', 'host->release_surface == NULL || host->release_slot == NULL ||\n        host->touch_idle_timer == NULL', 'host->release_surface == NULL ||\n        host->touch_idle_timer == NULL')
# --- the render callback -----------------------------------------------------------------------------------------------------
k('render without a slot', 'if (object->slot == ALC_NO_SLOT) return ALC_OK;\n    out->valid = 1u;', 'out->valid = 1u;')
k('render valid flag lost', 'out->valid = 1u;\n    showing_time', 'showing_time')
k('render time mode without cancel', 'object->state == ALC_STATE_TIME || object->state == ALC_STATE_CANCEL ||', 'object->state == ALC_STATE_TIME ||')
k('render time mode without time', 'object->state == ALC_STATE_TIME || object->state == ALC_STATE_CANCEL ||', 'object->state == ALC_STATE_CANCEL ||')
k('render time mode while any button pressed', '(object->state == ALC_STATE_PRESSED && object->button == ALC_STATE_CANCEL)', '(object->state == ALC_STATE_PRESSED)')
k('render time mode while pressed never', '(object->state == ALC_STATE_PRESSED && object->button == ALC_STATE_CANCEL)', '0')
k('render time mode on the time button', '(object->state == ALC_STATE_PRESSED && object->button == ALC_STATE_CANCEL)', '(object->state == ALC_STATE_PRESSED && object->button == 0)')
k('render hour from the other mode', 'hour = showing_time ? object->time_hour : object->alarm_hour;', 'hour = showing_time ? object->alarm_hour : object->time_hour;')
k('render quarter from the other mode', 'quarter = showing_time ? object->time_quarter : object->alarm_quarter;', 'quarter = showing_time ? object->alarm_quarter : object->time_quarter;')
k('render am from the other mode', 'am = showing_time ? object->time_am : object->alarm_am;', 'am = showing_time ? object->alarm_am : object->time_am;')
k('render hour below zero', 'if (hour < 0 || hour > 11 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;', 'if (hour > 11 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;')
k('render hour above eleven', 'if (hour < 0 || hour > 11 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;', 'if (hour < 0 || hour > 12 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;')
k('render hour eleven refused', 'if (hour < 0 || hour > 11 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;', 'if (hour < 0 || hour > 10 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;')
k('render quarter below zero', 'if (hour < 0 || hour > 11 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;', 'if (hour < 0 || hour > 11 || quarter > 3) return ALC_ERR_BOUNDS;')
k('render quarter above three', 'if (hour < 0 || hour > 11 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;', 'if (hour < 0 || hour > 11 || quarter < 0 || quarter > 4) return ALC_ERR_BOUNDS;')
k('render quarter three refused', 'if (hour < 0 || hour > 11 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;', 'if (hour < 0 || hour > 11 || quarter < 0 || quarter > 2) return ALC_ERR_BOUNDS;')
k('render bounds unchecked', 'if (hour < 0 || hour > 11 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;', '(void)0;')
k('render origin failure ignored', 'HOST(host->view_origin(host->context, &vx, &vy));', '(void)host->view_origin(host->context, &vx, &vy);')
k('render am overlay inverted', 'add_blit(out, am != 0 ? ALC_BLIT_AM : ALC_BLIT_PM, object->surface, body, am != 0 ? B_AM_SRC : B_PM_SRC, B_AMPM_DST,',
  'add_blit(out, am == 0 ? ALC_BLIT_AM : ALC_BLIT_PM, object->surface, body, am != 0 ? B_AM_SRC : B_PM_SRC, B_AMPM_DST,')
k('render am source inverted', 'am != 0 ? B_AM_SRC : B_PM_SRC, B_AMPM_DST,', 'am == 0 ? B_AM_SRC : B_PM_SRC, B_AMPM_DST,')
k('render am destination', 'am != 0 ? B_AM_SRC : B_PM_SRC, B_AMPM_DST,', 'am != 0 ? B_AM_SRC : B_PM_SRC, B_LIGHT_DST,')
k('render light inverted', 'add_blit(out, showing_time ? ALC_BLIT_LIGHT_TIME : ALC_BLIT_LIGHT_ALARM, object->surface, body,\n             showing_time ? B_TIME_LIGHT : B_ALARM_LIGHT, B_LIGHT_DST, vx, vy);',
  'add_blit(out, showing_time ? ALC_BLIT_LIGHT_ALARM : ALC_BLIT_LIGHT_TIME, object->surface, body,\n             showing_time ? B_TIME_LIGHT : B_ALARM_LIGHT, B_LIGHT_DST, vx, vy);')
k('render light source inverted', 'showing_time ? B_TIME_LIGHT : B_ALARM_LIGHT, B_LIGHT_DST', 'showing_time ? B_ALARM_LIGHT : B_TIME_LIGHT, B_LIGHT_DST')
k('render light destination', 'showing_time ? B_TIME_LIGHT : B_ALARM_LIGHT, B_LIGHT_DST', 'showing_time ? B_TIME_LIGHT : B_ALARM_LIGHT, B_AMPM_DST')
k('render hour stride', 'B_HOUR_SRC + (size_t)hour * 16u', 'B_HOUR_SRC + (size_t)hour * 8u')
k('render hour from the minute table', 'B_HOUR_SRC + (size_t)hour * 16u', 'B_MINUTE_SRC + (size_t)hour * 16u')
k('render hour destination', 'B_HOUR_SRC + (size_t)hour * 16u, B_HOUR_DST', 'B_HOUR_SRC + (size_t)hour * 16u, B_MINUTE_DST')
k('render hour surface', 'add_blit(out, ALC_BLIT_HOUR, object->surface,', 'add_blit(out, ALC_BLIT_HOUR, 0u,')
k('render hour kind', 'add_blit(out, ALC_BLIT_HOUR,', 'add_blit(out, ALC_BLIT_MINUTE,')
k('render minute stride', 'B_MINUTE_SRC + (size_t)quarter * 16u', 'B_MINUTE_SRC + (size_t)quarter * 8u')
k('render minute destination', 'B_MINUTE_SRC + (size_t)quarter * 16u, B_MINUTE_DST', 'B_MINUTE_SRC + (size_t)quarter * 16u, B_HOUR_DST')
k('render minute surface', 'add_blit(out, ALC_BLIT_MINUTE, object->surface,', 'add_blit(out, ALC_BLIT_MINUTE, 0u,')
k('render pressed test', 'if (object->state == ALC_STATE_PRESSED) {\n        switch', 'if (object->state != ALC_STATE_PRESSED) {\n        switch')
k('render pressed time button', 'case 0: add_blit(out, ALC_BLIT_DOWN_TIME, object->surface, body, B_TIME_DOWN, B_TIME_BTN, vx, vy); break;', 'case 0: break;')
k('render pressed time button source', 'ALC_BLIT_DOWN_TIME, object->surface, body, B_TIME_DOWN, B_TIME_BTN', 'ALC_BLIT_DOWN_TIME, object->surface, body, B_ALARM_DOWN, B_TIME_BTN')
k('render pressed time button destination', 'ALC_BLIT_DOWN_TIME, object->surface, body, B_TIME_DOWN, B_TIME_BTN', 'ALC_BLIT_DOWN_TIME, object->surface, body, B_TIME_DOWN, B_ALARM_BTN')
k('render pressed alarm button', 'case 1: add_blit(out, ALC_BLIT_DOWN_ALARM, object->surface, body, B_ALARM_DOWN, B_ALARM_BTN, vx, vy); break;', 'case 1: break;')
k('render pressed alarm button source', 'ALC_BLIT_DOWN_ALARM, object->surface, body, B_ALARM_DOWN, B_ALARM_BTN', 'ALC_BLIT_DOWN_ALARM, object->surface, body, B_TIME_DOWN, B_ALARM_BTN')
k('render pressed alarm button destination', 'ALC_BLIT_DOWN_ALARM, object->surface, body, B_ALARM_DOWN, B_ALARM_BTN', 'ALC_BLIT_DOWN_ALARM, object->surface, body, B_ALARM_DOWN, B_TIME_BTN')
k('render pressed increase button', 'case 3: add_blit(out, ALC_BLIT_DOWN_INCREASE, object->surface, body, B_INCREASE_DOWN, B_INCREASE_BTN, vx, vy); break;', 'case 3: break;')
k('render pressed increase button source', 'ALC_BLIT_DOWN_INCREASE, object->surface, body, B_INCREASE_DOWN, B_INCREASE_BTN', 'ALC_BLIT_DOWN_INCREASE, object->surface, body, B_DECREASE_DOWN, B_INCREASE_BTN')
k('render pressed increase button destination', 'ALC_BLIT_DOWN_INCREASE, object->surface, body, B_INCREASE_DOWN, B_INCREASE_BTN', 'ALC_BLIT_DOWN_INCREASE, object->surface, body, B_INCREASE_DOWN, B_DECREASE_BTN')
k('render pressed decrease button', 'case 4: add_blit(out, ALC_BLIT_DOWN_DECREASE, object->surface, body, B_DECREASE_DOWN, B_DECREASE_BTN, vx, vy); break;', 'case 4: break;')
k('render pressed decrease button source', 'ALC_BLIT_DOWN_DECREASE, object->surface, body, B_DECREASE_DOWN, B_DECREASE_BTN', 'ALC_BLIT_DOWN_DECREASE, object->surface, body, B_INCREASE_DOWN, B_DECREASE_BTN')
k('render pressed decrease button destination', 'ALC_BLIT_DOWN_DECREASE, object->surface, body, B_DECREASE_DOWN, B_DECREASE_BTN', 'ALC_BLIT_DOWN_DECREASE, object->surface, body, B_DECREASE_DOWN, B_INCREASE_BTN')
k('render pressed set button', 'case 6: add_blit(out, ALC_BLIT_DOWN_SET, object->surface, body, B_SET_DOWN, B_SET_BTN, vx, vy); break;', 'case 6: break;')
k('render pressed set button source', 'ALC_BLIT_DOWN_SET, object->surface, body, B_SET_DOWN, B_SET_BTN', 'ALC_BLIT_DOWN_SET, object->surface, body, B_CANCEL_DOWN, B_SET_BTN')
k('render pressed set button destination', 'ALC_BLIT_DOWN_SET, object->surface, body, B_SET_DOWN, B_SET_BTN', 'ALC_BLIT_DOWN_SET, object->surface, body, B_SET_DOWN, B_CANCEL_BTN')
k('render pressed cancel button', 'case 8: add_blit(out, ALC_BLIT_DOWN_CANCEL, object->surface, body, B_CANCEL_DOWN, B_CANCEL_BTN, vx, vy); break;', 'case 8: break;')
k('render pressed cancel button source', 'ALC_BLIT_DOWN_CANCEL, object->surface, body, B_CANCEL_DOWN, B_CANCEL_BTN', 'ALC_BLIT_DOWN_CANCEL, object->surface, body, B_SET_DOWN, B_CANCEL_BTN')
k('render pressed cancel button destination', 'ALC_BLIT_DOWN_CANCEL, object->surface, body, B_CANCEL_DOWN, B_CANCEL_BTN', 'ALC_BLIT_DOWN_CANCEL, object->surface, body, B_CANCEL_DOWN, B_SET_BTN')
k('render pressed unknown button draws', 'default: break;\n        }\n    } else if', 'default: add_blit(out, ALC_BLIT_DOWN_TIME, object->surface, body, B_TIME_DOWN, B_TIME_BTN, vx, vy); break;\n        }\n    } else if')
k('render restore without the request', '} else if (object->restore != 0) {', '} else if (1) {')
k('render restore never', '} else if (object->restore != 0) {', '} else if (0) {')
k('render restore with the pressed button', '} else if (object->restore != 0) {', '}\n    if (object->restore != 0) {')
k('render restore kept', 'object->restore = 0;\n    }\n    for (uint8_t i', '}\n    for (uint8_t i')
k('render restore cancel', '{ALC_BLIT_UP_CANCEL, B_CANCEL_BTN}', '{ALC_BLIT_UP_CANCEL, B_SET_BTN}')
k('render restore alarm', '{ALC_BLIT_UP_ALARM, B_ALARM_BTN}', '{ALC_BLIT_UP_ALARM, B_TIME_BTN}')
k('render restore time', '{ALC_BLIT_UP_TIME, B_TIME_BTN}', '{ALC_BLIT_UP_TIME, B_ALARM_BTN}')
k('render restore set', '{ALC_BLIT_UP_SET, B_SET_BTN}', '{ALC_BLIT_UP_SET, B_CANCEL_BTN}')
k('render restore increase', '{ALC_BLIT_UP_INCREASE, B_INCREASE_BTN}', '{ALC_BLIT_UP_INCREASE, B_DECREASE_BTN}')
k('render restore decrease', '{ALC_BLIT_UP_DECREASE, B_DECREASE_BTN}', '{ALC_BLIT_UP_DECREASE, B_INCREASE_BTN}')
k('render restore order', '{ALC_BLIT_UP_CANCEL, B_CANCEL_BTN}, {ALC_BLIT_UP_ALARM, B_ALARM_BTN}', '{ALC_BLIT_UP_ALARM, B_ALARM_BTN}, {ALC_BLIT_UP_CANCEL, B_CANCEL_BTN}')
k('render restore count', 'i < sizeof(up) / sizeof(up[0]); ++i)', 'i + 1 < sizeof(up) / sizeof(up[0]); ++i)')
k('render restore surface', 'add_blit(out, up[i].kind, 0u, body,', 'add_blit(out, up[i].kind, object->surface, body,')
k('render blit not announced', 'for (uint8_t i = 0; i < out->count; ++i) fx(host, ALC_FX_BLIT, out->blit[i].kind, 0);', '(void)0;')
k('render blit announced short', 'for (uint8_t i = 0; i < out->count; ++i) fx(host, ALC_FX_BLIT', 'for (uint8_t i = 1; i < out->count; ++i) fx(host, ALC_FX_BLIT')
k('render redraw request kept', 'fx(host, ALC_FX_BLIT, out->blit[i].kind, 0);\n    object->dirty = 0;', 'fx(host, ALC_FX_BLIT, out->blit[i].kind, 0);')
k('render source with the origin', 'for (int k = 0; k < 4; ++k) b->src[k] = rd_s32(body, src + (size_t)k * 4u);', 'for (int k = 0; k < 4; ++k) b->src[k] = rd_s32(body, src + (size_t)k * 4u) + (k % 2 ? vy : vx);')
k('render destination left without the origin', 'b->dst[0] = (int32_t)((uint32_t)rd_s32(body, dst) + (uint32_t)vx);', 'b->dst[0] = rd_s32(body, dst);')
k('render destination top without the origin', 'b->dst[1] = (int32_t)((uint32_t)rd_s32(body, dst + 4) + (uint32_t)vy);', 'b->dst[1] = rd_s32(body, dst + 4);')
k('render destination right without the origin', 'b->dst[2] = (int32_t)((uint32_t)rd_s32(body, dst + 8) + (uint32_t)vx);', 'b->dst[2] = rd_s32(body, dst + 8);')
k('render destination bottom without the origin', 'b->dst[3] = (int32_t)((uint32_t)rd_s32(body, dst + 12) + (uint32_t)vy);', 'b->dst[3] = rd_s32(body, dst + 12);')
k('render destination left with the y origin', '(uint32_t)rd_s32(body, dst) + (uint32_t)vx)', '(uint32_t)rd_s32(body, dst) + (uint32_t)vy)')
k('render destination top with the x origin', '(uint32_t)rd_s32(body, dst + 4) + (uint32_t)vy)', '(uint32_t)rd_s32(body, dst + 4) + (uint32_t)vx)')
k('render destination right edge wrong offset', 'rd_s32(body, dst + 8) + (uint32_t)vx', 'rd_s32(body, dst + 12) + (uint32_t)vx')
k('render destination bottom edge wrong offset', 'rd_s32(body, dst + 12) + (uint32_t)vy', 'rd_s32(body, dst + 8) + (uint32_t)vy')
k('render result not cleared', 'memset(out, 0, sizeof(*out));\n    if (object->slot == ALC_NO_SLOT) return ALC_OK;', 'if (object->slot == ALC_NO_SLOT) return ALC_OK;')
k('render body not validated', 'if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        alc_validate_body(body, body_length, NULL) != ALC_OK)\n        return ALC_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot',
  'if (object == NULL || body == NULL || out == NULL || !host_complete(host))\n        return ALC_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot')
# --- the host completeness check ---------------------------------------------------------------------------------------------
HOST_FIELDS = ('alloc_slot', 'register_slot', 'load_surface', 'set_slot_surface', 'release_surface', 'release_slot', 'mark_dirty',
               'view_origin', 'sound_prepare', 'sound_stop', 'sound_play', 'sound_busy', 'tick', 'touch_idle_timer',
               'event_flag_invalid', 'transition', 'store_event_flag')
for _field in HOST_FIELDS:
    k(f'host check lost: {_field}', f'host->{_field} != NULL', '1')

# --- the binding -------------------------------------------------------------------------------------------------------------
def b(name, old, new):
    add(BINDING, 'binding ' + name, old, new)


b('rows of other types copied', 'if (info.type != SESSION_AAA_TYPE) continue;', '(void)0;')
b('bad body accepted', 'if (alc_validate_body(info.typed_body, info.typed_body_length, &why) != ALC_OK) {', 'if (0) {')
b('bad body failure text lost', 'binding->failure = why;\n            return ALC_ERR_BODY;', 'binding->failure = "none";\n            return ALC_ERR_BODY;')
b('previous scene not cleared', 'if (alc_cleanup(&binding->object, &binding->host.kernel) != ALC_OK) {\n        free(rows);\n        binding->failure = "0xaa-scene-clear";', 'if (0) {\n        free(rows);\n        binding->failure = "0xaa-scene-clear";')
b('clear failure ignored', 'binding->failure = "0xaa-scene-clear";\n        return ALC_ERR_HOST;', 'binding->failure = "0xaa-scene-clear";\n        return ALC_OK;')
b('clear failure text', '"0xaa-scene-clear"', '"x"')
b('rows not replaced', 'binding->rows = rows;\n    binding->count = count;', 'free(rows);')
b('row count not replaced', 'binding->rows = rows;\n    binding->count = count;', 'binding->rows = rows;')
b('destroy does not clear', '(void)alc_cleanup(&binding->object, &binding->host.kernel);\n    free(binding->rows);', 'free(binding->rows);')
b('row copy skipped', 'memcpy(rows[i].body, info.typed_body, ALC_BODY_BYTES);\n        rows[i].present = 1u;', 'rows[i].present = 1u;')
b('row not marked present', 'rows[i].present = 1u;', '(void)0;')
b('foreign row accepted', 'action->type != SESSION_AAA_TYPE ||', '0 ||')
b('absent row accepted', '|| binding->rows[index].present == 0u) {', ') {')
b('row index unchecked', 'index >= binding->count ||', '0 ||')
b('row text', '"0xaa-row-not-owned"', '"x"')
b('handler uses the wrong body', 'binding->rows[index].body, ALC_BODY_BYTES, (int16_t)index', 'binding->rows[0].body, ALC_BODY_BYTES, (int16_t)index')
b('handler uses the wrong row number', 'ALC_BODY_BYTES, (int16_t)index, before->phase', 'ALC_BODY_BYTES, 1, before->phase')
b('handler does not load the world', 'load_world(binding);\n    status = alc_step', 'status = alc_step')
b('click does not load the world', 'load_world(binding);\n    status = alc_click', 'status = alc_click')
b('world hook required', 'if (binding->host.load_world != NULL) binding->host.load_world', 'if (1) binding->host.load_world')
b('world load context', 'binding->host.load_world(binding->host.kernel.context, &binding->world)', 'binding->host.load_world(NULL, &binding->world)')
b('unsupported becomes an error', 'if (status == ALC_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;', 'if (status == ALC_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_ERROR;')
b('errors are accepted', 'if (status != ALC_OK) return SCENE_ACTION_HANDLER_ERROR;', '(void)0;')
b('world stored only on init', '(result.initialized != 0u || result.completed != 0u) &&', '(result.initialized != 0u) &&')
b('world stored only on completion', '(result.initialized != 0u || result.completed != 0u) &&', '(result.completed != 0u) &&')
b('world stored on every visit', '(result.initialized != 0u || result.completed != 0u) &&', '1 &&')
b('world store context', 'binding->host.store_world(binding->host.kernel.context, &binding->world)', 'binding->host.store_world(NULL, &binding->world)')
b('phase before kept', 'out->phase = result.phase_after;', 'out->phase = before->phase;')
b('completion left pending', 'result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_PENDING')
b('every visit completes', 'result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_COMPLETED')
b('failure text lost', 'binding->failure = why != NULL ? why : "none";', 'binding->failure = "none";')
b('pointer on an inactive clock', 'if (binding->object.active == 0) return ALC_OK; /* 0x44d28c clears the redraw request and returns 0 */', '(void)0;')
b('pointer result not cleared', 'memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (binding->object.active == 0) return ALC_OK; /* 0x44d28c', 'out->candidate = -1;\n    if (binding->object.active == 0) return ALC_OK; /* 0x44d28c')
b('pointer candidate default', 'out->candidate = -1;\n    if (binding->object.active == 0) return ALC_OK; /* 0x44d28c', 'out->candidate = 0;\n    if (binding->object.active == 0) return ALC_OK; /* 0x44d28c')
b('pointer uses the wrong body', 'return alc_pointer(&binding->object, body, ALC_BODY_BYTES, x, y, out);', 'return alc_pointer(&binding->object, binding->rows[1].body, ALC_BODY_BYTES, x, y, out);')
b('click on an inactive clock', 'memset(out, 0, sizeof(*out));\n    if (binding->object.active == 0) return ALC_OK;', 'memset(out, 0, sizeof(*out));')
b('click result not cleared', 'memset(out, 0, sizeof(*out));\n    if (binding->object.active == 0) return ALC_OK;', 'if (binding->object.active == 0) return ALC_OK;')
b('click without a result pointer', 'if (out == NULL) out = &local;', '(void)0;')
b('click failure text', 'binding->failure = status == ALC_OK ? "none" : "0xaa-click";', 'binding->failure = "none";')
b('click failure text name', '"0xaa-click"', '"x"')
b('click row phase passed wrong', 'ALC_BODY_BYTES, row_phase, &binding->world', 'ALC_BODY_BYTES, 1u, &binding->world')
b('invalidate dropped', 'return alc_invalidate(&binding->object, &binding->host.kernel);', 'return ALC_OK;')
b('render without a slot', 'if (binding->object.slot == ALC_NO_SLOT) return ALC_OK; /* no render entry: 0x44e035 is never called */', '(void)0;')
b('render result not cleared', 'memset(out, 0, sizeof(*out));\n    if (binding->object.slot == ALC_NO_SLOT)', 'if (binding->object.slot == ALC_NO_SLOT)')
b('render uses the wrong body', 'return alc_render(&binding->object, body, ALC_BODY_BYTES, &binding->host.kernel, out);', 'return alc_render(&binding->object, binding->rows[1].body, ALC_BODY_BYTES, &binding->host.kernel, out);')
b('registered always', 'return binding != NULL && binding->object.slot != ALC_NO_SLOT ? 1u : 0u;', 'return binding != NULL ? 1u : 0u;')
b('unbound failure text', '"0xaa-binding-unbound"', '"none"')
b('create keeps no host', 'binding->host = *host;', '(void)0;')
b('create keeps a dirty object', 'alc_object_reset(&binding->object);\n        binding->failure', 'binding->failure')


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
    'time morning boundary': 'the branch before it already takes hour 12 (0xc), so "hour <= 0xc" and "hour < 0xc" select the same hours',
    'alarm on the hour quarter': 'this branch runs only when the time quarter is not above 0, and the reader leaves it in 0..3, so '
                                 'copying it and storing 0 give the same value (a negative quarter is outside the domain)',
    'press redraw lost': 'the pointer sets the redraw request before it reaches any button, and the press writer is only called '
                         'from the pointer, so setting it again changes nothing',
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
        cls.binary = Path(cls.tmp.name) / 'aa_test'
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
            out = Path(self.tmp.name) / 'aa_test_san'
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

    def test_mutation_anchors_are_unique(self):
        """Every mutant must apply to exactly one place of the current source and change it."""
        for filename, mutations in MUTANTS.items():
            text = (SRC / filename).read_text()
            for name, (old, new) in mutations.items():
                with self.subTest(name):
                    self.assertEqual(text.count(old), 1, f'anchor drifted: {old[:70]!r}')
                    self.assertNotEqual(old, new)

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
            try:
                done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=120, env=env)
                verdict = 'killed' if done.returncode != 0 else 'survived'
            except subprocess.TimeoutExpired:
                verdict = 'killed'  # a hang is a detected difference
            shutil.rmtree(work, ignore_errors=True)
            return name, verdict, ''

        with concurrent.futures.ThreadPoolExecutor(max_workers=min(8, os.cpu_count() or 2)) as pool:
            outcomes = list(pool.map(build_and_run, enumerate(jobs)))
        self.assertEqual(len({name for _, name, _, _ in jobs}), len(jobs), 'duplicate mutant names')
        killed = sum(1 for _, verdict, _ in outcomes if verdict == 'killed')
        for name, verdict, detail in outcomes:
            with self.subTest(name):
                self.assertEqual(verdict, 'killed', f'mutant {verdict}: {name} {detail}')
        print(f'mutants killed: {killed} of {len(jobs)} ({len(EQUIVALENT)} recorded equivalent, not run)')


class Corpus(unittest.TestCase):
    def test_real_row_validates_and_plays_through_the_binding(self):
        """The one real raw 0xaa row (resource 1535, row 3) passes the native body validation, shows the time, enters alarm mode,
        steps the hour, sets the alarm, plays the final sound and finishes; a second pass cancels (derived counts only; the decoded
        resources stay in work/)."""
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'aa_corpus'
            built = compile_c(binary, CORPUS_C, SOURCES, extra=('-Wno-error=type-limits',))
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['set'], summary['canceled'], summary['error']),
                         (1, 1, 1, 1, 0))
        self.assertEqual(summary['loads'], summary['releases'])
        self.assertEqual(done.stdout.count('SCENE_FAIL') + done.stdout.count('ROW_FAIL'), 0)


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_aa_runtime.sh')],
                              capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())


class Registration(unittest.TestCase):
    def test_module_is_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        self.assertIn(' action_family_aa_runtime session_bindings_aaa', build)


if __name__ == '__main__':
    unittest.main()
