"""QA-1: the Unicorn / oracle-interpreter guard used by oracle-backed tests.

The guard must (a) skip with a reason that names the running interpreter and
the supported entry points when Unicorn or the oracle interpreter is missing,
and (b) turn the very same condition into a hard failure when
BLACKMOOR_REQUIRE_ORACLE=1, so the canonical suite can never go green by
skipping the oracles.
"""

from __future__ import annotations

import ast
import os
import re
import sys
import tempfile
import types
import unittest
from pathlib import Path
from unittest import mock

import oracle_support as support

TESTS = Path(__file__).resolve().parent
ENV = "BLACKMOOR_REQUIRE_ORACLE"


def environment(**values: str) -> mock._patch_dict:
    """Patch the process environment, removing the guard variable by default."""
    patched = {key: value for key, value in os.environ.items() if key != ENV}
    patched.update(values)
    return mock.patch.dict(os.environ, patched, clear=True)


def without_unicorn() -> mock._patch_dict:
    # A None entry makes `import unicorn` raise ImportError.
    return mock.patch.dict(sys.modules, {"unicorn": None})


def with_fake_unicorn() -> mock._patch_dict:
    return mock.patch.dict(sys.modules, {"unicorn": types.ModuleType("unicorn")})


class UnicornGuardTests(unittest.TestCase):
    def test_missing_unicorn_skips_naming_interpreter_and_entry_points(self) -> None:
        with environment(), without_unicorn():
            with self.assertRaises(unittest.SkipTest) as caught:
                support.require_unicorn()
        reason = str(caught.exception)
        self.assertIn(sys.executable, reason)
        self.assertIn("work/tools/oracle-python/bin/python", reason)
        self.assertIn("script/run_test_suite.sh", reason)
        self.assertIn(ENV, reason)

    def test_required_oracle_turns_missing_unicorn_into_a_failure_not_a_skip(self) -> None:
        with environment(**{ENV: "1"}), without_unicorn():
            with self.assertRaises(support.OracleRequiredError) as caught:
                support.require_unicorn()
        self.assertNotIsInstance(caught.exception, unittest.SkipTest)
        self.assertIsInstance(caught.exception, AssertionError)
        self.assertIn(sys.executable, str(caught.exception))
        self.assertIn("script/run_test_suite.sh", str(caught.exception))

    def test_only_the_value_one_is_strict(self) -> None:
        for value in ("", "0", "no"):
            with self.subTest(value=value), environment(**{ENV: value}), without_unicorn():
                self.assertFalse(support.oracle_required())
                with self.assertRaises(unittest.SkipTest):
                    support.require_unicorn()
        with environment(**{ENV: "1"}):
            self.assertTrue(support.oracle_required())

    def test_available_unicorn_passes_in_both_modes(self) -> None:
        for env in (environment(), environment(**{ENV: "1"})):
            with env, with_fake_unicorn():
                self.assertIsNone(support.require_unicorn())

    def test_guard_works_as_a_set_up_class_hook(self) -> None:
        class Needs(unittest.TestCase):
            @classmethod
            def setUpClass(cls) -> None:
                support.require_unicorn()

            def test_never_runs(self) -> None:  # pragma: no cover
                raise AssertionError("body must not run without unicorn")

        suite = unittest.defaultTestLoader.loadTestsFromTestCase(Needs)
        for strict, expect_skipped, expect_errors in ((False, 1, 0), (True, 0, 1)):
            env = environment(**{ENV: "1"}) if strict else environment()
            with env, without_unicorn():
                result = unittest.TestResult()
                suite.run(result)
            with self.subTest(strict=strict):
                self.assertEqual(len(result.skipped), expect_skipped)
                self.assertEqual(len(result.errors) + len(result.failures), expect_errors)


class OraclePythonGuardTests(unittest.TestCase):
    def test_missing_oracle_interpreter_skips_with_reason(self) -> None:
        with tempfile.TemporaryDirectory() as directory, environment():
            missing = Path(directory) / "work/tools/oracle-python/bin/python"
            with self.assertRaises(unittest.SkipTest) as caught:
                support.require_oracle_python(missing)
        reason = str(caught.exception)
        self.assertIn(str(missing), reason)
        self.assertIn("script/run_test_suite.sh", reason)

    def test_missing_oracle_interpreter_fails_when_required(self) -> None:
        with tempfile.TemporaryDirectory() as directory, environment(**{ENV: "1"}):
            missing = Path(directory) / "oracle-python/bin/python"
            with self.assertRaises(support.OracleRequiredError):
                support.require_oracle_python(missing)

    def test_present_oracle_interpreter_is_returned(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            interpreter = Path(directory) / "python"
            interpreter.write_text("#!/bin/sh\n", encoding="utf-8")
            interpreter.chmod(0o755)
            for env in (environment(), environment(**{ENV: "1"})):
                with env:
                    self.assertEqual(support.require_oracle_python(interpreter), interpreter)

    def test_non_executable_oracle_interpreter_counts_as_missing(self) -> None:
        with tempfile.TemporaryDirectory() as directory, environment():
            interpreter = Path(directory) / "python"
            interpreter.write_text("", encoding="utf-8")
            interpreter.chmod(0o644)
            with self.assertRaises(unittest.SkipTest):
                support.require_oracle_python(interpreter)

    def test_default_path_is_the_workspace_oracle_interpreter(self) -> None:
        self.assertEqual(
            support.ORACLE_PYTHON,
            support.WORKSPACE / "work/tools/oracle-python/bin/python",
        )
        self.assertEqual(support.WORKSPACE / "outputs/blackmoor-decomp/tests", TESTS)


class GuardCoverageTests(unittest.TestCase):
    """Anti-regression: shell-outs to the oracle interpreter must be guarded."""

    def test_every_test_that_runs_the_oracle_interpreter_uses_the_guard(self) -> None:
        offenders = []
        for path in sorted(TESTS.glob("test_*.py")):
            text = path.read_text(encoding="utf-8")
            tree = ast.parse(text)
            docstring = ast.get_docstring(tree, clean=False)
            literals = [node.value for node in ast.walk(tree)
                        if isinstance(node, ast.Constant) and isinstance(node.value, str)
                        and node.value != docstring]
            if (not any("oracle-python" in value for value in literals)
                    or path.name == Path(__file__).name):
                continue
            if "oracle_support" not in text or "require_oracle_python" not in text:
                offenders.append(path.name)
        self.assertEqual(offenders, [], "unguarded oracle-python shell-outs")

    def test_in_process_unicorn_oracles_are_guarded_at_the_known_sites(self) -> None:
        # The five sites that fail under a plain interpreter (QA-1 baseline).
        expected = {
            "test_tail_oracle.py": 4,
            "test_caption_compositor.py": 1,
        }
        for name, minimum in expected.items():
            text = (TESTS / name).read_text(encoding="utf-8")
            with self.subTest(file=name):
                self.assertGreaterEqual(len(re.findall(r"require_unicorn\(\)", text)), minimum)


if __name__ == "__main__":
    unittest.main()
