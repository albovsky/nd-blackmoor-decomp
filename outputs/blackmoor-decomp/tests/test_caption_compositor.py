"""S05-3 native transfer tests and offscreen caption-layer composition."""

from __future__ import annotations

import ctypes as c
import os
import struct
import subprocess
import tempfile
import unittest
from pathlib import Path

import oracle_support
import test_caption_layout as layout
import test_caption_lifecycle as lifecycle

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libcaptioncompositor.dylib"
OK, ERR_ARGUMENT, ERR_FORMAT, ERR_BOUNDS, ERR_UNSUPPORTED = range(5)
OPAQUE, KEYED = 1, 2
RGB555, RGB565 = 1, 2


class Rect(c.Structure):
    _fields_ = [("left", c.c_int32), ("top", c.c_int32),
                ("right", c.c_int32), ("bottom", c.c_int32)]

    def tuple(self):
        return (self.left, self.top, self.right, self.bottom)


class View(c.Structure):
    _fields_ = [("pixels", c.POINTER(c.c_uint8)), ("byte_capacity", c.c_size_t),
                ("width", c.c_int32), ("height", c.c_int32),
                ("pitch_bytes", c.c_int32), ("format", c.c_int)]


def bind(path=LIBRARY):
    lib = c.CDLL(str(path))
    lib.caption_compositor_format_from_pixel_format.argtypes = [
        c.POINTER(layout.PixelFormat), c.POINTER(c.c_int)]
    lib.caption_compositor_blit.argtypes = [
        c.POINTER(View), c.POINTER(View), c.c_int, c.POINTER(Rect), c.POINTER(Rect), c.c_uint16]
    lib.caption_compositor_blit.restype = c.c_int
    lib.caption_compositor_status_string.argtypes = [c.c_int]
    lib.caption_compositor_status_string.restype = c.c_char_p
    return lib


def byte_array(data: bytes | bytearray):
    return (c.c_uint8 * max(1, len(data))).from_buffer_copy(bytes(data) or b"\0")


def view(buf, width, height, pitch, fmt=RGB555, capacity=None):
    return View(c.cast(buf, c.POINTER(c.c_uint8)),
                len(buf) if capacity is None else capacity, width, height, pitch, fmt)


def word_pixels(values):
    return b"".join(struct.pack("<H", v & 0xFFFF) for v in values)


class CaptionCompositorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not LIBRARY.exists():
            raise unittest.SkipTest("run build_caption_compositor.sh first")
        cls.lib = bind()

    def blit(self, src, dst, kind, sr, dr, key=0):
        return self.lib.caption_compositor_blit(c.byref(src), c.byref(dst), kind,
                                                c.byref(sr), c.byref(dr), key)

    def test_shipped_rgb555_and_rgb565_masks_resolve_exactly(self):
        for masks, expected, shifts, bits in (
            (layout.RGB555, RGB555, [0, 5, 10], [5, 5, 5]),
            (layout.RGB565, RGB565, [0, 5, 11], [5, 6, 5]),
        ):
            fmt = layout.PixelFormat()
            self.assertEqual(layout.bind().caption_pixel_format_from_masks(
                *masks, layout.buf(b"\0\x1f\0"), c.byref(fmt)), 0)
            resolved = c.c_int()
            self.assertEqual(self.lib.caption_compositor_format_from_pixel_format(
                c.byref(fmt), c.byref(resolved)), OK)
            self.assertEqual((resolved.value, list(fmt.shifts), list(fmt.channel_bits)),
                             (expected, shifts, bits))
        bad = layout.PixelFormat()
        bad.shifts[:] = (0, 5, 12)
        bad.masks[:] = (31, 31, 15)
        bad.channel_bits[:] = (5, 5, 4)
        out = c.c_int(99)
        self.assertEqual(self.lib.caption_compositor_format_from_pixel_format(
            c.byref(bad), c.byref(out)), ERR_UNSUPPORTED)
        self.assertEqual(out.value, 99)

    def test_pitched_opaque_and_keyed_transfers_use_inclusive_rectangles(self):
        source_bytes = bytearray(5 * 12)
        for y in range(5):
            source_bytes[y * 12:y * 12 + 10] = word_pixels(
                [0x8000 | (y << 8) | x for x in range(5)])
        target_bytes = bytearray(b"\xa5" * (7 * 18))
        src_buf, dst_buf = byte_array(source_bytes), byte_array(target_bytes)
        src = view(src_buf, 5, 5, 12, RGB565)
        dst = view(dst_buf, 7, 7, 18, RGB565)
        sr, dr = Rect(1, 1, 4, 3), Rect(2, 2, 5, 4)
        self.assertEqual(self.blit(src, dst, OPAQUE, sr, dr), OK)
        expected = bytearray(target_bytes)
        for row in range(3):
            for col in range(4):
                value = 0x8000 | ((row + 1) << 8) | (col + 1)
                off = (row + 2) * 18 + (col + 2) * 2
                expected[off:off + 2] = struct.pack("<H", value)
        self.assertEqual(bytes(dst_buf), bytes(expected))

        key = 0xF81F
        keyed_source = bytearray(word_pixels([0x8001, key, 0, 0xFFFF, key, 0x1234]))
        keyed_target = bytearray(word_pixels([0x0101] * 6))
        a, b = byte_array(keyed_source), byte_array(keyed_target)
        av, bv = view(a, 3, 2, 6, RGB565), view(b, 3, 2, 6, RGB565)
        rect = Rect(0, 0, 2, 1)
        self.assertEqual(self.blit(av, bv, KEYED, rect, rect, key), OK)
        self.assertEqual(bytes(b), word_pixels([0x8001, 0x0101, 0, 0xFFFF, 0x0101, 0x1234]))

    def test_release_path_uses_source_extents_from_destination_origin(self):
        source_bytes = word_pixels([0x1000 + i for i in range(12)])
        source_buf = byte_array(source_bytes)
        target_buf = byte_array(b"\xa5" * (8 * 4 * 2))
        src = view(source_buf, 4, 3, 8)
        dst = view(target_buf, 8, 4, 16)
        # Original release code derives transfer width/height from the source
        # rect. It uses only destination left/top to locate the first pixel;
        # the debug-only gate is what compares destination right/bottom.
        # Release code ignores destination right/bottom entirely. These
        # values are deliberately inconsistent and outside the destination;
        # source extents at the destination origin are still in bounds.
        sr, dr = Rect(0, 0, 3, 1), Rect(4, 2, 1000, -1000)
        self.assertEqual(self.blit(src, dst, OPAQUE, sr, dr), OK)
        expected = bytearray(b"\xa5" * (8 * 4 * 2))
        for y in range(2):
            for x in range(4):
                off = (y + 2) * 16 + (x + 4) * 2
                expected[off:off + 2] = source_bytes[y * 8 + x * 2:y * 8 + x * 2 + 2]
        self.assertEqual(bytes(target_buf), bytes(expected))
        # A large destination rect does not stretch the source transfer.
        target_buf = byte_array(b"\xa5" * (8 * 4 * 2))
        dst = view(target_buf, 8, 4, 16)
        self.assertEqual(self.blit(src, dst, OPAQUE, sr, Rect(1, 1, 7, 3)), OK)
        self.assertEqual(bytes(target_buf[1 * 16 + 1 * 2:1 * 16 + 5 * 2]),
                         source_bytes[:8])
        # The source-sized write itself must fit even when the supplied dest
        # rectangle is small; safety rejection occurs before any write.
        before = bytes(target_buf)
        self.assertEqual(self.blit(src, dst, OPAQUE, sr, Rect(6, 1, 6, 1)), ERR_BOUNDS)
        self.assertEqual(bytes(target_buf), before)

    def test_forward_alias_semantics_match_original_chunk_and_word_order(self):
        initial = word_pixels([0x8000 + i for i in range(16)])
        for kind in (OPAQUE, KEYED):
            raw = byte_array(initial)
            same = view(raw, 8, 1, 16)
            sr, dr = Rect(0, 0, 5, 0), Rect(1, 0, 6, 0)
            key = 0x8002
            status = self.blit(same, same, kind, sr, dr, key)
            self.assertEqual(status, OK)
            expected = bytearray(initial)
            if kind == OPAQUE:
                # The original transfers two dwords, then one 16-bit tail;
                # each chunk reads into a temporary before its write.
                for offset in range(0, 12, 4):
                    chunk = bytes(expected[offset:offset + 4])
                    expected[offset + 2:offset + 6] = chunk
                tail = expected[8:10]
                expected[10:12] = tail
            else:
                for i in range(6):
                    source = struct.unpack_from("<H", expected, i * 2)[0]
                    if source != key:
                        struct.pack_into("<H", expected, (i + 1) * 2, source)
            self.assertEqual(bytes(raw), bytes(expected))

    def test_two_byte_offset_and_cross_row_aliases_are_forward(self):
        initial = word_pixels([0xA000 + i for i in range(20)])
        # Both views begin two bytes into the same allocation. Source row 0
        # overlaps the later destination row, preserving the original row order.
        backing = byte_array(b"\x11\x22" + initial + b"\xee\xff")
        same = view(backing, 4, 4, 8, capacity=len(backing) - 2)
        same.pixels = c.cast(c.byref(backing, 2), c.POINTER(c.c_uint8))
        sr, dr = Rect(0, 0, 2, 1), Rect(1, 1, 3, 2)
        self.assertEqual(self.blit(same, same, OPAQUE, sr, dr), OK)
        # Independent expected model applies each source row after prior writes.
        expected = bytearray(b"\x11\x22" + initial + b"\xee\xff")
        for row in range(2):
            src = 2 + row * 8
            dst = 2 + (row + 1) * 8 + 2
            expected[dst:dst + 6] = bytes(expected[src:src + 6])
        self.assertEqual(bytes(backing), bytes(expected))

    def test_rejects_bad_spans_rectangles_formats_and_extents_before_write(self):
        srcbuf = byte_array(word_pixels(range(16)))
        dstbuf = byte_array(b"\xd3" * 32)
        src = view(srcbuf, 4, 4, 8)
        dst = view(dstbuf, 4, 4, 8)
        good = Rect(0, 0, 1, 1)
        before = bytes(dstbuf)
        self.assertEqual(self.blit(src, dst, OPAQUE, Rect(-1, 0, 0, 1), good), ERR_BOUNDS)
        self.assertEqual(self.blit(src, dst, OPAQUE, good, Rect(0, 3, 1, -1000)), ERR_BOUNDS)
        self.assertEqual(self.blit(src, dst, OPAQUE, good, Rect(3, 0, -1000, 1000)), ERR_BOUNDS)
        short = view(dstbuf, 4, 4, 8, capacity=31)
        self.assertEqual(self.blit(src, short, OPAQUE, good, good), ERR_BOUNDS)
        wrong = view(dstbuf, 4, 4, 8, RGB565)
        self.assertEqual(self.blit(src, wrong, OPAQUE, good, good), ERR_FORMAT)
        self.assertEqual(self.blit(src, dst, 3, good, good), ERR_UNSUPPORTED)
        self.assertEqual(bytes(dstbuf), before)
        narrow = view(dstbuf, 4, 4, 7)
        self.assertEqual(self.blit(src, narrow, OPAQUE, good, good), ERR_BOUNDS)
        negative_pitch = view(dstbuf, 4, 4, -8)
        self.assertEqual(self.blit(src, negative_pitch, OPAQUE, good, good), ERR_UNSUPPORTED)
        empty = Rect(2, 1, 1, 3)
        self.assertEqual(self.blit(src, dst, OPAQUE, empty, empty), ERR_BOUNDS)

    def test_actual_writer_lifecycle_and_frame_resource_compose_offscreen(self):
        """Use the shipped caption writer, lifecycle command order and Frame art."""
        oracle_support.require_unicorn()
        data = layout.ShippedData()
        laylib = layout.bind()
        fmt, fonts, geometry = layout.native_context(laylib, data)
        cap_surface, cap_pixels = layout.make_surface(
            geometry.caption_surface_width, geometry.caption_surface_height, 0x03E0)
        short_surface, short_pixels = layout.make_surface(
            geometry.caption_surface_width, geometry.caption_surface_height, 0x03E0)
        framed_surface, framed_pixels = layout.make_surface(
            geometry.framed_surface_width, geometry.framed_surface_height, 0x03E0)
        cap_backend = layout.SheetBackend(data, fmt)
        short_backend = layout.SheetBackend(data, fmt)
        framed_backend = layout.SheetBackend(data, fmt)
        cap_globals = layout.Globals()
        short_globals = layout.Globals()
        framed_globals = layout.Globals()
        for text, mode, surface, backend, globals_ in (
            (b"Caption layer<n>second line<e>", -1, cap_surface, cap_backend, cap_globals),
            (b"Hi<e>", -1, short_surface, short_backend, short_globals),
            (b"Framed layer<n>scrolling text<e>", -2, framed_surface,
             framed_backend, framed_globals),
        ):
            status, _result, _box, _globals, _stored = layout.native_write(
                laylib, fmt, fonts, geometry, backend, text + b"\0", mode, 0,
                surface=surface, globals_=globals_, capacity=len(text) + 5)
            self.assertEqual(status, layout.OK)
        self.assertNotEqual(bytes(cap_pixels), bytes([0xE0, 0x03]) * (len(cap_pixels) // 2))
        self.assertNotEqual(bytes(framed_pixels), bytes([0xE0, 0x03]) * (len(framed_pixels) // 2))

        # Independently source the writer surfaces from the original x86
        # writer, then require the reviewed native writer to produce the same
        # actual 16-bit backing bytes for these caption and framed fixtures.
        import caption_layout_original_oracle as writer_oracle
        original_writer = writer_oracle.Original(writer_oracle.DEFAULT_EXE, data, layout.RGB555)
        original_caption = original_writer.write(
            writer_oracle.Case("S05-3-caption", b"Caption layer<n>second line<e>",
                               -1, 0, "S05-3"), geometry.caption_surface_width,
            geometry.caption_surface_height)
        original_framed = original_writer.write(
            writer_oracle.Case("S05-3-framed", b"Framed layer<n>scrolling text<e>",
                               -2, 0, "S05-3"), geometry.framed_surface_width,
            geometry.framed_surface_height)
        original_short = original_writer.write(
            writer_oracle.Case("S05-3-short-caption", b"Hi<e>", -1, 0, "S05-3"),
            geometry.caption_surface_width, geometry.caption_surface_height)
        self.assertTrue(original_caption["terminated"] and original_framed["terminated"] and
                        original_short["terminated"])
        self.assertFalse(original_caption["outside_surface"] or original_framed["outside_surface"] or
                         original_short["outside_surface"])
        self.assertEqual(original_caption["pixels"], bytes(cap_pixels))
        self.assertEqual(original_framed["pixels"], bytes(framed_pixels))
        self.assertEqual(original_short["pixels"], bytes(short_pixels))

        # TASK +0x21/+0x31/+0x51 and BSUM +0x114 are the original sourced
        # restore rectangles / framed destination. Frame is the original
        # CIFTREE art loaded and converted through the existing pixel adapter.
        boot_chunks = layout.hiff_chunks(data.load_bytes(b"BOOT"))
        task = boot_chunks[b"TASK"]
        area_src = lifecycle.Rect(*struct.unpack_from("<4i", task, 0x21))
        area_dst = lifecycle.Rect(*struct.unpack_from("<4i", task, 0x31))
        cc_rect = lifecycle.Rect(*struct.unpack_from("<4i", task, 0x51))
        framed_dst = lifecycle.Rect(*struct.unpack_from(
            "<4i", data.bsum, 0x5B0227 - 0x5B0113))
        frame = data.sheet(b"Frame", fmt)
        self.assertIsNotNone(frame)
        frame_bytes, fw, fh, fpitch = frame
        self.assertEqual((fw, fh), (640, 480))
        frame_buf = byte_array(frame_bytes)

        # Initialize the actual shipped SCTB before applying the observed
        # render-list states. This ensures the fixture uses the same loaded
        # caption controls as the lifecycle oracle rather than a synthetic box.
        sctb = boot_chunks[b"SCTB"]
        self.assertEqual(len(sctb), 0x300)
        life = lifecycle.make_life(data, geometry)
        record = lifecycle.RecordingBackend(lifecycle.Script())
        clib = lifecycle.bind()
        sctb_buf = layout.buf(sctb)
        self.assertEqual(clib.caption_ctb_load_chunk(
            c.byref(life), c.byref(record.struct), sctb_buf, len(sctb)), lifecycle.OK)
        self.assertEqual(clib.caption_ctb_init(
            c.byref(life), c.byref(record.struct)), lifecycle.OK)
        life.g.scroll_src = lifecycle.Rect(
            0, 0, geometry.framed_surface_width - 1,
            min(geometry.framed_surface_height,
                framed_dst.bottom - framed_dst.top + 1) - 1)
        life.g.convo_restore_layer = 0
        life.g.caption_restore_layer = 1
        life.g.framed_layer_enabled = 1
        life.g.caption_layer_enabled = 1
        frame_handle, framed_handle, caption_handle, short_handle = \
            0xF001, 0xF002, 0xF003, 0xF004
        life.taskbar = lifecycle.Taskbar(frame_handle, area_src, area_dst, cc_rect)
        self.assertEqual(clib.caption_taskbar_restore_area(
            c.byref(life), c.byref(record.struct)), lifecycle.OK)
        area_command = next(event for event in record.events if event[0] == "blit")
        self.assertEqual(area_command[3:], (area_src.tuple(), area_dst.tuple()))
        record.events.clear()
        status = clib.caption_present_layers(c.byref(life), c.byref(record.struct),
                                             caption_handle, framed_handle,
                                             c.byref(framed_dst))
        self.assertEqual(status, lifecycle.OK)
        commands = [event for event in record.events if event[0] == "blit"]
        self.assertEqual([event[2] for event in commands],
                         [frame_handle, framed_handle, caption_handle])
        self.assertEqual([event[1] for event in commands], [OPAQUE, OPAQUE, KEYED])
        self.assertEqual(commands[0][3:], (cc_rect.tuple(), cc_rect.tuple()))

        # Execute the TASK area restore followed by the exact render-list
        # requests into a 640x480 target.
        fmt_enum = c.c_int()
        self.assertEqual(self.lib.caption_compositor_format_from_pixel_format(
            c.byref(fmt), c.byref(fmt_enum)), OK)
        target = byte_array(b"\x5a\xa5" * (640 * 480))
        dst_view = view(target, 640, 480, 1280, fmt_enum.value)
        source_views = {
            frame_handle: view(frame_buf, fw, fh, fpitch, fmt_enum.value),
            framed_handle: view(framed_pixels, geometry.framed_surface_width,
                               geometry.framed_surface_height,
                               geometry.framed_surface_width * 2, fmt_enum.value),
            caption_handle: view(cap_pixels, geometry.caption_surface_width,
                                geometry.caption_surface_height,
                                geometry.caption_surface_width * 2, fmt_enum.value),
            short_handle: view(short_pixels, geometry.caption_surface_width,
                               geometry.caption_surface_height,
                               geometry.caption_surface_width * 2, fmt_enum.value),
        }
        all_commands = [area_command] + commands

        def compose(target_bytes, requests, key_override=None):
            output = byte_array(target_bytes)
            output_view = view(output, 640, 480, 1280, fmt_enum.value)
            for event in requests:
                _, kind, handle, src_values, dst_values = event
                key = (key_override if key_override is not None else fmt.color_key) \
                    if kind == KEYED else 0
                self.assertEqual(self.blit(source_views[handle], output_view, kind,
                                           Rect(*src_values), Rect(*dst_values), key), OK)
            return bytes(output)

        composed = compose(bytes(target), all_commands)
        composed_hash = __import__("hashlib").sha256(composed).hexdigest()
        self.assertEqual(len(composed_hash), 64)
        self.assertEqual(len(composed), len(target))
        # Whole-sequence original x86 raster parity uses the actual Frame
        # resource and original writer bytes. Calls run unmodified with no
        # raster-helper hooks; each return buffer seeds the next request.
        import caption_compositor_original_oracle as transfer_oracle
        original_transfer = transfer_oracle.Original(transfer_oracle.DEFAULT_EXE)
        actual_sources = {
            frame_handle: (frame_bytes, fw, fh, fpitch),
            framed_handle: (original_framed["pixels"], geometry.framed_surface_width,
                            geometry.framed_surface_height,
                            geometry.framed_surface_width * 2),
            caption_handle: (original_caption["pixels"], geometry.caption_surface_width,
                             geometry.caption_surface_height,
                             geometry.caption_surface_width * 2),
            short_handle: (original_short["pixels"], geometry.caption_surface_width,
                           geometry.caption_surface_height,
                           geometry.caption_surface_width * 2),
        }
        original_canvas = bytes(target)
        for event in all_commands:
            _, kind, handle, src_values, dst_values = event
            source_bytes, sw, sh, spitch = actual_sources[handle]
            original_canvas = original_transfer.run(
                kind, source_bytes, sw, sh, spitch, src_values, original_canvas,
                dst_values, fmt_enum.value, fmt.color_key if kind == KEYED else 0)
        self.assertEqual(composed, original_canvas)

        # Caption over caption: draw the original-backed short caption without
        # a restore. New keyed pixels replace old text while key pixels leave
        # the previous caption composite visible.
        life.g.caption_restore_layer = 0
        life.g.framed_layer_enabled = 0
        life.g.caption_layer_enabled = 1
        record.events.clear()
        self.assertEqual(clib.caption_present_layers(c.byref(life), c.byref(record.struct),
                                                     short_handle, framed_handle,
                                                     c.byref(framed_dst)), lifecycle.OK)
        short_commands = [event for event in record.events if event[0] == "blit"]
        self.assertEqual(len(short_commands), 1)
        over_caption = compose(composed, short_commands)
        _, _, _, short_src, short_dst = short_commands[0]
        original_over_caption = original_transfer.run(
            KEYED, original_short["pixels"], geometry.caption_surface_width,
            geometry.caption_surface_height, geometry.caption_surface_width * 2,
            short_src, composed, short_dst, fmt_enum.value, fmt.color_key)
        self.assertEqual(over_caption, original_over_caption)
        without_old_caption = compose(bytes(target), all_commands[:-1])
        preserved_key_pixel = False
        cap_source = original_short["pixels"]
        for y in range(cc_rect.bottom - cc_rect.top + 1):
            for x in range(cc_rect.right - cc_rect.left + 1):
                src_offset = y * geometry.caption_surface_width * 2 + x * 2
                dst_offset = ((cc_rect.top + y) * 640 + cc_rect.left + x) * 2
                if struct.unpack_from("<H", cap_source, src_offset)[0] == fmt.color_key and \
                        composed[dst_offset:dst_offset + 2] != \
                        without_old_caption[dst_offset:dst_offset + 2]:
                    self.assertEqual(over_caption[dst_offset:dst_offset + 2],
                                     composed[dst_offset:dst_offset + 2])
                    preserved_key_pixel = True
                    break
            if preserved_key_pixel:
                break
        self.assertTrue(preserved_key_pixel)

        # Scroll by one source row through the same live layer consumer.
        life.g.caption_layer_enabled = 0
        life.g.framed_layer_enabled = 1
        life.g.scroll_src = lifecycle.Rect(0, 1, geometry.framed_surface_width - 1, 81)
        record.events.clear()
        self.assertEqual(clib.caption_present_layers(c.byref(life), c.byref(record.struct),
                                                     caption_handle, framed_handle,
                                                     c.byref(framed_dst)), lifecycle.OK)
        scroll_commands = [event for event in record.events if event[0] == "blit"]
        self.assertEqual(len(scroll_commands), 1)
        self.assertEqual(scroll_commands[0][3], (0, 1, 577, 81))
        scrolled = compose(bytes(target), scroll_commands)
        _, _, _, scroll_src, scroll_dst = scroll_commands[0]
        original_scrolled = original_transfer.run(
            OPAQUE, original_framed["pixels"], geometry.framed_surface_width,
            geometry.framed_surface_height, geometry.framed_surface_width * 2,
            scroll_src, bytes(target), scroll_dst, fmt_enum.value, 0)
        self.assertEqual(scrolled, original_scrolled)
        self.assertNotEqual(scrolled, bytes(target))

        # The original two-frame caption clear first restores the saved Frame
        # pixels, then drops the restore request on the next step.
        life.g.framed_layer_enabled = 0
        life.g.caption_layer_enabled = 1
        life.g.caption_restore_layer = 0
        life.g.caption_clear_counter = -1
        life.shared[0].caption_visible_flag = 1
        clib.caption_clear_step(c.byref(life))
        self.assertEqual((life.g.caption_layer_enabled, life.g.caption_restore_layer,
                          life.shared[0].caption_visible_flag), (0, 1, 0))
        record.events.clear()
        self.assertEqual(clib.caption_present_layers(c.byref(life), c.byref(record.struct),
                                                     caption_handle, framed_handle,
                                                     c.byref(framed_dst)), lifecycle.OK)
        clear_commands = [event for event in record.events if event[0] == "blit"]
        self.assertEqual(len(clear_commands), 1)
        self.assertEqual(clear_commands[0][2:],
                         (frame_handle, cc_rect.tuple(), cc_rect.tuple()))
        cleared = compose(over_caption, clear_commands)
        _, _, _, clear_src, clear_dst = clear_commands[0]
        original_cleared = original_transfer.run(
            OPAQUE, frame_bytes, fw, fh, fpitch, clear_src, over_caption,
            clear_dst, fmt_enum.value, 0)
        self.assertEqual(cleared, original_cleared)
        for y in range(cc_rect.top, cc_rect.bottom + 1):
            start = (y * 640 + cc_rect.left) * 2
            end = (y * 640 + cc_rect.right + 1) * 2
            self.assertEqual(cleared[start:end], frame_bytes[start:end])
        clib.caption_clear_step(c.byref(life))
        self.assertEqual((life.g.caption_restore_layer, life.g.caption_clear_counter), (0, -1))
        record.events.clear()
        self.assertEqual(clib.caption_present_layers(c.byref(life), c.byref(record.struct),
                                                     caption_handle, framed_handle,
                                                     c.byref(framed_dst)), lifecycle.OK)
        self.assertEqual([event for event in record.events if event[0] == "blit"], [])

        # Scene reset drops prior caption/frame state before a replacement
        # caption is presented from the same source-ordered saved surface.
        self.assertEqual(clib.caption_scene_reset(c.byref(life), c.byref(record.struct)),
                         lifecycle.OK)
        self.assertEqual((life.g.scroll_src.top, life.shared[0].caption_visible_flag,
                          life.shared[0].caption_finish_flag), (0, 0, 0))
        life.g.caption_layer_enabled = 1
        life.g.caption_restore_layer = 1
        record.events.clear()
        self.assertEqual(clib.caption_present_layers(c.byref(life), c.byref(record.struct),
                                                     short_handle, framed_handle,
                                                     c.byref(framed_dst)), lifecycle.OK)
        replacement_commands = [event for event in record.events if event[0] == "blit"]
        self.assertEqual([event[2] for event in replacement_commands],
                         [frame_handle, short_handle])
        replacement = compose(bytes(target), replacement_commands)
        original_replacement = bytes(target)
        for event in replacement_commands:
            _, kind, handle, rect_src, rect_dst = event
            source_bytes, sw, sh, spitch = actual_sources[handle]
            original_replacement = original_transfer.run(
                kind, source_bytes, sw, sh, spitch, rect_src, original_replacement,
                rect_dst, fmt_enum.value, fmt.color_key if kind == KEYED else 0)
        self.assertEqual(replacement, original_replacement)
        self.assertNotEqual(replacement, composed)

        wrong_key = compose(bytes(target), all_commands, fmt.color_key ^ 1)
        self.assertNotEqual(wrong_key, composed)
        wrong_order = [area_command, commands[0], commands[2], commands[1]]
        self.assertNotEqual(compose(bytes(target), wrong_order), composed)


SANITIZER_DRIVER = r"""
#include <stdint.h>
#include <stdio.h>
#include "caption_compositor.h"
int main(void) {
    uint8_t a[32] = {0}, b[32];
    for (unsigned i = 0; i < sizeof b; ++i) b[i] = 0xa5;
    CaptionCompositorView src = {a, sizeof a, 4, 4, 8, CAPTION_COMPOSITOR_RGB555_LE};
    CaptionCompositorView dst = {b, sizeof b, 4, 4, 8, CAPTION_COMPOSITOR_RGB555_LE};
    CaptionRect good = {0, 0, 1, 1}, bad = {0, 0, INT32_MAX, INT32_MAX};
    if (caption_compositor_blit(&src, &dst, CAPTION_BLIT_OPAQUE, &good, &good, 0) != 0) return 1;
    if (caption_compositor_blit(&src, &dst, CAPTION_BLIT_KEYED, &bad, &bad, 0) !=
        CAPTION_COMPOSITOR_ERR_BOUNDS) return 2;
    src.width = INT32_MAX; src.height = INT32_MAX; src.pitch_bytes = INT32_MAX;
    if (caption_compositor_blit(&src, &dst, CAPTION_BLIT_OPAQUE, &good, &good, 0) == 0) return 3;
    dst.pitch_bytes = 7;
    if (caption_compositor_blit(&src, &dst, CAPTION_BLIT_OPAQUE, &good, &good, 0) == 0) return 4;
    puts("caption compositor sanitizer driver ok");
    return 0;
}
"""


class CaptionCompositorSanitizerTests(unittest.TestCase):
    def test_asan_ubsan_malformed_and_extreme_views(self):
        if not shutil_which_xcrun():
            raise unittest.SkipTest("xcrun unavailable")
        with tempfile.TemporaryDirectory() as directory:
            temp = Path(directory)
            driver = temp / "driver.c"
            binary = temp / "driver"
            driver.write_text(SANITIZER_DRIVER)
            build = subprocess.run(
                ["xcrun", "clang", "-arch", "arm64", "-std=c11", "-g", "-O1",
                 "-fsanitize=address,undefined", "-fno-sanitize-recover=all",
                 "-I", str(PROJECT / "src"), str(driver),
                 str(PROJECT / "src/caption_compositor.c"), "-o", str(binary)],
                capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(binary)], capture_output=True, text=True, timeout=60,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr[-2500:])
            self.assertIn("caption compositor sanitizer driver ok", run.stdout)


def shutil_which_xcrun():
    import shutil
    return shutil.which("xcrun") is not None


if __name__ == "__main__":
    unittest.main()
