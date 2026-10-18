"""Differential tests: the original GAME.EXE bytes (Unicorn) against the native ports, on the same random fixtures.

Each case builds a fixture (object regions at fake addresses plus patches to the globals in the image), runs the original
function on it under tests/original_differential.py and the native port through tests/fl_differential_shim.c, and compares
every byte of memory the function can touch, the return value and the ordered calls out. A case also asserts that its
scenarios reached every instruction of the original, so the comparison is not blind to a branch. Skipped when Unicorn or the
pinned private GAME.EXE is missing.
"""
import ctypes
import os
from pathlib import Path
import random
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
SHIM = PROJECT / 'tests/fl_differential_shim.c'
KERNELS = ['original_methods_fl18.c', 'original_methods_fl17.c', 'original_methods_fl16.c']
SCENARIOS = 400


def compiler():
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


class Native(ctypes.CDLL):
    pass


def buf(data):
    return (ctypes.c_ubyte * len(data)).from_buffer_copy(bytes(data))


def ptr(array):
    return ctypes.cast(array, ctypes.POINTER(ctypes.c_ubyte))


class ShimCall(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64),
                ('arg', ctypes.c_uint64 * 8), ('data', (ctypes.c_uint8 * 32) * 2)]


CALL_NAMES = {1: 'free', 2: 'unmap', 3: 'close', 4: '4ea06c'}


