"""FL-27 (batch a) hand mutants of src/original_methods_fl27a.c (multi-line, reordering, forced branches) that the mechanical mutation check cannot express.
Each: (name, function key, old text, new text). Prints the verdict of every mutant; exit status 0. Run from outputs/blackmoor-decomp: python3 tests/fl27a_hand_mutants.py [function key ...]"""
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tests'))
import importlib.util
spec = importlib.util.spec_from_file_location('mut', ROOT / 'tests/fl27a_mutation_check.py')
mut = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mut)
direct = mut.direct
SRC = ROOT / 'src'

M = [
    ('4de214 call dropped', '4de214', 'm4de1f5_clear_flags(self, world);\n}', '(void)self;\n    (void)world;\n}'),
    ('4de1f5 word store', '4de1f5', 'wr32(self, 0x991, 0);', 'wr16(self, 0x991, 0);'),
    ('4de1f5 flag not cleared', '4de1f5', 'world->byte_5a161f = 0;', '(void)world;'),
    ('4de2d8 globals cleared before calls', '4de2d8', '    call1(host, 0x4e053f, 0x570508, 1);\n    call0(host, 0x4e1113, 0x570508);\n    world->value_5b15d6 = 0;\n    world->value_5d17f5 = 0;',
     '    world->value_5b15d6 = 0;\n    world->value_5d17f5 = 0;\n    call1(host, 0x4e053f, 0x570508, 1);\n    call0(host, 0x4e1113, 0x570508);'),
    ('4de2d8 thunk call dropped', '4de2d8', '    m4de214_clear_flags_thunk(self, world);\n}\n\n/* ---- 0x449d90', '    (void)self;\n}\n\n/* ---- 0x449d90'),
    ('4de2d8 order of the two callees', '4de2d8', '    call1(host, 0x4e053f, 0x570508, 1);\n    call0(host, 0x4e1113, 0x570508);', '    call0(host, 0x4e1113, 0x570508);\n    call1(host, 0x4e053f, 0x570508, 1);'),
    ('4de2d8 flag stored 0', '4de2d8', 'wr32(self, 0x991, 1);', 'wr32(self, 0x991, 0);'),
    ('449d90 no close', '449d90', '    call1(host, 0x50cee4, 0, file);\n', ''),
    ('449d90 swapped open args', '449d90', 'call2(host, 0x50d0a9, 0, path, 0x548aac)', 'call2(host, 0x50d0a9, 0, 0x548aac, path)'),
    ('449d90 close always', '449d90', '    if (file == 0) return 0;\n    call1(host, 0x50cee4, 0, file);', '    call1(host, 0x50cee4, 0, file);\n    if (file == 0) return 0;'),
    ('44c479 no wait loop', '44c479', 'while (rd32_volatile(p) == 1) {', 'if (rd32_volatile(p) == 1) {'),
    ('44c479 byte compare', '44c479', 'while (rd32_volatile(p) == 1) {', 'while ((rd32_volatile(p) & 0xff) == 1) {'),
    ('44c479 no store', '44c479', '    wr32(p, 0, 1);\n    return 1;', '    return 1;'),
    ('44c479 store byte', '44c479', '    wr32(p, 0, 1);\n    return 1;', '    p[0] = 1;\n    return 1;'),
    ('44c479 sleep arg', '44c479', 'call1(host, 0x52a2b0, 0, 1);\n        if (++spins', 'call1(host, 0x52a2b0, 0, 0);\n        if (++spins'),
    ('44c479 2 tested as low byte', '44c479', 'if (rd32_volatile(p) == 2) return 2;', 'if ((rd32_volatile(p) & 0xff) == 2) return 2;'),
    ('44c479 no rejection', '44c479', 'if (++spins >= limit) return FL27A_REJECTED;', 'if (++spins >= limit) spins = 0;'),
    ('4bee2c call after guard', '4bee2c', '    call0(host, 0x4bf38c, (uintptr_t)self);\n    if (handle == 0) {\n        wr32(self, 0x2c0, 0xfffffffdu);\n        return -1;\n    }\n    return (int32_t)rd32(mem_at(host, handle), 0xc);',
     '    if (handle == 0) {\n        wr32(self, 0x2c0, 0xfffffffdu);\n        return -1;\n    }\n    call0(host, 0x4bf38c, (uintptr_t)self);\n    return (int32_t)rd32(mem_at(host, handle), 0xc);'),
    ('4bee2c return 0 on null', '4bee2c', '        return -1;\n    }\n    return (int32_t)rd32(mem_at(host, handle), 0xc);', '        return 0;\n    }\n    return (int32_t)rd32(mem_at(host, handle), 0xc);'),
    ('4bef85 result inverted', '4bef85', 'return call1(host, 0x52a52c, 0, handle) != 0 ? 0 : 1;', 'return call1(host, 0x52a52c, 0, handle) != 0 ? 1 : 0;'),
    ('4bef85 result as byte', '4bef85', 'return call1(host, 0x52a52c, 0, handle) != 0 ? 0 : 1;', 'return (uint8_t)call1(host, 0x52a52c, 0, handle) != 0 ? 0 : 1;'),
    ('4bef85 null returns 1', '4bef85', '        wr32(self, 0x2c0, 0xfffffffdu);\n        return 0;\n    }\n    return call1', '        wr32(self, 0x2c0, 0xfffffffdu);\n        return 1;\n    }\n    return call1'),
    ('4bee5f clear 0x1e dwords', '4bee5f', 'memset(self + 8, 0, 0x1f * 4);', 'memset(self + 8, 0, 0x1e * 4);'),
    ('4bee5f clear at +0', '4bee5f', 'memset(self + 8, 0, 0x1f * 4);', 'memset(self + 4, 0, 0x1f * 4);'),
    ('4bee5f returns self', '4bee5f', '    return self + 8;\n}', '    return self;\n}'),
    ('4bee5f import args swapped', '4bee5f', 'call2(host, 0x52a508, 0, handle, (uintptr_t)(self + 8));', 'call2(host, 0x52a508, 0, (uintptr_t)(self + 8), handle);'),
    ('4befc8 clear after call', '4befc8', '    call0(host, 0x4bf38c, (uintptr_t)self);\n    wr32(self, 0xbc, 0);\n    if (handle == 0) {\n        wr32(self, 0x2c0, 0xfffffffdu);\n        return (int32_t)rd32(self, 0xbc);\n    }\n    wr32(self, 0xbc, call1(host, 0x52a528, 0, handle));',
     '    call0(host, 0x4bf38c, (uintptr_t)self);\n    if (handle == 0) {\n        wr32(self, 0xbc, 0);\n        wr32(self, 0x2c0, 0xfffffffdu);\n        return (int32_t)rd32(self, 0xbc);\n    }\n    wr32(self, 0xbc, call1(host, 0x52a528, 0, handle));'),
    ('4befc8 result not stored', '4befc8', '    wr32(self, 0xbc, call1(host, 0x52a528, 0, handle));\n    return (int32_t)rd32(self, 0xbc);', '    return (int32_t)call1(host, 0x52a528, 0, handle);'),
    ('4bef11 modes swapped', '4bef11', 'args[1] = rd32(self, 0x2c4) != 1 ? 1 : rd32(mem_at(host, handle), 8);', 'args[1] = rd32(self, 0x2c4) == 1 ? 1 : rd32(mem_at(host, handle), 8);'),
    ('4bef11 mode as word', '4bef11', 'args[1] = rd32(self, 0x2c4) != 1 ? 1 :', 'args[1] = rd16(self, 0x2c4) != 1 ? 1 :'),
    ('4bef11 mode stored after call', '4bef11', '    wr32(self, 0x2c4, mode);\n    args[0] = handle;', '    (void)mode;\n    args[0] = handle;'),
    ('4bef11 null returns 0', '4bef11', 'return (int32_t)0xfffffffd;', 'return 0;'),
    ('4bf098 flags from +8', '4bf098', 'args[6] = rd32(self, 4);', 'args[6] = rd32(self, 8);'),
    ('4bf098 args swapped', '4bf098', '    args[2] = pitch;\n    args[3] = height;', '    args[2] = height;\n    args[3] = pitch;'),
    ('4bf098 clear not first', '4bf098', '    call0(host, 0x4bf38c, (uintptr_t)self);\n    wr32(self, 0xbc, 0);\n    if (handle == 0) {\n        wr32(self, 0x2c0, 0xfffffffdu);\n        return (int32_t)rd32(self, 0xbc);\n    }\n    args[0]',
     '    call0(host, 0x4bf38c, (uintptr_t)self);\n    if (handle == 0) {\n        wr32(self, 0x2c0, 0xfffffffdu);\n        return (int32_t)rd32(self, 0xbc);\n    }\n    wr32(self, 0xbc, 0);\n    args[0]'),
    ('4bf10f mode compared as byte', '4bf10f', 'if (rd32(self, 0x2c4) != 1) {', 'if ((rd32(self, 0x2c4) & 0xff) != 1) {'),
    ('4bf10f cur compared with 8 as word', '4bf10f', 'if (rd32(h, 0xc) == rd32(h, 8)) return 0;', 'if (rd16(h, 0xc) == rd16(h, 8)) return 0;'),
    ('4bf10f goto frame cur+1', '4bf10f', 'args[1] = rd32(h, 0xc) - 1u;', 'args[1] = rd32(h, 0xc) + 1u;'),
    ('4bf10f cur==1 as byte', '4bf10f', 'if (rd32(h, 0xc) == 1) return 0;', 'if ((rd32(h, 0xc) & 0xff) == 1) return 0;'),
    ('4bf315 second byte', '4bf315', 'if (mem_at(host, name)[0] == 0) {', 'if (mem_at(host, name)[1] == 0) {'),
    ('4bf315 callee order', '4bf315', '    call0(host, 0x4bf38c, (uintptr_t)self);\n    call0(host, 0x4bede7, (uintptr_t)self);\n    if (mem_at', '    call0(host, 0x4bede7, (uintptr_t)self);\n    call0(host, 0x4bf38c, (uintptr_t)self);\n    if (mem_at'),
    ('4bf315 args swapped', '4bf315', 'call2(host, 0x52a518, 0, name, flags)', 'call2(host, 0x52a518, 0, flags, name)'),
    ('4bf315 error codes swapped', '4bf315', 'wr32(self, 0x2c0, 0xfffffffbu);', 'wr32(self, 0x2c0, 0xfffffffau);'),
    ('4c2dfb no re-read', '4c2dfb', 'call1(host, 0x51dc6c, 0, rd32(s, 0));', 'call1(host, 0x51dc6c, 0, p);'),
    ('4c2dfb bit tested as dword nonzero', '4c2dfb', 'if ((rd32(obj, 0x55) & 1u) == 0)', 'if (rd32(obj, 0x55) == 0)'),
    ('4c2dfb bit1', '4c2dfb', 'if ((rd32(obj, 0x55) & 1u) == 0)', 'if ((rd32(obj, 0x55) & 2u) == 0)'),
    ('4c2dfb slot not cleared', '4c2dfb', '    wr32(s, 0, 0);\n}', '}'),
    ('4c2dfb p cleared as word', '4c2dfb', '        wr32(obj, 0, 0);', '        wr16(obj, 0, 0);'),
    ('4c2dfb this wrong', '4c2dfb', 'call1(host, 0x4c2e5b, (uintptr_t)self, p);', 'call1(host, 0x4c2e5b, (uintptr_t)self + 1, p);'),
    ('4159db word as dword', '4159db', 'call2(host, 0x415db9, (uintptr_t)self, a, word);', 'call2(host, 0x415db9, (uintptr_t)self, a, word | 0x10000u);'),
    ('4159db no byte re-read', '4159db', ('    if (obj[0x20] == 2) {', '    args[2] = mem_at(host, a)[0x20];'), ('    const uint8_t b0 = obj[0x20];\n    if (b0 == 2) {', '    args[2] = b0;')),
    ('4159db 2 as word', '4159db', 'if (obj[0x20] == 2) {', 'if (rd16(obj, 0x20) == 2) {'),
    ('4159db global before call', '4159db', '    world->value_63a58a = 4;\n    call0(host, 0x4c97b4, 0x5cf659);', '    call0(host, 0x4c97b4, 0x5cf659);\n    world->value_63a58a = 4;'),
    ('4159db format args', '4159db', 'args[3] = a + 0x151u;', 'args[3] = a + 0x150u;'),
    ('4159db no stdcall', '4159db', '    if (host->call != NULL) host->call(host->context, 0x52139c, 0, args, 3);\n', ''),
    ('4c0c7d flag as word', '4c0c7d', 'if (rd32(mem_at(host, param), 0) != 0) {', 'if (rd16(mem_at(host, param), 0) != 0) {'),
    ('4c0c7d word as dword', '4c0c7d', 'if ((int16_t)rd16(obj, 0x1cc) == 0) {', 'if (rd32(obj, 0x1cc) == 0) {'),
    ('4c0c7d selector swapped', '4c0c7d', '                if (selector == 0)\n                    call1(host, 0x41546f, 0x5e2dbe, 0x637fd7);\n                else if (selector == 1)\n                    call1(host, 0x4156ea, 0x5e2dbe, 0x637fd7);',
     '                if (selector == 0)\n                    call1(host, 0x4156ea, 0x5e2dbe, 0x637fd7);\n                else if (selector == 1)\n                    call1(host, 0x41546f, 0x5e2dbe, 0x637fd7);'),
    ('4c0c7d selector as word', '4c0c7d', 'uint32_t selector = rd32(obj, 0x172);', 'uint32_t selector = rd16(obj, 0x172);'),
    ('4c0c7d else always', '4c0c7d', '                else if (selector == 1)\n', '                else\n'),
    ('4c0c7d word store 0', '4c0c7d', 'wr16(obj, 0x1cc, 1);', 'wr16(obj, 0x1cc, 0);'),
    ('4c0c7d no sleep', '4c0c7d', '        call1(host, 0x52a2b0, 0, 1);\n        if (++passes', '        if (++passes'),
    ('4c0c7d ax==2 ignored', '4c0c7d', 'if ((int16_t)state != 2) {', 'if (1) {'),
    ('4c0c7d no 44c4ab', '4c0c7d', '                call1(host, 0x44c4ab, 0, 0x637fd3);\n', ''),
    ('4c0c7d endthread args', '4c0c7d', 'call2(host, 0x51ec84, 0, 0, 1);', 'call2(host, 0x51ec84, 0, 1, 0);'),
]


def run(name, key, old, new):
    text = (SRC / 'original_methods_fl27a.c').read_text()
    olds, news = (old, new) if isinstance(old, tuple) else ((old,), (new,))
    for o in olds:
        if text.count(o) != 1:
            return 'BAD MUTANT (pattern occurs %d times)' % text.count(o)
    mutated = text
    for o, nw in zip(olds, news):
        mutated = mutated.replace(o, nw)
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        (tmp / 'original_methods_fl27a.c').write_text(mutated)
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
