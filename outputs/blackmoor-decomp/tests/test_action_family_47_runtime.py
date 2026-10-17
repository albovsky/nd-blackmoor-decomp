"""RT-42: raw 0x47 journal entry add (src/session_bindings_a47.c over src/action_family_47_runtime.c).

Facts under test (original GAME.EXE; loader 0x411a22, dispatcher arm 0x428515 of 0x427a50 (gate mode 0), appender 0x412787): the
row body is 39 bytes (kind word 3, 4 or 5, a 33-byte name, a code word at +0x23 and a link-value word at +0x25). The appender
ends the visit when a stored entry has the same name, asks the AUTOTEXT table 0x423259 for the name once per other stored entry
(a miss ends the visit), and otherwise adds the entry (strcpy, code word, link value: kept for code >= 10 or 7, else 9999),
counts it and, for kinds 4 and 3, sets the page-2 "new entry" flags; every path ends with the generic completion 0x42ba3a.
The unit cases live in tests/action_family_47_runtime_test.c; the corpus driver runs the 139 rows of the 4 decoded scenes through
the binding; the original-x86 oracle is tests/action_family_47_runtime_original_oracle.py (needs the private work/ evidence and
Unicorn).
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
TEST_C = PROJECT / 'tests/action_family_47_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_47_runtime_corpus.c'
EXECUTOR_C = PROJECT / 'tests/action_family_47_runtime_executor.c'
KERNEL_SOURCES = ['session_bindings_a47.c', 'action_family_47_runtime.c', 'scene_resource.c', 'hiff.c']
EXECUTOR_SOURCES = KERNEL_SOURCES + ['action_core.c', 'scene_executor.c', 'scene_conditions.c', 'scene_dependencies.c',
                                     'action_family_64.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 7
BINDING = 'session_bindings_a47.c'
KERNEL = 'action_family_47_runtime.c'

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


def row_body(kind, name, code, value):
    return struct.pack('<h', kind) + name.ljust(33, b'\0') + struct.pack('<hh', code, value)


def executor_scene():
    """Row 0 adds CURJ00 to the kind-4 table, row 1 CURJ01 behind event flag 3 == 1, row 2 CURJ00 to the kind-3 table (subtype 2)."""
    return base.scene_bytes([base.action(0x47, 1, row_body(4, b'CURJ00', 0, -1)),
                             base.action(0x47, 1, row_body(4, b'CURJ01', 0, -1), (base.condition(2, 3, 1),)),
                             base.action(0x47, 2, row_body(3, b'CURJ00', 7, 5))])


# each mutant must be caught by the unit cases
KERNEL_MUTANTS = {
    'link value kept for any code': ('(body->code >= 10 || body->code == 7) ? body->value', '1 ? body->value'),
    'link value dropped for code 7': ('(body->code >= 10 || body->code == 7) ? body->value', '(body->code >= 10) ? body->value'),
    'link value threshold off by one': ('body->code >= 10 ||', 'body->code > 10 ||'),
    'link value threshold unsigned': ('body->code >= 10 ||', '(uint16_t)body->code >= 10u ||'),
    'wrong special code': ('body->code == 7)', 'body->code == 8)'),
    'no-link value zero': ('(int16_t)A47_NO_LINK;', '(int16_t)0;'),
    'flag slots swapped': ('body->kind == 4 ? 0u : 1u', 'body->kind == 4 ? 1u : 0u'),
    'flag call for every kind': ('if (body->kind == 4 || body->kind == 3) {', 'if (1) {'),
    'flag call for kind 4 only': ('if (body->kind == 4 || body->kind == 3) {', 'if (body->kind == 4) {'),
    'any flag not set': ('        tables->page2_any = 1u;\n', ''),
    'duplicate not detected': ('strcmp((const char *)tables->name[table][entry], (const char *)body->name) == 0', '0'),
    'duplicate compared on the first byte only': ('strcmp((const char *)tables->name[table][entry], (const char *)body->name) == 0',
                                                  'strncmp((const char *)tables->name[table][entry], (const char *)body->name, 1u) == 0'),
    'lookup miss ignored': ('        if (found == 0) {', '        if (0) {'),
    'lookup key one byte short': ('found = lookup(context, body->name, name_bytes);', 'found = lookup(context, body->name, name_bytes - 1u);'),
    'lookup failure tolerated': ('        if (found < 0) {', '        if (0) {'),
    'lookup skipped without a binding': ('        if (lookup == NULL) {\n            return A47_ERR_UNBOUND;', '        if (0) {\n            return A47_ERR_UNBOUND;'),
    'table index off by one': ('(size_t)(body->kind - A47_FIRST_KIND)', '(size_t)(body->kind - A47_FIRST_KIND + (body->kind > 3))'),
    'count not grown': ('    tables->count[table] = (int16_t)(count + 1);\n', ''),
    'full table not refused': ('    if (count == (int16_t)A47_MAX_ENTRIES) {\n        return A47_ERR_FULL;\n    }\n', ''),
    'name copied without its NUL': ('name_bytes + 1u', 'name_bytes'),
    'whole name field copied': ('name_bytes + 1u', 'A47_NAME_BYTES'),
    'code word not stored': ('    tables->code[table][count] = body->code;\n', ''),
    'kind 6 accepted': ('body->kind >= A47_FIRST_KIND + (int)A47_TABLES', 'body->kind >= A47_FIRST_KIND + (int)A47_TABLES + 1'),
    'name offset wrong': ('memcpy(out->name, raw + 2, A47_NAME_BYTES);', 'memcpy(out->name, raw + 3, A47_NAME_BYTES - 1u);'),
    'value offset wrong': ('out->value = le16(raw + 0x25);', 'out->value = le16(raw + 0x24);'),
}
BINDING_MUTANTS = {
    'unsupported lookup reported as success': ('    case A47_ERR_UNBOUND:', '    case 1000:'),
    'full table unsupported instead of an error': ('        binding->failure = "journal table is full (400 entries)";\n        return SCENE_ACTION_HANDLER_ERROR;',
                                                   '        binding->failure = "journal table is full (400 entries)";\n        return SCENE_ACTION_HANDLER_UNSUPPORTED;'),
    'wrong type accepted': (' || action->type != SESSION_A47_TYPE) {', ') {'),
    'phase kept': ('    result->phase = 0u;\n    return SCENE_ACTION_HANDLER_OK;', '    result->phase = state_before->phase;\n    return SCENE_ACTION_HANDLER_OK;'),
    'direct completion': ('result->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'result->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;'),
    'row left pending': ('result->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'result->disposition = SCENE_ACTION_HANDLER_PENDING;'),
    'lookup not found treated as found': ('    case ACTION_FAMILY_51_LOOKUP_NOT_FOUND:\n        return 0;', '    case ACTION_FAMILY_51_LOOKUP_NOT_FOUND:\n        return 1;'),
    'lookup error treated as miss': ('    default:\n        return -1;', '    default:\n        return 0;'),
    'adds not counted': ('    binding->adds += binding->last.appended;\n', ''),
    'reset leaves the flags': ('        memset(&binding->tables, 0, sizeof(binding->tables));', '        memset(&binding->tables, 0, offsetof(A47Tables, page2_any));'),
}


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a47_test'
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
            out = Path(self.tmp.name) / 'a47_test_san'
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
        """The cases must fail when a recovered rule is deliberately broken (the oracle has its own mutants for the stores and
        the lookup calls; these also cover the host-status mapping the oracle cannot reach)."""
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
        cls.scene = Path(cls.tmp.name) / 'scene47.bin'
        cls.scene.write_bytes(executor_scene())

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec47'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), str(self.scene)], capture_output=True, text=True)

    def test_executor_adds_in_row_order_and_applies_the_subtype_completion(self):
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
                done = self.run_executor(work, 'exec47_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_47_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not (RESOURCES / '0001.bin').exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a47_corpus'
            built = compile_c(binary, CORPUS_C, KERNEL_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 4 scenes (2874..2877), 139 rows, all subtype 1, 134 with dependency tails; 65 kind-3 and 74 kind-4 rows, every one a
        # fresh name in a per-scene table, so all 139 add and each sets a page-2 flag
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['bad']), (4, 139, 139, 0))
        self.assertEqual((summary['tail_rows'], summary['sub1'], summary['sub0'], summary['sub2'], summary['sub_other']), (134, 139, 0, 0, 0))
        self.assertEqual((summary['kind3'], summary['kind4'], summary['kind5']), (65, 74, 0))
        self.assertEqual((summary['flagged'], summary['duplicates'], summary['adds']), (139, 0, 139))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_47_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)
        self.assertIn('"corpus_rows": 139', done.stdout)  # a missing corpus would silently drop its scenarios


if __name__ == '__main__':
    unittest.main()
