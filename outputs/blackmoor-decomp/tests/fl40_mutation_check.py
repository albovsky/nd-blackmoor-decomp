#!/usr/bin/env python3
"""FL-40 mutation check: do the seeds of tests/fl40_corpus.json tell the translation of a row from a slightly wrong one?

For each row it takes the committed C of `m<va>_lifted` (src/original_methods_fl40.c) and makes mutants by hand-rolled operators on single lines of it:
  jump       a conditional jump goes the other way (`if (c) goto` becomes `if (!(c)) goto`)
  literal    one numeric literal of a statement changes by one (a constant, a displacement, a carry-in, a shift count)
  alu        an add becomes a subtract and the other way round
  width      a memory access gets another width (RD32 <-> RD16 <-> RD8, WR32 <-> WR16 <-> WR8)
  register   the source register of a move or a push is another register
  drop       a stack adjustment, a store or a register update statement is removed
A mutant is killed when the translation of the mutant differs from the ORIGINAL bytes' recorded behaviour (final registers, ordered writes, ordered stub calls) on
any seed of the row. A survivor is retried on 40 more seeds that are not in the corpus (WIDE more with --harden); one that still survives is listed (it may be an equivalent mutant: a
statement whose effect no seed can see, such as the flags of an instruction whose flags nothing reads).

  fl40_mutation_check.py [--rows 0x401000,...] [--per-row 30] [--jobs 4]      (run from outputs/blackmoor-decomp)

Prints one line per row (mutants, killed, survivors) and a total; exits 1 when a survivor remains after the extra seeds.
"""
import argparse
import json
import mmap
import multiprocessing as mp
import os
import signal
import struct
from pathlib import Path
import random
import re
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import fl40_world as W

PROJECT = HERE.parent
SOURCE = PROJECT / 'src/original_methods_fl40.c'
CORPUS = HERE / 'fl40_corpus.json'
REGS = ['eax', 'ecx', 'edx', 'ebx', 'esi', 'edi']
EXTRA_SEEDS = range(5000, 5040)
WINDOW = None       # --window lo:hi: only the picked mutants lo..hi-1 (a row with more mutants than one compiler run can hold)
ALARM = float(os.environ.get('FL46_ALARM', '10'))     # seconds a scenario may run; FL-46 strict mode uses a short one
BUDGET = os.environ.get('FL46_BUDGET') == '1'       # FL-46 (Glib's ruling of 2026-10-23): a mutant that runs more than 100 times the original's instructions counts as killed, labelled 'killed by step budget'
STRICT = os.environ.get('FL46_STRICT_HANG') == '1' or BUDGET
BUDGET_FLOOR = 100          # the search for a mismatch skips a scenario once the mutant has made 100 times the original's instructions in taken jumps and loop turns, at least this many
CONFIRM_FLOOR = 200000      # a hang kill is confirmed on one scenario by the budget max(100 x the original's instructions, this many taken jumps and loop turns) (the same definition as FL-47)
PRELUDE = '''#include <signal.h>
static unsigned long long fl46_steps, fl46_limit = ~0ull;
void fl46_set_limit(unsigned long long limit) { fl46_steps = 0; fl46_limit = limit; }
unsigned long long fl46_get_steps(void) { return fl46_steps; }
#define FL46_STEP() do { if (++fl46_steps > fl46_limit) raise(SIGUSR1); } while (0)
'''


class Ref(str):
    steps = 0


def dig(t):
    r = Ref(t.digest())
    r.steps = t.steps
    return r


def instrument(code):
    """count the taken jumps and the turns of the rep loops: a straight line of statements is bounded, so any run that does not end makes unboundedly many"""
    code = re.sub(r'\bgoto (L_[0-9a-f]+|done);', r'{ FL46_STEP(); goto \1; }', code)
    return code.replace('while (ecx != 0u) {', 'while (ecx != 0u) { FL46_STEP();')


WIDE = 300          # --harden: seeds tried on a survivor after the extra ones


def split_functions(text):
    parts = re.split(r'(?=/\* GAME\.EXE 0x[0-9a-f]+ \()', text)
    out = {}
    for part in parts:
        m = re.match(r'/\* GAME\.EXE (0x[0-9a-f]+) \(', part)
        if m:
            out[m.group(1)] = part
    return out


