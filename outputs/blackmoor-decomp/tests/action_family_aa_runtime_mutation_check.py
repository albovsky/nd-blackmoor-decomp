#!/usr/bin/env python3
"""RT-52 mutation check for the raw-0xaa oracle.

Every mutant is a one-site textual edit of a COPY of src/action_family_aa_runtime.c (the project file is never touched). Each mutant is
built into a driver library and run through the original-x86 oracle (action_family_aa_runtime_original_oracle.py, `--src DIR`). A mutant
is KILLED when the oracle reports at least one mismatch against the unmodified GAME.EXE image (or one of its native-only refusal
checks fails); it SURVIVES when the oracle still reports 0 mismatches; it is INVALID if it does not compile or the edit site is not
found the stated number of times (invalid mutants never count as killed).

Usage:  python3 action_family_aa_runtime_mutation_check.py [--stage quick|full] [--only NAME] [--jobs N] [--result FILE]
Stage `quick` runs the oracle's --quick-only subset (plus the native refusal checks); survivors are re-run on the full scenario set
(--stage full runs every mutant on the full set). Mutants run in parallel, one single-process oracle per mutant (--jobs, default 4).
Equivalent mutants (EQUIVALENT below, each with a reason) are reported separately and are not counted in the kill rate.
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
ORACLE = HERE / 'action_family_aa_runtime_original_oracle.py'
KERNEL = 'action_family_aa_runtime.c'

# (name, class, old text, new text, expected occurrences of old text, index of the occurrence to edit)
M = []


def m(name, cls, old, new, count=1, which=0):
    M.append((name, cls, old, new, count, which))


# ---- the "NO SOUND\0" test (repe cmpsb, 9 bytes)
m('nosound-8-bytes', 'compare', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8) == 0;')
m('nosound-case', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'n', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}")
m('nosound-last-char', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'E', 0}")
m('nosound-inverted', 'predicate', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k) != 0;')
# ---- native body validation (checked by the refusal checks)
m('validate-length-lt', 'validate', 'length != ALC_BODY_BYTES)', 'length < ALC_BODY_BYTES)')
m('validate-name-short', 'validate', 'memchr(body, 0, ALC_NAME_BYTES) == NULL', 'memchr(body, 0, ALC_NAME_BYTES - 1) == NULL')
m('validate-button-sound-skipped', 'validate', 'else if (memchr(body + B_BUTTON_SOUND, 0, ALC_NAME_BYTES) == NULL)', 'else if (0)')
m('validate-final-sound-skipped', 'validate', 'else if (memchr(body + B_FINAL_SOUND, 0, ALC_NAME_BYTES) == NULL)', 'else if (0)')
m('validate-button-sound-short', 'validate', 'memchr(body + B_BUTTON_SOUND, 0, ALC_NAME_BYTES) == NULL', 'memchr(body + B_BUTTON_SOUND, 0, ALC_NAME_BYTES - 1) == NULL')
# ---- the time reader 0x44d711
m('time-am-default', 'constant', 'o->time_am = 1;\n    if (hour == 0 || hour == 0x18) {', 'o->time_am = 0;\n    if (hour == 0 || hour == 0x18) {')
m('time-hour-24-missing', 'compare', 'if (hour == 0 || hour == 0x18) {', 'if (hour == 0) {')
m('time-hour-0-missing', 'compare', 'if (hour == 0 || hour == 0x18) {', 'if (hour == 0x18) {')
m('time-hour-24-as-23', 'constant', 'if (hour == 0 || hour == 0x18) {', 'if (hour == 0 || hour == 0x17) {')
m('time-midnight-hour', 'constant', 'o->time_hour = 0xb;\n    } else if (hour == 0xc) {', 'o->time_hour = 0xa;\n    } else if (hour == 0xc) {')
m('time-noon-test', 'compare', '} else if (hour == 0xc) {', '} else if (hour == 0xd) {')
m('time-noon-hour', 'constant', 'o->time_hour = 0xb;\n        o->time_am = 0;', 'o->time_hour = 0xa;\n        o->time_am = 0;')
m('time-noon-pm-missing', 'missing-effect', 'o->time_hour = 0xb;\n        o->time_am = 0;', 'o->time_hour = 0xb;')
m('time-morning-offset', 'constant', 'o->time_hour = (int16_t)(hour - 1);', 'o->time_hour = (int16_t)(hour);')
m('time-morning-boundary', 'compare', '} else if (hour < 0xc) {', '} else if (hour < 0xb) {')
m('time-afternoon-offset', 'constant', 'o->time_hour = (int16_t)(hour - 0xd);', 'o->time_hour = (int16_t)(hour - 0xc);')
m('time-afternoon-pm-missing', 'missing-effect', 'o->time_hour = (int16_t)(hour - 0xd);\n        o->time_am = 0;', 'o->time_hour = (int16_t)(hour - 0xd);')
m('time-q0-upper', 'compare', 'if (minute >= 0 && minute <= 0xf)', 'if (minute >= 0 && minute < 0xf)')
m('time-q0-lower', 'compare', 'if (minute >= 0 && minute <= 0xf)', 'if (minute > 0 && minute <= 0xf)')
m('time-q0-wide', 'compare', 'if (minute >= 0 && minute <= 0xf)', 'if (minute >= -1 && minute <= 0xf)')
m('time-q1-lower', 'compare', 'else if (minute >= 0x10 && minute <= 0x1e)', 'else if (minute >= 0x11 && minute <= 0x1e)')
m('time-q1-upper', 'compare', 'else if (minute >= 0x10 && minute <= 0x1e)', 'else if (minute >= 0x10 && minute <= 0x1f)')
m('time-q2-lower', 'compare', 'else if (minute >= 0x1f && minute <= 0x2d)', 'else if (minute >= 0x1e && minute <= 0x2d)')
m('time-q2-upper', 'compare', 'else if (minute >= 0x1f && minute <= 0x2d)', 'else if (minute >= 0x1f && minute <= 0x2e)')
m('time-q3-lower', 'compare', 'else if (minute >= 0x2e && minute <= 0x3b)', 'else if (minute >= 0x2d && minute <= 0x3b)')
m('time-q3-upper', 'compare', 'else if (minute >= 0x2e && minute <= 0x3b)', 'else if (minute >= 0x2e && minute <= 0x3c)')
m('time-q-value-1', 'constant', 'o->time_quarter = 1;', 'o->time_quarter = 2;')
m('time-q-value-3', 'constant', 'o->time_quarter = 3;', 'o->time_quarter = 2;')
m('time-q-out-of-range-reset', 'missing-effect', 'else if (minute >= 0x2e && minute <= 0x3b)\n        o->time_quarter = 3;',
  'else if (minute >= 0x2e && minute <= 0x3b)\n        o->time_quarter = 3;\n    else\n        o->time_quarter = 0;')
m('time-alarm-am-missing', 'missing-effect', 'o->alarm_am = o->time_am;\n    if (o->time_quarter > 0) {', 'if (o->time_quarter > 0) {')
m('time-quarter-test-ge', 'compare', 'if (o->time_quarter > 0) {', 'if (o->time_quarter >= 0) {')
m('time-quarter-test-gt1', 'compare', 'if (o->time_quarter > 0) {', 'if (o->time_quarter > 1) {')
m('time-alarm-quarter-in-next-hour', 'constant', 'o->alarm_quarter = 0;\n        o->alarm_hour = (int16_t)(((int32_t)o->time_hour + 1) % 12);',
  'o->alarm_quarter = 1;\n        o->alarm_hour = (int16_t)(((int32_t)o->time_hour + 1) % 12);')
m('time-next-hour-plus', 'constant', 'o->alarm_hour = (int16_t)(((int32_t)o->time_hour + 1) % 12);', 'o->alarm_hour = (int16_t)(((int32_t)o->time_hour + 2) % 12);')
m('time-next-hour-modulus', 'modulus', 'o->alarm_hour = (int16_t)(((int32_t)o->time_hour + 1) % 12);', 'o->alarm_hour = (int16_t)(((int32_t)o->time_hour + 1) % 11);')
m('time-next-hour-unsigned', 'signedness', 'o->alarm_hour = (int16_t)(((int32_t)o->time_hour + 1) % 12);',
  'o->alarm_hour = (int16_t)(((uint32_t)((int32_t)o->time_hour + 1)) % 12u);')
m('time-wrap-toggle-test', 'compare', 'if (o->alarm_hour == 0xb) o->alarm_am = o->time_am == 0;', 'if (o->alarm_hour == 0xa) o->alarm_am = o->time_am == 0;')
m('time-wrap-toggle-missing', 'missing-effect', 'if (o->alarm_hour == 0xb) o->alarm_am = o->time_am == 0;', 'if (o->alarm_hour == 0xb) o->alarm_am = o->time_am;')
m('time-wrap-toggle-from-alarm', 'predicate', 'if (o->alarm_hour == 0xb) o->alarm_am = o->time_am == 0;', 'if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am == 0;')
m('time-exact-quarter', 'predicate', 'o->alarm_quarter = o->time_quarter;\n        o->alarm_hour = o->time_hour;', 'o->alarm_quarter = 0;\n        o->alarm_hour = o->time_hour;')
m('time-exact-hour', 'predicate', 'o->alarm_quarter = o->time_quarter;\n        o->alarm_hour = o->time_hour;', 'o->alarm_quarter = o->time_quarter;\n        o->alarm_hour = 0;')
# ---- the hour step 0x44d8ad
m('step-up-plus', 'constant', 'o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour + 1) % 12);', 'o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour + 2) % 12);')
m('step-up-modulus', 'modulus', 'o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour + 1) % 12);', 'o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour + 1) % 13);')
m('step-up-toggle-test', 'compare', 'if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am == 0;', 'if (o->alarm_hour == 0xa) o->alarm_am = o->alarm_am == 0;')
m('step-up-toggle-missing', 'missing-effect', 'if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am == 0;', 'if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am;')
m('step-down-zero-test', 'compare', 'if (o->alarm_hour == 0)\n            o->alarm_hour = 0xb;', 'if (o->alarm_hour == 1)\n            o->alarm_hour = 0xb;')
m('step-down-wrap-value', 'constant', 'if (o->alarm_hour == 0)\n            o->alarm_hour = 0xb;', 'if (o->alarm_hour == 0)\n            o->alarm_hour = 0xa;')
m('step-down-minus', 'constant', 'o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour - 1) % 12);', 'o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour - 2) % 12);')
m('step-down-modulus', 'modulus', 'o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour - 1) % 12);', 'o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour - 1) % 13);')
m('step-down-toggle-test', 'compare', 'if (o->alarm_hour == 0xa) o->alarm_am = o->alarm_am == 0;', 'if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am == 0;')
m('step-down-toggle-missing', 'missing-effect', 'if (o->alarm_hour == 0xa) o->alarm_am = o->alarm_am == 0;', 'if (o->alarm_hour == 0xa) o->alarm_am = o->alarm_am;')
m('step-direction', 'predicate', 'step_hour(o, o->state == ALC_STATE_INCREASE);', 'step_hour(o, o->state == ALC_STATE_DECREASE);')
# ---- the alarm writer 0x44d946
m('write-pm-test', 'predicate', 'if (o->alarm_am == 0)\n        hour = o->alarm_hour == 0xb', 'if (o->alarm_am != 0)\n        hour = o->alarm_hour == 0xb')
m('write-pm-noon', 'constant', 'hour = o->alarm_hour == 0xb ? 0xc : (int16_t)(o->alarm_hour + 0xd);', 'hour = o->alarm_hour == 0xb ? 0xb : (int16_t)(o->alarm_hour + 0xd);')
m('write-pm-offset', 'constant', '(int16_t)(o->alarm_hour + 0xd);', '(int16_t)(o->alarm_hour + 0xc);')
m('write-pm-wrap-test', 'compare', 'hour = o->alarm_hour == 0xb ? 0xc :', 'hour = o->alarm_hour == 0xa ? 0xc :')
m('write-am-midnight', 'constant', 'hour = o->alarm_hour == 0xb ? 0 : (int16_t)(o->alarm_hour + 1);', 'hour = o->alarm_hour == 0xb ? 0x18 : (int16_t)(o->alarm_hour + 1);')
m('write-am-offset', 'constant', '(int16_t)(o->alarm_hour + 1);\n    world->hour_585d51 = hour;', '(int16_t)(o->alarm_hour + 2);\n    world->hour_585d51 = hour;')
m('write-am-wrap-test', 'compare', 'hour = o->alarm_hour == 0xb ? 0 :', 'hour = o->alarm_hour == 0xa ? 0 :')
m('write-hour-not-stored', 'missing-effect', 'world->hour_585d51 = hour;\n    fx(host, ALC_FX_HOUR_STORE, hour, 0);', 'fx(host, ALC_FX_HOUR_STORE, hour, 0);')
m('write-minute-not-cleared', 'missing-effect', 'world->minute_585d4f = 0;\n    fx(host, ALC_FX_MINUTE_STORE, 0, 0);', 'fx(host, ALC_FX_MINUTE_STORE, 0, 0);')
m('write-minute-value', 'constant', 'world->minute_585d4f = 0;\n    fx(host, ALC_FX_MINUTE_STORE, 0, 0);', 'world->minute_585d4f = 1;\n    fx(host, ALC_FX_MINUTE_STORE, 0, 0);')
m('write-hour-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_HOUR_STORE, hour, 0);', '(void)0;')
m('write-minute-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_MINUTE_STORE, 0, 0);', '(void)0;')
# ---- the scene block of the finish paths
m('block-scene-none', 'compare', 'if (rd_s16(blk, SB_SCENE) != ALC_NO_SCENE) {', 'if (rd_s16(blk, SB_SCENE) == ALC_NO_SCENE) {')
m('block-scene-offset', 'rect', 't.scene = rd_s16(blk, SB_SCENE);', 't.scene = rd_s16(blk, SB_W1);')
m('block-word1-offset', 'rect', 't.word[0] = rd_s16(blk, SB_W1);', 't.word[0] = rd_s16(blk, SB_W2);')
m('block-word2-offset', 'rect', 't.word[1] = rd_s16(blk, SB_W2);', 't.word[1] = rd_s16(blk, SB_W3);')
m('block-word3-offset', 'rect', 't.word[2] = rd_s16(blk, SB_W3);', 't.word[2] = rd_s16(blk, SB_W1);')
m('block-dword1-offset', 'rect', 't.dword[0] = rd_s32(blk, SB_D1);', 't.dword[0] = rd_s32(blk, SB_D2);')
m('block-dword2-offset', 'rect', 't.dword[1] = rd_s32(blk, SB_D2);', 't.dword[1] = rd_s32(blk, SB_D3);')
m('block-dword3-offset', 'rect', 't.dword[2] = rd_s32(blk, SB_D3);', 't.dword[2] = rd_s32(blk, SB_D1);')
m('block-start-test', 'predicate', 'rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'rd_s16(blk, SB_START) != 0 ? 1 : 0;')
m('block-start-inverted', 'predicate', 'rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'rd_s16(blk, SB_START) == 1 ? 1 : 0;')
m('block-start-unsigned', 'signedness', 'rd_s16(blk, SB_START) != 1 ? 1 : 0;', '(uint16_t)rd_s16(blk, SB_START) != 1 ? 1 : 0;')
m('block-start-offset', 'rect', 'rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'rd_s16(blk, SB_FLAG) != 1 ? 1 : 0;')
m('block-mode-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_ENGINE_MODE, 4, 0);', '(void)0;')
m('block-mode-fx-value', 'constant', 'fx(host, ALC_FX_ENGINE_MODE, 4, 0);', 'fx(host, ALC_FX_ENGINE_MODE, 3, 0);')
m('block-start-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_START_FLAG, world->start_flag_5bb1ca, 0);', '(void)0;')
m('block-xfer-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_XFER_5C39FF, t.word[2], 0);', '(void)0;')
m('block-xfer-fx-order', 'order', 'fx(host, ALC_FX_XFER_5BB599, t.word[0], 0);\n        fx(host, ALC_FX_XFER_5BB595, t.word[1], 0);',
  'fx(host, ALC_FX_XFER_5BB595, t.word[1], 0);\n        fx(host, ALC_FX_XFER_5BB599, t.word[0], 0);')
m('block-flag-none', 'compare', 'if (flag != ALC_NO_FLAG) {', 'if (flag == ALC_NO_FLAG) {')
m('block-flag-offset', 'rect', 'const int16_t flag = rd_s16(blk, SB_FLAG);\n        if (flag != ALC_NO_FLAG) {', 'const int16_t flag = rd_s16(blk, SB_START);\n        if (flag != ALC_NO_FLAG) {')
m('block-flag-value-offset', 'rect', 'HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE]));', 'HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE - 1]));')
m('block-flag-value-fx', 'constant', 'fx(host, ALC_FX_EVENT_FLAG, flag, blk[SB_VALUE]);', 'fx(host, ALC_FX_EVENT_FLAG, flag, 0);')
m('block-flag-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_EVENT_FLAG, flag, blk[SB_VALUE]);', '(void)0;')
m('block-flag-skipped-after-scene', 'missing-effect', 'if (rd_s16(blk, SB_SCENE) != ALC_NO_SCENE) {\n        AlcTransition t;', 'if (rd_s16(blk, SB_SCENE) != ALC_NO_SCENE) {\n        return ALC_OK;\n        AlcTransition t;')
# ---- phase 0 (0x44da58)
m('p0-row-not-stored', 'missing-effect', 'o->row = row;\n    o->active = 1;', 'o->active = 1;')
m('p0-active-not-set', 'missing-effect', 'o->row = row;\n    o->active = 1;', 'o->row = row;')
m('p0-time-not-read', 'missing-effect', 'read_time(o, world);\n    o->dirty = 1;', 'o->dirty = 1;')
m('p0-dirty-not-set', 'missing-effect', 'o->dirty = 1;\n    world->start_flag_5bb1ca = 1;', 'world->start_flag_5bb1ca = 1;')
m('p0-start-flag-zero', 'constant', 'world->start_flag_5bb1ca = 1;\n    fx(host, ALC_FX_START_FLAG, 1, 0);\n    o->restore = 0;', 'world->start_flag_5bb1ca = 0;\n    fx(host, ALC_FX_START_FLAG, 1, 0);\n    o->restore = 0;')
m('p0-start-flag-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_START_FLAG, 1, 0);\n    o->restore = 0;', 'o->restore = 0;')
m('p0-restore-kept', 'missing-effect', 'o->restore = 0;\n    o->state = ALC_STATE_TIME;', 'o->state = ALC_STATE_TIME;')
m('p0-state-kept', 'missing-effect', 'o->state = ALC_STATE_TIME;\n    o->over = 0;', 'o->over = 0;')
m('p0-over-kept', 'missing-effect', 'o->over = 0;\n    HOST(host->alloc_slot', 'HOST(host->alloc_slot')
m('p0-slot-not-stored', 'missing-effect', 'o->slot = slot;\n    fx(host, ALC_FX_SLOT, slot, 0);', 'fx(host, ALC_FX_SLOT, slot, 0);')
m('p0-slot-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SLOT, slot, 0);', '(void)0;')
m('p0-register-skipped', 'missing-effect', 'HOST(host->register_slot(host->context, slot, "ALARM CLOCK OVERLAYS"));', '(void)0;')
m('p0-register-label', 'constant', 'HOST(host->register_slot(host->context, slot, "ALARM CLOCK OVERLAYS"));', 'HOST(host->register_slot(host->context, slot, "ALARM CLOCK OVERLAYZ"));')
m('p0-register-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SLOT_REGISTER, slot, 0);', '(void)0;')
m('p0-load-when-surface-set', 'predicate', 'if (o->surface == 0u) {\n        uint32_t surface = 0;', 'if (o->surface != 0u) {\n        uint32_t surface = 0;')
m('p0-load-always', 'predicate', 'if (o->surface == 0u) {\n        uint32_t surface = 0;', 'if (1) {\n        uint32_t surface = 0;')
m('p0-load-needs-name', 'predicate', 'if (o->surface == 0u) {\n        uint32_t surface = 0;', 'if (o->surface == 0u && body[0] != 0) {\n        uint32_t surface = 0;')
m('p0-load-name-offset', 'rect', 'host->load_surface(host->context, (const char *)body, &surface)', 'host->load_surface(host->context, (const char *)body + 1, &surface)')
m('p0-surface-not-stored', 'missing-effect', 'o->surface = surface;\n        fx(host, ALC_FX_SURFACE_LOAD', 'fx(host, ALC_FX_SURFACE_LOAD')
m('p0-load-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SURFACE_LOAD, (int32_t)surface, 0);', '(void)0;')
m('p0-slot-surface-skipped', 'missing-effect', 'HOST(host->set_slot_surface(host->context, slot, o->surface));', '(void)0;')
m('p0-slot-surface-zero', 'constant', 'HOST(host->set_slot_surface(host->context, slot, o->surface));', 'HOST(host->set_slot_surface(host->context, slot, 0u));')
m('p0-slot-surface-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SLOT_SURFACE, slot, (int32_t)o->surface);', '(void)0;')
m('p0-prepare-inverted', 'predicate', 'if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_prepare', 'if (no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_prepare')
m('p0-prepare-always', 'predicate', 'if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_prepare', 'if (1) {\n        HOST(host->sound_prepare')
m('p0-prepare-wrong-record', 'rect', 'HOST(host->sound_prepare(host->context, body + B_BUTTON_SOUND));\n        fx(host, ALC_FX_SOUND_PREPARE, B_BUTTON_SOUND, 0);',
  'HOST(host->sound_prepare(host->context, body + B_FINAL_SOUND));\n        fx(host, ALC_FX_SOUND_PREPARE, B_FINAL_SOUND, 0);')
m('p0-prepare-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SOUND_PREPARE, B_BUTTON_SOUND, 0);', '(void)0;')
m('p0-set-kept', 'missing-effect', 'o->set = 0;\n    o->canceled = 0;\n    return ALC_OK;', 'o->canceled = 0;\n    return ALC_OK;')
m('p0-canceled-kept', 'missing-effect', 'o->canceled = 0;\n    return ALC_OK;\n}\n\n/* 0x44dc17', 'return ALC_OK;\n}\n\n/* 0x44dc17')
m('step-phase0-phase1', 'constant', 'row_phase = 1u;\n            fx(host, ALC_FX_PHASE, 1, 0);', 'row_phase = 2u;\n            fx(host, ALC_FX_PHASE, 1, 0);')
m('step-phase0-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_PHASE, 1, 0);\n            result->initialized = 1u;', 'result->initialized = 1u;')
m('step-initialized-flag', 'missing-effect', 'result->initialized = 1u;', '(void)0;')
# ---- phase 1 (0x44dc17), one case at a time
m('p1-cancel-flag', 'missing-effect', 'o->canceled = 1;\n        *row_phase = 2u;', '*row_phase = 2u;')
m('p1-cancel-phase', 'constant', 'o->canceled = 1;\n        *row_phase = 2u;\n        fx(host, ALC_FX_PHASE, 2, 0);', 'o->canceled = 1;\n        *row_phase = 1u;\n        fx(host, ALC_FX_PHASE, 2, 0);')
m('p1-cancel-fx-dropped', 'missing-effect', 'o->canceled = 1;\n        *row_phase = 2u;\n        fx(host, ALC_FX_PHASE, 2, 0);', 'o->canceled = 1;\n        *row_phase = 2u;')
m('p1-pressed-tick-fx-dropped', 'missing-effect', 'const uint32_t now = host->tick(host->context);\n        fx(host, ALC_FX_TICK, (int32_t)now, 0);\n        if (now >= o->press_deadline) {',
  'const uint32_t now = host->tick(host->context);\n        if (now >= o->press_deadline) {')
m('p1-pressed-strict', 'compare', 'if (now >= o->press_deadline) {', 'if (now > o->press_deadline) {')
m('p1-pressed-signed', 'signedness', 'if (now >= o->press_deadline) {', 'if ((int32_t)now >= (int32_t)o->press_deadline) {')
m('p1-pressed-reversed', 'compare', 'if (now >= o->press_deadline) {', 'if (now <= o->press_deadline) {')
m('p1-pressed-wrong-deadline', 'rect', 'if (now >= o->press_deadline) {', 'if (now >= o->final_deadline) {')
m('p1-pressed-state-not-button', 'missing-effect', 'o->state = o->button;\n            o->restore = 1;', 'o->restore = 1;')
m('p1-pressed-state-to-alarm', 'constant', 'o->state = o->button;\n            o->restore = 1;', 'o->state = ALC_STATE_ALARM;\n            o->restore = 1;')
m('p1-pressed-restore-missing', 'missing-effect', 'o->state = o->button;\n            o->restore = 1;', 'o->state = o->button;')
m('p1-idle-dirty-missing', 'missing-effect', 'case ALC_STATE_ALARM:\n        o->dirty = 1;\n        break;', 'case ALC_STATE_ALARM:\n        break;')
m('p1-time-state-split', 'predicate', 'case ALC_STATE_TIME:\n    case ALC_STATE_ALARM:\n        o->dirty = 1;', 'case ALC_STATE_ALARM:\n        o->dirty = 1;')
m('p1-step-state-reset', 'constant', 'o->dirty = 1;\n        o->state = ALC_STATE_ALARM;\n        break;', 'o->dirty = 1;\n        o->state = ALC_STATE_TIME;\n        break;')
m('p1-step-dirty-missing', 'missing-effect', 'step_hour(o, o->state == ALC_STATE_INCREASE);\n        o->dirty = 1;', 'step_hour(o, o->state == ALC_STATE_INCREASE);')
m('p1-set-tick-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_TICK, (int32_t)now, 0);\n        o->final_deadline =', 'o->final_deadline =')
m('p1-set-delay-1000', 'constant', '(uint32_t)((int32_t)rd_s16(body, B_FINAL_DELAY) * 1000);', '(uint32_t)((int32_t)rd_s16(body, B_FINAL_DELAY) * 100);')
m('p1-set-delay-offset', 'rect', 'rd_s16(body, B_FINAL_DELAY) * 1000', 'rd_s16(body, B_FINAL_DELAY + 2) * 1000')
m('p1-set-delay-unsigned', 'signedness', '(uint32_t)((int32_t)rd_s16(body, B_FINAL_DELAY) * 1000);', '(uint32_t)((int32_t)(uint16_t)rd_s16(body, B_FINAL_DELAY) * 1000);')
m('p1-set-flag-missing', 'missing-effect', 'o->set = 1;\n        o->state = ALC_STATE_WAIT_SET;', 'o->state = ALC_STATE_WAIT_SET;')
m('p1-set-state', 'constant', 'o->set = 1;\n        o->state = ALC_STATE_WAIT_SET;', 'o->set = 1;\n        o->state = ALC_STATE_FINAL_SOUND;')
m('p1-wait-tick-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_TICK, (int32_t)now, 0);\n        if (now >= o->final_deadline) {', 'if (now >= o->final_deadline) {')
m('p1-wait-strict', 'compare', 'if (now >= o->final_deadline) {', 'if (now > o->final_deadline) {')
m('p1-wait-signed', 'signedness', 'if (now >= o->final_deadline) {', 'if ((int32_t)now >= (int32_t)o->final_deadline) {')
m('p1-wait-wrong-deadline', 'rect', 'if (now >= o->final_deadline) {', 'if (now >= o->press_deadline) {')
m('p1-wait-sound-inverted', 'predicate', 'if (!no_sound(body + B_FINAL_SOUND)) {\n                const int16_t ch', 'if (no_sound(body + B_FINAL_SOUND)) {\n                const int16_t ch')
m('p1-wait-sound-ignored', 'predicate', 'if (!no_sound(body + B_FINAL_SOUND)) {\n                const int16_t ch', 'if (1) {\n                const int16_t ch')
m('p1-wait-sound-tests-button-record', 'rect', 'if (!no_sound(body + B_FINAL_SOUND)) {\n                const int16_t ch', 'if (!no_sound(body + B_BUTTON_SOUND)) {\n                const int16_t ch')
m('p1-wait-channel-offset', 'rect', 'const int16_t ch = rd_s16(body, B_FINAL_CHANNEL);\n                HOST(host->sound_prepare', 'const int16_t ch = rd_s16(body, B_BUTTON_CHANNEL);\n                HOST(host->sound_prepare')
m('p1-wait-prepare-record', 'rect', 'HOST(host->sound_prepare(host->context, body + B_FINAL_SOUND));\n                fx(host, ALC_FX_SOUND_PREPARE, B_FINAL_SOUND, 0);',
  'HOST(host->sound_prepare(host->context, body + B_BUTTON_SOUND));\n                fx(host, ALC_FX_SOUND_PREPARE, B_BUTTON_SOUND, 0);')
m('p1-wait-prepare-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SOUND_PREPARE, B_FINAL_SOUND, 0);', '(void)0;')
m('p1-wait-play-skipped', 'missing-effect', 'HOST(host->sound_play(host->context, ch));\n                fx(host, ALC_FX_SOUND_PLAY, ch, 0);\n                o->state = ALC_STATE_FINAL_SOUND;',
  'o->state = ALC_STATE_FINAL_SOUND;')
m('p1-wait-play-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SOUND_PLAY, ch, 0);\n                o->state = ALC_STATE_FINAL_SOUND;', 'o->state = ALC_STATE_FINAL_SOUND;')
m('p1-wait-state-final', 'constant', 'o->state = ALC_STATE_FINAL_SOUND;\n            } else {', 'o->state = ALC_STATE_SET;\n            } else {')
m('p1-wait-nosound-phase', 'constant', '} else {\n                *row_phase = 2u;\n                fx(host, ALC_FX_PHASE, 2, 0);\n            }\n        }\n        break;\n    }\n    case ALC_STATE_FINAL_SOUND:',
  '} else {\n                *row_phase = 1u;\n                fx(host, ALC_FX_PHASE, 2, 0);\n            }\n        }\n        break;\n    }\n    case ALC_STATE_FINAL_SOUND:')
m('p1-wait-nosound-fx-dropped', 'missing-effect', '} else {\n                *row_phase = 2u;\n                fx(host, ALC_FX_PHASE, 2, 0);\n            }',
  '} else {\n                *row_phase = 2u;\n            }')
m('p1-final-channel-offset', 'rect', 'case ALC_STATE_FINAL_SOUND: {\n        const int16_t ch = rd_s16(body, B_FINAL_CHANNEL);', 'case ALC_STATE_FINAL_SOUND: {\n        const int16_t ch = rd_s16(body, B_BUTTON_CHANNEL);')
m('p1-final-busy-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_stop', 'if (busy == 0) {\n            HOST(host->sound_stop')
m('p1-final-busy-inverted', 'predicate', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_stop', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy != 0) {\n            HOST(host->sound_stop')
m('p1-final-busy-low-byte', 'predicate', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_stop', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if ((busy & 0xff) == 0) {\n            HOST(host->sound_stop')
m('p1-final-busy-signed', 'signedness', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_stop', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy <= 0) {\n            HOST(host->sound_stop')
m('p1-final-stop-record', 'rect', 'HOST(host->sound_stop(host->context, body + B_FINAL_SOUND));\n            fx(host, ALC_FX_SOUND_STOP, B_FINAL_SOUND, 0);', 'HOST(host->sound_stop(host->context, body + B_BUTTON_SOUND));\n            fx(host, ALC_FX_SOUND_STOP, B_BUTTON_SOUND, 0);')
m('p1-final-stop-skipped', 'missing-effect', 'HOST(host->sound_stop(host->context, body + B_FINAL_SOUND));\n            fx(host, ALC_FX_SOUND_STOP, B_FINAL_SOUND, 0);', '(void)0;')
m('p1-final-stop-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SOUND_STOP, B_FINAL_SOUND, 0);', '(void)0;')
m('p1-final-phase', 'constant', 'fx(host, ALC_FX_SOUND_STOP, B_FINAL_SOUND, 0);\n            *row_phase = 2u;', 'fx(host, ALC_FX_SOUND_STOP, B_FINAL_SOUND, 0);\n            *row_phase = 1u;')
m('p1-state-8-guard', 'compare', 'switch (o->state) {\n    case ALC_STATE_CANCEL:', 'switch (o->state & 7) {\n    case ALC_STATE_CANCEL:')
# ---- phase 2 (0x44ddc4)
m('p2-start-flag-zero', 'constant', 'world->start_flag_5bb1ca = 1;\n    fx(host, ALC_FX_START_FLAG, 1, 0);\n    if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop',
  'world->start_flag_5bb1ca = 0;\n    fx(host, ALC_FX_START_FLAG, 1, 0);\n    if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop')
m('p2-start-flag-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_START_FLAG, 1, 0);\n    if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop', 'if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop')
m('p2-stop-inverted', 'predicate', 'if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop', 'if (no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop')
m('p2-stop-always', 'predicate', 'if (!no_sound(body + B_BUTTON_SOUND)) {\n        HOST(host->sound_stop', 'if (1) {\n        HOST(host->sound_stop')
m('p2-stop-final-record', 'rect', 'HOST(host->sound_stop(host->context, body + B_BUTTON_SOUND));\n        fx(host, ALC_FX_SOUND_STOP, B_BUTTON_SOUND, 0);',
  'HOST(host->sound_stop(host->context, body + B_FINAL_SOUND));\n        fx(host, ALC_FX_SOUND_STOP, B_FINAL_SOUND, 0);')
m('p2-stop-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SOUND_STOP, B_BUTTON_SOUND, 0);', '(void)0;')
m('p2-cancel-test', 'predicate', 'if (o->canceled != 0) return apply_block(body + B_CANCEL_BLOCK, world, host);', 'if (o->canceled == 0) return apply_block(body + B_CANCEL_BLOCK, world, host);')
m('p2-cancel-block-offset', 'rect', 'return apply_block(body + B_CANCEL_BLOCK, world, host);', 'return apply_block(body + B_SET_BLOCK, world, host);')
m('p2-cancel-writes-alarm', 'predicate', 'if (o->canceled != 0) return apply_block(body + B_CANCEL_BLOCK, world, host);',
  'if (o->canceled != 0) { write_alarm(o, world, host); return apply_block(body + B_CANCEL_BLOCK, world, host); }')
m('p2-set-test', 'predicate', 'if (o->set != 0) {\n        write_alarm(o, world, host);', 'if (o->set == 0) {\n        write_alarm(o, world, host);')
m('p2-set-no-alarm-write', 'missing-effect', 'write_alarm(o, world, host);\n        return apply_block(body + B_SET_BLOCK, world, host);', 'return apply_block(body + B_SET_BLOCK, world, host);')
m('p2-set-block-offset', 'rect', 'return apply_block(body + B_SET_BLOCK, world, host);', 'return apply_block(body + B_CANCEL_BLOCK, world, host);')
m('p2-set-alarm-write-after-block', 'order', 'write_alarm(o, world, host);\n        return apply_block(body + B_SET_BLOCK, world, host);',
  'AlcObject *d = o; int rc = apply_block(body + B_SET_BLOCK, world, host); write_alarm(d, world, host); return rc;')
m('step-complete-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_COMPLETE, object->row, 0);', '(void)0;')
m('step-complete-flag', 'missing-effect', 'result->completed = 1u;', '(void)0;')
m('step-complete-phase', 'constant', 'row_phase = 0u; /* 0x42ba3a stores phase 0 */', 'row_phase = 2u; /* 0x42ba3a stores phase 0 */')
m('step-cleanup-skipped', 'missing-effect', 'rc = alc_cleanup(object, host);', 'rc = ALC_OK;')
m('step-other-phase-acts', 'predicate', 'rc = ALC_OK; /* 0x44da53: any other phase falls out of the switch */', 'rc = phase1(object, body, &row_phase, host);')
m('step-phase1-row-test', 'native', 'if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xaa-phase-1-without-init";',
  'if (object->active == 0) {\n            if (failure != NULL) *failure = "0xaa-phase-1-without-init";')
m('step-phase2-row-test', 'native', 'if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xaa-phase-2-without-init";',
  'if (object->active == 0) {\n            if (failure != NULL) *failure = "0xaa-phase-2-without-init";')
m('step-flag-precheck-skipped', 'native', 'if (flag != ALC_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (0) {')
m('step-flag-precheck-cancel-only', 'native', 'const uint8_t *blk = object->canceled != 0 ? body + B_CANCEL_BLOCK : (object->set != 0 ? body + B_SET_BLOCK : NULL);',
  'const uint8_t *blk = object->canceled != 0 ? body + B_CANCEL_BLOCK : NULL;')
m('step-flag-precheck-wrong-block', 'native', 'const uint8_t *blk = object->canceled != 0 ? body + B_CANCEL_BLOCK : (object->set != 0 ? body + B_SET_BLOCK : NULL);',
  'const uint8_t *blk = object->canceled != 0 ? body + B_SET_BLOCK : (object->set != 0 ? body + B_CANCEL_BLOCK : NULL);')
m('step-row-negative-accepted', 'native', 'if (row < 0) {\n            if (failure != NULL) *failure = "0xaa-row";', 'if (row < -1) {\n            if (failure != NULL) *failure = "0xaa-row";')
# ---- pointer 0x44d28c
m('pointer-x-not-truncated', 'signedness', 'x = (int16_t)x; /* movsx word */', '(void)0;')
m('pointer-y-not-truncated', 'signedness', 'y = (int16_t)y;', '(void)0;')
m('pointer-inactive-clears-nothing', 'missing-effect', 'if (object->active == 0) {\n        object->dirty = 0;', 'if (object->active == 0) {')
m('pointer-active-ignored', 'predicate', 'if (object->active == 0) {\n        object->dirty = 0;', 'if (0) {\n        object->dirty = 0;')
m('pointer-dirty-set-missing', 'missing-effect', 'object->dirty = 1;\n    if (x > rd_s32(body, B_INCREASE_BTN + 8)', 'if (x > rd_s32(body, B_INCREASE_BTN + 8)')
m('pointer-gate-right', 'compare', 'if (x > rd_s32(body, B_INCREASE_BTN + 8)', 'if (x >= rd_s32(body, B_INCREASE_BTN + 8)')
m('pointer-gate-right-field', 'rect', 'if (x > rd_s32(body, B_INCREASE_BTN + 8)', 'if (x > rd_s32(body, B_DECREASE_BTN + 8)')
m('pointer-gate-bottom', 'compare', '|| y > rd_s32(body, B_CANCEL_BTN + 12)', '|| y >= rd_s32(body, B_CANCEL_BTN + 12)')
m('pointer-gate-bottom-field', 'rect', '|| y > rd_s32(body, B_CANCEL_BTN + 12)', '|| y > rd_s32(body, B_SET_BTN + 12)')
m('pointer-gate-left', 'compare', '|| x < rd_s32(body, B_TIME_BTN)) {', '|| x <= rd_s32(body, B_TIME_BTN)) {')
m('pointer-gate-left-field', 'rect', '|| x < rd_s32(body, B_TIME_BTN)) {', '|| x < rd_s32(body, B_ALARM_BTN)) {')
m('pointer-gate-over-kept', 'missing-effect', 'object->over = 0;\n        return ALC_OK;\n    }\n    object->over = 1;', 'return ALC_OK;\n    }\n    object->over = 1;')
m('pointer-over-not-set', 'missing-effect', 'object->over = 1;\n    if (object->state == ALC_STATE_TIME', 'if (object->state == ALC_STATE_TIME')
m('pointer-alarm-state', 'predicate', 'if (object->state == ALC_STATE_TIME && in_rect(body, B_ALARM_BTN, x, y)) {', 'if (object->state == ALC_STATE_ALARM && in_rect(body, B_ALARM_BTN, x, y)) {')
m('pointer-alarm-any-state', 'predicate', 'if (object->state == ALC_STATE_TIME && in_rect(body, B_ALARM_BTN, x, y)) {', 'if (in_rect(body, B_ALARM_BTN, x, y)) {')
m('pointer-alarm-rect', 'rect', 'if (object->state == ALC_STATE_TIME && in_rect(body, B_ALARM_BTN, x, y)) {', 'if (object->state == ALC_STATE_TIME && in_rect(body, B_TIME_BTN, x, y)) {')
m('pointer-alarm-button', 'constant', 'press(object, body, 1, out);\n        out->hit = 1u;\n        return ALC_OK;\n    }\n    if (object->state == ALC_STATE_ALARM) {', 'press(object, body, 0, out);\n        out->hit = 1u;\n        return ALC_OK;\n    }\n    if (object->state == ALC_STATE_ALARM) {')
m('pointer-alarm-state-test', 'predicate', 'if (object->state == ALC_STATE_ALARM) {\n        static const', 'if (object->state != ALC_STATE_TIME) {\n        static const')
m('pointer-alarm-state-any', 'predicate', 'if (object->state == ALC_STATE_ALARM) {\n        static const', 'if (1) {\n        static const')
m('pointer-order-time-rect', 'rect', '{B_TIME_BTN, 0}, {B_INCREASE_BTN, 3}', '{B_ALARM_BTN, 0}, {B_INCREASE_BTN, 3}')
m('pointer-order-time-button', 'constant', '{B_TIME_BTN, 0}, {B_INCREASE_BTN, 3}', '{B_TIME_BTN, 1}, {B_INCREASE_BTN, 3}')
m('pointer-order-incr-button', 'constant', '{B_INCREASE_BTN, 3}, {B_DECREASE_BTN, 4}', '{B_INCREASE_BTN, 4}, {B_DECREASE_BTN, 4}')
m('pointer-order-decr-button', 'constant', '{B_DECREASE_BTN, 4}, {B_SET_BTN, 6}', '{B_DECREASE_BTN, 3}, {B_SET_BTN, 6}')
m('pointer-order-set-button', 'constant', '{B_SET_BTN, 6}};', '{B_SET_BTN, 5}};')
m('pointer-order-set-rect', 'rect', '{B_SET_BTN, 6}};', '{B_CANCEL_BTN, 6}};')
m('pointer-order-decr-rect', 'rect', '{B_DECREASE_BTN, 4}, {B_SET_BTN, 6}', '{B_INCREASE_BTN, 4}, {B_SET_BTN, 6}')
m('pointer-order-reversed', 'order', 'for (size_t i = 0; i < sizeof(order) / sizeof(order[0]); ++i) {', 'for (size_t i = sizeof(order) / sizeof(order[0]); i-- > 0;) {')
m('pointer-order-last-missing', 'loop-bound', 'for (size_t i = 0; i < sizeof(order) / sizeof(order[0]); ++i) {', 'for (size_t i = 0; i + 1 < sizeof(order) / sizeof(order[0]); ++i) {')
m('pointer-order-first-missing', 'loop-bound', 'for (size_t i = 0; i < sizeof(order) / sizeof(order[0]); ++i) {', 'for (size_t i = 1; i < sizeof(order) / sizeof(order[0]); ++i) {')
m('pointer-cancel-rect', 'rect', 'if (in_rect(body, B_CANCEL_BTN, x, y)) {\n        press(object, body, 8, out);', 'if (in_rect(body, B_SET_BTN, x, y)) {\n        press(object, body, 8, out);')
m('pointer-cancel-button', 'constant', 'press(object, body, 8, out);', 'press(object, body, 7, out);')
m('pointer-cancel-not-claimed', 'missing-effect', 'press(object, body, 8, out);\n        out->hit = 1u;', 'press(object, body, 8, out);')
m('pointer-display-minute', 'rect', 'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {',
  'if (in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {')
m('pointer-display-hour', 'rect', 'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {',
  'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {')
m('pointer-display-light', 'rect', 'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {',
  'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y)) {')
m('pointer-display-ampm', 'rect', 'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {',
  'if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y) || in_rect(body, B_AMPM_DST, x, y)) {')
m('pointer-display-wrong-light', 'rect', 'in_rect(body, B_LIGHT_DST, x, y)) {\n        object->dirty = 1;', 'in_rect(body, B_AMPM_DST, x, y)) {\n        object->dirty = 1;')
m('pointer-display-claims', 'predicate', 'object->dirty = 1;\n        return ALC_OK;\n    }\n    object->dirty = 0;', 'object->dirty = 1;\n        out->hit = 1u;\n        return ALC_OK;\n    }\n    object->dirty = 0;')
m('pointer-miss-dirty-kept', 'missing-effect', 'object->dirty = 0;\n    return ALC_OK;\n}\n\nint alc_click', 'return ALC_OK;\n}\n\nint alc_click')
m('rect-top-edge', 'compare', 'return rd_s32(body, rect + 4) <= y &&', 'return rd_s32(body, rect + 4) < y &&')
m('rect-bottom-edge', 'compare', 'y <= rd_s32(body, rect + 12) &&', 'y < rd_s32(body, rect + 12) &&')
m('rect-left-edge', 'compare', 'rd_s32(body, rect) <= x &&', 'rd_s32(body, rect) < x &&')
m('rect-right-edge', 'compare', 'x <= rd_s32(body, rect + 8);', 'x < rd_s32(body, rect + 8);')
m('rect-top-field', 'rect', 'return rd_s32(body, rect + 4) <= y &&', 'return rd_s32(body, rect + 12) <= y &&')
m('rect-xy-swapped', 'rect', 'return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&\n           x <= rd_s32(body, rect + 8);',
  'return rd_s32(body, rect + 4) <= x && x <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= y &&\n           y <= rd_s32(body, rect + 8);')
m('rect-unsigned', 'signedness', 'return rd_s32(body, rect + 4) <= y &&', 'return (uint32_t)rd_s32(body, rect + 4) <= (uint32_t)y &&')
m('press-cursor-kind-offset', 'rect', 'out->cursor_kind = rd_s16(body, B_CURSOR_KIND);', 'out->cursor_kind = rd_s16(body, B_PRESS_DELAY);')
m('press-cursor-kind-unsigned', 'signedness', 'out->cursor_kind = rd_s16(body, B_CURSOR_KIND);', 'out->cursor_kind = (uint16_t)rd_s16(body, B_CURSOR_KIND);')
m('press-cursor-sub', 'constant', 'out->cursor_sub = 1;', 'out->cursor_sub = 0;')
m('press-candidate', 'constant', 'out->candidate = ALC_CANDIDATE_BUTTON;', 'out->candidate = ALC_CANDIDATE_BUTTON + 1;')
m('press-dirty-missing', 'missing-effect', 'out->candidate = ALC_CANDIDATE_BUTTON;\n    o->dirty = 1;', 'out->candidate = ALC_CANDIDATE_BUTTON;')
m('press-button-not-stored', 'missing-effect', 'o->button = button;\n}', '(void)button;\n}')
m('press-cursor-not-written', 'missing-effect', 'out->cursor_written = 1u;', '(void)0;')
# ---- click 0x44d624
m('click-active-ignored', 'predicate', 'if (!(object->active != 0 && object->canceled == 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;',
  'if (!(object->canceled == 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;')
m('click-canceled-ignored', 'predicate', 'if (!(object->active != 0 && object->canceled == 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;',
  'if (!(object->active != 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;')
m('click-over-ignored', 'predicate', 'if (!(object->active != 0 && object->canceled == 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;',
  'if (!(object->active != 0 && object->canceled == 0 && row_phase == 1u)) return ALC_OK;')
m('click-phase-ignored', 'predicate', 'if (!(object->active != 0 && object->canceled == 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;',
  'if (!(object->active != 0 && object->canceled == 0 && object->over != 0)) return ALC_OK;')
m('click-phase-ge', 'compare', 'object->over != 0 && row_phase == 1u)) return ALC_OK;', 'object->over != 0 && row_phase >= 1u)) return ALC_OK;')
m('click-start-flag-ignored', 'predicate', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {', 'if (!no_sound(body + B_BUTTON_SOUND)) {')
m('click-start-flag-one', 'predicate', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {', 'if (world->start_flag_5bb1ca == 1 && !no_sound(body + B_BUTTON_SOUND)) {')
m('click-sound-name-ignored', 'predicate', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {', 'if (world->start_flag_5bb1ca != 0) {')
m('click-sound-name-inverted', 'predicate', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {', 'if (world->start_flag_5bb1ca != 0 && no_sound(body + B_BUTTON_SOUND)) {')
m('click-sound-name-final-record', 'rect', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {', 'if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_FINAL_SOUND)) {')
m('click-channel-offset', 'rect', 'const int16_t ch = rd_s16(body, B_BUTTON_CHANNEL);', 'const int16_t ch = rd_s16(body, B_FINAL_CHANNEL);')
m('click-busy-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_play', 'if (busy == 0) {\n            HOST(host->sound_play')
m('click-busy-inverted', 'predicate', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_play', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy != 0) {\n            HOST(host->sound_play')
m('click-busy-low-byte', 'predicate', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_play', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if ((busy & 0xff) == 0) {\n            HOST(host->sound_play')
m('click-busy-signed', 'signedness', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy == 0) {\n            HOST(host->sound_play', 'fx(host, ALC_FX_SOUND_BUSY, ch, busy);\n        if (busy <= 0) {\n            HOST(host->sound_play')
m('click-play-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_SOUND_PLAY, ch, 0);\n            out->sound_played = 1u;', 'out->sound_played = 1u;')
m('click-play-flag', 'missing-effect', 'out->sound_played = 1u;', '(void)0;')
m('click-state-not-pressed', 'missing-effect', 'object->state = ALC_STATE_PRESSED;\n    {', '{')
m('click-state-value', 'constant', 'object->state = ALC_STATE_PRESSED;\n    {', 'object->state = ALC_STATE_ALARM;\n    {')
m('click-tick-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_TICK, (int32_t)now, 0);\n        object->press_deadline', 'object->press_deadline')
m('click-delay-100', 'constant', '(uint32_t)((int32_t)rd_s16(body, B_PRESS_DELAY) * 100);', '(uint32_t)((int32_t)rd_s16(body, B_PRESS_DELAY) * 10);')
m('click-delay-offset', 'rect', 'rd_s16(body, B_PRESS_DELAY) * 100', 'rd_s16(body, B_CURSOR_KIND) * 100')
m('click-delay-unsigned', 'signedness', '(uint32_t)((int32_t)rd_s16(body, B_PRESS_DELAY) * 100);', '(uint32_t)((int32_t)(uint16_t)rd_s16(body, B_PRESS_DELAY) * 100);')
m('click-deadline-wrong-field', 'rect', 'object->press_deadline = now +', 'object->final_deadline = now +')
m('click-dirty-missing', 'missing-effect', 'object->dirty = 1;\n    out->fired = 1u;', 'out->fired = 1u;')
m('click-fired-flag', 'missing-effect', 'out->fired = 1u;\n    return ALC_OK;', 'return ALC_OK;')
# ---- invalidate, cleanup
m('invalidate-active-ignored', 'predicate', 'if (object->active != 0 && object->slot != ALC_NO_SLOT) HOST(host->mark_dirty', 'if (object->slot != ALC_NO_SLOT) HOST(host->mark_dirty')
m('invalidate-slot-ignored', 'predicate', 'if (object->active != 0 && object->slot != ALC_NO_SLOT) HOST(host->mark_dirty', 'if (object->active != 0) HOST(host->mark_dirty')
m('invalidate-wrong-slot', 'constant', 'HOST(host->mark_dirty(host->context, object->slot));', 'HOST(host->mark_dirty(host->context, object->slot == 0x18 ? 0x19 : 0x18));')
m('cleanup-surface-kept', 'missing-effect', 'object->surface = 0u;\n        fx(host, ALC_FX_RELEASE_SURFACE', 'fx(host, ALC_FX_RELEASE_SURFACE')
m('cleanup-surface-always-released', 'predicate', 'if (object->surface != 0u) {\n        const uint32_t surface', 'if (1) {\n        const uint32_t surface')
m('cleanup-surface-fx-value', 'constant', 'fx(host, ALC_FX_RELEASE_SURFACE, (int32_t)surface, 0);', 'fx(host, ALC_FX_RELEASE_SURFACE, 0, 0);')
m('cleanup-surface-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_RELEASE_SURFACE, (int32_t)surface, 0);', '(void)0;')
m('cleanup-slot-always-released', 'predicate', 'if (object->slot != ALC_NO_SLOT) {\n        const int16_t slot = object->slot;', 'if (1) {\n        const int16_t slot = object->slot;')
m('cleanup-slot-fx-value', 'constant', 'fx(host, ALC_FX_RELEASE_SLOT, slot, 0);', 'fx(host, ALC_FX_RELEASE_SLOT, 0, 0);')
m('cleanup-slot-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_RELEASE_SLOT, slot, 0);', '(void)0;')
m('cleanup-row-kept', 'missing-effect', 'object->row = -1; /* 0x44d107 */\n    object->slot = ALC_NO_SLOT;', 'object->slot = ALC_NO_SLOT;')
m('cleanup-slot-kept', 'missing-effect', 'object->slot = ALC_NO_SLOT;\n    object->active = 0;', 'object->active = 0;')
m('cleanup-active-kept', 'missing-effect', 'object->active = 0;\n    object->canceled = 0;', 'object->canceled = 0;')
m('cleanup-canceled-kept', 'missing-effect', 'object->canceled = 0;\n    object->set = 0;\n    HOST(host->touch_idle_timer', 'object->set = 0;\n    HOST(host->touch_idle_timer')
m('cleanup-set-kept', 'missing-effect', 'object->set = 0;\n    HOST(host->touch_idle_timer', 'HOST(host->touch_idle_timer')
m('cleanup-idle-skipped', 'missing-effect', 'HOST(host->touch_idle_timer(host->context));\n    fx(host, ALC_FX_IDLE_TIMER, 0, 0);', '(void)0;')
m('cleanup-idle-fx-dropped', 'missing-effect', 'fx(host, ALC_FX_IDLE_TIMER, 0, 0);', '(void)0;')
m('cleanup-idle-before-release', 'order', 'if (object->surface != 0u) {\n        const uint32_t surface = object->surface;',
  'HOST(host->touch_idle_timer(host->context));\n    fx(host, ALC_FX_IDLE_TIMER, 0, 0);\n    if (object->surface != 0u) {\n        const uint32_t surface = object->surface;')
# ---- render 0x44e035
m('render-valid-without-slot-test', 'predicate', 'if (object->slot == ALC_NO_SLOT) return ALC_OK;\n    out->valid = 1u;', 'out->valid = 1u;')
m('render-valid-flag', 'missing-effect', 'out->valid = 1u;\n    showing_time', 'showing_time')
m('render-showing-time-state0', 'predicate', 'showing_time = object->state == ALC_STATE_TIME || object->state == ALC_STATE_CANCEL ||', 'showing_time = object->state == ALC_STATE_ALARM || object->state == ALC_STATE_CANCEL ||')
m('render-showing-time-cancel-state', 'predicate', 'showing_time = object->state == ALC_STATE_TIME || object->state == ALC_STATE_CANCEL ||', 'showing_time = object->state == ALC_STATE_TIME ||')
m('render-showing-time-pressed-cancel', 'predicate', '(object->state == ALC_STATE_PRESSED && object->button == ALC_STATE_CANCEL);', '(object->state == ALC_STATE_PRESSED && object->button == ALC_STATE_TIME);')
m('render-showing-time-pressed-any', 'predicate', '(object->state == ALC_STATE_PRESSED && object->button == ALC_STATE_CANCEL);', '(object->state == ALC_STATE_PRESSED);')
m('render-showing-time-never-pressed', 'predicate', '(object->state == ALC_STATE_PRESSED && object->button == ALC_STATE_CANCEL);', '0;')
m('render-hour-source', 'predicate', 'hour = showing_time ? object->time_hour : object->alarm_hour;', 'hour = showing_time ? object->alarm_hour : object->time_hour;')
m('render-quarter-source', 'predicate', 'quarter = showing_time ? object->time_quarter : object->alarm_quarter;', 'quarter = showing_time ? object->alarm_quarter : object->time_quarter;')
m('render-am-source', 'predicate', 'am = showing_time ? object->time_am : object->alarm_am;', 'am = showing_time ? object->alarm_am : object->time_am;')
m('render-bounds-hour-high', 'native', 'if (hour < 0 || hour > 11 ||', 'if (hour < 0 || hour > 12 ||')
m('render-bounds-hour-low', 'native', 'if (hour < 0 || hour > 11 ||', 'if (hour < -1 || hour > 11 ||')
m('render-bounds-quarter-high', 'native', '|| quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;', '|| quarter < 0 || quarter > 4) return ALC_ERR_BOUNDS;')
m('render-bounds-quarter-low', 'native', '|| quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;', '|| quarter < -1 || quarter > 3) return ALC_ERR_BOUNDS;')
m('render-bounds-skipped', 'native', 'if (hour < 0 || hour > 11 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;', '(void)0;')
m('render-am-test', 'predicate', 'add_blit(out, am != 0 ? ALC_BLIT_AM : ALC_BLIT_PM, object->surface, body, am != 0 ? B_AM_SRC : B_PM_SRC, B_AMPM_DST,',
  'add_blit(out, am == 0 ? ALC_BLIT_AM : ALC_BLIT_PM, object->surface, body, am == 0 ? B_AM_SRC : B_PM_SRC, B_AMPM_DST,')
m('render-am-source-rect', 'rect', 'am != 0 ? B_AM_SRC : B_PM_SRC, B_AMPM_DST,', 'am != 0 ? B_PM_SRC : B_AM_SRC, B_AMPM_DST,')
m('render-ampm-dst', 'rect', 'am != 0 ? B_AM_SRC : B_PM_SRC, B_AMPM_DST,', 'am != 0 ? B_AM_SRC : B_PM_SRC, B_LIGHT_DST,')
m('render-light-test', 'predicate', 'showing_time ? ALC_BLIT_LIGHT_TIME : ALC_BLIT_LIGHT_ALARM, object->surface, body,\n             showing_time ? B_TIME_LIGHT : B_ALARM_LIGHT, B_LIGHT_DST, vx, vy);',
  'showing_time ? ALC_BLIT_LIGHT_ALARM : ALC_BLIT_LIGHT_TIME, object->surface, body,\n             showing_time ? B_TIME_LIGHT : B_ALARM_LIGHT, B_LIGHT_DST, vx, vy);')
m('render-light-source-rect', 'rect', 'showing_time ? B_TIME_LIGHT : B_ALARM_LIGHT, B_LIGHT_DST, vx, vy);', 'showing_time ? B_ALARM_LIGHT : B_TIME_LIGHT, B_LIGHT_DST, vx, vy);')
m('render-light-dst', 'rect', 'showing_time ? B_TIME_LIGHT : B_ALARM_LIGHT, B_LIGHT_DST, vx, vy);', 'showing_time ? B_TIME_LIGHT : B_ALARM_LIGHT, B_AMPM_DST, vx, vy);')
m('render-hour-stride', 'rect', 'B_HOUR_SRC + (size_t)hour * 16u, B_HOUR_DST', 'B_HOUR_SRC + (size_t)hour * 8u, B_HOUR_DST')
m('render-hour-dst', 'rect', 'B_HOUR_SRC + (size_t)hour * 16u, B_HOUR_DST', 'B_HOUR_SRC + (size_t)hour * 16u, B_MINUTE_DST')
m('render-hour-index', 'rect', 'B_HOUR_SRC + (size_t)hour * 16u, B_HOUR_DST', 'B_HOUR_SRC + (size_t)quarter * 16u, B_HOUR_DST')
m('render-minute-stride', 'rect', 'B_MINUTE_SRC + (size_t)quarter * 16u, B_MINUTE_DST', 'B_MINUTE_SRC + (size_t)quarter * 8u, B_MINUTE_DST')
m('render-minute-dst', 'rect', 'B_MINUTE_SRC + (size_t)quarter * 16u, B_MINUTE_DST', 'B_MINUTE_SRC + (size_t)quarter * 16u, B_HOUR_DST')
m('render-minute-index', 'rect', 'B_MINUTE_SRC + (size_t)quarter * 16u, B_MINUTE_DST', 'B_MINUTE_SRC + (size_t)hour * 16u, B_MINUTE_DST')
m('render-origin-x-in-y', 'rect', 'b->dst[1] = (int32_t)((uint32_t)rd_s32(body, dst + 4) + (uint32_t)vy);', 'b->dst[1] = (int32_t)((uint32_t)rd_s32(body, dst + 4) + (uint32_t)vx);')
m('render-origin-y-in-x', 'rect', 'b->dst[0] = (int32_t)((uint32_t)rd_s32(body, dst) + (uint32_t)vx);', 'b->dst[0] = (int32_t)((uint32_t)rd_s32(body, dst) + (uint32_t)vy);')
m('render-origin-right-missing', 'missing-effect', 'b->dst[2] = (int32_t)((uint32_t)rd_s32(body, dst + 8) + (uint32_t)vx);', 'b->dst[2] = rd_s32(body, dst + 8);')
m('render-origin-bottom-missing', 'missing-effect', 'b->dst[3] = (int32_t)((uint32_t)rd_s32(body, dst + 12) + (uint32_t)vy);', 'b->dst[3] = rd_s32(body, dst + 12);')
m('render-src-origin', 'rect', 'for (int k = 0; k < 4; ++k) b->src[k] = rd_s32(body, src + (size_t)k * 4u);', 'for (int k = 0; k < 4; ++k) b->src[k] = rd_s32(body, src + (size_t)k * 4u) + (k % 2 ? vy : vx);')
m('render-surface-zero', 'constant', 'b->src_surface = surface;', 'b->src_surface = 0u;')
m('render-pressed-test', 'predicate', 'if (object->state == ALC_STATE_PRESSED) {\n        switch (object->button) {', 'if (object->state == ALC_STATE_ALARM) {\n        switch (object->button) {')
m('render-down-time-src', 'rect', 'add_blit(out, ALC_BLIT_DOWN_TIME, object->surface, body, B_TIME_DOWN, B_TIME_BTN, vx, vy);', 'add_blit(out, ALC_BLIT_DOWN_TIME, object->surface, body, B_ALARM_DOWN, B_TIME_BTN, vx, vy);')
m('render-down-time-dst', 'rect', 'add_blit(out, ALC_BLIT_DOWN_TIME, object->surface, body, B_TIME_DOWN, B_TIME_BTN, vx, vy);', 'add_blit(out, ALC_BLIT_DOWN_TIME, object->surface, body, B_TIME_DOWN, B_ALARM_BTN, vx, vy);')
m('render-down-alarm-src', 'rect', 'add_blit(out, ALC_BLIT_DOWN_ALARM, object->surface, body, B_ALARM_DOWN, B_ALARM_BTN, vx, vy);', 'add_blit(out, ALC_BLIT_DOWN_ALARM, object->surface, body, B_TIME_DOWN, B_ALARM_BTN, vx, vy);')
m('render-down-alarm-dst', 'rect', 'add_blit(out, ALC_BLIT_DOWN_ALARM, object->surface, body, B_ALARM_DOWN, B_ALARM_BTN, vx, vy);', 'add_blit(out, ALC_BLIT_DOWN_ALARM, object->surface, body, B_ALARM_DOWN, B_TIME_BTN, vx, vy);')
m('render-down-increase-src', 'rect', 'B_INCREASE_DOWN, B_INCREASE_BTN, vx, vy); break;', 'B_DECREASE_DOWN, B_INCREASE_BTN, vx, vy); break;')
m('render-down-increase-dst', 'rect', 'B_INCREASE_DOWN, B_INCREASE_BTN, vx, vy); break;', 'B_INCREASE_DOWN, B_DECREASE_BTN, vx, vy); break;')
m('render-down-decrease-src', 'rect', 'B_DECREASE_DOWN, B_DECREASE_BTN, vx, vy); break;', 'B_INCREASE_DOWN, B_DECREASE_BTN, vx, vy); break;')
m('render-down-decrease-dst', 'rect', 'B_DECREASE_DOWN, B_DECREASE_BTN, vx, vy); break;', 'B_DECREASE_DOWN, B_INCREASE_BTN, vx, vy); break;')
m('render-down-set-src', 'rect', 'B_SET_DOWN, B_SET_BTN, vx, vy); break;', 'B_CANCEL_DOWN, B_SET_BTN, vx, vy); break;')
m('render-down-set-dst', 'rect', 'B_SET_DOWN, B_SET_BTN, vx, vy); break;', 'B_SET_DOWN, B_CANCEL_BTN, vx, vy); break;')
m('render-down-cancel-src', 'rect', 'B_CANCEL_DOWN, B_CANCEL_BTN, vx, vy); break;', 'B_SET_DOWN, B_CANCEL_BTN, vx, vy); break;')
m('render-down-cancel-dst', 'rect', 'B_CANCEL_DOWN, B_CANCEL_BTN, vx, vy); break;', 'B_CANCEL_DOWN, B_SET_BTN, vx, vy); break;')
m('render-down-kind-set', 'constant', 'case 6: add_blit(out, ALC_BLIT_DOWN_SET,', 'case 6: add_blit(out, ALC_BLIT_DOWN_CANCEL,')
m('render-down-case-time-missing', 'missing-effect', 'case 0: add_blit(out, ALC_BLIT_DOWN_TIME, object->surface, body, B_TIME_DOWN, B_TIME_BTN, vx, vy); break;\n', '')
m('render-down-case-cancel-missing', 'missing-effect', 'case 8: add_blit(out, ALC_BLIT_DOWN_CANCEL, object->surface, body, B_CANCEL_DOWN, B_CANCEL_BTN, vx, vy); break;\n', '')
m('render-down-case-2', 'predicate', 'case 6: add_blit(out, ALC_BLIT_DOWN_SET,', 'case 2: case 6: add_blit(out, ALC_BLIT_DOWN_SET,')
m('render-restore-test', 'predicate', '} else if (object->restore != 0) {', '} else if (object->restore == 0) {')
m('render-restore-ignores-pressed', 'predicate', '} else if (object->restore != 0) {', '} if (object->restore != 0) {')
m('render-restore-kept', 'missing-effect', 'object->restore = 0;\n    }\n    for (uint8_t i = 0;', '}\n    for (uint8_t i = 0;')
m('render-restore-surface', 'constant', 'add_blit(out, up[i].kind, 0u, body, up[i].rect, up[i].rect, vx, vy);', 'add_blit(out, up[i].kind, object->surface, body, up[i].rect, up[i].rect, vx, vy);')
m('render-restore-src-dst', 'rect', 'add_blit(out, up[i].kind, 0u, body, up[i].rect, up[i].rect, vx, vy);', 'add_blit(out, up[i].kind, 0u, body, up[i].rect, B_LIGHT_DST, vx, vy);')
m('render-restore-cancel-rect', 'rect', '{ALC_BLIT_UP_CANCEL, B_CANCEL_BTN}', '{ALC_BLIT_UP_CANCEL, B_SET_BTN}')
m('render-restore-alarm-rect', 'rect', '{ALC_BLIT_UP_ALARM, B_ALARM_BTN}', '{ALC_BLIT_UP_ALARM, B_TIME_BTN}')
m('render-restore-time-rect', 'rect', '{ALC_BLIT_UP_TIME, B_TIME_BTN}', '{ALC_BLIT_UP_TIME, B_ALARM_BTN}')
m('render-restore-set-rect', 'rect', '{ALC_BLIT_UP_SET, B_SET_BTN}', '{ALC_BLIT_UP_SET, B_CANCEL_BTN}')
m('render-restore-incr-rect', 'rect', '{ALC_BLIT_UP_INCREASE, B_INCREASE_BTN}', '{ALC_BLIT_UP_INCREASE, B_DECREASE_BTN}')
m('render-restore-decr-rect', 'rect', '{ALC_BLIT_UP_DECREASE, B_DECREASE_BTN}', '{ALC_BLIT_UP_DECREASE, B_INCREASE_BTN}')
m('render-restore-order', 'order', '{ALC_BLIT_UP_CANCEL, B_CANCEL_BTN}, {ALC_BLIT_UP_ALARM, B_ALARM_BTN}', '{ALC_BLIT_UP_ALARM, B_ALARM_BTN}, {ALC_BLIT_UP_CANCEL, B_CANCEL_BTN}')
m('render-restore-loop-short', 'loop-bound', 'for (size_t i = 0; i < sizeof(up) / sizeof(up[0]); ++i)', 'for (size_t i = 0; i + 1 < sizeof(up) / sizeof(up[0]); ++i)')
m('render-dirty-kept', 'missing-effect', 'object->dirty = 0;\n    return ALC_OK;\n}\n', 'return ALC_OK;\n}\n', 2, 1)
m('render-blit-fx-dropped', 'missing-effect', 'for (uint8_t i = 0; i < out->count; ++i) fx(host, ALC_FX_BLIT, out->blit[i].kind, 0);', '(void)0;')
m('render-blit-fx-kind', 'constant', 'fx(host, ALC_FX_BLIT, out->blit[i].kind, 0);', 'fx(host, ALC_FX_BLIT, out->blit[i].kind + 1, 0);')
m('render-origin-fetch-skipped', 'missing-effect', 'HOST(host->view_origin(host->context, &vx, &vy));', '(void)0;')

# Mutants proved equivalent by reading the code: they cannot change any observable behaviour, so a surviving run is the expected
# result. They are reported separately and never count as killed.
EQUIVALENT = {
    'time-q2-lower': 'minute 0x1e is already taken by the quarter-1 branch (<= 0x1e) tested first, so the lower bound 0x1f is never reached with 0x1e',
    'time-q3-lower': 'minute 0x2d is already taken by the quarter-2 branch (<= 0x2d) tested first, so the lower bound 0x2e is never reached with 0x2d',
    'time-wrap-toggle-from-alarm': 'alarm_am was just assigned time_am two statements earlier, so alarm_am == 0 and time_am == 0 are the same test',
    'step-down-modulus': 'the decrease branch handles hour 0 first, so the operand is 1..11 (hour-1 is 0..10) and % 12 and % 13 give the same value',
    'block-start-unsigned': 'comparing the 16-bit start word with 1 gives the same answer signed or unsigned (the only equal value is 1)',
    'press-dirty-missing': 'press() is only called from alc_pointer, which has already set dirty = 1 before the hit tests, so the second store changes nothing',
}


def apply(text, old, new, count, which):
    n = text.count(old)
    if n != count:
        raise ValueError('site found %d times, expected %d' % (n, count))
    pos = -1
    for _ in range(which + 1):
        pos = text.index(old, pos + 1)
    return text[:pos] + new + text[pos + len(old):]


def run_oracle(src_dir, quick, result):
    cmd = [sys.executable, str(ORACLE), '--src', str(src_dir), '--workers', '1', '--result', str(result), '--fail-fast', '--lenient-build']
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
    name, cls, old, new, count, which, kernel_text, work, stage = args
    d = work / name
    d.mkdir()
    for h in (PROJECT / 'src').glob('action_family_aa_runtime*.h'):
        shutil.copy(h, d / h.name)
    row = dict(name=name, cls=cls)
    try:
        mutated = apply(kernel_text, old, new, count, which)
    except ValueError as e:
        row.update(verdict='INVALID', detail=str(e))
        return row
    (d / KERNEL).write_text(mutated)
    verdict, detail = run_oracle(d, True, d / 'result.json')
    row['stage'] = 'quick'
    if verdict == 'SURVIVED' or stage == 'full':
        if verdict == 'SURVIVED':
            verdict, detail = run_oracle(d, False, d / 'result_full.json')
            row['stage'] = 'full'
    row.update(verdict=verdict, detail=detail)
    return row


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--stage', choices=('quick', 'full'), default='quick')
    ap.add_argument('--only')
    ap.add_argument('--jobs', type=int, default=min(4, os.cpu_count() or 1))
    ap.add_argument('--result', type=Path)
    a = ap.parse_args()
    kernel_text = (PROJECT / 'src' / KERNEL).read_text()
    work = Path(tempfile.mkdtemp(prefix='aa_mut_'))
    t0 = time.monotonic()
    todo = [(name, cls, old, new, count, which, kernel_text, work, a.stage) for name, cls, old, new, count, which in M
            if not a.only or a.only in name]
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
               equivalent=[r['name'] for r in rows if r['verdict'] == 'EQUIVALENT'], rows=rows,
               seconds=round(time.monotonic() - t0, 1))
    out['source_sha256'] = hashlib.sha256((PROJECT / 'src' / KERNEL).read_bytes()).hexdigest()
    out['mutation_script_sha256'] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    print(json.dumps({k: v for k, v in out.items() if k != 'rows'}, indent=1))
    if a.result:
        a.result.parent.mkdir(parents=True, exist_ok=True)
        a.result.write_text(json.dumps(out, indent=1, sort_keys=True))
    return 0 if not out['survived'] and not out['invalid'] else 1  # equivalent mutants do not fail the check


if __name__ == '__main__':
    sys.exit(main())
