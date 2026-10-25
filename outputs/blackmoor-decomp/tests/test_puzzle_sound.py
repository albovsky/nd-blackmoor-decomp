"""Bounded CSound descriptor adapter; backend calls are the observable boundary.

These synthetic records test native adapter policy, not decoder or hardware parity.
The optional local corpus test checks the 22 D1 descriptors without publishing them.
"""
from __future__ import annotations

import ctypes as C
import hashlib
import json
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
OK, NO_RESOURCE, ERR_ARGUMENT, ERR_DESCRIPTOR, ERR_UNSUPPORTED, ERR_BACKEND = range(6)
HOST_OK, HOST_NO_RESOURCE, HOST_UNSUPPORTED, HOST_ERROR = range(4)


class Command(C.Structure):
    _fields_ = [
        ('asset_stem', C.c_char * 34), ('channel', C.c_uint16),
        ('volume_category', C.c_uint8), ('control_word', C.c_uint32),
        ('first_percent', C.c_int16), ('second_percent', C.c_int16),
        ('first_gain', C.c_float), ('second_gain', C.c_float),
        ('mode', C.c_uint8), ('transition_scene', C.c_int16),
    ]


LOAD = C.CFUNCTYPE(C.c_int, C.c_void_p, C.POINTER(Command))
CHANNEL = C.CFUNCTYPE(C.c_int, C.c_void_p, C.c_uint16)
BUSY = C.CFUNCTYPE(C.c_int, C.c_void_p, C.c_uint16, C.POINTER(C.c_int))


class Backend(C.Structure):
    _fields_ = [('context', C.c_void_p), ('resolve_auto_text', C.c_void_p),
                ('present_caption', C.c_void_p), ('load_sound', LOAD),
                ('play_sound', CHANNEL), ('is_playing', BUSY), ('unload_sound', CHANNEL)]


class Sound(C.Structure):
    _fields_ = [('backend', Backend), ('prepared', C.c_uint8 * 32)]


def descriptor(name=b'Turn', channel=8, flags=2, mode=1, reserved=1,
               control=1, gains=(100, 100)):
    b = bytearray(0x31)
    b[:min(len(name), 33)] = name[:33]
    struct.pack_into('<HhhhIhh', b, 0x21, channel, flags, mode, reserved, control, *gains)
    return bytes(b)


class Recorder:
    def __init__(self):
        self.calls = []
        self.status = {name: HOST_OK for name in ('load', 'play', 'busy', 'unload')}
        self.playing = 0
        self.load = LOAD(self._load)
        self.play = CHANNEL(lambda _, ch: self._channel('play', ch))
        self.busy = BUSY(self._busy)
        self.unload = CHANNEL(lambda _, ch: self._channel('unload', ch))
        self.backend = Backend(None, None, None, self.load, self.play, self.busy, self.unload)

    def _load(self, _, p):
        cmd = p.contents
        self.calls.append(('load', bytes(cmd.asset_stem), cmd.channel, cmd.volume_category,
                           cmd.control_word, cmd.first_percent, cmd.second_percent,
                           cmd.first_gain, cmd.second_gain, cmd.mode, cmd.transition_scene))
        return self.status['load']

    def _channel(self, name, ch):
        self.calls.append((name, ch))
        return self.status[name]

    def _busy(self, _, ch, out):
        self.calls.append(('busy', ch))
        out[0] = self.playing
        return self.status['busy']


class PuzzleSoundTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory(prefix='puzzle-sound-')
        cls.addClassCleanup(cls.tmp.cleanup)
        lib = Path(cls.tmp.name) / 'libpuzzlesound.dylib'
        cc = shutil.which('clang') or shutil.which('cc')
        if cc is None:
            raise RuntimeError('C compiler required')
        subprocess.run([cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                        '-O2', '-fPIC', '-shared', str(PROJECT / 'src/puzzle_sound.c'),
                        '-o', str(lib)], check=True, capture_output=True, text=True)
        cls.lib = C.CDLL(str(lib))
        cls.lib.puzzle_sound_init.argtypes = [C.POINTER(Sound), C.POINTER(Backend)]
        for name in ('prepare', 'stop'):
            getattr(cls.lib, 'puzzle_sound_' + name).argtypes = [C.POINTER(Sound), C.c_void_p, C.c_size_t]
        cls.lib.puzzle_sound_play.argtypes = [C.POINTER(Sound), C.c_uint16]
        cls.lib.puzzle_sound_busy.argtypes = [C.POINTER(Sound), C.c_uint16, C.POINTER(C.c_int)]

    def setUp(self):
        self.rec = Recorder()
        self.sound = Sound()
        self.assertEqual(self.lib.puzzle_sound_init(C.byref(self.sound), C.byref(self.rec.backend)), OK)

    def record_call(self, operation, b=None, length=None):
        data = descriptor() if b is None else b
        buf = C.create_string_buffer(data)
        return getattr(self.lib, 'puzzle_sound_' + operation)(C.byref(self.sound), buf,
                                                           len(data) if length is None else length)

    def prepare(self, **kwargs):
        return self.record_call('prepare', descriptor(**kwargs))

    def play(self, channel=8):
        return self.lib.puzzle_sound_play(C.byref(self.sound), channel)

    def busy(self, channel=8, initial=99):
        out = C.c_int(initial)
        result = self.lib.puzzle_sound_busy(C.byref(self.sound), channel, C.byref(out))
        return result, out.value

    def test_prepare_converts_descriptor_without_playing(self):
        self.assertEqual(self.prepare(name=b'Independent', control=0xfedcba98, gains=(25, 70)), OK)
        self.assertEqual(self.rec.calls, [('load', b'Independent', 8, 2, 0xfedcba98,
                                          25, 70, C.c_float(.25).value, C.c_float(.70).value, 1, 9999)])

    def test_gains_are_independent_signed_and_clamped(self):
        for gains, want in [((-32768, 32767), (0., 1.)), ((100, 0), (1., 0.)),
                            ((-1, 99), (0., C.c_float(.99).value))]:
            with self.subTest(gains=gains):
                self.assertEqual(self.prepare(gains=gains), OK)
                self.assertEqual(self.rec.calls[-1][5:9], (*gains, *want))

    def test_every_channel_uses_original_volume_category(self):
        categories = [1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 3, 3,
                      3, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1, 1, 3, 1, 0, 2]
        for ch, category in enumerate(categories):
            self.assertEqual(self.prepare(channel=ch), OK)
            self.assertEqual(self.rec.calls[-1][2:4], (ch, category))

    def test_prepare_play_busy_stop_order_and_channel_isolation(self):
        self.assertEqual(self.prepare(), OK)
        self.assertEqual(self.play(), OK)
        self.rec.playing = 1
        self.assertEqual(self.busy(), (OK, 1))
        self.assertEqual(self.busy(9), (OK, 0))
        self.assertEqual(self.record_call('stop'), OK)
        self.assertEqual(self.play(), NO_RESOURCE)
        self.assertEqual(self.busy(), (OK, 0))
        self.assertEqual([x[:2] for x in self.rec.calls],
                         [('load', b'Turn'), ('play', 8), ('busy', 8), ('unload', 8)])

    def test_missing_reload_cannot_replay_previous_channel(self):
        self.assertEqual(self.prepare(), OK)
        self.rec.status['load'] = HOST_NO_RESOURCE
        self.assertEqual(self.prepare(name=b'Missing'), NO_RESOURCE)
        self.assertEqual(self.play(), NO_RESOURCE)
        self.assertEqual(self.busy(), (OK, 0))
        self.assertEqual([x[0] for x in self.rec.calls], ['load', 'load'])

    def test_unprepared_play_never_calls_backend_and_busy_is_idle(self):
        self.assertEqual(self.play(), NO_RESOURCE)
        self.assertEqual(self.busy(), (OK, 0))
        self.assertEqual(self.rec.calls, [])

    def test_backend_failures_propagate_and_failed_reload_invalidates(self):
        for failure, want in [(HOST_UNSUPPORTED, ERR_UNSUPPORTED), (HOST_ERROR, ERR_BACKEND),
                              (55, ERR_BACKEND)]:
            with self.subTest(failure=failure):
                self.rec.status['load'] = HOST_OK
                self.assertEqual(self.prepare(), OK)
                self.rec.status['load'] = failure
                self.assertEqual(self.prepare(), want)
                self.assertEqual(self.play(), NO_RESOURCE)

    def test_backend_play_busy_and_stop_failures_are_explicit(self):
        self.assertEqual(self.prepare(), OK)
        for operation in ('play', 'busy', 'unload'):
            for failure, want in [(HOST_UNSUPPORTED, ERR_UNSUPPORTED),
                                  (HOST_NO_RESOURCE, NO_RESOURCE), (HOST_ERROR, ERR_BACKEND)]:
                with self.subTest(operation=operation, failure=failure):
                    self.rec.status = {x: HOST_OK for x in self.rec.status}
                    self.assertEqual(self.prepare(), OK)
                    self.rec.status[operation] = failure
                    if operation == 'play':
                        self.assertEqual(self.play(), want)
                    elif operation == 'busy':
                        self.assertEqual(self.busy(), (want, 99))
                    else:
                        self.assertEqual(self.record_call('stop'), want)
                        self.assertEqual(self.play(), NO_RESOURCE)

    def test_invalid_busy_answer_is_error_and_does_not_mutate_output(self):
        self.assertEqual(self.prepare(), OK)
        for value in (-1, 2):
            self.rec.playing = value
            self.assertEqual(self.busy(), (ERR_BACKEND, 99))

    def test_malformed_descriptors_have_no_effect_on_prepared_channel(self):
        self.assertEqual(self.prepare(), OK)
        cases = [(descriptor(), n, ERR_DESCRIPTOR) for n in (0, 1, 0x30, 0x32)]
        cases += [(descriptor(name=b'x' * 33), 0x31, ERR_DESCRIPTOR),
                  (descriptor(name=b'a/b'), 0x31, ERR_DESCRIPTOR),
                  (descriptor(name=b'a\\b'), 0x31, ERR_DESCRIPTOR),
                  (descriptor(channel=32), 0x31, ERR_DESCRIPTOR),
                  (descriptor(channel=65535), 0x31, ERR_DESCRIPTOR)]
        for flags in (-32768, -1, 0, 1, 3, 32767):
            cases.append((descriptor(flags=flags), 0x31, ERR_UNSUPPORTED))
        for mode in (-1, 0, 2, 256, 32767):
            cases.append((descriptor(mode=mode), 0x31, ERR_UNSUPPORTED))
        for b, n, want in cases:
            for operation in ('prepare', 'stop'):
                with self.subTest(operation=operation, length=n, record=b.hex()):
                    self.rec.calls.clear()
                    self.assertEqual(self.record_call(operation, b, n), want)
                    self.assertEqual(self.rec.calls, [])
                    self.assertEqual(self.play(), OK)

    def test_maximum_and_empty_names_and_ignored_reserved_word(self):
        self.assertEqual(self.prepare(name=b'x' * 32, reserved=-32768), OK)
        self.assertEqual(self.rec.calls[-1][1], b'x' * 32)
        self.assertEqual(self.prepare(name=b'', reserved=32767), OK)
        self.assertEqual(self.rec.calls[-1][1], b'')

    def test_stop_uses_descriptor_channel_even_if_not_prepared(self):
        self.assertEqual(self.record_call('stop', descriptor(channel=31)), OK)
        self.assertEqual(self.rec.calls, [('unload', 31)])

    def test_invalid_arguments_and_missing_backend_preserve_state(self):
        self.assertEqual(self.prepare(), OK)
        before = bytes(self.sound)
        self.assertEqual(self.lib.puzzle_sound_init(C.byref(self.sound), None), ERR_ARGUMENT)
        self.assertEqual(bytes(self.sound), before)
        self.assertEqual(self.lib.puzzle_sound_init(None, C.byref(self.rec.backend)), ERR_ARGUMENT)
        self.assertEqual(self.lib.puzzle_sound_prepare(C.byref(self.sound), None, 0x31), ERR_ARGUMENT)
        self.assertEqual(self.lib.puzzle_sound_stop(None, None, 0), ERR_ARGUMENT)
        self.assertEqual(self.lib.puzzle_sound_play(None, 8), ERR_ARGUMENT)
        self.assertEqual(self.lib.puzzle_sound_busy(C.byref(self.sound), 8, None), ERR_ARGUMENT)
        for ch in (32, 65535):
            self.assertEqual(self.play(ch), ERR_DESCRIPTOR)
            self.assertEqual(self.busy(ch), (ERR_DESCRIPTOR, 99))
        for field in ('load_sound', 'play_sound', 'is_playing', 'unload_sound'):
            backend = Backend.from_buffer_copy(self.rec.backend)
            setattr(backend, field, dict(Backend._fields_)[field]())
            self.assertEqual(self.lib.puzzle_sound_init(C.byref(self.sound), C.byref(backend)), ERR_UNSUPPORTED)
            self.assertEqual(bytes(self.sound), before)
        self.assertEqual(bytes(self.sound), before)
        self.assertEqual(len(self.rec.calls), 1)

    def test_local_d1_corpus_uses_supported_profile(self):
        metadata = ROOT / 'work/analysis/slices/A-D1.1.corpus.json'
        resources = ROOT / 'work/analysis/hiff-resources'
        if not metadata.is_file():
            self.skipTest('private D1 corpus unavailable')
        rows = json.loads(metadata.read_text())['records']
        count = 0
        for row in rows:
            data = (resources / ('%04d.bin' % row['resource_index'])).read_bytes()
            p, n = row['act_payload_offset'], row['act_payload_length']
            body = data[p + 50:p + n]
            self.assertEqual(hashlib.sha256(body).hexdigest(), row['body_sha256'])
            for off in (0x2d9, 0x345):
                self.assertEqual(self.record_call('prepare', body[off:off + 0x31]), OK)
                self.assertEqual(self.rec.calls[-1][2:4], ((8 if off == 0x2d9 else 9), 2))
                count += 1
        self.assertEqual(count, 22)


if __name__ == '__main__':
    unittest.main()
