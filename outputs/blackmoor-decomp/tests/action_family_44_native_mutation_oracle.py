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
    directory = Path(tempfile.mkdtemp(prefix='A-44.1.mutants-', dir=PRIVATE))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_44.c').read_text()
    mutants = [
        ('wrong_word_source_offset', 'word = le16(raw + 2u);', 'word = le16(raw + 4u);'),
        ('wrong_mode_offset', 'if (raw[492u] == 0u)', 'if (raw[491u] == 0u)'),
        ('wrong_inline_count_width', 'body_bytes += (size_t)count;', 'body_bytes += (size_t)(count & 255u);'),
        ('wrong_tail_modulus', '(n - body_bytes) % ACTION_FAMILY_44_DEPENDENCY_BYTES', '(n - body_bytes) % 8u'),
        ('wrong_tail_count', 'd->dependency_count = (n - body_bytes) / ACTION_FAMILY_44_DEPENDENCY_BYTES;',
         'd->dependency_count = (n - body_bytes) / 8u;'),
        ('wrong_short_body_status',
         'if (n < ACTION_FAMILY_44_HEADER_BYTES) {\n        return ACTION_FAMILY_44_ERR_BODY;',
         'if (n < ACTION_FAMILY_44_HEADER_BYTES) {\n        return ACTION_FAMILY_44_ERR_TAIL;'),
        ('wrong_constructor_field_offset', 'object[526u] = (uint8_t)text_bytes;',
         'object[525u] = (uint8_t)text_bytes;'),
        ('wrong_constructor_allocation_constant',
         'object_bytes = ACTION_FAMILY_44_HEADER_BYTES + text_bytes + 1u;',
         'object_bytes = ACTION_FAMILY_44_HEADER_BYTES + text_bytes + 2u;'),
        ('wrong_constructor_cursor_constant',
         'result.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;',
         'result.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes + 1u;'),
        ('wrong_constructor_inline_source_length',
         'result.source_word_20e_after = decoded.option_1ec == 0u ? (uint16_t)decoded.text_bytes : decoded.word_20e;',
         'result.source_word_20e_after = decoded.word_20e;'),
    ]
    results = []
    parity_reasons = ('decoded neutral field mismatch', 'decoded body/tail mismatch',
        'native body-length helper mismatch', 'original/native allocation mismatch',
        'constructor size/cursor/constant mismatch', 'constructor field/source-write mismatch',
        'original/native tail acceptance mismatch', 'native decoder rejected valid original',
        'native short-body/safety rejection mismatch')
    for name, old, new in mutants:
        if source.count(old) != 1:
            raise RuntimeError(f'mutation anchor not unique: {name}')
        changed = source.replace(old, new)
        src, lib = directory / f'{name}.c', directory / f'{name}.dylib'
        src.write_text(changed)
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
            '-I', str(PROJECT / 'src'), str(src), '-o', str(lib)], check=True, capture_output=True)
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_44_original_oracle.py'),
            '--native-library', str(lib), '--result', str(directory / f'{name}.oracle.json')],
            capture_output=True, text=True)
        (directory / f'{name}.stdout.log').write_text(run.stdout)
        (directory / f'{name}.stderr.log').write_text(run.stderr)
        reason = run.stderr.strip().splitlines()[-1] if run.stderr.strip() else ''
        if run.returncode == 0 or 'OracleError:' not in reason or not any(s in reason for s in parity_reasons):
            raise RuntimeError(f'oracle failed to reject mutant for parity reason: {name}: {reason}')
        results.append(dict(name=name, detected=True, oracle_exit=run.returncode, reason=reason,
                            source_sha256=sha(changed.encode()), native_library_sha256=sha(lib.read_bytes())))
    report = dict(slice='A-44.1', status='pass', compiled_mutants_detected=len(results), results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT / 'tests/action_family_44_original_oracle.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results), receipt=str(result_path))))


if __name__ == '__main__':
    main()