class DiffBase(unittest.TestCase):
    SHIM = SHIM          # a later batch (FL-19) points these at its own shim and kernels
    KERNELS = KERNELS

    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        lib = Path(cls.directory.name) / 'fl_differential.so'
        cmd = [*compiler(), '-std=c11', '-O1', '-g', '-shared', '-fPIC', f'-I{SRC}', str(cls.SHIM),
               *[str(SRC / name) for name in cls.KERNELS], '-o', str(lib)]
        built = subprocess.run(cmd, capture_output=True, text=True)
        if built.returncode != 0:
            raise AssertionError(built.stderr)
        cls.lib = ctypes.CDLL(str(lib))
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall)

    # ---- helpers ----
    def native_calls(self):
        calls = self.lib.shim_calls()
        out = []
        for i in range(self.lib.shim_call_count()):
            c = calls[i]
            out.append((CALL_NAMES[c.id], *c.arg[:2]))
        return out

    def native_session(self, regions):
        """Copy the regions into ctypes arrays and register them with the shim. Returns {name: array}."""
        self.lib.shim_reset()
        arrays = {}
        for name, (va, data) in regions.items():
            arrays[name] = buf(data)
            self.lib.shim_add_region(va, ptr(arrays[name]), len(data))
        return arrays

    def image_bytes(self, va, length):
        pe = od.load_image()
        off = va - pe.image_base
        return bytearray(pe.image[off:off + length])

    def check_coverage(self, va, size, executed):
        missing = sorted(od.instruction_addresses(va, size) - executed)
        self.assertEqual(missing, [], 'scenarios never reached original instructions %s' % [hex(a) for a in missing])


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Differential(DiffBase):
    # ---- 0x42ca22 ----
    def test_42ca22_apply_event_flags(self):
        """FL-17: differential test of m42ca22_apply_event_flags (original 0x42ca22)"""
        rng = random.Random(0x42ca22)
        executed = set()
        slack, area = 32, 160
        for n in range(SCENARIOS):
            records = rng.randrange(0, 13)
            table = bytearray()
            for _ in range(12):
                table += struct.pack('<hhh', rng.choice([0, 1, 2, 3, -1]), rng.choice([-1, -2, 0, 1, 5, 7, 20, 20, 3]),
                                     rng.choice([0, 1, -1, 123, -32768, 32767, -5]))
            owner = bytearray(rng.randbytes(0x80))
            count = rng.choice([0, 1, 2, 5, 12, -1, -5, records])
            struct.pack_into('<h', owner, 0x6d, count)
            key = rng.choice([0, 1, 2, 3, -1])
            table_ptr = rng.choice([0, od.region_va(0), od.region_va(0)])
            flags = bytearray(rng.randbytes(slack + area))
            fva = 0x585801 - slack
            regions = {'table': (od.region_va(0), table), 'owner': (od.region_va(1), owner)}
            patches = [(0x5b4ea5, struct.pack('<I', table_ptr)), (0x5b4ead, struct.pack('<I', od.region_va(1))),
                       (0x5b4e00, struct.pack('<h', key)), (fva, flags)]
            orig = od.Original(patches, regions).run(0x42ca22, 134, read={'flags': (fva, slack + area)})
            self.assertEqual(orig.calls, [])
            self.assertEqual(orig.cleanup, 0)
            executed |= orig.executed
            arrays = self.native_session(regions)
            nflags = buf(flags)
            self.lib.shim_m42ca22(key, ptr(arrays['table']) if table_ptr else None, ptr(arrays['owner']),
                                  ctypes.cast(ctypes.byref(nflags, slack), ctypes.POINTER(ctypes.c_ubyte)))
            self.assertEqual(bytes(nflags), orig.memory['flags'], 'scenario %d' % n)
        self.check_coverage(0x42ca22, 134, executed)

    # ---- 0x48c0ac ----
    def test_48c0ac_accept_piece(self):
        """FL-17: differential test of m48c0ac_accept_piece (original 0x48c0ac)"""
        rng = random.Random(0x48c0ac)
        executed = set()
        slack, nrec = 0x8d, 6
        for n in range(SCENARIOS):
            this = bytearray(rng.randbytes(0x80))
            struct.pack_into('<hh', this, 0x26, rng.choice([-1, 0, 1, 2, 3, 4]), rng.choice([-2, -1, 0, 1, 2, 5]))
            obj = bytearray(rng.randbytes(0x240))
            records = bytearray(rng.randbytes(slack + nrec * 0x8d))
            for i in range(-1, nrec - 1):
                struct.pack_into('<I', records, slack + i * 0x8d, od.region_va(1) if rng.random() < 0.9 else 0xdead0000)
            selector = rng.choice([0x27a9, 0x27a8, 0x27a8, 0x27a9, 0, 0x27a7])
            rva = 0x5bb5e5 - slack
            # a record whose object address is garbage is only reached when the selector is not 0x27a8 (it is not read then)
            index = struct.unpack_from('<h', this, 0x26)[0]
            if selector == 0x27a8:
                struct.pack_into('<I', records, slack + index * 0x8d, od.region_va(1))
            regions = {'this': (od.region_va(0), this), 'obj': (od.region_va(1), obj)}
            patches = [(0x5c39e5, struct.pack('<I', selector)), (rva, records)]
            orig = od.Original(patches, regions).run(0x48c0ac, 120, ecx=od.region_va(0),
                                                     read={'this': (od.region_va(0), 0x80), 'records': (rva, len(records))})
            self.assertEqual(orig.calls, [])
            executed |= orig.executed
            arrays = self.native_session(regions)
            nrecords = buf(records)
            self.lib.shim_m48c0ac(ptr(arrays['this']), selector,
                                  ctypes.cast(ctypes.byref(nrecords, slack), ctypes.POINTER(ctypes.c_ubyte)))
            self.assertEqual(bytes(arrays['this']), orig.memory['this'], 'this, scenario %d' % n)
            self.assertEqual(bytes(nrecords), orig.memory['records'], 'records, scenario %d' % n)
        self.check_coverage(0x48c0ac, 120, executed)

    # ---- 0x415011 ----
    def test_415011_close_handles(self):
        """FL-17: differential test of m415011_close_handles (original 0x415011)"""
        rng = random.Random(0x415011)
        executed = set()
        for n in range(SCENARIOS):
            arg = bytearray(rng.randbytes(0x60))
            for off in (0x21, 0x25, 0x29, 0x2d):
                if rng.random() < 0.5:
                    struct.pack_into('<I', arg, off, 0)
            regions = {'arg': (od.region_va(0), arg)}
            stubs = {0x51dc6c: od.Stub('free', args=1)}
            iat = {0x52a2b4: od.Stub('unmap', args=1, cleanup=4), 0x52a2b8: od.Stub('close', args=1, cleanup=4)}
            orig = od.Original((), regions, stubs, iat).run(0x415011, 150, ecx=0x1234, stack_args=[od.region_va(0)],
                                                            read={'arg': (od.region_va(0), 0x60)})
            executed |= orig.executed
            self.assertEqual(orig.cleanup, 4)
            arrays = self.native_session(regions)
            self.lib.shim_m415011(ptr(arrays['arg']))
            self.assertEqual(bytes(arrays['arg']), orig.memory['arg'], 'scenario %d' % n)
            self.assertEqual(self.native_calls(), [(c[0], c[1], 0) for c in orig.calls], 'scenario %d' % n)
        self.check_coverage(0x415011, 150, executed)

    # ---- 0x4eac4c ----
    def test_4eac4c_use_item(self):
        """FL-17: differential test of m4eac4c_use_item (original 0x4eac4c)"""
        rng = random.Random(0x4eac4c)
        executed = set()
        slack, nrec = 0x8d, 6
        for n in range(SCENARIOS):
            this = bytearray(rng.randbytes(0x40))
            obj = bytearray(rng.randbytes(0x20))
            w = rng.choice([0, 1, 0x7fff, 0x8000, 0xffff, 0x1234, rng.randrange(0x10000)])
            struct.pack_into('<H', obj, 0, w)
            records = bytearray(rng.randbytes(slack + nrec * 0x8d))
            index = rng.choice([-1, 0, 1, 2, 3, 4])
            struct.pack_into('<I', records, slack + index * 0x8d, od.region_va(1))
            signed = struct.unpack('<h', struct.pack('<H', w))[0]
            word = rng.choice([signed, signed, -1, 0, rng.randrange(-32768, 32768)])
            rva = 0x5bb5e5 - slack
            regions = {'this': (od.region_va(0), this), 'obj': (od.region_va(1), obj)}
            patches = [(0x583a29, struct.pack('<h', word)), (rva, records)]
            stubs = {0x4ea06c: od.Stub('4ea06c', args=1, this=True, cleanup=4)}
            high = rng.randrange(0x10000) << 16
            orig = od.Original(patches, regions, stubs).run(
                0x4eac4c, 92, ecx=od.region_va(0), stack_args=[high | (index & 0xffff)],
                read={'word': (0x583a29, 2), 'records': (rva, len(records)), 'this': (od.region_va(0), 0x40)})
            self.assertEqual(orig.cleanup, 4)
            executed |= orig.executed
            arrays = self.native_session(regions)
            nrecords = buf(records)
            nword = ctypes.c_int16(word)
            self.lib.shim_m4eac4c(ptr(arrays['this']), index, ctypes.byref(nword),
                                  ctypes.cast(ctypes.byref(nrecords, slack), ctypes.POINTER(ctypes.c_ubyte)))
            self.assertEqual(bytes(nrecords), orig.memory['records'], 'records, scenario %d' % n)
            self.assertEqual(struct.pack('<h', nword.value), orig.memory['word'], 'word, scenario %d' % n)
            self.assertEqual(bytes(arrays['this']), orig.memory['this'])
            # the original pushes a dword whose low word is the argument of 0x4ea06c
            expect = [(c[0], c[1], c[2] & 0xffff) for c in orig.calls]
            self.assertEqual(self.native_calls(), expect, 'calls, scenario %d' % n)
        self.check_coverage(0x4eac4c, 92, executed)


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl16Differential(DiffBase):
    """A sample of the FL-16 ports: the pure functions and the loop / tick ones, original bytes against the native code."""

    def native_call(self, name, *args, restype=None):
        fn = getattr(self.lib, name)
        fn.restype = restype
        return fn(*args)

    def test_434773_is_data_tag(self):
        """FL-16: differential test of m434773_is_data_tag (original 0x434773)"""
        rng = random.Random(0x434773)
        executed = set()
        for n in range(SCENARIOS):
            text = bytearray(rng.randbytes(8))
            if rng.random() < 0.7:
                text[0:4] = b'DATA'
                if rng.random() < 0.6:
                    text[rng.randrange(4)] = rng.choice([0x44, 0x41, 0x54, 0xc4, 0x00, 0xff, rng.randrange(256)])
            regions = {'text': (od.region_va(0), text)}
            orig = od.Original((), regions).run(0x434773, 69, stack_args=[od.region_va(0)], read={'text': (od.region_va(0), 8)})
            executed |= orig.executed
            self.assertEqual(orig.cleanup, 4)
            arrays = self.native_session(regions)
            self.assertEqual(self.native_call('shim16_434773', ptr(arrays['text']), restype=ctypes.c_uint32), orig.eax)
        self.check_coverage(0x434773, 69, executed)

    def test_4347b8_read_be32(self):
        """FL-16: differential test of m4347b8_read_be32 (original 0x4347b8)"""
        rng = random.Random(0x4347b8)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(8))
            regions = {'bytes': (od.region_va(0), data)}
            orig = od.Original((), regions).run(0x4347b8, 92, stack_args=[od.region_va(0)])
            executed |= orig.executed
            arrays = self.native_session(regions)
            self.assertEqual(self.native_call('shim16_4347b8', ptr(arrays['bytes']), restype=ctypes.c_uint32), orig.eax)
        self.check_coverage(0x4347b8, 92, executed)

    def test_43f04b_copy_rows(self):
        """FL-16: differential test of m43f04b_copy_rows (original 0x43f04b)"""
        rng = random.Random(0x43f04b)
        executed = set()
        for n in range(SCENARIOS):
            rows = rng.choice([-2, 0, 1, 2, 5])
            row_bytes = rng.choice([0, 1, 2, 3, 4, 5, 7, 8, 13])
            stride = rng.choice([row_bytes, row_bytes + 3, 16, 0])
            src = bytearray(rng.randbytes(0x100))
            dst = bytearray(rng.randbytes(0x100))
            regions = {'dst': (od.region_va(0), dst), 'src': (od.region_va(1), src)}
            orig = od.Original((), regions).run(0x43f04b, 88, stack_args=[od.region_va(0), od.region_va(1), rows & 0xffffffff, row_bytes,
                                                                          stride & 0xffffffff],
                                                read={'dst': (od.region_va(0), 0x100)})
            executed |= orig.executed
            self.assertEqual(orig.cleanup, 0x14)
            arrays = self.native_session(regions)
            self.native_call('shim16_43f04b', ptr(arrays['dst']), ptr(arrays['src']), rows, row_bytes, stride)
            self.assertEqual(bytes(arrays['dst']), orig.memory['dst'], 'scenario %d' % n)
        self.check_coverage(0x43f04b, 88, executed)

    def rect_case(self, which, size, seed):
        rng = random.Random(seed)
        executed = set()
        for n in range(SCENARIOS):
            src = bytearray(rng.randbytes(16))
            dst = bytearray(rng.randbytes(16))
            ox, oy = rng.randrange(-1000, 1000), rng.randrange(-1000, 1000)
            regions = {'src': (od.region_va(0), src), 'dst': (od.region_va(1), dst)}
            patches = [(0x583186, struct.pack('<i', ox)), (0x58318a, struct.pack('<i', oy))]
            orig = od.Original(patches, regions).run(which, size, stack_args=[od.region_va(0), od.region_va(1)],
                                                     read={'dst': (od.region_va(1), 16), 'src': (od.region_va(0), 16)})
            executed |= orig.executed
            self.assertEqual(orig.cleanup, 8)
            arrays = self.native_session(regions)
            self.native_call('shim16_rect', which, ptr(arrays['src']), ptr(arrays['dst']), ox, oy)
            self.assertEqual(bytes(arrays['dst']), orig.memory['dst'])
            self.assertEqual(bytes(arrays['src']), orig.memory['src'])
        self.check_coverage(which, size, executed)

    def test_44d9b5_shift_rect(self):
        """FL-16: differential test of m44d9b5_shift_rect (original 0x44d9b5)"""
        self.rect_case(0x44d9b5, 83, 0x44d9b5)

    def test_45b568_shift_rect(self):
        """FL-16: differential test of m45b568_shift_rect (original 0x45b568)"""
        self.rect_case(0x45b568, 83, 0x45b568)

    def test_4b8e42_expire_slot(self):
        """FL-16: differential test of m4b8e42_expire_slot (original 0x4b8e42)"""
        rng = random.Random(0x4b8e42)
        executed = set()
        for n in range(SCENARIOS):
            slot = rng.choice([0, 1, 3, 4])
            this = bytearray(rng.randbytes(0x400))
            deadlines = bytearray(rng.randbytes(0x37 * 5 + 4))
            now = rng.choice([1000, 0x7fffffff, 0x80000000, 0xfffffff0])
            dl = rng.choice([now - 1, now, now + 1, 0, 0xffffffff]) & 0xffffffff
            struct.pack_into('<I', deadlines, slot * 0x37, dl)
            regions = {'self': (od.region_va(0), this)}
            patches = [(0x61eee1, deadlines)]
            iat = {0x52a23c: od.Stub('tick', result=now, silent=True)}
            stubs = {0x4b8a27: od.Stub(0x4b8a27, args=1, this=True, cleanup=4)}
            orig = od.Original(patches, regions, stubs, iat).run(0x4b8e42, 80, ecx=od.region_va(0),
                                                                 stack_args=[(rng.randrange(0x10000) << 16) | slot],
                                                                 read={'self': (od.region_va(0), 0x400)})
            executed |= orig.executed
            self.assertEqual(orig.cleanup, 4)
            arrays = self.native_session(regions)
            nd = buf(deadlines)
            self.lib.shim_reset()
            self.lib.shim_add_region(od.region_va(0), ptr(arrays['self']), 0x400)
            self.native_call('shim16_4b8e42', ptr(arrays['self']), slot, ptr(nd), now)
            self.assertEqual(bytes(arrays['self']), orig.memory['self'], 'scenario %d' % n)
            native_calls = [(c[0], c[1], c[2]) for c in [(self.lib.shim_calls()[i].id, self.lib.shim_calls()[i].this_ptr,
                                                         self.lib.shim_calls()[i].arg[0]) for i in range(self.lib.shim_call_count())]]
            ptr_self = ctypes.addressof(arrays['self'])
            native_calls = [(0x4b8a27, od.region_va(0) + (c[1] - ptr_self), c[2]) for c in native_calls]
            self.assertEqual(native_calls, [(c[0], c[1], c[2]) for c in orig.calls], 'calls, scenario %d' % n)
        self.check_coverage(0x4b8e42, 80, executed)


if __name__ == '__main__':
    unittest.main()
