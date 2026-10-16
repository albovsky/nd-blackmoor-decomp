"""RT-34: raw 0x44 scroll list entry (src/action_family_d8_runtime.c, action_family_44_runtime.c, session_bindings_a44.c).

Facts under test (original GAME.EXE; the loader builds the 528-byte object, dispatcher arm 0x44 of 0x427a50 calls 0x4121b8 after
the dependency gate; 0x4121b8 runs the text writer 0x413187, the generic completion 0x42ba3a and the record builder 0x411b16, which
replaces the row by a runtime type 0xd8 record; arm 0xd8 calls 0x48c1c0 on the CPeepholePuzzle singleton at 0x624686):
 * first visit: writer, completion (subtype 1: completed, subtype 2: dependency reset), phase 0, record built; the record keeps the
   old subtype only in the visit's disposition (the stored subtype is 1);
 * 0xd8 phase 0 initialises limits / rect flags / render entries / surfaces, phase 1 scrolls by elapsed / (1000 / fps) in the held
   direction until the limit, phase 2 changes scene, finishes and cleans up.
The unit cases live in tests/action_family_d8_runtime_test.c (synthetic fixtures) and the executor check in
tests/action_family_44_runtime_executor.c; the original-x86 oracles are tests/action_family_d8_runtime_original_oracle.py and
tests/action_family_44_runtime_original_oracle.py (they need the private work/ evidence and Unicorn).
"""
import os
from pathlib import Path
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/action_family_d8_runtime_test.c'
UNIT_SOURCES = ['action_family_d8_runtime.c', 'action_family_44_runtime.c']
EXECUTOR_C = PROJECT / 'tests/action_family_44_runtime_executor.c'
EXECUTOR_SOURCES = ['session_bindings_a44.c', 'action_family_44.c', 'action_family_44_runtime.c', 'action_family_d8_runtime.c',
                    'action_core.c', 'scene_resource.c', 'hiff.c', 'scene_executor.c', 'scene_conditions.c',
                    'scene_dependencies.c', 'action_family_64.c']
EXPECTED_UNIT_TESTS = 11


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


def compile_c(output, main_c, sources, src_dir=SRC):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g',
           f'-I{src_dir}', str(main_c), *[str(Path(src_dir) / s) for s in sources], '-lm', '-o', str(output)]
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


def mutate(tmp, filename, old, new, tag):
    original = (SRC / filename).read_text()
    assert original.count(old) == 1, 'mutation anchor drifted: ' + old[:60]
    work = Path(tmp) / tag
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir()
    for item in SRC.iterdir():
        if item.suffix in ('.c', '.h'):
            shutil.copy(item, work / item.name)
    (work / filename).write_text(original.replace(old, new, 1))
    return work


