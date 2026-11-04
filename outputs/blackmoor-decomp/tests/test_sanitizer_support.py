"""A failed leak tool must never be counted as a detected code mutation."""
import subprocess
import unittest
from unittest.mock import patch

import sanitizer_support as support


def report(code, count=None):
    stdout = '' if count is None else f'Process 123: {count} leaks for {count * 16} total leaked bytes.\n'
    return subprocess.CompletedProcess([], code, stdout, 'diagnostic')


class LeakVerdicts(unittest.TestCase):
    def test_clean_and_leaking_reports(self):
        for result, expected in ((report(0, 0), 'survived'), (report(1, 2), 'killed')):
            with self.subTest(expected), patch.object(support.subprocess, 'run', return_value=result):
                self.assertEqual(support.leaks_verdict('fixture'), expected)

    def test_tool_failures_do_not_kill_mutants(self):
        for result in (report(2), report(-9), report(1), report(0), report(1, 0), report(0, 1)):
            with self.subTest(result=result), patch.object(support.subprocess, 'run', return_value=result):
                with self.assertRaises(support.LeakCheckerError):
                    support.leaks_verdict('fixture')

    def test_timeout_is_a_checker_error(self):
        with patch.object(support.subprocess, 'run', side_effect=subprocess.TimeoutExpired('leaks', 1)):
            with self.assertRaises(support.LeakCheckerError):
                support.leaks_verdict('fixture', timeout=1)

    def test_transient_tool_failure_is_retried(self):
        with patch.object(support.subprocess, 'run', side_effect=[report(2), report(0, 0)]):
            self.assertEqual(support.leaks_verdict('fixture'), 'survived')

    def test_missing_checker_is_explicit(self):
        with patch.object(support, 'leak_checker', return_value=None):
            with self.assertRaisesRegex(support.LeakCheckerError, 'cannot be judged'):
                support.require_leak_checker('sanitizer-compiler', 'plain-compiler')

    def test_unexpected_lsan_failure_is_not_downgraded(self):
        failed = subprocess.CompletedProcess([], 1, '', 'LeakSanitizer has encountered a fatal error under ptrace')
        with patch.object(support, '_build_and_run', return_value=failed):
            with self.assertRaises(support.LeakCheckerError):
                support.sanitizer_leak_status('mock-fatal-lsan-compiler')


if __name__ == '__main__':
    unittest.main()
