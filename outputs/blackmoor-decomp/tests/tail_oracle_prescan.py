#!/usr/bin/env python3
"""Observe and model the original dependency pre-scan, without changing native.

The model is a test-side reconstruction of the checks before tree construction,
corroborated by retained REA/Ghidra evidence and immutable x86 execution. A pass
at 0x424e98 says only that this pre-scan passed, not that a tree can be built or
evaluated. Native acceptance here means the family decoder API; integrating
these checks into scene_resource.c is reserved for root.

Run with work/tools/oracle-python/bin/python and Unicorn JIT permitted.
Only the printf-like log boundary is replaced. Fatal paths execute through
their original branch to 0x52139c, where observation stops before cleanup.
"""
from __future__ import annotations

from collections import Counter
from dataclasses import dataclass
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import time

import tail_oracle_common as T

EMPTY_DONE, PRESCAN_PASS = 0x424c31, 0x424e98
# label: (check address, format address, return after log, fatal branch label).
# 0x544bd4/0x544c54 reject too-short paired branches, rather than an
# unpaired marker. Only 0x544d94 diagnoses unequal open/close counts here.
FAILURES = {
    'slot_reuse': (0x424bd6, 0x544ab0, 0x424bfb, 0x425b82),
    'ragged_tail': (0x424c5b, 0x544b30, 0x424c8c, 0x425b80),
    'open_close_adjacent': (0x424d30, 0x544bd4, 0x424d5d, 0x425b7e),
    'open_close_one_leaf': (0x424d8c, 0x544c54, 0x424dba, 0x425b7c),
    'adjacent_0b_first_boolean_zero': (0x424dee, 0x544cf0, 0x424e50, 0x425b7a),
    'open_close_count_mismatch': (0x424e5d, 0x544d94, 0x424e90, 0x425b78),
}
EXIT_POINTS = {
    hex(EMPTY_DONE): 'empty tail: original trunk flag set to one; diagnostics disabled',
    hex(PRESCAN_PASS): 'content pre-scan passed; stop before allocation/tree construction',
    hex(T.FATAL_EXIT): 'original log and fatal branch executed; stop before cleanup',
}
HOOKS = {
    'code:0x50ca3e': 'only replacement: validate caller/format/scene/family/count; record log; cdecl return with ignored EAX=0',
}
UNVERIFIED = [
    'tree construction, ordering/nesting validity, marker Boolean pairing, allocation and dependency evaluation after 0x424e98',
    'fatal cleanup side effects at 0x52139c/0x4c97b4; nonzero diagnostics flag',
    'native scene_resource.c integration and full caller slot lifecycle; slot reuse is observed only in the original',
    'malformed typed bodies: trusted typed boundaries supplied by the reviewed body slices',
    'arbitrary large content tails and all opcode combinations; synthetic checks are bounded',
    'runtime/lifecycle/gameplay and whole-file x86 matching',
]


def record(opcode, boolean=0):
    return struct.pack('<8H', opcode, 0, 0, boolean & 0xffff, 0, 0, 0, 0)


def tail(*opcodes):
    return b''.join(record(opcode) for opcode in opcodes)


def model_prescan(data, *, slot_reuse=0):
    """Reconstructed test model of 0x424bd6..0x424e98; no tree semantics."""
    T.require(0 <= slot_reuse <= 0xffffffff, 'slot reuse must be a DWORD')
    if slot_reuse:
        return 'slot_reuse'
    if not data:
        return 'empty'
    if len(data) % 16:
        return 'ragged_tail'
    rows = list(struct.iter_unpack('<8h', data))
    opens = closes = 0
    for index, row in enumerate(rows):
        opcode = row[0]
        if opcode == 0x12:
            opens += 1
            if index + 1 < len(rows) and rows[index + 1][0] == 0x13:
                return 'open_close_adjacent'
            if index + 2 < len(rows) and rows[index + 2][0] == 0x13:
                return 'open_close_one_leaf'
        elif opcode == 0x13:
            closes += 1
        elif (opcode == 0x0b and index + 1 < len(rows) and
              rows[index + 1][0] == 0x0b and row[3] == 0):
            return 'adjacent_0b_first_boolean_zero'
    return 'pass' if opens == closes else 'open_close_count_mismatch'


