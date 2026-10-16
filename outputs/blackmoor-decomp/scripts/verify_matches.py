#!/usr/bin/env python3
"""Verify byte-exact function matches against a PE32 original.

The manifest deliberately carries provenance fields (``description`` and
``source``).  Bytes can be compared mechanically; their provenance cannot.
Each candidate is an independently compiled i386 COFF object, and its named
symbol identifies the bytes to compare.

Example::

    verify_matches.py GAME.EXE matches.json --report report.json

The command exits 0 when every manifest-selected byte range is an exact
match, 1 when one or more ranges are rejected or differ, and 2 for an
invalid manifest/original.  A byte-range match does not establish that the
manifest size covers a complete source function.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import struct
import sys
from pathlib import Path
from typing import Any, Iterable, Optional


MACHINE_I386 = 0x014C
COFF_SYMBOL_SIZE = 18
COFF_RELOCATION_SIZE = 10
PE32_MAGIC = 0x010B
BASE_RELOCATION_DIRECTORY = 5


class VerificationError(Exception):
    """A malformed input or a candidate that cannot be verified."""


class Reader:
    """Bounds checked little-endian reads from an immutable byte string."""

    def __init__(self, data: bytes, label: str) -> None:
        self.data = data
        self.label = label

    def require(self, offset: int, size: int, what: str) -> None:
        if offset < 0 or size < 0 or offset > len(self.data) - size:
            raise VerificationError(
                f"{self.label}: truncated {what} at 0x{offset:x} (size {size})"
            )

    def bytes(self, offset: int, size: int, what: str = "data") -> bytes:
        self.require(offset, size, what)
        return self.data[offset : offset + size]

    def u16(self, offset: int, what: str = "uint16") -> int:
        return struct.unpack_from("<H", self.bytes(offset, 2, what))[0]

    def i16(self, offset: int, what: str = "int16") -> int:
        return struct.unpack_from("<h", self.bytes(offset, 2, what))[0]

    def u32(self, offset: int, what: str = "uint32") -> int:
        return struct.unpack_from("<I", self.bytes(offset, 4, what))[0]


def _coff_name(raw_name: bytes, string_table: bytes, label: str) -> str:
    """Decode an inline or string-table COFF name."""

    if len(raw_name) != 8:
        raise VerificationError(f"{label}: invalid COFF name width")

    if raw_name[:4] == b"\x00\x00\x00\x00":
        string_offset = struct.unpack_from("<I", raw_name, 4)[0]
        if string_offset < 4 or string_offset >= len(string_table):
            raise VerificationError(
                f"{label}: COFF string-table offset {string_offset} is out of bounds"
            )
        end = string_table.find(b"\x00", string_offset)
        if end < 0:
            raise VerificationError(f"{label}: unterminated COFF string")
        return string_table[string_offset:end].decode("latin-1")

    return raw_name.split(b"\x00", 1)[0].decode("latin-1")


class CoffSymbol:
    def __init__(
        self,
        name: str,
        value: int,
        section_number: int,
        symbol_type: int,
        storage_class: int,
        index: int,
    ) -> None:
        self.name = name
        self.value = value
        self.section_number = section_number
        self.symbol_type = symbol_type
        self.storage_class = storage_class
        self.index = index


class Section:
    def __init__(
        self,
        name: str,
        virtual_size: int,
        virtual_address: int,
        raw_size: int,
        raw_pointer: int,
        relocation_pointer: int,
        relocation_count: int,
        characteristics: int,
    ) -> None:
        self.name = name
        self.virtual_size = virtual_size
        self.virtual_address = virtual_address
        self.raw_size = raw_size
        self.raw_pointer = raw_pointer
        self.relocation_pointer = relocation_pointer
        self.relocation_count = relocation_count
        self.characteristics = characteristics


class PEImage:
    def __init__(
        self, data: bytes, sections: list[Section], symbols: list[CoffSymbol], base_relocations: list[tuple[int, int]]
    ) -> None:
        self.data = data
        self.reader = Reader(data, "original PE")
        self.sections = sections
        self.symbols = symbols
        self.base_relocations = base_relocations

    def rva_bytes(self, rva: int, size: int) -> tuple[bytes, int, Section]:
        if rva < 0 or size <= 0 or rva > 0xFFFFFFFF or size > 0xFFFFFFFF:
            raise VerificationError(f"original PE: invalid RVA/size 0x{rva:x}/{size}")
        end_rva = rva + size
        if end_rva > 0x100000000:
            raise VerificationError("original PE: RVA range overflows 32-bit address space")

        for section in self.sections:
            virtual_span = max(section.virtual_size, section.raw_size)
            section_start = section.virtual_address
            section_end = section_start + virtual_span
            if not section_start <= rva < section_end:
                continue

            offset_in_section = rva - section_start
            if end_rva > section_end:
                raise VerificationError(
                    f"original PE: RVA range 0x{rva:x}-0x{end_rva:x} crosses section {section.name}"
                )
            if offset_in_section + size > section.virtual_size:
                raise VerificationError(
                    f"original PE: RVA range is outside virtual bytes of section {section.name}"
                )
            if offset_in_section + size > section.raw_size:
                raise VerificationError(
                    f"original PE: RVA range is virtual-only in section {section.name}"
                )
            raw_offset = section.raw_pointer + offset_in_section
            self.reader.require(raw_offset, size, f"section {section.name} bytes")
            return self.data[raw_offset : raw_offset + size], raw_offset, section

        raise VerificationError(f"original PE: RVA 0x{rva:x} is outside a section")

    def relocations_overlapping(self, rva: int, size: int) -> list[dict[str, int | str]]:
        end = rva + size
        overlaps: list[dict[str, int | str]] = []

        for relocation_rva, relocation_size in self.base_relocations:
            if relocation_rva < end and relocation_rva + relocation_size > rva:
                overlaps.append({"rva": relocation_rva, "size": relocation_size, "kind": "base"})

        # PE section COFF relocations are uncommon in a linked image, but if
        # present they still make a byte match unsafe.  Parse their offsets
        # relative to the containing section and conservatively treat unknown
        # relocation kinds as four-byte fields.
        for section in self.sections:
            if section.relocation_count == 0:
                continue
            reader = self.reader
            for index in range(section.relocation_count):
                offset = section.relocation_pointer + index * COFF_RELOCATION_SIZE
                raw = reader.bytes(offset, COFF_RELOCATION_SIZE, f"{section.name} relocation")
                virtual_offset, _symbol_index, relocation_type = struct.unpack("<IIH", raw)
                relocation_size = _relocation_width(MACHINE_I386, relocation_type)
                relocation_rva = section.virtual_address + virtual_offset
                if relocation_rva < end and relocation_rva + relocation_size > rva:
                    overlaps.append(
                        {
                            "rva": relocation_rva,
                            "size": relocation_size,
                            "kind": "section",
                        }
                    )
        return overlaps


class CoffObject:
    def __init__(self, data: bytes, sections: list[Section], symbols: list[CoffSymbol]) -> None:
        self.data = data
        self.reader = Reader(data, "COFF object")
        self.sections = sections
        self.symbols = symbols

    def symbol_bytes(self, symbol_name: str, size: int) -> tuple[bytes, int, CoffSymbol]:
        matches = [symbol for symbol in self.symbols if symbol.name == symbol_name]
        if not matches:
            raise VerificationError(f"COFF object: symbol {symbol_name!r} is absent")
        if len(matches) > 1:
            raise VerificationError(f"COFF object: symbol {symbol_name!r} is ambiguous")

        symbol = matches[0]
        if not 1 <= symbol.section_number <= len(self.sections):
            raise VerificationError(
                f"COFF object: symbol {symbol_name!r} has invalid section {symbol.section_number}"
            )
        section = self.sections[symbol.section_number - 1]
        if size <= 0 or symbol.value > section.raw_size or symbol.value + size > section.raw_size:
            raise VerificationError(
                f"COFF object: symbol {symbol_name!r} range is outside section {section.name}"
            )

        raw_offset = section.raw_pointer + symbol.value
        self.reader.require(raw_offset, size, f"section {section.name} bytes")
        overlaps = _coff_relocations_overlapping(self, section, symbol.value, size)
        if overlaps:
            raise VerificationError(
                f"COFF object: relocation overlaps symbol {symbol_name!r} at "
                + ", ".join(f"+0x{item['offset']:x}" for item in overlaps)
            )
        return self.data[raw_offset : raw_offset + size], raw_offset, symbol


def _relocation_width(machine: int, relocation_type: int) -> int:
    """Return a conservative width for a COFF relocation field."""

    if machine == MACHINE_I386:
        # IMAGE_REL_I386_SECTION is a 16-bit field.  All other supported
        # i386 code/data relocations used by normal compilers occupy four
        # bytes; treating an unknown type as four bytes rejects safely.
        return 2 if relocation_type == 0x000A else 4
    return 4


def _parse_string_table(reader: Reader, table_offset: int, symbol_count: int) -> bytes:
    if symbol_count < 0:
        raise VerificationError(f"{reader.label}: negative COFF symbol count")
    symbols_end = table_offset + symbol_count * COFF_SYMBOL_SIZE
    reader.require(symbols_end, 4, "COFF string-table size")
    string_size = reader.u32(symbols_end, "COFF string-table size")
    if string_size < 4:
        raise VerificationError(f"{reader.label}: invalid COFF string-table size {string_size}")
    string_table = reader.bytes(symbols_end, string_size, "COFF string table")
    return string_table


def _parse_symbols(reader: Reader, table_offset: int, symbol_count: int) -> list[CoffSymbol]:
    if table_offset == 0 and symbol_count == 0:
        return []
    if table_offset == 0 or symbol_count == 0:
        raise VerificationError(f"{reader.label}: incomplete COFF symbol-table header")
    string_table = _parse_string_table(reader, table_offset, symbol_count)
    symbols: list[CoffSymbol] = []
    index = 0
    while index < symbol_count:
        offset = table_offset + index * COFF_SYMBOL_SIZE
        raw = reader.bytes(offset, COFF_SYMBOL_SIZE, "COFF symbol")
        name = _coff_name(raw[:8], string_table, f"{reader.label} symbol {index}")
        value, section_number, symbol_type, storage_class, aux_count = struct.unpack(
            "<IhHBB", raw[8:]
        )
        if index + 1 + aux_count > symbol_count:
            raise VerificationError(f"{reader.label}: symbol {index} has truncated auxiliary records")
        symbols.append(
            CoffSymbol(
                name=name,
                value=value,
                section_number=section_number,
                symbol_type=symbol_type,
                storage_class=storage_class,
                index=index,
            )
        )
        index += 1 + aux_count
    return symbols


def _parse_sections(reader: Reader, section_offset: int, section_count: int) -> list[Section]:
    sections: list[Section] = []
    for index in range(section_count):
        offset = section_offset + index * 40
        raw = reader.bytes(offset, 40, f"section header {index}")
        name = raw[:8].split(b"\x00", 1)[0].decode("latin-1")
        virtual_size, virtual_address, raw_size, raw_pointer = struct.unpack("<IIII", raw[8:24])
        relocation_pointer = struct.unpack_from("<I", raw, 24)[0]
        relocation_count = struct.unpack_from("<H", raw, 32)[0]
        characteristics = struct.unpack_from("<I", raw, 36)[0]
        if raw_size:
            reader.require(raw_pointer, raw_size, f"section {name} raw data")
        if relocation_count:
            if relocation_pointer == 0:
                raise VerificationError(f"{reader.label}: section {name} has relocations at offset zero")
            reader.require(
                relocation_pointer,
                relocation_count * COFF_RELOCATION_SIZE,
                f"section {name} relocations",
            )
        sections.append(
            Section(
                name=name,
                virtual_size=virtual_size,
                virtual_address=virtual_address,
                raw_size=raw_size,
                raw_pointer=raw_pointer,
                relocation_pointer=relocation_pointer,
                relocation_count=relocation_count,
                characteristics=characteristics,
            )
        )
    return sections


def _parse_base_relocations(
    reader: Reader,
    data: bytes,
    sections: list[Section],
    relocation_rva: int,
    relocation_size: int,
) -> list[tuple[int, int]]:
    """Parse PE32 base relocations, including HIGHADJ's extra word."""

    _relocation_data, raw_offset, _section = _rva_bytes_from_sections(
        reader, data, sections, relocation_rva, relocation_size, "base relocation directory"
    )
    relocations: list[tuple[int, int]] = []
    cursor = 0
    while cursor < relocation_size:
        if relocation_size - cursor < 8:
            raise VerificationError("original PE: truncated base-relocation block")
        block_rva, block_size = struct.unpack_from("<II", data, raw_offset + cursor)
        if block_size < 8 or block_size > relocation_size - cursor or block_size % 2:
            raise VerificationError("original PE: invalid base-relocation block size")
        entry_count = (block_size - 8) // 2
        entry_index = 0
        while entry_index < entry_count:
            entry_offset = raw_offset + cursor + 8 + entry_index * 2
            entry = struct.unpack_from("<H", data, entry_offset)[0]
            relocation_type = entry >> 12
            relocation_offset = entry & 0x0FFF
            if relocation_type == 0:  # IMAGE_REL_BASED_ABSOLUTE padding.
                width = 0
            elif relocation_type in (1, 2):  # HIGH and LOW.
                width = 2
            elif relocation_type == 3:  # HIGHLOW.
                width = 4
            elif relocation_type == 4:  # HIGHADJ consumes the next 16-bit word.
                if entry_index + 1 >= entry_count:
                    raise VerificationError(
                        "original PE: HIGHADJ relocation is missing its adjustment word"
                    )
                width = 2
                entry_index += 1
            else:
                raise VerificationError(
                    f"original PE: unsupported base-relocation type {relocation_type}"
                )
            if width:
                relocations.append((block_rva + relocation_offset, width))
            entry_index += 1
        cursor += block_size
    return relocations


