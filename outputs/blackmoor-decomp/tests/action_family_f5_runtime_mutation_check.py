#!/usr/bin/env python3
"""RT-55 mutation check for the raw-0xf5 oracle (Typing Quiz Puzzle runtime and the shared score / time display widget).

Every mutant is a one-site textual edit of a COPY of src/action_family_f5_runtime.c or src/score_time_display.c (the project files are
never touched). Each mutant is built into a driver library and run through the original-x86 oracle
(action_family_f5_runtime_original_oracle.py, `--src DIR`). A mutant is KILLED when the oracle reports at least one mismatch against the
unmodified GAME.EXE image (or one of its native-only refusal checks fails); it SURVIVES when the oracle still reports 0 mismatches; it is
INVALID if it does not compile or the edit site is not found the stated number of times (invalid mutants never count as killed).

Usage:  python3 action_family_f5_runtime_mutation_check.py [--stage quick|full] [--only NAME] [--jobs N] [--result FILE] [--check-sites]
Stage `quick` runs the oracle's --quick-only subset (plus the native refusal checks); survivors are re-run on the full scenario set
(--stage full runs every mutant on the full set). Mutants run in parallel, one oracle per mutant (--jobs, default 4).
Equivalent mutants (EQUIVALENT below, each with a reason read from the kernel and the original) are reported separately and are not
counted in the kill rate; a mutant listed there that is KILLED is reported as killed (the reason is then moot).
"""
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
ORACLE = HERE / 'action_family_f5_runtime_original_oracle.py'
KERNELS = {'f5': 'action_family_f5_runtime.c', 'std': 'score_time_display.c'}
HEADERS = ('action_family_f5_runtime.h', 'score_time_display.h')

# (name, file, class, old text, new text, expected occurrences of old text, index of the occurrence to edit)
M = []


def m(name, cls, old, new, count=1, which=0, f='f5'):
    M.append((name, f, cls, old, new, count, which))


def s(name, cls, old, new, count=1, which=0):
    m(name, cls, old, new, count, which, f='std')


# ---------------------------------------------------------------------------------------------------------------------------------
# helpers: no_sound, sounds, tick, rand
# ---------------------------------------------------------------------------------------------------------------------------------
m('nosound-8-bytes', 'compare', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8) == 0;')
m('nosound-case', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'n', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}")
m('nosound-last-char', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'E', 0}")
m('nosound-inverted', 'predicate', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k) != 0;')
m('sound-prepare-always', 'predicate', 'if (!no_sound(body + off)) {', 'if (1) {', 2, 0)
m('sound-stop-always', 'predicate', 'if (!no_sound(body + off)) {', 'if (1) {', 2, 1)
m('sound-prepare-never', 'predicate', 'if (!no_sound(body + off)) {', 'if (0) {', 2, 0)
m('sound-stop-never', 'predicate', 'if (!no_sound(body + off)) {', 'if (0) {', 2, 1)
m('sound-prepare-effect-offset', 'field', 'fx(host, TQZ_FX_SOUND_PREPARE, (int32_t)off, 0);', 'fx(host, TQZ_FX_SOUND_PREPARE, (int32_t)off + 1, 0);')
m('sound-stop-effect-offset', 'field', 'fx(host, TQZ_FX_SOUND_STOP, (int32_t)off, 0);', 'fx(host, TQZ_FX_SOUND_STOP, (int32_t)off + 1, 0);')
m('sound-prepare-effect-missing', 'missing-effect', 'fx(host, TQZ_FX_SOUND_PREPARE, (int32_t)off, 0);', ';')
m('sound-play-channel', 'field', 'fx(host, TQZ_FX_SOUND_PLAY, channel, 0);', 'fx(host, TQZ_FX_SOUND_PLAY, channel ^ 1, 0);')
m('sound-play-host-channel', 'field', 'HOST(host->sound_play(host->context, channel));', 'HOST(host->sound_play(host->context, (int16_t)(channel + 1)));')
m('sound-channel-width', 'sign', 'return rd_s16(body, off);', 'return (int16_t)(uint8_t)rd_s16(body, off);')
m('tick-effect-missing', 'missing-effect', 'fx(host, TQZ_FX_TICK, (int32_t)*out, 0);', ';')
m('rand-effect-missing', 'missing-effect', 'fx(host, TQZ_FX_RANDOM, v, 0);', ';')
m('rand-upper-bound', 'validate', 'if (v < 0 || v > 32767) return TQZ_ERR_HOST;', 'if (v < 0 || v > 32766) return TQZ_ERR_HOST;')
m('rand-lower-bound', 'validate', 'if (v < 0 || v > 32767) return TQZ_ERR_HOST;', 'if (v < -1 || v > 32767) return TQZ_ERR_HOST;')
# reset helpers
m('reset-slot', 'field', 'object->slot = TQZ_NO_SLOT;\n    object->row = -1;', 'object->slot = 0;\n    object->row = -1;')
m('reset-row', 'field', 'object->slot = TQZ_NO_SLOT;\n    object->row = -1;', 'object->slot = TQZ_NO_SLOT;\n    object->row = 0;')
m('reset-score-block-slot', 'field', 'object->score_block[44] = -1;\n    object->clock_block[48] = -1;\n}', 'object->clock_block[48] = -1;\n}')
m('reset-clock-block-slot', 'field', 'object->score_block[44] = -1;\n    object->clock_block[48] = -1;\n}', 'object->score_block[44] = -1;\n}')
m('new-game-played', 'missing-effect', 'world->played_5a4c0a = 0;', ';')
m('new-game-best', 'missing-effect', 'world->best_5a4c0e = 0;', ';')

# ---------------------------------------------------------------------------------------------------------------------------------
# key filter 0x437ea1
# ---------------------------------------------------------------------------------------------------------------------------------
m('filter-A', 'compare', "(u >= 'A' && u <= 'Z')", "(u > 'A' && u <= 'Z')")
m('filter-Z', 'compare', "(u >= 'A' && u <= 'Z')", "(u >= 'A' && u < 'Z')")
m('filter-a', 'compare', "(u >= 'a' && u <= 'z')", "(u > 'a' && u <= 'z')")
m('filter-z', 'compare', "(u >= 'a' && u <= 'z')", "(u >= 'a' && u < 'z')")
m('filter-0', 'compare', "(u >= '0' && u <= '9')", "(u > '0' && u <= '9')")
m('filter-9', 'compare', "(u >= '0' && u <= '9')", "(u >= '0' && u < '9')")
m('filter-punct-no-minus', 'compare', '"\\b\\r .,?!/$()&:;+%=-"', '"\\b\\r .,?!/$()&:;+%="')
m('filter-punct-no-backspace', 'compare', '"\\b\\r .,?!/$()&:;+%=-"', '"\\r .,?!/$()&:;+%=-"')
m('filter-punct-no-cr', 'compare', '"\\b\\r .,?!/$()&:;+%=-"', '"\\b .,?!/$()&:;+%=-"')
m('filter-punct-extra-tab', 'compare', '"\\b\\r .,?!/$()&:;+%=-"', '"\\b\\r\\t .,?!/$()&:;+%=-"')
m('filter-punct-nul', 'compare', 'i + 1 < sizeof punct', 'i < sizeof punct')
m('filter-punct-last-skipped', 'compare', 'i + 1 < sizeof punct', 'i + 2 < sizeof punct')
m('filter-extra-first', 'compare', 'static const uint8_t extra[] = {0xe0,', 'static const uint8_t extra[] = {0xe1,')
m('filter-extra-last', 'compare', '0xe1, 0xed, 0xf3, 0xfa, 0xdf};', '0xe1, 0xed, 0xf3, 0xfa, 0xde};')
m('filter-extra-dropped-last', 'compare', 'i < sizeof extra; ++i', 'i + 1 < sizeof extra; ++i')
m('filter-extra-middle', 'compare', '0xf6, 0xdc, 0xfc, 0xa1, 0xbf,', '0xf6, 0xdc, 0xfc, 0xa2, 0xbf,')
m('filter-extra-signed', 'sign', 'const uint8_t u = (uint8_t)ch;', 'const uint8_t u = (uint8_t)(ch & 0x7f);')

# ---------------------------------------------------------------------------------------------------------------------------------
# body validation (checked by the native refusal checks)
# ---------------------------------------------------------------------------------------------------------------------------------
m('validate-length-lt', 'validate', 'body == NULL || length != TQZ_BODY_BYTES) {', 'body == NULL || length < TQZ_BODY_BYTES) {')
m('validate-name-short', 'validate', 'memchr(body, 0, TQZ_NAME_BYTES) == NULL', 'memchr(body, 0, TQZ_NAME_BYTES - 1) == NULL')
for letter in 'ABC':
    m('validate-sound-%s-skipped' % letter, 'validate', 'memchr(body + B_SOUND_%s, 0, TQZ_SOUND_BYTES) == NULL ||' % letter, '0 ||')
m('validate-sound-D-skipped', 'validate', 'memchr(body + B_SOUND_D, 0, TQZ_SOUND_BYTES) == NULL) {', '0) {')
m('validate-sound-short', 'validate', 'memchr(body + B_SOUND_A, 0, TQZ_SOUND_BYTES) == NULL', 'memchr(body + B_SOUND_A, 0, TQZ_SOUND_BYTES - 1) == NULL')
m('validate-variants-low', 'validate', 'rd_s16(body, B_VARIANTS) < 1', 'rd_s16(body, B_VARIANTS) < 0')
m('validate-variants-high', 'validate', 'rd_s16(body, B_VARIANTS) > TQZ_BALLOONS', 'rd_s16(body, B_VARIANTS) >= TQZ_BALLOONS')
m('validate-positions-low', 'validate', 'rd_s16(body, B_POSITIONS) < 1', 'rd_s16(body, B_POSITIONS) < 0')
m('validate-positions-high', 'validate', 'rd_s16(body, B_POSITIONS) > TQZ_BALLOONS', 'rd_s16(body, B_POSITIONS) >= TQZ_BALLOONS')
m('validate-count-min-low', 'validate', 'rd_s16(body, B_COUNT_MIN) < 0', 'rd_s16(body, B_COUNT_MIN) < -1')
m('validate-count-max-high', 'validate', 'rd_s16(body, B_COUNT_MAX) > TQZ_BALLOONS', 'rd_s16(body, B_COUNT_MAX) >= TQZ_BALLOONS')
m('validate-count-order', 'validate', 'rd_s16(body, B_COUNT_MIN) > rd_s16(body, B_COUNT_MAX)', 'rd_s16(body, B_COUNT_MIN) >= rd_s16(body, B_COUNT_MAX)')
m('validate-life-order', 'validate', 'rd_s16(body, B_LIFE_MIN) > rd_s16(body, B_LIFE_MAX)', 'rd_s16(body, B_LIFE_MIN) >= rd_s16(body, B_LIFE_MAX)')
m('validate-life-skipped', 'validate', 'rd_s16(body, B_LIFE_MIN) > rd_s16(body, B_LIFE_MAX)', '0')
m('validate-count-skipped', 'validate', 'rd_s16(body, B_COUNT_MIN) < 0 || rd_s16(body, B_COUNT_MAX) > TQZ_BALLOONS ||', '0 ||')

