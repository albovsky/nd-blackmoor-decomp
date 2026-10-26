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
import os
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
    """the statement of a line without its comments. FL-60: every `/* ... */` span goes, not everything from the first `/*` on: a call to an import carries `/* call [DLL!name] */` BEFORE
    its FL4x_CALL, and cutting at the first comment hid the call from the barrier test (rule `same value` then excused a mutant across a call)"""
    return re.sub(r'\s*/\*.*', '', re.sub(r'\s*/\*.*?\*/', '', line)).strip()


def aliasing_write(t, k):
    """a store in statement `t` that could overwrite the frame slot [ebp + k]: through ebp/esp with an overlapping slot, or with an address that is not register + offset of another register.
    FL-55: every store of the statement counts (an x87 qword store emits two, at addr and addr + 4)"""
    return any(_aliasing_one(t[m.start():], k) for m in re.finditer(r'\bWR\d+\(', t))


def _aliasing_one(t, k):
    m = re.match(r'WR(\d+)\(\(uint32_t\)\((\w+)(?: \+ (0x[0-9a-f]+)u)?\)', t)
    if not m:
        m2 = re.match(r'WR(\d+)\((\w+),', t)
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
        if BARRIER.search(t) or (t.startswith('{') and not fpu_block(t)) or re.match(r'^%s\b' % reg, t) or re.search(r'\b%s = ' % reg, t) or aliasing_write(t, k):
            return False
    return False


def fpu_block(t):
    """FL-55: a statement block of an x87 instruction (`{ long double v_ = ...; ... }`): it changes only the FPU state and, for a store, one memory cell (aliasing_write checks that cell);
    it never writes a general register or the flags"""
    return t.startswith('{ long double ') and not re.search(r'\b(e[a-d]x|e[sd]i|e[sb]p|esp|zf|sf|cf|of|pf)\b ?=[^=]', t)


def sext16_slot_ok(lines, n, mut):
    """FL-55: `fild dword ptr [ebp + K]` mutated to `fild word ptr [ebp + K]` (fl41_ld_i32 -> fl41_ld_i16, same address): the slot was stored from a register that a `movsx reg, word ptr [...]` defined
    just before on straight-line code (no call, label or jump, no later write to the register, no store that could overwrite the slot), so the dword is the sign extension of a 16-bit value and
    its low word, read as a signed 16-bit integer, is the same number"""
    t = stmt(lines[n])
    m = re.match(r'^fl41_fpush\(fp, fl41_ld_i32\(fp, RD32\(\(uint32_t\)\(ebp \+ (0x[0-9a-f]+)u\)\)\)\);$', t)
    if not m or stmt(mut) != t.replace('fl41_ld_i32(', 'fl41_ld_i16(', 1):
        return False
    k = m.group(1)
    store = re.compile(r'^WR32\(\(uint32_t\)\(ebp \+ %su\), (e[a-d]x|e[sd]i)\);$' % k)
    j = n - 1
    reg = None
    while j >= 0:
        u = stmt(lines[j])
        j -= 1
        if not u:
            continue
        ms = store.match(u)
        if ms:
            reg = ms.group(1)
            break
        if BARRIER.search(u) or u.startswith('{') and not fpu_block(u) or aliasing_write(u, k):
            return False
    if reg is None:
        return False
    sext = re.compile(r'^%s = \(\(uint32_t\)\(int32_t\)\(int16_t\)\(RD16\(.*\)\)\) & 0xffffffffu;$' % reg)
    while j >= 0:
        u = stmt(lines[j])
        j -= 1
        if not u:
            continue
        if sext.match(u):
            return True
        if BARRIER.search(u) or re.search(r'\b%s [-+*/|&^]?= ' % reg, u) or u.startswith('{') and not fpu_block(u):
            return False
    return False


CONST_RD = re.compile(r'\bRD(8|16|32)\(')
_IMAGE = []


