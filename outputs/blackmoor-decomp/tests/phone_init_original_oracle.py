#!/usr/bin/env python3
"""Compare selected 0x4e2e05 phone initialization with native BOOT row sorting.

Other phone UI descriptors are seeded empty to exclude unrelated rendering
configuration. No x86 instruction or function is hooked in this comparison.
"""
import ctypes as c
import hashlib
import json
import struct
from pathlib import Path

from action_ui_original_oracle import (make_unicorn, PEImage, EXPECTED_EXE_SHA256,
    PHONE_COUNT_VA, PHONE_RECORDS_VA, NLS_MODE_VA, DEBUG_LOG_VA)
from test_action_ui import ActionUIWorld, PHONE_SIZE, PROJECT


def main():
    root = PROJECT.parents[1]
    pe = PEImage.parse_and_map(root / "work/original/GAME.EXE")
    assert hashlib.sha256(pe.data).hexdigest() == EXPECTED_EXE_SHA256
    boot = (root / "work/analysis/cif-boot-native.bin").read_bytes()
    report_path = root / "work/analysis/phone-init-validation.json"
    boot_report = json.loads((root / "work/analysis/boot-world-inputs-recovery.json").read_text())
    # The actual UICL chunk is independently described by the recovered BOOT
    # loader. Check ID and size before using its observed payload offset.
    offset = 0xbb64
    assert boot[offset-8:offset-4] == b"UICL"
    size = int.from_bytes(boot[offset-4:offset], "big")
    uicl = boot[offset:offset+size]
    count = struct.unpack_from("<h", uicl, 0xd9f)[0]
    assert count == 12 and 0xda1 + PHONE_SIZE * count <= len(uicl)
    source_bytes = uicl[0xda1:0xda1+PHONE_SIZE*count]
    uc, invoke, _ = make_unicorn(pe)
    uc.mem_write(NLS_MODE_VA, b"\0")
    uc.mem_write(DEBUG_LOG_VA, b"\0")
    source_object = 0x57975c
    uc.mem_write(source_object+0x1471, struct.pack("<h", count))
    uc.mem_write(source_object+0x457b, source_bytes)
    # Empty comparison sentinels select descriptor-disabled paths, leaving
    # actual phone copy/sort and all its in-image helpers unchanged.
    uc.mem_write(source_object+0x139d, bytes(uc.mem_read(0x63a9e4, 1)))
    uc.mem_write(source_object+0x13e3, bytes(uc.mem_read(0x63a9e8, 1)))
    invoke(0x4e2e05, ecx=source_object)
    original_count = struct.unpack("<h", uc.mem_read(PHONE_COUNT_VA, 2))[0]
    original = bytes(uc.mem_read(PHONE_RECORDS_VA, original_count*PHONE_SIZE))
    library_path = PROJECT / "build/libactionui.dylib"
    lib = c.CDLL(str(library_path))
    lib.action_ui_initialize_phone.argtypes = [c.POINTER(ActionUIWorld),
        c.POINTER(c.c_uint8*PHONE_SIZE), c.c_size_t]
    lib.action_ui_initialize_phone.restype = c.c_int
    source = ((c.c_uint8*PHONE_SIZE)*count).from_buffer_copy(source_bytes)
    destination = ((c.c_uint8*PHONE_SIZE)*count)()
    world = ActionUIWorld(phone_records=destination, phone_capacity=count)
    assert lib.action_ui_initialize_phone(c.byref(world), source, count) == 0
    native = bytes(destination)
    mismatches = int(world.phone_count != original_count or original != native)
    report = {"scope":"selected 0x4e2e05 BOOT phone row copy/sort; other UI descriptors disabled",
        "original_sha256":EXPECTED_EXE_SHA256,
        "native_library_sha256":hashlib.sha256(library_path.read_bytes()).hexdigest(),
        "boot_sha256":hashlib.sha256(boot).hexdigest(),
        "source_uicl_sha256":hashlib.sha256(uicl).hexdigest(),
        "original_entry":"0x4e2e05", "instruction_hooks":0,
        "phone_rows_compared":original_count, "phone_bytes_compared":len(original),
        "sorted_rows_sha256":hashlib.sha256(original).hexdigest(),
        "mismatches":mismatches, "global_table_capacity_proven":False}
    assert boot_report
    report_path.write_text(json.dumps(report, indent=2)+"\n")
    print(f"Compared {original_count} phone rows / {len(original)} bytes; mismatches={mismatches}")
    return mismatches


if __name__ == "__main__":
    raise SystemExit(main())
