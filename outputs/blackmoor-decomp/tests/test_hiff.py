"""Regression tests for original CHiff DATA/chunk indexing semantics."""

from __future__ import annotations

import ctypes
import json
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
WORKSPACE = PROJECT.parents[1]
LIBRARY_PATH = PROJECT / "build/libhiff.dylib"
TOOL_PATH = PROJECT / "build/hifftool"
BOOT_PATH = WORKSPACE / "work/analysis/cif-boot-native.bin"
RESOURCE_MANIFEST = WORKSPACE / "work/analysis/hiff-resources.json"

HIFF_OK = 0
HIFF_ERR_FORMAT = 3
HIFF_ERR_BOUNDS = 4
HIFF_ERR_LIMIT = 5
HIFF_ERR_NOT_FOUND = 6
HIFF_SELECTION_DATA = 1
HIFF_SELECTION_CHUNK = 2


class DataInfo(ctypes.Structure):
    _fields_ = [
        ("record_offset", ctypes.c_size_t),
        ("type_offset", ctypes.c_size_t),
        ("body_offset", ctypes.c_size_t),
        ("extent_size", ctypes.c_size_t),
        ("declared_size", ctypes.c_uint32),
        ("type", ctypes.c_char * 5),
    ]


class ChunkInfo(ctypes.Structure):
    _fields_ = [
        ("data_index", ctypes.c_size_t),
        ("header_offset", ctypes.c_size_t),
        ("payload_offset", ctypes.c_size_t),
        ("padded_extent_size", ctypes.c_size_t),
        ("payload_size", ctypes.c_uint32),
        ("id", ctypes.c_char * 5),
    ]


class SelectionInfo(ctypes.Structure):
    _fields_ = [
        ("kind", ctypes.c_int),
        ("index", ctypes.c_size_t),
        ("data_index", ctypes.c_size_t),
        ("record_offset", ctypes.c_size_t),
        ("header_offset", ctypes.c_size_t),
        ("payload_offset", ctypes.c_size_t),
        ("length", ctypes.c_size_t),
        ("name", ctypes.c_char * 5),
    ]


def bind_library(library: ctypes.CDLL) -> None:
    byte_ptr = ctypes.POINTER(ctypes.c_uint8)
    size_ptr = ctypes.POINTER(ctypes.c_size_t)
    info_ptr = ctypes.POINTER(SelectionInfo)

    library.hiff_open_memory.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_char),
        ctypes.c_size_t,
    ]
    library.hiff_open_memory.restype = ctypes.c_void_p
    library.hiff_close.argtypes = [ctypes.c_void_p]
    library.hiff_close.restype = None
    library.hiff_data_count.argtypes = [ctypes.c_void_p]
    library.hiff_data_count.restype = ctypes.c_size_t
    library.hiff_chunk_count.argtypes = [ctypes.c_void_p]
    library.hiff_chunk_count.restype = ctypes.c_size_t
    library.hiff_data_at.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.POINTER(DataInfo)]
    library.hiff_data_at.restype = ctypes.c_int
    library.hiff_chunk_at.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.POINTER(ChunkInfo)]
    library.hiff_chunk_at.restype = ctypes.c_int
    for name in ("hiff_select_data", "hiff_select_chunk", "hiff_select_first", "hiff_select_next"):
        function = getattr(library, name)
        function.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
        function.restype = ctypes.c_int
    for name in (
        "hiff_get_selected_data",
        "hiff_get_selected_chunk",
        "hiff_get_selected",
    ):
        function = getattr(library, name)
        function.argtypes = [
            ctypes.c_void_p,
            ctypes.POINTER(byte_ptr),
            size_ptr,
            info_ptr,
        ]
        function.restype = ctypes.c_int


def load_library() -> ctypes.CDLL:
    if not LIBRARY_PATH.is_file():
        raise unittest.SkipTest(f"HIFF library is not built: {LIBRARY_PATH}")
    library = ctypes.CDLL(str(LIBRARY_PATH))
    bind_library(library)
    return library


