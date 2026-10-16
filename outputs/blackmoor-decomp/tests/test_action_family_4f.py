"""RT-27: raw 0x4f "compare a value, set an event flag" (src/action_family_4f.c, src/session_bindings_a4f.c).

Facts under test (original GAME.EXE; loader 0x44b1b4 copies 10 bytes, dispatcher arm 0x428133 of 0x427a50 calls the
handler 0x44b641, completion 0x42ba3a):
 * the body is attribute, mode, operator, five operand bytes and an int16 event flag index;
 * the attribute (30 int16 + 10 float32 action values, 9999 = unset) is compared as an x87 float32 against the other
   float slots (mode 0), the int16 slots (mode 1), the slots named by the operands (mode 2) or the operand literals
   (mode 3, plus the percent form b3 * b4 / 100 for operators 5 to 7); the first match stores 1 in the flag;
 * the row then completes through the generic helper 0x42ba3a with phase 0.
The unit cases live in tests/action_family_4f_runtime_test.c (synthetic bodies); the corpus driver runs the 815 rows of
the decoded scenes through the binding; the original-x86 oracle is tests/action_family_4f_runtime_original_oracle.py
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
TEST_C = PROJECT / 'tests/action_family_4f_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_4f_runtime_corpus.c'
KERNEL_SOURCES = ['action_family_4f.c', 'session_bindings_a4f.c']
CORPUS_SOURCES = ['action_family_4f.c', 'session_bindings_a4f.c', 'action_core.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 14


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


def compile_c(output, main_c, sources, src_dir=SRC):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-ffp-contract=off',
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
        cls.binary = Path(cls.tmp.name) / 'a4f_test'
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
            out = Path(self.tmp.name) / 'a4f_test_san'
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
            'sentinel unset slot compared': ('action_family_4f.c', 'if (is_sentinel(other) || slot == d->attribute) {', 'if (slot == d->attribute) {'),
            'own slot compared': ('action_family_4f.c', 'if (is_sentinel(other) || slot == d->attribute) {', 'if (is_sentinel(other)) {'),
            'greater swapped with less': ('action_family_4f.c', 'case 1: return c0;\n    case 2: return !(c0 || c3);',
                                          'case 1: return !(c0 || c3);\n    case 2: return c0;'),
            'less-or-equal without equal': ('action_family_4f.c', 'default: return c0 || c3; /* 4, 7 */', 'default: return c0; /* 4, 7 */'),
            'nan ordered': ('action_family_4f.c', 'c0 = 1;\n        c3 = 1;', 'c0 = 0;\n        c3 = 0;'),
            'short body accepted': ('action_family_4f.c', 'if (length < ACTION_FAMILY_4F_BODY_BYTES) {', 'if (length < 9u) {'),
            'flag sign lost': ('action_family_4f.c', 'out->flag = (int16_t)((uint16_t)body[8] | ((uint16_t)body[9] << 8));',
                               'out->flag = (int16_t)((uint16_t)body[8] | (((uint16_t)body[9] & 0x7fu) << 8));'),
            'flag bound off by one': ('action_family_4f.c', '(size_t)decoded->flag >= world->event_flag_count', '(size_t)decoded->flag > world->event_flag_count'),
            'flag set to two': ('action_family_4f.c', 'world->event_flags[decoded->flag] = 1;', 'world->event_flags[decoded->flag] = 2;'),
            'unused literal compared': ('action_family_4f.c', 'if (decoded->operand[i] == 99u || decoded->op > 7u) {', 'if (decoded->op > 7u) {'),
            'percent divisor': ('action_family_4f.c', '/ 100.0;', '/ 10.0;'),
            'percent at every operand': ('action_family_4f.c', '} else if (i == 0u) {', '} else {'),
            'out-of-body read allowed': ('action_family_4f.c', 'if (offset >= ACTION_FAMILY_4F_BODY_BYTES) {', 'if (offset >= 64u) {'),
            'operand 40 allowed': ('action_family_4f.c', 'if (slot >= ATTRIBUTE_COUNT) {', 'if (slot >= 200u) {'),
            'attribute 40 evaluated': ('action_family_4f.c', 'if (decoded->attribute >= ATTRIBUTE_COUNT) {', 'if (decoded->attribute > ATTRIBUTE_COUNT + 100u) {'),
            'phase kept': ('session_bindings_a4f.c', 'out->phase = 0u;', 'out->phase = before->phase;'),
            'bounds failure ignored': ('session_bindings_a4f.c', 'if (status == ACTION_FAMILY_4F_ERR_BOUNDS) {', 'if (0) {'),
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


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_4f.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a4f_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 57 scenes, 815 rows, all subtype 1 and mode 3, operators 0 (782), 1 (13), 2 (19) and 3 (1), 68 rows with a dependency tail
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['error']), (57, 815, 815, 0))
        self.assertEqual((summary['mode3'], summary['other_mode'], summary['subtype1'], summary['tail_rows']), (815, 0, 815, 68))
        self.assertEqual((summary['op0'], summary['op1'], summary['op2'], summary['op3'], summary['op_other']), (782, 13, 19, 1, 0))
        self.assertEqual((summary['flag_none'], summary['flag_min'], summary['flag_max']), (0, 1000, 1588))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_4f_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
