#!/usr/bin/env python3
"""Whole-file image composer for the Blackmoor reconstruction (packet M02).

The composer builds the complete 1,511,424-byte PE32 image of GAME.EXE from
three kinds of ranges and refuses to emit a file unless every byte is claimed
by exactly one of them:

``structured``
    Generated from the descriptions under ``image/`` (PE headers, Rich header,
    section table, import directory, IAT, resource directory tree, switch
    jump tables, ``int 3`` padding and zero padding).  No original byte is
    stored; the descriptions hold field values, names, hints and addresses.
``reconstructed``
    Assembled from reviewed reconstruction sources already in the repository
    (the S08-2/3/4 mnemonic assembly objects, assembled with the pinned GNU
    ``as``, plus the two incomplete 7-byte C ranges) and re-verified through
    ``verify_matches.py`` before their bytes are used; plus the audited
    tool-assisted assembly batches of packet M03 (``asm_batches``), reassembled
    with the pinned GNU ``as`` and checked against the code hashes in their
    manifests.  Provenance classes are reported separately.
``referenced``
    Copied at build time from the owner's local ``GAME.EXE`` by offset, length
    and SHA-256 (``image/ranges.json``).  A referenced range is a placeholder
    for work that is not done yet; it is reported separately and never counted
    as matched.

``missing`` (no description at all) is an error.

Commands::

    compose_image.py derive   # one-time bootstrap: write image/*.json from the local original
    compose_image.py build    # compose, report and (by default) require the whole-file hash
    compose_image.py stages   # rebuild with structured groups enabled one at a time

``derive`` reads the local original; ``build`` needs it only for referenced
ranges and for the final hash comparison.  Original bytes are never written
under version control.
"""

from __future__ import annotations

import argparse
import bisect
import hashlib
import importlib.util
import json
import re
import shutil
import struct
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Iterable, Optional

SCHEMA = 1
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
ORIGINAL_SIZE = 1511424

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
REPO_DIR = PROJECT_DIR.parent.parent
DEFAULT_IMAGE_DIR = PROJECT_DIR / "image"
DEFAULT_BUILD_DIR = PROJECT_DIR / "build" / "image"
DEFAULT_ORIGINAL = REPO_DIR / "work" / "original" / "GAME.EXE"
DEFAULT_ASSEMBLER = (
    REPO_DIR / "work" / "tools" / "s08-binutils-2.43.1" / "prefix" / "bin" / "i686-w64-mingw32-as"
)
DEFAULT_FUNCTION_INDEX = PROJECT_DIR / "function-index.json"

CLS_STRUCTURED = "structured"
CLS_RECONSTRUCTED = "reconstructed"
CLS_REFERENCED = "referenced"
CLS_MISSING = "missing"
CLASSES = (CLS_STRUCTURED, CLS_RECONSTRUCTED, CLS_REFERENCED, CLS_MISSING)

# Structured groups, in the order the packet introduces them.  ``derive`` and
# ``stages`` rely on this order.
GROUPS = (
    "dos_header",
    "rich_header",
    "pe_headers",
    "section_table",
    "header_padding",
    "iat",
    "import_directory",
    "resource_tree",
    "jump_tables",
    "int3_padding",
    "section_padding",
)

PAGE = 0x1000
TEXT_BASE_VA = 0x400000


class ComposeError(Exception):
    """A description, range or build step that cannot be composed."""


# --------------------------------------------------------------------------
# small helpers
# --------------------------------------------------------------------------


def num(value: Any) -> int:
    """Accept an int or a decimal/hex string."""
    if isinstance(value, bool):
        raise ComposeError(f"expected a number, got {value!r}")
    if isinstance(value, int):
        return value
    if isinstance(value, str):
        return int(value, 0)
    raise ComposeError(f"expected a number, got {value!r}")


def hx(value: int) -> str:
    return f"0x{value:x}"


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def rol32(value: int, count: int) -> int:
    count &= 31
    value &= 0xFFFFFFFF
    return ((value << count) | (value >> (32 - count))) & 0xFFFFFFFF if count else value


def load_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ComposeError(f"cannot read {path}: {exc}") from exc


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=1) + "\n", encoding="utf-8")


def write_json_rows(path: Path, head: dict[str, Any], key: str, rows: list[Any]) -> None:
    """Write ``head`` plus ``rows`` under ``key`` with one row per line."""
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = ["{"]
    for name, value in head.items():
        lines.append(f" {json.dumps(name)}: {json.dumps(value)},")
    lines.append(f" {json.dumps(key)}: [")
    for index, row in enumerate(rows):
        comma = "," if index + 1 < len(rows) else ""
        lines.append("  " + json.dumps(row, separators=(", ", ": ")) + comma)
    lines.append(" ]")
    lines.append("}")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


# --------------------------------------------------------------------------
# items and ranges
# --------------------------------------------------------------------------


@dataclass
class Item:
    offset: int
    length: int
    cls: str
    group: str
    name: str = ""
    section: str = ""
    kind: str = "data"  # code | data | header
    region: str = ""  # game | vorbis | crt_mfc for code, otherwise empty
    data: Optional[bytes] = None
    sha256: str = ""  # expected SHA-256 for referenced ranges
    stage_referenced: bool = False  # structured item served from the original in a staged build
    provenance: str = ""  # reconstructed items: the provenance class of the source that produced the bytes

    @property
    def end(self) -> int:
        return self.offset + self.length


@dataclass
class Layout:
    """Section geometry used to translate RVAs and attribute bytes to sections."""

    raw: dict[str, Any]
    sections: list[dict[str, Any]] = field(default_factory=list)

    def __post_init__(self) -> None:
        for section in self.raw["sections"]:
            self.sections.append(
                {
                    "name": section["name"],
                    "virtual_address": num(section["virtual_address"]),
                    "virtual_size": num(section["virtual_size"]),
                    "raw_pointer": num(section["raw_pointer"]),
                    "raw_size": num(section["raw_size"]),
                    "characteristics": num(section["characteristics"]),
                }
            )

    @property
    def image_base(self) -> int:
        return num(self.raw["pe"]["optional_header"]["ImageBase"])

    @property
    def header_size(self) -> int:
        return num(self.raw["pe"]["optional_header"]["SizeOfHeaders"])

    def rva_to_offset(self, rva: int) -> int:
        for section in self.sections:
            start = section["virtual_address"]
            if start <= rva < start + section["raw_size"]:
                return section["raw_pointer"] + (rva - start)
        raise ComposeError(f"RVA {hx(rva)} is outside every section's raw data")

    def section_of_offset(self, offset: int) -> str:
        if offset < self.header_size:
            return "<headers>"
        for section in self.sections:
            if section["raw_pointer"] <= offset < section["raw_pointer"] + section["raw_size"]:
                return section["name"]
        return "<outside>"

    def code_region(self, va: int) -> str:
        for region in self.raw["code_regions"]:
            if num(region["start_va"]) <= va < num(region["end_va"]):
                return region["name"]
        return "unattributed"


# --------------------------------------------------------------------------
# PE structure writers (shared by derive and build)
# --------------------------------------------------------------------------

DOS_FIELDS = (
    "e_cblp",
    "e_cp",
    "e_crlc",
    "e_cparhdr",
    "e_minalloc",
    "e_maxalloc",
    "e_ss",
    "e_sp",
    "e_csum",
    "e_ip",
    "e_cs",
    "e_lfarlc",
    "e_ovno",
)
COFF_FIELDS = (
    "Machine",
    "NumberOfSections",
    "TimeDateStamp",
    "PointerToSymbolTable",
    "NumberOfSymbols",
    "SizeOfOptionalHeader",
    "Characteristics",
)
OPTIONAL_FIELDS = (
    ("Magic", "H"),
    ("MajorLinkerVersion", "B"),
    ("MinorLinkerVersion", "B"),
    ("SizeOfCode", "I"),
    ("SizeOfInitializedData", "I"),
    ("SizeOfUninitializedData", "I"),
    ("AddressOfEntryPoint", "I"),
    ("BaseOfCode", "I"),
    ("BaseOfData", "I"),
    ("ImageBase", "I"),
    ("SectionAlignment", "I"),
    ("FileAlignment", "I"),
    ("MajorOperatingSystemVersion", "H"),
    ("MinorOperatingSystemVersion", "H"),
    ("MajorImageVersion", "H"),
    ("MinorImageVersion", "H"),
    ("MajorSubsystemVersion", "H"),
    ("MinorSubsystemVersion", "H"),
    ("Win32VersionValue", "I"),
    ("SizeOfImage", "I"),
    ("SizeOfHeaders", "I"),
    ("CheckSum", "I"),
    ("Subsystem", "H"),
    ("DllCharacteristics", "H"),
    ("SizeOfStackReserve", "I"),
    ("SizeOfStackCommit", "I"),
    ("SizeOfHeapReserve", "I"),
    ("SizeOfHeapCommit", "I"),
    ("LoaderFlags", "I"),
    ("NumberOfRvaAndSizes", "I"),
)
OPTIONAL_FORMAT = "<" + "".join(code for _, code in OPTIONAL_FIELDS)
OPTIONAL_STD_SIZE = struct.calcsize(OPTIONAL_FORMAT)
SECTION_ENTRY_SIZE = 40
DATA_DIRECTORY_COUNT = 16


def build_dos_header(dos: dict[str, Any], lfanew: int) -> bytes:
    """The 64-byte MZ header; fields not listed are zero."""
    header = bytearray(0x40)
    header[0:2] = b"MZ"
    values = [num(dos[name]) for name in DOS_FIELDS]
    struct.pack_into("<13H", header, 2, *values)
    struct.pack_into("<I", header, 0x3C, lfanew)
    return bytes(header)


def build_dos_region(layout: dict[str, Any]) -> bytes:
    """MZ header plus the standard linker stub, zero padded to the Rich offset."""
    pe = layout["pe"]
    region = bytearray(num(layout["rich"]["dans_offset"]))
    region[0:0x40] = build_dos_header(layout["dos_header"], num(pe["lfanew"]))
    stub = bytes.fromhex(layout["dos_stub"]["code_hex"]) + layout["dos_stub"]["message"].encode("latin-1")
    if 0x40 + len(stub) > len(region):
        raise ComposeError("DOS stub does not fit before the Rich header")
    region[0x40 : 0x40 + len(stub)] = stub
    return bytes(region)


