#!/usr/bin/env python3
"""Run the original Blackmoor CIF decoder as an isolated x86 oracle.

This harness maps only GAME.EXE's PE image and enters the 579-byte function at
0x41b6e2 in Unicorn.  It does not launch the executable, call Windows APIs, or
use ScummVM.  The CIF parser below is deliberately independent of the native C
implementation so both sides can be compared against the original machine
code.

Examples (from the workspace root)::

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/cif_original_oracle.py self-test
    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/cif_original_oracle.py benchmark
    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/cif_original_oracle.py compare \
      --native-library outputs/blackmoor-decomp/build/libcifarchive.dylib
    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/cif_original_oracle.py full-compare \
      --native-library outputs/blackmoor-decomp/build/libcifarchive.dylib

The benchmark selects a bounded representative set.  It is not whole-engine,
whole-executable, or game-play equivalence evidence.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import os
import struct
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Sequence


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_SOURCE_JSON = ROOT / "work/analysis/game-source.json"
DEFAULT_ANALYSIS_DIR = ROOT / "work/analysis"
EXPECTED_EXE_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"

DECODER_VA = 0x41B6E2
DECODER_SIZE = 0x243
RING_VA = 0x56F354
RING_SIZE = 4096
RING_INITIALIZED = 4078
RING_PAGES_VA = 0x56F000
RING_PAGES_SIZE = 0x2000

STACK_BASE = 0x1000
STACK_SIZE = 0xF000
INPUT_BASE = 0x20000000
OUTPUT_BASE = 0x30000000
SENTINEL_VA = 0x51000000
PAGE_SIZE = 0x1000
MAX_OUTPUT_CAPACITY = 64 * 1024 * 1024
DEFAULT_TIMEOUT_US = 30_000_000
DEFAULT_INSTRUCTION_LIMIT = 400_000_000

CIFTREE_HEADER_SIZE = 32
CIFTREE_BUCKET_BYTES = 0x800
CIFTREE_COUNT_OFFSET = 28
CIFTREE_RECORD_SIZE = 94
CIFTREE_RECORD_BASE = CIFTREE_HEADER_SIZE + CIFTREE_BUCKET_BYTES


class OracleError(RuntimeError):
    """An invalid oracle setup, decoder trap, or resource-budget failure."""


class FormatError(ValueError):
    """A malformed or inconsistent input file."""


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


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
        machine, section_count, _timestamp, _sym, _nsyms, optional_size, _chars = (
            struct.unpack_from("<HHIIIHH", data, coff_offset)
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

    def va_to_file_offset(self, va: int, size: int = 1) -> int:
        rva = va - self.image_base
        if rva < 0:
            raise FormatError(f"VA 0x{va:x} precedes image base")
        for section in self.sections:
            if section.virtual_address <= rva and rva + size <= section.virtual_address + section.raw_size:
                return section.raw_offset + rva - section.virtual_address
        raise FormatError(f"VA range 0x{va:x}..0x{va + size:x} is not file-backed")


@dataclass(frozen=True)
class CifTreeEntry:
    name: str
    entry_id: int
    data_offset: int
    next_index: int
    output_size: int
    compressed_size: int
    type: int
    record_index: int


@dataclass(frozen=True)
class CifTree:
    path: Path
    data: bytes
    entries: tuple[CifTreeEntry, ...]
    bucket_heads: tuple[int, ...]
    summary: dict[str, object]

    @classmethod
    def parse(cls, path: Path) -> "CifTree":
        data = path.read_bytes()
        if len(data) < CIFTREE_RECORD_BASE:
            raise FormatError("CIFTREE.DAT is shorter than its header and bucket table")
        if data[:8] != b"CIF TREE":
            raise FormatError("CIFTREE.DAT signature mismatch")
        if struct.unpack_from("<H", data, 24)[0] != 2:
            raise FormatError("unexpected CIFTREE version marker")

        count = struct.unpack_from("<H", data, CIFTREE_COUNT_OFFSET)[0]
        record_end = CIFTREE_RECORD_BASE + count * CIFTREE_RECORD_SIZE
        if count == 0 or record_end > len(data):
            raise FormatError(f"invalid record count {count} or truncated records")

        bucket_heads = struct.unpack_from("<1024H", data, CIFTREE_HEADER_SIZE)
        entries: list[CifTreeEntry] = []
        allowed_types = {2, 3, 4}
        for index in range(count):
            offset = CIFTREE_RECORD_BASE + index * CIFTREE_RECORD_SIZE
            record = data[offset : offset + CIFTREE_RECORD_SIZE]
            if len(record) != CIFTREE_RECORD_SIZE:
                raise FormatError(f"truncated CIFTREE record {index}")
            raw_name = record[:33].split(b"\0", 1)[0]
            try:
                name = raw_name.decode("ascii")
            except UnicodeDecodeError as exc:
                raise FormatError(f"non-ASCII name in CIFTREE record {index}") from exc
            if not name:
                raise FormatError(f"empty name in CIFTREE record {index}")
            if any(ord(ch) < 0x20 or ord(ch) > 0x7E for ch in name):
                raise FormatError(f"non-printable name in CIFTREE record {index}: {name!r}")

            entry_id = struct.unpack_from("<H", record, 33)[0]
            data_offset = struct.unpack_from("<I", record, 35)[0]
            next_index = struct.unpack_from("<H", record, 39)[0]
            output_size = struct.unpack_from("<I", record, 81)[0]
            compressed_size = struct.unpack_from("<I", record, 89)[0]
            entry_type = record[93]
            if entry_id != index:
                raise FormatError(f"record {index} has id {entry_id}")
            if entry_type not in allowed_types:
                raise FormatError(f"record {index} has unexpected type {entry_type}")
            if next_index != 0xFFFF and next_index >= count:
                raise FormatError(f"record {index} points to out-of-range next id {next_index}")
            if data_offset > len(data) or compressed_size > len(data) - data_offset:
                raise FormatError(f"record {index} compressed range exceeds CIFTREE.DAT")
            if entry_type == 4 and (output_size or compressed_size):
                raise FormatError(f"metadata record {index} unexpectedly has payload")
            if entry_type != 4 and output_size == 0:
                raise FormatError(f"resource record {index} has zero output size")
            entries.append(
                CifTreeEntry(
                    name,
                    entry_id,
                    data_offset,
                    next_index,
                    output_size,
                    compressed_size,
                    entry_type,
                    index,
                )
            )

        # Validate every hash bucket and linked chain, including reachability.
        visit_counts = [0] * count
        chain_count = 0
        max_chain = 0
        for bucket, head in enumerate(bucket_heads):
            cursor = head
            local_seen: set[int] = set()
            chain_length = 0
            while cursor != 0xFFFF:
                if cursor >= count:
                    raise FormatError(f"bucket {bucket} starts/links to invalid id {cursor}")
                if cursor in local_seen:
                    raise FormatError(f"cycle in CIFTREE bucket {bucket} at id {cursor}")
                local_seen.add(cursor)
                visit_counts[cursor] += 1
                chain_length += 1
                cursor = entries[cursor].next_index
            if chain_length:
                chain_count += 1
                max_chain = max(max_chain, chain_length)
        unreachable = [i for i, visits in enumerate(visit_counts) if visits == 0]
        multiply_reached = [i for i, visits in enumerate(visit_counts) if visits > 1]
        if unreachable or multiply_reached:
            raise FormatError(
                "CIFTREE bucket chains do not form a partition: "
                f"unreachable={len(unreachable)}, multiply_reached={len(multiply_reached)}"
            )

        type_counts: dict[str, int] = {}
        type_output_bytes: dict[str, int] = {}
        type_compressed_bytes: dict[str, int] = {}
        for entry in entries:
            key = str(entry.type)
            type_counts[key] = type_counts.get(key, 0) + 1
            type_output_bytes[key] = type_output_bytes.get(key, 0) + entry.output_size
            type_compressed_bytes[key] = type_compressed_bytes.get(key, 0) + entry.compressed_size
        summary: dict[str, object] = {
            "sha256": sha256(data),
            "file_size": len(data),
            "header_count": count,
            "record_base": CIFTREE_RECORD_BASE,
            "record_size": CIFTREE_RECORD_SIZE,
            "record_end": record_end,
            "bucket_count": len(bucket_heads),
            "bucket_bytes": CIFTREE_BUCKET_BYTES,
            "nonempty_buckets": chain_count,
            "max_chain_length": max_chain,
            "all_records_reachable_once": True,
            "type_counts": type_counts,
            "type_output_bytes": type_output_bytes,
            "type_compressed_bytes": type_compressed_bytes,
        }
        return cls(path, data, tuple(entries), tuple(bucket_heads), summary)

    def payload(self, entry: CifTreeEntry) -> bytes:
        return self.data[entry.data_offset : entry.data_offset + entry.compressed_size]


@dataclass(frozen=True)
class StandaloneCif:
    path: Path
    data: bytes
    name: str
    output_size: int
    compressed_size: int
    entry_type: int
    payload: bytes
    summary: dict[str, object]

    @classmethod
    def parse(cls, path: Path) -> "StandaloneCif":
        data = path.read_bytes()
        if len(data) < 81 or data[:8] != b"CIF FILE":
            raise FormatError(f"not a standalone CIF FILE: {path}")
        if struct.unpack_from("<H", data, 24)[0] != 2:
            raise FormatError(f"unexpected CIF version marker in {path}")
        output_size = struct.unpack_from("<I", data, 68)[0]
        compressed_size = struct.unpack_from("<I", data, 76)[0]
        entry_type = data[80]
        payload_start = 81
        if payload_start + compressed_size != len(data):
            raise FormatError(
                f"standalone CIF compressed size mismatch in {path}: "
                f"header={compressed_size}, file={len(data)}"
            )
        if entry_type not in (2, 3):
            raise FormatError(f"unsupported standalone CIF type {entry_type} in {path}")
        payload = data[payload_start:]
        name = path.stem
        return cls(
            path,
            data,
            name,
            output_size,
            compressed_size,
            entry_type,
            payload,
            {
                "name": name,
                "file_size": len(data),
                "output_size": output_size,
                "compressed_size": compressed_size,
                "type": entry_type,
                "payload_offset": payload_start,
                "sha256": sha256(data),
            },
        )


def _find_mounted_game_dir(configured_game_dir: Path, bundle_name: str) -> Path | None:
    """Resolve a configured GOG path inside the mounted app bundle, read-only."""
    volumes = Path("/Volumes")
    if not volumes.is_dir():
        return None
    for volume in sorted(volumes.iterdir()):
        if not volume.is_dir():
            continue
        outer_bundle = volume / bundle_name
        game_resources = outer_bundle / "Contents/Resources/game"
        if not game_resources.is_dir():
            continue
        try:
            inner_bundles = sorted(game_resources.glob("*.app"))
        except OSError:
            continue
        for inner_bundle in inner_bundles:
            candidate = (
                inner_bundle
                / "Contents/Resources/drive_c/GOG Games"
                / configured_game_dir.name
            )
            if (candidate / "Ciftree/CIFTREE.DAT").is_file():
                return candidate
    return None


def resolve_game_dir(
    source_json: Path = DEFAULT_SOURCE_JSON,
    explicit_game_dir: Path | None = None,
) -> tuple[Path, dict[str, object]]:
    if explicit_game_dir is not None:
        path = explicit_game_dir.expanduser().resolve()
        if not (path / "Ciftree/CIFTREE.DAT").is_file():
            raise FileNotFoundError(f"no Ciftree/CIFTREE.DAT under {path}")
        return path, {"configured_path": str(path), "resolved_path": str(path), "fallback_used": False}

    try:
        source = json.loads(source_json.read_text(encoding="utf-8"))
        configured = Path(source["game_dir"]).expanduser()
        bundle_name = Path(source["bundle"]).name
    except (OSError, KeyError, json.JSONDecodeError, TypeError) as exc:
        raise FormatError(f"cannot read game source descriptor {source_json}: {exc}") from exc
    configured_candidate = configured / "Ciftree/CIFTREE.DAT"
    if configured_candidate.is_file():
        resolved = configured.resolve()
        return resolved, {
            "source_json": str(source_json),
            "configured_path": str(configured),
            "resolved_path": str(resolved),
            "fallback_used": False,
        }
    mounted = _find_mounted_game_dir(configured, bundle_name)
    if mounted is None:
        raise FileNotFoundError(
            f"configured source has no CIFTREE.DAT ({configured_candidate}); "
            "no matching mounted game bundle was found"
        )
    return mounted.resolve(), {
        "source_json": str(source_json),
        "configured_path": str(configured),
        "resolved_path": str(mounted.resolve()),
        "fallback_used": True,
        "fallback_reason": "configured /Applications game path is not mounted; matching source bundle was found under /Volumes",
    }


class OriginalDecoder:
    """Persistent x86 Unicorn machine executing only GAME.EXE's LZSS routine."""

    def __init__(
        self,
        exe_path: Path = DEFAULT_EXE,
        *,
        timeout_us: int = DEFAULT_TIMEOUT_US,
        instruction_limit: int = DEFAULT_INSTRUCTION_LIMIT,
    ) -> None:
        try:
            from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_PROT_ALL
            from unicorn.x86_const import (
                UC_X86_REG_EAX,
                UC_X86_REG_EBP,
                UC_X86_REG_EBX,
                UC_X86_REG_ECX,
                UC_X86_REG_EDI,
                UC_X86_REG_EDX,
                UC_X86_REG_EFLAGS,
                UC_X86_REG_EIP,
                UC_X86_REG_ES,
                UC_X86_REG_ESP,
                UC_X86_REG_ESI,
            )
        except ImportError as exc:
            raise OracleError("Unicorn 2.x is required; run with work/tools/oracle-python/bin/python") from exc

        self._uc_constants = {
            "UC_PROT_ALL": UC_PROT_ALL,
            "UC_X86_REG_EAX": UC_X86_REG_EAX,
            "UC_X86_REG_EBP": UC_X86_REG_EBP,
            "UC_X86_REG_EBX": UC_X86_REG_EBX,
            "UC_X86_REG_ECX": UC_X86_REG_ECX,
            "UC_X86_REG_EDI": UC_X86_REG_EDI,
            "UC_X86_REG_EDX": UC_X86_REG_EDX,
            "UC_X86_REG_EFLAGS": UC_X86_REG_EFLAGS,
            "UC_X86_REG_EIP": UC_X86_REG_EIP,
            "UC_X86_REG_ES": UC_X86_REG_ES,
            "UC_X86_REG_ESP": UC_X86_REG_ESP,
            "UC_X86_REG_ESI": UC_X86_REG_ESI,
        }
        self.exe_path = exe_path.resolve()
        self.pe = PEImage.parse_and_map(self.exe_path)
        exe_sha = sha256(self.pe.data)
        if exe_sha != EXPECTED_EXE_SHA256:
            raise OracleError(f"GAME.EXE hash mismatch: {exe_sha}")
        code_file_offset = self.pe.va_to_file_offset(DECODER_VA, DECODER_SIZE)
        self.decoder_bytes = self.pe.data[code_file_offset : code_file_offset + DECODER_SIZE]
        if len(self.decoder_bytes) != DECODER_SIZE:
            raise OracleError("could not map the complete original decoder function")

        image_start = self.pe.image_base & ~(PAGE_SIZE - 1)
        image_end = align_up(self.pe.image_base + self.pe.size_of_image)
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(image_start, image_end - image_start, UC_PROT_ALL)
        self.uc.mem_write(self.pe.image_base, self.pe.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE, UC_PROT_ALL)
        # These globals are process-zeroed in the original; keep them mapped and
        # persistent so the final 18 bytes survive successive decoder calls.
        self.uc.mem_write(RING_PAGES_VA, bytes(RING_PAGES_SIZE))
        self.stack_pointer = STACK_BASE + STACK_SIZE // 2
        self.input_capacity = 0
        self.output_capacity = 0
        self.timeout_us = timeout_us
        self.instruction_limit = instruction_limit
        self.calls = 0
        self.uc.reg_write(self._uc_constants["UC_X86_REG_ES"], 0)

    def _ensure_buffer(self, base: int, current: int, required: int) -> int:
        capacity = max(PAGE_SIZE, align_up(required))
        if capacity <= current:
            return current
        if current:
            self.uc.mem_map(base + current, capacity - current, self._uc_constants["UC_PROT_ALL"])
        else:
            self.uc.mem_map(base, capacity, self._uc_constants["UC_PROT_ALL"])
        return capacity

    def decode(
        self,
        compressed: bytes,
        nominal_output_size: int,
        *,
        label: str = "stream",
        output_limit: int | None = None,
    ) -> "OracleResult":
        if len(compressed) > 0xFFFFFFFF:
            raise OracleError("original function takes a 32-bit compressed size")
        if not (0 <= nominal_output_size <= 0xFFFFFFFF):
            raise OracleError("nominal output size must fit in 32 bits")
        if output_limit is None:
            output_limit = min(
                MAX_OUTPUT_CAPACITY,
                max(0x10000, nominal_output_size * 2 + 0x10000),
            )
        if output_limit < 0 or output_limit > MAX_OUTPUT_CAPACITY:
            raise OracleError(f"output limit {output_limit} is outside the configured cap")
        input_required = max(1, len(compressed))
        self.input_capacity = self._ensure_buffer(INPUT_BASE, self.input_capacity, input_required)
        self.output_capacity = self._ensure_buffer(OUTPUT_BASE, self.output_capacity, max(1, output_limit))
        if compressed:
            self.uc.mem_write(INPUT_BASE, compressed)

        # __thiscall: [return, pInput, pOutput, compressedLen, nominalOutSize].
        # The function overwrites the nominal-size slot with actual output count.
        entry_esp = self.stack_pointer
        stack = struct.pack(
            "<IIIII",
            SENTINEL_VA,
            INPUT_BASE,
            OUTPUT_BASE,
            len(compressed),
            nominal_output_size,
        )
        self.uc.mem_write(entry_esp, stack)
        for reg in (
            "UC_X86_REG_EAX",
            "UC_X86_REG_EBX",
            "UC_X86_REG_ECX",
            "UC_X86_REG_EDX",
            "UC_X86_REG_ESI",
            "UC_X86_REG_EDI",
            "UC_X86_REG_EBP",
        ):
            self.uc.reg_write(self._uc_constants[reg], 0)
        self.uc.reg_write(self._uc_constants["UC_X86_REG_ESP"], entry_esp)
        self.uc.reg_write(self._uc_constants["UC_X86_REG_EIP"], DECODER_VA)
        self.uc.reg_write(self._uc_constants["UC_X86_REG_EFLAGS"], 0x202)
        start_time = time.perf_counter()
        try:
            self.uc.emu_start(
                DECODER_VA,
                SENTINEL_VA,
                timeout=self.timeout_us,
                count=self.instruction_limit,
            )
        except Exception as exc:  # Unicorn exception includes its memory/exec cause.
            raise OracleError(f"decoder trap in {label}: {type(exc).__name__}: {exc}") from exc
        elapsed = time.perf_counter() - start_time
        eip = self.uc.reg_read(self._uc_constants["UC_X86_REG_EIP"])
        esp = self.uc.reg_read(self._uc_constants["UC_X86_REG_ESP"])
        if eip != SENTINEL_VA:
            raise OracleError(
                f"decoder did not return for {label}: eip=0x{eip:x}; "
                f"instruction limit={self.instruction_limit}, timeout={self.timeout_us}us"
            )
        if esp != entry_esp + 20:
            raise OracleError(f"unexpected __thiscall stack cleanup for {label}: ESP delta={esp - entry_esp}")
        written = struct.unpack("<I", self.uc.mem_read(entry_esp + 16, 4))[0]
        if written > output_limit:
            raise OracleError(f"decoder output for {label} exceeded its {output_limit}-byte limit")
        output = bytes(self.uc.mem_read(OUTPUT_BASE, written)) if written else b""
        ring = bytes(self.uc.mem_read(RING_VA, RING_SIZE))
        self.calls += 1
        return OracleResult(
            label=label,
            data=output,
            reported_output_size=written,
            ring=ring,
            elapsed_seconds=elapsed,
            compressed_size=len(compressed),
        )


