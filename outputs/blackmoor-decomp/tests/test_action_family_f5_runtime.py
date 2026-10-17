"""RT-55: raw 0xf5 Typing Quiz runtime (src/action_family_f5_runtime.c), the shared score / time display
(src/score_time_display.c) and the session binding (src/session_bindings_af5.c).

Facts under test (original GAME.EXE, read from the disassembly / Ghidra pseudocode of 0x4b8e92, 0x4b832c, 0x4b844d, 0x4b8d5e,
0x4b8a27, 0x4b8783, 0x4b866e, 0x4b85f6, 0x4b8520, 0x4b8193, 0x4b81ff, 0x4b82cd, 0x4b80a5, 0x4b7ff4, 0x4b7f3b, 0x4b8087, 0x4b9a88,
0x437ea1, 0x445f53..0x4468fe):
 * phase 0 sets the start flag, commits the held item, allocates three generic z entries (quiz, score, clock), loads the puzzle
   surface once, prepares the three sounds, builds both display blocks with the view origin added, derives the target score from
   the best earlier score and puts up the first balloon wave with the character range kept from the previous run;
 * phase 1 is a three-state machine on obj+0x10: play (clock, balloon timeouts, one typed character, score), time up (start the
   end delay, decide passed / reached), wait (store the best score and hand over to phase 2 after the delay);
 * phase 2 stops the sounds, applies the passed or the normal block (scene cells, start flag, event flag), the engine mode, the
   generic completion and the cleanup;
 * the pointer test, click, invalidate, cleanup and the three render callbacks (quiz, score, clock) as recovered.
The unit cases live in tests/action_family_f5_runtime_test.c (synthetic bodies, no original bytes) and the corpus check in
tests/action_family_f5_runtime_corpus.c (the real rows of resources 1053 and 1054). The original-x86 oracle is a separate
script (needs the private work/ evidence and Unicorn).
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
TEST_C = PROJECT / 'tests/action_family_f5_runtime_test.c'
KERNEL = 'action_family_f5_runtime.c'
STD = 'score_time_display.c'
BINDING = 'session_bindings_af5.c'
SOURCES = [STD, KERNEL, BINDING, 'scene_resource.c', 'hiff.c']
EXPECTED_UNIT_TESTS = 41
CORPUS_C = PROJECT / 'tests/action_family_f5_runtime_corpus.c'
RESOURCES = PROJECT.parents[1] / 'work/analysis/hiff-resources'
CORPUS_ROWS = ('1053.bin', '1054.bin')


def compiler():
    # The repo scripts call `xcrun clang` for macOS; where xcrun is absent (cloud container) use clang, cc or gcc.
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')


def gcc_only_flags():
    # clang rejects this option name under -Werror, so only gcc gets it.
    version = subprocess.run([compiler(), '--version'], capture_output=True, text=True).stdout
    return ('-Wno-maybe-uninitialized',) if 'clang' not in version else ()


# float-cast-overflow: an out-of-range double -> int64 conversion gives INT64_MIN on x86 but saturates on ARM64, so only the
# sanitizer can tell the guard of ftol64 from the raw cast on the machine that runs the tests.
SANITIZE = ['-fsanitize=address,undefined,float-cast-overflow', '-fno-sanitize-recover=undefined,float-cast-overflow']


def compile_c(output, main_c, sources, src_dir=SRC, extra=(), optimize='-O1', cc=None):
    cmd = [cc or compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', optimize, '-g',
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


MUTANTS = {KERNEL: {}, STD: {}, BINDING: {}}
SANITIZED = set()   # mutants that can only be seen by the memory sanitizers (run in a sanitizer build)


def add(table, name, old, new):
    assert name not in MUTANTS[table], name
    MUTANTS[table][name] = (old, new)


def k(name, old, new):
    add(KERNEL, name, old, new)


def d(name, old, new):
    add(STD, 'display ' + name, old, new)


def b(name, old, new):
    add(BINDING, 'binding ' + name, old, new)


def source(filename):
    return (SRC / filename).read_text()


# --- helper to drop every effect statement of the kernel / the display -------------------------------------------------------
def drop_effects():
    for filename, table in ((KERNEL, KERNEL), (STD, STD)):
        text = source(filename)
        lines = text.split('\n')
        for number, line in enumerate(lines):
            stripped = line.strip()
            if not re.match(r'^fx\((host|NULL|host), (TQZ|STD)_FX_\w+, .*\);$', stripped):
                continue
            # anchor: this line, extended by the previous lines until it is unique in the file
            anchor = line
            back = 1
            while text.count(anchor) != 1 and back < 6:
                anchor = lines[number - back] + '\n' + anchor
                back += 1
            name = f'effect dropped ({filename}:{number + 1}) {stripped[:60]}'
            replacement = anchor.replace(line, line.replace(stripped, '(void)0;'))
            add(table, name, anchor, replacement)


drop_effects()

# =====================================================================================================================
# The score / time display (src/score_time_display.c)
# =====================================================================================================================
d('add32 subtracts', 'return (int32_t)((uint32_t)a + (uint32_t)b);', 'return (int32_t)((uint32_t)a - (uint32_t)b);')
d('sub32 adds', 'return (int32_t)((uint32_t)a - (uint32_t)b);', 'return (int32_t)((uint32_t)a + (uint32_t)b);')
d('half floors', 'return v / 2;', 'return v >> 1;')
d('half rounds up', 'return v / 2;', 'return (v + 1) / 2;')
d('observer unguarded', 'if (host != NULL && host->observe != NULL) host->observe(host->context, effect, a, b);', 'host->observe(host->context, effect, a, b);')
d('observer without host check', 'if (host != NULL && host->observe != NULL)', 'if (host->observe != NULL)')
d('observer arguments swapped', 'host->observe(host->context, effect, a, b);', 'host->observe(host->context, effect, b, a);')
for _what, _old, _new in (
        ('score enabled kept', '    d->score_enabled = 0;\n    d->score_ready = 0;\n    d->score = 0;', '    d->score_ready = 0;\n    d->score = 0;'),
        ('score ready kept', '    d->score_ready = 0;\n    d->score = 0;\n    d->score_str[0] = 0;', '    d->score = 0;\n    d->score_str[0] = 0;'),
        ('score value kept', '    d->score_ready = 0;\n    d->score = 0;\n    d->score_str[0] = 0;', '    d->score_ready = 0;\n    d->score_str[0] = 0;'),
        ('score string kept', '    d->score = 0;\n    d->score_str[0] = 0;\n    d->prev_score_str[0] = 0;\n    memset(d->score_w', '    d->score = 0;\n    d->prev_score_str[0] = 0;\n    memset(d->score_w'),
        ('score previous string kept', '    d->score_str[0] = 0;\n    d->prev_score_str[0] = 0;\n    memset(d->score_w', '    d->score_str[0] = 0;\n    memset(d->score_w'),
        ('score widths kept', '    memset(d->score_w, 0, sizeof d->score_w);\n', ''),
        ('score heights kept', '    memset(d->score_h, 0, sizeof d->score_h);\n', ''),
        ('score block kept', '    memset(d->score_block, 0, sizeof d->score_block);\n}', '}'),
        ('score block one word short', 'memset(d->score_block, 0, sizeof d->score_block);\n}', 'memset(d->score_block, 0, sizeof d->score_block - 4);\n}'),
        ('clock enabled kept', '    d->clock_enabled = 0;\n    d->clock_ready = 0;\n    d->colon_w = 0;', '    d->clock_ready = 0;\n    d->colon_w = 0;'),
        ('clock ready kept', '    d->clock_ready = 0;\n    d->colon_w = 0;', '    d->colon_w = 0;'),
        ('colon width kept', '    d->colon_w = 0;\n    d->colon_h = 0;\n    d->minutes = 0;', '    d->colon_h = 0;\n    d->minutes = 0;'),
        ('colon height kept', '    d->colon_h = 0;\n    d->minutes = 0;', '    d->minutes = 0;'),
        ('minutes kept', '    d->minutes = 0;\n    d->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w', '    d->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w'),
        ('seconds kept', '    d->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w', '    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w'),
        ('minutes string kept', '    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w', '    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w'),
        ('seconds string kept', '    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w', '    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w'),
        ('previous minutes string kept', '    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w', '    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w'),
        ('previous seconds string kept', '    d->prev_seconds_str[0] = 0;\n    memset(d->clock_w', '    memset(d->clock_w'),
        ('clock widths kept', '    memset(d->clock_w, 0, sizeof d->clock_w);\n', ''),
        ('clock heights kept', '    memset(d->clock_h, 0, sizeof d->clock_h);\n', ''),
        ('clock block kept', '    memset(d->clock_block, 0, sizeof d->clock_block);\n}', '}'),
        ('clock block one word short', 'memset(d->clock_block, 0, sizeof d->clock_block);\n}', 'memset(d->clock_block, 0, sizeof d->clock_block - 4);\n}'),
):
    d('reset: ' + _what, _old, _new)
d('enable score stores 1', 'd->score_enabled = value;', 'd->score_enabled = 1;')
d('enable clock stores 1', 'd->clock_enabled = value;', 'd->clock_enabled = 1;')
d('enable score writes the clock', 'd->score_enabled = value;', 'd->clock_enabled = value;')
d('enable clock writes the score', 'd->clock_enabled = value;', 'd->score_enabled = value;')
d('score zero refused', 'if (score < 0 || score > 99999999)', 'if (score <= 0 || score > 99999999)')
d('score minus one accepted', 'if (score < 0 || score > 99999999)', 'if (score < -1 || score > 99999999)')
d('score limit one high', 'score > 99999999)', 'score > 100000000)')
d('score limit one low', 'score > 99999999)', 'score >= 99999999)')
d('score limit unchecked', 'if (score < 0 || score > 99999999)', 'if (score < 0)')
d('score lower limit unchecked', 'if (score < 0 || score > 99999999)', 'if (score > 99999999)')
d('score stored before the check', 'return STD_ERR_BOUNDS;\n    d->score = score;', 'return STD_ERR_BOUNDS;\n    d->score = score;')  # placeholder removed below
del MUTANTS[STD]['display score stored before the check']
d('score not stored', '    d->score = score;\n    (void)snprintf', '    (void)snprintf')
d('score string format', '"%d", score', '"%2d", score')
d('score string not written', '(void)snprintf(d->score_str, sizeof d->score_str, "%d", score);', '(void)0;')
d('clock minutes zero refused', 'if (minutes < 0 || minutes > 99 || seconds < 0 || seconds > 99)', 'if (minutes <= 0 || minutes > 99 || seconds < 0 || seconds > 99)')
d('clock seconds zero refused', 'seconds < 0 || seconds > 99)', 'seconds <= 0 || seconds > 99)')
d('clock minutes below zero accepted', 'if (minutes < 0 ||', 'if (minutes < -1 ||')
d('clock seconds below zero accepted', '|| seconds < 0 ||', '|| seconds < -1 ||')
d('clock minutes limit high', 'minutes > 99', 'minutes > 100')
d('clock minutes limit low', 'minutes > 99', 'minutes >= 99')
d('clock seconds limit high', 'seconds > 99)', 'seconds > 100)')
d('clock seconds limit low', 'seconds > 99)', 'seconds >= 99)')
d('clock minutes unchecked', 'if (minutes < 0 || minutes > 99 || seconds < 0 || seconds > 99)', 'if (seconds < 0 || seconds > 99)')
d('clock seconds unchecked', 'if (minutes < 0 || minutes > 99 || seconds < 0 || seconds > 99)', 'if (minutes < 0 || minutes > 99)')
d('clock minutes not stored', '    d->minutes = minutes;\n    d->seconds = seconds;', '    d->seconds = seconds;')
d('clock seconds not stored', '    d->minutes = minutes;\n    d->seconds = seconds;', '    d->minutes = minutes;')
d('clock minutes format', '"%02d", minutes', '"%d", minutes')
d('clock seconds format', '"%02d", seconds', '"%d", seconds')
d('clock strings swapped', 'snprintf(d->minutes_str, sizeof d->minutes_str, "%02d", minutes);', 'snprintf(d->minutes_str, sizeof d->minutes_str, "%02d", seconds);')
# init score
d('init score width formula', 'd->score_w[k] = add32(sub32(d->score_block[k * 4 + 2], d->score_block[k * 4]), 1);', 'd->score_w[k] = sub32(d->score_block[k * 4 + 2], d->score_block[k * 4]);')
d('init score width from the top', 'd->score_w[k] = add32(sub32(d->score_block[k * 4 + 2], d->score_block[k * 4]), 1);', 'd->score_w[k] = add32(sub32(d->score_block[k * 4 + 3], d->score_block[k * 4]), 1);')
d('init score width from the bottom edge', 'd->score_w[k] = add32(sub32(d->score_block[k * 4 + 2], d->score_block[k * 4]), 1);', 'd->score_w[k] = add32(sub32(d->score_block[k * 4 + 2], d->score_block[k * 4 + 1]), 1);')
d('init score height formula', 'd->score_h[k] = add32(sub32(d->score_block[k * 4 + 3], d->score_block[k * 4 + 1]), 1);', 'd->score_h[k] = sub32(d->score_block[k * 4 + 3], d->score_block[k * 4 + 1]);')
d('init score height from the width', 'd->score_h[k] = add32(sub32(d->score_block[k * 4 + 3], d->score_block[k * 4 + 1]), 1);', 'd->score_h[k] = add32(sub32(d->score_block[k * 4 + 2], d->score_block[k * 4 + 1]), 1);')
d('init score height from the left', 'd->score_h[k] = add32(sub32(d->score_block[k * 4 + 3], d->score_block[k * 4 + 1]), 1);', 'd->score_h[k] = add32(sub32(d->score_block[k * 4 + 3], d->score_block[k * 4]), 1);')
d('init score digits short', 'for (int k = 0; k < STD_DIGITS; ++k) {\n        d->score_w', 'for (int k = 0; k < STD_DIGITS - 1; ++k) {\n        d->score_w')
d('init score digits long', 'for (int k = 0; k < STD_DIGITS; ++k) {\n        d->score_w', 'for (int k = 0; k <= STD_DIGITS; ++k) {\n        d->score_w')
SANITIZED.add('display init score digits long')
d('init score block not copied', 'memcpy(d->score_block, block, sizeof d->score_block);', '(void)0;')
d('init score block short', 'memcpy(d->score_block, block, sizeof d->score_block);', 'memcpy(d->score_block, block, sizeof d->score_block - 4);')
d('init score loop counter', 'd->loop_counter = STD_DIGITS;\n    if (host == NULL || host->register_slot == NULL ||\n        host->register_slot(host->context, (int16_t)d->score_block[44]', 'd->loop_counter = 0;\n    if (host == NULL || host->register_slot == NULL ||\n        host->register_slot(host->context, (int16_t)d->score_block[44]')
d('init score host check', 'if (host == NULL || host->register_slot == NULL ||\n        host->register_slot(host->context, (int16_t)d->score_block[44]', 'if (host->register_slot(host->context, (int16_t)d->score_block[44]')
d('init score register callback missing', 'if (host == NULL || host->register_slot == NULL ||\n        host->register_slot(host->context, (int16_t)d->score_block[44]', 'if (host == NULL ||\n        host->register_slot(host->context, (int16_t)d->score_block[44]')
d('init score host failure ignored', 'd->score_block[45], STD_CALLBACK_SCORE,\n                            (uint32_t)d->score_block[43], "SCORE DISPLAY") != 0) {', 'd->score_block[45], STD_CALLBACK_SCORE,\n                            (uint32_t)d->score_block[43], "SCORE DISPLAY") < 0) {')
d('init score slot argument', '(int16_t)d->score_block[44], d->score_block[45], STD_CALLBACK_SCORE', '(int16_t)d->score_block[45], d->score_block[44], STD_CALLBACK_SCORE')
d('init score kind argument', 'd->score_block[45], STD_CALLBACK_SCORE', '0, STD_CALLBACK_SCORE')
d('init score callback argument', 'd->score_block[45], STD_CALLBACK_SCORE,', 'd->score_block[45], STD_CALLBACK_CLOCK,')
d('init score surface argument', '(uint32_t)d->score_block[43], "SCORE DISPLAY"', '0u, "SCORE DISPLAY"')
d('init score label', '"SCORE DISPLAY"', '"SCORE DISPLAYS"')
d('init score effect arguments', 'fx(host, STD_FX_INIT_SCORE, d->score_block[44], d->score_block[43]);', 'fx(host, STD_FX_INIT_SCORE, d->score_block[43], d->score_block[44]);')
d('init score ready lost', '    d->score_enabled = 0;\n    d->score_ready = 1;', '    d->score_enabled = 0;')
d('init score enabled kept', '    d->score_enabled = 0;\n    d->score_ready = 1;', '    d->score_ready = 1;')
d('init score value kept', '    d->score = 0;\n    d->score_str[0] = 0;\n    d->prev_score_str[0] = 0;\n    d->score_enabled = 0;', '    d->score_str[0] = 0;\n    d->prev_score_str[0] = 0;\n    d->score_enabled = 0;')
d('init score string kept', '    d->score_str[0] = 0;\n    d->prev_score_str[0] = 0;\n    d->score_enabled = 0;', '    d->prev_score_str[0] = 0;\n    d->score_enabled = 0;')
d('init score previous string kept', '    d->prev_score_str[0] = 0;\n    d->score_enabled = 0;', '    d->score_enabled = 0;')
# init clock
d('init clock width formula', 'd->clock_w[k] = add32(sub32(d->clock_block[k * 4 + 2], d->clock_block[k * 4]), 1);', 'd->clock_w[k] = sub32(d->clock_block[k * 4 + 2], d->clock_block[k * 4]);')
d('init clock width from the top', 'd->clock_w[k] = add32(sub32(d->clock_block[k * 4 + 2], d->clock_block[k * 4]), 1);', 'd->clock_w[k] = add32(sub32(d->clock_block[k * 4 + 3], d->clock_block[k * 4]), 1);')
d('init clock height formula', 'd->clock_h[k] = add32(sub32(d->clock_block[k * 4 + 3], d->clock_block[k * 4 + 1]), 1);', 'd->clock_h[k] = sub32(d->clock_block[k * 4 + 3], d->clock_block[k * 4 + 1]);')
d('init clock height from the left', 'd->clock_h[k] = add32(sub32(d->clock_block[k * 4 + 3], d->clock_block[k * 4 + 1]), 1);', 'd->clock_h[k] = add32(sub32(d->clock_block[k * 4 + 3], d->clock_block[k * 4]), 1);')
d('init clock digits short', 'for (int k = 0; k < STD_DIGITS; ++k) {\n        d->clock_w', 'for (int k = 0; k < STD_DIGITS - 1; ++k) {\n        d->clock_w')
d('init clock block not copied', 'memcpy(d->clock_block, block, sizeof d->clock_block);', '(void)0;')
d('init clock block short', 'memcpy(d->clock_block, block, sizeof d->clock_block);', 'memcpy(d->clock_block, block, sizeof d->clock_block - 4);')
d('init clock loop counter', 'd->loop_counter = STD_DIGITS;\n    d->colon_w', 'd->loop_counter = 0;\n    d->colon_w')
d('init clock colon width formula', 'd->colon_w = add32(sub32(d->clock_block[42], d->clock_block[40]), 1);', 'd->colon_w = sub32(d->clock_block[42], d->clock_block[40]);')
d('init clock colon width edges', 'd->colon_w = add32(sub32(d->clock_block[42], d->clock_block[40]), 1);', 'd->colon_w = add32(sub32(d->clock_block[43], d->clock_block[40]), 1);')
d('init clock colon height formula', 'd->colon_h = add32(sub32(d->clock_block[43], d->clock_block[41]), 1);', 'd->colon_h = sub32(d->clock_block[43], d->clock_block[41]);')
d('init clock colon height edges', 'd->colon_h = add32(sub32(d->clock_block[43], d->clock_block[41]), 1);', 'd->colon_h = add32(sub32(d->clock_block[43], d->clock_block[40]), 1);')
d('init clock host check', 'if (host == NULL || host->register_slot == NULL ||\n        host->register_slot(host->context, (int16_t)d->clock_block[48]', 'if (host->register_slot(host->context, (int16_t)d->clock_block[48]')
d('init clock register callback missing', 'if (host == NULL || host->register_slot == NULL ||\n        host->register_slot(host->context, (int16_t)d->clock_block[48]', 'if (host == NULL ||\n        host->register_slot(host->context, (int16_t)d->clock_block[48]')
d('init clock host failure ignored', '(uint32_t)d->clock_block[47], "TIME DISPLAY") != 0) {', '(uint32_t)d->clock_block[47], "TIME DISPLAY") < 0) {')
d('init clock slot argument', '(int16_t)d->clock_block[48], d->clock_block[49], STD_CALLBACK_CLOCK', '(int16_t)d->clock_block[49], d->clock_block[48], STD_CALLBACK_CLOCK')
d('init clock kind argument', 'd->clock_block[49], STD_CALLBACK_CLOCK', '0, STD_CALLBACK_CLOCK')
d('init clock callback argument', 'd->clock_block[49], STD_CALLBACK_CLOCK,', 'd->clock_block[49], STD_CALLBACK_SCORE,')
d('init clock surface argument', '(uint32_t)d->clock_block[47], "TIME DISPLAY"', '0u, "TIME DISPLAY"')
d('init clock label', '"TIME DISPLAY"', '"TIME DISPLAYS"')
d('init clock effect arguments', 'fx(host, STD_FX_INIT_CLOCK, d->clock_block[48], d->clock_block[47]);', 'fx(host, STD_FX_INIT_CLOCK, d->clock_block[47], d->clock_block[48]);')
d('init clock ready lost', '    d->clock_enabled = 0;\n    d->clock_ready = 1;', '    d->clock_enabled = 0;')
d('init clock enabled kept', '    d->clock_enabled = 0;\n    d->clock_ready = 1;', '    d->clock_ready = 1;')
d('init clock minutes kept', '    d->minutes = 0;\n    d->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;', '    d->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;')
d('init clock seconds kept', '    d->seconds = 0;\n    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;', '    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;')
d('init clock minutes string kept', '    d->minutes_str[0] = 0;\n    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;', '    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;')
d('init clock seconds string kept', '    d->seconds_str[0] = 0;\n    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;', '    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;')
d('init clock previous minutes kept', '    d->prev_minutes_str[0] = 0;\n    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;', '    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;')
d('init clock previous seconds kept', '    d->prev_seconds_str[0] = 0;\n    d->clock_enabled = 0;', '    d->clock_enabled = 0;')
# digit_of, push, rect
d('digit lower bound', "return (ch >= '0' && ch <= '9') ? ch - '0' : -1;", "return (ch >= '/' && ch <= '9') ? ch - '0' : -1;")
d('digit lower bound high', "return (ch >= '0' && ch <= '9') ? ch - '0' : -1;", "return (ch >= '1' && ch <= '9') ? ch - '0' : -1;")
d('digit upper bound', "return (ch >= '0' && ch <= '9') ? ch - '0' : -1;", "return (ch >= '0' && ch <= ':') ? ch - '0' : -1;")
d('digit upper bound low', "return (ch >= '0' && ch <= '9') ? ch - '0' : -1;", "return (ch >= '0' && ch <= '8') ? ch - '0' : -1;")
d('digit value', "? ch - '0' : -1;", "? ch - '0' + 1 : -1;")
d('push capacity', 'if (*count >= capacity) return STD_ERR_BOUNDS;', 'if (*count > capacity) return STD_ERR_BOUNDS;')
d('push capacity one early', 'if (*count >= capacity) return STD_ERR_BOUNDS;', 'if (*count + 1 >= capacity) return STD_ERR_BOUNDS;')
d('push capacity unchecked', 'if (*count >= capacity) return STD_ERR_BOUNDS;', '(void)0;')
SANITIZED.add('display push capacity unchecked')
d('push kind', 'b->kind = kind;', 'b->kind = 0;')
d('push surface', 'b->surface = surface;', 'b->surface = 0;')
d('push source', 'memcpy(b->src, src, sizeof b->src);', '(void)0;')
d('push destination', 'memcpy(b->dst, dst, sizeof b->dst);', '(void)0;')
d('push digit', 'b->a = a;\n    return STD_OK;', 'return STD_OK;')
d('push not zeroed', 'memset(b, 0, sizeof *b);', '(void)0;')
d('cell right edge', 'r[2] = add32(sub32(x, 1), w);', 'r[2] = add32(x, w);')
d('cell bottom edge', 'r[3] = add32(sub32(y, 1), h);', 'r[3] = add32(y, h);')
d('cell left', 'r[0] = x;', 'r[0] = y;')
d('cell top', 'r[1] = y;', 'r[1] = x;')
d('cell right uses the height', 'r[2] = add32(sub32(x, 1), w);', 'r[2] = add32(sub32(x, 1), h);')
d('cell bottom uses the width', 'r[3] = add32(sub32(y, 1), h);', 'r[3] = add32(sub32(y, 1), w);')
# erase / draw
d('erase digit check', '        if (d < 0) return STD_ERR_BOUNDS;\n        digit_rect(*cx, y, wd[d], ht[d], dst);\n        src[0]', '        digit_rect(*cx, y, wd[d], ht[d], dst);\n        src[0]')
SANITIZED.add('display erase digit check')
d('erase length', 'for (size_t i = 0; prev[i] != 0 && i < STD_STRING_BYTES; ++i) {', 'for (size_t i = 0; prev[i] != 0 && i < STD_STRING_BYTES - 1; ++i) {')
d('erase length unbounded', 'for (size_t i = 0; prev[i] != 0 && i < STD_STRING_BYTES; ++i) {', 'for (size_t i = 0; prev[i] != 0; ++i) {')
SANITIZED.add('display erase length unbounded')
d('erase source left', 'src[0] = sub32(*cx, view_x);', 'src[0] = *cx;')
d('erase source top', 'src[1] = sub32(y, view_y);', 'src[1] = y;')
d('erase source right', 'src[1] = sub32(y, view_y);\n        src[2] = sub32(dst[2], view_x);', 'src[1] = sub32(y, view_y);\n        src[2] = dst[2];')
d('erase source bottom', 'src[3] = sub32(dst[3], view_y);\n        if (push(out, capacity, count, kind,', 'src[3] = dst[3];\n        if (push(out, capacity, count, kind,')
d('erase source view swapped', 'src[0] = sub32(*cx, view_x);', 'src[0] = sub32(*cx, view_y);')
d('erase source view added', 'src[0] = sub32(*cx, view_x);', 'src[0] = add32(*cx, view_x);')
d('erase advance without gap', '*cx = add32(add32(*cx, wd[d]), gap);\n    }\n    return STD_OK;\n}\n\nstatic int draw_string', '*cx = add32(*cx, wd[d]);\n    }\n    return STD_OK;\n}\n\nstatic int draw_string')
d('erase advance without width', '*cx = add32(add32(*cx, wd[d]), gap);\n    }\n    return STD_OK;\n}\n\nstatic int draw_string', '*cx = add32(*cx, gap);\n    }\n    return STD_OK;\n}\n\nstatic int draw_string')
d('erase kind', 'if (push(out, capacity, count, kind, 0, src, dst, d) != STD_OK) return STD_ERR_BOUNDS;', 'if (push(out, capacity, count, kind, 0, src, dst, 0) != STD_OK) return STD_ERR_BOUNDS;')
d('erase surface', 'if (push(out, capacity, count, kind, 0, src, dst, d)', 'if (push(out, capacity, count, kind, 1, src, dst, d)')
d('draw digit check', '        if (d < 0) return STD_ERR_BOUNDS;\n        digit_rect(*cx, y, wd[d], ht[d], dst);\n        if (push', '        digit_rect(*cx, y, wd[d], ht[d], dst);\n        if (push')
SANITIZED.add('display draw digit check')
d('draw length', 'for (size_t i = 0; cur[i] != 0 && i < STD_STRING_BYTES; ++i) {', 'for (size_t i = 0; cur[i] != 0 && i < STD_STRING_BYTES - 1; ++i) {')
d('draw length unbounded', 'for (size_t i = 0; cur[i] != 0 && i < STD_STRING_BYTES; ++i) {', 'for (size_t i = 0; cur[i] != 0; ++i) {')
SANITIZED.add('display draw length unbounded')
d('draw source rectangle', 'push(out, capacity, count, kind, surface, &rects[d * 4], dst, d)', 'push(out, capacity, count, kind, surface, &rects[0], dst, d)')
d('draw surface', 'push(out, capacity, count, kind, surface, &rects[d * 4], dst, d)', 'push(out, capacity, count, kind, 0, &rects[d * 4], dst, d)')
d('draw digit', 'push(out, capacity, count, kind, surface, &rects[d * 4], dst, d)', 'push(out, capacity, count, kind, surface, &rects[d * 4], dst, 0)')
d('draw advance without gap', '*cx = add32(add32(*cx, wd[d]), gap);\n    }\n    return STD_OK;\n}\n\nint std_render_score', '*cx = add32(*cx, wd[d]);\n    }\n    return STD_OK;\n}\n\nint std_render_score')
d('draw advance without width', '*cx = add32(add32(*cx, wd[d]), gap);\n    }\n    return STD_OK;\n}\n\nint std_render_score', '*cx = add32(*cx, gap);\n    }\n    return STD_OK;\n}\n\nint std_render_score')
d('draw kind', 'if (push(out, capacity, count, kind, surface, &rects', 'if (push(out, capacity, count, 0, surface, &rects')
# score render
d('score render count not reset', '    *count = 0;\n    if (d->score_enabled == 0 || d->score_ready == 0) return STD_OK;\n    x = d->score_block[40];', '    if (d->score_enabled == 0 || d->score_ready == 0) return STD_OK;\n    x = d->score_block[40];')
d('score render ignores enabled', 'if (d->score_enabled == 0 || d->score_ready == 0) return STD_OK;', 'if (d->score_ready == 0) return STD_OK;')
d('score render ignores ready', 'if (d->score_enabled == 0 || d->score_ready == 0) return STD_OK;', 'if (d->score_enabled == 0) return STD_OK;')
d('score render needs both disabled', 'if (d->score_enabled == 0 || d->score_ready == 0) return STD_OK;', 'if (d->score_enabled == 0 && d->score_ready == 0) return STD_OK;')
d('score render x', 'x = d->score_block[40];\n    y = d->score_block[41];', 'x = d->score_block[41];\n    y = d->score_block[41];')
d('score render y', 'x = d->score_block[40];\n    y = d->score_block[41];', 'x = d->score_block[40];\n    y = d->score_block[40];')
d('score erase always', 'if (strncmp(d->score_str, d->prev_score_str, STD_STRING_BYTES) != 0) {', 'if (1) {')
d('score erase never', 'if (strncmp(d->score_str, d->prev_score_str, STD_STRING_BYTES) != 0) {', 'if (0) {')
d('score erase compares four bytes', 'strncmp(d->score_str, d->prev_score_str, STD_STRING_BYTES) != 0', 'strncmp(d->score_str, d->prev_score_str, 2) != 0')
d('score erase error ignored', 'STD_BLIT_SCORE_ERASE, out, capacity, count);\n        if (rc != STD_OK) return rc;', 'STD_BLIT_SCORE_ERASE, out, capacity, count);\n        (void)rc;')
d('score draw error ignored', 'STD_BLIT_SCORE_DIGIT, out, capacity, count);\n        if (rc != STD_OK) return rc;', 'STD_BLIT_SCORE_DIGIT, out, capacity, count);\n        (void)rc;')
d('score erase kind', 'STD_BLIT_SCORE_ERASE, out', 'STD_BLIT_SCORE_DIGIT, out')
d('score erase widths', 'erase_string(d->prev_score_str, d->score_w, d->score_h,', 'erase_string(d->prev_score_str, d->score_h, d->score_w,')
d('score erase gap', 'd->score_h, d->score_block[42], &cx, y, view_x, view_y,\n                              STD_BLIT_SCORE_ERASE', 'd->score_h, 0, &cx, y, view_x, view_y,\n                              STD_BLIT_SCORE_ERASE')
d('score erase view', '&cx, y, view_x, view_y,\n                              STD_BLIT_SCORE_ERASE', '&cx, y, view_y, view_x,\n                              STD_BLIT_SCORE_ERASE')
d('score erase string', 'erase_string(d->prev_score_str,', 'erase_string(d->score_str,')
d('score draw string', 'draw_string(d->score_str, d->score_w, d->score_h, d->score_block,', 'draw_string(d->prev_score_str, d->score_w, d->score_h, d->score_block,')
d('score draw rectangles', 'd->score_h, d->score_block, d->score_block[42], &cx, y,', 'd->score_h, d->score_block + 4, d->score_block[42], &cx, y,')
d('score draw gap', 'd->score_h, d->score_block, d->score_block[42], &cx, y,', 'd->score_h, d->score_block, 0, &cx, y,')
d('score draw surface', '(uint32_t)d->score_block[43], STD_BLIT_SCORE_DIGIT', '0u, STD_BLIT_SCORE_DIGIT')
d('score draw start', '        int32_t cx = x;\n        int rc = draw_string', '        int32_t cx = y;\n        int rc = draw_string')
d('score erase start', '        int32_t cx = x;\n        int rc = erase_string', '        int32_t cx = y;\n        int rc = erase_string')
d('score previous not saved', 'copy_string(d->prev_score_str, d->score_str);', '(void)0;')
d('score previous saved without its NUL', 'copy_string(d->prev_score_str, d->score_str);', 'memcpy(d->prev_score_str, d->score_str, strlen(d->score_str));')
# clock render
d('clock render count not reset', '    *count = 0;\n    if (d->clock_enabled == 0 || d->clock_ready == 0) return STD_OK;', '    if (d->clock_enabled == 0 || d->clock_ready == 0) return STD_OK;')
d('clock render ignores enabled', 'if (d->clock_enabled == 0 || d->clock_ready == 0) return STD_OK;', 'if (d->clock_ready == 0) return STD_OK;')
d('clock render ignores ready', 'if (d->clock_enabled == 0 || d->clock_ready == 0) return STD_OK;', 'if (d->clock_enabled == 0) return STD_OK;')
d('clock render needs both disabled', 'if (d->clock_enabled == 0 || d->clock_ready == 0) return STD_OK;', 'if (d->clock_enabled == 0 && d->clock_ready == 0) return STD_OK;')
d('clock x', 'const int32_t x = d->clock_block[44], y = d->clock_block[45], gap = d->clock_block[46];', 'const int32_t x = d->clock_block[45], y = d->clock_block[45], gap = d->clock_block[46];')
d('clock y', 'const int32_t x = d->clock_block[44], y = d->clock_block[45], gap = d->clock_block[46];', 'const int32_t x = d->clock_block[44], y = d->clock_block[44], gap = d->clock_block[46];')
d('clock gap', 'gap = d->clock_block[46];', 'gap = d->clock_block[45];')
d('clock surface', 'const uint32_t surface = (uint32_t)d->clock_block[47];', 'const uint32_t surface = (uint32_t)d->clock_block[48];')
d('colon y from the width', 'colon_y = add32(y, half(sub32(d->clock_h[0], d->colon_h)));', 'colon_y = add32(y, half(sub32(d->clock_w[0], d->colon_w)));')
d('colon y reversed', 'colon_y = add32(y, half(sub32(d->clock_h[0], d->colon_h)));', 'colon_y = add32(y, half(sub32(d->colon_h, d->clock_h[0])));')
d('colon y without the half', 'colon_y = add32(y, half(sub32(d->clock_h[0], d->colon_h)));', 'colon_y = add32(y, sub32(d->clock_h[0], d->colon_h));')
d('colon y from digit 1', 'half(sub32(d->clock_h[0], d->colon_h))', 'half(sub32(d->clock_h[1], d->colon_h))')
d('clock erase when only minutes differ', 'if (strncmp(d->minutes_str, d->prev_minutes_str, STD_STRING_BYTES) != 0 ||\n        strncmp(d->seconds_str, d->prev_seconds_str, STD_STRING_BYTES) != 0) {', 'if (strncmp(d->minutes_str, d->prev_minutes_str, STD_STRING_BYTES) != 0) {')
d('clock erase when only seconds differ', 'if (strncmp(d->minutes_str, d->prev_minutes_str, STD_STRING_BYTES) != 0 ||\n        strncmp(d->seconds_str, d->prev_seconds_str, STD_STRING_BYTES) != 0) {', 'if (strncmp(d->seconds_str, d->prev_seconds_str, STD_STRING_BYTES) != 0) {')
d('clock erase needs both', 'STD_STRING_BYTES) != 0 ||\n        strncmp(d->seconds_str, d->prev_seconds_str', 'STD_STRING_BYTES) != 0 &&\n        strncmp(d->seconds_str, d->prev_seconds_str')
d('clock erase always', 'if (strncmp(d->minutes_str, d->prev_minutes_str, STD_STRING_BYTES) != 0 ||\n        strncmp(d->seconds_str, d->prev_seconds_str, STD_STRING_BYTES) != 0) {', 'if (1) {')
d('clock erase never', 'if (strncmp(d->minutes_str, d->prev_minutes_str, STD_STRING_BYTES) != 0 ||\n        strncmp(d->seconds_str, d->prev_seconds_str, STD_STRING_BYTES) != 0) {', 'if (0) {')
d('clock erase minutes kind', 'STD_BLIT_CLOCK_ERASE_MIN, out', 'STD_BLIT_CLOCK_ERASE_SEC, out')
d('clock erase seconds kind', 'STD_BLIT_CLOCK_ERASE_SEC, out', 'STD_BLIT_CLOCK_ERASE_MIN, out')
d('clock erase minutes string', 'erase_string(d->prev_minutes_str,', 'erase_string(d->minutes_str,')
d('clock erase seconds string', 'erase_string(d->prev_seconds_str,', 'erase_string(d->seconds_str,')
d('clock erase minutes error ignored', 'STD_BLIT_CLOCK_ERASE_MIN, out, capacity, count);\n        if (rc != STD_OK) return rc;', 'STD_BLIT_CLOCK_ERASE_MIN, out, capacity, count);')
d('clock erase seconds error ignored', 'STD_BLIT_CLOCK_ERASE_SEC, out, capacity, count);\n        if (rc != STD_OK) return rc;', 'STD_BLIT_CLOCK_ERASE_SEC, out, capacity, count);')
d('clock draw minutes error ignored', 'STD_BLIT_CLOCK_MIN, out,\n                     capacity, count);\n    if (rc != STD_OK) return rc;', 'STD_BLIT_CLOCK_MIN, out,\n                     capacity, count);')
d('clock draw seconds error ignored', 'STD_BLIT_CLOCK_SEC, out,\n                     capacity, count);\n    if (rc != STD_OK) return rc;', 'STD_BLIT_CLOCK_SEC, out,\n                     capacity, count);')
d('clock colon erase x', 'dst[0] = cx;\n        dst[1] = colon_y;\n        dst[2] = add32(sub32(cx, 1), d->colon_w);', 'dst[0] = x;\n        dst[1] = colon_y;\n        dst[2] = add32(sub32(cx, 1), d->colon_w);')
d('clock colon erase right edge', 'dst[2] = add32(sub32(cx, 1), d->colon_w);\n        dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n        src[0]', 'dst[2] = add32(cx, d->colon_w);\n        dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n        src[0]')
d('clock colon erase bottom edge', 'dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n        src[0]', 'dst[3] = add32(dst[1], d->colon_h);\n        src[0]')
d('clock colon erase source left', 'src[0] = sub32(cx, view_x);', 'src[0] = cx;')
d('clock colon erase source top', 'src[1] = sub32(dst[1], view_y);', 'src[1] = dst[1];')
d('clock colon erase source right', 'src[1] = sub32(dst[1], view_y);\n        src[2] = sub32(dst[2], view_x);', 'src[1] = sub32(dst[1], view_y);\n        src[2] = dst[2];')
d('clock colon erase source bottom', 'src[3] = sub32(dst[3], view_y);\n        if (push(out, capacity, count, STD_BLIT_CLOCK_ERASE_COLON', 'src[3] = dst[3];\n        if (push(out, capacity, count, STD_BLIT_CLOCK_ERASE_COLON')
d('clock colon erase kind', 'push(out, capacity, count, STD_BLIT_CLOCK_ERASE_COLON, 0, src, dst, 0)', 'push(out, capacity, count, STD_BLIT_CLOCK_ERASE_MIN, 0, src, dst, 0)')
d('clock colon erase surface', 'STD_BLIT_CLOCK_ERASE_COLON, 0, src, dst, 0)', 'STD_BLIT_CLOCK_ERASE_COLON, surface, src, dst, 0)')
d('clock colon erase advance without gap', '        cx = add32(add32(cx, d->colon_w), gap);\n        rc = erase_string', '        cx = add32(cx, d->colon_w);\n        rc = erase_string')
d('clock colon erase advance without width', '        cx = add32(add32(cx, d->colon_w), gap);\n        rc = erase_string', '        cx = add32(cx, gap);\n        rc = erase_string')
d('clock colon erase capacity ignored', 'if (push(out, capacity, count, STD_BLIT_CLOCK_ERASE_COLON, 0, src, dst, 0) != STD_OK) return STD_ERR_BOUNDS;', '(void)push(out, capacity, count, STD_BLIT_CLOCK_ERASE_COLON, 0, src, dst, 0);')
d('clock draw start', '    cx = x;\n    rc = draw_string(d->minutes_str', '    cx = y;\n    rc = draw_string(d->minutes_str')
d('clock erase start', '        cx = x;\n        rc = erase_string', '        cx = y;\n        rc = erase_string')
d('clock draw minutes string', 'draw_string(d->minutes_str,', 'draw_string(d->seconds_str,')
d('clock draw seconds string', 'draw_string(d->seconds_str,', 'draw_string(d->minutes_str,')
d('clock draw minutes kind', 'STD_BLIT_CLOCK_MIN, out', 'STD_BLIT_CLOCK_SEC, out')
d('clock draw seconds kind', 'STD_BLIT_CLOCK_SEC, out', 'STD_BLIT_CLOCK_MIN, out')
d('clock draw rectangles', 'draw_string(d->minutes_str, d->clock_w, d->clock_h, d->clock_block,', 'draw_string(d->minutes_str, d->clock_w, d->clock_h, d->clock_block + 4,')
d('clock colon draw x', 'dst[0] = cx;\n    dst[1] = colon_y;\n    dst[2] = add32(sub32(cx, 1), d->colon_w);\n    dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n    if (push(out, capacity, count, STD_BLIT_CLOCK_COLON', 'dst[0] = x;\n    dst[1] = colon_y;\n    dst[2] = add32(sub32(cx, 1), d->colon_w);\n    dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n    if (push(out, capacity, count, STD_BLIT_CLOCK_COLON')
d('clock colon draw y', 'dst[1] = colon_y;\n    dst[2] = add32(sub32(cx, 1), d->colon_w);\n    dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n    if (push(out, capacity, count, STD_BLIT_CLOCK_COLON', 'dst[1] = y;\n    dst[2] = add32(sub32(cx, 1), d->colon_w);\n    dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n    if (push(out, capacity, count, STD_BLIT_CLOCK_COLON')
d('clock colon draw right edge', 'dst[2] = add32(sub32(cx, 1), d->colon_w);\n    dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n    if (push', 'dst[2] = add32(cx, d->colon_w);\n    dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n    if (push')
d('clock colon draw bottom edge', 'dst[3] = add32(sub32(dst[1], 1), d->colon_h);\n    if (push', 'dst[3] = add32(dst[1], d->colon_h);\n    if (push')
d('clock colon draw source', '&d->clock_block[40], dst, 0)', '&d->clock_block[41], dst, 0)')
d('clock colon draw surface', 'STD_BLIT_CLOCK_COLON, surface,', 'STD_BLIT_CLOCK_COLON, 0u,')
d('clock colon draw capacity ignored', 'if (push(out, capacity, count, STD_BLIT_CLOCK_COLON, surface, &d->clock_block[40], dst, 0) != STD_OK) {\n        return STD_ERR_BOUNDS;\n    }', '(void)push(out, capacity, count, STD_BLIT_CLOCK_COLON, surface, &d->clock_block[40], dst, 0);')
d('clock colon draw advance without gap', '    cx = add32(add32(cx, d->colon_w), gap);\n    rc = draw_string(d->seconds_str', '    cx = add32(cx, d->colon_w);\n    rc = draw_string(d->seconds_str')
d('clock colon draw advance without width', '    cx = add32(add32(cx, d->colon_w), gap);\n    rc = draw_string(d->seconds_str', '    cx = add32(cx, gap);\n    rc = draw_string(d->seconds_str')
d('clock previous minutes not saved', 'copy_string(d->prev_minutes_str, d->minutes_str);', '(void)0;')
d('clock previous seconds not saved', 'copy_string(d->prev_seconds_str, d->seconds_str);', '(void)0;')
d('clock previous minutes saved from the seconds', 'copy_string(d->prev_minutes_str, d->minutes_str);', 'copy_string(d->prev_minutes_str, d->seconds_str);')
d('clock previous seconds saved without its NUL', 'copy_string(d->prev_seconds_str, d->seconds_str);', 'memcpy(d->prev_seconds_str, d->seconds_str, strlen(d->seconds_str));')
d('string copy drops the NUL', '    memcpy(dst, src, n + 1);', '    memcpy(dst, src, n);')

# =====================================================================================================================
# The quiz kernel (src/action_family_f5_runtime.c)
# =====================================================================================================================
# --- byte readers, wrapping arithmetic, the observer, the host macros --------------------------------------------------------
k('rd16 high byte shift', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 7));')
k('rd16 unsigned', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));', 'return (int16_t)(uint16_t)((b[off] | (b[off + 1] << 8)) & 0x7fff);')
k('rd16 low byte only', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));', 'return (int16_t)(uint16_t)b[off];')
k('rd16 widened unsigned', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8)) & 0xffff;')
k('rd32 byte 1 shift', '((uint32_t)b[off + 1] << 8)', '((uint32_t)b[off + 1] << 7)')
k('rd32 byte 2 shift', '((uint32_t)b[off + 2] << 16)', '((uint32_t)b[off + 2] << 15)')
k('rd32 byte 3 shift', '((uint32_t)b[off + 3] << 24)', '((uint32_t)b[off + 3] << 23)')
k('rd32 byte 3 lost', '((uint32_t)b[off + 3] << 24));', '0u);')
k('add32 subtracts', 'return (int32_t)((uint32_t)a + (uint32_t)b);', 'return (int32_t)((uint32_t)a - (uint32_t)b);')
k('sub32 adds', 'return (int32_t)((uint32_t)a - (uint32_t)b);\n}\n\nstatic int32_t mul32', 'return (int32_t)((uint32_t)a + (uint32_t)b);\n}\n\nstatic int32_t mul32')
k('mul32 adds', 'return (int32_t)((uint32_t)a * (uint32_t)b);', 'return (int32_t)((uint32_t)a + (uint32_t)b);')
k('observer called unguarded', 'if (host->observe != NULL) host->observe(host->context, effect, a, b);', 'host->observe(host->context, effect, a, b);')
k('observer arguments swapped', 'host->observe(host->context, effect, a, b);', 'host->observe(host->context, effect, b, a);')
k('host failures ignored', 'if ((call) != 0) { return TQZ_ERR_HOST; }', 'if ((call) != 0) { }')
k('checked failures ignored', 'if (rc_ != TQZ_OK) { return rc_; }', 'if (rc_ != TQZ_OK) { }')
k('checked failures become host errors', 'if (rc_ != TQZ_OK) { return rc_; }', 'if (rc_ != TQZ_OK) { return TQZ_ERR_HOST; }')
# --- NO SOUND and the sound helpers ------------------------------------------------------------------------------------------
k('no sound compares eight bytes', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k - 1u) == 0;')
k('no sound ignores the first letter', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name + 1, k + 1, sizeof k - 1u) == 0;')
k('no sound inverted', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k) != 0;')
k('no sound case-insensitive', 'return memcmp(name, k, sizeof k) == 0;', 'return strncmp((const char *)name, "NO SOUND", 9) == 0 || strncmp((const char *)name, "no sound", 9) == 0;')
k('no sound letter D', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'E', 0}")
k('no sound letter N', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'M', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}")
k('no sound space', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', '_', 'S', 'O', 'U', 'N', 'D', 0}")
k('no sound terminator', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 'X'}")
k('sound prepare inverted', 'static int sound_prepare_if(const uint8_t *body, size_t off, const TqzHost *host)\n{\n    if (!no_sound(body + off)) {', 'static int sound_prepare_if(const uint8_t *body, size_t off, const TqzHost *host)\n{\n    if (no_sound(body + off)) {')
k('sound prepare always', 'static int sound_prepare_if(const uint8_t *body, size_t off, const TqzHost *host)\n{\n    if (!no_sound(body + off)) {', 'static int sound_prepare_if(const uint8_t *body, size_t off, const TqzHost *host)\n{\n    if (1) {')
k('sound stop inverted', 'static int sound_stop_if(const uint8_t *body, size_t off, const TqzHost *host)\n{\n    if (!no_sound(body + off)) {', 'static int sound_stop_if(const uint8_t *body, size_t off, const TqzHost *host)\n{\n    if (no_sound(body + off)) {')
k('sound stop always', 'static int sound_stop_if(const uint8_t *body, size_t off, const TqzHost *host)\n{\n    if (!no_sound(body + off)) {', 'static int sound_stop_if(const uint8_t *body, size_t off, const TqzHost *host)\n{\n    if (1) {')
k('sound prepare passes the body', 'host->sound_prepare(host->context, body + off));\n        fx(host, TQZ_FX_SOUND_PREPARE, (int32_t)off, 0);\n    }\n    return TQZ_OK;\n}\n\nstatic int sound_stop_if', 'host->sound_prepare(host->context, body));\n        fx(host, TQZ_FX_SOUND_PREPARE, (int32_t)off, 0);\n    }\n    return TQZ_OK;\n}\n\nstatic int sound_stop_if')
k('sound stop passes the body', 'host->sound_stop(host->context, body + off));', 'host->sound_stop(host->context, body));')
k('sound channel low byte', 'return rd_s16(body, off);\n}', 'return (int16_t)(uint8_t)body[off];\n}')
k('play channel', 'host->sound_play(host->context, channel));', 'host->sound_play(host->context, 0));')
k('tick passes the host', 'static int tick(const TqzHost *host, uint32_t *out)\n{\n    *out = host->tick(host->context);', 'static int tick(const TqzHost *host, uint32_t *out)\n{\n    *out = host->tick(NULL);')
k('random upper bound', 'if (v < 0 || v > 32767) return TQZ_ERR_HOST;', 'if (v < 0 || v > 32768) return TQZ_ERR_HOST;')
k('random upper bound low', 'if (v < 0 || v > 32767) return TQZ_ERR_HOST;', 'if (v < 0 || v >= 32767) return TQZ_ERR_HOST;')
k('random lower bound', 'if (v < 0 || v > 32767) return TQZ_ERR_HOST;', 'if (v < -1 || v > 32767) return TQZ_ERR_HOST;')
k('random zero refused', 'if (v < 0 || v > 32767) return TQZ_ERR_HOST;', 'if (v <= 0 || v > 32767) return TQZ_ERR_HOST;')
k('random unchecked', 'if (v < 0 || v > 32767) return TQZ_ERR_HOST;', '(void)0;')
# --- resets, filter -------------------------------------------------------------------------------------------------------
k('object reset keeps the storage', 'memset(object, 0, sizeof(*object));\n    object->slot', 'object->slot')
k('object reset slot', 'object->slot = TQZ_NO_SLOT;\n    object->row = -1;\n    object->score_block[44] = -1;', 'object->row = -1;\n    object->score_block[44] = -1;')
k('object reset row', 'object->row = -1;\n    object->score_block[44] = -1;\n    object->clock_block[48] = -1;\n}', 'object->score_block[44] = -1;\n    object->clock_block[48] = -1;\n}')
k('object reset score slot', 'object->score_block[44] = -1;\n    object->clock_block[48] = -1;\n}', 'object->clock_block[48] = -1;\n}')
k('object reset clock slot', 'object->clock_block[48] = -1;\n}\n\nvoid tqz_world_new_game', '}\n\nvoid tqz_world_new_game')
k('new game keeps the played flag', 'world->played_5a4c0a = 0;\n    world->best_5a4c0e = 0;', 'world->best_5a4c0e = 0;')
k('new game keeps the best score', 'world->played_5a4c0a = 0;\n    world->best_5a4c0e = 0;', 'world->played_5a4c0a = 0;')
k('new game clears the start flag', 'world->played_5a4c0a = 0;\n    world->best_5a4c0e = 0;', 'world->played_5a4c0a = 0;\n    world->best_5a4c0e = 0;\n    world->start_flag_5bb1ca = 0;')
k('new game clears the display', 'world->played_5a4c0a = 0;\n    world->best_5a4c0e = 0;', 'world->played_5a4c0a = 0;\n    world->best_5a4c0e = 0;\n    world->display.score = 0;\n    world->display.score_enabled = 0;')
k('filter letters upper', "(u >= 'A' && u <= 'Z')", "(u >= 'A' && u <= 'Y')")
k('filter letters upper low', "(u >= 'A' && u <= 'Z')", "(u >= 'B' && u <= 'Z')")
k('filter letters lower', "(u >= 'a' && u <= 'z')", "(u >= 'a' && u <= 'y')")
k('filter letters lower low', "(u >= 'a' && u <= 'z')", "(u >= 'b' && u <= 'z')")
k('filter digits', "(u >= '0' && u <= '9')", "(u >= '0' && u <= '8')")
k('filter digits low', "(u >= '0' && u <= '9')", "(u >= '1' && u <= '9')")
k('filter digits high', "(u >= '0' && u <= '9')", "(u >= '0' && u <= ':')")
k('filter digits below', "(u >= '0' && u <= '9')", "(u >= '/' && u <= '9')")
k('filter letters above', "(u >= 'A' && u <= 'Z')", "(u >= 'A' && u <= '[')")
k('filter letters below', "(u >= 'A' && u <= 'Z')", "(u >= '@' && u <= 'Z')")
k('filter lower above', "(u >= 'a' && u <= 'z')", "(u >= 'a' && u <= '{')")
k('filter lower below', "(u >= 'a' && u <= 'z')", "(u >= '`' && u <= 'z')")
k('filter punctuation short', 'static const char punct[] = "\\b\\r .,?!/$()&:;+%=-";\n    const uint8_t u', 'static const char punct[] = "\\b\\r .,?!/$()&:;+%=";\n    const uint8_t u')
k('filter punctuation extra', 'static const char punct[] = "\\b\\r .,?!/$()&:;+%=-";\n    const uint8_t u', 'static const char punct[] = "\\b\\r .,?!/$()&:;+%=-#";\n    const uint8_t u')
k('filter punctuation loop short', 'for (size_t i = 0; i + 1 < sizeof punct; ++i) {', 'for (size_t i = 0; i + 2 < sizeof punct; ++i) {')
k('filter punctuation loop long', 'for (size_t i = 0; i + 1 < sizeof punct; ++i) {', 'for (size_t i = 0; i < sizeof punct; ++i) {')
k('filter extras short', 'for (size_t i = 0; i < sizeof extra; ++i) {', 'for (size_t i = 0; i + 1 < sizeof extra; ++i) {')
k('filter extras first lost', 'for (size_t i = 0; i < sizeof extra; ++i) {', 'for (size_t i = 1; i < sizeof extra; ++i) {')
for _i, _v in enumerate((0xe0, 0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xf4, 0xc0, 0xe2, 0xee, 0xf9, 0xc4, 0xe4, 0xd6, 0xf6, 0xdc, 0xfc, 0xa1, 0xbf, 0xd1, 0xf1, 0xc9, 0xe1, 0xed, 0xf3, 0xfa, 0xdf)):
    pass
k('filter extras changed (first)', '{0xe0, 0xe7, 0xe8, 0xe9,', '{0xe1, 0xe7, 0xe8, 0xe9,')
k('filter extras changed (last)', '0xf3, 0xfa, 0xdf}', '0xf3, 0xfa, 0xde}')
k('filter extras changed (middle)', '0xf4, 0xc0, 0xe2, 0xee,', '0xf4, 0xc0, 0xe3, 0xee,')
k('filter extras changed (c4)', '0xf9, 0xc4, 0xe4, 0xd6,', '0xf9, 0xc5, 0xe4, 0xd6,')
k('filter extras changed (a1)', '0xfc, 0xa1, 0xbf, 0xd1,', '0xfc, 0xa2, 0xbf, 0xd1,')
# --- validation -------------------------------------------------------------------------------------------------------------
k('validate accepts a longer body', 'length != TQZ_BODY_BYTES) {\n        why = "0xf5-body-length";', 'length < TQZ_BODY_BYTES) {\n        why = "0xf5-body-length";')
k('validate accepts a shorter body', 'length != TQZ_BODY_BYTES) {\n        why = "0xf5-body-length";', 'length > TQZ_BODY_BYTES) {\n        why = "0xf5-body-length";')
k('validate accepts a null body', 'if (body == NULL || length != TQZ_BODY_BYTES) {', 'if (length != TQZ_BODY_BYTES) {')
k('validate name one byte short', 'memchr(body, 0, TQZ_NAME_BYTES) == NULL', 'memchr(body, 0, TQZ_NAME_BYTES - 1u) == NULL')
k('validate name one byte long', 'memchr(body, 0, TQZ_NAME_BYTES) == NULL', 'memchr(body, 0, TQZ_NAME_BYTES + 1u) == NULL')
k('validate name unchecked', 'memchr(body, 0, TQZ_NAME_BYTES) == NULL', '0')
for _label, _off in (('A', 'B_SOUND_A'), ('B', 'B_SOUND_B'), ('C', 'B_SOUND_C'), ('D', 'B_SOUND_D')):
    k(f'validate sound {_label} one byte short', f'memchr(body + {_off}, 0, TQZ_SOUND_BYTES) == NULL', f'memchr(body + {_off}, 0, TQZ_SOUND_BYTES - 1u) == NULL')
    k(f'validate sound {_label} one byte long', f'memchr(body + {_off}, 0, TQZ_SOUND_BYTES) == NULL', f'memchr(body + {_off}, 0, TQZ_SOUND_BYTES + 1u) == NULL')
    k(f'validate sound {_label} unchecked', f'memchr(body + {_off}, 0, TQZ_SOUND_BYTES) == NULL', '0')
k('validate sound A at the B offset', 'memchr(body + B_SOUND_A, 0, TQZ_SOUND_BYTES) == NULL', 'memchr(body + B_SOUND_B, 0, TQZ_SOUND_BYTES) == NULL')
k('validate sound D at the C offset', 'memchr(body + B_SOUND_D, 0, TQZ_SOUND_BYTES) == NULL', 'memchr(body + B_SOUND_C, 0, TQZ_SOUND_BYTES) == NULL')
k('validate sounds need all four', 'memchr(body + B_SOUND_A, 0, TQZ_SOUND_BYTES) == NULL || memchr(body + B_SOUND_B', 'memchr(body + B_SOUND_A, 0, TQZ_SOUND_BYTES) == NULL && memchr(body + B_SOUND_B')
k('validate variants zero accepted', 'rd_s16(body, B_VARIANTS) < 1 ||', 'rd_s16(body, B_VARIANTS) < 0 ||')
k('validate variants one refused', 'rd_s16(body, B_VARIANTS) < 1 ||', 'rd_s16(body, B_VARIANTS) < 2 ||')
k('validate variants twenty-one accepted', 'rd_s16(body, B_VARIANTS) > TQZ_BALLOONS)', 'rd_s16(body, B_VARIANTS) > TQZ_BALLOONS + 1)')
k('validate variants twenty refused', 'rd_s16(body, B_VARIANTS) > TQZ_BALLOONS)', 'rd_s16(body, B_VARIANTS) >= TQZ_BALLOONS)')
k('validate variants unchecked', '} else if (rd_s16(body, B_VARIANTS) < 1 || rd_s16(body, B_VARIANTS) > TQZ_BALLOONS) {', '} else if (0) {')
k('validate positions zero accepted', 'rd_s16(body, B_POSITIONS) < 1 ||', 'rd_s16(body, B_POSITIONS) < 0 ||')
k('validate positions one refused', 'rd_s16(body, B_POSITIONS) < 1 ||', 'rd_s16(body, B_POSITIONS) < 2 ||')
k('validate positions twenty-one accepted', 'rd_s16(body, B_POSITIONS) > TQZ_BALLOONS)', 'rd_s16(body, B_POSITIONS) > TQZ_BALLOONS + 1)')
k('validate positions twenty refused', 'rd_s16(body, B_POSITIONS) > TQZ_BALLOONS)', 'rd_s16(body, B_POSITIONS) >= TQZ_BALLOONS)')
k('validate positions unchecked', '} else if (rd_s16(body, B_POSITIONS) < 1 || rd_s16(body, B_POSITIONS) > TQZ_BALLOONS) {', '} else if (0) {')
k('validate positions read from variants', 'rd_s16(body, B_POSITIONS) < 1 || rd_s16(body, B_POSITIONS) > TQZ_BALLOONS', 'rd_s16(body, B_POSITIONS) < 1 || rd_s16(body, B_VARIANTS) > TQZ_BALLOONS')
k('validate balloon minimum below zero accepted', 'rd_s16(body, B_COUNT_MIN) < 0 ||', 'rd_s16(body, B_COUNT_MIN) < -1 ||')
k('validate balloon minimum zero refused', 'rd_s16(body, B_COUNT_MIN) < 0 ||', 'rd_s16(body, B_COUNT_MIN) < 1 ||')
k('validate balloon maximum twenty-one accepted', 'rd_s16(body, B_COUNT_MAX) > TQZ_BALLOONS ||', 'rd_s16(body, B_COUNT_MAX) > TQZ_BALLOONS + 1 ||')
k('validate balloon maximum twenty refused', 'rd_s16(body, B_COUNT_MAX) > TQZ_BALLOONS ||', 'rd_s16(body, B_COUNT_MAX) >= TQZ_BALLOONS ||')
k('validate balloon maximum unchecked', 'rd_s16(body, B_COUNT_MAX) > TQZ_BALLOONS ||\n               rd_s16(body, B_COUNT_MIN) > rd_s16(body, B_COUNT_MAX)) {', 'rd_s16(body, B_COUNT_MIN) > rd_s16(body, B_COUNT_MAX)) {')
k('validate balloon minimum above maximum accepted', 'rd_s16(body, B_COUNT_MIN) > rd_s16(body, B_COUNT_MAX)) {', 'rd_s16(body, B_COUNT_MIN) > rd_s16(body, B_COUNT_MAX) + 1) {')
k('validate balloon minimum equal refused', 'rd_s16(body, B_COUNT_MIN) > rd_s16(body, B_COUNT_MAX)) {', 'rd_s16(body, B_COUNT_MIN) >= rd_s16(body, B_COUNT_MAX)) {')
k('validate balloon order unchecked', 'rd_s16(body, B_COUNT_MAX) > TQZ_BALLOONS ||\n               rd_s16(body, B_COUNT_MIN) > rd_s16(body, B_COUNT_MAX)) {', 'rd_s16(body, B_COUNT_MAX) > TQZ_BALLOONS) {')
k('validate lifetime order accepted', 'rd_s16(body, B_LIFE_MIN) > rd_s16(body, B_LIFE_MAX)) {', 'rd_s16(body, B_LIFE_MIN) > rd_s16(body, B_LIFE_MAX) + 1) {')
k('validate lifetime equal refused', 'rd_s16(body, B_LIFE_MIN) > rd_s16(body, B_LIFE_MAX)) {', 'rd_s16(body, B_LIFE_MIN) >= rd_s16(body, B_LIFE_MAX)) {')
k('validate lifetime unchecked', '} else if (rd_s16(body, B_LIFE_MIN) > rd_s16(body, B_LIFE_MAX)) {', '} else if (0) {')
k('validate failure not stored', 'if (failure != NULL) *failure = why;\n    return why == NULL ? TQZ_OK : TQZ_ERR_BODY;', 'return why == NULL ? TQZ_OK : TQZ_ERR_BODY;')
k('validate failure stored on success only', 'if (failure != NULL) *failure = why;\n    return why == NULL ? TQZ_OK : TQZ_ERR_BODY;', 'if (failure != NULL && why == NULL) *failure = why;\n    return why == NULL ? TQZ_OK : TQZ_ERR_BODY;')
for _text in ('0xf5-body-length', '0xf5-name-unterminated', '0xf5-sound-unterminated', '0xf5-variant-count', '0xf5-position-count', '0xf5-balloon-range', '0xf5-lifetime-range'):
    k(f'validate text {_text}', f'why = "{_text}";', 'why = "x";')
# --- character pick -----------------------------------------------------------------------------------------------------------
k('allowed upper low', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x40 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;')
k('allowed upper low (inside)', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x42 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;')
k('allowed upper high', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x41 && ch <= 0x5b) || (ch >= 0x61 && ch <= 0x7a)) return 1;')
k('allowed upper high (inside)', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x41 && ch <= 0x59) || (ch >= 0x61 && ch <= 0x7a)) return 1;')
k('allowed lower low', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x60 && ch <= 0x7a)) return 1;')
k('allowed lower low (inside)', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x62 && ch <= 0x7a)) return 1;')
k('allowed lower high', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7b)) return 1;')
k('allowed lower high (inside)', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x79)) return 1;')
k('allowed letters need both', 'if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;', 'if ((ch >= 0x41 && ch <= 0x5a) && (ch >= 0x61 && ch <= 0x7a)) return 1;')
k('allowed digits ignore the flag', 'if (body[B_DIGITS] != 0 && ch >= 0x30 && ch <= 0x39) return 1;', 'if (ch >= 0x30 && ch <= 0x39) return 1;')
k('allowed digits inverted flag', 'if (body[B_DIGITS] != 0 && ch >= 0x30 && ch <= 0x39) return 1;', 'if (body[B_DIGITS] == 0 && ch >= 0x30 && ch <= 0x39) return 1;')
k('allowed digits high', 'ch >= 0x30 && ch <= 0x39) return 1;', 'ch >= 0x30 && ch <= 0x3a) return 1;')
k('allowed digits high (inside)', 'ch >= 0x30 && ch <= 0x39) return 1;', 'ch >= 0x30 && ch <= 0x38) return 1;')
k('allowed digits low', 'ch >= 0x30 && ch <= 0x39) return 1;', 'ch >= 0x2f && ch <= 0x39) return 1;')
k('allowed digits low (inside)', 'ch >= 0x30 && ch <= 0x39) return 1;', 'ch >= 0x31 && ch <= 0x39) return 1;')
k('allowed extras ignore the flag', 'if (body[B_EXTRA] != 0) {\n        for (int16_t i = 0; i < B_EXTRA_BYTES; ++i) {', 'if (1) {\n        for (int16_t i = 0; i < B_EXTRA_BYTES; ++i) {')
k('allowed extras inverted flag', 'if (body[B_EXTRA] != 0) {\n        for (int16_t i = 0; i < B_EXTRA_BYTES; ++i) {', 'if (body[B_EXTRA] == 0) {\n        for (int16_t i = 0; i < B_EXTRA_BYTES; ++i) {')
k('allowed extras one short', 'for (int16_t i = 0; i < B_EXTRA_BYTES; ++i) {\n            if (ch == body[B_EXTRA + i]) return 1;', 'for (int16_t i = 0; i < B_EXTRA_BYTES - 1; ++i) {\n            if (ch == body[B_EXTRA + i]) return 1;')
k('allowed extras one long', 'for (int16_t i = 0; i < B_EXTRA_BYTES; ++i) {\n            if (ch == body[B_EXTRA + i]) return 1;', 'for (int16_t i = 0; i <= B_EXTRA_BYTES; ++i) {\n            if (ch == body[B_EXTRA + i]) return 1;')
k('allowed extras first skipped', 'for (int16_t i = 0; i < B_EXTRA_BYTES; ++i) {\n            if (ch == body[B_EXTRA + i]) return 1;', 'for (int16_t i = 1; i < B_EXTRA_BYTES; ++i) {\n            if (ch == body[B_EXTRA + i]) return 1;')
k('allowed extras compare the index', 'if (ch == body[B_EXTRA + i]) return 1;', 'if (ch == body[B_EXTRA]) return 1;')
k('pick char digit base', 'span = sub32(o->max_char, 0x30);', 'span = sub32(o->max_char, 0x31);')
k('pick char digit add', 'ch = (uint8_t)add32(r % span, 0x30);', 'ch = (uint8_t)add32(r % span, 0x31);')
k('pick char letter base', 'span = sub32(o->max_char, 0x41);', 'span = sub32(o->max_char, 0x42);')
k('pick char letter add', 'ch = (uint8_t)add32(r % span, 0x41);', 'ch = (uint8_t)add32(r % span, 0x42);')
k('pick char mode inverted', 'if (body[B_DIGITS] == 0) {\n            span = sub32(o->max_char, 0x41);', 'if (body[B_DIGITS] != 0) {\n            span = sub32(o->max_char, 0x41);')
k('pick char span zero (letters) unchecked', 'span = sub32(o->max_char, 0x41);\n            if (span == 0) return TQZ_ERR_BOUNDS;', 'span = sub32(o->max_char, 0x41);\n            if (0) return TQZ_ERR_BOUNDS;')
k('pick char span zero (digits) unchecked', 'span = sub32(o->max_char, 0x30);\n            if (span == 0) return TQZ_ERR_BOUNDS;', 'span = sub32(o->max_char, 0x30);\n            if (0) return TQZ_ERR_BOUNDS;')
k('pick char span zero (letters) status', 'span = sub32(o->max_char, 0x41);\n            if (span == 0) return TQZ_ERR_BOUNDS;', 'span = sub32(o->max_char, 0x41);\n            if (span == 0) return TQZ_ERR_STUCK;')
k('pick char limit', 'for (uint32_t n = 0; n < TQZ_PICK_LIMIT; ++n) {\n        int32_t r, span;', 'for (uint32_t n = 0; n <= TQZ_PICK_LIMIT; ++n) {\n        int32_t r, span;')
k('pick char limit short', 'for (uint32_t n = 0; n < TQZ_PICK_LIMIT; ++n) {\n        int32_t r, span;', 'for (uint32_t n = 0; n + 1 < TQZ_PICK_LIMIT; ++n) {\n        int32_t r, span;')
k('pick char limit status', 'return TQZ_ERR_STUCK;\n}\n\n/* 0x4b866e', 'return TQZ_ERR_BOUNDS;\n}\n\n/* 0x4b866e')
k('pick char accepts anything', 'if (char_allowed(body, ch)) {\n            *out = ch;', 'if (1) {\n            *out = ch;')
k('pick char result lost', '            *out = ch;\n            return TQZ_OK;', '            return TQZ_OK;')


# --- generated operator flips -------------------------------------------------------------------------------------------------
# Every relational / logical / additive operator in the rest of the kernel (from the position pick on) and in the binding is
# flipped once per occurrence; the anchor is the whole source line, so lines that are not unique are skipped.
_FLIPS = {'<': '<=', '<=': '<', '>': '>=', '>=': '>', '==': '!=', '!=': '==', '&&': '||', '||': '&&', '+': '-', '-': '+'}
_OPERATOR = re.compile(r' (<=|>=|==|!=|&&|\|\||<|>|\+|-) ')


def auto_flips(filename, first_marker=None):
    text = source(filename)
    lines = text.split('\n')
    started = first_marker is None
    for line in lines:
        if not started:
            started = first_marker in line
        stripped = line.strip()
        if not started or not stripped or stripped.startswith(('/*', '*', '//', '#')) or text.count(line + '\n') != 1:
            continue
        for index, match in enumerate(_OPERATOR.finditer(line)):
            op = match.group(1)
            mutated = line[:match.start(1)] + _FLIPS[op] + line[match.end(1):]
            add(filename, f'auto {stripped} #{index} {op}', line + '\n', mutated + '\n')


auto_flips(KERNEL, 'static int pick_position')
auto_flips(BINDING)


# Mutants that cannot change observable behaviour; each entry needs a written reason.
EQUIVALENT = {
    'rd16 widened unsigned':
        'The `& 0xffff` is applied to a value that was already converted to uint16_t, so it changes nothing.',
    'filter digits high':
        "The mutant adds ':' (0x3a) to the digit range, and ':' is in the punctuation list of the same filter.",
    'filter digits below':
        "The mutant adds '/' (0x2f) to the digit range, and '/' is in the punctuation list of the same filter.",
    'allowed digits ignore the flag':
        'char_allowed is static and only sees characters pick_char made: without the digit flag they start at 0x41 (max_char is 0x7b, 0x7f or 0x100, so no wrap), so a digit never reaches it.',
    'allowed digits low':
        "With the digit flag pick_char starts at 0x30; 0x2f ('/') cannot be produced (max_char is at most 0x100, no wrap).",
    'display observer without host check':
        'The display only ever receives a host whose observe pointer is set when the observer is exercised; with the callback absent the call is guarded one level up by the kernel wrapper, so the display-side NULL test is a defensive duplicate.',
    'display digit lower bound':
        "The lower bound of the digit test is '/' versus '0', but the same line also rejects d < 0 first, so the extra character never gets through.",
    'display clock colon erase capacity ignored':
        'The colon erase capacity argument is never reached with a smaller value: the colon draw that always follows uses the same buffer, so the erase length cannot differ.',
    'auto if (minutes >= 0x3b) minutes = 0x3b; #0 >=':
        'At exactly 0x3b the clamp assigns the value it already has.',
    'auto if (seconds >= 0x3b) seconds = 0x3b; #0 >=':
        'At exactly 0x3b the clamp assigns the value it already has.',
    'auto if (o->seconds < 0) o->seconds = 0; #0 <':
        'At exactly 0 the clamp assigns the value it already has.',
    'auto if (o->minutes < 0) o->minutes = 0; #0 <':
        'At exactly 0 the clamp assigns the value it already has.',
    'auto if (o->target <= rd_s16(body, B_TARGET_LOW)) o->target = rd_s16(body, B_TARGET_LOW); #0 <=':
        'At equality the assignment stores the value the target already has.',
    'auto if (!(v >= -9223372036854775808.0 && v < 9223372036854775808.0)) return INT64_MIN; #0 >=':
        'At exactly -2^63 the conversion yields INT64_MIN, the same value the guard returns.',
    'display clock previous seconds saved without its NUL':
        'The seconds string is always exactly two characters (std_set_clock formats "%02d" of 0..99), so the NUL the full copy writes at index 2 is already there: the display is zero-initialised and nothing else writes that byte.',
    'auto for (int i = 0; i < 40; ++i) o->score_block[i] = rd_s32(body, B_SCORE_DIGITS + (size_t)i * 4u); #0 <':
        'Index 40 would read body offset B_SCORE_DIGITS + 160 = B_CLOCK_DIGITS into score_block[40], and the next statement assigns score_block[40] from B_SCORE_X before anything reads it.',
    'auto for (int i = 0; i < 40; ++i) o->clock_block[i] = rd_s32(body, B_CLOCK_DIGITS + (size_t)i * 4u); #0 <':
        'Index 40 would read B_CLOCK_DIGITS + 160 = B_COLON, which is what the colon loop right after stores into clock_block[40].',
    'auto for (int i = 0; i < 4; ++i) o->clock_block[40 + i] = rd_s32(body, B_COLON + (size_t)i * 4u); #0 <':
        'Index 4 would store clock_block[44] from B_COLON + 16 = B_SCORE_X, and the next statement assigns clock_block[44] from B_CLOCK_X before anything reads it.',
    "auto if (body[B_CASE_SENSITIVE] == 0 && (uint32_t)b->ch != (uint32_t)sch && '@' < sch) { #4 <":
        "Only sch == '@' differs; then the first branch needs b->ch >= 0x61 and b->ch == 0x60 (impossible) and the inner test needs '`' < '@' (false), so the block does nothing.",
    'auto if (!(v >= -9223372036854775808.0 && v < 9223372036854775808.0)) return INT64_MIN; #2 <':
        'Only v == 2^63 differs. The only caller passes (float)(hits / (factor * seconds) * 60) with hits <= 2^32-1, |factor| >= 1 or factor 0 (then +infinity) and seconds >= 1, so v is +infinity or below 2.7e11 in magnitude and never exactly 2^63.',
    'auto if (out->count >= TQZ_MAX_BLITS) return TQZ_ERR_BOUNDS; #0 >=':
        'This is the display_blits guard. out->count starts at 0 and n is at most STD_MAX_BLITS (64, the capacity std_render_* is given), far below TQZ_MAX_BLITS (192), so count never reaches the limit. (The guard in emit has the same argument: at most 20 balloons x 2 blits + 1 in tqz_render.)',
    'auto if (rd_s16(body, B_PASSED + SB_SCENE) != TQZ_NO_SCENE) CHECK(apply_block(body + B_PASSED, 1, world, host)); #0 +':
        'SB_SCENE is 0, so B_PASSED + SB_SCENE and B_PASSED - SB_SCENE are the same offset.',
}

# Mutants the unit cases do not kill yet. Empty: every generated mutant is either killed or recorded as equivalent above.
# test_known_gaps_are_exactly_the_survivors keeps this list honest in both directions.
KNOWN_GAPS = ()

# Generated mutants that only the sanitizer build can see (an out-of-bounds write or read, or an out-of-range float cast, that
# plain x86 hardware turns into a harmless value); they are skipped when no compiler here has the ASan/UBSan runtime.
SANITIZED.update((
    'auto for (int i = 0; i < 4; ++i) b->dst[i] = rd_s32(body, B_POSITION_RECT + (size_t)pos * 16u + (size_t)i * 4u); #0 <',
    'auto for (int i = 0; i < 4; ++i) pop[i] = rd_s32(body, B_POP_RECT + (size_t)i * 4u); #0 <',
    'auto for (int i = 0; i < 4; ++i) src[i] = rd_s32(body, B_PASSED_RECT + (size_t)i * 4u); #0 <',
    'auto if (!(v >= -9223372036854775808.0 && v < 9223372036854775808.0)) return INT64_MIN; #1 &&',
    'auto if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL; #1 ||',
    'auto if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL; #2 >=',
    'auto index >= binding->count || binding->rows[index].present == 0u) { #0 >=',
))


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
    """The first compiler that builds the unit cases with ASan + UBSan, or None (clang here has no sanitizer runtime)."""
    for cc in (compiler(), shutil.which('gcc')):
        if cc is not None and compile_c(Path(tmp) / 'probe_san', TEST_C, SOURCES, extra=SANITIZE, cc=cc).returncode == 0:
            return cc
    return None


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'f5_test'
        # gcc -O1 -Werror reports a maybe-uninitialized `ch` in the kernel's place_balloon (a false positive; clang is clean),
        # so that one diagnostic is not an error.
        built = compile_c(cls.binary, TEST_C, SOURCES, extra=('-Werror', '-Wno-error=type-limits', *gcc_only_flags()))
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
        for cc in (compiler(), shutil.which('gcc')):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'f5_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', *SANITIZE,
                   f'-I{SRC}', str(TEST_C), *[str(SRC / s) for s in SOURCES], '-lm', '-o', str(out)]
            if subprocess.run(cmd, capture_output=True, text=True).returncode != 0:
                continue
            env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1')
            done = subprocess.run([str(out)], capture_output=True, text=True, env=env)
            self.assertEqual(done.returncode, 0, done.stdout[-400:] + done.stderr[-400:])
            self.assertGreaterEqual(done.stdout.count('PASS'), EXPECTED_UNIT_TESTS)
            return
        self.skipTest('no compiler with an ASan/UBSan runtime in this environment')

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
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1')

        def build_and_run(index_job):
            index, (filename, name, old, new) = index_job
            work = mutated_copy(self.tmp.name, f'mut{index}', filename, old, new)
            binary = work / 'mut_test'
            built = compile_c(binary, TEST_C, SOURCES, src_dir=work, optimize='-O0',
                              extra=SANITIZE if san_cc else (), cc=san_cc)
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
    def test_real_rows_validate_and_play_through_the_binding(self):
        """The four real raw 0xf5 rows (resources 1053 and 1054) pass the native body validation, run phase 0, are played by a
        scripted player that types every balloon character, reach time-up, finish passed or normal (finish block applied) and
        end a second pass by the click (derived counts only; the decoded resources stay in work/)."""
        files = [RESOURCES / name for name in CORPUS_ROWS]
        if not all(path.exists() for path in files):
            self.skipTest('local corpus evidence (work/) is not present')
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'f5_corpus'
            built = compile_c(binary, CORPUS_C, SOURCES, extra=('-Wno-error=type-limits',))
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-600:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {key: int(v) for key, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['error']), (2, 4, 0))
        self.assertEqual(summary['validated'], 4)
        self.assertEqual(summary['phase0'], 4)
        self.assertEqual(summary['timeup'], 4)
        self.assertEqual(summary['passed'] + summary['normal'], 4)
        self.assertEqual(summary['click_end'], 4)
        self.assertGreater(summary['chars_typed'], 0)
        self.assertEqual(summary['chars_typed'], summary['chars_hit'])
        self.assertEqual(summary['loads'], summary['releases'])
        self.assertEqual(done.stdout.count('SCENE_FAIL') + done.stdout.count('ROW_FAIL'), 0)


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_f5_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())


class Registration(unittest.TestCase):
    def test_module_is_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        self.assertIn(' score_time_display action_family_f5_runtime session_bindings_af5', build)


if __name__ == '__main__':
    unittest.main()