# ---------------------------------------------------------------------------------------------------------------------------------
# characters, positions, balloons
# ---------------------------------------------------------------------------------------------------------------------------------
m('char-upper-low', 'compare', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch > 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;')
m('char-upper-high', 'compare', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x41 && ch < 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;')
m('char-lower-low', 'compare', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch > 0x61 && ch <= 0x7a)) return 1;')
m('char-lower-high', 'compare', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch < 0x7a)) return 1;')
m('char-bracket-allowed', 'compare', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x41 && ch <= 0x7a)) return 1;')
m('char-digits-gate', 'predicate', 'if (body[B_DIGITS] != 0 && ch >= 0x30 && ch <= 0x39) return 1;', 'if (ch >= 0x30 && ch <= 0x39) return 1;')
m('char-digits-low', 'compare', 'ch >= 0x30 && ch <= 0x39) return 1;', 'ch > 0x30 && ch <= 0x39) return 1;')
m('char-digits-high', 'compare', 'ch >= 0x30 && ch <= 0x39) return 1;', 'ch >= 0x30 && ch < 0x39) return 1;')
m('char-extra-gate', 'predicate', 'if (body[B_EXTRA] != 0) {', 'if (body[B_EXTRA] == 0) {')
m('char-extra-gate-removed', 'predicate', 'if (body[B_EXTRA] != 0) {', 'if (1) {')
m('char-extra-count', 'index', 'for (int16_t i = 0; i < B_EXTRA_BYTES; ++i) {', 'for (int16_t i = 0; i < B_EXTRA_BYTES - 1; ++i) {')
m('char-extra-offset', 'index', 'if (ch == body[B_EXTRA + i]) return 1;', 'if (ch == body[B_EXTRA + i + 1]) return 1;')
m('pick-char-digits-test', 'predicate', 'if (body[B_DIGITS] == 0) {\n            span', 'if (body[B_DIGITS] != 0) {\n            span')
m('pick-char-letter-base-span', 'constant', 'span = sub32(o->max_char, 0x41);', 'span = sub32(o->max_char, 0x40);')
m('pick-char-letter-base', 'constant', 'ch = (uint8_t)add32(r % span, 0x41);', 'ch = (uint8_t)add32(r % span, 0x40);')
m('pick-char-digit-base-span', 'constant', 'span = sub32(o->max_char, 0x30);', 'span = sub32(o->max_char, 0x31);')
m('pick-char-digit-base', 'constant', 'ch = (uint8_t)add32(r % span, 0x30);', 'ch = (uint8_t)add32(r % span, 0x31);')
m('pick-char-reject-loop', 'predicate', 'if (char_allowed(body, ch)) {', 'if (1) {')
m('pick-position-occupied-state', 'predicate', 'if (b->state != 0 &&', 'if (b->state == TQZ_BALLOON_FLYING &&')
m('pick-position-y-view', 'field', 'sub32(b->dst[1], view_y) == rd_s32', 'sub32(b->dst[1], view_x) == rd_s32')
m('pick-position-x-view', 'field', 'sub32(b->dst[0], view_x) == rd_s32', 'sub32(b->dst[0], view_y) == rd_s32')
m('pick-position-y-field', 'index', 'rd_s32(body, B_POSITION_RECT + 4 + (size_t)c * 16u)', 'rd_s32(body, B_POSITION_RECT + 8 + (size_t)c * 16u)')
m('pick-position-x-test-dropped', 'predicate', '&&\n                sub32(b->dst[0], view_x) == rd_s32(body, B_POSITION_RECT + (size_t)c * 16u)) {', ') {')
m('pick-position-first', 'arith', 'c = (int16_t)(r % n);\n    for', 'c = (int16_t)(r % (n + 1));\n    for')
m('pick-position-retry', 'arith', 'CHECK(rnd(host, &r));\n        c = (int16_t)(r % n);', 'CHECK(rnd(host, &r));\n        c = (int16_t)(r % (n - 1 + (n == 1)));')
m('pick-position-scan-short', 'index', 'for (int16_t k = 0; k < n; ++k) {\n            const TqzBalloon', 'for (int16_t k = 0; k < n - 1; ++k) {\n            const TqzBalloon')
m('place-view-lookup', 'field', 'HOST(host->view_rects(host->context, view, local));\n    CHECK(pick_position', 'HOST(host->view_rects(host->context, local, view));\n    CHECK(pick_position')
m('place-dst-y-view', 'field', 'b->dst[1] = add32(b->dst[1], view[1]);', 'b->dst[1] = add32(b->dst[1], view[0]);')
m('place-dst-y2-view', 'field', 'b->dst[3] = add32(b->dst[3], view[1]);', 'b->dst[3] = add32(b->dst[3], view[0]);')
m('place-dst-x-view', 'field', 'b->dst[0] = add32(b->dst[0], view[0]);', 'b->dst[0] = add32(b->dst[0], view[1]);')
m('place-dst-x2-view', 'field', 'b->dst[2] = add32(b->dst[2], view[0]);', 'b->dst[2] = add32(b->dst[2], view[1]);')
m('place-text-y-bias', 'constant', 'sub32(b->dst[3], b->dst[1]) / 2), 6);', 'sub32(b->dst[3], b->dst[1]) / 2), 5);')
m('place-text-y-half', 'arith', 'sub32(b->dst[3], b->dst[1]) / 2), 6);', 'sub32(b->dst[3], b->dst[1]) / 3), 6);')
m('place-text-y-base', 'field', 'b->text_y = add32(sub32(b->dst[3], sub32', 'b->text_y = add32(sub32(b->dst[1], sub32')
m('place-text-x-bias', 'constant', 'sub32(b->dst[2], b->dst[0]) / 2), -8);', 'sub32(b->dst[2], b->dst[0]) / 2), -7);')
m('place-text-x-half', 'arith', 'sub32(b->dst[2], b->dst[0]) / 2), -8);', 'sub32(b->dst[2], b->dst[0]) / 3), -8);')
m('place-text-x-base', 'field', 'b->text_x = add32(sub32(b->dst[2], sub32', 'b->text_x = add32(sub32(b->dst[0], sub32')
m('place-variant-modulus', 'arith', 'variant = (int16_t)(r % (int32_t)rd_s16(body, B_VARIANTS));', 'variant = (int16_t)(r % ((int32_t)rd_s16(body, B_VARIANTS) + 1));')
m('place-variant-index', 'index', 'B_VARIANT_RECT + (size_t)variant * 16u', 'B_VARIANT_RECT + (size_t)variant * 8u')
m('place-state', 'field', 'b->state = TQZ_BALLOON_FLYING;\n    CHECK(pick_char', 'b->state = TQZ_BALLOON_POPPING;\n    CHECK(pick_char')
m('place-char-store', 'field', 'b->ch = ch;', 'b->ch = (uint8_t)(ch & 0x7f);')
m('place-spawn', 'field', 'b->spawn = t;', 'b->spawn = t + 1u;')
m('place-lifetime-span', 'arith', 'add32(sub32(rd_s16(body, B_LIFE_MAX), rd_s16(body, B_LIFE_MIN)), 1), 0)', 'add32(sub32(rd_s16(body, B_LIFE_MAX), rd_s16(body, B_LIFE_MIN)), 2), 0)')
m('place-lifetime-base', 'field', '                            rd_s16(body, B_LIFE_MIN));\n    return TQZ_OK;', '                            0);\n    return TQZ_OK;')
m('place-lifetime-base-max', 'field', '                            rd_s16(body, B_LIFE_MIN));\n    return TQZ_OK;', '                            rd_s16(body, B_LIFE_MAX));\n    return TQZ_OK;')
m('first-wave-span', 'arith', 'r % add32(sub32(rd_s16(body, B_COUNT_MAX), rd_s16(body, B_COUNT_MIN)), 1) + rd_s16(body, B_COUNT_MIN)', 'r % add32(sub32(rd_s16(body, B_COUNT_MAX), rd_s16(body, B_COUNT_MIN)), 2) + rd_s16(body, B_COUNT_MIN)')
m('first-wave-base', 'field', 'r % add32(sub32(rd_s16(body, B_COUNT_MAX), rd_s16(body, B_COUNT_MIN)), 1) + rd_s16(body, B_COUNT_MIN)', 'r % add32(sub32(rd_s16(body, B_COUNT_MAX), rd_s16(body, B_COUNT_MIN)), 1)')
m('first-wave-clear', 'missing-effect', 'memset(o->balloon, 0, sizeof o->balloon);', ';')
m('first-wave-loop', 'index', 'for (int16_t k = 0; k < o->count; ++k) CHECK(place_balloon(o, body, host, k));', 'for (int16_t k = 0; k < o->count - 1; ++k) CHECK(place_balloon(o, body, host, k));')
m('more-below-min', 'predicate', 'if (add32(o->count, n) < lo) {', 'if (add32(o->count, n) <= lo) {')
m('more-below-min-store', 'field', 'o->count = lo;', 'o->count = hi;')
m('more-fresh-first', 'arith', 'fresh = (int16_t)(r % (n + 1));\n        while', 'fresh = (int16_t)(r % n);\n        while')
m('more-fresh-retry', 'arith', 'fresh = (int16_t)(r % (n + 1));\n        }', 'fresh = (int16_t)(r % n);\n        }')
m('more-loop-lo', 'predicate', 'while (add32(o->count, fresh) < lo || hi < add32(o->count, fresh)) {', 'while (add32(o->count, fresh) <= lo || hi < add32(o->count, fresh)) {')
m('more-loop-hi', 'predicate', 'while (add32(o->count, fresh) < lo || hi < add32(o->count, fresh)) {', 'while (add32(o->count, fresh) < lo || hi <= add32(o->count, fresh)) {')
m('more-count-store', 'missing-effect', 'o->count = (int16_t)(o->count + fresh);', ';')
m('more-fill-gate', 'predicate', 'k < rd_s16(body, B_POSITIONS) && fresh > 0; ++k', 'k < rd_s16(body, B_POSITIONS) && fresh >= 0; ++k')
m('more-fill-range', 'index', 'k < rd_s16(body, B_POSITIONS) && fresh > 0; ++k', 'k < rd_s16(body, B_POSITIONS) - 1 && fresh > 0; ++k')
m('more-fill-free', 'predicate', 'if (o->balloon[k].state == 0) {', 'if (o->balloon[k].state != TQZ_BALLOON_FLYING) {')
m('more-fill-decrement', 'missing-effect', 'fresh = (int16_t)(fresh - 1);', ';')

# ---------------------------------------------------------------------------------------------------------------------------------
# clock, score, expiry, keys
# ---------------------------------------------------------------------------------------------------------------------------------
m('clock-elapsed-sign', 'arith', 'o->elapsed = t - o->start_tick;', 'o->elapsed = o->start_tick - t;')
m('clock-seconds-div', 'arith', 'sub32(rd_s16(body, B_TIME_LIMIT), (int32_t)(o->elapsed / 1000u))', 'sub32(rd_s16(body, B_TIME_LIMIT), (int32_t)(o->elapsed / 1001u))')
m('clock-limit-field', 'field', 'remaining = sub32(rd_s16(body, B_TIME_LIMIT)', 'remaining = sub32(rd_s16(body, B_FACTOR)')
m('clock-minutes-div', 'arith', 'minutes = remaining / 60;', 'minutes = remaining / 59;')
m('clock-minutes-clamp-test', 'compare', 'if (minutes >= 0x3b) minutes = 0x3b;', 'if (minutes > 0x3b) minutes = 0x3b;')
m('clock-minutes-clamp-value', 'constant', 'if (minutes >= 0x3b) minutes = 0x3b;', 'if (minutes >= 0x3b) minutes = 0x3a;')
m('clock-seconds-mul', 'arith', 'seconds = sub32(remaining, mul32(minutes, 60));', 'seconds = sub32(remaining, mul32(minutes, 59));')
m('clock-seconds-clamp-test', 'compare', 'if (seconds >= 0x3b) seconds = 0x3b;', 'if (seconds > 0x3b) seconds = 0x3b;')
m('clock-seconds-clamp-value', 'constant', 'if (seconds >= 0x3b) seconds = 0x3b;', 'if (seconds >= 0x3b) seconds = 0x3a;')
m('clock-change-test', 'predicate', 'if (minutes != o->minutes || seconds != o->seconds) {', 'if (minutes != o->minutes && seconds != o->seconds) {')
m('clock-change-minutes-only', 'predicate', 'if (minutes != o->minutes || seconds != o->seconds) {', 'if (minutes != o->minutes) {')
m('clock-change-seconds-only', 'predicate', 'if (minutes != o->minutes || seconds != o->seconds) {', 'if (seconds != o->seconds) {')
m('clock-seconds-floor', 'predicate', 'if (o->seconds < 0) o->seconds = 0;', 'if (o->seconds < -1) o->seconds = 0;')
m('clock-minutes-floor', 'predicate', 'if (o->minutes < 0) o->minutes = 0;', ';')
m('clock-set-order', 'arith', 'std_set_clock(&world->display, o->minutes, o->seconds) != STD_OK) return TQZ_ERR_BOUNDS;\n        fx', 'std_set_clock(&world->display, o->seconds, o->minutes) != STD_OK) return TQZ_ERR_BOUNDS;\n        fx')
m('clock-effect', 'field', 'fx(host, TQZ_FX_SET_CLOCK, o->minutes, o->seconds);\n    }\n    return TQZ_OK;', 'fx(host, TQZ_FX_SET_CLOCK, o->seconds, o->minutes);\n    }\n    return TQZ_OK;')
m('score-gate-seconds', 'predicate', 'if (secs != 0u && o->hits != 0) {', 'if (o->hits != 0) {')
m('score-gate-hits', 'predicate', 'if (secs != 0u && o->hits != 0) {', 'if (secs != 0u) {')
m('score-gate-or', 'predicate', 'if (secs != 0u && o->hits != 0) {', 'if (secs != 0u || o->hits != 0) {')
m('score-hits-float', 'precision', 'const double hits = (double)(float)(double)(uint32_t)o->hits;', 'const double hits = (double)(uint32_t)o->hits;')
m('score-hits-signed', 'sign', 'const double hits = (double)(float)(double)(uint32_t)o->hits;', 'const double hits = (double)(float)(double)(int32_t)o->hits;')
m('score-factor-field', 'field', 'const double factor = (double)(float)(int32_t)rd_s16(body, B_FACTOR);', 'const double factor = (double)(float)(int32_t)rd_s16(body, B_MIN_SCORE);')
m('score-factor-unsigned', 'sign', 'const double factor = (double)(float)(int32_t)rd_s16(body, B_FACTOR);', 'const double factor = (double)(float)(uint32_t)(uint16_t)rd_s16(body, B_FACTOR);')
m('score-seconds-float', 'precision', 'const double seconds = (double)(float)(int32_t)secs;', 'const double seconds = (double)(int32_t)secs;')
m('score-grouping', 'precision', 'const double scaled = (hits / (factor * seconds)) * (double)60.0f;', 'const double scaled = ((hits / factor) / seconds) * (double)60.0f;')
m('score-scale-first', 'precision', 'const double scaled = (hits / (factor * seconds)) * (double)60.0f;', 'const double scaled = (hits * (double)60.0f) / (factor * seconds);')
m('score-scale', 'constant', 'const double scaled = (hits / (factor * seconds)) * (double)60.0f;', 'const double scaled = (hits / (factor * seconds)) * (double)59.0f;')
m('score-store-float', 'precision', 'const float stored = (float)scaled;', 'const double stored = scaled;')
m('score-wrap-int16', 'sign', 'o->score = (int32_t)(int16_t)(uint16_t)(uint64_t)ftol64((double)stored);', 'o->score = (int32_t)ftol64((double)stored);')
m('score-wrap-unsigned', 'sign', 'o->score = (int32_t)(int16_t)(uint16_t)(uint64_t)ftol64((double)stored);', 'o->score = (int32_t)(uint16_t)(uint64_t)ftol64((double)stored);')
m('ftol-range-low', 'compare', 'if (!(v >= -9223372036854775808.0 && v < 9223372036854775808.0)) return INT64_MIN;', 'if (!(v > -9223372036854775808.0 && v < 9223372036854775808.0)) return INT64_MIN;')
m('ftol-range-skipped', 'compare', 'if (!(v >= -9223372036854775808.0 && v < 9223372036854775808.0)) return INT64_MIN;', ';')
m('score-change-test', 'predicate', 'if (o->score != o->prev_score) {', 'if (o->score == o->prev_score) {')
m('score-change-removed', 'predicate', 'if (o->score != o->prev_score) {', 'if (1) {')
m('score-effect', 'field', 'fx(host, TQZ_FX_SET_SCORE, o->score, 0);\n    }\n    if ((int32_t)rd_s16(body, B_TIME_LIMIT)', 'fx(host, TQZ_FX_SET_SCORE, o->prev_score, 0);\n    }\n    if ((int32_t)rd_s16(body, B_TIME_LIMIT)')
m('score-timeup-test', 'predicate', '(int32_t)rd_s16(body, B_TIME_LIMIT) <= (int32_t)secs', '(int32_t)rd_s16(body, B_TIME_LIMIT) < (int32_t)secs')
m('score-timeup-state', 'field', 'o->state = TQZ_STATE_TIME_UP;\n        fx(host, TQZ_FX_STATE, o->state, 0);\n    }\n    return TQZ_OK;', 'o->state = TQZ_STATE_WAIT_END;\n        fx(host, TQZ_FX_STATE, o->state, 0);\n    }\n    return TQZ_OK;')
m('expire-state-test', 'predicate', 'if (b->state == TQZ_BALLOON_FLYING && (uint32_t)(int32_t)b->lifetime', 'if (b->state != 0 && (uint32_t)(int32_t)b->lifetime')
m('expire-lifetime-test', 'predicate', '(uint32_t)(int32_t)b->lifetime < (t - b->spawn) / 1000u', '(uint32_t)(int32_t)b->lifetime <= (t - b->spawn) / 1000u')
m('expire-lifetime-signed', 'sign', '(uint32_t)(int32_t)b->lifetime < (t - b->spawn) / 1000u', '(uint32_t)(uint16_t)b->lifetime < (t - b->spawn) / 1000u')
m('expire-lifetime-div', 'arith', '(t - b->spawn) / 1000u', '(t - b->spawn) / 1024u')
m('expire-state', 'field', 'b->state = TQZ_BALLOON_GONE;\n            o->count = (int16_t)(o->count - 1);\n            gone', 'b->state = TQZ_BALLOON_POPPING;\n            o->count = (int16_t)(o->count - 1);\n            gone')
m('expire-count', 'arith', 'o->count = (int16_t)(o->count - 1);\n            gone', 'o->count = (int16_t)(o->count - 2);\n            gone')
m('expire-range', 'index', 'for (int16_t k = 0; k < rd_s16(body, B_POSITIONS); ++k) {\n        TqzBalloon *b = &o->balloon[k];\n        if (b->state == TQZ_BALLOON_FLYING && (uint32_t)(int32_t)b->lifetime', 'for (int16_t k = 0; k < rd_s16(body, B_POSITIONS) - 1; ++k) {\n        TqzBalloon *b = &o->balloon[k];\n        if (b->state == TQZ_BALLOON_FLYING && (uint32_t)(int32_t)b->lifetime')
m('expire-sound-gate', 'predicate', 'if (gone > 0) {', 'if (gone > 1) {')
m('expire-sound-channel', 'field', 'CHECK(play(host, sound_channel(body, B_CHANNEL_TIMEOUT)));', 'CHECK(play(host, sound_channel(body, B_CHANNEL_MISS)));')
m('expire-more-count', 'constant', 'CHECK(more_balloons(o, body, host, 2));\n    }\n    return TQZ_OK;\n}\n\n/* The key handling', 'CHECK(more_balloons(o, body, host, 1));\n    }\n    return TQZ_OK;\n}\n\n/* The key handling')
m('expire-more-missing', 'missing-effect', 'CHECK(more_balloons(o, body, host, 2));\n    }\n    return TQZ_OK;\n}\n\n/* The key handling', ';\n    }\n    return TQZ_OK;\n}\n\n/* The key handling')
m('key-pending-gate', 'predicate', 'if (o->key_pending == 0) return TQZ_OK;', ';')
m('key-case-gate', 'predicate', 'if (body[B_CASE_SENSITIVE] == 0 &&', 'if (body[B_CASE_SENSITIVE] != 0 &&')
m('key-case-gate-removed', 'predicate', 'if (body[B_CASE_SENSITIVE] == 0 &&', 'if (')
m('key-case-differs', 'predicate', '(uint32_t)b->ch != (uint32_t)sch && \'@\' < sch', '(uint32_t)b->ch == (uint32_t)sch && \'@\' < sch')
m('key-case-letter-low', 'compare', "'@' < sch) {", "'A' < sch) {")
m('key-case-upper-test', 'compare', 'if (b->ch < 0x61 ||', 'if (b->ch <= 0x61 ||')
m('key-case-upper-offset', 'constant', '(uint32_t)b->ch != (uint32_t)sch + 0x20u', '(uint32_t)b->ch != (uint32_t)sch + 0x21u')
m('key-case-lower-test', 'compare', "if ('`' < sch &&", "if ('a' < sch &&")
m('key-case-lower-offset', 'constant', '(uint32_t)b->ch == (uint32_t)sch - 0x20u', '(uint32_t)b->ch == (uint32_t)sch - 0x1fu')
m('key-case-lower-store', 'constant', 'o->key_char = (uint8_t)(o->key_char - 0x20);', 'o->key_char = (uint8_t)(o->key_char - 0x1f);')
m('key-case-upper-store', 'constant', 'o->key_char = (uint8_t)(o->key_char + 0x20);', 'o->key_char = (uint8_t)(o->key_char + 0x1f);')
m('key-hit-state', 'predicate', 'if (b->state == TQZ_BALLOON_FLYING && (uint32_t)b->ch == (uint32_t)(int32_t)(int8_t)o->key_char) {', 'if ((uint32_t)b->ch == (uint32_t)(int32_t)(int8_t)o->key_char) {')
m('key-hit-signed', 'sign', '(uint32_t)b->ch == (uint32_t)(int32_t)(int8_t)o->key_char', '(uint32_t)b->ch == (uint32_t)(uint8_t)o->key_char')
m('key-hit-state-store', 'field', 'b->state = TQZ_BALLOON_POPPING;\n            o->hits', 'b->state = TQZ_BALLOON_GONE;\n            o->hits')
m('key-hit-count', 'arith', 'o->hits = add32(o->hits, 1);', 'o->hits = add32(o->hits, 2);')
m('key-hit-channel', 'field', 'CHECK(play(host, sound_channel(body, B_CHANNEL_HIT)));', 'CHECK(play(host, sound_channel(body, B_CHANNEL_MISS)));')
m('key-hit-deadline', 'constant', 'b->deadline = t + 1000u;', 'b->deadline = t + 999u;')
m('key-hit-pending', 'missing-effect', 'b->deadline = t + 1000u;\n            o->key_pending = 0;', 'b->deadline = t + 1000u;')
m('key-hit-break', 'missing-effect', 'o->key_pending = 0;\n            break;', 'o->key_pending = 0;')
m('key-miss-gate', 'predicate', 'if (o->key_pending != 0) {\n        o->key_pending = 0;', 'if (o->key_pending == 0) {\n        o->key_pending = 0;')
m('key-miss-channel', 'field', 'CHECK(play(host, sound_channel(body, B_CHANNEL_MISS)));', 'CHECK(play(host, sound_channel(body, B_CHANNEL_HIT)));')
m('key-miss-pending', 'missing-effect', 'o->key_pending = 0;\n        CHECK(play(host, sound_channel(body, B_CHANNEL_MISS)));', 'CHECK(play(host, sound_channel(body, B_CHANNEL_MISS)));')
m('key-range', 'index', 'for (int16_t k = 0; k < rd_s16(body, B_POSITIONS); ++k) {\n        TqzBalloon *b = &o->balloon[k];\n        const int32_t sch', 'for (int16_t k = 0; k < rd_s16(body, B_POSITIONS) - 1; ++k) {\n        TqzBalloon *b = &o->balloon[k];\n        const int32_t sch')