def _parse_pe(data: bytes) -> PEImage:
    reader = Reader(data, "original PE")
    if reader.bytes(0, 2, "DOS signature") != b"MZ":
        raise VerificationError("original PE: missing MZ signature")
    pe_offset = reader.u32(0x3C, "PE header offset")
    if reader.bytes(pe_offset, 4, "PE signature") != b"PE\x00\x00":
        raise VerificationError("original PE: missing PE signature")

    coff_offset = pe_offset + 4
    coff = reader.bytes(coff_offset, 20, "COFF file header")
    machine, section_count, _timestamp, symbol_pointer, symbol_count, optional_size, _characteristics = struct.unpack(
        "<HHIIIHH", coff
    )
    if machine != MACHINE_I386:
        raise VerificationError(
            f"original PE: wrong architecture 0x{machine:04x}; expected i386 0x{MACHINE_I386:04x}"
        )

    optional_offset = coff_offset + 20
    optional = reader.bytes(optional_offset, optional_size, "PE optional header")
    if optional_size < 2 or struct.unpack_from("<H", optional)[0] != PE32_MAGIC:
        raise VerificationError("original PE: expected PE32 optional header")
    if optional_size < 96:
        raise VerificationError("original PE: truncated PE32 optional header")
    directory_count = struct.unpack_from("<I", optional, 92)[0]
    section_offset = optional_offset + optional_size
    sections = _parse_sections(reader, section_offset, section_count)
    symbols = _parse_symbols(reader, symbol_pointer, symbol_count)

    base_relocations: list[tuple[int, int]] = []
    if directory_count > BASE_RELOCATION_DIRECTORY and optional_size >= 96 + (BASE_RELOCATION_DIRECTORY + 1) * 8:
        directory_offset = 96 + BASE_RELOCATION_DIRECTORY * 8
        relocation_rva, relocation_size = struct.unpack_from("<II", optional, directory_offset)
        if relocation_rva and relocation_size:
            base_relocations = _parse_base_relocations(
                reader, data, sections, relocation_rva, relocation_size
            )

    return PEImage(data, sections, symbols, base_relocations)


