#!/usr/bin/env python3
"""RT-58 mutation check for the raw-0x76 oracle (PASSWORD puzzle runtime).

Every mutant is a one-site textual edit of a COPY of src/action_family_76_runtime.c or src/action_family_76_runtime.h (the project files are
never touched). The sites are generated mechanically from the code text (comments, strings and character literals masked):
  * relational / logical operator flips (== != < <= > >= && ||), binary + and - flips, removal of a logical not,
  * every integer literal changed by +1 (0 -> 1, 1 -> 2, ...), every character literal changed to its successor,
  * deletion of every simple statement (assignment, call, observe(), break) replaced by `;`,
plus the hand-written mutants in CURATED (semantic one-site edits the mechanical operators do not reach).
Each mutant is built into a driver library and run through the original-x86 oracle (action_family_76_runtime_original_oracle.py, `--src DIR`).
A mutant is KILLED when the oracle reports at least one mismatch against the unmodified GAME.EXE image (or one of its native-only refusal
checks fails, or the run crashes / hangs); it SURVIVES when the oracle still reports 0 mismatches; it is INVALID if the driver does not
compile (invalid mutants are listed, never counted as killed). Equivalent mutants (EQUIVALENT below, each with a reason read from the kernel
and the original) are reported separately and are not counted in the kill rate; an EQUIVALENT mutant that is KILLED is reported as killed.

Usage:  python3 action_family_76_runtime_mutation_check.py [--stage quick|full] [--only TEXT] [--jobs N] [--result FILE] [--list]
Stage `quick` (default) runs the oracle's --quick-only subset (plus the native refusal checks); the survivors are re-run on the full
scenario set. --stage full runs every mutant on the full set. Mutants run in parallel, one oracle per mutant (--jobs, default 4).
"""
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
ROOT = PROJECT.parents[1]
ORACLE = HERE / 'action_family_76_runtime_original_oracle.py'
FILES = ('action_family_76_runtime.c', 'action_family_76_runtime.h')