@dataclass(frozen=True)
class OracleResult:
    label: str
    data: bytes
    reported_output_size: int
    ring: bytes
    elapsed_seconds: float
    compressed_size: int

    @property
    def ring_tail(self) -> bytes:
        return self.ring[RING_INITIALIZED:]

    def report(self) -> dict[str, object]:
        return {
            "label": self.label,
            "compressed_size": self.compressed_size,
            "reported_output_size": self.reported_output_size,
            "output_sha256": sha256(self.data),
            "ring_sha256": sha256(self.ring),
            "ring_tail_sha256": sha256(self.ring_tail),
            "elapsed_seconds": round(self.elapsed_seconds, 6),
        }


@dataclass(frozen=True)
class Literal:
    value: int


@dataclass(frozen=True)
class Copy:
    offset: int
    length: int


Token = Literal | Copy


def encode_original_stream(tokens: Sequence[Token]) -> bytes:
    """Build valid streams; invert the decoder's per-byte counter subtraction."""
    decoded: list[int] = []
    for start in range(0, len(tokens), 8):
        block = tokens[start : start + 8]
        control = 0
        for bit, token in enumerate(block):
            if isinstance(token, Literal):
                if not 0 <= token.value <= 0xFF:
                    raise ValueError("literal must be a byte")
                control |= 1 << bit
        decoded.append(control)
        for token in block:
            if isinstance(token, Literal):
                decoded.append(token.value)
            elif isinstance(token, Copy):
                if not (0 <= token.offset < RING_SIZE):
                    raise ValueError("copy offset must be a 12-bit ring index")
                if not (3 <= token.length <= 18):
                    raise ValueError("copy length must be in the original 3..18 range")
                decoded.append(token.offset & 0xFF)
                decoded.append(((token.offset >> 4) & 0xF0) | (token.length - 3))
            else:
                raise TypeError(f"unknown LZSS token {token!r}")
    return bytes((value + index) & 0xFF for index, value in enumerate(decoded))