def rich_checksum(dos_region: bytes, dans_offset: int, tuples: list[tuple[int, int]]) -> int:
    """Microsoft Rich header checksum over the DOS region and the comp-id tuples."""
    checksum = dans_offset
    for index in range(dans_offset):
        if 0x3C <= index < 0x40:
            continue  # e_lfanew is excluded
        checksum = (checksum + rol32(dos_region[index], index)) & 0xFFFFFFFF
    for comp_id, count in tuples:
        checksum = (checksum + rol32(comp_id, count)) & 0xFFFFFFFF
    return checksum


def build_rich_region(layout: dict[str, Any], dos_region: bytes) -> tuple[bytes, int]:
    """DanS block, XOR-ed comp-id tuples, ``Rich`` and the recomputed key, zero filled to the PE header."""
    rich = layout["rich"]
    dans = num(rich["dans_offset"])
    tuples = [((num(prod) << 16) | num(build), num(count)) for prod, build, count in rich["tuples"]]
    key = rich_checksum(dos_region, dans, tuples)
    out = bytearray()
    out += struct.pack("<I", 0x536E6144 ^ key)  # "DanS"
    out += struct.pack("<III", key, key, key)
    for comp_id, count in tuples:
        out += struct.pack("<II", comp_id ^ key, count ^ key)
    out += b"Rich" + struct.pack("<I", key)
    end = num(layout["pe"]["lfanew"])
    if dans + len(out) > end:
        raise ComposeError("Rich header overruns the PE header offset")
    out += bytes(end - dans - len(out))
    return bytes(out), key


def build_pe_headers(layout: dict[str, Any]) -> bytes:
    """``PE\\0\\0``, COFF file header and the optional header with its data directories."""
    pe = layout["pe"]
    coff = pe["file_header"]
    optional = pe["optional_header"]
    out = bytearray(b"PE\0\0")
    out += struct.pack("<HHIIIHH", *[num(coff[name]) for name in COFF_FIELDS])
    out += struct.pack(OPTIONAL_FORMAT, *[num(optional[name]) for name, _ in OPTIONAL_FIELDS])
    directories = layout["data_directories"]
    for index in range(DATA_DIRECTORY_COUNT):
        rva, size = directories.get(str(index), [0, 0])
        out += struct.pack("<II", num(rva), num(size))
    expected = 4 + 20 + num(coff["SizeOfOptionalHeader"])
    if len(out) != expected:
        raise ComposeError(f"optional header is {len(out)} bytes, SizeOfOptionalHeader says {expected}")
    return bytes(out)


def build_section_table(layout: dict[str, Any]) -> bytes:
    out = bytearray()
    for section in layout["sections"]:
        name = section["name"].encode("latin-1")
        if len(name) > 8:
            raise ComposeError(f"section name {section['name']!r} exceeds 8 bytes")
        out += name.ljust(8, b"\0")
        out += struct.pack(
            "<IIIIIIHHI",
            num(section["virtual_size"]),
            num(section["virtual_address"]),
            num(section["raw_size"]),
            num(section["raw_pointer"]),
            num(section.get("relocations_pointer", 0)),
            num(section.get("line_numbers_pointer", 0)),
            num(section.get("relocations_count", 0)),
            num(section.get("line_numbers_count", 0)),
            num(section["characteristics"]),
        )
    return bytes(out)


# --------------------------------------------------------------------------
# generators for every structured group
# --------------------------------------------------------------------------


def gen_header_groups(layout: Layout) -> list[Item]:
    """DOS header + stub, Rich header, PE headers, section table and header padding."""
    raw = layout.raw
    items: list[Item] = []
    dos_region = build_dos_region(raw)
    items.append(Item(0, len(dos_region), CLS_STRUCTURED, "dos_header", "dos_header_and_stub", "<headers>", "header", data=dos_region))
    rich_region, _ = build_rich_region(raw, dos_region)
    rich_offset = len(dos_region)
    items.append(Item(rich_offset, len(rich_region), CLS_STRUCTURED, "rich_header", "rich_header", "<headers>", "header", data=rich_region))
    pe_headers = build_pe_headers(raw)
    pe_offset = num(raw["pe"]["lfanew"])
    items.append(Item(pe_offset, len(pe_headers), CLS_STRUCTURED, "pe_headers", "pe_file_and_optional_header", "<headers>", "header", data=pe_headers))
    table = build_section_table(raw)
    table_offset = pe_offset + len(pe_headers)
    items.append(Item(table_offset, len(table), CLS_STRUCTURED, "section_table", "section_table", "<headers>", "header", data=table))
    pad_start = table_offset + len(table)
    pad_end = layout.header_size
    if pad_end < pad_start:
        raise ComposeError("SizeOfHeaders is smaller than the headers")
    if pad_end > pad_start:
        items.append(Item(pad_start, pad_end - pad_start, CLS_STRUCTURED, "header_padding", "header_zero_fill", "<headers>", "header", data=bytes(pad_end - pad_start)))
    return items


def import_thunk(symbol: dict[str, Any]) -> int:
    if "ordinal" in symbol:
        return 0x80000000 | num(symbol["ordinal"])
    return num(symbol["hint_name_rva"])


def gen_iat(layout: Layout, imports: dict[str, Any]) -> list[Item]:
    items = []
    for dll in imports["dlls"]:
        rva = num(dll["iat_rva"])
        data = b"".join(struct.pack("<I", import_thunk(s)) for s in dll["symbols"]) + struct.pack("<I", 0)
        items.append(
            Item(layout.rva_to_offset(rva), len(data), CLS_STRUCTURED, "iat", f"IAT {dll['name']}", ".rdata", "data", data=data)
        )
    return items


def gen_import_directory(layout: Layout, imports: dict[str, Any]) -> list[Item]:
    dlls = imports["dlls"]
    items = []
    descriptors = bytearray()
    for dll in dlls:
        descriptors += struct.pack(
            "<IIIII",
            num(dll["ilt_rva"]),
            num(dll.get("time_date_stamp", 0)),
            num(dll.get("forwarder_chain", 0)),
            num(dll["name_rva"]),
            num(dll["iat_rva"]),
        )
    descriptors += bytes(20)
    items.append(
        Item(layout.rva_to_offset(num(imports["directory_rva"])), len(descriptors), CLS_STRUCTURED, "import_directory", "import_descriptors", ".rdata", "data", data=bytes(descriptors))
    )
    for dll in dlls:
        ilt = b"".join(struct.pack("<I", import_thunk(s)) for s in dll["symbols"]) + struct.pack("<I", 0)
        items.append(Item(layout.rva_to_offset(num(dll["ilt_rva"])), len(ilt), CLS_STRUCTURED, "import_directory", f"ILT {dll['name']}", ".rdata", "data", data=ilt))
        name = dll["name"].encode("latin-1") + b"\0"
        items.append(Item(layout.rva_to_offset(num(dll["name_rva"])), len(name), CLS_STRUCTURED, "import_directory", f"DLL name {dll['name']}", ".rdata", "data", data=name))
        for symbol in dll["symbols"]:
            if "ordinal" in symbol:
                continue
            entry = struct.pack("<H", num(symbol["hint"])) + symbol["name"].encode("latin-1") + b"\0"
            if len(entry) % 2:
                entry += b"\0"
            items.append(
                Item(layout.rva_to_offset(num(symbol["hint_name_rva"])), len(entry), CLS_STRUCTURED, "import_directory", f"hint/name {symbol['name']}", ".rdata", "data", data=entry)
            )
    for rva, length in imports.get("gaps", []):
        items.append(Item(layout.rva_to_offset(num(rva)), num(length), CLS_STRUCTURED, "import_directory", "import_gap", ".rdata", "data", data=bytes(num(length))))
    return items


def gen_resource_tree(layout: Layout, resources: dict[str, Any]) -> list[Item]:
    base_rva = num(resources["section_rva"])
    base = layout.rva_to_offset(base_rva)
    items = []
    for directory in resources["directories"]:
        entries = directory["entries"]
        data = struct.pack(
            "<IIHHHH",
            num(directory.get("characteristics", 0)),
            num(directory.get("time_date_stamp", 0)),
            num(directory.get("major", 0)),
            num(directory.get("minor", 0)),
            0,  # named entries: none exist in this binary
            len(entries),
        )
        for entry in entries:
            if "directory" in entry:
                data += struct.pack("<II", num(entry["id"]), 0x80000000 | num(entry["directory"]))
            else:
                data += struct.pack("<II", num(entry["id"]), num(entry["data"]))
        items.append(Item(base + num(directory["offset"]), len(data), CLS_STRUCTURED, "resource_tree", f"resource directory {directory['offset']}", ".rsrc", "data", data=data))
    for entry in resources["data_entries"]:
        data = struct.pack("<IIII", num(entry["rva"]), num(entry["size"]), num(entry.get("codepage", 0)), num(entry.get("reserved", 0)))
        items.append(Item(base + num(entry["offset"]), len(data), CLS_STRUCTURED, "resource_tree", f"resource data entry {entry['path']}", ".rsrc", "data", data=data))
    return items


def gen_jump_tables(layout: Layout, text_data: dict[str, Any]) -> list[Item]:
    items = []
    for table in text_data["jump_tables"]:
        offset = num(table["offset"])
        if table["kind"] == "dword":
            data = b"".join(struct.pack("<I", num(v)) for v in table["entries"])
            name = f"switch table {hx(offset + layout.image_base)}"
        else:
            raise ComposeError(f"unknown jump table kind {table['kind']!r}")
        items.append(Item(offset, len(data), CLS_STRUCTURED, "jump_tables", name, ".text", "data", data=data))
    return items


def gen_int3_padding(layout: Layout, text_data: dict[str, Any]) -> list[Item]:
    return [
        Item(num(run["offset"]), num(run["length"]), CLS_STRUCTURED, "int3_padding", "int3 padding", ".text", "data", data=b"\xcc" * num(run["length"]))
        for run in text_data["int3_padding"]
    ]


def gen_section_padding(layout: Layout, section_padding: list[Any]) -> list[Item]:
    items = []
    for entry in section_padding:
        offset, length, section = num(entry[0]), num(entry[1]), entry[2]
        items.append(Item(offset, length, CLS_STRUCTURED, "section_padding", f"{section} zero fill", section, "data", data=bytes(length)))
    return items


def gen_resource_padding(layout: Layout, resources: dict[str, Any]) -> list[Item]:
    return [
        Item(layout.rva_to_offset(num(rva)), num(length), CLS_STRUCTURED, "section_padding", ".rsrc zero fill", ".rsrc", "data", data=bytes(num(length)))
        for rva, length in resources.get("padding", [])
    ]


# --------------------------------------------------------------------------
# reconstructed ranges: bind the reviewed matching objects
# --------------------------------------------------------------------------