def _rva_bytes_from_sections(
    reader: Reader,
    data: bytes,
    sections: list[Section],
    rva: int,
    size: int,
    label: str,
) -> tuple[bytes, int, Section]:
    if rva < 0 or size <= 0:
        raise VerificationError(f"original PE: invalid {label} range")
    end = rva + size
    for section in sections:
        section_start = section.virtual_address
        section_end = section_start + max(section.virtual_size, section.raw_size)
        if section_start <= rva < section_end:
            offset = rva - section_start
            if end > section_end or offset + size > section.raw_size:
                raise VerificationError(f"original PE: {label} is outside raw section bytes")
            raw_offset = section.raw_pointer + offset
            reader.require(raw_offset, size, label)
            return data[raw_offset : raw_offset + size], raw_offset, section
    raise VerificationError(f"original PE: {label} RVA is outside a section")


def _parse_coff_object(data: bytes) -> CoffObject:
    reader = Reader(data, "COFF object")
    coff = reader.bytes(0, 20, "COFF file header")
    machine, section_count, _timestamp, symbol_pointer, symbol_count, optional_size, _characteristics = struct.unpack(
        "<HHIIIHH", coff
    )
    if machine != MACHINE_I386:
        raise VerificationError(
            f"COFF object: wrong architecture 0x{machine:04x}; expected i386 0x{MACHINE_I386:04x}"
        )
    section_offset = 20 + optional_size
    sections = _parse_sections(reader, section_offset, section_count)
    symbols = _parse_symbols(reader, symbol_pointer, symbol_count)
    return CoffObject(data, sections, symbols)


