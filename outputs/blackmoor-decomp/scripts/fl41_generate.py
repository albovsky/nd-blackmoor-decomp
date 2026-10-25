#!/usr/bin/env python3
"""FL-41: translate the pending game rows at or above 0x480000 that scripts/lift_fl41.py takes, search for the seeds that run every instruction and take both
directions of every conditional jump of the ORIGINAL bytes (Unicorn), check that the translation agrees with the original on each of them, and write

  src/original_methods_fl41.c   one `m<va>_lifted` per row whose seeds cover the whole function (rows that do not stay out and are listed)
  tests/fl41_corpus.json        per row: body size, callees (address -> bytes popped), the seeds, coverage counts

  fl41_generate.py [--rows 0x401000,0x401010,...] [--limit N] [--max-seeds 1500] [--jobs 4] [--out-dir DIR]

Run from outputs/blackmoor-decomp; needs Unicorn and the private work/original/GAME.EXE.
"""
from __future__ import annotations

import argparse
import json
import traceback
import multiprocessing as mp
from pathlib import Path
import sys
import tempfile
import time

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl28b_fixtures as F
import fl41_world as W
import lift_fl41 as L

# rows the coordinator keeps out of this pool (unreachable code, large or guarded loops, dispatchers, owner-ruling rows)
EXCLUDED = {0x4e0978, 0x4b5d17, 0x4cdfd3, 0x4fc62d, 0x4c334f, 0x4cf687, 0x4bf9bb, 0x4f0059, 0x4e45be, 0x4de2d8,
            # the 12 FL-39 batch d rows with an unexplained mutation survivor keep their ports in src/original_methods_fl39d.c (same symbol names)
            0x488e54, 0x4a1e93, 0x4a1fd1, 0x4b450f, 0x4ba262, 0x4d57e8, 0x4e023b, 0x4e06c0, 0x4e8d72, 0x4e94a9, 0x4ee572, 0x4fb1c6}

HEADER = '''/* FL-41: GAME.EXE functions at or above 0x480000, translated instruction by instruction by scripts/lift_fl41.py (see original_methods_fl41.h for the model).
 * GENERATED: regenerate with scripts/fl41_generate.py; do not edit by hand. Each symbol `m<va>_lifted` is the original function at <va>; the comment above
 * it gives the address and the size. These are machine translations: they carry no names and no restructuring of the original. */
#include "original_methods_fl41.h"

'''


def covers(row, executed, edges):
    total = W.od.instruction_addresses(row['va'], row['body'])
    missing = sorted(total - executed)
    dirs = 0
    taken = 0
    untaken = []
    for address, _, target, after in F.conditional_edges(row['va'], row['body']):
        dirs += 2
        for name, nxt in (('taken', target), ('fall-through', after)):
            if (address, nxt) in edges:
                taken += 1
            else:
                untaken.append((address, name))
    return len(total) - len(missing), len(total), taken, dirs, missing, untaken


def scenario_key(seed, overrides):
    return (seed, tuple(sorted(overrides)))


def jcc_cmp_addresses(row, untaken):
    """The compare/test instructions in front of the conditional jumps that still have an untaken direction."""
    import capstone
    pe = W.od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    off = row['va'] - pe.image_base
    ins = list(md.disasm(pe.image[off:off + row['body']], row['va']))
    want = {a for a, _ in untaken}
    out = set()
    for k, i in enumerate(ins):
        if i.address in want:
            for j in range(k - 1, max(-1, k - 7), -1):
                if ins[j].mnemonic in ('cmp', 'test'):
                    out.add(ins[j].address)
                    break
    return out


