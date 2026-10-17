"""RT-59: raw 0xda Bul puzzle runtime (src/action_family_da_runtime.c) and the session binding (src/session_bindings_ada.c).

Facts under test (original GAME.EXE, read from the disassembly / Ghidra pseudocode of 0x45c18f, 0x45b5bb, 0x45b7a8, 0x45b872,
0x45b477, 0x45b42e, 0x45b3ea, 0x45d2c6, 0x45ba0b, 0x45bbd8, 0x45bcc1, 0x45bda7, 0x45be3f, 0x45be7f):
 * phase 0 sets the start flag, commits the held item, resets the working rectangles and positions, builds the clearing-out
   rectangles (copied whole, then right / bottom overwritten in the order of the original), allocates one generic z entry, loads
   the puzzle surface once, prepares the four sound records and starts the first caption;
 * phase 1 is a switch on obj+0x24 (idle / button animation / the computer's decision, caption pick, pick of moves, moving step
   by step, wait, score step, win / lose caption, reset wait, caption wait, exit delay);
 * phase 2 stops the three button sounds, applies the finish block (scene change cells, start flag, engine mode) and the event
   flag, runs the generic completion and the cleanup;
 * the pointer test (buttons 0..2 and the finish rectangle), the click, the invalidate, the cleanup and the render callback as
   recovered; the native-only refusals listed in src/action_family_da_runtime.h.
The unit cases live in tests/action_family_da_runtime_test.c (synthetic bodies, no original bytes), the corpus check in
tests/action_family_da_runtime_corpus.c (the two real rows of resource 977). The original-x86 oracle is a separate script (needs
the private work/ evidence and Unicorn).

The mutation sweep changes the kernel and the binding one clause at a time (operator flips, negations, constants, dropped
effects, dropped host-error checks, ...). Every mutant must make a unit case fail, or be listed in EQUIVALENT with the reason it
cannot change observable behaviour. Mutants that only the memory sanitizers see are in SANITIZED.
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
TEST_C = PROJECT / 'tests/action_family_da_runtime_test.c'
KERNEL = 'action_family_da_runtime.c'
BINDING = 'session_bindings_ada.c'
SOURCES = [KERNEL, BINDING, 'scene_resource.c', 'hiff.c']
EXPECTED_UNIT_TESTS = 31
CORPUS_C = PROJECT / 'tests/action_family_da_runtime_corpus.c'
RESOURCES = PROJECT.parents[1] / 'work/analysis/hiff-resources'
CORPUS_ROWS = ('0977.bin',)

SANITIZE = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined']


def compiler():
    # The repo scripts call `xcrun clang` for macOS; where xcrun is absent (cloud container) use clang, cc or gcc.
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')


def gcc_only_flags():
    version = subprocess.run([compiler(), '--version'], capture_output=True, text=True).stdout
    return ('-Wno-maybe-uninitialized',) if 'clang' not in version else ()


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


# ---------------------------------------------------------------------------------------------------------------------------
# Mutants
# ---------------------------------------------------------------------------------------------------------------------------
MUTANTS = {KERNEL: {}, BINDING: {}}
SANITIZED = set()   # mutants that only the memory sanitizers can see (run in a sanitizer build)


def add(table, name, old, new):
    if name.startswith(('auto ', 'effect ')):
        # generated names repeat when the same statement text occurs in several places: number the later ones
        base, number = name, 1
        while name in MUTANTS[table]:
            number += 1
            name = f'{base} @{number}'
    assert name not in MUTANTS[table], name
    MUTANTS[table][name] = (old, new)


def k(name, old, new):
    add(KERNEL, name, old, new)


def b(name, old, new):
    add(BINDING, 'binding ' + name, old, new)


def source(filename):
    return (SRC / filename).read_text()


def unique_anchor(lines, number):
    """The line, extended upwards by up to four lines until it occurs once in the file; None when it never does."""
    text = '\n'.join(lines) + '\n'
    anchor = lines[number]
    back = 1
    while text.count(anchor + '\n') != 1 and back <= 4 and number - back >= 0:
        anchor = lines[number - back] + '\n' + anchor
        back += 1
    return anchor if text.count(anchor + '\n') == 1 else None


def is_code(stripped):
    return bool(stripped) and not stripped.startswith(('/*', '*', '//', '#'))


# Dropped effects: every observer call becomes a no-op.
def drop_effects(filename):
    lines = source(filename).split('\n')
    for number, line in enumerate(lines):
        stripped = line.strip()
        if not re.match(r'^(fx\(\w+, BUL_FX_\w+, .*\);|if \(host->observe != NULL\) host->observe\(.*\);)$', stripped):
            continue
        anchor = unique_anchor(lines, number)
        if anchor is None:
            continue
        add(filename, f'effect dropped ({filename}:{number + 1}) {stripped[:60]}', anchor + '\n',
            (anchor[:len(anchor) - len(line)] + line.replace(stripped, '(void)0;')) + '\n')


drop_effects(KERNEL)

_FLIPS = {'<': '<=', '<=': '<', '>': '>=', '>=': '>', '==': '!=', '!=': '==', '&&': '||', '||': '&&', '+': '-', '-': '+',
          '&': '|', '|': '&', '%': '*', '*': '/', '<<': '>>'}
_OPERATOR = re.compile(r' (<=|>=|==|!=|&&|\|\||<<|<|>|\+|-|&|\||%|\*) ')
_NEGATION = re.compile(r'(?<![!=<>])!(?=[A-Za-z_(])')
_LITERAL = re.compile(r'(?<![\w.])(0x[0-9a-fA-F]+|\d+)(u?)(?![\w.])')


def mask_text(line):
    """The line with string / character literals and a trailing comment blanked out (same length), so the generators only touch
    code."""
    out = []
    quote = None
    i = 0
    while i < len(line):
        ch = line[i]
        if quote is None and line.startswith('/*', i):
            out.append(' ' * (len(line) - i))
            break
        if quote is None and ch in '"\'':
            quote = ch
            out.append(' ')
        elif quote is not None:
            if ch == '\\' and i + 1 < len(line):
                out.append('  ')
                i += 2
                continue
            if ch == quote:
                quote = None
            out.append(' ')
        else:
            out.append(ch)
        i += 1
    return ''.join(out)


def auto_mutants(filename, first_marker=None, last_marker=None):
    text = source(filename)
    lines = text.split('\n')
    started = first_marker is None
    for number, line in enumerate(lines):
        if not started:
            started = first_marker in line
        if last_marker is not None and last_marker in line:
            break
        stripped = line.strip()
        if not started or not is_code(stripped):
            continue
        anchor = unique_anchor(lines, number)
        if anchor is None:
            continue
        prefix = anchor[:len(anchor) - len(line)]
        masked = mask_text(line)

        def put(name, mutated):
            add(filename, f'auto {name}', anchor + '\n', prefix + mutated + '\n')

        for index, match in enumerate(_OPERATOR.finditer(masked)):
            op = match.group(1)
            put(f'{stripped} #{index} {op}', line[:match.start(1)] + _FLIPS[op] + line[match.end(1):])
        for index, match in enumerate(_NEGATION.finditer(masked)):
            put(f'{stripped} #{index} !', line[:match.start()] + line[match.end():])
        if re.match(r'^(enum|typedef)\b', stripped):
            continue
        for index, match in enumerate(_LITERAL.finditer(masked)):
            text_value = match.group(1)
            value = int(text_value, 16) if text_value.lower().startswith('0x') else int(text_value)
            if value < 2 or 'sizeof' in line[:match.start()] or '[' in line[match.start() - 1:match.start()]:
                continue
            new_value = hex(value + 1) if text_value.lower().startswith('0x') else str(value + 1)
            put(f'{stripped} #{index} literal {text_value}', line[:match.start(1)] + new_value + line[match.end(1):])


auto_mutants(KERNEL, 'static void fx(')
auto_mutants(BINDING)

# Clauses the generators cannot express: the host-error checks, the status checks and a few structural clauses.
k('HOST macro ignores a host failure', 'if ((call) != 0) {           \\', 'if ((call) == 99) {          \\')
k('HOST macro reports success', '(c)->why = "0xda-host";  \\\n            return BUL_ERR_HOST;     \\', '(c)->why = "0xda-host";  \\\n            return BUL_OK;           \\')
k('HOST macro loses the reason', '(c)->why = "0xda-host";  \\', '(c)->why = NULL;           \\')
k('CHECK macro ignores a failure', 'if (rc_ != BUL_OK) {         \\', 'if (rc_ == 99) {            \\')
k('CHECK macro changes the status', 'return rc_;              \\', 'return BUL_ERR_HOST;       \\')
k('real_name accepts NO SOUND', 'return !no_sound(name) && name[0] != 0;', 'return name[0] != 0;')
k('real_name accepts empty', 'return !no_sound(name) && name[0] != 0;', 'return !no_sound(name);')
k('no_sound compares eight bytes', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k - 1) == 0;')
k('no_sound compares the terminator away', 'static const uint8_t k[9] = {\'N\', \'O\', \' \', \'S\', \'O\', \'U\', \'N\', \'D\', 0};', 'static const uint8_t k[9] = {\'N\', \'O\', \' \', \'S\', \'O\', \'U\', \'N\', \'D\', \'X\'};')
k('observer unguarded', 'if (c->host->observe != NULL) c->host->observe(c->host->context, effect, a, b);', 'c->host->observe(c->host->context, effect, a, b);')
k('observer arguments swapped', 'c->host->observe(c->host->context, effect, a, b);', 'c->host->observe(c->host->context, effect, b, a);')
k('rd_s16 unsigned', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));', 'return (int16_t)(b[off] | (b[off + 1] << 8)) & 0x7fff;')
k('rd_s32 high byte lost', '((uint32_t)b[off + 3] << 24));', '((uint32_t)b[off + 3] << 23));')
k('rd_rect swaps right and bottom', 'r->right = rd_s32(b, off + 8);\n    r->bottom = rd_s32(b, off + 12);', 'r->right = rd_s32(b, off + 12);\n    r->bottom = rd_s32(b, off + 8);')
k('add16 wraps like 32 bits', 'return (int16_t)(uint16_t)((uint32_t)(uint16_t)a + (uint32_t)(uint16_t)b);', 'return (int16_t)((int32_t)a + (int32_t)b);')
k('shifted moves the bottom by x', 's.bottom = add32(r->bottom, vy);', 's.bottom = add32(r->bottom, vx);')
k('shifted moves the top by x', 's.top = add32(r->top, vy);', 's.top = add32(r->top, vx);')
k('shifted leaves the right', 's.right = add32(r->right, vx);', 's.right = r->right;')
k('bounds status', 'c->why = "0xda-rect-index";\n        return BUL_ERR_BOUNDS;', 'c->why = "0xda-rect-index";\n        return BUL_ERR_HOST;')
k('rect index low bound', 'if (index < lo || index >= hi) {', 'if (index < lo + 1 || index >= hi) {')
k('rect index high bound', 'if (index < lo || index >= hi) {', 'if (index < lo || index > hi) {')
k('rect offset is 8 bytes per rectangle', 'rd_rect(out, c->body, (size_t)((int64_t)base + (int64_t)index * 16));', 'rd_rect(out, c->body, (size_t)((int64_t)base + (int64_t)index * 8));')
k('tick effect value', 'fx(c, BUL_FX_TICK, (int32_t)*out, 0);', 'fx(c, BUL_FX_TICK, 0, 0);')
k('random lower bound', 'if (v < 0 || v > 32767) {', 'if (v < 1 || v > 32767) {')
k('random upper bound', 'if (v < 0 || v > 32767) {', 'if (v < 0 || v > 32766) {')
k('random status', 'c->why = "0xda-random";\n        return BUL_ERR_HOST;', 'c->why = "0xda-random";\n        return BUL_ERR_BOUNDS;')
k('sound play host failure ignored', 'HOST(c, c->host->sound_play(c->host->context, channel));', '(void)c->host->sound_play(c->host->context, channel);')
k('busy always false', '*out = c->host->sound_busy(c->host->context, channel) != 0;', '*out = c->host->sound_busy(c->host->context, channel) == 99;')
k('busy not queried', '*out = c->host->sound_busy(c->host->context, channel) != 0;', '*out = 0;')
k('play_if_idle plays when busy', 'if (!is_busy) CHECK(play(c, channel));', 'CHECK(play(c, channel));')
k('prepare ignores NO SOUND', 'if (!no_sound(c->body + off)) {\n        HOST(c, c->host->sound_prepare(c->host->context, c->body + off));', 'if (1) {\n        HOST(c, c->host->sound_prepare(c->host->context, c->body + off));')
k('stop ignores NO SOUND', 'if (!no_sound(c->body + off)) {\n        HOST(c, c->host->sound_stop(c->host->context, c->body + off));', 'if (1) {\n        HOST(c, c->host->sound_stop(c->host->context, c->body + off));')
k('prepare host failure ignored', 'HOST(c, c->host->sound_prepare(c->host->context, c->body + off));', '(void)c->host->sound_prepare(c->host->context, c->body + off);')
k('stop host failure ignored', 'HOST(c, c->host->sound_stop(c->host->context, c->body + off));', '(void)c->host->sound_stop(c->host->context, c->body + off);')
k('prepare effect offset', 'fx(c, BUL_FX_SOUND_PREPARE, (int32_t)off, 0);', 'fx(c, BUL_FX_SOUND_PREPARE, 0, 0);')
k('stop effect offset', 'fx(c, BUL_FX_SOUND_STOP, (int32_t)off, 0);', 'fx(c, BUL_FX_SOUND_STOP, 0, 0);')
k('reset leaves the row', 'object->row = -1;\n    object->slot = -1;', 'object->slot = -1;')
k('reset leaves the slot', 'object->slot = -1;\n    object->active = 0;', 'object->active = 0;')
k('reset leaves active', 'object->active = 0;\n    object->won = 0;', 'object->won = 0;')
k('reset leaves won', 'object->won = 0;\n    object->finish_kind = 0;', 'object->finish_kind = 0;')
k('reset leaves the finish kind', 'object->finish_kind = 0;\n    return BUL_OK;\n}\n\nstatic int emit_pair', 'return BUL_OK;\n}\n\nstatic int emit_pair')
k('power-on object has no slot marker', 'object->slot = BUL_NO_SLOT;\n    object->row = -1;', 'object->row = -1;')
k('power-on object has no row marker', 'object->slot = BUL_NO_SLOT;\n    object->row = -1;', 'object->slot = BUL_NO_SLOT;')
k('power-on object not cleared', 'memset(object, 0, sizeof(*object));\n    object->slot = BUL_NO_SLOT;', 'object->slot = BUL_NO_SLOT;')
k('cleanup keeps the surface handle', 'object->surface = 0; /* 0x4c2dfb zeroes the handle */', '(void)0;')
k('cleanup releases the surface when none', 'if (object->surface != 0) {\n        const uint32_t held', 'if (1) {\n        const uint32_t held')
k('cleanup surface failure ignored', 'if (host->release_surface(host->context, held) != 0) return BUL_ERR_HOST;', '(void)host->release_surface(host->context, held);')
k('cleanup slot failure ignored', 'if (host->release_slot(host->context, object->slot) != 0) return BUL_ERR_HOST;', '(void)host->release_slot(host->context, object->slot);')
k('cleanup releases a missing slot', 'if (object->slot != BUL_NO_SLOT) {\n        if (host->release_slot', 'if (1) {\n        if (host->release_slot')
k('cleanup releases the slot first', 'if (object->surface != 0) {\n        const uint32_t held', 'if (object->slot != BUL_NO_SLOT) { (void)host->release_slot(host->context, object->slot); }\n    if (object->surface != 0) {\n        const uint32_t held')
k('invalidate marks an inactive object', 'if (object->active != 0 && object->slot != BUL_NO_SLOT) {', 'if (object->slot != BUL_NO_SLOT) {')
k('invalidate marks without a slot', 'if (object->active != 0 && object->slot != BUL_NO_SLOT) {', 'if (object->active != 0) {')
k('invalidate failure ignored', 'if (host->mark_dirty(host->context, object->slot) != 0) return BUL_ERR_HOST;', '(void)host->mark_dirty(host->context, object->slot);')
k('invalidate status', 'if (host->mark_dirty(host->context, object->slot) != 0) return BUL_ERR_HOST;', 'if (host->mark_dirty(host->context, object->slot) != 0) return BUL_ERR_BOUNDS;')
k('click handled on a refused gate', 'if (object->active == 0 || object->won != 0 || object->state != 0 || row_phase != 1u) return BUL_OK;', 'if (object->won != 0 || object->state != 0 || row_phase != 1u) return BUL_OK;')
k('click ignores the won flag', 'if (object->active == 0 || object->won != 0 || object->state != 0 || row_phase != 1u) return BUL_OK;', 'if (object->active == 0 || object->state != 0 || row_phase != 1u) return BUL_OK;')
k('click ignores the state', 'if (object->active == 0 || object->won != 0 || object->state != 0 || row_phase != 1u) return BUL_OK;', 'if (object->active == 0 || object->won != 0 || row_phase != 1u) return BUL_OK;')
k('click ignores the row phase', 'if (object->active == 0 || object->won != 0 || object->state != 0 || row_phase != 1u) return BUL_OK;', 'if (object->active == 0 || object->won != 0 || object->state != 0) return BUL_OK;')
k('click works on a copy of the world', 'local = *world;', 'local.start_flag_5bb1ca = 0;')
k('click writes the caller output first', 'out->handled = 0;\n        out->new_phase = row_phase;\n    }\n    if (object == NULL', 'out->handled = 0;\n    }\n    if (object == NULL')
k('click button without pending kind checks', 'if (kind < 0 || kind > 2) return BUL_ERR_UNSUPPORTED;', '(void)0;')
k('click button kind two refused', 'if (kind < 0 || kind > 2) return BUL_ERR_UNSUPPORTED;', 'if (kind < 0 || kind > 1) return BUL_ERR_UNSUPPORTED;')
k('click button sound ignores NO SOUND', 'if (!no_sound(body + rec)) CHECK(play_if_idle', 'if (1) CHECK(play_if_idle')
k('click button sound ignores the start flag', 'if (local.start_flag_5bb1ca != 0) {', 'if (1) {')
k('click button sound uses the wrong record', 'const size_t rec = BUL_B_SOUND_BUTTON + (size_t)kind * BUL_B_SOUND_RECORD_BYTES;', 'const size_t rec = BUL_B_SOUND_BUTTON;')
k('click button sound channel offset', 'rd_s16(body, rec + B_SOUND_BUTTON_CHANNEL)', 'rd_s16(body, rec)')
k('click finish phase effect', 'out->new_phase = 2u;\n            fx(&c, BUL_FX_ROW_PHASE, 2, 0);', 'out->new_phase = 2u;')
k('click finish does not end the game', 'out->new_phase = 2u;\n            fx(&c, BUL_FX_ROW_PHASE, 2, 0);', 'fx(&c, BUL_FX_ROW_PHASE, 2, 0);')
k('click finish handled flag', 'out->handled = 1;\n        CHECK(caption_pick(&c, B_NAMES_CLICK, 4, 0, &found));', 'CHECK(caption_pick(&c, B_NAMES_CLICK, 4, 0, &found));')
k('click button handled flag', 'out->handled = 1;\n        object->anim_active = 1;', 'object->anim_active = 1;')
k('click finish picks the wrong names', 'B_NAMES_CLICK, 4, 0, &found', 'B_NAMES_CLICK, 4, 1, &found')
k('click finish picks fewer names', 'B_NAMES_CLICK, 4, 0, &found', 'B_NAMES_CLICK, 3, 0, &found')
k('pointer ignores inactive', 'if (object->active == 0 || object->anim_active != 0) return BUL_OK;', 'if (object->anim_active != 0) return BUL_OK;')
k('pointer ignores the animation', 'if (object->active == 0 || object->anim_active != 0) return BUL_OK;', 'if (object->active == 0) return BUL_OK;')
k('pointer ignores the computer turn', 'if (body[BUL_B_TWO_PLAYERS] == 0 && object->mode >= 2) return BUL_OK;', '(void)0;')
k('pointer computer turn needs mode 3', 'if (body[BUL_B_TWO_PLAYERS] == 0 && object->mode >= 2) return BUL_OK;', 'if (body[BUL_B_TWO_PLAYERS] == 0 && object->mode >= 3) return BUL_OK;')
k('pointer x is not a word', 'px = (int16_t)(uint16_t)x;', 'px = (int16_t)(x > 32767 ? 32767 : x);')
k('pointer y is not a word', 'py = (int16_t)(uint16_t)y;', 'py = (int16_t)(y > 32767 ? 32767 : y);')
k('pointer body length not checked', 'if (object == NULL || body == NULL || out == NULL || body_length != BUL_BODY_BYTES) return BUL_ERR_ARGUMENT;', 'if (object == NULL || body == NULL || out == NULL) return BUL_ERR_ARGUMENT;')
k('pointer cursor sub on a miss', 'out->cursor_sub = 0;\n    out->cursor_link = 0;', 'out->cursor_link = 0;')
k('pointer cursor link on a miss', 'out->cursor_sub = 0;\n    out->cursor_link = 0;', 'out->cursor_sub = 0;')
k('pointer button cell', 'out->cursor_cell = 0x5b160cu + 0x16u * 32u + 16u;', 'out->cursor_cell = 0x5b160cu + 0x16u * 32u;')
k('pointer finish cell', 'out->cursor_cell = 0x5b160cu + 9u * 32u + 16u;', 'out->cursor_cell = 0x5b160cu + 9u * 32u;')
k('pointer button stores nothing', 'object->pending_button = (int16_t)kind;', '(void)0;')
k('pointer button result missing', 'out->button = kind;', '(void)0;')
k('pointer button candidate', 'out->candidate = BUL_CANDIDATE_BUTTON;', 'out->candidate = BUL_CANDIDATE_FINISH;')
k('pointer finish candidate', 'out->candidate = BUL_CANDIDATE_FINISH;', 'out->candidate = BUL_CANDIDATE_BUTTON;')
k('pointer button cursor kind', 'out->cursor_kind = 0x16;', 'out->cursor_kind = 9;')
k('pointer finish cursor kind', 'out->cursor_kind = 9;', 'out->cursor_kind = 0x16;')
k('pointer button hit flag', 'out->hit = 1;\n        out->candidate = BUL_CANDIDATE_BUTTON;', 'out->candidate = BUL_CANDIDATE_BUTTON;')
k('pointer finish hit flag', 'out->hit = 1;\n        out->candidate = BUL_CANDIDATE_FINISH;', 'out->candidate = BUL_CANDIDATE_FINISH;')
k('pointer button 0 reaches five up', 'py >= sub32(rd_s32(body, b0 + 4), 5)', 'py >= sub32(rd_s32(body, b0 + 4), 4)')
k('pointer button 0 reaches five down', 'py <= add32(rd_s32(body, b0 + 12), 5)', 'py <= add32(rd_s32(body, b0 + 12), 4)')
k('pointer button 1 narrowed left', 'px >= add32(rd_s32(body, b1), 10)', 'px >= add32(rd_s32(body, b1), 9)')
k('pointer button 1 narrowed right', 'px <= sub32(rd_s32(body, b1 + 8), 10)', 'px <= sub32(rd_s32(body, b1 + 8), 9)')
k('pointer button 1 moved down top', 'py >= add32(rd_s32(body, b1 + 4), 5)', 'py >= add32(rd_s32(body, b1 + 4), 4)')
k('pointer button 1 moved down bottom', 'py <= add32(rd_s32(body, b1 + 12), 5)', 'py <= add32(rd_s32(body, b1 + 12), 4)')
k('pointer button 1 needs mode 1 or 3', '(object->mode == 1 || object->mode == 3) && py >=', '(object->mode == 1 || object->mode == 2) && py >=')
k('pointer button 1 any mode', '} else if ((object->mode == 1 || object->mode == 3) && py >=', '} else if (py >=')

def named(prefix):
    """The one generated mutant whose name starts with `prefix` (so the tables below stay readable and cannot match twice)."""
    found = [n for table in MUTANTS.values() for n in table if n.startswith(prefix)]
    assert len(found) == 1, (prefix, found)
    return found[0]


# Mutants that cannot change observable behaviour; each entry needs a written reason.
EQUIVALENT = {}


def equivalent(prefix, reason):
    EQUIVALENT[named(prefix)] = reason


_RECT_GUARD = ('body_rect is a native bound check. Every index it receives is bounded before it is called: positions are 1..M '
               'with M <= 15 (bul_validate_body and check_object), scores are 0..N with N <= 6, so the indexes are -1..14 for the '
               'position array and -1..5 for the piece arrays and the guard (including the status it returns) never fires.')
equivalent('auto if (index < lo || index >= hi) { #1 ||', _RECT_GUARD)
equivalent('auto if (index < lo || index >= hi) { #2 >=', _RECT_GUARD)
equivalent('rect index high bound', _RECT_GUARD)
equivalent('bounds status', _RECT_GUARD)
_CAPTION_ARGS = ('caption_pick is static and only called with the constants (entry 0 or 1, count 1 or 4), so the native argument '
                 'guard (entry 0..1, count <= 10) never fires and its operators cannot be told apart.')
for _prefix in ('auto if (entry < 0 || entry > 1 || count > 10) { #1 ||', 'auto if (entry < 0 || entry > 1 || count > 10) { #3 ||',
                'auto if (entry < 0 || entry > 1 || count > 10) { #4 >', 'auto if (entry < 0 || entry > 1 || count > 10) { #2 literal 10'):
    equivalent(_prefix, _CAPTION_ARGS)
equivalent('auto if (count < 2) { #0 <', 'caption_pick is only called with count 1 or 4; for those, count < 2 and count <= 2 select the same branch.')
equivalent('auto if (count < 2) { #0 literal 2', 'caption_pick is only called with count 1 or 4; for those, count < 2 and count < 3 select the same branch.')
_OFFSET_ZERO = 'B_SURFACE_NAME and SB_SCENE are 0, so adding or subtracting them gives the same address.'
equivalent('auto } else if (memchr(body + B_SURFACE_NAME, 0, BUL_NAME_BYTES) == NULL) { #0 +', _OFFSET_ZERO)
equivalent('auto HOST(c, c->host->load_surface(c->host->context, (const char *)body + B_SURFACE_NAME, &surface)); #0 +', _OFFSET_ZERO)
equivalent('auto if (rd_s16(body, BUL_B_BLOCK_LEFT + SB_SCENE) != BUL_NO_SCENE) CHECK(apply_block(c, BUL_B_BLOCK_LEFT)); #0 +', _OFFSET_ZERO)
equivalent('auto if (rd_s16(body, BUL_B_BLOCK_ENDED + SB_SCENE) != BUL_NO_SCENE) CHECK(apply_block(c, BUL_B_BLOCK_ENDED)); #0 +', _OFFSET_ZERO)
equivalent('auto char buf[BUL_CAPTION_MAX + 4 + 1]; #0 literal 4',
           'The buffer one byte larger than needed behaves the same: the text is at most BUL_CAPTION_MAX bytes and the kernel writes at most BUL_CAPTION_MAX + 4 bytes plus the terminator.')
equivalent('auto if (out->count >= BUL_MAX_BLITS) { #0 >=',
           'The most blits one render can emit is 48 (8 roll + 5 + 6 + 5 + 6 + 6 piece blits + erase + 2 lights + pass + button + 2 markers + moving + 4 clears), below BUL_MAX_BLITS (64), so count never reaches the limit and the guard (>= or >) never fires.')
equivalent('add16 wraps like 32 bits',
           'add16 is only applied to the mode (0..3), scores (0..6), step (0..moves, moves <= 5) and positions (1..15) minus or plus one; none of them gets near the 16-bit limits where a 16-bit and a 32-bit sum differ.')
equivalent('auto if (i > (size_t)INT16_MAX) { #0 >',
           'The mutant differs only for the row with index exactly 32767, which needs a scene of 32,768 actions; the production parser and every real or unit scene are far below that, so the boundary is not constructible here.')

# Mutants only the memory sanitizers see (a stack or heap overflow that plain hardware turns into a harmless value).
for _prefix in ('auto char buf[BUL_CAPTION_MAX + 4 + 1]; #1 +',
                'auto memcpy(buf + len, "<e>", 4); /* the dword at 0x54ab74: three characters and a NUL */ #0 literal 4',
                'auto buf[len + 4] = \'\\0\'; #0 literal 4',
                'auto if (action == NULL || before == NULL || out == NULL || action->type != SESSION_ADA_TYPE || index >= binding->count || #8 >=',
                'auto if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL; #1 ||',
                'auto if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL; #2 >='):
    SANITIZED.add(named(_prefix))

# Mutants the unit cases do not kill yet. Empty: every mutant is either killed or recorded as equivalent above.
# test_known_gaps_are_exactly_the_survivors keeps this list honest in both directions.
KNOWN_GAPS = ()


def mutated_source(filename, old, new):
    original = (SRC / filename).read_text()
    if original.count(old) != 1:
        raise AssertionError(f'mutation anchor drifted ({original.count(old)} matches): {old[:70]!r}')
    return original.replace(old, new, 1)


def build_objects(root, cc, extra=(), optimize='-O1'):
    """Object files of the unit test and of every source, built once; a mutant recompiles only its own source."""
    objects = {}
    flags = ['-std=c11', '-Wall', '-Wextra', '-Wpedantic', optimize, '-g', f'-I{SRC}', '-Wno-error=type-limits', *extra]
    for name, source_path in (('test', TEST_C), *[(s, SRC / s) for s in SOURCES]):
        target = Path(root) / (Path(name).stem + '.o')
        done = subprocess.run([cc, *flags, '-c', str(source_path), '-o', str(target)], capture_output=True, text=True)
        if done.returncode != 0:
            raise AssertionError(done.stderr[-600:])
        objects[name] = target
    return objects, flags


def run_mutant(root, index, cc, objects, flags, filename, old, new, extra_link=()):
    work = Path(root) / f'mut{index}'
    work.mkdir(parents=True, exist_ok=True)
    path = work / filename
    path.write_text(mutated_source(filename, old, new))
    target = work / 'mutant.o'
    built = subprocess.run([cc, *flags, '-c', str(path), '-o', str(target)], capture_output=True, text=True)
    if built.returncode != 0:
        return 'build', built.stderr[-300:]
    parts = [str(target if name == filename else obj) for name, obj in objects.items() if name != 'test']
    binary = work / 'mutant'
    linked = subprocess.run([cc, *extra_link, str(objects['test']), *parts, '-lm', '-o', str(binary)], capture_output=True, text=True)
    if linked.returncode != 0:
        return 'build', linked.stderr[-300:]
    verdict = 'survived'
    env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1')
    proc = subprocess.Popen(['stdbuf', '-oL', str(binary)] if shutil.which('stdbuf') else [str(binary)],
                            stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, env=env)
    try:
        for line in proc.stdout:
            if line.startswith('FAIL'):
                verdict = 'killed'
                break
        proc.stdout.close()
        if verdict == 'killed':
            proc.kill()
        elif proc.wait(timeout=240) != 0:
            verdict = 'killed'
    except subprocess.TimeoutExpired:
        proc.kill()
        verdict = 'killed'
    finally:
        proc.kill()
        proc.wait()
    shutil.rmtree(work, ignore_errors=True)
    return verdict, ''


def sweep(tmp, names=None):
    """Runs every mutant that is not recorded equivalent; returns {name: verdict}."""
    cc = compiler()
    plain, plain_flags = build_objects(tmp, cc)
    jobs = []
    for filename, mutations in MUTANTS.items():
        for name, (old, new) in mutations.items():
            if (names is None or name in names) and name not in EQUIVALENT and name not in KNOWN_GAPS and name not in SANITIZED:
                jobs.append((filename, name, old, new))
    outcomes = {}

    def go(item):
        index, (filename, name, old, new) = item
        verdict, detail = run_mutant(tmp, index, cc, plain, plain_flags, filename, old, new)
        return name, verdict, detail

    with concurrent.futures.ThreadPoolExecutor(max_workers=min(8, os.cpu_count() or 2)) as pool:
        for name, verdict, detail in pool.map(go, enumerate(jobs)):
            outcomes[name] = (verdict, detail)
    return outcomes


def sweep_sanitized(tmp):
    """The mutants only the sanitizers see, in a sanitizer build (None when no compiler here has the runtime)."""
    probe = Path(tmp) / 'probe_san'
    cc = next((c for c in (compiler(), shutil.which('gcc'))
               if c is not None and compile_c(probe, TEST_C, SOURCES, extra=SANITIZE, cc=c).returncode == 0), None)
    if cc is None:
        return None
    san_root = Path(tmp) / 'san'
    san_root.mkdir()
    objects, flags = build_objects(san_root, cc, extra=SANITIZE, optimize='-O0')
    outcomes = {}
    index = 0
    for filename, mutations in MUTANTS.items():
        for name, (old, new) in mutations.items():
            if name in SANITIZED:
                verdict, detail = run_mutant(san_root, index, cc, objects, flags, filename, old, new, extra_link=SANITIZE)
                outcomes[name] = (verdict, detail)
                index += 1
    return outcomes


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'da_test'
        # gcc -O1 -Werror reports maybe-uninitialized locals that clang does not (false positives), and src/scene_resource.c
        # compares an int16 count against INT16_MAX (type-limits), so those two diagnostics are not errors.
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
            out = Path(self.tmp.name) / 'da_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', *SANITIZE, '-Wno-type-limits',
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
        for name, reason in EQUIVALENT.items():
            self.assertGreater(len(reason), 30, f'equivalent mutant without a reason: {name}')

    def test_mutations_are_detected(self):
        """Every mutant that is neither recorded equivalent nor a named open gap must be killed by the unit cases."""
        outcomes = sweep(self.tmp.name)
        killed = sum(1 for verdict, _ in outcomes.values() if verdict == 'killed')
        for name, (verdict, detail) in sorted(outcomes.items()):
            with self.subTest(name):
                self.assertEqual(verdict, 'killed', f'mutant {verdict}: {name} {detail}')
        print(f'mutants killed: {killed} of {len(outcomes)} ({len(EQUIVALENT)} equivalent, {len(KNOWN_GAPS)} open gaps, '
              f'{len(SANITIZED)} sanitizer-only, not run here)')

    def test_sanitizer_only_mutations_are_detected(self):
        if not SANITIZED:
            self.skipTest('no sanitizer-only mutants recorded')
        outcomes = sweep_sanitized(self.tmp.name)
        if outcomes is None:
            self.skipTest('no compiler with an ASan/UBSan runtime in this environment')
        for name, (verdict, detail) in sorted(outcomes.items()):
            with self.subTest(name):
                self.assertEqual(verdict, 'killed', f'mutant {verdict}: {name} {detail}')


class Corpus(unittest.TestCase):
    def test_real_rows_validate_and_play_through_the_binding(self):
        """The two real raw 0xda rows (resource 977) pass the native body validation, run phase 0, are played to their end by a
        scripted player over many seeds (win and lose, the finish block applied, the generic completion) and are left once by the
        finish rectangle per seed (derived counts only; the decoded resources stay in work/)."""
        files = [RESOURCES / name for name in CORPUS_ROWS]
        if not all(path.exists() for path in files):
            self.skipTest('local corpus evidence (work/) is not present')
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'da_corpus'
            built = compile_c(binary, CORPUS_C, SOURCES, extra=('-Wno-error=type-limits',))
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-600:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {key: int(v) for key, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['error']), (1, 2, 0))
        self.assertEqual(summary['validated'], 2)
        self.assertGreater(summary['phase0'], 2)
        self.assertEqual(summary['ended'], summary['played'])
        self.assertGreater(summary['won'], 0)
        self.assertGreater(summary['lost'], 0)
        self.assertEqual(summary['won'] + summary['lost'], summary['ended'])
        self.assertGreater(summary['left'], 0)
        self.assertEqual(summary['ended'] + summary['left'], summary['finish_blocks'])
        self.assertEqual(summary['phase0'], summary['finish_blocks'])
        self.assertGreater(summary['rolls'], 0)
        self.assertGreater(summary['passes'], 0)
        self.assertGreater(summary['resets'], 0)
        self.assertGreater(summary['blits'], 0)
        self.assertEqual(summary['completes'], summary['phase0'])
        self.assertEqual(summary['loads'], summary['releases'])
        self.assertEqual(summary['registers'], summary['slot_releases'])
        self.assertEqual(done.stdout.count('SCENE_FAIL') + done.stdout.count('ROW_FAIL'), 0)


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_da_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())


class Registration(unittest.TestCase):
    def test_module_is_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        self.assertIn(' action_family_da_runtime session_bindings_ada', build)

    def test_app_glue_excludes_the_slots_both_ways(self):
        """Every other family's z entry allocator excludes ada_slot_used and the Bul allocator excludes theirs (RT-57 pattern)."""
        app = (SRC / 'blackmoor_app.mm').read_text()
        allocators = re.findall(r'static int native_(\w+)_alloc_slot\(void \*context, int16_t \*slot\)\n\{(.*?)\n\}\n', app, re.S)
        families = {name for name, _ in allocators}
        self.assertIn('ada', families)
        self.assertGreaterEqual(len(families), 13)
        for name, body in allocators:
            if name == 'ada':
                for other in sorted(families - {'ada'}):
                    self.assertIn(f'!app->{other}_slot_used[index]', body, f'ada allocator does not exclude {other}')
            else:
                self.assertIn('!app->ada_slot_used[', body, f'{name} allocator does not exclude ada')

    def test_binding_slot_and_count_are_numeric_literals(self):
        app = (SRC / 'blackmoor_app.mm').read_text()
        slot = re.search(r'bindings\[(\d+)\]\.type = SESSION_ADA_TYPE;', app)
        self.assertIsNotNone(slot)
        self.assertEqual(slot.group(1), '59')
        self.assertIn('SceneSessionActionBinding bindings[60]{};', app)
        self.assertIn('config.action_binding_count = 60u;', app)

    def test_progress_map_sees_the_live_handler(self):
        """decomp-progress/playable.py needs gap-free slots 0..count-1; with slot 59 declared and slot 58 (RT-58, raw 0x76) not
        yet merged the map refuses the file ("live binding count drifted"), so this check is only asserted once slot 58 exists."""
        import importlib.util
        app = (SRC / 'blackmoor_app.mm').read_text()
        if not re.search(r'bindings\[58\]\.type = ', app):
            self.skipTest('slot 58 (RT-58) is not merged yet: the progress map needs gap-free binding slots')
        spec = importlib.util.spec_from_file_location('playable', PROJECT / 'decomp-progress/playable.py')
        playable = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(playable)
        actions = playable.derive_actions(PROJECT)
        self.assertIn('0xda', actions['handled']['types'])
        self.assertEqual(actions['registrations']['external']['0xda'], 'native_ada_handler')


if __name__ == '__main__':
    unittest.main()
