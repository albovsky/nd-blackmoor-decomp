#!/usr/bin/env python3
"""Compile isolated mutations and require the immutable x86 oracle to reject.

All build/log/report paths are unique; no shipped native library is replaced.
Run with the packet's oracle Python and Unicorn JIT permitted.
"""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[3]
SRC = ROOT / 'outputs/blackmoor-decomp/src'
PRIVATE = ROOT / 'work/analysis/slices'
ORACLE = ROOT / 'outputs/blackmoor-decomp/tests/action_family_0c_original_oracle.py'
MUTATIONS = [
    ('prefix-word-offset', 'read_u16_le(raw_body + i * 2u)', 'read_u16_le(raw_body + 2u + i * 2u)'),
    ('count-field-offset', 'count = read_u16_le(raw_body + 8u);', 'count = read_u16_le(raw_body + 6u);'),
    ('table-stride', 'ACTION_FAMILY_0C_RECORD18_BYTES * (size_t)count', '16u * (size_t)count'),
    ('record-field-offset', 'read_u16_le(decoded.records_18 + index * ACTION_FAMILY_0C_RECORD18_BYTES + i * 2u)',
     'read_u16_le(decoded.records_18 + index * ACTION_FAMILY_0C_RECORD18_BYTES + ((i + 1u) % 9u) * 2u)'),
    ('record-view-offset', 'decoded->records_18 = raw_body + ACTION_FAMILY_0C_PREFIX_BYTES;',
     'decoded->records_18 = raw_body + ACTION_FAMILY_0C_PREFIX_BYTES + 2u;'),
    ('tail-modulus', '(length - typed) % ACTION_FAMILY_0C_DEPENDENCY_BYTES', '(length - typed) % 8u'),
    ('tail-count', '(length - typed) / ACTION_FAMILY_0C_DEPENDENCY_BYTES', '(length - typed) / 8u'),
    ('short-body-guard', 'if (length < typed) {', 'if (length < typed && length == 0u) {'),
    ('body-length-result', 'memcpy(out, &decoded.body_bytes, sizeof(*out));',
     'decoded.body_bytes += 2u; memcpy(out, &decoded.body_bytes, sizeof(*out));'),
    ('count-size-narrowing-bound', 'if (count > ACTION_FAMILY_0C_MAX_COUNT) {', 'if (count > 32767u) {'),
    ('constructor-destination-field-offset', 'memcpy(object_bytes, raw_body, decoded.body_bytes);',
     'memcpy(object_bytes + 2u, raw_body, decoded.body_bytes - 2u);'),
    ('constructor-prefix-field-offset', 'memcpy(object_bytes, raw_body, decoded.body_bytes);',
     'memcpy(object_bytes, raw_body, decoded.body_bytes); object_bytes[0] = raw_body[2];'),
    ('constructor-copy-size', 'memcpy(object_bytes, raw_body, decoded.body_bytes);',
     'memcpy(object_bytes, raw_body, decoded.body_bytes - 1u);'),
    ('constructor-cursor-constant', 'payload_offset_before + (uint32_t)decoded.body_bytes;',
     'payload_offset_before + (uint32_t)decoded.body_bytes + UINT32_C(2);'),
    ('constructor-allocation-constant', 'constructed.allocation_bytes = decoded.body_bytes;',
     'constructed.allocation_bytes = decoded.body_bytes + 2u;'),
    ('constructor-slot-field', 'constructed.result_slot_handle = output_handle;',
     'constructed.result_slot_handle = output_handle + UINT32_C(4);'),
    ('runtime-type-constant', 'decoded->runtime_type = ACTION_FAMILY_0C_RUNTIME_TYPE;',
     'decoded->runtime_type = UINT8_C(0x0b);'),
]


def sha(data): return hashlib.sha256(data).hexdigest()


def main():
    source_text = (SRC / 'action_family_0c.c').read_text()
    directory = Path(tempfile.mkdtemp(prefix='A-0C.1.mutations-', dir=PRIVATE))
    (directory / 'action_family_0c.h').write_bytes((SRC / 'action_family_0c.h').read_bytes())
    rows = []
    for label, old, new in MUTATIONS:
        if source_text.count(old) != 1: raise RuntimeError('nonunique mutation: ' + label)
        source, library, log = (directory / (label + ext) for ext in ('.c', '.dylib', '.log'))
        with source.open('x') as out: out.write(source_text.replace(old, new))
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
            '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib', str(source), '-o', str(library)], check=True)
        with log.open('x') as output:
            cp = subprocess.run([sys.executable, str(ORACLE), '--native-library', str(library),
                '--result', str(directory / (label + '.unexpected-result.json'))], stdout=output, stderr=subprocess.STDOUT)
        lines = log.read_text().splitlines()
        if cp.returncode != 1 or not lines or not any(marker in lines[-1] for marker in ('ParityMismatch:', 'TailMismatch:')):
            raise RuntimeError(f'mutation not rejected by a parity check: {label}; exit={cp.returncode}; log={log}')
        if (directory / (label + '.unexpected-result.json')).exists(): raise RuntimeError('mutant produced a success report')
        rows.append(dict(mutation=label, status='detected', exit_code=cp.returncode, parity_failure=lines[-1],
                         source_sha256=sha(source.read_bytes()), library_sha256=sha(library.read_bytes()), log_sha256=sha(log.read_bytes())))
    report = dict(status='pass', mutants=len(rows), detected=len(rows), mutations=rows,
                  original_source_sha256=sha((SRC / 'action_family_0c.c').read_bytes()),
                  oracle_sha256=sha(ORACLE.read_bytes()), script_sha256=sha(Path(__file__).read_bytes()))
    result = directory / 'report.json'
    with result.open('x') as out: out.write(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', mutants=len(rows), detected=len(rows), result=str(result), sha256=sha(result.read_bytes()))))


if __name__ == '__main__': main()