class OriginalPrescan(T.OriginalTail):
    exits = (EMPTY_DONE, PRESCAN_PASS, T.FATAL_EXIT)

    def log(self, uc, address, _size, _user):
        esp = uc.reg_read(self.r['ESP'])
        ret, destination, fmt = struct.unpack('<3I', uc.mem_read(esp, 12))
        labels = [label for label, info in FAILURES.items() if info[1] == fmt]
        T.require(address == T.LOG_BOUNDARY and destination == 0x63888b and len(labels) == 1,
                  'unexpected pre-scan logging format/boundary')
        label = labels[0]
        T.require(ret == FAILURES[label][2], 'unexpected pre-scan log caller')
        count = 5 if label == 'slot_reuse' else 8 if label == 'ragged_tail' else 6
        args = struct.unpack('<' + 'I' * count, uc.mem_read(esp, count * 4))
        expected = (ret, destination, fmt, self.scene, self.family)
        if label != 'slot_reuse':
            expected += (self.expected_count,)
        if label == 'ragged_tail':
            expected += (self.length, self.consumed)
        T.require(args == expected, 'original pre-scan log arguments mismatch')
        self.logs.append(args)
        uc.reg_write(self.r['EAX'], 0)
        uc.reg_write(self.r['ESP'], esp + 4)
        uc.reg_write(self.r['EIP'], ret)

    def invoke(self, payload, typed_length, *, slot_reuse=0):
        # Unlike the arithmetic-only stage, this stage reads content. Require
        # the supplied cursor to remain within the fully backed ACT payload.
        T.require(len(payload) >= 50 + typed_length, 'pre-scan requires a backed typed body')
        result = super().invoke(payload, typed_length, slot_reuse=slot_reuse)
        if result.exit_address == EMPTY_DONE:
            trunk_flag = struct.unpack('<I', self.uc.mem_read(T.ACTION + 0x36, 4))[0]
            T.require(trunk_flag == 1, 'original empty-tail trunk flag not set')
        return result


def original_label(result):
    if result.exit_address == EMPTY_DONE:
        return 'empty'
    if result.exit_address == PRESCAN_PASS:
        return 'pass'
    T.require(result.exit_address == T.FATAL_EXIT and len(result.logs) == 1,
              'unexpected pre-scan result')
    fmt = result.logs[0][2]
    labels = [label for label, info in FAILURES.items() if info[1] == fmt]
    T.require(len(labels) == 1, 'unclassified original fatal diagnostic')
    return labels[0]


def evidence(label, exit_address):
    row = dict(exit_label=label, exit_address=hex(exit_address))
    if label in FAILURES:
        check, fmt, log_return, branch = FAILURES[label]
        row.update(check_address=hex(check), log_format=hex(fmt),
                   log_call_address=hex(log_return - 5), fatal_branch_label=hex(branch),
                   fatal_funnel='0x425b40 -> 0x52139c (observed); 0x4c97b4 cleanup unexecuted')
    return row


@dataclass(frozen=True)
class Case:
    name: str
    data: bytes
    expected_label: str
    slot_reuse: int = 0