def choose_representative_entries(tree: CifTree) -> list[CifTreeEntry]:
    resources = [entry for entry in tree.entries if entry.type in (2, 3) and entry.output_size]
    images = [entry for entry in resources if entry.type == 2]
    data_entries = [entry for entry in resources if entry.type == 3]
    if not images or not data_entries:
        raise FormatError("archive has no type-2 image and type-3 data samples")
    by_name = {entry.name.upper(): entry for entry in tree.entries}
    candidates = [
        min(images, key=lambda item: item.output_size),
        max(images, key=lambda item: item.output_size),
        by_name.get("AUTOTEXT", min(data_entries, key=lambda item: item.output_size)),
        by_name.get("BOOT", max(data_entries, key=lambda item: item.output_size)),
    ]
    selected: list[CifTreeEntry] = []
    seen: set[int] = set()
    for entry in candidates:
        if entry.record_index not in seen:
            selected.append(entry)
            seen.add(entry.record_index)
    return selected


def _native_bindings(path: Path) -> tuple[ctypes.CDLL, type[ctypes.Structure]]:
    try:
        lib = ctypes.CDLL(str(path.resolve()))
    except OSError as exc:
        raise OracleError(f"could not load native CIF library {path}: {exc}") from exc

    class CifDecodeContext(ctypes.Structure):
        _fields_ = [("ring", ctypes.c_uint8 * RING_SIZE)]

    lib.cif_decode_context_init.argtypes = [ctypes.POINTER(CifDecodeContext)]
    lib.cif_decode_context_init.restype = None
    lib.cif_decode.argtypes = [
        ctypes.POINTER(CifDecodeContext),
        ctypes.POINTER(ctypes.c_uint8),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_uint8),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
    ]
    lib.cif_decode.restype = ctypes.c_int
    lib.cif_decode_cif_memory.argtypes = [
        ctypes.POINTER(CifDecodeContext),
        ctypes.c_void_p,
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_uint8),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
    ]
    lib.cif_decode_cif_memory.restype = ctypes.c_int
    lib.cif_tree_open_file.argtypes = [
        ctypes.c_char_p,
        ctypes.POINTER(ctypes.c_char),
        ctypes.c_size_t,
    ]
    lib.cif_tree_open_file.restype = ctypes.c_void_p
    lib.cif_tree_close.argtypes = [ctypes.c_void_p]
    lib.cif_tree_close.restype = None
    lib.cif_tree_entry_count.argtypes = [ctypes.c_void_p]
    lib.cif_tree_entry_count.restype = ctypes.c_size_t
    lib.cif_tree_find.argtypes = [
        ctypes.c_void_p,
        ctypes.c_char_p,
        ctypes.POINTER(ctypes.c_size_t),
    ]
    lib.cif_tree_find.restype = ctypes.c_int
    lib.cif_tree_extract.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        ctypes.POINTER(CifDecodeContext),
        ctypes.POINTER(ctypes.c_uint8),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
    ]
    lib.cif_tree_extract.restype = ctypes.c_int
    if hasattr(lib, "cif_status_string"):
        lib.cif_status_string.argtypes = [ctypes.c_int]
        lib.cif_status_string.restype = ctypes.c_char_p
    return lib, CifDecodeContext