def _coff_relocations_overlapping(
    obj: CoffObject, section: Section, offset: int, size: int
) -> list[dict[str, int]]:
    if section.relocation_count == 0:
        return []
    start = offset
    end = offset + size
    overlaps: list[dict[str, int]] = []
    for index in range(section.relocation_count):
        relocation_offset = section.relocation_pointer + index * COFF_RELOCATION_SIZE
        raw = obj.reader.bytes(relocation_offset, COFF_RELOCATION_SIZE, f"{section.name} relocation")
        virtual_address, _symbol_index, relocation_type = struct.unpack("<IIH", raw)
        width = _relocation_width(MACHINE_I386, relocation_type)
        if virtual_address < end and virtual_address + width > start:
            overlaps.append({"offset": virtual_address, "size": width})
    return overlaps


def _parse_int(value: Any, field: str) -> int:
    if isinstance(value, bool):
        raise VerificationError(f"manifest: {field} must be an integer")
    if isinstance(value, int):
        result = value
    elif isinstance(value, str):
        try:
            result = int(value, 0)
        except ValueError as exc:
            raise VerificationError(f"manifest: {field} must be an integer") from exc
    else:
        raise VerificationError(f"manifest: {field} must be an integer")
    if result < 0:
        raise VerificationError(f"manifest: {field} must be non-negative")
    return result


