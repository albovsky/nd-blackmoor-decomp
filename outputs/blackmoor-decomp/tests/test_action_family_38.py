"""Synthetic fixtures for A-38.1; no original resource bytes are embedded."""
import ctypes as C
import os
from pathlib import Path
import struct
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / 'outputs/blackmoor-decomp'
OBJECT_BYTES = 0xABA
PREFIX_BYTES = 71
MAX_FRAMES = 100


class Decoded(C.Structure):
    _fields_ = [('name', C.c_uint8 * 33)] + [
        (f'option_{offset:02x}', C.c_uint16) for offset in range(0x21, 0x33, 2)
    ] + [('frame_start', C.c_int16), ('frame_end', C.c_int16),
         ('fixed_rect', C.c_int32 * 4), ('frame_records', C.POINTER(C.c_uint8)),
         ('frame_count', C.c_size_t), ('dependency_records', C.POINTER(C.c_uint8)),
         ('dependency_count', C.c_size_t), ('available_body_bytes', C.c_size_t),
         ('body_bytes', C.c_size_t), ('dependency_bytes', C.c_size_t)]


class OwnerLinks(C.Structure):
    _fields_ = [(name, C.c_uint32) for name in ('output_handle', 'result_slot_handle',
        'owner_slot_1c_handle', 'owner_slot_20_handle', 'output_allocation_bytes')]


class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.c_uint8 * OBJECT_BYTES),
        ('dependency_records', C.POINTER(C.c_uint8)), ('dependency_count', C.c_size_t),
        ('dependency_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t),
        ('body_bytes_consumed', C.c_size_t), ('payload_offset_before', C.c_uint32),
        ('payload_offset_after', C.c_uint32), ('owner_links', OwnerLinks)]


def storage(data):
    return (C.c_uint8 * len(data)).from_buffer_copy(data)


def pointer(p):
    return C.cast(p, C.c_void_p).value


def body_fixture(start=0, count=4, tail=1, name=b'fixture', rect=None):
    if rect is None:
        rect = (-0x80000000, 0x7fffffff, 0x7fffffff, -0x80000000)
    data = bytearray(PREFIX_BYTES + max(0, count) * 16 + tail * 16)
    data[:len(name)] = name
    data[len(name)] = 0
    for i, offset in enumerate(range(0x21, 0x33, 2)):
        struct.pack_into('<H', data, offset, 0x8123 + i * 0x101)
    struct.pack_into('<hh4i', data, 0x33, start, start + count - 1, *rect)
    for i in range(PREFIX_BYTES, len(data)):
        data[i] = (i * 37 + 11) & 255
    return bytes(data)


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_38_decode.argtypes = [C.c_void_p, C.c_size_t, C.c_void_p]
    lib.action_family_38_decode.restype = C.c_int
    lib.action_family_38_construct.argtypes = [C.c_void_p, C.c_size_t, C.c_void_p,
        C.c_size_t, C.c_uint32, C.c_uint32, C.c_void_p]
    lib.action_family_38_construct.restype = C.c_int
    return lib


