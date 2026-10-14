"""Native input-consumer boundary, alias, sanitizer, and oracle checks."""
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
WORK = ROOT / "work"
SOURCE = PROJECT / "src/input_consume.c"
HEADER_DIR = PROJECT / "src"
ORACLE = PROJECT / "tests/input_consume_original_oracle.py"
ORACLE_PYTHON = WORK / "tools/oracle-python/bin/python"
ORACLE_REPORT = PROJECT / "build/input_consume_original_oracle.json"


class InputLatchStateView(ctypes.Structure):
    _fields_ = [("bytes", ctypes.POINTER(ctypes.c_uint8)), ("length", ctypes.c_size_t)]


class InputConsumeNativeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.temporary = tempfile.TemporaryDirectory(prefix="s08-4-native-test-")
        library_path = Path(cls.temporary.name) / "libinput_consume.dylib"
        result = subprocess.run(
            [
                "xcrun", "clang", "-dynamiclib", "-std=c11", "-O2", "-Wall", "-Wextra",
                "-Werror", "-fno-stack-protector", "-I", str(HEADER_DIR), str(SOURCE),
                "-o", str(library_path),
            ],
            text=True,
            capture_output=True,
            check=False,
        )
        if result.returncode:
            raise AssertionError(result.stdout + result.stderr)
        cls.library = ctypes.CDLL(str(library_path))
        cls.functions = {}
        for name in ("input_consume_field0", "input_consume_field4"):
            function = getattr(cls.library, name)
            function.argtypes = [ctypes.POINTER(InputLatchStateView), ctypes.POINTER(ctypes.c_uint32)]
            function.restype = ctypes.c_int
            cls.functions[name] = function

    @classmethod
    def tearDownClass(cls) -> None:
        cls.temporary.cleanup()

    def make_view(self, storage: ctypes.Array, length: int | None = None) -> InputLatchStateView:
        pointer = ctypes.cast(ctypes.addressof(storage), ctypes.POINTER(ctypes.c_uint8))
        return InputLatchStateView(pointer, len(storage) if length is None else length)

    def invoke(self, method: str, data: bytes, length: int | None = None) -> tuple[int, int, bytes]:
        storage = ctypes.create_string_buffer(data, len(data))
        view = self.make_view(storage, length)
        output = ctypes.c_uint32(0xA5A5A5A5)
        status = int(self.functions[method](ctypes.byref(view), ctypes.byref(output)))
        return status, int(output.value), bytes(storage.raw)

    def test_field0_uses_its_16_byte_extent_and_clears_only_after_nonzero(self) -> None:
        zero_data = bytearray(range(16))
        zero_data[0:4] = b"\x00" * 4
        zero = bytes(zero_data)
        status, raw, after = self.invoke("input_consume_field0", zero, 16)
        self.assertEqual(status, 0)
        self.assertEqual(raw, 0)
        self.assertEqual(after, zero)

        data = bytearray(range(24))
        data[0:4] = b"\x00\x00\x80\x00"
        data[12:16] = b"\xff\x00\x12\x34"
        expected = bytearray(data)
        expected[0:4] = b"\x00" * 4
        expected[12:16] = b"\x00" * 4
        status, raw, after = self.invoke("input_consume_field0", bytes(data), 16)
        self.assertEqual(status, 0)
        self.assertEqual(raw, 1)
        self.assertEqual(after, bytes(expected))

    def test_field4_requires_20_bytes_and_clears_only_after_nonzero(self) -> None:
        data = bytearray(range(24))
        data[4:8] = b"\x00\x00\x00\x80"
        data[16:20] = b"\x01\x02\x03\x04"
        expected = bytearray(data)
        expected[4:8] = b"\x00" * 4
        expected[16:20] = b"\x00" * 4
        status, raw, after = self.invoke("input_consume_field4", bytes(data), 20)
        self.assertEqual(status, 0)
        self.assertEqual(raw, 1)
        self.assertEqual(after, bytes(expected))

        status, raw, after = self.invoke("input_consume_field4", bytes(data), 16)
        self.assertEqual(status, 2)
        self.assertEqual(raw, 0xA5A5A5A5)
        self.assertEqual(after, bytes(data))

    def test_invalid_views_and_address_overflow_preserve_state_and_output(self) -> None:
        original = bytes(range(32))
        storage = ctypes.create_string_buffer(original, len(original))
        view = self.make_view(storage, 15)
        output = ctypes.c_uint32(0xA5A5A5A5)
        status = self.functions["input_consume_field0"](ctypes.byref(view), ctypes.byref(output))
        self.assertEqual(status, 2)
        self.assertEqual(output.value, 0xA5A5A5A5)
        self.assertEqual(bytes(storage.raw), original)

        self.assertEqual(self.functions["input_consume_field0"](None, ctypes.byref(output)), 1)
        valid_view = self.make_view(storage, len(original))
        self.assertEqual(self.functions["input_consume_field0"](ctypes.byref(valid_view), None), 3)
        self.assertEqual(output.value, 0xA5A5A5A5)

        null_view = InputLatchStateView(ctypes.POINTER(ctypes.c_uint8)(), 16)
        self.assertEqual(self.functions["input_consume_field0"](ctypes.byref(null_view), ctypes.byref(output)), 1)

        max_address = ctypes.c_size_t(-1).value
        near_end = ctypes.cast(ctypes.c_void_p(max_address - 7), ctypes.POINTER(ctypes.c_uint8))
        overflow_view = InputLatchStateView(near_end, 20)
        self.assertEqual(self.functions["input_consume_field0"](ctypes.byref(overflow_view), ctypes.byref(output)), 1)

        huge_view = self.make_view(storage, max_address)
        self.assertEqual(self.functions["input_consume_field0"](ctypes.byref(huge_view), ctypes.byref(output)), 1)

        overflow_output = ctypes.cast(ctypes.c_void_p(max_address - 1), ctypes.POINTER(ctypes.c_uint32))
        self.assertEqual(self.functions["input_consume_field0"](ctypes.byref(valid_view), overflow_output), 3)
        self.assertEqual(bytes(storage.raw), original)
        self.assertEqual(output.value, 0xA5A5A5A5)

    def test_result_overlap_with_state_or_descriptor_is_rejected_before_mutation(self) -> None:
        original = bytearray(range(32))
        original[0:4] = b"\x01\x00\x00\x00"
        storage = ctypes.create_string_buffer(bytes(original), len(original))
        view = self.make_view(storage, len(original))
        before = bytes(storage.raw)
        for offset in (0, 2, 20):
            alias = ctypes.cast(ctypes.addressof(storage) + offset, ctypes.POINTER(ctypes.c_uint32))
            self.assertEqual(self.functions["input_consume_field0"](ctypes.byref(view), alias), 4)
            self.assertEqual(bytes(storage.raw), before)

        descriptor_alias = ctypes.cast(ctypes.addressof(view), ctypes.POINTER(ctypes.c_uint32))
        self.assertEqual(self.functions["input_consume_field0"](ctypes.byref(view), descriptor_alias), 4)
        self.assertEqual(bytes(storage.raw), before)

    def test_view_descriptor_may_alias_state_because_metadata_is_snapshotted(self) -> None:
        max_address = ctypes.c_size_t(-1).value
        for method, primary, companion in (
            ("input_consume_field0", 0, 12),
            ("input_consume_field4", 4, 16),
        ):
            storage = ctypes.create_string_buffer(64)
            base = ctypes.addressof(storage)
            view_pointer = ctypes.cast(base, ctypes.POINTER(InputLatchStateView))
            view_pointer.contents.bytes = ctypes.cast(base, ctypes.POINTER(ctypes.c_uint8))
            view_pointer.contents.length = 20
            before = bytearray(storage.raw)
            self.assertNotEqual(int.from_bytes(before[primary:primary + 4], "little"), 0)
            expected = bytearray(before)
            expected[primary:primary + 4] = b"\x00" * 4
            expected[companion:companion + 4] = b"\x00" * 4
            output = ctypes.c_uint32(0xA5A5A5A5)
            status = self.functions[method](view_pointer, ctypes.byref(output))
            self.assertEqual(status, 0)
            self.assertEqual(output.value, 1)
            self.assertEqual(bytes(storage.raw), bytes(expected))
            self.assertLessEqual(base + len(storage), max_address)

    def test_original_native_oracle_covers_latch_interleavings(self) -> None:
        ORACLE_REPORT.parent.mkdir(parents=True, exist_ok=True)
        result = subprocess.run(
            [str(ORACLE_PYTHON), str(ORACLE), "--original", str(WORK / "original/GAME.EXE"),
             "--report", str(ORACLE_REPORT)],
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        report = json.loads(ORACLE_REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["original_sha256"], "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45")
        self.assertGreater(report["native_original_comparisons"], 0)
        self.assertEqual(report["native_original_mismatches"], 0)
        self.assertGreater(report["interleaving_steps"], 10)
        self.assertTrue(report["frame_short_circuit_cases"] >= 2)
        self.assertFalse(report["contains_original_byte_values"])

    def test_sanitized_harness_passes_address_and_undefined_checks(self) -> None:
        driver = r'''#include "input_consume.h"
#include <stdint.h>
#include <string.h>

int main(void) {
    uint8_t bytes[32];
    uint8_t before[32];
    InputLatchStateView view;
    uint32_t raw = 0xA5A5A5A5u;
    uint32_t *alias;
    size_t i;
    for (i = 0; i < sizeof(bytes); ++i) bytes[i] = (uint8_t)(i * 17u + 3u);
    view.bytes = bytes;
    view.length = 16;
    memcpy(before, bytes, sizeof(bytes));
    if (input_consume_field0(&view, &raw) != INPUT_CONSUME_OK || raw != 1u) return 1;
    if (bytes[0] || bytes[1] || bytes[2] || bytes[3]) return 2;
    if (bytes[12] || bytes[13] || bytes[14] || bytes[15]) return 3;
    if (memcmp(bytes + 16, before + 16, 16) != 0) return 4;
    memcpy(bytes, before, sizeof(bytes));
    view.length = 15;
    raw = 0xA5A5A5A5u;
    if (input_consume_field0(&view, &raw) != INPUT_CONSUME_STATE_VIEW_TOO_SHORT) return 5;
    if (raw != 0xA5A5A5A5u || memcmp(bytes, before, sizeof(bytes)) != 0) return 6;
    view.length = sizeof(bytes);
    alias = (uint32_t *)(void *)(bytes + 1);
    if (input_consume_field0(&view, alias) != INPUT_CONSUME_RESULT_ALIASES_INPUT) return 7;
    if (memcmp(bytes, before, sizeof(bytes)) != 0) return 8;
    view.length = 20;
    if (input_consume_field4(&view, &raw) != INPUT_CONSUME_OK) return 9;
    return 0;
}
'''
        with tempfile.TemporaryDirectory(prefix="s08-4-asan-ubsan-") as directory:
            temp = Path(directory)
            driver_path = temp / "sanitize_driver.c"
            executable = temp / "sanitize_driver"
            driver_path.write_text(driver, encoding="utf-8")
            build = subprocess.run(
                ["xcrun", "clang", "-std=c11", "-O1", "-g", "-fsanitize=address,undefined",
                 "-fno-omit-frame-pointer", "-I", str(HEADER_DIR), str(SOURCE), str(driver_path),
                 "-o", str(executable)],
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(build.returncode, 0, build.stdout + build.stderr)
            environment = dict(os.environ)
            environment["ASAN_OPTIONS"] = "detect_leaks=0:halt_on_error=1"
            environment["UBSAN_OPTIONS"] = "halt_on_error=1:print_stacktrace=1"
            result = subprocess.run(
                [str(executable)], text=True, capture_output=True, check=False, env=environment
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
