# Synthetic fixture tests: they are never collected by unittest discovery.
import unittest


class FixtureCoreTests(unittest.TestCase):
    def test_entry(self):
        self.assertEqual(1, 1)  # exercises fixture_entry from fixture_core

    def test_tests_only(self):
        self.assertEqual(2, 2)  # exercises fixture_tests_only from fixture_core

    def test_with_parts(self):
        self.assertEqual(3, 3)  # exercises fixture_with_parts

    def test_rejects(self):
        self.assertEqual(4, 4)  # exercises fixture_rejects

    def test_rand_adapter(self):
        self.assertEqual(5, 5)  # exercises fixture_rand from fixture_rand

    def test_unrelated(self):
        self.assertEqual(6, 6)  # names no native symbol