# (name, file, old text, new text, expected occurrences of old text, index of the occurrence to edit): hand-written semantic mutants
CURATED = [
    ('cursor-char', FILES[0], "#define CURSOR '-'", "#define CURSOR '+'", 1, 0),
    ('no-sound-case', FILES[0], "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'n', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", 1, 0),
    ('no-sound-8-bytes', FILES[0], 'memcmp(body + name, NO_SOUND, sizeof NO_SOUND) == 0', 'memcmp(body + name, NO_SOUND, 8) == 0', 1, 0),
    ('upper-lower-bound', FILES[0], "if (*s > '`' && *s < '{')", "if (*s >= '`' && *s < '{')", 1, 0),
    ('upper-upper-bound', FILES[0], "if (*s > '`' && *s < '{')", "if (*s > '`' && *s <= '{')", 1, 0),
    ('upper-unsigned', FILES[0], "if (*s > '`' && *s < '{')", "if ((unsigned char)*s > '`' && (unsigned char)*s < '{')", 1, 0),
    ('upper-offset', FILES[0], '*s = (char)(*s - 0x20);', '*s = (char)(*s - 0x1f);', 1, 0),
    ('contains-case-sensitive', FILES[0], 'upper(typed);\n', '\n', 1, 0),
    ('contains-word-case-sensitive', FILES[0], 'upper(word);\n', '\n', 1, 0),
    ('contains-prefix-only', FILES[0], 'return strstr(hay, needle) != NULL;', 'return strncmp(hay, needle, strlen(needle)) == 0;', 1, 0),
    ('contains-equal-only', FILES[0], 'return strstr(hay, needle) != NULL;', 'return strcmp(hay, needle) == 0;', 1, 0),
    ('typed-copy-short', FILES[0], 'memcpy(typed, field, PWD_TEXT_BYTES);', 'memcpy(typed, field, PWD_TEXT_BYTES - 1);', 1, 0),
    ('word-copy-short', FILES[0], 'memcpy(word, body + words_off + (size_t)i * WORD_STRIDE, PWD_TEXT_BYTES);',
     'memcpy(word, body + words_off + (size_t)i * WORD_STRIDE, PWD_TEXT_BYTES - 1);', 1, 0),
    ('word-stride', FILES[0], '#define WORD_STRIDE 0x21u', '#define WORD_STRIDE 0x20u', 1, 0),
    ('width-limit-signed', FILES[0], 'if ((int32_t)width < limit) field[len] = key;', 'if ((uint16_t)width < limit) field[len] = key;', 1, 0),
    ('width-limit-32bit', FILES[0], 'int16_t width = 0;', 'int32_t width = 0;', 1, 0),
    ('width-delta', FILES[0], 'rd32u(body, rect + 8) - rd32u(body, rect)) - 0x14', 'rd32u(body, rect + 8) - rd32u(body, rect)) - 0x13', 1, 0),
    ('width-rect-field2', FILES[0], 'const size_t rect = second ? 0x14u : 0x04u;', 'const size_t rect = 0x04u;', 1, 0),
    ('width-rect-field1', FILES[0], 'const size_t rect = second ? 0x14u : 0x04u;', 'const size_t rect = 0x14u;', 1, 0),
    ('limit-len', FILES[0], 'if (len + 2 < PWD_TEXT_BYTES) {', 'if (len + 1 < PWD_TEXT_BYTES) {', 1, 0),
    ('limit-len-3', FILES[0], 'if (len + 2 < PWD_TEXT_BYTES) {', 'if (len + 3 < PWD_TEXT_BYTES) {', 1, 0),
    ('limit-len-le', FILES[0], 'if (len + 2 < PWD_TEXT_BYTES) {', 'if (len + 2 <= PWD_TEXT_BYTES) {', 1, 0),
    ('key-store-signed', FILES[0], 'state->b[PWD_S_KEY] = (uint8_t)ch;', 'state->b[PWD_S_KEY] = (uint8_t)(ch & 0x7f);', 1, 0),
    ('key-pending-ignored', FILES[0], 'state->b[PWD_S_ACTIVE] != 0 && state->b[PWD_S_KEY_PENDING] == 0 && pwd_char_accepted(ch)',
     'state->b[PWD_S_ACTIVE] != 0 && pwd_char_accepted(ch)', 1, 0),
    ('key-active-ignored', FILES[0], 'state->b[PWD_S_ACTIVE] != 0 && state->b[PWD_S_KEY_PENDING] == 0 && pwd_char_accepted(ch)',
     'state->b[PWD_S_KEY_PENDING] == 0 && pwd_char_accepted(ch)', 1, 0),
    ('key-filter-ignored', FILES[0], 'state->b[PWD_S_ACTIVE] != 0 && state->b[PWD_S_KEY_PENDING] == 0 && pwd_char_accepted(ch)',
     'state->b[PWD_S_ACTIVE] != 0 && state->b[PWD_S_KEY_PENDING] == 0', 1, 0),
    ('filter-letters-ascii-only-upper', FILES[0], "(c >= 'A' && c <= 'Z') || ", "(c >= 'A' && c < 'Z') || ", 1, 0),
    ('filter-minus-removed', FILES[0], "case '&': case ':': case ';': case '+': case '%': case '=': case '-':",
     "case '&': case ':': case ';': case '+': case '%': case '=':", 1, 0),
    ('filter-high-bytes-removed', FILES[0], 'case -0x20: case -0x19:', 'case -0x19:', 1, 0),
    ('filter-high-last-removed', FILES[0], 'case -0xf: case -0x37: case -0x1f: case -0x13: case -0xd: case -6: case -0x21:',
     'case -0xf: case -0x37: case -0x1f: case -0x13: case -0xd: case -6:', 1, 0),
    ('blink-deadline-strict', FILES[0], 'if (rd32u(state->b, PWD_S_DEADLINE) <= now) {', 'if (rd32u(state->b, PWD_S_DEADLINE) < now) {', 1, 0),
    ('blink-deadline-signed', FILES[0], 'if (rd32u(state->b, PWD_S_DEADLINE) <= now) {', 'if ((int32_t)rd32u(state->b, PWD_S_DEADLINE) <= (int32_t)now) {', 1, 0),
    ('blink-period-unsigned', FILES[0], 'now + (uint32_t)(int32_t)pwd_rd16(body, B_BLINK)', 'now + (uint32_t)(uint16_t)pwd_rd16(body, B_BLINK)', 1, 0),
    ('blink-second-tick-reused', FILES[0], '        now = host->tick(host->context);\n        observe(host, PWD_FX_TICK, (int32_t)now, 0);\n        wr32(state->b, PWD_S_DEADLINE',
     '        wr32(state->b, PWD_S_DEADLINE', 1, 0),
    ('blink-toggle-wrong-way', FILES[0], 'wr32(state->b, PWD_S_BLINK, phase == 0 ? 1u : 0u);', 'wr32(state->b, PWD_S_BLINK, 1u);', 1, 0),
    ('blink-phase-other-values', FILES[0], '    } else if (phase == 1) {\n        if (len != 0', '    } else {\n        if (len != 0', 1, 0),
    ('phase0-deadline-signed', FILES[0], 'wr32(state->b, PWD_S_DEADLINE, t + (uint32_t)(int32_t)pwd_rd16(body, B_BLINK));',
     'wr32(state->b, PWD_S_DEADLINE, t + (uint32_t)(uint16_t)pwd_rd16(body, B_BLINK));', 1, 0),
    ('phase0-origin-swapped', FILES[0], 'const uint32_t origin = (uint32_t)((j & 1) ? vy : vx);', 'const uint32_t origin = (uint32_t)((j & 1) ? vx : vy);', 1, 0),
    ('phase0-no-origin', FILES[0], 'wr32(state->b, dst, rd32u(body, src) + origin);', 'wr32(state->b, dst, rd32u(body, src));', 1, 0),
    ('phase0-rect-order', FILES[0], 'const size_t src = (j < 4) ? (size_t)(0x24 + 4 * j) : (size_t)(4 + 4 * (j - 4));',
     'const size_t src = (size_t)(4 + 4 * j);', 1, 0),
    ('phase0-fields-not-cleared-1', FILES[0], 'memset(state->b + PWD_S_FIELD1, 0, PWD_TEXT_BYTES);', ';', 1, 0),
    ('phase0-fields-not-cleared-2', FILES[0], 'memset(state->b + PWD_S_FIELD2, 0, PWD_TEXT_BYTES);', ';', 1, 0),
    ('phase0-fields-clear-short-1', FILES[0], 'memset(state->b + PWD_S_FIELD1, 0, PWD_TEXT_BYTES);', 'memset(state->b + PWD_S_FIELD1, 0, PWD_TEXT_BYTES - 1);', 1, 0),
    ('phase0-fields-clear-short-2', FILES[0], 'memset(state->b + PWD_S_FIELD2, 0, PWD_TEXT_BYTES);', 'memset(state->b + PWD_S_FIELD2, 0, PWD_TEXT_BYTES - 1);', 1, 0),
    ('phase0-row-high-byte', FILES[0], 'state->b[PWD_S_ROW + 1] = (uint8_t)((uint16_t)row >> 8);', ';', 1, 0),
    ('phase0-view-failure-after-effect', FILES[0], '    if (host->view_origin(host->context, &vx, &vy) != 0) return PWD_ERR_HOST;\n    state->b[PWD_S_ACTIVE] = 1;',
     '    state->b[PWD_S_ACTIVE] = 1;\n    if (host->view_origin(host->context, &vx, &vy) != 0) return PWD_ERR_HOST;', 1, 0),
    ('enter-field2-wrong-state-first', FILES[0], '        if (second) {\n            state->b[PWD_S_WRONG] = 1;\n            wr32(state->b, PWD_S_STATE, PWD_STATE_WRONG_SOUND);\n        }\n    }',
     '    }\n    if (second && !matched) {\n        state->b[PWD_S_WRONG] = 1;\n        wr32(state->b, PWD_S_STATE, PWD_STATE_WRONG_SOUND);\n    }', 1, 0),
    ('enter-first-miss-field1-only-after-loop', FILES[0], '!check_words(body, field, words, count, state, second) && !second', '!check_words(body, field, words, count, state, second)', 1, 0),
    ('enter-field1-with-second-sets-correct', FILES[0], '                wr32(state->b, PWD_S_STATE, PWD_STATE_FIELD2); /*',
     '                state->b[PWD_S_CORRECT] = 1; wr32(state->b, PWD_S_STATE, PWD_STATE_FIELD2); /*', 1, 0),
    ('enter-backspace-two-chars', FILES[0], '            len = strlen((const char *)field);\n            if (len != 0) field[len - 1] = 0;\n        } else if (key == KEY_ENTER)',
     '            len = strlen((const char *)field);\n            if (len != 0) field[len - 1] = 0;\n            len = strlen((const char *)field);\n            if (len != 0) field[len - 1] = 0;\n        } else if (key == KEY_ENTER)', 1, 0),
    ('enter-cursor-not-removed', FILES[0], '        if (len != 0 && field[len - 1] == CURSOR) field[len - 1] = 0;\n        if (key == KEY_BACKSPACE)',
     '        if (key == KEY_BACKSPACE)', 1, 0),
    ('typing-ignores-pending', FILES[0], '    if (state->b[PWD_S_KEY_PENDING] != 0) {\n        const uint8_t key', '    if (1) {\n        const uint8_t key', 1, 0),
    ('typing-pending-not-cleared', FILES[0], '        state->b[PWD_S_KEY_PENDING] = 0;\n    }\n    if (second) {', '    }\n    if (second) {', 1, 0),
    ('blink-after-wrong-field1', FILES[0], '} else if (state->b[PWD_S_WRONG] == 0 && state_dword(state, PWD_S_STATE) != 1) {', '} else if (state_dword(state, PWD_S_STATE) != 1) {', 1, 0),
    ('blink-field2-after-correct', FILES[0], 'if (state->b[PWD_S_WRONG] == 0 && state->b[PWD_S_CORRECT] == 0) return blink(state, body, field, host);',
     'if (state->b[PWD_S_WRONG] == 0) return blink(state, body, field, host);', 1, 0),
    ('blink-field2-after-wrong', FILES[0], 'if (state->b[PWD_S_WRONG] == 0 && state->b[PWD_S_CORRECT] == 0) return blink(state, body, field, host);',
     'if (state->b[PWD_S_CORRECT] == 0) return blink(state, body, field, host);', 1, 0),
    ('sound-start-play-before-prepare', FILES[0], '    if (host->sound_prepare(host->context, body + name) != 0) return PWD_ERR_HOST;\n    observe(host, PWD_FX_SOUND_PREPARE, (int32_t)name, 0);\n',
     '', 1, 0),
    ('sound-wait-busy-test', FILES[0], '    if (busy == 0) {\n        if (host->sound_stop', '    if (busy != 1) {\n        if (host->sound_stop', 1, 0),
    ('sound-wait-busy-low-byte', FILES[0], '    if (busy == 0) {\n        if (host->sound_stop', '    if ((busy & 0xff) == 0) {\n        if (host->sound_stop', 1, 0),
    ('sound-channel-unsigned', FILES[0], 'if (host->sound_busy(host->context, pwd_rd16(body, channel), &busy) != 0) return PWD_ERR_HOST;\n    observe(host, PWD_FX_SOUND_BUSY, pwd_rd16(body, channel), busy);',
     'if (host->sound_busy(host->context, (int16_t)(uint8_t)pwd_rd16(body, channel), &busy) != 0) return PWD_ERR_HOST;\n    observe(host, PWD_FX_SOUND_BUSY, pwd_rd16(body, channel), busy);', 1, 0),
    ('finish-flag-checked-for-unused-block', FILES[0], 'const int used = state->b[PWD_S_CANCEL] != 0 || state->b[PWD_S_WRONG] != 0 || state->b[PWD_S_CORRECT] != 0;',
     'const int used = 1;', 1, 0),
    ('finish-cancel-block-first', FILES[0], 'const size_t block = state->b[PWD_S_CANCEL] != 0 ? (size_t)B_CANCEL : state->b[PWD_S_WRONG] != 0 ? (size_t)B_WRONG : (size_t)B_CORRECT;',
     'const size_t block = state->b[PWD_S_WRONG] != 0 ? (size_t)B_WRONG : state->b[PWD_S_CANCEL] != 0 ? (size_t)B_CANCEL : (size_t)B_CORRECT;', 1, 0),
    ('finish-cancel-over-wrong', FILES[0], '        if (state->b[PWD_S_CANCEL] == 0) {\n            if (state->b[PWD_S_WRONG] == 0) {',
     '        if (state->b[PWD_S_CANCEL] == 0 || state->b[PWD_S_WRONG] != 0) {\n            if (state->b[PWD_S_WRONG] == 0) {', 1, 0),
    ('finish-start-flag-eq', FILES[0], 'observe(host, PWD_FX_START_FLAG, pwd_rd16(body, base + 20) != 1, 0);', 'observe(host, PWD_FX_START_FLAG, pwd_rd16(body, base + 20) == 1, 0);', 1, 0),
    ('finish-start-flag-byte', FILES[0], 'observe(host, PWD_FX_START_FLAG, pwd_rd16(body, base + 20) != 1, 0);', 'observe(host, PWD_FX_START_FLAG, (int8_t)pwd_rd16(body, base + 20) != 1, 0);', 1, 0),
    ('finish-value-signed', FILES[0], 'const uint32_t value = body[base + 24];', 'const uint32_t value = (uint32_t)(int8_t)body[base + 24];', 1, 0),
    ('finish-scene-9999-unsigned', FILES[0], 'if (pwd_rd16(body, base) != PWD_NO_SCENE) {', 'if ((uint16_t)pwd_rd16(body, base) != PWD_NO_SCENE) {', 1, 0),
    ('finish-flag-minus-one-unsigned', FILES[0], 'if (pwd_rd16(body, base + 22) != PWD_NO_FLAG) {', 'if ((uint16_t)pwd_rd16(body, base + 22) != 0xffff) {', 1, 0),
    ('finish-correct-requires-flag', FILES[0], '                if (state->b[PWD_S_CORRECT] != 0) rc = finish_block(body, B_CORRECT, host);',
     '                rc = finish_block(body, B_CORRECT, host);', 1, 0),
    ('finish-releases-font-late', FILES[0], '        if (host->font_release(host->context, font) != 0) return PWD_ERR_HOST;\n        observe(host, PWD_FX_FONT_RELEASE, font, 0);\n        observe(host, PWD_FX_ENTRY_VISIBLE, 0, 0);',
     '        observe(host, PWD_FX_ENTRY_VISIBLE, 0, 0);\n        if (host->font_release(host->context, font) != 0) return PWD_ERR_HOST;\n        observe(host, PWD_FX_FONT_RELEASE, font, 0);', 1, 0),
    ('finish-completion-not-reported', FILES[0], '        result->completed = 1;', '        result->completed = 0;', 1, 0),
    ('step-phase-above-2-allowed', FILES[0], '    if (phase > 2) {', '    if (phase > 3) {', 1, 0),
    ('step-row-check-dropped', FILES[0], 'if (phase != 0 && (state->b[PWD_S_ACTIVE] == 0 || state_row(state) != row)) {', 'if (phase != 0 && state->b[PWD_S_ACTIVE] == 0) {', 1, 0),
    ('step-active-check-dropped', FILES[0], 'if (phase != 0 && (state->b[PWD_S_ACTIVE] == 0 || state_row(state) != row)) {', 'if (phase != 0 && state_row(state) != row) {', 1, 0),
    ('pointer-y-inclusive-low', FILES[0], 'if (y >= pwd_rd32(body, B_CANCEL_RECT + 4) &&', 'if (y > pwd_rd32(body, B_CANCEL_RECT + 4) &&', 1, 0),
    ('pointer-x-view-shifted', FILES[0], 'x >= pwd_rd32(body, B_CANCEL_RECT) && x <= pwd_rd32(body, B_CANCEL_RECT + 8)) {', 'x >= pwd_rd32(body, B_CANCEL_RECT) + 1 && x <= pwd_rd32(body, B_CANCEL_RECT + 8)) {', 1, 0),
    ('pointer-unsigned-compare', FILES[0], 'if (y >= pwd_rd32(body, B_CANCEL_RECT + 4) && y <= pwd_rd32(body, B_CANCEL_RECT + 12) &&',
     'if ((uint32_t)y >= (uint32_t)pwd_rd32(body, B_CANCEL_RECT + 4) && (uint32_t)y <= (uint32_t)pwd_rd32(body, B_CANCEL_RECT + 12) &&', 1, 0),
    ('pointer-active-ignored', FILES[0], '    if (state->b[PWD_S_ACTIVE] == 0) return PWD_OK;\n    if (body_length != PWD_BODY_BYTES) return PWD_ERR_BODY;',
     '    if (body_length != PWD_BODY_BYTES) return PWD_ERR_BODY;', 1, 0),
    ('click-correct-ignored', FILES[0], 'if (state->b[PWD_S_ACTIVE] != 0 && state->b[PWD_S_CORRECT] == 0 && candidate == PWD_CANDIDATE_CANCEL) {',
     'if (state->b[PWD_S_ACTIVE] != 0 && candidate == PWD_CANDIDATE_CANCEL) {', 1, 0),
    ('click-active-ignored', FILES[0], 'if (state->b[PWD_S_ACTIVE] != 0 && state->b[PWD_S_CORRECT] == 0 && candidate == PWD_CANDIDATE_CANCEL) {',
     'if (state->b[PWD_S_CORRECT] == 0 && candidate == PWD_CANDIDATE_CANCEL) {', 1, 0),
    ('click-wrong-checked', FILES[0], 'if (state->b[PWD_S_ACTIVE] != 0 && state->b[PWD_S_CORRECT] == 0 && candidate == PWD_CANDIDATE_CANCEL) {',
     'if (state->b[PWD_S_ACTIVE] != 0 && state->b[PWD_S_CORRECT] == 0 && state->b[PWD_S_WRONG] == 0 && candidate == PWD_CANDIDATE_CANCEL) {', 1, 0),
    ('click-row-byte', FILES[0], 'out->row = state_row(state);', 'out->row = (int16_t)(uint8_t)state_row(state);', 1, 0),
    ('render-field2-condition', FILES[0], 'if (state->b[PWD_S_FIELD2] != 0) {', 'if (state->b[PWD_S_FIELD2] != 0 || state->b[PWD_S_FIELD1] != 0) {', 1, 0),
    ('render-y-top', FILES[0], 'op->y = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F1 + 12);', 'op->y = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F1 + 4);', 1, 0),
    ('render-x-wide', FILES[0], 'op->x = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F1);', 'op->x = (int16_t)(uint8_t)pwd_rd32(state->b, PWD_S_RECT_F1);', 1, 0),
    ('render-src-shifted', FILES[0], 'op->dst[i] = pwd_rd32(state->b, PWD_S_RECT_BG + (size_t)4 * i);', 'op->dst[i] = pwd_rd32(body, B_RECT_BG + (size_t)4 * i);', 1, 0),
    ('render-count', FILES[0], '    out->count = 2;\n    if (state->b[PWD_S_FIELD2]', '    out->count = 3;\n    if (state->b[PWD_S_FIELD2]', 1, 0),
    ('pwd-rd16-unsigned', FILES[1], 'return (int16_t)(uint16_t)(p[off] | (p[off + 1] << 8));', 'return (uint16_t)(p[off] | (p[off + 1] << 8));', 1, 0),
    ('pwd-rd32-byte', FILES[1], '((uint32_t)p[off + 3] << 24)', '((uint32_t)p[off + 3] << 23)', 1, 0),
    ('validate-font-18', FILES[0], 'pwd_rd16(body, B_FONT) > PWD_MAX_FONT', 'pwd_rd16(body, B_FONT) > PWD_MAX_FONT + 1', 1, 0),
    ('validate-sound-name-skipped', FILES[0], '!has_nul(body, B_SUCCESS_SOUND, WORD_STRIDE) || !has_nul(body, B_WRONG_SOUND, WORD_STRIDE)', '0', 1, 0),
    ('validate-word-a-last-skipped', FILES[0], 'for (i = 0; i < pwd_rd16(body, B_COUNT_A); ++i) {', 'for (i = 0; i + 1 < pwd_rd16(body, B_COUNT_A); ++i) {', 1, 0),
    ('validate-word-b-last-skipped', FILES[0], 'for (i = 0; i < pwd_rd16(body, B_COUNT_B); ++i) {', 'for (i = 0; i + 1 < pwd_rd16(body, B_COUNT_B); ++i) {', 1, 0),
]

