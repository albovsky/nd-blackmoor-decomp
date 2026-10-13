"""Original-byte A-28 initializer/setup/capture/blend layout regression.

This test executes the pinned x86 bytes in Unicorn. It supplies only a
synthetic 16-bit mode-table entry and memory-backed DirectDraw surface wrapper;
it does not launch the game or claim native presentation parity.
"""
import ctypes as c
import hashlib
from pathlib import Path
import struct
import subprocess
import sys
import unittest

from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE
from unicorn.x86_const import (
    UC_X86_REG_EAX, UC_X86_REG_EBP, UC_X86_REG_ECX, UC_X86_REG_EFLAGS,
    UC_X86_REG_EIP, UC_X86_REG_ESP, UC_X86_REG_FPCW,
)


PROJECT = Path(__file__).resolve().parents[1]
ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(PROJECT / "tests"))
from cif_original_oracle import PEImage, EXPECTED_EXE_SHA256, align_up

STACK = 0x10000000
STACK_TOP = STACK + 0x1F000
DATA = 0x20000000
END = 0x30000000
EFFECT = 0x6198D7
SURFACE_WRAPPER = 0x5CF659
GLOBAL_CANVAS = 0x583186
BYTE_COUNT_GLOBAL = 0x639895
BIT_COUNT_GLOBAL = 0x639893
CHANNEL_SHIFTS = (0x5D2F1B, 0x5D2F1A, 0x5D2F19)
CHANNEL_MASKS = (0x5D2F1F, 0x5D2F1E, 0x5D2F1D)


class Rect(c.Structure):
    _fields_ = [("left", c.c_int32), ("top", c.c_int32),
                ("right", c.c_int32), ("bottom", c.c_int32)]


class PrimarySurface(c.Structure):
    _fields_ = [
        ("pixels", c.POINTER(c.c_uint8)), ("byte_length", c.c_size_t),
        ("width", c.c_size_t), ("height", c.c_size_t),
        ("pitch_bytes", c.c_size_t), ("origin_x", c.c_int32),
        ("origin_y", c.c_int32), ("channel_shifts", c.c_uint8 * 3),
        ("channel_masks", c.c_uint8 * 3), ("format", c.c_int),
        ("scope", c.c_int), ("primary_target", c.c_uint8),
        ("storage_lifetime", c.c_int),
    ]


class WordCapture(c.Structure):
    _fields_ = [
        ("bytes", c.POINTER(c.c_uint8)), ("byte_length", c.c_size_t),
        ("width", c.c_size_t), ("height", c.c_size_t),
        ("stride_pixels", c.c_size_t), ("offset_x", c.c_size_t),
        ("offset_y", c.c_size_t), ("storage_lifetime", c.c_int),
    ]


def packed_surface(seed, width=4, height=3):
    words = []
    for y in range(height):
        for x in range(width):
            i = y * width + x
            red = (seed + 3 * i + x) & 31
            green = (seed * 5 + 7 * i + y) & 63
            blue = (seed * 3 + 11 * i + x + y) & 31
            words.append((red << 11) | (green << 5) | blue)
    return struct.pack("<" + "H" * len(words), *words)


def capture_descriptor(storage, rect, width=4, height=3):
    return WordCapture(c.cast(storage, c.POINTER(c.c_uint8)), len(storage),
        width, height, width, rect.left, rect.top, 1)


def primary_descriptor(storage, width=4, height=3):
    return PrimarySurface(c.cast(storage, c.POINTER(c.c_uint8)), len(storage),
        width, height, width * 2, 0, 0,
        (c.c_uint8 * 3)(11, 5, 0), (c.c_uint8 * 3)(31, 63, 31),
        1, 1, 1, 1)