def _manifest_provenance(manifest: dict[str, Any]) -> tuple[str, str]:
    description = manifest.get("description")
    source = manifest.get("source")
    if isinstance(description, dict):
        description_text = description.get("text") or description.get("summary")
        if source is None:
            source = description.get("source")
    else:
        description_text = description
    if not isinstance(description_text, str) or not description_text.strip():
        raise VerificationError("manifest: non-empty description is required")
    if not isinstance(source, str) or not source.strip():
        raise VerificationError("manifest: non-empty source is required")
    return description_text, source


def _validated_manifest(manifest: Any, manifest_path: Path) -> tuple[str, str, str, list[dict[str, Any]]]:
    if not isinstance(manifest, dict):
        raise VerificationError("manifest: top-level JSON value must be an object")
    description, source = _manifest_provenance(manifest)
    original_sha256 = manifest.get("original_sha256")
    if not isinstance(original_sha256, str) or len(original_sha256) != 64:
        raise VerificationError("manifest: original_sha256 must be a 64-character hex SHA-256")
    try:
        int(original_sha256, 16)
    except ValueError as exc:
        raise VerificationError("manifest: original_sha256 must be hexadecimal") from exc

    functions = manifest.get("functions")
    if not isinstance(functions, list) or not functions:
        raise VerificationError("manifest: functions must be a non-empty array")
    normalized: list[dict[str, Any]] = []
    for index, function in enumerate(functions):
        if not isinstance(function, dict):
            raise VerificationError(f"manifest: functions[{index}] must be an object")
        for key in ("rva", "size", "symbol", "object"):
            if key not in function:
                raise VerificationError(f"manifest: functions[{index}] is missing {key}")
        rva = _parse_int(function["rva"], f"functions[{index}].rva")
        size = _parse_int(function["size"], f"functions[{index}].size")
        if rva > 0xFFFFFFFF:
            raise VerificationError(f"manifest: functions[{index}].rva exceeds 32-bit RVA")
        if size <= 0:
            raise VerificationError(f"manifest: functions[{index}].size must be positive")
        if rva + size > 0x100000000:
            raise VerificationError(
                f"manifest: functions[{index}] range exceeds 32-bit RVA space"
            )
        symbol = function["symbol"]
        object_name = function["object"]
        if not isinstance(symbol, str) or not symbol:
            raise VerificationError(f"manifest: functions[{index}].symbol must be non-empty text")
        if not isinstance(object_name, str) or not object_name:
            raise VerificationError(f"manifest: functions[{index}].object must be non-empty text")
        object_path = Path(object_name)
        if not object_path.is_absolute():
            object_path = manifest_path.parent / object_path
        normalized.append(
            {
                "index": index,
                "rva": rva,
                "size": size,
                "symbol": symbol,
                "object": str(object_path.resolve()),
                "display_object": os.path.abspath(object_path),
            }
        )
    ranges = sorted(
        (function["rva"], function["rva"] + function["size"], function["index"])
        for function in normalized
    )
    for previous, current in zip(ranges, ranges[1:]):
        if current[0] < previous[1]:
            raise VerificationError(
                "manifest: functions[{}] range 0x{:x}-0x{:x} overlaps "
                "functions[{}] range 0x{:x}-0x{:x}".format(
                    current[2], current[0], current[1], previous[2], previous[0], previous[1]
                )
            )
    return description, source, original_sha256.lower(), normalized


