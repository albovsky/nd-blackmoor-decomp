"""RT-58: raw 0x76 PASSWORD puzzle runtime (src/action_family_76_runtime.c) and the session binding
(src/session_bindings_a76.c).

Facts under test (original GAME.EXE, handler 0x42fc70 and its blocks as recorded in src/action_family_76_runtime.h and in
tasks/RT-58-password-puzzle-76-runtime.md; the comparison with the original x86 code is the oracle's job, see
tests/test_action_family_76_runtime_oracle.py):
 * phase 0 initialises the puzzle (start flag, font reference, rectangles shifted by the view origin, blink deadline), phase 1 is
   an inner state machine on the typed text (two fields, cursor blink, Backspace, Enter, the sounds), phase 2 leaves through the
   correct, wrong or cancel block and reports the generic completion;
 * the character filter, the pointer block (cancel strip), the click, invalidate, cleanup, new game and the render callback;
 * the session binding: row bodies copied and validated per scene, the static render entry flag, the start flag hook.
The unit cases live in tests/action_family_76_runtime_test.c (synthetic bodies, no original bytes) and the corpus check in
tests/action_family_76_runtime_corpus.c (the real row of resource 2529).
"""
import concurrent.futures
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/action_family_76_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_76_runtime_corpus.c'
KERNEL = 'action_family_76_runtime.c'
BINDING = 'session_bindings_a76.c'
SUPPORT = ['scene_resource.c', 'hiff.c']
SOURCES = [KERNEL, BINDING, *SUPPORT]
EXPECTED_UNIT_TESTS = 18
RESOURCES = PROJECT.parents[1] / 'work/analysis/hiff-resources'
CORPUS_ROWS = ('2529.bin',)


def compiler():
    # The repo scripts call `xcrun clang` for macOS; where xcrun is absent (cloud container) use clang, cc or gcc.
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')


WARN = ['-std=c11', '-Wall', '-Wextra', '-Wpedantic']
# gcc 13 reports a type-limits warning in scene_resource.c (not part of this slice); it is not an error here.
NO_ERROR = ['-Wno-error=type-limits']
SANITIZE = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined']


