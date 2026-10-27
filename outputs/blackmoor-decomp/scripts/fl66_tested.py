#!/usr/bin/env python3
"""FL-66: the "tested equivalent" tier. A pending row whose committed translation (a) is run on generated scenarios that execute EVERY instruction of the original function and take BOTH directions of
every conditional jump, and (b) agrees with the original x86 bytes (Unicorn) on EVERY one of those scenarios (registers, written memory, callee calls, return). No mutation check is run, so this is
weaker than `ported` (the ledger's verified count) and is never added to it.

  fl66_tested.py check  ROW [ROW ...] | --pool NAME [--shard i/n] [--scen FILE ...] [--out FILE] [--timeout S]     differential + coverage of the rows on every scenario we know of
  fl66_tested.py gen    ROW [ROW ...] | --pool NAME [--shard i/n] [--budget-s N] [--timeout S]                      run the concolic generator on the rows that miss coverage, then check again
  fl66_tested.py merge  [--write]                                                                                    fold the per-row results of tasks/fl66/rows/ into tasks/fl66-tested-equivalent.json and tests/fl66_scenarios.json
  fl66_tested.py status                                                                                             print "verified X, tested equivalent Y, translated only Z"
  fl66_tested.py replay [--sample N] [--rows ROW,..]                                                                 re-run the kept scenarios of the committed manifest (what tests/test_fl66_tested_equivalent.py does)

Pools: held (lower rows in the verified corpus that are held: full coverage, unexplained mutants), lower (src/original_methods_fl56_unverified.c), upper (translated/original_methods_fl41_translated.c),
upper57 (translated/original_methods_fl57_translated.c). Run from outputs/blackmoor-decomp; needs unicorn, capstone, z3-solver and the private work/original/GAME.EXE.

Each row is run in its own subprocess under a timeout (a native loop cannot be interrupted from Python); its result is tasks/fl66/rows/<va>.json: status `tested_equivalent`, `partial` (agrees everywhere,
coverage incomplete), `mismatch` (the translation disagrees with the original on a scenario: a translation defect, listed, never counted) or `error`.
"""
import argparse
import glob
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import time

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))

SCEN_DIR = Path(os.environ['FL66_SCEN']) if os.environ.get('FL66_SCEN') else PROJECT / 'tasks/fl66/scen'
ROWS_DIR = Path(os.environ['FL66_ROWS']) if os.environ.get('FL66_ROWS') else PROJECT / 'tasks/fl66/rows'
MANIFEST = PROJECT / 'tasks/fl66-tested-equivalent.json'
SCENARIOS = PROJECT / 'tests/fl66_scenarios.json'
CACHE = Path(os.environ.get('FL66_CACHE', '/tmp/fl66-cache'))
SCHEMA = 'blackmoor-tested-equivalent/1'
MANIFEST2 = PROJECT / 'tasks/fl67-infeasible.json'
SCENARIOS2 = PROJECT / 'tests/fl67_scenarios.json'
SCHEMA2 = 'blackmoor-tested-equivalent-infeasible/1'
RULE_ID2 = 'T-EQ-INFEASIBLE'
RULE_TEXT2 = ('A pending function is tested equivalent by proof when its committed translation equals the original on every scenario kept for it, and every instruction and conditional-jump direction '
              'those scenarios do not reach is PROVED unreachable: scripts/fl67_infeasible.py symbolically executes the original bytes (all paths at once, z3) and shows that no start state of the '
              'function reaches it in a run that does not fault. Modelling assumptions: ebx/esi/edi/ebp survive a call and esp returns by the bytes the callee pops; the direction flag is clear; '
              'an access at or above 0xfff00000, a division by zero and a quotient overflow fault; the image below .data is constant; a function that never forms the address of its own frame '
              'keeps its frame slots out of reach of stores through other pointers and of callees (except the argument slots pushed for the call). Not a verified port: never added to the verified count.')
RULE_ID = 'T-EQ-COVERED'
RULE_TEXT = ('A pending function is tested equivalent when its committed translation runs under Unicorn-vs-native differential scenarios that execute every instruction of the original function and take both '
             'directions of every conditional jump, and the translation equals the original on every one of those scenarios (final registers, written memory, callee calls and their arguments, return). '
             'No mutation check was run: this is not a verified port and is never added to the verified count.')

