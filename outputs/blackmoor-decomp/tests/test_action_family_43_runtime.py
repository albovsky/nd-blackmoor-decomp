"""RT-32: raw 0x43 AUTOTEXT text overlay (src/session_bindings_a43.c over src/autotext_writer.c and the 0x36 overlay binding).

Facts under test (original GAME.EXE; dispatcher arm 0x428465 of 0x427a50 gates with mode 0 and calls the handler 0x411f24
with ECX = the text owner 0x619a41 and the row as its argument):
 * the row's object (the 301-byte prefix, then the resolved AUTOTEXT string) is rendered by the text writer 0x413187 into the
   AUTOTEXT surface slot of the word at +2;
 * the generic completion 0x42ba3a runs with the raw subtype (only its subtype-2 dependency reset survives, the completion
   byte is cleared right after);
 * a 0xABA overlay image is built (defaults 0x48945b over the rectangle at +0xe9, option words +0 and +0xe7, geometry +0xf9,
   name "USE_AUTOTEXT" + decimal(word +2 + 1)) and replaces the row object; the row becomes runtime type 0x36, subtype 1,
   completion 0, phase 0, and the overlay arm serves it from the next dispatcher pass on.
The comparison with the original is tests/action_family_43_runtime_original_oracle.py (needs the private work/ evidence and
Unicorn); the integration case with the production executor is tests/session_bindings_a43_test.c; the corpus driver runs the 13
rows of the decoded scenes. The text writer has its own oracle (tests/autotext_writer_original_oracle.py).
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
EXECUTOR_C = PROJECT / 'tests/session_bindings_a43_test.c'
CORPUS_C = PROJECT / 'tests/action_family_43_runtime_corpus.c'
KERNEL_SOURCES = ['session_bindings_a43.c', 'session_bindings_a36.c', 'action_family_43.c', 'action_family_37.c',
                  'action_family_36.c', 'action_family_38.c', 'action_family_36_runtime.c', 'autotext_writer.c',
                  'caption_layout.c', 'scene_resource.c', 'hiff.c', 'action_core.c']
EXECUTOR_SOURCES = KERNEL_SOURCES + ['scene_executor.c', 'scene_conditions.c', 'action_family_64.c']
CORPUS_SOURCES = KERNEL_SOURCES + ['autotext.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


def compile_c(output, main_c, sources, src_dir=SRC, cc=None, extra=()):
    cmd = [cc or compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', *extra,
           f'-I{src_dir}', str(main_c), *[str(Path(src_dir) / s) for s in sources], '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


def copy_sources(work):
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir()
    for item in SRC.iterdir():
        if item.suffix in ('.c', '.h'):
            shutil.copy(item, work / item.name)


class ExecutorTests(unittest.TestCase):
    """The production executor drives synthetic 0x43 rows through render, conversion, overlay visits and completion."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_case(self, src_dir=SRC, name='exec43'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-800:])
        return subprocess.run([str(binary)], capture_output=True, text=True)

    def test_render_convert_serve_and_complete(self):
        done = self.run_case()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_sanitizers_on_the_integration_case(self):
        for cc in (shutil.which('gcc'), compiler()):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'exec43_san'
            cmd = [cc, '-std=c11', '-g', '-O1', '-Wno-error=type-limits', '-fsanitize=address,undefined',
                   '-fno-sanitize-recover=undefined', f'-I{SRC}', str(EXECUTOR_C), *[str(SRC / s) for s in EXECUTOR_SOURCES],
                   '-lm', '-o', str(out)]
            if subprocess.run(cmd, capture_output=True, text=True).returncode != 0:
                continue
            done = subprocess.run([str(out)], capture_output=True, text=True, env=dict(os.environ, ASAN_OPTIONS='detect_leaks=0'))
            self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout[-400:] + done.stderr[-400:])
            return
        self.skipTest('no compiler with an ASan/UBSan runtime in this environment')

    def test_mutants_are_detected(self):
        mutations = {
            'completion uses the raw subtype': ('session_bindings_a43.c', 'action->subtype != 1u) {', '0) {'),
            'row never marked as an overlay': ('scene_executor.c', 'if (handler_result.become_overlay36) {', 'if (0) {'),
            'row type not adopted by the overlay binding': ('session_bindings_a36.c', 'b->raw_types[row] = SESSION_A43_ROW_TYPE;', 'b->raw_types[row] = 0;'),
            'failed writer still converts': ('session_bindings_a43.c', 'if (status != AUTOTEXT_WRITE_OK) {', 'if (0) {'),
            'later visits render again': ('session_bindings_a43.c', 'if (before->runtime_type_36) {', 'if (0) {'),
        }
        for name, (filename, old, new) in mutations.items():
            with self.subTest(name):
                original = (SRC / filename).read_text()
                self.assertEqual(original.count(old), 1, 'mutation anchor drifted')
                work = Path(self.tmp.name) / 'mut_exec'
                copy_sources(work)
                (work / filename).write_text(original.replace(old, new, 1))
                done = self.run_case(work, 'exec43_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_43_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not (RESOURCES / '0001.bin').exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a43_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), str(RESOURCES / '0001.bin'), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 13 rows in 13 scenes: all keyed, all subtype 1 (A-43.1 corpus census); every one renders and converts
        self.assertEqual((summary['rows'], summary['ok'], summary['bad']), (13, 13, 0))
        self.assertEqual((summary['keyed'], summary['inline'], summary['converted'], summary['resets']), (13, 0, 13, 0))
        self.assertEqual(done.stdout.count('ROW_FAIL'), 0)


class OriginalOracle(unittest.TestCase):
    def test_quick_scenarios_against_the_original_dispatcher(self):
        try:
            import unicorn  # noqa: F401
        except ImportError:
            self.skipTest('Unicorn is not installed')
        if not (ROOT / 'work/original/GAME.EXE').exists():
            self.skipTest('local original evidence (work/) is not present')
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_43_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
