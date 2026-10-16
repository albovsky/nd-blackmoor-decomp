"""RT-33: raw 0x2e "random movie" control row (src/session_bindings_a2e.c).

Facts under test (original GAME.EXE; loader arm 0x40c114 builds the 15-byte body, dispatcher arm 0x427f62 of 0x427a50 calls
handler 0x4ced84 on the object at 0x63821d after the dependency gate, mode 0):
 * every visit stores the row (+0x242) and the signed body byte (+0x23a) in the object; only if the object is active (+0x216)
   does the mode act: 1 = variable store, scene change, start flag, state 1de := 2 and flag 206 := 0; 2 = state 1de := 0 (or 3
   and 25a := 0 when 25a was set), flag 206 := 1; other modes nothing; mode 0 calls the random-movie stop 0x4ceb3b, which this
   slice does not model (refused before any effect);
 * every returning path sets the completion byte of the row at +0x242 directly: DIRECT_COMPLETED, phase untouched, whatever the
   subtype.
The unit cases live in tests/action_family_2e_runtime_test.c (synthetic fixtures); the corpus driver runs the 10 rows of the
decoded scenes through the binding; the original-x86 oracle is tests/action_family_2e_runtime_original_oracle.py (needs the
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
TEST_C = PROJECT / 'tests/action_family_2e_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_2e_runtime_corpus.c'
KERNEL_SOURCES = ['session_bindings_a2e.c', 'action_family_2e.c']
CORPUS_SOURCES = ['session_bindings_a2e.c', 'action_family_2e.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXECUTOR_C = PROJECT / 'tests/action_family_2e_runtime_executor.c'
EXECUTOR_SOURCES = ['session_bindings_a2e.c', 'action_family_2e.c', 'action_core.c', 'scene_resource.c', 'hiff.c', 'scene_executor.c',
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


def mutate(tmp, filename, old, new, tag):
    original = (SRC / filename).read_text()
    assert original.count(old) == 1, 'mutation anchor drifted'
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
        cls.binary = Path(cls.tmp.name) / 'a2e_test'
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
            out = Path(self.tmp.name) / 'a2e_test_san'
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
        """The cases must fail when a recovered rule is deliberately broken (the oracle carries 36 more mutants)."""
        c = 'session_bindings_a2e.c'
        mutations = {
            'mode zero-extended': (c, 'mode = (int32_t)(int8_t)body.option_00;', 'mode = (int32_t)body.option_00;'),
            'active test inverted': (c, '    if (b->movie.active != 0) {\n        if (mode == 1) {', '    if (b->movie.active == 0) {\n        if (mode == 1) {'),
            'mode 0 not refused': (c, '        if (mode == 0) {\n            b->failure = "random movie stop', '        if (mode == 0 && 0) {\n            b->failure = "random movie stop'),
            'flag sign dropped': (c, 'b->world->event_flags[flag] = (int32_t)(int16_t)body.word[5];', 'b->world->event_flags[flag] = (int32_t)body.word[5];'),
            'flag index 0 skipped': (c, 'if (flag != SESSION_A2E_NO_FLAG) {\n                b->world->event_flags[flag]', 'if (flag > 0) {\n                b->world->event_flags[flag]'),
            'scene sentinel moved': ('session_bindings_a2e.h', '#define SESSION_A2E_NO_SCENE 9999', '#define SESSION_A2E_NO_SCENE 9998'),
            'start flag inverted': (c, 'const int32_t start = (int16_t)body.word[6] != 1 ? 1 : 0;', 'const int32_t start = (int16_t)body.word[6] == 1 ? 1 : 0;'),
            'scene dwords wrong': (c, 'request.opaque_dwords[2] = 1;', 'request.opaque_dwords[2] = 0;'),
            'mode 2 test inverted': (c, 'if (b->movie.pending_25a == 0) {', 'if (b->movie.pending_25a != 0) {'),
            'mode 2 pending kept': (c, '                b->movie.pending_25a = 0;\n                fx(b, index, SESSION_A2E_FX_PENDING_25A, 0);', '                fx(b, index, SESSION_A2E_FX_PENDING_25A, 0);'),
            'phase cleared': (c, 'out->phase = before->phase;', 'out->phase = 0u;'),
            'generic completion': (c, 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
            'missing sink tolerated': (c, 'if (b->host.set_start_flag == NULL) {', 'if (0) {'),
            'missing transition tolerated': (c, 'if ((int16_t)body.word[0] != SESSION_A2E_NO_SCENE && b->host.transition == NULL) {', 'if (0) {'),
            'table bound dropped': (c, 'if (flag != SESSION_A2E_NO_FLAG && (flag < 0 ||', 'if (0 && flag != SESSION_A2E_NO_FLAG && (flag < 0 ||'),
            'body length unchecked': (c, 'action->typed_body_length != ACTION_FAMILY_2E_BODY_BYTES) {', '0) {'),
            'wrong type accepted': (c, ' || action->type != SESSION_A2E_TYPE) {', ') {'),
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
    """The production executor drives synthetic 0x2e rows (gate, DIRECT_COMPLETED bookkeeping, registration of the handler)."""

    @classmethod
    def setUpClass(cls):
        sys.path.insert(0, str(PROJECT / 'tests'))
        import test_scene_executor as base
        import struct
        cls.tmp = tempfile.TemporaryDirectory()
        mode1 = struct.pack('<Bhhhhhhh', 1, 9999, 0, 0, 0, 5, 9, 0)
        mode2 = struct.pack('<Bhhhhhhh', 2, 0, 0, 0, 0, 0, 0, 0)
        gated = base.action(0x2e, 1, mode1, (base.condition(2, 3, 1),))
        plain = base.action(0x2e, 2, mode2)
        cls.scene = Path(cls.tmp.name) / 'scene2e.bin'
        cls.scene.write_bytes(base.scene_bytes([gated, plain]))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec2e'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), str(self.scene)], capture_output=True, text=True)

    def test_executor_gates_and_completes_the_rows(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        old = 'executor->states[index].completed = 1u;\n        executor->states[index].phase = handler_result.phase;\n        break;\n    case SCENE_ACTION_HANDLER_RESET_DEPENDENCIES:'
        new = 'executor->states[index].completed = 0u;\n        executor->states[index].phase = handler_result.phase;\n        break;\n    case SCENE_ACTION_HANDLER_RESET_DEPENDENCIES:'
        work = mutate(self.tmp.name, 'scene_executor.c', old, new, 'mut_exec')
        done = self.run_executor(work, 'exec2e_mut')
        self.assertNotEqual(done.returncode, 0, 'mutant survived: direct completion leaves the row open')


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_2e_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a2e_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 10 scenes, 10 rows, all subtype 1, two with a dependency tail; modes 0 (6 rows), 1 (2), 2 (2) (A-2E.1 census, re-run here)
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['error']), (10, 10, 10, 0))
        self.assertEqual((summary['sub1'], summary['sub_other'], summary['tail_rows']), (10, 0, 2))
        self.assertEqual((summary['mode0'], summary['mode1'], summary['mode2'], summary['mode3'], summary['mode_other']), (6, 2, 2, 0, 0))
        # active object: the four mode-1/2 rows complete, the six mode-0 rows are refused
        self.assertEqual((summary['active_ok'], summary['active_refused']), (4, 6))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_2e_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
