"""RT-48: raw 0x20, 0x70 and 0x80 (src/session_bindings_a20_a70_a80.c over src/action_family_{20,70,80}_runtime.c).

Facts under test (original GAME.EXE, dispatcher 0x427a50, all three arms gate mode 0 and ending in a direct completion-byte store):
 * 0x20 (arm 0x429373): two body dwords go to 0x63aa10 and 0x55cd94, 0x43e96c erases every loaded action row (the row itself
   included) and 0x43e8b8 recounts, then [0x5bb57b] := [0x5bb57f] and word [0x5c3a4f] := its low word.
 * 0x70 (arm 0x4291f8): 0x4fb018 unloads the scene sounds, then outer state 5 with next state 6, 0x583991 := 0, 0x43dbd5 sets word
   0x5bb1c4, engine mode 0x583999 := 0, 0x5bb1e2 := 0.
 * 0x80 (arm 0x42960b, method 0x4e386e on object 0x57975c): a body word other than 9999 (signed) is the scene, 9999 takes the
   object's stored scene; the transition words always come from the object; engine mode 4; object states 2 and 3 also reset the
   overlay cells.
The unit cases live in tests/action_family_20_70_80_runtime_test.c; the corpus driver runs the 6 real rows of the decoded scenes;
the original-x86 oracle is tests/action_family_20_70_80_runtime_original_oracle.py (needs the private work/ evidence and Unicorn).
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
TEST_C = PROJECT / 'tests/action_family_20_70_80_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_20_70_80_runtime_corpus.c'
EXECUTOR_C = PROJECT / 'tests/action_family_20_70_80_runtime_executor.c'
KERNEL_SOURCES = ['session_bindings_a20_a70_a80.c', 'action_family_20_runtime.c', 'action_family_70_runtime.c',
                  'action_family_80_runtime.c', 'action_family_20.c', 'action_family_70.c', 'action_family_80.c']
CORPUS_SOURCES = KERNEL_SOURCES + ['scene_resource.c', 'hiff.c']
EXECUTOR_SOURCES = CORPUS_SOURCES + ['scene_executor.c', 'scene_conditions.c', 'scene_dependencies.c', 'action_family_64.c',
                                     'action_core.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 15

sys.path.insert(0, str(PROJECT / 'tests'))
import test_scene_executor as base  # noqa: E402


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


def mutated_copy(tmp, filename, old, new):
    original = (SRC / filename).read_text()
    assert original.count(old) == 1, 'mutation anchor drifted: ' + old
    work = Path(tmp) / 'mut'
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir()
    for item in SRC.iterdir():
        if item.suffix in ('.c', '.h'):
            shutil.copy(item, work / item.name)
    (work / filename).write_text(original.replace(old, new, 1))
    return work


def body20(d0, d4):
    return struct.pack('<II', d0, d4)


def flag_is(index, value):
    return base.condition(2, index, value)


def erase_scene():
    """0x70 behind flag 1, 0x80 behind flag 2, 0x20 behind flag 3, then an ungated 0x70."""
    return base.scene_bytes([base.action(0x70, 1, b'\0', (flag_is(1, 1),)),
                             base.action(0x80, 1, struct.pack('<H', 6301), (flag_is(2, 1),)),
                             base.action(0x20, 1, body20(3, 1), (flag_is(3, 1),)),
                             base.action(0x70, 1, b'\0')])


def transition_scene():
    return base.scene_bytes([base.action(0x80, 1, struct.pack('<H', 6301))])


def plain_70_scene():
    return base.scene_bytes([base.action(0x70, 1, b'\0')])


# each mutant must be caught by the unit cases
K20, B, K70, K80 = ('action_family_20_runtime.c', 'session_bindings_a20_a70_a80.c', 'action_family_70_runtime.c',
                    'action_family_80_runtime.c')
MUTANTS = {
    K20: {
        'view cells swapped (first dword)': ('world->view_cell_63aa10 = (int32_t)decoded->dword_0;', 'world->view_cell_63aa10 = (int32_t)decoded->dword_4;'),
        'view cells swapped (second dword)': ('world->view_cell_55cd94 = (int32_t)decoded->dword_4;', 'world->view_cell_55cd94 = (int32_t)decoded->dword_0;'),
        'scene copy reversed': ('world->scene_5bb57b = world->scene_5bb57f;', 'world->scene_5bb57f = world->scene_5bb57b;'),
        'word from the high half': ('((uint32_t)world->scene_5bb57b & 0xffffu)', '((uint32_t)world->scene_5bb57b >> 16)'),
        'erase skipped': ('if (host->erase_rows(host->context, &erased) != 0) {', 'if (0) {'),
        'erase failure ignored': ('        return ACTION_FAMILY_20_RUNTIME_ERR_HOST;', '        return ACTION_FAMILY_20_RUNTIME_OK;'),
        'erase count dropped': ('out->rows_erased = erased;', 'out->rows_erased = 0u;'),
    },
    K70: {
        'next state 5': ('world->next_state_583985 = 6;', 'world->next_state_583985 = 5;'),
        'outer state 6': ('world->outer_state_583981 = 5;', 'world->outer_state_583981 = 6;'),
        'cell 583991 not cleared': ('world->cell_583991 = 0;', 'world->cell_583991 = 1;'),
        'first render 0': ('world->first_render_5bb1c4 = 1;', 'world->first_render_5bb1c4 = 0;'),
        'engine mode 3': ('world->engine_mode_583999 = 0;', 'world->engine_mode_583999 = 3;'),
        'cell 5bb1e2 not cleared': ('world->cell_5bb1e2 = 0;', 'world->cell_5bb1e2 = 1;'),
        'sound unload skipped': ('if (host->unload_scene_sound(host->context) != 0) {', 'if (0) {'),
        'sound unload after the first write': ('if (host->unload_scene_sound(host->context) != 0) {', 'world->outer_state_583981 = 5;\n    if (host->unload_scene_sound(host->context) != 0) {'),
        'sound failure ignored': ('        return ACTION_FAMILY_70_RUNTIME_ERR_HOST;', '        return ACTION_FAMILY_70_RUNTIME_OK;'),
    },
    K80: {
        'nine thousand compare inverted': ('if (word != ACTION_FAMILY_80_SCENE_NONE) {', 'if (word == ACTION_FAMILY_80_SCENE_NONE) {'),
        'body word unsigned': ('word = (int32_t)(int16_t)decoded->word_0;', 'word = (int32_t)(uint16_t)decoded->word_0;'),
        'stored scene from the wrong word': ('world->scene_5bb57b = (int32_t)object->scene_6ba;', 'world->scene_5bb57b = (int32_t)object->word_6bc;'),
        'second scene cell stale': ('world->scene_5bb57f = (int32_t)object->scene_6ba;', 'world->scene_5bb57f = world->scene_5bb57f;'),
        'tuple words swapped': ('world->word_5bb599 = object->word_6bc;', 'world->word_5bb599 = object->word_6be;'),
        'tuple dword swapped': ('world->dword_5bb59b = object->dword_6c2;', 'world->dword_5bb59b = object->dword_6c6;'),
        'last tuple dword wrong': ('world->dword_5bb5a3 = object->dword_6ca;', 'world->dword_5bb5a3 = object->dword_6c2;'),
        'transition word 5c39ff not 1': ('world->word_5c39ff = 1;\n    world->engine_mode_583999', 'world->word_5c39ff = 0;\n    world->engine_mode_583999'),
        'engine mode 3': ('world->engine_mode_583999 = ACTION_FAMILY_80_MODE_SCENE_CHANGE;', 'world->engine_mode_583999 = 3;'),
        'state 3 not an overlay reset': ('if (object->state_4528 == 2 || object->state_4528 == 3) {', 'if (object->state_4528 == 2) {'),
        'state 2 not an overlay reset': ('if (object->state_4528 == 2 || object->state_4528 == 3) {', 'if (object->state_4528 == 3) {'),
        'overlay cell 583204 value': ('world->cell_583204 = 5;', 'world->cell_583204 = 4;'),
        'load game flag not cleared': ('world->cell_5bb22a = 0;', 'world->cell_5bb22a = 1;'),
        'object 4530 not cleared': ('object->dword_4530 = 0;', 'object->dword_4530 = 1;'),
        'object 6b2 test inverted': ('if ((int32_t)object->word_6b2 != ACTION_FAMILY_80_SCENE_NONE) {', 'if ((int32_t)object->word_6b2 == ACTION_FAMILY_80_SCENE_NONE) {'),
        'object 65d2 not set': ('object->dword_65d2 = 1;', 'object->dword_65d2 = 0;'),
        'object 6b4 not cleared': ('object->dword_6b4 = 0;\n            }', 'object->dword_6b4 = 1;\n            }'),
    },
    B: {
        'a20 phase kept': ('out->phase = 0u;                                             /* 0x43ea29', 'out->phase = before->phase;                                  /* 0x43ea29'),
        'a20 completes generically': ('DIRECT_COMPLETED;\n    return SCENE_ACTION_HANDLER_OK;\n}\n\nconst char *session_a20_failure', 'COMPLETED;\n    return SCENE_ACTION_HANDLER_OK;\n}\n\nconst char *session_a20_failure'),
        'a20 store skipped': ('    if (b->host.store_world != NULL) {\n        b->host.store_world(b->host.context, &world);\n    }\n    out->phase = 0u;', '    out->phase = 0u;'),
        'a20 load refusal ignored': ('if (b->host.load_world == NULL || b->host.load_world(b->host.context, &world) != 0) {', 'if (b->host.load_world == NULL) {'),
        'a70 phase reset': ('out->phase = before->phase;                                  /* the phase word is not written */\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269', 'out->phase = 0u;\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269'),
        'a70 left pending': ('SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269', 'SCENE_ACTION_HANDLER_PENDING;   /* 0x429269'),
        'a70 world store skipped': ('    if (b->host.store_world != NULL) {\n        b->host.store_world(b->host.context, &world);\n    }\n    out->phase = before->phase;                                  /* the phase word is not written */\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269', '    out->phase = before->phase;\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269'),
        'a80 phase reset': ('out->phase = before->phase;                                  /* the phase word is not written */\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x42964e', 'out->phase = 0u;\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x42964e'),
        'a80 left pending': ('SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x42964e', 'SCENE_ACTION_HANDLER_PENDING;   /* 0x42964e'),
        'a80 stored-scene flag inverted': ('(int16_t)decoded.word_0 == ACTION_FAMILY_80_SCENE_NONE', '(int16_t)decoded.word_0 != ACTION_FAMILY_80_SCENE_NONE'),
        'a80 transition refusal ignored': ('if (b->host.transition(b->host.context, &request) != 0) {', 'if (b->host.transition(b->host.context, &request) != 0 && 0) {'),
        'a80 request words swapped': ('request.opaque_words[0] = world.word_5bb599;', 'request.opaque_words[0] = world.word_5bb595;'),
        'a80 request last dword': ('request.opaque_dwords[2] = world.dword_5bb5a3;', 'request.opaque_dwords[2] = world.dword_5bb59f;'),
        'a80 object store skipped': ('    if (b->host.store_object != NULL) {\n        b->host.store_object(b->host.context, &object);\n    }\n', ''),
        'a80 object refusal ignored': ('(int16_t)decoded.word_0 == ACTION_FAMILY_80_SCENE_NONE, &object) != 0) {', '(int16_t)decoded.word_0 == ACTION_FAMILY_80_SCENE_NONE, &object) != 0 && 0) {'),
    },
}
EXECUTOR_MUTANTS = {
    'erase skipped': (K20, 'if (host->erase_rows(host->context, &erased) != 0) {', 'if (0) {'),
    'a70 left pending': (B, 'SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269', 'SCENE_ACTION_HANDLER_PENDING;   /* 0x429269'),
    'a80 left pending': (B, 'SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x42964e', 'SCENE_ACTION_HANDLER_PENDING;   /* 0x42964e'),
}


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a207080_test'
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
            out = Path(self.tmp.name) / 'a207080_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined',
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
        """The cases must fail when a recovered rule is deliberately broken (the oracle has its own mutants against the
        original; these also cover the host-status mapping the oracle cannot reach)."""
        for filename, mutations in MUTANTS.items():
            for name, (old, new) in mutations.items():
                with self.subTest(name):
                    work = mutated_copy(self.tmp.name, filename, old, new)
                    binary = work / 'mut_test'
                    built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                    if built.returncode != 0:
                        self.fail('mutant does not build: ' + name + built.stderr[-200:])
                    code, _ = run_unit(binary)
                    self.assertNotEqual(code, 0, 'mutant survived: ' + name)


class ExecutorTests(unittest.TestCase):
    """The production executor drives synthetic rows (gate mode 0, direct completion, erase, transition) with the real bindings."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.scenes = []
        for name, data in (('erase', erase_scene()), ('transition', transition_scene()), ('plain70', plain_70_scene())):
            path = Path(cls.tmp.name) / (name + '.bin')
            path.write_bytes(data)
            cls.scenes.append(str(path))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec207080'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), *self.scenes], capture_output=True, text=True)

    def test_executor_erases_rows_and_applies_the_direct_completions(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        for name, (filename, old, new) in EXECUTOR_MUTANTS.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, filename, old, new)
                done = self.run_executor(work, 'exec207080_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_20_70_80_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_bindings(self):
        if not (RESOURCES / '0001.bin').exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a207080_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 6 scenes with one row each of interest: 2 x 0x20, 2 x 0x70 (one with a dependency tail), 2 x 0x80 (scene 6301, and 9999)
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['bad']), (6, 6, 6, 0))
        self.assertEqual((summary['n20'], summary['n70'], summary['n80']), (2, 2, 2))
        self.assertEqual((summary['w9999'], summary['w_literal']), (1, 1))
        self.assertEqual((summary['erase_calls'], summary['unloads'], summary['transitions']), (2, 2, 2))
        self.assertEqual(done.stdout.count('ROW_FAIL'), 0)


class OriginalOracle(unittest.TestCase):
    def test_quick_scenarios_against_the_original_dispatcher(self):
        try:
            import unicorn  # noqa: F401
            import numpy  # noqa: F401
        except ImportError:
            self.skipTest('Unicorn/numpy are not installed')
        if not (ROOT / 'work/original/GAME.EXE').exists():
            self.skipTest('local original evidence (work/) is not present')
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_20_70_80_runtime_original_oracle.py'),
                               '--quick-only', '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
