"""FL-28 (batch c) hand mutants of src/original_methods_fl28c.c (multi-line, widened casts, dropped statements, forced conventions) that the mechanical mutation check cannot express.
Each: (name, function key, old text, new text). Prints the verdict of every mutant; exit status 0. Run from outputs/blackmoor-decomp: python3 tests/fl28c_hand_mutants.py [function key ...]"""
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tests'))
import importlib.util
spec = importlib.util.spec_from_file_location('mut', ROOT / 'tests/fl28c_mutation_check.py')
mut = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mut)
direct = mut.direct
SRC = ROOT / 'src'

C1 = 'if (call2(host, 0x4cf1e4, (uintptr_t)self, '
M = [
    # the review mutants: 16-bit or 8-bit truncations of answers, sizes and indices
    ('4cd243 header alloc answer as 16 bit', '4cd243', C1 + '(uintptr_t)dst, 0x27) == 0)', 'if ((uint16_t)call2(host, 0x4cf1e4, (uintptr_t)self, (uintptr_t)dst, 0x27) == 0)'),
    ('4cd243 table alloc answer as 16 bit', '4cd243', C1 + '(uintptr_t)(self + 0x226), n) == 0)', 'if ((uint16_t)call2(host, 0x4cf1e4, (uintptr_t)self, (uintptr_t)(self + 0x226), n) == 0)'),
    ('4cd243 sub alloc answer as 16 bit', '4cd243', C1 + '(uintptr_t)(r + 0x31), m) == 0)', 'if ((uint16_t)call2(host, 0x4cf1e4, (uintptr_t)self, (uintptr_t)(r + 0x31), m) == 0)'),
    ('4cd243 second alloc answer as 16 bit', '4cd243', C1 + '(uintptr_t)(self + 0x22a), n) == 0)', 'if ((uint16_t)call2(host, 0x4cf1e4, (uintptr_t)self, (uintptr_t)(self + 0x22a), n) == 0)'),
    ('4cd243 sub copy size as 8 bit', '4cd243', 'object_at(host, rd32(src, 0) + c), m);', 'object_at(host, rd32(src, 0) + c), (uint8_t)m);'),
    ('4cd243 sub copy size as 16 bit', '4cd243', 'object_at(host, rd32(src, 0) + c), m);', 'object_at(host, rd32(src, 0) + c), (uint16_t)m);'),
    ('4cd243 second copy size as 8 bit', '4cd243', 'object_at(host, rd32(src, 0)), n);', 'object_at(host, rd32(src, 0)), (uint8_t)n);'),
    ('4cd243 second copy size as 16 bit', '4cd243', 'object_at(host, rd32(src, 0)), n);', 'object_at(host, rd32(src, 0)), (uint16_t)n);'),
    ('4cd243 running offset as 16 bit', '4cd243', '    wr32(tail, 0, rd32(tail, 0) + c);\n    wr32(src, 0, rd32(src, 0) + c);', '    wr32(tail, 0, rd32(tail, 0) + (uint16_t)c);\n    wr32(src, 0, rd32(src, 0) + (uint16_t)c);'),
    ('4cd243 second m = dropped', '4cd243', '        m = (uint32_t)(rds16(r, 0x2f) * 0x23);\n        if ((int32_t)m < 0) return 0;', '        if ((int32_t)m < 0) return 0;'),
    ('4cd243 second n recompute dropped', '4cd243', '    n = (uint32_t)(rds16(object_at(host, rd32(self, 0x222)), 0x25) * 0x22);      /* the count of the copy is computed again', '    /* the count of the copy is computed again'),
    ('4cd243 sub pointer as a guest address', '4cd243', '(uintptr_t)(r + 0x31), m) == 0)', 'u32(record + 0x31u), m) == 0)'),
    ('4cf1e4 size as 8 bit', '4cf1e4', 'size_t i, n = size;', 'size_t i, n = (uint8_t)size;'),
    ('4cf1e4 size as 16 bit', '4cf1e4', 'size_t i, n = size;', 'size_t i, n = (uint16_t)size;'),
    ('4cec6c index as 16 bit', '4cec6c', 'record = rd32(self, 0x226) + rd32(self, 0x246) * 0x35u;', 'record = rd32(self, 0x226) + (uint16_t)rd32(self, 0x246) * 0x35u;'),
    ('4ceb8c index as 16 bit', '4ceb8c', 'rd32(self, 0x22a) + rd32(self, 0x24a) * 0x22u);', 'rd32(self, 0x22a) + (uint16_t)rd32(self, 0x24a) * 0x22u);'),
    ('4cf026 record offset as 16 bit', '4cf026', 'uint32_t record = rd32(self, 0x226) + (uint32_t)i * 0x35u;\n        if (call2', 'uint32_t record = rd32(self, 0x226) + (uint16_t)(i * 0x35);\n        if (call2'),
    ('4cf026 index as int16 (equivalent: i never exceeds 32766)', '4cf026', '    int32_t i;\n    if (rd32(self, 0x222) == 0', '    int16_t i;\n    if (rd32(self, 0x222) == 0'),
    ('4cf026 compare answer as 16 bit', '4cf026', 'if (call2(host, 0x516530, 0, key, record) == 0)', 'if ((uint16_t)call2(host, 0x516530, 0, key, record) == 0)'),
    ('4ce8ea arm 0 gate answer as 16 bit', '4ce8ea', 'if (call1(host, 0x4bef85, 0x6201f9, rd32(self, 0x18e)) == 0) return;\n        scan_rect(self, host);\n        wr32', 'if ((uint16_t)call1(host, 0x4bef85, 0x6201f9, rd32(self, 0x18e)) == 0) return;\n        scan_rect(self, host);\n        wr32'),
    ('4ce8ea arm 4 gate answer as 16 bit', '4ce8ea', 'if (call1(host, 0x4bef85, 0x6201f9, rd32(self, 0x18e)) == 0) return;\n        scan_rect(self, host);\n        call0', 'if ((uint16_t)call1(host, 0x4bef85, 0x6201f9, rd32(self, 0x18e)) == 0) return;\n        scan_rect(self, host);\n        call0'),
    ('4ce8ea 0x4bf10f answer as 16 bit (arm 4)', '4ce8ea', 'r = call1(host, 0x4bf10f, 0x6201f9, rd32(self, 0x18e));\n        if (r != 0 && rd32(self, 0x232) != (uint32_t)rds16(object_at(host, rec), 0x23)) return;', 'r = (uint16_t)call1(host, 0x4bf10f, 0x6201f9, rd32(self, 0x18e));\n        if (r != 0 && rd32(self, 0x232) != (uint32_t)rds16(object_at(host, rec), 0x23)) return;'),
]