class NativeTree:
    """Exercise the public C archive lookup/extraction API with persistent state."""

    def __init__(self, lib: ctypes.CDLL, context_type: type[ctypes.Structure], path: Path) -> None:
        self.lib = lib
        self.context = context_type()
        self.lib.cif_decode_context_init(ctypes.byref(self.context))
        self.error_buffer = ctypes.create_string_buffer(512)
        self.tree = self.lib.cif_tree_open_file(
            os.fsencode(path),
            ctypes.cast(self.error_buffer, ctypes.POINTER(ctypes.c_char)),
            len(self.error_buffer),
        )
        if not self.tree:
            raise OracleError(
                f"native cif_tree_open_file failed for {path}: "
                f"{self.error_buffer.value.decode('utf-8', 'replace')}"
            )
        self.entry_count = int(self.lib.cif_tree_entry_count(self.tree))

    def find_index(self, name: str, expected_index: int) -> int:
        index = ctypes.c_size_t()
        # Lowercasing every query makes the case-insensitive public lookup part
        # of the validation, rather than testing only a private decoder.
        query = name.casefold().encode("ascii")
        status = self.lib.cif_tree_find(self.tree, query, ctypes.byref(index))
        if status != 0:
            raise OracleError(f"native cif_tree_find failed for {name!r}: status={status}")
        if index.value != expected_index:
            raise OracleError(
                f"native casefold lookup {name!r} returned {index.value}, expected {expected_index}"
            )
        return int(index.value)

    def extract(self, index: int, output_size: int, *, label: str) -> dict[str, object]:
        out_buffer = (ctypes.c_uint8 * max(1, output_size))()
        written = ctypes.c_size_t()
        consumed = ctypes.c_size_t()
        start = time.perf_counter()
        status = self.lib.cif_tree_extract(
            self.tree,
            index,
            ctypes.byref(self.context),
            out_buffer,
            output_size,
            ctypes.byref(written),
            ctypes.byref(consumed),
        )
        elapsed = time.perf_counter() - start
        if status != 0:
            message = ""
            if hasattr(self.lib, "cif_status_string"):
                raw = self.lib.cif_status_string(status)
                message = raw.decode("utf-8", "replace") if raw else ""
            raise OracleError(f"native cif_tree_extract failed for {label}: status={status} {message}")
        if written.value > output_size:
            raise OracleError(f"native tree extractor over-reported output for {label}")
        return {
            "data": bytes(out_buffer[: written.value]),
            "written": written.value,
            "consumed": consumed.value,
            "ring": bytes(self.context.ring),
            "elapsed_seconds": elapsed,
        }

    def close(self) -> None:
        if self.tree:
            self.lib.cif_tree_close(self.tree)
            self.tree = None


