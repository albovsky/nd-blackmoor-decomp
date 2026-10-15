#!/usr/bin/env python3
"""A-4B.1: immutable x86 loader/object and generic dependency-tail oracle.

Run with work/tools/oracle-python/bin/python and Unicorn JIT permitted. Only
malloc and the shared tail oracle's diagnostic boundary are replaced. Original
lookup, signed sizes, copies, cursor changes and tail decisions execute as-is.
All generated libraries, reports and logs use unique private paths.
"""
import argparse
from collections import Counter
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import sys
import tempfile
import time

sys.dont_write_bytecode = True
from autotext_original_oracle import (OriginalAutoText, _read_cvtx_payload,
    parse_entries, TABLE_VA, ALLOC_BASE, ALLOC_LIMIT, STACK_TOP, ALLOCATOR_VA)
from tail_oracle_common import (OriginalTail, run_family, build_native,
    HOOKS as TAIL_HOOKS, EXIT_POINTS as TAIL_EXITS, TailMismatch)
from test_action_family_4b import Decoded, Constructed, fixture, storage, load_native

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / 'outputs/blackmoor-decomp'
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = 'bdcc8ed5f083a583c01b624dcb5721c24c961199e9914469a15bec0dedc8ca20'
CODE = [
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x410ca4, 0x410f89, 'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'),
    (0x40c625, 0x40caac, 'e415cd94005561c7a0d8c78614cec5563ecad10c7bad554e5233573bda1eb212'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x423097, 0x4230d1, '9ef78e5e90da3f4962a0ddc051cae69dc5052a7bf3c04653428f1a6347cb3e0f'),
    (0x423142, 0x423259, '6910fd42954f15d645d47b5092f2f8856dca626982d0c7e053a167083309f578'),
    (0x423259, 0x423310, 'e482a132a6a8391b0b8c3e69e2008669d9af3ed80c4e426de7da0d9b996d047e'),
    (0x53f428, 0x53f520, 'ef89465743efd658713ed226b1a1b636040624abe96f21b95d0e733f37484e47'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
    (0x50ca3e, 0x50ca90, 'e38ee527f737dc4c39c3e4bf44ffc0e27aed605f503d9b00fed4e19973f97c73'),
]
INPUT, INPUT_CAPACITY, GLOBAL_TABLE = 0x24000000, 0x20000, 0x619a6b
BOUNDARY, ROW = 0x410a68, 0x5bb5b3


class OracleError(AssertionError):
    pass


def require(ok, message):
    if not ok:
        raise OracleError(message)


def sha(data):
    return hashlib.sha256(data).hexdigest()


