"""RT-45: raw 0xea Onebuild puzzle runtime (src/action_family_ea_runtime.c) and its session binding.

Facts under test (original GAME.EXE, read from the disassembly of 0x4867bd and the helpers named in the header):
 * phase 0 builds one surface set per piece (rect B or A cut from the source image, rotated copies when rotation is
   allowed or a start orientation is set), takes the first free Z slot and ends in phase 1;
 * phase 1 is a seven-state machine on obj+0xbac (idle/solved check, pick-drop sound wait, feedback wait, animation
   step, timed wait, win sound wait, done); the sound waits use the 300/800/2000/100 ms GetTickCount deadlines;
 * the pointer receiver reports the pick/rotate/animation/exit candidates and, while dragging, the good or bad drop;
   the accepted-release click picks, rotates or drops a piece, or asks for the finish;
 * phase 2 applies the win block (solved, not exited) or the exit block, runs the generic completion and clears.
The unit cases live in tests/action_family_ea_runtime_test.c (synthetic bodies); the corpus driver runs the 6 rows of
the decoded scenes 2282..2284 through the binding. The original-x86 oracle is
tests/action_family_ea_runtime_original_oracle.py (needs the private work/ evidence).
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
TEST_C = PROJECT / 'tests/action_family_ea_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_ea_runtime_corpus.c'
KERNEL_SOURCES = ['action_family_ea_runtime.c']
BINDING_SOURCES = KERNEL_SOURCES + ['session_bindings_aea.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
PUZZLE_SCENES = ('2282.bin', '2283.bin', '2284.bin')
EXPECTED_UNIT_TESTS = 20


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
        cls.binary = Path(cls.tmp.name) / 'ea_test'
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
            out = Path(self.tmp.name) / 'ea_test_san'
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
            'pick sound deadline': ('wr_32(obj, O_DEADLINE, (int32_t)(now(host) + 300u));',
                                    'wr_32(obj, O_DEADLINE, (int32_t)(now(host) + 3000u));'),
            'feedback deadline': ('wr_32(obj, O_DEADLINE, (int32_t)(now(host) + 2000u));',
                                  'wr_32(obj, O_DEADLINE, (int32_t)(now(host) + 1000u));'),
            'done sound deadline': ('        wr_32(obj, O_DEADLINE2, (int32_t)(now(host) + 800u));\n        wr_32(obj, O_STATE, EA_STATE_WAIT);\n        wr_32(obj, O_FLAG_2F, 1);\n        return EA_OK;',
                                    '        wr_32(obj, O_DEADLINE2, (int32_t)(now(host) + 400u));\n        wr_32(obj, O_STATE, EA_STATE_WAIT);\n        wr_32(obj, O_FLAG_2F, 1);\n        return EA_OK;'),
            'animation start wait': ('HOST(host->sound_prepare(host->context, B_SND_ANIM, body + B_SND_ANIM));\n            wr_32(obj, O_DEADLINE2, (int32_t)(now(host) + 100u));',
                                     'HOST(host->sound_prepare(host->context, B_SND_ANIM, body + B_SND_ANIM));\n            wr_32(obj, O_DEADLINE2, (int32_t)(now(host) + 200u));'),
            'animation frame wait': ('wr_32(obj, O_DEADLINE2, (int32_t)(now(host) + 100u));\n        wr_32(obj, O_STATE, EA_STATE_ANIM_STEP);',
                                     'wr_32(obj, O_DEADLINE2, (int32_t)(now(host) + 200u));\n        wr_32(obj, O_STATE, EA_STATE_ANIM_STEP);'),
            'drop wait deadline strict': ('if (now(host) < (uint32_t)rd_s32(obj, O_DEADLINE)) return EA_OK;\n        HOST(host->sound_stop',
                                          'if (now(host) <= (uint32_t)rd_s32(obj, O_DEADLINE)) return EA_OK;\n        HOST(host->sound_stop'),
            'wait deadline strict': ('if (now(host) < (uint32_t)rd_s32(obj, O_DEADLINE2)) return EA_OK;\n        if (rd_s32(obj, O_FLAG_2F)',
                                     'if (now(host) <= (uint32_t)rd_s32(obj, O_DEADLINE2)) return EA_OK;\n        if (rd_s32(obj, O_FLAG_2F)'),
            'caption suffix dropped': ('memcpy(buf + n, "<e>", 4);', 'memcpy(buf + n, "", 1);'),
            'caption clear text': ('caption_show(host->context, "<n><e>")', 'caption_show(host->context, "<n>")'),
            'good drop tolerance sign': ('sub32(rd_s32(body, bp + BP_RECT_C), (int32_t)rd_s16(body, B_TOL)) <= rd_s32(obj, O_PREV) &&',
                                         'add32(rd_s32(body, bp + BP_RECT_C), (int32_t)rd_s16(body, B_TOL)) <= rd_s32(obj, O_PREV) &&'),
            'hit left edge exclusive': ('(int32_t)x <= qr) {', '(int32_t)x < qr) {'),
            'hit top edge exclusive': ('obj[Q + P_PLACED] == 0 && qt <= (int32_t)y', 'obj[Q + P_PLACED] == 0 && qt < (int32_t)y'),
            'exit rect inclusive edge': ('rd_s32(body, B_EXIT_RECT) <= (int32_t)x && (int32_t)x <= rd_s32(body, B_EXIT_RECT + 8)',
                                         'rd_s32(body, B_EXIT_RECT) <= (int32_t)x && (int32_t)x < rd_s32(body, B_EXIT_RECT + 8)'),
            'rotation order': ('if (obj[P + P_ORIENT] == 4) obj[P + P_ORIENT] = 0;', 'if (obj[P + P_ORIENT] == 3) obj[P + P_ORIENT] = 0;'),
            'rotate about the centre': ('cx = (int16_t)add32(rd_s32(obj, P + P_RECT), (int32_t)sw / 2);',
                                        'cx = (int16_t)add32(rd_s32(obj, P + P_RECT), (int32_t)sw);'),
            'top piece by lowest layer': ('if (rd_s16(obj, piece_off(best) + P_Z) < rd_s16(obj, piece_off(cand) + P_Z)) best = cand;',
                                          'if (rd_s16(obj, piece_off(best) + P_Z) > rd_s16(obj, piece_off(cand) + P_Z)) best = cand;'),
            'layer not raised': ('wr_16(obj, P + P_Z, (int16_t)(rd_s16(obj, P + P_Z) + 1));', '(void)0;'),
            'order list ignored': ('(body[B_ORDERED] == 0 ||\n             (body[B_ORDERED] != 0 &&', '(1 ||\n             (body[B_ORDERED] != 0 &&'),
            'flag 0x23 ignored': ('if (body[B_FLAG23] == 0) {', 'if (1) {'),
            'solved check inverted': ('if (obj[piece_off(k) + P_PLACED] == 0) {\n            if (rd_s32(body, bpiece_off(k) + BP_RECT_C + 4) != 0) return;',
                                      'if (obj[piece_off(k) + P_PLACED] != 0) {\n            if (rd_s32(body, bpiece_off(k) + BP_RECT_C + 4) != 0) return;'),
            'win block on exit': ('if (obj[O_EXIT] == 0) {\n        if (obj[O_DONE] != 0) {', 'if (obj[O_EXIT] != 0) {\n        if (obj[O_DONE] != 0) {'),
            'start flag lost in phase 2': ('EaWorld *world, const EaHost *host)\n{\n    world->start_flag_5bb1ca = 1;\n    if (obj[O_EXIT] == 0) {',
                                           'EaWorld *world, const EaHost *host)\n{\n    world->start_flag_5bb1ca = 0;\n    if (obj[O_EXIT] == 0) {'),
            'scene 9999 not skipped': ('if (rd_s16(blk, SB_SCENE) != EA_NO_SCENE) {', 'if (1) {'),
            'event flag always stored': ('if (flag != EA_NO_FLAG) HOST(host->store_event_flag', 'if (1) HOST(host->store_event_flag'),
            'view origin dropped': ('wr_32(obj, to, add32(src[0], v.origin_x));', 'wr_32(obj, to, src[0]);'),
            'clamp bottom keeps the size': ('wr_32(obj, off + 4, sub32(rd_s32(obj, off + 12), h));', 'wr_32(obj, off + 4, add32(rd_s32(obj, off + 12), h));'),
            'rect B preferred over A': ('if (!rect_valid(body, BP + BP_RECT_B)) {\n        w =', 'if (rect_valid(body, BP + BP_RECT_B)) {\n        w ='),
            'rotated copies skipped': ('if (body[B_ROT_ALLOWED] != 0 || obj[P + P_ORIENT] != 0) {', 'if (0) {'),
            'entry width not swapped': ('wr_16(obj, ent + ENT_W, rw);', 'wr_16(obj, ent + ENT_W, w);'),
            'placed piece keeps start orientation': ('obj[P + P_ORIENT] = 0;\n        if (body[B_LAYER_ON] != 0) {', '(void)0;\n        if (body[B_LAYER_ON] != 0) {'),
            'animation row compare': ('if (rd_s16(body, B_GRID_ROWS) <= cell) {', 'if (rd_s16(body, B_GRID_ROWS) < cell) {'),
            'animation column modulo': ('mul32(add32(rd_s16(obj, O_CELL_W), gap), frame % (int32_t)cols)', 'mul32(add32(rd_s16(obj, O_CELL_W), gap), frame / (int32_t)cols)'),
            'win sound skipped': ('if (no_sound(body + B_SND_WIN)) {\n            *row_phase = 2u;', 'if (1) {\n            *row_phase = 2u;'),
            'busy win sound ignored': ('HOST(host->sound_busy(host->context, rd_s16(body, B_CHAN_WIN), &busy));\n        if (busy != 0) return EA_OK;',
                                       'HOST(host->sound_busy(host->context, rd_s16(body, B_CHAN_WIN), &busy));\n        if (0) return EA_OK;'),
            'alternate sound never re-rolled': ('if (no_sound(body + alt2)) {\n                    HOST(rand3(host, r));', 'if (no_sound(body + alt2)) {\n                    done = 1;'),
            'orientation unchecked': ('else if (body[p + BP_ORIENT] > 3) why = "0xea-piece-orientation";', ''),
            'cleanup keeps the slot': ('if (rd_s16(obj, O_SLOT) != -1) HOST(host->release_slot(host->context, rd_s16(obj, O_SLOT)));', '(void)0;'),
            'second surface leaks': ('wr_32(obj, O_SRC, 0);\n    }\n    for (int16_t i = 0; i < 20; ++i)', 'wr_32(obj, O_SRC, 0);\n    }\n    for (int16_t i = 0; i < 0; ++i)'),
        }
        original = (SRC / 'action_family_ea_runtime.c').read_text()
        survived = []
        for name, (old, new) in mutations.items():
            with self.subTest(name):
                self.assertEqual(original.count(old), 1, 'mutation anchor drifted: ' + name)
                work = Path(self.tmp.name) / 'mut'
                shutil.rmtree(work, ignore_errors=True)
                work.mkdir()
                for item in SRC.iterdir():
                    if item.suffix in ('.c', '.h'):
                        shutil.copy(item, work / item.name)
                (work / 'action_family_ea_runtime.c').write_text(original.replace(old, new, 1))
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                try:
                    done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=30)
                    code = done.returncode
                except subprocess.TimeoutExpired:
                    code = -1
                if code == 0:
                    survived.append(name)
        self.assertEqual(survived, [], 'mutations survived')


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_ea_runtime.sh')],
                              capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        files = [RESOURCES / name for name in PUZZLE_SCENES]
        if not all(path.exists() for path in files):
            self.skipTest('local corpus evidence (work/) is not present')
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'ea_corpus'
            built = compile_c(binary, CORPUS_C, BINDING_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True, timeout=120)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['solved'], summary['exited'], summary['error']),
                         (3, 6, 6, 6, 0))
        self.assertEqual(summary['loads'] + summary['creates'], summary['releases'])
        self.assertEqual(done.stdout.count('SCENE_FAIL') + done.stdout.count('ROW_FAIL'), 0)


class Registration(unittest.TestCase):
    def test_progress_map_sees_the_live_handler(self):
        import importlib.util
        spec = importlib.util.spec_from_file_location('playable', PROJECT / 'decomp-progress/playable.py')
        playable = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(playable)
        actions = playable.derive_actions(PROJECT)
        self.assertIn('0xea', actions['handled']['types'])
        self.assertEqual(actions['registrations']['external']['0xea'], 'native_aea_handler')


if __name__ == '__main__':
    unittest.main()
