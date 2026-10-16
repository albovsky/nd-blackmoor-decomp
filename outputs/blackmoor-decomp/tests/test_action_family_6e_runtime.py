"""RT-28: raw 0x6e "save the running scene" (src/scene_stack.c, src/session_bindings_a6e.c).

Facts under test (original GAME.EXE; loader arm 0x40e250 copies one byte, dispatcher arm 0x42916f of 0x427a50):
 * after the dependency gate (mode 0) the arm calls 0x42e560(2) and stores 1 in the row's completion byte itself
   (0x4291aa); neither the generic completion 0x42ba3a nor a dependency reset runs, and the phase word is untouched;
 * 0x42e560 copies the running scene's words (0x5bb57b, 0x5bb57f, 0x5bb50b, 0x5bb593, 0x5bb5a7, 0x5bb5af) and the low
   word of its argument into the record at 0x5c3a05 (0x5c3a13 is written twice, the second store wins; 0x5c3a17 never);
 * the game initializer sets the record's five words to 9999, 9999, 0, 0, 2 and leaves the three dwords alone.
The unit cases live in tests/action_family_6e_runtime_test.c (synthetic fixtures); the corpus driver runs the 68 rows of
the decoded scenes through the binding; the original-x86 oracle is tests/action_family_6e_runtime_original_oracle.py
(needs the private work/ evidence and Unicorn).
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
TEST_C = PROJECT / 'tests/action_family_6e_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_6e_runtime_corpus.c'
KERNEL_SOURCES = ['scene_stack.c', 'session_bindings_a6e.c']
CORPUS_SOURCES = ['scene_stack.c', 'session_bindings_a6e.c', 'action_core.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXECUTOR_C = PROJECT / 'tests/action_family_6e_runtime_executor.c'
EXECUTOR_SOURCES = ['scene_stack.c', 'session_bindings_a6e.c', 'action_core.c', 'scene_resource.c', 'hiff.c', 'scene_executor.c',
                    'scene_conditions.c', 'scene_dependencies.c', 'action_family_64.c']
EXPECTED_UNIT_TESTS = 8


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
        cls.binary = Path(cls.tmp.name) / 'a6e_test'
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
            out = Path(self.tmp.name) / 'a6e_test_san'
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
            'scene word from the second global': ('scene_stack.c', 'slot->scene_5c3a05 = (int16_t)current->scene_5bb57b;',
                                                   'slot->scene_5c3a05 = (int16_t)current->scene_5bb57f;'),
            'scene word keeps 32 bits': ('scene_stack.c', 'slot->scene_5c3a07 = (int16_t)current->scene_5bb57f;',
                                          'slot->scene_5c3a07 = (int16_t)(current->scene_5bb57f & 0x7fff);'),
            'type argument ignored': ('scene_stack.c', 'slot->word_5c3a0d = (int16_t)type_argument;', 'slot->word_5c3a0d = (int16_t)(type_argument * 0 + 2);'),
            'dword 13 keeps the first store': ('scene_stack.c', 'slot->dword_5c3a13 = current->dword_5bb5af;', 'slot->dword_5c3a13 = current->dword_5bb5ab;'),
            'dword 17 written': ('scene_stack.c', 'slot->dword_5c3a13 = current->dword_5bb5af;',
                                  'slot->dword_5c3a17 = current->dword_5bb5af; slot->dword_5c3a13 = current->dword_5bb5af;'),
            'init marker': ('scene_stack.c', 'slot->scene_5c3a05 = SCENE_STACK_EMPTY_MARKER;\n    slot->scene_5c3a07', 'slot->scene_5c3a05 = 0;\n    slot->scene_5c3a07'),
            'init clears the dwords': ('scene_stack.c', 'slot->word_5c3a0d = 2;\n}', 'slot->word_5c3a0d = 2;\n    slot->dword_5c3a17 = 0;\n}'),
            'push argument': ('session_bindings_a6e.h', '#define SESSION_A6E_PUSH_ARGUMENT 2', '#define SESSION_A6E_PUSH_ARGUMENT 3'),
            'phase cleared': ('session_bindings_a6e.c', 'out->phase = before->phase;', 'out->phase = 0u;'),
            'generic completion': ('session_bindings_a6e.c', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;',
                                    'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
            'missing provider tolerated': ('session_bindings_a6e.c', 'if (b->host.load_current == NULL) {', 'if (0) {'),
            'provider failure ignored': ('session_bindings_a6e.c', 'if (b->host.load_current(b->host.context, &current) != 0) {', 'if (b->host.load_current(b->host.context, &current) > 5) {'),
            'body length unchecked': ('session_bindings_a6e.c', 'if (action->typed_body_length != ACTION_FAMILY_6E_BODY_BYTES) {', 'if (0) {'),
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
    """The production executor drives synthetic 0x6e rows (gate, DIRECT_COMPLETED bookkeeping, registration of the handler)."""

    @classmethod
    def setUpClass(cls):
        sys.path.insert(0, str(PROJECT / 'tests'))
        import test_scene_executor as base
        cls.tmp = tempfile.TemporaryDirectory()
        gated = base.action(0x6e, 1, b'\0', (base.condition(2, 3, 1),))
        plain = base.action(0x6e, 2, b'\0')
        cls.scene = Path(cls.tmp.name) / 'scene6e.bin'
        cls.scene.write_bytes(base.scene_bytes([gated, plain]))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec6e'):
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
                done = self.run_executor(work, 'exec6e_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_6e_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a6e_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 48 scenes, 68 rows, all subtype 1, every row has one dependency record behind its one body byte (always 0)
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['error']), (48, 68, 68, 0))
        self.assertEqual((summary['sub1'], summary['sub_other'], summary['tail_rows']), (68, 0, 68))
        self.assertEqual((summary['body_zero'], summary['body_other'], summary['pushes']), (68, 0, 68))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_6e_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
