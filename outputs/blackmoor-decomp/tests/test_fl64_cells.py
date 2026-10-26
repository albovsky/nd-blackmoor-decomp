#!/usr/bin/env python3
"""FL-64 soundness test of scripts/fl64_cells.py: run the ORIGINAL bytes of every corpus row (tests/fl40_corpus.json and tests/fl41_corpus.json) under Unicorn on corpus seeds and check, before every
executed instruction, that the registers and the value read by its memory operand lie in the sets the exploration found for that instruction. Concrete members must contain the real value; symbolic
members (a start register, an argument slot plus a constant) are compared with the start values recorded at the first instruction. Rows the engine refuses or abandons are skipped.

  python3 tests/test_fl64_cells.py [--world 40|41] [--rows 0x4f6810,...] [--seeds 6]          (run from outputs/blackmoor-decomp; also a unittest on a few rows)
"""
import argparse
import json
from pathlib import Path
import sys
import unittest

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl43_equiv as E
import fl64_cells as C
from unicorn import x86_const as UX

REG_IDS = {n: getattr(UX, 'UC_X86_REG_' + n.upper()) for n in C.GP + ('ebp', 'esp')}


def world(n):
    if n == 40:
        import fl40_world as W
    else:
        import fl41_world as W
    return W


def check_row(W, key, entry, seeds, facts=None):
    va = int(key, 16)
    if facts is None:
        facts = C.explore(va, entry['body'])
    if facts is None:
        return None
    f = E.Function(va, entry['body'])
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    bad, checked = [], [0]
    first = f.order[0]

    def make(addr):
        ins = f.at[addr]
        memop = next((op for op in ins.operands if op.type == E.MEM_OP and ins.mnemonic != 'lea'), None)

        def sym_value(uc, v, start):
            _, name, off = v
            if name.startswith('in_'):
                return (start['regs'][name[3:]] + off) & C.M32
            if name.startswith('arg'):
                d = int(name[3:])
                return (int.from_bytes(bytes(uc.mem_read((start['esp'] + d - 4) & C.M32, 4)), 'little') + off) & C.M32
            return None

        def member(uc, actual, values, start):
            for v in values:
                if v is None:
                    return True
                if C.is_conc(v):
                    if v == actual:
                        return True
                elif v[0] == 'lo':
                    if (actual & C.mask(v[1] // 8)) == v[2]:
                        return True
                else:
                    r = sym_value(uc, v, start)
                    if r is None or r == actual:
                        return True
            return False

        def probe(uc, ensure, wc):
            if addr == first:
                start.clear()
                start['regs'] = {r: uc.reg_read(REG_IDS[r]) for r in C.GP}
                start['esp'] = uc.reg_read(REG_IDS['esp'])
            if addr not in facts.regs:
                bad.append((hex(addr), 'executed but never reached by the exploration'))
                return
            rep = ins.mnemonic.startswith(('rep', 'movs', 'stos', 'cmps', 'scas', 'lods'))
            for r, vals in facts.regs[addr].items():
                if rep and r in ('ecx', 'esi', 'edi', 'eax'):
                    continue                              # the hook fires once per repetition: the registers move
                x = uc.reg_read(REG_IDS[r])
                checked[0] += 1
                if not member(uc, x, vals, start):
                    bad.append((hex(addr), r, hex(x), sorted(map(str, vals))))
            if memop is not None and addr in facts.reads:
                m = memop.mem
                a = m.disp
                if m.base:
                    a += uc.reg_read(REG_IDS[ins.reg_name(m.base)])
                if m.index:
                    a += uc.reg_read(REG_IDS[ins.reg_name(m.index)]) * m.scale
                a &= C.M32
                try:
                    x = int.from_bytes(bytes(uc.mem_read(a, memop.size)), 'little')
                except Exception:
                    return
                checked[0] += 1
                if not member(uc, x, facts.reads[addr], start):
                    bad.append((hex(addr), 'read %x' % a, hex(x), sorted(map(str, facts.reads[addr]))))
        return probe

    start = {}
    for sd, ov in seeds:
        try:
            W.run_original(row, sd, [tuple(o) for o in ov], probes={a: make(a) for a in f.order})
        except Exception as exc:
            bad.append(('run', repr(exc)[:100]))
    return bad, checked[0]


class Soundness(unittest.TestCase):
    def test_rows(self):
        n = 0
        for wn, rows in ((40, ('0x467c0e', '0x45bbd8', '0x44ecaf')), (41, ())):
            corpus = json.loads((HERE / ('fl%d_corpus.json' % wn)).read_text())
            for key in rows:
                if key not in corpus:
                    continue
                res = check_row(world(wn), key, corpus[key], corpus[key]['seeds'][:6])
                if res is None:
                    continue
                n += 1
                self.assertEqual(res[0], [], key)
        self.assertGreater(n, 0)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--world', type=int, default=40)
    ap.add_argument('--rows')
    ap.add_argument('--seeds', type=int, default=6)
    a = ap.parse_args()
    corpus = json.loads((HERE / ('fl%d_corpus.json' % a.world)).read_text())
    W = world(a.world)
    tot = rows = skipped = 0
    failures, errors = [], []
    for key in sorted(corpus, key=lambda k: int(k, 16)):
        if a.rows and key not in a.rows.split(','):
            continue
        try:
            res = check_row(W, key, corpus[key], corpus[key]['seeds'][:a.seeds])
        except Exception as exc:
            print(key, 'ERROR', repr(exc)[:200])
            errors.append(key)
            continue
        if res is None:
            skipped += 1
            continue
        rows += 1
        tot += res[1]
        if res[0]:
            failures.append(key)
            print(key, 'UNSOUND', res[0][:3], flush=True)
    print('world %d: rows checked %d, skipped %d, values checked %d, rows with a violation %d, rows that raised %d' % (a.world, rows, skipped, tot, len(failures), len(errors)))
    sys.exit(1 if failures or errors else 0)
