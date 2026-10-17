"""RT-41: raw 0x7d "return from the examined item's scene" (src/action_family_7d_runtime.c, src/session_bindings_a7d.c).

Facts under test (original GAME.EXE; loader arm 0x40e61e copies one byte, dispatcher arm 0x42950b of 0x427a50):
 * after the dependency gate (mode 0) the arm calls the view method 0x4eb5f2 (no arguments), stores the word 0xffff into the
   selector 0x583f1d and stores 1 in the row's completion byte itself; neither the generic completion 0x42ba3a nor a dependency
   reset runs, and the phase word is untouched;
 * 0x4eb5f2 pops the second saved-scene record 0x5c3a1b..0x5c3a30: 0x5bb57b and 0x5bb57f both take the sign-extended word
   0x5c3a1d, 0x5bb599/0x5bb595 take words 0x5c3a1f/0x5c3a21, 0x5bb59b/0x5bb59f/0x5bb5a3 take dwords 0x5c3a25/0x5c3a29/0x5c3a2d,
   0x5c39ff := 1, 0x5bb1ca := (word 0x5c3a23 != 1), mode 0x583999 := 4, and both leading words of the record become 9999; an
   empty record (marker 9999) is not fatal in the original (it carries on), the native visit refuses it;
 * a selector other than -1 re-adds that item with the inventory add step 0x4e9e84(item, 0) and requests the UI animation
   0x4e0559(1, 0, 0) (also for a duplicate); a close byte 0 at view +0x7011 sets the inventory flag 0x583232.
The unit cases live in tests/action_family_7d_runtime_test.c (synthetic fixtures); the corpus driver runs the 4 rows of the decoded
scenes through the binding; the original-x86 oracle is tests/action_family_7d_runtime_original_oracle.py (needs the private work/
evidence and Unicorn).
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
TEST_C = PROJECT / 'tests/action_family_7d_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_7d_runtime_corpus.c'
KERNEL_SOURCES = ['scene_stack.c', 'action_family_7d_runtime.c', 'session_bindings_a7d.c', 'action_family_78_runtime.c',
                  'action_family_79_runtime.c']
CORPUS_SOURCES = KERNEL_SOURCES + ['action_core.c', 'scene_resource.c', 'hiff.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 11


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


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a7d_test'
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
            out = Path(self.tmp.name) / 'a7d_test_san'
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
        """The cases must fail when a recovered rule is deliberately broken (the oracle has its own mutants over the original)."""
        k, b = 'action_family_7d_runtime.c', 'session_bindings_a7d.c'
        mutations = {
            'scene taken from the marker word': (k, 'r.scene_5bb57b = slot->scene_5c3a1d;', 'r.scene_5bb57b = slot->marker_5c3a1b;'),
            'second scene global from the marker word': (k, 'r.scene_5bb57f = slot->scene_5c3a1d;', 'r.scene_5bb57f = slot->marker_5c3a1b;'),
            'scene word zero extended': (k, 'r.scene_5bb57b = slot->scene_5c3a1d;', 'r.scene_5bb57b = (uint16_t)slot->scene_5c3a1d;'),
            'dword 59f taken from 25': (k, 'r.dword_5bb59f = slot->dword_5c3a29;', 'r.dword_5bb59f = slot->dword_5c3a25;'),
            'dword 5a3 not read': (k, 'r.dword_5bb5a3 = slot->dword_5c3a2d;', 'r.dword_5bb5a3 = 0;'),
            'start flag inverted': (k, 'slot->word_5c3a23 == 1 ? 0 : 1', 'slot->word_5c3a23 == 1 ? 1 : 0'),
            'mode 3': (k, 'r.mode_583999 = 4;', 'r.mode_583999 = 3;'),
            'record marker kept': (k, '    slot->marker_5c3a1b = SCENE_RESTORE_EMPTY_MARKER;           /* 0x4eb6e3 */\n', ''),
            'empty test on the scene word': (k, 'if (slot->marker_5c3a1b == SCENE_RESTORE_EMPTY_MARKER) {   /* 0x4eb5f9',
                                             'if (slot->scene_5c3a1d == SCENE_RESTORE_EMPTY_MARKER) {   /* 0x4eb5f9'),
            'saver keeps the first dword store': (k, '    slot->dword_5c3a29 = current->dword_5bb5af;             /* 0x4eb76b..0x4eb771 overwrites the line above */\n', ''),
            'selector tested against zero': (k, 'taken = item != -1;', 'taken = item != 0;'),
            'item added with flag 1': (k, 'action78_add_item(item, 0, &model->inventory', 'action78_add_item(item, 1, &model->inventory'),
            'UI request enable 1': (k, 'request_ui_animation(host->inventory.context, 1, 0, 0)', 'request_ui_animation(host->inventory.context, 1, 1, 0)'),
            'UI request only for a new item': (k, 'if (host->inventory.request_ui_animation(host->inventory.context, 1, 0, 0) != 0) {',
                                               'if (result->readded && host->inventory.request_ui_animation(host->inventory.context, 1, 0, 0) != 0) {'),
            'inventory flag inverted': (k, 'open_inventory = *model->view_close_flag == 0u;', 'open_inventory = *model->view_close_flag != 0u;'),
            'selector kept': (k, '    *model->held_selector = -1;                          /* 0x429539 */\n', ''),
            'record cleared before the host answers': (k, '    popped = *model->slot;', '    popped = *model->slot; *model->slot = popped; (void)scene_restore_slot_pop(model->slot, &pop);'),
            'scene change before the add': (k, '    if (taken) {\n        int status = action78_add_item', '    if (host->scene_change(host->context, &pop) != 0) return ACTION7D_ERR_HOST;\n    if (taken) {\n        int status = action78_add_item'),
            'missing scene-change provider tolerated': (k, 'if (host->scene_change == NULL) {', 'if (0) {'),
            'missing UI provider tolerated': (k, 'if (taken && host->inventory.request_ui_animation == NULL) {', 'if (0) {'),
            'missing inventory provider tolerated': (k, 'if (open_inventory && host->open_inventory == NULL) {', 'if (0) {'),
            'host refusal ignored': (k, 'if (host->scene_change(host->context, &pop) != 0) {', 'if (host->scene_change(host->context, &pop) > 5) {'),
            'empty record accepted': (k, '        return ACTION7D_ERR_EMPTY;', '        (void)0;'),
            'phase cleared': (b, 'out->phase = before->phase;', 'out->phase = 0u;'),
            'generic completion': (b, 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
            'unsupported mapped to error': (b, 'return SCENE_ACTION_HANDLER_UNSUPPORTED;', 'return SCENE_ACTION_HANDLER_ERROR;'),
            'target scene from the second global': (b, 'request.target_scene = (int16_t)pop->scene_5bb57b;', 'request.target_scene = (int16_t)pop->scene_5bb57f + 1;'),
            'request words shifted': (b, 'request.opaque_words[2] = pop->word_5c39ff;', 'request.opaque_words[2] = 0;'),
            'body length unchecked': (b, 'if (action->typed_body_length != ACTION_FAMILY_7D_BODY_BYTES) {', 'if (0) {'),
            'view mode read once': (b, 'model.inventory = *b->inventory;', 'static Action78Model once; static int init; if (!init) { once = *b->inventory; init = 1; } model.inventory = once;'),
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
                self.assertNotEqual(code, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_7d_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_binding(self):
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a7d_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # 4 scenes, 4 rows, all subtype 1, three with a dependency record behind the one body byte (always 0)
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['error']), (4, 4, 4, 0))
        self.assertEqual((summary['sub1'], summary['sub_other'], summary['tail_rows']), (4, 0, 3))
        self.assertEqual((summary['body_zero'], summary['body_other'], summary['visits']), (4, 0, 4))
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
        done = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_7d_runtime_original_oracle.py'), '--quick-only',
                               '--fail-fast'], capture_output=True, text=True, cwd=str(PROJECT / 'tests'))
        self.assertEqual(done.returncode, 0, done.stdout[-600:] + done.stderr[-600:])
        self.assertIn('"mismatches": 0', done.stdout)


if __name__ == '__main__':
    unittest.main()
