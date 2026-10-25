#!/usr/bin/env python3
"""FL-55: killing scenarios of a second kind for the survivors that scripts/fl45_targeted.py leaves alive. That tool changes input cells; this one lets a CALLEE change the state:

  stubwrite   the k-th callee stub also stores a dword at a cell that the mutated instruction reads (a reload of a global, a frame slot or an argument that a callee may have rewritten
              between two reads; FL-48's STUB_WR override, honoured by both sides)
  stub value  the k-th callee returns a chosen eax, ecx or edx (a value with a bit above the narrowed width set, 0, -1, ...), for a mutant that narrows the read of what a callee returned

A scenario counts only if the ORIGINAL does not fault and the UNMUTATED translation agrees with it (the same rule as every other scenario); it kills the mutants whose translation then differs.
The scenarios found are written to --out in the format of fl45_targeted.py (scripts/fl48_apply.py adds them to the corpus).

  fl55_extra.py --survivors <fl41_survivors.py output> --rows 0x4d3137,... [--seeds 12] [--jobs 2] --out FILE       (run from outputs/blackmoor-decomp)
"""
import argparse
import ctypes
import json
import multiprocessing as mp
import os
from pathlib import Path
import random
import re
import signal
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
from capstone import x86_const as CX
import fl41_world as W
import fl41_mutation_check as M
import fl45_targeted as T

WIDE = (0x10000, 0x100, 0x80000000, 0x10001, 0x1000000)


def candidates(v, size):
    out = {0, 1, 0xffffffff, 0x7fffffff}
    for x in WIDE:
        out.add((v | x) & 0xffffffff)
        out.add((v ^ x) & 0xffffffff)
    out.add((v + 1) & 0xffffffff)
    out.add((v - 1) & 0xffffffff)
    out.discard(v)
    return sorted(out)


def work(args):
    try:
        return work_inner(args)
    except Exception as ex:
        return args[0], {'error': '%s: %s' % (type(ex).__name__, str(ex)[:200]), 'found': [], 'alive': -1, 'tried': 0}


