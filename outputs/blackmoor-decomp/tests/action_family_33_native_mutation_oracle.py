#!/usr/bin/env python3
"""Compile wrong offsets/rules and require the shipped x86 oracle to detect them.

Each run owns a new private directory; explicit report paths must not exist.
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
SCRATCH = Path('/private/tmp')  # mutants and reports never touch canonical work/analysis/slices


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    directory = Path(tempfile.mkdtemp(prefix='A-33.1.mutants-', dir=SCRATCH))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_33.c').read_text()
    mod = '(length - extent) % ACTION_FAMILY_33_DEPENDENCY_BYTES != 0u'
    cnt = 'd->dependency_count = d->dependency_bytes / ACTION_FAMILY_33_DEPENDENCY_BYTES;'
    mutants = [
        # constructor/decoder field offsets and constants
        ('wrong_count_field_offset', 'a = u16(raw_body + 109u);', 'a = u16(raw_body + 108u);'),
        ('wrong_second_count_field_offset', 'b = u16(raw_body + 111u);', 'b = u16(raw_body + 110u);'),
        ('wrong_prefix_constant', 'extent = UINT32_C(113) +', 'extent = UINT32_C(112) +'),
        ('wrong_first_stride_constant', 'UINT32_C(6) * a', 'UINT32_C(4) * a'),
        ('wrong_count_stride_constant', 'UINT32_C(66) * b;', 'UINT32_C(64) * b;'),
        ('swapped_counts', 'extent = UINT32_C(113) + UINT32_C(6) * a + UINT32_C(66) * b;',
         'extent = UINT32_C(113) + UINT32_C(6) * b + UINT32_C(66) * a;'),
        ('wrong_dependency_pointer', 'd->dependency_records = raw_body + extent;', 'd->dependency_records = raw_body + extent + 1u;'),
        ('wrong_runtime_type', 'd->runtime_type = ACTION_FAMILY_33_RUNTIME_TYPE;', 'd->runtime_type = UINT8_C(0x37);'),
        ('wrong_raw_type', 'd->raw_type = ACTION_FAMILY_33_RAW_TYPE;', 'd->raw_type = UINT8_C(0x32);'),
        # dependency-tail modulus
        ('tail_modulus_removed', mod, '0'),
        ('wrong_tail_modulus', mod, '(length - extent) % 8u != 0u'),
        ('tail_modulus_below_4096_only', mod, '(length - extent) < 4096u && ' + mod),
        ('wrong_tail_count_divisor', cnt, 'd->dependency_count = d->dependency_bytes / 8u;'),
        ('tail_count_truncated_to_8_bits', cnt,
         'd->dependency_count = (uint8_t)(d->dependency_bytes / ACTION_FAMILY_33_DEPENDENCY_BYTES);'),
        ('tail_count_truncated_to_16_bits', cnt,
         'd->dependency_count = (uint16_t)(d->dependency_bytes / ACTION_FAMILY_33_DEPENDENCY_BYTES);'),
        ('tail_bytes_off_by_one', 'd->dependency_bytes = length - extent;', 'd->dependency_bytes = length - extent - 1u;'),
        # short-body guards
        ('missing_short_body_guard', 'if ((size_t)extent > length) return ACTION_FAMILY_33_ERR_BODY;',
         'if (length == 0u) return ACTION_FAMILY_33_ERR_BODY;'),
        # Guard against reading the count words of a body shorter than 113 bytes. Backed-memory
        # parity cannot see it (the later extent check returns the same status), so it is
        # checked by the exact-heap-buffer ASan/UBSan driver instead of the x86 oracle.
        ('missing_prefix_guard', 'if (length < ACTION_FAMILY_33_PREFIX_BYTES) return ACTION_FAMILY_33_ERR_BODY;',
         'if (length < 4u) return ACTION_FAMILY_33_ERR_BODY;', 'sanitizer'),
        ('body_guard_off_by_one', 'if ((size_t)extent > length) return ACTION_FAMILY_33_ERR_BODY;',
         'if ((size_t)extent > length + 1u) return ACTION_FAMILY_33_ERR_BODY;'),
        # count width / signedness / narrowing rule
        ('wrong_signed_count_width', 'if (a > INT16_MAX || b > INT16_MAX)', 'if (a > INT8_MAX || b > INT8_MAX)'),
        # Removing the explicit INT16_MAX count check is an EQUIVALENT mutant (any count >= 0x8000
        # already exceeds the 32767-byte extent bound), so it is deliberately not listed.
        ('wrong_narrowed_size_bound', 'extent > ACTION_FAMILY_33_MAX_BODY_BYTES', 'extent > UINT32_C(16777215)'),
        # 32765 is the largest reachable extent (113 + 6k; 32766/32767 are unreachable, so shifting
        # the bound by one there is an equivalent mutant); rejecting 32765 must be detected.
        ('largest_valid_extent_rejected', 'extent > ACTION_FAMILY_33_MAX_BODY_BYTES', 'extent > UINT32_C(32764)'),
        # constructor object model
        ('wrong_constructor_field_offset', 'memcpy(object_bytes, raw_body, decoded.body_bytes);',
         'memcpy(object_bytes + 1u, raw_body, decoded.body_bytes);'),
        ('constructor_copy_one_byte_short', 'memcpy(object_bytes, raw_body, decoded.body_bytes);',
         'memcpy(object_bytes, raw_body, decoded.body_bytes - 1u);'),
        ('wrong_constructor_allocation_constant', 'constructed.output_allocation_bytes = (uint32_t)decoded.body_bytes;',
         'constructed.output_allocation_bytes = (uint32_t)decoded.body_bytes + UINT32_C(1);'),
        ('wrong_constructor_cursor_constant',
         'constructed.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;',
         'constructed.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes + UINT32_C(1);'),
        ('wrong_constructor_result_slot', 'constructed.result_slot_handle = output_handle;', 'constructed.result_slot_handle = 0u;'),
    ]
    results = []
    parity_reasons = ('native rejected', 'body_length/original cursor mismatch', 'decoded neutral field mismatch',
        'decoded body/tail mismatch', 'acceptance mismatch', 'count/body mismatch',
        'original/native allocation mismatch', 'original/native allocation rule mismatch',
        'original/native cursor/body rule mismatch', 'native short-body safety status mismatch',
        'native count safety status mismatch', 'native constructor rejected', 'native object guard changed',
        'native changed input', 'native borrowed dependency span mismatch', 'ragged rejection changed native output',
        'reviewed corpus typed boundary mismatch', 'native body_length mismatch')
    for name, old, new, *channel in mutants:
        if source.count(old) != 1:
            raise RuntimeError(f'mutation anchor not unique: {name}')
        changed = source.replace(old, new)
        src, lib = directory / f'{name}.c', directory / f'{name}.dylib'
        src.write_text(changed)
        if channel == ['sanitizer']:
            exe = directory / f'{name}.asan'
            subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11', '-g', '-O1',
                '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-I', str(PROJECT / 'src'),
                str(PROJECT / 'tests/action_family_33_sanitizer.c'), str(src), '-o', str(exe)],
                check=True, capture_output=True)
            run = subprocess.run([str(exe)], capture_output=True, text=True,
                                 env=dict(ASAN_OPTIONS='detect_leaks=0:abort_on_error=0'))
            (directory / f'{name}.stderr.log').write_text(run.stderr)
            if run.returncode == 0 or not ('AddressSanitizer' in run.stderr or 'runtime error' in run.stderr):
                raise RuntimeError(f'sanitizer driver failed to reject mutant: {name}')
            results.append(dict(name=name, detected=True, channel='asan_ubsan_exact_heap_driver',
                                sanitizer_exit=run.returncode, source_sha256=sha(changed.encode())))
            continue
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
            '-I', str(PROJECT / 'src'), str(src), '-o', str(lib)], check=True, capture_output=True)
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_33_original_oracle.py'),
            '--native-library', str(lib), '--result', str(directory / f'{name}.oracle.json')],
            capture_output=True, text=True)
        (directory / f'{name}.stdout.log').write_text(run.stdout)
        (directory / f'{name}.stderr.log').write_text(run.stderr)
        reason = run.stderr.strip().splitlines()[-1] if run.stderr.strip() else ''
        if run.returncode == 0 or not any(s in reason for s in parity_reasons) or not any(
                s in reason for s in ('OracleError:', 'TailMismatch:')):
            raise RuntimeError(f'oracle failed to reject mutant for an explicit parity/safety reason: {name}: {reason}')
        results.append(dict(name=name, detected=True, channel='x86_oracle', oracle_exit=run.returncode, reason=reason,
                            source_sha256=sha(changed.encode()), native_library_sha256=sha(lib.read_bytes())))
    report = dict(slice='A-33.1', status='pass', compiled_mutants_detected=len(results), results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT / 'tests/action_family_33_original_oracle.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results), receipt=str(result_path))))


if __name__ == '__main__':
    main()
