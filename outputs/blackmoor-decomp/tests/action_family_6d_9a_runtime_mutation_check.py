#!/usr/bin/env python3
"""RT-57 mutation check for the raw-0x6d / raw-0x9a oracle (tests/action_family_6d_9a_runtime_original_oracle.py).

Every mutant is a one-site (a few: two-site, marked) textual edit of a COPY of src/action_family_6d_runtime.c, src/action_family_9a_runtime.c,
the two kernel headers or src/session_bindings_a6d_a9a.c (the project files are never touched). Each mutant is built into a driver library
and run through the original-x86 oracle (`--src DIR`). A mutant is KILLED when the oracle reports at least one mismatch against the
unmodified GAME.EXE image, one of its native-only refusal checks fails, or the mutated native code crashes; it SURVIVES when the oracle
still reports 0 mismatches; it is INVALID if it does not compile or the edit site is not found the stated number of times (invalid
mutants never count as killed).

Usage:  python3 action_family_6d_9a_runtime_mutation_check.py [--stage quick|full] [--only NAME] [--jobs N] [--result FILE] [--check-sites]
Stage `quick` runs the oracle's --quick-only subset (plus the native refusal checks); survivors are re-run on the full scenario set
(--stage full runs every mutant on the full set). Mutants run in parallel, one oracle per mutant (--jobs, default 4).
Equivalent mutants (EQUIVALENT below, each with a reason read from the kernel, the binding and the original) are reported separately and
are not counted in the kill rate; a mutant listed there that is KILLED is reported as killed (the reason is then moot).
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
ROOT = PROJECT.parents[1]
ORACLE = HERE / 'action_family_6d_9a_runtime_original_oracle.py'
FILES = {'k6': 'action_family_6d_runtime.c', 'k9': 'action_family_9a_runtime.c', 'b': 'session_bindings_a6d_a9a.c',
         'h6': 'action_family_6d_runtime.h', 'h9': 'action_family_9a_runtime.h'}

# (name, class, [(file key, old text, new text, expected occurrences of old text, index of the occurrence to edit), ...])
M = []


def m(name, f, cls, old, new, count=1, which=0, more=None):
    sites = [(f, old, new, count, which)]
    if more:
        sites += more
    M.append((name, cls, sites))


# ---------------------------------------------------------------------------------------------------------------------------------
# raw 0x9a kernel: phase machine
# ---------------------------------------------------------------------------------------------------------------------------------
K = 'k9'
m('9a-phase0-test-inverted', K, 'predicate', 'if (phase == 0u) {', 'if (phase != 0u) {')
m('9a-phase0-test-le1', K, 'predicate', 'if (phase == 0u) {', 'if (phase <= 1u) {')
m('9a-phase0-new-phase-1', K, 'constant', 'outcome->phase = 2u;', 'outcome->phase = 1u;')
m('9a-phase0-new-phase-3', K, 'constant', 'outcome->phase = 2u;', 'outcome->phase = 3u;')
m('9a-phase2-test-lt', K, 'predicate', 'if (phase != 2u) {', 'if (phase < 2u) {')
m('9a-phase2-test-gt', K, 'predicate', 'if (phase != 2u) {', 'if (phase > 2u) {')
m('9a-phase2-test-never-works', K, 'predicate', 'if (phase != 2u) {', 'if (1) {')
m('9a-phase-kept-init', K, 'field', 'outcome->phase = phase;', 'outcome->phase = 0u;')
m('9a-disposition-init', K, 'field', 'outcome->disposition = SCENE_ACTION_HANDLER_PENDING;', 'outcome->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;')
m('9a-worked-init', K, 'field', 'outcome->worked = 0;', 'outcome->worked = 1;')
m('9a-transition-init', K, 'field', 'outcome->transition = 0;', 'outcome->transition = 1;')
# ---- the sound word and the stop loops
m('9a-sound-word-index', K, 'index', 'sound = (int16_t)decoded->word[0];', 'sound = (int16_t)decoded->word[1];')
m('9a-sound-15-bit', K, 'sign', 'sound = (int16_t)decoded->word[0];', 'sound = (int16_t)(decoded->word[0] & 0x7fffu);')
m('9a-sound-8-bit', K, 'sign', 'sound = (int16_t)decoded->word[0];', 'sound = (int16_t)(uint8_t)decoded->word[0];')
m('9a-all-from-0-value', K, 'constant', '#define STOP_ALL_FROM_0 0x14', '#define STOP_ALL_FROM_0 0x13')
m('9a-all-from-1-value', K, 'constant', '#define STOP_ALL_FROM_1 0x15', '#define STOP_ALL_FROM_1 0x16')
m('9a-all-from-0-only', K, 'predicate', 'sound == STOP_ALL_FROM_0 || sound == STOP_ALL_FROM_1', 'sound == STOP_ALL_FROM_0')
m('9a-all-from-1-only', K, 'predicate', 'sound == STOP_ALL_FROM_0 || sound == STOP_ALL_FROM_1', 'sound == STOP_ALL_FROM_1')
m('9a-all-low-byte', K, 'sign', 'sound == STOP_ALL_FROM_0 || sound == STOP_ALL_FROM_1', '(sound & 0xff) == STOP_ALL_FROM_0 || (sound & 0xff) == STOP_ALL_FROM_1')
m('9a-loop-start-inverted', K, 'predicate', 'channel = (int16_t)(sound != STOP_ALL_FROM_0)', 'channel = (int16_t)(sound == STOP_ALL_FROM_0)')
m('9a-loop-start-0', K, 'constant', 'channel = (int16_t)(sound != STOP_ALL_FROM_0)', 'channel = (int16_t)0')
m('9a-loop-start-1', K, 'constant', 'channel = (int16_t)(sound != STOP_ALL_FROM_0)', 'channel = (int16_t)1')
m('9a-loop-end-le', K, 'compare', 'channel < STOP_CHANNEL_END', 'channel <= STOP_CHANNEL_END')
m('9a-loop-end-13', K, 'constant', '#define STOP_CHANNEL_END 14', '#define STOP_CHANNEL_END 13')
m('9a-loop-end-15', K, 'constant', '#define STOP_CHANNEL_END 14', '#define STOP_CHANNEL_END 15')
m('9a-loop-step-2', K, 'arith', '++channel', 'channel += 2')
m('9a-single-channel-8-bit', K, 'sign', '(uint16_t)sound) != 0', '(uint8_t)sound) != 0')
m('9a-single-channel-15-bit', K, 'sign', '(uint16_t)sound) != 0', '(uint16_t)(sound & 0x7fff)) != 0')
m('9a-loop-channel-8-bit', K, 'sign', '(uint16_t)channel) != 0', '(uint8_t)channel) != 0')
m('9a-loop-stop-failure-inverted', K, 'predicate', 'host->stop_channel(host->context, (uint16_t)channel) != 0', 'host->stop_channel(host->context, (uint16_t)channel) == 0')
m('9a-single-stop-failure-inverted', K, 'predicate', '(uint16_t)sound) != 0', '(uint16_t)sound) == 0')
m('9a-loop-stop-failure-ignored', K, 'missing-effect', 'return ACTION_FAMILY_9A_RUNTIME_ERR_HOST;', '(void)0;', 3, 0)
m('9a-single-stop-failure-ignored', K, 'missing-effect', 'return ACTION_FAMILY_9A_RUNTIME_ERR_HOST;', '(void)0;', 3, 1)
m('9a-flag-store-failure-ignored', K, 'missing-effect', 'return ACTION_FAMILY_9A_RUNTIME_ERR_HOST;', '(void)0;', 3, 2)
# ---- the flag index query
m('9a-flag-word-index', K, 'index', 'flag_index = (int16_t)decoded->word[11];', 'flag_index = (int16_t)decoded->word[10];')
m('9a-flag-8-bit', K, 'sign', 'flag_index = (int16_t)decoded->word[11];', 'flag_index = (int16_t)(int8_t)decoded->word[11];')
m('9a-flag-query-skips-0', K, 'predicate', 'if (flag_index != -1 && host->event_flag_invalid', 'if (flag_index > 0 && host->event_flag_invalid')
m('9a-flag-query-inverted', K, 'predicate', 'event_flag_invalid(host->context, flag_index) != 0', 'event_flag_invalid(host->context, flag_index) == 0')
m('9a-flag-query-ignores-negatives', K, 'predicate', 'if (flag_index != -1 && host->event_flag_invalid(host->context, flag_index) != 0) {',
  'if (flag_index != -1 && host->event_flag_invalid(host->context, flag_index) != 0 && flag_index >= 0) {')
m('9a-flag-query-skipped', K, 'missing-effect', 'if (flag_index != -1 && host->event_flag_invalid(host->context, flag_index) != 0) {', 'if (0) {')
m('9a-flag-query-only-for-sound-7777', K, 'predicate', 'if (flag_index != -1 && host->event_flag_invalid(host->context, flag_index) != 0) {',
  'if (flag_index != -1 && (host->event_flag_invalid(host->context, flag_index) != 0) && sound == 0x7777) {')
# ---- the scene change cells
m('9a-scene-test-inverted', K, 'predicate', 'if (scene != ACTION_FAMILY_9A_SCENE_NONE) {', 'if (scene == ACTION_FAMILY_9A_SCENE_NONE) {')
m('9a-scene-test-15-bit', K, 'compare', 'if (scene != ACTION_FAMILY_9A_SCENE_NONE) {', 'if ((scene & 0x7fff) != ACTION_FAMILY_9A_SCENE_NONE) {')
m('9a-scene-none-value', 'h9', 'constant', '#define ACTION_FAMILY_9A_SCENE_NONE 9999', '#define ACTION_FAMILY_9A_SCENE_NONE 9998')
m('9a-scene-zero-extended', K, 'sign', 'next.scene_5bb57b = scene;', 'next.scene_5bb57b = (int32_t)(uint16_t)scene;')
m('9a-scene-word-wrong-field', K, 'index', 'scene = (int16_t)decoded->word[1];', 'scene = (int16_t)decoded->word[2];')
m('9a-scene-word-15-bit', K, 'sign', 'scene = (int16_t)decoded->word[1];', 'scene = (int16_t)(decoded->word[1] & 0x7fffu);')
m('9a-word-5bb599-index', K, 'index', 'next.word_5bb599 = (int16_t)decoded->word[2];', 'next.word_5bb599 = (int16_t)decoded->word[3];')
m('9a-word-5bb595-index', K, 'index', 'next.word_5bb595 = (int16_t)decoded->word[3];', 'next.word_5bb595 = (int16_t)decoded->word[2];')
m('9a-word-5c39ff-index', K, 'index', 'next.word_5c39ff = (int16_t)decoded->word[4];', 'next.word_5c39ff = (int16_t)decoded->word[3];')
m('9a-dword-5bb59b-index', K, 'index', 'body_dword(decoded, 5u)', 'body_dword(decoded, 6u)')
m('9a-dword-5bb59f-index', K, 'index', 'body_dword(decoded, 7u)', 'body_dword(decoded, 6u)')
m('9a-dword-5bb5a3-index', K, 'index', 'body_dword(decoded, 9u)', 'body_dword(decoded, 8u)')
m('9a-dword-5bb59b-into-59f', K, 'index', 'next.dword_5bb59f = (int32_t)body_dword(decoded, 7u);', 'next.dword_5bb59f = (int32_t)body_dword(decoded, 5u);')
m('9a-dword-high-half-shift', K, 'arith', '((uint32_t)d->word[word_index + 1u] << 16)', '((uint32_t)d->word[word_index + 1u] << 15)')
m('9a-dword-halves-swapped', K, 'arith', '(uint32_t)d->word[word_index] | ((uint32_t)d->word[word_index + 1u] << 16)',
  '((uint32_t)d->word[word_index] << 16) | (uint32_t)d->word[word_index + 1u]')
m('9a-startflag-inverted', K, 'predicate', 'decoded->byte_26 << 8)) != 1);', 'decoded->byte_26 << 8)) == 1);')
m('9a-startflag-greater', K, 'predicate', 'decoded->byte_26 << 8)) != 1);', 'decoded->byte_26 << 8)) > 1);')
m('9a-startflag-low-byte', K, 'index', '(decoded->word[12] >> 8)', '(decoded->word[12] & 0xffu)')
m('9a-startflag-byte26-shift', K, 'arith', '(uint16_t)decoded->byte_26 << 8', '(uint16_t)decoded->byte_26 << 7')
m('9a-startflag-byte26-unshifted', K, 'arith', '(uint16_t)decoded->byte_26 << 8', '(uint16_t)decoded->byte_26')
m('9a-startflag-unsigned', K, 'sign', '((int16_t)(uint16_t)', '((uint16_t)')
m('9a-startflag-byte26-missing', K, 'index', '((uint16_t)decoded->byte_26 << 8)', '0')
m('9a-engine-mode-3', K, 'constant', 'next.engine_mode_583999 = 4;', 'next.engine_mode_583999 = 3;')
m('9a-engine-mode-0', K, 'constant', 'next.engine_mode_583999 = 4;', 'next.engine_mode_583999 = 0;')
m('9a-transition-flag-missing', K, 'missing-effect', 'outcome->transition = 1;', '(void)0;')
# ---- the event flag store
m('9a-flag-store-skips-0', K, 'predicate', 'if (flag_index != -1 &&\n        host->store_event_flag', 'if (flag_index > 0 &&\n        host->store_event_flag')
m('9a-flag-store-always', K, 'predicate', 'if (flag_index != -1 &&\n        host->store_event_flag', 'if (1 &&\n        host->store_event_flag')
m('9a-flag-store-never', K, 'missing-effect', 'if (flag_index != -1 &&\n        host->store_event_flag', 'if (0 &&\n        host->store_event_flag')
m('9a-flag-value-high-byte', K, 'index', '(uint32_t)(decoded->word[12] & 0xffu)', '(uint32_t)(decoded->word[12] >> 8)')
m('9a-flag-value-7-bit', K, 'arith', 'decoded->word[12] & 0xffu', 'decoded->word[12] & 0x7fu')
m('9a-flag-value-sign-extended', K, 'sign', '(uint32_t)(decoded->word[12] & 0xffu)', '(uint32_t)(int32_t)(int8_t)(decoded->word[12] & 0xffu)')
m('9a-flag-store-index-plus-1', K, 'index', 'host->store_event_flag(host->context, flag_index,', 'host->store_event_flag(host->context, (int16_t)(flag_index + 1),')
m('9a-flag-store-failure-inverted', K, 'predicate', '(uint32_t)(decoded->word[12] & 0xffu)) != 0)', '(uint32_t)(decoded->word[12] & 0xffu)) == 0)')
# ---- completion
m('9a-world-not-committed', K, 'missing-effect', '*world = next;', '(void)0;')
m('9a-completed-generic', K, 'field', 'outcome->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'outcome->disposition = SCENE_ACTION_HANDLER_COMPLETED;')
m('9a-completed-pending', K, 'field', 'outcome->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'outcome->disposition = SCENE_ACTION_HANDLER_PENDING;')
m('9a-worked-not-set', K, 'missing-effect', 'outcome->worked = 1;', '(void)0;')
m('9a-next-from-wrong', K, 'order', 'next = *world;', 'memset(&next, 0, sizeof next);')
# argument validation the binding never trips (see EQUIVALENT)
m('9a-arg-decoded', K, 'validate', 'if (decoded == NULL || world == NULL', 'if (world == NULL')
m('9a-arg-outcome', K, 'validate', ' || outcome == NULL || host->stop_channel == NULL', ' || host->stop_channel == NULL')
m('9a-arg-hooks', K, 'validate', ' || host->stop_channel == NULL ||\n        host->event_flag_invalid == NULL || host->store_event_flag == NULL) {', ') {')

# ---------------------------------------------------------------------------------------------------------------------------------
# raw 0x6d kernel
# ---------------------------------------------------------------------------------------------------------------------------------
K = 'k6'
m('6d-select-overlay-inverted', K, 'predicate', 'if (world->overlay_flag_5bb22a != 0) {', 'if (world->overlay_flag_5bb22a == 0) {')
m('6d-select-overlay-16-bit', K, 'sign', 'if (world->overlay_flag_5bb22a != 0) {', 'if ((int16_t)world->overlay_flag_5bb22a != 0) {')
m('6d-select-overlay-8-bit', K, 'sign', 'if (world->overlay_flag_5bb22a != 0) {', 'if ((uint8_t)world->overlay_flag_5bb22a != 0) {')
m('6d-select-overlay-positive', K, 'sign', 'if (world->overlay_flag_5bb22a != 0) {', 'if (world->overlay_flag_5bb22a > 0) {')
m('6d-select-overlay-equals-1', K, 'compare', 'if (world->overlay_flag_5bb22a != 0) {', 'if (world->overlay_flag_5bb22a == 1) {')
m('6d-select-mode4-16-bit', K, 'sign', 'if (world->popup_mode_583204 == 4) {', 'if ((int16_t)world->popup_mode_583204 == 4) {')
m('6d-select-mode4-8-bit', K, 'sign', 'if (world->popup_mode_583204 == 4) {', 'if ((uint8_t)world->popup_mode_583204 == 4) {')
m('6d-select-mode4-value', K, 'constant', 'if (world->popup_mode_583204 == 4) {', 'if (world->popup_mode_583204 == 5) {')
m('6d-select-mode4-ge', K, 'compare', 'if (world->popup_mode_583204 == 4) {', 'if (world->popup_mode_583204 >= 4) {')
m('6d-select-mode3-16-bit', K, 'sign', 'if (world->popup_mode_583204 == 3) {', 'if ((int16_t)world->popup_mode_583204 == 3) {')
m('6d-select-mode3-8-bit', K, 'sign', 'if (world->popup_mode_583204 == 3) {', 'if ((uint8_t)world->popup_mode_583204 == 3) {')
m('6d-select-mode3-value', K, 'constant', 'if (world->popup_mode_583204 == 3) {', 'if (world->popup_mode_583204 == 2) {')
m('6d-select-mode3-le', K, 'compare', 'if (world->popup_mode_583204 == 3) {', 'if (world->popup_mode_583204 <= 3) {')
m('6d-select-overlay-returns-mode3', K, 'field', 'return ACTION_FAMILY_6D_TEARDOWN_OVERLAY;', 'return ACTION_FAMILY_6D_TEARDOWN_MODE3;')
m('6d-select-mode4-returns-mode3', K, 'field', 'return ACTION_FAMILY_6D_TEARDOWN_MODE4;', 'return ACTION_FAMILY_6D_TEARDOWN_MODE3;')
m('6d-select-mode4-returns-none', K, 'field', 'return ACTION_FAMILY_6D_TEARDOWN_MODE4;', 'return ACTION_FAMILY_6D_TEARDOWN_NONE;')
m('6d-select-mode3-returns-mode4', K, 'field', 'return ACTION_FAMILY_6D_TEARDOWN_MODE3;', 'return ACTION_FAMILY_6D_TEARDOWN_MODE4;')
m('6d-select-mode3-returns-overlay', K, 'field', 'return ACTION_FAMILY_6D_TEARDOWN_MODE3;', 'return ACTION_FAMILY_6D_TEARDOWN_OVERLAY;')
m('6d-select-mode4-before-overlay', K, 'order', 'if (world->overlay_flag_5bb22a != 0) {', 'if (world->overlay_flag_5bb22a != 0 && world->popup_mode_583204 != 4) {')
m('6d-select-mode3-before-overlay', K, 'order', 'if (world->overlay_flag_5bb22a != 0) {', 'if (world->overlay_flag_5bb22a != 0 && world->popup_mode_583204 != 3) {')
m('6d-teardown-host-check-kind', K, 'predicate', 'if (kind != ACTION_FAMILY_6D_TEARDOWN_NONE && host->teardown == NULL) {', 'if (host->teardown == NULL) {')
m('6d-teardown-host-check-dropped', K, 'validate', 'if (kind != ACTION_FAMILY_6D_TEARDOWN_NONE && host->teardown == NULL) {', 'if (0) {')
m('6d-teardown-block-inverted', K, 'predicate', 'if (kind != ACTION_FAMILY_6D_TEARDOWN_NONE) {\n        if (host->teardown', 'if (kind == ACTION_FAMILY_6D_TEARDOWN_NONE) {\n        if (host->teardown')
m('6d-teardown-block-skipped', K, 'missing-effect', 'if (kind != ACTION_FAMILY_6D_TEARDOWN_NONE) {\n        if (host->teardown', 'if (0) {\n        if (host->teardown')
m('6d-teardown-kind-fixed', K, 'field', 'host->teardown(host->context, kind) != 0', 'host->teardown(host->context, ACTION_FAMILY_6D_TEARDOWN_MODE4) != 0')
m('6d-teardown-failure-inverted', K, 'predicate', 'host->teardown(host->context, kind) != 0', 'host->teardown(host->context, kind) == 0')
m('6d-teardown-failure-ignored', K, 'missing-effect', 'return ACTION_FAMILY_6D_RUNTIME_ERR_HOST;', '(void)0;', 2, 0)
m('6d-unload-failure-ignored', K, 'missing-effect', 'return ACTION_FAMILY_6D_RUNTIME_ERR_HOST;', '(void)0;', 2, 1)
m('6d-mode-not-cleared', K, 'missing-effect', 'next.popup_mode_583204 = 0;', '(void)0;')
m('6d-mode-set-1', K, 'constant', 'next.popup_mode_583204 = 0;', 'next.popup_mode_583204 = 1;')
m('6d-overlay-branch-inverted', K, 'predicate', 'if (kind == ACTION_FAMILY_6D_TEARDOWN_OVERLAY) {', 'if (kind != ACTION_FAMILY_6D_TEARDOWN_OVERLAY) {')
m('6d-overlay-branch-ge-mode3', K, 'compare', 'if (kind == ACTION_FAMILY_6D_TEARDOWN_OVERLAY) {', 'if (kind >= ACTION_FAMILY_6D_TEARDOWN_MODE3) {')
m('6d-overlay-branch-ge-mode4', K, 'compare', 'if (kind == ACTION_FAMILY_6D_TEARDOWN_OVERLAY) {', 'if (kind >= ACTION_FAMILY_6D_TEARDOWN_MODE4) {')
m('6d-overlay-flag-not-cleared', K, 'missing-effect', 'next.overlay_flag_5bb22a = 0;', '(void)0;')
m('6d-overlay-flag-set-1', K, 'constant', 'next.overlay_flag_5bb22a = 0;', 'next.overlay_flag_5bb22a = 1;')
m('6d-overlay-return-not-stored', K, 'missing-effect', 'next.overlay_return_6b2 = ACTION_FAMILY_6D_STORED_RETURN_SCENE;', '(void)0;')
m('6d-overlay-return-zero', K, 'constant', 'next.overlay_return_6b2 = ACTION_FAMILY_6D_STORED_RETURN_SCENE;', 'next.overlay_return_6b2 = 0;')
m('6d-overlay-return-value', 'h6', 'constant', '#define ACTION_FAMILY_6D_STORED_RETURN_SCENE 9999', '#define ACTION_FAMILY_6D_STORED_RETURN_SCENE 9998')
m('6d-unload-failure-inverted', K, 'predicate', 'if (host->unload_scene_sound(host->context) != 0) {', 'if (host->unload_scene_sound(host->context) == 0) {')
m('6d-unload-skipped', K, 'missing-effect', 'if (host->unload_scene_sound(host->context) != 0) {', 'if (0) {')
m('6d-unload-twice', K, 'missing-effect', 'if (host->unload_scene_sound(host->context) != 0) {', 'host->unload_scene_sound(host->context);\n    if (host->unload_scene_sound(host->context) != 0) {')
m('6d-unload-before-teardown', K, 'order', 'next = *world;\n', 'next = *world;\n    if (host->unload_scene_sound(host->context) != 0) {\n        return ACTION_FAMILY_6D_RUNTIME_ERR_HOST;\n    }\n',
  more=[('k6', '    if (host->unload_scene_sound(host->context) != 0) {                  /* 0x429129 */\n        return ACTION_FAMILY_6D_RUNTIME_ERR_HOST;\n    }\n', '', 1, 0)])
m('6d-outer-state-5', K, 'constant', 'next.outer_state_583981 = 6;', 'next.outer_state_583981 = 5;')
m('6d-outer-state-7', K, 'constant', 'next.outer_state_583981 = 6;', 'next.outer_state_583981 = 7;')
m('6d-cell-5839a1-not-cleared', K, 'missing-effect', 'next.cell_5839a1 = 0;', '(void)0;')
m('6d-cell-5839a1-set-1', K, 'constant', 'next.cell_5839a1 = 0;', 'next.cell_5839a1 = 1;')
m('6d-engine-mode-not-cleared', K, 'missing-effect', 'next.engine_mode_583999 = 0;', '(void)0;')
m('6d-engine-mode-3', K, 'constant', 'next.engine_mode_583999 = 0;', 'next.engine_mode_583999 = 3;')
m('6d-cell-5bb1e2-not-cleared', K, 'missing-effect', 'next.cell_5bb1e2 = 0;', '(void)0;')
m('6d-cell-5bb1e2-set-1', K, 'constant', 'next.cell_5bb1e2 = 0;', 'next.cell_5bb1e2 = 1;')
m('6d-world-not-committed', K, 'missing-effect', '*world = next;', '(void)0;')
m('6d-next-not-copied', K, 'missing-effect', 'next = *world;', 'memset(&next, 0, sizeof next);')
m('6d-arg-decoded', K, 'validate', 'if (decoded == NULL || world == NULL || host == NULL || host->unload_scene_sound == NULL) {', 'if (world == NULL || host == NULL || host->unload_scene_sound == NULL) {')
m('6d-arg-unload-host', K, 'validate', ' || host->unload_scene_sound == NULL) {', ') {')

# ---------------------------------------------------------------------------------------------------------------------------------
# session bindings: raw 0x6d (first occurrences) and raw 0x9a
# ---------------------------------------------------------------------------------------------------------------------------------
B = 'b'
m('b6d-type-check-dropped', B, 'validate', ' || action->type != SESSION_A6D_TYPE', '')
m('b6d-decode-inverted', B, 'predicate', 'action_family_6d_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_6D_OK', 'action_family_6d_decode(action->raw_body, action->raw_body_length, &decoded) == ACTION_FAMILY_6D_OK')
m('b6d-load-world-null-check-dropped', B, 'validate', 'if (b->host.load_world == NULL || b->host.load_world(b->host.context, &world) != 0) {', 'if (b->host.load_world(b->host.context, &world) != 0) {')
m('b6d-load-world-inverted', B, 'predicate', 'b->host.load_world(b->host.context, &world) != 0) {\n        b->failure = "world provider (cells 0x583204', 'b->host.load_world(b->host.context, &world) == 0) {\n        b->failure = "world provider (cells 0x583204')
m('b6d-unload-null-check-dropped', B, 'validate', 'if (b->host.unload_scene_sound == NULL) {', 'if (0) {')
m('b6d-kernel-teardown-dropped', B, 'missing-effect', 'kernel_host.teardown = b->host.teardown;', 'kernel_host.teardown = NULL;')
m('b6d-kernel-unload-dropped', B, 'missing-effect', 'kernel_host.unload_scene_sound = b->host.unload_scene_sound;', 'kernel_host.unload_scene_sound = NULL;')
m('b6d-kernel-context-dropped', B, 'field', 'kernel_host.context = b->host.context;', 'kernel_host.context = NULL;', 2, 0)
m('b6d-teardown-status-to-host', B, 'predicate', 'status == ACTION_FAMILY_6D_RUNTIME_ERR_TEARDOWN', 'status == ACTION_FAMILY_6D_RUNTIME_ERR_HOST')
m('b6d-teardown-status-any-failure', B, 'predicate', 'status == ACTION_FAMILY_6D_RUNTIME_ERR_TEARDOWN', 'status != ACTION_FAMILY_6D_RUNTIME_OK')
m('b6d-status-inverted', B, 'predicate', 'if (status != ACTION_FAMILY_6D_RUNTIME_OK) {', 'if (status == ACTION_FAMILY_6D_RUNTIME_OK) {')
m('b6d-last-world-missing', B, 'missing-effect', 'b->last_world = world;', '(void)0;', 2, 0)
m('b6d-visits-missing', B, 'missing-effect', '++b->visits;', '(void)0;', 2, 0)
m('b6d-store-world-skipped', B, 'missing-effect', 'if (b->host.store_world != NULL) {', 'if (0) {', 2, 0)
m('b6d-store-world-inverted', B, 'predicate', 'if (b->host.store_world != NULL) {', 'if (b->host.store_world == NULL) {', 2, 0)
m('b6d-phase-cleared', B, 'field', 'out->phase = before->phase;', 'out->phase = 0u;')
m('b6d-phase-constant', B, 'field', 'out->phase = before->phase;', 'out->phase = 2u;')
m('b6d-completed-generic', B, 'field', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;    /* 0x429163', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;    /* 0x429163')
m('b6d-completed-pending', B, 'field', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;    /* 0x429163', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;    /* 0x429163')
m('b6d-world-zero-init', B, 'validate', 'memset(&world, 0, sizeof(world));\n    if (b->host.load_world == NULL', 'if (b->host.load_world == NULL')
m('b9a-type-check-dropped', B, 'validate', ' || action->type != SESSION_A9A_TYPE', '')
m('b9a-decode-inverted', B, 'predicate', 'action_family_9a_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_9A_OK', 'action_family_9a_decode(action->raw_body, action->raw_body_length, &decoded) == ACTION_FAMILY_9A_OK')
m('b9a-stop-null-check-dropped', B, 'validate', 'b->host.stop_channel == NULL || ', '')
m('b9a-flag-query-null-check-dropped', B, 'validate', 'b->host.event_flag_invalid == NULL || ', '')
m('b9a-flag-store-null-check-dropped', B, 'validate', ' || b->host.store_event_flag == NULL) {\n        b->failure = "sound channel stop', ') {\n        b->failure = "sound channel stop')
m('b9a-transition-check-always', B, 'predicate', '(int16_t)decoded.word[1] != ACTION_FAMILY_9A_SCENE_NONE && b->host.transition == NULL', 'b->host.transition == NULL')
m('b9a-transition-check-inverted', B, 'predicate', '(int16_t)decoded.word[1] != ACTION_FAMILY_9A_SCENE_NONE && b->host.transition == NULL', '(int16_t)decoded.word[1] == ACTION_FAMILY_9A_SCENE_NONE && b->host.transition == NULL')
m('b9a-transition-check-unsigned', B, 'sign', '(int16_t)decoded.word[1] != ACTION_FAMILY_9A_SCENE_NONE && b->host.transition == NULL', '(uint16_t)decoded.word[1] != ACTION_FAMILY_9A_SCENE_NONE && b->host.transition == NULL')
m('b9a-transition-check-dropped', B, 'validate', '(int16_t)decoded.word[1] != ACTION_FAMILY_9A_SCENE_NONE && b->host.transition == NULL', '0')
m('b9a-load-world-null-check-dropped', B, 'validate', 'b->host.load_world != NULL && b->host.load_world(b->host.context, &world) != 0', 'b->host.load_world(b->host.context, &world) != 0')
m('b9a-load-world-inverted', B, 'predicate', 'b->host.load_world(b->host.context, &world) != 0) {\n        b->failure = "world provider (scene cells)"', 'b->host.load_world(b->host.context, &world) == 0) {\n        b->failure = "world provider (scene cells)"')
m('b9a-world-zero-init', B, 'validate', 'memset(&world, 0, sizeof(world));\n    if (b->host.load_world != NULL', 'if (b->host.load_world != NULL')
m('b9a-kernel-stop-dropped', B, 'missing-effect', 'kernel_host.stop_channel = b->host.stop_channel;', 'kernel_host.stop_channel = NULL;')
m('b9a-kernel-flag-query-dropped', B, 'missing-effect', 'kernel_host.event_flag_invalid = b->host.event_flag_invalid;', 'kernel_host.event_flag_invalid = NULL;')
m('b9a-kernel-flag-store-dropped', B, 'missing-effect', 'kernel_host.store_event_flag = b->host.store_event_flag;', 'kernel_host.store_event_flag = NULL;')
m('b9a-kernel-context-dropped', B, 'field', 'kernel_host.context = b->host.context;', 'kernel_host.context = NULL;', 2, 1)
m('b9a-phase-argument', B, 'field', 'action_family_9a_runtime_visit(&decoded, before->phase, &world', 'action_family_9a_runtime_visit(&decoded, 2u, &world')
m('b9a-flag-status-to-host', B, 'predicate', 'status == ACTION_FAMILY_9A_RUNTIME_ERR_FLAG', 'status == ACTION_FAMILY_9A_RUNTIME_ERR_HOST')
m('b9a-flag-status-unsupported', B, 'field', 'b->failure = "event flag index outside the window";\n        return SCENE_ACTION_HANDLER_ERROR;', 'b->failure = "event flag index outside the window";\n        return SCENE_ACTION_HANDLER_UNSUPPORTED;')
m('b9a-status-inverted', B, 'predicate', 'if (status != ACTION_FAMILY_9A_RUNTIME_OK) {', 'if (status == ACTION_FAMILY_9A_RUNTIME_OK) {')
m('b9a-worked-inverted', B, 'predicate', 'if (outcome.worked != 0u) {', 'if (outcome.worked == 0u) {')
m('b9a-worked-always', B, 'predicate', 'if (outcome.worked != 0u) {', 'if (1) {')
m('b9a-last-world-missing', B, 'missing-effect', 'b->last_world = world;', '(void)0;', 2, 1)
m('b9a-store-world-skipped', B, 'missing-effect', 'if (b->host.store_world != NULL) {', 'if (0) {', 2, 1)
m('b9a-store-world-inverted', B, 'predicate', 'if (b->host.store_world != NULL) {', 'if (b->host.store_world == NULL) {', 2, 1)
m('b9a-transition-inverted', B, 'predicate', 'if (outcome.transition != 0u) {', 'if (outcome.transition == 0u) {')
m('b9a-transition-always', B, 'predicate', 'if (outcome.transition != 0u) {', 'if (1) {')
m('b9a-request-target', B, 'field', 'request.target_scene = (int16_t)world.scene_5bb57b;', 'request.target_scene = (int16_t)world.word_5c39ff;')
m('b9a-request-target-unsigned', B, 'sign', 'request.target_scene = (int16_t)world.scene_5bb57b;', 'request.target_scene = (int16_t)(world.scene_5bb57b & 0x7fff);')
m('b9a-request-word0', B, 'field', 'request.opaque_words[0] = world.word_5bb599;', 'request.opaque_words[0] = world.word_5bb595;')
m('b9a-request-word1', B, 'field', 'request.opaque_words[1] = world.word_5bb595;', 'request.opaque_words[1] = world.word_5bb599;')
m('b9a-request-word2', B, 'field', 'request.opaque_words[2] = world.word_5c39ff;', 'request.opaque_words[2] = world.word_5bb595;')
m('b9a-request-dword0', B, 'field', 'request.opaque_dwords[0] = world.dword_5bb59b;', 'request.opaque_dwords[0] = world.dword_5bb59f;')
m('b9a-request-dword1', B, 'field', 'request.opaque_dwords[1] = world.dword_5bb59f;', 'request.opaque_dwords[1] = world.dword_5bb5a3;')
m('b9a-request-dword2', B, 'field', 'request.opaque_dwords[2] = world.dword_5bb5a3;', 'request.opaque_dwords[2] = world.dword_5bb59b;')
m('b9a-request-word-unsigned', B, 'sign', 'request.opaque_words[0] = world.word_5bb599;', 'request.opaque_words[0] = (int16_t)(world.word_5bb599 & 0x7fff);')
m('b9a-transition-failure-inverted', B, 'predicate', 'if (b->host.transition(b->host.context, &request) != 0) {', 'if (b->host.transition(b->host.context, &request) == 0) {')
m('b9a-transition-failure-ignored', B, 'missing-effect', 'if (b->host.transition(b->host.context, &request) != 0) {', 'if (b->host.transition(b->host.context, &request) < 0) {')
m('b9a-visits-missing', B, 'missing-effect', '++b->visits;', '(void)0;', 2, 1)
m('b9a-phase-from-before', B, 'field', 'out->phase = outcome.phase;', 'out->phase = before->phase;')
m('b9a-phase-cleared', B, 'field', 'out->phase = outcome.phase;', 'out->phase = 0u;')
m('b9a-disposition-pending', B, 'field', 'out->disposition = outcome.disposition;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;')
m('b9a-disposition-direct', B, 'field', 'out->disposition = outcome.disposition;', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;')
m('b9a-disposition-generic', B, 'field', 'out->disposition = outcome.disposition;', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;')

# Mutants proved equivalent by reading the code and the original: they cannot change any observable behaviour in a state the binding or the
# original can reach, so a surviving run is the expected result. They are reported separately and never count as killed.
EQUIVALENT = {
    '9a-loop-channel-8-bit': 'the loop counter only takes the values 0..13, for which (uint8_t) and (uint16_t) agree',
    '9a-startflag-byte26-shift': 'the word is only compared with 1, and (byte25 | byte26 << k) == 1 holds exactly when byte26 == 0 and byte25 == 1 for every shift k >= 1, so 7 and 8 agree '
                                 '(the unshifted variant 9a-startflag-byte26-unshifted differs and is killed)',
    '9a-startflag-unsigned': 'the word is only compared with 1, and (int16_t)x != 1 and (uint16_t)x != 1 agree for every 16-bit x',
    '9a-arg-decoded': 'the binding passes the address of its own decoded object and a stack outcome; a NULL argument is unreachable through the binding '
                      '(the unit test of the kernel owns the NULL checks)',
    '9a-arg-outcome': 'as 9a-arg-decoded for the outcome pointer',
    '9a-arg-hooks': 'the binding refuses a missing stop / flag query / flag store host (UNSUPPORTED) before it calls the kernel, so the kernel never sees NULL',
    '6d-arg-decoded': 'the binding passes the address of its own decoded object; NULL is unreachable through the binding',
    '6d-arg-unload-host': 'the binding refuses a missing unload host (UNSUPPORTED) before the kernel runs',
    'b9a-transition-check-unsigned': '(int16_t)x != 9999 and (uint16_t)x != 9999 agree for every 16-bit x',
    'b6d-world-zero-init': 'the 6d load_world is required (a missing or failing one is UNSUPPORTED) and fills all seven fields of Action6DWorld, so the zero '
                           'initialisation is never read',
}


def apply(texts, sites):
    out = dict(texts)
    for f, old, new, count, which in sites:
        text = out[f]
        n = text.count(old)
        if n != count:
            raise ValueError('site %r found %d times, expected %d' % (old[:50], n, count))
        pos = -1
        for _ in range(which + 1):
            pos = text.index(old, pos + 1)
        out[f] = text[:pos] + new + text[pos + len(old):]
    return out


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
    if done.returncode < 0 or 'Segmentation' in done.stderr or 'Fatal' in done.stderr or 'crash' in done.stderr:
        return 'KILLED', 'crash (signal %d) %s' % (-done.returncode if done.returncode < 0 else 0, done.stderr[-120:].replace('\n', ' '))
    return 'ERROR', (done.stderr or done.stdout)[-400:].replace('\n', ' ')


def one(args):
    name, cls, sites, texts, work, stage = args
    d = work / name
    d.mkdir()
    for item in (PROJECT / 'src').iterdir():
        if item.suffix in ('.c', '.h'):
            shutil.copy(item, d / item.name)
    row = dict(name=name, cls=cls, files=sorted({FILES[s[0]] for s in sites}), sites=len(sites))
    try:
        mutated = apply(texts, sites)
    except ValueError as e:
        row.update(verdict='INVALID', detail=str(e))
        return row
    for key, fname in FILES.items():
        (d / fname).write_text(mutated[key])
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
    texts = {key: (PROJECT / 'src' / fname).read_text() for key, fname in FILES.items()}
    if a.check_sites:
        bad = 0
        for name, cls, sites in M:
            try:
                after = apply(texts, sites)
                if after == texts:
                    raise ValueError('the edit changes nothing')
            except ValueError as e:
                print('SITE', name, e)
                bad += 1
        names = [t[0] for t in M]
        print('mutants', len(M), 'bad sites', bad, 'duplicate names', len(names) - len(set(names)))
        return 1 if bad else 0
    base = ROOT / 'work' / 'rt57'
    base.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='6d9a_mut_', dir=str(base)))
    t0 = time.monotonic()
    todo = [(name, cls, sites, texts, work, a.stage) for name, cls, sites in M
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
    out['source_sha256'] = {fname: hashlib.sha256((PROJECT / 'src' / fname).read_bytes()).hexdigest() for fname in FILES.values()}
    out['mutation_script_sha256'] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    print(json.dumps({k: v for k, v in out.items() if k != 'rows'}, indent=1))
    if a.result:
        a.result.parent.mkdir(parents=True, exist_ok=True)
        a.result.write_text(json.dumps(out, indent=1, sort_keys=True))
    return 0 if not out['survived'] and not out['invalid'] else 1  # equivalent mutants do not fail the check


if __name__ == '__main__':
    sys.exit(main())
