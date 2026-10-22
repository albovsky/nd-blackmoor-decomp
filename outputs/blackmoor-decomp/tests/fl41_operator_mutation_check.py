#!/usr/bin/env python3
"""FL-41 operator-level mutation check for machine-translated (lifted) batches.

usage (from outputs/blackmoor-decomp):  python3 tests/fl41_operator_mutation_check.py <batch> [--worker K --workers N] [--out FILE] [--only 0x4a1e93,...]
         python3 tests/fl41_operator_mutation_check.py <batch> --list      (site counts per function)

<batch> is the batch id, e.g. fl39d: the source is src/original_methods_<batch>.c, the tests are tests/test_<batch>_direct.py (build() and EXPECTED) and
tests/test_<batch>_differential.py.

FL-39 batch d sampled up to three mutants per function and did not mutate the arithmetic and comparison instructions of the lifted code. This check
mutates every site of the operators listed below (not `*`, not `?:`) in every lifted function, one mutation per function per round (a mutation is local to one function body, so the per-function
test results tell them apart), rebuilds and reruns the direct test binary and the Unicorn differential test:

  arithmetic  + - & | ^ << >>   (sub<->add, and<->or, xor->or, shl<->shr)
  compare     == != < > <= >=   (each to its negation)
  signedness  (int8_t/int16_t/int32_t) <-> the unsigned cast (movsx <-> movzx)
  constants   every integer literal ^ 1 (shift counts and masks included)

A mutant is KILLED when the direct test result of its function is FAIL or the differential test of its function fails (or the program crashes or hangs).
Survivors are classified afterwards (`--classify F1,F2` compiles each function alone with gcc -O2 -S): gcc -O2 code identical to the original port means dead or masked code.
Builds that fail (warnings are errors) are bisected down to the single mutation. A worker runs in its own copy of the tree and restores the source file.
"""
import importlib
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))

BINOPS = [(' + ', ' - '), (' - ', ' + '), (' & ', ' | '), (' | ', ' & '), (' ^ ', ' | '), (' << ', ' >> '), (' >> ', ' << '),
          (' == ', ' != '), (' != ', ' == '), (' < ', ' >= '), (' > ', ' <= '), (' <= ', ' > '), (' >= ', ' < ')]
CASTS = [('(int8_t)', '(uint8_t)'), ('(int16_t)', '(uint16_t)'), ('(int32_t)', '(uint32_t)'), ('(uint8_t)', '(int8_t)'), ('(uint16_t)', '(int16_t)')]
OPT = '-O0'          # the first pass builds the direct binary unoptimised (1.7 s instead of 25 s); --opt -O2 repeats a pass as the tests build it
LITERAL = re.compile(r'(?<![\w.])(0x[0-9a-fA-F]+|[0-9]+)(u|U)?(?![\w.])')


def function_blocks(text):
    """[(va, start, end)] of the lifted function bodies: from the `/* ---- 0x.. lifted ---- */` marker to the closing brace at the start of a line."""
    out = []
    for m in re.finditer(r'/\* ---- 0x([0-9a-f]+) lifted ---- \*/\n', text):
        end = text.index('\n}\n', m.end()) + 3
        out.append((m.group(1), m.start(), end))
    return out


def code_lines(text, a, b):
    """[(offset of the line, line)] of the executable statements of the function text[a:b]: after the first `/* 0x` address comment, no comments, labels or (void) lines."""
    first = text.index('\n    /* 0x', a)
    out, pos = [], first
    for line in text[first:b].split('\n'):
        stripped = line.strip()
        if stripped and not stripped.startswith('/*') and not stripped.startswith('(void)') and not stripped.endswith(':;') and not stripped.startswith('uintptr_t') \
                and stripped != '}' and not stripped.startswith('uint32_t fa') and not stripped.startswith('goto'):
            out.append((pos, line))
        pos += len(line) + 1
    return out


