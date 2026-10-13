"""Tests for bounded original New Game startup inputs in BOOT."""

from __future__ import annotations

import ctypes
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
LIBRARY = PROJECT / "build/libengineboot.dylib"
REAL_BOOT = ROOT / "work/analysis/cif-boot-native.bin"

ENGINE_BOOT_OK = 0
ENGINE_BOOT_ERR_ARGUMENT = 1
ENGINE_BOOT_ERR_FORMAT = 3
ENGINE_BOOT_ERR_BOUNDS = 4
ENGINE_BOOT_ERR_NOT_FOUND = 5
BSUM_SIZE = 402
UICL_TABLE_OFFSET = 0xDA1
PHONE_ROW_SIZE = 41


class EngineBootStartupSettings(ctypes.Structure):
    _fields_ = [
        ("ordinary_initial_scene", ctypes.c_int16),
        ("ordinary_coordinate_word_a", ctypes.c_int16),
        ("ordinary_coordinate_word_b", ctypes.c_int16),
        ("alternate_initial_scene", ctypes.c_int16),
        ("alternate_coordinate_word_a", ctypes.c_int16),
        ("alternate_coordinate_word_b", ctypes.c_int16),
        ("initial_hour", ctypes.c_int16),
        ("initial_minute", ctypes.c_int16),
        ("first_day_event_hour", ctypes.c_int16),
        ("first_day_event_flag_id", ctypes.c_int16),
        ("clock_update_interval_ms", ctypes.c_int16),
    ]


def build_native_library() -> None:
    result = subprocess.run(
        [str(PROJECT / "scripts/build_boottool.sh")],
        check=False,
        text=True,
        capture_output=True,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr or result.stdout)


def load_library() -> ctypes.CDLL:
    build_native_library()
    library = ctypes.CDLL(str(LIBRARY))
    char_ptr = ctypes.POINTER(ctypes.c_char)
    byte_ptr = ctypes.POINTER(ctypes.c_uint8)
    size_ptr = ctypes.POINTER(ctypes.c_size_t)

    library.engine_boot_open_memory.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        char_ptr,
        ctypes.c_size_t,
    ]
    library.engine_boot_open_memory.restype = ctypes.c_void_p
    library.engine_boot_close.argtypes = [ctypes.c_void_p]
    library.engine_boot_close.restype = None
    library.engine_boot_get_startup_settings.argtypes = [
        ctypes.c_void_p,
        ctypes.POINTER(EngineBootStartupSettings),
    ]
    library.engine_boot_get_startup_settings.restype = ctypes.c_int
    library.engine_boot_get_phone_count.argtypes = [
        ctypes.c_void_p,
        size_ptr,
    ]
    library.engine_boot_get_phone_count.restype = ctypes.c_int
    library.engine_boot_phone_row_at.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        byte_ptr,
    ]
    library.engine_boot_phone_row_at.restype = ctypes.c_int
    return library


def make_chunk(identifier: bytes, payload: bytes) -> bytes:
    if len(identifier) != 4:
        raise ValueError("HIFF chunk identifiers are exactly four bytes")
    return (
        identifier
        + len(payload).to_bytes(4, "big")
        + payload
        + (b"\0" if len(payload) & 1 else b"")
    )


def make_data(data_type: bytes, contents: bytes) -> bytes:
    if len(data_type) != 4:
        raise ValueError("HIFF DATA types are exactly four bytes")
    declared_size = len(data_type) + len(contents)
    return b"DATA" + declared_size.to_bytes(4, "big") + data_type + contents


def make_boot(*, bsum: bytes | None = None, uicl: bytes | None = None) -> bytes:
    summary = bytearray(BSUM_SIZE) if bsum is None else bytearray(bsum)
    chunks = [make_chunk(b"BSUM", bytes(summary))]
    if uicl is not None:
        chunks.append(make_chunk(b"UICL", uicl))
    return make_data(b"BOOT", b"".join(chunks))


