#!/usr/bin/env python3
"""Original-backed generic dependency-tail stage for nine native decoders.

Run with work/tools/oracle-python/bin/python and Unicorn JIT permitted:
    .../python outputs/blackmoor-decomp/tests/tail_oracle_common.py

Enter immutable 0x424aa8 with the previously validated typed-body extent.
Observe empty/accepted exits BEFORE dependency opcode/tree construction; on a
ragged tail execute the original diagnostic call and branch to fatal cleanup.
The only replacement is the printf-like logging boundary. Unicorn exit points
observe original decisions; no original instruction or branch is substituted.
This is a behavioral oracle, not reconstructed source or byte-match coverage.
"""
from __future__ import annotations

import argparse
from collections import Counter
import ctypes as C
from dataclasses import asdict, dataclass
import hashlib
import importlib
import json
import os
from pathlib import Path
import struct
import subprocess
import sys
import tempfile
import time

sys.dont_write_bytecode = True
from cif_original_oracle import PEImage, OracleError

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / 'outputs/blackmoor-decomp'
SOURCE = PROJECT / 'src'
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CODE_START, CODE_END = 0x424aa8, 0x425b8b
CODE_HASH = 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'
# Pinned private corpora from the independently reviewed body-boundary slices.
FAMILIES = {
    '35': (113, '1dc946bf742b3e64bf0b7823629a8001840b51aaae79f0709811928a8dd23617'),
    '38': (425, 'fadff73b78ac68cd5fa8896d484e2928fe5b9fcc9a551e2e46cf9937f51df353'),
    '3f': (493, '6c879d935c4132d21ee26095aedd4c15e50d3a4769c6cc5bec80b70f54f4cd48'),
    '3e': (202, 'c364ac6f03043b1194de9aca27b6cfbc217aaed0cad89ca4426ffc78b7d15212'),
    '6e': (68, '2137a7f57c49247aee0a045c0c0f3080ccb75846211f3c10911b9ba582f0eca8'),
    '79': (38, 'd4fa3f9bafb5da4b59b297c82f08991d16ca720d0090bcc2a45eabc6ae53dfbd'),
    '67': (27, 'f26ae1990be86ec635f8e2ce046593050ee52d556cbc04e97f1c8f2ff56e0829'),
    '6f': (25, '845573a98968ff9138a090544844deb05e94b13c1b500a812d5ad511640e5a3c'),
    '43': (13, '2d95f4bc387a6ada1261dc94bd3ea8c60fac55a27bd69edc3de9d8d4f0c0b284'),
}
TAIL_LENGTHS = tuple(range(49)) + (63, 64, 65, 255, 256, 257, 1023, 1024)
WIDTH_TAILS = (256 * 16, 65536 * 16)
ACTION, OWNER = 0x5bb5b3, 0x63786d
INPUT, INPUT_CAPACITY = 0x20000000, 0x200000
STACK, RETURN = 0x9000, 0x51000000
EMPTY_EXIT, ACCEPT_EXIT, FATAL_EXIT = 0x424c0d, 0x424c94, 0x52139c
LOG_BOUNDARY = 0x50ca3e
HOOKS = {
    'code:0x50ca3e': 'only replacement: validate/record ragged-tail log arguments; cdecl return, ignored EAX=0',
}
EXIT_POINTS = {
    hex(EMPTY_EXIT): 'observer: empty-tail branch reached, count initialized to zero',
    hex(ACCEPT_EXIT): 'observer: modulus accepted, original DWORD count stored; before opcode scan',
    hex(FATAL_EXIT): 'observer: original ragged diagnostic and fatal branch executed; stop before cleanup',
}
UNVERIFIED = [
    'prior slot reuse: [row+0x3a] != 0 at 0x424bd6 (fresh zero slot only)',
    '0x12/0x13 pairing and all dependency opcode/tree construction at 0x424cf4..0x424e93 and later',
    'allocation failure, fatal cleanup effects at 0x52139c/0x4c97b4, nonzero diagnostics flag',
    'malformed typed-body original loader behavior; native short-body status is a safety contract',
    'caller typed-body recovery is supplied by reviewed family slices, not rerun in this direct-entry stage',
    'dependency evaluation, runtime/lifecycle/gameplay, whole-file x86 matching',
]


