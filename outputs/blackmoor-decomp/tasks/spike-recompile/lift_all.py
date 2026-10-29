#!/usr/bin/env python3
"""Spike: lift every ledger function with the FL41 lifter in bulk mode; write all_lifted.c and a refusal census."""
import json, sys, time, collections, traceback, re
from pathlib import Path
sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent          # outputs/blackmoor-decomp
sys.path.insert(0, str(PROJECT / 'tests')); sys.path.insert(0, str(PROJECT / 'scripts'))
import lift_fl41 as L
OUT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('.')
L.BULK = True
# fiadd/fisub/fimul/fidiv with an integer memory operand: the lifter refuses them; they are the float forms with that operand converted
FIARITH = {"fiadd": "fadd", "fisub": "fsub", "fisubr": "fsubr", "fimul": "fmul", "fidiv": "fdiv", "fidivr": "fdivr"}
_lift_x87 = L.lift_x87
def lift_x87(c, i, mn):
    if mn in FIARITH and i.operands and i.operands[0].type == L.X.X86_OP_MEM:
        op, reverse = L.FARITH[FIARITH[mn]]
        c.emit("{ long double d_ = FL41_FST(fp, 0), s_ = %s; FL41_FST(fp, 0) = fl41_fx_%s(fp, %s, %s); }" % (L.f_load(i, i.operands[0], "i"), op, "s_" if reverse else "d_", "d_" if reverse else "s_"))
        return
    return _lift_x87(c, i, mn)
L.lift_x87 = lift_x87
L.INLINE_CALLEES.add(0x50f978)
spans = L.ledger_spans()
entries = json.load(open(PROJECT / 'function-ledger.json'))['entries']
rows = sorted(int(e['va'], 16) for e in entries)
ok, refused = {}, {}
meta = {}
t0 = time.time()
for n, va in enumerate(rows):
    body = spans[va]
    try:
        text, callees, imports, fs, inline = L.lift(va, body)
        ok[va] = text
        meta[va] = {'callees': {hex(k): v for k, v in callees.items()}, 'imports': {hex(k): v for k, v in imports.items()}, 'fs': fs,
                    'indirect': {hex(k): v for k, v in L.INDIRECT_SITES.get(va, {}).items()}, 'inline': sorted(hex(x) for x in inline)}
    except L.Unsupported as ex:
        refused[va] = str(ex)
    except Exception as ex:
        refused[va] = 'ERROR ' + repr(ex)[:200]
    if n % 500 == 0:
        print(n, len(ok), len(refused), '%.0fs' % (time.time() - t0), flush=True)
parts_ok = parts_bad = 0
part_size = {}
for e in entries:
    c = int(e['va'], 16)
    parts = sorted(int(p, 16) for p in (e.get('derived_parts') or []))
    end = c + e['span']
    for k, pva in enumerate(parts):
        if pva in ok:
            continue
        nxt = parts[k + 1] if k + 1 < len(parts) else end
        try:
            text, callees, imports, fs, inline = L.lift(pva, nxt - pva)
            ok[pva] = text
            part_size[pva] = nxt - pva
            meta[pva] = {'callees': {hex(a): v for a, v in callees.items()}, 'imports': {hex(a): v for a, v in imports.items()}, 'fs': fs,
                         'indirect': {hex(a): v for a, v in L.INDIRECT_SITES.get(pva, {}).items()}, 'inline': sorted(hex(x) for x in inline), 'part_of': e['va']}
            parts_ok += 1
        except Exception as ex:
            # a part that runs into the jump table of its function: the table is data, so cut the part where the run of code pointers starts
            m = re.search(r'disassembly stops at (0x[0-9a-f]+)', str(ex))
            if m:
                img = L.od.load_image()
                stop = int(m.group(1), 16)
                t = stop & ~3
                while t > pva and 0x401000 <= int.from_bytes(img.image[t - 4 - img.image_base:t - img.image_base], 'little') < 0x540000:
                    t -= 4
                if pva < t < stop:
                    try:
                        text, callees, imports, fs, inline = L.lift(pva, t - pva)
                        ok[pva] = text
                        part_size[pva] = t - pva
                        meta[pva] = {'callees': {hex(a): v for a, v in callees.items()}, 'imports': {hex(a): v for a, v in imports.items()}, 'fs': fs,
                                     'indirect': {hex(a): v for a, v in L.INDIRECT_SITES.get(pva, {}).items()}, 'inline': sorted(hex(x) for x in inline), 'part_of': e['va']}
                        parts_ok += 1
                        continue
                    except Exception as ex2:
                        ex = ex2
            refused[pva] = 'part of %s: %s' % (e['va'], str(ex)[:120])
            parts_bad += 1