def children(row, o, overrides, untaken, rng):
    """Overrides that make a compare of this run come out the other way: the memory cells that fed the operands are set to the other operand (+-1)."""
    written = set()
    first_write = {}
    for k, (a, n, v) in enumerate(o.writes):
        for b in range(a, a + n):
            first_write.setdefault(b, k)
    inputs = []
    for a, n, v, wc in o.reads:
        if 0x401000 <= a < W.DATA_START or any(first_write.get(b, 1 << 30) < wc for b in range(a, a + n)):
            continue
        inputs.append((a, n, v))
    wanted = jcc_cmp_addresses(row, untaken)
    events = [e for e in o.events if e[0] in wanted] if wanted else []
    if not events or rng.random() < 0.3:
        events = o.events
    out = []
    for e in rng.sample(events, min(len(events), 6)):
        address, bits, a, b, ca, cb, wc = e
        mask = (1 << bits) - 1
        for value, other, cell in ((a, b, ca), (b, a, cb)):
            if cell and not any(first_write.get(x, 1 << 30) < wc for x in range(cell[0], cell[0] + cell[1])):
                cells = [cell]
            else:
                cells = [(x, n) for x, n, v in reversed(inputs) if n * 8 == bits and v == value][:2]
            for x, n in cells:
                for delta in (0, 1, -1):
                    new = (other + delta) & mask
                    if new != value:
                        out.append((x, n, new))
    if inputs and rng.random() < 0.5:
        x, n, v = rng.choice(inputs)
        out.append((x, n, rng.choice([0, 1, 2, 0xff, 0x7fffffff, 0x80000000, 0xffffffff, rng.getrandbits(32), rng.randrange(0x100)]) & ((1 << (8 * n)) - 1)))
    rng.shuffle(out)
    return out[:14]


def search(args):
    try:
        return search_row(args)
    except Exception as ex_:
        return args[0]['va'], {'status': 'error', 'detail': '%s: %s' % (type(ex_).__name__, str(ex_)[:300]), 'trace': traceback.format_exc()[-1200:]}


def search_row(args):
    import ctypes
    import random
    row, libpath, max_seeds, guided = args
    lib = ctypes.CDLL(libpath)
    ex, ed = set(), set()
    kept = []                     # (seed, overrides)
    tried = set()
    stats = {'faults': 0, 'runs': 0}

    def run(seed, overrides):
        o = W.run_original(row, seed, overrides)
        stats['runs'] += 1
        if o.fault:
            stats['faults'] += 1
            return None
        if len(row['ret']) != 1 or o.regs['esp'] != W.SP + 4 + row['ret'][0]:
            raise RuntimeError(('stack discipline: esp after the run is 0x%x, expected 0x%x for ret %s' % (o.regs['esp'], W.SP + 4 + (row['ret'] or [0])[0], row['ret'])))
        return o

    def consider(seed, overrides, o):
        nonlocal ex, ed
        if o.executed <= ex and o.edges <= ed:
            return False
        n = W.run_native(lib, row, seed, overrides)
        if n.fault or n.digest() != o.digest():
            raise RuntimeError(('mismatch', seed, overrides, (o.regs, o.writes[:6], o.calls[:2]), (n.regs, n.writes[:6], n.calls[:2], n.fault)))
        kept.append((seed, list(overrides)))
        ex |= o.executed
        ed |= o.edges
        return True

    def full():
        a, b, c, d, missing, untaken = covers(row, ex, ed)
        return a == b and c == d

    try:
        seeds = range(max_seeds)
        if row.get('fpu'):          # FL-52: a row that uses the x87 unit is also searched with the float seeds (style 7), alternately with the plain ones
            seeds = [s for pair in zip(range(max_seeds), range(W.FLOAT_SEEDS, W.FLOAT_SEEDS + max_seeds)) for s in pair]
        for seed in seeds:
            o = run(seed, ())
            if o is not None and consider(seed, (), o) and full():
                break
        if not full() and kept:
            rng = random.Random(row['va'])
            budget = guided
            queue = list(kept)
            qi = 0
            while budget > 0 and not full():
                seed, overrides = queue[qi % len(queue)]
                qi += 1
                o = W.run_original(row, seed, overrides, observe=True)
                budget -= 1
                if o.fault:
                    continue
                untaken = covers(row, ex, ed)[5]
                for cell in children(row, o, overrides, untaken, rng):
                    merged = {(a, n): v for a, n, v in overrides}
                    merged[(cell[0], cell[1])] = cell[2]
                    new = tuple(sorted((a, n, v) for (a, n), v in merged.items()))
                    key = scenario_key(seed, new)
                    if key in tried:
                        continue
                    tried.add(key)
                    c = run(seed, new)
                    budget -= 1
                    if c is not None and consider(seed, new, c):
                        queue.append((seed, list(new)))
                        if full():
                            break
    except RuntimeError as ex_:
        return row['va'], {'status': 'mismatch', 'detail': repr(ex_.args)[:1500]}
    a, b, c, d, missing, untaken = covers(row, ex, ed)
    return row['va'], {'status': 'complete' if (a == b and c == d) else 'incomplete', 'seeds': kept, 'instructions': [a, b], 'directions': [c, d],
                       'missing': [hex(x) for x in missing][:8], 'untaken': [(hex(x), n) for x, n in untaken][:8], 'tried': stats['runs'], 'faults': stats['faults']}


