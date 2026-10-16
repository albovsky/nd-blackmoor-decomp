"""FL-8 executed-range recorder (loaded as sitecustomize; inert unless enabled).

Set BLACKMOOR_EXEC_TRACE_DIR and put this directory first on PYTHONPATH.  Every
Unicorn instance an oracle creates gets one extra UC_HOOK_CODE hook, installed
just before each emu_start so it runs after the oracle's own hooks.  The hook
records an instruction only when it really executes: if an earlier hook moved
EIP (an oracle replacing an original routine by a Python seam), the original
bytes at that address did not run and are not recorded.

Counts are kept per "key": the test id while a unittest test runs, otherwise
BLACKMOOR_EXEC_LABEL, otherwise the script path.  A subprocess started by a
test inherits the key through BLACKMOOR_EXEC_LABEL.  Traces are flushed at exit
to one JSON file per process; scripts/record_function_execution.py merges them.
Only instruction addresses, sizes and hit counts are written (no bytes).
"""

import atexit
import json
import os
import sys

TRACE_DIR = os.environ.get("BLACKMOOR_EXEC_TRACE_DIR")
TEXT_BEGIN, TEXT_END = 0x401000, 0x52925A
TIMEOUT_SCALE = 20

if TRACE_DIR:
    _traces = {}
    _outcomes = {}
    _state = {"key": None}

    def _key():
        return (_state["key"] or os.environ.get("BLACKMOOR_EXEC_LABEL")
                or os.path.abspath(sys.argv[0] if sys.argv and sys.argv[0] else "-"))

    def _install_unicorn():
        try:
            import unicorn
            from unicorn import UC_HOOK_CODE
            from unicorn.x86_const import UC_X86_REG_EIP
        except Exception:
            return
        original_start = unicorn.Uc.emu_start
        original_write = unicorn.Uc.reg_write
        written = {}            # id(Uc) -> True when EIP was written since the last recorded instruction

        def reg_write(self, reg_id, value):
            if reg_id == UC_X86_REG_EIP:
                written[id(self)] = True
            return original_write(self, reg_id, value)

        def emu_start(self, *args, **kwargs):
            ident = id(self)
            written[ident] = False
            # the recorder is slower than the oracle alone: a wall-clock guard must not fire because of it
            if len(args) > 2 and args[2]:
                args = (*args[:2], args[2] * TIMEOUT_SCALE, *args[3:])
            elif kwargs.get("timeout"):
                kwargs["timeout"] = kwargs["timeout"] * TIMEOUT_SCALE
            # (re)install the recorder hook before every start so that it runs after every hook the oracle added
            handle = getattr(self, "_fl8_hook", None)
            if handle is not None:
                self.hook_del(handle)

            def on_code(uc, address, size, user, ident=ident):
                if written[ident]:          # EIP was written: only then pay for a register read
                    written[ident] = False
                    if uc.reg_read(UC_X86_REG_EIP) != address:
                        return              # an earlier hook moved EIP: this instruction does not run
                table = _traces.setdefault(_key(), {})
                cell = table.get(address)
                if cell is None:
                    table[address] = [size, 1]
                else:
                    cell[1] += 1

            self._fl8_hook = self.hook_add(UC_HOOK_CODE, on_code, None, TEXT_BEGIN, TEXT_END)
            return original_start(self, *args, **kwargs)

        unicorn.Uc.reg_write = reg_write
        unicorn.Uc.emu_start = emu_start

    def _install_unittest():
        import unittest
        original_run = unittest.TestCase.run

        def run(self, result=None):
            key = self.id()
            previous = _state["key"]
            _state["key"] = key
            os.environ["BLACKMOOR_EXEC_LABEL"] = key
            target = result if result is not None else self.defaultTestResult()
            before = (len(target.failures), len(target.errors), len(getattr(target, "skipped", ())),
                      len(getattr(target, "unexpectedSuccesses", ())))
            try:
                return original_run(self, result)
            finally:
                after = (len(target.failures), len(target.errors), len(getattr(target, "skipped", ())),
                         len(getattr(target, "unexpectedSuccesses", ())))
                _outcomes[key] = "passed" if after == before else "not_passed"
                _state["key"] = previous
                if previous is None:
                    os.environ.pop("BLACKMOOR_EXEC_LABEL", None)

        unittest.TestCase.run = run

    def _flush():
        if not _traces and not _outcomes:
            return
        os.makedirs(TRACE_DIR, exist_ok=True)
        payload = {
            "pid": os.getpid(),
            "argv": [os.path.abspath(sys.argv[0])] if sys.argv and sys.argv[0] else [],
            "outcomes": _outcomes,
            "traces": {
                key: sorted([a, v[0], v[1]] for a, v in table.items())
                for key, table in _traces.items()
            },
        }
        path = os.path.join(TRACE_DIR, f"{os.getpid()}-{len(os.listdir(TRACE_DIR))}.json")
        with open(path, "w") as handle:
            json.dump(payload, handle, separators=(",", ":"))

    _install_unicorn()
    try:
        _install_unittest()
    except Exception:
        pass
    atexit.register(_flush)
