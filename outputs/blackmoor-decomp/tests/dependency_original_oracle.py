#!/usr/bin/env python3
"""Compare reconstructed branch reduction with original x86 0x42406d.

Requires Unicorn 2.1.4. This executes the original integer-only function with
linked leaf objects, not the game or an action interpreter. Empty branches are
excluded: original 0x424aa8 handles those before calling this routine.
"""
import argparse
import ctypes as c
import hashlib
import itertools
import json
from pathlib import Path
import random
import struct

from cif_original_oracle import PEImage, EXPECTED_EXE_SHA256, align_up


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--exe', type=Path, required=True)
    parser.add_argument('--native-library', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    from unicorn import Uc, UC_ARCH_X86, UC_MODE_32
    from unicorn.x86_const import UC_X86_REG_ESP, UC_X86_REG_EBP, UC_X86_REG_EIP, UC_X86_REG_EFLAGS
    pe = PEImage.parse_and_map(args.exe)
    digest = hashlib.sha256(pe.data).hexdigest()
    if digest != EXPECTED_EXE_SHA256:
        raise ValueError('Original executable identity mismatch')
    machine = Uc(UC_ARCH_X86, UC_MODE_32)
    machine.mem_map(pe.image_base, align_up(pe.size_of_image))
    machine.mem_write(pe.image_base, pe.image)
    machine.mem_map(0x10000000, 0x10000)
    machine.mem_map(0x20000000, 0x40000)
    machine.mem_map(0x30000000, 0x1000)
    branch, parent, nodes, stack, sentinel = 0x20010000, 0x20010080, 0x20020000, 0x10008000, 0x30000000
    native = c.CDLL(str(args.native_library.resolve())).scene_dependencies_reduce
    native.argtypes = [c.POINTER(c.c_int32), c.POINTER(c.c_uint16), c.c_size_t, c.POINTER(c.c_int)]
    cases = []
    for states in itertools.product((0, 1), repeat=2):
        for op in (0, 1):
            cases.append((list(states), [op, op], 'two-node-truth-table'))
    for states in itertools.product((0, 1), repeat=4):
        for ops in itertools.product((0, 1), repeat=3):
            cases.append((list(states), list(ops) + [0], 'four-node-exhaustive'))
    rng = random.Random(20261013)
    for _ in range(600):
        size = rng.randrange(1, 25)
        cases.append(([rng.choice((-7, 0, 0, 1, 2)) for _ in range(size)],
                      [rng.choice((0, 1, 2, 65535)) for _ in range(size)], 'seeded-mixed-state'))
    cases.append(([1] * 512, [0] * 512, 'maximum-loader-leaf-count'))
    cases.append(([0] * 511 + [1], [1] * 512, 'maximum-backward-propagation'))
    table, result_digest = [], hashlib.sha256()
    for number, (states, operators, label) in enumerate(cases):
        machine.mem_write(branch, struct.pack('<7I', 0, nodes, 0, parent, 0, 0, len(states)))
        machine.mem_write(parent, bytes(32))
        for i, state in enumerate(states):
            leaf = bytearray(0x60)
            struct.pack_into('<i', leaf, 4, state)
            struct.pack_into('<H', leaf, 0x16, operators[i])
            struct.pack_into('<II', leaf, 0x34,
                             nodes + (i - 1) * 0x60 if i else 0,
                             nodes + (i + 1) * 0x60 if i + 1 < len(states) else 0)
            machine.mem_write(nodes + i * 0x60, bytes(leaf))
        machine.mem_write(stack, struct.pack('<II', sentinel, branch))
        machine.reg_write(UC_X86_REG_ESP, stack)
        machine.reg_write(UC_X86_REG_EBP, 0)
        machine.reg_write(UC_X86_REG_EFLAGS, 0x202)
        machine.emu_start(0x42406d, sentinel, timeout=10_000_000, count=50_000_000)
        if machine.reg_read(UC_X86_REG_EIP) != sentinel or machine.reg_read(UC_X86_REG_ESP) != stack + 8:
            raise AssertionError(f'Original routine did not return normally in case {number}')
        original = [struct.unpack('<i', machine.mem_read(nodes + i * 0x60 + 4, 4))[0]
                    for i in range(len(states))]
        original_result = struct.unpack('<I', machine.mem_read(branch, 4))[0]
        parent_result = struct.unpack('<I', machine.mem_read(parent + 4, 4))[0]
        values = (c.c_int32 * len(states))(*states)
        links = (c.c_uint16 * len(states))(*operators)
        result = c.c_int(-1)
        status = native(values, links, len(states), c.byref(result))
        if status or list(values) != original or result.value != original_result or parent_result != original_result:
            raise AssertionError(f'Original/native branch mismatch in case {number}: {label}')
        result_digest.update(struct.pack('<I', original_result))
        result_digest.update(struct.pack('<' + 'i' * len(original), *original))
        if label == 'two-node-truth-table':
            table.append({'input': states, 'operator': operators[0], 'result': original_result, 'after': original})
    code_offset = pe.va_to_file_offset(0x42406d, 0x424201 - 0x42406d)
    report = {'scope': 'branch reduction only; not complete dependency tree construction, leaf evaluation or gameplay',
              'original_sha256': digest, 'function_va': '0x42406d',
              'original_code_sha256': hashlib.sha256(pe.data[code_offset:code_offset + 404]).hexdigest(),
              'native_library_sha256': hashlib.sha256(args.native_library.read_bytes()).hexdigest(),
              'compared_branches': len(cases), 'mismatches': 0,
              'truth_table': table, 'result_digest': result_digest.hexdigest(),
              'original_parent_status_checked': True,
              'empty_branch_scope': 'native-only tests; original loader handles empty branches separately'}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: v for k, v in report.items() if k != 'truth_table'}))


if __name__ == '__main__':
    main()
