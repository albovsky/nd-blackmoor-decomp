#!/usr/bin/env python3
"""Compile real source mutants; require the original oracle to reject each.

Every mutant, library, log and receipt gets a unique private directory. Never
writes the normal oracle receipt or another slice's paths. Use oracle-python.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT=Path(__file__).resolve().parents[3]
PROJECT=Path(__file__).resolve().parents[1]
PRIVATE=ROOT/'work/analysis/slices'

def sha(data):return hashlib.sha256(data).hexdigest()

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--result',type=Path);args=ap.parse_args()
    directory=Path(tempfile.mkdtemp(prefix='A-3F.1.mutants-',dir=PRIVATE))
    if args.result is None:args.result=directory/'result.json'
    source=(PROJECT/'src/action_family_3f.c').read_text()
    mutants=[
        ('wrong_option_source','d.option_21 = u16(raw_body + 33u);','d.option_21 = u16(raw_body + 34u);'),
        ('wrong_primary_stride','extent = 2u + (size_t)count * 5u + 68u;',
         'extent = 2u + (size_t)count * 4u + 68u;'),
        ('wrong_constructor_default','put16(arena + 0x21u, 12u);','put16(arena + 0x21u, 11u);'),
        ('wrong_secondary_count_width','if (secondary > INT8_MAX)',
         'if (u16(raw_body + cursor) > INT8_MAX)'),
    ]
    results=[]
    for name,old,new in mutants:
        if source.count(old)!=1:raise RuntimeError(f'mutation anchor not unique: {name}')
        changed=source.replace(old,new);src=directory/f'{name}.c';lib=directory/f'{name}.dylib'
        src.write_text(changed)
        subprocess.run(['xcrun','--sdk','macosx','clang','-arch','arm64','-std=c11','-Wall','-Wextra',
            '-Wpedantic','-Werror','-O2','-fPIC','-dynamiclib','-I',str(PROJECT/'src'),str(src),'-o',str(lib)],
            check=True,capture_output=True)
        oracle_result=directory/f'{name}.oracle.json'
        run=subprocess.run([sys.executable,str(PROJECT/'tests/action_family_3f_original_oracle.py'),
            '--native-library',str(lib),'--result',str(oracle_result)],capture_output=True,text=True)
        (directory/f'{name}.stdout.log').write_text(run.stdout)
        (directory/f'{name}.stderr.log').write_text(run.stderr)
        reason=run.stderr.strip().splitlines()[-1] if run.stderr.strip() else ''
        if run.returncode==0 or 'OracleError:' not in reason or not any(s in reason for s in (
            'original/native allocation mismatch','allocation rule mismatch','cursor/body rule mismatch',
            'native decoder rejected','native layout query rejected','decoded neutral fields mismatch')):
            raise RuntimeError(f'oracle failed to detect mutant for parity reason: {name}: {reason}')
        results.append(dict(name=name,detected=True,oracle_exit=run.returncode,reason=reason,
            source_sha256=sha(changed.encode()),native_library_sha256=sha(lib.read_bytes())))
    report=dict(slice='A-3F.1',status='pass',compiled_mutants_detected=len(results),results=results,
        baseline_source_sha256=sha(source.encode()),
        oracle_script_sha256=sha((PROJECT/'tests/action_family_3f_original_oracle.py').read_bytes()),
        evidence_directory=str(directory),original_decisions_replaced=False)
    args.result.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'status':'pass','compiled_mutants_detected':len(results),'receipt':str(args.result)}))

if __name__=='__main__':main()
