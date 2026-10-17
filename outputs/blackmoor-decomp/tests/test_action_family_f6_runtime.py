"""RT-47: raw 0xf6 card puzzle runtime (src/action_family_f6_runtime.c) and its session binding.

Facts under test (original GAME.EXE, read from the disassembly of 0x45f0e6, 0x45de8a, 0x45e1ca, 0x45e587, 0x45e6bd,
0x45e906, 0x45e9db, 0x45eb76, 0x45dd4d, 0x460f26):
 * phase 0 stores the row, the active flag and [0x5bb1ca], deals one card to each player (two _rand draws per card),
   takes the first free Z entry, loads the image only when the object has none and ends in phase 1;
 * phase 1 is a twelve-state machine on obj+0x39e (delivery / no-card animations, card slides, human and computer
   turns, set scoring, refill, spoken lines with a caption, waits, end of game); the computer picks its columns with
   _rand, a spoken line is chosen with _rand among the real (not "NO SOUND") names;
 * a click on a column button or card plays the pick line and asks for the column choice; the exit rectangle asks for
   phase 2; phase 2 applies the win / draw block (finished, not exited) or the exit block, runs the generic completion
   and cleans the object up.
The unit cases live in tests/action_family_f6_runtime_test.c (synthetic bodies); the corpus driver runs the 6 rows of
the decoded scenes through the binding. The original-x86 oracle is tests/action_family_f6_runtime_original_oracle.py
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
TEST_C = PROJECT / 'tests/action_family_f6_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_f6_runtime_corpus.c'
KERNEL_SOURCES = ['action_family_f6_runtime.c']
BINDING_SOURCES = KERNEL_SOURCES + ['session_bindings_af6.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 21


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


MUTATIONS = {
    'unit compare in the signed pick modulus': ('idx = (int16_t)(r % (int32_t)count);', 'idx = (int16_t)(r % (int32_t)(count + 1));'),
    'deal row modulus uses the columns': ('row = (int16_t)(r1 % (int32_t)rows_of(c));', 'row = (int16_t)(r1 % (int32_t)cols_of(c));'),
    'deal column modulus uses the rows': ('col = (int16_t)(r2 % (int32_t)cols_of(c));', 'col = (int16_t)(r2 % (int32_t)rows_of(c));'),
    'deal draws column before row': ('CHECK(draw(c, &r1));\n            row = (int16_t)(r1 % (int32_t)rows_of(c));\n            CHECK(draw(c, &r2));',
                                     'CHECK(draw(c, &r2));\n            row = (int16_t)(r2 % (int32_t)rows_of(c));\n            CHECK(draw(c, &r1));'),
    'three cards allowed in a column': ('o->count[player][col] + 1 < 3)', 'o->count[player][col] + 1 < 4)'),
    'free pick threshold': ('const int free_pick = o->deck_left <= cols_of(c);', 'const int free_pick = o->deck_left < cols_of(c);'),
    'deck not consumed': ('o->deck_left = (int16_t)(o->deck_left - 1);', '(void)0;'),
    'move does not clear the source': ('o->card[from][row][col] = 0;', '(void)0;'),
    'move counts the wrong player': ('o->count[to][col] = (int16_t)(o->count[to][col] + 1);', 'o->count[from][col] = (int16_t)(o->count[from][col] + 1);'),
    'find card scans only one row': ('for (int16_t r = 0; r < rows_of(c); ++r) {\n        if (c->o->card[player][r][col] == 1) {',
                                     'for (int16_t r = 0; r < 1; ++r) {\n        if (c->o->card[player][r][col] == 1) {'),
    'refill rule uses two cards per set': ('(int)c->o->score[player] * 3) return deal(c, player, &col);\n    return F6_OK;\n}\n\n/* 0x45eadc */',
                                           '(int)c->o->score[player] * 2) return deal(c, player, &col);\n    return F6_OK;\n}\n\n/* 0x45eadc */'),
    'refill b ignores an empty hand': ('if (sum == 0 || (int)sum', 'if ((int)sum'),
    'computer pick takes a full column': ('if (!seen && o->count[0][col] < 3) {', 'if (!seen && o->count[0][col] < 4) {'),
    'computer pick takes an empty column': ('} else if (0 < o->count[0][col]) {', '} else if (0 <= o->count[0][col]) {'),
    'computer order not recorded': ('o->order[o->order_count] = *out;', '(void)0;'),
    'slide deadline interval dropped': ('o->state = ST_SLIDE;\n    o->after_slide = next;\n    CHECK(tick(c, &now));\n    o->deadline_anim = now + (uint32_t)rd_s32(b, B_SLIDE_INTERVAL);',
                                        'o->state = ST_SLIDE;\n    o->after_slide = next;\n    CHECK(tick(c, &now));\n    o->deadline_anim = now;'),
    'forward slide start step': ('o->slide_step = 0;\n        o->slide_sheet[idx][0] = (int32_t)((uint32_t)o->slide_sheet[idx][0] - (uint32_t)back);',
                                  'o->slide_step = 1;\n        o->slide_sheet[idx][0] = (int32_t)((uint32_t)o->slide_sheet[idx][0] - (uint32_t)back);'),
    'pick line shows no caption': ('o->caption_shown = 1;', '(void)0;'),
    'pick line skips the sound': ('HOST(c->h->sound_play(c->h->context, record_channel(o)));\n        fx(c->h, F6_FX_SOUND_PLAY, record_channel(o), 0);',
                                  '(void)0;'),
    'pick line state': ('        o->state = ST_LINE;\n    }\n    return F6_OK;\n}\n\n/* 0x45e906', '    }\n    return F6_OK;\n}\n\n/* 0x45e906'),
    'caption terminator dropped': ('memcpy(buffer + len, "<e>", 4u);', 'memcpy(buffer + len, "<>", 3u);'),
    'real sound test': ('if (memcmp(name, k, sizeof k) == 0) return 0;\n    return name[0] != 0;', 'if (memcmp(name, k, sizeof k) == 0) return 0;\n    return name[0] == 0;'),
    'draw ends with the human': ('CHECK(pick_line(c, B_LIST_END, 2));\n            o->outcome_2a8 = 0;\n        } else if (o->score[0] == o->score[1]) {',
                                 'CHECK(pick_line(c, B_LIST_END, 2));\n            o->outcome_2a8 = 1;\n        } else if (o->score[0] == o->score[1]) {'),
    'win block on exit': ('} else if (rd_s16(b, B_EXIT + XB_SCENE) != F6_NO_SCENE) {', '} else if (rd_s16(b, B_EXIT + XB_SCENE) == F6_NO_SCENE) {'),
    'exit click does not ask for phase 2': ('object->exit_taken = 1;\n        *new_phase = 2u;', 'object->exit_taken = 1;\n        *new_phase = 1u;'),
    'button click does not press': ('object->button_down = 1;', '(void)0;'),
    'card click goes to the wrong state': ('object->state = ST_CHOOSE;\n    } else if (candidate == F6_CANDIDATE_BUTTON)',
                                           'object->state = ST_TURN;\n    } else if (candidate == F6_CANDIDATE_BUTTON)'),
}


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'f6_test'
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
            out = Path(self.tmp.name) / 'f6_test_san'
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
        original = (SRC / 'action_family_f6_runtime.c').read_text()
        for name, (old, new) in MUTATIONS.items():
            with self.subTest(name):
                self.assertEqual(original.count(old), 1, 'mutation anchor drifted')
                work = Path(self.tmp.name) / 'mut'
                shutil.rmtree(work, ignore_errors=True)
                work.mkdir()
                for item in SRC.iterdir():
                    if item.suffix in ('.c', '.h'):
                        shutil.copy(item, work / item.name)
                (work / 'action_family_f6_runtime.c').write_text(original.replace(old, new, 1))
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, results = run_unit(binary)
                self.assertNotEqual(code, 0, 'mutation survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_f6_runtime.sh')],
                              capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'f6_corpus'
            built = compile_c(binary, CORPUS_C, BINDING_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['played'], summary['exited'], summary['error']),
                         (3, 6, 6, 6, 0))
        self.assertEqual(summary['loads'], summary['releases'])
        self.assertEqual(done.stdout.count('SCENE_FAIL') + done.stdout.count('ROW_FAIL'), 0)


class Registration(unittest.TestCase):
    def test_progress_map_sees_the_live_handler(self):
        import importlib.util
        spec = importlib.util.spec_from_file_location('playable', PROJECT / 'decomp-progress/playable.py')
        playable = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(playable)
        actions = playable.derive_actions(PROJECT)
        self.assertIn('0xf6', actions['handled']['types'])
        self.assertEqual(actions['registrations']['external']['0xf6'], 'native_af6_handler')


if __name__ == '__main__':
    unittest.main()
