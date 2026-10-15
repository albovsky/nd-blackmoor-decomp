#!/usr/bin/env python3
"""Compile real decoder/constructor mutants and require original-oracle failures.

Run with oracle-python and Unicorn JIT permitted. Each build and subprocess
log/report gets a unique private directory; normal receipts are never replaced.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT / 'work/analysis/slices'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--result', type=Path)
    args = parser.parse_args()
    directory = Path(tempfile.mkdtemp(prefix='A-4B.1.mutants-', dir=PRIVATE))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_4b.c').read_text()
    mutants = [
        ('selector_source_offset', 'uint16_t bits = read_le16(raw_body);',
         'uint16_t bits = read_le16(raw_body + 1u);'),
        ('body_length_rule', 'memcpy(out_length, &decoded.body_bytes, sizeof(*out_length));',
         'size_t wrong = decoded.body_bytes + 1u; memcpy(out_length, &wrong, sizeof(*out_length));'),
        ('constructor_field_offset',
         'write_le16(constructed.object_bytes, (uint16_t)(resolved_text_bytes + 3u));',
         'write_le16(constructed.object_bytes + 1u, (uint16_t)(resolved_text_bytes + 3u));'),
        ('constructor_word_constant',
         'write_le16(constructed.object_bytes, (uint16_t)(resolved_text_bytes + 3u));',
         'write_le16(constructed.object_bytes, (uint16_t)(resolved_text_bytes + 2u));'),
        ('constructor_suffix_constant',
         'memcpy(constructed.object_bytes + 2u + resolved_text_bytes, "<e>", 4u);',
         'memcpy(constructed.object_bytes + 2u + resolved_text_bytes, "<x>", 4u);'),
        ('constructor_allocation_constant',
         'constructed.allocation_bytes = resolved_text_bytes + 6u;',
         'constructed.allocation_bytes = resolved_text_bytes + 5u;'),
        ('constructor_cursor_rule',
         'constructed.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;',
         'constructed.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes + 1u;'),
        ('tail_modulus',
         '(length - typed) % ACTION_FAMILY_4B_DEPENDENCY_BYTES != 0u',
         '(length - typed) % 8u != 0u'),
        ('tail_count',
         'decoded->dependency_count = (length - typed) / ACTION_FAMILY_4B_DEPENDENCY_BYTES;',
         'decoded->dependency_count = (length - typed) / 8u;'),
        ('short_typed_body', 'if (length < typed) {', 'if (length < 2u) {'),
        ('inline_count_bound', '(uint32_t)selector > ACTION_FAMILY_4B_MAX_INLINE_BYTES',
         '(uint32_t)selector > ACTION_FAMILY_4B_MAX_INLINE_BYTES + 1u'),
    ]
    reasons = ('native rejected original-valid', 'original/native body_length mismatch',
               'original/native constructor object mismatch', 'original/native constructor cursor/handle mismatch',
               'acceptance mismatch:', 'count/body mismatch:',
               'native short-body safety status mismatch', 'native malformed safety mismatch',
               'native body_length/decode tail or short-body status mismatch')
    results = []
    for name, old, new in mutants:
        if source.count(old) != 1:
            raise RuntimeError(f'mutation anchor is not unique: {name}')
        changed = source.replace(old, new)
        src, lib = directory / f'{name}.c', directory / f'{name}.dylib'
        with src.open('x') as output:
            output.write(changed)
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
                        '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
                        '-I', str(PROJECT / 'src'), str(src), '-o', str(lib)], check=True, capture_output=True)
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_4b_original_oracle.py'),
                              '--native-library', str(lib), '--result', str(directory / f'{name}.oracle.json')],
                             capture_output=True, text=True)
        (directory / f'{name}.stdout.log').write_text(run.stdout)
        (directory / f'{name}.stderr.log').write_text(run.stderr)
        reason = run.stderr.strip().splitlines()[-1] if run.stderr.strip() else ''
        if run.returncode == 0 or not any(s in reason for s in reasons) or not any(
                s in reason for s in ('OracleError:', 'TailMismatch:')):
            raise RuntimeError(f'oracle failed to reject compiled mutant for expected reason: {name}: {reason}')
        results.append(dict(name=name, detected=True, oracle_exit=run.returncode, reason=reason,
                            source_sha256=sha(changed.encode()), native_library_sha256=sha(lib.read_bytes())))
    report = dict(slice='A-4B.1', status='pass', compiled_mutants_detected=len(results), results=results,
                  baseline_source_sha256=sha(source.encode()), evidence_directory=str(directory),
                  oracle_script_sha256=sha((PROJECT / 'tests/action_family_4b_original_oracle.py').read_bytes()),
                  original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results), receipt=str(result_path))))


if __name__ == '__main__':
    main()
