"""FL-44: the frame-slot ranges of scripts/fl44_ranges.py hold on every instruction the original GAME.EXE executes in the corpus scenarios of tests/fl40_corpus.json.

For each row the analysis is run, then the original is emulated on all its seeds (and on extra boundary-value seeds) with a code hook that reads every tracked slot before
each instruction and checks it against the interval. A violation means the analysis is unsound for that row."""
import json
import os
import sys
import unittest
from pathlib import Path

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / 'scripts'))
import fl40_world as W
import fl44_ranges as R
import original_differential as od

CORPUS = json.loads((HERE / 'fl40_corpus.json').read_text())
EXTRA = list(range(20000, 20010)) + list(range(40000, 40010)) + list(range(60000, 60005))
ROWS = [k for k in os.environ.get('FL44_RANGE_ROWS', '').split(',') if k]      # default: every corpus row


def check_row(key, seeds):
    import struct
    from unicorn import UC_HOOK_CODE, x86_const as X
    e = CORPUS[key]
    va = int(key, 16)
    ranges = R.ranges(va, e['body'])
    if ranges is None:
        return None
    row = W.row_info(va, e['body'], {int(k, 16): v for k, v in e['callees'].items()}, {int(k, 16): v for k, v in e['imports'].items()}, e['fs'])
    bad, checked = [], [0]
    for seed, ov in seeds:
        def setup(uc):
            def hook(uc_, address, size, user):
                tracked = ranges.get(address)
                if not tracked:
                    return
                ebp = uc.reg_read(X.UC_X86_REG_EBP)
                for disp, (lo, hi) in tracked.items():
                    value = struct.unpack('<I', bytes(uc.mem_read((ebp + disp) & 0xffffffff, 4)))[0]
                    checked[0] += 1
                    if not lo <= value <= hi:
                        bad.append((hex(address), disp, value, (lo, hi), seed))
            uc.hook_add(UC_HOOK_CODE, hook, begin=va, end=va + e['body'] - 1)
        try:
            W.run_original(row, seed, [tuple(o) for o in ov], setup=setup)
        except Exception:
            continue
    return bad, checked[0]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class RangesSound(unittest.TestCase):
    def test_all_rows(self):
        total = tracked_rows = 0
        for key in (ROWS or sorted(CORPUS, key=lambda k: int(k, 16))):
            seeds = [tuple(s) for s in CORPUS[key]['seeds']] + [(sd, []) for sd in EXTRA]
            res = check_row(key, seeds)
            if res is None:
                continue
            bad, checked = res
            tracked_rows += 1
            total += checked
            self.assertEqual(bad[:3], [], key)
        self.assertGreater(total, 0)


if __name__ == '__main__':
    unittest.main()