def sha(data):
    return hashlib.sha256(data).hexdigest()


def require(condition, message):
    if not condition:
        raise OracleError(message)


def write_json(path, value):
    # Exclusive creation also protects explicit caller-selected report paths.
    with Path(path).open('x') as output:
        json.dump(value, output, indent=2)
        output.write('\n')


def new_run(label):
    return Path(tempfile.mkdtemp(prefix=f'A-TAIL.1.{label}-', dir=PRIVATE))


class TailMismatch(AssertionError):
    """A successfully executed original disagrees with native behavior."""


@dataclass(frozen=True)
class TailResult:
    exit_address: int
    accepted: bool
    count: int
    logs: tuple


class OriginalTail:
    def __init__(self):
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_PROT_READ
        from unicorn import x86_const as x
        pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
        require(len(pe.data) == 1511424 and sha(pe.data) == EXE_HASH, 'pinned GAME.EXE mismatch')
        require(sha(pe.image[CODE_START - pe.image_base:CODE_END - pe.image_base]) == CODE_HASH,
                'pinned generic loader code mismatch')
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.r = {n: getattr(x, 'UC_X86_REG_' + n) for n in
                  ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI', 'EBP', 'ESP', 'EIP', 'EFLAGS', 'ES')}
        uc = self.uc
        uc.mem_map(pe.image_base, (pe.size_of_image + 4095) & ~4095)
        uc.mem_write(pe.image_base, pe.image)
        uc.mem_map(0x1000, 0x10000)
        uc.mem_map(INPUT, INPUT_CAPACITY + 0x1000, UC_PROT_READ)
        uc.reg_write(self.r['ES'], 0)
        # Exit points stop before the instruction at that address. They do not
        # rewrite the image or choose a branch, and need no internal code hooks.
        uc.ctl_exits_enabled(True)
        uc.ctl_set_exits([EMPTY_EXIT, ACCEPT_EXIT, FATAL_EXIT])
        uc.hook_add(UC_HOOK_CODE, self.log, begin=LOG_BOUNDARY, end=LOG_BOUNDARY)
        self.calls = 0

    def log(self, uc, address, _size, _user):
        r = self.r
        esp = uc.reg_read(r['ESP'])
        args = struct.unpack('<8I', uc.mem_read(esp, 32))
        ret, destination, fmt, _scene, family, count, length, consumed = args
        require(address == LOG_BOUNDARY and (ret, destination, fmt) ==
                (0x424c8c, 0x63888b, 0x544b30), 'unexpected logging boundary/caller')
        require((family, count, length, consumed) ==
                (self.family, self.expected_count, self.length, self.consumed),
                'original ragged diagnostic arguments mismatch')
        self.logs.append(args)
        uc.reg_write(r['EAX'], 0)  # no later original decision uses this return
        uc.reg_write(r['ESP'], esp + 4)
        uc.reg_write(r['EIP'], ret)

    def invoke(self, payload, typed_length):
        require(50 <= len(payload) <= INPUT_CAPACITY, 'ACT outside oracle input budget')
        require(0 < typed_length <= INPUT_CAPACITY and 50 + typed_length <= 0xffffffff,
                'invalid previously validated typed extent')
        uc, r = self.uc, self.r
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'nonzero diagnostic flag')
        self.logs = []
        self.family, self.length, self.consumed = payload[48], len(payload), 50 + typed_length
        self.expected_count = ((self.length - self.consumed) & 0xffffffff) >> 4
        image = b'\xa6' * 16 + payload + b'\xd6' * 16
        # Host writes initialize read-only emulated source memory; emulated
        # writes fail protection. The original stage never reads dependency bytes.
        uc.mem_write(INPUT, image)
        row = bytearray(0x8d)
        row[:50] = payload[:50]
        uc.mem_write(ACTION - 16, b'\x91' * 16 + row + b'\x92' * 16)
        uc.mem_write(OWNER + 0x60c, struct.pack('<I', 7))
        args = struct.pack('<5I', RETURN, ACTION, self.consumed, self.length,
                           INPUT + 16 + self.consumed)
        uc.mem_write(STACK, args)
        for name, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=OWNER,
                                EDX=0x44444444, ESI=0x55555555, EDI=0x66666666,
                                EBP=0x77777777, ESP=STACK, EFLAGS=0x202, ES=0).items():
            uc.reg_write(r[name], value)
        uc.emu_start(CODE_START, RETURN, count=10000)
        exit_address = uc.reg_read(r['EIP'])
        require(exit_address in (EMPTY_EXIT, ACCEPT_EXIT, FATAL_EXIT),
                f'original did not reach a tail exit: {exit_address:#x}')
        count = struct.unpack('<I', uc.mem_read(ACTION + 0x6a, 4))[0]
        require(bytes(uc.mem_read(INPUT, len(image))) == image, 'original changed ACT input')
        require(bytes(uc.mem_read(ACTION - 16, 16)) == b'\x91' * 16 and
                bytes(uc.mem_read(ACTION + 0x8d, 16)) == b'\x92' * 16,
                'original action guard overwritten')
        require(bytes(uc.mem_read(ACTION, 0x36)) == bytes(row[:0x36]),
                'original changed action header/data pointer')
        require(bytes(uc.mem_read(STACK, 20)) == args, 'original changed caller arguments')
        require(struct.unpack('<I', uc.mem_read(OWNER + 0x60c, 4))[0] == 8,
                'original owner initialization did not execute')
        require(len(self.logs) == int(exit_address == FATAL_EXIT),
                'ragged path did not execute exactly one original log call')
        self.calls += 1
        return TailResult(exit_address, exit_address != FATAL_EXIT, count, tuple(self.logs))


