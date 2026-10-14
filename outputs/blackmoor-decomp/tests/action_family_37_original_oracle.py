#!/usr/bin/env python3
"""Compare A-37.2 native values with the immutable original x86 constructor."""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import importlib.util
import json
import struct
import sys
import time
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_CORPUS = ROOT / "work/analysis/slices/A-37.1-discovery-corpus.json"
DEFAULT_MANIFEST = ROOT / "work/analysis/hiff-resources.json"
DEFAULT_NATIVE = ROOT / "outputs/blackmoor-decomp/build/libactionfamily37.dylib"
DEFAULT_RESULT = ROOT / "work/analysis/slices/A-37.2-original-oracle.json"
EXPECTED_EXE_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
EXPECTED_CORPUS_SHA256 = "a4253c266d94267a563bc357dbaf3ed69a6e1fbd2ddd5198b0ec71bf5e04296d"
EXPECTED_MANIFEST_SHA256 = "440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c"
EXPECTED_ARCHIVE_SHA256 = "1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161"
EXPECTED_CURSOR_WINDOW_SHA256 = "32a07731b8e58ed2fa7d5de9a8a952a45063ce267ab161db291e157350f76534"
EXPECTED_RAW37_DISPATCH_SHA256 = "b1dfaf06c05f64aa21b2aed0fb70fdec982a65cddb8aee67044d5a28b3842730"
EXPECTED_DEFAULTS_SHA256 = "799385eaa2201dd5e8137d0e30f1e96fe0d6a0cbaf4390fe3966bf987464f79a"
EXPECTED_CONSTRUCTOR_SHA256 = "717d0de9f08e537cf3833bc5664716f6df3452ed642f638453e4e7567a990410"

PAGE = 0x1000
STACK = 0x1000
STACK_SIZE = 0x10000
INPUT = 0x20000000
DATA = 0x30000000
SENTINEL = 0x51000000
OWNER = DATA + 0x1000
RESULT_SLOT = DATA + 0x2000
CURSOR = DATA + 0x2100
PAYLOAD_OFFSET = DATA + 0x2104
OUT = DATA + 0x5000
ALLOCATOR = 0x51DC43
OBJECT_BYTES = 0xABA
BODY_BYTES = 0x45
DEPENDENCY_BYTES = 0x10


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


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def pointer_value(pointer) -> int | None:
    return c.cast(pointer, c.c_void_p).value if pointer else None


def load_native(path: Path):
    lib = c.CDLL(str(path))
    lib.action_family_37_decode.argtypes = [
        c.POINTER(c.c_uint8), c.c_size_t, c.POINTER(Decoded)
    ]
    lib.action_family_37_decode.restype = c.c_int
    lib.action_family_37_construct.argtypes = [
        c.POINTER(c.c_uint8), c.c_size_t, c.c_uint32, c.c_uint32,
        c.POINTER(Constructed),
    ]
    lib.action_family_37_construct.restype = c.c_int
    return lib


def map_original(exe_path: Path):
    pe_source = ROOT / "outputs/blackmoor-decomp/tests/cif_original_oracle.py"
    spec = importlib.util.spec_from_file_location("a37_pe_image", pe_source)
    if spec is None or spec.loader is None:
        raise RuntimeError("could not load the pinned PE image parser")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    pe = module.PEImage.parse_and_map(exe_path)
    actual = sha256(pe.data)
    if actual != EXPECTED_EXE_SHA256:
        raise RuntimeError(f"GAME.EXE SHA-256 mismatch: {actual}")
    return pe


