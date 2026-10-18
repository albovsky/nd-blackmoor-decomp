"""RT-60: raw 0xee Memory puzzle runtime (src/action_family_ee_runtime.c) and the session binding
(src/session_bindings_aee.c).

Facts under test (original GAME.EXE, handler 0x47c0f0 and its helpers as recorded in src/action_family_ee_runtime.h and in
tasks/RT-60-memory-puzzle-ee-runtime.md; the comparison with the original x86 code is the oracle's job, see
tests/test_action_family_ee_runtime_oracle.py):
 * phase 0 lays out the tiles, registers the render entry, loads the overlay surface and deals the pictures; phase 1 is an inner
   state machine (play, win / lose sound pick and wait); phase 2 leaves through the win or lose block, reports the generic
   completion and clears the object;
 * the pointer receiver (page tabs, tiles, the 3-pixel shrink), the click (flip, pair, mismatch with the flip-back delay, tries),
   the sound and caption helpers, invalidate, cleanup and the render plan;
 * the session binding: row bodies copied and validated per scene, the render entry, the scene clear.
The unit cases live in tests/action_family_ee_runtime_test.c (synthetic bodies, no original bytes) and the corpus check in
tests/action_family_ee_runtime_corpus.c (the two real rows of resource 926).
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
TEST_C = PROJECT / 'tests/action_family_ee_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_ee_runtime_corpus.c'
KERNEL = 'action_family_ee_runtime.c'
BINDING = 'session_bindings_aee.c'
SUPPORT = ['scene_resource.c', 'hiff.c']
SOURCES = [KERNEL, BINDING, *SUPPORT]
EXPECTED_UNIT_TESTS = 26
RESOURCES = PROJECT.parents[1] / 'work/analysis/hiff-resources'
CORPUS_ROWS = ('0926.bin',)
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


# --- generated mutants: every named offset constant of the kernel moved, every simple statement dropped ---------------------------
def shift_constants():
    text = source(KERNEL)
    for match in re.finditer(r'\b([A-Z][A-Z0-9_]*) = (0x[0-9a-fA-F]+)(?=[,\s])', text):
        name, value = match.group(1), int(match.group(2), 16)
        if name in ('CAPTION_TEXT_MAX',) or name.startswith('MP_'):
            continue
        anchor = match.group(0)
        if text.count(anchor) != 1:
            continue
        step = 1 if name.startswith('SND_KEY_BYTES') or name.startswith('SND_TEXT_BYTES') else 4
        k(f'constant {name}', anchor, f'{name} = 0x{value + step:x}')


shift_constants()


def drop_statements():
    text = source(KERNEL)
    lines = text.split('\n')
    for number, line in enumerate(lines):
        stripped = line.strip()
        if not re.match(r'^(wr_32|wr_16|HOST|CHECK|memset|memcpy|result->\w+ = )\(?.*;$', stripped) or stripped.endswith('{'):
            continue
        if 'return' in stripped and not stripped.startswith(('HOST', 'CHECK')):
            continue
        anchor = line
        back = 1
        while text.count(anchor) != 1 and back < 8 and number - back >= 0:
            anchor = lines[number - back] + '\n' + anchor
            back += 1
        if text.count(anchor) != 1:
            continue
        indent = line[:len(line) - len(line.lstrip())]
        k(f'statement dropped (line {number + 1}) {stripped[:70]}', anchor, anchor.replace(line, indent + '(void)0;'))


drop_statements()

# --- targeted kernel mutants -------------------------------------------------------------------------------------------------------
k('no sound exact length', 'return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, sizeof k - 1) == 0;')
k('caption suffix', 'memcpy(buf + n, "<n><e>", 7);', 'memcpy(buf + n, "<n><f>", 7);')
k('caption local size', 'CAPTION_LOCAL_BYTES = 104', 'CAPTION_LOCAL_BYTES = 105')
k('caption text limit', 'CAPTION_TEXT_MAX = 0x9c40', 'CAPTION_TEXT_MAX = 0x9c3f')
k('caption text limit (one more)', 'CAPTION_TEXT_MAX = 0x9c40', 'CAPTION_TEXT_MAX = 0x9c41')
k('slot label', '#define LABEL_SLOT "WHALESURVIVOR GAME PUZZLE OVERLAYS"', '#define LABEL_SLOT "WHALESURVIVOR GAME PUZZLE OVERLAY"')
k('surface tag', '#define TAG_SURFACE "Memory Puzzle Overlay Surface"', '#define TAG_SURFACE "Memory Puzzle Overlay"')
k('start flag value', 'HOST(host->set_start_flag(host->context, 1));', 'HOST(host->set_start_flag(host->context, 0));')
k('ids floor value', 'if (rd_s32(b, O_IDS) <= 4) wr_32(b, O_IDS, 4);', 'if (rd_s32(b, O_IDS) <= 4) wr_32(b, O_IDS, 5);')
k('ids floor limit', 'if (rd_s32(b, O_IDS) <= 4) wr_32(b, O_IDS, 4);', 'if (rd_s32(b, O_IDS) <= 5) wr_32(b, O_IDS, 4);')
k('needed floor value', 'if (rd_s32(b, O_NEEDED) <= 2) wr_32(b, O_NEEDED, 2);', 'if (rd_s32(b, O_NEEDED) <= 2) wr_32(b, O_NEEDED, 3);')
k('needed floor limit', 'if (rd_s32(b, O_NEEDED) <= 2) wr_32(b, O_NEEDED, 2);', 'if (rd_s32(b, O_NEEDED) <= 3) wr_32(b, O_NEEDED, 2);')
k('needed from the wrong half', 'scaled(rd_s32(body, B_PCT_NEEDED), rd_s32(b, O_HALF_TOTAL), &v);', 'scaled(rd_s32(body, B_PCT_NEEDED), rd_s32(b, O_HALF_PAGE), &v);')
k('ids from the wrong count', 'scaled(rd_s32(body, B_PCT_IDS), rd_s32(b, O_SLOTS), &v);', 'scaled(rd_s32(body, B_PCT_IDS), rd_s32(b, O_TOTAL), &v);')
k('slots from columns only', 'mul32(rd_s32(body, B_SLOT_COLS), rd_s32(body, B_SLOT_ROWS))', 'mul32(rd_s32(body, B_SLOT_COLS), rd_s32(body, B_SLOT_COLS))')
k('float precision of the scaling', 'const double q = (double)(float)pct / 100.0;', 'const double q = (double)pct / 100.0;')
k('float precision of the count', 'const double p = q * (double)(float)count;', 'const double p = q * (double)count;')
k('scaling rounds', '*out = (int32_t)p;', '*out = (int32_t)(p + 0.5);')
for edge, (old, new) in {
        'top': ('add32(rd_s32(body, r + 4), 3) <= y', 'add32(rd_s32(body, r + 4), {}) <= y'),
        'bottom': ('y <= add32(rd_s32(body, r + 12), -3)', 'y <= add32(rd_s32(body, r + 12), -{})'),
        'left': ('add32(rd_s32(body, r), 3) <= x', 'add32(rd_s32(body, r), {}) <= x'),
        'right': ('x <= add32(rd_s32(body, r + 8), -3)', 'x <= add32(rd_s32(body, r + 8), -{})')}.items():
    for n in (2, 4):
        k(f'tile shrink {edge} {n}', old, new.format(n))
k('tile hit uses the view', 'add32(rd_s32(body, r + 4), 3) <= y', 'add32(add32(rd_s32(body, r + 4), rd_s32(b, O_VIEW + 4)), 3) <= y')
k('tab edge top', 'rd_s32(body, k + 4) <= y', 'rd_s32(body, k) <= y')
k('tab edge bottom', 'y <= rd_s32(body, k + 12)', 'y <= rd_s32(body, k + 8)')
k('tab edge left', 'rd_s32(body, k) <= x', 'rd_s32(body, k + 4) <= x')
k('tab edge right', 'x <= rd_s32(body, k + 8)', 'x <= rd_s32(body, k + 12)')
k('tab page stride (pointer)', '(size_t)rd_s32(b, O_PAGE) * 0x30u + (size_t)j * 0x10u', '(size_t)rd_s32(b, O_PAGE) * 0x20u + (size_t)j * 0x10u')
k('tab rectangle stride (pointer)', '(size_t)rd_s32(b, O_PAGE) * 0x30u + (size_t)j * 0x10u', '(size_t)rd_s32(b, O_PAGE) * 0x30u + (size_t)j * 0x08u')
k('tab page stride (phase 0)', '(size_t)rd_s32(b, O_LOOP_I) * 0x30u + (size_t)rd_s32(b, O_LOOP_J) * 0x10u', '(size_t)rd_s32(b, O_LOOP_I) * 0x20u + (size_t)rd_s32(b, O_LOOP_J) * 0x10u')
k('tab rectangle stride (phase 0)', '(size_t)rd_s32(b, O_LOOP_I) * 0x30u + (size_t)rd_s32(b, O_LOOP_J) * 0x10u', '(size_t)rd_s32(b, O_LOOP_I) * 0x30u + (size_t)rd_s32(b, O_LOOP_J) * 0x08u')
k('tab rectangle count (pointer)', 'for (int32_t j = 0; j < 3; ++j) {', 'for (int32_t j = 0; j < 2; ++j) {')
k('tab rectangle count (phase 0)', 'rd_s32(b, O_LOOP_J) < 3;', 'rd_s32(b, O_LOOP_J) < 2;')
k('tile rectangle y uses the x origin', 'add32(rd_s32(body, s + 4), rd_s32(b, O_VIEW + 4))', 'add32(rd_s32(body, s + 4), rd_s32(b, O_VIEW))')
k('tile rectangle x uses the y origin', 'wr_32(b, d, add32(rd_s32(body, s), rd_s32(b, O_VIEW)));', 'wr_32(b, d, add32(rd_s32(body, s), rd_s32(b, O_VIEW + 4)));')
k('tile rectangle stride', 's = B_TILES + i * 16u, d = O_TILE_RECTS + i * 16u;', 's = B_TILES + i * 16u, d = O_TILE_RECTS + i * 8u;')
k('tab target y uses the x origin', 'wr_32(b, O_TAB_TARGET + 4, add32(rd_s32(body, B_TAB_TARGET + 4), rd_s32(b, O_VIEW + 4)));', 'wr_32(b, O_TAB_TARGET + 4, add32(rd_s32(body, B_TAB_TARGET + 4), rd_s32(b, O_VIEW)));')
k('tab target right uses the y origin', 'wr_32(b, O_TAB_TARGET + 8, add32(rd_s32(body, B_TAB_TARGET + 8), rd_s32(b, O_VIEW)));', 'wr_32(b, O_TAB_TARGET + 8, add32(rd_s32(body, B_TAB_TARGET + 8), rd_s32(b, O_VIEW + 4)));')
k('restore source', 'blit_plan(plan, 0, MP_LABEL_BACKGROUND, NULL, 0, view.clip, b, O_VIEW_COPY);', 'blit_plan(plan, 0, MP_LABEL_BACKGROUND, NULL, 0, view.view, b, O_VIEW_COPY);')
k('restore destination', 'blit_plan(plan, 0, MP_LABEL_BACKGROUND, NULL, 0, view.clip, b, O_VIEW_COPY);', 'blit_plan(plan, 0, MP_LABEL_BACKGROUND, NULL, 0, view.clip, b, O_VIEW);')
k('tab picture page stride', 'B_TAB_SRC + (size_t)rd_s32(b, O_PAGE) * 0x10u', 'B_TAB_SRC + (size_t)rd_s32(b, O_PAGE) * 0x20u')
k('picture rectangle stride', 'B_PICTURES + (size_t)id * 16u', 'B_PICTURES + (size_t)id * 8u')
k('picture id range', 'if (id < 0 || id >= MP_MAX_IDS) return MP_ERR_BOUNDS;', 'if (id < 0 || id > MP_MAX_IDS) return MP_ERR_BOUNDS;')
k('block choice', 'const size_t block = rd_s32(b, O_WON) != 0 ? B_BLOCK_WIN : B_BLOCK_LOSE;', 'const size_t block = rd_s32(b, O_LOST) != 0 ? B_BLOCK_LOSE : B_BLOCK_WIN;')
k('block flag value width', 'rd_s16(body, block + 0x18)', 'body[block + 0x18]')
k('block flag index offset', 'rd_s16(body, block + 0x16) != MP_NO_FLAG', 'rd_s16(body, block + 0x14) != MP_NO_FLAG')
k('block start flag', 't.start_flag = rd_s16(body, block + 0x14) != 1;', 't.start_flag = rd_s16(body, block + 0x14) != 0;')
k('block scene', 't.scene = rd_s16(body, block);', 't.scene = rd_s16(body, block + 2);')
k('block word 1', 't.word[0] = rd_s16(body, block + 2);', 't.word[0] = rd_s16(body, block + 4);')
k('block word 2', 't.word[1] = rd_s16(body, block + 4);', 't.word[1] = rd_s16(body, block + 2);')
k('block word 3', 't.word[2] = rd_s16(body, block + 6);', 't.word[2] = rd_s16(body, block + 4);')
k('block dword 1', 't.dword[0] = rd_s32(body, block + 8);', 't.dword[0] = rd_s32(body, block + 12);')
k('block dword 2', 't.dword[1] = rd_s32(body, block + 12);', 't.dword[1] = rd_s32(body, block + 8);')
k('block dword 3', 't.dword[2] = rd_s32(body, block + 16);', 't.dword[2] = rd_s32(body, block + 12);')
k('delay is unsigned 16', 'host->tick(host->context) + (uint32_t)rd_s32(body, B_DELAY)', 'host->tick(host->context) + (uint32_t)(uint16_t)rd_s32(body, B_DELAY)')
k('deadline signed compare', 'rd_u32(b, O_DEADLINE) < host->tick(host->context)', 'rd_s32(b, O_DEADLINE) < (int32_t)host->tick(host->context)')
k('first cell pointer', 'wr_32(b, O_FIRST, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * MP_CELL_BYTES));', 'wr_32(b, O_FIRST, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * 8u));')
k('second cell pointer', 'wr_32(b, O_SECOND, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * MP_CELL_BYTES));', 'wr_32(b, O_SECOND, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * 8u));')
k('flip sound 1 record', 'CHECK(play_record(body, B_SND_FLIP1, host));', 'CHECK(play_record(body, B_SND_FLIP2, host));')
k('flip sound 2 record', 'CHECK(play_record(body, B_SND_FLIP2, host));', 'CHECK(play_record(body, B_SND_FLIP1, host));')
k('match list', 'pick_and_play(object, body, B_SND_MATCH, 5, O_SND_MATCH, host)', 'pick_and_play(object, body, B_SND_MATCH, 4, O_SND_MATCH, host)')
k('wrong list (click)', 'if (rd_s32(b, O_LOST) == 0) CHECK(pick_and_play(object, body, B_SND_WRONG, 10,', 'if (rd_s32(b, O_LOST) == 0) CHECK(pick_and_play(object, body, B_SND_WRONG, 9,')
k('win list', 'pick_and_play(object, body, B_SND_WIN, 10, O_SND_WIN, host)', 'pick_and_play(object, body, B_SND_WIN, 9, O_SND_WIN, host)')
k('lose list', 'case MP_STATE_LOSE_PICK:\n            CHECK(pick_and_play(object, body, B_SND_WRONG, 10,', 'case MP_STATE_LOSE_PICK:\n            CHECK(pick_and_play(object, body, B_SND_WRONG, 9,')
k('match field', 'pick_and_play(object, body, B_SND_MATCH, 5, O_SND_MATCH, host)', 'pick_and_play(object, body, B_SND_MATCH, 5, O_SND_WRONG, host)')
k('win wait channel record', 'rd_s16(body, B_SND_WIN + (size_t)rd_s32(b, O_SND_WIN) * MP_SOUND_RECORD_BYTES + SND_CHANNEL)', 'rd_s16(body, B_SND_WIN + (size_t)rd_s32(b, O_SND_WIN) * MP_SOUND_RECORD_BYTES)')
k('lose wait channel record', 'rd_s16(body, B_SND_WRONG + (size_t)rd_s32(b, O_SND_WRONG) * MP_SOUND_RECORD_BYTES + SND_CHANNEL)', 'rd_s16(body, B_SND_WRONG + (size_t)rd_s32(b, O_SND_WIN) * MP_SOUND_RECORD_BYTES + SND_CHANNEL)')
k('pick modulus', 'wr_32(b, field, host->random(host->context) % count);', 'wr_32(b, field, host->random(host->context) % (count + 1));')
k('id pick modulus', '        *id = host->random(host->context) % ids;\n    } while', '        *id = host->random(host->context) % (ids + 1);\n    } while')
k('id pick (all used) modulus', '    if (!any_free) {\n        *id = host->random(host->context) % ids;', '    if (!any_free) {\n        *id = host->random(host->context) % (ids + 1);')
k('partner modulus', 'r = host->random(host->context) % span;', 'r = host->random(host->context) % (span + 1);')
k('id marked used', 'wr_32(o->used, (size_t)*id * 4u, 1);', 'wr_32(o->used, (size_t)*id * 4u, 2);')
k('pick limit', 'if (++draws > MP_PICK_LIMIT) return MP_ERR_STUCK;\n        r =', 'if (++draws > MP_PICK_LIMIT + 1) return MP_ERR_STUCK;\n        r =')
k('page deal partner span', 'CHECK(draw_partner(o, host, page * per_page, per_page, &partner));', 'CHECK(draw_partner(o, host, page * per_page, total, &partner));')
k('page deal partner base', 'CHECK(draw_partner(o, host, page * per_page, per_page, &partner));', 'CHECK(draw_partner(o, host, 0, per_page, &partner));')
k('shuffle partner span', 'CHECK(draw_partner(o, host, 0, total, &partner));', 'CHECK(draw_partner(o, host, 0, per_page, &partner));')
k('shuffle on one page', 'if (pages == 1 || body[B_SHUFFLE_ALL] == 0) {', 'if (body[B_SHUFFLE_ALL] == 0) {')
k('validate shuffle on one page', 'const int shuffle_all = pages > 1 && body[B_SHUFFLE_ALL] != 0;', 'const int shuffle_all = body[B_SHUFFLE_ALL] != 0;')
k('validate odd count', 'if ((shuffle_all ? per_page * pages : per_page) % 2 != 0)', 'if ((shuffle_all ? per_page * pages : per_page * pages) % 2 != 0)')
k('validate sound lists', '{B_SND_MATCH, 5}, {B_SND_WRONG, 10}, {B_SND_WIN, 10}', '{B_SND_MATCH, 4}, {B_SND_WRONG, 10}, {B_SND_WIN, 10}')
k('validate wrong list', '{B_SND_MATCH, 5}, {B_SND_WRONG, 10}, {B_SND_WIN, 10}', '{B_SND_MATCH, 5}, {B_SND_WRONG, 9}, {B_SND_WIN, 10}')
k('validate win list', '{B_SND_MATCH, 5}, {B_SND_WRONG, 10}, {B_SND_WIN, 10}', '{B_SND_MATCH, 5}, {B_SND_WRONG, 10}, {B_SND_WIN, 9}')
k('validate name span', 'field_terminated(body, B_NAME, 0x21)', 'field_terminated(body, B_NAME, 0x20)')
k('validate key span', 'field_terminated(body, r + SND_KEY, SND_KEY_BYTES)', 'field_terminated(body, r + SND_KEY, SND_KEY_BYTES - 1)')
k('validate text span', 'field_terminated(body, r + SND_TEXT, SND_TEXT_BYTES)', 'field_terminated(body, r + SND_TEXT, SND_TEXT_BYTES - 1)')
k('validate sound name span', 'field_terminated(body, r + SND_NAME, 0x21)', 'field_terminated(body, r + SND_NAME, 0x20)')
k('validate length', 'if (body == NULL || length < MP_BODY_BYTES) {', 'if (body == NULL || length < MP_BODY_BYTES - 1) {')
k('tab hit index bound', 'rd_s32(b, O_HIT) >= rd_s32(body, B_PAGES)', 'rd_s32(b, O_HIT) > rd_s32(body, B_PAGES)')
k('tab sound channel', 'host->sound_play(host->context, MP_FLIP_CHANNEL)', 'host->sound_play(host->context, MP_FLIP_CHANNEL + 1)')
k('cell index range', 'd / MP_CELL_BYTES >= (uint32_t)MP_MAX_CELLS', 'd / MP_CELL_BYTES > (uint32_t)MP_MAX_CELLS')
k('cell index base', 'if (ptr < MP_GUEST_CELLS) return -1;', 'if (ptr <= MP_GUEST_CELLS) return -1;')
k('cell index alignment', 'd % MP_CELL_BYTES != 0u ||', 'd % 4u != 0u ||')

# --- targeted binding mutants ----------------------------------------------------------------------------------------------------
b('create requires the host', 'if (host == NULL || !host_complete(&host->kernel)) return NULL;', 'if (host == NULL) return NULL;')
b('create requires a complete host', 'h->event_flag_invalid != NULL && h->transition != NULL && h->store_event_flag != NULL && h->complete != NULL;', 'h->event_flag_invalid != NULL && h->transition != NULL && h->store_event_flag != NULL;')
b('create checks the view', 'return h->view != NULL && h->set_start_flag != NULL', 'return h->set_start_flag != NULL')
b('create checks the random source', 'h->tick != NULL && h->sound_prepare', 'h->sound_prepare')
b('row handle', 'return (uint32_t)index + 1u;', 'return (uint32_t)index;')
b('row type check', 'if (info.type != SESSION_AEE_TYPE) continue;', 'if (info.type != SESSION_AEE_TYPE + 1) continue;')
b('validation skipped', 'if (mp_validate_body(info.typed_body, info.typed_body_length, &why) != MP_OK) {', 'if (0) {')
b('row not marked present', '        rows[i].present = 1u;\n', '')
b('body not copied', 'memcpy(rows[i].body, info.typed_body, MP_BODY_BYTES);', '(void)0;')
b('row count not stored', '    binding->count = count;\n', '')
b('old rows kept', '    free(binding->rows);\n    binding->rows = rows;', '    binding->rows = rows;')
b('scene clear skipped', '    if (session_aee_cleanup(binding) != MP_OK) {\n        free(rows);', '    if (0) {\n        free(rows);')
b('scene clear failure ignored', '        binding->failure = "0xee-scene-clear";\n        return MP_ERR_HOST;', '        binding->failure = "0xee-scene-clear";')
b('handler type check', 'action->type != SESSION_AEE_TYPE ||', 'action->type != SESSION_AEE_TYPE + 1 ||')
b('handler row index', 'binding->rows[index].body, MP_BODY_BYTES, body_handle(index), (int16_t)index,', 'binding->rows[index].body, MP_BODY_BYTES, body_handle(index), 0,')
b('handler phase', '(int16_t)index, before->phase,', '(int16_t)index, 0,')
b('unsupported mapping', 'if (status == MP_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;', '(void)0;')
b('error mapping', 'if (status != MP_OK) return SCENE_ACTION_HANDLER_ERROR;', '(void)0;')
b('completion disposition', 'result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_PENDING')
b('phase reported', '    out->phase = result.phase_after;\n', '')
b('failure text kept', 'binding->failure = why != NULL ? why : "none";\n    if (status == MP_ERR_UNSUPPORTED)', 'if (status == MP_ERR_UNSUPPORTED)')
b('pointer defaults', '    out->candidate = -1;\n    if (!mp_object_active', '    if (!mp_object_active')
b('pointer when inactive', '    if (!mp_object_active(&binding->object)) return MP_OK; /* 0x47b4aa', '    /* 0x47b4aa')
b('click body handle', 'body_handle((size_t)mp_object_row(&binding->object))', 'body_handle(0u)')
b('click when inactive', '    if (!mp_object_active(&binding->object)) return MP_OK;\n    body = active_body(binding);\n    if (body == NULL) return MP_ERR_ARGUMENT;\n    status = mp_click', '    body = active_body(binding);\n    if (body == NULL) return MP_ERR_ARGUMENT;\n    status = mp_click')
b('click failure text', 'binding->failure = status == MP_OK ? "none" : "0xee-click";', 'binding->failure = "none";')
b('pointer failure text', 'binding->failure = status == MP_OK ? "none" : "0xee-pointer";', 'binding->failure = "none";')
b('render without entry', '    if (mp_object_slot(&binding->object) == MP_NO_SLOT) { /* no render entry', '    if (0) { /* no render entry')
b('render failure text', 'binding->failure = status == MP_OK ? "none" : "0xee-render";', 'binding->failure = "none";')
b('registered', 'return binding != NULL && mp_object_slot(&binding->object) != MP_NO_SLOT ? 1u : 0u;', 'return binding != NULL && mp_object_active(&binding->object) ? 1u : 0u;')
b('destroy clears the puzzle', '    (void)session_aee_cleanup(binding);\n    free(binding->rows);', '    free(binding->rows);')

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

# Mutants that cannot change observable behaviour, each with the reason.
EQUIVALENT = {
    'constant BLOCK_BYTES':
        'the constant is declared and never used',
    'statement dropped (line 194) wr_32(b, O_SURFACE, 0);':
        'object_clear runs only at the end of mp_cleanup, which has already zeroed the surface after a successful release; a failed release returns before it',
    'statement dropped (line 195) wr_32(b, O_CELLS, 0);':
        'the cell-table guest pointer is zeroed twice in mp_cleanup (conditional store and object_clear)',
    'statement dropped (line 196) wr_32(b, O_USED, 0);':
        'the used-table guest pointer is zeroed twice in mp_cleanup (conditional store and object_clear)',
    'statement dropped (line 386) wr_32(c, 4, 0);':
        'memset(o->cells, 0) just above already zeroed the second and third word of every cell',
    'statement dropped (line 387) wr_32(c, 8, 0);':
        'memset(o->cells, 0) just above already zeroed the second and third word of every cell',
    'statement dropped (line 432) wr_32(b, O_REDRAW, 1);':
        'mp_step phase 0 stores the redraw flag again after deal, and deal is called only from there',
    'statement dropped (line 443) wr_32(b, O_SURFACE, 0);':
        'object_clear zeroes the same cell a few lines later in the same function',
    'statement dropped (line 575) wr_32(b, O_REDRAW, 1);':
        'deal (its only caller) has already stored the redraw flag, and a failing deal returns before this line',
    'float precision of the scaling':
        'the counts are at most 36 and the results are clamped to the 4/2 minimum and the slot/half-total maximum, so only percentages above 2^24 (not exact in float32) could differ, and those are clamped to the same bound',
    'float precision of the count':
        'counts are at most 72, exactly representable as float32',
    'validate shuffle on one page':
        'with one page per_page * pages equals per_page, and pages >= 1 is validated before',
    "auto if (a >= 'A' && a <= 'Z') a += 0x20u; #0 >=":
        'the only letters of the "NO SOUND" key are N O S U D, so folding or not folding the boundary letters A and Z changes no comparison',
    "auto if (a >= 'A' && a <= 'Z') a += 0x20u; #2 <=":
        'the only letters of the "NO SOUND" key are N O S U D, so folding or not folding the boundary letters A and Z changes no comparison',
    "auto if (b >= 'A' && b <= 'Z') b += 0x20u; #0 >=":
        'the only letters of the "NO SOUND" key are N O S U D, so folding or not folding the boundary letters A and Z changes no comparison',
    "auto if (b >= 'A' && b <= 'Z') b += 0x20u; #2 <=":
        'the only letters of the "NO SOUND" key are N O S U D, so folding or not folding the boundary letters A and Z changes no comparison',
    'auto if (!(p > -2147483648.0 && p < 2147483648.0)) return 0; #0 >':
        'with counts of at most 36 the product never leaves the int32 range, so the range guard is never taken',
    'auto if (!(p > -2147483648.0 && p < 2147483648.0)) return 0; #1 &&':
        'with counts of at most 36 the product never leaves the int32 range, so the range guard is never taken',
    'auto if (!(p > -2147483648.0 && p < 2147483648.0)) return 0; #2 <':
        'with counts of at most 36 the product never leaves the int32 range, so the range guard is never taken',
    'auto const int shuffle_all = pages > 1 && body[B_SHUFFLE_ALL] != 0; #0 >':
        'with one page per_page * pages equals per_page, and pages >= 1 is validated before',
    'auto else if (rd_s32(body, B_PCT_NEEDED) != -1 && !scaled(rd_s32(body, B_PCT_NEEDED), per_page * pages / 2, &t)) #0 !=':
        'scaled cannot fail for counts of at most 36, so the guard never rejects a body',
    'auto if (!field_terminated(body, r + SND_NAME, 0x21)) why = "0xee-unterminated-sound-name"; #0 +':
        'SND_NAME is 0, so adding or subtracting it is the same address',
    'auto if (!no_sound_ci(rec + SND_NAME)) { #0 +':
        'SND_NAME is 0, so adding or subtracting it is the same address',
    'auto if (!no_sound_ci(body + base + (size_t)i * MP_SOUND_RECORD_BYTES + SND_NAME)) found = 1; #2 +':
        'SND_NAME is 0, so adding or subtracting it is the same address',
    'auto } while (no_sound_ci(body + base + (size_t)rd_s32(b, field) * MP_SOUND_RECORD_BYTES + SND_NAME)); #2 +':
        'SND_NAME is 0, so adding or subtracting it is the same address',
    'auto if (rd_s32(b, O_IDS) <= 4) wr_32(b, O_IDS, 4); #0 <=':
        'at equality the store writes the value already there',
    'auto if (!(rd_s32(b, O_IDS) < rd_s32(b, O_SLOTS))) wr_32(b, O_IDS, rd_s32(b, O_SLOTS)); #0 <':
        'at equality the store writes the value already there',
    'auto if (rd_s32(b, O_NEEDED) <= 2) wr_32(b, O_NEEDED, 2); #0 <=':
        'at equality the store writes the value already there',
    'auto if (!(rd_s32(b, O_NEEDED) < rd_s32(b, O_HALF_TOTAL))) wr_32(b, O_NEEDED, rd_s32(b, O_HALF_TOTAL)); #0 <':
        'at equality the store writes the value already there',
    'auto for (int32_t i = 0; i < total; ++i) #0 <':
        'the extra pass reads one cell past the table, inside MpObject (the following member), whose first word is never -1; the sanitizers do not see an in-object overread',
    'auto if (rd_s32(b, O_CELLS) != 0) wr_32(b, O_CELLS, 0); #0 !=':
        'object_clear stores zero to the same cell right after, so the conditional store is redundant',
    'auto if (rd_s32(b, O_USED) != 0) wr_32(b, O_USED, 0); #0 !=':
        'object_clear stores zero to the same cell right after, so the conditional store is redundant',
    'auto HOST(host->load_surface(host->context, (const char *)body + B_NAME, TAG_SURFACE, &surface)); #0 +':
        'B_NAME is 0, so adding or subtracting it is the same address',
    'auto no_sound_exact(body + B_SND_WIN + (size_t)rd_s32(b, O_SND_WIN) * MP_SOUND_RECORD_BYTES + SND_NAME)) #0 +':
        'after the pick, a record that is not -1 is never a case-insensitive NO SOUND, so the exact compare is false at the right address and false at the wrong one (other body bytes are not "NO SOUND")',
    'auto no_sound_exact(body + B_SND_WIN + (size_t)rd_s32(b, O_SND_WIN) * MP_SOUND_RECORD_BYTES + SND_NAME)) #2 +':
        'SND_NAME is 0, so adding or subtracting it is the same address',
    'auto no_sound_exact(body + B_SND_WRONG + (size_t)rd_s32(b, O_SND_WRONG) * MP_SOUND_RECORD_BYTES + SND_NAME)) #0 +':
        'after the pick, a record that is not -1 is never a case-insensitive NO SOUND, so the exact compare is false at the right address and false at the wrong one (other body bytes are not "NO SOUND")',
    'auto no_sound_exact(body + B_SND_WRONG + (size_t)rd_s32(b, O_SND_WRONG) * MP_SOUND_RECORD_BYTES + SND_NAME)) #2 +':
        'SND_NAME is 0, so adding or subtracting it is the same address',
}

# Mutants the unit cases do not kill yet. test_known_gaps_are_exactly_the_survivors keeps this list honest in both directions.
# Both guard a row index above 32,767; the unit cases do not build a scene with that many action rows.
KNOWN_GAPS = (
    'binding auto binding->rows[index].present == 0u || index > (size_t)INT16_MAX) { #1 ||',
    'binding auto binding->rows[index].present == 0u || index > (size_t)INT16_MAX) { #2 >',
)

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
        cls.binary = Path(cls.tmp.name) / 'aee_test'
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
        out = Path(self.tmp.name) / 'aee_test_san'
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
    def test_real_rows_validate_and_play_through_the_binding(self):
        """The two real raw 0xee rows (resource 926) pass the native body validation, are played perfectly through the binding
        (every pair found, page changes, the flip-back delay after a mismatch, the win exit) and lost by running out of tries
        (derived counts only; the decoded resource stays in work/)."""
        files = [RESOURCES / name for name in CORPUS_ROWS]
        if not all(path.exists() for path in files):
            self.skipTest('local corpus evidence (work/) is not present')
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'aee_corpus'
            built = compile_c(binary, CORPUS_C, SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-600:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {key: int(v) for key, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['validated'], summary['error']), (1, 2, 2, 0))
        self.assertEqual((summary['pages'], summary['tiles'], summary['pairs']), (2, 48, 48))
        self.assertEqual((summary['wins'], summary['loses'], summary['win_exits'], summary['lose_exits']), (2, 0, 2, 2))
        self.assertEqual((summary['flipbacks'], summary['blocked'], summary['mismatches']), (2, 2, 2))
        self.assertEqual(summary['nav_fail'], 0)
        self.assertEqual(summary['caption_bounds'], 0)
        self.assertEqual(done.stdout.count('ROW_FAIL') + done.stdout.count('SCENE_FAIL'), 0)


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_ee_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())


class Registration(unittest.TestCase):
    def test_module_is_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        self.assertIn(' action_family_ee_runtime session_bindings_aee', build)


if __name__ == '__main__':
    unittest.main()
