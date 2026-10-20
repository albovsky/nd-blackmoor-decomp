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
FLAG = "            wr32(self, 0x4fc4 + (ptrdiff_t)i * 4, 1);\n            p += 4;\n            wr32(self, 0x112c, call1(host, 0x4347b8, (uintptr_t)self, p));\n"
MUTS = [
    ('43423d', 'hoisted bound', "    for (i = 0; i < (int32_t)rd32(self, 0x5f64); i++) {", "    int32_t bound = (int32_t)rd32(self, 0x5f64);\n    for (i = 0; i < bound; i++) {"),
    ('4344bf', 'hoisted bound', "    for (i = 0; i < (int32_t)rd32(self, 0x5f68); i++) {", "    int32_t bound = (int32_t)rd32(self, 0x5f68);\n    for (i = 0; i < bound; i++) {"),
    ('4344bf', 'flag store after the 0x112c store', FLAG, "            p += 4;\n            wr32(self, 0x112c, call1(host, 0x4347b8, (uintptr_t)self, p));\n            wr32(self, 0x4fc4 + (ptrdiff_t)i * 4, 1);\n"),
    ('4bf19a', 'result of BinkGoto returned', "    call3(host, 0x52a530, 0, (uintptr_t)handle, frame, 0);\n    return 1;", "    return call3(host, 0x52a530, 0, (uintptr_t)handle, frame, 0) ? 1 : 0;"),
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
