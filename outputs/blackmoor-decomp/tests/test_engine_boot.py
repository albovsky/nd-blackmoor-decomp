"""Tests for original BOOT metadata and CIF type-2 image loading."""

from __future__ import annotations

import ctypes
import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
LIBRARY = PROJECT / "build/libengineboot.dylib"
BOOTTOOL = PROJECT / "build/boottool"

ENGINE_BOOT_OK = 0
CIF_OK = 0
CIF_IMAGE_OK = 0
CIF_IMAGE_ERR_METADATA = 5
CIF_IMAGE_ERR_TYPE = 4
CIF_TREE_PREFIX_SIZE = 32 + 2048
CIF_TREE_ENTRY_SIZE = 94


class DecodeContext(ctypes.Structure):
    _fields_ = [("ring", ctypes.c_uint8 * 4096)]


class HiffChunkInfo(ctypes.Structure):
    _fields_ = [
        ("data_index", ctypes.c_size_t),
        ("header_offset", ctypes.c_size_t),
        ("payload_offset", ctypes.c_size_t),
        ("padded_extent_size", ctypes.c_size_t),
        ("payload_size", ctypes.c_uint32),
        ("id", ctypes.c_char * 5),
    ]


class CifEntryInfo(ctypes.Structure):
    _fields_ = [
        ("name", ctypes.c_char * 33),
        ("id", ctypes.c_uint16),
        ("data_offset", ctypes.c_uint32),
        ("next_index", ctypes.c_uint16),
        ("metadata_41_80", ctypes.c_uint8 * 40),
        ("output_size", ctypes.c_uint32),
        ("metadata_85_88", ctypes.c_uint8 * 4),
        ("compressed_size", ctypes.c_uint32),
        ("type", ctypes.c_uint8),
    ]


class EngineBootSummary(ctypes.Structure):
    _fields_ = [
        ("logo_count", ctypes.c_uint8),
        ("object_count", ctypes.c_uint8),
        ("font_count", ctypes.c_int16),
        ("initial_scene", ctypes.c_int16),
        ("bsum_chunk_index", ctypes.c_size_t),
        ("bsum_payload_offset", ctypes.c_size_t),
        ("bsum_raw", ctypes.c_uint8 * 402),
    ]


class EngineBootImageDescriptor(ctypes.Structure):
    _fields_ = [
        ("filename", ctypes.c_char * 34),
        ("nominal_width", ctypes.c_uint16),
        ("nominal_height", ctypes.c_uint16),
        ("source_chunk_index", ctypes.c_size_t),
        ("payload_offset", ctypes.c_size_t),
        ("raw", ctypes.c_uint8 * 37),
    ]


class EngineBootMenuInfo(ctypes.Structure):
    _fields_ = [
        ("chunk", HiffChunkInfo),
        ("chunk_index", ctypes.c_size_t),
        ("raw", ctypes.POINTER(ctypes.c_uint8)),
        ("raw_size", ctypes.c_size_t),
        ("first_image_filename", ctypes.c_char * 34),
        ("first_image_nominal_width", ctypes.c_uint16),
        ("first_image_nominal_height", ctypes.c_uint16),
    ]


class EngineBootPlgoInfo(ctypes.Structure):
    _fields_ = [
        ("chunk", HiffChunkInfo),
        ("chunk_index", ctypes.c_size_t),
        ("raw", ctypes.POINTER(ctypes.c_uint8)),
        ("raw_size", ctypes.c_size_t),
        ("filename", ctypes.c_char * 34),
        ("byte_at_66", ctypes.c_uint8),
        ("sound_name_at_111", ctypes.c_char * 10),
    ]


class CifImage(ctypes.Structure):
    _fields_ = [
        ("name", ctypes.c_char * 33),
        ("id", ctypes.c_uint16),
        ("width", ctypes.c_uint16),
        ("pitch", ctypes.c_uint16),
        ("height", ctypes.c_uint16),
        ("depth", ctypes.c_uint16),
        ("pixels", ctypes.POINTER(ctypes.c_uint8)),
        ("byte_count", ctypes.c_size_t),
    ]


def build_native_tools() -> None:
    result = subprocess.run(
        [str(PROJECT / "scripts/build_boottool.sh")],
        check=False,
        text=True,
        capture_output=True,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr or result.stdout)


