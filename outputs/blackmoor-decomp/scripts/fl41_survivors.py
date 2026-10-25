#!/usr/bin/env python3
"""FL-40: sort the survivors of tests/fl41_mutation_check.py (its log as the argument) into those that are provably equivalent mutants and the rows that stay out.

A survivor is explained only when one of these holds for the mutated statement; everything else leaves its row pending:
  identical code   `cc -O2 -S` of the mutant and of the translation give the same assembly (scripts/fl41_o2_classify.py): a flag nothing reads, a dead store
  same value       a register reload `reg = RD(ebp +- k)` right after the store `WR(ebp +- k, reg)` or the load `reg = RD(ebp +- k)` of the same register, on straight-line code with no call, label, jump or
                   store that could hit the slot in between (a store through another register is assumed not to point into the function's own frame): the register already holds the value, so dropping the reload changes nothing
  cleanup          the bytes a played callee pops after a call (`esp += n`) when the next statement that touches esp is `esp = ebp` on straight-line code
  repeat, dead     (FL-43, scripts/fl43_equiv.py) a dropped instruction that data flow over the original instructions shows to be a no-op: the register already holds the value on every path
                   to it, or every register and flag it writes is overwritten before it is read
  range            (FL-45, scripts/fl45_ranges.py) a `width` mutant that narrows the read of a frame slot [ebp + k] (32 -> 16 or 8 bits, 16 -> 8) where interval analysis of the ORIGINAL
                   instructions shows that the bytes left out are zero at that instruction (32-bit value in [0, 65535] or [0, 255]; low half in [0, 255])
  masked read      (FL-45) a `width` mutant that widens a read (8 -> 16 or 32, 16 -> 32) whose value the statement masks or sign-casts back to the original width: same value; the wider read
                   could differ only by faulting on bytes past the end of mapped memory
  flags            (FL-45) a mutant of a `cmp` whose only effect is on flags that the next jump does not read and nothing reads afterwards: a widened byte/word read (the low bits of the
                   result, hence ZF/SF/PF, are the same; only CF differs) before a `je/jne/js/jns`; the swapped operands of a `cmp` before `je/jne` (equality is symmetric)
  relation         (FL-45) a conditional jump replaced by another one that takes the same decision for every value pair the interval analysis allows at the compare (both operands
                   non-negative: the signed and unsigned orders agree, and the possible relations of the two values (<, =, >) are read off the intervals); or an unsigned condition
                   against the constant 0 (nothing is below 0). Subsumes the earlier signed <-> unsigned counterpart rule
  frame            `ebp = esp` / `esp = ebp` where nothing reads ebp between that statement and the next `esp = ebp`, or a `sub esp, N` whose next esp-touching statement is `esp = ebp`
The earlier "local width" class (a narrower read of a frame local that the corpus never shows) is NOT an equivalence and is gone: those rows stay pending.

  fl41_survivors.py <mutation log> [--equiv tasks/fl41-o2-identical.json] [--out tasks/fl41-survivors.json]
"""
import json
from pathlib import Path
import random
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl41_mutation_check as M
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl43_equiv as E
import fl45_ranges as RG

BARRIER = re.compile(r'FL41_CALL|goto|^L_|^done:|while|switch|case |FL41_EPILOGUE')


def stmt(line):
    return re.sub(r'\s*/\*.*', '', line).strip()


def aliasing_write(t, k):
    """a store in statement `t` that could overwrite the frame slot [ebp + k]: through ebp/esp with an overlapping slot, or with an address that is not register + offset of another register"""
    if not re.search(r'\bWR\d+\(', t):
        return False
    m = re.search(r'\bWR(\d+)\(\(uint32_t\)\((\w+)(?: \+ (0x[0-9a-f]+)u)?\)', t)
    if not m:
        m2 = re.search(r'\bWR(\d+)\((\w+),', t)
        return not (m2 and m2.group(2) == 'esp')            # a push: below the locals
    width, base, off = m.group(1), m.group(2), m.group(3)
    if base == 'ebp':
        a = int(off, 16) if off else 0
        b = int(k, 16)
        sa = a - (1 << 32) if a >= 1 << 31 else a
        sb = b - (1 << 32) if b >= 1 << 31 else b
        return abs(sa - sb) < 4 or abs(sa - sb) < int(width) // 8
    if re.match(r'^0x[0-9a-f]+u$', base):
        return False                                                  # an absolute address of the image: not the stack
    return base not in ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi')      # another register + offset: assumed not to point into this function's own frame


