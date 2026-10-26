#!/usr/bin/env python3
"""FL-62: scenarios aimed at the unexplained survivors of one upper row.

  fl62_target.py SURV.json ROW [ROW ...] --out FILE [--cap 4000] [--seed 1]          (run from outputs/blackmoor-decomp)

SURV.json is the output of scripts/fl58_classify.py (`rows_with_survivors`: [kind, rule, statement, line] per survivor; the unexplained ones have rule null). For each unexplained survivor at line n the
instructions of lines n-6..n are taken; every corpus scenario that runs line n is replayed on the original, and the memory cells that those instructions read (before the run wrote them) are set one at a time
to values that tell a narrower read, a changed literal, a flipped compare or a dropped statement apart: edge values, the constants of the row +-1 with and without extra bits above the low 8 or 16, the cell's
own value with bits set or cleared in each half and byte. Start registers get edge values too (a partial-register move keeps the rest of the register). The scenarios that fault in the original are dropped.
FILE (JSON): {row: [[seed, [[address, size, value], ...]], ...]}, the format of `fl62_onerow.py --scen`.
"""
import argparse
import json
from pathlib import Path
import random
import re
import sys
import time

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl41_mutation_check as M
import fl41_world as W
import lift_fl41 as L
import fl61_boundary as B

REG_VALUES = (0, 1, 0xffffffff, 0x80000000, 0x100, 0x10000, 0x01010101, 0xff00ff00, 0x7fffffff, 0x12345678, 0x7f, 0xff, 0xffff)


def cell_values(n, v, magic):
    mask = (1 << (8 * n)) - 1
    vals = set(B.EDGES[n])
    vals |= {(m + d) & mask for m in magic for d in (-2, -1, 0, 1, 2)}
    vals |= {(v + 1) & mask, (v - 1) & mask, (v + 2) & mask, (v - 2) & mask, (~v) & mask, v ^ 1, v ^ 0x80, v ^ 0x8000, v ^ 0x80000000}
    if n >= 2:
        vals |= {v | 0x100, v & 0xff, v ^ 0xff00, (v | 0x80) & mask}
    if n == 4:
        vals |= {v | 0x10000, v | 0x1000000, v | 0x80000000, v & 0xffff, v & 0xff, v ^ 0xffff0000, v ^ 0xff000000, (v & 0xffff) | 0x10000, (v & 0xff) | 0x100}
        for m in magic:
            vals |= {m | 0x10000, m | 0x100, m | 0x1000000, m | 0x80000000, m ^ 0xffff0000, m ^ 0xff00}
    vals = {x & mask for x in vals}
    vals.discard(v)
    return sorted(vals)


def lines_addresses(text, n):
    out = {}
    for j, line in enumerate(text.split('\n')):
        m = re.search(r'/\* (0x[0-9a-f]+):', line)
        if m:
            out[j] = int(m.group(1), 16)
    return out