# ---------------------------------------------------------------------------------------------------------------------------------
# phase 0
# ---------------------------------------------------------------------------------------------------------------------------------
m('p0-row', 'field', 'o->row = row;\n    o->active = 1;', 'o->row = 0;\n    o->active = 1;')
m('p0-active-effect', 'missing-effect', 'fx(host, TQZ_FX_ACTIVE, 1, 0);', ';')
m('p0-start-flag', 'field', 'world->start_flag_5bb1ca = 1;\n    fx(host, TQZ_FX_START_FLAG, 1, 0);', 'world->start_flag_5bb1ca = 0;\n    fx(host, TQZ_FX_START_FLAG, 1, 0);')
m('p0-start-flag-effect', 'missing-effect', 'fx(host, TQZ_FX_START_FLAG, 1, 0);\n    HOST(host->clear_pending_item', 'HOST(host->clear_pending_item')
m('p0-clear-item', 'missing-effect', 'HOST(host->clear_pending_item(host->context));\n    fx(host, TQZ_FX_CLEAR_ITEM, 0, 0);', 'fx(host, TQZ_FX_CLEAR_ITEM, 0, 0);')
m('p0-slot-store', 'field', 'fx(host, TQZ_FX_SLOT, slot, 0);\n    o->slot = slot;', 'fx(host, TQZ_FX_SLOT, slot, 0);\n    o->slot = 0;')
m('p0-register-type', 'constant', 'host->register_slot(host->context, slot, 10, TQZ_CALLBACK_QUIZ, 0, "TYPING QUIZ PUZZLE OVERLAYS")', 'host->register_slot(host->context, slot, 11, TQZ_CALLBACK_QUIZ, 0, "TYPING QUIZ PUZZLE OVERLAYS")')
m('p0-register-label', 'constant', '"TYPING QUIZ PUZZLE OVERLAYS"', '"TYPING QUIZ PUZZLE OVERLAY"')
m('p0-surface-gate', 'predicate', 'if (o->surface == 0) {', 'if (1) {')
m('p0-surface-gate-never', 'predicate', 'if (o->surface == 0) {', 'if (0) {')
m('p0-surface-name', 'field', 'host->load_surface(host->context, (const char *)body, &surface)', 'host->load_surface(host->context, (const char *)body + 1, &surface)')
m('p0-surface-store', 'field', 'o->surface = surface;\n    }', 'o->surface = 0;\n    }')
m('p0-slot-surface', 'field', 'host->set_slot_surface(host->context, o->slot, o->surface)', 'host->set_slot_surface(host->context, o->slot, 0)')
m('p0-slot-surface-effect', 'field', 'fx(host, TQZ_FX_SLOT_SURFACE, o->slot, (int32_t)o->surface);', 'fx(host, TQZ_FX_SLOT_SURFACE, o->slot, 0);')
m('p0-prepare-A', 'missing-effect', 'CHECK(sound_prepare_if(body, B_SOUND_A, host));', ';')
m('p0-prepare-B', 'field', 'CHECK(sound_prepare_if(body, B_SOUND_B, host));', 'CHECK(sound_prepare_if(body, B_SOUND_C, host));')
m('p0-prepare-C', 'missing-effect', 'CHECK(sound_prepare_if(body, B_SOUND_C, host));\n    o->score = 0;', 'o->score = 0;')
m('p0-score-reset', 'missing-effect', 'o->score = 0;\n    o->hits = 0;', 'o->hits = 0;')
m('p0-hits-reset', 'missing-effect', 'o->score = 0;\n    o->hits = 0;', 'o->score = 0;')
m('p0-score-digits-count', 'index', 'for (int i = 0; i < 40; ++i) o->score_block[i] = rd_s32(body, B_SCORE_DIGITS + (size_t)i * 4u);', 'for (int i = 0; i < 39; ++i) o->score_block[i] = rd_s32(body, B_SCORE_DIGITS + (size_t)i * 4u);')
m('p0-score-x', 'field', 'o->score_block[40] = rd_s32(body, B_SCORE_X);', 'o->score_block[40] = rd_s32(body, B_SCORE_Y);')
m('p0-score-y', 'field', 'o->score_block[41] = rd_s32(body, B_SCORE_Y);', 'o->score_block[41] = rd_s32(body, B_SCORE_X);')
m('p0-score-gap', 'field', 'o->score_block[42] = rd_s32(body, B_SCORE_GAP);', 'o->score_block[42] = rd_s32(body, B_CLOCK_GAP);')
m('p0-score-surface', 'field', 'o->score_block[43] = (int32_t)o->surface;', 'o->score_block[43] = 0;')
m('p0-score-slot', 'field', 'o->score_block[44] = slot;', 'o->score_block[44] = slot + 1;')
m('p0-score-type', 'constant', 'o->score_block[45] = 10;', 'o->score_block[45] = 11;')
m('p0-score-view-x', 'field', 'view_add(&o->score_block[40], o->score_block[40], view[0]);', 'view_add(&o->score_block[40], o->score_block[40], view[1]);')
m('p0-score-view-y', 'field', 'view_add(&o->score_block[41], o->score_block[41], view[1]);', 'view_add(&o->score_block[41], o->score_block[41], view[0]);')
m('p0-score-init-error', 'validate', 'if (std_init_score(&world->display, o->score_block, &sh) != STD_OK) return TQZ_ERR_HOST;', 'std_init_score(&world->display, o->score_block, &sh);')
m('p0-score-set', 'missing-effect', 'if (std_set_score(&world->display, o->score) != STD_OK) return TQZ_ERR_BOUNDS;\n    fx(host, TQZ_FX_SET_SCORE, o->score, 0);\n    std_enable_score', 'std_enable_score')
m('p0-score-set-effect', 'missing-effect', 'fx(host, TQZ_FX_SET_SCORE, o->score, 0);\n    std_enable_score(&world->display, 1);', 'std_enable_score(&world->display, 1);')
m('p0-score-enable', 'field', 'std_enable_score(&world->display, 1);', 'std_enable_score(&world->display, 0);')
m('p0-score-enable-effect', 'missing-effect', 'fx(host, TQZ_FX_ENABLE_SCORE, 1, 0);', ';')
m('p0-start-tick', 'field', 'o->start_tick = t;\n    o->elapsed = 0;', 'o->start_tick = t + 1u;\n    o->elapsed = 0;')
m('p0-elapsed', 'missing-effect', 'o->start_tick = t;\n    o->elapsed = 0;', 'o->start_tick = t;')
m('p0-minutes-reset', 'missing-effect', 'o->minutes = 0;\n    o->seconds = 0;\n    /* The clock display block. */', 'o->seconds = 0;\n    /* The clock display block. */')
m('p0-seconds-reset', 'missing-effect', 'o->minutes = 0;\n    o->seconds = 0;\n    /* The clock display block. */', 'o->minutes = 0;\n    /* The clock display block. */')
m('p0-clock-digits-count', 'index', 'for (int i = 0; i < 40; ++i) o->clock_block[i] = rd_s32(body, B_CLOCK_DIGITS + (size_t)i * 4u);', 'for (int i = 0; i < 39; ++i) o->clock_block[i] = rd_s32(body, B_CLOCK_DIGITS + (size_t)i * 4u);')
m('p0-clock-colon', 'index', 'for (int i = 0; i < 4; ++i) o->clock_block[40 + i] = rd_s32(body, B_COLON + (size_t)i * 4u);', 'for (int i = 0; i < 3; ++i) o->clock_block[40 + i] = rd_s32(body, B_COLON + (size_t)i * 4u);')
m('p0-clock-x', 'field', 'o->clock_block[44] = rd_s32(body, B_CLOCK_X);', 'o->clock_block[44] = rd_s32(body, B_SCORE_X);')
m('p0-clock-y', 'field', 'o->clock_block[45] = rd_s32(body, B_CLOCK_Y);', 'o->clock_block[45] = rd_s32(body, B_SCORE_Y);')
m('p0-clock-gap', 'field', 'o->clock_block[46] = rd_s32(body, B_CLOCK_GAP);', 'o->clock_block[46] = rd_s32(body, B_SCORE_GAP);')
m('p0-clock-surface', 'field', 'o->clock_block[47] = (int32_t)o->surface;', 'o->clock_block[47] = 0;')
m('p0-clock-slot', 'field', 'o->clock_block[48] = slot;', 'o->clock_block[48] = slot + 1;')
m('p0-clock-type', 'constant', 'o->clock_block[49] = 10;', 'o->clock_block[49] = 11;')
m('p0-clock-view-x', 'field', 'view_add(&o->clock_block[44], o->clock_block[44], view[0]);', 'view_add(&o->clock_block[44], o->clock_block[44], view[1]);')
m('p0-clock-view-y', 'field', 'view_add(&o->clock_block[45], o->clock_block[45], view[1]);', 'view_add(&o->clock_block[45], o->clock_block[45], view[0]);')
m('p0-clock-init-error', 'validate', 'if (std_init_clock(&world->display, o->clock_block, &sh) != STD_OK) return TQZ_ERR_HOST;', 'std_init_clock(&world->display, o->clock_block, &sh);')
m('p0-clock-set', 'missing-effect', 'if (std_set_clock(&world->display, o->minutes, o->seconds) != STD_OK) return TQZ_ERR_BOUNDS;\n    fx(host, TQZ_FX_SET_CLOCK, o->minutes, o->seconds);\n    std_enable_clock', 'std_enable_clock')
m('p0-clock-enable', 'field', 'std_enable_clock(&world->display, 1);', 'std_enable_clock(&world->display, 0);')
m('p0-clock-enable-effect', 'missing-effect', 'fx(host, TQZ_FX_ENABLE_CLOCK, 1, 0);', ';')
m('p0-played', 'field', 'world->played_5a4c0a = 1;', 'world->played_5a4c0a = 0;')
m('p0-played-effect', 'missing-effect', 'fx(host, TQZ_FX_PLAYED_FLAG, 1, 0);', ';')
m('p0-target-percent-gate', 'predicate', 'if (rd_s16(body, B_TARGET_PERCENT) < 1 || world->best_5a4c0e < 1) {', 'if (rd_s16(body, B_TARGET_PERCENT) < 0 || world->best_5a4c0e < 1) {')
m('p0-target-best-gate', 'predicate', 'if (rd_s16(body, B_TARGET_PERCENT) < 1 || world->best_5a4c0e < 1) {', 'if (rd_s16(body, B_TARGET_PERCENT) < 1 || world->best_5a4c0e < 0) {')
m('p0-target-gate-and', 'predicate', 'if (rd_s16(body, B_TARGET_PERCENT) < 1 || world->best_5a4c0e < 1) {', 'if (rd_s16(body, B_TARGET_PERCENT) < 1 && world->best_5a4c0e < 1) {')
m('p0-target-default', 'field', 'o->target = rd_s16(body, B_DEFAULT_TARGET);', 'o->target = rd_s16(body, B_TARGET_LOW);')
m('p0-target-percent', 'arith', 'o->target = (int16_t)(mul32(world->best_5a4c0e, rd_s16(body, B_TARGET_PERCENT)) / 100);', 'o->target = (int16_t)(mul32(world->best_5a4c0e, rd_s16(body, B_TARGET_PERCENT)) / 101);')
m('p0-target-percent-field', 'field', 'mul32(world->best_5a4c0e, rd_s16(body, B_TARGET_PERCENT))', 'mul32(world->best_5a4c0e, rd_s16(body, B_TARGET_LOW))')
m('p0-target-low-test', 'predicate', 'if (o->target <= rd_s16(body, B_TARGET_LOW)) o->target', 'if (o->target < rd_s16(body, B_TARGET_LOW)) o->target')
m('p0-target-low-store', 'field', 'o->target = rd_s16(body, B_TARGET_LOW);\n    }', 'o->target = rd_s16(body, B_DEFAULT_TARGET);\n    }')
m('p0-state', 'field', 'o->state = TQZ_STATE_PLAY;\n    fx(host, TQZ_FX_STATE, o->state, 0);\n    fx(host, TQZ_FX_PHASE, 1, 0);', 'o->state = TQZ_STATE_TIME_UP;\n    fx(host, TQZ_FX_STATE, o->state, 0);\n    fx(host, TQZ_FX_PHASE, 1, 0);')
m('p0-state-effect', 'missing-effect', 'fx(host, TQZ_FX_STATE, o->state, 0);\n    fx(host, TQZ_FX_PHASE, 1, 0);', 'fx(host, TQZ_FX_PHASE, 1, 0);')
m('p0-phase-effect', 'field', 'fx(host, TQZ_FX_PHASE, 1, 0);\n    HOST(host->font_acquire', 'fx(host, TQZ_FX_PHASE, 2, 0);\n    HOST(host->font_acquire')
m('p0-font-effect', 'missing-effect', 'fx(host, TQZ_FX_FONT_ACQUIRE, TQZ_FONT_SURFACE, 0);', ';')
m('p0-first-wave', 'missing-effect', 'CHECK(first_wave(o, body, host));', ';')
m('p0-max-char-wide-gate', 'predicate', 'if (body[B_WIDE] == 0) {\n        o->max_char', 'if (body[B_WIDE] != 0) {\n        o->max_char')
m('p0-max-char-extra-gate', 'predicate', 'o->max_char = body[B_EXTRA] == 0 ? 0x7b : 0x7f;', 'o->max_char = body[B_EXTRA] != 0 ? 0x7b : 0x7f;')
m('p0-max-char-plain', 'constant', 'o->max_char = body[B_EXTRA] == 0 ? 0x7b : 0x7f;', 'o->max_char = body[B_EXTRA] == 0 ? 0x7a : 0x7f;')
m('p0-max-char-extra', 'constant', 'o->max_char = body[B_EXTRA] == 0 ? 0x7b : 0x7f;', 'o->max_char = body[B_EXTRA] == 0 ? 0x7b : 0x7e;')
m('p0-max-char-wide', 'constant', 'o->max_char = 0x100;', 'o->max_char = 0xff;')

