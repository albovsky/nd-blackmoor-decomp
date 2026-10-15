#!/usr/bin/env python3
"""Compiled decoder/constructor/tail mutants must fail the shipped raw-0x2d checks.

Use oracle-python with Unicorn JIT allowed. Every mutant source, library, report
and log goes to one unique directory under /private/tmp; nothing in the
canonical evidence tree is touched except an explicitly named --result path.
Three detectors: the original-x86 oracle (rule and parity mutants), the unit
fixtures (argument/span validation mutants, which the original cannot judge) and
the ASan/UBSan harness (missing bound guards).
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

PROJECT = Path(__file__).resolve().parents[1]
CLANG = ['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
         '-Wall', '-Wextra', '-Wpedantic', '-Werror']


def sha(data):
    return hashlib.sha256(data).hexdigest()


C, H = 'c', 'h'
DEP = 'ACTION_FAMILY_2D_DEPENDENCY_BYTES'
MODULUS = f'if ((length - lay->body_bytes) % {DEP} != 0u) {{'
COUNT = f'd.dependency_count = d.dependency_bytes / {DEP};'
# (name, tier, stage, file, old, new, expected reason substring)
MUTANTS = [
    # --- body rule and layout offsets (oracle) ---
    ('entry_count_offset', 'oracle', 'quick', C, 'entries = read_i16_le(raw + 0x23u);',
     'entries = read_i16_le(raw + 0x24u);', 'native decoder rejected'),
    ('group_count_offset', 'oracle', 'quick', C, 'groups = read_i16_le(raw + 0x25u);',
     'groups = read_i16_le(raw + 0x24u);', 'native decoder rejected'),
    ('record_count_offset_in_walk', 'oracle', 'quick', C, 'n = read_i16_le(raw + cursor + 0x2fu);',
     'n = read_i16_le(raw + cursor + 0x2eu);', 'native decoder rejected'),
    ('entry_walk_stride_wrong', 'oracle', 'quick', C,
     'cursor += ACTION_FAMILY_2D_ENTRY_FILE_BYTES +\n            ACTION_FAMILY_2D_RECORD35_BYTES * (size_t)read_i16_le(raw + cursor + 0x2fu);',
     'cursor += ACTION_FAMILY_2D_ENTRY_FILE_BYTES - 1u +\n            ACTION_FAMILY_2D_RECORD35_BYTES * (size_t)read_i16_le(raw + cursor + 0x2fu);',
     'decoded entry'),
    ('header_constant_38', 'oracle', 'quick', H, '#define ACTION_FAMILY_2D_HEADER_BYTES 39u',
     '#define ACTION_FAMILY_2D_HEADER_BYTES 38u', 'native decoder rejected'),
    ('entry_constant_48', 'oracle', 'quick', H, '#define ACTION_FAMILY_2D_ENTRY_FILE_BYTES 49u',
     '#define ACTION_FAMILY_2D_ENTRY_FILE_BYTES 48u', 'native decoder rejected'),
    ('record35_constant_34', 'oracle', 'quick', H, '#define ACTION_FAMILY_2D_RECORD35_BYTES 35u',
     '#define ACTION_FAMILY_2D_RECORD35_BYTES 34u', 'native decoder rejected'),
    ('record34_constant_33', 'oracle', 'quick', H, '#define ACTION_FAMILY_2D_RECORD34_BYTES 34u',
     '#define ACTION_FAMILY_2D_RECORD34_BYTES 33u', 'native decoder rejected'),
    ('entry_object_constant_52', 'oracle', 'quick', H, '#define ACTION_FAMILY_2D_ENTRY_OBJECT_BYTES 53u',
     '#define ACTION_FAMILY_2D_ENTRY_OBJECT_BYTES 52u', 'native'),
    ('negative_header_counts_accepted', 'oracle', 'quick', C, 'if (entries < 0 || groups < 0) {',
     'if (0) {', 'native did not reject with ERR_COUNT'),
    ('negative_group_count_accepted', 'oracle', 'quick', C, 'if (entries < 0 || groups < 0) {',
     'if (entries < 0) {', 'native did not reject with ERR_COUNT'),
    ('negative_record_count_accepted', 'oracle', 'quick', C,
     'if (n < 0) {\n            return ACTION_FAMILY_2D_ERR_COUNT;', 'if (0) {\n            return ACTION_FAMILY_2D_ERR_COUNT;',
     'native did not reject with ERR_COUNT'),
    ('entry_count_sign_masked', 'oracle', 'quick', C, 'entries = read_i16_le(raw + 0x23u);',
     'entries = (int16_t)(read_u16_le(raw + 0x23u) & 0x7fffu);', 'native did not reject with ERR_COUNT'),
    ('record35_total_wrong', 'oracle', 'quick', C, 'total += (size_t)n;', 'total += 1u;', 'decoded header mismatch'),
    ('decoded_body_extent_wrong', 'oracle', 'quick', C, 'd.body_bytes = lay.body_bytes;',
     'd.body_bytes = lay.body_bytes - 1u;', 'decoded body/tail mismatch'),
    ('dependency_view_offset_wrong', 'oracle', 'quick', C, 'd.dependency_records = raw_body + lay.body_bytes;',
     'd.dependency_records = raw_body + lay.body_bytes - 1u;', 'decoded body/tail mismatch'),
    ('body_length_wrong', 'oracle', 'quick', C, '*body_bytes = lay.body_bytes;',
     '*body_bytes = lay.body_bytes - 1u;', 'body_length/original cursor mismatch'),
    ('name_offset_wrong', 'oracle', 'quick', C, 'memcpy(d.name, raw_body, sizeof(d.name));',
     'memcpy(d.name, raw_body + 1, sizeof(d.name));', 'decoded header mismatch'),
    ('word21_offset_wrong', 'oracle', 'quick', C, 'd.word_21 = read_u16_le(raw_body + 0x21u);',
     'd.word_21 = read_u16_le(raw_body + 0x20u);', 'decoded header mismatch'),
    ('entry_dword25_offset_wrong', 'oracle', 'quick', C, 'e.dword_25 = read_u32_le(p + 0x25u);',
     'e.dword_25 = read_u32_le(p + 0x26u);', 'decoded entry'),
    ('entry_word2d_offset_wrong', 'oracle', 'quick', C, 'e.word_2d = read_u16_le(p + 0x2du);',
     'e.word_2d = read_u16_le(p + 0x2eu);', 'decoded entry'),
    ('record35_stride_wrong', 'oracle', 'quick', C,
     'record_index * ACTION_FAMILY_2D_RECORD35_BYTES, sizeof(r.bytes));',
     'record_index * 34u, sizeof(r.bytes));', 'record35 mismatch'),
    ('record34_start_wrong', 'oracle', 'quick', C,
     'memcpy(r.bytes, raw_body + lay.body_bytes - lay.records_34_bytes +',
     'memcpy(r.bytes, raw_body + lay.body_bytes - lay.records_34_bytes - 1u +', 'record34 mismatch'),
    # --- constructor (oracle) ---
    ('entry_handle_index_wrong', 'oracle', 'quick', C, 'write_u32_le(entry + ACTION_FAMILY_2D_ENTRY_FILE_BYTES, handles[2u + i]);',
     'write_u32_le(entry + ACTION_FAMILY_2D_ENTRY_FILE_BYTES, handles[1u + i]);', 'allocation image mismatch'),
    ('entry_pointer_offset_wrong', 'oracle', 'quick', C, 'write_u32_le(entry + ACTION_FAMILY_2D_ENTRY_FILE_BYTES, handles[2u + i]);',
     'write_u32_le(entry + ACTION_FAMILY_2D_ENTRY_FILE_BYTES - 1u, handles[2u + i]);', 'allocation image mismatch'),
    ('record_block_source_wrong', 'oracle', 'quick', C,
     'memcpy(image + blocks, raw_body + cursor + ACTION_FAMILY_2D_ENTRY_FILE_BYTES, records);',
     'memcpy(image + blocks, raw_body + cursor + ACTION_FAMILY_2D_ENTRY_FILE_BYTES - 1u, records);',
     'allocation image mismatch'),
    ('group_block_source_wrong', 'oracle', 'quick', C, 'memcpy(image + blocks, raw_body + cursor, lay.records_34_bytes);',
     'memcpy(image + blocks, raw_body + cursor - 1u, lay.records_34_bytes);', 'allocation image mismatch'),
    ('header_block_truncated', 'oracle', 'quick', C, 'memcpy(image, raw_body, ACTION_FAMILY_2D_HEADER_BYTES);',
     'memcpy(image, raw_body, ACTION_FAMILY_2D_HEADER_BYTES - 1u);', 'allocation image mismatch'),
    ('owner_group_handle_wrong', 'oracle', 'quick', C, 'c.owner_group_handle = handles[handle_count - 1u];',
     'c.owner_group_handle = handles[handle_count - 2u];', 'owner/slot metadata mismatch'),
    ('owner_table_handle_wrong', 'oracle', 'quick', C, 'c.owner_entry_table_handle = handles[1];',
     'c.owner_entry_table_handle = handles[0];', 'owner/slot metadata mismatch'),
    ('owner_action_index_zero_extended', 'oracle', 'quick', C, 'c.owner_action_index = (int32_t)action_index;',
     'c.owner_action_index = (int32_t)(uint16_t)action_index;', 'owner/slot metadata mismatch'),
    ('result_slot_handle_wrong', 'oracle', 'quick', C, 'c.result_slot_handle = handles[0];',
     'c.result_slot_handle = handles[1];', 'owner/slot metadata mismatch'),
    ('payload_offset_after_wrong', 'oracle', 'quick', C,
     'c.payload_offset_after = payload_offset_before + (uint32_t)lay.body_bytes; /* wraps */',
     'c.payload_offset_after = payload_offset_before + (uint32_t)lay.body_bytes - 1u;', 'cursor/body rule mismatch'),
    ('allocation_count_wrong', 'oracle', 'quick', C, 'c.allocation_count = handle_count;',
     'c.allocation_count = handle_count - 1u;', 'cursor/body rule mismatch'),
    ('image_bytes_wrong', 'oracle', 'quick', C, 'c.image_bytes = image_bytes;', 'c.image_bytes = image_bytes - 1u;',
     'cursor/body rule mismatch'),
    ('runtime_type_wrong', 'oracle', 'quick', H, '#define ACTION_FAMILY_2D_RUNTIME_TYPE UINT8_C(0x2d)',
     '#define ACTION_FAMILY_2D_RUNTIME_TYPE UINT8_C(0x2e)', 'owner/slot metadata mismatch'),
    # --- dependency tail boundary (oracle, original 0x424aa8) ---
    ('tail_modulus_removed', 'oracle', 'tail', C, MODULUS, 'if (0u) {', 'acceptance mismatch'),
    ('tail_modulus_8', 'oracle', 'tail', C, MODULUS,
     'if ((length - lay->body_bytes) % 8u != 0u) {', 'acceptance mismatch'),
    ('tail_modulus_below_4096_only', 'oracle', 'tail', C, MODULUS,
     f'if ((length - lay->body_bytes) % {DEP} != 0u &&\n        length - lay->body_bytes < 4096u) {{', 'acceptance mismatch'),
    ('tail_count_truncated_to_8_bits', 'oracle', 'tail', C, COUNT,
     f'd.dependency_count = (uint8_t)(d.dependency_bytes / {DEP});', 'count/body mismatch'),
    ('tail_count_truncated_to_16_bits', 'oracle', 'tail', C, COUNT,
     f'd.dependency_count = (uint16_t)(d.dependency_bytes / {DEP});', 'count/body mismatch'),
    ('tail_count_wrong_divisor', 'oracle', 'tail', C, COUNT, 'd.dependency_count = d.dependency_bytes / 8u;',
     'count/body mismatch'),
    # --- short bodies (oracle, native safety status after the original 0x424aa8 run) ---
    ('short_header_guard_off_by_one', 'oracle', 'tail', C, 'if (length < ACTION_FAMILY_2D_HEADER_BYTES) {',
     'if (length < ACTION_FAMILY_2D_HEADER_BYTES - 1u) {', 'native short-body safety status mismatch'),
    ('short_record_guard_off_by_one', 'oracle', 'tail', C, 'if (length - cursor < need) {',
     'if (length - cursor + 1u < need) {', 'native short-body safety status mismatch'),
    ('short_group_guard_off_by_one', 'oracle', 'tail', C, 'if (length - cursor < lay->records_34_bytes) {',
     'if (length - cursor + 1u < lay->records_34_bytes) {', 'native short-body safety status mismatch'),
    ('short_group_guard_removed', 'oracle', 'tail', C, 'if (length - cursor < lay->records_34_bytes) {',
     'if (0) {', 'native short-body safety status mismatch'),
    # --- argument/span validation (unit fixtures; the original has no such contract) ---
    ('handle_count_check_removed', 'unit', None, C, 'if (handle_count != 3u + (size_t)lay.entry_count) {',
     'if (0) {', 'FAIL'),
    ('zero_handle_accepted', 'unit', None, C, 'if (handles[i] == 0u) {', 'if (0) {', 'FAIL'),
    ('capacity_off_by_one', 'unit', None, C, 'if (image_capacity < image_bytes) {',
     'if (image_capacity + 1u < image_bytes) {', 'FAIL'),
    ('input_overlap_check_removed', 'unit', None, C, 'if (overlap(raw, length, out, out_size)) {', 'if (0) {', 'FAIL'),
    ('input_wrap_check_removed', 'unit', None, C, 'if (!span_valid(raw, length) || !span_valid(out, out_size)) {',
     'if (0) {', 'FAIL'),
    ('construct_image_overlap_removed', 'unit', None, C, 'overlap(raw_body, raw_body_length, image, image_capacity) ||',
     '0 ||', 'FAIL'),
    ('entry_index_check_removed', 'unit', None, C, 'if (index >= (size_t)lay.entry_count) {', 'if (0) {', 'FAIL'),
    # --- missing bound guards are visible to the sanitizer harness ---
    ('sanitizer_entry_header_guard_off_by_one', 'sanitizer', None, C,
     'if (length - cursor < ACTION_FAMILY_2D_ENTRY_FILE_BYTES) {',
     'if (length - cursor + 1u < ACTION_FAMILY_2D_ENTRY_FILE_BYTES) {', 'sanitizer'),
    ('sanitizer_entry_guard_removed', 'sanitizer', None, C, 'if (length - cursor < need) {', 'if (0) {', 'sanitizer'),
    ('sanitizer_group_guard_removed', 'sanitizer', None, C, 'if (length - cursor < lay->records_34_bytes) {',
     'if (0) {', 'sanitizer'),
]


def build_mutant(directory, name, kind, old, new, source, header):
    work = directory / name
    work.mkdir()
    src_text, hdr_text = source, header
    target = src_text if kind == C else hdr_text
    if target.count(old) != 1:
        raise RuntimeError(f'mutation anchor not unique: {name} ({target.count(old)})')
    if kind == C:
        src_text = src_text.replace(old, new)
    else:
        hdr_text = hdr_text.replace(old, new)
    (work / 'action_family_2d.c').write_text(src_text)
    (work / 'action_family_2d.h').write_text(hdr_text)
    return work, src_text, hdr_text


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--result', type=Path)
    ap.add_argument('--only', action='append', help='run only named mutants (diagnostics)')
    ap.add_argument('--discover', action='store_true', help='print reasons instead of enforcing them')
    args = ap.parse_args()
    directory = Path(tempfile.mkdtemp(prefix='A-2D.1.mutants-', dir='/private/tmp'))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_2d.c').read_text()
    header = (PROJECT / 'src/action_family_2d.h').read_text()
    results = []
    for name, tier, stage, kind, old, new, expected in MUTANTS:
        if args.only and name not in args.only:
            continue
        work, src_text, hdr_text = build_mutant(directory, name, kind, old, new, source, header)
        lib = work / 'lib.dylib'
        reason = ''
        if tier in ('oracle', 'unit'):
            subprocess.run(CLANG + ['-O2', '-fPIC', '-dynamiclib', '-I', str(work),
                                    str(work / 'action_family_2d.c'), '-o', str(lib)],
                           check=True, capture_output=True)
        if tier == 'oracle':
            run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_2d_original_oracle.py'),
                                  '--native-library', str(lib), '--stage', stage,
                                  '--result', str(work / 'oracle.json')], capture_output=True, text=True)
            streams = (run.stdout, run.stderr)
            reason = run.stderr.strip().splitlines()[-1] if run.stderr.strip() else ''
            detected = (run.returncode != 0 and any(s in reason for s in ('OracleError:', 'TailMismatch:')))
        elif tier == 'unit':
            run = subprocess.run([sys.executable, '-m', 'unittest', 'discover', '-s', str(PROJECT / 'tests'),
                                  '-p', 'test_action_family_2d.py'], capture_output=True, text=True,
                                 env=dict(os.environ, A2D_NATIVE_LIBRARY=str(lib)))
            streams = (run.stdout, run.stderr)
            lines = [l for l in run.stderr.splitlines() if l.startswith(('FAIL:', 'ERROR:'))]
            detected = run.returncode != 0
            reason = 'FAIL ' + ('; '.join(lines[:3]) if lines else f'unit-test process crashed (exit {run.returncode})')
        else:
            binary = work / 'sanitizer'
            compile_run = subprocess.run(CLANG + ['-O1', '-g', '-fsanitize=address,undefined',
                                                  '-fno-omit-frame-pointer', '-I', str(work),
                                                  str(work / 'action_family_2d.c'),
                                                  str(PROJECT / 'tests/action_family_2d_sanitizer.c'),
                                                  '-o', str(binary)], capture_output=True, text=True)
            if compile_run.returncode:
                raise RuntimeError(f'sanitizer mutant failed to compile: {name}: {compile_run.stderr[:400]}')
            run = subprocess.run([str(binary)], capture_output=True, text=True,
                                 env=dict(os.environ, ASAN_OPTIONS='detect_leaks=0', UBSAN_OPTIONS='halt_on_error=1'))
            streams = (run.stdout, run.stderr)
            detected = run.returncode != 0
            first = next((l for l in run.stderr.splitlines() if 'ERROR' in l or 'Assertion' in l or 'runtime error' in l), '')
            reason = 'sanitizer exit ' + str(run.returncode) + (': ' + first[:160] if first else '')
        for suffix, content in zip(('stdout', 'stderr'), streams):
            (work / f'{suffix}.log').write_text(content)
        if args.discover:
            print(json.dumps(dict(name=name, tier=tier, detected=detected, reason=reason[:220])), flush=True)
        elif not detected or expected not in reason:
            raise RuntimeError(f'checks did not reject mutant for the expected reason: {name}: {reason}')
        results.append(dict(name=name, tier=tier, stage=stage, detected=detected, exit=run.returncode,
                            reason=reason, expected_reason=expected, source_sha256=sha(src_text.encode()),
                            header_sha256=sha(hdr_text.encode()),
                            native_library_sha256=sha(lib.read_bytes()) if lib.exists() else None))
    tiers = {t: sum(1 for r in results if r['tier'] == t and r['detected']) for t in ('oracle', 'unit', 'sanitizer')}
    report = dict(slice='A-2D.1', status='pass', compiled_mutants_detected=len(results),
        detected_by_tier=tiers, results=results,
        baseline_source_sha256=sha(source.encode()), baseline_header_sha256=sha(header.encode()),
        oracle_script_sha256=sha((PROJECT / 'tests/action_family_2d_original_oracle.py').read_bytes()),
        shared_tail_helper_sha256=sha((PROJECT / 'tests/tail_oracle_common.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results), detected_by_tier=tiers,
                         receipt=str(result_path), receipt_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
