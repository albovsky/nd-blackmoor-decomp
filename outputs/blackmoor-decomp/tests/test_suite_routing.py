"""Architecture routing must preserve every discovered test, including duplicates."""
import importlib.util
import json
from pathlib import Path
import unittest

path = Path(__file__).resolve().parents[3] / 'script/run_test_suite.py'
spec = importlib.util.spec_from_file_location('canonical_suite_routing', path)
routing = importlib.util.module_from_spec(spec)
spec.loader.exec_module(routing)


def marker(module):
    case = type('Marker', (unittest.TestCase,), {'__module__': module, 'runTest': lambda self: None})
    return case()


class SuiteRouting(unittest.TestCase):
    def test_partition_preserves_nested_cases_and_duplicates(self):
        native = marker('test_native_app')
        old_port = marker('test_fl30a_differential')
        reference = marker('test_fl66_tested_equivalent')
        suite = unittest.TestSuite([native, unittest.TestSuite([reference, old_port, reference])])
        selected, forwarded = routing.split_suite(suite, True)
        self.assertEqual(list(routing.cases(selected)), [native, old_port])
        self.assertEqual(forwarded, [reference, reference])
        self.assertEqual(selected.countTestCases() + len(forwarded), suite.countTestCases())

    def test_other_hosts_keep_the_complete_suite(self):
        items = [marker('test_native_app'), marker('test_fl66_tested_equivalent')]
        native, reference = routing.split_suite(unittest.TestSuite(items), False)
        self.assertEqual(list(routing.cases(native)), items)
        self.assertEqual(reference, [])

    def test_import_errors_and_unrelated_names_stay_visible(self):
        items = [marker('unittest.loader'), marker('test_native_fl66'), marker('test_fl_differential')]
        native, reference = routing.split_suite(unittest.TestSuite(items), True)
        self.assertEqual(list(routing.cases(native)), items)
        self.assertEqual(reference, [])

    def test_every_existing_x87_host_test_routes_to_reference(self):
        for source in path.parents[1].joinpath('outputs/blackmoor-decomp/tests').glob('test_*.py'):
            text = source.read_text()
            if source.name == Path(__file__).name or not ('X87_HOST' in text or 'x86 host' in text):
                continue
            with self.subTest(source=source.name):
                native, reference = routing.split_suite(unittest.TestSuite([marker(source.stem)]), True)
                self.assertEqual(native.countTestCases(), 0)
                self.assertEqual(len(reference), 1)

    def test_letter_suffixed_reference_modules_route(self):
        native, reference = routing.split_suite(unittest.TestSuite([marker('test_fl45a_reference')]), True)
        self.assertEqual(native.countTestCases(), 0)
        self.assertEqual(len(reference), 1)

    def test_reference_receipt_requires_actual_complete_success(self):
        names = ['test.reference.a', 'test.reference.a', 'test.reference.b']
        receipt = dict(tests_run=3, successful=True, executed_ids=names[::-1],
                       skipped=[], expected_failures=[], unexpected_successes=[])
        self.assertTrue(routing.reference_passed(0, receipt, names))
        self.assertFalse(routing.reference_passed(1, receipt, names))
        self.assertFalse(routing.reference_passed(0, None, names))
        for field, value in [('tests_run', 2), ('successful', False),
                             ('executed_ids', ['test.reference.a', 'test.reference.b', 'test.reference.b']),
                             ('skipped', [['test.reference.a', 'needs x86 host']]),
                             ('expected_failures', ['test.reference.a']),
                             ('unexpected_successes', ['test.reference.a'])]:
            with self.subTest(field=field):
                changed = dict(receipt)
                changed[field] = value
                self.assertFalse(routing.reference_passed(0, changed, names))
        self.assertTrue(routing.reference_passed(0, json.loads(json.dumps(receipt)), names))

    def test_discovery_options_are_already_applied_before_child(self):
        options = ['-v', '-p', 'test_fl*.py', '--start-directory=tests', '-t.', '-k', 'reference']
        self.assertEqual(routing.reference_options(options), ['-v', '-k', 'reference'])


if __name__ == '__main__':
    unittest.main()
