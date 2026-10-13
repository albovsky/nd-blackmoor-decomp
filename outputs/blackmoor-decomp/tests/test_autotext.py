"""Tests for the bounded native AUTOTEXT parser and lookup index."""

from __future__ import annotations

import ctypes
import json
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
WORKSPACE = PROJECT.parents[1]
LIBRARY_PATH = PROJECT / "build/libautotext.dylib"
BUILD_SCRIPT = PROJECT / "scripts/build_autotext.sh"
RESOURCE_MANIFEST = WORKSPACE / "work/analysis/hiff-resources.json"

AUTOTEXT_OK = 0
AUTOTEXT_ERR_FORMAT = 3
AUTOTEXT_ERR_BOUNDS = 4
AUTOTEXT_ERR_UNSUPPORTED = 5
AUTOTEXT_ERR_NOT_FOUND = 6
AUTOTEXT_KEY_BYTES = 33


def make_chunk(identifier: bytes, payload: bytes) -> bytes:
    if len(identifier) != 4:
        raise ValueError("chunk identifiers must be four bytes")
    padded = payload + (b"\0" if len(payload) & 1 else b"")
    return identifier + len(payload).to_bytes(4, "big") + padded


def make_data(data_type: bytes, contents: bytes) -> bytes:
    if len(data_type) != 4:
        raise ValueError("DATA type must be four bytes")
    return b"DATA" + (4 + len(contents)).to_bytes(4, "big") + data_type + contents


def make_cvtx(entries: list[tuple[bytes, bytes]]) -> bytes:
    if len(entries) > 0xFFFF:
        raise ValueError("CVTX count exceeds uint16")
    payload = bytearray(len(entries).to_bytes(2, "little"))
    for key, raw_value in entries:
        if len(key) >= AUTOTEXT_KEY_BYTES or b"\0" in key:
            raise ValueError("fixture keys must fit a 33-byte NUL-terminated field")
        if len(raw_value) > 0xFFFF:
            raise ValueError("fixture value exceeds uint16 length")
        payload.extend(key + bytes(AUTOTEXT_KEY_BYTES - len(key)))
        payload.extend(len(raw_value).to_bytes(2, "little"))
        payload.extend(raw_value)
    return make_data(b"TEXT", make_chunk(b"CVTX", bytes(payload)))


def parse_cvtx(resource: bytes) -> list[dict[str, bytes | int]]:
    if len(resource) < 20 or resource[:4] != b"DATA" or resource[8:12] != b"TEXT":
        raise AssertionError("fixture is not a complete TEXT DATA record")
    declared_data_length = int.from_bytes(resource[4:8], "big")
    if declared_data_length + 8 != len(resource):
        raise AssertionError("TEXT DATA length mismatch")
    offset = 12
    cvtx: bytes | None = None
    while offset < len(resource):
        if len(resource) - offset < 8:
            raise AssertionError("truncated chunk header")
        identifier = resource[offset : offset + 4]
        length = int.from_bytes(resource[offset + 4 : offset + 8], "big")
        start = offset + 8
        end = start + length
        padded_end = end + (length & 1)
        if padded_end > len(resource):
            raise AssertionError("chunk exceeds DATA bounds")
        if identifier == b"CVTX":
            if cvtx is not None:
                raise AssertionError("multiple CVTX chunks")
            cvtx = resource[start:end]
        offset = padded_end
    if cvtx is None or len(cvtx) < 2:
        raise AssertionError("missing CVTX chunk")

    count = int.from_bytes(cvtx[:2], "little")
    offset = 2
    result: list[dict[str, bytes | int]] = []
    for index in range(count):
        if len(cvtx) - offset < 35:
            raise AssertionError(f"truncated CVTX record {index}")
        key_field = cvtx[offset : offset + 33]
        key_end = key_field.find(b"\0")
        if key_end < 0:
            raise AssertionError(f"unterminated CVTX key {index}")
        length = int.from_bytes(cvtx[offset + 33 : offset + 35], "little")
        value_start = offset + 35
        value_end = value_start + length
        if value_end > len(cvtx):
            raise AssertionError(f"CVTX value {index} exceeds payload bounds")
        raw_value = cvtx[value_start:value_end]
        terminator = raw_value.find(b"\0")
        caption_length = length if terminator < 0 else terminator
        result.append(
            {
                "index": index,
                "key": key_field[:key_end],
                "key_field": key_field,
                "raw_value": raw_value,
                "raw_length": length,
                "caption_length": caption_length,
                "caption": raw_value[:caption_length],
            }
        )
        offset = value_end
    if offset != len(cvtx):
        raise AssertionError("CVTX count leaves trailing bytes")
    return result


