"""Native LP64 host layout and returned-flags macros; synthetic data only."""
from pathlib import Path
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]


class RecompFlagsTests(unittest.TestCase):
    def test_host_layout_and_returned_flags(self):
        with tempfile.TemporaryDirectory(prefix="blackmoor-flags-") as temporary:
            binary = Path(temporary) / "recomp-flags-fixture"
            command = ["cc", "-std=c11", "-O0", "-Wall", "-Wextra",
                       "-I" + str(PROJECT / "src"),
                       str(PROJECT / "tests/recomp_flags_fixture.c"), "-o", str(binary)]
            build = subprocess.run(command, capture_output=True, text=True, timeout=30)
            self.assertEqual(build.returncode, 0, build.stdout + build.stderr)
            run = subprocess.run([str(binary)], capture_output=True, text=True, timeout=10)
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            self.assertEqual(sum(line.startswith("PASS ") for line in run.stdout.splitlines()), 6, run.stdout)
            print(run.stdout, end="")


if __name__ == "__main__":
    unittest.main()
