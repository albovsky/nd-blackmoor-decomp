"""FL-62: the exhaustive mutation check of one upper row in this process (as fl48_onerow.py), with the hardening seeds and boundary scenarios in the same pass.

  fl62_onerow.py ROW [--scen FILE] [--no-harden]      (run from outputs/blackmoor-decomp; FL48_RLIMIT_MB bounds the memory)

The killers (seeds from the checker's fixed ranges, scenarios from --scen) go into tests/fl41_corpus.json under a file lock, so that rows checked in parallel do not overwrite each other. The log
line is the one of fl48_onerow.py (`ROW mutants N killed K survivors [...]`), which scripts/fl52_merge.py and the survivor classifier read.
"""
import argparse
import fcntl
import json
import os
import resource
import sys
sys.dont_write_bytecode = True
if os.environ.get('FL48_RLIMIT_MB'):
    resource.setrlimit(resource.RLIMIT_AS, (int(os.environ['FL48_RLIMIT_MB']) << 20,) * 2)
sys.path.insert(0, 'tests')
import fl41_mutation_check as C

ap = argparse.ArgumentParser()
ap.add_argument('row')
ap.add_argument('--scen')
ap.add_argument('--no-harden', action='store_true')
a = ap.parse_args()
key = a.row
corpus = json.loads(C.CORPUS.read_text())
funcs = C.split_functions(C.SOURCE.read_text())
helper = funcs.get('0x50c920', '')
scen = json.loads(open(a.scen).read()).get(key) if a.scen else None
res = C.check_row((key, corpus[key], funcs[key], helper if 'FL41_CALL_LIFTED' in funcs[key] else '', 100000, not a.no_harden, True, scen))[1]
if 'error' in res:
    print('%s COMPILE ERROR %s' % (key, res['error']))
    sys.exit(0)
if res['killers'] or res.get('scen_killers'):
    with open(str(C.CORPUS) + '.lock', 'w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        fresh = json.loads(C.CORPUS.read_text())
        have = {(sd, json.dumps(ov)) for sd, ov in fresh[key]['seeds']}
        fresh[key]['seeds'].extend([sd, []] for sd in res['killers'] if (sd, json.dumps([])) not in have)
        fresh[key]['seeds'].extend([sd, [list(o) for o in ov]] for sd, ov in res.get('scen_killers', []) if (sd, json.dumps([list(o) for o in ov])) not in have)
        C.CORPUS.write_text(json.dumps(fresh, indent=1, sort_keys=True) + '\n')
if res.get('divergent'):
    print('%s divergent seeds (the unmutated translation differs from the original) %s' % (key, res['divergent']), flush=True)
if res.get('budgets'):
    print('%s mutants killed by the step budget %s' % (key, res['budgets']), flush=True)
if res.get('hangs'):
    print('%s mutants killed by a hang or crash %s' % (key, res['hangs']), flush=True)
print('%s mutants %d killed %d survivors %s' % (key, res['mutants'], res['killed'], res['survivors']), flush=True)
