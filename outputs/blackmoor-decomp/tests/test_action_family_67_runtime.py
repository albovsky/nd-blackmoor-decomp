"""RT-30: raw 0x67 "set the start flag" (src/session_bindings_a67.c).

Facts under test (original GAME.EXE; loader arm 0x40d29f copies one byte, dispatcher arm 0x428692 of 0x427a50):
 * after the dependency gate (mode 0) the arm stores 1 in the process-wide start flag DAT_005bb1ca (0x4286b5) and then
   sets the row's completion byte to 1 itself (0x4286cc); neither the generic completion 0x42ba3a nor a dependency reset
   runs, and the phase word is untouched, whatever the subtype;
 * the body byte is never read.
The unit cases live in tests/action_family_67_runtime_test.c (synthetic fixtures); the corpus driver runs the 27 rows of the
decoded scenes through the binding; the original-x86 oracle is tests/action_family_67_runtime_original_oracle.py (needs the
private work/ evidence and Unicorn).
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
TEST_C = PROJECT / 'tests/action_family_67_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_67_runtime_corpus.c'
KERNEL_SOURCES = ['session_bindings_a67.c']
CORPUS_SOURCES = ['session_bindings_a67.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXECUTOR_C = PROJECT / 'tests/action_family_67_runtime_executor.c'
EXECUTOR_SOURCES = ['session_bindings_a67.c', 'action_core.c', 'scene_resource.c', 'hiff.c', 'scene_executor.c',
                    'scene_conditions.c', 'scene_dependencies.c', 'action_family_64.c']
EXPECTED_UNIT_TESTS = 3


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
        cls.binary = Path(cls.tmp.name) / 'a67_test'
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
            out = Path(self.tmp.name) / 'a67_test_san'
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
            'flag value 0': ('session_bindings_a67.h', '#define SESSION_A67_START_FLAG_VALUE 1', '#define SESSION_A67_START_FLAG_VALUE 0'),
            'flag value 2': ('session_bindings_a67.h', '#define SESSION_A67_START_FLAG_VALUE 1', '#define SESSION_A67_START_FLAG_VALUE 2'),
            'flag not reported to the host': ('session_bindings_a67.c', '    b->host.set_start_flag(b->host.context, b->start_flag);',
                                               '    (void)b->host.set_start_flag;'),
            'flag only for subtype 1': ('session_bindings_a67.c', '    b->host.set_start_flag(b->host.context, b->start_flag);',
                                         '    if (action->subtype == 1u) b->host.set_start_flag(b->host.context, b->start_flag);'),
            'flag or-ed instead of stored': ('session_bindings_a67.c', '    b->start_flag = SESSION_A67_START_FLAG_VALUE;',
                                              '    b->start_flag |= SESSION_A67_START_FLAG_VALUE + 2;'),
            'phase cleared': ('session_bindings_a67.c', 'out->phase = before->phase;', 'out->phase = 0u;'),
            'generic completion': ('session_bindings_a67.c', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;',
                                    'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
            'missing sink tolerated': ('session_bindings_a67.c', 'if (b->host.set_start_flag == NULL) {', 'if (0) {'),
            'body length unchecked': ('session_bindings_a67.c', 'if (action->typed_body_length != ACTION_FAMILY_67_BODY_BYTES) {', 'if (0) {'),
            'wrong type accepted': ('session_bindings_a67.c', ' || action->type != SESSION_A67_TYPE) {', ') {'),
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
    """The production executor drives synthetic 0x67 rows (gate, DIRECT_COMPLETED bookkeeping, registration of the handler)."""

    @classmethod
    def setUpClass(cls):
        sys.path.insert(0, str(PROJECT / 'tests'))
        import test_scene_executor as base
        cls.tmp = tempfile.TemporaryDirectory()
        gated = base.action(0x67, 1, b'\0', (base.condition(2, 3, 1),))
        plain = base.action(0x67, 2, b'\0')
        cls.scene = Path(cls.tmp.name) / 'scene67.bin'
        cls.scene.write_bytes(base.scene_bytes([gated, plain]))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec67'):
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
                done = self.run_executor(work, 'exec67_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_67_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a67_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 25 scenes, 27 rows, all subtype 1, body byte always 0, no dependency tail (A-67.1 corpus census)
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['error']), (25, 27, 27, 0))
        self.assertEqual((summary['sub1'], summary['sub_other'], summary['tail_rows']), (27, 0, 0))
        self.assertEqual((summary['body_zero'], summary['body_other'], summary['visits']), (27, 0, 27))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_67_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
