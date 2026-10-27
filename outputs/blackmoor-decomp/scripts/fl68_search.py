#!/usr/bin/env python3
"""FL-68: a goal-directed scenario search for rows the concolic generator (fl61/fl62) cannot set up (calls through a pointer, library callees it does not model, x87 helpers, ...) or leaves partial.

It works on the ORIGINAL bytes under Unicorn only (the translation is checked afterwards by `fl66_tested.py check --scen FILE`, exactly as for any other generator), so every scenario it writes is a plain
(seed, overrides) pair of the corpus format. Greedy hill climbing with three kinds of moves on a parent scenario:

  * compare flips: for every executed cmp/test the guided search records (fl41_world.cmp_decoders) set the cell the left operand was read from to the right operand's value (and +-1, 0, ~0) and the other way round;
  * boundary values: every memory cell the run reads before it writes it, set to an edge value of its width, a constant of the row +-1, or the cell's own value +-1;
  * register and callee-return moves: one start register, or one of eax/ecx/edx that the k-th callee stub returns, set to an edge value (REG_OVERRIDE / STUB_OVR);

and, once a round of single moves finds nothing, random combinations of two or three moves drawn from every move seen so far. A candidate is kept when the original runs it without a fault and it executes an
instruction or takes a jump direction that the kept set has not. The kept set becomes the parents of the next round.

  fl68_search.py ROW [ROW ...] --out FILE [--budget-s N] [--seed N] [--scen FILE ...]        (run from outputs/blackmoor-decomp; FILE maps each row to [[seed, [[address, size, value], ...]], ...])
"""
import argparse
import gc
import json
from pathlib import Path
import random
import sys
import time

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl66_tested as F

EDGES = {1: (0, 1, 0x7f, 0x80, 0xff), 2: (0, 1, 0x7f, 0x80, 0xff, 0x100, 0x101, 0x7fff, 0x8000, 0xffff, 0xff00),
         4: (0, 1, 2, 3, 4, 0xff, 0x100, 0x101, 0x7fff, 0x8000, 0xffff, 0x10000, 0x10001, 0x7fffffff, 0x80000000, 0xffffffff, 0xffff0000, 0xffff8000, 0xfffffffe, 0x1000, 0x400000, 0x401000)}
DECO = (0x100, 0x8000, 0x10000, 0x1000000, 0xff00, 0x80000000, 0x10001)
REG_VALUES = (0, 1, 2, 0xffffffff, 0x80000000, 0x7fffffff, 0x100, 0x10000, 0xffff, 0xff, 0x400000, 0x10)


def cells_of(W, tr):
    """The memory cells a run reads before it writes them (the inputs of the run) and their values."""
    first_write = {}
    for k, (a, n, v) in enumerate(tr.writes):
        for b in range(a, a + n):
            first_write.setdefault(b, k)
    cells = {}
    for a, n, v, wc in tr.reads:
        if W.IMAGE_BASE <= a < W.DATA_START or a >= 0xfff00000 or n not in (1, 2, 4):
            continue
        if any(first_write.get(b, 1 << 30) < wc for b in range(a, a + n)):
            continue
        cells.setdefault((a, n), v)
    return cells


