#!/usr/bin/env python3
"""Compiled decoder/constructor/tail mutants must fail the shipped oracle.

Use oracle-python with Unicorn JIT allowed. Every source, library, oracle
report and log has a unique directory under the temp area (default
/private/tmp); no canonical receipt is replaced.
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


TAIL_OLD = 'ACTION_FAMILY_F6_DEPENDENCY_BYTES != 0u) {'


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--result', type=Path)
    ap.add_argument('--directory', type=Path, help='existing empty directory; default: new temp dir')
    args = ap.parse_args()
    directory = args.directory or Path(tempfile.mkdtemp(prefix='A-F6.1.mutants-', dir='/private/tmp'))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_f6.c').read_text()
    D = 'd->dependency_count = d->dependency_bytes / ACTION_FAMILY_F6_DEPENDENCY_BYTES;'
    C_ = 'out->dependency_count = out->dependency_bytes / ACTION_FAMILY_F6_DEPENDENCY_BYTES;'
    mutants = [
        # decoder body bytes
        ('wrong_body_source_offset', 'all', 'memcpy(d->body, raw, ACTION_FAMILY_F6_BODY_BYTES);',
         'memcpy(d->body, raw + 1u, ACTION_FAMILY_F6_BODY_BYTES - 1u);', 'decoded body mismatch'),
        ('dropped_last_body_byte', 'all', 'memcpy(d->body, raw, ACTION_FAMILY_F6_BODY_BYTES);',
         'memcpy(d->body, raw, ACTION_FAMILY_F6_BODY_BYTES - 1u);', 'decoded body mismatch'),
        ('wrong_decoded_body_extent', 'all', 'd->body_bytes = ACTION_FAMILY_F6_BODY_BYTES;',
         'd->body_bytes = 4933u;', 'decoded body/tail mismatch'),
        ('wrong_dependency_view_offset', 'all', 'd->dependency_records = raw + ACTION_FAMILY_F6_BODY_BYTES;',
         'd->dependency_records = raw + 4933u;', 'decoded body/tail mismatch'),
        ('wrong_dependency_bytes', 'all', 'd->dependency_bytes = length - ACTION_FAMILY_F6_BODY_BYTES;',
         'd->dependency_bytes = length - 4933u;', 'decoded body/tail mismatch'),
        ('wrong_body_length_constant', 'all', '*body_bytes = ACTION_FAMILY_F6_BODY_BYTES;',
         '*body_bytes = 4933u;', 'body_length/original cursor mismatch'),
        # constructor offsets and constants
        ('wrong_constructor_field_offset', 'all',
         'memcpy(out->object_bytes, raw_body, ACTION_FAMILY_F6_OBJECT_BYTES);',
         'memcpy(out->object_bytes + 1u, raw_body, ACTION_FAMILY_F6_OBJECT_BYTES - 1u);',
         'original/native allocation mismatch'),
        ('dropped_last_object_byte', 'all',
         'memcpy(out->object_bytes, raw_body, ACTION_FAMILY_F6_OBJECT_BYTES);',
         'memcpy(out->object_bytes, raw_body, ACTION_FAMILY_F6_OBJECT_BYTES - 1u);',
         'original/native allocation mismatch'),
        ('wrong_constructor_allocation_constant', 'all',
         'out->allocation_bytes = ACTION_FAMILY_F6_OBJECT_BYTES;', 'out->allocation_bytes = 4935u;',
         'original/native allocation constants mismatch'),
        ('wrong_constructor_cursor_constant', 'all', 'payload_offset_before + UINT32_C(4934);',
         'payload_offset_before + UINT32_C(4933);', 'original/native cursor/body rule mismatch'),
        ('wrong_constructor_consumed_constant', 'all', 'out->body_bytes_consumed = ACTION_FAMILY_F6_BODY_BYTES;',
         'out->body_bytes_consumed = 4933u;', 'original/native cursor/body rule mismatch'),
        ('wrong_runtime_type_constant', 'all', 'out->runtime_type = ACTION_FAMILY_F6_RUNTIME_TYPE;',
         'out->runtime_type = UINT8_C(0xf5);', 'original/native allocation constants mismatch'),
        ('wrong_raw_type_constant', 'all', 'out->raw_type = ACTION_FAMILY_F6_RAW_TYPE;',
         'out->raw_type = UINT8_C(0xf5);', 'original/native allocation constants mismatch'),
        # tail modulus
        ('tail_modulus_removed', 'tail', TAIL_OLD, '1u != 0u) {', 'acceptance mismatch'),
        ('tail_modulus_8', 'tail', TAIL_OLD, '8u != 0u) {', 'acceptance mismatch'),
        ('tail_modulus_below_4096_only', 'tail', TAIL_OLD,
         'ACTION_FAMILY_F6_DEPENDENCY_BYTES != 0u &&\n        (length - ACTION_FAMILY_F6_BODY_BYTES) < 4096u) {',
         'acceptance mismatch'),
        # tail count: wrong divisor and 8/16-bit truncation (decoder and constructor)
        ('wrong_tail_count_divisor', 'tail', D, 'd->dependency_count = d->dependency_bytes / 8u;', 'count/body mismatch'),
        ('tail_count_truncated_8_bits', 'tail', D,
         'd->dependency_count = (uint8_t)(d->dependency_bytes / ACTION_FAMILY_F6_DEPENDENCY_BYTES);',
         'count/body mismatch'),
        ('tail_count_truncated_16_bits', 'tail', D,
         'd->dependency_count = (uint16_t)(d->dependency_bytes / ACTION_FAMILY_F6_DEPENDENCY_BYTES);',
         'count/body mismatch'),
        ('constructor_tail_count_truncated_8_bits', 'all', C_,
         'out->dependency_count = (uint8_t)(out->dependency_bytes / ACTION_FAMILY_F6_DEPENDENCY_BYTES);',
         'original/native cursor/body rule mismatch'),
        ('constructor_tail_count_truncated_16_bits', 'all', C_,
         'out->dependency_count = (uint16_t)(out->dependency_bytes / ACTION_FAMILY_F6_DEPENDENCY_BYTES);',
         'original/native cursor/body rule mismatch'),
        # short-body guard
        ('short_body_guard_off_by_one', 'tail', 'length < ACTION_FAMILY_F6_BODY_BYTES) {',
         'length < ACTION_FAMILY_F6_BODY_BYTES - 1u) {', 'native short-body safety status mismatch'),
        ('short_body_guard_removed', 'tail', 'length < ACTION_FAMILY_F6_BODY_BYTES) {',
         'length < 1u) {', 'native short-body safety status mismatch'),
    ]
    results = []
    for name, stage, old, new, expected in mutants:
        if source.count(old) != 1:
            raise RuntimeError(f'mutation anchor not unique: {name} ({source.count(old)})')
        changed = source.replace(old, new)
        src, lib = directory / f'{name}.c', directory / f'{name}.dylib'
        with src.open('x') as output:
            output.write(changed)
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
            '-I', str(PROJECT / 'src'), str(src), '-o', str(lib)], check=True, capture_output=True)
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_f6_original_oracle.py'),
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
                            reason=reason[:300], expected_reason=expected,
                            source_sha256=sha(changed.encode()), native_library_sha256=sha(lib.read_bytes())))
    report = dict(slice='A-F6.1', status='pass', compiled_mutants_detected=len(results),
        mutants_total=len(mutants), results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT / 'tests/action_family_f6_original_oracle.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results),
                         receipt=str(result_path), receipt_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