TEST_HEAD = '''"""FL-41 differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl41.c on the seeds of tests/fl41_corpus.json (tests/fl41_world.py builds the world).

GENERATED by scripts/fl41_generate.py (one test per translated row). Every test runs each seed of its row on the original and on the translation and compares the final
registers (the callee-saved ones and esp included), every write of the function in order (the stack included) and the ordered stub calls with what they returned and
stored. It also requires that the seeds together run every instruction of the original function and take both directions of every conditional jump of it
(there is no allowlist). `test_source_is_what_the_lifter_writes` regenerates every translation from GAME.EXE and requires the committed text.
"""
import json
from pathlib import Path
import platform
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import original_differential as od
import fl28b_fixtures as F
import fl41_world as W

PROJECT = Path(__file__).resolve().parents[1]
CORPUS = json.loads((Path(__file__).resolve().parent / 'fl41_corpus.json').read_text())
X87_HOST = platform.machine().lower() in ('x86_64', 'amd64', 'i386', 'i686')       # FL-52: the x87 model of the rows that use the FPU runs on the host's own unit


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl41Differential(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        cls.lib = W.build_library(cls.directory.name)

    def check_row(self, key, symbol):
        self.assertTrue(hasattr(self.lib, symbol), symbol)
        c = CORPUS[key]
        va = int(key, 16)
        row = W.row_info(va, c['body'], {int(k, 16): v for k, v in c['callees'].items()}, {int(k, 16): v for k, v in c['imports'].items()}, c['fs'])
        if row.get('fpu') and not X87_HOST:
            self.skipTest('the x87 model of %s is bit-exact only on an x86 host' % key)
        executed, edges = set(), set()
        for seed, overrides in c['seeds']:
            overrides = [tuple(o) for o in overrides]
            original = W.run_original(row, seed, overrides)
            self.assertIsNone(original.fault)
            native = W.run_native(self.lib, row, seed, overrides)
            self.assertIsNone(native.fault)
            self.assertEqual(original.regs, native.regs, 'registers, seed %d' % seed)
            self.assertEqual(original.writes, native.writes, 'writes, seed %d' % seed)
            self.assertEqual(original.calls, native.calls, 'calls, seed %d' % seed)
            executed |= original.executed
            edges |= original.edges
        self.assertEqual(sorted(od.instruction_addresses(va, c['body']) - executed), [], 'instructions never run')
        for address, _, target, after in F.conditional_edges(va, c['body']):
            self.assertIn((address, target), edges, 'taken direction of 0x%x' % address)
            self.assertIn((address, after), edges, 'fall-through direction of 0x%x' % address)

    def test_source_is_what_the_lifter_writes(self):
        import lift_fl41 as L
        spans = L.ledger_spans()
        text = (PROJECT / 'src/original_methods_fl41.c').read_text()
        for key in CORPUS:
            va = int(key, 16)
            self.assertIn(L.lift(va, spans[va])[0], text, key)

'''