COMMENT = re.compile(r'^(.*?)(\s*/\* 0x[0-9a-f]+: .*\*/)?$')


def mutants(text, va, rng, limit, only=None):
    lines = text.split('\n')
    found = []
    for n, line in enumerate(lines):
        code, comment = COMMENT.match(line).groups()
        comment = comment or ''
        if not code.strip() or code.strip() in ('{', '}') or code.strip().startswith(('/*', 'void ', 'FL40_', 'done:', 'L_', 'while', 'switch', 'case', 'default', 'break')):
            continue

        def add(kind, new_code):
            found.append((kind, n, new_code + comment))
        m = re.match(r'^(\s*)if \((.*)\) goto (L_[0-9a-f]+);\s*$', code)
        if m:
            add('jump', '%sif (!(%s)) goto %s;' % (m.group(1), m.group(2), m.group(3)))
            continue
        if 'goto' in code or 'case ' in code or 'switch' in code:
            continue
        if 'FL40_ADD(' in code:
            add('alu', code.replace('FL40_ADD(', 'FL40_SUB('))
        if 'FL40_SUB(' in code:
            add('alu', code.replace('FL40_SUB(', 'FL40_ADD('))
        for old, new in (('FL40_SHL(', 'FL40_SHR('), ('FL40_SHR(', 'FL40_SAR('), ('FL40_SAR(', 'FL40_SHR('), ('FL40_ROL(', 'FL40_ROR('), ('FL40_ROR(', 'FL40_ROL(')):
            if old in code:
                add('alu', code.replace(old, new, 1))
        if re.search(r'FL40_(ADD|SUB)\(a_, b_, ([01])u,', code):
            add('literal', re.sub(r'(FL40_(?:ADD|SUB)\(a_, b_, )([01])u,', lambda m: '%s%du,' % (m.group(1), 1 - int(m.group(2))), code, count=1))
        if 'FL40_SUB(' in code and 'a_ = ' in code and 'b_ = ' in code:        # the other operators of a block are commutative: swapping them is no mutant
            add('register', re.sub(r'a_ = ([^,]+), b_ = ([^,;]+),', r'a_ = \2, b_ = \1,', code, count=1))
        if 'FL40_CALL' not in code:
            for old, new in (('RD32(', 'RD16('), ('RD16(', 'RD8('), ('RD8(', 'RD16('), ('WR32(', 'WR16('), ('WR16(', 'WR8('), ('WR8(', 'WR16(')):
                if old in code:
                    add('width', code.replace(old, new, 1))
        m = re.match(r'^(\s*)(\w{3}) = (eax|ecx|edx|ebx|esi|edi|ebp|esp);\s*$', code)
        if m:
            other = rng.choice([r for r in REGS + ['ebp', 'esp'] if r != m.group(3)])
            add('register', '%s%s = %s;' % (m.group(1), m.group(2), other))
        m = re.search(r'WR32\(esp, (eax|ecx|edx|ebx|esi|edi|ebp)\);', code)
        if m:
            other = rng.choice([r for r in REGS if r != m.group(1)])
            add('register', code.replace(m.group(0), 'WR32(esp, %s);' % other, 1))
        if 'FL40_CALL' not in code:
            add('drop', re.sub(r'\S.*$', ';', code))
        for lit in re.finditer(r'0x([0-9a-f]+)u', code):
            if 'FL40_CALL' in code or 'esp, 0x' in code or lit.start() == 0:
                continue
            v = int(lit.group(1), 16)
            add('literal', code[:lit.start()] + '0x%xu' % ((v + 1) & 0xffffffff) + code[lit.end():])
            break
        m = re.search(r'esp \+= (\d+)u;', code)
        if m and 'FL40_CALL' in code and int(m.group(1)) > 4:
            add('literal', code.replace(m.group(0), 'esp += %du;' % (int(m.group(1)) - 4), 1))
    rng.shuffle(found)
    by_kind = {}
    for f in found:
        by_kind.setdefault(f[0], []).append(f)
    picked = []
    while len(picked) < limit and any(by_kind.values()):
        for kind in list(by_kind):
            if by_kind[kind] and len(picked) < limit:
                picked.append(by_kind[kind].pop())
    out = []
    if WINDOW:
        picked = picked[WINDOW[0]:WINDOW[1]]
    for kind, n, replacement in picked:
        if only is not None and (kind, n) not in only:
            continue
        mutated = list(lines)
        mutated[n] = replacement
        text2 = '\n'.join(mutated).replace('m%x_lifted' % va, 'm%x_mut%d' % (va, len(out)), 1)
        out.append((kind, n, text2))
    return out


