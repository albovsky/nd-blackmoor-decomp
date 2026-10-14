"""Fixtures for A-3F.1. All byte fixtures are synthetic, never corpus dumps."""
import ctypes as C
from pathlib import Path
import struct
import subprocess
import unittest

PROJECT = Path(__file__).resolve().parents[1]

class Decoded(C.Structure):
    _fields_ = [('raw_type',C.c_uint8),('runtime_type',C.c_uint8),('name',C.c_uint8*33),
        ('option_21',C.c_uint16),('text_key',C.c_uint8*33),('option_44',C.c_uint8),
        ('option_45',C.c_uint8),('option_46',C.c_uint8),('word_47',C.c_uint16),
        ('word_49',C.c_uint16),('primary_count',C.c_int16),('secondary_count',C.c_int16),
        ('primary_records',C.c_void_p),('primary_bytes',C.c_size_t),
        ('secondary_records',C.c_void_p),('secondary_bytes',C.c_size_t),
        ('dependency_records',C.c_void_p),('dependency_count',C.c_size_t),
        ('body_bytes',C.c_size_t),('dependency_bytes',C.c_size_t),('available_body_bytes',C.c_size_t)]

class Text(C.Structure):
    _fields_ = [('bytes',C.c_void_p),('length',C.c_size_t)]

class Constructed(C.Structure):
    _fields_ = [('arena_bytes',C.c_size_t),('allocation_count',C.c_size_t),
        ('primary_offset',C.c_size_t),('secondary_offset',C.c_size_t),
        ('dependency_records',C.c_void_p),('dependency_count',C.c_size_t),
        ('body_bytes_consumed',C.c_size_t),('payload_offset_before',C.c_uint32),
        ('payload_offset_after',C.c_uint32),('result_slot_handle',C.c_uint32)]

def storage(data):
    return (C.c_uint8*len(data)).from_buffer_copy(data)

def fixture(primary=(),secondary=(),tails=0):
    b=bytearray(77)
    b[:4]=b'NAME'; b[35:38]=b'KEY'
    struct.pack_into('<H',b,33,0x8123)
    struct.pack_into('<BBBHHh',b,68,0x91,0x82,0x73,0xa456,0xb789,len(primary))
    for count in primary:
        b+=bytes((count & 255,0xa7))
        b+=bytes((i*19+7)&255 for i in range(max(0,count)*5))
        b+=b'KEY'+bytes(30)+b'CHOICE'+bytes(27)+struct.pack('<H',0xf123)
    b+=bytes((len(secondary)&255,0xb8))
    for count in secondary:
        b+=bytes((count&255,0xc9))
        b+=bytes((i*37+3)&255 for i in range(max(0,count)*5))
        b+=struct.pack('<I',0xfedcba98)
    b+=bytes((i*29+13)&255 for i in range(tails*16))
    return bytes(b)

def texts(values):
    keep=[storage(x) for x in values]
    rows=(Text*len(keep))(*(Text(C.addressof(x),len(x)) for x in keep))
    return rows,keep

def load_native(path):
    lib=C.CDLL(str(path))
    lib.action_family_3f_decode.argtypes=[C.c_void_p,C.c_size_t,C.POINTER(Decoded)]
    lib.action_family_3f_decode.restype=C.c_int
    lib.action_family_3f_body_length.argtypes=[C.c_void_p,C.c_size_t,C.POINTER(C.c_size_t)]
    lib.action_family_3f_body_length.restype=C.c_int
    lib.action_family_3f_construct.argtypes=[C.c_void_p,C.c_size_t,C.POINTER(Text),C.c_size_t,
        C.c_uint32,C.c_uint32,C.c_void_p,C.c_size_t,C.POINTER(Constructed)]
    lib.action_family_3f_construct.restype=C.c_int
    return lib