def moves_of(W, row, tr, magic, goal=None):
    """The single-move candidates for a parent: lists of [address, size, value] to add to its overrides."""
    out, flips, edge, stubs, regs = [], [], [], [], []
    has_stub = hasattr(W, 'STUB_OVR')                       # the fl40 world has no callee-return or callee-store overrides
    sp0 = W.STACK_BASE + W.STACK_SIZE - 0x100 - 4 * (W.ARGS + 1)
    near_stack = tuple(sp0 + 4 * d for d in (-12, -8, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 6))       # a pointer into the function's own stack: a push or a local store changes what it points at
    cells = cells_of(W, tr)
    for (a, n), v in cells.items():
        mask = (1 << (8 * n)) - 1
        values = set(EDGES[n]) | {(m + d) & mask for m in magic for d in (-1, 0, 1)} | {(v + 1) & mask, (v - 1) & mask, (~v) & mask, v ^ 0x80, v ^ 0x8000}
        values |= {(m | d) & mask for m in magic for d in DECO} | {(v | d) & mask for d in DECO}
        values |= {(-m + d) & mask for m in magic for d in (-1, 0, 1)}          # a cell that an `lea r, [cell + imm]` / `add` turns into zero
        if n == 4:
            values |= set(near_stack)
        values.discard(v)
        for new in sorted(values):
            edge.append([[a, n, new]])
    keys = [k for k in cells if k[1] == 4][:14]
    for c in keys:                                          # a cell made equal to another input cell (a key compared against a table entry, a pointer against itself)
        for d in keys:
            if c != d and cells[c] != cells[d]:
                edge.append([[c[0], 4, cells[d]]])
    sources = [(W.REG_OVERRIDE + 4 * k, 4) for k in range(len(W.REG_NAMES))] + [(W.STUB_OVR + 16 * k + 4 * reg, 4) for k in range(min(len(tr.calls), 8) if has_stub else 0) for reg in range(3)] + list(cells)
    for ev in getattr(tr, 'events', ()):
        if len(ev) != 7:                                    # a string compare (address, 'str', esi, bytes)
            continue
        address, bits, av, bv, ca, cb, wc = ev
        if goal and address not in goal:
            continue
        mask = (1 << bits) - 1
        for cell, mine, other in ((ca, av, bv), (cb, bv, av)):
            if cell is None or cell[0] >= 0xffd00000:
                continue
            for new in {other & mask, (other + 1) & mask, (other - 1) & mask, 0, mask, (~other) & mask, 1, (mine + 1) & mask, (mine - 1) & mask}:
                if new != mine:
                    flips.append([[cell[0], cell[1], new]])
        if ca is None or cb is None:
            # an operand that is a register: the value comes from a start register, a callee return or a cell, so move each of those to the other operand's value (+-1)
            for src in sources:
                smask = (1 << (8 * src[1])) - 1
                for new in {av & smask, bv & smask, (av + 1) & smask, (av - 1) & smask, (bv + 1) & smask, (bv - 1) & smask}:
                    flips.append([[src[0], src[1], new]])
    for k, name in enumerate(W.REG_NAMES):
        for val in REG_VALUES + near_stack + tuple(m & 0xffffffff for m in magic[:8]):
            regs.append([[W.REG_OVERRIDE + 4 * k, 4, val & 0xffffffff]])
    for k in range(min(len(tr.calls), 8) if has_stub else 0):
        for reg in range(3):
            for val in REG_VALUES + tuple(m & 0xffffffff for m in magic[:6]):
                stubs.append([[W.STUB_OVR + 16 * k + 4 * reg, 4, val & 0xffffffff]])
    for k in range(min(len(tr.calls), 6) if has_stub else 0):   # a callee that stores into a cell the function reads again after the call (a global the callee sets)
        for (a, n), v in list(cells.items())[:24]:
            if n != 4:
                continue
            for val in (0, 1, 0xffffffff, (v + 1) & 0xffffffff) + tuple(m & 0xffffffff for m in magic[:3]):
                stubs.append([[W.STUB_WR + 16 * k, 4, a], [W.STUB_WR + 16 * k + 4, 4, val]])
    return flips, stubs, edge, regs


def merge_ov(ov, move):
    """The overrides of a parent with a move applied (a move replaces an earlier override of the same cell)."""
    cells = {(m[0], m[1]) for m in move}
    return [list(o) for o in ov if (o[0], o[1]) not in cells] + [list(m) for m in move]


def _faulted(W):
    tr = W.Trace()
    tr.fault = 'reserved override page'
    return tr


def ok_now(done):
    return done()[0]