def _difference_list(expected: bytes, actual: bytes) -> list[dict[str, int | str]]:
    return [
        {
            "offset": offset,
            "expected": f"{expected_byte:02x}",
            "actual": f"{actual_byte:02x}",
        }
        for offset, (expected_byte, actual_byte) in enumerate(zip(expected, actual))
        if expected_byte != actual_byte
    ]


def _display_path(path: Path | str, path_root: Optional[Path]) -> str:
    """Report spelling of a path: resolved absolute, or relative to path_root.

    The relative form starts from the absolute but unresolved path, so a symlinked
    directory (such as a worktree's work/) keeps its in-tree spelling.
    """

    if path_root is None:
        return str(Path(path).resolve())
    relative = os.path.relpath(os.path.abspath(path), os.path.abspath(path_root))
    return relative.replace(os.sep, "/")


def _empty_report(
    original_path: Path,
    manifest_path: Path,
    manifest_sha256: Optional[str] = None,
    path_root: Optional[Path] = None,
) -> dict[str, Any]:
    return {
        "original": _display_path(original_path, path_root),
        "manifest": _display_path(manifest_path, path_root),
        "manifest_original_sha256": manifest_sha256,
        "match_scope": "manifest-selected-byte-range",
        "function_completeness": "unverified",
        "all_byte_ranges_exact": False,
        "exact_byte_range_count": 0,
        "exact_byte_range_bytes": 0,
        "function_count": 0,
        "mismatch_count": 0,
        "mismatch_bytes": 0,
        "rejected_count": 0,
        "difference_count": 0,
        "difference_bytes": 0,
        "functions": [],
        "errors": [],
    }


