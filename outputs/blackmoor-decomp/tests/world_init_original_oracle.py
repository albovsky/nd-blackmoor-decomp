"""Pinned original-x86 byte oracle for the bounded world-init contract.

Run with:
    python3 outputs/blackmoor-decomp/tests/world_init_original_oracle.py

This checks the executable hash, extracted code-window hashes, and exact
instruction-byte anchors for all modeled spans/branches. It does not emulate
the full initializer or claim complete game-state equivalence.
"""

from __future__ import annotations

import hashlib
import argparse
import json
import struct
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
GAME = ROOT / "work/original/GAME.EXE"
EXPECTED_GAME_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
IMAGE_BASE = 0x400000

SOURCE_WINDOWS = {
    "new_game_event_clear": (0x438233, 0x43825E),
    "new_game_visits_clear": (0x43825E, 0x438288),
    "new_game_opaque_state_clear": (0x438288, 0x4382B0),
    "new_game_time_record_loop": (0x4382B0, 0x4382E2),
    "new_game_clock_and_difficulty": (0x4382E2, 0x4383C1),
    "new_game_start_tuple": (0x438627, 0x43873F),
    "scene_clear_event_flags": (0x43DC28, 0x43DD5E),
    "scene_clear_clock_branch": (0x43E13B, 0x43E18F),
    "successful_load_visit_increment": (0x43A6A2, 0x43A6CF),
    "inventory_reset": (0x4E7E1E, 0x4E7EF5),
    "inventory_object_data_reset": (0x4E7F19, 0x4E7FA9),
    "time_record_initializer": (0x433BD2, 0x433C51),
}


ANCHORS = [
    ("New Game clears 1,251 event dwords", 0x438245,
     "817df8e3040000"),
    ("New Game event clear base and zero store", 0x43824E,
     "8b55f8c70495a167580000000000"),
    ("New Game clears 10,001 visit words", 0x438270,
     "817df811270000"),
    ("New Game visit clear base and zero store", 0x438279,
     "8b4df866c7044d2d7b58000000"),
    ("New Game clears 30 state dwords", 0x43829A,
     "837df81e"),
    ("New Game state dword base and zero store", 0x4382A0,
     "8b45f8c70485b139580000000000"),
    ("time-record loop count, stride and helper call", 0x4382C2,
     "837df80a7d1a8b55f869d20601000081c2655d580052e8f5b8ffff"),
    ("clock total-minute multiply and dword store", 0x438350,
     "0fbf05515d58006bc03c0fbf0d4f5d580003c1a34b5d5800"),
    ("clock interval read and deadline store", 0x438368,
     "0fbf1580025b008b45fc03c2a3555d5800"),
    ("difficulty reset to zero", 0x4383AF,
     "66c7054fc958000000"),
    ("alternate tuple gate", 0x438627,
     "833dde b15b0000".replace(" ", "")),
    ("forced-scene gates and mirror destination", 0x438684,
     "833dd1a46300007509833dd5a4630000745a"),
    ("test-mode gate after tuple selection", 0x43873F,
     "833dd9a46300000f849b010000"),
    ("inventory selector reset fields", 0x4E7E1E,
     "66c7052b3a5800000066c7052d3a5800000066c7052f3a5800000066c705293a5800ffff66c7051d3f5800ffff"),
    ("inventory loop resets 70 rows", 0x4E7E6F,
     "8b4dfc83b92e82000046"),
    ("inventory object loop resets 16 0x28-byte records", 0x4E7F1C,
     "83b82e82000010"),
    ("inventory object slot first dword becomes 0xffffffff", 0x4E7F34,
     "c78410ae7f0000ffffffff"),
    ("inventory object slot second dword becomes zero", 0x4E7F4E,
     "c78410b27f000000000000"),
    ("inventory object fixed data resets at offsets 0x825e and 0x6b1c",
     0x4E7F5E,
     "c7815e820000000000008b55fcc7821c6b0000ffffffff"),
    ("inventory object fixed data resets at offsets 0x8256 and 0x8286",
     0x4E7F78,
     "c78056820000000000008b4dfcc7818682000000000000"),
    ("inventory object fixed data resets at offsets 0x825a and 0x8262",
     0x4E7F92,
     "c7825a820000000000008b45fcc7806282000000000000"),
    ("scene-clear restoration gate", 0x43E13B,
     "833db5325e00007527"),
    ("scene-clear fresh clock fields", 0x43E144,
     "c705415d58000000000066c705455d5800000066c705475d5800000066c705495d58000000"),
    ("scene-clear restore re-baseline/deadline", 0x43E16B,
     "8b4dfc890d335d58008b55fc89155d5d58000fbf0580025b008b4dfc03c8890d555d5800"),
    ("successful scene load increments a 16-bit visit word", 0x43A6A2,
     "e8efff0000833db5325e0000751fa17bb55b00668b0c452d7b58006683c1018b157bb55b0066890c552d7b5800"),
    ("31 contiguous scene-clear event stores", 0x43DC28, None),
    ("time-record helper zeroes 65 dwords plus one word", 0x433BE0,
     "b94100000033c08b7d08f3ab66ab"),
    ("time-record helper writes sentinels at stride four", 0x433BF5,
     "eb098b45fc83c0018945fc837dfc0a7d12"),
]


