"""FL-55b: the "translated, unverified" rows (translated/original_methods_fl41_translated.c, tests/fl41_translated.json, written by scripts/fl55_bulk.py).

These rows are NOT port credits: they were translated by scripts/lift_fl41.py without the mutation check and compared with the original only on the few seeds the table keeps.
The tests check that the table and the C file belong together, that the C file compiles with the FL-41 model, and that a deterministic sample of the rows agrees with the original again.
"""
import ctypes
import json
from pathlib import Path
import platform
import re
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import original_differential as od
import fl41_world as W
import lift_fl41 as L

PROJECT = Path(__file__).resolve().parents[1]
TABLE = json.loads((Path(__file__).resolve().parent / 'fl41_translated.json').read_text())
SOURCE = (PROJECT / 'translated/original_methods_fl41_translated.c').read_text()
X87_HOST = platform.machine().lower() in ('x86_64', 'amd64', 'i386', 'i686')


class Fl56Translated(unittest.TestCase):
    def test_table_and_source_belong_together(self):
        symbols = set(re.findall(r'^void (m[0-9a-f]+)_lifted\(', SOURCE, re.M))
        self.assertEqual(symbols - {'m50c920'}, {'m' + k[2:] for k in TABLE})
        self.assertGreaterEqual(len(TABLE), 1500)
        for k, row in TABLE.items():
            self.assertIn(row['status'], ('agrees', 'no seed'))
            self.assertEqual(bool(row['seeds']), row['status'] == 'agrees')
            self.assertGreaterEqual(int(k, 16), 0x480000)

    def test_translated_rows_are_not_port_credits(self):
        ledger = json.loads((PROJECT / 'function-ledger.json').read_text())['entries']
        ported = {e['va'] for e in ledger if e['status'] == 'ported'}
        corpus = json.loads((Path(__file__).resolve().parent / 'fl41_corpus.json').read_text())
        self.assertFalse(set(TABLE) & set(corpus))
        # a row that is both in the ledger as ported and in this table would count twice in the reports
        self.assertFalse(set(TABLE) & ported)

    def test_c_file_compiles_with_the_model(self):
        with tempfile.TemporaryDirectory() as tmp:
            W.build_library(tmp, [PROJECT / 'translated/original_methods_fl41_translated.c'])

    @unittest.skipUnless(od.available() and X87_HOST, 'needs Unicorn, the pinned private work/original/GAME.EXE and an x86 host for the x87 rows')
    def test_sample_of_rows_agrees_with_the_original(self):
        L.BULK = True                                          # row_info reads the x87 effect of the callees the way the bulk lift did
        self.addCleanup(setattr, L, 'BULK', False)
        sample = [k for k in sorted(TABLE, key=lambda x: int(x, 16)) if TABLE[k]['seeds']][::40]
        self.assertGreaterEqual(len(sample), 30)
        with tempfile.TemporaryDirectory() as tmp:
            W.build_library(tmp, [PROJECT / 'translated/original_methods_fl41_translated.c'])
            lib = ctypes.CDLL(str(Path(tmp) / 'fl41.so'))
            for k in sample:
                t = TABLE[k]
                row = W.row_info(int(k, 16), t['body'], {int(a, 16): n for a, n in t['callees'].items()}, {int(a, 16): n for a, n in t['imports'].items()}, t['fs'], {int(a, 16): n for a, n in t.get('sites', {}).items()}, t.get('frame', False))
                for seed, overrides in t['seeds'][:3]:
                    ov = tuple(tuple(o) for o in overrides)
                    original = W.run_original(row, seed, ov)
                    native = W.run_native(lib, row, seed, ov)
                    self.assertFalse(original.fault, k)
                    self.assertEqual(native.digest(), original.digest(), k)


if __name__ == '__main__':
    unittest.main()
