#!/usr/bin/env python3
"""RT-60 mutation check for the raw-0xee oracle (Memory puzzle runtime).

Every mutant is a one-site textual edit of a COPY of src/action_family_ee_runtime.c or src/action_family_ee_runtime.h (the project files are
never touched). The sites are generated mechanically from the code text (comments, strings and character literals masked):
  * relational / logical operator flips (== != < <= > >= && ||), binary + and - flips, removal of a logical not,
  * every integer literal changed by +1 (0 -> 1, 1 -> 2, ...), every character literal changed to its successor,
  * deletion of every simple statement (assignment, call, break) replaced by `;`,
plus the hand-written mutants in CURATED (semantic one-site edits the mechanical operators do not reach).
Each mutant is built into a driver library and run through the original-x86 oracle (action_family_ee_runtime_original_oracle.py, `--src DIR`).
A mutant is KILLED when the oracle reports at least one mismatch against the unmodified GAME.EXE image (or one of its native-only checks
fails, or the run crashes / hangs); it SURVIVES when the oracle still reports 0 mismatches; it is INVALID if the driver does not compile
(invalid mutants are listed, never counted as killed). Equivalent mutants (EQUIVALENT below, each with a reason read from the kernel and the
original) are reported separately and are not counted in the kill rate; an EQUIVALENT mutant that is KILLED is reported as killed.

Usage:  python3 action_family_ee_runtime_mutation_check.py [--stage quick|full] [--only TEXT] [--jobs N] [--result FILE] [--list]
Stage `quick` (default) runs the oracle's --quick-only subset (plus the native checks); the survivors are re-run on the full scenario set.
--stage full runs every mutant on the full set. Mutants run in parallel, one oracle per mutant (--jobs, default 4).
"""
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
import threading
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
ROOT = PROJECT.parents[1]
ORACLE = HERE / 'action_family_ee_runtime_original_oracle.py'
FILES = ('action_family_ee_runtime.c', 'action_family_ee_runtime.h')

