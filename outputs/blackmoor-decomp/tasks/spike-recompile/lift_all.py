#!/usr/bin/env python3
"""Spike: lift every ledger function with the FL41 lifter in bulk mode; write all_lifted.c and a refusal census."""
import json, sys, time, collections, traceback
from pathlib import Path
sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent          # outputs/blackmoor-decomp
sys.path.insert(0, str(PROJECT / 'tests')); sys.path.insert(0, str(PROJECT / 'scripts'))
import lift_fl41 as L
OUT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('.')
L.BULK = True
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
            meta[pva] = {'callees': {hex(a): v for a, v in callees.items()}, 'imports': {hex(a): v for a, v in imports.items()}, 'fs': fs,
                         'indirect': {hex(a): v for a, v in L.INDIRECT_SITES.get(pva, {}).items()}, 'inline': sorted(hex(x) for x in inline), 'part_of': e['va']}
            parts_ok += 1
        except Exception as ex:
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
        if i >= 0 and starts[i] <= t < starts[i] + spans[starts[i]]:
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
