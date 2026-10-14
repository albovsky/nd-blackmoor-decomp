"""A-TAIL.1 helper tests. Run with work/tools/oracle-python/bin/python (JIT).

Fixtures are synthetic. Native builds and receipts use unique private paths.
"""
from pathlib import Path
import tempfile
import unittest

import tail_oracle_common as T


class OriginalTailTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.machine = T.OriginalTail()

    def payload(self, typed=2, tail=0):
        return bytes(48) + b'\x79\x01' + b'\x34\x12'[:typed] + bytes(tail)

    def test_empty_exit_and_initialized_count(self):
        result = self.machine.invoke(self.payload(), 2)
        self.assertEqual((result.exit_address, result.accepted, result.count, result.logs),
                         (T.EMPTY_EXIT, True, 0, ()))

    def test_required_tail_lengths(self):
        for tail in T.TAIL_LENGTHS:
            with self.subTest(tail=tail):
                result = self.machine.invoke(self.payload(tail=tail), 2)
                self.assertEqual(result.accepted, tail % 16 == 0)
                self.assertEqual(result.count, tail // 16)
                self.assertEqual(result.exit_address,
                                 T.EMPTY_EXIT if tail == 0 else
                                 T.ACCEPT_EXIT if tail % 16 == 0 else T.FATAL_EXIT)
                self.assertEqual(len(result.logs), int(tail % 16 != 0))

    def test_count_width_boundaries(self):
        for count in (255, 256, 65535, 65536):
            with self.subTest(count=count):
                result = self.machine.invoke(self.payload(tail=count * 16), 2)
                self.assertTrue(result.accepted)
                self.assertEqual(result.count, count)

    def test_repeated_calls_reset_row_owner_and_count(self):
        for tail in (32, 1, 0, 16, 15, 0):
            result = self.machine.invoke(self.payload(tail=tail), 2)
            self.assertEqual(result.count, tail // 16)

    def test_tail_stage_does_not_claim_dependency_opcode_validation(self):
        # Unpaired 0x12/0x13 are beyond the observed modulus boundary.
        for opcode in (0x12, 0x13):
            result = self.machine.invoke(self.payload() + bytes([opcode]) + bytes(15), 2)
            self.assertEqual(result.exit_address, T.ACCEPT_EXIT)

    def test_short_body_original_wrap_is_not_native_safety_status(self):
        # Trusted consumed offset exceeds the declared ACT by 16. The original
        # uses DWORD subtraction, whereas native deliberately rejects a short body.
        result = self.machine.invoke(bytes(48) + b'\x35\x01', 16)
        self.assertEqual((result.accepted, result.count), (True, 0x0fffffff))

    def test_invalid_harness_arguments(self):
        for payload, typed in ((bytes(49), 1), (self.payload(), 0), (self.payload(), -1),
                               (self.payload(), 0x100000000),
                               (self.payload() + bytes(T.INPUT_CAPACITY), 2)):
            with self.subTest(typed=typed, length=len(payload)):
                with self.assertRaises(T.OracleError):
                    self.machine.invoke(payload, typed)

    def test_original_image_is_unchanged(self):
        self.machine.invoke(self.payload(tail=1), 2)
        self.assertEqual(T.sha(self.machine.uc.mem_read(T.CODE_START, T.CODE_END - T.CODE_START)),
                         T.CODE_HASH)


class NativeTailTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-TAIL.1.tests-', dir=T.PRIVATE)
        cls.native = T.NativeFamily('79', T.build_native('79', Path(cls.directory.name)))
        cls.machine = T.OriginalTail()

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def test_comparison_checks_count_and_rejection(self):
        payload = bytes(48) + b'\x79\x01\x34\x12'
        for tail in (0, 8, 16, 4096, 1048576):
            result = T.compare_tail(self.native, self.machine, payload + bytes(tail), 2)
            self.assertEqual(result.accepted, tail % 16 == 0)

    def test_short_body_status_is_a_separate_native_contract(self):
        payload = bytes(48) + b'\x79\x01\x34\x12'
        result = T.check_short_body(self.native, self.machine, payload, 2, 0)
        self.assertEqual(result.exit_address, T.FATAL_EXIT)

    def test_comparison_rejects_wrong_trusted_boundary(self):
        payload = bytes(48) + b'\x79\x01\x34\x12'
        with self.assertRaises(T.TailMismatch):
            T.compare_tail(self.native, self.machine, payload, 1)


class MutationDefinitionTests(unittest.TestCase):
    def test_exact_mutation_sites_for_all_families(self):
        from tail_oracle_mutation_check import mutate, MUTATIONS
        for family in T.FAMILIES:
            source = (T.SOURCE / f'action_family_{family}.c').read_text()
            for mutation in MUTATIONS:
                with self.subTest(family=family, mutation=mutation):
                    changed, sites = mutate(source, family, mutation)
                    self.assertNotEqual(source, changed)
                    self.assertGreater(sites, 0)


if __name__ == '__main__':
    unittest.main()
