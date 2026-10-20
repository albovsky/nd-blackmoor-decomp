"""FL-30 (batch c): the mutants that tests/fl30c_mutation_check.py cannot model (a hoisted loop bound, a moved store, a returned import result). Each is applied to a scratch copy of
src/original_methods_fl30c.c and run against the differential test of its function; prints CAUGHT or SURVIVED. Run from outputs/blackmoor-decomp: python3 tests/fl30c_hand_mutants.py"""
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
os.chdir(ROOT)
sys.path.insert(0, str(ROOT / 'tests'))
sys.dont_write_bytecode = True
import fl30c_mutation_check as mc

src = (ROOT / 'src/original_methods_fl30c.c').read_text()
MUTS = [
    ('423876', 'recursion with the flag 0', "m423876_unwind_chain(self, node + 0x44, 1, world, host);", "m423876_unwind_chain(self, node + 0x44, 0, world, host);"),
    ('423876', 'arguments of 0x4234dd swapped', "call2(host, 0x4234dd, (uintptr_t)self, (uintptr_t)cell, node_va);", "call2(host, 0x4234dd, (uintptr_t)self, node_va, (uintptr_t)cell);"),
    ('423876', 'cell not replaced by [t+4]', "cell = object_at(host, rd32(tp, 4));", "(void)rd32(tp, 4);"),
    ('4763b3', 'first block tests the vertical length for the 2 case', "        if (rds16(self, 0x8d4) - rds16(self, 0x8d2) == 2) {\n            wr32(self, 0x8c6, rd32(self, 0x8c6) + (uint32_t)(rds16(rec, 0x656) * 1000));\n        } else if (rds16(self, 0x8d0)",
     "        if (rds16(self, 0x8d0) - rds16(self, 0x8ce) == 2) {\n            wr32(self, 0x8c6, rd32(self, 0x8c6) + (uint32_t)(rds16(rec, 0x656) * 1000));\n        } else if (rds16(self, 0x8d0)"),
    ('41b6e2', 'key not advanced in the literal branch', "            c = (uint8_t)(src[si] - key);\n            key = (uint8_t)(key + 1);\n            dst[out] = c;", "            c = (uint8_t)(src[si] - key);\n            dst[out] = c;"),
    ('43d7f0', 'flag store after the first call', "    world->value_5d15a5 = 1;\n    call0(host, kInitCalls[0].callee, kInitCalls[0].object);", "    call0(host, kInitCalls[0].callee, kInitCalls[0].object);\n    world->value_5d15a5 = 1;"),
    ('434025', 'sel reset for every entry', "        uint32_t q = 5;\n        if (n <= 8) {", "        uint32_t q = 5;\n        sel = 0;\n        if (n <= 8) {"),
    ('4fcb5c', 'second clamp uses the unclamped bits', "    else wr32(self, vol, 0x3f800000u);", "    else wr32(self, vol, 0x3f800001u);"),
]
for key, what, old, new in MUTS:
    assert src.count(old) == 1, what
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        (tmp / 'original_methods_fl30c.c').write_text(src.replace(old, new))
        for h in ['original_methods_fl30c.h'] + [p.name for p in (ROOT / 'src').glob('original_methods_fl1[0-9].h')]:
            shutil.copy(ROOT / 'src' / h, tmp / h)
        cc = subprocess.run(['gcc', '-std=c11', '-Wall', '-Wextra', '-Werror', '-fsyntax-only', '-I' + str(tmp), str(tmp / 'original_methods_fl30c.c')], capture_output=True, text=True)
        assert cc.returncode == 0, cc.stderr
        child = subprocess.run([sys.executable, '-c', mc.DIFFERENTIAL_CHILD, str(tmp), mc.FUNCS[key]], capture_output=True, text=True, timeout=600, cwd=str(ROOT))
        print(key, what, 'CAUGHT by the differential test' if child.returncode != 0 else 'SURVIVED')
