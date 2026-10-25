"""FL-56: the "translated, unverified" lower rows and the proofs of impossible jump directions.

- every `untaken_ok` direction of tests/fl40_corpus.json has a mechanical proof (scripts/fl56_untaken.py);
- the unverified rows are not in the verified corpus, are not claimed as ported by the ledger, and the committed source and manifest are what the lifter writes now.
"""
import json
from pathlib import Path
import sys
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import original_differential as od

PROJECT = Path(__file__).resolve().parents[1]
CORPUS = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
MANIFEST = json.loads((PROJECT / 'tasks/fl56-translated-unverified.json').read_text())


@unittest.skipUnless(od.available(), 'needs the pinned private work/original/GAME.EXE')
class UntakenProofs(unittest.TestCase):
    def test_every_allowed_untaken_direction_has_a_proof(self):
        import fl56_untaken as U
        allowed = [(k, a, d) for k, c in CORPUS.items() for a, d in c.get('untaken_ok', [])]
        self.assertTrue(allowed)
        for key, address, direction in allowed:
            self.assertIsNotNone(U.prove(key, int(address, 16), direction), (key, address, direction))

    def test_the_prover_refuses_a_possible_direction(self):
        import fl56_untaken as U
        self.assertIsNone(U.prove('0x45e6bd', 0x45e70a, 'taken'))          # [ebp-4] can be nonzero when the loop comes back
        self.assertIsNone(U.prove('0x4230d1', 0x42311f, 'fall-through'))    # the other direction is the one that happens


class UnknownConditions(unittest.TestCase):
    def test_a_condition_the_evaluator_does_not_know_proves_nothing(self):
        sys.path.insert(0, str(PROJECT / 'scripts'))
        import fl56_untaken as U
        for cc in ('o', 'no', 'p', 'np'):
            self.assertIsNone(U.outcomes('cmp', ('const', 1), ('const', 1), cc), cc)
        self.assertEqual(U.outcomes('cmp', ('const', 1), ('const', 1), 'e'), {1})


class ValueWalk(unittest.TestCase):
    """the abstract value of a register must be unknown after any instruction that writes it, implicit writes and 16-bit parts included"""
    def walk(self, hexcode, reg):
        import capstone
        sys.path.insert(0, str(PROJECT / 'scripts'))
        import fl56_untaken as U
        md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        md.detail = True
        ins = list(md.disasm(bytes.fromhex(hexcode), 0x1000))
        return U.value_of(ins, len(ins) - 1, reg, U.jump_targets(ins), [])

    def test_clobbers_are_not_skipped(self):
        self.assertIsNone(self.walk('31f6668b3085f6', 'esi'))        # xor esi,esi; mov si,[eax]; test esi,esi
        self.assertIsNone(self.walk('31c0f7e985c0', 'eax'))          # xor eax,eax; imul ecx; test eax,eax
        self.assertIsNone(self.walk('31c00f3185c0', 'eax'))          # rdtsc
        self.assertIsNone(self.walk('31c09f85c0', 'eax'))            # lahf
        self.assertEqual(self.walk('b80100000085c0', 'eax'), ('const', 1))


class UnverifiedRows(unittest.TestCase):
    def test_rows_are_not_in_the_verified_corpus_and_not_ported(self):
        ledger = json.loads((PROJECT / 'function-ledger.json').read_text())['entries']
        status = {x['va']: x['status'] for x in ledger}
        self.assertFalse(set(MANIFEST['rows']) & set(CORPUS))
        for key, row in MANIFEST['rows'].items():
            self.assertEqual(row['status'], 'translated, unverified')
            self.assertNotEqual(status[key], 'ported', key)

    @unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
    def test_source_and_manifest_are_what_the_lifter_writes(self):
        import fl56_unverified as V
        source, manifest = V.build()
        self.assertEqual((PROJECT / 'src/original_methods_fl56_unverified.c').read_text(), source)
        self.assertEqual(json.loads(json.dumps(manifest, sort_keys=True)), MANIFEST)


if __name__ == '__main__':
    unittest.main()