POOLS = {
    'held': {'world': 40, 'source': 'src/original_methods_fl40.c', 'table': 'tests/fl40_corpus.json'},
    'lower': {'world': 40, 'source': 'src/original_methods_fl56_unverified.c', 'table': 'tasks/fl56-translated-unverified.json', 'key': 'rows'},
    'upper': {'world': 41, 'source': 'translated/original_methods_fl41_translated.c', 'table': 'tests/fl41_translated.json'},
    'upper57': {'world': 41, 'source': 'translated/original_methods_fl57_translated.c', 'table': 'tests/fl57_translated.json'},
    'fl68': {'world': 41, 'source': 'translated/original_methods_fl41_translated.c', 'table': 'tests/fl68_rows.json', 'lib': 'upper'},      # FL-68: rows whose translation sits in the upper file but whose table entry does not (the inline helpers)
}
WORLD_FILES = {40: 'tests/fl40_pending.json', 41: 'tests/fl41_pending.json'}


def jload(path):
    return json.loads(Path(path).read_text())


def ledger_entries():
    return {e['va']: e for e in jload(PROJECT / 'function-ledger.json')['entries']}


def pool_table(name):
    p = POOLS[name]
    t = jload(PROJECT / p['table'])
    return t[p['key']] if 'key' in p else t


def held_rows():
    """Rows of the lower verified corpus that the ledger does not credit."""
    led = ledger_entries()
    return sorted((k for k in jload(PROJECT / POOLS['held']['table']) if led.get(k, {}).get('status') == 'pending'), key=lambda k: int(k, 16))


def pool_keys(name):
    if name == 'held':
        return held_rows()
    led = ledger_entries()
    return sorted((k for k in pool_table(name) if led.get(k, {}).get('status') == 'pending'), key=lambda k: (pool_table(name)[k]['body'], int(k, 16)))


def pool_of(key):
    for name in POOLS:
        if key in (held_rows() if name == 'held' else pool_table(name)):
            return name
    raise KeyError(key)


# ---- scenarios ---------------------------------------------------------------------------------------------------------------------------------

def norm(s):
    if isinstance(s, int):
        return (s, ())
    return (int(s[0]), tuple(tuple(int(x) for x in o) for o in s[1]))


def as_json(s):
    return [s[0], [list(o) for o in s[1]]]


def looks_like_scenarios(v):
    return isinstance(v, list) and v and all(isinstance(x, list) and len(x) == 2 and isinstance(x[0], int) and isinstance(x[1], list) for x in v)


def scenario_files():
    fs = sorted(glob.glob(str(PROJECT / 'tasks/fl6*/*.json')) + glob.glob(str(PROJECT / 'tasks/fl6*-*.json')) + glob.glob(str(SCEN_DIR / '*.json')))
    return [f for f in fs if '/rows/' not in f and 'mutation' not in f]


def known_scenarios(key, world, extra=()):
    """Every scenario any earlier thread kept or generated for the row: the corpus and pending tables, the translated tables, tasks/fl6x scenario files, and `extra` files."""
    out, seen = [], set()

    def add(items):
        for s in items:
            try:
                n = norm(s)
            except Exception:
                continue
            if n not in seen:
                seen.add(n)
                out.append(n)
    for f in ('tests/fl40_corpus.json', 'tests/fl41_corpus.json', WORLD_FILES[world], 'tests/fl41_translated.json', 'tests/fl57_translated.json', 'tasks/fl56-translated-unverified.json', 'tests/fl66_scenarios.json'):
        p = PROJECT / f
        if not p.exists():
            continue
        d = _cached(p)
        d = d.get('rows', d) if isinstance(d, dict) and 'rows' in d else d
        if isinstance(d, dict) and key in d:
            v = d[key]
            add(v.get('seeds', []) if isinstance(v, dict) else v)
    for f in list(scenario_files()) + list(extra):
        d = _cached(Path(f))
        if not isinstance(d, dict):
            continue
        v = d.get(key)
        if looks_like_scenarios(v):
            add(v)
        elif isinstance(v, dict) and looks_like_scenarios(v.get('seeds')):
            add(v['seeds'])
    return out


