"""RT-57: raw 0x1c, the interactive video (src/session_bindings_a1c.c over src/action_family_1c_runtime.c).

Facts under test (original GAME.EXE, dispatcher 0x427a50 arm 0x427cc3 with gate mode 1 -> handler 0x4cb586 on the singleton 0x63847b):
 * phase 0 loads the ".IV" file (0x4cbba9: 33-byte name, entry count, entries of {id, hotspot count, byte, word, word} each followed
   by count * 24 bytes of rectangles) and waits until the movie player (0x637fcf) is in state 2 with the file's clip name; then it
   optionally registers the z entry (type 15, callback 0x4cc79a), reads the held-item word 0x583a29 and continues with phase 1;
 * phase 1 follows the player's hotspot index (player state 2 or 3 keeps the row alive, anything else makes it phase 2); a new
   index translates the entry's rectangles by the player's origin and raises the changed flag the render callback consumes;
 * phase 2 releases the z entry, frees the file and completes the row with the generic completion (0x42ba3a).
The unit cases live in tests/action_family_1c_runtime_test.c (synthetic in-memory ".IV" files: the real ones are game data and not
in the repository); the corpus driver runs the 2 real rows (scenes S2186 and S3420); the executor driver runs synthetic rows
through the production scene executor. The original-x86 oracle is another worker's file.
"""
import concurrent.futures
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/action_family_1c_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_1c_runtime_corpus.c'
EXECUTOR_C = PROJECT / 'tests/action_family_1c_runtime_executor.c'
KERNEL_SOURCES = ['session_bindings_a1c.c', 'action_family_1c_runtime.c', 'action_family_1c.c']
CORPUS_SOURCES = KERNEL_SOURCES + ['scene_resource.c', 'hiff.c']
EXECUTOR_SOURCES = CORPUS_SOURCES + ['scene_executor.c', 'scene_conditions.c', 'scene_dependencies.c', 'action_family_64.c',
                                     'action_core.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 29

sys.path.insert(0, str(PROJECT / 'tests'))
import test_scene_executor as base  # noqa: E402


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


SANITIZE = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined']


def compile_c(output, main_c, sources, src_dir=SRC, extra=(), werror=True, cc=None):
    cmd = [cc or compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', *(['-Werror'] if werror else []), '-O1', '-g',
           *extra, f'-I{src_dir}', str(main_c), *[str(Path(src_dir) / s) for s in sources], '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


def sanitizers_work(tmp):
    """(a compiler with an ASan/UBSan runtime or None, whether LeakSanitizer works). The default compiler may lack the runtime
    (clang without compiler-rt), so gcc is tried too."""
    probe = Path(tmp) / 'probe.c'
    probe.write_text('#include <stdlib.h>\nint main(void){ volatile char *p = malloc(7); p[0] = 1; p = 0; return 0; }\n')
    out = Path(tmp) / 'probe'
    for cc in dict.fromkeys(c for c in (compiler(), shutil.which('gcc'), shutil.which('cc')) if c):
        built = subprocess.run([cc, '-g', '-O0', *SANITIZE, str(probe), '-o', str(out)], capture_output=True, text=True)
        if built.returncode != 0:
            continue
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1')
        done = subprocess.run([str(out)], capture_output=True, text=True, env=env)
        return cc, done.returncode != 0 and 'LeakSanitizer' in done.stderr
    return None, False


def run_unit(binary, leaks=False):
    env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1' if leaks else 'detect_leaks=0')
    done = subprocess.run([str(binary)], capture_output=True, text=True, env=env)
    results = {}
    for line in done.stdout.splitlines():
        status, _, rest = line.partition(' ')
        if status in ('PASS', 'FAIL'):
            name, _, message = rest.partition(': ')
            results[name] = (status, message)
    return done.returncode, results


def mutated_copy(tmp, filename, old, new, tag='mut'):
    original = (SRC / filename).read_text()
    assert original.count(old) == 1, 'mutation anchor drifted: ' + old
    work = Path(tmp) / tag
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir()
    for item in SRC.iterdir():
        if item.suffix == '.h' or item.name in EXECUTOR_SOURCES:
            shutil.copy(item, work / item.name)
    (work / filename).write_text(original.replace(old, new, 1))
    return work


def body1c(name=b'CLIP', render=1):
    body = bytearray(105)
    body[:len(name)] = name
    body[0x21:0x23] = render.to_bytes(2, 'little')
    return bytes(body)


def flag_is(index, value):
    return base.condition(2, index, value)


def scene_ungated():
    # subtype 0: the generic completion would leave the completion byte alone, the original stores it directly
    return base.scene_bytes([base.action(0x1c, 0, body1c())])


def scene_gated():
    return base.scene_bytes([base.action(0x1c, 1, body1c(), (flag_is(3, 1),))])


def scene_repeating():
    return base.scene_bytes([base.action(0x1c, 2, body1c())])


K, B = 'action_family_1c_runtime.c', 'session_bindings_a1c.c'
DISPOSITION = '''out->disposition = outcome.disposition == SCENE_ACTION_HANDLER_COMPLETED && action->subtype != 2u
                           ? SCENE_ACTION_HANDLER_DIRECT_COMPLETED
                           : outcome.disposition;'''
# each mutant must be caught by the unit cases; entries are (old, new) or (old, new, 'leak') when only a leak checker can see it
MUTANTS = {
    K: {
        # c1c_free_iv (0x4cbb00)
        'free_iv accepts a null object': ('if (object == NULL || object->iv == NULL) {', 'if (object->iv == NULL) {'),
        'free_iv ignores the loaded file': ('if (object == NULL || object->iv == NULL) {', 'if (object == NULL) {'),
        'free_iv skips the rectangles': ('        free(object->iv->entries[i].rects);\n    }\n    free(object->iv->entries);', '    }\n    free(object->iv->entries);', 'leak'),
        'free_iv skips the last entry': ('for (i = 0; i < object->iv->count; ++i) {\n        free(object->iv->entries[i].rects);', 'for (i = 0; i < object->iv->count - 1; ++i) {\n        free(object->iv->entries[i].rects);', 'leak'),
        'free_iv skips the entries': ('    free(object->iv->entries);\n    free(object->iv);', '    free(object->iv);', 'leak'),
        'free_iv skips the file': ('    free(object->iv->entries);\n    free(object->iv);', '    free(object->iv->entries);', 'leak'),
        'free_iv keeps the pointer': ('    free(object->iv);\n    object->iv = NULL;', '    free(object->iv);'),
        'free_iv keeps the record': ('    object->iv = NULL;\n    object->record = NULL;\n}', '    object->iv = NULL;\n}'),
        # read_exact, le16, le32
        'read_exact inverted': ('return host->read(host->context, file, buffer, size) == size;', 'return host->read(host->context, file, buffer, size) != size;'),
        'read_exact accepts any non-empty read': ('return host->read(host->context, file, buffer, size) == size;', 'return host->read(host->context, file, buffer, size) != 0u;'),
        'le16 high byte shift': ('(p[0] | (p[1] << 8))', '(p[0] | (p[1] << 7))'),
        'le16 high byte dropped': ('(p[0] | (p[1] << 8))', '(p[0])'),
        'le16 unsigned': ('return (int16_t)(uint16_t)(p[0] | (p[1] << 8));', 'return (int16_t)(uint16_t)(p[0] | (p[1] << 8)) & 0x7fff;'),
        'le32 byte 1 shift': ('((uint32_t)p[1] << 8)', '((uint32_t)p[1] << 7)'),
        'le32 byte 2 shift': ('((uint32_t)p[2] << 16)', '((uint32_t)p[2] << 15)'),
        'le32 byte 3 shift': ('((uint32_t)p[3] << 24)', '((uint32_t)p[3] << 23)'),
        'le32 byte 3 dropped': ('| ((uint32_t)p[3] << 24)', ''),
        # load_iv (0x4cbba9)
        'empty name accepted': ('if (length == 0u || length >= C1C_BODY_BYTES) {', 'if (length >= C1C_BODY_BYTES) {'),
        'unterminated name accepted': ('if (length == 0u || length >= C1C_BODY_BYTES) {', 'if (length == 0u) {'),
        'name limit off by one': ('if (length == 0u || length >= C1C_BODY_BYTES) {', 'if (length == 0u || length >= C1C_BODY_BYTES - 1u) {'),
        'name scan stops early': ('for (length = 0u; length < C1C_BODY_BYTES && body[length] != 0u; ++length) {', 'for (length = 0u; length < C1C_BODY_BYTES - 1u && body[length] != 0u; ++length) {'),
        'open failure ignored': ('if (host->open_iv(host->context, name, &file) != 0 || file == NULL) {', 'if (0) {'),
        'null file accepted': ('if (host->open_iv(host->context, name, &file) != 0 || file == NULL) {', 'if (host->open_iv(host->context, name, &file) != 0) {'),
        'open result inverted': ('if (host->open_iv(host->context, name, &file) != 0 || file == NULL) {', 'if (host->open_iv(host->context, name, &file) == 0 || file == NULL) {'),
        'open failure is a host error': ('if (host->open_iv(host->context, name, &file) != 0 || file == NULL) { /* 0x4cbc58 */\n        return C1C_ERR_FILE;',
                                         'if (host->open_iv(host->context, name, &file) != 0 || file == NULL) { /* 0x4cbc58 */\n        return C1C_ERR_HOST;'),
        'name read size': ('read_exact(host, file, iv->name, C1C_NAME_BYTES)', 'read_exact(host, file, iv->name, C1C_NAME_BYTES - 1u)'),
        'count read size': ('read_exact(host, file, count_bytes, 4u)', 'read_exact(host, file, count_bytes, 3u)'),
        'name read skipped': ('if (!read_exact(host, file, iv->name, C1C_NAME_BYTES) || !read_exact(host, file, count_bytes, 4u)) {', 'if (!read_exact(host, file, count_bytes, 4u)) {'),
        'count read skipped': ('if (!read_exact(host, file, iv->name, C1C_NAME_BYTES) || !read_exact(host, file, count_bytes, 4u)) {', 'if (!read_exact(host, file, iv->name, C1C_NAME_BYTES)) {'),
        'count read unchecked': ('|| !read_exact(host, file, count_bytes, 4u)) {', '|| (read_exact(host, file, count_bytes, 4u), 0)) {'),
        'negative entry count accepted': ('if (iv->count < 0 || iv->count > C1C_MAX_ENTRIES) {', 'if (iv->count > C1C_MAX_ENTRIES) {'),
        'zero entries refused': ('if (iv->count < 0 || iv->count > C1C_MAX_ENTRIES) {', 'if (iv->count <= 0 || iv->count > C1C_MAX_ENTRIES) {'),
        'entry limit exclusive': ('if (iv->count < 0 || iv->count > C1C_MAX_ENTRIES) {', 'if (iv->count < 0 || iv->count >= C1C_MAX_ENTRIES) {'),
        'entry limit dropped': ('if (iv->count < 0 || iv->count > C1C_MAX_ENTRIES) {', 'if (iv->count < 0) {'),
        'count stored unsigned': ('iv->count = le32(count_bytes);', 'iv->count = (int32_t)(le32(count_bytes) & 0xffffu);'),
        'entry loop stops early': ('for (i = 0; i < iv->count; ++i) {\n            C1cEntry *e = &iv->entries[i];', 'for (i = 0; i < iv->count - 1; ++i) {\n            C1cEntry *e = &iv->entries[i];'),
        'id read size': ('if (!read_exact(host, file, b2, 2u)) goto fail_entries;     /* 0x4cbd9c: id */', 'if (!read_exact(host, file, b2, 1u)) goto fail_entries;     /* 0x4cbd9c: id */'),
        'id dropped': ('e->id = le16(b2);', 'e->id = 0;'),
        'id from the wrong field': ('e->id = le16(b2);\n            if (!read_exact(host, file, b2, 2u)) goto fail_entries;     /* 0x4cbdc8: hotspot count */\n            e->count = le16(b2);',
                                    'e->count = le16(b2);\n            if (!read_exact(host, file, b2, 2u)) goto fail_entries;     /* 0x4cbdc8: hotspot count */\n            e->id = le16(b2);'),
        'hotspot count dropped': ('e->count = le16(b2);', 'e->count = 1;'),
        'byte read skipped': ('if (!read_exact(host, file, b1, 1u)) goto fail_entries;     /* 0x4cbdf0 */', ''),
        'byte dropped': ('e->byte_4 = b1[0];', 'e->byte_4 = 0;'),
        'word 5 dropped': ('e->word_5 = le16(b2);', 'e->word_5 = 0;'),
        'word 7 dropped': ('e->word_7 = le16(b2);', 'e->word_7 = 0;'),
        'word 5 from the wrong field': ('e->word_5 = le16(b2);', 'e->word_5 = e->id;'),
        'word 7 from the wrong field': ('e->word_7 = le16(b2);', 'e->word_7 = e->word_5;'),
        'rectangle count zero accepted': ('if (e->count <= 0 || e->count > C1C_MAX_RECTS) goto fail_entries;', 'if (e->count < 0 || e->count > C1C_MAX_RECTS) goto fail_entries;'),
        'rectangle count negative accepted': ('if (e->count <= 0 || e->count > C1C_MAX_RECTS) goto fail_entries;', 'if (e->count == 0 || e->count > C1C_MAX_RECTS) goto fail_entries;'),
        'rectangle limit exclusive': ('if (e->count <= 0 || e->count > C1C_MAX_RECTS) goto fail_entries;', 'if (e->count <= 0 || e->count >= C1C_MAX_RECTS) goto fail_entries;'),
        'rectangle limit dropped': ('if (e->count <= 0 || e->count > C1C_MAX_RECTS) goto fail_entries;', 'if (e->count <= 0) goto fail_entries;'),
        'rectangle read size': ('read_exact(host, file, raw, C1C_RECT_BYTES)', 'read_exact(host, file, raw, C1C_RECT_BYTES - 4u)'),
        'rectangle loop stops early': ('for (j = 0; j < e->count; ++j) {                             /* one fread', 'for (j = 0; j < e->count - 1; ++j) {                         /* one fread'),
        'rectangle field order': ('e->rects[j].d[k] = le32(raw + 4 * k);', 'e->rects[j].d[k] = le32(raw + 4 * (5 - k));'),
        'rectangle field dropped': ('e->rects[j].d[k] = le32(raw + 4 * k);', 'e->rects[j].d[k] = k == 4 ? 0 : le32(raw + 4 * k);'),
        'rectangle field 0 dropped': ('e->rects[j].d[k] = le32(raw + 4 * k);', 'e->rects[j].d[k] = k == 0 ? 0 : le32(raw + 4 * k);'),
        'rectangle field 5 dropped': ('e->rects[j].d[k] = le32(raw + 4 * k);', 'e->rects[j].d[k] = k == 5 ? 0 : le32(raw + 4 * k);'),
        'file not closed on success': ('    host->close(host->context, file);                                    /* 0x4cbf06 */\n    object->iv = iv;', '    object->iv = iv;'),
        'file closed twice on success': ('    host->close(host->context, file);                                    /* 0x4cbf06 */\n    object->iv = iv;', '    host->close(host->context, file);\n    host->close(host->context, file);\n    object->iv = iv;'),
        'file not stored': ('    object->iv = iv;\n    return C1C_OK;\nfail_entries:', '    free(iv->entries);\n    free(iv);\n    return C1C_OK;\nfail_entries:'),
        'file not closed on failure': ('    free(iv->entries);\n    free(iv);\n    host->close(host->context, file);\n    return C1C_ERR_FILE;', '    free(iv->entries);\n    free(iv);\n    return C1C_ERR_FILE;'),
        'failure keeps the file': ('    free(iv->entries);\n    free(iv);\n    host->close(host->context, file);\n    return C1C_ERR_FILE;', '    free(iv->entries);\n    host->close(host->context, file);\n    object->iv = iv;\n    return C1C_ERR_FILE;'),
        'failure leaks the rectangles': ('fail_entries:\n    for (i = 0; i < iv->count; ++i) {\n        free(iv->entries[i].rects);\n    }\n', 'fail_entries:\n', 'leak'),
        'failure leaks the entries': ('fail:\n    free(iv->entries);\n    free(iv);', 'fail:\n    free(iv);', 'leak'),
        'failure leaks the file': ('fail:\n    free(iv->entries);\n    free(iv);', 'fail:\n    free(iv->entries);', 'leak'),
        'failure returns ok': ('    host->close(host->context, file);\n    return C1C_ERR_FILE;\n}', '    host->close(host->context, file);\n    return C1C_OK;\n}'),
        # find_entry (0x4cb944), names_equal
        'find_entry without a file': ('    if (object->iv == NULL) {\n        return NULL;\n    }\n    for (i = 0; i < object->iv->count; ++i) {\n        if (object->iv->entries[i].id == index) {', '    for (i = 0; i < object->iv->count; ++i) {\n        if (object->iv->entries[i].id == index) {'),
        'find_entry reads one entry too many': ('for (i = 0; i < object->iv->count; ++i) {\n        if (object->iv->entries[i].id == index) {', 'for (i = 0; i <= object->iv->count; ++i) {\n        if (object->iv->entries[i].id == index) {'),
        'find_entry stops early': ('for (i = 0; i < object->iv->count; ++i) {\n        if (object->iv->entries[i].id == index) {', 'for (i = 0; i < object->iv->count - 1; ++i) {\n        if (object->iv->entries[i].id == index) {'),
        'find_entry takes the last match': ('        if (object->iv->entries[i].id == index) {\n            return &object->iv->entries[i];', '        if (object->iv->entries[i].id == index && (i + 1 >= object->iv->count || object->iv->entries[i + 1].id != index)) {\n            return &object->iv->entries[i];'),
        'find_entry compares the wrong way': ('if (object->iv->entries[i].id == index) {', 'if (object->iv->entries[i].id != index) {'),
        'find_entry compares unsigned': ('if (object->iv->entries[i].id == index) {', 'if ((uint16_t)object->iv->entries[i].id == (uint16_t)index && index >= 0) {'),
        'names_equal mismatch accepted': ('if (a[i] != b[i]) return 0;', ''),
        'names_equal always unequal on the first byte': ('if (a[i] != b[i]) return 0;', 'if (a[i] != b[i] || i == 0) return 0;'),
        'names_equal ignores the terminator': ('if (a[i] == 0) return 1;', ''),
        'names_equal stops one byte early': ('for (i = 0; i < C1C_NAME_BYTES; ++i) {\n        if (a[i] != b[i]) return 0;', 'for (i = 0; i < C1C_NAME_BYTES - 1; ++i) {\n        if (a[i] != b[i]) return 0;'),
        'names_equal compares one byte': ('        if (a[i] == 0) return 1;\n    }\n    return 1;', '        return 1;\n    }\n    return 1;'),
        'names_equal fails at the end': ('        if (a[i] == 0) return 1;\n    }\n    return 1;', '        if (a[i] == 0) return 1;\n    }\n    return 0;'),
        # c1c_visit (0x4cb586)
        'null object accepted': ('if (object == NULL || body == NULL || host == NULL', 'if (body == NULL || host == NULL'),
        'null body accepted': ('|| body == NULL || host == NULL', '|| host == NULL'),
        'null host accepted': ('|| host == NULL || outcome == NULL', '|| outcome == NULL'),
        'null outcome accepted': ('|| outcome == NULL || host->player_state == NULL', '|| host->player_state == NULL'),
        'missing player_state accepted': ('host->player_state == NULL ||\n        host->player_name', 'host->player_name'),
        'missing player_name accepted': ('host->player_name == NULL || host->player_hotspot', 'host->player_hotspot'),
        'missing player_hotspot accepted': ('host->player_hotspot == NULL || host->player_origin', 'host->player_origin'),
        'missing player_origin accepted': ('host->player_origin == NULL || host->open_iv', 'host->open_iv'),
        'missing open_iv accepted': ('host->open_iv == NULL ||\n        host->read', 'host->read'),
        'missing read accepted': ('host->read == NULL || host->close', 'host->close'),
        'missing close accepted': ('host->close == NULL || host->alloc_slot', 'host->alloc_slot'),
        'missing alloc_slot accepted': ('host->alloc_slot == NULL || host->register_slot', 'host->register_slot'),
        'missing register_slot accepted': ('host->register_slot == NULL ||\n        host->release_slot', 'host->release_slot'),
        'missing release_slot accepted': ('host->release_slot == NULL || host->cell_583a29 == NULL) {', 'host->cell_583a29 == NULL) {'),
        'missing cell accepted': ('host->release_slot == NULL || host->cell_583a29 == NULL) {', 'host->release_slot == NULL) {'),
        'initial phase dropped': ('outcome->phase = phase;', 'outcome->phase = 0u;'),
        'initial disposition completed': ('outcome->disposition = SCENE_ACTION_HANDLER_PENDING;', 'outcome->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
        'phase limit': ('if (phase > 2u) {', 'if (phase > 3u) {'),
        'phase limit low': ('if (phase > 2u) {', 'if (phase >= 2u) {'),
        'phase 2 compare': ('if (phase == 2u) {', 'if (phase == 3u) {'),
        'phase 2 release skipped': ('        if (object->slot != -1) {\n            if (host->release_slot', '        if (0) {\n            if (host->release_slot'),
        'phase 2 release always': ('        if (object->slot != -1) {\n            if (host->release_slot', '        if (1) {\n            if (host->release_slot'),
        'phase 2 release inverted': ('        if (object->slot != -1) {\n            if (host->release_slot', '        if (object->slot == -1) {\n            if (host->release_slot'),
        'phase 2 release failure ignored': ('if (host->release_slot(host->context, object->slot) != 0) return C1C_ERR_HOST;', 'host->release_slot(host->context, object->slot);'),
        'phase 2 releases the wrong slot': ('host->release_slot(host->context, object->slot)', 'host->release_slot(host->context, (int16_t)(object->slot + 1))'),
        'phase 2 keeps the file': ('        c1c_free_iv(object);\n        object->body = NULL;', '        object->body = NULL;'),
        'phase 2 keeps the body': ('        object->body = NULL;\n        object->slot = -1;\n        object->armed = 0;', '        object->slot = -1;\n        object->armed = 0;'),
        'phase 2 keeps the slot': ('        object->slot = -1;\n        object->armed = 0;', '        object->armed = 0;'),
        'phase 2 keeps the armed flag': ('        object->armed = 0;\n        object->changed = 0;', '        object->changed = 0;'),
        'phase 2 keeps the changed flag': ('        object->changed = 0;\n        object->record = NULL;\n        object->dword_14e = 0;', '        object->record = NULL;\n        object->dword_14e = 0;'),
        'phase 2 dword 14e': ('        object->dword_14e = 0;\n        object->dword_154 = 0;\n        object->dword_158 = 0;', '        object->dword_14e = 1;\n        object->dword_154 = 0;\n        object->dword_158 = 0;'),
        'phase 2 dword 154': ('        object->dword_154 = 0;\n        object->dword_158 = 0;', '        object->dword_154 = 1;\n        object->dword_158 = 0;'),
        'phase 2 dword 158': ('        object->dword_158 = 0;\n        object->last_index = -1;', '        object->dword_158 = 1;\n        object->last_index = -1;'),
        'phase 2 last index': ('        object->dword_158 = 0;\n        object->last_index = -1;', '        object->dword_158 = 0;\n        object->last_index = 0;'),
        'phase 2 keeps the last index': ('        object->last_index = -1;\n        object->origin_present = 0;\n        outcome->phase = 0u;', '        object->origin_present = 0;\n        outcome->phase = 0u;'),
        'phase 2 keeps the origin flag': ('        object->origin_present = 0;\n        outcome->phase = 0u;', '        outcome->phase = 0u;'),
        'phase 2 stays pending': ('outcome->disposition = SCENE_ACTION_HANDLER_COMPLETED;           /* 0x42ba3a */', 'outcome->disposition = SCENE_ACTION_HANDLER_PENDING;'),
        'phase 2 completes directly': ('outcome->disposition = SCENE_ACTION_HANDLER_COMPLETED;           /* 0x42ba3a */', 'outcome->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;'),
        'phase 0 compare': ('if (phase == 0u) {\n        uint8_t name', 'if (phase == 1u) {\n        uint8_t name'),
        'body pointer not kept': ('    object->body = body;                                                 /* 0x4cb5a4: stored on every visit */', ''),
        'body pointer kept only in phase 0': ('    object->body = body;                                                 /* 0x4cb5a4: stored on every visit */\n    if (phase > 2u) {', '    if (phase > 2u) {'),
        'phase 2 keeps the phase': ('        outcome->phase = 0u;                                             /* 0x42ba3a leaves the phase word 0 */\n', ''),
        'phase 2 stores phase 2': ('outcome->phase = 0u;                                             /* 0x42ba3a leaves the phase word 0 */', 'outcome->phase = 2u;'),
        'load always': ('if (object->iv == NULL) {\n            status = load_iv', 'if (1) {\n            status = load_iv'),
        'load never': ('if (object->iv == NULL) {\n            status = load_iv', 'if (0) {\n            status = load_iv'),
        'load failure ignored': ('if (status != C1C_OK) return status;', ''),
        'load failure is a host error': ('if (status != C1C_OK) return status;', 'if (status != C1C_OK) return C1C_ERR_HOST;'),
        'state failure ignored in phase 0': ('        if (host->player_state(host->context, &state) != 0) return C1C_ERR_HOST;\n        if (state != 2) return C1C_OK;', '        host->player_state(host->context, &state);\n        if (state != 2) return C1C_OK;'),
        'state compare': ('if (state != 2) return C1C_OK;', 'if (state != 3) return C1C_OK;'),
        'state compare relaxed': ('if (state != 2) return C1C_OK;', 'if (state < 2) return C1C_OK;'),
        'state compare any': ('if (state != 2) return C1C_OK;', 'if (state == 0) return C1C_OK;'),
        'name failure ignored': ('if (host->player_name(host->context, name) != 0) return C1C_ERR_HOST;', 'host->player_name(host->context, name);'),
        'name compare inverted': ('if (!names_equal(object->iv->name, name)) return C1C_OK;', 'if (names_equal(object->iv->name, name)) return C1C_OK;'),
        'name compare dropped': ('if (!names_equal(object->iv->name, name)) return C1C_OK;', ''),
        'slot not cleared': ('        object->slot = -1;                                               /* 0x4cb66a */', ''),
        'render word low byte only': ('if (le16(body + C1C_BODY_RENDER_WORD) != 0) {', 'if (body[C1C_BODY_RENDER_WORD] != 0) {'),
        'render word high byte only': ('if (le16(body + C1C_BODY_RENDER_WORD) != 0) {', 'if (body[C1C_BODY_RENDER_WORD + 1u] != 0) {'),
        'render word offset': ('if (le16(body + C1C_BODY_RENDER_WORD) != 0) {', 'if (le16(body + C1C_BODY_RENDER_WORD + 1u) != 0) {'),
        'render word offset before': ('if (le16(body + C1C_BODY_RENDER_WORD) != 0) {', 'if (le16(body + C1C_BODY_RENDER_WORD - 1u) != 0) {'),
        'render word inverted': ('if (le16(body + C1C_BODY_RENDER_WORD) != 0) {', 'if (le16(body + C1C_BODY_RENDER_WORD) == 0) {'),
        'render word ignored': ('if (le16(body + C1C_BODY_RENDER_WORD) != 0) {', 'if (1) {'),
        'alloc failure ignored': ('if (host->alloc_slot(host->context, &slot) != 0) return C1C_ERR_HOST;       /* 0x4cb690 */', 'host->alloc_slot(host->context, &slot);'),
        'slot not kept': ('            object->slot = slot;\n', ''),
        'register slot wrong': ('host->register_slot(host->context, slot, C1C_LABEL)', 'host->register_slot(host->context, (int16_t)(slot + 1), C1C_LABEL)'),
        'register label wrong': ('host->register_slot(host->context, slot, C1C_LABEL)', 'host->register_slot(host->context, slot, "INTERACTIVE VIDEO")'),
        'register failure ignored': ('if (host->register_slot(host->context, slot, C1C_LABEL) != 0) return C1C_ERR_HOST;', 'host->register_slot(host->context, slot, C1C_LABEL);'),
        'register skipped': ('if (host->register_slot(host->context, slot, C1C_LABEL) != 0) return C1C_ERR_HOST;', ''),
        'cell failure ignored': ('if (host->cell_583a29(host->context, &object->word_152) != 0) return C1C_ERR_HOST; /* 0x4cb76f */', 'host->cell_583a29(host->context, &object->word_152);'),
        'cell skipped': ('if (host->cell_583a29(host->context, &object->word_152) != 0) return C1C_ERR_HOST; /* 0x4cb76f */', ''),
        'cell read before the z entry': ('        object->slot = -1;                                               /* 0x4cb66a */', '        host->cell_583a29(host->context, &object->word_152);\n        object->slot = -1;                                               /* 0x4cb66a */'),
        'last index not reset': ('        object->last_index = -1;                                         /* 0x4cb79a */', ''),
        'last index reset to zero': ('        object->last_index = -1;                                         /* 0x4cb79a */', '        object->last_index = 0;'),
        'dword 154 not reset': ('        object->dword_154 = 0;\n        object->dword_14e = 0;\n        object->armed = 1;', '        object->dword_14e = 0;\n        object->armed = 1;'),
        'dword 14e not reset': ('        object->dword_14e = 0;\n        object->armed = 1;', '        object->armed = 1;'),
        'phase 0 dword 14e not cleared': ('        object->dword_14e = 0;\n        object->armed = 1;', '        object->armed = 1;'),
        'phase 0 dword 154 not cleared': ('        object->dword_154 = 0;\n        object->dword_14e = 0;\n        object->armed = 1;', '        object->dword_14e = 0;\n        object->armed = 1;'),
        'armed not set': ('        object->armed = 1;', ''),
        'armed set to 2': ('        object->armed = 1;', '        object->armed = 2;'),
        'origin flag not reset': ('        object->armed = 1;\n        object->origin_present = 0;', '        object->armed = 1;'),
        'phase 0 match stays in phase 0': ('        outcome->phase = 1u;                                             /* 0x4cb7e5: state := 1 */', ''),
        'phase 0 match jumps to phase 2': ('        outcome->phase = 1u;                                             /* 0x4cb7e5: state := 1 */', '        outcome->phase = 2u;'),
        # phase 1
        'stale changed flag kept': ('    object->changed = 0;                                                 /* 0x4cb7ff */', ''),
        'stale record kept': ('    object->record = NULL;\n    if (host->player_state(host->context, &state) != 0) return C1C_ERR_HOST;\n    if (state == 2 || state == 3) {', '    if (host->player_state(host->context, &state) != 0) return C1C_ERR_HOST;\n    if (state == 2 || state == 3) {'),
        'state failure ignored in phase 1': ('    if (host->player_state(host->context, &state) != 0) return C1C_ERR_HOST;\n    if (state == 2 || state == 3) {', '    host->player_state(host->context, &state);\n    if (state == 2 || state == 3) {'),
        'state 2 leaves the row': ('if (state == 2 || state == 3) {                                      /* 0x4cb81d */', 'if (state == 3) {'),
        'state 3 leaves the row': ('if (state == 2 || state == 3) {                                      /* 0x4cb81d */', 'if (state == 2) {'),
        'state 4 keeps the row': ('if (state == 2 || state == 3) {                                      /* 0x4cb81d */', 'if (state >= 2 && state <= 4) {'),
        'state 1 keeps the row': ('if (state == 2 || state == 3) {                                      /* 0x4cb81d */', 'if (state >= 1 && state <= 3) {'),
        'any state keeps the row': ('if (state == 2 || state == 3) {                                      /* 0x4cb81d */', 'if (1) {'),
        'hotspot only in state 3': ('        if (state == 2) {\n            if (host->player_hotspot', '        if (state == 3) {\n            if (host->player_hotspot'),
        'hotspot in both states': ('        if (state == 2) {\n            if (host->player_hotspot', '        if (1) {\n            if (host->player_hotspot'),
        'hotspot failure ignored': ('if (host->player_hotspot(host->context, &index) != 0) return C1C_ERR_HOST;', 'host->player_hotspot(host->context, &index);'),
        'hotspot -1 looked up': ('            if (index32 != -1) {', '            if (1) {'),
        'hotspot 0 is none': ('            if (index32 != -1) {', '            if (index32 > 0) {'),
        'hotspot negative is none': ('            if (index32 != -1) {', '            if (index32 >= 0) {'),
        'hotspot read as unsigned': ('            index32 = index;', '            index32 = (uint16_t)index;'),
        'record not looked up': ('object->record = find_entry(object, index32);            /* 0x4cb865 */', ''),
        'record lookup uses the last index': ('object->record = find_entry(object, index32);            /* 0x4cb865 */', 'object->record = find_entry(object, object->last_index);'),
        'new index not required': ('if (object->record != NULL && index32 != object->last_index) {', 'if (object->record != NULL) {'),
        'record not required': ('if (object->record != NULL && index32 != object->last_index) {', 'if (index32 != object->last_index) {'),
        'same index translated again': ('if (object->record != NULL && index32 != object->last_index) {', 'if (object->record != NULL && index32 == object->last_index) {'),
        'origin failure ignored': ('if (host->player_origin(host->context, &origin_present, &dx, &dy) != 0) return C1C_ERR_HOST;', 'host->player_origin(host->context, &origin_present, &dx, &dy);'),
        'origin flag is the raw value': ('object->origin_present = origin_present != 0;        /* 0x4cb9d1 */', 'object->origin_present = origin_present;'),
        'origin flag inverted': ('object->origin_present = origin_present != 0;        /* 0x4cb9d1 */', 'object->origin_present = origin_present == 0;'),
        'origin flag not stored': ('object->origin_present = origin_present != 0;        /* 0x4cb9d1 */', ''),
        'origin ignored': ('if (object->origin_present) {\n                        int16_t k;', 'if (0) {\n                        int16_t k;'),
        'origin always applied': ('if (object->origin_present) {\n                        int16_t k;', 'if (1) {\n                        int16_t k;'),
        'translation loop overruns': ('for (k = 0; k < object->record->count; ++k) {\n                            rects[k].d[1]', 'for (k = 0; k <= object->record->count; ++k) {\n                            rects[k].d[1]'),
        'translation loop stops early': ('for (k = 0; k < object->record->count; ++k) {\n                            rects[k].d[1]', 'for (k = 0; k < object->record->count - 1; ++k) {\n                            rects[k].d[1]'),
        'x1 not translated': ('rects[k].d[1] = (int32_t)((uint32_t)rects[k].d[1] + (uint32_t)dx);', ''),
        'x2 not translated': ('rects[k].d[3] = (int32_t)((uint32_t)rects[k].d[3] + (uint32_t)dx);', ''),
        'y1 not translated': ('rects[k].d[2] = (int32_t)((uint32_t)rects[k].d[2] + (uint32_t)dy);', ''),
        'y2 not translated': ('rects[k].d[4] = (int32_t)((uint32_t)rects[k].d[4] + (uint32_t)dy);', ''),
        'x1 translated by dy': ('rects[k].d[1] = (int32_t)((uint32_t)rects[k].d[1] + (uint32_t)dx);', 'rects[k].d[1] = (int32_t)((uint32_t)rects[k].d[1] + (uint32_t)dy);'),
        'x2 translated by dy': ('rects[k].d[3] = (int32_t)((uint32_t)rects[k].d[3] + (uint32_t)dx);', 'rects[k].d[3] = (int32_t)((uint32_t)rects[k].d[3] + (uint32_t)dy);'),
        'y1 translated by dx': ('rects[k].d[2] = (int32_t)((uint32_t)rects[k].d[2] + (uint32_t)dy);', 'rects[k].d[2] = (int32_t)((uint32_t)rects[k].d[2] + (uint32_t)dx);'),
        'y2 translated by dx': ('rects[k].d[4] = (int32_t)((uint32_t)rects[k].d[4] + (uint32_t)dy);', 'rects[k].d[4] = (int32_t)((uint32_t)rects[k].d[4] + (uint32_t)dx);'),
        'x1 subtracted': ('rects[k].d[1] = (int32_t)((uint32_t)rects[k].d[1] + (uint32_t)dx);', 'rects[k].d[1] = (int32_t)((uint32_t)rects[k].d[1] - (uint32_t)dx);'),
        'y2 subtracted': ('rects[k].d[4] = (int32_t)((uint32_t)rects[k].d[4] + (uint32_t)dy);', 'rects[k].d[4] = (int32_t)((uint32_t)rects[k].d[4] - (uint32_t)dy);'),
        'x1 narrowed': ('rects[k].d[1] = (int32_t)((uint32_t)rects[k].d[1] + (uint32_t)dx);', 'rects[k].d[1] = (int32_t)(int16_t)((uint32_t)rects[k].d[1] + (uint32_t)dx);'),
        'y1 narrowed': ('rects[k].d[2] = (int32_t)((uint32_t)rects[k].d[2] + (uint32_t)dy);', 'rects[k].d[2] = (int32_t)(int16_t)((uint32_t)rects[k].d[2] + (uint32_t)dy);'),
        'x2 narrowed': ('rects[k].d[3] = (int32_t)((uint32_t)rects[k].d[3] + (uint32_t)dx);', 'rects[k].d[3] = (int32_t)(int16_t)((uint32_t)rects[k].d[3] + (uint32_t)dx);'),
        'y2 narrowed': ('rects[k].d[4] = (int32_t)((uint32_t)rects[k].d[4] + (uint32_t)dy);', 'rects[k].d[4] = (int32_t)(int16_t)((uint32_t)rects[k].d[4] + (uint32_t)dy);'),
        'change flag not raised': ('object->changed = 1;                                 /* 0x4cb89f */', ''),
        'change flag raised without a translation': ('object->changed = 1;                                 /* 0x4cb89f */', 'object->changed = object->origin_present ? 1 : 0;'),
        'last index not kept': ('object->last_index = index32;', ''),
        'last index kept wrong': ('object->last_index = index32;', 'object->last_index = -1;'),
        'other states do not reach phase 2': ('outcome->phase = 2u;                                             /* 0x4cb8b2 */', ''),
        'other states reach phase 3': ('outcome->phase = 2u;                                             /* 0x4cb8b2 */', 'outcome->phase = 3u;'),
        # c1c_render (0x4cc79a)
        'render accepts a null object': ('if (object == NULL || count == NULL || (capacity != 0u && fills == NULL)) {', 'if (count == NULL || (capacity != 0u && fills == NULL)) {'),
        'render accepts a null count': ('if (object == NULL || count == NULL || (capacity != 0u && fills == NULL)) {', 'if (object == NULL || (capacity != 0u && fills == NULL)) {'),
        'render accepts null fills': ('(capacity != 0u && fills == NULL)) {', '0) {'),
        'render demands fills': ('(capacity != 0u && fills == NULL)) {', '(fills == NULL)) {'),
        'render count not cleared': ('    *count = 0u;\n    if (object->changed == 0) {', '    if (object->changed == 0) {'),
        'render ignores the changed flag': ('if (object->changed == 0) {                                          /* 0x4cc7bc */', 'if (0) {'),
        'render only when unchanged': ('if (object->changed == 0) {                                          /* 0x4cc7bc */', 'if (object->changed != 0) {'),
        'render without a record': ('if (object->record == NULL) {\n        return C1C_ERR_BODY;', 'if (0) {\n        return C1C_ERR_BODY;'),
        'render without a record is ok': ('        return C1C_ERR_BODY;                                             /* the original', '        return C1C_OK;                                                   /* the original'),
        'render color start': ('uint16_t color = C1C_COLOR_FIRST;', 'uint16_t color = C1C_COLOR_FIRST + 1;'),
        'render color step': ('color = (uint16_t)(color + C1C_COLOR_STEP);', 'color = (uint16_t)(color + C1C_COLOR_STEP + 1);'),
        'render color 8 bit': ('color = (uint16_t)(color + C1C_COLOR_STEP);', 'color = (uint8_t)(color + C1C_COLOR_STEP);'),
        'render color step never': ('        color = (uint16_t)(color + C1C_COLOR_STEP);\n', ''),
        'render loop stops early': ('for (i = 0; i < object->record->count; ++i) {\n        const C1cRect *r', 'for (i = 0; i < object->record->count - 1; ++i) {\n        const C1cRect *r'),
        'render loop overruns': ('for (i = 0; i < object->record->count; ++i) {\n        const C1cRect *r', 'for (i = 0; i <= object->record->count; ++i) {\n        const C1cRect *r'),
        'render capacity exclusive': ('if (n < capacity) {', 'if (n + 1u < capacity) {'),
        'render capacity overrun': ('if (n < capacity) {', 'if (n <= capacity) {'),
        'render counts only what fits': ('        ++n;\n        color', '        n += n < capacity;\n        color'),
        'render left wrong field': ('fills[n].left = (int32_t)((uint32_t)r->d[1] + (uint32_t)view_x);', 'fills[n].left = (int32_t)((uint32_t)r->d[3] + (uint32_t)view_x);'),
        'render right wrong field': ('fills[n].right = (int32_t)((uint32_t)r->d[3] + (uint32_t)view_x);', 'fills[n].right = (int32_t)((uint32_t)r->d[1] + (uint32_t)view_x);'),
        'render top wrong field': ('fills[n].top = (int32_t)((uint32_t)r->d[2] + (uint32_t)view_y);', 'fills[n].top = (int32_t)((uint32_t)r->d[4] + (uint32_t)view_y);'),
        'render bottom wrong field': ('fills[n].bottom = (int32_t)((uint32_t)r->d[4] + (uint32_t)view_y);', 'fills[n].bottom = (int32_t)((uint32_t)r->d[2] + (uint32_t)view_y);'),
        'render left view y': ('fills[n].left = (int32_t)((uint32_t)r->d[1] + (uint32_t)view_x);', 'fills[n].left = (int32_t)((uint32_t)r->d[1] + (uint32_t)view_y);'),
        'render right view y': ('fills[n].right = (int32_t)((uint32_t)r->d[3] + (uint32_t)view_x);', 'fills[n].right = (int32_t)((uint32_t)r->d[3] + (uint32_t)view_y);'),
        'render top view x': ('fills[n].top = (int32_t)((uint32_t)r->d[2] + (uint32_t)view_y);', 'fills[n].top = (int32_t)((uint32_t)r->d[2] + (uint32_t)view_x);'),
        'render bottom view x': ('fills[n].bottom = (int32_t)((uint32_t)r->d[4] + (uint32_t)view_y);', 'fills[n].bottom = (int32_t)((uint32_t)r->d[4] + (uint32_t)view_x);'),
        'render view dropped': ('fills[n].left = (int32_t)((uint32_t)r->d[1] + (uint32_t)view_x);', 'fills[n].left = r->d[1];'),
        'render view subtracted': ('fills[n].top = (int32_t)((uint32_t)r->d[2] + (uint32_t)view_y);', 'fills[n].top = (int32_t)((uint32_t)r->d[2] - (uint32_t)view_y);'),
        'render coordinates narrowed': ('fills[n].right = (int32_t)((uint32_t)r->d[3] + (uint32_t)view_x);', 'fills[n].right = (int16_t)((uint32_t)r->d[3] + (uint32_t)view_x);'),
        'render color not stored': ('            fills[n].color = color;\n', ''),
        'render count not stored': ('    *count = n;\n    object->changed = 0;', '    object->changed = 0;'),
        'render count capped': ('    *count = n;\n    object->changed = 0;', '    *count = n < capacity ? n : capacity;\n    object->changed = 0;'),
        'render keeps the changed flag': ('    *count = n;\n    object->changed = 0;', '    *count = n;'),
    },
    B: {
        'create accepts a null host': ('    SessionA1cBinding *b;\n    if (host == NULL) {\n        return NULL;\n    }', '    SessionA1cBinding *b;'),
        'create failure text': ('        b->failure = "none";\n    }\n    return b;', '        b->failure = "";\n    }\n    return b;'),
        'create does not copy the host': ('        b->host = *host;\n', ''),
        'destroy leaks the file': ('    if (b != NULL) {\n        c1c_free_iv(&b->object);\n    }\n    free(b);', '    free(b);', 'leak'),
        'destroy accepts null': ('    if (b != NULL) {\n        c1c_free_iv(&b->object);\n    }\n    free(b);', '    c1c_free_iv(&b->object);\n    free(b);'),
        'destroy leaks the binding': ('    free(b);\n}\n\nstatic int host_complete', '}\n\nstatic int host_complete', 'leak'),
        'host check: player_state': ('return h->player_state != NULL && h->player_name', 'return h->player_name'),
        'host check: player_name': ('h->player_name != NULL && h->player_hotspot', 'h->player_hotspot'),
        'host check: player_hotspot': ('h->player_hotspot != NULL && h->player_origin', 'h->player_origin'),
        'host check: player_origin': ('h->player_origin != NULL &&\n           h->open_iv', 'h->open_iv'),
        'host check: open_iv': ('h->open_iv != NULL && h->read', 'h->read'),
        'host check: read': ('h->read != NULL && h->close', 'h->close'),
        'host check: close': ('h->close != NULL && h->alloc_slot', 'h->alloc_slot'),
        'host check: alloc_slot': ('h->alloc_slot != NULL && h->register_slot', 'h->register_slot'),
        'host check: register_slot': ('h->register_slot != NULL &&\n           h->release_slot', 'h->release_slot'),
        'host check: release_slot': ('h->release_slot != NULL && h->cell_583a29 != NULL;', 'h->cell_583a29 != NULL;'),
        'host check: cell': ('h->release_slot != NULL && h->cell_583a29 != NULL;', 'h->release_slot != NULL;'),
        'handler accepts a null binding': ('if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A1C_TYPE) {', 'if (action == NULL || before == NULL || out == NULL || action->type != SESSION_A1C_TYPE) {'),
        'handler accepts a null action': ('if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A1C_TYPE) {', 'if (b == NULL || before == NULL || out == NULL || action->type != SESSION_A1C_TYPE) {'),
        'handler accepts a null state': ('if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A1C_TYPE) {', 'if (b == NULL || action == NULL || out == NULL || action->type != SESSION_A1C_TYPE) {'),
        'handler accepts a null result': ('if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A1C_TYPE) {', 'if (b == NULL || action == NULL || before == NULL || action->type != SESSION_A1C_TYPE) {'),
        'handler accepts any type': ('|| action->type != SESSION_A1C_TYPE) {', ') {'),
        'decode failure ignored': ('if (action_family_1c_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_1C_OK) {', 'if (action_family_1c_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_1C_OK && 0) {'),
        'decode failure is unsupported': ('b->failure = "invalid raw-0x1c body";\n        return SCENE_ACTION_HANDLER_ERROR;', 'b->failure = "invalid raw-0x1c body";\n        return SCENE_ACTION_HANDLER_UNSUPPORTED;'),
        'decode failure text': ('b->failure = "invalid raw-0x1c body";', 'b->failure = "none";'),
        'host check skipped': ('    if (!host_complete(&b->host)) {', '    if (0) {'),
        'host check is an error': ('b->failure = "movie player, .IV file or z entry provider";\n        return SCENE_ACTION_HANDLER_UNSUPPORTED;', 'b->failure = "movie player, .IV file or z entry provider";\n        return SCENE_ACTION_HANDLER_ERROR;'),
        'host check text': ('b->failure = "movie player, .IV file or z entry provider";', 'b->failure = "none";'),
        'body not copied': ('    memcpy(b->body, action->raw_body, sizeof(b->body));\n', ''),
        'body copy too short': ('memcpy(b->body, action->raw_body, sizeof(b->body));', 'memcpy(b->body, action->raw_body, sizeof(b->body) - 1u);'),
        'kernel gets phase 0': ('c1c_visit(&b->object, b->body, before->phase, &b->host, &outcome)', 'c1c_visit(&b->object, b->body, 0u, &b->host, &outcome)'),
        'kernel failure ignored': ('    if (status != C1C_OK) {\n        b->failure = status == C1C_ERR_FILE', '    if (status != C1C_OK && 0) {\n        b->failure = status == C1C_ERR_FILE'),
        'kernel failure is unsupported': ('"raw-0x1c host callback failed";\n        return SCENE_ACTION_HANDLER_ERROR;', '"raw-0x1c host callback failed";\n        return SCENE_ACTION_HANDLER_UNSUPPORTED;'),
        'file failure text': ('(the original shuts the game down)"', '"'),
        'file failure maps to host text': ('b->failure = status == C1C_ERR_FILE ?', 'b->failure = status == C1C_ERR_BODY ?'),
        'host failure text': ('"raw-0x1c host callback failed"', '"none"'),
        'failure not cleared': ('    b->failure = "none";\n    ++b->visits;', '    ++b->visits;'),
        'visits not counted': ('    ++b->visits;\n    out->phase', '    out->phase'),
        'visits counted on failure': ('    if (status != C1C_OK) {\n        b->failure = status == C1C_ERR_FILE', '    ++b->visits;\n    if (status != C1C_OK) {\n        b->failure = status == C1C_ERR_FILE'),
        'phase from the row': ('out->phase = outcome.phase;', 'out->phase = before->phase;'),
        'phase zero': ('out->phase = outcome.phase;', 'out->phase = 0u;'),
        'disposition pending': (DISPOSITION, 'out->disposition = SCENE_ACTION_HANDLER_PENDING;'),
        'disposition always direct': (DISPOSITION, 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;'),
        'disposition never direct': (DISPOSITION, 'out->disposition = outcome.disposition;'),
        'disposition direct for subtype 2': (DISPOSITION, DISPOSITION.replace(' && action->subtype != 2u', '')),
        'disposition direct only for subtype 1': (DISPOSITION, DISPOSITION.replace('action->subtype != 2u', 'action->subtype == 1u')),
        'disposition direct only for subtype 2': (DISPOSITION, DISPOSITION.replace('action->subtype != 2u', 'action->subtype == 2u')),
        'disposition direct for every outcome': (DISPOSITION, DISPOSITION.replace('outcome.disposition == SCENE_ACTION_HANDLER_COMPLETED && ', '')),
        'handler returns error': ('    return SCENE_ACTION_HANDLER_OK;\n}\n\nint session_a1c_render', '    return SCENE_ACTION_HANDLER_ERROR;\n}\n\nint session_a1c_render'),
        'render accepts a null binding': ('return b == NULL ? C1C_ERR_ARGUMENT : c1c_render(&b->object, view_x, view_y, fills, capacity, count);', 'return b == NULL ? C1C_OK : c1c_render(&b->object, view_x, view_y, fills, capacity, count);'),
        'render view swapped': ('c1c_render(&b->object, view_x, view_y, fills, capacity, count)', 'c1c_render(&b->object, view_y, view_x, fills, capacity, count)'),
        'render capacity dropped': ('c1c_render(&b->object, view_x, view_y, fills, capacity, count)', 'c1c_render(&b->object, view_x, view_y, fills, 1u, count)'),
        'object accessor null': ('return b == NULL ? NULL : &b->object;', 'return &b->object;'),
        'failure accessor null text': ('return b == NULL ? "invalid binding" : b->failure;', 'return b == NULL ? "none" : b->failure;'),
        'failure accessor null': ('return b == NULL ? "invalid binding" : b->failure;', 'return b->failure;'),
        'visits accessor null': ('return b == NULL ? 0ul : b->visits;', 'return b->visits;'),
    },
}

# Mutants that cannot change observable behaviour. Each carries the reason; test_equivalent_mutants_survive checks that the unit
# cases still pass on them, so a reason that stops being true is noticed.
EQUIVALENT = {
    'read_exact accepts a longer read': (K, 'return host->read(host->context, file, buffer, size) == size;', 'return host->read(host->context, file, buffer, size) >= size;',
                                         'the host contract is "copies exactly size bytes and returns the count read", so the count never exceeds size and ">=" equals "=="'),
    'load_iv frees a previous file': (K, '    c1c_free_iv(object);\n    for (length = 0u;', '    for (length = 0u;',
                                      'load_iv is entered only with nothing loaded (c1c_visit calls it when object->iv == NULL), so the leading free is defence in depth'),
    'phase variable not updated after the match': (K, '        phase = 1u;\n        outcome->phase = 1u;', '        outcome->phase = 1u;',
                                                   'the local `phase` is not read after the phase 0 block (the outcome carries the stored phase)'),
    'phase 2 dword 14e not cleared': (K, '        object->dword_14e = 0;\n        object->dword_154 = 0;\n        object->dword_158 = 0;', '        object->dword_154 = 0;\n        object->dword_158 = 0;',
                                      'nothing in the kernel ever sets +0x14e to a nonzero value, so clearing it is unobservable'),
    'phase 2 dword 154 not cleared': (K, '        object->dword_154 = 0;\n        object->dword_158 = 0;', '        object->dword_158 = 0;',
                                      'nothing in the kernel ever sets +0x154 to a nonzero value'),
    'phase 2 dword 158 not cleared': (K, '        object->dword_158 = 0;\n        object->last_index = -1;', '        object->last_index = -1;',
                                      'nothing in the kernel ever sets +0x158 to a nonzero value'),
    'phase 2 keeps the record': (K, '        object->record = NULL;\n        object->dword_14e = 0;', '        object->dword_14e = 0;',
        'phase 2 calls c1c_free_iv just before, which already clears the record pointer'),
    'changed not reset': (K, '        object->changed = 0;\n        object->record = NULL;\n        object->dword_154 = 0;', '        object->record = NULL;\n        object->dword_154 = 0;',
        'the phase 1 step that follows in the same visit clears the changed flag again (0x4cb7ff)'),
    'record not reset': (K, '        object->record = NULL;\n        object->dword_154 = 0;', '        object->dword_154 = 0;',
        'the phase 1 step that follows in the same visit clears the record pointer again (0x4cb7ff)'),
    'create does not reset the object': (B, '        c1c_object_reset(&b->object);\n', '',
        'the binding is calloc-ed, so the object is already all zero, which is exactly the power-on object'),
    'render color cast removed': (K, 'color = (uint16_t)(color + C1C_COLOR_STEP);', 'color = color + C1C_COLOR_STEP;',
                                  'color is a uint16_t, so the assignment converts modulo 2^16 exactly like the explicit cast'),
    'allocation failure of the file record ignored': (K, '    if (iv == NULL) {\n        host->close(host->context, file);\n        return C1C_ERR_HOST;\n    }', '    if (0) {\n        host->close(host->context, file);\n        return C1C_ERR_HOST;\n    }',
                                                      'calloc failure cannot be injected by the unit harness (no malloc fault injection); the branch is a native-only refusal'),
    'allocation failure of the entry table ignored': (K, '    if (iv->entries == NULL) {\n        goto fail;\n    }', '    if (0) {\n        goto fail;\n    }',
                                                      'calloc failure cannot be injected by the unit harness; the branch is a native-only refusal'),
    'allocation failure of the rectangles ignored': (K, 'if (e->rects == NULL) goto fail_entries;', '',
                                                     'calloc failure cannot be injected by the unit harness; the branch is a native-only refusal'),
    'binding allocation failure ignored': (B, '    b = (SessionA1cBinding *)calloc(1u, sizeof(*b));\n    if (b != NULL) {', '    b = (SessionA1cBinding *)calloc(1u, sizeof(*b));\n    if (1) {',
                                           'calloc failure cannot be injected by the unit harness'),
}
EXECUTOR_MUTANTS = {
    'phase 2 stays pending': (K, 'outcome->disposition = SCENE_ACTION_HANDLER_COMPLETED;           /* 0x42ba3a */', 'outcome->disposition = SCENE_ACTION_HANDLER_PENDING;'),
    'binding drops the disposition': (B, DISPOSITION, 'out->disposition = SCENE_ACTION_HANDLER_PENDING;'),
    'binding completes generically': (B, DISPOSITION, 'out->disposition = outcome.disposition;'),
    'phase 0 match skips phase 1': (K, '        outcome->phase = 1u;                                             /* 0x4cb7e5: state := 1 */', ''),
    'file never released': (K, '        c1c_free_iv(object);\n        object->body = NULL;', '        object->body = NULL;'),
    'the z entry is never released': (K, '        if (object->slot != -1) {\n            if (host->release_slot', '        if (0) {\n            if (host->release_slot'),
    'hotspot change not raised': (K, 'object->changed = 1;                                 /* 0x4cb89f */', ''),
    'player state 3 ends the row': (K, 'if (state == 2 || state == 3) {                                      /* 0x4cb81d */', 'if (state == 2) {'),
}


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a1c_test'
        built = compile_c(cls.binary, TEST_C, KERNEL_SOURCES)
        assert built.returncode == 0, built.stderr
        cls.san, cls.leaks = sanitizers_work(cls.tmp.name)  # compiler or None

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
        if not self.san:
            self.skipTest('no compiler with an ASan/UBSan runtime in this environment')
        out = Path(self.tmp.name) / 'a1c_test_san'
        built = compile_c(out, TEST_C, KERNEL_SOURCES, extra=SANITIZE, cc=self.san)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        code, results = run_unit(out, leaks=self.leaks)
        self.assertEqual(code, 0)
        self.assertGreaterEqual(sum(status == 'PASS' for status, _ in results.values()), EXPECTED_UNIT_TESTS)

    def _run_mutant(self, tag, filename, old, new):
        work = mutated_copy(self.tmp.name, filename, old, new, tag)
        binary = work / 'mut_test'
        built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work, extra=SANITIZE if self.san else (), werror=False,
                          cc=self.san)
        if built.returncode != 0:
            return 'does not build: ' + built.stderr[-300:], None
        code, _ = run_unit(binary, leaks=self.leaks)
        return None, code

    def test_mutations_are_detected(self):
        """The cases must fail when a recovered rule is deliberately broken (the oracle has its own mutants against the original;
        these also cover the host-status mapping the oracle cannot reach). Leak mutants need LeakSanitizer."""
        jobs = []
        skipped = []
        for filename, mutations in MUTANTS.items():
            for name, entry in mutations.items():
                if len(entry) == 3 and not self.leaks:
                    skipped.append(name)
                    continue
                jobs.append((filename, name, entry[0], entry[1]))
        survivors, broken = [], []

        def run(job):
            filename, name, old, new = job
            tag = 'mut_' + re.sub(r'\W', '_', filename + name)
            return job, self._run_mutant(tag, filename, old, new)

        with concurrent.futures.ThreadPoolExecutor(max_workers=min(8, os.cpu_count() or 2)) as pool:
            for job, (problem, code) in pool.map(run, jobs):
                if problem is not None:
                    broken.append((job[1], problem))
                elif code == 0:
                    survivors.append(job[1])
        self.assertEqual(broken, [], 'mutants that do not build')
        self.assertEqual(survivors, [], 'mutants that survived')
        self.assertGreaterEqual(len(jobs) + len(skipped), 250)

    def test_equivalent_mutants_survive(self):
        """The recorded equivalent mutants build and leave every unit case green (so the recorded reason is still true)."""
        for name, (filename, old, new, reason) in EQUIVALENT.items():
            with self.subTest(name):
                self.assertTrue(reason)
                work = mutated_copy(self.tmp.name, filename, old, new, 'eq')
                binary = work / 'eq_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work, extra=SANITIZE if self.san else (), werror=False,
                                  cc=self.san)
                self.assertEqual(built.returncode, 0, built.stderr[-300:])
                code, _ = run_unit(binary, leaks=self.leaks)
                self.assertEqual(code, 0, 'the recorded equivalent mutant is detected: ' + name)


class ExecutorTests(unittest.TestCase):
    """The production executor drives synthetic rows (gate mode 1, pending phases, generic completion) with the real binding."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.scenes = []
        for name, data in (('ungated', scene_ungated()), ('gated', scene_gated()), ('repeating', scene_repeating())):
            path = Path(cls.tmp.name) / (name + '.bin')
            path.write_bytes(data)
            cls.scenes.append(str(path))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec1c'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir, werror=src_dir == SRC)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), *self.scenes], capture_output=True, text=True)

    def test_executor_runs_the_whole_life_of_a_row(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        for name, (filename, old, new) in EXECUTOR_MUTANTS.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, filename, old, new, 'exec_mut')
                done = self.run_executor(work, 'exec1c_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_1c_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not (RESOURCES / '0001.bin').exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a1c_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # two scenes (S2186 and S3420) with one row each; both rows are repeating (subtype 2), both bodies are the full 105 bytes, one row carries a dependency
        # record, neither asks for the hotspot render entry (body word 0x21 is 0), so no z entry is allocated
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['bad']), (2, 2, 2, 0))
        self.assertEqual((summary['full_body'], summary['tail_rows'], summary['sub1'], summary['sub2']), (2, 1, 0, 2))
        self.assertEqual((summary['render_rows'], summary['allocs'], summary['registers'], summary['releases']), (0, 0, 0, 0))
        self.assertEqual((summary['opens'], summary['closes'], summary['fills']), (2, 2, 4))
        self.assertEqual(done.stdout.count('ROW_FAIL'), 0)


GLUE_PRELUDE = r'''
#include <array>
#include <cstdarg>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <string>
#include <dirent.h>
#include "scene_session.h"
#include "session_bindings_a1c.h"
#define D9_SLOT_FIRST 0x18
#define D9_SLOT_LAST 0x3f
struct StandInRect { int left = 0, top = 0, right = 0, bottom = 0; };
struct StandInInventory { int16_t *selected_item_candidate = nullptr; };
struct StandInView { StandInInventory inventory; };
struct StandInNewGame { StandInView view; };
struct NativeApp {
    std::string game_directory; StandInRect scene_destination; StandInNewGame new_game;
    SessionA1cBinding *a1c = nullptr; std::array<bool, 0x40> a1c_slot_used{}; bool a1c_wait_logged = false; bool a1c_fills_logged = false;
    std::array<bool, 0x40> ad1_slot_used{}, ad3_slot_used{}, ad9_slot_used{}, aaa_slot_used{}, ad0_slot_used{}, aea_slot_used{},
        af6_slot_used{}, ae0_slot_used{}, ae4_slot_used{}, af5_slot_used{}, aeb_slot_used{}, ada_slot_used{};
};
static void record(NativeApp *, const char *, ...) __attribute__((format(printf, 2, 3)));
static void record(NativeApp *, const char *, ...) {}
'''


def glue_regions(app):
    start = app.index('/* Raw 0x1c (RT-57)')
    end = app.index('/* RT-44: raw 0x4e recomputes')
    creation = '    C1cHost a1c_host{};\n    native_a1c_fill_host(app, &a1c_host);\n    app->a1c = session_a1c_create(&a1c_host);'
    assert creation in app
    begin_start = app.index('    app->a1c_slot_used.fill(false);')
    begin_end = app.index('    if (session_aea_begin_scene(', begin_start)
    ada = app.find('    if (session_ada_begin_scene(', begin_start)  # RT-59's block follows RT-57's; it needs its own stand-in members
    if 0 <= ada < begin_end:
        begin_end = ada
    return app[start:end], creation, app[begin_start:begin_end]


class AppGlue(unittest.TestCase):
    """src/blackmoor_app.mm is not compiled in the cloud. The glue is syntax-checked here against stand-in types, and the
    registration is pinned at text level."""

    @classmethod
    def setUpClass(cls):
        cls.app = (SRC / 'blackmoor_app.mm').read_text()

    def test_glue_compiles_against_stand_in_types(self):
        cxx = shutil.which('clang++') or shutil.which('c++')
        if cxx is None:
            self.skipTest('no C++ compiler')
        functions, creation, begin = glue_regions(self.app)
        source = (GLUE_PRELUDE + functions + '\nstatic void create_for_syntax_check(NativeApp *app)\n{\n' + creation + '\n}\n' +
                  '\nstatic bool begin_for_syntax_check(NativeApp *app)\n{\n' + begin + '    return true;\n}\n' +
                  '\nstatic void cleanup_for_syntax_check(NativeApp *app)\n{\n    session_a1c_destroy(app->a1c);\n}\n')
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / 'glue_check.cpp'
            path.write_text(source)
            done = subprocess.run([cxx, '-std=c++17', '-fsyntax-only', '-Wall', '-Wextra', '-Werror', '-Wno-unused-function',
                                   f'-I{SRC}', str(path)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr[-1500:])

    def test_registration_uses_numeric_literals_and_gap_free_slots(self):
        for line in ('bindings[57].type = SESSION_A1C_TYPE;', 'bindings[57].callback = native_a1c_handler;', 'bindings[57].context = app;'):
            self.assertEqual(self.app.count(line), 1, line)
        indices = sorted({int(n) for n in re.findall(r'\n    bindings\[(\d+)\]\.type', self.app)})
        self.assertEqual(indices, list(range(1, len(indices) + 1)))
        count = len(indices) + 1
        self.assertIn(f'SceneSessionActionBinding bindings[{count}]{{}};', self.app)
        self.assertIn(f'config.action_binding_count = {count}u;', self.app)
        self.assertGreaterEqual(count, 58)

    def test_binding_is_created_checked_recreated_and_destroyed(self):
        self.assertEqual(self.app.count('session_a1c_destroy(app->a1c);'), 2)  # cleanup, and the per-scene recreate
        self.assertEqual(self.app.count('app->a1c = session_a1c_create(&a1c_host);'), 2)
        self.assertIn('app->a1c == nullptr', self.app)
        self.assertIn('#include "session_bindings_a1c.h"', self.app)
        self.assertIn('SessionA1cBinding *a1c = nullptr;', self.app)

    def test_the_z_entry_allocators_exclude_the_new_family(self):
        loops = [m.start() for m in re.finditer(r'for \(int16_t i = D9_SLOT_FIRST; i <= D9_SLOT_LAST; \+\+i\) \{', self.app)]
        self.assertGreaterEqual(len(loops), 11)
        for start in loops:
            text = self.app[start:self.app.index('*slot = i;', start)]
            self.assertIn('a1c_slot_used', text, 'allocator at offset %d does not exclude raw 0x1c' % start)
        # the raw 0x1c allocator excludes every other family's array and its own
        arrays = set(re.findall(r'std::array<bool, 0x40> (\w+_slot_used)', self.app)) - {'a1c_slot_used'}
        mine = self.app.index('static int native_a1c_alloc_slot(')
        text = self.app[mine:self.app.index('*slot = i;', mine)]
        self.assertIn('!app->a1c_slot_used[', text)
        for array in sorted(arrays):
            self.assertIn(f'!app->{array}[', text, array)

    def test_render_hook_and_scene_reset(self):
        self.assertEqual(self.app.count('(void)native_a1c_render(app);'), 1)
        self.assertEqual(self.app.count('static bool native_a1c_render(NativeApp *app);'), 1)
        self.assertEqual(self.app.count('app->a1c_slot_used.fill(false);'), 1)
        self.assertIn('hotspot fills not drawn', self.app)
        self.assertIn('waits for a movie player', self.app)

    def test_file_path_follows_the_ciftree_rule(self):
        self.assertIn('app->game_directory + "/Ciftree"', self.app)
        self.assertIn('std::string(name) + ".IV"', self.app)

    def test_modules_are_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        for module in ('action_family_1c', 'action_family_1c_runtime', 'session_bindings_a1c'):
            self.assertRegex(build, rf'[ ]{module}[ ;]', module)
        script = (PROJECT / 'scripts/build_action_family_1c_runtime.sh').read_text()
        for source in KERNEL_SOURCES:
            self.assertIn(source, script)


if __name__ == '__main__':
    unittest.main()