# ---------------------------------------------------------------------------------------------------------------------------------
# phase 1, phase 2, step
# ---------------------------------------------------------------------------------------------------------------------------------
m('p1-order-clock-expire', 'order', 'CHECK(clock_update(o, body, world, host));\n        CHECK(expire_balloons(o, body, host));', 'CHECK(expire_balloons(o, body, host));\n        CHECK(clock_update(o, body, world, host));')
m('p1-order-key-score', 'order', 'CHECK(process_key(o, body, host));\n        CHECK(score_update(o, body, world, host));', 'CHECK(score_update(o, body, world, host));\n        CHECK(process_key(o, body, host));')
m('p1-order-expire-key', 'order', 'CHECK(expire_balloons(o, body, host));\n        CHECK(process_key(o, body, host));', 'CHECK(process_key(o, body, host));\n        CHECK(expire_balloons(o, body, host));')
m('p1-no-clock', 'missing-effect', 'CHECK(clock_update(o, body, world, host));\n        CHECK(expire_balloons', 'CHECK(expire_balloons')
m('p1-no-expire', 'missing-effect', 'CHECK(expire_balloons(o, body, host));\n        CHECK(process_key', 'CHECK(process_key')
m('p1-no-score', 'missing-effect', 'CHECK(score_update(o, body, world, host));\n        break;', 'break;')
m('p1-timeup-deadline-sign', 'arith', 'o->end_deadline = t + (uint32_t)rd_s32(body, B_END_DELAY);', 'o->end_deadline = t - (uint32_t)rd_s32(body, B_END_DELAY);')
m('p1-timeup-deadline-field', 'field', 'o->end_deadline = t + (uint32_t)rd_s32(body, B_END_DELAY);', 'o->end_deadline = t + (uint32_t)rd_s32(body, B_TIME_LIMIT);')
m('p1-timeup-state', 'field', 'o->state = TQZ_STATE_WAIT_END;\n        fx(host, TQZ_FX_STATE, o->state, 0);\n        o->flag34', 'o->state = TQZ_STATE_PLAY;\n        fx(host, TQZ_FX_STATE, o->state, 0);\n        o->flag34')
m('p1-timeup-flag34', 'missing-effect', 'o->flag34 = 1;\n        o->finishing = 1;', 'o->finishing = 1;')
m('p1-timeup-finishing', 'missing-effect', 'o->flag34 = 1;\n        o->finishing = 1;', 'o->flag34 = 1;')
m('p1-timeup-compare', 'predicate', 'if (o->score < (int32_t)o->target) {', 'if (o->score <= (int32_t)o->target) {')
m('p1-timeup-min-score', 'predicate', 'if ((int32_t)rd_s16(body, B_MIN_SCORE) <= o->score) o->reached = 1;', 'if ((int32_t)rd_s16(body, B_MIN_SCORE) < o->score) o->reached = 1;')
m('p1-timeup-min-score-field', 'field', 'if ((int32_t)rd_s16(body, B_MIN_SCORE) <= o->score) o->reached = 1;', 'if ((int32_t)rd_s16(body, B_DEFAULT_TARGET) <= o->score) o->reached = 1;')
m('p1-timeup-reached', 'missing-effect', 'o->reached = 1;', ';')
m('p1-timeup-passed', 'missing-effect', 'o->passed = 1;', ';')
m('p1-timeup-sound-d', 'predicate', 'if (!no_sound(body + B_SOUND_D)) {\n                HOST(host->sound_prepare', 'if (no_sound(body + B_SOUND_D)) {\n                HOST(host->sound_prepare')
m('p1-timeup-sound-offset', 'field', 'HOST(host->sound_prepare(host->context, body + B_SOUND_D));', 'HOST(host->sound_prepare(host->context, body + B_SOUND_C));')
m('p1-timeup-sound-channel', 'field', 'CHECK(play(host, sound_channel(body, B_CHANNEL_D)));', 'CHECK(play(host, sound_channel(body, B_CHANNEL_HIT)));')
m('p1-timeup-sound-effect', 'missing-effect', 'fx(host, TQZ_FX_SOUND_PREPARE, B_SOUND_D, 0);', ';')
m('p1-wait-compare', 'predicate', 'if (o->end_deadline <= t) {', 'if (o->end_deadline < t) {')
m('p1-wait-best', 'field', 'world->best_5a4c0e = (int16_t)o->score;', 'world->best_5a4c0e = (int16_t)o->target;')
m('p1-wait-best-missing', 'missing-effect', 'world->best_5a4c0e = (int16_t)o->score;\n            fx(host, TQZ_FX_BEST_SCORE, world->best_5a4c0e, 0);', 'fx(host, TQZ_FX_BEST_SCORE, world->best_5a4c0e, 0);')
m('p1-wait-phase', 'field', '*row_phase = 2u;\n            fx(host, TQZ_FX_PHASE, 2, 0);', '*row_phase = 1u;\n            fx(host, TQZ_FX_PHASE, 2, 0);')
m('p1-wait-reset-score', 'missing-effect', 'std_reset_score(&world->display);\n            std_reset_clock', 'std_reset_clock')
m('p1-wait-reset-clock', 'missing-effect', 'std_reset_clock(&world->display);\n            fx(host, TQZ_FX_RESET_DISPLAY, 0, 0);', 'fx(host, TQZ_FX_RESET_DISPLAY, 0, 0);')
m('p1-wait-active', 'missing-effect', 'o->active = 0;\n            fx(host, TQZ_FX_ACTIVE, 0, 0);', 'fx(host, TQZ_FX_ACTIVE, 0, 0);')
m('block-start-flag', 'predicate', 'rd_s16(blk, SB_START) != 1 ? 1 : 0', 'rd_s16(blk, SB_START) == 1 ? 1 : 0')
m('block-start-field', 'field', 'rd_s16(blk, SB_START) != 1 ? 1 : 0', 'rd_s16(blk, SB_FLAG) != 1 ? 1 : 0')
m('block-word1', 'field', 't.word[0] = rd_s16(blk, SB_W1);', 't.word[0] = rd_s16(blk, SB_W2);')
m('block-word2', 'field', 't.word[1] = rd_s16(blk, SB_W2);', 't.word[1] = rd_s16(blk, SB_W3);')
m('block-word3', 'field', 't.word[2] = rd_s16(blk, SB_W3);', 't.word[2] = rd_s16(blk, SB_W1);')
m('block-dword1', 'field', 't.dword[0] = rd_s32(blk, SB_D1);', 't.dword[0] = rd_s32(blk, SB_D2);')
m('block-dword2', 'field', 't.dword[1] = rd_s32(blk, SB_D2);', 't.dword[1] = rd_s32(blk, SB_D3);')
m('block-dword3', 'field', 't.dword[2] = rd_s32(blk, SB_D3);', 't.dword[2] = rd_s32(blk, SB_D1);')
m('block-scene', 'field', 't.scene = rd_s16(blk, SB_SCENE);', 't.scene = rd_s16(blk, SB_W1);')
m('block-effect-scene', 'missing-effect', 'fx(host, TQZ_FX_XFER_5BB57B, t.scene, 0);', ';')
m('block-effect-word2', 'field', 'fx(host, TQZ_FX_XFER_5BB595, t.word[1], 0);', 'fx(host, TQZ_FX_XFER_5BB595, t.word[0], 0);')
m('block-effect-dword3', 'field', 'fx(host, TQZ_FX_XFER_5BB5A3, t.dword[2], 0);', 'fx(host, TQZ_FX_XFER_5BB5A3, t.dword[1], 0);')
m('block-effect-start', 'missing-effect', 'fx(host, TQZ_FX_START_FLAG, world->start_flag_5bb1ca, 0);', ';')
m('flag-value', 'field', 'HOST(host->store_event_flag(host->context, index, 1u));', 'HOST(host->store_event_flag(host->context, index, 0u));')
m('flag-effect-value', 'field', 'fx(host, TQZ_FX_EVENT_FLAG, index, 1);', 'fx(host, TQZ_FX_EVENT_FLAG, index, 0);')
m('flag-effect-index', 'field', 'fx(host, TQZ_FX_EVENT_FLAG, index, 1);', 'fx(host, TQZ_FX_EVENT_FLAG, index + 1, 1);')
m('p2-stop-A', 'missing-effect', 'CHECK(sound_stop_if(body, B_SOUND_A, host));', ';')
m('p2-stop-B', 'field', 'CHECK(sound_stop_if(body, B_SOUND_B, host));', 'CHECK(sound_stop_if(body, B_SOUND_A, host));')
m('p2-stop-C', 'missing-effect', 'CHECK(sound_stop_if(body, B_SOUND_C, host));\n    if (o->passed == 0) {', 'if (o->passed == 0) {')
m('p2-stop-D', 'missing-effect', 'CHECK(sound_stop_if(body, B_SOUND_D, host));', ';')
m('p2-passed-test', 'predicate', 'if (o->passed == 0) {\n        CHECK(apply_block', 'if (o->passed != 0) {\n        CHECK(apply_block')
m('p2-normal-block', 'field', 'CHECK(apply_block(body + B_NORMAL, 0, world, host));', 'CHECK(apply_block(body + B_PASSED, 0, world, host));')
m('p2-reached-test', 'predicate', 'if (o->reached == 0 || rd_s16(body, B_NORMAL + SB_FLAG) == TQZ_NO_FLAG) {', 'if (o->reached != 0 || rd_s16(body, B_NORMAL + SB_FLAG) == TQZ_NO_FLAG) {')
m('p2-reached-and', 'predicate', 'if (o->reached == 0 || rd_s16(body, B_NORMAL + SB_FLAG) == TQZ_NO_FLAG) {', 'if (o->reached == 0 && rd_s16(body, B_NORMAL + SB_FLAG) == TQZ_NO_FLAG) {')
m('p2-flag-none-test', 'predicate', 'rd_s16(body, B_NORMAL + SB_FLAG) == TQZ_NO_FLAG) {\n            if (rd_s16', 'rd_s16(body, B_NORMAL + SB_FLAG) != TQZ_NO_FLAG) {\n            if (rd_s16')
m('p2-flag2-test', 'predicate', 'if (rd_s16(body, B_NORMAL + SB_FLAG2) != TQZ_NO_FLAG) CHECK(store_flag(rd_s16(body, B_NORMAL + SB_FLAG2), host));', 'if (rd_s16(body, B_NORMAL + SB_FLAG2) == TQZ_NO_FLAG) CHECK(store_flag(rd_s16(body, B_NORMAL + SB_FLAG2), host));')
m('p2-flag2-field', 'field', 'CHECK(store_flag(rd_s16(body, B_NORMAL + SB_FLAG2), host));', 'CHECK(store_flag(rd_s16(body, B_NORMAL + SB_FLAG), host));')
m('p2-flag-field', 'field', '} else {\n            CHECK(store_flag(rd_s16(body, B_NORMAL + SB_FLAG), host));', '} else {\n            CHECK(store_flag(rd_s16(body, B_NORMAL + SB_FLAG2), host));')
m('p2-passed-scene-test', 'predicate', 'if (rd_s16(body, B_PASSED + SB_SCENE) != TQZ_NO_SCENE) CHECK', 'if (rd_s16(body, B_PASSED + SB_SCENE) == TQZ_NO_SCENE) CHECK')
m('p2-passed-block', 'field', 'CHECK(apply_block(body + B_PASSED, 1, world, host));', 'CHECK(apply_block(body + B_NORMAL, 1, world, host));')
m('p2-passed-flag-test', 'predicate', 'if (rd_s16(body, B_PASSED + SB_FLAG) != TQZ_NO_FLAG) CHECK', 'if (rd_s16(body, B_PASSED + SB_FLAG) == TQZ_NO_FLAG) CHECK')
m('p2-passed-flag-field', 'field', 'CHECK(store_flag(rd_s16(body, B_PASSED + SB_FLAG), host));', 'CHECK(store_flag(rd_s16(body, B_NORMAL + SB_FLAG), host));')
m('p2-engine-mode', 'constant', 'HOST(host->engine_mode(host->context, 4));\n    fx(host, TQZ_FX_ENGINE_MODE, 4, 0);', 'HOST(host->engine_mode(host->context, 3));\n    fx(host, TQZ_FX_ENGINE_MODE, 4, 0);')
m('p2-engine-mode-effect', 'missing-effect', 'fx(host, TQZ_FX_ENGINE_MODE, 4, 0);', ';')
m('step-negative-row', 'validate', 'if (row < 0) {', 'if (row < -1) {')
m('step-p0-phase-after', 'field', 'row_phase = 1u;\n            result->initialized = 1u;', 'row_phase = 0u;\n            result->initialized = 1u;')
m('step-p0-initialized', 'missing-effect', 'result->initialized = 1u;', ';')
m('step-p1-active', 'predicate', 'if (object->active == 0 || object->row != row) {', 'if (object->active == 0 && object->row != row) {')
m('step-p1-row', 'predicate', 'if (object->active == 0 || object->row != row) {', 'if (object->active == 0) {')
m('step-p2-row', 'predicate', 'if (object->row != row) {\n            if (failure != NULL) *failure = "0xf5-phase-2-without-init";', 'if (0) {\n            if (failure != NULL) *failure = "0xf5-phase-2-without-init";')
m('step-p2-flag-precheck', 'validate', 'if (flag[0] != TQZ_NO_FLAG && host->event_flag_invalid(host->context, flag[0]) != 0) {', 'if (0) {')
m('step-p2-precheck-normal', 'validate', 'flag[0] = object->reached == 0 || rd_s16(body, B_NORMAL + SB_FLAG) == TQZ_NO_FLAG\n                              ? rd_s16(body, B_NORMAL + SB_FLAG2)\n                              : rd_s16(body, B_NORMAL + SB_FLAG);', 'flag[0] = rd_s16(body, B_NORMAL + SB_FLAG2);')
m('step-p2-precheck-passed', 'validate', 'flag[0] = rd_s16(body, B_PASSED + SB_FLAG);', 'flag[0] = TQZ_NO_FLAG;')
m('step-p2-complete-effect', 'missing-effect', 'fx(host, TQZ_FX_COMPLETE, row, 0);', ';')
m('step-p2-completed', 'missing-effect', 'result->completed = 1u;', ';')
m('step-p2-cleanup', 'missing-effect', 'rc = tqz_cleanup(object, world, host);\n            row_phase = 0u;', 'row_phase = 0u;')
m('step-p2-phase-after', 'field', 'rc = tqz_cleanup(object, world, host);\n            row_phase = 0u;', 'rc = tqz_cleanup(object, world, host);\n            row_phase = 1u;')
m('step-other-phase', 'predicate', '} else {\n        return TQZ_OK;\n    }\n    result->phase_after', '} else {\n        return TQZ_ERR_UNSUPPORTED;\n    }\n    result->phase_after')