# reason per equivalent mutant. The key is either a curated name ("c:<name>") or "<kind>|<source line text>" for a mechanical mutant (all sites
# of that kind on that line; line numbers are not used, so the entries survive edits elsewhere in the file).
EQUIVALENT = {
    'c:upper-unsigned': "(unsigned char)c > '`' && < '{' selects the same bytes 0x61..0x7a as the signed compare (bytes >= 0x80 are above '{' unsigned and negative signed)",
    'c:finish-scene-9999-unsigned': 'a 16-bit word equals 9999 as uint16_t exactly when it does as int16_t (9999 < 32768)',
    'c:finish-flag-minus-one-unsigned': 'a 16-bit word equals -1 as int16_t exactly when it equals 0xffff as uint16_t',
    'c:pwd-rd16-unsigned': 'the helper returns int16_t: the (uint16_t) cast converts back to the same value',
    'num|B_RECT_F1 = 0x004,': 'the enumerator is documentation only: no code uses it (the field rectangles are read through literals)',
    'num|B_RECT_F2 = 0x014,': 'the enumerator is documentation only: no code uses it (the field rectangles are read through literals)',
    "char|if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')) return 1;":
        "':' (0x3a, the byte after '9') is accepted by the switch below anyway",
    'num|char typed[PWD_TEXT_BYTES + 1];': 'a longer local buffer; the last byte is still terminated and only bytes before the first NUL are read',
    'num|char word[PWD_TEXT_BYTES + 1];': 'a longer local buffer; the last byte is still terminated and only bytes before the first NUL are read',
    'num|typed[PWD_TEXT_BYTES] = 0;': 'byte 33 is read only when bytes 0..32 are all non-NUL: field byte 32 is cleared by phase 0 and typing never writes it, and the original would '
                                      'then run on into the next field (not a state the kernel claims)',
    'del|typed[PWD_TEXT_BYTES] = 0;': 'same as the num variant: byte 33 of the copy is never read for a field whose byte 32 is NUL',
    'num|word[PWD_TEXT_BYTES] = 0;': 'byte 33 of a word copy is read only after 33 non-NUL body bytes, which validation refuses (every word needs a NUL within its 33 bytes)',
    'del|word[PWD_TEXT_BYTES] = 0;': 'same as the num variant: validation guarantees a NUL within the 33 bytes',
    'num|matched = 1;': 'matched is only tested for non-zero',
    'num|int32_t vx = 0, vy = 0;': 'overwritten by the host on success; read only after a successful call (the oracle host always writes both)',
    'num|int16_t width = 0;': 'overwritten by the host on success; read only after a successful call',
    'num|int32_t busy = 0;': 'overwritten by the host on success; read only after a successful call',
    'num|rc = step_typing(state, body, host, 1);': '"second" is only used as a boolean (2 and 1 behave the same)',
    'del|rc = PWD_OK; /* the original switch has no other case */': 'rc already holds PWD_OK from the validation above',
    'del|break;': 'only the break before the end of the last case / switch is meant: removing it falls out of the switch anyway '
                  '(other break deletions are killed; an entry by text hides any further surviving break deletion, so check the list)',
    'del|op->text[PWD_TEXT_BYTES] = 0;': 'the whole result is cleared by the memset at the top and the copy covers 33 bytes: byte 33 is already zero',
    'num|char text[PWD_TEXT_BYTES + 1];': 'one more byte of the op text buffer is absorbed by the struct padding: sizeof(PwdOp) stays 80, which the oracle checks',
    'num|out->count = 1;': 'dead store: the count is set to 2 (or 3) a few lines later',
    'del|out->count = 1;': 'dead store: the count is set to 2 (or 3) a few lines later',
}


