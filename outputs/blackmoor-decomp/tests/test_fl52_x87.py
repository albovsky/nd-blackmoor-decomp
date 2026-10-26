"""FL-52: the x87 support of the FL-41 stack (rows at or above 0x480000): scripts/lift_fl41.py, src/original_methods_fl41_x87.h, tests/fl41_world.py.

* the lifter takes rows with fld/fild and the C it writes compiles;
* the census of lifted rows rose above the 189 of FL-48 and no row is refused for 'fild at' / 'fld at' any more;
* the FPU model of the translation (the host's x87 unit) agrees with the original bytes under Unicorn on small x87 rows, on plain seeds and on float seeds
  (final registers, the ordered writes, the ordered stub calls, and the whole x87 state: status word, control word, the registers in 80 bits);
* the seeds of the existing rows are unchanged (float seeds start at 100000).
"""
import contextlib
import io
import json
from pathlib import Path
import platform
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import original_differential as od
import fl41_world as W
import lift_fl41 as L

X87_HOST = platform.machine().lower() in ('x86_64', 'amd64', 'i386', 'i686')
# small x87 rows that were refused for 'fild at' / 'fld at' before FL-52: fild + fstp + fld + fmul + a callee that takes st(0) (0x4939e6), fld/fstp chains (the others)
SMALL_X87_ROWS = (0x4939e6, 0x4fc9f1, 0x4ccb50)


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl52X87(unittest.TestCase):
    def test_lifter_takes_an_x87_row_and_the_c_compiles(self):
        spans = L.ledger_spans()
        text, callees, imports, fs, inline = L.lift(0x4939e6, spans[0x4939e6])
        self.assertIn('FL41_FPU_PROLOGUE', text)
        self.assertIn('FL41_FPU_EPILOGUE', text)
        self.assertIn('fl41_ld_i32(fp, ', text)             # the fild
        self.assertIn('fl41_fpop(fp);', text)               # the callee 0x50ce04 (__ftol) takes st(0)
        row = W.row_info(0x4939e6, spans[0x4939e6], callees, imports, fs)
        self.assertTrue(row['fpu'])
        self.assertEqual(row['fpret'], {0x50ce04: -1})
        with tempfile.TemporaryDirectory() as tmp:
            src = Path(tmp) / 'one.c'
            src.write_text('#include "original_methods_fl41.h"\n' + text)
            lib = W.build_library(tmp, [src])
            self.assertTrue(hasattr(lib, 'm4939e6_lifted'))

    def test_a_row_without_x87_instructions_has_no_fpu_prologue(self):
        spans = L.ledger_spans()
        corpus = json.loads((Path(__file__).resolve().parent / 'fl41_corpus.json').read_text())      # any credited row: the committed text is what the lifter writes
        key = sorted(corpus, key=lambda k: int(k, 16))[0]
        self.assertNotIn('FPU', L.lift(int(key, 16), spans[int(key, 16)])[0])
        self.assertNotIn('fpu', W.row_info(int(key, 16), spans[int(key, 16)], {}, {}, False))

    def test_census_counts_the_x87_rows(self):
        with contextlib.redirect_stdout(io.StringIO()):
            ok, reasons = L.census()
        self.assertGreater(len(ok), 189)                      # 189 before FL-52
        self.assertGreaterEqual(len(ok), 201)                 # 221 before the eight FL-52 rows left the pending set, 213 before the ten FL-55 rows did, 201 after FL-62 credited 8 rows
        credited = json.loads((Path(__file__).resolve().parent / 'fl41_corpus.json').read_text())      # FL-55: the three rows are credited now, so they left the pending census
        for va in SMALL_X87_ROWS:
            self.assertTrue(hex(va) in ok or hex(va) in credited)
        self.assertFalse([v for v in reasons.values() if v.startswith(('fild at', 'fld at'))])

    def test_float_seeds_start_at_100000_and_older_seeds_keep_their_style(self):
        self.assertEqual([W.style_of(s) for s in (0, 1, 7, 41769, 99999)], [0, 1, 2, 4, 4])
        self.assertEqual(W.style_of(100000), 7)
        self.assertEqual(W.style_of(W.FLOAT_SEEDS + 3), 7)

    @unittest.skipUnless(X87_HOST, 'the x87 model is bit-exact only on an x86 host')
    def test_fpu_model_agrees_with_unicorn_on_small_x87_rows(self):
        spans = L.ledger_spans()
        texts, rows = {}, {}
        for va in SMALL_X87_ROWS:
            text, callees, imports, fs, inline = L.lift(va, spans[va])
            texts[va], rows[va] = text, W.row_info(va, spans[va], callees, imports, fs)
        with tempfile.TemporaryDirectory() as tmp:
            src = Path(tmp) / 'x87.c'
            src.write_text('#include "original_methods_fl41.h"\n' + '\n'.join(texts[v] for v in SMALL_X87_ROWS))
            lib = W.build_library(tmp, [src])
            compared = 0
            for va in SMALL_X87_ROWS:
                row = rows[va]
                for seed in list(range(4)) + [W.FLOAT_SEEDS + k for k in range(6)]:
                    original = W.run_original(row, seed)
                    if original.fault:
                        continue
                    native = W.run_native(lib, row, seed)
                    self.assertIsNone(native.fault)
                    self.assertEqual(original.regs, native.regs, 'registers and x87 state, row 0x%x seed %d' % (va, seed))
                    self.assertEqual(original.writes, native.writes, 'writes, row 0x%x seed %d' % (va, seed))
                    self.assertEqual(original.calls, native.calls, 'calls, row 0x%x seed %d' % (va, seed))
                    self.assertIn('fpu', native.regs)
                    compared += 1
            self.assertGreaterEqual(compared, 20)


if __name__ == '__main__':
    unittest.main()
