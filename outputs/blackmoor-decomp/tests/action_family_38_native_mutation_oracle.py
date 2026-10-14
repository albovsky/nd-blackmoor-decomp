#!/usr/bin/env python3
"""Compile wrong native rules/offsets and require original-x86 oracle rejection.

Every run gets its own private directory. Each oracle invocation receives a
unique result path; unrelated failures do not count as mutation detection.
"""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT=Path(__file__).resolve().parents[3]
PROJECT=ROOT/'outputs/blackmoor-decomp'
PRIVATE=ROOT/'work/analysis/slices'


def main():
    directory=Path(tempfile.mkdtemp(prefix='A-38.1.mutations-',dir=PRIVATE))
    source=(PROJECT/'src/action_family_38.c').read_text()
    variants=[
        ('wrong_frame_count_rule', '(int32_t)read_i16(raw + 0x33u) + 1;',
         '(int32_t)read_i16(raw + 0x33u) + 0;'),
        ('wrong_option_source_offset', 'd->option_23 = read_u16(raw + 0x23u);',
         'd->option_23 = read_u16(raw + 0x24u);'),
        ('wrong_constructor_destination', 'write_u16(object + 0x3du, d.option_2d);',
         'write_u16(object + 0x3bu, d.option_2d);'),
        ('wrong_allocation_clear_extent', 'memset(object, 0, 0xacu);',
         'memset(object, 0, ACTION_FAMILY_38_OBJECT_BYTES);'),
    ]
    results=[]
    for name,old,new in variants:
        if source.count(old)!=1:raise RuntimeError(f'mutation anchor not unique: {name}')
        src=directory/f'{name}.c';lib=directory/f'{name}.dylib'
        src.write_text(source.replace(old,new))
        subprocess.run(['xcrun','--sdk','macosx','clang','-arch','arm64','-std=c11',
            '-Wall','-Wextra','-Wpedantic','-Werror','-O2','-fPIC','-dynamiclib',
            '-I',str(PROJECT/'src'),str(src),'-o',str(lib)],check=True,capture_output=True)
        run=subprocess.run([sys.executable,str(PROJECT/'tests/action_family_38_original_oracle.py'),
            '--native-library',str(lib),'--result',str(directory/f'{name}.json')],capture_output=True,text=True)
        (directory/f'{name}.log').write_text(run.stdout+run.stderr)
        reason=run.stderr.strip().splitlines()[-1] if run.stderr else ''
        if run.returncode==0 or not reason.startswith('RuntimeError:') or not any(
            text in reason for text in ('mismatch record','rejected record')):
            raise RuntimeError(f'mutant failed for an unrelated reason: {name}: {reason}')
        results.append(dict(name=name,detected=True,oracle_exit=run.returncode,reason=reason,
            source_sha256=hashlib.sha256(src.read_bytes()).hexdigest(),
            library_sha256=hashlib.sha256(lib.read_bytes()).hexdigest()))
    report=dict(slice='A-38.1',compiled_mutants_detected=len(results),results=results,
        oracle_script_sha256=hashlib.sha256((PROJECT/'tests/action_family_38_original_oracle.py').read_bytes()).hexdigest())
    path=directory/'report.json'
    path.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(compiled_mutants_detected=len(results),report=str(path),results=results)))


if __name__=='__main__':
    main()
