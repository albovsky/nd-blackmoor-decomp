"""FL-8: the executed-range recorder and its collector.

A tiny x86 routine is run under Unicorn in a child process that loads
scripts/exec_trace/sitecustomize.py, and the written trace is merged by
scripts/record_function_execution.py.  No original bytes are involved.
"""

from __future__ import annotations

import importlib.util
import json
import os
import subprocess
import sys
import tempfile
import textwrap
import unittest
from pathlib import Path

import oracle_support

TESTS = Path(__file__).resolve().parent
PROJECT = TESTS.parent
SCRIPT = PROJECT / "scripts/record_function_execution.py"
SHIM = PROJECT / "scripts/exec_trace"

SPEC = importlib.util.spec_from_file_location("record_function_execution", SCRIPT)
rfe = importlib.util.module_from_spec(SPEC)
sys.modules["record_function_execution"] = rfe
SPEC.loader.exec_module(rfe)

# 0x401000: mov eax,1 ; call 0x401010 ; ret      0x401010: inc eax ; ret
PROGRAM = textwrap.dedent('''
    import sys
    from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE
    from unicorn.x86_const import UC_X86_REG_EIP, UC_X86_REG_ESP
    uc = Uc(UC_ARCH_X86, UC_MODE_32)
    uc.mem_map(0x401000, 0x1000)
    uc.mem_map(0x100000, 0x1000)
    uc.mem_write(0x401000, bytes.fromhex("b801000000 e806000000 c3".replace(" ", "")))
    uc.mem_write(0x401010, bytes.fromhex("40 c3".replace(" ", "")))
    redirect = sys.argv[1] == "redirect"
    def seam(uc_, address, size, user):
        if redirect and address == 0x401010:        # the oracle replaces the callee by a Python seam
            esp = uc_.reg_read(UC_X86_REG_ESP)
            uc_.reg_write(UC_X86_REG_EIP, int.from_bytes(uc_.mem_read(esp, 4), "little"))
            uc_.reg_write(UC_X86_REG_ESP, esp + 4)
    uc.hook_add(UC_HOOK_CODE, seam)
    uc.reg_write(UC_X86_REG_ESP, 0x100800)
    uc.mem_write(0x100800, (0x500000).to_bytes(4, "little"))
    uc.emu_start(0x401000, 0x500000)
''')


def run_child(trace_dir: Path, mode: str) -> None:
    environment = dict(os.environ, BLACKMOOR_EXEC_TRACE_DIR=str(trace_dir),
                       PYTHONPATH=str(SHIM))
    done = subprocess.run([sys.executable, "-c", PROGRAM, mode], env=environment,
                          capture_output=True, text=True)
    assert done.returncode == 0, done.stderr


class RecorderTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        oracle_support.require_unicorn()

    def trace(self, mode):
        with tempfile.TemporaryDirectory() as scratch:
            run_child(Path(scratch), mode)
            merged, _ = rfe.load_traces(Path(scratch))
        self.assertEqual(len(merged), 1)
        return next(iter(merged.values()))

    def test_executed_instructions_are_recorded_with_sizes_and_hits(self):
        table = self.trace("plain")
        self.assertEqual(sorted(table), [0x401000, 0x401005, 0x40100a, 0x401010, 0x401011])
        self.assertEqual(table[0x401000], [5, 1])
        self.assertEqual(table[0x401005], [5, 1])
        self.assertEqual(table[0x401011], [1, 1])

    def test_instruction_replaced_by_a_python_seam_is_not_recorded(self):
        table = self.trace("redirect")
        self.assertNotIn(0x401010, table)
        self.assertNotIn(0x401011, table)
        self.assertIn(0x40100a, table)

    def test_collector_attributes_bytes_and_entry_hits_to_functions(self):
        with tempfile.TemporaryDirectory() as scratch:
            scratch = Path(scratch)
            work = scratch / "ws"
            (work / "outputs").mkdir(parents=True)
            script = work / "outputs/x_oracle.py"
            script.write_text("pass\n")
            traces = scratch / "tr"
            traces.mkdir()
            key = str(script)
            rows = [[0x401000, 5, 2], [0x401005, 5, 2], [0x40100a, 1, 2], [0x401010, 1, 3], [0x401011, 1, 3]]
            (traces / "1-0.json").write_text(json.dumps(
                {"pid": 1, "argv": [], "outcomes": {}, "traces": {key: rows}}))
            (traces / "runs.json").write_text(json.dumps(
                [{"script": "outputs/x_oracle.py", "exit": 0, "seconds": 0.1, "tail": ""}]))
            entries = [{"va": "0x00401000", "span": 16, "code_size": 11}, {"va": "0x00401010", "span": 2, "code_size": 2}]
            xrefs = scratch / "xrefs.json"
            xrefs.write_text(json.dumps({"original_sha256": "0" * 64, "entries": entries}))
            saved = (rfe.XREFS, rfe.WORKSPACE)
            rfe.XREFS, rfe.WORKSPACE = xrefs, work
            try:
                model = rfe.derive(traces, work)
            finally:
                rfe.XREFS, rfe.WORKSPACE = saved
        self.assertEqual(model["functions"]["0x401000"], [11, [0, 2, 11, 6]])
        self.assertEqual(model["functions"]["0x401010"], [2, [0, 3, 2, 6]])
        self.assertEqual(model["runs"][0]["script"], "outputs/x_oracle.py")

    def test_bytes_outside_the_function_code_are_not_counted(self):
        with tempfile.TemporaryDirectory() as scratch:
            scratch = Path(scratch)
            work = scratch / "ws"
            (work / "outputs").mkdir(parents=True)
            (work / "outputs/x_oracle.py").write_text("pass\n")
            traces = scratch / "tr"
            traces.mkdir()
            # a 16-byte span whose code is 8 bytes; an executed thunk sits at +8
            (traces / "1-0.json").write_text(json.dumps({"pid": 1, "argv": [], "outcomes": {}, "traces": {
                str(work / "outputs/x_oracle.py"): [[0x401000, 8, 1], [0x401008, 6, 1]]}}))
            (traces / "runs.json").write_text(json.dumps(
                [{"script": "outputs/x_oracle.py", "exit": 0, "seconds": 0.1, "tail": ""}]))
            xrefs = scratch / "xrefs.json"
            xrefs.write_text(json.dumps({"original_sha256": "0" * 64,
                                         "entries": [{"va": "0x00401000", "span": 16, "code_size": 8}]}))
            saved = (rfe.XREFS, rfe.WORKSPACE)
            rfe.XREFS, rfe.WORKSPACE = xrefs, work
            try:
                model = rfe.derive(traces, work)
            finally:
                rfe.XREFS, rfe.WORKSPACE = saved
        self.assertEqual(model["functions"]["0x401000"], [8, [0, 1, 8, 1]])

    def test_a_failed_run_is_not_evidence(self):
        with tempfile.TemporaryDirectory() as scratch:
            scratch = Path(scratch)
            work = scratch / "ws"
            (work / "outputs").mkdir(parents=True)
            (work / "outputs/x_oracle.py").write_text("pass\n")
            traces = scratch / "tr"
            traces.mkdir()
            (traces / "1-0.json").write_text(json.dumps({"pid": 1, "argv": [], "outcomes": {}, "traces": {
                str(work / "outputs/x_oracle.py"): [[0x401000, 1, 1]]}}))
            (traces / "runs.json").write_text(json.dumps(
                [{"script": "outputs/x_oracle.py", "exit": 1, "seconds": 0.1, "tail": ""}]))
            xrefs = scratch / "xrefs.json"
            xrefs.write_text(json.dumps({"original_sha256": "0" * 64,
                                         "entries": [{"va": "0x00401000", "span": 16}]}))
            saved = (rfe.XREFS, rfe.WORKSPACE)
            rfe.XREFS, rfe.WORKSPACE = xrefs, work
            try:
                model = rfe.derive(traces, work)
            finally:
                rfe.XREFS, rfe.WORKSPACE = saved
        self.assertEqual(model["runs"], [])
        self.assertEqual(model["functions"], {})


if __name__ == "__main__":
    unittest.main()
