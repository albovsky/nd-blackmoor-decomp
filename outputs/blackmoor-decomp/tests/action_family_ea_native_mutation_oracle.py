#!/usr/bin/env python3
"""Compiled decoder/constructor/tail mutants must fail the shipped oracle.

Use oracle-python with Unicorn JIT allowed. Every source, library, oracle
report and log has a unique private directory; no normal receipt is replaced.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    directory = Path(tempfile.mkdtemp(prefix='A-EA.1.mutants-', dir='/private/tmp'))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_ea.c').read_text()
    B = 'ACTION_FAMILY_EA_BODY_BYTES'
    D = 'ACTION_FAMILY_EA_DEPENDENCY_BYTES'
    O = 'ACTION_FAMILY_EA_OBJECT_BYTES'
    mutants = [
        ('dropped_final_body_byte', 'all',
         f'memcpy(d->byte, raw, {B});', f'memcpy(d->byte, raw, {B} - 1u);',
         'decoded neutral field mismatch'),
        ('swapped_word_byte_source', 'all',
         f'memcpy(d->byte, raw, {B});',
         f'memcpy(d->byte, raw, {B});\n    d->byte[{B} - 3u] = raw[{B} - 2u];',
         'decoded neutral field mismatch'),
        ('wrong_decoded_body_extent', 'all',
         f'd->body_bytes = {B};', 'd->body_bytes = 3846u;', 'decoded body/tail mismatch'),
        ('wrong_dependency_view_offset', 'all',
         f'd->dependency_records = raw + {B};', f'd->dependency_records = raw + {B} - 1u;',
         'decoded body/tail mismatch'),
        ('wrong_body_length_constant', 'all',
         f'*body_bytes = {B};', '*body_bytes = 3846u;', 'body_length/original cursor mismatch'),
        ('wrong_constructor_field_offset', 'all',
         f'memcpy(result.object_bytes, decoded.byte, {O});',
         f'memcpy(result.object_bytes + 1, decoded.byte, {O} - 1u);',
         'original/native allocation mismatch'),
        ('wrong_constructor_allocation_constant', 'all',
         f'result.allocation_bytes = {O};', 'result.allocation_bytes = 3848u;',
         'original/native allocation constants mismatch'),
        ('wrong_constructor_cursor_constant', 'all',
         'payload_offset_before + UINT32_C(0xf07);', 'payload_offset_before + UINT32_C(0xf06);',
         'original/native cursor/body rule mismatch'),
        ('wrong_runtime_type_constant', 'all',
         'result.runtime_type = ACTION_FAMILY_EA_RUNTIME_TYPE;', 'result.runtime_type = UINT8_C(0xe9);',
         'original/native allocation constants mismatch'),
        ('wrong_raw_type_constant', 'all',
         'result.raw_type = ACTION_FAMILY_EA_RAW_TYPE;', 'result.raw_type = UINT8_C(0xe9);',
         'original/native allocation constants mismatch'),
        ('tail_modulus_removed', 'tail', f'{D} != 0u) {{', '1u != 0u) {', 'acceptance mismatch'),
        ('tail_modulus_8', 'tail', f'{D} != 0u) {{', '8u != 0u) {', 'acceptance mismatch'),
        ('tail_modulus_below_4096_only', 'tail', f'{D} != 0u) {{',
         f'{D} != 0u &&\n            (length - {B}) < 4096u) {{', 'acceptance mismatch'),
        ('tail_count_8_bit', 'tail',
         f'd->dependency_count = d->dependency_bytes / {D};',
         f'd->dependency_count = (d->dependency_bytes / {D}) & 0xffu;', 'count/body mismatch'),
        ('tail_count_16_bit', 'tail',
         f'd->dependency_count = d->dependency_bytes / {D};',
         f'd->dependency_count = (d->dependency_bytes / {D}) & 0xffffu;', 'count/body mismatch'),
        ('missing_short_body_guard', 'tail',
         f'length < {B})', f'length < {B} - 1u)', 'native short-body safety status mismatch'),
    ]
    results = []
    for name, stage, old, new, expected in mutants:
        if source.count(old) != 1:
            raise RuntimeError(f'mutation anchor not unique: {name}')
        changed = source.replace(old, new)
        src, lib = directory / f'{name}.c', directory / f'{name}.dylib'
        with src.open('x') as output:
            output.write(changed)
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
            '-I', str(PROJECT / 'src'), str(src), '-o', str(lib)], check=True, capture_output=True)
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_ea_original_oracle.py'),
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
    report = dict(slice='A-EA.1', status='pass', compiled_mutants_detected=len(results), results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT / 'tests/action_family_ea_original_oracle.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results),
                         receipt=str(result_path), receipt_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
