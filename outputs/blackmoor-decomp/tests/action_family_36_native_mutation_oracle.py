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
    directory = Path(tempfile.mkdtemp(prefix='A-36.1.mutants-', dir=PRIVATE))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_36.c').read_text()
    mutants = [
        ('wrong_primary_stride', '*primary * ACTION_FAMILY_36_PRIMARY_BYTES +', '*primary * 15u +'),
        ('wrong_primary_count_source', 'p = read_i16(raw + 0x2bu);', 'p = read_i16(raw + 0x2du);'),
        ('wrong_primary_narrowing', 'p = signed_word((uint16_t)difference);',
         'p = difference < 0 || difference > 100 ? -1 : (int16_t)difference;'),
        ('wrong_secondary_count_source', 's = read_i16(raw + 0xaau);', 's = read_i16(raw + 0xa8u);'),
        ('wrong_decoded_word_offset', 'd->word_33 = read_i16(raw + 0x33u);', 'd->word_33 = read_i16(raw + 0x35u);'),
        ('wrong_tail_modulus', '(length - *body) % ACTION_FAMILY_36_DEPENDENCY_BYTES', '(length - *body) % 8u'),
        ('wrong_tail_count', 'd->dependency_bytes / ACTION_FAMILY_36_DEPENDENCY_BYTES;', 'd->dependency_bytes / 8u;'),
        ('wrong_short_body_rule', 'length < ACTION_FAMILY_36_PREFIX_BYTES', 'length < ACTION_FAMILY_36_PREFIX_BYTES - 1u'),
        ('wrong_body_length_result', '*body_length = body;', '*body_length = body + 1u;'),
        ('wrong_constructor_primary_offset', 'result.object_bytes + ACTION_FAMILY_36_PREFIX_BYTES,',
         'result.object_bytes + ACTION_FAMILY_36_PREFIX_BYTES + 1u,'),
        ('wrong_constructor_secondary_offset', 'result.object_bytes + ACTION_FAMILY_36_SECONDARY_OFFSET,',
         'result.object_bytes + ACTION_FAMILY_36_SECONDARY_OFFSET + 2u,'),
        ('wrong_constructor_preserved_bytes',
         'memcpy(result.object_bytes, allocation_before, ACTION_FAMILY_36_OBJECT_BYTES);',
         'memset(result.object_bytes, 0, ACTION_FAMILY_36_OBJECT_BYTES);'),
        ('wrong_constructor_allocation_constant',
         'result.owner_links.output_allocation_bytes = ACTION_FAMILY_36_OBJECT_BYTES;',
         'result.owner_links.output_allocation_bytes = ACTION_FAMILY_36_OBJECT_BYTES + 1u;'),
        ('wrong_constructor_owner_link', 'result.owner_links.owner_slot_1c_handle = output_handle;',
         'result.owner_links.owner_slot_1c_handle = output_handle + 1u;'),
        ('wrong_constructor_cursor_constant',
         'result.payload_offset_after = payload_offset_before + (uint32_t)body;',
         'result.payload_offset_after = payload_offset_before + (uint32_t)body + 1u;'),
    ]
    results = []
    parity_reasons = ('decoded neutral fields mismatch', 'decoded body/tail/count mismatch',
        'original/native object mismatch', 'original/native owner/constants mismatch',
        'original/native cursor/tail/count mismatch', 'original/native body_length mismatch',
        'original/native dependency acceptance mismatch', 'native short/count safety mismatch')
    for name, old, new in mutants:
        if source.count(old) != 1:
            raise RuntimeError(f'mutation anchor not unique: {name}')
        changed = source.replace(old, new)
        src, lib = directory / f'{name}.c', directory / f'{name}.dylib'
        src.write_text(changed)
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
            '-I', str(PROJECT / 'src'), str(src), '-o', str(lib)], check=True, capture_output=True)
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_36_original_oracle.py'),
            '--native-library', str(lib), '--result', str(directory / f'{name}.oracle.json')],
            capture_output=True, text=True)
        (directory / f'{name}.stdout.log').write_text(run.stdout)
        (directory / f'{name}.stderr.log').write_text(run.stderr)
        reason = run.stderr.strip().splitlines()[-1] if run.stderr.strip() else ''
        if run.returncode == 0 or 'OracleError:' not in reason or not any(s in reason for s in parity_reasons):
            raise RuntimeError(f'oracle failed to reject mutant for parity reason: {name}: {reason}')
        results.append(dict(name=name, detected=True, oracle_exit=run.returncode, reason=reason,
                            source_sha256=sha(changed.encode()), native_library_sha256=sha(lib.read_bytes())))
    report = dict(slice='A-36.1', status='pass', compiled_mutants_detected=len(results), results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT / 'tests/action_family_36_original_oracle.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results), receipt=str(result_path))))


if __name__ == '__main__':
    main()