def work_inner(args):
    key, entry, text, helper, wanted, seed_limit = args
    va = int(key, 16)
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    muts = M.mutants(text, va, random.Random(va), 100000, True)
    picked = [(k, n, t) for k, n, t in muts if (k, n, M.line_hash(t, n)) in wanted]       # mutant by mutant: the idents of the survivors no rule explains
    if not picked:
        return key, {'found': [], 'alive': 0, 'tried': 0}
    named = [(k, n, re.sub(r'm%x_mut\d+' % va, 'm%x_mut%d' % (va, i), t, count=1)) for i, (k, n, t) in enumerate(picked)]
    at = T.alive_instructions(text.split('\n'), {(k, n) for k, n, _ in wanted})
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / 'm.c'
        src.write_text('#include "original_methods_fl41.h"\n' + helper + text + '\n' + '\n'.join(t for _, _, t in named))
        built = subprocess.run(['cc', '-std=c11', '-O0', '-shared', '-fPIC', '-w', '-I%s' % (PROJECT / 'src'), str(src), '-o', str(Path(tmp) / 'm.so')], capture_output=True, text=True)
        if built.returncode:
            return key, {'error': built.stderr[:300], 'found': [], 'alive': -1, 'tried': 0}
        lib = ctypes.CDLL(str(Path(tmp) / 'm.so'))

        class Shim:
            def __init__(self, name):
                self.name = name

            def __getattr__(self, n):
                return getattr(lib, self.name)

        alive = set(range(len(named)))
        by_line = {}
        for i, (k, n, t) in enumerate(named):
            by_line.setdefault(n, set()).add(i)
        found, tried = [], 0
        base = [(sd, [tuple(o) for o in ov]) for sd, ov in entry['seeds']]

        def evaluate(sd, scen, pool):
            """kill list of the mutants in `pool` on scenario (sd, scen), or None when the scenario is unusable (the original faults or the unmutated translation differs)"""
            o2 = W.run_original(row, sd, scen)
            if o2.fault:
                return None
            t = W.run_native(lib, row, sd, scen)
            if t.fault or t.digest() != o2.digest():
                return None
            ref = o2.digest()
            killed = []
            for k in sorted(pool):
                r_fd, w_fd = os.pipe()
                pid = os.fork()
                if pid == 0:
                    try:
                        signal.alarm(20)
                        os.close(r_fd)
                        m = W.run_native(Shim('m%x_mut%d' % (va, k)), row, sd, scen)
                        os.write(w_fd, b'1' if (m.fault or m.digest() != ref) else b'0')
                    finally:
                        os._exit(0)
                os.close(w_fd)
                data = os.read(r_fd, 4)
                os.close(r_fd)
                os.waitpid(pid, 0)
                if data != b'0':
                    killed.append(k)
            return killed

        if row.get('fpu'):
            # float inputs: the cells that an x87 load or arithmetic instruction reads (from the corpus seeds) are set to small, ordinary floats, so that rounding and huge magnitudes do not hide a change
            pe = W.od.load_image()
            md = T.capstone.Cs(T.capstone.CS_ARCH_X86, T.capstone.CS_MODE_32)
            md.detail = True
            off = va - pe.image_base
            x87_mem = [i for i in md.disasm(pe.image[off:off + row['body']], va) if i.mnemonic.startswith('f') and any(op.type == CX.X86_OP_MEM for op in i.operands)]
            nice = [0x3f000000, 0x3fc00000, 0x40200000, 0x3e800000, 0xbfc00000, 0x40a00000, 0x3f800000, 0x41200000]
            for sd, ov in base[:seed_limit]:
                cells = {}
                for ins in x87_mem:
                    store = []
                    try:
                        W.run_original(row, sd, ov, observe=True, probes={ins.address: T.make_probe(md, ins, store)})
                    except Exception:
                        continue
                    for c in (store[0][0] if store else []):
                        if c[1] == 4 and ins.mnemonic not in ('fstp', 'fst', 'fistp') and not (W.IMAGE_BASE <= c[0] < W.DATA_START):      # the image below the data section is constant
                            cells[c[0]] = c[2]
                addrs = sorted(cells)
                for shift in range(len(nice)):
                    scen = tuple(sorted(set(tuple(ov) + tuple((a_, 4, nice[(k + shift) % len(nice)]) for k, a_ in enumerate(addrs)))))
                    tried += 1
                    if not alive:
                        break
                    try:
                        killed = evaluate(sd, scen, alive)
                    except Exception as ex_:
                        if os.environ.get('FL55_DEBUG'):
                            print('float pass', sd, shift, 'error', repr(ex_)[:150], flush=True)
                        continue
                    if os.environ.get('FL55_DEBUG'):
                        print('float pass', sd, shift, 'cells', len(addrs), 'usable' if killed is not None else 'unusable', killed, flush=True)
                    if killed:
                        found.append((sd, [list(c) for c in scen], [named[k][:2] for k in killed]))
                        alive -= set(killed)
        for address, kinds in sorted(at.items()):
            targets = set().union(*(by_line.get(n, set()) for _, n in kinds)) & alive
            if not targets:
                continue
            md, ins = T.instruction_at(row, address)
            reaching = []
            for sd, ov in base:
                store = []
                try:
                    o = W.run_original(row, sd, ov, observe=True, probes={address: T.make_probe(md, ins, store)})
                except Exception:
                    continue
                if o.fault or not store:
                    continue
                reaching.append((sd, ov, o, store[0]))
                if len(reaching) >= seed_limit:
                    break
            for sd, ov, o, (cells, values, wc) in reaching:
                if not (alive & targets):
                    break
                scenarios = []
                for k_ in range(len(o.calls)):
                    for (a, n, v) in cells:
                        for new in candidates(v, n):
                            scenarios.append(tuple(ov) + ((W.STUB_WR + 16 * k_, 4, a), (W.STUB_WR + 16 * k_ + 4, 4, new)))
                    for r_, v_ in enumerate(o.calls[k_][4:7]):
                        if v_ in values:
                            for new in candidates(v_, 4):
                                scenarios.append(tuple(ov) + ((W.STUB_OVR + 16 * k_ + 4 * r_, 4, new),))
                for (a, n, v) in cells:                  # neighbour cells: a mutant that reads the address one byte off (or another width) sees the bytes around the cell, so they must differ from the cell's own
                    if n != 4:
                        continue
                    xs = {v, 0, 1, 0x7fffffff, 0x80000000} | {x for x in values if x != v}
                    xs |= {(x + d) & 0xffffffff for x in values for d in (-1, 1)}
                    for x in sorted(xs):
                        for hi in (0, 0x7f, 0xff):
                            for lo in (0, 0x7f, 0xff):
                                scenarios.append(tuple(ov) + ((a, 4, x), (a + 4, 1, hi), (a - 1, 1, lo)))
                for scen in scenarios:
                    if not (alive & targets):
                        break
                    scen = tuple(sorted(set(scen)))
                    tried += 1
                    try:
                        o2 = W.run_original(row, sd, scen)
                        if o2.fault:
                            continue
                        t = W.run_native(lib, row, sd, scen)
                    except Exception:
                        continue
                    if t.fault or t.digest() != o2.digest():
                        continue
                    ref = o2.digest()
                    killed = []
                    for k in sorted(alive & targets):
                        r_fd, w_fd = os.pipe()
                        pid = os.fork()
                        if pid == 0:
                            try:
                                signal.alarm(20)
                                os.close(r_fd)
                                m = W.run_native(Shim('m%x_mut%d' % (va, k)), row, sd, scen)
                                os.write(w_fd, b'1' if (m.fault or m.digest() != ref) else b'0')
                            finally:
                                os._exit(0)
                        os.close(w_fd)
                        data = os.read(r_fd, 4)
                        os.close(r_fd)
                        os.waitpid(pid, 0)
                        if data != b'0':
                            killed.append(k)
                    if killed:
                        found.append((sd, [list(c) for c in scen], [named[k][:2] for k in killed]))
                        alive -= set(killed)
        return key, {'found': found, 'alive': len(alive), 'tried': tried}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--survivors', required=True)
    ap.add_argument('--rows', required=True)
    ap.add_argument('--seeds', type=int, default=12)
    ap.add_argument('--jobs', type=int, default=2)
    ap.add_argument('--out', required=True)
    a = ap.parse_args()
    surv = json.loads(Path(a.survivors).read_text())
    corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())
    helper = funcs.get('0x50c920', '')
    jobs = []
    for key in a.rows.split(','):
        wanted = {(m[0], m[1], m[2]) for m in surv['mutants'].get(key, []) if m[3] is None}      # only the survivors no rule explains
        if wanted:
            jobs.append((key, corpus[key], funcs[key], helper if 'FL41_CALL_LIFTED' in funcs[key] else '', wanted, a.seeds))
    result = {}
    with mp.Pool(a.jobs, maxtasksperchild=1) as pool:
        for key, res in pool.imap_unordered(work, jobs):
            result[key] = res
            if 'error' in res:
                print(key, 'ERROR', res['error'], flush=True)
                continue
            print('%s tried %d scenarios; %d scenarios kill %d mutants; %d still alive' % (key, res['tried'], len(res['found']), sum(len(f[2]) for f in res['found']), res['alive']), flush=True)
            Path(a.out).write_text(json.dumps(result, indent=1, sort_keys=True) + '\n')


if __name__ == '__main__':
    main()
