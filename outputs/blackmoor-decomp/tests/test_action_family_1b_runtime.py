"""RT-40: raw 0x1b two-table scene-change hotspot (src/session_bindings_a1b.c over src/action_family_1b_runtime.c).

Facts under test (original GAME.EXE; loader 0x414692, dispatcher arm 0x427c87 of 0x427a50 with gate mode 1, object method 0x414947,
pointer cascade case 0x4f22ad): the row phase dword picks the step. Phase 0 sets the start flag 0x5bb1ca, stores phase 1 and runs
phase 1; phase 1 clears the request and sets it again for the FIRST secondary record (18 bytes: selector word, four dwords) whose
selector equals 0x5bb50b, copying the low words of the four dwords into the row rectangle; phase 2 stores the completion byte
directly (no generic completion, the phase stays 2) and copies the FIRST primary record (22 bytes: key word, three words, three
dwords after the target) whose key equals the held item 0x583a29, else the object's fixed block, into the scene-change cells, then
sets the engine mode 4. Any other phase does nothing.
The unit cases live in tests/action_family_1b_runtime_test.c (a synthetic scene written here); the corpus driver runs the 4 rows
of the decoded scenes through the binding; the original-x86 oracle is tests/action_family_1b_runtime_original_oracle.py (needs the
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
TEST_C = PROJECT / 'tests/action_family_1b_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_1b_runtime_corpus.c'
EXECUTOR_C = PROJECT / 'tests/action_family_1b_runtime_executor.c'
KERNEL_SOURCES = ['session_bindings_a1b.c', 'action_family_1b_runtime.c', 'action_family_1b.c', 'scene_resource.c', 'hiff.c']
EXECUTOR_SOURCES = KERNEL_SOURCES + ['action_core.c', 'scene_executor.c', 'scene_conditions.c', 'scene_dependencies.c',
                                     'action_family_64.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 4
BINDING = 'session_bindings_a1b.c'
KERNEL = 'action_family_1b_runtime.c'

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


def body_1b(primary, fixed, secondary, tail=b''):
    """A-1B.1 layout: count, count x 22-byte records, 22 fixed bytes, count, count x 18-byte records, 16-byte dependency tail."""
    out = struct.pack('<h', len(primary))
    for key, target, w4, w6, w8, d0, d1, d2 in primary:
        out += struct.pack('<hhhhhiii', key, target, w4, w6, w8, d0, d1, d2)
    out += struct.pack('<5h3i', *fixed)
    out += struct.pack('<h', len(secondary))
    for selector, left, top, right, bottom in secondary:
        out += struct.pack('<hiiii', selector, left, top, right, bottom)
    return out + tail


FIXED = (11, -3, 7, -8, 9, 70000, -71000, 72)
FIXED_EMPTY = (22, -30, 70, -80, 90, 7, 8, 9)
PRIMARY = [(5, 4005, 1, 2, 3, 50, 51, 52), (9, 4009, -2, 3, 4, 90, -91, 92), (9, 4999, 0, 0, 0, 1, 1, 1)]
SECONDARY = [(7, 0x7abc0111, 0x7bcd0222, 0x7cde0333, 0x7def0444), (3, 0x555, 0x666, 0x777, 0x888), (7, 1, 2, 3, 4)]


def unit_scene():
    """Row 0 primary keys {5, 9, 9}, secondary selectors {7, 3, 7}; row 1 no records; row 2 a 0x45 row the binding ignores."""
    return base.scene_bytes([base.action(0x1b, 1, body_1b(PRIMARY, FIXED, SECONDARY)),
                             base.action(0x1b, 1, body_1b([], FIXED_EMPTY, [])),
                             base.action(0x45, 1, bytes(196))])


def executor_scene():
    """Row 0 hotspot (selector 7 rectangle 100,200,300,400; held item 5 goes to scene 4005, else the fixed block scene 1500),
    row 1 the same behind event flag 3 == 1 (subtype 2 on row 0, see below)."""
    primary = [(5, 4005, 1, 2, 3, 50, 51, 52)]
    fixed = (0, 1500, 0, 0, 0, 0, 0, 0)
    secondary = [(7, 100, 200, 300, 400)]
    # row 0 has subtype 2: the original ignores the subtype of a 0x1b row (no generic completion), the executor must too
    return base.scene_bytes([base.action(0x1b, 2, body_1b(primary, fixed, secondary)),
                             base.action(0x1b, 1, body_1b(primary, fixed, secondary), (base.condition(2, 3, 1),))])


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a1b_test'
        built = compile_c(cls.binary, TEST_C, KERNEL_SOURCES)
        assert built.returncode == 0, built.stderr
        cls.scene = Path(cls.tmp.name) / 'unit1b.bin'
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
            out = Path(self.tmp.name) / 'a1b_test_san'
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
        """The cases must fail when a recovered rule is deliberately broken (the oracle has its own mutants for the kernel's cell
        stream; these cover the host-status mapping and the diagnostics the oracle cannot reach)."""
        mutations = {
            'refused transition ignored': (BINDING, '        if (b->host.transition(b->host.context, &request) != 0) {', '        if (0) {'),
            'no transition provider tolerated': (BINDING, '    if (before->phase == 2u && b->host.transition == NULL) {', '    if (0) {'),
            'refused world tolerated': (BINDING, 'b->host.load_world(b->host.context, &world) != 0) {', '0) {'),
            'slot committed before the transition': (BINDING, '    if (result.finished) {\n        /* The 0x0a arm', '    b->slots[index] = slot;\n    if (result.finished) {\n        /* The 0x0a arm'),
            'row index off by one': (BINDING, 'action1b_step(&b->decoded[index],', 'action1b_step(&b->decoded[index ? index - 1u : 0u],'),
            'finish completes by subtype': (BINDING, 'SCENE_ACTION_HANDLER_DIRECT_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING'),
            'phase not reported': (BINDING, '    out->phase = result.phase_after;', '    out->phase = 0u;'),
            'pre-gate leaves the request': (BINDING, '        b->slots[index].request = 0;\n        b->current_row = index;', '        b->current_row = index;'),
            'world not stored': (BINDING, '    if (b->host.store_world != NULL) {', '    if (0) {'),
            'cursor without a held item uses the wrong word': (KERNEL, 'c.cursor_index = as_s16(decoded->fixed_words[0]);', 'c.cursor_index = as_s16(decoded->fixed_words[1]);'),
            'held cursor offset by one': (KERNEL, 'c.cursor_index = (int32_t)held_item + 0x25;', 'c.cursor_index = (int32_t)held_item + 0x26;'),
            'request not cleared before the scan': (KERNEL, '        s.request = 0;\n        fx(host, ACTION17_FX_REQUEST, 0);\n', ''),
        }
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, filename, old, new)
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, _ = run_unit(binary, self.scene)
                self.assertNotEqual(code, 0, 'mutant survived: ' + name)


class ExecutorTests(unittest.TestCase):
    """The production executor drives the synthetic rows (pre-gate, gate mode 1, phase 2 from an accepted release) with the real
    binding."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.scene = Path(cls.tmp.name) / 'scene1b.bin'
        cls.scene.write_bytes(executor_scene())

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec1b'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), str(self.scene)], capture_output=True, text=True)

    def test_executor_registers_scans_and_finishes_through_the_binding(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        mutations = {
            'finish completes by subtype': ('SCENE_ACTION_HANDLER_DIRECT_COMPLETED : SCENE_ACTION_HANDLER_PENDING',
                                            'SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING'),
            'finish never completes': ('SCENE_ACTION_HANDLER_DIRECT_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_PENDING : SCENE_ACTION_HANDLER_PENDING'),
            'pre-gate does not clear': ('        b->slots[index].request = 0;\n        b->current_row = index;', '        b->current_row = index;'),
        }
        for name, (old, new) in mutations.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, BINDING, old, new)
                done = self.run_executor(work, 'exec1b_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_1b_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not (RESOURCES / '0001.bin').exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a1b_corpus'
            built = compile_c(binary, CORPUS_C, KERNEL_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 4 scenes, 4 rows, all subtype 1, 2 with dependency tails, 5 primary and 4 secondary records, every row hovers and finishes
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['bad'], summary['scene_fail']), (4, 4, 4, 0, 0))
        self.assertEqual((summary['tail_rows'], summary['primary'], summary['secondary']), (2, 5, 4))
        self.assertEqual((summary['sub0'], summary['sub1'], summary['sub2'], summary['sub_other']), (0, 4, 0, 0))
        self.assertEqual((summary['hover_hits'], summary['transitions']), (4, 4))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_1b_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)
        self.assertIn('"corpus_rows": 4', done.stdout)  # a missing corpus would silently drop its scenarios


if __name__ == '__main__':
    unittest.main()
