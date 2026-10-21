#!/usr/bin/env python3
"""FL-34 (batch c): original-x86 oracle for the eight spill rows of FL-32 (0x4d0abc, 0x4d0c17, 0x4e01fb, 0x4cca9c, 0x446f77, 0x4fce5e, 0x4d3ffe, 0x47a3d9).

Runs ONLY the original bytes (Unicorn, no native library) on the fixtures of tests/fl34c_fixtures.py, the same generator and the same original-run function that
tests/test_fl34c_differential.py uses against the native port. The hooks are the OS and host boundaries only: the recording stubs of the callees that the fixtures name
(0x4c5377, 0x4cc962, 0x51d716, 0x4f7e93, 0x4dad60, 0x4789d6; entered by address, they pop their stack arguments, return a scripted value and, where a scenario needs a
callee that changes `self` or a global, store scripted values). Nothing inside a function under test is patched; every compare, index computation and store runs as original
instructions. The oracle also checks the number of bytes each function popped (0x10 for 0x4cca9c, 4 for 0x4fce5e, 0 for the others) and that 0x446f77 returns this.

Prints one line per function:  0x<va> instructions <executed>/<total> branch-directions <taken>/<total> scenarios <n> digest <sha256 of the ordered calls and the memory
read back, over all scenarios>. Exits 0 only when every instruction of every function was executed and both directions of every conditional jump were taken (the allowlist
fl34c_fixtures.UNTAKEN_ALLOWED is empty). No original bytes or memory dumps are printed. Run from outputs/blackmoor-decomp:  python3 tests/fl34c_original_oracle.py
"""
import hashlib
from pathlib import Path
import random
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
import fl34c_fixtures as fx


def main():
    if not od.available():
        print('needs Unicorn and the pinned private work/original/GAME.EXE', file=sys.stderr)
        return 2
    status = 0
    for key in fx.KEYS:
        spec = fx.SPECS[key]
        rng = random.Random(int(key, 16))
        count = fx.scenarios(key)
        executed, edges = set(), set()
        chain = hashlib.sha256()
        for n in range(count):
            orig, _, digest = fx.run_original(fx.build(key, rng, n))
            executed |= orig.executed
            edges |= orig.edges
            chain.update(digest.encode())
        total = od.instruction_addresses(spec['va'], spec.get('code', spec['size']))
        missing = sorted(total - executed)
        unexpected, stale, directions = fx.check_edges(key, edges)
        print('0x%x instructions %d/%d branch-directions %d/%d scenarios %d digest %s' % (spec['va'], len(total) - len(missing), len(total),
              directions - len(fx.untaken_edges(key, edges)), directions, count, chain.hexdigest()))
        if unexpected or stale:
            print('  untaken conditional-jump directions: %s; stale allowlist entries: %s' % ([(hex(a), d) for a, d in unexpected], [hex(a) for a, _ in stale]), file=sys.stderr)
            status = 1
        if missing:
            print('  never executed: %s' % ' '.join(hex(a) for a in missing[:16]), file=sys.stderr)
            status = 1
    return status


if __name__ == '__main__':
    sys.exit(main())
