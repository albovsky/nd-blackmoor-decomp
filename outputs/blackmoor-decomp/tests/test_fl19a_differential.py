"""FL-19 batch a differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl19a.c on the same random fixtures.

See test_fl_differential.py, test_fl18_differential.py and original_differential.py for the method. Every case compares all the memory the
function can write (objects, record tables, globals), the return value where there is one, how many bytes the function popped, and the
ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared as the original addresses they stand for, pointers to a
local of the function as 'L'; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits) and, where a call is
described that way, the bytes behind a pointer argument. The callees themselves are recording stubs; the function under test runs as the
original bytes. A case also requires that its scenarios reached every instruction of the original function.
"""
import ctypes
from dataclasses import dataclass
from pathlib import Path
import random
import struct
import sys
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]
SCENARIOS = 300
LOCAL = 'L'


class World(ctypes.Structure):
    """Mirrors Fl19aWorld (src/original_methods_fl19a.h); every scalar is unsigned here, the layout is the same."""
    _fields_ = [('self_address', ctypes.c_uint32)] + \
               [(n, ctypes.c_void_p) for n in ('records_5bb5e5', 'globals_5d1a31', 'string_559b18', 'bytes_551b18', 'table_5a2664',
                                              'table_5a434c')] + \
               [('word_5a1e5e', ctypes.c_uint16), ('word_5a1e60', ctypes.c_uint16)] + \
               [(n, ctypes.c_void_p) for n in ('table_5b30cc', 'table_5b3e40', 'table_5b3ae8')] + \
               [(n, ctypes.c_uint32) for n in ('value_583102', 'value_583106', 'value_5b44f0', 'value_5b44f4', 'value_5b44f8',
                                               'value_5c39e5', 'value_5c39e9', 'value_5c3a47', 'value_5c3a5b', 'value_5c3a5f',
                                               'value_5bb1ca', 'value_5839a9', 'value_5bb57b', 'value_5bb59b', 'value_5bb59f',
                                               'value_5bb5a3', 'value_583999', 'value_5d0377', 'value_5d162d', 'value_5d1631',
                                               'value_5d1639', 'value_571ad3')] + \
               [(n, ctypes.c_uint16) for n in ('word_583a29', 'word_583f1d', 'word_5bb599', 'word_5bb595', 'word_5c39ff')]


# the globals of the original that a case may set, with their address and size
GLOBALS = {
    'word_5a1e5e': (0x5a1e5e, 2), 'word_5a1e60': (0x5a1e60, 2),
    'value_583102': (0x583102, 4), 'value_583106': (0x583106, 4), 'value_5b44f0': (0x5b44f0, 4), 'value_5b44f4': (0x5b44f4, 4),
    'value_5b44f8': (0x5b44f8, 4), 'value_5c39e5': (0x5c39e5, 4), 'value_5c39e9': (0x5c39e9, 4), 'value_5c3a47': (0x5c3a47, 4),
    'value_5c3a5b': (0x5c3a5b, 4), 'value_5c3a5f': (0x5c3a5f, 4), 'value_5bb1ca': (0x5bb1ca, 4), 'value_5839a9': (0x5839a9, 4),
    'value_5bb57b': (0x5bb57b, 4), 'value_5bb59b': (0x5bb59b, 4), 'value_5bb59f': (0x5bb59f, 4), 'value_5bb5a3': (0x5bb5a3, 4),
    'value_583999': (0x583999, 4), 'value_5d0377': (0x5d0377, 4), 'value_5d162d': (0x5d162d, 4), 'value_5d1631': (0x5d1631, 4),
    'value_5d1639': (0x5d1639, 4), 'value_571ad3': (0x571ad3, 4), 'word_583a29': (0x583a29, 2), 'word_583f1d': (0x583f1d, 2),
    'word_5bb599': (0x5bb599, 2), 'word_5bb595': (0x5bb595, 2), 'word_5c39ff': (0x5c39ff, 2),
}
FMT = {2: '<H', 4: '<I'}

# the shim function ids (tests/fl19a_differential_shim.c)
F_4CEB3B, F_423F57, F_4CECF7, F_4EA269, F_4CCDAB, F_47E2A5, F_423259, F_4E89EB, F_4E444D, F_4B617A, F_4CCFF5, F_48D1E8, F_475DA4, \
    F_4EE2A9, F_48BD91 = range(1, 16)


@dataclass
class Area:
    name: str
    va: int
    data: bytearray
    image: bool = True      # inside the image (a global or table) or a region outside it
    compare: bool = True


def nonzero(rng):
    """A non-zero dword, often with only one byte or the sign bit set, so that a test that looks at less than the full dword is caught."""
    return rng.choice([1, 0x100, 0x10000, 0x04000000, 0x80000000, rng.randrange(1, 1 << 32)])