def _native_decode(
    lib: ctypes.CDLL,
    context: ctypes.Structure,
    compressed: bytes,
    output_size: int,
    *,
    label: str,
) -> dict[str, object]:
    in_buffer = (ctypes.c_uint8 * max(1, len(compressed)))()
    if compressed:
        ctypes.memmove(in_buffer, compressed, len(compressed))
    out_buffer = (ctypes.c_uint8 * max(1, output_size))()
    written = ctypes.c_size_t()
    consumed = ctypes.c_size_t()
    start = time.perf_counter()
    status = lib.cif_decode(
        ctypes.byref(context),
        in_buffer,
        len(compressed),
        out_buffer,
        output_size,
        ctypes.byref(written),
        ctypes.byref(consumed),
    )
    elapsed = time.perf_counter() - start
    if status != 0:
        message = ""
        if hasattr(lib, "cif_status_string"):
            raw = lib.cif_status_string(status)
            message = raw.decode("utf-8", "replace") if raw else ""
        raise OracleError(f"native decoder failed for {label}: status={status} {message}")
    if written.value > output_size:
        raise OracleError(f"native decoder over-reported output for {label}")
    return {
        "data": bytes(out_buffer[: written.value]),
        "written": written.value,
        "consumed": consumed.value,
        "ring": bytes(context.ring),
        "elapsed_seconds": elapsed,
    }


