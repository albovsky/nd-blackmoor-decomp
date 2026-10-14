#!/usr/bin/env python3
"""Compile real mutants and require the shipped original oracle to detect them.

Use oracle-python with JIT permitted. Each invocation owns a unique private
directory; source, libraries, reports and logs never overwrite other evidence.
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
    directory = Path(tempfile.mkdtemp(prefix='A-94.1.mutants-', dir=PRIVATE))
    result_path = args.result or directory / 'report.json'
    if result_path.exists():
        raise RuntimeError('result path must be unique')
    source = (PROJECT / 'src/action_family_94.c').read_text()
    # Expected failure messages name an actual parity or safety assertion;
    # a crash, unrelated harness failure or mere nonzero exit does not count.
    mutants = [
        ('wrong_word_source_offset', 'd->word_21 = read_le32(raw + 0x21u);',
         'd->word_21 = read_le32(raw + 0x22u);', 'decoded neutral field mismatch'),
        ('wrong_final_byte_offset', 'd->option_31 = raw[0x31u];',
         'd->option_31 = raw[0x30u];', 'decoded neutral field mismatch'),
        ('wrong_typed_body_rule', 'd->body_bytes = ACTION_FAMILY_94_BODY_BYTES;',
         'd->body_bytes = 51u;', 'decoded body/tail mismatch'),
        ('wrong_constructor_field_offset',
         'write_le32(result.object_bytes + 0x21u, decoded.word_21);',
         'write_le32(result.object_bytes + 0x22u, decoded.word_21);', 'original/native object mismatch'),
        ('wrong_constructor_allocation_constant',
         'result.allocation_bytes = ACTION_FAMILY_94_OBJECT_BYTES;',
         'result.allocation_bytes = 51u;', 'original/native slot/constants mismatch'),
        ('wrong_constructor_cursor_constant',
         'result.payload_offset_after = payload_offset_before + UINT32_C(50);',
         'result.payload_offset_after = payload_offset_before + UINT32_C(51);',
         'original/native cursor/tail mismatch'),
        ('wrong_runtime_type_constant', 'result.runtime_type = ACTION_FAMILY_94_RUNTIME_TYPE;',
         'result.runtime_type = UINT8_C(0x93);', 'original/native slot/constants mismatch'),
        ('wrong_tail_modulus',
         'ACTION_FAMILY_94_DEPENDENCY_BYTES != 0u)', '8u != 0u)',
         'original/native tail accept/reject mismatch'),
        ('wrong_tail_count',
         'd->dependency_count = d->dependency_bytes / ACTION_FAMILY_94_DEPENDENCY_BYTES;',
         'd->dependency_count = d->dependency_bytes / 32u;',
         'original/native stored tail count mismatch'),
        ('wrong_short_body_guard', 'length < ACTION_FAMILY_94_BODY_BYTES',
         'length == 0u', 'native short-body safety mismatch'),
    ]
    results = []
    for name, old, new, expected_reason in mutants:
        if source.count(old) != 1:
            raise RuntimeError(f'mutation anchor not unique: {name}')
        changed = source.replace(old, new)
        src, lib = directory / f'{name}.c', directory / f'{name}.dylib'
        src.write_text(changed)
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
            '-I', str(PROJECT / 'src'), str(src), '-o', str(lib)],
            check=True, capture_output=True, text=True)
        # Exercise the dependency count mutant against the original stored
        # count before the ordinary synthetic object check can detect it.
        run = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_94_original_oracle.py'),
            '--native-library', str(lib), '--result', str(directory / f'{name}.oracle.json')],
            capture_output=True, text=True)
        (directory / f'{name}.stdout.log').write_text(run.stdout)
        (directory / f'{name}.stderr.log').write_text(run.stderr)
        reason = run.stderr.strip().splitlines()[-1] if run.stderr.strip() else ''
        if run.returncode == 0 or 'OracleError:' not in reason or expected_reason not in reason:
            raise RuntimeError(f'oracle failed to detect mutant for its expected reason: {name}: {reason}')
        results.append(dict(name=name, detected=True, oracle_exit=run.returncode, reason=reason,
                            source_sha256=sha(changed.encode()), native_library_sha256=sha(lib.read_bytes())))
    report = dict(slice='A-94.1', status='pass', compiled_mutants_detected=len(results), results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT / 'tests/action_family_94_original_oracle.py').read_bytes()),
        evidence_directory=str(directory), original_decisions_replaced=False)
    with result_path.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', compiled_mutants_detected=len(results), receipt=str(result_path))))


if __name__ == '__main__':
    main()