def const_reads_substituted(text):
    """FL-55: `text` with every read RD<w>(<constant address>) of the image below the data section (code and constant tables: the world ignores overrides there, and the executable never
    changes them) replaced by the number it reads from the original bytes; None when the text has no such read"""
    if not _IMAGE:
        import fl41_world as W
        import struct
        pe0 = W.od.load_image()
        opt = struct.unpack_from('<I', pe0.image, 0x3c)[0] + 24
        iat_rva, iat_size = struct.unpack_from('<II', pe0.image, opt + 96 + 8 * 12)          # the import address table: the world stores callee stubs there
        _IMAGE.append((pe0, W.DATA_START, (pe0.image_base + iat_rva, pe0.image_base + iat_rva + iat_size)))
    pe, limit, iat = _IMAGE[0]
    out, pos, found = [], 0, False
    while True:
        m = CONST_RD.search(text, pos)
        if not m:
            out.append(text[pos:])
            break
        depth, j = 1, m.end()
        while j < len(text) and depth:
            depth += {'(': 1, ')': -1}.get(text[j], 0)
            j += 1
        inner = text[m.end():j - 1]
        arith = re.sub(r'\(uint32_t\)', '', inner)
        arith = re.sub(r'\b(0x[0-9a-f]+|\d+)u\b', r'\1', arith)
        if not arith.strip() or not re.fullmatch(r'[+\s()]*', re.sub(r'0x[0-9a-f]+|\d+', '', arith)):
            out.append(text[pos:j])
            pos = j
            continue
        address = eval(arith, {'__builtins__': {}}) & 0xffffffff
        width = int(m.group(1)) // 8
        if not (pe.image_base <= address and address + width <= limit) or (address < iat[1] and iat[0] < address + width):
            out.append(text[pos:j])
            pos = j
            continue
        off = address - pe.image_base
        out.append(text[pos:m.start()] + str(int.from_bytes(pe.image[off:off + width], 'little')))
        pos = j
        found = True
    return ''.join(out) if found else None


def const_read_ok(orig, mut):
    """the mutant changes only the width or the address of reads of constants in the image, and every such read gives the same number"""
    a, b = const_reads_substituted(orig), const_reads_substituted(mut)
    return a is not None and a == b


ONE_F32 = re.compile(r'fl41_ld_f32\(fp, 1065353216\)')
ONE_F64 = re.compile(r'fl41_ld_f64\(fp, \(\(uint64_t\)1072693248 << 32\) \| 0\)')


def mul_one_ok(lines, n, orig, mut):
    """FL-55: `fmul` of st(0) by a constant 1.0 (a 4- or 8-byte float constant of the image) is the identity, so the mutant that drops it, or turns the multiplication into a division by the
    same constant, changes nothing. The model is the host's x87 unit at 53 bits of precision (control word 0x27f), where x * 1.0 and x / 1.0 are exact for a value that holds at most 53
    significant bits (a NaN cannot be a signalling one: on the x87 unit a load of a signalling NaN quiets it, and a quiet NaN passes through x * 1.0 and x / 1.0 unchanged; fldcw is not lifted, so the
    precision stays at 53 bits); a row that loads a 64-bit integer (`fild qword`) can hold more, so it is excluded"""
    if 'fl41_fx_mul(fp, d_, s_)' not in orig or any('fl41_ld_i64' in l or 'fl41_ld_f80' in l for l in lines):
        return False
    sub = const_reads_substituted(orig)
    if sub is None or not (ONE_F32.search(sub) or ONE_F64.search(sub)):
        return False
    if re.fullmatch(r';', mut.strip()):
        return True
    return mut == orig.replace('fl41_fx_mul(fp, d_, s_)', 'fl41_fx_div(fp, d_, s_)', 1)


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


def cleanup_split_ok(lines, n):
    """FL-55: the `esp += N;` line of a call written over several lines (a callee that takes st(0) is followed by `fl41_fpop`): the previous statement is the `FL41_CALL(...);`, and the next
    statement that touches esp is `esp = ebp;`"""
    if not re.match(r'^esp \+= \d+u;$', stmt(lines[n])):
        return False
    j = n - 1
    while j >= 0 and not stmt(lines[j]):
        j -= 1
    if j < 0 or not re.match(r'^FL41_CALL\(0x[0-9a-f]+u\);$', stmt(lines[j])):
        return False
    return forward(lines, n, lambda t: t.startswith('esp = ebp;'), lambda t: 'esp' in t or BARRIER.search(t) or re.search(r'\bWR\d+', t) and 'esp' in t)


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
    return stmt(line)


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


