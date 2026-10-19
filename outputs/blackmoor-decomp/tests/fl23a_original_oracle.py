#!/usr/bin/env python3
"""FL-23 (batch a) original-x86 oracle: runs ONLY the original GAME.EXE bytes of the hit-test handlers called from 0x4f0059 under Unicorn,
on the fixtures of tests/fl23a_fixtures.py (the same ones tests/test_fl23a_differential.py compares the native port on), and checks that
every instruction of each function body ran at least once.

Hooks (OS or host boundaries only; nothing inside a function under test is patched): recording stubs at the entry of the callees
0x4a1e93, 0x4ba486, 0x459ddc, 0x487dcf, 0x48aa66, 0x48e776, 0x478396, 0x479f72, 0x46ebbd and 0x4ab706. A stub logs the ecx and stack
arguments, the call-time state that the scenario asked to see, and returns a scripted value in eax.

Prints one line per function: `0x... instructions N/N scenarios M digest <sha256>` (the digest covers the ordered call and memory
observations of all scenarios; it prints no original bytes). Exit status 0 only if every function is fully covered.
Run from outputs/blackmoor-decomp:  python3 tests/fl23a_original_oracle.py
"""
import hashlib
from pathlib import Path
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
import fl23a_fixtures as fx


def run_function(va):
    """Runs all scenarios of one function on the original bytes. Returns (executed instruction addresses, scenario count, digest)."""
    executed = set()
    total = hashlib.sha256()
    scenarios = fx.scenarios(va)
    for spec in scenarios:
        orig, calls = fx.run_original(spec)
        if orig.cleanup != 8:
            raise AssertionError('0x%x popped %d bytes, expected 8' % (va, orig.cleanup))
        executed |= orig.executed
        total.update(fx.digest(orig, calls).encode())
    return executed, len(scenarios), total.hexdigest()


def main():
    if not od.available():
        print('needs Unicorn and the pinned work/original/GAME.EXE', file=sys.stderr)
        return 2
    failed = 0
    for va, span, _name, _gen in fx.FUNCTIONS:
        executed, count, digest = run_function(va)
        wanted = od.instruction_addresses(va, span)
        reached = len(wanted & executed)
        print('0x%x instructions %d/%d scenarios %d digest %s' % (va, reached, len(wanted), count, digest))
        if reached != len(wanted):
            failed += 1
            print('  not reached: %s' % [hex(a) for a in sorted(wanted - executed)][:20], file=sys.stderr)
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main())