def load_verifier() -> Any:
    """Import ``verify_matches.py`` (read-only) so binding shares its COFF/PE semantics."""
    path = SCRIPT_DIR / "verify_matches.py"
    spec = importlib.util.spec_from_file_location("verify_matches", path)
    if spec is None or spec.loader is None:
        raise ComposeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules.setdefault("verify_matches", module)
    spec.loader.exec_module(module)
    return module


def build_recipe_object(binding: dict[str, Any], build_dir: Path, assembler: Path) -> Path:
    """Produce the COFF object a binding names, from its committed source."""
    source = PROJECT_DIR / binding["source"]
    if not source.is_file():
        raise ComposeError(f"reconstruction source {source} is missing")
    object_path = build_dir / "objects" / Path(binding["object"]).name
    object_path.parent.mkdir(parents=True, exist_ok=True)
    tool = binding["tool"]
    if tool == "gnu-as":
        if not assembler.is_file():
            raise ComposeError(
                f"pinned GNU as not found at {assembler}; the accepted S08-2 private binutils 2.43.1 install is required"
            )
        command = [str(assembler), "--32", "-o", str(object_path), str(source)]
    elif tool == "clang-c":
        # Apple clang through xcrun on the Mac; any clang on PATH elsewhere (verify_matches decides whether the bytes are right).
        launcher = ["xcrun", "clang"] if shutil.which("xcrun") else [shutil.which("clang") or "clang"]
        command = [
            *launcher,
            "-target",
            "i686-pc-windows-msvc",
            "-O2",
            "-fomit-frame-pointer",
            "-fno-stack-protector",
            "-c",
            str(source),
            "-o",
            str(object_path),
        ]
    else:
        raise ComposeError(f"unknown build tool {tool!r} for {binding['source']}")
    try:
        completed = subprocess.run(command, capture_output=True, text=True, check=False)
    except OSError as exc:
        raise ComposeError(f"cannot run {command[0]}: {exc}") from exc
    if completed.returncode != 0:
        raise ComposeError(f"{tool} failed for {binding['source']}: {completed.stderr.strip()[:400]}")
    return object_path


def bind_reconstructed(
    layout: Layout,
    reconstructed: dict[str, Any],
    original_path: Path,
    build_dir: Path,
    assembler: Path,
    structured: Optional[Iterable[tuple[int, int]]] = None,
) -> tuple[list[Item], list[dict[str, Any]]]:
    """Assemble every binding, verify it against the original and return its ranges.

    ``structured`` lists the (offset, length) ranges the structured groups already generate; data items of an
    audited function inside them (switch tables, ``int3`` padding) are not bound a second time.

    The bytes come from the assembled objects, never from the original; the
    original is consulted only by ``verify_matches.verify`` (exact-range check).
    """
    verifier = load_verifier()
    items: list[Item] = []
    records: list[dict[str, Any]] = []
    taken: list[tuple[int, int, str]] = []
    for binding in reconstructed["bindings"]:
        manifest_path = PROJECT_DIR / binding["manifest"]
        object_path = build_recipe_object(binding, build_dir, assembler)
        manifest = load_json(manifest_path)
        staged = build_dir / "objects" / (Path(binding["manifest"]).stem + ".manifest.json")
        # Point the manifest at the object this run just built, keep everything else.
        retargeted = dict(manifest)
        retargeted["functions"] = [dict(f, object=str(object_path)) for f in manifest["functions"]]
        staged.write_text(json.dumps(retargeted), encoding="utf-8")
        report = verifier.verify(original_path, staged)
        if report.get("errors") or not report.get("all_byte_ranges_exact"):
            raise ComposeError(f"{binding['manifest']}: verify_matches did not report exact ranges: {report.get('errors') or report.get('mismatch_count')}")
        candidate = verifier._parse_coff_object(object_path.read_bytes())
        for function in manifest["functions"]:
            rva, size, symbol = num(function["rva"]), num(function["size"]), function["symbol"]
            offset = layout.rva_to_offset(rva)
            conflict = [t for t in taken if offset < t[1] and t[0] < offset + size]
            if conflict:
                records.append(
                    {"manifest": binding["manifest"], "symbol": symbol, "offset": offset, "length": size, "status": "superseded", "by": conflict[0][2]}
                )
                continue
            data, _, _ = candidate.symbol_bytes(symbol, size)
            taken.append((offset, offset + size, f"{binding['manifest']}:{symbol}"))
            items.append(
                Item(
                    offset,
                    size,
                    CLS_RECONSTRUCTED,
                    "reconstructed",
                    symbol,
                    ".text",
                    "code",
                    layout.code_region(rva + layout.image_base),
                    data=data,
                    provenance=binding["provenance_class"],
                )
            )
            records.append(
                {
                    "manifest": binding["manifest"],
                    "symbol": symbol,
                    "offset": offset,
                    "length": size,
                    "source": binding["source"],
                    "source_kind": binding["source_kind"],
                    "provenance_class": binding["provenance_class"],
                    "source_sha256": file_sha256(PROJECT_DIR / binding["source"]),
                    "object_sha256": file_sha256(object_path),
                    "range_sha256": sha256(data),
                    "status": "bound",
                }
            )
    asm_items, asm_records = bind_asm_batches(layout, reconstructed.get("asm_batches", []), build_dir, assembler, taken, None if structured is None else list(structured))
    return items + asm_items, records + asm_records


ASM_CLASS = "tool_assisted_reconstructed_assembly"
# Index tables are data items of an audited function (owner ruling 2026-10-14: labeled ``.byte`` lists), reported
# apart from the function code so that no code-byte or function count includes them.
ASM_INDEX_CLASS = "tool_assisted_reconstructed_index_table"
# Alignment padding (nop-equivalent instructions or ``.fill``) that the generator splits off a function span and
# the structured ``int3_padding`` group does not already generate; it is not a function and is reported apart.
ASM_PADDING_CLASS = "tool_assisted_reconstructed_padding"
ASM_DATA_CLASSES = (ASM_INDEX_CLASS, ASM_PADDING_CLASS)
# Endings other than a terminal ret/jmp (owner ruling of 2026-10-16): a code part that ends in a call with no
# instruction after it (whether the callee returns is not provable from the bytes) and a fragment that falls
# through; both count only bound together with the range that follows them.
ASM_ENDINGS = ("call-end", "fall-through")
ASM_WORKERS = 4


def load_auditor() -> Any:
    """Import ``audit_tool_assisted.py`` (read-only) for its pinned-assembler check."""
    path = SCRIPT_DIR / "audit_tool_assisted.py"
    spec = importlib.util.spec_from_file_location("audit_tool_assisted", path)
    if spec is None or spec.loader is None:
        raise ComposeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules.setdefault("audit_tool_assisted", module)
    spec.loader.exec_module(module)
    return module


def assemble_symbols(verifier: Any, assembler: Path, source: Path, wanted: list[tuple[str, int]]) -> list[bytes]:
    """Assemble one audited ``.s`` and return the bytes of the named symbols (code part first).

    The object is discarded after reading.  A relocation or a symbol outside
    ``.text`` is an error: every target must resolve at assembly time.
    """
    with tempfile.TemporaryDirectory(prefix="m02-asm-") as tmp:
        object_path = Path(tmp) / "function.obj"
        completed = subprocess.run(
            [str(assembler), "--32", "-o", str(object_path), str(source)], capture_output=True, text=True, check=False
        )
        if completed.returncode != 0:
            raise ComposeError(f"{source.name}: pinned GNU as rejected the source: {' '.join(completed.stderr.split())[:300]}")
        candidate = verifier._parse_coff_object(object_path.read_bytes())
    if any(section.relocation_count for section in candidate.sections):
        raise ComposeError(f"{source.name}: the object carries relocations")
    return [candidate.symbol_bytes(symbol, size)[0] for symbol, size in wanted]


def assemble_function_bytes(verifier: Any, assembler: Path, source: Path, symbol: str, size: int) -> bytes:
    """Assemble one audited ``.s`` and return the bytes of its code symbol."""
    return assemble_symbols(verifier, assembler, source, [(symbol, size)])[0]


