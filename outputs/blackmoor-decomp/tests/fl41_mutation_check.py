#!/usr/bin/env python3
"""FL-41 mutation check: do the seeds of tests/fl41_corpus.json tell the translation of a row from a slightly wrong one?

For each row it takes the committed C of `m<va>_lifted` (src/original_methods_fl41.c) and makes mutants by hand-rolled operators on single lines of it:
  jump       a conditional jump goes the other way (`if (c) goto` becomes `if (!(c)) goto`)
  literal    one numeric literal of a statement changes by one (a constant, a displacement, a carry-in, a shift count)
  alu        an add becomes a subtract and the other way round
  width      a memory access gets another width (RD32 <-> RD16 <-> RD8, WR32 <-> WR16 <-> WR8)
  register   the source register of a move or a push is another register
  drop       a stack adjustment, a store or a register update statement is removed
A mutant is killed when the translation of the mutant differs from the ORIGINAL bytes' recorded behaviour (final registers, ordered writes, ordered stub calls) on
any seed of the row. A survivor is retried on 40 more seeds that are not in the corpus (WIDE more with --harden); one that still survives is listed (it may be an equivalent mutant: a
statement whose effect no seed can see, such as the flags of an instruction whose flags nothing reads).

  fl41_mutation_check.py [--rows 0x401000,...] [--per-row 30] [--jobs 4]      (run from outputs/blackmoor-decomp)

Prints one line per row (mutants, killed, survivors) and a total; exits 1 when a survivor remains after the extra seeds.
"""
import argparse
import json
import multiprocessing as mp
import os
import signal
from pathlib import Path
import random
import re
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import fl41_world as W

PROJECT = HERE.parent
SOURCE = PROJECT / 'src/original_methods_fl41.c'
CORPUS = HERE / 'fl41_corpus.json'
REGS = ['eax', 'ecx', 'edx', 'ebx', 'esi', 'edi']
EXTRA_SEEDS = range(5000, 5040)
WIDE = 600          # --harden: seeds tried on a survivor after the extra ones


def split_functions(text):
    parts = re.split(r'(?=/\* GAME\.EXE 0x[0-9a-f]+ \()', text)
    out = {}
    for part in parts:
        m = re.match(r'/\* GAME\.EXE (0x[0-9a-f]+) \(', part)
        if m:
            out[m.group(1)] = part
    return out


COMMENT = re.compile(r'^(.*?)(\s*/\* 0x[0-9a-f]+: .*\*/)?$')


def mutants(text, va, rng, limit):
    lines = text.split('\n')
    found = []
    for n, line in enumerate(lines):
        code, comment = COMMENT.match(line).groups()
        comment = comment or ''
        if not code.strip() or code.strip() in ('{', '}') or code.strip().startswith(('/*', 'void ', 'FL41_', 'done:', 'L_', 'while', 'switch', 'case', 'default', 'break')):
            continue

        def add(kind, new_code):
            found.append((kind, n, new_code + comment))
        m = re.match(r'^(\s*)if \((.*)\) goto (L_[0-9a-f]+);\s*$', code)
        if m:
            add('jump', '%sif (!(%s)) goto %s;' % (m.group(1), m.group(2), m.group(3)))
            continue
        if 'goto' in code or 'case ' in code or 'switch' in code:
            continue
        if 'FL41_ADD(' in code:
            add('alu', code.replace('FL41_ADD(', 'FL41_SUB('))
        if 'FL41_SUB(' in code:
            add('alu', code.replace('FL41_SUB(', 'FL41_ADD('))
        for old, new in (('FL41_SHL(', 'FL41_SHR('), ('FL41_SHR(', 'FL41_SAR('), ('FL41_SAR(', 'FL41_SHR('), ('FL41_ROL(', 'FL41_ROR('), ('FL41_ROR(', 'FL41_ROL(')):
            if old in code:
                add('alu', code.replace(old, new, 1))
        if re.search(r'FL41_(ADD|SUB)\(a_, b_, ([01])u,', code):
            add('literal', re.sub(r'(FL41_(?:ADD|SUB)\(a_, b_, )([01])u,', lambda m: '%s%du,' % (m.group(1), 1 - int(m.group(2))), code, count=1))
        if 'FL41_SUB(' in code and 'a_ = ' in code and 'b_ = ' in code:        # the other operators of a block are commutative: swapping them is no mutant
            add('register', re.sub(r'a_ = ([^,]+), b_ = ([^,;]+),', r'a_ = \2, b_ = \1,', code, count=1))
        if 'FL41_CALL' not in code:
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
        if 'FL41_CALL' not in code:
            add('drop', re.sub(r'\S.*$', ';', code))
        for lit in re.finditer(r'0x([0-9a-f]+)u', code):
            if 'FL41_CALL' in code or 'esp, 0x' in code or lit.start() == 0:
                continue
            v = int(lit.group(1), 16)
            add('literal', code[:lit.start()] + '0x%xu' % ((v + 1) & 0xffffffff) + code[lit.end():])
            break
        m = re.search(r'esp \+= (\d+)u;', code)
        if m and 'FL41_CALL' in code and int(m.group(1)) > 4:
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
    for kind, n, replacement in picked:
        mutated = list(lines)
        mutated[n] = replacement
        text2 = '\n'.join(mutated).replace('m%x_lifted' % va, 'm%x_mut%d' % (va, len(out)), 1)
        out.append((kind, n, text2))
    return out