# (name, file, old text, new text, expected occurrences of old text, index of the occurrence to edit): hand-written semantic mutants
C = FILES[0]
CURATED = [
    ('no-sound-exact-case', C, "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'n', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", 1, 0),
    ('no-sound-exact-8-bytes', C, 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8) == 0;', 1, 0),
    ('no-sound-exact-prefix-7', C, 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 7) == 0;', 1, 0),
    ('no-sound-ci-case-sensitive', C, "if (a >= 'A' && a <= 'Z') a += 0x20u;\n        if (b >= 'A' && b <= 'Z') b += 0x20u;",
     "if (b >= 'A' && b <= 'Z') b += 0x20u;", 1, 0),
    ('no-sound-ci-lower-bound', C, "if (a >= 'A' && a <= 'Z') a += 0x20u;", "if (a > 'A' && a <= 'Z') a += 0x20u;", 1, 0),
    ('no-sound-ci-upper-bound', C, "if (a >= 'A' && a <= 'Z') a += 0x20u;", "if (a >= 'A' && a < 'Z') a += 0x20u;", 1, 0),
    ('no-sound-ci-upper-bound-wide', C, "if (a >= 'A' && a <= 'Z') a += 0x20u;", "if (a >= 'A' && a <= '[') a += 0x20u;", 1, 0),
    ('no-sound-ci-lower-bound-wide', C, "if (a >= 'A' && a <= 'Z') a += 0x20u;", "if (a >= '@' && a <= 'Z') a += 0x20u;", 1, 0),
    ('no-sound-ci-prefix', C, 'if (a == 0) return 1;', 'if (a == 0 || i == 7) return 1;', 1, 0),
    ('no-sound-ci-ignores-nul', C, 'if (a != b) return 0;\n        if (a == 0) return 1;', 'if (a != b && a != 0) return 0;\n        if (a == 0) return 1;', 1, 0),
    ('no-sound-ci-first-only', C, 'if (a == 0) return 1;\n        ++i;', 'return 1;\n        ++i;', 1, 0),
    ('cell-index-lower-bound', C, 'if (ptr < MP_GUEST_CELLS) return -1;', 'if (ptr <= MP_GUEST_CELLS - 1000) return -1;', 1, 0),
    ('cell-index-misaligned', C, 'if (d % MP_CELL_BYTES != 0u || ', 'if (', 1, 0),
    ('cell-index-max', C, 'd / MP_CELL_BYTES >= (uint32_t)MP_MAX_CELLS) return -1;', 'd / MP_CELL_BYTES > (uint32_t)MP_MAX_CELLS) return -1;', 1, 0),
    ('cell-index-no-max', C, ' || d / MP_CELL_BYTES >= (uint32_t)MP_MAX_CELLS) return -1;', ') return -1;', 1, 0),
    ('reset-row', C, 'wr_16(b, O_ROW, -1);\n    wr_16(b, O_SLOT, -1);\n}\n\n/* 0x47b23b', 'wr_16(b, O_ROW, 0);\n    wr_16(b, O_SLOT, -1);\n}\n\n/* 0x47b23b', 1, 0),
    ('reset-slot', C, 'wr_16(b, O_SLOT, -1);\n}\n\n/* 0x47b23b', 'wr_16(b, O_SLOT, 0);\n}\n\n/* 0x47b23b', 1, 0),
    ('clear-keeps-body', C, 'wr_32(b, O_BODY, 0);\n    wr_32(b, O_ACTIVE, 0);', 'wr_32(b, O_ACTIVE, 0);', 1, 0),
    ('clear-keeps-redraw', C, 'wr_32(b, O_REDRAW, 0);\n    wr_32(b, O_FLIPBACK, 0);\n    wr_32(b, O_UNUSED, 0);', 'wr_32(b, O_FLIPBACK, 0);\n    wr_32(b, O_UNUSED, 0);', 1, 0),
    ('clear-keeps-flipback', C, 'wr_32(b, O_FLIPBACK, 0);\n    wr_32(b, O_UNUSED, 0);', 'wr_32(b, O_UNUSED, 0);', 1, 0),
    ('clear-keeps-first', C, 'wr_32(b, O_FIRST, 0);\n    wr_32(b, O_SECOND, 0);\n    wr_32(b, O_PER_PAGE, 0);', 'wr_32(b, O_SECOND, 0);\n    wr_32(b, O_PER_PAGE, 0);', 1, 0),
    ('clear-keeps-second', C, 'wr_32(b, O_SECOND, 0);\n    wr_32(b, O_PER_PAGE, 0);', 'wr_32(b, O_PER_PAGE, 0);', 1, 0),
    ('clear-keeps-half-page', C, 'wr_32(b, O_HALF_PAGE, 0);\n    wr_32(b, O_SLOTS, 0);', 'wr_32(b, O_SLOTS, 0);', 1, 0),
    ('clear-keeps-slots', C, 'wr_32(b, O_SLOTS, 0);\n    wr_32(b, O_NEEDED, 0);', 'wr_32(b, O_NEEDED, 0);', 1, 0),
    ('clear-keeps-page', C, 'wr_32(b, O_PAGE, 0);\n    wr_32(b, O_IDS, 0);\n}', 'wr_32(b, O_IDS, 0);\n}', 1, 0),
    ('clear-keeps-ids', C, 'wr_32(b, O_PAGE, 0);\n    wr_32(b, O_IDS, 0);\n}', 'wr_32(b, O_PAGE, 0);\n}', 1, 0),
    ('clear-clears-state', C, 'wr_32(b, O_IDS, 0);\n}', 'wr_32(b, O_IDS, 0);\n    wr_32(b, O_STATE, 0);\n}', 1, 0),
    ('clear-clears-deadline', C, 'wr_32(b, O_IDS, 0);\n}', 'wr_32(b, O_IDS, 0);\n    wr_32(b, O_DEADLINE, 0);\n}', 1, 0),
    ('clear-clears-pairs', C, 'wr_32(b, O_IDS, 0);\n}', 'wr_32(b, O_IDS, 0);\n    wr_32(b, O_PAIRS, 0);\n}', 1, 0),
    ('clear-clears-hit', C, 'wr_32(b, O_IDS, 0);\n}', 'wr_32(b, O_IDS, 0);\n    wr_32(b, O_HIT, 0);\n}', 1, 0),
    ('clear-clears-snd-win', C, 'wr_32(b, O_IDS, 0);\n}', 'wr_32(b, O_IDS, 0);\n    wr_32(b, O_SND_WIN, 0);\n}', 1, 0),
    ('active-test-nonzero', C, 'int mp_object_active(const MpObject *object) { return rd_s32(object->b, O_ACTIVE) != 0; }',
     'int mp_object_active(const MpObject *object) { return rd_s32(object->b, O_ACTIVE) == 1; }', 1, 0),
    ('terminated-span', C, 'return memchr(body + off, 0, span) != NULL;', 'return memchr(body + off, 0, span - 1) != NULL;', 1, 0),
    ('scaled-float-single', C, 'const double q = (double)(float)pct / 100.0;\n    const double p = q * (double)(float)count;',
     'const double q = (double)(float)pct / 100.0;\n    const double p = (double)(float)(q * (double)(float)count);', 1, 0),
    ('scaled-double-pct', C, 'const double q = (double)(float)pct / 100.0;', 'const double q = (double)pct / 100.0;', 1, 0),
    ('scaled-double-count', C, 'const double p = q * (double)(float)count;', 'const double p = q * (double)count;', 1, 0),
    ('scaled-single-quotient', C, 'const double q = (double)(float)pct / 100.0;', 'const double q = (double)(float)((double)(float)pct / 100.0);', 1, 0),
    ('scaled-round', C, '*out = (int32_t)p;', '*out = (int32_t)(p + 0.5);', 1, 0),
    ('scaled-floor', C, '*out = (int32_t)p;', '*out = (int32_t)(p < 0 ? p - 0.5 : p);', 1, 0),
    ('validate-name-span', C, 'field_terminated(body, B_NAME, 0x21)', 'field_terminated(body, B_NAME, 0x20)', 1, 0),
    ('validate-page-bound', C, 'pages > MP_MAX_PAGES) why', 'pages >= MP_MAX_PAGES) why', 1, 0),
    ('validate-col-bound', C, 'cols > 6) why', 'cols > 5) why', 1, 0),
    ('validate-row-bound', C, 'rows > 4) why', 'rows > 3) why', 1, 0),
    ('validate-slot-col-bound', C, 'sc > 6) why', 'sc > 5) why', 1, 0),
    ('validate-slot-row-bound', C, 'sr > 2) why', 'sr > 1) why', 1, 0),
    ('validate-shuffle-ignores-pages', C, 'const int shuffle_all = pages > 1 && body[B_SHUFFLE_ALL] != 0;', 'const int shuffle_all = body[B_SHUFFLE_ALL] != 0;', 1, 0),
    ('validate-shuffle-always', C, 'const int shuffle_all = pages > 1 && body[B_SHUFFLE_ALL] != 0;', 'const int shuffle_all = pages > 1;', 1, 0),
    ('validate-odd-per-page-only', C, '(shuffle_all ? per_page * pages : per_page) % 2 != 0', 'per_page % 2 != 0', 1, 0),
    ('validate-odd-total-always', C, '(shuffle_all ? per_page * pages : per_page) % 2 != 0', '(per_page * pages) % 2 != 0', 1, 0),
    ('validate-needed-count', C, 'per_page * pages / 2, &t)', 'per_page / 2, &t)', 1, 0),
    ('validate-needed-sentinel', C, 'rd_s32(body, B_PCT_NEEDED) != -1 && !scaled', 'rd_s32(body, B_PCT_NEEDED) != 0 && !scaled', 1, 0),
    ('validate-ids-count', C, 'scaled(rd_s32(body, B_PCT_IDS), sc * sr, &t)', 'scaled(rd_s32(body, B_PCT_IDS), sc + sr, &t)', 1, 0),
    ('validate-short-body', C, 'length < MP_BODY_BYTES) {', 'length + 1 < MP_BODY_BYTES) {', 1, 0),
    ('validate-sound-lists-flip1', C, '{B_SND_FLIP1, 1}, ', '', 1, 0),
    ('validate-sound-lists-flip2', C, '{B_SND_FLIP2, 1}, ', '', 1, 0),
    ('validate-sound-lists-match', C, '{B_SND_MATCH, 5}, ', '', 1, 0),
    ('validate-sound-lists-wrong', C, '{B_SND_WRONG, 10}, ', '', 1, 0),
    ('validate-sound-lists-win-short', C, '{B_SND_WIN, 10}}', '{B_SND_WIN, 9}}', 1, 0),
    ('validate-sound-lists-wrong-short', C, '{B_SND_WRONG, 10}', '{B_SND_WRONG, 9}', 1, 0),
    ('validate-sound-lists-match-short', C, '{B_SND_MATCH, 5}', '{B_SND_MATCH, 4}', 1, 0),
    ('validate-key-span', C, 'field_terminated(body, r + SND_KEY, SND_KEY_BYTES)', 'field_terminated(body, r + SND_KEY, SND_KEY_BYTES - 1)', 1, 0),
    ('validate-text-span', C, 'field_terminated(body, r + SND_TEXT, SND_TEXT_BYTES)', 'field_terminated(body, r + SND_TEXT, SND_TEXT_BYTES - 1)', 1, 0),
    ('validate-snd-name-span', C, 'field_terminated(body, r + SND_NAME, 0x21)', 'field_terminated(body, r + SND_NAME, 0x20)', 1, 0),
    ('validate-wrong-failure-kept', C, 'if (failure != NULL) *failure = why;', 'if (failure != NULL) *failure = "0xee-pages";', 1, 0),
    ('caption-limit', C, 'if (n + 7u > sizeof buf) return MP_ERR_BOUNDS;', 'if (n + 7u >= sizeof buf) return MP_ERR_BOUNDS;', 1, 0),
    ('caption-limit-loose', C, 'if (n + 7u > sizeof buf) return MP_ERR_BOUNDS;', 'if (n + 8u > sizeof buf) return MP_ERR_BOUNDS;', 1, 0),
    ('caption-suffix', C, 'memcpy(buf + n, "<n><e>", 7);', 'memcpy(buf + n, "<n><E>", 7);', 1, 0),
    ('caption-suffix-short', C, 'memcpy(buf + n, "<n><e>", 7);', 'memcpy(buf + n, "<n><e>", 6);', 1, 0),
    ('caption-failure-ignored', C, 'return host->caption_show(host->context, buf) != 0 ? MP_ERR_HOST : MP_OK;', 'host->caption_show(host->context, buf); return MP_OK;', 1, 0),
    ('play-no-sound-test-exact', C, 'if (!no_sound_ci(rec + SND_NAME)) {\n        HOST(host->sound_prepare', 'if (!no_sound_exact(rec + SND_NAME)) {\n        HOST(host->sound_prepare', 1, 0),
    ('play-prepare-id', C, 'host->sound_prepare(host->context, (uint32_t)id, rec)', 'host->sound_prepare(host->context, (uint32_t)id + 1u, rec)', 1, 0),
    ('play-channel', C, 'host->sound_play(host->context, rd_s16(rec, SND_CHANNEL))', 'host->sound_play(host->context, rd_s16(rec, SND_CHANNEL) + 1)', 1, 0),
    ('play-prepare-skipped-no-play', C, 'HOST(host->sound_play(host->context, rd_s16(rec, SND_CHANNEL)));', '', 1, 0),
    ('play-caption-key-test', C, 'if (rec[SND_KEY] != 0) {', 'if (rec[SND_KEY] != 0 && rec[SND_TEXT] == 0) {', 1, 0),
    ('play-caption-text-fallback-always', C, 'if (!shown && rec[SND_TEXT] != 0)', 'if (rec[SND_TEXT] != 0)', 1, 0),
    ('play-caption-text-never', C, 'if (!shown && rec[SND_TEXT] != 0) CHECK(show_caption(host, (const char *)rec + SND_TEXT));', '', 1, 0),
    ('play-caption-text-test', C, 'if (!shown && rec[SND_TEXT] != 0)', 'if (!shown)', 1, 0),
    ('play-caption-enabled-test', C, 'if (enabled == 0) return MP_OK;', 'if (enabled == 1) return MP_OK;', 1, 0),
    ('play-caption-autotext-limit', C, 'strlen(t) < (size_t)CAPTION_TEXT_MAX + 1u', 'strlen(t) < (size_t)CAPTION_TEXT_MAX', 1, 0),
    ('play-caption-autotext-limit-loose', C, 'strlen(t) < (size_t)CAPTION_TEXT_MAX + 1u', 'strlen(t) < (size_t)CAPTION_TEXT_MAX + 2u', 1, 0),
    ('play-caption-autotext-empty', C, 't != NULL && strlen(t)', 't != NULL && t[0] != 0 && strlen(t)', 1, 0),
    ('play-caption-autotext-null-falls', C, 'if (t != NULL && strlen(t)', 'if (t == NULL || strlen(t)', 1, 0),
    ('play-caption-key-pointer', C, 'host->autotext_lookup(host->context, (const char *)rec + SND_KEY, &t)', 'host->autotext_lookup(host->context, (const char *)rec + SND_TEXT, &t)', 1, 0),
    ('play-caption-text-pointer', C, 'show_caption(host, (const char *)rec + SND_TEXT)', 'show_caption(host, (const char *)rec + SND_KEY)', 1, 0),
    ('pick-found-requires-last', C, 'for (int i = 0; i < count && !found; ++i)', 'for (int i = 0; i < count - 1 && !found; ++i)', 1, 0),
    ('pick-found-exact', C, 'if (!no_sound_ci(body + base + (size_t)i * MP_SOUND_RECORD_BYTES + SND_NAME)) found = 1;', 'if (!no_sound_exact(body + base + (size_t)i * MP_SOUND_RECORD_BYTES + SND_NAME)) found = 1;', 1, 0),
    ('pick-draw-exact', C, '} while (no_sound_ci(body + base + (size_t)rd_s32(b, field)', '} while (no_sound_exact(body + base + (size_t)rd_s32(b, field)', 1, 0),
    ('pick-modulo-count', C, 'host->random(host->context) % count);', 'host->random(host->context) % (count - 1));', 1, 0),
    ('pick-first-draw-skipped', C, 'wr_32(b, field, host->random(host->context) % count);', 'wr_32(b, field, (host->random(host->context) + 1) % count);', 1, 0),
    ('pick-no-initial-minus-one', C, 'wr_32(b, field, -1);\n    for (int i = 0; i < count', 'for (int i = 0; i < count', 1, 0),
    ('pick-field-not-stored', C, 'wr_32(b, field, host->random(host->context) % count);\n        } while', 'wr_32(b, field, 0 * host->random(host->context) % count);\n        } while', 1, 0),
    ('pick-id-any-free-first-only', C, 'for (int32_t j = 0; j < ids; ++j)\n        if (rd_s32(o->used, (size_t)j * 4u) == 0) {', 'for (int32_t j = 0; j < 1; ++j)\n        if (rd_s32(o->used, (size_t)j * 4u) == 0) {', 1, 0),
    ('pick-id-any-free-last-skipped', C, 'for (int32_t j = 0; j < ids; ++j)\n        if (rd_s32(o->used, (size_t)j * 4u) == 0) {', 'for (int32_t j = 0; j < ids - 1; ++j)\n        if (rd_s32(o->used, (size_t)j * 4u) == 0) {', 1, 0),
    ('pick-id-all-used-marks', C, '*id = host->random(host->context) % ids;\n        return MP_OK;', '*id = host->random(host->context) % ids;\n        wr_32(o->used, (size_t)*id * 4u, 1);\n        return MP_OK;', 1, 0),
    ('pick-id-no-mark', C, '    wr_32(o->used, (size_t)*id * 4u, 1);\n    return MP_OK;', '    return MP_OK;', 1, 0),
    ('pick-id-modulo', C, '*id = host->random(host->context) % ids;\n    } while', '*id = host->random(host->context) % (ids - 1);\n    } while', 1, 0),
    ('draw-partner-first-draw-modulo', C, 'r = host->random(host->context) % span;', 'r = host->random(host->context) % (span > 2 ? span - 1 : span);', 1, 0),
    ('draw-partner-undealt-test', C, 'if (rd_s32(cell_at(o, *cell), 0) == -1) return MP_OK;', 'if (rd_s32(cell_at(o, *cell), 0) <= -1) return MP_OK;', 1, 0),
    ('draw-partner-accepts-dealt', C, 'if (rd_s32(cell_at(o, *cell), 0) == -1) return MP_OK;', 'if (rd_s32(cell_at(o, *cell), 0) != 0) return MP_OK;', 1, 0),
    ('draw-partner-first', C, '*cell = first + r;', '*cell = r;', 1, 0),
    ('deal-cell-flipped-init', C, 'wr_32(c, 4, 0);\n        wr_32(c, 8, 0);', 'wr_32(c, 4, 0);\n        wr_32(c, 8, 1);', 1, 0),
    ('deal-slots-product', C, 'mul32(rd_s32(body, B_SLOT_COLS), rd_s32(body, B_SLOT_ROWS))', 'mul32(rd_s32(body, B_SLOT_COLS), rd_s32(body, B_SLOT_COLS))', 1, 0),
    ('deal-ids-lower-clamp', C, 'if (rd_s32(b, O_IDS) <= 4) wr_32(b, O_IDS, 4);', 'if (rd_s32(b, O_IDS) < 4) wr_32(b, O_IDS, 4);', 1, 0),
    ('deal-ids-lower-clamp-value', C, 'if (rd_s32(b, O_IDS) <= 4) wr_32(b, O_IDS, 4);', 'if (rd_s32(b, O_IDS) <= 4) wr_32(b, O_IDS, 5);', 1, 0),
    ('deal-ids-lower-clamp-bound', C, 'if (rd_s32(b, O_IDS) <= 4) wr_32(b, O_IDS, 4);', 'if (rd_s32(b, O_IDS) <= 3) wr_32(b, O_IDS, 4);', 1, 0),
    ('deal-ids-upper-clamp', C, 'if (!(rd_s32(b, O_IDS) < rd_s32(b, O_SLOTS))) wr_32(b, O_IDS, rd_s32(b, O_SLOTS));', 'if (!(rd_s32(b, O_IDS) <= rd_s32(b, O_SLOTS))) wr_32(b, O_IDS, rd_s32(b, O_SLOTS));', 1, 0),
    ('deal-ids-upper-clamp-missing', C, 'if (!(rd_s32(b, O_IDS) < rd_s32(b, O_SLOTS))) wr_32(b, O_IDS, rd_s32(b, O_SLOTS));', '', 1, 0),
    ('deal-ids-lower-clamp-missing', C, 'if (rd_s32(b, O_IDS) <= 4) wr_32(b, O_IDS, 4);', '', 1, 0),
    ('deal-needed-lower-clamp', C, 'if (rd_s32(b, O_NEEDED) <= 2) wr_32(b, O_NEEDED, 2);', 'if (rd_s32(b, O_NEEDED) < 2) wr_32(b, O_NEEDED, 2);', 1, 0),
    ('deal-needed-lower-clamp-value', C, 'if (rd_s32(b, O_NEEDED) <= 2) wr_32(b, O_NEEDED, 2);', 'if (rd_s32(b, O_NEEDED) <= 2) wr_32(b, O_NEEDED, 3);', 1, 0),
    ('deal-needed-lower-clamp-bound', C, 'if (rd_s32(b, O_NEEDED) <= 2) wr_32(b, O_NEEDED, 2);', 'if (rd_s32(b, O_NEEDED) <= 1) wr_32(b, O_NEEDED, 2);', 1, 0),
    ('deal-needed-lower-clamp-missing', C, 'if (rd_s32(b, O_NEEDED) <= 2) wr_32(b, O_NEEDED, 2);', '', 1, 0),
    ('deal-needed-upper-clamp', C, 'if (!(rd_s32(b, O_NEEDED) < rd_s32(b, O_HALF_TOTAL))) wr_32(b, O_NEEDED, rd_s32(b, O_HALF_TOTAL));', 'if (!(rd_s32(b, O_NEEDED) <= rd_s32(b, O_HALF_TOTAL))) wr_32(b, O_NEEDED, rd_s32(b, O_HALF_TOTAL));', 1, 0),
    ('deal-needed-upper-clamp-missing', C, 'if (!(rd_s32(b, O_NEEDED) < rd_s32(b, O_HALF_TOTAL))) wr_32(b, O_NEEDED, rd_s32(b, O_HALF_TOTAL));', '', 1, 0),
    ('deal-needed-fixed-field', C, 'wr_32(b, O_NEEDED, rd_s32(body, B_NEEDED_FIXED));', 'wr_32(b, O_NEEDED, rd_s32(body, B_TRIES));', 1, 0),
    ('deal-needed-sentinel', C, 'if (rd_s32(body, B_PCT_NEEDED) == -1) {\n        wr_32(b, O_NEEDED', 'if (rd_s32(body, B_PCT_NEEDED) <= 0) {\n        wr_32(b, O_NEEDED', 1, 0),
    ('deal-needed-of-half-page', C, 'scaled(rd_s32(body, B_PCT_NEEDED), rd_s32(b, O_HALF_TOTAL), &v)', 'scaled(rd_s32(body, B_PCT_NEEDED), rd_s32(b, O_HALF_PAGE), &v)', 1, 0),
    ('deal-ids-of-total', C, 'scaled(rd_s32(body, B_PCT_IDS), rd_s32(b, O_SLOTS), &v)', 'scaled(rd_s32(body, B_PCT_IDS), rd_s32(b, O_TOTAL), &v)', 1, 0),
    ('deal-shuffle-all-ignored', C, 'if (pages == 1 || body[B_SHUFFLE_ALL] == 0) {', 'if (pages == 1 || 1) {', 1, 0),
    ('deal-shuffle-all-always', C, 'if (pages == 1 || body[B_SHUFFLE_ALL] == 0) {', 'if (pages == 1) {', 1, 0),
    ('deal-shuffle-all-flag-sense', C, 'if (pages == 1 || body[B_SHUFFLE_ALL] == 0) {', 'if (pages == 1 || body[B_SHUFFLE_ALL] != 0) {', 1, 0),
    ('deal-shuffle-all-one-page', C, 'if (pages == 1 || body[B_SHUFFLE_ALL] == 0) {', 'if (body[B_SHUFFLE_ALL] == 0) {', 1, 0),
    ('deal-page-span', C, 'CHECK(draw_partner(o, host, page * per_page, per_page, &partner));', 'CHECK(draw_partner(o, host, 0, per_page, &partner));', 1, 0),
    ('deal-page-span-total', C, 'CHECK(draw_partner(o, host, page * per_page, per_page, &partner));', 'CHECK(draw_partner(o, host, page * per_page, total, &partner));', 1, 0),
    ('deal-page-order', C, 'for (int32_t page = 0; page < pages; ++page)\n            for (int32_t col = 0; col < per_page; ++col) {', 'for (int32_t col = 0; col < per_page; ++col)\n            for (int32_t page = 0; page < pages; ++page) {', 1, 0),
    ('deal-all-order-reverse', C, 'for (int32_t i = 0; i < total; ++i)\n            if (rd_s32(cell_at(o, i), 0) == -1) {', 'for (int32_t i = total - 1; i >= 0; --i)\n            if (rd_s32(cell_at(o, i), 0) == -1) {', 1, 0),
    ('deal-partner-id', C, 'wr_32(cell_at_w(o, partner), 0, rd_s32(cell_at(o, i), 0));', 'wr_32(cell_at_w(o, partner), 0, rd_s32(cell_at(o, i), 0) ^ 1);', 1, 0),
    ('deal-partner-id-paged', C, 'wr_32(cell_at_w(o, partner), 0, rd_s32(cell_at(o, rd_s32(b, O_CELL)), 0));', 'wr_32(cell_at_w(o, partner), 0, rd_s32(cell_at(o, rd_s32(b, O_CELL)), 0) ^ 1);', 1, 0),
    ('deal-resets-tries', C, 'wr_32(b, O_TRIES, 0);\n    wr_32(b, O_PAIRS, 0);', 'wr_32(b, O_PAIRS, 0);', 1, 0),
    ('deal-resets-pairs', C, 'wr_32(b, O_TRIES, 0);\n    wr_32(b, O_PAIRS, 0);', 'wr_32(b, O_TRIES, 0);', 1, 0),
    ('deal-resets-deadline', C, 'wr_32(b, O_DEADLINE, 0);\n    wr_32(b, O_FLIPBACK, 0);\n    wr_32(b, O_PAGE, 0);\n    wr_32(b, O_REDRAW, 1);', 'wr_32(b, O_FLIPBACK, 0);\n    wr_32(b, O_PAGE, 0);\n    wr_32(b, O_REDRAW, 1);', 1, 0),
    ('deal-resets-flipback', C, 'wr_32(b, O_FLIPBACK, 0);\n    wr_32(b, O_PAGE, 0);\n    wr_32(b, O_REDRAW, 1);', 'wr_32(b, O_PAGE, 0);\n    wr_32(b, O_REDRAW, 1);', 1, 0),
    ('deal-resets-page', C, 'wr_32(b, O_PAGE, 0);\n    wr_32(b, O_REDRAW, 1);\n    return MP_OK;\n}\n\n/* 0x47b321', 'wr_32(b, O_REDRAW, 1);\n    return MP_OK;\n}\n\n/* 0x47b321', 1, 0),
    ('deal-cells-pointer', C, 'wr_32(b, O_CELLS, (int32_t)MP_GUEST_CELLS);', 'wr_32(b, O_CELLS, (int32_t)MP_GUEST_USED);', 1, 0),
    ('deal-used-pointer', C, 'wr_32(b, O_USED, (int32_t)MP_GUEST_USED);', 'wr_32(b, O_USED, (int32_t)MP_GUEST_CELLS);', 1, 0),
    ('deal-first-second-reset', C, 'wr_32(b, O_FIRST, 0);\n    wr_32(b, O_SECOND, 0);\n    wr_32(b, O_CELLS', 'wr_32(b, O_SECOND, 0);\n    wr_32(b, O_CELLS', 1, 0),
    ('deal-second-reset', C, 'wr_32(b, O_FIRST, 0);\n    wr_32(b, O_SECOND, 0);\n    wr_32(b, O_CELLS', 'wr_32(b, O_FIRST, 0);\n    wr_32(b, O_CELLS', 1, 0),
    ('deal-cells-cleared-count', C, 'for (wr_32(b, O_LOOP_I, 0); rd_s32(b, O_LOOP_I) < total; wr_32', 'for (wr_32(b, O_LOOP_I, 0); rd_s32(b, O_LOOP_I) < total - 1; wr_32', 1, 0),
    ('cleanup-surface-release-skipped', C, 'HOST(host->release_surface(host->context, rd_u32(b, O_SURFACE)));\n        wr_32(b, O_SURFACE, 0);', 'wr_32(b, O_SURFACE, 0);', 1, 0),
    ('cleanup-surface-handle', C, 'host->release_surface(host->context, rd_u32(b, O_SURFACE))', 'host->release_surface(host->context, rd_u32(b, O_SURFACE) + 1u)', 1, 0),
    ('cleanup-surface-kept', C, 'host->release_surface(host->context, rd_u32(b, O_SURFACE)));\n        wr_32(b, O_SURFACE, 0);', 'host->release_surface(host->context, rd_u32(b, O_SURFACE)));', 1, 0),
    ('cleanup-cells-freed-twice', C, 'if (rd_s32(b, O_CELLS) != 0) wr_32(b, O_CELLS, 0);', 'wr_32(b, O_CELLS, 0);', 1, 0),
    ('cleanup-slot-release-always', C, 'if (rd_s16(b, O_SLOT) != -1) HOST(host->release_slot(host->context, rd_s16(b, O_SLOT)));', 'HOST(host->release_slot(host->context, rd_s16(b, O_SLOT)));', 1, 0),
    ('cleanup-slot-release-id', C, 'host->release_slot(host->context, rd_s16(b, O_SLOT))', 'host->release_slot(host->context, rd_s16(b, O_SLOT) + 1)', 1, 0),
    ('cleanup-slot-release-never', C, 'if (rd_s16(b, O_SLOT) != -1) HOST(host->release_slot(host->context, rd_s16(b, O_SLOT)));', '', 1, 0),
    ('cleanup-before-clear', C, 'object_clear(b);\n    return MP_OK;', 'return MP_OK;', 1, 0),
    ('invalidate-needs-active', C, 'if (rd_s32(b, O_ACTIVE) != 0 && rd_s16(b, O_SLOT) != -1) HOST(host->mark_dirty', 'if (rd_s16(b, O_SLOT) != -1) HOST(host->mark_dirty', 1, 0),
    ('invalidate-needs-slot', C, 'if (rd_s32(b, O_ACTIVE) != 0 && rd_s16(b, O_SLOT) != -1) HOST(host->mark_dirty', 'if (rd_s32(b, O_ACTIVE) != 0) HOST(host->mark_dirty', 1, 0),
    ('invalidate-slot-id', C, 'host->mark_dirty(host->context, rd_s16(b, O_SLOT))', 'host->mark_dirty(host->context, rd_s16(b, O_SLOT) + 1)', 1, 0),
    ('block-scene-test', C, 'if (rd_s16(body, block) != MP_NO_SCENE) {', 'if (rd_s16(body, block) >= 0) {', 1, 0),
    ('block-scene-always', C, 'if (rd_s16(body, block) != MP_NO_SCENE) {', 'if (1) {', 1, 0),
    ('block-flag-test', C, 'if (rd_s16(body, block + 0x16) != MP_NO_FLAG)\n', 'if (rd_s16(body, block + 0x16) >= 0)\n', 1, 0),
    ('block-flag-always', C, 'if (rd_s16(body, block + 0x16) != MP_NO_FLAG)\n', 'if (1)\n', 1, 0),
    ('block-flag-value', C, 'rd_s16(body, block + 0x16), rd_s16(body, block + 0x18)', 'rd_s16(body, block + 0x16), rd_s16(body, block + 0x16)', 1, 0),
    ('block-start-flag-sense', C, 't.start_flag = rd_s16(body, block + 0x14) != 1;', 't.start_flag = rd_s16(body, block + 0x14) == 1;', 1, 0),
    ('block-start-flag-nonzero', C, 't.start_flag = rd_s16(body, block + 0x14) != 1;', 't.start_flag = rd_s16(body, block + 0x14) != 0;', 1, 0),
    ('block-start-flag-two', C, 't.start_flag = rd_s16(body, block + 0x14) != 1;', 't.start_flag = rd_s16(body, block + 0x14) != 2;', 1, 0),
    ('block-start-flag-8bit', C, 't.start_flag = rd_s16(body, block + 0x14) != 1;', 't.start_flag = (rd_s16(body, block + 0x14) & 0xff) != 1;', 1, 0),
    ('block-dword-order', C, 't.dword[0] = rd_s32(body, block + 8);\n        t.dword[1] = rd_s32(body, block + 12);', 't.dword[1] = rd_s32(body, block + 8);\n        t.dword[0] = rd_s32(body, block + 12);', 1, 0),
    ('block-word-order', C, 't.word[0] = rd_s16(body, block + 2);\n        t.word[1] = rd_s16(body, block + 4);', 't.word[1] = rd_s16(body, block + 2);\n        t.word[0] = rd_s16(body, block + 4);', 1, 0),
    ('block-transition-before-flag', C, 'HOST(host->transition(host->context, &t));\n    }', 'HOST(host->transition(host->context, &t));\n        return MP_OK;\n    }', 1, 0),
    ('block-flag-invalid-sentinel', C, 'return index != MP_NO_FLAG && host->event_flag_invalid(host->context, index) != 0;', 'return host->event_flag_invalid(host->context, index) != 0;', 1, 0),
    ('block-flag-invalid-negated', C, 'host->event_flag_invalid(host->context, index) != 0;', 'host->event_flag_invalid(host->context, index) == 0;', 1, 0),
    ('block-flag-invalid-offset', C, 'const int16_t index = rd_s16(body, block + 0x16);', 'const int16_t index = rd_s16(body, block + 0x18);', 1, 0),
    ('flip-back-strict', C, 'rd_u32(b, O_DEADLINE) < host->tick(host->context)', 'rd_u32(b, O_DEADLINE) <= host->tick(host->context)', 1, 0),
    ('flip-back-signed', C, 'rd_u32(b, O_DEADLINE) < host->tick(host->context)', 'rd_s32(b, O_DEADLINE) < (int32_t)host->tick(host->context)', 1, 0),
    ('flip-back-reversed', C, 'rd_u32(b, O_DEADLINE) < host->tick(host->context)', 'rd_u32(b, O_DEADLINE) > host->tick(host->context)', 1, 0),
    ('flip-back-needs-flag', C, 'if (rd_s32(b, O_FLIPBACK) != 0 && rd_u32(b, O_DEADLINE)', 'if (rd_u32(b, O_DEADLINE)', 1, 0),
    ('flip-back-tick-first', C, 'if (rd_s32(b, O_FLIPBACK) != 0 && rd_u32(b, O_DEADLINE) < host->tick(host->context)) {', 'if (rd_u32(b, O_DEADLINE) < host->tick(host->context) && rd_s32(b, O_FLIPBACK) != 0) {', 1, 0),
    ('flip-back-first-cell', C, 'wr_32(cell_at_w(o, c1), 4, 0);\n        wr_32(cell_at_w(o, c2), 4, 0);', 'wr_32(cell_at_w(o, c2), 4, 0);', 1, 0),
    ('flip-back-second-cell', C, 'wr_32(cell_at_w(o, c1), 4, 0);\n        wr_32(cell_at_w(o, c2), 4, 0);', 'wr_32(cell_at_w(o, c1), 4, 0);', 1, 0),
    ('flip-back-bounds-first', C, 'if (c1 < 0 || c2 < 0) return MP_ERR_BOUNDS;', 'if (c2 < 0) return MP_ERR_BOUNDS;', 1, 0),
    ('flip-back-bounds-second', C, 'if (c1 < 0 || c2 < 0) return MP_ERR_BOUNDS;', 'if (c1 < 0) return MP_ERR_BOUNDS;', 1, 0),
    ('flip-back-keeps-first', C, 'wr_32(b, O_FIRST, 0);\n        wr_32(b, O_SECOND, 0);\n        wr_32(b, O_FLIPBACK, 0);\n        wr_32(b, O_DEADLINE, 0);', 'wr_32(b, O_SECOND, 0);\n        wr_32(b, O_FLIPBACK, 0);\n        wr_32(b, O_DEADLINE, 0);', 1, 0),
    ('flip-back-keeps-second', C, 'wr_32(b, O_FIRST, 0);\n        wr_32(b, O_SECOND, 0);\n        wr_32(b, O_FLIPBACK, 0);\n        wr_32(b, O_DEADLINE, 0);', 'wr_32(b, O_FIRST, 0);\n        wr_32(b, O_FLIPBACK, 0);\n        wr_32(b, O_DEADLINE, 0);', 1, 0),
    ('flip-back-keeps-flag', C, 'wr_32(b, O_SECOND, 0);\n        wr_32(b, O_FLIPBACK, 0);\n        wr_32(b, O_DEADLINE, 0);', 'wr_32(b, O_SECOND, 0);\n        wr_32(b, O_DEADLINE, 0);', 1, 0),
    ('flip-back-keeps-deadline', C, 'wr_32(b, O_FLIPBACK, 0);\n        wr_32(b, O_DEADLINE, 0);\n    }', 'wr_32(b, O_FLIPBACK, 0);\n    }', 1, 0),
    ('check-end-win-tries', C, 'rd_s32(body, B_TRIES) < rd_s32(b, O_TRIES)) {', 'rd_s32(body, B_TRIES) <= rd_s32(b, O_TRIES)) {', 1, 0),
    ('check-end-win-pairs', C, 'if (rd_s32(b, O_PAIRS) < rd_s32(b, O_NEEDED) || rd_s32', 'if (rd_s32(b, O_PAIRS) <= rd_s32(b, O_NEEDED) || rd_s32', 1, 0),
    ('check-end-win-and', C, 'if (rd_s32(b, O_PAIRS) < rd_s32(b, O_NEEDED) || rd_s32', 'if (rd_s32(b, O_PAIRS) < rd_s32(b, O_NEEDED) && rd_s32', 1, 0),
    ('check-end-lose-tries', C, 'rd_s32(body, B_TRIES) <= rd_s32(b, O_TRIES)) wr_32(b, O_LOST, 1);', 'rd_s32(body, B_TRIES) < rd_s32(b, O_TRIES)) wr_32(b, O_LOST, 1);', 1, 0),
    ('check-end-lose-pairs', C, 'if (rd_s32(b, O_PAIRS) < rd_s32(b, O_NEEDED) && rd_s32(body, B_TRIES) <= rd_s32(b, O_TRIES)) wr_32(b, O_LOST, 1);', 'if (rd_s32(body, B_TRIES) <= rd_s32(b, O_TRIES)) wr_32(b, O_LOST, 1);', 1, 0),
    ('check-end-lose-pairs-le', C, 'if (rd_s32(b, O_PAIRS) < rd_s32(b, O_NEEDED) && rd_s32(body, B_TRIES) <= rd_s32(b, O_TRIES)) wr_32(b, O_LOST, 1);', 'if (rd_s32(b, O_PAIRS) <= rd_s32(b, O_NEEDED) && rd_s32(body, B_TRIES) <= rd_s32(b, O_TRIES)) wr_32(b, O_LOST, 1);', 1, 0),
    ('check-end-lose-unconditional', C, 'if (rd_s32(b, O_PAIRS) < rd_s32(b, O_NEEDED) && rd_s32(body, B_TRIES) <= rd_s32(b, O_TRIES)) wr_32(b, O_LOST, 1);', 'wr_32(b, O_LOST, 1);', 1, 0),
    ('check-end-won-clears-lost', C, 'wr_32(b, O_WON, 1);\n    }\n}', 'wr_32(b, O_WON, 1);\n        wr_32(b, O_LOST, 0);\n    }\n}', 1, 0),
    ('check-end-tries-field', C, 'rd_s32(body, B_TRIES) <= rd_s32(b, O_TRIES)) wr_32(b, O_LOST, 1);', 'rd_s32(body, B_NEEDED_FIXED) <= rd_s32(b, O_TRIES)) wr_32(b, O_LOST, 1);', 1, 0),
    ('phase-limit', C, 'if (phase > 2u) return MP_ERR_UNSUPPORTED;', 'if (phase > 3u) return MP_ERR_UNSUPPORTED;', 1, 0),
    ('step-recenter-flag', C, 'if (body[B_RECENTER] != 0) HOST(host->recenter_cursor(host->context));', 'if (body[B_RECENTER] == 1) HOST(host->recenter_cursor(host->context));', 1, 0),
    ('step-recenter-never', C, 'if (body[B_RECENTER] != 0) HOST(host->recenter_cursor(host->context));', '', 1, 0),
    ('step-recenter-always', C, 'if (body[B_RECENTER] != 0) HOST(host->recenter_cursor(host->context));', 'HOST(host->recenter_cursor(host->context));', 1, 0),
    ('step-start-flag-value', C, 'host->set_start_flag(host->context, 1)', 'host->set_start_flag(host->context, 0)', 1, 0),
    ('step-order-clear-recenter', C, 'HOST(host->clear_pending_item(host->context));\n        if (body[B_RECENTER]', 'if (body[B_RECENTER]', 1, 0),
    ('step-half-page', C, 'wr_32(b, O_HALF_PAGE, rd_s32(b, O_PER_PAGE) / 2);', 'wr_32(b, O_HALF_PAGE, (rd_s32(b, O_PER_PAGE) + 1) / 2);', 1, 0),
    ('step-half-total', C, 'wr_32(b, O_HALF_TOTAL, rd_s32(b, O_TOTAL) / 2);', 'wr_32(b, O_HALF_TOTAL, (rd_s32(b, O_TOTAL) + 1) / 2);', 1, 0),
    ('step-per-page', C, 'wr_32(b, O_PER_PAGE, mul32(cols, rows));', 'wr_32(b, O_PER_PAGE, mul32(cols, cols));', 1, 0),
    ('step-total', C, 'wr_32(b, O_TOTAL, mul32(rd_s32(b, O_PER_PAGE), pages));', 'wr_32(b, O_TOTAL, rd_s32(b, O_PER_PAGE));', 1, 0),
    ('step-view-copy', C, 'wr_32(b, O_VIEW_COPY + (size_t)k * 4u, rd_s32(b, O_VIEW + (size_t)k * 4u));', 'wr_32(b, O_VIEW_COPY + (size_t)k * 4u, view.view[(k + 1) % 4]);', 1, 0),
    ('step-view-stored', C, 'wr_32(b, O_VIEW + (size_t)k * 4u, view.view[k]);', 'wr_32(b, O_VIEW + (size_t)k * 4u, view.view[3 - k]);', 1, 0),
    ('step-tile-x-offset', C, 'wr_32(b, d + 8, add32(rd_s32(body, s + 8), rd_s32(b, O_VIEW)));', 'wr_32(b, d + 8, add32(rd_s32(body, s + 8), rd_s32(b, O_VIEW + 8)));', 1, 0),
    ('step-tile-y-offset', C, 'wr_32(b, d + 12, add32(rd_s32(body, s + 12), rd_s32(b, O_VIEW + 4)));', 'wr_32(b, d + 12, add32(rd_s32(body, s + 12), rd_s32(b, O_VIEW)));', 1, 0),
    ('step-tile-stride', C, 'd = O_TILE_RECTS + i * 16u;', 'd = O_TILE_RECTS + i * 12u;', 1, 0),
    ('step-tile-count', C, 'for (wr_32(b, O_LOOP_I, 0); rd_s32(b, O_LOOP_I) < rd_s32(b, O_PER_PAGE); wr_32', 'for (wr_32(b, O_LOOP_I, 0); rd_s32(b, O_LOOP_I) < rd_s32(b, O_PER_PAGE) - 1; wr_32', 1, 0),
    ('step-tabs-flag', C, 'if (body[B_TABS] != 0) {\n            for (wr_32', 'if (body[B_TABS] == 1) {\n            for (wr_32', 1, 0),
    ('step-tabs-never', C, 'if (body[B_TABS] != 0) {\n            for (wr_32', 'if (0) {\n            for (wr_32', 1, 0),
    ('step-tabs-page-stride', C, '(size_t)rd_s32(b, O_LOOP_I) * 0x30u + (size_t)rd_s32(b, O_LOOP_J) * 0x10u;', '(size_t)rd_s32(b, O_LOOP_I) * 0x20u + (size_t)rd_s32(b, O_LOOP_J) * 0x10u;', 1, 0),
    ('step-tabs-hot-count', C, 'rd_s32(b, O_LOOP_J) < 3; wr_32(b, O_LOOP_J, rd_s32(b, O_LOOP_J) + 1)) {', 'rd_s32(b, O_LOOP_J) < 2; wr_32(b, O_LOOP_J, rd_s32(b, O_LOOP_J) + 1)) {', 1, 0),
    ('step-tabs-page-count', C, 'for (wr_32(b, O_LOOP_I, 0); rd_s32(b, O_LOOP_I) < pages;', 'for (wr_32(b, O_LOOP_I, 0); rd_s32(b, O_LOOP_I) < pages - 1;', 1, 0),
    ('step-tabs-hot-y', C, 'wr_32(b, O_TAB_HOT + 4 + k, add32(rd_s32(body, B_TAB_HOT + 4 + k), rd_s32(b, O_VIEW + 4)));', 'wr_32(b, O_TAB_HOT + 4 + k, add32(rd_s32(body, B_TAB_HOT + 4 + k), rd_s32(b, O_VIEW)));', 1, 0),
    ('step-tabs-target-y', C, 'wr_32(b, O_TAB_TARGET + 4, add32(rd_s32(body, B_TAB_TARGET + 4), rd_s32(b, O_VIEW + 4)));', 'wr_32(b, O_TAB_TARGET + 4, add32(rd_s32(body, B_TAB_TARGET + 4), rd_s32(b, O_VIEW)));', 1, 0),
    ('step-tabs-target-x2', C, 'wr_32(b, O_TAB_TARGET + 8, add32(rd_s32(body, B_TAB_TARGET + 8), rd_s32(b, O_VIEW)));', 'wr_32(b, O_TAB_TARGET + 8, add32(rd_s32(body, B_TAB_TARGET + 8), rd_s32(b, O_VIEW + 4)));', 1, 0),
    ('step-surface-reuse', C, 'if (rd_s32(b, O_SURFACE) == 0) {\n            surface = 0;', 'if (1) {\n            surface = 0;', 1, 0),
    ('step-surface-tag', C, '#define TAG_SURFACE "Memory Puzzle Overlay Surface"', '#define TAG_SURFACE "Memory Puzzle Overlay Surfacf"', 1, 0),
    ('step-label', C, '#define LABEL_SLOT "WHALESURVIVOR GAME PUZZLE OVERLAYS"', '#define LABEL_SLOT "WHALESURVIVOR GAME PUZZLE OVERLAYT"', 1, 0),
    ('step-slot-surface', C, 'host->set_slot_surface(host->context, slot, rd_u32(b, O_SURFACE))', 'host->set_slot_surface(host->context, slot, 0)', 1, 0),
    ('step-state-reset', C, 'wr_32(b, O_STATE, 0);\n        result->initialized = 1;', 'result->initialized = 1;', 1, 0),
    ('step-won-reset', C, 'wr_32(b, O_WON, 0);\n        wr_32(b, O_LOST, 0);\n        wr_32(b, O_REDRAW, 1);\n        wr_32(b, O_STATE, 0);', 'wr_32(b, O_LOST, 0);\n        wr_32(b, O_REDRAW, 1);\n        wr_32(b, O_STATE, 0);', 1, 0),
    ('step-lost-reset', C, 'wr_32(b, O_LOST, 0);\n        wr_32(b, O_REDRAW, 1);\n        wr_32(b, O_STATE, 0);', 'wr_32(b, O_REDRAW, 1);\n        wr_32(b, O_STATE, 0);', 1, 0),
    ('step-phase-after-init', C, 'result->phase_after = 1u;\n        return MP_OK;', 'result->phase_after = 2u;\n        return MP_OK;', 1, 0),
    ('step-row-check', C, 'if (rd_s16(b, O_ROW) != row || rd_s32(b, O_ACTIVE) == 0) return MP_ERR_UNSUPPORTED;', 'if (rd_s32(b, O_ACTIVE) == 0) return MP_ERR_UNSUPPORTED;', 1, 0),
    ('step-active-check', C, 'if (rd_s16(b, O_ROW) != row || rd_s32(b, O_ACTIVE) == 0) return MP_ERR_UNSUPPORTED;', 'if (rd_s16(b, O_ROW) != row) return MP_ERR_UNSUPPORTED;', 1, 0),
    ('step-play-won-state', C, 'if (rd_s32(b, O_WON) != 0) {\n                wr_32(b, O_STATE, 1);', 'if (rd_s32(b, O_WON) != 0) {\n                wr_32(b, O_STATE, 3);', 1, 0),
    ('step-play-lost-state', C, 'if (rd_s32(b, O_LOST) != 0) {\n                wr_32(b, O_STATE, 2);', 'if (rd_s32(b, O_LOST) != 0) {\n                wr_32(b, O_STATE, 4);', 1, 0),
    ('step-play-won-redraw', C, 'wr_32(b, O_STATE, 1);\n                wr_32(b, O_REDRAW, 1);', 'wr_32(b, O_STATE, 1);', 1, 0),
    ('step-play-lost-redraw', C, 'wr_32(b, O_STATE, 2);\n                wr_32(b, O_REDRAW, 1);', 'wr_32(b, O_STATE, 2);', 1, 0),
    ('step-play-won-priority', C, 'if (rd_s32(b, O_LOST) != 0) {\n                wr_32(b, O_STATE, 2);', 'if (rd_s32(b, O_LOST) != 0 && rd_s32(b, O_WON) == 0) {\n                wr_32(b, O_STATE, 2);', 1, 0),
    ('step-play-flipback-after-end', C, 'CHECK(flip_back(object, host));\n            if (rd_s32(b, O_WON) != 0) {', 'if (rd_s32(b, O_WON) != 0) {', 1, 0),
    ('step-win-pick-field', C, 'pick_and_play(object, body, B_SND_WIN, 10, O_SND_WIN, host)', 'pick_and_play(object, body, B_SND_WIN, 10, O_SND_WRONG, host)', 1, 0),
    ('step-win-pick-count', C, 'pick_and_play(object, body, B_SND_WIN, 10, O_SND_WIN, host)', 'pick_and_play(object, body, B_SND_WIN, 9, O_SND_WIN, host)', 1, 0),
    ('step-win-no-pick-minus-one', C, 'if (rd_s32(b, O_SND_WIN) == -1 ||', 'if (', 1, 0),
    ('step-win-exact-check', C, 'no_sound_exact(body + B_SND_WIN + (size_t)rd_s32(b, O_SND_WIN)', 'no_sound_ci(body + B_SND_WIN + (size_t)rd_s32(b, O_SND_WIN)', 1, 0),
    ('step-win-wait-state', C, 'wr_32(b, O_STATE, MP_STATE_WIN_WAIT);', 'wr_32(b, O_STATE, MP_STATE_LOSE_WAIT);', 1, 0),
    ('step-lose-pick-field', C, 'pick_and_play(object, body, B_SND_WRONG, 10, O_SND_WRONG, host));\n            if', 'pick_and_play(object, body, B_SND_WRONG, 10, O_SND_WIN, host));\n            if', 1, 0),
    ('step-lose-no-pick-minus-one', C, 'if (rd_s32(b, O_SND_WRONG) == -1 ||', 'if (', 1, 0),
    ('step-lose-exact-check', C, 'no_sound_exact(body + B_SND_WRONG + (size_t)rd_s32(b, O_SND_WRONG)', 'no_sound_ci(body + B_SND_WRONG + (size_t)rd_s32(b, O_SND_WRONG)', 1, 0),
    ('step-lose-wait-state', C, 'wr_32(b, O_STATE, MP_STATE_LOSE_WAIT);', 'wr_32(b, O_STATE, MP_STATE_WIN_WAIT);', 1, 0),
    ('step-win-wait-channel', C, 'rd_s16(body, B_SND_WIN + (size_t)rd_s32(b, O_SND_WIN) * MP_SOUND_RECORD_BYTES + SND_CHANNEL),', 'rd_s16(body, B_SND_WRONG + (size_t)rd_s32(b, O_SND_WRONG) * MP_SOUND_RECORD_BYTES + SND_CHANNEL),', 1, 0),
    ('step-lose-wait-channel', C, 'rd_s16(body, B_SND_WRONG + (size_t)rd_s32(b, O_SND_WRONG) * MP_SOUND_RECORD_BYTES + SND_CHANNEL),\n                                  &busy));\n            if (busy == 0) result->phase_after = 2u;\n            break;\n        default', 'rd_s16(body, B_SND_WIN + (size_t)rd_s32(b, O_SND_WIN) * MP_SOUND_RECORD_BYTES + SND_CHANNEL),\n                                  &busy));\n            if (busy == 0) result->phase_after = 2u;\n            break;\n        default', 1, 0),
    ('step-win-wait-busy', C, 'if (busy == 0) result->phase_after = 2u;\n            break;\n        case MP_STATE_LOSE_WAIT', 'if (busy != 0) result->phase_after = 2u;\n            break;\n        case MP_STATE_LOSE_WAIT', 1, 0),
    ('step-lose-wait-busy', C, 'if (busy == 0) result->phase_after = 2u;\n            break;\n        default', 'if (busy != 0) result->phase_after = 2u;\n            break;\n        default', 1, 0),
    ('step-win-wait-busy-nonneg', C, 'if (busy == 0) result->phase_after = 2u;\n            break;\n        case MP_STATE_LOSE_WAIT', 'if (busy <= 0) result->phase_after = 2u;\n            break;\n        case MP_STATE_LOSE_WAIT', 1, 0),
    ('step-finish-block-select', C, 'const size_t block = rd_s32(b, O_WON) != 0 ? B_BLOCK_WIN : B_BLOCK_LOSE;', 'const size_t block = rd_s32(b, O_LOST) != 0 ? B_BLOCK_LOSE : B_BLOCK_WIN;', 1, 0),
    ('step-finish-block-win', C, 'const size_t block = rd_s32(b, O_WON) != 0 ? B_BLOCK_WIN : B_BLOCK_LOSE;', 'const size_t block = B_BLOCK_LOSE;', 1, 0),
    ('step-finish-apply', C, 'const int apply = rd_s32(b, O_WON) != 0 || rd_s32(b, O_LOST) != 0;', 'const int apply = rd_s32(b, O_WON) != 0;', 1, 0),
    ('step-finish-apply-lost', C, 'const int apply = rd_s32(b, O_WON) != 0 || rd_s32(b, O_LOST) != 0;', 'const int apply = rd_s32(b, O_LOST) != 0;', 1, 0),
    ('step-finish-apply-always', C, 'const int apply = rd_s32(b, O_WON) != 0 || rd_s32(b, O_LOST) != 0;', 'const int apply = 1;', 1, 0),
    ('step-finish-inactive-before-block', C, 'wr_32(b, O_ACTIVE, 0);\n        if (apply) CHECK(apply_block', 'if (apply) CHECK(apply_block', 1, 0),
    ('step-finish-complete-row', C, 'host->complete(host->context, rd_s16(b, O_ROW))', 'host->complete(host->context, row)', 1, 0),
    ('step-finish-completed-flag', C, 'result->completed = 1;\n        CHECK(mp_cleanup', 'CHECK(mp_cleanup', 1, 0),
    ('step-finish-cleanup', C, 'result->completed = 1;\n        CHECK(mp_cleanup(object, host));', 'result->completed = 1;', 1, 0),
    ('step-finish-invalid-flag-check', C, 'if (apply && block_flag_invalid(body, block, host)) return MP_ERR_BOUNDS;', 'if (block_flag_invalid(body, block, host)) return MP_ERR_BOUNDS;', 1, 0),
    ('step-finish-invalid-flag-ignored', C, 'if (apply && block_flag_invalid(body, block, host)) return MP_ERR_BOUNDS;', '', 1, 0),
    ('pointer-inactive', C, 'if (rd_s32(b, O_ACTIVE) == 0 || rd_s32(b, O_WON) != 0 || rd_s32(b, O_LOST) != 0) return MP_OK;', 'if (rd_s32(b, O_WON) != 0 || rd_s32(b, O_LOST) != 0) return MP_OK;', 1, 0),
    ('pointer-won', C, 'if (rd_s32(b, O_ACTIVE) == 0 || rd_s32(b, O_WON) != 0 || rd_s32(b, O_LOST) != 0) return MP_OK;', 'if (rd_s32(b, O_ACTIVE) == 0 || rd_s32(b, O_LOST) != 0) return MP_OK;', 1, 0),
    ('pointer-lost', C, 'if (rd_s32(b, O_ACTIVE) == 0 || rd_s32(b, O_WON) != 0 || rd_s32(b, O_LOST) != 0) return MP_OK;', 'if (rd_s32(b, O_ACTIVE) == 0 || rd_s32(b, O_WON) != 0) return MP_OK;', 1, 0),
    ('pointer-hit-reset', C, 'wr_32(b, O_HIT, -1);\n    if (body[B_TABS]', 'if (body[B_TABS]', 1, 0),
    ('pointer-tab-before-tiles', C, 'out->hit = 1;\n                return MP_OK;\n            }\n        }\n    }\n    for (int32_t j = 0; j < rd_s32(b, O_PER_PAGE); ++j) {', 'out->hit = 1;\n            }\n        }\n    }\n    for (int32_t j = 0; j < rd_s32(b, O_PER_PAGE); ++j) {', 1, 0),
    ('pointer-tab-only-first', C, 'for (int32_t j = 0; j < 3; ++j) {\n            const size_t k = B_TAB_HOT', 'for (int32_t j = 0; j < 1; ++j) {\n            const size_t k = B_TAB_HOT', 1, 0),
    ('pointer-tab-page-stride', C, '(size_t)rd_s32(b, O_PAGE) * 0x30u + (size_t)j * 0x10u;', '(size_t)rd_s32(b, O_PAGE) * 0x10u + (size_t)j * 0x10u;', 1, 0),
    ('pointer-tab-page-ignored', C, '(size_t)rd_s32(b, O_PAGE) * 0x30u + (size_t)j * 0x10u;', '(size_t)j * 0x10u;', 1, 0),
    ('pointer-tab-top', C, 'rd_s32(body, k + 4) <= y && y <= rd_s32(body, k + 12)', 'rd_s32(body, k + 4) < y && y <= rd_s32(body, k + 12)', 1, 0),
    ('pointer-tab-bottom', C, 'rd_s32(body, k + 4) <= y && y <= rd_s32(body, k + 12)', 'rd_s32(body, k + 4) <= y && y < rd_s32(body, k + 12)', 1, 0),
    ('pointer-tab-left', C, 'rd_s32(body, k) <= x && x <= rd_s32(body, k + 8)', 'rd_s32(body, k) < x && x <= rd_s32(body, k + 8)', 1, 0),
    ('pointer-tab-right', C, 'rd_s32(body, k) <= x && x <= rd_s32(body, k + 8)', 'rd_s32(body, k) <= x && x < rd_s32(body, k + 8)', 1, 0),
    ('pointer-tab-body-coords', C, 'rd_s32(body, k + 4) <= y && y <= rd_s32(body, k + 12) && rd_s32(body, k) <= x && x <= rd_s32(body, k + 8)', 'rd_s32(b, O_TAB_HOT + (k - B_TAB_HOT) + 4) <= y && y <= rd_s32(b, O_TAB_HOT + (k - B_TAB_HOT) + 12) && rd_s32(b, O_TAB_HOT + (k - B_TAB_HOT)) <= x && x <= rd_s32(b, O_TAB_HOT + (k - B_TAB_HOT) + 8)', 1, 0),
    ('pointer-tab-hit-index', C, 'wr_32(b, O_HIT, j);\n                write_candidate(MP_CANDIDATE_TAB, out);', 'wr_32(b, O_HIT, j + 1);\n                write_candidate(MP_CANDIDATE_TAB, out);', 1, 0),
    ('pointer-tile-shrink-top', C, 'add32(rd_s32(body, r + 4), 3) <= y', 'add32(rd_s32(body, r + 4), 2) <= y', 1, 0),
    ('pointer-tile-shrink-top-4', C, 'add32(rd_s32(body, r + 4), 3) <= y', 'add32(rd_s32(body, r + 4), 4) <= y', 1, 0),
    ('pointer-tile-shrink-bottom', C, 'y <= add32(rd_s32(body, r + 12), -3)', 'y <= add32(rd_s32(body, r + 12), -2)', 1, 0),
    ('pointer-tile-shrink-bottom-4', C, 'y <= add32(rd_s32(body, r + 12), -3)', 'y <= add32(rd_s32(body, r + 12), -4)', 1, 0),
    ('pointer-tile-shrink-left', C, 'add32(rd_s32(body, r), 3) <= x', 'add32(rd_s32(body, r), 2) <= x', 1, 0),
    ('pointer-tile-shrink-left-4', C, 'add32(rd_s32(body, r), 3) <= x', 'add32(rd_s32(body, r), 4) <= x', 1, 0),
    ('pointer-tile-shrink-right', C, 'x <= add32(rd_s32(body, r + 8), -3)', 'x <= add32(rd_s32(body, r + 8), -2)', 1, 0),
    ('pointer-tile-shrink-right-4', C, 'x <= add32(rd_s32(body, r + 8), -3)', 'x <= add32(rd_s32(body, r + 8), -4)', 1, 0),
    ('pointer-tile-strict-top', C, 'add32(rd_s32(body, r + 4), 3) <= y', 'add32(rd_s32(body, r + 4), 3) < y', 1, 0),
    ('pointer-tile-strict-bottom', C, 'y <= add32(rd_s32(body, r + 12), -3)', 'y < add32(rd_s32(body, r + 12), -3)', 1, 0),
    ('pointer-tile-strict-left', C, 'add32(rd_s32(body, r), 3) <= x', 'add32(rd_s32(body, r), 3) < x', 1, 0),
    ('pointer-tile-strict-right', C, 'x <= add32(rd_s32(body, r + 8), -3)', 'x < add32(rd_s32(body, r + 8), -3)', 1, 0),
    ('pointer-tile-cell-page', C, 'wr_32(b, O_CELL, add32(mul32(rd_s32(b, O_PAGE), rd_s32(b, O_PER_PAGE)), j));\n        if (add32', 'wr_32(b, O_CELL, j);\n        if (add32', 1, 0),
    ('pointer-tile-bounds-low', C, 'if (c < 0 || c >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;\n            if (rd_s32(cell_at(object, c), 4) == 0', 'if (c >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;\n            if (rd_s32(cell_at(object, c), 4) == 0', 1, 0),
    ('pointer-tile-bounds-high', C, 'if (c < 0 || c >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;\n            if (rd_s32(cell_at(object, c), 4) == 0', 'if (c < 0 || c > rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;\n            if (rd_s32(cell_at(object, c), 4) == 0', 1, 0),
    ('pointer-tile-faceup', C, 'if (rd_s32(cell_at(object, c), 4) == 0 && rd_s32(cell_at(object, c), 8) == 0) {', 'if (rd_s32(cell_at(object, c), 8) == 0) {', 1, 0),
    ('pointer-tile-matched', C, 'if (rd_s32(cell_at(object, c), 4) == 0 && rd_s32(cell_at(object, c), 8) == 0) {', 'if (rd_s32(cell_at(object, c), 4) == 0) {', 1, 0),
    ('pointer-tile-hit-stored', C, 'wr_32(b, O_HIT, j);\n                write_candidate(MP_CANDIDATE_TILE, out);', 'write_candidate(MP_CANDIDATE_TILE, out);', 1, 0),
    ('pointer-tile-first-hit-wins', C, 'out->hit = 1;\n                return MP_OK;\n            }\n        }\n    }\n    return MP_OK;\n}', 'out->hit = 1;\n            }\n        }\n    }\n    return MP_OK;\n}', 1, 0),
    ('candidate-cursor', C, 'out->cursor = 0;', 'out->cursor = 1;', 1, 0),
    ('candidate-cursor-flag', C, 'out->cursor_flag = 1;', 'out->cursor_flag = 0;', 1, 0),
    ('candidate-wrote', C, 'out->wrote_cursor = 1;', 'out->wrote_cursor = 0;', 1, 0),
    ('pointer-body-short', C, 'if (body == NULL || body_length < MP_BODY_BYTES) return MP_ERR_ARGUMENT;\n    wr_32(b, O_HIT, -1);', 'if (body == NULL) return MP_ERR_ARGUMENT;\n    wr_32(b, O_HIT, -1);', 1, 0),
    ('click-body-stored', C, 'wr_32(b, O_BODY, (int32_t)body_handle);\n    if (!(rd_s32(b, O_ACTIVE) != 0 && row_phase', 'if (!(rd_s32(b, O_ACTIVE) != 0 && row_phase', 1, 0),
    ('click-phase', C, 'row_phase == 1u && rd_s32(b, O_STATE) == MP_STATE_PLAY', 'rd_s32(b, O_STATE) == MP_STATE_PLAY', 1, 0),
    ('click-phase-ge', C, 'row_phase == 1u && rd_s32(b, O_STATE) == MP_STATE_PLAY', 'row_phase >= 1u && rd_s32(b, O_STATE) == MP_STATE_PLAY', 1, 0),
    ('click-state', C, 'row_phase == 1u && rd_s32(b, O_STATE) == MP_STATE_PLAY', 'row_phase == 1u', 1, 0),
    ('click-active', C, 'if (!(rd_s32(b, O_ACTIVE) != 0 && row_phase', 'if (!(row_phase', 1, 0),
    ('click-candidate-tab-only', C, '(candidate == MP_CANDIDATE_TAB || candidate == MP_CANDIDATE_TILE)))', '(candidate == MP_CANDIDATE_TAB)))', 1, 0),
    ('click-candidate-tile-only', C, '(candidate == MP_CANDIDATE_TAB || candidate == MP_CANDIDATE_TILE)))', '(candidate == MP_CANDIDATE_TILE)))', 1, 0),
    ('click-candidate-any', C, '(candidate == MP_CANDIDATE_TAB || candidate == MP_CANDIDATE_TILE)))', '(candidate != -1)))', 1, 0),
    ('click-tab-bounds-low', C, 'if (rd_s32(b, O_HIT) < 0 || rd_s32(b, O_HIT) >= rd_s32(body, B_PAGES)) return MP_ERR_BOUNDS;', 'if (rd_s32(b, O_HIT) >= rd_s32(body, B_PAGES)) return MP_ERR_BOUNDS;', 1, 0),
    ('click-tab-bounds-high', C, 'if (rd_s32(b, O_HIT) < 0 || rd_s32(b, O_HIT) >= rd_s32(body, B_PAGES)) return MP_ERR_BOUNDS;', 'if (rd_s32(b, O_HIT) < 0 || rd_s32(b, O_HIT) > rd_s32(body, B_PAGES)) return MP_ERR_BOUNDS;', 1, 0),
    ('click-tab-page', C, 'wr_32(b, O_PAGE, rd_s32(b, O_HIT));\n        HOST(host->sound_play', 'HOST(host->sound_play', 1, 0),
    ('click-tab-channel', C, 'host->sound_play(host->context, MP_FLIP_CHANNEL)', 'host->sound_play(host->context, MP_FLIP_CHANNEL + 1)', 1, 0),
    ('click-tab-sound-skipped', C, 'wr_32(b, O_PAGE, rd_s32(b, O_HIT));\n        HOST(host->sound_play(host->context, MP_FLIP_CHANNEL));', 'wr_32(b, O_PAGE, rd_s32(b, O_HIT));', 1, 0),
    ('click-tab-redraw', C, 'wr_32(b, O_PAGE, rd_s32(b, O_HIT));\n        HOST', 'wr_32(b, O_PAGE, rd_s32(b, O_HIT));\n        wr_32(b, O_REDRAW, 1);\n        HOST', 1, 0),
    ('click-tile-bounds-low', C, 'if (idx < 0 || idx >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;\n        wr_32(b, O_CELL, idx);', 'if (idx >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;\n        wr_32(b, O_CELL, idx);', 1, 0),
    ('click-tile-bounds-high', C, 'if (idx < 0 || idx >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;\n        wr_32(b, O_CELL, idx);', 'if (idx < 0 || idx > rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;\n        wr_32(b, O_CELL, idx);', 1, 0),
    ('click-tile-index-page', C, 'const int32_t idx = add32(mul32(rd_s32(b, O_PAGE), rd_s32(b, O_PER_PAGE)), rd_s32(b, O_HIT));', 'const int32_t idx = rd_s32(b, O_HIT);', 1, 0),
    ('click-tile-cell-stored', C, 'wr_32(b, O_CELL, idx);\n        cell = cell_at_w', 'cell = cell_at_w', 1, 0),
    ('click-tile-matched', C, 'if (rd_s32(cell, 8) == 0 && rd_s32(cell, 4) == 0 && (rd_s32(b, O_FIRST)', 'if (rd_s32(cell, 4) == 0 && (rd_s32(b, O_FIRST)', 1, 0),
    ('click-tile-faceup', C, 'if (rd_s32(cell, 8) == 0 && rd_s32(cell, 4) == 0 && (rd_s32(b, O_FIRST)', 'if (rd_s32(cell, 8) == 0 && (rd_s32(b, O_FIRST)', 1, 0),
    ('click-tile-two-free', C, '(rd_s32(b, O_FIRST) == 0 || rd_s32(b, O_SECOND) == 0) &&\n            rd_s32(b, O_FLIPBACK) == 0) {', 'rd_s32(b, O_FLIPBACK) == 0) {', 1, 0),
    ('click-tile-two-free-and', C, '(rd_s32(b, O_FIRST) == 0 || rd_s32(b, O_SECOND) == 0) &&', '(rd_s32(b, O_FIRST) == 0 && rd_s32(b, O_SECOND) == 0) &&', 1, 0),
    ('click-tile-flipback-wait', C, '            rd_s32(b, O_FLIPBACK) == 0) {\n            wr_32(cell, 4, 1);', '            1) {\n            wr_32(cell, 4, 1);', 1, 0),
    ('click-tile-flip', C, 'wr_32(cell, 4, 1);\n            if (rd_s32(b, O_FIRST) == 0) {', 'if (rd_s32(b, O_FIRST) == 0) {', 1, 0),
    ('click-first-pointer', C, 'wr_32(b, O_FIRST, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * MP_CELL_BYTES));', 'wr_32(b, O_FIRST, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * MP_CELL_BYTES) + 4);', 1, 0),
    ('click-first-sound', C, 'CHECK(play_record(body, B_SND_FLIP1, host));', 'CHECK(play_record(body, B_SND_FLIP2, host));', 1, 0),
    ('click-second-sound', C, 'CHECK(play_record(body, B_SND_FLIP2, host));', 'CHECK(play_record(body, B_SND_FLIP1, host));', 1, 0),
    ('click-second-sound-after-store', C, 'CHECK(play_record(body, B_SND_FLIP2, host));\n                wr_32(b, O_SECOND, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * MP_CELL_BYTES));', 'wr_32(b, O_SECOND, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * MP_CELL_BYTES));\n                CHECK(play_record(body, B_SND_FLIP2, host));', 1, 0),
    ('click-second-pointer', C, 'wr_32(b, O_SECOND, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * MP_CELL_BYTES));', 'wr_32(b, O_SECOND, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * MP_CELL_BYTES) + 4);', 1, 0),
    ('click-first-bounds', C, 'if (c1 < 0) return MP_ERR_BOUNDS;\n                CHECK(play_record', 'CHECK(play_record', 1, 0),
    ('click-match-ids', C, 'if (rd_s32(cell_at(object, c1), 0) == rd_s32(cell, 0)) {', 'if (rd_s32(cell_at(object, c1), 0) != rd_s32(cell, 0)) {', 1, 0),
    ('click-match-pairs', C, 'wr_32(b, O_PAIRS, rd_s32(b, O_PAIRS) + 1);\n                    wr_32(b, O_TRIES, rd_s32(b, O_TRIES) + 1);\n                    wr_32(cell_at_w', 'wr_32(b, O_TRIES, rd_s32(b, O_TRIES) + 1);\n                    wr_32(cell_at_w', 1, 0),
    ('click-match-tries', C, 'wr_32(b, O_PAIRS, rd_s32(b, O_PAIRS) + 1);\n                    wr_32(b, O_TRIES, rd_s32(b, O_TRIES) + 1);\n                    wr_32(cell_at_w', 'wr_32(b, O_PAIRS, rd_s32(b, O_PAIRS) + 1);\n                    wr_32(cell_at_w', 1, 0),
    ('click-match-first-cell', C, 'wr_32(cell_at_w(object, c1), 8, 1);\n                    wr_32(cell, 8, 1);', 'wr_32(cell, 8, 1);', 1, 0),
    ('click-match-second-cell', C, 'wr_32(cell_at_w(object, c1), 8, 1);\n                    wr_32(cell, 8, 1);', 'wr_32(cell_at_w(object, c1), 8, 1);', 1, 0),
    ('click-match-clears-first', C, 'wr_32(b, O_FIRST, 0);\n                    wr_32(b, O_SECOND, 0);\n                    check_end(object, body);', 'wr_32(b, O_SECOND, 0);\n                    check_end(object, body);', 1, 0),
    ('click-match-clears-second', C, 'wr_32(b, O_FIRST, 0);\n                    wr_32(b, O_SECOND, 0);\n                    check_end(object, body);', 'wr_32(b, O_FIRST, 0);\n                    check_end(object, body);', 1, 0),
    ('click-match-check-end', C, 'check_end(object, body);\n                    if (rd_s32(b, O_WON) == 0) CHECK(pick_and_play(object, body, B_SND_MATCH', 'if (rd_s32(b, O_WON) == 0) CHECK(pick_and_play(object, body, B_SND_MATCH', 1, 0),
    ('click-match-sound-on-win', C, 'if (rd_s32(b, O_WON) == 0) CHECK(pick_and_play(object, body, B_SND_MATCH', 'CHECK(pick_and_play(object, body, B_SND_MATCH', 1, 0),
    ('click-match-sound-on-lost', C, 'if (rd_s32(b, O_WON) == 0) CHECK(pick_and_play(object, body, B_SND_MATCH', 'if (rd_s32(b, O_WON) == 0 && rd_s32(b, O_LOST) == 0) CHECK(pick_and_play(object, body, B_SND_MATCH', 1, 0),
    ('click-match-sound-list', C, 'pick_and_play(object, body, B_SND_MATCH, 5, O_SND_MATCH, host)', 'pick_and_play(object, body, B_SND_MATCH, 4, O_SND_MATCH, host)', 1, 0),
    ('click-match-sound-field', C, 'pick_and_play(object, body, B_SND_MATCH, 5, O_SND_MATCH, host)', 'pick_and_play(object, body, B_SND_MATCH, 5, O_SND_WIN, host)', 1, 0),
    ('click-mismatch-tries', C, 'wr_32(b, O_TRIES, rd_s32(b, O_TRIES) + 1);\n                    check_end(object, body);\n                    if (rd_s32(b, O_LOST)', 'check_end(object, body);\n                    if (rd_s32(b, O_LOST)', 1, 0),
    ('click-mismatch-check-end', C, 'check_end(object, body);\n                    if (rd_s32(b, O_LOST) == 0)', 'if (rd_s32(b, O_LOST) == 0)', 1, 0),
    ('click-mismatch-sound-on-lost', C, 'if (rd_s32(b, O_LOST) == 0) CHECK(pick_and_play(object, body, B_SND_WRONG', 'CHECK(pick_and_play(object, body, B_SND_WRONG', 1, 0),
    ('click-mismatch-sound-on-won', C, 'if (rd_s32(b, O_LOST) == 0) CHECK(pick_and_play(object, body, B_SND_WRONG', 'if (rd_s32(b, O_LOST) == 0 && rd_s32(b, O_WON) == 0) CHECK(pick_and_play(object, body, B_SND_WRONG', 1, 0),
    ('click-mismatch-sound-list', C, 'pick_and_play(object, body, B_SND_WRONG, 10, O_SND_WRONG, host));\n                    wr_32(b, O_DEADLINE', 'pick_and_play(object, body, B_SND_WRONG, 9, O_SND_WRONG, host));\n                    wr_32(b, O_DEADLINE', 1, 0),
    ('click-mismatch-sound-field', C, 'pick_and_play(object, body, B_SND_WRONG, 10, O_SND_WRONG, host));\n                    wr_32(b, O_DEADLINE', 'pick_and_play(object, body, B_SND_WRONG, 10, O_SND_WIN, host));\n                    wr_32(b, O_DEADLINE', 1, 0),
    ('click-mismatch-deadline-delay', C, '(uint32_t)rd_s32(body, B_DELAY)));', '(uint32_t)rd_s32(body, B_DELAY) + 1u));', 1, 0),
    ('click-mismatch-deadline-tick-order', C, 'wr_32(b, O_DEADLINE, (int32_t)(host->tick(host->context) + (uint32_t)rd_s32(body, B_DELAY)));\n                    wr_32(b, O_FLIPBACK, 1);', 'wr_32(b, O_FLIPBACK, 1);\n                    wr_32(b, O_DEADLINE, (int32_t)(host->tick(host->context) + (uint32_t)rd_s32(body, B_DELAY)));', 1, 0),
    ('click-mismatch-flipback', C, 'wr_32(b, O_FLIPBACK, 1);\n                }', '', 1, 0),
    ('click-mismatch-flipback-on-end', C, '                    wr_32(b, O_DEADLINE, (int32_t)(host->tick(host->context) + (uint32_t)rd_s32(body, B_DELAY)));', '                    if (rd_s32(b, O_LOST) == 0) wr_32(b, O_DEADLINE, (int32_t)(host->tick(host->context) + (uint32_t)rd_s32(body, B_DELAY)));', 1, 0),
    ('render-redraw-first', C, 'blit_plan(plan, 0, MP_LABEL_BACKGROUND, NULL, 0, view.clip, b, O_VIEW_COPY);\n        wr_32(b, O_REDRAW, 0);', 'blit_plan(plan, 0, MP_LABEL_BACKGROUND, NULL, 0, view.clip, b, O_VIEW_COPY);', 1, 0),
    ('render-redraw-test', C, 'if (rd_s32(b, O_REDRAW) != 0) {\n        MpView view;', 'if (1) {\n        MpView view;', 1, 0),
    ('render-redraw-clip', C, 'blit_plan(plan, 0, MP_LABEL_BACKGROUND, NULL, 0, view.clip, b, O_VIEW_COPY);', 'blit_plan(plan, 0, MP_LABEL_BACKGROUND, NULL, 0, view.view, b, O_VIEW_COPY);', 1, 0),
    ('render-redraw-dst', C, 'blit_plan(plan, 0, MP_LABEL_BACKGROUND, NULL, 0, view.clip, b, O_VIEW_COPY);', 'blit_plan(plan, 0, MP_LABEL_BACKGROUND, NULL, 0, view.clip, b, O_VIEW);', 1, 0),
    ('render-redraw-kind', C, 'blit_plan(plan, 0, MP_LABEL_BACKGROUND', 'blit_plan(plan, 1, MP_LABEL_BACKGROUND', 1, 0),
    ('render-tab-test', C, 'if (body[B_TABS] != 0) blit_plan(plan, 1, MP_LABEL_TAB', 'if (1) blit_plan(plan, 1, MP_LABEL_TAB', 1, 0),
    ('render-tab-page-stride', C, 'B_TAB_SRC + (size_t)rd_s32(b, O_PAGE) * 0x10u, NULL, b, O_TAB_TARGET', 'B_TAB_SRC + (size_t)rd_s32(b, O_PAGE) * 0x20u, NULL, b, O_TAB_TARGET', 1, 0),
    ('render-tab-dst', C, 'NULL, b, O_TAB_TARGET);', 'NULL, b, O_TAB_HOT);', 1, 0),
    ('render-tab-label', C, 'blit_plan(plan, 1, MP_LABEL_TAB', 'blit_plan(plan, 1, MP_LABEL_VISIBLE', 1, 0),
    ('render-tab-kind', C, 'blit_plan(plan, 1, MP_LABEL_TAB', 'blit_plan(plan, 0, MP_LABEL_TAB', 1, 0),
    ('render-local-page', C, 'int32_t local = mul32(rd_s32(b, O_PAGE), rd_s32(b, O_PER_PAGE));', 'int32_t local = 0;', 1, 0),
    ('render-bounds-low', C, 'if (local < 0 || local >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;', 'if (local >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;', 1, 0),
    ('render-bounds-high', C, 'if (local < 0 || local >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;', 'if (local < 0 || local > rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;', 1, 0),
    ('render-faceup-test', C, 'if (rd_s32(cell, 4) == 1) {\n                const int32_t id', 'if (rd_s32(cell, 4) != 0) {\n                const int32_t id', 1, 0),
    ('render-matched-visible', C, 'if (rd_s32(cell, 4) == 1) {\n                const int32_t id', 'if (rd_s32(cell, 4) == 1 || rd_s32(cell, 8) == 1) {\n                const int32_t id', 1, 0),
    ('render-id-bounds-low', C, 'if (id < 0 || id >= MP_MAX_IDS) return MP_ERR_BOUNDS;', 'if (id >= MP_MAX_IDS) return MP_ERR_BOUNDS;', 1, 0),
    ('render-id-bounds-high', C, 'if (id < 0 || id >= MP_MAX_IDS) return MP_ERR_BOUNDS;', 'if (id < 0 || id > MP_MAX_IDS) return MP_ERR_BOUNDS;', 1, 0),
    ('render-picture-stride', C, 'B_PICTURES + (size_t)id * 16u, NULL, b, O_TILE_RECTS', 'B_PICTURES + (size_t)id * 8u, NULL, b, O_TILE_RECTS', 1, 0),
    ('render-picture-dst', C, 'O_TILE_RECTS + (size_t)j * 16u);\n            } else {', 'O_TILE_RECTS + (size_t)(j ? j - 1 : 0) * 16u);\n            } else {', 1, 0),
    ('render-picture-label', C, 'blit_plan(plan, 1, MP_LABEL_VISIBLE', 'blit_plan(plan, 1, MP_LABEL_HIDDEN', 1, 0),
    ('render-hidden-label', C, 'blit_plan(plan, 0, MP_LABEL_HIDDEN', 'blit_plan(plan, 0, MP_LABEL_VISIBLE', 1, 0),
    ('render-hidden-kind', C, 'blit_plan(plan, 0, MP_LABEL_HIDDEN', 'blit_plan(plan, 1, MP_LABEL_HIDDEN', 1, 0),
    ('render-hidden-src', C, 'B_TILES + (size_t)j * 16u, NULL, b, O_TILE_RECTS + (size_t)j * 16u);\n            }', 'B_TILES + (size_t)(j ? j - 1 : 0) * 16u, NULL, b, O_TILE_RECTS + (size_t)j * 16u);\n            }', 1, 0),
    ('render-inactive', C, 'if (rd_s32(b, O_ACTIVE) == 0) return MP_OK;\n    if (body == NULL || body_length < MP_BODY_BYTES) return MP_ERR_ARGUMENT;\n    plan->valid = 1;', 'plan->valid = 1;\n    if (rd_s32(b, O_ACTIVE) == 0) return MP_OK;\n    if (body == NULL || body_length < MP_BODY_BYTES) return MP_ERR_ARGUMENT;', 1, 0),
    ('render-valid', C, 'plan->valid = 1;\n    if (rd_s32(b, O_REDRAW)', 'if (rd_s32(b, O_REDRAW)', 1, 0),
    ('blit-src-i-order', C, 'p->src[k] = src_i != NULL ? src_i[k] : rd_s32(src, src_off + (size_t)k * 4u);', 'p->src[k] = src_i != NULL ? src_i[3 - k] : rd_s32(src, src_off + (size_t)k * 4u);', 1, 0),
    ('blit-dst-stride', C, 'p->dst[k] = rd_s32(dst, dst_off + (size_t)k * 4u);', 'p->dst[k] = rd_s32(dst, dst_off + (size_t)(k ^ 1) * 4u);', 1, 0),
    ('body-handle-click', C, 'wr_32(b, O_BODY, (int32_t)body_handle);\n    if (!(rd_s32(b, O_ACTIVE)', 'wr_32(b, O_BODY, 0);\n    if (!(rd_s32(b, O_ACTIVE)', 1, 0),
    ('body-handle-phase0', C, 'wr_32(b, O_BODY, (int32_t)body_handle);\n        wr_16(b, O_ROW, row);', 'wr_16(b, O_ROW, row);', 1, 0),
    ('body-handle-phase12', C, 'wr_32(b, O_BODY, (int32_t)body_handle);\n    if (phase == 1u) {', 'if (phase == 1u) {', 1, 0),
    ('phase0-row', C, 'wr_16(b, O_ROW, row);\n        wr_32(b, O_ACTIVE, 1);', 'wr_32(b, O_ACTIVE, 1);', 1, 0),
    ('phase0-active', C, 'wr_32(b, O_ACTIVE, 1);\n        HOST(host->set_start_flag', 'HOST(host->set_start_flag', 1, 0),
    ('phase0-validate', C, 'CHECK(mp_validate_body(body, body_length, failure));\n        wr_32(b, O_BODY', 'wr_32(b, O_BODY', 1, 0),
    ('phase12-validate', C, 'CHECK(mp_validate_body(body, body_length, failure));\n    wr_32(b, O_BODY, (int32_t)body_handle);\n    if (phase == 1u)', 'wr_32(b, O_BODY, (int32_t)body_handle);\n    if (phase == 1u)', 1, 0),
]


