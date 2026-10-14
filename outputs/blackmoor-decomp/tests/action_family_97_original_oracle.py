#!/usr/bin/env python3
"""A-97.1: execute immutable raw-0x97 loader, rand and AUTOTEXT in x86.

Only malloc and three Windows TLS/error APIs are hooked. No selection,
field copy, original helper, AUTOTEXT lookup or branch decision is replaced.
The full loader entry runs until 0x410a68, immediately before dependency
construction. This is constructor/boundary evidence, not gameplay evidence.
"""
from __future__ import annotations

import argparse
from collections import Counter
import ctypes as c
import hashlib
import json
from pathlib import Path
import struct
import time

from autotext_original_oracle import (
    OriginalAutoText, OracleError, _read_cvtx_payload, parse_entries,
    TABLE_INIT_VA, INSERT_VA, KEY_VA, VALUE_VA, MAX_VALUE_BUFFER,
    ALLOCATOR_VA, ALLOC_LIMIT, STACK_TOP, RETURN_VA,
)
import test_action_family_97 as native

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
EXE_HASH = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
MANIFEST_HASH = "440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c"
ARCHIVE_HASH = "1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161"
CORPUS_HASH = "feaa724043a52d82ec7886d4a2f239577a0392fec9cefb772ac9be8523964ab5"
CODE_WINDOWS = [
    (0x40B34A, 444, "814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc"),
    (0x40F532, 2021, "515aa68a3f54c8fd2897d4687fbcada5287c5fd458917f9f0c6f78b5c797d383"),
    (0x410A68, 66, "b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d"),
    (0x410CA4, 741, "f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620"),
    (0x410F99, 230, "66213ccc0b5222fd241ed267229688698a430b4ba06d799544623c6f4ec73aa1"),
    (0x50CD50, 34, "0da22e82752744ae9cf05712c17046a865cf942af4473a565c34145d52ef5477"),
    (0x510DD3, 103, "20cf859c5de096b4df74fcb2a62bf3fe20adc24e692782e53d071c8e8fea0893"),
    (0x423097, 840, "df12edcf92c53747be145ded658e02da9a1fd0bf1ed411017f98d465cbd99f8e"),
]
INPUT_PAGE = 0x40000000
ACT = INPUT_PAGE + 0x100
THREAD = INPUT_PAGE + 0x80000
TABLE = 0x619A6B
SLOT = 0x5BB5B3
SLOT_TYPE = SLOT + 0x30
SLOT_SUBTYPE = SLOT + 0x31
SLOT_PAYLOAD = SLOT + 0x32
SLOT_INDEX = 0x5C39E3
EXIT = 0x410A68


def sha(data):
    return hashlib.sha256(data).hexdigest()


def address(pointer):
    return c.cast(pointer, c.c_void_p).value