class ActionFamily38Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT/'scripts/build_action_family_38.sh')], check=True,
                       capture_output=True)
        cls.lib = load_native(Path(os.environ.get('BUILD_DIR', PROJECT/'build')) /
                              'libactionfamily38.dylib')

    def reject(self, data, expected=None):
        raw = storage(data)
        seed = storage(bytes([0xCD]) * OBJECT_BYTES)
        for kind in (Decoded, Constructed):
            out = kind()
            C.memset(C.byref(out), 0xA6, C.sizeof(out))
            before = bytes(out)
            status = (self.lib.action_family_38_decode(raw, len(data), C.byref(out))
                      if kind is Decoded else self.lib.action_family_38_construct(
                          raw, len(data), seed, len(seed), 50, 1, C.byref(out)))
            self.assertNotEqual(status, 0)
            if expected is not None:
                self.assertEqual(status, expected)
            self.assertEqual(bytes(out), before)

    def test_decode_fields_and_borrowed_views(self):
        data = body_fixture(start=-15, count=16, tail=8)
        raw = storage(data); out = Decoded()
        self.assertEqual(self.lib.action_family_38_decode(raw, len(data), C.byref(out)), 0)
        self.assertEqual(bytes(out.name), b'fixture' + bytes(26))
        for offset in range(0x21, 0x33, 2):
            self.assertEqual(getattr(out, f'option_{offset:02x}'),
                             struct.unpack_from('<H', data, offset)[0])
        self.assertEqual((out.frame_start, out.frame_end, out.frame_count), (-15, 0, 16))
        self.assertEqual(tuple(out.fixed_rect), struct.unpack_from('<4i', data, 0x37))
        self.assertEqual(pointer(out.frame_records), C.addressof(raw) + 71)
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 327)
        self.assertEqual((out.body_bytes, out.dependency_count, out.dependency_bytes,
                          out.available_body_bytes), (327, 8, 128, len(data)))
        raw[327] ^= 1
        self.assertEqual(out.dependency_records[0], raw[327])

    def test_all_bounded_counts_and_signed_endpoints(self):
        for count in range(101):
            for start in (-32768, -count, 1, 32768 - max(1, count)):
                if not -32768 <= start + count - 1 <= 32767:
                    continue
                data = body_fixture(start=start, count=count, tail=count % 3)
                raw = storage(data); out = Decoded()
                self.assertEqual(self.lib.action_family_38_decode(raw, len(data), C.byref(out)), 0)
                self.assertEqual(out.frame_count, count)
                self.assertEqual(out.body_bytes, 71 + count * 16)

    def test_minimum_and_maximum_names(self):
        for name in (b'', bytes(range(1, 33))):
            data = body_fixture(name=name, count=0, start=1, tail=0)
            raw=storage(data); out=Decoded()
            self.assertEqual(self.lib.action_family_38_decode(raw, len(data), C.byref(out)), 0)
            self.assertEqual(bytes(out.name), name + bytes(33-len(name)))

    def test_constructor_image_and_untouched_allocation(self):
        data=body_fixture(start=-50,count=100,tail=2)
        raw=storage(data)
        seed_bytes=bytes((i*19+7)&255 for i in range(OBJECT_BYTES))
        seed=storage(seed_bytes); out=Constructed()
        self.assertEqual(self.lib.action_family_38_construct(raw,len(raw),seed,len(seed),
                         0xFFFFFFFB,0x12345678,C.byref(out)),0)
        expected=bytearray(seed_bytes); expected[:0xAC]=bytes(0xAC)
        expected[:8]=b'fixture\0'
        for src,dst in [(0x21,0x21),(0x23,0x23),(0x25,0x25),(0x27,0x27),
                        (0x29,0x2d),(0x2b,0x2f),(0x2d,0x3d),(0x2f,0x51),
                        (0x31,0x53),(0x33,0x33),(0x35,0x35)]:
            expected[dst:dst+2]=data[src:src+2]
        for off,value in [(0x29,2),(0x37,15),(0x39,65535),(0x43,1),(0xaa,1),
                          (0x6ec,0),(0x6ee,0),(0x6f0,2)]:
            struct.pack_into('<H',expected,off,value)
        struct.pack_into('<I',expected,0x4d,1)
        for i in range(1,10):struct.pack_into('<H',expected,0x51+i*4,65535)
        expected[0x79:0x82]=b'NO SOUND\0'
        expected[0xac:0x6ec]=data[71:1671]
        expected[0x6f2:0x6fa]=bytes(8)
        left,top,right,bottom=struct.unpack_from('<4I',data,0x37)
        struct.pack_into('<II',expected,0x6fa,(right-left)&0xffffffff,(bottom-top)&0xffffffff)
        expected[0x702:0x712]=data[0x37:0x47]
        self.assertEqual(bytes(out.object_bytes),bytes(expected))
        self.assertEqual(bytes(seed),seed_bytes)
        self.assertEqual(out.payload_offset_after,(0xFFFFFFFB+1671)&0xffffffff)
        self.assertEqual(out.body_bytes_consumed,1671)
        self.assertEqual(pointer(out.dependency_records),C.addressof(raw)+1671)
        self.assertEqual(out.dependency_count,2)
        self.assertEqual(list(bytes(out.owner_links)),list(struct.pack('<5I',*[0x12345678]*4,OBJECT_BYTES)))

    def test_short_prefixes(self):
        data=body_fixture()
        for length in range(71):self.reject(data[:length],2)

    def test_short_frame_tables(self):
        data=body_fixture(count=100,tail=0)
        for length in (71,72,1669,1670):self.reject(data[:length],2)

    def test_non_record_dependency_tails(self):
        data=body_fixture(tail=0)
        for residue in range(1,16):self.reject(data+bytes(residue),4)

    def test_negative_and_overflow_counts(self):
        for start,end in [(2,0),(32767,-32768),(-32768,32767),(0,100),(-100,0)]:
            data=bytearray(body_fixture(count=100,tail=0))
            struct.pack_into('<hh',data,0x33,start,end)
            self.reject(data,7)

    def test_unterminated_name(self):
        data=bytearray(body_fixture());data[:33]=b'X'*33
        self.reject(data,3)

    def test_null_arguments_and_zero_handle(self):
        raw=storage(body_fixture());seed=storage(bytes(OBJECT_BYTES));out=Constructed()
        C.memset(C.byref(out),0xA6,C.sizeof(out));before=bytes(out)
        self.assertEqual(self.lib.action_family_38_decode(None,len(raw),C.byref(out)),1)
        self.assertEqual(self.lib.action_family_38_decode(raw,len(raw),None),1)
        for r,s,handle,o in [(None,seed,1,C.byref(out)),(raw,None,1,C.byref(out)),
                             (raw,seed,0,C.byref(out)),(raw,seed,1,None)]:
            self.assertEqual(self.lib.action_family_38_construct(r,len(raw),s,OBJECT_BYTES,50,handle,o),1)
        self.assertEqual(bytes(out),before)

    def test_seed_length(self):
        raw=storage(body_fixture());seed=storage(bytes(OBJECT_BYTES+1));out=Constructed()
        for length in (0,OBJECT_BYTES-1,OBJECT_BYTES+1):
            C.memset(C.byref(out),0xA6,C.sizeof(out));before=bytes(out)
            self.assertEqual(self.lib.action_family_38_construct(raw,len(raw),seed,length,50,1,C.byref(out)),8)
            self.assertEqual(bytes(out),before)

    def test_span_wrap(self):
        raw=storage(body_fixture());seed=storage(bytes(OBJECT_BYTES));out=Constructed()
        bad=C.c_void_p(C.c_size_t(-1).value-32)
        C.memset(C.byref(out),0xA6,C.sizeof(out));before=bytes(out)
        self.assertEqual(self.lib.action_family_38_decode(bad,len(raw),C.byref(out)),5)
        self.assertEqual(self.lib.action_family_38_decode(raw,len(raw),bad),5)
        self.assertEqual(self.lib.action_family_38_construct(raw,len(raw),bad,OBJECT_BYTES,50,1,C.byref(out)),5)
        self.assertEqual(bytes(out),before)

    def test_input_output_overlap_both_directions(self):
        data=body_fixture()
        for kind in (Decoded,Constructed):
            for raw_offset,out_offset in [(64,64),(64,65),(65,64),(64,64+len(data)-1)]:
                area=storage(bytes(4096));C.memmove(C.addressof(area)+raw_offset,data,len(data))
                before=bytes(area);out=C.c_void_p(C.addressof(area)+out_offset)
                raw=C.c_void_p(C.addressof(area)+raw_offset);seed=storage(bytes(OBJECT_BYTES))
                status=(self.lib.action_family_38_decode(raw,len(data),out) if kind is Decoded
                        else self.lib.action_family_38_construct(raw,len(data),seed,len(seed),50,1,out))
                self.assertEqual(status,6);self.assertEqual(bytes(area),before)

    def test_seed_output_overlap(self):
        raw=storage(body_fixture());area=storage(bytes(8192));before=bytes(area)
        for seed_off,out_off in [(64,64),(64,65),(65,64),(64,64+OBJECT_BYTES-1)]:
            self.assertEqual(self.lib.action_family_38_construct(raw,len(raw),
                C.c_void_p(C.addressof(area)+seed_off),OBJECT_BYTES,50,1,
                C.c_void_p(C.addressof(area)+out_off)),6)
            self.assertEqual(bytes(area),before)


if __name__=='__main__':
    unittest.main()