def bind_library(library: ctypes.CDLL) -> None:
    byte_ptr = ctypes.POINTER(ctypes.c_uint8)
    size_ptr = ctypes.POINTER(ctypes.c_size_t)
    library.autotext_open_memory.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        ctypes.c_int,
        ctypes.POINTER(ctypes.c_void_p),
        ctypes.POINTER(ctypes.c_char),
        ctypes.c_size_t,
    ]
    library.autotext_open_memory.restype = ctypes.c_int
    library.autotext_close.argtypes = [ctypes.c_void_p]
    library.autotext_close.restype = None
    library.autotext_lookup.argtypes = [
        ctypes.c_void_p,
        byte_ptr,
        ctypes.c_size_t,
        ctypes.POINTER(byte_ptr),
        size_ptr,
        size_ptr,
    ]
    library.autotext_lookup.restype = ctypes.c_int
    library.autotext_entry_count.argtypes = [ctypes.c_void_p]
    library.autotext_entry_count.restype = ctypes.c_size_t


def open_resource(library: ctypes.CDLL, resource: bytes, nls_mode: int = 0):
    source = ctypes.create_string_buffer(resource)
    handle = ctypes.c_void_p()
    error = ctypes.create_string_buffer(256)
    status = library.autotext_open_memory(
        ctypes.cast(source, ctypes.c_void_p), len(resource), nls_mode,
        ctypes.byref(handle), error, len(error)
    )
    return status, handle, source, error.value.decode("ascii", "replace")


def lookup(library: ctypes.CDLL, handle: ctypes.c_void_p, key: bytes):
    key_buffer = (ctypes.c_uint8 * max(1, len(key))).from_buffer_copy(key or b"\0")
    value = ctypes.POINTER(ctypes.c_uint8)()
    raw_length = ctypes.c_size_t()
    caption_length = ctypes.c_size_t()
    status = library.autotext_lookup(
        handle,
        key_buffer,
        len(key),
        ctypes.byref(value),
        ctypes.byref(raw_length),
        ctypes.byref(caption_length),
    )
    raw = ctypes.string_at(value, raw_length.value) if value and raw_length.value else b""
    caption = raw[: caption_length.value]
    return status, raw, raw_length.value, caption_length.value, caption


class AutoTextTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        if not LIBRARY_PATH.is_file():
            result = subprocess.run(["sh", str(BUILD_SCRIPT)], capture_output=True, text=True, check=False)
            if result.returncode:
                raise unittest.SkipTest(f"could not build AUTOTEXT library: {result.stderr}")
        cls.library = ctypes.CDLL(str(LIBRARY_PATH))
        bind_library(cls.library)

    def test_actual_fixture_has_original_key_and_first_duplicate_wins(self) -> None:
        manifest = json.loads(RESOURCE_MANIFEST.read_text(encoding="utf-8"))
        record = next(item for item in manifest["resources"] if item["name"] == "AUTOTEXT")
        resource_path = WORKSPACE / "work/analysis/hiff-resources/0001.bin"
        resource = resource_path.read_bytes()
        entries = parse_cvtx(resource)
        status, handle, _source, error = open_resource(self.library, resource)
        self.assertEqual(status, AUTOTEXT_OK, error)
        try:
            self.assertEqual(self.library.autotext_entry_count(handle), len(entries))
            self.assertEqual(len(entries), 1257)
            self.assertEqual(len(resource), record["size"])

            nsht = next(entry for entry in entries if entry["key"] == b"NSHT01")
            for query in (b"NSHT01", b"nsht01"):
                status, raw, raw_length, caption_length, caption = lookup(self.library, handle, query)
                self.assertEqual(status, AUTOTEXT_OK)
                self.assertEqual(raw_length, nsht["raw_length"])
                self.assertEqual(caption_length, nsht["caption_length"])
                self.assertEqual(raw, nsht["raw_value"])
                self.assertEqual(caption, nsht["caption"])

            normalized: dict[bytes, list[dict[str, bytes | int]]] = {}
            for entry in entries:
                key = bytes(byte - 32 if 97 <= byte <= 122 else byte for byte in entry["key"])
                normalized.setdefault(key, []).append(entry)
            duplicates = [group for group in normalized.values() if len(group) > 1]
            self.assertEqual(len(duplicates), 1)
            first = duplicates[0][0]
            status, _raw, raw_length, caption_length, caption = lookup(
                self.library, handle, first["key"]
            )
            self.assertEqual(status, AUTOTEXT_OK)
            self.assertEqual(raw_length, first["raw_length"])
            self.assertEqual(caption_length, first["caption_length"])
            self.assertEqual(caption, first["caption"])
        finally:
            self.library.autotext_close(handle)

    def test_owner_keeps_source_copy_and_missing_key_is_reported(self) -> None:
        resource = (WORKSPACE / "work/analysis/hiff-resources/0001.bin").read_bytes()
        status, handle, source, error = open_resource(self.library, resource)
        self.assertEqual(status, AUTOTEXT_OK, error)
        try:
            ctypes.memset(ctypes.addressof(source), 0xA5, len(resource))
            status, _raw, _raw_length, _caption_length, _caption = lookup(
                self.library, handle, b"NSHT01"
            )
            self.assertEqual(status, AUTOTEXT_OK)
            status, raw, raw_length, caption_length, caption = lookup(
                self.library, handle, b"AUTOTEXT_MISSING_947"
            )
            self.assertEqual(status, AUTOTEXT_ERR_NOT_FOUND)
            self.assertEqual((raw, raw_length, caption_length, caption), (b"", 0, 0, b""))
        finally:
            self.library.autotext_close(handle)

    def test_embedded_nul_keeps_raw_payload_and_c_string_lengths_separate(self) -> None:
        resource = make_cvtx([(b"TXT01", b"A\0B"), (b"TXT02", b"\0tail")])
        status, handle, _source, error = open_resource(self.library, resource)
        self.assertEqual(status, AUTOTEXT_OK, error)
        try:
            status, raw, raw_length, caption_length, caption = lookup(self.library, handle, b"TXT01")
            self.assertEqual(status, AUTOTEXT_OK)
            self.assertEqual(raw, b"A\0B")
            self.assertEqual(raw_length, 3)
            self.assertEqual(caption_length, 1)
            self.assertEqual(caption, b"A")

            status, raw, raw_length, caption_length, caption = lookup(self.library, handle, b"TXT02")
            self.assertEqual(status, AUTOTEXT_OK)
            self.assertEqual(raw, b"\0tail")
            self.assertEqual(raw_length, 5)
            self.assertEqual(caption_length, 0)
            self.assertEqual(caption, b"")
        finally:
            self.library.autotext_close(handle)

    def test_nls_mode_is_explicitly_unsupported_and_leaves_output_null(self) -> None:
        resource = make_cvtx([(b"TXT01", b"caption")])
        status, handle, _source, _error = open_resource(self.library, resource, nls_mode=1)
        self.assertEqual(status, AUTOTEXT_ERR_UNSUPPORTED)
        self.assertFalse(handle.value)

    def test_malformed_record_header_and_unsafe_value_size_are_rejected(self) -> None:
        unterminated_key = b"A" * 33 + b"\0\0"
        malformed = make_data(b"TEXT", make_chunk(b"CVTX", b"\x01\x00" + unterminated_key))
        status, handle, _source, _error = open_resource(self.library, malformed)
        self.assertEqual(status, AUTOTEXT_ERR_FORMAT)
        self.assertFalse(handle.value)

        unsafe_value = b"\x01\x00" + b"TXT01" + bytes(28) + (40000).to_bytes(2, "little")
        unsafe_value += bytes(40000)
        malformed = make_data(b"TEXT", make_chunk(b"CVTX", unsafe_value))
        status, handle, _source, _error = open_resource(self.library, malformed)
        self.assertEqual(status, AUTOTEXT_ERR_UNSUPPORTED)
        self.assertFalse(handle.value)


if __name__ == "__main__":
    unittest.main()
