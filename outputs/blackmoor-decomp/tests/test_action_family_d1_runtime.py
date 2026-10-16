"""RT-35: raw 0xd1 Turning Puzzle runtime (src/action_family_d1_runtime.c) and its session binding.

Facts under test (original GAME.EXE, read from the disassembly of 0x4b64a9, 0x4b5d17, 0x4b617a, 0x4b6355, 0x4b7051):
 * phase 0 stores the row, the active flag and [0x5bb1ca], places each tile's destination rectangle at the view
   origin, takes the first free Z entry, loads the CIFTREE image only when the object has none, prepares the sound
   records whose name is not "NO SOUND" and ends in phase 1;
 * phase 1 is a six-state machine (idle/solved check, start, animate, wait for the GetTickCount deadline, auto-turn,
   win sound); a tile advances one frame per full sub-step run and wraps from frame F-1 to 0;
 * a click on a tile (candidate 0x276c) turns that tile and its linked tiles unless the turn sound is busy; the exit
   rectangle (0x276d) asks for phase 2; phase 2 applies the win block (solved, not exited) or the exit block, runs the
   generic completion and cleans the object up.
The unit cases live in tests/action_family_d1_runtime_test.c (synthetic bodies); the corpus driver runs the 11 rows of
the decoded scenes through the binding. The original-x86 oracle is tests/action_family_d1_runtime_original_oracle.py
(needs the private work/ evidence).
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
TEST_C = PROJECT / 'tests/action_family_d1_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_d1_runtime_corpus.c'
KERNEL_SOURCES = ['action_family_d1_runtime.c']
BINDING_SOURCES = KERNEL_SOURCES + ['session_bindings_ad1.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 18


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


def compile_c(output, main_c, sources, src_dir=SRC, extra=()):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-O1', '-g',
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
        cls.binary = Path(cls.tmp.name) / 'd1_test'
        built = compile_c(cls.binary, TEST_C, KERNEL_SOURCES, extra=('-Werror',))
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
            out = Path(self.tmp.name) / 'd1_test_san'
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
            'frame wrap off by one': ('if ((int32_t)o->frame[i] == (int32_t)frames - 1) {',
                                      'if ((int32_t)o->frame[i] == (int32_t)frames - 2) {'),
            'animate deadline factor': ('rd_s16(body, B_PACE_T) * 1000) / (int32_t)substeps);',
                                        'rd_s16(body, B_PACE_T) * 8000) / (int32_t)substeps);'),
            'auto deadline factor': ('rd_s16(body, B_PACE_T) * 8000) / (int32_t)rd_s16(body, B_SUBSTEPS));',
                                     'rd_s16(body, B_PACE_T) * 1000) / (int32_t)rd_s16(body, B_SUBSTEPS));'),
            'deadline compare strict': ('if (o->deadline <= now) {', 'if (o->deadline < now) {'),
            'hit top edge exclusive': ('if (rd_s32(body, h + 4) <= y && y <= rd_s32(body, h + 12)',
                                       'if (rd_s32(body, h + 4) < y && y <= rd_s32(body, h + 12)'),
            'hit bottom edge exclusive': ('y <= rd_s32(body, h + 12) && rd_s32(body, h) <= x',
                                          'y < rd_s32(body, h + 12) && rd_s32(body, h) <= x'),
            'links ignored': ('if (link != 0) object->moving[link - 1] = 1;', '(void)link;'),
            'win block on exit': ('if (o->exit_taken == 0) {', 'if (o->exit_taken != 0) {'),
            'cleanup keeps the slot': ('object->slot = D1_NO_SLOT; /* 0x4b5b8a */', '(void)0;'),
            'start flag lost in phase 2': ('D1World *world, const D1Host *host)\n{\n    world->start_flag_5bb1ca = 1;',
                                           'D1World *world, const D1Host *host)\n{\n    world->start_flag_5bb1ca = 0;'),
            'row flag ignored': ('if (body[B_ROW_FLAG] != 0) y += (uint32_t)(int32_t)tile * h;',
                                 'if (0) y += (uint32_t)(int32_t)tile * h;'),
            'sub-step factor missing': ('(uint32_t)(int32_t)frame * w * s', '(uint32_t)(int32_t)frame * w'),
            'image always reloaded': ('if (o->surface == 0u) {\n        uint32_t surface = 0;',
                                      'if (1) {\n        uint32_t surface = 0;'),
            'busy sound ignored': ('if (busy == 0) {\n            object->state = D1_STATE_ANIMATE;',
                                   'if (1) {\n            object->state = D1_STATE_ANIMATE;'),
            'solved check inverted': ('while (i < n && o->frame[i] == rd_s16(body, B_TARGET + (size_t)i * 2u)) ++i;',
                                      'while (i < n && o->frame[i] != rd_s16(body, B_TARGET + (size_t)i * 2u)) ++i;'),
            'exit and tile swapped': ('if (candidate == D1_CANDIDATE_EXIT) {', 'if (candidate == D1_CANDIDATE_TILE) {'),
            'moving kept when unsolved': ('if (o->solved == 0)\n                for', 'if (o->solved != 0)\n                for'),
            'step not advanced': ('o->step = (int16_t)(o->step + 1);', '(void)0;'),
            'event flag always stored': ('if (flag != D1_NO_FLAG) {\n            if (host->store_event_flag',
                                         'if (1) {\n            if (host->store_event_flag'),
            'view origin dropped': ('o->dst[i][0] = (int32_t)((uint32_t)rd_s32(body, d) + (uint32_t)vx);',
                                    'o->dst[i][0] = (int32_t)((uint32_t)rd_s32(body, d));'),
            'completion not signalled': ('result->completed = 1u;', 'result->completed = 0u;'),
            'pointer ignores the sub-step': ('(int16_t)(object->step - 1));', 'object->step);'),
            'turn sound played when flag clear': ('if (start_flag != 0) {', 'if (start_flag == 0) {'),
            'second sound record unchecked': ('if (!no_sound(body + B_SOUND1)) {\n        HOST(host->sound_prepare',
                                              'if (1) {\n        HOST(host->sound_prepare'),
        }
        original = (SRC / 'action_family_d1_runtime.c').read_text()
        for name, (old, new) in mutations.items():
            with self.subTest(name):
                self.assertEqual(original.count(old), 1, 'mutation anchor drifted')
                work = Path(self.tmp.name) / 'mut'
                shutil.rmtree(work, ignore_errors=True)
                work.mkdir()
                for item in SRC.iterdir():
                    if item.suffix in ('.c', '.h'):
                        shutil.copy(item, work / item.name)
                (work / 'action_family_d1_runtime.c').write_text(original.replace(old, new, 1))
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, results = run_unit(binary)
                self.assertNotEqual(code, 0, 'mutation survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_d1_runtime.sh')],
                              capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'd1_corpus'
            built = compile_c(binary, CORPUS_C, BINDING_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['solved'], summary['exited'], summary['error']),
                         (11, 11, 11, 11, 0))
        self.assertEqual(summary['loads'], summary['releases'])
        self.assertEqual(done.stdout.count('SCENE_FAIL') + done.stdout.count('ROW_FAIL'), 0)


class Registration(unittest.TestCase):
    def test_progress_map_sees_the_live_handler(self):
        import importlib.util
        spec = importlib.util.spec_from_file_location('playable', PROJECT / 'decomp-progress/playable.py')
        playable = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(playable)
        actions = playable.derive_actions(PROJECT)
        self.assertIn('0xd1', actions['handled']['types'])
        self.assertEqual(actions['registrations']['external']['0xd1'], 'native_ad1_handler')


if __name__ == '__main__':
    unittest.main()
