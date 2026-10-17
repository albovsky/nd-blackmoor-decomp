"""RT-46: raw 0x33 secondary video with hotspots (src/session_bindings_a33.c over src/action_family_33_runtime.c).

Facts under test (original GAME.EXE; loader arm 0x40c186, dispatcher arm of 0x427a50 (gate mode 1), handler 0x42c221 and its pure
callees 0x42ca22, 0x42e72c, 0x42d215, 0x42caa8, 0x42cecd): the unit cases live in tests/action_family_33_runtime_test.c (kernel,
over a scripted host), the binding cases in tests/action_family_33_runtime_binding.c (scene parser, media gate, phase mapping,
the finish branch's scene-change request, pre-gate request clear, pointer row). The original-x86 oracle is
tests/action_family_33_runtime_original_oracle.py (needs the private work/ evidence and Unicorn).
"""
import os
from pathlib import Path
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/action_family_33_runtime_test.c'
BINDING_C = PROJECT / 'tests/action_family_33_runtime_binding.c'
KERNEL_SOURCES = ['action_family_33_runtime.c']
BINDING_SOURCES = ['session_bindings_a33.c', 'action_family_33_runtime.c', 'scene_resource.c', 'hiff.c']
KERNEL = 'action_family_33_runtime.c'
BINDING = 'session_bindings_a33.c'

sys.path.insert(0, str(PROJECT / 'tests'))
import test_scene_executor as base  # noqa: E402


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


def compile_c(output, main_c, sources, src_dir=SRC):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g',
           f'-I{src_dir}', str(main_c), *[str(Path(src_dir) / s) for s in sources], '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


def mutated_copy(tmp, filename, old, new):
    original = (SRC / filename).read_text()
    assert original.count(old) == 1, 'mutation anchor drifted: ' + old
    work = Path(tmp) / 'mut'
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir()
    for item in SRC.iterdir():
        if item.suffix in ('.c', '.h'):
            shutil.copy(item, work / item.name)
    (work / filename).write_text(original.replace(old, new, 1))
    return work


def row_body(kind=2):
    """113 fixed bytes plus one 66-byte hotspot (key 3), as tests/action_family_33_runtime_binding.c expects."""
    b = bytearray(0x71 + 66)
    b[0:6] = b'CLIP01'
    b[0x21:0x27] = b'OVER01'
    for offset, value in ((0x42, 7), (0x44, 2), (0x46, kind), (0x48, 1), (0x4A, 2 if kind == 2 else 1), (0x4C, 3), (0x4E, 5),
                          (0x50, 4), (0x52, 9), (0x54, 11), (0x56, 13), (0x58, 1234), (0x5A, 5), (0x5C, 6), (0x5E, 7),
                          (0x6D, 0), (0x6F, 1), (0x71, 3)):
        struct.pack_into('<h', b, offset, value)
    for offset, value in ((0x60, 70), (0x64, 80), (0x68, 90)):
        struct.pack_into('<i', b, offset, value)
    for i, value in enumerate([1, 2, 11, 12, 100, 120, 160, 150, 21, 22, 31, 32, 200, 220, 260, 250]):
        struct.pack_into('<i', b, 0x71 + 2 + 4 * i, value)
    return bytes(b)


def scene():
    return base.scene_bytes([base.action(0x33, 1, row_body() + bytes(16), (b'\0' * 16,))])