def test_source(complete):
    out = [TEST_HEAD]
    for v in complete:
        out.append("    def test_%x_lifted(self):\n        self.check_row('0x%x', 'm%x_lifted')\n\n" % (v, v, v))
    return ''.join(out).rstrip('\n') + '\n\n\nif __name__ == "__main__":\n    unittest.main()\n'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rows')
    ap.add_argument('--limit', type=int)
    ap.add_argument('--max-seeds', type=int, default=300)
    ap.add_argument('--guided', type=int, default=1500)
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--out-dir', default=str(PROJECT))
    ap.add_argument('--cache', help='JSON file with the finished searches: rows in it are not searched again, every finished row is added to it')
    a = ap.parse_args()
    spans = L.ledger_spans()
    if a.rows:
        vas = [int(v, 16) for v in a.rows.split(',')]
    else:
        ok, _ = L.census()
        vas = [int(v, 16) for v in ok if int(v, 16) not in EXCLUDED]
    if a.limit:
        vas = vas[:a.limit]
    texts, rows = {}, {}
    uses_inline = False
    for va in vas:
        text, callees, imports, fs, inline = L.lift(va, spans[va])
        uses_inline |= bool(inline)
        texts[va] = text
        rows[va] = W.row_info(va, spans[va], callees, imports, fs)
    tmp = tempfile.mkdtemp()
    src = Path(tmp) / 'all.c'
    helper = L.lift(0x50c920, spans[0x50c920])[0] if uses_inline else ''
    src.write_text('#include "original_methods_fl41.h"\n' + helper + '\n'.join(texts[v] for v in vas))
    lib = W.build_library(tmp, [src])
    libpath = str(Path(tmp) / 'fl41.so')
    t0 = time.time()
    results = {}
    cache_path = Path(a.cache) if a.cache else None
    if cache_path is not None and cache_path.is_file():
        results = {int(k, 16): v for k, v in json.loads(cache_path.read_text()).items()}
    todo = [v for v in vas if v not in results or results[v]['status'] == 'error']
    with mp.Pool(a.jobs, maxtasksperchild=1) as pool:
        for k, (va, res) in enumerate(pool.imap_unordered(search, [(rows[v], libpath, a.max_seeds, a.guided) for v in todo])):
            results[va] = res
            if cache_path is not None:
                cache_path.write_text(json.dumps({hex(x): y for x, y in results.items()}))
            print('%d/%d 0x%x %s %s' % (k + 1, len(todo), va, res['status'], {x: res[x] for x in ('instructions', 'directions', 'tried') if x in res}), flush=True)
    complete = [v for v in vas if results[v]['status'] == 'complete']
    out = Path(a.out_dir)
    helper = L.lift(0x50c920, spans[0x50c920])[0] if any('FL41_CALL_LIFTED' in texts[v] for v in complete) else ''
    (out / 'src/original_methods_fl41.c').write_text(HEADER + helper + '\n'.join(texts[v] for v in complete))
    corpus = {'0x%x' % v: {'body': rows[v]['body'], 'callees': {hex(k): n for k, n in rows[v]['callees'].items()},
                           'imports': {hex(k): n for k, n in rows[v]['imports'].items()}, 'fs': rows[v]['fs'],
                           'seeds': [[sd, [list(o) for o in ov]] for sd, ov in results[v]['seeds']], 'instructions': results[v]['instructions'], 'directions': results[v]['directions']} for v in complete}
    (out / 'tests/fl41_corpus.json').write_text(json.dumps(corpus, indent=1, sort_keys=True) + '\n')
    (out / 'tests/test_fl41_differential.py').write_text(test_source(complete))
    rest = {'0x%x' % v: results[v] for v in vas if v not in complete}
    (out / 'tests/fl41_pending.json').write_text(json.dumps(rest, indent=1, sort_keys=True) + '\n')
    print('complete %d, not complete %d, %.0f s' % (len(complete), len(rest), time.time() - t0))


if __name__ == '__main__':
    main()
