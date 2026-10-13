#!/usr/bin/env python3
"""Execute the original x86 CHiff index/selection routines under Unicorn.

Only the shipped GAME.EXE is executed.  The harness maps its PE image and
provides an isolated object, input buffer, and stack; it does not launch the
game or call Windows APIs.  This is an oracle for the recovered CHiff methods,
not evidence of whole-game equivalence.

Examples (from the workspace root)::

    work/tools/oracle-python/bin/python outputs/blackmoor-decomp/tests/hiff_original_oracle.py boot
    work/tools/oracle-python/bin/python outputs/blackmoor-decomp/tests/hiff_original_oracle.py benchmark
    work/tools/oracle-python/bin/python outputs/blackmoor-decomp/tests/hiff_original_oracle.py compare --native-library outputs/blackmoor-decomp/build/libhiff.dylib
    work/tools/oracle-python/bin/python outputs/blackmoor-decomp/tests/hiff_original_oracle.py full-compare --native-library outputs/blackmoor-decomp/build/libhiff.dylib

The benchmark is deliberately bounded.  Full comparison reports every
resource in the supplied decoded type-3 corpus, including exact exclusions.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import struct
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_MANIFEST = ROOT / "work/analysis/hiff-resources.json"
DEFAULT_ANALYSIS_DIR = ROOT / "work/analysis"
DEFAULT_BOOT = ROOT / "work/analysis/cif-boot-native.bin"
EXPECTED_EXE_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"

CREATE_DATA_VA = 0x433EAA
CREATE_CHUNK_VA = 0x434025
SELECT_DATA_VA = 0x43423D
SELECT_CHUNK_VA = 0x4343A2
FIRST_CHUNK_VA = 0x4344BF
NEXT_CHUNK_VA = 0x434630
DATA_MARKER_VA = 0x434773
READ_BE32_VA = 0x4347B8
COPY_TAG_VA = 0x434814
FATAL_REPORT_VA = 0x42639D
FATAL_EXIT_VA = 0x4C97B4

STACK_BASE = 0x1000
STACK_SIZE = 0xF000
HEAP_BASE = 0x20000000
SENTINEL_VA = 0x51000000
PAGE_SIZE = 0x1000
OBJECT_SIZE = 0x7000
DEFAULT_TIMEOUT_US = 30_000_000
DEFAULT_INSTRUCTION_LIMIT = 100_000_000
TABLE_CAPACITY = 999


class OracleError(RuntimeError):
    """Original executable trapped, exhausted a budget, or violated setup."""


class FormatError(ValueError):
    """Input executable or resource manifest is inconsistent."""


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _decode_c_string(value: bytes | bytearray) -> str:
    return bytes(value).split(b"\0", 1)[0].decode("latin-1")


def align_up(value: int, alignment: int = PAGE_SIZE) -> int:
    return (value + alignment - 1) & ~(alignment - 1)


@dataclass(frozen=True)
class PESection:
    name: str
    virtual_address: int
    virtual_size: int
    raw_offset: int
    raw_size: int


@dataclass(frozen=True)
class PEImage:
    data: bytes
    image_base: int
    size_of_image: int
    size_of_headers: int
    sections: tuple[PESection, ...]
    image: bytes

    @classmethod
    def parse_and_map(cls, path: Path) -> "PEImage":
        data = path.read_bytes()
        if len(data) < 0x40 or data[:2] != b"MZ":
            raise FormatError(f"not an MZ executable: {path}")
        pe_offset = struct.unpack_from("<I", data, 0x3C)[0]
        if pe_offset + 24 > len(data) or data[pe_offset : pe_offset + 4] != b"PE\0\0":
            raise FormatError("invalid PE signature or truncated PE header")
        coff_offset = pe_offset + 4
        machine, section_count, _timestamp, _sym, _nsyms, optional_size, _chars = struct.unpack_from(
            "<HHIIIHH", data, coff_offset
        )
        if machine != 0x14C:
            raise FormatError(f"expected x86 PE32 (machine 0x14c), got 0x{machine:x}")
        optional_offset = coff_offset + 20
        if optional_offset + optional_size > len(data):
            raise FormatError("truncated PE optional header")
        if struct.unpack_from("<H", data, optional_offset)[0] != 0x10B:
            raise FormatError("expected PE32 optional header")
        image_base = struct.unpack_from("<I", data, optional_offset + 28)[0]
        size_of_image = struct.unpack_from("<I", data, optional_offset + 56)[0]
        size_of_headers = struct.unpack_from("<I", data, optional_offset + 60)[0]
        if not size_of_image or size_of_image > 0x40000000:
            raise FormatError(f"implausible PE image size 0x{size_of_image:x}")
        if size_of_headers > len(data) or size_of_headers > size_of_image:
            raise FormatError("invalid PE header mapping size")

        section_table = optional_offset + optional_size
        if section_table + section_count * 40 > len(data):
            raise FormatError("truncated PE section table")
        image = bytearray(size_of_image)
        image[:size_of_headers] = data[:size_of_headers]
        sections: list[PESection] = []
        for index in range(section_count):
            record = data[section_table + index * 40 : section_table + (index + 1) * 40]
            name = record[:8].split(b"\0", 1)[0].decode("ascii", "replace")
            virtual_size, virtual_address, raw_size, raw_offset = struct.unpack_from("<IIII", record, 8)
            if raw_offset + raw_size > len(data):
                raise FormatError(f"section {name!r} raw bytes exceed executable")
            if virtual_address + max(virtual_size, raw_size) > size_of_image:
                raise FormatError(f"section {name!r} exceeds SizeOfImage")
            if raw_size:
                image[virtual_address : virtual_address + raw_size] = data[raw_offset : raw_offset + raw_size]
            sections.append(PESection(name, virtual_address, virtual_size, raw_offset, raw_size))
        return cls(data, image_base, size_of_image, size_of_headers, tuple(sections), bytes(image))


@dataclass(frozen=True)
class OriginalData:
    index: int
    marker_address: int
    name: str
    declared_size: int
    table_size: int
    content_address: int
    content_size: int


@dataclass(frozen=True)
class OriginalChunk:
    index: int
    address: int
    data_owner: int
    name: str
    declared_size: int
    aligned_size: int
    content_address: int


@dataclass(frozen=True)
class OriginalIndex:
    datas: tuple[OriginalData, ...]
    chunks: tuple[OriginalChunk, ...]
    elapsed_seconds: float


class NativeDataInfo(ctypes.Structure):
    _fields_ = [
        ("record_offset", ctypes.c_size_t),
        ("type_offset", ctypes.c_size_t),
        ("body_offset", ctypes.c_size_t),
        ("extent_size", ctypes.c_size_t),
        ("declared_size", ctypes.c_uint32),
        ("type", ctypes.c_char * 5),
    ]


class NativeChunkInfo(ctypes.Structure):
    _fields_ = [
        ("data_index", ctypes.c_size_t),
        ("header_offset", ctypes.c_size_t),
        ("payload_offset", ctypes.c_size_t),
        ("padded_extent_size", ctypes.c_size_t),
        ("payload_size", ctypes.c_uint32),
        ("id", ctypes.c_char * 5),
    ]


class NativeSelectionInfo(ctypes.Structure):
    _fields_ = [
        ("kind", ctypes.c_int),
        ("index", ctypes.c_size_t),
        ("data_index", ctypes.c_size_t),
        ("record_offset", ctypes.c_size_t),
        ("header_offset", ctypes.c_size_t),
        ("payload_offset", ctypes.c_size_t),
        ("length", ctypes.c_size_t),
        ("name", ctypes.c_char * 5),
    ]


class NativeHIFF:
    """Small ctypes owner for the recovered C API and its copied input."""

    def __init__(self, lib: ctypes.CDLL, payload: bytes, label: str) -> None:
        self.lib = lib
        self.label = label
        self.source = (ctypes.c_uint8 * max(1, len(payload))).from_buffer_copy(payload or b"\0")
        error = ctypes.create_string_buffer(512)
        self.handle = lib.hiff_open_memory(
            ctypes.cast(self.source, ctypes.c_void_p), len(payload), error, len(error)
        )
        if not self.handle:
            self.error = error.value.decode("utf-8", "replace") or "hiff_open_memory returned NULL"
            raise OracleError(self.error)
        self.error = ""

    def close(self) -> None:
        if self.handle:
            self.lib.hiff_close(self.handle)
            self.handle = None

    def counts(self) -> tuple[int, int]:
        return int(self.lib.hiff_data_count(self.handle)), int(self.lib.hiff_chunk_count(self.handle))

    def data_rows(self) -> list[dict[str, Any]]:
        rows: list[dict[str, Any]] = []
        count = int(self.lib.hiff_data_count(self.handle))
        for index in range(count):
            info = NativeDataInfo()
            status = self.lib.hiff_data_at(self.handle, index, ctypes.byref(info))
            if status != 0:
                raise OracleError(f"hiff_data_at({index}) returned status {status} for {self.label}")
            rows.append(
                {
                    "record_offset": int(info.record_offset),
                    "type_offset": int(info.type_offset),
                    "body_offset": int(info.body_offset),
                    "extent_size": int(info.extent_size),
                    "declared_size": int(info.declared_size),
                    "type": _decode_c_string(info.type),
                }
            )
        return rows

    def chunk_rows(self) -> list[dict[str, Any]]:
        rows: list[dict[str, Any]] = []
        count = int(self.lib.hiff_chunk_count(self.handle))
        for index in range(count):
            info = NativeChunkInfo()
            status = self.lib.hiff_chunk_at(self.handle, index, ctypes.byref(info))
            if status != 0:
                raise OracleError(f"hiff_chunk_at({index}) returned status {status} for {self.label}")
            rows.append(
                {
                    "data_index": int(info.data_index),
                    "header_offset": int(info.header_offset),
                    "payload_offset": int(info.payload_offset),
                    "padded_extent_size": int(info.padded_extent_size),
                    "payload_size": int(info.payload_size),
                    "id": _decode_c_string(info.id),
                }
            )
        return rows

    def select(self, operation: str, name: str) -> tuple[int, dict[str, Any] | None]:
        encoded = name.encode("latin-1") + b"\0"
        operations = {
            "select_data": self.lib.hiff_select_data,
            "select_chunk": self.lib.hiff_select_chunk,
            "first": self.lib.hiff_select_first,
            "next": self.lib.hiff_select_next,
        }
        try:
            function = operations[operation]
        except KeyError as exc:
            raise OracleError(f"unknown native selection operation {operation}") from exc
        status = int(function(self.handle, encoded))
        return status, None

    def selected(self, kind: str) -> dict[str, Any] | None:
        byte_pointer = ctypes.c_void_p()
        length = ctypes.c_size_t()
        info = NativeSelectionInfo()
        getter = self.lib.hiff_get_selected_data if kind == "data" else self.lib.hiff_get_selected_chunk
        status = int(getter(self.handle, ctypes.byref(byte_pointer), ctypes.byref(length), ctypes.byref(info)))
        if status == 6:  # HIFF_ERR_NOT_FOUND
            return None
        if status != 0:
            raise OracleError(f"native selected-{kind} getter returned status {status} for {self.label}")
        content = ctypes.string_at(byte_pointer, length.value) if length.value else b""
        return {
            "kind": int(info.kind),
            "index": int(info.index),
            "data_index": int(info.data_index),
            "record_offset": int(info.record_offset),
            "header_offset": int(info.header_offset),
            "payload_offset": int(info.payload_offset),
            "length": int(info.length),
            "name": _decode_c_string(info.name),
            "bytes": content,
        }


class OriginalCHiff:
    """Persistent Unicorn x86 machine executing the original CHiff methods."""

    def __init__(
        self,
        exe_path: Path = DEFAULT_EXE,
        *,
        timeout_us: int = DEFAULT_TIMEOUT_US,
        instruction_limit: int = DEFAULT_INSTRUCTION_LIMIT,
    ) -> None:
        try:
            from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_PROT_ALL, UC_HOOK_CODE
            from unicorn.x86_const import (
                UC_X86_REG_EAX,
                UC_X86_REG_EBP,
                UC_X86_REG_EBX,
                UC_X86_REG_ECX,
                UC_X86_REG_EDX,
                UC_X86_REG_EFLAGS,
                UC_X86_REG_EIP,
                UC_X86_REG_ESP,
                UC_X86_REG_ESI,
                UC_X86_REG_EDI,
                UC_X86_REG_ES,
            )
        except ImportError as exc:
            raise OracleError("Unicorn 2.x is required; run with work/tools/oracle-python/bin/python") from exc

        self.reg = {
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
            "ES": UC_X86_REG_ES,
        }
        self.UC_PROT_ALL = UC_PROT_ALL
        self.UC_HOOK_CODE = UC_HOOK_CODE
        self.pe = PEImage.parse_and_map(exe_path.resolve())
        actual_hash = sha256(self.pe.data)
        if actual_hash != EXPECTED_EXE_SHA256:
            raise OracleError(f"GAME.EXE hash mismatch: {actual_hash}")

        image_start = self.pe.image_base & ~(PAGE_SIZE - 1)
        image_end = align_up(self.pe.image_base + self.pe.size_of_image)
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(image_start, image_end - image_start, UC_PROT_ALL)
        self.uc.mem_write(self.pe.image_base, self.pe.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE, UC_PROT_ALL)
        self.stack_pointer = STACK_BASE + STACK_SIZE // 2
        self.timeout_us = timeout_us
        self.instruction_limit = instruction_limit
        self.heap_size = 0
        self.object_address = 0
        self.input_address = HEAP_BASE
        self.name_address = 0
        self._fatal: str | None = None
        self._calls = 0
        self.uc.hook_add(self.UC_HOOK_CODE, self._on_code)
        self.uc.reg_write(self.reg["ES"], 0)

    def _on_code(self, uc: Any, address: int, size: int, _user_data: Any) -> None:
        if address in (FATAL_REPORT_VA, FATAL_EXIT_VA):
            self._fatal = f"original fatal/error path at 0x{address:08x}"
            uc.emu_stop()

    def _prepare_input(self, payload: bytes) -> None:
        object_offset = align_up(max(1, len(payload)) + 0x1000)
        object_offset = max(0x10000, object_offset)
        required = align_up(object_offset + OBJECT_SIZE + 0x10000)
        if required > self.heap_size:
            if self.heap_size:
                self.uc.mem_map(HEAP_BASE + self.heap_size, required - self.heap_size, self.UC_PROT_ALL)
            else:
                self.uc.mem_map(HEAP_BASE, required, self.UC_PROT_ALL)
            self.heap_size = required
        self.object_address = HEAP_BASE + object_offset
        self.name_address = self.object_address + OBJECT_SIZE + 0x100
        self.uc.mem_write(HEAP_BASE, payload if payload else b"\0")
        self.uc.mem_write(self.object_address, bytes(OBJECT_SIZE))
        self.uc.mem_write(self.name_address, bytes(0x100))
        self._write_u32(self.object_address + 0x1118, HEAP_BASE)
        self._write_u32(self.object_address + 0x1124, len(payload))

    def _read_u32(self, address: int) -> int:
        return struct.unpack("<I", self.uc.mem_read(address, 4))[0]

    def _write_u32(self, address: int, value: int) -> None:
        self.uc.mem_write(address, struct.pack("<I", value & 0xFFFFFFFF))

    def _call(self, address: int, args: tuple[int, ...] = (), *, label: str) -> tuple[int, float]:
        self._fatal = None
        esp = self.stack_pointer
        stack = struct.pack("<I" + "I" * len(args), SENTINEL_VA, *args)
        self.uc.mem_write(esp, stack)
        for register in ("EAX", "EBX", "ECX", "EDX", "ESI", "EDI", "EBP"):
            self.uc.reg_write(self.reg[register], 0)
        self.uc.reg_write(self.reg["ECX"], self.object_address)
        self.uc.reg_write(self.reg["ESP"], esp)
        self.uc.reg_write(self.reg["EIP"], address)
        self.uc.reg_write(self.reg["EFLAGS"], 0x202)
        started = time.perf_counter()
        try:
            self.uc.emu_start(address, SENTINEL_VA, timeout=self.timeout_us, count=self.instruction_limit)
        except Exception as exc:
            raise OracleError(f"original CHiff trap in {label}: {type(exc).__name__}: {exc}") from exc
        elapsed = time.perf_counter() - started
        eip = self.uc.reg_read(self.reg["EIP"])
        if self._fatal:
            raise OracleError(f"{self._fatal} while executing {label}")
        if eip != SENTINEL_VA:
            raise OracleError(
                f"original CHiff did not return from {label}: EIP=0x{eip:x}; "
                f"instruction limit={self.instruction_limit}, timeout={self.timeout_us}us"
            )
        esp_after = self.uc.reg_read(self.reg["ESP"])
        expected_delta = 4 + len(args) * 4
        if esp_after != esp + expected_delta:
            raise OracleError(
                f"unexpected thiscall stack cleanup in {label}: "
                f"ESP delta={esp_after - esp}, expected {expected_delta}"
            )
        self._calls += 1
        return self.uc.reg_read(self.reg["EAX"]), elapsed

    def index(self, payload: bytes, *, label: str = "resource") -> OriginalIndex:
        self._prepare_input(payload)
        started = time.perf_counter()
        self._call(CREATE_DATA_VA, label=f"{label}:CreateDATADatabase")
        data_count = self._read_u32(self.object_address + 0x5F64)
        if data_count > TABLE_CAPACITY:
            raise OracleError(f"original DATA count {data_count} exceeds expected table cap in {label}")
        data_rows: list[OriginalData] = []
        for index in range(data_count):
            marker = self._read_u32(self.object_address + 0x1144 + index * 4)
            table_size = self._read_u32(self.object_address + 0x3084 + index * 4)
            relative = marker - HEAP_BASE
            if relative < 0 or relative + 12 > len(payload):
                raise OracleError(f"original DATA pointer {index} is outside {label}")
            if payload[relative : relative + 4] != b"DATA":
                raise OracleError(f"original DATA pointer {index} lacks marker bytes in {label}")
            declared_size = int.from_bytes(payload[relative + 4 : relative + 8], "big")
            raw_name = payload[relative + 8 : relative + 12]
            name = raw_name.split(b"\0", 1)[0].decode("latin-1")
            content_size = max(0, declared_size - 4)
            data_rows.append(
                OriginalData(
                    index,
                    marker,
                    name,
                    declared_size,
                    table_size,
                    marker + 12,
                    content_size,
                )
            )

        self._call(CREATE_CHUNK_VA, label=f"{label}:CreateChunkDatabase")
        chunk_count = self._read_u32(self.object_address + 0x5F68)
        if chunk_count > TABLE_CAPACITY:
            raise OracleError(f"original CHUNK count {chunk_count} exceeds expected table cap in {label}")
        chunks: list[OriginalChunk] = []
        for index in range(chunk_count):
            address = self._read_u32(self.object_address + 0x20E4 + index * 4)
            relative = address - HEAP_BASE
            if relative < 0 or relative + 8 > len(payload):
                raise OracleError(f"original CHUNK pointer {index} is outside {label}")
            raw_name = payload[relative : relative + 4]
            name = raw_name.split(b"\0", 1)[0].decode("latin-1")
            declared_size = int.from_bytes(payload[relative + 4 : relative + 8], "big")
            aligned = declared_size + (declared_size & 1)
            chunks.append(
                OriginalChunk(
                    index,
                    address,
                    self._find_data_owner(address, data_rows),
                    name,
                    declared_size,
                    aligned,
                    address + 8,
                )
            )
        return OriginalIndex(tuple(data_rows), tuple(chunks), time.perf_counter() - started)

    def _find_data_owner(self, chunk_address: int, datas: list[OriginalData]) -> int:
        # The original indexer flattens nested DATA records into the parent
        # scan.  Address ranges provide a stable provenance tag for the oracle.
        for data in datas:
            start = data.content_address
            end = start + data.content_size
            if start <= chunk_address < end:
                return data.index
        return -1

    def select_data(self, name: str, *, label: str = "select-data") -> dict[str, Any]:
        return self._select(name, SELECT_DATA_VA, label, "data")

    def select_chunk(self, name: str, *, label: str = "select-chunk") -> dict[str, Any]:
        return self._select(name, SELECT_CHUNK_VA, label, "chunk")

    def _select(self, name: str, address: int, label: str, kind: str) -> dict[str, Any]:
        encoded = name.encode("latin-1")
        if b"\0" in encoded or len(encoded) >= 0x100:
            raise ValueError("original selector names must be NUL-free byte strings under 256 bytes")
        self.uc.mem_write(self.name_address, encoded + b"\0")
        before = self.selection_snapshot()
        eax, elapsed = self._call(address, (self.name_address,), label=f"{label}:{name!r}")
        return {
            "found": bool(eax),
            "kind": kind,
            "name": name,
            "before": before,
            "after": self.selection_snapshot(),
            "elapsed_seconds": elapsed,
        }

    def first_chunk(self, name: str, *, label: str = "first-chunk") -> dict[str, Any]:
        return self._iteration(name, FIRST_CHUNK_VA, label)

    def next_chunk(self, name: str, *, label: str = "next-chunk") -> dict[str, Any]:
        return self._iteration(name, NEXT_CHUNK_VA, label)

    def _iteration(self, name: str, address: int, label: str) -> dict[str, Any]:
        encoded = name.encode("latin-1")
        if b"\0" in encoded or len(encoded) >= 0x100:
            raise ValueError("original selector names must be NUL-free byte strings under 256 bytes")
        self.uc.mem_write(self.name_address, encoded + b"\0")
        before = self.selection_snapshot()
        eax, elapsed = self._call(address, (self.name_address,), label=f"{label}:{name!r}")
        return {
            "found": bool(eax),
            "kind": "chunk",
            "name": name,
            "before": before,
            "after": self.selection_snapshot(),
            "elapsed_seconds": elapsed,
        }

    def selection_snapshot(self) -> dict[str, Any]:
        data_pointer = self._read_u32(self.object_address + 0x111C)
        chunk_pointer = self._read_u32(self.object_address + 0x1120)
        return {
            "data": {
                "pointer": data_pointer,
                "size": self._read_u32(self.object_address + 0x1128),
                "name": self.read_selected_name(0x1136),
            },
            "chunk": {
                "pointer": chunk_pointer,
                "size": self._read_u32(self.object_address + 0x112C),
                "name": self.read_selected_name(0x1130),
            },
        }

    def read_selected_name(self, offset: int) -> str:
        return bytes(self.uc.mem_read(self.object_address + offset, 4)).split(b"\0", 1)[0].decode("latin-1")


def _original_report(
    payload: bytes, label: str, machine: OriginalCHiff | None = None
) -> tuple[OriginalIndex, dict[str, Any]]:
    machine = machine or OriginalCHiff()
    index = machine.index(payload, label=label)
    data_rows = [
        {
            "index": row.index,
            "name": row.name,
            "marker_offset": row.marker_address - HEAP_BASE,
            "declared_size": row.declared_size,
            "table_size": row.table_size,
            "content_offset": row.content_address - HEAP_BASE,
            "content_size": row.content_size,
        }
        for row in index.datas
    ]
    chunk_rows: list[dict[str, Any]] = []
    chunk_name_counts: dict[str, int] = {}
    for row in index.chunks:
        chunk_name_counts[row.name] = chunk_name_counts.get(row.name, 0) + 1

    selection_traces: list[dict[str, Any]] = []
    unique_data_names = list(dict.fromkeys(row.name for row in index.datas))
    for name in unique_data_names:
        result = machine.select_data(name, label=f"{label}:select-data")
        first_row = next(row for row in index.datas if row.name == name)
        after_data = result["after"]["data"]
        expected = (first_row.content_address, first_row.content_size, first_row.name)
        actual = (after_data["pointer"], after_data["size"], after_data["name"])
        if not result["found"] or actual != expected:
            raise OracleError(f"original DATA selector disagrees for {name!r} in {label}: got {actual!r}, expected {expected!r}")
        selection_traces.append({"operation": "select_data", **result})
    missing_data = _missing_name(unique_data_names)
    before_miss = machine.selection_snapshot()
    missing = machine.select_data(missing_data, label=f"{label}:select-data-miss")
    if missing["found"] or missing["after"] != before_miss:
        raise OracleError(f"original failed DATA selection changed state in {label}: {missing!r}")
    selection_traces.append({"operation": "select_data_miss", **missing})

    unique_chunk_names = list(dict.fromkeys(row.name for row in index.chunks))
    for name in unique_chunk_names:
        result = machine.select_chunk(name, label=f"{label}:select-chunk")
        first_row = next(row for row in index.chunks if row.name == name)
        after_chunk = result["after"]["chunk"]
        expected = (first_row.content_address, first_row.declared_size, first_row.name)
        actual = (after_chunk["pointer"], after_chunk["size"], after_chunk["name"])
        if not result["found"] or actual != expected:
            raise OracleError(f"original CHUNK selector disagrees for {name!r} in {label}: got {actual!r}, expected {expected!r}")
        selection_traces.append({"operation": "select_chunk", **result})
    missing_chunk = _missing_name(unique_chunk_names)
    before_miss = machine.selection_snapshot()
    missing = machine.select_chunk(missing_chunk, label=f"{label}:select-chunk-miss")
    if missing["found"] or missing["after"] != before_miss:
        raise OracleError(f"original failed CHUNK selection changed state in {label}: {missing!r}")
    selection_traces.append({"operation": "select_chunk_miss", **missing})

    for name, count in sorted(chunk_name_counts.items()):
        first = machine.first_chunk(name, label=f"{label}:first")
        found = []
        if first["found"]:
            found.append(first)
            for _ in range(count - 1):
                nxt = machine.next_chunk(name, label=f"{label}:next")
                if not nxt["found"]:
                    raise OracleError(f"original NextChunk stopped early for {name!r} in {label}")
                found.append(nxt)
            extra = machine.next_chunk(name, label=f"{label}:next-end")
            if extra["found"]:
                raise OracleError(f"original NextChunk returned more than {count} {name!r} chunks in {label}")
            if extra["after"] != extra["before"]:
                raise OracleError(f"original exhausted NextChunk changed selected state for {name!r} in {label}")
        elif count:
            raise OracleError(f"original FirstChunk failed to select known indexed tag {name!r} in {label}")
        elif first["after"] != first["before"]:
            raise OracleError(f"original missing FirstChunk changed selected state for {name!r} in {label}")
        expected = [row for row in index.chunks if row.name == name]
        for ordinal, (actual, expected_row) in enumerate(zip(found, expected, strict=True)):
            state = actual["after"]["chunk"]
            if state["pointer"] != expected_row.content_address or state["size"] != expected_row.declared_size or state["name"] != expected_row.name:
                raise OracleError(
                    f"original duplicate iteration order mismatch for {name!r} #{ordinal} in {label}: "
                    f"got {state!r}, expected payload offset={expected_row.content_address - HEAP_BASE} "
                    f"size={expected_row.declared_size}"
                )
        selection_traces.append({"operation": "first_next_sequence", "name": name, "steps": found, "end": extra if first["found"] else None})
        chunk_rows.extend(
            {
                "index": row.index,
                "name": row.name,
                "offset": row.address - HEAP_BASE,
                "first_containing_data_index_inferred": row.data_owner,
                "declared_size": row.declared_size,
                "aligned_size": row.aligned_size,
                "content_offset": row.content_address - HEAP_BASE,
                "selected_by_iteration": True,
            }
            for row in index.chunks
        )
    report = {
        "label": label,
        "input_size": len(payload),
        "input_sha256": sha256(payload),
        "data_count": len(index.datas),
        "chunk_count": len(index.chunks),
        "data_names": [row.name for row in index.datas],
        "chunk_names": [row.name for row in index.chunks],
        "data": data_rows,
        "chunks": chunk_rows,
        "selection_traces": selection_traces,
        "index_elapsed_seconds": round(index.elapsed_seconds, 6),
    }
    return index, report


def _missing_name(existing: Iterable[str]) -> str:
    names = set(existing)
    for candidate in ("~!~!", "!~!~", "ZZZ~", "~ZZZ", "####", "????", "NOPE"):
        if candidate not in names:
            return candidate
    for value in range(1, 256):
        candidate = chr(value) * 4
        if candidate not in names:
            return candidate
    for left in range(1, 256):
        for right in range(1, 256):
            candidate = chr(left) + chr(right) + chr(left) + chr(right)
            if candidate not in names:
                return candidate
    raise OracleError("could not find a missing four-byte selector name")


def _load_manifest(path: Path) -> list[dict[str, Any]]:
    try:
        document = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as exc:
        raise FormatError(f"could not read decoded-resource manifest {path}: {exc}") from exc
    rows = document.get("resources")
    if not isinstance(rows, list):
        raise FormatError("resource manifest has no resources array")
    previous_index = -1
    for row in rows:
        if not isinstance(row, dict) or not isinstance(row.get("index"), int):
            raise FormatError("resource manifest contains a malformed row")
        if row["index"] <= previous_index:
            raise FormatError("resource manifest must be in strictly increasing archive-record order")
        previous_index = row["index"]
    return rows


def _load_resource(row: dict[str, Any], manifest: Path) -> bytes:
    declared_path = Path(str(row.get("path", "")))
    path = declared_path if declared_path.is_absolute() else manifest.parent / declared_path
    if not path.is_file():
        # The manifest may have been produced from a different checkout root.
        path = manifest.parent / "hiff-resources" / f"{int(row['index']):04d}.bin"
    payload = path.read_bytes()
    if len(payload) != int(row["size"]):
        raise FormatError(f"resource {row.get('index')} size mismatch: {len(payload)} != {row['size']}")
    digest = sha256(payload)
    if digest != row["sha256"]:
        raise FormatError(f"resource {row.get('index')} sha256 mismatch: {digest} != {row['sha256']}")
    return payload


def _benchmark_rows(rows: list[dict[str, Any]], *, count: int = 12) -> list[dict[str, Any]]:
    eligible = [row for row in rows if bool(row.get("starts_with_DATA"))]
    if not eligible:
        return []
    by_name = {str(row.get("name", "")).upper(): row for row in eligible}
    chosen: list[dict[str, Any]] = []
    for name in ("AUTOTEXT", "BOOT", "CONVO"):
        if name in by_name:
            chosen.append(by_name[name])
    # Add even-spaced samples in record order to cover data-size and nesting
    # variation while keeping the first validation run bounded.
    if len(eligible) > len(chosen):
        sample_count = max(0, count - len(chosen))
        for slot in range(sample_count):
            index = round(slot * (len(eligible) - 1) / max(1, sample_count - 1))
            chosen.append(eligible[index])
    result: list[dict[str, Any]] = []
    seen: set[int] = set()
    for row in chosen:
        key = int(row["index"])
        if key not in seen:
            seen.add(key)
            result.append(row)
        if len(result) >= count:
            break
    return result


def _native_bindings(path: Path) -> ctypes.CDLL:
    try:
        lib = ctypes.CDLL(str(path.resolve()))
    except OSError as exc:
        raise OracleError(f"could not load native HIFF library {path}: {exc}") from exc
    expected = (
        "hiff_open_memory",
        "hiff_close",
        "hiff_data_count",
        "hiff_chunk_count",
        "hiff_data_at",
        "hiff_chunk_at",
        "hiff_select_data",
        "hiff_select_chunk",
        "hiff_select_first",
        "hiff_select_next",
        "hiff_get_selected_data",
        "hiff_get_selected_chunk",
    )
    missing = [name for name in expected if not hasattr(lib, name)]
    if missing:
        raise OracleError(f"native HIFF ABI is missing exported symbols: {', '.join(missing)}")
    handle = ctypes.c_void_p
    lib.hiff_open_memory.argtypes = [handle, ctypes.c_size_t, ctypes.c_void_p, ctypes.c_size_t]
    lib.hiff_open_memory.restype = handle
    lib.hiff_close.argtypes = [handle]
    lib.hiff_close.restype = None
    for symbol in ("hiff_data_count", "hiff_chunk_count"):
        function = getattr(lib, symbol)
        function.argtypes = [handle]
        function.restype = ctypes.c_size_t
    lib.hiff_data_at.argtypes = [handle, ctypes.c_size_t, ctypes.POINTER(NativeDataInfo)]
    lib.hiff_data_at.restype = ctypes.c_int
    lib.hiff_chunk_at.argtypes = [handle, ctypes.c_size_t, ctypes.POINTER(NativeChunkInfo)]
    lib.hiff_chunk_at.restype = ctypes.c_int
    for symbol in ("hiff_select_data", "hiff_select_chunk", "hiff_select_first", "hiff_select_next"):
        function = getattr(lib, symbol)
        function.argtypes = [handle, ctypes.c_char_p]
        function.restype = ctypes.c_int
    for symbol in ("hiff_get_selected_data", "hiff_get_selected_chunk"):
        function = getattr(lib, symbol)
        function.argtypes = [
            handle,
            ctypes.POINTER(ctypes.c_void_p),
            ctypes.POINTER(ctypes.c_size_t),
            ctypes.POINTER(NativeSelectionInfo),
        ]
        function.restype = ctypes.c_int
    return lib


def _original_data_rows(index: OriginalIndex) -> list[dict[str, Any]]:
    return [
        {
            "record_offset": row.marker_address - HEAP_BASE,
            "type_offset": row.marker_address - HEAP_BASE + 8,
            "body_offset": row.content_address - HEAP_BASE,
            "extent_size": row.table_size,
            "declared_size": row.declared_size,
            "type": row.name,
        }
        for row in index.datas
    ]


def _original_chunk_rows(index: OriginalIndex) -> list[dict[str, Any]]:
    return [
        {
            "header_offset": row.address - HEAP_BASE,
            "payload_offset": row.content_address - HEAP_BASE,
            "padded_extent_size": 8 + row.aligned_size,
            "payload_size": row.declared_size,
            "id": row.name,
        }
        for row in index.chunks
    ]


def _rows_sha256(rows: list[dict[str, Any]]) -> str:
    canonical = json.dumps(rows, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return sha256(canonical)


def _compare_rows(
    category: str,
    original: list[dict[str, Any]],
    native: list[dict[str, Any]],
    *,
    mismatch_limit: int = 40,
) -> tuple[int, list[dict[str, Any]]]:
    mismatch_count = 0
    mismatches: list[dict[str, Any]] = []
    if len(original) != len(native):
        mismatch_count += 1
        mismatches.append(
            {"category": category, "field": "row_count", "original": len(original), "native": len(native)}
        )
    for row_index, (original_row, native_row) in enumerate(zip(original, native)):
        for field, expected in original_row.items():
            actual = native_row.get(field)
            if expected != actual:
                mismatch_count += 1
                if len(mismatches) < mismatch_limit:
                    mismatches.append(
                        {
                            "category": category,
                            "row_index": row_index,
                            "field": field,
                            "original": expected,
                            "native": actual,
                        }
                    )
    return mismatch_count, mismatches


def _compare_native_tables(index: OriginalIndex, native: NativeHIFF) -> dict[str, Any]:
    original_data = _original_data_rows(index)
    native_data = native.data_rows()
    original_chunks = _original_chunk_rows(index)
    native_chunks_full = native.chunk_rows()
    native_chunks = [
        {field: row[field] for field in original_chunks[0]} if original_chunks else {
            field: row[field]
            for field in ("header_offset", "payload_offset", "padded_extent_size", "payload_size", "id")
        }
        for row in native_chunks_full
    ]
    data_mismatches, data_details = _compare_rows("data", original_data, native_data)
    chunk_mismatches, chunk_details = _compare_rows("chunk", original_chunks, native_chunks)
    return {
        "data_rows_compared": min(len(original_data), len(native_data)),
        "chunk_rows_compared": min(len(original_chunks), len(native_chunks)),
        "data_mismatch_count": data_mismatches,
        "chunk_mismatch_count": chunk_mismatches,
        "mismatches": data_details + chunk_details,
        "original_data_sha256": _rows_sha256(original_data),
        "native_data_sha256": _rows_sha256(native_data),
        "original_chunk_sha256": _rows_sha256(original_chunks),
        "native_chunk_sha256": _rows_sha256(native_chunks),
        "native_data_index_provenance": "native traversal metadata; original CHiff stores no per-chunk data_index",
    }


def _validate_native_selection_state(
    native: NativeHIFF,
    original: dict[str, Any],
    index: OriginalIndex,
    payload: bytes,
    *,
    label: str,
) -> list[dict[str, Any]]:
    mismatches: list[dict[str, Any]] = []
    for kind, native_kind in (("data", "data"), ("chunk", "chunk")):
        expected = original[kind]
        pointer = int(expected["pointer"])
        selected = native.selected(native_kind)
        if pointer == 0:
            if selected is not None:
                mismatches.append({"label": label, "kind": kind, "field": "selection", "original": None, "native": _selection_for_report(selected)})
            continue
        offset = pointer - HEAP_BASE
        if not 0 <= offset <= len(payload):
            mismatches.append({"label": label, "kind": kind, "field": "original_pointer_bounds", "original": offset, "native": None})
            continue
        if selected is None:
            mismatches.append({"label": label, "kind": kind, "field": "selection", "original": offset, "native": None})
            continue
        expected_length = int(expected["size"])
        expected_name = str(expected["name"])
        comparable = {
            "payload_offset": offset,
            "length": expected_length,
            "name": expected_name,
        }
        if native_kind == "data":
            source = next((row for row in index.datas if row.content_address - HEAP_BASE == offset), None)
            if source is not None:
                comparable.update(
                    {
                        "index": source.index,
                        "record_offset": source.marker_address - HEAP_BASE,
                        "header_offset": source.marker_address - HEAP_BASE,
                        "data_index": source.index,
                    }
                )
        else:
            source = next((row for row in index.chunks if row.content_address - HEAP_BASE == offset), None)
            if source is not None:
                comparable.update({"index": source.index, "header_offset": source.address - HEAP_BASE})
        for field, expected_value in comparable.items():
            if selected.get(field) != expected_value:
                mismatches.append(
                    {
                        "label": label,
                        "kind": kind,
                        "field": field,
                        "original": expected_value,
                        "native": selected.get(field),
                    }
                )
        expected_bytes = payload[offset : offset + expected_length]
        if selected["bytes"] != expected_bytes:
            mismatches.append(
                {
                    "label": label,
                    "kind": kind,
                    "field": "selected_bytes_sha256",
                    "original": sha256(expected_bytes),
                    "native": sha256(selected["bytes"]),
                }
            )
    return mismatches


def _selection_for_report(selected: dict[str, Any]) -> dict[str, Any]:
    return {key: value for key, value in selected.items() if key != "bytes"}


def _compare_native_selection_traces(
    native: NativeHIFF,
    report: dict[str, Any],
    index: OriginalIndex,
    payload: bytes,
) -> dict[str, Any]:
    mismatches: list[dict[str, Any]] = []
    operations = 0

    def check_state(original_state: dict[str, Any], label: str) -> None:
        mismatches.extend(
            _validate_native_selection_state(native, original_state, index, payload, label=label)
        )

    def apply(operation: str, name: str, original_result: dict[str, Any], label: str) -> None:
        nonlocal operations
        check_state(original_result["before"], label + ":before")
        status, _ = native.select(operation, name)
        expected_found = bool(original_result["found"])
        if (status == 0) != expected_found:
            mismatches.append(
                {"label": label, "field": "found", "original": expected_found, "native_status": status}
            )
        check_state(original_result["after"], label + ":after")
        operations += 1

    for trace_index, trace in enumerate(report.get("selection_traces", [])):
        operation = trace["operation"]
        if operation == "select_data":
            apply("select_data", trace["name"], trace, f"trace[{trace_index}]")
        elif operation == "select_data_miss":
            apply("select_data", trace["name"], trace, f"trace[{trace_index}]")
        elif operation == "select_chunk":
            apply("select_chunk", trace["name"], trace, f"trace[{trace_index}]")
        elif operation == "select_chunk_miss":
            apply("select_chunk", trace["name"], trace, f"trace[{trace_index}]")
        elif operation == "first_next_sequence":
            name = trace["name"]
            for step_index, original_result in enumerate(trace["steps"]):
                apply("first" if step_index == 0 else "next", name, original_result, f"trace[{trace_index}].step[{step_index}]")
            end_result = trace.get("end")
            if end_result is not None:
                apply("next", name, end_result, f"trace[{trace_index}].end")
        else:
            mismatches.append({"label": f"trace[{trace_index}]", "field": "unknown_operation", "native": operation})
    return {
        "operations_compared": operations,
        "selection_mismatch_count": len(mismatches),
        "mismatches": mismatches[:100],
        "first_next_sequences_compared": sum(
            1 for item in report.get("selection_traces", []) if item.get("operation") == "first_next_sequence"
        ),
        "duplicate_first_next_sequences_compared": sum(
            1
            for item in report.get("selection_traces", [])
            if item.get("operation") == "first_next_sequence" and len(item.get("steps", [])) > 1
        ),
    }


def _attach_native_comparison(
    report: dict[str, Any],
    index: OriginalIndex,
    payload: bytes,
    native_library: Path,
    label: str,
) -> None:
    lib = _native_bindings(native_library)
    try:
        native = NativeHIFF(lib, payload, label)
    except OracleError as exc:
        raise OracleError(f"native parser rejected original-valid {label}: {exc}") from exc
    try:
        table_comparison = _compare_native_tables(index, native)
        selection_comparison = _compare_native_selection_traces(native, report, index, payload)
        report["native_comparison"] = {**table_comparison, "selection": selection_comparison}
        if (
            table_comparison["data_mismatch_count"]
            or table_comparison["chunk_mismatch_count"]
            or selection_comparison["selection_mismatch_count"]
        ):
            raise OracleError(f"native/original mismatch for {label}: {report['native_comparison']!r}")
    finally:
        native.close()


def _run_boot(path: Path, native_library: Path | None = None) -> dict[str, Any]:
    payload = path.read_bytes()
    index, report = _original_report(payload, path.stem)
    report["source_path"] = str(path)
    report["scope"] = "Original x86 CHiff routines only; not whole-game equivalence."
    if native_library is not None:
        _attach_native_comparison(report, index, payload, native_library, path.stem)
    return report


def _make_test_chunk(name: bytes, payload: bytes) -> bytes:
    if len(name) != 4:
        raise ValueError("fixture chunk tags must be four bytes")
    padded = payload + (b"\0" if len(payload) & 1 else b"")
    return name + len(payload).to_bytes(4, "big") + padded


def _make_test_data(name: bytes, body: bytes) -> bytes:
    if len(name) != 4:
        raise ValueError("fixture DATA types must be four bytes")
    declared = 4 + len(body)
    return b"DATA" + declared.to_bytes(4, "big") + name + body


def _run_nested_fixture(native_library: Path | None = None) -> dict[str, Any]:
    """Pin the original's one-nested-DATA-per-iteration behavior."""
    first_child = _make_test_data(b"CHL1", _make_test_chunk(b"KID1", b"kid1"))
    second_child = _make_test_data(b"CHL2", _make_test_chunk(b"KID2", b"kid2"))
    payload = _make_test_data(
        b"ROOT",
        _make_test_chunk(b"PRE1", b"pre1")
        + first_child
        + second_child
        + _make_test_chunk(b"POST", b"post"),
    )
    index, report = _original_report(payload, "nested-data-quirk-fixture")
    observed = report["chunk_names"]
    expected = ["PRE1", "DATA", "POST", "KID1", "KID2"]
    if observed != expected:
        raise OracleError(f"original nested-DATA fixture order changed: got {observed!r}, expected {expected!r}")
    report["fixture"] = "ROOT=[PRE1,CHL1{KID1},CHL2{KID2},POST]"
    report["expected_original_flat_order"] = expected
    report["finding"] = (
        "The original skips one nested DATA extent, then immediately indexes the next nested DATA header "
        "as a DATA chunk before continuing; later child DATA passes add KID1 and KID2."
    )
    if native_library is not None:
        _attach_native_comparison(report, index, payload, native_library, "adjacent-DATA fixture")

    duplicate_payload = _make_test_data(
        b"DUPS",
        _make_test_chunk(b"DUP1", b"one")
        + _make_test_chunk(b"KEEP", b"stay")
        + _make_test_chunk(b"DUP1", b"two")
        + _make_test_chunk(b"DUP1", b"three"),
    )
    duplicate_index, duplicate_report = _original_report(duplicate_payload, "duplicate-chunk-fixture")
    duplicate_expected = ["DUP1", "KEEP", "DUP1", "DUP1"]
    if duplicate_report["chunk_names"] != duplicate_expected:
        raise OracleError(
            f"original duplicate-chunk fixture order changed: got {duplicate_report['chunk_names']!r}, "
            f"expected {duplicate_expected!r}"
        )
    duplicate_report["fixture"] = "DUPS=[DUP1(one),KEEP(stay),DUP1(two),DUP1(three)]"
    duplicate_report["expected_original_flat_order"] = duplicate_expected
    if native_library is not None:
        _attach_native_comparison(
            duplicate_report,
            duplicate_index,
            duplicate_payload,
            native_library,
            "duplicate-chunk fixture",
        )
    report["duplicate_iteration_fixture"] = duplicate_report
    return report