def same_value(lines, n):
    """lines[n] is `reg = RD32((uint32_t)(ebp + K));`: the nearest earlier statement that matters is `WR32((uint32_t)(ebp + K), reg);`, with no call, label, jump,
    write to reg or store that could overwrite the slot in between (a store through another register is assumed not to point into the function's own frame)"""
    m = re.match(r'^(e[a-z]{2}) = RD32\(\(uint32_t\)\(ebp \+ (0x[0-9a-f]+)u\)\);$', stmt(lines[n]))
    if not m:
        return False
    reg, k = m.groups()
    want = 'WR32((uint32_t)(ebp + %su), %s);' % (k, reg)
    for j in range(n - 1, -1, -1):
        t = stmt(lines[j])
        if not t:
            continue
        if t.startswith(want) or t.startswith('%s = RD32((uint32_t)(ebp + %su));' % (reg, k)):
            return True
        if BARRIER.search(t) or t.startswith('{') or re.match(r'^%s\b' % reg, t) or re.search(r'\b%s = ' % reg, t) or aliasing_write(t, k):
            return False
    return False


def forward(lines, n, ok, stop):
    for j in range(n + 1, len(lines)):
        t = stmt(lines[j])
        if not t:
            continue
        if ok(t):
            return True
        if stop(t):
            return False
    return False


def cleanup_ok(lines, n):
    return 'FL41_CALL' in lines[n] and forward(lines, n, lambda t: t.startswith('esp = ebp;'),
                                               lambda t: 'esp' in t or BARRIER.search(t) or re.search(r'\bR?D\d+|\bWR\d+', t) and 'esp' in t)


def frame_ok(lines, n):
    t = stmt(lines[n])
    if not (t.startswith('ebp = esp;') or t.startswith('esp = ebp;')):
        return False
    return forward(lines, n, lambda x: x.startswith('esp = ebp;'), lambda x: 'ebp' in x or BARRIER.search(x))


def esp_adjust_ok(lines, n):
    """`sub esp, N` of a frame allocation in a function whose only other uses of esp are the prologue push, the epilogue (`esp = ebp`, the pop of ebp, the ret
    adjustment) and the pushes/calls of no statement: every return path restores esp from ebp, so the allocated size never shows"""
    if not re.search(r'\besp = r_;', stmt(lines[n])):
        return False
    body = [stmt(l) for l in lines]
    uses = [t for i, t in enumerate(body) if i != n and re.search(r'\besp\b', t) and not (i < n and t.startswith('ebp = esp;'))]
    plain = ('esp -= 4u; WR32(esp, ebp);', 'esp = ebp;', 'ebp = RD32(esp); esp += 4u;')
    for t in uses:
        if t.startswith(plain) or re.match(r'^esp \+= \d+u; goto done;', t):
            continue
        return False
    rets = sum(1 for t in body if 'goto done;' in t)
    return rets > 0 and sum(1 for t in body if t.startswith('esp = ebp;')) >= rets


def stmt_full(line):
    return re.sub(r'\s*/\*.*', '', line).strip()


def instruction_address(lines, n):
    """the address in the comment of line n; a statement that spans several lines (division, string instruction) has the address in a comment line of its own just before it"""
    m = re.search(r'/\* (0x[0-9a-f]+): ', lines[n])
    if m:
        return int(m.group(1), 16)
    for k in range(n - 1, max(n - 12, -1), -1):
        m = re.match(r'^\s*/\* (0x[0-9a-f]+): [^*]*\*/\s*$', lines[k])
        if m:
            return int(m.group(1), 16)
        if re.search(r'/\* 0x[0-9a-f]+: ', lines[k]):
            return None                                   # the statement before this one is a complete instruction: this line belongs to no comment
    return None


RD = re.compile(r'RD(8|16|32)\(')