_CACHE = {}


def _cached(path):
    path = Path(path)
    if path not in _CACHE:
        try:
            _CACHE[path] = json.loads(path.read_text())
        except Exception:
            _CACHE[path] = None
    return _CACHE[path]


# ---- worlds, libraries and rows ----------------------------------------------------------------------------------------------------------------

def world(num):
    if num == 40:
        import fl40_world as W
        import fl40_generate as G
        import lift_function as L
        L.UNVERIFIED = True                 # row_info reads the x87 effect of callees the strict lifter refuses (FL-56)
    else:
        import fl41_world as W
        import fl41_generate as G
        import lift_fl41 as L
        L.BULK = True                       # row_info reads the x87 effect of the callees the way the bulk lift did
    return W, G


def source_sha(path):
    return hashlib.sha256((PROJECT / path).read_bytes()).hexdigest()


def library_key(pool):
    """Cache key of a pool's library: the C file AND the shared model headers it includes (a changed header changes what the translation does)."""
    h = hashlib.sha256()
    h.update((PROJECT / POOLS[pool]['source']).read_bytes())
    for header in sorted((PROJECT / 'src').glob('original_methods_fl4*.h')):
        h.update(header.name.encode())
        h.update(header.read_bytes())
    return h.hexdigest()


def library(pool):
    """The shared library of the pool's committed C file (cached under /tmp by the hash of the file and its headers: the 10 MB upper file takes minutes to compile).
    Concurrent shards compile into their own temporary file and publish it atomically."""
    p = POOLS[pool]
    world(p['world'])
    CACHE.mkdir(parents=True, exist_ok=True)
    so = CACHE / ('%s-%s.so' % (p.get('lib', pool), library_key(pool)[:16]))
    if not so.exists():
        tmp = CACHE / ('%s-%d.tmp.so' % (so.stem, os.getpid()))
        cmd = ['cc', '-std=c11', '-O1', '-shared', '-fPIC', '-w', '-I%s' % (PROJECT / 'src'), str(PROJECT / p['source']), '-o', str(tmp)]
        r = subprocess.run(cmd, capture_output=True, text=True)
        if r.returncode:
            raise RuntimeError(r.stderr[:2000])
        os.replace(tmp, so)
    import ctypes
    return ctypes.CDLL(str(so))


SITES = PROJECT / 'tests/fl68_sites.json'


def extra_sites():
    return _cached(SITES) or {}


def row_info(pool, key):
    p = POOLS[pool]
    W, _ = world(p['world'])
    t = (jload(PROJECT / 'tests/fl40_corpus.json') if pool == 'held' else pool_table(pool))[key]
    va = int(key, 16)
    cal = {int(a, 16): n for a, n in t['callees'].items()}
    imp = {int(a, 16): n for a, n in t.get('imports', {}).items()}
    sites = {int(a, 16): n for a, n in t.get('sites', {}).items()}
    sites.update({int(a, 16): n for a, n in extra_sites().get(key, {}).items()})            # FL-68: indirect calls and tail jumps registered by scripts/fl68_sites.py
    if p['world'] == 40:
        return W.row_info(va, t['body'], cal, imp, t.get('fs', False), sites)            # FL-69: the fl40 world plays them too
    return W.row_info(va, t['body'], cal, imp, t.get('fs', False), sites, t.get('frame', False))


def row_text(source, key):
    """The function text of a row in a committed C file (from its `/* GAME.EXE <va> (` comment to the next row's)."""
    text = (PROJECT / source).read_text()
    m = re.search(r'^/\* GAME\.EXE %s \(.*?(?=^/\* GAME\.EXE 0x|\Z)' % re.escape(key), text, re.M | re.S)
    return m.group(0) if m else None


def translation_sha_of(text, key):
    """Same hash as decomp-progress/function_ledger.translation_sha256 (the ledger re-checks it on every build)."""
    m = re.search(r'^/\* GAME\.EXE %s \(.*?(?=^/\* GAME\.EXE 0x|\Z)' % re.escape(key), text, re.M | re.S)
    return hashlib.sha256(m.group(0).encode()).hexdigest() if m else None