# Equivalent mutants: key is the mutant name or "kind|source text"; the value is the reason, read from the kernel and the original.
EQUIVALENT = {
    'c:no-sound-exact-case': 'no_sound_exact is only reached for a record pick_and_play picked, and the pick loop only accepts a record that is not case-insensitively "NO SOUND"; the exact comparison is therefore false for every reachable name, with or without the 9-byte case change.',
    'c:step-win-exact-check': 'same reason: a picked record is never case-insensitively "NO SOUND", so both the exact and the case-insensitive test are false there (-1 is handled first).',
    'c:step-lose-exact-check': 'same reason as step-win-exact-check, for the lose list.',
    'c:no-sound-ci-lower-bound': 'the reference string holds only N O S U D and a space; folding of the byte 0x41 can never make a name byte equal one of them either way.',
    'c:no-sound-ci-upper-bound': 'the byte 0x5a folded or not never equals a byte of "no sound".',
    'c:no-sound-ci-upper-bound-wide': 'the byte 0x5b folded to 0x7b is not a byte of "no sound".',
    'c:no-sound-ci-lower-bound-wide': 'the byte 0x40 folded to 0x60 is not a byte of "no sound".',
    'c:active-test-nonzero': 'the kernel only ever stores 0 or 1 in the active field, so == 1 and != 0 agree on every reachable object.',
    'c:cell-index-lower-bound': 'a pointer below the cell table wraps to a huge distance; d / 12 >= MAX_CELLS already returns -1, so the extra lower test never decides.',
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


DECL = re.compile(r'^\s*(static\s+|const\s+|inline\s+)*(int|void|char|size_t|uint8_t|uint16_t|uint32_t|int8_t|int16_t|int32_t|double|float|MpHost|MpResult|MpObject|MpView|'
                  r'MpTransition|MpBlit|MpPointerResult|MpRenderPlan|MpStatus|unsigned)\b[^=(]*(=.*)?;\s*$')
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
            name = '%s:L%d:%s:%d' % (f.replace('action_family_ee_runtime', 'k'), n + 1, kind, seen[key])
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
    with tempfile.TemporaryDirectory(prefix='RT-60.mut-', dir=str(ROOT / 'work/analysis/slices')) as td:
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


CACHE_LOCK = threading.Lock()


def cached_run(mut, srcdir, stage, timeout, cache, strict=False):
    """run_one with a resumable cache (one JSON line per finished mutant, keyed by name, stage and the sha of the sources)."""
    key = '%s|%s|%s|%s' % (mut['name'], stage, strict, SOURCE_KEY)
    if cache is not None and key in cache:
        return dict(mut, **cache[key])
    res = run_one(mut, srcdir, stage, timeout, strict)
    if cache is not None:
        slim = {k: res[k] for k in ('status', 'detail')}
        with CACHE_LOCK:
            cache[key] = slim
            with open(CACHE_PATH, 'a') as fh:
                fh.write(json.dumps(dict(key=key, **slim)) + '\n')
    return res


SOURCE_KEY = ''
CACHE_PATH = ROOT / 'work/rt60/RT-60.mutation-cache.jsonl'


def main():
    global SOURCE_KEY
    ap = argparse.ArgumentParser()
    ap.add_argument('--stage', choices=('quick', 'full'), default='quick')
    ap.add_argument('--only', default='')
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--result', type=Path)
    ap.add_argument('--src', type=Path, default=PROJECT / 'src')
    ap.add_argument('--list', action='store_true')
    ap.add_argument('--quick-only', action='store_true', help='stop after the quick stage (survivors are listed but not re-run on the full set)')
    ap.add_argument('--full-limit', type=int, default=-1, help='at most N survivors not yet in the cache are re-run on the full set (-1: all)')
    ap.add_argument('--no-cache', action='store_true')
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
    SOURCE_KEY = hashlib.sha256(''.join(shas[f] for f in FILES).encode() + ORACLE.read_bytes() + Path(HERE / 'action_family_ee_runtime_oracle_driver.c').read_bytes()).hexdigest()[:16]
    cache = None
    if not args.no_cache:
        cache = {}
        CACHE_PATH.parent.mkdir(parents=True, exist_ok=True)
        if CACHE_PATH.exists():
            for line in CACHE_PATH.read_text().splitlines():
                try:
                    row = json.loads(line)
                    cache[row['key']] = {'status': row['status'], 'detail': row['detail']}
                except (ValueError, KeyError):
                    pass
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        results = list(pool.map(lambda m: cached_run(m, args.src, args.stage, args.timeout, cache), muts))
    if args.stage == 'quick' and not args.quick_only:
        again = [m for m, r in zip(muts, results) if r['status'] == 'SURVIVED']
        if args.full_limit >= 0:
            fresh = 0
            kept = []
            for m in again:
                if '%s|full|False|%s' % (m['name'], SOURCE_KEY) in (cache or {}):
                    kept.append(m)
                elif fresh < args.full_limit:
                    fresh += 1
                    kept.append(m)
            again = kept
        print('quick stage: %d mutants, %d survived; re-running the survivors on the full scenario set' % (len(muts), len(again)), flush=True)
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            second = list(pool.map(lambda m: cached_run(m, args.src, 'full', args.timeout * 4, cache), again))
        by_name = {r['name']: r for r in second}
        results = [by_name.get(r['name'], r) if r['status'] == 'SURVIVED' else r for r in results]
    # a survivor that only the lenient build lets through is still rejected by the strict -Wall -Wextra -Wpedantic -Werror build the project
    # uses (deleted prototypes: implicit declaration); those are reported as a separate class, not as oracle kills
    left = [m for m, r in zip(muts, results) if r['status'] == 'SURVIVED']
    if left:
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            strict = list(pool.map(lambda m: cached_run(m, args.src, 'quick', args.timeout, cache, True), left))
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
        args.result.write_text(json.dumps(dict(slice='RT-60', source_sha256=shas, stage=args.stage, total=len(results), invalid=len(invalid), strict_rejected=len(strict_killed), killed=len(killed),
                                               survived=len(survivors), equivalent=len(equiv),
                                               results=[{k: v for k, v in r.items() if k in ('name', 'status', 'detail', 'text', 'kind')} for r in results]),
                                          indent=1, sort_keys=True) + '\n')
    return 0 if not open_survivors else 1


if __name__ == '__main__':
    sys.exit(main())
