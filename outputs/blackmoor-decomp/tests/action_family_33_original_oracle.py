#!/usr/bin/env python3
"""A-33.1 immutable-x86 loader/copy and real dependency-tail oracle.

Run with work/tools/oracle-python/bin/python and Unicorn JIT permitted.
Only malloc and the shared ragged-tail logging boundary are replacements.
Every report uses exclusive creation in a unique directory by default.
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

from cif_original_oracle import PEImage, OracleError
from test_action_family_33 import (Decoded, Constructed, body_fixture, load_native, pointer, storage)
from tail_oracle_common import (OriginalTail, NativeFamily, run_family, compare_tail,
                               HOOKS as TAIL_HOOKS, EXIT_POINTS as TAIL_EXITS,
                               TAIL_LENGTHS, WIDTH_TAILS)

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'  # read-only inputs; reports go to a unique temp directory
SCRATCH = Path('/private/tmp')
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '2c5e6cb31c2617ce74a0b0e6b60c48877bda1f647323f5cb7f3064a9818dbef3'
CODE = [
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x410ca4, 0x410f89, 'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'),
    (0x40c186, 0x40c29b, '5138b34021766b4f3054b12b114f54fdb69dd86f129266b3b7b33b40b8100bd7'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
]
INPUT, INPUT_CAPACITY, DATA, STACK = 0x20000000, 0x200000, 0x30000000, 0x5800
OUT, OWNER, ROW = DATA + 0x5000, 0x571442, 0x5bb5b3
STOP, ALLOCATOR, BOUNDARY, ARM = 0x51000000, 0x51dc43, 0x410a68, 0x40c186
MAX_OBJECT = 32767


def sha(data):
    return hashlib.sha256(data).hexdigest()


def require(condition, message):
    if not condition:
        raise OracleError(message)


def payload_for(body, subtype=1):
    return b'synthetic' + bytes(39) + bytes([0x33, subtype]) + body


class Original:
    def __init__(self, pe):
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
        from unicorn import x86_const as x
        self.r = {n: getattr(x, 'UC_X86_REG_' + n) for n in
                  ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI', 'EBP', 'ESP', 'EIP', 'EFLAGS', 'ES')}
        uc = self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        uc.mem_map(pe.image_base, (pe.size_of_image + 4095) & ~4095)
        uc.mem_write(pe.image_base, pe.image)
        uc.mem_map(0x1000, 0x10000)
        uc.mem_map(INPUT, INPUT_CAPACITY + 4096)
        uc.mem_map(DATA, 0x20000)
        uc.ctl_exits_enabled(True)
        self.allocations, self.probes, self.full_loaders, self.direct_arms = 0, 0, 0, 0
        self.sizes = Counter()
        self.source_span = (0, 0)
        self.stop_boundary = None
        uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        uc.hook_add(UC_HOOK_MEM_READ, self.observe_read, begin=INPUT, end=INPUT + INPUT_CAPACITY + 31)
        uc.hook_add(UC_HOOK_MEM_WRITE, self.observe_write, begin=OUT-16, end=OUT+MAX_OBJECT+15)

    def observe_read(self, _uc, _access, address, size, _value, _data):
        require(self.source_span[0] <= address and address + size <= self.source_span[1],
                f'original read outside exact fixture: {address:#x} + {size}')

    def observe_write(self, _uc, _access, address, size, _value, _data):
        require(OUT <= address and address + size <= OUT + self.extent,
                f'original write outside exact allocation: {address:#x} + {size}')

    def allocate(self, uc, address, _size, _data):
        require(address == ALLOCATOR, 'unexpected replacement')
        esp = uc.reg_read(self.r['ESP'])
        ret, n = struct.unpack('<II', uc.mem_read(esp, 8))
        require(ret == 0x40c1c1 and n == self.extent and 0 < n <= MAX_OBJECT,
                f'unexpected original allocation request: {n}')
        uc.mem_write(OUT-16, b'\xa5'*16 + self.seed + b'\xd7'*16)
        uc.reg_write(self.r['EAX'], OUT)
        uc.reg_write(self.r['ESP'], esp+4)
        uc.reg_write(self.r['EIP'], ret)
        self.allocations += 1
        self.sizes[n] += 1

    def prepare(self, payload, offset, direct):
        uc, r = self.uc, self.r
        require(163 <= len(payload) <= INPUT_CAPACITY, 'fixture outside loader budget')
        self.source_span = INPUT+16, INPUT+16+len(payload)
        uc.mem_write(INPUT, b'\xa6'*16 + payload + b'\xd6'*16)
        uc.mem_write(ROW, bytes(0x8d))
        self.owner_image = b'\x5a'*0x100
        uc.mem_write(OWNER-16, b'\x91'*16 + self.owner_image + b'\x92'*16)
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'nonzero diagnostic flag')
        uc.mem_write(0x5c39e3, bytes(2))
        self.args = struct.pack('<3I', STOP, INPUT+16, len(payload))
        uc.mem_write(STACK, self.args)
        uc.mem_write(STACK-0x1000, b'\x3c'*16)
        uc.mem_write(STACK+32, b'\x7e'*16)
        for name, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=OWNER,
            EDX=0x33333333, ESI=0x44444444, EDI=0x55555555, EBP=0x9800,
            ESP=STACK, EFLAGS=0x202, ES=0).items():
            uc.reg_write(r[name], value)
        if direct:
            uc.mem_write(0x9800-0x20, struct.pack('<I', INPUT+16+50))
            uc.mem_write(0x9800-0xcc, struct.pack('<I', offset))
        return ARM if direct else 0x40b34a

    def invoke(self, payload, *, direct=False, offset=50, seed_byte=0xcd, probe=False):
        body = payload[50:]
        a, b = struct.unpack_from('<hh', body, 109)
        wide = 113 + 6*a + 66*b
        narrowed = (wide + 32768) % 65536 - 32768
        self.extent = narrowed
        if not probe:
            require(a >= 0 and b >= 0 and 113 <= wide <= MAX_OBJECT and len(body) >= wide,
                    'unsafe original execution requested')
            self.seed = bytes([seed_byte])*wide
        entry = self.prepare(payload, offset, direct)
        before = self.allocations
        boundary = ALLOCATOR if probe else BOUNDARY
        # Keep one stop set per engine: Unicorn's cached translated blocks can
        # retain earlier exit instrumentation when the set changes mid-run.
        require(self.stop_boundary in (None, boundary), 'use a separate engine for allocation probes')
        self.stop_boundary = boundary
        self.uc.ctl_set_exits([boundary])
        try:
            self.uc.emu_start(entry, STOP, count=1000000)
        except Exception as error:
            raise OracleError(f'original execution failed: probe={probe}, counts={a},{b}, '
                f'EIP={self.uc.reg_read(self.r["EIP"]):#x}, allocations={self.allocations-before}') from error
        uc, r = self.uc, self.r
        if probe:
            require(uc.reg_read(r['EIP']) == ALLOCATOR and self.allocations == before,
                    'allocation probe did not stop before replacement')
            request = struct.unpack('<I', uc.mem_read(uc.reg_read(r['ESP'])+4, 4))[0]
            require(request == narrowed & 0xffffffff, 'original signed-16 narrowing mismatch')
            self.probes += 1
            return request
        require(uc.reg_read(r['EIP']) == BOUNDARY and self.allocations == before+1,
                'original failed to reach handoff with one allocation')
        ebp = uc.reg_read(r['EBP'])
        cursor = struct.unpack('<I', uc.mem_read(ebp-0x20, 4))[0]
        after = struct.unpack('<I', uc.mem_read(ebp-0xcc, 4))[0]
        expected_row = bytearray(0x8d)
        if not direct:
            n = payload[:48].index(0)+1
            expected_row[:n] = payload[:n]
            expected_row[48:50] = payload[48:50]
        expected_row[50:54] = struct.pack('<I', OUT)
        require(bytes(uc.mem_read(ROW, 0x8d)) == expected_row,
                'original raw/runtime type, subtype or result slot mismatch')
        for address, expected in ((INPUT, b'\xa6'*16), (INPUT+16, payload),
            (INPUT+16+len(payload), b'\xd6'*16), (OUT-16, b'\xa5'*16),
            (OUT+wide, b'\xd7'*16), (OWNER-16, b'\x91'*16), (OWNER, self.owner_image),
            (OWNER+0x100, b'\x92'*16), (STACK, self.args),
            (STACK-0x1000, b'\x3c'*16), (STACK+32, b'\x7e'*16)):
            require(bytes(uc.mem_read(address, len(expected))) == expected,
                    f'original input/owner/stack/allocation guard changed: {address:#x}')
        self.direct_arms += int(direct)
        self.full_loaders += int(not direct)
        return bytes(uc.mem_read(OUT, wide)), cursor-(INPUT+16+50), after


class Native33(NativeFamily):
    """Adapter so the shared A-TAIL driver can exercise family 0x33 (not in its pin table).

    invoke() and validated_length() are inherited unchanged from the reviewed helper."""
    def __init__(self, library):
        self.family, self.library = '33', Path(library)
        self.Decoded = Decoded
        self.lib = load_native(self.library)
        self.decode = self.lib.action_family_33_decode
        self.body_length = self.lib.action_family_33_body_length


class Native:
    family = '33'

    def __init__(self, lib):
        self.lib = lib

    def invoke(self, body, length=None):
        # Extra backing makes deliberate missing-guard mutants safe to probe.
        raw = storage(body + bytes(32768))
        d = Decoded()
        C.memset(C.byref(d), 0xa5, C.sizeof(d))
        before = bytes(d)
        status = self.lib.action_family_33_decode(raw, len(body) if length is None else length, C.byref(d))
        # Shared tail helper checks bytes(raw) == body, so expose the logical
        # input view while retaining the full allocation through ctypes _b_base_.
        view = (C.c_uint8 * max(1, len(body))).from_buffer(raw)
        return status, d, view, before


def compare(lib, machine, payload, label, *, direct=False, offset=50, seed_byte=0xcd):
    body = payload[50:]
    image, advance, after = machine.invoke(payload, direct=direct, offset=offset, seed_byte=seed_byte)
    raw = storage(body + bytes(32768))
    d, out, n = Decoded(), Constructed(), C.c_size_t(0x5a5a)
    require(lib.action_family_33_decode(raw, len(body), C.byref(d)) == 0, f'native rejected {label}')
    require(lib.action_family_33_body_length(raw, len(body), C.byref(n)) == 0 and n.value == advance,
            f'body_length/original cursor mismatch: {label}')
    a, b = struct.unpack_from('<HH', image, 109)
    require((d.raw_type, d.runtime_type, d.count_6d, d.count_6f) == (0x33, 0x33, a, b),
            f'decoded neutral field mismatch: {label}')
    require((d.body_bytes, pointer(d.typed_body), pointer(d.dependency_records),
             d.dependency_count, d.dependency_bytes, d.available_body_bytes) ==
            (advance, C.addressof(raw), C.addressof(raw)+advance,
             (len(body)-advance)//16, len(body)-advance, len(body)), f'decoded body/tail mismatch: {label}')
    arena = storage(bytes([0xa5])*16 + bytes([seed_byte])*(advance+16))
    target = C.cast(C.byref(arena, 16), C.POINTER(C.c_uint8))
    require(lib.action_family_33_construct(raw, len(body), offset, OUT, target, advance, C.byref(out)) == 0,
            f'native constructor rejected: {label}')
    native_image = bytes(arena)[16:16+advance]
    require(native_image == image, f'original/native allocation mismatch: {label}')
    require(bytes(arena)[:16] == bytes([0xa5])*16 and bytes(arena)[16+advance:] == bytes([seed_byte])*16,
            f'native object guard changed: {label}')
    require((out.body_bytes_consumed, out.payload_offset_before, out.payload_offset_after,
             pointer(out.dependency_records), out.dependency_count, out.dependency_bytes,
             out.available_body_bytes) ==
            (advance, offset, after, C.addressof(raw)+advance, (len(body)-advance)//16,
             len(body)-advance, len(body)), f'original/native cursor/body rule mismatch: {label}')
    require((pointer(out.object_bytes), out.output_handle, out.result_slot_handle,
             out.output_allocation_bytes) == (pointer(target), OUT, OUT, advance),
            f'original/native allocation rule mismatch: {label}')
    require(bytes(raw) == body+bytes(32768), 'native changed input')
    return native_image, image, advance


def check_safety(lib, machine, native):
    records = []
    # Execute original arithmetic to malloc entry only: never attempt negative
    # or narrowed allocations/copies and never replace the arithmetic decision.
    for a, b in ((0x8000, 0), (0xffff, 0), (0, 0x8000), (0, 0xffff),
                 (5443, 0), (0, 495), (5442, 1), (10923, 0), (32767, 32767),
                 (0xffff, 2), (0xfffa, 10)):
        body = bytearray(body_fixture())
        struct.pack_into('<HH', body, 109, a, b)
        request = machine.invoke(payload_for(body), probe=True)
        status, d, raw, before = native.invoke(bytes(body))
        n = C.c_size_t(0x5a5a)
        require(status == 6 and bytes(d) == before and
                lib.action_family_33_body_length(raw, len(body), C.byref(n)) == 6 and n.value == 0x5a5a,
                'native count safety status mismatch')
        records.append(dict(count_bits=[a, b], original_allocation_request=request, native_status=status))
    short_cases = 0
    for a, b in ((0, 0), (4, 1)):
        body = body_fixture(a, b)
        typed = len(body)
        for n in range(typed):
            status, d, raw, before = native.invoke(body, n)
            length = C.c_size_t(0x5a5a)
            require(status == 2 and bytes(d) == before and
                    lib.action_family_33_body_length(raw, n, C.byref(length)) == 2 and length.value == 0x5a5a,
                    'native short-body safety status mismatch')
            short_cases += 1
    return records, short_cases


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--native-library', type=Path, default=ROOT/'outputs/blackmoor-decomp/build/libactionfamily33.dylib')
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-33.1.oracle-', dir=SCRATCH))/'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    manifest_bytes = (ROOT/'work/analysis/hiff-resources.json').read_bytes()
    corpus_bytes = (PRIVATE/'A-33.1.corpus.json').read_bytes()
    require(sha(manifest_bytes) == MANIFEST_HASH and sha(corpus_bytes) == CORPUS_HASH, 'pinned manifest/corpus mismatch')
    manifest, corpus = json.loads(manifest_bytes), json.loads(corpus_bytes)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['resources_scanned'], corpus['scen_data_records'],
             corpus['scene_actions'], corpus['raw_0x33_records'], len(corpus['records'])) ==
            (ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 2267, 2078, 19612, 3, 3), 'corpus identity/count mismatch')
    resources = {}
    for row in manifest['resources']:
        i = int(row['index'])
        data = (ROOT/'work/analysis/hiff-resources'/f'{i:04d}.bin').read_bytes()
        require((len(data), sha(data)) == (row['size'], row['sha256']), f'resource mismatch: {i}')
        resources[i] = data
    require(len(resources) == 2267, 'resource coverage mismatch')
    pe = PEImage.parse_and_map(ROOT/'work/original/GAME.EXE')
    require(sha(pe.data) == EXE_HASH and len(pe.data) == 1511424, 'pinned executable mismatch')
    for start, end, digest in CODE:
        require(sha(pe.image[start-pe.image_base:end-pe.image_base]) == digest, f'code mismatch: {start:#x}')
    lib, machine, tail = load_native(args.native_library), Original(pe), OriginalTail()
    native = Native(lib)
    adapter = Native33(args.native_library)
    nh, oh, bh, th = (hashlib.sha256() for _ in range(4))
    object_bytes = 0
    tail_records = []
    for i, row in enumerate(corpus['records']):
        data = resources[row['resource_index']]
        p, size = row['act_payload_offset'], row['act_payload_length']
        payload = data[p:p+size]
        body, typed = payload[50:], row['typed_body_length']
        require((len(payload), payload[48], payload[49], row['raw_body_offset'], len(body), sha(body),
                 sha(body[:typed]), sha(body[typed:]), typed, len(body)-typed, (len(body)-typed)//16) ==
                (size, 0x33, row['subtype'], p+50, row['raw_body_length'], row['body_sha256'],
                 row['prefix_sha256'], row['dependency_tail_sha256'],
                 113+6*row['count_6d']+66*row['count_6f'], row['dependency_tail_length'],
                 row['dependency_tail_records']), f'corpus row mismatch: {i}')
        nimage, oimage, advance = compare(lib, machine, payload, f'corpus-{i}', seed_byte=(i*31+7)&255)
        # The expected typed extent for the tail stage is the ORIGINAL cursor
        # advance observed by running the loader, not a formula or the census.
        require(advance == typed, 'corpus boundary mismatch')
        nh.update(nimage); oh.update(oimage); bh.update(body); th.update(body[advance:])
        object_bytes += advance
        tail_records.append((payload, advance))
    synthetic = []
    pairs = ((0, 0), (1, 0), (0, 1), (4, 1), (0, 5), (2, 3),
             (5442, 0), (0, 494), (8, 494), (5431, 1), (200, 3), (3, 90))
    for i, (a, b) in enumerate(pairs):
        body = body_fixture(a, b, (0, 1, 2, 9)[i%4])
        payload = payload_for(body, (0, 1, 2, 255)[i%4])
        image, _, advance = compare(lib, machine, payload, f'synthetic-loader-{i}', seed_byte=i*19)
        offset = (0, 50, 0xfffffff0, 0xffffffff)[i%4]
        compare(lib, machine, payload, f'synthetic-arm-{i}', direct=True, offset=offset, seed_byte=0xcd)
        synthetic.append(dict(counts=[a,b], typed_length=advance, offset=offset, object_sha256=sha(image)))
    # Shared A-TAIL discipline: the original generic dependency loader 0x424aa8
    # for every corpus tail plus tails 0..300, 1023..1025, 4079..4097 and the
    # 256/65536/65537-record width rows, for the corpus prefix of each record;
    # native accept/reject, dependency_count and borrowed span against the original.
    tail_report = run_family(adapter, tail, tail_records)
    # Additional synthetic-loader prefixes (small and large counts) get the 0..40 sweep.
    extra_tail = 0
    for a, b in ((0, 0), (4, 1), (5442, 0), (8, 494)):
        for n in tuple(range(41)) + (4096, 4097, 16*256, 16*65536):
            compare_tail(adapter, tail, payload_for(body_fixture(a, b) + bytes(n)), 113 + 6*a + 66*b)
            extra_tail += 1
    probes = Original(pe)
    count_safety, short_cases = check_safety(lib, probes, native)
    report = dict(slice='A-33.1', scope='Track N loader/copy value model and original generic tail arithmetic; no runtime',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
            corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()), oracle_script_sha256=sha(Path(__file__).read_bytes()),
        shared_tail_oracle_sha256=sha((Path(__file__).parent/'tail_oracle_common.py').read_bytes()),
        corpus_records=3, corpus_object_bytes_compared=object_bytes, corpus_object_sha256=nh.hexdigest(),
        original_object_sha256=oh.hexdigest(), corpus_raw_bodies_sha256=bh.hexdigest(), corpus_dependency_tails_sha256=th.hexdigest(),
        original_constructor_calls=machine.allocations, full_loader_calls=machine.full_loaders,
        direct_arm_calls=machine.direct_arms, allocation_sizes=dict(machine.sizes), synthetic=synthetic,
        original_tail_calls=tail.calls, shared_tail_family_run=tail_report,
        extra_synthetic_prefix_tail_comparisons=extra_tail,
        tail_lengths=list(TAIL_LENGTHS), width_tail_bytes=list(WIDTH_TAILS),
        tail_empty_exit=hex(tail.exits[0]), tail_accept_exit=hex(tail.exits[1]), tail_fatal_exit=hex(tail.exits[2]),
        native_short_safety_cases=short_cases,
        original_allocation_arithmetic_probes=probes.probes, count_safety_cases=count_safety, mismatches=0,
        hooks=[dict(address=hex(ALLOCATOR), kind='replacement', purpose='malloc only: exact observed length, seeded object'),
            dict(range='0x20000000..0x2020001f', kind='observation', purpose='original reads inside exact ACT span'),
            dict(range=hex(OUT-16)+'..'+hex(OUT+MAX_OBJECT+15), kind='observation', purpose='object writes inside exact allocation'),
            dict(kind='replacement', boundaries=TAIL_HOOKS, purpose='shared generic-tail log only')],
        stop_boundaries=dict(loader=hex(BOUNDARY), unsafe_allocation_probe=hex(ALLOCATOR), generic_tail=TAIL_EXITS),
        original_decisions_replaced=False,
        deliberate_safety_rejections=['negative counts and any signed-16 size narrowing (original may wrap positive)',
            'short bodies, ragged tails, null/overlap/wrapped spans, zero handle, insufficient object capacity'],
        unverified=['allocation failure/fatal cleanup and nonzero diagnostics', 'runtime handler 0x42c221 and all descendants',
            'dependency opcode construction/evaluation after shared accept/empty stops', 'video/audio/render/host effects',
            'subtype lifecycle, parser/dispatcher/app integration', 'original C++ provenance, whole-file matching, native gameplay'],
        elapsed_seconds=round(time.monotonic()-started,3))
    with result_path.open('x') as f:
        json.dump(report,f,indent=2); f.write('\n')
    print(json.dumps(dict(corpus_records=3, original_constructor_calls=machine.allocations,
        tail_parity_comparisons=tail_report['parity_comparisons'], extra_tail=extra_tail,
        original_tail_calls=tail.calls, arithmetic_probes=probes.probes, object_bytes_compared=object_bytes,
        mismatches=0, result=str(result_path), result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