def translation_sha(pool, key):
    return translation_sha_of((PROJECT / POOLS[pool]['source']).read_text(), key)


# ---- the check of one row ------------------------------------------------------------------------------------------------------------------------

EARLY = bool(os.environ.get('FL66_EARLY'))


def check_row(key, extra=(), scenarios=None, max_scen=4000, lib=None):
    pool = pool_of(key)
    p = POOLS[pool]
    W, G = world(p['world'])
    lib = lib or library(pool)
    row = row_info(pool, key)
    scen = list(scenarios) if scenarios is not None else known_scenarios(key, p['world'], extra)
    ex, ed, kept, bad, ran, skipped = set(), set(), [], None, 0, 0
    for seed, ov in scen[:max_scen]:
        o = W.run_original(row, seed, ov)
        if o.fault:
            skipped += 1
            continue
        n = W.run_native(lib, row, seed, ov)
        ran += 1
        if n.fault or n.digest() != o.digest():
            bad = as_json((seed, ov))
            break
        if o.executed <= ex and o.edges <= ed:
            continue
        kept.append(as_json((seed, ov)))
        ex |= o.executed
        ed |= o.edges
        if EARLY and not any(G.covers(row, ex, ed)[4:]):       # FL-68: a row with thousands of known scenarios (0.4 s each, both sides) stops at full coverage; the kept list is the scenario set the tests replay
            break
    got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
    res = {'pool': pool, 'body': row['body'], 'instructions': [got, total], 'directions': [taken, dirs], 'scenarios_run': ran, 'scenarios_skipped_original_faults': skipped,
           'kept': kept, 'translation_sha256': translation_sha(pool, key), 'source': p['source']}
    if bad:
        res['status'] = 'mismatch'
        res['mismatch'] = bad
    elif not missing and not untaken and ran:
        res['status'] = 'tested_equivalent'
    else:
        res['status'] = 'partial'
        res['missing'] = [hex(x) for x in missing]
        res['untaken'] = [[hex(a), n] for a, n in untaken]
    return res


def write_row(key, res):
    ROWS_DIR.mkdir(parents=True, exist_ok=True)
    path = ROWS_DIR / (key + '.json')
    tmp = path.with_suffix('.tmp')
    tmp.write_text(json.dumps(res, sort_keys=True) + '\n')
    os.replace(tmp, path)


def one(args):
    """Subprocess entry: check (and with --gen generate) one row and write tasks/fl66/rows/<va>.json."""
    key = args.rows[0]
    try:
        res = check_row(key, args.scen)
        if args.gen and res['status'] == 'partial':
            res = generate_then_check(key, args, res)
        if res['status'] == 'partial' and args.prove:
            res = prove_leftovers(key, res)
    except Exception as ex:                                    # a defect of the harness, never a credit
        res = {'status': 'error', 'error': '%s: %s' % (type(ex).__name__, str(ex)[:300])}
    write_row(key, res)
    print(key, res['status'], res.get('instructions'), res.get('directions'), flush=True)


def generate_then_check(key, args, before):
    pool = pool_of(key)
    p = POOLS[pool]
    script = 'fl62_concolic.py' if p['world'] == 41 else 'fl61_concolic.py'
    gen = SCEN_DIR
    gen.mkdir(parents=True, exist_ok=True)
    out, rep = gen / ('gen-%s.json' % key), gen / ('rep-%s.json' % key)
    for f in (out, rep):
        if f.exists():
            os.replace(f, f.with_suffix('.old'))
    cmd = [sys.executable, '-u', str(PROJECT / 'scripts' / script), key, '--budget-s', str(args.budget_s), '--out', str(out), '--report', str(rep)]
    try:
        subprocess.run(cmd, cwd=PROJECT, capture_output=True, text=True, timeout=args.budget_s * 4 + 120)
    except subprocess.TimeoutExpired:
        pass
    res = check_row(key, list(args.scen) + [str(out)]) if out.exists() else before
    res['generated'] = out.exists()
    return res