def build_native(family, directory):
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    library = directory / f'libactionfamily{family}.dylib'
    require(not library.exists(), 'build output must be unique')
    env = dict(os.environ, BUILD_DIR=str(directory))
    cp = subprocess.run([str(PROJECT / f'scripts/build_action_family_{family}.sh')],
                        env=env, capture_output=True, text=True)
    require(cp.returncode == 0, f'family {family} build failed: {cp.stderr[:2000]}')
    return library


class NativeFamily:
    def __init__(self, family, library):
        require(family in FAMILIES, 'unknown family')
        self.family, self.library = family, Path(library)
        # Reuse the reviewed ctypes layouts only. No unittest setUp or build
        # side effects from these read-only example modules are invoked.
        module = importlib.import_module(f'test_action_family_{family}')
        self.Decoded = module.Decoded
        self.lib = module.load_native(self.library)
        self.decode = getattr(self.lib, f'action_family_{family}_decode')
        self.body_length = getattr(self.lib, f'action_family_{family}_body_length', None)

    def invoke(self, body, length=None):
        # Fully backed storage allows missing-length guard mutants to be probed
        # without undefined reads of host memory. The logical extent is separate.
        raw = (C.c_uint8 * max(1, len(body))).from_buffer_copy(body or b'\0')
        decoded = self.Decoded()
        C.memset(C.byref(decoded), 0xa5, C.sizeof(decoded))
        before = bytes(decoded)
        status = self.decode(raw, len(body) if length is None else length, C.byref(decoded))
        return status, decoded, raw, before

    def validated_length(self, payload, expected):
        body = payload[50:]
        status, decoded, raw, _ = self.invoke(body)
        require(status == 0 and decoded.body_bytes == expected,
                f'family {self.family}: reviewed corpus typed boundary mismatch')
        if self.body_length is not None:
            length = C.c_size_t()
            require(self.body_length(raw, len(body), C.byref(length)) == 0 and length.value == expected,
                    f'family {self.family}: native body_length mismatch')
        return decoded.body_bytes


