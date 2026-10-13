#!/usr/bin/env python3
"""Validate recovered AUTOTEXT records against original GAME.EXE lookup.

This executes only the shipped executable's table initializer, entry insert,
and caption lookup routines in a bounded Unicorn machine. AUTOTEXT record
bytes are taken from the decoded AUTOTEXT HIFF/TEXT/CVTX fixture. The original
resource loader's CVTX record loop is separately identified in the recovery
notes; this oracle does not start the game or call Windows APIs.

Run from the workspace root with:

    work/tools/oracle-python/bin/python \
        outputs/blackmoor-decomp/tests/autotext_original_oracle.py verify
"""

from __future__ import annotations

import argparse
import hashlib
import json
import struct
from collections import defaultdict
from pathlib import Path
from typing import Any

from hiff_original_oracle import DEFAULT_EXE, PEImage, sha256


ROOT = Path(__file__).resolve().parents[3]
RESOURCE_PATH = ROOT / "work/analysis/hiff-resources/0001.bin"
EXPECTED_EXE_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
EXPECTED_RESOURCE_SHA256 = "9c3d5cabe39edc21603e06e1ee933837cd080650762df4d2a8d107eebcfca441"

TABLE_INIT_VA = 0x423097
INSERT_VA = 0x423142
LOOKUP_VA = 0x423259
ALLOCATOR_VA = 0x51DC43

PAGE_SIZE = 0x1000
STACK_BASE = 0x10000000
STACK_SIZE = 0x20000
STACK_TOP = STACK_BASE + STACK_SIZE // 2
HEAP_BASE = 0x20000000
HEAP_SIZE = 0x02000000
TABLE_VA = HEAP_BASE + 0x1000
KEY_VA = HEAP_BASE + 0x01000000
VALUE_VA = KEY_VA + 0x100
ALLOC_BASE = HEAP_BASE + 0x10000
ALLOC_LIMIT = KEY_VA - 0x1000
RETURN_VA = 0x30000000
MAX_VALUE_BUFFER = 40_000


class OracleError(RuntimeError):
    """The fixture was inconsistent or an original method did not return."""


def _read_cvtx_payload(resource: bytes) -> bytes:
    if len(resource) < 20 or resource[:4] != b"DATA":
        raise OracleError("AUTOTEXT fixture does not begin with a DATA record")
    data_size = int.from_bytes(resource[4:8], "big")
    if 8 + data_size != len(resource) or resource[8:12] != b"TEXT":
        raise OracleError("AUTOTEXT fixture is not one complete TEXT DATA record")
    offset = 12
    end = len(resource)
    found: bytes | None = None
    while offset < end:
        if end - offset < 8:
            raise OracleError("truncated AUTOTEXT chunk header")
        chunk_id = resource[offset : offset + 4]
        chunk_length = int.from_bytes(resource[offset + 4 : offset + 8], "big")
        payload_start = offset + 8
        payload_end = payload_start + chunk_length
        padded_end = payload_end + (chunk_length & 1)
        if payload_end > end or padded_end > end:
            raise OracleError("AUTOTEXT chunk extends beyond TEXT DATA record")
        if chunk_id == b"CVTX":
            if found is not None:
                raise OracleError("multiple CVTX chunks make fixture selection ambiguous")
            found = resource[payload_start:payload_end]
        offset = padded_end
    if found is None:
        raise OracleError("AUTOTEXT TEXT record has no CVTX chunk")
    return found


def parse_entries(payload: bytes) -> list[dict[str, Any]]:
    if len(payload) < 2:
        raise OracleError("CVTX record is missing the little-endian entry count")
    count = int.from_bytes(payload[:2], "little")
    offset = 2
    entries: list[dict[str, Any]] = []
    for index in range(count):
        if len(payload) - offset < 35:
            raise OracleError(f"CVTX entry {index} has a truncated header")
        key_field = payload[offset : offset + 33]
        key_end = key_field.find(b"\0")
        if key_end < 0:
            raise OracleError(f"CVTX entry {index} has no bounded key terminator")
        key = key_field[:key_end]
        raw_length = int.from_bytes(payload[offset + 33 : offset + 35], "little")
        value_offset = offset + 35
        value_end = value_offset + raw_length
        if value_end > len(payload):
            raise OracleError(f"CVTX entry {index} value exceeds payload bounds")
        raw_value = payload[value_offset:value_end]
        visible_length = raw_value.find(b"\0")
        if visible_length < 0:
            visible_length = raw_length
        if raw_length >= MAX_VALUE_BUFFER:
            raise OracleError(f"CVTX entry {index} exceeds the original zeroed 40000-byte buffer")
        entries.append(
            {
                "index": index,
                "key": key,
                "key_field": key_field,
                "raw_value": raw_value,
                "raw_value_length": raw_length,
                "caption_length": visible_length,
                "caption": raw_value[:visible_length],
            }
        )
        offset = value_end
    if offset != len(payload):
        raise OracleError("CVTX entry count does not consume the complete payload")
    return entries