class OriginalFrameOracle:
    """Runs the original setup/capture/pixel routines with bounded test hooks."""
    def __init__(self, image):
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(image.image_base, align_up(image.size_of_image))
        self.uc.mem_write(image.image_base, image.image)
        self.uc.mem_map(STACK, 0x20000)
        self.uc.mem_map(DATA, 0x80000)
        self.uc.mem_map(END, 0x1000)
        self.alloc_cursor = DATA + 0x40000
        self.allocations = []
        self.present_calls = 0
        self.tail_pump_calls = 0
        self.mode_helper_calls = 0
        for va in (0x51DC43, 0x4C9B66, 0x4C952F, 0x4C4C2B):
            self.uc.hook_add(UC_HOOK_CODE, self.hook, begin=va, end=va)

    @staticmethod
    def _read32(uc, address):
        return struct.unpack("<I", uc.mem_read(address, 4))[0]

    def _return_from_hook(self, uc, eax=None):
        esp = uc.reg_read(UC_X86_REG_ESP)
        if eax is not None:
            uc.reg_write(UC_X86_REG_EAX, eax)
        uc.reg_write(UC_X86_REG_EIP, self._read32(uc, esp))
        uc.reg_write(UC_X86_REG_ESP, esp + 4)

    def hook(self, uc, address, _size, _user):
        if address == 0x51DC43:
            esp = uc.reg_read(UC_X86_REG_ESP)
            requested = self._read32(uc, esp + 4)
            aligned = (requested + 15) & ~15
            result = self.alloc_cursor
            self.alloc_cursor += max(aligned, 16)
            if self.alloc_cursor > DATA + 0x80000:
                raise RuntimeError("bounded oracle allocator exhausted")
            self.allocations.append(requested)
            self._return_from_hook(uc, result)
        elif address == 0x4C9B66:
            # The original helper queries a display device. For this exact
            # software-mode branch the hook supplies only its success field;
            # 0x4c9d91's original selected-mode parsing runs unchanged.
            self.mode_helper_calls += 1
            ecx = uc.reg_read(UC_X86_REG_ECX)
            uc.mem_write(ecx + 0x1F34, struct.pack("<I", 1))
            self._return_from_hook(uc, 1)
        elif address == 0x4C952F:
            self.present_calls += 1
            self._return_from_hook(uc)
        elif address == 0x4C4C2B:
            self.tail_pump_calls += 1
            self._return_from_hook(uc)

    def call(self, address, args=(), ecx=0, control_word=0x037F):
        esp = STACK_TOP - 4 * (len(args) + 1)
        self.uc.mem_write(esp, struct.pack("<" + "I" * (len(args) + 1), END, *args))
        self.uc.reg_write(UC_X86_REG_ESP, esp)
        self.uc.reg_write(UC_X86_REG_EBP, 0)
        self.uc.reg_write(UC_X86_REG_ECX, ecx)
        self.uc.reg_write(UC_X86_REG_EFLAGS, 0x202)
        self.uc.reg_write(UC_X86_REG_FPCW, control_word)
        self.uc.emu_start(address, END, timeout=10_000_000, count=20_000_000)
        if self.uc.reg_read(UC_X86_REG_EIP) != END:
            raise RuntimeError(f"original 0x{address:x} did not return")
        return self.uc.reg_read(UC_X86_REG_EAX)

    def select_synthetic_16bit_mode(self):
        obj = DATA + 0x1000
        selected = DATA + 0x6000
        source = DATA + 0x8000
        self.uc.mem_write(obj, bytes(0x2000))
        self.uc.mem_write(obj + 0x1F24, struct.pack("<I", selected))
        self.uc.mem_write(obj + 0x1F28, struct.pack("<I", source))
        self.uc.mem_write(obj + 0x1F30, struct.pack("<I", 2))
        # The selected mode record consumed by original 0x4c9d91. Bit count is
        # at +0, width at +4 and height at +8 in the 0x40-byte table entry.
        self.uc.mem_write(0x552BEC, struct.pack("<HHHHH", 16, 0, 4, 0, 3))
        self.uc.mem_write(source, bytes(0x1764))
        self.uc.mem_write(source + 0x1758, struct.pack("<III", 1, 0, 0))
        self.uc.mem_write(0x63A4CD, b"\x00\x00")
        self.call(0x4C9D91, ecx=obj)
        bits = struct.unpack("<h", self.uc.mem_read(BIT_COUNT_GLOBAL, 2))[0]
        byte_count = struct.unpack("<h", self.uc.mem_read(BYTE_COUNT_GLOBAL, 2))[0]
        dimensions = struct.unpack("<hh", self.uc.mem_read(0x63988B, 4))
        if (bits, byte_count, dimensions) != (16, 2, (4, 3)):
            raise AssertionError((bits, byte_count, dimensions))

    def initialize_and_setup(self, body):
        uc = self.uc
        uc.mem_write(EFFECT, bytes(0x100))
        uc.mem_write(GLOBAL_CANVAS, struct.pack("<4i", 0, 0, 3, 2))
        self.call(0x446FFB, ecx=EFFECT)
        if self.allocations[-2:] != [4 * 3 * 12, 4 * 3 * 12]:
            raise AssertionError(f"unexpected capture allocations: {self.allocations}")

        input_body = DATA + 0x2000
        cursor = DATA + 0x2100
        consumed = DATA + 0x2110
        slot = 0x5BB5E5
        phase = 0x5BB632
        uc.mem_write(input_body, body)
        uc.mem_write(cursor, struct.pack("<I", input_body))
        uc.mem_write(consumed, bytes(4))
        uc.mem_write(slot, bytes(4))
        uc.mem_write(phase, bytes(4))
        self.call(0x4471CA, (slot, cursor, consumed))
        self.call(0x44727A, (0,), ecx=EFFECT)

        initialized = {
            "capture_width": struct.unpack("<i", uc.mem_read(EFFECT + 0x3D, 4))[0],
            "capture_height": struct.unpack("<i", uc.mem_read(EFFECT + 0x41, 4))[0],
            "capture_pitch_bytes": struct.unpack("<i", uc.mem_read(EFFECT + 0x45, 4))[0],
            "capture_pixels": struct.unpack("<i", uc.mem_read(EFFECT + 0x39, 4))[0],
            "source_allocation": self.allocations[-3],
            "target_allocation": self.allocations[-2],
            "effect_rect": struct.unpack("<4i", uc.mem_read(EFFECT + 0x1D, 16)),
            "payload_origin": struct.unpack("<2i", uc.mem_read(EFFECT + 0x4E, 8)),
        }
        if initialized != {
            "capture_width": 4, "capture_height": 3,
            "capture_pitch_bytes": 8, "capture_pixels": 12,
            "source_allocation": 144, "target_allocation": 144,
            "effect_rect": (1, 0, 2, 1), "payload_origin": (1, 0),
        }:
            raise AssertionError(initialized)
        return initialized

    def configure_wrapper(self, source, output, width=4, height=3):
        uc = self.uc
        uc.mem_write(SURFACE_WRAPPER + 0x0C, struct.pack("<I", source))
        uc.mem_write(SURFACE_WRAPPER + 0x14, struct.pack("<I", output))
        uc.mem_write(SURFACE_WRAPPER + 0x18, struct.pack("<h", width))
        uc.mem_write(SURFACE_WRAPPER + 0x1A, struct.pack("<h", height))
        uc.mem_write(SURFACE_WRAPPER + 0x1C, struct.pack("<i", width * 2))
        uc.mem_write(SURFACE_WRAPPER + 0x20, struct.pack("<h", 2))
        uc.mem_write(SURFACE_WRAPPER + 0x22, bytes(32))
        uc.mem_write(SURFACE_WRAPPER + 0x42, bytes(4))
        uc.mem_write(0x5CF665, struct.pack("<I", source))

    def capture(self, surface, output):
        self.configure_wrapper(surface, surface)
        self.call(0x447AC7, (surface, output), ecx=EFFECT)
        return bytes(self.uc.mem_read(output, 4 * 3 * 12))

    def blend(self, output_surface, output_buffer, source, target, weight=0.5):
        self.configure_wrapper(output_surface, output_buffer)
        self.present_calls = 0
        self.tail_pump_calls = 0
        low, high = struct.unpack("<II", struct.pack("<d", weight))
        self.call(0x4477D1, (output_surface, source, target, low, high),
                  ecx=EFFECT, control_word=0x037F)
        if (self.present_calls, self.tail_pump_calls) != (1, 1):
            raise AssertionError((self.present_calls, self.tail_pump_calls))
        return bytes(self.uc.mem_read(output_buffer, 4 * 3 * 2))


