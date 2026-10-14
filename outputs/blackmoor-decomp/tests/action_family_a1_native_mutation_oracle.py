#!/usr/bin/env python3
"""Compile actual wrong-offset/rule variants, then require oracle rejection."""
import hashlib
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT/'outputs/blackmoor-decomp'
PRIVATE = ROOT/'work/analysis/slices'


def main():
    source = (PROJECT/'src/action_family_a1.c').read_text()
    mutations = [
        ('wrong_word_source_offset', 'd->word_23 = read_u32(raw + 0x23u);',
         'd->word_23 = read_u32(raw + 0x24u);'),
        ('wrong_key_body_boundary', 'signed_word == -1 ? ACTION_FAMILY_A1_KEY_BODY_BYTES :',
         'signed_word == -1 ? ACTION_FAMILY_A1_KEY_BODY_BYTES - 1u :'),
        ('wrong_constructor_option_destination', 'write_u16(object + 0xa5u, d.option_2e);',
         'write_u16(object + 0xa5u, d.option_2c);'),
    ]
    results = []
    with tempfile.TemporaryDirectory(prefix='A-A1.1-mutants-',dir=PRIVATE) as directory:
        tmp = Path(directory)
        for name,old,new in mutations:
            if source.count(old)!=1:
                raise RuntimeError(f'mutation anchor not unique: {name}')
            mutated = source.replace(old,new)
            src,lib = tmp/f'{name}.c',tmp/f'{name}.dylib'
            src.write_text(mutated)
            subprocess.run(['xcrun','clang','-arch','arm64','-std=c11','-Wall','-Wextra',
                '-Wpedantic','-Werror','-O2','-fPIC','-dynamiclib','-I',str(PROJECT/'src'),
                str(src),'-o',str(lib)],check=True,capture_output=True)
            run = subprocess.run([sys.executable,str(PROJECT/'tests/action_family_a1_original_oracle.py'),
                '--native-library',str(lib),'--result',str(tmp/f'{name}.json')],capture_output=True,text=True)
            if run.returncode==0 or 'RuntimeError:' not in run.stderr:
                raise RuntimeError(f'oracle failed to detect compiled mutant: {name}: {run.stderr[-300:]}')
            reason = run.stderr.strip().splitlines()[-1]
            if not any(s in reason for s in ('mismatch record','rejected record')):
                raise RuntimeError(f'mutant failed for unrelated reason: {reason}')
            results.append(dict(name=name,detected=True,oracle_exit=run.returncode,reason=reason,
                source_sha256=hashlib.sha256(mutated.encode()).hexdigest()))
    report = dict(slice='A-A1.1',compiled_mutants_detected=len(results),results=results,
                  oracle_hooks='allocation only; same complete original/native comparator as normal run')
    (PRIVATE/'A-A1.1.mutations.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report))


if __name__=='__main__':
    main()
