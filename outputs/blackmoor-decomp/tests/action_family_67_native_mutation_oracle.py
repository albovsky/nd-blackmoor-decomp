#!/usr/bin/env python3
"""Compile wrong native rules and require the actual original oracle to catch them.

Use oracle-python with JIT allowed. Every run/library/log/result is unique.
Unrelated oracle setup or compiler failures never count as detected mutations.
"""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / 'outputs/blackmoor-decomp'
PRIVATE = ROOT / 'work/analysis/slices'


def main():
    directory = Path(tempfile.mkdtemp(prefix='A-67.1.mutations-', dir=PRIVATE))
    source = (PROJECT / 'src/action_family_67.c').read_text()
    variants = [
        ('wrong_option_source_offset', 'd->option_00 = raw[0u];', 'd->option_00 = length > 1u ? raw[1u] : 0u;'),
        ('wrong_typed_body_rule', 'd->body_bytes = ACTION_FAMILY_67_BODY_BYTES;',
         'd->body_bytes = 2u;'),
        ('wrong_dependency_stride',
         'd->dependency_count = d->dependency_bytes / ACTION_FAMILY_67_DEPENDENCY_BYTES;',
         'd->dependency_count = d->dependency_bytes / 8u;'),
        # This writes one byte into model padding, leaving the actual x86
        # object byte unwritten. The mutation remains inside allocated storage.
        ('wrong_constructor_field_offset', 'result.object_bytes[0u] = decoded.option_00;',
         '((uint8_t *)&result)[1u] = decoded.option_00;'),
        ('wrong_allocation_constant', 'result.allocation_bytes = ACTION_FAMILY_67_OBJECT_BYTES;',
         'result.allocation_bytes = 2u;'),
        ('wrong_runtime_type_constant', 'result.runtime_type = ACTION_FAMILY_67_RUNTIME_TYPE;',
         'result.runtime_type = UINT8_C(0x36);'),
        ('wrong_cursor_constant',
         'result.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;',
         'result.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes + 1u;'),
    ]
    results = []
    for name, old, new in variants:
        if source.count(old) != 1:
            raise RuntimeError(f'mutation anchor not unique: {name}')
        src, lib = directory / f'{name}.c', directory / f'{name}.dylib'
        src.write_text(source.replace(old, new))
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
            '-I', str(PROJECT / 'src'), str(src), '-o', str(lib)], check=True, capture_output=True)
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_67_original_oracle.py'),
            '--native-library', str(lib), '--result', str(directory / f'{name}.json')],
            capture_output=True, text=True)
        (directory / f'{name}.stdout.log').write_text(run.stdout)
        (directory / f'{name}.stderr.log').write_text(run.stderr)
        reason = run.stderr.strip().splitlines()[-1] if run.stderr else ''
        if run.returncode == 0 or not reason.startswith('RuntimeError:') or not any(
                text in reason for text in ('mismatch record', 'rejected record')):
            raise RuntimeError(f'mutant failed for unrelated reason: {name}: {reason}')
        results.append(dict(name=name, detected=True, oracle_exit=run.returncode, reason=reason,
            source_sha256=hashlib.sha256(src.read_bytes()).hexdigest(),
            library_sha256=hashlib.sha256(lib.read_bytes()).hexdigest()))
    report = dict(slice='A-67.1', compiled_mutants_detected=len(results), results=results,
        baseline_source_sha256=hashlib.sha256(source.encode()).hexdigest(),
        oracle_script_sha256=hashlib.sha256((PROJECT / 'tests/action_family_67_original_oracle.py').read_bytes()).hexdigest())
    path = directory / 'report.json'
    with path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(compiled_mutants_detected=len(results), report=str(path), results=results)))


if __name__ == '__main__':
    main()
