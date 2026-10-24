#!/usr/bin/env python3
"""FL-48: a reading packet per row for the written reasons (tasks/fl48-written-reasons.json): the translation with its line numbers, and for every unexplained survivor
(kind, line) the statement and each mutated version of it.   fl48_packet.py SURVIVORS.json OUTDIR ROW [ROW ...]      (run from outputs/blackmoor-decomp)"""
import json
from pathlib import Path
import random
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl41_mutation_check as M


def main():
    surv = json.loads(Path(sys.argv[1]).read_text())['rows_with_survivors']
    out = Path(sys.argv[2])
    out.mkdir(parents=True, exist_ok=True)
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())
    for row in sys.argv[3:]:
        text = funcs[row]
        lines = text.split('\n')
        muts = M.mutants(text, int(row, 16), random.Random(int(row, 16)), 100000, True)
        want = sorted({(k, n) for k, c, _, n in surv[row] if c is None}, key=lambda x: (x[1], x[0]))
        parts = ['# Row %s: unexplained survivors\n' % row, 'Translation (line numbers are 0-based indexes into the function text; the statements are exactly as in the file):\n', '```']
        parts += ['%4d  %s' % (i, l) for i, l in enumerate(lines)]
        parts += ['```\n', '## Survivors (each must get an equivalence reason or a verdict "not equivalent")\n']
        for k, n in want:
            parts.append('### %s at line %d\n' % (k, n))
            parts.append('Statement: `%s`\n' % lines[n].strip())
            for kind, nn, mt in muts:
                if kind == k and nn == n:
                    parts.append('- mutant: `%s`' % mt.split('\n')[n].strip())
            parts.append('')
        (out / (row + '.md')).write_text('\n'.join(parts) + '\n')
        print(row, len(want), 'survivor statements')


if __name__ == '__main__':
    main()