class OriginalLoader(OriginalAutoText):
    def __init__(self):
        self.allocations = []
        self.source_span = (0, 0)
        self.running_body = False
        self.active_allocation = None
        self.calls = self.full_calls = self.arm_calls = 0
        self.seed = 0xcd
        super().__init__(ROOT / 'work/original/GAME.EXE')
        from unicorn import UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE, UC_PROT_READ
        self.machine.mem_map(INPUT, INPUT_CAPACITY, UC_PROT_READ)
        self.machine.hook_add(UC_HOOK_MEM_READ, self.observe_read,
                              begin=INPUT, end=INPUT + INPUT_CAPACITY - 1)
        self.machine.hook_add(UC_HOOK_MEM_WRITE, self.observe_write,
                              begin=ALLOC_BASE, end=ALLOC_LIMIT)
        for start, end, digest in CODE:
            require(sha(self.pe.image[start-self.pe.image_base:end-self.pe.image_base]) == digest,
                    f'pinned code/literal window mismatch: {start:#x}')

    def observe_read(self, _uc, _access, address, size, _value, _data):
        require(self.source_span[0] <= address and address + size <= self.source_span[1],
                f'original source read outside exact ACT: {address:#x}, {size}')

    def observe_write(self, _uc, _access, address, size, _value, _data):
        if self.running_body:
            require(self.active_allocation is not None, 'original write before body allocation')
            start, length = self.active_allocation
            require(start <= address and address + size <= start + length,
                    f'original allocation write outside exact extent: {address:#x}, {size}')

    def _on_code(self, uc, address, _size, _data):
        require(address == ALLOCATOR_VA, 'unexpected replacement hook')
        esp = uc.reg_read(self._reg['ESP'])
        requested = struct.unpack('<I', uc.mem_read(esp + 4, 4))[0]
        start = ((self._allocator_cursor + 31) & ~15) + 16
        end = start + requested
        require(requested > 0 and end + 16 <= ALLOC_LIMIT,
                f'allocator boundary exceeded: {requested}')
        uc.mem_write(start - 16, b'\xa5' * 16 + bytes([self.seed]) * requested + b'\xd7' * 16)
        self._allocator_cursor = end + 16
        self._allocator_calls += 1
        self.allocations.append((start, requested))
        if self.running_body:
            require(self.active_allocation is None, 'more than one body allocation')
            self.active_allocation = (start, requested)
        uc.reg_write(self._reg['EAX'], start)
        self._return_from_intercepted_call(uc)

    def copy_table(self):
        self.machine.mem_write(GLOBAL_TABLE, bytes(self.machine.mem_read(TABLE_VA, 4096)))

    def invoke(self, payload, seed=0xcd, arm_offset=None):
        uc, r = self.machine, self._reg
        require(len(payload) + 32 <= INPUT_CAPACITY and payload[48] == 0x4b,
                'invalid original ACT fixture')
        require(b'\0' in payload[:48], 'original description needs bounded NUL')
        self.seed, self.source_span = seed, (INPUT + 16, INPUT + 16 + len(payload))
        uc.mem_write(INPUT, b'\xa6' * 16 + payload + b'\xd6' * 16)
        uc.mem_write(0x5c39e3, bytes(2))
        uc.mem_write(ROW - 16, b'\x91' * 16 + bytes(0x8d) + b'\x92' * 16)
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'nonzero original debug flag')
        stack_args = struct.pack('<III', 0x30000000, INPUT + 16, len(payload))
        uc.mem_write(STACK_TOP - 0x1000, b'\x3c' * 16)
        uc.mem_write(STACK_TOP + 32, b'\x7e' * 16)
        uc.mem_write(STACK_TOP, stack_args)
        for key, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=0x33333333,
                               EDX=0x44444444, ESI=0x55555555, EDI=0x66666666,
                               EBP=0x77777777, ESP=STACK_TOP, EFLAGS=0x202).items():
            uc.reg_write(r[key], value)
        entry = 0x40b34a
        if arm_offset is not None:
            # Direct entry to the inline constructor block with its caller frame
            # slots initialized; no original instruction/decision is replaced.
            frame = STACK_TOP - 0x100
            uc.reg_write(r['EBP'], frame)
            uc.mem_write(frame - 0x20, struct.pack('<I', INPUT + 16 + 50))
            uc.mem_write(frame - 0xcc, struct.pack('<I', arm_offset))
            row = bytearray(0x8d)
            end_name = payload[:48].index(0) + 1
            row[:end_name] = payload[:end_name]
            row[48:50] = payload[48:50]
            uc.mem_write(ROW, bytes(row))
            entry = 0x40c625
        before = len(self.allocations)
        self.active_allocation, self.running_body = None, True
        try:
            uc.emu_start(entry, BOUNDARY, count=4000000)
        finally:
            self.running_body = False
        require(uc.reg_read(r['EIP']) == BOUNDARY and len(self.allocations) == before + 1,
                'original loader did not reach dependency handoff with one allocation')
        addr, n = self.allocations[-1]
        ebp = uc.reg_read(r['EBP'])
        cursor = struct.unpack('<I', uc.mem_read(ebp - 0x20, 4))[0]
        offset = struct.unpack('<I', uc.mem_read(ebp - 0xcc, 4))[0]
        row = bytearray(0x8d)
        end_name = payload[:48].index(0) + 1
        row[:end_name] = payload[:end_name]
        row[48:50] = payload[48:50]
        row[50:54] = struct.pack('<I', addr)
        require(bytes(uc.mem_read(ROW, 0x8d)) == bytes(row),
                'original row/raw runtime type/subtype/slot mismatch')
        for pos, expected in ((INPUT, b'\xa6' * 16), (INPUT + 16, payload),
                              (INPUT + 16 + len(payload), b'\xd6' * 16),
                              (addr - 16, b'\xa5' * 16), (addr + n, b'\xd7' * 16),
                              (ROW - 16, b'\x91' * 16), (ROW + 0x8d, b'\x92' * 16),
                              (STACK_TOP - 0x1000, b'\x3c' * 16), (STACK_TOP, stack_args),
                              (STACK_TOP + 32, b'\x7e' * 16)):
            require(bytes(uc.mem_read(pos, len(expected))) == expected,
                    f'original source/allocation/row/stack guard changed: {pos:#x}')
        self.calls += 1
        self.full_calls += arm_offset is None
        self.arm_calls += arm_offset is not None
        return bytes(uc.mem_read(addr, n)), cursor - (INPUT + 16 + 50), offset, addr


