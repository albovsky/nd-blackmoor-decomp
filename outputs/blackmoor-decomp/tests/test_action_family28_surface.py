import ctypes as c
import hashlib
import json
import os
from pathlib import Path
import subprocess
import unittest


PROJECT = Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]


class BinkPlayerInfo(c.Structure):
    _fields_ = [
        ("width", c.c_uint32),
        ("height", c.c_uint32),
        ("total_frames", c.c_uint32),
        ("frame_rate_num", c.c_int32),
        ("frame_rate_den", c.c_int32),
        ("time_base_num", c.c_int32),
        ("time_base_den", c.c_int32),
        ("decoded_frame_storage_bytes", c.c_uint64),
    ]


class BinkPlayerFrame(c.Structure):
    _fields_ = [
        ("rgba", c.POINTER(c.c_uint8)),
        ("rgba_bytes", c.c_size_t),
        ("width", c.c_uint32),
        ("height", c.c_uint32),
        ("stride", c.c_uint32),
        ("current_frame", c.c_int32),
        ("pts_ns", c.c_int64),
        ("duration_ns", c.c_int64),
        ("is_terminal", c.c_uint8),
    ]


class Rect(c.Structure):
    _fields_ = [
        ("left", c.c_int32),
        ("top", c.c_int32),
        ("right", c.c_int32),
        ("bottom", c.c_int32),
    ]


class PrimarySurface(c.Structure):
    _fields_ = [
        ("pixels", c.POINTER(c.c_uint8)),
        ("byte_length", c.c_size_t),
        ("width", c.c_size_t),
        ("height", c.c_size_t),
        ("pitch_bytes", c.c_size_t),
        ("origin_x", c.c_int32),
        ("origin_y", c.c_int32),
        ("channel_shifts", c.c_uint8 * 3),
        ("channel_masks", c.c_uint8 * 3),
        ("format", c.c_int),
        ("scope", c.c_int),
        ("primary_target", c.c_uint8),
        ("storage_lifetime", c.c_int),
    ]


class WordCapture(c.Structure):
    _fields_ = [
        ("bytes", c.POINTER(c.c_uint8)),
        ("byte_length", c.c_size_t),
        ("width", c.c_size_t),
        ("height", c.c_size_t),
        ("stride_pixels", c.c_size_t),
        ("offset_x", c.c_size_t),
        ("offset_y", c.c_size_t),
        ("storage_lifetime", c.c_int),
    ]


