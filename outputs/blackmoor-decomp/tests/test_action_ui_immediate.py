"""Original raw1d code1 permission/deferred-request component checks.

Literal cases follow 4e1305 and 4e1412..4e14b0. These synthetic native worlds
do not establish S3337 phone integration, original execution or GUI behavior.
"""
import ctypes as C
import hashlib
from pathlib import Path
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
OK, UNSUPPORTED = 0, 5


class World(C.Structure):
    _fields_ = [('screen', C.c_int32), ('request', C.c_uint8 * 3),
                ('phone_scene', C.c_int16), ('phone_mode', C.c_int32)]


CLOSE = C.CFUNCTYPE(C.c_int, C.c_void_p, C.c_int32)


class Host(C.Structure):
    _fields_ = [('context', C.c_void_p), ('close_screen', CLOSE)]


def state(world):
    return world.screen, tuple(world.request), world.phone_scene, world.phone_mode


class ActionUIImmediateTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        source = PROJECT / 'src/action_ui_immediate.c'
        compiler = shutil.which('clang') or shutil.which('cc')
        if compiler is None:
            raise RuntimeError('C compiler required for immediate UI tests')
        temporary = tempfile.TemporaryDirectory(prefix='blackmoor-ui-immediate-')
        cls.addClassCleanup(temporary.cleanup)
        library = Path(temporary.name) / ('immediate.dylib' if sys.platform == 'darwin' else 'immediate.so')
        command = [compiler, '-std=c11', '-O2', '-Wall', '-Wextra', '-Wpedantic', '-Werror']
        command += ['-dynamiclib'] if sys.platform == 'darwin' else ['-shared', '-fPIC']
        command += [str(source), '-o', str(library)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        if result.returncode:
            raise RuntimeError('Immediate UI compilation failed:\n' + result.stderr)
        cls.library = C.CDLL(str(library))
        cls.apply = cls.library.action_ui_apply_immediate
        cls.apply.argtypes = [C.POINTER(World), C.c_void_p, C.c_size_t, C.POINTER(Host)]
        cls.apply.restype = C.c_int
        print('UI_IMMEDIATE_BUILD source_sha256=' + hashlib.sha256(source.read_bytes()).hexdigest() +
              ' library_sha256=' + hashlib.sha256(library.read_bytes()).hexdigest())

    def invoke(self, world, group=3, mode=0, start=1600, end=1, host=None):
        body = C.create_string_buffer(struct.pack('<hBBhh', group, 1, mode, start, end))
        before_body = bytes(body)
        status = self.apply(C.byref(world), body, 8, C.byref(host) if host is not None else None)
        self.assertEqual(bytes(body), before_body, 'immediate code1 must not rewrite its original action body')
        return status

    def test_deferred_open_permission_and_teardown_matrix(self):
        # Regressions caught: opening phone inline, wrong switch permissions,
        # teardown after request publication, clearing sibling request flags,
        # interpreting ignored mode, unsigned phone words, or using full/low
        # screen comparisons at the wrong side of the original helper guard.
        world = World(0, (C.c_uint8 * 3)(0, 0, 0), 777, 31)
        self.assertEqual(self.invoke(world), OK)
        self.assertEqual(state(world), (1, (0, 0, 1), 1600, 1),
                         'S3337 group3/start1600/end1 requests the next-tick phone screen, not screen5 inline')

        # Columns are requested inventory1/journal2/phone3. None denies;
        # zero permits without teardown;3/4/5 requires that old popup close.
        permissions = [
            (0, (0, 0, 0)), (1, (None, None, None)), (2, (None, None, None)),
            (3, (None, 3, 3)), (4, (4, None, 4)), (5, (5, 5, None)),
            (65536, (0, 0, 0)), (-65536, (0, 0, 0)),
            (65539, (None, None, None)), (65540, (None, None, None)),
            (65541, (None, None, None)), (-1, (None, None, None)),
        ]
        for screen, groups in permissions:
            for group, closed in enumerate(groups, 1):
                with self.subTest(screen=screen, group=group):
                    world = World(screen, (C.c_uint8 * 3)(0, 0, 0), 777, 31)
                    before = state(world)
                    calls = []

                    def close(context, old_screen):
                        calls.append((context, old_screen, state(world)))
                        return 0

                    callback = CLOSE(close)
                    host = Host(0x1234, callback)
                    self.assertEqual(self.invoke(world, group=group, host=host), OK)
                    if closed is None:
                        expected = before
                    else:
                        flags = ((1, 0, 0), (0, 1, 0), (0, 0, 1))[group - 1]
                        expected = (1, flags, 1600, 1) if group == 3 else (1, flags, 777, 31)
                    self.assertEqual(state(world), expected)
                    expected_calls = [(0x1234, closed, before)] if closed else []
                    self.assertEqual(calls, expected_calls,
                                     'close the permitted old popup before publishing any deferred world changes')

        for screen in (0, 3, 4, 5):
            for group in (0, 4):
                with self.subTest(no_effect_group=group, screen=screen):
                    world = World(screen, (C.c_uint8 * 3)(1, 0, 1), 777, 31)
                    before = state(world)
                    self.assertEqual(self.invoke(world, group=group), OK)
                    self.assertEqual(state(world), before)

        for mode, start, end, expected_scene, expected_mode in (
            (0, 1600, 1, 1600, 1), (1, 1600, 1, 1600, 1), (255, 1600, 1, 1600, 1),
            (255, -32768, -32768, -32768, -32768), (1, -1, -2, -1, -2),
            (0, 9999, -32768, 777, 31),
        ):
            with self.subTest(mode=mode, start=start, end=end):
                world = World(0, (C.c_uint8 * 3)(1, 1, 0), 777, 31)
                self.assertEqual(self.invoke(world, mode=mode, start=start, end=end), OK)
                self.assertEqual(state(world), (1, (1, 1, 1), expected_scene, expected_mode))

        # An absent host/teardown is an ordinary unsupported boundary, not a
        # silent successful switch. A denied switch needs no teardown host.
        for host in (None, Host(None, CLOSE())):
            for screen, group in ((3, 2), (3, 3), (4, 1), (4, 3), (5, 1), (5, 2)):
                with self.subTest(missing_teardown=screen, group=group, missing_host=host is None):
                    world = World(screen, (C.c_uint8 * 3)(1, 0, 1), 777, 31)
                    before = state(world)
                    self.assertEqual(self.invoke(world, group=group, host=host), UNSUPPORTED)
                    self.assertEqual(state(world), before)


if __name__ == '__main__':
    unittest.main()
