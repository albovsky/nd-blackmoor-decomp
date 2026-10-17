"""RT-53: raw 0xd3 Collision Puzzle runtime (src/action_family_d3_runtime.c) and its session binding (src/session_bindings_ad3.c).

Facts under test (original GAME.EXE, read from the disassembly of 0x463392, 0x462c39, 0x4631d1, 0x463b10, 0x4618ab, 0x461862,
0x461827, 0x4618df, 0x462577, 0x462b84, 0x4619be, 0x461d82, 0x461d4b, 0x4630a3, 0x4632bf and 0x42ba3a):
 * phase 0 sets the start flag, optionally resets the persistent grid (body byte 0x21), clears the held item, derives the cell
   size from the first piece rectangle, runs the one-time grid setup, allocates the generic z entry, loads the puzzle surface
   once, prepares the three move sounds and ends in phase 1;
 * phase 1 is a five-state machine on obj+0x24: idle (solved scan), solved (start the delay), moving (one animation step per
   tick, a stop plays sound B on an empty cell type and sound C otherwise because the move check clears the piece number), wait
   for the final sound and wait for the delay;
 * phase 2 stops the move sounds, applies the cancel block or the solved block (scene cells, engine mode, event flag), then the
   generic completion 0x42ba3a and the cleanup;
 * the pointer hit-tests the piece zones (a quarter of the cell width left and right, half the height above and below) in
   scan order and the cancel rectangle; the click starts a slide or asks for the cancel; the render callback blits the overlays,
   the restore of the vacated rectangle and the pieces.
The unit cases live in tests/action_family_d3_runtime_test.c (synthetic bodies, no original bytes). The original-x86 oracle is a
separate script (needs the private work/ evidence and Unicorn).
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
TEST_C = PROJECT / 'tests/action_family_d3_runtime_test.c'
KERNEL = 'action_family_d3_runtime.c'
BINDING = 'session_bindings_ad3.c'
SOURCES = [KERNEL, BINDING, 'scene_resource.c', 'hiff.c']
EXPECTED_UNIT_TESTS = 39
CORPUS_C = PROJECT / 'tests/action_family_d3_runtime_corpus.c'
RESOURCES = PROJECT.parents[1] / 'work/analysis/hiff-resources'


def compiler():
    # The repo scripts call `xcrun clang` for macOS; where xcrun is absent (cloud container) use clang, cc or gcc.
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')


SANITIZE = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined']


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


MUTANTS = {KERNEL: {}, BINDING: {}}


def add(table, name, old, new):
    assert name not in MUTANTS[table], name
    MUTANTS[table][name] = (old, new)


def k(name, old, new):
    add(KERNEL, name, old, new)


# Each mutant breaks one recovered rule; the unit cases must fail on every one of them. Anchors are unique source fragments.
# --- byte readers and wrapping arithmetic -------------------------------------------------------------------------------------
k('rd16 high byte shift', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 7));')
k('rd16 unsigned', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));', 'return (int16_t)(uint16_t)((b[off] | (b[off + 1] << 8)) & 0x7fff);')
k('rd16 low byte only', 'return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));', 'return (int16_t)(uint16_t)b[off];')
k('rd32 byte 1 shift', '((uint32_t)b[off + 1] << 8)', '((uint32_t)b[off + 1] << 7)')
k('rd32 byte 2 shift', '((uint32_t)b[off + 2] << 16)', '((uint32_t)b[off + 2] << 15)')
k('rd32 byte 3 shift', '((uint32_t)b[off + 3] << 24)', '((uint32_t)b[off + 3] << 23)')
k('rd32 byte 3 lost', '((uint32_t)b[off + 3] << 24));', '0u);')
k('add32 subtracts', 'return (int32_t)((uint32_t)a + (uint32_t)b);', 'return (int32_t)((uint32_t)a - (uint32_t)b);')
k('sub32 adds', 'return (int32_t)((uint32_t)a - (uint32_t)b);\n}\n\nstatic int32_t mul32', 'return (int32_t)((uint32_t)a + (uint32_t)b);\n}\n\nstatic int32_t mul32')
k('mul32 adds', 'return (int32_t)((uint32_t)a * (uint32_t)b);', 'return (int32_t)((uint32_t)a + (uint32_t)b);')
k('observer called unguarded', 'if (host->observe != NULL) host->observe(host->context, effect, a, b);', 'host->observe(host->context, effect, a, b);')
k('observer arguments swapped', 'host->observe(host->context, effect, a, b);', 'host->observe(host->context, effect, b, a);')
# --- the NO SOUND test ---------------------------------------------------------------------------------------------------------
k('no sound compares eight bytes', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k - 1u) == 0;')
k('no sound ignores the first letter', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name + 1, k + 1, sizeof k - 1u) == 0;')
k('no sound inverted', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k) != 0;')
k('no sound case-insensitive', 'return memcmp(name, k, sizeof k) == 0;', 'return strncmp((const char *)name, "NO SOUND", 9) == 0 || strncmp((const char *)name, "no sound", 9) == 0;')
k('no sound letter D', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'E', 0}")
k('no sound letter N', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'M', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}")
k('no sound space', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', '_', 'S', 'O', 'U', 'N', 'D', 0}")
k('no sound terminator', "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 'X'}")
k('host failures ignored', 'if ((call) != 0) { return CPZ_ERR_HOST; }', 'if ((call) != 0) { }')
# --- the object and grid resets ------------------------------------------------------------------------------------------------
k('reset keeps the storage', 'memset(object, 0, sizeof(*object));\n    object->slot', 'object->slot')
k('reset slot', 'object->slot = CPZ_NO_SLOT;\n    object->row = -1;\n}', 'object->row = -1;\n}')
k('reset row', 'object->slot = CPZ_NO_SLOT;\n    object->row = -1;\n}', 'object->slot = CPZ_NO_SLOT;\n}')
k('grid reset keeps the ready flag', 'world->grid_ready = 0;\n    memset(world->cell', 'memset(world->cell')
k('grid reset keeps the cells', 'world->grid_ready = 0;\n    memset(world->cell, 0, sizeof(world->cell));', 'world->grid_ready = 0;')
k('grid reset clears one row only', 'memset(world->cell, 0, sizeof(world->cell));\n}', 'memset(world->cell, 0, sizeof(world->cell[0]));\n}')
# --- body validation -----------------------------------------------------------------------------------------------------------
k('validate accepts a longer body', 'length != CPZ_BODY_BYTES', 'length < CPZ_BODY_BYTES')
k('validate accepts a shorter body', 'length != CPZ_BODY_BYTES', 'length > CPZ_BODY_BYTES')
k('validate accepts a null body', 'body == NULL || length != CPZ_BODY_BYTES', 'length != CPZ_BODY_BYTES')
k('validate name one byte short', 'memchr(body, 0, CPZ_NAME_BYTES) == NULL', 'memchr(body, 0, CPZ_NAME_BYTES - 1u) == NULL')
k('validate name one byte long', 'memchr(body, 0, CPZ_NAME_BYTES) == NULL', 'memchr(body, 0, CPZ_NAME_BYTES + 1u) == NULL')
k('validate name unchecked', 'memchr(body, 0, CPZ_NAME_BYTES) == NULL', '0')
for _label, _off in (('A', 'B_SOUND_A'), ('B', 'B_SOUND_B'), ('C', 'B_SOUND_C'), ('D', 'B_SOUND_D')):
    k(f'validate sound {_label} one byte short', f'memchr(body + {_off}, 0, CPZ_SOUND_BYTES) == NULL',
      f'memchr(body + {_off}, 0, CPZ_SOUND_BYTES - 1u) == NULL')
    k(f'validate sound {_label} one byte long', f'memchr(body + {_off}, 0, CPZ_SOUND_BYTES) == NULL',
      f'memchr(body + {_off}, 0, CPZ_SOUND_BYTES + 1u) == NULL')
    k(f'validate sound {_label} unchecked', f'memchr(body + {_off}, 0, CPZ_SOUND_BYTES) == NULL', '0')
k('validate sound A at the B offset', 'memchr(body + B_SOUND_A, 0, CPZ_SOUND_BYTES) == NULL', 'memchr(body + B_SOUND_B, 0, CPZ_SOUND_BYTES) == NULL')
k('validate sound D at the C offset', 'memchr(body + B_SOUND_D, 0, CPZ_SOUND_BYTES) == NULL', 'memchr(body + B_SOUND_C, 0, CPZ_SOUND_BYTES) == NULL')
k('validate rows below zero accepted', 'rd_s16(body, B_ROWS) < 0 ||', 'rd_s16(body, B_ROWS) < -1 ||')
k('validate zero rows refused', 'rd_s16(body, B_ROWS) < 0 ||', 'rd_s16(body, B_ROWS) < 1 ||')
k('validate rows above eight accepted', 'rd_s16(body, B_ROWS) > CPZ_GRID_MAX ||', 'rd_s16(body, B_ROWS) > CPZ_GRID_MAX + 1 ||')
k('validate eight rows refused', 'rd_s16(body, B_ROWS) > CPZ_GRID_MAX ||', 'rd_s16(body, B_ROWS) >= CPZ_GRID_MAX ||')
k('validate rows unchecked', 'rd_s16(body, B_ROWS) < 0 || rd_s16(body, B_ROWS) > CPZ_GRID_MAX ||', '0 ||')
k('validate columns below zero accepted', 'rd_s16(body, B_COLS) < 0 ||', 'rd_s16(body, B_COLS) < -1 ||')
k('validate zero columns refused', 'rd_s16(body, B_COLS) < 0 ||', 'rd_s16(body, B_COLS) < 1 ||')
k('validate columns above eight accepted', 'rd_s16(body, B_COLS) > CPZ_GRID_MAX) {', 'rd_s16(body, B_COLS) > CPZ_GRID_MAX + 1) {')
k('validate eight columns refused', 'rd_s16(body, B_COLS) > CPZ_GRID_MAX) {', 'rd_s16(body, B_COLS) >= CPZ_GRID_MAX) {')
k('validate columns unchecked', 'rd_s16(body, B_COLS) < 0 ||\n               rd_s16(body, B_COLS) > CPZ_GRID_MAX) {', '0) {')
k('validate columns read from rows', 'rd_s16(body, B_COLS) > CPZ_GRID_MAX) {', 'rd_s16(body, B_ROWS) > CPZ_GRID_MAX) {')
k('validate pieces below zero accepted', 'rd_s16(body, B_PIECES) < 0 ||', 'rd_s16(body, B_PIECES) < -1 ||')
k('validate zero pieces refused', 'rd_s16(body, B_PIECES) < 0 ||', 'rd_s16(body, B_PIECES) < 1 ||')
k('validate pieces above ten accepted', 'rd_s16(body, B_PIECES) > CPZ_PIECES_MAX) {', 'rd_s16(body, B_PIECES) > CPZ_PIECES_MAX + 1) {')
k('validate ten pieces refused', 'rd_s16(body, B_PIECES) > CPZ_PIECES_MAX) {', 'rd_s16(body, B_PIECES) >= CPZ_PIECES_MAX) {')
k('validate pieces unchecked', 'rd_s16(body, B_PIECES) < 0 || rd_s16(body, B_PIECES) > CPZ_PIECES_MAX) {', '0) {')
k('validate steps of zero accepted', 'rd_s16(body, B_STEPS) < 1) {', 'rd_s16(body, B_STEPS) < 0) {')
k('validate one step refused', 'rd_s16(body, B_STEPS) < 1) {', 'rd_s16(body, B_STEPS) < 2) {')
k('validate steps unchecked', 'rd_s16(body, B_STEPS) < 1) {', '0) {')
k('validate failure text lost', 'if (failure != NULL) *failure = why;\n    return why == NULL ? CPZ_OK', 'return why == NULL ? CPZ_OK')
k('validate always ok', 'return why == NULL ? CPZ_OK : CPZ_ERR_BODY;', 'return CPZ_OK;')
k('validate length text', '"0xd3-body-length"', '"x"')
k('validate name text', '"0xd3-name-unterminated"', '"x"')
k('validate grid text', '"0xd3-grid-size"', '"x"')
k('validate pieces text', '"0xd3-piece-count"', '"x"')
k('validate steps text', '"0xd3-animation-steps"', '"x"')
k('validate sound text', '"0xd3-sound-unterminated"', '"x"')
# --- the cell rectangle (0x462b84) ---------------------------------------------------------------------------------------------
k('cell left uses the row', 'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w))',
  'add32(add32(add32(mul32(gap, a), view_x), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w))')
k('cell left without the view origin', 'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w))',
  'add32(add32(mul32(gap, b), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w))')
k('cell left with the y view origin', 'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w))',
  'add32(add32(add32(mul32(gap, b), view_y), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w))')
k('cell left without the origin', 'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w))',
  'add32(add32(mul32(gap, b), view_x), mul32(b, o->cell_w))')
k('cell left with the y origin', 'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w))',
  'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_Y)), mul32(b, o->cell_w))')
k('cell left without the cell strides', 'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w))',
  'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), 0)')
k('cell left strides by the height', 'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w))',
  'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_h))')
k('cell left strides by the row', 'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w))',
  'add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), mul32(a, o->cell_w))')
k('cell right is not a width away', 'out[2] = add32(out[0], o->cell_w);', 'out[2] = add32(out[0], o->cell_h);')
k('cell right without the width', 'out[2] = add32(out[0], o->cell_w);', 'out[2] = out[0];')
k('cell top uses the column', 'add32(add32(add32(mul32(gap, a), view_y), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_h))',
  'add32(add32(add32(mul32(gap, b), view_y), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_h))')
k('cell top without the view origin', 'add32(add32(add32(mul32(gap, a), view_y), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_h))',
  'add32(add32(mul32(gap, a), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_h))')
k('cell top with the x view origin', 'add32(add32(add32(mul32(gap, a), view_y), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_h))',
  'add32(add32(add32(mul32(gap, a), view_x), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_h))')
k('cell top without the origin', 'add32(add32(add32(mul32(gap, a), view_y), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_h))',
  'add32(add32(mul32(gap, a), view_y), mul32(a, o->cell_h))')
k('cell top with the x origin', 'add32(add32(add32(mul32(gap, a), view_y), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_h))',
  'add32(add32(add32(mul32(gap, a), view_y), rd_s32(body, B_ORIGIN_X)), mul32(a, o->cell_h))')
k('cell top without the cell strides', 'add32(add32(add32(mul32(gap, a), view_y), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_h))',
  'add32(add32(add32(mul32(gap, a), view_y), rd_s32(body, B_ORIGIN_Y)), 0)')
k('cell top strides by the width', 'add32(add32(add32(mul32(gap, a), view_y), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_h))',
  'add32(add32(add32(mul32(gap, a), view_y), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_w))')
k('cell bottom is not a height away', 'out[3] = add32(out[1], o->cell_h);', 'out[3] = add32(out[1], o->cell_w);')
k('cell bottom without the height', 'out[3] = add32(out[1], o->cell_h);', 'out[3] = out[1];')
k('cell gap from the wrong word', 'const int32_t gap = rd_s16(body, B_GAP);', 'const int32_t gap = rd_s16(body, B_STEPS);')
k('cell gap unsigned', 'const int32_t gap = rd_s16(body, B_GAP);', 'const int32_t gap = (uint16_t)rd_s16(body, B_GAP);')
# --- the one-time grid setup (0x462577) ----------------------------------------------------------------------------------------
k('setup gap half shifts', 'const int32_t gap_half = rd_s16(body, B_GAP) / 2;', 'const int32_t gap_half = rd_s16(body, B_GAP) >> 1;')
k('setup gap half is a third', 'const int32_t gap_half = rd_s16(body, B_GAP) / 2;', 'const int32_t gap_half = rd_s16(body, B_GAP) / 3;')
k('setup gap half is the gap', 'const int32_t gap_half = rd_s16(body, B_GAP) / 2;', 'const int32_t gap_half = rd_s16(body, B_GAP);')
k('setup runs every time', 'if (world->grid_ready != 0) return;', '(void)0;')
k('setup never runs twice but forgets the flag', 'world->grid_ready = 1;\n    for (int16_t a', 'for (int16_t a')
k('setup flag test inverted', 'if (world->grid_ready != 0) return;', 'if (world->grid_ready == 0) return;')
k('setup rows inclusive', 'for (int16_t a = 0; a < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            CpzCell *c', 'for (int16_t a = 0; a <= rows && a < CPZ_GRID_MAX; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            CpzCell *c')
k('setup columns inclusive', 'for (int16_t b = 0; b < cols; ++b) {\n            CpzCell *c', 'for (int16_t b = 0; b <= cols && b < CPZ_GRID_MAX; ++b) {\n            CpzCell *c')
k('setup rows read from columns', 'const int16_t rows = rd_s16(body, B_ROWS), cols = rd_s16(body, B_COLS), pieces = rd_s16(body, B_PIECES);\n    const int32_t gap_half',
  'const int16_t rows = rd_s16(body, B_COLS), cols = rd_s16(body, B_COLS), pieces = rd_s16(body, B_PIECES);\n    const int32_t gap_half')
k('setup cell not cleared first', 'memset(c, 0, sizeof(*c));\n            c->type', 'c->type')
k('setup type row stride', 'B_TYPES + (size_t)a * 16u + (size_t)b * 2u', 'B_TYPES + (size_t)a * 8u + (size_t)b * 2u')
k('setup type column stride', 'B_TYPES + (size_t)a * 16u + (size_t)b * 2u', 'B_TYPES + (size_t)a * 16u + (size_t)b * 4u')
k('setup type transposed', 'B_TYPES + (size_t)a * 16u + (size_t)b * 2u', 'B_TYPES + (size_t)b * 16u + (size_t)a * 2u')
k('setup base not from the cell', 'cell_rect(o, body, view_x, view_y, a, b, c->base);', 'memset(c->base, 0, sizeof c->base);')
k('setup rect not from the cell', 'cell_rect(o, body, view_x, view_y, a, b, c->rect);\n            if (c->type != 0) {', 'memset(c->rect, 0, sizeof c->rect);\n            if (c->type != 0) {')
k('setup base uses the swapped cell', 'cell_rect(o, body, view_x, view_y, a, b, c->base);', 'cell_rect(o, body, view_x, view_y, b, a, c->base);')
k('setup rect uses the swapped cell', 'cell_rect(o, body, view_x, view_y, a, b, c->rect);\n            if (c->type != 0) {', 'cell_rect(o, body, view_x, view_y, b, a, c->rect);\n            if (c->type != 0) {')
k('setup typed cells only for positive types', 'if (c->type != 0) {\n                c->visible = 1;', 'if (c->type > 0) {\n                c->visible = 1;')
k('setup typed cells not visible', 'if (c->type != 0) {\n                c->visible = 1;', 'if (c->type != 0) {\n                c->visible = 0;')
k('setup every cell visible', 'if (c->type != 0) {\n                c->visible = 1;', 'if (1) {\n                c->visible = 1;')
k('setup horizontal arrow width', 'const int32_t w = sub32(rd_s32(body, B_ARROW_H + 8), rd_s32(body, B_ARROW_H));', 'const int32_t w = sub32(rd_s32(body, B_ARROW_H + 8), rd_s32(body, B_ARROW_H + 4));')
k('setup horizontal arrow height', 'const int32_t h = sub32(rd_s32(body, B_ARROW_H + 12), rd_s32(body, B_ARROW_H + 4));', 'const int32_t h = sub32(rd_s32(body, B_ARROW_H + 12), rd_s32(body, B_ARROW_H));')
k('setup horizontal arrow offset', 'const int32_t off = sub32(o->cell_h, h) / 2;', 'const int32_t off = sub32(o->cell_h, h);')
k('setup horizontal arrow offset shifts', 'const int32_t off = sub32(o->cell_h, h) / 2;', 'const int32_t off = sub32(o->cell_h, h) >> 1;')
k('setup horizontal arrow offset uses the width', 'const int32_t off = sub32(o->cell_h, h) / 2;', 'const int32_t off = sub32(o->cell_w, h) / 2;')
k('setup horizontal arrow top', 'c->base[1] = add32(c->base[1], off);\n                    c->base[3] = sub32(c->base[3], off);', 'c->base[1] = sub32(c->base[1], off);\n                    c->base[3] = sub32(c->base[3], off);')
k('setup horizontal arrow bottom', 'c->base[1] = add32(c->base[1], off);\n                    c->base[3] = sub32(c->base[3], off);', 'c->base[1] = add32(c->base[1], off);\n                    c->base[3] = add32(c->base[3], off);')
k('setup left arrow position', 'c->base[0] = sub32(sub32(c->base[0], gap_half), w / 2);', 'c->base[0] = sub32(add32(c->base[0], gap_half), w / 2);')
k('setup left arrow without the gap', 'c->base[0] = sub32(sub32(c->base[0], gap_half), w / 2);', 'c->base[0] = sub32(c->base[0], w / 2);')
k('setup left arrow width half', 'c->base[0] = sub32(sub32(c->base[0], gap_half), w / 2);', 'c->base[0] = sub32(sub32(c->base[0], gap_half), w);')
k('setup left arrow width half shifts', 'c->base[0] = sub32(sub32(c->base[0], gap_half), w / 2);', 'c->base[0] = sub32(sub32(c->base[0], gap_half), w >> 1);')
k('setup right arrow position', 'c->base[0] = sub32(add32(c->base[2], gap_half), w / 2);', 'c->base[0] = sub32(sub32(c->base[2], gap_half), w / 2);')
k('setup right arrow from the left edge', 'c->base[0] = sub32(add32(c->base[2], gap_half), w / 2);', 'c->base[0] = sub32(add32(c->base[0], gap_half), w / 2);')
k('setup right arrow without the gap', 'c->base[0] = sub32(add32(c->base[2], gap_half), w / 2);', 'c->base[0] = sub32(c->base[2], w / 2);')
k('setup right arrow width half shifts', 'c->base[0] = sub32(add32(c->base[2], gap_half), w / 2);', 'c->base[0] = sub32(add32(c->base[2], gap_half), w >> 1);')
k('setup horizontal arrow right edge', 'c->base[2] = add32(c->base[0], w);\n                    break;', 'c->base[2] = add32(c->base[2], w);\n                    break;')
k('setup horizontal arrow width kept', 'c->base[2] = add32(c->base[0], w);\n                    break;', 'break;')
k('setup left arrow is the right one', 'if (c->type == CPZ_DIR_LEFT) {\n                        c->base[0]', 'if (c->type == CPZ_DIR_RIGHT) {\n                        c->base[0]')
k('setup vertical arrow width', 'const int32_t w = sub32(rd_s32(body, B_ARROW_V + 8), rd_s32(body, B_ARROW_V));', 'const int32_t w = sub32(rd_s32(body, B_ARROW_V + 8), rd_s32(body, B_ARROW_V + 4));')
k('setup vertical arrow height', 'const int32_t h = sub32(rd_s32(body, B_ARROW_V + 12), rd_s32(body, B_ARROW_V + 4));', 'const int32_t h = sub32(rd_s32(body, B_ARROW_V + 12), rd_s32(body, B_ARROW_V));')
k('setup vertical arrow offset', 'const int32_t off = sub32(o->cell_w, w) / 2;', 'const int32_t off = sub32(o->cell_w, w);')
k('setup vertical arrow offset shifts', 'const int32_t off = sub32(o->cell_w, w) / 2;', 'const int32_t off = sub32(o->cell_w, w) >> 1;')
k('setup vertical arrow offset uses the height', 'const int32_t off = sub32(o->cell_w, w) / 2;', 'const int32_t off = sub32(o->cell_h, w) / 2;')
k('setup vertical arrow left', 'c->base[0] = add32(c->base[0], off);\n                    c->base[2] = sub32(c->base[2], off);', 'c->base[0] = sub32(c->base[0], off);\n                    c->base[2] = sub32(c->base[2], off);')
k('setup vertical arrow right', 'c->base[0] = add32(c->base[0], off);\n                    c->base[2] = sub32(c->base[2], off);', 'c->base[0] = add32(c->base[0], off);\n                    c->base[2] = add32(c->base[2], off);')
k('setup up arrow position', 'c->base[1] = sub32(sub32(c->base[1], gap_half), h / 2);', 'c->base[1] = sub32(add32(c->base[1], gap_half), h / 2);')
k('setup up arrow without the gap', 'c->base[1] = sub32(sub32(c->base[1], gap_half), h / 2);', 'c->base[1] = sub32(c->base[1], h / 2);')
k('setup up arrow height half', 'c->base[1] = sub32(sub32(c->base[1], gap_half), h / 2);', 'c->base[1] = sub32(sub32(c->base[1], gap_half), h);')
k('setup up arrow height half shifts', 'c->base[1] = sub32(sub32(c->base[1], gap_half), h / 2);', 'c->base[1] = sub32(sub32(c->base[1], gap_half), h >> 1);')
k('setup down arrow position', 'c->base[1] = sub32(add32(c->base[3], gap_half), h / 2);', 'c->base[1] = sub32(sub32(c->base[3], gap_half), h / 2);')
k('setup down arrow from the top edge', 'c->base[1] = sub32(add32(c->base[3], gap_half), h / 2);', 'c->base[1] = sub32(add32(c->base[1], gap_half), h / 2);')
k('setup down arrow without the gap', 'c->base[1] = sub32(add32(c->base[3], gap_half), h / 2);', 'c->base[1] = sub32(c->base[3], h / 2);')
k('setup down arrow height half shifts', 'c->base[1] = sub32(add32(c->base[3], gap_half), h / 2);', 'c->base[1] = sub32(add32(c->base[3], gap_half), h >> 1);')
k('setup vertical arrow bottom edge', 'c->base[3] = add32(c->base[1], h);\n                    break;', 'c->base[3] = add32(c->base[3], h);\n                    break;')
k('setup vertical arrow height kept', 'c->base[3] = add32(c->base[1], h);\n                    break;', 'break;')
k('setup up arrow is the down one', 'if (c->type == CPZ_DIR_UP) {\n                        c->base[1]', 'if (c->type == CPZ_DIR_DOWN) {\n                        c->base[1]')
k('setup left and right arrows differ in type', 'case CPZ_DIR_LEFT:\n                case CPZ_DIR_RIGHT: {', 'case CPZ_DIR_LEFT: {')
k('setup right arrow dropped from the case', 'case CPZ_DIR_LEFT:\n                case CPZ_DIR_RIGHT: {', 'case CPZ_DIR_RIGHT: {')
k('setup down arrow dropped from the case', 'case CPZ_DIR_UP:\n                case CPZ_DIR_DOWN: {', 'case CPZ_DIR_UP: {')
k('setup up arrow dropped from the case', 'case CPZ_DIR_UP:\n                case CPZ_DIR_DOWN: {', 'case CPZ_DIR_DOWN: {')
k('setup pieces inclusive', 'for (int16_t k = 0; k < pieces; ++k) {', 'for (int16_t k = 0; k <= pieces && k < CPZ_PIECES_MAX; ++k) {')
k('setup pieces off by one', 'for (int16_t k = 0; k < pieces; ++k) {', 'for (int16_t k = 0; k + 1 < pieces; ++k) {')
k('setup piece start swapped', 'rd_s16(body, B_START + (size_t)k * 4u) == b && rd_s16(body, B_START + 2u + (size_t)k * 4u) == a',
  'rd_s16(body, B_START + (size_t)k * 4u) == a && rd_s16(body, B_START + 2u + (size_t)k * 4u) == b')
k('setup piece column ignored', 'rd_s16(body, B_START + (size_t)k * 4u) == b && rd_s16(body, B_START + 2u + (size_t)k * 4u) == a', 'rd_s16(body, B_START + 2u + (size_t)k * 4u) == a')
k('setup piece row ignored', 'rd_s16(body, B_START + (size_t)k * 4u) == b && rd_s16(body, B_START + 2u + (size_t)k * 4u) == a', 'rd_s16(body, B_START + (size_t)k * 4u) == b')
k('setup piece stride', 'B_START + (size_t)k * 4u) == b', 'B_START + (size_t)k * 2u) == b')
k('setup piece row stride', 'B_START + 2u + (size_t)k * 4u) == a', 'B_START + 2u + (size_t)k * 2u) == a')
k('setup piece not visible', 'c->visible = 1;\n                    c->piece = (int16_t)(k + 1);', 'c->piece = (int16_t)(k + 1);')
k('setup piece number', 'c->piece = (int16_t)(k + 1);', 'c->piece = k;')
k('setup first piece wins', 'c->piece = (int16_t)(k + 1);\n                }', 'c->piece = c->piece != 0 ? c->piece : (int16_t)(k + 1);\n                }')
# --- the cell type test and the move check (0x461d4b, 0x4619be) -----------------------------------------------------------------
k('type test inverted', 'return world->cell[a][b].type == piece;', 'return world->cell[a][b].type != piece;')
k('type test transposed', 'return world->cell[a][b].type == piece;', 'return world->cell[b][a].type == piece;')
k('type test on the piece slot', 'return world->cell[a][b].type == piece;', 'return world->cell[a][b].piece == piece;')
k('move check direction not stored', 'int ok = 1;\n    o->dir = dir;', 'int ok = 1;')
k('move check left edge', 'if (b == 0) ok = 0;', 'if (b == 1) ok = 0;')
k('move check left edge missing', 'if (b == 0) ok = 0;\n        else if', 'if (0) ok = 0;\n        else if')
k('move check left own arrow', 'world->cell[a][b].type == CPZ_DIR_LEFT || world->cell[a][b - 1].type == CPZ_DIR_RIGHT', 'world->cell[a][b].type == CPZ_DIR_RIGHT || world->cell[a][b - 1].type == CPZ_DIR_RIGHT')
k('move check left own arrow missing', 'world->cell[a][b].type == CPZ_DIR_LEFT || world->cell[a][b - 1].type == CPZ_DIR_RIGHT', '0 || world->cell[a][b - 1].type == CPZ_DIR_RIGHT')
k('move check left neighbor arrow', 'world->cell[a][b - 1].type == CPZ_DIR_RIGHT ||', 'world->cell[a][b - 1].type == CPZ_DIR_LEFT ||')
k('move check left neighbor arrow missing', 'world->cell[a][b - 1].type == CPZ_DIR_RIGHT ||', '0 ||')
k('move check left neighbor piece', 'world->cell[a][b - 1].piece != 0 ||', 'world->cell[a][b - 1].piece == 0 ||')
k('move check left neighbor piece missing', 'world->cell[a][b - 1].piece != 0 ||', '0 ||')
k('move check left neighbor wall', 'world->cell[a][b - 1].type == CPZ_CELL_WALL)', 'world->cell[a][b - 1].type == CPZ_DIR_RIGHT)')
k('move check left neighbor wall missing', 'world->cell[a][b - 1].type == CPZ_CELL_WALL)', '0)')
k('move check left neighbor is the column', 'world->cell[a][b - 1].piece != 0 ||', 'world->cell[a][b + 1].piece != 0 ||')
k('move check up edge', 'if (a == 0) ok = 0;', 'if (a == 1) ok = 0;')
k('move check up edge missing', 'if (a == 0) ok = 0;\n        else if', 'if (0) ok = 0;\n        else if')
k('move check up own arrow', 'world->cell[a][b].type == CPZ_DIR_UP || world->cell[a - 1][b].type == CPZ_DIR_DOWN', 'world->cell[a][b].type == CPZ_DIR_DOWN || world->cell[a - 1][b].type == CPZ_DIR_DOWN')
k('move check up own arrow missing', 'world->cell[a][b].type == CPZ_DIR_UP || world->cell[a - 1][b].type == CPZ_DIR_DOWN', '0 || world->cell[a - 1][b].type == CPZ_DIR_DOWN')
k('move check up neighbor arrow', 'world->cell[a - 1][b].type == CPZ_DIR_DOWN ||', 'world->cell[a - 1][b].type == CPZ_DIR_UP ||')
k('move check up neighbor arrow missing', 'world->cell[a - 1][b].type == CPZ_DIR_DOWN ||', '0 ||')
k('move check up neighbor piece', 'world->cell[a - 1][b].piece != 0 ||', 'world->cell[a - 1][b].piece == 0 ||')
k('move check up neighbor piece missing', 'world->cell[a - 1][b].piece != 0 ||', '0 ||')
k('move check up neighbor wall', 'world->cell[a - 1][b].type == CPZ_CELL_WALL)', 'world->cell[a - 1][b].type == CPZ_DIR_DOWN)')
k('move check up neighbor wall missing', 'world->cell[a - 1][b].type == CPZ_CELL_WALL)', '0)')
k('move check down edge', 'if (a == rd_s16(body, B_ROWS) - 1) ok = 0;', 'if (a == rd_s16(body, B_ROWS) - 2) ok = 0;')
k('move check down edge from the columns', 'if (a == rd_s16(body, B_ROWS) - 1) ok = 0;', 'if (a == rd_s16(body, B_COLS) - 1) ok = 0;')
k('move check down edge missing', 'if (a == rd_s16(body, B_ROWS) - 1) ok = 0;', 'if (0) ok = 0;')
k('move check down edge one late', 'if (a == rd_s16(body, B_ROWS) - 1) ok = 0;', 'if (a == rd_s16(body, B_ROWS)) ok = 0;')
k('move check down own arrow', 'world->cell[a][b].type == CPZ_DIR_DOWN || world->cell[a + 1][b].type == CPZ_DIR_UP', 'world->cell[a][b].type == CPZ_DIR_UP || world->cell[a + 1][b].type == CPZ_DIR_UP')
k('move check down own arrow missing', 'world->cell[a][b].type == CPZ_DIR_DOWN || world->cell[a + 1][b].type == CPZ_DIR_UP', '0 || world->cell[a + 1][b].type == CPZ_DIR_UP')
k('move check down neighbor arrow', 'world->cell[a + 1][b].type == CPZ_DIR_UP ||', 'world->cell[a + 1][b].type == CPZ_DIR_DOWN ||')
k('move check down neighbor arrow missing', 'world->cell[a + 1][b].type == CPZ_DIR_UP ||', '0 ||')
k('move check down neighbor piece', 'world->cell[a + 1][b].piece != 0 ||', 'world->cell[a + 1][b].piece == 0 ||')
k('move check down neighbor piece missing', 'world->cell[a + 1][b].piece != 0 ||', '0 ||')
k('move check down neighbor wall', 'world->cell[a + 1][b].type == CPZ_CELL_WALL)', 'world->cell[a + 1][b].type == CPZ_DIR_UP)')
k('move check down neighbor wall missing', 'world->cell[a + 1][b].type == CPZ_CELL_WALL)', '0)')
k('move check right edge', 'if (b == rd_s16(body, B_COLS) - 1) ok = 0;', 'if (b == rd_s16(body, B_COLS) - 2) ok = 0;')
k('move check right edge from the rows', 'if (b == rd_s16(body, B_COLS) - 1) ok = 0;', 'if (b == rd_s16(body, B_ROWS) - 1) ok = 0;')
k('move check right edge missing', 'if (b == rd_s16(body, B_COLS) - 1) ok = 0;', 'if (0) ok = 0;')
k('move check right edge one late', 'if (b == rd_s16(body, B_COLS) - 1) ok = 0;', 'if (b == rd_s16(body, B_COLS)) ok = 0;')
k('move check right own arrow', 'world->cell[a][b].type == CPZ_DIR_RIGHT || world->cell[a][b + 1].type == CPZ_DIR_LEFT', 'world->cell[a][b].type == CPZ_DIR_LEFT || world->cell[a][b + 1].type == CPZ_DIR_LEFT')
k('move check right own arrow missing', 'world->cell[a][b].type == CPZ_DIR_RIGHT || world->cell[a][b + 1].type == CPZ_DIR_LEFT', '0 || world->cell[a][b + 1].type == CPZ_DIR_LEFT')
k('move check right neighbor arrow', 'world->cell[a][b + 1].type == CPZ_DIR_LEFT ||', 'world->cell[a][b + 1].type == CPZ_DIR_RIGHT ||')
k('move check right neighbor arrow missing', 'world->cell[a][b + 1].type == CPZ_DIR_LEFT ||', '0 ||')
k('move check right neighbor piece', 'world->cell[a][b + 1].piece != 0 ||', 'world->cell[a][b + 1].piece == 0 ||')
k('move check right neighbor piece missing', 'world->cell[a][b + 1].piece != 0 ||', '0 ||')
k('move check right neighbor wall', 'world->cell[a][b + 1].type == CPZ_CELL_WALL)', 'world->cell[a][b + 1].type == CPZ_DIR_LEFT)')
k('move check right neighbor wall missing', 'world->cell[a][b + 1].type == CPZ_CELL_WALL)', '0)')
k('move check refusal keeps the piece', 'o->piece = 0;\n        o->dir = 0;\n        o->step = 0;\n    }\n    return ok;', 'o->dir = 0;\n        o->step = 0;\n    }\n    return ok;')
k('move check refusal keeps the direction', 'o->piece = 0;\n        o->dir = 0;\n        o->step = 0;\n    }\n    return ok;', 'o->piece = 0;\n        o->step = 0;\n    }\n    return ok;')
k('move check refusal keeps the step', 'o->piece = 0;\n        o->dir = 0;\n        o->step = 0;\n    }\n    return ok;', 'o->piece = 0;\n        o->dir = 0;\n    }\n    return ok;')
k('move check refusal always', 'if (!ok) {\n        o->piece = 0;', 'if (1) {\n        o->piece = 0;')
k('move check result inverted', 'o->step = 0;\n    }\n    return ok;', 'o->step = 0;\n    }\n    return !ok;')
k('move check position from the wrong fields', 'const int16_t a = o->at_row, b = o->at_col;', 'const int16_t a = o->at_col, b = o->at_row;')
# --- one animation step (0x461d82) ---------------------------------------------------------------------------------------------
k('step does not save the rectangle', 'memcpy(o->saved, c->rect, sizeof(o->saved));\n    switch (o->dir) {', 'switch (o->dir) {')
k('step saves after the move', 'memcpy(o->saved, c->rect, sizeof(o->saved));\n    switch (o->dir) {', 'switch (o->dir) {')
k('step cell from the wrong fields', 'CpzCell *c = &world->cell[o->at_row][o->at_col];\n    int arrived = 0;', 'CpzCell *c = &world->cell[o->at_col][o->at_row];\n    int arrived = 0;')
k('step left moves right', 'c->rect[0] = o->dir == CPZ_DIR_LEFT ? sub32(c->rect[0], o->cell_w / steps) : add32(c->rect[0], o->cell_w / steps);',
  'c->rect[0] = o->dir == CPZ_DIR_LEFT ? add32(c->rect[0], o->cell_w / steps) : add32(c->rect[0], o->cell_w / steps);')
k('step right moves left', 'c->rect[0] = o->dir == CPZ_DIR_LEFT ? sub32(c->rect[0], o->cell_w / steps) : add32(c->rect[0], o->cell_w / steps);',
  'c->rect[0] = o->dir == CPZ_DIR_LEFT ? sub32(c->rect[0], o->cell_w / steps) : sub32(c->rect[0], o->cell_w / steps);')
k('step horizontal division rounds up', 'sub32(c->rect[0], o->cell_w / steps)', 'sub32(c->rect[0], (o->cell_w + steps - 1) / steps)')
k('step horizontal division by one less', 'add32(c->rect[0], o->cell_w / steps);\n        c->rect[2]', 'add32(c->rect[0], o->cell_w / (steps > 1 ? steps - 1 : steps));\n        c->rect[2]')
k('step horizontal by the height', 'add32(c->rect[0], o->cell_w / steps);\n        c->rect[2]', 'add32(c->rect[0], o->cell_h / steps);\n        c->rect[2]')
k('step horizontal right edge', 'c->rect[2] = add32(c->rect[0], o->cell_w);\n        break;', 'c->rect[2] = add32(c->rect[2], o->cell_w / steps);\n        break;')
k('step horizontal right edge kept', 'c->rect[2] = add32(c->rect[0], o->cell_w);\n        break;', 'break;')
k('step up moves down', 'c->rect[1] = o->dir == CPZ_DIR_UP ? sub32(c->rect[1], o->cell_h / steps) : add32(c->rect[1], o->cell_h / steps);',
  'c->rect[1] = o->dir == CPZ_DIR_UP ? add32(c->rect[1], o->cell_h / steps) : add32(c->rect[1], o->cell_h / steps);')
k('step down moves up', 'c->rect[1] = o->dir == CPZ_DIR_UP ? sub32(c->rect[1], o->cell_h / steps) : add32(c->rect[1], o->cell_h / steps);',
  'c->rect[1] = o->dir == CPZ_DIR_UP ? sub32(c->rect[1], o->cell_h / steps) : sub32(c->rect[1], o->cell_h / steps);')
k('step vertical division rounds up', 'sub32(c->rect[1], o->cell_h / steps)', 'sub32(c->rect[1], (o->cell_h + steps - 1) / steps)')
k('step vertical by the width', 'add32(c->rect[1], o->cell_h / steps);\n        c->rect[3]', 'add32(c->rect[1], o->cell_w / steps);\n        c->rect[3]')
k('step vertical bottom edge', 'c->rect[3] = add32(c->rect[1], o->cell_h);\n        break;', 'c->rect[3] = add32(c->rect[3], o->cell_h / steps);\n        break;')
k('step vertical bottom edge kept', 'c->rect[3] = add32(c->rect[1], o->cell_h);\n        break;', 'break;')
k('step steps from the wrong word', 'const int32_t steps = rd_s16(body, B_STEPS);', 'const int32_t steps = rd_s16(body, B_GAP);')
k('step counter not advanced', 'o->step = (int16_t)(o->step + 1);\n    if (o->step == rd_s16(body, B_STEPS)) {', 'if (o->step == rd_s16(body, B_STEPS)) {')
k('step counter advanced by two', 'o->step = (int16_t)(o->step + 1);', 'o->step = (int16_t)(o->step + 2);')
k('step arrival one tick early', 'if (o->step == rd_s16(body, B_STEPS)) {', 'if (o->step == rd_s16(body, B_STEPS) - 1) {')
k('step arrival one tick late', 'if (o->step == rd_s16(body, B_STEPS)) {', 'if (o->step == rd_s16(body, B_STEPS) + 1) {')
k('step arrival never', 'if (o->step == rd_s16(body, B_STEPS)) {', 'if (0) {')
k('step arrival compares the wrong word', 'if (o->step == rd_s16(body, B_STEPS)) {', 'if (o->step == rd_s16(body, B_GAP)) {')
k('step old cell keeps the piece', 'c->piece = 0;\n        if (c->type == 0) c->visible = 0;', 'if (c->type == 0) c->visible = 0;')
k('step old cell stays visible', 'if (c->type == 0) c->visible = 0;', '(void)0;')
k('step old typed cell hidden', 'if (c->type == 0) c->visible = 0;', 'c->visible = 0;')
k('step old cell hidden for positive types', 'if (c->type == 0) c->visible = 0;', 'if (c->type <= 0) c->visible = 0;')
k('step old cell rectangle kept', 'cell_rect(o, body, view_x, view_y, o->at_row, o->at_col, c->rect);\n        switch (o->dir) {', 'switch (o->dir) {')
k('step old cell rectangle with the wrong origin', 'cell_rect(o, body, view_x, view_y, o->at_row, o->at_col, c->rect);', 'cell_rect(o, body, view_y, view_x, o->at_row, o->at_col, c->rect);')
k('step left does not move the column', 'case CPZ_DIR_LEFT: o->at_col = (int16_t)(o->at_col - 1); break;', 'case CPZ_DIR_LEFT: break;')
k('step left moves two columns', 'case CPZ_DIR_LEFT: o->at_col = (int16_t)(o->at_col - 1); break;', 'case CPZ_DIR_LEFT: o->at_col = (int16_t)(o->at_col - 2); break;')
k('step up does not move the row', 'case CPZ_DIR_UP: o->at_row = (int16_t)(o->at_row - 1); break;', 'case CPZ_DIR_UP: break;')
k('step up moves a column', 'case CPZ_DIR_UP: o->at_row = (int16_t)(o->at_row - 1); break;', 'case CPZ_DIR_UP: o->at_col = (int16_t)(o->at_col - 1); break;')
k('step down does not move the row', 'case CPZ_DIR_DOWN: o->at_row = (int16_t)(o->at_row + 1); break;', 'case CPZ_DIR_DOWN: break;')
k('step down case moves up', 'case CPZ_DIR_DOWN: o->at_row = (int16_t)(o->at_row + 1); break;', 'case CPZ_DIR_DOWN: o->at_row = (int16_t)(o->at_row - 1); break;')
k('step right case moves left', 'default: o->at_col = (int16_t)(o->at_col + 1); break;', 'default: o->at_col = (int16_t)(o->at_col - 1); break;')
k('step right does not move', 'default: o->at_col = (int16_t)(o->at_col + 1); break;', 'default: break;')
k('step new cell not occupied', 'c->piece = o->piece;\n        c->visible = 1;', 'c->visible = 1;')
k('step new cell not visible', 'c->piece = o->piece;\n        c->visible = 1;', 'c->piece = o->piece;')
k('step new cell is the old one', 'c = &world->cell[o->at_row][o->at_col];\n        c->piece = o->piece;', 'c->piece = o->piece;')
k('step counter not reset', 'c->visible = 1;\n        o->step = 0;', 'c->visible = 1;')
k('step arrival not reported', 'c->visible = 1;\n        o->step = 0;\n        arrived = 1;', 'c->visible = 1;\n        o->step = 0;')
k('step moved flag not set', 'arrived = 1;\n        o->moved = 1;', 'arrived = 1;')
k('step moved flag set every tick', 'o->step = (int16_t)(o->step + 1);\n    if', 'o->step = (int16_t)(o->step + 1);\n    o->moved = 1;\n    if')
k('step without a direction moves', 'default:\n        return 0;\n    }\n    o->step', 'default:\n        break;\n    }\n    o->step')
# --- the solved scan (0x4632bf) -------------------------------------------------------------------------------------------------
k('scan rows inclusive', 'for (int16_t a = 0; a < rows; ++a)\n        for (int16_t b = 0; b < cols; ++b)\n            if (world->cell[a][b].piece != 0 && !type_is', 'for (int16_t a = 0; a <= rows && a < CPZ_GRID_MAX; ++a)\n        for (int16_t b = 0; b < cols; ++b)\n            if (world->cell[a][b].piece != 0 && !type_is')
k('scan columns inclusive', 'for (int16_t b = 0; b < cols; ++b)\n            if (world->cell[a][b].piece != 0 && !type_is', 'for (int16_t b = 0; b <= cols && b < CPZ_GRID_MAX; ++b)\n            if (world->cell[a][b].piece != 0 && !type_is')
k('scan rows stop one early', 'for (int16_t a = 0; a < rows; ++a)\n        for (int16_t b = 0; b < cols; ++b)\n            if (world->cell[a][b].piece != 0 && !type_is', 'for (int16_t a = 0; a + 1 < rows; ++a)\n        for (int16_t b = 0; b < cols; ++b)\n            if (world->cell[a][b].piece != 0 && !type_is')
k('scan columns stop one early', 'for (int16_t b = 0; b < cols; ++b)\n            if (world->cell[a][b].piece != 0 && !type_is', 'for (int16_t b = 0; b + 1 < cols; ++b)\n            if (world->cell[a][b].piece != 0 && !type_is')
k('scan empty cells fail', 'if (world->cell[a][b].piece != 0 && !type_is', 'if (!type_is')
k('scan ignores the type', 'if (world->cell[a][b].piece != 0 && !type_is(world, world->cell[a][b].piece, a, b)) return;', 'if (world->cell[a][b].piece != 0 && 0) return;')
k('scan compares the cell number', 'if (world->cell[a][b].piece != 0 && !type_is(world, world->cell[a][b].piece, a, b)) return;', 'if (world->cell[a][b].piece != 0 && !type_is(world, 1, a, b)) return;')
k('scan stops at the first match', 'if (world->cell[a][b].piece != 0 && !type_is(world, world->cell[a][b].piece, a, b)) return;', 'if (world->cell[a][b].piece != 0 && type_is(world, world->cell[a][b].piece, a, b)) return;')
k('scan rows from the columns', 'const int16_t rows = rd_s16(body, B_ROWS), cols = rd_s16(body, B_COLS);\n    for (int16_t a = 0; a < rows; ++a)\n        for', 'const int16_t rows = rd_s16(body, B_COLS), cols = rd_s16(body, B_COLS);\n    for (int16_t a = 0; a < rows; ++a)\n        for')
k('scan does not mark solved', 'o->solved = 1;\n    o->state = CPZ_STATE_SOLVED;\n    fx(host, CPZ_FX_STATE', 'o->state = CPZ_STATE_SOLVED;\n    fx(host, CPZ_FX_STATE')
k('scan does not change state', 'o->solved = 1;\n    o->state = CPZ_STATE_SOLVED;\n    fx(host, CPZ_FX_STATE', 'o->solved = 1;\n    fx(host, CPZ_FX_STATE')
k('scan state wrong', 'o->solved = 1;\n    o->state = CPZ_STATE_SOLVED;', 'o->solved = 1;\n    o->state = CPZ_STATE_WAIT_DELAY;')
k('scan state not announced', 'o->state = CPZ_STATE_SOLVED;\n    fx(host, CPZ_FX_STATE, o->state, 0);\n}', 'o->state = CPZ_STATE_SOLVED;\n}')
# --- the finish blocks ---------------------------------------------------------------------------------------------------------
k('block scene test inverted', 'if (rd_s16(blk, SB_SCENE) != CPZ_NO_SCENE) {', 'if (rd_s16(blk, SB_SCENE) == CPZ_NO_SCENE) {')
k('block scene sentinel', 'if (rd_s16(blk, SB_SCENE) != CPZ_NO_SCENE) {', 'if (rd_s16(blk, SB_SCENE) != 9998) {')
k('block scene always', 'if (rd_s16(blk, SB_SCENE) != CPZ_NO_SCENE) {', 'if (1) {')
k('block scene from the wrong word', 't.scene = rd_s16(blk, SB_SCENE);', 't.scene = rd_s16(blk, SB_W1);')
k('block scene unsigned', 't.scene = rd_s16(blk, SB_SCENE);', 't.scene = (int16_t)(rd_s16(blk, SB_SCENE) & 0x7fff);')
k('block word 1 from word 2', 't.word[0] = rd_s16(blk, SB_W1);', 't.word[0] = rd_s16(blk, SB_W2);')
k('block word 2 from word 3', 't.word[1] = rd_s16(blk, SB_W2);', 't.word[1] = rd_s16(blk, SB_W3);')
k('block word 3 from word 1', 't.word[2] = rd_s16(blk, SB_W3);', 't.word[2] = rd_s16(blk, SB_W1);')
k('block dword 1 from dword 2', 't.dword[0] = rd_s32(blk, SB_D1);', 't.dword[0] = rd_s32(blk, SB_D2);')
k('block dword 2 from dword 3', 't.dword[1] = rd_s32(blk, SB_D2);', 't.dword[1] = rd_s32(blk, SB_D3);')
k('block dword 3 from dword 1', 't.dword[2] = rd_s32(blk, SB_D3);', 't.dword[2] = rd_s32(blk, SB_D1);')
k('block transition failure ignored', 'HOST(host->transition(host->context, &t));', '(void)host->transition(host->context, &t);')
k('block transition lost', 'HOST(host->transition(host->context, &t));', '(void)0;')
k('block scene effect lost', 'fx(host, CPZ_FX_XFER_5BB57B, t.scene, 0);', '(void)0;')
k('block word 1 effect lost', 'fx(host, CPZ_FX_XFER_5BB599, t.word[0], 0);', '(void)0;')
k('block word 2 effect lost', 'fx(host, CPZ_FX_XFER_5BB595, t.word[1], 0);', '(void)0;')
k('block word 3 effect lost', 'fx(host, CPZ_FX_XFER_5C39FF, t.word[2], 0);', '(void)0;')
k('block dword 1 effect lost', 'fx(host, CPZ_FX_XFER_5BB59B, t.dword[0], 0);', '(void)0;')
k('block dword 2 effect lost', 'fx(host, CPZ_FX_XFER_5BB59F, t.dword[1], 0);', '(void)0;')
k('block dword 3 effect lost', 'fx(host, CPZ_FX_XFER_5BB5A3, t.dword[2], 0);', '(void)0;')
k('block start flag stores 1 for 1', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) == 1 ? 1 : 0;')
k('block start flag stores 0 for 0', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 0 ? 1 : 0;')
k('block start flag from the wrong word', 'rd_s16(blk, SB_START) != 1', 'rd_s16(blk, SB_FLAG) != 1')
k('block start flag stored raw', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START);')
k('block start flag not announced', 'fx(host, CPZ_FX_START_FLAG, world->start_flag_5bb1ca, 0);', '(void)0;')
k('block start flag not stored', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;\n', '')
k('block engine mode not announced', 'fx(host, CPZ_FX_ENGINE_MODE, 4, 0);', '(void)0;')
k('block engine mode wrong', 'fx(host, CPZ_FX_ENGINE_MODE, 4, 0);', 'fx(host, CPZ_FX_ENGINE_MODE, 3, 0);')
k('block flag 0 is none', 'if (flag != CPZ_NO_FLAG) {', 'if (flag > 0) {')
k('block flag -1 is a flag', 'if (flag != CPZ_NO_FLAG) {', 'if (1) {')
k('block flag -2 is none', 'if (flag != CPZ_NO_FLAG) {', 'if (flag >= -1 || flag < -2) {')
k('block flag from the wrong word', 'const int16_t flag = rd_s16(blk, SB_FLAG);\n        if (flag != CPZ_NO_FLAG) {', 'const int16_t flag = rd_s16(blk, SB_START);\n        if (flag != CPZ_NO_FLAG) {')
k('block flag value wrong', 'store_event_flag(host->context, flag, blk[SB_VALUE])', 'store_event_flag(host->context, flag, blk[SB_VALUE] + 1u)')
k('block flag value signed', 'store_event_flag(host->context, flag, blk[SB_VALUE])', 'store_event_flag(host->context, flag, (uint32_t)(int8_t)blk[SB_VALUE])')
k('block flag value from the wrong byte', 'store_event_flag(host->context, flag, blk[SB_VALUE])', 'store_event_flag(host->context, flag, blk[SB_VALUE - 1])')
k('block flag store failure ignored', 'HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE]));', '(void)host->store_event_flag(host->context, flag, blk[SB_VALUE]);')
k('block flag store lost', 'HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE]));', '(void)0;')
k('block flag not announced', 'fx(host, CPZ_FX_EVENT_FLAG, flag, blk[SB_VALUE]);', '(void)0;')
# --- phase 0 (0x4633d8) --------------------------------------------------------------------------------------------------------
k('phase 0 row not stored', 'o->row = row;\n    o->active = 1;', 'o->active = 1;')
k('phase 0 not active', 'o->active = 1;\n    fx(host, CPZ_FX_ACTIVE, 1, 0);', 'fx(host, CPZ_FX_ACTIVE, 1, 0);')
k('phase 0 active not announced', 'fx(host, CPZ_FX_ACTIVE, 1, 0);', '(void)0;')
k('phase 0 start flag not set', 'world->start_flag_5bb1ca = 1;\n    fx(host, CPZ_FX_START_FLAG, 1, 0);\n    if (body[B_PERSIST]', 'fx(host, CPZ_FX_START_FLAG, 1, 0);\n    if (body[B_PERSIST]')
k('phase 0 start flag not announced', 'fx(host, CPZ_FX_START_FLAG, 1, 0);\n    if (body[B_PERSIST]', 'if (body[B_PERSIST]')
k('phase 0 persist test inverted', 'if (body[B_PERSIST] == 0) {', 'if (body[B_PERSIST] != 0) {')
k('phase 0 persist one resets', 'if (body[B_PERSIST] == 0) {', 'if (body[B_PERSIST] <= 1) {')
k('phase 0 persist only one keeps', 'if (body[B_PERSIST] == 0) {', 'if (body[B_PERSIST] != 1) {')
k('phase 0 always resets', 'if (body[B_PERSIST] == 0) {', 'if (1) {')
k('phase 0 never resets', 'if (body[B_PERSIST] == 0) {', 'if (0) {')
k('phase 0 persist from the wrong byte', 'if (body[B_PERSIST] == 0) {', 'if (body[B_PERSIST + 1] == 0) {')
k('phase 0 reset not performed', 'cpz_grid_reset(world);\n        fx(host, CPZ_FX_GRID_RESET, 0, 0);', 'fx(host, CPZ_FX_GRID_RESET, 0, 0);')
k('phase 0 reset not announced', 'fx(host, CPZ_FX_GRID_RESET, 0, 0);', '(void)0;')
k('phase 0 item not cleared', 'HOST(host->clear_pending_item(host->context));\n    fx(host, CPZ_FX_CLEAR_ITEM, 0, 0);', 'fx(host, CPZ_FX_CLEAR_ITEM, 0, 0);')
k('phase 0 item clear not announced', 'fx(host, CPZ_FX_CLEAR_ITEM, 0, 0);', '(void)0;')
k('phase 0 cell width', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC));', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC + 4));')
k('phase 0 cell width of the second piece', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC));', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 24), rd_s32(body, B_PIECE_SRC + 16));')
k('phase 0 cell width reversed', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC));', 'o->cell_w = sub32(rd_s32(body, B_PIECE_SRC), rd_s32(body, B_PIECE_SRC + 8));')
k('phase 0 cell height', 'o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC + 4));', 'o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC));')
k('phase 0 cell height reversed', 'o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC + 4));', 'o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 4), rd_s32(body, B_PIECE_SRC + 12));')
k('phase 0 cell size after the setup', 'o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC + 4));\n    HOST(host->view_origin', 'HOST(host->view_origin')
k('phase 0 setup not run', 'grid_setup(o, body, world, view_x, view_y);\n        fx(host, CPZ_FX_GRID_SETUP, ran, 0);', 'fx(host, CPZ_FX_GRID_SETUP, ran, 0);')
k('phase 0 setup ran flag inverted', 'const int ran = world->grid_ready == 0;', 'const int ran = world->grid_ready != 0;')
k('phase 0 setup ran flag taken after', 'const int ran = world->grid_ready == 0;\n        grid_setup(o, body, world, view_x, view_y);', 'grid_setup(o, body, world, view_x, view_y);\n        const int ran = world->grid_ready == 0;')
k('phase 0 setup not announced', 'fx(host, CPZ_FX_GRID_SETUP, ran, 0);', '(void)0;')
k('phase 0 setup with the swapped origin', 'grid_setup(o, body, world, view_x, view_y);\n        fx', 'grid_setup(o, body, world, view_y, view_x);\n        fx')
k('phase 0 flag 28 not set', 'o->flag28 = 1;', '(void)0;')
k('phase 0 slot not stored', 'o->slot = slot;\n        fx(host, CPZ_FX_SLOT, slot, 0);', 'fx(host, CPZ_FX_SLOT, slot, 0);')
k('phase 0 slot not announced', 'fx(host, CPZ_FX_SLOT, slot, 0);', '(void)0;')
k('phase 0 label wrong', '"COLLISION PUZZLE OVERLAYS"));', '"COLLISION PUZZLE"));')
k('phase 0 register slot wrong', 'host->register_slot(host->context, slot, "COLLISION PUZZLE OVERLAYS")', 'host->register_slot(host->context, 0, "COLLISION PUZZLE OVERLAYS")')
k('phase 0 register not announced', 'fx(host, CPZ_FX_SLOT_REGISTER, slot, 0);', '(void)0;')
k('phase 0 surface test inverted', 'if (o->surface == 0u) {\n            uint32_t surface = 0;', 'if (o->surface != 0u) {\n            uint32_t surface = 0;')
k('phase 0 surface always loaded', 'if (o->surface == 0u) {\n            uint32_t surface = 0;', 'if (1) {\n            uint32_t surface = 0;')
k('phase 0 loads the wrong name', 'host->load_surface(host->context, (const char *)body, &surface)', 'host->load_surface(host->context, (const char *)body + 1, &surface)')
k('phase 0 surface not stored', 'o->surface = surface;\n            fx(host, CPZ_FX_SURFACE_LOAD', 'fx(host, CPZ_FX_SURFACE_LOAD')
k('phase 0 surface not announced', 'fx(host, CPZ_FX_SURFACE_LOAD, (int32_t)surface, 0);', '(void)0;')
k('phase 0 slot surface wrong', 'host->set_slot_surface(host->context, slot, o->surface)', 'host->set_slot_surface(host->context, slot, 0u)')
k('phase 0 slot surface slot wrong', 'host->set_slot_surface(host->context, slot, o->surface)', 'host->set_slot_surface(host->context, 0, o->surface)')
k('phase 0 slot surface not announced', 'fx(host, CPZ_FX_SLOT_SURFACE, slot, (int32_t)o->surface);', '(void)0;')
k('phase 0 sound A test inverted', 'if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_prepare', 'if (no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_prepare')
k('phase 0 sound A always', 'if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_prepare', 'if (1) {\n        HOST(host->sound_prepare')
k('phase 0 sound A never', 'if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_prepare', 'if (0) {\n        HOST(host->sound_prepare')
k('phase 0 sound A record', 'HOST(host->sound_prepare(host->context, body + B_SOUND_A));', 'HOST(host->sound_prepare(host->context, body + B_SOUND_D));')
k('phase 0 sound A not announced', 'fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_A, 0);', '(void)0;')
k('phase 0 sound B test inverted', 'if (!no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_prepare', 'if (no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_prepare')
k('phase 0 sound B always', 'if (!no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_prepare', 'if (1) {\n        HOST(host->sound_prepare')
k('phase 0 sound B tests record A', 'if (!no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_prepare', 'if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_prepare')
k('phase 0 sound B record', 'HOST(host->sound_prepare(host->context, body + B_SOUND_B));', 'HOST(host->sound_prepare(host->context, body + B_SOUND_A));')
k('phase 0 sound B not announced', 'fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_B, 0);', '(void)0;')
k('phase 0 sound C test inverted', 'if (!no_sound(body + B_SOUND_C)) {\n        HOST(host->sound_prepare', 'if (no_sound(body + B_SOUND_C)) {\n        HOST(host->sound_prepare')
k('phase 0 sound C always', 'if (!no_sound(body + B_SOUND_C)) {\n        HOST(host->sound_prepare', 'if (1) {\n        HOST(host->sound_prepare')
k('phase 0 sound C tests record B', 'if (!no_sound(body + B_SOUND_C)) {\n        HOST(host->sound_prepare', 'if (!no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_prepare')
k('phase 0 sound C record', 'HOST(host->sound_prepare(host->context, body + B_SOUND_C));', 'HOST(host->sound_prepare(host->context, body + B_SOUND_B));')
k('phase 0 sound C not announced', 'fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_C, 0);', '(void)0;')
k('phase 0 solved kept', 'o->solved = 0;\n    o->canceled = 0;\n    o->state = CPZ_STATE_IDLE;', 'o->canceled = 0;\n    o->state = CPZ_STATE_IDLE;')
k('phase 0 canceled kept', 'o->canceled = 0;\n    o->state = CPZ_STATE_IDLE;', 'o->state = CPZ_STATE_IDLE;')
k('phase 0 state kept', 'o->state = CPZ_STATE_IDLE;\n    o->piece = 0;', 'o->piece = 0;')
k('phase 0 state wrong', 'o->state = CPZ_STATE_IDLE;\n    o->piece = 0;', 'o->state = CPZ_STATE_SOLVED;\n    o->piece = 0;')
k('phase 0 piece kept', 'o->piece = 0;\n    o->dir = 0;\n    o->step = 0;\n    o->moved = 0;', 'o->dir = 0;\n    o->step = 0;\n    o->moved = 0;')
k('phase 0 direction kept', 'o->dir = 0;\n    o->step = 0;\n    o->moved = 0;', 'o->step = 0;\n    o->moved = 0;')
k('phase 0 step kept', 'o->step = 0;\n    o->moved = 0;\n    memset', 'o->moved = 0;\n    memset')
k('phase 0 moved kept', 'o->moved = 0;\n    memset(o->saved', 'memset(o->saved')
k('phase 0 saved rectangle kept', 'memset(o->saved, 0, sizeof(o->saved));\n    return CPZ_OK;', 'return CPZ_OK;')
k('phase 0 saved rectangle partly kept', 'memset(o->saved, 0, sizeof(o->saved));\n    return CPZ_OK;', 'memset(o->saved, 0, sizeof(o->saved) - 4);\n    return CPZ_OK;')
# --- the stop sound ------------------------------------------------------------------------------------------------------------
k('stop sound test inverted', 'if (!no_sound(body + record)) {\n        const int16_t ch', 'if (no_sound(body + record)) {\n        const int16_t ch')
k('stop sound always', 'if (!no_sound(body + record)) {\n        const int16_t ch', 'if (1) {\n        const int16_t ch')
k('stop sound channel from the record', 'const int16_t ch = rd_s16(body, channel);', 'const int16_t ch = rd_s16(body, record);')
k('stop sound channel unsigned', 'const int16_t ch = rd_s16(body, channel);', 'const int16_t ch = (int16_t)(rd_s16(body, channel) & 0x7fff);')
k('stop sound not announced', 'fx(host, CPZ_FX_SOUND_PLAY, ch, 0);\n    }\n    return CPZ_OK;\n}\n\n/* 0x4634a5', '}\n    return CPZ_OK;\n}\n\n/* 0x4634a5')
# --- phase 1 (0x4634a5) --------------------------------------------------------------------------------------------------------
k('idle visit keeps the moved flag', 'case CPZ_STATE_IDLE:\n        o->moved = 0;', 'case CPZ_STATE_IDLE:')
k('idle visit scan test inverted', 'if (o->solved == 0) {\n            solved_scan(o, world, body, host);', 'if (o->solved != 0) {\n            solved_scan(o, world, body, host);')
k('idle visit never scans', 'if (o->solved == 0) {\n            solved_scan(o, world, body, host);', 'if (0) {\n            solved_scan(o, world, body, host);')
k('idle visit already solved keeps the state', 'o->state = CPZ_STATE_SOLVED;\n            fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;', 'fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;')
k('idle visit already solved not announced', 'o->state = CPZ_STATE_SOLVED;\n            fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;', 'o->state = CPZ_STATE_SOLVED;\n        }\n        break;')
k('solved state does not read the tick', 'const uint32_t now = host->tick(host->context);\n        fx(host, CPZ_FX_TICK, (int32_t)now, 0);\n        o->deadline', 'const uint32_t now = 0u;\n        fx(host, CPZ_FX_TICK, (int32_t)now, 0);\n        o->deadline')
k('solved state tick not announced', 'fx(host, CPZ_FX_TICK, (int32_t)now, 0);\n        o->deadline', 'o->deadline')
k('solved state delay subtracted', 'o->deadline = now + (uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000);', 'o->deadline = now - (uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000);')
k('solved state delay in tenths', 'o->deadline = now + (uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000);', 'o->deadline = now + (uint32_t)((int32_t)rd_s16(body, B_DELAY) * 100);')
k('solved state delay unsigned', 'o->deadline = now + (uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000);', 'o->deadline = now + (uint32_t)((int32_t)(uint16_t)rd_s16(body, B_DELAY) * 1000);')
k('solved state delay from the wrong word', 'o->deadline = now + (uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000);', 'o->deadline = now + (uint32_t)((int32_t)rd_s16(body, B_STEPS) * 1000);')
k('solved state ignores the delay', 'o->deadline = now + (uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000);', 'o->deadline = now;')
k('solved state next state wrong', 'o->state = CPZ_STATE_WAIT_DELAY;\n        fx(host, CPZ_FX_STATE, o->state, 0);\n        break;\n    }\n    case CPZ_STATE_MOVING: {', 'o->state = CPZ_STATE_WAIT_SOUND;\n        fx(host, CPZ_FX_STATE, o->state, 0);\n        break;\n    }\n    case CPZ_STATE_MOVING: {')
k('solved state next state not announced', 'o->state = CPZ_STATE_WAIT_DELAY;\n        fx(host, CPZ_FX_STATE, o->state, 0);\n        break;\n    }\n    case CPZ_STATE_MOVING: {', 'o->state = CPZ_STATE_WAIT_DELAY;\n        break;\n    }\n    case CPZ_STATE_MOVING: {')
k('moving state without the view origin', 'HOST(host->view_origin(host->context, &view_x, &view_y));\n        if (move_step', 'if (move_step')
k('moving state stop test uses or', 'if (move_step(o, body, world, view_x, view_y) != 0 && can_move(o, world, body, o->dir) == 0) {', 'if (move_step(o, body, world, view_x, view_y) != 0 || can_move(o, world, body, o->dir) == 0) {')
k('moving state stops at every step', 'if (move_step(o, body, world, view_x, view_y) != 0 && can_move(o, world, body, o->dir) == 0) {', 'if (move_step(o, body, world, view_x, view_y) == 0 || can_move(o, world, body, o->dir) == 0) {')
k('moving state never checks the move', 'if (move_step(o, body, world, view_x, view_y) != 0 && can_move(o, world, body, o->dir) == 0) {', 'if (move_step(o, body, world, view_x, view_y) != 0 && 1) {')
k('moving state swaps the origin', 'move_step(o, body, world, view_x, view_y) != 0 &&', 'move_step(o, body, world, view_y, view_x) != 0 &&')
k('moving state checks the wrong direction', 'can_move(o, world, body, o->dir) == 0) {\n            const int rests', 'can_move(o, world, body, CPZ_DIR_LEFT) == 0) {\n            const int rests')
k('moving state continue test inverted', 'can_move(o, world, body, o->dir) == 0) {\n            const int rests', 'can_move(o, world, body, o->dir) != 0) {\n            const int rests')
k('moving state rest test on the piece', 'const int rests = type_is(world, o->piece, o->at_row, o->at_col);', 'const int rests = type_is(world, 1, o->at_row, o->at_col);')
k('moving state rest test on the old cell', 'const int rests = type_is(world, o->piece, o->at_row, o->at_col);', 'const int rests = type_is(world, o->piece, o->at_col, o->at_row);')
k('moving state rest test inverted', 'const int rc = rests == 0 ? play_if(body, B_SOUND_C, B_CHANNEL_C, host) : play_if(body, B_SOUND_B, B_CHANNEL_B, host);', 'const int rc = rests != 0 ? play_if(body, B_SOUND_C, B_CHANNEL_C, host) : play_if(body, B_SOUND_B, B_CHANNEL_B, host);')
k('moving state sound C with the B channel', 'play_if(body, B_SOUND_C, B_CHANNEL_C, host) :', 'play_if(body, B_SOUND_C, B_CHANNEL_B, host) :')
k('moving state sound B with the C channel', ': play_if(body, B_SOUND_B, B_CHANNEL_B, host);', ': play_if(body, B_SOUND_B, B_CHANNEL_C, host);')
k('moving state sound B record', ': play_if(body, B_SOUND_B, B_CHANNEL_B, host);', ': play_if(body, B_SOUND_C, B_CHANNEL_B, host);')
k('moving state sound C record', 'play_if(body, B_SOUND_C, B_CHANNEL_C, host) :', 'play_if(body, B_SOUND_B, B_CHANNEL_C, host) :')
k('moving state sound failure ignored', 'if (rc != CPZ_OK) return rc;\n            o->state = CPZ_STATE_IDLE;', 'o->state = CPZ_STATE_IDLE;')
k('moving state stays moving', 'o->state = CPZ_STATE_IDLE;\n            fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;', 'fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;')
k('moving state state not announced', 'o->state = CPZ_STATE_IDLE;\n            fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;', 'o->state = CPZ_STATE_IDLE;\n        }\n        break;')
k('moving state goes to the wrong state', 'o->state = CPZ_STATE_IDLE;\n            fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;', 'o->state = CPZ_STATE_SOLVED;\n            fx(host, CPZ_FX_STATE, o->state, 0);\n        }\n        break;')
k('wait sound channel from the wrong record', 'const int16_t ch = rd_s16(body, B_CHANNEL_D);\n        int32_t busy = 0;', 'const int16_t ch = rd_s16(body, B_CHANNEL_C);\n        int32_t busy = 0;')
k('wait sound busy test inverted', 'if (busy == 0) {\n            HOST(host->sound_stop', 'if (busy != 0) {\n            HOST(host->sound_stop')
k('wait sound busy only for one', 'if (busy == 0) {\n            HOST(host->sound_stop', 'if (busy != 1) {\n            HOST(host->sound_stop')
k('wait sound busy not announced', 'fx(host, CPZ_FX_SOUND_BUSY, ch, busy);', '(void)0;')
k('wait sound stops the wrong record', 'HOST(host->sound_stop(host->context, body + B_SOUND_D));\n            fx(host, CPZ_FX_SOUND_STOP, B_SOUND_D, 0);\n            *row_phase', 'HOST(host->sound_stop(host->context, body + B_SOUND_C));\n            fx(host, CPZ_FX_SOUND_STOP, B_SOUND_D, 0);\n            *row_phase')
k('wait sound stop not announced', 'fx(host, CPZ_FX_SOUND_STOP, B_SOUND_D, 0);\n            *row_phase = 2u;', '*row_phase = 2u;')
k('wait sound phase not advanced', '*row_phase = 2u;\n            fx(host, CPZ_FX_PHASE, 2, 0);\n        }\n        break;\n    }\n    case CPZ_STATE_WAIT_DELAY', 'fx(host, CPZ_FX_PHASE, 2, 0);\n        }\n        break;\n    }\n    case CPZ_STATE_WAIT_DELAY')
k('wait sound phase wrong', '*row_phase = 2u;\n            fx(host, CPZ_FX_PHASE, 2, 0);\n        }\n        break;\n    }\n    case CPZ_STATE_WAIT_DELAY', '*row_phase = 1u;\n            fx(host, CPZ_FX_PHASE, 2, 0);\n        }\n        break;\n    }\n    case CPZ_STATE_WAIT_DELAY')
k('wait sound phase not announced', 'fx(host, CPZ_FX_PHASE, 2, 0);\n        }\n        break;\n    }\n    case CPZ_STATE_WAIT_DELAY', '}\n        break;\n    }\n    case CPZ_STATE_WAIT_DELAY')
k('wait delay tick not announced', 'const uint32_t now = host->tick(host->context);\n        fx(host, CPZ_FX_TICK, (int32_t)now, 0);\n        if (now >= o->deadline) {', 'const uint32_t now = host->tick(host->context);\n        if (now >= o->deadline) {')
k('wait delay exclusive', 'if (now >= o->deadline) {', 'if (now > o->deadline) {')
k('wait delay one early', 'if (now >= o->deadline) {', 'if (now + 1u >= o->deadline) {')
k('wait delay signed', 'if (now >= o->deadline) {', 'if ((int32_t)now >= (int32_t)o->deadline) {')
k('wait delay reversed', 'if (now >= o->deadline) {', 'if (now <= o->deadline) {')
k('wait delay never', 'if (now >= o->deadline) {', 'if (0) {')
k('wait delay no final sound test inverted', 'if (no_sound(body + B_SOUND_D)) {\n                *row_phase = 2u;', 'if (!no_sound(body + B_SOUND_D)) {\n                *row_phase = 2u;')
k('wait delay no final sound tests the wrong record', 'if (no_sound(body + B_SOUND_D)) {\n                *row_phase = 2u;', 'if (no_sound(body + B_SOUND_C)) {\n                *row_phase = 2u;')
k('wait delay no final sound phase wrong', 'if (no_sound(body + B_SOUND_D)) {\n                *row_phase = 2u;', 'if (no_sound(body + B_SOUND_D)) {\n                *row_phase = 1u;')
k('wait delay no final sound phase not announced', 'if (no_sound(body + B_SOUND_D)) {\n                *row_phase = 2u;\n                fx(host, CPZ_FX_PHASE, 2, 0);', 'if (no_sound(body + B_SOUND_D)) {\n                *row_phase = 2u;')
k('wait delay channel from the wrong record', 'const int16_t ch = rd_s16(body, B_CHANNEL_D);\n                HOST(host->sound_prepare', 'const int16_t ch = rd_s16(body, B_CHANNEL_A);\n                HOST(host->sound_prepare')
k('wait delay prepares the wrong record', 'HOST(host->sound_prepare(host->context, body + B_SOUND_D));\n                fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_D, 0);', 'HOST(host->sound_prepare(host->context, body + B_SOUND_C));\n                fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_D, 0);')
k('wait delay prepare not announced', 'fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_D, 0);', '(void)0;')
k('wait delay prepare skipped', 'HOST(host->sound_prepare(host->context, body + B_SOUND_D));\n                fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_D, 0);', 'fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_D, 0);')
k('wait delay play skipped', 'HOST(host->sound_play(host->context, ch));\n                fx(host, CPZ_FX_SOUND_PLAY, ch, 0);\n                o->state = CPZ_STATE_WAIT_SOUND;', 'fx(host, CPZ_FX_SOUND_PLAY, ch, 0);\n                o->state = CPZ_STATE_WAIT_SOUND;')
k('wait delay play not announced', 'fx(host, CPZ_FX_SOUND_PLAY, ch, 0);\n                o->state = CPZ_STATE_WAIT_SOUND;', 'o->state = CPZ_STATE_WAIT_SOUND;')
k('wait delay state not changed', 'o->state = CPZ_STATE_WAIT_SOUND;\n                fx(host, CPZ_FX_STATE, o->state, 0);', 'fx(host, CPZ_FX_STATE, o->state, 0);')
k('wait delay state not announced', 'o->state = CPZ_STATE_WAIT_SOUND;\n                fx(host, CPZ_FX_STATE, o->state, 0);', 'o->state = CPZ_STATE_WAIT_SOUND;')
k('wait delay state wrong', 'o->state = CPZ_STATE_WAIT_SOUND;\n                fx(host, CPZ_FX_STATE, o->state, 0);', 'o->state = CPZ_STATE_IDLE;\n                fx(host, CPZ_FX_STATE, o->state, 0);')
k('unknown states do something', 'default:\n        break;\n    }\n    return CPZ_OK;\n}\n\n/* 0x463c26', 'default:\n        o->state = CPZ_STATE_IDLE;\n        break;\n    }\n    return CPZ_OK;\n}\n\n/* 0x463c26')
# --- phase 2 (0x463c26) --------------------------------------------------------------------------------------------------------
k('phase 2 start flag not set', 'world->start_flag_5bb1ca = 1;\n    fx(host, CPZ_FX_START_FLAG, 1, 0);\n    if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_stop', 'fx(host, CPZ_FX_START_FLAG, 1, 0);\n    if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_stop')
k('phase 2 start flag not announced', 'fx(host, CPZ_FX_START_FLAG, 1, 0);\n    if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_stop', 'if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_stop')
k('phase 2 sound A test inverted', 'if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_stop', 'if (no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_stop')
k('phase 2 sound A always', 'if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_stop', 'if (1) {\n        HOST(host->sound_stop')
k('phase 2 sound A record', 'HOST(host->sound_stop(host->context, body + B_SOUND_A));', 'HOST(host->sound_stop(host->context, body + B_SOUND_D));')
k('phase 2 sound A not announced', 'fx(host, CPZ_FX_SOUND_STOP, B_SOUND_A, 0);', '(void)0;')
k('phase 2 sound B test inverted', 'if (!no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_stop', 'if (no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_stop')
k('phase 2 sound B always', 'if (!no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_stop', 'if (1) {\n        HOST(host->sound_stop')
k('phase 2 sound B tests record A', 'if (!no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_stop', 'if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_stop')
k('phase 2 sound B record', 'HOST(host->sound_stop(host->context, body + B_SOUND_B));', 'HOST(host->sound_stop(host->context, body + B_SOUND_A));')
k('phase 2 sound B not announced', 'fx(host, CPZ_FX_SOUND_STOP, B_SOUND_B, 0);', '(void)0;')
k('phase 2 sound C test inverted', 'if (!no_sound(body + B_SOUND_C)) {\n        HOST(host->sound_stop', 'if (no_sound(body + B_SOUND_C)) {\n        HOST(host->sound_stop')
k('phase 2 sound C always', 'if (!no_sound(body + B_SOUND_C)) {\n        HOST(host->sound_stop', 'if (1) {\n        HOST(host->sound_stop')
k('phase 2 sound C tests record B', 'if (!no_sound(body + B_SOUND_C)) {\n        HOST(host->sound_stop', 'if (!no_sound(body + B_SOUND_B)) {\n        HOST(host->sound_stop')
k('phase 2 sound C record', 'HOST(host->sound_stop(host->context, body + B_SOUND_C));', 'HOST(host->sound_stop(host->context, body + B_SOUND_B));')
k('phase 2 sound C not announced', 'fx(host, CPZ_FX_SOUND_STOP, B_SOUND_C, 0);', '(void)0;')
k('phase 2 canceled test inverted', 'if (o->canceled == 0) {\n        if (o->solved != 0)', 'if (o->canceled != 0) {\n        if (o->solved != 0)')
k('phase 2 solved test inverted', 'if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);', 'if (o->solved == 0) return apply_block(body + B_SOLVED, world, host);')
k('phase 2 solved applies the cancel block', 'if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);', 'if (o->solved != 0) return apply_block(body + B_CANCEL, world, host);')
k('phase 2 cancel applies the solved block', 'return apply_block(body + B_CANCEL, world, host);\n}', 'return apply_block(body + B_SOLVED, world, host);\n}')
k('phase 2 solved always applies', 'if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);\n        return CPZ_OK;', 'return apply_block(body + B_SOLVED, world, host);')
# --- the dispatch --------------------------------------------------------------------------------------------------------------
k('host check lost: object', 'if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {', 'if (body == NULL || world == NULL || result == NULL || !host_complete(host)) {')
k('host check lost: body', 'if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {', 'if (object == NULL || world == NULL || result == NULL || !host_complete(host)) {')
k('host check lost: world', 'if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {', 'if (object == NULL || body == NULL || result == NULL || !host_complete(host)) {')
k('host check lost: result', 'if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {', 'if (object == NULL || body == NULL || world == NULL || !host_complete(host)) {')
k('host check lost: host', 'if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {', 'if (object == NULL || body == NULL || world == NULL || result == NULL) {')
k('host argument text', '"0xd3-argument"', '"x"')
k('step result not cleared', 'memset(result, 0, sizeof(*result));\n    result->phase_after = phase;', 'result->phase_after = phase;')
k('step phase after not preset', 'result->phase_after = phase;', '(void)0;')
k('step body not validated', 'if (cpz_validate_body(body, body_length, &why) != CPZ_OK) {\n        if (failure != NULL) *failure = why;\n        return CPZ_ERR_BODY;\n    }', '(void)why;')
k('step failure text not cleared', 'if (failure != NULL) *failure = NULL;\n    if (object == NULL', 'if (object == NULL')
k('step row refusal text', '"0xd3-row"', '"x"')
k('step negative row accepted', 'if (row < 0) {', 'if (0) {')
k('step row zero refused', 'if (row < 0) {', 'if (row < 1) {')
k('step phase 0 not initialized', 'row_phase = 1u;\n            fx(host, CPZ_FX_PHASE, 1, 0);\n            result->initialized = 1u;', 'row_phase = 1u;\n            fx(host, CPZ_FX_PHASE, 1, 0);')
k('step phase 0 stays in 0', 'row_phase = 1u;\n            fx(host, CPZ_FX_PHASE, 1, 0);\n            result->initialized = 1u;', 'fx(host, CPZ_FX_PHASE, 1, 0);\n            result->initialized = 1u;')
k('step phase 0 phase not announced', 'row_phase = 1u;\n            fx(host, CPZ_FX_PHASE, 1, 0);\n            result->initialized = 1u;', 'row_phase = 1u;\n            result->initialized = 1u;')
k('step phase 1 without init text', '"0xd3-phase-1-without-init"', '"x"')
k('step phase 1 inactive accepted', 'if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xd3-phase-1-without-init";', 'if (object->row != row) {\n            if (failure != NULL) *failure = "0xd3-phase-1-without-init";')
k('step phase 1 other row accepted', 'if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xd3-phase-1-without-init";', 'if (object->active == 0) {\n            if (failure != NULL) *failure = "0xd3-phase-1-without-init";')
k('step phase 1 refused as error', 'if (failure != NULL) *failure = "0xd3-phase-1-without-init";\n            return CPZ_ERR_UNSUPPORTED;', 'if (failure != NULL) *failure = "0xd3-phase-1-without-init";\n            return CPZ_ERR_ARGUMENT;')
k('step phase 2 without init text', '"0xd3-phase-2-without-init"', '"x"')
k('step phase 2 inactive accepted', 'if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xd3-phase-2-without-init";', 'if (object->row != row) {\n            if (failure != NULL) *failure = "0xd3-phase-2-without-init";')
k('step phase 2 other row accepted', 'if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xd3-phase-2-without-init";', 'if (object->active == 0) {\n            if (failure != NULL) *failure = "0xd3-phase-2-without-init";')
k('step phase 2 refused as error', 'if (failure != NULL) *failure = "0xd3-phase-2-without-init";\n            return CPZ_ERR_UNSUPPORTED;', 'if (failure != NULL) *failure = "0xd3-phase-2-without-init";\n            return CPZ_ERR_ARGUMENT;')
k('step flag check uses the solved block first', 'object->canceled != 0 ? body + B_CANCEL : (object->solved != 0 ? body + B_SOLVED : NULL)', 'object->solved != 0 ? body + B_SOLVED : (object->canceled != 0 ? body + B_CANCEL : NULL)')
k('step flag check ignores the cancel block', 'object->canceled != 0 ? body + B_CANCEL : (object->solved != 0 ? body + B_SOLVED : NULL)', 'object->solved != 0 ? body + B_SOLVED : NULL')
k('step flag check ignores the solved block', 'object->canceled != 0 ? body + B_CANCEL : (object->solved != 0 ? body + B_SOLVED : NULL)', 'object->canceled != 0 ? body + B_CANCEL : NULL')
k('step flag check always the solved block', 'object->canceled != 0 ? body + B_CANCEL : (object->solved != 0 ? body + B_SOLVED : NULL)', 'body + B_SOLVED')
k('step flag check without the sentinel', 'if (flag != CPZ_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (host->event_flag_invalid(host->context, flag) != 0) {')
k('step flag check never refuses', 'if (flag != CPZ_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (0) {')
k('step flag check refuses valid flags', 'if (flag != CPZ_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {', 'if (flag != CPZ_NO_FLAG && host->event_flag_invalid(host->context, flag) == 0) {')
k('step flag check text', '"0xd3-event-flag-index"', '"x"')
k('step flag check wrong status', 'if (failure != NULL) *failure = "0xd3-event-flag-index";\n                    return CPZ_ERR_BOUNDS;', 'if (failure != NULL) *failure = "0xd3-event-flag-index";\n                    return CPZ_ERR_HOST;')
k('step phase 2 completion not announced', 'fx(host, CPZ_FX_COMPLETE, row, 0);', '(void)0;')
k('step phase 2 completion not reported', 'result->completed = 1u;\n            row_phase = 0u;', 'row_phase = 0u;')
k('step phase 2 keeps the phase', 'row_phase = 0u; /* 0x42ba3a stores phase 0 */', '(void)0;')
k('step phase 2 phase one', 'row_phase = 0u; /* 0x42ba3a stores phase 0 */', 'row_phase = 1u;')
k('step phase 2 cleanup lost', 'rc = cpz_cleanup(object, host);\n        }\n    } else {', '(void)0;\n        }\n    } else {')
k('step other phases fail', 'rc = CPZ_OK; /* any other phase falls out of the switch */', 'rc = CPZ_ERR_UNSUPPORTED;')
k('step failure text for host errors', 'if (rc != CPZ_OK && failure != NULL && *failure == NULL) *failure = "0xd3-host";', '(void)0;')
k('step failure text for host errors name', '"0xd3-host"', '"x"')
k('step phase after lost', 'result->phase_after = row_phase;\n    return rc;', 'return rc;')
# --- the pointer (0x462c39, 0x4630a3) ------------------------------------------------------------------------------------------
k('cursor kind left', 'case CPZ_CANDIDATE_LEFT: out->cursor_kind = 0x19; break;', 'case CPZ_CANDIDATE_LEFT: out->cursor_kind = 0x1a; break;')
k('cursor kind up', 'case CPZ_CANDIDATE_UP: out->cursor_kind = 0x17; break;', 'case CPZ_CANDIDATE_UP: out->cursor_kind = 0x18; break;')
k('cursor kind down', 'case CPZ_CANDIDATE_DOWN: out->cursor_kind = 0x18; break;', 'case CPZ_CANDIDATE_DOWN: out->cursor_kind = 0x17; break;')
k('cursor kind right', 'default: out->cursor_kind = 0x1a; break;', 'default: out->cursor_kind = 0x19; break;')
k('cursor kind cancel', 'out->cursor_kind = CPZ_CURSOR_CANCEL;', 'out->cursor_kind = 8;')
k('cursor sub', 'out->cursor_sub = 1;', 'out->cursor_sub = 0;')
k('cursor not written', 'out->cursor_written = 1u;\n    out->cursor_sub', 'out->cursor_sub')
k('cursor candidate lost', 'out->candidate = candidate;\n    if (candidate == CPZ_CANDIDATE_CANCEL) {', 'if (candidate == CPZ_CANDIDATE_CANCEL) {')
k('cursor cancel falls through', 'out->cursor_kind = CPZ_CURSOR_CANCEL;\n        return;', 'out->cursor_kind = CPZ_CURSOR_CANCEL;')
k('pointer null object accepted', 'if (object == NULL || world == NULL || body == NULL || out == NULL ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (object->active == 0 ||',
  'if (world == NULL || body == NULL || out == NULL ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (object->active == 0 ||')
k('pointer null world accepted', 'if (object == NULL || world == NULL || body == NULL || out == NULL ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (object->active == 0 ||',
  'if (object == NULL || body == NULL || out == NULL ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (object->active == 0 ||')
k('pointer body not validated', 'if (object == NULL || world == NULL || body == NULL || out == NULL ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (object->active == 0 ||',
  'if (object == NULL || world == NULL || body == NULL || out == NULL)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (object->active == 0 ||')
k('pointer result not cleared', 'memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (object->active == 0 ||', 'out->candidate = -1;\n    if (object->active == 0 ||')
k('pointer candidate default', 'out->candidate = -1;\n    if (object->active == 0 ||', 'out->candidate = 0;\n    if (object->active == 0 ||')
k('pointer inactive object active', 'if (object->active == 0 || object->state == CPZ_STATE_MOVING) return CPZ_OK;', 'if (object->state == CPZ_STATE_MOVING) return CPZ_OK;')
k('pointer moving object active', 'if (object->active == 0 || object->state == CPZ_STATE_MOVING) return CPZ_OK;', 'if (object->active == 0) return CPZ_OK;')
k('pointer other states refused', 'if (object->active == 0 || object->state == CPZ_STATE_MOVING) return CPZ_OK;', 'if (object->active == 0 || object->state != CPZ_STATE_IDLE) return CPZ_OK;')
k('pointer x not sign-extended', 'x = (int16_t)x; /* movsx word */', '(void)0;')
k('pointer y not sign-extended', 'y = (int16_t)y;', '(void)0;')
k('pointer x zero-extended', 'x = (int16_t)x; /* movsx word */', 'x = (uint16_t)x;')
k('pointer y zero-extended', 'y = (int16_t)y;', 'y = (uint16_t)y;')
k('pointer view x not added', 'px = add32(x, view_x);', 'px = x;')
k('pointer view x is y', 'px = add32(x, view_x);', 'px = add32(x, view_y);')
k('pointer view y not added', 'py = add32(y, view_y);', 'py = y;')
k('pointer view y is x', 'py = add32(y, view_y);', 'py = add32(y, view_x);')
k('pointer rows from columns', 'rows = rd_s16(body, B_ROWS);\n    cols = rd_s16(body, B_COLS);\n    /* (w', 'rows = rd_s16(body, B_COLS);\n    cols = rd_s16(body, B_COLS);\n    /* (w')
k('pointer quarter shifts three', 'quarter = (quarter < 0) ? (int32_t)(~(~(uint32_t)quarter >> 2)) : (quarter >> 2);', 'quarter = (quarter < 0) ? (int32_t)(~(~(uint32_t)quarter >> 2)) : (quarter >> 3);')
k('pointer quarter shifts one', 'quarter = (quarter < 0) ? (int32_t)(~(~(uint32_t)quarter >> 2)) : (quarter >> 2);', 'quarter = (quarter < 0) ? (int32_t)(~(~(uint32_t)quarter >> 2)) : (quarter >> 1);')
k('pointer quarter without the bias', 'quarter = (int32_t)((uint32_t)object->cell_w + (uint32_t)((object->cell_w < 0) ? 3 : 0));', 'quarter = (int32_t)((uint32_t)object->cell_w + (uint32_t)((object->cell_w < 0) ? 0 : 0));')
k('pointer quarter from the height', 'quarter = (int32_t)((uint32_t)object->cell_w + (uint32_t)((object->cell_w < 0) ? 3 : 0));', 'quarter = (int32_t)((uint32_t)object->cell_h + (uint32_t)((object->cell_h < 0) ? 3 : 0));')
k('pointer half height of the width', 'half_h = object->cell_h / 2;', 'half_h = object->cell_w / 2;')
k('pointer half height is a third', 'half_h = object->cell_h / 2;', 'half_h = object->cell_h / 3;')
k('pointer half height rounds up', 'half_h = object->cell_h / 2;', 'half_h = (object->cell_h + 1) / 2;')
k('pointer rows inclusive', 'for (int16_t a = 0; a < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0) continue;', 'for (int16_t a = 0; a <= rows && a < CPZ_GRID_MAX; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0) continue;')
k('pointer columns inclusive', 'for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0) continue;', 'for (int16_t b = 0; b <= cols && b < CPZ_GRID_MAX; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0) continue;')
k('pointer rows stop early', 'for (int16_t a = 0; a < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0) continue;', 'for (int16_t a = 0; a + 1 < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0) continue;')
k('pointer columns stop early', 'for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0) continue;', 'for (int16_t b = 0; b + 1 < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->piece == 0) continue;')
k('pointer empty cells scanned', 'if (c->piece == 0) continue;\n            object->piece = c->piece;', 'object->piece = c->piece;')
k('pointer piece not stored', 'object->piece = c->piece;\n            object->at_row = a;', 'object->at_row = a;')
k('pointer row not stored', 'object->at_row = a;\n            object->at_col = b;', 'object->at_col = b;')
k('pointer column not stored', 'object->at_col = b;\n            if (c->rect[1] <= py && py < add32', 'if (c->rect[1] <= py && py < add32')
k('pointer up top inclusive', 'if (c->rect[1] <= py && py < add32(c->rect[1], half_h)', 'if (c->rect[1] < py && py < add32(c->rect[1], half_h)')
k('pointer up top one early', 'if (c->rect[1] <= py && py < add32(c->rect[1], half_h)', 'if (c->rect[1] - 1 <= py && py < add32(c->rect[1], half_h)')
k('pointer up bottom exclusive', 'py < add32(c->rect[1], half_h) && add32(c->rect[0], quarter) < px', 'py <= add32(c->rect[1], half_h) && add32(c->rect[0], quarter) < px')
k('pointer up bottom early', 'py < add32(c->rect[1], half_h) && add32(c->rect[0], quarter) < px', 'py < add32(c->rect[1], half_h) - 1 && add32(c->rect[0], quarter) < px')
k('pointer up left exclusive', 'add32(c->rect[0], quarter) < px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP)', 'add32(c->rect[0], quarter) <= px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP)')
k('pointer up right exclusive', 'px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP)', 'px <= sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP)')
k('pointer up move check lost', 'px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP) == 1) {', 'px < sub32(c->rect[2], quarter) && 1) {')
k('pointer up move check wrong direction', 'can_move(object, world, body, CPZ_DIR_UP) == 1) {', 'can_move(object, world, body, CPZ_DIR_DOWN) == 1) {')
k('pointer up candidate', 'cursor_write(object, CPZ_CANDIDATE_UP, out);', 'cursor_write(object, CPZ_CANDIDATE_DOWN, out);')
k('pointer right top inclusive', 'if (c->rect[1] <= py && py <= c->rect[3] && sub32(c->rect[2], quarter) < px && px <= c->rect[2] &&', 'if (c->rect[1] < py && py <= c->rect[3] && sub32(c->rect[2], quarter) < px && px <= c->rect[2] &&')
k('pointer right bottom inclusive', 'if (c->rect[1] <= py && py <= c->rect[3] && sub32(c->rect[2], quarter) < px && px <= c->rect[2] &&', 'if (c->rect[1] <= py && py < c->rect[3] && sub32(c->rect[2], quarter) < px && px <= c->rect[2] &&')
k('pointer right left exclusive', 'sub32(c->rect[2], quarter) < px && px <= c->rect[2] &&', 'sub32(c->rect[2], quarter) <= px && px <= c->rect[2] &&')
k('pointer right edge inclusive', 'sub32(c->rect[2], quarter) < px && px <= c->rect[2] &&', 'sub32(c->rect[2], quarter) < px && px < c->rect[2] &&')
k('pointer right move check lost', 'px <= c->rect[2] &&\n                can_move(object, world, body, CPZ_DIR_RIGHT) == 1) {', 'px <= c->rect[2] &&\n                1) {')
k('pointer right move check wrong direction', 'can_move(object, world, body, CPZ_DIR_RIGHT) == 1) {', 'can_move(object, world, body, CPZ_DIR_LEFT) == 1) {')
k('pointer right candidate', 'cursor_write(object, CPZ_CANDIDATE_RIGHT, out);', 'cursor_write(object, CPZ_CANDIDATE_LEFT, out);')
k('pointer down top inclusive', 'if (sub32(c->rect[3], half_h) <= py && py <= c->rect[3]', 'if (sub32(c->rect[3], half_h) < py && py <= c->rect[3]')
k('pointer down top early', 'if (sub32(c->rect[3], half_h) <= py && py <= c->rect[3]', 'if (sub32(c->rect[3], half_h) - 1 <= py && py <= c->rect[3]')
k('pointer down bottom inclusive', 'py <= c->rect[3] && add32(c->rect[0], quarter) < px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)', 'py < c->rect[3] && add32(c->rect[0], quarter) < px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)')
k('pointer down left exclusive', 'py <= c->rect[3] && add32(c->rect[0], quarter) < px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)', 'py <= c->rect[3] && add32(c->rect[0], quarter) <= px &&\n                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)')
k('pointer down right exclusive', 'px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)', 'px <= sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN)')
k('pointer down move check lost', 'can_move(object, world, body, CPZ_DIR_DOWN) == 1) {', '1) {')
k('pointer down move check wrong direction', 'can_move(object, world, body, CPZ_DIR_DOWN) == 1) {', 'can_move(object, world, body, CPZ_DIR_UP) == 1) {')
k('pointer down candidate', 'cursor_write(object, CPZ_CANDIDATE_DOWN, out);', 'cursor_write(object, CPZ_CANDIDATE_UP, out);')
k('pointer left top inclusive', 'if (c->rect[1] <= py && py <= c->rect[3] && c->rect[0] <= px', 'if (c->rect[1] < py && py <= c->rect[3] && c->rect[0] <= px')
k('pointer left bottom inclusive', 'if (c->rect[1] <= py && py <= c->rect[3] && c->rect[0] <= px', 'if (c->rect[1] <= py && py < c->rect[3] && c->rect[0] <= px')
k('pointer left edge exclusive', 'c->rect[0] <= px && px < add32(c->rect[0], quarter) &&', 'c->rect[0] < px && px < add32(c->rect[0], quarter) &&')
k('pointer left quarter inclusive', 'c->rect[0] <= px && px < add32(c->rect[0], quarter) &&', 'c->rect[0] <= px && px <= add32(c->rect[0], quarter) &&')
k('pointer left move check lost', 'px < add32(c->rect[0], quarter) &&\n                can_move(object, world, body, CPZ_DIR_LEFT) == 1) {', 'px < add32(c->rect[0], quarter) &&\n                1) {')
k('pointer left move check wrong direction', 'can_move(object, world, body, CPZ_DIR_LEFT) == 1) {', 'can_move(object, world, body, CPZ_DIR_RIGHT) == 1) {')
k('pointer left candidate', 'cursor_write(object, CPZ_CANDIDATE_LEFT, out);', 'cursor_write(object, CPZ_CANDIDATE_RIGHT, out);')
k('pointer hit flags lost: up', 'cursor_write(object, CPZ_CANDIDATE_UP, out);\n                out->hit = 1u;', 'cursor_write(object, CPZ_CANDIDATE_UP, out);')
k('pointer hit flags lost: right', 'cursor_write(object, CPZ_CANDIDATE_RIGHT, out);\n                out->hit = 1u;', 'cursor_write(object, CPZ_CANDIDATE_RIGHT, out);')
k('pointer hit flags lost: down', 'cursor_write(object, CPZ_CANDIDATE_DOWN, out);\n                out->hit = 1u;', 'cursor_write(object, CPZ_CANDIDATE_DOWN, out);')
k('pointer hit flags lost: left', 'cursor_write(object, CPZ_CANDIDATE_LEFT, out);\n                out->hit = 1u;', 'cursor_write(object, CPZ_CANDIDATE_LEFT, out);')
k('pointer hit continues: up', 'cursor_write(object, CPZ_CANDIDATE_UP, out);\n                out->hit = 1u;\n                return CPZ_OK;', 'cursor_write(object, CPZ_CANDIDATE_UP, out);\n                out->hit = 1u;')
k('pointer hit continues: right', 'cursor_write(object, CPZ_CANDIDATE_RIGHT, out);\n                out->hit = 1u;\n                return CPZ_OK;', 'cursor_write(object, CPZ_CANDIDATE_RIGHT, out);\n                out->hit = 1u;')
k('pointer hit continues: down', 'cursor_write(object, CPZ_CANDIDATE_DOWN, out);\n                out->hit = 1u;\n                return CPZ_OK;', 'cursor_write(object, CPZ_CANDIDATE_DOWN, out);\n                out->hit = 1u;')
k('pointer hit continues: left', 'cursor_write(object, CPZ_CANDIDATE_LEFT, out);\n                out->hit = 1u;\n                return CPZ_OK;', 'cursor_write(object, CPZ_CANDIDATE_LEFT, out);\n                out->hit = 1u;')
k('pointer miss keeps the direction', 'object->dir = 0;\n    if (in_rect(body, B_CANCEL_RECT, x, y)) {', 'if (in_rect(body, B_CANCEL_RECT, x, y)) {')
k('pointer cancel rectangle ignored', 'if (in_rect(body, B_CANCEL_RECT, x, y)) {', 'if (0) {')
k('pointer cancel with the view origin', 'if (in_rect(body, B_CANCEL_RECT, x, y)) {', 'if (in_rect(body, B_CANCEL_RECT, px, py)) {')
k('pointer cancel swapped', 'if (in_rect(body, B_CANCEL_RECT, x, y)) {', 'if (in_rect(body, B_CANCEL_RECT, y, x)) {')
k('pointer cancel candidate', 'cursor_write(object, CPZ_CANDIDATE_CANCEL, out);\n        out->hit = 1u;', 'cursor_write(object, CPZ_CANDIDATE_UP, out);\n        out->hit = 1u;')
k('pointer cancel hit lost', 'cursor_write(object, CPZ_CANDIDATE_CANCEL, out);\n        out->hit = 1u;', 'cursor_write(object, CPZ_CANDIDATE_CANCEL, out);')
k('cancel rectangle left exclusive', 'return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&\n           x <= rd_s32(body, rect + 8);', 'return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) < x &&\n           x <= rd_s32(body, rect + 8);')
k('cancel rectangle right exclusive', 'x <= rd_s32(body, rect + 8);', 'x < rd_s32(body, rect + 8);')
k('cancel rectangle top exclusive', 'return rd_s32(body, rect + 4) <= y &&', 'return rd_s32(body, rect + 4) < y &&')
k('cancel rectangle bottom exclusive', 'y <= rd_s32(body, rect + 12) &&', 'y < rd_s32(body, rect + 12) &&')
k('cancel rectangle top from the left', 'return rd_s32(body, rect + 4) <= y &&', 'return rd_s32(body, rect) <= y &&')
k('cancel rectangle right from the bottom', 'x <= rd_s32(body, rect + 8);', 'x <= rd_s32(body, rect + 12);')
# --- the click (0x4631d1) ------------------------------------------------------------------------------------------------------
k('click null object accepted', 'if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;', 'if (body == NULL || out == NULL || !host_complete(host) ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;')
k('click host not checked', 'if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;', 'if (object == NULL || body == NULL || out == NULL || host == NULL ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;')
k('click body not validated', 'if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;', 'if (object == NULL || body == NULL || out == NULL || !host_complete(host))\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;')
k('click result not cleared', 'memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;', 'out->new_phase = row_phase;')
k('click phase not preset', 'out->new_phase = row_phase;\n    if (!(object->active', '(void)0;\n    if (!(object->active')
k('click inactive accepted', 'if (!(object->active != 0 && object->solved == 0 && object->state == CPZ_STATE_IDLE && row_phase == 1u)) return CPZ_OK;', 'if (!(object->solved == 0 && object->state == CPZ_STATE_IDLE && row_phase == 1u)) return CPZ_OK;')
k('click solved accepted', 'if (!(object->active != 0 && object->solved == 0 && object->state == CPZ_STATE_IDLE && row_phase == 1u)) return CPZ_OK;', 'if (!(object->active != 0 && object->state == CPZ_STATE_IDLE && row_phase == 1u)) return CPZ_OK;')
k('click any state accepted', 'if (!(object->active != 0 && object->solved == 0 && object->state == CPZ_STATE_IDLE && row_phase == 1u)) return CPZ_OK;', 'if (!(object->active != 0 && object->solved == 0 && row_phase == 1u)) return CPZ_OK;')
k('click moving accepted', 'if (!(object->active != 0 && object->solved == 0 && object->state == CPZ_STATE_IDLE && row_phase == 1u)) return CPZ_OK;', 'if (!(object->active != 0 && object->solved == 0 && object->state != CPZ_STATE_SOLVED && row_phase == 1u)) return CPZ_OK;')
k('click any phase accepted', 'if (!(object->active != 0 && object->solved == 0 && object->state == CPZ_STATE_IDLE && row_phase == 1u)) return CPZ_OK;', 'if (!(object->active != 0 && object->solved == 0 && object->state == CPZ_STATE_IDLE)) return CPZ_OK;')
k('click phase two accepted', 'if (!(object->active != 0 && object->solved == 0 && object->state == CPZ_STATE_IDLE && row_phase == 1u)) return CPZ_OK;', 'if (!(object->active != 0 && object->solved == 0 && object->state == CPZ_STATE_IDLE && row_phase >= 1u)) return CPZ_OK;')
k('click candidate test inverted', 'if (candidate == CPZ_CANDIDATE_CANCEL) {\n        object->canceled = 1;', 'if (candidate != CPZ_CANDIDATE_CANCEL) {\n        object->canceled = 1;')
k('click candidate is the left move', 'if (candidate == CPZ_CANDIDATE_CANCEL) {\n        object->canceled = 1;', 'if (candidate == CPZ_CANDIDATE_LEFT) {\n        object->canceled = 1;')
k('click cancel not stored', 'object->canceled = 1;\n        out->cancel_asked = 1u;', 'out->cancel_asked = 1u;')
k('click cancel not reported', 'out->cancel_asked = 1u;\n        out->new_phase = 2u;', 'out->new_phase = 2u;')
k('click cancel phase wrong', 'out->new_phase = 2u;\n        fx(host, CPZ_FX_PHASE, 2, 0);', 'out->new_phase = 1u;\n        fx(host, CPZ_FX_PHASE, 2, 0);')
k('click cancel phase not announced', 'out->new_phase = 2u;\n        fx(host, CPZ_FX_PHASE, 2, 0);', 'out->new_phase = 2u;')
k('click move needs no direction', '} else if (object->dir != 0) {', '} else if (1) {')
k('click move never', '} else if (object->dir != 0) {', '} else if (0) {')
k('click move direction compared with the candidate', '} else if (object->dir != 0) {', '} else if (object->dir == candidate) {')
k('click state not changed', 'object->state = CPZ_STATE_MOVING;\n        fx(host, CPZ_FX_STATE, object->state, 0);\n        out->move_started', 'fx(host, CPZ_FX_STATE, object->state, 0);\n        out->move_started')
k('click state wrong', 'object->state = CPZ_STATE_MOVING;\n        fx(host, CPZ_FX_STATE, object->state, 0);\n        out->move_started', 'object->state = CPZ_STATE_SOLVED;\n        fx(host, CPZ_FX_STATE, object->state, 0);\n        out->move_started')
k('click state not announced', 'fx(host, CPZ_FX_STATE, object->state, 0);\n        out->move_started = 1u;', 'out->move_started = 1u;')
k('click move not reported', 'out->move_started = 1u;\n        if (start_flag', 'if (start_flag')
k('click sound without the flag', 'if (start_flag != 0 && !no_sound(body + B_SOUND_A)) {', 'if (!no_sound(body + B_SOUND_A)) {')
k('click sound only for one', 'if (start_flag != 0 && !no_sound(body + B_SOUND_A)) {', 'if (start_flag == 1 && !no_sound(body + B_SOUND_A)) {')
k('click sound for flag zero', 'if (start_flag != 0 && !no_sound(body + B_SOUND_A)) {', 'if (start_flag == 0 && !no_sound(body + B_SOUND_A)) {')
k('click sound ignores NO SOUND', 'if (start_flag != 0 && !no_sound(body + B_SOUND_A)) {', 'if (start_flag != 0) {')
k('click sound tests the wrong record', 'if (start_flag != 0 && !no_sound(body + B_SOUND_A)) {', 'if (start_flag != 0 && !no_sound(body + B_SOUND_B)) {')
k('click sound NO SOUND inverted', 'if (start_flag != 0 && !no_sound(body + B_SOUND_A)) {', 'if (start_flag != 0 && no_sound(body + B_SOUND_A)) {')
k('click sound channel', 'const int16_t ch = rd_s16(body, B_CHANNEL_A);\n            HOST(host->sound_play', 'const int16_t ch = rd_s16(body, B_CHANNEL_B);\n            HOST(host->sound_play')
k('click sound not played', 'HOST(host->sound_play(host->context, ch));\n            fx(host, CPZ_FX_SOUND_PLAY, ch, 0);\n            out->sound_played', 'fx(host, CPZ_FX_SOUND_PLAY, ch, 0);\n            out->sound_played')
k('click sound not announced', 'fx(host, CPZ_FX_SOUND_PLAY, ch, 0);\n            out->sound_played', 'out->sound_played')
k('click sound not reported', 'out->sound_played = 1u;', '(void)0;')
# --- invalidate and cleanup ----------------------------------------------------------------------------------------------------
k('invalidate argument check lost', 'if (object == NULL || host == NULL || host->mark_dirty == NULL) return CPZ_ERR_ARGUMENT;', 'if (object == NULL || host == NULL) return CPZ_ERR_ARGUMENT;')
k('invalidate object check lost', 'if (object == NULL || host == NULL || host->mark_dirty == NULL) return CPZ_ERR_ARGUMENT;', 'if (host == NULL || host->mark_dirty == NULL) return CPZ_ERR_ARGUMENT;')
k('invalidate host check lost', 'if (object == NULL || host == NULL || host->mark_dirty == NULL) return CPZ_ERR_ARGUMENT;', 'if (object == NULL || host->mark_dirty == NULL) return CPZ_ERR_ARGUMENT;')
k('invalidate inactive', 'if (object->active != 0 && object->slot != CPZ_NO_SLOT) HOST', 'if (object->slot != CPZ_NO_SLOT) HOST')
k('invalidate without a slot', 'if (object->active != 0 && object->slot != CPZ_NO_SLOT) HOST', 'if (object->active != 0) HOST')
k('invalidate wrong slot', 'host->mark_dirty(host->context, object->slot)', 'host->mark_dirty(host->context, 0)')
k('cleanup argument check lost', 'if (object == NULL || host == NULL || host->release_surface == NULL || host->release_slot == NULL)\n        return CPZ_ERR_ARGUMENT;', 'if (object == NULL || host == NULL)\n        return CPZ_ERR_ARGUMENT;')
k('cleanup surface release always', 'if (object->surface != 0u) {\n        const uint32_t surface', 'if (1) {\n        const uint32_t surface')
k('cleanup surface release never', 'if (object->surface != 0u) {\n        const uint32_t surface', 'if (0) {\n        const uint32_t surface')
k('cleanup surface kept', 'object->surface = 0u;\n        fx(host, CPZ_FX_RELEASE_SURFACE', 'fx(host, CPZ_FX_RELEASE_SURFACE')
k('cleanup surface handle', 'host->release_surface(host->context, surface)', 'host->release_surface(host->context, 0u)')
k('cleanup surface release not announced', 'fx(host, CPZ_FX_RELEASE_SURFACE, (int32_t)surface, 0);', '(void)0;')
k('cleanup slot release always', 'if (object->slot != CPZ_NO_SLOT) {\n        const int16_t slot', 'if (1) {\n        const int16_t slot')
k('cleanup slot release never', 'if (object->slot != CPZ_NO_SLOT) {\n        const int16_t slot', 'if (0) {\n        const int16_t slot')
k('cleanup slot handle', 'host->release_slot(host->context, slot)', 'host->release_slot(host->context, 0)')
k('cleanup slot release not announced', 'fx(host, CPZ_FX_RELEASE_SLOT, slot, 0);', '(void)0;')
k('cleanup slot kept', 'object->slot = CPZ_NO_SLOT; /* 0x461827 */', '(void)0;')
k('cleanup row kept', 'object->row = -1;\n    object->active = 0;', 'object->active = 0;')
k('cleanup active kept', 'object->active = 0;\n    object->canceled = 0;', 'object->canceled = 0;')
k('cleanup canceled kept', 'object->canceled = 0;\n    object->solved = 0;\n    return CPZ_OK;', 'object->solved = 0;\n    return CPZ_OK;')
k('cleanup solved kept', 'object->solved = 0;\n    return CPZ_OK;\n}\n\nstatic void add_blit', 'return CPZ_OK;\n}\n\nstatic void add_blit')
k('cleanup resets the state too', 'object->solved = 0;\n    return CPZ_OK;\n}\n\nstatic void add_blit', 'object->solved = 0;\n    object->state = 0;\n    return CPZ_OK;\n}\n\nstatic void add_blit')
# --- render (0x463b10) ---------------------------------------------------------------------------------------------------------
k('blit kind lost', 'bl->kind = kind;\n    bl->piece = piece;', 'bl->piece = piece;')
k('blit piece lost', 'bl->piece = piece;\n    bl->src_surface = surface;', 'bl->src_surface = surface;')
k('blit surface lost', 'bl->src_surface = surface;\n    for', 'for')
k('blit source offset', 'bl->src[k] = rd_s32(body, src + (size_t)k * 4u);', 'bl->src[k] = rd_s32(body, src + (size_t)k * 4u + 4u);')
k('blit source stride', 'bl->src[k] = rd_s32(body, src + (size_t)k * 4u);', 'bl->src[k] = rd_s32(body, src + (size_t)k * 2u);')
k('blit destination lost', 'bl->dst[k] = dst[k];', '(void)0;')
k('blit destination swapped', 'bl->dst[k] = dst[k];', 'bl->dst[k] = dst[k ^ 1];')
k('blit not announced', 'fx(host, CPZ_FX_BLIT, kind, piece);\n}', '(void)0;\n}')
k('blit announces the surface', 'fx(host, CPZ_FX_BLIT, kind, piece);\n}', 'fx(host, CPZ_FX_BLIT, kind, (int32_t)surface);\n}')
k('render null object accepted', 'if (object == NULL || world == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot', 'if (world == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot')
k('render null world accepted', 'if (object == NULL || world == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot', 'if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot')
k('render body not validated', 'if (object == NULL || world == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot', 'if (object == NULL || world == NULL || body == NULL || out == NULL || !host_complete(host))\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot')
k('render host not checked', 'if (object == NULL || world == NULL || body == NULL || out == NULL || !host_complete(host) ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot', 'if (object == NULL || world == NULL || body == NULL || out == NULL || host == NULL ||\n        cpz_validate_body(body, body_length, NULL) != CPZ_OK)\n        return CPZ_ERR_ARGUMENT;\n    memset(out, 0, sizeof(*out));\n    if (object->slot')
k('render result not cleared', 'memset(out, 0, sizeof(*out));\n    if (object->slot == CPZ_NO_SLOT) return CPZ_OK;', 'if (object->slot == CPZ_NO_SLOT) return CPZ_OK;')
k('render without a slot', 'if (object->slot == CPZ_NO_SLOT) return CPZ_OK;\n    out->valid = 1u;', 'out->valid = 1u;')
k('render never valid', 'out->valid = 1u;\n    HOST(host->view_origin', 'HOST(host->view_origin')
k('render slot zero refused', 'if (object->slot == CPZ_NO_SLOT) return CPZ_OK;', 'if (object->slot <= 0) return CPZ_OK;')
k('render without the view origin', 'HOST(host->view_origin(host->context, &view_x, &view_y));\n    rows = rd_s16(body, B_ROWS);', 'rows = rd_s16(body, B_ROWS);')
k('render rows from columns', 'rows = rd_s16(body, B_ROWS);\n    cols = rd_s16(body, B_COLS);\n    for (int16_t a = 0; a < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0) continue;',
  'rows = rd_s16(body, B_COLS);\n    cols = rd_s16(body, B_COLS);\n    for (int16_t a = 0; a < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0) continue;')
k('render rows inclusive', 'for (int16_t a = 0; a < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0) continue;', 'for (int16_t a = 0; a <= rows && a < CPZ_GRID_MAX; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0) continue;')
k('render columns inclusive', 'for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0) continue;', 'for (int16_t b = 0; b <= cols && b < CPZ_GRID_MAX; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0) continue;')
k('render rows stop early', 'for (int16_t a = 0; a < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0) continue;', 'for (int16_t a = 0; a + 1 < rows; ++a) {\n        for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0) continue;')
k('render columns stop early', 'for (int16_t b = 0; b < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0) continue;', 'for (int16_t b = 0; b + 1 < cols; ++b) {\n            const CpzCell *c = &world->cell[a][b];\n            if (c->visible == 0) continue;')
k('render invisible cells drawn', 'if (c->visible == 0) continue;', '(void)0;')
k('render visible cells skipped', 'if (c->visible == 0) continue;', 'if (c->visible != 0) continue;')
k('render target source offset', 'const size_t src = B_TARGET_SRC + (size_t)(c->type - 1) * 16u;', 'const size_t src = B_TARGET_SRC + (size_t)(c->type) * 16u;')
k('render target source stride', 'const size_t src = B_TARGET_SRC + (size_t)(c->type - 1) * 16u;', 'const size_t src = B_TARGET_SRC + (size_t)(c->type - 1) * 8u;')
k('render target emptiness test', 'if (rd_s32(body, src + 8) != rd_s32(body, src))\n                    add_blit(out, CPZ_BLIT_TARGET', 'if (rd_s32(body, src + 8) != rd_s32(body, src) || 1)\n                    add_blit(out, CPZ_BLIT_TARGET')
k('render target emptiness inverted', 'if (rd_s32(body, src + 8) != rd_s32(body, src))\n                    add_blit(out, CPZ_BLIT_TARGET', 'if (rd_s32(body, src + 8) == rd_s32(body, src))\n                    add_blit(out, CPZ_BLIT_TARGET')
k('render target emptiness on the height', 'if (rd_s32(body, src + 8) != rd_s32(body, src))\n                    add_blit(out, CPZ_BLIT_TARGET', 'if (rd_s32(body, src + 12) != rd_s32(body, src + 4))\n                    add_blit(out, CPZ_BLIT_TARGET')
k('render target emptiness on the wrong edge', 'if (rd_s32(body, src + 8) != rd_s32(body, src))\n                    add_blit(out, CPZ_BLIT_TARGET', 'if (rd_s32(body, src + 8) != rd_s32(body, src + 4))\n                    add_blit(out, CPZ_BLIT_TARGET')
k('render target kind', 'add_blit(out, CPZ_BLIT_TARGET, 0, object->surface, body, src, c->base, host);', 'add_blit(out, CPZ_BLIT_PIECE, 0, object->surface, body, src, c->base, host);')
k('render target destination', 'add_blit(out, CPZ_BLIT_TARGET, 0, object->surface, body, src, c->base, host);', 'add_blit(out, CPZ_BLIT_TARGET, 0, object->surface, body, src, c->rect, host);')
k('render target surface', 'add_blit(out, CPZ_BLIT_TARGET, 0, object->surface, body, src, c->base, host);', 'add_blit(out, CPZ_BLIT_TARGET, 0, 0u, body, src, c->base, host);')
k('render type 1 skipped', 'case 1: case 2: case 3:', 'case 2: case 3:')
k('render type 10 skipped', 'case 9: case 10: {', 'case 9: {')
k('render type 5 skipped', 'case 4: case 5: case 6:', 'case 4: case 6:')
k('render type 11 drawn', 'case 9: case 10: {', 'case 9: case 10: case 11: {')
k('render horizontal arrow cases', 'case CPZ_DIR_LEFT:\n            case CPZ_DIR_RIGHT:\n                add_blit(out, CPZ_BLIT_ARROW_H', 'case CPZ_DIR_LEFT:\n                add_blit(out, CPZ_BLIT_ARROW_H')
k('render horizontal arrow right case', 'case CPZ_DIR_LEFT:\n            case CPZ_DIR_RIGHT:\n                add_blit(out, CPZ_BLIT_ARROW_H', 'case CPZ_DIR_RIGHT:\n                add_blit(out, CPZ_BLIT_ARROW_H')
k('render horizontal arrow source', 'add_blit(out, CPZ_BLIT_ARROW_H, 0, object->surface, body, B_ARROW_H, c->base, host);', 'add_blit(out, CPZ_BLIT_ARROW_H, 0, object->surface, body, B_ARROW_V, c->base, host);')
k('render horizontal arrow kind', 'add_blit(out, CPZ_BLIT_ARROW_H, 0, object->surface, body, B_ARROW_H, c->base, host);', 'add_blit(out, CPZ_BLIT_ARROW_V, 0, object->surface, body, B_ARROW_H, c->base, host);')
k('render horizontal arrow destination', 'add_blit(out, CPZ_BLIT_ARROW_H, 0, object->surface, body, B_ARROW_H, c->base, host);', 'add_blit(out, CPZ_BLIT_ARROW_H, 0, object->surface, body, B_ARROW_H, c->rect, host);')
k('render vertical arrow up case', 'case CPZ_DIR_UP:\n            case CPZ_DIR_DOWN:\n                add_blit(out, CPZ_BLIT_ARROW_V', 'case CPZ_DIR_DOWN:\n                add_blit(out, CPZ_BLIT_ARROW_V')
k('render vertical arrow down case', 'case CPZ_DIR_UP:\n            case CPZ_DIR_DOWN:\n                add_blit(out, CPZ_BLIT_ARROW_V', 'case CPZ_DIR_UP:\n                add_blit(out, CPZ_BLIT_ARROW_V')
k('render vertical arrow source', 'add_blit(out, CPZ_BLIT_ARROW_V, 0, object->surface, body, B_ARROW_V, c->base, host);', 'add_blit(out, CPZ_BLIT_ARROW_V, 0, object->surface, body, B_ARROW_H, c->base, host);')
k('render vertical arrow kind', 'add_blit(out, CPZ_BLIT_ARROW_V, 0, object->surface, body, B_ARROW_V, c->base, host);', 'add_blit(out, CPZ_BLIT_ARROW_H, 0, object->surface, body, B_ARROW_V, c->base, host);')
k('render vertical arrow destination', 'add_blit(out, CPZ_BLIT_ARROW_V, 0, object->surface, body, B_ARROW_V, c->base, host);', 'add_blit(out, CPZ_BLIT_ARROW_V, 0, object->surface, body, B_ARROW_V, c->rect, host);')
k('render wall emptiness test lost', 'if (rd_s32(body, B_WALL + 8) != rd_s32(body, B_WALL))', 'if (1)')
k('render wall emptiness inverted', 'if (rd_s32(body, B_WALL + 8) != rd_s32(body, B_WALL))', 'if (rd_s32(body, B_WALL + 8) == rd_s32(body, B_WALL))')
k('render wall emptiness on the height', 'if (rd_s32(body, B_WALL + 8) != rd_s32(body, B_WALL))', 'if (rd_s32(body, B_WALL + 12) != rd_s32(body, B_WALL + 4))')
k('render wall emptiness on the wrong edge', 'if (rd_s32(body, B_WALL + 8) != rd_s32(body, B_WALL))', 'if (rd_s32(body, B_WALL + 8) != rd_s32(body, B_WALL + 4))')
k('render wall source', 'add_blit(out, CPZ_BLIT_WALL, 0, object->surface, body, B_WALL, c->base, host);', 'add_blit(out, CPZ_BLIT_WALL, 0, object->surface, body, B_ARROW_H, c->base, host);')
k('render wall kind', 'add_blit(out, CPZ_BLIT_WALL, 0, object->surface, body, B_WALL, c->base, host);', 'add_blit(out, CPZ_BLIT_ARROW_H, 0, object->surface, body, B_WALL, c->base, host);')
k('render wall destination', 'add_blit(out, CPZ_BLIT_WALL, 0, object->surface, body, B_WALL, c->base, host);', 'add_blit(out, CPZ_BLIT_WALL, 0, object->surface, body, B_WALL, c->rect, host);')
k('render piece cell test lost', 'if (c->piece != 0) {\n                if ((object->state', 'if (1) {\n                if ((object->state')
k('render restore while moving only', '(object->state == CPZ_STATE_MOVING || object->moved == 1) && object->piece == c->piece', '(object->state == CPZ_STATE_MOVING) && object->piece == c->piece')
k('render restore after a move only', '(object->state == CPZ_STATE_MOVING || object->moved == 1) && object->piece == c->piece', '(object->moved == 1) && object->piece == c->piece')
k('render restore needs both', '(object->state == CPZ_STATE_MOVING || object->moved == 1) && object->piece == c->piece', '(object->state == CPZ_STATE_MOVING && object->moved == 1) && object->piece == c->piece')
k('render restore for any piece', '(object->state == CPZ_STATE_MOVING || object->moved == 1) && object->piece == c->piece', '(object->state == CPZ_STATE_MOVING || object->moved == 1)')
k('render restore for the wrong moved value', 'object->moved == 1) && object->piece == c->piece', 'object->moved != 0) && object->piece == c->piece')
k('render restore kind', 'bl->kind = CPZ_BLIT_RESTORE;', 'bl->kind = CPZ_BLIT_PIECE;')
k('render restore piece', 'bl->piece = c->piece;\n                    bl->src_surface = 0u;', 'bl->piece = 0;\n                    bl->src_surface = 0u;')
k('render restore surface', 'bl->src_surface = 0u;\n                    bl->src[0]', 'bl->src_surface = object->surface;\n                    bl->src[0]')
k('render restore source left', 'bl->src[0] = sub32(object->saved[0], view_x);', 'bl->src[0] = object->saved[0];')
k('render restore source left with y', 'bl->src[0] = sub32(object->saved[0], view_x);', 'bl->src[0] = sub32(object->saved[0], view_y);')
k('render restore source top', 'bl->src[1] = sub32(object->saved[1], view_y);', 'bl->src[1] = object->saved[1];')
k('render restore source top with x', 'bl->src[1] = sub32(object->saved[1], view_y);', 'bl->src[1] = sub32(object->saved[1], view_x);')
k('render restore source right', 'bl->src[2] = sub32(object->saved[2], view_x);', 'bl->src[2] = object->saved[2];')
k('render restore source right from the left', 'bl->src[2] = sub32(object->saved[2], view_x);', 'bl->src[2] = sub32(object->saved[0], view_x);')
k('render restore source bottom', 'bl->src[3] = sub32(object->saved[3], view_y);', 'bl->src[3] = object->saved[3];')
k('render restore source bottom from the top', 'bl->src[3] = sub32(object->saved[3], view_y);', 'bl->src[3] = sub32(object->saved[1], view_y);')
k('render restore destination', 'for (int k = 0; k < 4; ++k) bl->dst[k] = object->saved[k];', 'for (int k = 0; k < 4; ++k) bl->dst[k] = c->rect[k];')
k('render restore destination partly', 'for (int k = 0; k < 4; ++k) bl->dst[k] = object->saved[k];', 'for (int k = 0; k < 3; ++k) bl->dst[k] = object->saved[k];')
k('render restore not announced', 'fx(host, CPZ_FX_BLIT, CPZ_BLIT_RESTORE, c->piece);', '(void)0;')
k('render restore announces kind six', 'fx(host, CPZ_FX_BLIT, CPZ_BLIT_RESTORE, c->piece);', 'fx(host, CPZ_FX_BLIT, CPZ_BLIT_PIECE, c->piece);')
k('render piece number unchecked', 'if (c->piece < 1 || c->piece > CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;', '(void)0;')
k('render piece number above ten accepted', 'if (c->piece < 1 || c->piece > CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;', 'if (c->piece < 1 || c->piece > CPZ_PIECES_MAX + 1) return CPZ_ERR_BOUNDS;')
k('render piece number ten refused', 'if (c->piece < 1 || c->piece > CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;', 'if (c->piece < 1 || c->piece >= CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;')
k('render negative piece number accepted', 'if (c->piece < 1 || c->piece > CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;', 'if (c->piece > CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;')
k('render piece number one refused', 'if (c->piece < 1 || c->piece > CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;', 'if (c->piece < 2 || c->piece > CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;')
k('render piece kind', 'add_blit(out, CPZ_BLIT_PIECE, c->piece, object->surface, body,\n                         B_PIECE_SRC + (size_t)(c->piece - 1) * 16u, c->rect, host);', 'add_blit(out, CPZ_BLIT_TARGET, c->piece, object->surface, body,\n                         B_PIECE_SRC + (size_t)(c->piece - 1) * 16u, c->rect, host);')
k('render piece number lost', 'add_blit(out, CPZ_BLIT_PIECE, c->piece, object->surface, body,', 'add_blit(out, CPZ_BLIT_PIECE, 0, object->surface, body,')
k('render piece source', 'B_PIECE_SRC + (size_t)(c->piece - 1) * 16u, c->rect, host);', 'B_PIECE_SRC + (size_t)(c->piece) * 16u, c->rect, host);')
k('render piece source stride', 'B_PIECE_SRC + (size_t)(c->piece - 1) * 16u, c->rect, host);', 'B_PIECE_SRC + (size_t)(c->piece - 1) * 8u, c->rect, host);')
k('render piece destination', 'B_PIECE_SRC + (size_t)(c->piece - 1) * 16u, c->rect, host);', 'B_PIECE_SRC + (size_t)(c->piece - 1) * 16u, c->base, host);')
k('render piece surface', 'add_blit(out, CPZ_BLIT_PIECE, c->piece, object->surface, body,', 'add_blit(out, CPZ_BLIT_PIECE, c->piece, 0u, body,')
# --- the host completeness check -----------------------------------------------------------------------------------------------
HOST_FIELDS = ('alloc_slot', 'register_slot', 'load_surface', 'set_slot_surface', 'release_surface', 'release_slot', 'mark_dirty',
               'view_origin', 'clear_pending_item', 'sound_prepare', 'sound_stop', 'sound_play', 'sound_busy', 'tick',
               'event_flag_invalid', 'transition', 'store_event_flag')
for _field in HOST_FIELDS:
    k(f'host check lost: {_field}', f'host->{_field} != NULL', '1')


# --- the binding ---------------------------------------------------------------------------------------------------------------
def b(name, old, new):
    add(BINDING, 'binding ' + name, old, new)


b('rows of other types copied', 'if (info.type != SESSION_AD3_TYPE) continue;', '(void)0;')
b('bad body accepted', 'if (cpz_validate_body(info.typed_body, info.typed_body_length, &why) != CPZ_OK) {', 'if (0) {')
b('bad body failure text lost', 'binding->failure = why;\n            return CPZ_ERR_BODY;', 'binding->failure = "none";\n            return CPZ_ERR_BODY;')
b('bad body status', 'binding->failure = why;\n            return CPZ_ERR_BODY;', 'binding->failure = why;\n            return CPZ_ERR_ARGUMENT;')
b('row error status', 'binding->failure = "0xd3-scene-row";\n            return CPZ_ERR_BODY;', 'binding->failure = "0xd3-scene-row";\n            return CPZ_OK;')
b('row error text', '"0xd3-scene-row"', '"x"')
b('allocation error text', '"0xd3-row-allocation"', '"x"')
b('previous scene not cleared', 'if (cpz_cleanup(&binding->object, &binding->host.kernel) != CPZ_OK) {\n        free(rows);\n        binding->failure = "0xd3-scene-clear";', 'if (0) {\n        free(rows);\n        binding->failure = "0xd3-scene-clear";')
b('clear failure ignored', 'binding->failure = "0xd3-scene-clear";\n        return CPZ_ERR_HOST;', 'binding->failure = "0xd3-scene-clear";\n        return CPZ_OK;')
b('clear failure text', '"0xd3-scene-clear"', '"x"')
b('rows not replaced', 'binding->rows = rows;\n    binding->count = count;', 'free(rows);')
b('row count not replaced', 'binding->rows = rows;\n    binding->count = count;', 'binding->rows = rows;')
b('old rows leaked', 'free(binding->rows);\n    binding->rows = rows;', 'binding->rows = rows;')
b('failure not reset', 'binding->count = count;\n    binding->failure = "none";', 'binding->count = count;')
b('scene clear resets the grid', 'binding->rows = rows;\n    binding->count = count;', 'cpz_grid_reset(&binding->world);\n    binding->rows = rows;\n    binding->count = count;')
b('destroy does not clear', '(void)cpz_cleanup(&binding->object, &binding->host.kernel);\n    free(binding->rows);', 'free(binding->rows);')
b('row copy skipped', 'memcpy(rows[i].body, info.typed_body, CPZ_BODY_BYTES);\n        rows[i].present = 1u;', 'rows[i].present = 1u;')
b('row not marked present', 'rows[i].present = 1u;', '(void)0;')
b('foreign row accepted', 'action->type != SESSION_AD3_TYPE ||', '0 ||')
b('absent row accepted', '|| binding->rows[index].present == 0u) {', ') {')
b('row index unchecked', 'index >= binding->count ||', '0 ||')
b('row text', '"0xd3-row-not-owned"', '"x"')
b('handler uses the wrong body', 'binding->rows[index].body, CPZ_BODY_BYTES, (int16_t)index', 'binding->rows[0].body, CPZ_BODY_BYTES, (int16_t)index')
b('handler uses the wrong row number', 'CPZ_BODY_BYTES, (int16_t)index, before->phase', 'CPZ_BODY_BYTES, 1, before->phase')
b('handler uses the wrong phase', 'CPZ_BODY_BYTES, (int16_t)index, before->phase', 'CPZ_BODY_BYTES, (int16_t)index, 1u')
b('unsupported becomes an error', 'if (status == CPZ_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;', 'if (status == CPZ_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_ERROR;')
b('errors are accepted', 'if (status != CPZ_OK) return SCENE_ACTION_HANDLER_ERROR;', '(void)0;')
b('world stored only on init', '(result.initialized != 0u || result.completed != 0u) &&', '(result.initialized != 0u) &&')
b('world stored only on completion', '(result.initialized != 0u || result.completed != 0u) &&', '(result.completed != 0u) &&')
b('world stored on every visit', '(result.initialized != 0u || result.completed != 0u) &&', '1 &&')
b('world store context', 'binding->host.store_world(binding->host.kernel.context, &binding->world)', 'binding->host.store_world(NULL, &binding->world)')
b('world hook required', 'binding->host.store_world != NULL)', '1)')
b('phase before kept', 'out->phase = result.phase_after;', 'out->phase = before->phase;')
b('completion left pending', 'result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_PENDING')
b('every visit completes', 'result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_COMPLETED')
b('failure text lost', 'binding->failure = why != NULL ? why : "none";', 'binding->failure = "none";')
b('active body row check', 'if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;', 'if (row < 0 || binding->rows[row].present == 0u) return NULL;')
b('pointer on an inactive puzzle', 'if (binding->object.active == 0) return CPZ_OK; /* 0x462c39 returns 0 without touching anything */', '(void)0;')
b('pointer result not cleared', 'memset(out, 0, sizeof(*out));\n    out->candidate = -1;\n    if (binding->object.active == 0) return CPZ_OK; /* 0x462c39', 'out->candidate = -1;\n    if (binding->object.active == 0) return CPZ_OK; /* 0x462c39')
b('pointer candidate default', 'out->candidate = -1;\n    if (binding->object.active == 0) return CPZ_OK; /* 0x462c39', 'out->candidate = 0;\n    if (binding->object.active == 0) return CPZ_OK; /* 0x462c39')
b('pointer without a view origin provider accepted', 'if (binding->host.kernel.view_origin == NULL ||\n        binding->host.kernel.view_origin(binding->host.kernel.context, &view_x, &view_y) != 0) {', 'if (binding->host.kernel.view_origin(binding->host.kernel.context, &view_x, &view_y) != 0) {')
b('pointer origin failure ignored', 'binding->host.kernel.view_origin(binding->host.kernel.context, &view_x, &view_y) != 0) {', 'binding->host.kernel.view_origin(binding->host.kernel.context, &view_x, &view_y) < 0) {')
b('pointer origin failure status', 'binding->failure = "0xd3-pointer-origin";\n        return CPZ_ERR_HOST;', 'binding->failure = "0xd3-pointer-origin";\n        return CPZ_OK;')
b('pointer origin failure text', '"0xd3-pointer-origin"', '"x"')
b('pointer origin swapped', 'cpz_pointer(&binding->object, &binding->world, body, CPZ_BODY_BYTES, x, y, view_x, view_y, out)', 'cpz_pointer(&binding->object, &binding->world, body, CPZ_BODY_BYTES, x, y, view_y, view_x, out)')
b('pointer origin not passed', 'cpz_pointer(&binding->object, &binding->world, body, CPZ_BODY_BYTES, x, y, view_x, view_y, out)', 'cpz_pointer(&binding->object, &binding->world, body, CPZ_BODY_BYTES, x, y, 0, 0, out)')
b('pointer coordinates swapped', 'cpz_pointer(&binding->object, &binding->world, body, CPZ_BODY_BYTES, x, y, view_x, view_y, out)', 'cpz_pointer(&binding->object, &binding->world, body, CPZ_BODY_BYTES, y, x, view_x, view_y, out)')
b('pointer uses the wrong world', 'cpz_pointer(&binding->object, &binding->world,', 'cpz_pointer(&binding->object, NULL,')
b('click on an inactive puzzle', 'memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;\n    if (binding->object.active == 0) return CPZ_OK;', 'memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;')
b('click result not cleared', 'memset(out, 0, sizeof(*out));\n    out->new_phase = row_phase;\n    if (binding->object.active == 0)', 'out->new_phase = row_phase;\n    if (binding->object.active == 0)')
b('click phase not preset', 'out->new_phase = row_phase;\n    if (binding->object.active == 0) return CPZ_OK;', 'if (binding->object.active == 0) return CPZ_OK;')
b('click failure text', 'binding->failure = status == CPZ_OK ? "none" : "0xd3-click";', 'binding->failure = "none";')
b('click failure text name', '"0xd3-click"', '"x"')
b('click row phase passed wrong', 'CPZ_BODY_BYTES, row_phase, candidate, start_flag', 'CPZ_BODY_BYTES, 1u, candidate, start_flag')
b('click candidate passed wrong', 'CPZ_BODY_BYTES, row_phase, candidate, start_flag', 'CPZ_BODY_BYTES, row_phase, 0x277f, start_flag')
b('click start flag passed wrong', 'CPZ_BODY_BYTES, row_phase, candidate, start_flag', 'CPZ_BODY_BYTES, row_phase, candidate, 1')
b('invalidate dropped', 'return cpz_invalidate(&binding->object, &binding->host.kernel);', 'return CPZ_OK;')
b('grid reset dropped', 'cpz_grid_reset(&binding->world);\n}', '(void)0;\n}')
b('render without a slot', 'if (binding->object.slot == CPZ_NO_SLOT) return CPZ_OK; /* no render entry: 0x463b10 is never called */', '(void)0;')
b('render result not cleared', 'memset(out, 0, sizeof(*out));\n    if (binding->object.slot == CPZ_NO_SLOT)', 'if (binding->object.slot == CPZ_NO_SLOT)')
b('render uses the wrong body', 'cpz_render(&binding->object, &binding->world, body, CPZ_BODY_BYTES, &binding->host.kernel, out)', 'cpz_render(&binding->object, &binding->world, binding->rows[1].body, CPZ_BODY_BYTES, &binding->host.kernel, out)')
b('render failure text', 'binding->failure = status == CPZ_OK ? "none" : "0xd3-render";', 'binding->failure = "none";')
b('render failure text name', '"0xd3-render"', '"x"')
b('registered always', 'return binding != NULL && binding->object.slot != CPZ_NO_SLOT ? 1u : 0u;', 'return binding != NULL ? 1u : 0u;')
b('world accessor lost', 'return binding == NULL ? NULL : &binding->world;', 'return NULL;')
b('unbound failure text', '"0xd3-binding-unbound"', '"none"')
b('create keeps no host', 'binding->host = *host;', '(void)0;')
b('create keeps a dirty object', 'cpz_object_reset(&binding->object);\n        binding->failure', 'binding->failure')


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


# Mutants that cannot change observable behaviour; each entry needs a written reason.
EQUIVALENT = {
    'pointer quarter without the bias':
        'For a negative cell width the quarter is negative with or without the +3 bias (floor vs truncation differ only below 4); '
        'every zone test (left, right, up, down) is then an empty integer interval, so no pointer position can tell them apart.',
    'render restore for the wrong moved value':
        '`moved == 1` vs `moved != 0`: the kernel only ever writes 0 or 1 to the moved flag (phase 0, the idle visit and the arrival '
        'step), so the two tests agree on every reachable object.',
    'binding row error status':
        'scene_resource_action_at cannot fail for an index below scene_resource_action_count of a parsed scene; the branch is a '
        'defensive return that no scene can reach (no fault injection exists for the parser).',
    'binding row error text':
        'Same unreachable defensive branch as binding row error status; only its failure text differs.',
    'binding allocation error text':
        'The calloc failure branch cannot be reached without allocator fault injection; only its failure text differs.',
}


def sanitizer_compiler(tmp):
    """The first compiler that builds the unit cases with ASan + UBSan, or None. Memory-unsafe mutants (an unchecked row
    index, a loop one past the array) are only visible to a sanitizer build."""
    for cc in (compiler(), shutil.which('gcc')):
        if cc is not None and compile_c(Path(tmp) / 'probe_san', TEST_C, SOURCES, extra=SANITIZE, cc=cc).returncode == 0:
            return cc
    return None


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'd3_test'
        built = compile_c(cls.binary, TEST_C, SOURCES, extra=('-Werror', '-Wno-error=type-limits'))
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
        """ASan + UBSan (and leak checking) over the same cases: rejected bodies, failed host calls, random valid bodies."""
        for cc in (compiler(), shutil.which('gcc')):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'd3_test_san'
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

    def test_mutation_anchors_are_unique(self):
        """Every mutant must apply to exactly one place of the current source and change it."""
        for filename, mutations in MUTANTS.items():
            text = (SRC / filename).read_text()
            for name, (old, new) in mutations.items():
                with self.subTest(name):
                    self.assertEqual(text.count(old), 1, f'anchor drifted: {old[:70]!r}')
                    self.assertNotEqual(old, new)

    def test_mutations_are_detected(self):
        """The cases must fail when a recovered rule is deliberately broken (every non-equivalent mutant is killed)."""
        jobs = []
        for filename, mutations in MUTANTS.items():
            for name, (old, new) in mutations.items():
                if name not in EQUIVALENT:
                    jobs.append((filename, name, old, new))

        san_cc = sanitizer_compiler(self.tmp.name)
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
                verdict = 'killed'  # a hang is a detected difference
            shutil.rmtree(work, ignore_errors=True)
            return name, verdict, ''

        with concurrent.futures.ThreadPoolExecutor(max_workers=min(8, os.cpu_count() or 2)) as pool:
            outcomes = list(pool.map(build_and_run, enumerate(jobs)))
        self.assertEqual(len({name for _, name, _, _ in jobs}), len(jobs), 'duplicate mutant names')
        killed = sum(1 for _, verdict, _ in outcomes if verdict == 'killed')
        for name, verdict, detail in outcomes:
            with self.subTest(name):
                self.assertEqual(verdict, 'killed', f'mutant {verdict}: {name} {detail}')
        print(f'mutants killed: {killed} of {len(jobs)} ({len(EQUIVALENT)} recorded equivalent, not run)')


class Corpus(unittest.TestCase):
    def test_real_rows_validate_and_play_through_the_binding(self):
        """The real raw 0xd3 rows (resources 2190 and 2194, three rows) pass the native body validation, set the grid up, make
        every possible move in each direction, solve their puzzle, finish, and a second pass cancels (derived counts only; the
        decoded resources stay in work/)."""
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'd3_corpus'
            built = compile_c(binary, CORPUS_C, SOURCES, extra=('-Wno-error=type-limits',))
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-600:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {key: int(v) for key, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['solved'], summary['canceled'], summary['error']),
                         (2, 3, 3, 3, 0))
        self.assertEqual(summary['loads'], summary['releases'])
        for direction in ('left', 'up', 'down', 'right'):
            self.assertGreater(summary['moves_' + direction], 0, direction)
        self.assertEqual(summary['unsolvable'], 0)
        self.assertEqual(done.stdout.count('SCENE_FAIL') + done.stdout.count('ROW_FAIL'), 0)


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_d3_runtime.sh')],
                              capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())


class Registration(unittest.TestCase):
    def test_module_is_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        self.assertIn(' action_family_d3_runtime session_bindings_ad3', build)


if __name__ == '__main__':
    unittest.main()
