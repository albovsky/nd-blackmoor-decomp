#!/usr/bin/env python3
"""Compile deliberate wrong rules; only an oracle parity/safety failure counts."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT=Path(__file__).resolve().parents[3]
PROJECT=ROOT/'outputs/blackmoor-decomp'
PRIVATE=ROOT/'work/analysis/slices'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    directory=Path(tempfile.mkdtemp(prefix='A-16.1.mutations-',dir=PRIVATE))
    shared=(PROJECT/'src/action_family_17.c').read_text()
    wrapper=(PROJECT/'src/action_family_16.c').read_text()
    variants=[
        ('count_source_offset','count = read_u16(raw + 0x14u);','count = read_u16(raw + 0x12u);'),
        ('typed_size_constant','ACTION_FAMILY_17_RECORD_BYTES * (size_t)count;',
            'ACTION_FAMILY_17_RECORD_BYTES * (size_t)count + 2u;'),
        ('record_view_offset','decoded->records = raw + ACTION_FAMILY_17_PREFIX_BYTES;',
            'decoded->records = raw + ACTION_FAMILY_17_PREFIX_BYTES + 2u;'),
        ('constructor_field_offset','write_u16(object_bytes + 0x14u, (uint16_t)decoded.count);',
            'write_u16(object_bytes + 0x12u, (uint16_t)decoded.count);'),
        ('constructor_allocation_constant','result.allocation_bytes = decoded.body_bytes;',
            'result.allocation_bytes = decoded.body_bytes + 2u;'),
        ('cursor_constant','payload_offset_before + (uint32_t)decoded.body_bytes;',
            'payload_offset_before + (uint32_t)decoded.body_bytes + 1u;'),
        ('tail_modulus','(length - typed) % ACTION_FAMILY_17_DEPENDENCY_BYTES != 0u',
            '(length - typed) % 8u != 0u'),
        ('tail_count','decoded->dependency_count = (length - typed) / ACTION_FAMILY_17_DEPENDENCY_BYTES;',
            'decoded->dependency_count = (length - typed) / 8u;'),
        ('short_body_guard','if (length < typed) {','if (length < typed && length != typed - 1u) {'),
        ('count_narrowing_guard','if (count > ACTION_FAMILY_17_MAX_COUNT) {',
            'if (count > ACTION_FAMILY_17_MAX_COUNT + 1u) {'),
    ]
    wrapper_variants=[
        ('runtime_type_constant','out->runtime_type = ACTION_FAMILY_16_RUNTIME_TYPE;',
            'out->runtime_type = 0x17u;'),
        ('raw_type_constant','out->raw_type = ACTION_FAMILY_16_RAW_TYPE;',
            'out->raw_type = 0x17u;'),
    ]
    expected={
        'count_source_offset':'native decoder rejected valid original',
        'typed_size_constant':'native decoder rejected valid original',
        'record_view_offset':'decoded field/view mismatch',
        'constructor_field_offset':'whole original/native object mismatch',
        'constructor_allocation_constant':'constructor state/cursor/type mismatch',
        'cursor_constant':'constructor state/cursor/type mismatch',
        'tail_modulus':'acceptance mismatch:',
        'tail_count':'dependency view/count mismatch',
        'short_body_guard':'native short-body safety status mismatch',
        'count_narrowing_guard':'count safety mismatch',
        'runtime_type_constant':'native type mismatch',
        'raw_type_constant':'native type mismatch',
    }
    results=[]
    for name,old,new in variants + wrapper_variants:
        source = wrapper if (name,old,new) in wrapper_variants else shared
        expected_occurrences = 2 if source is wrapper else 1
        if source.count(old)!=expected_occurrences:
            raise RuntimeError(f'nonunique mutation anchor: {name}')
        src,lib=directory/f'{name}.c',directory/f'{name}.dylib'
        src.write_text(source.replace(old,new))
        companion=PROJECT/('src/action_family_17.c' if source is wrapper else 'src/action_family_16.c')
        subprocess.run(['xcrun','--sdk','macosx','clang','-arch','arm64','-std=c11',
            '-Wall','-Wextra','-Wpedantic','-Werror','-O2','-fPIC','-dynamiclib','-I',
            str(PROJECT/'src'),str(src),str(companion),'-o',str(lib)],check=True,capture_output=True)
        cp=subprocess.run([sys.executable,str(PROJECT/'tests/action_family_16_original_oracle.py'),
            '--native-library',str(lib),'--result',str(directory/f'{name}.json')],capture_output=True,text=True)
        log=directory/f'{name}.log';log.write_text(cp.stdout+cp.stderr)
        reason=cp.stderr.strip().splitlines()[-1] if cp.stderr else ''
        if cp.returncode!=1 or not reason.startswith(('cif_original_oracle.OracleError:',
            'tail_oracle_common.TailMismatch:')) or expected[name] not in reason:
            raise RuntimeError(f'unrelated failure or undetected mutation: {name}: {reason}')
        results.append(dict(name=name,detected=True,reason=reason,oracle_exit=cp.returncode,
            mutated_component='wrapper' if source is wrapper else 'reused_decoder',
            source_sha256=sha(src),native_sha256=sha(lib),log_sha256=sha(log)))
    report=dict(slice='A-16.1',compiled_mutants=len(results),detected=len(results),results=results,
        oracle_sha256=sha(PROJECT/'tests/action_family_16_original_oracle.py'))
    path=directory/'report.json';path.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(detected=len(results),report=str(path))))


if __name__=='__main__':
    main()
