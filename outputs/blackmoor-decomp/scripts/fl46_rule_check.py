#!/usr/bin/env python3
"""FL-46: soundness check of scripts/fl46_rules.py. Writes the (kind, line) of every mutant of every translated row that the rules call harmless, in the survivors-file format
that `tests/fl40_mutation_check.py --rescue` reads. Running the harness on that file must kill none of them (every line `mutants N killed 0`); a kill disproves a rule.

  fl46_rule_check.py <out.json>      (run from outputs/blackmoor-decomp)
"""
import json
from pathlib import Path
import random
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl40_mutation_check as M
import fl46_rules as R


def main():
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl40.c').read_text())
    corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
    out = {'rows_with_survivors': {}}
    total = 0
    for row in sorted(corpus, key=lambda k: int(k, 16)):
        text = funcs[row]
        lines = text.split('\n')
        seen = set()
        items = []
        for kind, n, _ in M.mutants(text, int(row, 16), random.Random(int(row, 16)), 100000):
            if (kind, n) in seen:
                continue
            seen.add((kind, n))
            why = R.explain(kind, lines, n, row)
            if why:
                items.append([kind, None, why, n])
        if items:
            out['rows_with_survivors'][row] = items
            total += len(items)
    Path(sys.argv[1]).write_text(json.dumps(out, indent=1) + '\n')
    print(total, 'lines claimed harmless in', len(out['rows_with_survivors']), 'rows')


if __name__ == '__main__':
    main()