def mask(lines):
    """The lines with comments, string literals and character literals replaced by spaces (same length)."""
    out, in_comment = [], False
    for line in lines:
        res, i = [], 0
        while i < len(line):
            two = line[i:i + 2]
            if in_comment:
                if two == '*/':
                    in_comment = False
                    res.append('  ')
                    i += 2
                else:
                    res.append(' ')
                    i += 1
            elif two == '/*':
                in_comment = True
                res.append('  ')
                i += 2
            elif two == '//':
                res.append(' ' * (len(line) - i))
                break
            elif line[i] in '"\'':
                q = line[i]
                j = i + 1
                while j < len(line) and line[j] != q:
                    j += 2 if line[j] == '\\' else 1
                res.append(' ' * (min(j, len(line) - 1) - i + 1))
                i = j + 1
            else:
                res.append(line[i])
                i += 1
        out.append(''.join(res))
    return out


DECL = re.compile(r'^\s*(static\s+|const\s+|inline\s+)*(int|void|char|size_t|uint8_t|uint16_t|uint32_t|int8_t|int16_t|int32_t|PwdHost|PwdResult|PwdState|'
                  r'PwdTransition|PwdOp|PwdPointerResult|PwdClickResult|PwdRenderResult|PwdStatus|unsigned)\b[^=(]*(=.*)?;\s*$')
