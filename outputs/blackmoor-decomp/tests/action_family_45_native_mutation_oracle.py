#!/usr/bin/env python3
"""Require real compiled offset/rule/constant mutants to fail original parity.

Every mutant, oracle report and log uses a unique private directory. Run with
oracle-python and JIT permitted. No normal receipt or other slice is overwritten.
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
    directory = Path(tempfile.mkdtemp(prefix='A-45.1.mutants-', dir=PRIVATE))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_45.c').read_text()
    mutants = [
        ('wrong_count_source_offset', 'count = read_le16(raw_body + 194u);',
         'count = read_le16(raw_body + 192u);'),
        ('wrong_prefix_word_offset', 'decoded->words[i] = read_le16(raw_body + i * 2u);',
         'decoded->words[i] = read_le16(raw_body + i * 2u + 2u);'),
        ('wrong_entry_source_offset', 'decoded->entries[i].word_1 = read_le16(entry + 2u);',
         'decoded->entries[i].word_1 = read_le16(entry);'),
        ('wrong_typed_body_rule', 'decoded->body_bytes = body_bytes;',
         'decoded->body_bytes = body_bytes + 4u;'),
        ('wrong_tail_modulus', '(length - typed) % ACTION_FAMILY_45_DEPENDENCY_BYTES != 0u',
         '(length - typed) % 8u != 0u'),
        ('wrong_tail_count', 'decoded->dependency_count = decoded->dependency_bytes / ACTION_FAMILY_45_DEPENDENCY_BYTES;',
         'decoded->dependency_count = decoded->dependency_bytes / 8u;'),
        ('short_body_guard', 'if (length < typed) {', 'if (length + 16u < typed) {'),
        ('wrong_max_count_constant', 'if (count > ACTION_FAMILY_45_MAX_ENTRIES) {',
         'if (count >= ACTION_FAMILY_45_MAX_ENTRIES) {'),
        ('wrong_constructor_field_offset',
         'write_le16(constructed.object_bytes + 194u, decoded.entry_count);',
         'write_le16(constructed.object_bytes + 192u, decoded.entry_count);'),
        ('wrong_constructor_allocation_constant',
         'constructed.output_allocation_bytes = (uint32_t)decoded.body_bytes;',
         'constructed.output_allocation_bytes = (uint32_t)decoded.body_bytes + 4u;'),
        ('wrong_constructor_cursor_constant',
         'constructed.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;',
         'constructed.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes + 1u;'),
        ('wrong_runtime_type', 'decoded->runtime_type = ACTION_FAMILY_45_RUNTIME_TYPE;',
         'decoded->runtime_type = UINT8_C(0x44);'),
    ]
    results = []
    parity_reasons = ('native decoder rejected record', 'decoded type/count mismatch',
        'decoded neutral field mismatch', 'decoded entry field mismatch', 'decoded body/tail mismatch',
        'original/native object mismatch', 'original/native slot/constants mismatch',
        'original/native cursor/tail mismatch', 'original dependency accept/reject mismatch',
        'native safety short body mismatch')
    for name, old, new in mutants:
        if source.count(old) != 1:
            raise RuntimeError(f'mutation anchor not unique: {name}')
        changed = source.replace(old, new)
        src, lib = directory / f'{name}.c', directory / f'{name}.dylib'
        src.write_text(changed)
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
            '-I', str(PROJECT / 'src'), str(src), '-o', str(lib)], check=True, capture_output=True)
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_45_original_oracle.py'),
            '--native-library', str(lib), '--result', str(directory / f'{name}.oracle.json')],
            capture_output=True, text=True)
        (directory / f'{name}.stdout.log').write_text(run.stdout)
        (directory / f'{name}.stderr.log').write_text(run.stderr)
        reason = run.stderr.strip().splitlines()[-1] if run.stderr.strip() else ''
        if run.returncode == 0 or 'OracleError:' not in reason or not any(s in reason for s in parity_reasons):
            raise RuntimeError(f'oracle failed to reject mutant for parity reason: {name}: {reason}')
        results.append(dict(name=name, detected=True, oracle_exit=run.returncode, reason=reason,
                            source_sha256=sha(changed.encode()), native_library_sha256=sha(lib.read_bytes())))
    report = dict(slice='A-45.1', status='pass', compiled_mutants_detected=len(results), results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT / 'tests/action_family_45_original_oracle.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results), receipt=str(result_path))))


if __name__ == '__main__':
    main()
