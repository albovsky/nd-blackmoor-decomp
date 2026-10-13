"""Regression tests for the portable CIF archive library.

Build the native library first, or set ``CIF_ARCHIVE_LIBRARY`` to its path.
The tests use only synthetic bytes and never open or modify the supplied game.
"""

from __future__ import annotations

import ctypes
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
RING_SIZE = 4096
RING_INITIALIZED = 4078
TREE_HEADER_SIZE = 32
HASH_TABLE_SIZE = 2048
ENTRY_SIZE = 94
TREE_PREFIX_SIZE = TREE_HEADER_SIZE + HASH_TABLE_SIZE
CIF_HEADER_SIZE = 81

CIF_OK = 0
CIF_ERR_FORMAT = 4
CIF_ERR_UNSUPPORTED = 5
CIF_ERR_MALFORMED = 8
CIF_ERR_OUTPUT_SIZE = 9


class DecodeContext(ctypes.Structure):
    _fields_ = [("ring", ctypes.c_uint8 * RING_SIZE)]


class EntryInfo(ctypes.Structure):
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


def library_candidates() -> list[Path]:
    override = os.environ.get("CIF_ARCHIVE_LIBRARY")
    if override:
        return [Path(override).expanduser().resolve()]
    build = PROJECT / "build"
    return [
        build / "libcifarchive.dylib",
        build / "libcif_archive.dylib",
        build / "libcif_archive.so",
        build / "cif_archive.dylib",
        build / "cif_archive.so",
        build / "cif_archive.dll",
        build / "libcif_archive.dll",
    ]


def load_library() -> ctypes.CDLL:
    for candidate in library_candidates():
        if candidate.is_file():
            library = ctypes.CDLL(str(candidate))
            bind_library(library)
            return library
    candidates = ", ".join(str(path) for path in library_candidates())
    raise unittest.SkipTest(
        "CIF archive library is not built; expected one of: " + candidates
    )


def bind_library(library: ctypes.CDLL) -> None:
    context_ptr = ctypes.POINTER(DecodeContext)
    size_ptr = ctypes.POINTER(ctypes.c_size_t)
    byte_ptr = ctypes.POINTER(ctypes.c_uint8)
    char_ptr = ctypes.POINTER(ctypes.c_char)

    library.cif_decode_context_init.argtypes = [context_ptr]
    library.cif_decode_context_init.restype = None
    library.cif_decode.argtypes = [
        context_ptr,
        byte_ptr,
        ctypes.c_size_t,
        byte_ptr,
        ctypes.c_size_t,
        size_ptr,
        size_ptr,
    ]
    library.cif_decode.restype = ctypes.c_int
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
        ctypes.POINTER(EntryInfo),
    ]
    library.cif_tree_entry_at.restype = ctypes.c_int
    library.cif_tree_find.argtypes = [
        ctypes.c_void_p,
        ctypes.c_char_p,
        size_ptr,
    ]
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


def encode_stream(tokens: list[tuple]) -> bytes:
    """Encode literal/match tokens using the game's incrementing byte counter."""

    plain = bytearray()
    for start in range(0, len(tokens), 8):
        group = tokens[start : start + 8]
        flags = 0
        for bit, token in enumerate(group):
            if token[0] == "literal":
                flags |= 1 << bit
        plain.append(flags)
        for token in group:
            if token[0] == "literal":
                plain.append(token[1] & 0xFF)
            elif token[0] == "match":
                _, offset, length = token
                if not (0 <= offset < RING_SIZE and 3 <= length <= 18):
                    raise ValueError("match offset or length is outside the format")
                plain.append(offset & 0xFF)
                plain.append(((offset >> 4) & 0xF0) | (length - 3))
            else:
                raise ValueError(f"unknown token kind: {token[0]}")

    encoded = bytearray()
    counter = 0
    for value in plain:
        encoded.append((value + counter) & 0xFF)
        counter = (counter + 1) & 0xFF
    return bytes(encoded)


