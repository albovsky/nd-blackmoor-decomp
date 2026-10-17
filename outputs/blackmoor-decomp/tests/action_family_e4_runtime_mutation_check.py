#!/usr/bin/env python3
"""RT-54 mutation check for the raw-0xe4 oracle.

Every mutant is a one-site textual edit of a COPY of src/action_family_e4_runtime.c (the project file is never touched). Each mutant
is built into a driver library and run through the original-x86 oracle (action_family_e4_runtime_original_oracle.py, `--src DIR`). A mutant
is KILLED when the oracle reports at least one mismatch against the unmodified GAME.EXE image (or one of its native-only refusal
checks fails); it SURVIVES when the oracle still reports 0 mismatches; it is INVALID if it does not compile or the edit site is not
found the stated number of times (invalid mutants never count as killed).

Usage:  python3 action_family_e4_runtime_mutation_check.py [--stage quick|full] [--only NAME] [--jobs N] [--result FILE]
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
ORACLE = HERE / 'action_family_e4_runtime_original_oracle.py'
KERNEL = 'action_family_e4_runtime.c'

# (name, class, old text, new text, expected occurrences of old text, index of the occurrence to edit)
M = []


def m(name, cls, old, new, count=1, which=0):
    M.append((name, cls, old, new, count, which))


# ---- the "NO SOUND\0" test (repe cmpsb, 9 bytes)
m('nosound-8-bytes', 'compare', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8) == 0;')
m('nosound-case', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'n', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}")
m('nosound-last-char', 'compare', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'E', 0}")
m('nosound-inverted', 'predicate', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k) != 0;')
# ---- body validation (native-only refusals, checked by refusal_checks)
m('validate-length-lt', 'validate', 'length != E4R_BODY_BYTES', 'length < E4R_BODY_BYTES')
m('validate-rows-low', 'validate', 'if (rows < 1 || rows > E4R_MAX_ROWS)', 'if (rows < 0 || rows > E4R_MAX_ROWS)')
m('validate-rows-high', 'validate', 'if (rows < 1 || rows > E4R_MAX_ROWS)', 'if (rows < 1 || rows > E4R_MAX_ROWS + 1)')
m('validate-cols-low', 'validate', 'else if (cols < 1 || cols > E4R_MAX_COLS)', 'else if (cols < 0 || cols > E4R_MAX_COLS)')
m('validate-cols-high', 'validate', 'else if (cols < 1 || cols > E4R_MAX_COLS)', 'else if (cols < 1 || cols > E4R_MAX_COLS + 1)')
m('validate-kinds-low', 'validate', 'kinds < E4R_MIN_KINDS || kinds > E4R_MAX_KINDS', 'kinds < E4R_MIN_KINDS - 1 || kinds > E4R_MAX_KINDS')
m('validate-kinds-high', 'validate', 'kinds < E4R_MIN_KINDS || kinds > E4R_MAX_KINDS', 'kinds < E4R_MIN_KINDS || kinds > E4R_MAX_KINDS + 1')
m('validate-font-low', 'validate', 'font < 0 || font > E4R_MAX_FONT', 'font < -1 || font > E4R_MAX_FONT')
m('validate-font-high', 'validate', 'font < 0 || font > E4R_MAX_FONT', 'font < 0 || font > E4R_MAX_FONT + 1')
m('validate-name-short', 'validate', '!terminated(body, E4R_NAME_BYTES)', '!terminated(body, E4R_NAME_BYTES - 1)')
m('validate-score-name-skipped', 'validate', '!terminated(body + B_SCORE_NAME, E4R_NAME_BYTES)', '0')
m('validate-title-skipped', 'validate', '!terminated(body + B_TITLE, E4R_NAME_BYTES)', '0')
m('validate-sound-a-skipped', 'validate', '!terminated(body + B_SOUND_A, E4R_NAME_BYTES)', '0')
m('validate-sound-b-skipped', 'validate', '!terminated(body + B_SOUND_B, E4R_NAME_BYTES)', '0')
m('validate-sound-c-skipped', 'validate', '!terminated(body + B_SOUND_C, E4R_NAME_BYTES)', '0')
m('validate-sound-d-skipped', 'validate', '!terminated(body + B_SOUND_D, E4R_NAME_BYTES)', '0')
m('validate-sound-d-short', 'validate', '!terminated(body + B_SOUND_D, E4R_NAME_BYTES)', '!terminated(body + B_SOUND_D, E4R_NAME_BYTES - 1)')
m('validate-piece-names-all', 'validate', 'for (k = 0; why == NULL && k < kinds; ++k)', 'for (k = 0; why == NULL && k < E4R_MAX_KINDS; ++k)')
m('validate-piece-names-short', 'validate', 'for (k = 0; why == NULL && k < kinds; ++k)', 'for (k = 0; why == NULL && k < kinds - 1; ++k)')
m('validate-piece-name-width', 'validate', 'terminated(body + B_KIND_NAME + (size_t)k * E4R_NAME_BYTES, E4R_NAME_BYTES)',
  'terminated(body + B_KIND_NAME + (size_t)k * E4R_NAME_BYTES, E4R_NAME_BYTES - 1)')
# ---- in_board, kinds_in_range
m('inboard-row-high', 'compare', 'return row >= 0 && row < bs16(body, B_ROWS) && col >= 0', 'return row >= 0 && row <= bs16(body, B_ROWS) && col >= 0')
m('inboard-row-low', 'compare', 'return row >= 0 && row < bs16(body, B_ROWS) && col >= 0', 'return row >= -1 && row < bs16(body, B_ROWS) && col >= 0')
m('inboard-col-high', 'compare', 'col >= 0 && col < bs16(body, B_COLS);', 'col >= 0 && col <= bs16(body, B_COLS);')
m('inboard-col-low', 'compare', 'col >= 0 && col < bs16(body, B_COLS);', 'col >= -1 && col < bs16(body, B_COLS);')
m('kinds-range-low', 'compare', 'if (kind < 0 || kind >= kinds) return 0;', 'if (kind < -1 || kind >= kinds) return 0;')
m('kinds-range-high', 'compare', 'if (kind < 0 || kind >= kinds) return 0;', 'if (kind < 0 || kind > kinds) return 0;')
m('kinds-range-skipped', 'compare', 'if (kind < 0 || kind >= kinds) return 0;', 'if (0) return 0;')
# ---- cell rectangles 0x475bef
m('cellrect-w-axis', 'rect', 'wrap_mul(col, w), view[0])', 'wrap_mul(col, h), view[0])')
m('cellrect-h-axis', 'rect', 'wrap_mul(row, h), view[1])', 'wrap_mul(row, w), view[1])')
m('cellrect-view-x-missing', 'rect', 'wrap_mul(col, w), view[0])', 'wrap_mul(col, w), 0)')
m('cellrect-view-y-missing', 'rect', 'wrap_mul(row, h), view[1])', 'wrap_mul(row, h), 0)')
m('cellrect-view-swapped', 'rect', 'wrap_mul(col, w), view[0])', 'wrap_mul(col, w), view[1])')
m('cellrect-xoff-field', 'rect', 'wrap_add(x, bs16(body, B_X_OFFSET))', 'wrap_add(x, bs16(body, B_Y_OFFSET))')
m('cellrect-yoff-field', 'rect', 'wrap_add(y, bs16(body, B_Y_OFFSET))', 'wrap_add(y, bs16(body, B_X_OFFSET))')
m('cellrect-xgap-by-row', 'rect', 'wrap_mul(bs16(body, B_X_GAP), col)', 'wrap_mul(bs16(body, B_X_GAP), row)')
m('cellrect-ygap-by-col', 'rect', 'wrap_mul(bs16(body, B_Y_GAP), row)', 'wrap_mul(bs16(body, B_Y_GAP), col)')
m('cellrect-xgap-field', 'rect', 'wrap_mul(bs16(body, B_X_GAP), col)', 'wrap_mul(bs16(body, B_Y_GAP), col)')
m('cellrect-ygap-field', 'rect', 'wrap_mul(bs16(body, B_Y_GAP), row)', 'wrap_mul(bs16(body, B_X_GAP), row)')
m('cellrect-right-uses-h', 'rect', 'ob32(o, at + 8, wrap_add(x, w));', 'ob32(o, at + 8, wrap_add(x, h));')
m('cellrect-bottom-uses-w', 'rect', 'ob32(o, at + 12, wrap_add(y, h));', 'ob32(o, at + 12, wrap_add(y, w));')
m('cellrect-top-slot', 'rect', 'ob32(o, at + 4, y);', 'ob32(o, at + 4, x);')
m('cellrect-w-no-truncation', 'signedness', 'const int16_t w = (int16_t)(bs32(body, B_PIECE_RECT + 8) - bs32(body, B_PIECE_RECT));',
  'const int32_t w = (bs32(body, B_PIECE_RECT + 8) - bs32(body, B_PIECE_RECT));')
m('cellrect-h-no-truncation', 'signedness', 'const int16_t h = (int16_t)(bs32(body, B_PIECE_RECT + 12) - bs32(body, B_PIECE_RECT + 4));',
  'const int32_t h = (bs32(body, B_PIECE_RECT + 12) - bs32(body, B_PIECE_RECT + 4));')
m('cellrect-w-field', 'rect', 'bs32(body, B_PIECE_RECT + 8) - bs32(body, B_PIECE_RECT));', 'bs32(body, B_PIECE_RECT + 12) - bs32(body, B_PIECE_RECT));')
m('cellrect-h-field', 'rect', 'bs32(body, B_PIECE_RECT + 12) - bs32(body, B_PIECE_RECT + 4));', 'bs32(body, B_PIECE_RECT + 8) - bs32(body, B_PIECE_RECT + 4));')
# ---- fill 0x475a1e
m('fill-modulus', 'constant', 'kind = (int16_t)(value % (kinds - 1));', 'kind = (int16_t)(value % kinds);')
m('fill-modulus-minus-two', 'constant', 'kind = (int16_t)(value % (kinds - 1));', 'kind = (int16_t)(value % (kinds - 2));')
m('fill-modulus-unsigned', 'signedness', 'kind = (int16_t)(value % (kinds - 1));', 'kind = (int16_t)((uint32_t)value % (uint32_t)(kinds - 1));')
m('fill-top-neighbour-skipped', 'predicate', 'if (r > 0 && kind == e4r_rd16(o, cell_at(r - 1, c) + CELL_KIND))', 'if (0 && kind == e4r_rd16(o, cell_at(r - 1, c) + CELL_KIND))')
m('fill-left-neighbour-skipped', 'predicate', 'else if (c > 0 && kind == e4r_rd16(o, cell_at(r, c - 1) + CELL_KIND))', 'else if (0 && kind == e4r_rd16(o, cell_at(r, c - 1) + CELL_KIND))')
m('fill-top-neighbour-row-bound', 'compare', 'if (r > 0 && kind == e4r_rd16(o, cell_at(r - 1, c) + CELL_KIND))', 'if (r > 1 && kind == e4r_rd16(o, cell_at(r - 1, c) + CELL_KIND))')
m('fill-left-neighbour-col-bound', 'compare', 'else if (c > 0 && kind == e4r_rd16(o, cell_at(r, c - 1) + CELL_KIND))', 'else if (c > 1 && kind == e4r_rd16(o, cell_at(r, c - 1) + CELL_KIND))')
m('fill-top-neighbour-wrong-cell', 'rect', 'cell_at(r - 1, c) + CELL_KIND))\n                    retry = 1;', 'cell_at(r - 1, 0) + CELL_KIND))\n                    retry = 1;')
m('fill-left-neighbour-wrong-cell', 'rect', 'cell_at(r, c - 1) + CELL_KIND))\n                    retry = 1;', 'cell_at(0, c - 1) + CELL_KIND))\n                    retry = 1;')
m('fill-single-column-test', 'predicate', '(all != 0 || (col == c && row == r))', '(all != 0 || (col == c))')
m('fill-single-row-test', 'predicate', '(all != 0 || (col == c && row == r))', '(all != 0 || (row == r))')
m('fill-single-either', 'predicate', '(all != 0 || (col == c && row == r))', '(all != 0 || (col == c || row == r))')
m('fill-single-swapped', 'predicate', '(all != 0 || (col == c && row == r))', '(all != 0 || (col == r && row == c))')
m('fill-all-inverted', 'predicate', '(all != 0 || (col == c && row == r))', '(all == 0 || (col == c && row == r))')
m('fill-rand-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_RAND, value, 0);', '(void)0;')
m('fill-kind-store-skipped', 'missing-effect', 'ob16(o, cell_at(r, c) + CELL_KIND, kind);\n            if (!have_view)', 'if (!have_view)')
m('fill-present-skipped', 'missing-effect', 'o->b[cell_at(r, c) + CELL_PRESENT] = 1;\n            o->b[cell_at(r, c) + CELL_MATCHED] = 0;', 'o->b[cell_at(r, c) + CELL_MATCHED] = 0;')
m('fill-matched-kept', 'missing-effect', 'o->b[cell_at(r, c) + CELL_MATCHED] = 0;\n        }', '(void)0;\n        }')
m('fill-view-every-cell', 'order', 'if (!have_view) {', 'if (1) {')
m('fill-rect-skipped', 'missing-effect', 'cell_rect(o, body, r, c, view);\n            o->b[cell_at(r, c) + CELL_PRESENT] = 1;', 'o->b[cell_at(r, c) + CELL_PRESENT] = 1;')
m('fill-col-major', 'order', 'for (r = 0; r < rows; ++r) {\n        for (c = 0; c < cols; ++c) {\n            int16_t kind = 0;', 'for (c = 0; c < cols; ++c) {\n        for (r = 0; r < rows; ++r) {\n            int16_t kind = 0;')
# ---- CheckForMatch 0x4763b3
m('match-up-bound', 'compare', 'if (rmin == 0) break;', 'if (rmin == 1) break;')
m('match-down-bound', 'compare', 'if (rmax == rows - 1) break;', 'if (rmax == rows) break;')
m('match-left-bound', 'compare', 'if (cmin == 0) break;', 'if (cmin == 1) break;')
m('match-right-bound', 'compare', 'if (cmax == cols - 1) break;', 'if (cmax == cols) break;')
m('match-down-bound-cols', 'compare', 'if (rmax == rows - 1) break;', 'if (rmax == cols - 1) break;')
m('match-right-bound-rows', 'compare', 'if (cmax == cols - 1) break;', 'if (cmax == rows - 1) break;')
m('match-up-compare-cell', 'rect', 'if (kind != e4r_rd16(o, cell_at(rmin, col) + CELL_KIND)) { ++rmin; break; }', 'if (kind != e4r_rd16(o, cell_at(rmin, cmin) + CELL_KIND)) { ++rmin; break; }')
m('match-left-compare-cell', 'rect', 'if (kind != e4r_rd16(o, cell_at(row, cmin) + CELL_KIND)) { ++cmin; break; }', 'if (kind != e4r_rd16(o, cell_at(rmin, cmin) + CELL_KIND)) { ++cmin; break; }')
m('match-down-no-step-back', 'missing-effect', '{ --rmax; break; }', '{ break; }')
m('match-up-no-step-back', 'missing-effect', '{ ++rmin; break; }', '{ break; }')
m('match-left-no-step-back', 'missing-effect', '{ ++cmin; break; }', '{ break; }')
m('match-right-no-step-back', 'missing-effect', '{ --cmax; break; }', '{ break; }')
m('match-run-row-min-store', 'missing-effect', 'ob16(o, E4R_O_RUN_ROW_MIN, rmin);\n', '')
m('match-run-row-max-store', 'missing-effect', 'ob16(o, E4R_O_RUN_ROW_MAX, rmax);\n', '')
m('match-run-col-min-store', 'missing-effect', 'ob16(o, E4R_O_RUN_COL_MIN, cmin);\n', '')
m('match-run-col-max-store', 'missing-effect', 'ob16(o, E4R_O_RUN_COL_MAX, cmax);\n', '')
m('match-flags-not-cleared-col', 'missing-effect', 'o->b[E4R_O_MATCH_COL] = 0;\n    o->b[E4R_O_MATCH_ROW] = 0;\n    for (;;) {', 'o->b[E4R_O_MATCH_ROW] = 0;\n    for (;;) {')
m('match-flags-not-cleared-row', 'missing-effect', 'o->b[E4R_O_MATCH_COL] = 0;\n    o->b[E4R_O_MATCH_ROW] = 0;\n    for (;;) {', 'o->b[E4R_O_MATCH_COL] = 0;\n    for (;;) {')
m('match-vertical-threshold', 'compare', 'if ((int32_t)rmax - (int32_t)rmin > 1) {', 'if ((int32_t)rmax - (int32_t)rmin > 2) {')
m('match-vertical-threshold-low', 'compare', 'if ((int32_t)rmax - (int32_t)rmin > 1) {', 'if ((int32_t)rmax - (int32_t)rmin > 0) {')
m('match-horizontal-threshold', 'compare', 'if ((int32_t)cmax - (int32_t)cmin > 1) {', 'if ((int32_t)cmax - (int32_t)cmin > 2) {')
m('match-horizontal-threshold-low', 'compare', 'if ((int32_t)cmax - (int32_t)cmin > 1) {', 'if ((int32_t)cmax - (int32_t)cmin > 0) {')
m('match-vertical-flag', 'missing-effect', 'o->b[E4R_O_MATCH_COL] = 1;\n', '')
m('match-horizontal-flag', 'missing-effect', 'o->b[E4R_O_MATCH_ROW] = 1;\n', '')
m('match-vertical-marks-end-open', 'loop-bound', 'for (r = rmin; r <= rmax; ++r) {', 'for (r = rmin; r < rmax; ++r) {')
m('match-horizontal-marks-end-open', 'loop-bound', 'for (c = cmin; c <= cmax; ++c) {', 'for (c = cmin; c < cmax; ++c) {')
m('match-vertical-marks-start', 'loop-bound', 'for (r = rmin; r <= rmax; ++r) {', 'for (r = rmin + 1; r <= rmax; ++r) {')
m('match-vertical-mark-column', 'rect', 'o->b[cell_at(r, col) + CELL_MATCHED] = 1;', 'o->b[cell_at(r, cmin) + CELL_MATCHED] = 1;')
m('match-horizontal-mark-row', 'rect', 'o->b[cell_at(row, c) + CELL_MATCHED] = 1;', 'o->b[cell_at(rmin, c) + CELL_MATCHED] = 1;')
m('match-vertical-per-piece-field', 'rect', 'o->b[cell_at(r, col) + CELL_MATCHED] = 1;\n            ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_PER_PIECE)));',
  'o->b[cell_at(r, col) + CELL_MATCHED] = 1;\n            ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS4_SCORE)));')
m('match-horizontal-per-piece-field', 'rect', 'o->b[cell_at(row, c) + CELL_MATCHED] = 1;\n            ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_PER_PIECE)));',
  'o->b[cell_at(row, c) + CELL_MATCHED] = 1;\n            ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS5_SCORE)));')
m('match-vertical-per-piece-once', 'missing-effect', 'o->b[cell_at(r, col) + CELL_MATCHED] = 1;\n            ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_PER_PIECE)));',
  'o->b[cell_at(r, col) + CELL_MATCHED] = 1;')
m('match-vertical-bonus3-uses-vertical-run', 'predicate', '        if ((int32_t)cmax - (int32_t)cmin == 2) {\n            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS3_TIME), 1000)));\n        } else if ((int32_t)rmax - (int32_t)rmin == 3) {',
  '        if ((int32_t)rmax - (int32_t)rmin == 2) {\n            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS3_TIME), 1000)));\n        } else if ((int32_t)rmax - (int32_t)rmin == 3) {')
m('match-vertical-bonus3-time-field', 'rect', '        if ((int32_t)cmax - (int32_t)cmin == 2) {\n            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS3_TIME), 1000)));\n        } else if ((int32_t)rmax - (int32_t)rmin == 3) {',
  '        if ((int32_t)cmax - (int32_t)cmin == 2) {\n            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS4_TIME), 1000)));\n        } else if ((int32_t)rmax - (int32_t)rmin == 3) {')
m('match-horizontal-bonus3-time-field', 'rect', '        if ((int32_t)cmax - (int32_t)cmin == 2) {\n            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS3_TIME), 1000)));\n        } else if ((int32_t)cmax - (int32_t)cmin == 3) {',
  '        if ((int32_t)cmax - (int32_t)cmin == 2) {\n            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS5_TIME), 1000)));\n        } else if ((int32_t)cmax - (int32_t)cmin == 3) {')
m('match-bonus3-time-factor-vertical', 'constant', 'wrap_mul(bs16(body, B_BONUS3_TIME), 1000)', 'wrap_mul(bs16(body, B_BONUS3_TIME), 100)', 2, 0)
m('match-bonus3-time-factor-horizontal', 'constant', 'wrap_mul(bs16(body, B_BONUS3_TIME), 1000)', 'wrap_mul(bs16(body, B_BONUS3_TIME), 100)', 2, 1)
m('match-bonus4-time-factor-vertical', 'constant', 'wrap_mul(bs16(body, B_BONUS4_TIME), 1000)', 'wrap_mul(bs16(body, B_BONUS4_TIME), 100)', 2, 0)
m('match-bonus4-time-factor-horizontal', 'constant', 'wrap_mul(bs16(body, B_BONUS4_TIME), 1000)', 'wrap_mul(bs16(body, B_BONUS4_TIME), 100)', 2, 1)
m('match-bonus5-time-factor-vertical', 'constant', 'wrap_mul(bs16(body, B_BONUS5_TIME), 1000)', 'wrap_mul(bs16(body, B_BONUS5_TIME), 100)', 2, 0)
m('match-bonus5-time-factor-horizontal', 'constant', 'wrap_mul(bs16(body, B_BONUS5_TIME), 1000)', 'wrap_mul(bs16(body, B_BONUS5_TIME), 100)', 2, 1)
m('match-bonus4-score-vertical', 'missing-effect', 'ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS4_SCORE)));', '(void)0;', 2, 0)
m('match-bonus4-score-horizontal', 'missing-effect', 'ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS4_SCORE)));', '(void)0;', 2, 1)
m('match-bonus5-score-vertical', 'missing-effect', 'ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS5_SCORE)));', '(void)0;', 2, 0)
m('match-bonus5-score-horizontal', 'missing-effect', 'ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS5_SCORE)));', '(void)0;', 2, 1)
m('match-bonus4-score-field-vertical', 'rect', 'wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS4_SCORE))', 'wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS5_SCORE))', 2, 0)
m('match-bonus5-score-field-horizontal', 'rect', 'wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS5_SCORE))', 'wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS4_SCORE))', 2, 1)
m('match-vertical-bonus4-run', 'compare', '} else if ((int32_t)rmax - (int32_t)rmin == 3) {', '} else if ((int32_t)rmax - (int32_t)rmin >= 3) {')
m('match-vertical-bonus5-run', 'compare', '} else if ((int32_t)rmax - (int32_t)rmin == 4) {', '} else if ((int32_t)rmax - (int32_t)rmin >= 4) {')
m('match-horizontal-bonus4-run', 'compare', '} else if ((int32_t)cmax - (int32_t)cmin == 3) {', '} else if ((int32_t)cmax - (int32_t)cmin >= 3) {')
m('match-horizontal-bonus5-run', 'compare', '} else if ((int32_t)cmax - (int32_t)cmin == 4) {', '} else if ((int32_t)cmax - (int32_t)cmin >= 4) {')
m('match-vertical-bonus4-value', 'constant', '} else if ((int32_t)rmax - (int32_t)rmin == 3) {', '} else if ((int32_t)rmax - (int32_t)rmin == 2) {')
m('match-horizontal-bonus5-value', 'constant', '} else if ((int32_t)cmax - (int32_t)cmin == 4) {', '} else if ((int32_t)cmax - (int32_t)cmin == 5) {')
m('match-vertical-text', 'missing-effect', 'set_number_text(o, E4R_O_SCORE_TEXT, score);\n        o->b[E4R_O_SCORE_DIRTY] = 1;\n    }\n    if ((int32_t)cmax', 'o->b[E4R_O_SCORE_DIRTY] = 1;\n    }\n    if ((int32_t)cmax')
m('match-vertical-dirty', 'missing-effect', 'set_number_text(o, E4R_O_SCORE_TEXT, score);\n        o->b[E4R_O_SCORE_DIRTY] = 1;\n    }\n    if ((int32_t)cmax', 'set_number_text(o, E4R_O_SCORE_TEXT, score);\n    }\n    if ((int32_t)cmax')
m('match-horizontal-text', 'missing-effect', 'set_number_text(o, E4R_O_SCORE_TEXT, score);\n        o->b[E4R_O_SCORE_DIRTY] = 1;\n    }\n}', 'o->b[E4R_O_SCORE_DIRTY] = 1;\n    }\n}')
m('match-horizontal-dirty', 'missing-effect', 'set_number_text(o, E4R_O_SCORE_TEXT, score);\n        o->b[E4R_O_SCORE_DIRTY] = 1;\n    }\n}', 'set_number_text(o, E4R_O_SCORE_TEXT, score);\n    }\n}')
m('match-score-text-signed', 'signedness', 'score = (uint32_t)e4r_rd32(o, E4R_O_SCORE);\n        set_number_text(o, E4R_O_SCORE_TEXT, score);\n        o->b[E4R_O_SCORE_DIRTY] = 1;\n    }\n}',
  'score = (uint32_t)e4r_rd32(o, E4R_O_SCORE) & 0x7fffffffu;\n        set_number_text(o, E4R_O_SCORE_TEXT, score);\n        o->b[E4R_O_SCORE_DIRTY] = 1;\n    }\n}')
m('match-score-wrap-saturate', 'signedness', 'static int32_t wrap_add(int32_t a, int32_t b)\n{\n    return (int32_t)((uint32_t)a + (uint32_t)b);',
  'static int32_t wrap_add(int32_t a, int32_t b)\n{\n    if ((int64_t)a + b > 0x7fffffff) return 0x7fffffff;\n    return (int32_t)((uint32_t)a + (uint32_t)b);')
# ---- scene block of phase 2
m('block-scene-test', 'predicate', 'if (bs16(blk, SB_SCENE) != E4R_NO_SCENE) {', 'if (bs16(blk, SB_SCENE) == E4R_NO_SCENE) {')
m('block-scene-field', 'rect', 't.scene = bs16(blk, SB_SCENE);', 't.scene = bs16(blk, SB_W1);')
m('block-word1-field', 'rect', 't.word[0] = bs16(blk, SB_W1);', 't.word[0] = bs16(blk, SB_W2);')
m('block-word2-field', 'rect', 't.word[1] = bs16(blk, SB_W2);', 't.word[1] = bs16(blk, SB_W3);')
m('block-word3-field', 'rect', 't.word[2] = bs16(blk, SB_W3);', 't.word[2] = bs16(blk, SB_W1);')
m('block-dword1-field', 'rect', 't.dword[0] = bs32(blk, SB_D1);', 't.dword[0] = bs32(blk, SB_D2);')
m('block-dword2-field', 'rect', 't.dword[1] = bs32(blk, SB_D2);', 't.dword[1] = bs32(blk, SB_D3);')
m('block-dword3-field', 'rect', 't.dword[2] = bs32(blk, SB_D3);', 't.dword[2] = bs32(blk, SB_D1);')
m('block-start-test', 'predicate', 'world->start_flag_5bb1ca = bs16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = bs16(blk, SB_START) == 1 ? 1 : 0;')
m('block-start-value', 'constant', 'world->start_flag_5bb1ca = bs16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = bs16(blk, SB_START) != 0 ? 1 : 0;')
m('block-start-field', 'rect', 'bs16(blk, SB_START) != 1 ? 1 : 0;', 'bs16(blk, SB_FLAG) != 1 ? 1 : 0;')
m('block-start-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_START_FLAG, world->start_flag_5bb1ca, 0);\n        fx(host, E4R_FX_ENGINE_MODE, 4, 0);', 'fx(host, E4R_FX_ENGINE_MODE, 4, 0);')
m('block-mode-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_ENGINE_MODE, 4, 0);', '(void)0;')
m('block-mode-fx-value', 'constant', 'fx(host, E4R_FX_ENGINE_MODE, 4, 0);', 'fx(host, E4R_FX_ENGINE_MODE, 3, 0);')
m('block-transition-fx-scene-dropped', 'missing-effect', 'fx(host, E4R_FX_XFER_5BB57B, t.scene, 0);\n', '')
m('block-transition-fx-order', 'order', 'fx(host, E4R_FX_XFER_5BB599, t.word[0], 0);\n        fx(host, E4R_FX_XFER_5BB595, t.word[1], 0);', 'fx(host, E4R_FX_XFER_5BB595, t.word[1], 0);\n        fx(host, E4R_FX_XFER_5BB599, t.word[0], 0);')
m('block-flag-test', 'predicate', 'if (flag != E4R_NO_FLAG) {', 'if (flag == E4R_NO_FLAG) {')
m('block-flag-value-field', 'rect', 'blk[SB_VALUE]));\n            fx(host, E4R_FX_EVENT_FLAG, flag, blk[SB_VALUE]);', 'blk[SB_VALUE + 1]));\n            fx(host, E4R_FX_EVENT_FLAG, flag, blk[SB_VALUE]);')
m('block-flag-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_EVENT_FLAG, flag, blk[SB_VALUE]);', '(void)0;')
m('block-flag-field', 'rect', 'const int16_t flag = bs16(blk, SB_FLAG);', 'const int16_t flag = bs16(blk, SB_START);')
m('block-flag-before-scene', 'order', '    {\n        const int16_t flag = bs16(blk, SB_FLAG);', '    if (bs16(blk, SB_SCENE) == E4R_NO_SCENE) return E4R_OK;\n    {\n        const int16_t flag = bs16(blk, SB_FLAG);')
# ---- effect records of the helpers
m('tick-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_TICK, (int32_t)t, 0);', '(void)0;')
m('busy-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_SOUND_BUSY, channel, *result);', '(void)0;')
m('busy-fx-result', 'constant', 'fx(host, E4R_FX_SOUND_BUSY, channel, *result);', 'fx(host, E4R_FX_SOUND_BUSY, channel, 0);')
m('play-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_SOUND_PLAY, channel, 0);', '(void)0;')
m('prepare-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_SOUND_PREPARE, (int32_t)off, 0);', '(void)0;')
m('stop-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_SOUND_STOP, (int32_t)off, 0);', '(void)0;')
m('stop-fx-offset', 'constant', 'fx(host, E4R_FX_SOUND_STOP, (int32_t)off, 0);', 'fx(host, E4R_FX_SOUND_STOP, (int32_t)off + 1, 0);')
# ---- phase 0
m('p0-row-store', 'missing-effect', 'ob16(o, E4R_O_ROW, row);\n    ob32(o, E4R_O_ACTIVE, 1);', 'ob32(o, E4R_O_ACTIVE, 1);')
m('p0-active-store', 'missing-effect', 'ob32(o, E4R_O_ACTIVE, 1);\n    world->start_flag_5bb1ca = 1;', 'world->start_flag_5bb1ca = 1;')
m('p0-start-flag', 'missing-effect', 'world->start_flag_5bb1ca = 1;\n    fx(host, E4R_FX_START_FLAG, 1, 0);\n    HOST(host->stop_ambient', 'fx(host, E4R_FX_START_FLAG, 1, 0);\n    HOST(host->stop_ambient')
m('p0-start-flag-fx', 'missing-effect', 'fx(host, E4R_FX_START_FLAG, 1, 0);\n    HOST(host->stop_ambient', 'HOST(host->stop_ambient')
m('p0-ambient-stop-fx', 'missing-effect', 'fx(host, E4R_FX_AMBIENT_STOP, 0, 0);', '(void)0;')
m('p0-ambient-after-fill', 'order', '    HOST(host->stop_ambient(host->context));\n    fx(host, E4R_FX_AMBIENT_STOP, 0, 0);\n    rc = fill(o, body, 1, 0, 0, host);\n    if (rc != E4R_OK) return rc;\n',
  '    rc = fill(o, body, 1, 0, 0, host);\n    if (rc != E4R_OK) return rc;\n    HOST(host->stop_ambient(host->context));\n    fx(host, E4R_FX_AMBIENT_STOP, 0, 0);\n')
m('p0-fill-skipped', 'missing-effect', '    rc = fill(o, body, 1, 0, 0, host);\n    if (rc != E4R_OK) return rc;\n\n    HOST(host->alloc_slot', '    HOST(host->alloc_slot')
m('p0-slot-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_SLOT, slot, 0);', '(void)0;')
m('p0-slot-store', 'missing-effect', 'ob16(o, E4R_O_SLOT, slot);\n    HOST(host->register_slot', 'HOST(host->register_slot')
m('p0-register-name', 'constant', '"MATCH PUZZLE OVERLAYS"', '"MATCH PUZZLE OVERLAY"')
m('p0-register-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_SLOT_REGISTER, slot, 0);', '(void)0;')
m('p0-surface-always-load', 'predicate', 'if (e4r_rd32(o, E4R_O_SURFACE) == 0) {', 'if (1) {')
m('p0-surface-never-load', 'predicate', 'if (e4r_rd32(o, E4R_O_SURFACE) == 0) {', 'if (0) {')
m('p0-surface-name', 'rect', 'host->load_surface(host->context, 0, (const char *)body, &surface)', 'host->load_surface(host->context, 0, (const char *)body + B_SCORE_NAME, &surface)')
m('p0-surface-kind', 'constant', 'host->load_surface(host->context, 0, (const char *)body, &surface)', 'host->load_surface(host->context, 1, (const char *)body, &surface)')
m('p0-surface-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_SURFACE_LOAD, 0, (int32_t)surface);', '(void)0;')
m('p0-surface-store', 'missing-effect', 'ob32(o, E4R_O_SURFACE, (int32_t)surface);\n    }', '(void)0;\n    }')
m('p0-slot-surface-fx', 'missing-effect', 'fx(host, E4R_FX_SLOT_SURFACE, slot, e4r_rd32(o, E4R_O_SURFACE));', '(void)0;')
m('p0-score-surface-always', 'predicate', 'if (e4r_rd32(o, E4R_O_SCORE_SURFACE) == 0 && body[B_SCORE_NAME] != 0) {', 'if (body[B_SCORE_NAME] != 0) {')
m('p0-score-surface-name-test', 'predicate', 'if (e4r_rd32(o, E4R_O_SCORE_SURFACE) == 0 && body[B_SCORE_NAME] != 0) {', 'if (e4r_rd32(o, E4R_O_SCORE_SURFACE) == 0) {')
m('p0-score-surface-name-inverted', 'predicate', 'if (e4r_rd32(o, E4R_O_SCORE_SURFACE) == 0 && body[B_SCORE_NAME] != 0) {', 'if (e4r_rd32(o, E4R_O_SCORE_SURFACE) == 0 && body[B_SCORE_NAME] == 0) {')
m('p0-score-surface-name-field', 'rect', 'host->load_surface(host->context, 1, (const char *)body + B_SCORE_NAME, &surface)', 'host->load_surface(host->context, 1, (const char *)body, &surface)')
m('p0-score-surface-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_SURFACE_LOAD, 1, (int32_t)surface);', '(void)0;')
m('p0-score-surface-store', 'missing-effect', 'ob32(o, E4R_O_SCORE_SURFACE, (int32_t)surface);', '(void)0;')
m('p0-sound-a-test', 'predicate', 'if (!no_sound(body + B_SOUND_A)) {\n        rc = prepare_sound(host, body, B_SOUND_A);', 'if (no_sound(body + B_SOUND_A)) {\n        rc = prepare_sound(host, body, B_SOUND_A);')
m('p0-sound-b-test', 'predicate', 'if (!no_sound(body + B_SOUND_B)) {\n        rc = prepare_sound(host, body, B_SOUND_B);', 'if (no_sound(body + B_SOUND_B)) {\n        rc = prepare_sound(host, body, B_SOUND_B);')
m('p0-sound-c-test', 'predicate', 'if (!no_sound(body + B_SOUND_C)) {\n        rc = prepare_sound(host, body, B_SOUND_C);', 'if (no_sound(body + B_SOUND_C)) {\n        rc = prepare_sound(host, body, B_SOUND_C);')
m('p0-sound-a-record', 'rect', 'rc = prepare_sound(host, body, B_SOUND_A);', 'rc = prepare_sound(host, body, B_SOUND_B);')
m('p0-sound-d-prepared', 'missing-effect', '    if (!no_sound(body + B_SOUND_C)) {\n        rc = prepare_sound(host, body, B_SOUND_C);\n        if (rc != E4R_OK) return rc;\n    }\n',
  '    if (!no_sound(body + B_SOUND_C)) {\n        rc = prepare_sound(host, body, B_SOUND_C);\n        if (rc != E4R_OK) return rc;\n    }\n    if (!no_sound(body + B_SOUND_D)) {\n        rc = prepare_sound(host, body, B_SOUND_D);\n        if (rc != E4R_OK) return rc;\n    }\n')
m('p0-no-selection', 'constant', 'ob32(o, E4R_O_NO_SELECTION, 1);\n    o->b[E4R_O_CHECK_FIRST] = 0;', 'ob32(o, E4R_O_NO_SELECTION, 0);\n    o->b[E4R_O_CHECK_FIRST] = 0;')
m('p0-check-first', 'missing-effect', 'o->b[E4R_O_CHECK_FIRST] = 0;\n    o->b[E4R_O_CHECK_SECOND] = 0;\n    o->b[E4R_O_SHOW_NAME] = 0;', 'o->b[E4R_O_CHECK_SECOND] = 0;\n    o->b[E4R_O_SHOW_NAME] = 0;')
m('p0-check-second', 'missing-effect', 'o->b[E4R_O_CHECK_SECOND] = 0;\n    o->b[E4R_O_SHOW_NAME] = 0;', 'o->b[E4R_O_SHOW_NAME] = 0;')
m('p0-show-name', 'missing-effect', 'o->b[E4R_O_SHOW_NAME] = 0;\n    o->b[E4R_O_NAME_DIRTY] = 1;\n    o->b[E4R_O_SCORE_DIRTY] = 0;', 'o->b[E4R_O_NAME_DIRTY] = 1;\n    o->b[E4R_O_SCORE_DIRTY] = 0;')
m('p0-name-dirty', 'constant', 'o->b[E4R_O_NAME_DIRTY] = 1;\n    o->b[E4R_O_SCORE_DIRTY] = 0;', 'o->b[E4R_O_NAME_DIRTY] = 0;\n    o->b[E4R_O_SCORE_DIRTY] = 0;')
m('p0-score-dirty', 'constant', 'o->b[E4R_O_SCORE_DIRTY] = 0;\n    o->b[E4R_O_ERASE_ALL] = 0;', 'o->b[E4R_O_SCORE_DIRTY] = 1;\n    o->b[E4R_O_ERASE_ALL] = 0;')
m('p0-erase-all', 'constant', 'o->b[E4R_O_ERASE_ALL] = 0;\n    o->b[E4R_O_MATCH_COL] = 0;\n    o->b[E4R_O_MATCH_ROW] = 0;\n    o->b[E4R_O_SHUFFLE_DOWN] = 0;',
  'o->b[E4R_O_ERASE_ALL] = 1;\n    o->b[E4R_O_MATCH_COL] = 0;\n    o->b[E4R_O_MATCH_ROW] = 0;\n    o->b[E4R_O_SHUFFLE_DOWN] = 0;')
m('p0-match-col', 'missing-effect', 'o->b[E4R_O_MATCH_COL] = 0;\n    o->b[E4R_O_MATCH_ROW] = 0;\n    o->b[E4R_O_SHUFFLE_DOWN] = 0;', 'o->b[E4R_O_MATCH_ROW] = 0;\n    o->b[E4R_O_SHUFFLE_DOWN] = 0;')
m('p0-match-row', 'missing-effect', 'o->b[E4R_O_MATCH_ROW] = 0;\n    o->b[E4R_O_SHUFFLE_DOWN] = 0;', 'o->b[E4R_O_SHUFFLE_DOWN] = 0;')
m('p0-shuffle-down', 'missing-effect', 'o->b[E4R_O_SHUFFLE_DOWN] = 0;\n    o->b[E4R_O_SHUFFLE_DIRTY] = 0;\n    ob32(o, E4R_O_SCORE, 0);', 'o->b[E4R_O_SHUFFLE_DIRTY] = 0;\n    ob32(o, E4R_O_SCORE, 0);')
m('p0-shuffle-dirty', 'constant', 'o->b[E4R_O_SHUFFLE_DIRTY] = 0;\n    ob32(o, E4R_O_SCORE, 0);', 'o->b[E4R_O_SHUFFLE_DIRTY] = 1;\n    ob32(o, E4R_O_SCORE, 0);')
m('p0-score-zero', 'missing-effect', 'ob32(o, E4R_O_SCORE, 0);\n    {\n        const int32_t base', '{\n        const int32_t base')
m('p0-time-factor', 'constant', 'const int32_t base = wrap_mul(bs16(body, B_TIME_LIMIT), 1000);', 'const int32_t base = wrap_mul(bs16(body, B_TIME_LIMIT), 100);')
m('p0-time-field', 'rect', 'const int32_t base = wrap_mul(bs16(body, B_TIME_LIMIT), 1000);', 'const int32_t base = wrap_mul(bs16(body, B_END_DELAY), 1000);')
m('p0-time-end-tick', 'missing-effect', 'ob32(o, E4R_O_TIME_END, wrap_add(base, (int32_t)get_tick(host)));', 'ob32(o, E4R_O_TIME_END, base);')
m('p0-score-text', 'constant', 'set_text(o, E4R_O_SCORE_TEXT, "0");\n    set_text(o, E4R_O_TIME_TEXT, "");\n    set_text(o, E4R_O_NAME_TEXT, "");\n    set_number_text(o, E4R_O_TARGET_TEXT',
  'set_text(o, E4R_O_SCORE_TEXT, "1");\n    set_text(o, E4R_O_TIME_TEXT, "");\n    set_text(o, E4R_O_NAME_TEXT, "");\n    set_number_text(o, E4R_O_TARGET_TEXT')
m('p0-time-text-cleared', 'missing-effect', 'set_text(o, E4R_O_TIME_TEXT, "");\n    set_text(o, E4R_O_NAME_TEXT, "");\n    set_number_text', 'set_text(o, E4R_O_NAME_TEXT, "");\n    set_number_text')
m('p0-name-text-cleared', 'missing-effect', 'set_text(o, E4R_O_NAME_TEXT, "");\n    set_number_text', 'set_number_text')
m('p0-target-text-signed', 'signedness', 'set_number_text(o, E4R_O_TARGET_TEXT, (uint32_t)bs32(body, B_TARGET));', 'set_number_text(o, E4R_O_TARGET_TEXT, (uint32_t)bs32(body, B_TARGET) & 0x7fffffffu);')
m('p0-target-text-field', 'rect', 'set_number_text(o, E4R_O_TARGET_TEXT, (uint32_t)bs32(body, B_TARGET));', 'set_number_text(o, E4R_O_TARGET_TEXT, (uint32_t)bs32(body, B_TARGET + 4));')
m('p0-won', 'constant', 'ob32(o, E4R_O_WON, 0);\n    ob32(o, E4R_O_EXIT, 0);\n    ob32(o, E4R_O_STATE, E4R_STATE_PLAY);\n    fx(host, E4R_FX_PHASE, 1, 0);', 'ob32(o, E4R_O_EXIT, 0);\n    ob32(o, E4R_O_STATE, E4R_STATE_PLAY);\n    fx(host, E4R_FX_PHASE, 1, 0);')
m('p0-exit', 'constant', 'ob32(o, E4R_O_EXIT, 0);\n    ob32(o, E4R_O_STATE, E4R_STATE_PLAY);\n    fx(host, E4R_FX_PHASE, 1, 0);', 'ob32(o, E4R_O_STATE, E4R_STATE_PLAY);\n    fx(host, E4R_FX_PHASE, 1, 0);')
m('p0-state', 'constant', 'ob32(o, E4R_O_STATE, E4R_STATE_PLAY);\n    fx(host, E4R_FX_PHASE, 1, 0);', 'ob32(o, E4R_O_STATE, E4R_STATE_SHUFFLE);\n    fx(host, E4R_FX_PHASE, 1, 0);')
m('p0-phase-fx', 'missing-effect', 'ob32(o, E4R_O_STATE, E4R_STATE_PLAY);\n    fx(host, E4R_FX_PHASE, 1, 0);', 'ob32(o, E4R_O_STATE, E4R_STATE_PLAY);')
m('p0-phase-fx-value', 'constant', 'ob32(o, E4R_O_STATE, E4R_STATE_PLAY);\n    fx(host, E4R_FX_PHASE, 1, 0);', 'ob32(o, E4R_O_STATE, E4R_STATE_PLAY);\n    fx(host, E4R_FX_PHASE, 2, 0);')
m('step-phase0-after', 'constant', 'after = 1;\n        result->initialized = 1;', 'after = 0;\n        result->initialized = 1;')
m('step-phase0-initialized', 'missing-effect', 'after = 1;\n        result->initialized = 1;', 'after = 1;')
# ---- refill start
m('refill-state', 'constant', 'ob32(o, E4R_O_STATE, E4R_STATE_REFILL);\n    ob32(o, E4R_O_DEADLINE', 'ob32(o, E4R_O_STATE, E4R_STATE_SHUFFLE);\n    ob32(o, E4R_O_DEADLINE')
m('refill-deadline-delay', 'constant', 'wrap_add((int32_t)get_tick(host), 800)', 'wrap_add((int32_t)get_tick(host), 799)')
m('refill-name-from-kind', 'rect', 'set_text_bytes(o, E4R_O_NAME_TEXT, body + B_KIND_NAME + (size_t)kind * E4R_NAME_BYTES);', 'set_text_bytes(o, E4R_O_NAME_TEXT, body + B_KIND_NAME);')
m('refill-name-stride', 'rect', 'body + B_KIND_NAME + (size_t)kind * E4R_NAME_BYTES);', 'body + B_KIND_NAME + (size_t)kind * (E4R_NAME_BYTES - 1));')
m('refill-icon-from-kind', 'rect', 'memcpy(o->b + E4R_O_ICON_RECT, body + B_PIECE_RECT + (size_t)kind * 16u, 16u);', 'memcpy(o->b + E4R_O_ICON_RECT, body + B_PIECE_RECT, 16u);')
m('refill-icon-copy-short', 'rect', 'body + B_PIECE_RECT + (size_t)kind * 16u, 16u);', 'body + B_PIECE_RECT + (size_t)kind * 16u, 12u);')
m('refill-show-name', 'missing-effect', 'o->b[E4R_O_SHOW_NAME] = 1;\n    return E4R_OK;', 'return E4R_OK;')
m('refill-kind-from-cell', 'rect', 'const int16_t kind = e4r_rd16(o, cell_at(row, col) + CELL_KIND);\n    ob32(o, E4R_O_STATE, E4R_STATE_REFILL);', 'const int16_t kind = e4r_rd16(o, cell_at(col, row) + CELL_KIND);\n    ob32(o, E4R_O_STATE, E4R_STATE_REFILL);')
# ---- phase 1, state 0
m('p1-state-guard', 'compare', 'if ((uint32_t)state > 6u) return E4R_OK;', 'if ((uint32_t)state > 7u) return E4R_OK;')
m('p1-state-guard-signed', 'signedness', 'if ((uint32_t)state > 6u) return E4R_OK;', 'if (state > 6) return E4R_OK;')
m('p1-first-check-order', 'order', '        if (o->b[E4R_O_CHECK_FIRST] != 0) {\n            check_match', '        if (o->b[E4R_O_CHECK_SECOND] == 0 && o->b[E4R_O_CHECK_FIRST] != 0) {\n            check_match')
m('p1-first-uses-swap-cell', 'rect', 'check_match(o, body, e4r_rd32(o, E4R_O_SEL_COL), e4r_rd32(o, E4R_O_SEL_ROW));', 'check_match(o, body, e4r_rd32(o, E4R_O_SWAP_COL), e4r_rd32(o, E4R_O_SWAP_ROW));')
m('p1-second-uses-sel-cell', 'rect', 'check_match(o, body, e4r_rd32(o, E4R_O_SWAP_COL), e4r_rd32(o, E4R_O_SWAP_ROW));', 'check_match(o, body, e4r_rd32(o, E4R_O_SEL_COL), e4r_rd32(o, E4R_O_SEL_ROW));')
m('p1-first-match-both-flags', 'predicate', 'if (o->b[E4R_O_MATCH_COL] != 0 || o->b[E4R_O_MATCH_ROW] != 0) {\n                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SEL_ROW)',
  'if (o->b[E4R_O_MATCH_COL] != 0 && o->b[E4R_O_MATCH_ROW] != 0) {\n                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SEL_ROW)')
m('p1-first-match-col-only', 'predicate', 'if (o->b[E4R_O_MATCH_COL] != 0 || o->b[E4R_O_MATCH_ROW] != 0) {\n                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SEL_ROW)',
  'if (o->b[E4R_O_MATCH_COL] != 0) {\n                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SEL_ROW)')
m('p1-first-match-row-only', 'predicate', 'if (o->b[E4R_O_MATCH_COL] != 0 || o->b[E4R_O_MATCH_ROW] != 0) {\n                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SEL_ROW)',
  'if (o->b[E4R_O_MATCH_ROW] != 0) {\n                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SEL_ROW)')
m('p1-second-match-col-only', 'predicate', 'if (o->b[E4R_O_MATCH_COL] != 0 || o->b[E4R_O_MATCH_ROW] != 0) {\n                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SWAP_ROW)',
  'if (o->b[E4R_O_MATCH_COL] != 0) {\n                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SWAP_ROW)')
m('p1-second-match-row-only', 'predicate', 'if (o->b[E4R_O_MATCH_COL] != 0 || o->b[E4R_O_MATCH_ROW] != 0) {\n                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SWAP_ROW)',
  'if (o->b[E4R_O_MATCH_ROW] != 0) {\n                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SWAP_ROW)')
m('p1-second-refill-cell', 'rect', 'rc = start_refill(o, body, e4r_rd32(o, E4R_O_SWAP_ROW), e4r_rd32(o, E4R_O_SWAP_COL), host);', 'rc = start_refill(o, body, e4r_rd32(o, E4R_O_SEL_ROW), e4r_rd32(o, E4R_O_SEL_COL), host);')
m('p1-first-refill-cell', 'rect', 'rc = start_refill(o, body, e4r_rd32(o, E4R_O_SEL_ROW), e4r_rd32(o, E4R_O_SEL_COL), host);', 'rc = start_refill(o, body, e4r_rd32(o, E4R_O_SWAP_ROW), e4r_rd32(o, E4R_O_SWAP_COL), host);')
m('p1-first-flag-kept', 'missing-effect', 'o->b[E4R_O_CHECK_FIRST] = 0;\n        } else if', '(void)0;\n        } else if')
m('p1-second-flag-kept', 'missing-effect', 'o->b[E4R_O_CHECK_SECOND] = 0;\n        } else {', '(void)0;\n        } else {')
m('p1-first-clears-second', 'predicate', 'o->b[E4R_O_CHECK_FIRST] = 0;\n        } else if', 'o->b[E4R_O_CHECK_FIRST] = 0;\n            o->b[E4R_O_CHECK_SECOND] = 0;\n        } else if')
m('p1-first-flag-only-on-match', 'predicate', 'o->b[E4R_O_CHECK_FIRST] = 0;\n        } else if', 'if (o->b[E4R_O_STATE] == 0) o->b[E4R_O_CHECK_FIRST] = 0;\n        } else if')
m('p1-time-text-limit-test', 'predicate', 'if (limit != 0) {\n                char buf[24];', 'if (limit > 0) {\n                char buf[24];')
m('p1-time-text-always', 'predicate', 'if (limit != 0) {\n                char buf[24];', 'if (1) {\n                char buf[24];')
m('p1-time-text-format', 'constant', '"%2dm %2ds"', '"%2dm%2ds"')
m('p1-time-text-minutes', 'constant', '(int)((left / 60000u) % 60u)', '(int)((left / 60000u) % 100u)')
m('p1-time-text-minutes-div', 'constant', '(int)((left / 60000u) % 60u)', '(int)((left / 6000u) % 60u)')
m('p1-time-text-seconds', 'constant', '(int)((left / 1000u) % 60u)', '(int)((left / 1000u) % 100u)')
m('p1-time-text-seconds-div', 'constant', '(int)((left / 1000u) % 60u)', '(int)((left / 100u) % 60u)')
m('p1-time-left-signed', 'signedness', 'const uint32_t left = (uint32_t)e4r_rd32(o, E4R_O_TIME_END) - now;', 'const uint32_t left = (uint32_t)(int32_t)((int32_t)e4r_rd32(o, E4R_O_TIME_END) - (int32_t)now) & 0x7fffffffu;')
m('p1-time-left-source', 'rect', 'const uint32_t left = (uint32_t)e4r_rd32(o, E4R_O_TIME_END) - now;', 'const uint32_t left = (uint32_t)e4r_rd32(o, E4R_O_DEADLINE) - now;')
m('p1-time-expired-bound', 'compare', '(limit > 0 && left < 500u)', '(limit > 0 && left < 501u)')
m('p1-time-expired-bound-low', 'compare', '(limit > 0 && left < 500u)', '(limit > 0 && left < 499u)')
m('p1-time-expired-le', 'compare', '(limit > 0 && left < 500u)', '(limit > 0 && left <= 500u)')
m('p1-time-expired-signed', 'signedness', '(limit > 0 && left < 500u)', '(limit > 0 && (int32_t)left < 500)')
m('p1-time-expired-limit-zero', 'predicate', '(limit > 0 && left < 500u)', '(limit >= 0 && left < 500u)')
m('p1-time-expired-limit-ne', 'predicate', '(limit > 0 && left < 500u)', '(limit != 0 && left < 500u)')
m('p1-time-expired-ignores-limit', 'predicate', '(limit > 0 && left < 500u)', '(left < 500u)')
m('p1-target-reached-gt', 'compare', '|| score >= target) {\n                ob32(o, E4R_O_STATE, E4R_STATE_END);', '|| score > target) {\n                ob32(o, E4R_O_STATE, E4R_STATE_END);')
m('p1-target-reached-unsigned', 'signedness', '|| score >= target) {\n                ob32(o, E4R_O_STATE, E4R_STATE_END);', '|| (uint32_t)score >= (uint32_t)target) {\n                ob32(o, E4R_O_STATE, E4R_STATE_END);')
m('p1-target-win-gt', 'compare', 'if (score >= target) {\n                    set_text(o, E4R_O_TIME_TEXT, "WIN!!!");', 'if (score > target) {\n                    set_text(o, E4R_O_TIME_TEXT, "WIN!!!");')
m('p1-target-win-unsigned', 'signedness', 'if (score >= target) {\n                    set_text(o, E4R_O_TIME_TEXT, "WIN!!!");', 'if ((uint32_t)score >= (uint32_t)target) {\n                    set_text(o, E4R_O_TIME_TEXT, "WIN!!!");')
m('p1-win-text', 'constant', 'set_text(o, E4R_O_TIME_TEXT, "WIN!!!");', 'set_text(o, E4R_O_TIME_TEXT, "WIN!!");')
m('p1-time-text', 'constant', 'set_text(o, E4R_O_TIME_TEXT, "TIME!");', 'set_text(o, E4R_O_TIME_TEXT, "TIME");')
m('p1-won-store', 'missing-effect', 'ob32(o, E4R_O_WON, 1);\n                } else {', '(void)0;\n                } else {')
m('p1-end-state', 'constant', 'ob32(o, E4R_O_STATE, E4R_STATE_END);\n                if (score', 'ob32(o, E4R_O_STATE, E4R_STATE_END_WAIT);\n                if (score')
m('p1-play-tick-once', 'order', 'const uint32_t now = get_tick(host);\n            const uint32_t left', 'const uint32_t now = (get_tick(host), get_tick(host));\n            const uint32_t left')
# ---- states 1..6
m('end-sound-test', 'predicate', 'if (!no_sound(body + B_SOUND_D)) {\n            rc = prepare_sound(host, body, B_SOUND_D);\n            if (rc != E4R_OK) return rc;\n            rc = play',
  'if (no_sound(body + B_SOUND_D)) {\n            rc = prepare_sound(host, body, B_SOUND_D);\n            if (rc != E4R_OK) return rc;\n            rc = play')
m('end-sound-record', 'rect', 'rc = prepare_sound(host, body, B_SOUND_D);', 'rc = prepare_sound(host, body, B_SOUND_C);')
m('end-sound-channel', 'rect', 'rc = play(host, bs16(body, B_CHANNEL_D));\n            if (rc != E4R_OK) return rc;\n        }\n        ob32(o, E4R_O_DEADLINE, wrap_add((int32_t)get_tick(host), wrap_mul(bs16(body, B_FINAL_DELAY)',
  'rc = play(host, bs16(body, B_CHANNEL_C));\n            if (rc != E4R_OK) return rc;\n        }\n        ob32(o, E4R_O_DEADLINE, wrap_add((int32_t)get_tick(host), wrap_mul(bs16(body, B_FINAL_DELAY)')
m('end-sound-play-skipped', 'missing-effect', 'rc = play(host, bs16(body, B_CHANNEL_D));\n            if (rc != E4R_OK) return rc;\n        }\n        ob32(o, E4R_O_DEADLINE', '}\n        ob32(o, E4R_O_DEADLINE')
m('end-final-delay-factor', 'constant', 'wrap_mul(bs16(body, B_FINAL_DELAY), 1000)', 'wrap_mul(bs16(body, B_FINAL_DELAY), 100)')
m('end-final-delay-field', 'rect', 'wrap_mul(bs16(body, B_FINAL_DELAY), 1000)', 'wrap_mul(bs16(body, B_END_DELAY), 1000)')
m('end-next-state', 'constant', 'ob32(o, E4R_O_STATE, E4R_STATE_END_WAIT);\n        break;', 'ob32(o, E4R_O_STATE, E4R_STATE_END_SOUND);\n        break;')
m('end-wait-lt', 'compare', 'if ((uint32_t)e4r_rd32(o, E4R_O_DEADLINE) <= get_tick(host)) ob32(o, E4R_O_STATE, E4R_STATE_END_SOUND);', 'if ((uint32_t)e4r_rd32(o, E4R_O_DEADLINE) < get_tick(host)) ob32(o, E4R_O_STATE, E4R_STATE_END_SOUND);')
m('end-wait-signed', 'signedness', 'if ((uint32_t)e4r_rd32(o, E4R_O_DEADLINE) <= get_tick(host)) ob32(o, E4R_O_STATE, E4R_STATE_END_SOUND);', 'if ((int32_t)e4r_rd32(o, E4R_O_DEADLINE) <= (int32_t)get_tick(host)) ob32(o, E4R_O_STATE, E4R_STATE_END_SOUND);')
m('end-wait-next', 'constant', 'ob32(o, E4R_O_STATE, E4R_STATE_END_SOUND);\n        break;\n    case E4R_STATE_SCORES:', 'ob32(o, E4R_O_STATE, E4R_STATE_SCORES);\n        break;\n    case E4R_STATE_SCORES:')
m('end-sound-busy-channel', 'rect', 'rc = busy(host, bs16(body, B_CHANNEL_D), &b);', 'rc = busy(host, bs16(body, B_CHANNEL_C), &b);')
m('end-sound-stop-inverted', 'predicate', 'if (b == 0) {\n            rc = stop_sound(host, body, B_SOUND_D);', 'if (b != 0) {\n            rc = stop_sound(host, body, B_SOUND_D);')
m('end-sound-stop-always', 'predicate', 'if (b == 0) {\n            rc = stop_sound(host, body, B_SOUND_D);', 'if (1) {\n            rc = stop_sound(host, body, B_SOUND_D);')
m('end-sound-stop-record', 'rect', 'rc = stop_sound(host, body, B_SOUND_D);', 'rc = stop_sound(host, body, B_SOUND_C);')
m('end-sound-delay-factor', 'constant', 'wrap_mul(bs16(body, B_END_DELAY), 1000)', 'wrap_mul(bs16(body, B_END_DELAY), 100)')
m('end-sound-delay-field', 'rect', 'wrap_mul(bs16(body, B_END_DELAY), 1000)', 'wrap_mul(bs16(body, B_FINAL_DELAY), 1000)')
m('end-sound-next', 'constant', 'ob32(o, E4R_O_STATE, E4R_STATE_SCORES);\n        o->b[E4R_O_ERASE_ALL] = 1;\n        break;', 'ob32(o, E4R_O_STATE, E4R_STATE_PLAY);\n        o->b[E4R_O_ERASE_ALL] = 1;\n        break;')
m('end-sound-erase', 'missing-effect', 'o->b[E4R_O_ERASE_ALL] = 1;\n        break;\n    }', 'break;\n    }')
m('refill-wait-unsigned', 'signedness', 'int wait = unsigned_before(now, (uint32_t)e4r_rd32(o, E4R_O_DEADLINE));', 'int wait = (int32_t)now < (int32_t)e4r_rd32(o, E4R_O_DEADLINE);')
m('refill-wait-le', 'compare', 'static int unsigned_before(uint32_t a, uint32_t b) { return a < b; }', 'static int unsigned_before(uint32_t a, uint32_t b) { return a <= b; }')
m('refill-busy-skipped-when-early', 'predicate', 'if (!wait) {\n            rc = busy(host, bs16(body, B_CHANNEL_A), &b1);', 'if (1) {\n            rc = busy(host, bs16(body, B_CHANNEL_A), &b1);')
m('refill-busy1-channel', 'rect', 'rc = busy(host, bs16(body, B_CHANNEL_A), &b1);', 'rc = busy(host, bs16(body, B_CHANNEL_B), &b1);')
m('refill-busy1-nonzero', 'predicate', 'wait = b1 != 0;', 'wait = b1 == 0;')
m('refill-busy1-low-byte', 'predicate', 'wait = b1 != 0;', 'wait = (b1 & 0xff) != 0;')
m('refill-busy2-channel', 'rect', 'rc = busy(host, bs16(body, B_CHANNEL_A), &b2);', 'rc = busy(host, bs16(body, B_CHANNEL_B), &b2);')
m('refill-busy2-skipped', 'missing-effect', '            rc = busy(host, bs16(body, B_CHANNEL_A), &b2);\n            if (rc != E4R_OK) return rc;\n            if (b2 == 0) {', '            if (b2 == 0) {')
m('refill-busy2-inverted', 'predicate', 'if (b2 == 0) {', 'if (b2 != 0) {')
m('refill-busy3-channel', 'rect', 'rc = busy(host, bs16(body, B_CHANNEL_A), &b3);', 'rc = busy(host, bs16(body, B_CHANNEL_B), &b3);')
m('refill-busy3-skipped', 'missing-effect', '                rc = busy(host, bs16(body, B_CHANNEL_A), &b3);\n                if (rc != E4R_OK) return rc;\n                if (b3 == 0 &&', '                if (b3 == 0 &&')
m('refill-busy3-inverted', 'predicate', 'if (b3 == 0 && !no_sound(body + B_SOUND_A)) {', 'if (b3 != 0 && !no_sound(body + B_SOUND_A)) {')
m('refill-sound-test', 'predicate', 'if (b3 == 0 && !no_sound(body + B_SOUND_A)) {', 'if (b3 == 0 && no_sound(body + B_SOUND_A)) {')
m('refill-sound-ignored', 'predicate', 'if (b3 == 0 && !no_sound(body + B_SOUND_A)) {', 'if (b3 == 0) {')
m('refill-sound-record', 'rect', 'if (b3 == 0 && !no_sound(body + B_SOUND_A)) {', 'if (b3 == 0 && !no_sound(body + B_SOUND_B)) {')
m('refill-play-channel', 'rect', 'rc = play(host, bs16(body, B_CHANNEL_A));\n                    if (rc != E4R_OK) return rc;\n                }\n            }', 'rc = play(host, bs16(body, B_CHANNEL_B));\n                    if (rc != E4R_OK) return rc;\n                }\n            }')
m('refill-state-after', 'constant', 'ob32(o, E4R_O_STATE, E4R_STATE_PLAY);\n            set_text(o, E4R_O_NAME_TEXT, "");', 'ob32(o, E4R_O_STATE, E4R_STATE_SHUFFLE);\n            set_text(o, E4R_O_NAME_TEXT, "");')
m('refill-name-cleared', 'missing-effect', 'set_text(o, E4R_O_NAME_TEXT, "");\n            o->b[E4R_O_SHOW_NAME] = 0;\n            o->b[E4R_O_NAME_DIRTY] = 1;\n            for (r', 'o->b[E4R_O_SHOW_NAME] = 0;\n            o->b[E4R_O_NAME_DIRTY] = 1;\n            for (r')
m('refill-show-name-kept', 'missing-effect', 'o->b[E4R_O_SHOW_NAME] = 0;\n            o->b[E4R_O_NAME_DIRTY] = 1;\n            for (r', 'o->b[E4R_O_NAME_DIRTY] = 1;\n            for (r')
m('refill-name-dirty', 'missing-effect', 'o->b[E4R_O_NAME_DIRTY] = 1;\n            for (r', 'for (r')
m('refill-matched-test', 'predicate', 'if (o->b[cell_at(r, c) + CELL_MATCHED] == 1) {', 'if (o->b[cell_at(r, c) + CELL_MATCHED] != 0) {')
m('refill-matched-test-present', 'predicate', 'if (o->b[cell_at(r, c) + CELL_MATCHED] == 1) {', 'if (o->b[cell_at(r, c) + CELL_PRESENT] == 1) {')
m('refill-fill-arguments', 'rect', 'rc = fill(o, body, 0, (int16_t)r, (int16_t)c, host);', 'rc = fill(o, body, 0, (int16_t)c, (int16_t)r, host);')
m('refill-col-major', 'order', '            for (r = 0; r < rows; ++r)\n                for (c = 0; c < cols; ++c)\n                    if (o->b[cell_at(r, c) + CELL_MATCHED] == 1) {',
  '            for (c = 0; c < cols; ++c)\n                for (r = 0; r < rows; ++r)\n                    if (o->b[cell_at(r, c) + CELL_MATCHED] == 1) {')
m('shuffle-lt', 'compare', 'if ((uint32_t)e4r_rd32(o, E4R_O_SHUFFLE_END) <= get_tick(host)) {', 'if ((uint32_t)e4r_rd32(o, E4R_O_SHUFFLE_END) < get_tick(host)) {')
m('shuffle-signed', 'signedness', 'if ((uint32_t)e4r_rd32(o, E4R_O_SHUFFLE_END) <= get_tick(host)) {', 'if ((int32_t)e4r_rd32(o, E4R_O_SHUFFLE_END) <= (int32_t)get_tick(host)) {')
m('shuffle-fill-all', 'predicate', 'rc = fill(o, body, 1, 0, 0, host);\n            if (rc != E4R_OK) return rc;\n            o->b[E4R_O_SHUFFLE_DOWN] = 0;', 'rc = fill(o, body, 0, 0, 0, host);\n            if (rc != E4R_OK) return rc;\n            o->b[E4R_O_SHUFFLE_DOWN] = 0;')
m('shuffle-down-kept', 'missing-effect', 'o->b[E4R_O_SHUFFLE_DOWN] = 0;\n            o->b[E4R_O_SHUFFLE_DIRTY] = 1;', 'o->b[E4R_O_SHUFFLE_DIRTY] = 1;')
m('shuffle-dirty-missing', 'missing-effect', 'o->b[E4R_O_SHUFFLE_DIRTY] = 1;\n            ob32(o, E4R_O_STATE, E4R_STATE_PLAY);', 'ob32(o, E4R_O_STATE, E4R_STATE_PLAY);')
m('shuffle-state-after', 'missing-effect', 'o->b[E4R_O_SHUFFLE_DIRTY] = 1;\n            ob32(o, E4R_O_STATE, E4R_STATE_PLAY);', 'o->b[E4R_O_SHUFFLE_DIRTY] = 1;')
m('scores-lt', 'compare', 'if ((uint32_t)e4r_rd32(o, E4R_O_DEADLINE) <= get_tick(host)) {\n            int32_t carry', 'if ((uint32_t)e4r_rd32(o, E4R_O_DEADLINE) < get_tick(host)) {\n            int32_t carry')
m('scores-signed', 'signedness', 'if ((uint32_t)e4r_rd32(o, E4R_O_DEADLINE) <= get_tick(host)) {\n            int32_t carry', 'if ((int32_t)e4r_rd32(o, E4R_O_DEADLINE) <= (int32_t)get_tick(host)) {\n            int32_t carry')
m('scores-insert-ge', 'compare', 'if (carry > world->high_score[i]) {', 'if (carry >= world->high_score[i]) {')
m('scores-insert-unsigned', 'signedness', 'if (carry > world->high_score[i]) {', 'if ((uint32_t)carry > (uint32_t)world->high_score[i]) {')
m('scores-insert-stop-after-first', 'loop-bound', 'carry = displaced;\n                }\n            }', 'carry = displaced;\n                    break;\n                }\n            }')
m('scores-insert-no-carry', 'missing-effect', 'carry = displaced;\n                }\n            }', '(void)displaced;\n                }\n            }')
m('scores-insert-loop-short', 'loop-bound', 'for (i = 0; i < E4R_HIGH_SCORES; ++i) {\n                if (carry > world->high_score[i]) {', 'for (i = 0; i < E4R_HIGH_SCORES - 1; ++i) {\n                if (carry > world->high_score[i]) {')
m('scores-insert-erase', 'missing-effect', 'world->high_score[i] = carry;\n                    o->b[E4R_O_ERASE_ALL] = 1;', 'world->high_score[i] = carry;')
m('scores-insert-source', 'rect', 'int32_t carry = e4r_rd32(o, E4R_O_SCORE);', 'int32_t carry = e4r_rd32(o, E4R_O_SHUFFLE_END);')
m('scores-lost-state', 'constant', 'if (e4r_rd32(o, E4R_O_WON) == 0) {\n                ob32(o, E4R_O_STATE, E4R_STATE_PLAY);', 'if (e4r_rd32(o, E4R_O_WON) == 0) {\n                ob32(o, E4R_O_STATE, E4R_STATE_SHUFFLE);')
m('scores-lost-score', 'missing-effect', 'ob32(o, E4R_O_SCORE, 0);\n                ob32(o, E4R_O_TIME_END, wrap_add(wrap_mul', 'ob32(o, E4R_O_TIME_END, wrap_add(wrap_mul')
m('scores-lost-time-end', 'missing-effect', 'ob32(o, E4R_O_TIME_END, wrap_add(wrap_mul(bs16(body, B_TIME_LIMIT), 1000), (int32_t)get_tick(host)));\n                set_text', 'set_text')
m('scores-lost-time-factor', 'constant', 'wrap_mul(bs16(body, B_TIME_LIMIT), 1000), (int32_t)get_tick(host)));\n                set_text', 'wrap_mul(bs16(body, B_TIME_LIMIT), 100), (int32_t)get_tick(host)));\n                set_text')
m('scores-lost-score-text', 'constant', 'set_text(o, E4R_O_SCORE_TEXT, "0");\n                set_text(o, E4R_O_TIME_TEXT, "");\n                o->b[E4R_O_ERASE_ALL] = 1;', 'set_text(o, E4R_O_SCORE_TEXT, "1");\n                set_text(o, E4R_O_TIME_TEXT, "");\n                o->b[E4R_O_ERASE_ALL] = 1;')
m('scores-lost-time-text', 'missing-effect', 'set_text(o, E4R_O_TIME_TEXT, "");\n                o->b[E4R_O_ERASE_ALL] = 1;', 'o->b[E4R_O_ERASE_ALL] = 1;')
m('scores-lost-erase', 'missing-effect', 'set_text(o, E4R_O_TIME_TEXT, "");\n                o->b[E4R_O_ERASE_ALL] = 1;', 'set_text(o, E4R_O_TIME_TEXT, "");')
m('scores-won-phase', 'missing-effect', '            } else {\n                *phase = 2;\n                fx(host, E4R_FX_PHASE, 2, 0);\n            }', '            } else {\n                fx(host, E4R_FX_PHASE, 2, 0);\n            }')
m('scores-won-phase-fx', 'missing-effect', '            } else {\n                *phase = 2;\n                fx(host, E4R_FX_PHASE, 2, 0);\n            }', '            } else {\n                *phase = 2;\n            }')
m('scores-won-no-limit-test', 'predicate', 'if (e4r_rd32(o, E4R_O_WON) != 0 && bs16(body, B_TIME_LIMIT) == 0) {', 'if (e4r_rd32(o, E4R_O_WON) != 0) {')
m('scores-won-no-limit-negative', 'predicate', 'if (e4r_rd32(o, E4R_O_WON) != 0 && bs16(body, B_TIME_LIMIT) == 0) {', 'if (e4r_rd32(o, E4R_O_WON) != 0 && bs16(body, B_TIME_LIMIT) <= 0) {')
m('scores-won-no-limit-won-test', 'predicate', 'if (e4r_rd32(o, E4R_O_WON) != 0 && bs16(body, B_TIME_LIMIT) == 0) {', 'if (e4r_rd32(o, E4R_O_WON) == 0 && bs16(body, B_TIME_LIMIT) == 0) {')
m('scores-won-no-limit-phase', 'missing-effect', '            *phase = 2;\n            fx(host, E4R_FX_PHASE, 2, 0);\n        }\n        break;\n    }', '            fx(host, E4R_FX_PHASE, 2, 0);\n        }\n        break;\n    }')
m('scores-won-no-limit-fx', 'missing-effect', '            *phase = 2;\n            fx(host, E4R_FX_PHASE, 2, 0);\n        }\n        break;\n    }', '            *phase = 2;\n        }\n        break;\n    }')
# ---- cleanup 0x475885
m('cleanup-surface-test', 'predicate', 'if (surface != 0) {', 'if (surface == 0) {')
m('cleanup-surface-kept', 'missing-effect', 'fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)surface, 0);\n        ob32(object, E4R_O_SURFACE, 0);', 'fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)surface, 0);')
m('cleanup-surface-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)surface, 0);', '(void)0;')
m('cleanup-surface-fx-kind', 'constant', 'fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)surface, 0);', 'fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)surface, 1);')
m('cleanup-score-surface-test', 'predicate', 'if (score_surface != 0) {', 'if (score_surface == 0) {')
m('cleanup-score-surface-kept', 'missing-effect', 'fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)score_surface, 1);\n        ob32(object, E4R_O_SCORE_SURFACE, 0);', 'fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)score_surface, 1);')
m('cleanup-score-surface-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)score_surface, 1);', '(void)0;')
m('cleanup-score-surface-fx-kind', 'constant', 'fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)score_surface, 1);', 'fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)score_surface, 0);')
m('cleanup-score-surface-before-surface', 'order', 'if (surface != 0) {\n        HOST(host->release_surface(host->context, surface));', 'if (surface != 0 && score_surface == 0) {\n        HOST(host->release_surface(host->context, surface));')
m('cleanup-slot-test', 'predicate', 'if (slot != E4R_NO_SLOT) {\n        HOST(host->release_slot', 'if (slot == E4R_NO_SLOT) {\n        HOST(host->release_slot')
m('cleanup-slot-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_RELEASE_SLOT, slot, 0);', '(void)0;')
m('cleanup-row-kept', 'missing-effect', 'ob16(object, E4R_O_ROW, -1);\n    ob16(object, E4R_O_SLOT, -1);', 'ob16(object, E4R_O_SLOT, -1);')
m('cleanup-slot-kept', 'missing-effect', 'ob16(object, E4R_O_SLOT, -1);\n    ob32(object, E4R_O_ACTIVE, 0);', 'ob32(object, E4R_O_ACTIVE, 0);')
m('cleanup-active-kept', 'missing-effect', 'ob32(object, E4R_O_ACTIVE, 0);\n    ob32(object, E4R_O_EXIT, 0);', 'ob32(object, E4R_O_EXIT, 0);')
m('cleanup-exit-kept', 'missing-effect', 'ob32(object, E4R_O_EXIT, 0);\n    ob32(object, E4R_O_WON, 0);', 'ob32(object, E4R_O_WON, 0);')
m('cleanup-won-kept', 'missing-effect', 'ob32(object, E4R_O_WON, 0);\n    memset', 'memset')
m('cleanup-cells-kept', 'missing-effect', 'memset(object->b + E4R_O_CELLS, 0, (size_t)E4R_MAX_ROWS * CELL_ROW_STRIDE);', '(void)0;')
m('cleanup-cells-short', 'loop-bound', 'memset(object->b + E4R_O_CELLS, 0, (size_t)E4R_MAX_ROWS * CELL_ROW_STRIDE);', 'memset(object->b + E4R_O_CELLS, 0, (size_t)(E4R_MAX_ROWS - 1) * CELL_ROW_STRIDE);')
m('cleanup-cells-shifted', 'rect', 'memset(object->b + E4R_O_CELLS, 0, (size_t)E4R_MAX_ROWS * CELL_ROW_STRIDE);', 'memset(object->b + E4R_O_CELLS + 1, 0, (size_t)E4R_MAX_ROWS * CELL_ROW_STRIDE - 1);')
m('cleanup-order-slot-before-surface', 'order', 'if (surface != 0) {\n        HOST(host->release_surface(host->context, surface));',
  'if (slot != E4R_NO_SLOT) {\n        HOST(host->release_slot(host->context, slot));\n        fx(host, E4R_FX_RELEASE_SLOT, slot, 0);\n        slot = E4R_NO_SLOT;\n    }\n    if (surface != 0) {\n        HOST(host->release_surface(host->context, surface));')
# ---- step() guards and phase 2
m('step-guard-row', 'predicate', 'if (e4r_rd16(o, E4R_O_ROW) != row || e4r_rd32(o, E4R_O_ACTIVE) == 0) {', 'if (e4r_rd32(o, E4R_O_ACTIVE) == 0) {')
m('step-guard-active', 'predicate', 'if (e4r_rd16(o, E4R_O_ROW) != row || e4r_rd32(o, E4R_O_ACTIVE) == 0) {', 'if (e4r_rd16(o, E4R_O_ROW) != row) {')
m('step-guard-kinds', 'predicate', 'if (phase == 1 && !kinds_in_range(o, body)) {', 'if (phase == 2 && !kinds_in_range(o, body)) {')
m('step-guard-kinds-skipped', 'predicate', 'if (phase == 1 && !kinds_in_range(o, body)) {', 'if (0) {')
m('step-guard-selection-state', 'predicate', 'if (phase == 1 && e4r_rd32(o, E4R_O_STATE) == 0) {\n        if ((o->b[E4R_O_CHECK_FIRST]', 'if (phase == 1) {\n        if ((o->b[E4R_O_CHECK_FIRST]')
m('step-guard-first-in-board', 'predicate', '!in_board(body, e4r_rd32(o, E4R_O_SEL_ROW), e4r_rd32(o, E4R_O_SEL_COL))) ||', '0) ||')
m('step-guard-second-in-board', 'predicate', '!in_board(body, e4r_rd32(o, E4R_O_SWAP_ROW), e4r_rd32(o, E4R_O_SWAP_COL)))) {', '0)) {')
m('step-guard-second-when-first', 'predicate', '(o->b[E4R_O_CHECK_FIRST] == 0 && o->b[E4R_O_CHECK_SECOND] != 0 &&', '(o->b[E4R_O_CHECK_SECOND] != 0 &&')
m('step-guard-exit-flag-block', 'predicate', 'if (e4r_rd32(o, E4R_O_EXIT) != 0)\n            blk = body + B_EXIT_BLOCK;\n        else if (e4r_rd32(o, E4R_O_WON) != 0)\n            blk = body + B_WIN_BLOCK;',
  'if (e4r_rd32(o, E4R_O_WON) != 0)\n            blk = body + B_WIN_BLOCK;\n        else if (e4r_rd32(o, E4R_O_EXIT) != 0)\n            blk = body + B_EXIT_BLOCK;')
m('step-guard-flag-skipped', 'predicate', 'host->event_flag_invalid(host->context, bs16(blk, SB_FLAG)) != 0) {', '0) {')
m('step-guard-flag-no-flag', 'predicate', 'if (blk != NULL && bs16(blk, SB_FLAG) != E4R_NO_FLAG && host', 'if (blk != NULL && host')
m('p2-start-flag', 'missing-effect', 'world->start_flag_5bb1ca = 1;\n        fx(host, E4R_FX_START_FLAG, 1, 0);\n        if (!no_sound(body + B_SOUND_A)) {\n            rc = stop_sound', 'fx(host, E4R_FX_START_FLAG, 1, 0);\n        if (!no_sound(body + B_SOUND_A)) {\n            rc = stop_sound')
m('p2-start-flag-fx', 'missing-effect', 'fx(host, E4R_FX_START_FLAG, 1, 0);\n        if (!no_sound(body + B_SOUND_A)) {\n            rc = stop_sound', 'if (!no_sound(body + B_SOUND_A)) {\n            rc = stop_sound')
m('p2-stop-a-test', 'predicate', 'if (!no_sound(body + B_SOUND_A)) {\n            rc = stop_sound(host, body, B_SOUND_A);', 'if (no_sound(body + B_SOUND_A)) {\n            rc = stop_sound(host, body, B_SOUND_A);')
m('p2-stop-b-test', 'predicate', 'if (!no_sound(body + B_SOUND_B)) {\n            rc = stop_sound(host, body, B_SOUND_B);', 'if (no_sound(body + B_SOUND_B)) {\n            rc = stop_sound(host, body, B_SOUND_B);')
m('p2-stop-c-test', 'predicate', 'if (!no_sound(body + B_SOUND_C)) {\n            rc = stop_sound(host, body, B_SOUND_C);', 'if (no_sound(body + B_SOUND_C)) {\n            rc = stop_sound(host, body, B_SOUND_C);')
m('p2-stop-d', 'missing-effect', '        if (!no_sound(body + B_SOUND_C)) {\n            rc = stop_sound(host, body, B_SOUND_C);\n            if (rc != E4R_OK) goto host_fail;\n        }\n',
  '        if (!no_sound(body + B_SOUND_C)) {\n            rc = stop_sound(host, body, B_SOUND_C);\n            if (rc != E4R_OK) goto host_fail;\n        }\n        if (!no_sound(body + B_SOUND_D)) {\n            rc = stop_sound(host, body, B_SOUND_D);\n            if (rc != E4R_OK) goto host_fail;\n        }\n')
m('p2-stop-a-record', 'rect', 'rc = stop_sound(host, body, B_SOUND_A);\n            if (rc != E4R_OK) goto host_fail;', 'rc = stop_sound(host, body, B_SOUND_B);\n            if (rc != E4R_OK) goto host_fail;')
m('p2-exit-test', 'predicate', 'if (e4r_rd32(o, E4R_O_EXIT) == 0) {\n            if (e4r_rd32(o, E4R_O_WON) != 0) {', 'if (e4r_rd32(o, E4R_O_EXIT) != 0) {\n            if (e4r_rd32(o, E4R_O_WON) != 0) {')
m('p2-win-test', 'predicate', 'if (e4r_rd32(o, E4R_O_WON) != 0) {\n                rc = apply_block(body + B_WIN_BLOCK', 'if (e4r_rd32(o, E4R_O_WON) == 0) {\n                rc = apply_block(body + B_WIN_BLOCK')
m('p2-win-block', 'rect', 'rc = apply_block(body + B_WIN_BLOCK, world, host);', 'rc = apply_block(body + B_EXIT_BLOCK, world, host);')
m('p2-exit-block', 'rect', 'rc = apply_block(body + B_EXIT_BLOCK, world, host);\n            if (rc != E4R_OK) goto host_fail;\n        }\n        if (body[B_NAME_PANEL]', 'rc = apply_block(body + B_WIN_BLOCK, world, host);\n            if (rc != E4R_OK) goto host_fail;\n        }\n        if (body[B_NAME_PANEL]')
m('p2-font-test', 'predicate', 'if (body[B_NAME_PANEL] != 0) {\n            const int16_t font', 'if (body[B_NAME_PANEL] == 0) {\n            const int16_t font')
m('p2-font-fx-dropped', 'missing-effect', 'fx(host, E4R_FX_FONT_RELEASE, font, 0);', '(void)0;')
m('p2-font-field', 'rect', 'const int16_t font = bs16(body, B_FONT);\n            if (host->font_release', 'const int16_t font = bs16(body, B_FONT_PARAM);\n            if (host->font_release')
m('p2-complete-fx', 'missing-effect', 'fx(host, E4R_FX_COMPLETE, row, 0);', '(void)0;')
m('p2-complete-fx-value', 'constant', 'fx(host, E4R_FX_COMPLETE, row, 0);', 'fx(host, E4R_FX_COMPLETE, row + 1, 0);')
m('p2-completed-flag', 'missing-effect', 'result->completed = 1;\n        rc = e4r_cleanup(o, host);', 'rc = e4r_cleanup(o, host);')
m('p2-cleanup-skipped', 'missing-effect', 'result->completed = 1;\n        rc = e4r_cleanup(o, host);\n        if (rc != E4R_OK) goto host_fail;', 'result->completed = 1;')
m('p2-complete-before-cleanup', 'order', 'fx(host, E4R_FX_COMPLETE, row, 0);\n        result->completed = 1;\n        rc = e4r_cleanup(o, host);\n        if (rc != E4R_OK) goto host_fail;',
  'result->completed = 1;\n        rc = e4r_cleanup(o, host);\n        if (rc != E4R_OK) goto host_fail;\n        fx(host, E4R_FX_COMPLETE, row, 0);')
# ---- pointer 0x4756b8
m('pointer-candidate-exit-state', 'predicate', 'if (candidate == E4R_CANDIDATE_EXIT && e4r_rd32(o, E4R_O_STATE) != E4R_STATE_SCORES) {', 'if (candidate == E4R_CANDIDATE_EXIT) {')
m('pointer-candidate-exit-state-value', 'constant', 'e4r_rd32(o, E4R_O_STATE) != E4R_STATE_SCORES) {\n        out->cursor_written = 1;\n        out->cursor_kind = 9;', 'e4r_rd32(o, E4R_O_STATE) != E4R_STATE_END) {\n        out->cursor_written = 1;\n        out->cursor_kind = 9;')
m('pointer-exit-cursor', 'constant', 'out->cursor_kind = 9;', 'out->cursor_kind = 10;')
m('pointer-exit-cursor-sub', 'constant', 'out->cursor_kind = 9;\n        out->cursor_sub = 1;', 'out->cursor_kind = 9;\n        out->cursor_sub = 0;')
m('pointer-piece-cursor', 'constant', 'out->cursor_kind = 0x16;', 'out->cursor_kind = 0x15;')
m('pointer-piece-cursor-sub', 'constant', 'out->cursor_kind = 0x16;\n        out->cursor_sub = 1;', 'out->cursor_kind = 0x16;\n        out->cursor_sub = 0;')
m('pointer-shuffle-cursor', 'predicate', 'candidate == E4R_CANDIDATE_PIECE || candidate == E4R_CANDIDATE_SHUFFLE', 'candidate == E4R_CANDIDATE_PIECE')
m('pointer-exit-cursor-on-piece', 'predicate', 'candidate == E4R_CANDIDATE_PIECE || candidate == E4R_CANDIDATE_SHUFFLE', 'candidate == E4R_CANDIDATE_PIECE || candidate == E4R_CANDIDATE_SHUFFLE || candidate == E4R_CANDIDATE_EXIT')
m('pointer-inactive', 'predicate', 'if (e4r_rd32(o, E4R_O_ACTIVE) == 0 || e4r_rd32(o, E4R_O_STATE) == E4R_STATE_REFILL) return E4R_OK;', 'if (e4r_rd32(o, E4R_O_STATE) == E4R_STATE_REFILL) return E4R_OK;')
m('pointer-refill', 'predicate', 'if (e4r_rd32(o, E4R_O_ACTIVE) == 0 || e4r_rd32(o, E4R_O_STATE) == E4R_STATE_REFILL) return E4R_OK;', 'if (e4r_rd32(o, E4R_O_ACTIVE) == 0) return E4R_OK;')
m('pointer-refill-other-state', 'constant', 'e4r_rd32(o, E4R_O_STATE) == E4R_STATE_REFILL) return E4R_OK;', 'e4r_rd32(o, E4R_O_STATE) == E4R_STATE_SHUFFLE) return E4R_OK;')
m('pointer-x-width', 'signedness', 'px = (int16_t)x;', 'px = x;')
m('pointer-y-width', 'signedness', 'py = (int16_t)y;', 'py = y;')
m('pointer-x-unsigned', 'signedness', 'px = (int16_t)x;', 'px = (uint16_t)x;')
m('pointer-y-unsigned', 'signedness', 'py = (int16_t)y;', 'py = (uint16_t)y;')
OLDP = 'if (top <= py && py <= bottom && left <= px && px <= right) {'
m('pointer-cell-top-margin', 'compare', 'top = wrap_add(e4r_rd32(o, at + 4), 3)', 'top = wrap_add(e4r_rd32(o, at + 4), 2)')
m('pointer-cell-top-margin-hi', 'compare', 'top = wrap_add(e4r_rd32(o, at + 4), 3)', 'top = wrap_add(e4r_rd32(o, at + 4), 4)')
m('pointer-cell-bottom-margin', 'compare', 'bottom = wrap_add(e4r_rd32(o, at + 12), -3)', 'bottom = wrap_add(e4r_rd32(o, at + 12), -2)')
m('pointer-cell-bottom-margin-lo', 'compare', 'bottom = wrap_add(e4r_rd32(o, at + 12), -3)', 'bottom = wrap_add(e4r_rd32(o, at + 12), -4)')
m('pointer-cell-left-margin', 'compare', 'left = wrap_add(e4r_rd32(o, at), 3)', 'left = wrap_add(e4r_rd32(o, at), 2)')
m('pointer-cell-left-margin-hi', 'compare', 'left = wrap_add(e4r_rd32(o, at), 3)', 'left = wrap_add(e4r_rd32(o, at), 4)')
m('pointer-cell-right-margin', 'compare', 'right = wrap_add(e4r_rd32(o, at + 8), -3)', 'right = wrap_add(e4r_rd32(o, at + 8), -2)')
m('pointer-cell-right-margin-lo', 'compare', 'right = wrap_add(e4r_rd32(o, at + 8), -3)', 'right = wrap_add(e4r_rd32(o, at + 8), -4)')
m('pointer-cell-top-strict', 'compare', 'if (top <= py &&', 'if (top < py &&')
m('pointer-cell-bottom-strict', 'compare', 'py <= bottom &&', 'py < bottom &&')
m('pointer-cell-left-strict', 'compare', 'left <= px &&', 'left < px &&')
m('pointer-cell-right-strict', 'compare', 'px <= right) {', 'px < right) {')
m('pointer-cell-wrap-as-int64', 'signedness',
  'const int32_t left = wrap_add(e4r_rd32(o, at), 3), top = wrap_add(e4r_rd32(o, at + 4), 3),\n                          right = wrap_add(e4r_rd32(o, at + 8), -3), bottom = wrap_add(e4r_rd32(o, at + 12), -3);',
  'const int64_t left = (int64_t)e4r_rd32(o, at) + 3, top = (int64_t)e4r_rd32(o, at + 4) + 3,\n                          right = (int64_t)e4r_rd32(o, at + 8) - 3, bottom = (int64_t)e4r_rd32(o, at + 12) - 3;')
m('pointer-cell-rect-swapped', 'rect', 'top = wrap_add(e4r_rd32(o, at + 4), 3)', 'top = wrap_add(e4r_rd32(o, at + 8), 3)')
m('pointer-hover-row-store', 'missing-effect', 'ob32(o, E4R_O_HOVER_ROW, r);\n', '')
m('pointer-hover-col-store', 'missing-effect', 'ob32(o, E4R_O_HOVER_COL, c);\n', '')
m('pointer-hover-swapped', 'rect', 'ob32(o, E4R_O_HOVER_ROW, r);\n                ob32(o, E4R_O_HOVER_COL, c);', 'ob32(o, E4R_O_HOVER_ROW, c);\n                ob32(o, E4R_O_HOVER_COL, r);')
m('pointer-first-hit-wins', 'order', 'out->hit = 1;\n                return E4R_OK;\n            }\n        }\n    }', 'out->hit = 1;\n            }\n        }\n    }')
m('pointer-shuffle-top', 'compare', 'if (bs32(body, B_SHUFFLE_RECT + 4) <= py &&', 'if (bs32(body, B_SHUFFLE_RECT + 4) < py &&')
m('pointer-shuffle-bottom', 'compare', 'py <= bs32(body, B_SHUFFLE_RECT + 12) &&', 'py < bs32(body, B_SHUFFLE_RECT + 12) &&')
m('pointer-shuffle-left', 'compare', 'bs32(body, B_SHUFFLE_RECT) <= px &&', 'bs32(body, B_SHUFFLE_RECT) < px &&')
m('pointer-shuffle-right', 'compare', 'px <= bs32(body, B_SHUFFLE_RECT + 8)) {', 'px < bs32(body, B_SHUFFLE_RECT + 8)) {')
m('pointer-shuffle-rect-field', 'rect', 'if (bs32(body, B_SHUFFLE_RECT + 4) <= py &&', 'if (bs32(body, B_EXIT_RECT + 4) <= py &&')
m('pointer-exit-top', 'compare', 'if (bs32(body, B_EXIT_RECT + 4) <= py &&', 'if (bs32(body, B_EXIT_RECT + 4) < py &&')
m('pointer-exit-bottom', 'compare', 'py <= bs32(body, B_EXIT_RECT + 12) &&', 'py < bs32(body, B_EXIT_RECT + 12) &&')
m('pointer-exit-left', 'compare', 'bs32(body, B_EXIT_RECT) <= px &&', 'bs32(body, B_EXIT_RECT) < px &&')
m('pointer-exit-right', 'compare', 'px <= bs32(body, B_EXIT_RECT + 8)) {', 'px < bs32(body, B_EXIT_RECT + 8)) {')
m('pointer-exit-before-shuffle', 'order', '    if (bs32(body, B_SHUFFLE_RECT + 4) <= py && py <= bs32(body, B_SHUFFLE_RECT + 12) &&\n        bs32(body, B_SHUFFLE_RECT) <= px && px <= bs32(body, B_SHUFFLE_RECT + 8)) {',
  '    if (bs32(body, B_EXIT_RECT + 4) <= py && py <= bs32(body, B_EXIT_RECT + 12) && bs32(body, B_EXIT_RECT) <= px &&\n        px <= bs32(body, B_EXIT_RECT + 8)) {\n        write_cursor(o, E4R_CANDIDATE_EXIT, out);\n        out->hit = 1;\n        return E4R_OK;\n    }\n    if (bs32(body, B_SHUFFLE_RECT + 4) <= py && py <= bs32(body, B_SHUFFLE_RECT + 12) &&\n        bs32(body, B_SHUFFLE_RECT) <= px && px <= bs32(body, B_SHUFFLE_RECT + 8)) {')
# ---- click 0x47608e
m('click-guard-active', 'predicate', '(e4r_rd32(o, E4R_O_ACTIVE) != 0 && e4r_rd32(o, E4R_O_WON) == 0', '(e4r_rd32(o, E4R_O_WON) == 0')
m('click-guard-won', 'predicate', 'e4r_rd32(o, E4R_O_WON) == 0 && e4r_rd32(o, E4R_O_STATE) == 0 &&', 'e4r_rd32(o, E4R_O_STATE) == 0 &&')
m('click-guard-state', 'predicate', 'e4r_rd32(o, E4R_O_STATE) == 0 &&\n          o->b[E4R_O_CHECK_FIRST] == 0', 'o->b[E4R_O_CHECK_FIRST] == 0')
m('click-guard-first', 'predicate', 'o->b[E4R_O_CHECK_FIRST] == 0 && o->b[E4R_O_CHECK_SECOND] == 0 && row_phase == 1))', 'o->b[E4R_O_CHECK_SECOND] == 0 && row_phase == 1))')
m('click-guard-second', 'predicate', 'o->b[E4R_O_CHECK_FIRST] == 0 && o->b[E4R_O_CHECK_SECOND] == 0 && row_phase == 1))', 'o->b[E4R_O_CHECK_FIRST] == 0 && row_phase == 1))')
m('click-guard-phase', 'predicate', 'o->b[E4R_O_CHECK_SECOND] == 0 && row_phase == 1))', 'o->b[E4R_O_CHECK_SECOND] == 0))')
m('click-guard-phase-value', 'constant', 'o->b[E4R_O_CHECK_SECOND] == 0 && row_phase == 1))', 'o->b[E4R_O_CHECK_SECOND] == 0 && row_phase <= 1))')
m('click-guard-won-nonzero-one', 'predicate', 'e4r_rd32(o, E4R_O_WON) == 0 && e4r_rd32(o, E4R_O_STATE) == 0 &&', '(e4r_rd32(o, E4R_O_WON) & 1) == 0 && e4r_rd32(o, E4R_O_STATE) == 0 &&')
m('click-guard-check-flags-one', 'predicate', 'o->b[E4R_O_CHECK_FIRST] == 0 && o->b[E4R_O_CHECK_SECOND] == 0 && row_phase == 1))', '(o->b[E4R_O_CHECK_FIRST] & 1) == 0 && o->b[E4R_O_CHECK_SECOND] == 0 && row_phase == 1))')
m('click-exit-store', 'missing-effect', 'ob32(o, E4R_O_EXIT, 1);\n        out->phase_changed = 1;', 'out->phase_changed = 1;')
m('click-exit-phase', 'constant', 'out->phase = 2;\n        fx(host, E4R_FX_PHASE, 2, 0);', 'out->phase = 3;\n        fx(host, E4R_FX_PHASE, 2, 0);')
m('click-exit-phase-fx', 'missing-effect', 'out->phase = 2;\n        fx(host, E4R_FX_PHASE, 2, 0);', 'out->phase = 2;')
m('click-exit-phase-changed', 'missing-effect', 'out->phase_changed = 1;\n        out->phase = 2;', 'out->phase = 2;')
m('click-exit-fired', 'missing-effect', 'out->fired = 1;\n        ob32(o, E4R_O_EXIT, 1);', 'ob32(o, E4R_O_EXIT, 1);')
m('click-piece-no-selection-test', 'predicate', 'if (e4r_rd32(o, E4R_O_NO_SELECTION) == 0) {', 'if (e4r_rd32(o, E4R_O_NO_SELECTION) != 0) {')
m('click-piece-no-selection-low-byte', 'predicate', 'if (e4r_rd32(o, E4R_O_NO_SELECTION) == 0) {', 'if ((e4r_rd32(o, E4R_O_NO_SELECTION) & 0xff) == 0) {')
m('click-swap-hover-in-board', 'predicate', 'if (!in_board(body, hrow, hcol) || !in_board(body, srow, scol)) return E4R_ERR_UNSUPPORTED;', 'if (!in_board(body, srow, scol)) return E4R_ERR_UNSUPPORTED;')
m('click-swap-sel-in-board', 'predicate', 'if (!in_board(body, hrow, hcol) || !in_board(body, srow, scol)) return E4R_ERR_UNSUPPORTED;', 'if (!in_board(body, hrow, hcol)) return E4R_ERR_UNSUPPORTED;')
m('click-select-in-board', 'predicate', 'if (!in_board(body, hrow, hcol)) return E4R_ERR_UNSUPPORTED;\n            out->fired = 1;', 'if (0) return E4R_ERR_UNSUPPORTED;\n            out->fired = 1;')
m('click-swap-fired', 'missing-effect', 'out->fired = 1;\n            ob32(o, E4R_O_NO_SELECTION, 1);', 'ob32(o, E4R_O_NO_SELECTION, 1);')
m('click-swap-no-selection-store', 'missing-effect', 'ob32(o, E4R_O_NO_SELECTION, 1);\n            rc = click_sound(host, body, B_SOUND_C, B_CHANNEL_C, out);', 'rc = click_sound(host, body, B_SOUND_C, B_CHANNEL_C, out);')
m('click-swap-sound-record', 'rect', 'ob32(o, E4R_O_NO_SELECTION, 1);\n            rc = click_sound(host, body, B_SOUND_C, B_CHANNEL_C, out);', 'ob32(o, E4R_O_NO_SELECTION, 1);\n            rc = click_sound(host, body, B_SOUND_B, B_CHANNEL_C, out);')
m('click-swap-sound-channel', 'rect', 'ob32(o, E4R_O_NO_SELECTION, 1);\n            rc = click_sound(host, body, B_SOUND_C, B_CHANNEL_C, out);', 'ob32(o, E4R_O_NO_SELECTION, 1);\n            rc = click_sound(host, body, B_SOUND_C, B_CHANNEL_B, out);')
m('click-swap-kinds-not-swapped-a', 'missing-effect', 'ob16(o, cell_at(srow, scol) + CELL_KIND, b);\n', '')
m('click-swap-kinds-not-swapped-b', 'missing-effect', 'ob16(o, cell_at(hrow, hcol) + CELL_KIND, a);\n', '')
m('click-swap-kinds-wrong', 'rect', 'a = e4r_rd16(o, cell_at(srow, scol) + CELL_KIND);\n            b = e4r_rd16(o, cell_at(hrow, hcol) + CELL_KIND);', 'a = e4r_rd16(o, cell_at(srow, scol) + CELL_KIND);\n            b = e4r_rd16(o, cell_at(hcol, hrow) + CELL_KIND);')
m('click-swap-row-store', 'missing-effect', 'ob32(o, E4R_O_SWAP_ROW, hrow);\n', '')
m('click-swap-col-store', 'missing-effect', 'ob32(o, E4R_O_SWAP_COL, hcol);\n', '')
m('click-swap-row-source', 'rect', 'ob32(o, E4R_O_SWAP_ROW, hrow);', 'ob32(o, E4R_O_SWAP_ROW, srow);')
m('click-swap-col-source', 'rect', 'ob32(o, E4R_O_SWAP_COL, hcol);', 'ob32(o, E4R_O_SWAP_COL, scol);')
m('click-swap-check-first', 'missing-effect', 'o->b[E4R_O_CHECK_FIRST] = 1;\n            o->b[E4R_O_CHECK_SECOND] = 1;', 'o->b[E4R_O_CHECK_SECOND] = 1;')
m('click-swap-check-second', 'missing-effect', 'o->b[E4R_O_CHECK_FIRST] = 1;\n            o->b[E4R_O_CHECK_SECOND] = 1;', 'o->b[E4R_O_CHECK_FIRST] = 1;')
m('click-select-fired', 'missing-effect', 'out->fired = 1;\n            rc = click_sound(host, body, B_SOUND_C, B_CHANNEL_C, out);\n            if (rc != E4R_OK) return rc;\n            ob32(o, E4R_O_SEL_ROW', 'rc = click_sound(host, body, B_SOUND_C, B_CHANNEL_C, out);\n            if (rc != E4R_OK) return rc;\n            ob32(o, E4R_O_SEL_ROW')
m('click-select-sound-record', 'rect', 'rc = click_sound(host, body, B_SOUND_C, B_CHANNEL_C, out);\n            if (rc != E4R_OK) return rc;\n            ob32(o, E4R_O_SEL_ROW', 'rc = click_sound(host, body, B_SOUND_B, B_CHANNEL_C, out);\n            if (rc != E4R_OK) return rc;\n            ob32(o, E4R_O_SEL_ROW')
m('click-select-row', 'missing-effect', 'ob32(o, E4R_O_SEL_ROW, hrow);\n', '')
m('click-select-col', 'missing-effect', 'ob32(o, E4R_O_SEL_COL, hcol);\n', '')
m('click-select-no-selection', 'missing-effect', 'ob32(o, E4R_O_NO_SELECTION, 0);', '(void)0;')
m('click-select-swapped', 'rect', 'ob32(o, E4R_O_SEL_ROW, hrow);\n            ob32(o, E4R_O_SEL_COL, hcol);', 'ob32(o, E4R_O_SEL_ROW, hcol);\n            ob32(o, E4R_O_SEL_COL, hrow);')
m('click-shuffle-fired', 'missing-effect', 'out->fired = 1;\n        rc = click_sound(host, body, B_SOUND_B, B_CHANNEL_B, out);', 'rc = click_sound(host, body, B_SOUND_B, B_CHANNEL_B, out);')
m('click-shuffle-sound-record', 'rect', 'rc = click_sound(host, body, B_SOUND_B, B_CHANNEL_B, out);', 'rc = click_sound(host, body, B_SOUND_C, B_CHANNEL_B, out);')
m('click-shuffle-sound-channel', 'rect', 'rc = click_sound(host, body, B_SOUND_B, B_CHANNEL_B, out);', 'rc = click_sound(host, body, B_SOUND_B, B_CHANNEL_C, out);')
m('click-shuffle-delay', 'constant', 'wrap_add((int32_t)get_tick(host), 0xfa)', 'wrap_add((int32_t)get_tick(host), 0xf9)')
m('click-shuffle-down', 'missing-effect', 'o->b[E4R_O_SHUFFLE_DOWN] = 1;\n        ob32(o, E4R_O_STATE, E4R_STATE_SHUFFLE);', 'ob32(o, E4R_O_STATE, E4R_STATE_SHUFFLE);')
m('click-shuffle-state', 'missing-effect', 'o->b[E4R_O_SHUFFLE_DOWN] = 1;\n        ob32(o, E4R_O_STATE, E4R_STATE_SHUFFLE);', 'o->b[E4R_O_SHUFFLE_DOWN] = 1;')
m('click-shuffle-tick-after-sound', 'order', 'rc = click_sound(host, body, B_SOUND_B, B_CHANNEL_B, out);\n        if (rc != E4R_OK) return rc;\n        ob32(o, E4R_O_SHUFFLE_END, wrap_add((int32_t)get_tick(host), 0xfa));',
  'const int32_t tick_first = (int32_t)get_tick(host);\n        rc = click_sound(host, body, B_SOUND_B, B_CHANNEL_B, out);\n        if (rc != E4R_OK) return rc;\n        ob32(o, E4R_O_SHUFFLE_END, wrap_add(tick_first, 0xfa));')
m('click-sound-test', 'predicate', 'if (!no_sound(body + record)) {', 'if (no_sound(body + record)) {')
m('click-sound-busy-channel', 'rect', 'const int rc = busy(host, bs16(body, channel), &b);', 'const int rc = busy(host, bs16(body, channel) + 1, &b);')
m('click-sound-busy-inverted', 'predicate', 'if (b == 0) {\n            const int rc2 = play', 'if (b != 0) {\n            const int rc2 = play')
m('click-sound-busy-low-byte', 'predicate', 'if (b == 0) {\n            const int rc2 = play', 'if ((b & 0xff) == 0) {\n            const int rc2 = play')
m('click-sound-play-flag', 'missing-effect', 'out->sound_played = 1;', '(void)0;')
m('click-sound-play-channel', 'rect', 'const int rc2 = play(host, bs16(body, channel));', 'const int rc2 = play(host, bs16(body, channel) + 1);')
# ---- invalidate
m('invalidate-active', 'predicate', 'if (e4r_rd32(object, E4R_O_ACTIVE) != 0 && slot != E4R_NO_SLOT) {', 'if (slot != E4R_NO_SLOT) {')
m('invalidate-slot', 'predicate', 'if (e4r_rd32(object, E4R_O_ACTIVE) != 0 && slot != E4R_NO_SLOT) {', 'if (e4r_rd32(object, E4R_O_ACTIVE) != 0) {')
m('invalidate-fx', 'missing-effect', 'fx(host, E4R_FX_MARK_DIRTY, slot, 0);', '(void)0;')
m('invalidate-either', 'predicate', 'if (e4r_rd32(object, E4R_O_ACTIVE) != 0 && slot != E4R_NO_SLOT) {', 'if (e4r_rd32(object, E4R_O_ACTIVE) != 0 || slot != E4R_NO_SLOT) {')
# ---- render 0x4778df
m('render-valid-row', 'predicate', 'if (row < 0 || e4r_rd16(o, E4R_O_SLOT) == E4R_NO_SLOT) return E4R_OK;', 'if (e4r_rd16(o, E4R_O_SLOT) == E4R_NO_SLOT) return E4R_OK;')
m('render-valid-slot', 'predicate', 'if (row < 0 || e4r_rd16(o, E4R_O_SLOT) == E4R_NO_SLOT) return E4R_OK;', 'if (row < 0) return E4R_OK;')
m('render-valid-flag', 'missing-effect', 'out->valid = 1;\n\n    if (o->b[E4R_O_ERASE_ALL] != 0) {', '\n    if (o->b[E4R_O_ERASE_ALL] != 0) {')
m('render-bounds-state', 'predicate', 'if (e4r_rd32(o, E4R_O_STATE) != E4R_STATE_SCORES) {\n        for (r = 0; r < rows; ++r)', 'if (0) {\n        for (r = 0; r < rows; ++r)')
m('render-bounds-kind-low', 'compare', '(kind < 0 || kind >= kinds))\n                    return E4R_ERR_BOUNDS;', '(kind < -1 || kind >= kinds))\n                    return E4R_ERR_BOUNDS;')
m('render-bounds-kind-high', 'compare', '(kind < 0 || kind >= kinds))\n                    return E4R_ERR_BOUNDS;', '(kind < 0 || kind > kinds))\n                    return E4R_ERR_BOUNDS;')
m('render-bounds-present', 'predicate', 'if (o->b[cell + CELL_PRESENT] != 0 && o->b[cell + CELL_MATCHED] == 0 && (kind', 'if (o->b[cell + CELL_MATCHED] == 0 && (kind')
m('render-bounds-matched', 'predicate', 'if (o->b[cell + CELL_PRESENT] != 0 && o->b[cell + CELL_MATCHED] == 0 && (kind', 'if (o->b[cell + CELL_PRESENT] != 0 && (kind')
m('render-view-failure', 'missing-effect', 'if (host->view_rects(host->context, view, full) != 0) return E4R_ERR_HOST;', 'host->view_rects(host->context, view, full);')
m('render-erase-all-test', 'predicate', 'if (o->b[E4R_O_ERASE_ALL] != 0) {\n        OP', 'if (o->b[E4R_O_ERASE_ALL] == 0) {\n        OP')
m('render-erase-all-label', 'constant', 'OP(add_blit(out, E4R_LABEL_ERASE_ALL, E4R_SURFACE_BACKGROUND, full, view));', 'OP(add_blit(out, E4R_LABEL_ERASE_ALL, E4R_SURFACE_BACKGROUND, view, view));')
m('render-erase-all-role', 'constant', 'OP(add_blit(out, E4R_LABEL_ERASE_ALL, E4R_SURFACE_BACKGROUND, full, view));', 'OP(add_blit(out, E4R_LABEL_ERASE_ALL, E4R_SURFACE_PUZZLE, full, view));')
m('render-erase-all-kept', 'missing-effect', 'o->b[E4R_O_ERASE_ALL] = 0;\n    }', '(void)0;\n    }')
m('render-scores-state', 'predicate', 'if (e4r_rd32(o, E4R_O_STATE) == E4R_STATE_SCORES) {\n        if (bs16(body, B_TIME_LIMIT) > 0) {', 'if (e4r_rd32(o, E4R_O_STATE) == E4R_STATE_END_SOUND) {\n        if (bs16(body, B_TIME_LIMIT) > 0) {')
m('render-scores-limit-ge', 'compare', 'if (bs16(body, B_TIME_LIMIT) > 0) {\n            int16_t height', 'if (bs16(body, B_TIME_LIMIT) >= 0) {\n            int16_t height')
m('render-scores-limit-ne', 'compare', 'if (bs16(body, B_TIME_LIMIT) > 0) {\n            int16_t height', 'if (bs16(body, B_TIME_LIMIT) != 0) {\n            int16_t height')
m('render-scores-backdrop-role', 'constant', 'OP(add_blit(out, E4R_LABEL_SCORES_BACKDROP, E4R_SURFACE_SCORE, full, view));', 'OP(add_blit(out, E4R_LABEL_SCORES_BACKDROP, E4R_SURFACE_PUZZLE, full, view));')
m('render-scores-backdrop-src', 'constant', 'OP(add_blit(out, E4R_LABEL_SCORES_BACKDROP, E4R_SURFACE_SCORE, full, view));', 'OP(add_blit(out, E4R_LABEL_SCORES_BACKDROP, E4R_SURFACE_SCORE, view, view));')
m('render-scores-extent-font', 'rect', 'host->text_extent(host->context, bs16(body, B_FONT), &height) != 0', 'host->text_extent(host->context, bs16(body, B_FONT_PARAM), &height) != 0')
m('render-scores-extent-fx', 'missing-effect', 'fx(host, E4R_FX_TEXT_EXTENT, bs16(body, B_FONT), height);', '(void)0;')
m('render-scores-step', 'constant', 'step = (int16_t)(height + 0xd);', 'step = (int16_t)(height + 0xc);')
m('render-scores-step-trunc', 'signedness', 'step = (int16_t)(height + 0xd);', 'step = (int16_t)(height + 0xd) & 0x7f;')
m('render-scores-hsy0', 'constant', 'wrap_add(bs32(body, B_HS_Y0), -6)', 'wrap_add(bs32(body, B_HS_Y0), -5)')
m('render-scores-hsy0-field', 'rect', 'wrap_add(bs32(body, B_HS_Y0), -6)', 'wrap_add(bs32(body, B_HS_Y1), -6)')
m('render-scores-rect-view-y', 'rect', 'rect[1] = wrap_add(wrap_add(bs32(body, B_HS_Y0), -6), view[1]);', 'rect[1] = wrap_add(bs32(body, B_HS_Y0), -6);')
m('render-scores-rect-bottom', 'rect', 'rect[3] = wrap_add(rect[1], step);', 'rect[3] = rect[1];')
m('render-scores-rect-left', 'rect', 'rect[0] = wrap_add(bs32(body, B_HS_X0), view[0]);', 'rect[0] = bs32(body, B_HS_X0);')
m('render-scores-rect-left-field', 'rect', 'rect[0] = wrap_add(bs32(body, B_HS_X0), view[0]);', 'rect[0] = wrap_add(bs32(body, B_HS_X1), view[0]);')
m('render-scores-text-left', 'rect', 'OP(add_text(out, o->b + E4R_O_SCORE_TEXT, bufrect, body, view));', 'OP(add_text(out, o->b + E4R_O_TIME_TEXT, bufrect, body, view));')
m('render-scores-high-y', 'constant', 'wrap_add(wrap_add(bs32(body, B_HS_Y1), -0x10), view[1]), step)', 'wrap_add(wrap_add(bs32(body, B_HS_Y1), -0x11), view[1]), step)')
m('render-scores-high-y-field', 'rect', 'wrap_add(wrap_add(bs32(body, B_HS_Y1), -0x10), view[1]), step)', 'wrap_add(wrap_add(bs32(body, B_HS_Y0), -0x10), view[1]), step)')
m('render-scores-high-x', 'rect', 'high_rect[0] = wrap_add(bs32(body, B_HS_X1), view[0]);', 'high_rect[0] = wrap_add(bs32(body, B_HS_X0), view[0]);')
m('render-scores-high-x-view', 'rect', 'high_rect[0] = wrap_add(bs32(body, B_HS_X1), view[0]);', 'high_rect[0] = bs32(body, B_HS_X1);')
m('render-scores-high-loop-short', 'loop-bound', 'for (i = 0; i < E4R_HIGH_SCORES; ++i) {\n                uint8_t text[16];', 'for (i = 0; i < E4R_HIGH_SCORES - 1; ++i) {\n                uint8_t text[16];')
m('render-scores-high-row-advance', 'rect', 'high_rect[1] = high_rect[3];\n                high_rect[3] = wrap_add(high_rect[3], step);', 'high_rect[1] = high_rect[3];\n                high_rect[3] = wrap_add(high_rect[3], step + 1);')
m('render-scores-high-row-top', 'rect', 'high_rect[1] = high_rect[3];\n', 'high_rect[1] = high_rect[3] - 1;\n')
m('render-scores-high-unsigned', 'signedness', '(unsigned)(uint32_t)world->high_score[i]', '(unsigned)((uint32_t)world->high_score[i] & 0x7fffffffu)')
m('render-scores-high-index', 'rect', '(unsigned)(uint32_t)world->high_score[i]', '(unsigned)(uint32_t)world->high_score[E4R_HIGH_SCORES - 1 - i]')
m('render-scores-return-early', 'missing-effect', '        }\n        return E4R_OK;\n    }\n\n    for (r = 0; r < rows; ++r)', '        }\n    }\n\n    for (r = 0; r < rows; ++r)')
m('render-piece-present', 'predicate', 'if (o->b[cell + CELL_PRESENT] == 0) continue;', 'if (0) continue;')
m('render-piece-matched', 'predicate', 'if (o->b[cell + CELL_MATCHED] == 0) {\n                const int16_t kind', 'if (o->b[cell + CELL_MATCHED] != 0) {\n                const int16_t kind')
m('render-piece-src-stride', 'rect', 'body_rect(body, B_PIECE_RECT + (size_t)kind * 16u, src);', 'body_rect(body, B_PIECE_RECT + (size_t)kind * 8u, src);')
m('render-piece-label', 'constant', 'OP(add_blit(out, E4R_LABEL_PIECE, E4R_SURFACE_PUZZLE, src, dst));', 'OP(add_blit(out, E4R_LABEL_MATCHED, E4R_SURFACE_PUZZLE, src, dst));')
m('render-piece-role', 'constant', 'OP(add_blit(out, E4R_LABEL_PIECE, E4R_SURFACE_PUZZLE, src, dst));', 'OP(add_blit(out, E4R_LABEL_PIECE, E4R_SURFACE_BACKGROUND, src, dst));')
m('render-matched-src', 'rect', 'body_rect(body, B_MATCHED_SRC, src);', 'body_rect(body, B_SHUFFLE_SRC, src);')
m('render-matched-label', 'constant', 'OP(add_blit(out, E4R_LABEL_MATCHED, E4R_SURFACE_PUZZLE, src, dst));', 'OP(add_blit(out, E4R_LABEL_PIECE, E4R_SURFACE_PUZZLE, src, dst));')
m('render-matched-role', 'constant', 'OP(add_blit(out, E4R_LABEL_MATCHED, E4R_SURFACE_PUZZLE, src, dst));', 'OP(add_blit(out, E4R_LABEL_MATCHED, E4R_SURFACE_SCORE, src, dst));')
m('render-cell-dst-rect', 'rect', 'dst[3] = e4r_rd32(o, cell + CELL_RECT + 12);', 'dst[3] = e4r_rd32(o, cell + CELL_RECT + 8);')
m('render-cell-order-col-major', 'order', '    for (r = 0; r < rows; ++r)\n        for (c = 0; c < cols; ++c) {\n            const size_t cell = cell_at(r, c);\n            if (o->b[cell + CELL_PRESENT] == 0) continue;',
  '    for (c = 0; c < cols; ++c)\n        for (r = 0; r < rows; ++r) {\n            const size_t cell = cell_at(r, c);\n            if (o->b[cell + CELL_PRESENT] == 0) continue;')
m('render-name-panel', 'predicate', 'if (body[B_NAME_PANEL] != 0) {\n        int32_t rect[4], icon[4];', 'if (body[B_NAME_PANEL] == 0) {\n        int32_t rect[4], icon[4];')
m('render-name-rect-field', 'rect', 'body_rect(body, B_NAME_RECT, rect);', 'body_rect(body, B_TIME_RECT, rect);')
m('render-icon-rect-field', 'rect', 'body_rect(body, B_ICON_RECT, icon);', 'body_rect(body, B_NAME_RECT, icon);')
m('render-name-hidden-dirty-test', 'predicate', 'if (o->b[E4R_O_SHOW_NAME] == 0) {\n            if (o->b[E4R_O_NAME_DIRTY] != 0) {', 'if (o->b[E4R_O_SHOW_NAME] != 0) {\n            if (o->b[E4R_O_NAME_DIRTY] != 0) {')
m('render-name-dirty-test', 'predicate', 'if (o->b[E4R_O_NAME_DIRTY] != 0) {\n                rect_plus_view(rect, view, dst);', 'if (o->b[E4R_O_NAME_DIRTY] == 0) {\n                rect_plus_view(rect, view, dst);')
m('render-name-erase-label', 'constant', 'E4R_LABEL_NAME_ERASE, E4R_SURFACE_BACKGROUND, rect, dst', 'E4R_LABEL_ICON_ERASE, E4R_SURFACE_BACKGROUND, rect, dst')
m('render-name-erase-role', 'constant', 'E4R_LABEL_NAME_ERASE, E4R_SURFACE_BACKGROUND, rect, dst', 'E4R_LABEL_NAME_ERASE, E4R_SURFACE_PUZZLE, rect, dst')
m('render-icon-erase-label', 'constant', 'E4R_LABEL_ICON_ERASE, E4R_SURFACE_BACKGROUND, icon, dst', 'E4R_LABEL_NAME_ERASE, E4R_SURFACE_BACKGROUND, icon, dst')
m('render-icon-erase-skipped', 'missing-effect', '                rect_plus_view(icon, view, dst);\n                OP(add_blit(out, E4R_LABEL_ICON_ERASE, E4R_SURFACE_BACKGROUND, icon, dst));\n', '')
m('render-name-dirty-kept', 'missing-effect', 'o->b[E4R_O_NAME_DIRTY] = 0;\n            }\n        } else {', '(void)0;\n            }\n        } else {')
m('render-name-text-rect', 'rect', 'OP(add_text(out, o->b + E4R_O_NAME_TEXT, rect, body, view));', 'OP(add_text(out, o->b + E4R_O_NAME_TEXT, icon, body, view));')
m('render-name-text-field', 'rect', 'OP(add_text(out, o->b + E4R_O_NAME_TEXT, rect, body, view));', 'OP(add_text(out, o->b + E4R_O_TIME_TEXT, rect, body, view));')
m('render-name-icon-src', 'rect', 'src[0] = e4r_rd32(o, E4R_O_ICON_RECT);\n            src[1]', 'src[0] = e4r_rd32(o, E4R_O_ICON_RECT + 4);\n            src[1]')
m('render-name-icon-label', 'constant', 'OP(add_blit(out, E4R_LABEL_NAME_ICON, E4R_SURFACE_PUZZLE, src, dst));', 'OP(add_blit(out, E4R_LABEL_PIECE, E4R_SURFACE_PUZZLE, src, dst));')
m('render-name-icon-role', 'constant', 'OP(add_blit(out, E4R_LABEL_NAME_ICON, E4R_SURFACE_PUZZLE, src, dst));', 'OP(add_blit(out, E4R_LABEL_NAME_ICON, E4R_SURFACE_BACKGROUND, src, dst));')
m('render-name-icon-dst', 'rect', '            rect_plus_view(icon, view, dst);\n            src[0] = e4r_rd32(o, E4R_O_ICON_RECT);', '            rect_plus_view(rect, view, dst);\n            src[0] = e4r_rd32(o, E4R_O_ICON_RECT);')
m('render-score-panel', 'predicate', 'if (body[B_SCORE_PANEL] != 0) {', 'if (body[B_SCORE_PANEL] == 0) {')
m('render-score-rect-field', 'rect', 'body_rect(body, B_SCORE_RECT, rect);', 'body_rect(body, B_TARGET_RECT, rect);')
m('render-score-dirty-test', 'predicate', 'if (o->b[E4R_O_SCORE_DIRTY] != 0) {\n            rect_plus_view', 'if (o->b[E4R_O_SCORE_DIRTY] == 0) {\n            rect_plus_view')
m('render-score-erase-label', 'constant', 'E4R_LABEL_SCORE_ERASE, E4R_SURFACE_BACKGROUND, rect, dst', 'E4R_LABEL_TIME_ERASE, E4R_SURFACE_BACKGROUND, rect, dst')
m('render-score-erase-role', 'constant', 'E4R_LABEL_SCORE_ERASE, E4R_SURFACE_BACKGROUND, rect, dst', 'E4R_LABEL_SCORE_ERASE, E4R_SURFACE_SCORE, rect, dst')
m('render-score-dirty-kept', 'missing-effect', 'o->b[E4R_O_SCORE_DIRTY] = 0;\n        }\n        OP(add_text(out, o->b + E4R_O_SCORE_TEXT, rect, body, view));', '(void)0;\n        }\n        OP(add_text(out, o->b + E4R_O_SCORE_TEXT, rect, body, view));')
m('render-score-text-only-dirty', 'predicate', '        }\n        OP(add_text(out, o->b + E4R_O_SCORE_TEXT, rect, body, view));\n    }\n\n    if (o->b[E4R_O_TIME_TEXT] != 0) {', '            OP(add_text(out, o->b + E4R_O_SCORE_TEXT, rect, body, view));\n        }\n    }\n\n    if (o->b[E4R_O_TIME_TEXT] != 0) {')
m('render-time-test', 'predicate', 'if (o->b[E4R_O_TIME_TEXT] != 0) {', 'if (o->b[E4R_O_TIME_TEXT] == 0) {')
m('render-time-rect-field', 'rect', 'body_rect(body, B_TIME_RECT, rect);', 'body_rect(body, B_SCORE_RECT, rect);')
m('render-time-erase-label', 'constant', 'E4R_LABEL_TIME_ERASE, E4R_SURFACE_BACKGROUND, rect, dst', 'E4R_LABEL_SCORE_ERASE, E4R_SURFACE_BACKGROUND, rect, dst')
m('render-time-erase-role', 'constant', 'E4R_LABEL_TIME_ERASE, E4R_SURFACE_BACKGROUND, rect, dst', 'E4R_LABEL_TIME_ERASE, E4R_SURFACE_PUZZLE, rect, dst')
m('render-time-erase-skipped', 'missing-effect', '        OP(add_blit(out, E4R_LABEL_TIME_ERASE, E4R_SURFACE_BACKGROUND, rect, dst));\n', '')
m('render-time-text-order', 'order', '        OP(add_blit(out, E4R_LABEL_TIME_ERASE, E4R_SURFACE_BACKGROUND, rect, dst));\n        OP(add_text(out, o->b + E4R_O_TIME_TEXT, rect, body, view));',
  '        OP(add_text(out, o->b + E4R_O_TIME_TEXT, rect, body, view));\n        OP(add_blit(out, E4R_LABEL_TIME_ERASE, E4R_SURFACE_BACKGROUND, rect, dst));')
m('render-shuffle-down-test', 'predicate', 'if (o->b[E4R_O_SHUFFLE_DOWN] == 0) {\n            if (o->b[E4R_O_SHUFFLE_DIRTY] != 0) {', 'if (o->b[E4R_O_SHUFFLE_DOWN] != 0) {\n            if (o->b[E4R_O_SHUFFLE_DIRTY] != 0) {')
m('render-shuffle-dirty-test', 'predicate', 'if (o->b[E4R_O_SHUFFLE_DIRTY] != 0) {\n                rect_plus_view(rect, view, dst);', 'if (o->b[E4R_O_SHUFFLE_DIRTY] == 0) {\n                rect_plus_view(rect, view, dst);')
m('render-shuffle-erase-label', 'constant', 'E4R_LABEL_SHUFFLE_ERASE, E4R_SURFACE_BACKGROUND, rect, dst', 'E4R_LABEL_TIME_ERASE, E4R_SURFACE_BACKGROUND, rect, dst')
m('render-shuffle-erase-role', 'constant', 'E4R_LABEL_SHUFFLE_ERASE, E4R_SURFACE_BACKGROUND, rect, dst', 'E4R_LABEL_SHUFFLE_ERASE, E4R_SURFACE_PUZZLE, rect, dst')
m('render-shuffle-dirty-kept', 'missing-effect', 'o->b[E4R_O_SHUFFLE_DIRTY] = 0;\n            }\n        } else {', '(void)0;\n            }\n        } else {')
m('render-shuffle-down-src', 'rect', 'body_rect(body, B_SHUFFLE_SRC, src);\n            OP(add_blit(out, E4R_LABEL_SHUFFLE_DOWN', 'body_rect(body, B_MATCHED_SRC, src);\n            OP(add_blit(out, E4R_LABEL_SHUFFLE_DOWN')
m('render-shuffle-down-label', 'constant', 'E4R_LABEL_SHUFFLE_DOWN, E4R_SURFACE_PUZZLE, src, dst', 'E4R_LABEL_SHUFFLE_ERASE, E4R_SURFACE_PUZZLE, src, dst')
m('render-shuffle-down-role', 'constant', 'E4R_LABEL_SHUFFLE_DOWN, E4R_SURFACE_PUZZLE, src, dst', 'E4R_LABEL_SHUFFLE_DOWN, E4R_SURFACE_BACKGROUND, src, dst')
m('render-shuffle-rect-field', 'rect', '        body_rect(body, B_SHUFFLE_RECT, rect);\n        if (o->b[E4R_O_SHUFFLE_DOWN] == 0) {', '        body_rect(body, B_TARGET_RECT, rect);\n        if (o->b[E4R_O_SHUFFLE_DOWN] == 0) {')
m('render-title-test', 'predicate', 'if (body[B_TITLE] != 0) {', 'if (body[B_TITLE] == 0) {')
m('render-title-rect-field', 'rect', 'body_rect(body, B_TITLE_RECT, rect);', 'body_rect(body, B_TARGET_RECT, rect);')
m('render-title-text-field', 'rect', 'OP(add_text(out, body + B_TITLE, rect, body, view));', 'OP(add_text(out, body, rect, body, view));')
m('render-target-test', 'predicate', 'if (o->b[E4R_O_TARGET_TEXT] != 0) {', 'if (o->b[E4R_O_TARGET_TEXT] == 0) {')
m('render-target-rect-field', 'rect', 'body_rect(body, B_TARGET_RECT, rect);', 'body_rect(body, B_TITLE_RECT, rect);')
m('render-target-text-field', 'rect', 'OP(add_text(out, o->b + E4R_O_TARGET_TEXT, rect, body, view));', 'OP(add_text(out, o->b + E4R_O_SCORE_TEXT, rect, body, view));')
m('render-order-title-target', 'order', '    if (body[B_TITLE] != 0) {\n        int32_t rect[4];\n        body_rect(body, B_TITLE_RECT, rect);\n        OP(add_text(out, body + B_TITLE, rect, body, view));\n    }\n    if (o->b[E4R_O_TARGET_TEXT] != 0) {\n        int32_t rect[4];\n        body_rect(body, B_TARGET_RECT, rect);\n        OP(add_text(out, o->b + E4R_O_TARGET_TEXT, rect, body, view));\n    }',
  '    if (o->b[E4R_O_TARGET_TEXT] != 0) {\n        int32_t rect[4];\n        body_rect(body, B_TARGET_RECT, rect);\n        OP(add_text(out, o->b + E4R_O_TARGET_TEXT, rect, body, view));\n    }\n    if (body[B_TITLE] != 0) {\n        int32_t rect[4];\n        body_rect(body, B_TITLE_RECT, rect);\n        OP(add_text(out, body + B_TITLE, rect, body, view));\n    }')
# ---- text and blit helpers
m('text-empty', 'predicate', 'if (text[0] == 0) return E4R_OK;', 'if (0) return E4R_OK;')
m('text-font', 'rect', 'op->font = bs16(body, B_FONT);', 'op->font = bs16(body, B_FONT_PARAM);')
m('text-param', 'rect', 'op->param = bs16(body, B_FONT_PARAM);', 'op->param = bs16(body, B_FONT);')
m('text-x-view', 'rect', 'op->x = (int16_t)wrap_add(rect[0], view[0]);', 'op->x = (int16_t)rect[0];')
m('text-y-view', 'rect', 'op->y = (int16_t)wrap_add(rect[3], view[1]);', 'op->y = (int16_t)rect[3];')
m('text-y-top', 'rect', 'op->y = (int16_t)wrap_add(rect[3], view[1]);', 'op->y = (int16_t)wrap_add(rect[1], view[1]);')
m('text-x-right', 'rect', 'op->x = (int16_t)wrap_add(rect[0], view[0]);', 'op->x = (int16_t)wrap_add(rect[2], view[0]);')
m('text-x-no-truncation', 'signedness', 'op->x = (int16_t)wrap_add(rect[0], view[0]);', 'op->x = wrap_add(rect[0], view[0]);')
m('text-y-no-truncation', 'signedness', 'op->y = (int16_t)wrap_add(rect[3], view[1]);', 'op->y = wrap_add(rect[3], view[1]);')
m('rect-plus-view-x2', 'rect', 'd[2] = wrap_add(r[2], view[0]);', 'd[2] = r[2];')
m('rect-plus-view-y2', 'rect', 'd[3] = wrap_add(r[3], view[1]);', 'd[3] = r[3];')
m('rect-plus-view-x0', 'rect', 'd[0] = wrap_add(r[0], view[0]);', 'd[0] = r[0];')
m('rect-plus-view-y0', 'rect', 'd[1] = wrap_add(r[1], view[1]);', 'd[1] = r[1];')
m('rect-plus-view-swapped', 'rect', 'd[1] = wrap_add(r[1], view[1]);', 'd[1] = wrap_add(r[1], view[0]);')
m('body-rect-order', 'rect', 'r[1] = bs32(body, off + 4);\n    r[2] = bs32(body, off + 8);', 'r[2] = bs32(body, off + 4);\n    r[1] = bs32(body, off + 8);')
m('blit-surface-role', 'rect', 'op->surface_role = role;', 'op->surface_role = 0;')
m('blit-src-dst-swapped', 'rect', 'memcpy(op->src, src, sizeof op->src);\n    memcpy(op->dst, dst, sizeof op->dst);', 'memcpy(op->src, dst, sizeof op->src);\n    memcpy(op->dst, src, sizeof op->dst);')
m('set-number-text-signed', 'signedness', 'snprintf(buf, sizeof buf, "%u", (unsigned)v);', 'snprintf(buf, sizeof buf, "%d", (int)v);')
m('set-text-terminator', 'compare', 'memcpy(o->b + off, s, strlen(s) + 1u);', 'memcpy(o->b + off, s, strlen(s));')
m('set-text-bytes-terminator', 'compare', 'memcpy(o->b + off, s, strlen((const char *)s) + 1u);', 'memcpy(o->b + off, s, strlen((const char *)s));')
m('object-reset-slot', 'constant', 'ob16(object, E4R_O_SLOT, -1);\n    ob16(object, E4R_O_ROW, -1);\n}', 'ob16(object, E4R_O_ROW, -1);\n}')
m('scene-reset-marker', 'missing-effect', 'world->high_score_marker_5a0545 = 0;\n', '')
m('scene-reset-table', 'loop-bound', 'for (i = 0; i < E4R_HIGH_SCORES; ++i) world->high_score[i] = 0;', 'for (i = 0; i < E4R_HIGH_SCORES - 1; ++i) world->high_score[i] = 0;')


# Mutants proved equivalent by reading the code: they cannot change any observable behaviour, so a surviving run is the expected
# result. They are reported separately and never count as killed.
EQUIVALENT = {
    'fill-view-every-cell': 'view_rects is a pure query; the original reads the view rectangle from process memory, so how many times the host answers is not observable (the values read are compared)',
    'match-up-compare-cell': 'the vertical scan runs before the horizontal one, so cmin still equals col while cell_at(rmin, cmin) is read',
    'p1-state-guard': 'state 7 has no case in the switch, so the extra pass through the guard does nothing',
    'p1-state-guard-signed': 'a negative state matches no case of the switch, exactly as the unsigned guard returns early',
    'render-scores-high-row-top': 'add_text reads only rect[0] and rect[3]; the top coordinate high_rect[1] is never used',
    'text-x-no-truncation': 'E4rOp.x is an int16_t field, so the explicit cast to int16_t changes nothing',
    'text-y-no-truncation': 'E4rOp.y is an int16_t field, so the explicit cast to int16_t changes nothing',
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
    try:
        done = subprocess.run(cmd, capture_output=True, text=True, cwd=str(HERE), timeout=1500)
    except subprocess.TimeoutExpired:
        return 'KILLED', 'timeout (the mutant hangs or loops: observed as a failure)'
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
    for h in (PROJECT / 'src').glob('action_family_e4_runtime*.h'):
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
    work = Path(tempfile.mkdtemp(prefix='e4_mut_'))
    t0 = time.monotonic()
    todo = [(name, cls, old, new, count, which, kernel_text, work, a.stage) for name, cls, old, new, count, which in M
            if not a.only or any(o in name for o in a.only.split(','))]
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
