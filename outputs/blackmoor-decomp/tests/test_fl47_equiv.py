#!/usr/bin/env python3
"""FL-47 soundness test of the 'holds' and 'eq' facts of scripts/fl43_equiv.py: run the ORIGINAL bytes of every translated row under Unicorn on corpus seeds and check, before every
executed instruction, that each fact the forward analysis says holds there does hold: a register equals the 32 bits at [base + disp], two registers are equal.
Rows the analysis does not cover (NoProof) are skipped.

  python3 tests/test_fl47_equiv.py [--rows 0x4f6810,...] [--seeds 6]          (run from outputs/blackmoor-decomp; also a unittest)
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
import fl41_world as W
import fl43_equiv as E
from unicorn import x86_const as UX

REG_IDS = {n: getattr(UX, 'UC_X86_REG_' + n.upper()) for n in E.ALL}


def check_row(key, entry, seeds):
    va = int(key, 16)
    try:
        f = E.Function(va, entry['body'], exposed_ok=True)
    except E.NoProof:
        return None
    IN = f.facts()
    row = W.row_info(va, entry['body'], {int(k, 16): v for k, v in entry['callees'].items()}, {int(k, 16): v for k, v in entry['imports'].items()}, entry['fs'])
    bad, checked = [], [0]

    def make(addr):
        facts = [x for x in (IN.get(addr) or ()) if x[0][0] in ('holds', 'eq') or (x[0][0] == 'mov' and x[3] is not None and x[3][0] == 'slot' and x[3][2] == 4 and x[0][1].startswith(x[1] + ', dword ptr [ebp'))]
        if f.at[addr].mnemonic.startswith(E.STRING_OPS):
            facts = []                      # the hook fires once per repetition of a rep instruction; the facts hold before its first

        def probe(uc, ensure, wc):
            for sig, reg, inputs, mcls in facts:
                if sig[0] == 'eq':
                    (other,) = tuple(inputs)
                    if uc.reg_read(REG_IDS[reg]) != uc.reg_read(REG_IDS[other]):
                        bad.append((hex(addr), 'eq', reg, other))
                else:
                    if sig[0] == 'mov':                  # a register that holds the 32 bits of a frame slot
                        where, label = uc.reg_read(REG_IDS['ebp']) + mcls[1], ('slot', hex(mcls[1] & 0xffffffff))
                    else:                                # 'holds': a register that holds the 32 bits at [base + disp]
                        where, label = uc.reg_read(REG_IDS[sig[1]]) + sig[2], (sig[1], hex(sig[2] & 0xffffffff))
                    try:
                        mem = int.from_bytes(bytes(uc.mem_read(where & 0xffffffff, 4)), 'little')
                    except Exception:
                        continue
                    if mem != uc.reg_read(REG_IDS[reg]):
                        bad.append((hex(addr), sig[0], reg) + label)
                checked[0] += 1
        return probe

    for sd, ov in seeds:
        W.run_original(row, sd, [tuple(o) for o in ov], probes={a: make(a) for a in f.order})
    return bad, checked[0]


class Proofs(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.corpus = json.loads((HERE / 'fl41_corpus.json').read_text())

    def test_store_then_reload_through_equal_pointers_is_a_repeat(self):
        # 0x4a140b: `mov [edx + 0xdf0], ecx` then, with eax and edx both loaded from [ebp - 4], `mov ecx, [eax + 0xdf0]` at 0x4a148d
        proof = E.prove(0x4a140b, self.corpus['0x4a140b']['body'], [0x4a148d, 0x4a1478])
        self.assertTrue(proof[0x4a148d].startswith('repeat'))
        self.assertIsNone(proof[0x4a1478])            # after a call the value may have changed

    def test_address_taken_frame_needs_the_flag_and_keeps_only_the_slots_below_the_address(self):
        body = self.corpus['0x4be367']['body']
        with self.assertRaises(E.NoProof):
            E.prove(0x4be367, body, [0x4be39a])
        self.assertTrue(E.prove(0x4be367, body, [0x4be39a], exposed_ok=True)[0x4be39a].startswith('repeat'))


class Soundness(unittest.TestCase):
    def test_rows(self):
        corpus = json.loads((HERE / 'fl41_corpus.json').read_text())
        n = total = 0
        for key in sorted(corpus, key=lambda k: int(k, 16)):
            res = check_row(key, corpus[key], corpus[key]['seeds'][:6])
            if res is None:
                continue
            n += 1
            total += res[1]
            self.assertEqual(res[0], [], key)
        self.assertGreater(n, 0)
        self.assertGreater(total, 0)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--rows')
    ap.add_argument('--seeds', type=int, default=6)
    a = ap.parse_args()
    corpus = json.loads((HERE / 'fl41_corpus.json').read_text())
    tot = rows = skipped = 0
    for key in sorted(corpus, key=lambda k: int(k, 16)):
        if a.rows and key not in a.rows.split(','):
            continue
        res = check_row(key, corpus[key], corpus[key]['seeds'][:a.seeds])
        if res is None:
            skipped += 1
            continue
        rows += 1
        tot += res[1]
        if res[0]:
            print(key, 'UNSOUND', res[0][:3])
    print('rows checked %d, skipped %d, facts checked %d' % (rows, skipped, tot))
