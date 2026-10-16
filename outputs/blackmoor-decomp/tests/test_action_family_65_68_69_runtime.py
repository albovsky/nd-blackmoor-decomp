"""RT-37: raw 0x65 "SAVE_CONTINUE", raw 0x68 "start timer" and raw 0x69 "clear timer" (src/session_bindings_a65_a68_a69.c).

Facts under test (original GAME.EXE; loader arms 0x40d116, 0x40d364 and 0x40d428 copy one byte, dispatcher arms 0x4285fd,
0x4286ee and 0x42875d of 0x427a50, all gate mode 0):
 * 0x65 calls the save routine 0x4d7a15 with the game object 0x5e2e70, the name "SAVE CONTINUE" and 0, then sets the completion
   byte itself; the body byte is never read;
 * 0x68 and 0x69 clear the timer record (byte body[0]) * 0x106 + 0x585d65 with 0x433bd2; 0x68 then stores the dword 1 at record+0;
   the completion byte is set by the arm in all three: no 0x42ba3a, no dependency reset and no phase write, whatever the subtype.
The unit cases live in tests/action_family_65_68_69_runtime_test.c (synthetic fixtures); the corpus driver runs the 24 rows of the
decoded scenes through the binding; the original-x86 oracle is tests/action_family_65_68_69_runtime_original_oracle.py (needs the
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
TEST_C = PROJECT / 'tests/action_family_65_68_69_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_65_68_69_runtime_corpus.c'
KERNEL_SOURCES = ['session_bindings_a65_a68_a69.c']
CORPUS_SOURCES = ['session_bindings_a65_a68_a69.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXECUTOR_C = PROJECT / 'tests/action_family_65_68_69_runtime_executor.c'
EXECUTOR_SOURCES = ['session_bindings_a65_a68_a69.c', 'action_core.c', 'scene_resource.c', 'hiff.c', 'scene_executor.c',
                    'scene_conditions.c', 'scene_dependencies.c', 'action_family_64.c']
EXPECTED_UNIT_TESTS = 5
BINDING = 'session_bindings_a65_a68_a69.c'
HEADER = 'session_bindings_a65_a68_a69.h'


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


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a65_test'
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
            out = Path(self.tmp.name) / 'a65_test_san'
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
        save = '    b->host.save_game(b->host.context, SESSION_A65_SAVE_NAME, 0);'
        mutations = {
            'save name changed': (HEADER, '#define SESSION_A65_SAVE_NAME "SAVE CONTINUE"', '#define SESSION_A65_SAVE_NAME "SAVE CONTINUF"'),
            'report_failure 1': (BINDING, save, save.replace(', 0);', ', 1);')),
            'save skipped': (BINDING, save, '    (void)b->host.save_game;'),
            'save twice': (BINDING, save, save + '\n' + save),
            'timer state 0': (HEADER, '#define SESSION_A68_STATE_RUNNING 1', '#define SESSION_A68_STATE_RUNNING 0'),
            'timer state 2': (HEADER, '#define SESSION_A68_STATE_RUNNING 1', '#define SESSION_A68_STATE_RUNNING 2'),
            '0x69 starts the timer': (BINDING, 'SESSION_A69_TYPE, 0);', 'SESSION_A69_TYPE, 1);'),
            '0x68 does not start the timer': (BINDING, 'SESSION_A68_TYPE, 1);', 'SESSION_A68_TYPE, 0);'),
            'record not cleared': (BINDING, '    session_timer_record_clear(record);', '    (void)record;'),
            'pair index words zero': (BINDING, 'record[RECORD_FLAG_PAIR_OFFSET + 4u * k + 1u] = 0xffu;', 'record[RECORD_FLAG_PAIR_OFFSET + 4u * k + 1u] = 0u;'),
            'pair loop one short': (BINDING, 'for (k = 0u; k < RECORD_FLAG_PAIR_COUNT; ++k) {', 'for (k = 0u; k + 1u < RECORD_FLAG_PAIR_COUNT; ++k) {'),
            'no sound string': (BINDING, 'static const char no_sound[] = "NO SOUND";', 'static const char no_sound[] = "NO SOUNE";'),
            'sound string at the wrong offset': (BINDING, '#define RECORD_SOUND_OFFSET 0x28u', '#define RECORD_SOUND_OFFSET 0x2cu'),
            'phase cleared': (BINDING, 'out->phase = before->phase;', 'out->phase = 0u; (void)before;'),
            'generic completion': (BINDING, 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
            'wrong type accepted': (BINDING, ' || action->type != type) {', ') { (void)type;'),
            'body length unchecked': (BINDING, 'if (action->typed_body_length != body_bytes || action->typed_body == NULL) {', 'if ((void)body_bytes, 0) {'),
            'record table missing tolerated': (BINDING, 'if (b->host.time_record == NULL) {', 'if (0) {'),
            'save hook missing tolerated': (BINDING, 'if (b->host.save_game == NULL) {', 'if (0) {'),
            'unknown timer index tolerated': (BINDING, '    if (record == NULL) {', '    if (0) {'),
        }
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, filename, old, new)
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, _ = run_unit(binary)
                self.assertNotEqual(code, 0, 'mutant survived: ' + name)


class ExecutorTests(unittest.TestCase):
    """The production executor drives synthetic rows (gate, DIRECT_COMPLETED bookkeeping, registration of the handlers)."""

    @classmethod
    def setUpClass(cls):
        sys.path.insert(0, str(PROJECT / 'tests'))
        import test_scene_executor as base
        cls.tmp = tempfile.TemporaryDirectory()
        gated_start = base.action(0x68, 1, bytes([3]), (base.condition(2, 3, 1),))
        clear = base.action(0x69, 2, bytes([3]))
        save = base.action(0x65, 1, b'\0')
        cls.scene = Path(cls.tmp.name) / 'scene65.bin'
        cls.scene.write_bytes(base.scene_bytes([gated_start, clear, save]))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec65'):
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
                work = mutated_copy(self.tmp.name, filename, old, new)
                done = self.run_executor(work, 'exec65_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_65_68_69_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a65_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 21 scenes; 7 + 10 + 7 rows, all subtype 1; 0x65 body byte always 0; timer indexes 1..8; 7 rows carry a dependency tail
        self.assertEqual((summary['scenes'], summary['rows65'], summary['rows68'], summary['rows69']), (21, 7, 10, 7))
        self.assertEqual((summary['ok65'], summary['ok68'], summary['ok69'], summary['error']), (7, 10, 7, 0))
        self.assertEqual((summary['sub1'], summary['sub_other'], summary['tail_rows']), (24, 0, 7))
        self.assertEqual((summary['max_index'], summary['body65_nonzero']), (8, 0))
        self.assertEqual((summary['visits65'], summary['visits68'], summary['visits69']), (7, 10, 7))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_65_68_69_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
