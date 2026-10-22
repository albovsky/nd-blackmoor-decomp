"""FL-41: the operator-level recheck of the FL-39 batch d rows (tasks/fl41-fl39d-recheck.json) and the ledger agree.

A batch d row is credited only when none of its mutation survivors is unexplained; every row that has one is pending (no port acceptance), and every credited
row of the batch appears in the recheck file. Needs no Unicorn and no private files.
"""
import json
from pathlib import Path
import unittest

PROJECT = Path(__file__).resolve().parents[1]
RECHECK = json.loads((PROJECT / 'tasks/fl41-fl39d-recheck.json').read_text())
OVERRIDES = json.loads((PROJECT / 'function-ledger-overrides.json').read_text())
CREDITED = {e['va'] for e in OVERRIDES['port_acceptances'] if (e.get('native_source') or {}).get('symbol', '').endswith('_lifted')
            and (e['native_source'].get('path') or '').endswith('original_methods_fl39d.c')}


class Fl41RecheckTests(unittest.TestCase):
    def test_a_row_with_an_unexplained_survivor_is_not_credited(self):
        for va, row in RECHECK['rows'].items():
            if row['unexplained']:
                self.assertNotIn('0x' + va, CREDITED, va)
                self.assertTrue(row['decision'].startswith('pending'), va)

    def test_every_credited_batch_d_row_was_rechecked_and_has_no_unexplained_survivor(self):
        self.assertEqual(sorted(CREDITED), sorted('0x' + va for va, row in RECHECK['rows'].items() if not row['unexplained'] and row['decision'] == 'credited'))

    def test_each_explained_survivor_carries_a_reason(self):
        for va, row in RECHECK['rows'].items():
            for survivor in row['explained']:
                self.assertGreater(len(survivor['reason']), 40, va)

    def test_totals_add_up(self):
        t = RECHECK['totals']
        rows = RECHECK['rows'].values()
        self.assertEqual(t['mutants'], sum(r['mutants'] for r in rows))
        self.assertEqual(t['mutants'], t['killed'] + t['identical_gcc_O2'] + t['explained'] + t['unexplained'])
        self.assertEqual(t['credited_rows_sent_back_to_pending'], sorted(va for va, r in RECHECK['rows'].items() if r['decision'] == 'pending'))


if __name__ == '__main__':
    unittest.main()
