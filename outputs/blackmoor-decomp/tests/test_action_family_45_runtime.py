"""RT-38: raw 0x45 timer control (src/session_bindings_a45.c).

Facts under test (original GAME.EXE; dispatcher arm 0x4287cc of 0x427a50, gate mode 0): the arm reads the signed word body[0] as
timer record n of the table at 0x585d65 (0x106 bytes each) and the signed word body[2] as a sub-case 0..6 of the switch at
0x428842; any other value does nothing. 0 clears the record (0x433bd2), 1 and 2 store the state, 3 and 4 add and subtract
hours/minutes/seconds for the states 1, 2, 5 and 6 (subtraction clamps each field at zero; a seconds word >= 5000 reads the loader
word table at 0x5adb81), 5 and 6 configure the record for state 1 (limit values, 49 + 33 + 100 body bytes, the ten event pair
index words, the entries, state := sub-case). The arm sets the completion byte itself, or the row stays open when the sub-case
does not apply; no generic completion 0x42ba3a, no dependency reset, the phase word is never written.
The unit cases live in tests/action_family_45_runtime_test.c (synthetic fixtures); the corpus driver runs the 32 rows of the
decoded scenes through the binding; the original-x86 oracle is tests/action_family_45_runtime_original_oracle.py (needs the
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
TEST_C = PROJECT / 'tests/action_family_45_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_45_runtime_corpus.c'
KERNEL_SOURCES = ['session_bindings_a45.c', 'session_bindings_a65_a68_a69.c']
CORPUS_SOURCES = KERNEL_SOURCES + ['scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXECUTOR_C = PROJECT / 'tests/action_family_45_runtime_executor.c'
EXECUTOR_SOURCES = KERNEL_SOURCES + ['action_core.c', 'scene_resource.c', 'hiff.c', 'scene_executor.c', 'scene_conditions.c',
                                     'scene_dependencies.c', 'action_family_64.c']
EXPECTED_UNIT_TESTS = 5
BINDING = 'session_bindings_a45.c'
HEADER = 'session_bindings_a45.h'


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
        cls.binary = Path(cls.tmp.name) / 'a45_test'
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
            out = Path(self.tmp.name) / 'a45_test_san'
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
        state = 'return state == 1u || state == 2u || state == 5u || state == 6u;'
        store = 'rec_put(r, SESSION_TIMER_STATE, (uint32_t)mode);            /* 0x428877, 0x42889c */'
        mutations = {
            'mode 1 stores 2': (BINDING, store, 'rec_put(r, SESSION_TIMER_STATE, 2u);'),
            'mode 0 clears nothing': (BINDING, '        session_timer_record_clear(r);                              /* 0x428850 */', '        (void)r;'),
            'gate drops state 6': (BINDING, state, 'return state == 1u || state == 2u || state == 5u;'),
            'gate accepts state 3': (BINDING, state, 'return state == 1u || state == 2u || state == 3u || state == 5u || state == 6u;'),
            'add and subtract swapped': (BINDING, 'adjust(r, body, seconds, mode == 4);', 'adjust(r, body, seconds, mode == 3);'),
            'minutes not clamped': (BINDING, 'minutes = (int32_t)minutes < 0 ? 0u : minutes;', ''),
            'seconds per ms': (BINDING, '#define MS_PER_SECOND 0x3e8u', '#define MS_PER_SECOND 0x3e9u'),
            'table base 5001': (HEADER, '#define SESSION_A45_VARIABLE_BASE 0x1388', '#define SESSION_A45_VARIABLE_BASE 0x1389'),
            'table word unsigned': (BINDING, '    *value = table;', '    *value = (int32_t)(uint16_t)table;'),
            'name copy short': (BINDING, '#define NAME_BYTES 49u', '#define NAME_BYTES 48u'),
            'payload copy short': (BINDING, '#define PAYLOAD_BYTES 100u', '#define PAYLOAD_BYTES 99u'),
            'pair high word set too': (BINDING, '        r[0xdeu + 4u * k + 1u] = 0xffu;\n    }\n    for (k = 0u; k < count; ++k) {',
                                       '        r[0xdeu + 4u * k + 1u] = 0xffu;\n        r[0xdeu + 4u * k + 2u] = 0xffu;\n    }\n    for (k = 0u; k < count; ++k) {'),
            'entries one short': (BINDING, 'for (k = 0u; k < count; ++k) {                                  /* 0x428c37..0x428c9c: whole dwords */',
                                  'for (k = 0u; k + 1u < count; ++k) {'),
            'reserved dword kept': (BINDING, 'rec_put(r, SESSION_TIMER_RESERVED_14, 0u);', ''),
            'configure runs for any state': (BINDING, '} else if (rec_get(r, SESSION_TIMER_STATE) != 1u) {              /* 0x428b1b */', '} else if (0) {'),
            'mode 7 configures': (BINDING, 'if (mode < 0 || (unsigned)mode >= SESSION_A45_MODE_COUNT) {', 'if (mode < 0 || (unsigned)mode > SESSION_A45_MODE_COUNT) {'),
            'negative mode taken as signed': (BINDING, 'if (mode < 0 || (unsigned)mode >= SESSION_A45_MODE_COUNT) {', 'if (mode >= (int)SESSION_A45_MODE_COUNT) {'),
            'phase cleared': (BINDING, 'out->phase = before->phase;                                     /* the phase word is never written */', 'out->phase = 0u;'),
            'generic completion': (BINDING, 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* the completion byte := 1 by the arm itself */',
                                   'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
            'pending rows completed': (BINDING, 'out->disposition = SCENE_ACTION_HANDLER_PENDING;            /* the row is visited again next tick */',
                                       'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;'),
            'wrong type accepted': (BINDING, ' || action->type != SESSION_A45_TYPE) {', ') {'),
            'count unchecked': (BINDING, 'if (count < 0 || (unsigned)count > ACTION_FAMILY_45_MAX_ENTRIES ||', 'if (0 ||'),
            'record table missing tolerated': (BINDING, 'if (b->host.time_record == NULL) {', 'if (0) {'),
            'unknown timer index tolerated': (BINDING, '    if (r == NULL) {\n        b->failure = "timer index outside', '    if (0) {\n        b->failure = "timer index outside'),
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
    """The production executor drives synthetic rows (gate, PENDING revisit, DIRECT_COMPLETED bookkeeping) with the real binding."""

    @classmethod
    def setUpClass(cls):
        sys.path.insert(0, str(PROJECT / 'tests'))
        import test_scene_executor as base
        import struct
        cls.tmp = tempfile.TemporaryDirectory()

        def body(record, mode, seconds=0):
            b = bytearray(196)
            struct.pack_into('<5h', b, 0, record, mode, 0, 0, seconds)
            return bytes(b)

        rows = [base.action(0x45, 1, body(2, 3, 5)), base.action(0x45, 1, body(2, 1)),
                base.action(0x45, 1, body(2, 0), (base.condition(2, 3, 1),))]
        cls.scene = Path(cls.tmp.name) / 'scene45.bin'
        cls.scene.write_bytes(base.scene_bytes(rows))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec45'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), str(self.scene)], capture_output=True, text=True)

    def test_executor_revisits_open_rows_and_completes_the_others(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        mutations = {
            'pending row completed': ('session_bindings_a45.c', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;            /* the row is visited again next tick */',
                                      'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;'),
        }
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, filename, old, new)
                done = self.run_executor(work, 'exec45_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_45_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a45_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 9 scenes, 32 rows, all subtype 1: 4 x mode 0, 6 x mode 5, 22 x mode 6; 3 rows read the word table (seconds 5000, 5001, 5004)
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['unsupported'], summary['error']), (9, 32, 32, 0, 0))
        self.assertEqual((summary['sub1'], summary['sub_other'], summary['tail_rows']), (32, 0, 29))
        self.assertEqual([summary['mode%d' % m] for m in range(7)] + [summary['mode_other']], [4, 0, 0, 0, 0, 6, 22, 0])
        self.assertEqual((summary['table_rows'], summary['max_record'], summary['max_count']), (3, 8, 4))
        self.assertEqual((summary['completed'], summary['pending']), (32, 0))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_45_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)
        self.assertIn('"corpus_rows": 32', done.stdout)  # a missing corpus would silently drop its scenarios


if __name__ == '__main__':
    unittest.main()
