#!/usr/bin/env python3
"""RT-56 mutation check for the raw-0xeb oracle.

Every mutant is a one-site textual edit of a COPY of src/action_family_eb_runtime.c (the project file is never touched). Each mutant
is built into a driver library and run through the original-x86 oracle (action_family_eb_runtime_original_oracle.py, `--src DIR`). A mutant
is KILLED when the oracle reports at least one mismatch against the unmodified GAME.EXE image (or one of its native-only refusal
checks fails); it SURVIVES when the oracle still reports 0 mismatches; it is INVALID if it does not compile or the edit site is not
found the stated number of times (invalid mutants never count as killed).

Usage:  python3 action_family_eb_runtime_mutation_check.py [--stage quick|full] [--only NAME] [--jobs N] [--result FILE] [--check-sites]
Stage `quick` runs the oracle's --quick-only subset (plus the native refusal checks); survivors are re-run on the full scenario set
(--stage full runs every mutant on the full set). Mutants run in parallel, one single-process oracle per mutant (--jobs, default 4).
`--check-sites` only verifies that every edit site is found the stated number of times. Equivalent mutants (EQUIVALENT below, each
with a reason) are reported separately and are not counted in the kill rate.
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
ORACLE = HERE / 'action_family_eb_runtime_original_oracle.py'
KERNEL = 'action_family_eb_runtime.c'

# (name, class, old text, new text, expected occurrences of old text, index of the occurrence to edit)
M = []


def m(name, cls, old, new, count=1, which=0):
    M.append((name, cls, old, new, count, which))


# ---- string compares ("NO_FILE\0" 8 bytes, "NO SOUND\0" 9 bytes)
m('nofile-7-bytes', 'compare', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 7) == 0;', 2, 0)
m('nosound-8-bytes', 'compare', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8) == 0;', 2, 1)
m('nofile-case', 'compare', "{'N', 'O', '_', 'F', 'I', 'L', 'E', 0}", "{'n', 'O', '_', 'F', 'I', 'L', 'E', 0}")
m('nosound-case', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'n', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}")
m('nosound-last-char', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'E', 0}")
m('nosound-inverted', 'predicate', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k) != 0;', 2, 1)
# ---- body validation (native-only refusals, checked by the K1 scenarios and by the maximal-length names of the others)
m('validate-length-lt', 'validate', 'length != EB_BODY_BYTES', 'length < EB_BODY_BYTES')
m('validate-ntypes-low', 'validate', '(n = rd_s16(body, B_NTYPES)) < 0 || n > EB_MAX_TYPES', '(n = rd_s16(body, B_NTYPES)) < -1 || n > EB_MAX_TYPES')
m('validate-ntypes-high', 'validate', '(n = rd_s16(body, B_NTYPES)) < 0 || n > EB_MAX_TYPES', '(n = rd_s16(body, B_NTYPES)) < 0 || n > EB_MAX_TYPES + 1')
m('validate-grid-cols-skipped', 'validate', 'rd_s32(body, B_ANIM_AREA + 12) != rd_s32(body, B_ANIM_AREA + 4) && rd_s16(body, B_GRID_COLS) == 0',
  'rd_s32(body, B_ANIM_AREA + 12) != rd_s32(body, B_ANIM_AREA + 4) && 0')
m('validate-name-span', 'validate', '{B_NAME, 0x21}', '{B_NAME, 0x20}')
m('validate-multi-span', 'validate', '{B_MULTI_NAME, 0x21}', '{B_MULTI_NAME, 0x20}')
m('validate-anim-name-span', 'validate', '{B_ANIM_NAME, 0x21}', '{B_ANIM_NAME, 0x20}')
m('validate-key-span', 'validate', '{B_KEY_BAD, 0x21}', '{B_KEY_BAD, 0x20}')
m('validate-text-span', 'validate', '{B_TEXT_WIN, 200}', '{B_TEXT_WIN, 199}')
m('validate-sound-span', 'validate', '{B_SND_PICK, 0x21}', '{B_SND_PICK, 0x20}')
m('validate-sound-skipped', 'validate', '{B_SND_GOOD, 0x21}, {B_SND_BAD, 0x21}', '{B_SND_GOOD, 0x21}')
m('validate-size-low', 'validate', 'if (w < 1 || w > 4096 || h < 1 || h > 4096) why = "0xeb-piece-size";',
  'if (w < 0 || w > 4096 || h < 1 || h > 4096) why = "0xeb-piece-size";')
m('validate-size-high', 'validate', 'if (w < 1 || w > 4096 || h < 1 || h > 4096) why = "0xeb-piece-size";',
  'if (w < 1 || w > 4097 || h < 1 || h > 4096) why = "0xeb-piece-size";')
m('validate-size-uses-c', 'validate', 'const size_t r = rect_valid(body, p + BT_C) ? p + BT_C : p + BT_B;',
  'const size_t r = p + BT_B;')
# ---- generic rectangle helpers
m('rect-valid-and', 'predicate', 'return !(rd_s32(b, off + 12) == rd_s32(b, off + 4) || rd_s32(b, off + 8) == rd_s32(b, off));',
  'return !(rd_s32(b, off + 12) == rd_s32(b, off + 4) && rd_s32(b, off + 8) == rd_s32(b, off));')
m('rect-valid-width-only', 'predicate', 'return !(rd_s32(b, off + 12) == rd_s32(b, off + 4) || rd_s32(b, off + 8) == rd_s32(b, off));',
  'return !(rd_s32(b, off + 8) == rd_s32(b, off));')
m('translate-y-origin', 'arith', 'wr_32(obj, to + 4, add32(src[1], v.origin_y));', 'wr_32(obj, to + 4, add32(src[1], v.origin_x));')
m('translate-right-origin', 'arith', 'wr_32(obj, to + 8, add32(src[2], v.origin_x));', 'wr_32(obj, to + 8, add32(src[2], v.origin_y));')
m('clamp-top-edge', 'compare', 'if (rd_s32(obj, off + 4) < v.clip[1]) {', 'if (rd_s32(obj, off + 4) <= v.clip[1]) {')
m('clamp-bottom-edge', 'compare', 'if (v.clip[3] < rd_s32(obj, off + 12)) {', 'if (v.clip[3] <= rd_s32(obj, off + 12)) {')
m('clamp-left-edge', 'compare', 'if (rd_s32(obj, off) < v.clip[0]) {', 'if (rd_s32(obj, off) <= v.clip[0]) {')
m('clamp-right-edge', 'compare', 'if (v.clip[2] < rd_s32(obj, off + 8)) {', 'if (v.clip[2] <= rd_s32(obj, off + 8)) {')
m('clamp-left-uses-top', 'arith', 'wr_32(obj, off, v.clip[0]);', 'wr_32(obj, off, v.clip[1]);')
m('clamp-height-plus-one', 'arith', 'wr_32(obj, off + 12, add32(rd_s32(obj, off + 4), h));', 'wr_32(obj, off + 12, add32(rd_s32(obj, off + 4), h + 1));')
m('clamp-width-minus', 'arith', 'wr_32(obj, off, sub32(rd_s32(obj, off + 8), w));', 'wr_32(obj, off, sub32(rd_s32(obj, off + 8), w - 1));')
# ---- piece builder 0x47e582
m('init-forced-ignored', 'logic', 'if (forced != 0 || body[B_PERSIST] == 0 || world->saved_flag == 0 ||', 'if (body[B_PERSIST] == 0 || world->saved_flag == 0 ||')
m('init-persist-inverted', 'logic', 'if (forced != 0 || body[B_PERSIST] == 0 ||', 'if (forced != 0 || body[B_PERSIST] != 0 ||')
m('init-saved-flag-ignored', 'logic', 'if (forced != 0 || body[B_PERSIST] == 0 || world->saved_flag == 0 ||', 'if (forced != 0 || body[B_PERSIST] == 0 ||')
m('init-scene-compare-inverted', 'compare', 'if (forced != 0 || body[B_PERSIST] == 0 || world->saved_flag == 0 || (int32_t)world->saved_scene != world->scene_5bb57b) {',
  'if (forced != 0 || body[B_PERSIST] == 0 || world->saved_flag == 0 || (int32_t)world->saved_scene == world->scene_5bb57b) {')
m('init-stamp-kept', 'logic', 'obj[P + P_STAMP] = 0;', ';', 2, 0)
m('init-home-rect-a', 'arith', 'copy_rect(obj, P + P_RECT, body, T + BT_B);', 'copy_rect(obj, P + P_RECT, body, T + BT_A);', 2, 0)
m('init-c-validity-inverted', 'predicate', 'if (!rect_valid(body, T + BT_C)) {', 'if (rect_valid(body, T + BT_C)) {')
m('init-width-plus-zero', 'arith', 'w = (int16_t)((int16_t)sub32(rd_s32(body, T + BT_B + 8), rd_s32(body, T + BT_B)) + 1);',
  'w = (int16_t)((int16_t)sub32(rd_s32(body, T + BT_B + 8), rd_s32(body, T + BT_B)));')
m('init-height-from-c', 'arith', 'h = (int16_t)((int16_t)sub32(rd_s32(body, T + BT_C + 12), rd_s32(body, T + BT_C + 4)) + 1);',
  'h = (int16_t)((int16_t)sub32(rd_s32(body, T + BT_C + 12), rd_s32(body, T + BT_C + 4)));')
m('init-source-rect-b', 'arith', 'for (int k = 0; k < 4; ++k) src_rect[k] = rd_s32(body, T + BT_A + (size_t)k * 4u);',
  'for (int k = 0; k < 4; ++k) src_rect[k] = rd_s32(body, T + BT_B + (size_t)k * 4u);')
m('init-entry-bottom', 'arith', 'wr_32(obj, E0 + ENT_RECT + 12, add32(sub32(rd_s32(obj, E0 + ENT_RECT + 4), 1), h));',
  'wr_32(obj, E0 + ENT_RECT + 12, add32(sub32(rd_s32(obj, E0 + ENT_RECT + 4), 1), h + 1));')
m('init-rotation-gate-and', 'logic', 'if (body[B_ROT_ALLOWED] != 0 || obj[P + P_ORIENT] != 0) {', 'if (body[B_ROT_ALLOWED] != 0 && obj[P + P_ORIENT] != 0) {')
m('init-rotation-gate-orient', 'logic', 'if (body[B_ROT_ALLOWED] != 0 || obj[P + P_ORIENT] != 0) {', 'if (body[B_ROT_ALLOWED] != 0) {')
m('init-three-orientations', 'logic', 'for (unsigned k = 1; k < 4; ++k) {', 'for (unsigned k = 1; k < 3; ++k) {')
m('init-rotated-size-kept', 'logic', 'w = rw;', ';')
m('init-copy-source', 'logic', 'HOST(host->copy_surface(host->context, s2, (uint32_t)rd_s32(obj, prev + ENT_SURF)));',
  'HOST(host->copy_surface(host->context, s2, (uint32_t)rd_s32(obj, entry_off(type, 0) + ENT_SURF)));')
m('init-rotated-rect-right', 'arith', 'wr_32(obj, ent + ENT_RECT + 8, add32(sub32(rd_s32(obj, ent + ENT_RECT), 1), rw));',
  'wr_32(obj, ent + ENT_RECT + 8, add32(sub32(rd_s32(obj, ent + ENT_RECT), 1), rh));')
# ---- helpers 0x47e8fe..0x47ed96
m('top-piece-tie', 'compare', 'rd_s16(obj, piece_off(best) + P_Z) < rd_s16(obj, piece_off(cand) + P_Z)', 'rd_s16(obj, piece_off(best) + P_Z) <= rd_s16(obj, piece_off(cand) + P_Z)')
m('top-piece-first-only', 'logic', 'for (int32_t k = 1; k < n; ++k) {', 'for (int32_t k = 1; k < n && k < 2; ++k) {')
m('overlap-left-edge', 'compare', 'if (ar < bl) return 0;', 'if (ar <= bl) return 0;')
m('overlap-right-edge', 'compare', 'if (br < al) return 0;', 'if (br <= al) return 0;')
m('overlap-top-edge', 'compare', 'if (ab < bt) return 0;', 'if (ab <= bt) return 0;')
m('overlap-bottom-edge', 'compare', 'if (bb < at) return 0;', 'if (bb <= at) return 0;')
m('overlap-minus-one-edge', 'logic', 'return !(t == -1 || bo == -1 || l == -1 || r == -1);', 'return !(t == -1 || bo == -1 || l == -1);')
m('overlap-right-min', 'logic', 'r = br < ar ? br : ar;', 'r = br < ar ? ar : br;', 2, 0)
m('layer-max-pick', 'logic', 'z = zj < z ? z : zj;', 'z = zj < z ? zj : z;')
m('layer-increment', 'arith', 'wr_16(obj, piece_off(i) + P_Z, (int16_t)(rd_s16(obj, piece_off(i) + P_Z) + 1));',
  'wr_16(obj, piece_off(i) + P_Z, (int16_t)(rd_s16(obj, piece_off(i) + P_Z) + 2));')
m('layer-self-overlap', 'logic', 'if (j != i && pieces_overlap(obj, i, j)) found[nfound++] = j;', 'if (pieces_overlap(obj, i, j)) found[nfound++] = j;')
# ---- rotation 0x47fa11 and multi pick 0x47fb76
m('rotate-wrap-at-3', 'compare', 'if (obj[P + P_ORIENT] == 4) obj[P + P_ORIENT] = 0;', 'if (obj[P + P_ORIENT] == 3) obj[P + P_ORIENT] = 0;')
m('rotate-orient-step', 'arith', 'obj[P + P_ORIENT] = (uint8_t)(obj[P + P_ORIENT] + 1);', 'obj[P + P_ORIENT] = (uint8_t)(obj[P + P_ORIENT] + 2);')
m('rotate-centre-width', 'arith', 'add32(rd_s32(obj, P + P_RECT), w / 2)', 'add32(rd_s32(obj, P + P_RECT), w / 2 + 1)')
m('rotate-centre-height', 'arith', 'add32(rd_s32(obj, P + P_RECT + 4), h / 2)', 'add32(rd_s32(obj, P + P_RECT + 4), h)')
m('rotate-lift-not-set', 'logic', 'wr_32(obj, O_LIFT, 1);', ';', 3, 0)
m('rotate-saved-rect-skipped', 'logic', 'copy_rect(obj, O_SAVED, obj, P + P_RECT);', ';', 3, 0)
m('rotate-no-clamp', 'logic', 'CHECK(clamp_rect(obj, P + P_RECT, host));', ';', 2, 0)
m('multi-e-validity-inverted', 'predicate', 'if (!rect_valid(body, T + BT_E)) {', 'if (rect_valid(body, T + BT_E)) {')
m('multi-copies-d-not-e', 'logic', 'copy_rect(obj, P + P_RECT, body, T + BT_E);', 'copy_rect(obj, P + P_RECT, body, T + BT_D);')
m('multi-half-width', 'arith', 'sub32(dr, dl) / 2', 'sub32(dr, dl) / 3')
m('multi-no-clamp', 'logic', 'CHECK(clamp_rect(obj, P + P_RECT, host));', ';', 2, 1)
m('multi-bottom', 'arith', 'wr_32(obj, P + P_RECT + 12, sub32(add32(rd_s32(obj, P + P_RECT + 4), db), dt));',
  'wr_32(obj, P + P_RECT + 12, sub32(add32(rd_s32(obj, P + P_RECT + 4), db), dt + 1));')
# ---- follower 0x47f275 and the pointer receiver 0x47f421
m('follow-prev-copy', 'logic', 'wr_32(obj, O_PREV_T + 12, rd_s32(obj, O_MOVE_T + 12));', ';')
m('follow-centre-height', 'arith', 'sub32(rd_s32(obj, O_PTR_RECT + 12), rd_s32(obj, O_PTR_RECT + 4)) / 2', 'sub32(rd_s32(obj, O_PTR_RECT + 12), rd_s32(obj, O_PTR_RECT + 4)) / 3')
m('follow-bottom', 'arith', 'wr_32(obj, O_MOVE + 12, add32(rd_s32(obj, O_MOVE + 4), rd_s16(obj, O_HH)));', 'wr_32(obj, O_MOVE + 12, add32(rd_s32(obj, O_MOVE + 4), rd_s16(obj, O_HH) + 1));')
m('follow-first-move-or', 'logic', 'if (rd_s32(obj, O_PREV + 4) == 0 && rd_s32(obj, O_PREV + 12) == 0) {', 'if (rd_s32(obj, O_PREV + 4) == 0 || rd_s32(obj, O_PREV + 12) == 0) {')
m('near-top-offset', 'arith', 'sub32(rd_s32(obj, P + 6), 4) < add32(y, half_h)', 'sub32(rd_s32(obj, P + 6), 3) < add32(y, half_h)')
m('near-y-edge', 'compare', 'y < rd_s32(obj, P + 6) &&', 'y <= rd_s32(obj, P + 6) &&')
m('near-left-margin', 'arith', 'sub32(rd_s32(obj, P + 2), 0x14) < sub32(x, half_w)', 'sub32(rd_s32(obj, P + 2), 0x13) < sub32(x, half_w)')
m('near-right-edge', 'compare', 'add32(x, half_w) < add32(rd_s32(obj, P + 10), 0x14))', 'add32(x, half_w) <= add32(rd_s32(obj, P + 10), 0x14))')
m('near-at-home-inverted', 'logic', 'if (!at_home && sub32', 'if (at_home && sub32')
m('cursor-rotate-index', 'arith', 'out->cursor = 0x14;', 'out->cursor = 0x15;')
m('cursor-rotate-flag', 'arith', 'out->cursor_flag = 0;', 'out->cursor_flag = 1;')
m('cursor-rotate-record', 'arith', 'out->cursor_record = 0x5b188cu;', 'out->cursor_record = 0x5b189cu;')
m('cursor-hand-index', 'arith', 'out->cursor = 0x16;', 'out->cursor = 0x17;')
m('cursor-hit-test', 'logic', 'if (rd_s32(obj, O_HIT) == 0 && code != EB_CANDIDATE_PICK)', 'if (rd_s32(obj, O_HIT) == 0 || code != EB_CANDIDATE_PICK)')
m('cursor-record-base', 'arith', 'out->cursor_record = (uint32_t)(0x5b161c + (int64_t)out->cursor * 0x20);', 'out->cursor_record = (uint32_t)(0x5b161c + (int64_t)out->cursor * 0x10);', 2, 0)
m('cursor-exit-b-source', 'logic', 'code == EB_CANDIDATE_EXIT_A ? B_CURSOR_EXIT_A : B_CURSOR_EXIT_B', 'code == EB_CANDIDATE_EXIT_A ? B_CURSOR_EXIT_B : B_CURSOR_EXIT_A')
m('pointer-multi-hand-drag', 'logic', 'if (rd_s32(obj, O_DRAG) != 0 && obj[O_MULTI_HAND] == 0) {', 'if (rd_s32(obj, O_DRAG) != 0) {')
m('area-top-edge', 'compare', 'rd_s32(body, B_AREA + 4) < sub32(y, half_h)', 'rd_s32(body, B_AREA + 4) <= sub32(y, half_h)')
m('area-bottom-edge', 'compare', 'add32(y, half_h) < rd_s32(body, B_AREA + 12)', 'add32(y, half_h) <= rd_s32(body, B_AREA + 12)')
m('area-left-edge', 'compare', 'rd_s32(body, B_AREA) < sub32(x, half_w)', 'rd_s32(body, B_AREA) <= sub32(x, half_w)')
m('area-right-edge', 'compare', 'add32(x, half_w) < rd_s32(body, B_AREA + 8)', 'add32(x, half_w) <= rd_s32(body, B_AREA + 8)')
m('mode-one-near-test', 'logic', '(body[B_MODE] == 1 && near_unplaced(obj, body, x, y))', '(body[B_MODE] == 2 && near_unplaced(obj, body, x, y))')
m('overlap-mode-gate', 'logic', 'if (body[B_MODE] == 0 && body[B_OVERLAP] != 0) {', 'if (body[B_MODE] != 0 && body[B_OVERLAP] != 0) {')
m('overlap-byte-gate', 'logic', 'if (body[B_MODE] == 0 && body[B_OVERLAP] != 0) {', 'if (body[B_MODE] == 0) {')
m('overlap-counter-index', 'logic', 'if (j != hand && obj[O_COUNTS + (size_t)j] != 0) {', 'if (j != hand && obj[O_COUNTS + (size_t)j] == 0) {')
m('overlap-self-skip', 'logic', 'if (j != hand && obj[O_COUNTS + (size_t)j] != 0) {', 'if (obj[O_COUNTS + (size_t)j] != 0) {')
m('overlap-x-margin', 'arith', 'x_hit = add32(rd_s32(obj, P + 2), 3) <= pr;', 'x_hit = add32(rd_s32(obj, P + 2), 4) <= pr;')
m('overlap-x-inside-edge', 'compare', 'else if (pl <= sub32(rd_s32(obj, P + 10), 3))', 'else if (pl < sub32(rd_s32(obj, P + 10), 3))')
m('overlap-y-margin', 'arith', 'y_hit = add32(rd_s32(obj, P + 6), 3) <= pb;', 'y_hit = add32(rd_s32(obj, P + 6), 2) <= pb;')
m('overlap-y-inside-edge', 'compare', 'else if (x_hit && pt <= sub32(rd_s32(obj, P + 14), 3))', 'else if (x_hit && pt < sub32(rd_s32(obj, P + 14), 3))')
m('overlap-left-first', 'compare', 'if (pl < rd_s32(obj, P + 2))', 'if (pl <= rd_s32(obj, P + 2))')
m('list-multi-hand-filter', 'logic', '(obj[O_MULTI_HAND] == 0 || j == rd_s16(obj, O_HAND)) &&', '(obj[O_MULTI_HAND] == 0 && j == rd_s16(obj, O_HAND)) &&')
m('list-stamp-spawn-filter', 'logic', '(obj[P + P_STAMP] == 0 || body[T + BT_SPAWN] == 0)) {', '(obj[P + P_STAMP] == 0 && body[T + BT_SPAWN] == 0)) {')
m('zone-locked-gate', 'logic', 'if (body[B_ROT_ALLOWED] == 0 || body[B_ROT_LOCKED] == 0 || y < rd_s32(obj, P + 6) ||', 'if (body[B_ROT_ALLOWED] == 0 || y < rd_s32(obj, P + 6) ||')
m('zone-allowed-gate', 'logic', 'if (body[B_ROT_ALLOWED] == 0 || body[B_ROT_LOCKED] == 0 || y < rd_s32(obj, P + 6) ||', 'if (body[B_ROT_LOCKED] == 0 || y < rd_s32(obj, P + 6) ||')
m('zone-height-edge', 'compare', 'add32(rd_s32(obj, P + 6), rd_s16(body, B_ZONE_H)) < y', 'add32(rd_s32(obj, P + 6), rd_s16(body, B_ZONE_H)) <= y')
m('zone-width-edge', 'compare', 'add32(rd_s32(obj, P + 2), rd_s16(body, B_ZONE_W)) < x', 'add32(rd_s32(obj, P + 2), rd_s16(body, B_ZONE_W)) <= x')
m('list-bottom-edge', 'compare', 'y <= rd_s32(obj, P + 14) &&', 'y < rd_s32(obj, P + 14) &&')
m('list-right-edge', 'compare', 'x <= rd_s32(obj, P + 10)) {', 'x < rd_s32(obj, P + 10)) {')
m('list-left-edge', 'compare', 'rd_s32(obj, P + 2) <= x &&', 'rd_s32(obj, P + 2) < x &&')
m('rotate-list-priority', 'logic', 'if (rd_s16(obj, O_COUNT2) != 0) {', 'if (rd_s16(obj, O_COUNT2) > 1) {')
m('lists-not-cleared', 'logic', 'for (size_t k = 0; k < 40u; k += 4u) wr_32(obj, O_LIST1 + k, 0);', ';')
m('btn-a-top-edge', 'compare', 'if (rd_s32(body, B_BTN_A + 4) <= y', 'if (rd_s32(body, B_BTN_A + 4) < y')
m('btn-a-right-edge', 'compare', 'x <= rd_s32(body, B_BTN_A + 8)) {', 'x < rd_s32(body, B_BTN_A + 8)) {')
m('btn-b-bottom-edge', 'compare', 'y <= rd_s32(body, B_BTN_B + 12)', 'y < rd_s32(body, B_BTN_B + 12)')
m('btn-b-left-edge', 'compare', 'rd_s32(body, B_BTN_B) <= x', 'rd_s32(body, B_BTN_B) < x')
# ---- sound blocks and captions
m('blip-no-play', 'logic', 'HOST(host->sound_play(host->context, rd_s16(body, chan)));', ';')
m('blip-delay', 'arith', 'wr_32(obj, O_DEADLINE, (int32_t)(host->tick(host->context) + delay));', 'wr_32(obj, O_DEADLINE, (int32_t)(host->tick(host->context) + delay + 1u));')
m('blip-state-skipped', 'logic', 'wr_32(obj, O_STATE, 1);', ';', 2, 0)
m('good-sound-delay', 'arith', 'wr_32(obj, O_DEADLINE, (int32_t)(host->tick(host->context) + 300u));', 'wr_32(obj, O_DEADLINE, (int32_t)(host->tick(host->context) + 301u));')
m('good-silent-deadline', 'logic', 'wr_32(obj, O_DEADLINE, (int32_t)host->tick(host->context));', 'wr_32(obj, O_DEADLINE, (int32_t)host->tick(host->context) + 1);')
m('good-anim-delay', 'arith', 'wr_32(obj, O_DEADLINE2, (int32_t)(host->tick(host->context) + 100u));\n    return EB_OK;', 'wr_32(obj, O_DEADLINE2, (int32_t)(host->tick(host->context) + 101u));\n    return EB_OK;')
m('good-state-anim', 'logic', 'CHECK(save_and_check(obj, body, world, row_phase, host));\n    wr_32(obj, O_STATE, 4);', 'CHECK(save_and_check(obj, body, world, row_phase, host));\n    wr_32(obj, O_STATE, 5);')
m('caption-disabled-test', 'predicate', 'if (enabled == 0) return EB_OK;', 'if (enabled != 1) return EB_OK;')
m('caption-autotext-limit', 'compare', 'strlen(t) < 0x9c41u', 'strlen(t) < 0x9c42u')
m('caption-fallback-or', 'logic', 'if (found == NULL && body[text] != 0)', 'if (found == NULL || body[text] != 0)')
m('caption-key-empty', 'predicate', 'if (body[key] != 0) {', 'if (body[key] == 0) {')
m('caption-suffix', 'arith', 'memcpy(buf + n, "<e>", 4);', 'memcpy(buf + n, "<f>", 4);')
m('caption-local-bad', 'compare', 'caption_block(body, B_KEY_BAD, B_TEXT_BAD, 204, host)', 'caption_block(body, B_KEY_BAD, B_TEXT_BAD, 220, host)')
m('caption-local-win', 'compare', 'caption_block(body, B_KEY_WIN, B_TEXT_WIN, 208, host)', 'caption_block(body, B_KEY_WIN, B_TEXT_WIN, 220, host)')
# ---- event flags and the save / solved check 0x480b34
m('flag-none-test', 'logic', 'if (index == EB_NO_FLAG) return EB_OK;', 'if (index == 0) return EB_OK;')
m('flag-window', 'compare', 'if (host->event_flag_invalid(host->context, index) != 0) return EB_ERR_BOUNDS;', ';')
m('save-flag-not-set', 'logic', 'world->saved_flag = 1;', 'world->saved_flag = 0;')
m('save-counters', 'logic', 'memcpy(world->saved_counts, obj + O_COUNTS, sizeof world->saved_counts);', ';')
m('save-pieces', 'logic', 'memcpy(world->saved_pieces, obj + O_PIECES, sizeof world->saved_pieces);', ';')
m('save-count', 'logic', 'world->saved_count = rd_s16(obj, O_COUNT);', ';')
m('save-total', 'logic', 'world->saved_total = total;', ';')
m('total-spawn-mode', 'logic', '(body[type_off(j) + BT_SPAWN] == 0 || body[B_MODE] == 2)', '(body[type_off(j) + BT_SPAWN] == 0 && body[B_MODE] == 2)')
m('total-count-term', 'arith', 'total = (int16_t)((int16_t)(total + rd_s16(obj, O_COUNT)) - ntypes);', 'total = (int16_t)((int16_t)(total + rd_s16(obj, O_COUNT)) - ntypes + 1);')
m('target-edge', 'compare', 'if (total < rd_s16(body, B_TARGET)) {', 'if (total <= rd_s16(body, B_TARGET)) {')
m('exit-flag-short', 'arith', 'CHECK(write_flag(body, B_FLAG_EXIT, body[B_VALUE_EXIT] == 0, host));\n        return EB_OK;',
  'CHECK(write_flag(body, B_FLAG_EXIT, body[B_VALUE_EXIT], host));\n        return EB_OK;')
m('exit-flag-reached', 'arith', 'CHECK(write_flag(body, B_FLAG_EXIT, body[B_VALUE_EXIT], host));\n    CHECK(write_flag(body, B_FLAG_WIN',
  'CHECK(write_flag(body, B_FLAG_EXIT, body[B_VALUE_EXIT] == 0, host));\n    CHECK(write_flag(body, B_FLAG_WIN')
m('win-flag-provisional', 'arith', 'CHECK(write_flag(body, B_FLAG_WIN, body[B_VALUE_WIN] == 0, host));', 'CHECK(write_flag(body, B_FLAG_WIN, body[B_VALUE_WIN], host));')
m('win-flag-final', 'arith', 'CHECK(write_flag(body, B_FLAG_WIN, body[B_VALUE_WIN], host));\n    if (body[B_WIN_SOUND] == 0) {',
  'CHECK(write_flag(body, B_FLAG_WIN, body[B_VALUE_WIN] + 1u, host));\n    if (body[B_WIN_SOUND] == 0) {')
m('forbidden-inverted', 'predicate', 'if (obj[O_COUNTS + (size_t)j] != 0 && body[T + BT_FORBIDDEN] != 0) return EB_OK;', 'if (obj[O_COUNTS + (size_t)j] == 0 && body[T + BT_FORBIDDEN] != 0) return EB_OK;')
m('forbidden-ignores-count', 'predicate', 'if (obj[O_COUNTS + (size_t)j] != 0 && body[T + BT_FORBIDDEN] != 0) return EB_OK;', 'if (body[T + BT_FORBIDDEN] != 0) return EB_OK;')
m('required-inverted', 'predicate', 'if (body[T + BT_REQUIRED] != 0 && obj[O_COUNTS + (size_t)j] != body[T + BT_REQUIRED]) return EB_OK;',
  'if (body[T + BT_REQUIRED] != 0 && obj[O_COUNTS + (size_t)j] == body[T + BT_REQUIRED]) return EB_OK;')
m('required-zero-ignored', 'predicate', 'if (body[T + BT_REQUIRED] != 0 && obj[O_COUNTS + (size_t)j] != body[T + BT_REQUIRED]) return EB_OK;',
  'if (obj[O_COUNTS + (size_t)j] != body[T + BT_REQUIRED]) return EB_OK;')
m('done-phase-test', 'logic', 'if (row_phase == 2) obj[O_DONE] = 1;', 'if (row_phase == 1) obj[O_DONE] = 1;')
m('win-state', 'logic', 'wr_32(obj, O_STATE, 6);\n        obj[O_DONE] = 1;', 'wr_32(obj, O_STATE, 5);\n        obj[O_DONE] = 1;')
m('win-sound-gate', 'logic', 'if (body[B_WIN_SOUND] == 0) {', 'if (body[B_WIN_SOUND] != 0) {')
# ---- the click 0x47ff0e
m('click-done-gate', 'logic', 'if (rd_s32(obj, O_ACTIVE) == 0 || obj[O_DONE] != 0 || rd_s32(obj, O_STATE) != 0 || row_phase != 1) return EB_OK;',
  'if (rd_s32(obj, O_ACTIVE) == 0 || rd_s32(obj, O_STATE) != 0 || row_phase != 1) return EB_OK;')
m('click-state-gate', 'logic', 'if (rd_s32(obj, O_ACTIVE) == 0 || obj[O_DONE] != 0 || rd_s32(obj, O_STATE) != 0 || row_phase != 1) return EB_OK;',
  'if (rd_s32(obj, O_ACTIVE) == 0 || obj[O_DONE] != 0 || row_phase != 1) return EB_OK;')
m('click-phase-gate', 'logic', 'if (rd_s32(obj, O_ACTIVE) == 0 || obj[O_DONE] != 0 || rd_s32(obj, O_STATE) != 0 || row_phase != 1) return EB_OK;',
  'if (rd_s32(obj, O_ACTIVE) == 0 || obj[O_DONE] != 0 || rd_s32(obj, O_STATE) != 0 || row_phase == 0) return EB_OK;')
m('exit-keeps-phase', 'logic', '*new_phase = 2;\n        CHECK(save_and_check', '*new_phase = 1;\n        CHECK(save_and_check')
m('exit-phase-for-check', 'logic', 'phase = 2;\n        *new_phase = 2;', 'phase = 1;\n        *new_phase = 2;')
m('exit-byte', 'logic', 'obj[O_EXIT] = 1;', ';')
m('exit-done-guard', 'logic', 'if (obj[O_DONE] != 0) return EB_OK;\n        obj[O_EXIT] = 1;', 'obj[O_EXIT] = 1;')
m('exit-candidate-b', 'logic', 'if (candidate == EB_CANDIDATE_EXIT_A || candidate == EB_CANDIDATE_EXIT_B) {', 'if (candidate == EB_CANDIDATE_EXIT_A) {')
m('rotate-click-sound', 'arith', 'CHECK(sound_blip(obj, body, B_SND_ROT, B_CHAN_ROT, 0x15e, host));', 'CHECK(sound_blip(obj, body, B_SND_ROT, B_CHAN_ROT, 0x15f, host));')
m('rotate-key-sound', 'missing-effect', 'CHECK(sound_rotate_480abe(obj, body, host));\n    set_layer', ';\n    set_layer')
m('rotate-click-hand', 'logic', 'wr_16(obj, O_HAND, top);', ';')
m('rotate-click-drag', 'logic', 'wr_32(obj, O_DRAG, 1);\n        wr_16(obj, O_HAND, top);', 'wr_16(obj, O_HAND, top);')
m('pick-candidate-and', 'logic', '(rd_s32(obj, O_DRAG) == 0 && candidate == EB_CANDIDATE_PICK) ||', '(rd_s32(obj, O_DRAG) == 0) ||')
m('pick-multi-second-click', 'logic', '(rd_s32(obj, O_DRAG) != 0 && obj[O_MULTI_HAND] != 0)) {', '(0)) {')
m('pick-multi-branch', 'logic', 'if (obj[O_HAS_MULTI] != 0 && obj[O_MULTI_HAND] == 0) {', 'if (obj[O_HAS_MULTI] != 0) {')
m('pick-multi-hand-flag', 'logic', 'obj[O_MULTI_HAND] = 1;', ';')
m('pick-plain-branch', 'logic', 'if (obj[O_HAS_MULTI] == 0) {\n            hand = top_piece', 'if (obj[O_HAS_MULTI] != 0) {\n            hand = top_piece')
m('spawn-gate', 'logic', 'if (body[T + BT_SPAWN] != 0) {\n            const int16_t count', 'if (body[T + BT_SPAWN] == 0) {\n            const int16_t count')
m('spawn-forced', 'logic', 'CHECK(piece_init(obj, body, world, count, obj[P + P_TYPE], 1, host));', 'CHECK(piece_init(obj, body, world, count, obj[P + P_TYPE], 0, host));')
m('spawn-layer', 'logic', 'set_layer(obj, count);', ';')
m('spawn-count', 'arith', 'wr_16(obj, O_COUNT, (int16_t)(count + 1));', 'wr_16(obj, O_COUNT, (int16_t)(count + 2));')
m('pick-multi-hand-reset', 'logic', 'obj[O_MULTI_HAND] = 0;\n        wr_32(obj, O_LIFT, 1);', 'wr_32(obj, O_LIFT, 1);')
m('pick-c-rect', 'predicate', 'if (rect_valid(body, T + BT_C)) copy_rect(obj, P + P_RECT, body, T + BT_C);', 'if (!rect_valid(body, T + BT_C)) copy_rect(obj, P + P_RECT, body, T + BT_C);')
m('pick-counter-gate', 'logic', 'if (obj[O_COUNTS + obj[P + P_TYPE]] != 0 && body[T + BT_SPAWN] == 0)\n            obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] - 1);',
  'if (obj[O_COUNTS + obj[P + P_TYPE]] != 0)\n            obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] - 1);')
m('pick-sound-delay', 'arith', 'CHECK(sound_blip(obj, body, B_SND_PICK, B_CHAN_PICK, 300, host));', 'CHECK(sound_blip(obj, body, B_SND_PICK, B_CHAN_PICK, 301, host));')
m('drop-flag', 'logic', 'wr_32(obj, O_DROP, 1);', ';')
m('drop-prev-rect', 'logic', 'copy_rect(obj, P + P_RECT, obj, O_PREV);', 'copy_rect(obj, P + P_RECT, obj, O_MOVE);')
m('drop-prev-translated', 'logic', 'copy_rect(obj, P + P_RECT2, obj, O_PREV_T);', 'copy_rect(obj, P + P_RECT2, obj, O_MOVE_T);')
m('drop-layer', 'logic', 'set_layer(obj, hand);', ';')
m('drop-good-mode', 'logic', 'if (rd_s32(obj, O_HIT) != 0 && body[B_MODE] != 2) {', 'if (rd_s32(obj, O_HIT) != 0) {')
m('drop-stamp', 'logic', 'obj[P + P_STAMP] = 1;', ';')
m('drop-counter', 'arith', 'obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);\n            CHECK(sound_good', 'obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 2);\n            CHECK(sound_good', 2, 0)
m('drop-mode2-counter', 'arith', 'obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);\n            CHECK(sound_good(obj, body, world, row_phase, host));\n        }',
  'CHECK(sound_good(obj, body, world, row_phase, host));\n        }')
m('drop-bad-gate', 'logic', 'if (rd_s32(obj, O_HIT) == 0 || body[B_MODE] != 2) {', 'if (rd_s32(obj, O_HIT) == 0 && body[B_MODE] != 2) {')
m('bad-sound-delay', 'arith', 'host->tick(host->context) + 200u', 'host->tick(host->context) + 201u')
m('bad-sound-gate', 'predicate', 'if (!no_sound(body + B_SND_BAD)) {', 'if (no_sound(body + B_SND_BAD)) {')
m('bad-orientation', 'logic', 'CHECK(translate(obj, P + P_RECT, P + P_RECT2, host));\n        obj[P + P_ORIENT] = 0;', 'CHECK(translate(obj, P + P_RECT, P + P_RECT2, host));\n        obj[P + P_ORIENT] = 1;')
m('bad-home-rect', 'logic', 'obj[P + P_STAMP] = 0;\n        copy_rect(obj, P + P_RECT, body, T + BT_B);', 'obj[P + P_STAMP] = 0;\n        copy_rect(obj, P + P_RECT, body, T + BT_A);', 2, 1)
m('hand-size-width', 'arith', 'wr_16(obj, O_HW, (int16_t)sub32(rd_s32(obj, P + 10), rd_s32(obj, P + 2)));', 'wr_16(obj, O_HW, (int16_t)sub32(rd_s32(obj, P + 10), rd_s32(obj, P + 2)) + 1);')
# ---- the second button 0x47ef0f
m('rotkey-allowed-gate', 'logic', 'if (rd_s32(obj, O_ACTIVE) == 0 || body[B_ROT_ALLOWED] == 0 || body[B_ROT_LOCKED] != 0 || obj[O_DONE] != 0 ||',
  'if (rd_s32(obj, O_ACTIVE) == 0 || body[B_ROT_LOCKED] != 0 || obj[O_DONE] != 0 ||')
m('rotkey-locked-gate', 'logic', 'body[B_ROT_ALLOWED] == 0 || body[B_ROT_LOCKED] != 0 || obj[O_DONE] != 0 ||', 'body[B_ROT_ALLOWED] == 0 || obj[O_DONE] != 0 ||')
m('rotkey-list-gate', 'logic', '|| rd_s16(obj, O_COUNT1) == 0)\n        return EB_OK;', ')\n        return EB_OK;')
m('rotkey-drag-branch', 'logic', 'if (rd_s32(obj, O_DRAG) == 0) {\n        size_t T;', 'if (rd_s32(obj, O_DRAG) != 0) {\n        size_t T;')
m('rotkey-counter', 'logic', 'if (obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] != 0 && body[T + BT_SPAWN] == 0)', 'if (obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] != 0)')
m('rotkey-layer', 'logic', 'CHECK(sound_rotate_480abe(obj, body, host));\n    set_layer(obj, piece);', 'CHECK(sound_rotate_480abe(obj, body, host));')
m('rotkey-hand-size', 'logic', 'CHECK(rotate_piece(obj, piece, host));\n        hand_size(obj, piece);\n    }', 'CHECK(rotate_piece(obj, piece, host));\n    }')
# ---- invalidate / cleanup
m('invalidate-or', 'logic', 'if (rd_s32(object->b, O_ACTIVE) != 0 && rd_s16(object->b, O_SLOT) != -1)', 'if (rd_s32(object->b, O_ACTIVE) != 0 || rd_s16(object->b, O_SLOT) != -1)')
m('cleanup-slot-test', 'logic', 'if (rd_s16(obj, O_SLOT) != -1) HOST(host->release_slot(host->context, rd_s16(obj, O_SLOT)));', 'HOST(host->release_slot(host->context, rd_s16(obj, O_SLOT)));')
m('cleanup-type-count', 'logic', 'for (int16_t t = 0; t < EB_MAX_TYPES; ++t)\n        for (unsigned k = 0; k < 4; ++k) {', 'for (int16_t t = 0; t < EB_MAX_TYPES - 1; ++t)\n        for (unsigned k = 0; k < 4; ++k) {')
m('cleanup-orientations', 'logic', 'for (int16_t t = 0; t < EB_MAX_TYPES; ++t)\n        for (unsigned k = 0; k < 4; ++k) {', 'for (int16_t t = 0; t < EB_MAX_TYPES; ++t)\n        for (unsigned k = 0; k < 3; ++k) {')
m('cleanup-surface-zeroed', 'logic', 'wr_32(obj, surfaces[k], 0);', ';')
m('cleanup-entry-zeroed', 'logic', 'wr_32(obj, e + ENT_SURF, 0);', ';')
m('cleanup-exit-byte', 'logic', 'obj[O_EXIT] = 0;\n    obj[O_DONE] = 0;', 'obj[O_DONE] = 0;')
m('cleanup-done-byte', 'logic', 'obj[O_DONE] = 0;\n    wr_32(obj, O_DRAG, 0);\n    return EB_OK;', 'wr_32(obj, O_DRAG, 0);\n    return EB_OK;')
m('cleanup-drag', 'logic', 'obj[O_DONE] = 0;\n    wr_32(obj, O_DRAG, 0);\n    return EB_OK;', 'obj[O_DONE] = 0;\n    return EB_OK;')
m('cleanup-active', 'logic', 'wr_32(obj, O_ACTIVE, 0);\n    obj[O_EXIT] = 0;', 'obj[O_EXIT] = 0;')
# ---- finish blocks
m('block-scene-none', 'compare', 'if (rd_s16(blk, SB_SCENE) != EB_NO_SCENE) {', 'if (rd_s16(blk, SB_SCENE) == EB_NO_SCENE) {')
m('block-start-flag', 'compare', 'rd_s16(blk, SB_START) != 1 ? 1 : 0', 'rd_s16(blk, SB_START) != 0 ? 1 : 0')
m('block-scene-cell', 'logic', 'world->scene_5bb57b = t.scene;', ';')
m('block-word-two', 'arith', 't.word[1] = rd_s16(blk, SB_W2);', 't.word[1] = rd_s16(blk, SB_W1);')
m('block-dword-three', 'arith', 't.dword[2] = rd_s32(blk, SB_D3);', 't.dword[2] = rd_s32(blk, SB_D2);')
m('phase2-block-choice', 'logic', 'if (obj[O_DONE] != 0) CHECK(apply_block(body + B_BLOCK_WIN, world, host));', 'if (obj[O_DONE] != 0) CHECK(apply_block(body + B_BLOCK_EXIT, world, host));')
m('phase2-exit-block', 'logic', 'CHECK(apply_block(body + B_BLOCK_EXIT, world, host));\n    }', 'CHECK(apply_block(body + B_BLOCK_WIN, world, host));\n    }')
m('phase2-no-done-block', 'logic', 'if (obj[O_DONE] != 0) CHECK(apply_block', 'CHECK(apply_block')
m('phase2-start-flag', 'logic', 'world->start_flag_5bb1ca = 1;', ';', 2, 1)
m('phase2-stop-order', 'logic', 'static const size_t order[4] = {B_SND_PICK, B_SND_GOOD, B_SND_BAD, B_SND_ROT};', 'static const size_t order[4] = {B_SND_PICK, B_SND_GOOD, B_SND_ROT, B_SND_BAD};')
m('phase2-complete-row', 'logic', 'HOST(host->complete(host->context, rd_s16(obj, O_ROW)));', ';')
# ---- phase 0
m('p0-start-flag', 'logic', 'world->start_flag_5bb1ca = 1;', ';', 2, 0)
m('p0-clear-item', 'logic', 'HOST(host->clear_pending_item(host->context));', ';')
m('p0-hit-reset', 'logic', 'wr_32(obj, O_HIT, 0);\n    wr_32(obj, O_DRAG, 0);\n    wr_16(obj, O_HAND, -1);', 'wr_32(obj, O_DRAG, 0);\n    wr_16(obj, O_HAND, -1);')
m('p0-hand', 'logic', 'wr_16(obj, O_HAND, -1);\n    wr_32(obj, O_DRAG, 0);', 'wr_32(obj, O_DRAG, 0);')
m('p0-drop-lift', 'logic', 'wr_32(obj, O_DROP, 0);\n    wr_32(obj, O_LIFT, 0);', 'wr_32(obj, O_LIFT, 0);')
m('p0-rects-cleared', 'logic', 'for (size_t off = O_PREV; off < O_PREV + 0x40u; off += 4u) wr_32(obj, off, 0);', 'for (size_t off = O_PREV; off < O_PREV + 0x30u; off += 4u) wr_32(obj, off, 0);')
m('p0-pointer-rect-cleared', 'logic', 'for (size_t off = O_PTR_RECT; off < O_PTR_RECT + 16u; off += 4u) wr_32(obj, off, 0);', ';')
m('p0-deadline', 'logic', 'wr_32(obj, O_DEADLINE, 0);\n    wr_16(obj, O_ANIM_ROW, 0);', 'wr_16(obj, O_ANIM_ROW, 0);')
m('p0-anim-frame', 'logic', 'wr_16(obj, O_ANIM_FRAME, 0);\n    wr_16(obj, O_CELL_W', 'wr_16(obj, O_CELL_W')
m('p0-cell-width', 'arith', 'wr_16(obj, O_CELL_W, (int16_t)sub32(rd_s32(body, B_ANIM_AREA + 8), rd_s32(body, B_ANIM_AREA)));',
  'wr_16(obj, O_CELL_W, (int16_t)sub32(rd_s32(body, B_ANIM_AREA + 8), rd_s32(body, B_ANIM_AREA)) + 1);')
m('p0-cell-height', 'arith', 'wr_16(obj, O_CELL_H, (int16_t)sub32(rd_s32(body, B_ANIM_AREA + 12), rd_s32(body, B_ANIM_AREA + 4)));',
  'wr_16(obj, O_CELL_H, (int16_t)sub32(rd_s32(body, B_ANIM_AREA + 12), rd_s32(body, B_ANIM_AREA)));')
m('p0-source-already-loaded', 'logic', 'if (rd_s32(obj, O_SRC) == 0) {', 'if (rd_s32(obj, O_SRC) != 0) {')
m('p0-surfaces-cleared', 'logic', 'for (int16_t t = 0; t < EB_MAX_TYPES; ++t)\n        for (unsigned k = 0; k < 4; ++k) wr_32(obj, entry_off(t, k) + ENT_SURF, 0);', ';')
m('p0-fresh-persist', 'logic', 'if (body[B_PERSIST] == 0 || world->saved_flag == 0 || (int32_t)world->saved_scene != world->scene_5bb57b) {', 'if (body[B_PERSIST] != 0 || world->saved_flag == 0 || (int32_t)world->saved_scene != world->scene_5bb57b) {')
m('p0-fresh-flag', 'logic', 'if (body[B_PERSIST] == 0 || world->saved_flag == 0 || (int32_t)world->saved_scene != world->scene_5bb57b) {', 'if (body[B_PERSIST] == 0 || (int32_t)world->saved_scene != world->scene_5bb57b) {')
m('p0-fresh-scene', 'logic', 'if (body[B_PERSIST] == 0 || world->saved_flag == 0 || (int32_t)world->saved_scene != world->scene_5bb57b) {', 'if (body[B_PERSIST] == 0 || world->saved_flag == 0 || (int32_t)world->saved_scene == world->scene_5bb57b) {')
m('p0-saved-scene', 'logic', 'world->saved_scene = (int16_t)world->scene_5bb57b;', ';')
m('p0-instances-cleared', 'logic', 'memset(obj + O_PIECES, 0, sizeof world->saved_pieces);', ';')
m('p0-counters-cleared', 'logic', 'memset(obj + O_COUNTS, 0, 20);', 'memset(obj + O_COUNTS, 0, 19);')
m('p0-count-ntypes', 'arith', 'wr_16(obj, O_COUNT, ntypes);', 'wr_16(obj, O_COUNT, ntypes + 1);')
m('p0-total-fresh', 'logic', 'wr_16(obj, O_COUNT, ntypes);\n        wr_16(obj, O_TOTAL, 0);', 'wr_16(obj, O_COUNT, ntypes);')
m('p0-restore-pieces', 'logic', 'memcpy(obj + O_PIECES, world->saved_pieces, sizeof world->saved_pieces);', ';')
m('p0-restore-counters', 'logic', 'memcpy(obj + O_COUNTS, world->saved_counts, sizeof world->saved_counts);', ';')
m('p0-restore-count', 'logic', 'wr_16(obj, O_COUNT, world->saved_count);', 'wr_16(obj, O_COUNT, ntypes);')
m('p0-restore-total', 'logic', 'wr_16(obj, O_TOTAL, world->saved_total);', ';')
m('p0-multi-name-test', 'logic', 'if (no_file(body + B_MULTI_NAME) || body[B_MULTI_NAME] == 0) {', 'if (no_file(body + B_MULTI_NAME)) {')
m('p0-multi-empty-test', 'logic', 'if (no_file(body + B_MULTI_NAME) || body[B_MULTI_NAME] == 0) {', 'if (body[B_MULTI_NAME] == 0) {')
m('p0-anim-name-test', 'logic', 'if (!no_file(body + B_ANIM_NAME) && body[B_ANIM_NAME] != 0) {', 'if (!no_file(body + B_ANIM_NAME)) {')
m('p0-anim-empty-test', 'logic', 'if (!no_file(body + B_ANIM_NAME) && body[B_ANIM_NAME] != 0) {', 'if (body[B_ANIM_NAME] != 0) {')
m('p0-anim-flags', 'logic', 'obj[O_ANIM_REST] = 0;\n    obj[O_ANIM_ON] = 0;', 'obj[O_ANIM_ON] = 0;')
m('p0-slot-label', 'logic', 'HOST(host->register_slot(host->context, slot, LABEL_SLOT));', ';')
m('p0-prepare-order', 'logic', 'static const size_t order[4] = {B_SND_PICK, B_SND_GOOD, B_SND_ROT, B_SND_BAD};', 'static const size_t order[4] = {B_SND_PICK, B_SND_ROT, B_SND_GOOD, B_SND_BAD};')
m('p0-prepare-skips-no-sound', 'predicate', 'if (!no_sound(body + order[k]))\n                HOST(host->sound_prepare', 'if (1)\n                HOST(host->sound_prepare')
# ---- phase 1 state machine 0x480e02
m('s0-count-limit', 'compare', 'if (rd_s16(obj, O_COUNT) > 0x4f) *row_phase = 2;', 'if (rd_s16(obj, O_COUNT) > 0x50) *row_phase = 2;')
m('s0-count-edge', 'compare', 'if (rd_s16(obj, O_COUNT) > 0x4f) *row_phase = 2;', 'if (rd_s16(obj, O_COUNT) >= 0x4f) *row_phase = 2;')
m('s1-deadline-edge', 'compare', 'if ((uint32_t)rd_s32(obj, O_DEADLINE) <= host->tick(host->context)) wr_32(obj, O_STATE, 0);', 'if ((uint32_t)rd_s32(obj, O_DEADLINE) < host->tick(host->context)) wr_32(obj, O_STATE, 0);')
m('s1-deadline-signed', 'compare', 'if ((uint32_t)rd_s32(obj, O_DEADLINE) <= host->tick(host->context)) wr_32(obj, O_STATE, 0);',
  'if (rd_s32(obj, O_DEADLINE) <= (int32_t)host->tick(host->context)) wr_32(obj, O_STATE, 0);')
m('s3-busy-test', 'predicate', 'if (busy == 0) {\n            HOST(host->sound_stop(host->context, B_SND_WIN', 'if (busy != 0) {\n            HOST(host->sound_stop(host->context, B_SND_WIN')
m('s3-stop-win', 'logic', 'HOST(host->sound_stop(host->context, B_SND_WIN, body + B_SND_WIN));\n            *row_phase = 2;', '*row_phase = 2;')
m('s3-channel', 'logic', 'HOST(host->sound_busy(host->context, rd_s16(body, B_CHAN_WIN), &busy));', 'HOST(host->sound_busy(host->context, rd_s16(body, B_CHAN_GOOD), &busy));')
m('s4-noanim-deadline', 'compare', 'if ((uint32_t)rd_s32(obj, O_DEADLINE) <= host->tick(host->context))\n                wr_32(obj, O_STATE, obj[O_DONE] == 0 ? 0 : 6);',
  'if ((uint32_t)rd_s32(obj, O_DEADLINE) < host->tick(host->context))\n                wr_32(obj, O_STATE, obj[O_DONE] == 0 ? 0 : 6);')
m('s4-noanim-next', 'logic', 'wr_32(obj, O_STATE, obj[O_DONE] == 0 ? 0 : 6);', 'wr_32(obj, O_STATE, obj[O_DONE] == 0 ? 6 : 0);', 2, 0)
m('s4-anim-on', 'logic', 'obj[O_ANIM_ON] = 1;', ';')
m('s4-good-sound-test', 'predicate', 'if (!no_sound(body + B_SND_GOOD)) {\n                int32_t busy = 0;', 'if (no_sound(body + B_SND_GOOD)) {\n                int32_t busy = 0;')
m('s4-good-busy', 'predicate', 'if (busy == 0) HOST(host->sound_play(host->context, rd_s16(body, B_CHAN_GOOD)));', 'if (busy != 0) HOST(host->sound_play(host->context, rd_s16(body, B_CHAN_GOOD)));')
m('s4-rows-edge', 'compare', 'if (rd_s16(body, B_GRID_ROWS) <= rd_s16(obj, O_ANIM_FRAME) / cols) {', 'if (rd_s16(body, B_GRID_ROWS) < rd_s16(obj, O_ANIM_FRAME) / cols) {')
m('s4-repeat-edge', 'compare', 'if (rd_s16(obj, O_ANIM_ROW) < rd_s16(body, B_GRID_REPEAT)) {', 'if (rd_s16(obj, O_ANIM_ROW) <= rd_s16(body, B_GRID_REPEAT)) {')
m('s4-cell-column', 'arith', 'mul32(add32(rd_s16(obj, O_CELL_W), rd_s16(body, B_GRID_GAP)), frame % cols)', 'mul32(add32(rd_s16(obj, O_CELL_W), rd_s16(body, B_GRID_GAP)), frame / cols)')
m('s4-cell-row', 'arith', 'row = (int16_t)(frame / cols);', 'row = (int16_t)(frame % cols);')
m('s4-gap', 'arith', 'mul32(add32(rd_s16(obj, O_CELL_H), rd_s16(body, B_GRID_GAP)), row)', 'mul32(add32(rd_s16(obj, O_CELL_H), 0), row)')
m('s4-origin', 'arith', 'frame % cols), 1));', 'frame % cols), 0));')
m('s4-frame-step', 'arith', 'wr_16(obj, O_ANIM_FRAME, (int16_t)(rd_s16(obj, O_ANIM_FRAME) + 1));', 'wr_16(obj, O_ANIM_FRAME, (int16_t)(rd_s16(obj, O_ANIM_FRAME) + 2));')
m('s4-next-delay', 'logic', 'wr_32(obj, O_STATE, 5);', 'wr_32(obj, O_STATE, 4);')
m('s4-restore', 'logic', 'obj[O_ANIM_REST] = 1;', ';')
m('s4-anim-off', 'logic', 'obj[O_ANIM_REST] = 1;\n                obj[O_ANIM_ON] = 0;', 'obj[O_ANIM_REST] = 1;')
m('s4-row-reset', 'logic', 'wr_16(obj, O_ANIM_ROW, 0);\n                obj[O_ANIM_REST] = 1;', 'obj[O_ANIM_REST] = 1;')
m('s5-deadline-edge', 'compare', '(uint32_t)rd_s32(obj, O_DEADLINE2) <= host->tick(host->context)', '(uint32_t)rd_s32(obj, O_DEADLINE2) < host->tick(host->context)')
m('s5-rearm', 'arith', 'wr_32(obj, O_DEADLINE2, (int32_t)(host->tick(host->context) + 100u));\n        }', 'wr_32(obj, O_DEADLINE2, (int32_t)(host->tick(host->context) + 101u));\n        }')
m('s6-sound-test', 'predicate', 'if (no_sound(body + B_SND_WIN)) {\n            *row_phase = 2;', 'if (!no_sound(body + B_SND_WIN)) {\n            *row_phase = 2;')
m('s6-prepare', 'logic', 'HOST(host->sound_prepare(host->context, B_SND_WIN, body + B_SND_WIN));', ';')
m('s6-play', 'logic', 'HOST(host->sound_play(host->context, rd_s16(body, B_CHAN_WIN)));', ';')
m('s6-next-state', 'logic', 'wr_32(obj, O_STATE, 3);', 'wr_32(obj, O_STATE, 4);')
# ---- render plan 0x481cb9
m('plan-drop-or', 'logic', 'if (rd_s32(obj, O_DROP) != 0 || rd_s32(obj, O_DRAG) != 0) {', 'if (rd_s32(obj, O_DROP) != 0 && rd_s32(obj, O_DRAG) != 0) {')
m('plan-drop-flag-kept', 'logic', 'plan_blit(plan, 0, 0, 0, src, dst);\n        wr_32(obj, O_DROP, 0);', 'plan_blit(plan, 0, 0, 0, src, dst);')
m('plan-lift-flag-kept', 'logic', 'wr_32(obj, O_LIFT, 0);', ';', 2, 1)
m('plan-lift-translated', 'arith', 'xlate(&v, src, moved);\n        plan_blit(plan, 0, 0, 0, src, moved);\n        wr_32(obj, O_LIFT, 0);', 'plan_blit(plan, 0, 0, 0, src, src);\n        wr_32(obj, O_LIFT, 0);')
m('plan-want-hand', 'arith', 'want = (int16_t)(n - 1);', 'want = n;')
m('plan-stamped-kind', 'logic', 'plan_blit(plan, 1, 4, (uint32_t)rd_s32(obj, ent + ENT_SURF), src, dst);', 'plan_blit(plan, 0, 4, (uint32_t)rd_s32(obj, ent + ENT_SURF), src, dst);', 2, 1)
m('plan-hand-kind', 'logic', 'plan_blit(plan, 1, 4, (uint32_t)rd_s32(obj, ent + ENT_SURF), src, dst);', 'plan_blit(plan, 0, 4, (uint32_t)rd_s32(obj, ent + ENT_SURF), src, dst);', 2, 0)
m('plan-orient-mask', 'logic', 'entry_off(obj[P + P_TYPE], obj[P + P_ORIENT] & 3u)', 'entry_off(obj[P + P_TYPE], 0)', 2, 0)
m('plan-moving-dst', 'arith', 'rect_at(obj, O_MOVE_T, dst);', 'rect_at(obj, O_MOVE, dst);')
m('plan-multi-source', 'arith', 'rect_at(body, T + BT_D, src);', 'rect_at(body, T + BT_A, src);')
m('plan-multi-dst', 'arith', 'rect_at(obj, P + P_RECT2, dst);\n                    plan_blit(plan, 1, 3', 'rect_at(obj, P + P_RECT, dst);\n                    plan_blit(plan, 1, 3')
m('plan-anim-restore', 'logic', 'obj[O_ANIM_REST] = 0;', ';', 2, 1)
m('plan-anim-on-gate', 'logic', 'if (obj[O_ANIM_ON] == 0) {\n                if (obj[O_ANIM_REST] != 0) {', 'if (obj[O_ANIM_ON] != 0) {\n                if (obj[O_ANIM_REST] != 0) {')
m('plan-anim-source', 'arith', 'rect_at(obj, O_ANIM_SRC, src);\n                plan_blit(plan, 0, 1', 'rect_at(body, B_ANIM_AREA, src);\n                plan_blit(plan, 0, 1')
m('plan-stamp-gate', 'logic', 'if (obj[P + P_STAMP] == 0) {\n                        if (rect_valid(body, T + BT_A)) {', 'if (obj[P + P_STAMP] != 0) {\n                        if (rect_valid(body, T + BT_A)) {')
m('plan-a-valid', 'predicate', 'if (rect_valid(body, T + BT_A)) {\n                            rect_at', 'if (!rect_valid(body, T + BT_A)) {\n                            rect_at')
m('plan-layer-test', 'compare', 'if (rd_s16(obj, P + P_Z) == layer) {', 'if (rd_s16(obj, P + P_Z) <= layer) {')
m('plan-hand-skip', 'logic', 'if (rd_s32(obj, O_DRAG) == 0 || rd_s16(obj, O_HAND) != c) {', 'if (rd_s32(obj, O_DRAG) == 0 || rd_s16(obj, O_HAND) == c) {')
m('plan-source-surface', 'logic', 'plan_blit(plan, 1, 2, (uint32_t)rd_s32(obj, O_SRC), src, dst);', 'plan_blit(plan, 1, 3, (uint32_t)rd_s32(obj, O_SRC), src, dst);')


# Equivalent mutants: the edit changes no observable behaviour; each carries its reason.
EQUIVALENT = {
    'clamp-top-edge': 'at an equal edge the branch rewrites the edge with the value it already has and recomputes the opposite edge from the same 16-bit height, so nothing changes for rectangle sizes below 32768 (validated piece sizes are at most 4096)',
    'clamp-bottom-edge': 'at an equal edge the branch rewrites the edge with the value it already has and recomputes the opposite edge from the same 16-bit height, so nothing changes for rectangle sizes below 32768 (validated piece sizes are at most 4096)',
    'clamp-left-edge': 'at an equal edge the branch rewrites the edge with the value it already has and recomputes the opposite edge from the same 16-bit height, so nothing changes for rectangle sizes below 32768 (validated piece sizes are at most 4096)',
    'clamp-right-edge': 'at an equal edge the branch rewrites the edge with the value it already has and recomputes the opposite edge from the same 16-bit height, so nothing changes for rectangle sizes below 32768 (validated piece sizes are at most 4096)',
    'layer-self-overlap': 'a piece compared with itself contributes its own z to the maximum, which the maximum already contains, so the layer is unchanged',
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
    cmd = [sys.executable, str(ORACLE), '--src', str(src_dir), '--workers', '1', '--result', str(result), '--fail-fast', '--lenient-build',
           '--mutation-run']
    if quick:
        cmd.append('--quick-only')
    try:
        done = subprocess.run(cmd, capture_output=True, text=True, cwd=str(HERE), timeout=1500)
    except subprocess.TimeoutExpired:
        return 'KILLED', 'timeout (the mutant hangs or loops: observed as a failure)'
    first = next((l for l in done.stdout.splitlines() if l.startswith('FIRST')), None)
    if 'driver build failed' in done.stderr or 'driver build failed' in done.stdout:
        return 'INVALID', 'does not build: ' + (done.stderr or done.stdout)[-300:].replace('\n', ' ')
    if done.returncode == 0:
        return 'SURVIVED', None
    if first is not None:
        return 'KILLED', first[:240]
    if done.returncode < 0:
        return 'KILLED', 'crash signal %d' % -done.returncode
    return 'ERROR', (done.stderr or done.stdout)[-400:].replace('\n', ' ')


def one(args):
    name, cls, old, new, count, which, kernel_text, work, stage = args
    d = work / name
    d.mkdir()
    for h in (PROJECT / 'src').glob('action_family_eb_runtime*.h'):
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
    ap.add_argument('--check-sites', action='store_true')
    a = ap.parse_args()
    kernel_text = (PROJECT / 'src' / KERNEL).read_text()
    names = [t[0] for t in M]
    if len(set(names)) != len(names):
        raise SystemExit('duplicate mutant names')
    if a.check_sites:
        bad = 0
        for name, cls, old, new, count, which in M:
            try:
                apply(kernel_text, old, new, count, which)
            except ValueError as e:
                print('SITE', name, e)
                bad += 1
        print('mutants', len(M), 'bad sites', bad)
        return 1 if bad else 0
    work = Path(tempfile.mkdtemp(prefix='eb_mut_'))
    t0 = time.monotonic()
    todo = [(name, cls, old, new, count, which, kernel_text, work, a.stage) for name, cls, old, new, count, which in M
            if not a.only or any(o in name for o in a.only.split(','))]
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