def load_library() -> ctypes.CDLL:
    if not LIBRARY.is_file() or not BOOTTOOL.is_file():
        build_native_tools()
    library = ctypes.CDLL(str(LIBRARY))
    byte_ptr = ctypes.POINTER(ctypes.c_uint8)
    context_ptr = ctypes.POINTER(DecodeContext)
    image_ptr = ctypes.POINTER(CifImage)
    size_ptr = ctypes.POINTER(ctypes.c_size_t)
    char_ptr = ctypes.POINTER(ctypes.c_char)

    library.cif_decode_context_init.argtypes = [context_ptr]
    library.cif_decode_context_init.restype = None
    library.cif_tree_open_memory.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        char_ptr,
        ctypes.c_size_t,
    ]
    library.cif_tree_open_memory.restype = ctypes.c_void_p
    library.cif_tree_close.argtypes = [ctypes.c_void_p]
    library.cif_tree_close.restype = None
    library.cif_tree_entry_count.argtypes = [ctypes.c_void_p]
    library.cif_tree_entry_count.restype = ctypes.c_size_t
    library.cif_tree_entry_at.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        ctypes.POINTER(CifEntryInfo),
    ]
    library.cif_tree_entry_at.restype = ctypes.c_int
    library.cif_tree_find.argtypes = [ctypes.c_void_p, ctypes.c_char_p, size_ptr]
    library.cif_tree_find.restype = ctypes.c_int
    library.cif_tree_extract.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        context_ptr,
        byte_ptr,
        ctypes.c_size_t,
        size_ptr,
        size_ptr,
    ]
    library.cif_tree_extract.restype = ctypes.c_int
    library.cif_decode_cif_memory.argtypes = [
        context_ptr,
        ctypes.c_void_p,
        ctypes.c_size_t,
        byte_ptr,
        ctypes.c_size_t,
        size_ptr,
        size_ptr,
        size_ptr,
    ]
    library.cif_decode_cif_memory.restype = ctypes.c_int

    library.engine_boot_open_memory.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        char_ptr,
        ctypes.c_size_t,
    ]
    library.engine_boot_open_memory.restype = ctypes.c_void_p
    library.engine_boot_close.argtypes = [ctypes.c_void_p]
    library.engine_boot_close.restype = None
    library.engine_boot_get_summary.argtypes = [
        ctypes.c_void_p,
        ctypes.POINTER(EngineBootSummary),
    ]
    library.engine_boot_get_summary.restype = ctypes.c_int
    library.engine_boot_chunk_count.argtypes = [ctypes.c_void_p]
    library.engine_boot_chunk_count.restype = ctypes.c_size_t
    library.engine_boot_chunk_at.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        ctypes.POINTER(HiffChunkInfo),
        ctypes.POINTER(byte_ptr),
        size_ptr,
    ]
    library.engine_boot_chunk_at.restype = ctypes.c_int
    library.engine_boot_logo_count.argtypes = [ctypes.c_void_p]
    library.engine_boot_logo_count.restype = ctypes.c_size_t
    library.engine_boot_object_count.argtypes = [ctypes.c_void_p]
    library.engine_boot_object_count.restype = ctypes.c_size_t
    library.engine_boot_logo_at.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        ctypes.POINTER(EngineBootImageDescriptor),
    ]
    library.engine_boot_logo_at.restype = ctypes.c_int
    library.engine_boot_object_at.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        ctypes.POINTER(EngineBootImageDescriptor),
    ]
    library.engine_boot_object_at.restype = ctypes.c_int
    library.engine_boot_get_menu.argtypes = [
        ctypes.c_void_p,
        ctypes.POINTER(EngineBootMenuInfo),
    ]
    library.engine_boot_get_menu.restype = ctypes.c_int
    library.engine_boot_get_plgo.argtypes = [
        ctypes.c_void_p,
        ctypes.POINTER(EngineBootPlgoInfo),
    ]
    library.engine_boot_get_plgo.restype = ctypes.c_int

    library.cif_image_decode_tree_entry.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        context_ptr,
        image_ptr,
        char_ptr,
        ctypes.c_size_t,
    ]
    library.cif_image_decode_tree_entry.restype = ctypes.c_int
    library.cif_image_decode_cif_memory.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        context_ptr,
        image_ptr,
        char_ptr,
        ctypes.c_size_t,
    ]
    library.cif_image_decode_cif_memory.restype = ctypes.c_int
    library.cif_image_to_rgba.argtypes = [image_ptr, byte_ptr, ctypes.c_size_t]
    library.cif_image_to_rgba.restype = ctypes.c_int
    library.cif_image_destroy.argtypes = [image_ptr]
    library.cif_image_destroy.restype = None
    return library


