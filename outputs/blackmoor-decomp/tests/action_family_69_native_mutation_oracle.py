#!/usr/bin/env python3
"""Compiled native mutants must fail the shipped original-x86 oracle.

Run with oracle-python and JIT permitted. Reports, libraries and subprocess
reports have unique paths and never replace another run's evidence.
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
PRIVATE = ROOT / 'work/analysis/slices'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    directory = Path(tempfile.mkdtemp(prefix='A-69.1.mutants-', dir=PRIVATE))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_69.c').read_text()
    mutants = [
        ('wrong_byte_source_offset', 'decoded->option_00 = raw_body[0];',
         'decoded->option_00 = raw_body[1];', 'decoded fields/tail mismatch'),
        ('wrong_typed_body_rule', 'decoded->body_bytes = ACTION_FAMILY_69_BODY_BYTES;',
         'decoded->body_bytes = 2u;', 'decoded fields/tail mismatch'),
        ('wrong_constructor_field_offset', 'constructed.object_bytes[0] = decoded.option_00;',
         '((uint8_t *)&constructed)[1] = decoded.option_00;', 'original/native object mismatch'),
        ('wrong_constructor_allocation_constant',
         'constructed.output_allocation_bytes = ACTION_FAMILY_69_OBJECT_BYTES;',
         'constructed.output_allocation_bytes = 2u;', 'original/native slot/constants mismatch'),
        ('wrong_constructor_cursor_constant',
         'constructed.payload_offset_after = payload_offset_before + UINT32_C(1);',
         'constructed.payload_offset_after = payload_offset_before + UINT32_C(2);',
         'original/native cursor/tail mismatch'),
        ('wrong_tail_modulus',
         '(length - ACTION_FAMILY_69_BODY_BYTES) % ACTION_FAMILY_69_DEPENDENCY_BYTES != 0u',
         '(length - ACTION_FAMILY_69_BODY_BYTES) % 8u != 0u', 'acceptance mismatch'),
        ('wrong_tail_count',
         'decoded->dependency_count = decoded->dependency_bytes / ACTION_FAMILY_69_DEPENDENCY_BYTES;',
         'decoded->dependency_count = decoded->dependency_bytes / 8u;', 'count/body mismatch'),
        ('missing_short_body_guard', 'if (length < ACTION_FAMILY_69_BODY_BYTES) {',
         'if (length < ACTION_FAMILY_69_BODY_BYTES && length != 0u) {',
         'native short-body safety status mismatch'),
        ('wrong_body_length_constant', 'const size_t length = ACTION_FAMILY_69_BODY_BYTES;',
         'const size_t length = 2u;', 'body_length/original cursor mismatch'),
    ]
    results = []
    for name, old, new, expected in mutants:
        if source.count(old) != 1:
            raise RuntimeError(f'mutation anchor not unique: {name}')
        changed = source.replace(old, new)
        src, lib = directory / f'{name}.c', directory / f'{name}.dylib'
        src.write_text(changed)
        compile_run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
            '-I', str(PROJECT / 'src'), str(src), '-o', str(lib)], capture_output=True, text=True)
        if compile_run.returncode:
            raise RuntimeError(f'mutant compile failed: {name}: {compile_run.stderr[:1500]}')
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_69_original_oracle.py'),
            '--native-library', str(lib), '--result', str(directory / f'{name}.oracle.json')],
            capture_output=True, text=True)
        (directory / f'{name}.stdout.log').write_text(run.stdout)
        (directory / f'{name}.stderr.log').write_text(run.stderr)
        reason = run.stderr.strip().splitlines()[-1] if run.stderr.strip() else ''
        if run.returncode == 0 or not any(e in reason for e in ('OracleError:', 'TailMismatch:')) or expected not in reason:
            raise RuntimeError(f'oracle did not reject mutant for expected reason: {name}: {reason}')
        results.append(dict(name=name, detected=True, oracle_exit=run.returncode, reason=reason,
                            source_sha256=sha(changed.encode()), native_library_sha256=sha(lib.read_bytes()),
                            stderr_sha256=sha(run.stderr.encode())))
    report = dict(slice='A-69.1', status='pass', compiled_mutants_detected=len(results), results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT / 'tests/action_family_69_original_oracle.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results), receipt=str(result_path))))


if __name__ == '__main__':
    main()