# each mutant must be caught by the unit or binding cases
KERNEL_MUTANTS = {
    'loop wraps at the end frame': ('if (st->frame_5b4e00 > set->w4e) {', 'if (st->frame_5b4e00 >= set->w4e) {'),
    'hold clamps to the wrong frame': ('        if (st->frame_5b4e00 > set->w52) {\n            st->frame_5b4e00 = set->w52;', '        if (st->frame_5b4e00 > set->w52) {\n            st->frame_5b4e00 = set->w50;'),
    'reverse snaps one late': ('if (st->frame_5b4e00 < set->w4c) {', 'if (st->frame_5b4e00 <= set->w4c) {'),
    'end clamps to the wrong frame': ('        if (st->frame_5b4e00 > set->w56) {\n            st->frame_5b4e00 = set->w56;', '        if (st->frame_5b4e00 > set->w56) {\n            st->frame_5b4e00 = set->w54;'),
    'hold never turns to reverse': ('st->anim_5b4e14 == 1 && st->latch_5c39e5 != (int32_t)st->row_5b4e89', 'st->anim_5b4e14 == 0 && st->latch_5c39e5 != (int32_t)st->row_5b4e89'),
    'page does not toggle': ('st->page_5b4dc8 = st->page_5b4dc8 != 0 ? 0 : 1;', 'st->page_5b4dc8 = 1;'),
    'page buffers swapped': ('(int32_t)(st->page_5b4dc8 != 0 ? st->buf_5b4dbc : st->buf_5b4db8)', '(int32_t)(st->page_5b4dc8 != 0 ? st->buf_5b4db8 : st->buf_5b4dbc)'),
    'deadline compared signed': ('if ((uint32_t)tick < st->deadline_5b4dfc) {', 'if (tick < (int32_t)st->deadline_5b4dfc) {'),
    'first deadline keeps the tick': ('OP(host, A33_OP_TICK, 0, 0, &tick);\n                st->deadline_5b4dfc = add32((uint32_t)tick, (uint32_t)st->delay_5b4c5a);\n                st->ready_5b4e0a = 0;',
                                      'OP(host, A33_OP_TICK, 0, 0, &tick);\n                st->deadline_5b4dfc = (uint32_t)tick;\n                st->ready_5b4e0a = 0;'),
    'free ignores the flag bit': ('if ((st->flags_5b4dc2 & 8u) == 0u) {', 'if (1) {'),
    'old thread not stopped': ('OP(host, A33_OP_THREAD_STOP, (int32_t)st->thread_5b4e0c, 0, NULL);', ''),
    'stream state not set': ('st->stream_5b4c3a = 2;', ''),
    'second video not fatal': ('if (st->active_5c39f1 != 0) {', 'if (0) {'),
    'push ignored': ('if (set->push_6c == 1u) {', 'if (0) {'),
    'engine mode 3': ('st->mode_583999 = 4;', 'st->mode_583999 = 3;'),
    'wrong scene cell': ('st->scene_5bb57b = (int32_t)set->scene_58;', 'st->scene_5bb57b = (int32_t)set->w5a;'),
    'row not cleared': ('st->row_5b4e89 = (int16_t)-1;', 'st->row_5b4e89 = 0;'),
    'event flag -1 not skipped': ('if (e->index != -1 && e->key == st->frame_5b4e00) {', 'if (e->key == st->frame_5b4e00) {'),
    'request not set': ('cells->request = 1;', 'cells->request = 0;'),
    'cut source top subtracted': ('out_src[1] = addi32(src[1], sub32(cut_top, top));', 'out_src[1] = sub32(src[1], sub32(cut_top, top));'),
    'cut source bottom added': ('out_src[3] = sub32(src[3], sub32(bottom, cut_bottom));', 'out_src[3] = addi32(src[3], sub32(bottom, cut_bottom));'),
    'second pair flag missing': ('        st->flag_5b4e8d = 1;\n', ''),
    'flags before flip in the first pass': ('status = event_flags(st, set, host);\n                if (status != A33_OK) {\n                    return status;\n                }\n                status = page_flip(st, host);',
                                            'status = page_flip(st, host);\n                if (status != A33_OK) {\n                    return status;\n                }\n                status = event_flags(st, set, host);'),
    'finish without a frame': ('    if (st->ready_5b4e0a == 0) {\n        return A33_OK;\n    }\n    st->row_5b4e89', '    st->row_5b4e89'),
    'init writes the wrong frame for hold': ('st->frame_5b4e00 = set->w54;', 'st->frame_5b4e00 = set->w4c;'),
    'thread failure not fatal': ('        if (st->thread_5b4e0c == 0u) {\n            OP(host, A33_OP_LOG, A33_LOG_THREAD_MEMORY, 0, NULL);\n            return A33_ERR_FATAL;\n        }', ''),
    'missing hotspots not fatal': ('if (set->hotspot_count < 1) {', 'if (set->hotspot_count < 0) {'),
}
BINDING_MUTANTS = {
    'media gate dropped': ('before->phase == 0u && (b->host.media_available == NULL', 'before->phase == 99u && (b->host.media_available == NULL'),
    'phase kept on completion': ('        out->disposition = SCENE_ACTION_HANDLER_COMPLETED; /* 0x42ba3a: completes, subtype 2 resets, phase := 0 */\n        out->phase = 0u;',
                                 '        out->disposition = SCENE_ACTION_HANDLER_COMPLETED;\n        out->phase = before->phase;'),
    'completion without a request': ('if (b->host.transition == NULL || b->host.transition(b->host.kernel.context, &request) != 0) {', 'if (b->host.transition == NULL || (b->host.transition(b->host.kernel.context, &request) != 0 && 0)) {'),
    'swapped request words': ('request.opaque_words[0] = b->state.w_5bb599;', 'request.opaque_words[0] = b->state.w_5bb595;'),
    'latch kept across scenes': ('    b->state.active_5c39f1 = 0; /* ClearSceneData 0x43e3f2 */\n', ''),
    'pre-gate keeps the request': ('        b->cells[index].request = 0;\n', ''),
    'idle row offered to the pointer': ('    if (cells->request == 0) {\n        return 0;\n    }\n', ''),
    'wrong type accepted': ('action->type != SESSION_A33_TYPE || index >= b->count', 'index >= b->count'),
}