def read_change(orig, mut):
    """(original width, mutant width, text of the original read's argument, text after the read) when the two lines differ in exactly the width of one RD call, else None"""
    a = [(m.start(), m.group(1)) for m in RD.finditer(orig)]
    b = [(m.start(), m.group(1)) for m in RD.finditer(mut)]
    if len(a) != len(b) or [x[0] for x in a] != [x[0] for x in b]:
        return None
    diff = [i for i in range(len(a)) if a[i][1] != b[i][1]]
    if len(diff) != 1:
        return None
    i = diff[0]
    start = a[i][0]
    # the line with the width replaced must be the mutant, nothing else changed
    if orig[:start] + 'RD%s(' % b[i][1] + orig[start + len('RD%s(' % a[i][1]):] != mut:
        return None
    pos = start + len('RD%s(' % a[i][1])
    depth, j = 1, pos
    while j < len(orig) and depth:
        depth += {'(': 1, ')': -1}.get(orig[j], 0)
        j += 1
    return int(a[i][1]), int(b[i][1]), orig[pos:j - 1], orig[start:j], orig[:start], orig[j:]


def plain_store_operand(before):
    """`before` ends with `WRn(<address>, ` where the stored value starts right there (nothing but the address precedes the comma at depth 0)"""
    i = max((m.start() for m in re.finditer(r'WR\d+\(', before)), default=-1)
    if i < 0:
        return None
    rest = before[before.index('(', i) + 1:]
    depth = 0
    for j, ch in enumerate(rest):
        depth += {'(': 1, ')': -1}.get(ch, 0)
        if depth < 0:
            return None
        if ch == ',' and depth == 0:
            return int(re.match(r'WR(\d+)', before[i:]).group(1)) if rest[j:] == ', ' else None
    return None


def masked_ok(change):
    wa, wb, arg, call, before, after = change
    if wb <= wa:
        return False
    mask = (1 << wa) - 1
    if re.search(r'\| \(+$', before) and re.match(r'^\)\)? & 0x%xu\b' % mask, after):
        return True                                     # `(RDn(x)) & mask` or `((RDn(x))) & mask`
    if plain_store_operand(before) == wa and re.match(r'^\)\)?;', after):
        return True                                     # `WRn(addr, RDn(x))`: the store keeps the low n bits
    cast = {8: 'int8_t', 16: 'int16_t'}.get(wa)
    return bool(cast and before.endswith('(%s)(' % cast) and re.match(r'^\)\s*[\);,]', after))


def width_range_ok(change, ranges, addr):
    """the narrowed read of a frame slot returns the same value: its omitted bytes are zero by the interval analysis"""
    wa, wb, arg, call, before, after = change
    m = re.match(r'^\(uint32_t\)\(ebp \+ (0x[0-9a-f]+)u\)$', arg.strip())
    if ranges is None or not m or wb >= wa:
        return False
    k = int(m.group(1), 16)
    k = k - (1 << 32) if k >= 1 << 31 else k
    if addr is None or addr not in ranges.at:
        return False
    st = ranges.IN.get(addr)
    if st is None:
        return True                                    # never reached: the analysis finds no path to the instruction
    v = st.slots.get(k, RG.TOP)
    if wa == 32:
        return v[0] >= 0 and v[1] <= (1 << wb) - 1
    if wa == 16 and wb == 8:
        return v[2] >= 0 and v[3] <= 255
    return False


SIGNED_UNSIGNED = {'(sf != of)': '(cf)', '(sf == of)': '(!cf)', '(zf || sf != of)': '(cf || zf)', '(!zf && sf == of)': '(!cf && !zf)'}
SIGNED_UNSIGNED = {k: v.replace('(cf)', 'cf').replace('(!cf)', '!cf') for k, v in SIGNED_UNSIGNED.items()}
SIGNED_UNSIGNED.update({v: k for k, v in list(SIGNED_UNSIGNED.items())})


def jump_range_ok(orig, mut, ranges, addr):
    """a conditional jump replaced by its signed <-> unsigned counterpart (jge <-> jae, jg <-> ja, ...) agrees when both compared values lie in [0, 2^31) at the compare"""
    a = re.match(r'^if \((.*)\) goto (L_[0-9a-f]+);$', orig)
    b = re.match(r'^if \((.*)\) goto (L_[0-9a-f]+);$', mut)
    if not a or not b or a.group(2) != b.group(2) or SIGNED_UNSIGNED.get(a.group(1)) != b.group(1) or ranges is None:
        return False
    if addr is None or addr not in ranges.at:
        return False
    st = ranges.IN.get(addr)
    if st is None:
        return True
    if st.cmp is None or st.cmp[2] not in (2, 4):
        return False
    lhs, rhs, size = st.cmp
    if lhs is None or rhs is None:
        return False
    lv, rv = ranges.loc_value(st, lhs, size), ranges.rhs_value(st, rhs, size)
    return bool(lv and rv and lv[0] >= 0 and rv[0] >= 0)