def encode_literals(data: bytes) -> bytes:
    plain = bytearray()
    for start in range(0, len(data), 8):
        group = data[start : start + 8]
        plain.append((1 << len(group)) - 1)
        plain.extend(group)
    encoded = bytearray()
    counter = 0
    for byte in plain:
        encoded.append((byte + counter) & 0xFF)
        counter = (counter + 1) & 0xFF
    return bytes(encoded)


def make_tree(name: bytes, output: bytes, *, width: int, pitch: int,
              height: int, depth: int = 16, resource_type: int = 2) -> bytes:
    compressed = encode_literals(output)
    header = bytearray(32)
    header[:20] = b"CIF TREE WayneSikes\0"
    header[24:26] = (2).to_bytes(2, "little")
    header[26:28] = (1).to_bytes(2, "little")
    header[28:30] = (1).to_bytes(2, "little")
    buckets = bytearray(b"\xff" * 2048)
    bucket = sum(name) & 0x3FF
    buckets[bucket * 2 : bucket * 2 + 2] = b"\0\0"
    data_offset = CIF_TREE_PREFIX_SIZE + CIF_TREE_ENTRY_SIZE
    record = bytearray(CIF_TREE_ENTRY_SIZE)
    record[: len(name)] = name
    record[33:35] = (7).to_bytes(2, "little")
    record[35:39] = data_offset.to_bytes(4, "little")
    record[39:41] = b"\xff\xff"
    record[73:75] = width.to_bytes(2, "little")
    record[75:77] = pitch.to_bytes(2, "little")
    record[77:79] = height.to_bytes(2, "little")
    record[79] = depth
    record[81:85] = len(output).to_bytes(4, "little")
    record[89:93] = len(compressed).to_bytes(4, "little")
    record[93] = resource_type
    return bytes(header + buckets + record + compressed)


def make_standalone_cif(output: bytes, *, width: int, pitch: int,
                        height: int, depth: int = 16, resource_type: int = 2) -> bytes:
    compressed = encode_literals(output)
    header = bytearray(81)
    header[:20] = b"CIF FILE WayneSikes\0"
    header[24:26] = (2).to_bytes(2, "little")
    header[26:28] = (1).to_bytes(2, "little")
    header[60:62] = width.to_bytes(2, "little")
    header[62:64] = pitch.to_bytes(2, "little")
    header[64:66] = height.to_bytes(2, "little")
    header[66] = depth
    header[67] = 2
    header[68:72] = len(output).to_bytes(4, "little")
    header[76:80] = len(compressed).to_bytes(4, "little")
    header[80] = resource_type
    return bytes(header + compressed)


def make_decoded_boot(chunks: list[tuple[bytes, bytes]]) -> bytes:
    chunk_bytes = bytearray()
    for chunk_id, payload in chunks:
        if len(chunk_id) != 4:
            raise ValueError("HIFF chunk identifiers are four bytes")
        chunk_bytes.extend(chunk_id)
        chunk_bytes.extend(len(payload).to_bytes(4, "big"))
        chunk_bytes.extend(payload)
        if len(payload) & 1:
            chunk_bytes.append(0)
    declared_size = 4 + len(chunk_bytes)
    return b"DATA" + declared_size.to_bytes(4, "big") + b"BOOT" + bytes(chunk_bytes)


class EngineBootImageTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.library = load_library()

    def make_context(self) -> DecodeContext:
        context = DecodeContext()
        self.library.cif_decode_context_init(ctypes.byref(context))
        return context

    def open_tree(self, data: bytes) -> tuple[int, ctypes.Array]:
        source = (ctypes.c_uint8 * len(data)).from_buffer_copy(data)
        error = ctypes.create_string_buffer(256)
        tree = self.library.cif_tree_open_memory(
            ctypes.cast(source, ctypes.c_void_p), len(data), error, len(error)
        )
        self.assertTrue(tree, error.value.decode("utf-8", "replace"))
        return tree, source

    def test_real_decoded_boot_exposes_original_startup_records(self) -> None:
        path = ROOT / "work/analysis/cif-boot-native.bin"
        if not path.is_file():
            self.skipTest(f"decoded original BOOT is unavailable: {path}")
        data = path.read_bytes()
        storage = (ctypes.c_uint8 * len(data)).from_buffer_copy(data)
        error = ctypes.create_string_buffer(256)
        boot = self.library.engine_boot_open_memory(
            ctypes.cast(storage, ctypes.c_void_p), len(data), error, len(error)
        )
        self.assertTrue(boot, error.value.decode("utf-8", "replace"))
        try:
            summary = EngineBootSummary()
            self.assertEqual(
                self.library.engine_boot_get_summary(boot, ctypes.byref(summary)),
                ENGINE_BOOT_OK,
            )
            self.assertEqual(
                (summary.logo_count, summary.object_count, summary.font_count,
                 summary.initial_scene),
                (1, 1, 18, 0),
            )
            self.assertEqual(summary.bsum_raw[242], 1)
            self.assertEqual(summary.bsum_raw[243], 1)
            self.assertEqual(bytes(summary.bsum_raw[337:339]), (18).to_bytes(2, "little"))
            self.assertEqual(bytes(summary.bsum_raw[221:223]), b"\0\0")
            self.assertEqual(summary.bsum_payload_offset, 20)
            self.assertEqual(self.library.engine_boot_chunk_count(boot), 40)

            menu = EngineBootMenuInfo()
            self.assertEqual(self.library.engine_boot_get_menu(boot, ctypes.byref(menu)), 0)
            self.assertEqual(menu.raw_size, 631)
            self.assertEqual(menu.first_image_filename, b"MAIN")
            self.assertEqual((menu.first_image_nominal_width,
                              menu.first_image_nominal_height), (640, 727))

            plgo = EngineBootPlgoInfo()
            self.assertEqual(self.library.engine_boot_get_plgo(boot, ctypes.byref(plgo)), 0)
            self.assertEqual(plgo.raw_size, 160)
            self.assertEqual(plgo.filename, b"her_logo_splash")
            self.assertEqual(plgo.byte_at_66, 0)
            self.assertEqual(plgo.sound_name_at_111, b"NO SOUND")

            logo = EngineBootImageDescriptor()
            self.assertEqual(self.library.engine_boot_logo_at(boot, 0, ctypes.byref(logo)), 0)
            self.assertEqual(logo.filename, b"LOGO")
            self.assertEqual((logo.nominal_width, logo.nominal_height), (640, 480))
            self.assertEqual(bytes(logo.raw[33:37]), b"\x80\x02\xe0\x01")

            image_object = EngineBootImageDescriptor()
            self.assertEqual(
                self.library.engine_boot_object_at(boot, 0, ctypes.byref(image_object)), 0
            )
            self.assertEqual(image_object.filename, b"UIShared_OVL")
            self.assertEqual((image_object.nominal_width, image_object.nominal_height),
                             (1000, 800))
        finally:
            self.library.engine_boot_close(boot)

    def test_malformed_short_bsum_is_rejected_without_reading_past_chunk(self) -> None:
        short_bsum = make_decoded_boot([(b"BSUM", b"\0" * 401)])
        source = (ctypes.c_uint8 * len(short_bsum)).from_buffer_copy(short_bsum)
        error = ctypes.create_string_buffer(256)
        boot = self.library.engine_boot_open_memory(
            ctypes.cast(source, ctypes.c_void_p), len(short_bsum), error, len(error)
        )
        self.assertFalse(boot)
        self.assertIn(b"at least 402", error.value)

    def test_bsum_scene_and_font_count_are_signed_little_endian_words(self) -> None:
        bsum = bytearray(402)
        bsum[221:223] = (-1).to_bytes(2, "little", signed=True)
        bsum[337:339] = (-2).to_bytes(2, "little", signed=True)
        boot_bytes = make_decoded_boot([(b"BSUM", bytes(bsum))])
        source = (ctypes.c_uint8 * len(boot_bytes)).from_buffer_copy(boot_bytes)
        error = ctypes.create_string_buffer(256)
        boot = self.library.engine_boot_open_memory(
            ctypes.cast(source, ctypes.c_void_p), len(boot_bytes), error, len(error)
        )
        self.assertTrue(boot, error.value.decode("utf-8", "replace"))
        try:
            summary = EngineBootSummary()
            self.assertEqual(
                self.library.engine_boot_get_summary(boot, ctypes.byref(summary)), 0
            )
            self.assertEqual((summary.initial_scene, summary.font_count), (-1, -2))
        finally:
            self.library.engine_boot_close(boot)

    def test_malformed_short_descriptor_and_plgo_are_bounds_errors(self) -> None:
        bsum = bytearray(402)
        bsum[242] = 1
        boot_bytes = make_decoded_boot([
            (b"BSUM", bytes(bsum)),
            (b"LG0\0", b"\0" * 36),
            (b"PLGO", b"\0" * 119),
        ])
        source = (ctypes.c_uint8 * len(boot_bytes)).from_buffer_copy(boot_bytes)
        error = ctypes.create_string_buffer(256)
        boot = self.library.engine_boot_open_memory(
            ctypes.cast(source, ctypes.c_void_p), len(boot_bytes), error, len(error)
        )
        self.assertTrue(boot, error.value.decode("utf-8", "replace"))
        try:
            descriptor = EngineBootImageDescriptor()
            self.assertNotEqual(
                self.library.engine_boot_logo_at(boot, 0, ctypes.byref(descriptor)),
                ENGINE_BOOT_OK,
            )
            plgo = EngineBootPlgoInfo()
            self.assertNotEqual(
                self.library.engine_boot_get_plgo(boot, ctypes.byref(plgo)),
                ENGINE_BOOT_OK,
            )
        finally:
            self.library.engine_boot_close(boot)

    def test_boottool_emits_decoded_boot_json_without_fabricating_ui(self) -> None:
        path = ROOT / "work/analysis/cif-boot-native.bin"
        if not path.is_file():
            self.skipTest(f"decoded original BOOT is unavailable: {path}")
        result = subprocess.run(
            [str(BOOTTOOL), "inspect", "--boot-resource", str(path)],
            check=True,
            text=True,
            capture_output=True,
        )
        report = json.loads(result.stdout)
        self.assertEqual(report["summary"]["font_count"], 18)
        self.assertEqual(report["menu"]["first_image"], "MAIN")
        self.assertEqual(report["plgo"]["sound_name_at_111"], "NO SOUND")
        self.assertEqual(len(report["chunks"]), 40)
        self.assertEqual(
            [(item["kind"], item["filename"]) for item in report["descriptors"]],
            [("menu", "MAIN"), ("logo", "LOGO"), ("object", "UIShared_OVL")],
        )
        self.assertEqual(report["assets"], [])

    def test_boottool_accepts_an_explicit_standalone_boot_cif(self) -> None:
        path = ROOT / "work/analysis/cif-boot-native.bin"
        if not path.is_file():
            self.skipTest(f"decoded original BOOT is unavailable: {path}")
        data = path.read_bytes()
        standalone = make_standalone_cif(data, width=0, pitch=0, height=0,
                                         resource_type=3)
        with tempfile.TemporaryDirectory() as temporary_directory:
            cif_path = Path(temporary_directory) / "BOOT.CIF"
            cif_path.write_bytes(standalone)
            result = subprocess.run(
                [str(BOOTTOOL), "inspect", "--boot-cif", str(cif_path)],
                check=True,
                text=True,
                capture_output=True,
            )
        report = json.loads(result.stdout)
        self.assertEqual(report["boot_source"]["kind"], "standalone-cif")
        self.assertEqual(report["decoded_size"], len(data))
        self.assertEqual(report["summary"]["initial_scene"], 0)

    def test_boottool_reports_declared_missing_and_truncated_image_descriptors(self) -> None:
        bsum = bytearray(402)
        bsum[242] = 1  # LG0 is declared but its descriptor is truncated.
        bsum[243] = 1  # OB0 is declared but absent.
        decoded = make_decoded_boot([
            (b"BSUM", bytes(bsum)),
            (b"LG0\0", b"\0" * 36),
        ])
        with tempfile.TemporaryDirectory() as temporary_directory:
            boot_path = Path(temporary_directory) / "BOOT.bin"
            boot_path.write_bytes(decoded)
            result = subprocess.run(
                [str(BOOTTOOL), "inspect", "--boot-resource", str(boot_path),
                 "--external-cif-dir", temporary_directory],
                check=False,
                text=True,
                capture_output=True,
            )
        self.assertEqual(result.returncode, 1, result.stderr)
        report = json.loads(result.stdout)
        unresolved = {
            (item["kind"], item["index"]): item
            for item in report["descriptors"]
            if item["status"] == "unresolved"
        }
        self.assertEqual(set(unresolved), {("logo", 0), ("object", 0)})
        self.assertIn("out of bounds", unresolved[("logo", 0)]["error"])
        self.assertIn("not present", unresolved[("object", 0)]["error"])
        unresolved_assets = {
            (item["kind"], item["index"]): item
            for item in report["assets"]
            if item["status"] == "declared-record-unresolved"
        }
        self.assertEqual(set(unresolved_assets), {("logo", 0), ("object", 0)})

    def test_tree_image_uses_actual_dimensions_and_returns_raw_rgb555(self) -> None:
        raw = b"\x00\x7c\xe0\x03"
        archive = make_tree(b"IMAGE", raw, width=2, pitch=4, height=1)
        tree, _owner = self.open_tree(archive)
        context = self.make_context()
        image = CifImage()
        error = ctypes.create_string_buffer(256)
        try:
            status = self.library.cif_image_decode_tree_entry(
                tree, 0, ctypes.byref(context), ctypes.byref(image), error, len(error)
            )
            self.assertEqual(status, CIF_IMAGE_OK, error.value.decode("utf-8", "replace"))
            self.assertEqual(image.name, b"IMAGE")
            self.assertEqual((image.width, image.pitch, image.height, image.depth),
                             (2, 4, 1, 16))
            self.assertEqual(image.byte_count, len(raw))
            self.assertEqual(ctypes.string_at(image.pixels, image.byte_count), raw)

            rgba = (ctypes.c_uint8 * 8)()
            self.assertEqual(self.library.cif_image_to_rgba(ctypes.byref(image), rgba, 8), 1)
            self.assertEqual(bytes(rgba), bytes((255, 0, 0, 255, 0, 255, 0, 255)))
            self.assertEqual(self.library.cif_image_to_rgba(ctypes.byref(image), rgba, 7), 0)
        finally:
            self.library.cif_image_destroy(ctypes.byref(image))
            self.library.cif_tree_close(tree)

    def test_tree_metadata_mismatch_is_rejected_before_decode(self) -> None:
        archive = make_tree(b"BAD", b"\x00\x00\x00\x00", width=2, pitch=6, height=1)
        tree, _owner = self.open_tree(archive)
        context = self.make_context()
        image = CifImage()
        error = ctypes.create_string_buffer(256)
        try:
            status = self.library.cif_image_decode_tree_entry(
                tree, 0, ctypes.byref(context), ctypes.byref(image), error, len(error)
            )
            self.assertEqual(status, CIF_IMAGE_ERR_METADATA)
            self.assertIn(b"pitch", error.value)
            self.assertFalse(image.pixels)
        finally:
            self.library.cif_image_destroy(ctypes.byref(image))
            self.library.cif_tree_close(tree)

    def test_tree_entry_must_be_type_two(self) -> None:
        archive = make_tree(b"DATA", b"1234", width=2, pitch=4,
                            height=1, resource_type=3)
        tree, _owner = self.open_tree(archive)
        image = CifImage()
        error = ctypes.create_string_buffer(256)
        try:
            status = self.library.cif_image_decode_tree_entry(
                tree, 0, ctypes.byref(self.make_context()), ctypes.byref(image),
                error, len(error)
            )
            self.assertEqual(status, CIF_IMAGE_ERR_TYPE)
            self.assertFalse(image.pixels)
        finally:
            self.library.cif_image_destroy(ctypes.byref(image))
            self.library.cif_tree_close(tree)

    def test_explicit_standalone_cif_image_metadata_and_pixels(self) -> None:
        raw = b"\x00\x7c\xe0\x03"
        standalone = make_standalone_cif(raw, width=2, pitch=4, height=1)
        source = (ctypes.c_uint8 * len(standalone)).from_buffer_copy(standalone)
        context = self.make_context()
        image = CifImage()
        error = ctypes.create_string_buffer(256)
        status = self.library.cif_image_decode_cif_memory(
            ctypes.cast(source, ctypes.c_void_p), len(standalone),
            ctypes.byref(context), ctypes.byref(image), error, len(error)
        )
        try:
            self.assertEqual(status, CIF_IMAGE_OK, error.value.decode("utf-8", "replace"))
            self.assertEqual((image.width, image.pitch, image.height, image.depth),
                             (2, 4, 1, 16))
            self.assertEqual(ctypes.string_at(image.pixels, image.byte_count), raw)
        finally:
            self.library.cif_image_destroy(ctypes.byref(image))

    def test_standalone_depth_is_one_byte_and_wrong_metadata_fails(self) -> None:
        standalone = make_standalone_cif(b"\0\0\0\0", width=2, pitch=6, height=1)
        source = (ctypes.c_uint8 * len(standalone)).from_buffer_copy(standalone)
        image = CifImage()
        error = ctypes.create_string_buffer(256)
        status = self.library.cif_image_decode_cif_memory(
            ctypes.cast(source, ctypes.c_void_p), len(standalone),
            ctypes.byref(self.make_context()), ctypes.byref(image), error, len(error)
        )
        self.assertEqual(status, CIF_IMAGE_ERR_METADATA)
        self.assertIn(b"pitch", error.value)

    def test_real_original_logo_cif_header_matches_verified_dimensions(self) -> None:
        configured = os.environ.get("BLACKMOOR_LOGO_CIF")
        if configured:
            path = Path(configured)
        else:
            app = Path("/Applications/Nancy Drew - Curse of Blackmoor Manor.app")
            path = next(iter(app.rglob("Logo.CIF")), None) if app.exists() else None
        if path is None or not path.is_file():
            self.skipTest("original standalone Logo.CIF is not available")
        data = path.read_bytes()
        source = (ctypes.c_uint8 * len(data)).from_buffer_copy(data)
        image = CifImage()
        error = ctypes.create_string_buffer(256)
        status = self.library.cif_image_decode_cif_memory(
            ctypes.cast(source, ctypes.c_void_p), len(data),
            ctypes.byref(self.make_context()), ctypes.byref(image), error, len(error)
        )
        try:
            self.assertEqual(status, CIF_IMAGE_OK, error.value.decode("utf-8", "replace"))
            self.assertEqual((image.width, image.pitch, image.height, image.depth,
                              image.byte_count), (640, 1280, 480, 16, 614400))
        finally:
            self.library.cif_image_destroy(ctypes.byref(image))

    def test_original_boot_and_tree_image_actual_sizes_are_not_nominal_sizes(self) -> None:
        app = Path("/Applications/Nancy Drew - Curse of Blackmoor Manor.app")
        tree_path = next(iter(app.rglob("CIFTREE.DAT")), None) if app.exists() else None
        boot_path = ROOT / "work/analysis/cif-boot-native.bin"
        if tree_path is None or not boot_path.is_file():
            self.skipTest("original installed CIFTREE and decoded BOOT are not available")
        result = subprocess.run(
            [str(BOOTTOOL), "inspect", "--boot-resource", str(boot_path),
             "--tree", str(tree_path)],
            check=True,
            text=True,
            capture_output=True,
        )
        report = json.loads(result.stdout)
        by_name = {asset["filename"]: asset for asset in report["assets"]}
        self.assertEqual((by_name["MAIN"]["nominal_height"],
                          by_name["MAIN"]["actual_height"]), (727, 743))
        self.assertEqual((by_name["UIShared_OVL"]["nominal_width"],
                          by_name["UIShared_OVL"]["actual_width"],
                          by_name["UIShared_OVL"]["nominal_height"],
                          by_name["UIShared_OVL"]["actual_height"]),
                         (1000, 447, 800, 660))

    def test_all_original_tree_type_two_images_decode_with_recovered_metadata(self) -> None:
        app = Path("/Applications/Nancy Drew - Curse of Blackmoor Manor.app")
        tree_path = next(iter(app.rglob("CIFTREE.DAT")), None) if app.exists() else None
        if tree_path is None:
            self.skipTest("original installed CIFTREE.DAT is not available")
        archive = tree_path.read_bytes()
        tree, _owner = self.open_tree(archive)
        context = self.make_context()
        image = CifImage()
        error = ctypes.create_string_buffer(256)
        image_count = 0
        try:
            for index in range(self.library.cif_tree_entry_count(tree)):
                entry = CifEntryInfo()
                self.assertEqual(
                    self.library.cif_tree_entry_at(tree, index, ctypes.byref(entry)),
                    CIF_OK,
                )
                if entry.type != 2:
                    continue
                status = self.library.cif_image_decode_tree_entry(
                    tree, index, ctypes.byref(context), ctypes.byref(image),
                    error, len(error)
                )
                self.assertEqual(status, CIF_IMAGE_OK,
                                 f"{entry.name!r}: {error.value.decode('utf-8', 'replace')}")
                self.assertEqual(image.depth, 16, entry.name)
                self.assertEqual(image.pitch, image.width * 2, entry.name)
                self.assertEqual(image.byte_count, image.pitch * image.height, entry.name)
                self.assertEqual(image.byte_count, entry.output_size, entry.name)
                image_count += 1
                self.library.cif_image_destroy(ctypes.byref(image))
            self.assertEqual(image_count, 619)
        finally:
            self.library.cif_image_destroy(ctypes.byref(image))
            self.library.cif_tree_close(tree)

    def test_external_cif_preference_is_reported_and_malformed_patch_does_not_fallback(self) -> None:
        app = Path("/Applications/Nancy Drew - Curse of Blackmoor Manor.app")
        tree_path = next(iter(app.rglob("CIFTREE.DAT")), None) if app.exists() else None
        boot_path = ROOT / "work/analysis/cif-boot-native.bin"
        if tree_path is None or not boot_path.is_file():
            self.skipTest("original installed CIFTREE and decoded BOOT are not available")
        with tempfile.TemporaryDirectory() as temporary_directory:
            patch_dir = Path(temporary_directory)
            (patch_dir / "LOGO.CIF").write_bytes(b"present but invalid")
            result = subprocess.run(
                [str(BOOTTOOL), "inspect", "--boot-resource", str(boot_path),
                 "--tree", str(tree_path), "--external-cif-dir", str(patch_dir)],
                check=False,
                text=True,
                capture_output=True,
            )
        self.assertEqual(result.returncode, 1)
        report = json.loads(result.stdout)
        logo = next(asset for asset in report["assets"] if asset["filename"] == "LOGO")
        self.assertEqual(logo["source"], "external-cif")
        self.assertEqual(logo["status"], "decode-error:image dimensions or output extent are out of bounds")
        self.assertNotIn("actual_width", logo)

    def test_boottool_reports_external_patch_and_explicit_tree_fallback_sources(self) -> None:
        app = Path("/Applications/Nancy Drew - Curse of Blackmoor Manor.app")
        tree_path = next(iter(app.rglob("CIFTREE.DAT")), None) if app.exists() else None
        logo_path = next(iter(app.rglob("Logo.CIF")), None) if app.exists() else None
        boot_path = ROOT / "work/analysis/cif-boot-native.bin"
        if tree_path is None or logo_path is None or not boot_path.is_file():
            self.skipTest("original installed CIFTREE, Logo.CIF, and decoded BOOT are unavailable")
        result = subprocess.run(
            [str(BOOTTOOL), "inspect", "--boot-resource", str(boot_path),
             "--tree", str(tree_path), "--external-cif-dir", str(logo_path.parent)],
            check=True,
            text=True,
            capture_output=True,
        )
        report = json.loads(result.stdout)
        by_name = {asset["filename"]: asset for asset in report["assets"]}
        self.assertEqual(by_name["LOGO"]["source"], "external-cif")
        self.assertEqual(by_name["LOGO"]["status"], "decoded")
        self.assertEqual(by_name["LOGO"]["actual_width"], 640)
        self.assertEqual(by_name["MAIN"]["source"], "tree-after-external-miss")
        self.assertTrue(by_name["MAIN"]["external_candidate_path"].endswith("MAIN.CIF"))
        self.assertTrue(report["external_cif_preference"]["enabled_by_cli"])

    def test_boottool_resolves_mixed_case_external_cif_filename(self) -> None:
        boot_path = ROOT / "work/analysis/cif-boot-native.bin"
        if not boot_path.is_file():
            self.skipTest(f"decoded original BOOT is unavailable: {boot_path}")
        with tempfile.TemporaryDirectory() as temporary_directory:
            patch_dir = Path(temporary_directory)
            image_path = patch_dir / "Logo.CIF"
            image_path.write_bytes(
                make_standalone_cif(b"\x00\x00", width=1, pitch=2, height=1)
            )
            result = subprocess.run(
                [str(BOOTTOOL), "inspect", "--boot-resource", str(boot_path),
                 "--external-cif-dir", str(patch_dir)],
                check=True,
                text=True,
                capture_output=True,
            )
        report = json.loads(result.stdout)
        logo = next(asset for asset in report["assets"] if asset["filename"] == "LOGO")
        self.assertEqual(logo["source"], "external-cif")
        self.assertEqual(Path(logo["source_path"]).name, "Logo.CIF")
        self.assertEqual(logo["status"], "decoded")

    def test_boottool_rejects_ambiguous_casefold_external_cif_names(self) -> None:
        boot_path = ROOT / "work/analysis/cif-boot-native.bin"
        if not boot_path.is_file():
            self.skipTest(f"decoded original BOOT is unavailable: {boot_path}")
        with tempfile.TemporaryDirectory() as temporary_directory:
            patch_dir = Path(temporary_directory)
            first = patch_dir / "Logo.CIF"
            second = patch_dir / "LOGO.cif"
            first.write_bytes(
                make_standalone_cif(b"\x00\x00", width=1, pitch=2, height=1)
            )
            second.write_bytes(
                make_standalone_cif(b"\x00\x00", width=1, pitch=2, height=1)
            )
            if first.samefile(second):
                self.skipTest("case-insensitive filesystem cannot represent duplicate names")
            result = subprocess.run(
                [str(BOOTTOOL), "inspect", "--boot-resource", str(boot_path),
                 "--external-cif-dir", str(patch_dir)],
                check=False,
                text=True,
                capture_output=True,
            )
        self.assertEqual(result.returncode, 1, result.stderr)
        report = json.loads(result.stdout)
        logo = next(asset for asset in report["assets"] if asset["filename"] == "LOGO")
        self.assertEqual(logo["source"], "external-cif")
        self.assertEqual(
            logo["status"],
            "external-path-error:ambiguous-case-insensitive-external-cif-filename",
        )


if __name__ == "__main__":
    unittest.main()
