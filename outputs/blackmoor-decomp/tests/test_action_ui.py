"""Native bounds and state tests for the isolated UI action families."""

from __future__ import annotations

import ctypes as c
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libactionui.dylib"

OK = 0
ERR_ARGUMENT = 1
ERR_BODY = 2
ERR_GROUP_BOUNDS = 3
ERR_PHONE_CAPACITY = 4
ERR_UNSUPPORTED = 5

PHONE_SIZE = 41


class ControlGroup(c.Structure):
    _fields_ = [
        ("state", c.c_int32),
        ("starts", c.c_int16 * 50),
        ("ends", c.c_int16 * 50),
        ("codes", c.c_int32 * 50),
        ("availability", c.c_int32),
        ("flags", c.c_int32 * 3),
    ]


class ActionUIWorld(c.Structure):
    _fields_ = [
        ("phone_records", c.POINTER(c.c_uint8 * PHONE_SIZE)),
        ("phone_count", c.c_size_t),
        ("phone_capacity", c.c_size_t),
        ("nls_mode", c.c_uint8),
        ("controls", ControlGroup * 5),
    ]


class ActionUIActionResult(c.Structure):
    _fields_ = [
        ("recognized", c.c_uint8),
        ("applied", c.c_uint8),
        ("completed", c.c_uint8),
        ("phase", c.c_uint32),
    ]


def bytes_buffer(data: bytes):
    return (c.c_uint8 * len(data)).from_buffer_copy(data)


def i16(value: int) -> bytes:
    return int(value).to_bytes(2, "little", signed=True)


def phone(key: bytes, name: str, tail: bytes = b"\x5a" * 8, prefix=b"\x0a\x00") -> bytes:
    assert len(key) == 11
    encoded = name.encode("ascii")
    assert len(encoded) < 20
    assert len(tail) == 8
    return prefix + key + encoded + b"\0" * (20 - len(encoded)) + tail


def control(group: int, code: int, mode: int, start: int, end: int) -> bytes:
    return i16(group) + bytes((code, mode)) + i16(start) + i16(end)


class ActionUITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not LIBRARY.is_file():
            subprocess.run([str(PROJECT / "scripts/build_action_ui.sh")], check=True)
        cls.lib = c.CDLL(str(LIBRARY))
        cls.lib.action_ui_initialize_controls.argtypes = [c.POINTER(ActionUIWorld)]
        cls.lib.action_ui_initialize_controls.restype = c.c_int
        cls.lib.action_ui_initialize_phone.argtypes = [
            c.POINTER(ActionUIWorld), c.POINTER(c.c_uint8 * PHONE_SIZE), c.c_size_t
        ]
        cls.lib.action_ui_initialize_phone.restype = c.c_int
        cls.lib.action_ui_apply_phone.argtypes = [
            c.POINTER(ActionUIWorld), c.POINTER(c.c_uint8), c.c_size_t
        ]
        cls.lib.action_ui_apply_phone.restype = c.c_int
        cls.lib.action_ui_apply_control.argtypes = [
            c.POINTER(ActionUIWorld), c.POINTER(c.c_uint8), c.c_size_t
        ]
        cls.lib.action_ui_apply_control.restype = c.c_int
        cls.lib.action_ui_dispatch.argtypes = [
            c.POINTER(ActionUIWorld), c.c_uint8, c.c_uint8,
            c.POINTER(c.c_uint8), c.c_size_t, c.c_uint32,
            c.POINTER(ActionUIActionResult),
        ]
        cls.lib.action_ui_dispatch.restype = c.c_int

    def world(self, phone_capacity=8):
        rows = ((c.c_uint8 * PHONE_SIZE) * phone_capacity)()
        world = ActionUIWorld()
        world.phone_records = c.cast(rows, c.POINTER(c.c_uint8 * PHONE_SIZE))
        world.phone_capacity = phone_capacity
        self.assertEqual(self.lib.action_ui_initialize_controls(c.byref(world)), OK)
        return world, rows

    def apply_phone(self, world, body):
        return self.lib.action_ui_apply_phone(c.byref(world), bytes_buffer(body), len(body))

    def apply_control(self, world, body):
        return self.lib.action_ui_apply_control(c.byref(world), bytes_buffer(body), len(body))

    def test_control_initialization_matches_five_groups_and_all_sentinels(self):
        world, _rows = self.world()
        for group in world.controls:
            self.assertEqual(group.state, 0)
            self.assertEqual(group.availability, 0)
            self.assertEqual(list(group.flags), [0, 0, 0])
            self.assertEqual(list(group.starts), [9999] * 50)
            self.assertEqual(list(group.ends), [9999] * 50)
            self.assertEqual(list(group.codes), [13] * 50)

    def test_phone_initialization_preserves_rows_and_controls_while_sorting(self):
        world, rows = self.world()
        entries = [phone(b"x" * 11, "Zulu"), phone(b"x" * 11, "alice"),
                   phone(b"x" * 11, "Alice", tail=b"\x11" * 8)]
        source = ((c.c_uint8 * PHONE_SIZE) * len(entries)).from_buffer_copy(b"".join(entries))
        controls_before = bytes(world.controls)
        self.assertEqual(self.lib.action_ui_initialize_phone(c.byref(world), source,
                                                             len(entries)), OK)
        self.assertEqual(world.phone_count, 3)
        self.assertEqual([bytes(rows[i]) for i in range(3)],
                         [entries[1], entries[2], entries[0]])
        self.assertEqual(bytes(world.controls), controls_before)
        self.assertEqual(bytes(source), b"".join(entries))

    def test_phone_initialization_rejects_bad_source_before_mutation(self):
        world, rows = self.world(phone_capacity=1)
        seed = phone(b"s" * 11, "Seed")
        self.assertEqual(self.apply_phone(world, seed), OK)
        source = ((c.c_uint8 * PHONE_SIZE) * 2).from_buffer_copy(
            phone(b"a" * 11, "Alpha") + phone(b"b" * 11, "Beta"))
        before = bytes(world), bytes(rows)
        self.assertEqual(self.lib.action_ui_initialize_phone(c.byref(world), source, 2),
                         ERR_PHONE_CAPACITY)
        self.assertEqual((bytes(world), bytes(rows)), before)
        source[0][13:33] = b"A" * 20
        self.assertEqual(self.lib.action_ui_initialize_phone(c.byref(world), source, 1),
                         ERR_BODY)
        self.assertEqual((bytes(world), bytes(rows)), before)
        world.nls_mode = 1
        before = bytes(world), bytes(rows)
        self.assertEqual(self.lib.action_ui_initialize_phone(c.byref(world), source, 1),
                         ERR_UNSUPPORTED)
        self.assertEqual((bytes(world), bytes(rows)), before)

    def test_phone_insert_sorts_by_recovered_ascii_normalization_and_sets_ui_bits(self):
        world, rows = self.world()
        zulu = phone(b"z" * 11, "zulu", tail=b"\x01\x02\x03\x04\x05\x06\x07\x08")
        alpha = phone(b"a" * 11, "alpha", tail=b"\x08\x07\x06\x05\x04\x03\x02\x01")
        self.assertEqual(self.apply_phone(world, zulu), OK)
        self.assertEqual(self.apply_phone(world, alpha), OK)
        self.assertEqual(world.phone_count, 2)
        self.assertEqual(bytes(rows[0]), alpha)
        self.assertEqual(bytes(rows[1]), zulu)
        self.assertEqual(world.controls[3].availability, 1)
        self.assertEqual(world.controls[3].flags[0], 1)
        self.assertEqual(list(world.controls[3].flags[1:]), [0, 0])

    def test_phone_duplicate_key_replaces_the_entire_record_before_sort(self):
        world, rows = self.world()
        old = phone(b"k" * 11, "Alpha", tail=b"\x11" * 8)
        other = phone(b"x" * 11, "Mango", tail=b"\x22" * 8)
        replacement = phone(b"k" * 11, "Zulu", tail=b"\x33" * 8,
                            prefix=b"\xaa\xbb")
        self.assertEqual(self.apply_phone(world, old), OK)
        self.assertEqual(self.apply_phone(world, other), OK)
        self.assertEqual(self.apply_phone(world, replacement), OK)
        self.assertEqual(world.phone_count, 2)
        self.assertEqual(bytes(rows[0]), other)
        self.assertEqual(bytes(rows[1]), replacement)

    def test_phone_equal_casefolded_names_keep_existing_stable_order(self):
        world, rows = self.world()
        lowercase = phone(b"1" * 11, "alice")
        uppercase = phone(b"2" * 11, "Alice")
        self.assertEqual(self.apply_phone(world, lowercase), OK)
        self.assertEqual(self.apply_phone(world, uppercase), OK)
        self.assertEqual([bytes(rows[i]) for i in range(2)], [lowercase, uppercase])

    def test_phone_sort_restarts_after_each_adjacent_swap(self):
        world, rows = self.world()
        initial = [
            phone(b"z" * 11, "Zulu"),
            phone(b"m" * 11, "Mike"),
            phone(b"e" * 11, "Echo"),
        ]
        for index, record in enumerate(initial):
            rows[index][:] = record
        world.phone_count = len(initial)
        inserted = phone(b"a" * 11, "Alpha")
        self.assertEqual(self.apply_phone(world, inserted), OK)
        self.assertEqual(world.phone_count, 4)
        names = [bytes(rows[index][13:33]).split(b"\0", 1)[0]
                 for index in range(world.phone_count)]
        self.assertEqual(names, [b"Alpha", b"Echo", b"Mike", b"Zulu"])

    def test_phone_capacity_bad_nls_and_bad_records_are_atomic(self):
        world, rows = self.world(phone_capacity=1)
        first = phone(b"1" * 11, "One")
        second = phone(b"2" * 11, "Two")
        self.assertEqual(self.apply_phone(world, first), OK)
        before = bytes(rows[0])
        self.assertEqual(self.apply_phone(world, second), ERR_PHONE_CAPACITY)
        self.assertEqual(bytes(rows[0]), before)
        self.assertEqual(world.phone_count, 1)

        world.nls_mode = 1
        self.assertEqual(self.apply_phone(world, phone(b"1" * 11, "Changed")), ERR_UNSUPPORTED)
        self.assertEqual(bytes(rows[0]), before)
        world.nls_mode = 0
        invalid_name = b"x" * 41
        self.assertEqual(self.apply_phone(world, invalid_name), ERR_BODY)
        self.assertEqual(bytes(rows[0]), before)

    def test_invalid_existing_phone_table_is_rejected_before_replacement(self):
        world, rows = self.world(phone_capacity=1)
        rows[0][:] = phone(b"k" * 11, "Valid")
        world.phone_count = 1
        rows[0][13:33] = b"x" * 20
        invalid_original = bytes(rows[0])
        self.assertEqual(self.apply_phone(world, phone(b"k" * 11, "Replacement")),
                         ERR_ARGUMENT)
        self.assertEqual(bytes(rows[0]), invalid_original)

    def test_control_insert_duplicate_and_remove_reproduce_parallel_array_quirk(self):
        world, _rows = self.world()
        group = world.controls[2]
        self.assertEqual(self.apply_control(world, control(2, 13, 1, -4, 9)), OK)
        self.assertEqual((group.starts[0], group.ends[0], group.codes[0]), (-4, 9, 13))
        self.assertEqual(self.apply_control(world, control(2, 77, 1, -4, 9)), OK)
        self.assertEqual((group.starts[0], group.ends[0], group.codes[0]), (-4, 9, 13))

        self.assertEqual(self.apply_control(world, control(2, 55, 1, 20, 21)), OK)
        self.assertEqual((group.starts[1], group.ends[1], group.codes[1]), (20, 21, 55))
        codes_before = list(group.codes)
        self.assertEqual(self.apply_control(world, control(2, 0, 0, -4, 9)), OK)
        self.assertEqual((group.starts[0], group.ends[0]), (20, 9))
        self.assertEqual((group.starts[1], group.ends[1]), (9999, 21))
        self.assertEqual(list(group.codes[:49]), codes_before[:49])
        self.assertEqual(group.codes[49], 13)

    def test_control_special_sentinels_and_full_table_shift(self):
        world, _rows = self.world()
        group = world.controls[0]
        self.assertEqual(self.apply_control(world, control(0, 13, 1, 9995, 0)), OK)
        self.assertEqual(group.state, 1)
        self.assertEqual(self.apply_control(world, control(0, 13, 1, 1, 9996)), OK)
        self.assertEqual(group.state, 0)
        self.assertEqual(self.apply_control(world, control(0, 13, 0, 0, 9997)), OK)
        self.assertEqual(group.state, 2)
        self.assertEqual(self.apply_control(world, control(0, 13, 0, 9998, 0)), OK)
        self.assertEqual(group.state, 0)

        for entry in range(50):
            group.starts[entry] = entry
            group.ends[entry] = entry + 100
            group.codes[entry] = 1000 + entry
        self.assertEqual(self.apply_control(world, control(0, 42, 1, -7, 8)), OK)
        self.assertEqual(list(group.starts[:3]), [1, 2, 3])
        self.assertEqual(list(group.ends[:3]), [100, 101, 102])
        self.assertEqual((group.starts[49], group.ends[49], group.codes[49]), (-7, 8, 42))
        self.assertEqual(group.codes[0], 1000)
        self.assertEqual(group.codes[1], 1001)

    def test_control_code_one_is_explicitly_unsupported_and_atomic(self):
        world, _rows = self.world()
        group = world.controls[1]
        before = (group.state, list(group.starts), list(group.ends), list(group.codes))
        self.assertEqual(self.apply_control(world, control(1, 1, 1, 0, 0)), ERR_UNSUPPORTED)
        self.assertEqual((group.state, list(group.starts), list(group.ends), list(group.codes)),
                         before)

    def test_control_group_bounds_and_body_length_are_rejected_without_writes(self):
        world, _rows = self.world()
        self.assertEqual(self.apply_control(world, control(-1, 13, 1, 1, 2)),
                         ERR_GROUP_BOUNDS)
        self.assertEqual(self.apply_control(world, control(5, 13, 1, 1, 2)),
                         ERR_GROUP_BOUNDS)
        self.assertEqual(self.apply_control(world, b"\0" * 7), ERR_BODY)
        for group in world.controls:
            self.assertEqual(list(group.starts), [9999] * 50)

    def test_dispatch_completion_is_direct_subtype_agnostic_and_preserves_phase(self):
        world, _rows = self.world()
        for action_type, body in (
            (0x82, phone(b"p" * 11, "Phone")),
            (0x1D, control(3, 13, 1, 0, 0)),
        ):
            result = ActionUIActionResult()
            body_view = bytes_buffer(body)
            self.assertEqual(
                self.lib.action_ui_dispatch(c.byref(world), action_type, 2,
                                            body_view, len(body), 0x12345678,
                                            c.byref(result)), OK
            )
            self.assertEqual((result.recognized, result.applied, result.completed), (1, 1, 1))
            self.assertEqual(result.phase, 0x12345678)
        self.assertEqual(world.controls[3].starts[0], 0)

        result = ActionUIActionResult()
        unsupported_control = control(0, 1, 1, 0, 0)
        body_view = bytes_buffer(unsupported_control)
        self.assertEqual(self.lib.action_ui_dispatch(c.byref(world), 0x1D, 1,
                                                    body_view, len(unsupported_control), 9,
                                                    c.byref(result)), ERR_UNSUPPORTED)
        self.assertEqual((result.recognized, result.applied, result.completed), (1, 0, 0))
        self.assertEqual(result.phase, 9)

        self.assertEqual(self.lib.action_ui_dispatch(c.byref(world), 0xFE, 1,
                                                    body_view, len(unsupported_control), 9,
                                                    c.byref(result)), ERR_UNSUPPORTED)
        self.assertEqual((result.recognized, result.applied), (0, 0))


if __name__ == "__main__":
    unittest.main()
