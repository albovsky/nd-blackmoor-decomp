"""RT-51: raw 0xd6 / 0xe0 keypad puzzle runtime (src/action_family_e0_runtime.c) and its session binding (src/session_bindings_ae0.c).

Facts under test (original GAME.EXE, read from the disassembly of 0x471722, 0x470ffe, 0x4712bd, 0x472a5c, 0x470ddc, 0x470e31,
0x470e71, 0x470e8e and the dispatcher arms 0x42a2c0 / 0x42a2fc; see outputs/blackmoor-decomp/tasks/RT-51-keypad-puzzle-d6-e0-runtime.md):
 * one singleton serves both raw types (flag 0 = 0xd6 with 1,733 body bytes, flag 1 = 0xe0 with 294); phase 0 initialises it (raw
   0xe0 lays the key grid out from cols / rows / sizes / gaps and stores cols * rows at +0x21), registers a generic Z entry, loads
   the CIFTREE sheet and ends in phase 1;
 * phase 1 is a state machine on obj+0xd2c: state 0 (typed code, release after the wait, exit button, code sets), 1 (arm the show
   delay), 3 (wait, blink, start sound B or the next round), 4 (wait for sound B), anything else idle; phase 2 applies the exit,
   all-sets or failed scene block (the failed block tests the stale dword 0x5bb57b), stores the event flag, completes and cleans up;
 * the pointer cascade tests the exit rectangle, the keys and the exit button, the click block types the keys and presses the exit
   button, the render callback blits keys, round lights and the exit button.
Native safety differences (body validation, bounds, zeroed bytes past the 294 loaded ones) are checks of this port, not original
behaviour. The unit cases live in tests/action_family_e0_runtime_test.c (synthetic bodies). The original-x86 oracle is
tests/action_family_e0_runtime_original_oracle.py (needs the private work/ evidence and Unicorn).
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
TEST_C = PROJECT / 'tests/action_family_e0_runtime_test.c'
KERNEL = 'action_family_e0_runtime.c'
BINDING = 'session_bindings_ae0.c'
OWNED = [KERNEL, BINDING]
OTHERS = ['scene_resource.c', 'hiff.c']
SOURCES = OWNED + OTHERS
EXPECTED_UNIT_TESTS = 47


def compiler():
    return os.environ.get('CC') or shutil.which('cc') or shutil.which('gcc') or shutil.which('clang')


def compile_obj(cc, source, output, include_dir=SRC, optimize='-O1', werror=True):
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', optimize, '-g', f'-I{include_dir}', '-c', str(source), '-o', str(output)]
    if werror:
        cmd.insert(1, '-Werror')
    return subprocess.run(cmd, capture_output=True, text=True)


def link(cc, objects, output):
    return subprocess.run([cc, *map(str, objects), '-lm', '-o', str(output)], capture_output=True, text=True)


def build_objects(cc, directory, optimize):
    """Objects of the test and of the four sources; the owned files and the test are built with -Werror."""
    directory.mkdir(parents=True, exist_ok=True)
    objects = {}
    jobs = [(TEST_C, 'test.o', True)] + [(SRC / name, name + '.o', name in OWNED) for name in SOURCES]
    for source, name, werror in jobs:
        out = directory / name
        done = compile_obj(cc, source, out, optimize=optimize, werror=werror)
        assert done.returncode == 0, done.stderr[-1500:]
        objects[source.name] = out
    return objects


def run_unit(binary, timeout=120):
    try:
        done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return -9, {}
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
        # --- validation --------------------------------------------------------------------------------------------
        'validate: expected lengths swapped': ('(flag == 0 ? E0_BODY_BYTES_D6 : E0_BODY_BYTES_E0)', '(flag == 0 ? E0_BODY_BYTES_E0 : E0_BODY_BYTES_D6)'),
        'validate: longer body accepted': ('length != (flag == 0', 'length < (flag == 0'),
        'validate: flag 2 accepted': ('(flag != 0 && flag != 1)', '(flag != 0 && flag != 1 && flag != 2)'),
        'validate: name search one short': ('memchr(body, 0, B_NAME_BYTES) == NULL', 'memchr(body, 0, B_NAME_BYTES - 1) == NULL'),
        'validate: name search one long': ('memchr(body, 0, B_NAME_BYTES) == NULL', 'memchr(body, 0, B_NAME_BYTES + 1) == NULL'),
        'validate: padding starts one late': ('for (i = length; i < E0_BODY_CAPACITY', 'for (i = length + 1; i < E0_BODY_CAPACITY'),
        'validate: padding ends one early': ('i < E0_BODY_CAPACITY && why == NULL', 'i < E0_BODY_CAPACITY - 1 && why == NULL'),
        'validate: padding ignored': ('if (body[i] != 0u) why', 'if (0) why'),
        'validate: 0xe0 count adds': ('cols * (int32_t)rd_s16(body, B_ROWS)', 'cols + (int32_t)rd_s16(body, B_ROWS)'),
        'validate: 0xe0 count saturates': ('n = (int16_t)(int32_t)((int32_t)cols * (int32_t)rd_s16(body, B_ROWS));',
                                           'n = (int16_t)((int32_t)cols * (int32_t)rd_s16(body, B_ROWS) > 32767 ? 100 : (int32_t)cols * (int32_t)rd_s16(body, B_ROWS));'),
        'validate: 0xe0 count from the stored word': ('n = (int16_t)(int32_t)((int32_t)cols * (int32_t)rd_s16(body, B_ROWS));', 'n = rd_s16(body, B_COUNT);'),
        'validate: zero columns with no keys rejected': ('if (n > 0 && cols == 0)', 'if (n >= 0 && cols == 0)'),
        'validate: zero columns with keys accepted': ('if (n > 0 && cols == 0)', 'if (n > 0 && cols != 0)'),
        'validate: 100 keys rejected': ('n > E0_MAX_KEYS))', 'n >= E0_MAX_KEYS))'),
        'validate: 101 keys accepted': ('n > E0_MAX_KEYS))', 'n > E0_MAX_KEYS + 1))'),
        'validate: negative key count accepted': ('(n < 0 || n > E0_MAX_KEYS)', '(n < -1 || n > E0_MAX_KEYS)'),
        'validate: negative key count unchecked': ('(n < 0 || n > E0_MAX_KEYS)', '(n > E0_MAX_KEYS)'),
        'validate: ordered limit 31': ('n > E0_MAX_CODE) why = "keypad-ordered-key-count"', 'n > E0_MAX_CODE + 1) why = "keypad-ordered-key-count"'),
        'validate: ordered limit 30 rejected': ('n > E0_MAX_CODE) why = "keypad-ordered-key-count"', 'n >= E0_MAX_CODE) why = "keypad-ordered-key-count"'),
        'validate: ordered only for byte 1': ('body[B_ORDERED] != 0u && n > E0_MAX_CODE', 'body[B_ORDERED] == 1u && n > E0_MAX_CODE'),
        'validate: ordered limit without the ordered byte': ('body[B_ORDERED] != 0u && n > E0_MAX_CODE', 'n > E0_MAX_CODE'),
        'validate: code length 30 rejected': ('k >= 0 && k <= E0_MAX_CODE', 'k >= 0 && k < E0_MAX_CODE'),
        'validate: code length 31 accepted': ('k >= 0 && k <= E0_MAX_CODE', 'k >= 0 && k <= E0_MAX_CODE + 1'),
        'validate: negative code length accepted': ('k >= 0 && k <= E0_MAX_CODE', 'k >= -1 && k <= E0_MAX_CODE'),
        'validate: record 0 unchecked': ('!record_ok(body, B_ROUND0)', '0'),
        'validate: three later records': ('j < 4u', 'j < 3u'),
        'validate: five later records': ('j < 4u && why == NULL', 'j < 5u && why == NULL'),
        'validate: later record stride': ('B_ROUND1 + j * E0_ROUND_BYTES', 'B_ROUND1 + j * 32u'),
        'validate: code set test inverted': ('if (body[B_SETS + 5u * s] != 0u) {', 'if (body[B_SETS + 5u * s] == 0u) {'),
        'validate: code set hole accepted': ('if (seen_zero) why', 'if (0) why'),
        'validate: last code set unchecked': ('s < 5u', 's < 4u'),
        'validate: code set stride': ('body[B_SETS + 5u * s]', 'body[B_SETS + 4u * s]'),
        'validate: sets with 30 keys accepted': ('sets > 0 && n > E0_MAX_CODE - 1', 'sets > 0 && n > E0_MAX_CODE'),
        'validate: sets with 29 keys rejected': ('sets > 0 && n > E0_MAX_CODE - 1', 'sets > 0 && n > E0_MAX_CODE - 2'),
        'validate: 30 keys without sets rejected': ('sets > 0 && n > E0_MAX_CODE - 1', 'n > E0_MAX_CODE - 1'),
        # --- phase 0 -----------------------------------------------------------------------------------------------
        'phase 0: not active': ('o->active = 1u;\n    o->flag = (uint8_t)flag;', 'o->flag = (uint8_t)flag;'),
        'phase 0: flag not stored': ('o->flag = (uint8_t)flag;', 'o->flag = 0u;'),
        'phase 0: solved not cleared': ('o->solved = 0u;\n    o->waiting = 0u;', 'o->waiting = 0u;'),
        'phase 0: waiting not cleared': ('o->waiting = 0u;\n    c->world->start_flag_5bb1ca = 1;', 'c->world->start_flag_5bb1ca = 1;'),
        'phase 0: start flag cleared': ('c->world->start_flag_5bb1ca = 1;\n    fx(h, E0_FX_START_FLAG, 1, 0);', 'c->world->start_flag_5bb1ca = 0;\n    fx(h, E0_FX_START_FLAG, 1, 0);'),
        'phase 0: row not stored': ('o->row = row;', '(void)0;'),
        'phase 0: exit request kept': ('o->exit_asked = 0u;\n    memset(o->rect_a', 'memset(o->rect_a'),
        'phase 0: key rectangles kept': ('memset(o->rect_a, 0, sizeof(o->rect_a));', '(void)0;'),
        'phase 0: hit rectangles kept': ('memset(o->rect_b, 0, sizeof(o->rect_b));', '(void)0;'),
        'phase 0: flag inverted': ('if (flag != 0) {\n        const int16_t cols', 'if (flag == 0) {\n        const int16_t cols'),
        'phase 0: grid count adds': ('const int16_t n = (int16_t)(int32_t)((int32_t)cols * (int32_t)rd_s16(b, B_ROWS));', 'const int16_t n = (int16_t)(int32_t)((int32_t)cols + (int32_t)rd_s16(b, B_ROWS));'),
        'phase 0: count not stored': ('wr_s16(b, B_COUNT, n);', '(void)0;'),
        'phase 0: row split rounds up': ('floor((double)i / (double)cols)', 'ceil((double)i / (double)cols)'),
        'phase 0: column from the rows': ('(int32_t)i % (int32_t)cols;', '(int32_t)i % (int32_t)rd_s16(b, B_ROWS);'),
        'phase 0: key width unsigned': ('const uint32_t w = (uint32_t)(int32_t)rd_s16(b, B_KEY_W);', 'const uint32_t w = (uint32_t)(uint16_t)rd_s16(b, B_KEY_W);'),
        'phase 0: key height unsigned': ('const uint32_t hgt = (uint32_t)(int32_t)rd_s16(b, B_KEY_H);', 'const uint32_t hgt = (uint32_t)(uint16_t)rd_s16(b, B_KEY_H);'),
        'phase 0: x0 unsigned': ('left = (uint32_t)(int32_t)rd_s16(b, B_X0) +', 'left = (uint32_t)(uint16_t)rd_s16(b, B_X0) +'),
        'phase 0: y0 unsigned': ('top = (uint32_t)(int32_t)rd_s16(b, B_Y0) +', 'top = (uint32_t)(uint16_t)rd_s16(b, B_Y0) +'),
        'phase 0: x gap unsigned': ('(uint32_t)(int32_t)rd_s16(b, B_XGAP));', '(uint32_t)(uint16_t)rd_s16(b, B_XGAP));'),
        'phase 0: y gap unsigned': ('(uint32_t)(int32_t)rd_s16(b, B_YGAP));', '(uint32_t)(uint16_t)rd_s16(b, B_YGAP));'),
        'phase 0: x0 prime unsigned': ('left = (uint32_t)(int32_t)rd_s16(b, B_X0B) +', 'left = (uint32_t)(uint16_t)rd_s16(b, B_X0B) +'),
        'phase 0: y0 prime unsigned': ('top = (uint32_t)(int32_t)rd_s16(b, B_Y0B) +', 'top = (uint32_t)(uint16_t)rd_s16(b, B_Y0B) +'),
        'phase 0: x gap prime unsigned': ('(uint32_t)(int32_t)rd_s16(b, B_XGAPB));', '(uint32_t)(uint16_t)rd_s16(b, B_XGAPB));'),
        'phase 0: y gap prime unsigned': ('(uint32_t)(int32_t)rd_s16(b, B_YGAPB));', '(uint32_t)(uint16_t)rd_s16(b, B_YGAPB));'),
        'phase 0: hit rectangle from the source origin': ('top = (uint32_t)(int32_t)rd_s16(b, B_Y0B) +', 'top = (uint32_t)(int32_t)rd_s16(b, B_Y0) +'),
        'phase 0: hit rectangle uses the source gap': ('(uint32_t)(int32_t)rd_s16(b, B_XGAPB));', '(uint32_t)(int32_t)rd_s16(b, B_XGAP));'),
        'phase 0: source right edge': ('o->rect_a[i][2] = (int32_t)(left + w);', 'o->rect_a[i][2] = (int32_t)left;'),
        'phase 0: hit bottom edge': ('o->rect_b[i][3] = (int32_t)(top + hgt);', 'o->rect_b[i][3] = (int32_t)(top + w);'),
        'phase 0: grid rounds kept': ('o->rounds = 1;\n        o->round = 0;', 'o->rounds = 1;'),
        'phase 0: grid rounds count': ('o->rounds = 1;\n        o->round = 0;', 'o->rounds = 0;\n        o->round = 0;'),
        'phase 0: grid code sets kept': ('o->set_count = 0;\n        o->scene = rd_s16(b, B_ROUNDS);', 'o->scene = rd_s16(b, B_ROUNDS);'),
        'phase 0: grid scene lost': ('o->scene = rd_s16(b, B_ROUNDS);', 'o->scene = E0_NO_SCENE;'),
        'phase 0: source rectangle stride': ('o->rect_a[i][k] = rd_s32(b, B_RECT_A + (size_t)i * 16u + (size_t)k * 4u);', 'o->rect_a[i][k] = rd_s32(b, B_RECT_A + (size_t)i * 12u + (size_t)k * 4u);'),
        'phase 0: hit rectangle from the source table': ('o->rect_b[i][k] = rd_s32(b, B_RECT_B +', 'o->rect_b[i][k] = rd_s32(b, B_RECT_A +'),
        'phase 0: 29 rectangles': ('for (int i = 0; i < 30; ++i)\n            for (int k = 0; k < 4; ++k) {', 'for (int i = 0; i < 29; ++i)\n            for (int k = 0; k < 4; ++k) {'),
        'phase 0: rounds from the count': ('o->rounds = rd_s16(b, B_ROUNDS);', 'o->rounds = rd_s16(b, B_COUNT);'),
        'phase 0: round 0 starts at 1 only with positive rounds': ('o->rounds > 0 && o->round == 0', 'o->rounds >= 0 && o->round == 0'),
        'phase 0: round reset when rounds': ('o->rounds > 0 && o->round == 0', 'o->rounds > 0'),
        'phase 0: round never starts': ('if (o->rounds > 0 && o->round == 0) o->round = 1;', '(void)0;'),
        'phase 0: sets counted inverted': ('if (b[B_SETS + 5u * (size_t)s] != 0u) ++o->set_count;', 'if (b[B_SETS + 5u * (size_t)s] == 0u) ++o->set_count;'),
        'phase 0: four sets counted': ('for (int s = 0; s < 5; ++s)', 'for (int s = 0; s < 4; ++s)'),
        'phase 0: scene of 0xd6': ('o->scene = E0_NO_SCENE;\n    }', 'o->scene = 0;\n    }'),
        'phase 0: record 0 for round 1 only': ('if (o->round <= 1)', 'if (o->round < 1)'),
        'phase 0: later record index': ('(long)((int32_t)o->round - 2) * (long)E0_ROUND_BYTES', '(long)((int32_t)o->round - 1) * (long)E0_ROUND_BYTES'),
        'phase 0: record refused ignored': ('    if (rc != E0_OK) return rc;\n    clear_lit', '    clear_lit'),
        'phase 0: keys not cleared': ('clear_lit(o, rd_s16(b, B_COUNT));\n    clear_player(o);', 'clear_player(o);'),
        'phase 0: all keys cleared': ('clear_lit(o, rd_s16(b, B_COUNT));\n    clear_player(o);', 'clear_lit(o, E0_MAX_KEYS);\n    clear_player(o);'),
        'phase 0: typed keys kept': ('clear_player(o);\n    for (int i = 0; i < E0_MAX_CODE; ++i) o->record[i] = -1;', 'for (int i = 0; i < E0_MAX_CODE; ++i) o->record[i] = -1;'),
        'phase 0: record kept': ('for (int i = 0; i < E0_MAX_CODE; ++i) o->record[i] = -1;\n    o->typed = 0;', 'o->typed = 0;'),
        'phase 0: record clears 29': ('for (int i = 0; i < E0_MAX_CODE; ++i) o->record[i] = -1;\n    o->typed = 0;', 'for (int i = 0; i < E0_MAX_CODE - 1; ++i) o->record[i] = -1;\n    o->typed = 0;'),
        'phase 0: typed count kept': ('o->typed = 0;\n    o->recorded = 0;\n    o->tiles_visible = 1u;', 'o->recorded = 0;\n    o->tiles_visible = 1u;'),
        'phase 0: record count kept': ('o->recorded = 0;\n    o->tiles_visible = 1u;', 'o->tiles_visible = 1u;'),
        'phase 0: tiles hidden': ('o->tiles_visible = 1u;\n    o->exit_pending = 0u;', 'o->exit_pending = 0u;'),
        'phase 0: exit press kept': ('o->exit_pending = 0u;\n    HOST(h->alloc_slot', 'HOST(h->alloc_slot'),
        'phase 0: slot not stored': ('o->slot = slot;', '(void)0;'),
        'phase 0: registered without the held surface': ('HOST(h->register_slot(h->context, slot, kEntryLabel, o->surface));', 'HOST(h->register_slot(h->context, slot, kEntryLabel, 0u));'),
        'phase 0: surface always loaded': ('if (o->surface == 0u) {\n        uint32_t surface = 0u;', 'if (1) {\n        uint32_t surface = 0u;'),
        'phase 0: surface never loaded': ('if (o->surface == 0u) {\n        uint32_t surface = 0u;', 'if (0) {\n        uint32_t surface = 0u;'),
        'phase 0: surface handle not kept': ('o->surface = surface;', '(void)0;'),
        'phase 0: slot surface wrong': ('HOST(h->set_slot_surface(h->context, slot, o->surface));', 'HOST(h->set_slot_surface(h->context, slot, 0u));'),
        'phase 0: sound A prepared when none': ('if (!no_sound(b + B_SOUND_A)) {\n        HOST(h->sound_prepare', 'if (no_sound(b + B_SOUND_A)) {\n        HOST(h->sound_prepare'),
        'phase 0: sound B prepared': ('HOST(h->sound_prepare(h->context, b + B_SOUND_A));\n        fx(h, E0_FX_SOUND_PREPARE, B_SOUND_A, 0);', 'HOST(h->sound_prepare(h->context, b + B_SOUND_B));\n        fx(h, E0_FX_SOUND_PREPARE, B_SOUND_A, 0);'),
        'phase 0: state kept': ('o->state = 0;\n    o->initialized = 1u;', 'o->initialized = 1u;'),
        'phase 0: not initialised': ('o->state = 0;\n    o->initialized = 1u;', 'o->state = 0;'),
        'phase 0: ends in phase 2': ('set_phase(c, 1u);\n    return E0_OK;\n}', 'set_phase(c, 2u);\n    return E0_OK;\n}'),
        'sound: eight byte compare': ('memcmp(name, k, sizeof k) == 0', 'memcmp(name, k, 8) == 0'),
        'sound: terminator not compared': ("'N', 'D', 0};", "'N', 'D', 1};"),
        'sound: letter wrong': ("{'N', 'O', ' ', 'S'", "{'N', 'O', '_', 'S'"),
        # --- state 0 -----------------------------------------------------------------------------------------------
        'state 0: solved needs no wait check': ('o->solved != 0u && o->waiting == 0u && b[B_HAS_EXIT] == 0u', 'o->solved != 0u && b[B_HAS_EXIT] == 0u'),
        'state 0: solved advances with the exit button': ('o->solved != 0u && o->waiting == 0u && b[B_HAS_EXIT] == 0u', 'o->solved != 0u && o->waiting == 0u'),
        'state 0: solved advance needs the flag unset': ('o->solved != 0u && o->waiting == 0u && b[B_HAS_EXIT] == 0u', 'o->waiting == 0u && b[B_HAS_EXIT] == 0u'),
        'state 0: next round from round 0': ('if (o->round > 0 && o->round < rd_s16(b, B_ROUNDS)) {', 'if (o->round >= 0 && o->round < rd_s16(b, B_ROUNDS)) {'),
        'state 0: last round clears solved': ('if (o->round > 0 && o->round < rd_s16(b, B_ROUNDS)) {', 'if (o->round > 0 && o->round <= rd_s16(b, B_ROUNDS)) {'),
        'state 0: rounds from the object': ('if (o->round > 0 && o->round < rd_s16(b, B_ROUNDS)) {', 'if (o->round > 0 && o->round < o->rounds) {'),
        'state 0: solved advance keeps solved': ('            o->solved = 0u;\n            o->typed = 0;\n            clear_player(o);\n        }', '            o->typed = 0;\n            clear_player(o);\n        }'),
        'state 0: solved advance keeps typed': ('            o->solved = 0u;\n            o->typed = 0;\n            clear_player(o);\n        }', '            o->solved = 0u;\n            clear_player(o);\n        }'),
        'state 0: solved advance keeps typed keys': ('            o->typed = 0;\n            clear_player(o);\n        }\n        o->state = 1;', '            o->typed = 0;\n        }\n        o->state = 1;'),
        'state 0: solved advance to state 2': ('clear_player(o);\n        }\n        o->state = 1;', 'clear_player(o);\n        }\n        o->state = 2;'),
        'state 0: wait compare strict': ('if (now <= o->wait_deadline) return E0_OK;', 'if (now < o->wait_deadline) return E0_OK;'),
        'state 0: wait compare signed': ('if (now <= o->wait_deadline) return E0_OK;', 'if ((int32_t)now <= (int32_t)o->wait_deadline) return E0_OK;'),
        'state 0: wait compare inverted': ('if (now <= o->wait_deadline) return E0_OK;', 'if (now >= o->wait_deadline) return E0_OK;'),
        'state 0: wait kept': ('o->waiting = 0u;\n        if (o->exit_pending != 0u) {', 'if (o->exit_pending != 0u) {'),
        'state 0: exit press kept': ('o->exit_pending = 0u;\n            o->recorded = 0;\n            clear_typed = 1;', 'o->recorded = 0;\n            clear_typed = 1;'),
        'state 0: records kept': ('o->exit_pending = 0u;\n            o->recorded = 0;\n            clear_typed = 1;', 'o->exit_pending = 0u;\n            clear_typed = 1;'),
        'state 0: typed keys kept after the exit press': ('o->recorded = 0;\n            clear_typed = 1;', 'o->recorded = 0;'),
        'state 0: exit press with solved keeps solved in the last round': ('if (o->round > 0 && o->round < rd_s16(b, B_ROUNDS)) o->solved = 0u;', 'o->solved = 0u;'),
        'state 0: exit press solved next round from round 0': ('if (o->round > 0 && o->round < rd_s16(b, B_ROUNDS)) o->solved = 0u;', 'if (o->round >= 0 && o->round < rd_s16(b, B_ROUNDS)) o->solved = 0u;'),
        'state 0: exit press solved last round': ('if (o->round > 0 && o->round < rd_s16(b, B_ROUNDS)) o->solved = 0u;', 'if (o->round > 0 && o->round <= rd_s16(b, B_ROUNDS)) o->solved = 0u;'),
        'state 0: exit press solved rounds from the object': ('if (o->round > 0 && o->round < rd_s16(b, B_ROUNDS)) o->solved = 0u;', 'if (o->round > 0 && o->round < o->rounds) o->solved = 0u;'),
        'state 0: exit press solved goes to state 2': ('                o->state = 1;\n            } else if (o->set_count > 0) {', '                o->state = 2;\n            } else if (o->set_count > 0) {'),
        'state 0: sets path always': ('} else if (o->set_count > 0) {', '} else if (o->set_count >= 0) {'),
        'state 0: sets path never': ('} else if (o->set_count > 0) {', '} else if (o->set_count > 99) {'),
        'state 0: one set too many': ('for (int16_t i = 0; i < o->set_count; ++i) {', 'for (int16_t i = 0; i <= o->set_count; ++i) {'),
        'state 0: one set too few': ('for (int16_t i = 0; i < o->set_count; ++i) {', 'for (int16_t i = 0; i < o->set_count - 1; ++i) {'),
        'state 0: sets of four codes': ('for (int j = 0; j < 5; ++j) {', 'for (int j = 0; j < 4; ++j) {'),
        'state 0: set stride': ('b[B_SETS + 5u * (size_t)i + (size_t)j]', 'b[B_SETS + 4u * (size_t)i + (size_t)j]'),
        'state 0: zero code does not end a set': ('if (code == 0u) break;', '(void)0;'),
        'state 0: record search one too far': ('for (int16_t m = 0; m < n; ++m) {\n                            if (o->record[m]', 'for (int16_t m = 0; m <= n; ++m) {\n                            if (o->record[m]'),
        'state 0: record search one too short': ('for (int16_t m = 0; m < n; ++m) {\n                            if (o->record[m]', 'for (int16_t m = 0; m < n - 1; ++m) {\n                            if (o->record[m]'),
        'state 0: record code off by one': ('o->record[m] == (int16_t)code - 1', 'o->record[m] == (int16_t)code'),
        'state 0: record compare inverted': ('o->record[m] == (int16_t)code - 1', 'o->record[m] != (int16_t)code - 1'),
        'state 0: matched record entry consumed': ('o->record[n] = -1; /* index N, not m (original) */', 'o->record[m] = -1;'),
        'state 0: missing code does not end a set': ('if (!flagm) break;', '(void)0;'),
        'state 0: completed set does not ask for phase 2': ('o->solved_sets = 1u;\n                        set_phase(c, 2u);', 'o->solved_sets = 1u;'),
        'state 0: completed set not remembered': ('o->solved_sets = 1u;\n                        set_phase(c, 2u);', 'set_phase(c, 2u);'),
        'state 0: completed set asks for phase 1': ('o->solved_sets = 1u;\n                        set_phase(c, 2u);', 'o->solved_sets = 1u;\n                        set_phase(c, 1u);'),
        'state 0: record kept after the sets': ('                for (int i = 0; i < E0_MAX_CODE; ++i) o->record[i] = -1;\n                o->recorded = 0;', '                o->recorded = 0;'),
        'state 0: record clears 29 after the sets': ('                for (int i = 0; i < E0_MAX_CODE; ++i) o->record[i] = -1;\n                o->recorded = 0;', '                for (int i = 0; i < E0_MAX_CODE - 1; ++i) o->record[i] = -1;\n                o->recorded = 0;'),
        'state 0: scene move needs typed keys': ('(o->typed == 0 || b[B_ORDERED] == 0u) && o->scene != E0_NO_SCENE', '(o->typed != 0 || b[B_ORDERED] == 0u) && o->scene != E0_NO_SCENE'),
        'state 0: scene move needs ordered': ('(o->typed == 0 || b[B_ORDERED] == 0u) && o->scene != E0_NO_SCENE', '(o->typed == 0 || b[B_ORDERED] != 0u) && o->scene != E0_NO_SCENE'),
        'state 0: scene move without typed test': ('(o->typed == 0 || b[B_ORDERED] == 0u) && o->scene != E0_NO_SCENE', '(b[B_ORDERED] == 0u) && o->scene != E0_NO_SCENE'),
        'state 0: scene move needs no scene': ('(o->typed == 0 || b[B_ORDERED] == 0u) && o->scene != E0_NO_SCENE', '(o->typed == 0 || b[B_ORDERED] == 0u)'),
        'state 0: scene move on any scene word': ('(o->typed == 0 || b[B_ORDERED] == 0u) && o->scene != E0_NO_SCENE', '(o->typed == 0 || b[B_ORDERED] == 0u) && o->scene != 0'),
        'state 0: scene move to state 2': ('o->scene != E0_NO_SCENE) {\n                    o->state = 1;', 'o->scene != E0_NO_SCENE) {\n                    o->state = 2;'),
        'state 0: keys cleared only for N': ('} else {\n                    clear_lit(o, E0_MAX_KEYS);', '} else {\n                    clear_lit(o, n);'),
        'state 0: keys not cleared': ('} else {\n                    clear_lit(o, E0_MAX_KEYS);', '} else {\n                    (void)0;'),
        'state 0: release even on the exit key': ('} else if (o->hover != E0_EXIT_KEY) {', '} else if (1) {'),
        'state 0: release only on the exit key': ('} else if (o->hover != E0_EXIT_KEY) {', '} else if (o->hover == E0_EXIT_KEY) {'),
        'state 0: release all keys': ('for (int16_t i = 0; i < n; ++i)\n                if (o->lit[i] != 0u) o->lit[i] = 0u;', 'for (int16_t i = 0; i < E0_MAX_KEYS; ++i)\n                if (o->lit[i] != 0u) o->lit[i] = 0u;'),
        'state 0: release one key too many': ('for (int16_t i = 0; i < n; ++i)\n                if (o->lit[i] != 0u) o->lit[i] = 0u;', 'for (int16_t i = 0; i <= n; ++i)\n                if (o->lit[i] != 0u) o->lit[i] = 0u;'),
        'state 0: release one key too few': ('for (int16_t i = 0; i < n; ++i)\n                if (o->lit[i] != 0u) o->lit[i] = 0u;', 'for (int16_t i = 0; i < n - 1; ++i)\n                if (o->lit[i] != 0u) o->lit[i] = 0u;'),
        'state 0: typed keys kept after the press': ('if (clear_typed) {\n        clear_player(o);\n        o->typed = 0;', 'if (clear_typed) {\n        clear_player(o);'),
        'state 0: typed count kept after the press': ('if (clear_typed) {\n        clear_player(o);\n        o->typed = 0;', 'if (clear_typed) {\n        o->typed = 0;'),
        'state 0: typed keys cleared always': ('if (clear_typed) {\n        clear_player(o);', 'if (1) {\n        clear_player(o);'),
        # --- typed code check --------------------------------------------------------------------------------------
        'typed: empty code checked': ('o->code_len > 0 && o->waiting == 0u && o->typed == o->code_len', 'o->code_len >= 0 && o->waiting == 0u && o->typed == o->code_len'),
        'typed: checked at any count': ('o->code_len > 0 && o->waiting == 0u && o->typed == o->code_len', 'o->code_len > 0 && o->waiting == 0u && o->typed >= o->code_len'),
        'typed: checked below the count': ('o->code_len > 0 && o->waiting == 0u && o->typed == o->code_len', 'o->code_len > 0 && o->waiting == 0u && o->typed <= o->code_len'),
        'typed: solved not set': ('o->solved = 1u;\n        for (int16_t i = 0; i < o->code_len; ++i) {', 'o->solved = 0u;\n        for (int16_t i = 0; i < o->code_len; ++i) {'),
        'typed: one entry too many': ('for (int16_t i = 0; i < o->code_len; ++i) {\n            if (o->code_ordered', 'for (int16_t i = 0; i <= o->code_len; ++i) {\n            if (o->code_ordered'),
        'typed: one entry too few': ('for (int16_t i = 0; i < o->code_len; ++i) {\n            if (o->code_ordered', 'for (int16_t i = 0; i < o->code_len - 1; ++i) {\n            if (o->code_ordered'),
        'typed: ordered test inverted': ('if (o->code_ordered != 0u) {', 'if (o->code_ordered == 0u) {'),
        'typed: ordered compare inverted': ('if (o->player[i] != (int16_t)o->code[i]) {', 'if (o->player[i] == (int16_t)o->code[i]) {'),
        'typed: ordered code sign extended': ('if (o->player[i] != (int16_t)o->code[i]) {', 'if (o->player[i] != (int16_t)(int8_t)o->code[i]) {'),
        'typed: unordered code sign extended': ('if (o->scratch[m] == (int16_t)o->code[i]) {', 'if (o->scratch[m] == (int16_t)(int8_t)o->code[i]) {'),
        'typed: scratch copy missing': ('memcpy(o->scratch, o->player, sizeof(o->scratch));', '(void)0;'),
        'typed: one scratch entry short': ('for (int16_t m = 0; m < o->code_len; ++m) {\n                    matched = 0;', 'for (int16_t m = 0; m < o->code_len - 1; ++m) {\n                    matched = 0;'),
        'typed: one scratch entry too many': ('for (int16_t m = 0; m < o->code_len; ++m) {\n                    matched = 0;', 'for (int16_t m = 0; m <= o->code_len; ++m) {\n                    matched = 0;'),
        'typed: compare inverted': ('if (o->scratch[m] == (int16_t)o->code[i]) {', 'if (o->scratch[m] != (int16_t)o->code[i]) {'),
        'typed: matched entry consumed': ('o->scratch[o->code_len] = -1;', 'o->scratch[m] = -1;'),
        'typed: length 30 record write moved': ('o->record[0] = -1;\n                        else', 'o->record[1] = -1;\n                        else'),
        'typed: length 30 record write missing': ('o->record[0] = -1;\n                        else', '(void)0;\n                        else'),
        'typed: length 29 treated as the record write': ('if (o->code_len == E0_MAX_CODE)\n                            o->record[0] = -1;', 'if (o->code_len == E0_MAX_CODE - 1)\n                            o->record[0] = -1;'),
        'typed: mismatch not recorded': ('if (!matched) {\n                    o->solved = 0u;', 'if (!matched) {\n                    o->solved = 1u;'),
        'typed: ordered mismatch not recorded': ('if (o->player[i] != (int16_t)o->code[i]) {\n                    o->solved = 0u;', 'if (o->player[i] != (int16_t)o->code[i]) {\n                    o->solved = 1u;'),
        'wrap: only in ordered mode inverted': ('if (b[B_ORDERED] != 0u && o->typed >= rd_s16(b, B_COUNT)) {', 'if (b[B_ORDERED] == 0u && o->typed >= rd_s16(b, B_COUNT)) {'),
        'wrap: strict': ('if (b[B_ORDERED] != 0u && o->typed >= rd_s16(b, B_COUNT)) {', 'if (b[B_ORDERED] != 0u && o->typed > rd_s16(b, B_COUNT)) {'),
        'wrap: against the code length': ('if (b[B_ORDERED] != 0u && o->typed >= rd_s16(b, B_COUNT)) {', 'if (b[B_ORDERED] != 0u && o->typed >= o->code_len) {'),
        'wrap: always': ('if (b[B_ORDERED] != 0u && o->typed >= rd_s16(b, B_COUNT)) {', 'if (o->typed >= rd_s16(b, B_COUNT)) {'),
        'wrap: keys cleared only for N': ('clear_lit(o, E0_MAX_KEYS);\n        clear_player(o);\n        o->typed = 0;\n    }\n}', 'clear_lit(o, rd_s16(b, B_COUNT));\n        clear_player(o);\n        o->typed = 0;\n    }\n}'),
        'wrap: typed keys kept': ('clear_lit(o, E0_MAX_KEYS);\n        clear_player(o);\n        o->typed = 0;\n    }\n}', 'clear_lit(o, E0_MAX_KEYS);\n        o->typed = 0;\n    }\n}'),
        'wrap: count kept': ('clear_lit(o, E0_MAX_KEYS);\n        clear_player(o);\n        o->typed = 0;\n    }\n}', 'clear_lit(o, E0_MAX_KEYS);\n        clear_player(o);\n    }\n}'),
        'wrap: keys kept': ('clear_lit(o, E0_MAX_KEYS);\n        clear_player(o);\n        o->typed = 0;\n    }\n}', 'clear_player(o);\n        o->typed = 0;\n    }\n}'),
        # --- states 1, 3, 4 ----------------------------------------------------------------------------------------
        'state 1: delay in tenths': ('rd_s16(c->b, B_DELAY) * 1000 + 0x190', 'rd_s16(c->b, B_DELAY) * 100 + 0x190'),
        'state 1: lead time': ('rd_s16(c->b, B_DELAY) * 1000 + 0x190', 'rd_s16(c->b, B_DELAY) * 1000 + 0x19'),
        'state 1: delay unsigned': ('(uint32_t)((int32_t)rd_s16(c->b, B_DELAY) * 1000', '(uint32_t)((int32_t)(uint16_t)rd_s16(c->b, B_DELAY) * 1000'),
        'state 1: deadline subtracts': ('o->show_deadline = first + (uint32_t)', 'o->show_deadline = first - (uint32_t)'),
        'state 1: blink period': ('o->blink_deadline = do_tick(c->h) + 0x64u;\n    o->state = 3;', 'o->blink_deadline = do_tick(c->h) + 0x65u;\n    o->state = 3;'),
        'state 1: blink from the first tick': ('o->blink_deadline = do_tick(c->h) + 0x64u;\n    o->state = 3;', 'o->blink_deadline = first + 0x64u;\n    o->state = 3;'),
        'state 1: stays in state 1': ('o->blink_deadline = do_tick(c->h) + 0x64u;\n    o->state = 3;', 'o->blink_deadline = do_tick(c->h) + 0x64u;\n    o->state = 1;'),
        'state 1: goes to state 4': ('o->blink_deadline = do_tick(c->h) + 0x64u;\n    o->state = 3;', 'o->blink_deadline = do_tick(c->h) + 0x64u;\n    o->state = 4;'),
        'blink: toggle period': ('o->blink_deadline = do_tick(c->h) + 0x64u;\n        }', 'o->blink_deadline = do_tick(c->h) + 0x63u;\n        }'),
        'blink: strict compare': ('if (now >= o->blink_deadline) {', 'if (now > o->blink_deadline) {'),
        'blink: signed compare': ('if (now >= o->blink_deadline) {', 'if ((int32_t)now >= (int32_t)o->blink_deadline) {'),
        'blink: inverted compare': ('if (now >= o->blink_deadline) {', 'if (now <= o->blink_deadline) {'),
        'blink: no toggle': ('o->blink = o->blink == 0u ? 1u : 0u;', '(void)0;'),
        'blink: set instead of toggle': ('o->blink = o->blink == 0u ? 1u : 0u;', 'o->blink = 1u;'),
        'blink: without the byte': ('if (c->b[B_BLINK] != 0u) {', 'if (1) {'),
        'blink: inverted byte': ('if (c->b[B_BLINK] != 0u) {', 'if (c->b[B_BLINK] == 0u) {'),
        'blink: re-arm without a tick': ('o->blink_deadline = do_tick(c->h) + 0x64u;\n        }', 'o->blink_deadline = now + 0x64u;\n        }'),
        'state 3: show compare strict': ('if (now < o->show_deadline) {', 'if (now <= o->show_deadline) {'),
        'state 3: show compare signed': ('if (now < o->show_deadline) {', 'if ((int32_t)now < (int32_t)o->show_deadline) {'),
        'state 3: show compare inverted': ('if (now < o->show_deadline) {', 'if (now >= o->show_deadline) {'),
        'state 3: waiting without blink step': ('if (now < o->show_deadline) {\n        blink_step(c);', 'if (now < o->show_deadline) {'),
        'state 3: scene shortcut with typed keys': ('o->scene != 0 && o->typed == 0) {\n        set_phase(c, 2u);', 'o->scene != 0 && o->typed != 0) {\n        set_phase(c, 2u);'),
        'state 3: scene shortcut without the typed test': ('o->scene != 0 && o->typed == 0) {\n        set_phase(c, 2u);', 'o->scene != 0) {\n        set_phase(c, 2u);'),
        'state 3: scene shortcut for scene 0': ('o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {\n        set_phase(c, 2u);', 'o->scene != E0_NO_SCENE && o->typed == 0) {\n        set_phase(c, 2u);'),
        'state 3: scene shortcut for scene 9999': ('o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {\n        set_phase(c, 2u);', 'o->scene != 0 && o->typed == 0) {\n        set_phase(c, 2u);'),
        'state 3: scene shortcut only for positive scenes': ('o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {\n        set_phase(c, 2u);', 'o->scene != E0_NO_SCENE && o->scene > 0 && o->typed == 0) {\n        set_phase(c, 2u);'),
        'state 3: scene shortcut to phase 1': ('o->scene != 0 && o->typed == 0) {\n        set_phase(c, 2u);', 'o->scene != 0 && o->typed == 0) {\n        set_phase(c, 1u);'),
        'state 3: sound B tested inverted': ('if (!no_sound(b + B_SOUND_B)) {\n        HOST(h->sound_prepare', 'if (no_sound(b + B_SOUND_B)) {\n        HOST(h->sound_prepare'),
        'state 3: sound A prepared': ('HOST(h->sound_prepare(h->context, b + B_SOUND_B));', 'HOST(h->sound_prepare(h->context, b + B_SOUND_A));'),
        'state 3: sound B not prepared': ('HOST(h->sound_prepare(h->context, b + B_SOUND_B));\n        fx(h, E0_FX_SOUND_PREPARE, B_SOUND_B, 0);', 'fx(h, E0_FX_SOUND_PREPARE, B_SOUND_B, 0);'),
        'state 3: click channel played': ('HOST(h->sound_play(h->context, rd_s16(b, B_WIN_CHANNEL)));', 'HOST(h->sound_play(h->context, rd_s16(b, B_CLICK_CHANNEL)));'),
        'state 3: sound B not played': ('HOST(h->sound_play(h->context, rd_s16(b, B_WIN_CHANNEL)));\n        fx(h, E0_FX_SOUND_PLAY, rd_s16(b, B_WIN_CHANNEL), 0);', 'fx(h, E0_FX_SOUND_PLAY, rd_s16(b, B_WIN_CHANNEL), 0);'),
        'state 3: sound B state wrong': ('fx(h, E0_FX_SOUND_PLAY, rd_s16(b, B_WIN_CHANNEL), 0);\n        o->state = 4;', 'fx(h, E0_FX_SOUND_PLAY, rd_s16(b, B_WIN_CHANNEL), 0);\n        o->state = 3;'),
        'state 3: solved test inverted': ('if (o->solved != 0u) {\n        set_phase(c, 2u);\n        return E0_OK;\n    }\n    return next_round(c);', 'if (o->solved == 0u) {\n        set_phase(c, 2u);\n        return E0_OK;\n    }\n    return next_round(c);'),
        'state 3: finish without the solved test': ('if (o->solved != 0u) {\n        set_phase(c, 2u);\n        return E0_OK;\n    }\n    return next_round(c);', 'if (1) {\n        set_phase(c, 2u);\n        return E0_OK;\n    }\n    return next_round(c);'),
        'state 3: finish keeps phase 1': ('if (o->solved != 0u) {\n        set_phase(c, 2u);\n        return E0_OK;\n    }\n    return next_round(c);', 'if (o->solved != 0u) {\n        set_phase(c, 1u);\n        return E0_OK;\n    }\n    return next_round(c);'),
        'round: record index': ('(long)B_ROUND1 + (long)((int32_t)o->round - 1) * (long)E0_ROUND_BYTES', '(long)B_ROUND1 + (long)((int32_t)o->round - 2) * (long)E0_ROUND_BYTES'),
        'round: record stride': ('(long)((int32_t)o->round - 1) * (long)E0_ROUND_BYTES', '(long)((int32_t)o->round - 1) * 32L'),
        'round: counter step': ('o->round = (int16_t)(o->round + 1);', 'o->round = (int16_t)(o->round + 2);'),
        'round: counter kept': ('o->round = (int16_t)(o->round + 1);', '(void)0;'),
        'round: blink kept': ('o->blink = 0u;\n    o->state = 0;\n    return E0_OK;', 'o->state = 0;\n    return E0_OK;'),
        'round: state kept': ('o->blink = 0u;\n    o->state = 0;\n    return E0_OK;', 'o->blink = 0u;\n    return E0_OK;'),
        'round: state 1': ('o->blink = 0u;\n    o->state = 0;\n    return E0_OK;', 'o->blink = 0u;\n    o->state = 1;\n    return E0_OK;'),
        'round: bounds ignored': ('int rc = load_record(o, c->b, (long)B_ROUND1 + (long)((int32_t)o->round - 1) * (long)E0_ROUND_BYTES);\n    if (rc != E0_OK) return rc;', 'int rc = load_record(o, c->b, (long)B_ROUND1 + (long)((int32_t)o->round - 1) * (long)E0_ROUND_BYTES);\n    (void)rc;'),
        'record: length 30 refused': ('rd_s16(body, (size_t)off) > E0_MAX_CODE', 'rd_s16(body, (size_t)off) >= E0_MAX_CODE'),
        'record: length 31 accepted': ('rd_s16(body, (size_t)off) > E0_MAX_CODE', 'rd_s16(body, (size_t)off) > E0_MAX_CODE + 1'),
        'record: negative length accepted': ('rd_s16(body, (size_t)off) < 0 ||', 'rd_s16(body, (size_t)off) < -1 ||'),
        'record: negative offset accepted': ('if (off < 0 || (size_t)off + E0_ROUND_BYTES > E0_BODY_CAPACITY) return E0_ERR_BOUNDS;', 'if ((size_t)off + E0_ROUND_BYTES > E0_BODY_CAPACITY) return E0_ERR_BOUNDS;'),
        'record: late offset accepted': ('if (off < 0 || (size_t)off + E0_ROUND_BYTES > E0_BODY_CAPACITY) return E0_ERR_BOUNDS;', 'if (off < 0) return E0_ERR_BOUNDS;'),
        'record: ordered byte lost': ('o->code_ordered = body[(size_t)off + 2];', 'o->code_ordered = 0u;'),
        'record: code bytes from the wrong place': ('memcpy(o->code, body + (size_t)off + 3, E0_MAX_CODE);', 'memcpy(o->code, body + (size_t)off + 2, E0_MAX_CODE);'),
        'record: length not copied': ('o->code_len = rd_s16(body, (size_t)off);', '(void)0;'),
        'state 4: busy tested inverted': ('if (busy == 0) {\n        HOST(h->sound_stop(h->context, b + B_SOUND_B));', 'if (busy != 0) {\n        HOST(h->sound_stop(h->context, b + B_SOUND_B));'),
        'state 4: sound A stopped': ('HOST(h->sound_stop(h->context, b + B_SOUND_B));\n        fx(h, E0_FX_SOUND_STOP, B_SOUND_B, 0);\n        if (o->solved != 0u) {', 'HOST(h->sound_stop(h->context, b + B_SOUND_A));\n        fx(h, E0_FX_SOUND_STOP, B_SOUND_B, 0);\n        if (o->solved != 0u) {'),
        'state 4: sound B not stopped': ('HOST(h->sound_stop(h->context, b + B_SOUND_B));\n        fx(h, E0_FX_SOUND_STOP, B_SOUND_B, 0);\n        if (o->solved != 0u) {', 'fx(h, E0_FX_SOUND_STOP, B_SOUND_B, 0);\n        if (o->solved != 0u) {'),
        'state 4: click channel polled': ('const int16_t channel = rd_s16(b, B_WIN_CHANNEL);', 'const int16_t channel = rd_s16(b, B_CLICK_CHANNEL);'),
        'state 4: solved test inverted': ('        if (o->solved != 0u) {\n            set_phase(c, 2u);\n            return E0_OK;\n        }\n        return next_round(c);\n    }\n    blink_step(c);', '        if (o->solved == 0u) {\n            set_phase(c, 2u);\n            return E0_OK;\n        }\n        return next_round(c);\n    }\n    blink_step(c);'),
        'state 4: busy without blink step': ('        return next_round(c);\n    }\n    blink_step(c);', '        return next_round(c);\n    }'),
        'state 4: idle finish keeps phase 1': ('        if (o->solved != 0u) {\n            set_phase(c, 2u);\n            return E0_OK;\n        }\n        return next_round(c);\n    }\n    blink_step(c);', '        if (o->solved != 0u) {\n            set_phase(c, 1u);\n            return E0_OK;\n        }\n        return next_round(c);\n    }\n    blink_step(c);'),
        # --- the visit ---------------------------------------------------------------------------------------------
        'step: state 0 handler wrong': ('case 0: rc = state0(&c); break;', 'case 0: rc = state1(&c); break;'),
        'step: state 1 handler wrong': ('case 1: rc = state1(&c); break;', 'case 1: rc = state3(&c); break;'),
        'step: state 3 handler wrong': ('case 3: rc = state3(&c); break;', 'case 3: rc = state4(&c); break;'),
        'step: state 4 handler wrong': ('case 4: rc = state4(&c); break;', 'case 4: rc = state3(&c); break;'),
        'step: other states act': ('default: rc = E0_OK; break;', 'default: rc = state0(&c); break;'),
        'step: phase 3 acts': ('if (phase > 2u) return E0_OK;', 'if (phase > 3u) return E0_OK;'),
        'step: phase 2 ignored': ('if (phase > 2u) return E0_OK;', 'if (phase > 1u) return E0_OK;'),
        'step: body not validated': ('if (e0_validate_body(flag, body, body_length, failure) != E0_OK) return E0_ERR_BODY;', 'if (0) return E0_ERR_BODY;'),
        'step: phase 1 without phase 0': ('if (phase != 0u && (object->initialized == 0u || object->row != row)) {', 'if (0) {'),
        'step: phase 1 for another row': ('(object->initialized == 0u || object->row != row)', '(object->initialized == 0u)'),
        'step: phase 1 without initialisation': ('(object->initialized == 0u || object->row != row)', '(object->row != row)'),
        'step: phase not reported': ('result->phase_after = c.phase;', 'result->phase_after = phase;'),
        'step: initialisation not reported': ('if (rc == E0_OK) result->initialized = 1u;', '(void)0;'),
        'step: initialised on failure': ('if (rc == E0_OK) result->initialized = 1u;', 'result->initialized = 1u;'),
        'step: observer required': ('if (host->observe != NULL) host->observe(host->context, effect, a, b);', 'host->observe(host->context, effect, a, b);'),
        'step: host completeness not checked': ('h->store_event_flag != NULL && h->event_flag_invalid != NULL;', 'h->store_event_flag != NULL;'),
        'step: alloc not required': ('return h != NULL && h->alloc_slot != NULL &&', 'return h != NULL &&'),
        'step: release surface not required': ('h->set_slot_surface != NULL && h->release_surface != NULL && h->release_slot != NULL &&', 'h->set_slot_surface != NULL && h->release_slot != NULL &&'),
        'step: busy not required': ('h->sound_play != NULL && h->sound_busy != NULL && h->tick != NULL', 'h->sound_play != NULL && h->tick != NULL'),
        'step: tick not required': ('h->sound_busy != NULL && h->tick != NULL && h->transition != NULL', 'h->sound_busy != NULL && h->transition != NULL'),
        'step: origin not required': ('h->mark_dirty != NULL && h->view_origin != NULL && h->sound_prepare != NULL', 'h->mark_dirty != NULL && h->sound_prepare != NULL'),
        'step: dirty not required': ('h->mark_dirty != NULL && h->view_origin != NULL', 'h->view_origin != NULL'),
        'step: register not required': ('h->register_slot != NULL && h->load_surface != NULL', 'h->load_surface != NULL'),
        'step: load not required': ('h->load_surface != NULL &&\n           h->set_slot_surface', 'h->set_slot_surface'),
        'step: stop not required': ('h->sound_prepare != NULL && h->sound_stop != NULL &&', 'h->sound_prepare != NULL &&'),
        'step: prepare not required': ('h->sound_prepare != NULL && h->sound_stop != NULL &&', 'h->sound_stop != NULL &&'),
        'step: play not required': ('h->sound_stop != NULL &&\n           h->sound_play != NULL && h->sound_busy', 'h->sound_stop != NULL &&\n           h->sound_busy'),
        'step: transition not required': ('h->tick != NULL && h->transition != NULL &&', 'h->tick != NULL &&'),
        'step: store flag not required': ('h->transition != NULL &&\n           h->store_event_flag != NULL', 'h->transition != NULL'),
        'step: surface slot not required': ('h->load_surface != NULL &&\n           h->set_slot_surface != NULL', 'h->load_surface != NULL'),
        'step: release slot not required': ('h->release_surface != NULL && h->release_slot != NULL &&', 'h->release_surface != NULL &&'),
        # --- phase 2 -----------------------------------------------------------------------------------------------
        'phase 2: exit branch inverted': ('const int exit_branch = o->exit_asked != 0u;', 'const int exit_branch = o->exit_asked == 0u;'),
        'phase 2: sets branch inverted': ('const int sets_branch = !exit_branch && o->solved_sets != 0u;', 'const int sets_branch = !exit_branch && o->solved_sets == 0u;'),
        'phase 2: exit flag from the sets block': ('flag_index = rd_s16(b, B_EXIT_FLAG);', 'flag_index = rd_s16(b, B_ALL_FLAG);'),
        'phase 2: exit value from the sets block': ('flag_value = b[B_EXIT_VALUE];', 'flag_value = b[B_ALL_VALUE];'),
        'phase 2: sets flag from the failed block': ('flag_index = rd_s16(b, B_ALL_FLAG);', 'flag_index = rd_s16(b, B_FAIL_FLAG);'),
        'phase 2: sets value from the failed block': ('flag_value = b[B_ALL_VALUE];', 'flag_value = b[B_FAIL_VALUE];'),
        'phase 2: failed flag from the exit block': ('flag_index = rd_s16(b, B_FAIL_FLAG);', 'flag_index = rd_s16(b, B_EXIT_FLAG);'),
        'phase 2: failed value from the exit block': ('flag_value = b[B_FAIL_VALUE];', 'flag_value = b[B_EXIT_VALUE];'),
        'phase 2: event flag not validated': ('if (flag_invalid(h, flag_index)) return E0_ERR_BOUNDS;', '(void)0;'),
        'phase 2: no flag is invalid': ('return index != E0_NO_FLAG && h->event_flag_invalid(h->context, index) != 0;', 'return h->event_flag_invalid(h->context, index) != 0;'),
        'phase 2: flag check inverted': ('return index != E0_NO_FLAG && h->event_flag_invalid(h->context, index) != 0;', 'return index != E0_NO_FLAG && h->event_flag_invalid(h->context, index) == 0;'),
        'phase 2: flag check dropped': ('return index != E0_NO_FLAG && h->event_flag_invalid(h->context, index) != 0;', 'return 0;'),
        'phase 2: start flag cleared first': ('w->start_flag_5bb1ca = 1;\n    fx(h, E0_FX_START_FLAG, 1, 0);\n    o->blink = 0u;', 'w->start_flag_5bb1ca = 0;\n    fx(h, E0_FX_START_FLAG, 1, 0);\n    o->blink = 0u;'),
        'phase 2: blink kept': ('o->blink = 0u;\n    o->active = 0u;\n    w->entry17_active_5d1a8f = 0;', 'o->active = 0u;\n    w->entry17_active_5d1a8f = 0;'),
        'phase 2: still active': ('o->blink = 0u;\n    o->active = 0u;\n    w->entry17_active_5d1a8f = 0;', 'o->blink = 0u;\n    w->entry17_active_5d1a8f = 0;'),
        'phase 2: leftover cell kept': ('w->entry17_active_5d1a8f = 0;', '(void)0;'),
        'phase 2: leftover cell set': ('w->entry17_active_5d1a8f = 0;\n    fx(h, E0_FX_ENTRY17_ACTIVE, 0, 0);', 'w->entry17_active_5d1a8f = 1;\n    fx(h, E0_FX_ENTRY17_ACTIVE, 0, 0);'),
        'phase 2: sound A stopped when none': ('if (!no_sound(b + B_SOUND_A)) {\n        HOST(h->sound_stop', 'if (no_sound(b + B_SOUND_A)) {\n        HOST(h->sound_stop'),
        'phase 2: sound B stopped': ('HOST(h->sound_stop(h->context, b + B_SOUND_A));\n        fx(h, E0_FX_SOUND_STOP, B_SOUND_A, 0);\n    }\n    if (exit_branch) {', 'HOST(h->sound_stop(h->context, b + B_SOUND_B));\n        fx(h, E0_FX_SOUND_STOP, B_SOUND_A, 0);\n    }\n    if (exit_branch) {'),
        'phase 2: sound A not stopped': ('HOST(h->sound_stop(h->context, b + B_SOUND_A));\n        fx(h, E0_FX_SOUND_STOP, B_SOUND_A, 0);\n    }\n    if (exit_branch) {', 'fx(h, E0_FX_SOUND_STOP, B_SOUND_A, 0);\n    }\n    if (exit_branch) {'),
        'phase 2: exit block applied for no scene': ('if (rd_s16(b, B_EXIT_BLOCK) != E0_NO_SCENE) {', 'if (rd_s16(b, B_EXIT_BLOCK) == E0_NO_SCENE) {'),
        'phase 2: exit block always applied': ('if (rd_s16(b, B_EXIT_BLOCK) != E0_NO_SCENE) {', 'if (1) {'),
        'phase 2: exit block from the sets offset': ('apply_block(b + B_EXIT_BLOCK, rd_s16(b, B_EXIT_START), w, h)', 'apply_block(b + B_ALL_BLOCK, rd_s16(b, B_EXIT_START), w, h)'),
        'phase 2: exit start flag from the sets block': ('apply_block(b + B_EXIT_BLOCK, rd_s16(b, B_EXIT_START), w, h)', 'apply_block(b + B_EXIT_BLOCK, rd_s16(b, B_ALL_START), w, h)'),
        'phase 2: sets block applied for no scene': ('if (rd_s16(b, B_ALL_BLOCK) != E0_NO_SCENE) {', 'if (rd_s16(b, B_ALL_BLOCK) == E0_NO_SCENE) {'),
        'phase 2: sets block from the exit offset': ('apply_block(b + B_ALL_BLOCK, rd_s16(b, B_ALL_START), w, h)', 'apply_block(b + B_EXIT_BLOCK, rd_s16(b, B_ALL_START), w, h)'),
        'phase 2: sets start flag from the exit block': ('apply_block(b + B_ALL_BLOCK, rd_s16(b, B_ALL_START), w, h)', 'apply_block(b + B_ALL_BLOCK, rd_s16(b, B_EXIT_START), w, h)'),
        'phase 2: assigns a scene without the checks': ('if (o->solved == 0u && o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {', 'if (o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {'),
        'phase 2: assigns the scene of a solved puzzle': ('if (o->solved == 0u && o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {', 'if (o->solved != 0u && o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {'),
        'phase 2: assigns scene 9999': ('if (o->solved == 0u && o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {', 'if (o->solved == 0u && o->scene != 0 && o->typed == 0) {'),
        'phase 2: assigns scene 0': ('if (o->solved == 0u && o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {', 'if (o->solved == 0u && o->scene != E0_NO_SCENE && o->typed == 0) {'),
        'phase 2: assigns with typed keys': ('if (o->solved == 0u && o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {', 'if (o->solved == 0u && o->scene != E0_NO_SCENE && o->scene != 0) {'),
        'phase 2: assigns only positive scenes': ('o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {\n            fail_scene', 'o->scene != E0_NO_SCENE && o->scene > 0 && o->typed == 0) {\n            fail_scene'),
        'phase 2: assigned scene from the failed block': ('fail_scene = o->scene;', 'fail_scene = rd_s16(b, B_FAIL_BLOCK);'),
        'phase 2: failed scene tested inverted': ('} else if (rd_s16(b, B_FAIL_BLOCK) != E0_NO_SCENE) {', '} else if (rd_s16(b, B_FAIL_BLOCK) == E0_NO_SCENE) {'),
        'phase 2: failed scene from the exit block': ('fail_scene = rd_s16(b, B_FAIL_BLOCK);', 'fail_scene = rd_s16(b, B_EXIT_BLOCK);'),
        'phase 2: scene cell not assigned': ('w->scene_cell_5bb57b = fail_scene;', '(void)0;'),
        'phase 2: scene cell stored wrongly': ('w->scene_cell_5bb57b = fail_scene;', 'w->scene_cell_5bb57b = (int16_t)fail_scene + 1;'),
        'phase 2: scene cell effect missing': ('fx(h, E0_FX_XFER_5BB57B, fail_scene, 0);', '(void)0;'),
        'phase 2: stale cell ignored': ('if (w->scene_cell_5bb57b != E0_NO_SCENE) {\n            E0Transition t;', 'if (fail_assigns) {\n            E0Transition t;'),
        'phase 2: stale cell compared as a word': ('if (w->scene_cell_5bb57b != E0_NO_SCENE) {\n            E0Transition t;', 'if ((int16_t)w->scene_cell_5bb57b != E0_NO_SCENE) {\n            E0Transition t;'),
        'phase 2: stale cell compared with 0': ('if (w->scene_cell_5bb57b != E0_NO_SCENE) {\n            E0Transition t;', 'if (w->scene_cell_5bb57b != 0) {\n            E0Transition t;'),
        'phase 2: stale cell always used': ('if (w->scene_cell_5bb57b != E0_NO_SCENE) {\n            E0Transition t;', 'if (1) {\n            E0Transition t;'),
        'phase 2: transition scene wrong': ('t.scene = w->scene_cell_5bb57b;', 't.scene = fail_scene;'),
        'phase 2: failed words swapped': ('t.word[0] = rd_s16(b, B_FAIL_BLOCK + SB_W1);', 't.word[0] = rd_s16(b, B_FAIL_BLOCK + SB_W2);'),
        'phase 2: failed third word wrong': ('t.word[2] = rd_s16(b, B_FAIL_BLOCK + SB_W3);', 't.word[2] = rd_s16(b, B_FAIL_BLOCK + SB_W1);'),
        'phase 2: failed dwords swapped': ('t.dword[0] = rd_s32(b, B_FAIL_BLOCK + SB_D1);', 't.dword[0] = rd_s32(b, B_FAIL_BLOCK + SB_D2);'),
        'phase 2: failed third dword wrong': ('t.dword[2] = rd_s32(b, B_FAIL_BLOCK + SB_D3);', 't.dword[2] = rd_s32(b, B_FAIL_BLOCK + SB_D1);'),
        'phase 2: failed start flag 1 stores 1': ('w->start_flag_5bb1ca = rd_s16(b, B_FAIL_START) == 1 ? 0 : 1;', 'w->start_flag_5bb1ca = rd_s16(b, B_FAIL_START) == 1 ? 1 : 0;'),
        'phase 2: failed start flag from nonzero': ('w->start_flag_5bb1ca = rd_s16(b, B_FAIL_START) == 1 ? 0 : 1;', 'w->start_flag_5bb1ca = rd_s16(b, B_FAIL_START) != 0 ? 0 : 1;'),
        'phase 2: failed start flag from the exit block': ('rd_s16(b, B_FAIL_START) == 1 ? 0 : 1', 'rd_s16(b, B_EXIT_START) == 1 ? 0 : 1'),
        'phase 2: failed engine mode': ('w->start_flag_5bb1ca = rd_s16(b, B_FAIL_START) == 1 ? 0 : 1;\n            fx(h, E0_FX_START_FLAG, w->start_flag_5bb1ca, 0);\n            fx(h, E0_FX_ENGINE_MODE, 4, 0);', 'w->start_flag_5bb1ca = rd_s16(b, B_FAIL_START) == 1 ? 0 : 1;\n            fx(h, E0_FX_START_FLAG, w->start_flag_5bb1ca, 0);\n            fx(h, E0_FX_ENGINE_MODE, 3, 0);'),
        'phase 2: block scene unsigned': ('t.scene = rd_s16(blk, SB_SCENE);', 't.scene = (uint16_t)rd_s16(blk, SB_SCENE);'),
        'phase 2: block words swapped': ('t.word[0] = rd_s16(blk, SB_W1);', 't.word[0] = rd_s16(blk, SB_W2);'),
        'phase 2: block third word wrong': ('t.word[2] = rd_s16(blk, SB_W3);', 't.word[2] = rd_s16(blk, SB_W1);'),
        'phase 2: block dwords swapped': ('t.dword[0] = rd_s32(blk, SB_D1);', 't.dword[0] = rd_s32(blk, SB_D2);'),
        'phase 2: block third dword wrong': ('t.dword[2] = rd_s32(blk, SB_D3);', 't.dword[2] = rd_s32(blk, SB_D1);'),
        'phase 2: block scene cell kept': ('world->scene_cell_5bb57b = t.scene;', '(void)0;'),
        'phase 2: block start flag 1 stores 1': ('world->start_flag_5bb1ca = start_word == 1 ? 0 : 1;', 'world->start_flag_5bb1ca = start_word == 1 ? 1 : 0;'),
        'phase 2: block start flag from nonzero': ('world->start_flag_5bb1ca = start_word == 1 ? 0 : 1;', 'world->start_flag_5bb1ca = start_word != 0 ? 0 : 1;'),
        'phase 2: block engine mode': ('fx(host, E0_FX_ENGINE_MODE, 4, 0);\n    return E0_OK;', 'fx(host, E0_FX_ENGINE_MODE, 3, 0);\n    return E0_OK;'),
        'phase 2: block start flag effect missing': ('fx(host, E0_FX_START_FLAG, world->start_flag_5bb1ca, 0);', '(void)0;'),
        'phase 2: flag stored for -1': ('if (flag_index != E0_NO_FLAG) {\n        const int rc = store_flag', 'if (1) {\n        const int rc = store_flag'),
        'phase 2: flag never stored': ('if (flag_index != E0_NO_FLAG) {\n        const int rc = store_flag', 'if (0) {\n        const int rc = store_flag'),
        'phase 2: flag value wrong': ('store_flag(h, flag_index, flag_value)', 'store_flag(h, flag_index, 1)'),
        'phase 2: flag value signed': ('HOST(host->store_event_flag(host->context, index, value));', 'HOST(host->store_event_flag(host->context, index, (uint32_t)(int8_t)value));'),
        'phase 2: completion effect missing': ('fx(h, E0_FX_COMPLETE, o->row, 0);', '(void)0;'),
        'phase 2: completion row wrong': ('fx(h, E0_FX_COMPLETE, o->row, 0);', 'fx(h, E0_FX_COMPLETE, o->row + 1, 0);'),
        'phase 2: no cleanup': ('const int rc = e0_cleanup(o, h);\n        if (rc != E0_OK) return rc;', 'const int rc = E0_OK;\n        if (rc != E0_OK) return rc;'),
        'phase 2: cleanup failure ignored': ('const int rc = e0_cleanup(o, h);\n        if (rc != E0_OK) return rc;', 'const int rc = e0_cleanup(o, h);\n        (void)rc;'),
        'phase 2: completion not flagged': ('result->completed = 1u;', '(void)0;'),
        'phase 2: phase reported as 0': ('c->phase = 2u;\n    return E0_OK;\n}', 'c->phase = 0u;\n    return E0_OK;\n}'),
        'phase 2: block failure ignored': ('const int rc = apply_block(b + B_EXIT_BLOCK, rd_s16(b, B_EXIT_START), w, h);\n            if (rc != E0_OK) return rc;', 'const int rc = apply_block(b + B_EXIT_BLOCK, rd_s16(b, B_EXIT_START), w, h);\n            (void)rc;'),
        'phase 2: sets block failure ignored': ('const int rc = apply_block(b + B_ALL_BLOCK, rd_s16(b, B_ALL_START), w, h);\n            if (rc != E0_OK) return rc;', 'const int rc = apply_block(b + B_ALL_BLOCK, rd_s16(b, B_ALL_START), w, h);\n            (void)rc;'),
        'phase 2: flag failure ignored': ('const int rc = store_flag(h, flag_index, flag_value);\n        if (rc != E0_OK) return rc;', 'const int rc = store_flag(h, flag_index, flag_value);\n        (void)rc;'),
        # --- cleanup, invalidate, scene reset ----------------------------------------------------------------------
        'cleanup: surface released always': ('if (object->surface != 0u) {\n        const uint32_t surface', 'if (1) {\n        const uint32_t surface'),
        'cleanup: surface never released': ('if (object->surface != 0u) {\n        const uint32_t surface', 'if (0) {\n        const uint32_t surface'),
        'cleanup: surface kept on release': ('object->surface = 0u;\n        fx(host, E0_FX_RELEASE_SURFACE', 'fx(host, E0_FX_RELEASE_SURFACE'),
        'cleanup: slot released always': ('if (object->slot != E0_NO_SLOT) {\n        const int16_t slot', 'if (1) {\n        const int16_t slot'),
        'cleanup: slot never released': ('if (object->slot != E0_NO_SLOT) {\n        const int16_t slot', 'if (0) {\n        const int16_t slot'),
        'cleanup: slot zero not released': ('if (object->slot != E0_NO_SLOT) {\n        const int16_t slot', 'if (object->slot > 0) {\n        const int16_t slot'),
        'cleanup: row kept': ('object->row = -1;\n    object->slot = -1;', 'object->slot = -1;'),
        'cleanup: slot kept': ('object->row = -1;\n    object->slot = -1;', 'object->row = -1;'),
        'cleanup: active kept': ('object->active = 0u;\n    object->exit_asked = 0u;', 'object->exit_asked = 0u;'),
        'cleanup: exit request kept': ('object->exit_asked = 0u;\n    object->solved = 0u;', 'object->solved = 0u;'),
        'cleanup: solved kept': ('object->solved = 0u;\n    object->solved_sets = 0u;', 'object->solved_sets = 0u;'),
        'cleanup: solved sets kept': ('object->solved_sets = 0u;\n    object->blink = 0u;', 'object->blink = 0u;'),
        'cleanup: blink kept': ('object->blink = 0u;\n    object->initialized = 0u;', 'object->initialized = 0u;'),
        'cleanup: initialised kept': ('object->initialized = 0u;\n    return E0_OK;', 'return E0_OK;'),
        'cleanup: too much reset': ('object->initialized = 0u;\n    return E0_OK;', 'object->initialized = 0u;\n    object->typed = 0;\n    return E0_OK;'),
        'invalidate: inactive marked': ('if (object->active != 0u && object->slot != E0_NO_SLOT) {', 'if (object->slot != E0_NO_SLOT) {'),
        'invalidate: no slot marked': ('if (object->active != 0u && object->slot != E0_NO_SLOT) {', 'if (object->active != 0u) {'),
        'invalidate: never marked': ('if (object->active != 0u && object->slot != E0_NO_SLOT) {', 'if (0) {'),
        'scene reset: round kept': ('object->word_5957b5 = 0;\n    object->round = 0;', 'object->word_5957b5 = 0;'),
        'scene reset: word kept': ('object->word_5957b5 = 0;\n    object->round = 0;', 'object->round = 0;'),
        'reset: row not set': ('object->row = -1;\n    object->slot = E0_NO_SLOT;\n}', 'object->slot = E0_NO_SLOT;\n}'),
        'reset: slot not set': ('object->row = -1;\n    object->slot = E0_NO_SLOT;\n}', 'object->row = -1;\n}'),
        # --- pointer -----------------------------------------------------------------------------------------------
        'pointer: x not truncated': ('const int32_t x = (int16_t)xin;', 'const int32_t x = xin;'),
        'pointer: y not truncated': ('const int32_t y = (int16_t)yin;', 'const int32_t y = yin;'),
        'pointer: x unsigned': ('const int32_t x = (int16_t)xin;', 'const int32_t x = (uint16_t)xin;'),
        'pointer: y unsigned': ('const int32_t y = (int16_t)yin;', 'const int32_t y = (uint16_t)yin;'),
        'pointer: inactive claims': ('if (o->active != 0u) {\n        const int16_t n = rd_s16(b, B_COUNT);', 'if (1) {\n        const int16_t n = rd_s16(b, B_COUNT);'),
        'pointer: exit top edge exclusive': ('y >= rd_s32(b, B_EXIT_AREA + 4)', 'y > rd_s32(b, B_EXIT_AREA + 4)'),
        'pointer: exit bottom edge exclusive': ('y <= rd_s32(b, B_EXIT_AREA + 12)', 'y < rd_s32(b, B_EXIT_AREA + 12)'),
        'pointer: exit left edge exclusive': ('x >= rd_s32(b, B_EXIT_AREA) &&', 'x > rd_s32(b, B_EXIT_AREA) &&'),
        'pointer: exit right edge exclusive': ('x <= rd_s32(b, B_EXIT_AREA + 8)', 'x < rd_s32(b, B_EXIT_AREA + 8)'),
        'pointer: exit rectangle from the exit button': ('y >= rd_s32(b, B_EXIT_AREA + 4) && y <= rd_s32(b, B_EXIT_AREA + 12) && x >= rd_s32(b, B_EXIT_AREA) &&', 'y >= rd_s32(b, B_EXIT_RECT + 4) && y <= rd_s32(b, B_EXIT_AREA + 12) && x >= rd_s32(b, B_EXIT_AREA) &&'),
        'pointer: exit rectangle candidate': ('pointer_hit(out, E0_CURSOR_EXIT, E0_CANDIDATE_EXIT);', 'pointer_hit(out, E0_CURSOR_EXIT, E0_CANDIDATE_KEY);'),
        'pointer: exit rectangle cursor': ('pointer_hit(out, E0_CURSOR_EXIT, E0_CANDIDATE_EXIT);', 'pointer_hit(out, E0_CURSOR_PICK, E0_CANDIDATE_EXIT);'),
        'pointer: exit rectangle stores the hover': ('pointer_hit(out, E0_CURSOR_EXIT, E0_CANDIDATE_EXIT);\n            return E0_OK;', 'pointer_hit(out, E0_CURSOR_EXIT, E0_CANDIDATE_EXIT);\n            o->hover = -1;\n            return E0_OK;'),
        'pointer: key count capped': ('for (int16_t i = 0; i < n && i < E0_MAX_KEYS; ++i) {', 'for (int16_t i = 0; i < n; ++i) {'),
        'pointer: one key too many': ('for (int16_t i = 0; i < n && i < E0_MAX_KEYS; ++i) {', 'for (int16_t i = 0; i <= n && i < E0_MAX_KEYS; ++i) {'),
        'pointer: one key too few': ('for (int16_t i = 0; i < n && i < E0_MAX_KEYS; ++i) {', 'for (int16_t i = 0; i < n - 1 && i < E0_MAX_KEYS; ++i) {'),
        'pointer: keys hit while waiting': ('if (o->waiting == 0u && y >= o->rect_b[i][1]', 'if (y >= o->rect_b[i][1]'),
        'pointer: key top edge exclusive': ('y >= o->rect_b[i][1]', 'y > o->rect_b[i][1]'),
        'pointer: key bottom edge exclusive': ('y <= o->rect_b[i][3]', 'y < o->rect_b[i][3]'),
        'pointer: key left edge exclusive': ('x >= o->rect_b[i][0]', 'x > o->rect_b[i][0]'),
        'pointer: key right edge exclusive': ('x <= o->rect_b[i][2]', 'x < o->rect_b[i][2]'),
        'pointer: keys from the source rectangles': ('y >= o->rect_b[i][1] && y <= o->rect_b[i][3] && x >= o->rect_b[i][0] &&\n                x <= o->rect_b[i][2]', 'y >= o->rect_a[i][1] && y <= o->rect_a[i][3] && x >= o->rect_a[i][0] &&\n                x <= o->rect_a[i][2]'),
        'pointer: key candidate': ('pointer_hit(out, E0_CURSOR_PICK, E0_CANDIDATE_KEY);\n                o->hover = i;', 'pointer_hit(out, E0_CURSOR_PICK, E0_CANDIDATE_EXIT);\n                o->hover = i;'),
        'pointer: key cursor': ('pointer_hit(out, E0_CURSOR_PICK, E0_CANDIDATE_KEY);\n                o->hover = i;', 'pointer_hit(out, E0_CURSOR_EXIT, E0_CANDIDATE_KEY);\n                o->hover = i;'),
        'pointer: key hover not stored': ('o->hover = i;', '(void)0;'),
        'pointer: key hover off by one': ('o->hover = i;', 'o->hover = i + 1;'),
        'pointer: key scan continues': ('o->hover = i;\n                return E0_OK;', 'o->hover = i;'),
        'pointer: exit button hit while waiting': ('if (o->waiting == 0u && b[B_HAS_EXIT] != 0u &&', 'if (b[B_HAS_EXIT] != 0u &&'),
        'pointer: exit button without the flag': ('if (o->waiting == 0u && b[B_HAS_EXIT] != 0u &&', 'if (o->waiting == 0u &&'),
        'pointer: exit button top edge exclusive': ('y >= rd_s32(b, B_EXIT_RECT + 4)', 'y > rd_s32(b, B_EXIT_RECT + 4)'),
        'pointer: exit button bottom edge exclusive': ('y <= rd_s32(b, B_EXIT_RECT + 12)', 'y < rd_s32(b, B_EXIT_RECT + 12)'),
        'pointer: exit button left edge exclusive': ('x >= rd_s32(b, B_EXIT_RECT) &&', 'x > rd_s32(b, B_EXIT_RECT) &&'),
        'pointer: exit button right edge exclusive': ('x <= rd_s32(b, B_EXIT_RECT + 8))', 'x < rd_s32(b, B_EXIT_RECT + 8))'),
        'pointer: exit button from the pressed source': ('y >= rd_s32(b, B_EXIT_RECT + 4)', 'y >= rd_s32(b, B_EXIT_SRC + 4)'),
        'pointer: exit button hover': ('o->hover = E0_EXIT_KEY;\n            return E0_OK;', 'o->hover = 0x29;\n            return E0_OK;'),
        'pointer: exit button candidate': ('pointer_hit(out, E0_CURSOR_PICK, E0_CANDIDATE_KEY);\n            o->hover = E0_EXIT_KEY;', 'pointer_hit(out, E0_CURSOR_PICK, E0_CANDIDATE_EXIT);\n            o->hover = E0_EXIT_KEY;'),
        'pointer: miss keeps the hover': ('    o->hover = -1;\n    return E0_OK;\n}\n\nint e0_click', '    return E0_OK;\n}\n\nint e0_click'),
        'pointer: miss stores another hover': ('    o->hover = -1;\n    return E0_OK;\n}\n\nint e0_click', '    o->hover = 0;\n    return E0_OK;\n}\n\nint e0_click'),
        'pointer: result not cleared': ('memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (o->active', 'out->candidate = -1;\n    if (o->active'),
        'pointer: default candidate': ('memset(out, 0, sizeof(*out));\n    out->candidate = -1;', 'memset(out, 0, sizeof(*out));\n    out->candidate = 0;'),
        'pointer: hit flag lost': ('out->hit = 1u;\n    out->cursor = (uint8_t)cursor;', 'out->hit = 0u;\n    out->cursor = (uint8_t)cursor;'),
        'pointer: cursor lost': ('out->cursor = (uint8_t)cursor;', '(void)0;'),
        'pointer: candidate lost': ('out->candidate = candidate;', '(void)0;'),
        # --- click -------------------------------------------------------------------------------------------------
        'click: inactive acts': ('if (o->active == 0u || o->state != 0 || row_phase != 1u) return E0_OK;', 'if (o->state != 0 || row_phase != 1u) return E0_OK;'),
        'click: any state acts': ('if (o->active == 0u || o->state != 0 || row_phase != 1u) return E0_OK;', 'if (o->active == 0u || row_phase != 1u) return E0_OK;'),
        'click: any phase acts': ('if (o->active == 0u || o->state != 0 || row_phase != 1u) return E0_OK;', 'if (o->active == 0u || o->state != 0) return E0_OK;'),
        'click: phase 0 acts': ('if (o->active == 0u || o->state != 0 || row_phase != 1u) return E0_OK;', 'if (o->active == 0u || o->state != 0 || row_phase > 1u) return E0_OK;'),
        'click: phase 2 acts': ('if (o->active == 0u || o->state != 0 || row_phase != 1u) return E0_OK;', 'if (o->active == 0u || o->state != 0 || row_phase < 1u) return E0_OK;'),
        'click: new phase not passed through': ('*new_phase = row_phase;\n    if (o->active', '*new_phase = 1u;\n    if (o->active'),
        'click: hover 100 accepted': ('(o->hover < 0 || o->hover >= E0_MAX_KEYS)', '(o->hover < 0 || o->hover > E0_MAX_KEYS)'),
        'click: hover 99 refused': ('(o->hover < 0 || o->hover >= E0_MAX_KEYS)', '(o->hover < 0 || o->hover >= E0_MAX_KEYS - 1)'),
        'click: negative hover accepted': ('(o->hover < 0 || o->hover >= E0_MAX_KEYS)', '(o->hover < -1 || o->hover >= E0_MAX_KEYS)'),
        'click: hover 0 refused': ('(o->hover < 0 || o->hover >= E0_MAX_KEYS)', '(o->hover <= 0 || o->hover >= E0_MAX_KEYS)'),
        'click: bounds check for any candidate': ('if (o->hover != E0_EXIT_KEY && candidate == E0_CANDIDATE_KEY && (o->hover < 0', 'if (o->hover != E0_EXIT_KEY && (o->hover < 0'),
        'click: key block for any candidate': ('if (o->hover != E0_EXIT_KEY && candidate == E0_CANDIDATE_KEY) {\n        const int16_t hv', 'if (o->hover != E0_EXIT_KEY) {\n        const int16_t hv'),
        'click: key block for the exit key': ('if (o->hover != E0_EXIT_KEY && candidate == E0_CANDIDATE_KEY) {\n        const int16_t hv', 'if (candidate == E0_CANDIDATE_KEY) {\n        const int16_t hv'),
        'click: key block for the other candidate': ('if (o->hover != E0_EXIT_KEY && candidate == E0_CANDIDATE_KEY) {\n        const int16_t hv', 'if (o->hover != E0_EXIT_KEY && candidate == E0_CANDIDATE_EXIT) {\n        const int16_t hv'),
        'click: un-light needs ordered mode': ('if (o->lit[hv] != 0u && b[B_ORDERED] != 0u) {', 'if (o->lit[hv] != 0u) {'),
        'click: un-light without the lit test': ('if (o->lit[hv] != 0u && b[B_ORDERED] != 0u) {', 'if (b[B_ORDERED] != 0u) {'),
        'click: key left lit': ('o->lit[hv] = 0u;\n            t = (int16_t)(o->typed - 1);', 't = (int16_t)(o->typed - 1);'),
        'click: pop tests the wrong entry': ('t = (int16_t)(o->typed - 1);', 't = o->typed;'),
        'click: pop index not clamped': ('if (t < 0) t = 0;', '(void)0;'),
        'click: pop of any entry': ('if (o->player[t] == o->hover) {', 'if (1) {'),
        'click: pop of another entry': ('if (o->player[t] == o->hover) {', 'if (o->player[t] != o->hover) {'),
        'click: count kept on pop': ('o->typed = (int16_t)(o->typed - 1);\n                if (o->typed < 0)', 'if (o->typed < 0)'),
        'click: count not clamped on pop': ('if (o->typed < 0) o->typed = 0;', '(void)0;'),
        'click: popped entry kept': ('o->player[o->typed] = -1;\n            }', '(void)0;\n            }'),
        'click: popped entry cleared elsewhere': ('o->player[o->typed] = -1;\n            }', 'o->player[o->typed + 1] = -1;\n            }'),
        'click: ordered append stores one early': ('if (o->typed <= n - 1) o->player[o->typed] = o->hover;', 'if (o->typed < n - 1) o->player[o->typed] = o->hover;'),
        'click: ordered append stores past the end': ('if (o->typed <= n - 1) o->player[o->typed] = o->hover;', 'if (o->typed <= n) o->player[o->typed] = o->hover;'),
        'click: ordered append never stores': ('if (o->typed <= n - 1) o->player[o->typed] = o->hover;', '(void)0;'),
        'click: ordered append stores the count': ('o->player[o->typed] = o->hover;\n            if (o->lit[hv] == 0u) {', 'o->player[o->typed] = o->typed;\n            if (o->lit[hv] == 0u) {'),
        'click: ordered count step': ('o->typed = (int16_t)(o->typed + 1);\n                o->lit[hv] = 1u;\n            }\n            if (o->typed > n)', 'o->typed = (int16_t)(o->typed + 2);\n                o->lit[hv] = 1u;\n            }\n            if (o->typed > n)'),
        'click: ordered key not lit': ('o->typed = (int16_t)(o->typed + 1);\n                o->lit[hv] = 1u;\n            }\n            if (o->typed > n)', 'o->typed = (int16_t)(o->typed + 1);\n            }\n            if (o->typed > n)'),
        'click: ordered count not clamped': ('if (o->typed > n) o->typed = n;', '(void)0;'),
        'click: ordered count clamped late': ('if (o->typed > n) o->typed = n;', 'if (o->typed > n + 1) o->typed = n;'),
        'click: ordered count clamped to zero': ('if (o->typed > n) o->typed = n;', 'if (o->typed > n) o->typed = 0;'),
        'click: unordered lit key acts': ('} else if (o->lit[hv] == 0u) {\n            o->typed', '} else if (1) {\n            o->typed'),
        'click: unordered key counts twice': ('} else if (o->lit[hv] == 0u) {\n            o->typed = (int16_t)(o->typed + 1);', '} else if (o->lit[hv] == 0u) {\n            o->typed = (int16_t)(o->typed + 2);'),
        'click: unordered count clamped without code': ('if (o->code_len > 0 && o->typed > o->code_len) o->typed = o->code_len;', 'if (o->typed > o->code_len) o->typed = o->code_len;'),
        'click: unordered count not clamped': ('if (o->code_len > 0 && o->typed > o->code_len) o->typed = o->code_len;', '(void)0;'),
        'click: unordered count clamped late': ('if (o->code_len > 0 && o->typed > o->code_len) o->typed = o->code_len;', 'if (o->code_len > 0 && o->typed > o->code_len + 1) o->typed = o->code_len;'),
        'click: unordered key not lit': ('o->lit[hv] = 1u;\n            o->wait_deadline', 'o->wait_deadline'),
        'click: unordered wait period': ('o->wait_deadline = do_tick(h) + 0x12cu;\n            o->waiting = 1u;', 'o->wait_deadline = do_tick(h) + 0x12du;\n            o->waiting = 1u;'),
        'click: unordered wait subtracts': ('o->wait_deadline = do_tick(h) + 0x12cu;\n            o->waiting = 1u;', 'o->wait_deadline = do_tick(h) - 0x12cu;\n            o->waiting = 1u;'),
        'click: unordered wait not armed': ('o->wait_deadline = do_tick(h) + 0x12cu;\n            o->waiting = 1u;', 'do_tick(h);\n            o->waiting = 1u;'),
        'click: unordered waiting not set': ('o->waiting = 1u;\n            for (int16_t i = 0; i < o->code_len - 1; ++i)', 'for (int16_t i = 0; i < o->code_len - 1; ++i)'),
        'click: window shift too short': ('for (int16_t i = 0; i < o->code_len - 1; ++i) o->player[i] = o->player[i + 1];', 'for (int16_t i = 0; i < o->code_len - 2; ++i) o->player[i] = o->player[i + 1];'),
        'click: window shift backwards': ('o->player[i] = o->player[i + 1];', 'o->player[i + 1] = o->player[i];'),
        'click: window newest entry lost': ('o->player[o->code_len - 1] = o->hover;', '(void)0;'),
        'click: window newest entry first': ('o->player[o->code_len - 1] = o->hover;', 'o->player[0] = o->hover;'),
        'click: empty code pad kept': ('o->pad_d48 = o->hover;', '(void)0;'),
        'click: empty code writes the window': ('if (o->code_len == 0)\n                o->pad_d48 = o->hover;', 'if (o->code_len == 1)\n                o->pad_d48 = o->hover;'),
        'click: record gate': ('if (o->set_count > 0 && o->recorded <= n - 1) {', 'if (o->set_count >= 0 && o->recorded <= n - 1) {'),
        'click: record gate never': ('if (o->set_count > 0 && o->recorded <= n - 1) {', 'if (o->set_count > 1 && o->recorded <= n - 1) {'),
        'click: record one too early': ('if (o->set_count > 0 && o->recorded <= n - 1) {', 'if (o->set_count > 0 && o->recorded < n - 1) {'),
        'click: record past the end': ('if (o->set_count > 0 && o->recorded <= n - 1) {', 'if (o->set_count > 0 && o->recorded <= n) {'),
        'click: record stores the count': ('o->record[o->recorded] = o->hover;', 'o->record[o->recorded] = o->recorded;'),
        'click: record count kept': ('o->recorded = (int16_t)(o->recorded + 1);\n        }', '(void)0;\n        }'),
        'click: record count step': ('o->recorded = (int16_t)(o->recorded + 1);\n        }', 'o->recorded = (int16_t)(o->recorded + 2);\n        }'),
        'click: key sound ignores the start flag': ('o->recorded = (int16_t)(o->recorded + 1);\n        }\n        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {', 'o->recorded = (int16_t)(o->recorded + 1);\n        }\n        if (!no_sound(b + B_SOUND_A)) {'),
        'click: key sound with the start flag cleared': ('o->recorded = (int16_t)(o->recorded + 1);\n        }\n        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {', 'o->recorded = (int16_t)(o->recorded + 1);\n        }\n        if (start_flag == 0 && !no_sound(b + B_SOUND_A)) {'),
        'click: key sound ignores the record': ('o->recorded = (int16_t)(o->recorded + 1);\n        }\n        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {', 'o->recorded = (int16_t)(o->recorded + 1);\n        }\n        if (start_flag != 0) {'),
        'click: key sound inverted': ('o->recorded = (int16_t)(o->recorded + 1);\n        }\n        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {', 'o->recorded = (int16_t)(o->recorded + 1);\n        }\n        if (start_flag != 0 && no_sound(b + B_SOUND_A)) {'),
        'click: key sound channel': ('o->recorded = (int16_t)(o->recorded + 1);\n        }\n        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {\n            HOST(h->sound_play(h->context, rd_s16(b, B_CLICK_CHANNEL)));', 'o->recorded = (int16_t)(o->recorded + 1);\n        }\n        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {\n            HOST(h->sound_play(h->context, rd_s16(b, B_WIN_CHANNEL)));'),
        'click: exit button needs the flag': ('if (b[B_HAS_EXIT] != 0u && o->hover == E0_EXIT_KEY) {', 'if (o->hover == E0_EXIT_KEY) {'),
        'click: exit button without the hover': ('if (b[B_HAS_EXIT] != 0u && o->hover == E0_EXIT_KEY) {', 'if (b[B_HAS_EXIT] != 0u) {'),
        'click: exit button press lost': ('o->exit_pending = 1u;\n        o->wait_deadline', 'o->wait_deadline'),
        'click: exit button wait period': ('o->exit_pending = 1u;\n        o->wait_deadline = do_tick(h) + 0x12cu;', 'o->exit_pending = 1u;\n        o->wait_deadline = do_tick(h) + 0x12bu;'),
        'click: exit button wait not armed': ('o->exit_pending = 1u;\n        o->wait_deadline = do_tick(h) + 0x12cu;', 'o->exit_pending = 1u;\n        do_tick(h);'),
        'click: exit button waits': ('o->exit_pending = 1u;\n        o->wait_deadline = do_tick(h) + 0x12cu;', 'o->exit_pending = 1u;\n        o->waiting = 1u;\n        o->wait_deadline = do_tick(h) + 0x12cu;'),
        'click: exit sound ignores the start flag': ('o->wait_deadline = do_tick(h) + 0x12cu;\n        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {', 'o->wait_deadline = do_tick(h) + 0x12cu;\n        if (!no_sound(b + B_SOUND_A)) {'),
        'click: exit sound ignores the record': ('o->wait_deadline = do_tick(h) + 0x12cu;\n        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {', 'o->wait_deadline = do_tick(h) + 0x12cu;\n        if (start_flag != 0) {'),
        'click: exit sound inverted': ('o->wait_deadline = do_tick(h) + 0x12cu;\n        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {', 'o->wait_deadline = do_tick(h) + 0x12cu;\n        if (start_flag != 0 && no_sound(b + B_SOUND_A)) {'),
        'click: exit sound channel': ('        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {\n            HOST(h->sound_play(h->context, rd_s16(b, B_CLICK_CHANNEL)));\n            fx(h, E0_FX_SOUND_PLAY, rd_s16(b, B_CLICK_CHANNEL), 0);\n        }\n    }\n    if (candidate', '        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {\n            HOST(h->sound_play(h->context, rd_s16(b, B_WIN_CHANNEL)));\n            fx(h, E0_FX_SOUND_PLAY, rd_s16(b, B_CLICK_CHANNEL), 0);\n        }\n    }\n    if (candidate'),
        'click: exit rectangle candidate': ('if (candidate == E0_CANDIDATE_EXIT) {', 'if (candidate == E0_CANDIDATE_KEY) {'),
        'click: exit rectangle request lost': ('o->exit_asked = 1u;\n        *new_phase = 2u;', '*new_phase = 2u;'),
        'click: exit rectangle phase lost': ('o->exit_asked = 1u;\n        *new_phase = 2u;', 'o->exit_asked = 1u;'),
        'click: exit rectangle phase 1': ('*new_phase = 2u;\n        fx(h, E0_FX_PHASE, 2, 0);', '*new_phase = 1u;\n        fx(h, E0_FX_PHASE, 2, 0);'),
        'click: exit rectangle effect lost': ('*new_phase = 2u;\n        fx(h, E0_FX_PHASE, 2, 0);', '*new_phase = 2u;'),
        # --- render plan -------------------------------------------------------------------------------------------
        'render: hidden tiles drawn': ('if (o->tiles_visible == 0u) return E0_OK;', '(void)0;'),
        'render: origin failure ignored': ('HOST(host->view_origin(host->context, &vx, &vy));', 'if (host->view_origin(host->context, &vx, &vy) != 0) { vx = 0; vy = 0; }'),
        'render: invalid plan': ('plan->valid = 1u;', 'plan->valid = 0u;'),
        'render: surface lost': ('plan->surface = o->surface;', '(void)0;'),
        'render: count capped': ('if (i >= E0_MAX_KEYS) return E0_ERR_BOUNDS;', '(void)0;'),
        'render: lit key inverted': ('if (o->lit[i] != 0u)\n            rc = add_blit', 'if (o->lit[i] == 0u)\n            rc = add_blit'),
        'render: lit key kind': ('add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_KEY_DOWN, o->rect_a[i], vx, vy, o->rect_b[i]);', 'add_blit(plan, E0_BLIT_BG_KEYED, E0_ROLE_KEY_DOWN, o->rect_a[i], vx, vy, o->rect_b[i]);'),
        'render: lit key role': ('add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_KEY_DOWN, o->rect_a[i], vx, vy, o->rect_b[i]);', 'add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_KEY_UP, o->rect_a[i], vx, vy, o->rect_b[i]);'),
        'render: lit key source': ('E0_ROLE_KEY_DOWN, o->rect_a[i], vx, vy, o->rect_b[i]);', 'E0_ROLE_KEY_DOWN, o->rect_b[i], vx, vy, o->rect_b[i]);'),
        'render: lit key destination': ('E0_ROLE_KEY_DOWN, o->rect_a[i], vx, vy, o->rect_b[i]);', 'E0_ROLE_KEY_DOWN, o->rect_a[i], vx, vy, o->rect_a[i]);'),
        'render: unlit key kind': ('add_blit(plan, E0_BLIT_BG_OPAQUE, E0_ROLE_KEY_UP, o->rect_b[i], vx, vy, o->rect_b[i]);', 'add_blit(plan, E0_BLIT_BG_KEYED, E0_ROLE_KEY_UP, o->rect_b[i], vx, vy, o->rect_b[i]);'),
        'render: unlit key source': ('E0_ROLE_KEY_UP, o->rect_b[i], vx, vy, o->rect_b[i]);', 'E0_ROLE_KEY_UP, o->rect_a[i], vx, vy, o->rect_b[i]);'),
        'render: lights for both flags': ('if (o->flag == 0u) {\n        for (int16_t i = 0; i < o->round; ++i) {', 'if (1) {\n        for (int16_t i = 0; i < o->round; ++i) {'),
        'render: lights for neither flag': ('if (o->flag == 0u) {\n        for (int16_t i = 0; i < o->round; ++i) {', 'if (o->flag != 0u) {\n        for (int16_t i = 0; i < o->round; ++i) {'),
        'render: one light too many': ('for (int16_t i = 0; i < o->round; ++i) {\n            const size_t d', 'for (int16_t i = 0; i <= o->round; ++i) {\n            const size_t d'),
        'render: one light too few': ('for (int16_t i = 0; i < o->round; ++i) {\n            const size_t d', 'for (int16_t i = 0; i < o->round - 1; ++i) {\n            const size_t d'),
        'render: light destination stride': ('const size_t d = B_LIGHT_DST + (size_t)i * 16u;', 'const size_t d = B_LIGHT_DST + (size_t)i * 8u;'),
        'render: light source stride': ('rd_rect(b, B_LIGHT_SRC + (size_t)i * 16u, src);', 'rd_rect(b, B_LIGHT_SRC + (size_t)i * 8u, src);'),
        'render: light skipped for negative height': ('if (dst[3] - dst[1] != 0) {\n                rd_rect(b, B_LIGHT_SRC', 'if (dst[3] - dst[1] > 0) {\n                rd_rect(b, B_LIGHT_SRC'),
        'render: light drawn at zero height': ('if (dst[3] - dst[1] != 0) {\n                rd_rect(b, B_LIGHT_SRC', 'if (1) {\n                rd_rect(b, B_LIGHT_SRC'),
        'render: light kind': ('add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_ROUND_LIGHT, src, vx, vy, dst);', 'add_blit(plan, E0_BLIT_BG_KEYED, E0_ROLE_ROUND_LIGHT, src, vx, vy, dst);'),
        'render: light from the destination': ('rd_rect(b, B_LIGHT_SRC + (size_t)i * 16u, src);\n                rc = add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_ROUND_LIGHT, src, vx, vy, dst);', 'rd_rect(b, B_LIGHT_SRC + (size_t)i * 16u, src);\n                rc = add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_ROUND_LIGHT, dst, vx, vy, dst);'),
        'render: active light for round 0': ('if (o->round > 0) {\n            const size_t last', 'if (o->round >= 0) {\n            const size_t last'),
        'render: active light of the wrong round': ('const size_t last = (size_t)(o->round - 1);', 'const size_t last = (size_t)(o->round - 2);'),
        'render: active destination stride': ('const size_t d = B_ACTIVE_DST + last * 16u;', 'const size_t d = B_ACTIVE_DST + last * 8u;'),
        'render: active source stride': ('rd_rect(b, B_ACTIVE_SRC + last * 16u, src);', 'rd_rect(b, B_ACTIVE_SRC + last * 8u, src);'),
        'render: active light zero height drawn': ('rd_rect(b, d, dst);\n            if (dst[3] - dst[1] != 0) {\n                int rc;', 'rd_rect(b, d, dst);\n            if (1) {\n                int rc;'),
        'render: active light blink inverted': ('if (o->blink != 0u) {\n                    rc = add_blit', 'if (o->blink == 0u) {\n                    rc = add_blit'),
        'render: active erase kind': ('add_blit(plan, E0_BLIT_BG_KEYED, E0_ROLE_ACTIVE_ERASE, dst, vx, vy, dst);', 'add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_ACTIVE_ERASE, dst, vx, vy, dst);'),
        'render: active erase source': ('E0_ROLE_ACTIVE_ERASE, dst, vx, vy, dst);', 'E0_ROLE_ACTIVE_ERASE, src, vx, vy, dst);'),
        'render: active light kind': ('add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_ACTIVE_LIGHT, src, vx, vy, dst);', 'add_blit(plan, E0_BLIT_BG_KEYED, E0_ROLE_ACTIVE_LIGHT, src, vx, vy, dst);'),
        'render: exit button pressed inverted': ('if (o->exit_pending != 0u) {\n            rd_rect(b, B_EXIT_SRC, src);', 'if (o->exit_pending == 0u) {\n            rd_rect(b, B_EXIT_SRC, src);'),
        'render: pressed source': ('rd_rect(b, B_EXIT_SRC, src);', 'rd_rect(b, B_EXIT_RECT, src);'),
        'render: pressed kind': ('add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_EXIT_DOWN, src, vx, vy, dst);', 'add_blit(plan, E0_BLIT_BG_KEYED, E0_ROLE_EXIT_DOWN, src, vx, vy, dst);'),
        'render: pressed button does not wait': ('o->waiting = 1u;\n        } else {', '(void)0;\n        } else {'),
        'render: released button waits': ('rc = add_blit(plan, E0_BLIT_BG_KEYED, E0_ROLE_EXIT_UP, dst, vx, vy, dst);', 'rc = add_blit(plan, E0_BLIT_BG_KEYED, E0_ROLE_EXIT_UP, dst, vx, vy, dst);\n            o->waiting = 1u;'),
        'render: released kind': ('add_blit(plan, E0_BLIT_BG_KEYED, E0_ROLE_EXIT_UP, dst, vx, vy, dst);', 'add_blit(plan, E0_BLIT_BG_OPAQUE, E0_ROLE_EXIT_UP, dst, vx, vy, dst);'),
        'render: exit drawn only with the flag': ('    {\n        int rc;\n        rd_rect(b, B_EXIT_RECT, dst);', '    if (b[B_HAS_EXIT] != 0u) {\n        int rc;\n        rd_rect(b, B_EXIT_RECT, dst);'),
        'render: blit limit one late': ('if (plan->count >= E0_MAX_BLITS) return E0_ERR_BOUNDS;', 'if (plan->count > E0_MAX_BLITS) return E0_ERR_BOUNDS;'),
        'render: blit limit one early': ('if (plan->count >= E0_MAX_BLITS) return E0_ERR_BOUNDS;', 'if (plan->count >= E0_MAX_BLITS - 1) return E0_ERR_BOUNDS;'),
        'render: x origin dropped': ('bl->dst[0] = (int32_t)((uint32_t)dst_raw[0] + (uint32_t)vx);', 'bl->dst[0] = dst_raw[0];'),
        'render: y origin dropped': ('bl->dst[1] = (int32_t)((uint32_t)dst_raw[1] + (uint32_t)vy);', 'bl->dst[1] = dst_raw[1];'),
        'render: right origin wrong': ('bl->dst[2] = (int32_t)((uint32_t)dst_raw[2] + (uint32_t)vx);', 'bl->dst[2] = (int32_t)((uint32_t)dst_raw[2] + (uint32_t)vy);'),
        'render: bottom origin wrong': ('bl->dst[3] = (int32_t)((uint32_t)dst_raw[3] + (uint32_t)vy);', 'bl->dst[3] = (int32_t)((uint32_t)dst_raw[3] + (uint32_t)vx);'),
        'render: source origin applied': ('for (int k = 0; k < 4; ++k) bl->src[k] = src[k];', 'for (int k = 0; k < 4; ++k) bl->src[k] = src[k] + vx;'),
        'render: active bounds': ('if (d + 16u > E0_BODY_CAPACITY || B_ACTIVE_SRC + last * 16u + 16u > E0_BODY_CAPACITY)', 'if (d + 16u > E0_BODY_CAPACITY + 32u || B_ACTIVE_SRC + last * 16u + 16u > E0_BODY_CAPACITY + 32u)'),
        # --- image -------------------------------------------------------------------------------------------------
        'pack: key rectangle offset': ('put32(image, mask, 0x1cu + (size_t)i * 16u', 'put32(image, mask, 0x20u + (size_t)i * 16u'),
        'pack: hit rectangle offset': ('put32(image, mask, 0x65cu + (size_t)i * 16u', 'put32(image, mask, 0x660u + (size_t)i * 16u'),
        'pack: lit offset': ('put8(image, mask, 0xc9cu + (size_t)i, o->lit[i]);', 'put8(image, mask, 0xc9du + (size_t)i, o->lit[i]);'),
        'pack: code length width': ('put16(image, mask, 0xd01, (uint16_t)o->code_len);', 'put8(image, mask, 0xd01, (uint8_t)o->code_len);'),
        'pack: state width': ('put32(image, mask, 0xd2c, (uint32_t)o->state);', 'put16(image, mask, 0xd2c, (uint16_t)o->state);'),
        'pack: typed offset': ('put16(image, mask, 0xd32, (uint16_t)o->typed);', 'put16(image, mask, 0xd30, (uint16_t)o->typed);'),
        'pack: scratch offset': ('put16(image, mask, 0xd86u + (size_t)i * 2u, (uint16_t)o->scratch[i]);', 'put16(image, mask, 0xd88u + (size_t)i * 2u, (uint16_t)o->scratch[i]);'),
        'pack: record offset': ('put16(image, mask, 0xdc2u + (size_t)i * 2u, (uint16_t)o->record[i]);', 'put16(image, mask, 0xdc4u + (size_t)i * 2u, (uint16_t)o->record[i]);'),
        'pack: deadline offsets': ('put32(image, mask, 0xd40, o->blink_deadline);\n    put32(image, mask, 0xd44, o->show_deadline);', 'put32(image, mask, 0xd44, o->blink_deadline);\n    put32(image, mask, 0xd40, o->show_deadline);'),
        'pack: scene offset': ('put16(image, mask, 0xe08, (uint16_t)o->scene);', 'put16(image, mask, 0xe06, (uint16_t)o->scene);'),
        'pack: image not cleared': ('memset(image, 0, E0_IMAGE_BYTES);\n    memset(mask, 0, E0_IMAGE_BYTES);', 'memset(mask, 0, E0_IMAGE_BYTES);'),
        'pack: mask not cleared': ('memset(image, 0, E0_IMAGE_BYTES);\n    memset(mask, 0, E0_IMAGE_BYTES);', 'memset(image, 0, E0_IMAGE_BYTES);'),
        'pack: mask not set': ('image[off] = v;\n    mask[off] = 1u;', 'image[off] = v;'),
        'pack: pad word lost': ('put16(image, mask, 0xd48, (uint16_t)o->pad_d48);', '(void)0;'),
        'pack: solved sets offset': ('put8(image, mask, 0xdff, o->solved_sets);', 'put8(image, mask, 0xdfe, o->solved_sets);'),
    },
    BINDING: {
        'binding: row copy skipped': ('memcpy(rows[i].body, info.typed_body, info.typed_body_length);', '(void)0;'),
        'binding: row length lost': ('rows[i].length = info.typed_body_length;', 'rows[i].length = E0_BODY_BYTES_D6;'),
        'binding: row flag always 0xd6': ('flag = info.type == SESSION_AE0_TYPE_E0 ? 1 : 0;', 'flag = 0;'),
        'binding: row flag always 0xe0': ('flag = info.type == SESSION_AE0_TYPE_E0 ? 1 : 0;', 'flag = 1;'),
        'binding: row flag not stored': ('rows[i].flag = (uint8_t)flag;', '(void)0;'),
        'binding: row not marked present': ('rows[i].present = 1u;', '(void)0;'),
        'binding: rows of other types copied': ('if (info.type != SESSION_AE0_TYPE_D6 && info.type != SESSION_AE0_TYPE_E0) continue;', '(void)0;'),
        'binding: 0xe0 rows skipped': ('if (info.type != SESSION_AE0_TYPE_D6 && info.type != SESSION_AE0_TYPE_E0) continue;', 'if (info.type != SESSION_AE0_TYPE_D6) continue;'),
        'binding: 0xd6 rows skipped': ('if (info.type != SESSION_AE0_TYPE_D6 && info.type != SESSION_AE0_TYPE_E0) continue;', 'if (info.type != SESSION_AE0_TYPE_E0) continue;'),
        'binding: bad body accepted': ('if (e0_validate_body(flag, rows[i].body, rows[i].length, &why) != E0_OK) {', 'if (0) {'),
        'binding: bad body failure text lost': ('binding->failure = why;\n            return E0_ERR_BODY;', 'binding->failure = "none";\n            return E0_ERR_BODY;'),
        'binding: bad body result lost': ('binding->failure = why;\n            return E0_ERR_BODY;', 'binding->failure = why;\n            return E0_OK;'),
        'binding: previous scene not cleared': ('if (e0_cleanup(&binding->object, &binding->host.kernel) != E0_OK) {', 'if (0) {'),
        'binding: clear failure ignored': ('binding->failure = "keypad-scene-clear";\n        return E0_ERR_HOST;', 'binding->failure = "keypad-scene-clear";\n        return E0_OK;'),
        'binding: clear failure text': ('binding->failure = "keypad-scene-clear";', 'binding->failure = "none";'),
        'binding: round reset skipped': ('e0_scene_reset(&binding->object);', '(void)0;'),
        'binding: rows not replaced': ('binding->rows = rows;\n    binding->count = count;', 'binding->rows = rows;'),
        'binding: scene failure text kept': ('binding->failure = "none";\n    return E0_OK;\n}', 'return E0_OK;\n}'),
        'binding: destroy does not clear': ('(void)e0_cleanup(&binding->object, &binding->host.kernel);\n    free(binding->rows);', 'free(binding->rows);'),
        'binding: foreign row accepted': ('(action->type != SESSION_AE0_TYPE_D6 && action->type != SESSION_AE0_TYPE_E0) ||', '0 ||'),
        'binding: absent row accepted': ('binding->rows[index].present == 0u ||', '0 ||'),
        'binding: handler uses another row': ('row->body, row->length, row->flag, (int16_t)index,', 'row->body, row->length, row->flag, (int16_t)(index + 1),'),
        'binding: handler flag lost': ('row->body, row->length, row->flag, (int16_t)index,', 'row->body, row->length, 0, (int16_t)index,'),
        'binding: handler length lost': ('row->body, row->length, row->flag, (int16_t)index,', 'row->body, E0_BODY_BYTES_D6, row->flag, (int16_t)index,'),
        'binding: handler phase lost': ('(int16_t)index, before->phase, &binding->world,', '(int16_t)index, 0u, &binding->world,'),
        'binding: unsupported becomes an error': ('if (status == E0_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;', 'if (status == E0_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_ERROR;'),
        'binding: errors are accepted': ('if (status != E0_OK) return SCENE_ACTION_HANDLER_ERROR;', '(void)0;'),
        'binding: world stored only on init': ('(result.initialized != 0u || result.completed != 0u) &&', '(result.initialized != 0u) &&'),
        'binding: world stored only on completion': ('(result.initialized != 0u || result.completed != 0u) &&', '(result.completed != 0u) &&'),
        'binding: world stored on every visit': ('(result.initialized != 0u || result.completed != 0u) &&', '1 &&'),
        'binding: phase before kept': ('out->phase = result.phase_after;', 'out->phase = before->phase;'),
        'binding: completion left pending': ('result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_PENDING'),
        'binding: every visit completes': ('result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_COMPLETED'),
        'binding: failure text lost': ('binding->failure = why != NULL ? why : "none";', 'binding->failure = "none";'),
        'binding: scene cell not read': ('binding->world.scene_cell_5bb57b = binding->host.scene_cell(binding->host.kernel.context);', '(void)0;'),
        'binding: scene cell read in every phase': ('if (before->phase == 2u && binding->host.scene_cell != NULL)', 'if (binding->host.scene_cell != NULL)'),
        'binding: scene cell read without the callback': ('if (before->phase == 2u && binding->host.scene_cell != NULL)', 'if (before->phase == 2u)'),
        'binding: scene cell initial value': ('binding->world.scene_cell_5bb57b = E0_NO_SCENE;', 'binding->world.scene_cell_5bb57b = 0;'),
        'binding: pointer on an inactive puzzle': ('if (binding->object.active == 0u) {\n        binding->object.hover = -1;', 'if (0) {\n        binding->object.hover = -1;'),
        'binding: inactive pointer keeps the hover': ('binding->object.hover = -1; /* 0x470ffe stores hover := -1 and returns 0 */', '(void)0;'),
        'binding: pointer result not cleared': ('memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (binding->object.active', 'out->candidate = -1;\n    if (binding->object.active'),
        'binding: pointer candidate default': ('out->candidate = -1;\n    if (binding->object.active', 'out->candidate = 0;\n    if (binding->object.active'),
        'binding: click on an inactive puzzle': ('*new_phase = row_phase;\n    if (binding->object.active == 0u) return E0_OK;', '*new_phase = row_phase;'),
        'binding: click phase lost': ('*new_phase = row_phase;\n    if (binding->object.active == 0u) return E0_OK;', '*new_phase = 1u;\n    if (binding->object.active == 0u) return E0_OK;'),
        'binding: click failure text': ('binding->failure = status == E0_OK ? "none" : "keypad-click";', 'binding->failure = "none";'),
        'binding: click row phase wrong': ('row->body, row->length, row_phase, candidate, start_flag,', 'row->body, row->length, 1u, candidate, start_flag,'),
        'binding: click start flag dropped': ('row->body, row->length, row_phase, candidate, start_flag,', 'row->body, row->length, row_phase, candidate, 0,'),
        'binding: click candidate dropped': ('row->body, row->length, row_phase, candidate, start_flag,', 'row->body, row->length, row_phase, 0, start_flag,'),
        'binding: click uses another row': ('e0_click(&binding->object, row->body,', 'e0_click(&binding->object, binding->rows[0].body,'),
        'binding: plan drawn without a slot': ('binding->object.tiles_visible == 0u || binding->object.slot == E0_NO_SLOT', 'binding->object.tiles_visible == 0u'),
        'binding: plan drawn while hidden': ('binding->object.tiles_visible == 0u || binding->object.slot == E0_NO_SLOT', 'binding->object.slot == E0_NO_SLOT'),
        'binding: plan never drawn': ('binding->object.tiles_visible == 0u || binding->object.slot == E0_NO_SLOT', '1'),
        'binding: plan row missing': ('row = active_row(binding);\n    if (row == NULL) {\n        memset(plan, 0, sizeof(*plan));', 'row = active_row(binding);\n    if (0) {\n        memset(plan, 0, sizeof(*plan));'),
        'binding: registered inverted': ('binding->object.slot != E0_NO_SLOT ? 1u : 0u', 'binding->object.slot == E0_NO_SLOT ? 1u : 0u'),
        'binding: state of the wrong object': ('return binding == NULL ? NULL : &binding->object;', 'return NULL;'),
        'binding: unbound failure text': ('"keypad-binding-unbound"', '"none"'),
        'binding: active row index': ('if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;', 'if (row < 0 || (size_t)row >= binding->count) return NULL;'),
    },
}

# Mutants whose result no unit case can see, each with the reason. The test asserts that they survive, so a stale entry (one that
# a later test change kills) is reported and must be moved to MUTANTS.
EQUIVALENT = {
    KERNEL: {
        'validate: zero columns line removed': (
            'if (n > 0 && cols == 0) why = "keypad-zero-columns";', '(void)0;',
            'n is the 16 bit product cols * rows, so cols == 0 gives n == 0: the zero-columns reason is unreachable'),
        'validate: code records are checked inside the body for flag 1': (
            'if (why == NULL && flag == 0) {\n        int sets', 'if (why == NULL) {\n        int sets',
            'a flag 1 body has zero bytes beyond its 294 loaded ones (the padding check), so records 1..4 and the code sets read as valid'),
        'validate: record offset upper bound': (
            'return off + E0_ROUND_BYTES <= E0_BODY_CAPACITY && k >= 0', 'return k >= 0',
            'record_ok is only called with the five fixed record offsets, all inside the capacity'),
        'state 0: record index N write removed': (
            'o->record[n] = -1; /* index N, not m (original) */', '(void)0;',
            'the write only touches record[N], which no later search reads (they stop at N) and the loop end clears the whole record'),
        'typed: waiting is tested again': (
            'o->code_len > 0 && o->waiting == 0u && o->typed == o->code_len', 'o->code_len > 0 && o->typed == o->code_len',
            'typed_checks is only reached with waiting == 0: a still waiting visit returns from the waiting block first'),
        'click: ordered count clamp at N is not strict': (
            'if (o->typed > n) o->typed = n;', 'if (o->typed >= n) o->typed = n;',
            'typed == n assigns n to itself'),
        'click: unordered count clamp at the code length is not strict': (
            'if (o->code_len > 0 && o->typed > o->code_len) o->typed = o->code_len;', 'if (o->code_len > 0 && o->typed >= o->code_len) o->typed = o->code_len;',
            'typed == code_len assigns code_len to itself'),
        'click: window shift reads one entry further': (
            'for (int16_t i = 0; i < o->code_len - 1; ++i) o->player[i] = o->player[i + 1];', 'for (int16_t i = 0; i < o->code_len; ++i) o->player[i] = o->player[i + 1];',
            'the extra pass copies player[K] into player[K-1], which the next statement overwrites with the hover'),
        'render: light bound': (
            'if (d + 16u > E0_BODY_CAPACITY || B_LIGHT_SRC + (size_t)i * 16u + 16u > E0_BODY_CAPACITY)', 'if (0)',
            'the light bound is implied by the active light bound that follows for every round that reaches it (outputs are identical; only a sanitizer sees the read)'),
        'record: offset upper bound is not strict': (
            'if (off < 0 || (size_t)off + E0_ROUND_BYTES > E0_BODY_CAPACITY) return E0_ERR_BOUNDS;', 'if (off < 0 || (size_t)off + E0_ROUND_BYTES >= E0_BODY_CAPACITY) return E0_ERR_BOUNDS;',
            'record offsets are 0x24f + 33 k: none ends exactly at 1,733 bytes'),
        'state 0: record count kept after the sets': (
            '                for (int i = 0; i < E0_MAX_CODE; ++i) o->record[i] = -1;\n                o->recorded = 0;', '                for (int i = 0; i < E0_MAX_CODE; ++i) o->record[i] = -1;',
            'the same statement already ran when the exit press was consumed, a few lines earlier, and nothing in between writes recorded'),
        'phase 2: sets branch beats the exit': (
            'const int sets_branch = !exit_branch && o->solved_sets != 0u;', 'const int sets_branch = o->solved_sets != 0u;',
            'a phase 2 branch chain tests the exit request first, so the sets branch can only be reached with exit_asked == 0'),
        'cleanup: surface handle kept': (
            '    object->surface = 0u;\n    object->active = 0u;', '    object->active = 0u;',
            'the release block above already zeroes the handle whenever it is nonzero, and the final store only runs for a handle that is already zero'),
        'click: bounds check on the exit key': (
            'if (o->hover != E0_EXIT_KEY && candidate == E0_CANDIDATE_KEY && (o->hover < 0', 'if (candidate == E0_CANDIDATE_KEY && (o->hover < 0',
            'E0_EXIT_KEY is 0x28, inside 0..99, so the range test never fires for it (the key block is skipped for that hover by the next test)'),
        'click: ordered lit key counted': (
            'if (o->lit[hv] == 0u) {\n                o->typed = (int16_t)(o->typed + 1);\n                o->lit[hv] = 1u;', 'if (1) {\n                o->typed = (int16_t)(o->typed + 1);\n                o->lit[hv] = 1u;',
            'an ordered click on a lit key takes the un-light branch above; the append branch is only reached with lit == 0'),
    },
    BINDING: {
        'binding: row index above int16': (
            'index > (size_t)INT16_MAX', '0',
            'a scene holds at most 999 actions (HIFF chunk bound), so the index never exceeds int16'),
        'binding: body longer than the capacity': (
            'if (info.typed_body_length > E0_BODY_CAPACITY) {', 'if (0) {',
            'scene_resource only returns the fixed loader lengths 1,733 and 294'),
    },
}

# Mutants whose only visible effect is an out-of-bounds read (undefined behaviour with no deterministic output): the ASan run of
# the same cases must stop on them.
SANITIZER_ONLY = {
    BINDING: {
        'binding: row beyond the table accepted': ('index >= binding->count ||', '0 ||'),
    },
}


def mutated_object(cc, root, key, filename, old, new, base_objects):
    original = (SRC / filename).read_text()
    if original.count(old) != 1:
        raise AssertionError(f'mutation anchor drifted ({original.count(old)} matches): {old[:80]!r}')
    work = Path(root) / key
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir(parents=True)
    (work / filename).write_text(original.replace(old, new, 1))
    out = work / (filename + '.o')
    done = compile_obj(cc, work / filename, out, include_dir=SRC, optimize='-O0', werror=False)
    if done.returncode != 0:
        return None, done.stderr[-300:]
    objects = [out if name == filename else path for name, path in base_objects.items()]
    binary = work / 'mut_test'
    linked = link(cc, objects, binary)
    if linked.returncode != 0:
        return None, linked.stderr[-300:]
    return binary, ''


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.cc = compiler()
        assert cls.cc is not None, 'no C compiler'
        objects = build_objects(cls.cc, Path(cls.tmp.name) / 'plain', '-O1')
        cls.binary = Path(cls.tmp.name) / 'e0_test'
        linked = link(cls.cc, list(objects.values()), cls.binary)
        assert linked.returncode == 0, linked.stderr

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
        for cc in (self.cc, shutil.which('gcc'), shutil.which('clang')):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'e0_test_san'
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
        tables = list(MUTANTS.items()) + list(SANITIZER_ONLY.items()) + [(f, {n: (o, w) for n, (o, w, _r) in m.items()}) for f, m in EQUIVALENT.items()]
        for filename, mutations in tables:
            text = (SRC / filename).read_text()
            for name, (old, new) in mutations.items():
                with self.subTest(name):
                    self.assertEqual(text.count(old), 1, f'anchor of {name!r} matches {text.count(old)} times')
                    self.assertNotEqual(old, new, f'{name!r} does not change the source')

    def test_mutant_count(self):
        self.assertGreaterEqual(len(MUTANTS[KERNEL]), 80)
        self.assertGreaterEqual(len(MUTANTS[BINDING]), 10)
        names = [n for t in (MUTANTS, SANITIZER_ONLY, EQUIVALENT) for f in t for n in t[f]]
        self.assertEqual(len(names), len(set(names)), 'duplicate mutant names')

    def _base_objects(self):
        directory = Path(self.tmp.name) / 'base0'
        if not hasattr(type(self), '_base'):
            type(self)._base = build_objects(self.cc, directory, '-O0')
        return type(self)._base

    def _sweep(self, table, expected):
        base = self._base_objects()
        jobs = [(filename, name, old, new) for filename, mutations in table.items() for name, (old, new) in mutations.items()]

        def build_and_run(index_job):
            index, (filename, name, old, new) = index_job
            binary, error = mutated_object(self.cc, self.tmp.name, f'mut{expected}{index}', filename, old, new, base)
            if binary is None:
                return name, 'build', error
            code, _ = run_unit(binary, timeout=60)
            return name, 'killed' if code != 0 else 'survived', ''

        with concurrent.futures.ThreadPoolExecutor(max_workers=min(8, os.cpu_count() or 2)) as pool:
            outcomes = list(pool.map(build_and_run, enumerate(jobs)))
        for name, verdict, detail in outcomes:
            with self.subTest(name):
                self.assertEqual(verdict, expected, f'mutant {verdict}: {name} {detail}')

    def test_mutations_are_detected(self):
        """The cases must fail when a recovered rule is deliberately broken."""
        self._sweep(MUTANTS, 'killed')

    def test_out_of_bounds_mutants_are_stopped_by_the_sanitizer(self):
        """A row index beyond the table must be refused before the row is read; ASan sees the read the plain build cannot."""
        for filename, mutations in SANITIZER_ONLY.items():
            for name, (old, new) in mutations.items():
                original = (SRC / filename).read_text()
                self.assertEqual(original.count(old), 1, name)
                work = Path(self.tmp.name) / 'san_mutant'
                shutil.rmtree(work, ignore_errors=True)
                work.mkdir()
                (work / filename).write_text(original.replace(old, new, 1))
                sources = [str(work / filename) if s == filename else str(SRC / s) for s in SOURCES]
                out = work / 'san_test'
                cmd = [self.cc, '-std=c11', '-g', '-O0', '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined',
                       f'-I{SRC}', str(TEST_C), *sources, '-lm', '-o', str(out)]
                if subprocess.run(cmd, capture_output=True, text=True).returncode != 0:
                    self.skipTest('no ASan/UBSan runtime in this environment')
                done = subprocess.run([str(out)], capture_output=True, text=True, env=dict(os.environ, ASAN_OPTIONS='detect_leaks=0'))
                self.assertNotEqual(done.returncode, 0, f'sanitizer did not stop {name}')

    def test_equivalent_mutants_do_not_change_the_cases(self):
        """Behaviour-neutral rewrites (each with its reason in EQUIVALENT) must pass; a failure means the entry went stale."""
        table = {f: {n: (o, w) for n, (o, w, _r) in m.items()} for f, m in EQUIVALENT.items()}
        self._sweep(table, 'survived')


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_e0_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_build_script_names_the_sources(self):
        text = (PROJECT / 'scripts/build_action_family_e0_runtime.sh').read_text()
        for name in SOURCES:
            self.assertIn(name, text)
        for flag in ('-Wall', '-Wextra', '-Wpedantic', '-Werror', '-std=c11'):
            self.assertIn(flag, text)


class Registration(unittest.TestCase):
    def test_module_is_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        self.assertIn(' action_family_e0_runtime session_bindings_ae0', build)


if __name__ == '__main__':
    unittest.main()