print('derived parts lifted', parts_ok, 'refused', parts_bad)
print('lifted', len(ok), 'refused', len(refused), '%.0fs' % (time.time() - t0))
import re, bisect
TAIL1 = re.compile(r'FL41_CALL\((0x[0-9a-f]+u)\); esp \+= \d+u; goto done;(  /\* 0x[0-9a-f]+: jmp )')
TAIL2 = re.compile(r'FL41_CALL\(t_\); esp \+= \d+u; goto done; \}(  /\* 0x[0-9a-f]+: jmp )')
tails = 0
for va in ok:
    t, n1 = TAIL1.subn(r'FL41_TAILJMP(\1);\2', ok[va])
    t, n2 = TAIL2.subn(r'FL41_TAILJMP(t_); }\1', t)
    ok[va] = t
    tails += n1 + n2
print('tail jumps rewritten', tails)
# a call through a register or pointer: the lifter assumed the callee pops what the caller pushed (stdcall), which is wrong for a
# cdecl callback (qsort's comparator); take the callee's own `ret N` from its final esp instead
ICALL = re.compile(r'FL41_CALL\(t_\); (?:esp \+= (\d+)u; )?esp \+= 4u; \}')
icalls = 0
for va in ok:
    ok[va], n = ICALL.subn(lambda m: 'FL41_ICALL(t_, %su); }' % (m.group(1) or '0'), ok[va])
    icalls += n
print('indirect calls rewritten', icalls)
# the x87 stack is global, as on the machine: a callee takes its operands from the caller's stack and leaves its result on it, so the
# per-call model (callee on an empty stack, `fpush(fret)` / `fpop` in the caller) is dropped; the host no longer zeroes or restores the stack
FPCALL = re.compile(r'(FL41_CALL\(0x[0-9a-f]+u\);\n(?:    esp \+= \d+u;\n)+)    fl41_fp(?:ush\(fp, fl41_ld_f64\(fp, h->fret\(h->ctx\)\)\)|op\(fp\));\n')
fpcalls = 0
for va in ok:
    ok[va], n = FPCALL.subn(r'\1', ok[va])
    fpcalls += n
print('x87 per-call adjustments removed', fpcalls)
# entry aliases for direct calls and tail jumps that land inside a function
starts = sorted(ok)
aliases = {}
for e in entries:
    c = int(e['va'], 16)
    if c in ok:
        for part in e.get('derived_parts') or []:
            aliases[int(part, 16)] = c
for va, m in meta.items():
    for t in m['callees']:
        t = int(t, 16)
        if t in spans or t in ok or t in aliases:
            continue
        i = bisect.bisect_right(starts, t) - 1
        if i >= 0 and starts[i] <= t < starts[i] + (spans.get(starts[i]) or part_size[starts[i]]):
            aliases[t] = starts[i]
print('alias candidates', len(aliases))
alias_text = {}
for t, c in sorted(aliases.items()):
    text = ok[c]
    marker = '/* 0x%x: ' % t
    if marker not in text:
        print('alias %x: no instruction at that address in %x' % (t, c)); continue
    lines = text.split('\n')
    out = []
    inserted_goto = False
    for ln in lines:
        if ln.startswith('void m%x_lifted(' % c):
            ln = ln.replace('m%x_lifted' % c, 'm%x_lifted' % t)
        if marker in ln and ('L_%x:' % t) not in text:
            out.append('L_%x:' % t)
        out.append(ln)
        if not inserted_goto and ln.strip() in ('FL41_PROLOGUE', 'FL41_FPU_PROLOGUE', 'uint32_t esp0_ = esp;'):
            pass
    # the goto goes after the last prologue line
    k = max(i for i, ln in enumerate(out) if ln.strip() in ('FL41_PROLOGUE', 'FL41_FPU_PROLOGUE', 'uint32_t esp0_ = esp;'))
    out.insert(k + 1, '    goto L_%x;' % t)
    alias_text[t] = '\n'.join(out)
print('aliases', len(alias_text), 'of', len(aliases))
with open(OUT / 'all_lifted.c', 'w') as f:
    f.write('#include "original_methods_fl41.h"\n')
    f.write('#include "original_methods_fl41_x87.h"\n')
    f.write('#include "fl57_helpers.h"\n')
    f.write('#include "spike_macros.h"\n')
    for va in sorted(ok):
        f.write('\n' + ok[va])
    for t in sorted(alias_text):
        f.write('\n' + alias_text[t])
ok.update({t: None for t in alias_text})
json.dump({'lifted': sorted(hex(v) for v in ok), 'meta': {hex(k): v for k, v in meta.items()}, 'refused': {hex(k): v for k, v in refused.items()}},
          open(OUT / 'lift_census.json', 'w'), indent=0)
reasons = collections.Counter(' '.join(r.split()[:3]) for r in refused.values())
for r, c in reasons.most_common(40):
    print('%5d  %s' % (c, r))