class Native:
    def __init__(self, library):
        self.family, self.library = '4b', Path(library)
        self.lib = load_native(self.library)

    def invoke(self, body, length=None):
        raw, decoded = storage(body), Decoded()
        C.memset(C.byref(decoded), 0xa5, C.sizeof(decoded))
        before = bytes(decoded)
        status = self.lib.action_family_4b_decode(raw, len(body) if length is None else length,
                                                 C.byref(decoded))
        return status, decoded, raw, before

    def validated_length(self, payload, expected):
        result, decoded, raw, _ = self.invoke(payload[50:])
        size = C.c_size_t()
        require(result == 0 and decoded.body_bytes == expected and
                self.lib.action_family_4b_body_length(raw, len(payload) - 50, C.byref(size)) == 0 and
                size.value == expected, 'native validated typed extent mismatch')
        return size.value


class TailNative(Native):
    def invoke(self, body, length=None):
        status, decoded, raw, before = super().invoke(body, length)
        size = C.c_size_t(0xabcdef)
        result = self.lib.action_family_4b_body_length(raw, len(body) if length is None else length,
                                                      C.byref(size))
        require(result == status and (size.value == decoded.body_bytes if status == 0 else
                                     size.value == 0xabcdef),
                'native body_length/decode tail or short-body status mismatch')
        return status, decoded, raw, before


