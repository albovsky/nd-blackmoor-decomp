"""FL-18 differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl18.c on the same random fixtures.

See test_fl_differential.py and original_differential.py for the method. Every case compares all the memory the function can write
(objects, record tables, globals), the return value where there is one, how many bytes the function popped, and the ordered calls out:
callee, ecx, stack arguments (pointers into a fixture are compared as the original addresses they stand for, pointers to a local of the
function as 'L'; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits) and the bytes behind a
pointer argument where the call is described that way. The callees themselves are recording stubs; the function under test runs as
the original bytes. A case also requires that its scenarios reached every instruction of the original function.
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

SCENARIOS = 300
LOCAL = 'L'


class ShimWorld(ctypes.Structure):
    _fields_ = [(n, ctypes.c_void_p) for n in ('records', 'words_5afbda', 'dwords_5d032f', 'table_5a1e62', 'table_5d1599',
                                               'bytes_5495b0', 'bytes_54b158', 'flags_585801', 'string_5b618e')] + \
               [('value_5cf665', ctypes.c_uint32), ('word_61d467', ctypes.c_int32), ('word_61d465', ctypes.c_int32),
                ('word_5a1e5c', ctypes.c_uint32)] + \
               [(n, ctypes.c_uint32) for n in ('value_5c39e5', 'value_5d0377', 'value_5d162d', 'value_5b44f0', 'value_5b44f4',
                                               'value_5d1631', 'value_5d1639', 'value_638483', 'value_63848d')] + \
               [('origin_x', ctypes.c_int32), ('origin_y', ctypes.c_int32), ('value_5bb1ca', ctypes.c_uint32)] + \
               [(n, ctypes.c_uint32) for n in ('value_5d19fb', 'value_5839a9', 'value_5c39f9', 'value_5bb57b', 'value_5bb59b',
                                               'value_5bb59f', 'value_5bb5a3', 'value_583999', 'word_5bb599', 'word_5bb595',
                                               'word_5c39ff')] + \
               [('word_5b61b0', ctypes.c_int32)] + \
               [(n, ctypes.c_uint32) for n in ('value_5d15e3', 'word_5b61dd', 'word_5b61d1', 'word_5b61e1', 'word_5b61ed')] + \
               [('result', ctypes.c_int32)]


# the globals of the original that a case may set, with their address and size
GLOBALS = {
    'value_5cf665': (0x5cf665, 4), 'word_61d467': (0x61d467, 2), 'word_61d465': (0x61d465, 2), 'word_5a1e5c': (0x5a1e5c, 2),
    'value_5c39e5': (0x5c39e5, 4), 'value_5d0377': (0x5d0377, 4), 'value_5d162d': (0x5d162d, 4), 'value_5b44f0': (0x5b44f0, 4),
    'value_5b44f4': (0x5b44f4, 4), 'value_5d1631': (0x5d1631, 4), 'value_5d1639': (0x5d1639, 4), 'value_638483': (0x638483, 4),
    'value_63848d': (0x63848d, 4), 'origin_x': (0x583186, 4), 'origin_y': (0x58318a, 4), 'value_5bb1ca': (0x5bb1ca, 4),
    'value_5d19fb': (0x5d19fb, 4), 'value_5839a9': (0x5839a9, 4), 'value_5c39f9': (0x5c39f9, 4), 'value_5bb57b': (0x5bb57b, 4),
    'value_5bb59b': (0x5bb59b, 4), 'value_5bb59f': (0x5bb59f, 4), 'value_5bb5a3': (0x5bb5a3, 4), 'value_583999': (0x583999, 4),
    'word_5bb599': (0x5bb599, 2), 'word_5bb595': (0x5bb595, 2), 'word_5c39ff': (0x5c39ff, 2), 'word_5b61b0': (0x5b61b0, 2),
    'value_5d15e3': (0x5d15e3, 4), 'word_5b61dd': (0x5b61dd, 2), 'word_5b61d1': (0x5b61d1, 2), 'word_5b61e1': (0x5b61e1, 2),
    'word_5b61ed': (0x5b61ed, 2),
}
FMT = {2: '<H', 4: '<I'}
TICK_SLOT = 0x52a23c


@dataclass
class Area:
    name: str
    va: int
    data: bytearray
    image: bool = True      # inside the image (a global or table) or a region outside it
    compare: bool = True


def words(*items):
    return bytearray(b''.join(struct.pack('<H', i & 0xffff) for i in items))


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl18Differential(DiffBase):
    def native_calls18(self, areas, deref_len=None):
        """The shim's call log as comparable tuples: (callee, this, *args, *data)."""
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
            if c.id in (deref_len or {}):
                entry.append(bytes(c.data[0])[:deref_len[c.id]])
            out.append(entry)
        return out

    def normalize_original(self, calls, stubs, iat):
        by_name = {s.name: s for s in [*stubs.values(), *iat.values()]}
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

    def pair(self, fn_id, va, size, areas, stubs, g, *, ecx=0, stack=(), iat=None, cleanup=0, word_args=None, self_name='self',
             native_args=(0, 0), set_tick=None, scripts=(), executed=None, bytes_5495b0=None, bytes_54b158=None, pointers=None):
        """Run the original and the native function on one fixture and compare. `g` maps ShimWorld field names to initial values
        (globals); `pointers` maps ShimWorld pointer field names to (area name, offset)."""
        iat = dict(iat or {})
        image_patches = [(a.va, a.data) for a in areas if a.image]
        for field, value in g.items():
            if field in GLOBALS:
                address, size_ = GLOBALS[field]
                image_patches.append((address, struct.pack(FMT[size_], value & ((1 << (8 * size_)) - 1))))
        regions = {a.name: (a.va, a.data) for a in areas if not a.image}
        read = {a.name: (a.va, len(a.data)) for a in areas if a.compare}
        for field in g:
            if field in GLOBALS:
                read['g:' + field] = (GLOBALS[field][0], GLOBALS[field][1])
        orig = od.Original(image_patches, regions, stubs, iat).run(va, size, ecx=ecx, stack_args=stack, read=read)
        self.assertEqual(orig.cleanup, cleanup)
        # native
        self.lib.shim_reset()
        self.lib.shim_script_reset()
        arrays = []
        by_name = {}
        for a in areas:
            arr = buf(a.data)
            by_name[a.name] = arr
            arrays.append((a, arr))
            self.lib.shim_add_region(a.va, ptr(arr), len(arr))
        sw = ShimWorld()
        for field, value in g.items():
            if field in GLOBALS and field not in ('origin_x', 'origin_y'):
                setattr(sw, field, value & 0xffffffff if GLOBALS[field][1] == 4 else value)
            elif field in ('origin_x', 'origin_y'):
                setattr(sw, field, struct.unpack('<i', struct.pack('<I', value & 0xffffffff))[0])
        for field, (name, offset) in (pointers or {}).items():
            setattr(sw, field, ctypes.cast(ctypes.byref(by_name[name], offset), ctypes.c_void_p).value)
        if bytes_5495b0 is not None:
            by_name['_b5495b0'] = buf(bytes_5495b0)
            sw.bytes_5495b0 = ctypes.cast(by_name['_b5495b0'], ctypes.c_void_p).value
        if bytes_54b158 is not None:
            by_name['_b54b158'] = buf(bytes_54b158)
            sw.bytes_54b158 = ctypes.cast(by_name['_b54b158'], ctypes.c_void_p).value
        for stub in [*stubs.values(), *iat.values()]:
            for r in (stub.results or ([stub.result] if stub.result else [])):
                self.lib.shim_script_return(stub.name, r)
            if stub.out is not None:
                self.lib.shim_script_out(stub.name, ctypes.c_uint64(stub.out), 0)
            if stub.deref is not None:
                self.lib.shim_script_deref(stub.name, stub.deref[0], stub.deref[1])
        for name, (callee, value) in scripts:
            self.lib.shim_script_out(callee, ctypes.c_uint64(value), 1)
        if set_tick is not None:
            self.lib.shim_set_tick(set_tick)
        self_ptr = ptr(by_name[self_name]) if self_name in by_name else None
        self.lib.shim_fl18(fn_id, self_ptr, native_args[0], native_args[1], ctypes.byref(sw))
        for a in areas:
            if a.compare:
                self.assertEqual(bytes(by_name[a.name]), orig.memory[a.name], a.name)
        for field in g:
            if field in GLOBALS:
                address, size_ = GLOBALS[field]
                native_value = getattr(sw, field) & ((1 << (8 * size_)) - 1)
                self.assertEqual(struct.pack(FMT[size_], native_value), orig.memory['g:' + field], field)
        expected = self.normalize_original(orig.calls, stubs, iat)
        actual = self.native_calls18(arrays, {x.name: x.deref[1] for x in [*stubs.values(), *iat.values()] if x.deref})
        for calls in (expected, actual):
            for entry in calls:
                for index in (word_args or {}).get(entry[0], ()):
                    entry[2 + index] = entry[2 + index] & 0xffff
        self.assertEqual(actual, expected)
        if executed is not None:
            executed |= orig.executed
        return orig, sw

    def finish(self, va, size, executed):
        missing = sorted(od.instruction_addresses(va, size) - executed)
        self.assertEqual(missing, [], 'scenarios never reached original instructions %s' % [hex(a) for a in missing])

    # ---- helpers for the shared shapes ----
    def records_area(self, rng, nrec=6, slack=1):
        """The record table at 0x5bb5e5 (stride 0x8d) with `slack` records below it."""
        return Area('records', 0x5bb5e5 - slack * 0x8d, bytearray(rng.randbytes((slack + nrec) * 0x8d))), slack * 0x8d

    # ---- 0x4c924d ----
    def test_4c924d_count_up(self):
        """FL-18: differential test of m4c924d_count_up (original 0x4c924d)"""
        rng = random.Random(0x4c924d)
        executed = set()
        for n in range(SCENARIOS):
            index = rng.choice([-3, -1, 0, 1, 2, 5])
            words_a = Area('words', 0x5afbda - 16, bytearray(rng.randbytes(32)))
            for i in range(-3, 6):
                struct.pack_into('<H', words_a.data, 16 + i * 2, rng.choice([0, 0, 1, 0xffff, rng.randrange(0x10000)]))
            dwords_a = Area('dwords', 0x5d032f - 32, bytearray(rng.randbytes(96)))
            for i in range(-3, 6):
                struct.pack_into('<I', dwords_a.data, 32 + i * 4, rng.choice([0, 0, rng.randrange(1 << 32)]))
            stubs = {0x4c2790: od.Stub(0x4c2790, args=4, this=True, cleanup=16, results=[rng.randrange(1 << 32)])}
            high = rng.randrange(0x10000) << 16
            self.pair(1, 0x4c924d, 120, [words_a, dwords_a], stubs, {}, stack=[high | (index & 0xffff)], cleanup=4,
                      native_args=(index, 0), executed=executed,
                      pointers={'words_5afbda': ('words', 16), 'dwords_5d032f': ('dwords', 32)})
        self.finish(0x4c924d, 120, executed)

    # ---- 0x4121b8 ----
    def test_4121b8_start_piece(self):
        """FL-18: differential test of m4121b8_start_piece (original 0x4121b8)"""
        rng = random.Random(0x4121b8)
        executed = set()
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 3, 4])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x1100)), image=False)
            records, slack = self.records_area(rng)
            stubs = {0x413187: od.Stub(0x413187, args=4, this=True, cleanup=16),
                     0x42ba3a: od.Stub(0x42ba3a, args=1),
                     0x411b16: od.Stub(0x411b16, args=3, this=True, cleanup=12)}
            high = rng.randrange(0x10000) << 16
            self.pair(2, 0x4121b8, 124, [this, records], stubs, {}, ecx=od.region_va(0), stack=[high | (index & 0xffff)], cleanup=4,
                      native_args=(index, 0), executed=executed, word_args={0x42ba3a: {0}, 0x411b16: {1}},
                      pointers={'records': ('records', slack)})
        self.finish(0x4121b8, 124, executed)

    # ---- 0x4e7bf3 and 0x4e8dc8 (the six-slot loops) ----
    def slot_object(self, rng):
        this = bytearray(rng.randbytes(0x8240))
        for k in range(6):
            if rng.random() < 0.5:
                struct.pack_into('<I', this, 0x7012 + k * 0xf7, 0)
        struct.pack_into('<i', this, 0x822e, rng.choice([0, 0, 3, -2, 9, rng.randrange(-10, 20)]))
        return this

    def test_4e7bf3_close_slots(self):
        """FL-18: differential test of m4e7bf3_close_slots (original 0x4e7bf3)"""
        rng = random.Random(0x4e7bf3)
        executed = set()
        for n in range(SCENARIOS):
            this = Area('self', od.region_va(0), self.slot_object(rng), image=False)
            stubs = {0x4e1d34: od.Stub(0x4e1d34, this=True), 0x4e7ba7: od.Stub(0x4e7ba7, this=True)}
            self.pair(3, 0x4e7bf3, 127, [this], stubs, {}, ecx=od.region_va(0), executed=executed)
        self.finish(0x4e7bf3, 127, executed)

    def test_4e8dc8_check_slots(self):
        """FL-18: differential test of m4e8dc8_check_slots (original 0x4e8dc8)"""
        rng = random.Random(0x4e8dc8)
        executed = set()
        for n in range(SCENARIOS):
            data = self.slot_object(rng)
            struct.pack_into('<I', data, 0x764c, rng.choice([0, 1, 2, 3, 3, 2, 4]))
            this = Area('self', od.region_va(0), data, image=False)
            stubs = {0x4ee517: od.Stub(0x4ee517, this=True, results=[rng.choice([0, 0, 0, 1, 0x100, 0x80000000])]),
                     0x4e26fc: od.Stub(0x4e26fc, this=True,
                                       results=[rng.choice([0, 0, 0, 0, 2, 0x10000]) for _ in range(6)]),
                     0x4e8e78: od.Stub(0x4e8e78, this=True)}
            self.pair(8, 0x4e8dc8, 176, [this], stubs, {}, ecx=od.region_va(0), executed=executed)
        self.finish(0x4e8dc8, 176, executed)

    # ---- 0x4b7051 ----
    def test_4b7051_draw_list(self):
        """FL-18: differential test of m4b7051_draw_list (original 0x4b7051)"""
        rng = random.Random(0x4b7051)
        executed = set()
        for n in range(SCENARIOS):
            records, slack = self.records_area(rng, nrec=5, slack=0)
            for i in range(5):
                struct.pack_into('<I', records.data, i * 0x8d, od.region_va(1 + i % 2))
            objects = [Area('o1', od.region_va(1), bytearray(rng.randbytes(0x40)), image=False),
                       Area('o2', od.region_va(2), bytearray(rng.randbytes(0x40)), image=False)]
            for o in objects:
                struct.pack_into('<h', o.data, 0x21, rng.choice([-1, 0, 1, 3, 4]))
            table = Area('t5d1599', 0x5d1599, bytearray(rng.randbytes(0x4a * 4 + 4)), compare=False)
            g = {'word_61d467': rng.randrange(0, 5), 'word_61d465': rng.randrange(0, 4), 'value_5cf665': rng.randrange(1 << 32)}
            stubs = {0x4c5377: od.Stub(0x4c5377, args=5, this=True, cleanup=20)}
            self.pair(4, 0x4b7051, 128, [*objects, records, table], stubs, g, executed=executed,
                      pointers={'records': ('records', 0), 'table_5d1599': ('t5d1599', 0)})
        self.finish(0x4b7051, 128, executed)

    # ---- 0x4b7f3b and 0x4b7ff4 ----
    def test_4b7f3b_reset(self):
        """FL-18: differential test of m4b7f3b_reset (original 0x4b7f3b)"""
        rng = random.Random(0x4b7f3b)
        executed = set()
        for n in range(50):
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x700)), image=False)
            self.pair(5, 0x4b7f3b, 185, [this], {}, {}, ecx=od.region_va(0), executed=executed)
        self.finish(0x4b7f3b, 185, executed)

    def test_4b7ff4_release(self):
        """FL-18: differential test of m4b7ff4_release (original 0x4b7ff4)"""
        rng = random.Random(0x4b7ff4)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x700))
            if rng.random() < 0.4:
                struct.pack_into('<I', data, 0xc, 0)
            struct.pack_into('<h', data, 4, rng.choice([-1, -1, 0, 7]))
            for off in (0x61e, 0x546):
                struct.pack_into('<I', data, off, rng.choice([0xffffffff, 0xffffffff, 0x0001ffff, 0xffff0005, rng.randrange(1 << 32)]))
            this = Area('self', od.region_va(0), data, image=False)
            stubs = {0x4c2dfb: od.Stub(0x4c2dfb, args=1, this=True, cleanup=4),
                     0x4d3992: od.Stub(0x4d3992, args=1),
                     0x4c92c5: od.Stub(0x4c92c5, args=1, this=True, cleanup=4)}
            self.pair(6, 0x4b7ff4, 147, [this], stubs, {}, ecx=od.region_va(0), executed=executed, word_args={0x4d3992: {0}})
        self.finish(0x4b7ff4, 147, executed)

    # ---- 0x4e7253 ----
    def test_4e7253_store_record(self):
        """FL-18: differential test of m4e7253_store_record (original 0x4e7253)"""
        rng = random.Random(0x4e7253)
        executed = set()
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2, 3])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x40)), image=False)
            records, slack = self.records_area(rng, nrec=4, slack=0)
            for i in range(4):
                struct.pack_into('<I', records.data, i * 0x8d, od.region_va(1 + i % 2))
            objects = [Area('o1', od.region_va(1), bytearray(rng.randbytes(0x40)), image=False),
                       Area('o2', od.region_va(2), bytearray(rng.randbytes(0x40)), image=False)]
            table = Area('table', 0x5a1e62, bytearray(rng.randbytes(0x29 * 8)))
            # (a negative index would land on the word 0x5a1e5c and the other globals below the table, which the model does not mirror)
            local = rng.choice([0, 1, 2, 5, 0xabcd0003, 0x00010004])
            stubs = {0x4e45be: od.Stub(0x4e45be, args=4, this=True, cleanup=16, results=[rng.choice([0, 1, 1])], out=local),
                     0x4e3ade: od.Stub(0x4e3ade, this=True),
                     0x4e0559: od.Stub(0x4e0559, args=3, this=True, cleanup=12)}
            g = {'word_5a1e5c': rng.choice([0, 1, 2, 5, 7])}
            high = rng.randrange(0x10000) << 16
            self.pair(7, 0x4e7253, 168, [this, *objects, records, table], stubs, g, ecx=od.region_va(0),
                      stack=[high | index], cleanup=4, native_args=(index, 0), executed=executed,
                      pointers={'records': ('records', 0), 'table_5a1e62': ('table', 0)})
        self.finish(0x4e7253, 168, executed)

    # ---- the hotspot setters 0x45b7a8, 0x4b6097, 0x4b81ff ----
    def hotspot_globals(self, rng):
        return {'value_5c39e5': rng.randrange(1 << 32), 'value_5d0377': rng.randrange(1 << 32), 'value_5d162d': rng.randrange(1 << 32),
                'value_5b44f0': rng.randrange(1 << 8), 'value_5b44f4': rng.randrange(1 << 8), 'value_5d1631': rng.randrange(1 << 32),
                'value_5d1639': rng.randrange(1 << 32)}

    def test_45b7a8_arm_hotspot(self):
        """FL-18: differential test of m45b7a8_arm_hotspot (original 0x45b7a8)"""
        rng = random.Random(0x45b7a8)
        executed = set()
        for n in range(SCENARIOS):
            a = rng.choice([0x27bb, 0x27bb, 0x27ba, -5, 0, 0x7fff, -32768])
            b = rng.choice([0, 1, -1, 0x1234, -32768, 32767])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x200)), image=False)
            stack = [(rng.randrange(0x10000) << 16) | (a & 0xffff), (rng.randrange(0x10000) << 16) | (b & 0xffff)]
            self.pair(9, 0x45b7a8, 202, [this], {}, self.hotspot_globals(rng), ecx=od.region_va(0), stack=stack, cleanup=8,
                      native_args=(a, b), executed=executed)
        self.finish(0x45b7a8, 202, executed)

    def test_4b6097_arm_hotspot(self):
        """FL-18: differential test of m4b6097_arm_hotspot (original 0x4b6097)"""
        rng = random.Random(0x4b6097)
        executed = set()
        for n in range(SCENARIOS):
            a = rng.choice([0x276d, 0x276c, 0x276c, 0x276d, 0x276b, -5, 0])
            b = rng.choice([0, 1, -1, 0x1234, -32768, 32767])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x300)), image=False)
            stack = [(rng.randrange(0x10000) << 16) | (a & 0xffff), (rng.randrange(0x10000) << 16) | (b & 0xffff)]
            self.pair(13, 0x4b6097, 227, [this], {}, self.hotspot_globals(rng), ecx=od.region_va(0), stack=stack, cleanup=8,
                      native_args=(a, b), executed=executed)
        self.finish(0x4b6097, 227, executed)

    def test_4b81ff_hit_test(self):
        """FL-18: differential test of m4b81ff_hit_test (original 0x4b81ff)"""
        rng = random.Random(0x4b81ff)
        executed = set()
        for n in range(SCENARIOS):
            obj = bytearray(rng.randbytes(0x600))
            left, top = rng.randrange(-20, 20), rng.randrange(-20, 20)
            for off, value in ((0x55e, left), (0x562, top), (0x566, left + rng.randrange(0, 30)), (0x56a, top + rng.randrange(0, 30))):
                struct.pack_into('<i', obj, off, value)
            struct.pack_into('<h', obj, 0x55c, rng.choice([0, 5, -3, 0x7fff]))
            this = bytearray(rng.randbytes(0x40))
            struct.pack_into('<I', this, 8, od.region_va(1))
            if rng.random() < 0.2:
                struct.pack_into('<I', this, 0x14, 0)
            areas = [Area('self', od.region_va(0), this, image=False), Area('obj', od.region_va(1), obj, image=False)]
            x = rng.choice([left - 1, left, left + 1, left + 15, left + 31, rng.randrange(-40, 60)])
            y = rng.choice([top - 1, top, top + 1, top + 15, top + 31, rng.randrange(-40, 60)])
            stack = [(rng.randrange(0x10000) << 16) | (x & 0xffff), (rng.randrange(0x10000) << 16) | (y & 0xffff)]
            orig, sw = self.pair(10, 0x4b81ff, 206, areas, {}, self.hotspot_globals(rng), ecx=od.region_va(0), stack=stack,
                                 cleanup=8, native_args=(x, y), executed=executed)
            self.assertEqual(sw.result, struct.unpack('<i', struct.pack('<I', orig.eax))[0])
        self.finish(0x4b81ff, 206, executed)

    # ---- 0x423b51 ----
    def test_423b51_reset_record(self):
        """FL-18: differential test of m423b51_reset_record (original 0x423b51)"""
        rng = random.Random(0x423b51)
        executed = set()
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2, 3])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x40)), image=False)
            records, slack = self.records_area(rng, nrec=4, slack=0)
            other = Area('other', od.region_va(1), bytearray(rng.randbytes(0x40)), image=False)
            if rng.random() < 0.5:
                struct.pack_into('<I', records.data, 4 + index * 0x8d + 4, 0)
            stubs = {0x4234c8: od.Stub(0x4234c8, this=True),
                     0x423876: od.Stub(0x423876, args=2, this=True, cleanup=8, out=od.region_va(1) if rng.random() < 0.5 else None)}
            scripts = [('other', (0x423876, od.region_va(1)))] if stubs[0x423876].out is not None else []
            if stubs[0x423876].out is not None:
                # the callee repoints the slot (a pointer-sized local in the native port, a dword in the original)
                stubs[0x423876].out = od.region_va(1)
            self.pair(11, 0x423b51, 218, [this, records, other], stubs, {}, ecx=od.region_va(0), stack=[index], cleanup=4,
                      native_args=(index, 0), executed=executed, scripts=scripts,
                      pointers={'records': ('records', 0)})
        self.finish(0x423b51, 218, executed)

    # ---- 0x4cc79a ----
    def test_4cc79a_draw_rects(self):
        """FL-18: differential test of m4cc79a_draw_rects (original 0x4cc79a)"""
        rng = random.Random(0x4cc79a)
        executed = set()
        for n in range(SCENARIOS):
            listing = bytearray(rng.randbytes(0x20))
            struct.pack_into('<h', listing, 2, rng.choice([-1, 0, 1, 2, 3]))
            struct.pack_into('<I', listing, 9, od.region_va(1))
            entries = bytearray(rng.randbytes(0x18 * 4))
            areas = [Area('list', od.region_va(0), listing, image=False), Area('entries', od.region_va(1), entries, image=False)]
            g = {'value_638483': rng.choice([0, 1, 1, 7]), 'value_63848d': od.region_va(0), 'value_5cf665': rng.randrange(1 << 32),
                 'origin_x': rng.randrange(-500, 500), 'origin_y': rng.randrange(-500, 500)}
            stubs = {0x4c7623: od.Stub(0x4c7623, args=3, this=True, cleanup=12, deref=(1, 16))}
            self.pair(12, 0x4cc79a, 225, areas, stubs, g, executed=executed, word_args={0x4c7623: {2}})
        self.finish(0x4cc79a, 225, executed)

    # ---- 0x4b8d5e ----
    def test_4b8d5e_expire_slots(self):
        """FL-18: differential test of m4b8d5e_expire_slots (original 0x4b8d5e)"""
        rng = random.Random(0x4b8d5e)
        executed = set()
        for n in range(SCENARIOS):
            now = rng.choice([5000, 123456, 0xfffff000, 10])
            data = bytearray(rng.randbytes(0x400))
            obj = bytearray(rng.randbytes(0x600))
            struct.pack_into('<h', obj, 0x173, rng.choice([-1, 0, 1, 3, 4]))
            struct.pack_into('<I', data, 8, od.region_va(1))
            for k in range(4):
                struct.pack_into('<I', data, k * 0x37 + 0x7d, rng.choice([1, 1, 1, 0, 2, 3]))
                struct.pack_into('<h', data, k * 0x37 + 0x7b, rng.choice([0, 1, 3, 20, -1, 100]))
                struct.pack_into('<I', data, k * 0x37 + 0x77, (now - rng.choice([0, 500, 1000, 3999, 4000, 5000, 20000, 200000])) & 0xffffffff)
            areas = [Area('self', od.region_va(0), data, image=False), Area('obj', od.region_va(1), obj, image=False)]
            stubs = {0x4fb2e3: od.Stub(0x4fb2e3, args=1, this=True, cleanup=4), 0x4b8a27: od.Stub(0x4b8a27, args=1, this=True, cleanup=4)}
            iat = {TICK_SLOT: od.Stub('tick', result=now, silent=True)}
            self.pair(14, 0x4b8d5e, 228, areas, stubs, {}, ecx=od.region_va(0), iat=iat, set_tick=now, executed=executed,
                      word_args={0x4fb2e3: {0}})
        self.finish(0x4b8d5e, 228, executed)

    # ---- 0x410f99 ----
    def test_410f99_init_entry(self):
        """FL-18: differential test of m410f99_init_entry (original 0x410f99)"""
        rng = random.Random(0x410f99)
        executed = set()
        for n in range(SCENARIOS):
            src = bytearray(rng.randbytes(0x80))
            length = rng.choice([0, 1, 5, 0x20, 0x22, 0x30, 0x3f])
            for i in range(length):
                src[i] = rng.randrange(1, 256)
            src[length] = 0
            areas = [Area('self', od.region_va(0), bytearray(rng.randbytes(0xc0)), image=False),
                     Area('src', od.region_va(1), src, image=False)]
            a = rng.choice([0, 1, -1, 0x1234, -32768])
            b = rng.randrange(256)
            stack = [od.region_va(0), od.region_va(1), (rng.randrange(0x10000) << 16) | (a & 0xffff), (rng.randrange(1 << 24) << 8) | b]
            self.pair(15, 0x410f99, 230, areas, {}, {}, stack=stack, native_args=(a, b), executed=executed, bytes_5495b0=bytes(src))
        self.finish(0x410f99, 230, executed)

    # ---- 0x44d624 and 0x4631d1 ----
    def rodata(self, va):
        return bytes(self.image_bytes(va, 9))

    def test_44d624_arm_timer(self):
        """FL-18: differential test of m44d624_arm_timer (original 0x44d624)"""
        rng = random.Random(0x44d624)
        executed = set()
        pattern = self.rodata(0x5495b0)
        for n in range(SCENARIOS):
            this = bytearray(rng.randbytes(0x100))
            struct.pack_into('<h', this, 0x1e, rng.choice([0, 1, 2]))
            for off in (0x25, 0x29):
                if rng.random() < 0.2:
                    struct.pack_into('<I', this, off, 0)
            if rng.random() < 0.3:
                this[0x49] = 0
            records, slack = self.records_area(rng, nrec=3, slack=0)
            for i in range(3):
                struct.pack_into('<I', records.data, i * 0x8d, od.region_va(1 + i % 2))
                struct.pack_into('<I', records.data, i * 0x8d + 0x4d, rng.choice([1, 1, 1, 2, 0]))
            objects = [Area('o1', od.region_va(1), bytearray(rng.randbytes(0x300)), image=False),
                       Area('o2', od.region_va(2), bytearray(rng.randbytes(0x300)), image=False)]
            for o in objects:
                if rng.random() < 0.7:
                    o.data[0x265:0x26e] = pattern
                    if rng.random() < 0.5:
                        o.data[0x265 + rng.choice([8, 8, rng.randrange(9)])] ^= 1 << rng.randrange(8)
            areas = [Area('self', od.region_va(0), this, image=False), records, *objects]
            now = rng.choice([100, 123456, 0xfffffff0])
            stubs = {0x4f6334: od.Stub(0x4f6334, args=1, this=True, cleanup=4, results=[rng.choice([0, 1])]),
                     0x4fb2e3: od.Stub(0x4fb2e3, args=1, this=True, cleanup=4)}
            iat = {TICK_SLOT: od.Stub('tick', result=now, silent=True)}
            self.pair(16, 0x44d624, 237, areas, stubs, {'value_5bb1ca': rng.choice([0, 1, 1])}, ecx=od.region_va(0), iat=iat,
                      set_tick=now, executed=executed, word_args={0x4fb2e3: {0}}, bytes_5495b0=pattern,
                      pointers={'records': ('records', 0)})
        self.finish(0x44d624, 237, executed)

    def test_4631d1_check_piece(self):
        """FL-18: differential test of m4631d1_check_piece (original 0x4631d1)"""
        rng = random.Random(0x4631d1)
        executed = set()
        pattern = self.rodata(0x54b158)
        for n in range(SCENARIOS):
            this = bytearray(rng.randbytes(0x100))
            struct.pack_into('<h', this, 0x1e, rng.choice([0, 1, 2]))
            for off in (0x3f, 0x47, 0x24):
                if rng.random() < 0.6:
                    struct.pack_into('<I', this, off, 0 if off != 0x3f else 3)
            struct.pack_into('<h', this, 0x57, rng.choice([0, 0, 1, -2]))
            records, slack = self.records_area(rng, nrec=3, slack=0)
            for i in range(3):
                struct.pack_into('<I', records.data, i * 0x8d, od.region_va(1 + i % 2))
                struct.pack_into('<I', records.data, i * 0x8d + 0x4d, rng.choice([1, 1, 1, 2, 0]))
            objects = [Area('o1', od.region_va(1), bytearray(rng.randbytes(0x300)), image=False),
                       Area('o2', od.region_va(2), bytearray(rng.randbytes(0x300)), image=False)]
            for o in objects:
                if rng.random() < 0.7:
                    o.data[0x24f:0x258] = pattern
                    if rng.random() < 0.5:
                        o.data[0x24f + rng.choice([8, 8, rng.randrange(9)])] ^= 1 << rng.randrange(8)
            areas = [Area('self', od.region_va(0), this, image=False), records, *objects]
            stubs = {0x4fb2e3: od.Stub(0x4fb2e3, args=1, this=True, cleanup=4)}
            g = {'value_5bb1ca': rng.choice([0, 1, 1]), 'value_5c39e5': rng.choice([0x277f, 0x277f, 0x1234])}
            self.pair(17, 0x4631d1, 238, areas, stubs, g, ecx=od.region_va(0), executed=executed, word_args={0x4fb2e3: {0}},
                      bytes_54b158=pattern, pointers={'records': ('records', 0)})
        self.finish(0x4631d1, 238, executed)

    # ---- 0x41632b ----
    def test_41632b_free_buffers(self):
        """FL-18: differential test of m41632b_free_buffers (original 0x41632b)"""
        rng = random.Random(0x41632b)
        executed = set()
        for n in range(SCENARIOS):
            arg = bytearray(rng.randbytes(0x200))
            for off in (0x17a, 0x17e):
                if rng.random() < 0.5:
                    struct.pack_into('<I', arg, off, 0)
            stubs = {0x51dc6c: od.Stub(0x51dc6c, args=1)}
            self.pair(18, 0x41632b, 137, [Area('self', od.region_va(0), arg, image=False)], stubs, {}, stack=[od.region_va(0)],
                      cleanup=4, executed=executed)
        self.finish(0x41632b, 137, executed)

    # ---- 0x4c08d3 ----
    def test_4c08d3_shift_rects(self):
        """FL-18: differential test of m4c08d3_shift_rects (original 0x4c08d3)"""
        rng = random.Random(0x4c08d3)
        executed = set()
        for n in range(SCENARIOS):
            this = bytearray(rng.randbytes(0x260))
            struct.pack_into('<I', this, 0x24a, od.region_va(1))
            areas = [Area('self', od.region_va(0), this, image=False),
                     Area('obj', od.region_va(1), bytearray(rng.randbytes(0x40)), image=False)]
            g = {'origin_x': rng.randrange(-1000, 1000), 'origin_y': rng.randrange(-1000, 1000)}
            self.pair(19, 0x4c08d3, 299, areas, {}, g, ecx=od.region_va(0), executed=executed)
        self.finish(0x4c08d3, 299, executed)

    # ---- 0x4c0774 ----
    def test_4c0774_open_piece(self):
        """FL-18: differential test of m4c0774_open_piece (original 0x4c0774)"""
        rng = random.Random(0x4c0774)
        executed = set()
        for n in range(SCENARIOS):
            this = bytearray(rng.randbytes(0x260))
            struct.pack_into('<I', this, 0x22a, od.region_va(1))
            struct.pack_into('<h', this, 0x1d4, rng.choice([0, 0, 3]))
            obj = bytearray(rng.randbytes(0x60))
            struct.pack_into('<h', obj, 0x21, rng.choice([0, 0, 1, -1]))
            struct.pack_into('<h', obj, 0x37, rng.choice([-1, -1, 0, 3, 7, -2]))
            struct.pack_into('<h', obj, 0x25, rng.choice([5, 5, 4, 0]))
            struct.pack_into('<h', obj, 0x23, rng.choice([1, 1, 0, 2]))
            flags = Area('flags', 0x585801 - 32, bytearray(rng.randbytes(32 + 64)))
            areas = [Area('self', od.region_va(0), this, image=False), Area('obj', od.region_va(1), obj, image=False), flags]
            g = {name: rng.randrange(1 << 32) for name in ('value_5d19fb', 'value_5839a9', 'value_5c39f9', 'value_5bb57b', 'value_5bb59b',
                                                           'value_5bb59f', 'value_5bb5a3', 'value_583999', 'value_5bb1ca')}
            g.update({name: rng.randrange(1 << 16) for name in ('word_5bb599', 'word_5bb595', 'word_5c39ff')})
            stubs = {0x4d36ed: od.Stub(0x4d36ed), 0x4bf773: od.Stub(0x4bf773, this=True), 0x42ba3a: od.Stub(0x42ba3a, args=1)}
            a = rng.choice([0, 1, -1, 0x1234, -32768])
            self.pair(20, 0x4c0774, 351, areas, stubs, g, ecx=od.region_va(0),
                      stack=[(rng.randrange(0x10000) << 16) | (a & 0xffff)], cleanup=4, native_args=(a, 0), executed=executed,
                      word_args={0x42ba3a: {0}}, pointers={'flags_585801': ('flags', 32)})
        self.finish(0x4c0774, 351, executed)

    # ---- 0x4d07e7 ----
    def test_4d07e7_draw_texts(self):
        """FL-18: differential test of m4d07e7_draw_texts (original 0x4d07e7)"""
        rng = random.Random(0x4d07e7)
        executed = set()
        for n in range(SCENARIOS):
            records, slack = self.records_area(rng, nrec=4, slack=0)
            for i in range(4):
                struct.pack_into('<I', records.data, i * 0x8d, od.region_va(1 + i % 2))
            objects = [Area('o1', od.region_va(1), bytearray(rng.randbytes(0x40)), image=False),
                       Area('o2', od.region_va(2), bytearray(rng.randbytes(0x40)), image=False)]
            for o in objects:
                struct.pack_into('<h', o.data, 0, rng.choice([0, 1, 2, 5, -1, -3]))
            dwords_a = Area('dwords', 0x5d032f - 32, bytearray(rng.randbytes(32 + 48)))
            text = Area('text', 0x5b618e, bytearray(rng.randbytes(8)))
            if rng.random() < 0.4:
                text.data[0] = 0
            g = {'word_5b61b0': rng.randrange(0, 4), 'value_5d15e3': rng.randrange(1 << 32), 'value_5cf665': rng.randrange(1 << 32)}
            g.update({name: rng.randrange(1 << 16) for name in ('word_5b61dd', 'word_5b61d1', 'word_5b61e1', 'word_5b61ed')})
            stubs = {0x4c5377: od.Stub(0x4c5377, args=5, this=True, cleanup=20), 0x4d2c20: od.Stub(0x4d2c20, args=8)}
            self.pair(21, 0x4d07e7, 363, [*objects, records, dwords_a, text], stubs, g, executed=executed,
                      word_args={0x4d2c20: {3, 4}}, pointers={'records': ('records', 0), 'dwords_5d032f': ('dwords', 32),
                                                             'string_5b618e': ('text', 0)})
        self.finish(0x4d07e7, 363, executed)


if __name__ == '__main__':
    unittest.main()