def CHECKER_VERSION_now():
    import fl67_infeasible as P
    return P.CHECKER_VERSION


def prove_leftovers(key, res):
    """FL-67: a partial row whose every missing instruction and untaken direction is PROVED unreachable (scripts/fl67_infeasible.py) becomes `proved`."""
    import fl67_infeasible as P
    out = P.prove_row(key, {'missing': res['missing'], 'untaken': res['untaken']}, timeout_ms=20000, fail_fast=True)
    res['proof_status'] = out['status']
    if out['status'] == 'proved':
        res['status'] = 'proved'
        res['proofs'] = {'checker': out['checker'], 'plan': out.get('plan'), 'instructions': {a: v[1] for a, v in out['instructions'].items()},
                         'directions': {a: v[1] for a, v in out['directions'].items()}}
    else:
        res['proof_reason'] = out.get('reason', '')
        res['proof_open'] = {a: v[0] for a, v in list(out['instructions'].items()) + list(out['directions'].items()) if v[0] != 'unsat'}
    return res


def supervise(args):
    """Run the rows of a pool (or the listed rows) one subprocess each with a timeout; skip rows that already have a result unless --redo."""
    keys = list(args.rows) or pool_keys(args.pool)
    i, n = map(int, args.shard.split('/'))
    keys = keys[i::n]
    t0 = time.time()
    done = 0
    for key in keys:
        path = ROWS_DIR / (key + '.json')
        if path.exists() and not args.redo:
            prev = jload(path)
            if not (args.gen and prev.get('status') == 'partial' and not prev.get('generated')):
                continue
        cmd = [sys.executable, '-u', str(Path(__file__).resolve()), '_one', key] + (['--gen'] if args.gen else []) + (['--prove'] if args.prove else []) + ['--budget-s', str(args.budget_s)] + sum((['--scen', s] for s in args.scen), [])
        try:
            r = subprocess.run(cmd, cwd=PROJECT, capture_output=True, text=True, timeout=args.timeout)
            sys.stdout.write(r.stdout[-300:])
            if r.returncode:
                write_row(key, {'status': 'error', 'error': 'exit %d: %s' % (r.returncode, r.stderr[-200:])})
                print(key, 'error exit', r.returncode, flush=True)
        except subprocess.TimeoutExpired:
            write_row(key, {'status': 'error', 'error': 'timeout after %ds' % args.timeout})
            print(key, 'timeout', flush=True)
        done += 1
        if args.limit_s and time.time() - t0 > args.limit_s:
            break
    print('shard %s: %d rows processed in %ds' % (args.shard, done, time.time() - t0), flush=True)


# ---- the manifest ---------------------------------------------------------------------------------------------------------------------------------

def load_results():
    out = {}
    for f in sorted(glob.glob(str(ROWS_DIR / '*.json'))):
        out[Path(f).stem] = jload(f)
    return out


