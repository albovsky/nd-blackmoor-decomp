#!/usr/bin/env python3
"""Compile deliberate mutants; require a specific oracle parity/safety failure.

Uses unique paths for every build, report and log. A crash or generic setup
failure is not counted as successful mutation detection.
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
    ap = argparse.ArgumentParser()
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    directory = Path(tempfile.mkdtemp(prefix='A-1B.1.mutants-', dir='/private/tmp'))
    result_path = args.result or directory / 'report.json'
    if result_path.exists(): raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_1b.c').read_text()
    mutants = [
        ('wrong_primary_stride',
         'first_bytes = (size_t)primary * ACTION_FAMILY_1B_PRIMARY_BYTES;',
         'first_bytes = (size_t)primary * 20u;'),
        ('wrong_secondary_stride',
         'last_bytes = (size_t)secondary * ACTION_FAMILY_1B_SECONDARY_BYTES;',
         'last_bytes = (size_t)secondary * 16u;'),
        ('wrong_secondary_count_width',
         'secondary = u16(raw + cursor + 22u);', 'secondary = raw[cursor + 22u];'),
        ('wrong_primary_count_sign',
         'if (primary > INT16_MAX) return ACTION_FAMILY_1B_ERR_COUNT;',
         'if (primary > UINT16_MAX) return ACTION_FAMILY_1B_ERR_COUNT;'),
        ('wrong_fixed_word_source',
         'd.fixed_words[i] = u16(raw + cursor + i * 2u);',
         'd.fixed_words[i] = u16(raw + cursor + 2u + i * 2u);'),
        ('wrong_typed_body_rule', 'd.body_bytes = cursor;', 'd.body_bytes = cursor + 2u;'),
        ('wrong_tail_modulus',
         '(length - cursor) % ACTION_FAMILY_1B_DEPENDENCY_BYTES != 0u',
         '(length - cursor) % 8u != 0u'),
        ('wrong_tail_count',
         'd.dependency_count = d.dependency_bytes / ACTION_FAMILY_1B_DEPENDENCY_BYTES;',
         'd.dependency_count = d.dependency_bytes / ACTION_FAMILY_1B_DEPENDENCY_BYTES + 1u;'),
        ('missing_short_body_guard',
         'if (length < 2u) return ACTION_FAMILY_1B_ERR_BODY;', '/* Deliberate missing short guard. */'),
        ('wrong_constructor_field_offset',
         'put16(c.object_bytes + 28u, (uint16_t)d.secondary_count);',
         'put16(c.object_bytes + 27u, (uint16_t)d.secondary_count);'),
        ('wrong_constructor_allocation_constant',
         'c.output_allocation_bytes = ACTION_FAMILY_1B_OBJECT_BYTES;',
         'c.output_allocation_bytes = 36u;'),
        ('wrong_constructor_allocation_count', 'c.allocation_count = 3u;', 'c.allocation_count = 2u;'),
        ('wrong_constructor_cursor_constant',
         'c.payload_offset_after = payload_offset_before + (uint32_t)d.body_bytes;',
         'c.payload_offset_after = payload_offset_before + (uint32_t)d.body_bytes + 2u;'),
        ('wrong_owner_field', 'c.owner_field_24 = secondary_handle;', 'c.owner_field_24 = primary_handle;'),
        ('tail_modulus_removed',
         '(length - cursor) % ACTION_FAMILY_1B_DEPENDENCY_BYTES != 0u', '0'),
        ('tail_modulus_below_4096_only',
         '(length - cursor) % ACTION_FAMILY_1B_DEPENDENCY_BYTES != 0u',
         '(length - cursor) < 4096u && (length - cursor) % ACTION_FAMILY_1B_DEPENDENCY_BYTES != 0u'),
        ('tail_count_truncated_8_bits',
         'd.dependency_count = d.dependency_bytes / ACTION_FAMILY_1B_DEPENDENCY_BYTES;',
         'd.dependency_count = (d.dependency_bytes / ACTION_FAMILY_1B_DEPENDENCY_BYTES) & 0xffu;'),
        ('tail_count_truncated_16_bits',
         'd.dependency_count = d.dependency_bytes / ACTION_FAMILY_1B_DEPENDENCY_BYTES;',
         'd.dependency_count = (d.dependency_bytes / ACTION_FAMILY_1B_DEPENDENCY_BYTES) & 0xffffu;'),
        ('primary_count_truncated_8_bits', 'primary = u16(raw);', 'primary = raw[0];'),
        ('secondary_count_sign_unchecked',
         'if (secondary > INT16_MAX) return ACTION_FAMILY_1B_ERR_COUNT;',
         'if (secondary > UINT16_MAX) return ACTION_FAMILY_1B_ERR_COUNT;'),
        ('missing_primary_array_guard',
         'if (first_bytes > length - 2u) return ACTION_FAMILY_1B_ERR_BODY;', '/* Deliberate missing guard. */'),
        ('missing_fixed_block_guard',
         'if (length - cursor < 24u) return ACTION_FAMILY_1B_ERR_BODY;', '/* Deliberate missing guard. */'),
        ('fixed_block_guard_off_by_one',
         'if (length - cursor < 24u) return ACTION_FAMILY_1B_ERR_BODY;',
         'if (length - cursor < 23u) return ACTION_FAMILY_1B_ERR_BODY;'),
        ('missing_secondary_array_guard',
         'if (last_bytes > length - cursor - 24u) return ACTION_FAMILY_1B_ERR_BODY;', '/* Deliberate missing guard. */'),
        ('wrong_secondary_count_offset',
         'secondary = u16(raw + cursor + 22u);', 'secondary = u16(raw + cursor + 20u);'),
        ('wrong_constructor_primary_pointer_offset',
         'put32(c.object_bytes + 2u, primary_handle);', 'put32(c.object_bytes + 3u, primary_handle);'),
        ('wrong_constructor_secondary_pointer_offset',
         'put32(c.object_bytes + 30u, secondary_handle);', 'put32(c.object_bytes + 31u, secondary_handle);'),
        ('wrong_constructor_fixed_word_offset',
         'put16(c.object_bytes + 6u + i * 2u, d.fixed_words[i]);', 'put16(c.object_bytes + 8u + i * 2u, d.fixed_words[i]);'),
        ('wrong_constructor_fixed_dword_offset',
         'put32(c.object_bytes + 16u + i * 4u, d.fixed_dwords[i]);', 'put32(c.object_bytes + 14u + i * 4u, d.fixed_dwords[i]);'),
        ('wrong_constructor_primary_count_source',
         'put16(c.object_bytes, (uint16_t)d.primary_count);', 'put16(c.object_bytes, (uint16_t)d.secondary_count);'),
        ('wrong_constructor_primary_allocation',
         'c.primary_allocation_bytes = (uint32_t)d.primary_bytes;', 'c.primary_allocation_bytes = (uint32_t)d.primary_bytes + 2u;'),
        ('wrong_constructor_secondary_allocation',
         'c.secondary_allocation_bytes = (uint32_t)d.secondary_bytes;', 'c.secondary_allocation_bytes = (uint32_t)d.secondary_bytes + 2u;'),
        ('wrong_owner_field_1c', 'c.owner_field_1c = output_handle;', 'c.owner_field_1c = primary_handle;'),
        ('wrong_owner_field_20', 'c.owner_field_20 = primary_handle;', 'c.owner_field_20 = secondary_handle;'),
        ('wrong_result_slot', 'c.result_slot_handle = output_handle;', 'c.result_slot_handle = primary_handle;'),
        ('wrong_runtime_type', 'd.runtime_type = ACTION_FAMILY_1B_RUNTIME_TYPE;', 'd.runtime_type = UINT8_C(0x1a);'),
    ]
    reasons = ('native decoder rejected original-valid fixture', 'decoded field mismatch',
        'native body_length/original cursor mismatch', 'decoded body/view mismatch',
        'decoded dependency count mismatch', 'original/native object mismatch',
        'original/native allocation rule mismatch', 'original/native cursor mismatch',
        'original/native owner fields mismatch', 'tail acceptance mismatch', 'tail count mismatch',
        'native short-body safety rejection mismatch', 'native negative-count safety rejection mismatch',
        'tail body_length mismatch', 'tail view mismatch', 'tail rejection mutated output',
        'original/native constructed view mismatch', 'native mutated input', 'short-body rejection mutated output',
        'negative-count rejection mutated output', 'original/native array mismatch')
    results = []
    for name, old, new in mutants:
        if source.count(old) != 1: raise RuntimeError(f'mutation anchor not unique: {name}')
        changed = source.replace(old, new)
        src, lib = directory/f'{name}.c', directory/f'{name}.dylib'
        with src.open('x') as output: output.write(changed)
        run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
            '-I', str(PROJECT/'src'), str(src), '-o', str(lib)], capture_output=True, text=True)
        if run.returncode: raise RuntimeError(f'mutant build failed: {name}: {run.stderr[:1000]}')
        run = subprocess.run([sys.executable, str(PROJECT/'tests/action_family_1b_original_oracle.py'),
            '--native-library', str(lib), '--result', str(directory/f'{name}.oracle.json')],
            capture_output=True, text=True)
        for label, value in [('stdout', run.stdout), ('stderr', run.stderr)]:
            with (directory/f'{name}.{label}.log').open('x') as output: output.write(value)
        reason = run.stderr.strip().splitlines()[-1] if run.stderr.strip() else ''
        if run.returncode <= 0 or 'OracleError:' not in reason or not any(s in reason for s in reasons):
            raise RuntimeError(f'oracle did not reject mutant for explicit parity/safety reason: {name}: {reason}')
        results.append(dict(name=name, detected=True, oracle_exit=run.returncode, reason=reason,
                            source_sha256=sha(changed.encode()), native_sha256=sha(lib.read_bytes())))
    report = dict(slice='A-1B.1', status='pass', compiled_mutants_detected=len(results), results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT/'tests/action_family_1b_original_oracle.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output: json.dump(report, output, indent=2); output.write('\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results), result=str(result_path))))


if __name__ == '__main__':
    main()
