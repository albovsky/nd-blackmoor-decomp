#!/usr/bin/env python3
"""Native tests for the bounded raw-0x37 decoder/constructor model."""

from __future__ import annotations

import ctypes as c
import struct
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libactionfamily37.dylib"
OK = 0
ERR_ARGUMENT = 1
ERR_BODY = 2
ERR_NAME = 3
ERR_TAIL = 4
ERR_BOUNDS = 5
ERR_OVERLAP = 6
BODY_BYTES = 69
DEPENDENCY_BYTES = 16
OBJECT_BYTES = 0xABA


class Decoded(c.Structure):
    _fields_ = [
        ("name", c.c_uint8 * 33),
        ("option_21", c.c_uint16),
        ("option_23", c.c_uint16),
        ("fixed_rect", c.c_int32 * 4),
        ("initial_geometry", c.c_int32 * 4),
        ("dependency_records", c.POINTER(c.c_uint8)),
        ("dependency_count", c.c_size_t),
        ("available_body_bytes", c.c_size_t),
        ("body_bytes", c.c_size_t),
        ("dependency_bytes", c.c_size_t),
    ]


class OwnerLinks(c.Structure):
    _fields_ = [
        ("output_handle", c.c_uint32),
        ("result_slot_handle", c.c_uint32),
        ("owner_slot_1c_handle", c.c_uint32),
        ("owner_slot_20_handle", c.c_uint32),
        ("output_allocation_bytes", c.c_uint32),
    ]


class Constructed(c.Structure):
    _fields_ = [
        ("object_bytes", c.c_uint8 * OBJECT_BYTES),
        ("dependency_records", c.POINTER(c.c_uint8)),
        ("dependency_count", c.c_size_t),
        ("dependency_bytes", c.c_size_t),
        ("available_body_bytes", c.c_size_t),
        ("body_bytes_consumed", c.c_size_t),
        ("payload_offset_before", c.c_uint32),
        ("payload_offset_after", c.c_uint32),
        ("owner_links", OwnerLinks),
    ]


def buffer(data: bytes):
    return (c.c_uint8 * len(data)).from_buffer_copy(data) if data else None


def pointer_value(pointer) -> int | None:
    return c.cast(pointer, c.c_void_p).value if pointer else None


def body_bytes(
    name: bytes = b"overlay",
    *,
    option_21: int = 1,
    option_23: int = 10,
    fixed_rect=(0, 0, 32, 24),
    initial_geometry=(1, 2, 3, 4),
    dependency_count: int = 0,
) -> bytes:
    if len(name) > 32:
        raise ValueError("name must fit the 33-byte fixed field")
    body = bytearray(BODY_BYTES + dependency_count * DEPENDENCY_BYTES)
    body[: len(name)] = name
    body[len(name)] = 0
    struct.pack_into("<HH", body, 0x21, option_21 & 0xFFFF, option_23 & 0xFFFF)
    struct.pack_into("<4I", body, 0x25, *(value & 0xFFFFFFFF for value in fixed_rect))
    struct.pack_into("<4I", body, 0x35, *(value & 0xFFFFFFFF for value in initial_geometry))
    for i in range(BODY_BYTES, len(body)):
        body[i] = (i * 29 + 7) & 0xFF
    return bytes(body)