# ---------------------------------------------------------------------------------------------------------------------------------
# key / pointer / click / invalidate / cleanup
# ---------------------------------------------------------------------------------------------------------------------------------
m('key-active', 'predicate', 'if (object->active != 0 && object->state == 0 && object->key_pending == 0 &&', 'if (object->state == 0 && object->key_pending == 0 &&')
m('key-state', 'predicate', 'if (object->active != 0 && object->state == 0 && object->key_pending == 0 &&', 'if (object->active != 0 && object->key_pending == 0 &&')
m('key-pending', 'predicate', 'if (object->active != 0 && object->state == 0 && object->key_pending == 0 &&', 'if (object->active != 0 && object->state == 0 &&')
m('key-row-phase', 'predicate', 'row_phase == 1u && tqz_key_filter(ch)', 'row_phase >= 1u && tqz_key_filter(ch)')
m('key-row-phase-eq2', 'predicate', 'row_phase == 1u && tqz_key_filter(ch)', 'row_phase != 0u && tqz_key_filter(ch)')
m('key-filter-used', 'predicate', 'row_phase == 1u && tqz_key_filter(ch)', 'row_phase == 1u')
m('key-store-char', 'field', 'object->key_char = (uint8_t)ch;', 'object->key_char = (uint8_t)(ch & 0x7f);')
m('key-store-pending', 'field', 'object->key_pending = 1;\n        return 1;', 'object->key_pending = 2;\n        return 1;')
m('pointer-active', 'predicate', 'if (object->active == 0 || py <', 'if (py <')
m('pointer-top', 'compare', 'py < rd_s32(body, B_RECT + 4)', 'py <= rd_s32(body, B_RECT + 4)')
m('pointer-bottom', 'compare', 'rd_s32(body, B_RECT + 12) < py', 'rd_s32(body, B_RECT + 12) <= py')
m('pointer-left', 'compare', 'px < rd_s32(body, B_RECT)', 'px <= rd_s32(body, B_RECT)')
m('pointer-right', 'compare', 'rd_s32(body, B_RECT + 8) < px', 'rd_s32(body, B_RECT + 8) <= px')
m('pointer-x-width', 'sign', 'px = (int16_t)(uint16_t)x;', 'px = (int16_t)x == x ? (int16_t)x : (int16_t)0x7fff;')
m('pointer-y-width', 'sign', 'py = (int16_t)(uint16_t)y;', 'py = (int16_t)y == y ? (int16_t)y : (int16_t)0x7fff;')
m('pointer-x-unsigned', 'sign', 'px = (int16_t)(uint16_t)x;', 'px = (int16_t)(uint8_t)x;')
m('pointer-candidate', 'constant', 'out->candidate = TQZ_CANDIDATE;', 'out->candidate = TQZ_CANDIDATE - 1;')
m('pointer-cursor-kind', 'field', 'out->cursor_kind = rd_s16(body, B_CURSOR);', 'out->cursor_kind = rd_s16(body, B_CURSOR) + 1;')
m('pointer-cursor-sub', 'constant', 'out->cursor_sub = 1;', 'out->cursor_sub = 0;')
m('pointer-rect-y-field', 'index', 'py < rd_s32(body, B_RECT + 4)', 'py < rd_s32(body, B_RECT)')
m('pointer-rect-x-field', 'index', 'px < rd_s32(body, B_RECT) ||', 'px < rd_s32(body, B_RECT + 4) ||')
m('click-active', 'predicate', 'if (object->active != 0 && object->finishing == 0 && object->state == 0 && row_phase == 1u &&', 'if (object->finishing == 0 && object->state == 0 && row_phase == 1u &&')
m('click-finishing', 'predicate', 'if (object->active != 0 && object->finishing == 0 && object->state == 0 && row_phase == 1u &&', 'if (object->active != 0 && object->state == 0 && row_phase == 1u &&')
m('click-state', 'predicate', 'if (object->active != 0 && object->finishing == 0 && object->state == 0 && row_phase == 1u &&', 'if (object->active != 0 && object->finishing == 0 && row_phase == 1u &&')
m('click-phase', 'predicate', 'if (object->active != 0 && object->finishing == 0 && object->state == 0 && row_phase == 1u &&', 'if (object->active != 0 && object->finishing == 0 && object->state == 0 &&')
m('click-candidate', 'predicate', 'candidate == TQZ_CANDIDATE) {', 'candidate != 0) {')
m('click-new-phase', 'constant', '*new_phase = 2u;', '*new_phase = 3u;')
m('click-keep-phase', 'field', '*new_phase = row_phase;\n    return 0;', '*new_phase = 0u;\n    return 0;')
m('invalidate-active', 'predicate', 'if (object->active != 0 && object->slot != TQZ_NO_SLOT) HOST(host->mark_dirty', 'if (object->slot != TQZ_NO_SLOT) HOST(host->mark_dirty')
m('invalidate-slot', 'predicate', 'if (object->active != 0 && object->slot != TQZ_NO_SLOT) HOST(host->mark_dirty', 'if (object->active != 0) HOST(host->mark_dirty')
m('invalidate-slot-arg', 'field', 'HOST(host->mark_dirty(host->context, object->slot));', 'HOST(host->mark_dirty(host->context, (int16_t)(object->slot + 1)));')
m('cleanup-surface-test', 'predicate', 'if (object->surface != 0) {\n        const uint32_t held', 'if (object->surface == 0) {\n        const uint32_t held')
m('cleanup-surface-effect', 'field', 'fx(host, TQZ_FX_RELEASE_SURFACE, (int32_t)held, 0);', 'fx(host, TQZ_FX_RELEASE_SURFACE, 0, 0);')
m('cleanup-surface-clear', 'missing-effect', 'object->surface = 0;\n    }\n    if (object->slot != TQZ_NO_SLOT) {', '}\n    if (object->slot != TQZ_NO_SLOT) {')
m('cleanup-slot-test', 'predicate', 'if (object->slot != TQZ_NO_SLOT) {\n        HOST(host->release_slot(host->context, object->slot));', 'if (object->slot > 0) {\n        HOST(host->release_slot(host->context, object->slot));')
m('cleanup-slot-effect', 'missing-effect', 'fx(host, TQZ_FX_RELEASE_SLOT, object->slot, 0);', ';')
m('cleanup-clock-test', 'predicate', 'if (object->clock_block[48] != -1) {', 'if (object->clock_block[48] > 0) {')
m('cleanup-clock-slot', 'field', 'HOST(host->release_slot(host->context, (int16_t)object->clock_block[48]));', 'HOST(host->release_slot(host->context, (int16_t)object->score_block[44]));')
m('cleanup-score-test', 'predicate', 'if (object->score_block[44] != -1) {', 'if (object->score_block[44] > 0) {')
m('cleanup-score-slot', 'field', 'HOST(host->release_slot(host->context, (int16_t)object->score_block[44]));', 'HOST(host->release_slot(host->context, (int16_t)object->clock_block[48]));')
m('cleanup-order-slots', 'order', 'if (object->clock_block[48] != -1) {', 'if (object->clock_block[48] != -1 && object->score_block[44] == -1) {')
m('cleanup-font', 'missing-effect', 'HOST(host->font_release(host->context));\n    fx(host, TQZ_FX_FONT_RELEASE, TQZ_FONT_SURFACE, 0);', 'fx(host, TQZ_FX_FONT_RELEASE, TQZ_FONT_SURFACE, 0);')
m('cleanup-font-effect', 'missing-effect', 'fx(host, TQZ_FX_FONT_RELEASE, TQZ_FONT_SURFACE, 0);', ';')
m('cleanup-row', 'field', 'object->row = -1;\n    object->slot = -1;\n    object->active = 0;', 'object->row = 0;\n    object->slot = -1;\n    object->active = 0;')
m('cleanup-slot', 'field', 'object->slot = -1;\n    object->active = 0;\n    object->passed', 'object->slot = 0;\n    object->active = 0;\n    object->passed')
m('cleanup-active', 'missing-effect', 'object->active = 0;\n    object->passed = 0;', 'object->passed = 0;')
m('cleanup-passed', 'missing-effect', 'object->passed = 0;\n    object->finishing = 0;', 'object->finishing = 0;')
m('cleanup-finishing', 'missing-effect', 'object->finishing = 0;\n    object->reached = 0;', 'object->reached = 0;')
m('cleanup-reached', 'missing-effect', 'object->reached = 0;\n    object->flag34 = 0;', 'object->flag34 = 0;')
m('cleanup-flag34', 'missing-effect', 'object->flag34 = 0;\n    object->surface = 0;\n    object->hits = 0;', 'object->surface = 0;\n    object->hits = 0;')
m('cleanup-hits', 'missing-effect', 'object->hits = 0;\n    object->score = 0;', 'object->score = 0;')
m('cleanup-score', 'missing-effect', 'object->score = 0;\n    object->prev_score = 0;', 'object->prev_score = 0;')
m('cleanup-prev-score', 'missing-effect', 'object->prev_score = 0;\n    object->dword55a = 0;', 'object->dword55a = 0;')
m('cleanup-dword55a', 'missing-effect', 'object->dword55a = 0;\n    memset(object->score_block', 'memset(object->score_block')
m('cleanup-score-block', 'missing-effect', 'memset(object->score_block, 0, sizeof object->score_block);', ';')
m('cleanup-clock-block', 'missing-effect', 'memset(object->clock_block, 0, sizeof object->clock_block);', ';')
m('cleanup-clock-slot-reset', 'missing-effect', 'object->clock_block[48] = -1;\n    object->score_block[44] = -1;\n    return TQZ_OK;', 'object->score_block[44] = -1;\n    return TQZ_OK;')
m('cleanup-score-slot-reset', 'missing-effect', 'object->score_block[44] = -1;\n    return TQZ_OK;\n}\n\nstatic int emit', 'return TQZ_OK;\n}\n\nstatic int emit')

