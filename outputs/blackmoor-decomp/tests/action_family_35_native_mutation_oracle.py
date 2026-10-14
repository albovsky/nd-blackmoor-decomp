#!/usr/bin/env python3
"""Compile isolated native mutations; immutable original oracle must reject each.

Run with work/tools/oracle-python/bin/python and Unicorn JIT permitted. Mutants
and logs stay in unique A-35.1 private evidence paths, never replace source/build.
"""
import hashlib
import json
import subprocess
import sys
from pathlib import Path

ROOT=Path(__file__).resolve().parents[3]
SRC=ROOT/'outputs/blackmoor-decomp/src'
PRIVATE=ROOT/'work/analysis/slices'
ORACLE=ROOT/'outputs/blackmoor-decomp/tests/action_family_35_original_oracle.py'
MUTATIONS=[
    ('wrong-fixed-word-offset',
     'read_u16_le(raw_body + 0x21u + i * 2u)',
     'read_u16_le(raw_body + 0x23u + i * 2u)', 'decoded field/view mismatch'),
    ('wrong-first-array-stride',
     'ACTION_FAMILY_35_RECORD6_BYTES * (size_t)n',
     '4u * (size_t)n', 'native decoder rejected'),
    ('wrong-second-array-size',
     'ACTION_FAMILY_35_RECORD34_BYTES * (size_t)m',
     '32u * (size_t)m', 'native decoder rejected'),
    ('wrong-first-record-offset',
     'decoded->records_6 = raw_body + ACTION_FAMILY_35_PREFIX_BYTES;',
     'decoded->records_6 = raw_body + ACTION_FAMILY_35_PREFIX_BYTES + 2u;',
     'decoded field/view mismatch'),
    ('wrong-object-copy-rule',
     'memcpy(object_bytes, raw_body, decoded.body_bytes);',
     'memcpy(object_bytes, raw_body, decoded.body_bytes - 1u);',
     'whole original/native object mismatch'),
]


def sha(data):return hashlib.sha256(data).hexdigest()


def main():
    original=(SRC/'action_family_35.c').read_text()
    header=(SRC/'action_family_35.h').read_bytes()
    directory=PRIVATE/'A-35.1.mutants';directory.mkdir(exist_ok=True)
    (directory/'action_family_35.h').write_bytes(header)
    rows=[]
    for label,old,new,expect in MUTATIONS:
        if original.count(old)!=1:raise RuntimeError(f'mutation source not unique: {label}')
        source=directory/f'{label}.c';library=directory/f'{label}.dylib';log=directory/f'{label}.log'
        source.write_text(original.replace(old,new))
        subprocess.run(['xcrun','--sdk','macosx','clang','-arch','arm64','-std=c11',
            '-Wall','-Wextra','-Wpedantic','-Werror','-O2','-fPIC','-dynamiclib',str(source),'-o',str(library)],check=True)
        with log.open('w') as out:
            cp=subprocess.run([sys.executable,str(ORACLE),'--native-library',str(library),
                '--result',str(directory/f'{label}.unexpected-result.json')],stdout=out,stderr=subprocess.STDOUT)
        output=log.read_text()
        if cp.returncode!=1 or expect not in output:
            raise RuntimeError(f'oracle did not detect {label} as expected: exit {cp.returncode}; see {log}')
        rows.append(dict(mutation=label,status='detected',exit_code=cp.returncode,
            expected_failure=expect,native_sha256=sha(library.read_bytes()),source_sha256=sha(source.read_bytes()),
            log_sha256=sha(log.read_bytes())))
    result=dict(status='pass',mutants=len(rows),detected=len(rows),mutations=rows,
        original_native_source_sha256=sha((SRC/'action_family_35.c').read_bytes()),
        oracle_sha256=sha(ORACLE.read_bytes()),helper_sha256=sha(Path(__file__).read_bytes()))
    (PRIVATE/'A-35.1.mutations.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(status='pass',mutants=len(rows),detected=len(rows))))


if __name__=='__main__':main()