def targeted(key, surv, text, corpus, rng, cap, window=6, shift=False, forward=0, all_cells=False):
    va = int(key, 16)
    spans = L.ledger_spans()
    _, callees, imports, fs, inline = L.lift(va, spans[va])
    row = W.row_info(va, spans[va], callees, imports, fs)
    magic = [m & 0xffffffff for m in row['magic']]
    addr_of = lines_addresses(text, 0)
    goals = []
    for kind, rule, stmt, n in surv:
        if rule is not None or n not in addr_of:
            continue
        near = {addr_of[j] for j in range(max(0, n - window), n + 1 + forward) if j in addr_of}
        goals.append((kind, n, addr_of[n], near))
    out, primary = [], []
    seeds = [(s[0], s[1]) for s in corpus[key]['seeds']]
    for seed, ov in seeds:
        tr = W.run_original(row, seed, [tuple(o) for o in ov], observe=True)
        if tr.fault:
            continue
        first_write = {}
        for k, (a, n_, v) in enumerate(tr.writes):
            for b in range(a, a + n_):
                first_write.setdefault(b, k)
        for kind, n, here, near in goals:
            if here not in tr.executed:
                continue
            cells = {}
            for (a, sz, v, wc), pc in zip(tr.reads, tr.read_pcs):
                if pc not in near or W.IMAGE_BASE <= a < W.DATA_START or a >= 0xfff00000 or sz not in (1, 2, 4):
                    continue
                if any(first_write.get(b, 1 << 30) < wc for b in range(a, a + sz)):
                    continue
                cells.setdefault((a, sz), v)
            for (a, sz), v in cells.items():
                for new in cell_values(sz, v, magic):
                    primary.append((seed, [list(o) for o in ov] + [[a, sz, new]]))         # FL-63: the cells next to the statement come first; the cap below must not drop them for the wide families
            if all_cells:          # FL-63: every cell the run reads (a value-chain input far from the mutated statement), not only the cells read next to it
                for (a, sz), v in {(a, sz): v for (a, sz, v, wc) in tr.reads if not (W.IMAGE_BASE <= a < W.DATA_START) and a < 0xfff00000 and sz in (1, 2, 4)
                                   and not any(first_write.get(b, 1 << 30) < wc for b in range(a, a + sz))}.items():
                    if (a, sz) in cells:
                        continue
                    for new in cell_values(sz, v, magic):
                        out.append((seed, [list(o) for o in ov] + [[a, sz, new]]))
            if kind in ('width', 'literal', 'drop'):          # bits above the low byte or half on ANY input cell of the run, and on what the callees return: a narrower read further down a value chain differs only then
                allcells = {}
                for (a, sz, v, wc), pc in zip(tr.reads, tr.read_pcs):
                    if W.IMAGE_BASE <= a < W.DATA_START or a >= 0xfff00000 or sz != 4 or any(first_write.get(b, 1 << 30) < wc for b in range(a, a + sz)):
                        continue
                    allcells.setdefault(a, v)
                for a, v in allcells.items():
                    if (a, 4) in cells:
                        continue
                    for new in (v | 0x10000, v | 0x1000000, v | 0x80000000, v | 0x100, v ^ 0xffff0000):
                        out.append((seed, [list(o) for o in ov] + [[a, 4, new & 0xffffffff]]))
                for k in range(min(len(tr.calls), 6)):
                    for reg in range(3):
                        for new in (0x10001, 0x10000, 0x80000000, 0x100, 0x01010101, 0xffff0000):
                            out.append((seed, [list(o) for o in ov] + [[W.STUB_OVR + 16 * k + 4 * reg, 4, new]]))
            if shift:          # FL-63: the pointer in ecx moved by a few bytes with every cell read inside its region moved along: partial-register moves keep the low bits of a pointer, and an odd or misaligned `this` is an input the draws never make
                regs0 = W.initial_state(row, seed)[0]
                W.apply_register_overrides(regs0, [tuple(o) for o in ov])
                this0 = regs0['ecx']
                region = {}
                for (a, sz, v, wc) in tr.reads:
                    if this0 <= a < this0 + 0x2000 and sz in (1, 2, 4) and not any(first_write.get(b, 1 << 30) < wc for b in range(a, a + sz)):
                        region.setdefault((a, sz), v)
                stack = {}
                for (a, sz, v, wc), pc in zip(tr.reads, tr.read_pcs):
                    if W.STACK_BASE <= a < W.STACK_BASE + W.STACK_SIZE and pc in near and sz in (1, 2, 4):
                        stack.setdefault((a, sz), v)
                for d in (1, 2, 3, 0x10001, -1):
                    base = [list(o) for o in ov if not (this0 <= o[0] < this0 + 0x2000)] + [[(a + d) & 0xffffffff, sz, v] for (a, sz), v in region.items()]
                    base.append([W.REG_OVERRIDE + 4 * W.REG_NAMES.index('ecx'), 4, (this0 + d) & 0xffffffff])
                    out.append((seed, base))
                    for (a, sz), v in stack.items():
                        for new in (v ^ 1, v & ~1, v | 1, v ^ 0xff):
                            out.append((seed, base + [[a, sz, new & ((1 << (8 * sz)) - 1)]]))
            if kind in ('literal', 'register', 'alu', 'drop'):
                for name in ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi'):
                    for val in REG_VALUES:
                        out.append((seed, [list(o) for o in ov] + [[W.REG_OVERRIDE + 4 * W.REG_NAMES.index(name), 4, val]]))
    rng.shuffle(out)
    rng.shuffle(primary)
    out = primary + out
    seen, picked = set(), []
    for seed, ov in out:
        k = (seed, tuple(map(tuple, ov)))
        if k in seen:
            continue
        seen.add(k)
        picked.append((seed, ov))
        if len(picked) >= cap * 2:
            break
    good = []
    for seed, ov in picked:
        tr = W.run_original(row, seed, [tuple(o) for o in ov])
        if not tr.fault:
            good.append([seed, ov])
            if len(good) >= cap:
                break
    return good, len(goals)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('surv')
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--out', required=True)
    ap.add_argument('--cap', type=int, default=4000)
    ap.add_argument('--seed', type=int, default=1)
    ap.add_argument('--window', type=int, default=6)
    ap.add_argument('--shift', action='store_true')
    ap.add_argument('--forward', type=int, default=0)
    ap.add_argument('--all-cells', action='store_true')
    a = ap.parse_args()
    surv = json.loads(Path(a.surv).read_text())['rows_with_survivors']
    corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())
    out = json.loads(Path(a.out).read_text()) if Path(a.out).exists() else {}
    rng = random.Random(a.seed)
    for key in a.rows:
        t0 = time.time()
        good, goals = targeted(key, surv.get(key, []), funcs[key], corpus, rng, a.cap, a.window, a.shift, a.forward, a.all_cells)
        out[key] = good
        print('%s unexplained survivors %d scenarios %d  %.0fs' % (key, goals, len(good), time.time() - t0), flush=True)
        Path(a.out).write_text(json.dumps(out))


if __name__ == '__main__':
    main()