def compile_c(output, main_c, sources, src_dir=SRC, extra=(), optimize='-O1', cc=None, objects=(), werror=True):
    cmd = [cc or compiler(), *WARN, *(['-Werror', *NO_ERROR] if werror else []), optimize, '-g', f'-I{src_dir}', *extra, str(main_c),
           *[str(Path(src_dir) / s) for s in sources], *map(str, objects), '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


def run_unit(binary, env=None):
    done = subprocess.run([str(binary)], capture_output=True, text=True, env=env)
    results = {}
    for line in done.stdout.splitlines():
        status, _, rest = line.partition(' ')
        if status in ('PASS', 'FAIL'):
            name, _, message = rest.partition(': ')
            results[name] = (status, message)
    return done.returncode, results


MUTANTS = {KERNEL: {}, BINDING: {}}
SANITIZED = set()   # mutants that can only be seen by the memory sanitizers (run in a sanitizer build)


def add(table, name, old, new):
    assert name not in MUTANTS[table], name
    MUTANTS[table][name] = (old, new)


def k(name, old, new):
    add(KERNEL, name, old, new)


def b(name, old, new):
    add(BINDING, 'binding ' + name, old, new)


def source(filename):
    return (SRC / filename).read_text()


# --- every observer statement of the kernel, dropped one at a time ---------------------------------------------------------------
def drop_effects():
    text = source(KERNEL)
    lines = text.split('\n')
    for number, line in enumerate(lines):
        stripped = line.strip()
        if not re.match(r'^observe\(host, PWD_FX_\w+, .*\);$', stripped):
            continue
        anchor = line
        back = 1
        while text.count(anchor) != 1 and back < 6:
            anchor = lines[number - back] + '\n' + anchor
            back += 1
        add(KERNEL, f'effect dropped (line {number + 1}) {stripped[:60]}', anchor,
            anchor.replace(line, line.replace(stripped, '(void)0;')))


drop_effects()

# --- targeted kernel mutants (constants, offsets, argument order) -----------------------------------------------------------------
k('cursor character', "#define CURSOR '-'", "#define CURSOR '+'")
k('text field size', 'if (len + 2 < PWD_TEXT_BYTES) {', 'if (len + 1 < PWD_TEXT_BYTES) {')
k('text field size (one more)', 'if (len + 2 < PWD_TEXT_BYTES) {', 'if (len + 3 < PWD_TEXT_BYTES) {')
k('width margin low', 'rd32u(body, rect + 8) - rd32u(body, rect)) - 0x14', 'rd32u(body, rect + 8) - rd32u(body, rect)) - 0x13')
k('width margin high', 'rd32u(body, rect + 8) - rd32u(body, rect)) - 0x14', 'rd32u(body, rect + 8) - rd32u(body, rect)) - 0x15')
k('field 2 rectangle', 'second ? 0x14u : 0x04u', 'second ? 0x04u : 0x14u')
k('field 2 words', 'second ? B_WORDS_B : B_WORDS_A', 'second ? B_WORDS_A : B_WORDS_B')
k('field 2 count', 'second ? pwd_rd16(body, B_COUNT_B) : pwd_rd16(body, B_COUNT_A)', 'second ? pwd_rd16(body, B_COUNT_A) : pwd_rd16(body, B_COUNT_B)')
k('field 2 buffer', 'second ? PWD_S_FIELD2 : PWD_S_FIELD1', 'second ? PWD_S_FIELD1 : PWD_S_FIELD2')
k('field 1 hit sets correct', 'if (!second && pwd_rd16(body, B_COUNT_B) != 0) {\n                wr32(state->b, PWD_S_STATE, PWD_STATE_FIELD2);', 'if (!second && pwd_rd16(body, B_COUNT_B) != 0) {\n                state->b[PWD_S_CORRECT] = 1;\n                wr32(state->b, PWD_S_STATE, PWD_STATE_FIELD2);')
k('field 1 hit goes to the sound', 'wr32(state->b, PWD_S_STATE, PWD_STATE_FIELD2); /*', 'wr32(state->b, PWD_S_STATE, PWD_STATE_SUCCESS_SOUND); /*')
k('final hit goes to field 2', 'state->b[PWD_S_CORRECT] = 1;\n                wr32(state->b, PWD_S_STATE, PWD_STATE_SUCCESS_SOUND);', 'state->b[PWD_S_CORRECT] = 1;\n                wr32(state->b, PWD_S_STATE, PWD_STATE_FIELD2);')
k('final hit does not set correct', '                state->b[PWD_S_CORRECT] = 1;\n                wr32(state->b, PWD_S_STATE, PWD_STATE_SUCCESS_SOUND);', '                wr32(state->b, PWD_S_STATE, PWD_STATE_SUCCESS_SOUND);')
k('field 2 hit takes the field 1 branch', 'if (!second && pwd_rd16(body, B_COUNT_B) != 0) {\n                wr32', 'if (pwd_rd16(body, B_COUNT_B) != 0) {\n                wr32')
k('upper case shift', '*s = (char)(*s - 0x20);', '*s = (char)(*s - 0x21);')
k('upper case lower bound', "if (*s > '`' && *s < '{')", "if (*s > '@' && *s < '{')")
k('upper case upper bound', "if (*s > '`' && *s < '{')", "if (*s > '`' && *s < '|')")
k('typed text size', 'memcpy(typed, field, PWD_TEXT_BYTES);', 'memcpy(typed, field, PWD_TEXT_BYTES - 1);')
k('word copy size', 'memcpy(word, body + words_off + (size_t)i * WORD_STRIDE, PWD_TEXT_BYTES);', 'memcpy(word, body + words_off + (size_t)i * WORD_STRIDE, PWD_TEXT_BYTES - 1);')
k('word stride', 'body + words_off + (size_t)i * WORD_STRIDE', 'body + words_off + (size_t)i * 0x20u')
k('words not upper-cased', '        upper(word);\n', '')
k('typed text not upper-cased', '    upper(typed);\n', '')
k('no sound compare length', 'memcmp(body + name, NO_SOUND, sizeof NO_SOUND)', 'memcmp(body + name, NO_SOUND, sizeof NO_SOUND - 1)')
k('sound start state', 'wr32(state->b, PWD_S_STATE, next);\n    return PWD_OK;', 'return PWD_OK;')
k('sound channel read', 'host->sound_play(host->context, pwd_rd16(body, channel))', 'host->sound_play(host->context, pwd_rd16(body, channel + 2))')
k('sound busy channel', 'host->sound_busy(host->context, pwd_rd16(body, channel), &busy)', 'host->sound_busy(host->context, pwd_rd16(body, channel + 2), &busy)')
k('wrong sound channel', 'sound_start(state, body, B_WRONG_SOUND, B_WRONG_CHANNEL, PWD_STATE_WRONG_WAIT', 'sound_start(state, body, B_WRONG_SOUND, B_SUCCESS_CHANNEL, PWD_STATE_WRONG_WAIT')
k('success sound channel', 'sound_start(state, body, B_SUCCESS_SOUND, B_SUCCESS_CHANNEL, PWD_STATE_SUCCESS_WAIT', 'sound_start(state, body, B_SUCCESS_SOUND, B_WRONG_CHANNEL, PWD_STATE_SUCCESS_WAIT')
k('wrong wait sound', 'sound_wait(body, B_WRONG_SOUND, B_WRONG_CHANNEL, &next, host)', 'sound_wait(body, B_SUCCESS_SOUND, B_WRONG_CHANNEL, &next, host)')
k('success wait sound', 'sound_wait(body, B_SUCCESS_SOUND, B_SUCCESS_CHANNEL, &next, host)', 'sound_wait(body, B_WRONG_SOUND, B_SUCCESS_CHANNEL, &next, host)')
k('blink period unsigned', '(uint32_t)(int32_t)pwd_rd16(body, B_BLINK));\n    wr32(state->b, PWD_S_STATE, 0);', '(uint32_t)(uint16_t)pwd_rd16(body, B_BLINK));\n    wr32(state->b, PWD_S_STATE, 0);')
k('blink period unsigned (toggle)', 'wr32(state->b, PWD_S_DEADLINE, now + (uint32_t)(int32_t)pwd_rd16(body, B_BLINK));', 'wr32(state->b, PWD_S_DEADLINE, now + (uint32_t)(uint16_t)pwd_rd16(body, B_BLINK));')
k('blink period field', 'wr32(state->b, PWD_S_DEADLINE, now + (uint32_t)(int32_t)pwd_rd16(body, B_BLINK));', 'wr32(state->b, PWD_S_DEADLINE, now + (uint32_t)(int32_t)pwd_rd16(body, B_FONT));')
k('blink deadline signed compare', 'if (rd32u(state->b, PWD_S_DEADLINE) <= now) {', 'if ((int32_t)rd32u(state->b, PWD_S_DEADLINE) <= (int32_t)now) {')
k('blink phase flip', 'wr32(state->b, PWD_S_BLINK, phase == 0 ? 1u : 0u);', 'wr32(state->b, PWD_S_BLINK, 1u);')
k('blink phase flip (back)', 'wr32(state->b, PWD_S_BLINK, phase == 0 ? 1u : 0u);', 'wr32(state->b, PWD_S_BLINK, 0u);')
k('blink shown only for an empty field', 'if (len == 0) {\n            field[0] = CURSOR;\n        } else if (field[len - 1] != CURSOR) {', 'if (len == 0) {\n            field[0] = CURSOR;\n        } else if (1) {')
k('rectangle source of field 1', "(size_t)(4 + 4 * (j - 4))", "(size_t)(0x14 + 4 * (j - 4))")
k('rectangle source of the background', "(size_t)(0x24 + 4 * j)", "(size_t)(0x04 + 4 * j)")
k('rectangle shift axes', 'const uint32_t origin = (uint32_t)((j & 1) ? vy : vx);', 'const uint32_t origin = (uint32_t)((j & 1) ? vx : vy);')
k('rectangle count', 'for (j = 0; j < 12; ++j) {', 'for (j = 0; j < 11; ++j) {')
k('field 1 cleared', 'memset(state->b + PWD_S_FIELD1, 0, PWD_TEXT_BYTES);\n', '')
k('field 2 cleared', 'memset(state->b + PWD_S_FIELD2, 0, PWD_TEXT_BYTES);\n', '')
k('cancel flag cleared', '    state->b[PWD_S_CANCEL] = 0;\n    state->b[PWD_S_KEY_PENDING] = 0;', '    state->b[PWD_S_KEY_PENDING] = 0;')
k('wrong flag cleared', '    state->b[PWD_S_WRONG] = 0;\n    state->b[PWD_S_CANCEL] = 0;', '    state->b[PWD_S_CANCEL] = 0;')
k('correct flag cleared', '    state->b[PWD_S_CORRECT] = 0;\n    observe(host, PWD_FX_START_FLAG, 1, 0);', '    observe(host, PWD_FX_START_FLAG, 1, 0);')
k('key flag cleared', '    state->b[PWD_S_KEY_PENDING] = 0;\n    if (host->font_acquire', '    if (host->font_acquire')
k('row stored low', 'state->b[PWD_S_ROW] = (uint8_t)row;', 'state->b[PWD_S_ROW] = 0;')
k('row stored high', 'state->b[PWD_S_ROW + 1] = (uint8_t)((uint16_t)row >> 8);', 'state->b[PWD_S_ROW + 1] = 0;')
k('state not reset', '    wr32(state->b, PWD_S_STATE, 0);\n    wr32(state->b, PWD_S_BLINK, 0);', '    wr32(state->b, PWD_S_BLINK, 0);')
k('blink not reset', '    wr32(state->b, PWD_S_BLINK, 0);\n    return PWD_OK;\n}\n\n/* The typed key', '    return PWD_OK;\n}\n\n/* The typed key')
k('block order wrong/correct', 'state->b[PWD_S_WRONG] != 0 ? (size_t)B_WRONG : (size_t)B_CORRECT', 'state->b[PWD_S_WRONG] != 0 ? (size_t)B_CORRECT : (size_t)B_WRONG')
k('flag check block', 'pwd_rd16(body, block + 0x16)', 'pwd_rd16(body, block + 0x14)')
k('transition word 1', 't.word[0] = pwd_rd16(body, base + 2);', 't.word[0] = pwd_rd16(body, base + 4);')
k('transition word 2', 't.word[1] = pwd_rd16(body, base + 4);', 't.word[1] = pwd_rd16(body, base + 2);')
k('transition word 3', 't.word[2] = pwd_rd16(body, base + 6);', 't.word[2] = pwd_rd16(body, base + 4);')
k('transition dword 1', 't.dword[0] = pwd_rd32(body, base + 8);', 't.dword[0] = pwd_rd32(body, base + 12);')
k('transition dword 2', 't.dword[1] = pwd_rd32(body, base + 12);', 't.dword[1] = pwd_rd32(body, base + 8);')
k('transition dword 3', 't.dword[2] = pwd_rd32(body, base + 16);', 't.dword[2] = pwd_rd32(body, base + 12);')
k('event flag value', 'const uint32_t value = body[base + 24];', 'const uint32_t value = body[base + 23];')
k('event flag value signed', 'const uint32_t value = body[base + 24];', 'const uint32_t value = (uint32_t)(int32_t)(int8_t)body[base + 24];')
k('event flag index', 'const int16_t index = pwd_rd16(body, base + 22);', 'const int16_t index = pwd_rd16(body, base + 20);')
k('start flag value', 'observe(host, PWD_FX_START_FLAG, pwd_rd16(body, base + 20) != 1, 0);', 'observe(host, PWD_FX_START_FLAG, pwd_rd16(body, base + 20) == 1, 0);')
k('scene block cancel', 'rc = finish_block(body, B_CANCEL, host);', 'rc = finish_block(body, B_WRONG, host);')
k('scene block wrong', 'rc = finish_block(body, B_WRONG, host);\n            }', 'rc = finish_block(body, B_CORRECT, host);\n            }')
k('active kept after phase 2', '        state->b[PWD_S_ACTIVE] = 0;\n        if (host->font_release', '        if (host->font_release')
k('completed flag', '        result->completed = 1;\n', '')
k('initialized flag', '        result->initialized = 1;\n', '')
k('phase after', '    result->phase_after = next;\n', '')
k('pointer rect order', 'y >= pwd_rd32(body, B_CANCEL_RECT + 4) && y <= pwd_rd32(body, B_CANCEL_RECT + 12)', 'y >= pwd_rd32(body, B_CANCEL_RECT + 4) && y <= pwd_rd32(body, B_CANCEL_RECT + 8)')
k('pointer x edges', 'x >= pwd_rd32(body, B_CANCEL_RECT) && x <= pwd_rd32(body, B_CANCEL_RECT + 8)', 'x >= pwd_rd32(body, B_CANCEL_RECT + 4) && x <= pwd_rd32(body, B_CANCEL_RECT + 8)')
k('pointer result', '        out->candidate = PWD_CANDIDATE_CANCEL;\n', '')
k('pointer cursor', '        out->cursor_kind = PWD_CURSOR_KIND_CANCEL;\n', '')
k('click row', 'out->row = state_row(state);', 'out->row = 0;')
k('click phase', 'out->phase = 2;', 'out->phase = 1;')
k('click sets cancel', '        state->b[PWD_S_CANCEL] = 1;\n        out->fired', '        out->fired')
k('render source rectangle', 'op->src[i] = pwd_rd32(body, B_RECT_BG + (size_t)4 * i);', 'op->src[i] = pwd_rd32(state->b, PWD_S_RECT_BG + (size_t)4 * i);')
k('render destination rectangle', 'op->dst[i] = pwd_rd32(state->b, PWD_S_RECT_BG + (size_t)4 * i);', 'op->dst[i] = pwd_rd32(body, B_RECT_BG + (size_t)4 * i);')
k('render x', 'op->x = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F1);\n', 'op->x = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F1 + 8);\n')
k('render y', 'op->y = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F1 + 12);', 'op->y = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F1 + 4);')
k('render field 2 x', 'op->x = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F2);', 'op->x = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F1);')
k('render field 2 y', 'op->y = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F2 + 12);', 'op->y = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F2 + 4);')
k('render field 2 text', 'memcpy(op->text, state->b + PWD_S_FIELD2, PWD_TEXT_BYTES);', 'memcpy(op->text, state->b + PWD_S_FIELD1, PWD_TEXT_BYTES);')
k('render field 2 condition', 'if (state->b[PWD_S_FIELD2] != 0) {', 'if (state->b[PWD_S_FIELD2] != 0 || 1) {')
k('render count', '        out->count = 3;\n', '')
k('filter letters', "if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')) return 1;", "if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'y') || (c >= '0' && c <= '9')) return 1;")
k('filter digits', "(c >= '0' && c <= '9')) return 1;", "(c >= '0' && c <= '8')) return 1;")
k('validate font', 'pwd_rd16(body, B_FONT) > PWD_MAX_FONT', 'pwd_rd16(body, B_FONT) > PWD_MAX_FONT + 1')
k('validate sound 1', '!has_nul(body, B_SUCCESS_SOUND, WORD_STRIDE) || !has_nul(body, B_WRONG_SOUND, WORD_STRIDE)', '!has_nul(body, B_SUCCESS_SOUND, WORD_STRIDE) && !has_nul(body, B_WRONG_SOUND, WORD_STRIDE)')
k('validate words A', 'if (!has_nul(body, B_WORDS_A + (size_t)i * WORD_STRIDE, WORD_STRIDE)) why = "unterminated accepted word of field 1";', 'if (!has_nul(body, B_WORDS_A + (size_t)i * WORD_STRIDE, WORD_STRIDE - 1)) why = "unterminated accepted word of field 1";')
k('validate words B offset', 'if (!has_nul(body, B_WORDS_B + (size_t)i * WORD_STRIDE, WORD_STRIDE)) why', 'if (!has_nul(body, B_WORDS_A + (size_t)i * WORD_STRIDE, WORD_STRIDE)) why')

# --- targeted binding mutants ----------------------------------------------------------------------------------------------------
b('start flag from effect', 'if (effect == PWD_FX_START_FLAG) binding->start_flag = a;', '(void)0;')
b('entry flag from effect', 'if (effect == PWD_FX_ENTRY_VISIBLE) binding->entry_flag = a;', '(void)0;')
b('entry flag from the wrong effect', 'if (effect == PWD_FX_ENTRY_VISIBLE) binding->entry_flag = a;', 'if (effect == PWD_FX_START_FLAG) binding->entry_flag = a;')
b('observer not forwarded', 'if (binding->host.kernel.observe != NULL) binding->host.kernel.observe(binding->host.kernel.context, effect, a, b);', '(void)0;')
b('observer arguments', 'binding->host.kernel.observe(binding->host.kernel.context, effect, a, b);', 'binding->host.kernel.observe(binding->host.kernel.context, effect, b, a);')
b('observer context', 'binding->host.kernel.observe(binding->host.kernel.context, effect, a, b);', 'binding->host.kernel.observe(binding, effect, a, b);')
b('trampoline width arguments', 'text_width(TRAMPOLINE_OWNER(c)->context, font, text, width)', 'text_width(TRAMPOLINE_OWNER(c)->context, 0, text, width)')
b('trampoline busy channel', 'sound_busy(TRAMPOLINE_OWNER(c)->context, channel, result)', 'sound_busy(TRAMPOLINE_OWNER(c)->context, 0, result)')
b('trampoline event flag index', 'store_event_flag(TRAMPOLINE_OWNER(c)->context, index, value)', 'store_event_flag(TRAMPOLINE_OWNER(c)->context, index, 0)')
b('kernel context', 'binding->kernel.context = binding;', 'binding->kernel.context = &binding->host;')
b('observer installed only on demand', 'binding->kernel.observe = t_observe;', 'binding->kernel.observe = host->kernel.observe == NULL ? NULL : t_observe;')
b('cleanup keeps the entry flag', '    pwd_cleanup(&binding->state);\n    binding->entry_flag = 0;', '    pwd_cleanup(&binding->state);')
b('cleanup keeps the state', '    pwd_cleanup(&binding->state);\n    binding->entry_flag = 0;', '    binding->entry_flag = 0;')
b('scene clear skipped', 'is not touched. */\n    session_a76_cleanup(binding);', 'is not touched. */')
b('scene clear before validation', '    if (binding == NULL || scene == NULL) return PWD_ERR_ARGUMENT;\n    count =', '    if (binding == NULL || scene == NULL) return PWD_ERR_ARGUMENT;\n    session_a76_cleanup(binding);\n    count =')
b('row type check', 'if (info.type != SESSION_A76_TYPE) continue;', 'if (info.type != SESSION_A76_TYPE + 1) continue;')
b('validation skipped', 'if (pwd_validate_body(info.typed_body, info.typed_body_length, &why) != PWD_OK) {', 'if (0) {')
b('row not marked present', '        rows[i].present = 1u;\n', '')
b('body not copied', 'memcpy(rows[i].body, info.typed_body, PWD_BODY_BYTES);', '(void)0;')
b('row count not stored', '    binding->count = count;\n', '')
b('old rows kept', '    free(binding->rows);\n    binding->rows = rows;', '    binding->rows = rows;')
b('handler type check', 'action->type != SESSION_A76_TYPE ||', 'action->type != SESSION_A76_TYPE + 1 ||')
b('handler row index', 'status = pwd_step(&binding->state, binding->rows[index].body, PWD_BODY_BYTES, (int16_t)index,', 'status = pwd_step(&binding->state, binding->rows[index].body, PWD_BODY_BYTES, 0,')
b('handler phase', '(int16_t)index, before->phase,', '(int16_t)index, 0,')
b('unsupported mapping', 'if (status == PWD_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;', '(void)0;')
b('error mapping', 'if (status != PWD_OK) return SCENE_ACTION_HANDLER_ERROR;', '(void)0;')
b('store hook without visit check', '(result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL', 'binding->host.store_world != NULL')
b('store hook only initialised', '(result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL', 'result.initialized != 0u && binding->host.store_world != NULL')
b('store hook only completed', '(result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL', 'result.completed != 0u && binding->host.store_world != NULL')
b('store hook value', 'binding->host.store_world(binding->host.kernel.context, binding->start_flag);', 'binding->host.store_world(binding->host.kernel.context, 0);')
b('store hook context', 'binding->host.store_world(binding->host.kernel.context, binding->start_flag);', 'binding->host.store_world(binding, binding->start_flag);')
b('completion disposition', 'result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_PENDING')
b('phase reported', '    out->phase = result.phase_after;\n', '')
b('failure text kept', 'binding->failure = why != NULL ? why : "none";\n    if (status == PWD_ERR_UNSUPPORTED)', 'if (status == PWD_ERR_UNSUPPORTED)')
b('pointer when inactive', '    if (binding->state.b[PWD_S_ACTIVE] == 0) return PWD_OK; /* 0x4f04b6', '    /* 0x4f04b6')
b('pointer defaults', '    out->candidate = -1;\n    out->cursor_kind = -1;\n    if (binding->state', '    if (binding->state')
b('invalidate', '    binding->entry_flag = 1;\n    return 1;', '    return 1;')
b('render when no entry', '    if (binding->entry_flag == 0) return PWD_OK; /* no render entry', '    /* no render entry')
b('render failure text', 'binding->failure = status == PWD_OK ? "none" : "0x76-render";', 'binding->failure = "none";')
b('registered', 'return binding != NULL && binding->entry_flag != 0 ? 1u : 0u;', 'return binding != NULL && binding->state.b[PWD_S_ACTIVE] != 0 ? 1u : 0u;')
b('new game clears the entry flag', 'if (binding != NULL) pwd_new_game(&binding->state);', 'if (binding != NULL) { pwd_new_game(&binding->state); binding->entry_flag = 0; }')

# --- generated operator flips ------------------------------------------------------------------------------------------------------
# Every relational / logical / additive operator of the kernel and the binding is flipped once per occurrence; the anchor is the
# whole source line, so lines that are not unique are skipped.
_FLIPS = {'<': '<=', '<=': '<', '>': '>=', '>=': '>', '==': '!=', '!=': '==', '&&': '||', '||': '&&', '+': '-', '-': '+'}
_OPERATOR = re.compile(r' (<=|>=|==|!=|&&|\|\||<|>|\+|-) ')


def auto_flips(filename):
    text = source(filename)
    for line in text.split('\n'):
        stripped = line.strip()
        if not stripped or stripped.startswith(('/*', '*', '//', '#', 'case ')) or text.count(line + '\n') != 1:
            continue
        for index, match in enumerate(_OPERATOR.finditer(line)):
            op = match.group(1)
            mutated = line[:match.start(1)] + _FLIPS[op] + line[match.end(1):]
            label = 'auto' if filename == KERNEL else 'binding auto'
            add(filename, f'{label} {stripped} #{index} {op}', line + '\n', mutated + '\n')


auto_flips(KERNEL)
auto_flips(BINDING)

# Mutants that cannot change observable behaviour; each entry needs a written reason.
EQUIVALENT = {
    'upper case upper bound':
        "The mutant also lowers '{' (0x7b) to '[' (0x5b). The typed text holds only characters the key filter accepts plus the "
        "cursor, and neither '{' nor '[' is among them, so a word containing either never matches before or after the change.",
    "auto if (*s > '`' && *s < '{') *s = (char)(*s - 0x20); #0 >":
        "The mutant also lowers '`' (0x60) to '@' (0x40). The typed text never holds '`' or '@' (the key filter refuses both), so a "
        "word containing either never matches before or after the change.",
    "auto if (*s > '`' && *s < '{') *s = (char)(*s - 0x20); #2 <":
        "The mutant also lowers '{' (0x7b) to '[' (0x5b); neither can be typed (see 'upper case upper bound').",
    'typed text size':
        "The field holds at most 31 characters plus the cursor and a NUL (the 33-byte buffer), so byte 0x20 of the copy is never "
        "read: the string ends at the NUL before it.",
    'word copy size':
        "An accepted word whose 33rd byte matters has 32 characters, and the typed text holds at most 31, so a 32-character word "
        "can never be a substring of it, with or without the NUL the full copy keeps.",
    'binding kernel context':
        "SessionA76Host is the first member of SessionA76Binding, so &binding->host and binding are the same address and the "
        "trampolines see the same pointer.",
    'binding invalidate':
        "The entry flag is already 1 whenever the puzzle is active: phase 0 sets both through the observer and every path that "
        "clears one (phase 2, scene clear) clears the other, so the store never changes it.",
    'binding render failure text':
        "pwd_render fails only for a wrong body length or a NULL argument, which the binding never passes; the failure text of that "
        "branch is unreachable.",
    'binding auto binding->failure = status == PWD_OK ? "none" : "0x76-render"; #0 ==':
        "The same unreachable pwd_render failure branch as 'binding render failure text'.",
    'binding auto if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL; #1 ||':
        "Defensive range check of the state's row: while the puzzle is active or its entry flag is set the row is a present row of "
        "the current scene (phase 0 stores it for a present row, the scene clear resets both), so the sub-conditions never differ.",
    'binding auto if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL; #2 >=':
        'Same defensive range check: the row is never equal to the row count while the puzzle is active.',
    'binding auto if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL; #3 ||':
        'Same defensive range check: the row of an active puzzle is always present.',
}

# Mutants the unit cases do not kill yet. test_known_gaps_are_exactly_the_survivors keeps this list honest in both directions.
KNOWN_GAPS = ()

# Generated mutants that only the sanitizer build can see (an out-of-bounds access that plain hardware turns into a harmless value).
SANITIZED.update(())


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


def sanitizer_compiler(tmp):
    """The first compiler that builds the unit cases with ASan + UBSan, or None (clang here may have no sanitizer runtime)."""
    for cc in (compiler(), shutil.which('gcc')):
        if cc is not None and compile_c(Path(tmp) / 'probe_san', TEST_C, SOURCES, extra=SANITIZE, cc=cc).returncode == 0:
            return cc
    return None


def support_objects(tmp, cc, extra):
    """The unmutated support sources, compiled once."""
    objects = []
    for name in SUPPORT:
        obj = Path(tmp) / (Path(name).stem + '.o')
        cmd = [cc, *WARN, '-O0', '-g', f'-I{SRC}', *extra, '-c', str(SRC / name), '-o', str(obj)]
        done = subprocess.run(cmd, capture_output=True, text=True)
        assert done.returncode == 0, done.stderr
        objects.append(obj)
    return objects


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a76_test'
        built = compile_c(cls.binary, TEST_C, SOURCES)
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
        san_cc = sanitizer_compiler(self.tmp.name)
        if san_cc is None:
            self.skipTest('no compiler with an ASan/UBSan runtime in this environment')
        out = Path(self.tmp.name) / 'a76_test_san'
        built = compile_c(out, TEST_C, SOURCES, extra=SANITIZE, cc=san_cc)
        self.assertEqual(built.returncode, 0, built.stderr)
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1')
        code, results = run_unit(out, env)
        self.assertEqual(code, 0, str(results)[-400:])
        self.assertGreaterEqual(len(results), EXPECTED_UNIT_TESTS)

    def test_mutation_anchors_are_unique(self):
        for filename, mutations in MUTANTS.items():
            text = (SRC / filename).read_text()
            for name, (old, new) in mutations.items():
                with self.subTest(name):
                    self.assertEqual(text.count(old), 1, f'anchor drifted: {old[:70]!r}')
                    self.assertNotEqual(old, new)

    def test_known_gaps_are_exactly_the_survivors(self):
        names = {name for table in MUTANTS.values() for name in table}
        for name in tuple(EQUIVALENT) + KNOWN_GAPS + tuple(SANITIZED):
            self.assertIn(name, names, f'stale entry: {name}')
        for name, reason in EQUIVALENT.items():
            self.assertTrue(reason.strip(), f'equivalent mutant without a reason: {name}')

    def test_mutations_are_detected(self):
        """Every mutant that is neither recorded equivalent nor a named open gap must be killed by the unit cases."""
        jobs = []
        for filename, mutations in MUTANTS.items():
            for name, (old, new) in mutations.items():
                if name not in EQUIVALENT and name not in KNOWN_GAPS:
                    jobs.append((filename, name, old, new))
        san_cc = sanitizer_compiler(self.tmp.name)
        if san_cc is None:
            jobs = [job for job in jobs if job[1] not in SANITIZED]
        cc = san_cc or compiler()
        extra = SANITIZE if san_cc else ()
        objects = support_objects(self.tmp.name, cc, extra)
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1')

        def build_and_run(index_job):
            index, (filename, name, old, new) = index_job
            work = mutated_copy(self.tmp.name, f'mut{index}', filename, old, new)
            binary = work / 'mut_test'
            built = compile_c(binary, TEST_C, [KERNEL, BINDING], src_dir=work, optimize='-O0', extra=extra, cc=cc, objects=objects,
                              werror=False)  # a mutant may legitimately warn (always-true tests, unused values)
            if built.returncode != 0:
                return name, 'build', built.stderr[-300:]
            try:
                done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=120, env=env)
                verdict = 'killed' if done.returncode != 0 else 'survived'
            except subprocess.TimeoutExpired:
                verdict = 'killed'
            shutil.rmtree(work, ignore_errors=True)
            return name, verdict, ''

        with concurrent.futures.ThreadPoolExecutor(max_workers=min(8, os.cpu_count() or 2)) as pool:
            outcomes = list(pool.map(build_and_run, enumerate(jobs)))
        self.assertEqual(len({name for _, name, _, _ in jobs}), len(jobs), 'duplicate mutant names')
        killed = sum(1 for _, verdict, _ in outcomes if verdict == 'killed')
        for name, verdict, detail in outcomes:
            with self.subTest(name):
                self.assertEqual(verdict, 'killed', f'mutant {verdict}: {name} {detail}')
        print(f'mutants killed: {killed} of {len(jobs)} ({len(EQUIVALENT)} equivalent, {len(KNOWN_GAPS)} open gaps, not run)')


