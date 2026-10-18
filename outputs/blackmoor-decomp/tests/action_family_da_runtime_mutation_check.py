#!/usr/bin/env python3
"""RT-59 mutation check for the raw-0xda oracle (Bul puzzle runtime).

Every mutant is a one-site textual edit of a COPY of src/action_family_da_runtime.c (the project files are never touched). Each mutant is
built into a driver library and run through the original-x86 oracle (action_family_da_runtime_original_oracle.py, `--src DIR`). A mutant is
KILLED when the oracle reports at least one mismatch against the unmodified GAME.EXE image (or one of its native-only refusal checks fails);
it SURVIVES when the oracle still reports 0 mismatches; it is INVALID if it does not compile or the edit site is not found the stated
number of times (invalid mutants never count as killed).

Usage:  python3 action_family_da_runtime_mutation_check.py [--stage quick|full] [--only NAME] [--names A,B] [--jobs N] [--result FILE]
                                                            [--check-sites]
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
ORACLE = HERE / 'action_family_da_runtime_original_oracle.py'
KERNELS = {'da': 'action_family_da_runtime.c'}
HEADERS = ('action_family_da_runtime.h',)

# (name, file, class, old text, new text, expected occurrences of old text, index of the occurrence to edit)
M = []


def m(name, cls, old, new, count=1, which=0, f='da'):
    M.append((name, f, cls, old, new, count, which))


# ---------------------------------------------------------------------------------------------------------------------------------
# helpers: no_sound, real_name, body_rect, tick, rand, play, busy, prepare, stop, reset
# ---------------------------------------------------------------------------------------------------------------------------------
m('nosound-8-bytes', 'compare', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8) == 0;')
m('nosound-case', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'n', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}")
m('nosound-last-char', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'E', 0}")
m('nosound-space', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', '_', 'S', 'O', 'U', 'N', 'D', 0}")
m('nosound-inverted', 'predicate', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k) != 0;')
m('realname-empty-test', 'predicate', 'return !no_sound(name) && name[0] != 0;', 'return !no_sound(name);')
m('realname-nosound-test', 'predicate', 'return !no_sound(name) && name[0] != 0;', 'return name[0] != 0;')
m('realname-or', 'predicate', 'return !no_sound(name) && name[0] != 0;', 'return !no_sound(name) || name[0] != 0;')
m('bodyrect-lower-bound', 'validate', 'if (index < lo || index >= hi) {', 'if (index < lo + 1 || index >= hi) {')
m('bodyrect-upper-bound', 'validate', 'if (index < lo || index >= hi) {', 'if (index < lo || index > hi) {')
m('bodyrect-stride', 'arith', '(int64_t)index * 16));', '(int64_t)index * 17));')
m('tick-effect-missing', 'missing-effect', 'fx(c, BUL_FX_TICK, (int32_t)*out, 0);', ';')
m('tick-effect-value', 'field', 'fx(c, BUL_FX_TICK, (int32_t)*out, 0);', 'fx(c, BUL_FX_TICK, (int32_t)*out + 1, 0);')
m('rand-effect-missing', 'missing-effect', 'fx(c, BUL_FX_RANDOM, v, 0);', ';')
m('rand-upper-bound', 'validate', 'if (v < 0 || v > 32767) {', 'if (v < 0 || v > 32766) {')
m('rand-lower-bound', 'validate', 'if (v < 0 || v > 32767) {', 'if (v < -1 || v > 32767) {')
m('rand-result', 'field', '    *out = v;\n    return BUL_OK;', '    *out = v ^ 1;\n    return BUL_OK;')
m('play-effect-channel', 'field', 'fx(c, BUL_FX_SOUND_PLAY, channel, 0);', 'fx(c, BUL_FX_SOUND_PLAY, channel ^ 1, 0);')
m('play-host-channel', 'field', 'HOST(c, c->host->sound_play(c->host->context, channel));',
  'HOST(c, c->host->sound_play(c->host->context, (int16_t)(channel + 1)));')
m('play-effect-missing', 'missing-effect', 'fx(c, BUL_FX_SOUND_PLAY, channel, 0);', ';')
m('busy-inverted', 'predicate', '*out = c->host->sound_busy(c->host->context, channel) != 0;', '*out = c->host->sound_busy(c->host->context, channel) == 0;')
m('busy-effect-value', 'field', 'fx(c, BUL_FX_SOUND_BUSY, channel, *out);', 'fx(c, BUL_FX_SOUND_BUSY, channel, !*out);')
m('busy-effect-channel', 'field', 'fx(c, BUL_FX_SOUND_BUSY, channel, *out);', 'fx(c, BUL_FX_SOUND_BUSY, channel + 1, *out);')
m('busy-effect-missing', 'missing-effect', 'fx(c, BUL_FX_SOUND_BUSY, channel, *out);', ';')
m('playifidle-inverted', 'predicate', 'if (!is_busy) CHECK(play(c, channel));', 'if (is_busy) CHECK(play(c, channel));')
m('playifidle-always', 'predicate', 'if (!is_busy) CHECK(play(c, channel));', 'CHECK(play(c, channel));')
m('prepare-nosound-gate-inverted', 'predicate', 'if (!no_sound(c->body + off)) {', 'if (no_sound(c->body + off)) {', 2, 0)
m('stop-nosound-gate-inverted', 'predicate', 'if (!no_sound(c->body + off)) {', 'if (no_sound(c->body + off)) {', 2, 1)
m('prepare-always', 'predicate', 'if (!no_sound(c->body + off)) {', 'if (1) {', 2, 0)
m('stop-always', 'predicate', 'if (!no_sound(c->body + off)) {', 'if (1) {', 2, 1)
m('prepare-effect-offset', 'field', 'fx(c, BUL_FX_SOUND_PREPARE, (int32_t)off, 0);', 'fx(c, BUL_FX_SOUND_PREPARE, (int32_t)off + 1, 0);')
m('stop-effect-offset', 'field', 'fx(c, BUL_FX_SOUND_STOP, (int32_t)off, 0);', 'fx(c, BUL_FX_SOUND_STOP, (int32_t)off + 1, 0);')
m('prepare-effect-missing', 'missing-effect', 'fx(c, BUL_FX_SOUND_PREPARE, (int32_t)off, 0);', ';')
m('stop-effect-missing', 'missing-effect', 'fx(c, BUL_FX_SOUND_STOP, (int32_t)off, 0);', ';')
m('reset-slot', 'field', 'object->slot = BUL_NO_SLOT;\n    object->row = -1;', 'object->slot = 0;\n    object->row = -1;')
m('reset-row', 'field', 'object->slot = BUL_NO_SLOT;\n    object->row = -1;', 'object->slot = BUL_NO_SLOT;\n    object->row = 0;')

# ---------------------------------------------------------------------------------------------------------------------------------
# bul_validate_body
# ---------------------------------------------------------------------------------------------------------------------------------
m('validate-length-long', 'validate', 'if (body == NULL || length != BUL_BODY_BYTES) {', 'if (body == NULL || length < BUL_BODY_BYTES) {')
m('validate-length-short', 'validate', 'if (body == NULL || length != BUL_BODY_BYTES) {', 'if (body == NULL || length > BUL_BODY_BYTES) {')
m('validate-name-span', 'validate', 'memchr(body + B_SURFACE_NAME, 0, BUL_NAME_BYTES) == NULL', 'memchr(body + B_SURFACE_NAME, 0, BUL_NAME_BYTES - 1) == NULL')
m('validate-name-no-test', 'validate', '} else if (memchr(body + B_SURFACE_NAME, 0, BUL_NAME_BYTES) == NULL) {', '} else if (0) {')
m('validate-sound-count', 'validate', 'for (size_t i = 0; i < 4 && !bad; ++i) {', 'for (size_t i = 0; i < 3 && !bad; ++i) {')
m('validate-sound-span', 'validate', 'BUL_B_SOUND_RECORD_BYTES, 0, BUL_NAME_BYTES) == NULL) bad = 1;', 'BUL_B_SOUND_RECORD_BYTES, 0, BUL_NAME_BYTES - 1) == NULL) bad = 1;')
m('validate-caption-entries', 'validate', 'for (size_t e = 0; e < 2 && !bad; ++e) {', 'for (size_t e = 0; e < 1 && !bad; ++e) {')
m('validate-caption-names', 'validate', 'for (size_t i = 0; i < NAMES_PER_ENTRY && !bad; ++i) {', 'for (size_t i = 0; i < NAMES_PER_ENTRY - 1 && !bad; ++i) {')
m('validate-caption-first', 'validate', 'NAME_FIRST = 0x06', 'NAME_FIRST = 0x07')
m('validate-caption-span', 'validate', '                           BUL_NAME_BYTES) == NULL) {\n                    bad = 1;', '                           BUL_NAME_BYTES - 1) == NULL) {\n                    bad = 1;')
m('validate-positions-low', 'validate', 'rd_s16(body, BUL_B_POSITIONS) < 1 || rd_s16(body, BUL_B_POSITIONS) > BUL_MAX_POSITIONS',
  'rd_s16(body, BUL_B_POSITIONS) < 0 || rd_s16(body, BUL_B_POSITIONS) > BUL_MAX_POSITIONS')
m('validate-positions-high', 'validate', 'rd_s16(body, BUL_B_POSITIONS) < 1 || rd_s16(body, BUL_B_POSITIONS) > BUL_MAX_POSITIONS',
  'rd_s16(body, BUL_B_POSITIONS) < 1 || rd_s16(body, BUL_B_POSITIONS) >= BUL_MAX_POSITIONS')
m('validate-pieces-low', 'validate', 'rd_s16(body, BUL_B_PIECES) < 1 || rd_s16(body, BUL_B_PIECES) > BUL_MAX_PIECES',
  'rd_s16(body, BUL_B_PIECES) < 0 || rd_s16(body, BUL_B_PIECES) > BUL_MAX_PIECES')
m('validate-pieces-high', 'validate', 'rd_s16(body, BUL_B_PIECES) < 1 || rd_s16(body, BUL_B_PIECES) > BUL_MAX_PIECES',
  'rd_s16(body, BUL_B_PIECES) < 1 || rd_s16(body, BUL_B_PIECES) >= BUL_MAX_PIECES')
m('validate-start-player-low', 'validate', 'rd_s16(body, BUL_B_START_PLAYER) < 1 ||', 'rd_s16(body, BUL_B_START_PLAYER) < 0 ||')
m('validate-start-player-high', 'validate', 'rd_s16(body, BUL_B_START_PLAYER) > rd_s16(body, BUL_B_POSITIONS) ||',
  'rd_s16(body, BUL_B_START_PLAYER) >= rd_s16(body, BUL_B_POSITIONS) ||')
m('validate-start-computer-low', 'validate', 'rd_s16(body, BUL_B_START_COMPUTER) < 1 ||', 'rd_s16(body, BUL_B_START_COMPUTER) < 0 ||')
m('validate-start-computer-high', 'validate', 'rd_s16(body, BUL_B_START_COMPUTER) > rd_s16(body, BUL_B_POSITIONS)) {',
  'rd_s16(body, BUL_B_START_COMPUTER) >= rd_s16(body, BUL_B_POSITIONS)) {')
m('copy-name-terminator', 'arith', 'memcpy(dst, src, n + 1u);', 'memcpy(dst, src, n);')

# ---------------------------------------------------------------------------------------------------------------------------------
# caption_pick 0x45be7f
# ---------------------------------------------------------------------------------------------------------------------------------
m('cap-entry-range', 'validate', 'if (entry < 0 || entry > 1 || count > 10) {', 'if (entry < 0 || entry > 0 || count > 10) {')
m('cap-count-range', 'validate', 'if (entry < 0 || entry > 1 || count > 10) {', 'if (entry < 0 || entry > 1 || count > 3) {')
m('cap-channel-source', 'field', 'o->cap_channel = rd_s16(body, e);', 'o->cap_channel = rd_s16(body, e + 2);')
m('cap-1a7', 'field', 'o->cap_1a7 = 2;', 'o->cap_1a7 = 3;')
m('cap-1a9', 'field', 'o->cap_1a9 = 1;', 'o->cap_1a9 = 0;')
m('cap-1ab', 'field', 'o->cap_1ab = 1;', 'o->cap_1ab = 0;')
m('cap-1ad', 'field', 'o->cap_1ad = 1;', 'o->cap_1ad = 0;')
m('cap-1b1-source', 'field', 'o->cap_1b1 = rd_s16(body, e + 2);', 'o->cap_1b1 = rd_s16(body, e + 4);')
m('cap-1b3-source', 'field', 'o->cap_1b3 = rd_s16(body, e + 4);', 'o->cap_1b3 = rd_s16(body, e + 2);')
m('cap-single-test', 'predicate', 'if (count < 2) {', 'if (count < 1) {')
m('cap-single-realname', 'predicate', 'if (real_name(body + names)) {', 'if (body[names] != 0) {')
m('cap-single-copy', 'missing-effect', 'copy_name(o->sound_name, body + names);', ';')
m('cap-pick-limit', 'validate', 'if (++draws > BUL_PICK_LIMIT) {', 'if (++draws > 1) {')
m('cap-pick-index', 'arith', 'idx = (int16_t)(r % count);', 'idx = (int16_t)((r >> 1) % count);')
m('cap-pick-copy', 'missing-effect', 'copy_name(o->sound_name, buf);', ';')
m('cap-pick-tracked', 'missing-effect', 'tracked[idx] = 1;', ';')
m('cap-pick-done-test', 'predicate', 'if (tracked[k] == 0) done = 0;', 'if (tracked[k] != 0) done = 0;')
m('cap-pick-done-bound', 'arith', 'for (int16_t k = 0; k < count; ++k) {', 'for (int16_t k = 0; k < count - 1; ++k) {')
m('cap-prepare-effect-missing', 'missing-effect', 'fx(c, BUL_FX_SOUND_PREPARE, BUL_NO_OFFSET, 0);', ';')
m('cap-prepare-effect-offset', 'field', 'fx(c, BUL_FX_SOUND_PREPARE, BUL_NO_OFFSET, 0);', 'fx(c, BUL_FX_SOUND_PREPARE, 0, 0);')
m('cap-play-channel', 'field', 'CHECK(play(c, o->cap_channel));', 'CHECK(play(c, o->cap_1b1));')
m('cap-play-missing', 'missing-effect', 'CHECK(play(c, o->cap_channel));', ';')
m('cap-text-effect', 'field', 'fx(c, BUL_FX_CAPTION_TEXT, text != NULL, 0);', 'fx(c, BUL_FX_CAPTION_TEXT, text != NULL && text[0] != 0, 0);')
m('cap-text-effect-missing', 'missing-effect', 'fx(c, BUL_FX_CAPTION_TEXT, text != NULL, 0);', ';')
m('cap-limit-test', 'validate', 'if (len <= BUL_CAPTION_LIMIT) {', 'if (len < BUL_CAPTION_LIMIT) {')
m('cap-max-test', 'validate', 'if (len > BUL_CAPTION_MAX) {', 'if (len >= BUL_CAPTION_MAX) {')
m('cap-suffix', 'field', 'memcpy(buf + len, "<e>", 4);', 'memcpy(buf + len, "<f>", 4);')
m('cap-show-effect', 'field', 'fx(c, BUL_FX_CAPTION_SHOW, (int32_t)strlen(buf), 0);', 'fx(c, BUL_FX_CAPTION_SHOW, (int32_t)len, 0);')
m('cap-show-effect-missing', 'missing-effect', 'fx(c, BUL_FX_CAPTION_SHOW, (int32_t)strlen(buf), 0);', ';')
m('cap-state', 'field', 'o->state = BUL_STATE_CAPTION_WAIT;', 'o->state = BUL_STATE_IDLE;')
m('cap-found', 'field', '    *found = got;\n    return BUL_OK;', '    *found = 0;\n    return BUL_OK;')

# ---------------------------------------------------------------------------------------------------------------------------------
# reset_work 0x45ba0b, pick_moves 0x45bbd8, score_check 0x45bda7, step_check 0x45bcc1
# ---------------------------------------------------------------------------------------------------------------------------------
m('reset-roll-a-source', 'field', 'rd_rect(&o->roll_a[i], body, BUL_B_WORK_SRC + (size_t)i * B_WORK_STRIDE);', 'rd_rect(&o->roll_a[i], body, BUL_B_WORK_SRC + (size_t)i * 16u);')
m('reset-roll-b-source', 'field', 'rd_rect(&o->roll_b[i], body, BUL_B_WORK_SRC + (size_t)i * B_WORK_STRIDE);', 'rd_rect(&o->roll_b[i], body, BUL_B_WORK_SRC + (size_t)i * B_WORK_STRIDE + 16u);')
m('reset-work-stride', 'field', 'B_WORK_STRIDE = 0x20,', 'B_WORK_STRIDE = 0x21,')
m('reset-pos-player', 'field', 'o->pos_player = rd_s16(body, BUL_B_START_PLAYER);', 'o->pos_player = rd_s16(body, BUL_B_START_COMPUTER);')
m('reset-pos-computer', 'field', 'o->pos_computer = rd_s16(body, BUL_B_START_COMPUTER);', 'o->pos_computer = rd_s16(body, BUL_B_START_PLAYER);')
m('reset-mode', 'field', 'o->mode = 0;\n    CHECK(body_rect(c, BUL_B_POSITION_RECT, (int32_t)o->pos_player - 1', 'o->mode = 1;\n    CHECK(body_rect(c, BUL_B_POSITION_RECT, (int32_t)o->pos_player - 1')
m('reset-cur-player-index', 'arith', '(int32_t)o->pos_player - 1, 0, B_POSITION_SLOTS, &o->cur_player', '(int32_t)o->pos_player - 2, 0, B_POSITION_SLOTS, &o->cur_player')
m('reset-cur-computer-index', 'arith', '(int32_t)o->pos_computer - 1, 0, B_POSITION_SLOTS, &o->cur_computer', '(int32_t)o->pos_computer - 2, 0, B_POSITION_SLOTS, &o->cur_computer')
m('reset-cur-player-swap', 'field', '(int32_t)o->pos_player - 1, 0, B_POSITION_SLOTS, &o->cur_player', '(int32_t)o->pos_player - 1, 0, B_POSITION_SLOTS, &o->cur_computer')
m('reset-image-player', 'field', 'rd_rect(&o->image_player, body, BUL_B_MARKER_IMAGE);', 'rd_rect(&o->image_player, body, BUL_B_MARKER_IMAGE + 16u);')
m('reset-image-computer', 'field', 'rd_rect(&o->image_computer, body, BUL_B_MARKER_IMAGE + 16u);', 'rd_rect(&o->image_computer, body, BUL_B_MARKER_IMAGE);')
m('reset-anim-active', 'field', '    o->anim_active = 0;\n    o->button_kind = 0;\n    o->anim_deadline = 0;\n    o->button_down = 0;\n    return BUL_OK;',
  '    o->button_kind = 0;\n    o->anim_deadline = 0;\n    o->button_down = 0;\n    return BUL_OK;')
m('reset-button-kind', 'field', '    o->anim_active = 0;\n    o->button_kind = 0;\n    o->anim_deadline = 0;\n    o->button_down = 0;\n    return BUL_OK;',
  '    o->anim_active = 0;\n    o->anim_deadline = 0;\n    o->button_down = 0;\n    return BUL_OK;')
m('reset-anim-deadline', 'field', '    o->anim_active = 0;\n    o->button_kind = 0;\n    o->anim_deadline = 0;\n    o->button_down = 0;\n    return BUL_OK;',
  '    o->anim_active = 0;\n    o->button_kind = 0;\n    o->button_down = 0;\n    return BUL_OK;')
m('reset-button-down', 'field', '    o->anim_active = 0;\n    o->button_kind = 0;\n    o->anim_deadline = 0;\n    o->button_down = 0;\n    return BUL_OK;',
  '    o->anim_active = 0;\n    o->button_kind = 0;\n    o->anim_deadline = 0;\n    return BUL_OK;')
m('pick-bit', 'arith', 'bit = (int16_t)(r & 1);', 'bit = (int16_t)((r >> 1) & 1);')
m('pick-odd-step', 'arith', 'if (bit == 1) odd = (int16_t)(odd + 1);', 'if (bit == 1) odd = (int16_t)(odd + 2);')
m('pick-row', 'arith', 'row = (int16_t)(r & 3);', 'row = (int16_t)(r & 1);')
m('pick-row-shift', 'arith', 'row = (int16_t)(r & 3);', 'row = (int16_t)((r >> 1) & 3);')
m('pick-source', 'field', '(size_t)row * B_WORK_STRIDE + (size_t)bit * 16u);', '(size_t)row * B_WORK_STRIDE + (size_t)bit * 32u);')
m('pick-odd-zero', 'arith', 'if (odd == 0) odd = 5;', 'if (odd == 0) odd = 4;')
m('pick-odd-test', 'predicate', 'if (odd == 0) odd = 5;', 'if (odd <= 1) odd = 5;')
m('pick-set', 'field', 'BulRect *dst = set == 0 ? o->roll_a : o->roll_b;', 'BulRect *dst = set == 0 ? o->roll_b : o->roll_a;')
m('pick-rand-order', 'arith', '        CHECK(rnd(c, &r));\n        row = (int16_t)(r & 3);', '        row = (int16_t)(r & 3);')
m('score-player-eq', 'predicate', 'if (o->score_player == n) {', 'if (o->score_player >= n) {')
m('score-won', 'missing-effect', '        o->won = 1;\n        o->state = BUL_STATE_WIN;', '        o->state = BUL_STATE_WIN;')
m('score-win-state', 'field', 'o->state = BUL_STATE_WIN;', 'o->state = BUL_STATE_LOSE;')
m('score-win-finish', 'missing-effect', '        o->state = BUL_STATE_WIN;\n        o->finish_kind = 1;', '        o->state = BUL_STATE_WIN;')
m('score-computer-test', 'predicate', '} else if (o->score_computer == n) {', '} else if (o->score_computer != n) {')
m('score-lose-state', 'field', 'o->state = BUL_STATE_LOSE;\n        o->finish_kind = 1;', 'o->state = BUL_STATE_WIN;\n        o->finish_kind = 1;')
m('score-lose-finish', 'missing-effect', '        o->state = BUL_STATE_LOSE;\n        o->finish_kind = 1;', '        o->state = BUL_STATE_LOSE;')
m('step-test', 'predicate', 'if (o->pos_player != o->pos_computer) return BUL_OK;', 'if (o->pos_player == o->pos_computer) return BUL_OK;')
m('step-caption-count', 'field', 'B_NAMES_STEP + (size_t)side * BUL_B_CAPTION_STRIDE, 4, side, &found', 'B_NAMES_STEP + (size_t)side * BUL_B_CAPTION_STRIDE, 3, side, &found')
m('step-caption-entry', 'field', 'B_NAMES_STEP + (size_t)side * BUL_B_CAPTION_STRIDE, 4, side, &found', 'B_NAMES_STEP + (size_t)side * BUL_B_CAPTION_STRIDE, 4, 0, &found')
m('step-caption-stride', 'field', 'B_NAMES_STEP + (size_t)side * BUL_B_CAPTION_STRIDE, 4, side, &found', 'B_NAMES_STEP, 4, side, &found')
m('step-state', 'field', 'o->state = BUL_STATE_SCORE;\n    CHECK(tick(c, &t));\n    o->deadline_17c', 'o->state = BUL_STATE_WAIT;\n    CHECK(tick(c, &t));\n    o->deadline_17c')
m('step-deadline', 'arith', 'o->deadline_17c = t + 0x4b0u;', 'o->deadline_17c = t + 0x4b1u;')
m('step-tick-missing', 'missing-effect', 'CHECK(tick(c, &t));\n    o->deadline_17c', 'o->deadline_17c = 0;\n    o->deadline_17c')
m('step-image', 'field', 'BUL_B_MARKER_AFTER + (size_t)side * 16u);', 'BUL_B_MARKER_AFTER);')
m('step-image-target', 'field', 'rd_rect(side == 0 ? &o->image_player : &o->image_computer, c->body, BUL_B_MARKER_AFTER', 'rd_rect(side == 0 ? &o->image_computer : &o->image_player, c->body, BUL_B_MARKER_AFTER')
m('step-score-player', 'arith', 'o->score_player = add16(o->score_player, 1);', 'o->score_player = add16(o->score_player, 2);')
m('step-score-computer', 'arith', 'o->score_computer = add16(o->score_computer, 1);', 'o->score_computer = add16(o->score_computer, 2);')
m('step-side-test', 'predicate', '    if (side == 0) {\n        o->score_player', '    if (side == 1) {\n        o->score_player')
m('step-matched', 'field', '    *matched = 1;', '    *matched = 0;')
m('step-name-stride-constant', 'field', 'B_NAMES_STEP = 0x6e1,', 'B_NAMES_STEP = 0x702,')

# ---------------------------------------------------------------------------------------------------------------------------------
# name offsets and other body offsets
# ---------------------------------------------------------------------------------------------------------------------------------
for nm, old, new in (('phase0', 'B_NAME_PHASE0 = 0x873,', 'B_NAME_PHASE0 = 0x894,'), ('click', 'B_NAMES_CLICK = 0x7e9,', 'B_NAMES_CLICK = 0x80a,'),
                     ('pass0', 'B_NAMES_PASS_0 = 0x5b8,', 'B_NAMES_PASS_0 = 0x5d9,'), ('pass1', 'B_NAMES_PASS_1 = 0x894,', 'B_NAMES_PASS_1 = 0x8b5,'),
                     ('roll0', 'B_NAMES_ROLL_0 = 0x5d9,', 'B_NAMES_ROLL_0 = 0x5fa,'), ('roll1', 'B_NAMES_ROLL_1 = 0x8b5,', 'B_NAMES_ROLL_1 = 0x8d6,'),
                     ('end1', 'B_NAMES_END_1 = 0x65d,', 'B_NAMES_END_1 = 0x67e,'), ('end3', 'B_NAMES_END_3 = 0x939,', 'B_NAMES_END_3 = 0x95a,'),
                     ('win', 'B_NAMES_WIN = 0x765,', 'B_NAMES_WIN = 0x786,'), ('lose', 'B_NAMES_LOSE = 0xa41,', 'B_NAMES_LOSE = 0xa62,'),
                     ('button2-channel', 'B_BUTTON2_CHANNEL = 0x581,', 'B_BUTTON2_CHANNEL = 0x583,'),
                     ('sound-channel-word', 'B_SOUND_BUTTON_CHANNEL = 0x21,', 'B_SOUND_BUTTON_CHANNEL = 0x23,'),
                     ('player-jail-right', 'B_PLAYER_JAIL_LAST_RIGHT = 0x255,', 'B_PLAYER_JAIL_LAST_RIGHT = 0x259,'),
                     ('computer-jail-right', 'B_COMPUTER_JAIL_LAST_RIGHT = 0x315,', 'B_COMPUTER_JAIL_LAST_RIGHT = 0x311,'),
                     ('light-left', 'B_LIGHT_LEFT = 0x34d,', 'B_LIGHT_LEFT = 0x351,'), ('light-right', 'B_LIGHT_RIGHT = 0x355,', 'B_LIGHT_RIGHT = 0x359,')):
    m('offset-' + nm, 'field', old, new)

# ---------------------------------------------------------------------------------------------------------------------------------
# phase 0
# ---------------------------------------------------------------------------------------------------------------------------------
m('p0-row', 'field', 'o->row = row;', 'o->row = row + 1;')
m('p0-start-flag', 'field', '    c->w->start_flag_5bb1ca = 1;\n    fx(c, BUL_FX_START_FLAG, 1, 0);\n    HOST(', '    fx(c, BUL_FX_START_FLAG, 1, 0);\n    HOST(')
m('p0-start-flag-effect', 'missing-effect', '    fx(c, BUL_FX_START_FLAG, 1, 0);\n    HOST(', '    HOST(')
m('p0-clear-item-effect', 'missing-effect', 'fx(c, BUL_FX_CLEAR_ITEM, 0, 0);', ';')
m('p0-moving', 'missing-effect', 'memset(&o->moving, 0, sizeof o->moving);', ';')
m('p0-erase', 'missing-effect', 'memset(&o->erase, 0, sizeof o->erase);', ';')
m('p0-score-player', 'missing-effect', '    o->score_player = 0;\n    o->score_computer = 0;\n    /* The two', '    o->score_computer = 0;\n    /* The two')
m('p0-score-computer', 'missing-effect', '    o->score_player = 0;\n    o->score_computer = 0;\n    /* The two', '    o->score_player = 0;\n    /* The two')
m('p0-clear0-source', 'field', 'rd_rect(&o->clear[0], body, BUL_B_PLAYER_JAIL);', 'rd_rect(&o->clear[0], body, BUL_B_COMPUTER_JAIL);')
m('p0-clear0-right', 'missing-effect', '    o->clear[0].right = rd_s32(body, B_PLAYER_JAIL_LAST_RIGHT);\n', '')
m('p0-clear0-bottom', 'field', 'o->clear[0].bottom = rd_s32(body, B_PLAYER_JAIL_LAST_RIGHT + 4u);', 'o->clear[0].bottom = rd_s32(body, B_PLAYER_JAIL_LAST_RIGHT);')
m('p0-clear1-source', 'field', 'rd_rect(&o->clear[1], body, BUL_B_COMPUTER_JAIL);', 'rd_rect(&o->clear[1], body, BUL_B_PLAYER_JAIL);')
m('p0-clear1-right', 'missing-effect', '    o->clear[1].right = rd_s32(body, B_COMPUTER_JAIL_LAST_RIGHT);\n', '')
m('p0-clear1-bottom', 'field', 'o->clear[1].bottom = rd_s32(body, B_COMPUTER_JAIL_LAST_RIGHT + 4u);', 'o->clear[1].bottom = rd_s32(body, B_COMPUTER_JAIL_LAST_RIGHT);')
m('p0-light', 'predicate', 'o->light = rd_s32(body, B_LIGHT_RIGHT) != rd_s32(body, B_LIGHT_LEFT);', 'o->light = rd_s32(body, B_LIGHT_RIGHT) == rd_s32(body, B_LIGHT_LEFT);')
m('p0-state', 'field', '    o->state = BUL_STATE_IDLE;\n    o->next_state = 0;\n    fx(c, BUL_FX_ROW_PHASE, 1, 0);', '    o->state = BUL_STATE_WAIT;\n    o->next_state = 0;\n    fx(c, BUL_FX_ROW_PHASE, 1, 0);')
m('p0-next-state', 'field', '    o->next_state = 0;\n    fx(c, BUL_FX_ROW_PHASE, 1, 0);', '    o->next_state = 1;\n    fx(c, BUL_FX_ROW_PHASE, 1, 0);')
m('p0-row-phase-effect', 'field', 'fx(c, BUL_FX_ROW_PHASE, 1, 0);', 'fx(c, BUL_FX_ROW_PHASE, 2, 0);')
m('p0-row-phase-effect-missing', 'missing-effect', 'fx(c, BUL_FX_ROW_PHASE, 1, 0);', ';')
m('p0-slot-effect', 'missing-effect', 'fx(c, BUL_FX_SLOT, slot, 0);', ';')
m('p0-slot-negative', 'validate', 'if (slot < 0) {', 'if (slot < -1) {')
m('p0-slot-store', 'missing-effect', 'o->slot = slot;', ';')
m('p0-register-type', 'field', 'c->host->register_slot(c->host->context, slot, 10,', 'c->host->register_slot(c->host->context, slot, 11,')
m('p0-register-label', 'field', '"BUL PUZZLE OVERLAYS"', '"BUL PUZZLE OVERLAYX"')
m('p0-register-label-underscore', 'field', '"BUL PUZZLE OVERLAYS"', '"BUL_PUZZLE_OVERLAYS"')
m('p0-register-surface', 'field', 'BUL_CALLBACK_PUZZLE, 0, "BUL PUZZLE OVERLAYS"', 'BUL_CALLBACK_PUZZLE, 1, "BUL PUZZLE OVERLAYS"')
m('p0-register-effect', 'missing-effect', 'fx(c, BUL_FX_SLOT_REGISTER, slot, 0);', ';')
m('p0-surface-test', 'predicate', 'if (o->surface == 0) {', 'if (1) {')
m('p0-surface-test-never', 'predicate', 'if (o->surface == 0) {', 'if (o->surface == 1) {')
m('p0-load-effect', 'missing-effect', 'fx(c, BUL_FX_SURFACE_LOAD, (int32_t)surface, 0);', ';')
m('p0-surface-store', 'missing-effect', 'o->surface = surface;', ';')
m('p0-load-name', 'field', '(const char *)body + B_SURFACE_NAME, &surface', '(const char *)body + B_SURFACE_NAME + 1, &surface')
m('p0-slot-surface-value', 'field', 'c->host->set_slot_surface(c->host->context, o->slot, o->surface)', 'c->host->set_slot_surface(c->host->context, o->slot, o->surface + 1u)')
m('p0-slot-surface-effect', 'field', 'fx(c, BUL_FX_SLOT_SURFACE, o->slot, (int32_t)o->surface);', 'fx(c, BUL_FX_SLOT_SURFACE, o->slot, (int32_t)o->surface + 1);')
m('p0-prepare-step', 'missing-effect', 'CHECK(prepare_record(c, BUL_B_SOUND_STEP));', ';')
m('p0-prepare-button0', 'missing-effect', 'CHECK(prepare_record(c, BUL_B_SOUND_BUTTON));', ';')
m('p0-prepare-button1', 'missing-effect', 'CHECK(prepare_record(c, BUL_B_SOUND_BUTTON + BUL_B_SOUND_RECORD_BYTES));', ';')
m('p0-prepare-button2', 'missing-effect', 'CHECK(prepare_record(c, BUL_B_SOUND_BUTTON + 2u * BUL_B_SOUND_RECORD_BYTES));', ';')
m('p0-caption-entry', 'field', 'CHECK(caption_pick(c, B_NAME_PHASE0, 1, 1, &found));', 'CHECK(caption_pick(c, B_NAME_PHASE0, 1, 0, &found));')
m('p0-caption-missing', 'missing-effect', 'CHECK(caption_pick(c, B_NAME_PHASE0, 1, 1, &found));', ';')

# ---------------------------------------------------------------------------------------------------------------------------------
# state 0 (idle / button animation)
# ---------------------------------------------------------------------------------------------------------------------------------
m('idle-anim-test', 'predicate', 'if (o->anim_active == 0) {\n        if (body[BUL_B_TWO_PLAYERS]', 'if (o->anim_active != 0) {\n        if (body[BUL_B_TWO_PLAYERS]')
m('idle-computer-two-players', 'predicate', 'if (body[BUL_B_TWO_PLAYERS] == 0 && o->mode >= 2) {', 'if (body[BUL_B_TWO_PLAYERS] != 0 && o->mode >= 2) {', 2, 0)
m('idle-computer-mode', 'predicate', 'if (body[BUL_B_TWO_PLAYERS] == 0 && o->mode >= 2) {', 'if (body[BUL_B_TWO_PLAYERS] == 0 && o->mode >= 3) {', 2, 0)
m('idle-computer-mode-gt', 'predicate', 'if (body[BUL_B_TWO_PLAYERS] == 0 && o->mode >= 2) {', 'if (body[BUL_B_TWO_PLAYERS] == 0 && o->mode >= 1) {', 2, 0)
m('idle-smart-test', 'predicate', 'if (o->mode == 3 && body[BUL_B_SMART] != 0) {', 'if (o->mode == 3 && body[BUL_B_SMART] == 0) {')
m('idle-smart-mode', 'predicate', 'if (o->mode == 3 && body[BUL_B_SMART] != 0) {', 'if (o->mode >= 2 && body[BUL_B_SMART] != 0) {')
m('idle-smart-diff-order', 'arith', '(uint32_t)(uint16_t)o->pos_computer - (uint32_t)(uint16_t)o->pos_player', '(uint32_t)(uint16_t)o->pos_player - (uint32_t)(uint16_t)o->pos_computer')
m('idle-smart-gt5', 'predicate', 'if (d > 5) {', 'if (d >= 5) {')
m('idle-smart-gt5-low', 'predicate', 'if (d > 5) {', 'if (d > 4) {')
m('idle-smart-neg', 'predicate', '} else if (d < 0 && (int32_t)d + rd_s16(body, BUL_B_POSITIONS) > 5) {', '} else if (d <= 0 && (int32_t)d + rd_s16(body, BUL_B_POSITIONS) > 5) {')
m('idle-smart-wrap', 'predicate', '(int32_t)d + rd_s16(body, BUL_B_POSITIONS) > 5) {', '(int32_t)d + rd_s16(body, BUL_B_POSITIONS) >= 5) {')
m('idle-smart-wrap-sum', 'arith', '(int32_t)d + rd_s16(body, BUL_B_POSITIONS) > 5) {', '(int32_t)d + rd_s16(body, BUL_B_POSITIONS) + 1 > 5) {')
m('idle-random-mode', 'predicate', '} else if (o->mode == 3) {\n                int32_t r;', '} else if (o->mode >= 2) {\n                int32_t r;')
m('idle-random-bit', 'arith', 'decide = r & 1;', 'decide = !(r & 1);')
m('idle-random-shift', 'arith', 'decide = r & 1;', 'decide = (r >> 1) & 1;')
m('idle-anim-set', 'missing-effect', '            o->anim_active = 1;\n            CHECK(tick(c, &t));\n            o->anim_deadline = t + 300u;', '            CHECK(tick(c, &t));\n            o->anim_deadline = t + 300u;')
m('idle-anim-deadline', 'arith', 'o->anim_deadline = t + 300u;', 'o->anim_deadline = t + 301u;')
m('idle-button-down', 'field', '            o->button_down = 1;\n            if (decide == 0) {', '            o->button_down = 0;\n            if (decide == 0) {')
m('idle-decide-test', 'predicate', 'if (decide == 0) {', 'if (decide != 0) {')
m('idle-start-flag', 'predicate', 'if (c->w->start_flag_5bb1ca != 0 && !no_sound(body + BUL_B_SOUND_BUTTON)) {', 'if (!no_sound(body + BUL_B_SOUND_BUTTON)) {')
m('idle-start-flag-inverted', 'predicate', 'if (c->w->start_flag_5bb1ca != 0 && !no_sound(body + BUL_B_SOUND_BUTTON)) {', 'if (c->w->start_flag_5bb1ca == 0 && !no_sound(body + BUL_B_SOUND_BUTTON)) {')
m('idle-nosound', 'predicate', 'if (c->w->start_flag_5bb1ca != 0 && !no_sound(body + BUL_B_SOUND_BUTTON)) {', 'if (c->w->start_flag_5bb1ca != 0) {')
m('idle-play-channel', 'field', 'CHECK(play_if_idle(c, rd_s16(body, BUL_B_SOUND_BUTTON + B_SOUND_BUTTON_CHANNEL)));', 'CHECK(play_if_idle(c, rd_s16(body, BUL_B_SOUND_STEP + B_SOUND_BUTTON_CHANNEL)));')
m('idle-pass-kind', 'field', '                o->button_kind = 0;\n                if (c->w', '                o->button_kind = 2;\n                if (c->w')
m('idle-decide-kind', 'field', '            } else {\n                o->button_kind = 1;\n            }', '            } else {\n                o->button_kind = 2;\n            }')
m('idle-deadline-test', 'predicate', 'if (t > o->anim_deadline) {', 'if (t >= o->anim_deadline) {')
m('idle-deadline-signed', 'predicate', 'if (t > o->anim_deadline) {', 'if ((int32_t)(t - o->anim_deadline) > 0) {')
m('idle-button-down-clear', 'missing-effect', '        o->button_down = 0;\n        if (o->button_kind == 0) {', '        if (o->button_kind == 0) {')
m('idle-extra-tick', 'missing-effect', 'CHECK(tick(c, &t)); /* the deadlines below read the clock again */', ';')
m('idle-roll-state', 'field', 'o->state = BUL_STATE_PICK_MOVES;', 'o->state = BUL_STATE_MOVING;')
m('idle-roll-deadline-computer', 'arith', 'o->deadline_16e = t + 1000u;', 'o->deadline_16e = t + 1001u;')
m('idle-roll-deadline', 'arith', 'o->deadline_16e = t + 800u;', 'o->deadline_16e = t + 801u;')
m('idle-roll-two-players', 'predicate', 'if (body[BUL_B_TWO_PLAYERS] == 0 && o->mode >= 2) {', 'if (body[BUL_B_TWO_PLAYERS] != 0 && o->mode >= 2) {', 2, 1)
m('idle-roll-mode', 'predicate', 'if (body[BUL_B_TWO_PLAYERS] == 0 && o->mode >= 2) {', 'if (body[BUL_B_TWO_PLAYERS] == 0 && o->mode >= 3) {', 2, 1)
m('idle-kind1-test', 'predicate', '} else if (o->button_kind == 1) {', '} else if (o->button_kind == 2) {')
m('idle-pass-state', 'field', 'o->state = BUL_STATE_CAPTION_PICK;\n            if (o->mode == 1) {', 'o->state = BUL_STATE_IDLE;\n            if (o->mode == 1) {')
m('idle-pass-mode1', 'predicate', '            if (o->mode == 1) {\n                o->mode = 2;', '            if (o->mode == 0) {\n                o->mode = 2;')
m('idle-pass-mode1-target', 'field', 'o->mode = 2;\n                CHECK(caption_pick(c, B_NAMES_PASS_0', 'o->mode = 3;\n                CHECK(caption_pick(c, B_NAMES_PASS_0')
m('idle-pass-entry0', 'field', 'caption_pick(c, B_NAMES_PASS_0, 1, 0, &found)', 'caption_pick(c, B_NAMES_PASS_0, 1, 1, &found)')
m('idle-pass-mode3', 'predicate', '            if (o->mode == 3) {\n                o->mode = 0;', '            if (o->mode == 2) {\n                o->mode = 0;')
m('idle-pass-mode3-target', 'field', 'o->mode = 0;\n                CHECK(caption_pick(c, B_NAMES_PASS_1', 'o->mode = 1;\n                CHECK(caption_pick(c, B_NAMES_PASS_1')
m('idle-pass-entry1', 'field', 'caption_pick(c, B_NAMES_PASS_1, 1, 1, &found)', 'caption_pick(c, B_NAMES_PASS_1, 1, 0, &found)')
m('idle-pass-button-down', 'missing-effect', '            o->button_down = 0;\n        } else if (o->button_kind == 2) {', '        } else if (o->button_kind == 2) {')
m('idle-reset-clear2', 'field', 'o->clear[2] = o->cur_player;', 'o->clear[2] = o->cur_computer;')
m('idle-reset-clear3', 'field', 'o->clear[3] = o->cur_computer;', 'o->clear[3] = o->cur_player;')
m('idle-reset-state', 'field', 'o->state = BUL_STATE_RESET_WAIT;', 'o->state = BUL_STATE_IDLE;')

# ---------------------------------------------------------------------------------------------------------------------------------
# state 3 (moving)
# ---------------------------------------------------------------------------------------------------------------------------------
m('move-deadline-test', 'predicate', 'if (t < o->deadline_16e) return BUL_OK;', 'if (t <= o->deadline_16e) return BUL_OK;')
m('move-deadline-signed', 'predicate', 'if (t < o->deadline_16e) return BUL_OK;', 'if ((int32_t)(t - o->deadline_16e) < 0) return BUL_OK;')
m('move-side', 'predicate', 'o->side = (o->mode == 0 || o->mode == 1) ? 0 : 1;', 'o->side = (o->mode == 0) ? 0 : 1;')
m('move-side-swap', 'predicate', 'o->side = (o->mode == 0 || o->mode == 1) ? 0 : 1;', 'o->side = (o->mode == 0 || o->mode == 1) ? 1 : 0;')
m('move-steps-test', 'predicate', 'if (o->step < o->moves) {', 'if (o->step <= o->moves) {')
m('move-cur', 'field', 'BulRect *cur = o->side == 0 ? &o->cur_player : &o->cur_computer;', 'BulRect *cur = o->side == 0 ? &o->cur_computer : &o->cur_player;')
m('move-pos', 'field', 'int16_t *pos = o->side == 0 ? &o->pos_player : &o->pos_computer;', 'int16_t *pos = o->side == 0 ? &o->pos_computer : &o->pos_player;')
m('move-moving', 'missing-effect', 'o->moving = *cur;', ';')
m('move-image-stride', 'field', 'BUL_B_MARKER_IMAGE + (size_t)o->side * 16u);', 'BUL_B_MARKER_IMAGE);')
m('move-image-target', 'field', 'rd_rect(o->side == 0 ? &o->image_player : &o->image_computer, body,', 'rd_rect(o->side == 0 ? &o->image_computer : &o->image_player, body,')
m('move-direction', 'predicate', 'if (o->mode == 0 || o->mode == 1) {\n            *pos = *pos == m', 'if (o->mode == 0) {\n            *pos = *pos == m')
m('move-forward-wrap', 'predicate', '*pos = *pos == m ? (int16_t)1 : add16(*pos, 1);', '*pos = *pos == m - 1 ? (int16_t)1 : add16(*pos, 1);')
m('move-forward-step', 'arith', '*pos = *pos == m ? (int16_t)1 : add16(*pos, 1);', '*pos = *pos == m ? (int16_t)1 : add16(*pos, 2);')
m('move-forward-wrap-target', 'field', '*pos = *pos == m ? (int16_t)1 : add16(*pos, 1);', '*pos = *pos == m ? (int16_t)2 : add16(*pos, 1);')
m('move-back-wrap', 'predicate', '*pos = *pos == 1 ? m : add16(*pos, -1);', '*pos = *pos == 2 ? m : add16(*pos, -1);')
m('move-back-step', 'arith', '*pos = *pos == 1 ? m : add16(*pos, -1);', '*pos = *pos == 1 ? m : add16(*pos, -2);')
m('move-back-wrap-target', 'field', '*pos = *pos == 1 ? m : add16(*pos, -1);', '*pos = *pos == 1 ? m - 1 : add16(*pos, -1);')
m('move-rect-index', 'arith', '(int32_t)*pos - 1, 0, B_POSITION_SLOTS, cur));', '(int32_t)*pos, 0, B_POSITION_SLOTS, cur));')
m('move-step-count', 'arith', 'o->step = add16(o->step, 1);', 'o->step = add16(o->step, 2);')
m('move-sound-gate', 'predicate', 'if (!no_sound(body + BUL_B_SOUND_STEP)) {\n            CHECK(play_if_idle', 'if (no_sound(body + BUL_B_SOUND_STEP)) {\n            CHECK(play_if_idle')
m('move-sound-channel', 'field', 'rd_s16(body, BUL_B_SOUND_STEP + B_SOUND_BUTTON_CHANNEL)', 'rd_s16(body, BUL_B_SOUND_BUTTON + B_SOUND_BUTTON_CHANNEL)')
m('move-deadline-computer', 'predicate', 'if (body[BUL_B_TWO_PLAYERS] == 0 && o->side == 1) {', 'if (body[BUL_B_TWO_PLAYERS] != 0 && o->side == 1) {')
m('move-deadline-computer-side', 'predicate', 'if (body[BUL_B_TWO_PLAYERS] == 0 && o->side == 1) {', 'if (body[BUL_B_TWO_PLAYERS] == 0 && o->side == 0) {')
m('move-deadline-400', 'arith', 'o->deadline_180 = t + 400u;', 'o->deadline_180 = t + 401u;')
m('move-deadline-200', 'arith', 'o->deadline_180 = t + 200u;', 'o->deadline_180 = t + 201u;')
m('move-wait-state', 'field', 'o->state = BUL_STATE_WAIT;', 'o->state = BUL_STATE_IDLE;')
m('move-matched', 'predicate', 'if (!matched) {', 'if (matched) {')
m('move-end-idle', 'field', '            o->state = BUL_STATE_IDLE;\n            if (o->mode == 3) {', '            o->state = BUL_STATE_MOVING;\n            if (o->mode == 3) {')
m('move-end3-entry', 'field', 'caption_pick(c, B_NAMES_END_3, 4, 1, &found)', 'caption_pick(c, B_NAMES_END_3, 4, 0, &found)')
m('move-end3-count', 'field', 'caption_pick(c, B_NAMES_END_3, 4, 1, &found)', 'caption_pick(c, B_NAMES_END_3, 3, 1, &found)')
m('move-end3-mode', 'field', '                o->mode = 0;\n            } else {\n                if (o->mode == 1) {', '                o->mode = 1;\n            } else {\n                if (o->mode == 1) {')
m('move-end1-test', 'predicate', '                if (o->mode == 1) {\n                    CHECK(caption_pick(c, B_NAMES_END_1', '                if (o->mode == 0) {\n                    CHECK(caption_pick(c, B_NAMES_END_1')
m('move-end1-entry', 'field', 'caption_pick(c, B_NAMES_END_1, 4, 0, &found)', 'caption_pick(c, B_NAMES_END_1, 4, 1, &found)')
m('move-end-mode-add', 'arith', 'o->mode = add16(o->mode, 1);', 'o->mode = add16(o->mode, 2);')
m('move-next-state-pass0', 'field', 'o->next_state = 1;', 'o->next_state = 0;', 4, 0)
m('move-next-state-pass1', 'field', 'o->next_state = 1;', 'o->next_state = 0;', 4, 1)
m('move-next-state-end3', 'field', 'o->next_state = 1;', 'o->next_state = 0;', 4, 2)
m('move-next-state-end1', 'field', 'o->next_state = 1;', 'o->next_state = 0;', 4, 3)
m('move-found-end3', 'predicate', 'o->state = BUL_STATE_CAPTION_PICK;', 'o->state = BUL_STATE_IDLE;', 3, 1)
m('move-found-end1', 'predicate', 'o->state = BUL_STATE_CAPTION_PICK;', 'o->state = BUL_STATE_IDLE;', 3, 2)

# ---------------------------------------------------------------------------------------------------------------------------------
# state 6 (score), states 7 / 8 (finish captions)
# ---------------------------------------------------------------------------------------------------------------------------------
m('score-deadline-test', 'predicate', 'if (t > o->deadline_17c) {', 'if (t >= o->deadline_17c) {')
m('score-deadline-signed', 'predicate', 'if (t > o->deadline_17c) {', 'if ((int32_t)(t - o->deadline_17c) > 0) {')
m('score-mode-test', 'predicate', 'if (o->mode == 0 || o->mode == 1) {\n            o->moving = o->cur_computer;', 'if (o->mode == 0) {\n            o->moving = o->cur_computer;')
m('score-moving-computer', 'field', 'o->moving = o->cur_computer;', 'o->moving = o->cur_player;')
m('score-moving-player', 'field', 'o->moving = o->cur_player;', 'o->moving = o->cur_computer;')
m('score-erase-computer-index', 'arith', 'n - o->score_player - 1, -1, PIECE_SLOTS, &o->erase', 'n - o->score_player, -1, PIECE_SLOTS, &o->erase')
m('score-erase-player-index', 'arith', 'n - o->score_computer - 1, -1, PIECE_SLOTS, &o->erase', 'n - o->score_computer, -1, PIECE_SLOTS, &o->erase')
m('score-erase-computer-base', 'field', 'CHECK(body_rect(c, BUL_B_COMPUTER_BARRACK, n - o->score_player - 1', 'CHECK(body_rect(c, BUL_B_PLAYER_BARRACK, n - o->score_player - 1')
m('score-erase-player-base', 'field', 'CHECK(body_rect(c, BUL_B_PLAYER_BARRACK, n - o->score_computer - 1', 'CHECK(body_rect(c, BUL_B_COMPUTER_BARRACK, n - o->score_computer - 1')
m('score-erase-lower-bound', 'validate', 'n - o->score_player - 1, -1, PIECE_SLOTS, &o->erase', 'n - o->score_player - 1, 0, PIECE_SLOTS, &o->erase')
m('score-state', 'missing-effect', '        o->state = BUL_STATE_IDLE;\n        score_check(c);', '        score_check(c);')
m('score-check-missing', 'missing-effect', '        score_check(c);\n        CHECK(reset_work(c));', '        CHECK(reset_work(c));')
m('score-reset-missing', 'missing-effect', '        score_check(c);\n        CHECK(reset_work(c));', '        score_check(c);')
m('finish-caption-count', 'field', 'CHECK(caption_pick(c, names, 4, entry, &found));', 'CHECK(caption_pick(c, names, 3, entry, &found));')
m('finish-caption-found', 'predicate', '    if (!found) {\n        CHECK(set_row_phase_2(c, row_phase));', '    if (found) {\n        CHECK(set_row_phase_2(c, row_phase));')
m('finish-next-state', 'field', 'o->next_state = BUL_STATE_EXIT_DELAY;', 'o->next_state = BUL_STATE_IDLE;')
m('finish-deadline', 'arith', 'o->deadline_16e = t + 500u;', 'o->deadline_16e = t + 501u;')
m('finish-tick-missing', 'missing-effect', '        CHECK(tick(c, &t));\n        o->deadline_16e = t + 500u;', '        o->deadline_16e = 500u;')
m('finish-row-phase-store', 'field', '*row_phase = 2u;', '*row_phase = 1u;')
m('finish-row-phase-effect', 'missing-effect', '    fx(c, BUL_FX_ROW_PHASE, 2, 0);\n    return BUL_OK;', '    return BUL_OK;')

# ---------------------------------------------------------------------------------------------------------------------------------
# phase 1 dispatch
# ---------------------------------------------------------------------------------------------------------------------------------
m('p1-capture-state', 'missing-effect', '        o->state = BUL_STATE_IDLE;\n        if (o->mode == 0) {', '        if (o->mode == 0) {')
m('p1-capture-roll0-entry', 'field', 'caption_pick(c, B_NAMES_ROLL_0, 4, 0, &found)', 'caption_pick(c, B_NAMES_ROLL_0, 4, 1, &found)')
m('p1-capture-roll1-entry', 'field', 'caption_pick(c, B_NAMES_ROLL_1, 4, 1, &found)', 'caption_pick(c, B_NAMES_ROLL_1, 4, 0, &found)')
m('p1-capture-mode0', 'predicate', '        if (o->mode == 0) {\n            CHECK(caption_pick(c, B_NAMES_ROLL_0', '        if (o->mode == 1) {\n            CHECK(caption_pick(c, B_NAMES_ROLL_0')
m('p1-capture-mode2', 'predicate', '} else if (o->mode == 2) {\n            CHECK(caption_pick(c, B_NAMES_ROLL_1', '} else if (o->mode == 3) {\n            CHECK(caption_pick(c, B_NAMES_ROLL_1')
m('p1-capture-next0', 'field', 'if (found) o->next_state = 0;', 'if (found) o->next_state = 1;', 2, 0)
m('p1-capture-next1', 'field', 'if (found) o->next_state = 0;', 'if (found) o->next_state = 1;', 2, 1)
m('p1-pick-step', 'field', '        o->step = 0;\n        CHECK(pick_moves', '        o->step = 1;\n        CHECK(pick_moves')
m('p1-pick-set', 'predicate', 'CHECK(pick_moves(c, (o->mode == 0 || o->mode == 1) ? 0 : 1, &o->moves));', 'CHECK(pick_moves(c, (o->mode == 0) ? 0 : 1, &o->moves));')
m('p1-pick-anim', 'missing-effect', '        o->anim_active = 0;\n        o->state = BUL_STATE_MOVING;', '        o->state = BUL_STATE_MOVING;')
m('p1-pick-state', 'field', '        o->anim_active = 0;\n        o->state = BUL_STATE_MOVING;', '        o->anim_active = 0;\n        o->state = BUL_STATE_WAIT;')
m('p1-wait-test', 'predicate', 'if (t > o->deadline_180) o->state = BUL_STATE_MOVING;', 'if (t >= o->deadline_180) o->state = BUL_STATE_MOVING;')
m('p1-wait-signed', 'predicate', 'if (t > o->deadline_180) o->state = BUL_STATE_MOVING;', 'if ((int32_t)(t - o->deadline_180) > 0) o->state = BUL_STATE_MOVING;')
m('p1-win-entry', 'field', 'state_finish_caption(c, B_NAMES_WIN, 0, row_phase)', 'state_finish_caption(c, B_NAMES_WIN, 1, row_phase)')
m('p1-lose-entry', 'field', 'state_finish_caption(c, B_NAMES_LOSE, 1, row_phase)', 'state_finish_caption(c, B_NAMES_LOSE, 0, row_phase)')
m('p1-resetwait-test', 'predicate', '        if (!is_busy) {\n            o->score_player = 0;', '        if (is_busy) {\n            o->score_player = 0;')
m('p1-resetwait-player', 'missing-effect', '            o->score_player = 0;\n            o->score_computer = 0;\n            CHECK(reset_work(c));', '            o->score_computer = 0;\n            CHECK(reset_work(c));')
m('p1-resetwait-computer', 'missing-effect', '            o->score_player = 0;\n            o->score_computer = 0;\n            CHECK(reset_work(c));', '            o->score_player = 0;\n            CHECK(reset_work(c));')
m('p1-resetwait-reset', 'missing-effect', '            CHECK(reset_work(c));\n            o->state = BUL_STATE_IDLE;', '            o->state = BUL_STATE_IDLE;')
m('p1-resetwait-state', 'missing-effect', '            CHECK(reset_work(c));\n            o->state = BUL_STATE_IDLE;', '            CHECK(reset_work(c));')
m('p1-capwait-channel', 'field', 'CHECK(busy(c, o->cap_channel, &is_busy));', 'CHECK(busy(c, o->cap_1b1, &is_busy));')
m('p1-capwait-test', 'predicate', 'if (!is_busy) o->state = o->next_state;', 'if (is_busy) o->state = o->next_state;')
m('p1-capwait-target', 'field', 'if (!is_busy) o->state = o->next_state;', 'if (!is_busy) o->state = BUL_STATE_IDLE;')
m('p1-exit-test', 'predicate', 'if (t >= o->deadline_16e) CHECK(set_row_phase_2(c, row_phase));', 'if (t > o->deadline_16e) CHECK(set_row_phase_2(c, row_phase));')
m('p1-exit-signed', 'predicate', 'if (t >= o->deadline_16e) CHECK(set_row_phase_2(c, row_phase));', 'if ((int32_t)(t - o->deadline_16e) >= 0) CHECK(set_row_phase_2(c, row_phase));')

# ---------------------------------------------------------------------------------------------------------------------------------
# phase 2: finish blocks, flags, completion
# ---------------------------------------------------------------------------------------------------------------------------------
m('blk-scene', 'missing-effect', '    t.scene = rd_s16(b, SB_SCENE);', '    t.scene = 0;')
m('blk-word1', 'field', 't.word[0] = rd_s16(b, SB_W1);', 't.word[0] = rd_s16(b, SB_W2);')
m('blk-word2', 'field', 't.word[1] = rd_s16(b, SB_W2);', 't.word[1] = rd_s16(b, SB_W3);')
m('blk-word3', 'field', 't.word[2] = rd_s16(b, SB_W3);', 't.word[2] = rd_s16(b, SB_W1);')
m('blk-dword1', 'field', 't.dword[0] = rd_s32(b, SB_D1);', 't.dword[0] = rd_s32(b, SB_D2);')
m('blk-dword2', 'field', 't.dword[1] = rd_s32(b, SB_D2);', 't.dword[1] = rd_s32(b, SB_D3);')
m('blk-dword3', 'field', 't.dword[2] = rd_s32(b, SB_D3);', 't.dword[2] = rd_s32(b, SB_D1);')
m('blk-offset-start', 'field', 'SB_START = 20,', 'SB_START = 21,')
m('blk-offset-flag', 'field', 'SB_FLAG = 22,', 'SB_FLAG = 23,')
m('blk-offset-value', 'field', 'SB_VALUE = 24,', 'SB_VALUE = 23,')
m('blk-offset-flag2', 'field', 'SB_FLAG2 = 25,', 'SB_FLAG2 = 26,')
m('blk-offset-value2', 'field', 'SB_VALUE2 = 27', 'SB_VALUE2 = 28')
m('blk-effect-scene', 'field', 'fx(c, BUL_FX_XFER_5BB57B, t.scene, 0);', 'fx(c, BUL_FX_XFER_5BB57B, t.scene + 1, 0);')
m('blk-effect-word1', 'field', 'fx(c, BUL_FX_XFER_5BB599, t.word[0], 0);', 'fx(c, BUL_FX_XFER_5BB599, t.word[1], 0);')
m('blk-effect-word3', 'field', 'fx(c, BUL_FX_XFER_5C39FF, t.word[2], 0);', 'fx(c, BUL_FX_XFER_5C39FF, t.word[0], 0);')
m('blk-effect-dword2', 'field', 'fx(c, BUL_FX_XFER_5BB59F, t.dword[1], 0);', 'fx(c, BUL_FX_XFER_5BB59F, t.dword[2], 0);')
m('blk-effect-missing', 'missing-effect', 'fx(c, BUL_FX_XFER_5BB5A3, t.dword[2], 0);', ';')
m('blk-start-test', 'predicate', 'c->w->start_flag_5bb1ca = rd_s16(b, SB_START) != 1 ? 1 : 0;', 'c->w->start_flag_5bb1ca = rd_s16(b, SB_START) != 0 ? 1 : 0;')
m('blk-start-value', 'predicate', 'c->w->start_flag_5bb1ca = rd_s16(b, SB_START) != 1 ? 1 : 0;', 'c->w->start_flag_5bb1ca = rd_s16(b, SB_START) != 1 ? 0 : 1;')
m('blk-start-effect', 'missing-effect', 'fx(c, BUL_FX_START_FLAG, c->w->start_flag_5bb1ca, 0);', ';')
m('blk-mode-value', 'field', 'HOST(c, c->host->engine_mode(c->host->context, 4));', 'HOST(c, c->host->engine_mode(c->host->context, 3));')
m('blk-mode-effect', 'field', 'fx(c, BUL_FX_ENGINE_MODE, 4, 0);', 'fx(c, BUL_FX_ENGINE_MODE, 3, 0);')
m('flag-effect-value', 'field', 'fx(c, BUL_FX_EVENT_FLAG, index, value);', 'fx(c, BUL_FX_EVENT_FLAG, index, value + 1);')
m('flag-effect-index', 'field', 'fx(c, BUL_FX_EVENT_FLAG, index, value);', 'fx(c, BUL_FX_EVENT_FLAG, index + 1, value);')
m('flag-left-value', 'field', '*value = body[BUL_B_BLOCK_LEFT + SB_VALUE];', '*value = body[BUL_B_BLOCK_LEFT + SB_VALUE2];')
m('flag-left-index', 'field', 'return rd_s16(body, BUL_B_BLOCK_LEFT + SB_FLAG);', 'return rd_s16(body, BUL_B_BLOCK_LEFT + SB_FLAG2);')
m('flag-kind-test', 'predicate', 'if (o->finish_kind == 0) {\n        *value', 'if (o->finish_kind != 0) {\n        *value')
m('flag-won-test', 'predicate', 'if (o->won != 0) {', 'if (o->won == 0) {')
m('flag-won-value', 'field', '*value = body[BUL_B_BLOCK_ENDED + SB_VALUE];', '*value = body[BUL_B_BLOCK_ENDED + SB_VALUE2];')
m('flag-won-index', 'field', 'return rd_s16(body, BUL_B_BLOCK_ENDED + SB_FLAG);', 'return rd_s16(body, BUL_B_BLOCK_ENDED + SB_FLAG2);')
m('flag-lost-value', 'field', '*value = body[BUL_B_BLOCK_ENDED + SB_VALUE2];', '*value = body[BUL_B_BLOCK_ENDED + SB_VALUE];')
m('flag-lost-index', 'field', 'return rd_s16(body, BUL_B_BLOCK_ENDED + SB_FLAG2);', 'return rd_s16(body, BUL_B_BLOCK_ENDED + SB_FLAG);')
m('p2-start-flag', 'missing-effect', '    c->w->start_flag_5bb1ca = 1;\n    fx(c, BUL_FX_START_FLAG, 1, 0);\n    CHECK(stop_record', '    fx(c, BUL_FX_START_FLAG, 1, 0);\n    CHECK(stop_record')
m('p2-start-flag-effect', 'missing-effect', '    fx(c, BUL_FX_START_FLAG, 1, 0);\n    CHECK(stop_record', '    CHECK(stop_record')
m('p2-stop-button0', 'missing-effect', 'CHECK(stop_record(c, BUL_B_SOUND_BUTTON));', ';')
m('p2-stop-button1', 'missing-effect', 'CHECK(stop_record(c, BUL_B_SOUND_BUTTON + BUL_B_SOUND_RECORD_BYTES));', ';')
m('p2-stop-button2', 'missing-effect', 'CHECK(stop_record(c, BUL_B_SOUND_BUTTON + 2u * BUL_B_SOUND_RECORD_BYTES));', ';')
m('p2-left-test', 'predicate', 'if (o->finish_kind == 0) {\n        if (rd_s16(body, BUL_B_BLOCK_LEFT', 'if (o->finish_kind != 0) {\n        if (rd_s16(body, BUL_B_BLOCK_LEFT')
m('p2-left-scene-test', 'predicate', 'if (rd_s16(body, BUL_B_BLOCK_LEFT + SB_SCENE) != BUL_NO_SCENE) CHECK(apply_block(c, BUL_B_BLOCK_LEFT));', 'CHECK(apply_block(c, BUL_B_BLOCK_LEFT));')
m('p2-ended-scene-test', 'predicate', 'if (rd_s16(body, BUL_B_BLOCK_ENDED + SB_SCENE) != BUL_NO_SCENE) CHECK(apply_block(c, BUL_B_BLOCK_ENDED));', 'CHECK(apply_block(c, BUL_B_BLOCK_ENDED));')
m('p2-flag-test', 'predicate', 'if (flag != BUL_NO_FLAG) CHECK(store_flag(c, flag, value));', 'CHECK(store_flag(c, flag, value));')
m('p2-precheck-test', 'validate', 'if (flag != BUL_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (host->event_flag_invalid(host->context, flag) != 0) {')
m('p2-precheck-missing', 'validate', 'if (flag != BUL_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (0) {')
m('step-complete-effect', 'field', 'fx(&c, BUL_FX_COMPLETE, object->row, 0);', 'fx(&c, BUL_FX_COMPLETE, object->row + 1, 0);')
m('step-complete-flag', 'missing-effect', '            result->completed = 1u;', '            result->completed = 0u;')
m('step-complete-phase', 'field', '            row_phase = 0u;', '            row_phase = 1u;')
m('step-init-flag', 'missing-effect', '            result->initialized = 1u;', '            result->initialized = 0u;')
m('step-init-phase', 'field', '            row_phase = 1u;\n            result->initialized', '            row_phase = 2u;\n            result->initialized')
m('step-p1-guard', 'predicate', 'if (object->active == 0 || object->row != row) {', 'if (object->active == 0 && object->row != row) {')
m('step-p1-guard-active', 'predicate', 'if (object->active == 0 || object->row != row) {', 'if (object->row != row) {')
m('step-p1-guard-row', 'predicate', 'if (object->active == 0 || object->row != row) {', 'if (object->active == 0) {')
m('step-p2-guard', 'predicate', 'if (object->row != row) {\n            if (failure != NULL) *failure = "0xda-phase-2-without-init";', 'if (0) {\n            if (failure != NULL) *failure = "0xda-phase-2-without-init";')
m('step-p0-row', 'validate', 'if (row < 0) {\n            if (failure != NULL) *failure = "0xda-row";', 'if (row < -1) {\n            if (failure != NULL) *failure = "0xda-row";')
m('step-phase-above-2', 'predicate', '    } else {\n        return BUL_OK;\n    }\n    result->phase_after', '    } else if (phase == 3u) {\n        row_phase = 0u;\n    } else {\n        return BUL_OK;\n    }\n    result->phase_after')
m('check-mode-high', 'validate', 'o->mode < 0 || o->mode > 3', 'o->mode < 0 || o->mode > 4')
m('check-mode-low', 'validate', 'o->mode < 0 || o->mode > 3', 'o->mode < -1 || o->mode > 3')
m('check-score-player-high', 'validate', 'o->score_player < 0 || o->score_player > n ||', 'o->score_player < 0 || o->score_player > n + 1 ||')
m('check-score-player-low', 'validate', 'o->score_player < 0 || o->score_player > n ||', 'o->score_player < -1 || o->score_player > n ||')
m('check-score-computer-high', 'validate', 'o->score_computer < 0 ||\n        o->score_computer > n ||', 'o->score_computer < 0 ||\n        o->score_computer > n + 1 ||')
m('check-score-computer-low', 'validate', 'o->score_computer < 0 ||', 'o->score_computer < -1 ||')
m('check-pos-player-low', 'validate', 'o->pos_player < 1 || o->pos_player > m ||', 'o->pos_player < 0 || o->pos_player > m ||')
m('check-pos-player-high', 'validate', 'o->pos_player < 1 || o->pos_player > m ||', 'o->pos_player < 1 || o->pos_player > m + 1 ||')
m('check-pos-computer-low', 'validate', 'o->pos_computer < 1 || o->pos_computer > m ||', 'o->pos_computer < 0 || o->pos_computer > m ||')
m('check-pos-computer-high', 'validate', 'o->pos_computer < 1 || o->pos_computer > m ||', 'o->pos_computer < 1 || o->pos_computer > m + 1 ||')
m('check-side-high', 'validate', 'o->side < 0 || o->side > 1 ||', 'o->side < 0 || o->side > 2 ||')
m('check-side-low', 'validate', 'o->side < 0 || o->side > 1 ||', 'o->side < -1 || o->side > 1 ||')
m('check-button-high', 'validate', 'o->button_kind < 0 || o->button_kind > 2)', 'o->button_kind < 0 || o->button_kind > 3)')
m('check-button-low', 'validate', 'o->button_kind < 0 || o->button_kind > 2)', 'o->button_kind < -1 || o->button_kind > 2)')

# ---------------------------------------------------------------------------------------------------------------------------------
# pointer 0x45b5bb / 0x45b7a8
# ---------------------------------------------------------------------------------------------------------------------------------
m('ptr-x-width', 'sign', 'px = (int16_t)(uint16_t)x;', 'px = (int16_t)(uint8_t)x;')
m('ptr-y-width', 'sign', 'py = (int16_t)(uint16_t)y;', 'py = (int16_t)(uint8_t)y;')
m('ptr-x-unsigned', 'sign', 'px = (int16_t)(uint16_t)x;', 'px = (int16_t)(x & 0x7fff);')
m('ptr-inactive', 'predicate', 'if (object->active == 0 || object->anim_active != 0) return BUL_OK;', 'if (object->anim_active != 0) return BUL_OK;')
m('ptr-anim-gate', 'predicate', 'if (object->active == 0 || object->anim_active != 0) return BUL_OK;', 'if (object->active == 0) return BUL_OK;')
m('ptr-computer-gate', 'predicate', 'if (body[BUL_B_TWO_PLAYERS] == 0 && object->mode >= 2) return BUL_OK;', 'if (body[BUL_B_TWO_PLAYERS] != 0 && object->mode >= 2) return BUL_OK;')
m('ptr-computer-mode', 'predicate', 'if (body[BUL_B_TWO_PLAYERS] == 0 && object->mode >= 2) return BUL_OK;', 'if (body[BUL_B_TWO_PLAYERS] == 0 && object->mode >= 3) return BUL_OK;')
m('ptr-b0-top', 'arith', 'py >= sub32(rd_s32(body, b0 + 4), 5)', 'py >= sub32(rd_s32(body, b0 + 4), 4)')
m('ptr-b0-top-sign', 'arith', 'py >= sub32(rd_s32(body, b0 + 4), 5)', 'py >= add32(rd_s32(body, b0 + 4), 5)')
m('ptr-b0-bottom', 'arith', 'py <= add32(rd_s32(body, b0 + 12), 5)', 'py <= add32(rd_s32(body, b0 + 12), 4)')
m('ptr-b0-bottom-sign', 'arith', 'py <= add32(rd_s32(body, b0 + 12), 5)', 'py <= sub32(rd_s32(body, b0 + 12), 5)')
m('ptr-b0-left', 'compare', 'px >= rd_s32(body, b0) &&', 'px > rd_s32(body, b0) &&')
m('ptr-b0-right', 'compare', 'px <= rd_s32(body, b0 + 8)) {', 'px < rd_s32(body, b0 + 8)) {')
m('ptr-b0-top-edge', 'compare', 'py >= sub32(rd_s32(body, b0 + 4), 5)', 'py > sub32(rd_s32(body, b0 + 4), 5)')
m('ptr-b0-bottom-edge', 'compare', 'py <= add32(rd_s32(body, b0 + 12), 5)', 'py < add32(rd_s32(body, b0 + 12), 5)')
m('ptr-b1-modes', 'predicate', '(object->mode == 1 || object->mode == 3) && py >= add32(rd_s32(body, b1 + 4), 5)', '(object->mode == 1) && py >= add32(rd_s32(body, b1 + 4), 5)')
m('ptr-b1-modes-all', 'predicate', '(object->mode == 1 || object->mode == 3) && py >= add32(rd_s32(body, b1 + 4), 5)', '(object->mode == 1 || object->mode == 3 || object->mode == 0) && py >= add32(rd_s32(body, b1 + 4), 5)')
m('ptr-b1-top', 'arith', 'py >= add32(rd_s32(body, b1 + 4), 5)', 'py >= sub32(rd_s32(body, b1 + 4), 5)')
m('ptr-b1-top-edge', 'compare', 'py >= add32(rd_s32(body, b1 + 4), 5)', 'py > add32(rd_s32(body, b1 + 4), 5)')
m('ptr-b1-bottom', 'arith', 'py <= add32(rd_s32(body, b1 + 12), 5)', 'py <= add32(rd_s32(body, b1 + 12), 4)')
m('ptr-b1-bottom-edge', 'compare', 'py <= add32(rd_s32(body, b1 + 12), 5)', 'py < add32(rd_s32(body, b1 + 12), 5)')
m('ptr-b1-left', 'arith', 'px >= add32(rd_s32(body, b1), 10)', 'px >= add32(rd_s32(body, b1), 9)')
m('ptr-b1-left-edge', 'compare', 'px >= add32(rd_s32(body, b1), 10)', 'px > add32(rd_s32(body, b1), 10)')
m('ptr-b1-right', 'arith', 'px <= sub32(rd_s32(body, b1 + 8), 10)', 'px <= sub32(rd_s32(body, b1 + 8), 9)')
m('ptr-b1-right-edge', 'compare', 'px <= sub32(rd_s32(body, b1 + 8), 10)', 'px < sub32(rd_s32(body, b1 + 8), 10)')
m('ptr-b2-top', 'compare', 'py >= rd_s32(body, b2 + 4) &&', 'py > rd_s32(body, b2 + 4) &&')
m('ptr-b2-bottom', 'compare', 'py <= rd_s32(body, b2 + 12) &&', 'py < rd_s32(body, b2 + 12) &&')
m('ptr-b2-left', 'compare', 'px >= rd_s32(body, b2) &&', 'px > rd_s32(body, b2) &&')
m('ptr-b2-right', 'compare', 'px <= rd_s32(body, b2 + 8)) {', 'px < rd_s32(body, b2 + 8)) {')
m('ptr-b2-kind', 'field', '            kind = 2;', '            kind = 1;')
m('ptr-b1-kind', 'field', '            kind = 1;', '            kind = 2;')
m('ptr-finish-top', 'compare', 'py >= rd_s32(body, BUL_B_FINISH_RECT + 4) &&', 'py > rd_s32(body, BUL_B_FINISH_RECT + 4) &&')
m('ptr-finish-bottom', 'compare', 'py <= rd_s32(body, BUL_B_FINISH_RECT + 12) &&', 'py < rd_s32(body, BUL_B_FINISH_RECT + 12) &&')
m('ptr-finish-left', 'compare', 'px >= rd_s32(body, BUL_B_FINISH_RECT) &&', 'px > rd_s32(body, BUL_B_FINISH_RECT) &&')
m('ptr-finish-right', 'compare', 'px <= rd_s32(body, BUL_B_FINISH_RECT + 8)) {', 'px < rd_s32(body, BUL_B_FINISH_RECT + 8)) {')
m('ptr-finish-offset', 'field', 'px >= rd_s32(body, BUL_B_FINISH_RECT) &&', 'px >= rd_s32(body, BUL_B_FINISH_RECT + 16) &&')
m('ptr-button-cursor', 'field', 'out->cursor_kind = 0x16;', 'out->cursor_kind = 0x17;')
m('ptr-button-cell', 'field', 'out->cursor_cell = 0x5b160cu + 0x16u * 32u + 16u;', 'out->cursor_cell = 0x5b160cu + 0x16u * 32u;')
m('ptr-finish-cursor', 'field', 'out->cursor_kind = 9;', 'out->cursor_kind = 8;')
m('ptr-finish-cell', 'field', 'out->cursor_cell = 0x5b160cu + 9u * 32u + 16u;', 'out->cursor_cell = 0x5b160cu + 9u * 32u + 32u;')
m('ptr-pending', 'missing-effect', 'object->pending_button = (int16_t)kind;', ';')
m('ptr-pending-value', 'field', 'object->pending_button = (int16_t)kind;', 'object->pending_button = (int16_t)(kind ^ 1);')
m('ptr-sub-miss', 'field', '    out->cursor_sub = 0;\n    out->cursor_link = 0;', '    out->cursor_sub = 1;\n    out->cursor_link = 0;')
m('ptr-sub-hit', 'field', '    out->cursor_sub = 1;\n    out->cursor_link = 1;', '    out->cursor_sub = 0;\n    out->cursor_link = 1;')
m('ptr-link-miss', 'field', '    out->cursor_sub = 0;\n    out->cursor_link = 0;', '    out->cursor_sub = 0;\n    out->cursor_link = 1;')
m('ptr-candidate-button', 'field', 'out->candidate = BUL_CANDIDATE_BUTTON;', 'out->candidate = BUL_CANDIDATE_FINISH;')
m('ptr-candidate-finish', 'field', 'out->candidate = BUL_CANDIDATE_FINISH;', 'out->candidate = BUL_CANDIDATE_BUTTON;')

# ---------------------------------------------------------------------------------------------------------------------------------
# click 0x45b872
# ---------------------------------------------------------------------------------------------------------------------------------
m('click-active', 'predicate', 'if (object->active == 0 || object->won != 0 || object->state != 0 || row_phase != 1u) return BUL_OK;', 'if (object->won != 0 || object->state != 0 || row_phase != 1u) return BUL_OK;')
m('click-won', 'predicate', 'if (object->active == 0 || object->won != 0 || object->state != 0 || row_phase != 1u) return BUL_OK;', 'if (object->active == 0 || object->state != 0 || row_phase != 1u) return BUL_OK;')
m('click-state', 'predicate', 'if (object->active == 0 || object->won != 0 || object->state != 0 || row_phase != 1u) return BUL_OK;', 'if (object->active == 0 || object->won != 0 || row_phase != 1u) return BUL_OK;')
m('click-row-phase', 'predicate', 'if (object->active == 0 || object->won != 0 || object->state != 0 || row_phase != 1u) return BUL_OK;', 'if (object->active == 0 || object->won != 0 || object->state != 0) return BUL_OK;')
m('click-finish-entry', 'field', 'caption_pick(&c, B_NAMES_CLICK, 4, 0, &found)', 'caption_pick(&c, B_NAMES_CLICK, 4, 1, &found)')
m('click-finish-count', 'field', 'caption_pick(&c, B_NAMES_CLICK, 4, 0, &found)', 'caption_pick(&c, B_NAMES_CLICK, 3, 0, &found)')
m('click-finish-found', 'predicate', '        if (!found) {\n            out->new_phase = 2u;', '        if (found) {\n            out->new_phase = 2u;')
m('click-finish-phase', 'field', 'out->new_phase = 2u;', 'out->new_phase = 1u;')
m('click-finish-effect', 'missing-effect', 'fx(&c, BUL_FX_ROW_PHASE, 2, 0);', ';')
m('click-finish-next-state', 'field', 'object->next_state = BUL_STATE_EXIT_DELAY;', 'object->next_state = BUL_STATE_IDLE;', 1, 0)
m('click-finish-deadline', 'arith', 'object->deadline_16e = t + 800u;', 'object->deadline_16e = t + 801u;')
m('click-handled-finish', 'field', 'out->handled = 1;', 'out->handled = 0;', 2, 0)
m('click-handled-button', 'field', 'out->handled = 1;', 'out->handled = 0;', 2, 1)
m('click-kind-range', 'validate', 'if (kind < 0 || kind > 2) return BUL_ERR_UNSUPPORTED;', 'if (kind < 0 || kind > 3) return BUL_ERR_UNSUPPORTED;')
m('click-anim', 'field', 'object->anim_active = 1;', 'object->anim_active = 0;')
m('click-kind', 'field', 'object->button_kind = kind;', 'object->button_kind = 0;')
m('click-deadline', 'arith', 'object->anim_deadline = t + 250u;', 'object->anim_deadline = t + 251u;')
m('click-down', 'field', 'object->button_down = 1;', 'object->button_down = 0;')
m('click-start-flag', 'predicate', 'if (local.start_flag_5bb1ca != 0) {', 'if (local.start_flag_5bb1ca == 0) {')
m('click-start-flag-always', 'predicate', 'if (local.start_flag_5bb1ca != 0) {', 'if (1) {')
m('click-record', 'field', 'const size_t rec = BUL_B_SOUND_BUTTON + (size_t)kind * BUL_B_SOUND_RECORD_BYTES;', 'const size_t rec = BUL_B_SOUND_BUTTON;')
m('click-nosound', 'predicate', 'if (!no_sound(body + rec)) CHECK(play_if_idle(&c, rd_s16(body, rec + B_SOUND_BUTTON_CHANNEL)));', 'CHECK(play_if_idle(&c, rd_s16(body, rec + B_SOUND_BUTTON_CHANNEL)));')
m('click-channel', 'field', 'rd_s16(body, rec + B_SOUND_BUTTON_CHANNEL)', 'rd_s16(body, BUL_B_SOUND_STEP + B_SOUND_BUTTON_CHANNEL)')
m('click-tick-missing', 'missing-effect', '        CHECK(tick(&c, &t));\n        object->anim_deadline', '        t = 0;\n        object->anim_deadline')

# ---------------------------------------------------------------------------------------------------------------------------------
# invalidate 0x45b477, cleanup 0x45b42e + 0x45b3ea
# ---------------------------------------------------------------------------------------------------------------------------------
m('inv-active', 'predicate', 'if (object->active != 0 && object->slot != BUL_NO_SLOT) {\n        if (host->mark_dirty', 'if (object->slot != BUL_NO_SLOT) {\n        if (host->mark_dirty')
m('inv-slot', 'predicate', 'if (object->active != 0 && object->slot != BUL_NO_SLOT) {\n        if (host->mark_dirty', 'if (object->active != 0) {\n        if (host->mark_dirty')
m('inv-effect', 'missing-effect', 'host->observe(host->context, BUL_FX_MARK_DIRTY, object->slot, 0);', ';')
m('inv-effect-slot', 'field', 'host->observe(host->context, BUL_FX_MARK_DIRTY, object->slot, 0);', 'host->observe(host->context, BUL_FX_MARK_DIRTY, object->slot + 1, 0);')
m('clean-surface-test', 'predicate', 'if (object->surface != 0) {', 'if (1) {')
m('clean-surface-clear', 'missing-effect', 'object->surface = 0; /* 0x4c2dfb zeroes the handle */', ';')
m('clean-surface-effect', 'missing-effect', 'host->observe(host->context, BUL_FX_RELEASE_SURFACE, (int32_t)held, 0);', ';')
m('clean-slot-test', 'predicate', 'if (object->slot != BUL_NO_SLOT) {\n        if (host->release_slot', 'if (1) {\n        if (host->release_slot')
m('clean-slot-effect', 'missing-effect', 'host->observe(host->context, BUL_FX_RELEASE_SLOT, object->slot, 0);', ';')
m('clean-row', 'missing-effect', '    object->row = -1;\n    object->slot = -1;\n    object->active = 0;', '    object->slot = -1;\n    object->active = 0;')
m('clean-slot', 'missing-effect', '    object->slot = -1;\n    object->active = 0;', '    object->active = 0;')
m('clean-active', 'missing-effect', '    object->active = 0;\n    object->won = 0;', '    object->won = 0;')
m('clean-won', 'missing-effect', '    object->won = 0;\n    object->finish_kind = 0;\n    return BUL_OK;', '    object->finish_kind = 0;\n    return BUL_OK;')
m('clean-finish', 'missing-effect', '    object->finish_kind = 0;\n    return BUL_OK;', '    return BUL_OK;')
m('clean-order', 'field', '    if (object->surface != 0) {\n        const uint32_t held', '    if (object->surface != 0 && object->slot != BUL_NO_SLOT) {\n        const uint32_t held')

# ---------------------------------------------------------------------------------------------------------------------------------
# render 0x45d2c6 / 0x45b568
# ---------------------------------------------------------------------------------------------------------------------------------
m('render-active', 'predicate', 'if (object->active == 0 || object->slot == BUL_NO_SLOT) return BUL_OK; /* no callback without a z entry */', 'if (object->slot == BUL_NO_SLOT) return BUL_OK; /* no callback without a z entry */')
m('render-check-object', 'validate', '    CHECK(check_object(&c));\n    out->valid = 1;', '    out->valid = 1;')
m('render-valid', 'field', '    out->valid = 1;', '    out->valid = 0;')
m('render-roll-a-dst', 'field', 'BUL_B_ROLL_A_DST + (size_t)i * 16u', 'BUL_B_ROLL_B_DST + (size_t)i * 16u')
m('render-roll-a-src', 'field', 'BUL_BLIT_ROLL_A, i, 0, &object->roll_a[i]', 'BUL_BLIT_ROLL_A, i, 0, &object->roll_b[i]')
m('render-roll-a-index', 'field', 'BUL_BLIT_ROLL_A, i, 0,', 'BUL_BLIT_ROLL_A, i + 1, 0,')
m('render-roll-b-dst', 'field', 'BUL_B_ROLL_B_DST + (size_t)i * 16u', 'BUL_B_ROLL_A_DST + (size_t)i * 16u')
m('render-roll-b-src', 'field', 'BUL_BLIT_ROLL_B, i, 0, &object->roll_b[i]', 'BUL_BLIT_ROLL_B, i, 0, &object->roll_a[i]')
m('render-roll-count', 'arith', '    for (int i = 0; i < 4; ++i) {\n        BulRect rect;\n        rd_rect(&rect, body, BUL_B_ROLL_B_DST', '    for (int i = 0; i < 3; ++i) {\n        BulRect rect;\n        rd_rect(&rect, body, BUL_B_ROLL_B_DST')
m('render-player-barrack-count', 'arith', 'n - object->score_computer - 1, BUL_B_PLAYER_BARRACK', 'n - object->score_computer, BUL_B_PLAYER_BARRACK')
m('render-player-jail-count', 'field', 'BUL_BLIT_PLAYER_JAIL, object->score_player,', 'BUL_BLIT_PLAYER_JAIL, object->score_computer,')
m('render-computer-barrack-count', 'arith', 'n - object->score_player - 1, BUL_B_COMPUTER_BARRACK', 'n - object->score_player, BUL_B_COMPUTER_BARRACK')
m('render-computer-jail-count', 'field', 'BUL_BLIT_COMPUTER_JAIL, object->score_computer,', 'BUL_BLIT_COMPUTER_JAIL, object->score_player,')
m('render-player-jail-again', 'field', 'BUL_BLIT_PLAYER_JAIL_AGAIN, object->score_player,', 'BUL_BLIT_PLAYER_JAIL_AGAIN, object->score_computer,')
m('render-player-jail-again-missing', 'missing-effect', 'CHECK(emit_pieces(&c, out, BUL_BLIT_PLAYER_JAIL_AGAIN, object->score_player, BUL_B_PLAYER_JAIL, BUL_B_PIECE_PLAYER_JAIL,\n                      vx, vy));', ';')
m('render-pieces-slot-bound', 'validate', 'CHECK(body_rect(c, array, i, 0, PIECE_SLOTS, &rect));', 'CHECK(body_rect(c, array, i, 0, PIECE_SLOTS - 1, &rect));')
m('render-pieces-image', 'field', 'rd_rect(&src, c->body, image);', 'rd_rect(&src, c->body, image + 16u);')
m('render-pieces-array', 'field', 'CHECK(body_rect(c, array, i, 0, PIECE_SLOTS, &rect));', 'CHECK(body_rect(c, array + 16u, i, 0, PIECE_SLOTS, &rect));')
m('render-erase-test', 'predicate', 'if (object->erase.right != 0) {', 'if (object->erase.bottom != 0) {')
m('render-erase-clear', 'missing-effect', 'memset(&object->erase, 0, sizeof object->erase);', ';')
m('render-light-test', 'predicate', 'if (object->mode == 0 || (object->mode == 1 && object->light != 0)) {', 'if (object->mode == 0) {')
m('render-light-test-mode', 'predicate', 'if (object->mode == 0 || (object->mode == 1 && object->light != 0)) {', 'if (object->mode == 0 || (object->mode == 1)) {')
m('render-light-test-flag', 'predicate', 'if (object->mode == 0 || (object->mode == 1 && object->light != 0)) {', 'if (object->mode == 0 || (object->mode == 1 && object->light == 0)) {')
m('render-light-else', 'predicate', '    } else if (object->light != 0) {\n        CHECK(emit_body(&c, out, BUL_BLIT_COMPUTER_LIGHT,', '    } else {\n        CHECK(emit_body(&c, out, BUL_BLIT_COMPUTER_LIGHT,')
m('render-light-else-test', 'predicate', '    } else if (object->light != 0) {', '    } else if (object->light == 0) {')
m('render-player-light-src', 'field', 'BUL_B_PLAYER_LIGHT_ON, BUL_B_PLAYER_LIGHT, vx', 'BUL_B_COMPUTER_LIGHT_ON, BUL_B_PLAYER_LIGHT, vx')
m('render-computer-light-off-backdrop', 'field', 'BUL_BLIT_COMPUTER_LIGHT_OFF, 0, 1,', 'BUL_BLIT_COMPUTER_LIGHT_OFF, 0, 0,')
m('render-computer-light-src', 'field', 'BUL_B_COMPUTER_LIGHT_ON, BUL_B_COMPUTER_LIGHT, vx', 'BUL_B_PLAYER_LIGHT_ON, BUL_B_COMPUTER_LIGHT, vx')
m('render-player-light-off-backdrop', 'field', 'BUL_BLIT_PLAYER_LIGHT_OFF, 0, 1,', 'BUL_BLIT_PLAYER_LIGHT_OFF, 0, 0,')
m('render-pass-test', 'predicate', 'if (object->mode == 0 || object->mode == 2) {\n        CHECK(emit_body(&c, out, BUL_BLIT_PASS_DISABLED', 'if (object->mode == 0) {\n        CHECK(emit_body(&c, out, BUL_BLIT_PASS_DISABLED')
m('render-pass-disabled-src', 'field', 'BUL_B_PASS_DISABLED, BUL_B_BUTTON_RECT + 16u, vx', 'BUL_B_PASS_DISABLED, BUL_B_BUTTON_RECT, vx')
m('render-pass-enabled-backdrop', 'field', 'BUL_BLIT_PASS_ENABLED, 0, 1,', 'BUL_BLIT_PASS_ENABLED, 0, 0,')
m('render-anim-test', 'predicate', 'if (object->anim_active != 0) {\n        const int16_t k', 'if (1) {\n        const int16_t k')
m('render-button-down-test', 'predicate', 'if (object->button_down != 0) {', 'if (object->button_down == 0) {')
m('render-button-down-src', 'field', 'BUL_B_BUTTON_DOWN_IMAGE + (size_t)k * 16u', 'BUL_B_BUTTON_DOWN_IMAGE + (size_t)k * 32u')
m('render-button-down-dst', 'field', 'BUL_B_BUTTON_RECT + (size_t)k * 16u, vx, vy));\n        } else {', 'BUL_B_BUTTON_RECT, vx, vy));\n        } else {')
m('render-button-up-backdrop', 'field', 'BUL_BLIT_BUTTON_UP, k, 1,', 'BUL_BLIT_BUTTON_UP, k, 0,')
m('render-button-up-clear', 'missing-effect', '            object->anim_active = 0;', '            ;')
m('render-finish-kind', 'predicate', 'if (object->finish_kind == 0) {\n        if (object->state != BUL_STATE_SCORE', 'if (object->finish_kind != 0) {\n        if (object->state != BUL_STATE_SCORE')
m('render-player-piece-test', 'predicate', 'object->state != BUL_STATE_SCORE || object->side == 0', 'object->state != BUL_STATE_SCORE && object->side == 0')
m('render-player-piece-side', 'predicate', 'object->state != BUL_STATE_SCORE || object->side == 0', 'object->state != BUL_STATE_SCORE || object->side == 1')
m('render-computer-piece-test', 'predicate', 'object->state != BUL_STATE_SCORE || object->side == 1', 'object->state != BUL_STATE_SCORE && object->side == 1')
m('render-computer-piece-side', 'predicate', 'object->state != BUL_STATE_SCORE || object->side == 1', 'object->state != BUL_STATE_SCORE || object->side == 0')
m('render-player-piece-src', 'field', 'BUL_BLIT_PLAYER_PIECE, 0, 0, &object->image_player, &object->cur_player', 'BUL_BLIT_PLAYER_PIECE, 0, 0, &object->image_player, &object->cur_computer')
m('render-computer-piece-src', 'field', 'BUL_BLIT_COMPUTER_PIECE, 0, 0, &object->image_computer, &object->cur_computer', 'BUL_BLIT_COMPUTER_PIECE, 0, 0, &object->image_player, &object->cur_computer')
m('render-moving-test', 'predicate', 'if (object->moving.right != 0) {', 'if (object->moving.bottom != 0) {')
m('render-moving-clear', 'missing-effect', 'memset(&object->moving, 0, sizeof object->moving);', ';')
m('render-clear-test', 'predicate', 'if (object->state == BUL_STATE_RESET_WAIT) {', 'if (object->state != BUL_STATE_RESET_WAIT) {')
m('render-clear-count', 'arith', 'for (int i = 0; i < 4; ++i) CHECK(emit_erase(&c, out, BUL_BLIT_CLEAR_PLAYER + i', 'for (int i = 0; i < 3; ++i) CHECK(emit_erase(&c, out, BUL_BLIT_CLEAR_PLAYER + i')
m('render-clear-rect', 'field', '&object->clear[i], vx, vy)', '&object->clear[3 - i], vx, vy)')
m('pair-view', 'field', 'e->dst = shifted(rect, vx, vy); /* 0x45b568 */', 'e->dst = shifted(rect, vy, vx); /* 0x45b568 */')
m('pair-src', 'field', '    e->src = *src;', '    e->src = *rect;')
m('pair-index', 'field', 'fx(c, BUL_FX_BLIT, kind, index);', 'fx(c, BUL_FX_BLIT, kind, index + 1);')
m('pair-overflow', 'validate', 'if (out->count >= BUL_MAX_BLITS) {', 'if (out->count > BUL_MAX_BLITS) {')
m('shift-top', 'field', 's.top = add32(r->top, vy);', 's.top = add32(r->top, vx);')
m('shift-right', 'field', 's.right = add32(r->right, vx);', 's.right = add32(r->right, vy);')
m('shift-bottom', 'field', 's.bottom = add32(r->bottom, vy);', 's.bottom = add32(r->bottom, vx);')
m('shift-left', 'field', 's.left = add32(r->left, vx);', 's.left = add32(r->left, vy);')
m('erase-backdrop', 'field', 'return emit_pair(c, out, kind, 0, 1, r, r, vx, vy);', 'return emit_pair(c, out, kind, 0, 0, r, r, vx, vy);')
m('rd-s16-sign', 'sign', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));', 'return (int16_t)(uint8_t)(b[off] | (b[off + 1] << 8));')
m('rd-rect-top', 'field', 'r->top = rd_s32(b, off + 4);', 'r->top = rd_s32(b, off + 8);')
m('rd-rect-bottom', 'field', 'r->bottom = rd_s32(b, off + 12);', 'r->bottom = rd_s32(b, off + 8);')
m('add16-wrap', 'arith', 'return (int16_t)(uint16_t)((uint32_t)(uint16_t)a + (uint32_t)(uint16_t)b);', 'return (int16_t)((int32_t)a + (int32_t)b);')

# Mutants proved equivalent by reading the code and the original: they cannot change any observable behaviour in a state a loader-built
# body or a game path produces, so a surviving run is the expected result. They are reported separately and never count as killed.
EQUIVALENT = {
    'bodyrect-upper-bound': 'native bound: the largest index any caller passes is 14 for the 15 position slots (positions are 1..M <= 15) and 5 for the '
                            '6 piece slots (count <= N <= 6), never equal to the bound itself',
    'p0-slot-negative': 'the driver and the engine allocator never answer a negative slot without an error (host failures are K6 and the allocator returns '
                        'one of 0x18..0x3f); slot -1 with a success answer is unreachable',
    'pair-overflow': 'native bound on the blit list: the largest list the original produces is below 64 entries, the bound is never reached',
    'validate-positions-low': 'M == 0 is refused anyway by the start-position test of the same validator (both start positions must lie in 1..M, '
                              'which is empty for M == 0); the two bounds agree for every body',
    'score-player-eq': 'a score never exceeds N at the test: phase 1 refuses objects with a score above N (K2) and every point is followed by this check '
                       'in state 6, which ends the game at N; == and >= agree on every reachable state',
    'idle-pass-button-down': 'the button_down store in the pass branch repeats the store `o->button_down = 0` made at the top of the same deadline block '
                             'and nothing in between (caption_pick) touches the field',
    'add16-wrap': 'the int32 sum converted to int16 is the same modulo-2^16 wrap as the explicit uint16 arithmetic on the compiler in use '
                  '(the C conversion is implementation-defined and gcc / clang wrap)',
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
    work_root = PROJECT.parent.parent / 'work' / 'rt59'
    work_root.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='da_mut_', dir=str(work_root)))
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
