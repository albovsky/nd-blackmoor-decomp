"""A-35.1 fixtures: bounded decode and transactional allocation model."""
import ctypes as C
import struct
import subprocess
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / 'outputs/blackmoor-decomp'
MAX_COUNT = 32767
MAX_BODY = 63 + 40 * MAX_COUNT


class Decoded(C.Structure):
    _fields_ = [('name', C.c_uint8 * 33), ('words', C.c_uint16 * 13),
                ('count_6', C.c_int16), ('count_34', C.c_int16),
                ('records_6', C.c_void_p), ('records_34', C.c_void_p),
                ('dependency_records', C.c_void_p), ('dependency_count', C.c_size_t),
                ('dependency_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t),
                ('body_bytes', C.c_size_t), ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]


class Record6(C.Structure):
    _fields_ = [('words', C.c_uint16 * 3)]


class Record34(C.Structure):
    _fields_ = [('words', C.c_uint16 * 17)]


class Constructed(C.Structure):
    _fields_ = [('dependency_records', C.c_void_p), ('dependency_count', C.c_size_t),
                ('dependency_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t),
                ('body_bytes_consumed', C.c_size_t), ('allocation_bytes', C.c_size_t),
                ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
                ('result_slot_handle', C.c_uint32), ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]


def storage(data):
    return (C.c_uint8 * len(data)).from_buffer_copy(data)


def fixture(n=1, m=1, tail=0, terminated=True):
    body = bytearray((i * 37 + 19) & 255 for i in range(63 + 6*n + 34*m))
    body[:33] = b'movie' + bytes(28) if terminated else b'X'*33
    struct.pack_into('<h', body, 59, n)
    struct.pack_into('<h', body, 61+6*n, m)
    body += bytes((i * 13 + 7) & 255 for i in range(tail))
    return bytes(body)


def load_native(path=None):
    lib = C.CDLL(str(path or PROJECT/'build/libactionfamily35.dylib'))
    lib.action_family_35_decode.argtypes = [C.c_void_p, C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_35_decode.restype = C.c_int
    for name, record in [('record6_at', Record6), ('record34_at', Record34)]:
        fn = getattr(lib, 'action_family_35_'+name)
        fn.argtypes = [C.c_void_p, C.c_size_t, C.c_size_t, C.POINTER(record)]
        fn.restype = C.c_int
    lib.action_family_35_construct.argtypes = [C.c_void_p, C.c_size_t, C.c_uint32, C.c_uint32,
        C.c_void_p, C.c_size_t, C.POINTER(Constructed)]
    lib.action_family_35_construct.restype = C.c_int
    return lib


class ActionFamily35Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT/'scripts/build_action_family_35.sh')], check=True, capture_output=True)
        cls.lib = load_native()

    def check_valid(self, n, m, tail=0, terminated=True):
        body = fixture(n,m,tail,terminated); src = storage(body); out = Decoded()
        self.assertEqual(self.lib.action_family_35_decode(src,len(body),C.byref(out)),0)
        typed = 63+6*n+34*m
        self.assertEqual(bytes(out.name),body[:33])
        self.assertEqual(list(out.words),list(struct.unpack_from('<13H',body,33)))
        self.assertEqual((out.count_6,out.count_34),(n,m))
        self.assertEqual((out.raw_type,out.runtime_type),(0x35,0x35))
        self.assertEqual((out.records_6,out.records_34),(C.addressof(src)+61,C.addressof(src)+63+6*n))
        self.assertEqual((out.body_bytes,out.available_body_bytes,out.dependency_records,
            out.dependency_count,out.dependency_bytes),(typed,len(body),C.addressof(src)+typed,tail//16,tail))
        obj = (C.c_uint8 * (typed+16))(*([0xcc]*(typed+16))); meta = Constructed()
        self.assertEqual(self.lib.action_family_35_construct(src,len(body),0xfffffff0,0x35000001,
            obj,len(obj),C.byref(meta)),0)
        self.assertEqual(bytes(obj[:typed]),body[:typed]); self.assertEqual(bytes(obj[typed:]),b'\xcc'*16)
        self.assertEqual((meta.body_bytes_consumed,meta.allocation_bytes,meta.payload_offset_before,
            meta.payload_offset_after,meta.result_slot_handle,meta.raw_type,meta.runtime_type),
            (typed,typed,0xfffffff0,(0xfffffff0+typed)&0xffffffff,0x35000001,0x35,0x35))
        self.assertEqual((meta.dependency_records,meta.dependency_count,meta.dependency_bytes,
            meta.available_body_bytes),(C.addressof(src)+typed,tail//16,tail,len(body)))
        for count, stride, start, typ, fn in [(n,6,61,Record6,self.lib.action_family_35_record6_at),
                (m,34,63+6*n,Record34,self.lib.action_family_35_record34_at)]:
            for idx in sorted({0,max(0,count-1)}):
                rec = typ(); C.memset(C.byref(rec),0xa5,C.sizeof(rec)); before = bytes(rec)
                status = fn(src,len(body),idx,C.byref(rec))
                if idx >= count:
                    self.assertEqual(status,8); self.assertEqual(bytes(rec),before)
                else:
                    self.assertEqual(status,0)
                    self.assertEqual(list(rec.words),list(struct.unpack_from('<'+'H'*(stride//2),body,start+stride*idx)))
        return src,out

    def reject(self, body, status):
        src = storage(body); dec = Decoded(); meta = Constructed(); obj = (C.c_uint8*256)()
        for out in (dec,meta,obj): C.memset(C.byref(out),0xa5,C.sizeof(out))
        before = [bytes(out) for out in (src,dec,meta,obj)]
        self.assertEqual(self.lib.action_family_35_decode(src,len(body),C.byref(dec)),status)
        self.assertEqual(self.lib.action_family_35_construct(src,len(body),50,1,obj,len(obj),C.byref(meta)),status)
        for typ,fn in [(Record6,self.lib.action_family_35_record6_at),(Record34,self.lib.action_family_35_record34_at)]:
            rec=typ(); C.memset(C.byref(rec),0xa5,C.sizeof(rec)); rb=bytes(rec)
            self.assertEqual(fn(src,len(body),0,C.byref(rec)),status);self.assertEqual(bytes(rec),rb)
        self.assertEqual([bytes(out) for out in (src,dec,meta,obj)],before)

    def test_minimum(self): self.check_valid(0,0)
    def test_valid_arrays_and_tail(self): self.check_valid(3,4,48)
    def test_maximum_first_count(self): self.check_valid(MAX_COUNT,0)
    def test_maximum_second_count(self): self.check_valid(0,MAX_COUNT)
    def test_maximum_both_counts(self): self.check_valid(MAX_COUNT,MAX_COUNT,16)
    def test_name_bytes_are_copied_without_string_semantics(self): self.check_valid(1,1,0,False)

    def test_short_prefix(self):
        for n in range(61):
            with self.subTest(length=n): self.reject(fixture()[:n],2)
    def test_short_arrays(self):
        body=fixture(2,2)
        for n in range(61,len(body)):
            with self.subTest(length=n): self.reject(body[:n],2)
    def test_bad_tail(self):
        for tail in range(1,32):
            if tail!=16:
                with self.subTest(tail=tail): self.reject(fixture(tail=tail),4)
    def test_negative_and_unsigned_count_overflow(self):
        for offset in (59,67):
            for value in (0x8000,0x8001,0xffff):
                body=bytearray(fixture());struct.pack_into('<H',body,offset,value)
                with self.subTest(offset=offset,value=value): self.reject(bytes(body),3)
    def test_max_counts_require_full_arrays(self):
        body=bytearray(fixture());struct.pack_into('<H',body,59,32767);self.reject(body,2)
        body=bytearray(fixture());struct.pack_into('<H',body,67,32767);self.reject(body,2)
    def test_null_arguments(self):
        src=storage(fixture());out=Decoded();meta=Constructed();obj=(C.c_uint8*256)()
        self.assertEqual(self.lib.action_family_35_decode(None,103,C.byref(out)),1)
        self.assertEqual(self.lib.action_family_35_decode(src,len(src),None),1)
        for handle,ptr,mp in [(0,obj,C.byref(meta)),(1,None,C.byref(meta)),(1,obj,None)]:
            self.assertEqual(self.lib.action_family_35_construct(src,len(src),50,handle,ptr,256,mp),1)
    def test_capacity_failure_is_atomic(self):
        src=storage(fixture());obj=(C.c_uint8*256)();meta=Constructed()
        C.memset(obj,0xa5,len(obj));C.memset(C.byref(meta),0xa5,C.sizeof(meta));before=(bytes(obj),bytes(meta))
        self.assertEqual(self.lib.action_family_35_construct(src,len(src),50,1,obj,102,C.byref(meta)),7)
        self.assertEqual((bytes(obj),bytes(meta)),before)
    def test_overlap_failure_is_atomic(self):
        buf=(C.c_uint8*1024)();C.memmove(buf,fixture(),103);base=C.addressof(buf);before=bytes(buf)
        self.assertEqual(self.lib.action_family_35_decode(buf,103,C.cast(base+1,C.POINTER(Decoded))),6)
        meta=Constructed();C.memset(C.byref(meta),0xa5,C.sizeof(meta));mb=bytes(meta)
        self.assertEqual(self.lib.action_family_35_construct(buf,103,50,1,base+1,200,C.byref(meta)),6)
        self.assertEqual(self.lib.action_family_35_construct(buf,103,50,1,base+256,256,
            C.cast(base+257,C.POINTER(Constructed))),6)
        self.assertEqual(self.lib.action_family_35_construct(buf,103,50,1,base+256,256,
            C.cast(base,C.POINTER(Constructed))),6)
        self.assertEqual(bytes(buf),before);self.assertEqual(bytes(meta),mb)
    def test_address_wrap_rejected_before_read(self):
        src=storage(fixture());out=Decoded();obj=(C.c_uint8*256)();meta=Constructed()
        self.assertEqual(self.lib.action_family_35_decode(C.c_void_p(-32),103,C.byref(out)),5)
        self.assertEqual(self.lib.action_family_35_decode(src,C.c_size_t(-1),C.byref(out)),5)
        self.assertEqual(self.lib.action_family_35_decode(src,len(src),C.cast(C.c_void_p(-32),C.POINTER(Decoded))),5)
        self.assertEqual(self.lib.action_family_35_construct(src,len(src),50,1,obj,C.c_size_t(-1),C.byref(meta)),5)
    def test_unaligned_source(self):
        body=fixture(1,2,16);src=storage(b'!'+body);out=Decoded()
        self.assertEqual(self.lib.action_family_35_decode(C.addressof(src)+1,len(body),C.byref(out)),0)
        self.assertEqual(out.body_bytes,137)
    def test_record_output_overlap_and_range(self):
        src=storage(fixture());before=bytes(src)
        for fn,typ in [(self.lib.action_family_35_record6_at,Record6),(self.lib.action_family_35_record34_at,Record34)]:
            rec=typ();C.memset(C.byref(rec),0xa5,C.sizeof(rec));rb=bytes(rec)
            self.assertEqual(fn(src,len(src),C.c_size_t(-1),C.byref(rec)),8)
            self.assertEqual(bytes(rec),rb)
            self.assertEqual(fn(src,len(src),0,C.cast(src,C.POINTER(typ))),6)
            self.assertEqual(fn(src,len(src),0,None),1)
        self.assertEqual(bytes(src),before)


if __name__=='__main__': unittest.main()