def make_chunk(identifier: bytes, payload: bytes) -> bytes:
    if len(identifier) != 4:
        raise ValueError("chunk identifiers must have four source bytes")
    return identifier + len(payload).to_bytes(4, "big") + payload + (b"\0" if len(payload) & 1 else b"")


def make_data(data_type: bytes, contents: bytes) -> bytes:
    if len(data_type) != 4:
        raise ValueError("DATA types must have four source bytes")
    declared_size = len(data_type) + len(contents)
    return b"DATA" + declared_size.to_bytes(4, "big") + data_type + contents


def open_hiff(library: ctypes.CDLL, raw: bytes) -> tuple[int, ctypes.Array, ctypes.Array]:
    source = ctypes.create_string_buffer(raw)
    error = ctypes.create_string_buffer(256)
    hiff = library.hiff_open_memory(source, len(raw), error, len(error))
    return hiff, source, error


def selected_bytes(library: ctypes.CDLL, hiff: int, getter: str) -> tuple[bytes, SelectionInfo]:
    pointer = ctypes.POINTER(ctypes.c_uint8)()
    length = ctypes.c_size_t()
    info = SelectionInfo()
    status = getattr(library, getter)(hiff, ctypes.byref(pointer), ctypes.byref(length), ctypes.byref(info))
    if status != HIFF_OK:
        raise AssertionError(f"{getter} returned status {status}")
    return ctypes.string_at(pointer, length.value), info


class HiffTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.library = load_library()

    def test_nested_data_is_skipped_and_chunks_remain_flat_in_record_order(self) -> None:
        child = make_data(b"CHLD", make_chunk(b"KID1", b"c"))
        before = make_chunk(b"PRE1", b"a")
        after = make_chunk(b"POST", b"xyz")
        raw = make_data(b"ROOT", before + child + after)
        hiff, _, error = open_hiff(self.library, raw)
        self.assertTrue(hiff, error.value.decode("ascii", errors="replace"))
        try:
            self.assertEqual(self.library.hiff_data_count(hiff), 2)
            self.assertEqual(self.library.hiff_chunk_count(hiff), 3)
            records = [DataInfo(), DataInfo()]
            chunks = [ChunkInfo() for _ in range(3)]
            for index, record in enumerate(records):
                self.assertEqual(self.library.hiff_data_at(hiff, index, ctypes.byref(record)), HIFF_OK)
            for index, chunk in enumerate(chunks):
                self.assertEqual(self.library.hiff_chunk_at(hiff, index, ctypes.byref(chunk)), HIFF_OK)

            self.assertEqual([record.type.decode() for record in records], ["ROOT", "CHLD"])
            self.assertEqual(records[0].record_offset, 0)
            self.assertEqual(records[0].type_offset, 8)
            self.assertEqual(records[0].body_offset, 12)
            self.assertEqual(records[0].extent_size, len(raw))
            self.assertEqual([chunk.id.decode() for chunk in chunks], ["PRE1", "POST", "KID1"])
            self.assertEqual([chunk.data_index for chunk in chunks], [0, 0, 1])
            self.assertEqual(chunks[0].padded_extent_size, 10)
            self.assertEqual(chunks[1].payload_size, 3)
            self.assertEqual(chunks[1].padded_extent_size, 12)
        finally:
            self.library.hiff_close(hiff)

    def test_adjacent_nested_data_preserves_original_fallthrough_bug(self) -> None:
        first_child = make_data(b"CHL1", make_chunk(b"KID1", b"c"))
        second_child = make_data(b"CHL2", make_chunk(b"KID2", b"d"))
        before = make_chunk(b"PRE1", b"a")
        raw = make_data(
            b"ROOT",
            before + first_child + second_child
            + make_chunk(b"POST", b"after"),
        )
        hiff, _, error = open_hiff(self.library, raw)
        self.assertTrue(hiff, error.value.decode("ascii", errors="replace"))
        try:
            chunks = [ChunkInfo() for _ in range(self.library.hiff_chunk_count(hiff))]
            for index, chunk in enumerate(chunks):
                self.assertEqual(self.library.hiff_chunk_at(hiff, index, ctypes.byref(chunk)), HIFF_OK)
            self.assertEqual([chunk.id.decode() for chunk in chunks],
                             ["PRE1", "DATA", "POST", "KID1", "KID2"])
            self.assertEqual([chunk.data_index for chunk in chunks], [0, 0, 0, 1, 2])
            adjacent_data_chunk = chunks[1]
            self.assertEqual(adjacent_data_chunk.header_offset, 44)
            self.assertEqual(adjacent_data_chunk.payload_size, 14)
            self.assertEqual(self.library.hiff_select_chunk(hiff, b"DATA"), HIFF_OK)
            data_payload, data_info = selected_bytes(self.library, hiff, "hiff_get_selected_chunk")
            self.assertEqual(data_payload[:4], b"CHL2")
            self.assertEqual(data_info.data_index, 0)
        finally:
            self.library.hiff_close(hiff)

    def test_selection_state_is_independent_and_misses_preserve_selections(self) -> None:
        raw = make_data(
            b"ROOT",
            make_chunk(b"DUP1", b"one")
            + make_chunk(b"DUP1", b"two")
            + make_chunk(b"END!", b"!"),
        )
        hiff, _, error = open_hiff(self.library, raw)
        self.assertTrue(hiff, error.value.decode("ascii", errors="replace"))
        try:
            self.assertEqual(self.library.hiff_select_data(hiff, b"ROOT"), HIFF_OK)
            data, data_info = selected_bytes(self.library, hiff, "hiff_get_selected_data")
            self.assertEqual(data[:4], b"DUP1")
            self.assertEqual(data_info.kind, HIFF_SELECTION_DATA)

            self.assertEqual(self.library.hiff_select_chunk(hiff, b"DUP1"), HIFF_OK)
            first, first_info = selected_bytes(self.library, hiff, "hiff_get_selected_chunk")
            self.assertEqual(first, b"one")
            self.assertEqual(first_info.kind, HIFF_SELECTION_CHUNK)
            self.assertEqual(self.library.hiff_select_data(hiff, b"MISS"), HIFF_ERR_NOT_FOUND)
            self.assertEqual(self.library.hiff_select_chunk(hiff, b"MISS"), HIFF_ERR_NOT_FOUND)
            self.assertEqual(selected_bytes(self.library, hiff, "hiff_get_selected_data")[0], data)
            self.assertEqual(selected_bytes(self.library, hiff, "hiff_get_selected_chunk")[0], first)

            self.assertEqual(self.library.hiff_select_first(hiff, b"DUP1"), HIFF_OK)
            self.assertEqual(selected_bytes(self.library, hiff, "hiff_get_selected_chunk")[0], b"one")
            self.assertEqual(self.library.hiff_select_next(hiff, b"DUP1"), HIFF_OK)
            second, second_info = selected_bytes(self.library, hiff, "hiff_get_selected_chunk")
            self.assertEqual((second, second_info.index), (b"two", 1))
            self.assertEqual(self.library.hiff_select_next(hiff, b"DUP1"), HIFF_ERR_NOT_FOUND)
            self.assertEqual(selected_bytes(self.library, hiff, "hiff_get_selected_chunk")[0], b"two")

            # First resets the used array even when the requested id is absent,
            # while leaving the prior selected chunk intact on that miss.
            self.assertEqual(self.library.hiff_select_first(hiff, b"NOPE"), HIFF_ERR_NOT_FOUND)
            self.assertEqual(selected_bytes(self.library, hiff, "hiff_get_selected_chunk")[0], b"two")
            self.assertEqual(self.library.hiff_select_next(hiff, b"DUP1"), HIFF_OK)
            self.assertEqual(selected_bytes(self.library, hiff, "hiff_get_selected_chunk")[0], b"one")
        finally:
            self.library.hiff_close(hiff)

    def test_case_sensitive_short_nul_fourcc(self) -> None:
        raw = make_data(b"R\0OT", make_chunk(b"CD\0X", b"nul-id"))
        hiff, _, error = open_hiff(self.library, raw)
        self.assertTrue(hiff, error.value.decode("ascii", errors="replace"))
        try:
            self.assertEqual(self.library.hiff_select_data(hiff, b"R"), HIFF_OK)
            self.assertEqual(self.library.hiff_select_data(hiff, b"r"), HIFF_ERR_NOT_FOUND)
            self.assertEqual(self.library.hiff_select_chunk(hiff, b"CD"), HIFF_OK)
            self.assertEqual(selected_bytes(self.library, hiff, "hiff_get_selected_chunk")[0], b"nul-id")
            self.assertEqual(self.library.hiff_select_chunk(hiff, b"cd"), HIFF_ERR_NOT_FOUND)
            self.assertEqual(self.library.hiff_select_chunk(hiff, b"C"), HIFF_ERR_NOT_FOUND)
        finally:
            self.library.hiff_close(hiff)

    def test_open_memory_owns_its_input_copy(self) -> None:
        raw = make_data(b"ROOT", make_chunk(b"ONE!", b"original"))
        hiff, source, error = open_hiff(self.library, raw)
        self.assertTrue(hiff, error.value.decode("ascii", errors="replace"))
        try:
            ctypes.memset(source, 0, len(raw))
            self.assertEqual(self.library.hiff_select_chunk(hiff, b"ONE!"), HIFF_OK)
            self.assertEqual(selected_bytes(self.library, hiff, "hiff_get_selected_chunk")[0], b"original")
        finally:
            self.library.hiff_close(hiff)

    def test_malformed_bounds_and_original_limits_are_checked(self) -> None:
        truncated_record = b"DATA\x00\x00"
        hiff, _, error = open_hiff(self.library, truncated_record)
        self.assertFalse(hiff)
        self.assertIn(b"truncated", error.value)

        oversized_record = b"DATA\x00\x00\x00\x20ROOT"
        hiff, _, error = open_hiff(self.library, oversized_record)
        self.assertFalse(hiff)
        self.assertIn(b"past input end", error.value)

        no_pad = b"DATA\x00\x00\x00\x0fROOTODD!\x00\x00\x00\x03abc"
        hiff, _, error = open_hiff(self.library, no_pad)
        self.assertFalse(hiff)
        self.assertIn(b"past DATA record", error.value)

        for declared_size in range(4):
            with self.subTest(declared_size=declared_size):
                truncated_type = (
                    b"DATA"
                    + declared_size.to_bytes(4, "big")
                    + (b"X" * declared_size)
                )
                hiff, _, error = open_hiff(self.library, truncated_type)
                self.assertFalse(hiff)
                self.assertIn(b"four-byte type", error.value)

        too_small = make_data(b"ROOT", b"")
        hiff, _, error = open_hiff(self.library, too_small)
        self.assertFalse(hiff)
        self.assertIn(b"smaller than 9", error.value)

        empty_chunk_record = make_data(b"ROOT", b"ZERO\0\0\0\0")
        many_records = empty_chunk_record * 1000
        hiff, _, error = open_hiff(self.library, many_records)
        self.assertFalse(hiff)
        self.assertIn(b"limit", error.value)

        many_chunks = make_data(b"ROOT", b"ZERO\0\0\0\0" * 1000)
        hiff, _, error = open_hiff(self.library, many_chunks)
        self.assertFalse(hiff)
        self.assertIn(b"limit", error.value)

    @unittest.skipUnless(BOOT_PATH.is_file(), "decoded boot resource is unavailable")
    def test_decoded_boot_resource_matches_observed_data_and_chunk_index(self) -> None:
        raw = BOOT_PATH.read_bytes()
        hiff, _, error = open_hiff(self.library, raw)
        self.assertTrue(hiff, error.value.decode("ascii", errors="replace"))
        try:
            self.assertEqual(self.library.hiff_data_count(hiff), 2)
            self.assertEqual(self.library.hiff_chunk_count(hiff), 40)
            first = DataInfo()
            nested = DataInfo()
            self.assertEqual(self.library.hiff_data_at(hiff, 0, ctypes.byref(first)), HIFF_OK)
            self.assertEqual(self.library.hiff_data_at(hiff, 1, ctypes.byref(nested)), HIFF_OK)
            self.assertEqual((first.record_offset, first.declared_size, first.type.decode()),
                             (0, 0x10F3A, "BOOT"))
            self.assertEqual((nested.record_offset, nested.declared_size, nested.type.decode()),
                             (0x10EDA, 0x60, "BIMG"))

            chunks = [ChunkInfo() for _ in range(self.library.hiff_chunk_count(hiff))]
            for index, chunk in enumerate(chunks):
                self.assertEqual(self.library.hiff_chunk_at(hiff, index, ctypes.byref(chunk)), HIFF_OK)
            self.assertEqual(chunks[0].id.decode(), "BSUM")
            self.assertEqual(chunks[0].header_offset, 12)
            self.assertEqual(chunks[0].payload_size, 402)
            self.assertEqual(sum(chunk.data_index == 0 for chunk in chunks), 38)
            self.assertEqual(sum(chunk.data_index == 1 for chunk in chunks), 2)
            self.assertFalse(any(chunk.header_offset == nested.record_offset for chunk in chunks))

            self.assertEqual(self.library.hiff_select_data(hiff, b"BOOT"), HIFF_OK)
            body, data_info = selected_bytes(self.library, hiff, "hiff_get_selected_data")
            self.assertEqual((data_info.payload_offset, len(body)), (12, 0x10F3A - 4))
            self.assertEqual(body[:4], b"BSUM")
            self.assertEqual(self.library.hiff_select_chunk(hiff, b"CD"), HIFF_OK)
            cd_payload, cd_info = selected_bytes(self.library, hiff, "hiff_get_selected_chunk")
            self.assertEqual((cd_info.name.decode(), len(cd_payload)), ("CD", 153))
            self.assertEqual(selected_bytes(self.library, hiff, "hiff_get_selected_data")[0], body)
        finally:
            self.library.hiff_close(hiff)

    @unittest.skipUnless(TOOL_PATH.is_file() and BOOT_PATH.is_file(), "HIFF tool or boot fixture unavailable")
    def test_cli_lists_decoded_boot_as_json(self) -> None:
        result = subprocess.run(
            [str(TOOL_PATH), "list", str(BOOT_PATH)],
            check=True,
            text=True,
            capture_output=True,
        )
        document = json.loads(result.stdout)
        self.assertEqual(document["input_size"], 69442)
        self.assertEqual(document["data_count"], 2)
        self.assertEqual(document["chunk_count"], 40)
        self.assertEqual(document["data"][1]["type"], "BIMG")

    @unittest.skipUnless(RESOURCE_MANIFEST.is_file(), "decoded DATA resource corpus is unavailable")
    def test_decoded_resource_corpus_indexes_without_bounds_failures(self) -> None:
        manifest = json.loads(RESOURCE_MANIFEST.read_text(encoding="utf-8"))
        resources = manifest["resources"]
        total_records = 0
        total_chunks = 0
        indexed_resources = 0
        for resource in resources:
            with self.subTest(name=resource["name"], index=resource["index"]):
                raw = Path(resource["path"]).read_bytes()
                hiff, _, error = open_hiff(self.library, raw)
                self.assertTrue(hiff, error.value.decode("ascii", errors="replace"))
                try:
                    data_count = self.library.hiff_data_count(hiff)
                    total_records += data_count
                    total_chunks += self.library.hiff_chunk_count(hiff)
                    indexed_resources += data_count > 0
                finally:
                    self.library.hiff_close(hiff)
        self.assertEqual(len(resources), 2267)
        self.assertEqual(indexed_resources, 2082)
        self.assertEqual(total_records, 2083)
        self.assertEqual(total_chunks, 21733)


if __name__ == "__main__":
    unittest.main()
