#!/usr/bin/env python3
"""A-45.1 isolated original-x86 loader oracle; malloc is the sole replacement.

Use work/tools/oracle-python/bin/python with Unicorn JIT allowed.
Executes 0x424aa8 to its empty/accept/reject boundary for every corpus tail
and synthetic tails 0..40; does not execute dependency tree construction. No executable
is launched. Each report path is unique; original files are only read.
"""
import argparse
from collections import Counter
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import tempfile
import time

from cif_original_oracle import PEImage
from test_action_family_45 import Decoded, Constructed, body_fixture, load_native, storage

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '2f6c74bdba3cc31cb83c97786cdc71b4d37fb4422e257089f9fa4f6a6e20e7bd'
CODE = [(4240202, 4240646, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'), (4263076, 4263817, 'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'), (4248813, 4249258, '397b246829ed918990379a6144a5e587bc3fc5a04480cdcdf3c26ffc56e5ffbe'), (4262504, 4262570, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'), (4344488, 4344980, '3dea175ad43be94e993582562641213d1f7169205a4d7b65fe937b3c5a831311')]
INPUT = 0x20000000
OUT = 0x30000010
ACTION = 0x5bb5b3
SLOT = ACTION + 0x32
ALLOCATOR = 0x51dc43
BOUNDARY = 0x410aa5
DEPENDENCY_EXITS = {0x424c31: 'empty', 0x424c5b: 'reject', 0x424c94: 'accept'}
DEPENDENCY_OWNER = 0x30001000
HOOKS = {
    'code:0x51dc43': 'only replacement: guarded successful malloc(196 + 4*count), cdecl return',
    'read:0x20000000..0x2001ffff': 'observer only; reject reads outside exact ACT payload',
    'write:0x20000000..0x2001ffff': 'observer only; reject any input write',
    'write:0x30000000..0x30000fff': 'observer only; reject writes outside exact allocation',
    'code:0x40d502,0x40d589': 'observer stop for signed count decision, before diagnostics/allocation',
    'code:0x424c31,0x424c5b,0x424c94': 'observer stop after original empty/reject/accept decisions; no instruction replaced',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


class OracleError(RuntimeError):
    pass


def require(condition, message):
    if not condition:
        raise OracleError(message)


class Original:
    def __init__(self, pe):
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
        from unicorn import x86_const as x
        self.r = {name: getattr(x, 'UC_X86_REG_' + name) for name in
                  ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI', 'EBP', 'ESP', 'EIP', 'EFLAGS', 'ES')}
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, (pe.size_of_image + 4095) & ~4095)
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(0x1000, 0x10000)
        self.uc.mem_map(INPUT, 0x20000)
        self.uc.mem_map(OUT - 16, 0x2000)
        self.uc.reg_write(self.r['ES'], 0)
        self.count_stop = None
        self.dependency_calls = 0
        self.allocations = 0
        self.sizes = Counter()
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.read_input, begin=INPUT, end=INPUT + 0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_input, begin=INPUT, end=INPUT + 0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_object, begin=OUT - 16, end=OUT - 16 + 0xfff)

        for address in DEPENDENCY_EXITS:
            self.uc.hook_add(UC_HOOK_CODE, self.stop_dependency, begin=address, end=address)

        for address in (0x40d502, 0x40d589):
            self.uc.hook_add(UC_HOOK_CODE, self.stop_count, begin=address, end=address)

    def stop_count(self, uc, address, _size, _data):
        if address == self.count_stop:
            uc.emu_stop()

    def stop_dependency(self, uc, address, _size, _data):
        self.dependency_exit = DEPENDENCY_EXITS[address]
        self.dependency_stop = address
        uc.emu_stop()

    def allocate(self, uc, address, _size, _data):
        require(address == ALLOCATOR, 'unexpected replacement hook')
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        require(size == self.typed, f'original allocation size mismatch: {size}/{self.typed}')
        uc.mem_write(OUT - 16, b'\xa5' * 16 + bytes([self.seed]) * self.typed + b'\xd7' * 16)
        uc.reg_write(self.r['EAX'], OUT)
        uc.reg_write(self.r['ESP'], esp + 4)
        uc.reg_write(self.r['EIP'], ret)
        self.allocations += 1
        self.sizes[size] += 1

    def read_input(self, _uc, _access, address, size, _value, _data):
        require(INPUT + 16 <= address and address + size <= INPUT + 16 + self.input_size,
                'original read outside exact ACT payload')

    def write_input(self, _uc, _access, _address, _size, _value, _data):
        raise OracleError('original wrote input')

    def write_object(self, _uc, _access, address, size, _value, _data):
        require(OUT <= address and address + size <= OUT + self.typed, 'original wrote outside exact allocation')

    def invoke(self, payload, offset=50, inline=False, seed=0xCD):
        uc, r = self.uc, self.r
        require(len(payload) >= 246 and payload[48] == 0x45, 'invalid oracle fixture')
        require(b'\0' in payload[:48], 'oracle description must terminate inside header')
        require(len(payload) + 32 <= 0x20000, 'oracle fixture exceeds mapped input budget')
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'pinned diagnostic flag is nonzero')
        self.typed = 196 + 4 * struct.unpack_from('<h', payload, 50 + 194)[0]
        require(196 <= self.typed <= 236, 'unsafe original count')
        self.seed = seed
        self.input_size = len(payload)
        uc.mem_write(INPUT, b'\xa6' * 16 + payload + b'\xd6' * 16)
        uc.mem_write(0x5c39e3, bytes(2))  # caller state: fresh action slot zero
        initial_action = bytearray((i * 19 + seed) & 255 for i in range(0x8d))
        initial_action[0x3a:0x3e] = bytes(4)  # fresh slot: dependency tree absent
        uc.mem_write(ACTION - 16, b'\x91' * 16 + initial_action + b'\x92' * 16)
        stack = 0x5800
        args = struct.pack('<III', 0x51000000, INPUT + 16, len(payload))
        uc.mem_write(stack, args)
        uc.mem_write(stack - 0x1000, b'\x93' * 16)
        uc.mem_write(stack + 32, b'\x94' * 16)
        for name, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=0x33333333,
                                EDX=0x44444444, ESI=0x55555555, EDI=0x66666666,
                                EBP=0x77777777, ESP=stack, EFLAGS=0x202).items():
            uc.reg_write(r[name], value)
        body_va = INPUT + 16 + 50
        expected = bytearray(initial_action)
        if inline:
            # A direct basic-block entry is not a separate original function.
            # Supply the same caller frame, then execute the unchanged arm.
            frame = 0x7000
            uc.reg_write(r['EBP'], frame)
            uc.reg_write(r['ESP'], frame - 0x300)
            for address, value in ((frame - 0x20, body_va), (frame - 0xcc, offset),
                                   (frame - 0x108, 1), (frame - 0xf8, 1),
                                   (frame + 0xc, len(payload))):
                uc.mem_write(address, struct.pack('<I', value))
            expected[0x30:0x32] = payload[48:50]
            uc.mem_write(ACTION + 0x30, payload[48:50])
            entry = 0x40d4ed
        else:
            require(offset == 50, 'full loader starts at offset 50')
            name_end = payload.index(0, 0, 48) + 1
            expected[:name_end] = payload[:name_end]
            expected[0x30:0x32] = payload[48:50]
            entry = 0x40b34a
        before = self.allocations
        uc.emu_start(entry, BOUNDARY, count=100000)
        require(uc.reg_read(r['EIP']) == BOUNDARY and self.allocations == before + 1,
                'original failed to reach dependency handoff with one allocation')
        frame = uc.reg_read(r['EBP'])
        cursor = struct.unpack('<I', uc.mem_read(frame - 0x20, 4))[0]
        consumed = struct.unpack('<I', uc.mem_read(frame - 0xcc, 4))[0]
        forwarded = struct.unpack('<4I', uc.mem_read(uc.reg_read(r['ESP']), 16))
        require(forwarded == (ACTION, consumed, len(payload), cursor),
                'original dependency arguments do not reflect cursor/offset')
        expected[0x32:0x36] = struct.pack('<I', OUT)
        for address, data in ((INPUT, b'\xa6' * 16), (INPUT + 16, payload),
                              (INPUT + 16 + len(payload), b'\xd6' * 16),
                              (OUT - 16, b'\xa5' * 16), (OUT + self.typed, b'\xd7' * 16),
                              (ACTION - 16, b'\x91' * 16), (ACTION, bytes(expected)),
                              (ACTION + 0x8d, b'\x92' * 16), (stack, args),
                              (stack - 0x1000, b'\x93' * 16), (stack + 32, b'\x94' * 16)):
            require(bytes(uc.mem_read(address, len(data))) == data,
                    f'original action/input/stack/allocation guard mismatch at {address:#x}')
        image = bytes(uc.mem_read(OUT, self.typed))
        decision = None
        if not inline:
            decision = self.run_dependency(BOUNDARY)
            require(bytes(uc.mem_read(INPUT + 16, len(payload))) == payload, 'dependency decision changed input')
            require(bytes(uc.mem_read(OUT, self.typed)) == image, 'dependency decision changed object')
        return image, cursor - body_va, consumed, decision



    def run_dependency(self, entry):
        self.dependency_exit = None
        self.uc.emu_start(entry, 0x51000000, count=100000)
        require(self.dependency_exit is not None, 'original dependency loader missed decision exit')
        self.dependency_calls += 1
        count = struct.unpack('<I', self.uc.mem_read(ACTION + 0x6a, 4))[0]
        return self.dependency_exit != 'reject', count, self.dependency_stop

    def dependency(self, payload, typed):
        # Separate real function call; stop immediately after arithmetic decision,
        # before any dependency-row interpretation or allocation.
        uc, r = self.uc, self.r
        self.input_size = len(payload)
        uc.mem_write(INPUT, b'\xa6' * 16 + payload + b'\xd6' * 16)
        uc.mem_write(ACTION, bytes(0x8d))
        uc.mem_write(ACTION + 0x30, payload[48:50])
        uc.mem_write(DEPENDENCY_OWNER, bytes(0x620))
        stack = 0x9000
        uc.mem_write(stack, struct.pack('<5I', 0x51000000, ACTION, 50 + typed,
                                       len(payload), INPUT + 16 + 50 + typed))
        for name in ('EAX', 'EBX', 'EDX', 'ESI', 'EDI', 'EBP'):
            uc.reg_write(r[name], 0)
        uc.reg_write(r['ESP'], stack)
        uc.reg_write(r['ECX'], DEPENDENCY_OWNER)
        uc.reg_write(r['EFLAGS'], 0x202)
        return self.run_dependency(0x424aa8)

    def count_decision(self, count_bits):
        # Observe original signed comparison/narrowing without executing unsafe
        # malloc/copy paths or replacing diagnostics. No native parity claim for
        # negative-count construction.
        uc, r = self.uc, self.r
        body = bytes(194) + struct.pack('<H', count_bits)
        payload = bytes(48) + bytes([0x45, 1]) + body
        self.input_size = len(payload)
        uc.mem_write(INPUT + 16, payload)
        frame = 0x7000
        uc.reg_write(r['EBP'], frame); uc.reg_write(r['ESP'], frame - 0x300)
        uc.mem_write(frame - 0x20, struct.pack('<I', INPUT + 66))
        signed = count_bits if count_bits < 32768 else count_bits - 65536
        stop = 0x40d502 if signed > 10 else 0x40d589
        self.count_stop = stop
        uc.emu_start(0x40d4ed, 0x51000000, count=1000)
        self.count_stop = None
        require(uc.reg_read(r['EIP']) == stop, 'original count decision missed stop')
        if signed > 10:
            return dict(bits=count_bits, signed=signed, original_upper_bound_reject=True)
        product_bits = (signed * 4) & 65535
        product = product_bits if product_bits < 32768 else product_bits - 65536
        allocation_bits = (product + 196) & 65535
        allocation = allocation_bits if allocation_bits < 32768 else allocation_bits - 65536
        requested = uc.reg_read(r['EAX'])
        require(requested == allocation & 0xffffffff, 'original signed-narrow allocation mismatch')
        return dict(bits=count_bits, signed=signed, original_upper_bound_reject=False,
                    narrowed_suffix_bytes=product, allocation_argument=requested,
                    executed_allocation_or_copy=False)


