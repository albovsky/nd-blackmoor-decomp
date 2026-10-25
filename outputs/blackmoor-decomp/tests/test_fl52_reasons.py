"""FL-52: the written reasons for the upper-address rows credited in FL-52 still describe the code they were written for, and the credited rows have no unexplained mutant.

  - every reason in tasks/fl52-written-reasons.json names a statement that is still, character for character, on its line of the translation in src/original_methods_fl41.c, is long
    enough to say something (80+ characters), carries the independent reviewer's note, and cites only instruction addresses inside the function that the translation has;
  - a reason names a mutant (`ident`, the hash the mutation logs use) that the mutation operators still produce on that line;
  - the merged final log of the credited rows (tasks/fl52/final2/merged.txt: the normal runs with the step-budget survivors added, scripts/fl52_merge.py) has every survivor classified
    in tasks/fl52/final2/surv.json (identical -O2 code, a proven no-op, a range rule or a written reason): no unexplained row; and each credited row is in the log.
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

CREDITED = ('0x488da5', '0x489722', '0x48e776', '0x48e9bf', '0x4959ea', '0x4a0cea', '0x4a6bde', '0x4af96e')


class WrittenReasons(unittest.TestCase):
    def setUp(self):
        self.doc = json.loads((PROJECT / 'tasks/fl52-written-reasons.json').read_text())
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
            have = {(k, n, M.line_hash(t, n)) for k, n, t in muts}
            for i in items:
                self.assertTrue(i.get('ident'), (row, i['kind'], i['line']))
                self.assertIn((i['kind'], i['line'], i['ident']), have, (row, i['kind'], i['line']))


class FinalLog(unittest.TestCase):
    def test_credited_rows_are_in_the_translated_set_and_fully_explained(self):
        rows = set(M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text()))
        surv = json.loads((PROJECT / 'tasks/fl52/final2/surv.json').read_text())
        log = (PROJECT / 'tasks/fl52/final2/merged.txt').read_text()
        for row in CREDITED:
            self.assertIn(row, rows)
            self.assertRegex(log, r'(?m)^%s mutants \d+' % row)
        self.assertEqual(set(surv['unexplained_rows']) & set(CREDITED), set())

    def test_hang_listed_mutants_were_killed_by_the_budget_or_are_classified(self):
        """every hang-listed mutant of a credited row is either killed by the step budget or a budget survivor that the classification explains"""
        sys.path.insert(0, str(PROJECT / 'scripts'))
        import fl52_merge
        logs = {'0x4a6bde': ('mut3', ['budget3']), '0x48e9bf': ('mut3', ['budget3']), '0x4af96e': ('p-mut', ['p-bud']), '0x48e776': ('mut3', []), '0x488da5': ('mut', []),
                '0x4959ea': ('p3-mut', ['p3-bud', 'p3-bud2']), '0x489722': ('p2-mut', ['p2-bud', 'p2-bud2']), '0x4a0cea': ('p2-mut', ['p2-bud', 'p2-bud2'])}
        surv = json.loads((PROJECT / 'tasks/fl52/final2/surv.json').read_text())
        for row, (normal, budgets) in logs.items():
            _, _, hangs, _, _ = fl52_merge.parse(PROJECT / 'tasks/fl52' / ('%s-%s.txt' % (normal, row)))
            idents = {h[2] for h in hangs}
            if not idents:
                self.assertEqual(budgets, [], row)
                continue
            killed, alive = set(), set()
            for budget in budgets:
                _, _, _, k, a = fl52_merge.parse(PROJECT / 'tasks/fl52' / ('%s-%s.txt' % (budget, row)))
                killed |= {x[2] for x in k}
                alive |= {x[3] for x in a}
            alive -= killed
            self.assertEqual(idents - killed - alive, set(), row)
            explained = {m[2] for m in surv['mutants'].get(row, []) if m[3] is not None}
            self.assertEqual((idents & alive) - explained, set(), row)


if __name__ == '__main__':
    unittest.main()
