"""Tests for the isolated 0x9f sound-action state machine."""

from __future__ import annotations

import ctypes as c
import struct
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libactionsound.dylib"

OK = 0
ERR_ARGUMENT = 1
ERR_BODY = 2
ERR_UNSUPPORTED = 3
ERR_BACKEND = 4
BACKEND_OK = 0
BACKEND_NO_RESOURCE = 1
BACKEND_UNSUPPORTED = 2
BACKEND_ERROR = 3
CAPTION_LITERAL = 0
CAPTION_RESOLVED_AUTO_TEXT = 1
NO_TRANSITION = 9999


class CaptionRequest(c.Structure):
    _fields_ = [
        ("kind", c.c_int),
        ("bytes", c.POINTER(c.c_uint8)),
        ("length", c.c_size_t),
        ("terminator", c.c_char_p),
        ("terminator_length", c.c_size_t),
    ]


class AudioCommand(c.Structure):
    _fields_ = [
        ("asset_stem", c.c_char * 34),
        ("channel", c.c_uint16),
        ("volume_category", c.c_uint8),
        ("control_word", c.c_uint32),
        ("first_percent", c.c_int16),
        ("second_percent", c.c_int16),
        ("first_gain", c.c_float),
        ("second_gain", c.c_float),
        ("mode", c.c_uint8),
        ("transition_scene", c.c_int16),
    ]


class Action(c.Structure):
    _fields_ = [
        ("type", c.c_uint8),
        ("subtype", c.c_uint8),
        ("eligible", c.c_uint8),
        ("completed_before", c.c_uint8),
        ("phase_before", c.c_uint32),
        ("scene_dispatch_argument", c.c_uint8),
        ("captions_enabled", c.c_uint8),
        ("body", c.POINTER(c.c_uint8)),
        ("body_length", c.c_size_t),
    ]


class Transition(c.Structure):
    _fields_ = [
        ("target_scene", c.c_int16),
        ("opaque_words", c.c_int16 * 3),
        ("opaque_dwords", c.c_int32 * 3),
        ("scene_flag_value", c.c_uint8),
        ("engine_state_value", c.c_uint8),
    ]


class Result(c.Structure):
    _fields_ = [
        ("recognized", c.c_uint8),
        ("applied", c.c_uint8),
        ("completion_valid", c.c_uint8),
        ("completed", c.c_uint8),
        ("reset_dependencies", c.c_uint8),
        ("stop_later_actions", c.c_uint8),
        ("has_transition", c.c_uint8),
        ("reserved", c.c_uint8),
        ("phase", c.c_uint32),
        ("transition", Transition),
    ]


ResolveFn = c.CFUNCTYPE(
    c.c_int, c.c_void_p, c.POINTER(c.c_uint8), c.c_size_t,
    c.POINTER(c.POINTER(c.c_uint8)), c.POINTER(c.c_size_t)
)
PresentFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(CaptionRequest))
LoadFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(AudioCommand))
ChannelFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_uint16)
QueryFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_uint16, c.POINTER(c.c_int))


class Backend(c.Structure):
    _fields_ = [
        ("context", c.c_void_p),
        ("resolve_auto_text", ResolveFn),
        ("present_caption", PresentFn),
        ("load_sound", LoadFn),
        ("play_sound", ChannelFn),
        ("is_playing", QueryFn),
        ("unload_sound", ChannelFn),
    ]


def sound_body(*, selector=0xFFFF, channel=13, control=1, left=75,
               right=75, mode=0, transition=NO_TRANSITION,
               caption=b"NSHT01\0") -> bytes:
    length = 81 if selector == 0xFFFF else 48 + selector
    body = bytearray(length)
    body[:7] = b"NSHT01\0"
    struct.pack_into("<H", body, 33, channel)
    struct.pack_into("<I", body, 35, control)
    struct.pack_into("<h", body, 39, left)
    struct.pack_into("<h", body, 41, right)
    body[43] = mode
    struct.pack_into("<h", body, 44, transition)
    struct.pack_into("<H", body, 46, selector)
    if selector == 0xFFFF:
        body[48:81] = caption[:33].ljust(33, b"\0")
    else:
        body[48:] = caption[:selector].ljust(selector, b"\0")
    return bytes(body)


