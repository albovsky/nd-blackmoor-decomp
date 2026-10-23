#!/usr/bin/env python3
"""FL-40: sort the survivors of tests/fl40_mutation_check.py (its log as the argument) into those that are provably equivalent mutants and the rows that stay out.

A survivor is explained only when one of these holds for the mutated statement; everything else leaves its row pending:
  identical code   `cc -O2 -S` of the mutant and of the translation give the same assembly (tests/fl40_equiv_check.py): a flag nothing reads, a dead store
  same value       a register reload `reg = RD(ebp +- k)` right after the store `WR(ebp +- k, reg)` or the load `reg = RD(ebp +- k)` of the same register, on straight-line code with no call, label, jump or
                   store that could hit the slot in between (a store through another register is assumed not to point into the function's own frame): the register already holds the value, so dropping the reload changes nothing
  available copy   (FL-42) the same reload, across labels and jumps: a forward dataflow over the statements of the function (intersection at joins) tracks which register
                   equals which frame slot; a reload of a register that equals the slot on every path to it changes nothing. A call kills eax, ecx, edx; a function that takes
                   the address of a frame slot, or addresses its frame through esp, kills all slot facts at every call and every store through a register
  cleanup          the bytes a played callee pops after a call (`esp += n`) when the next statement that touches esp is `esp = ebp` on straight-line code
  frame            `ebp = esp` / `esp = ebp` where nothing reads ebp between that statement and the next `esp = ebp`, or a `sub esp, N` whose next esp-touching statement is `esp = ebp`
The earlier "local width" class (a narrower read of a frame local that the corpus never shows) is NOT an equivalence and is gone: those rows stay pending.

  fl40_survivors.py <mutation log> [--equiv tasks/fl40-equivalence.json] [--out tasks/fl40-survivors.json]
"""
import json
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl40_mutation_check as M

BARRIER = re.compile(r'FL40_CALL|goto|^L_|^done:|while|switch|case |FL40_EPILOGUE')


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


SLOT_READ = re.compile(r'^(e[a-z]{2}) = RD32\(\(uint32_t\)\(ebp \+ (0x[0-9a-f]+)u\)\);')
SLOT_WRITE = re.compile(r'\bWR32\(\(uint32_t\)\(ebp \+ (0x[0-9a-f]+)u\), (e[a-z]{2})\);')
SLOT_ACCESS = re.compile(r'\b(?:RD|WR)(\d+)\(\(uint32_t\)\(ebp \+ (0x[0-9a-f]+)u\)')
GP = ('eax', 'ecx', 'edx', 'ebx', 'esi', 'edi')
LABEL = re.compile(r'^(L_[0-9a-f]+|done):$')


def slot_range(k, width):
    k = int(k, 16)
    k = k - (1 << 32) if k >= 1 << 31 else k
    return k, k + width