def _native_decode_standalone(
    lib: ctypes.CDLL,
    context: ctypes.Structure,
    file_bytes: bytes,
    output_size: int,
    *,
    label: str,
) -> dict[str, object]:
    file_buffer = ctypes.create_string_buffer(file_bytes, len(file_bytes))
    out_buffer = (ctypes.c_uint8 * max(1, output_size))()
    required = ctypes.c_size_t()
    written = ctypes.c_size_t()
    consumed = ctypes.c_size_t()
    start = time.perf_counter()
    status = lib.cif_decode_cif_memory(
        ctypes.byref(context),
        ctypes.cast(file_buffer, ctypes.c_void_p),
        len(file_bytes),
        out_buffer,
        output_size,
        ctypes.byref(required),
        ctypes.byref(written),
        ctypes.byref(consumed),
    )
    elapsed = time.perf_counter() - start
    if status != 0:
        message = ""
        if hasattr(lib, "cif_status_string"):
            raw = lib.cif_status_string(status)
            message = raw.decode("utf-8", "replace") if raw else ""
        raise OracleError(f"native standalone CIF decoder failed for {label}: status={status} {message}")
    if required.value != output_size or written.value > output_size:
        raise OracleError(
            f"native standalone CIF size mismatch for {label}: "
            f"required={required.value}, written={written.value}, expected={output_size}"
        )
    return {
        "data": bytes(out_buffer[: written.value]),
        "written": written.value,
        "consumed": consumed.value,
        "ring": bytes(context.ring),
        "elapsed_seconds": elapsed,
    }


def _self_test(exe: Path, report_path: Path) -> dict[str, object]:
    oracle = OriginalDecoder(exe)
    checks: list[dict[str, object]] = []

    def run_case(name: str, tokens: Sequence[Token], expected: bytes, nominal: int = 0x12345678) -> OracleResult:
        result = oracle.decode(encode_original_stream(tokens), nominal, label=name)
        if result.data != expected:
            raise OracleError(
                f"synthetic case {name}: output mismatch ({len(result.data)} != {len(expected)})"
            )
        checks.append({**result.report(), "expected_sha256": sha256(expected), "passed": True})
        return result

    run_case("literal-basic", [Literal(ord("A")), Literal(ord("B")), Literal(ord("C"))], b"ABC")
    run_case(
        "overlap-copy",
        [Literal(ord("A")), Copy(RING_INITIALIZED, 18)],
        b"A" * 19,
    )
    wrap_payload = bytes((index * 37 + 11) & 0xFF for index in range(8207))
    run_case("4096-ring-wrap-and-byte-counter-wrap", [Literal(value) for value in wrap_payload], wrap_payload)

    retained = bytes(range(0x31, 0x31 + 18))
    run_case("tail-retention-seed", [Literal(value) for value in retained], retained)
    run_case("tail-retention-replay", [Copy(RING_INITIALIZED, 18)], retained)

    truncated = oracle.decode(
        encode_original_stream([]) + bytes((0xFF,)),
        0xFFFFFFFF,
        label="truncated-control-only",
    )
    if truncated.data:
        raise OracleError("truncated one-byte control unexpectedly emitted output")
    checks.append({**truncated.report(), "passed": True, "note": "one control byte, no token payload"})

    one_literal_stream = encode_original_stream([Literal(ord("Z"))])
    truncated_literal = oracle.decode(
        one_literal_stream,
        0,
        label="one-literal-with-mismatched-nominal-size",
    )
    if truncated_literal.data != b"Z" or truncated_literal.reported_output_size != 1:
        raise OracleError("original decoder did not overwrite nominal size with actual output count")
    checks.append({
        **truncated_literal.report(),
        "passed": True,
        "note": "valid one-literal stream; nominal output size 0 is overwritten with actual count",
    })

    report = {
        "oracle": "original GAME.EXE x86 function 0x41b6e2..0x41b925 under Unicorn",
        "executable_sha256": sha256(exe.read_bytes()),
        "decoder_va": DECODER_VA,
        "decoder_size": DECODER_SIZE,
        "decoder_bytes_sha256": sha256(oracle.decoder_bytes),
        "isolation": "only decoder function executed; no Windows API or game engine",
        "ring_initialization": f"zeroed pages 0x{RING_PAGES_VA:x}..0x{RING_PAGES_VA + RING_PAGES_SIZE:x} once; state retained across {oracle.calls} calls",
        "checks": checks,
        "passed": True,
    }
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    return report