NUM = re.compile(r'(?<![\w.])(0x[0-9a-fA-F]+|\d+)(u|U)?(?![\w.])')
CHAR = re.compile(r"'(\\.|[^\\'])'")


def sites(path):
    """All mutation sites of one file: (kind, line index, new line text, tag)."""
    lines = path.read_text().split('\n')
    masked = mask(lines)
    out = []
    for n, (raw, m) in enumerate(zip(lines, masked)):
        stripped = m.strip()
        if not stripped or stripped.startswith('#include') or stripped.startswith('#ifndef') or stripped.startswith('#endif') or stripped.startswith('#ifdef'):
            continue
        is_define = stripped.startswith('#define')
        if stripped.startswith('#') and not is_define:
            continue

        def edit(start, end, text, kind):
            out.append((kind, n, raw[:start] + text + raw[end:], '%s' % kind))
        if not is_define:
            for op, new in (('==', '!='), ('!=', '=='), ('&&', '||'), ('||', '&&'), ('<=', '<'), ('>=', '>')):
                for mt in re.finditer(re.escape(op), m):
                    edit(mt.start(), mt.end(), new, 'op%s' % op)
            for mt in re.finditer(r'(?<![<>=\-!])<(?![<=])', m):
                edit(mt.start(), mt.end(), '<=', 'op<')
            for mt in re.finditer(r'(?<![<>=\-])>(?![>=])', m):
                edit(mt.start(), mt.end(), '>=', 'op>')
            for mt in re.finditer(r'(?<=\S) \+ (?=\S)', m):
                edit(mt.start(), mt.end(), ' - ', 'op+')
            for mt in re.finditer(r'(?<=\S) - (?=\S)', m):
                edit(mt.start(), mt.end(), ' + ', 'op-')
            for mt in re.finditer(r'(?<![!=<>])!(?!=)(?=[\w(])', m):
                edit(mt.start(), mt.end(), '', 'not')
        for mt in NUM.finditer(m):
            tok = mt.group(1)
            val = int(tok, 16) if tok.startswith('0x') else int(tok)
            new = ('0x%x' % (val + 1)) if tok.startswith('0x') else str(val + 1)
            edit(mt.start(1), mt.end(1), new, 'num')
        for mt in CHAR.finditer(raw):
            if m[mt.start():mt.end()].strip():          # still visible after masking: not in a comment
                continue
            ch = mt.group(1)
            if ch in ('\\b', '\\r'):
                nxt = {'\\b': "'\\t'", '\\r': "'\\n'"}[ch]
            elif len(ch) == 1:
                nxt = "'%s'" % chr(ord(ch) + 1) if ch not in ("'", '\\') and ord(ch) + 1 not in (39, 92) else None
            else:
                nxt = None
            if nxt and not stripped.startswith('#') or (nxt and is_define):
                out.append(('char', n, raw[:mt.start()] + nxt + raw[mt.end():], 'char'))
        body = stripped
        if (not is_define and body.endswith(';') and not DECL.match(m) and not body.startswith(('return', 'case', 'default', 'for', 'if', 'else', 'while', 'goto',
                                                                                                'continue', '}', 'static', 'typedef'))
                and not body.startswith('(')):
            lead = len(raw) - len(raw.lstrip())
            out.append(('del', n, raw[:lead] + ';', 'del'))
    return out