class OriginalAutoText:
    """Bounded x86 runner for original table init/insert/lookup methods."""

    def __init__(self, executable: Path = DEFAULT_EXE) -> None:
        try:
            from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, UC_PROT_ALL, Uc
            from unicorn.x86_const import (
                UC_X86_REG_EAX,
                UC_X86_REG_EBP,
                UC_X86_REG_EBX,
                UC_X86_REG_ECX,
                UC_X86_REG_EDI,
                UC_X86_REG_EDX,
                UC_X86_REG_EFLAGS,
                UC_X86_REG_EIP,
                UC_X86_REG_ESI,
                UC_X86_REG_ESP,
            )
        except ImportError as exc:
            raise OracleError("Unicorn 2.x is required; use work/tools/oracle-python/bin/python") from exc

        self._reg = {
            "EAX": UC_X86_REG_EAX,
            "EBX": UC_X86_REG_EBX,
            "ECX": UC_X86_REG_ECX,
            "EDX": UC_X86_REG_EDX,
            "ESI": UC_X86_REG_ESI,
            "EDI": UC_X86_REG_EDI,
            "EBP": UC_X86_REG_EBP,
            "ESP": UC_X86_REG_ESP,
            "EIP": UC_X86_REG_EIP,
            "EFLAGS": UC_X86_REG_EFLAGS,
        }
        self._UcError: type[Exception] | None = None
        try:
            from unicorn import UcError

            self._UcError = UcError
        except ImportError:
            pass

        self.pe = PEImage.parse_and_map(executable.resolve())
        actual_hash = sha256(self.pe.data)
        if actual_hash != EXPECTED_EXE_SHA256:
            raise OracleError(f"GAME.EXE identity mismatch: {actual_hash}")

        self.machine = Uc(UC_ARCH_X86, UC_MODE_32)
        self.machine.mem_map(0, PAGE_SIZE, UC_PROT_ALL)
        image_base = self.pe.image_base & ~(PAGE_SIZE - 1)
        image_end = (self.pe.image_base + self.pe.size_of_image + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1)
        self.machine.mem_map(image_base, image_end - image_base, UC_PROT_ALL)
        self.machine.mem_write(self.pe.image_base, self.pe.image)
        self.machine.mem_map(STACK_BASE, STACK_SIZE, UC_PROT_ALL)
        self.machine.mem_map(HEAP_BASE, HEAP_SIZE, UC_PROT_ALL)
        self.machine.mem_map(RETURN_VA, PAGE_SIZE, UC_PROT_ALL)
        self.machine.mem_write(TABLE_VA, bytes(0x1000))
        self.machine.mem_write(KEY_VA, bytes(64))
        self.machine.mem_write(VALUE_VA, bytes(MAX_VALUE_BUFFER))
        self._allocator_cursor = ALLOC_BASE
        self._allocator_calls = 0
        self._hook_error: str | None = None
        self._uc_hook_code = UC_HOOK_CODE
        self.machine.hook_add(UC_HOOK_CODE, self._on_code, begin=ALLOCATOR_VA, end=ALLOCATOR_VA)

    def _return_from_intercepted_call(self, uc: Any) -> None:
        esp = uc.reg_read(self._reg["ESP"])
        return_address = struct.unpack("<I", uc.mem_read(esp, 4))[0]
        uc.reg_write(self._reg["ESP"], esp + 4)
        uc.reg_write(self._reg["EIP"], return_address)

    def _on_code(self, uc: Any, address: int, _size: int, _user_data: Any) -> None:
        if address != ALLOCATOR_VA:
            return
        esp = uc.reg_read(self._reg["ESP"])
        requested = struct.unpack("<I", uc.mem_read(esp + 4, 4))[0]
        start = (self._allocator_cursor + 3) & ~3
        end = start + requested
        if requested == 0 or end > ALLOC_LIMIT:
            self._hook_error = f"bounded bump allocator rejected {requested} bytes"
            uc.emu_stop()
            return
        uc.mem_write(start, bytes(requested))
        self._allocator_cursor = end
        self._allocator_calls += 1
        uc.reg_write(self._reg["EAX"], start)
        self._return_from_intercepted_call(uc)

    def _call(self, address: int, args: tuple[int, ...], this_pointer: int, label: str) -> int:
        self._hook_error = None
        stack_words = [RETURN_VA, *(value & 0xFFFFFFFF for value in args)]
        self.machine.mem_write(STACK_TOP, struct.pack("<" + "I" * len(stack_words), *stack_words))
        for name in ("EAX", "EBX", "EDX", "ESI", "EDI", "EBP"):
            self.machine.reg_write(self._reg[name], 0)
        self.machine.reg_write(self._reg["ECX"], this_pointer)
        self.machine.reg_write(self._reg["ESP"], STACK_TOP)
        self.machine.reg_write(self._reg["EIP"], address)
        self.machine.reg_write(self._reg["EFLAGS"], 0x202)
        try:
            self.machine.emu_start(address, RETURN_VA, timeout=20_000_000, count=50_000_000)
        except Exception as exc:
            raise OracleError(f"original {label} trapped at 0x{self.machine.reg_read(self._reg['EIP']):08x}: {exc}") from exc
        if self._hook_error:
            raise OracleError(self._hook_error)
        eip = self.machine.reg_read(self._reg["EIP"])
        if eip != RETURN_VA:
            raise OracleError(f"original {label} failed to return: EIP=0x{eip:08x}")
        expected_esp = STACK_TOP + 4 + 4 * len(args)
        actual_esp = self.machine.reg_read(self._reg["ESP"])
        if actual_esp != expected_esp:
            raise OracleError(
                f"original {label} stack delta {actual_esp - STACK_TOP}, expected {expected_esp - STACK_TOP}"
            )
        return self.machine.reg_read(self._reg["EAX"])

    def initialize(self) -> None:
        self._call(TABLE_INIT_VA, (), TABLE_VA, "caption table init")

    def insert(self, key_field: bytes, raw_value: bytes) -> None:
        if len(key_field) != 33 or b"\0" not in key_field:
            raise OracleError("original insert requires a terminated 33-byte key field")
        if len(raw_value) >= MAX_VALUE_BUFFER:
            raise OracleError("raw value exceeds original safe text buffer")
        # FUN_00411215 zeroes its 40000-byte stack array before copying exactly
        # the declared CVTX length. FUN_00423142 then copies it as a C string.
        self.machine.mem_write(KEY_VA, key_field)
        self.machine.mem_write(VALUE_VA, bytes(MAX_VALUE_BUFFER))
        if raw_value:
            self.machine.mem_write(VALUE_VA, raw_value)
        self._call(INSERT_VA, (KEY_VA, VALUE_VA), TABLE_VA, "caption entry insert")

    def lookup(self, key: bytes) -> bytes | None:
        if not key or len(key) >= 33 or b"\0" in key:
            raise ValueError("original lookup key must be a nonempty NUL-free byte string under 33 bytes")
        self.machine.mem_write(KEY_VA, key + b"\0")
        pointer = self._call(LOOKUP_VA, (KEY_VA,), TABLE_VA, "caption lookup")
        if pointer == 0:
            return None
        if not HEAP_BASE <= pointer < ALLOC_LIMIT:
            raise OracleError(f"original lookup returned pointer outside allocated arena: 0x{pointer:08x}")
        available = min(MAX_VALUE_BUFFER, ALLOC_LIMIT - pointer)
        result = bytes(self.machine.mem_read(pointer, available))
        terminator = result.find(b"\0")
        if terminator < 0:
            raise OracleError("original lookup value has no terminator within the bounded read")
        return result[:terminator]