def compare_tail(native, machine, payload, typed_length):
    original = machine.invoke(payload, typed_length)
    status, decoded, raw, before = native.invoke(payload[50:])
    context = f'family {native.family}, typed={typed_length}, tail={len(payload)-50-typed_length}'
    if (status == 0) != original.accepted:
        raise TailMismatch(f'{context}: acceptance mismatch: native={status}, original={asdict(original)}')
    if original.accepted:
        if (decoded.body_bytes, decoded.dependency_count) != (typed_length, original.count):
            raise TailMismatch(f'{context}: count/body mismatch: native={decoded.dependency_count}, '
                               f'original={original.count}, native_body={decoded.body_bytes}')
        pointer = C.cast(decoded.dependency_records, C.c_void_p).value
        require(pointer == C.addressof(raw) + typed_length and
                decoded.dependency_bytes == len(payload) - 50 - typed_length,
                f'{context}: native borrowed dependency span mismatch')
    else:
        require(bytes(decoded) == before, f'{context}: ragged rejection changed native output')
    require(bytes(raw) == payload[50:], f'{context}: native changed input')
    return original


def check_short_body(native, machine, payload, typed_length, logical_length):
    require(0 <= logical_length < typed_length, 'short probe must be below trusted typed extent')
    original = machine.invoke(payload[:50 + logical_length], typed_length)
    status, decoded, raw, before = native.invoke(payload[50:50 + typed_length], logical_length)
    # Original arithmetic is unsigned DWORD and can accept negative multiples
    # of 16. Native rejects before parsing; ERR_BODY is its own documented API,
    # never claimed to be an original return value. Keep this check separate.
    if status != 2 or bytes(decoded) != before:
        raise TailMismatch(f'family {native.family}: native short-body safety status mismatch: '
                           f'length={logical_length}, trusted={typed_length}, native={status}, '
                           f'original_exit={original.exit_address:#x}, original_count={original.count}')
    require(bytes(raw) == payload[50:50 + typed_length], 'native changed padded short-body backing')
    return original


class Corpus:
    def __init__(self):
        data = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
        require(sha(data) == MANIFEST_HASH, 'pinned manifest mismatch')
        manifest = json.loads(data)
        require(manifest['archive_sha256'] == ARCHIVE_HASH and len(manifest['resources']) == 2267,
                'pinned archive/manifest count mismatch')
        self.rows = {int(row['index']): row for row in manifest['resources']}
        self.resources = {}

    def records(self, family):
        count, digest = FAMILIES[family]
        data = (PRIVATE / f'A-{family.upper()}.1.corpus.json').read_bytes()
        require(sha(data) == digest, f'family {family}: pinned corpus mismatch')
        corpus = json.loads(data)
        require((corpus['exe_sha256'], corpus['manifest_sha256'], corpus['archive_sha256'],
                 corpus['resources_scanned'], corpus['scen_data_records'], corpus['scene_actions'],
                 len(corpus['records'])) ==
                (EXE_HASH, MANIFEST_HASH, ARCHIVE_HASH, 2267, 2078, 19612, count),
                f'family {family}: corpus identity/count mismatch')
        records = []
        for ordinal, row in enumerate(corpus['records']):
            index = row['resource_index']
            if index not in self.resources:
                resource = (ROOT / 'work/analysis/hiff-resources' / f'{index:04d}.bin').read_bytes()
                pinned = self.rows[index]
                require((len(resource), sha(resource)) == (pinned['size'], pinned['sha256']),
                        f'resource {index} mismatch')
                self.resources[index] = resource
            resource = self.resources[index]
            offset, size = row['act_payload_offset'], row['act_payload_length']
            payload = resource[offset:offset + size]
            typed = row['typed_body_length']
            require(len(payload) == size and payload[48] == int(family, 16) and
                    payload[49] == row['subtype'] and row['raw_body_offset'] == offset + 50 and
                    (len(payload) - 50, sha(payload[50:])) ==
                    (row['raw_body_length'], row['body_sha256']) and
                    len(payload) - 50 - typed == row['dependency_tail_length'],
                    f'family {family}: corpus row {ordinal} mismatch')
            records.append((payload, typed))
        return records