def encode_literals(data: bytes) -> bytes:
    return encode_stream([("literal", value) for value in data])


def expected_bucket(name: bytes) -> int:
    return sum(name) & 0x3FF


def make_entry(
    name: bytes,
    *,
    data_offset: int,
    compressed_size: int,
    output_size: int,
    resource_type: int = 3,
    next_index: int = 0xFFFF,
) -> bytes:
    if len(name) >= 33 or b"\0" in name:
        raise ValueError("synthetic archive names must fit the 33-byte C string field")
    entry = bytearray(ENTRY_SIZE)
    entry[: len(name)] = name
    entry[33:35] = (7).to_bytes(2, "little")
    entry[35:39] = data_offset.to_bytes(4, "little")
    entry[39:41] = next_index.to_bytes(2, "little")
    entry[81:85] = output_size.to_bytes(4, "little")
    entry[89:93] = compressed_size.to_bytes(4, "little")
    entry[93] = resource_type
    return bytes(entry)


def make_archive(
    name: bytes = b"TEST.DAT",
    *,
    compressed: bytes | None = None,
    output: bytes = b"ok",
    resource_type: int = 3,
    version: tuple[int, int] = (2, 1),
    next_index: int = 0xFFFF,
    data_offset: int | None = None,
    bucket_slot: int | None = None,
    bucket_item: int = 0,
    raw_name: bytes | None = None,
) -> bytes:
    if compressed is None:
        compressed = encode_literals(output)
    payload_offset = TREE_PREFIX_SIZE + ENTRY_SIZE
    if data_offset is None:
        data_offset = payload_offset

    header = bytearray(TREE_HEADER_SIZE)
    header[:20] = b"CIF TREE WayneSikes\0"
    header[24:26] = version[0].to_bytes(2, "little")
    header[26:28] = version[1].to_bytes(2, "little")
    header[28:30] = (1).to_bytes(2, "little")

    buckets = bytearray(b"\xff" * HASH_TABLE_SIZE)
    if bucket_slot is None:
        bucket_slot = expected_bucket(name)
    buckets[bucket_slot * 2 : bucket_slot * 2 + 2] = bucket_item.to_bytes(2, "little")

    record_name = name if raw_name is None else raw_name
    entry = make_entry(
        record_name,
        data_offset=data_offset,
        compressed_size=len(compressed),
        output_size=len(output),
        resource_type=resource_type,
        next_index=next_index,
    )
    archive = bytearray(header + buckets + entry)
    if data_offset <= len(archive):
        archive.extend(b"\0" * (data_offset - len(archive)))
        archive.extend(compressed)
    return bytes(archive)


