"""FL-59: the three upper rows that no lifter could take (translated/original_methods_fl59_handports.c, tests/fl59_handports.json, written by scripts/fl59_handports.py).

0x50ed50 and 0x50fa90 are the CRT memmove (hand ports), 0x4d8dca is a recursive quicksort (BULK lift with its two self-calls run natively).
They are "translated, unverified": NOT port credits, no mutation check was run. The tests check that the table and the C file belong together, that the C file compiles with the FL-41 model,
and that the recorded scenarios still agree with the original bytes (Unicorn) when the private work/original/GAME.EXE is present.
"""
import json
from pathlib import Path
import re
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import original_differential as od
import fl41_world as W

PROJECT = Path(__file__).resolve().parents[1]
TABLE = json.loads((Path(__file__).resolve().parent / 'fl59_handports.json').read_text())
SOURCE_PATH = PROJECT / 'translated/original_methods_fl59_handports.c'
SOURCE = SOURCE_PATH.read_text()


def view(t):
    mem = {}
    for address, size, value in t.writes:
        if W.STACK_BASE <= address < W.STACK_BASE + W.STACK_SIZE:
            continue        # the original's push/pop of ebp, edi and esi
        for b in range(size):
            mem[address + b] = (value >> (8 * b)) & 0xff
    return ({k: t.regs[k] for k in ('eax', 'ebx', 'esp', 'ebp', 'esi', 'edi')}, sorted(mem.items()), t.fault)


class Fl59Handports(unittest.TestCase):
    def test_table_and_source_belong_together(self):
        symbols = set(re.findall(r'^void (m[0-9a-f]+)_lifted\(', SOURCE, re.M))
        self.assertEqual(symbols, {'m' + k[2:] for k in TABLE})
        self.assertEqual(set(TABLE), {'0x4d8dca', '0x50ed50', '0x50fa90'})
        for k, row in TABLE.items():
            self.assertTrue(row['seeds'] or row['scenarios'], k)

    def test_not_port_credits(self):
        ledger = json.loads((PROJECT / 'function-ledger.json').read_text())['entries']
        ported = {e['va'] for e in ledger if e['status'] == 'ported'}
        self.assertFalse(set(TABLE) & ported)
        for name in ('fl41_translated.json', 'fl57_translated.json', 'fl41_corpus.json'):
            self.assertFalse(set(TABLE) & set(json.loads((Path(__file__).resolve().parent / name).read_text())), name)

    def test_the_recursive_call_runs_natively(self):
        self.assertEqual(SOURCE.count('FL41_CALL_LIFTED(m4d8dca_lifted);'), 2)
        self.assertNotIn('FL41_CALL(0x4d8dcau)', SOURCE)

    def test_c_file_compiles_with_the_model(self):
        with tempfile.TemporaryDirectory() as tmp:
            W.build_library(tmp, [SOURCE_PATH])

    @unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
    def test_recorded_scenarios_agree_with_the_original(self):
        with tempfile.TemporaryDirectory() as tmp:
            lib = W.build_library(tmp, [SOURCE_PATH])
            for k, t in TABLE.items():
                va = int(k, 16)
                row = W.row_info(va, t['body'], {})
                if t['kind'] == 'memmove':
                    cases = [(0, ((W.SP + 4, 4, d), (W.SP + 8, 4, s), (W.SP + 12, 4, n))) for d, s, n in t['scenarios'][::4]] + [(seed, ()) for seed in t['seeds'][:4]]
                    for seed, ov in cases:
                        original = W.run_original(row, seed, ov)
                        self.assertFalse(original.fault, k)
                        self.assertEqual(view(W.run_native(lib, row, seed, ov)), view(original), k)
                else:
                    for seed in t['seeds'][:4]:
                        original = W.run_original(row, seed)
                        self.assertFalse(original.fault, k)
                        self.assertEqual(W.run_native(lib, row, seed).digest(), original.digest(), k)


if __name__ == '__main__':
    unittest.main()