def verify(
    original_path: Path, manifest_path: Path, path_root: Optional[Path] = None
) -> dict[str, Any]:
    report = _empty_report(original_path, manifest_path, path_root=path_root)
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        description, source, expected_sha256, functions = _validated_manifest(manifest, manifest_path)
        report["description"] = description
        report["source"] = source
        report["manifest_original_sha256"] = expected_sha256
        original_data = original_path.read_bytes()
        actual_sha256 = hashlib.sha256(original_data).hexdigest()
        report["original_sha256"] = actual_sha256
        if actual_sha256 != expected_sha256:
            raise VerificationError(
                "original PE: SHA-256 does not match manifest "
                f"({actual_sha256} != {expected_sha256})"
            )
        pe = _parse_pe(original_data)
    except (OSError, UnicodeError, json.JSONDecodeError, VerificationError) as exc:
        report["errors"] = [str(exc)]
        report["error"] = str(exc)
        return report

    report["function_count"] = len(functions)
    function_reports: list[dict[str, Any]] = []
    for function in functions:
        result: dict[str, Any] = {
            "rva": function["rva"],
            "size": function["size"],
            "symbol": function["symbol"],
            "object": function["object"]
            if path_root is None
            else _display_path(function["display_object"], path_root),
            "match_scope": "manifest-selected-byte-range",
            "function_completeness": "unverified",
            "status": "rejected",
            "exact_byte_range": False,
            "differences": [],
        }
        try:
            expected_bytes, original_offset, _section = pe.rva_bytes(function["rva"], function["size"])
            original_relocations = pe.relocations_overlapping(function["rva"], function["size"])
            if original_relocations:
                raise VerificationError(
                    "original PE: relocation overlaps candidate at "
                    + ", ".join(f"0x{item['rva']:x}" for item in original_relocations)
                )
            object_path = Path(function["object"])
            object_data = object_path.read_bytes()
            candidate = _parse_coff_object(object_data)
            actual_bytes, object_offset, _symbol = candidate.symbol_bytes(function["symbol"], function["size"])
            differences = _difference_list(expected_bytes, actual_bytes)
            result.update(
                {
                    "original_offset": original_offset,
                    "object_offset": object_offset,
                    "original_sha256": hashlib.sha256(expected_bytes).hexdigest(),
                    "object_sha256": hashlib.sha256(actual_bytes).hexdigest(),
                    "compared_bytes": function["size"],
                    "differences": differences,
                }
            )
            if differences:
                result["status"] = "byte-range-mismatch"
            else:
                result["status"] = "exact-byte-range"
                result["exact_byte_range"] = True
        except (OSError, VerificationError) as exc:
            result["error"] = str(exc)
        function_reports.append(result)

    report["functions"] = function_reports
    report["exact_byte_range_count"] = sum(1 for item in function_reports if item["exact_byte_range"])
    report["exact_byte_range_bytes"] = sum(
        item["size"] for item in function_reports if item["exact_byte_range"]
    )
    report["mismatch_count"] = sum(
        1 for item in function_reports if item["status"] == "byte-range-mismatch"
    )
    report["mismatch_bytes"] = sum(
        item["size"] for item in function_reports if item["status"] == "byte-range-mismatch"
    )
    report["rejected_count"] = sum(1 for item in function_reports if item["status"] == "rejected")
    report["difference_count"] = sum(len(item["differences"]) for item in function_reports)
    report["difference_bytes"] = report["difference_count"]
    report["all_byte_ranges_exact"] = report["exact_byte_range_count"] == report["function_count"]
    report["counts"] = {
        "functions": report["function_count"],
        "exact_byte_ranges": report["exact_byte_range_count"],
        "mismatches": report["mismatch_count"],
        "rejected": report["rejected_count"],
        "differences": report["difference_count"],
    }
    report["bytes"] = {
        "exact_byte_ranges": report["exact_byte_range_bytes"],
        "mismatches": report["mismatch_bytes"],
        "differences": report["difference_bytes"],
    }
    return report


def _write_report(report_path: Path, report: dict[str, Any]) -> None:
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def main(argv: Optional[Iterable[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("original", type=Path, help="original PE32 i386 executable")
    parser.add_argument("manifest", type=Path, help="JSON match manifest")
    parser.add_argument("--report", type=Path, help="write the JSON report to this path")
    parser.add_argument(
        "--path-root",
        type=Path,
        help="record original, manifest and object paths in the report relative to this directory",
    )
    args = parser.parse_args(argv)

    report = verify(args.original, args.manifest, args.path_root)
    encoded = json.dumps(report, indent=2, sort_keys=True)
    if args.report:
        try:
            _write_report(args.report, report)
        except OSError as exc:
            print(f"verify_matches: cannot write report: {exc}", file=sys.stderr)
            return 2
    print(encoded)
    if report.get("error"):
        return 2
    return 0 if report.get("all_byte_ranges_exact") else 1


if __name__ == "__main__":
    raise SystemExit(main())