def pe_sections(image: bytes):
    pe_offset = struct.unpack_from("<I", image, 0x3C)[0]
    if image[pe_offset:pe_offset + 4] != b"PE\0\0":
        raise AssertionError("original image has no PE signature")
    coff = pe_offset + 4
    section_count = struct.unpack_from("<H", image, coff + 2)[0]
    optional_size = struct.unpack_from("<H", image, coff + 16)[0]
    section_table = coff + 20 + optional_size
    sections = []
    for index in range(section_count):
        offset = section_table + index * 40
        name = image[offset:offset + 8].split(b"\0", 1)[0].decode("ascii")
        virtual_size, rva, raw_size, raw_offset = struct.unpack_from(
            "<IIII", image, offset + 8
        )
        sections.append((name, virtual_size, rva, raw_size, raw_offset))
    return sections


def file_bytes_for_va(image: bytes, sections, va: int, size: int) -> bytes:
    rva = va - IMAGE_BASE
    for _name, _virtual_size, section_rva, raw_size, raw_offset in sections:
        relative = rva - section_rva
        if relative >= 0 and relative + size <= raw_size:
            return image[raw_offset + relative:raw_offset + relative + size]
    raise AssertionError(f"VA {va:#x}+{size:#x} is not backed by original file bytes")


def expected_scene_clear_stores() -> bytes:
    return b"".join(
        b"\xc7\x05" + struct.pack("<I", 0x5867A1 + 4 * index) + b"\0\0\0\0"
        for index in range(31)
    )


def reference_time_record() -> bytes:
    record = bytearray(0x106)
    record[0x28:0x28 + 9] = b"NO SOUND\0"
    for index in range(10):
        offset = 0xDE + index * 4
        record[offset:offset + 2] = b"\xff\xff"
    return bytes(record)