# ---------------------------------------------------------------------------------------------------------------------------------
# render
# ---------------------------------------------------------------------------------------------------------------------------------
m('render-slot-test', 'predicate', 'if (object->active == 0 || object->slot == TQZ_NO_SLOT) return TQZ_OK;', 'if (object->active == 0) return TQZ_OK;')
m('render-active-test', 'predicate', 'if (object->active == 0 || object->slot == TQZ_NO_SLOT) return TQZ_OK;', 'if (object->slot == TQZ_NO_SLOT) return TQZ_OK;')
m('render-valid', 'missing-effect', 'out->valid = 1;\n    if (object->finishing == 0) {', 'if (object->finishing == 0) {')
m('render-finishing-test', 'predicate', 'out->valid = 1;\n    if (object->finishing == 0) {', 'out->valid = 1;\n    if (object->finishing != 0) {')
m('render-range', 'index', 'for (int16_t k = 0; k < rd_s16(body, B_POSITIONS); ++k) {\n            TqzBalloon *b = &object->balloon[k];\n            if (b->state == TQZ_BALLOON_FLYING) {', 'for (int16_t k = 0; k < rd_s16(body, B_POSITIONS) - 1; ++k) {\n            TqzBalloon *b = &object->balloon[k];\n            if (b->state == TQZ_BALLOON_FLYING) {')
m('render-flying-balloon-kind', 'field', 'emit(out, TQZ_BLIT_BALLOON, object->surface, b->src, b->dst, k, 0, 0)', 'emit(out, TQZ_BLIT_POP, object->surface, b->src, b->dst, k, 0, 0)')
m('render-flying-surface', 'field', 'emit(out, TQZ_BLIT_BALLOON, object->surface, b->src, b->dst, k, 0, 0)', 'emit(out, TQZ_BLIT_BALLOON, 0, b->src, b->dst, k, 0, 0)')
m('render-flying-src-dst', 'field', 'emit(out, TQZ_BLIT_BALLOON, object->surface, b->src, b->dst, k, 0, 0)', 'emit(out, TQZ_BLIT_BALLOON, object->surface, b->dst, b->src, k, 0, 0)')
m('render-flying-index', 'field', 'emit(out, TQZ_BLIT_BALLOON, object->surface, b->src, b->dst, k, 0, 0)', 'emit(out, TQZ_BLIT_BALLOON, object->surface, b->src, b->dst, k + 1, 0, 0)')
m('render-text-char', 'field', 'emit(out, TQZ_BLIT_TEXT, 0, NULL, NULL, b->ch, (int16_t)b->text_x, (int16_t)b->text_y)', 'emit(out, TQZ_BLIT_TEXT, 0, NULL, NULL, b->ch + 1, (int16_t)b->text_x, (int16_t)b->text_y)')
m('render-text-x', 'field', 'emit(out, TQZ_BLIT_TEXT, 0, NULL, NULL, b->ch, (int16_t)b->text_x, (int16_t)b->text_y)', 'emit(out, TQZ_BLIT_TEXT, 0, NULL, NULL, b->ch, (int16_t)b->text_y, (int16_t)b->text_x)')
m('render-text-x-width', 'sign', 'emit(out, TQZ_BLIT_TEXT, 0, NULL, NULL, b->ch, (int16_t)b->text_x, (int16_t)b->text_y)', 'emit(out, TQZ_BLIT_TEXT, 0, NULL, NULL, b->ch, b->text_x, (int16_t)b->text_y)')
m('render-text-y-width', 'sign', 'emit(out, TQZ_BLIT_TEXT, 0, NULL, NULL, b->ch, (int16_t)b->text_x, (int16_t)b->text_y)', 'emit(out, TQZ_BLIT_TEXT, 0, NULL, NULL, b->ch, (int16_t)b->text_x, b->text_y)')
m('render-text-missing', 'missing-effect', 'CHECK(emit(out, TQZ_BLIT_TEXT, 0, NULL, NULL, b->ch, (int16_t)b->text_x, (int16_t)b->text_y));', ';')
m('render-pop-rect', 'field', 'pop[i] = rd_s32(body, B_POP_RECT + (size_t)i * 4u);', 'pop[i] = rd_s32(body, B_POP_RECT + (size_t)((i + 1) % 4) * 4u);')
m('render-pop-kind', 'field', 'emit(out, TQZ_BLIT_POP, object->surface, pop, b->dst, k, 0, 0)', 'emit(out, TQZ_BLIT_BALLOON, object->surface, pop, b->dst, k, 0, 0)')
m('render-pop-dst', 'field', 'emit(out, TQZ_BLIT_POP, object->surface, pop, b->dst, k, 0, 0)', 'emit(out, TQZ_BLIT_POP, object->surface, pop, b->src, k, 0, 0)')
m('render-pop-deadline', 'predicate', 'if (b->deadline <= t) {', 'if (b->deadline < t) {')
m('render-pop-tick-missing', 'missing-effect', 'CHECK(tick(host, &t));\n                if (b->deadline <= t) {', 'if (b->deadline <= 0) {')
m('render-pop-state', 'field', 'b->state = TQZ_BALLOON_GONE;\n                    object->count = (int16_t)(object->count - 1);', 'b->state = TQZ_BALLOON_FREE;\n                    object->count = (int16_t)(object->count - 1);')
m('render-pop-count', 'arith', 'object->count = (int16_t)(object->count - 1);\n                    CHECK(more_balloons', 'object->count = (int16_t)(object->count - 2);\n                    CHECK(more_balloons')
m('render-pop-more', 'constant', 'CHECK(more_balloons(object, body, host, 2));', 'CHECK(more_balloons(object, body, host, 1));')
m('render-pop-more-missing', 'missing-effect', 'CHECK(more_balloons(object, body, host, 2));', ';')
m('render-gone-view', 'field', 'src[0] = sub32(b->dst[0], view[0]);\n                src[1] = sub32(b->dst[1], view[1]);', 'src[0] = sub32(b->dst[0], view[1]);\n                src[1] = sub32(b->dst[1], view[0]);')
m('render-gone-view-right', 'field', 'src[2] = sub32(b->dst[2], view[0]);\n                src[3] = sub32(b->dst[3], view[1]);', 'src[2] = sub32(b->dst[2], view[2]);\n                src[3] = sub32(b->dst[3], view[3]);')
m('render-gone-kind', 'field', 'emit(out, TQZ_BLIT_BALLOON_ERASE, 0, src, b->dst, k, 0, 0)', 'emit(out, TQZ_BLIT_BACKGROUND_ERASE, 0, src, b->dst, k, 0, 0)')
m('render-gone-free', 'missing-effect', 'b->state = TQZ_BALLOON_FREE;\n            }', '}')
m('render-gone-dst-index', 'field', 'emit(out, TQZ_BLIT_BALLOON_ERASE, 0, src, b->dst, k, 0, 0)', 'emit(out, TQZ_BLIT_BALLOON_ERASE, 0, src, b->dst, 0, 0, 0)')
m('render-finish-flag', 'predicate', 'if (object->flag34 != 0) {\n            CHECK(emit', 'if (object->flag34 == 0) {\n            CHECK(emit')
m('render-finish-erase-src', 'field', 'emit(out, TQZ_BLIT_BACKGROUND_ERASE, 0, local, view, 0, 0, 0)', 'emit(out, TQZ_BLIT_BACKGROUND_ERASE, 0, view, view, 0, 0, 0)')
m('render-finish-erase-dst', 'field', 'emit(out, TQZ_BLIT_BACKGROUND_ERASE, 0, local, view, 0, 0, 0)', 'emit(out, TQZ_BLIT_BACKGROUND_ERASE, 0, local, local, 0, 0, 0)')
m('render-finish-flag-clear', 'missing-effect', 'object->flag34 = 0;\n        }', '}')
m('render-passed-rect', 'field', 'src[i] = rd_s32(body, B_PASSED_RECT + (size_t)i * 4u);', 'src[i] = rd_s32(body, B_PASSED_RECT + (size_t)((i + 1) % 4) * 4u);')
m('render-passed-x', 'arith', 'dst[0] = sub32(add32(view[0], sub32(view[2], view[0]) / 2), sub32(src[2], src[0]) / 2);', 'dst[0] = sub32(add32(view[0], sub32(view[2], view[0]) / 2), sub32(src[2], src[0]) / 3);')
m('render-passed-x-view', 'arith', 'dst[0] = sub32(add32(view[0], sub32(view[2], view[0]) / 2)', 'dst[0] = sub32(add32(view[0], sub32(view[2], view[0]) / 3)')
m('render-passed-y', 'arith', 'dst[1] = sub32(add32(view[1], sub32(view[3], view[1]) / 2), sub32(src[3], src[1]) / 2);', 'dst[1] = sub32(add32(view[1], sub32(view[3], view[1]) / 2), sub32(src[3], src[1]) / 3);')
m('render-passed-y-view', 'arith', 'dst[1] = sub32(add32(view[1], sub32(view[3], view[1]) / 2)', 'dst[1] = sub32(add32(view[1], sub32(view[3], view[1]) / 3)')
m('render-passed-x2', 'arith', 'dst[2] = add32(dst[0], sub32(src[2], src[0]));', 'dst[2] = add32(dst[0], sub32(src[2], src[0]) + 1);')
m('render-passed-y2', 'arith', 'dst[3] = add32(dst[1], sub32(src[3], src[1]));', 'dst[3] = add32(dst[1], sub32(src[3], src[1]) + 1);')
m('render-passed-kind', 'field', 'emit(out, TQZ_BLIT_PASSED, object->surface, src, dst, 0, 0, 0)', 'emit(out, TQZ_BLIT_BACKGROUND_ERASE, object->surface, src, dst, 0, 0, 0)')
m('render-passed-surface', 'field', 'emit(out, TQZ_BLIT_PASSED, object->surface, src, dst, 0, 0, 0)', 'emit(out, TQZ_BLIT_PASSED, 0, src, dst, 0, 0, 0)')
m('emit-surface', 'field', 'e->surface = surface;', 'e->surface = 0;')
m('emit-src-copy', 'missing-effect', 'if (src != NULL) memcpy(e->src, src, sizeof e->src);', ';')
m('emit-dst-copy', 'missing-effect', 'if (dst != NULL) memcpy(e->dst, dst, sizeof e->dst);', ';')
m('render-widget-score-view', 'field', 'std_render_score(&world->display, view[0], view[1],', 'std_render_score(&world->display, view[1], view[0],')
m('render-widget-clock-view', 'field', 'std_render_clock(&world->display, view[0], view[1],', 'std_render_clock(&world->display, view[1], view[0],')