def global_forward_ok(lines, n, change):
    """FL-62: a narrower read of a global that the same straight line stored a small constant to a moment ago. `lines[n]` reads `RDw((uint32_t)(0xADDRu))` (original width w, mutant width v < w) and the
    nearest earlier statement that touches memory is `WRw((uint32_t)(0xADDRu), 0xCu)` with C below 2^v: the cell holds C on every path to the read (no label in between, so no other way in), so the
    narrower read returns the same value. In between there may be no call and only stores to other absolute addresses that do not overlap the cell (or pushes through esp);
    a conditional jump out of the line is fine."""
    wa, wb, arg, call, before, after = change
    m = re.match(r'^\(uint32_t\)\((0x[0-9a-f]+)u\)$', arg.strip())
    if not m or wb >= wa:
        return False
    addr = int(m.group(1), 16)
    if re.search(r'\bWR\d+\(', before) or BARRIER.search(before):
        return False                                            # something on the read line itself ahead of the read
    for j in range(n - 1, -1, -1):
        t = stmt(lines[j])
        if not t:
            continue
        s = re.match(r'^WR%d\(\(uint32_t\)\(%su\), (0x[0-9a-f]+)u\);' % (wa, m.group(1)), t)
        if s and not re.search(r'\bWR\d+\(', t[s.end():]) and not BARRIER.search(t[s.end():]):
            return int(s.group(1), 16) < (1 << wb)
        if re.match(r'^if \(.*\) goto L_[0-9a-f]+;$', t) and not re.search(r'\bWR\d+\(', t):
            continue
        if BARRIER.search(t) or re.search(r'\bWR\d+\(\(uint32_t\)\((?!0x)', t):
            return False
        for w in re.finditer(r'\bWR(\d+)\(([^,]*),', t):
            width, target = int(w.group(1)) // 8, w.group(2)
            if target == 'esp':
                continue
            a = re.match(r'^\(uint32_t\)\((0x[0-9a-f]+)u\)$', target)
            if not a:
                return False
            other = int(a.group(1), 16)
            if other < addr + wa // 8 and addr < other + width:
                return False
    return False


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


CMP_CONST = re.compile(r'^\{ uint32_t a_ = (.+?), b_ = (0x[0-9a-f]+)u, r_; FL41_SUB\(a_, b_, 0u, r_, 32\); \}$')
JUMP_STMT = re.compile(r'^if \(([a-z!()|&=\s]*)\) goto (L_[0-9a-f]+);$')          # a condition of cf zf sf of only: no side effect


def writes_reg(t, reg):
    """the statement assigns to `reg` anywhere in it (`reg = `, `reg += `, a partial write inside a block, a swap, ...)"""
    return bool(re.search(r'\b%s\s*([-+*/&|^]|<<|>>)?=(?!=)' % reg, t))


def sub_flags(a, c):
    r = (a - c) & 0xffffffff
    return dict(cf=a < c, zf=a == c, sf=bool(r >> 31), of=bool(((a ^ c) & (a ^ r)) >> 31))


def operand_key(lines, i, expr):
    """What `expr` (the first operand of the compare on line i) denotes, by value: ('cell', k) for the frame slot [ebp + k]; ('via', slot, k) for [reg + k] where reg was loaded from the frame slot by the nearest
    earlier statement (no other write to reg in between) -> (key, first line the value depends on); None when it is neither"""
    m = re.match(r'^RD32\(\(uint32_t\)\((\w+)(?: \+ (0x[0-9a-f]+)u)?\)\)$', expr)
    if not m:
        return None
    base, off = m.group(1), m.group(2) or '0x0'
    if base == 'ebp':
        return ('cell', off), i
    for j in range(i - 1, -1, -1):
        t = stmt(lines[j])
        if not t:
            continue
        d = re.match(r'^%s = RD32\(\(uint32_t\)\(ebp \+ (0x[0-9a-f]+)u\)\);$' % base, t)
        if d:
            return ('via', d.group(1), off), j
        if writes_reg(t, base) or (BARRIER.search(t) and not JUMP_STMT.match(t)) or t.startswith('L_'):
            return None
    return None


