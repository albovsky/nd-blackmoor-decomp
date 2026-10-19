#!/usr/bin/env python3
"""FL-27 (batch a): original-x86 oracle for the action 0x35 (movie) runtime methods of GAME.EXE listed in tasks/FL-27-action-family-35-runtime.md (batch a).

Runs ONLY the original bytes (Unicorn, no native library) on the fixtures of tests/fl27a_fixtures.py, the same generator and the same
original-run function that tests/test_fl27a_differential.py uses against the native port. The hooks are the OS and host boundaries only:
the recording stubs of the callees listed in fl27a_fixtures.SHAPES (by entry address) and of the imports in fl27a_fixtures.IAT_SHAPES (by IAT
slot: Sleep and the Bink calls); they return a scripted value, pop their stack arguments, and may store a value at their n-th call (the
other thread of a waiting loop) or stop the run (AfxEndThread). Nothing inside a function under test is patched; every guard, compare,
index computation and store of the bodies runs as original instructions.

Prints one line per function:  0x<va> instructions <executed>/<total> branch-directions <taken>/<total> scenarios <n> digest <sha256 of the ordered calls and the memory
read back, over all scenarios>. Exits 0 only when every instruction of every function was executed and both directions of every conditional jump were taken (except the
allowlisted edge in fl27a_fixtures.UNTAKEN_ALLOWED). No original bytes or memory dumps are
printed. Run from outputs/blackmoor-decomp:  python3 tests/fl27a_original_oracle.py
"""
import hashlib
from pathlib import Path
import random
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
import fl27a_fixtures as fx


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