def emulate_original_time_record_initializer(image: bytes, sections) -> bytes:
    from unicorn import Uc, UC_ARCH_X86, UC_MODE_32
    from unicorn.x86_const import UC_X86_REG_EIP, UC_X86_REG_ESP

    function_va = 0x433BD2
    code_page = 0x433000
    machine = Uc(UC_ARCH_X86, UC_MODE_32)
    machine.mem_map(code_page, 0x1000)
    machine.mem_write(code_page,
                      file_bytes_for_va(image, sections, code_page, 0x1000))

    data_page = 0x545000
    machine.mem_map(data_page, 0x1000)
    machine.mem_write(0x545DD4,
                      file_bytes_for_va(image, sections, 0x545DD4, 9))

    record_address = 0x600100
    machine.mem_map(0x600000, 0x1000)
    machine.mem_write(record_address, b"\xcc" * 0x106)
    stack_base = 0x700000
    machine.mem_map(stack_base, 0x1000)
    stack_pointer = stack_base + 0x800
    return_address = stack_base + 0xF00
    machine.mem_write(stack_pointer,
                      struct.pack("<II", return_address, record_address))
    machine.reg_write(UC_X86_REG_ESP, stack_pointer)
    machine.emu_start(function_va, return_address, count=10000)
    if machine.reg_read(UC_X86_REG_EIP) != return_address:
        raise AssertionError("original helper did not return within instruction limit")
    return bytes(machine.mem_read(record_address, 0x106))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--emulate-original-time-record-helper",
        action="store_true",
        help="execute isolated original x86 helper 0x433bd2 with Unicorn",
    )
    args = parser.parse_args()
    image = GAME.read_bytes()
    actual_hash = hashlib.sha256(image).hexdigest()
    if actual_hash != EXPECTED_GAME_SHA256:
        raise SystemExit(
            f"pinned original hash mismatch: {actual_hash} != {EXPECTED_GAME_SHA256}"
        )
    sections = pe_sections(image)
    windows = {}
    for name, (begin, end) in SOURCE_WINDOWS.items():
        code = file_bytes_for_va(image, sections, begin, end - begin)
        file_offset = next(
            raw + (begin - IMAGE_BASE - rva)
            for _section, _vs, rva, raw_size, raw in sections
            if begin - IMAGE_BASE >= rva and end - IMAGE_BASE <= rva + raw_size
        )
        windows[name] = {
            "va_start": f"0x{begin:08x}",
            "va_end_exclusive": f"0x{end:08x}",
            "file_offset": f"0x{file_offset:x}",
            "sha256": hashlib.sha256(code).hexdigest(),
            "length": len(code),
        }

    checks = []
    for label, va, expected_hex in ANCHORS:
        if expected_hex is None:
            expected = expected_scene_clear_stores()
        else:
            expected = bytes.fromhex(expected_hex)
        actual = file_bytes_for_va(image, sections, va, len(expected))
        if actual != expected:
            raise SystemExit(
                f"original byte anchor mismatch at {va:#x}: "
                f"{actual.hex()} != {expected.hex()} ({label})"
            )
        checks.append({
            "label": label,
            "va": f"0x{va:08x}",
            "bytes_hex": actual.hex(),
            "passed": True,
        })

    sound_name = file_bytes_for_va(image, sections, 0x545DD4, 9)
    if sound_name != b"NO SOUND\0":
        raise SystemExit(f"original time-record sound name mismatch: {sound_name!r}")
    emulated = None
    if args.emulate_original_time_record_helper:
        emulated = emulate_original_time_record_initializer(image, sections)
        if emulated != reference_time_record():
            raise SystemExit(
                "emulated original VA 0x433bd2 differs from the independent record fixture"
            )
    result = {
        "original_exe_sha256": actual_hash,
        "original_exe_size": len(image),
        "provenance": "direct PE32/i386 source bytes from work/original/GAME.EXE",
        "source_windows": windows,
        "byte_assertions": checks,
        "time_record_initializer": {
            "helper_va": "0x00433bd2",
            "record_bytes": 262,
            "zero_prefix_stores": "65 dwords and one word",
            "name_va": "0x00545dd4",
            "name_hex": sound_name.hex(),
            "sentinel_word_count": 10,
            "sentinel_offset_first": "0xde",
            "sentinel_stride": 4,
            "emulated_original": emulated is not None,
            "record_sha256": hashlib.sha256(emulated).hexdigest()
            if emulated is not None else None,
            "comparison": "emulated original bytes match independent expected record"
            if emulated is not None else "not requested; static byte assertions only",
        },
        "limits": [
            "Only the standalone 0x433bd2 time-record initializer was dynamically executed; the full 0x4381f4 initializer and 0x43dbe3 scene-clear routine contain application/resource calls outside this slice.",
            "Byte checks prove the listed loop bounds, writes, tuple gates, and clock branches only.",
            "Event-flag, visit, and inventory allocation capacities are not established by reset spans or neighboring addresses.",
            "The inventory object's resource-handle destruction/recreation and icon setup at 0x4e7e15 are not modeled by the data-only object reset helper.",
            "Test-mode filesystem/automation behavior after the 0x63a4d9 gate is not modeled.",
        ],
    }
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
