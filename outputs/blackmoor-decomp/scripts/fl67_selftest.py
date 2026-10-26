#!/usr/bin/env python3
"""FL-67: differential fuzz of the instruction semantics of scripts/fl67_infeasible.py against Unicorn.

Every distinct (mnemonic, operand shape) of the straight-line instructions that the pending game functions use is taken from the real bytes of GAME.EXE
and run from random registers, flags and memory in Unicorn; the symbolic model, evaluated on the same start state, must give the same registers, the same
defined flags and the same bytes of memory. Flags the model leaves unconstrained (undefined by the architecture) are not compared.

  fl67_selftest.py [--per-shape N] [--seed S] [--rows ROW ...]       (run from outputs/blackmoor-decomp; needs the private work/original/GAME.EXE)
"""
import argparse
import collections
import json
from pathlib import Path
import random
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))

import z3
import capstone
from capstone import x86_const as X
import unicorn
from unicorn import x86_const as UX
import fl67_infeasible as P
import original_differential as od

DATA = 0x20000000          # the data window of the fuzz: a page of random bytes
STACK = 0x30000000
CODE = 0x401000
FLAG_BITS = {'cf': 0, 'pf': 2, 'af': 4, 'zf': 6, 'sf': 7, 'of': 11}
UCREG = {r: getattr(UX, 'UC_X86_REG_' + r.upper()) for r in P.FULL}
SKIP = {'call', 'ret', 'jmp', 'leave', 'int3', 'nop'}


def shape(ins):
    return (ins.mnemonic, tuple((o.type, o.size, (o.mem.base != 0, o.mem.index != 0, o.mem.scale) if o.type == X.X86_OP_MEM else (o.imm == 0 if o.type == X.X86_OP_IMM else ins.reg_name(o.reg) if o.size != 4 else 0))
                                for o in ins.operands))


def instruction_pool(rows):
    img = od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    led = {e['va']: e for e in json.loads((PROJECT / 'function-ledger.json').read_text())['entries']}
    pool = collections.defaultdict(list)
    for key in rows or sorted(led):
        e = led[key]
        if e['region'] != 'game':
            continue
        off = int(key, 16) - img.image_base
        for i in md.disasm(img.image[off:off + e['span']], int(key, 16)):
            m = i.mnemonic
            if m in SKIP or m.startswith(('j', 'loop', 'f')) or m == 'wait':
                continue
            pool[shape(i)].append(bytes(i.bytes))
    return pool


def run_unicorn(code, regs, flags, window):
    uc = unicorn.Uc(unicorn.UC_ARCH_X86, unicorn.UC_MODE_32)
    uc.mem_map(CODE & ~0xfff, 0x1000)
    uc.mem_map(DATA, 0x2000)
    uc.mem_map(STACK, 0x2000)
    uc.mem_write(CODE, code + b'\x90' * 4)
    uc.mem_write(DATA, window)
    uc.mem_write(STACK, window)
    for r, v in regs.items():
        uc.reg_write(UCREG[r], v)
    ef = 0x202
    for f, b in flags.items():
        ef |= int(b) << FLAG_BITS[f]
    uc.reg_write(UX.UC_X86_REG_EFLAGS, ef)
    uc.emu_start(CODE, CODE + len(code))
    out = {r: uc.reg_read(UCREG[r]) for r in P.FULL}
    e = uc.reg_read(UX.UC_X86_REG_EFLAGS)
    fl = {f: bool((e >> b) & 1) for f, b in FLAG_BITS.items()}
    return out, fl, bytes(uc.mem_read(DATA, 0x2000)), bytes(uc.mem_read(STACK, 0x2000))


def free_consts(e):
    out, seen, todo = [], set(), [e]
    while todo:
        x = todo.pop()
        if x.get_id() in seen:
            continue
        seen.add(x.get_id())
        if z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED:
            out.append(x)
        todo.extend(x.children())
    return out