class CifLibraryTestCase(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.library = load_library()

    def make_context(self) -> DecodeContext:
        context = DecodeContext()
        self.library.cif_decode_context_init(ctypes.byref(context))
        return context

    def decode(
        self,
        context: DecodeContext,
        compressed: bytes,
        output_capacity: int,
    ) -> tuple[int, bytes, int, int]:
        compressed_array = (
            (ctypes.c_uint8 * len(compressed)).from_buffer_copy(compressed)
            if compressed
            else None
        )
        output_array = (ctypes.c_uint8 * max(1, output_capacity))()
        written = ctypes.c_size_t(999)
        consumed = ctypes.c_size_t(999)
        status = self.library.cif_decode(
            ctypes.byref(context),
            compressed_array,
            len(compressed),
            output_array if output_capacity else None,
            output_capacity,
            ctypes.byref(written),
            ctypes.byref(consumed),
        )
        return (
            status,
            bytes(output_array[: written.value]),
            written.value,
            consumed.value,
        )

    def open_tree(self, archive: bytes) -> tuple[int | None, ctypes.Array]:
        source = (ctypes.c_uint8 * len(archive)).from_buffer_copy(archive)
        error = ctypes.create_string_buffer(256)
        tree = self.library.cif_tree_open_memory(
            ctypes.cast(source, ctypes.c_void_p), len(archive), error, len(error)
        )
        return tree, error


class TestCifDecoder(CifLibraryTestCase):
    def test_literal_stream_wraps_the_byte_counter(self) -> None:
        expected = bytes((index * 37 + 0x80) & 0xFF for index in range(260))
        compressed = encode_literals(expected)
        self.assertGreater(len(compressed), 256)

        status, actual, written, consumed = self.decode(
            self.make_context(), compressed, len(expected)
        )

        self.assertEqual(status, CIF_OK)
        self.assertEqual(actual, expected)
        self.assertEqual(written, len(expected))
        self.assertEqual(consumed, len(compressed))

    def test_overlapping_backreference_copies_forward(self) -> None:
        compressed = encode_stream(
            [("literal", ord("A")), ("match", RING_INITIALIZED, 18)]
        )

        status, actual, written, consumed = self.decode(
            self.make_context(), compressed, 19
        )

        self.assertEqual(status, CIF_OK)
        self.assertEqual(actual, b"A" * 19)
        self.assertEqual(written, 19)
        self.assertEqual(consumed, len(compressed))

    def test_backreference_source_and_destination_wrap_ring(self) -> None:
        seed = bytes(range(30))
        compressed = encode_stream(
            [("literal", value) for value in seed] + [("match", 4090, 18)]
        )

        status, actual, written, consumed = self.decode(
            self.make_context(), compressed, 48
        )

        self.assertEqual(status, CIF_OK)
        self.assertEqual(actual, seed + seed[12:30])
        self.assertEqual(written, 48)
        self.assertEqual(consumed, len(compressed))

    def test_last_18_ring_bytes_persist_between_calls(self) -> None:
        context = self.make_context()
        seed = b"0123456789ABCDEFGH"
        first = encode_literals(seed)
        status, actual, written, consumed = self.decode(context, first, len(seed))
        self.assertEqual((status, actual, written, consumed), (CIF_OK, seed, 18, len(first)))

        second = encode_stream([("match", RING_INITIALIZED, 18)])
        status, actual, written, consumed = self.decode(context, second, 18)

        self.assertEqual(status, CIF_OK)
        self.assertEqual(actual, seed)
        self.assertEqual(written, 18)
        self.assertEqual(consumed, len(second))

    def test_truncated_backreference_is_malformed(self) -> None:
        # One control byte and one encoded pair byte; the second pair byte is absent.
        compressed = bytes((0, 0xEF))

        status, actual, written, consumed = self.decode(
            self.make_context(), compressed, 3
        )

        self.assertEqual(status, CIF_ERR_MALFORMED)
        self.assertEqual(actual, b"")
        self.assertEqual(written, 0)
        self.assertEqual(consumed, len(compressed))

    def test_output_overflow_is_rejected_before_consuming_next_literal(self) -> None:
        compressed = encode_literals(b"AB")

        status, actual, written, consumed = self.decode(
            self.make_context(), compressed, 1
        )

        self.assertEqual(status, CIF_ERR_OUTPUT_SIZE)
        self.assertEqual(actual, b"A")
        self.assertEqual(written, 1)
        self.assertEqual(consumed, 2)  # flag plus the first literal

    def test_output_underflow_is_reported_as_malformed(self) -> None:
        compressed = encode_literals(b"A")

        status, actual, written, consumed = self.decode(
            self.make_context(), compressed, 2
        )

        self.assertEqual(status, CIF_ERR_MALFORMED)
        self.assertEqual(actual, b"A")
        self.assertEqual(written, 1)
        self.assertEqual(consumed, len(compressed))

    def test_reference_that_exceeds_output_capacity_is_rejected_atomically(self) -> None:
        compressed = encode_stream([("match", RING_INITIALIZED, 18)])

        status, actual, written, consumed = self.decode(
            self.make_context(), compressed, 17
        )

        self.assertEqual(status, CIF_ERR_OUTPUT_SIZE)
        self.assertEqual(actual, b"")
        self.assertEqual(written, 0)
        self.assertEqual(consumed, len(compressed))


class TestCifArchive(CifLibraryTestCase):
    def test_case_insensitive_lookup_and_extraction(self) -> None:
        expected = b"synthetic resource"
        archive = make_archive(name=b"TEST.DAT", output=expected)
        tree, error = self.open_tree(archive)
        self.assertTrue(tree, error.value.decode("ascii", "replace"))
        assert tree is not None
        try:
            self.assertEqual(self.library.cif_tree_entry_count(tree), 1)
            index = ctypes.c_size_t(99)
            status = self.library.cif_tree_find(tree, b"test.dat", ctypes.byref(index))
            self.assertEqual(status, CIF_OK)
            self.assertEqual(index.value, 0)

            entry = EntryInfo()
            self.assertEqual(
                self.library.cif_tree_entry_at(tree, 0, ctypes.byref(entry)), CIF_OK
            )
            self.assertEqual(entry.name, b"TEST.DAT")
            self.assertEqual(entry.output_size, len(expected))
            self.assertEqual(entry.compressed_size, len(encode_literals(expected)))
            self.assertEqual(entry.type, 3)

            context = self.make_context()
            output = (ctypes.c_uint8 * len(expected))()
            written = ctypes.c_size_t()
            consumed = ctypes.c_size_t()
            status = self.library.cif_tree_extract(
                tree,
                index.value,
                ctypes.byref(context),
                output,
                len(expected),
                ctypes.byref(written),
                ctypes.byref(consumed),
            )
            self.assertEqual(status, CIF_OK)
            self.assertEqual(bytes(output), expected)
            self.assertEqual(written.value, len(expected))
            self.assertEqual(consumed.value, len(encode_literals(expected)))
        finally:
            self.library.cif_tree_close(tree)

    def assert_archive_rejected(self, archive: bytes) -> str:
        tree, error = self.open_tree(archive)
        if tree:
            self.library.cif_tree_close(tree)
        self.assertFalse(tree, error.value.decode("ascii", "replace"))
        return error.value.decode("ascii", "replace")

    def test_wrong_tree_version_is_rejected(self) -> None:
        message = self.assert_archive_rejected(
            make_archive(version=(2, 2), output=b"x")
        )
        self.assertIn("version", message.lower())

    def test_cyclic_hash_chain_is_rejected(self) -> None:
        message = self.assert_archive_rejected(
            make_archive(name=b"CYCLE", next_index=0, output=b"x")
        )
        self.assertIn("cycle", message.lower())

    def test_hash_head_outside_entry_table_is_rejected(self) -> None:
        message = self.assert_archive_rejected(
            make_archive(name=b"INDEX", bucket_item=1, output=b"x")
        )
        self.assertIn("out-of-range", message.lower())

    def test_payload_range_past_archive_is_rejected(self) -> None:
        message = self.assert_archive_rejected(
            make_archive(name=b"BOUNDS", data_offset=0x100000, output=b"x")
        )
        self.assertIn("payload", message.lower())

    def test_high_bit_entry_name_is_rejected(self) -> None:
        message = self.assert_archive_rejected(
            make_archive(name=b"ASCII", raw_name=b"N\x80ME", output=b"x")
        )
        self.assertIn("ASCII", message)

    def test_high_bit_lookup_name_is_unsupported(self) -> None:
        tree, error = self.open_tree(make_archive(name=b"ASCII", output=b"x"))
        self.assertTrue(tree, error.value.decode("ascii", "replace"))
        assert tree is not None
        try:
            index = ctypes.c_size_t()
            self.assertEqual(
                self.library.cif_tree_find(tree, b"N\x80ME", ctypes.byref(index)),
                CIF_ERR_UNSUPPORTED,
            )
        finally:
            self.library.cif_tree_close(tree)

    def test_extractor_rejects_short_output_buffer(self) -> None:
        tree, error = self.open_tree(make_archive(name=b"BUF", output=b"payload"))
        self.assertTrue(tree, error.value.decode("ascii", "replace"))
        assert tree is not None
        try:
            index = ctypes.c_size_t()
            self.assertEqual(
                self.library.cif_tree_find(tree, b"BUF", ctypes.byref(index)), CIF_OK
            )
            context = self.make_context()
            output = (ctypes.c_uint8 * 1)()
            written = ctypes.c_size_t()
            consumed = ctypes.c_size_t()
            self.assertEqual(
                self.library.cif_tree_extract(
                    tree,
                    index.value,
                    ctypes.byref(context),
                    output,
                    len(output),
                    ctypes.byref(written),
                    ctypes.byref(consumed),
                ),
                CIF_ERR_OUTPUT_SIZE,
            )
            self.assertEqual(written.value, 0)
            self.assertEqual(consumed.value, 0)
        finally:
            self.library.cif_tree_close(tree)

    def test_standalone_cif_version_and_payload(self) -> None:
        expected = b"standalone"
        compressed = encode_literals(expected)
        cif = bytearray(CIF_HEADER_SIZE + len(compressed))
        cif[:20] = b"CIF FILE WayneSikes\0"
        cif[24:26] = (2).to_bytes(2, "little")
        cif[26:28] = (1).to_bytes(2, "little")
        cif[67] = 2
        cif[68:72] = len(expected).to_bytes(4, "little")
        cif[76:80] = len(compressed).to_bytes(4, "little")
        cif[80] = 3
        cif[CIF_HEADER_SIZE:] = compressed

        context = self.make_context()
        file_buffer = (ctypes.c_uint8 * len(cif)).from_buffer_copy(cif)
        output = (ctypes.c_uint8 * len(expected))()
        required = ctypes.c_size_t()
        written = ctypes.c_size_t()
        consumed = ctypes.c_size_t()
        status = self.library.cif_decode_cif_memory(
            ctypes.byref(context),
            ctypes.cast(file_buffer, ctypes.c_void_p),
            len(cif),
            output,
            len(expected),
            ctypes.byref(required),
            ctypes.byref(written),
            ctypes.byref(consumed),
        )
        self.assertEqual(status, CIF_OK)
        self.assertEqual(required.value, len(expected))
        self.assertEqual(bytes(output), expected)
        self.assertEqual(written.value, len(expected))
        self.assertEqual(consumed.value, len(compressed))

        file_buffer[24] = 3
        file_buffer[25] = 0
        status = self.library.cif_decode_cif_memory(
            ctypes.byref(context),
            ctypes.cast(file_buffer, ctypes.c_void_p),
            len(cif),
            output,
            len(expected),
            ctypes.byref(required),
            ctypes.byref(written),
            ctypes.byref(consumed),
        )
        self.assertEqual(status, CIF_ERR_FORMAT)

    def test_cli_refuses_to_overwrite_an_existing_output(self) -> None:
        executable = PROJECT / "build" / "ciftool"
        if not executable.is_file():
            self.skipTest("ciftool is not built")

        with tempfile.TemporaryDirectory(prefix="cif-archive-test-") as temp_dir:
            temp_path = Path(temp_dir)
            archive_path = temp_path / "synthetic.dat"
            output_path = temp_path / "existing.bin"
            archive_path.write_bytes(make_archive(name=b"TEST.DAT", output=b"new"))
            sentinel = b"preserve existing contents"
            output_path.write_bytes(sentinel)

            result = subprocess.run(
                [str(executable), "extract", str(archive_path), "test.dat", str(output_path)],
                capture_output=True,
                check=False,
            )

            self.assertNotEqual(result.returncode, 0)
            self.assertIn(b"already exists", result.stderr.lower())
            self.assertEqual(output_path.read_bytes(), sentinel)


if __name__ == "__main__":
    unittest.main()