def bind_asm_batches(
    layout: Layout,
    batches: list[dict[str, Any]],
    build_dir: Path,
    assembler: Path,
    taken: list[tuple[int, int, str]],
    structured: Optional[list[tuple[int, int]]] = None,
) -> tuple[list[Item], list[dict[str, Any]]]:
    """Bind audited tool-assisted assembly batches (packet M03) as reconstructed ranges.

    Each function's ``.s`` is reassembled with the pinned GNU as; the symbol's
    bytes must equal the SHA-256 the batch manifest records for the original
    code part (a comparison of hashes, no original byte is read here) and the
    batch must carry an all-accepted audit report whose manifest hash matches.
    The bytes come from the assembled object.  A function that overlaps a range
    bound earlier (the hand-written baseline) is reported as superseded.  Data
    items are bound as their own classes: index tables and padding that no structured group generates.
    Switch tables and ``int3`` padding are generated by the structured groups and are skipped here.
    """
    if not batches:
        return [], []
    verifier = load_verifier()
    problem, assembler_info = load_auditor().check_assembler(assembler)
    if problem:
        raise ComposeError(f"asm batches need the pinned assembler: {problem}")
    items: list[Item] = []
    records: list[dict[str, Any]] = []
    following: list[tuple[int, str]] = []
    for batch in batches:
        manifest_path = PROJECT_DIR / batch["manifest"]
        report_path = PROJECT_DIR / batch["report"]
        manifest = load_json(manifest_path)
        report = load_json(report_path)
        if batch.get("provenance_class", ASM_CLASS) != ASM_CLASS or manifest.get("class") != ASM_CLASS:
            raise ComposeError(f"{batch['manifest']}: not a {ASM_CLASS} batch")
        if manifest.get("original_sha256") != ORIGINAL_SHA256:
            raise ComposeError(f"{batch['manifest']}: describes a different original")
        if report.get("manifest_sha256") != file_sha256(manifest_path):
            raise ComposeError(f"{batch['report']}: audit report is stale (manifest hash differs)")
        if not report.get("all_accepted") or report.get("errors") or report.get("accepted_count") != len(manifest["functions"]):
            raise ComposeError(f"{batch['report']}: the audit did not accept every function in the batch")
        accepted = {f["function"]: f for f in report["functions"] if f.get("status") == "accepted"}
        functions = manifest["functions"]
        names = [f["function"] for f in functions]
        if len(set(names)) != len(names):
            raise ComposeError(f"{batch['manifest']}: a function is listed twice")
        for function in functions:
            audited = accepted.get(function["function"])
            if audited is None:
                raise ComposeError(f"{batch['report']}: {function['function']} is not accepted")
            if audited.get("source", {}).get("sha256") != function["source_sha256"] or audited.get("code") != function["code"]:
                raise ComposeError(f"{batch['report']}: the audited source or code part of {function['function']} differs from the manifest")
            if (audited.get("ending") or "") != (function.get("ending") or ""):
                raise ComposeError(f"{batch['report']}: the audited ending of {function['function']} differs from the manifest")
            if function.get("ending") and function["ending"] not in ASM_ENDINGS:
                raise ComposeError(f"{batch['manifest']}: {function['function']} has an unknown ending {function['ending']!r}")
            source = manifest_path.parent / function["source"]
            if file_sha256(source) != function["source_sha256"]:
                raise ComposeError(f"{function['source']}: source differs from the audited hash")
            if re.search(r"^\s*\.(incbin|include)\b", source.read_text(encoding="utf-8", errors="replace"), re.MULTILINE):
                raise ComposeError(f"{function['source']}: .incbin and .include are not permitted in reconstructed assembly")
            listed = sorted((d["kind"], d["symbol"], num(d["rva"]), num(d["size"])) for d in function.get("data_items", []))
            audited_items = sorted((d["kind"], d["symbol"], num(d["rva"]), num(d["size"])) for d in audited.get("data_items", []))
            if listed != audited_items:
                raise ComposeError(f"{batch['report']}: the audited data items of {function['function']} differ from the manifest")

        def index_tables(function: dict[str, Any]) -> list[dict[str, Any]]:
            """Audited data items to bind: index tables and padding that no structured group generates."""
            if structured is None:  # the caller did not say which ranges are structured: bind no data item
                return []
            chosen = []
            for d in accepted[function["function"]].get("data_items", []):
                offset, size = layout.rva_to_offset(num(d["rva"])), num(d["size"])
                inside = [r for r in structured if offset < r[0] + r[1] and r[0] < offset + size]
                if d["kind"] == "switch_table" or (inside and d["kind"] == "padding"):
                    if d["kind"] == "switch_table" and not any(r[0] <= offset and offset + size <= r[0] + r[1] for r in inside):
                        raise ComposeError(f"{function['function']}: switch table {d['symbol']} is not generated by a structured group")
                    if not any(r[0] <= offset and offset + size <= r[0] + r[1] for r in inside):
                        raise ComposeError(f"{function['function']}: padding {d['symbol']} partly overlaps a structured range")
                    continue
                if inside:
                    raise ComposeError(f"{function['function']}: {d['symbol']} overlaps a structured range")
                chosen.append(d)
            return chosen

        def assemble(function: dict[str, Any]) -> tuple[bytes, list[bytes]]:
            code = function["code"]
            tables = index_tables(function)
            wanted = [(code["symbol"], num(code["size"]))] + [(t["symbol"], num(t["size"])) for t in tables]
            data, *table_bytes = assemble_symbols(verifier, assembler, manifest_path.parent / function["source"], wanted)
            if sha256(data) != code["sha256"]:
                raise ComposeError(f"{function['source']}: assembled bytes differ from the audited original code part")
            for table, table_data in zip(tables, table_bytes):
                if sha256(table_data) != table["sha256"]:
                    raise ComposeError(f"{function['source']}: assembled {table['symbol']} differs from the audited original index table")
            return data, table_bytes

        with ThreadPoolExecutor(max_workers=ASM_WORKERS) as pool:
            assembled = list(pool.map(assemble, functions))

        bound = superseded = bound_bytes = 0
        ends: dict[str, int] = {}
        data_bytes: dict[str, int] = {}
        data_count: dict[str, int] = {}
        superseded_names: list[str] = []
        source_hashes: list[str] = []
        range_hashes: list[str] = []
        for function, (data, table_bytes) in zip(functions, assembled):
            code = function["code"]
            rva, size = num(code["rva"]), num(code["size"])
            offset = layout.rva_to_offset(rva)
            conflict = [t for t in taken if offset < t[1] and t[0] < offset + size]
            if conflict:
                if any(t[2].startswith(f"{batch['manifest']}:") for t in conflict):
                    raise ComposeError(f"{batch['manifest']}: {code['symbol']} overlaps another function of the same batch")
                superseded += 1
                superseded_names.append(f"{code['symbol']} by {conflict[0][2]}")
                continue
            taken.append((offset, offset + size, f"{batch['manifest']}:{code['symbol']}"))
            items.append(
                Item(
                    offset,
                    size,
                    CLS_RECONSTRUCTED,
                    "reconstructed",
                    code["symbol"],
                    ".text",
                    "code",
                    layout.code_region(rva + layout.image_base),
                    data=data,
                    provenance=ASM_CLASS,
                )
            )
            for table, table_data in zip(index_tables(function), table_bytes):
                table_offset, table_size = layout.rva_to_offset(num(table["rva"])), num(table["size"])
                if any(table_offset < t[1] and t[0] < table_offset + table_size for t in taken):
                    raise ComposeError(f"{batch['manifest']}: {table['symbol']} overlaps another bound range")
                taken.append((table_offset, table_offset + table_size, f"{batch['manifest']}:{table['symbol']}"))
                items.append(
                    Item(
                        table_offset,
                        table_size,
                        CLS_RECONSTRUCTED,
                        "reconstructed",
                        table["symbol"],
                        ".text",
                        "data",
                        layout.code_region(num(table["rva"]) + layout.image_base),
                        data=table_data,
                        provenance=ASM_INDEX_CLASS if table["kind"] == "index_table" else ASM_PADDING_CLASS,
                    )
                )
                data_bytes[table["kind"]] = data_bytes.get(table["kind"], 0) + table_size
                data_count[table["kind"]] = data_count.get(table["kind"], 0) + 1
                range_hashes.append(sha256(table_data))
            if function.get("ending"):
                ends[function["ending"]] = ends.get(function["ending"], 0) + 1
                following.append((offset + size, code["symbol"]))
            bound += 1
            bound_bytes += size
            source_hashes.append(function["source_sha256"])
            range_hashes.append(sha256(data))
        records.append(
            {
                "manifest": batch["manifest"],
                "symbol": batch["manifest"],
                "batch": manifest["batch"],
                "offset": 0,
                "length": bound_bytes,
                "source_kind": "tool_assisted_assembly",
                "provenance_class": ASM_CLASS,
                "status": "bound",
                "functions": bound,
                "index_tables": data_count.get("index_table", 0),
                "index_table_bytes": data_bytes.get("index_table", 0),
                "padding_items": data_count.get("padding", 0),
                "padding_bytes": data_bytes.get("padding", 0),
                "call_end_fragments": ends.get("call-end", 0),
                "fall_through_fragments": ends.get("fall-through", 0),
                "superseded": superseded,
                "superseded_list": superseded_names,
                "manifest_sha256": file_sha256(manifest_path),
                "report_sha256": file_sha256(report_path),
                "sources_sha256": sha256("\n".join(source_hashes).encode()),
                "range_sha256": sha256("\n".join(range_hashes).encode()),
                "assembler_version_line": assembler_info.get("version_line"),
            }
        )
    # a fragment that ends in a call or falls through counts only bound together with the range that follows it
    # (owner ruling of 2026-10-16)
    code_starts = {t[0] for t in taken if not t[2].rsplit(":", 1)[-1].startswith(("PAD_", "IDXTAB_", "SWTAB_"))}
    for end, symbol in following:
        if end not in code_starts:
            raise ComposeError(f"{symbol}: is followed by file offset {hx(end)}, which is not bound as code")
    return items, records


# --------------------------------------------------------------------------
# composition
# --------------------------------------------------------------------------


@dataclass
class Composition:
    data: bytes
    items: list[Item]
    sha256: str
    hash_match: bool
    size_match: bool
    enabled_groups: tuple[str, ...]
    reconstructed_records: list[dict[str, Any]]
    structured_mismatches: list[dict[str, Any]]
    layout: Layout
    ranges_meta: dict[str, Any]
    descriptions: dict[str, str]  # file name -> sha256


def load_descriptions(image_dir: Path) -> dict[str, Any]:
    names = ("layout", "imports", "resources", "text_data", "ranges", "reconstructed")
    loaded = {name: load_json(image_dir / f"{name}.json") for name in names}
    for name, value in loaded.items():
        if value.get("schema") != SCHEMA:
            raise ComposeError(f"{name}.json: unsupported schema {value.get('schema')!r}")
    return loaded


def structured_items(layout: Layout, desc: dict[str, Any]) -> dict[str, list[Item]]:
    by_group: dict[str, list[Item]] = {group: [] for group in GROUPS}
    for item in gen_header_groups(layout):
        by_group[item.group].append(item)
    by_group["iat"] = gen_iat(layout, desc["imports"])
    by_group["import_directory"] = gen_import_directory(layout, desc["imports"])
    by_group["resource_tree"] = gen_resource_tree(layout, desc["resources"])
    by_group["jump_tables"] = gen_jump_tables(layout, desc["text_data"])
    by_group["int3_padding"] = gen_int3_padding(layout, desc["text_data"])
    by_group["section_padding"] = gen_section_padding(layout, desc["layout"]["section_padding"]) + gen_resource_padding(layout, desc["resources"])
    return by_group


def referenced_items(layout: Layout, ranges: dict[str, Any], original: bytes) -> list[Item]:
    items = []
    columns = ranges["columns"]
    for row in ranges["ranges"]:
        record = dict(zip(columns, row))
        offset, length = num(record["offset"]), num(record["length"])
        if offset < 0 or length <= 0 or offset + length > len(original):
            raise ComposeError(f"referenced range {hx(offset)}+{length} lies outside the original")
        data = original[offset : offset + length]
        actual = sha256(data)
        if actual != record["sha256"]:
            raise ComposeError(
                f"referenced range {record.get('name')} at {hx(offset)}+{length}: SHA-256 {actual} does not match the description {record['sha256']}"
            )
        items.append(
            Item(
                offset,
                length,
                CLS_REFERENCED,
                "referenced",
                record.get("name", ""),
                layout.section_of_offset(offset),
                record["kind"],
                record.get("region", ""),
                data=data,
                sha256=record["sha256"],
            )
        )
    return items