def run_family(native, machine, records):
    exits = Counter()
    digest = hashlib.sha256()
    corpus_calls = synthetic_calls = short_calls = 0

    def remember(result):
        exits[hex(result.exit_address)] += 1
        digest.update(struct.pack('<II', result.exit_address, result.count))

    pattern = bytes((i * 37 + 11) & 255 for i in range(max(TAIL_LENGTHS)))
    for payload, expected in records:
        typed = native.validated_length(payload, expected)
        remember(compare_tail(native, machine, payload, typed))
        corpus_calls += 1
        prefix = payload[:50 + typed]
        for tail in TAIL_LENGTHS:
            remember(compare_tail(native, machine, prefix + pattern[:tail], typed))
            synthetic_calls += 1
        for logical in sorted({0, typed - 1, max(0, typed - 16)}):
            # Separate native safety contract; excluded from tail parity counts.
            check_short_body(native, machine, prefix, typed, logical)
            short_calls += 1
    prefix, typed = records[0]
    for tail in WIDTH_TAILS:
        remember(compare_tail(native, machine, prefix[:50 + typed] + bytes(tail), typed))
        synthetic_calls += 1
    return dict(family=native.family, corpus_records=corpus_calls, tail_lengths=list(TAIL_LENGTHS),
                synthetic_tail_comparisons=synthetic_calls, native_short_body_checks=short_calls,
                parity_comparisons=corpus_calls + synthetic_calls, exit_counts=dict(exits),
                observed_exits_counts_sha256=digest.hexdigest(), mismatches=0,
                native_library=str(native.library), native_library_sha256=sha(native.library.read_bytes()),
                source_sha256=sha((SOURCE / f'action_family_{native.family}.c').read_bytes()),
                header_sha256=sha((SOURCE / f'action_family_{native.family}.h').read_bytes()))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--family', choices=FAMILIES, action='append')
    args = parser.parse_args()
    started = time.monotonic()
    run = new_run('oracle')
    machine, corpus = OriginalTail(), Corpus()
    results = []
    for family in args.family or FAMILIES:
        native = NativeFamily(family, build_native(family, run / family))
        result = run_family(native, machine, corpus.records(family))
        results.append(result)
        print(json.dumps({key: result[key] for key in
                          ('family', 'corpus_records', 'parity_comparisons', 'mismatches')}), flush=True)
    report = dict(slice='A-TAIL.1', status='pass', families=results,
                  corpus_records=sum(row['corpus_records'] for row in results),
                  parity_comparisons=sum(row['parity_comparisons'] for row in results),
                  native_short_body_checks=sum(row['native_short_body_checks'] for row in results),
                  original_calls=machine.calls, mismatches=0,
                  inputs=dict(exe_sha256=EXE_HASH, code_start=hex(CODE_START), code_end=hex(CODE_END),
                              code_sha256=CODE_HASH, manifest_sha256=MANIFEST_HASH,
                              archive_sha256=ARCHIVE_HASH, corpus_pins=FAMILIES,
                              referenced_resources_verified=len(corpus.resources)),
                  hooks=HOOKS, exit_points=EXIT_POINTS, original_decisions_replaced=False,
                  unverified_branches=UNVERIFIED, helper_sha256=sha(Path(__file__).read_bytes()),
                  elapsed_seconds=round(time.monotonic() - started, 3))
    require(sha(machine.uc.mem_read(CODE_START, CODE_END - CODE_START)) == CODE_HASH,
            'emulated original code changed')
    write_json(run / 'report.json', report)
    print(json.dumps(dict(status='pass', result=str(run / 'report.json'),
                          sha256=sha((run / 'report.json').read_bytes()))), flush=True)


if __name__ == '__main__':
    main()
