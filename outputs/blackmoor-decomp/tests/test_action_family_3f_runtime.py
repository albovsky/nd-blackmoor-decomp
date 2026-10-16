"""RT-23: raw 0x3f conversation runtime (src/action_family_3f_runtime.c) and its session binding.

Facts under test (original GAME.EXE, read from the disassembly of 0x420c17):
 * phase 0 is refused with no effect when [0x5c39e9] or [0x5c39ed] is set, and does nothing but store the row
   when the engine mode [0x583999] is not 3; otherwise it runs the effect sequence of the packet in order and
   leaves phase 1 with sub-state 4 (running);
 * running polls channel 0xc every tick; with Fast Convo [0x58322a] the skip key is required EVEN after the
   sound ended (0x421b04..0x421b84); a response list waits for [0x5839b1 + i] == 1;
 * sub-state 5 stops the first sound, plays a named response sound from +0x747 on channel 0xd, "NO SOUND" and
   an empty name finish at once; the finish writes secondary flags, the chosen response's event word, then
   picks the transition (exit flag [0x58322b] pops; chosen scene; intermediate table; default; pop flag);
 * the response list build is 0x4205c1/0x420737 with add/replace/remove (0x41fa11/0x41fd08/0x42028e), at most
   30 entries and case-insensitive text identity.
The unit cases live in tests/action_family_3f_runtime_test.c (synthetic bodies through the A-3F.1 constructor);
the corpus driver runs the 493 rows of work/analysis/slices/A-3F.1.corpus.json through the binding.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/action_family_3f_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_3f_runtime_corpus.c'
KERNEL_SOURCES = ['action_family_3f.c', 'action_family_3f_runtime.c']
BINDING_SOURCES = KERNEL_SOURCES + ['session_bindings_a3f.c', 'scene_resource.c', 'hiff.c']
CORPUS_JSON = ROOT / 'work/analysis/slices/A-3F.1.corpus.json'
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 26


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


def compile_c(output, main_c, sources, src_dir=SRC, extra=()):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g',
           f'-I{src_dir}', *extra, str(main_c), *[str(Path(src_dir) / s) for s in sources],
           '-o', str(output)]
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
        cls.binary = Path(cls.tmp.name) / 'a3f_test'
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
        """ASan + UBSan over the same cases, which include the malformed-input rejections
        (unterminated names, bad handles, out-of-range indexes, oversize condition counts)."""
        for cc in (compiler(), shutil.which('gcc')):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'a3f_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', '-fsanitize=address,undefined',
                   '-fno-sanitize-recover=undefined', f'-I{SRC}', str(TEST_C),
                   *[str(SRC / s) for s in KERNEL_SOURCES], '-o', str(out)]
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
            'fast convo ignored': ('if (playing == 0 || w->fast_convo_58322a != 0) {', 'if (playing == 0) {'),
            'chain rule forward': ('f[i + 1] = 1u;\n                    changed = 1;', 'changed = 0;'),
            'overflow off by one': ('m->response_count + 1 >= 0x1f', 'm->response_count + 1 > 0x1f'),
            'no-sound name': ('memcmp(name, NO_SOUND, 9u) != 0 && name[0] != 0u', 'name[0] != 0u'),
            'exit flag precedence': ('if (w->exit_58322b != 0) {\n        next = NEXT_POP_EXIT;', 'if (0) {\n        next = NEXT_POP_EXIT;'),
            'case sensitive text': ('if (x > 0x40u && x < 0x5bu) {', 'if (0) {'),
            'second guard ignored': ('if (w->flag_5c39e9 != 0 || w->flag_5c39ed != 0) {', 'if (w->flag_5c39e9 != 0) {'),
            'default always': ('img[C3F_DEFAULT_ENABLE] == 1u', 'img[C3F_DEFAULT_ENABLE] != 7u'),
            'event write skipped': ('w->events[m->responses[sel].event_index] = (int32_t)m->responses[sel].event_value;', '(void)0;'),
        }
        original = (SRC / 'action_family_3f_runtime.c').read_text()
        for name, (old, new) in mutations.items():
            with self.subTest(name):
                self.assertIn(old, original, 'mutation anchor drifted')
                work = Path(self.tmp.name) / 'mut'
                shutil.rmtree(work, ignore_errors=True)
                work.mkdir()
                for item in SRC.iterdir():
                    if item.suffix in ('.c', '.h'):
                        shutil.copy(item, work / item.name)
                (work / 'action_family_3f_runtime.c').write_text(original.replace(old, new, 1))
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, results = run_unit(binary)
                self.assertNotEqual(code, 0, 'mutation survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_3f_runtime.sh')],
                              capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_tiers_run_through_the_binding(self):
        if not CORPUS_JSON.exists() or not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        records = json.loads(CORPUS_JSON.read_text())['records']
        files = sorted({RESOURCES / ('%04d.bin' % r['resource_index']) for r in records})
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a3f_corpus'
            built = compile_c(binary, CORPUS_C, BINDING_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0)
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                fields = dict(item.split('=') for item in line.split()[1:])
                summary[fields['tier']] = {k: int(v) for k, v in fields.items() if k != 'tier'}
        self.assertEqual(summary['A']['rows'], 277)
        self.assertEqual((summary['A']['ok'], summary['A']['error']), (277, 0))
        self.assertEqual(summary['B']['rows'], 66)
        self.assertEqual((summary['B']['ok'], summary['B']['error']), (66, 0))
        self.assertEqual(summary['C']['rows'], 150)
        self.assertEqual((summary['C']['unsupported'], summary['C']['ok']), (150, 0))
        self.assertEqual(done.stdout.count('SCENE_FAIL'), 0)


if __name__ == '__main__':
    unittest.main()