def check_row(args):
    try:
        return check_row_inner(args)
    except Exception as exc:        # a worker that raises something unpicklable would hang the pool
        return args[0], {'error': 'worker crashed: %s' % repr(exc)[:300]}


def safe_original(row, sd, ov=()):
    try:
        return W.run_original(row, sd, ov)
    except Exception:
        return None


def check_row_inner(args):
    key, entry, text, helper, per_row, harden, rescue = args
    va = int(key, 16)
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    rng = random.Random(va)
    muts = mutants(text, va, rng, per_row, rescue['only'] if rescue else None)     # FL-42 rescue: only the mutants that survived an earlier run, against a long list of new seeds
    scenarios = [(sd, [tuple(o) for o in ov]) for sd, ov in entry['seeds']]
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / 'm.c'
        for _ in range(4):
            src.write_text('#include "original_methods_fl40.h"\n' + (PRELUDE if BUDGET else '') + (instrument if BUDGET else str)(helper + text + '\n'.join(m[2] for m in muts)))
            cmd = ['cc', '-std=c11', '-O0', '-shared', '-fPIC', '-w', '-I%s' % (PROJECT / 'src'), str(src), '-o', str(Path(tmp) / 'm.so')]
            built = subprocess.run(cmd, capture_output=True, text=True)
            if built.returncode == 0:
                break
            bad = {int(x) for x in re.findall(r"m%x_mut(\d+)" % va, built.stderr)}
            if not bad:
                return key, {'error': built.stderr[:600]}
            # a mutant that does not compile (a dropped loop header, a deleted label) is not a mutant: leave it out and renumber
            muts = [(kind, n, t.replace('m%x_mut%d' % (va, i), 'm%x_mutX' % va)) for i, (kind, n, t) in enumerate(muts) if i not in bad]
            muts = [(kind, n, re.sub(r'm%x_mutX' % va, 'm%x_mut%d' % (va, i), t, count=1)) for i, (kind, n, t) in enumerate(muts)]
        else:
            return key, {'error': 'mutants do not compile'}
        import ctypes
        lib = ctypes.CDLL(str(Path(tmp) / 'm.so'))
        if BUDGET:
            lib.fl46_set_limit.argtypes = [ctypes.c_ulonglong]
            lib.fl46_get_steps.restype = ctypes.c_ulonglong
        reference = [(sd, ov, dig(W.run_original(row, sd, ov))) for sd, ov in scenarios]
        extra = None
        wide = None
        killed, survivors, killers = 0, [], set()
        mutant_survivors = []       # FL-49: (index of the mutant, kind, line) of every survivor, for the per-mutant detail (FL49_DETAIL=1)
        fresh_by_stage = []
        end_kind = [None]       # FL-46: how the last scan child ended when it did not finish: 'alarm' (a hang), 'crash' (another signal than SIGKILL, which is the out-of-memory killer's or a kill from outside and kills nothing) or 'nonend' (it left without finishing, an out-of-memory)

        port_steps = []         # FL-46: after scan(None, ...), the taken jumps and loop turns of the unmutated port on each of its items

        def scan(k, items, every=False, floor=BUDGET_FLOOR):
            """Run mutant k (None: the unmutated translation) on the scenarios against the recorded original, in a forked child.
            -> (indices of the scenarios on which it differs, the one a hang or crash stopped it on last; only the first unless `every`; and True when it hung or crashed).
            Every scenario has its own alarm (a mutant that loops forever is dead on that seed). The child leaves the index it is on and a flag per scenario in shared memory,
            so a hang names its seed and the mismatches found before it are not lost."""
            cur = mmap.mmap(-1, 8)
            flags = mmap.mmap(-1, len(items) + 1)
            stepmm = mmap.mmap(-1, 8 * len(items) + 8)
            r_fd, w_fd = os.pipe()
            pid = os.fork()
            if pid == 0:
                try:
                    os.close(r_fd)
                    for i, (sd, ov, ref) in enumerate(items):
                        cur[:8] = struct.pack('<q', i)
                        if BUDGET:
                            lib.fl46_set_limit(~0 & 0xffffffffffffffff if k is None else max(100 * ref.steps, floor))
                        signal.setitimer(signal.ITIMER_REAL, ALARM)
                        t = W.run_native(Shim(lib, va, k), row, sd, ov)
                        signal.setitimer(signal.ITIMER_REAL, 0)
                        if BUDGET and k is None:
                            struct.pack_into('<Q', stepmm, 8 * i, lib.fl46_get_steps())
                        if (t.digest() if not t.fault else 'fault') != ref:
                            flags[i] = 1
                            if not every:
                                break
                    os.write(w_fd, b'D')
                except MemoryError:             # the mutant ran away with memory: the original does not
                    pass
                except Exception as exc:        # a harness bug is not a kill
                    os.write(w_fd, b'E' + repr(exc).encode()[:200])
                finally:
                    os._exit(0)
            os.close(w_fd)
            chunks = []
            while True:
                c = os.read(r_fd, 65536)
                if not c:
                    break
                chunks.append(c)
            os.close(r_fd)
            _, status = os.waitpid(pid, 0)
            end_kind[0] = 'alarm' if os.WIFSIGNALED(status) and os.WTERMSIG(status) == signal.SIGALRM else 'budget' if os.WIFSIGNALED(status) and os.WTERMSIG(status) == signal.SIGUSR1 else 'crash' if os.WIFSIGNALED(status) and os.WTERMSIG(status) != signal.SIGKILL else 'nonend'
            port_steps[:] = [struct.unpack_from('<Q', stepmm, 8 * i)[0] for i in range(len(items))]
            data = b''.join(chunks)
            if data.startswith(b'E'):
                raise RuntimeError('mutation harness error on %s mutant %s: %s' % (key, k, data[1:].decode()))
            found = [i for i in range(len(items)) if flags[i]]
            if data != b'D':
                found.append(struct.unpack('<q', cur[:8])[0])      # the alarm, or the mutant crashed the process: the original does neither
                return found, True
            return found, False

        def guard(items, what):
            """FL-44: a kill counts only on a seed where the unmutated translation equals the original. Returns the scenarios where it does.
            A scenario that makes the unmutated translation hang or crash is dropped too and the scan goes on after it."""
            bad, start = set(), 0
            while items and start < len(items):
                found, hung = scan(None, items[start:], every=True)
                bad |= {start + i for i in found}
                if BUDGET:
                    for i in range(len(port_steps)):
                        if start + i not in bad:
                            items[start + i][2].steps = port_steps[i]       # the unit of the budget is the port's own: taken jumps and loop turns
                if not hung:
                    break
                start += found[-1] + 1
            dropped[0] += len(bad)
            if bad and what == 'corpus':
                raise RuntimeError('the unmutated translation of %s differs from the original on corpus seed %s' % (key, items[min(bad)][0]))
            return [it for i, it in enumerate(items) if i not in bad]

        def first_mismatch(k, items):
            """Index of the first scenario on which mutant k differs from the recorded original (a hang counts), None when it agrees everywhere.
            FL-46 strict mode (FL46_STRICT_HANG=1, Glib's ruling that a timeout is never a kill): a scenario that ends in the alarm or in an out-of-memory kills nothing and the scan goes on after it;
            a crash by another signal still kills."""
            if not STRICT:
                found, hung = scan(k, items)
                if hung:
                    hangs.append(k)
                return min(found) if found else None
            start, first_hit = 0, None
            over = []       # FL-50: every scenario on which the quick budget (BUDGET_FLOOR) ran out
            while start < len(items):
                found, hung = scan(k, items[start:])
                if not hung:
                    return start + min(found) if found else None
                if end_kind[0] == 'crash':
                    return start + min(found)
                if end_kind[0] == 'budget':
                    first_hit = first_hit or items[start + found[-1]]
                    over.append(items[start + found[-1]])
                else:
                    hangs.append(k)
                start += found[-1] + 1
            if first_hit is not None and BUDGET:        # no mismatch anywhere: the hang kill must hold up on the full definition of the budget
                # FL-50: the quick budget is only a filter. On the full budget max(100 x the original's instructions, CONFIRM_FLOOR) a mutant that finishes
                # (a 16-bit loop counter that wraps after about 65,000 turns) and differs from the original is killed by that difference, not by a hang.
                for it in over:
                    found, hung = scan(k, [it], floor=CONFIRM_FLOOR)
                    if found and not hung:
                        return items.index(it)
                found, hung = scan(k, [first_hit], floor=CONFIRM_FLOOR)
                if hung and end_kind[0] == 'budget':
                    budget_hit.add(k)
            return None

        dropped = [0]
        budget_hit = set()      # FL-46: mutants that went over the step budget on a scenario and are not killed by a mismatch
        hangs = []          # mutants killed by a hang or crash (a scenario over its 10 s alarm); logged, and the port itself ran the same scenarios inside the same alarm
        reference = guard(reference, 'corpus')
        for k, (kind, n, _) in enumerate(muts):
            hit = first_mismatch(k, reference)
            dead = hit is not None
            if not dead:
                if extra is None:
                    extra = []
                    for sd in EXTRA_SEEDS:
                        t = safe_original(row, sd)
                        if t is not None and not t.fault:
                            extra.append((sd, (), dig(t)))
                    extra = guard(extra, 'extra')
                hit = first_mismatch(k, extra)
                if hit is not None:
                    if harden:
                        killers.add(extra[hit][0])
                    survivors.append((kind, n, 'killed only by an extra seed'))
                    killed += 1
                    continue
            if dead:
                killed += 1
            else:
                if rescue:
                    hit = None
                    for stage in range(len(rescue['stages'])):        # new seeds in growing batches: most killable mutants die in the first
                        while len(fresh_by_stage) <= stage:
                            fresh_by_stage.append(guard([(sd, (), dig(t)) for sd in rescue['stages'][len(fresh_by_stage)] for t in [safe_original(row, sd)] if t is not None and not t.fault], 'rescue'))
                        hit = first_mismatch(k, fresh_by_stage[stage])
                        if hit is not None:
                            killers.add(fresh_by_stage[stage][hit][0])
                            break
                    if hit is not None:
                        killed += 1
                        survivors.append((kind, n, 'killed by rescue seed'))
                    else:
                        survivors.append((kind, n, 'killed by step budget' if k in budget_hit else 'survives'))
                        mutant_survivors.append((k, kind, n))
                    continue
                if harden:
                    if wide is None:
                        wide = guard([(sd, (), dig(t)) for sd in list(range(6000, 6000 + WIDE)) + list(range(W.HI_SEEDS, W.HI_SEEDS + WIDE)) + list(range(W.TGT_SEEDS, W.TGT_SEEDS + WIDE)) for t in [safe_original(row, sd)] if t is not None and not t.fault], 'wide')
                    hit = first_mismatch(k, wide)
                    if hit is not None:
                        killers.add(wide[hit][0])
                        killed += 1
                        survivors.append((kind, n, 'killed by hardening seed'))
                        continue
                survivors.append((kind, n, 'killed by step budget' if k in budget_hit else 'survives'))
                mutant_survivors.append((k, kind, n))
        return key, {'mutants': len(muts), 'killed': killed, 'survivors': survivors, 'killers': sorted(killers), 'mutant_survivors': mutant_survivors, 'mutant_texts': {k: muts[k][2] for k, _, _ in mutant_survivors} if os.environ.get('FL49_DETAIL') else {}, 'guard_dropped': dropped[0], 'hang_kills': len(set(hangs)), 'budget_kills': len(budget_hit)}