def known_compare_ok(lines, n, orig, mut):
    """A conditional jump replaced by another condition where an earlier compare-and-jump on the SAME cell has already ruled out the values on which the two conditions differ. Shape (0x4de322, 0x4be2c6):
        cmp [cell], C0 ; jcc0 away          (fall through: the cell is outside what jcc0 takes away)
        ... only register loads, no store, call, label or jump target in between ...
        cmp [cell], C1 ; jcc  (orig)  vs  jcc'  (mutant)
    The cell is the same when both operands are the same frame slot, or [reg + k] with reg loaded from one frame slot, and no store lies between the earlier load of the slot and the later compare.
    For every unsigned value a of the cell with jcc0 not taken, the original and the mutant condition (evaluated on the flags of a - C1) must agree; the flags are piecewise constant in a with breakpoints
    at C, C + 1, C + 2^31, C + 2^31 + 1, so checking a window of values around each breakpoint of C0 and C1 is exhaustive."""
    a, b = JUMP_STMT.match(orig), JUMP_STMT.match(mut)
    if not a or not b or a.group(2) != b.group(2):
        return False
    k = n - 1
    while k >= 0 and not stmt(lines[k]):
        k -= 1
    c1 = CMP_CONST.match(stmt(lines[k])) if k >= 0 else None
    if not c1:
        return False
    key1 = operand_key(lines, k, c1.group(1))
    if key1 is None:
        return False
    C1 = int(c1.group(2), 16)
    ruled_out = []          # FL-65: every earlier compare-and-jump on the same cell whose fall-through rules values out, not only the nearest one (0x4ef2d1: `cmp [c], 0; je`, `cmp [c], 1; je`, `cmp [c], 2; jne`)
    start = key1[1]
    for j in range(k - 1, -1, -1):
        t = stmt(lines[j])
        if not t:
            continue
        jm = JUMP_STMT.match(t)
        if jm:
            p = j - 1
            while p >= 0 and not stmt(lines[p]):
                p -= 1
            c0 = CMP_CONST.match(stmt(lines[p])) if p >= 0 else None
            key0 = operand_key(lines, p, c0.group(1)) if c0 else None
            if key0 and key0[0] == key1[0]:
                start = min(start, key0[1], p)
                ruled_out.append((int(c0.group(2), 16), jm.group(1)))
            continue
        if re.search(r'\bWR\d+\(', t) or writes_reg(t, 'ebp') or (BARRIER.search(t) and not JUMP_STMT.match(t)) or t.startswith('L_'):
            break
    if not ruled_out:
        return False
    if any(re.search(r'\bWR\d+\(', stmt(lines[q])) or writes_reg(stmt(lines[q]), 'ebp') or BARRIER.search(stmt(lines[q])) and not JUMP_STMT.match(stmt(lines[q])) or stmt(lines[q]).startswith('L_') for q in range(start, k + 1)):
        return False
    points = {0, 1, 2, 0x7fffffff, 0x80000000, 0x80000001, 0xfffffffe, 0xffffffff}
    for c in [C1] + [c0v for c0v, _ in ruled_out]:
        for base in (c, c + 0x80000000):
            points |= {(base + d) & 0xffffffff for d in range(-3, 4)}
    for v in points:
        if any(cond_eval(cj, **sub_flags(v, c0v)) for c0v, cj in ruled_out):
            continue                                    # a jcc0 is taken: the cell is not this value here
        f = sub_flags(v, C1)
        if cond_eval(a.group(1), **f) != cond_eval(b.group(1), **f):
            return False
    return True


