#!/usr/bin/env python3
"""FL-56: mechanical proof that one direction of a conditional jump of an original GAME.EXE function can never be taken.

  fl56_untaken.py ROW JCC DIRECTION        prints the proof of `taken` or `fall-through` of the jcc at JCC being impossible, or says that none was found
  fl56_untaken.py --check                  proves every `untaken_ok` direction of tests/fl40_corpus.json (exit 1 if one has no proof)

The proof is deliberately narrow. Walking back from the jcc through straight-line code (no jump target inside the span, no call, no ret), the flags of the jcc come from the nearest `test r, r`,
`cmp r, imm` or `cmp r, r` whose operands have an abstract value that decides the condition for EVERY input:
  const k            after `mov r, imm`, `xor r, r`, or `and r, imm` of a const (the value is exact)
  range [0, 255]     after `xor r, r` (or any const-0 r) followed by `mov r8, <byte>` into the low byte of r (zero-extended byte)
With these a `test r, r` / `cmp r, imm` followed by je jne ja jae jb jbe jl jge jle jg js jns is decided by evaluating it on the const, or on both ends of the range. A direction is impossible when
the condition has the same outcome for all values. Anything else (memory slots, loops, values from callees) is not covered: the row then needs a killing scenario instead.
"""
import json
from pathlib import Path
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import capstone
from capstone import x86_const as X
import original_differential as od

MASK = 0xffffffff
REG32 = {X.X86_REG_EAX: 'eax', X.X86_REG_ECX: 'ecx', X.X86_REG_EDX: 'edx', X.X86_REG_EBX: 'ebx', X.X86_REG_ESI: 'esi', X.X86_REG_EDI: 'edi'}
LOW8 = {X.X86_REG_AL: 'eax', X.X86_REG_CL: 'ecx', X.X86_REG_DL: 'edx', X.X86_REG_BL: 'ebx'}


def signed(v):
    return v - (1 << 32) if v & 0x80000000 else v


def flags_of(kind, a, b):
    """cf zf sf of `cmp a, b` (kind 'cmp') or `test a, b` ('test') on 32-bit values"""
    if kind == 'test':
        r = a & b & MASK
        return dict(cf=0, zf=int(r == 0), sf=r >> 31, of=0)
    r = (a - b) & MASK
    return dict(cf=int(a < b), zf=int(r == 0), sf=r >> 31, of=int(((a ^ b) & (a ^ r)) >> 31))


def cond(name, f):
    return {'e': f['zf'], 'z': f['zf'], 'ne': 1 - f['zf'], 'nz': 1 - f['zf'], 'a': int(not f['cf'] and not f['zf']), 'ae': 1 - f['cf'], 'b': f['cf'], 'be': int(f['cf'] or f['zf']),
            'l': int(f['sf'] != f['of']), 'ge': int(f['sf'] == f['of']), 'le': int(f['zf'] or f['sf'] != f['of']), 'g': int(not f['zf'] and f['sf'] == f['of']),
            's': f['sf'], 'ns': 1 - f['sf']}.get(name)


def disasm(va, size):
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    pe = od.load_image()
    off = va - pe.image_base
    return list(md.disasm(bytes(pe.image[off:off + size]), va))


def jump_targets(ins):
    out = set()
    for i in ins:
        if i.group(X.X86_GRP_JUMP) or i.mnemonic.startswith('loop') or i.mnemonic == 'jecxz':
            if i.operands and i.operands[0].type == X.X86_OP_IMM:
                out.add(i.operands[0].imm)
            else:
                out.add(None)          # an indirect jump (a switch): any address may be a target
    return out


FAMILY = {'eax': {'eax', 'ax', 'al', 'ah'}, 'ecx': {'ecx', 'cx', 'cl', 'ch'}, 'edx': {'edx', 'dx', 'dl', 'dh'}, 'ebx': {'ebx', 'bx', 'bl', 'bh'},
          'esi': {'esi', 'si'}, 'edi': {'edi', 'di'}}