def _run_archive_samples(
    *,
    exe: Path,
    tree: CifTree,
    standalones: Sequence[StandaloneCif],
    compare_library: Path | None,
    report_path: Path,
    selected_entries: Sequence[CifTreeEntry] | None = None,
    full_sweep: bool = False,
) -> dict[str, object]:
    oracle = OriginalDecoder(exe)
    native_lib: ctypes.CDLL | None = None
    native_tree: NativeTree | None = None
    native_context: ctypes.Structure | None = None
    if compare_library:
        native_lib, context_type = _native_bindings(compare_library)
        native_tree = NativeTree(native_lib, context_type, tree.path)
        if native_tree.entry_count != len(tree.entries):
            raise OracleError(
                f"native tree entry count {native_tree.entry_count} != independent parser count {len(tree.entries)}"
            )
        native_context = native_tree.context

    entries = list(selected_entries if selected_entries is not None else choose_representative_entries(tree))
    samples: list[dict[str, object]] = []
    total_original_seconds = 0.0
    total_native_seconds = 0.0
    total_compressed = 0
    total_output = 0
    start_wall = time.perf_counter()
    try:
        for entry_number, entry in enumerate(entries, start=1):
            label = f"tree:{entry.name}"
            lookup_index: int | None = None
            if native_tree is not None:
                lookup_index = native_tree.find_index(entry.name, entry.record_index)
            if entry.type == 4:
                samples.append({
                    "name": entry.name,
                    "record_index": entry.record_index,
                    "type": entry.type,
                    "lookup_index": lookup_index,
                    "validation": "lookup-only metadata record",
                })
            else:
                payload = tree.payload(entry)
                original = oracle.decode(payload, entry.output_size, label=label)
                if original.reported_output_size != entry.output_size:
                    raise OracleError(
                        f"original output size differs for {label}: {original.reported_output_size} != {entry.output_size}"
                    )
                sample = {
                    "name": entry.name,
                    "record_index": entry.record_index,
                    "type": entry.type,
                    "lookup_index": lookup_index,
                    "data_offset": entry.data_offset,
                    "compressed_size": entry.compressed_size,
                    "expected_output_size": entry.output_size,
                    "original": original.report(),
                }
                if native_tree is not None:
                    native = native_tree.extract(lookup_index, entry.output_size, label=label)
                    total_native_seconds += float(native["elapsed_seconds"])
                    if int(native["consumed"]) != entry.compressed_size:
                        raise OracleError(
                            f"native tree extractor consumed {native['consumed']} bytes for {label}; "
                            f"expected {entry.compressed_size}"
                        )
                    output_match = native["data"] == original.data
                    ring_match = native["ring"] == original.ring
                    sample["native"] = {
                        "output_sha256": sha256(native["data"]),
                        "ring_sha256": sha256(native["ring"]),
                        "ring_tail_sha256": sha256(native["ring"][RING_INITIALIZED:]),
                        "written": native["written"],
                        "consumed": native["consumed"],
                        "elapsed_seconds": round(float(native["elapsed_seconds"]), 6),
                    }
                    sample["comparison"] = {
                        "output_match": output_match,
                        "ring_match": ring_match,
                    }
                    if not output_match or not ring_match:
                        samples.append(sample)
                        raise OracleError(f"native/original mismatch for {label}: {sample['comparison']}")
                samples.append(sample)
                total_original_seconds += original.elapsed_seconds
                total_compressed += len(payload)
                total_output += len(original.data)

            if full_sweep and entry_number % 100 == 0:
                print(
                    f"progress tree entries {entry_number}/{len(entries)}; "
                    f"payloads decoded={sum(1 for item in samples if item.get('type') in (2, 3))}",
                    flush=True,
                )

        for standalone_number, standalone in enumerate(standalones, start=1):
            label = f"standalone:{standalone.path.name}"
            original = oracle.decode(standalone.payload, standalone.output_size, label=label)
            if original.reported_output_size != standalone.output_size:
                raise OracleError(f"standalone output size mismatch for {label}")
            sample = {
                "name": standalone.name,
                "source": str(standalone.path),
                "type": standalone.entry_type,
                "compressed_size": len(standalone.payload),
                "expected_output_size": standalone.output_size,
                "standalone_header": standalone.summary,
                "original": original.report(),
            }
            if native_lib is not None and native_context is not None:
                native = _native_decode_standalone(
                    native_lib,
                    native_context,
                    standalone.data,
                    standalone.output_size,
                    label=label,
                )
                total_native_seconds += float(native["elapsed_seconds"])
                if int(native["consumed"]) != standalone.compressed_size:
                    raise OracleError(
                        f"native standalone decoder consumed {native['consumed']} bytes for {label}; "
                        f"expected {standalone.compressed_size}"
                    )
                output_match = native["data"] == original.data
                ring_match = native["ring"] == original.ring
                sample["native"] = {
                    "output_sha256": sha256(native["data"]),
                    "ring_sha256": sha256(native["ring"]),
                    "ring_tail_sha256": sha256(native["ring"][RING_INITIALIZED:]),
                    "written": native["written"],
                    "consumed": native["consumed"],
                    "elapsed_seconds": round(float(native["elapsed_seconds"]), 6),
                }
                sample["comparison"] = {"output_match": output_match, "ring_match": ring_match}
                if not output_match or not ring_match:
                    samples.append(sample)
                    raise OracleError(f"native/original mismatch for {label}: {sample['comparison']}")
            samples.append(sample)
            total_original_seconds += original.elapsed_seconds
            total_compressed += len(standalone.payload)
            total_output += len(original.data)
            if full_sweep and standalone_number % 10 == 0:
                print(
                    f"progress standalone CIFs {standalone_number}/{len(standalones)}",
                    flush=True,
                )
    finally:
        if native_tree is not None:
            native_tree.close()

    total_archive_output = sum(entry.output_size for entry in tree.entries if entry.type in (2, 3))
    total_archive_compressed = sum(entry.compressed_size for entry in tree.entries if entry.type in (2, 3))
    archive_resource_count = sum(1 for entry in tree.entries if entry.type in (2, 3))
    tree_payload_rows = [
        item for item in samples if "record_index" in item and item.get("type") in (2, 3)
    ]
    standalone_rows = [item for item in samples if "source" in item]
    compared_resources = len(tree_payload_rows)
    comparison_rows = [item for item in samples if "comparison" in item]
    all_comparisons_match = (
        len(comparison_rows) == len(tree_payload_rows) + len(standalones)
        and all(
            item["comparison"].get("output_match") and item["comparison"].get("ring_match")
            for item in comparison_rows
        )
    ) if compare_library else None
    report: dict[str, object] = {
        "oracle": "original GAME.EXE x86 function under Unicorn",
        "executable_sha256": sha256(exe.read_bytes()),
        "decoder_va": DECODER_VA,
        "decoder_size": DECODER_SIZE,
        "decoder_bytes_sha256": sha256(oracle.decoder_bytes),
        "tree": {
            "source_path": str(tree.path),
            **tree.summary,
        },
        "archive_validation_scope": (
            "all tree payloads plus standalone CIFs" if full_sweep
            else "representative sample set; not a whole-archive decode"
        ),
        "validation_order": (
            "all CIFTREE records in record-index order; casefold lookup for every record; "
            "type-2/type-3 resources extracted; type-4 metadata lookup only; then standalone CIF files sorted by relative path"
            if full_sweep else "selected CIFTREE entries in selected order, then the supplied standalone CIF files"
        ),
        "scope_note": "decoder-level equivalence only; this does not establish whole-engine, executable, or gameplay equivalence",
        "validation_counts": {
            "tree_records_seen": len(entries),
            "tree_casefold_lookups": len(entries) if compare_library else 0,
            "tree_payloads_decoded_by_original": compared_resources,
            "tree_payloads_decoded_by_native_tree_extract": sum(
                1 for item in tree_payload_rows if "native" in item
            ),
            "standalone_cif_files": len(standalone_rows),
            "payload_comparisons": len(comparison_rows),
        },
        "payload_totals": {
            "tree_resource_count": archive_resource_count,
            "tree_compressed_bytes": total_archive_compressed,
            "tree_output_bytes": total_archive_output,
            "validated_compressed_bytes_including_standalones": total_compressed,
            "validated_output_bytes_including_standalones": total_output,
        },
        "timing": {
            "original_decoder_seconds": round(total_original_seconds, 6),
            "native_api_seconds": round(total_native_seconds, 6),
            "wall_seconds": round(time.perf_counter() - start_wall, 6),
        },
        "samples": samples,
        "native_comparison_performed": compare_library is not None,
        "all_payload_comparisons_match": all_comparisons_match,
        "all_tree_casefold_lookups_resolved": (
            sum(1 for item in samples if "lookup_index" in item) == len(entries)
        ) if compare_library else None,
    }
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    return report