def compare(lib, machine, payload, ordinal, offset=50, inline=False, seed=0xCD):
    body = payload[50:]
    raw = storage(body)
    d, native = Decoded(), Constructed()
    require(lib.action_family_45_decode(raw, len(body), C.byref(d)) == 0,
            f'native decoder rejected record {ordinal}')
    original, advance, consumed, dependency = machine.invoke(payload, offset, inline, seed)
    require(advance == len(original) and consumed == (offset + advance) & 0xffffffff,
            f'original body rule mismatch record {ordinal}')
    require((d.raw_type, d.runtime_type, d.entry_count) ==
            (payload[48], payload[48], struct.unpack_from('<H', original, 194)[0]),
            f'decoded type/count mismatch record {ordinal}')
    require(tuple(d.words) == struct.unpack_from('<97H', original),
            f'decoded neutral field mismatch record {ordinal}')
    for i in range(d.entry_count):
        require((d.entries[i].word_0, d.entries[i].word_1) ==
                struct.unpack_from('<HH', original, 196 + i * 4),
                f'decoded entry field mismatch record {ordinal}')
    tail_bytes = len(body) - advance
    require((d.dependency_records, d.body_bytes, d.available_body_bytes,
             d.dependency_bytes, d.dependency_count) ==
            (C.addressof(raw) + advance, advance, len(body), tail_bytes, tail_bytes // 16),
            f'decoded body/tail mismatch record {ordinal}')
    if dependency is not None:
        accepted, stored_count, _stop = dependency
        require(accepted and d.dependency_count == stored_count,
                f'original dependency decision/count mismatch record {ordinal}')
    require(lib.action_family_45_construct(raw, len(body), offset, OUT, C.byref(native)) == 0,
            f'native constructor rejected record {ordinal}')
    require(bytes(native.object_bytes)[:advance] == original,
            f'original/native object mismatch record {ordinal}')
    require(bytes(native.object_bytes)[advance:] == bytes(236 - advance),
            'native unused object capacity not neutral')
    require((native.body_bytes_consumed, native.payload_offset_before, native.payload_offset_after,
             native.dependency_records, native.dependency_count, native.dependency_bytes,
             native.available_body_bytes) ==
            (advance, offset, consumed, C.addressof(raw) + advance, tail_bytes // 16,
             tail_bytes, len(body)), f'original/native cursor/tail mismatch record {ordinal}')
    require((native.output_handle, native.result_slot_handle, native.output_allocation_bytes) ==
            (OUT, OUT, advance), f'original/native slot/constants mismatch record {ordinal}')
    require(bytes(raw)[:len(body)] == body, 'native modified input')
    return bytes(native.object_bytes)[:advance], original


def rejected(lib, body, expected, label):
    # Padding is outside the advertised span and permits guard mutation checks
    # without crashing Python. The sanitizer independently uses exact-size heaps.
    raw = storage(body + bytes(236))
    for cls in (Decoded, Constructed):
        out = cls(); C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
        call = lib.action_family_45_decode if cls is Decoded else lib.action_family_45_construct
        args = (raw, len(body), C.byref(out)) if cls is Decoded else (raw, len(body), 50, OUT, C.byref(out))
        require(call(*args) == expected, f'native safety {label} mismatch')
        require(bytes(out) == before, f'native safety {label} mutated output')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--native-library', type=Path,
                    default=ROOT / 'outputs/blackmoor-decomp/build/libactionfamily45.dylib')
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-45.1.oracle-', dir=PRIVATE)) / 'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    mb = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE / 'A-45.1.corpus.json').read_bytes()
    require((sha(mb), sha(cb)) == (MANIFEST_HASH, CORPUS_HASH), 'pinned manifest/corpus hash mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['raw_0x45_records'], len(corpus['records']),
             corpus['scene_actions'], corpus['scen_data_records']) ==
            (ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 32, 32, 19612, 2078),
            'input identity/count mismatch')
    resources = {}
    for row in manifest['resources']:
        index = int(row['index'])
        data = (ROOT / 'work/analysis/hiff-resources' / f'{index:04d}.bin').read_bytes()
        require((len(data), sha(data)) == (row['size'], row['sha256']), f'resource mismatch: {index}')
        resources[index] = data
    require(len(resources) == 2267, 'resource coverage mismatch')
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    require(sha(pe.data) == EXE_HASH and len(pe.data) == 1511424, 'executable mismatch')
    for start, end, digest in CODE:
        require(sha(pe.image[start - pe.image_base:end - pe.image_base]) == digest,
                f'code window mismatch: {start:#x}')
    machine, lib = Original(pe), load_native(args.native_library)
    native_hash, original_hash, bodies, tails = [hashlib.sha256() for _ in range(4)]
    corpus_object_bytes = 0
    for ordinal, row in enumerate(corpus['records']):
        data = resources[row['resource_index']]
        p, n = row['act_payload_offset'], row['act_payload_length']
        payload = data[p:p + n]; body = payload[50:]
        count = struct.unpack_from('<h', body, 194)[0]; typed = 196 + 4 * count
        require((row['raw_body_offset'], row['raw_body_length'], row['body_sha256'],
                 payload[48], payload[49], row['typed_body_length'], row['dependency_tail_records'],
                 row['dependency_tail_length'], row['body_count'], row['prefix_sha256'],
                 row['dependency_tail_sha256']) ==
                (p + 50, len(body), sha(body), 0x45, row['subtype'], typed, (len(body) - typed) // 16,
                 len(body) - typed, count, sha(body[:typed]), sha(body[typed:])),
                f'corpus row mismatch: {ordinal}')
        native, original = compare(lib, machine, payload, ordinal, seed=(ordinal * 31 + 7) & 255)
        require(len(original) == typed, 'corpus cursor rule mismatch')
        native_hash.update(native); original_hash.update(original)
        bodies.update(body); tails.update(body[typed:]); corpus_object_bytes += len(original)
    synthetic_hash = hashlib.sha256()
    # All valid count values, all subtype bytes, nonzero neutral fields, empty
    # and large tails, prior heap seeds and direct-arm DWORD offset wrap.
    for subtype in range(256):
        count = subtype % 11; tail = (0, 1, 2, 255)[subtype % 4]
        payload = b'synthetic' + bytes(39) + bytes([0x45, subtype]) + body_fixture(count, tail, subtype)
        for inline in (False, True):
            offset = (0, 50, 0xfffffffe, 0xffffffff)[subtype % 4] if inline else 50
            native, _ = compare(lib, machine, payload, f'synthetic-{subtype}-{inline}',
                                offset, inline, seed=subtype ^ 0xA5)
            synthetic_hash.update(native)
    decisions = []
    # The original function, rather than a Python modulus substitute, decides
    # accept/reject and writes the compared dependency count at action+0x6a.
    for count in (0, 1, 10):
        typed = 196 + 4 * count
        for tail_length in range(41):
            body = body_fixture(count) + bytes((i * 7 + 3) & 255 for i in range(tail_length))
            payload = b'tail-fixture' + bytes(36) + bytes([0x45, 1]) + body
            accepted, stored_count, stop = machine.dependency(payload, typed)
            raw, d, c = storage(body), Decoded(), Constructed()
            C.memset(C.byref(d), 0xa5, C.sizeof(d)); before_d = bytes(d)
            C.memset(C.byref(c), 0x5a, C.sizeof(c)); before_c = bytes(c)
            status = lib.action_family_45_decode(raw, len(body), C.byref(d))
            constructed_status = lib.action_family_45_construct(raw, len(body), 50, OUT, C.byref(c))
            require((status == 0) == accepted and constructed_status == status,
                    f'original dependency accept/reject mismatch count={count} tail={tail_length}')
            if accepted:
                require((d.body_bytes, d.dependency_count, c.body_bytes_consumed, c.dependency_count) ==
                        (typed, stored_count, typed, stored_count), 'original dependency count/body mismatch')
            else:
                require(status == 4 and bytes(d) == before_d and bytes(c) == before_c,
                        'native rejected tail status/mutation mismatch')
            decisions.append(dict(body_count=count, tail_bytes=tail_length, accepted=accepted,
                                  original_stored_count=stored_count, original_stop=hex(stop)))
    safety_count = 0
    for n in range(196):
        rejected(lib, body_fixture()[:n], 2, 'short body'); safety_count += 1
    for count in range(1, 11):
        for n in range(196, 196 + 4 * count):
            rejected(lib, body_fixture(count)[:n], 2, 'short body'); safety_count += 1
    invalid_counts = (11, 12, 49, 8191, 8192, 0x7fff, 0x8000, 0xffce, 0xffff)
    count_decisions = []
    for bits in invalid_counts:
        rejected(lib, body_fixture()[:194] + struct.pack('<H', bits), 3, 'invalid count')
        count_decisions.append(machine.count_decision(bits)); safety_count += 1
    report = dict(slice='A-45.1', status='pass',
        scope='successful inline loader and dependency arithmetic decisions; dependency tree/runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()), corpus_records=32,
        corpus_object_bytes_compared=corpus_object_bytes, original_constructor_calls=machine.allocations,
        full_loader_calls=32 + 256, direct_inline_arm_calls=256,
        synthetic_valid_constructor_calls=512, mismatches=0,
        original_dependency_calls=machine.dependency_calls, dependency_synthetic_cases=len(decisions),
        dependency_decisions=decisions, invalid_count_original_decisions=count_decisions,
        native_only_safety_rejections=safety_count, allocation_sizes=dict(machine.sizes),
        corpus_object_sha256=native_hash.hexdigest(), original_object_sha256=original_hash.hexdigest(),
        synthetic_object_sha256=synthetic_hash.hexdigest(), corpus_raw_bodies_sha256=bodies.hexdigest(),
        corpus_dependency_tails_sha256=tails.hexdigest(), hooks=HOOKS,
        original_decisions_replaced=False, stop_boundaries=[hex(BOUNDARY)] + [hex(x) for x in DEPENDENCY_EXITS],
        deliberate_safety_rejections=['short prefix/suffix; negative or >10 count; fractional tail',
                                     'null/overlap/wrapped spans/zero handle (native suite)',
                                     'original negatives only observed before allocation, not construction parity'],
        unverified=['allocation failure/fatal diagnostics', 'nonzero diagnostic flag',
                    'previous action-slot reuse', 'dependency tree construction/evaluation after arithmetic decision',
                    'runtime/timer/lifecycle/render/host effects', 'live subtype behavior beyond preservation',
                    'original C++ provenance/whole-file matching/native gameplay'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(corpus_records=32, constructor_calls=machine.allocations,
                         dependency_calls=machine.dependency_calls, mismatches=0,
                         corpus_object_bytes=corpus_object_bytes, result=str(result_path),
                         result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