def cstring(rng, low, high, alphabet='abAB'):
    return bytes(rng.choice(alphabet.encode()) for _ in range(rng.randrange(low, high + 1))) + b'\0'


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl19aDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl19a_differential_shim.c'
    KERNELS = ['original_methods_fl19a.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_fl19a.restype = ctypes.c_uint32
        cls.lib.shim_fl19a.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_int32,
                                       ctypes.c_int32, ctypes.c_uint32, ctypes.c_void_p]
        cls.lib.shim_script_return.argtypes = [ctypes.c_uint32, ctypes.c_uint32]
        cls.lib.shim_script_deref.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int]
        cls.lib.shim_add_region.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_uint32]

    def test_world_layout(self):
        self.assertEqual(self.lib.shim_world_size(), ctypes.sizeof(World))

    def native_calls19(self, areas, deref_len):
        spans = [(ctypes.addressof(arr), len(arr), a.va) for a, arr in areas]

        def va_of(value):
            for base, length, va in spans:
                if base <= value < base + length:
                    return va + (value - base)
            return LOCAL if value >= 1 << 32 else value
        calls = self.lib.shim_calls()
        out = []
        for i in range(self.lib.shim_call_count()):
            c = calls[i]
            entry = [c.id, va_of(c.this_ptr), *[va_of(c.arg[k]) for k in range(c.nargs)]]
            if c.id in deref_len:
                entry.append(bytes(c.data[0])[:deref_len[c.id]])
            out.append(entry)
        return out

    def normalize_original(self, calls, stubs):
        by_name = {s.name: s for s in stubs.values()}
        out = []
        for call in calls:
            stub = by_name[call[0]]
            entry = [call[0], call[1] if stub.this else 0]
            rest = list(call[2 if stub.this else 1:])
            data = rest.pop() if stub.deref is not None else None
            entry.extend(LOCAL if od.STACK_BASE <= v < od.STACK_BASE + od.STACK_SIZE else v for v in rest)
            if data is not None:
                entry.append(data)
            out.append(entry)
        return out

    def pair(self, fn, va, size, areas, stubs, g, *, ecx=0x33333333, stack=(), cleanup=0, word_args=None, native=(0, 0, 0),
             pointers=None, p1=None, p2=None, executed=None, returns=False):
        """Run the original and the native function on one fixture and compare. `g` maps World field names to initial values
        (globals of the original, or self_address); `pointers` maps World pointer fields to (area name, offset); p1 and p2 name the
        areas that the shim passes as pointer arguments."""
        image_patches = [(a.va, a.data) for a in areas if a.image]
        for field, value in g.items():
            if field in GLOBALS:
                address, nbytes = GLOBALS[field]
                image_patches.append((address, struct.pack(FMT[nbytes], value & ((1 << (8 * nbytes)) - 1))))
        regions = {a.name: (a.va, a.data) for a in areas if not a.image}
        read = {a.name: (a.va, len(a.data)) for a in areas if a.compare}
        for field in g:
            if field in GLOBALS:
                read['g:' + field] = GLOBALS[field]
        orig = od.Original(image_patches, regions, stubs).run(va, size, ecx=ecx, stack_args=stack, read=read)
        self.assertEqual(orig.cleanup, cleanup)
        # native
        self.lib.shim_reset()
        arrays, by_name = [], {}
        for a in areas:
            arr = buf(a.data)
            by_name[a.name] = arr
            arrays.append((a, arr))
            self.lib.shim_add_region(a.va, ptr(arr), len(arr))
        world = World()
        for field, value in g.items():
            nbytes = GLOBALS[field][1] if field in GLOBALS else 4
            setattr(world, field, value & ((1 << (8 * nbytes)) - 1))
        for field, (name, offset) in (pointers or {}).items():
            setattr(world, field, ctypes.cast(ctypes.byref(by_name[name], offset), ctypes.c_void_p).value)
        for stub in stubs.values():
            for r in (stub.results or ([stub.result] if stub.result else [])):
                self.lib.shim_script_return(stub.name, r)
            if stub.deref is not None:
                self.lib.shim_script_deref(stub.name, stub.deref[0], stub.deref[1])

        def address(name):
            return ctypes.cast(by_name[name], ctypes.c_void_p).value if name in by_name else None
        result = self.lib.shim_fl19a(fn, address('self'), address(p1), address(p2), native[0], native[1], native[2] & 0xffffffff,
                                     ctypes.byref(world))
        for a, arr in arrays:
            if a.compare:
                self.assertEqual(bytes(arr), orig.memory[a.name], a.name)
        for field in g:
            if field in GLOBALS:
                nbytes = GLOBALS[field][1]
                self.assertEqual(struct.pack(FMT[nbytes], getattr(world, field) & ((1 << (8 * nbytes)) - 1)), orig.memory['g:' + field],
                                 field)
        if returns:
            self.assertEqual(result, orig.eax)
        expected = self.normalize_original(orig.calls, stubs)
        actual = self.native_calls19(arrays, {x.name: x.deref[1] for x in stubs.values() if x.deref})
        for calls in (expected, actual):
            for entry in calls:
                for index in (word_args or {}).get(entry[0], ()):
                    entry[2 + index] = entry[2 + index] & 0xffff
        self.assertEqual(actual, expected)
        if executed is not None:
            executed |= orig.executed
        return orig, result

    def finish(self, va, size, executed):
        missing = sorted(od.instruction_addresses(va, size) - executed)
        self.assertEqual(missing, [], 'scenarios never reached original instructions %s' % [hex(a) for a in missing])

    # ---- helpers for the shared shapes ----
    def records_area(self, rng, nrec=6, slack=1):
        """The record table at 0x5bb5e5 (stride 0x8d) with `slack` records below it; returns the area and the byte offset of record 0."""
        return Area('records', 0x5bb5e5 - slack * 0x8d, bytearray(rng.randbytes((slack + nrec) * 0x8d))), slack * 0x8d

    def point_records(self, records, objects):
        """Every record's first dword (the slack record included) addresses one of the objects; record i (one slack record) uses object i % 2."""
        for i in range(len(records.data) // 0x8d):
            struct.pack_into('<I', records.data, i * 0x8d, objects[i % len(objects)].va)

    # ---- 0x4ceb3b ----
    def test_4ceb3b_reset_state(self):
        """FL-19: differential test of m4ceb3b_reset_state (original 0x4ceb3b)"""
        rng = random.Random(0x4ceb3b)
        executed = set()
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 3, 4, 5])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x300)), image=False)
            records, slack = self.records_area(rng, 6, 1)
            glob = Area('glob', 0x5d1a31, bytearray(rng.randbytes(0x100)))
            stubs = {0x4d36ed: od.Stub(0x4d36ed), 0x4cd218: od.Stub(0x4cd218, this=True)}
            high = rng.randrange(0x10000) << 16
            self.pair(F_4CEB3B, 0x4ceb3b, 81, [this, records, glob], stubs, {'value_5839a9': rng.randrange(1 << 32)},
                      ecx=od.region_va(0), stack=[high | (index & 0xffff)], cleanup=4, native=(index, 0, 0), executed=executed,
                      pointers={'records_5bb5e5': ('records', slack), 'globals_5d1a31': ('glob', 0)})
        self.finish(0x4ceb3b, 81, executed)

    # ---- 0x423f57 ----
    def test_423f57_load_entry(self):
        """FL-19: differential test of m423f57_load_entry (original 0x423f57)"""
        rng = random.Random(0x423f57)
        executed = set()
        for n in range(SCENARIOS):
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x700)), image=False)
            entry = Area('entry', od.region_va(1), bytearray(rng.randbytes(0x20)), image=False)
            struct.pack_into('<I', entry.data, 4, 0 if rng.random() < 0.5 else nonzero(rng))
            struct.pack_into('<I', entry.data, 0, 0 if rng.random() < 0.5 else nonzero(rng))
            value = rng.randrange(1 << 32)
            stubs = {0x4234c8: od.Stub(0x4234c8, this=True), 0x424201: od.Stub(0x424201, args=1, this=True, cleanup=4)}
            self.pair(F_423F57, 0x423f57, 100, [this, entry], stubs, {'value_5c3a47': rng.randrange(1 << 32)}, ecx=od.region_va(0),
                      stack=[od.region_va(1), value], cleanup=8, native=(0, 0, value), p1='entry', executed=executed, returns=True)
        self.finish(0x423f57, 100, executed)

    # ---- 0x4cecf7 ----
    def test_4cecf7_init_descriptor(self):
        """FL-19: differential test of m4cecf7_init_descriptor (original 0x4cecf7)"""
        rng = random.Random(0x4cecf7)
        executed = set()
        for n in range(SCENARIOS):
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x20)), image=False, compare=False)
            glob = Area('glob', 0x5d1a31, bytearray(rng.randbytes(0x100)))
            text = bytearray(rng.randbytes(0x40))
            string = cstring(rng, 0, 36, 'abcXYZ')
            text[:len(string)] = string
            text = Area('text', 0x559b18, text, compare=False)
            self.pair(F_4CECF7, 0x4cecf7, 141, [this, glob, text], {}, {'self_address': od.region_va(0)}, ecx=od.region_va(0),
                      executed=executed, pointers={'globals_5d1a31': ('glob', 0), 'string_559b18': ('text', 0)})
        self.finish(0x4cecf7, 141, executed)

    # ---- 0x4ea269 ----
    def test_4ea269_select_piece(self):
        """FL-19: differential test of m4ea269_select_piece (original 0x4ea269)"""
        rng = random.Random(0x4ea269)
        executed = set()
        for n in range(SCENARIOS):
            piece = rng.choice([-2, -1, 0, 1, 2, 3])
            mode = rng.choice([1, 1, 0, 2, -1, 0x7fff])
            flag = rng.choice([0, 0, 1, rng.randrange(1 << 32)])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0xc00)), image=False)
            g = {name: rng.randrange(1 << 32) for name in ('value_5bb57b', 'value_5bb59b', 'value_5bb59f', 'value_5bb5a3', 'value_583999')}
            g.update({name: rng.randrange(1 << 16) for name in ('word_5bb599', 'word_5bb595', 'word_5c39ff')})
            g['word_583f1d'] = rng.choice([0xffff, 0xffff, 0, 1, rng.randrange(1 << 16)])
            stubs = {0x4e9e84: od.Stub(0x4e9e84, args=2, this=True, cleanup=8), 0x4eb70f: od.Stub(0x4eb70f, args=1, this=True, cleanup=4),
                     0x4ea06c: od.Stub(0x4ea06c, args=1, this=True, cleanup=4), 0x4fb2e3: od.Stub(0x4fb2e3, args=1, this=True, cleanup=4),
                     0x4e7d04: od.Stub(0x4e7d04, this=True)}
            stack = [(rng.randrange(0x10000) << 16) | (piece & 0xffff), (rng.randrange(0x10000) << 16) | (mode & 0xffff), flag]
            self.pair(F_4EA269, 0x4ea269, 248, [this], stubs, g, ecx=od.region_va(0), stack=stack, cleanup=12, native=(piece, mode, flag),
                      executed=executed, word_args={0x4e9e84: {0}, 0x4ea06c: {0}})
        self.finish(0x4ea269, 248, executed)

    # ---- 0x4ccdab ----
    def test_4ccdab_reset_object(self):
        """FL-19: differential test of m4ccdab_reset_object (original 0x4ccdab)"""
        rng = random.Random(0x4ccdab)
        executed = set()
        for n in range(60):
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x300)), image=False)
            glob = Area('glob', 0x5d1a31, bytearray(rng.randbytes(0x100)))
            self.pair(F_4CCDAB, 0x4ccdab, 326, [this, glob], {}, {}, ecx=od.region_va(0), executed=executed,
                      pointers={'globals_5d1a31': ('glob', 0)})
        self.finish(0x4ccdab, 326, executed)

    # ---- 0x47e2a5 ----
    def test_47e2a5_release_surfaces(self):
        """FL-19: differential test of m47e2a5_release_surfaces (original 0x47e2a5)"""
        rng = random.Random(0x47e2a5)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x1400))
            density = rng.choice([0.1, 0.5, 0.9])
            for off in (0x13a4, 0x13a8, 0x13ac):
                struct.pack_into('<I', data, off, 0 if rng.random() < 0.5 else nonzero(rng))
            for i in range(0x14):
                for j in range(4):
                    struct.pack_into('<I', data, 0x20 + i * 0x60 + j * 0x18, 0 if rng.random() > density else nonzero(rng))
            struct.pack_into('<h', data, 0x1c, rng.choice([-1, -1, 0, 3, 0x7fff, -2]))
            this = Area('self', od.region_va(0), data, image=False)
            stubs = {0x4c2dfb: od.Stub(0x4c2dfb, args=1, this=True, cleanup=4), 0x4d3992: od.Stub(0x4d3992, args=1),
                     0x47e25a: od.Stub(0x47e25a, this=True)}
            self.pair(F_47E2A5, 0x47e2a5, 338, [this], stubs, {}, ecx=od.region_va(0), executed=executed, word_args={0x4d3992: {0}})
        self.finish(0x47e2a5, 338, executed)

    # ---- 0x423259 ----
    def test_423259_find_by_name(self):
        """FL-19: differential test of m423259_find_by_name (original 0x423259)"""
        rng = random.Random(0x423259)
        executed = set()
        for n in range(SCENARIOS):
            name = cstring(rng, 8, 15)
            this = bytearray(rng.randbytes(0x100))
            nodes = [Area('n%d' % k, od.region_va(2 + k), bytearray(rng.randbytes(0x80)), image=False) for k in range(3)]
            index = rng.choice([0, 1, 2, 5, 0x3f])
            struct.pack_into('<I', this, index * 4, rng.choice([nodes[0].va] * 5 + [0]))
            for k, node in enumerate(nodes):
                text = bytearray(name)
                if rng.random() < 0.6:
                    text[rng.randrange(len(text) - 1)] = rng.choice(b'abAB')
                if rng.random() < 0.3:
                    text = bytearray(cstring(rng, 8, 15))
                node.data[4:4 + len(text)] = text
                struct.pack_into('<I', node.data, 0x25, nodes[k + 1].va if k < 2 and rng.random() < 0.85 else 0)
            areas = [Area('self', od.region_va(0), this, image=False), Area('name', od.region_va(1), bytearray(name), image=False), *nodes]
            stubs = {0x423368: od.Stub(0x423368, args=1, this=True, cleanup=4, results=[index]),
                     0x50d0bc: od.Stub(0x50d0bc, args=1, deref=(0, 8))}
            self.pair(F_423259, 0x423259, 271, areas, stubs, {}, ecx=od.region_va(0), stack=[od.region_va(1)], cleanup=4, p1='name',
                      executed=executed, returns=True)
        self.finish(0x423259, 271, executed)

    # ---- 0x4e89eb ----
    def test_4e89eb_layout_slots(self):
        """FL-19: differential test of m4e89eb_layout_slots (original 0x4e89eb)"""
        rng = random.Random(0x4e89eb)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x8300))
            struct.pack_into('<I', data, 0x764c, rng.choice([2, 3, 2, 3, 0, 1, 5]))
            for k in range(6):
                struct.pack_into('<I', data, 0x7012 + k * 0xf7, 0 if rng.random() < 0.5 else nonzero(rng))
            struct.pack_into('<i', data, 0x822e, rng.choice([0, 3, -2, 9, rng.randrange(-10, 20)]))
            areas = [Area('self', od.region_va(0), data, image=False), Area('t30', 0x5b30cc, bytearray(rng.randbytes(0x100)), compare=False),
                     Area('t3e', 0x5b3e40, bytearray(rng.randbytes(0x100)), compare=False),
                     Area('t3a', 0x5b3ae8, bytearray(rng.randbytes(0x100)), compare=False)]
            g = {'value_5b44f0': rng.randrange(0, 10), 'value_5b44f4': rng.randrange(0, 4), 'value_583102': rng.randrange(1 << 32),
                 'value_583106': rng.randrange(1 << 32), 'value_5c3a5b': rng.randrange(1 << 32), 'value_5c3a5f': rng.randrange(1 << 32)}
            stubs = {0x4ee2a9: od.Stub(0x4ee2a9, this=True, results=[rng.choice([0, 0, 0, 1, 0x100, 0x80000000])]),
                     0x4e22fd: od.Stub(0x4e22fd, args=2, this=True, cleanup=8), 0x4e8bb4: od.Stub(0x4e8bb4, this=True)}
            self.pair(F_4E89EB, 0x4e89eb, 457, areas, stubs, g, ecx=od.region_va(0), executed=executed, word_args={0x4e22fd: {0, 1}},
                      pointers={'table_5b30cc': ('t30', 0), 'table_5b3e40': ('t3e', 0), 'table_5b3ae8': ('t3a', 0)})
        self.finish(0x4e89eb, 457, executed)

    # ---- 0x4e444d ----
    def test_4e444d_find_name(self):
        """FL-19: differential test of m4e444d_find_name (original 0x4e444d)"""
        rng = random.Random(0x4e444d)
        executed = set()
        for n in range(SCENARIOS):
            kind = rng.choice([0, 0, 1, 2, -1, 0x4000, -32768])
            t26, t43 = bytearray(0x4a * 6), bytearray(0x29 * 6)
            entries = []
            for table, stride in ((t26, 0x4a), (t43, 0x29)):
                for i in range(6):
                    text = cstring(rng, 0, 5, 'ab')
                    entries.append(text)
                    table[i * stride:i * stride + len(text)] = text
            name = rng.choice(entries) if rng.random() < 0.6 else cstring(rng, 0, 5, 'ab')
            if rng.random() < 0.15:
                name = name[:-1] + b'a\0'
            areas = [Area('t26', 0x5a2664, t26, compare=False), Area('t43', 0x5a434c, t43, compare=False),
                     Area('out', od.region_va(1), bytearray(rng.randbytes(8)), image=False),
                     Area('name', od.region_va(2), bytearray(name), image=False)]
            g = {'word_5a1e5e': rng.choice([0, 1, 2, 3, 6, 0xffff]), 'word_5a1e60': rng.choice([0, 1, 2, 4, 6, 0xffff])}
            stack = [(rng.randrange(0x10000) << 16) | (kind & 0xffff), od.region_va(1), od.region_va(2)]
            self.pair(F_4E444D, 0x4e444d, 369, areas, {}, g, stack=stack, cleanup=12, native=(kind, 0, 0), p1='out', p2='name',
                      executed=executed, returns=True, pointers={'table_5a2664': ('t26', 0), 'table_5a434c': ('t43', 0)})
        self.finish(0x4e444d, 369, executed)

    # ---- 0x4b617a ----
    def test_4b617a_arm_piece(self):
        """FL-19: differential test of m4b617a_arm_piece (original 0x4b617a)"""
        rng = random.Random(0x4b617a)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x300))
            struct.pack_into('<h', data, 0x1e, rng.choice([-1, 0, 1, 2, 3]))
            struct.pack_into('<I', data, 0x225, nonzero(rng) if rng.random() < 0.85 else 0)
            data[0x22a] = 0 if rng.random() < 0.85 else rng.randrange(1, 256)
            struct.pack_into('<I', data, 0x274, 0 if rng.random() < 0.85 else nonzero(rng))
            struct.pack_into('<h', data, 0x252, rng.choice([-1, 0, 1, 2, 3, 4, 5]))
            bytes9 = bytearray(rng.randbytes(9))
            objects = []
            for k in range(2):
                obj = bytearray(rng.randbytes(0x400))
                struct.pack_into('<h', obj, 0x21, rng.choice([-1, 0, 1, 2, 3, 6]))
                for sel in range(-1, 6):
                    for i in range(4):
                        struct.pack_into('<h', obj, 0x254 + sel * 8 + i * 2, rng.choice([0, 0, 1, 2, 3, -1, -2, 4, 5]))
                obj[0x2d9:0x2d9 + 9] = bytes9 if rng.random() < 0.5 else bytearray(rng.randbytes(9))
                objects.append(Area('o%d' % k, od.region_va(1 + k), obj, image=False, compare=False))
            records, slack = self.records_area(rng, 6, 1)
            self.point_records(records, objects)
            for i in range(7):
                struct.pack_into('<I', records.data, i * 0x8d + 0x4d, rng.choice([1, 1, 1, 1, 0, 2, 3]))
            g = {'value_5c39e5': rng.choice([0x276d, 0x276c, 0x276c, 0x276c, 0x276c, 0x1234, rng.randrange(1 << 32)]),
                 'value_5bb1ca': rng.choice([0, 1, 0x80000000])}
            stubs = {0x4f6334: od.Stub(0x4f6334, args=1, this=True, cleanup=4, results=[rng.choice([0, 0, 0, 1, 0x100])]),
                     0x4fb2e3: od.Stub(0x4fb2e3, args=1, this=True, cleanup=4)}
            areas = [Area('self', od.region_va(0), data, image=False), *objects, records, Area('b551', 0x551b18, bytes9, compare=False)]
            self.pair(F_4B617A, 0x4b617a, 475, areas, stubs, g, ecx=od.region_va(0), executed=executed, word_args={0x4fb2e3: {0}},
                      pointers={'records_5bb5e5': ('records', slack), 'bytes_551b18': ('b551', 0)})
        self.finish(0x4b617a, 475, executed)

    # ---- 0x4ccff5 ----
    def test_4ccff5_free_piece(self):
        """FL-19: differential test of m4ccff5_free_piece (original 0x4ccff5)"""
        rng = random.Random(0x4ccff5)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x300))
            struct.pack_into('<I', data, 0x23e, rng.choice([0xffffffff, 0, 1, 2, 3, 4]) if rng.random() < 0.9 else 0xffffffff)
            struct.pack_into('<I', data, 0x222, od.region_va(1))
            struct.pack_into('<I', data, 0x226, od.region_va(2) if rng.random() < 0.7 else 0)
            struct.pack_into('<I', data, 0x22a, rng.choice([0, nonzero(rng)]))
            obj_area = Area('obj', od.region_va(1), bytearray(rng.randbytes(0x40)), image=False)
            arr = bytearray(rng.randbytes(0x35 * 3 + 0x40))
            for i in range(3):
                struct.pack_into('<I', arr, i * 0x35 + 0x31, 0 if rng.random() < 0.4 else nonzero(rng))
            records, slack = self.records_area(rng, 6, 1)
            for i in range(7):
                struct.pack_into('<I', records.data, i * 0x8d, 0 if rng.random() < 0.35 else nonzero(rng))
            this = Area('self', od.region_va(0), data, image=False)
            # the element count of the array is the signed word [obj + 0x23]
            struct.pack_into('<h', obj_area.data, 0x23, rng.choice([-1, 0, 1, 2, 3]))
            stubs = {0x51dc6c: od.Stub(0x51dc6c, args=1), 0x423b51: od.Stub(0x423b51, args=1, this=True, cleanup=4)}
            self.pair(F_4CCFF5, 0x4ccff5, 547, [this, obj_area, Area('arr', od.region_va(2), arr, image=False), records], stubs, {},
                      ecx=od.region_va(0), executed=executed, pointers={'records_5bb5e5': ('records', slack)})
        self.finish(0x4ccff5, 547, executed)

    # ---- the rectangle hit tests ----
    def rect(self, rng, span=40, extent=40):
        lo = rng.randrange(-5, span)
        return lo, lo + rng.randrange(0, extent)

    def put_rect(self, data, off_xlo, off_ylo, off_xhi, off_yhi, rng):
        """Four dwords {xlo, ylo, xhi, yhi} at the four offsets; returns the rectangle."""
        xlo, xhi = self.rect(rng)
        ylo, yhi = self.rect(rng)
        for off, value in ((off_xlo, xlo), (off_ylo, ylo), (off_xhi, xhi), (off_yhi, yhi)):
            struct.pack_into('<i', data, off, value)
        return xlo, ylo, xhi, yhi

    def pick_point(self, rng, rects):
        """Either a random point or one inside / on the edge of a random rectangle."""
        if rects and rng.random() < 0.6:
            xlo, ylo, xhi, yhi = rng.choice(rects)
            return rng.choice([xlo, xhi, rng.randrange(xlo, xhi + 1)]), rng.choice([ylo, yhi, rng.randrange(ylo, yhi + 1)])
        return rng.randrange(-8, 70), rng.randrange(-8, 70)

    # ---- 0x48d1e8 ----
    def test_48d1e8_hit_test(self):
        """FL-19: differential test of m48d1e8_hit_test (original 0x48d1e8)"""
        rng = random.Random(0x48d1e8)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x80))
            struct.pack_into('<I', data, 0x33, 0 if rng.random() < 0.12 else nonzero(rng))
            struct.pack_into('<h', data, 0x1e, rng.choice([-1, 0, 1, 2, 3]))
            data[0x26] = rng.choice([0, 0, 0x10, 1])
            struct.pack_into('<h', data, 0x27, rng.choice([-1, 0, 1, 2, 3]))
            objects, rects = [], []
            for k in range(2):
                obj = bytearray(rng.randbytes(0x900))
                struct.pack_into('<h', obj, 0x21, rng.choice([-1, 0, 1, 2, 3, 4]))
                mine = [self.put_rect(obj, 0x7ab, 0x7af, 0x7b3, 0x7b7, rng)]
                for i in range(4):
                    mine.append(self.put_rect(obj, 0x203 + i * 16, 0x207 + i * 16, 0x20b + i * 16, 0x20f + i * 16, rng))
                    mine.append(self.put_rect(obj, 0x113 + i * 16, 0x117 + i * 16, 0x11b + i * 16, 0x11f + i * 16, rng))
                objects.append(Area('o%d' % k, od.region_va(1 + k), obj, image=False, compare=False))
                rects.append(mine)
            records, slack = self.records_area(rng, 6, 1)
            self.point_records(records, objects)
            index = struct.unpack_from('<h', data, 0x1e)[0]
            x, y = self.pick_point(rng, rects[(index + 1) % 2])
            stubs = {0x48d3cb: od.Stub(0x48d3cb, args=2, this=True, cleanup=8)}
            stack = [(rng.randrange(0x10000) << 16) | (x & 0xffff), (rng.randrange(0x10000) << 16) | (y & 0xffff)]
            self.pair(F_48D1E8, 0x48d1e8, 483, [Area('self', od.region_va(0), data, image=False), *objects, records], stubs, {},
                      ecx=od.region_va(0), stack=stack, cleanup=8, native=(x, y, 0), executed=executed, returns=True,
                      word_args={0x48d3cb: {1}}, pointers={'records_5bb5e5': ('records', slack)})
        self.finish(0x48d1e8, 483, executed)

    # ---- 0x475da4 ----
    def test_475da4_hit_test(self):
        """FL-19: differential test of m475da4_hit_test (original 0x475da4)"""
        rng = random.Random(0x475da4)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x900))
            struct.pack_into('<I', data, 0x89a, 0 if rng.random() < 0.08 else nonzero(rng))
            struct.pack_into('<I', data, 0x2c, rng.choice([2, 2, 0, 1, 3]) if rng.random() < 0.1 else rng.choice([0, 1, 3]))
            struct.pack_into('<h', data, 0x22, rng.choice([-1, 0, 1, 2, 3]))
            objects, rects = [], []
            for k in range(2):
                obj = bytearray(rng.randbytes(0x900))
                struct.pack_into('<h', obj, 0x42, rng.choice([-1, 0, 1, 2, 3]))
                struct.pack_into('<h', obj, 0x44, rng.choice([-1, 0, 1, 2, 3]))
                mine = [self.put_rect(obj, 0x678, 0x67c, 0x680, 0x684, rng), self.put_rect(obj, 0x7e2, 0x7e6, 0x7ea, 0x7ee, rng)]
                objects.append(Area('o%d' % k, od.region_va(1 + k), obj, image=False, compare=False))
                rects.append(mine)
            cells = []
            for i in range(3):
                for j in range(3):
                    # the rectangles of the cells are tested with a margin of 3 inside
                    xlo, xhi = self.rect(rng, 40, 60)
                    ylo, yhi = self.rect(rng, 40, 60)
                    base = 0x30 + i * 0xc8 + j * 0x14
                    for off, value in ((4, xlo), (8, ylo), (0xc, xhi), (0x10, yhi)):
                        struct.pack_into('<i', data, base + off, value)
                    cells.append((xlo + 3, ylo + 3, xhi - 3, yhi - 3))
            records, slack = self.records_area(rng, 6, 1)
            self.point_records(records, objects)
            index = struct.unpack_from('<h', data, 0x22)[0]
            good = [c for c in cells if c[0] <= c[2] and c[1] <= c[3]]
            x, y = self.pick_point(rng, rects[(index + 1) % 2] + good)
            stubs = {0x475fb1: od.Stub(0x475fb1, args=1, this=True, cleanup=4)}
            stack = [(rng.randrange(0x10000) << 16) | (x & 0xffff), (rng.randrange(0x10000) << 16) | (y & 0xffff)]
            self.pair(F_475DA4, 0x475da4, 525, [Area('self', od.region_va(0), data, image=False), *objects, records], stubs, {},
                      ecx=od.region_va(0), stack=stack, cleanup=8, native=(x, y, 0), executed=executed, returns=True,
                      pointers={'records_5bb5e5': ('records', slack)})
        self.finish(0x475da4, 525, executed)

    # ---- 0x4ee2a9 ----
    def test_4ee2a9_hit_slots(self):
        """FL-19: differential test of m4ee2a9_hit_slots (original 0x4ee2a9)"""
        rng = random.Random(0x4ee2a9)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x600))
            struct.pack_into('<I', data, 0x4af, rng.choice([0, 1, 2, 3, 2, 3]))
            for off in (0x15f, 0x252):
                struct.pack_into('<I', data, off, 0 if rng.random() < 0.4 else nonzero(rng))
            areas = [Area('self', od.region_va(0), data, image=False), Area('t30', 0x5b30cc, bytearray(rng.randbytes(0x300)), compare=False),
                     Area('t3e', 0x5b3e40, bytearray(rng.randbytes(0x300)), compare=False),
                     Area('t3a', 0x5b3ae8, bytearray(rng.randbytes(0x200)), compare=False)]
            g = {name: rng.randrange(1 << 32) for name in ('value_5b44f0', 'value_5b44f4', 'value_5d162d', 'value_5d1631', 'value_5d1639',
                                                           'value_5c3a5b', 'value_5c3a5f', 'value_583102', 'value_583106', 'value_5d0377',
                                                           'value_571ad3')}
            g['value_5c39e9'] = rng.choice([0, 0, 1, rng.randrange(1 << 32)])
            g['word_583a29'] = rng.choice([0xffff, 0xffff, 0, 1, 3, 5, 0xfffc])
            g['value_5b44f8'] = rng.choice([0, 0, 1, 5])
            stubs = {0x4e22fd: od.Stub(0x4e22fd, args=2, this=True, cleanup=8, results=[rng.choice([0, 0, 1, 0x100])]),
                     0x4ef2d1: od.Stub(0x4ef2d1, args=2, this=True, cleanup=8, results=[rng.choice([0, 0, 1, 0x80000000])])}
            self.pair(F_4EE2A9, 0x4ee2a9, 622, areas, stubs, g, ecx=od.region_va(0), executed=executed, returns=True,
                      word_args={0x4e22fd: {0, 1}, 0x4ef2d1: {0, 1}},
                      pointers={'table_5b30cc': ('t30', 0), 'table_5b3e40': ('t3e', 0), 'table_5b3ae8': ('t3a', 0)})
        self.finish(0x4ee2a9, 622, executed)

    # ---- 0x48bd91 ----
    def test_48bd91_hit_test(self):
        """FL-19: differential test of m48bd91_hit_test (original 0x48bd91)"""
        rng = random.Random(0x48bd91)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x80))
            struct.pack_into('<h', data, 0x26, rng.choice([-1, 0, 1, 2, 3]))
            data[0x46] = 0 if rng.random() < 0.12 else rng.choice([1, 0x80, 0xff])
            objects, rects = [], []
            for k in range(2):
                obj = bytearray(rng.randbytes(0x300))
                mine = [self.put_rect(obj, 0x14e, 0x152, 0x156, 0x15a, rng)]
                for i in range(4):
                    mine.append(self.put_rect(obj, 0x74 + i * 16, 0x78 + i * 16, 0x7c + i * 16, 0x80 + i * 16, rng))
                struct.pack_into('<h', obj, 0x15e, rng.choice([-1, 0, 1, 2, 3]))
                dx, dy = rng.randrange(-20, 20), rng.randrange(-20, 20)
                struct.pack_into('<i', obj, 0x64, dx)
                struct.pack_into('<i', obj, 0x68, dy)
                for i in range(3):
                    xlo, ylo, xhi, yhi = self.put_rect(obj, 0x162 + i * 0x12, 0x166 + i * 0x12, 0x16a + i * 0x12, 0x16e + i * 0x12, rng)
                    mine.append((xlo + dx, ylo + dy, xhi + dx, yhi + dy))
                objects.append(Area('o%d' % k, od.region_va(1 + k), obj, image=False, compare=False))
                rects.append(mine)
            records, slack = self.records_area(rng, 6, 1)
            self.point_records(records, objects)
            index = struct.unpack_from('<h', data, 0x26)[0]
            x, y = self.pick_point(rng, rects[(index + 1) % 2])
            g = {name: rng.randrange(1 << 32) for name in ('value_5b44f0', 'value_5b44f4', 'value_5d162d', 'value_5d1631', 'value_5d1639',
                                                           'value_5c39e5', 'value_5d0377', 'value_571ad3')}
            g['word_583a29'] = rng.choice([0xffff, 0xffff, 0, 3, 5, 0xfffd])
            g['value_5b44f8'] = rng.choice([0, 0, 1, 5])
            stack = [(rng.randrange(0x10000) << 16) | (x & 0xffff), (rng.randrange(0x10000) << 16) | (y & 0xffff)]
            self.pair(F_48BD91, 0x48bd91, 795, [Area('self', od.region_va(0), data, image=False), *objects, records], {}, g,
                      ecx=od.region_va(0), stack=stack, cleanup=8, native=(x, y, 0), executed=executed, returns=True,
                      pointers={'records_5bb5e5': ('records', slack)})
        self.finish(0x48bd91, 795, executed)


if __name__ == '__main__':
    unittest.main()