def run_unit(binary):
    done = subprocess.run([str(binary)], capture_output=True, text=True)
    return done.returncode, done.stdout


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a33_test'
        built = compile_c(cls.binary, TEST_C, KERNEL_SOURCES)
        assert built.returncode == 0, built.stderr
        cls.scene = Path(cls.tmp.name) / 'scene33.bin'
        cls.scene.write_bytes(scene())

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_binding(self, src_dir=SRC, name='a33_binding'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, BINDING_C, BINDING_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), str(self.scene)], capture_output=True, text=True)

    def test_kernel_cases_pass(self):
        code, out = run_unit(self.binary)
        self.assertEqual((code, out.strip().splitlines()[-1]), (0, 'ALL PASS'), out)

    def test_binding_cases_pass(self):
        done = self.run_binding()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_sanitizers_on_the_kernel_cases(self):
        for cc in (compiler(), shutil.which('gcc')):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'a33_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined',
                   f'-I{SRC}', str(TEST_C), *[str(SRC / s) for s in KERNEL_SOURCES], '-o', str(out)]
            if subprocess.run(cmd, capture_output=True, text=True).returncode != 0:
                continue
            env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0')
            done = subprocess.run([str(out)], capture_output=True, text=True, env=env)
            self.assertEqual(done.returncode, 0, done.stdout[-400:] + done.stderr[-400:])
            return
        self.skipTest('no compiler with an ASan/UBSan runtime in this environment')

    def test_kernel_mutations_are_detected(self):
        """The cases must fail when a recovered rule is deliberately broken (the oracle has its own mutants against the original)."""
        for name, (old, new) in KERNEL_MUTANTS.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, KERNEL, old, new)
                binary = work / 'mut_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                if built.returncode != 0:
                    self.fail('mutant does not build: ' + name + built.stderr[-200:])
                code, _ = run_unit(binary)
                if code == 0:
                    # a kernel mutant may also be caught by the binding cases
                    done = self.run_binding(work, 'a33_binding_mut')
                    self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)

    def test_binding_mutations_are_detected(self):
        for name, (old, new) in BINDING_MUTANTS.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, BINDING, old, new)
                done = self.run_binding(work, 'a33_binding_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_33_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())


if __name__ == '__main__':
    unittest.main()