def _json_report(value: dict[str, object]) -> None:
    print(json.dumps(value, indent=2))


def build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE, help="immutable original GAME.EXE")
    parser.add_argument("--source-json", type=Path, default=DEFAULT_SOURCE_JSON)
    parser.add_argument("--game-dir", type=Path, help="explicit source game directory containing Ciftree/")
    parser.add_argument("--native-library", type=Path, help="optional shared library exposing cif_decode ABI")
    parser.add_argument("--report", type=Path, help="write JSON report here")
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("self-test", help="run synthetic decoder and ring-state cases")
    subparsers.add_parser("benchmark", help="decode mixed representative archive entries and standalone boot.CIF")
    compare = subparsers.add_parser("compare", help="compare the representative set against the native C API")
    compare.add_argument("--native-library", dest="native_library_command", type=Path, required=True)
    full_compare = subparsers.add_parser(
        "full-compare",
        help="compare all archive resources and standalone CIF files against the original decoder",
    )
    full_compare.add_argument("--native-library", dest="native_library_command", type=Path, required=True)
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = build_arg_parser().parse_args(argv)
    exe = args.exe.expanduser().resolve()
    report_path = args.report.expanduser().resolve() if args.report else None
    if args.command == "self-test":
        path = report_path or DEFAULT_ANALYSIS_DIR / "cif-validation-selftest.json"
        report = _self_test(exe, path)
        _json_report(report)
        return 0

    game_dir, source_resolution = resolve_game_dir(args.source_json, args.game_dir)
    tree_path = game_dir / "Ciftree/CIFTREE.DAT"
    tree = CifTree.parse(tree_path)
    boot_path = game_dir / "Ciftree/boot.CIF"
    library = getattr(args, "native_library_command", None) or args.native_library
    if args.command in ("compare", "full-compare") and library is None:
        raise OracleError(f"{args.command} requires --native-library")
    full_sweep = args.command == "full-compare"
    if full_sweep:
        standalone_paths = sorted(
            (path for path in (game_dir / "Ciftree").rglob("*") if path.is_file() and path.suffix.lower() == ".cif"),
            key=lambda path: path.relative_to(game_dir).as_posix().casefold(),
        )
        standalones = [StandaloneCif.parse(path) for path in standalone_paths]
        if len(standalones) != 63:
            raise FormatError(f"expected 63 standalone CIF files, found {len(standalones)}")
        selected = list(tree.entries)
        default_name = "cif-validation-full.json"
    else:
        standalones = [StandaloneCif.parse(boot_path)] if boot_path.is_file() else []
        selected = choose_representative_entries(tree)
        default_name = "cif-validation-native-compare.json" if library else "cif-validation-oracle-benchmark.json"
    output_path = report_path or DEFAULT_ANALYSIS_DIR / default_name
    report = _run_archive_samples(
        exe=exe,
        tree=tree,
        standalones=standalones,
        compare_library=library,
        report_path=output_path,
        selected_entries=selected,
        full_sweep=full_sweep,
    )
    report["source_resolution"] = source_resolution
    report["report_path"] = str(output_path)
    # Include source path resolution in the persisted artifact, as well as stdout.
    output_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    if full_sweep:
        _json_report({
            key: report[key]
            for key in (
                "archive_validation_scope",
                "validation_counts",
                "payload_totals",
                "timing",
                "native_comparison_performed",
                "all_payload_comparisons_match",
                "all_tree_casefold_lookups_resolved",
                "report_path",
            )
        })
    else:
        _json_report(report)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OracleError, FormatError, FileNotFoundError, PermissionError) as exc:
        print(f"cif_original_oracle: {exc}", file=sys.stderr)
        raise SystemExit(2)