def _run_resources(
    manifest_path: Path,
    *,
    full_sweep: bool,
    native_library: Path | None,
) -> dict[str, Any]:
    rows = _load_manifest(manifest_path)
    selected = rows if full_sweep else _benchmark_rows(rows)
    selection_check = native_library is not None and not full_sweep
    native_lib = _native_bindings(native_library) if native_library is not None else None
    machine = OriginalCHiff()
    results: list[dict[str, Any]] = []
    exclusions: list[dict[str, Any]] = []
    total_original_seconds = 0.0
    aggregate_data_mismatches = 0
    aggregate_chunk_mismatches = 0
    aggregate_selection_mismatches = 0
    compared_data_rows = 0
    compared_chunk_rows = 0
    native_open_count = 0
    for position, row in enumerate(selected, 1):
        label = f"{int(row['index']):04d}:{row['name']}"
        payload = _load_resource(row, manifest_path)
        original_index: OriginalIndex | None = None
        original_detail: dict[str, Any] | None = None
        original_error: str | None = None
        try:
            if selection_check or (not full_sweep and native_lib is None):
                original_index, original_detail = _original_report(payload, label, machine)
            else:
                original_index = machine.index(payload, label=label)
            total_original_seconds += float(original_index.elapsed_seconds)
        except OracleError as exc:
            original_error = str(exc)

        native: NativeHIFF | None = None
        native_error: str | None = None
        if native_lib is not None:
            try:
                native = NativeHIFF(native_lib, payload, label)
                native_open_count += 1
            except OracleError as exc:
                native_error = str(exc)

        item: dict[str, Any] = {
            "archive_index": row["index"],
            "resource_name": row["name"],
            "input_size": row["size"],
            "input_sha256": row["sha256"],
            "original_indexed": original_index is not None,
            "original_error": original_error,
        }
        if original_index is not None:
            item.update(
                {
                    "original_data_count": len(original_index.datas),
                    "original_chunk_count": len(original_index.chunks),
                    "original_index_seconds": round(original_index.elapsed_seconds, 6),
                    "original_data_sha256": _rows_sha256(_original_data_rows(original_index)),
                    "original_chunk_sha256": _rows_sha256(_original_chunk_rows(original_index)),
                }
            )
        if native_lib is not None:
            item["native_opened"] = native is not None
            item["native_error"] = native_error
            if native is not None and original_index is not None:
                try:
                    comparison = _compare_native_tables(original_index, native)
                    item["native_data_count"], item["native_chunk_count"] = native.counts()
                    item["table_comparison"] = comparison
                    aggregate_data_mismatches += int(comparison["data_mismatch_count"])
                    aggregate_chunk_mismatches += int(comparison["chunk_mismatch_count"])
                    compared_data_rows += int(comparison["data_rows_compared"])
                    compared_chunk_rows += int(comparison["chunk_rows_compared"])
                    if selection_check and original_detail is not None:
                        selection = _compare_native_selection_traces(native, original_detail, original_index, payload)
                        item["selection_comparison"] = selection
                        aggregate_selection_mismatches += int(selection["selection_mismatch_count"])
                        item["selection_operation_count"] = int(selection["operations_compared"])
                    if original_detail is not None:
                        # Preserve the detailed bounded oracle trace as a separate
                        # analysis file; summaries stay compact in this report.
                        item["selection_trace_count"] = len(original_detail["selection_traces"])
                except OracleError as exc:
                    item["comparison_error"] = str(exc)
            if original_index is None or native is None:
                exclusions.append(
                    {
                        "archive_index": row["index"],
                        "resource_name": row["name"],
                        "input_size": row["size"],
                        "input_sha256": row["sha256"],
                        "original_error": original_error,
                        "native_error": native_error,
                    }
                )
        elif original_error is not None:
            exclusions.append(
                {
                    "archive_index": row["index"],
                    "resource_name": row["name"],
                    "input_size": row["size"],
                    "input_sha256": row["sha256"],
                    "original_error": original_error,
                }
            )
        if native is not None:
            native.close()
        if original_detail is not None and native_lib is None:
            item["original"] = original_detail
        results.append(item)
        if position % 50 == 0:
            print(f"original CHiff resources {position}/{len(selected)}", file=sys.stderr, flush=True)
    return {
        "format": "original-x86-chiff-oracle-report-v1",
        "executable_sha256": EXPECTED_EXE_SHA256,
        "resource_manifest": str(manifest_path),
        "manifest_resource_count": len(rows),
        "selection": "all type-3 decoded resources in archive record order" if full_sweep else "bounded boot/autotext/convo plus stratified DATA resources",
        "resources_requested": len(selected),
        "resources_indexed_by_original": sum(1 for item in results if item["original_indexed"]),
        "resources_opened_by_native": native_open_count if native_lib is not None else None,
        "resources_excluded": len(exclusions),
        "data_rows": sum(int(item.get("original_data_count", 0)) for item in results),
        "chunk_rows": sum(int(item.get("original_chunk_count", 0)) for item in results),
        "data_rows_compared": compared_data_rows if native_lib is not None else None,
        "chunk_rows_compared": compared_chunk_rows if native_lib is not None else None,
        "data_mismatch_count": aggregate_data_mismatches if native_lib is not None else None,
        "chunk_mismatch_count": aggregate_chunk_mismatches if native_lib is not None else None,
        "selection_mismatch_count": aggregate_selection_mismatches if native_lib is not None and selection_check else None,
        "original_index_seconds": round(total_original_seconds, 6),
        "native_library": str(native_library) if native_library else None,
        "results": results,
        "exclusions": exclusions,
        "scope": "Original game x86 CHiff index/selection routines only; no whole-game equivalence claim.",
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--output", type=Path)
    subparsers = parser.add_subparsers(dest="command", required=True)
    boot = subparsers.add_parser("boot", help="run the original parser on decoded boot.CIF")
    boot.add_argument("--resource", type=Path, default=DEFAULT_BOOT)
    boot.add_argument("--native-library", type=Path)
    fixture = subparsers.add_parser("fixture", help="confirm original adjacent nested-DATA chunk traversal")
    fixture.add_argument("--native-library", type=Path)
    subparsers.add_parser("benchmark", help="index a bounded representative subset of type-3 files")
    compare = subparsers.add_parser("compare", help="compare a bounded subset with native HIFF")
    compare.add_argument("--native-library", type=Path, required=True)
    full_compare = subparsers.add_parser("full-compare", help="compare all type-3 resources with native HIFF")
    full_compare.add_argument("--native-library", type=Path, required=True)

    args = parser.parse_args(argv)
    if args.command == "boot":
        document = _run_boot(args.resource, args.native_library)
        default_output = DEFAULT_ANALYSIS_DIR / f"hiff-validation-{args.resource.stem}.json"
    elif args.command == "fixture":
        document = _run_nested_fixture(args.native_library)
        default_output = DEFAULT_ANALYSIS_DIR / "hiff-validation-fixture.json"
    else:
        library = getattr(args, "native_library", None)
        document = _run_resources(
            args.manifest,
            full_sweep=args.command == "full-compare",
            native_library=library,
        )
        default_output = DEFAULT_ANALYSIS_DIR / (
            "hiff-validation-full.json" if args.command == "full-compare" else "hiff-validation-benchmark.json"
        )
    output = args.output or default_output
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(document, indent=2, sort_keys=True) + "\n")
    brief = {key: value for key, value in document.items() if key not in ("results", "exclusions", "data", "chunks", "selection_traces")}
    if "duplicate_iteration_fixture" in brief:
        duplicate = brief.pop("duplicate_iteration_fixture")
        brief["duplicate_iteration_fixture_summary"] = {
            key: duplicate.get(key)
            for key in ("input_size", "data_count", "chunk_count", "chunk_names", "native_comparison")
        }
    if "data_count" in document:
        brief["data_count"] = document["data_count"]
        brief["chunk_count"] = document["chunk_count"]
    print(json.dumps(brief, indent=2))
    print(f"wrote {output}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (FormatError, OracleError, OSError, ValueError) as exc:
        print(f"hiff_original_oracle: {exc}", file=sys.stderr)
        raise SystemExit(2)
