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
PRIVATE = ROOT / 'work/analysis/slices'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    directory = Path(tempfile.mkdtemp(prefix='A-83.1.mutants-', dir=PRIVATE))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_83.c').read_text()
    mutants = [
        ('wrong_word_source_offset', 'all',
         'd->word[i] = (uint16_t)((uint16_t)raw[2u * i] |\n                              ((uint16_t)raw[2u * i + 1u] << 8));',
         'd->word[i] = (uint16_t)((uint16_t)raw[2u * i + 1u] |\n                              ((uint16_t)raw[2u * i] << 8));',
         'decoded neutral field mismatch'),
        ('wrong_decoded_body_extent', 'all',
         'd->body_bytes = ACTION_FAMILY_83_BODY_BYTES;', 'd->body_bytes = 73u;',
         'decoded body/tail mismatch'),
        ('wrong_body_length_constant', 'all',
         '*body_bytes = ACTION_FAMILY_83_BODY_BYTES;', '*body_bytes = 73u;',
         'body_length/original cursor mismatch'),
        ('wrong_constructor_field_offset', 'all',
         'result.object_bytes[2u * i] =', 'result.object_bytes[(2u * i + 2u) % 74u] =',
         'original/native allocation mismatch'),
        ('wrong_constructor_allocation_constant', 'all',
         'result.allocation_bytes = ACTION_FAMILY_83_OBJECT_BYTES;', 'result.allocation_bytes = 75u;',
         'original/native allocation constants mismatch'),
        ('wrong_constructor_cursor_constant', 'all',
         'result.payload_offset_after = payload_offset_before + UINT32_C(74);',
         'result.payload_offset_after = payload_offset_before + UINT32_C(73);',
         'original/native cursor/body rule mismatch'),
        ('wrong_runtime_type_constant', 'all',
         'result.runtime_type = ACTION_FAMILY_83_RUNTIME_TYPE;', 'result.runtime_type = UINT8_C(0x82);',
         'original/native allocation constants mismatch'),
        ('wrong_tail_modulus', 'tail',
         'ACTION_FAMILY_83_DEPENDENCY_BYTES != 0u)', '8u != 0u)', 'acceptance mismatch'),
        ('wrong_tail_count', 'tail',
         'd->dependency_count = d->dependency_bytes / ACTION_FAMILY_83_DEPENDENCY_BYTES;',
         'd->dependency_count = d->dependency_bytes / 8u;', 'count/body mismatch'),
        ('missing_short_body_guard', 'tail',
         'length < ACTION_FAMILY_83_BODY_BYTES)', 'length < ACTION_FAMILY_83_BODY_BYTES - 1u)',
         'native short-body safety status mismatch'),
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
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_83_original_oracle.py'),
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
    report = dict(slice='A-83.1', status='pass', compiled_mutants_detected=len(results), results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT / 'tests/action_family_83_original_oracle.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results),
                         receipt=str(result_path), receipt_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
