"""RT-44: raw 0x4e float value recomputation (src/session_bindings_a4e.c over src/action_family_4e_runtime.c).

Facts under test (original GAME.EXE; loader 0x44b102, dispatcher arm 0x4280f9 of 0x427a50 (gate mode 1), method 0x44b3c8): the
row body is 31 bytes, a target byte and ten (selector byte, signed amount word) triples. A target outside 30..39 changes nothing.
Otherwise float slot target is cleared and each triple adds a term: selector 99 none, 0..29 amount / 100 * int16 slot, 30..39
amount / 100 * float slot (an unset 9999 slot, or NaN, contributes 0), 100 the amount itself, anything else is reported through
0x52139c and contributes 0; the arithmetic is x87 at 53-bit precision with float stores. Every path ends with the generic
completion 0x42ba3a. The unit cases live in tests/action_family_4e_runtime_test.c; the corpus driver runs the 18 rows of the 3
decoded scenes through the binding; the original-x86 oracle is tests/action_family_4e_runtime_original_oracle.py (needs the
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
TEST_C = PROJECT / 'tests/action_family_4e_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_4e_runtime_corpus.c'
EXECUTOR_C = PROJECT / 'tests/action_family_4e_runtime_executor.c'
KERNEL_SOURCES = ['session_bindings_a4e.c', 'action_family_4e_runtime.c', 'action_family_4e.c', 'action_core.c', 'scene_resource.c', 'hiff.c']
EXECUTOR_SOURCES = KERNEL_SOURCES + ['scene_executor.c', 'scene_conditions.c', 'scene_dependencies.c', 'action_family_64.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 10
BINDING = 'session_bindings_a4e.c'
KERNEL = 'action_family_4e_runtime.c'

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


def row_body(target, triples):
    triples = list(triples) + [(99, 0)] * (10 - len(triples))
    return bytes([target]) + b''.join(struct.pack('<Bh', sel, amount) for sel, amount in triples)


def executor_scene():
    """Row 0 sets slot 30 to 5, row 1 slot 31 to 50% of slot 30 behind event flag 3 == 1, row 2 (subtype 2) slot 32 to 1 + 100% of itself."""
    return base.scene_bytes([base.action(0x4E, 1, row_body(30, [(100, 5)])),
                             base.action(0x4E, 1, row_body(31, [(30, 50)]), (base.condition(2, 3, 1),)),
                             base.action(0x4E, 2, row_body(32, [(100, 1), (32, 100)]))])


# each mutant must be caught by the unit cases
KERNEL_MUTANTS = {
    'target range starts at 29': ('decoded->option_00 < ACTION_FAMILY_4E_FIRST_TARGET', 'decoded->option_00 < ACTION_FAMILY_4E_FIRST_TARGET - 1u'),
    'target range starts at 31': ('decoded->option_00 < ACTION_FAMILY_4E_FIRST_TARGET', 'decoded->option_00 < ACTION_FAMILY_4E_FIRST_TARGET + 1u'),
    'target range ends at 38': ('decoded->option_00 > ACTION_FAMILY_4E_LAST_TARGET', 'decoded->option_00 >= ACTION_FAMILY_4E_LAST_TARGET'),
    'target range ends at 40': ('decoded->option_00 > ACTION_FAMILY_4E_LAST_TARGET', 'decoded->option_00 > ACTION_FAMILY_4E_LAST_TARGET + 1u'),
    'target not cleared first': ('    *target = 0.0f;\n', ''),
    'skip selector not skipped': ('        if (selector == ACTION_FAMILY_4E_SELECTOR_SKIP) {\n            continue;\n        }\n', ''),
    'literal scaled by percent': ('term = (float)amount;', 'term = (float)amount / 100.0f;'),
    'literal amount unsigned': ('term = (float)amount;', 'term = (float)(uint16_t)amount;'),
    'short slot boundary 29': ('if (selector < ACTION_CORE_SHORT_SLOT_COUNT) {', 'if (selector < ACTION_CORE_SHORT_SLOT_COUNT - 1u) {'),
    'float slot boundary 38': ('} else if (selector <= ACTION_FAMILY_4E_LAST_TARGET) {', '} else if (selector < ACTION_FAMILY_4E_LAST_TARGET) {'),
    'short unset ignored': ('if (slot == UNSET_SHORT) {', 'if (0) {'),
    'float unset ignored': ('if (slot == UNSET_FLOAT || isnan(slot)) {', 'if (isnan(slot)) {'),
    'float nan not treated as unset': ('if (slot == UNSET_FLOAT || isnan(slot)) {', 'if (slot == UNSET_FLOAT) {'),
    'amount multiplied before dividing': ('return (float)(((double)(float)amount / PERCENT_DIVISOR) * slot);', 'return (float)(((double)(float)amount * slot) / PERCENT_DIVISOR);'),
    'percent divisor 10': ('#define PERCENT_DIVISOR 100.0', '#define PERCENT_DIVISOR 10.0'),
    'sum overwrites the target': ('*target = (float)((double)term + (double)*target);', '*target = term;'),
    'report term not zero': ('            o->report_selector[o->reports++] = selector;\n            term = 0.0f;', '            o->report_selector[o->reports++] = selector;\n            term = 1.0f;'),
    'report not recorded': ('o->report_selector[o->reports++] = selector;', 'o->reports += 0u;'),
    'target slot index off by one': ('&world->float_values[decoded->option_00 - ACTION_FAMILY_4E_FIRST_TARGET]', '&world->float_values[decoded->option_00 - ACTION_FAMILY_4E_FIRST_TARGET - (decoded->option_00 == 39u)]'),
    'last triple ignored': ('for (i = 0u; i < ACTION_FAMILY_4E_ENTRY_COUNT; ++i) {', 'for (i = 0u; i + 1u < ACTION_FAMILY_4E_ENTRY_COUNT; ++i) {'),
}
BINDING_MUTANTS = {
    'wrong type accepted': (' || action->type != SESSION_A4E_TYPE) {', ') {'),
    'phase kept': ('    out->phase = 0u; /* 0x42ba3a: [0x5bb632 + row*0x8d] = 0 */', '    out->phase = before->phase;'),
    'direct completion': ('out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;'),
    'row left pending': ('out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;'),
    'reports not counted': ('    b->reports += b->last.reports;\n', ''),
    'body failure ignored': ('    if (action_family_4e_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_4E_OK) {',
                             '    if (action_family_4e_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_4E_OK && 0) {'),
}


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a4e_test'
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
            out = Path(self.tmp.name) / 'a4e_test_san'
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
        """The cases must fail when a recovered rule is deliberately broken (the oracle has its own mutants for the arithmetic
        against the original; these also cover the host-status mapping the oracle cannot reach)."""
        for filename, mutations in ((KERNEL, KERNEL_MUTANTS), (BINDING, BINDING_MUTANTS)):
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
    """The production executor drives the synthetic rows (gate, generic completion by subtype) with the real binding."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.scene = Path(cls.tmp.name) / 'scene4e.bin'
        cls.scene.write_bytes(executor_scene())

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec4e'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), str(self.scene)], capture_output=True, text=True)

    def test_executor_recomputes_in_row_order_and_applies_the_subtype_completion(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        mutations = {
            'subtype 2 completes for good': ('out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;'),
            'rows left open': ('out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;'),
        }
        for name, (old, new) in mutations.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, BINDING, old, new)
                done = self.run_executor(work, 'exec4e_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_4e_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not (RESOURCES / '0001.bin').exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a4e_corpus'
            built = compile_c(binary, CORPUS_C, KERNEL_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 3 scenes, 18 rows, all subtype 1 with a dependency tail, every target in 30..39; the selectors are float slots 30..39
        # (24) and literals (12), against freshly initialized (unset) slots 9 of the 36 terms are skipped
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['bad']), (3, 18, 18, 0))
        self.assertEqual((summary['tail_rows'], summary['sub1'], summary['sub0'], summary['sub2'], summary['sub_other']), (18, 18, 0, 0, 0))
        self.assertEqual((summary['target_valid'], summary['terms'], summary['unset'], summary['reports']), (18, 36, 9, 0))
        self.assertEqual((summary['literal'], summary['short_sel'], summary['float_sel']), (12, 0, 24))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_4e_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)
        self.assertIn('"corpus_rows": 18', done.stdout)  # a missing corpus would silently drop its scenarios


if __name__ == '__main__':
    unittest.main()