def known_compare_safe(lines, n, orig, mut):
    try:
        return known_compare_ok(lines, n, orig, mut)
    except Exception:            # a condition that names anything but cf zf sf of: not this rule's case
        return False


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


def classify(kind, lines, n, equivalent, proofs=None, mutline=None, ranges=None, row=None, cells=None, fn=None):
    if equivalent:
        return 'identical code'
    if kind in ('drop', 'alu') and mutline is not None and mul_one_ok(lines, n, stmt_full(lines[n]), stmt_full(mutline)):
        return 'range'
    if kind in ('width', 'literal') and mutline is not None and const_read_ok(stmt_full(lines[n]), stmt_full(mutline)):
        return 'range'
    if kind == 'width' and mutline is not None and sext16_slot_ok(lines, n, mutline):
        return 'range'
    if kind == 'width' and mutline is not None:
        change = read_change(stmt_full(lines[n]), stmt_full(mutline))
        if change and masked_ok(change):
            return 'masked read'
        if change and width_range_ok(change, ranges, instruction_address(lines, n)):
            return 'range'
        if change and global_forward_ok(lines, n, change):
            return 'forwarded store'
    if kind == 'jump' and mutline is not None and known_compare_safe(lines, n, stmt_full(lines[n]), stmt_full(mutline)):
        return 'known compare'
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
    if kind == 'drop' and cleanup_split_ok(lines, n):
        return 'cleanup'
    if kind == 'register' and frame_ok(lines, n):
        return 'frame'
    if kind in ('alu', 'literal', 'register', 'drop') and esp_adjust_ok(lines, n):
        return 'frame'
    if row:
        import fl48_rules       # FL-48: FL-46's liveness rules (dead flags, dead register, equal push) on the statements
        cls = fl48_rules.explain(kind, lines, n, row)
        if cls:
            return cls
    if cells is not None and mutline is not None:
        import fl64_rules       # FL-65: the exact-value rules of FL-64 (cell range, folded constant) on this one mutant; `cells` are the facts of scripts/fl64_cells.py for the row
        if fl64_rules.cell_width_ok(kind, lines, n, [mutline], cells):
            return 'cell range'
        if fl64_rules.folded_ok(kind, lines, n, [mutline], cells):
            return 'folded constant'
        import fl65_cells
        if fl65_cells.flags_known_ok(kind, lines, n, [mutline], cells):
            return 'known flags'
    if fn is not None and mutline is not None:
        import fl65_diff        # FL-65: the bits in which the mutant can differ never reach a store, an address, a jump condition, a call or the return
        if fl65_diff.unobserved_ok(kind, lines, n, [mutline], row, fn):
            return 'unobserved bits'
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
        cells = None
        if os.environ.get('FL65_CELLS', '1') != '0' and m.group(1) in corpus:       # FL-65: exact reachable values of registers and cells (scripts/fl64_cells.py), None when the loop is not bounded by constants
            import fl65_cells
            cells = fl65_cells.explore(int(m.group(1), 16), corpus[m.group(1)]['body'])
        fn = None
        if os.environ.get('FL65_CELLS', '1') != '0' and m.group(1) in corpus:
            try:
                fn = (RG.TableFunction if ranges else E.Function)(int(m.group(1), 16), corpus[m.group(1)]['body'])
            except E.NoProof:
                fn = None
        items = []
        written = {(r_['kind'], r_['line'], r_.get('ident')) for r_ in WRITTEN.get(m.group(1), []) if text[r_['line']] == r_['statement']}      # FL-48: a written reason for exactly this statement (and mutant, when it names one)
        for kind, n, why, *rest in eval(m.group(2)[:m.group(2).rindex(']') + 1]):
            if why == 'survives':
                ident = rest[0] if rest else None
                same = equiv.get(m.group(1), {}).get((kind, n, ident), False) or (ident is None and equiv.get(m.group(1), {}).get((kind, n, None), False))
                cls = classify(kind, text, n, same, proofs, idents.get((kind, n, ident)), ranges, m.group(1), cells, fn) or ('written reason' if ((kind, n, ident) in written or (kind, n, None) in written) else None)
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