def shift_copy_count_ok(orig, mut, ranges, addr):
    """`shr ecx, N` -> `sar ecx, N` directly before `rep movs`/`rep stos` of units of at least 2^N bytes (the string-copy idiom `shr ecx, 2; rep movsd`): the two shifts differ only when ecx
    has its top bit set, and then the original copies at least 2^(31-N) units, which is 2 GiB or more: the copy cannot finish inside the 2 GiB user address space of the 32-bit image
    (it faults), and a run that faults is not a run the check compares. Below 2^31 both shifts give the same count."""
    if ranges is None or addr is None or addr not in ranges.at or 'FL41_SHR(' not in orig or orig.replace('FL41_SHR(', 'FL41_SAR(', 1) != mut:
        return False
    ins = ranges.at[addr]
    if ins.mnemonic != 'shr' or len(ins.operands) != 2 or ins.operands[0].type != RG.REG_OP or ins.reg_name(ins.operands[0].reg) != 'ecx' or ins.operands[1].type != RG.IMM_OP:
        return False
    n = ins.operands[1].imm
    order = ranges.f.order
    k = order.index(addr)
    if k + 1 >= len(order):
        return False
    nxt = ranges.at[order[k + 1]]
    unit = {'movsd': 4, 'stosd': 4, 'movsw': 2, 'stosw': 2, 'movsb': 1, 'stosb': 1}.get(nxt.mnemonic.replace('rep ', '').strip())
    return bool(nxt.mnemonic.startswith('rep ') and unit and unit >= (1 << n) and 0 < n < 32)


COND_REL = {'zf': {'eq'}, '!zf': {'lt', 'gt'},
            '(sf != of)': {'lt'}, '(sf == of)': {'gt', 'eq'}, '(zf || sf != of)': {'lt', 'eq'}, '(!zf && sf == of)': {'gt'},
            'cf': {'lt'}, '!cf': {'gt', 'eq'}, '(cf || zf)': {'lt', 'eq'}, '(!cf && !zf)': {'gt'}}
UNSIGNED_CONDS = {'cf', '!cf', '(cf || zf)', '(!cf && !zf)', 'zf', '!zf'}


def relation_ok(orig, mut, ranges, addr):
    """a conditional jump replaced by another that decides the same way on every pair of values the compare can see (see the `relation` class)"""
    a = re.match(r'^if \((.*)\) goto (L_[0-9a-f]+);$', orig)
    b = re.match(r'^if \((.*)\) goto (L_[0-9a-f]+);$', mut)
    if not a or not b or a.group(2) != b.group(2) or a.group(1) not in COND_REL or b.group(1) not in COND_REL or ranges is None:
        return False
    if addr is None or addr not in ranges.at:
        return False
    st = ranges.IN.get(addr)
    if st is None:
        return True
    if st.cmp is None or st.cmp[2] not in (2, 4) or st.cmp[0] is None or st.cmp[1] is None:
        return False
    lhs, rhs, size = st.cmp
    lv, rv = ranges.loc_value(st, lhs, size), ranges.rhs_value(st, rhs, size)
    possible = None
    if lv and rv and lv[0] >= 0 and rv[0] >= 0:
        possible = {r for r, ok in (('lt', lv[0] < rv[1]), ('eq', lv[0] <= rv[1] and rv[0] <= lv[1]), ('gt', lv[1] > rv[0])) if ok}
    elif rv and rv == (0, 0) and a.group(1) in UNSIGNED_CONDS and b.group(1) in UNSIGNED_CONDS:
        possible = {'eq', 'gt'}                          # unsigned: nothing is below 0
    if possible is None:
        return False
    return all((r in COND_REL[a.group(1)]) == (r in COND_REL[b.group(1)]) for r in possible)


