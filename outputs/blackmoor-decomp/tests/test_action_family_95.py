"""RT-26: raw 0x95 "Set Volume" (src/action_family_95.c, src/session_bindings_a95.c, sound_control_set_scalars).

Facts under test (original GAME.EXE; loader case 0x95 of 0x40b34a, dispatcher arm 0x429e41 of 0x427a50, setter
0x4fca60, volume helper 0x4f684a, completion 0x42ba3a):
 * the typed body is three bytes: a 16-bit channel and a volume byte; both scalars are (float)((double)byte / 100.0);
 * the setter stores both scalars in the channel slot, derives both attenuations from the category master
   (scalar * master * 2857.142822265625 - 2857.142857142857, truncated) and the volume helper clamps them to
   [-2857, 0] and calls SetVolume with the first one (error states 0x3ea, 0x3ef, 0x408 are recorded, not raised);
 * the row then completes through the generic helper 0x42ba3a with phase 0.
The unit cases live in tests/action_family_95_runtime_test.c (synthetic bodies); the corpus driver runs the 123 rows of
the decoded scenes through the binding; the original-x86 oracle is tests/action_family_95_runtime_original_oracle.py
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
TEST_C = PROJECT / 'tests/action_family_95_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_95_runtime_corpus.c'
KERNEL_SOURCES = ['action_family_95.c', 'session_bindings_a95.c', 'sound_control.c']
CORPUS_SOURCES = ['action_family_95.c', 'session_bindings_a95.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 12


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
        cls.binary = Path(cls.tmp.name) / 'a95_test'
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
            out = Path(self.tmp.name) / 'a95_test_san'
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
            'divisor 99': ('action_family_95.c', 'quotient = (double)body[2] / 100.0;', 'quotient = (double)body[2] / 99.0;'),
            'channel sign lost': ('action_family_95.c', 'out->channel = (int16_t)word;', 'out->channel = (int16_t)(word & 0x7fff);'),
            'volume byte offset': ('action_family_95.c', 'out->volume_percent = body[2];', 'out->volume_percent = body[1];'),
            'short body accepted': ('action_family_95.c', 'if (length < ACTION_FAMILY_95_BODY_BYTES) {',
                                    'if (length < 2u) {'),
            'channel 32 accepted': ('action_family_95.c', '(uint32_t)decoded->channel >= ACTION_FAMILY_95_CHANNEL_COUNT',
                                    '(uint32_t)decoded->channel > ACTION_FAMILY_95_CHANNEL_COUNT'),
            'second scalar from first': ('action_family_95.c', 'decoded->scalar, decoded->scalar) != 0',
                                         'decoded->scalar, 0.0f) != 0'),
            'phase kept': ('session_bindings_a95.c', 'out->phase = 0u;', 'out->phase = before->phase;'),
            'host failure ignored': ('session_bindings_a95.c', 'if (status != ACTION_FAMILY_95_OK) {\n        b->failure = "volume provider failed";',
                                     'if (0) {\n        b->failure = "volume provider failed";'),
            'second attenuation from first scalar': ('sound_control.c', 'slot->second_attenuation = attenuation_unchecked(second_scalar, master);',
                                                     'slot->second_attenuation = attenuation_unchecked(first_scalar, master);'),
            'second scalar not stored': ('sound_control.c', 'slot->second_scalar = second_scalar;', 'slot->second_scalar = 0.0f;'),
            'scalar above 1 refused': ('sound_control.c', 'first_scalar > 100.0f', 'first_scalar > 1.0f'),
            'category not validated': ('sound_control.c', 'if (slot->volume_category >= SOUND_CONTROL_CATEGORY_COUNT)\n        return SOUND_CONTROL_ERR_ARGUMENT;\n    master',
                                       'master'),
            'volume called without buffer check': ('sound_control.c', 'state->device_ready != 0u && slot->buffer_available != 0u) {\n        ++result->volume_calls;',
                                                   'state->device_ready != 0u) {\n        ++result->volume_calls;'),
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
                self.assertNotEqual(code, 0, 'mutation survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_95.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a95_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 64 scenes, 123 rows, all subtype 1, channels 0/4/5/6/7/11/12, 14 distinct volumes, 3 rows carry dependency tails
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['error']), (64, 123, 123, 0))
        self.assertEqual((summary['equal'], summary['out_of_range'], summary['max_channel']), (123, 0, 12))
        self.assertEqual((summary['channels'], summary['volumes'], summary['subtype1'], summary['subtype2']), (7, 14, 123, 0))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_95_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)


class Registration(unittest.TestCase):
    def test_progress_map_sees_the_live_handler(self):
        import importlib.util
        spec = importlib.util.spec_from_file_location('playable', PROJECT / 'decomp-progress/playable.py')
        playable = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(playable)
        actions = playable.derive_actions(PROJECT)
        self.assertIn('0x95', actions['handled']['types'])
        self.assertEqual(actions['registrations']['external']['0x95'], 'native_a95_handler')


if __name__ == '__main__':
    unittest.main()
