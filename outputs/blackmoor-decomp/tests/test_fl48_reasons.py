"""FL-48: the written reasons for the upper-address rows still describe the code they were written for.

  - every reason in tasks/fl48-written-reasons.json names a statement that is still, character for character, on its line of the translation in src/original_methods_fl41.c, is long
    enough to say something (80+ characters), carries the independent reviewer's note, and cites only instruction addresses inside the function that the translation has;
  - a reason that names a mutant (`ident`, the hash scripts/fl48_only.py and the mutation logs use) names one the mutation operators still produce on that line.
"""
import json
from pathlib import Path
import random
import re
import sys
import unittest

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
import fl41_mutation_check as M


class WrittenReasons(unittest.TestCase):
    def setUp(self):
        self.doc = json.loads((PROJECT / 'tasks/fl48-written-reasons.json').read_text())
        self.funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())

    def test_each_reason_matches_its_statement(self):
        for row, items in self.doc['rows'].items():
            lines = self.funcs[row].split('\n')
            for i in items:
                self.assertEqual(lines[i['line']], i['statement'], (row, i['kind'], i['line']))
                self.assertGreaterEqual(len(i['reason']), 80, (row, i['line']))
                self.assertGreaterEqual(len(i['review']), 40, (row, i['line']))

    def test_reasons_cite_addresses_of_the_function_only(self):
        corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text())
        for row, items in self.doc['rows'].items():
            lo = int(row, 16)
            known = set(re.findall(r'/\* (0x[0-9a-f]+):', self.funcs[row]))
            for i in items:
                for addr in re.findall(r'0x4[0-9a-f]{5}\b', i['reason']):
                    if lo <= int(addr, 16) < lo + corpus[row]['body']:
                        self.assertIn(addr, known, (row, i['line'], addr))

    def test_named_mutants_exist(self):
        for row, items in self.doc['rows'].items():
            muts = M.mutants(self.funcs[row], int(row, 16), random.Random(int(row, 16)), 100000, True)
            for i in items:
                if i.get('ident'):
                    self.assertIn((i['kind'], i['line'], i['ident']), {(k, n, M.line_hash(t, n)) for k, n, t in muts}, (row, i['kind'], i['line']))


if __name__ == '__main__':
    unittest.main()
