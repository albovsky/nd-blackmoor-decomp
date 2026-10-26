#!/usr/bin/env python3
"""FL-65: print the unexplained survivors (original statement and mutant) of classification files; usage: fl65_unexpl.py SURV.json [...] (run from outputs/blackmoor-decomp)"""
import json
import random
import re
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl41_mutation_check as M
funcs = M.split_functions(open('src/original_methods_fl41.c').read())
for f in sys.argv[1:]:
    d = json.load(open(f))
    for r in d['rows_with_survivors']:
        lines = funcs[r].split('\n')
        idents = {}
        for mk, mn, mt in M.mutants(funcs[r], int(r, 16), random.Random(int(r, 16)), 100000, True):
            idents[(mk, mn, M.line_hash(mt, mn))] = mt.split('\n')[mn]
        bad = [(k, n, ident) for k, n, ident, cls in d['mutants'][r] if cls is None]
        print('=====', r, 'unexplained', len(bad), 'of', len(d['mutants'][r]))
        for k, n, ident in bad:
            print(k, n, '|', re.sub(r'\s+', ' ', lines[n].strip())[:140], '\n      ->', re.sub(r'\s+', ' ', idents[(k, n, ident)].strip())[:140])
