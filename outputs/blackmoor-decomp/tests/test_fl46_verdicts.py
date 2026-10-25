"""FL-46: the credited lower-address ports follow the committed verdict, and the written reasons still describe the code they were written for.

  - every written reason in tasks/fl46-written-reasons.json names a statement that is still, character for character, on its line of the translation
    in src/original_methods_fl40.c, is long enough to say something (80+ characters) and cites only instruction addresses inside the function;
  - the held-rows file is what scripts/fl44_final.py computes from the logs and the rules as committed (so no one edits the file by hand);
  - a corpus row has a port acceptance in function-ledger-overrides.json exactly when it is not held.
"""
import contextlib
import io
import json
import re
import sys
import unittest
from pathlib import Path

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl40_mutation_check as M

ORACLE = 'tests/fl40_original_oracle.py'


class WrittenReasons(unittest.TestCase):
    def setUp(self):
        self.doc = {'rows': {}}
        for path in sorted((PROJECT / 'tasks').glob('fl4[69]-written-reasons.json')):          # FL-46, FL-49
            for row, items in json.loads(path.read_text())['rows'].items():
                self.doc['rows'].setdefault(row, []).extend(items)
        self.funcs = M.split_functions((PROJECT / 'src/original_methods_fl40.c').read_text())

    def test_each_reason_matches_its_statement(self):
        for row, items in self.doc['rows'].items():
            lines = self.funcs[row].split('\n')
            for i in items:
                self.assertEqual(lines[i['line']].strip()[:300], i['statement'], (row, i['kind'], i['line']))
                self.assertGreaterEqual(len(' '.join(i['reason'].split())), 80, (row, i['line']))
                self.assertGreaterEqual(len(i['review'].strip()), 40, (row, i['line']))

    def test_reasons_cite_addresses_of_the_function_only(self):
        corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
        for row, items in self.doc['rows'].items():
            lo = int(row, 16)
            known = set(re.findall(r'/\* (0x[0-9a-f]+):', self.funcs[row]))
            for i in items:
                for addr in re.findall(r'0x4[0-9a-fA-F]{5}\b', i['reason']):
                    if lo <= int(addr, 16) < lo + corpus[row]['body']:         # inside the function: it must be an instruction the translation has
                        self.assertIn(addr.lower(), known, (row, i['line'], addr))
                    else:                                                       # outside: only a jump table the function's own jmp reads; a callee's behaviour is not checked by the oracle
                        self.assertIn(addr.lower(), ('0x4453a7', '0x44550b'), (row, i['line'], addr))


class Coverage(unittest.TestCase):
    def test_a_wall_clock_hang_kill_in_an_older_log_never_decides_a_row(self):
        """a credited row whose line in an older log lists hang kills (wall clock) has a line in the budget log, which is read last"""
        held = set(json.loads((PROJECT / 'tasks/fl40-held-rows.json').read_text())['rows'])
        import fl44_final
        budget = set(re.findall(r'^(0x[0-9a-f]+) mutants', (PROJECT / 'tasks/fl46-budget3-log.txt').read_text(), re.M))
        for name in fl44_final.LOGS:
            if name.startswith(('fl49-', 'fl50-', 'fl51-', 'fl53-')):                      # run under FL46_BUDGET=1: a line with hang kills must say that budget kills decided them
                for line in (PROJECT / 'tasks' / name).read_text().split('\n'):
                    if re.match(r'^0x[0-9a-f]+ mutants .* hang-kills [1-9]', line) and (name.startswith('fl49-') or line.split()[0] not in held):       # FL-50: a held row may list wall-clock hangs; they decide nothing
                        self.assertIn('killed by step budget', line, (name, line[:20]))
                continue
            if name.startswith('fl46-'):
                continue
            for row in re.findall(r'^(0x[0-9a-f]+) mutants .* hang-kills [1-9]', (PROJECT / 'tasks' / name).read_text(), re.M):
                if row not in held:
                    self.assertIn(row, budget, (name, row))
        self.assertEqual(fl44_final.LOGS[-8:], ['fl46-budget3-log.txt', 'fl49-recheck-log.txt', 'fl49-recheck2-log.txt', 'fl49-recheck3-log.txt', 'fl50-recheck-log.txt', 'fl50-large-log.txt', 'fl51-mutation-log.txt', 'fl53-mutation-log.txt'])       # the later log wins in fl44_final.main


class HeldRows(unittest.TestCase):
    def test_held_file_is_what_the_final_verdict_computes(self):
        try:
            import capstone      # noqa: F401  (the range rule needs it)
        except ImportError:
            self.skipTest('the range rule needs capstone')
        import fl44_final
        held_path = PROJECT / 'tasks/fl40-held-rows.json'
        committed = json.loads(held_path.read_text())['rows']
        argv, sys.argv = sys.argv, ['fl44_final.py']
        try:
            with contextlib.redirect_stdout(io.StringIO()) as out:
                _, held_now = fl44_final.main()
        finally:
            sys.argv = argv
        counts = re.search(r'clean (\d+), held (\d+)', out.getvalue())
        corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
        self.assertEqual(int(counts.group(2)), len(committed))
        self.assertEqual(set(held_now), set(committed))
        self.assertEqual(int(counts.group(1)), len(corpus) - len(committed))

    def test_acceptance_exactly_for_the_rows_that_are_not_held(self):
        corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
        held = set(json.loads((PROJECT / 'tasks/fl40-held-rows.json').read_text())['rows'])
        accepted = {e['va'] for e in json.loads((PROJECT / 'function-ledger-overrides.json').read_text())['port_acceptances']
                    if (e.get('oracle') or {}).get('path') == ORACLE}
        self.assertEqual(accepted, set(corpus) - held)


if __name__ == '__main__':
    unittest.main()
