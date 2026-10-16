"""RT-24: raw 0xd9 Mouselight puzzle runtime (src/action_family_d9_runtime.c) and its session binding.

Facts under test (original GAME.EXE, read from the disassembly of 0x47d788 and 0x47df57):
 * phase 0 sets the tracking flag, [0x5bb1ca], the row, the active flag and the radius, allocates the
   composite (16 r^2 bytes), then a mask (mode 0: 1 where sqrt(dx^2+dy^2) < r) or a gaussian alpha map
   (mode != 0: exp(-(d2^2) / (r^4/2)) as float), takes the first free Z entry 0x18..0x3f, registers the
   type 10 render entry, loads the CIFTREE image only when the object has none, and ends in phase 1;
 * phase 1 keeps the previous window and clamps the new one to the scene source rectangle; a pointer
   below [0x583192] - [0x58318a] + 5 collapses the window to zero; the row never completes;
 * the scene clear releases the image, the buffers and the entry and resets the object, but not +0x1c,
   +0x1f, +0x55; the render callback restores the previous window and blits the current one (mask copy or
   alpha blend) with the mask rectangle offset where the window is clipped at the left/top edge.
The unit cases live in tests/action_family_d9_runtime_test.c (synthetic bodies); the corpus driver runs the
274 rows of the decoded scenes through the binding. The original-x86 oracle is
tests/action_family_d9_runtime_original_oracle.py (needs the private work/ evidence).
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/action_family_d9_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_d9_runtime_corpus.c'
KERNEL_SOURCES = ['action_family_d9_runtime.c']
BINDING_SOURCES = KERNEL_SOURCES + ['session_bindings_ad9.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 20


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


def compile_c(output, main_c, sources, src_dir=SRC, extra=()):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g',
           f'-I{src_dir}', *extra, str(main_c), *[str(Path(src_dir) / s) for s in sources],
           '-lm', '-o', str(output)]
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
        cls.binary = Path(cls.tmp.name) / 'd9_test'
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
        """ASan + UBSan over the same cases (bounds rejections, failed host calls, re-init, cleanup)."""
        for cc in (compiler(), shutil.which('gcc')):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'd9_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', '-fsanitize=address,undefined',
                   '-fno-sanitize-recover=undefined', f'-I{SRC}', str(TEST_C),
                   *[str(SRC / s) for s in KERNEL_SOURCES], '-lm', '-o', str(out)]
            if subprocess.run(cmd, capture_output=True, text=True).returncode != 0:
                continue
            env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0')
            done = subprocess.run([str(out)], capture_output=True, text=True, env=env)
            self.assertEqual(done.returncode, 0, done.stdout[-400:] + done.stderr[-400:])
            self.assertGreaterEqual(done.stdout.count('PASS'), EXPECTED_UNIT_TESTS)
            return
        self.skipTest('no compiler with an ASan/UBSan runtime in this environment')

    def test_mutations_are_detected(self):
        """The cases must fail when a recovered rule is deliberately broken."""
        mutations = {
            'left clamp dropped': ('object->rect[0] = px - r < 0 ? 0 : px - r;', 'object->rect[0] = px - r;'),
            'right edge off by one': ('if (px + r - 1 > view.max_x) object->rect[2] = view.max_x;',
                                      'if (px + r - 1 > view.max_x + 1) object->rect[2] = view.max_x;'),
            'view limit off by one': ('(int64_t)view.bottom - view.origin_y + 5', '(int64_t)view.bottom - view.origin_y + 4'),
            'previous window not kept': ('memcpy(object->prev, object->rect, sizeof(object->prev));', '(void)0;'),
            'pointer ignores tracking': ('if (object != NULL && object->tracking != 0u) {\n        object->pointer_x',
                                         'if (object != NULL) {\n        object->pointer_x'),
            'mask edge inclusive': ('sqrt((double)(y * y + x * x)) < (double)r ? 1u : 0u',
                                    'sqrt((double)(y * y + x * x)) <= (double)r ? 1u : 0u'),
            'alpha edge inclusive': ('if (!(sqrt((double)d2) < (double)radius)) return 0.0f;',
                                     'if (sqrt((double)d2) > (double)radius) return 0.0f;'),
            'alpha sigma changed': ('(r4 - (r4 >> 31)) >> 1', '(r4 - (r4 >> 31)) >> 2'),
            'image always reloaded': ('if (object->surface == 0u) {\n            uint32_t surface = 0u;',
                                      'if (1) {\n            uint32_t surface = 0u;'),
            'cleanup clears active': ('object->active = active;', 'object->active = 0u; (void)active;'),
            'map offset wrong': ('plan->map[0] = diameter - width;', 'plan->map[0] = width;'),
            'restore not offset': ('plan->restore_dst[i] = object->prev[i] + ox;', 'plan->restore_dst[i] = object->prev[i];'),
            'top offset without edge test': ('if (height < diameter && object->rect[1] == 0) plan->map[1]',
                                             'if (height < diameter) plan->map[1]'),
            'mask copies the wrong pixels': ('if (m[x] != 0u) store16', 'if (m[x] == 0u) store16'),
            'alpha rounds instead of chopping': ('return (uint32_t)(int64_t)value;',
                                                 'return (uint32_t)(int64_t)(value + (value < 0 ? -0.5 : 0.5));'),
            'start flag lost': ('world->start_flag_5bb1ca = 1;', 'world->start_flag_5bb1ca = 0;'),
            'invalidate ignores tracking': ('if (object->tracking != 0u && object->slot != D9_NO_SLOT) {',
                                            'if (object->slot != D9_NO_SLOT) {'),
        }
        original = (SRC / 'action_family_d9_runtime.c').read_text()
        for name, (old, new) in mutations.items():
            with self.subTest(name):
                self.assertEqual(original.count(old), 1, 'mutation anchor drifted')
                work = Path(self.tmp.name) / 'mut'
                shutil.rmtree(work, ignore_errors=True)
                work.mkdir()
                for item in SRC.iterdir():
                    if item.suffix in ('.c', '.h'):
                        shutil.copy(item, work / item.name)
                (work / 'action_family_d9_runtime.c').write_text(original.replace(old, new, 1))
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, results = run_unit(binary)
                self.assertNotEqual(code, 0, 'mutation survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_d9_runtime.sh')],
                              capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'd9_corpus'
            built = compile_c(binary, CORPUS_C, BINDING_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['error']), (245, 274, 274, 0))
        self.assertEqual((summary['alpha'], summary['mask']), (272, 2))
        self.assertEqual(summary['loads'], summary['releases'])
        self.assertEqual(done.stdout.count('SCENE_FAIL') + done.stdout.count('ROW_FAIL'), 0)


class Registration(unittest.TestCase):
    def test_progress_map_sees_the_live_handler(self):
        import importlib.util
        spec = importlib.util.spec_from_file_location('playable', PROJECT / 'decomp-progress/playable.py')
        playable = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(playable)
        actions = playable.derive_actions(PROJECT)
        self.assertIn('0xd9', actions['handled']['types'])
        self.assertEqual(actions['registrations']['external']['0xd9'], 'native_ad9_handler')


if __name__ == '__main__':
    unittest.main()
