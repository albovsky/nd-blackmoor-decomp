"""RT-39: raw 0x4b caption text row (src/session_bindings_a4b.c over src/action_family_4b.c).

Facts under test (original GAME.EXE; loader arm 0x40c625 of 0x40b34a, dispatcher arm 0x42816e of 0x427a50, gate mode 0): the
loader builds the row object (length word = text length + 3, the text, the marker "<e>"); selector -1 resolves a 33-byte AUTOTEXT
key through 0x423259 (a missing key becomes "Game Error (please contact Tech Support) missing auto text: <key><n>"), any other
selector is an inline byte count. The arm calls the caption writer 0x448d11 on the text box 0x619a05 with the caption surface
[0x5d03b3], the text at object + 2, mode -1 and measure 0, then the generic completion 0x42ba3a(row): subtype 1 completes, subtype 2
resets the dependencies and stays open, the phase is cleared.
The unit cases live in tests/action_family_4b_runtime_test.c (a synthetic scene written here); the corpus driver runs the 9 rows of
the decoded scenes through the binding; the original-x86 oracle is tests/action_family_4b_runtime_original_oracle.py (needs the
private work/ evidence and Unicorn).
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
TEST_C = PROJECT / 'tests/action_family_4b_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_4b_runtime_corpus.c'
EXECUTOR_C = PROJECT / 'tests/action_family_4b_runtime_executor.c'
KERNEL_SOURCES = ['session_bindings_a4b.c', 'action_family_4b.c', 'scene_resource.c', 'hiff.c']
CORPUS_SOURCES = KERNEL_SOURCES + ['autotext.c']
EXECUTOR_SOURCES = KERNEL_SOURCES + ['action_core.c', 'scene_executor.c', 'scene_conditions.c', 'scene_dependencies.c',
                                     'action_family_64.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 3
BINDING = 'session_bindings_a4b.c'

sys.path.insert(0, str(PROJECT / 'tests'))
import test_scene_executor as base  # noqa: E402


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


def compile_c(output, main_c, sources, src_dir=SRC):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g',
           f'-I{src_dir}', str(main_c), *[str(Path(src_dir) / s) for s in sources], '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


def run_unit(binary, scene):
    done = subprocess.run([str(binary), str(scene)], capture_output=True, text=True)
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


def inline(text):
    return struct.pack('<h', len(text)) + text


def key(name):
    return struct.pack('<h', -1) + name.ljust(33, b'\0')


def unit_scene():
    """Rows 0 inline "Hi there", 1 key KEYHIT, 2 key NOSUCH (subtype 2), 3 inline empty, 4 a 0x45 row the binding ignores."""
    return base.scene_bytes([base.action(0x4b, 1, inline(b'Hi there')), base.action(0x4b, 1, key(b'KEYHIT')),
                             base.action(0x4b, 2, key(b'NOSUCH')), base.action(0x4b, 1, inline(b'')),
                             base.action(0x45, 1, bytes(196))])


def executor_scene():
    """The first four rows, row 1 behind event flag 3 == 1."""
    return base.scene_bytes([base.action(0x4b, 1, inline(b'Hi there')),
                             base.action(0x4b, 1, key(b'KEYHIT'), (base.condition(2, 3, 1),)),
                             base.action(0x4b, 2, key(b'NOSUCH')), base.action(0x4b, 1, inline(b''))])


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a4b_test'
        built = compile_c(cls.binary, TEST_C, KERNEL_SOURCES)
        assert built.returncode == 0, built.stderr
        cls.scene = Path(cls.tmp.name) / 'unit4b.bin'
        cls.scene.write_bytes(unit_scene())

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def test_unit_cases_pass(self):
        code, results = run_unit(self.binary, self.scene)
        self.assertGreaterEqual(len(results), EXPECTED_UNIT_TESTS)
        for name, (status, message) in sorted(results.items()):
            with self.subTest(name):
                self.assertEqual(status, 'PASS', message)
        self.assertEqual(code, 0)

    def test_sanitizers_on_the_unit_cases(self):
        for cc in (compiler(), shutil.which('gcc')):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'a4b_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined',
                   f'-I{SRC}', str(TEST_C), *[str(SRC / s) for s in KERNEL_SOURCES], '-lm', '-o', str(out)]
            if subprocess.run(cmd, capture_output=True, text=True).returncode != 0:
                continue
            env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0')
            done = subprocess.run([str(out), str(self.scene)], capture_output=True, text=True, env=env)
            self.assertEqual(done.returncode, 0, done.stdout[-400:] + done.stderr[-400:])
            self.assertGreaterEqual(done.stdout.count('PASS'), EXPECTED_UNIT_TESTS)
            return
        self.skipTest('no compiler with an ASan/UBSan runtime in this environment')

    def test_mutations_are_detected(self):
        """The cases must fail when a recovered rule is deliberately broken (the oracle has its own mutants for the loader
        objects, the writer calls and the dispositions; these cover the host-status mapping the oracle cannot reach)."""
        mutations = {
            'unsupported writer reported as success': ('    if (written == SESSION_A4B_WRITE_UNSUPPORTED) {', '    if (0) {'),
            'writer failure ignored': ('    if (written != SESSION_A4B_WRITE_OK) {', '    if (0) {'),
            'wrong type accepted': (' || action->type != SESSION_A4B_TYPE ||', ' ||'),
            'no-lookup key rows built anyway': ('        if (binding->host.lookup == NULL) {\n            *deferred = 1;', '        if (0) {\n            *deferred = 1;'),
            'unsupported row visited': ('    if (row->state == SESSION_A4B_ROW_UNSUPPORTED) {', '    if (0) {'),
            'writer not counted': ('    ++binding->writes;\n', ''),
            'lookup failure tolerated': ('lookup_status == ACTION_FAMILY_51_LOOKUP_ERROR ||', '0 ||'),
            'table value not cut at the NUL': ('resolved_bytes = bounded_strlen(resolved, resolved_bytes);', '(void)bounded_strlen;'),
            'missing key not formatted': ('int written = snprintf(missing, sizeof(missing), ACTION_FAMILY_51_MISSING_FORMAT, (const char *)decoded.text_key);',
                                          'int written = snprintf(missing, sizeof(missing), "%s", (const char *)decoded.text_key);'),
            'failed scene keeps the previous objects': ('        free(scratch);\n        release_rows(binding);   /* the previous scene\'s objects must not answer for this scene\'s rows */\n', '        free(scratch);\n'),
            'phase not cleared': ('    result->phase = 0u;\n    return SCENE_ACTION_HANDLER_OK;', '    result->phase = state_before->phase;\n    return SCENE_ACTION_HANDLER_OK;'),
            'row index off by one': ('    row = &binding->rows[action_index];\n    if (row->state == SESSION_A4B_ROW_UNSUPPORTED) {',
                                     '    row = &binding->rows[action_index ? action_index - 1u : 0u];\n    if (row->state == SESSION_A4B_ROW_UNSUPPORTED) {'),
        }
        for name, (old, new) in mutations.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, BINDING, old, new)
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, _ = run_unit(binary, self.scene)
                self.assertNotEqual(code, 0, 'mutant survived: ' + name)


class ExecutorTests(unittest.TestCase):
    """The production executor drives the synthetic rows (gate, generic completion by subtype) with the real binding."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.scene = Path(cls.tmp.name) / 'scene4b.bin'
        cls.scene.write_bytes(executor_scene())

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec4b'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), str(self.scene)], capture_output=True, text=True)

    def test_executor_writes_in_row_order_and_applies_the_subtype_completion(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        mutations = {
            'subtype 2 completes for good': ('result->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'result->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;'),
            'rows left open': ('result->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'result->disposition = SCENE_ACTION_HANDLER_PENDING;'),
        }
        for name, (old, new) in mutations.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, BINDING, old, new)
                done = self.run_executor(work, 'exec4b_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_4b_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not (RESOURCES / '0001.bin').exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a4b_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), str(RESOURCES / '0001.bin'), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 5 scenes, 9 rows, all key rows (none inline), subtype 1, 8 with dependency tails, 1 key missing from the AUTOTEXT table
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['bad'], summary['scene_fail']), (5, 9, 9, 0, 0))
        self.assertEqual((summary['keyed'], summary['inline'], summary['tail_rows']), (9, 0, 8))
        self.assertEqual((summary['sub0'], summary['sub1'], summary['sub2'], summary['sub_other']), (0, 9, 0, 0))
        self.assertEqual((summary['lookups'], summary['missing'], summary['writes']), (9, 1, 9))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_4b_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)
        self.assertIn('"corpus_rows": 9', done.stdout)  # a missing corpus would silently drop its scenarios


if __name__ == '__main__':
    unittest.main()