def check_row(args):
    try:
        return check_row_inner(args)
    except Exception as ex_:
        return args[0], {'error': '%s: %s' % (type(ex_).__name__, str(ex_)[:200])}


def check_row_inner(args):
    key, entry, text, helper, per_row, harden = args
    va = int(key, 16)
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    rng = random.Random(va)
    muts = mutants(text, va, rng, per_row)
    scenarios = [(sd, [tuple(o) for o in ov]) for sd, ov in entry['seeds']]
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / 'm.c'
        for _ in range(4):
            src.write_text('#include "original_methods_fl41.h"\n' + helper + '\n'.join(m[2] for m in muts))
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
        reference = [(sd, ov, W.run_original(row, sd, ov).digest()) for sd, ov in scenarios]
        extra = None
        wide = None
        killed, survivors, killers = 0, [], set()
        def first_mismatch(k, items):
            """Index of the first scenario on which mutant k differs from the recorded original, 'timeout' when it hangs, None when it agrees everywhere.
            Runs in a forked child with an alarm: a mutant that loops forever is dead."""
            r_fd, w_fd = os.pipe()
            pid = os.fork()
            if pid == 0:
                try:
                    signal.alarm(20)
                    os.close(r_fd)
                    found = -1
                    for i, (sd, ov, ref) in enumerate(items):
                        t = W.run_native(Shim(lib, va, k), row, sd, ov)
                        if (t.digest() if not t.fault else 'fault') != ref:
                            found = i
                            break
                    os.write(w_fd, str(found).encode())
                except Exception as exc:        # a harness bug is not a kill
                    os.write(w_fd, b'E' + repr(exc).encode()[:200])
                finally:
                    os._exit(0)
            os.close(w_fd)
            data = os.read(r_fd, 32)
            os.close(r_fd)
            _, status = os.waitpid(pid, 0)
            if data.startswith(b'E'):
                raise RuntimeError('mutation harness error on %s mutant %d: %s' % (key, k, data[1:].decode()))
            if not data:
                return 'timeout'          # the alarm, or the mutant crashed the process: the original does neither
            i = int(data)
            return None if i < 0 else i

        for k, (kind, n, _) in enumerate(muts):
            hit = first_mismatch(k, reference)
            dead = hit is not None
            if not dead:
                if extra is None:
                    extra = []
                    for sd in EXTRA_SEEDS:
                        t = W.run_original(row, sd)
                        if not t.fault:
                            extra.append((sd, (), t.digest()))
                hit = first_mismatch(k, extra)
                if hit is not None:
                    if harden and hit != 'timeout':
                        killers.add(extra[hit][0])
                    survivors.append((kind, n, 'killed only by an extra seed'))
                    killed += 1
                    continue
            if dead:
                killed += 1
            else:
                if harden:
                    if wide is None:
                        wide = [(sd, (), t.digest()) for sd in range(6000, 6000 + WIDE) for t in [W.run_original(row, sd)] if not t.fault]
                    hit = first_mismatch(k, wide)
                    if hit is not None:
                        if hit != 'timeout':
                            killers.add(wide[hit][0])
                        killed += 1
                        survivors.append((kind, n, 'killed by hardening seed'))
                        continue
                survivors.append((kind, n, 'survives'))
        return key, {'mutants': len(muts), 'killed': killed, 'survivors': survivors, 'killers': sorted(killers)}


class Shim:
    """Looks like the ctypes library but maps `m<va>_lifted` to the k-th mutant symbol."""

    def __init__(self, lib, va, k):
        self.lib, self.name = lib, 'm%x_mut%d' % (va, k)

    def __getattr__(self, name):
        return getattr(self.lib, self.name)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rows')
    ap.add_argument('--per-row', type=int, default=30)
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--harden', action='store_true', help='add to the corpus a seed that kills each survivor, where one of 300 more seeds does')
    a = ap.parse_args()
    corpus = json.loads(CORPUS.read_text())
    funcs = split_functions(SOURCE.read_text())
    helper = funcs.get('0x50c920', '')
    keys = a.rows.split(',') if a.rows else sorted(corpus, key=lambda k: int(k, 16))
    work = [(k, corpus[k], funcs[k], helper if 'FL41_CALL_LIFTED' in funcs[k] else '', a.per_row, a.harden) for k in keys]
    total = killed = 0
    bad = []
    with mp.Pool(a.jobs, maxtasksperchild=1) as pool:
        for key, res in pool.imap_unordered(check_row, work):
            if 'error' in res:
                print('%s COMPILE ERROR %s' % (key, res['error']))
                bad.append(key)
                continue
            if res['killers']:
                corpus[key]['seeds'].extend([sd, []] for sd in res['killers'])
            total += res['mutants']
            killed += res['killed']
            hard = [s for s in res['survivors'] if s[2] == 'survives']
            print('%s mutants %d killed %d survivors %s' % (key, res['mutants'], res['killed'], res['survivors']), flush=True)
            if a.harden and res['killers']:
                CORPUS.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
            if hard:
                bad.append(key)
    if a.harden:
        CORPUS.write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    print('TOTAL mutants %d killed %d rows with a survivor %d' % (total, killed, len(bad)))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