class Original97(OriginalAutoText):
    def __init__(self, exe):
        super().__init__(exe)
        from unicorn import UC_HOOK_CODE, UC_PROT_ALL
        self.machine.mem_map(INPUT_PAGE, 0x100000, UC_PROT_ALL)
        self.machine.mem_write(THREAD, bytes(0x74))
        self.allocations = []
        self.action_arena = None
        self.os_calls = Counter()
        self.last_error = 0
        # Real CRT _getptd runs its existing-thread path. Only its Windows
        # imports return synthetic OS state; rand remains original code.
        self.stubs = {
            RETURN_VA + 0x100: (0, "GetLastError"),
            RETURN_VA + 0x110: (4, "TlsGetValue"),
            RETURN_VA + 0x120: (4, "SetLastError"),
        }
        for iat, stub in ((0x52A2A4, RETURN_VA + 0x100),
                          (0x52A0DC, RETURN_VA + 0x110),
                          (0x52A1D0, RETURN_VA + 0x120)):
            self.machine.mem_write(iat, struct.pack("<I", stub))
            self.machine.hook_add(UC_HOOK_CODE, self._on_os, begin=stub, end=stub)
        self.machine.mem_write(0x63A4CD, b"\0\0")
        self.machine.mem_write(0x5681F0, struct.pack("<I", 7))

    def _on_os(self, uc, address_, _size, _user):
        pop, name = self.stubs[address_]
        esp = uc.reg_read(self._reg["ESP"])
        if name == "TlsGetValue":
            index = struct.unpack("<I", uc.mem_read(esp + 4, 4))[0]
            if index != 7:
                raise OracleError("unexpected CRT TLS index")
            result = THREAD
        elif name == "GetLastError":
            result = self.last_error
        else:
            self.last_error = struct.unpack("<I", uc.mem_read(esp + 4, 4))[0]
            result = 0
        self.os_calls[name] += 1
        ret = struct.unpack("<I", uc.mem_read(esp, 4))[0]
        uc.reg_write(self._reg["EAX"], result)
        uc.reg_write(self._reg["ESP"], esp + 4 + pop)
        uc.reg_write(self._reg["EIP"], ret)

    def _on_code(self, uc, address_, _size, _user):
        if address_ != ALLOCATOR_VA:
            return
        esp = uc.reg_read(self._reg["ESP"])
        requested = struct.unpack("<I", uc.mem_read(esp + 4, 4))[0]
        start = (self._allocator_cursor + 19) & ~3
        if not 0 < requested <= 32767 or start + requested + 16 > ALLOC_LIMIT:
            raise OracleError(f"bounded malloc rejected {requested} bytes")
        self.machine.mem_write(start - 16, b"\xA7" * 16)
        self.machine.mem_write(start, b"\xCD" * requested)
        self.machine.mem_write(start + requested, b"\xB8" * 16)
        self._allocator_cursor = start + requested + 16
        self.allocations.append((start, requested))
        self._allocator_calls += 1
        uc.reg_write(self._reg["EAX"], start)
        self._return_from_intercepted_call(uc)

    def install_table(self, entries, extra):
        self._call(TABLE_INIT_VA, (), TABLE, "AUTOTEXT init")
        rows = [(e["key_field"], e["raw_value"]) for e in entries]
        rows += [(k.ljust(33, b"\0"), v) for k, v in extra.items()]
        for key, value in rows:
            self.machine.mem_write(KEY_VA, key)
            self.machine.mem_write(VALUE_VA, bytes(MAX_VALUE_BUFFER))
            self.machine.mem_write(VALUE_VA, value)
            self._call(INSERT_VA, (KEY_VA, VALUE_VA), TABLE, "AUTOTEXT insert")
        self.action_arena = self._allocator_cursor
        return len(rows)

    def run(self, act, seed, payload_offset=50):
        if self.action_arena is None or len(act) >= 0x70000:
            raise OracleError("uninitialized table or oversized fixture")
        self._allocator_cursor = self.action_arena
        self.allocations = []
        self.machine.mem_write(ACT - 16, b"\xD9" * 16)
        self.machine.mem_write(ACT, act)
        self.machine.mem_write(ACT + len(act), b"\xEA" * 16)
        self.machine.mem_write(SLOT - 16, b"\xF1" * 16)
        self.machine.mem_write(SLOT, b"\x5A" * 0x8D)
        self.machine.mem_write(SLOT + 0x8D, b"\xE2" * 16)
        self.machine.mem_write(SLOT_INDEX, b"\0\0")
        self.machine.mem_write(THREAD + 0x14, struct.pack("<I", seed))
        self.machine.mem_write(STACK_TOP - 0x900, b"\xCC" * 0x900)
        self.machine.mem_write(STACK_TOP - 0x910, b"\x71" * 16)
        self.machine.mem_write(STACK_TOP + 12, b"\x82" * 16)
        args = struct.pack("<III", RETURN_VA, ACT, len(act))
        self.machine.mem_write(STACK_TOP, args)
        for name in ("EAX", "EBX", "ECX", "EDX", "ESI", "EDI", "EBP"):
            self.machine.reg_write(self._reg[name], 0)
        self.machine.reg_write(self._reg["ESP"], STACK_TOP)
        self.machine.reg_write(self._reg["EFLAGS"], 0x202)
        if payload_offset == 50:
            start = 0x40B34A
        else:
            # A second bounded entry tests DWORD cursor-offset wrap using the
            # same original branch with its documented caller locals.
            start = 0x40F532
            frame = STACK_TOP - 4
            self.machine.reg_write(self._reg["EBP"], frame)
            self.machine.reg_write(self._reg["ESP"], frame - 0x244)
            self.machine.mem_write(frame - 0x20, struct.pack("<I", ACT + 50))
            self.machine.mem_write(frame - 0xCC, struct.pack("<I", payload_offset))
            self.machine.mem_write(SLOT_TYPE, b"\x97")
            self.machine.mem_write(SLOT_SUBTYPE, act[49:50])
        self.machine.emu_start(start, EXIT, count=5_000_000, timeout=20_000_000)
        if self.machine.reg_read(self._reg["EIP"]) != EXIT:
            raise OracleError("loader failed to reach dependency handoff")
        if len(self.allocations) != 1:
            raise OracleError(f"unexpected loader allocations {len(self.allocations)}")
        frame = self.machine.reg_read(self._reg["EBP"])
        pointer, = struct.unpack("<I", self.machine.mem_read(SLOT_PAYLOAD, 4))
        if pointer != self.allocations[0][0]:
            raise OracleError("slot payload differs from original malloc result")
        length = self.allocations[0][1]
        for a, expected in ((pointer - 16, b"\xA7" * 16),
                            (pointer + length, b"\xB8" * 16),
                            (ACT - 16, b"\xD9" * 16),
                            (ACT + len(act), b"\xEA" * 16),
                            (SLOT - 16, b"\xF1" * 16),
                            (SLOT + 0x8D, b"\xE2" * 16),
                            (STACK_TOP - 0x910, b"\x71" * 16),
                            (STACK_TOP + 12, b"\x82" * 16)):
            if bytes(self.machine.mem_read(a, 16)) != expected:
                raise OracleError(f"original guard changed at {a:#x}")
        if bytes(self.machine.mem_read(STACK_TOP, 12)) != args:
            raise OracleError("original caller arguments changed")
        if self.machine.reg_read(self._reg["ESP"]) != frame - 0x244:
            raise OracleError("loader call stack not balanced at handoff")
        slot = bytes(self.machine.mem_read(SLOT, 0x8D))
        if slot[0x36:] != b"\x5A" * (0x8D - 0x36):
            raise OracleError("loader changed runtime fields before handoff")
        return dict(
            payload=bytes(self.machine.mem_read(pointer, length)),
            act_after=bytes(self.machine.mem_read(ACT, len(act))),
            selected=struct.unpack("<h", self.machine.mem_read(frame - 0x10, 2))[0],
            advance=struct.unpack("<I", self.machine.mem_read(frame - 0x20, 4))[0] - ACT - 50,
            offset=struct.unpack("<I", self.machine.mem_read(frame - 0xCC, 4))[0],
            seed=struct.unpack("<I", self.machine.mem_read(THREAD + 0x14, 4))[0],
            runtime_type=slot[0x30], subtype=slot[0x31],
        )


