"""Architecture routing must preserve every discovered test, including duplicates."""
import importlib.util
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


if __name__ == '__main__':
    unittest.main()
