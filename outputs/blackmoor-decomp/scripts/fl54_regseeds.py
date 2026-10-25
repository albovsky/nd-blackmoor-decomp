#!/usr/bin/env python3
"""FL-54: killing scenarios that change a START REGISTER of a corpus seed (tests/fl40_world.py REG_OVERRIDE). A seed's own `this` (ecx) is aligned and in its region, so a mutant that keeps one bit of a
masked register, reads only the low word of a saved `this`, or counts in 8 or 16 bits is never told apart by the memory-cell scenarios of fl49_targeted.py.

For each row of the held file and each of the first N corpus seeds that does not fault, the registers eax ecx edx ebx esi edi ebp are set one at a time to variants of their start value (+-1..3, ^1, bit
patterns above the 8/16-bit width, 0, 1, -1); a scenario counts only if the ORIGINAL does not fault and the UNMUTATED translation agrees with it; it kills every alive mutant of the wanted (kind, line)s
whose translation then differs (or crashes, or hangs past a 20 s alarm).

  fl54_regseeds.py --held HELD.json --out OUT.json [--rows a,b] [--seeds 10] [--jobs 4] [--apply]      (run from outputs/blackmoor-decomp; --apply appends the killing scenarios to tests/fl40_corpus.json)
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
import fl40_world as W
import fl40_mutation_check as M
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl49_targeted as T

SOURCE = PROJECT / 'src/original_methods_fl40.c'
CORPUS = PROJECT / 'tests/fl40_corpus.json'
CELL_BASES = 12     # register-variant scenarios per row that get the cell stage


def variants(v):
    out = {0, 1, 0xffffffff, 0x80000000, v ^ 1, v ^ 0x100, v ^ 0x10000, v | 0x80, v | 0x8000}
    for d in (1, 2, 3, 4):
        out.add((v + d) & 0xffffffff)
        out.add((v - d) & 0xffffffff)
    out.add(v | 0x100)
    out.add(v | 0x10000)
    out.add((v & ~0xff) | 0x80)
    out.discard(v)
    return sorted(x & 0xffffffff for x in out)


def work(args):
    key, entry, text, helper, wanted, seed_limit = args
    va = int(key, 16)
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    picked = M.mutants(text, va, random.Random(va), 100000, wanted)
    if not picked:
        return key, {'found': [], 'alive': 0, 'tried': 0}
    named = [(k, n, re.sub(r'm%x_mut\d+' % va, 'm%x_mut%d' % (va, i), t, count=1)) for i, (k, n, t) in enumerate(picked)]
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / 'm.c'
        src.write_text('#include "original_methods_fl40.h"\n' + helper + text + '\n' + '\n'.join(t for _, _, t in named))
        built = subprocess.run(['cc', '-std=c11', '-O0', '-shared', '-fPIC', '-w', '-I%s' % (PROJECT / 'src'), str(src), '-o', str(Path(tmp) / 'm.so')], capture_output=True, text=True)
        if built.returncode:
            return key, {'error': built.stderr[:300]}
        lib = ctypes.CDLL(str(Path(tmp) / 'm.so'))

        class Shim:
            def __init__(self, name):
                self.name = name

            def __getattr__(self, n):
                return getattr(lib, self.name)

        alive = set(range(len(named)))
        found, tried = [], 0
        agreeing = []
        lines = text.split('\n')
        at = T.alive_instructions(lines, wanted)
        by_line = {}
        for i, (k, n, t) in enumerate(named):
            by_line.setdefault(n, set()).add(i)
        base = [(sd, [tuple(o) for o in ov]) for sd, ov in entry['seeds']]
        used = 0
        for sd, ov in base:
            if not alive or used >= seed_limit:
                break
            try:
                o = W.run_original(row, sd, ov)
            except W.Fault:
                continue
            if o.fault:
                continue
            used += 1
            regs, _, _ = W.initial_state(row, sd)
            W.apply_register_overrides(regs, ov)
            for idx, name in enumerate(W.REG_NAMES):
                shifted = []
                if name == 'ecx':        # `this` moved by d bytes together with the override cells that lie around it (an unaligned object with the same contents)
                    this = regs['ecx']
                    for d in (1, 2, 3, 0x10000):
                        shifted.append(('shift%d' % d, tuple(sorted(((a + d if this - 0x100 <= a < this + 0x4000 else a), s_, v_) for a, s_, v_ in ov if a < W.REG_OVERRIDE)) + ((W.REG_OVERRIDE + 4, 4, (this + d) & 0xffffffff),)))
                for new in list(variants(regs[name])) + shifted:
                    if not alive:
                        break
                    if isinstance(new, tuple):
                        label, scen = new
                        new = label
                    else:
                        scen = None
                    scen = scen if scen is not None else tuple(sorted(set(ov) | {(W.REG_OVERRIDE + 4 * idx, 4, new)}, key=lambda x: (x[0], x[1], x[2]))) if not any(a == W.REG_OVERRIDE + 4 * idx for a, _, _ in ov) else tuple((a, s_, (new if a == W.REG_OVERRIDE + 4 * idx else v_)) for a, s_, v_ in ov)
                    tried += 1
                    try:
                        o2 = W.run_original(row, sd, scen)
                        if o2.fault:
                            continue
                        t = W.run_native(lib, row, sd, scen)
                    except W.Fault:
                        continue
                    if t.fault or t.digest() != o2.digest():
                        continue
                    ref = o2.digest()
                    killed = []
                    for k in sorted(alive):
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
                    elif len(agreeing) < CELL_BASES and (isinstance(new, str) or new in (regs[name] + 1, regs[name] + 2, regs[name] ^ 1, regs[name] | 0x10000, regs[name] | 0x100)):
                        agreeing.append((sd, scen))
        for sd, scen in agreeing:                      # stage 2: the register variant plus one changed cell of each mutated instruction's memory operand
            if not alive:
                break
            for address, kinds in sorted(at.items()):
                if not alive:
                    break
                targets = set().union(*(by_line.get(n, set()) for _, n in kinds)) & alive
                if not targets:
                    continue
                md, ins = T.instruction_at(row, address)
                store = []
                o = W.run_original(row, sd, scen, observe=True, probes={address: T.make_probe(md, ins, store)})
                if o.fault or not store:
                    continue
                cells, values, _wc = store[0]
                for (a, n, v) in cells:
                    for new_v in T.variants(v, n, [op.imm & 0xffffffff for op in ins.operands if op.type == T.CX.X86_OP_IMM], [x for x in values if x != v]):
                        if not (alive & targets):
                            break
                        merged = {(x, y): z for x, y, z in scen}
                        merged[(a, n)] = new_v
                        scen2 = tuple(sorted((x, y, z) for (x, y), z in merged.items()))
                        tried += 1
                        try:
                            o2 = W.run_original(row, sd, scen2)
                            if o2.fault:
                                continue
                            t = W.run_native(lib, row, sd, scen2)
                        except W.Fault:
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
                                    m = W.run_native(Shim('m%x_mut%d' % (va, k)), row, sd, scen2)
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
                            found.append((sd, [list(c) for c in scen2], [named[k][:2] for k in killed]))
                            alive -= set(killed)
        return key, {'found': found, 'alive': len(alive), 'tried': tried}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--held', required=True)
    ap.add_argument('--rows')
    ap.add_argument('--seeds', type=int, default=10)
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--out', required=True)
    ap.add_argument('--apply', action='store_true')
    a = ap.parse_args()
    held = json.loads(Path(a.held).read_text())['rows']
    corpus = json.loads(CORPUS.read_text())
    funcs = M.split_functions(SOURCE.read_text())
    helper = funcs.get('0x50c920', '')
    jobs = []
    for key, items in held.items():
        if a.rows and key not in a.rows.split(','):
            continue
        wanted = {(i['kind'], i['line']) for i in items if i['kind'] != 'unchecked'}
        if wanted:
            jobs.append((key, corpus[key], funcs[key], helper if 'FL40_CALL_LIFTED' in funcs[key] else '', wanted, a.seeds))
    result = {}
    with mp.Pool(a.jobs, maxtasksperchild=1) as pool:
        for key, res in pool.imap_unordered(work, jobs):
            result[key] = res
            if 'error' in res:
                print(key, 'ERROR', res['error'], flush=True)
                continue
            print('%s tried %d scenarios; %d scenarios kill %d mutants; %d still alive' % (key, res['tried'], len(res['found']), sum(len(f[2]) for f in res['found']), res['alive']), flush=True)
            Path(a.out).write_text(json.dumps(result, indent=1, sort_keys=True) + '\n')
    if a.apply:
        corpus = json.loads(CORPUS.read_text())
        for key, res in result.items():
            corpus[key]['seeds'].extend([sd, ov] for sd, ov, _ in res.get('found', []))
        CORPUS.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')


if __name__ == '__main__':
    main()