def scene_file(path):
    sys.path.insert(0, str(PROJECT / 'tests'))
    import test_scene_executor as base

    def body(word=2):
        h = bytearray(528)
        struct.pack_into('<H', h, 2, word)
        struct.pack_into('<h', h, 0xc, 200)
        struct.pack_into('<h', h, 0xe, 1000)
        struct.pack_into('<iiii', h, 0x10b, 0, 0, 100, 100)
        struct.pack_into('<iiii', h, 0x11b, 5, 6, 105, 106)
        h[0x1eb] = 20
        struct.pack_into('<H', h, 526, 4)
        return bytes(h) + b'abc\0'
    ungated = base.action(0x44, 1, body())
    gated = base.action(0x44, 2, body(), (base.condition(2, 3, 1),))
    Path(path).write_bytes(base.scene_bytes([ungated, gated]))


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'd8_test'
        built = compile_c(cls.binary, TEST_C, UNIT_SOURCES)
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
            out = Path(self.tmp.name) / 'd8_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined',
                   f'-I{SRC}', str(TEST_C), *[str(SRC / s) for s in UNIT_SOURCES], '-lm', '-o', str(out)]
            if subprocess.run(cmd, capture_output=True, text=True).returncode != 0:
                continue
            env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0')
            done = subprocess.run([str(out)], capture_output=True, text=True, env=env)
            self.assertEqual(done.returncode, 0, done.stdout[-400:] + done.stderr[-400:])
            self.assertGreaterEqual(done.stdout.count('PASS'), EXPECTED_UNIT_TESTS)
            return
        self.skipTest('no compiler with an ASan/UBSan runtime in this environment')

    def test_mutations_are_detected(self):
        """The cases must fail when a recovered rule is deliberately broken (the oracles carry more mutants)."""
        d = 'action_family_d8_runtime.c'
        b = 'action_family_44_runtime.c'
        mutations = {
            'limit y max uses top': (d, 'o->limit_4c = (int16_t)(rds32(record + REC_50) - rds32(record + REC_SRC + 12));', 'o->limit_4c = (int16_t)(rds32(record + REC_50) - rds32(record + REC_SRC + 4));'),
            'limit x min wrong': (d, 'o->limit_4a = (int16_t)(rds32(record + REC_44) - rds32(record + REC_SRC));', 'o->limit_4a = (int16_t)(rds32(record + REC_44) - rds32(record + REC_SRC + 8));'),
            'empty rect test off by one': (d, 'return r[2] <= r[0] || r[3] <= r[1];', 'return r[2] < r[0] || r[3] < r[1];'),
            'case-sensitive name2': (d, 'if (x >= \'A\' && x <= \'Z\') x = (unsigned char)(x + 0x20);', ''),
            'autotext index shifted': (d, '*index = name[12] - \'1\';', '*index = name[12] - \'0\';'),
            'listpage base wrong': (d, '*index = 2 + crt_atoi(rest);', '*index = 1 + crt_atoi(rest);'),
            'text page bound dropped': (d, 'if (text_index < 0 || (unsigned)text_index >= D8_TEXT_SURFACES) {', 'if (0) {'),
            'text limit not height based': (d, 'o->limit_4c = (int16_t)(text_height - rds32(record + REC_SRC + 12));', 'o->limit_4c = (int16_t)(text_height);'),
            'period inverted': (d, 'period = (uint32_t)(1000 / (int)fps);', 'period = (uint32_t)((int)fps);'),
            'fps zero tolerated': (d, 'if (fps == 0u) {', 'if (0) {'),
            'scroll before period': (d, 'if (now - o->tick < period) return D8_OK;', 'if (now - o->tick < period / 2u) return D8_OK;'),
            'direction 0 sign': (d, 'case 0u: o->pos_43 = (int16_t)(o->pos_43 - steps);', 'case 0u: o->pos_43 = (int16_t)(o->pos_43 + steps);'),
            'lower limit side flag': (d, '        o->can_move[0] = 0u;\n        o->dir = 0xffu;', '        o->can_move[1] = 0u;\n        o->dir = 0xffu;'),
            'direction kept at limit': (d, '        o->pos_43 = o->limit_4e;\n        o->can_move[0] = 0u;\n        o->dir = 0xffu;', '        o->pos_43 = o->limit_4e;\n        o->can_move[0] = 0u;'),
            'link scene cells': (d, 'change.word[2] = 1;\n        change.dword[2] = 1;', 'change.word[2] = 0;\n        change.dword[2] = 1;'),
            'start flag inverted': (d, 'start_flag = rds16(record + REC_EXIT_SCENE + 20) == 1 ? 0 : 1;', 'start_flag = rds16(record + REC_EXIT_SCENE + 20) == 1 ? 1 : 0;'),
            'exit flag bound dropped': (d, 'if (flag_index != -1 && (flag_index < 0 ||', 'if (0 && flag_index != -1 && (flag_index < 0 ||'),
            'exit value wrong byte': (d, 'record[REC_EXIT_FLAG + 2]', 'record[REC_EXIT_FLAG + 3]'),
            'borrowed text released': (d, 'if (o->surface1 == 0u || o->borrowed != 0u) {', 'if (o->surface1 == 0u) {'),
            'second surface not skipped': (d, 'if (o->surface2 != o->surface1) {', 'if (1) {'),
            'link hit offset dropped': (d, '(uint32_t)rds32(e + 6) + (uint32_t)oy', '(uint32_t)rds32(e + 6)'),
            'exit cursor wrong': (d, 'out->cursor_5b44f0 = 9;', 'out->cursor_5b44f0 = 8;'),
            'item cursor base': (d, '(int32_t)in->item_583a29 + 0x25;', '(int32_t)in->item_583a29 + 0x24;'),
            'press ignores phase': (d, '', ''),
            'list name offset': (b, 'memcpy(record + 12, number, strlen(number) + 1u);', 'memcpy(record + 13, number, strlen(number) + 1u);'),
            'page word minus two': (b, '(int)rds16(object + OBJ_WORD2) - 2', '(int)rds16(object + OBJ_WORD2) - 1'),
            'no-link value kept': (b, 'if (text->link_value[i] == A44_NO_LINK) continue;', ''),
            'link bound dropped': (b, 'return count > (int)D8_ENTRY_MAX ? -1 : count;', 'return count;'),
            'fps byte offset': (b, 'record[0x134] = object[OBJ_FPS];', 'record[0x134] = object[OBJ_FPS - 1u];'),
            'word c d swapped': (b, 'put32(record + 0x50, (uint32_t)(int32_t)rds16(object + OBJ_WORD_E));', 'put32(record + 0x50, (uint32_t)(int32_t)rds16(object + OBJ_WORD_C));'),
        }
        del mutations['press ignores phase']
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                work = mutate(self.tmp.name, filename, old, new, 'mut')
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, UNIT_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, _ = run_unit(binary)
                self.assertNotEqual(code, 0, 'mutant survived: ' + name)


class ExecutorTests(unittest.TestCase):
    """The production executor drives synthetic 0x44 rows through the real binding (writer, completion, record, link click)."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.scene = Path(cls.tmp.name) / 'scene44.bin'
        scene_file(cls.scene)

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec44'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), str(self.scene)], capture_output=True, text=True)

    def test_executor_runs_the_row_to_a_scene_change(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        c = 'session_bindings_a44.c'
        mutations = {
            'subtype 2 reset dropped': (c, 'out->disposition = action->subtype == 2u ? SCENE_ACTION_HANDLER_RESET_DEPENDENCIES : SCENE_ACTION_HANDLER_PENDING;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;'),
            'finish not completed': (c, 'result.finished != 0u ? SCENE_ACTION_HANDLER_DIRECT_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_PENDING'),
            'first visit phase kept': (c, '        out->phase = 0u;\n        out->disposition = action->subtype', '        out->phase = before->phase + 1u;\n        out->disposition = action->subtype'),
            'record not replaced': (c, '        row->is_object = 0u;\n        row->is_record = 1u;', '        row->is_object = 1u;\n        row->is_record = 0u;'),
            'writer failure ignored': (c, 'if (b->host.write_text(USER(b), row->bytes, row->length, text) != 0) {', 'if (0) {'),
            'scene words dropped': (c, 'request.target_scene = change->scene;', 'request.target_scene = 0;'),
        }
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                work = mutate(self.tmp.name, filename, old, new, 'mut_exec')
                done = self.run_executor(work, 'exec44_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_44_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())


if __name__ == '__main__':
    unittest.main()