CASES = (
    Case('empty', b'', 'empty'),
    Case('leaf', tail(0), 'pass'),
    Case('unpaired_open', tail(0x12), 'open_close_count_mismatch'),
    Case('unpaired_close', tail(0x13), 'open_close_count_mismatch'),
    Case('adjacent_open_close', tail(0x12, 0x13), 'open_close_adjacent'),
    Case('one_leaf_pair', tail(0x12, 0, 0x13), 'open_close_one_leaf'),
    Case('two_leaf_pair', tail(0x12, 0, 0, 0x13), 'pass'),
    Case('nested_pair', tail(0x12, 0x12, 0, 0, 0x13, 0x13), 'pass'),
    Case('reversed_pair_prescan_only', tail(0x13, 0x12), 'pass'),
    Case('unpaired_open_with_leaves', tail(0x12, 0, 0), 'open_close_count_mismatch'),
    Case('unpaired_close_with_leaves', tail(0, 0, 0x13), 'open_close_count_mismatch'),
    Case('double_open', tail(0x12, 0x12), 'open_close_count_mismatch'),
    Case('double_close', tail(0x13, 0x13), 'open_close_count_mismatch'),
    Case('pair_extra_open', tail(0x12, 0, 0, 0x13, 0x12), 'open_close_count_mismatch'),
    Case('pair_extra_close', tail(0x12, 0, 0, 0x13, 0x13), 'open_close_count_mismatch'),
    Case('opcode_high_byte', tail(0x1012), 'pass'),
    Case('negative_opcode', tail(0xffff), 'pass'),
    Case('single_0b_false', tail(0x0b), 'pass'),
    Case('adjacent_0b_false_false', tail(0x0b, 0x0b), 'adjacent_0b_first_boolean_zero'),
    Case('adjacent_0b_false_true', record(0x0b) + record(0x0b, 1), 'adjacent_0b_first_boolean_zero'),
    Case('adjacent_0b_true_false', record(0x0b, 1) + record(0x0b), 'pass'),
    Case('adjacent_0b_negative_false', record(0x0b, -1) + record(0x0b), 'pass'),
    Case('separated_0b_false', tail(0x0b, 0, 0x0b), 'pass'),
    Case('triple_0b_last_false', record(0x0b, 1) * 2 + record(0x0b), 'pass'),
    Case('triple_0b_middle_false', record(0x0b, 1) + record(0x0b) + record(0x0b, 1),
         'adjacent_0b_first_boolean_zero'),
    Case('ragged', b'\x12', 'ragged_tail'),
    Case('reused_empty_slot', b'', 'slot_reuse', 1),
    Case('reused_leaf_slot', tail(0), 'slot_reuse', 1),
    Case('reused_invalid_slot', tail(0x12, 0x13), 'slot_reuse', 0xffffffff),
)


def compare_model(machine, payload, typed, slot_reuse=0):
    result = machine.invoke(payload, typed, slot_reuse=slot_reuse)
    observed = original_label(result)
    expected = model_prescan(payload[50 + typed:], slot_reuse=slot_reuse)
    T.require(observed == expected, f'pre-scan model mismatch: original={observed}, model={expected}')
    count = 0 if slot_reuse else (len(payload) - 50 - typed) >> 4
    T.require(result.count == count, 'pre-scan original count mismatch')
    return result, observed


def native_observation(native, payload, typed):
    status, decoded, raw, before = native.invoke(payload[50:])
    aligned = (len(payload) - 50 - typed) % 16 == 0
    T.require((status == 0) == aligned, 'unexpected native decoder acceptance in pre-scan probe')
    if status == 0:
        pointer = C.cast(decoded.dependency_records, C.c_void_p).value
        T.require((decoded.body_bytes, decoded.dependency_bytes, decoded.dependency_count, pointer) ==
                  (typed, len(payload) - 50 - typed, (len(payload) - 50 - typed) // 16,
                   C.addressof(raw) + typed), 'native dependency span/count mismatch')
    else:
        T.require(bytes(decoded) == before, 'native ragged rejection changed output')
    T.require(bytes(raw) == payload[50:], 'native pre-scan probe changed input')
    return dict(status=status, accepted=status == 0,
                dependency_count=decoded.dependency_count if status == 0 else None)


