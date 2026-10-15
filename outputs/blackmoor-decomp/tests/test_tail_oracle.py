"""A-TAIL.2 helper tests. Run with work/tools/oracle-python/bin/python (JIT).

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
        for count in (255, 256, 65535, 65536, 65537):
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
        cls.directory = tempfile.TemporaryDirectory(prefix='A-TAIL.2.tests-', dir=T.PRIVATE)
        cls.native = T.NativeFamily('79', T.build_native('79', Path(cls.directory.name)))
        cls.machine = T.OriginalTail()

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def test_comparison_checks_count_and_rejection(self):
        payload = bytes(48) + b'\x79\x01\x34\x12'
        for tail in (0, 8, 16, 4096, 4097, 1048576, 1048592):
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

    def test_extended_family_and_length_coverage(self):
        self.assertEqual(len(T.FAMILIES), 29)
        self.assertTrue(set(range(301)).issubset(T.TAIL_LENGTHS))
        self.assertTrue(set(range(1023, 1026)).issubset(T.TAIL_LENGTHS))
        self.assertTrue(set(range(4079, 4098)).issubset(T.TAIL_LENGTHS))
        self.assertTrue({65536 * 16, 65537 * 16}.issubset(T.WIDTH_TAILS))

    def test_new_mutant_witnesses_straddle_prior_coverage(self):
        # These are compiled C regressions: preserving 65536 records and small
        # ragged rejection must not let a mutant survive the extended stage.
        from tail_oracle_mutation_check import compile_mutant, witness
        with tempfile.TemporaryDirectory(prefix='A-TAIL.2.mutation-tests-', dir='/private/tmp') as path:
            directory = Path(path)
            machine = T.OriginalTail()
            payload = bytes(48) + b'\x79\x01\x34\x12'
            for mutation in ('modulus_below_4096', 'count_u16_above_65536'):
                library, _ = compile_mutant('79', mutation, directory / mutation)
                native = T.NativeFamily('79', library)
                for length in (0, 1, 16, 4095, 4096, 65536 * 16):
                    T.compare_tail(native, machine, payload + bytes(length), 2)
                with self.assertRaises(T.TailMismatch):
                    witness(native, machine, payload, 2, mutation)

    def test_old_oracle_comparison_errors_fail_closed(self):
        from types import SimpleNamespace
        from unittest.mock import patch
        from tail_oracle_mutation_check import old_oracle
        reason = 'OracleError: original dependency accept/reject mismatch count=0 tail=1'
        with tempfile.TemporaryDirectory(prefix='A-TAIL.2.old-oracle-tests-', dir='/private/tmp') as path:
            directory = Path(path)
            for index, (family, message, code, expected) in enumerate((
                    ('45', reason, 1, True),
                    ('44', reason, 1, False),
                    ('45', 'OracleError: original dependency setup mismatch', 1, False),
                    ('45', 'OracleError: native mismatch', -11, False))):
                case_dir = directory / str(index)
                case_dir.mkdir()
                def simulate(_command, *, stdout, **_kwargs):
                    stdout.write(message + '\n')
                    stdout.flush()
                    return SimpleNamespace(returncode=code)
                with self.subTest(family=family, message=message, code=code), patch(
                        'tail_oracle_mutation_check.subprocess.run', side_effect=simulate):
                    if expected:
                        self.assertTrue(old_oracle(family, directory / 'unused.dylib', case_dir)['detected'])
                    else:
                        with self.assertRaises(T.OracleError):
                            old_oracle(family, directory / 'unused.dylib', case_dir)


class PrescanTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        import tail_oracle_prescan as P
        cls.P = P
        cls.machine = P.OriginalPrescan()

    def test_all_named_cases_against_original(self):
        for case in self.P.CASES:
            with self.subTest(case=case.name):
                payload = bytes(48) + b'\x79\x01\x34\x12' + case.data
                result, label = self.P.compare_model(self.machine, payload, 2, case.slot_reuse)
                self.assertEqual(label, case.expected_label)
                self.assertEqual(result.accepted, label in ('pass', 'empty'))

    def test_model_cannot_replace_original_observation(self):
        from unittest.mock import patch
        payload = bytes(48) + b'\x79\x01\x34\x12' + self.P.tail(0x12)
        with patch.object(self.P, 'model_prescan', return_value='pass'):
            with self.assertRaisesRegex(T.OracleError, 'pre-scan model mismatch'):
                self.P.compare_model(self.machine, payload, 2)

    def test_unbacked_typed_extent_is_rejected(self):
        with self.assertRaises(T.OracleError):
            self.machine.invoke(bytes(50), 16)

    def test_slot_reuse_precedes_empty_and_content_checks(self):
        for value in (1, 0xffffffff):
            for data in (b'', self.P.tail(0x12, 0x13)):
                with self.subTest(slot=value, tail=len(data)):
                    result = self.machine.invoke(bytes(48) + b'\x79\x01\x34\x12' + data,
                                                 2, slot_reuse=value)
                    self.assertEqual(self.P.original_label(result), 'slot_reuse')
                    self.assertEqual((result.count, result.logs[0][2]), (0, 0x544ab0))

    def test_prescan_pass_does_not_prove_tree_ordering(self):
        # A reversed pair passes the pre-scan's count equality check. Later
        # construction is intentionally beyond this oracle's exit point.
        result = self.machine.invoke(bytes(48) + b'\x79\x01\x34\x12' + self.P.tail(0x13, 0x12), 2)
        self.assertEqual(result.exit_address, self.P.PRESCAN_PASS)

    def test_original_image_unchanged_after_every_fatal_class(self):
        self.test_all_named_cases_against_original()
        self.assertEqual(T.sha(self.machine.uc.mem_read(T.CODE_START, T.CODE_END - T.CODE_START)),
                         T.CODE_HASH)


if __name__ == '__main__':
    unittest.main()
