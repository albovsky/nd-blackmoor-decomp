#!/usr/bin/env python3
"""FL-52: the two mutation passes of one row, resumable per step: the normal exhaustive check (scripts/fl48_onerow.py), then, when the normal log lists hang-killed mutants, the step-budget
rerun of exactly those mutants (FL45_STRICT_HANG). Writes tasks/fl52/TAG-mut-ROW.txt, TAG-hang-ROW.json and TAG-bud-ROW.txt (TAG = $FL52_TAG, default p); a step whose output exists is skipped.
  fl52_pipe.py ROW [ROW ...]      (run from outputs/blackmoor-decomp; one row at a time per process)"""
import ast
import json
import os
from pathlib import Path
import re
import subprocess
import sys

OUT = Path('tasks/fl52')
TAG = os.environ.get('FL52_TAG', 'p')          # a rerun of a row with new scenarios uses another tag (p2, p3, ...) so the earlier logs stay


def run(row, log, env):
    with open(log, 'w') as fh:
        subprocess.run(['timeout', os.environ.get('FL52_TIMEOUT', '5400'), sys.executable, 'scripts/fl48_onerow.py', row], stdout=fh, stderr=subprocess.STDOUT, env=dict(os.environ, FL48_RLIMIT_MB='6000', **env))


def main():
    for row in sys.argv[1:]:
        mut, hang, bud = OUT / ('%s-mut-%s.txt' % (TAG, row)), OUT / ('%s-hang-%s.json' % (TAG, row)), OUT / ('%s-bud-%s.txt' % (TAG, row))
        if not (mut.exists() and ' killed ' in mut.read_text()):
            run(row, mut, {})
        text = mut.read_text()
        m = re.search(r'^%s mutants killed by a hang or crash (\[.*\])$' % row, text, re.M)
        idents = [x[2] for x in ast.literal_eval(m.group(1))] if m else []
        hang.write_text(json.dumps({row: idents}))
        if idents and not (bud.exists() and ' killed ' in bud.read_text()):
            run(row, bud, {'FL45_STRICT_HANG': str(hang)})
        print(row, 'normal done; hang-listed', len(idents), flush=True)


if __name__ == '__main__':
    main()