def disp_magic(row):
    """the displacements of the row's `lea` and arithmetic memory operands (`lea esi, [eax + 0x20000]`: a cell of -0x20000 makes the result zero), which the world's own magic list leaves out"""
    import capstone
    from capstone import x86_const as X
    import original_differential as od
    pe = od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = row['va'] - pe.image_base
    out = []
    for i in md.disasm(pe.image[off:off + row['body']], row['va']):
        for op in i.operands:
            if op.type == X.X86_OP_MEM and (op.mem.base or op.mem.index) and abs(op.mem.disp) >= 0x10 and op.mem.disp & 0xffffffff not in out:
                out.append(op.mem.disp & 0xffffffff)
    return out[:12]


def search(key, budget_s, rng, extra=(), verbose=True):
    pool = F.pool_of(key)
    p = F.POOLS[pool]
    W, G = F.world(p['world'])
    row = F.row_info(pool, key)
    if not getattr(W, '_fl68_cached', False):             # the pages of a seed are drawn the same way on every run of the seed: draw them once
        orig_fill, pages = W.page_fill, {}

        def page_fill(seed, magic, page):
            k = (seed, page, tuple(magic))
            if k not in pages:
                pages[k] = orig_fill(seed, magic, page)
            return pages[k]
        W.page_fill = page_fill
        W._fl68_cached = True
    W.INSTRUCTION_LIMIT = 200000          # a candidate that runs longer is a hang for this search (FL-45: kill under max(100x port steps, 200,000)) and is dropped as a fault
    magic = [m & 0xffffffff for m in row['magic']] + disp_magic(row)
    t0 = time.time()
    ex, ed, kept, seen = set(), set(), [], set()
    runs = faults = 0

    def run(seed, ov, observe=False):
        nonlocal runs, faults
        runs += 1
        try:
            tr = W.run_original(row, seed, [tuple(o) for o in ov], observe=observe)
        except IndexError:                                  # a move on a cell in the reserved override pages above 0xffd00000
            runs -= 1
            return _faulted(W)
        if tr.fault:
            faults += 1
        return tr

    def key_of(seed, ov):
        return (seed, tuple(sorted((o[0], o[1], o[2]) for o in ov)))

    def offer(seed, ov, tr):
        nonlocal ex, ed
        if tr.fault:
            return False
        if tr.executed <= ex and tr.edges <= ed:
            return False
        ex |= tr.executed
        ed |= tr.edges
        kept.append((seed, [list(o) for o in ov]))
        return True

    known = F.known_scenarios(key, p['world'], extra)
    gc.collect()
    gc.freeze()                       # the loaded tables are millions of objects: W.run_original's gc.collect() after every run would rescan them (0.15 s a run)
    parents = []
    for seed, ov in known:
        k = key_of(seed, ov)
        if k in seen:
            continue
        seen.add(k)
        tr = run(seed, ov)
        if tr.fault:
            continue
        parents.append((seed, [list(o) for o in ov]))
        offer(seed, ov, tr)
        if time.time() - t0 > budget_s / 3:
            break
    if not parents:
        for s in range(1, 4):                          # no scenario of any table runs: try small start values of eax (a size or a count) and ecx on a few seeds
            for v in (None, 0, 1, 4, 0x100, 0xfff, 0x1000, 0x1fff, 0x2800):
                ov = [] if v is None else [[W.REG_OVERRIDE, 4, v]]
                tr = run(s, ov)
                if not tr.fault and offer(s, ov, tr):
                    parents.append((s, ov))
        parents = parents or [(1, [])]

    memo = {}

    def done():
        k = (len(ex), len(ed))
        if memo.get('k') != k:
            got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
            memo['k'], memo['v'] = k, (not missing and not untaken, (got, total, taken, dirs))
        return memo['v']

    atoms, flip_atoms = [], []
    rounds = 0
    deep_done = False
    while time.time() - t0 < budget_s:
        ok, cov = done()
        if ok:
            break
        rounds += 1
        before = len(kept)
        frontier = list(kept)[-24:] if len(kept) > 24 else list(kept)
        progress = False
        got, total, taken, dirs, missing, untaken = G.covers(row, ex, ed)
        goal = G.jcc_cmp_addresses(row, untaken)
        per_parent = []
        for seed, ov in frontier:
            if time.time() - t0 > budget_s:
                break
            tr = run(seed, ov, observe=True)
            if tr.fault:
                continue
            classes = moves_of(W, row, tr, magic, goal)
            for cls in classes:
                rng.shuffle(cls)
            per_parent.append((seed, ov, classes))
            atoms.extend(m for cls in classes for m in cls)
            flip_atoms.extend(classes[0])
        for ci in range(4):                      # compare flips of every parent first, then callee returns, cell edges and registers
            for seed, ov, classes in per_parent:
                for mv in classes[ci]:
                    if time.time() - t0 > budget_s or ok_now(done):
                        break
                    nov = merge_ov(ov, mv)
                    k = key_of(seed, nov)
                    if k in seen:
                        continue
                    seen.add(k)
                    if offer(seed, nov, run(seed, nov)):
                        progress = True
            if time.time() - t0 > budget_s or ok_now(done):
                break
        if len(kept) == before and not progress and not deep_done:
            # depth two: a register or callee-return move that adds no coverage by itself but makes the run read other cells (a null pointer reads cell 4): try the cell and compare moves on top of it
            deep_done = True
            deep_seen = set()
            cand = []
            for seed, ov, classes in per_parent:
                cand.extend((seed, ov, mv) for mv in classes[1] + classes[3] + classes[2])
            rng.shuffle(cand)
            base_cells = {}
            for seed, ov, mv in cand[:1500]:
                if time.time() - t0 > budget_s or ok_now(done):
                    break
                nov = merge_ov(ov, mv)
                k = key_of(seed, nov)
                if k in deep_seen:
                    continue
                deep_seen.add(k)
                tr = run(seed, nov, observe=True)
                if tr.fault:
                    continue
                if offer(seed, nov, tr):
                    progress = True
                    continue
                if seed not in base_cells:
                    base_cells[seed] = {}
                cells = frozenset(cells_of(W, tr))
                if cells in base_cells[seed]:
                    continue
                base_cells[seed][cells] = 1
                kids = moves_of(W, row, tr, magic, None)
                for cls, cap in ((kids[0], 400), (kids[2], 60)):
                    rng.shuffle(cls)
                    for kv in cls[:cap]:
                        if time.time() - t0 > budget_s or ok_now(done):
                            break
                        kov = merge_ov(nov, kv)
                        kk = key_of(seed, kov)
                        if kk in seen:
                            continue
                        seen.add(kk)
                        if offer(seed, kov, run(seed, kov)):
                            progress = True
            if progress or len(kept) != before:
                continue
        if len(kept) == before and not progress:
            # combinations of two or three moves
            if not atoms:
                break
            tries = 0
            while time.time() - t0 < budget_s and tries < 3000 and not done()[0]:
                tries += 1
                seed, ov = rng.choice(kept)
                nov = ov
                if flip_atoms and rng.random() < 0.7:
                    nov = merge_ov(nov, rng.choice(flip_atoms))
                for _ in range(rng.choice((1, 1, 2))):
                    nov = merge_ov(nov, rng.choice(atoms))
                k = key_of(seed, nov)
                if k in seen:
                    continue
                seen.add(k)
                offer(seed, nov, run(seed, nov))
            if len(kept) == before:
                break
    ok, cov = done()
    if verbose:
        print('%s runs %d (faults %d) kept %d  instructions %d/%d directions %d/%d  %s  %.0fs' % (key, runs, faults, len(kept), cov[0], cov[1], cov[2], cov[3], 'FULL' if ok else 'partial', time.time() - t0), flush=True)
    return kept, ok


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--out', required=True)
    ap.add_argument('--budget-s', type=int, default=60)
    ap.add_argument('--seed', type=int, default=1)
    ap.add_argument('--scen', action='append', default=[])
    a = ap.parse_args()
    out = json.loads(Path(a.out).read_text()) if Path(a.out).exists() else {}
    rng = random.Random(a.seed)
    for key in a.rows:
        kept, ok = search(key, a.budget_s, rng, a.scen)
        out[key] = [[s, ov] for s, ov in kept]
        Path(a.out).write_text(json.dumps(out))


if __name__ == '__main__':
    main()