class ActionFamily28SurfaceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT / "scripts/build_action_family28_surface.sh")], check=True)
        bink_test_environment = os.environ.copy()
        # The later BinkPlayer suite needs its test-only accounting hook. The
        # test runner caches this dylib by path, so build that shared test
        # instance with the hook before either module loads it.
        bink_test_environment["BINK_PLAYER_TESTING"] = "1"
        subprocess.run([str(PROJECT / "scripts/build_bink_player.sh")],
                       check=True, env=bink_test_environment)
        cls.lib = c.CDLL(str(PROJECT / "build/libactionfamily28surface.dylib"))
        cls.lib.action_family28_surface_from_rgba.argtypes = [
            c.POINTER(BinkPlayerFrame), c.POINTER(c.c_uint8), c.c_size_t,
            c.c_int32, c.c_int32, c.POINTER(PrimarySurface),
        ]
        cls.lib.action_family28_surface_from_rgba.restype = c.c_int
        cls.lib.action_family28_surface_from_rgba_rect.argtypes = [
            c.POINTER(BinkPlayerFrame), c.c_size_t, c.c_size_t,
            c.c_size_t, c.c_size_t, c.POINTER(c.c_uint8), c.c_size_t,
            c.c_int32, c.c_int32, c.POINTER(PrimarySurface),
        ]
        cls.lib.action_family28_surface_from_rgba_rect.restype = c.c_int
        cls.lib.action_family28_capture_required_bytes.argtypes = [
            c.c_size_t, c.c_size_t, c.c_size_t, c.POINTER(c.c_size_t)
        ]
        cls.lib.action_family28_capture_required_bytes.restype = c.c_int
        cls.lib.action_family28_surface_capture_words.argtypes = [
            c.POINTER(PrimarySurface), c.POINTER(Rect), c.POINTER(WordCapture)
        ]
        cls.lib.action_family28_surface_capture_words.restype = c.c_int
        cls.lib.action_family28_surface_capture_words_at.argtypes = [
            c.POINTER(PrimarySurface), c.POINTER(Rect), c.c_size_t, c.c_size_t,
            c.POINTER(WordCapture),
        ]
        cls.lib.action_family28_surface_capture_words_at.restype = c.c_int
        cls.lib.action_family28_surface_blend_present_words.argtypes = [
            c.POINTER(PrimarySurface), c.POINTER(Rect), c.POINTER(WordCapture),
            c.POINTER(WordCapture), c.c_double, c.c_uint16, c.c_uint8,
        ]
        cls.lib.action_family28_surface_blend_present_words.restype = c.c_int
        cls.bink = c.CDLL(str(PROJECT / "build/libbink_player.dylib"))
        cls.bink.bink_player_open.argtypes = [
            c.c_char_p, c.POINTER(c.c_void_p), c.POINTER(BinkPlayerInfo),
            c.c_char_p, c.c_size_t,
        ]
        cls.bink.bink_player_open.restype = c.c_int
        cls.bink.bink_player_set_mode.argtypes = [
            c.c_void_p, c.c_int32, c.c_uint64, c.c_char_p, c.c_size_t,
        ]
        cls.bink.bink_player_set_mode.restype = c.c_int
        cls.bink.bink_player_advance.argtypes = [
            c.c_void_p, c.c_uint64, c.POINTER(BinkPlayerFrame),
            c.c_char_p, c.c_size_t,
        ]
        cls.bink.bink_player_advance.restype = c.c_int
        cls.bink.bink_player_close.argtypes = [c.c_void_p]

    @staticmethod
    def frame(colors, width=3, height=2, stride=16):
        storage = (c.c_uint8 * (stride * height))()
        for index, (red, green, blue, alpha) in enumerate(colors):
            row, column = divmod(index, width)
            at = row * stride + column * 4
            storage[at:at + 4] = (red, green, blue, alpha)
        frame = BinkPlayerFrame(c.cast(storage, c.POINTER(c.c_uint8)),
            len(storage), width, height, stride, 0, 0, 0, 1)
        return storage, frame

    def make_surface(self, rgba_storage, frame, origin=(0, 0)):
        output = (c.c_uint8 * (frame.width * frame.height * 2))()
        surface = PrimarySurface()
        status = self.lib.action_family28_surface_from_rgba(
            c.byref(frame), output, len(output), *origin, c.byref(surface)
        )
        self.assertEqual(status, 0)
        self.assertEqual(surface.format, 1)
        self.assertEqual(surface.scope, 1)
        self.assertEqual(surface.primary_target, 1)
        return output, surface

    def make_capture(self, surface, rect):
        size = c.c_size_t()
        self.assertEqual(self.lib.action_family28_capture_required_bytes(
            surface.width, surface.height, surface.width, c.byref(size)), 0)
        storage = (c.c_uint8 * size.value)()
        capture = WordCapture(c.cast(storage, c.POINTER(c.c_uint8)), size.value,
            surface.width, surface.height, surface.width,
            rect.left - surface.origin_x, rect.top - surface.origin_y, 1)
        self.assertEqual(self.lib.action_family28_surface_capture_words(
            c.byref(surface), c.byref(rect), c.byref(capture)), 0)
        return storage, capture

    @staticmethod
    def u16_rows(storage):
        return [int.from_bytes(bytes(storage[i:i + 2]), "little")
                for i in range(0, len(storage), 2)]

    def test_rgba_conversion_captures_original_word_layout_and_blends_only_rect(self):
        colors_source = [
            (255, 0, 0, 17), (0, 255, 0, 63), (0, 0, 255, 127),
            (255, 255, 255, 0), (0, 0, 0, 255), (248, 252, 248, 9),
        ]
        colors_target = [
            (0, 0, 0, 255), (0, 0, 255, 0), (255, 0, 0, 0),
            (0, 0, 0, 0), (255, 255, 255, 0), (0, 255, 0, 0),
        ]
        source_rgba, source_frame = self.frame(colors_source)
        target_rgba, target_frame = self.frame(colors_target)
        source_storage, source_surface = self.make_surface(source_rgba, source_frame)
        target_storage, target_surface = self.make_surface(target_rgba, target_frame)
        self.assertEqual(self.u16_rows(source_storage),
                         [0xF800, 0x07E0, 0x001F, 0xFFFF, 0x0000, 0xFFFF])

        rect = Rect(1, 0, 2, 1)  # Original right/bottom coordinates are inclusive.
        source_capture_storage, source_capture = self.make_capture(source_surface, rect)
        target_capture_storage, target_capture = self.make_capture(target_surface, rect)
        self.assertEqual(source_capture.byte_length, 72)
        self.assertEqual((source_capture.offset_x, source_capture.offset_y), (1, 0))
        source_red = int.from_bytes(bytes(source_capture_storage[12:16]), "little")
        source_green = int.from_bytes(bytes(source_capture_storage[16:20]), "little")
        source_blue = int.from_bytes(bytes(source_capture_storage[20:24]), "little")
        self.assertEqual((source_red, source_green, source_blue), (0, 63, 0))

        # The output surface is a copy of the source. The outside pixels must
        # remain untouched while the inclusive rectangle receives the blend.
        output_storage = (c.c_uint8 * len(source_storage)).from_buffer_copy(source_storage)
        output_surface = PrimarySurface.from_buffer_copy(source_surface)
        output_surface.pixels = c.cast(output_storage, c.POINTER(c.c_uint8))
        output_surface.byte_length = len(output_storage)
        before = self.u16_rows(output_storage)
        self.assertEqual(self.lib.action_family28_surface_blend_present_words(
            c.byref(output_surface), c.byref(rect), c.byref(source_capture),
            c.byref(target_capture), 1.0, 0x027F, 1), 0)
        after = self.u16_rows(output_storage)
        self.assertEqual(after[0], before[0])
        self.assertEqual(after[3], before[3])
        self.assertEqual(after[1:3], self.u16_rows(source_storage)[1:3])
        self.assertEqual(after[4:6], self.u16_rows(source_storage)[4:6])

        # Endpoint weight zero selects the target capture and supports the
        # other explicitly recovered x87 precision setting.
        output_storage[:] = source_storage[:]
        self.assertEqual(self.lib.action_family28_surface_blend_present_words(
            c.byref(output_surface), c.byref(rect), c.byref(source_capture),
            c.byref(target_capture), 0.0, 0x037F, 1), 0)
        after_target = self.u16_rows(output_storage)
        self.assertEqual(after_target[0], before[0])
        self.assertEqual(after_target[1:3], self.u16_rows(target_storage)[1:3])
        self.assertEqual(after_target[4:6], self.u16_rows(target_storage)[4:6])

    def test_rect_origin_and_capture_stride_are_explicit(self):
        rgba, frame = self.frame([(255, 0, 0, 0)] * 6)
        storage, surface = self.make_surface(rgba, frame, (10, 20))
        rect = Rect(11, 20, 12, 20)
        capture_size = c.c_size_t()
        self.assertEqual(self.lib.action_family28_capture_required_bytes(
            3, 2, 5, c.byref(capture_size)), 0)
        capture_storage = (c.c_uint8 * capture_size.value)()
        capture = WordCapture(c.cast(capture_storage, c.POINTER(c.c_uint8)),
            capture_size.value, 3, 2, 5, 1, 0, 1)
        self.assertEqual(self.lib.action_family28_surface_capture_words(
            c.byref(surface), c.byref(rect), c.byref(capture)), 0)
        self.assertEqual(capture_size.value, 120)
        # Padded words in each row remain untouched by the capture operation.
        self.assertEqual(bytes(capture_storage[36:60]), bytes(24))

    def test_source_crop_and_destination_rect_are_independent(self):
        # RGBA crop uses the BOOT VIEW source rectangle, while the adapter
        # surface keeps the original destination coordinates as its origin.
        colors = [
            (255, 0, 0, 255), (0, 255, 0, 255), (0, 0, 255, 255),
            (255, 255, 255, 255), (0, 0, 0, 255), (248, 252, 248, 255),
        ]
        rgba, frame = self.frame(colors)
        cropped = (c.c_uint8 * (2 * 2 * 2))()
        surface = PrimarySurface()
        self.assertEqual(self.lib.action_family28_surface_from_rgba_rect(
            c.byref(frame), 1, 0, 2, 2, cropped, len(cropped),
            10, 20, c.byref(surface)), 0)
        self.assertEqual((surface.width, surface.height, surface.origin_x,
                          surface.origin_y), (2, 2, 10, 20))
        self.assertEqual(self.u16_rows(cropped), [0x07E0, 0x001F, 0x0000, 0xFFFF])

        # The destination effect rect begins at x=11, but the original source
        # crop origin supplied through +0x4e/+0x52 is (0,0).
        rect = Rect(11, 20, 11, 21)
        size = c.c_size_t()
        self.assertEqual(self.lib.action_family28_capture_required_bytes(
            2, 2, 2, c.byref(size)), 0)
        source_bytes = (c.c_uint8 * size.value)()
        target_bytes = (c.c_uint8 * size.value)()
        source_capture = WordCapture(c.cast(source_bytes, c.POINTER(c.c_uint8)),
            size.value, 2, 2, 2, 99, 99, 1)
        target_capture = WordCapture(c.cast(target_bytes, c.POINTER(c.c_uint8)),
            size.value, 2, 2, 2, 99, 99, 1)
        self.assertEqual(self.lib.action_family28_surface_capture_words_at(
            c.byref(surface), c.byref(rect), 0, 0, c.byref(source_capture)), 0)
        self.assertEqual(self.lib.action_family28_surface_capture_words_at(
            c.byref(surface), c.byref(rect), 0, 0, c.byref(target_capture)), 0)
        self.assertEqual((source_capture.offset_x, source_capture.offset_y), (0, 0))

        output = (c.c_uint8 * len(cropped)).from_buffer_copy(cropped)
        output_surface = PrimarySurface.from_buffer_copy(surface)
        output_surface.pixels = c.cast(output, c.POINTER(c.c_uint8))
        self.assertEqual(self.lib.action_family28_surface_blend_present_words(
            c.byref(output_surface), c.byref(rect), c.byref(source_capture),
            c.byref(target_capture), 1.0, 0x027F, 1), 0)
        self.assertEqual(self.u16_rows(output), [0x07E0, 0x07E0, 0x0000, 0x0000])

        invalid = WordCapture(c.cast(source_bytes, c.POINTER(c.c_uint8)),
            size.value, 2, 2, 2, 1, 0, 1)
        before = bytes(source_bytes)
        self.assertEqual(self.lib.action_family28_surface_capture_words_at(
            c.byref(surface), c.byref(rect), 2, 0, c.byref(invalid)), 3)
        self.assertEqual(bytes(source_bytes), before)
        self.assertEqual((invalid.offset_x, invalid.offset_y), (1, 0))

    def test_different_capture_crop_origins_are_rejected_before_surface_mutation(self):
        # The recovered effect loop uses one source index for both captures.
        # Both origins below are independently in bounds, but they cannot be
        # represented by that shared-crop contract.
        colors = [
            (255, 0, 0, 255), (0, 255, 0, 255), (0, 0, 255, 255),
            (255, 255, 255, 255), (0, 0, 0, 255), (248, 252, 248, 255),
        ]
        rgba, frame = self.frame(colors)
        background, source_surface = self.make_surface(rgba, frame)
        rect = Rect(1, 0, 1, 0)

        capture_size = c.c_size_t()
        self.assertEqual(self.lib.action_family28_capture_required_bytes(
            3, 2, 3, c.byref(capture_size)), 0)
        source_bytes = (c.c_uint8 * capture_size.value)()
        target_bytes = (c.c_uint8 * capture_size.value)()
        source_capture = WordCapture(c.cast(source_bytes, c.POINTER(c.c_uint8)),
            capture_size.value, 3, 2, 3, 0, 0, 1)
        target_capture = WordCapture(c.cast(target_bytes, c.POINTER(c.c_uint8)),
            capture_size.value, 3, 2, 3, 1, 0, 1)
        self.assertEqual(self.lib.action_family28_surface_capture_words_at(
            c.byref(source_surface), c.byref(rect), 0, 0,
            c.byref(source_capture)), 0)
        self.assertEqual(self.lib.action_family28_surface_capture_words_at(
            c.byref(source_surface), c.byref(rect), 1, 0,
            c.byref(target_capture)), 0)
        self.assertEqual((source_capture.offset_x, source_capture.offset_y), (0, 0))
        self.assertEqual((target_capture.offset_x, target_capture.offset_y), (1, 0))

        output = (c.c_uint8 * len(background)).from_buffer_copy(background)
        output_surface = PrimarySurface.from_buffer_copy(source_surface)
        output_surface.pixels = c.cast(output, c.POINTER(c.c_uint8))
        output_surface.byte_length = len(output)
        before = bytes(output)
        self.assertEqual(self.lib.action_family28_surface_blend_present_words(
            c.byref(output_surface), c.byref(rect), c.byref(source_capture),
            c.byref(target_capture), 0.0, 0x027F, 1), 2)
        self.assertEqual(bytes(output), before)

    def test_failures_are_rejected_before_surface_or_output_mutation(self):
        rgba, frame = self.frame([(255, 0, 0, 255)] * 6)
        storage, surface = self.make_surface(rgba, frame)
        before = bytes(storage)

        truncated = BinkPlayerFrame(frame.rgba, 10, frame.width, frame.height,
                                    frame.stride, 0, 0, 0, 1)
        output = (c.c_uint8 * len(storage))(*([0xA5] * len(storage)))
        original_output = bytes(output)
        original_descriptor = PrimarySurface()
        c.memset(c.byref(original_descriptor), 0x5A, c.sizeof(original_descriptor))
        descriptor_before = bytes(original_descriptor)
        self.assertEqual(self.lib.action_family28_surface_from_rgba(
            c.byref(truncated), output, len(output), 0, 0,
            c.byref(original_descriptor)), 3)
        self.assertEqual(bytes(output), original_output)
        self.assertEqual(bytes(original_descriptor), descriptor_before)

        rect = Rect(0, 0, 2, 1)
        capture_size = c.c_size_t()
        self.assertEqual(self.lib.action_family28_capture_required_bytes(
            3, 2, 3, c.byref(capture_size)), 0)
        capture_storage = (c.c_uint8 * capture_size.value)(*([0xA5] * capture_size.value))
        short_capture = WordCapture(c.cast(capture_storage, c.POINTER(c.c_uint8)),
            capture_size.value - 1, 3, 2, 3, 0, 0, 1)
        capture_before = bytes(capture_storage)
        self.assertEqual(self.lib.action_family28_surface_capture_words(
            c.byref(surface), c.byref(rect), c.byref(short_capture)), 3)
        self.assertEqual(bytes(capture_storage), capture_before)

        source_storage, source_capture = self.make_capture(surface, rect)
        target_storage, target_capture = self.make_capture(surface, rect)
        corrupt = (c.c_uint8 * len(target_storage)).from_buffer_copy(target_storage)
        corrupt[12] = 0x40  # Red word exceeds the declared five-bit mask.
        corrupt_capture = WordCapture(c.cast(corrupt, c.POINTER(c.c_uint8)),
            len(corrupt), 3, 2, 3, 0, 0, 1)
        self.assertEqual(self.lib.action_family28_surface_blend_present_words(
            c.byref(surface), c.byref(rect), c.byref(source_capture),
            c.byref(corrupt_capture), 0.5, 0x037F, 1), 3)
        self.assertEqual(bytes(storage), before)
        self.assertEqual(self.lib.action_family28_surface_blend_present_words(
            c.byref(surface), c.byref(rect), c.byref(source_capture),
            c.byref(target_capture), 0.5, 0x027E, 1), 2)
        self.assertEqual(bytes(storage), before)

        unsupported_scope = PrimarySurface.from_buffer_copy(surface)
        unsupported_scope.scope = 99
        self.assertEqual(self.lib.action_family28_surface_capture_words(
            c.byref(unsupported_scope), c.byref(rect), c.byref(target_capture)), 2)
        unsupported_primary = PrimarySurface.from_buffer_copy(surface)
        unsupported_primary.primary_target = 0
        self.assertEqual(self.lib.action_family28_surface_blend_present_words(
            c.byref(unsupported_primary), c.byref(rect), c.byref(source_capture),
            c.byref(target_capture), 0.5, 0x037F, 1), 2)
        self.assertEqual(bytes(storage), before)

        out_size = c.c_size_t(987)
        self.assertEqual(self.lib.action_family28_capture_required_bytes(
            c.c_size_t(-1).value, 2, c.c_size_t(-1).value, c.byref(out_size)), 3)
        self.assertEqual(out_size.value, 987)

        # A huge size_t dimension plus a positive signed origin could overflow
        # the adapter's signed coordinate arithmetic. Reject it before any
        # conversion or surface access, even when the declared byte span fits.
        huge_surface = PrimarySurface.from_buffer_copy(surface)
        huge_surface.width = (1 << 63) - 1
        huge_surface.pitch_bytes = (1 << 64) - 2
        huge_surface.byte_length = (1 << 64) - 2
        huge_surface.origin_x = (1 << 31) - 1
        edge_rect = Rect((1 << 31) - 1, 0, (1 << 31) - 1, 0)
        self.assertEqual(self.lib.action_family28_surface_capture_words(
            c.byref(huge_surface), c.byref(edge_rect), c.byref(target_capture)), 3)

    def test_real_open_a_frame_is_captured_into_owned_original_layout_spans(self):
        source = REPOSITORY / "work/analysis/game-source.json"
        if not source.is_file():
            self.skipTest("original game descriptor is unavailable")
        game_dir = Path(json.loads(source.read_text())["game_dir"])
        clip = game_dir / "CDVideo/OPEN_A.bik"
        if not clip.is_file():
            self.skipTest("installed OPEN_A Bink asset is unavailable")

        player = c.c_void_p()
        info = BinkPlayerInfo()
        error = c.create_string_buffer(512)
        self.assertEqual(self.bink.bink_player_open(
            str(clip).encode(), c.byref(player), c.byref(info), error, len(error)),
            0, error.value.decode(errors="replace"))
        try:
            self.assertEqual((info.width, info.height, info.total_frames), (620, 375, 1))
            self.assertEqual(self.bink.bink_player_set_mode(
                player, 0, 1_000_000_000, error, len(error)), 0)
            frame = BinkPlayerFrame()
            self.assertEqual(self.bink.bink_player_advance(
                player, 1_000_000_000, c.byref(frame), error, len(error)),
                0, error.value.decode(errors="replace"))
            self.assertEqual((frame.width, frame.height, frame.current_frame), (620, 375, 0))

            rgb565 = (c.c_uint8 * (frame.width * frame.height * 2))()
            surface = PrimarySurface()
            self.assertEqual(self.lib.action_family28_surface_from_rgba(
                c.byref(frame), rgb565, len(rgb565), 0, 0, c.byref(surface)), 0)
            surface_hash = hashlib.sha256(bytes(rgb565)).digest()
            rect = Rect(0, 0, frame.width - 1, frame.height - 1)
            capture_size = c.c_size_t()
            self.assertEqual(self.lib.action_family28_capture_required_bytes(
                frame.width, frame.height, frame.width, c.byref(capture_size)), 0)
            captured_words = (c.c_uint8 * capture_size.value)()
            capture = WordCapture(c.cast(captured_words, c.POINTER(c.c_uint8)),
                capture_size.value, frame.width, frame.height, frame.width, 0, 0, 1)
            self.assertEqual(self.lib.action_family28_surface_capture_words(
                c.byref(surface), c.byref(rect), c.byref(capture)), 0)
            self.assertEqual(capture_size.value, 620 * 375 * 12)
            capture_hash = hashlib.sha256(bytes(captured_words)).digest()
            self.assertNotEqual(surface_hash, bytes(len(surface_hash)))
            self.assertNotEqual(capture_hash, bytes(len(capture_hash)))

            # BinkPlayerFrame.rgba is borrowed until the next advance. Both
            # adapter results own independent spans and remain stable after
            # that invalidation boundary.
            status = self.bink.bink_player_advance(
                player, 1_000_000_001, c.byref(frame), error, len(error))
            self.assertEqual(status, 2, error.value.decode(errors="replace"))
            self.assertEqual(hashlib.sha256(bytes(rgb565)).digest(), surface_hash)
            self.assertEqual(hashlib.sha256(bytes(captured_words)).digest(), capture_hash)
        finally:
            self.bink.bink_player_close(player)


if __name__ == "__main__":
    unittest.main()