def sites(text, a, b):
    """[(start, end, replacement, label)] of the operator mutations of the function text[a:b], in source order."""
    out = []
    for pos, line in code_lines(text, a, b):
        code = re.sub(r'/\*.*?\*/', lambda m: ' ' * len(m.group(0)), line)
        for old, new in BINOPS:
            i = code.find(old)
            while i >= 0:
                # `<` / `>` must not be the start of a shift or part of a longer operator already listed
                if old.strip() in ('<', '>') and (code[i:i + 3] in (' <<', ' >>') or code[i + 1:i + 3] in ('<<', '>>')):
                    pass
                else:
                    out.append((pos + i, pos + i + len(old), new, 'op %s -> %s' % (old.strip(), new.strip())))
                i = code.find(old, i + 1)
        for old, new in CASTS:
            i = code.find(old)
            while i >= 0:
                out.append((pos + i, pos + i + len(old), new, 'cast %s -> %s' % (old.strip('()'), new.strip('()'))))
                i = code.find(old, i + 1)
        for m in LITERAL.finditer(code):
            lit = m.group(0)
            if code[:m.start()].rstrip().endswith('world->') or code[max(0, m.start() - 6):m.start()].endswith('value_') or lit.lower().startswith('0xffffffff'):
                continue      # field names, and the 32-bit width mask of the lifter (a no-op on a uint32_t)
            kind = 'literal'
            if line.strip().startswith('fb ='):
                kind = 'cmpconst'          # the constant operand of a cmp / test
            elif line.strip().startswith('fa =') and re.search(r'[-+] ', code[:m.start()][-6:]):
                kind = 'aluimm'            # the immediate of an add / sub
            out.append((pos + m.start(), pos + m.end(), '(%s ^ 1u)' % lit.rstrip('uU'), '%s %s ^ 1' % (kind, lit)))
    out.sort()
    # drop overlapping sites (a literal inside a cast pair cannot overlap, but ops and literals can share a span)
    keep, last = [], -1
    for s in out:
        if s[0] >= last:
            keep.append(s)
            last = s[1]
    return keep


class Batch:
    def __init__(self, name, kinds=('op', 'cast', 'literal', 'cmpconst', 'aluimm')):
        self.name = name
        self.src = PROJECT / ('src/original_methods_%s.c' % name)
        self.direct = importlib.import_module('test_%s_direct' % name)
        self.original = self.src.read_text()
        self.blocks = function_blocks(self.original)
        self.sites = {va: [x for x in sites(self.original, a, b) if x[3].split()[0] in kinds] for va, a, b in self.blocks}
        self.span = {va: (a, b) for va, a, b in self.blocks}

    def mutate(self, group):
        """Source text with the mutations of `group` = [(va, site index)] applied (at most one per function)."""
        edits = sorted(((self.sites[va][i][0], self.sites[va][i][1], self.sites[va][i][2]) for va, i in group), reverse=True)
        text = self.original
        for s, e, new in edits:
            text = text[:s] + new + text[e:]
        return text

    def run_direct(self):
        """('ok', {test name: 'PASS'/'FAIL'}, None) or ('build', stderr, None) or ('hang'|'crash', partial results, first expected case that did not report)."""
        with tempfile.TemporaryDirectory() as d:
            binary = Path(d) / 'direct'
            built = self.direct.build(binary, extra=(OPT, '-Wno-error'))
            if built.returncode != 0:
                return 'build', built.stderr[-600:], None
            status, text = 'ok', ''
            try:
                done = subprocess.run(['stdbuf', '-oL', str(binary)], capture_output=True, text=True, timeout=8)
                text = done.stdout
                if done.returncode < 0:
                    status = 'crash'
            except subprocess.TimeoutExpired as e:
                status, text = 'hang', (e.stdout or b'').decode() if isinstance(e.stdout, bytes) else (e.stdout or '')
        res = {}
        for line in text.splitlines():
            st, _, rest = line.partition(' ')
            if st in ('PASS', 'FAIL'):
                res[rest.partition(': ')[0]] = st
        culprit = next((n for n in self.direct.EXPECTED if n not in res), None)
        return status, res, culprit

    def run_differential(self):
        """('ok', info, None), or ('hang'|'crash', info, va of the test that was running)."""
        with tempfile.TemporaryDirectory() as d:
            progress = Path(d) / 'progress'
            code = ('import sys,json,unittest\nsys.path.insert(0,"tests")\n'
                    'class R(unittest.TestResult):\n    def startTest(self, t):\n        super().startTest(t)\n        open(%r, "a").write(t.id() + "\\n")\n'
                    'suite=unittest.defaultTestLoader.loadTestsFromName("tests.test_%s_differential")\nres=R()\nsuite.run(res)\n'
                    'print("RESULT",json.dumps({"fail":sorted(set(t.id() for t,_ in res.failures+res.errors)),"skipped":len(res.skipped),"run":res.testsRun,'
                    '"build":[m[-300:] for t,m in res.errors if "setUpClass" in t.id()]}))\n' % (str(progress), self.name))
            status, out = 'ok', ''
            try:
                done = subprocess.run([sys.executable, '-c', code], capture_output=True, text=True, cwd=PROJECT, timeout=150)
                out = done.stdout
                if done.returncode != 0:
                    status = 'crash'
            except subprocess.TimeoutExpired:
                status = 'hang'
            last = progress.read_text().split() if progress.exists() else []
            culprit = None
            if last:
                m = re.search(r'test_([0-9a-f]+)_', last[-1])
                culprit = m.group(1) if m else None
        lines = [l for l in out.splitlines() if l.startswith('RESULT ')]
        if status == 'ok' and lines:
            return 'ok', json.loads(lines[-1][7:]), None
        return (status if status != 'ok' else 'crash'), {}, culprit