class ActionFamily28FrameOracleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT / "scripts/build_action_family28_surface.sh")],
                       check=True)
        cls.lib = c.CDLL(str(PROJECT / "build/libactionfamily28surface.dylib"))
        cls.lib.action_family28_capture_required_bytes.argtypes = [
            c.c_size_t, c.c_size_t, c.c_size_t, c.POINTER(c.c_size_t)]
        cls.lib.action_family28_capture_required_bytes.restype = c.c_int
        cls.lib.action_family28_surface_capture_words.argtypes = [
            c.POINTER(PrimarySurface), c.POINTER(Rect), c.POINTER(WordCapture)]
        cls.lib.action_family28_surface_capture_words.restype = c.c_int
        cls.lib.action_family28_surface_blend_present_words.argtypes = [
            c.POINTER(PrimarySurface), c.POINTER(Rect), c.POINTER(WordCapture),
            c.POINTER(WordCapture), c.c_double, c.c_uint16, c.c_uint8]
        cls.lib.action_family28_surface_blend_present_words.restype = c.c_int
        original_path = ROOT / "work/original/GAME.EXE"
        cls.pe = PEImage.parse_and_map(original_path)
        if hashlib.sha256(cls.pe.data).hexdigest() != EXPECTED_EXE_SHA256:
            raise AssertionError("pinned original executable hash mismatch")

    def test_original_initializer_capture_crop_and_blend_tuple(self):
        original = OriginalFrameOracle(self.pe)
        original.select_synthetic_16bit_mode()
        body = struct.pack("<Bhhiiii", 1, 100, 0, 1, 0, 2, 1)
        state = original.initialize_and_setup(body)
        self.assertEqual(state["capture_width"], 4)
        self.assertEqual(state["capture_height"], 3)
        self.assertEqual(state["capture_pitch_bytes"], 8)
        self.assertEqual(state["source_allocation"], 144)
        self.assertEqual(state["effect_rect"], (1, 0, 2, 1))
        self.assertEqual(state["payload_origin"], (1, 0))

        for va, value in zip(CHANNEL_SHIFTS, (11, 5, 0)):
            original.uc.mem_write(va, bytes([value]))
        for va, value in zip(CHANNEL_MASKS, (31, 63, 31)):
            original.uc.mem_write(va, bytes([value]))

        source_bytes = packed_surface(3)
        target_bytes = packed_surface(19)
        initial_output = packed_surface(7)
        source_va, target_va, output_va = DATA + 0x1000, DATA + 0x2000, DATA + 0x3000
        source_capture_va = struct.unpack("<I", original.uc.mem_read(EFFECT + 0x31, 4))[0]
        target_capture_va = struct.unpack("<I", original.uc.mem_read(EFFECT + 0x35, 4))[0]
        output_va_bytes = DATA + 0x4000
        original.uc.mem_write(source_va, source_bytes)
        original.uc.mem_write(target_va, target_bytes)
        original.uc.mem_write(output_va, initial_output)
        original.uc.mem_write(output_va_bytes, initial_output)
        source_words = original.capture(source_va, source_capture_va)
        target_words = original.capture(target_va, target_capture_va)
        original_output = original.blend(output_va, output_va_bytes,
            source_capture_va, target_capture_va)

        # The same full-canvas surfaces enter the typed native adapter. Its
        # capture bytes must match original 0x447ac7 exactly, including the
        # independent effect-crop origin from body offsets +0x4e/+0x52.
        source_storage = (c.c_uint8 * len(source_bytes)).from_buffer_copy(source_bytes)
        target_storage = (c.c_uint8 * len(target_bytes)).from_buffer_copy(target_bytes)
        output_storage = (c.c_uint8 * len(initial_output)).from_buffer_copy(initial_output)
        source_surface = primary_descriptor(source_storage)
        target_surface = primary_descriptor(target_storage)
        output_surface = primary_descriptor(output_storage)
        rect = Rect(*state["effect_rect"])
        size = c.c_size_t()
        self.assertEqual(self.lib.action_family28_capture_required_bytes(
            4, 3, 4, c.byref(size)), 0)
        self.assertEqual(size.value, 144)
        source_native_storage = (c.c_uint8 * size.value)()
        target_native_storage = (c.c_uint8 * size.value)()
        source_native = capture_descriptor(source_native_storage, rect)
        target_native = capture_descriptor(target_native_storage, rect)
        self.assertEqual(self.lib.action_family28_surface_capture_words(
            c.byref(source_surface), c.byref(rect), c.byref(source_native)), 0)
        self.assertEqual(self.lib.action_family28_surface_capture_words(
            c.byref(target_surface), c.byref(rect), c.byref(target_native)), 0)
        self.assertEqual(bytes(source_native_storage), source_words)
        self.assertEqual(bytes(target_native_storage), target_words)
        self.assertEqual((source_native.width, source_native.height,
                          source_native.stride_pixels,
                          source_native.offset_x, source_native.offset_y),
                         (4, 3, 4, 1, 0))

        self.assertEqual(self.lib.action_family28_surface_blend_present_words(
            c.byref(output_surface), c.byref(rect), c.byref(source_native),
            c.byref(target_native), 0.5, 0x037F, 1), 0)
        self.assertEqual(bytes(output_storage), original_output)

        # The pixels around the nonzero effect rectangle remain the initialized
        # target bytes in both original and native output buffers.
        for index in (0, 3, 4, 7, 8, 9, 10, 11):
            self.assertEqual(original_output[index * 2:index * 2 + 2],
                             initial_output[index * 2:index * 2 + 2])
        self.assertEqual(len(source_words), 4 * 3 * 12)
        self.assertEqual(len(target_words), 4 * 3 * 12)


if __name__ == "__main__":
    unittest.main()