def check_coverage(items: list[Item], size: int) -> list[Item]:
    """Sort and prove that the items tile ``[0, size)`` exactly once."""
    ordered = sorted(items, key=lambda i: (i.offset, i.length))
    cursor = 0
    gaps: list[str] = []
    for item in ordered:
        if item.length <= 0:
            raise ComposeError(f"{item.group}/{item.name}: empty range at {hx(item.offset)}")
        if item.offset < cursor:
            raise ComposeError(
                f"overlap: {item.group}/{item.name} at {hx(item.offset)}+{item.length} starts before {hx(cursor)}"
            )
        if item.offset > cursor:
            gaps.append(f"{hx(cursor)}+{item.offset - cursor}")
        cursor = item.end
    if cursor < size:
        gaps.append(f"{hx(cursor)}+{size - cursor}")
    if cursor > size:
        raise ComposeError(f"ranges extend to {hx(cursor)}, past the {size}-byte image")
    if gaps:
        shown = ", ".join(gaps[:8]) + (" ..." if len(gaps) > 8 else "")
        raise ComposeError(f"missing bytes: {len(gaps)} gap(s) not claimed by any range: {shown}")
    return ordered


def compose(
    image_dir: Path,
    original_path: Path,
    build_dir: Path,
    enabled_groups: Iterable[str] = GROUPS,
    assembler: Path = DEFAULT_ASSEMBLER,
    descriptions: Optional[dict[str, Any]] = None,
) -> Composition:
    """Compose the image.

    ``enabled_groups`` selects which structured groups are generated; the
    remaining groups are served from the local original (``stage_referenced``)
    so each group can be switched on one at a time while the hash is re-checked.
    """
    requested = set(enabled_groups)
    unknown = requested - set(GROUPS)
    if unknown:
        raise ComposeError(f"unknown structured groups: {sorted(unknown)}")
    enabled = tuple(g for g in GROUPS if g in requested)
    desc = descriptions if descriptions is not None else load_descriptions(image_dir)
    original = original_path.read_bytes()
    if len(original) != ORIGINAL_SIZE or sha256(original) != ORIGINAL_SHA256:
        raise ComposeError(f"{original_path} is not the pinned GAME.EXE (size/SHA-256 mismatch)")
    layout = Layout(desc["layout"])

    by_group = structured_items(layout, desc)
    items: list[Item] = []
    mismatches: list[dict[str, Any]] = []
    for group in GROUPS:
        for item in by_group[group]:
            expected = original[item.offset : item.end]
            if item.data != expected:
                first = next((i for i, (a, b) in enumerate(zip(item.data or b"", expected)) if a != b), None)
                mismatches.append(
                    {"group": group, "name": item.name, "offset": item.offset, "length": item.length, "first_difference": None if first is None else item.offset + first}
                )
            if group not in enabled:
                item = Item(item.offset, item.length, CLS_REFERENCED, group, item.name, item.section, item.kind, data=expected, stage_referenced=True)
            items.append(item)

    reconstructed_items, records = bind_reconstructed(
        layout, desc["reconstructed"], original_path, build_dir, assembler, [(i.offset, i.length) for i in items]
    )
    items += reconstructed_items
    items += referenced_items(layout, desc["ranges"], original)

    for item in items:
        if item.cls == CLS_RECONSTRUCTED and item.data != original[item.offset : item.end]:
            raise ComposeError(f"reconstructed range {item.name} at {hx(item.offset)}+{item.length} differs from the original bytes")

    ordered = check_coverage(items, ORIGINAL_SIZE)
    image = b"".join(item.data for item in ordered if item.data is not None)
    if len(image) != sum(item.length for item in ordered):
        raise ComposeError("internal error: a range produced the wrong number of bytes")
    digest = sha256(image)
    meta = {k: v for k, v in desc["ranges"].items() if k != "ranges"}
    hashes = {}
    for name in ("layout", "imports", "resources", "text_data", "ranges", "reconstructed"):
        hashes[f"{name}.json"] = file_sha256(image_dir / f"{name}.json")
    return Composition(
        data=image,
        items=ordered,
        sha256=digest,
        hash_match=digest == ORIGINAL_SHA256,
        size_match=len(image) == ORIGINAL_SIZE,
        enabled_groups=enabled,
        reconstructed_records=records,
        structured_mismatches=mismatches,
        layout=layout,
        ranges_meta=meta,
        descriptions=hashes,
    )


# --------------------------------------------------------------------------
# coverage report
# --------------------------------------------------------------------------


def coalesce(items: list[Item]) -> list[dict[str, Any]]:
    """Maximal contiguous runs of equal (class, group, section, kind, region)."""
    runs: list[dict[str, Any]] = []
    for item in items:
        key = (item.cls, item.group, item.section, item.kind, item.region)
        if runs and runs[-1]["_key"] == key and runs[-1]["offset"] + runs[-1]["length"] == item.offset:
            runs[-1]["length"] += item.length
            continue
        runs.append({"_key": key, "offset": item.offset, "length": item.length})
    return runs


def coverage_report(comp: Composition) -> dict[str, Any]:
    items = comp.items
    by_class: dict[str, dict[str, int]] = {c: {"bytes": 0, "ranges": 0} for c in CLASSES}
    for run in coalesce(items):
        cls = run["_key"][0]
        by_class[cls]["bytes"] += run["length"]
        by_class[cls]["ranges"] += 1
    by_section: dict[str, dict[str, Any]] = {}
    by_region: dict[str, dict[str, Any]] = {}
    by_group: dict[str, dict[str, int]] = {}
    for item in items:
        section = by_section.setdefault(item.section, {c: 0 for c in CLASSES})
        section[item.cls] += item.length
        if item.kind == "code":
            region = by_region.setdefault(item.region or "unattributed", {c: 0 for c in CLASSES})
            region[item.cls] += item.length
        group = by_group.setdefault(item.group if item.cls != CLS_REFERENCED or item.stage_referenced else "referenced", {"bytes": 0, "items": 0})
        group["bytes"] += item.length
        group["items"] += 1
    # Reconstructed code by the provenance class of the source that produced it; classes are reported separately.
    by_provenance: dict[str, dict[str, int]] = {}
    for item in items:
        if item.cls == CLS_RECONSTRUCTED:
            entry = by_provenance.setdefault(item.provenance or "unspecified", {"ranges": 0, "bytes": 0})
            entry["ranges"] += 1
            entry["bytes"] += item.length
    referenced = [i for i in items if i.cls == CLS_REFERENCED and not i.stage_referenced]
    staged = [i for i in items if i.stage_referenced]
    total = len(comp.data)
    generated = by_class[CLS_STRUCTURED]["bytes"] + by_class[CLS_RECONSTRUCTED]["bytes"]
    code_total = sum(i.length for i in items if i.kind == "code")
    code_recon = sum(i.length for i in items if i.kind == "code" and i.cls == CLS_RECONSTRUCTED)
    code_ref = sum(i.length for i in items if i.kind == "code" and i.cls == CLS_REFERENCED)
    return {
        "schema": SCHEMA,
        "packet": "M02",
        "original_sha256": ORIGINAL_SHA256,
        "composed_sha256": comp.sha256,
        "whole_file_hash_match": comp.hash_match,
        "composed_size": total,
        "enabled_structured_groups": list(comp.enabled_groups),
        "claim": (
            "Referenced ranges are copied from the local original at build time and are NOT counted as matched. "
            "Structured and reconstructed ranges are generated from committed sources. Structured generation "
            "does not claim original C++ or compiler provenance."
        ),
        "progress": {
            "total_bytes": total,
            "generated_bytes": generated,
            "generated_fraction": round(generated / total, 6),
            "referenced_bytes": by_class[CLS_REFERENCED]["bytes"],
            "missing_bytes": by_class[CLS_MISSING]["bytes"],
            "code_bytes": code_total,
            "code_bytes_reconstructed": code_recon,
            "code_bytes_referenced": code_ref,
            "code_bytes_reconstructed_fraction": round(code_recon / code_total, 6) if code_total else 0,
            "reconstructed_functions": sum(entry["ranges"] for name, entry in by_provenance.items() if name not in ASM_DATA_CLASSES),
            "reconstructed_index_table_bytes": by_provenance.get(ASM_INDEX_CLASS, {}).get("bytes", 0),
            "reconstructed_padding_bytes": by_provenance.get(ASM_PADDING_CLASS, {}).get("bytes", 0),
        },
        "by_class": by_class,
        "reconstructed_by_provenance": by_provenance,
        "by_section": by_section,
        "by_code_region": by_region,
        "by_group": by_group,
        "stage_referenced_bytes": sum(i.length for i in staged),
        "referenced_ranges": {
            "count": len(referenced),
            "bytes": sum(i.length for i in referenced),
            "list": [
                {
                    "offset": i.offset,
                    "length": i.length,
                    "sha256": i.sha256,
                    "section": i.section,
                    "kind": i.kind,
                    "region": i.region,
                    "name": i.name,
                }
                for i in referenced
            ],
        },
        "reconstructed": comp.reconstructed_records,
        "structured_mismatches": comp.structured_mismatches,
        "description_sha256": comp.descriptions,
    }


