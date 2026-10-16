"""RT-25: raw 0x3e cel-video arm of the conversation kernel (src/action_family_3f_runtime.c).

Facts under test (original GAME.EXE, handler 0x420c17 cel arms, reader thread 0x422e4a, render 0x422a0a):
 * the frame cache holds capacity = ftol((float)(last-first+1) * ((float)pct/100.0)) slots, clamped 4..0x4b;
 * the reader evicts frames below the shown one, loads the next frame (all layers), advances by step byte + boost
   or jumps to a forced frame, and clamps to the last frame; it does nothing while the lock is 2 or no thread runs;
 * the sound position only grows (monotonic clamp); a cache miss raises the stall counter, the boost (cap 5) and
   forces a jump; a hit decays the boost after `stall limit` hits; the row ends when the last frame was shown;
 * the render callback orders layers by priority, restores the old rectangle before a keyed blit, and updates the
   saved rectangles of independent (kind 2) layers.
The cases live in tests/action_family_3e_runtime_test.c (synthetic bodies through the A-3E.1 constructor and a
fake CIFTREE host); the original-x86 oracle for the same arm is tests/action_family_3e_runtime_original_oracle.py.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/action_family_3e_runtime_test.c'
KERNEL_SOURCES = ['action_family_3f.c', 'action_family_3e.c', 'action_family_3f_runtime.c']
EXPECTED_UNIT_TESTS = 15
ROOT = PROJECT.parents[1]
CORPUS_C = PROJECT / 'tests/action_family_3e_runtime_corpus.c'
BINDING_SOURCES = KERNEL_SOURCES + ['session_bindings_a3f.c', 'scene_resource.c', 'hiff.c']
CORPUS_JSON = ROOT / 'work/analysis/slices/A-3E.1.corpus.json'
RESOURCES = ROOT / 'work/analysis/hiff-resources'


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


def compile_c(output, sources, src_dir=SRC):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g',
           f'-I{src_dir}', str(TEST_C), *[str(Path(src_dir) / s) for s in sources], '-o', str(output)]
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


class CelUnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a3e_test'
        built = compile_c(cls.binary, KERNEL_SOURCES)
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
            out = Path(self.tmp.name) / 'a3e_test_san'
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
        """The cases must fail when a recovered cel rule is deliberately broken."""
        mutations = {
            'capacity floor': ('if (c->capacity < CONVO3F_CEL_MIN_SLOTS) {', 'if (0) {'),
            'capacity ceiling': ('if (c->capacity > CONVO3F_CEL_SLOTS) {', 'if (0) {'),
            'evict keeps old frames': ('m->cel.slots[i].frame < m->cel.frame && i != m->cel.slot',
                                       'm->cel.slots[i].frame < 0 && i != m->cel.slot'),
            'evict shown slot': ('m->cel.slots[i].frame < m->cel.frame && i != m->cel.slot',
                                 'm->cel.slots[i].frame < m->cel.frame'),
            'boost ignored in advance': ('(uint16_t)c->boost));', '0u));'),
            'forced jump dropped': ('c->next = c->forced;\n                c->forced = -1;',
                                    'c->forced = -1;'),
            'next not clamped': ('if (c->next > c->last) {\n                c->next = c->last;\n            }\n            if (ran',
                                 'if (ran'),
            'sync not monotonic': ('v = raw > c->sync_last ? raw : c->sync_last;', 'v = raw;'),
            'sync not clamped to count': ('if (c->sync_count - 1 < v) {', 'if (0) {'),
            'boost cap': ('if (c->boost > 5) {', 'if (c->boost > 50) {'),
            'stall never boosts': ('if (w->stall_limit_5b028e <= c->stall) {', 'if (0) {'),
            'boost never decays': ('if (w->stall_limit_5b028e <= c->relax) {', 'if (0) {'),
            'forced not clamped': ('if (c->last < c->forced) {\n                c->forced = c->last;\n            }',
                                   ''),
            'lock 2 not honored': ('if (m->cel_thread == 0 || c->lock == 2) {', 'if (m->cel_thread == 0) {'),
            'entry flag not raised': ('c->drawn = c->target;\n        w->ui_5d191d = 1;', 'c->drawn = c->target;'),
            'restore before keyed blit dropped': (
                'blit_add(plan, CONVO3F_BLIT_RESTORE, 0u, 0, restore, dst);\n                    ', ''),
            'view origin ignored': ('dst[0] = (int32_t)((uint32_t)dst[0] + (uint32_t)w->view_x_583186);',
                                    ''),
            'priority order ignored': ('if (img[C3E_PRIORITY + layer] != (uint8_t)order) {', 'if (0) {'),
            'layer scan continues after a draw': ('break; /* 0x422e20', '(void)0; /* 0x422e20'),
            'layer count kept in phase 2': ('m->cel.layer_count = 0; /* +0xf9b', '(void)0; /* +0xf9b'),
            'sound offset stays after a cel row': ('m->cel.sound_offset = 0; /* 0x6aa', '(void)0; /* 0x6aa'),
            'half-loaded slot kept': ('(void)cel_free_slot_layers(m, h, slot, why); /* no half-loaded', '(void)0; /* no half-loaded'),
            'saved rects not updated': ('memcpy(c->saved_src[layer], hdr->dst, sizeof(hdr->dst));', ''),
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
                built = compile_c(binary, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr)
                code, _ = run_unit(binary)
                self.assertNotEqual(code, 0, 'mutation survived: ' + name)


class Corpus(unittest.TestCase):
    def test_corpus_tiers_run_through_the_binding(self):
        """All 202 raw 0x3e records: tier A (no response list) and B (player responses) complete through the
        executor binding with a scripted cel host; tier C (flag-dependent response builders) is refused."""
        if not CORPUS_JSON.exists() or not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        records = json.loads(CORPUS_JSON.read_text())['records']
        files = sorted({RESOURCES / ('%04d.bin' % r['resource_index']) for r in records})
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a3e_corpus'
            cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', f'-I{SRC}',
                   str(CORPUS_C), *[str(SRC / s) for s in BINDING_SOURCES], '-o', str(binary)]
            built = subprocess.run(cmd, capture_output=True, text=True)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0)
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                fields = dict(item.split('=') for item in line.split()[1:])
                summary[fields['tier']] = {k: int(v) for k, v in fields.items() if k != 'tier'}
        self.assertEqual((summary['A']['rows'], summary['A']['ok'], summary['A']['error']), (108, 108, 0))
        self.assertEqual((summary['B']['rows'], summary['B']['ok'], summary['B']['error']), (22, 22, 0))
        self.assertEqual((summary['C']['rows'], summary['C']['unsupported'], summary['C']['ok']), (72, 72, 0))
        self.assertEqual(done.stdout.count('SCENE_FAIL'), 0)


if __name__ == '__main__':
    unittest.main()
