#!/usr/bin/env python3
from __future__ import annotations

import ctypes
import itertools
import os
import subprocess
import tempfile
import unittest
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
SOURCE = PROJECT / "src/input_latch.c"
HEADER = PROJECT / "src/input_latch.h"
LIBRARY = PROJECT / "build/libinput_latch.dylib"
U32_MAX = 0xFFFFFFFF


class StateView(ctypes.Structure):
    _fields_ = [("bytes", ctypes.POINTER(ctypes.c_uint8)), ("length", ctypes.c_size_t)]


class PointView(ctypes.Structure):
    _fields_ = [("bytes", ctypes.POINTER(ctypes.c_uint8)), ("length", ctypes.c_size_t)]


def pattern(size: int, seed: int = 0) -> bytes:
    return bytes((seed * 73 + index * 29 + 7) & 0xFF for index in range(size))


def word(data: bytes | bytearray, offset: int) -> int:
    return int.from_bytes(data[offset:offset + 4], "little")


def put_word(data: bytearray, offset: int, value: int) -> None:
    data[offset:offset + 4] = (value & U32_MAX).to_bytes(4, "little")


def buffer_for(data: bytes | bytearray) -> ctypes.Array[ctypes.c_char]:
    return ctypes.create_string_buffer(bytes(data), len(data))


def pointer_at(buffer: ctypes.Array[ctypes.c_char], offset: int = 0) -> ctypes.POINTER(ctypes.c_uint8):
    return ctypes.cast(ctypes.addressof(buffer) + offset, ctypes.POINTER(ctypes.c_uint8))


def bytes_from(buffer: ctypes.Array[ctypes.c_char], size: int) -> bytes:
    return ctypes.string_at(ctypes.addressof(buffer), size)


class InputLatchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        subprocess.run([str(PROJECT / "scripts/build_input_latch.sh")], check=True)
        cls.library = ctypes.CDLL(str(LIBRARY))
        cls.library.input_latch_move.argtypes = [
            ctypes.POINTER(StateView), ctypes.c_uint32, ctypes.POINTER(PointView)
        ]
        cls.library.input_latch_move.restype = ctypes.c_int
        cls.library.input_latch_down.argtypes = [
            ctypes.POINTER(StateView), ctypes.c_uint32, ctypes.c_uint32
        ]
        cls.library.input_latch_down.restype = ctypes.c_int
        cls.library.input_latch_up.argtypes = [
            ctypes.POINTER(StateView), ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint32
        ]
        cls.library.input_latch_up.restype = ctypes.c_int

    def state(self, buffer: ctypes.Array[ctypes.c_char], length: int | None = None) -> StateView:
        return StateView(pointer_at(buffer), len(buffer) if length is None else length)

    def test_move_copies_full_unsigned_words_and_preserves_every_other_byte(self) -> None:
        initial = bytearray(pattern(0x40, 1))
        point_data = buffer_for(b"\x00\x00\x00\x80\xff\xff\xff\xff")
        point = PointView(pointer_at(point_data), 8)
        state_buffer = buffer_for(initial)
        status = self.library.input_latch_move(
            ctypes.byref(self.state(state_buffer)), U32_MAX, ctypes.byref(point)
        )
        expected = bytearray(initial)
        put_word(expected, 0x18, 0x80000000)
        put_word(expected, 0x1C, U32_MAX)
        self.assertEqual(status, 0)
        self.assertEqual(bytes_from(state_buffer, len(expected)), bytes(expected))

    def test_move_reads_second_word_after_first_store_when_views_overlap(self) -> None:
        initial = bytearray(pattern(0x40, 2))
        first = word(initial, 0x14)
        state_buffer = buffer_for(initial)
        point = PointView(pointer_at(state_buffer, 0x14), 8)
        status = self.library.input_latch_move(
            ctypes.byref(self.state(state_buffer)), 0xAABBCCDD, ctypes.byref(point)
        )
        expected = bytearray(initial)
        put_word(expected, 0x18, first)
        put_word(expected, 0x1C, first)
        self.assertEqual(status, 0)
        self.assertEqual(bytes_from(state_buffer, len(expected)), bytes(expected))

    def test_move_rejects_short_state_and_point_before_writing(self) -> None:
        initial = pattern(0x40, 3)
        state_buffer = buffer_for(initial)
        point_buffer = buffer_for(b"abcdefgh")
        state = self.state(state_buffer, 0x1F)
        point = PointView(pointer_at(point_buffer), 8)
        self.assertEqual(
            self.library.input_latch_move(ctypes.byref(state), 0, ctypes.byref(point)), 2
        )
        self.assertEqual(bytes_from(state_buffer, len(initial)), initial)

        state = self.state(state_buffer)
        point.length = 7
        self.assertEqual(
            self.library.input_latch_move(ctypes.byref(state), 0, ctypes.byref(point)), 4
        )
        self.assertEqual(bytes_from(state_buffer, len(initial)), initial)

    def test_move_rejects_null_views_without_writing(self) -> None:
        initial = pattern(0x40, 4)
        state_buffer = buffer_for(initial)
        state = self.state(state_buffer)
        self.assertEqual(self.library.input_latch_move(None, 0, None), 1)
        point = PointView(None, 8)
        self.assertEqual(
            self.library.input_latch_move(ctypes.byref(state), 0, ctypes.byref(point)), 3
        )
        self.assertEqual(bytes_from(state_buffer, len(initial)), initial)

    def test_down_truth_table_and_untouched_bytes(self) -> None:
        for value in (0, 1, 2, 0x80000000, U32_MAX):
            with self.subTest(field_0c=value):
                initial = bytearray(pattern(0x40, value & 0xFF))
                put_word(initial, 0x00, 0xAABBCCDD)
                put_word(initial, 0x08, 0x10203040)
                put_word(initial, 0x0C, value)
                put_word(initial, 0x10, 0x55667788)
                state_buffer = buffer_for(initial)
                status = self.library.input_latch_down(
                    ctypes.byref(self.state(state_buffer)), U32_MAX, 0xDEADBEEF
                )
                expected = bytearray(initial)
                put_word(expected, 0x00, 0)
                put_word(expected, 0x08, 0)
                if value == 0:
                    put_word(expected, 0x0C, 1)
                put_word(expected, 0x10, 0)
                self.assertEqual(status, 0)
                self.assertEqual(bytes_from(state_buffer, len(expected)), bytes(expected))

    def test_up_truth_table_for_gate_sentinel_and_noncanonical_latches(self) -> None:
        guards = (U32_MAX, 0, 0x80000000)
        latch_values = (0, 1, 2, 0x80000000, U32_MAX)
        blocked_values = (0, 1, 0x80000000, U32_MAX)
        for blocked, guard, field_00, field_0c in itertools.product(
            blocked_values, guards, latch_values, latch_values
        ):
            with self.subTest(blocked=blocked, guard=guard, field_00=field_00, field_0c=field_0c):
                initial = bytearray(pattern(0x40, (field_00 ^ field_0c ^ guard) & 0xFF))
                put_word(initial, 0x00, field_00)
                put_word(initial, 0x08, blocked)
                put_word(initial, 0x0C, field_0c)
                put_word(initial, 0x10, 0xA1B2C3D4)
                state_buffer = buffer_for(initial)
                status = self.library.input_latch_up(
                    ctypes.byref(self.state(state_buffer)), 0x12345678, U32_MAX, guard
                )
                expected = bytearray(initial)
                if blocked == 0:
                    if guard != U32_MAX and field_00 == 0:
                        put_word(expected, 0x00, 1)
                    if field_0c == 1:
                        put_word(expected, 0x0C, 2)
                    put_word(expected, 0x10, 0)
                self.assertEqual(status, 0)
                self.assertEqual(bytes_from(state_buffer, len(expected)), bytes(expected))

    def test_down_and_up_reject_short_state_without_writing(self) -> None:
        for method in ("input_latch_down", "input_latch_up"):
            with self.subTest(method=method):
                initial = pattern(0x20, 5)
                state_buffer = buffer_for(initial)
                state = self.state(state_buffer, 0x13)
                if method.endswith("up"):
                    status = getattr(self.library, method)(ctypes.byref(state), 0, 0, 0)
                else:
                    status = getattr(self.library, method)(ctypes.byref(state), 0, 0)
                self.assertEqual(status, 2)
                self.assertEqual(bytes_from(state_buffer, len(initial)), initial)

    def test_down_and_up_do_not_dereference_callback_argument(self) -> None:
        state_buffer = buffer_for(pattern(0x20, 6))
        state = self.state(state_buffer)
        self.assertEqual(
            self.library.input_latch_down(ctypes.byref(state), U32_MAX, 0xDEADBEEF), 0
        )
        self.assertEqual(
            self.library.input_latch_up(ctypes.byref(state), 0xDEADBEEF, U32_MAX, 0), 0
        )

    def test_sanitized_short_and_overlapping_views(self) -> None:
        harness = r'''#include "input_latch.h"
#include <stdint.h>
#include <string.h>
int main(void) {
    uint8_t storage[0x48];
    uint8_t point_storage[8] = {0x78, 0x56, 0x34, 0x12, 0xef, 0xcd, 0xab, 0x90};
    uint8_t before[sizeof(storage)];
    InputLatchStateView state;
    InputLatchPointView point;
    memset(storage, 0x5a, sizeof(storage));
    memcpy(before, storage, sizeof(storage));
    state.bytes = storage + 1;
    state.length = 0x13;
    point.bytes = point_storage;
    point.length = sizeof(point_storage);
    if (input_latch_down(&state, 0, 0) != INPUT_LATCH_STATE_VIEW_TOO_SHORT) return 1;
    if (memcmp(before, storage, sizeof(storage)) != 0) return 2;
    state.length = 0x20;
    point.length = 7;
    if (input_latch_move(&state, 0, &point) != INPUT_LATCH_POINT_VIEW_TOO_SHORT) return 3;
    if (memcmp(before, storage, sizeof(storage)) != 0) return 4;
    point.bytes = storage + 0x15;
    point.length = 8;
    memcpy(storage + 0x15, point_storage, 8);
    if (input_latch_move(&state, UINT32_MAX, &point) != INPUT_LATCH_OK) return 5;
    if (memcmp(storage + 0x19, storage + 0x15, 4) != 0) return 6;
    if (memcmp(storage + 0x1d, storage + 0x19, 4) != 0) return 7;
    return 0;
}'''
        with tempfile.TemporaryDirectory(prefix="s08-3-input-latch-asan-") as directory:
            temp = Path(directory)
            source = temp / "sanitizer.c"
            executable = temp / "sanitizer"
            source.write_text(harness, encoding="utf-8")
            subprocess.run(
                [
                    "xcrun", "clang", "-std=c11", "-O1", "-g", "-Wall", "-Wextra", "-Werror",
                    "-fsanitize=address,undefined", "-fno-omit-frame-pointer",
                    "-I", str(PROJECT / "src"), str(SOURCE), str(source), "-o", str(executable),
                ],
                check=True,
            )
            env = dict(os.environ)
            env["ASAN_OPTIONS"] = "abort_on_error=1"
            env["UBSAN_OPTIONS"] = "halt_on_error=1:print_stacktrace=1"
            subprocess.run([str(executable)], check=True, env=env)


if __name__ == "__main__":
    unittest.main()
