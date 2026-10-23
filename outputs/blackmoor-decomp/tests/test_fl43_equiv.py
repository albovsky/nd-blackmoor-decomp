"""FL-43: the data-flow proofs of scripts/fl43_equiv.py are sound against the mutation check.

A proof says that dropping one instruction of a row changes nothing. The mutation check (tests/fl41_mutation_check.py) drops every statement of every row and
runs the mutant against the original bytes: a proof for an instruction whose dropped mutant a seed kills would be a false proof. The committed log of the check
(tasks/fl43-mutation-log.txt, mutants not listed there as survivors were killed) is the evidence.
"""
import json
from pathlib import Path
import re
import sys
import unittest

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(PROJECT / 'scripts'))
import original_differential as od
import fl41_mutation_check as M

DROPPABLE_NOT = ('/*', 'void ', 'FL41_', 'done:', 'L_', 'while', 'switch', 'case', 'default', 'break', '{', '}')


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl43Equiv(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        import fl43_equiv as E
        cls.E = E
        cls.corpus = json.loads((HERE / 'fl41_corpus.json').read_text())
        cls.funcs = M.split_functions((PROJECT / 'src/original_methods_fl41.c').read_text())

    def test_reload_of_a_stored_register_is_a_repeat(self):
        # 0x4a9f63 stores ecx to [ebp - 8] and reloads it at 0x4a9f75 with nothing in between that could change either; after the call at 0x4a9f81 the reload at 0x4a9f86 is not
        proof = self.E.prove(0x4a9f63, self.corpus['0x4a9f63']['body'], [0x4a9f75, 0x4a9f86])
        self.assertTrue(proof[0x4a9f75].startswith('repeat'))
        self.assertIsNone(proof[0x4a9f86])

    def test_a_function_that_takes_the_address_of_a_frame_slot_gets_no_proof(self):
        import lift_fl41 as L
        with self.assertRaises(self.E.NoProof):          # 0x49027c has `lea reg, [ebp - k]` at 0x490358
            self.E.prove(0x49027c, L.ledger_spans()[0x49027c], [0x4902e5])

    def test_no_proof_for_an_instruction_whose_dropped_mutant_was_killed(self):
        log = HERE.parent / 'tasks/fl43-mutation-log.txt'
        if not log.is_file():
            self.skipTest('no committed mutation log')
        status = {}
        for line in log.read_text().split('\n'):
            m = re.match(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)', line)
            if m:
                status[m.group(1)] = {(x[0], x[1]): x[2] for x in eval(m.group(2)[:m.group(2).rindex(']') + 1])}
        checked = 0
        for key, st in status.items():
            if key not in self.funcs:        # a row that left the translated set
                continue
            lines = self.funcs[key].split('\n')
            statements = [n for n, l in enumerate(lines)
                          if (lambda c: c.strip() and not c.strip().startswith(DROPPABLE_NOT) and 'goto' not in c and 'FL41_CALL' not in c)(re.sub(r'\s*/\*.*', '', l))]
            addresses = {n: (lambda m: int(m.group(1), 16) if m else None)(re.search(r'/\* (0x[0-9a-f]+): ', lines[n])) for n in statements}
            try:
                proofs = self.E.prove(int(key, 16), self.corpus[key]['body'], [a for a in addresses.values() if a])
            except self.E.NoProof:
                continue
            for n in statements:
                if addresses[n] and proofs.get(addresses[n]):
                    checked += 1
                    self.assertEqual(st.get(('drop', n)), 'survives', '%s line %d (0x%x) has a proof but its dropped mutant was killed' % (key, n, addresses[n]))
        self.assertGreater(checked, 0)


if __name__ == '__main__':
    unittest.main()