class Corpus(unittest.TestCase):
    def test_real_row_validates_and_plays_through_the_binding(self):
        """The real raw 0x76 row (resource 2529) passes the native body validation, runs phase 0, leaves through the wrong exit
        after a wrong word, through the correct exit after each accepted word typed in three letter cases with extra letters
        around it, handles Backspace and the blink, and leaves through the cancel exit (derived counts only; the decoded
        resource stays in work/)."""
        files = [RESOURCES / name for name in CORPUS_ROWS]
        if not all(path.exists() for path in files):
            self.skipTest('local corpus evidence (work/) is not present')
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a76_corpus'
            built = compile_c(binary, CORPUS_C, SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-600:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {key: int(v) for key, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['error']), (1, 1, 0))
        self.assertEqual(summary['validated'], 1)
        self.assertEqual(summary['words'], 3)
        self.assertEqual(summary['variants'], 3 * summary['words'])
        self.assertEqual(summary['skipped'], 0)
        self.assertEqual((summary['wrong_exit'], summary['correct_exit'], summary['cancel_exit'], summary['cancel_noop']), (1, 1, 1, 1))
        self.assertEqual((summary['blink'], summary['backspace'], summary['renders']), (1, 1, 1))
        self.assertEqual(done.stdout.count('ROW_FAIL') + done.stdout.count('SCENE_FAIL'), 0)


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_76_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())


class Registration(unittest.TestCase):
    def test_module_is_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        self.assertIn(' action_family_76_runtime session_bindings_a76', build)


if __name__ == '__main__':
    unittest.main()