def run(name, key, old, new):
    text = (SRC / 'original_methods_fl28c.c').read_text()
    olds, news = (old, new) if isinstance(old, tuple) else ((old,), (new,))
    for o in olds:
        if text.count(o) != 1:
            return 'BAD MUTANT (pattern occurs %d times)' % text.count(o)
    mutated = text
    for o, nw in zip(olds, news):
        mutated = mutated.replace(o, nw)
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        (tmp / 'original_methods_fl28c.c').write_text(mutated)
        for h in SRC.glob('*.h'):
            shutil.copy(h, tmp / h.name)
        binary = tmp / 'direct'
        built = direct.build(binary, direct.TEST_C, tmp)
        if built.returncode != 0:
            return 'caught: build failed'
        try:
            done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=60)
        except subprocess.TimeoutExpired:
            return 'caught: direct test timeout'
        if done.returncode != 0:
            return 'caught by direct test'
        test = mut.FUNCS[key]
        try:
            child = subprocess.run([sys.executable, '-c', mut.DIFFERENTIAL_CHILD, str(tmp), test], capture_output=True, text=True, timeout=900, cwd=str(ROOT))
        except subprocess.TimeoutExpired:
            return 'caught by differential (timeout)'
        return 'SURVIVED' if child.returncode == 0 else 'caught by differential only'


if __name__ == '__main__':
    only = sys.argv[1:]
    counts = {}
    for name, key, old, new in M:
        if only and key not in only:
            continue
        r = run(name, key, old, new)
        counts[r.split(':')[0]] = counts.get(r.split(':')[0], 0) + 1
        print('%-8s %-40s %s' % (key, name, r), flush=True)
    print(counts)
