#!/usr/bin/env python3
"""Immutable x86 raw0c loader/inline copy and original generic tail parity.

Only allocation and ragged-tail logging are replaced. Unique private reports;
requires work/tools/oracle-python/bin/python with Unicorn JIT permitted.
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
from cif_original_oracle import PEImage
from test_action_family_0c import Decoded, Constructed, Record18, body_fixture, load_native, pointer, storage
from tail_oracle_common import (OriginalTail, compare_tail, check_short_body,
                                HOOKS as TAIL_HOOKS, EXIT_POINTS, UNVERIFIED as TAIL_UNVERIFIED)

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '6bb491e9ba0b735e8c69f61e5505912c137d7bfb515c1de2fedd0701fe4d6c39'
CODE = [
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x410ca4, 0x410f89, 'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'),
    (0x40bafd, 0x40bbed, '08363cb53f8da289a2afd3849a14063e336cd67a094c506b4bb82474b9e47f0e'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
]
INPUT, DATA, STACK, FRAME = 0x20000000, 0x30000000, 0x9800, 0x7800
ACTION, SLOT, OUT = 0x5bb5b3, 0x5bb5e5, DATA + 0x5000
BOUNDARY, ALLOCATOR, STOP = 0x410a68, 0x51dc43, 0x51000000
INPUT_CAPACITY = 0x220000


class OracleError(RuntimeError):
    pass


class ParityMismatch(AssertionError):
    pass


def require(condition, message):
    if not condition: raise OracleError(message)


def parity(condition, message):
    if not condition: raise ParityMismatch(message)


def sha(data):
    return hashlib.sha256(data).hexdigest()


class Original:
    def __init__(self, pe):
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE, UC_PROT_READ
        from unicorn import x86_const as x
        self.r = {n: getattr(x, 'UC_X86_REG_' + n) for n in
                  ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI', 'EBP', 'ESP', 'EIP', 'EFLAGS', 'ES')}
        uc = self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        uc.mem_map(pe.image_base, (pe.size_of_image + 4095) & ~4095)
        uc.mem_write(pe.image_base, pe.image)
        uc.mem_map(0x1000, 0x10000)
        uc.mem_map(INPUT, INPUT_CAPACITY, UC_PROT_READ)
        uc.mem_map(DATA, 0x20000)
        self.allocations = self.probes = 0
        self.sizes = Counter()
        self.source_span = (0, 0)
        self.size = 0
        self.probe = False
        uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        uc.hook_add(UC_HOOK_MEM_READ, self.observe_read, begin=INPUT, end=INPUT + INPUT_CAPACITY - 1)
        uc.hook_add(UC_HOOK_MEM_WRITE, self.observe_write, begin=OUT - 16, end=OUT + 32752 + 16)

    def observe_read(self, _uc, _access, address, size, _value, _data):
        require(self.source_span[0] <= address and address + size <= self.source_span[1],
                f'original source read outside exact ACT extent at {address:#x}')

    def observe_write(self, _uc, _access, address, size, _value, _data):
        require(OUT <= address and address + size <= OUT + self.size,
                f'original allocation write outside requested size at {address:#x}')

    def allocate(self, uc, address, _size, _data):
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        require(address == ALLOCATOR and ret == 0x40bb2a, 'unexpected allocation caller')
        if self.probe:
            # Observer only: execute original arithmetic, stop before malloc.
            self.probed_size = size
            self.probes += 1
            uc.emu_stop()
            return
        require(size == self.size and 10 <= size <= 32752, 'original allocation size mismatch')
        uc.mem_write(OUT - 16, b'\xa5' * 16 + self.seed + b'\xd7' * 16)
        uc.reg_write(self.r['EAX'], OUT)
        uc.reg_write(self.r['ESP'], esp + 4)
        uc.reg_write(self.r['EIP'], ret)  # cdecl: original caller removes size
        self.allocations += 1
        self.sizes[size] += 1

    def invoke(self, payload, offset=50, inline=False, seed_byte=0xcd, probe=False):
        uc, r = self.uc, self.r
        require(len(payload) + 32 < INPUT_CAPACITY and len(payload) >= 60, 'invalid oracle fixture extent')
        count = struct.unpack_from('<h', payload, 58)[0]
        narrowed = (10 + count * 18) & 0xffff
        self.size = narrowed if narrowed < 0x8000 else narrowed - 0x10000
        self.probe = probe
        if not probe: require(0 <= count <= 1819 and len(payload) >= 50 + self.size, 'unsafe constructor fixture')
        self.seed = bytes([seed_byte]) * max(0, self.size)
        image = b'\xa6' * 16 + payload + b'\xd6' * 16
        uc.mem_write(INPUT, image)
        self.source_span = (INPUT + 16, INPUT + 16 + len(payload))
        body_va = INPUT + 16 + 50
        row = bytes(0x8d)
        uc.mem_write(ACTION - 16, b'\x91' * 16 + row + b'\x92' * 16)
        uc.mem_write(0x5c39e3, bytes(2))
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'nonzero original diagnostics flag')
        owner = DATA + 0x1000
        uc.mem_write(owner, b'\x5a' * 256)
        if inline:
            uc.mem_write(ACTION + 48, payload[48:50])
            uc.mem_write(FRAME - 0x20, struct.pack('<I', body_va))
            uc.mem_write(FRAME - 0xcc, struct.pack('<I', offset))
        args = struct.pack('<3I', STOP, INPUT + 16, len(payload))
        uc.mem_write(STACK, args)
        uc.mem_write(STACK - 0x1000, b'\x93' * 16)
        uc.mem_write(STACK + 32, b'\x94' * 16)
        for name, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=owner,
                                EDX=0x44444444, ESI=0x55555555, EDI=0x66666666,
                                EBP=FRAME if inline else 0x77777777, ESP=STACK, EFLAGS=0x202, ES=0).items():
            uc.reg_write(r[name], value)
        before = self.allocations
        uc.emu_start(0x40bafd if inline else 0x40b34a, BOUNDARY, count=1000000)
        if probe:
            require(uc.reg_read(r['EIP']) == ALLOCATOR, 'size observer did not stop at malloc')
            return self.probed_size
        require(uc.reg_read(r['EIP']) == BOUNDARY and self.allocations == before + 1,
                'original did not reach body boundary after one allocation')
        frame = uc.reg_read(r['EBP'])
        cursor = struct.unpack('<I', uc.mem_read(frame - 0x20, 4))[0]
        consumed = struct.unpack('<I', uc.mem_read(frame - 0xcc, 4))[0]
        expected = bytearray(row)
        if not inline:
            name_bytes = payload[:48].index(0) + 1
            expected[:name_bytes] = payload[:name_bytes]
        expected[48:50] = payload[48:50]  # raw0c stays runtime0c, subtype retained
        expected[50:54] = struct.pack('<I', OUT)
        guards = [(INPUT, image), (OUT - 16, b'\xa5' * 16), (OUT + self.size, b'\xd7' * 16),
                  (ACTION - 16, b'\x91' * 16), (ACTION, bytes(expected)), (ACTION + 0x8d, b'\x92' * 16),
                  (owner, b'\x5a' * 256), (STACK, args), (STACK - 0x1000, b'\x93' * 16), (STACK + 32, b'\x94' * 16)]
        for address, value in guards:
            require(bytes(uc.mem_read(address, len(value))) == value, f'original guard/effect mismatch at {address:#x}')
        return bytes(uc.mem_read(OUT, self.size)), cursor - body_va, consumed


class NativeTailView:
    family = '0c'
    def __init__(self, lib): self.lib = lib
    def invoke(self, body, length=None):
        raw = storage(body); d = Decoded()
        C.memset(C.byref(d), 0xa5, C.sizeof(d)); before = bytes(d)
        status = self.lib.action_family_0c_decode(raw, len(body) if length is None else length, C.byref(d))
        return status, d, raw, before


def compare(lib, machine, payload, ordinal, offset=50, inline=False, seed=0xcd):
    body = payload[50:]; raw = storage(body); d = Decoded(); out = Constructed(); size = C.c_size_t()
    original, advance, consumed = machine.invoke(payload, offset, inline, seed)
    parity(lib.action_family_0c_decode(raw, len(body), C.byref(d)) == 0, f'native decoder rejected record {ordinal}')
    parity(lib.action_family_0c_body_length(raw, len(body), C.byref(size)) == 0 and size.value == advance,
           f'body_length cursor mismatch record {ordinal}')
    parity((list(d.words), d.count_18) == (list(struct.unpack_from('<4H', original)),
                                          struct.unpack_from('<h', original, 8)[0]), 'decoded prefix field mismatch')
    parity((pointer(d.records_18), pointer(d.dependency_records), d.body_bytes,
            d.available_body_bytes, d.dependency_bytes, d.dependency_count, d.raw_type, d.runtime_type) ==
           (C.addressof(raw) + 10, C.addressof(raw) + advance, advance,
            len(body), len(body) - advance, (len(body) - advance) // 16, 12, 12), 'decoded field/view mismatch')
    for index in range(d.count_18):
        row = Record18()
        parity(lib.action_family_0c_record18_at(raw, len(body), index, C.byref(row)) == 0 and
               list(row.words) == list(struct.unpack_from('<9H', original, 10 + 18 * index)), 'decoded record field mismatch')
    image = storage(bytes([seed]) * advance)
    parity(lib.action_family_0c_construct(raw, len(body), offset, OUT, image, advance, C.byref(out)) == 0,
           'native constructor rejected record')
    parity(bytes(image) == original, 'whole original/native object mismatch')
    parity((out.body_bytes_consumed, out.allocation_bytes, out.payload_offset_before,
            out.payload_offset_after, out.result_slot_handle, out.raw_type, out.runtime_type,
            pointer(out.dependency_records), out.dependency_count, out.dependency_bytes, out.available_body_bytes) ==
           (advance, advance, offset, consumed, OUT, 12, 12, C.addressof(raw) + advance,
            (len(body) - advance) // 16, len(body) - advance, len(body)), 'constructor field/constants mismatch')
    require(consumed == (offset + advance) & 0xffffffff, 'original DWORD offset rule mismatch')
    require(bytes(raw) == body, 'native changed source')
    return bytes(image), original, advance


def run(args):
    started = time.monotonic()
    mb = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE / 'A-0C.1.corpus.json').read_bytes()
    require((sha(mb), sha(cb)) == (MANIFEST_HASH, CORPUS_HASH), 'pinned manifest/corpus mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['exe_sha256'], corpus['manifest_sha256'],
             corpus['archive_sha256'], corpus['resources_scanned'], corpus['scen_data_records'],
             corpus['scene_actions'], len(corpus['records'])) ==
            (ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, ARCHIVE_HASH, 2267, 2078, 19612, 43), 'corpus identity/count mismatch')
    resources = {}
    for row in manifest['resources']:
        index = int(row['index'])
        data = (ROOT / 'work/analysis/hiff-resources' / f'{index:04d}.bin').read_bytes()
        require((len(data), sha(data)) == (row['size'], row['sha256']), f'resource mismatch {index}')
        resources[index] = data
    require(len(resources) == 2267, 'resource coverage mismatch')
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    require(len(pe.data) == 1511424 and sha(pe.data) == EXE_HASH, 'executable mismatch')
    for a, b, h in CODE: require(sha(pe.image[a-pe.image_base:b-pe.image_base]) == h, 'code window mismatch')
    lib = load_native(args.native_library)
    machine, tail, native_tail = Original(pe), OriginalTail(), NativeTailView(lib)
    hashes = {k: hashlib.sha256() for k in ('native_object', 'original_object', 'bodies', 'tails', 'tail_exits')}
    payloads = []; object_bytes = 0; exits = Counter()
    def remember(result):
        exits[hex(result.exit_address)] += 1
        hashes['tail_exits'].update(struct.pack('<II', result.exit_address, result.count))
    for ordinal, row in enumerate(corpus['records']):
        p, n = row['act_payload_offset'], row['act_payload_length']
        payload = resources[row['resource_index']][p:p+n]; body = payload[50:]
        typed = row['typed_body_length']
        require((len(payload), payload[48], payload[49], row['raw_body_offset'], len(body), sha(body),
                 sha(body[:10]), sha(body[10:typed]), sha(body[typed:]), len(body)-typed,
                 (len(body)-typed)//16, struct.unpack_from('<h', body, 8)[0]) ==
                (n, 12, row['subtype'], p+50, row['raw_body_length'], row['body_sha256'],
                 row['prefix_sha256'], row['record_table_sha256'], row['dependency_tail_sha256'],
                 row['dependency_tail_length'], row['dependency_tail_records'], row['count_18']), 'corpus row mismatch')
        # Compare the stored original tail count before constructor metadata.
        remember(compare_tail(native_tail, tail, payload, typed))
        image, original, advance = compare(lib, machine, payload, ordinal, seed=(ordinal * 31 + 7) & 255)
        parity(advance == typed, 'corpus typed boundary mismatch')
        hashes['native_object'].update(image); hashes['original_object'].update(original)
        hashes['bodies'].update(body); hashes['tails'].update(body[typed:]); object_bytes += advance
        payloads.append((payload, advance))
    synthetic = []; synthetic_bytes = 0
    for i, count in enumerate((0, 1, 2, 3, 20, 100, 1818, 1819)):
        body = body_fixture(count, i % 3); subtype = (0, 1, 2, 255)[i % 4]
        payload = b'synthetic' + bytes(39) + bytes([12, subtype]) + body
        for inline in (False, True):
            offset = (0, 50, 0xfffffff6, 0xffffffff)[i % 4] if inline else 50
            image, _, advance = compare(lib, machine, payload, f'synthetic-{i}-{inline}', offset, inline, seed=i ^ 0xa5)
            synthetic_bytes += advance
        synthetic.append(dict(count_18=count, subtype=subtype, inline_offset=offset, object_sha256=sha(image)))
    lengths = tuple(range(41)) + (63, 64, 65, 256, 257, 4096, 65536 * 16)
    synthetic_tails = short_checks = 0
    pattern = bytes((i * 37 + 11) & 255 for i in range(max(lengths)))
    for payload, typed in payloads:
        prefix = payload[:50+typed]
        for n in lengths:
            remember(compare_tail(native_tail, tail, prefix + pattern[:n], typed)); synthetic_tails += 1
            if n % 16 == 0:
                raw = storage(prefix[50:] + pattern[:n]); size = C.c_size_t()
                parity(lib.action_family_0c_body_length(raw, len(raw), C.byref(size)) == 0 and size.value == typed,
                       'body_length tail cursor mismatch')
        for logical in sorted({0, 9, typed-1, max(0, typed-16)}):
            check_short_body(native_tail, tail, prefix, typed, logical); short_checks += 1
            raw = storage(prefix[50:]); size = C.c_size_t(0xa5a5)
            parity(lib.action_family_0c_body_length(raw, logical, C.byref(size)) == 2 and size.value == 0xa5a5,
                   'body_length short-body safety mismatch')
    narrowing = []
    for bits, expected in ((1820, 0xffff8002), (3641, 12), (32767, 0xfffffff8), (32768, 10), (65535, 0xfffffff8)):
        body = bytearray(body_fixture(0)); struct.pack_into('<H', body, 8, bits)
        payload = b'safety' + bytes(42) + bytes([12, 1]) + body
        observed = machine.invoke(payload, probe=True)
        require(observed == expected, 'original signed size narrowing mismatch')
        status, d, raw, before = native_tail.invoke(bytes(body))
        parity(status == 4 and bytes(d) == before, 'native invalid-count safety mismatch')
        narrowing.append(dict(count_word_bits=bits, original_malloc_size_dword=observed, native_status=status))
    for a, b, h in CODE: require(sha(machine.uc.mem_read(a, b-a)) == h, 'emulated original code changed')
    return dict(slice='A-0C.1', status='pass', scope='body decoder/copy allocation and generic tail boundary only',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=CODE),
        corpus_records=43, corpus_object_bytes_compared=object_bytes, synthetic_object_bytes_compared=synthetic_bytes,
        synthetic_cases=synthetic, synthetic_constructor_calls=16, constructor_calls=machine.allocations,
        narrowing_observer_calls=machine.probes, narrowing_safety_checks=narrowing,
        tail_corpus_comparisons=43, tail_synthetic_comparisons=synthetic_tails, tail_lengths=list(lengths),
        native_short_body_checks=short_checks, tail_calls=tail.calls, tail_exit_counts=dict(exits),
        original_calls=machine.allocations + machine.probes + tail.calls, mismatches=0,
        hashes={k: v.hexdigest() for k,v in hashes.items()},
        native_library_sha256=sha(args.native_library.read_bytes()),
        source_sha256=sha((ROOT/'outputs/blackmoor-decomp/src/action_family_0c.c').read_bytes()),
        header_sha256=sha((ROOT/'outputs/blackmoor-decomp/src/action_family_0c.h').read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        tail_helper_sha256=sha((Path(__file__).parent/'tail_oracle_common.py').read_bytes()),
        hooks=[dict(address=hex(ALLOCATOR),kind='allocation replacement',purpose='cdecl malloc, original requested size, seeded exact guarded extent; size probes observe only'),
               dict(range='input mapping',kind='observation',purpose='source reads within exact ACT extent; input mapped read-only'),
               dict(range='object mapping',kind='observation',purpose='writes within original requested allocation')],
        tail_hooks=TAIL_HOOKS, tail_exit_points=EXIT_POINTS,
        stop_boundaries=[hex(BOUNDARY),hex(ALLOCATOR)], original_decisions_replaced=False,
        allocation_sizes=dict(machine.sizes),
        deliberate_safety_rejections=['negative count or narrowed-size wrap: separate native policy, size observed before original malloc',
            'short typed body including unsigned original tail underflow: native BODY status, no malformed constructor parity claimed',
            'null, overlap, address wrap, zero model handle, insufficient output capacity'],
        unverified=['allocation failure/fatal cleanup', 'nonzero diagnostics flag', 'prior action slot reuse',
            'dependency opcode construction/evaluation beyond accept/reject/empty split',
            'runtime/lifecycle, rendering/host effects, subtype behavior beyond loader preservation',
            'parser/dispatcher integration, independent review, whole-file x86 match, playable native game'],
        tail_unverified=TAIL_UNVERIFIED, elapsed_seconds=round(time.monotonic()-started,3))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--native-library', type=Path, default=ROOT/'outputs/blackmoor-decomp/build/libactionfamily0c.dylib')
    parser.add_argument('--result', type=Path)
    args = parser.parse_args()
    path = args.result or Path(tempfile.mkdtemp(prefix='A-0C.1.oracle-',dir=PRIVATE))/'report.json'
    require(not path.exists(), 'result path must be unique')
    result = run(args)
    with path.open('x') as out: out.write(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('status','corpus_records','constructor_calls','tail_calls','original_calls','mismatches')} | dict(result=str(path),sha256=sha(path.read_bytes()))))


if __name__ == '__main__': main()