def available_copies(lines):
    """for every statement index, the set of (register, slot) pairs that hold on every path reaching it (None for a statement no path reaches); None when the function is not analysable"""
    texts = [stmt(l) for l in lines]
    start = next((i for i, t in enumerate(texts) if t.startswith('FL40_PROLOGUE')), None)
    stop = next((i for i, t in enumerate(texts) if t.startswith('FL40_EPILOGUE')), None)
    if start is None or stop is None:
        return None
    ids = [i for i in range(start + 1, stop) if texts[i] and not texts[i].startswith('/*')]
    whole = '\n'.join(texts[i] for i in ids)
    if re.search(r'switch|\bcase\b|\bwhile\b|\bfor\b', whole):
        return None
    if re.search(r'\besp \+ ', whole) or re.search(r'\bebp = (?!esp;|RD32\(esp\);)', whole):
        return None                 # the frame is addressed through esp, or ebp is rebuilt
    if 'ebp = esp;' not in whole:
        return None                 # ebp is not this function's own frame pointer
    first_epilogue = whole.find('esp = ebp;')
    if first_epilogue >= 0 and re.search(r'\bWR\d+\(esp\b', whole[first_epilogue:]):
        return None                 # a push after the frame is released could land on a slot
    rest = SLOT_ACCESS.sub('', whole)
    for allowed in ('ebp = esp;', 'esp = ebp;', 'ebp = RD32(esp);'):
        rest = rest.replace(allowed, '')
    rest = rest.replace('WR32(esp, ebp);', '', 1)           # the prologue push only
    # the address of a slot (lea, push of ebp +- k, a copy of esp) leaves the function's own accesses: a callee or a store through a register may reach it
    escapes = 'ebp' in rest or bool(re.search(r'= esp;|\(esp\)\);', rest.replace('esp = ebp;', '')))
    labels, pending = {}, []
    for i in ids:
        if LABEL.match(texts[i]):
            pending.append(texts[i][:-1])
            continue
        for lab in pending:
            labels[lab] = i
        pending = []
    stmts = [i for i in ids if not LABEL.match(texts[i]) and texts[i] not in ('{', '}')]
    succ = {}
    for pos, i in enumerate(stmts):
        t = texts[i]
        nxt = stmts[pos + 1] if pos + 1 < len(stmts) else None
        outs = []
        m = re.search(r'goto (L_[0-9a-f]+|done);', t)
        if m:
            if labels.get(m.group(1)) is not None:
                outs.append(labels[m.group(1)])
            if t.startswith('if (') and nxt is not None:
                outs.append(nxt)
        elif nxt is not None:
            outs.append(nxt)
        succ[i] = outs

    def transfer(i, facts):
        t = texts[i]
        out = set(facts)
        written = {r for r in GP + ('ebp', 'esp') if re.search(r'(?<![\w.])%s (?:[-+*/&|^]|<<|>>)?= |(?<![\w.])%s(?:\+\+|--)|(?:\+\+|--)%s\b' % (r, r, r), t)}
        if 'FL40_CALL_LIFTED' in t or 'FL40_TRAP' in t:
            return set()
        if 'FL40_CALL' in t:
            written |= {'eax', 'ecx', 'edx'}
            if escapes:
                out = set()
        if 'ebp' in written:
            return set()
        out = {f for f in out if f[0] not in written}
        for m in SLOT_ACCESS.finditer(t):
            if t[m.start():m.start() + 2] == 'WR':
                lo, hi = slot_range(m.group(2), int(m.group(1)) // 8)
                out = {f for f in out if not (lo < slot_range(f[1], 4)[1] and slot_range(f[1], 4)[0] < hi)}
        for m in re.finditer(r'\bWR\d+\(([^;]*)', t):                 # a store whose address is built from ebp in any other way (indexed) may hit any slot
            if 'ebp' in m.group(1).split(',')[0] and not SLOT_ACCESS.match(m.group(0)):
                out = set()
        if escapes and re.search(r'\bWR\d+\((?!\(uint32_t\)\(ebp \+ 0x[0-9a-f]+u\)|esp,)', t):
            out = set()
        m = SLOT_WRITE.search(t)
        if m and not written and not t.startswith('if ('):
            out.add((m.group(2), m.group(1)))
        m = SLOT_READ.match(t)
        if m and t.count('RD') == 1 and not t.startswith('if ('):
            out.add((m.group(1), m.group(2)))
        return out

    IN = {i: None for i in stmts}
    if not stmts:
        return None
    IN[stmts[0]] = set()
    changed = True
    while changed:
        changed = False
        for i in stmts:
            if IN[i] is None:
                continue
            out = transfer(i, IN[i])
            for j in succ[i]:
                new = set(out) if IN[j] is None else IN[j] & out
                if new != IN[j]:
                    IN[j] = new
                    changed = True
    return IN


_AVAILABLE = [None, None]


def available_copy_ok(lines, n):
    """lines[n] is `reg = RD32(slot)` and reg already equals the slot on every path to it"""
    m = SLOT_READ.match(stmt(lines[n]))
    if not m:
        return False
    if _AVAILABLE[0] is not lines:
        _AVAILABLE[:] = [lines, available_copies(lines)]
    facts = _AVAILABLE[1]
    return facts is not None and facts.get(n) is not None and (m.group(1), m.group(2)) in facts[n]


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
    return 'FL40_CALL' in lines[n] and forward(lines, n, lambda t: t.startswith('esp = ebp;'),
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


def rep_count_ok(lines, n):
    """(FL-44) `shr ecx, 2` (or `sar`) whose result is the count of the very next `rep movsd` / `rep stosd`: arithmetic and logical shift differ only when bit 31 of ecx is set,
    and then the count is at least 2^29 dwords = 2 GiB. GAME.EXE is a 32-bit image without IMAGE_FILE_LARGE_ADDRESS_AWARE (characteristics 0x10f), so its user space is below
    2 GiB: a copy or fill of 2 GiB cannot finish (it hits unmapped memory), and in the emulated world it runs into the instruction limit. Both the original and the
    mutant fault on every such seed, so no completing execution tells them apart."""
    t = stmt(lines[n])
    m = re.match(r'^\{ uint32_t a_ = ecx, n_ = 0x2u, r_; if \(n_ != 0u\) \{ FL40_(SHR|SAR)\(r_, a_, n_, 32\); ecx = r_; \} \}$', t)
    if not m:
        return False
    for j in range(n + 1, len(lines)):
        raw = lines[j].strip()
        if not raw:
            continue
        if raw.startswith('/*'):
            if re.match(r'/\* 0x[0-9a-f]+: rep (movsd|stosd) ', raw):
                return True
            return False
        return False
    return False


_RANGES = {}


def frame_ranges(row):
    """fl44_ranges.ranges() of a row (cached); None when GAME.EXE or capstone is missing or the function is refused"""
    if row not in _RANGES:
        import fl44_ranges as R
        corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
        _RANGES[row] = R.ranges(int(row, 16), corpus[row]['body']) if R.available() and row in corpus else None
    return _RANGES[row]


FIRST_RD = re.compile(r'\bRD(8|16|32)\(\(uint32_t\)\(ebp \+ (0x[0-9a-f]+)u\)\)')
INSN = re.compile(r'/\* (0x[0-9a-f]+): ')


def range_ok(row, lines, n):
    """(FL-44) a narrower read of a frame slot that always holds a value the narrower access reads whole. The first RD of the statement must be the slot read, the slot a dword
    slot that scripts/fl44_ranges.py tracks at that instruction, and its interval inside what the narrower width keeps: below 2^16 for RD32 -> RD16, below 2^8 for RD16 -> RD8
    (below 2^7 when the read is sign-extended)."""
    text = lines[n]
    m = INSN.search(text)
    first = re.search(r'\bRD(8|16|32)\(', text)
    if not m or not first or not text.rstrip().endswith('*/') or len(re.findall(r'\b(?:RD|WR)\d+\(', text)) != 1:
        return False            # the statement must be one line with a single memory token, so that the only width mutant is the read
    slot = FIRST_RD.match(text, first.start())
    if not slot:
        return False
    width = int(slot.group(1))
    if width == 8:
        return False
    disp = int(slot.group(2), 16)
    disp = disp - (1 << 32) if disp >= 1 << 31 else disp
    r = frame_ranges(row)
    if r is None or int(m.group(1), 16) not in r or disp not in r[int(m.group(1), 16)]:
        return False
    hi = r[int(m.group(1), 16)][disp][1]
    bits = 16 if width == 32 else 8
    signed = 'int16_t' in text or 'int8_t' in text
    return hi < (1 << (bits - 1 if signed else bits))


MASKED_BYTE = re.compile(r'^\s*\w+ = \(\w+ & 0xffffff00u\) \| \(\(RD8\(.*\)\) & 0xffu\);')


def masked_read_ok(lines, n):
    """(FL-44) `(RD8(x)) & 0xffu` read as RD16: the low byte of the wider read is the byte, the mask drops the rest; only the wider read itself differs, and no trace records reads.
    The one place where the wider read is observable is the top of the model's address space (the world faults from 0xfff00000, a Win32 user space ends below 2 GiB), which no real read reaches."""
    t = stmt(lines[n])
    return bool(MASKED_BYTE.match(t)) and t.count('RD') == 1


_FLOW = {}


def flow_ok(row, lines, n):
    """(FL-44, using FL-43's scripts/fl43_equiv.py) the dropped instruction is a data-flow no-op on the original instructions: its work is repeated or dead"""
    m = INSN.search(lines[n])
    if not m or not row:
        return None
    key = (row, int(m.group(1), 16))
    if key not in _FLOW:
        try:
            import fl43_equiv as E
            corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
            res = E.prove(int(row, 16), corpus[row]['body'], [key[1]])
            _FLOW[key] = (res.get(key[1]) or '').split(':')[0] or None
        except Exception:
            _FLOW[key] = None
    return _FLOW[key]


def classify(kind, lines, n, equivalent, row=None):
    if equivalent:
        return 'identical code'
    if kind == 'alu' and rep_count_ok(lines, n):
        return 'rep count'
    if kind == 'drop' and flow_ok(row, lines, n):
        return 'flow ' + flow_ok(row, lines, n)
    if kind == 'width' and masked_read_ok(lines, n):
        return 'masked read'
    if kind == 'width' and row and range_ok(row, lines, n):
        return 'range'
    if kind == 'drop' and (same_value(lines, n) or available_copy_ok(lines, n)):
        return 'same value'
    if kind == 'literal' and cleanup_ok(lines, n):
        return 'cleanup'
    if kind == 'register' and frame_ok(lines, n):
        return 'frame'
    if kind in ('alu', 'literal', 'register', 'drop') and esp_adjust_ok(lines, n):
        return 'frame'
    if row:
        import fl46_rules       # FL-46: dead flags, dead registers, equal pushes (liveness on the statements)
        return fl46_rules.explain(kind, lines, n, row)
    return None


def main():
    log = sys.argv[1]
    equiv = {}
    if '--equiv' in sys.argv:
        for row, items in json.loads(Path(sys.argv[sys.argv.index('--equiv') + 1]).read_text())['rows'].items():
            equiv[row] = {(i['kind'], i['line']): i['equivalent'] for i in items}
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl40.c').read_text())
    out = {'rows_with_survivors': {}, 'unexplained_rows': []}
    for line in open(log):
        m = re.match(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)', line)
        if not m:
            continue
        text = funcs[m.group(1)].split('\n')
        items = []
        for kind, n, why in eval(m.group(2)[:m.group(2).rindex(']') + 1]):
            if why == 'survives':
                items.append((kind, classify(kind, text, n, equiv.get(m.group(1), {}).get((kind, n), False), m.group(1)), text[n].strip()[:160], n))
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