def run_family(native, machine, records):
    corpus_exits, opcodes = Counter(), Counter()
    digest = hashlib.sha256()
    for payload, expected in records:
        typed = native.validated_length(payload, expected)
        result, label = compare_model(machine, payload, typed)
        T.require(result.accepted, f'family {native.family}: corpus pre-scan fatal: {label}')
        corpus_exits[label] += 1
        for row in struct.iter_unpack('<8h', payload[50 + typed:]):
            opcodes[hex(row[0] & 0xffff)] += 1
        digest.update(struct.pack('<II', result.exit_address, result.count))
    payload, expected = records[0]
    typed = native.validated_length(payload, expected)
    prefix = payload[:50 + typed]
    table = []
    for case in CASES:
        probe = prefix + case.data
        result, label = compare_model(machine, probe, typed, case.slot_reuse)
        T.require(label == case.expected_label, f'{case.name}: fixture label mismatch')
        observation = native_observation(native, probe, typed)
        row = dict(family=native.family, case=case.name, tail_bytes=len(case.data),
                   tail_sha256=T.sha(case.data), slot_reuse=case.slot_reuse,
                   original_count=result.count, original_accepted=result.accepted,
                   native=observation, **evidence(label, result.exit_address),
                   native_accepts_original_fatal=observation['accepted'] and not result.accepted,
                   scope='original slot precondition; native has no slot input' if case.slot_reuse
                   else 'family decoder content acceptance; scene parser integration reserved')
        table.append(row)
    return dict(family=native.family, corpus_records=len(records), corpus_exit_labels=dict(corpus_exits),
                corpus_opcode_counts=dict(opcodes), corpus_observations_sha256=digest.hexdigest(),
                synthetic_cases=len(table), divergence_table=table,
                content_divergences=sum(row['native_accepts_original_fatal'] and not row['slot_reuse']
                                        for row in table),
                slot_precondition_differences=sum(row['native_accepts_original_fatal'] and bool(row['slot_reuse'])
                                                 for row in table),
                native_library=str(native.library), native_sha256=T.sha(native.library.read_bytes()),
                source_sha256=T.sha((T.SOURCE / f'action_family_{native.family}.c').read_bytes()),
                header_sha256=T.sha((T.SOURCE / f'action_family_{native.family}.h').read_bytes()))


def main():
    started = time.monotonic()
    directory = T.new_run('prescan')
    machine, corpus = OriginalPrescan(), T.Corpus()
    families = []
    for family in T.FAMILIES:
        native = T.NativeFamily(family, T.build_native(family, directory / family))
        result = run_family(native, machine, corpus.records(family))
        families.append(result)
        print(json.dumps({key: result[key] for key in
                          ('family', 'corpus_records', 'synthetic_cases', 'content_divergences',
                           'slot_precondition_differences')}), flush=True)
    T.require(T.sha(machine.uc.mem_read(T.CODE_START, T.CODE_END - T.CODE_START)) == T.CODE_HASH,
              'emulated original code changed')
    report = dict(slice='A-TAIL.2', status='pass', families=families,
                  corpus_records=sum(row['corpus_records'] for row in families),
                  synthetic_cases=sum(row['synthetic_cases'] for row in families),
                  content_divergences=sum(row['content_divergences'] for row in families),
                  slot_precondition_differences=sum(row['slot_precondition_differences'] for row in families),
                  model_original_mismatches=0, original_calls=machine.calls,
                  hooks=HOOKS, exit_points=EXIT_POINTS, original_decisions_replaced=False,
                  inputs=dict(exe_sha256=T.EXE_HASH, code_start=hex(T.CODE_START), code_end=hex(T.CODE_END),
                              code_sha256=T.CODE_HASH, manifest_sha256=T.MANIFEST_HASH,
                              archive_sha256=T.ARCHIVE_HASH, corpus_pins=T.FAMILIES),
                  failures={label: evidence(label, T.FATAL_EXIT) for label in FAILURES},
                  unverified_branches=UNVERIFIED,
                  prescan_script_sha256=T.sha(Path(__file__).read_bytes()),
                  helper_sha256=T.sha(Path(T.__file__).read_bytes()),
                  elapsed_seconds=round(time.monotonic() - started, 3))
    T.write_json(directory / 'report.json', report)
    print(json.dumps(dict(status='pass', result=str(directory / 'report.json'),
                          sha256=T.sha((directory / 'report.json').read_bytes()))), flush=True)


if __name__ == '__main__':
    main()
