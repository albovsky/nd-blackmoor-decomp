"""FL-48: check one row in this process (no worker pool), for rows whose pool worker dies and leaves the pool waiting forever."""
import json
import os
import resource
import sys
sys.dont_write_bytecode = True
if os.environ.get('FL48_RLIMIT_MB'):          # a runaway scenario ends with a MemoryError and a traceback instead of the container's OOM kill
    resource.setrlimit(resource.RLIMIT_AS, (int(os.environ['FL48_RLIMIT_MB']) << 20,) * 2)
sys.path.insert(0, 'tests')
import fl41_mutation_check as C

key = sys.argv[1]
corpus = json.loads(C.CORPUS.read_text())
funcs = C.split_functions(C.SOURCE.read_text())
helper = funcs.get('0x50c920', '')
res = C.check_row((key, corpus[key], funcs[key], helper if 'FL41_CALL_LIFTED' in funcs[key] else '', 100000, False, True))[1]
if 'error' in res:
    print('%s COMPILE ERROR %s' % (key, res['error']))
else:
    if res.get('divergent'):
        print('%s divergent seeds (the unmutated translation differs from the original) %s' % (key, res['divergent']), flush=True)
    if res.get('budgets'):
        print('%s mutants killed by the step budget %s' % (key, res['budgets']), flush=True)
    if res.get('hangs'):
        print('%s mutants killed by a hang or crash %s' % (key, res['hangs']), flush=True)
    print('%s mutants %d killed %d survivors %s' % (key, res['mutants'], res['killed'], res['survivors']), flush=True)