def render_markdown(report: dict[str, Any]) -> str:
    p = report["progress"]
    lines = [
        "# M02 image coverage",
        "",
        f"Composed {p['total_bytes']:,} bytes; whole-file SHA-256 match: **{report['whole_file_hash_match']}** (`{report['composed_sha256']}`).",
        "",
        report["claim"],
        "",
        "## Progress",
        "",
        f"- Generated (structured + reconstructed): {p['generated_bytes']:,} bytes ({p['generated_fraction'] * 100:.2f}%)",
        f"- Referenced from the local original (not matched): {p['referenced_bytes']:,} bytes in {report['referenced_ranges']['count']:,} described ranges",
        f"- Missing: {p['missing_bytes']:,} bytes",
        f"- Code bytes: {p['code_bytes']:,}; reconstructed {p['code_bytes_reconstructed']:,} ({p['code_bytes_reconstructed_fraction'] * 100:.2f}%); still referenced {p['code_bytes_referenced']:,}",
        f"- Reconstructed functions and derived code entries bound (separate classes below): {p['reconstructed_functions']:,}",
    ]
    dependent = sum(r.get("call_end_fragments", 0) + r.get("fall_through_fragments", 0) for r in report["reconstructed"])
    if dependent:
        lines.append(
            f"- Caveat: {dependent} of those entries end in a call or fall through into the next range, so they count only bound together with the range that follows (owner ruling of 2026-10-16); that no call-end callee is proven never to return is not claimed."
        )
    lines += [
        "",
        "## By class",
        "",
        "Ranges below are maximal contiguous runs of one class; the referenced list in `ranges.json` is finer (one entry per function piece, data page or resource payload).",
        "",
        "| Class | Bytes | Contiguous runs |",
        "|---|---:|---:|",
    ]
    for cls in CLASSES:
        entry = report["by_class"][cls]
        lines.append(f"| {cls} | {entry['bytes']:,} | {entry['ranges']:,} |")
    lines += ["", "## Reconstructed by provenance class", "", "| Class | Functions or ranges | Bytes |", "|---|---:|---:|"]
    for name, entry in report["reconstructed_by_provenance"].items():
        lines.append(f"| {name} | {entry['ranges']:,} | {entry['bytes']:,} |")
    lines += ["", "## By section", "", "| Section | structured | reconstructed | referenced |", "|---|---:|---:|---:|"]
    for name, entry in report["by_section"].items():
        lines.append(f"| {name} | {entry[CLS_STRUCTURED]:,} | {entry[CLS_RECONSTRUCTED]:,} | {entry[CLS_REFERENCED]:,} |")
    lines += ["", "## By code region", "", "| Region | reconstructed | referenced |", "|---|---:|---:|"]
    for name, entry in report["by_code_region"].items():
        lines.append(f"| {name} | {entry[CLS_RECONSTRUCTED]:,} | {entry[CLS_REFERENCED]:,} |")
    lines += ["", "## By structured group", "", "| Group | Bytes | Items |", "|---|---:|---:|"]
    for name, entry in report["by_group"].items():
        lines.append(f"| {name} | {entry['bytes']:,} | {entry['items']:,} |")
    lines += ["", "## Reconstructed ranges", "", "| Symbol | Offset | Length | Source kind | Status |", "|---|---:|---:|---|---|"]
    for record in report["reconstructed"]:
        if "functions" in record:
            lines.append(
                f"| `{record['manifest']}` ({record['functions']:,} functions, {record['superseded']} superseded by earlier bindings) | - | {record['length']:,} | {record.get('source_kind', '-')} | {record['status']} |"
            )
            continue
        lines.append(
            f"| `{record['symbol']}` | {hx(record['offset'])} | {record['length']} | {record.get('source_kind', '-')} | {record['status']} |"
        )
    lines.append("")
    lines.append("The full referenced-range list (offset, length, SHA-256) is `ranges.json`; `build/image/coverage-report.json` embeds it.")
    lines.append("")
    return "\n".join(lines)


# --------------------------------------------------------------------------
# derive: one-time bootstrap from the local original
# --------------------------------------------------------------------------