def merge(write):
    res = load_results()
    led = ledger_entries()
    prev = jload(MANIFEST) if MANIFEST.exists() else {'rows': {}}
    prev_sc = jload(SCENARIOS) if SCENARIOS.exists() else {}
    old_partial = jload(PROJECT / 'tasks/fl66-partial.json') if (PROJECT / 'tasks/fl66-partial.json').exists() else {}
    old_psc = jload(PROJECT / 'tasks/fl66-partial-scenarios.json') if (PROJECT / 'tasks/fl66-partial-scenarios.json').exists() else {}
    rows, scen = dict(prev['rows']), dict(prev_sc)
    # FL-68: the per-row results of earlier batches are not committed, so the partial / mismatch / error lists start from the committed ones and only the rows of this results directory replace theirs
    partial, mismatch, error = dict(old_partial.get('partial', {})), dict(old_partial.get('mismatch', {})), dict(old_partial.get('error', {}))
    psc = dict(old_psc)
    prev2 = jload(MANIFEST2) if MANIFEST2.exists() else {'rows': {}}
    proved, pscen = dict(prev2['rows']), (jload(SCENARIOS2) if SCENARIOS2.exists() else {})
    for key, r in res.items():
        if led.get(key, {}).get('status') != 'pending':
            rows.pop(key, None)
            scen.pop(key, None)
            continue
        for d in (partial, mismatch, error, psc):
            d.pop(key, None)
        st = r['status']
        if st == 'proved' and r['proofs']['checker'] < CHECKER_VERSION_now():
            st = 'partial'                                              # proved by an older checker: not credited
        if st != 'proved':
            proved.pop(key, None)                                       # a newer result that is not a proof withdraws the earlier credit (mismatch, error, partial)
            pscen.pop(key, None)
        if st == 'tested_equivalent':
            rows[key] = {k: r[k] for k in ('pool', 'body', 'instructions', 'directions', 'scenarios_run', 'translation_sha256', 'source')}
            rows[key]['scenarios_kept'] = len(r['kept'])
            scen[key] = r['kept']
            partial.pop(key, None)
        elif st == 'proved':
            proved[key] = {k: r[k] for k in ('pool', 'body', 'instructions', 'directions', 'scenarios_run', 'translation_sha256', 'source')}
            proved[key]['scenarios_kept'] = len(r['kept'])
            proved[key]['proofs'] = r['proofs']
            pscen[key] = r['kept']
            rows.pop(key, None)
            scen.pop(key, None)
            partial.pop(key, None)
        elif st == 'partial':
            partial[key] = {'instructions': r['instructions'], 'directions': r['directions'], 'body': r['body'], 'pool': r['pool']}
            psc[key] = r['kept']
        elif st == 'mismatch':
            mismatch[key] = r['mismatch']
            rows.pop(key, None)
            scen.pop(key, None)
        else:
            error[key] = r.get('error')
    for key in [k for k in rows if led.get(k, {}).get('status') != 'pending']:
        rows.pop(key)
        scen.pop(key, None)
    for key in [k for k in proved if led.get(k, {}).get('status') != 'pending' or k in rows]:
        proved.pop(key)
        pscen.pop(key, None)
    manifest = {'schema': SCHEMA, 'rule': {'id': RULE_ID, 'text': RULE_TEXT}, 'rows': {k: rows[k] for k in sorted(rows, key=lambda x: int(x, 16))}}
    scen = {k: scen[k] for k in sorted(rows, key=lambda x: int(x, 16))}
    pscen = {k: pscen[k] for k in sorted(proved, key=lambda x: int(x, 16))}
    manifest2 = {'schema': SCHEMA2, 'rule': {'id': RULE_ID2, 'text': RULE_TEXT2}, 'rows': {k: proved[k] for k in sorted(proved, key=lambda x: int(x, 16))}}
    print('tested equivalent %d, proved %d, partial %d, mismatch %d, error %d' % (len(rows), len(proved), len(partial), len(mismatch), len(error)))
    if write:
        MANIFEST2.write_text(json.dumps(manifest2, indent=1, sort_keys=True) + '\n')
        SCENARIOS2.write_text(json.dumps(pscen, separators=(',', ':'), sort_keys=True) + '\n')
        MANIFEST.write_text(json.dumps(manifest, indent=1, sort_keys=True) + '\n')
        SCENARIOS.write_text(json.dumps(scen, separators=(',', ':'), sort_keys=True) + '\n')
        (PROJECT / 'tasks/fl66-partial-scenarios.json').write_text(json.dumps({k: psc[k] for k in sorted(psc, key=lambda x: int(x, 16))}, separators=(',', ':')) + '\n')
        (PROJECT / 'tasks/fl66-partial.json').write_text(json.dumps({'partial': partial, 'mismatch': mismatch, 'error': error}, indent=1, sort_keys=True) + '\n')
    return 0


