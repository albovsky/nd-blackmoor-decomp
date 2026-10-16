#!/usr/bin/env python3
"""RT-31: plants mutants in the native sources and runs the raw 0x38 original-x86 oracle against
each (reduced `--mutation` size); every mutant that changes behaviour the oracle covers must make
the oracle fail. Mutants of code the oracle does not drive (the scene-load glue and the handler's
row-type check run in the production-executor unit tests) are listed as EXPECTED_SURVIVORS and
checked by tests/test_action_family_38_runtime.py instead.

    python3 outputs/blackmoor-decomp/tests/action_family_38_runtime_mutation_check.py [--only NAME]
"""
import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

import test_action_family_38_runtime as unit

PROJECT = unit.PROJECT
ORACLE = PROJECT / 'tests/action_family_38_runtime_original_oracle.py'
EXPECTED_SURVIVORS = {'scene load skips 0x38 rows', 'row image type not checked'}

KERNEL_MUTANTS = {
    'animation wrap goes to the last frame': ('action_family_36_runtime.c',
        'next = (loop == 2) ? rds16(image, OV36_FRAME_FIRST)\n                                                   : rds16(image, OV36_FRAME_LAST);',
        'next = (loop == 2) ? rds16(image, OV36_FRAME_LAST)\n                                                   : rds16(image, OV36_FRAME_LAST);'),
    'animation interval 1100 ms per second': ('action_family_36_runtime.c',
        'interval = ftol((1.0 / (double)(float)fps) * 1000.0);',
        'interval = ftol((1.0 / (double)(float)fps) * 1100.0);'),
    'animation starts at the last frame': ('action_family_36_runtime.c',
        'wr16(image, OV36_RT_FRAME, rd16(image, OV36_FRAME_INIT));',
        'wr16(image, OV36_RT_FRAME, rd16(image, OV36_FRAME_LAST));'),
    'animation ignores the direction': ('action_family_36_runtime.c',
        '                        if (direction == 1) {\n                            next = (int16_t)(uint16_t)(next + 1);',
        '                        if (direction != 7) {\n                            next = (int16_t)(uint16_t)(next + 1);'),
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--only')
    parser.add_argument('--quick', action='store_true')
    args = parser.parse_args()
    sources = unit.source_files_of_the_build_script()
    survivors, caught = [], []
    mutants = dict(unit.MUTANTS)
    mutants.update(KERNEL_MUTANTS)
    with tempfile.TemporaryDirectory() as tmp:
        for name, (filename, old, new) in mutants.items():
            if args.only and args.only != name:
                continue
            work = Path(tmp) / 'src'
            shutil.rmtree(work, ignore_errors=True)
            work.mkdir()
            for item in unit.SRC.iterdir():
                if item.suffix in ('.c', '.h'):
                    shutil.copy(item, work / item.name)
            original = (unit.SRC / filename).read_text()
            if original.count(old) != 1:
                raise SystemExit('mutation anchor drifted: ' + name)
            (work / filename).write_text(original.replace(old, new, 1))
            library = Path(tmp) / 'mutant.dylib'
            built = subprocess.run([unit.compiler(), '-std=c11', '-O1', '-fPIC', '-shared', '-I', str(work)] +
                                   [str(work / s) for s in sources] + ['-o', str(library)],
                                   capture_output=True, text=True)
            if built.returncode != 0:
                raise SystemExit('mutant does not build: %s\n%s' % (name, built.stderr[-400:]))
            env = dict(os.environ, A36_RUNTIME_LIBRARY=str(library))
            done = subprocess.run([sys.executable, str(ORACLE), '--mutation', '--report', str(Path(tmp) / 'r.json')],
                                  cwd=str(PROJECT / 'tests'), env=env, capture_output=True, text=True)
            status = 'caught' if done.returncode != 0 else 'SURVIVED'
            print('%-45s %s' % (name, status), flush=True)
            (caught if done.returncode != 0 else survivors).append(name)
    unexpected = [n for n in survivors if n not in EXPECTED_SURVIVORS]
    print(json.dumps(dict(caught=len(caught), survived=survivors, unexpected_survivors=unexpected)))
    return 1 if unexpected else 0


if __name__ == '__main__':
    sys.exit(main())
