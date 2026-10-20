"""FL-28 (batch a) hand mutants of src/original_methods_fl28a.c (multi-line, reordering, forced branches) that the mechanical mutation check cannot express.
Each: (name, function key, old text, new text). Prints the verdict of every mutant; exit status 0. Run from outputs/blackmoor-decomp: python3 tests/fl28a_hand_mutants.py [function key ...]"""
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tests'))
import importlib.util
spec = importlib.util.spec_from_file_location('mut', ROOT / 'tests/fl28a_mutation_check.py')
mut = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mut)
direct = mut.direct
SRC = ROOT / 'src'

M = [
    # the four mutants of the independent review: a 32-bit callee answer tested through its low 16 bits
    ('4fb2e3 answer tested as 16 bit', '4fb2e3', 'if (call1(host, 0x4f6059, 0x5cf1eb, slot16) == 0 &&', 'if ((uint16_t)call1(host, 0x4f6059, 0x5cf1eb, slot16) == 0 &&'),
    ('4f356e 0x4f6334 answer as 16 bit', '4f356e', 'if (call1(host, 0x4f6334, (uintptr_t)self, idx) != 0)', 'if ((uint16_t)call1(host, 0x4f6334, (uintptr_t)self, idx) != 0)'),
    ('4f356e 0x4f709c answer as 16 bit', '4f356e', 'if (call0(host, 0x4f709c, (uintptr_t)self) == 0) return 1;', 'if ((uint16_t)call0(host, 0x4f709c, (uintptr_t)self) == 0) return 1;'),
    ('4f80d3 lost status as 16 bit', '4f80d3', 'if (rd32(self, 0x3ca) == 0x88780096u) {', 'if ((uint16_t)rd32(self, 0x3ca) == 0x0096u) {'),
]


def run(name, key, old, new):
    text = (SRC / 'original_methods_fl28a.c').read_text()
    olds, news = (old, new) if isinstance(old, tuple) else ((old,), (new,))
    for o in olds:
        if text.count(o) != 1:
            return 'BAD MUTANT (pattern occurs %d times)' % text.count(o)
    mutated = text
    for o, nw in zip(olds, news):
        mutated = mutated.replace(o, nw)
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        (tmp / 'original_methods_fl28a.c').write_text(mutated)
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
