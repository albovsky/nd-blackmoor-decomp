#!/usr/bin/env python3
"""Run native checks and the Intel-only x87 reference model without dropping tests."""
import json
import argparse
import os
from pathlib import Path
import platform
import re
import subprocess
import sys
import tempfile
import unittest

WORKSPACE = Path(__file__).resolve().parents[1]
TESTS = WORKSPACE / 'outputs/blackmoor-decomp/tests'
sys.dont_write_bytecode = True


def cases(suite):
    for item in suite:
        if isinstance(item, unittest.TestSuite):
            yield from cases(item)
        else:
            yield item


def split_suite(suite, separate_x87):
    native, reference = [], []
    for test in cases(suite):
        # FL40 and later test the original-x86 translation/proof model. Its
        # headers explicitly require Intel long double and x87 instructions.
        match = re.fullmatch(r'test_fl(\d+)[a-z]?(?:_.*)?', type(test).__module__)
        target = reference if separate_x87 and match and int(match[1]) >= 40 else native
        target.append(test)
    return unittest.TestSuite(native), reference


class RecordingResult(unittest.TextTestResult):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.executed_ids = []

    def startTest(self, test):
        self.executed_ids.append(test.id())
        super().startTest(test)


class RecordingRunner(unittest.TextTestRunner):
    resultclass = RecordingResult


def reference_passed(returncode, completed, expected_ids):
    return (returncode == 0 and isinstance(completed, dict)
            and completed.get('successful') is True
            and completed.get('tests_run') == len(expected_ids)
            and sorted(completed.get('executed_ids', [])) == sorted(expected_ids)
            and completed.get('skipped') == []
            and completed.get('expected_failures') == []
            and completed.get('unexpected_successes') == [])


def reference_options(options):
    # Discovery has already selected the exact IDs. Its directory/pattern flags
    # are not valid options for unittest's subsequent explicit-ID invocation.
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('-s', '--start-directory')
    parser.add_argument('-p', '--pattern')
    parser.add_argument('-t', '--top-level-directory')
    _, remaining = parser.parse_known_args(options)
    return remaining


class ArchitectureLoader(unittest.TestLoader):
    def __init__(self, separate_x87):
        super().__init__()
        self.separate_x87 = separate_x87
        self.reference = []

    def discover(self, *args, **kwargs):
        complete = super().discover(*args, **kwargs)
        native, self.reference = split_suite(complete, self.separate_x87)
        if native.countTestCases() + len(self.reference) != complete.countTestCases():
            raise RuntimeError('suite routing changed the number of discovered tests')
        print(f'Suite routing: native={native.countTestCases()} x87={len(self.reference)} '
              f'total={complete.countTestCases()}', flush=True)
        return native


def main(options=None):
    options = list(sys.argv[1:] if options is None else options)
    if options[:1] == ['--x87-child']:
        request = json.loads(Path(options[1]).read_text())
        sys.path.insert(0, str(TESTS))
        program = unittest.main(module=None, argv=['unittest', *request['names'], *request['options']],
                                testRunner=RecordingRunner, exit=False)
        result = program.result
        completed = {'tests_run': result.testsRun, 'successful': result.wasSuccessful(),
                     'executed_ids': result.executed_ids,
                     'skipped': [(test.id(), reason) for test, reason in result.skipped],
                     'expected_failures': [test.id() for test, _ in result.expectedFailures],
                     'unexpected_successes': [test.id() for test in result.unexpectedSuccesses]}
        Path(request['result']).write_text(json.dumps(completed))
        if not reference_passed(0, completed, request['names']):
            print('Reference checks require every selected test to execute and pass without skips.', file=sys.stderr)
            return 1
        return 0

    separate = platform.system() == 'Darwin' and platform.machine().lower() in ('arm64', 'aarch64')
    interpreter = Path(os.environ.get('BLACKMOOR_X87_PYTHON',
                                     WORKSPACE / 'work/tools/oracle-x87-python313/bin/python3'))
    if separate and not any(flag in options for flag in ('-h', '--help')):
        if not interpreter.is_file():
            raise RuntimeError('x87 reference Python missing; set BLACKMOOR_X87_PYTHON to an x86 Python 3.10+ '
                               'with Unicorn, Capstone, pefile and z3-solver (see recomp/PORTABILITY-VERIFICATION.md)')
        probe = subprocess.run(['/usr/bin/arch', '-x86_64', str(interpreter), '-c',
                                'import platform,sys,unicorn,capstone,pefile,z3\n'
                                'assert platform.machine()=="x86_64" and sys.version_info >= (3,10)\n'
                                'print("blackmoor-x87-ready")'],
                               capture_output=True, text=True)
        if probe.returncode or probe.stdout.strip() != 'blackmoor-x87-ready':
            raise RuntimeError('x87 reference Python is not usable: ' + probe.stderr[-1000:])

    loader = ArchitectureLoader(separate)
    program = unittest.main(module=None,
                            argv=['unittest', 'discover', '-s', str(TESTS), '-p', 'test_*.py', *options],
                            testLoader=loader, exit=False)
    native_ok = program.result.wasSuccessful()
    reference_ok = True
    if loader.reference:
        with tempfile.TemporaryDirectory(prefix='blackmoor-x87-checks-') as scratch:
            directory = Path(scratch)
            compiler = directory / 'cc'
            compiler.write_text('#!/bin/sh\nexec /usr/bin/xcrun --sdk macosx clang -arch x86_64 "$@"\n')
            compiler.chmod(0o755)
            request = directory / 'tests.json'
            receipt = directory / 'result.json'
            request.write_text(json.dumps({'names': [test.id() for test in loader.reference],
                                           'options': reference_options(options),
                                           'result': str(receipt)}))
            environment = dict(os.environ, CC=str(compiler), FL66_CACHE=str(directory / 'cache'))
            environment['PATH'] = str(directory) + os.pathsep + environment.get('PATH', '')
            print(f'Running all {len(loader.reference)} x87 reference checks under existing Rosetta support.', flush=True)
            result = subprocess.run(['/usr/bin/arch', '-x86_64', str(interpreter), str(Path(__file__).resolve()),
                                     '--x87-child', str(request)], env=environment)
            reference_ok = False
            if result.returncode == 0 and receipt.is_file():
                completed = json.loads(receipt.read_text())
                reference_ok = reference_passed(result.returncode, completed,
                                                 [test.id() for test in loader.reference])
            if not reference_ok:
                print('Reference checks did not return a complete passing result.', file=sys.stderr)
    return int(not (native_ok and reference_ok))


if __name__ == '__main__':
    raise SystemExit(main())
