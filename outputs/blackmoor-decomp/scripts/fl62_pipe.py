#!/usr/bin/env python3
"""FL-62: the whole verification of one upper row after its coverage is complete and it is in the corpus, resumable per step (a step whose output exists is skipped).

  fl62_pipe.py ROW [ROW ...]          stage A (run from outputs/blackmoor-decomp; FL62_TIMEOUT seconds per step, default 1800)
  fl62_pipe.py --scen ROW [ROW ...]   stage B, for the rows that stage A leaves with unexplained survivors

Stage A: pass one `scripts/fl62_onerow.py ROW` (exhaustive mutants; the killers of the checker's fixed seed ranges go into the corpus): tasks/fl62/p1-ROW.txt; pass two, the plain check on the corpus alone: p2-ROW.txt.
Stage B: boundary scenarios (`scripts/fl62_boundary.py`, bound-ROW.json), then `fl62_onerow.py ROW --scen bound-ROW.json --no-harden` (a survivor is retried on them; the killing scenarios go into the corpus): p3-ROW.txt.
The definitive log of a row is p3 when it exists, else p2. A step that runs into the timeout is reported and the row stays translated.
"""
import ast
import json
import os
import re
from pathlib import Path
import subprocess
import sys

OUT = Path('tasks/fl62')
LIMIT = os.environ.get('FL62_TIMEOUT', '1800')


def run(cmd, log):
    with open(log, 'w') as fh:
        r = subprocess.run(['timeout', LIMIT, sys.executable, '-u'] + cmd, stdout=fh, stderr=subprocess.STDOUT, env=dict(os.environ, FL48_RLIMIT_MB='6000'))
    return r.returncode


def done(path):
    return path.exists() and ' killed ' in path.read_text()


def budget(row, definitive):
    """the step-budget rerun of the mutants the definitive log lists as killed by a hang or crash (a timeout is not a kill; only the budget rerun can kill them): tasks/fl62/h-ROW.json, b-ROW.txt"""
    text = definitive.read_text()
    m = re.search(r'^%s mutants killed by a hang or crash (\[.*\])$' % row, text, re.M)
    idents = [x[2] for x in ast.literal_eval(m.group(1))] if m else []
    hang, bud = OUT / ('h-%s.json' % row), OUT / ('b-%s.txt' % row)
    hang.write_text(json.dumps({row: idents}))
    if idents and not done(bud):
        with open(bud, 'w') as fh:
            subprocess.run(['timeout', LIMIT, sys.executable, '-u', 'scripts/fl62_onerow.py', row, '--no-harden'], stdout=fh, stderr=subprocess.STDOUT,
                           env=dict(os.environ, FL48_RLIMIT_MB='6000', FL45_STRICT_HANG=str(hang)))


def main():
    args = sys.argv[1:]
    stage_b = args and args[0] == '--scen'
    for row in (args[1:] if stage_b else args):
        bound, p1, p2, p3 = OUT / ('bound-%s.json' % row), OUT / ('p1-%s.txt' % row), OUT / ('p2-%s.txt' % row), OUT / ('p3-%s.txt' % row)
        if stage_b:
            if not bound.exists():
                run(['scripts/fl62_boundary.py', row, '--out', str(bound), '--cap', os.environ.get('FL62_CAP', '800')], OUT / ('bound-%s.log' % row))
            if bound.exists() and not done(p3):
                run(['scripts/fl62_onerow.py', row, '--scen', str(bound), '--no-harden'], p3)
            if done(p3):
                budget(row, p3)
            print(row, 'p3' if done(p3) else 'p3 FAILED', flush=True)
            continue
        if not done(p1):
            run(['scripts/fl62_onerow.py', row], p1)
        if done(p1) and not done(p2):
            run(['scripts/fl62_onerow.py', row, '--no-harden'], p2)
        if done(p2):
            budget(row, p2)
        print(row, 'p1' if done(p1) else 'p1 FAILED', 'p2' if done(p2) else 'p2 FAILED', flush=True)


if __name__ == '__main__':
    main()
