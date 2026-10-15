#!/usr/bin/env python3
"""Compiled decoder/constructor/tail mutants must fail the shipped raw-0x20 oracle.

Use oracle-python with Unicorn JIT allowed. Every mutant source, library, oracle
report and log goes to one unique directory under /private/tmp; nothing in the
canonical evidence tree is touched except an explicitly named --result path.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

PROJECT = Path(__file__).resolve().parents[1]


def sha(data):
    return hashlib.sha256(data).hexdigest()


COUNT = 'd->dependency_count = d->dependency_bytes / ACTION_FAMILY_20_DEPENDENCY_BYTES;'
MODULUS = ('if ((length - ACTION_FAMILY_20_BODY_BYTES) %\n'
           '            ACTION_FAMILY_20_DEPENDENCY_BYTES != 0u) {')
SHORT = 'if (length < ACTION_FAMILY_20_BODY_BYTES) {\n        return ACTION_FAMILY_20_ERR_BODY;\n    }'
READ_LE32 = ('return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |\n'
             '           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);')
D0 = 'd->dword_0 = read_le32(raw);'
D4 = 'd->dword_4 = read_le32(raw + 4);'
CONSTRUCT_LINES = [
    'result.object_bytes[0] = (uint8_t)decoded.dword_0;',
    'result.object_bytes[1] = (uint8_t)(decoded.dword_0 >> 8);',
    'result.object_bytes[2] = (uint8_t)(decoded.dword_0 >> 16);',
    'result.object_bytes[3] = (uint8_t)(decoded.dword_0 >> 24);',
    'result.object_bytes[4] = (uint8_t)decoded.dword_4;',
    'result.object_bytes[5] = (uint8_t)(decoded.dword_4 >> 8);',
    'result.object_bytes[6] = (uint8_t)(decoded.dword_4 >> 16);',
    'result.object_bytes[7] = (uint8_t)(decoded.dword_4 >> 24);',
]
MUTANTS = [
    ('read_le32_big_endian', 'all', READ_LE32,
     'return (uint32_t)p[3] | ((uint32_t)p[2] << 8) |\n           ((uint32_t)p[1] << 16) | ((uint32_t)p[0] << 24);',
     'decoded neutral field mismatch'),
    ('read_le32_drops_top_byte', 'all', READ_LE32,
     'return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |\n           ((uint32_t)p[2] << 16);',
     'decoded neutral field mismatch'),
    ('read_le32_drops_second_byte', 'all', READ_LE32,
     'return (uint32_t)p[0] |\n           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);',
     'decoded neutral field mismatch'),
    ('read_le32_masks_bit_31', 'all', READ_LE32,
     'return ((uint32_t)p[0] | ((uint32_t)p[1] << 8) |\n           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24)) &\n'
     '           UINT32_C(0x7fffffff);',
     'decoded neutral field mismatch'),
    ('dword_0_read_from_offset_4', 'all', D0, 'd->dword_0 = read_le32(raw + 4);', 'decoded neutral field mismatch'),
    ('dword_4_read_from_offset_3', 'all', D4, 'd->dword_4 = read_le32(raw + 3);', 'decoded neutral field mismatch'),
    ('dword_4_read_from_offset_0', 'all', D4, 'd->dword_4 = read_le32(raw);', 'decoded neutral field mismatch'),
    ('decoder_drops_dword_4', 'all', D4, 'd->dword_4 = 0u;', 'decoded neutral field mismatch'),
    ('decoder_drops_dword_0', 'all', D0, 'd->dword_0 = 0u;', 'decoded neutral field mismatch'),
    ('dword_treated_as_signed_count', 'all', SHORT,
     SHORT + '\n    if ((raw[3] & 0x80u) != 0u) {\n        return ACTION_FAMILY_20_ERR_BODY;\n    }',
     'native decoder rejected valid original record'),
    ('dword_4_treated_as_16_bit_count', 'all', SHORT,
     SHORT + '\n    if (raw[6] != 0u || raw[7] != 0u) {\n        return ACTION_FAMILY_20_ERR_BODY;\n    }',
     'native decoder rejected valid original record'),
    ('wrong_decoded_body_extent', 'all',
     'd->body_bytes = ACTION_FAMILY_20_BODY_BYTES;', 'd->body_bytes = 4u;',
     'decoded body/tail mismatch'),
    ('wrong_dependency_view_offset', 'all',
     'd->dependency_records = raw + ACTION_FAMILY_20_BODY_BYTES;',
     'd->dependency_records = raw + ACTION_FAMILY_20_BODY_BYTES - 4u;',
     'decoded body/tail mismatch'),
    ('wrong_body_length_constant', 'all',
     '*body_bytes = ACTION_FAMILY_20_BODY_BYTES;', '*body_bytes = 4u;',
     'body_length/original cursor mismatch'),
    ('wrong_body_length_constant_wide', 'all',
     '*body_bytes = ACTION_FAMILY_20_BODY_BYTES;', '*body_bytes = 16u;',
     'body_length/original cursor mismatch'),
    ('wrong_constructor_allocation_constant', 'all',
     'result.allocation_bytes = ACTION_FAMILY_20_OBJECT_BYTES;', 'result.allocation_bytes = 4u;',
     'original/native allocation constants mismatch'),
    ('wrong_constructor_cursor_constant', 'all',
     'payload_offset_before + UINT32_C(8);', 'payload_offset_before + UINT32_C(4);',
     'original/native cursor/body rule mismatch'),
    ('wrong_constructor_cursor_constant_wide', 'all',
     'payload_offset_before + UINT32_C(8);', 'payload_offset_before + UINT32_C(16);',
     'original/native cursor/body rule mismatch'),
    ('wrong_constructor_body_consumed', 'all',
     'result.body_bytes_consumed = decoded.body_bytes;', 'result.body_bytes_consumed = decoded.body_bytes - 4u;',
     'original/native cursor/body rule mismatch'),
    ('wrong_runtime_type_constant', 'all',
     'result.runtime_type = ACTION_FAMILY_20_RUNTIME_TYPE;', 'result.runtime_type = UINT8_C(0x21);',
     'original/native allocation constants mismatch'),
    ('wrong_raw_type_constant', 'all',
     'result.raw_type = ACTION_FAMILY_20_RAW_TYPE;', 'result.raw_type = UINT8_C(0x21);',
     'original/native allocation constants mismatch'),
]
for _i, _line in enumerate(CONSTRUCT_LINES):
    MUTANTS.append((f'constructor_drops_object_byte_{_i}', 'all', _line,
                    _line.split(' = ')[0] + ' = 0u;', 'original/native allocation mismatch'))
MUTANTS += [
    ('constructor_swaps_dwords', 'all', CONSTRUCT_LINES[0],
     'result.object_bytes[4] = (uint8_t)decoded.dword_0;', 'original/native allocation mismatch'),
    ('tail_modulus_removed', 'tail', MODULUS, 'if (0u) {', 'acceptance mismatch'),
    ('tail_modulus_8', 'tail', MODULUS,
     'if ((length - ACTION_FAMILY_20_BODY_BYTES) % 8u != 0u) {', 'acceptance mismatch'),
    ('tail_modulus_below_4096_only', 'tail', MODULUS,
     'if ((length - ACTION_FAMILY_20_BODY_BYTES) % ACTION_FAMILY_20_DEPENDENCY_BYTES != 0u &&\n'
     '            length - ACTION_FAMILY_20_BODY_BYTES < 4096u) {', 'acceptance mismatch'),
    ('tail_count_truncated_to_8_bits', 'tail', COUNT,
     'd->dependency_count = (uint8_t)(d->dependency_bytes / ACTION_FAMILY_20_DEPENDENCY_BYTES);',
     'count/body mismatch'),
    ('tail_count_truncated_to_16_bits', 'tail', COUNT,
     'd->dependency_count = (uint16_t)(d->dependency_bytes / ACTION_FAMILY_20_DEPENDENCY_BYTES);',
     'count/body mismatch'),
    ('tail_count_wrong_divisor', 'tail', COUNT,
     'd->dependency_count = d->dependency_bytes / 8u;', 'count/body mismatch'),
    ('short_body_guard_off_by_one', 'tail',
     'length < ACTION_FAMILY_20_BODY_BYTES)', 'length < ACTION_FAMILY_20_BODY_BYTES - 1u)',
     'native short-body safety status mismatch'),
    ('short_body_guard_rejects_exact_body', 'tail',
     'length < ACTION_FAMILY_20_BODY_BYTES)', 'length <= ACTION_FAMILY_20_BODY_BYTES)',
     # Both corpus records are exactly 8 bytes, so the native decoder's rejection of the
     # exact body is caught first, by the corpus typed-boundary check.
     'reviewed corpus typed boundary mismatch'),
]


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--result', type=Path)
    ap.add_argument('--only', action='append', help='run only named mutants (diagnostics)')
    args = ap.parse_args()
    directory = Path(tempfile.mkdtemp(prefix='A-20.1.mutants-', dir='/private/tmp'))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_20.c').read_text()
    results = []
    for name, stage, old, new, expected in MUTANTS:
        if args.only and name not in args.only:
            continue
        if source.count(old) != 1:
            raise RuntimeError(f'mutation anchor not unique: {name}')
        changed = source.replace(old, new)
        src, lib = directory / f'{name}.c', directory / f'{name}.dylib'
        with src.open('x') as output:
            output.write(changed)
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
            '-I', str(PROJECT / 'src'), str(src), '-o', str(lib)], check=True, capture_output=True)
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_20_original_oracle.py'),
            '--native-library', str(lib), '--stage', stage,
            '--result', str(directory / f'{name}.oracle.json')], capture_output=True, text=True)
        for suffix, content in (('stdout', run.stdout), ('stderr', run.stderr)):
            with (directory / f'{name}.{suffix}.log').open('x') as output:
                output.write(content)
        reason = run.stderr.strip().splitlines()[-1] if run.stderr.strip() else ''
        if (run.returncode == 0 or expected not in reason or
                not any(s in reason for s in ('OracleError:', 'TailMismatch:'))):
            raise RuntimeError(f'oracle did not reject mutant for expected parity/safety reason: {name}: {reason}')
        results.append(dict(name=name, stage=stage, detected=True, oracle_exit=run.returncode,
                            reason=reason, expected_reason=expected,
                            source_sha256=sha(changed.encode()), native_library_sha256=sha(lib.read_bytes())))
    report = dict(slice='A-20.1', status='pass', compiled_mutants_detected=len(results), results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT / 'tests/action_family_20_original_oracle.py').read_bytes()),
        shared_tail_helper_sha256=sha((PROJECT / 'tests/tail_oracle_common.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results),
                         receipt=str(result_path), receipt_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