def make_uicl(count: int, *, size: int | None = None) -> bytes:
    required = UICL_TABLE_OFFSET + max(count, 0) * PHONE_ROW_SIZE
    payload = bytearray(required if size is None else size)
    if len(payload) >= UICL_TABLE_OFFSET:
        payload[0xD9F:0xDA1] = int(count).to_bytes(2, "little", signed=True)
    for index in range(max(count, 0)):
        start = UICL_TABLE_OFFSET + index * PHONE_ROW_SIZE
        end = start + PHONE_ROW_SIZE
        if end <= len(payload):
            payload[start:end] = bytes((index,)) * PHONE_ROW_SIZE
    return bytes(payload)


class EngineBootStartupInputTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.library = load_library()

    def open_boot(self, data: bytes) -> tuple[int, ctypes.Array]:
        source = (ctypes.c_uint8 * len(data)).from_buffer_copy(data)
        error = ctypes.create_string_buffer(256)
        boot = self.library.engine_boot_open_memory(
            ctypes.cast(source, ctypes.c_void_p), len(data), error, len(error)
        )
        self.assertTrue(boot, error.value.decode("utf-8", "replace"))
        return boot, source

    def phone_count(self, boot: int) -> tuple[int, int]:
        count = ctypes.c_size_t()
        status = self.library.engine_boot_get_phone_count(boot, ctypes.byref(count))
        return status, count.value

    def test_real_boot_exposes_startup_defaults_and_all_twelve_source_rows(self) -> None:
        if not REAL_BOOT.is_file():
            self.skipTest(f"decoded original BOOT is unavailable: {REAL_BOOT}")
        boot, _owner = self.open_boot(REAL_BOOT.read_bytes())
        try:
            settings = EngineBootStartupSettings()
            self.assertEqual(
                self.library.engine_boot_get_startup_settings(
                    boot, ctypes.byref(settings)
                ),
                ENGINE_BOOT_OK,
            )
            self.assertEqual(
                tuple(getattr(settings, name) for name, _field_type in settings._fields_),
                (0, 0, 0, 8000, 0, 0, 18, 0, 3, 1668, 20000),
            )

            self.assertEqual(self.phone_count(boot), (ENGINE_BOOT_OK, 12))
            expected_fields = [
                (0x000A, "0105020305050509070001", "Mrs. Petrov", "40060100ffff0000"),
                (0x000B, "0005020305050509070001", "Mrs. Petrov", "40060100ffff0000"),
                (0x000B, "0000000005050509070001", "Mrs. Petrov", "40060100ffff0000"),
                (0x000A, "0105020305050503070309", "Home", "3c190100ffff0000"),
                (0x000B, "0502030505050307030900", "Home", "3c190100ffff0000"),
                (0x000B, "0505050307030900000000", "Home", "3c190100ffff0000"),
                (0x000A, "0105020305050504030507", "Ned Nickerson", "a4060100ffff0000"),
                (0x000B, "0005020305050504030507", "Ned Nickerson", "a4060100ffff0000"),
                (0x000B, "0000000005050504030507", "Ned Nickerson", "dc050100ffff0000"),
                (0x000B, "0105020305050509040008", "Paliki Vadas", "a4060100ffff0000"),
                (0x000B, "0005020305050509040008", "Paliki Vadas", "b2070100ffff0000"),
                (0x000B, "0000000005050509040008", "Paliki Vadas", "b2070100ffff0000"),
            ]
            for index, (kind, key_hex, name, tail_hex) in enumerate(expected_fields):
                raw = (ctypes.c_uint8 * PHONE_ROW_SIZE)()
                self.assertEqual(
                    self.library.engine_boot_phone_row_at(boot, index, raw),
                    ENGINE_BOOT_OK,
                )
                row = bytes(raw)
                self.assertEqual(int.from_bytes(row[:2], "little"), kind)
                self.assertEqual(row[2:13].hex(), key_hex)
                self.assertEqual(row[13:33].split(b"\0", 1)[0].decode(), name)
                self.assertEqual(row[33:41].hex(), tail_hex)

            raw = (ctypes.c_uint8 * PHONE_ROW_SIZE)()
            self.assertEqual(
                self.library.engine_boot_phone_row_at(boot, 12, raw),
                ENGINE_BOOT_ERR_NOT_FOUND,
            )
        finally:
            self.library.engine_boot_close(boot)

    def test_startup_settings_preserve_signed_words(self) -> None:
        bsum = bytearray(BSUM_SIZE)
        for offset, value in (
            (221, -4),
            (223, -2),
            (225, 7),
            (235, -8),
            (237, 9),
            (239, -10),
            (227, -11),
            (229, 12),
            (231, -13),
            (233, -1),
            (365, -15),
        ):
            bsum[offset : offset + 2] = value.to_bytes(2, "little", signed=True)
        boot, _owner = self.open_boot(make_boot(bsum=bytes(bsum)))
        try:
            settings = EngineBootStartupSettings()
            self.assertEqual(
                self.library.engine_boot_get_startup_settings(
                    boot, ctypes.byref(settings)
                ),
                ENGINE_BOOT_OK,
            )
            self.assertEqual(
                tuple(getattr(settings, name) for name, _field_type in settings._fields_),
                (-4, -2, 7, -8, 9, -10, -11, 12, -13, -1, -15),
            )
        finally:
            self.library.engine_boot_close(boot)

    def test_phone_table_rejects_short_negative_and_payload_overrun(self) -> None:
        cases = [
            (b"\0" * (UICL_TABLE_OFFSET - 1), ENGINE_BOOT_ERR_BOUNDS),
            (make_uicl(-1), ENGINE_BOOT_ERR_FORMAT),
            (make_uicl(13, size=3981), ENGINE_BOOT_ERR_BOUNDS),
        ]
        for payload, expected_status in cases:
            with self.subTest(payload_size=len(payload), expected=expected_status):
                boot, _owner = self.open_boot(make_boot(uicl=payload))
                try:
                    status, _count = self.phone_count(boot)
                    self.assertEqual(status, expected_status)
                    raw = (ctypes.c_uint8 * PHONE_ROW_SIZE)()
                    self.assertEqual(
                        self.library.engine_boot_phone_row_at(boot, 0, raw),
                        expected_status,
                    )
                finally:
                    self.library.engine_boot_close(boot)

    def test_phone_getters_ignore_uicl_in_foreign_data_record(self) -> None:
        valid_uicl = make_uicl(1)
        raw = (
            make_data(b"BOOT", make_chunk(b"BSUM", bytes(BSUM_SIZE)))
            + make_data(b"OTHR", make_chunk(b"UICL", valid_uicl))
        )
        boot, _owner = self.open_boot(raw)
        try:
            self.assertEqual(self.phone_count(boot), (ENGINE_BOOT_ERR_NOT_FOUND, 0))
            row = (ctypes.c_uint8 * PHONE_ROW_SIZE)()
            self.assertEqual(
                self.library.engine_boot_phone_row_at(boot, 0, row),
                ENGINE_BOOT_ERR_NOT_FOUND,
            )
        finally:
            self.library.engine_boot_close(boot)

    def test_getters_reject_null_arguments(self) -> None:
        self.assertEqual(
            self.library.engine_boot_get_startup_settings(None, None),
            ENGINE_BOOT_ERR_ARGUMENT,
        )
        self.assertEqual(
            self.library.engine_boot_get_phone_count(None, None),
            ENGINE_BOOT_ERR_ARGUMENT,
        )
        boot, _owner = self.open_boot(make_boot(uicl=make_uicl(0)))
        try:
            self.assertEqual(
                self.library.engine_boot_get_phone_count(boot, None),
                ENGINE_BOOT_ERR_ARGUMENT,
            )
            self.assertEqual(
                self.library.engine_boot_phone_row_at(boot, 0, None),
                ENGINE_BOOT_ERR_ARGUMENT,
            )
        finally:
            self.library.engine_boot_close(boot)


if __name__ == "__main__":
    unittest.main()
