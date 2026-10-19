#!/usr/bin/env python3
"""FL-23 (batch b): original-x86 oracle for the twelve click handlers of GAME.EXE that 0x43a7ca calls.

Runs ONLY the original bytes (Unicorn, no native library) on the fixtures of tests/fl23b_fixtures.py, the same generator and the same
original-run function that tests/test_fl23b_differential.py uses against the native port. The hooks are the OS and host boundaries only:
the recording stubs of the callees 0x4fb2e3, 0x4f6334, 0x4fb77a, 0x4e26fc and 0x45e6bd (by entry address; they return a scripted value and pop
their stack arguments) and the GetTickCount import slot 0x52a23c. Nothing inside a function under test is patched; every guard, compare,
index computation and store of the twelve bodies runs as original instructions.

Prints one line per function:  0x<va> instructions <executed>/<total> scenarios <n> digest <sha256 of the ordered calls and the memory
read back, over all scenarios>. Exits 0 only when every instruction of every function was executed. No original bytes or memory dumps are
printed. Run from outputs/blackmoor-decomp:  python3 tests/fl23b_original_oracle.py
"""
import hashlib
from pathlib import Path
import random
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
import fl23b_fixtures as fx


def main():
    if not od.available():
        print('needs Unicorn and the pinned private work/original/GAME.EXE', file=sys.stderr)
        return 2
    status = 0
    for key in fx.KEYS:
        spec = fx.SPECS[key]
        rng = random.Random(int(key, 16))
        executed = set()
        chain = hashlib.sha256()
        for n in range(fx.SCENARIOS):
            orig, _, digest = fx.run_original(fx.build(key, rng, n))
            executed |= orig.executed
            chain.update(digest.encode())
        total = od.instruction_addresses(spec['va'], spec['size'])
        missing = sorted(total - executed)
        print('0x%x instructions %d/%d scenarios %d digest %s' % (spec['va'], len(total) - len(missing), len(total), fx.SCENARIOS, chain.hexdigest()))
        if missing:
            print('  never executed: %s' % ' '.join(hex(a) for a in missing[:16]), file=sys.stderr)
            status = 1
    return status


if __name__ == '__main__':
    sys.exit(main())