def signed_narrow_ok(orig, change, ranges, addr):
    """(FL-47) `cmp dword [ebp + k], imm` whose slot holds a sign-extended n-bit value (32-bit interval within [-2^(n-1), 2^(n-1) - 1]) and 0 <= imm < 2^(n-1), read with only n bits,
    before an unsigned or equality jump that is the only reader of the flags: a value of 0 or more compares the same either way; a negative one is above every such imm unsigned (the
    32-bit value is huge, the zero-extended n-bit one is at least 2^(n-1))"""
    wa, wb, arg, call, before, after = change
    m = re.match(r'^\(uint32_t\)\(ebp \+ (0x[0-9a-f]+)u\)$', arg.strip())
    imm = re.match(r'^\{ uint32_t a_ = RD32\([^;]*\), b_ = (0x[0-9a-f]+)u, r_; FL41_SUB\(a_, b_, 0u, r_, 32\); \}$', orig)
    if ranges is None or not m or not imm or wb not in (8, 16) or addr is None or addr not in ranges.at:
        return False
    k = int(m.group(1), 16)
    k = k - (1 << 32) if k >= 1 << 31 else k
    c = int(imm.group(1), 16)
    st = ranges.IN.get(addr)
    if st is None:
        return True
    v = st.slots.get(k, RG.TOP)
    return v[0] >= -(1 << (wb - 1)) and v[1] <= (1 << (wb - 1)) - 1 and 0 <= c < (1 << (wb - 1))


def cond_eval(cond, **flags):
    expr = cond.replace('||', ' or ').replace('&&', ' and ')
    expr = re.sub(r'!(?!=)', ' not ', expr)
    return bool(eval(expr, {}, flags))


def logic_jump_ok(orig, mut, ranges, addr):
    """(FL-47) a conditional jump replaced by another one directly after a `test`/`and`/`or`/`xor` (which clear CF and OF), the jump reached only from that instruction: the two conditions
    agree for every value of ZF and SF once CF = OF = 0 (`jbe` and `je` after `test`, `jae` and always-true, ...)"""
    a = re.match(r'^if \((.*)\) goto (L_[0-9a-f]+);$', orig)
    b = re.match(r'^if \((.*)\) goto (L_[0-9a-f]+);$', mut)
    if not a or not b or a.group(2) != b.group(2) or ranges is None or addr is None or addr not in ranges.at:
        return False
    order = ranges.f.order
    k = order.index(addr)
    if k == 0 or not ranges.at[addr].mnemonic.startswith('j'):
        return False
    prev = ranges.at[order[k - 1]]
    if prev.mnemonic not in ('test', 'and', 'or', 'xor'):
        return False
    if any(addr in succ and src != prev.address for src, succ in ranges.f.succ.items()):
        return False                                       # reached from somewhere else: the flags come from another instruction
    sfs = (0,) if strlen_nonneg(ranges, k - 1) else (0, 1)
    for zf in (0, 1):
        for sf in sfs:
            fl = dict(cf=0, of=0, zf=zf, sf=sf)
            if cond_eval(a.group(1), **fl) != cond_eval(b.group(1), **fl):
                return False
    return True


def strlen_nonneg(ranges, t):
    """(FL-47) the instruction at order index t is `test ecx, ecx` of the string-length idiom `or ecx, -1 / xor eax, eax / repne scasb / not ecx / add ecx, -1` (or `dec ecx`) on straight-line code:
    the scan covers k >= 1 bytes, k <= 2^31 inside the 2 GiB user address space (a longer one faults, and a faulting run is not compared), ecx = k - 1 lies in [0, 2^31 - 1], so SF is 0"""
    order, at = ranges.f.order, ranges.at
    if t < 5 or at[order[t]].mnemonic != 'test' or at[order[t]].op_str != 'ecx, ecx':
        return False
    seq = [at[order[t - i]] for i in range(1, 5)]            # add/dec, not, repne scasb, then the instruction before it (xor eax,eax or the init of ecx)
    if not (seq[0].mnemonic == 'dec' and seq[0].op_str == 'ecx' or seq[0].mnemonic == 'add' and seq[0].op_str in ('ecx, -1', 'ecx, 0xffffffff')):
        return False
    if seq[1].mnemonic != 'not' or seq[1].op_str != 'ecx' or seq[2].mnemonic != 'repne scasb':
        return False
    found = None
    for i in range(4, 7):
        if t - i < 0:
            return False
        ins = at[order[t - i]]
        if ins.mnemonic == 'or' and ins.op_str in ('ecx, 0xffffffff', 'ecx, -1') or ins.mnemonic == 'mov' and ins.op_str in ('ecx, -1', 'ecx, 0xffffffff'):
            found = t - i
            break
        if ins.op_str.split(', ')[0] in ('ecx', 'cx', 'cl', 'ch') or ins.mnemonic in ('call', 'jmp') or ins.mnemonic.startswith('j') or ins.mnemonic.startswith(('rep', 'loop', 'pop', 'xchg')):
            return False
    if found is None:
        return False
    for k_ in range(found, t + 1):                           # every instruction from the initialisation to the test is reached only from the one before it
        a_ = order[k_]
        if any(a_ in s and src != order[k_ - 1] for src, s in ranges.f.succ.items() if k_ > found):
            return False
    return True


