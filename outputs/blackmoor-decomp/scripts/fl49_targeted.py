#!/usr/bin/env python3
"""FL-49: the fl45_targeted.py method for the translated rows below 0x480000 (tests/fl40_world.py, tests/fl40_mutation_check.py, tests/fl40_corpus.json). targeted hardening. For each unexplained survivor of the exhaustive mutation check, look for a scenario that tells the mutant from the original bytes by
building it around the mutated instruction (fl43_directed.py picks cells and values at random; this one starts from the instruction).

For a survivor at instruction I (the address in the comment of the mutated line) and a corpus seed whose run reaches I:
  1. the ORIGINAL is run with a probe at I: the effective address and value of every memory operand and the value of every register operand, as they are just before I;
  2. the input cells of the run (memory the run reads before it writes it, outside the code) are the cells that matter: the cells I reads itself, and every other input cell
     that holds one of the operand values (the value reached I through a copy chain: a load into a register, a store to a frame slot, a load back);
  3. each such cell is set, one at a time, to values chosen from the instruction: the immediates of I +-1, the other operands +-1 and their negation, the cell's value +-1,
     0, 1, -1, the value with a bit above its width set (so that a narrower read differs: `v | 0x100`, `v | 0x10000`, `v ^ 0x80000000`, ...);
  4. a scenario counts only if the ORIGINAL does not fault and the UNMUTATED translation agrees with it; it kills every alive mutant on which the translation of the mutant differs
     (or hangs or crashes).
The scenarios that kill are appended to the row's seeds in tests/fl41_corpus.json; the caller reruns the mutation check.

  fl49_targeted.py [--held tasks/fl40-held-rows.json] [--rows 0x4015fb,...] [--seeds 8] [--jobs 4] --out FILE [--apply]       (run from outputs/blackmoor-decomp)
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
import capstone
from capstone import x86_const as CX
from unicorn import x86_const as UX
import fl40_world as W
import fl40_mutation_check as M

SOURCE = PROJECT / 'src/original_methods_fl40.c'
CORPUS = PROJECT / 'tests/fl40_corpus.json'
FULL = {n: getattr(UX, 'UC_X86_REG_' + n.upper()) for n in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')}
SUB16 = {'ax': 'eax', 'cx': 'ecx', 'dx': 'edx', 'bx': 'ebx', 'sp': 'esp', 'bp': 'ebp', 'si': 'esi', 'di': 'edi'}
SUB8 = {'al': ('eax', 0), 'cl': ('ecx', 0), 'dl': ('edx', 0), 'bl': ('ebx', 0), 'ah': ('eax', 8), 'ch': ('ecx', 8), 'dh': ('edx', 8), 'bh': ('ebx', 8)}


def instruction_at(row, address):
    pe = W.od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = address - pe.image_base
    return md, next(md.disasm(pe.image[off:off + 16], address))


def make_probe(md, ins, store):
    """a callback for run_original: records (memory operand cells, operand values) of `ins` just before it runs"""
    def reg_value(uc, name):
        if name in FULL:
            return uc.reg_read(FULL[name])
        if name in SUB16:
            return uc.reg_read(FULL[SUB16[name]]) & 0xffff
        base, shift = SUB8[name]
        return (uc.reg_read(FULL[base]) >> shift) & 0xff

    def probe(uc, ensure, wc):
        cells, values = [], []
        for op in ins.operands:
            if op.type == CX.X86_OP_REG:
                try:
                    values.append(reg_value(uc, md.reg_name(op.reg)))
                except KeyError:
                    pass
            elif op.type == CX.X86_OP_IMM:
                values.append(op.imm & 0xffffffff)
            elif op.type == CX.X86_OP_MEM and ins.mnemonic != 'lea':
                m = op.mem
                try:
                    a = (m.disp + (uc.reg_read(FULL[md.reg_name(m.base)]) if m.base else 0) + (uc.reg_read(FULL[md.reg_name(m.index)]) * m.scale if m.index else 0)) & 0xffffffff
                except KeyError:
                    continue
                ensure(a)
                ensure(a + op.size - 1)
                v = int.from_bytes(bytes(uc.mem_read(a, op.size)), 'little')
                cells.append((a, op.size, v))
                values.append(v)
        store.append((cells, values, wc))
    return probe


def make_addr_probe(md, ins, store):
    """FL-47: a callback that records (effective address, size, [(register value, scale) of the base and the index]) of the memory operand of `ins` just before it runs"""
    def probe(uc, ensure, wc):
        for op in ins.operands:
            if op.type == CX.X86_OP_MEM and ins.mnemonic != 'lea':
                m = op.mem
                try:
                    parts = []
                    if m.base:
                        parts.append((uc.reg_read(FULL[md.reg_name(m.base)]), 1))
                    if m.index:
                        parts.append((uc.reg_read(FULL[md.reg_name(m.index)]), m.scale))
                    a = (m.disp + sum(v * s for v, s in parts)) & 0xffffffff
                except KeyError:
                    return
                store.append((a, op.size, parts, wc))
                return
    return probe


def store_instructions(row):
    """the instructions of the row that write memory through a register address"""
    pe = W.od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = row['va'] - pe.image_base
    out = []
    for ins in md.disasm(pe.image[off:off + row['body']], row['va']):
        for op in ins.operands:
            if op.type == CX.X86_OP_MEM and (op.access & 2) and ins.mnemonic != 'lea' and (op.mem.base or op.mem.index) and md.reg_name(op.mem.base or op.mem.index) not in ('ebp', 'esp'):
                out.append(ins)
                break
    return md, out


def variants(v, size, imms, others):
    bits = 8 * size
    mask = (1 << bits) - 1
    out = set()
    for c in imms:
        for d in (-1, 0, 1):
            out.add((c + d) & mask)
    for u in others:
        for x in (u, u + 1, u - 1, -u, -u + 1, -u - 1):
            out.add(x & mask)
    for c in list(imms) + list(others):                    # FL-47: an operand value with a bit above a narrower width set (what a narrowed read of the cell would not see)
        for x in (c | 0x100, c | 0x10000, c | 0x1000000, c ^ 0x80000000, c | 0x80000000):
            out.add(x & mask)
    for x in (v + 1, v - 1, 0, 1, -1, v ^ 1, v ^ 0x80, v | 0x80, v & 0xff, v & 0xffff):
        out.add(x & mask)
    if size >= 2:
        for x in (v | 0x100, v ^ 0x100, v | 0x8000, v ^ 0x8000, (v & ~0xff) | 0x100):
            out.add(x & mask)
    if size == 4:
        for x in (v | 0x10000, v ^ 0x10000, v ^ 0x80000000, v | 0x80000000, (v & 0xffff0000) | 0x10000, (v & 0xffff) | 0x10000, v << 8, v << 16):
            out.add(x & mask)
    out.discard(v)
    return sorted(out)


def alive_instructions(text_lines, wanted):
    out = {}
    for kind, n in wanted:
        addr = None
        m = re.search(r'/\* (0x[0-9a-f]+): ', text_lines[n])
        if m:
            addr = int(m.group(1), 16)
        else:                                                 # a statement over several lines has its address in a comment line of its own just before it
            for k in range(n - 1, max(n - 12, -1), -1):
                m = re.match(r'^\s*/\* (0x[0-9a-f]+): [^*]*\*/\s*$', text_lines[k])
                if m:
                    addr = int(m.group(1), 16)
                    break
                if re.search(r'/\* 0x[0-9a-f]+: ', text_lines[k]):
                    break
        if addr is not None:
            out.setdefault(addr, []).append((kind, n))
    return out


def work(args):
    key, entry, text, helper, wanted, seed_limit, corpus_path = args
    va = int(key, 16)
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    picked = M.mutants(text, va, random.Random(va), 100000, wanted)       # the same mutants, in the same order, as the exhaustive run (the `only` filter keeps the numbering)
    if not picked:
        return key, {'found': [], 'alive': 0, 'tried': 0}
    named = [(k, n, re.sub(r'm%x_mut\d+' % va, 'm%x_mut%d' % (va, i), t, count=1)) for i, (k, n, t) in enumerate(picked)]
    lines = text.split('\n')
    at = alive_instructions(lines, wanted)
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
        by_line = {}
        for i, (k, n, t) in enumerate(named):
            by_line.setdefault(n, set()).add(i)
        found, tried = [], 0
        base = [(sd, [tuple(o) for o in ov]) for sd, ov in entry['seeds']]
        for address, kinds in sorted(at.items()):
            lines_here = {n for _, n in kinds}
            targets = set().union(*(by_line.get(n, set()) for n in lines_here)) & alive
            if not targets:
                continue
            md, ins = instruction_at(row, address)
            s_md, stores = store_instructions(row)
            imms = [op.imm & 0xffffffff for op in ins.operands if op.type == CX.X86_OP_IMM]
            reaching = []
            for sd, ov in base:
                store = []
                o = W.run_original(row, sd, ov, observe=True, probes={address: make_probe(md, ins, store)})
                if o.fault or not store:
                    continue
                reaching.append((sd, ov, o, store[0], 0))
                if len(reaching) >= seed_limit:
                    break
            for sd, ov, o, (cells, values, wc), depth in reaching:
                if not (alive & targets):
                    break
                first_write = {}
                for k, (a, n, v) in enumerate(o.writes):
                    for b in range(a, a + n):
                        first_write.setdefault(b, k)
                inputs = {}
                for a, n, v, w in o.reads:
                    if 0x401000 <= a < W.DATA_START or any(first_write.get(b, 1 << 30) < w for b in range(a, a + n)):
                        continue
                    inputs.setdefault((a, n), v)
                if hasattr(W, 'STUB_OVR'):
                    for k_, call in enumerate(o.calls):                       # what a callee returned is an input too: the k-th stub's eax, ecx, edx
                        for r_, v_ in enumerate(call[4:7]):
                            inputs[(W.STUB_OVR + 16 * k_ + 4 * r_, 4)] = v_
                chosen = {}
                for (a, n, v) in cells:                                  # the cells the instruction reads itself, when they are input cells
                    if (a, n) in inputs:
                        chosen[(a, n)] = inputs[(a, n)]
                    else:
                        for (a2, n2), v2 in inputs.items():
                            if a2 <= a and a + n <= a2 + n2:
                                chosen[(a2, n2)] = v2
                for (a, n), v in inputs.items():                          # the cells whose value reached the instruction by a copy chain
                    if v in values and len(chosen) < 12:
                        chosen.setdefault((a, n), v)
                if ins.mnemonic.startswith('j') and not chosen:                  # FL-47: a conditional jump has no operand cells: any input cell may decide a later compare, try them one at a time
                    chosen = dict(list(inputs.items())[:48])
                extra = {}
                if cells:                                                 # FL-47 alias scenarios: make an earlier store through a register hit the cell this instruction reads
                    a_r = cells[0][0]
                    for s_ins in stores:
                        s_store = []
                        W.run_original(row, sd, ov, probes={s_ins.address: make_addr_probe(s_md, s_ins, s_store)})
                        for ea, size_s, parts, wc_s in s_store[:2]:
                            if wc_s >= wc:
                                continue
                            delta = (a_r - ea) & 0xffffffff
                            for (a, n), v in inputs.items():
                                if n != 4:
                                    continue
                                for pv, scale in parts:
                                    if v == pv and len(extra) < 40:
                                        if scale == 1 or delta % scale == 0:
                                            extra.setdefault((a, n), (v, set()))[1].add((v + delta // scale) & 0xffffffff)
                                        extra.setdefault((a, n), (v, set()))[1].add((v - ((-delta) & 0xffffffff) // scale) & 0xffffffff if scale == 1 else (v + delta // scale) & 0xffffffff)
                for (a, n), (v, news) in extra.items():
                    chosen.setdefault((a, n), v)
                for (a, n), v in sorted(chosen.items()):
                    for new in (list(variants(v, n, imms, [x for x in values if x != v])) if depth == 0 else []) + sorted(extra.get((a, n), (v, ()))[1]):
                        if not (alive & targets):
                            break
                        merged = {(x, y): z for x, y, z in ov}
                        merged[(a, n)] = new
                        scen = tuple(sorted((x, y, z) for (x, y), z in merged.items()))
                        tried += 1
                        o2 = W.run_original(row, sd, scen)
                        if o2.fault:
                            continue
                        t = W.run_native(lib, row, sd, scen)
                        if t.fault or t.digest() != o2.digest():
                            continue
                        ref = o2.digest()
                        killed = []
                        if depth == 0 and (a, n) in extra and new in extra[(a, n)][1] and len(reaching) < 40:      # an alias scenario that kills nothing yet is a base for a second alias cell
                            store2 = []
                            o3 = W.run_original(row, sd, scen, observe=True, probes={address: make_probe(md, ins, store2)})
                            if not o3.fault and store2:
                                reaching.append((sd, list(scen), o3, store2[0], 1))
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
    ap.add_argument('--held', default=str(PROJECT / 'tasks/fl40-held-rows.json'))
    ap.add_argument('--rows')
    ap.add_argument('--only', help='a JSON file {row: [[kind, line], ...]} that restricts the survivors asked for')
    ap.add_argument('--seeds', type=int, default=8)
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--out', required=True, help='JSON with the scenarios found (the corpus is only touched with --apply: do not run it while a mutation check writes the corpus)')
    ap.add_argument('--apply', action='store_true')
    ap.add_argument('--resume', action='store_true', help='keep the rows already in --out and skip them (the container may be reset in a long run)')
    a = ap.parse_args()
    held = json.loads(Path(a.held).read_text())['rows']
    only = json.loads(Path(a.only).read_text()) if a.only else None
    corpus = json.loads(CORPUS.read_text())
    funcs = M.split_functions(SOURCE.read_text())
    helper = funcs.get('0x50c920', '')
    jobs = []
    for key, items in held.items():
        if a.rows and key not in a.rows.split(','):
            continue
        wanted = {(i['kind'], i['line']) for i in items if i['kind'] != 'unchecked' and (only is None or [i['kind'], i['line']] in only.get(key, []))}
        if wanted:
            jobs.append((key, corpus[key], funcs[key], helper if 'FL40_CALL_LIFTED' in funcs[key] else '', wanted, a.seeds, None))
    result = json.loads(Path(a.out).read_text()) if a.resume and Path(a.out).is_file() else {}
    jobs = [j for j in jobs if j[0] not in result]
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
