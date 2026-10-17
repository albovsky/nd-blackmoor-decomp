"""RT-49: raw 0x77 Ordering Puzzle runtime (src/action_family_77_runtime.c) and its session binding (src/session_bindings_a77.c).

Facts under test (original GAME.EXE, read from the disassembly of 0x42ed54, 0x4f0270, 0x43b3d6, 0x4d00f4, 0x42ba3a):
 * phase 0 starts the puzzle (active flag, [0x5bb1ca] := 1, a random limit rand() % 5 (0 and 1 become 2) added to the solution
   length and capped at the button count, selection cleared, the CIFTREE image loaded, the 9-byte sound record A prepared unless
   it is "NO SOUND\\0") and ends in phase 1;
 * phase 1 is a four-state machine on 0x5b5162: compare the chosen order with the solution (or clear it once the limit is
   reached), store the event flag and arm the delay, wait for the GetTickCount deadline and start sound B, wait until sound B is
   no longer busy and ask for phase 2;
 * phase 2 releases the image, stops sound A and applies the exit block (exit asked) or the solved block, then the generic
   completion 0x42ba3a;
 * the pointer cascade hit-tests the buttons and then the exit rectangle (inclusive), the click block toggles the hovered button
   or asks for the exit, the render callback blits the selected-state rectangle of every chosen button.
The unit cases live in tests/action_family_77_runtime_test.c (synthetic bodies); the two real rows of the decoded scenes are
exercised by a private scratch driver. The original-x86 oracle is tests/action_family_77_runtime_original_oracle.py (needs the
private work/ evidence and Unicorn; written separately).
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
TEST_C = PROJECT / 'tests/action_family_77_runtime_test.c'
KERNEL = 'action_family_77_runtime.c'
BINDING = 'session_bindings_a77.c'
SOURCES = [KERNEL, BINDING, 'scene_resource.c', 'hiff.c']
EXPECTED_UNIT_TESTS = 29


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')


def compile_c(output, main_c, sources, src_dir=SRC, extra=(), optimize='-O1'):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', optimize, '-g',
           f'-I{src_dir}', *extra, str(main_c), *[str(Path(src_dir) / s) for s in sources],
           '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


def run_unit(binary):
    done = subprocess.run([str(binary)], capture_output=True, text=True)
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
        # --- phase 0 -----------------------------------------------------------------------------------------------
        'limit not capped by the button count': ('if (limit > n) limit = n;', '(void)0;'),
        'random 0 only becomes 2': ('if (r == 0 || r == 1) r = 2;', 'if (r == 0) r = 2;'),
        'random 1 only becomes 2': ('if (r == 0 || r == 1) r = 2;', 'if (r == 1) r = 2;'),
        'random below 2 becomes 2': ('if (r == 0 || r == 1) r = 2;', 'if (r < 2) r = 2;'),
        'random modulo 4': ('(int16_t)(raw % 5)', '(int16_t)(raw % 4)'),
        'random modulo unsigned': ('(int16_t)(raw % 5)', '(int16_t)((uint32_t)raw % 5u)'),
        'limit ignores the random value': ('(uint16_t)l + (uint16_t)r)', '(uint16_t)l + 2u)'),
        'limit ignores the solution length': ('(uint16_t)l + (uint16_t)r)', '(uint16_t)r)'),
        'start flag not set in phase 0': ('world->start_flag_5bb1ca = 1;\n    fx(host, A77_FX_START_FLAG, 1, 0);\n    s->row = row;',
                                          'world->start_flag_5bb1ca = 0;\n    fx(host, A77_FX_START_FLAG, 1, 0);\n    s->row = row;'),
        'solved not cleared in phase 0': ('s->solved = 0u;\n    world->start_flag', '(void)0;\n    world->start_flag'),
        'exit request not cleared in phase 0': ('s->exit_requested = 0u;\n    raw', '(void)0;\n    raw'),
        'count not cleared in phase 0': ('clear_selection(s);\n    s->count = 0;', 'clear_selection(s);'),
        'row not stored': ('s->row = row;\n    s->exit_requested', '(void)0;\n    s->exit_requested'),
        'active flag not set': ('s->active = 1u;\n    fx(host, A77_FX_ACTIVE, 1, 0);', '(void)0;\n    fx(host, A77_FX_ACTIVE, 1, 0);'),
        'surface handle not kept': ('s->surface = surface;\n        fx(host, A77_FX_SURFACE_LOAD', '(void)0;\n        fx(host, A77_FX_SURFACE_LOAD'),
        'overlay surface not set': ('s->overlay_surface = surface;', '(void)0;'),
        'overlay not activated': ('s->overlay_active = 1u;', 's->overlay_active = 0u;'),
        'held surface not released in phase 0': ('const int rc = release_held(s, host);\n        if (rc != A77_OK) return rc;\n    }\n    {\n        uint32_t surface',
                                                 'const int rc = A77_OK;\n        if (rc != A77_OK) return rc;\n    }\n    {\n        uint32_t surface'),
        'sound A prepared when it is none': ('if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_prepare', 'if (no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_prepare'),
        'sound record compared over 8 bytes': ('memcmp(name, k, sizeof k)', 'memcmp(name, k, 8)'),
        'phase 0 does not reset the inner state': ('s->step = 0u;\n    fx(host, A77_FX_STEP, 0, 0);\n    s->initialized', 'fx(host, A77_FX_STEP, 0, 0);\n    s->initialized'),
        'phase 0 ends in phase 2': ('row_phase = 1u;\n            fx(host, A77_FX_PHASE, 1, 0);', 'row_phase = 2u;\n            fx(host, A77_FX_PHASE, 1, 0);'),
        'phase 0 not flagged initialised': ('result->initialized = 1u;', 'result->initialized = 0u;'),
        'native initialised flag not set': ('s->initialized = 1u;\n    return A77_OK;', 'return A77_OK;'),
        'selection clear leaves the order': ('s->order[i] = -1;\n    }', '(void)0;\n    }'),
        'selection clear leaves the selected bytes': ('s->selected[i] = 0u;\n        s->order', '(void)0;\n        s->order'),
        'selection clear stops early': ('for (int i = 0; i < A77_MAX_BUTTONS; ++i) {\n        s->selected[i] = 0u;', 'for (int i = 0; i < A77_MAX_BUTTONS - 1; ++i) {\n        s->selected[i] = 0u;'),
        # --- phase 1 -----------------------------------------------------------------------------------------------
        'solved flag not set': ('s->solved = 1u;\n        for (int16_t i = 0; i < l; ++i) {', 's->solved = 0u;\n        for (int16_t i = 0; i < l; ++i) {'),
        'solution compared one entry too far': ('for (int16_t i = 0; i < l; ++i) {\n            if (s->order[i]', 'for (int16_t i = 0; i <= l; ++i) {\n            if (s->order[i]'),
        'solution compared one entry short': ('for (int16_t i = 0; i < l; ++i) {\n            if (s->order[i]', 'for (int16_t i = 0; i < l - 1; ++i) {\n            if (s->order[i]'),
        'solution byte sign extended': ('(int16_t)body[B_SOLUTION + (size_t)i]', '(int16_t)(int8_t)body[B_SOLUTION + (size_t)i]'),
        'solution compare inverted': ('if (s->order[i] != (int16_t)body', 'if (s->order[i] == (int16_t)body'),
        'unsolved reset at count above limit': ('} else if (s->count >= s->limit) {', '} else if (s->count > s->limit) {'),
        'unsolved reset below limit': ('} else if (s->count >= s->limit) {', '} else if (s->count >= s->limit - 1) {'),
        'unsolved reset unsigned': ('} else if (s->count >= s->limit) {', '} else if ((uint16_t)s->count >= (uint16_t)s->limit) {'),
        'unsolved reset keeps the count': ('clear_selection(s);\n            s->count = 0;\n        }\n        break;', 'clear_selection(s);\n        }\n        break;'),
        'unsolved reset keeps the selection': ('clear_selection(s);\n            s->count = 0;\n        }\n        break;', 's->count = 0;\n        }\n        break;'),
        'solved moves to the wrong state': ('s->step = 1u;\n            fx(host, A77_FX_STEP, 1, 0);', 's->step = 2u;\n            fx(host, A77_FX_STEP, 1, 0);'),
        'event flag always stored': ('const int16_t flag = rd_s16(body, B_EVENT_FLAG);\n        uint32_t now;\n        if (flag != A77_NO_FLAG) {',
                                     'const int16_t flag = rd_s16(body, B_EVENT_FLAG);\n        uint32_t now;\n        if (1) {'),
        'event flag value from the wrong byte': ('flag, body[B_EVENT_VALUE]));', 'flag, body[B_EVENT_VALUE + 1]));'),
        'delay in milliseconds': ('(int32_t)rd_s16(body, B_DELAY) * 1000)', '(int32_t)rd_s16(body, B_DELAY) * 100)'),
        'delay unsigned': ('(int32_t)rd_s16(body, B_DELAY) * 1000)', '(int32_t)(uint16_t)rd_s16(body, B_DELAY) * 1000)'),
        'deadline subtracts': ('s->deadline = now + (uint32_t)', 's->deadline = now - (uint32_t)'),
        'deadline not armed': ('s->step = 2u;\n        fx(host, A77_FX_STEP, 2, 0);', 's->step = 1u;\n        fx(host, A77_FX_STEP, 2, 0);'),
        'timer fires strictly after': ('if (now >= s->deadline) {', 'if (now > s->deadline) {'),
        'timer fires before': ('if (now >= s->deadline) {', 'if (now + 1u >= s->deadline) {'),
        'timer compare signed': ('if (now >= s->deadline) {', 'if ((int32_t)now >= (int32_t)s->deadline) {'),
        'timer inverted': ('if (now >= s->deadline) {', 'if (now <= s->deadline) {'),
        'sound B tested inverted': ('if (!no_sound(body + B_SOUND_B)) {\n                const int16_t ch', 'if (no_sound(body + B_SOUND_B)) {\n                const int16_t ch'),
        'sound B not prepared': ('HOST(host->sound_prepare(host->context, body + B_SOUND_B));', '(void)0;'),
        'sound B channel from sound A': ('const int16_t ch = rd_s16(body, B_WIN_CHANNEL);\n                HOST(host->sound_prepare', 'const int16_t ch = rd_s16(body, B_CLICK_CHANNEL);\n                HOST(host->sound_prepare'),
        'sound B does not wait': ('s->step = 3u;\n                fx(host, A77_FX_STEP, 3, 0);', 's->step = 2u;\n                fx(host, A77_FX_STEP, 3, 0);'),
        'no sound B does not finish': ('} else {\n                *row_phase = 2u;\n                fx(host, A77_FX_PHASE, 2, 0);\n            }\n        }\n        break;',
                                       '} else {\n                fx(host, A77_FX_PHASE, 2, 0);\n            }\n        }\n        break;'),
        'busy sound finishes': ('if (busy == 0) {\n            HOST(host->sound_stop(host->context, body + B_SOUND_B));', 'if (busy != 0) {\n            HOST(host->sound_stop(host->context, body + B_SOUND_B));'),
        'sound B not stopped': ('HOST(host->sound_stop(host->context, body + B_SOUND_B));', '(void)0;'),
        'sound B stop skipped for none': ('HOST(host->sound_stop(host->context, body + B_SOUND_B));', 'if (!no_sound(body + B_SOUND_B)) HOST(host->sound_stop(host->context, body + B_SOUND_B));'),
        'finish does not ask for phase 2': ('fx(host, A77_FX_SOUND_STOP, B_SOUND_B, 0);\n            *row_phase = 2u;', 'fx(host, A77_FX_SOUND_STOP, B_SOUND_B, 0);\n            *row_phase = 1u;'),
        'state 4 acts': ('default:\n        break; /* the jump table', 'case 4:\n        s->step = 0u;\n        break;\n    default:\n        break; /* the jump table'),
        'states wrap': ('switch (s->step) {', 'switch (s->step & 7u) {'),
        # --- phase 2 -----------------------------------------------------------------------------------------------
        'finish leaves the start flag': ('world->start_flag_5bb1ca = 1;\n    fx(host, A77_FX_START_FLAG, 1, 0);\n    s->active = 0u;', 'world->start_flag_5bb1ca = 0;\n    fx(host, A77_FX_START_FLAG, 1, 0);\n    s->active = 0u;'),
        'finish leaves the puzzle active': ('s->active = 0u;\n    fx(host, A77_FX_ACTIVE, 0, 0);\n    {', '(void)0;\n    fx(host, A77_FX_ACTIVE, 0, 0);\n    {'),
        'finish keeps the surface': ('const int rc = release_held(s, host);\n        if (rc != A77_OK) return rc;\n    }\n    s->overlay_active = 0u;', 'const int rc = A77_OK;\n        if (rc != A77_OK) return rc;\n    }\n    s->overlay_active = 0u;'),
        'release keeps the handle': ('HOST(host->release_surface(host->context, held));\n    s->surface = 0u;\n    fx(host, A77_FX_RELEASE_SURFACE, (int32_t)held, 0);\n    return A77_OK;',
                                     'HOST(host->release_surface(host->context, held));\n    fx(host, A77_FX_RELEASE_SURFACE, (int32_t)held, 0);\n    return A77_OK;'),
        'finish keeps the overlay drawn': ('s->overlay_active = 0u; /* overlay_surface keeps', '(void)0; /* overlay_surface keeps'),
        'finish clears the stale overlay surface': ('s->overlay_active = 0u; /* overlay_surface keeps', 's->overlay_active = 0u; s->overlay_surface = 0u; /* overlay_surface keeps'),
        'sound A not stopped': ('HOST(host->sound_stop(host->context, body + B_SOUND_A));', '(void)0;'),
        'sound A stopped when none': ('if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_stop', 'if (no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_stop'),
        'exit and solved blocks swapped': ('if (s->exit_requested != 0u) {\n        const int rc = apply_block', 'if (s->exit_requested == 0u) {\n        const int rc = apply_block'),
        'exit block from the solved offset': ('apply_block(body + B_EXIT_BLOCK, rd_s16(body, B_EXIT_START)', 'apply_block(body + B_SOLVED_BLOCK, rd_s16(body, B_EXIT_START)'),
        'solved start flag from the exit word': ('apply_block(body + B_SOLVED_BLOCK, rd_s16(body, B_SOLVED_START)', 'apply_block(body + B_SOLVED_BLOCK, rd_s16(body, B_EXIT_START)'),
        'exit start flag from the solved word': ('apply_block(body + B_EXIT_BLOCK, rd_s16(body, B_EXIT_START)', 'apply_block(body + B_EXIT_BLOCK, rd_s16(body, B_SOLVED_START)'),
        'no-scene compare inverted': ('if (rd_s16(blk, SB_SCENE) == A77_NO_SCENE) return A77_OK;', 'if (rd_s16(blk, SB_SCENE) != A77_NO_SCENE) return A77_OK;'),
        'scene compared unsigned': ('if (rd_s16(blk, SB_SCENE) == A77_NO_SCENE) return A77_OK;', 'if ((uint16_t)rd_s16(blk, SB_SCENE) == A77_NO_SCENE || rd_s16(blk, SB_SCENE) < 0) return A77_OK;'),
        'transition words swapped': ('t.word[0] = rd_s16(blk, SB_W1);', 't.word[0] = rd_s16(blk, SB_W2);'),
        'transition third word wrong': ('t.word[2] = rd_s16(blk, SB_W3);', 't.word[2] = rd_s16(blk, SB_W1);'),
        'transition dwords swapped': ('t.dword[0] = rd_s32(blk, SB_D1);', 't.dword[0] = rd_s32(blk, SB_D2);'),
        'transition third dword wrong': ('t.dword[2] = rd_s32(blk, SB_D3);', 't.dword[2] = rd_s32(blk, SB_D1);'),
        'start flag 1 stores 1': ('start_word == 1 ? 0 : 1', 'start_word == 1 ? 1 : 0'),
        'start flag 0 stores 0': ('start_word == 1 ? 0 : 1', 'start_word == 0 ? 1 : 0'),
        'engine mode not 4': ('fx(host, A77_FX_ENGINE_MODE, 4, 0);', 'fx(host, A77_FX_ENGINE_MODE, 3, 0);'),
        'exit event flag always stored': ('const int16_t flag = rd_s16(body, B_EXIT_FLAG);\n            if (flag != A77_NO_FLAG) {', 'const int16_t flag = rd_s16(body, B_EXIT_FLAG);\n            if (1) {'),
        'exit event flag value wrong': ('flag, body[B_EXIT_VALUE]));', 'flag, body[B_EXIT_VALUE + 1]));'),
        'exit event flag skipped without a scene': ('if (rc != A77_OK) return rc;\n        {\n            const int16_t flag = rd_s16(body, B_EXIT_FLAG);',
                                                    'if (rc != A77_OK || rd_s16(body + B_EXIT_BLOCK, SB_SCENE) == A77_NO_SCENE) return rc;\n        {\n            const int16_t flag = rd_s16(body, B_EXIT_FLAG);'),
        'completion not flagged': ('result->completed = 1u;', 'result->completed = 0u;'),
        'completion keeps the phase': ('row_phase = 0u; /* 0x42ba3a stores phase 0 */', '(void)0;'),
        # --- the visit ---------------------------------------------------------------------------------------------
        'phase 1 allowed without phase 0': ('if (state->initialized == 0u || state->row != row) {', 'if (0) {'),
        'phase 1 allowed for another row': ('if (state->initialized == 0u || state->row != row) {', 'if (state->initialized == 0u) {'),
        'event flag check dropped': ('host->event_flag_invalid(host->context, flag) != 0) {', '0) {'),
        'event flag check inverted': ('host->event_flag_invalid(host->context, flag) != 0) {', 'host->event_flag_invalid(host->context, flag) == 0) {'),
        'event flag checked in the wrong state': ('if (phase == 1u && state->step == 1u)', 'if (phase == 1u && state->step == 0u)'),
        'exit flag checked on the solved path': ('else if (phase == 2u && state->exit_requested != 0u)', 'else if (phase == 2u)'),
        'host completeness not checked': ('host->transition != NULL && host->store_event_flag != NULL;', 'host->transition != NULL;'),
        'negative row accepted': ('if (row < 0) {\n            if (failure != NULL) *failure = "0x77-row";', 'if (0) {\n            if (failure != NULL) *failure = "0x77-row";'),
        'other phases act': ('rc = A77_OK; /* any other phase falls out of the switch */', 'rc = phase1(state, body, &row_phase, host);'),
        'body not validated': ('if (a77_validate_body(body, body_length, &why) != A77_OK) {\n        if (failure != NULL) *failure = why;\n        return A77_ERR_BODY;',
                               'if (0) {\n        if (failure != NULL) *failure = why;\n        return A77_ERR_BODY;'),
        # --- validation --------------------------------------------------------------------------------------------
        'button count 17 accepted': ('n > A77_MAX_BUTTONS', 'n > A77_MAX_BUTTONS + 1'),
        'negative button count accepted': ('(n = rd_s16(body, B_COUNT)) < 0 ||', '(n = rd_s16(body, B_COUNT)) < -1 ||'),
        'solution length 17 accepted': ('l > A77_MAX_BUTTONS', 'l > A77_MAX_BUTTONS + 1'),
        'negative solution length accepted': ('(l = rd_s16(body, B_SOLUTION_LEN)) < 0 ||', '(l = rd_s16(body, B_SOLUTION_LEN)) < -1 ||'),
        'unterminated name accepted': ('memchr(body, 0, B_NAME_BYTES) == NULL', 'memchr(body, 0, B_NAME_BYTES - 1) == NULL'),
        'body length not checked': ('length != A77_BODY_BYTES', 'length < A77_BODY_BYTES'),
        # --- pointer -----------------------------------------------------------------------------------------------
        'pointer top edge exclusive': ('return rd_s32(body, rect + 4) <= y', 'return rd_s32(body, rect + 4) < y'),
        'pointer bottom edge exclusive': ('y <= rd_s32(body, rect + 12) &&', 'y < rd_s32(body, rect + 12) &&'),
        'pointer left edge exclusive': ('rd_s32(body, rect) <= x &&', 'rd_s32(body, rect) < x &&'),
        'pointer right edge exclusive': ('x <= rd_s32(body, rect + 8);', 'x < rd_s32(body, rect + 8);'),
        'pointer top and bottom swapped': ('return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12)', 'return rd_s32(body, rect + 12) <= y && y <= rd_s32(body, rect + 4)'),
        'pointer coordinates unsigned': ('return rd_s32(body, rect + 4) <= y', 'return (uint32_t)rd_s32(body, rect + 4) <= (uint32_t)y'),
        'pointer inactive still claims': ('if (state->active == 0u) return A77_OK;\n    n = rd_s16(body, B_COUNT);\n    for (int16_t i = 0; i < n; ++i) {\n        if (in_rect',
                                          'n = rd_s16(body, B_COUNT);\n    for (int16_t i = 0; i < n; ++i) {\n        if (in_rect'),
        'pointer tests one button too many': ('for (int16_t i = 0; i < n; ++i) {\n        if (in_rect', 'for (int16_t i = 0; i <= n; ++i) {\n        if (in_rect'),
        'pointer tests one button too few': ('for (int16_t i = 0; i < n; ++i) {\n        if (in_rect', 'for (int16_t i = 0; i < n - 1; ++i) {\n        if (in_rect'),
        'pointer hover not stored': ('state->hover = i; /* word 0x5b515b */', '(void)0;'),
        'pointer reports the wrong candidate': ('out->candidate = A77_CANDIDATE_BUTTON;', 'out->candidate = A77_CANDIDATE_EXIT;'),
        'pointer button cursor sub missing': ('out->cursor_sub = 1u;', 'out->cursor_sub = 0u;'),
        'pointer exit cursor wrong': ('out->cursor_kind = A77_CURSOR_EXIT;', 'out->cursor_kind = 1u;'),
        'pointer exit candidate wrong': ('out->candidate = A77_CANDIDATE_EXIT;\n        out->cursor_kind', 'out->candidate = A77_CANDIDATE_BUTTON;\n        out->cursor_kind'),
        'pointer exit rectangle at the button offset': ('in_rect(body, B_EXIT_RECT, x, y)', 'in_rect(body, B_BUTTON_RECT, x, y)'),
        'pointer exit hit not claimed': ('if (in_rect(body, B_EXIT_RECT, x, y)) {\n        out->hit = 1u;', 'if (in_rect(body, B_EXIT_RECT, x, y)) {\n        out->hit = 0u;'),
        'pointer button hit not claimed': ('state->hover = i; /* word 0x5b515b */\n            out->hit = 1u;', 'state->hover = i; /* word 0x5b515b */\n            out->hit = 0u;'),
        'pointer exit stores the hover': ('out->cursor_kind = A77_CURSOR_EXIT;', 'out->cursor_kind = A77_CURSOR_EXIT; state->hover = -1;'),
        'pointer keeps scanning buttons after a hit': ('out->cursor_sub = 1u;\n            return A77_OK;', 'out->cursor_sub = 1u;'),
        # --- click -------------------------------------------------------------------------------------------------
        'click works when solved': ('if (state->active == 0u || state->solved != 0u) return A77_OK;', 'if (state->active == 0u) return A77_OK;'),
        'click works when inactive': ('if (state->active == 0u || state->solved != 0u) return A77_OK;', 'if (state->solved != 0u) return A77_OK;'),
        'click only when unsolved inverted': ('if (state->active == 0u || state->solved != 0u) return A77_OK;', 'if (state->active == 0u || state->solved == 0u) return A77_OK;'),
        'click button candidate': ('if (candidate == A77_CANDIDATE_BUTTON) {\n        const int16_t h', 'if (candidate != A77_CANDIDATE_BUTTON) {\n        const int16_t h'),
        'click hover bound too high': ('if (h < 0 || h >= n ||', 'if (h < 0 || h > n ||'),
        'click negative hover accepted': ('if (h < 0 || h >= n ||', 'if (h < -1 || h >= n ||'),
        'click count bound too high': ('state->count > A77_MAX_BUTTONS) return A77_ERR_BOUNDS;', 'state->count > A77_MAX_BUTTONS + 1) return A77_ERR_BOUNDS;'),
        'click negative count accepted': ('state->count < 0 || state->count > A77_MAX_BUTTONS', 'state->count < -1 || state->count > A77_MAX_BUTTONS'),
        'toggle off tests the wrong entry': ('int16_t t = (int16_t)(state->count - 1);', 'int16_t t = state->count;'),
        'toggle off never clamps t': ('if (t < 0) t = 0;', '(void)0;'),
        'toggle off pops any entry': ('if (state->order[t] == h) {', 'if (1) {'),
        'toggle off pops the wrong entry': ('if (state->order[t] == h) {', 'if (state->order[t] != h) {'),
        'toggle off keeps the selected byte': ('state->selected[h] = 0u;\n            if (t < 0)', '(void)0;\n            if (t < 0)'),
        'toggle off keeps the count': ('state->count = (int16_t)(state->count - 1);\n                if (state->count < 0)', '(void)0;\n                if (state->count < 0)'),
        'toggle off count not clamped': ('if (state->count < 0) state->count = 0;', '(void)0;'),
        'toggle off leaves the order cell': ('state->order[state->count] = -1;', '(void)0;'),
        'toggle on keeps the selected byte': ('state->selected[h] = 1u;\n            if (state->count <= n - 1)', '(void)0;\n            if (state->count <= n - 1)'),
        'toggle on stores one entry too early': ('if (state->count <= n - 1) state->order[state->count] = h;', 'if (state->count < n - 1) state->order[state->count] = h;'),
        'toggle on stores past the count': ('if (state->count <= n - 1) state->order[state->count] = h;', 'if (state->count <= n) state->order[state->count] = h;'),
        'toggle on never stores': ('if (state->count <= n - 1) state->order[state->count] = h;', '(void)0;'),
        'toggle on stores the count': ('state->order[state->count] = h;', 'state->order[state->count] = state->count;'),
        'toggle on never clamps': ('if (state->count > n) state->count = n;', '(void)0;'),
        'toggle on clamps too late': ('if (state->count > n) state->count = n;', 'if (state->count > n + 1) state->count = n;'),
        'toggle not reported': ('out->toggled = 1u;', 'out->toggled = 0u;'),
        'click sound ignores the start flag': ('const int want_sound = start_flag != 0 && !no_sound(body + B_SOUND_A);', 'const int want_sound = !no_sound(body + B_SOUND_A);'),
        'click sound inverted flag': ('const int want_sound = start_flag != 0 && !no_sound(body + B_SOUND_A);', 'const int want_sound = start_flag == 0 && !no_sound(body + B_SOUND_A);'),
        'click sound ignores the record': ('const int want_sound = start_flag != 0 && !no_sound(body + B_SOUND_A);', 'const int want_sound = start_flag != 0;'),
        'click sound wrong channel': ('const int16_t ch = rd_s16(body, B_CLICK_CHANNEL);', 'const int16_t ch = rd_s16(body, B_WIN_CHANNEL);'),
        'click sound not reported': ('out->click_sound = 1u;', 'out->click_sound = 0u;'),
        'exit click candidate': ('} else if (candidate == A77_CANDIDATE_EXIT) {\n        state->exit_requested', '} else if (candidate == A77_CANDIDATE_BUTTON) {\n        state->exit_requested'),
        'exit click does not record the request': ('state->exit_requested = 1u;\n        out->exit_asked', '(void)0;\n        out->exit_asked'),
        'exit click does not ask': ('out->exit_asked = 1u;', 'out->exit_asked = 0u;'),
        'exit click keeps the phase': ('out->new_phase = 2u;', 'out->new_phase = row_phase;'),
        # --- render plan -------------------------------------------------------------------------------------------
        'render ignores the overlay flag': ('if (state->overlay_active == 0u) return A77_OK;\n    if (host->view_origin', 'if (0) return A77_OK;\n    if (host->view_origin'),
        'render tests the active flag': ('if (state->overlay_active == 0u) return A77_OK;\n    if (host->view_origin', 'if (state->active == 0u) return A77_OK;\n    if (host->view_origin'),
        'render surface wrong': ('plan->surface = state->overlay_surface;', 'plan->surface = state->surface;'),
        'render count wrong': ('plan->count = n;', 'plan->count = n - 1;'),
        'render not valid': ('plan->valid = 1u;', 'plan->valid = 0u;'),
        'render x origin dropped': ('b->dst[0] = (int32_t)((uint32_t)rd_s32(body, rect) + (uint32_t)vx);', 'b->dst[0] = rd_s32(body, rect);'),
        'render y origin dropped': ('b->dst[1] = (int32_t)((uint32_t)rd_s32(body, rect + 4) + (uint32_t)vy);', 'b->dst[1] = rd_s32(body, rect + 4);'),
        'render right origin wrong': ('b->dst[2] = (int32_t)((uint32_t)rd_s32(body, rect + 8) + (uint32_t)vx);', 'b->dst[2] = (int32_t)((uint32_t)rd_s32(body, rect + 8) + (uint32_t)vy);'),
        'render bottom origin wrong': ('b->dst[3] = (int32_t)((uint32_t)rd_s32(body, rect + 12) + (uint32_t)vy);', 'b->dst[3] = (int32_t)((uint32_t)rd_s32(body, rect + 12) + (uint32_t)vx);'),
        'render selected flag inverted': ('b->selected = state->selected[i] != 0u ? 1u : 0u;', 'b->selected = state->selected[i] != 0u ? 0u : 1u;'),
        'render selected rectangle stride': ('B_SELECTED_SRC + (size_t)i * 16u : rect;', 'B_SELECTED_SRC + (size_t)i * 8u : rect;'),
        'render unselected uses the selected rectangle': ('b->selected != 0u ? B_SELECTED_SRC + (size_t)i * 16u : rect;', 'B_SELECTED_SRC + (size_t)i * 16u;'),
        'render selected uses the button rectangle': ('b->selected != 0u ? B_SELECTED_SRC + (size_t)i * 16u : rect;', 'rect;'),
        'render origin failure ignored': ('if (host->view_origin(host->context, &vx, &vy) != 0) return A77_ERR_HOST;', 'host->view_origin(host->context, &vx, &vy);'),
        # --- clear -------------------------------------------------------------------------------------------------
        'clear keeps the puzzle active': ('state->active = 0u;\n    fx(host, A77_FX_ACTIVE, 0, 0);\n    state->overlay_active', '(void)0;\n    fx(host, A77_FX_ACTIVE, 0, 0);\n    state->overlay_active'),
        'clear keeps the overlay drawn': ('state->overlay_active = 0u;\n    fx(host, A77_FX_OVERLAY_ACTIVE, 0, 0);\n    state->initialized', '(void)0;\n    fx(host, A77_FX_OVERLAY_ACTIVE, 0, 0);\n    state->initialized'),
        'clear keeps the initialisation': ('state->initialized = 0u; /* native only', '(void)0; /* native only'),
        'clear keeps the surface handle': ('HOST(host->release_surface(host->context, held));\n        state->surface = 0u;\n        fx(host, A77_FX_RELEASE_SURFACE', 'HOST(host->release_surface(host->context, held));\n        fx(host, A77_FX_RELEASE_SURFACE'),
        'clear releases nothing': ('if (state->surface != 0u) {\n        const uint32_t held = state->surface;\n        HOST(host->release_surface(host->context, held));', 'if (0) {\n        const uint32_t held = state->surface;\n        HOST(host->release_surface(host->context, held));'),
        'clear releases an empty handle': ('if (state->surface != 0u) {\n        const uint32_t held = state->surface;\n        HOST(host->release_surface(host->context, held));', 'if (1) {\n        const uint32_t held = state->surface;\n        HOST(host->release_surface(host->context, held));'),
        'reset leaves the state': ('if (state != NULL) memset(state, 0, sizeof(*state));', '(void)0;'),
    },
    BINDING: {
        'row copy skipped': ('memcpy(rows[i].body, info.typed_body, A77_BODY_BYTES);\n        rows[i].present = 1u;', 'rows[i].present = 1u;'),
        'row not marked present': ('rows[i].present = 1u;\n    }', '(void)0;\n    }'),
        'rows of other types copied': ('if (info.type != SESSION_A77_TYPE) continue;', '(void)0;'),
        'bad body accepted': ('if (a77_validate_body(info.typed_body, info.typed_body_length, &why) != A77_OK) {', 'if (0) {'),
        'bad body failure text lost': ('binding->failure = why;\n            return A77_ERR_BODY;', 'binding->failure = "none";\n            return A77_ERR_BODY;'),
        'previous scene not cleared': ('if (a77_clear(&binding->state, &binding->host.kernel) != A77_OK) {\n        free(rows);\n        binding->failure = "0x77-scene-clear";', 'if (0) {\n        free(rows);\n        binding->failure = "0x77-scene-clear";'),
        'clear failure ignored': ('binding->failure = "0x77-scene-clear";\n        return A77_ERR_HOST;', 'binding->failure = "0x77-scene-clear";\n        return A77_OK;'),
        'rows not replaced': ('binding->rows = rows;\n    binding->count = count;', 'free(rows);'),
        'destroy does not clear': ('(void)a77_clear(&binding->state, &binding->host.kernel);\n    free(binding->rows);', 'free(binding->rows);'),
        'foreign row accepted': ('action->type != SESSION_A77_TYPE ||', '0 ||'),
        'absent row accepted': ('|| binding->rows[index].present == 0u ||', '||'),
        'handler uses the wrong body': ('binding->rows[index].body, A77_BODY_BYTES, (int16_t)index', 'binding->rows[0].body, A77_BODY_BYTES, (int16_t)index'),
        'unsupported becomes an error': ('if (status == A77_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;', 'if (status == A77_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_ERROR;'),
        'errors are accepted': ('if (status != A77_OK) return SCENE_ACTION_HANDLER_ERROR;', '(void)0;'),
        'world stored only on init': ('(result.initialized != 0u || result.completed != 0u) &&', '(result.initialized != 0u) &&'),
        'world stored only on completion': ('(result.initialized != 0u || result.completed != 0u) &&', '(result.completed != 0u) &&'),
        'world stored on every visit': ('(result.initialized != 0u || result.completed != 0u) &&', '1 &&'),
        'phase before kept': ('out->phase = result.phase_after;', 'out->phase = before->phase;'),
        'completion left pending': ('result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_PENDING'),
        'every visit completes': ('result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_COMPLETED'),
        'failure text lost': ('binding->failure = why != NULL ? why : "none";', 'binding->failure = "none";'),
        'pointer on an inactive puzzle': ('if (binding->state.active == 0u) return A77_OK; /* 0x4f0290 jumps to 0x4f04b6 */', '(void)0;'),
        'pointer result not cleared': ('memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    out->hover = -1;\n    if (binding->state.active', 'out->candidate = -1;\n    out->hover = -1;\n    if (binding->state.active'),
        'pointer candidate default': ('out->candidate = -1;\n    out->hover = -1;\n    if (binding->state.active', 'out->candidate = 0;\n    out->hover = -1;\n    if (binding->state.active'),
        'pointer hover default': ('out->candidate = -1;\n    out->hover = -1;\n    if (binding->state.active', 'out->candidate = -1;\n    out->hover = 0;\n    if (binding->state.active'),
        'click on an inactive puzzle': ('*new_phase = row_phase;\n    if (binding->state.active == 0u) return A77_OK;', '*new_phase = row_phase;'),
        'click phase dropped': ('if (status == A77_OK) *new_phase = result.new_phase;', '(void)0;'),
        'click failure text': ('binding->failure = status == A77_OK ? "none" : "0x77-click";', 'binding->failure = "none";'),
        'click row phase passed wrong': ('A77_BODY_BYTES, row_phase, candidate, start_flag', 'A77_BODY_BYTES, 1u, candidate, start_flag'),
        'click start flag dropped': ('A77_BODY_BYTES, row_phase, candidate, start_flag', 'A77_BODY_BYTES, row_phase, candidate, 0'),
        'plan drawn without the overlay': ('if (binding->state.overlay_active == 0u) { /* the generic entry is not drawn */', 'if (0) {'),
    },
}


def mutated_copy(root, key, filename, old, new):
    original = (SRC / filename).read_text()
    if original.count(old) != 1:
        raise AssertionError(f'mutation anchor drifted ({original.count(old)} matches): {old[:70]!r}')
    work = Path(root) / key
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir(parents=True)
    for item in SRC.iterdir():
        if item.suffix in ('.c', '.h'):
            shutil.copy(item, work / item.name)
    (work / filename).write_text(original.replace(old, new, 1))
    return work


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a77_test'
        built = compile_c(cls.binary, TEST_C, SOURCES, extra=('-Werror',))
        assert built.returncode == 0, built.stderr

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
        for cc in (compiler(), shutil.which('gcc')):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'a77_test_san'
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

    def test_mutations_are_detected(self):
        """The cases must fail when a recovered rule is deliberately broken."""
        jobs = []
        for filename, mutations in MUTANTS.items():
            for name, (old, new) in mutations.items():
                jobs.append((filename, name, old, new))

        def build_and_run(index_job):
            index, (filename, name, old, new) = index_job
            work = mutated_copy(self.tmp.name, f'mut{index}', filename, old, new)
            binary = work / 'mut_test'
            built = compile_c(binary, TEST_C, SOURCES, src_dir=work, optimize='-O0')
            if built.returncode != 0:
                return name, 'build', built.stderr[-300:]
            code, _ = run_unit(binary)
            shutil.rmtree(work, ignore_errors=True)
            return name, 'killed' if code != 0 else 'survived', ''

        with concurrent.futures.ThreadPoolExecutor(max_workers=min(8, os.cpu_count() or 2)) as pool:
            outcomes = list(pool.map(build_and_run, enumerate(jobs)))
        self.assertEqual(len({name for _, name, _, _ in jobs}), len(jobs), 'duplicate mutant names')
        for name, verdict, detail in outcomes:
            with self.subTest(name):
                self.assertEqual(verdict, 'killed', f'mutant {verdict}: {name} {detail}')


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_77_runtime.sh')],
                              capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())


class Registration(unittest.TestCase):
    def test_module_is_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        self.assertIn(' action_family_77_runtime session_bindings_a77', build)


if __name__ == '__main__':
    unittest.main()
