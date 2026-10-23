"""FL-44: the mutation harness counts a kill only on a scenario where the unmutated translation equals the original.

A deliberately wrong port (a flipped jump) must make the harness refuse the row ('differs from the original on corpus seed') instead of reporting every mutant killed."""
import json
import re
import sys
import unittest
from pathlib import Path

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import fl40_mutation_check as M
import original_differential as od

ROW = '0x4150af'


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class MutationGuard(unittest.TestCase):
    def setUp(self):
        self.corpus = json.loads(M.CORPUS.read_text())
        self.text = M.split_functions(M.SOURCE.read_text())[ROW]

    def run_row(self, text):
        entry = self.corpus[ROW]
        return M.check_row_inner((ROW, entry, text, '', 1000, False, None))

    def test_translation_passes_and_reports_no_dropped_scenarios(self):
        key, res = self.run_row(self.text)
        self.assertEqual(key, ROW)
        self.assertEqual(res['guard_dropped'], 0)
        self.assertGreater(res['mutants'], 10)

    def test_wrong_port_is_refused(self):
        broken = re.sub(r'if \((.*)\) goto (L_[0-9a-f]+);', r'if (!(\1)) goto \2;', self.text, count=1)
        self.assertNotEqual(broken, self.text)
        with self.assertRaisesRegex(RuntimeError, 'differs from the original on corpus seed'):
            self.run_row(broken)


if __name__ == '__main__':
    unittest.main()