def load_unicorn(pe):
    try:
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_PROT_ALL, UC_HOOK_CODE
        from unicorn.x86_const import (
            UC_X86_REG_EAX, UC_X86_REG_EBX, UC_X86_REG_ECX, UC_X86_REG_EDI,
            UC_X86_REG_EDX, UC_X86_REG_EBP, UC_X86_REG_ESI, UC_X86_REG_ESP,
            UC_X86_REG_EIP, UC_X86_REG_EFLAGS, UC_X86_REG_ES,
        )
    except ImportError as error:
        raise RuntimeError("use the pinned work/tools/oracle-python environment with Unicorn") from error

    uc = Uc(UC_ARCH_X86, UC_MODE_32)
    image_start = pe.image_base & ~(PAGE - 1)
    image_end = (pe.image_base + pe.size_of_image + PAGE - 1) & ~(PAGE - 1)
    uc.mem_map(image_start, image_end - image_start, UC_PROT_ALL)
    uc.mem_write(pe.image_base, pe.image)
    uc.mem_map(STACK, STACK_SIZE, UC_PROT_ALL)
    uc.mem_map(INPUT, 0x10000, UC_PROT_ALL)
    uc.mem_map(DATA, 0x30000, UC_PROT_ALL)
    uc.reg_write(UC_X86_REG_ES, 0)

    hook_state = {"allocations": 0, "sizes": []}

    def external_boundary_hook(uc_ref, address, _size, _user_data):
        if address != ALLOCATOR:
            return
        esp = uc_ref.reg_read(UC_X86_REG_ESP)
        return_address = struct.unpack("<I", uc_ref.mem_read(esp, 4))[0]
        requested = struct.unpack("<I", uc_ref.mem_read(esp + 4, 4))[0]
        if requested != OBJECT_BYTES:
            raise RuntimeError(f"original requested {requested:#x}, expected 0xABA")
        uc_ref.mem_write(OUT, b"\xCD" * (requested + 32))
        uc_ref.reg_write(UC_X86_REG_EAX, OUT)
        uc_ref.reg_write(UC_X86_REG_ESP, esp + 4)
        uc_ref.reg_write(UC_X86_REG_EIP, return_address)
        hook_state["allocations"] += 1
        hook_state["sizes"].append(requested)

    uc.hook_add(UC_HOOK_CODE, external_boundary_hook)
    initial_values = {
        "eax": 0x11111111,
        "ebx": 0x22222222,
        "ecx": 0,
        "edx": 0x33333333,
        "esi": 0x44444444,
        "edi": 0x55555555,
        "ebp": 0x66666666,
    }
    return uc, hook_state, initial_values, {
        "eax": UC_X86_REG_EAX,
        "ebx": UC_X86_REG_EBX,
        "ecx": UC_X86_REG_ECX,
        "edx": UC_X86_REG_EDX,
        "esi": UC_X86_REG_ESI,
        "edi": UC_X86_REG_EDI,
        "ebp": UC_X86_REG_EBP,
        "esp": UC_X86_REG_ESP,
        "eip": UC_X86_REG_EIP,
        "eflags": UC_X86_REG_EFLAGS,
    }