class ActionFamily37Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        built = subprocess.run(
            [str(PROJECT / "scripts/build_action_family_37.sh")],
            text=True,
            capture_output=True,
        )
        if built.returncode != 0:
            raise AssertionError(
                f"A-37.2 strict build failed:\n{built.stdout}{built.stderr}"
            )
        cls.lib = c.CDLL(str(LIBRARY))
        cls.lib.action_family_37_decode.argtypes = [
            c.POINTER(c.c_uint8), c.c_size_t, c.POINTER(Decoded)
        ]
        cls.lib.action_family_37_decode.restype = c.c_int
        cls.lib.action_family_37_construct.argtypes = [
            c.POINTER(c.c_uint8), c.c_size_t, c.c_uint32, c.c_uint32,
            c.POINTER(Constructed),
        ]
        cls.lib.action_family_37_construct.restype = c.c_int

    def decode(self, raw: bytes):
        source = buffer(raw)
        out = Decoded()
        status = self.lib.action_family_37_decode(source, len(raw), c.byref(out))
        return status, source, out

    def construct(self, raw: bytes, offset=0x32, handle=0x37A70001):
        source = buffer(raw)
        out = Constructed()
        status = self.lib.action_family_37_construct(
            source, len(raw), offset, handle, c.byref(out)
        )
        return status, source, out

    def test_fixed_decoder_lengths_and_borrowed_tail_view(self):
        for count in (0, 1, 8):
            raw = body_bytes(dependency_count=count)
            status, source, decoded = self.decode(raw)
            self.assertEqual(status, OK)
            self.assertEqual((decoded.body_bytes, decoded.dependency_count,
                              decoded.dependency_bytes, decoded.available_body_bytes),
                             (69, count, count * 16, len(raw)))
            self.assertEqual(pointer_value(decoded.dependency_records),
                             c.addressof(source) + 69)
            self.assertEqual(bytes(decoded.name), b"overlay\0" + bytes(25))
            self.assertEqual((decoded.option_21, decoded.option_23), (1, 10))
            self.assertEqual(tuple(decoded.fixed_rect), (0, 0, 32, 24))
            self.assertEqual(tuple(decoded.initial_geometry), (1, 2, 3, 4))

    def test_endian_signed_fields_name_and_exact_constructor_defaults(self):
        raw = body_bytes(name=b"", option_21=0x80FF, option_23=0xFE01,
                         fixed_rect=(0, 0, 0, 0), initial_geometry=(-1, -2, 0x12345678,
                                                                    -0x80000000))
        status, source, decoded = self.decode(raw)
        self.assertEqual(status, OK)
        self.assertEqual((decoded.option_21, decoded.option_23), (0x80FF, 0xFE01))
        self.assertEqual(tuple(decoded.initial_geometry), (-1, -2, 0x12345678,
                                                           -0x80000000))

        status, source, state = self.construct(raw)
        self.assertEqual(status, OK)
        image = bytes(state.object_bytes)
        expected = bytearray(OBJECT_BYTES)
        struct.pack_into("<H", expected, 0x21, 2)
        struct.pack_into("<H", expected, 0x23, 0x80FF)
        struct.pack_into("<H", expected, 0x25, 2)
        struct.pack_into("<H", expected, 0x27, 0xFE01)
        struct.pack_into("<H", expected, 0x29, 1)
        struct.pack_into("<H", expected, 0x39, 0xFFFF)
        struct.pack_into("<H", expected, 0x3D, 9999)
        struct.pack_into("<H", expected, 0x2B, 1)
        struct.pack_into("<H", expected, 0x43, 1)
        struct.pack_into("<I", expected, 0x4D, 1)
        struct.pack_into("<H", expected, 0xAA, 1)
        for index in range(10):
            struct.pack_into("<H", expected, 0x51 + index * 4, 0xFFFF)
        expected[0x79:0x82] = b"NO SOUND\0"
        struct.pack_into("<H", expected, 0x6F0, 2)
        expected[0x702:0x712] = raw[0x25:0x35]
        expected[0xAC:0xBC] = raw[0x35:0x45]
        self.assertEqual(image, bytes(expected))
        self.assertEqual(struct.unpack_from("<I", image, 0x6FA)[0], 0)
        self.assertEqual(struct.unpack_from("<I", image, 0x6FE)[0], 0)
        self.assertEqual(image[0x1C:0x21], bytes(5))
        self.assertEqual((state.body_bytes_consumed, state.payload_offset_before,
                          state.payload_offset_after), (69, 0x32, 0x77))
        self.assertEqual(state.owner_links.output_handle, 0x37A70001)
        self.assertEqual(state.owner_links.result_slot_handle, 0x37A70001)
        self.assertEqual(state.owner_links.owner_slot_1c_handle, 0x37A70001)
        self.assertEqual(state.owner_links.owner_slot_20_handle, 0x37A70001)
        self.assertEqual(state.owner_links.output_allocation_bytes, OBJECT_BYTES)
        self.assertEqual(pointer_value(state.dependency_records), c.addressof(source) + 69)

    def test_32_character_name_and_signed_extreme_difference_wrap(self):
        name = bytes(range(1, 33))
        raw = body_bytes(
            name=name,
            option_21=0xABCD,
            option_23=0x1234,
            fixed_rect=(-0x80000000, 0x7FFFFFFF, 0x7FFFFFFF, -0x80000000),
            initial_geometry=(-0x80000000, -1, 0, 0x7FFFFFFF),
        )
        status, source, state = self.construct(raw, offset=0xFFFFFFFB, handle=0x12345678)
        self.assertEqual(status, OK)
        image = bytes(state.object_bytes)
        self.assertEqual(image[:33], raw[:33])
        self.assertEqual(image[0x1C:0x21], raw[0x1C:0x21])
        self.assertEqual(image[0xAC:0xBC], raw[0x35:0x45])
        self.assertEqual(struct.unpack_from("<I", image, 0x6FA)[0], 0xFFFFFFFF)
        self.assertEqual(struct.unpack_from("<I", image, 0x6FE)[0], 1)
        self.assertEqual(state.payload_offset_after, 0x40)
        self.assertEqual(state.owner_links.output_handle, 0x12345678)
        self.assertEqual(state.owner_links.result_slot_handle, 0x12345678)

    def test_suffix_after_name_terminator_is_not_copied_to_object(self):
        raw = bytearray(body_bytes(name=b"X"))
        raw[2:0x21] = b"Q" * (0x21 - 2)
        status, _source, state = self.construct(bytes(raw))
        self.assertEqual(status, OK)
        self.assertEqual(bytes(state.object_bytes[:33]), b"X\0" + bytes(31))

    def test_invalid_inputs_and_output_aliases_are_atomic(self):
        raw = body_bytes()
        source = buffer(raw)
        decoded = Decoded()
        c.memset(c.byref(decoded), 0xA5, c.sizeof(decoded))
        before_decoded = bytes(decoded)
        self.assertEqual(self.lib.action_family_37_decode(source, 68,
                                                          c.byref(decoded)), ERR_BODY)
        self.assertEqual(bytes(decoded), before_decoded)

        for malformed, expected_status in (
            (body_bytes()[:68], ERR_BODY),
            (b"Z" * 69, ERR_NAME),
            (body_bytes() + b"\x01", ERR_TAIL),
        ):
            state = Constructed()
            c.memset(c.byref(state), 0xA5, c.sizeof(state))
            before = bytes(state)
            pointer = buffer(malformed)
            status = self.lib.action_family_37_construct(
                pointer, len(malformed), 0x32, 1, c.byref(state)
            )
            self.assertEqual(status, expected_status)
            self.assertEqual(bytes(state), before)

        state = Constructed()
        c.memset(c.byref(state), 0xA5, c.sizeof(state))
        before = bytes(state)
        self.assertEqual(self.lib.action_family_37_construct(
            source, len(raw), 0x32, 0, c.byref(state)), ERR_ARGUMENT)
        self.assertEqual(bytes(state), before)
        self.assertEqual(self.lib.action_family_37_decode(None, 69,
                                                          c.byref(decoded)), ERR_ARGUMENT)
        self.assertEqual(self.lib.action_family_37_decode(source, 69, None), ERR_ARGUMENT)

        top = (1 << (c.sizeof(c.c_void_p) * 8)) - 1
        wrapped_input = c.cast(c.c_void_p(top - 16), c.POINTER(c.c_uint8))
        self.assertEqual(self.lib.action_family_37_decode(wrapped_input, 69,
                                                          c.byref(decoded)), ERR_BOUNDS)
        wrapped_output = c.cast(c.c_void_p(top - 1), c.POINTER(Constructed))
        self.assertEqual(self.lib.action_family_37_construct(
            source, len(raw), 0x32, 1, wrapped_output), ERR_BOUNDS)

        arena = (c.c_uint8 * (c.sizeof(Constructed) + 128))()
        arena[:69] = raw[:69]
        arena_before = bytes(arena)
        alias_input = c.cast(arena, c.POINTER(c.c_uint8))
        alias_output = c.cast(arena, c.POINTER(Constructed))
        self.assertEqual(self.lib.action_family_37_construct(
            alias_input, 69, 0x32, 1, alias_output), ERR_OVERLAP)
        self.assertEqual(bytes(arena), arena_before)

        decode_arena = (c.c_uint8 * (c.sizeof(Decoded) + 128))()
        decode_arena[:69] = raw[:69]
        decode_before = bytes(decode_arena)
        decode_input = c.cast(decode_arena, c.POINTER(c.c_uint8))
        decode_output = c.cast(decode_arena, c.POINTER(Decoded))
        self.assertEqual(self.lib.action_family_37_decode(
            decode_input, 69, decode_output), ERR_OVERLAP)
        self.assertEqual(bytes(decode_arena), decode_before)

    def test_guards_input_tail_and_constructor_output(self):
        raw = body_bytes(dependency_count=2)
        original = bytes(raw)
        source = buffer(raw)

        class Guarded(c.Structure):
            _fields_ = [
                ("prefix", c.c_uint8 * 16),
                ("state", Constructed),
                ("suffix", c.c_uint8 * 16),
            ]

        guarded = Guarded()
        c.memset(c.byref(guarded), 0xA7, c.sizeof(guarded))
        status = self.lib.action_family_37_construct(
            source, len(raw), 0x32, 0x10203040, c.byref(guarded.state)
        )
        self.assertEqual(status, OK)
        self.assertEqual(bytes(guarded.prefix), b"\xA7" * 16)
        self.assertEqual(bytes(guarded.suffix), b"\xA7" * 16)
        self.assertEqual(bytes(source), original)
        self.assertEqual(guarded.state.dependency_count, 2)
        self.assertEqual(guarded.state.dependency_bytes, 32)
        self.assertEqual(guarded.state.available_body_bytes, len(raw))
        self.assertEqual(pointer_value(guarded.state.dependency_records),
                         c.addressof(source) + 69)


if __name__ == "__main__":
    unittest.main()