# ---------------------------------------------------------------------------------------------------------------------------------
# the shared score / time display widget (score_time_display.c)
# ---------------------------------------------------------------------------------------------------------------------------------
s('std-reset-score-enabled', 'missing-effect', 'd->score_enabled = 0;\n    d->score_ready = 0;', 'd->score_ready = 0;')
s('std-reset-score-ready', 'missing-effect', 'd->score_ready = 0;\n    d->score = 0;', 'd->score = 0;')
s('std-reset-score-value', 'missing-effect', 'd->score_ready = 0;\n    d->score = 0;\n    d->score_str[0] = 0;', 'd->score_ready = 0;\n    d->score_str[0] = 0;')
s('std-reset-score-str', 'missing-effect', 'd->score_str[0] = 0;\n    d->prev_score_str[0] = 0;\n    memset(d->score_w', 'd->prev_score_str[0] = 0;\n    memset(d->score_w')
s('std-reset-score-prev', 'missing-effect', 'd->prev_score_str[0] = 0;\n    memset(d->score_w', 'memset(d->score_w')
s('std-reset-score-w', 'missing-effect', 'memset(d->score_w, 0, sizeof d->score_w);', ';')
s('std-reset-score-h', 'missing-effect', 'memset(d->score_h, 0, sizeof d->score_h);', ';')
s('std-reset-score-block', 'missing-effect', 'memset(d->score_block, 0, sizeof d->score_block);\n}', '}')
s('std-reset-clock-enabled', 'missing-effect', 'd->clock_enabled = 0;\n    d->clock_ready = 0;\n    d->colon_w = 0;', 'd->clock_ready = 0;\n    d->colon_w = 0;')
s('std-reset-clock-ready', 'missing-effect', 'd->clock_ready = 0;\n    d->colon_w = 0;', 'd->colon_w = 0;')
s('std-reset-clock-colon-w', 'missing-effect', 'd->colon_w = 0;\n    d->colon_h = 0;', 'd->colon_h = 0;')
s('std-reset-clock-colon-h', 'missing-effect', 'd->colon_h = 0;\n    d->minutes = 0;', 'd->minutes = 0;')
s('std-reset-clock-minutes', 'missing-effect', 'd->minutes = 0;\n    d->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w', 'd->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w')
s('std-reset-clock-seconds', 'missing-effect', 'd->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w', 'd->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w')
s('std-reset-clock-minutes-str', 'missing-effect', 'd->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w', 'd->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w')
s('std-reset-clock-seconds-str', 'missing-effect', 'd->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w', 'd->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w')
s('std-reset-clock-prev-minutes', 'missing-effect', 'd->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w', 'd->prev_seconds_str[0] = 0;\n    memset(d->clock_w')
s('std-reset-clock-prev-seconds', 'missing-effect', 'd->prev_seconds_str[0] = 0;\n    memset(d->clock_w', 'memset(d->clock_w')
s('std-reset-clock-w', 'missing-effect', 'memset(d->clock_w, 0, sizeof d->clock_w);', ';')
s('std-reset-clock-h', 'missing-effect', 'memset(d->clock_h, 0, sizeof d->clock_h);', ';')
s('std-reset-clock-block', 'missing-effect', 'memset(d->clock_block, 0, sizeof d->clock_block);', ';')
s('std-enable-score-value', 'field', 'd->score_enabled = value;', 'd->score_enabled = value != 0;')
s('std-enable-clock-value', 'field', 'd->clock_enabled = value;', 'd->clock_enabled = value != 0;')
s('std-set-score-negative', 'validate', 'if (score < 0 || score > 99999999) return STD_ERR_BOUNDS;', 'if (score > 99999999) return STD_ERR_BOUNDS;')
s('std-set-score-store', 'missing-effect', 'd->score = score;\n    (void)snprintf', '(void)snprintf')
s('std-set-score-format', 'field', '"%d", score', '"%02d", score')
s('std-set-score-string', 'missing-effect', '(void)snprintf(d->score_str, sizeof d->score_str, "%d", score);', ';')
s('std-set-clock-minutes-neg', 'validate', 'if (minutes < 0 || minutes > 99 || seconds < 0 || seconds > 99) return STD_ERR_BOUNDS;', 'if (minutes > 99 || seconds < 0 || seconds > 99) return STD_ERR_BOUNDS;')
s('std-set-clock-seconds-neg', 'validate', 'if (minutes < 0 || minutes > 99 || seconds < 0 || seconds > 99) return STD_ERR_BOUNDS;', 'if (minutes < 0 || minutes > 99 || seconds > 99) return STD_ERR_BOUNDS;')
s('std-set-clock-minutes-max', 'validate', 'minutes > 99 ||', 'minutes > 59 ||')
s('std-set-clock-seconds-max', 'validate', 'seconds > 99) return STD_ERR_BOUNDS;', 'seconds > 59) return STD_ERR_BOUNDS;')
s('std-set-clock-store-minutes', 'missing-effect', 'd->minutes = minutes;\n    d->seconds = seconds;\n    (void)snprintf', 'd->seconds = seconds;\n    (void)snprintf')
s('std-set-clock-store-seconds', 'missing-effect', 'd->seconds = seconds;\n    (void)snprintf', '(void)snprintf')
s('std-set-clock-minutes-format', 'field', '"%02d", minutes', '"%d", minutes')
s('std-set-clock-seconds-format', 'field', '"%02d", seconds', '"%d", seconds')
s('std-set-clock-swap', 'field', '(void)snprintf(d->minutes_str, sizeof d->minutes_str, "%02d", minutes);', '(void)snprintf(d->minutes_str, sizeof d->minutes_str, "%02d", seconds);')
s('std-init-score-copy', 'missing-effect', 'memcpy(d->score_block, block, sizeof d->score_block);', ';')
s('std-init-score-w', 'arith', 'd->score_w[k] = add32(sub32(d->score_block[k * 4 + 2], d->score_block[k * 4]), 1);', 'd->score_w[k] = sub32(d->score_block[k * 4 + 2], d->score_block[k * 4]);')
s('std-init-score-w-index', 'index', 'd->score_w[k] = add32(sub32(d->score_block[k * 4 + 2], d->score_block[k * 4]), 1);', 'd->score_w[k] = add32(sub32(d->score_block[k * 4 + 3], d->score_block[k * 4]), 1);')
s('std-init-score-h', 'arith', 'd->score_h[k] = add32(sub32(d->score_block[k * 4 + 3], d->score_block[k * 4 + 1]), 1);', 'd->score_h[k] = sub32(d->score_block[k * 4 + 3], d->score_block[k * 4 + 1]);')
s('std-init-score-h-index', 'index', 'd->score_h[k] = add32(sub32(d->score_block[k * 4 + 3], d->score_block[k * 4 + 1]), 1);', 'd->score_h[k] = add32(sub32(d->score_block[k * 4 + 2], d->score_block[k * 4 + 1]), 1);')
s('std-init-score-counter', 'missing-effect', 'd->loop_counter = STD_DIGITS;\n    if (host == NULL || host->register_slot == NULL ||\n        host->register_slot(host->context, (int16_t)d->score_block[44]', 'if (host == NULL || host->register_slot == NULL ||\n        host->register_slot(host->context, (int16_t)d->score_block[44]')
s('std-init-score-slot', 'field', 'host->register_slot(host->context, (int16_t)d->score_block[44], d->score_block[45]', 'host->register_slot(host->context, (int16_t)d->score_block[45], d->score_block[44]')
s('std-init-score-surface', 'field', '(uint32_t)d->score_block[43], "SCORE DISPLAY"', '(uint32_t)d->score_block[42], "SCORE DISPLAY"')
s('std-init-score-label', 'constant', '"SCORE DISPLAY"', '"SCORE DISPLAY "')
s('std-init-score-callback', 'field', 'STD_CALLBACK_SCORE,\n', 'STD_CALLBACK_CLOCK,\n')
s('std-init-score-effect', 'field', 'fx(host, STD_FX_INIT_SCORE, d->score_block[44], d->score_block[43]);', 'fx(host, STD_FX_INIT_SCORE, d->score_block[43], d->score_block[44]);')
s('std-init-score-value', 'missing-effect', 'd->score = 0;\n    d->score_str[0] = 0;\n    d->prev_score_str[0] = 0;\n    d->score_enabled = 0;\n    d->score_ready = 1;', 'd->score_str[0] = 0;\n    d->prev_score_str[0] = 0;\n    d->score_enabled = 0;\n    d->score_ready = 1;')
s('std-init-score-str', 'missing-effect', 'd->score_str[0] = 0;\n    d->prev_score_str[0] = 0;\n    d->score_enabled = 0;\n    d->score_ready = 1;', 'd->prev_score_str[0] = 0;\n    d->score_enabled = 0;\n    d->score_ready = 1;')
s('std-init-score-prev', 'missing-effect', 'd->prev_score_str[0] = 0;\n    d->score_enabled = 0;\n    d->score_ready = 1;', 'd->score_enabled = 0;\n    d->score_ready = 1;')
s('std-init-score-enabled', 'missing-effect', 'd->score_enabled = 0;\n    d->score_ready = 1;', 'd->score_ready = 1;')
s('std-init-score-ready', 'missing-effect', 'd->score_ready = 1;\n    return STD_OK;', 'return STD_OK;')
s('std-init-clock-copy', 'missing-effect', 'memcpy(d->clock_block, block, sizeof d->clock_block);', ';')
s('std-init-clock-w', 'arith', 'd->clock_w[k] = add32(sub32(d->clock_block[k * 4 + 2], d->clock_block[k * 4]), 1);', 'd->clock_w[k] = sub32(d->clock_block[k * 4 + 2], d->clock_block[k * 4]);')
s('std-init-clock-h', 'arith', 'd->clock_h[k] = add32(sub32(d->clock_block[k * 4 + 3], d->clock_block[k * 4 + 1]), 1);', 'd->clock_h[k] = sub32(d->clock_block[k * 4 + 3], d->clock_block[k * 4 + 1]);')
s('std-init-clock-colon-w', 'arith', 'd->colon_w = add32(sub32(d->clock_block[42], d->clock_block[40]), 1);', 'd->colon_w = sub32(d->clock_block[42], d->clock_block[40]);')
s('std-init-clock-colon-w-index', 'index', 'd->colon_w = add32(sub32(d->clock_block[42], d->clock_block[40]), 1);', 'd->colon_w = add32(sub32(d->clock_block[43], d->clock_block[40]), 1);')
s('std-init-clock-colon-h', 'arith', 'd->colon_h = add32(sub32(d->clock_block[43], d->clock_block[41]), 1);', 'd->colon_h = sub32(d->clock_block[43], d->clock_block[41]);')
s('std-init-clock-colon-h-index', 'index', 'd->colon_h = add32(sub32(d->clock_block[43], d->clock_block[41]), 1);', 'd->colon_h = add32(sub32(d->clock_block[43], d->clock_block[40]), 1);')
s('std-init-clock-counter', 'missing-effect', 'd->loop_counter = STD_DIGITS;\n    d->colon_w', 'd->colon_w')
s('std-init-clock-slot', 'field', 'host->register_slot(host->context, (int16_t)d->clock_block[48], d->clock_block[49]', 'host->register_slot(host->context, (int16_t)d->clock_block[49], d->clock_block[48]')
s('std-init-clock-surface', 'field', '(uint32_t)d->clock_block[47], "TIME DISPLAY"', '(uint32_t)d->clock_block[46], "TIME DISPLAY"')
s('std-init-clock-label', 'constant', '"TIME DISPLAY"', '"TIME DISPLAY "')
s('std-init-clock-callback', 'field', 'STD_CALLBACK_CLOCK,\n', 'STD_CALLBACK_SCORE,\n')
s('std-init-clock-effect', 'field', 'fx(host, STD_FX_INIT_CLOCK, d->clock_block[48], d->clock_block[47]);', 'fx(host, STD_FX_INIT_CLOCK, d->clock_block[47], d->clock_block[48]);')
s('std-init-clock-minutes', 'missing-effect', 'd->minutes = 0;\n    d->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;', 'd->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;')
s('std-init-clock-seconds', 'missing-effect', 'd->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;', 'd->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;')
s('std-init-clock-strings', 'missing-effect', 'd->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;', 'd->clock_enabled = 0;')
s('std-init-clock-prev-strings', 'missing-effect', 'd->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;', 'd->clock_enabled = 0;')
s('std-init-clock-enabled', 'missing-effect', 'd->clock_enabled = 0;\n    d->clock_ready = 1;', 'd->clock_ready = 1;')
s('std-init-clock-ready', 'missing-effect', 'd->clock_ready = 1;\n    return STD_OK;', 'return STD_OK;')
s('std-digit-low', 'compare', "(ch >= '0' && ch <= '9') ? ch - '0' : -1", "(ch > '0' && ch <= '9') ? ch - '0' : -1")
s('std-digit-high', 'compare', "(ch >= '0' && ch <= '9') ? ch - '0' : -1", "(ch >= '0' && ch < '9') ? ch - '0' : -1")
s('std-digit-rect-left', 'field', 'r[2] = add32(sub32(x, 1), w);', 'r[2] = add32(x, w);')
s('std-digit-rect-bottom', 'field', 'r[3] = add32(sub32(y, 1), h);', 'r[3] = add32(y, h);')
s('std-digit-rect-swap', 'field', 'r[0] = x;\n    r[1] = y;', 'r[0] = y;\n    r[1] = x;')
s('std-erase-src-x', 'field', 'src[0] = sub32(*cx, view_x);\n        src[1] = sub32(y, view_y);', 'src[0] = sub32(*cx, view_y);\n        src[1] = sub32(y, view_x);')
s('std-erase-src-right', 'field', 'src[2] = sub32(dst[2], view_x);\n        src[3] = sub32(dst[3], view_y);', 'src[2] = sub32(dst[2], view_y);\n        src[3] = sub32(dst[3], view_x);', 2, 0)
s('std-erase-surface', 'field', 'push(out, capacity, count, kind, 0, src, dst, d)', 'push(out, capacity, count, kind, 1, src, dst, d)')
s('std-erase-digit', 'field', 'push(out, capacity, count, kind, 0, src, dst, d)', 'push(out, capacity, count, kind, 0, src, dst, 0)')
s('std-erase-advance', 'arith', '*cx = add32(add32(*cx, wd[d]), gap);\n    }\n    return STD_OK;\n}\n\nstatic int draw_string', '*cx = add32(*cx, wd[d]);\n    }\n    return STD_OK;\n}\n\nstatic int draw_string')
s('std-erase-width', 'index', 'digit_rect(*cx, y, wd[d], ht[d], dst);\n        src[0]', 'digit_rect(*cx, y, wd[0], ht[d], dst);\n        src[0]')
s('std-erase-height', 'index', 'digit_rect(*cx, y, wd[d], ht[d], dst);\n        src[0]', 'digit_rect(*cx, y, wd[d], ht[0], dst);\n        src[0]')
s('std-erase-bounds', 'validate', 'if (d < 0) return STD_ERR_BOUNDS;\n        digit_rect(*cx, y, wd[d], ht[d], dst);\n        src[0]', 'if (d < 0) break;\n        digit_rect(*cx, y, wd[d], ht[d], dst);\n        src[0]')
s('std-erase-limit', 'index', 'for (size_t i = 0; prev[i] != 0 && i < STD_STRING_BYTES; ++i) {', 'for (size_t i = 0; prev[i] != 0 && i < STD_STRING_BYTES - 1; ++i) {')
s('std-draw-source', 'index', 'push(out, capacity, count, kind, surface, &rects[d * 4], dst, d)', 'push(out, capacity, count, kind, surface, &rects[d * 4 + 4], dst, d)')
s('std-draw-surface', 'field', 'push(out, capacity, count, kind, surface, &rects[d * 4], dst, d)', 'push(out, capacity, count, kind, 0, &rects[d * 4], dst, d)')
s('std-draw-digit', 'field', 'push(out, capacity, count, kind, surface, &rects[d * 4], dst, d)', 'push(out, capacity, count, kind, surface, &rects[d * 4], dst, 0)')
s('std-draw-advance', 'arith', '*cx = add32(add32(*cx, wd[d]), gap);\n    }\n    return STD_OK;\n}\n\nint std_render_score', '*cx = add32(*cx, wd[d]);\n    }\n    return STD_OK;\n}\n\nint std_render_score')
s('std-draw-width', 'index', 'digit_rect(*cx, y, wd[d], ht[d], dst);\n        if (push(out, capacity, count, kind, surface', 'digit_rect(*cx, y, wd[0], ht[d], dst);\n        if (push(out, capacity, count, kind, surface')
s('std-draw-limit', 'index', 'for (size_t i = 0; cur[i] != 0 && i < STD_STRING_BYTES; ++i) {', 'for (size_t i = 0; cur[i] != 0 && i < STD_STRING_BYTES - 1; ++i) {')
s('std-render-score-gate', 'predicate', 'if (d->score_enabled == 0 || d->score_ready == 0) return STD_OK;', 'if (d->score_enabled == 0) return STD_OK;')
s('std-render-score-ready-gate', 'predicate', 'if (d->score_enabled == 0 || d->score_ready == 0) return STD_OK;', 'if (d->score_ready == 0) return STD_OK;')
s('std-render-score-x', 'field', 'x = d->score_block[40];\n    y = d->score_block[41];', 'x = d->score_block[41];\n    y = d->score_block[40];')
s('std-render-score-changed', 'predicate', 'if (strncmp(d->score_str, d->prev_score_str, STD_STRING_BYTES) != 0) {', 'if (strncmp(d->score_str, d->prev_score_str, STD_STRING_BYTES) == 0) {')
s('std-render-score-always-erase', 'predicate', 'if (strncmp(d->score_str, d->prev_score_str, STD_STRING_BYTES) != 0) {', 'if (1) {')
s('std-render-score-gap', 'field', 'd->score_block[42], &cx, y, view_x, view_y,\n                              STD_BLIT_SCORE_ERASE', 'd->score_block[41], &cx, y, view_x, view_y,\n                              STD_BLIT_SCORE_ERASE')
s('std-render-score-draw-gap', 'field', 'd->score_block, d->score_block[42], &cx, y,\n                             (uint32_t)d->score_block[43]', 'd->score_block, d->score_block[41], &cx, y,\n                             (uint32_t)d->score_block[43]')
s('std-render-score-surface', 'field', '(uint32_t)d->score_block[43], STD_BLIT_SCORE_DIGIT', '(uint32_t)d->score_block[42], STD_BLIT_SCORE_DIGIT')
s('std-render-score-erase-kind', 'field', 'STD_BLIT_SCORE_ERASE, out', 'STD_BLIT_SCORE_DIGIT, out')
s('std-render-score-prev-copy', 'missing-effect', 'memcpy(d->prev_score_str, d->score_str, STD_STRING_BYTES);', ';')
s('std-render-score-prev-copy-length', 'index', 'memcpy(d->prev_score_str, d->score_str, STD_STRING_BYTES);', 'memcpy(d->prev_score_str, d->score_str, STD_STRING_BYTES - 1);')
s('std-render-score-compare-length', 'index', 'strncmp(d->score_str, d->prev_score_str, STD_STRING_BYTES) != 0', 'strncmp(d->score_str, d->prev_score_str, 1) != 0')
s('std-render-clock-enabled-gate', 'predicate', 'if (d->clock_enabled == 0 || d->clock_ready == 0) return STD_OK;', 'if (d->clock_enabled == 0) return STD_OK;')
s('std-render-clock-ready-gate', 'predicate', 'if (d->clock_enabled == 0 || d->clock_ready == 0) return STD_OK;', 'if (d->clock_ready == 0) return STD_OK;')
s('std-render-clock-origin', 'field', 'const int32_t x = d->clock_block[44], y = d->clock_block[45], gap = d->clock_block[46];', 'const int32_t x = d->clock_block[45], y = d->clock_block[44], gap = d->clock_block[46];')
s('std-render-clock-gap', 'field', 'y = d->clock_block[45], gap = d->clock_block[46];', 'y = d->clock_block[45], gap = d->clock_block[45];')
s('std-render-clock-surface', 'field', 'const uint32_t surface = (uint32_t)d->clock_block[47];', 'const uint32_t surface = (uint32_t)d->clock_block[46];')
s('std-render-clock-colon-y', 'arith', 'colon_y = add32(y, half(sub32(d->clock_h[0], d->colon_h)));', 'colon_y = add32(y, sub32(d->clock_h[0], d->colon_h));')
s('std-render-clock-colon-y-digit', 'index', 'colon_y = add32(y, half(sub32(d->clock_h[0], d->colon_h)));', 'colon_y = add32(y, half(sub32(d->clock_h[1], d->colon_h)));')
s('std-render-clock-colon-y-sign', 'arith', 'colon_y = add32(y, half(sub32(d->clock_h[0], d->colon_h)));', 'colon_y = add32(y, half(sub32(d->colon_h, d->clock_h[0])));')
s('std-render-clock-changed', 'predicate', 'strncmp(d->minutes_str, d->prev_minutes_str, STD_STRING_BYTES) != 0 ||\n        strncmp(d->seconds_str, d->prev_seconds_str, STD_STRING_BYTES) != 0) {', 'strncmp(d->minutes_str, d->prev_minutes_str, STD_STRING_BYTES) != 0 &&\n        strncmp(d->seconds_str, d->prev_seconds_str, STD_STRING_BYTES) != 0) {')
s('std-render-clock-changed-minutes-only', 'predicate', 'strncmp(d->minutes_str, d->prev_minutes_str, STD_STRING_BYTES) != 0 ||\n        strncmp(d->seconds_str, d->prev_seconds_str, STD_STRING_BYTES) != 0) {', 'strncmp(d->minutes_str, d->prev_minutes_str, STD_STRING_BYTES) != 0) {')
s('std-render-clock-changed-seconds-only', 'predicate', 'strncmp(d->minutes_str, d->prev_minutes_str, STD_STRING_BYTES) != 0 ||\n        strncmp(d->seconds_str, d->prev_seconds_str, STD_STRING_BYTES) != 0) {', 'strncmp(d->seconds_str, d->prev_seconds_str, STD_STRING_BYTES) != 0) {')
s('std-render-clock-erase-minutes-kind', 'field', 'STD_BLIT_CLOCK_ERASE_MIN', 'STD_BLIT_CLOCK_ERASE_SEC')
s('std-render-clock-erase-seconds-kind', 'field', 'STD_BLIT_CLOCK_ERASE_SEC, out', 'STD_BLIT_CLOCK_ERASE_MIN, out')
s('std-render-clock-erase-minutes-string', 'field', 'rc = erase_string(d->prev_minutes_str,', 'rc = erase_string(d->prev_seconds_str,')
s('std-render-clock-erase-seconds-string', 'field', 'rc = erase_string(d->prev_seconds_str,', 'rc = erase_string(d->prev_minutes_str,')
s('std-render-clock-erase-colon-x', 'field', 'dst[0] = cx;\n        dst[1] = colon_y;\n        dst[2] = add32(sub32(cx, 1), d->colon_w);\n        dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n        src[0]', 'dst[0] = cx;\n        dst[1] = colon_y;\n        dst[2] = add32(cx, d->colon_w);\n        dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n        src[0]')
s('std-render-clock-erase-colon-bottom', 'field', 'dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n        src[0]', 'dst[3] = add32(dst[1], d->colon_h);\n        src[0]')
s('std-render-clock-erase-colon-src', 'field', 'src[0] = sub32(cx, view_x);\n        src[1] = sub32(dst[1], view_y);', 'src[0] = sub32(cx, view_y);\n        src[1] = sub32(dst[1], view_x);')
s('std-render-clock-erase-colon-src-right', 'field', 'src[2] = sub32(dst[2], view_x);\n        src[3] = sub32(dst[3], view_y);\n        if (push(out, capacity, count, STD_BLIT_CLOCK_ERASE_COLON', 'src[2] = sub32(dst[2], view_y);\n        src[3] = sub32(dst[3], view_x);\n        if (push(out, capacity, count, STD_BLIT_CLOCK_ERASE_COLON')
s('std-render-clock-erase-colon-kind', 'field', 'STD_BLIT_CLOCK_ERASE_COLON, 0, src, dst, 0', 'STD_BLIT_CLOCK_ERASE_MIN, 0, src, dst, 0')
s('std-render-clock-erase-colon-advance', 'arith', 'cx = add32(add32(cx, d->colon_w), gap);\n        rc = erase_string', 'cx = add32(cx, d->colon_w);\n        rc = erase_string')
s('std-render-clock-draw-minutes-string', 'field', 'rc = draw_string(d->minutes_str,', 'rc = draw_string(d->seconds_str,')
s('std-render-clock-draw-seconds-string', 'field', 'rc = draw_string(d->seconds_str,', 'rc = draw_string(d->minutes_str,')
s('std-render-clock-draw-min-kind', 'field', 'surface, STD_BLIT_CLOCK_MIN, out', 'surface, STD_BLIT_CLOCK_SEC, out')
s('std-render-clock-draw-sec-kind', 'field', 'surface, STD_BLIT_CLOCK_SEC, out', 'surface, STD_BLIT_CLOCK_MIN, out')
s('std-render-clock-colon-source', 'index', '&d->clock_block[40], dst, 0)', '&d->clock_block[44], dst, 0)')
s('std-render-clock-colon-kind', 'field', 'STD_BLIT_CLOCK_COLON, surface', 'STD_BLIT_CLOCK_MIN, surface')
s('std-render-clock-colon-surface', 'field', 'STD_BLIT_CLOCK_COLON, surface', 'STD_BLIT_CLOCK_COLON, 0')
s('std-render-clock-colon-x', 'arith', 'dst[2] = add32(sub32(cx, 1), d->colon_w);\n    dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n    if (push(out, capacity, count, STD_BLIT_CLOCK_COLON', 'dst[2] = add32(cx, d->colon_w);\n    dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n    if (push(out, capacity, count, STD_BLIT_CLOCK_COLON')
s('std-render-clock-colon-advance', 'arith', 'cx = add32(add32(cx, d->colon_w), gap);\n    rc = draw_string', 'cx = add32(cx, d->colon_w);\n    rc = draw_string')
s('std-render-clock-prev-minutes', 'missing-effect', 'memcpy(d->prev_minutes_str, d->minutes_str, STD_STRING_BYTES);', ';')
s('std-render-clock-prev-seconds', 'missing-effect', 'memcpy(d->prev_seconds_str, d->seconds_str, STD_STRING_BYTES);', ';')

