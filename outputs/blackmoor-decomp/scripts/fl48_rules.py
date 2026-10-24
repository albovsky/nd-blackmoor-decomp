#!/usr/bin/env python3
"""FL-48: FL-46's liveness rules (scripts/fl46_rules.py: dead flags, dead register, equal push) for the rows of src/original_methods_fl41.c.

The statements of the FL-41 translation have the shape of the FL-40 ones with `FL41_` for `FL40_`, so the lines are renamed and fl46_rules runs unchanged; the mutants it must find harmless
are those of tests/fl41_mutation_check.py (`--extended`), renamed the same way. The assumption on registers at a return is FL-46's (eax, ebx, esi, edi, ebp, esp live; ecx, edx and the flags not).
"""
import random
from pathlib import Path
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_mutation_check as M
import fl46_rules as R

_MUT = {}


def _mutants_of(lines, row, kind, n):
    key = (id(lines), row)
    if _MUT.get('key') != key:
        _MUT.clear()
        _MUT['key'] = key
        _MUT['all'] = M.mutants('\n'.join(lines), int(row, 16), random.Random(int(row, 16)), 100000, True)
    return [m[2].split('\n')[n].replace('FL41_', 'FL40_') for m in _MUT['all'] if m[0] == kind and m[1] == n]


R.mutants_of = _mutants_of


def explain(kind, lines, n, row):
    """lines: the lines of the row's FL-41 function (unrenamed); returns the rule name or None"""
    renamed = [l.replace('FL41_', 'FL40_') for l in lines]
    renamed_key = lines                                                  # the mutants are built from the unrenamed lines
    R_mut_lines = renamed_key
    R.mutants_of = lambda _l, r, k, i: _mutants_of(R_mut_lines, r, k, i)
    return R.explain(kind, renamed, n, row)