def one(code, rng, md):
    ins = next(md.disasm(code, CODE))
    window = bytes(rng.randrange(256) if rng.random() < .7 else rng.choice((0, 0xff, 0x80, 0x7f)) for _ in range(0x2000))
    regs = {r: rng.choice((rng.getrandbits(32), rng.randrange(0, 8), 0xffffffff, 0x80000000, 0x7fffffff, rng.randrange(0, 0x10000))) for r in P.FULL}
    regs['esp'] = STACK + 0x1000 + 4 * rng.randrange(-100, 100)
    flags = {f: bool(rng.getrandbits(1)) for f in P.FLAGS}
    touch = [STACK + 0x1000 - 0x200 + 0x180 - 0x180]
    touch = [regs['esp']]
    # a memory operand: put its address inside the data window
    for op in ins.operands:
        if op.type == X.X86_OP_MEM:
            if op.mem.segment != 0:
                return None
            names = [ins.reg_name(r) for r in (op.mem.base, op.mem.index) if r]
            if len(set(names)) != len(names) or any(P.REGS[n][1] != 4 for n in names):
                return None
            target = DATA + 0x800 + 4 * rng.randrange(0, 200) + rng.randrange(0, 4) * rng.choice((0, 1))
            touch.append(target)
            if op.mem.index:
                if ins.reg_name(op.mem.index) == 'esp':
                    return None
                idx = rng.randrange(0, 16)
                regs[ins.reg_name(op.mem.index)] = idx
            else:
                idx = 0
            if op.mem.base:
                regs[ins.reg_name(op.mem.base)] = (target - idx * op.mem.scale - op.mem.disp) & 0xffffffff
            else:
                if op.mem.disp & 0xffffffff not in range(DATA, DATA + 0x1000):
                    return None
    if any(op.type == X.X86_OP_MEM and not op.mem.base and not op.mem.index for op in ins.operands):
        return None
    # the cl-count shifts and string moves use registers; keep esi/edi inside the window for the string instructions
    if ins.mnemonic in ('movsb', 'movsw', 'movsd', 'stosb', 'stosw', 'stosd'):
        regs['esi'] = DATA + 0x800 + 4 * rng.randrange(0, 100)
        regs['edi'] = DATA + 0xc00 + 4 * rng.randrange(0, 100)
        touch += [regs['esi'], regs['edi']]
    try:
        u_regs, u_flags, u_data, u_stack = run_unicorn(code, regs, flags, window)
    except unicorn.UcError:
        return None                       # the original faults here (division by zero, overflow): the model assumes these away
    M = P.Machine({'callees': {}, 'imports': {}, 'sites': {}}, bytes(0x300000))
    st = P.State.start()
    M.ins = ins
    try:
        M.step(st, ins)
    except P.Unsupported:
        return 'unsupported'
    s = z3.Solver()
    for r in P.FULL:
        s.add(z3.BitVec('s_' + r, 32) == regs[r])
    for f in P.FLAGS:
        s.add(z3.Bool('s_' + f) == flags[f])
    mem0 = z3.Array('s_mem', z3.BitVecSort(32), z3.BitVecSort(8))
    cells = sorted({a + d for a in touch for d in range(-12, 24)})
    for a in cells:
        base = DATA if a < STACK else STACK
        s.add(z3.Select(mem0, z3.BitVecVal(a, 32)) == window[a - base])
    s.add(st.pc)                              # the access conditions of the model hold on this start state
    if s.check() != z3.sat:
        return 'pc-unsat'
    m = s.model()
    for r in P.FULL:
        v = m.eval(st.R[r], model_completion=True).as_long()
        if v != u_regs[r]:
            return 'reg %s: model %#x unicorn %#x' % (r, v, u_regs[r])
    for f in P.FLAGS:
        if f in ('pf', 'af'):
            continue
        e = z3.simplify(st.F[f])
        if any(str(x).startswith('fb') for x in free_consts(e)):
            continue                              # depends on an unconstrained flag: undefined by the architecture
        v = z3.is_true(m.eval(st.F[f], model_completion=True))
        if v != u_flags[f]:
            return 'flag %s: model %s unicorn %s' % (f, v, u_flags[f])
    for a in cells:
        base = DATA if a < STACK else STACK
        data = u_data if base == DATA else u_stack
        v = m.eval(z3.Select(st.mem, z3.BitVecVal(a, 32)), model_completion=True).as_long()
        if v != data[a - base]:
            return 'mem %#x: model %#x unicorn %#x' % (a, v, data[a - base])
    return 'ok'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--per-shape', type=int, default=6)
    ap.add_argument('--seed', type=int, default=1)
    ap.add_argument('--rows', nargs='*')
    a = ap.parse_args()
    rng = random.Random(a.seed)
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    pool = instruction_pool(a.rows)
    checked = bad = unsupported = skipped = 0
    seen_unsupported = collections.Counter()
    for sh, variants in sorted(pool.items(), key=str):
        for _ in range(a.per_shape):
            code = rng.choice(variants)
            res = None
            for _try in range(6):
                res = one(code, rng, md)
                if res is not None:
                    break
            if res is None:
                skipped += 1
            elif res == 'unsupported':
                unsupported += 1
                seen_unsupported[sh[0]] += 1
            else:
                checked += 1
                if res != 'ok':
                    bad += 1
                    print('MISMATCH', code.hex(), next(md.disasm(code, CODE)).mnemonic, next(md.disasm(code, CODE)).op_str, res)
    print('shapes %d, instruction runs checked %d, mismatches %d, skipped %d, unsupported %d %s' % (len(pool), checked, bad, skipped, unsupported, dict(seen_unsupported)))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