# Mutants proved equivalent by reading the code and the original: they cannot change any observable behaviour in a state a loader-built
# body or a game path produces, so a surviving run is the expected result. They are reported separately and never count as killed.
EQUIVALENT = {
    'clock-minutes-clamp-test': 'minutes >= 0x3b and minutes > 0x3b differ only at minutes == 0x3b, where the clamp stores the same value 0x3b',
    'clock-seconds-clamp-test': 'seconds >= 0x3b and seconds > 0x3b differ only at seconds == 0x3b, where the clamp stores the same value 0x3b',
    'char-digits-gate': 'the digit test is only reached for characters drawn as 0x41 + r % span (letters-only mode) which are never below 0x41, so a digit is never drawn when the digit flag is off; with the flag on the gate is true',
    'p0-target-low-test': 'when the target equals the low bound the assignment stores the same value; the two predicates differ only in a no-op store',
    'cleanup-surface-clear': 'the reset block that follows stores surface := 0 again, so the first store is shadowed',
    'std-enable-score-value': 'the enable setter is only called with 0 or 1, for which value and value != 0 coincide',
    'std-enable-clock-value': 'the enable setter is only called with 0 or 1, for which value and value != 0 coincide',
    'std-init-score-counter': 'the loop counter is stored again by the clock init (std_init_clock) later in the same visit; the final image is identical',
    'std-init-clock-counter': 'the loop counter is stored by the score init earlier in the same visit; the final image is identical',
    'std-init-score-value': 'std_set_score (always called right after the init in phase 0) stores the score again',
    'std-init-score-str': 'std_set_score stores the score string right after the init',
    'std-init-score-enabled': 'std_enable_score(1) is called right after the init in phase 0',
    'std-init-clock-minutes': 'std_set_clock stores minutes right after the init in phase 0',
    'std-init-clock-seconds': 'std_set_clock stores seconds right after the init in phase 0',
    'std-init-clock-enabled': 'std_enable_clock(1) is called right after the init in phase 0',
    'std-erase-digit': 'the digit index of an erase blit is an annotation of the kernel list; the original blit carries only the rectangles (compared)',
    'score-grouping': '(h/f)/s versus h/(f*s) differ by at most one double ulp (1e-16 relative); the 24-bit float store that follows absorbs it except for a probability of order 1e-9 per sample (3 million random samples: 0 differences)',
    'score-scale-first': 'same as score-grouping (h*60)/(f*s): double-ulp difference absorbed by the float store (3 million samples: 0 differences)',
    'score-seconds-float': 'the seconds operand is elapsed/1000 <= 4294967 < 2^24, exactly representable as a float, so the float rounding is the identity',
    'ftol-range-low': 'differs from the kernel only for v == -2^63 exactly, which the integer indefinite value INT64_MIN equals anyway '
                      '(the cast gives the same 64-bit value); no operand of the formula can reach |v| >= 2^63 (hits <= 2^31, factor >= 1)',
    'ftol-range-skipped': 'the range test only matters for |v| >= 2^63 (hits <= 2^31 multiplied by 60 and divided by at least 1 stays below 2^37): '
                          'no reachable operand; the cast of an in-range double is identical',
    'score-hits-signed': 'o->hits is a count of hits (0..a few thousand in any play; the formula operand is hits < 2^31): the signed and unsigned '
                         'conversions of a non-negative 32-bit value are identical; only a negative hit count (corrupted object) differs',
    'std-set-clock-minutes-max': 'the kernel never passes minutes above 59 (clock_update clamps at 0x3b); the bounds of the widget setter '
                                 '(0..99) are native-only protection of the ten-byte string; 59 and 99 are indistinguishable from any reachable call',
    'std-set-clock-seconds-max': 'same as std-set-clock-minutes-max for seconds (clamped at 0x3b by clock_update)',
    'std-set-score-negative': 'a negative score reaches std_set_score only through the 16-bit wrap of the score formula, which the oracle refuses (K4); '
                              'the refusal check score_wrap_negative covers it when the driver reaches it - see the refusal checks',
    'std-set-clock-minutes-neg': 'clock_update clamps minutes to >= 0 before the setter, so a negative value is unreachable',
    'std-set-clock-seconds-neg': 'clock_update clamps seconds to >= 0 before the setter, so a negative value is unreachable',
    'clock-seconds-floor': 'when seconds < 0 only for remaining < 0 with minutes also negative the next clamp (minutes < 0 -> 0) and the stored seconds '
                           'reach the setter in the same call; the boundary -1 vs 0 is observable only for seconds == -1, which needs remaining == -1 + 60 * minutes '
                           'with minutes == 0: the sole such state is remaining == -1; see the survivors report',
    'std-erase-bounds': 'the erase of a previous string with a non-digit is a K4 native refusal the oracle never feeds (the widget strings it produces are digits)',
    'std-erase-limit': 'the previous strings are at most 8 digits (score <= 32767 -> 5 digits, clock 2 digits); the ten-byte buffer limit is never reached',
    'std-draw-limit': 'the current strings are at most 5 digits (score <= 32767) or 2 digits (clock); the ten-byte buffer limit is never reached',
    'std-render-score-prev-copy-length': 'the ninth-byte copy differs only in the last byte of the ten-byte string, which holds NUL for every digit string '
                                         'the widget produces (<= 5 digits); the K8 dead bytes are compared separately',
}


def apply(text, old, new, count, which):
    n = text.count(old)
    if n != count:
        raise ValueError('site found %d times, expected %d' % (n, count))
    pos = -1
    for _ in range(which + 1):
        pos = text.index(old, pos + 1)
    return text[:pos] + new + text[pos + len(old):]


def run_oracle(src_dir, quick, result, workers=1):
    cmd = [sys.executable, str(ORACLE), '--src', str(src_dir), '--workers', str(workers), '--result', str(result), '--fail-fast', '--lenient-build']
    if quick:
        cmd.append('--quick-only')
    done = subprocess.run(cmd, capture_output=True, text=True, cwd=str(HERE))
    first = next((l for l in done.stdout.splitlines() if l.startswith('MISMATCH')), None)
    if 'driver build failed' in done.stderr or 'driver build failed' in done.stdout:
        return 'INVALID', 'does not build: ' + (done.stderr or done.stdout)[-300:].replace('\n', ' ')
    if done.returncode == 0:
        return 'SURVIVED', None
    if first is not None:
        return 'KILLED', first[:240]
    return 'ERROR', (done.stderr or done.stdout)[-400:].replace('\n', ' ')


def one(args):
    name, f, cls, old, new, count, which, texts, work, stage = args
    d = work / name
    d.mkdir()
    for h in HEADERS:
        shutil.copy(PROJECT / 'src' / h, d / h)
    for key, fname in KERNELS.items():
        (d / fname).write_text(texts[key])
    row = dict(name=name, cls=cls, file=KERNELS[f])
    try:
        mutated = apply(texts[f], old, new, count, which)
    except ValueError as e:
        row.update(verdict='INVALID', detail=str(e))
        return row
    (d / KERNELS[f]).write_text(mutated)
    verdict, detail = run_oracle(d, stage != 'full', d / 'result.json')
    row['stage'] = 'quick' if stage != 'full' else 'full'
    if verdict == 'SURVIVED' and stage != 'full':
        verdict, detail = run_oracle(d, False, d / 'result_full.json', workers=2)
        row['stage'] = 'full'
    row.update(verdict=verdict, detail=detail)
    return row


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--stage', choices=('quick', 'full'), default='quick')
    ap.add_argument('--only')
    ap.add_argument('--names', help='comma separated exact mutant names (re-run of a subset, e.g. earlier survivors)')
    ap.add_argument('--jobs', type=int, default=min(4, os.cpu_count() or 1))
    ap.add_argument('--result', type=Path)
    ap.add_argument('--check-sites', action='store_true', help='only verify that every edit site is found the stated number of times')
    a = ap.parse_args()
    texts = {key: (PROJECT / 'src' / fname).read_text() for key, fname in KERNELS.items()}
    mutants = [t for t in M if t is not None]
    if a.check_sites:
        bad = 0
        for name, f, cls, old, new, count, which in mutants:
            try:
                apply(texts[f], old, new, count, which)
                if old == new:
                    raise ValueError('the edit changes nothing')
            except ValueError as e:
                print('SITE', name, e)
                bad += 1
        names = [t[0] for t in mutants]
        print('mutants', len(mutants), 'bad sites', bad, 'duplicate names', len(names) - len(set(names)))
        return 1 if bad else 0
    work = Path(tempfile.mkdtemp(prefix='f5_mut_', dir=str(PROJECT.parent.parent / 'work' / 'rt55')))
    t0 = time.monotonic()
    todo = [(name, f, cls, old, new, count, which, texts, work, a.stage) for name, f, cls, old, new, count, which in mutants
            if (not a.only or a.only in name) and (not a.names or name in a.names.split(','))]
    names = [t[0] for t in todo]
    if len(set(names)) != len(names):
        raise SystemExit('duplicate mutant names')
    rows = []
    with ThreadPoolExecutor(max_workers=a.jobs) as pool:
        for row in pool.map(one, todo):
            rows.append(row)
            print(row['name'], row['verdict'], row.get('stage', ''), (row.get('detail') or '')[:160], flush=True)
    for r in rows:
        if r['verdict'] == 'SURVIVED' and r['name'] in EQUIVALENT:
            r['verdict'] = 'EQUIVALENT'
            r['reason'] = EQUIVALENT[r['name']]
    killed = sum(1 for r in rows if r['verdict'] == 'KILLED')
    counted = sum(1 for r in rows if r['verdict'] in ('KILLED', 'SURVIVED'))
    out = dict(mutants_total=len(rows), counted=counted, killed=killed, kill_rate=round(killed / counted, 4) if counted else None,
               survived=[r['name'] for r in rows if r['verdict'] == 'SURVIVED'],
               invalid=[r['name'] for r in rows if r['verdict'] in ('INVALID', 'ERROR')],
               equivalent=[dict(name=r['name'], reason=r['reason']) for r in rows if r['verdict'] == 'EQUIVALENT'], rows=rows,
               seconds=round(time.monotonic() - t0, 1))
    out['source_sha256'] = {fname: hashlib.sha256((PROJECT / 'src' / fname).read_bytes()).hexdigest() for fname in KERNELS.values()}
    out['mutation_script_sha256'] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    print(json.dumps({k: v for k, v in out.items() if k != 'rows'}, indent=1))
    if a.result:
        a.result.parent.mkdir(parents=True, exist_ok=True)
        a.result.write_text(json.dumps(out, indent=1, sort_keys=True))
    return 0 if not out['survived'] and not out['invalid'] else 1  # equivalent mutants do not fail the check


if __name__ == '__main__':
    sys.exit(main())