def mechanical(srcdir):
    muts = []
    for f in FILES:
        path = Path(srcdir) / f
        lines = path.read_text().split('\n')
        seen = {}
        for kind, n, new, tag in sites(path):
            key = (n, kind)
            seen[key] = seen.get(key, 0) + 1
            if new == lines[n]:
                continue
            name = '%s:L%d:%s:%d' % (f.replace('action_family_76_runtime', 'k'), n + 1, kind, seen[key])
            muts.append(dict(name=name, file=f, line=n, new_line=new, kind=kind, text=lines[n].strip(), occ=seen[key]))
    return muts


def curated(srcdir):
    muts = []
    for name, f, old, new, count, which in CURATED:
        text = (Path(srcdir) / f).read_text()
        muts.append(dict(name='c:' + name, file=f, old=old, new=new, count=count, which=which, kind='curated', text=name, occ=1,
                         valid=text.count(old) == count))
    return muts


def apply(mut, workdir, srcdir):
    for f in FILES:
        shutil.copy2(Path(srcdir) / f, Path(workdir) / f)
    p = Path(workdir) / mut['file']
    text = p.read_text()
    if 'old' in mut:
        if text.count(mut['old']) != mut['count']:
            return False
        parts = text.split(mut['old'])
        text = mut['old'].join(parts[:mut['which'] + 1]) + mut['new'] + mut['old'].join(parts[mut['which'] + 1:])
    else:
        lines = text.split('\n')
        lines[mut['line']] = mut['new_line']
        text = '\n'.join(lines)
    p.write_text(text)
    return True