class Recorder:
    def __init__(self):
        self.caption_config = False
        self.caption_result = BACKEND_OK
        self.resolver_result = BACKEND_OK
        self.resolved_text = b"resolved line"
        self.load_result = BACKEND_OK
        self.play_result = BACKEND_OK
        self.query_result = BACKEND_OK
        self.still_playing = 1
        self.unload_result = BACKEND_OK
        self.keys: list[bytes] = []
        self.captions: list[tuple[int, bytes, bytes]] = []
        self.commands: list[tuple] = []
        self.plays: list[int] = []
        self.queries: list[int] = []
        self.unloads: list[int] = []
        self.buffers = []

        @ResolveFn
        def resolve(_ctx, key, key_length, text_out, text_length_out):
            self.keys.append(c.string_at(key, key_length))
            if self.resolver_result != BACKEND_OK:
                return self.resolver_result
            buffer = (c.c_uint8 * len(self.resolved_text)).from_buffer_copy(
                self.resolved_text
            )
            self.buffers.append(buffer)
            text_out[0] = c.cast(buffer, c.POINTER(c.c_uint8))
            text_length_out[0] = len(self.resolved_text)
            return BACKEND_OK

        @PresentFn
        def present(_ctx, request):
            item = request.contents
            self.captions.append((
                item.kind,
                c.string_at(item.bytes, item.length),
                c.string_at(item.terminator, item.terminator_length),
            ))
            return self.caption_result

        @LoadFn
        def load(_ctx, command):
            item = command.contents
            self.commands.append((
                bytes(item.asset_stem).split(b"\0", 1)[0],
                item.channel,
                item.volume_category,
                item.control_word,
                item.first_percent,
                item.second_percent,
                item.first_gain,
                item.second_gain,
                item.mode,
                item.transition_scene,
            ))
            return self.load_result

        @ChannelFn
        def play(_ctx, channel):
            self.plays.append(channel)
            return self.play_result

        @QueryFn
        def query(_ctx, channel, playing_out):
            self.queries.append(channel)
            if self.query_result == BACKEND_OK:
                playing_out[0] = self.still_playing
            return self.query_result

        @ChannelFn
        def unload(_ctx, channel):
            self.unloads.append(channel)
            return self.unload_result

        self.callbacks = [resolve, present, load, play, query, unload]
        self.backend = Backend(
            None, resolve, present, load, play, query, unload
        )


class ActionSoundTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT / "scripts/build_action_sound.sh")], check=True)
        cls.lib = c.CDLL(str(LIBRARY))
        cls.lib.action_sound_step.argtypes = [
            c.POINTER(Action), c.POINTER(Backend), c.POINTER(Result)
        ]
        cls.lib.action_sound_step.restype = c.c_int

    def invoke(self, body, *, phase=0, subtype=1, eligible=True,
               completed=0, captions=False, dispatch_arg=1, recorder=None):
        body_storage = (c.c_uint8 * len(body)).from_buffer_copy(body)
        action = Action(
            0x9F, subtype, int(eligible), completed, phase,
            dispatch_arg, int(captions), body_storage, len(body)
        )
        output = Result()
        if recorder is None:
            backend_ptr = None
        else:
            backend_ptr = c.byref(recorder.backend)
        status = self.lib.action_sound_step(
            c.byref(action), backend_ptr, c.byref(output)
        )
        return status, output

    def test_s0_command_uses_independent_raw_and_clamped_gain_roles(self):
        recorder = Recorder()
        status, result = self.invoke(sound_body(), recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual((result.recognized, result.applied, result.phase), (1, 1, 1))
        self.assertEqual(recorder.commands, [(
            b"NSHT01", 13, 0, 1, 75, 75, 0.75, 0.75, 0, 9999
        )])
        self.assertEqual(recorder.plays, [13])
        self.assertEqual(recorder.queries, [])
        self.assertEqual(recorder.unloads, [])

    def test_channel_volume_categories_come_from_original_32_slot_initializer(self):
        for channel, category in ((13, 0), (0, 1), (17, 2), (14, 3), (31, 2)):
            with self.subTest(channel=channel):
                recorder = Recorder()
                status, _ = self.invoke(sound_body(channel=channel), recorder=recorder)
                self.assertEqual(status, OK)
                self.assertEqual(recorder.commands[0][2], category)

    def test_caption_literal_and_auto_text_have_typed_callbacks_and_terminator(self):
        recorder = Recorder()
        literal = b"Door opens"
        status, _ = self.invoke(
            sound_body(selector=len(literal), caption=literal),
            captions=True, recorder=recorder
        )
        self.assertEqual(status, OK)
        self.assertEqual(recorder.captions, [
            (CAPTION_LITERAL, literal, b"<e>")
        ])

        recorder = Recorder()
        key = b"NSHT01\0"
        status, _ = self.invoke(sound_body(caption=key), captions=True,
                                recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual(recorder.keys, [b"NSHT01"])
        self.assertEqual(recorder.captions, [
            (CAPTION_RESOLVED_AUTO_TEXT, b"resolved line", b"<e>")
        ])

    def test_missing_auto_text_uses_original_embedded_fallback(self):
        recorder = Recorder()
        recorder.resolver_result = BACKEND_NO_RESOURCE
        status, _ = self.invoke(
            sound_body(caption=b"missing-key\0"), captions=True,
            recorder=recorder
        )
        self.assertEqual(status, OK)
        self.assertEqual(recorder.keys, [b"missing-key"])
        self.assertEqual(recorder.captions, [(
            CAPTION_RESOLVED_AUTO_TEXT,
            b"Missing closed captioning text string<h><n><o>",
            b"<e>",
        )])

    def test_caption_disabled_or_dispatch_argument_zero_suppresses_callbacks(self):
        recorder = Recorder()
        status, _ = self.invoke(sound_body(), captions=False, recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual(recorder.keys, [])
        self.assertEqual(recorder.captions, [])
        status, _ = self.invoke(sound_body(), captions=True, dispatch_arg=0,
                                recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual(recorder.keys, [])
        self.assertEqual(recorder.captions, [])

    def test_auto_text_oversize_signed_length_is_not_presented(self):
        recorder = Recorder()
        recorder.resolved_text = b"x" * 32768
        status, result = self.invoke(sound_body(), captions=True,
                                     recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual(recorder.keys, [b"NSHT01"])
        self.assertEqual(recorder.captions, [])
        self.assertEqual(result.phase, 1)

    def test_phase_one_waits_for_authoritative_backend_query(self):
        recorder = Recorder()
        status, result = self.invoke(sound_body(), phase=1, recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual(result.phase, 1)
        self.assertEqual(recorder.queries, [13])
        recorder.still_playing = 0
        status, result = self.invoke(sound_body(), phase=1, recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual(result.phase, 2)

    def test_mode_one_skips_query_then_phase_two_does_not_unload(self):
        recorder = Recorder()
        body = sound_body(mode=1)
        status, result = self.invoke(body, phase=1, recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual(result.phase, 2)
        self.assertEqual(recorder.queries, [])
        status, result = self.invoke(body, phase=2, subtype=1, recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual((result.phase, result.completion_valid, result.completed),
                         (0, 1, 1))
        self.assertEqual(recorder.unloads, [])

    def test_phase_two_unloads_and_subtype_two_resets_completion(self):
        recorder = Recorder()
        status, result = self.invoke(sound_body(), phase=2, subtype=2,
                                     completed=1, recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual((result.phase, result.completion_valid, result.completed,
                          result.reset_dependencies), (0, 1, 0, 1))
        self.assertEqual(recorder.unloads, [13])

    def test_transition_returns_explicit_effect_and_stops_later_actions(self):
        recorder = Recorder()
        status, result = self.invoke(sound_body(transition=6400), phase=2,
                                     recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual((result.has_transition, result.stop_later_actions), (1, 1))
        transition = result.transition
        self.assertEqual(transition.target_scene, 6400)
        self.assertEqual(list(transition.opaque_words), [0, 0, 0])
        self.assertEqual(list(transition.opaque_dwords), [0, 0, 0])
        self.assertEqual((transition.scene_flag_value, transition.engine_state_value),
                         (1, 4))
        self.assertEqual(recorder.unloads, [13])

    def test_direct_completion_is_not_subtype_completion_or_transition(self):
        recorder = Recorder()
        status, result = self.invoke(sound_body(control=0), subtype=7,
                                     recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual((result.phase, result.completion_valid, result.completed,
                          result.reset_dependencies), (0, 1, 1, 0))
        self.assertEqual(recorder.plays, [13])

    def test_failed_original_load_advances_without_play_or_fake_completion(self):
        recorder = Recorder()
        recorder.load_result = BACKEND_NO_RESOURCE
        status, result = self.invoke(sound_body(), recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual(result.phase, 1)
        self.assertEqual(recorder.plays, [])

    def test_blocked_dependency_subtype_two_only_clears_phase_and_completion(self):
        recorder = Recorder()
        status, result = self.invoke(sound_body(), phase=1, subtype=2,
                                     completed=1, eligible=False,
                                     recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual((result.applied, result.phase, result.completion_valid,
                          result.completed, result.reset_dependencies), (1, 0, 1, 0, 0))
        self.assertEqual(recorder.commands, [])
        self.assertEqual(recorder.queries, [])
        self.assertEqual(recorder.unloads, [])

        status, result = self.invoke(sound_body(), phase=1, subtype=1,
                                     completed=0, eligible=False,
                                     recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual((result.applied, result.phase, result.completion_valid),
                         (0, 1, 0))

    def test_variable_numeric_body_requires_exact_selector_length(self):
        body = sound_body(selector=3, caption=b"abc")
        recorder = Recorder()
        status, result = self.invoke(body, recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual(result.phase, 1)
        self.assertEqual(recorder.commands[0][0], b"NSHT01")
        status, _ = self.invoke(body + b"x", recorder=recorder)
        self.assertEqual(status, ERR_BODY)

    def test_invalid_body_and_channel_are_rejected_without_callbacks(self):
        recorder = Recorder()
        status, _ = self.invoke(sound_body()[:-1], recorder=recorder)
        self.assertEqual(status, ERR_BODY)
        status, _ = self.invoke(sound_body(channel=32), recorder=recorder)
        self.assertEqual(status, ERR_UNSUPPORTED)
        unterminated = bytearray(sound_body())
        unterminated[:33] = b"A" * 33
        status, _ = self.invoke(bytes(unterminated), recorder=recorder)
        self.assertEqual(status, ERR_UNSUPPORTED)
        self.assertEqual(recorder.commands, [])

    def test_missing_or_unsupported_backend_is_explicit(self):
        status, _ = self.invoke(sound_body())
        self.assertEqual(status, ERR_UNSUPPORTED)
        recorder = Recorder()
        recorder.resolver_result = BACKEND_NO_RESOURCE
        status, _ = self.invoke(sound_body(), captions=True, recorder=recorder)
        self.assertEqual(status, OK)
        self.assertEqual(len(recorder.captions), 1)
        missing_presenter = Backend(None, recorder.callbacks[0], PresentFn(),
                                    recorder.callbacks[2], recorder.callbacks[3],
                                    recorder.callbacks[4], recorder.callbacks[5])
        body_storage = (c.c_uint8 * len(sound_body())).from_buffer_copy(sound_body())
        action = Action(0x9F, 1, 1, 0, 0, 1, 1,
                        body_storage, len(sound_body()))
        output = Result()
        status = self.lib.action_sound_step(c.byref(action),
                                            c.byref(missing_presenter),
                                            c.byref(output))
        self.assertEqual(status, ERR_UNSUPPORTED)


if __name__ == "__main__":
    unittest.main()
