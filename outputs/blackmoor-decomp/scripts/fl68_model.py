#!/usr/bin/env python3
"""FL-68: scenarios from the models of the FL-67 prover.

`scripts/fl67_infeasible.py` asks z3 whether a missing instruction or an untaken jump direction can happen at all; when the answer is "sat" the solver holds a start state that reaches it (registers, the
function's own frame, memory). This turns that model into scenarios of the corpus format ((seed, overrides)): the start registers become REG_OVERRIDE cells, the bytes of the model's start memory and frame
become one-byte overrides (the frame shifted to the world's entry esp), and the original is run on the result. A model that the original does not take is dropped (the prover over-approximates: loops are
generalised, callees return anything), and the target stays open. Only the ORIGINAL runs here; the translation is compared afterwards by `fl66_tested.py check`, like any other scenario file.

  fl68_model.py ROW [ROW ...] --out FILE [--timeout-ms N] [--tries N]            (run from outputs/blackmoor-decomp; FILE maps each row to [[seed, [[address, size, value], ...]], ...])
"""
import argparse
import json
from pathlib import Path
import sys
import time

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import z3
import fl66_tested as F
import fl67_infeasible as P
import fl68_search as S

M32 = 0xffffffff


def store_chain(e):
    """{address: byte} of a z3 array model value built from Store/K terms (the default is left to the world)."""
    out = {}
    while z3.is_store(e):
        a, v = e.arg(1), e.arg(2)
        if z3.is_bv_value(a) and z3.is_bv_value(v):
            out.setdefault(a.as_long(), v.as_long())
        e = e.arg(0)
    return out


def formulas(an, targets):
    """(label, z3 formula) for each missing instruction and untaken direction of the row"""
    out = []
    for a in targets.get('missing', []):
        a = int(a, 16) if isinstance(a, str) else a
        block = [b for b, blk in an.blocks.items() if any(i.address == a for i in blk['insns'])]
        conds = [c for n, c in an.ic.items() if block and n[0] == block[0]]
        if conds:
            out.append(('ins %#x' % a, z3.Or(*conds) if len(conds) > 1 else conds[0]))
    for a, name in targets.get('untaken', []):
        a = int(a, 16) if isinstance(a, str) else a
        kind = 'taken' if name == 'taken' else 'fall'
        block = [b for b, blk in an.blocks.items() if blk['insns'][-1].address == a]
        conds = [c for (n, k, t), c in an.edge.items() if block and n[0] == block[0] and k == kind]
        if conds:
            out.append(('dir %#x %s' % (a, name), z3.Or(*conds) if len(conds) > 1 else conds[0]))
    return out


def scenario_of(W, model):
    """the overrides of a model: registers, frame and memory bytes, shifted so that the model's entry esp is the world's"""
    sp0 = W.STACK_BASE + W.STACK_SIZE - 0x100 - 4 * (W.ARGS + 1)
    val = lambda name, bits=32: model.eval(z3.BitVec(name, bits), model_completion=True).as_long()
    esp = val('s_esp')
    delta = (sp0 - esp) & M32

    def shift(x):
        return (x + delta) & M32 if ((x - esp) & M32) < 0x4000 or ((esp - x) & M32) < 0x4000 else x
    ov = []
    for k, name in enumerate(W.REG_NAMES):
        ov.append([W.REG_OVERRIDE + 4 * k, 4, shift(val('s_' + name))])
    cells = {}
    for arr_name, stack in (('s_frm', True), ('s_mem', False)):
        arr = z3.Array(arr_name, z3.BitVecSort(32), z3.BitVecSort(8))
        decl = [d for d in model.decls() if d.name() == arr_name]
        if not decl:
            continue
        for a, v in store_chain(model[decl[0]]).items():
            a = (a + delta) & M32 if stack else shift(a)
            if a < W.IMAGE_BASE or a >= 0xffd00000:
                continue
            cells[a] = v
    for a, v in sorted(cells.items()):
        ov.append([a, 1, v])
    return ov


def settle(W, row, seed, ov):
    """The model's memory is zero wherever it names no byte, the world's is seeded: set every input cell the run reads and the model did not name to zero (a few rounds, a new cell can appear behind a pointer)."""
    ov = [list(o) for o in ov]
    for _ in range(4):
        tr = W.run_original(row, seed, [tuple(o) for o in ov], observe=True)
        if tr.fault:
            break
        named = {o[0] + k for o in ov if o[0] < W.REG_OVERRIDE for k in range(o[1])}
        new = [[a, n, 0] for (a, n), v in S.cells_of(W, tr).items() if not any(a + k in named for k in range(n))]
        if not new:
            break
        ov += new
    return ov


def run_row(key, timeout_ms, tries, verbose=True):
    pool = F.pool_of(key)
    p = F.POOLS[pool]
    W, G = F.world(p['world'])
    row = F.row_info(pool, key)
    res = json.loads((F.ROWS_DIR / (key + '.json')).read_text())
    targets = {'missing': res.get('missing', []), 'untaken': res.get('untaken', [])}
    t0 = time.time()
    try:
        an = P.Analysis(P.row_of(key), P.load_image(), timeout_ms)
        an.run()
    except P.Unsupported as ex:
        if verbose:
            print(key, 'unsupported', str(ex)[:80], flush=True)
        return [], 0, 0
    known = F.known_scenarios(key, p['world'])
    ex, ed = set(), set()
    for seed, ov in known:
        tr = W.run_original(row, seed, [tuple(o) for o in ov])
        if not tr.fault:
            ex |= tr.executed
            ed |= tr.edges
    kept, hit, total = [], 0, 0
    for label, f in formulas(an, targets):
        total += 1
        s = z3.Solver()
        s.set('timeout', timeout_ms)
        s.add(*an.M.facts)
        s.add(f)
        got = False
        for _ in range(tries):
            if s.check() != z3.sat:
                break
            m = s.model()
            ov0 = scenario_of(W, m)
            for seed in (1, 2, 3):
                ov = settle(W, row, seed, ov0)
                tr = W.run_original(row, seed, [tuple(o) for o in ov])
                if not tr.fault and not (tr.executed <= ex and tr.edges <= ed):
                    ex |= tr.executed
                    ed |= tr.edges
                    kept.append([seed, ov])
                    got = True
                    break
            if got:
                break
            # block this model's registers and ask for another
            s.add(z3.Or(*[z3.BitVec('s_' + n, 32) != m.eval(z3.BitVec('s_' + n, 32), model_completion=True) for n in W.REG_NAMES]))
        hit += got
        if verbose:
            print('  %s %s' % (label, 'hit' if got else 'no'), flush=True)
    cov = G.covers(row, ex, ed)
    if verbose:
        print(key, 'targets %d hit %d kept %d  instructions %d/%d directions %d/%d  %.0fs' % (total, hit, len(kept), cov[0], cov[1], cov[2], cov[3], time.time() - t0), flush=True)
    return kept, hit, total


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--out', required=True)
    ap.add_argument('--timeout-ms', type=int, default=20000)
    ap.add_argument('--tries', type=int, default=4)
    a = ap.parse_args()
    out = json.loads(Path(a.out).read_text()) if Path(a.out).exists() else {}
    for key in a.rows:
        kept, hit, total = run_row(key, a.timeout_ms, a.tries)
        if kept:
            out[key] = kept
            Path(a.out).write_text(json.dumps(out))


if __name__ == '__main__':
    main()