def verify_decode(lib, raw, row):
    src, decoded = native.buffer(raw), native.Decoded()
    if lib.action_family_97_decode(src, len(raw), c.byref(decoded)) != 0:
        raise OracleError("native corpus decode rejected")
    count, = struct.unpack_from("<h", raw)
    final = 2 + 33 * (count - 1)
    words = struct.unpack_from("<HIHHBH", raw, final + 33)
    got = (decoded.word_21, decoded.word_23, decoded.word_27,
           decoded.word_29, decoded.option_2b, decoded.word_2c)
    if decoded.count != count or got != words or (decoded.raw_type, decoded.runtime_type) != (0x97, 0x9F):
        raise OracleError("native decode count/neutral fields mismatch")
    for i in range(count):
        if bytes(decoded.names[i]) != raw[2 + 33 * i:35 + 33 * i]:
            raise OracleError("native fixed name mismatch")
    cursor = final + 46
    for entry in decoded.entries[:count]:
        selector, = struct.unpack_from("<h", raw, cursor)
        size = 33 if selector == -1 else selector
        if (entry.selector, entry.body_offset, entry.length) != (selector, cursor, size):
            raise OracleError("native entry boundary mismatch")
        if address(entry.bytes) != c.addressof(src) + cursor + 2:
            raise OracleError("native borrowed entry pointer mismatch")
        cursor += 2 + size
    if cursor != row["typed_body_length"] or decoded.body_bytes != cursor:
        raise OracleError("native typed body boundary mismatch")
    if (decoded.available_body_bytes, decoded.dependency_bytes, decoded.dependency_count) != (
            len(raw), len(raw) - cursor, (len(raw) - cursor) // 16):
        raise OracleError("native dependency split mismatch")
    if address(decoded.dependency_records) != c.addressof(src) + cursor:
        raise OracleError("native borrowed dependency pointer mismatch")


def compare(lib, original, lookup, act, seed, typed_length, offset=50):
    raw = act[50:]
    src, state = native.buffer(raw), native.Constructed()
    payload = native.buffer(b"\xCB" * 32767)
    status = lib.action_family_97_construct(src, len(raw), seed, offset,
        lookup.callback, None, payload, len(payload), c.byref(state))
    if status != 0:
        raise OracleError(f"native constructor rejected valid fixture: {status}")
    mine = bytes(payload[:state.allocation_bytes])
    got = original.run(act, seed, offset)
    if mine != got["payload"]:
        diff = next((i for i, (a, b) in enumerate(zip(mine, got["payload"])) if a != b),
                    min(len(mine), len(got["payload"])))
        raise OracleError(f"whole object mismatch at {diff:#x}; lengths native={len(mine)} original={len(got['payload'])}")
    if (state.body_bytes_consumed, state.payload_offset_after, state.random_state_after,
            state.selected_index, state.runtime_type) != (
            got["advance"], got["offset"], got["seed"], got["selected"], got["runtime_type"]):
        raise OracleError("original/native cursor, normalization or selection mismatch")
    if got["advance"] != typed_length or got["offset"] != (offset + typed_length) & 0xFFFFFFFF:
        raise OracleError("original cursor disagrees with corpus typed-body rule")
    count = struct.unpack_from("<h", raw)[0]
    expected_after = bytearray(act)
    for i in range(count):
        expected_after[52 + 33 * i:85 + 33 * i] = bytes(state.names_after[i])
    if got["act_after"] != bytes(expected_after) or bytes(src) != raw:
        raise OracleError("original star-removal model/source preservation mismatch")
    selected = state.selected_index
    cursor = 15 + 33 * count
    for i in range(count):
        selector, = struct.unpack_from("<h", raw, cursor)
        if i == selected and state.selector != selector:
            raise OracleError("native selected selector mismatch")
        cursor += 35 if selector == -1 else selector + 2
    last_star = max((i for i in range(count) if raw[2 + 33 * i] == 42), default=-1)
    if (state.random_advanced, state.raw_type, state.random_state_before, state.payload_offset_before) != (
            int(last_star < 0), 0x97, seed, offset):
        raise OracleError("native constructor metadata mismatch")
    if last_star >= 0 and selected != last_star:
        raise OracleError("last starred name did not select")
    if (state.dependency_bytes, state.dependency_count) != (len(raw) - typed_length, (len(raw) - typed_length) // 16):
        raise OracleError("constructor dependency split mismatch")
    if address(state.dependency_records) != c.addressof(src) + typed_length:
        raise OracleError("constructor borrowed dependency pointer mismatch")
    if bytes(payload[state.allocation_bytes:]) != b"\xCB" * (len(payload) - state.allocation_bytes):
        raise OracleError("native wrote beyond requested allocation")
    if got["subtype"] != act[49]:
        raise OracleError("original loader changed subtype")
    return mine, got["payload"], state


def seed_for(n, index):
    for seed in range(65536):
        next_ = (seed * 214013 + 2531011) & 0xFFFFFFFF
        if ((next_ >> 16) & 32767) % n == index:
            return seed
    raise OracleError("no synthetic RNG seed found")


def inputs():
    manifest_bytes = (ROOT / "work/analysis/hiff-resources.json").read_bytes()
    corpus_bytes = (ROOT / "work/analysis/slices/A-97.1-discovery-corpus.json").read_bytes()
    if sha(manifest_bytes) != MANIFEST_HASH or sha(corpus_bytes) != CORPUS_HASH:
        raise OracleError("manifest/census identity mismatch")
    manifest, corpus = json.loads(manifest_bytes), json.loads(corpus_bytes)
    if manifest["archive_sha256"] != ARCHIVE_HASH or corpus["archive_sha256"] != ARCHIVE_HASH:
        raise OracleError("archive identity mismatch")
    if corpus["exe_sha256"] != EXE_HASH or corpus["manifest_sha256"] != MANIFEST_HASH:
        raise OracleError("census original/manifest identity mismatch")
    if (corpus["resources_scanned"], corpus["scen_data_records"], corpus["scene_actions"],
            corpus["raw_0x97_records"], len(corpus["records"])) != (2267, 2078, 19612, 1958, 1958):
        raise OracleError("census coverage mismatch")
    resources = {}
    for r in manifest["resources"]:
        index = int(r["index"])
        data = (ROOT / "work/analysis/hiff-resources" / f"{index:04d}.bin").read_bytes()
        if len(data) != r["size"] or sha(data) != r["sha256"]:
            raise OracleError(f"resource {index} size/hash mismatch")
        resources[index] = data
    if len(resources) != 2267:
        raise OracleError("resource count mismatch")
    return corpus, resources


def synthetic_cases():
    cases = [
        ("minimum-count-empty-inline", native.body(), 1, 50),
        ("maximum-count-positive-and-auto", native.body(tuple(f"n{i}".encode() for i in range(9)),
            (b"a", (b"A97TEXT",), b"b\0c", b"", b"d", b"e", b"f", b"g", b"h"), tail=2), seed_for(9, 1), 50),
        ("positive-inline-embedded-nul", native.body(entries=(b"a\0bc",)), 0xFFFFFFFF, 50),
        ("last-star-wins", native.body((b"*a", b"b", b"*c"), (b"x", b"y", b"z")), 0x89ABCDEF, 50),
        ("empty-star", native.body((b"*",), (b"abc",)), 12345, 50),
        ("32-byte-name", native.body((b"Q" * 32,), (b"abc",)), 32767, 50),
        ("auto-text-missing", native.body(entries=((b"ZZNOPE",),)), 1, 50),
        ("auto-text-empty-key", native.body(entries=((b"",),)), 2, 50),
        ("auto-text-case-fold-and-nul", native.body(entries=((b"a97nul",),)), 3, 50),
        ("auto-text-empty-value", native.body(entries=((b"A97EMPTY",),)), 4, 50),
        ("max-safe-inline-allocation", native.body(entries=(b"x" * 32592,)), 5, 50),
        ("max-safe-auto-allocation", native.body(entries=((b"A97MAX",),)), 6, 50),
        ("signed-entry-sum-maximum", native.body((b"*a", b"b"), (b"", b"y" * 32763)), 7, 50),
        ("DWORD-offset-wrap", native.body(entries=(b"abc",), tail=1), 8, 0xFFFFFFF0),
    ]
    raw = bytearray(native.body((b"*first", b"*last"), (b"", b"")))
    raw[10:35] = b"\xA7" * 25
    cases.append(("star-padding-retained", bytes(raw), 9, 50))
    return cases


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--native-library", type=Path, default=native.LIBRARY)
    parser.add_argument("--result", type=Path, default=ROOT / "work/analysis/slices/A-97.1.original-oracle.json")
    parser.add_argument("--first-record-only", action="store_true", help="mutation/reproduction probe; never full acceptance")
    args = parser.parse_args()
    begin = time.monotonic()
    corpus, resources = inputs()
    original = Original97(ROOT / "work/original/GAME.EXE")
    for va, size, digest in CODE_WINDOWS:
        if sha(original.pe.image[va - original.pe.image_base:va - original.pe.image_base + size]) != digest:
            raise OracleError(f"original code window mismatch {va:#x}")
    extra = {b"A97TEXT": b"hello", b"A97NUL": b"a\0ignored", b"A97EMPTY": b"",
             b"A97MAX": b"x" * 32591}
    entries = parse_entries(_read_cvtx_payload(resources[1]))
    table_rows = original.install_table(entries, extra)
    lookup_rows = {e["key"]: e["caption"] for e in entries}
    lookup_rows.update(extra)
    lookup = native.DictionaryLookup(lookup_rows)
    lib = native.bind(args.native_library)
    native_hash, original_hash, body_hash = (hashlib.sha256() for _ in range(3))
    object_bytes = calls = unique = 0
    resources_used = set()
    selections = Counter()
    for ordinal, row in enumerate(corpus["records"]):
        data = resources[row["resource_index"]]
        a, length = row["act_payload_offset"], row["act_payload_length"]
        if row["raw_body_offset"] != a + 50 or row["raw_body_length"] != length - 50:
            raise OracleError("row ACT header/body offsets disagree")
        act = data[a:a + length]
        if len(act) != length or act[48] != 0x97 or act[49] != row["subtype"] or sha(act[50:]) != row["body_sha256"]:
            raise OracleError("row source bytes or type mismatch")
        verify_decode(lib, act[50:], row)
        body_hash.update(act[50:])
        resources_used.add(row["resource_index"])
        n = row["count"]
        seeds = [((ordinal + 1) * 0x1020304) & 0xFFFFFFFF]
        initial_index = (((seeds[0] * 214013 + 2531011) & 0xFFFFFFFF) >> 16 & 32767) % n
        seeds.extend(seed_for(n, i) for i in range(n) if i != initial_index)
        for seed in seeds:
            try:
                mine, got, state = compare(lib, original, lookup, act, seed, row["typed_body_length"])
            except Exception as error:
                raise OracleError(f"record {ordinal} resource={row['resource_index']} action={row['action_index']} seed={seed}: {error}") from error
            native_hash.update(mine)
            original_hash.update(got)
            object_bytes += len(mine)
            selections[state.selector] += 1
            calls += 1
        unique += 1
        if args.first_record_only:
            break
    synthetic_results = []
    if not args.first_record_only:
        for label, raw, seed, offset in synthetic_cases():
            src, d = native.buffer(raw), native.Decoded()
            if lib.action_family_97_decode(src, len(raw), c.byref(d)) != 0:
                raise OracleError(f"synthetic decode rejected: {label}")
            act = bytes(48) + b"\x97\x01" + raw
            mine, got, state = compare(lib, original, lookup, act, seed, d.body_bytes, offset)
            native_hash.update(mine)
            original_hash.update(got)
            object_bytes += len(mine)
            synthetic_results.append(dict(label=label, allocation_bytes=len(mine),
                typed_body_bytes=d.body_bytes, selected_index=state.selected_index, mismatches=0))
    if not args.first_record_only and (unique, calls) != (1958, 7728):
        raise OracleError("original calls do not cover every corpus alternative")
    report = dict(scope="raw-0x97 body boundary and complete allocation constructor only",
        partial_probe=args.first_record_only, unique_corpus_records=unique,
        corpus_alternative_comparisons=calls, synthetic_comparisons=len(synthetic_results),
        original_native_calls=calls + len(synthetic_results), object_bytes_compared=object_bytes,
        mismatches=0, resources_verified=len(resources), resources_with_raw97=len(resources_used),
        scenes=2078, actions=19612, selections_by_selector=dict(selections),
        original_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
        corpus_sha256=CORPUS_HASH, raw_bodies_sha256=body_hash.hexdigest(),
        native_object_images_sha256=native_hash.hexdigest(), original_object_images_sha256=original_hash.hexdigest(),
        native_library_sha256=sha(args.native_library.read_bytes()),
        oracle_sha256=sha(Path(__file__).read_bytes()),
        native_source_sha256=sha((PROJECT / "src/action_family_97.c").read_bytes()),
        code_windows=[dict(va=hex(a), size=b, sha256=h) for a, b, h in CODE_WINDOWS],
        autotext_entries_installed=table_rows, original_malloc_calls=original._allocator_calls,
        hooks=[dict(address="0x51dc43", boundary="malloc", policy="bounded patterned arena; real loader zeroing and copies execute"),
               dict(iat="0x52a2a4", boundary="GetLastError", policy="synthetic last-error value"),
               dict(iat="0x52a0dc", boundary="TlsGetValue", policy="return initialized CRT thread object; original rand executes"),
               dict(iat="0x52a1d0", boundary="SetLastError", policy="store synthetic last-error value")],
        os_hook_calls=dict(original.os_calls),
        unhooked_original_decisions=["raw dispatch/header setup", "star stripping/last-star selection",
            "CRT rand LCG and modulo", "AUTOTEXT init, insert, hash, lookup, ASCII case folding",
            "allocation length and cursor arithmetic", "0x410f99 defaults helper", "missing-key sprintf",
            "runtime 0x9f normalization"],
        synthetic_cases=synthetic_results,
        deliberate_safety_rejections=["counts <=0 or >=10", "negative selectors except -1",
            "truncation/unbounded names or keys", "signed 16-bit entry-sum wrap",
            "signed 16-bit allocation overflow", "malformed dependency tail", "NULL/overlap/span overflow"],
        unverified_branches=["raw 0x9e alternative branch", "allocation failure/fatal GUI/logging",
            "new CRT-thread TLS allocation", "AUTOTEXT >40000-byte fatal path",
            "unsafe negative-count/selector or wrapped-size original paths", "dependency tree construction",
            "runtime/lifecycle/rendering/subtype behavior"],
        elapsed_seconds=round(time.monotonic() - begin, 3))
    args.result.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({k: report[k] for k in ("unique_corpus_records", "corpus_alternative_comparisons",
        "synthetic_comparisons", "object_bytes_compared", "mismatches", "elapsed_seconds")}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