def invoke_original(uc, registers, initial, body: bytes, payload_offset_before: int):
    # The direct constructor receives a source cursor to the raw body, the
    # output-result slot, and a separate ECX owner object.
    body_va = INPUT + 0x32
    prefix_guard = b"\xA5" * 16
    suffix_guard = b"\xD7" * 16
    owner_before = b"\x5A" * 0x100
    owner_before = bytearray(owner_before)
    owner_before[0x1C:0x24] = b"\xA6" * 8
    owner_before = bytes(owner_before)
    result_slot_before = b"\x69" * 0x100
    stack_guard = b"\x3C" * 16

    uc.mem_write(INPUT, b"\x7C" * 0x10000)
    uc.mem_write(body_va - 16, prefix_guard)
    uc.mem_write(body_va, body)
    uc.mem_write(body_va + len(body), suffix_guard)
    uc.mem_write(OWNER - 16, prefix_guard)
    uc.mem_write(OWNER, owner_before)
    uc.mem_write(OWNER + 0x100, suffix_guard)
    uc.mem_write(RESULT_SLOT - 16, prefix_guard)
    uc.mem_write(RESULT_SLOT, result_slot_before)
    uc.mem_write(RESULT_SLOT + 0x180, suffix_guard)
    uc.mem_write(CURSOR, struct.pack("<I", body_va))
    uc.mem_write(PAYLOAD_OFFSET, struct.pack("<I", payload_offset_before & 0xFFFFFFFF))
    uc.mem_write(OUT - 16, prefix_guard)

    # Keep a distant stack canary beyond ordinary function-local stack use.
    uc.mem_write(STACK + 0x3FF0, stack_guard)
    uc.mem_write(STACK + 0x6000, suffix_guard)
    uc.mem_write(STACK + 0x4000, bytes(0x1000))
    original_esp = STACK + 0x4800
    args = (RESULT_SLOT, CURSOR, PAYLOAD_OFFSET)
    uc.mem_write(original_esp, struct.pack("<I3I", SENTINEL, *args))
    uc.reg_write(registers["eax"], initial["eax"])
    uc.reg_write(registers["ebx"], initial["ebx"])
    uc.reg_write(registers["ecx"], OWNER)
    uc.reg_write(registers["edx"], initial["edx"])
    uc.reg_write(registers["esi"], initial["esi"])
    uc.reg_write(registers["edi"], initial["edi"])
    uc.reg_write(registers["ebp"], initial["ebp"])
    uc.reg_write(registers["esp"], original_esp)
    uc.reg_write(registers["eip"], 0x4895CC)
    uc.reg_write(registers["eflags"], 0x202)
    uc.emu_start(0x4895CC, SENTINEL, count=100000, timeout=0)

    got_eip = uc.reg_read(registers["eip"])
    got_esp = uc.reg_read(registers["esp"])
    if got_eip != SENTINEL:
        raise RuntimeError(f"constructor did not return: EIP={got_eip:#x}")
    if got_esp != original_esp + 16:
        raise RuntimeError(f"ret cleanup {got_esp-original_esp}, expected 16 bytes")
    for key in ("ebx", "esi", "edi", "ebp"):
        if uc.reg_read(registers[key]) != initial[key]:
            raise RuntimeError(f"callee-saved {key} was not preserved")
    if bytes(uc.mem_read(original_esp, 16)) != struct.pack("<I3I", SENTINEL, *args):
        raise RuntimeError("caller stack arguments or return sentinel changed")
    if bytes(uc.mem_read(STACK + 0x3FF0, 16)) != stack_guard:
        raise RuntimeError("constructor crossed the lower stack guard")
    if bytes(uc.mem_read(STACK + 0x6000, 16)) != suffix_guard:
        raise RuntimeError("constructor crossed the upper stack guard")

    output = bytes(uc.mem_read(OUT, OBJECT_BYTES))
    result_slot = bytes(uc.mem_read(RESULT_SLOT, 0x100))
    owner = bytes(uc.mem_read(OWNER, 0x100))
    expected_pointer = struct.pack("<I", OUT)
    if result_slot[:4] != expected_pointer:
        raise RuntimeError("*param_1 did not receive the output allocation pointer")
    if result_slot[4:] != result_slot_before[4:]:
        raise RuntimeError("constructor changed result-slot bytes beyond *param_1")
    if owner[0x1C:0x20] != expected_pointer or owner[0x20:0x24] != expected_pointer:
        raise RuntimeError("ECX owner +0x1c/+0x20 do not alias the output allocation")
    if owner[:0x1C] != owner_before[:0x1C] or owner[0x24:] != owner_before[0x24:]:
        raise RuntimeError("constructor changed bytes outside the two ECX owner links")
    if bytes(uc.mem_read(OWNER - 16, 16)) != prefix_guard:
        raise RuntimeError("owner-prefix guard changed")
    if bytes(uc.mem_read(OWNER + 0x100, 16)) != suffix_guard:
        raise RuntimeError("owner-suffix guard changed")
    if bytes(uc.mem_read(RESULT_SLOT - 16, 16)) != prefix_guard:
        raise RuntimeError("result-slot prefix guard changed")
    if bytes(uc.mem_read(RESULT_SLOT + 0x180, 16)) != suffix_guard:
        raise RuntimeError("result-slot suffix guard changed")
    if bytes(uc.mem_read(OUT - 16, 16)) != prefix_guard:
        raise RuntimeError("output allocation prefix guard changed")
    if bytes(uc.mem_read(OUT + OBJECT_BYTES, 16)) != b"\xCD" * 16:
        raise RuntimeError("output allocation suffix guard changed")

    cursor = struct.unpack("<I", uc.mem_read(CURSOR, 4))[0]
    offset_after = struct.unpack("<I", uc.mem_read(PAYLOAD_OFFSET, 4))[0]
    if cursor != body_va + BODY_BYTES:
        raise RuntimeError(f"body cursor advanced {cursor-body_va}, expected 69")
    if offset_after != ((payload_offset_before + BODY_BYTES) & 0xFFFFFFFF):
        raise RuntimeError("payload offset did not advance by 69 as a DWORD")
    if bytes(uc.mem_read(body_va - 16, 16)) != prefix_guard:
        raise RuntimeError("source-body prefix guard changed")
    if bytes(uc.mem_read(body_va, len(body))) != body:
        raise RuntimeError("constructor modified the fixed body or dependency tail")
    if bytes(uc.mem_read(body_va + len(body), 16)) != suffix_guard:
        raise RuntimeError("source-body suffix guard changed")

    return {
        "object": output,
        "result_slot": result_slot,
        "owner_links": owner[0x1C:0x24],
        "body_cursor_advance": cursor - body_va,
        "payload_offset_before": payload_offset_before & 0xFFFFFFFF,
        "payload_offset_after": offset_after,
        "stack_cleanup_bytes": got_esp - original_esp,
        "callee_saved_registers_preserved": 4,
        "owner_external_writes": ["result slot *param_1", "ECX owner +0x1c", "ECX owner +0x20"],
    }