def evaluate(batch, group, log):
    """Runs the group; returns {va: ('killed'|'survived'|'build-failed', by)}. A function whose case hangs or crashes is killed ('hang'/'crash') and
    taken out of the group, then the rest is rerun; builds that fail are bisected to the single mutation."""
    out, group = {}, list(group)
    while group:
        batch.src.write_text(batch.mutate(group))
        status, direct, culprit = batch.run_direct()
        if status == 'build':
            return {**out, **bisect(batch, group, log, 'build-failed', direct)}
        gvas = {va for va, _ in group}
        if status in ('hang', 'crash'):
            va = re.match(r'test_m([0-9a-f]+)_', culprit or '')
            va = va.group(1) if va else None
            if va in gvas:
                out[va] = ('killed', 'direct-' + status)
                group = [g for g in group if g[0] != va]
                continue
            return {**out, **bisect(batch, group, log, None, None)}
        dstatus, diff, dva = batch.run_differential()
        if dstatus != 'ok':
            if dva in gvas:
                out[dva] = ('killed', 'differential-' + dstatus)
                group = [g for g in group if g[0] != dva]
                continue
            return {**out, **bisect(batch, group, log, None, None)}
        if diff['build']:
            return {**out, **bisect(batch, group, log, 'build-failed', diff['build'][0])}
        if diff['skipped']:
            raise SystemExit('differential tests skipped: the oracle is not available')
        failed = {m.group(1) for f in diff['fail'] for m in [re.search(r'test_([0-9a-f]+)_', f)] if m}
        for va, _ in group:
            name = [n for n in batch.direct.EXPECTED if n.startswith('test_m%s_' % va)]
            dr = direct.get(name[0]) if name else None
            d_killed, f_killed = dr == 'FAIL', va in failed
            by = '+'.join(k for k, v in (('direct', d_killed), ('differential', f_killed)) if v)
            out[va] = ('killed', by) if (d_killed or f_killed) else ('survived', by)
        return out
    return out


def bisect(batch, group, log, final, detail):
    if len(group) == 1:
        if final:
            log('  %s: %s' % (group[0][0], (detail or '')[:200].replace('\n', ' ')))
            return {group[0][0]: (final, str(detail)[:200])}
        return {group[0][0]: ('killed', 'crash-or-hang')}
    half = len(group) // 2
    out = evaluate(batch, group[:half], log)
    out.update(evaluate(batch, group[half:], log))
    return out


def classify(batch, results, cc='gcc'):
    """For every survivor of `results` ({va: {'survivors': [...]}}): compiles the function alone with `cc -O2 -S` from the original and from the mutant and
    compares the instructions. Returns {va: [{..., 'o2': 'identical'|'differs'}]}. Identical code means the mutation is dead or masked."""
    first = batch.original.index('/* ---- 0x')
    preamble = batch.original[:first]
    out = {}
    with tempfile.TemporaryDirectory() as d:
        def asm(text, tag):
            c, sfile = Path(d) / (tag + '.c'), Path(d) / (tag + '.s')
            c.write_text(text)
            done = subprocess.run([cc, '-std=c11', '-O2', '-ffp-contract=off', '-S', '-I' + str(PROJECT / 'src'), str(c), '-o', str(sfile)], capture_output=True, text=True)
            if done.returncode != 0:
                return 'ERROR ' + done.stderr[-200:]
            return '\n'.join(l.strip() for l in sfile.read_text().splitlines() if not l.strip().startswith(('.file', '.ident', '.section', '.loc', '#')) and not l.strip().startswith('.L') or l.strip().startswith('.L') and l.strip().endswith(':'))
        for va, v in results.items():
            if not v['survivors']:
                continue
            a, b = batch.span[va]
            base = asm(preamble + batch.original[a:b], 'orig')
            rows = []
            for sv in v['survivors']:
                s0, e0, new, _ = batch.sites[va][sv['site']]
                text = batch.original[:s0] + new + batch.original[e0:]
                shift = len(new) - (e0 - s0)
                mutant = asm(preamble + text[a:b + shift], 'mut')
                rows.append({**sv, 'o2': 'identical' if mutant == base and not base.startswith('ERROR') else ('error' if mutant.startswith('ERROR') else 'differs')})
            out[va] = rows
    return out


