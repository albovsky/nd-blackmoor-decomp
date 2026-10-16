"""RT-32: raw 0x94 "make a screen file" (src/session_bindings_a94.c with src/action_family_94_runtime.c).

Facts under test (original GAME.EXE; loader arm 0x40ea5e copies 50 bytes, dispatcher arm 0x429747 of 0x427a50 gates with
mode 0 and calls the handler 0x4c36b2 on the CDirectDraw object):
 * phase 0 sets the capture flag 0x5839a9, requests a redraw (0x4d36ed) and moves to phase 2;
 * phase 2 does nothing while the rectangle exceeds the screen (y1 > height or x1 > width, signed); otherwise it captures
   the front buffer, crops the rectangle (x0, y0, x1, y1 at body +0x21..+0x2d), writes name.BMP (24-bit, body +0x31 == 0,
   0x4c334f) or name.TGA (16-bit, top-left origin) through _makepath, clears the capture flag and moves to phase 3;
 * phase 3 is the generic completion 0x42ba3a (subtype behaviour, phase := 0); any other phase value does nothing.
The unit cases live in tests/action_family_94_runtime_test.c (synthetic fixtures); the corpus driver runs the 12 rows of the
decoded scenes through the binding; the original-x86 oracle is tests/action_family_94_runtime_original_oracle.py (needs the
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
TEST_C = PROJECT / 'tests/action_family_94_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_94_runtime_corpus.c'
KERNEL_SOURCES = ['session_bindings_a94.c', 'action_family_94_runtime.c']
CORPUS_SOURCES = KERNEL_SOURCES + ['scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXECUTOR_C = PROJECT / 'tests/action_family_94_runtime_executor.c'
EXECUTOR_SOURCES = KERNEL_SOURCES + ['action_core.c', 'scene_resource.c', 'hiff.c', 'scene_executor.c',
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


def copy_sources(work):
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir()
    for item in SRC.iterdir():
        if item.suffix in ('.c', '.h'):
            shutil.copy(item, work / item.name)


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a94_test'
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
        for cc in (shutil.which('gcc'), compiler()):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'a94_test_san'
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
            'phase 0 skips the flag': ('session_bindings_a94.c', 'b->host.set_capture_flag(b->host.context, 1);  /* 0x4c3719 */', '(void)0;'),
            'phase 0 skips the redraw request': ('session_bindings_a94.c', 'b->host.request_refresh(b->host.context);       /* 0x4c3727 */', '(void)0;'),
            'phase 0 goes to phase 1': ('session_bindings_a94.c', 'out->phase = A94_PHASE_CAPTURE;                 /* 0x4c3730: phase 0 jumps to 2 */', 'out->phase = 1u;'),
            'flag never cleared': ('session_bindings_a94.c', 'b->host.set_capture_flag(b->host.context, 0);  /* 0x4c3c19 */', '(void)0;'),
            'phase 3 not reached': ('session_bindings_a94.c', 'out->phase = A94_PHASE_DONE;                    /* 0x4c3c23 */', 'out->phase = A94_PHASE_CAPTURE;'),
            'completion without phase reset': ('session_bindings_a94.c', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED; /* 0x42ba3a */\n        out->phase = 0u;', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;\n        out->phase = 3u;'),
            'oversized rectangle captured': ('session_bindings_a94.c', 'if (!a94_capture_reachable(&display.screen, &request)) {', 'if (0) {'),
            'missing host tolerated': ('session_bindings_a94.c', 'if (!host_complete(&b->host)) {', 'if (!host_complete(&b->host) && 0) {'),
            'body length unchecked': ('session_bindings_a94.c', 'if (action->typed_body_length != A94_BODY_BYTES || action->typed_body == NULL) {', 'if (0) {'),
            'wrong type accepted': ('session_bindings_a94.c', ' || action->type != SESSION_A94_TYPE) {', ') {'),
            'reachable test uses width only': ('action_family_94_runtime.c', 'request->y1 <= (int32_t)screen->height && request->x1 <= (int32_t)screen->width', 'request->x1 <= (int32_t)screen->width'),
            'extension swapped': ('action_family_94_runtime.c', 'return request->format == 0u ? ".BMP" : ".TGA";', 'return request->format == 0u ? ".TGA" : ".BMP";'),
            'rows not flipped': ('action_family_94_runtime.c', 'uint8_t *dst = rows + (h - 1u - y) * stride;', 'uint8_t *dst = rows + y * stride;'),
            'bmp stride unpadded': ('action_family_94_runtime.c', 'stride = (3u * w + 3u) & ~(size_t)3u;', 'stride = 3u * w;'),
            'green not narrowed': ('action_family_94_runtime.c', 'g = (uint16_t)(g >> 1);', 'g = (uint16_t)(g >> 0);'),
            'tga origin bit': ('action_family_94_runtime.c', 'out[17] = 0x20u;', 'out[17] = 0x00u;'),
            'dir separator dropped': ('action_family_94_runtime.c', "            PUT('\\\\');\n        }\n    }\n    if (name != NULL) {", "            (void)0;\n        }\n    }\n    if (name != NULL) {"),
            'origin ignored in the domain': ('action_family_94_runtime.c', 'request->x0 >= 0 &&', '1 &&'),
        }
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                original = (SRC / filename).read_text()
                self.assertEqual(original.count(old), 1, 'mutation anchor drifted')
                work = Path(self.tmp.name) / 'mut'
                copy_sources(work)
                (work / filename).write_text(original.replace(old, new, 1))
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, _ = run_unit(binary)
                self.assertNotEqual(code, 0, 'mutant survived: ' + name)


class ExecutorTests(unittest.TestCase):
    """The production executor drives synthetic 0x94 rows (gate, three phases, completion bookkeeping)."""

    @classmethod
    def setUpClass(cls):
        sys.path.insert(0, str(PROJECT / 'tests'))
        import test_scene_executor as base
        cls.tmp = tempfile.TemporaryDirectory()
        body = bytearray(50)
        body[:4] = b'Shot'
        body[0x21:0x31] = (0).to_bytes(4, 'little') + (0).to_bytes(4, 'little') + (3).to_bytes(4, 'little') + (3).to_bytes(4, 'little')
        body[0x31] = 0
        gated = base.action(0x94, 1, bytes(body), (base.condition(2, 3, 1),))
        plain = base.action(0x94, 1, bytes(body))
        cls.scene = Path(cls.tmp.name) / 'scene94.bin'
        cls.scene.write_bytes(base.scene_bytes([gated, plain]))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec94'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), str(self.scene)], capture_output=True, text=True)

    def test_executor_gates_and_runs_the_three_phases(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        mutations = {
            'completion leaves the row open': ('scene_executor.c', 'executor->states[index].completed = completion.completed;',
                                                'executor->states[index].completed = 0u;'),
        }
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                original = (SRC / filename).read_text()
                self.assertEqual(original.count(old), 1, 'mutation anchor drifted')
                work = Path(self.tmp.name) / 'mut_exec'
                copy_sources(work)
                (work / filename).write_text(original.replace(old, new, 1))
                done = self.run_executor(work, 'exec94_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_94_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a94_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 12 scenes, 12 rows, all subtype 1, all BMP crops of the screen, no dependency tail (A-94.1 corpus census)
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['error']), (12, 12, 12, 0))
        self.assertEqual((summary['sub1'], summary['sub_other'], summary['tail_rows']), (12, 0, 0))
        self.assertEqual((summary['bmp'], summary['tga'], summary['full'], summary['crop']), (12, 0, 0, 12))
        self.assertEqual((summary['unreachable'], summary['invalid'], summary['files']), (0, 0, 12))
        self.assertEqual(done.stdout.count('ROW_FAIL'), 0)


class OriginalOracle(unittest.TestCase):
    def test_quick_scenarios_against_the_original_dispatcher(self):
        try:
            import unicorn  # noqa: F401
        except ImportError:
            self.skipTest('Unicorn is not installed')
        if not (ROOT / 'work/original/GAME.EXE').exists():
            self.skipTest('local original evidence (work/) is not present')
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_94_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