def create_body(name: bytes, option_21: int, option_23: int,
                rectangle: tuple[int, int, int, int],
                geometry: tuple[int, int, int, int], tail_count: int = 0) -> bytes:
    if len(name) > 32:
        raise ValueError("synthetic name exceeds the fixed 33-byte field")
    body = bytearray(BODY_BYTES + tail_count * DEPENDENCY_BYTES)
    body[:len(name)] = name
    body[len(name)] = 0
    struct.pack_into("<HH", body, 0x21, option_21 & 0xFFFF, option_23 & 0xFFFF)
    struct.pack_into("<4I", body, 0x25, *(value & 0xFFFFFFFF for value in rectangle))
    struct.pack_into("<4I", body, 0x35, *(value & 0xFFFFFFFF for value in geometry))
    for index in range(BODY_BYTES, len(body)):
        body[index] = (index * 37 + 11) & 0xFF
    return bytes(body)


def first_difference(left: bytes, right: bytes):
    for index, (a, b) in enumerate(zip(left, right)):
        if a != b:
            return index
    if len(left) != len(right):
        return min(len(left), len(right))
    return None


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--corpus", type=Path, default=DEFAULT_CORPUS)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--native-library", type=Path, default=DEFAULT_NATIVE)
    parser.add_argument("--result", type=Path, default=DEFAULT_RESULT)
    args = parser.parse_args()

    start_time = time.monotonic()
    corpus_bytes = args.corpus.read_bytes()
    corpus_sha = sha256(corpus_bytes)
    if corpus_sha != EXPECTED_CORPUS_SHA256:
        raise RuntimeError(f"A-37.1 census hash mismatch: {corpus_sha}")
    manifest_bytes = args.manifest.read_bytes()
    manifest_sha = sha256(manifest_bytes)
    if manifest_sha != EXPECTED_MANIFEST_SHA256:
        raise RuntimeError(f"resource manifest hash mismatch: {manifest_sha}")
    corpus = json.loads(corpus_bytes)
    manifest = json.loads(manifest_bytes)
    if corpus["exe_sha256"] != EXPECTED_EXE_SHA256:
        raise RuntimeError("census executable hash does not match immutable GAME.EXE")
    if corpus["manifest_sha256"] != manifest_sha:
        raise RuntimeError("census and resource manifest hashes disagree")
    if corpus["archive_sha256"] != EXPECTED_ARCHIVE_SHA256 or \
            manifest["archive_sha256"] != EXPECTED_ARCHIVE_SHA256:
        raise RuntimeError("census/manifest source archive hash mismatch")
    if corpus["raw_0x37_records"] != 4308 or len(corpus["records"]) != 4308:
        raise RuntimeError("pinned census does not contain exactly 4,308 raw-0x37 records")

    resources_by_index = {int(item["index"]): item for item in manifest["resources"]}
    resource_bytes: dict[int, bytes] = {}
    resource_hashes_verified = 0
    for resource in manifest["resources"]:
        index = int(resource["index"])
        source_path = ROOT / "work/analysis/hiff-resources" / f"{index:04d}.bin"
        data = source_path.read_bytes()
        actual_hash = sha256(data)
        if len(data) != int(resource["size"]) or actual_hash != resource["sha256"]:
            raise RuntimeError(f"source resource {index} differs from the pinned manifest")
        resource_bytes[index] = data
        resource_hashes_verified += 1
    if resource_hashes_verified != 2267:
        raise RuntimeError(f"verified {resource_hashes_verified} resources, expected 2,267")
    if len(corpus["resource_hashes"]) != resource_hashes_verified:
        raise RuntimeError("census resource-hash coverage differs from the manifest")
    for item in corpus["resource_hashes"]:
        resource = resources_by_index[int(item["resource_index"])]
        if item["sha256"] != resource["sha256"] or int(item["size"]) != int(resource["size"]):
            raise RuntimeError(f"census/resource manifest disagreement: {item['resource_index']}")

    pe = map_original(args.exe)
    debug_flag_rva = 0x63A4CD - pe.image_base
    debug_flag_initial = pe.image[debug_flag_rva]
    code_windows = [
        {"label": "loader payload cursor setup", "file_offset": 0xB3AB,
         "size": 19, "sha256": EXPECTED_CURSOR_WINDOW_SHA256},
        {"label": "raw-0x37 dispatch/normalization", "file_offset": 0xC404,
         "size": 126, "sha256": EXPECTED_RAW37_DISPATCH_SHA256},
        {"label": "FUN_0048945b defaults helper", "file_offset": 0x8945B,
         "size": 369, "sha256": EXPECTED_DEFAULTS_SHA256},
        {"label": "FUN_004895cc constructor", "file_offset": 0x895CC,
         "size": 342, "sha256": EXPECTED_CONSTRUCTOR_SHA256},
    ]
    for window in code_windows:
        actual = sha256(pe.data[window["file_offset"]:
                               window["file_offset"] + window["size"]])
        if actual != window["sha256"]:
            raise RuntimeError(f"original code window hash mismatch: {window['label']}: {actual}")

    lib = load_native(args.native_library)
    uc, hook_state, initial_registers, regs = load_unicorn(pe)
    prefix_hash = hashlib.sha256()
    raw_body_hash = hashlib.sha256()
    native_image_hash = hashlib.sha256()
    original_image_hash = hashlib.sha256()
    tail_histogram: Counter[int] = Counter()
    resource_ids: set[int] = set()
    total_image_bytes = 0
    owner_slot_checks = 0
    result_slot_checks = 0
    first_actual = None

    for ordinal, row in enumerate(corpus["records"]):
        resource_index = int(row["resource_index"])
        resource_ids.add(resource_index)
        resource = resource_bytes[resource_index]
        body_offset = int(row["raw_body_offset"])
        body_length = int(row["raw_body_length"])
        payload_offset = int(row["act_payload_offset"])
        payload_length = int(row["act_payload_length"])
        if body_offset != payload_offset + 50 or payload_length != body_length + 50:
            raise RuntimeError(f"ACT source offset mismatch at record {ordinal}")
        if body_length < BODY_BYTES or body_offset + body_length > len(resource):
            raise RuntimeError(f"raw body bounds mismatch at record {ordinal}")
        if int(row["dependency_tail_length"]) != body_length - BODY_BYTES:
            raise RuntimeError(f"tail byte count mismatch at record {ordinal}")
        tail_length = body_length - BODY_BYTES
        if tail_length % DEPENDENCY_BYTES != 0 or \
                int(row["dependency_tail_records"]) != tail_length // DEPENDENCY_BYTES:
            raise RuntimeError(f"tail record count mismatch at record {ordinal}")
        body = resource[body_offset:body_offset + body_length]
        prefix = body[:BODY_BYTES]
        if sha256(prefix) != row["prefix_69_sha256"]:
            raise RuntimeError(f"69-byte prefix hash mismatch at record {ordinal}")
        prefix_hash.update(prefix)
        raw_body_hash.update(body)
        tail_histogram[tail_length // DEPENDENCY_BYTES] += 1

        source = (c.c_uint8 * len(body)).from_buffer_copy(body)
        decoded = Decoded()
        status = lib.action_family_37_decode(source, len(body), c.byref(decoded))
        if status != 0:
            raise RuntimeError(f"native decoder rejected corpus record {ordinal}: status={status}")
        nul = prefix.find(b"\0", 0, 33)
        if nul < 0:
            raise RuntimeError(f"corpus record {ordinal} has no name terminator in 33 bytes")
        expected_name = prefix[:nul + 1] + bytes(32 - nul)
        if bytes(decoded.name) != expected_name:
            raise RuntimeError(f"native name decode mismatch at record {ordinal}")
        if (decoded.option_21, decoded.option_23) != struct.unpack_from("<HH", prefix, 0x21):
            raise RuntimeError(f"native option decode mismatch at record {ordinal}")
        rect = struct.unpack_from("<4i", prefix, 0x25)
        geometry = struct.unpack_from("<4i", prefix, 0x35)
        if tuple(decoded.fixed_rect) != rect or tuple(decoded.initial_geometry) != geometry:
            raise RuntimeError(f"native signed-word decode mismatch at record {ordinal}")
        if pointer_value(decoded.dependency_records) != c.addressof(source) + BODY_BYTES:
            raise RuntimeError(f"native dependency view pointer mismatch at record {ordinal}")
        if (decoded.dependency_count != tail_length // DEPENDENCY_BYTES or
                decoded.dependency_bytes != tail_length or
                decoded.available_body_bytes != body_length or
                decoded.body_bytes != BODY_BYTES):
            raise RuntimeError(f"native body/tail lengths mismatch at record {ordinal}")

        handle = 0x37000001 + ordinal
        native = Constructed()
        status = lib.action_family_37_construct(
            source, len(body), 0x32, handle, c.byref(native)
        )
        if status != 0:
            raise RuntimeError(f"native constructor rejected corpus record {ordinal}: status={status}")
        if pointer_value(native.dependency_records) != c.addressof(source) + BODY_BYTES:
            raise RuntimeError(f"native constructor dependency pointer mismatch at record {ordinal}")
        if (native.dependency_count != tail_length // DEPENDENCY_BYTES or
                native.dependency_bytes != tail_length or
                native.available_body_bytes != body_length or
                native.body_bytes_consumed != BODY_BYTES or
                native.payload_offset_before != 0x32 or
                native.payload_offset_after != 0x77):
            raise RuntimeError(f"native constructor cursor/tail model mismatch at record {ordinal}")
        links = native.owner_links
        if (links.output_handle != handle or links.result_slot_handle != handle or
                links.owner_slot_1c_handle != handle or
                links.owner_slot_20_handle != handle or
                links.output_allocation_bytes != OBJECT_BYTES):
            raise RuntimeError(f"native external-owner link metadata mismatch at record {ordinal}")

        original = invoke_original(uc, regs, initial_registers, body, 0x32)
        native_image = bytes(native.object_bytes)
        if native_image != original["object"]:
            diff = first_difference(native_image, original["object"])
            raise RuntimeError(
                f"native/original full image mismatch record={ordinal} resource={resource_index} "
                f"action={row['action_index']} offset={diff:#x} "
                f"native={native_image[diff]:02x} original={original['object'][diff]:02x}"
            )
        native_image_hash.update(native_image)
        original_image_hash.update(original["object"])
        total_image_bytes += len(native_image)
        owner_slot_checks += 2
        result_slot_checks += 1
        if hook_state["allocations"] != ordinal + 1:
            raise RuntimeError("allocator-hook count does not match original call count")
        if first_actual is None:
            first_actual = (body, native_image, original["object"])

    synthetic_cases = [
        {
            "label": "empty-name-no-tail",
            "body": create_body(b"", 0, 0xFFFF, (0, -1, 0, 1),
                                (0x12345678, -1, -0x80000000, 0), 0),
            "payload_offset": 0x32,
        },
        {
            "label": "32-byte-name-extreme-rect-eight-dependencies-wrap-offset",
            "body": create_body(bytes(range(1, 33)), 0x80FF, 0xFE01,
                                (-0x80000000, 0x7FFFFFFF, 0x7FFFFFFF, -0x80000000),
                                (-0x80000000, -1, 0x12345678, 0x7FFFFFFF), 8),
            "payload_offset": 0xFFFFFFFB,
        },
    ]
    synthetic_results = []
    for synthetic_index, fixture in enumerate(synthetic_cases):
        body = fixture["body"]
        source = (c.c_uint8 * len(body)).from_buffer_copy(body)
        state = Constructed()
        handle = 0x37F00001 + synthetic_index
        status = lib.action_family_37_construct(
            source, len(body), fixture["payload_offset"], handle, c.byref(state)
        )
        if status != 0:
            raise RuntimeError(f"native constructor rejected synthetic case {fixture['label']}: {status}")
        original = invoke_original(uc, regs, initial_registers, body,
                                   fixture["payload_offset"])
        native_image = bytes(state.object_bytes)
        if native_image != original["object"]:
            diff = first_difference(native_image, original["object"])
            raise RuntimeError(
                f"synthetic native/original mismatch {fixture['label']} offset={diff:#x}"
            )
        if state.payload_offset_after != original["payload_offset_after"]:
            raise RuntimeError(f"synthetic DWORD offset mismatch: {fixture['label']}")
        synthetic_results.append({
            "label": fixture["label"],
            "raw_body_bytes": len(body),
            "dependency_count": (len(body) - BODY_BYTES) // DEPENDENCY_BYTES,
            "body_cursor_advance": original["body_cursor_advance"],
            "payload_offset_before": original["payload_offset_before"],
            "payload_offset_after": original["payload_offset_after"],
            "full_object_bytes_compared": OBJECT_BYTES,
            "mismatches": 0,
            "name_length": body.find(b"\0", 0, 33),
            "allocation_bytes": OBJECT_BYTES,
        })
        if fixture["label"].startswith("32-byte"):
            first_actual = (body, native_image, original["object"])

    if hook_state["allocations"] != 4308 + len(synthetic_cases):
        raise RuntimeError("original allocator hook count does not match corpus + synthetic calls")
    if set(hook_state["sizes"]) != {OBJECT_BYTES}:
        raise RuntimeError("original allocator hook observed an unexpected allocation size")
    if total_image_bytes != 4308 * OBJECT_BYTES:
        raise RuntimeError("full corpus image comparison byte count is wrong")
    if len(resource_ids) != 461:
        raise RuntimeError(f"0x37 records referenced {len(resource_ids)} resources, expected 461")

    # Prove that the full-image equality comparator notices representative
    # wrong-copy-offset, wrong-default, and wrong-width mutations.
    if first_actual is None:
        raise RuntimeError("no original/native image available for mutation checks")
    selected_body, selected_native, selected_original = first_actual
    mutations = {}
    changed = bytearray(selected_native)
    changed[0] ^= 1
    mutations["wrong_name_destination"] = {
        "first_mismatch_offset": first_difference(bytes(changed), selected_original),
        "expected_offset": 0,
    }
    changed = bytearray(selected_native)
    changed[0x29] ^= 1
    mutations["wrong_default_value"] = {
        "first_mismatch_offset": first_difference(bytes(changed), selected_original),
        "expected_offset": 0x29,
    }
    changed = bytearray(selected_native)
    changed[0x6FA] ^= 1
    mutations["wrong_width_store"] = {
        "first_mismatch_offset": first_difference(bytes(changed), selected_original),
        "expected_offset": 0x6FA,
    }
    for label, item in mutations.items():
        if item["first_mismatch_offset"] != item["expected_offset"]:
            raise RuntimeError(f"full-image comparator missed {label} mutation")

    native_hash = sha256(args.native_library.read_bytes())
    result = {
        "slice": "A-37.2",
        "scope": "direct original 0x4895cc constructor plus native fixed-prefix decoder/state model; no full loader/runtime/provider/render",
        "inputs": {
            "game_exe_sha256": EXPECTED_EXE_SHA256,
            "census_sha256": corpus_sha,
            "resource_manifest_sha256": manifest_sha,
            "source_archive_sha256": EXPECTED_ARCHIVE_SHA256,
            "source_resources_verified": resource_hashes_verified,
            "resources_referenced_by_0x37_corpus": len(resource_ids),
            "corpus_raw_0x37_records": len(corpus["records"]),
            "raw_prefixes_sha256_concatenated": prefix_hash.hexdigest(),
            "full_raw_bodies_sha256_concatenated": raw_body_hash.hexdigest(),
            "code_windows": code_windows,
        },
        "native": {
            "library_sha256": native_hash,
            "object_image_sha256_concatenated": native_image_hash.hexdigest(),
            "module_source_sha256": sha256((ROOT / "outputs/blackmoor-decomp/src/action_family_37.c").read_bytes()),
            "module_header_sha256": sha256((ROOT / "outputs/blackmoor-decomp/src/action_family_37.h").read_bytes()),
        },
        "actual_corpus_comparison": {
            "records": 4308,
            "constructors_executed": 4308,
            "decoders_executed": 4308,
            "allocation_hook_calls": 4308,
            "allocation_size_bytes": OBJECT_BYTES,
            "complete_object_bytes_compared": total_image_bytes,
            "object_mismatches": 0,
            "native_equals_original_object_hash": native_image_hash.hexdigest() == original_image_hash.hexdigest(),
            "original_image_sha256_concatenated": original_image_hash.hexdigest(),
            "cursor_advance_bytes_each": BODY_BYTES,
            "payload_offset_0x32_to_0x77_each": True,
            "result_slot_pointer_checks": result_slot_checks,
            "external_owner_pointer_checks": owner_slot_checks,
            "dependency_tail_untouched_records": 4308,
            "input_body_untouched_records": 4308,
            "tail_record_count_histogram": {str(key): tail_histogram[key] for key in sorted(tail_histogram)},
            "callee_saved_register_checks": 4308 * 4,
            "stack_cleanup_histogram": {"16": 4308},
            "guard_checks": "input prefix/suffix, allocation prefix/suffix, result-slot prefix/suffix, external owner prefix/suffix, stack canaries",
        },
        "synthetic_original_fixtures": synthetic_results,
        "comparison_mutation_sensitivity": mutations,
        "original_process_state": {
            "DAT_0063a4cd_initial_byte": debug_flag_initial,
            "optional_constructor_logging_branch_taken": debug_flag_initial != 0,
        },
        "oracle_hooks": {
            "0x51dc43 allocation boundary": hook_state["allocations"],
            "other hooks": 0,
            "original constructor/default logic replaced": False,
        },
        "elapsed_seconds": round(time.monotonic() - start_time, 3),
        "unverified": [
            "allocator failure/fatal path",
            "optional constructor logging branch when DAT_0063a4cd is nonzero",
            "outer FUN_0040b34a full action loop and generic dependency builder",
            "runtime 0x36 phase, dependency gates, provider/cache/audio/render callbacks",
            "raw 0x38 animated-overlay loader and runtime",
            "whole-file executable matching and compiler provenance",
        ],
    }
    args.result.parent.mkdir(parents=True, exist_ok=True)
    args.result.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({
        "result": str(args.result),
        "actual_records": 4308,
        "synthetic_records": len(synthetic_results),
        "object_bytes_compared": total_image_bytes,
        "mismatches": 0,
        "allocator_hooks": hook_state["allocations"],
        "native_sha256": native_hash,
        "elapsed_seconds": result["elapsed_seconds"],
    }, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:
        print(f"A-37.2 original oracle failed: {error}", file=sys.stderr)
        raise