class Family3fTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT/'scripts/build_action_family_3f.sh')],check=True,stdout=subprocess.DEVNULL)
        cls.lib=load_native(PROJECT/'build/libactionfamily3f.dylib')

    def reject(self,data):
        src=storage(data); rows,keep=texts([b'text']*32768)
        arena=storage(b'\xcd'*20000)
        for typ in (Decoded,Constructed):
            out=typ(); C.memset(C.byref(out),0xa5,C.sizeof(out)); before=bytes(out)
            if typ is Decoded:
                status=self.lib.action_family_3f_decode(src,len(src),C.byref(out))
            else:
                status=self.lib.action_family_3f_construct(src,len(src),rows,len(rows),50,0x20000000,
                                                          arena,len(arena),C.byref(out))
            self.assertNotEqual(status,0)
            self.assertEqual(bytes(out),before)
            self.assertEqual(bytes(arena),b'\xcd'*20000)
        n=C.c_size_t(0xdead)
        self.assertNotEqual(self.lib.action_family_3f_body_length(src,len(src),C.byref(n)),0)
        self.assertEqual(n.value,0xdead)

    def test_minimum_and_fields(self):
        src=storage(fixture(tails=2));d=Decoded()
        self.assertEqual(self.lib.action_family_3f_decode(src,len(src),C.byref(d)),0)
        self.assertEqual((d.raw_type,d.runtime_type),(0x3f,0x3f))
        self.assertEqual(bytes(d.name),b'NAME'+bytes(29))
        self.assertEqual(bytes(d.text_key),b'KEY'+bytes(30))
        self.assertEqual((d.option_21,d.option_44,d.option_45,d.option_46,d.word_47,d.word_49),
                         (0x8123,0x91,0x82,0x73,0xa456,0xb789))
        self.assertEqual((d.body_bytes,d.dependency_bytes,d.dependency_count),(79,32,2))
        self.assertEqual(d.dependency_records,C.addressof(src)+79)

    def test_nested_variable_records(self):
        raw=fixture((0,1,2,127),(0,1,127),3);src=storage(raw);d=Decoded()
        self.assertEqual(self.lib.action_family_3f_decode(src,len(src),C.byref(d)),0)
        self.assertEqual((d.primary_count,d.secondary_count),(4,3))
        self.assertEqual(d.primary_bytes,4*70+130*5)
        self.assertEqual(d.secondary_bytes,3*6+128*5)
        self.assertEqual(d.primary_records,C.addressof(src)+77)
        self.assertEqual(d.secondary_records,C.addressof(src)+77+d.primary_bytes+2)
        self.assertEqual(d.body_bytes,len(raw)-48)

    def test_maximum_primary_count(self):
        src=storage(fixture((0,)*32767));d=Decoded()
        self.assertEqual(self.lib.action_family_3f_decode(src,len(src),C.byref(d)),0)
        self.assertEqual((d.primary_count,d.body_bytes),(32767,79+70*32767))

    def test_maximum_secondary_count(self):
        src=storage(fixture((),(0,)*127));d=Decoded()
        self.assertEqual(self.lib.action_family_3f_decode(src,len(src),C.byref(d)),0)
        self.assertEqual((d.secondary_count,d.body_bytes),(127,79+6*127))

    def test_all_short_prefixes(self):
        for n in range(79):self.reject(fixture()[:n])

    def test_all_nested_truncations(self):
        raw=fixture((1,),(2,))
        for n in range(77,len(raw)):self.reject(raw[:n])

    def test_negative_counts(self):
        for n in (-32768,-1):
            raw=bytearray(fixture());struct.pack_into('<h',raw,75,n);self.reject(raw)
        self.reject(fixture((-1,)))
        self.reject(fixture((),(-128,)))
        raw=bytearray(fixture());raw[77]=255;self.reject(raw)

    def test_count_overflow_or_missing_extent(self):
        raw=bytearray(fixture());struct.pack_into('<H',raw,75,32767);self.reject(raw)
        raw=bytearray(fixture((0,)));raw[77]=127;self.reject(raw)
        raw=bytearray(fixture());raw[77]=128;self.reject(raw)

    def test_unterminated_fields(self):
        for offset,raw in ((0,fixture()),(35,fixture()),(79,fixture((0,))),(112,fixture((0,)))):
            b=bytearray(raw);b[offset:offset+33]=b'x'*33;self.reject(b)

    def test_misaligned_tail(self):
        for n in range(1,16):self.reject(fixture()+bytes(n))

    def test_null_overlap_wrap(self):
        src=storage(fixture());d=Decoded();out=Constructed();rows,keep=texts([b'a'])
        self.assertNotEqual(self.lib.action_family_3f_decode(None,len(src),C.byref(d)),0)
        self.assertNotEqual(self.lib.action_family_3f_decode(src,len(src),None),0)
        arena=storage(fixture()+bytes(4096));before=bytes(arena)
        self.assertNotEqual(self.lib.action_family_3f_decode(arena,79,C.cast(arena,C.POINTER(Decoded))),0)
        self.assertNotEqual(self.lib.action_family_3f_construct(arena,79,rows,1,50,1,arena,2000,C.byref(out)),0)
        self.assertEqual(bytes(arena),before)
        n=C.c_size_t(-1).value
        self.assertNotEqual(self.lib.action_family_3f_decode(src,n,C.byref(d)),0)
        self.assertNotEqual(self.lib.action_family_3f_decode(C.c_void_p(n-15),79,C.byref(d)),0)
        self.assertNotEqual(self.lib.action_family_3f_body_length(arena,79,C.cast(arena,C.POINTER(C.c_size_t))),0)

    def test_constructor_defaults_preserve_memory_and_wrap(self):
        src=storage(fixture());rows,keep=texts([b'caption']);out=Constructed()
        arena=storage(b'\xcd'*1957)
        self.assertEqual(self.lib.action_family_3f_construct(src,len(src),rows,1,0xfffffff0,0x21000000,
                                                           arena,len(arena),C.byref(out)),0)
        self.assertEqual((out.arena_bytes,out.allocation_count),(1957,1))
        self.assertEqual(out.payload_offset_after,63)
        self.assertEqual(bytes(arena[0x16b:0x173]),b'caption\0')
        self.assertEqual(arena[0x31],0xcd)
        for offset in (0x2d,0x2f,0x774,0x776):
            self.assertEqual(struct.unpack_from('<H',bytes(arena),offset)[0],0x8123)
        self.assertEqual(struct.unpack_from('<HH',bytes(arena),0x793),(0,0))
        self.assertEqual(bytes(arena[0x747:0x74d]),b'dummy\0')

    def test_constructor_plan_and_all_allocations(self):
        src=storage(fixture((1,0),(2,)));rows,keep=texts([b'main',b'one',b'two']);out=Constructed()
        self.assertEqual(self.lib.action_family_3f_construct(src,len(src),rows,3,50,0x22000000,
                                                           None,0,C.byref(out)),0)
        arena=storage(b'\x7b'*out.arena_bytes)
        self.assertEqual(self.lib.action_family_3f_construct(src,len(src),rows,3,50,0x22000000,
                                                           arena,len(arena),C.byref(out)),0)
        self.assertEqual(out.allocation_count,5)
        self.assertEqual(out.primary_offset,1960)
        self.assertEqual(struct.unpack_from('<I',bytes(arena),0x795)[0],0x22000000+out.primary_offset)
        self.assertEqual(struct.unpack_from('<I',bytes(arena),0x7a1)[0],0x22000000+out.secondary_offset)
        self.assertEqual(bytes(arena[out.primary_offset+6:out.primary_offset+10]),b'one\0')

    def test_constructor_rejections_before_writes(self):
        src=storage(fixture((0,)));out=Constructed();arena=storage(b'\xa5'*10000)
        for values,base,cap in (([b'main'],1,10000),([b'main',b'x'*400],1,10000),
                ([b'x'*1500,b'a'],1,10000),([b'a',b'b'],0,10000),
                ([b'a',b'b'],0xfffffff0,10000),([b'a',b'b'],1,3)):
            rows,keep=texts(values);C.memset(C.byref(out),0x6b,C.sizeof(out));before=bytes(out)
            self.assertNotEqual(self.lib.action_family_3f_construct(src,len(src),rows,len(rows),50,base,
                arena,cap,C.byref(out)),0)
            self.assertEqual(bytes(out),before);self.assertEqual(bytes(arena),b'\xa5'*10000)
        rows=(Text*2)(Text(C.addressof(arena),3),Text(0,1))
        self.assertNotEqual(self.lib.action_family_3f_construct(src,len(src),rows,2,50,1,arena,10000,C.byref(out)),0)
        self.assertEqual(bytes(arena),b'\xa5'*10000)

    def test_resolved_text_limits_and_embedded_nul(self):
        src=storage(fixture((0,)));out=Constructed();rows,keep=texts([b'x'*1499,b'y'*399])
        arena=storage(b'\x35'*3000)
        self.assertEqual(self.lib.action_family_3f_construct(src,len(src),rows,2,50,1,arena,len(arena),C.byref(out)),0)
        rows,keep=texts([b'a\0ignored',b''])
        self.assertEqual(self.lib.action_family_3f_construct(src,len(src),rows,2,50,1,arena,len(arena),C.byref(out)),0)
        self.assertEqual(bytes(arena[0x16b:0x16d]),b'a\0')

    def test_constructor_all_output_aliases_and_nulls(self):
        src=storage(fixture());out=Constructed();arena=storage(b'\xa5'*3000)
        rows,keep=texts([b'caption']);C.memset(C.byref(out),0x6b,C.sizeof(out));before=bytes(out)
        calls=[(None,len(src),rows,1,arena,3000,C.byref(out)),
               (src,len(src),None,1,arena,3000,C.byref(out)),
               (src,len(src),rows,1,None,1,C.byref(out)),
               (src,len(src),rows,1,arena,3000,None),
               (src,len(src),rows,1,arena,3000,C.cast(arena,C.POINTER(Constructed))),
               (src,len(src),C.cast(arena,C.POINTER(Text)),1,arena,3000,C.byref(out)),
               (src,len(src),C.cast(C.byref(out),C.POINTER(Text)),1,arena,3000,C.byref(out))]
        for raw,n,text,count,buf,cap,target in calls:
            self.assertNotEqual(self.lib.action_family_3f_construct(raw,n,text,count,50,1,buf,cap,target),0)
            self.assertEqual(bytes(out),before);self.assertEqual(bytes(arena),b'\xa5'*3000)
        alias=(Text*1)(Text(C.addressof(out),4))
        self.assertNotEqual(self.lib.action_family_3f_construct(src,len(src),alias,1,50,1,
                           arena,3000,C.byref(out)),0)
        self.assertEqual(bytes(out),before);self.assertEqual(bytes(arena),b'\xa5'*3000)

if __name__=='__main__':unittest.main()
