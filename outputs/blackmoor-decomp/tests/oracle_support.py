"""Guards for tests that need the original-x86 oracle toolchain (QA-1).

The oracles run unmodified original routines under Unicorn, which is installed
only in work/tools/oracle-python. A plain `python3 -m unittest` therefore cannot
run them. These helpers turn that into an explicit, explained outcome:

* default: `unittest.SkipTest` whose reason names the running interpreter and
  the supported entry points;
* BLACKMOOR_REQUIRE_ORACLE=1 (set by script/run_test_suite.sh): the same
  condition raises `OracleRequiredError`, a hard failure, never a skip.

Call the guards from setUpClass or from the test body. Do not catch ImportError
inside oracle internals.
"""

from __future__ import annotations

import os
import sys
import unittest
from pathlib import Path

REQUIRE_ENV = "BLACKMOOR_REQUIRE_ORACLE"
WORKSPACE = Path(__file__).resolve().parents[3]
ORACLE_PYTHON = WORKSPACE / "work/tools/oracle-python/bin/python"

_ADVICE = (
    "run the suite with work/tools/oracle-python/bin/python or "
    "script/run_test_suite.sh"
)


class OracleRequiredError(AssertionError):
    """The oracle toolchain is missing while BLACKMOOR_REQUIRE_ORACLE=1."""


def oracle_required() -> bool:
    return os.environ.get(REQUIRE_ENV) == "1"


def _unavailable(what: str) -> None:
    if oracle_required():
        raise OracleRequiredError(
            f"{what}; {REQUIRE_ENV}=1 forbids skipping oracle tests: {_ADVICE}"
        )
    raise unittest.SkipTest(
        f"{what}; {_ADVICE} (set {REQUIRE_ENV}=1 to make this a failure)"
    )


def require_unicorn() -> None:
    """Skip (or, when the oracle is required, fail) unless `import unicorn` works."""
    try:
        import unicorn  # noqa: F401
    except ImportError:
        _unavailable(f"unicorn is not importable by {sys.executable}")


def require_oracle_python(path: Path | None = None) -> Path:
    """Return the oracle interpreter, or skip/fail when it is not installed."""
    interpreter = Path(path) if path is not None else ORACLE_PYTHON
    if not (interpreter.is_file() and os.access(interpreter, os.X_OK)):
        _unavailable(f"oracle interpreter {interpreter} is not installed")
    return interpreter