def build_report() -> dict[str, Any]:
    resource = RESOURCE_PATH.read_bytes()
    resource_hash = sha256(resource)
    if resource_hash != EXPECTED_RESOURCE_SHA256:
        raise OracleError(f"AUTOTEXT resource hash mismatch: {resource_hash}")
    payload = _read_cvtx_payload(resource)
    entries = parse_entries(payload)
    machine = OriginalAutoText()
    machine.initialize()
    for entry in entries:
        machine.insert(entry["key_field"], entry["raw_value"])

    # The S0 9f sound request provides this key. Compare the return from the
    # shipped lookup code directly with the corresponding CVTX bytes.
    nsht_entry = next((item for item in entries if item["key"] == b"NSHT01"), None)
    if nsht_entry is None:
        raise OracleError("actual AUTOTEXT CVTX has no NSHT01 key")
    actual_nsht = machine.lookup(b"NSHT01")
    if actual_nsht != nsht_entry["caption"]:
        raise OracleError("original NSHT01 lookup differs from CVTX string-copy bytes")
    case_variant = machine.lookup(b"nsht01")
    if case_variant != actual_nsht:
        raise OracleError("original lookup did not match the ASCII case variant of NSHT01")

    groups: dict[bytes, list[dict[str, Any]]] = defaultdict(list)
    for entry in entries:
        groups[bytes(byte - 32 if 97 <= byte <= 122 else byte for byte in entry["key"])].append(entry)
    duplicate_groups = [group for group in groups.values() if len(group) > 1]
    duplicate_checks: list[dict[str, Any]] = []
    for group in duplicate_groups:
        first = group[0]
        actual = machine.lookup(first["key"])
        if actual != first["caption"]:
            raise OracleError("original lookup did not return the first value for a duplicate key")
        duplicate_checks.append(
            {
                "normalized_key_hex": bytes(
                    byte - 32 if 97 <= byte <= 122 else byte for byte in first["key"]
                ).hex(),
                "record_indexes": [entry["index"] for entry in group],
                "returned_record_index": first["index"],
            }
        )

    missing = machine.lookup(b"AUTOTEXT_MISSING_947")
    if missing is not None:
        raise OracleError("original lookup unexpectedly found the missing-key probe")

    fallback = b"Missing closed captioning text string<h><n><o>"
    exe_offset = 0x543310 - machine.pe.image_base
    original_fallback = machine.pe.image[exe_offset : exe_offset + len(fallback) + 1]
    if original_fallback != fallback + b"\0":
        raise OracleError("missing-caption fallback bytes differ from GAME.EXE literal")

    return {
        "executable_sha256": machine.pe and sha256(machine.pe.data),
        "resource_sha256": resource_hash,
        "resource_type": "AUTOTEXT/TEXT/CVTX",
        "cvtx_payload_length": len(payload),
        "entry_count": len(entries),
        "original_table_initializer_va": f"0x{TABLE_INIT_VA:08x}",
        "original_insert_va": f"0x{INSERT_VA:08x}",
        "original_lookup_va": f"0x{LOOKUP_VA:08x}",
        "original_allocator_hook_va": f"0x{ALLOCATOR_VA:08x}",
        "allocator_calls": machine._allocator_calls,
        "nls_mode": "ASCII only; NLS uppercase branch not executed",
        "nsht01": {
            "found": True,
            "raw_payload_length": nsht_entry["raw_value_length"],
            "caption_length": len(actual_nsht),
            "caption_sha256": hashlib.sha256(actual_nsht).hexdigest(),
            "ascii_case_variant_matches": True,
        },
        "duplicate_groups": duplicate_checks,
        "missing_probe": {"found": False, "lookup_return": "NULL"},
        "missing_caption_fallback": {
            "source_va": "0x00543310",
            "bytes_hex": fallback.hex(),
            "byte_length": len(fallback),
            "terminator_in_binary": True,
            "caller_copy_bytes": 47,
            "caller_source": "FUN_0041c7f4, branches with DAT_0063a4cd == 0",
        },
        "execution_scope": (
            "Original GAME.EXE table init/insert/lookup routines only; one bounded allocator hook; "
            "no game launch, file/window/audio API, or caption renderer."
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("verify",), nargs="?", default="verify")
    args = parser.parse_args()
    if args.command == "verify":
        print(json.dumps(build_report(), indent=2, sort_keys=True))
        return 0
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