def next_jump(ranges, addr):
    """(condition suffix, address) of the conditional jump that directly follows the instruction at `addr`, with the flags dead after it; else None"""
    if ranges is None or addr is None or addr not in ranges.at:
        return None
    order = ranges.f.order
    k = order.index(addr)
    if k + 1 >= len(order):
        return None
    j = ranges.at[order[k + 1]]
    if not (j.mnemonic.startswith('j') and j.mnemonic != 'jmp'):
        return None
    if ranges.f.liveness()[j.address][1]:
        return None
    return j.mnemonic[1:], j.address


def flags_ok(kind, orig, mut, ranges, addr):
    """a mutant of a `cmp` that can change only flags the next jump does not read"""
    if ranges is None or addr is None or addr not in ranges.at:
        return False
    mn = ranges.at[addr].mnemonic
    if kind == 'width' and re.match(r'^rep(e|ne) (scas|cmps)[bwd]$', mn):
        # a repeated string compare reads ZF only (the repetition test); the widened read changes the low bits of nothing, only CF, and the flags are dead after the instruction
        change = read_change(orig, mut)
        unit = {'b': 8, 'w': 16, 'd': 32}[mn[-1]]
        return bool(change and change[1] > change[0] and change[0] == unit and not ranges.f.liveness()[addr][1])
    if mn != 'cmp':
        return False
    nj = next_jump(ranges, addr)
    if nj is None:
        return False
    cc = nj[0]
    if kind == 'register':
        swapped = re.sub(r'a_ = ([^,]+), b_ = ([^,;]+),', r'a_ = \2, b_ = \1,', orig, count=1)
        return swapped == mut and cc in ('e', 'z', 'ne', 'nz')
    if kind == 'width':
        change = read_change(orig, mut)
        if change and change[1] < change[0] == 32 and cc in ('a', 'ae', 'b', 'be', 'nbe', 'nb', 'nae', 'na', 'e', 'z', 'ne', 'nz'):
            return signed_narrow_ok(orig, change, ranges, addr)
        bits = re.search(r'FL41_(?:SUB|ADD)\(a_, b_, \d+u, r_, (\d+)\)', orig)
        return bool(change and bits and change[1] > change[0] and int(bits.group(1)) == change[0] and cc in ('e', 'z', 'ne', 'nz', 's', 'ns'))
    return False


def classify(kind, lines, n, equivalent, proofs=None, mutline=None, ranges=None, row=None):
    if equivalent:
        return 'identical code'
    if kind == 'width' and mutline is not None:
        change = read_change(stmt_full(lines[n]), stmt_full(mutline))
        if change and masked_ok(change):
            return 'masked read'
        if change and width_range_ok(change, ranges, instruction_address(lines, n)):
            return 'range'
    if kind == 'jump' and mutline is not None and logic_jump_ok(stmt_full(lines[n]), stmt_full(mutline), ranges, instruction_address(lines, n)):
        return 'range'
    if kind == 'jump' and mutline is not None and (jump_range_ok(stmt_full(lines[n]), stmt_full(mutline), ranges, instruction_address(lines, n))
                                                   or relation_ok(stmt_full(lines[n]), stmt_full(mutline), ranges, instruction_address(lines, n))):
        return 'range'
    if kind in ('register', 'width') and mutline is not None and flags_ok(kind, stmt_full(lines[n]), stmt_full(mutline), ranges, instruction_address(lines, n)):
        return 'flags'
    if kind == 'alu' and mutline is not None and shift_copy_count_ok(stmt_full(lines[n]), stmt_full(mutline), ranges, instruction_address(lines, n)):
        return 'copy count'
    if kind == 'drop' and proofs and proofs.get(instruction_address(lines, n)):
        return 'repeat' if proofs[instruction_address(lines, n)].startswith('repeat') else 'dead'
    if kind == 'drop' and same_value(lines, n):
        return 'same value'
    if kind == 'literal' and cleanup_ok(lines, n):
        return 'cleanup'
    if kind == 'register' and frame_ok(lines, n):
        return 'frame'
    if kind in ('alu', 'literal', 'register', 'drop') and esp_adjust_ok(lines, n):
        return 'frame'
    if row:
        import fl48_rules       # FL-48: FL-46's liveness rules (dead flags, dead register, equal push) on the statements
        return fl48_rules.explain(kind, lines, n, row)
    return None