def value_of(ins, k, reg, targets, trace):
    """abstract value of 32-bit register `reg` just before ins[k]: ('const', v) or ('range', lo, hi); None when unknown. Walks back through straight-line code. Every instruction passed over must
    leave the register (and its 16/8-bit parts) alone according to capstone's register access list, which includes the implicit writes (cdq, mul, rdtsc, string instructions, ...)."""
    family = FAMILY[reg]
    for j in range(k - 1, -1, -1):
        i = ins[j]
        entry = i.address in targets              # something else jumps here: fine for a plain `mov r, imm` / `xor r, r` (it IS the writer), otherwise the walk back would skip a path
        ops = i.operands
        if i.mnemonic in ('call', 'ret', 'leave') or i.mnemonic.startswith(('rep', 'j', 'loop')):
            return None
        try:
            names = {i.reg_name(r) for r in i.regs_access()[1]} - {'eflags'}
        except Exception:
            return None
        if not names & family:
            if entry:
                return None
            continue
        dest = ops[0] if ops else None
        if dest is None or dest.type != X.X86_OP_REG:
            return None
        r = dest.reg
        if r in REG32 and REG32[r] == reg:
            if i.mnemonic == 'mov' and ops[1].type == X.X86_OP_IMM:
                trace.append('%x: mov %s, 0x%x' % (i.address, reg, ops[1].imm & MASK))
                return ('const', ops[1].imm & MASK)
            if i.mnemonic == 'xor' and ops[1].type == X.X86_OP_REG and ops[1].reg == r:
                trace.append('%x: xor %s, %s' % (i.address, reg, reg))
                return ('const', 0)
            if entry:
                return None
            if i.mnemonic == 'and' and ops[1].type == X.X86_OP_IMM and names == {reg}:
                inner = value_of(ins, j, reg, targets, trace)
                if inner and inner[0] == 'const':
                    trace.append('%x: and %s, 0x%x' % (i.address, reg, ops[1].imm & MASK))
                    return ('const', inner[1] & ops[1].imm & MASK)
            return None
        if entry:
            return None
        if r in LOW8 and LOW8[r] == reg and i.mnemonic == 'mov' and names == {i.reg_name(r)} and \
                (ops[1].type == X.X86_OP_MEM or (ops[1].type == X.X86_OP_REG and ops[1].reg in LOW8)):
            inner = value_of(ins, j, reg, targets, trace)
            if inner == ('const', 0):
                trace.append('%x: mov %s, <byte>' % (i.address, i.reg_name(r)))
                return ('range', 0, 255)
        return None
    return None


def outcomes(kind, left, right, cc):
    """set of outcomes of the condition over every value pair the abstract values allow ({0}: never taken, {1}: always taken); None when not decidable"""
    def points(v):
        return [v[1]] if v[0] == 'const' else [v[1], v[2]]
    if (left[0] == 'range' and right[0] == 'range') or (left[0] == 'range' and cc not in ('e', 'ne', 'z', 'nz')):
        return None
    if left[0] == 'range':               # a range [0,255] against a constant: only equality is decided (the constant lies outside the range)
        if right[0] != 'const' or right[1] <= 255 or kind != 'cmp':
            return None
        return {0} if cc in ('e', 'z') else {1}
    result = {cond(cc, flags_of(kind, a, b)) for a in points(left) for b in points(right)}
    return None if None in result else result            # a condition the evaluator does not know (jo, jno, jp, jnp, ...) decides nothing


def prove(row, jcc, direction):
    va = int(row, 16)
    size = next(x['body_size'] for x in json.loads((PROJECT / 'function-ledger.json').read_text())['entries'] if x['va'] == row)
    ins = disasm(va, size)
    targets = jump_targets(ins)
    if None in targets:
        return None
    k = next((n for n, i in enumerate(ins) if i.address == jcc), None)
    if k is None or not ins[k].mnemonic.startswith('j') or ins[k].mnemonic == 'jmp':
        return None
    cc = ins[k].mnemonic[1:]
    if jcc in targets:
        return None
    j = k - 1
    while j >= 0 and ins[j].mnemonic in ('mov', 'lea') and ins[j].address not in targets:      # mov and lea leave the flags alone
        j -= 1
    if j < 0 or ins[j].mnemonic not in ('test', 'cmp'):
        return None
    flag = ins[j]
    if any(ins[n].address in targets for n in range(j + 1, k + 1)):
        return None
    a, b = flag.operands
    if a.type != X.X86_OP_REG or a.reg not in REG32:
        return None
    trace = []
    left = value_of(ins, j, REG32[a.reg], targets, trace)
    if left is None:
        return None
    if b.type == X.X86_OP_IMM:
        right = ('const', b.imm & MASK)
    elif b.type == X.X86_OP_REG and b.reg == a.reg and flag.mnemonic == 'test':
        right = left
    else:
        return None
    first = min(int(t.split(':')[0], 16) for t in trace) if trace else flag.address
    if any(first < t <= jcc for t in targets):
        return None
    out = outcomes(flag.mnemonic, left, right, cc)
    if out is None or len(out) != 1:
        return None
    result = next(iter(out))
    impossible = 'taken' if result == 0 else 'fall-through'
    if impossible != direction:
        return None
    return '%s; %x: %s %s, %s; %x: j%s is %s for every input, so its %s direction never happens' % ('; '.join(trace), flag.address, flag.mnemonic, flag.op_str.split(',')[0], flag.op_str.split(',')[1].strip(), jcc, cc,
                                                                                                 'never taken' if result == 0 else 'always taken', direction)


def main():
    args = sys.argv[1:]
    if args == ['--check']:
        corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
        bad = 0
        for key, c in sorted(corpus.items()):
            for addr, direction in c.get('untaken_ok', []):
                p = prove(key, int(addr, 16), direction)
                print(key, addr, direction, p or 'NO PROOF')
                bad += p is None
        return 1 if bad else 0
    row, jcc, direction = args
    p = prove(row, int(jcc, 16), direction)
    print(p or 'no proof found')
    return 0 if p else 1


if __name__ == '__main__':
    sys.exit(main())