def run_one(mut, srcdir, stage, timeout, strict=False):
    with tempfile.TemporaryDirectory(prefix='RT-58.mut-', dir=str(ROOT / 'work/analysis/slices')) as td:
        work = Path(td)
        if not apply(mut, work, srcdir):
            return dict(mut, status='INVALID', detail='edit site not found the stated number of times')
        cmd = [sys.executable, str(ORACLE), '--src', str(work), '--fail-fast', '--show', '1']
        if not strict:
            cmd.append('--lenient-build')
        if stage == 'quick':
            cmd.append('--quick-only')
        else:
            cmd += ['--workers', '1']
        try:
            done = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout, cwd=str(HERE))
        except subprocess.TimeoutExpired:
            return dict(mut, status='KILLED', detail='timeout (hang)')
        out = done.stdout + done.stderr
        if 'driver build failed' in out:
            return dict(mut, status='INVALID', detail='does not compile')
        if done.returncode == 0:
            last = [l for l in done.stdout.strip().splitlines() if l.startswith('{')]
            return dict(mut, status='SURVIVED', detail='0 mismatches')
        line = next((l for l in done.stdout.splitlines() if l.startswith('MISMATCH')), '')
        if not line:
            tail = (done.stderr.strip().splitlines() or ['crash'])[-1]
            return dict(mut, status='KILLED', detail='crash: ' + tail[:120])
        return dict(mut, status='KILLED', detail=line[:160])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--stage', choices=('quick', 'full'), default='quick')
    ap.add_argument('--only', default='')
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--result', type=Path)
    ap.add_argument('--src', type=Path, default=PROJECT / 'src')
    ap.add_argument('--list', action='store_true')
    ap.add_argument('--timeout', type=int, default=300)
    args = ap.parse_args()
    muts = curated(args.src) + mechanical(args.src)
    if args.only:
        muts = [m for m in muts if args.only in m['name'] or args.only in m['text']]
    if args.list:
        for m in muts:
            print(m['name'], '|', m['text'][:100], '|', m.get('new_line', m.get('new', ''))[:100].strip())
        print(len(muts), 'mutants (%d curated)' % sum(1 for m in muts if m['kind'] == 'curated'))
        return 0
    started = time.monotonic()
    shas = {f: hashlib.sha256((args.src / f).read_bytes()).hexdigest() for f in FILES}
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        results = list(pool.map(lambda m: run_one(m, args.src, args.stage, args.timeout), muts))
    if args.stage == 'quick':
        again = [m for m, r in zip(muts, results) if r['status'] == 'SURVIVED']
        print('quick stage: %d mutants, %d survived; re-running the survivors on the full scenario set' % (len(muts), len(again)), flush=True)
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            second = list(pool.map(lambda m: run_one(m, args.src, 'full', args.timeout * 4), again))
        by_name = {r['name']: r for r in second}
        results = [by_name.get(r['name'], r) if r['status'] == 'SURVIVED' else r for r in results]
    # a survivor that only the lenient build lets through is still rejected by the strict -Wall -Wextra -Wpedantic -Werror build the project
    # uses (deleted prototypes: implicit declaration); those are reported as a separate class, not as oracle kills
    left = [m for m, r in zip(muts, results) if r['status'] == 'SURVIVED']
    if left:
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            strict = list(pool.map(lambda m: run_one(m, args.src, 'quick', args.timeout, True), left))
        rejected = {r['name'] for r in strict if r['status'] == 'INVALID'}
        results = [dict(r, status='STRICT', detail='rejected by the strict -Werror build') if r['name'] in rejected else r for r in results]
    invalid = [r for r in results if r['status'] == 'INVALID']
    strict_killed = [r for r in results if r['status'] == 'STRICT']
    counted = [r for r in results if r['status'] not in ('INVALID', 'STRICT')]
    survivors = [r for r in counted if r['status'] == 'SURVIVED']
    equiv = [r for r in survivors if r['name'] in EQUIVALENT or '%s|%s' % (r['kind'], r['text']) in EQUIVALENT]
    open_survivors = [r for r in survivors if r not in equiv]
    killed = [r for r in counted if r['status'] == 'KILLED']
    print('mutants %d  invalid %d  rejected by the strict build %d  counted %d  killed %d  survived %d (equivalent with reason %d, open %d)  kill rate of the non-equivalent %.2f%%  %.0f s' % (
        len(results), len(invalid), len(strict_killed), len(counted), len(killed), len(survivors), len(equiv), len(open_survivors),
        100.0 * len(killed) / max(1, len(killed) + len(open_survivors)), time.monotonic() - started))
    for r in open_survivors:
        print('SURVIVOR', r['name'], '|', r['text'][:110], '|', (r.get('new_line') or r.get('new') or '').strip()[:110])
    if args.result:
        args.result.parent.mkdir(parents=True, exist_ok=True)
        args.result.write_text(json.dumps(dict(slice='RT-58', source_sha256=shas, stage=args.stage, total=len(results), invalid=len(invalid), strict_rejected=len(strict_killed), killed=len(killed),
                                               survived=len(survivors), equivalent=len(equiv),
                                               results=[{k: v for k, v in r.items() if k in ('name', 'status', 'detail', 'text', 'kind')} for r in results]),
                                          indent=1, sort_keys=True) + '\n')
    return 0 if not open_survivors else 1


if __name__ == '__main__':
    sys.exit(main())
