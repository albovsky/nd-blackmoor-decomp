"""FL-48: the written reasons for the upper-address rows still describe the code they were written for.

  - every reason in tasks/fl48-written-reasons.json names a statement that is still, character for character, on its line of the translation in src/original_methods_fl41.c, is long
    enough to say something (80+ characters), carries the independent reviewer's note, and cites only instruction addresses inside the function that the translation has;
  - a reason names a mutant (`ident`, the hash scripts/fl48_only.py and the mutation logs use) that the mutation operators still produce on that line;
  - no credited FL-48 row has an unexplained survivor, and every mutant that the step-budget rerun (tasks/fl48-budget-log-*.txt) did not kill is classified (identical code, proven
    no-op, range rule or written reason) in tasks/fl48-survivors-5.json: a hang kill of an ordinary run never decides a row (Glib's ruling).
"""
import ast
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
                self.assertTrue(i.get('ident'), (row, i['kind'], i['line']))       # a reason without an ident would cover every mutant of the line
                if True:
                    self.assertIn((i['kind'], i['line'], i['ident']), {(k, n, M.line_hash(t, n)) for k, n, t in muts}, (row, i['kind'], i['line']))


# FL-52 re-ran these FL-48 rows with its own budget accounting (tests/test_fl52_reasons.py); the FL-48 budget logs of these rows predate the long-alarm rerun
FL52_RECHECKED = {'0x489722', '0x4af96e'}


class StepBudget(unittest.TestCase):
    def test_hang_listed_mutants_are_killed_by_the_budget_or_explained(self):
        surv = json.loads((PROJECT / 'tasks/fl48-survivors-5.json').read_text())
        rows = set(M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text()))
        before = set(json.loads((PROJECT / 'tasks/fl48-credited-before.json').read_text()))
        self.assertEqual(rows & set(surv['unexplained_rows']), set())
        hang = json.loads((PROJECT / 'tasks/fl48-hang-lists-all.json').read_text())
        for row in sorted(rows - before - FL52_RECHECKED):
            if row not in hang:
                continue
            log = PROJECT / ('tasks/fl48-budget-log-%s.txt' % row)
            m = re.search(r'^%s mutants \d+ killed \d+ survivors (.*)$' % row, log.read_text(), re.M)
            self.assertTrue(m, row)
            alive = {(x[0], x[1], x[3]) for x in ast.literal_eval(m.group(1))}
            explained = {(x[0], x[1], x[2]) for x in surv['mutants'].get(row, []) if x[3]}
            self.assertEqual(alive - explained, set(), row)


if __name__ == '__main__':
    unittest.main()