class Shim:
    """Looks like the ctypes library but maps `m<va>_lifted` to the k-th mutant symbol."""

    def __init__(self, lib, va, k):
        self.lib, self.name = lib, ('m%x_lifted' % va) if k is None else 'm%x_mut%d' % (va, k)

    def __getattr__(self, name):
        return getattr(self.lib, self.name)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rows')
    ap.add_argument('--per-row', type=int, default=30)
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--rescue', help='FL-42: a survivors file; retry only the mutants it lists as surviving, against --seeds new seeds (the extra and hardening ones are skipped)')
    ap.add_argument('--seeds', type=int, default=1500)
    ap.add_argument('--base', type=int, default=W.TGT_SEEDS, help='first rescue seed (default 20000; 40000 adds boundary-value styles to the callees\' results)')
    ap.add_argument('--harden', action='store_true', help='add to the corpus a seed that kills each survivor, where one of 300 more seeds does')
    ap.add_argument('--corpus', help='read and write this copy of the corpus instead of tests/fl40_corpus.json (two runs at once must not share one file; merge the seeds afterwards)')
    ap.add_argument('--window', help='lo:hi, only the picked mutants lo..hi-1 of each row')
    a = ap.parse_args()
    global WINDOW, CORPUS
    if a.corpus:
        CORPUS = Path(a.corpus)
    WINDOW = tuple(int(x) for x in a.window.split(':')) if a.window else None
    corpus = json.loads(CORPUS.read_text())
    funcs = split_functions(SOURCE.read_text())
    helper = funcs.get('0x50c920', '')
    keys = a.rows.split(',') if a.rows else sorted(corpus, key=lambda k: int(k, 16))
    rescue = {}
    if a.rescue:        # a survivors file of scripts/fl40_survivors.py: the unexplained survivors of its rows
        for row, items in json.loads(Path(a.rescue).read_text())['rows_with_survivors'].items():
            only = {(kind, n) for kind, cls, _, n in items if cls is None}
            if only:
                rescue[row] = {'only': only}
        keys = [k for k in keys if k in rescue]
        stages, lo = [], a.base
        for size in (60, 240, a.seeds):
            stages.append(list(range(lo, lo + size)) + list(range(7300 + lo - a.base, 7300 + lo - a.base + size // 6)))
            lo += size
        for v in rescue.values():
            v['stages'] = stages
    work = [(k, corpus[k], funcs[k], helper if 'FL40_CALL_LIFTED' in funcs[k] else '', a.per_row, a.harden or bool(a.rescue), rescue.get(k)) for k in keys]
    total = killed = 0
    bad = []
    with mp.Pool(a.jobs, maxtasksperchild=1) as pool:        # a fresh process per row: the emulator instances of a long run add up
        for key, res in pool.imap_unordered(check_row, work):
            if 'error' in res:
                print('%s COMPILE ERROR %s' % (key, res['error']))
                bad.append(key)
                continue
            if res['killers']:
                corpus[key]['seeds'].extend([sd, []] for sd in res['killers'])
                if a.harden or a.rescue:        # kept as it goes: a long run that dies still leaves its seeds
                    CORPUS.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
            total += res['mutants']
            killed += res['killed']
            hard = [s for s in res['survivors'] if s[2] == 'survives']
            if os.environ.get('FL49_DETAIL'):        # FL-49: the surviving mutants one by one: DETAIL <row> [[index, kind, line, original line, mutant line], ...]
                orig = funcs[key].split('\n')
                print('DETAIL %s %s' % (key, json.dumps([[k, kind, n, orig[n].strip(), res['mutant_texts'][k].split('\n')[n].strip()] for k, kind, n in res['mutant_survivors']])), flush=True)
            print('%s mutants %d killed %d survivors %s%s' % (key, res['mutants'], res['killed'], res['survivors'], ((' guard-dropped-scenarios %d' % res['guard_dropped']) if res['guard_dropped'] else '') + ((' hang-kills %d' % res['hang_kills']) if res['hang_kills'] else '') + ((' budget-kills %d' % res['budget_kills']) if res['budget_kills'] else '')), flush=True)
            if hard:
                bad.append(key)
    if a.harden or a.rescue:
        CORPUS.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    print('TOTAL mutants %d killed %d rows with a survivor %d' % (total, killed, len(bad)))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
