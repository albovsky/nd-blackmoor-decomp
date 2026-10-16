"""RT-36: raw 0x2d "random movie" set owner (src/action_family_2d_runtime.c, src/session_bindings_a2d.c) and the raw 0x2e mode 0
stop it enables (src/session_bindings_a2e.c, scene_executor_retire_action).

Facts under test (original GAME.EXE; loader arm 0x40c0b3 builds the set, dispatcher arm of 0x427a50 calls handler 0x4cd6ff on the
object at 0x63821d after the dependency gate):
 * phase 0 initialises the object, loads the first clip (the random set "RandomMovie" picks rand % entry count, any other name
   is looked up by name) and sets the shared start flag; phase 1 steps the AVF decode thread or the Bink player and picks the next
   clip with the weighted pick 0x4cf0ce; phase 2 is the stop 0x4ceb3b;
 * the stop (also called by raw 0x2e mode 0) erases the raw 0x2d row (type 0, completion, phase 0, dependency reset) through the
   destructor 0x4cd218 and resets the object.
The unit cases live in tests/action_family_2d_runtime_test.c (synthetic fixtures, no original bytes); the corpus driver parses the
3 decoded rows; the executor driver runs raw 0x2e mode 0 against the production executor; the original-x86 oracle is
tests/action_family_2d_runtime_original_oracle.py (needs the private work/ evidence and Unicorn).
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
TEST_C = PROJECT / 'tests/action_family_2d_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_2d_runtime_corpus.c'
EXECUTOR_C = PROJECT / 'tests/action_family_2d_runtime_executor.c'
KERNEL_SOURCES = ['session_bindings_a2d.c', 'action_family_2d_runtime.c', 'session_bindings_a2e.c', 'action_family_2e.c', 'scene_resource.c',
                  'hiff.c']
CORPUS_SOURCES = KERNEL_SOURCES
EXECUTOR_SOURCES = ['session_bindings_a2e.c', 'action_family_2e.c', 'action_core.c', 'scene_resource.c', 'hiff.c', 'scene_executor.c',
                    'scene_conditions.c', 'scene_dependencies.c', 'action_family_64.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 12


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


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a2d_test'
        built = compile_c(cls.binary, TEST_C, KERNEL_SOURCES)
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
            out = Path(self.tmp.name) / 'a2d_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-Wno-type-limits',
                   f'-I{SRC}', str(TEST_C), *[str(SRC / s) for s in KERNEL_SOURCES], '-lm', '-o', str(out)]
            if subprocess.run(cmd, capture_output=True, text=True).returncode != 0:
                continue
            env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0')
            done = subprocess.run([str(out)], capture_output=True, text=True, env=env)
            self.assertEqual(done.returncode, 0, done.stdout[-400:] + done.stderr[-400:])
            self.assertGreaterEqual(done.stdout.count('PASS'), EXPECTED_UNIT_TESTS)
            return
        self.skipTest('no compiler with an ASan/UBSan runtime in this environment')

    def test_mutations_are_detected(self):
        """The cases must fail when a recovered rule is deliberately broken (the oracle carries more mutants)."""
        k = 'action_family_2d_runtime.c'
        mutations = {
            'rand modulus dropped': (k, '*out = (int32_t)((int64_t)r % (int64_t)count);', '*out = r;'),
            'random set name wrong': (k, '#define RANDOM_SET_NAME "RandomMovie"', '#define RANDOM_SET_NAME "randommovie"'),
            'single entry still rolls': (k, 'if (set->entry_count == 1) {\n            o->clip_246 = 0;', 'if (set->entry_count == -1) {\n            o->clip_246 = 0;'),
            'lookup by prefix': (k, 'if (strcmp(name, set->entries[i].name) == 0) {', 'if (strncmp(name, set->entries[i].name, 1) == 0) {'),
            'ring flag inverted': (k, 'if (set->mode_word == 1) {\n        w->g_5839a9 = 0;', 'if (set->mode_word != 1) {\n        w->g_5839a9 = 0;'),
            'start flag not set': (k, '    w->start_flag = 1;\n    w->g_5831c8 = 1; /* 0x4d36ed */', '    w->g_5831c8 = 1; /* 0x4d36ed */'),
            'active not set': (k, '    o->movie.active = 1;\n    o->buffer_192 = 0;', '    o->buffer_192 = 0;'),
            'weight window shifted': (k, 'lo = hi;\n        hi = (int32_t)((uint32_t)hi + (uint32_t)w);', 'lo = hi + 1;\n        hi = (int32_t)((uint32_t)hi + (uint32_t)w);'),
            'own weight window dropped': (k, 'if (entry->weight > 0) {\n        lo = 0;', 'if (entry->weight > 32000) {\n        lo = 0;'),
            'stop retires no row': (k, 'local.retire_row = arg == -1 ? D2_NO_ROW : arg;', 'local.retire_row = ((void)arg, D2_NO_ROW);'),
            'stop keeps phase': (k, 'local.phase_after = 0;\n            local.stopped = 1;', 'local.stopped = 1;'),
            'render needs no flag': (k, 'if (o->movie.active == 0 || o->movie.flag_206 == 0) {', 'if (o->movie.active == 0) {'),
            'entry type wrong': (k, 'w->entry_type = 0xb;', 'w->entry_type = 0xa;'),
        }
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                work = mutate(self.tmp.name, filename, old, new, 'mut')
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, _ = run_unit(binary)
                self.assertNotEqual(code, 0, 'mutant survived: ' + name)


class ExecutorTests(unittest.TestCase):
    """The production executor drives raw 0x2e mode 0: the stop retires the 0x2d row (scene_executor_retire_action)."""

    @classmethod
    def setUpClass(cls):
        sys.path.insert(0, str(PROJECT / 'tests'))
        import test_scene_executor as base
        cls.tmp = tempfile.TemporaryDirectory()
        mode0 = struct.pack('<Bhhhhhhh', 0, 9999, 0, 0, 0, 0, 0, 0)
        mode2 = struct.pack('<Bhhhhhhh', 2, 0, 0, 0, 0, 0, 0, 0)
        stopper = base.action(0x2e, 1, mode0)
        gated = base.action(0x2e, 1, mode2, (base.condition(2, 3, 1),))
        cls.scene = Path(cls.tmp.name) / 'scene2d.bin'
        cls.scene.write_bytes(base.scene_bytes([stopper, gated]))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec2d'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), str(self.scene)], capture_output=True, text=True)

    def test_mode_0_stop_retires_the_row_in_the_executor(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        mutations = {
            'retire leaves the row open': ('scene_executor.c', 'executor->states[action_index].completed = 1u;\n    executor->states[action_index].phase = 0u;',
                                           'executor->states[action_index].completed = 0u;\n    executor->states[action_index].phase = 0u;'),
            'retire keeps the phase': ('scene_executor.c', 'executor->states[action_index].completed = 1u;\n    executor->states[action_index].phase = 0u;',
                                       'executor->states[action_index].completed = 1u;\n    executor->states[action_index].phase = 5u;'),
            'retire bound dropped': ('scene_executor.c', 'if (executor == NULL || action_index >= executor->action_count) {\n        return SCENE_EXECUTOR_ERR_ARGUMENT;\n    }\n    executor->states[action_index].completed',
                                     'if (executor == NULL) {\n        return SCENE_EXECUTOR_ERR_ARGUMENT;\n    }\n    executor->states[action_index].completed'),
        }
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                work = mutate(self.tmp.name, filename, old, new, 'mut_exec')
                done = self.run_executor(work, 'exec2d_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_2d_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_bind_and_refuse_without_media(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a2d_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 3 scenes (resources 2095, 2184, 2643), 3 rows, all subtype 1 with the buffer ring and no dependency tail (RT-36 census)
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['error']), (3, 3, 3, 0))
        self.assertEqual((summary['sub1'], summary['sub_other'], summary['ring']), (3, 0, 3))

    def test_corpus_detects_a_dropped_media_gate(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        with tempfile.TemporaryDirectory() as tmp:
            work = mutate(tmp, 'session_bindings_a2d.c', 'if (before->phase == 0u && (b->host.media_available == NULL ||',
                          'if (0 && before->phase == 0u && (b->host.media_available == NULL ||', 'mut_corpus')
            binary = work / 'a2d_corpus_mut'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES, src_dir=work)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, sorted(RESOURCES.glob('*.bin')))], capture_output=True, text=True)
        self.assertNotEqual(done.returncode, 0, 'mutant survived: media gate dropped')


if __name__ == '__main__':
    unittest.main()