def main():
    argv = sys.argv[1:]
    global OPT
    if '--opt' in argv:
        OPT = argv[argv.index('--opt') + 1]
    kinds = tuple(argv[argv.index('--kinds') + 1].split(',')) if '--kinds' in argv else ('op', 'cast', 'literal', 'cmpconst', 'aluimm')
    batch = Batch(argv[0], kinds)
    worker, workers, outfile, only, replay = 0, 1, None, None, None
    if '--worker' in argv:
        worker = int(argv[argv.index('--worker') + 1])
    if '--workers' in argv:
        workers = int(argv[argv.index('--workers') + 1])
    if '--out' in argv:
        outfile = argv[argv.index('--out') + 1]
    if '--only' in argv:
        only = {s.replace('0x', '') for s in argv[argv.index('--only') + 1].split(',')}
    vas = [va for va, _, _ in batch.blocks if only is None or va in only]
    if '--replay' in argv:      # rerun only the survivors of an earlier result file: {va: [sites]}
        prev = json.load(open(argv[argv.index('--replay') + 1]))
        replay = {va: [x['site'] for x in v['survivors']] for va, v in prev.items() if v['survivors']}
        vas = [va for va in vas if va in replay]
    if '--classify' in argv:
        merged = {}
        for f in argv[argv.index('--classify') + 1].split(','):
            for va, v in json.load(open(f)).items():
                m = merged.setdefault(va, {'sites': v['sites'], 'survivors': [], 'killed': 0, 'build_failed': []})
                m['survivors'] += v['survivors']
                m['killed'] += v['killed']
                m['build_failed'] += v['build_failed']
        res = classify(batch, merged)
        Path(outfile or 'classified.json').write_text(json.dumps(res, indent=1))
        print('survivors', sum(len(v) for v in res.values()), 'identical', sum(1 for v in res.values() for r in v if r['o2'] == 'identical'),
              'differs', sum(1 for v in res.values() for r in v if r['o2'] == 'differs'), 'error', sum(1 for v in res.values() for r in v if r['o2'] == 'error'))
        return
    if '--list' in argv:
        for va in vas:
            print('0x%s %d' % (va, len(batch.sites[va])))
        print('total', sum(len(batch.sites[va]) for va in vas), 'functions', len(vas), 'rounds', max(len(batch.sites[va]) for va in vas))
        return
    rounds = max(len(batch.sites[va]) for va in vas)
    results = {va: {'sites': len(batch.sites[va]), 'survivors': [], 'killed': 0, 'build_failed': []} for va in vas}
    try:
        for r in range(worker, rounds, workers):
            group = [(va, r) for va in vas if r < len(batch.sites[va]) and (not replay or r in replay[va])]
            if not group:
                continue
            out = evaluate(batch, group, print)
            alive = 0
            for va, i in group:
                status, by = out[va]
                label = batch.sites[va][i][3]
                line = batch.original.count('\n', 0, batch.sites[va][i][0]) + 1
                if status == 'killed':
                    results[va]['killed'] += 1
                elif status == 'survived':
                    alive += 1
                    results[va]['survivors'].append({'site': i, 'line': line, 'mutation': label, 'seen': by})
                else:
                    results[va]['build_failed'].append({'site': i, 'line': line, 'mutation': label, 'detail': by})
            print('round %d: mutants %d survivors %d' % (r, len(group), alive), flush=True)
            if outfile:
                Path(outfile).write_text(json.dumps(results, indent=1))
    finally:
        batch.src.write_text(batch.original)
    if outfile:
        Path(outfile).write_text(json.dumps(results, indent=1))


if __name__ == '__main__':
    main()