def compare(native, machine, payload, resolved, ordinal, seed=0xcd, arm_offset=None):
    body = payload[50:]
    result, d, raw, _ = native.invoke(body)
    require(result == 0, f'native rejected original-valid record {ordinal}')
    original, advance, offset, handle = machine.invoke(payload, seed, arm_offset)
    size = C.c_size_t()
    require(native.lib.action_family_4b_body_length(raw, len(body), C.byref(size)) == 0 and
            d.body_bytes == size.value == advance, f'original/native body_length mismatch {ordinal}')
    selector = struct.unpack_from('<h', body)[0]
    require(d.text_selector == selector, f'original/native selector mismatch {ordinal}')
    if selector == -1:
        key = body[2:35].split(b'\0')[0]
        require(bytes(d.text_key) == key + bytes(33 - len(key)) and
                d.inline_text is None and d.inline_text_bytes == 0,
                f'original/native key view mismatch {ordinal}')
    else:
        require(bytes(d.text_key) == bytes(33) and d.inline_text == C.addressof(raw) + 2 and
                d.inline_text_bytes == selector, f'original/native inline view mismatch {ordinal}')
    require((d.dependency_records, d.dependency_bytes, d.available_body_bytes) ==
            (C.addressof(raw) + advance, len(body) - advance, len(body)),
            f'original/native borrowed boundary mismatch {ordinal}')
    text = storage(resolved) if resolved else None
    constructed = Constructed()
    before_offset = 50 if arm_offset is None else arm_offset
    require(native.lib.action_family_4b_construct(raw, len(body), text, len(resolved or b''),
            before_offset, handle, C.byref(constructed)) == 0,
            f'native constructor rejected original-valid record {ordinal}')
    image = bytes(constructed.object_bytes[:constructed.allocation_bytes])
    require(image == original, f'original/native constructor object mismatch {ordinal}: '
            f'sizes {len(image)}/{len(original)}')
    require((constructed.body_bytes_consumed, constructed.payload_offset_before,
             constructed.payload_offset_after, constructed.result_slot_handle) ==
            (advance, before_offset, offset, handle) and offset == (before_offset + advance) & 0xffffffff,
            f'original/native constructor cursor/handle mismatch {ordinal}')
    require((constructed.dependency_records, constructed.dependency_count,
             constructed.dependency_bytes, constructed.available_body_bytes) ==
            (d.dependency_records, d.dependency_count, d.dependency_bytes, len(body)),
            f'original/native constructor tail metadata mismatch {ordinal}')
    require(bytes(raw) == body, 'native modified raw input')
    return image, original, advance


def safety_checks(native):
    # Fully backed fixtures allow short-body mutants to fail deterministically
    # without host out-of-bounds reads. These statuses are native safety only.
    probes = []
    for selector in (-32768, -2, 10000, 32767):
        probes.append((struct.pack('<h', selector) + bytes(40), 2, 3))
    probes.extend([(fixture(0), 0, 2), (fixture(0), 1, 2),
                   (fixture(-1), 34, 2), (fixture(10), 11, 2),
                   (b'\xff\xff' + b'K' * 33, 35, 4)])
    for body, logical, expected in probes:
        raw = storage(body)
        d, out, size = Decoded(), Constructed(), C.c_size_t(0xabcdef)
        C.memset(C.byref(d), 0xa5, C.sizeof(d)); C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(d), bytes(out), size.value
        results = (native.lib.action_family_4b_decode(raw, logical, C.byref(d)),
                   native.lib.action_family_4b_construct(raw, logical, None, 0, 50, 7, C.byref(out)),
                   native.lib.action_family_4b_body_length(raw, logical, C.byref(size)))
        require(results == (expected,) * 3 and (bytes(d), bytes(out), size.value) == before,
                f'native malformed safety mismatch: logical={logical}, statuses={results}')
    # The original's 40000-character diagnostic is not its safe allocation bound.
    raw, text, out = storage(fixture(-1)), storage(b'z' * 32762), Constructed()
    C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
    require(native.lib.action_family_4b_construct(raw, 35, text, 32762, 50, 7, C.byref(out)) == 8 and
            bytes(out) == before, 'native signed allocation overflow safety mismatch')
    return len(probes) + 1