WRITTEN_PATH = PROJECT / 'tasks/fl48-written-reasons.json'
WRITTEN = json.loads(WRITTEN_PATH.read_text())['rows'] if WRITTEN_PATH.exists() else {}      # FL-48: {row: [{kind, line, statement, reason, review}]}, read by one Sonnet reader and checked by a second
for _p in sorted((PROJECT / 'tasks').glob('fl5*-written-reasons.json')):          # FL-52: later rounds keep their reasons in tasks/fl5N-written-reasons.json
    for _row, _items in json.loads(_p.read_text())['rows'].items():
        WRITTEN.setdefault(_row, []).extend(_items)


def main():
    log = sys.argv[1]
    equiv = {}
    if '--equiv' in sys.argv:        # scripts/fl41_o2_classify.py: {row: [[kind, line], ...]} for the survivors whose -O2 assembly equals the translation's
        for row, items in json.loads(Path(sys.argv[sys.argv.index('--equiv') + 1]).read_text()).items():
            equiv[row] = {(kind, n, ident): True for kind, n, ident in items}
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())
    corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
    out = {'rows_with_survivors': {}, 'unexplained_rows': [], 'mutants': {}}
    for line in open(log):
        m = re.match(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)', line)
        if not m:
            continue
        if m.group(1) not in funcs:            # a row already taken out of the translated set (pruned earlier)
            continue
        text = funcs[m.group(1)].split('\n')
        idents = {}
        for mk, mn, mt in M.mutants(funcs[m.group(1)], int(m.group(1), 16), random.Random(int(m.group(1), 16)), 100000, True):
            idents[(mk, mn, M.line_hash(mt, mn))] = mt.split('\n')[mn]
        try:
            ranges = RG.Ranges(int(m.group(1), 16), corpus[m.group(1)]['body'])
        except E.NoProof:
            ranges = None
        proofs = {}
        try:
            wanted = [a for a in (instruction_address(text, n) for _, n, *_ in eval(m.group(2)[:m.group(2).rindex(']') + 1])) if a]
            proofs = E.prove(int(m.group(1), 16), corpus[m.group(1)]['body'], wanted, ranges.feasible if ranges else None, RG.TableFunction if ranges else None, exposed_ok=True)
        except E.NoProof:
            pass
        items = []
        written = {(r_['kind'], r_['line'], r_.get('ident')) for r_ in WRITTEN.get(m.group(1), []) if text[r_['line']] == r_['statement']}      # FL-48: a written reason for exactly this statement (and mutant, when it names one)
        for kind, n, why, *rest in eval(m.group(2)[:m.group(2).rindex(']') + 1]):
            if why == 'survives':
                ident = rest[0] if rest else None
                same = equiv.get(m.group(1), {}).get((kind, n, ident), False) or (ident is None and equiv.get(m.group(1), {}).get((kind, n, None), False))
                cls = classify(kind, text, n, same, proofs, idents.get((kind, n, ident)), ranges, m.group(1)) or ('written reason' if ((kind, n, ident) in written or (kind, n, None) in written) else None)
                items.append((kind, cls, text[n].strip()[:160], n))
                out['mutants'].setdefault(m.group(1), []).append([kind, n, ident, cls])         # FL-48: the mutant by its hash (the writers of the reasons name mutants)
        if items:
            out['rows_with_survivors'][m.group(1)] = items
            if any(c is None for _, c, _, _ in items):
                out['unexplained_rows'].append(m.group(1))
    out['unexplained_rows'].sort(key=lambda k: int(k, 16))
    if '--out' in sys.argv:
        Path(sys.argv[sys.argv.index('--out') + 1]).write_text(json.dumps(out, indent=1) + '\n')
    print('rows with a survivor %d, unexplained %d' % (len(out['rows_with_survivors']), len(out['unexplained_rows'])))


if __name__ == '__main__':
    main()
