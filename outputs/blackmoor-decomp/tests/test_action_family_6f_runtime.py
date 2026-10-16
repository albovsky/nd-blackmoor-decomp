"""RT-29: raw 0x6f "return to the saved scene" (src/scene_stack.c scene_stack_pop, src/session_bindings_a6f.c).

Facts under test (original GAME.EXE; loader arm 0x40e314 copies one byte, dispatcher arm 0x4291b6 of 0x427a50):
 * after the dependency gate (mode 0) the arm calls the pop 0x42e493 (no arguments) and stores 1 in the row's completion
   byte itself (0x4291ec); neither the generic completion 0x42ba3a nor a dependency reset runs, and the phase word is untouched;
 * the pop reads the record 0x5c3a05: an empty record (word 0x5c3a05 == 9999) is the original's fatal path; otherwise
   0x5bb57b and 0x5bb57f both take the sign-extended word 0x5c3a07, 0x5bb599/0x5bb595 take words 0x5c3a09/0x5c3a0b,
   0x5bb59b/0x5bb59f/0x5bb5a3 take dwords 0x5c3a0f/0x5c3a13/0x5c3a17, 0x5c39ff := 1, 0x5bb1ca := (word 0x5c3a0d != 1),
   mode 0x583999 := 4, and both scene words of the record become 9999;
 * mode 4 stops the dispatcher after the row (its loop needs mode 3), like the executor's transition request.
The unit cases live in tests/action_family_6f_runtime_test.c (synthetic fixtures, including a 0x6e push then 0x6f pop round
trip); the corpus driver runs the 25 rows of the decoded scenes through the binding; the original-x86 oracle is
tests/action_family_6f_runtime_original_oracle.py (needs the private work/ evidence and Unicorn).
"""
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/action_family_6f_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_6f_runtime_corpus.c'
KERNEL_SOURCES = ['scene_stack.c', 'session_bindings_a6e.c', 'session_bindings_a6f.c']
CORPUS_SOURCES = ['scene_stack.c', 'session_bindings_a6f.c', 'action_core.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXECUTOR_C = PROJECT / 'tests/action_family_6f_runtime_executor.c'
EXECUTOR_SOURCES = ['scene_stack.c', 'session_bindings_a6e.c', 'session_bindings_a6f.c', 'action_core.c', 'scene_resource.c', 'hiff.c', 'scene_executor.c',
                    'scene_conditions.c', 'scene_dependencies.c', 'action_family_64.c']
EXPECTED_UNIT_TESTS = 9


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


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a6f_test'
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
            out = Path(self.tmp.name) / 'a6f_test_san'
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
        """The cases must fail when a recovered rule is deliberately broken (the oracle's own mutants are in the oracle)."""
        mutations = {
            'scene taken from word 05': ('scene_stack.c', 'r.scene_5bb57b = slot->scene_5c3a07; ', 'r.scene_5bb57b = slot->scene_5c3a05; '),
            'second scene global taken from word 05': ('scene_stack.c', 'r.scene_5bb57f = slot->scene_5c3a07; ', 'r.scene_5bb57f = slot->scene_5c3a05; '),
            'scene word zero extended': ('scene_stack.c', 'r.scene_5bb57b = slot->scene_5c3a07; ', 'r.scene_5bb57b = (uint16_t)slot->scene_5c3a07; '),
            'words 599 and 595 swapped': ('scene_stack.c', 'r.word_5bb599 = slot->word_5c3a09; ', 'r.word_5bb599 = slot->word_5c3a0b; '),
            'dword 59f taken from 0f': ('scene_stack.c', 'r.dword_5bb59f = slot->dword_5c3a13; ', 'r.dword_5bb59f = slot->dword_5c3a0f; '),
            'dword 5a3 not read': ('scene_stack.c', 'r.dword_5bb5a3 = slot->dword_5c3a17; ', 'r.dword_5bb5a3 = 0; '),
            'flag 5c39ff zero': ('scene_stack.c', 'r.word_5c39ff = 1; ', 'r.word_5c39ff = 0; '),
            'start flag inverted': ('scene_stack.c', 'slot->word_5c3a0d == 1 ? 0 : 1', 'slot->word_5c3a0d == 1 ? 1 : 0'),
            'start flag on type 2': ('scene_stack.c', 'slot->word_5c3a0d == 1 ? 0 : 1', 'slot->word_5c3a0d <= 1 ? 0 : 1'),
            'mode 3': ('scene_stack.c', 'r.mode_583999 = 4; ', 'r.mode_583999 = 3; '),
            'record not emptied': ('scene_stack.c', 'slot->scene_5c3a07 = SCENE_STACK_EMPTY_MARKER;        /* 0x42e555 */', '/* kept */'),
            'only word 05 emptied': ('scene_stack.c', 'slot->scene_5c3a05 = SCENE_STACK_EMPTY_MARKER;        /* 0x42e54c */', '/* kept */'),
            'empty test on word 07': ('scene_stack.c', 'if (slot->scene_5c3a05 == SCENE_STACK_EMPTY_MARKER) { /* 0x42e496', 'if (slot->scene_5c3a07 == SCENE_STACK_EMPTY_MARKER) { /* 0x42e496'),
            'empty pop proceeds': ('scene_stack.c', 'return SCENE_STACK_POP_EMPTY;\n    }\n    r.', 'slot->scene_5c3a05 = 0;\n    }\n    r.'),
            'phase cleared': ('session_bindings_a6f.c', 'out->phase = before->phase;', 'out->phase = 0u;'),
            'generic completion': ('session_bindings_a6f.c', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;',
                                    'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
            'record cleared before the host answers': ('session_bindings_a6f.c', 'popped = *b->slot;', 'popped = *b->slot; *b->slot = popped; scene_stack_pop(b->slot, &pop);'),
            'host refusal ignored': ('session_bindings_a6f.c', 'if (b->host.apply(b->host.context, &pop, &request) != 0) {', 'if (b->host.apply(b->host.context, &pop, &request) > 5) {'),
            'missing host tolerated': ('session_bindings_a6f.c', 'if (b->host.apply == NULL) {', 'if (0) {'),
            'target scene from the second global': ('session_bindings_a6f.c', 'request.target_scene = (int16_t)pop.scene_5bb57b;', 'request.target_scene = (int16_t)pop.scene_5bb57f + 1;'),
            'request words shifted': ('session_bindings_a6f.c', 'request.opaque_words[2] = pop.word_5c39ff;', 'request.opaque_words[2] = 0;'),
            'body length unchecked': ('session_bindings_a6f.c', 'if (action->typed_body_length != ACTION_FAMILY_6F_BODY_BYTES) {', 'if (0) {'),
        }
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                original = (SRC / filename).read_text()
                self.assertEqual(original.count(old), 1, 'mutation anchor drifted')
                work = Path(self.tmp.name) / 'mut'
                shutil.rmtree(work, ignore_errors=True)
                work.mkdir()
                for item in SRC.iterdir():
                    if item.suffix in ('.c', '.h'):
                        shutil.copy(item, work / item.name)
                (work / filename).write_text(original.replace(old, new, 1))
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, _ = run_unit(binary)
                self.assertNotEqual(code, 0, 'mutant survived: ' + name)


class ExecutorTests(unittest.TestCase):
    """The production executor drives synthetic 0x6e/0x6f rows (gates, DIRECT_COMPLETED bookkeeping, the pass ends after the pop's transition)."""

    @classmethod
    def setUpClass(cls):
        sys.path.insert(0, str(PROJECT / 'tests'))
        import test_scene_executor as base
        cls.tmp = tempfile.TemporaryDirectory()
        push = base.action(0x6e, 1, b'\0')
        pop = base.action(0x6f, 1, b'\0', (base.condition(2, 3, 1),))
        late = base.action(0x6e, 2, b'\0', (base.condition(2, 4, 1),))
        cls.scene = Path(cls.tmp.name) / 'scene6f.bin'
        cls.scene.write_bytes(base.scene_bytes([push, pop, late]))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec6f'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), str(self.scene)], capture_output=True, text=True)

    def test_executor_gates_and_completes_the_rows(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        mutations = {
            'direct completion leaves the row open': ('scene_executor.c', 'executor->states[index].completed = 1u;\n        executor->states[index].phase = handler_result.phase;\n        break;\n    case SCENE_ACTION_HANDLER_RESET_DEPENDENCIES:',
                                                       'executor->states[index].completed = 0u;\n        executor->states[index].phase = handler_result.phase;\n        break;\n    case SCENE_ACTION_HANDLER_RESET_DEPENDENCIES:'),
        }
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                original = (SRC / filename).read_text()
                self.assertEqual(original.count(old), 1, 'mutation anchor drifted')
                work = Path(self.tmp.name) / 'mut_exec'
                shutil.rmtree(work, ignore_errors=True)
                work.mkdir()
                for item in SRC.iterdir():
                    if item.suffix in ('.c', '.h'):
                        shutil.copy(item, work / item.name)
                (work / filename).write_text(original.replace(old, new, 1))
                done = self.run_executor(work, 'exec6f_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_6f_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a6f_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 24 scenes, 25 rows, all subtype 1, every row has one dependency record behind its one body byte (always 0)
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['error']), (24, 25, 25, 0))
        self.assertEqual((summary['sub1'], summary['sub_other'], summary['tail_rows']), (25, 0, 25))
        self.assertEqual((summary['body_zero'], summary['body_other'], summary['pops']), (25, 0, 25))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_6f_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