def inputs():
    manifest_bytes = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    corpus_bytes = (PRIVATE / 'A-4B.1.corpus.json').read_bytes()
    require(sha(manifest_bytes) == MANIFEST_HASH and sha(corpus_bytes) == CORPUS_HASH,
            'pinned manifest/corpus mismatch')
    manifest, corpus = json.loads(manifest_bytes), json.loads(corpus_bytes)
    require((manifest['archive_sha256'], len(manifest['resources']), corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['archive_sha256'], corpus['resources_scanned'],
             corpus['scen_data_records'], corpus['scene_actions'], corpus['raw_0x4b_records'],
             len(corpus['records'])) ==
            (ARCHIVE_HASH, 2267, EXE_HASH, MANIFEST_HASH, ARCHIVE_HASH, 2267, 2078, 19612, 9, 9),
            'pinned input identity/count mismatch')
    resources = {}
    for row in manifest['resources']:
        data = (ROOT / 'work/analysis/hiff-resources' / f'{int(row["index"]):04d}.bin').read_bytes()
        require((len(data), sha(data)) == (row['size'], row['sha256']), 'resource manifest mismatch')
        resources[int(row['index'])] = data
    records = []
    for row in corpus['records']:
        data = resources[row['resource_index']]
        start, length = row['act_payload_offset'], row['act_payload_length']
        payload = data[start:start + length]
        body, typed = payload[50:], row['typed_body_length']
        require(len(payload) == length and payload[48:50] == bytes([0x4b, row['subtype']]) and
                row['raw_body_offset'] == start + 50 and (len(body), sha(body)) ==
                (row['raw_body_length'], row['body_sha256']) and sha(body[:typed]) == row['prefix_sha256'] and
                sha(body[typed:]) == row['dependency_tail_sha256'] and
                (len(body) - typed, (len(body) - typed) // 16) ==
                (row['dependency_tail_length'], row['dependency_tail_records']), 'row source mismatch')
        records.append((payload, typed))
    return resources, records


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--native-library', type=Path)
    parser.add_argument('--result', type=Path)
    args = parser.parse_args()
    directory = Path(tempfile.mkdtemp(prefix='A-4B.1.oracle-', dir=PRIVATE))
    result_path = args.result or directory / 'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    resources, records = inputs()
    library = args.native_library or build_native('4b', directory)
    native, machine = Native(library), OriginalLoader()
    machine.initialize()
    captions = {}
    entries = parse_entries(_read_cvtx_payload(resources[1]))
    for entry in entries:
        machine.insert(entry['key_field'], entry['raw_value'])
        captions.setdefault(entry['key'].lower(), entry['caption'])
    machine.copy_table()
    table_allocations = len(machine.allocations)
    native_digest, original_digest, body_digest, tail_digest = (hashlib.sha256() for _ in range(4))
    object_bytes = 0
    missing_keys = 0
    for ordinal, (payload, _typed) in enumerate(records):
        body = payload[50:]
        selector = struct.unpack_from('<h', body)[0]
        resolved = None
        if selector == -1:
            key = body[2:35].split(b'\0')[0].lower()
            if key in captions:
                resolved = captions[key]
            else:
                # Independently format the immutable literal; original sprintf
                # at 0x50ca3e and its formatter execute without replacement.
                original_key = body[2:35].split(b'\0')[0]
                fmt = machine.pe.image[0x53f398-machine.pe.image_base:0x53f3dc-machine.pe.image_base].split(b'\0')[0]
                require(fmt.count(b'%s') == 1, 'unexpected missing-key format')
                resolved = fmt.replace(b'%s', original_key)
                missing_keys += 1
        image, original, advance = compare(native, machine, payload, resolved, ordinal, seed=ordinal * 17)
        native_digest.update(image); original_digest.update(original)
        body_digest.update(body); tail_digest.update(body[advance:]); object_bytes += len(image)
    synthetic = []
    specifications = [(0, 0), (1, 0), (9999, 0), (3, 0), (-1, 0), (-1, 1), (-1, 32), (-1, 32761)]
    for i, (selector, resolved_bytes) in enumerate(specifications):
        body = fixture(selector, i % 4, text=b'a\0b' if i == 3 else None)
        resolved = None
        if selector == -1:
            key = b'k' * 32 if i == 6 else f'4BSYNTH{i}'.encode()
            body = fixture(-1, i % 4, key=key, key_padding=0xfe)
            resolved = b'z' * resolved_bytes
            machine.insert(key + bytes(33 - len(key)), resolved)
            machine.copy_table()
        subtype = (0, 1, 2, 255)[i % 4]
        payload = b'synthetic' + bytes(39) + bytes([0x4b, subtype]) + body
        image, _, _ = compare(native, machine, payload, resolved, f'synthetic-{i}', seed=i * 29)
        arm_offset = (0, 50, 0xfffffffe, 0xffffffff)[i % 4]
        image2, _, _ = compare(native, machine, payload, resolved, f'arm-{i}',
                                seed=255 - i * 29, arm_offset=arm_offset)
        require(image == image2, 'constructor image depends on allocator seed/caller offset')
        synthetic.append(dict(selector=selector, resolved_bytes=resolved_bytes, subtype=subtype,
                              allocation_bytes=len(image), arm_payload_offset=arm_offset,
                              dependency_records=i % 4))
    # The shared runner executes immutable 0x424aa8 for every corpus tail,
    # all 0..48-byte tails per corpus prefix, larger tails, count-width probes
    # and padded short-body safety probes. It never constructs/evaluates a tree.
    tail_machine = OriginalTail()
    tail = run_family(TailNative(library), tail_machine, records)
    tail['original_calls'] = tail_machine.calls
    tail['body_length_api_checked_per_probe'] = True
    safety = safety_checks(native)
    report = dict(slice='A-4B.1', status='pass', mismatches=0,
        scope='raw4b loader to 0x410a68, direct inline constructor block, original generic tail exits',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=CODE),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        native_library=str(library), native_library_sha256=sha(Path(library).read_bytes()),
        source_sha256=sha((PROJECT / 'src/action_family_4b.c').read_bytes()),
        header_sha256=sha((PROJECT / 'src/action_family_4b.h').read_bytes()),
        shared_tail_oracle_sha256=sha((PROJECT / 'tests/tail_oracle_common.py').read_bytes()),
        autotext_oracle_sha256=sha((PROJECT / 'tests/autotext_original_oracle.py').read_bytes()),
        corpus_records=len(records), synthetic_records=len(synthetic), synthetic=synthetic,
        original_body_calls=machine.calls, full_loader_calls=machine.full_calls, direct_arm_calls=machine.arm_calls,
        autotext_entries_inserted=len(entries), autotext_table_allocations=table_allocations,
        corpus_missing_key_fallbacks=missing_keys, original_sprintf_replaced=False,
        corpus_object_bytes_compared=object_bytes, corpus_object_sha256=native_digest.hexdigest(),
        original_object_sha256=original_digest.hexdigest(),
        corpus_raw_bodies_sha256=body_digest.hexdigest(), corpus_dependency_tails_sha256=tail_digest.hexdigest(),
        synthetic_object_bytes_compared=2 * sum(x['allocation_bytes'] for x in synthetic),
        tail_oracle=tail, native_malformed_safety_checks=safety,
        replacement_hooks={'0x51dc43': 'malloc only; exact original request, seeded guarded allocation, cdecl return',
                           **TAIL_HOOKS},
        observer_hooks={'input': 'read-only 0x24000000..0x2401ffff; exact ACT read span',
                        'allocations': '0x20010000..0x20fff000; original body writes only inside current allocation'},
        stop_points={'0x410a68': 'before dependency handoff; typed cursor and offset observed', **TAIL_EXITS},
        original_decisions_replaced=False, original_files_modified=False,
        unverified=['nonzero diagnostics flag (missing-key fallback with zero flag is corpus-verified)',
            'allocator failure, fatal cleanup and original malformed/negative/truncated memory paths',
            'resolved lengths 32762..40000 signed allocation overflow (native safety rejection only)',
            'generic prior slot reuse, dependency opcode/tree construction and evaluation after accepted exit',
            'runtime textbox display/completion/rearm/subtype paths, rendering and host effects',
            'shared parser/dispatcher integration, independent review, Track M and playable game'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', corpus_records=len(records), original_body_calls=machine.calls,
                         tail_parity_comparisons=tail['parity_comparisons'], mismatches=0,
                         report=str(result_path))))


if __name__ == '__main__':
    main()
