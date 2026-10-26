#!/usr/bin/env python3
"""FL-63: the step-budget rerun of the mutants that a mutation log lists as killed by a hang or crash (a hang is not a kill; only the budget rerun can kill them; see scripts/fl62_pipe.py).

  fl63_budget.py ROW LOG [--scen FILE]      (run from outputs/blackmoor-decomp) writes tasks/fl63/h-ROW.json and the budget log tasks/fl63/b-<LOG name>
"""
import ast
import json
import os
from pathlib import Path
import re
import subprocess
import sys

row, log = sys.argv[1], Path(sys.argv[2])
scen = sys.argv[sys.argv.index('--scen') + 1:sys.argv.index('--scen') + 3] if '--scen' in sys.argv else []
m = re.search(r'^%s mutants killed by a hang or crash (\[.*\])$' % row, log.read_text(), re.M)
idents = [x[2] for x in ast.literal_eval(m.group(1))] if m else []
hang = Path('tasks/fl63/h-%s.json' % row)
hang.write_text(json.dumps({row: idents}))
out = log.parent / ('b-' + log.name)
if idents:
    with open(out, 'w') as fh:
        subprocess.run(['timeout', '1800', sys.executable, '-u', 'scripts/fl62_onerow.py', row, '--no-harden'] + scen, stdout=fh, stderr=subprocess.STDOUT,
                       env=dict(os.environ, FL48_RLIMIT_MB='6000', FL45_STRICT_HANG=str(hang)))
print(row, len(idents), 'hang-listed;', out if idents else 'no budget log needed')
