#!/usr/bin/env python3
"""RT-53 mutation check for the raw-0xd3 oracle.

Every mutant is a one-site textual edit of a COPY of src/action_family_d3_runtime.c (the project file is never touched). Each mutant is
built into a driver library and run through the original-x86 oracle (action_family_d3_runtime_original_oracle.py, `--src DIR`). A mutant
is KILLED when the oracle reports at least one mismatch against the unmodified GAME.EXE image (or one of its native-only refusal
checks fails); it SURVIVES when the oracle still reports 0 mismatches; it is INVALID if it does not compile or the edit site is not
found the stated number of times (invalid mutants never count as killed).

Usage:  python3 action_family_d3_runtime_mutation_check.py [--stage quick|full] [--only NAME] [--jobs N] [--result FILE]
Stage `quick` runs the oracle's --quick-only subset (plus the native refusal checks); survivors are re-run on the full scenario set
(--stage full runs every mutant on the full set). Mutants run in parallel, one single-process oracle per mutant (--jobs, default 4).
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
ORACLE = HERE / 'action_family_d3_runtime_original_oracle.py'
KERNEL = 'action_family_d3_runtime.c'

# (name, class, old text, new text, expected occurrences of old text, index of the occurrence to edit)
M = []


def m(name, cls, old, new, count=1, which=0):
    M.append((name, cls, old, new, count, which))


def drop(name, cls, stmt, count=1, which=0, keep=''):
    """Delete a statement (replace it by `keep`)."""
    m(name, cls, stmt, keep, count, which)


# ---- the "NO SOUND\0" test (repe cmpsb, 9 bytes)
m('nosound-8-bytes', 'compare', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8) == 0;')
m('nosound-case', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'n', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}")
m('nosound-last-char', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'E', 0}")
m('nosound-inverted', 'predicate', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k) != 0;')
# ---- native body validation (checked by the refusal checks)
m('validate-length-lt', 'validate', 'length != CPZ_BODY_BYTES)', 'length < CPZ_BODY_BYTES)')
m('validate-name-short', 'validate', 'memchr(body, 0, CPZ_NAME_BYTES) == NULL', 'memchr(body, 0, CPZ_NAME_BYTES - 1) == NULL')
m('validate-rows-max', 'validate', 'rd_s16(body, B_ROWS) > CPZ_GRID_MAX', 'rd_s16(body, B_ROWS) >= CPZ_GRID_MAX')
m('validate-rows-neg', 'validate', 'rd_s16(body, B_ROWS) < 0 ||', '0 ||')
m('validate-cols-max', 'validate', 'rd_s16(body, B_COLS) > CPZ_GRID_MAX', 'rd_s16(body, B_COLS) >= CPZ_GRID_MAX')
m('validate-cols-neg', 'validate', 'rd_s16(body, B_COLS) < 0 ||', '0 ||')
m('validate-pieces-max', 'validate', 'rd_s16(body, B_PIECES) > CPZ_PIECES_MAX', 'rd_s16(body, B_PIECES) >= CPZ_PIECES_MAX')
m('validate-pieces-neg', 'validate', 'rd_s16(body, B_PIECES) < 0 ||', '0 ||')
m('validate-steps-zero', 'validate', 'rd_s16(body, B_STEPS) < 1', 'rd_s16(body, B_STEPS) < 0')
m('validate-steps-one', 'validate', 'rd_s16(body, B_STEPS) < 1', 'rd_s16(body, B_STEPS) < 2')
for letter in 'ABC':
    m('validate-sound-%s-skipped' % letter, 'validate', 'memchr(body + B_SOUND_%s, 0, CPZ_SOUND_BYTES) == NULL ||' % letter, '0 ||')
m('validate-sound-D-skipped', 'validate', 'memchr(body + B_SOUND_D, 0, CPZ_SOUND_BYTES) == NULL) {', '0) {')
m('validate-sound-short', 'validate', 'memchr(body + B_SOUND_A, 0, CPZ_SOUND_BYTES) == NULL', 'memchr(body + B_SOUND_A, 0, CPZ_SOUND_BYTES - 1) == NULL')
# ---- 0x462b84 cell rectangle
m('rect-gap-uses-row', 'index', 'mul32(gap, b)', 'mul32(gap, a)')
m('rect-gap-uses-col-for-y', 'index', 'mul32(gap, a)', 'mul32(gap, b)')
m('rect-origin-x-is-y', 'field', 'rd_s32(body, B_ORIGIN_X)', 'rd_s32(body, B_ORIGIN_Y)')
m('rect-origin-y-is-x', 'field', 'rd_s32(body, B_ORIGIN_Y)', 'rd_s32(body, B_ORIGIN_X)')
m('rect-view-x-is-y', 'field', 'add32(add32(add32(mul32(gap, b), view_x)', 'add32(add32(add32(mul32(gap, b), view_y)')
m('rect-view-y-is-x', 'field', 'add32(add32(add32(mul32(gap, a), view_y)', 'add32(add32(add32(mul32(gap, a), view_x)')
m('rect-col-uses-height', 'field', 'mul32(b, o->cell_w)', 'mul32(b, o->cell_h)')
m('rect-row-uses-width', 'field', 'mul32(a, o->cell_h)', 'mul32(a, o->cell_w)')
m('rect-right-uses-height', 'field', 'out[2] = add32(out[0], o->cell_w);', 'out[2] = add32(out[0], o->cell_h);')
m('rect-bottom-uses-width', 'field', 'out[3] = add32(out[1], o->cell_h);', 'out[3] = add32(out[1], o->cell_w);')
m('rect-gap-sign', 'sign', 'const int32_t gap = rd_s16(body, B_GAP);', 'const int32_t gap = (uint16_t)rd_s16(body, B_GAP);')
# ---- 0x462577 grid setup
m('setup-not-skipped-when-ready', 'missing-effect', 'if (world->grid_ready != 0) return;', ';')
m('setup-flag-not-set', 'missing-effect', 'world->grid_ready = 1;\n    for', 'for')
m('setup-types-transposed', 'index', 'B_TYPES + (size_t)a * 16u + (size_t)b * 2u', 'B_TYPES + (size_t)b * 16u + (size_t)a * 2u')
m('setup-type-visible-positive-only', 'compare', 'if (c->type != 0) {', 'if (c->type > 0) {')
m('setup-gap-half-shift', 'arith', 'rd_s16(body, B_GAP) / 2', 'rd_s16(body, B_GAP) >> 1')
m('setup-gap-half-unsigned', 'arith', 'const int32_t gap_half = rd_s16(body, B_GAP) / 2;', 'const int32_t gap_half = (int32_t)((uint16_t)rd_s16(body, B_GAP) / 2u);')
m('setup-arrow-h-width-swapped', 'operand', 'sub32(rd_s32(body, B_ARROW_H + 8), rd_s32(body, B_ARROW_H))', 'sub32(rd_s32(body, B_ARROW_H), rd_s32(body, B_ARROW_H + 8))')
m('setup-arrow-h-height-swapped', 'operand', 'sub32(rd_s32(body, B_ARROW_H + 12), rd_s32(body, B_ARROW_H + 4))', 'sub32(rd_s32(body, B_ARROW_H + 4), rd_s32(body, B_ARROW_H + 12))')
m('setup-arrow-v-width-swapped', 'operand', 'sub32(rd_s32(body, B_ARROW_V + 8), rd_s32(body, B_ARROW_V))', 'sub32(rd_s32(body, B_ARROW_V), rd_s32(body, B_ARROW_V + 8))')
m('setup-arrow-v-height-swapped', 'operand', 'sub32(rd_s32(body, B_ARROW_V + 12), rd_s32(body, B_ARROW_V + 4))', 'sub32(rd_s32(body, B_ARROW_V + 4), rd_s32(body, B_ARROW_V + 12))')
m('setup-arrow-h-offset-shift', 'arith', 'sub32(o->cell_h, h) / 2', 'sub32(o->cell_h, h) >> 1')
m('setup-arrow-v-offset-shift', 'arith', 'sub32(o->cell_w, w) / 2', 'sub32(o->cell_w, w) >> 1')
m('setup-arrow-h-top-sign', 'sign', 'c->base[1] = add32(c->base[1], off);', 'c->base[1] = sub32(c->base[1], off);')
m('setup-arrow-h-bottom-sign', 'sign', 'c->base[3] = sub32(c->base[3], off);', 'c->base[3] = add32(c->base[3], off);')
m('setup-arrow-v-left-sign', 'sign', 'c->base[0] = add32(c->base[0], off);', 'c->base[0] = sub32(c->base[0], off);')
m('setup-arrow-v-right-sign', 'sign', 'c->base[2] = sub32(c->base[2], off);', 'c->base[2] = add32(c->base[2], off);')
m('setup-arrow-left-gap', 'sign', 'c->base[0] = sub32(sub32(c->base[0], gap_half), w / 2);', 'c->base[0] = sub32(add32(c->base[0], gap_half), w / 2);')
m('setup-arrow-left-half-width', 'arith', 'c->base[0] = sub32(sub32(c->base[0], gap_half), w / 2);', 'c->base[0] = sub32(sub32(c->base[0], gap_half), w >> 1);')
m('setup-arrow-right-gap', 'sign', 'c->base[0] = sub32(add32(c->base[2], gap_half), w / 2);', 'c->base[0] = sub32(sub32(c->base[2], gap_half), w / 2);')
m('setup-arrow-right-uses-left', 'field', 'c->base[0] = sub32(add32(c->base[2], gap_half), w / 2);', 'c->base[0] = sub32(add32(c->base[0], gap_half), w / 2);')
m('setup-arrow-h-right-edge', 'field', 'c->base[2] = add32(c->base[0], w);', 'c->base[2] = add32(c->base[0], h);')
m('setup-arrow-up-gap', 'sign', 'c->base[1] = sub32(sub32(c->base[1], gap_half), h / 2);', 'c->base[1] = sub32(add32(c->base[1], gap_half), h / 2);')
m('setup-arrow-up-half-height', 'arith', 'c->base[1] = sub32(sub32(c->base[1], gap_half), h / 2);', 'c->base[1] = sub32(sub32(c->base[1], gap_half), h >> 1);')
m('setup-arrow-down-gap', 'sign', 'c->base[1] = sub32(add32(c->base[3], gap_half), h / 2);', 'c->base[1] = sub32(sub32(c->base[3], gap_half), h / 2);')
m('setup-arrow-down-uses-top', 'field', 'c->base[1] = sub32(add32(c->base[3], gap_half), h / 2);', 'c->base[1] = sub32(add32(c->base[1], gap_half), h / 2);')
m('setup-arrow-v-bottom-edge', 'field', 'c->base[3] = add32(c->base[1], h);', 'c->base[3] = add32(c->base[1], w);')
m('setup-arrow-right-missing', 'case', 'case CPZ_DIR_LEFT:\n                case CPZ_DIR_RIGHT: {', 'case CPZ_DIR_LEFT: {')
m('setup-arrow-down-missing', 'case', 'case CPZ_DIR_UP:\n                case CPZ_DIR_DOWN: {', 'case CPZ_DIR_UP: {')
m('setup-arrow-up-is-down', 'case', 'if (c->type == CPZ_DIR_UP) {', 'if (c->type == CPZ_DIR_DOWN) {')
m('setup-arrow-left-is-right-test', 'case', 'if (c->type == CPZ_DIR_LEFT) {', 'if (c->type == CPZ_DIR_RIGHT) {')
m('setup-start-col-row-swapped', 'index', 'rd_s16(body, B_START + (size_t)k * 4u) == b && rd_s16(body, B_START + 2u + (size_t)k * 4u) == a',
  'rd_s16(body, B_START + (size_t)k * 4u) == a && rd_s16(body, B_START + 2u + (size_t)k * 4u) == b')
m('setup-piece-number-zero-based', 'constant', 'c->piece = (int16_t)(k + 1);', 'c->piece = (int16_t)k;')
m('setup-piece-not-visible', 'missing-effect', 'c->visible = 1;\n                    c->piece', 'c->piece')
m('setup-piece-count-ignored', 'compare', 'for (int16_t k = 0; k < pieces; ++k) {', 'for (int16_t k = 0; k < pieces - 1; ++k) {')
m('setup-cols-short', 'compare', 'for (int16_t b = 0; b < cols; ++b) {\n            CpzCell *c', 'for (int16_t b = 0; b < cols - 1; ++b) {\n            CpzCell *c')
m('setup-rows-short', 'compare', 'for (int16_t a = 0; a < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            CpzCell *c', 'for (int16_t a = 0; a < rows - 1; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            CpzCell *c')
m('setup-cell-not-cleared', 'missing-effect', 'memset(c, 0, sizeof(*c));\n            c->type', 'c->type')
m('setup-rect-not-set', 'missing-effect', 'cell_rect(o, body, view_x, view_y, a, b, c->rect);\n            if', 'if')
m('setup-base-not-set', 'missing-effect', 'cell_rect(o, body, view_x, view_y, a, b, c->base);\n', '')
# ---- 0x4619be move check
m('can-left-edge', 'compare', 'if (b == 0) ok = 0;', 'if (b == 1) ok = 0;')
m('can-up-edge', 'compare', 'if (a == 0) ok = 0;', 'if (a == 1) ok = 0;')
m('can-down-edge', 'compare', 'if (a == rd_s16(body, B_ROWS) - 1) ok = 0;', 'if (a == rd_s16(body, B_ROWS) - 2) ok = 0;')
m('can-right-edge', 'compare', 'if (b == rd_s16(body, B_COLS) - 1) ok = 0;', 'if (b == rd_s16(body, B_COLS) - 2) ok = 0;')
for d, dd, na, op in (('LEFT', 'RIGHT', 'cell[a][b - 1]', None), ('UP', 'DOWN', 'cell[a - 1][b]', None), ('DOWN', 'UP', 'cell[a + 1][b]', None),
                      ('RIGHT', 'LEFT', 'cell[a][b + 1]', None)):
    m('can-%s-own-arrow' % d.lower(), 'missing-clause', 'world->cell[a][b].type == CPZ_DIR_%s ||' % d, '0 ||')
    m('can-%s-neighbour-arrow' % d.lower(), 'missing-clause', 'world->%s.type == CPZ_DIR_%s ||' % (na, dd), '0 ||')
    m('can-%s-neighbour-piece' % d.lower(), 'missing-clause', 'world->%s.piece != 0 ||' % na, '0 ||')
    m('can-%s-neighbour-wall' % d.lower(), 'missing-clause', 'world->%s.type == CPZ_CELL_WALL)' % na, '0)')
    m('can-%s-own-arrow-wrong' % d.lower(), 'constant', 'world->cell[a][b].type == CPZ_DIR_%s ||' % d, 'world->cell[a][b].type == CPZ_DIR_%s ||' % dd)
m('can-wall-constant', 'constant', 'world->cell[a][b - 1].type == CPZ_CELL_WALL)', 'world->cell[a][b - 1].type == 0x15)')
m('can-dir-not-stored', 'missing-effect', 'o->dir = dir;\n', '')
m('can-refusal-keeps-piece', 'missing-effect', 'o->piece = 0;\n        o->dir = 0;\n        o->step = 0;', 'o->dir = 0;\n        o->step = 0;')
m('can-refusal-keeps-dir', 'missing-effect', 'o->piece = 0;\n        o->dir = 0;\n        o->step = 0;', 'o->piece = 0;\n        o->step = 0;')
m('can-refusal-keeps-step', 'missing-effect', 'o->piece = 0;\n        o->dir = 0;\n        o->step = 0;', 'o->piece = 0;\n        o->dir = 0;')
m('can-result-inverted', 'predicate', 'return ok;\n}\n\n/* 0x461d82', 'return !ok;\n}\n\n/* 0x461d82')
# ---- 0x461d82 move step
m('step-saved-missing', 'missing-effect', 'memcpy(o->saved, c->rect, sizeof(o->saved));', ';')
m('step-left-sign', 'sign', 'o->dir == CPZ_DIR_LEFT ? sub32(c->rect[0], o->cell_w / steps) : add32(c->rect[0], o->cell_w / steps)',
  'o->dir == CPZ_DIR_LEFT ? add32(c->rect[0], o->cell_w / steps) : sub32(c->rect[0], o->cell_w / steps)')
m('step-h-delta-height', 'field', 'sub32(c->rect[0], o->cell_w / steps)', 'sub32(c->rect[0], o->cell_h / steps)')
m('step-h-delta-height-right', 'field', 'add32(c->rect[0], o->cell_w / steps)', 'add32(c->rect[0], o->cell_h / steps)')
m('step-h-delta-no-divide', 'arith', 'sub32(c->rect[0], o->cell_w / steps)', 'sub32(c->rect[0], o->cell_w)')
m('step-h-delta-rounded-up', 'arith', 'add32(c->rect[0], o->cell_w / steps)', 'add32(c->rect[0], (o->cell_w + steps - 1) / steps)')
m('step-h-delta-shift', 'arith', 'add32(c->rect[0], o->cell_w / steps)', 'add32(c->rect[0], (steps == 1 ? o->cell_w : o->cell_w >> 1) / (steps == 1 ? 1 : steps >> 1 ? steps / 2 : 1))')
m('step-h-right-edge', 'field', 'c->rect[2] = add32(c->rect[0], o->cell_w);', 'c->rect[2] = add32(c->rect[0], o->cell_h);')
m('step-up-sign', 'sign', 'o->dir == CPZ_DIR_UP ? sub32(c->rect[1], o->cell_h / steps) : add32(c->rect[1], o->cell_h / steps)',
  'o->dir == CPZ_DIR_UP ? add32(c->rect[1], o->cell_h / steps) : sub32(c->rect[1], o->cell_h / steps)')
m('step-v-delta-width', 'field', 'sub32(c->rect[1], o->cell_h / steps)', 'sub32(c->rect[1], o->cell_w / steps)')
m('step-v-delta-width-down', 'field', 'add32(c->rect[1], o->cell_h / steps)', 'add32(c->rect[1], o->cell_w / steps)')
m('step-v-bottom-edge', 'field', 'c->rect[3] = add32(c->rect[1], o->cell_h);', 'c->rect[3] = add32(c->rect[1], o->cell_w);')
m('step-unknown-dir-continues', 'case', 'default:\n        return 0;\n    }\n    o->step', 'default:\n        break;\n    }\n    o->step')
m('step-counter-by-two', 'constant', 'o->step = (int16_t)(o->step + 1);', 'o->step = (int16_t)(o->step + 2);')
m('step-arrival-ge', 'compare', 'if (o->step == rd_s16(body, B_STEPS)) {', 'if (o->step >= rd_s16(body, B_STEPS)) {')
m('step-arrival-one-early', 'compare', 'if (o->step == rd_s16(body, B_STEPS)) {', 'if (o->step == rd_s16(body, B_STEPS) - 1 && o->step > 0) {')
m('step-arrival-piece-kept', 'missing-effect', '        c->piece = 0;\n        if (c->type == 0)', '        if (c->type == 0)')
m('step-arrival-visible-always-off', 'predicate', 'if (c->type == 0) c->visible = 0;', 'c->visible = 0;')
m('step-arrival-visible-never-off', 'missing-effect', 'if (c->type == 0) c->visible = 0;', ';')
m('step-arrival-visible-inverted', 'predicate', 'if (c->type == 0) c->visible = 0;', 'if (c->type != 0) c->visible = 0;')
m('step-arrival-rect-not-reset', 'missing-effect', 'cell_rect(o, body, view_x, view_y, o->at_row, o->at_col, c->rect);', ';')
m('step-arrival-rect-wrong-cell', 'index', 'cell_rect(o, body, view_x, view_y, o->at_row, o->at_col, c->rect);', 'cell_rect(o, body, view_x, view_y, o->at_col, o->at_row, c->rect);')
m('step-arrival-left', 'sign', 'case CPZ_DIR_LEFT: o->at_col = (int16_t)(o->at_col - 1); break;', 'case CPZ_DIR_LEFT: o->at_col = (int16_t)(o->at_col + 1); break;')
m('step-arrival-up', 'sign', 'case CPZ_DIR_UP: o->at_row = (int16_t)(o->at_row - 1); break;', 'case CPZ_DIR_UP: o->at_row = (int16_t)(o->at_row + 1); break;')
m('step-arrival-down', 'sign', 'case CPZ_DIR_DOWN: o->at_row = (int16_t)(o->at_row + 1); break;', 'case CPZ_DIR_DOWN: o->at_row = (int16_t)(o->at_row - 1); break;')
m('step-arrival-right', 'sign', 'default: o->at_col = (int16_t)(o->at_col + 1); break;', 'default: o->at_col = (int16_t)(o->at_col - 1); break;')
m('step-arrival-piece-number-lost', 'missing-effect', 'c->piece = o->piece;', ';')
m('step-arrival-visible-missing', 'missing-effect', 'c->piece = o->piece;\n        c->visible = 1;', 'c->piece = o->piece;')
m('step-arrival-counter-kept', 'missing-effect', 'c->visible = 1;\n        o->step = 0;', 'c->visible = 1;')
m('step-arrival-result-zero', 'constant', 'arrived = 1;\n        o->moved = 1;', 'o->moved = 1;')
m('step-arrival-moved-missing', 'missing-effect', 'arrived = 1;\n        o->moved = 1;', 'arrived = 1;')
# ---- 0x4632bf solved scan and 0x461d4b type test
m('type-is-inverted', 'predicate', 'return world->cell[a][b].type == piece;', 'return world->cell[a][b].type != piece;')
m('scan-cols-short', 'compare', 'for (int16_t b = 0; b < cols; ++b)\n            if', 'for (int16_t b = 0; b < cols - 1; ++b)\n            if')
m('scan-rows-short', 'compare', 'for (int16_t a = 0; a < rows; ++a)\n        for (int16_t b = 0; b < cols; ++b)\n            if', 'for (int16_t a = 0; a < rows - 1; ++a)\n        for (int16_t b = 0; b < cols; ++b)\n            if')
m('scan-empty-cells-count', 'predicate', 'if (world->cell[a][b].piece != 0 && !type_is(world, world->cell[a][b].piece, a, b)) return;', 'if (!type_is(world, world->cell[a][b].piece, a, b)) return;')
m('scan-any-piece-solves', 'predicate', 'if (world->cell[a][b].piece != 0 && !type_is(world, world->cell[a][b].piece, a, b)) return;', 'if (world->cell[a][b].piece != 0 && type_is(world, world->cell[a][b].piece, a, b)) return;')
m('scan-solved-flag-missing', 'missing-effect', 'o->solved = 1;\n    o->state = CPZ_STATE_SOLVED;', 'o->state = CPZ_STATE_SOLVED;')
m('scan-state-missing', 'missing-effect', 'o->solved = 1;\n    o->state = CPZ_STATE_SOLVED;\n    fx(host, CPZ_FX_STATE, o->state, 0);', 'o->solved = 1;')
m('scan-state-effect-missing', 'missing-effect', 'o->state = CPZ_STATE_SOLVED;\n    fx(host, CPZ_FX_STATE, o->state, 0);\n}', 'o->state = CPZ_STATE_SOLVED;\n}')
# ---- the scene block of phase 2
m('block-scene-test', 'compare', 'if (rd_s16(blk, SB_SCENE) != CPZ_NO_SCENE) {', 'if (rd_s16(blk, SB_SCENE) == CPZ_NO_SCENE) {')
m('block-scene-sign', 'sign', 't.scene = rd_s16(blk, SB_SCENE);', 't.scene = (int16_t)(uint16_t)rd_s16(blk, SB_SCENE) & 0x7fff;')
m('block-word1-offset', 'field', 't.word[0] = rd_s16(blk, SB_W1);', 't.word[0] = rd_s16(blk, SB_W2);')
m('block-word2-offset', 'field', 't.word[1] = rd_s16(blk, SB_W2);', 't.word[1] = rd_s16(blk, SB_W3);')
m('block-word3-offset', 'field', 't.word[2] = rd_s16(blk, SB_W3);', 't.word[2] = rd_s16(blk, SB_W1);')
m('block-dword1-offset', 'field', 't.dword[0] = rd_s32(blk, SB_D1);', 't.dword[0] = rd_s32(blk, SB_D2);')
m('block-dword2-offset', 'field', 't.dword[1] = rd_s32(blk, SB_D2);', 't.dword[1] = rd_s32(blk, SB_D3);')
m('block-dword3-offset', 'field', 't.dword[2] = rd_s32(blk, SB_D3);', 't.dword[2] = rd_s32(blk, SB_D1);')
m('block-start-flag-inverted', 'predicate', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) == 1 ? 1 : 0;')
m('block-start-flag-nonzero', 'predicate', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 0 ? 1 : 0;')
m('block-start-flag-missing', 'missing-effect', 'fx(host, CPZ_FX_START_FLAG, world->start_flag_5bb1ca, 0);\n        fx(host, CPZ_FX_ENGINE_MODE, 4, 0);',
  'fx(host, CPZ_FX_ENGINE_MODE, 4, 0);')
m('block-engine-mode-missing', 'missing-effect', 'fx(host, CPZ_FX_ENGINE_MODE, 4, 0);', ';')
m('block-engine-mode-wrong', 'constant', 'fx(host, CPZ_FX_ENGINE_MODE, 4, 0);', 'fx(host, CPZ_FX_ENGINE_MODE, 3, 0);')
m('block-flag-none-test', 'compare', 'if (flag != CPZ_NO_FLAG) {', 'if (flag == CPZ_NO_FLAG) {')
m('block-flag-value-field', 'field', 'store_event_flag(host->context, flag, blk[SB_VALUE])', 'store_event_flag(host->context, flag, blk[SB_FLAG])')
m('block-flag-value-field-effect', 'field', 'fx(host, CPZ_FX_EVENT_FLAG, flag, blk[SB_VALUE]);', 'fx(host, CPZ_FX_EVENT_FLAG, flag, blk[SB_VALUE] & 0x7f);')
# ---- phase 0
m('p0-row-not-stored', 'missing-effect', 'o->row = row;', ';')
m('p0-active-missing', 'missing-effect', 'o->active = 1;\n    fx(host, CPZ_FX_ACTIVE, 1, 0);', 'fx(host, CPZ_FX_ACTIVE, 1, 0);')
m('p0-active-effect-missing', 'missing-effect', 'fx(host, CPZ_FX_ACTIVE, 1, 0);', ';')
m('p0-start-flag-missing', 'missing-effect', 'world->start_flag_5bb1ca = 1;\n    fx(host, CPZ_FX_START_FLAG, 1, 0);\n    if (body[B_PERSIST]', 'fx(host, CPZ_FX_START_FLAG, 1, 0);\n    if (body[B_PERSIST]')
m('p0-persist-inverted', 'predicate', 'if (body[B_PERSIST] == 0) {', 'if (body[B_PERSIST] != 0) {')
m('p0-persist-low-bit', 'predicate', 'if (body[B_PERSIST] == 0) {', 'if ((body[B_PERSIST] & 1) == 0) {')
m('p0-grid-reset-missing', 'missing-effect', 'cpz_grid_reset(world);\n        fx(host, CPZ_FX_GRID_RESET, 0, 0);', 'fx(host, CPZ_FX_GRID_RESET, 0, 0);')
m('p0-cell-width-swapped', 'operand', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC));', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC), rd_s32(body, B_PIECE_SRC + 8));')
m('p0-cell-width-field', 'field', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC));', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC + 4));')
m('p0-cell-height-swapped', 'operand', 'o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC + 4));', 'o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 4), rd_s32(body, B_PIECE_SRC + 12));')
m('p0-cell-height-field', 'field', 'o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC + 4));', 'o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC));')
m('p0-cell-size-after-setup', 'order', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC));\n    o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC + 4));\n    HOST(host->view_origin(host->context, &view_x, &view_y));',
  'HOST(host->view_origin(host->context, &view_x, &view_y));\n    o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC));\n    o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC + 4));')
m('p0-setup-before-cell-size', 'order', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC));\n    o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC + 4));\n    HOST(host->view_origin(host->context, &view_x, &view_y));\n    {\n        const int ran = world->grid_ready == 0;\n        grid_setup(o, body, world, view_x, view_y);',
  'HOST(host->view_origin(host->context, &view_x, &view_y));\n    {\n        const int ran = world->grid_ready == 0;\n        grid_setup(o, body, world, view_x, view_y);\n        o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC));\n        o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC + 4));')
m('p0-setup-effect-flag-inverted', 'predicate', 'const int ran = world->grid_ready == 0;', 'const int ran = world->grid_ready != 0;')
m('p0-setup-effect-missing', 'missing-effect', 'fx(host, CPZ_FX_GRID_SETUP, ran, 0);', ';')
m('p0-clear-item-missing', 'missing-effect', 'HOST(host->clear_pending_item(host->context));\n    fx(host, CPZ_FX_CLEAR_ITEM, 0, 0);', 'fx(host, CPZ_FX_CLEAR_ITEM, 0, 0);')
m('p0-clear-item-late', 'order', 'HOST(host->clear_pending_item(host->context));\n    fx(host, CPZ_FX_CLEAR_ITEM, 0, 0);\n    o->cell_w', 'o->cell_w')
m('p0-flag28-missing', 'missing-effect', 'o->flag28 = 1;', ';')
m('p0-slot-not-stored', 'missing-effect', 'o->slot = slot;\n        fx(host, CPZ_FX_SLOT, slot, 0);', 'fx(host, CPZ_FX_SLOT, slot, 0);')
m('p0-register-label', 'constant', '"COLLISION PUZZLE OVERLAYS"));', '"COLLISION PUZZLE OVERLAYZ"));')
m('p0-surface-load-always', 'predicate', 'if (o->surface == 0u) {', 'if (1) {')
m('p0-surface-load-never', 'predicate', 'if (o->surface == 0u) {', 'if (0) {')
m('p0-surface-load-inverted', 'predicate', 'if (o->surface == 0u) {', 'if (o->surface != 0u) {')
m('p0-surface-not-stored', 'missing-effect', 'o->surface = surface;', ';')
m('p0-name-not-passed', 'field', 'host->load_surface(host->context, (const char *)body, &surface)', 'host->load_surface(host->context, (const char *)body + 1, &surface)')
m('p0-slot-surface-wrong', 'field', 'host->set_slot_surface(host->context, slot, o->surface)', 'host->set_slot_surface(host->context, slot, 0)')
m('p0-sound-A-inverted', 'predicate', 'if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_prepare', 'if (no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_prepare')
m('p0-sound-B-inverted', 'predicate', 'if (!no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_prepare', 'if (no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_prepare')
m('p0-sound-C-inverted', 'predicate', 'if (!no_sound(body + B_SOUND_C)) {\n        HOST(host->sound_prepare', 'if (no_sound(body + B_SOUND_C)) {\n        HOST(host->sound_prepare')
m('p0-sound-B-record', 'field', 'HOST(host->sound_prepare(host->context, body + B_SOUND_B));', 'HOST(host->sound_prepare(host->context, body + B_SOUND_C));')
m('p0-sound-C-record', 'field', 'HOST(host->sound_prepare(host->context, body + B_SOUND_C));', 'HOST(host->sound_prepare(host->context, body + B_SOUND_B));')
m('p0-sound-A-never-prepared', 'missing-effect', 'HOST(host->sound_prepare(host->context, body + B_SOUND_A));\n        fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_A, 0);', '')
m('p0-solved-kept', 'missing-effect', 'o->solved = 0;\n    o->canceled = 0;', 'o->canceled = 0;')
m('p0-canceled-kept', 'missing-effect', 'o->canceled = 0;\n    o->state = CPZ_STATE_IDLE;', 'o->state = CPZ_STATE_IDLE;')
m('p0-state-kept', 'missing-effect', 'o->state = CPZ_STATE_IDLE;\n    o->piece = 0;', 'o->piece = 0;')
m('p0-piece-kept', 'missing-effect', 'o->piece = 0;\n    o->dir = 0;\n    o->step = 0;\n    o->moved = 0;', 'o->dir = 0;\n    o->step = 0;\n    o->moved = 0;')
m('p0-dir-kept', 'missing-effect', 'o->dir = 0;\n    o->step = 0;\n    o->moved = 0;', 'o->step = 0;\n    o->moved = 0;')
m('p0-step-kept', 'missing-effect', 'o->step = 0;\n    o->moved = 0;\n    memset', 'o->moved = 0;\n    memset')
m('p0-moved-kept', 'missing-effect', 'o->moved = 0;\n    memset(o->saved', 'memset(o->saved')
m('p0-saved-kept', 'missing-effect', 'memset(o->saved, 0, sizeof(o->saved));\n    return CPZ_OK;', 'return CPZ_OK;')
# ---- phase 1
m('p1-idle-moved-kept', 'missing-effect', 'o->moved = 0;\n        if (o->solved == 0) {', 'if (o->solved == 0) {')
m('p1-idle-solved-test', 'predicate', 'if (o->solved == 0) {\n            solved_scan', 'if (o->solved != 0) {\n            solved_scan')
m('p1-idle-solved-state-missing', 'missing-effect', 'o->state = CPZ_STATE_SOLVED;\n            fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;', 'fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;')
m('p1-delay-ms', 'constant', '* 1000);', '* 100);')
m('p1-delay-unsigned', 'sign', '(uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000)', '(uint32_t)((uint16_t)rd_s16(body, B_DELAY) * 1000)')
m('p1-delay-field', 'field', 'rd_s16(body, B_DELAY)', 'rd_s16(body, B_STEPS)')
m('p1-delay-state-wrong', 'constant', 'o->state = CPZ_STATE_WAIT_DELAY;\n        fx(host, CPZ_FX_STATE, o->state, 0);\n        break;', 'o->state = CPZ_STATE_WAIT_SOUND;\n        fx(host, CPZ_FX_STATE, o->state, 0);\n        break;')
m('p1-delay-tick-missing', 'missing-effect', 'o->deadline = now + ', 'o->deadline = 0 * now + ')
m('p1-moving-origin-missing', 'missing-effect', 'HOST(host->view_origin(host->context, &view_x, &view_y));\n        if (move_step', 'if (move_step')
m('p1-moving-or', 'predicate', 'if (move_step(o, body, world, view_x, view_y) != 0 && can_move(o, world, body, o->dir) == 0) {', 'if (move_step(o, body, world, view_x, view_y) != 0 || can_move(o, world, body, o->dir) == 0) {')
m('p1-moving-continue-inverted', 'predicate', 'can_move(o, world, body, o->dir) == 0) {', 'can_move(o, world, body, o->dir) != 0) {')
m('p1-moving-no-arrival-test', 'predicate', 'if (move_step(o, body, world, view_x, view_y) != 0 && can_move', 'if (move_step(o, body, world, view_x, view_y) == 0 && can_move')
m('p1-moving-rest-uses-old-piece', 'order', 'const int rests = type_is(world, o->piece, o->at_row, o->at_col);', 'const int rests = type_is(world, world->cell[o->at_row][o->at_col].piece, o->at_row, o->at_col);')
m('p1-moving-sound-swapped', 'predicate', 'rests == 0 ? play_if(body, B_SOUND_C, B_CHANNEL_C, host) : play_if(body, B_SOUND_B, B_CHANNEL_B, host)', 'rests != 0 ? play_if(body, B_SOUND_C, B_CHANNEL_C, host) : play_if(body, B_SOUND_B, B_CHANNEL_B, host)')
m('p1-moving-channel-B', 'field', 'play_if(body, B_SOUND_B, B_CHANNEL_B, host)', 'play_if(body, B_SOUND_B, B_CHANNEL_C, host)')
m('p1-moving-channel-C', 'field', 'play_if(body, B_SOUND_C, B_CHANNEL_C, host)', 'play_if(body, B_SOUND_C, B_CHANNEL_B, host)')
m('p1-moving-record-B', 'field', 'play_if(body, B_SOUND_B, B_CHANNEL_B, host)', 'play_if(body, B_SOUND_C, B_CHANNEL_B, host)')
m('p1-moving-state-kept', 'missing-effect', 'o->state = CPZ_STATE_IDLE;\n            fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;', 'fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;')
m('p1-play-record-test', 'predicate', 'if (!no_sound(body + record)) {', 'if (no_sound(body + record)) {')
m('p1-play-channel-width', 'sign', 'const int16_t ch = rd_s16(body, channel);\n        HOST(host->sound_play', 'const int16_t ch = (int16_t)(uint8_t)rd_s16(body, channel);\n        HOST(host->sound_play')
m('p1-wait-sound-inverted', 'predicate', 'if (busy == 0) {', 'if (busy != 0) {')
m('p1-wait-sound-low-bits', 'predicate', 'if (busy == 0) {', 'if ((busy & 0xff) == 0) {')
m('p1-wait-sound-channel', 'field', 'const int16_t ch = rd_s16(body, B_CHANNEL_D);\n        int32_t busy = 0;', 'const int16_t ch = rd_s16(body, B_CHANNEL_C);\n        int32_t busy = 0;')
m('p1-wait-sound-stop-record', 'field', 'HOST(host->sound_stop(host->context, body + B_SOUND_D));', 'HOST(host->sound_stop(host->context, body + B_SOUND_C));')
m('p1-wait-sound-stop-missing', 'missing-effect', 'HOST(host->sound_stop(host->context, body + B_SOUND_D));\n            fx(host, CPZ_FX_SOUND_STOP, B_SOUND_D, 0);', '')
m('p1-wait-sound-phase-value', 'constant', '*row_phase = 2u;\n            fx(host, CPZ_FX_PHASE, 2, 0);\n        }\n        break;\n    }\n    case CPZ_STATE_WAIT_DELAY', '*row_phase = 3u;\n            fx(host, CPZ_FX_PHASE, 2, 0);\n        }\n        break;\n    }\n    case CPZ_STATE_WAIT_DELAY')
m('p1-wait-delay-gt', 'compare', 'if (now >= o->deadline) {', 'if (now > o->deadline) {')
m('p1-wait-delay-signed', 'sign', 'if (now >= o->deadline) {', 'if ((int32_t)now >= (int32_t)o->deadline) {')
m('p1-wait-delay-lt', 'compare', 'if (now >= o->deadline) {', 'if (now < o->deadline) {')
m('p1-wait-delay-no-sound-inverted', 'predicate', 'if (no_sound(body + B_SOUND_D)) {', 'if (!no_sound(body + B_SOUND_D)) {')
m('p1-wait-delay-no-sound-phase', 'missing-effect', 'if (no_sound(body + B_SOUND_D)) {\n                *row_phase = 2u;', 'if (no_sound(body + B_SOUND_D)) {\n                ;')
m('p1-wait-delay-prepare-missing', 'missing-effect', 'HOST(host->sound_prepare(host->context, body + B_SOUND_D));\n                fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_D, 0);', '')
m('p1-wait-delay-play-channel', 'field', 'const int16_t ch = rd_s16(body, B_CHANNEL_D);\n                HOST(host->sound_prepare', 'const int16_t ch = rd_s16(body, B_CHANNEL_A);\n                HOST(host->sound_prepare')
m('p1-wait-delay-play-missing', 'missing-effect', 'HOST(host->sound_play(host->context, ch));\n                fx(host, CPZ_FX_SOUND_PLAY, ch, 0);\n                o->state = CPZ_STATE_WAIT_SOUND;', 'o->state = CPZ_STATE_WAIT_SOUND;')
m('p1-wait-delay-state', 'constant', 'o->state = CPZ_STATE_WAIT_SOUND;', 'o->state = CPZ_STATE_WAIT_DELAY;')
m('p1-wait-delay-order', 'order', 'HOST(host->sound_prepare(host->context, body + B_SOUND_D));\n                fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_D, 0);\n                HOST(host->sound_play(host->context, ch));\n                fx(host, CPZ_FX_SOUND_PLAY, ch, 0);',
  'HOST(host->sound_play(host->context, ch));\n                fx(host, CPZ_FX_SOUND_PLAY, ch, 0);\n                HOST(host->sound_prepare(host->context, body + B_SOUND_D));\n                fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_D, 0);')
m('p1-state-default-acts', 'case', '    default:\n        break;\n    }\n    return CPZ_OK;\n}\n\n/* 0x463c26', '    default:\n        o->state = CPZ_STATE_IDLE;\n        break;\n    }\n    return CPZ_OK;\n}\n\n/* 0x463c26')
# ---- phase 2
m('p2-start-flag-missing', 'missing-effect', 'world->start_flag_5bb1ca = 1;\n    fx(host, CPZ_FX_START_FLAG, 1, 0);\n    if (!no_sound(body + B_SOUND_A))', 'fx(host, CPZ_FX_START_FLAG, 1, 0);\n    if (!no_sound(body + B_SOUND_A))')
for letter, other in (('A', 'B'), ('B', 'C'), ('C', 'A')):
    m('p2-sound-%s-inverted' % letter, 'predicate', 'if (!no_sound(body + B_SOUND_%s)) {\n        HOST(host->sound_stop' % letter, 'if (no_sound(body + B_SOUND_%s)) {\n        HOST(host->sound_stop' % letter)
    m('p2-sound-%s-record' % letter, 'field', 'HOST(host->sound_stop(host->context, body + B_SOUND_%s));\n        fx(host, CPZ_FX_SOUND_STOP, B_SOUND_%s, 0);\n    }\n    if (!no_sound(body' % (letter, letter) if letter != 'C' else 'HOST(host->sound_stop(host->context, body + B_SOUND_C));',
      'HOST(host->sound_stop(host->context, body + B_SOUND_%s));\n        fx(host, CPZ_FX_SOUND_STOP, B_SOUND_%s, 0);\n    }\n    if (!no_sound(body' % (other, letter) if letter != 'C' else 'HOST(host->sound_stop(host->context, body + B_SOUND_A));')
m('p2-cancel-test', 'predicate', 'if (o->canceled == 0) {\n        if (o->solved != 0)', 'if (o->canceled != 0) {\n        if (o->solved != 0)')
m('p2-solved-test', 'predicate', 'if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);', 'if (o->solved == 0) return apply_block(body + B_SOLVED, world, host);')
m('p2-solved-always', 'predicate', 'if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);', 'return apply_block(body + B_SOLVED, world, host);')
m('p2-solved-block-offset', 'field', 'apply_block(body + B_SOLVED, world, host)', 'apply_block(body + B_CANCEL, world, host)')
m('p2-cancel-block-offset', 'field', 'return apply_block(body + B_CANCEL, world, host);\n}', 'return apply_block(body + B_SOLVED, world, host);\n}')
# ---- cpz_step glue (the native refusals are checked natively, the rest by the visits)
m('step-phase0-row-check', 'validate', 'if (row < 0) {', 'if (row < -1) {')
m('step-phase1-active-check', 'validate', 'if (phase == 1u) {\n        if (object->active == 0 || object->row != row) {', 'if (phase == 1u) {\n        if (object->row != row) {')
m('step-phase1-row-check', 'validate', 'if (phase == 1u) {\n        if (object->active == 0 || object->row != row) {', 'if (phase == 1u) {\n        if (object->active == 0) {')
m('step-phase2-active-check', 'validate', 'if (phase == 2u) {\n        if (object->active == 0 || object->row != row) {', 'if (phase == 2u) {\n        if (object->row != row) {')
m('step-phase2-row-check', 'validate', 'if (phase == 2u) {\n        if (object->active == 0 || object->row != row) {', 'if (phase == 2u) {\n        if (object->active == 0) {')
m('step-flag-window-cancel', 'validate', 'object->canceled != 0 ? body + B_CANCEL : (object->solved != 0 ? body + B_SOLVED : NULL)', 'object->canceled != 0 ? body + B_SOLVED : (object->solved != 0 ? body + B_SOLVED : NULL)')
m('step-flag-window-solved', 'validate', '(object->solved != 0 ? body + B_SOLVED : NULL)', '(object->solved != 0 ? body + B_CANCEL : NULL)')
m('step-flag-window-test', 'validate', 'flag != CPZ_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0', 'host->event_flag_invalid(host->context, flag) != 0')
m('step-flag-window-ignored', 'validate', 'flag != CPZ_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0', '0')
m('step-complete-effect-missing', 'missing-effect', 'fx(host, CPZ_FX_COMPLETE, row, 0);', ';')
m('step-completed-flag-missing', 'missing-effect', 'result->completed = 1u;', ';')
m('step-initialized-flag-missing', 'missing-effect', 'result->initialized = 1u;', ';')
m('step-phase-after-completion', 'constant', 'row_phase = 0u; /* 0x42ba3a stores phase 0 */', 'row_phase = 2u;')
m('step-cleanup-missing', 'missing-effect', 'rc = cpz_cleanup(object, host);', ';')
m('step-phase0-phase-effect-missing', 'missing-effect', 'row_phase = 1u;\n            fx(host, CPZ_FX_PHASE, 1, 0);', 'row_phase = 1u;')
m('step-phase0-phase-value', 'constant', 'row_phase = 1u;\n            fx(host, CPZ_FX_PHASE, 1, 0);', 'row_phase = 2u;\n            fx(host, CPZ_FX_PHASE, 1, 0);')
# ---- 0x462c39 pointer
m('ptr-inactive-test', 'predicate', 'if (object->active == 0 || object->state == CPZ_STATE_MOVING) return CPZ_OK;', 'if (object->state == CPZ_STATE_MOVING) return CPZ_OK;')
m('ptr-moving-test', 'predicate', 'if (object->active == 0 || object->state == CPZ_STATE_MOVING) return CPZ_OK;', 'if (object->active == 0) return CPZ_OK;')
m('ptr-moving-state', 'constant', 'object->state == CPZ_STATE_MOVING) return CPZ_OK;', 'object->state != CPZ_STATE_IDLE) return CPZ_OK;')
m('ptr-x-not-truncated', 'sign', 'x = (int16_t)x; /* movsx word */', ';')
m('ptr-y-not-truncated', 'sign', 'y = (int16_t)y;', ';')
m('ptr-x-unsigned', 'sign', 'x = (int16_t)x; /* movsx word */', 'x = (uint16_t)x;')
m('ptr-view-x', 'field', 'px = add32(x, view_x);', 'px = add32(x, view_y);')
m('ptr-view-y', 'field', 'py = add32(y, view_y);', 'py = add32(y, view_x);')
m('ptr-quarter-shift', 'arith', 'quarter = (quarter < 0) ? (int32_t)(~(~(uint32_t)quarter >> 2)) : (quarter >> 2);', 'quarter = object->cell_w >> 2;')
m('ptr-quarter-trunc', 'arith', 'quarter = (int32_t)((uint32_t)object->cell_w + (uint32_t)((object->cell_w < 0) ? 3 : 0));', 'quarter = object->cell_w;')
m('ptr-quarter-height', 'field', 'quarter = (int32_t)((uint32_t)object->cell_w + (uint32_t)((object->cell_w < 0) ? 3 : 0));', 'quarter = (int32_t)((uint32_t)object->cell_h + (uint32_t)((object->cell_h < 0) ? 3 : 0));')
m('ptr-half-shift', 'arith', 'half_h = object->cell_h / 2;', 'half_h = object->cell_h >> 1;')
m('ptr-half-width', 'field', 'half_h = object->cell_h / 2;', 'half_h = object->cell_w / 2;')
m('ptr-cell-piece-test', 'predicate', 'if (c->piece == 0) continue;', 'if (c->piece != 0) continue;')
m('ptr-piece-not-bound', 'missing-effect', 'object->piece = c->piece;\n            object->at_row = a;', 'object->at_row = a;')
m('ptr-row-not-bound', 'missing-effect', 'object->at_row = a;\n            object->at_col = b;', 'object->at_col = b;')
m('ptr-col-not-bound', 'missing-effect', 'object->at_col = b;\n            if', 'if')
m('ptr-rows-short', 'compare', 'for (int16_t a = 0; a < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0)', 'for (int16_t a = 0; a < rows - 1; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0)')
m('ptr-cols-short', 'compare', 'for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0)', 'for (int16_t b = 0; b < cols - 1; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0)')
# up zone
m('ptr-up-top-lt', 'compare', 'c->rect[1] <= py && py < add32(c->rect[1], half_h)', 'c->rect[1] < py && py < add32(c->rect[1], half_h)')
m('ptr-up-bottom-le', 'compare', 'py < add32(c->rect[1], half_h) &&', 'py <= add32(c->rect[1], half_h) &&')
m('ptr-up-left-ge', 'compare', 'add32(c->rect[0], quarter) < px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP)', 'add32(c->rect[0], quarter) <= px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP)')
m('ptr-up-right-le', 'compare', 'px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP)', 'px <= sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP)')
m('ptr-up-dir', 'constant', 'can_move(object, world, body, CPZ_DIR_UP) == 1', 'can_move(object, world, body, CPZ_DIR_DOWN) == 1')
m('ptr-up-candidate', 'constant', 'cursor_write(object, CPZ_CANDIDATE_UP, out);', 'cursor_write(object, CPZ_CANDIDATE_DOWN, out);')
m('ptr-up-quarter-sign', 'sign', 'add32(c->rect[0], quarter) < px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP)', 'sub32(c->rect[0], quarter) < px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP)')
# right zone
m('ptr-right-top-lt', 'compare', 'if (c->rect[1] <= py && py <= c->rect[3] && sub32(c->rect[2], quarter) < px', 'if (c->rect[1] < py && py <= c->rect[3] && sub32(c->rect[2], quarter) < px')
m('ptr-right-bottom-lt', 'compare', 'py <= c->rect[3] && sub32(c->rect[2], quarter) < px', 'py < c->rect[3] && sub32(c->rect[2], quarter) < px')
m('ptr-right-left-ge', 'compare', 'sub32(c->rect[2], quarter) < px && px <= c->rect[2]', 'sub32(c->rect[2], quarter) <= px && px <= c->rect[2]')
m('ptr-right-right-lt', 'compare', 'px <= c->rect[2] &&\n                can_move', 'px < c->rect[2] &&\n                can_move')
m('ptr-right-dir', 'constant', 'can_move(object, world, body, CPZ_DIR_RIGHT) == 1', 'can_move(object, world, body, CPZ_DIR_LEFT) == 1')
m('ptr-right-candidate', 'constant', 'cursor_write(object, CPZ_CANDIDATE_RIGHT, out);', 'cursor_write(object, CPZ_CANDIDATE_LEFT, out);')
# down zone
m('ptr-down-top-lt', 'compare', 'if (sub32(c->rect[3], half_h) <= py && py <= c->rect[3]', 'if (sub32(c->rect[3], half_h) < py && py <= c->rect[3]')
m('ptr-down-bottom-lt', 'compare', 'py <= c->rect[3] && add32(c->rect[0], quarter) < px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)', 'py < c->rect[3] && add32(c->rect[0], quarter) < px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)')
m('ptr-down-left-ge', 'compare', 'add32(c->rect[0], quarter) < px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)', 'add32(c->rect[0], quarter) <= px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)')
m('ptr-down-right-le', 'compare', 'px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)', 'px <= sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)')
m('ptr-down-dir', 'constant', 'can_move(object, world, body, CPZ_DIR_DOWN) == 1', 'can_move(object, world, body, CPZ_DIR_UP) == 1')
m('ptr-down-half-sign', 'sign', 'sub32(c->rect[3], half_h) <= py', 'add32(c->rect[3], half_h) <= py')
m('ptr-down-candidate', 'constant', 'cursor_write(object, CPZ_CANDIDATE_DOWN, out);', 'cursor_write(object, CPZ_CANDIDATE_UP, out);')
# left zone
m('ptr-left-top-lt', 'compare', 'if (c->rect[1] <= py && py <= c->rect[3] && c->rect[0] <= px', 'if (c->rect[1] < py && py <= c->rect[3] && c->rect[0] <= px')
m('ptr-left-bottom-lt', 'compare', 'py <= c->rect[3] && c->rect[0] <= px', 'py < c->rect[3] && c->rect[0] <= px')
m('ptr-left-left-gt', 'compare', 'c->rect[0] <= px && px < add32(c->rect[0], quarter)', 'c->rect[0] < px && px < add32(c->rect[0], quarter)')
m('ptr-left-right-le', 'compare', 'px < add32(c->rect[0], quarter) &&', 'px <= add32(c->rect[0], quarter) &&')
m('ptr-left-dir', 'constant', 'can_move(object, world, body, CPZ_DIR_LEFT) == 1', 'can_move(object, world, body, CPZ_DIR_RIGHT) == 1')
m('ptr-left-candidate', 'constant', 'cursor_write(object, CPZ_CANDIDATE_LEFT, out);', 'cursor_write(object, CPZ_CANDIDATE_RIGHT, out);')
m('ptr-hit-flag-missing', 'missing-effect', 'cursor_write(object, CPZ_CANDIDATE_LEFT, out);\n                out->hit = 1u;', 'cursor_write(object, CPZ_CANDIDATE_LEFT, out);')
m('ptr-zone-order-up-right', 'order', 'if (c->rect[1] <= py && py < add32(c->rect[1], half_h) && add32(c->rect[0], quarter) < px &&', 'if (0 && c->rect[1] <= py && py < add32(c->rect[1], half_h) && add32(c->rect[0], quarter) < px &&')
m('ptr-dir-reset-missing', 'missing-effect', 'object->dir = 0;\n    if (in_rect', 'if (in_rect')
m('ptr-cancel-point-x', 'field', 'if (in_rect(body, B_CANCEL_RECT, x, y)) {', 'if (in_rect(body, B_CANCEL_RECT, px, py)) {')
m('ptr-cancel-top', 'compare', 'return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&', 'return rd_s32(body, rect + 4) < y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&')
m('ptr-cancel-bottom', 'compare', 'y <= rd_s32(body, rect + 12) &&', 'y < rd_s32(body, rect + 12) &&')
m('ptr-cancel-left', 'compare', 'rd_s32(body, rect) <= x &&', 'rd_s32(body, rect) < x &&')
m('ptr-cancel-right', 'compare', 'x <= rd_s32(body, rect + 8);', 'x < rd_s32(body, rect + 8);')
m('ptr-cancel-swapped-axes', 'field', 'rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&\n           x <= rd_s32(body, rect + 8);',
  'rd_s32(body, rect + 4) <= x && x <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= y &&\n           y <= rd_s32(body, rect + 8);')
m('ptr-cursor-cancel-kind', 'constant', 'out->cursor_kind = CPZ_CURSOR_CANCEL;', 'out->cursor_kind = 8;')
m('ptr-cursor-sub', 'constant', 'out->cursor_sub = 1;', 'out->cursor_sub = 2;')
m('ptr-cursor-left-kind', 'constant', 'case CPZ_CANDIDATE_LEFT: out->cursor_kind = 0x19; break;', 'case CPZ_CANDIDATE_LEFT: out->cursor_kind = 0x1a; break;')
m('ptr-cursor-up-kind', 'constant', 'case CPZ_CANDIDATE_UP: out->cursor_kind = 0x17; break;', 'case CPZ_CANDIDATE_UP: out->cursor_kind = 0x18; break;')
m('ptr-cursor-down-kind', 'constant', 'case CPZ_CANDIDATE_DOWN: out->cursor_kind = 0x18; break;', 'case CPZ_CANDIDATE_DOWN: out->cursor_kind = 0x17; break;')
m('ptr-cursor-right-kind', 'constant', 'default: out->cursor_kind = 0x1a; break;', 'default: out->cursor_kind = 0x19; break;')
m('ptr-cursor-written-flag', 'missing-effect', 'out->cursor_written = 1u;', ';')
m('ptr-candidate-not-reported', 'missing-effect', 'out->candidate = candidate;\n    if (candidate == CPZ_CANDIDATE_CANCEL) {', 'if (candidate == CPZ_CANDIDATE_CANCEL) {')
# ---- 0x4631d1 click
m('click-active-test', 'predicate', 'if (!(object->active != 0 && object->solved == 0', 'if (!(object->solved == 0')
m('click-solved-test', 'predicate', 'object->active != 0 && object->solved == 0 && object->state', 'object->active != 0 && object->state')
m('click-state-test', 'predicate', 'object->solved == 0 && object->state == CPZ_STATE_IDLE && row_phase == 1u', 'object->solved == 0 && row_phase == 1u')
m('click-phase-test', 'predicate', 'object->state == CPZ_STATE_IDLE && row_phase == 1u)) return', 'object->state == CPZ_STATE_IDLE)) return')
m('click-phase-ge', 'compare', 'row_phase == 1u)) return', 'row_phase >= 1u)) return')
m('click-cancel-candidate', 'constant', 'if (candidate == CPZ_CANDIDATE_CANCEL) {\n        object->canceled', 'if (candidate == CPZ_CANDIDATE_LEFT) {\n        object->canceled')
m('click-cancel-flag-missing', 'missing-effect', 'object->canceled = 1;\n        out->cancel_asked', 'out->cancel_asked')
m('click-cancel-phase-value', 'constant', 'out->new_phase = 2u;\n        fx(host, CPZ_FX_PHASE, 2, 0);', 'out->new_phase = 2u;\n        fx(host, CPZ_FX_PHASE, 1, 0);')
m('click-cancel-phase-effect-missing', 'missing-effect', 'out->new_phase = 2u;\n        fx(host, CPZ_FX_PHASE, 2, 0);', 'out->new_phase = 2u;')
m('click-move-needs-dir', 'predicate', '} else if (object->dir != 0) {', '} else if (object->dir == 0) {')
m('click-move-always', 'predicate', '} else if (object->dir != 0) {', '} else {')
m('click-move-state', 'constant', 'object->state = CPZ_STATE_MOVING;', 'object->state = CPZ_STATE_WAIT_SOUND;')
m('click-move-state-effect-missing', 'missing-effect', 'fx(host, CPZ_FX_STATE, object->state, 0);\n        out->move_started', 'out->move_started')
m('click-sound-needs-start-flag', 'predicate', 'if (start_flag != 0 && !no_sound(body + B_SOUND_A)) {', 'if (!no_sound(body + B_SOUND_A)) {')
m('click-sound-start-flag-inverted', 'predicate', 'if (start_flag != 0 && !no_sound(body + B_SOUND_A)) {', 'if (start_flag == 0 && !no_sound(body + B_SOUND_A)) {')
m('click-sound-start-flag-one', 'predicate', 'if (start_flag != 0 && !no_sound(body + B_SOUND_A)) {', 'if (start_flag == 1 && !no_sound(body + B_SOUND_A)) {')
m('click-sound-record-test', 'predicate', 'if (start_flag != 0 && !no_sound(body + B_SOUND_A)) {', 'if (start_flag != 0 && no_sound(body + B_SOUND_A)) {')
m('click-sound-channel', 'field', 'const int16_t ch = rd_s16(body, B_CHANNEL_A);', 'const int16_t ch = rd_s16(body, B_CHANNEL_B);')
m('click-sound-flag-missing', 'missing-effect', 'out->sound_played = 1u;', ';')
# ---- invalidate / cleanup
m('inv-active-test', 'predicate', 'if (object->active != 0 && object->slot != CPZ_NO_SLOT) HOST', 'if (object->slot != CPZ_NO_SLOT) HOST')
m('inv-slot-test', 'predicate', 'if (object->active != 0 && object->slot != CPZ_NO_SLOT) HOST', 'if (object->active != 0) HOST')
m('clean-surface-test', 'predicate', 'if (object->surface != 0u) {', 'if (1) {')
m('clean-surface-kept', 'missing-effect', 'object->surface = 0u;\n        fx(host, CPZ_FX_RELEASE_SURFACE', 'fx(host, CPZ_FX_RELEASE_SURFACE')
m('clean-surface-effect-value', 'field', 'fx(host, CPZ_FX_RELEASE_SURFACE, (int32_t)surface, 0);', 'fx(host, CPZ_FX_RELEASE_SURFACE, 0, 0);')
m('clean-slot-test', 'predicate', 'if (object->slot != CPZ_NO_SLOT) {\n        const int16_t slot', 'if (1) {\n        const int16_t slot')
m('clean-slot-reset', 'missing-effect', 'object->slot = CPZ_NO_SLOT; /* 0x461827 */', ';')
m('clean-row-reset', 'missing-effect', 'object->row = -1;\n    object->active = 0;', 'object->active = 0;')
m('clean-active-reset', 'missing-effect', 'object->active = 0;\n    object->canceled = 0;', 'object->canceled = 0;')
m('clean-canceled-reset', 'missing-effect', 'object->canceled = 0;\n    object->solved = 0;\n    return', 'object->solved = 0;\n    return')
m('clean-solved-reset', 'missing-effect', 'object->solved = 0;\n    return CPZ_OK;\n}\n\nstatic void add_blit', 'return CPZ_OK;\n}\n\nstatic void add_blit')
m('clean-state-reset', 'predicate', 'object->solved = 0;\n    return CPZ_OK;\n}\n\nstatic void add_blit', 'object->solved = 0;\n    object->state = 0;\n    return CPZ_OK;\n}\n\nstatic void add_blit')
m('clean-surface-after-slot', 'order', 'if (object->surface != 0u) {\n        const uint32_t surface = object->surface;\n        HOST(host->release_surface(host->context, surface));\n        object->surface = 0u;\n        fx(host, CPZ_FX_RELEASE_SURFACE, (int32_t)surface, 0);\n    }',
  'if (object->surface != 0u && object->slot == CPZ_NO_SLOT) {\n        const uint32_t surface = object->surface;\n        HOST(host->release_surface(host->context, surface));\n        object->surface = 0u;\n        fx(host, CPZ_FX_RELEASE_SURFACE, (int32_t)surface, 0);\n    }')
m('grid-reset-flag-kept', 'missing-effect', 'world->grid_ready = 0;\n    memset(world->cell', 'memset(world->cell')
m('grid-reset-cells-kept', 'missing-effect', 'memset(world->cell, 0, sizeof(world->cell));\n}', ';\n}')
m('grid-reset-partial', 'compare', 'memset(world->cell, 0, sizeof(world->cell));\n}', 'memset(world->cell, 0, sizeof(world->cell) - 40);\n}')
# ---- 0x463b10 render
m('render-slot-test', 'predicate', 'if (object->slot == CPZ_NO_SLOT) return CPZ_OK;', 'if (object->slot != CPZ_NO_SLOT) return CPZ_OK;')
m('render-rows-short', 'compare', 'for (int16_t a = 0; a < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0)', 'for (int16_t a = 0; a < rows - 1; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0)')
m('render-cols-short', 'compare', 'for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0)', 'for (int16_t b = 0; b < cols - 1; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0)')
m('render-visible-test', 'predicate', 'if (c->visible == 0) continue;', 'if (c->visible != 0) continue;')
m('render-visible-one', 'predicate', 'if (c->visible == 0) continue;', 'if (c->visible != 1) continue;')
m('render-target-range-low', 'case', 'case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8: case 9: case 10: {', 'case 2: case 3: case 4: case 5: case 6: case 7: case 8: case 9: case 10: {')
m('render-target-range-high', 'case', 'case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8: case 9: case 10: {', 'case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8: case 9: {')
m('render-target-range-wide', 'case', 'case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8: case 9: case 10: {', 'case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8: case 9: case 10: case 11: {')
m('render-target-source', 'index', 'B_TARGET_SRC + (size_t)(c->type - 1) * 16u', 'B_TARGET_SRC + (size_t)(c->type) * 16u')
m('render-target-zero-width-skip', 'predicate', 'if (rd_s32(body, src + 8) != rd_s32(body, src))\n                    add_blit(out, CPZ_BLIT_TARGET', 'if (1)\n                    add_blit(out, CPZ_BLIT_TARGET')
m('render-target-skip-inverted', 'predicate', 'if (rd_s32(body, src + 8) != rd_s32(body, src))\n                    add_blit(out, CPZ_BLIT_TARGET', 'if (rd_s32(body, src + 8) == rd_s32(body, src))\n                    add_blit(out, CPZ_BLIT_TARGET')
m('render-target-skip-height', 'field', 'if (rd_s32(body, src + 8) != rd_s32(body, src))\n                    add_blit(out, CPZ_BLIT_TARGET', 'if (rd_s32(body, src + 12) != rd_s32(body, src + 4))\n                    add_blit(out, CPZ_BLIT_TARGET')
m('render-target-kind', 'constant', 'add_blit(out, CPZ_BLIT_TARGET, 0, object->surface, body, src, c->base, host);', 'add_blit(out, CPZ_BLIT_ARROW_H, 0, object->surface, body, src, c->base, host);')
m('render-target-dst', 'field', 'add_blit(out, CPZ_BLIT_TARGET, 0, object->surface, body, src, c->base, host);', 'add_blit(out, CPZ_BLIT_TARGET, 0, object->surface, body, src, c->rect, host);')
m('render-arrow-h-left-only', 'case', 'case CPZ_DIR_LEFT:\n            case CPZ_DIR_RIGHT:\n                add_blit', 'case CPZ_DIR_LEFT:\n                add_blit')
m('render-arrow-h-source', 'index', 'add_blit(out, CPZ_BLIT_ARROW_H, 0, object->surface, body, B_ARROW_H, c->base, host);', 'add_blit(out, CPZ_BLIT_ARROW_H, 0, object->surface, body, B_ARROW_V, c->base, host);')
m('render-arrow-v-up-only', 'case', 'case CPZ_DIR_UP:\n            case CPZ_DIR_DOWN:\n                add_blit', 'case CPZ_DIR_UP:\n                add_blit')
m('render-arrow-v-source', 'index', 'add_blit(out, CPZ_BLIT_ARROW_V, 0, object->surface, body, B_ARROW_V, c->base, host);', 'add_blit(out, CPZ_BLIT_ARROW_V, 0, object->surface, body, B_ARROW_H, c->base, host);')
m('render-arrow-v-dst', 'field', 'add_blit(out, CPZ_BLIT_ARROW_V, 0, object->surface, body, B_ARROW_V, c->base, host);', 'add_blit(out, CPZ_BLIT_ARROW_V, 0, object->surface, body, B_ARROW_V, c->rect, host);')
m('render-wall-skip', 'predicate', 'if (rd_s32(body, B_WALL + 8) != rd_s32(body, B_WALL))', 'if (1)')
m('render-wall-skip-inverted', 'predicate', 'if (rd_s32(body, B_WALL + 8) != rd_s32(body, B_WALL))', 'if (rd_s32(body, B_WALL + 8) == rd_s32(body, B_WALL))')
m('render-wall-source', 'index', 'add_blit(out, CPZ_BLIT_WALL, 0, object->surface, body, B_WALL, c->base, host);', 'add_blit(out, CPZ_BLIT_WALL, 0, object->surface, body, B_ARROW_H, c->base, host);')
m('render-wall-type', 'constant', 'case CPZ_CELL_WALL:\n                if', 'case 0x15:\n                if')
m('render-overlay-after-piece', 'order', '            if (c->piece != 0) {\n                if ((object->state', '            if (c->piece != 0 && 0) {\n                if ((object->state')
m('render-piece-test', 'predicate', '            if (c->piece != 0) {\n                if ((object->state', '            if (c->piece == 0) {\n                if ((object->state')
m('render-restore-moving-only', 'predicate', '(object->state == CPZ_STATE_MOVING || object->moved == 1) && object->piece == c->piece', 'object->state == CPZ_STATE_MOVING && object->piece == c->piece')
m('render-restore-moved-only', 'predicate', '(object->state == CPZ_STATE_MOVING || object->moved == 1) && object->piece == c->piece', 'object->moved == 1 && object->piece == c->piece')
m('render-restore-moved-nonzero', 'predicate', 'object->moved == 1) && object->piece', 'object->moved != 0) && object->piece')
m('render-restore-and', 'predicate', '(object->state == CPZ_STATE_MOVING || object->moved == 1) && object->piece == c->piece', '(object->state == CPZ_STATE_MOVING && object->moved == 1) && object->piece == c->piece')
m('render-restore-piece-test', 'predicate', 'object->piece == c->piece) {', 'object->piece != c->piece) {')
m('render-restore-piece-free', 'predicate', '(object->state == CPZ_STATE_MOVING || object->moved == 1) && object->piece == c->piece', '(object->state == CPZ_STATE_MOVING || object->moved == 1)')
m('render-restore-view-x', 'field', 'bl->src[0] = sub32(object->saved[0], view_x);', 'bl->src[0] = sub32(object->saved[0], view_y);')
m('render-restore-view-y', 'field', 'bl->src[1] = sub32(object->saved[1], view_y);', 'bl->src[1] = sub32(object->saved[1], view_x);')
m('render-restore-right', 'field', 'bl->src[2] = sub32(object->saved[2], view_x);', 'bl->src[2] = object->saved[2];')
m('render-restore-bottom', 'field', 'bl->src[3] = sub32(object->saved[3], view_y);', 'bl->src[3] = object->saved[3];')
m('render-restore-dst', 'field', 'for (int k = 0; k < 4; ++k) bl->dst[k] = object->saved[k];', 'for (int k = 0; k < 4; ++k) bl->dst[k] = bl->src[k];')
m('render-restore-surface', 'field', 'bl->src_surface = 0u;', 'bl->src_surface = object->surface;')
m('render-restore-piece', 'field', 'bl->piece = c->piece;\n                    bl->src_surface', 'bl->piece = 0;\n                    bl->src_surface')
m('render-piece-source', 'index', 'B_PIECE_SRC + (size_t)(c->piece - 1) * 16u', 'B_PIECE_SRC + (size_t)(c->piece) * 16u')
m('render-piece-dst', 'field', 'add_blit(out, CPZ_BLIT_PIECE, c->piece, object->surface, body,\n                         B_PIECE_SRC + (size_t)(c->piece - 1) * 16u, c->rect, host);', 'add_blit(out, CPZ_BLIT_PIECE, c->piece, object->surface, body,\n                         B_PIECE_SRC + (size_t)(c->piece - 1) * 16u, c->base, host);')
m('render-piece-bounds-low', 'validate', 'if (c->piece < 1 || c->piece > CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;', 'if (c->piece > CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;')
m('render-piece-bounds-high', 'validate', 'if (c->piece < 1 || c->piece > CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;', 'if (c->piece < 1) return CPZ_ERR_BOUNDS;')
m('render-valid-flag', 'missing-effect', 'out->valid = 1u;', ';')
m('render-origin-read-missing', 'missing-effect', 'out->valid = 1u;\n    HOST(host->view_origin(host->context, &view_x, &view_y));', 'out->valid = 1u;')
m('blit-source-offset', 'index', 'bl->src[k] = rd_s32(body, src + (size_t)k * 4u);', 'bl->src[k] = rd_s32(body, src + (size_t)((k + 1) % 4) * 4u);')
m('blit-destination', 'field', 'bl->dst[k] = dst[k];', 'bl->dst[k] = dst[(k + 2) % 4];')
m('blit-piece-effect', 'field', 'fx(host, CPZ_FX_BLIT, kind, piece);', 'fx(host, CPZ_FX_BLIT, kind, 0);')
m('blit-kind-effect', 'field', 'fx(host, CPZ_FX_BLIT, kind, piece);', 'fx(host, CPZ_FX_BLIT, 6, piece);')

# Mutants proved equivalent by reading the code: they cannot change any observable behaviour in a reachable state, so a surviving run is
# the expected result. They are reported separately and never count as killed.
EQUIVALENT = {
    'step-arrival-ge': 'o->step starts at 0 (phase 0, every arrival, every refused move check) and grows by exactly 1, so it can only be equal to the step count '
                       'before it exceeds it; a step above the count needs a corrupted object that no scenario or game path produces (the original would walk '
                       'until the 16-bit counter wraps)',
    'step-unknown-dir-continues': 'the direction is one of 0x10..0x13 whenever a move runs (the pointer stores only those through the move check); with another '
                                  'value the original and the kernel both leave the step function in the switch default before counting',
    'p0-cell-size-after-setup': 'moves only the read of the view origin (a pure host query that is neither an effect nor a write) above the two field stores; '
                                'the order of a read-only host call against two object stores is not observable (the setup that uses the cell size still runs after both); '
                                'the stronger order mutant p0-setup-before-cell-size is killed',
    'ptr-quarter-shift': 'differs from the kernel only for a negative cell width; for every width from -80 to 0 and every pointer x in -200..99 the three x-tests '
                         '(up/down centre band, right strip, left strip) give the same truth values for both quarters (exhaustive check, 0 differences): a negative width '
                         'makes every x-interval empty',
    'ptr-quarter-trunc': 'same exhaustive check as ptr-quarter-shift (width -80..0, x -200..99, 0 differences)',
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
    name, cls, old, new, count, which, kernel_text, work, stage = args
    d = work / name
    d.mkdir()
    for h in (PROJECT / 'src').glob('action_family_d3_runtime*.h'):
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
    if verdict == 'SURVIVED':
        verdict, detail = run_oracle(d, False, d / 'result_full.json', workers=2)
        row['stage'] = 'full'
    row.update(verdict=verdict, detail=detail)
    return row


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--stage', choices=('quick', 'full'), default='quick')
    ap.add_argument('--only')
    ap.add_argument('--jobs', type=int, default=min(4, os.cpu_count() or 1))
    ap.add_argument('--result', type=Path)
    ap.add_argument('--check-sites', action='store_true', help='only verify that every edit site is found the stated number of times')
    a = ap.parse_args()
    kernel_text = (PROJECT / 'src' / KERNEL).read_text()
    if a.check_sites:
        bad = 0
        for name, cls, old, new, count, which in M:
            try:
                apply(kernel_text, old, new, count, which)
                if old == new:
                    raise ValueError('the edit changes nothing')
            except ValueError as e:
                print('SITE', name, e)
                bad += 1
        names = [t[0] for t in M]
        print('mutants', len(M), 'bad sites', bad, 'duplicate names', len(names) - len(set(names)))
        return 1 if bad else 0
    work = Path(tempfile.mkdtemp(prefix='d3_mut_'))
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
               equivalent=[dict(name=r['name'], reason=r['reason']) for r in rows if r['verdict'] == 'EQUIVALENT'], rows=rows,
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
