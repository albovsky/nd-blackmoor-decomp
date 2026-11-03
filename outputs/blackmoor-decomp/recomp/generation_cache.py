#!/usr/bin/env python3
"""Reuse lifted C only while its complete recorded generator inputs still match.

This helper runs source generation, never a compiler or game. One build owns
an output directory at a time. Generation retains lift_recomp's existing
write-if-unchanged chunk behavior; no generated source/object is deleted here.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

# Fixed project inputs; original_differential also reads the dynamic data
# manifests fingerprinted below. Original image bytes and CHUNKS are separate.
# Headers affect compilation, not lifting.
INPUTS = (
    'recomp/lift_recomp.py',
    'scripts/lift_fl41.py',
    'scripts/lift_function.py',
    'scripts/fl55_imports.py',
    'tests/original_differential.py',
    'tests/cif_original_oracle.py',
    'function-ledger.json',
    'function-xrefs.json',
)
STAMP = '.rc_generation_stamp.json'


def digest(path):
    result = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)
    return result.hexdigest()


def fingerprint(project, chunks, import_image):
    body_image = project.parent.parent / 'work/original/GAME.EXE'
    # Preserve the existing decoder path policy: function bytes use body_image;
    # the later PE-import read may use GAME_EXE. Hash both actual reads without
    # changing which image either reader opens.
    return {'schema': 1, 'chunks': chunks,
            'project_inputs': {name: digest(project / name) for name in INPUTS},
            'data_manifests': {path.relative_to(project).as_posix(): digest(path)
                               for path in sorted((project / 'asm_data').glob('data-*.json'))
                               if not path.name.endswith('-report.json')},
            'original_images': {'body_sha256': digest(body_image),
                                'imports_sha256': digest(import_image)}}


def output_pins(out, chunks):
    expected = {f'rc_lifted_{i:02d}.c' for i in range(chunks)}
    actual = {path.name for path in out.glob('rc_lifted_*.c')}
    extra_objects = {path.name for path in out.glob('rc_lifted_*.o')
                     if path.with_suffix('.c').name not in expected}
    if actual - expected or extra_objects:
        raise ValueError('unexpected leftover lifted chunks/objects; use a fresh build directory')
    if actual != expected:
        raise ValueError('generated lifted chunk set is incomplete')
    names = sorted(expected | {'rc_generated.c', 'rc_generated.h', 'lift_census.json'})
    for name in names:
        if not (out / name).is_file() or (out / name).stat().st_size == 0:
            raise ValueError('missing/empty generated output: ' + name)
    census = json.loads((out / 'lift_census.json').read_text())
    if not isinstance(census, dict) or not isinstance(census.get('lifted'), list) or not isinstance(census.get('refused'), dict):
        raise ValueError('invalid generated census')
    return {name: digest(out / name) for name in names}


def write_stamp(path, value):
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode='w', dir=path.parent, prefix=STAMP + '.', delete=False) as stream:
            temporary = Path(stream.name)
            stream.write(json.dumps(value, sort_keys=True, indent=2) + '\n')
        os.replace(temporary, path)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


def ensure_generated(project, out, chunks, force=False, import_image=None):
    if type(chunks) is not int or chunks < 1:
        raise ValueError('CHUNKS must be a positive integer')
    project, out = Path(project).resolve(), Path(out).resolve()
    original = project.parent.parent / 'work/original/GAME.EXE'
    selected_image = Path(import_image) if import_image is not None else Path(os.environ.get('GAME_EXE') or original)
    stamp = out / STAMP
    # An invalidated marker cannot survive a failed input read or generation.
    try:
        inputs = fingerprint(project, chunks, selected_image)
        if not force:
            try:
                recorded = json.loads(stamp.read_text())
                if recorded == {'inputs': inputs, 'outputs': output_pins(out, chunks)}:
                    return False
            except (OSError, ValueError, TypeError):
                pass
    except (OSError, ValueError):
        stamp.unlink(missing_ok=True)
        raise
    stamp.unlink(missing_ok=True)
    out.mkdir(parents=True, exist_ok=True)
    subprocess.run([sys.executable, '-I', str(project / 'recomp/lift_recomp.py'),
                    str(out), str(chunks)], check=True)
    outputs = output_pins(out, chunks)
    if inputs != fingerprint(project, chunks, selected_image):
        raise ValueError('generator inputs changed during generation; no cache stamp written')
    write_stamp(stamp, {'inputs': inputs, 'outputs': outputs})
    return True


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('output', type=Path)
    parser.add_argument('chunks', type=int)
    parser.add_argument('relift', nargs='?', default='')
    args = parser.parse_args(argv)
    try:
        ensure_generated(Path(__file__).resolve().parent.parent, args.output,
                         args.chunks, force=bool(args.relift))
        return 0
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('generated-C cache: ' + str(error), file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