def counts():
    """(verified ported, tested equivalent, translated only, partial coverage) from the committed ledger, manifest and translation tables."""
    led = ledger_entries()
    verified = sum(1 for e in led.values() if e['status'] == 'ported')
    te = set(jload(MANIFEST)['rows']) if MANIFEST.exists() else set()
    te |= set(jload(MANIFEST2)['rows']) if MANIFEST2.exists() else set()
    translated = set()
    for name in POOLS:
        translated |= {k for k in (held_rows() if name == 'held' else pool_table(name)) if led.get(k, {}).get('status') == 'pending'}
    translated |= {k for k in jload(PROJECT / 'tests/fl59_handports.json') if led.get(k, {}).get('status') == 'pending'} if (PROJECT / 'tests/fl59_handports.json').exists() else set()
    part = jload(PROJECT / 'tasks/fl66-partial.json')['partial'] if (PROJECT / 'tasks/fl66-partial.json').exists() else {}
    only = translated - te
    return verified, len(te), len(only), len([k for k in part if k in only]), len(translated)


def status():
    v, t, o, p, tr = counts()
    byproof = len(jload(MANIFEST2)['rows']) if MANIFEST2.exists() else 0
    print('verified %d, tested equivalent %d (%d of them by proof), translated only %d (partial coverage %d of those; %d rows translated)' % (v, t, byproof, o, p, tr))
    return 0


def replay(args):
    man = jload(MANIFEST)['rows']
    scen = jload(SCENARIOS)
    keys = args.rows.split(',') if args.rows else sorted(man, key=lambda x: int(x, 16))
    if args.sample:
        keys = keys[::max(1, len(keys) // args.sample)]
    bad = 0
    for key in keys:
        r = check_row(key, scenarios=[norm(s) for s in scen[key]])
        ok = r['status'] == 'tested_equivalent' and r['instructions'] == man[key]['instructions'] and r['directions'] == man[key]['directions']
        if not ok:
            bad += 1
        print(key, 'ok' if ok else 'FAIL ' + r['status'], flush=True)
    return 1 if bad else 0


def prove_pass(args):
    """FL-67: run the infeasibility prover on the partial rows that already have a result (no scenario generation). Rows whose items are all proved become `proved`."""
    keys = list(args.rows) or sorted(p.stem for p in ROWS_DIR.glob('*.json'))
    i, n = map(int, args.shard.split('/'))
    proved = 0
    for key in keys[i::n]:
        path = ROWS_DIR / (key + '.json')
        res = jload(path)
        if res['status'] == 'proved' and res.get('proofs', {}).get('checker', 0) < CHECKER_VERSION_now():
            res['status'] = 'partial'                                  # proved by an older, less sound checker: prove again
            res.pop('proofs', None)
        if res['status'] != 'partial':
            continue
        t0 = time.time()
        try:
            res = prove_leftovers(key, res)
        except Exception as ex:
            res['proof_status'] = 'error: %s' % str(ex)[:100]
        write_row(key, res)
        proved += res['status'] == 'proved'
        print(key, res['status'], res.get('proof_status'), res.get('proof_open', ''), '%.1fs' % (time.time() - t0), flush=True)
    print('proved %d' % proved)
    return 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('cmd', choices=['check', 'gen', 'merge', 'status', 'replay', '_one', 'prove'])
    ap.add_argument('rows', nargs='*')
    ap.add_argument('--pool')
    ap.add_argument('--shard', default='0/1')
    ap.add_argument('--scen', action='append', default=[])
    ap.add_argument('--timeout', type=int, default=900)
    ap.add_argument('--budget-s', type=int, default=90)
    ap.add_argument('--limit-s', type=int, default=0)
    ap.add_argument('--redo', action='store_true')
    ap.add_argument('--write', action='store_true')
    ap.add_argument('--gen', action='store_true')
    ap.add_argument('--prove', action='store_true', help='FL-67: after the check (or generation), try to prove the missing items unreachable')
    ap.add_argument('--sample', type=int, default=0)
    ap.add_argument('--rows', dest='rows_csv', help='replay: comma-separated rows')
    a = ap.parse_args()
    if a.cmd == '_one':
        return one(a)
    if a.cmd in ('check', 'gen'):
        a.gen = a.cmd == 'gen'
        return supervise(a)
    if a.cmd == 'prove':
        return prove_pass(a)
    if a.cmd == 'merge':
        return merge(a.write)
    if a.cmd == 'status':
        return status()
    a.rows = a.rows_csv or ','.join(a.rows)
    return replay(a)


if __name__ == '__main__':
    sys.exit(main())