class Derivation:
    """Reads the local original and writes the committed descriptions."""

    def __init__(self, original: bytes, function_index: Path, image_dir: Path) -> None:
        self.d = original
        self.function_index = function_index
        self.image_dir = image_dir
        if len(original) != ORIGINAL_SIZE or sha256(original) != ORIGINAL_SHA256:
            raise ComposeError("derive needs the pinned GAME.EXE")

    def u16(self, o: int) -> int:
        return struct.unpack_from("<H", self.d, o)[0]

    def u32(self, o: int) -> int:
        return struct.unpack_from("<I", self.d, o)[0]

    def cstr(self, o: int) -> bytes:
        end = self.d.index(b"\0", o)
        return self.d[o:end]

    # ---- layout -----------------------------------------------------------
    def derive_layout(self) -> dict[str, Any]:
        d = self.d
        lfanew = self.u32(0x3C)
        if d[lfanew : lfanew + 4] != b"PE\0\0":
            raise ComposeError("no PE signature at e_lfanew")
        dos_values = struct.unpack_from("<13H", d, 2)
        dos_header = {name: hx(v) for name, v in zip(DOS_FIELDS, dos_values)}
        stub_code = d[0x40:0x4E]
        message = b"This program cannot be run in DOS mode.\r\r\n$"
        if d[0x4E : 0x4E + len(message)] != message:
            raise ComposeError("DOS stub text differs from the standard linker stub")
        coff_values = struct.unpack_from("<HHIIIHH", d, lfanew + 4)
        file_header = {name: hx(v) for name, v in zip(COFF_FIELDS, coff_values)}
        optional_values = struct.unpack_from(OPTIONAL_FORMAT, d, lfanew + 24)
        optional = {name: hx(v) for (name, _), v in zip(OPTIONAL_FIELDS, optional_values)}
        directories = {}
        for index in range(DATA_DIRECTORY_COUNT):
            rva, size = struct.unpack_from("<II", d, lfanew + 24 + OPTIONAL_STD_SIZE + 8 * index)
            if rva or size:
                directories[str(index)] = [hx(rva), hx(size)]
        sections = []
        table = lfanew + 24 + coff_values[5]
        for index in range(coff_values[1]):
            name, vsize, vaddr, rsize, rptr, relptr, lnptr, relcount, lncount, chars = struct.unpack_from(
                "<8sIIIIIIHHI", d, table + SECTION_ENTRY_SIZE * index
            )
            sections.append(
                {
                    "name": name.rstrip(b"\0").decode("latin-1"),
                    "virtual_size": hx(vsize),
                    "virtual_address": hx(vaddr),
                    "raw_size": hx(rsize),
                    "raw_pointer": hx(rptr),
                    "relocations_pointer": hx(relptr),
                    "line_numbers_pointer": hx(lnptr),
                    "relocations_count": relcount,
                    "line_numbers_count": lncount,
                    "characteristics": hx(chars),
                }
            )
        dans = 0x80
        key = self.u32(0xF4 if d[0xF0:0xF4] == b"Rich" else -1)
        if d[0xF0:0xF4] != b"Rich" or self.u32(dans) ^ key != 0x536E6144:
            raise ComposeError("Rich header not at the expected offsets")
        tuples = []
        cursor = dans + 16
        while cursor < 0xF0:
            comp_id = self.u32(cursor) ^ key
            count = self.u32(cursor + 4) ^ key
            tuples.append([comp_id >> 16, comp_id & 0xFFFF, count])
            cursor += 8
        layout: dict[str, Any] = {
            "schema": SCHEMA,
            "note": "Structured PE skeleton description for GAME.EXE. Field values only; no original code or data bytes. The Rich key is recomputed, not stored.",
            "original": {"sha256": ORIGINAL_SHA256, "size": ORIGINAL_SIZE},
            "dos_header": dos_header,
            "dos_stub": {
                "note": "Standard Microsoft linker 16-bit DOS stub (14 code bytes, then the message); boilerplate shared by every LINK-produced PE, not game code.",
                "code_hex": stub_code.hex(),
                "message": message.decode("latin-1"),
            },
            "rich": {
                "dans_offset": hx(dans),
                "note": "Tuples are [prodid, build, object count]; product names are community RichPE inferences (see M0 report).",
                "tuples": tuples,
            },
            "pe": {"lfanew": hx(lfanew), "file_header": file_header, "optional_header": optional},
            "data_directories": directories,
            "sections": sections,
            "code_regions": [
                {"name": "game", "start_va": "0x401000", "end_va": "0x4fcef0", "note": "C++ /Od game code"},
                {"name": "vorbis", "start_va": "0x4fcef0", "end_va": "0x50bf50", "note": "libvorbis and libogg"},
                {"name": "crt_mfc", "start_va": "0x50bf50", "end_va": "0x52925a", "note": "static CRT and MFC 4.2"},
            ],
            "section_padding": [],
        }
        return layout

    # ---- imports ----------------------------------------------------------
    def derive_imports(self, layout: Layout) -> dict[str, Any]:
        directory = layout.raw["data_directories"]["1"]
        dir_rva, dir_size = num(directory[0]), num(directory[1])
        count = dir_size // 20 - 1
        dlls = []
        covered: list[tuple[int, int, str]] = [(dir_rva, dir_rva + dir_size, "descriptors")]
        for index in range(count):
            offset = layout.rva_to_offset(dir_rva) + 20 * index
            ilt_rva, tds, fwd, name_rva, iat_rva = struct.unpack_from("<IIIII", self.d, offset)
            if tds or fwd:
                raise ComposeError("bound or forwarded imports are not supported")
            name = self.cstr(layout.rva_to_offset(name_rva))
            covered.append((name_rva, name_rva + len(name) + 1, f"name {name!r}"))
            symbols = []
            cursor = 0
            while True:
                ilt_value = self.u32(layout.rva_to_offset(ilt_rva) + 4 * cursor)
                iat_value = self.u32(layout.rva_to_offset(iat_rva) + 4 * cursor)
                if ilt_value != iat_value:
                    raise ComposeError(f"{name!r}: IAT differs from ILT at {cursor}")
                if ilt_value == 0:
                    break
                if ilt_value & 0x80000000:
                    symbols.append({"ordinal": ilt_value & 0xFFFF, "name": f"#{ilt_value & 0xFFFF}"})
                else:
                    entry = layout.rva_to_offset(ilt_value)
                    hint = self.u16(entry)
                    symbol_name = self.cstr(entry + 2)
                    size = 2 + len(symbol_name) + 1
                    if size % 2:
                        size += 1
                    covered.append((ilt_value, ilt_value + size, "hint/name"))
                    symbols.append({"name": symbol_name.decode("latin-1"), "hint": hint, "hint_name_rva": hx(ilt_value)})
                cursor += 1
            covered.append((ilt_rva, ilt_rva + 4 * (cursor + 1), "ILT"))
            dlls.append(
                {
                    "name": name.decode("latin-1"),
                    "ilt_rva": hx(ilt_rva),
                    "iat_rva": hx(iat_rva),
                    "name_rva": hx(name_rva),
                    "symbols": symbols,
                }
            )
        # zero gaps inside the import region
        region_start = min(c[0] for c in covered)
        region_end = max(c[1] for c in covered)
        gaps = []
        cursor = region_start
        for start, end, _ in sorted(covered):
            if start < cursor:
                raise ComposeError(f"import structures overlap at {hx(start)}")
            if start > cursor:
                gaps.append((cursor, start - cursor))
            cursor = end
        for rva, length in gaps:
            offset = layout.rva_to_offset(rva)
            if any(self.d[offset : offset + length]):
                raise ComposeError(f"import gap {hx(rva)}+{length} is not zero fill")
        iat_rva, iat_size = num(layout.raw["data_directories"]["12"][0]), num(layout.raw["data_directories"]["12"][1])
        iat_covered = sum(4 * (len(dll["symbols"]) + 1) for dll in dlls)
        if iat_covered != iat_size:
            raise ComposeError(f"IAT arrays cover {iat_covered} bytes, directory says {iat_size}")
        return {
            "schema": SCHEMA,
            "note": "Import directory and IAT of GAME.EXE: DLL order, symbol order, hints, name strings and RVAs. Unbound (zero time/date stamp); every thunk points at its hint/name entry or carries an ordinal.",
            "directory_rva": hx(dir_rva),
            "directory_size": hx(dir_size),
            "iat_rva": hx(iat_rva),
            "iat_size": hx(iat_size),
            "region_rva": hx(region_start),
            "region_end_rva": hx(region_end),
            "dlls": dlls,
            "gaps": [[hx(rva), length] for rva, length in gaps],
        }

    # ---- resources --------------------------------------------------------
    def derive_resources(self, layout: Layout) -> dict[str, Any]:
        directory = layout.raw["data_directories"]["2"]
        base_rva, total = num(directory[0]), num(directory[1])
        base = layout.rva_to_offset(base_rva)
        directories: list[dict[str, Any]] = []
        data_entries: list[dict[str, Any]] = []
        covered: list[tuple[int, int]] = []

        def walk(offset: int, path: list[int]) -> None:
            characteristics, stamp, major, minor, named, ids = struct.unpack_from("<IIHHHH", self.d, base + offset)
            if named:
                raise ComposeError("named resource entries are not supported")
            node: dict[str, Any] = {"offset": hx(offset), "entries": []}
            if characteristics or stamp or major or minor:
                node.update({"characteristics": characteristics, "time_date_stamp": stamp, "major": major, "minor": minor})
            covered.append((offset, offset + 16 + 8 * ids))
            directories.append(node)
            children = []
            for index in range(ids):
                ident, target = struct.unpack_from("<II", self.d, base + offset + 16 + 8 * index)
                if target & 0x80000000:
                    node["entries"].append({"id": ident, "directory": hx(target & 0x7FFFFFFF)})
                    children.append((target & 0x7FFFFFFF, path + [ident]))
                else:
                    rva, size, codepage, reserved = struct.unpack_from("<IIII", self.d, base + target)
                    entry = {
                        "offset": hx(target),
                        "path": "/".join(str(p) for p in path + [ident]),
                        "rva": hx(rva),
                        "size": size,
                        "codepage": codepage,
                        "reserved": reserved,
                    }
                    data_entries.append(entry)
                    node["entries"].append({"id": ident, "data": hx(target)})
                    covered.append((target, target + 16))
            for child, child_path in children:
                walk(child, child_path)

        walk(0, [])
        tree_end = max(end for _, end in covered)
        # payload extents and the padding between them
        payloads = sorted((num(e["rva"]), num(e["rva"]) + e["size"], e["path"]) for e in data_entries)
        padding = []
        cursor = base_rva + tree_end
        for start, end, path in payloads:
            if start < cursor:
                raise ComposeError(f"resource payload {path} overlaps earlier data")
            if start > cursor:
                padding.append((cursor, start - cursor))
            cursor = end
        raw_end = num(layout.raw["sections"][3]["virtual_address"]) + num(layout.raw["sections"][3]["raw_size"])
        if cursor < raw_end:
            padding.append((cursor, raw_end - cursor))
        for rva, length in padding:
            offset = layout.rva_to_offset(rva)
            if any(self.d[offset : offset + length]):
                raise ComposeError(f"resource gap {hx(rva)}+{length} is not zero fill")
        # tree must be gapless between structures
        covered.sort()
        position = 0
        for start, end in covered:
            if start != position:
                raise ComposeError(f"resource tree has an unexplained gap at {hx(position)}")
            position = end
        return {
            "schema": SCHEMA,
            "note": "Resource directory tree of GAME.EXE (ID-only, no named entries). Payloads are not stored: each leaf names an RVA and size and the payload is a referenced range until reconstructed.",
            "section_rva": hx(base_rva),
            "directory_size": hx(total),
            "tree_size": hx(tree_end),
            "directories": directories,
            "data_entries": data_entries,
            "padding": [[hx(rva), length] for rva, length in padding],
        }

    # ---- text: switch tables and int3 padding ------------------------------
    def derive_text(self, layout: Layout, spans: list[tuple[int, int]]) -> dict[str, Any]:
        text_section = layout.sections[0]
        base_va = layout.image_base + text_section["virtual_address"]
        text_offset = text_section["raw_pointer"]
        text_size = text_section["virtual_size"]
        text = self.d[text_offset : text_offset + text_size]
        starts = [s for s, _ in spans]

        def span_of(va: int) -> tuple[int, int]:
            i = bisect.bisect_right(starts, va) - 1
            return spans[i]

        def dword(va: int) -> int:
            return struct.unpack_from("<I", text, va - base_va)[0]

        # 1. tables named by `jmp dword ptr [reg*4 + disp32]`
        referenced: dict[int, int] = {}
        pattern = re.compile(rb"\xff\x24[\x85\x8d\x95\x9d\xad\xb5\xbd](....)", re.S)
        for match in pattern.finditer(text):
            target = struct.unpack("<I", match.group(1))[0]
            site = base_va + match.start()
            if base_va <= target < base_va + text_size and span_of(site)[0] <= target < span_of(site)[1]:
                referenced.setdefault(target, site)
        ref_sorted = sorted(referenced)

        tables: list[tuple[int, int]] = []  # (start va, entries)
        for target in ref_sorted:
            s, e = span_of(target)
            start = None
            for shift in (0, 4):
                if target + shift + 4 <= e and s <= dword(target + shift) < e:
                    start = target + shift
                    break
            if start is None:
                continue
            following = min([x for x in ref_sorted if x > target] + [e])
            n = 0
            while start + 4 * n + 4 <= min(e, following) and s <= dword(start + 4 * n) < e:
                n += 1
            tables.append((start, n))
        # 2. unreferenced runs of in-span code addresses next to the tables above
        claimed = bytearray(len(text))
        for start, n in tables:
            claimed[start - base_va : start - base_va + 4 * n] = b"\x01" * (4 * n)
        index = 0
        while index + 4 <= len(text):
            va = base_va + index
            s, e = span_of(va)
            if not claimed[index] and s <= dword(va) < e:
                run = 0
                while (
                    index + 4 * run + 4 <= len(text)
                    and va + 4 * run + 4 <= e
                    and not claimed[index + 4 * run]
                    and s <= dword(va + 4 * run) < e
                ):
                    run += 1
                if run >= 3:
                    tables.append((va, run))
                    claimed[index : index + 4 * run] = b"\x01" * (4 * run)
                    index += 4 * run
                    continue
            index += 1
        tables.sort()
        table_starts = [t[0] for t in tables]

        # 3. byte index tables: the bytes after a dword table that are smaller than its entry count
        jump_tables: list[dict[str, Any]] = []
        index_tables: list[dict[str, Any]] = []
        for start, n in tables:
            s, e = span_of(start)
            end = start + 4 * n
            jump_tables.append({"offset": hx(start - layout.image_base), "kind": "dword", "entries": [hx(dword(start + 4 * k)) for k in range(n)]})
            limit = min([e] + [t for t in table_starts if t > start])
            probe = end
            while probe < limit and text[probe - base_va] < n:
                probe += 1
            if probe > end:
                # Raw index bytes are original data: only the extent is described here and
                # the bytes stay hash-referenced (see derive_ranges).
                index_tables.append(
                    {"offset": hx(end - layout.image_base), "length": probe - end, "table": hx(start - layout.image_base)}
                )
        # 4. trailing 0xCC padding of each span (after tables)
        padding_runs = []
        for s, e in spans:
            cursor = e - base_va
            origin = s - base_va
            while cursor > origin and text[cursor - 1] == 0xCC:
                cursor -= 1
            if cursor < e - base_va:
                padding_runs.append({"offset": hx(text_offset + cursor), "length": (e - base_va) - cursor})
        # sanity: tables and padding must not overlap one another
        taken = sorted(
            [(num(t["offset"]), num(t["offset"]) + 4 * len(t["entries"])) for t in jump_tables]
            + [(num(t["offset"]), num(t["offset"]) + t["length"]) for t in index_tables]
            + [(num(p["offset"]), num(p["offset"]) + p["length"]) for p in padding_runs]
        )
        for a, b in zip(taken, taken[1:]):
            if a[1] > b[0]:
                raise ComposeError(f"text data items overlap near {hx(b[0])}")
        return {
            "schema": SCHEMA,
            "note": (
                "Data items inside .text: switch jump tables (absolute code addresses) and 0xCC padding at the end of function spans are structured; "
                "the byte index tables that follow some tables are listed by extent only (index_tables) and stay hash-referenced data ranges. "
                "Offsets are file offsets (equal to RVAs in .text). Derived by M02's own heuristic (jmp [reg*4+table] references, in-span code addresses, index bytes smaller than the entry count); "
                "M03's per-function split supersedes it."
            ),
            "dword_table_count": len(tables),
            "index_table_count": len(index_tables),
            "jump_tables": jump_tables,
            "index_tables": index_tables,
            "int3_padding": padding_runs,
        }

    # ---- section zero fill -------------------------------------------------
    def derive_section_padding(self, layout: Layout, imports: dict[str, Any]) -> list[Any]:
        padding = []
        d = self.d
        # .text raw bytes past its virtual size
        text = layout.sections[0]
        start = text["raw_pointer"] + text["virtual_size"]
        end = text["raw_pointer"] + text["raw_size"]
        if any(d[start:end]):
            raise ComposeError(".text tail is not zero fill")
        padding.append([hx(start), end - start, ".text"])
        # .rdata tail past the end of the import region (everything after it up to the raw end)
        rdata = layout.sections[1]
        region_end = layout.rva_to_offset(num(imports["region_end_rva"]))
        end = rdata["raw_pointer"] + rdata["raw_size"]
        if any(d[region_end:end]):
            raise ComposeError(".rdata tail after the import region is not zero fill")
        if end > region_end:
            padding.append([hx(region_end), end - region_end, ".rdata"])
        return padding

    # ---- ranges ------------------------------------------------------------
    def derive_ranges(
        self,
        layout: Layout,
        structured: list[Item],
        reconstructed: list[tuple[int, int]],
        spans: list[tuple[int, int]],
        resources: dict[str, Any],
        index_tables: list[dict[str, Any]],
    ) -> dict[str, Any]:
        d = self.d
        bound_ranges = set(reconstructed)
        claimed = bytearray(len(d))
        for item in structured:
            claimed[item.offset : item.end] = b"\x01" * item.length
        for offset, length in reconstructed:
            claimed[offset : offset + length] = b"\x01" * length
        # an index table is referenced unless an audited batch binds all of it (then it is a reconstructed data item)
        unbound_tables: list[dict[str, Any]] = []
        for table in index_tables:
            offset, length = num(table["offset"]), num(table["length"])
            covered = sum(claimed[offset : offset + length])
            if covered == length and (offset, length) in bound_ranges:
                continue
            if covered:
                raise ComposeError(f"index table at {hx(offset)} overlaps a structured or reconstructed item")
            claimed[offset : offset + length] = b"\x01" * length
            unbound_tables.append(table)
        rows: list[list[Any]] = []

        def emit(start: int, end: int, name: str, kind: str, region: str, section: str) -> None:
            data = d[start:end]
            rows.append([start, end - start, sha256(data), kind, region, name])

        # function pieces
        text = layout.sections[0]
        base_va = layout.image_base + text["virtual_address"]
        for s, e in spans:
            lo, hi = s - base_va + text["raw_pointer"], e - base_va + text["raw_pointer"]
            region = layout.code_region(s)
            cursor = lo
            piece = 0
            while cursor < hi:
                if claimed[cursor]:
                    cursor += 1
                    continue
                end = cursor
                while end < hi and not claimed[end]:
                    end += 1
                name = f"FUN_{s:08x}" if piece == 0 and cursor == lo else f"FUN_{s:08x}+{cursor - lo:#x}"
                emit(cursor, end, name, "code", region, ".text")
                piece += 1
                cursor = end
        for table in unbound_tables:
            offset, length = num(table["offset"]), num(table["length"])
            emit(offset, offset + length, f"switch index table {hx(offset + layout.image_base)}", "data", layout.code_region(offset + layout.image_base), ".text")
        # data sections: everything not claimed, in page-bounded chunks
        for section in layout.sections[1:]:
            if section["name"] == ".rsrc":
                continue
            lo, hi = section["raw_pointer"], section["raw_pointer"] + section["raw_size"]
            cursor = lo
            while cursor < hi:
                if claimed[cursor]:
                    cursor += 1
                    continue
                end = cursor
                while end < hi and not claimed[end]:
                    end += 1
                position = cursor
                while position < end:
                    chunk_end = min(end, (position // PAGE + 1) * PAGE)
                    emit(position, chunk_end, f"{section['name']} data {position:#x}", "data", "", section["name"])
                    position = chunk_end
                cursor = end
        # resource payloads: one range per leaf; they must be exactly what the tree leaves unclaimed
        rsrc = layout.sections[3]
        for entry in sorted(resources["data_entries"], key=lambda e: num(e["rva"])):
            lo = layout.rva_to_offset(num(entry["rva"]))
            if any(claimed[lo : lo + entry["size"]]):
                raise ComposeError(f"resource payload {entry['path']} overlaps a structured item")
            emit(lo, lo + entry["size"], f"resource {entry['path']}", "data", "", ".rsrc")
            claimed[lo : lo + entry["size"]] = b"\x01" * entry["size"]
        left = [i for i in range(rsrc["raw_pointer"], rsrc["raw_pointer"] + rsrc["raw_size"]) if not claimed[i]]
        if left:
            raise ComposeError(f".rsrc has {len(left)} bytes outside the tree, padding and payloads (first {hx(left[0])})")
        rows.sort(key=lambda r: r[0])
        return {
            "schema": SCHEMA,
            "note": "Referenced ranges: copied from the local original by offset and length, verified by SHA-256. Placeholders for work not yet done; never counted as matched. Function pieces are the function-index spans minus structured items and reconstructed ranges.",
            "original_sha256": ORIGINAL_SHA256,
            "columns": ["offset", "length", "sha256", "kind", "region", "name"],
            "_rows": rows,
        }


def read_spans(function_index: Path, text_end_va: int) -> list[tuple[int, int]]:
    index = load_json(function_index)
    starts = sorted(num(f["address"]) for f in index["functions"])
    ends = starts[1:] + [text_end_va]
    return list(zip(starts, ends))


def derive(original_path: Path, image_dir: Path, function_index: Path, assembler: Path, build_dir: Path) -> None:
    original = original_path.read_bytes()
    derivation = Derivation(original, function_index, image_dir)
    layout_raw = derivation.derive_layout()
    layout = Layout(layout_raw)
    imports = derivation.derive_imports(layout)
    resources = derivation.derive_resources(layout)
    text_section = layout.sections[0]
    spans = read_spans(function_index, layout.image_base + text_section["virtual_address"] + text_section["virtual_size"])
    text_data = derivation.derive_text(layout, spans)
    layout_raw["section_padding"] = derivation.derive_section_padding(layout, imports)
    reconstructed = load_json(image_dir / "reconstructed.json")
    desc = {
        "layout": layout_raw,
        "imports": imports,
        "resources": resources,
        "text_data": text_data,
        "reconstructed": reconstructed,
        "ranges": {"schema": SCHEMA, "columns": ["offset", "length", "sha256", "kind", "region", "name"], "ranges": []},
    }
    structured = structured_items(layout, desc)
    flat = [item for group in GROUPS for item in structured[group]]
    # reconstructed ranges (RVA == offset in .text)
    bound, _ = bind_reconstructed(layout, reconstructed, original_path, build_dir, assembler, [(i.offset, i.length) for i in flat])
    ranges = derivation.derive_ranges(layout, flat, [(i.offset, i.length) for i in bound], spans, resources, text_data["index_tables"])
    write_json(image_dir / "layout.json", layout_raw)
    write_json(image_dir / "imports.json", imports)
    write_json(image_dir / "resources.json", resources)
    write_json(image_dir / "text_data.json", text_data)
    rows = ranges.pop("_rows")
    write_json_rows(image_dir / "ranges.json", ranges, "ranges", rows)


# --------------------------------------------------------------------------
# CLI
# --------------------------------------------------------------------------


def print_summary(comp: Composition, report: dict[str, Any]) -> None:
    p = report["progress"]
    print(f"composed {len(comp.data):,} bytes; sha256 {comp.sha256}")
    print(f"whole-file hash match: {comp.hash_match}")
    print(
        f"structured {report['by_class'][CLS_STRUCTURED]['bytes']:,} B, reconstructed {report['by_class'][CLS_RECONSTRUCTED]['bytes']:,} B, "
        f"referenced {report['by_class'][CLS_REFERENCED]['bytes']:,} B ({report['referenced_ranges']['count']:,} ranges), missing {p['missing_bytes']}"
    )


def cmd_build(args: argparse.Namespace) -> int:
    try:
        comp = compose(args.image_dir, args.original, args.build_dir, args.groups or GROUPS, args.assembler)
    except ComposeError as exc:
        print(f"compose_image: {exc}", file=sys.stderr)
        return 2
    report = coverage_report(comp)
    args.build_dir.mkdir(parents=True, exist_ok=True)
    if comp.hash_match or args.keep_mismatch:
        (args.build_dir / "GAME.composed.exe").write_bytes(comp.data)
    write_json(args.build_dir / "coverage-report.json", report)
    (args.build_dir / "coverage-report.md").write_text(render_markdown(report), encoding="utf-8")
    print_summary(comp, report)
    if comp.structured_mismatches:
        print(f"structured items that differ from the original: {len(comp.structured_mismatches)}", file=sys.stderr)
        for item in comp.structured_mismatches[:10]:
            print(f"  {item['group']}: {item['name']} at {hx(item['offset'])} first difference {item['first_difference']}", file=sys.stderr)
    if args.require_match and not comp.hash_match:
        print("compose_image: whole-file SHA-256 does not match the original", file=sys.stderr)
        return 1
    return 0


def cmd_stages(args: argparse.Namespace) -> int:
    """Switch structured groups on one at a time and re-confirm the whole-file hash."""
    results = []
    enabled: list[str] = []
    ok = True
    for stage, group in enumerate((None,) + GROUPS):
        if group:
            enabled.append(group)
        try:
            comp = compose(args.image_dir, args.original, args.build_dir, tuple(enabled), args.assembler)
        except ComposeError as exc:
            print(f"compose_image: stage {stage}: {exc}", file=sys.stderr)
            return 2
        report = coverage_report(comp)
        row = {
            "stage": stage,
            "enabled_group": group,
            "sha256": comp.sha256,
            "hash_match": comp.hash_match,
            "structured_bytes": report["by_class"][CLS_STRUCTURED]["bytes"],
            "reconstructed_bytes": report["by_class"][CLS_RECONSTRUCTED]["bytes"],
            "referenced_bytes": report["by_class"][CLS_REFERENCED]["bytes"],
        }
        results.append(row)
        ok = ok and comp.hash_match
        print(
            f"stage {stage:2d} {group or '(all referenced)':<18} match={comp.hash_match} structured={row['structured_bytes']:>9,} referenced={row['referenced_bytes']:>9,}"
        )
    write_json(args.build_dir / "stage-report.json", {"schema": SCHEMA, "stages": results})
    return 0 if ok else 1


def cmd_derive(args: argparse.Namespace) -> int:
    try:
        derive(args.original, args.image_dir, args.function_index, args.assembler, args.build_dir)
    except ComposeError as exc:
        print(f"compose_image: {exc}", file=sys.stderr)
        return 2
    print(f"wrote descriptions under {args.image_dir}")
    return 0


def make_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="command", required=True)

    def common(p: argparse.ArgumentParser) -> None:
        p.add_argument("--original", type=Path, default=DEFAULT_ORIGINAL, help="local GAME.EXE (read-only)")
        p.add_argument("--image-dir", type=Path, default=DEFAULT_IMAGE_DIR)
        p.add_argument("--build-dir", type=Path, default=DEFAULT_BUILD_DIR)
        p.add_argument("--assembler", type=Path, default=DEFAULT_ASSEMBLER, help="pinned i686-w64-mingw32-as 2.43.1")

    build = sub.add_parser("build", help="compose the image and write the coverage report")
    common(build)
    build.add_argument("--groups", nargs="*", choices=GROUPS, help="structured groups to generate (default: all)")
    build.add_argument("--no-require-match", dest="require_match", action="store_false", help="do not fail on a hash mismatch")
    build.add_argument("--keep-mismatch", action="store_true", help="write the composed file even when the hash differs")
    build.set_defaults(func=cmd_build, require_match=True)

    stages = sub.add_parser("stages", help="enable structured groups one at a time and re-confirm the hash")
    common(stages)
    stages.set_defaults(func=cmd_stages)

    derive_cmd = sub.add_parser("derive", help="one-time bootstrap: write image/*.json from the local original")
    common(derive_cmd)
    derive_cmd.add_argument("--function-index", type=Path, default=DEFAULT_FUNCTION_INDEX)
    derive_cmd.set_defaults(func=cmd_derive)
    return parser


def main(argv: Optional[Iterable[str]] = None) -> int:
    args = make_parser().parse_args(list(argv) if argv is not None else None)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
