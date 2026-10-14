"""Fixtures for raw44's inline/keyed body and allocated value model."""
import ctypes as C
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
OK, ARGUMENT, BODY, TAIL, BOUNDS, OVERLAP, TEXT = range(7)

class Decoded(C.Structure):
    _fields_ = [('header', C.c_void_p), ('text', C.c_void_p), ('text_bytes', C.c_size_t),
                ('word_02', C.c_uint16), ('word_20e', C.c_uint16), ('option_1ec', C.c_uint8),
                ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8),
                ('dependency_records', C.c_void_p), ('dependency_count', C.c_size_t),
                ('available_body_bytes', C.c_size_t), ('body_bytes', C.c_size_t),
                ('dependency_bytes', C.c_size_t)]

class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.c_size_t), ('body_bytes_consumed', C.c_size_t),
                ('dependency_records', C.c_void_p), ('dependency_count', C.c_size_t),
                ('dependency_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t),
                ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
                ('result_slot_handle', C.c_uint32), ('word_20e_after', C.c_uint16),
                ('source_word_20e_after', C.c_uint16), ('source_word_20e_written', C.c_uint8),
                ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]

def storage(data):
    return (C.c_uint8 * len(data)).from_buffer_copy(data)

def fixture(mode=1, inline=b'abc\0', count=None, tail=0, word=2, key=b'KEY'):
    header = bytearray((i * 13 + 7) & 255 for i in range(528))
    struct.pack_into('<H', header, 2, word)
    header[492] = mode
    header[493:526] = key.ljust(33, b'\0')
    struct.pack_into('<H', header, 526, (len(inline) if count is None else count) & 65535)
    return bytes(header) + (inline if mode == 0 else b'') + bytes(tail * 16)

def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_44_decode.argtypes = [C.c_void_p, C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_44_decode.restype = C.c_int
    lib.action_family_44_body_length.argtypes = [C.c_void_p, C.c_size_t, C.POINTER(C.c_size_t)]
    lib.action_family_44_body_length.restype = C.c_int
    lib.action_family_44_construct.argtypes = [C.c_void_p, C.c_size_t, C.c_void_p, C.c_size_t,
        C.c_uint32, C.c_uint32, C.c_void_p, C.c_size_t, C.POINTER(Constructed)]
    lib.action_family_44_construct.restype = C.c_int
    return lib

class ActionFamily44Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-44.1.tests-',
            dir=PROJECT.parents[1] / 'work/analysis/slices')
        path = Path(cls.directory.name) / 'libactionfamily44.dylib'
        run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
            '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC',
            '-dynamiclib', str(PROJECT / 'src/action_family_44.c'), '-o', str(path)],
            capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(path)

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def reject(self, data, status):
        raw = storage(data); d = Decoded(); c = Constructed(); n = C.c_size_t(999)
        arena = storage(b'\xa5' * 1024); text = storage(b'text\0')
        C.memset(C.byref(d), 0xa5, C.sizeof(d)); C.memset(C.byref(c), 0xa5, C.sizeof(c))
        before = bytes(d), bytes(c), bytes(arena)
        self.assertEqual(self.lib.action_family_44_decode(raw,len(raw),C.byref(d)),status)
        self.assertEqual(self.lib.action_family_44_body_length(raw,len(raw),C.byref(n)),status)
        self.assertEqual(self.lib.action_family_44_construct(raw,len(raw),text,len(text),50,1,
            arena,len(arena),C.byref(c)),status)
        self.assertEqual((bytes(d),bytes(c),bytes(arena)),before)
        self.assertEqual(n.value,999); self.assertEqual(bytes(raw),data)

    def test_keyed_fixed_rule_ignores_signed_looking_word(self):
        for mode in (1,2,255):
            for count in (0,32767,32768,65535):
                raw = storage(fixture(mode=mode,count=count,tail=2,word=65535)); d=Decoded()
                self.assertEqual(self.lib.action_family_44_decode(raw,len(raw),C.byref(d)),OK)
                self.assertEqual((d.option_1ec,d.word_02,d.word_20e),(mode,65535,count))
                self.assertEqual((d.body_bytes,d.dependency_count,d.text_bytes),(528,2,3))
                self.assertEqual((d.header,d.text,d.dependency_records),(C.addressof(raw),C.addressof(raw)+493,C.addressof(raw)+528))
                self.assertEqual((d.raw_type,d.runtime_type),(0x44,0x44))

    def test_inline_minimum_and_maximum(self):
        for n in (1,2,32767):
            raw=storage(fixture(0,b'x'*(n-1)+b'\0',tail=1)); d=Decoded(); length=C.c_size_t()
            self.assertEqual(self.lib.action_family_44_decode(raw,len(raw),C.byref(d)),OK)
            self.assertEqual(self.lib.action_family_44_body_length(raw,len(raw),C.byref(length)),OK)
            self.assertEqual((length.value,d.body_bytes,d.text_bytes),(528+n,528+n,n-1))

    def test_borrowed_view(self):
        raw=storage(fixture(tail=1));d=Decoded()
        self.assertEqual(self.lib.action_family_44_decode(raw,len(raw),C.byref(d)),OK)
        raw[528]=97;self.assertEqual(C.string_at(d.dependency_records,1),b'a')
        self.assertEqual((d.dependency_bytes,d.available_body_bytes),(16,len(raw)))

    def test_all_short_fixed_headers(self):
        b=fixture()
        for n in range(528):self.reject(b[:n],BODY)

    def test_short_inline_extension(self):
        self.reject(fixture(0,b'ab\0',count=4),BODY)

    def test_negative_inline_counts(self):
        for n in (32768,65535):self.reject(fixture(0,count=n),BODY)

    def test_empty_inline_extent(self):
        self.reject(fixture(0,b'',count=0),TEXT)

    def test_inline_word_branch_bound(self):
        self.reject(fixture(0,word=3),BODY)
        raw=storage(fixture(0,word=65535));d=Decoded()
        self.assertEqual(self.lib.action_family_44_decode(raw,len(raw),C.byref(d)),OK)

    def test_missing_terminators(self):
        self.reject(fixture(key=b'k'*33),TEXT)
        self.reject(fixture(0,b'abc'),TEXT)

    def test_every_fractional_tail(self):
        for n in range(1,41):
            if n%16:self.reject(fixture()+bytes(n),TAIL)

    def construct(self,data,text=b'caption\0',offset=50):
        raw=storage(data); t=storage(text); c=Constructed()
        self.assertEqual(self.lib.action_family_44_construct(raw,len(raw),t,len(t),offset,0x440001,None,0,C.byref(c)),OK)
        arena=storage(b'\xa5'*c.object_bytes)
        self.assertEqual(self.lib.action_family_44_construct(raw,len(raw),t,len(t),offset,0x440001,arena,len(arena),C.byref(c)),OK)
        self.assertEqual(bytes(raw),data)
        return c,bytes(arena)

    def test_keyed_constructor_full_object(self):
        data=fixture(count=65535);c,b=self.construct(data)
        self.assertEqual(b,data[:526]+struct.pack('<H',7)+b'caption\0')
        self.assertEqual((c.object_bytes,c.body_bytes_consumed,c.payload_offset_after),(536,528,578))
        self.assertEqual((c.result_slot_handle,c.source_word_20e_written,c.source_word_20e_after,c.word_20e_after),(0x440001,0,65535,7))

    def test_inline_copy_retains_declared_junk_and_models_source_write(self):
        data=fixture(0,b'a\0junk');c,b=self.construct(data)
        self.assertEqual(b,data)
        self.assertEqual((c.word_20e_after,c.source_word_20e_after,c.source_word_20e_written),(6,1,1))

    def test_keyed_maximum_text_and_narrowing(self):
        for n in (0,32767,32768,40000):
            c,b=self.construct(fixture(),b'x'*n+b'\0')
            self.assertEqual((c.object_bytes,c.word_20e_after),(529+n,n))
            self.assertEqual(b[528:],b'x'*n+b'\0')

    def test_offset_wrap(self):
        c,_=self.construct(fixture(),offset=0xfffffff0)
        self.assertEqual(c.payload_offset_after,(0xfffffff0+528)&0xffffffff)

    def test_constructor_failures_are_atomic(self):
        raw=storage(fixture());out=Constructed();text=storage(b'abc\0');arena=storage(b'\xa5'*600)
        for t,n,h,a,z,status in [(None,0,1,arena,600,TEXT),(text,3,1,arena,600,TEXT),
            (text,4,0,arena,600,ARGUMENT),(text,4,1,arena,531,BOUNDS),
            (text,4,1,None,1,ARGUMENT)]:
            C.memset(C.byref(out),0xa5,C.sizeof(out));before=bytes(out),bytes(arena)
            self.assertEqual(self.lib.action_family_44_construct(raw,len(raw),t,n,0,h,a,z,C.byref(out)),status)
            self.assertEqual((bytes(out),bytes(arena)),before)
        long=storage(b'x'*40001+b'\0')
        self.assertEqual(self.lib.action_family_44_construct(raw,len(raw),long,len(long),0,1,None,0,C.byref(out)),TEXT)

    def test_null_and_wrapped_spans(self):
        raw=storage(fixture());d=Decoded();c=Constructed();n=C.c_size_t()
        self.assertEqual(self.lib.action_family_44_decode(None,528,C.byref(d)),ARGUMENT)
        self.assertEqual(self.lib.action_family_44_decode(raw,528,None),ARGUMENT)
        self.assertEqual(self.lib.action_family_44_body_length(raw,528,None),ARGUMENT)
        self.assertEqual(self.lib.action_family_44_construct(None,528,None,0,0,1,None,0,C.byref(c)),ARGUMENT)
        self.assertEqual(self.lib.action_family_44_construct(raw,528,None,0,0,1,None,0,None),ARGUMENT)
        for p,z in [(C.c_void_p(-1),528),(raw,C.c_size_t(-1).value)]:
            self.assertEqual(self.lib.action_family_44_decode(p,z,C.byref(d)),BOUNDS)
            self.assertEqual(self.lib.action_family_44_body_length(p,z,C.byref(n)),BOUNDS)
            self.assertEqual(self.lib.action_family_44_construct(p,z,None,0,0,1,None,0,C.byref(c)),BOUNDS)

    def test_adjacent_spans_and_first_nul_resolution(self):
        raw=storage(fixture());t=storage(b'a\0junk');c=Constructed()
        block=storage(bytes(C.sizeof(Constructed)+530))
        out=C.cast(block,C.POINTER(Constructed))
        arena=C.c_void_p(C.addressof(block)+C.sizeof(Constructed))
        self.assertEqual(self.lib.action_family_44_construct(raw,len(raw),t,len(t),0,1,
            arena,530,out),OK)
        self.assertEqual((out.contents.object_bytes,out.contents.word_20e_after),(530,1))
        self.assertEqual(C.string_at(arena.value+528,2),b'a\0')

    def test_overlapping_outputs(self):
        block=storage(fixture()+bytes(600));before=bytes(block)
        for cls,call in [(Decoded,self.lib.action_family_44_decode),(C.c_size_t,self.lib.action_family_44_body_length)]:
            out=C.cast(C.addressof(block)+1,C.POINTER(cls))
            self.assertEqual(call(block,528,out),OVERLAP)
        c=Constructed();t=storage(b'a\0')
        self.assertEqual(self.lib.action_family_44_construct(block,528,t,2,0,1,block,600,C.byref(c)),OVERLAP)
        out=C.cast(C.addressof(block)+1,C.POINTER(Constructed))
        self.assertEqual(self.lib.action_family_44_construct(block,528,t,2,0,1,None,0,out),OVERLAP)
        arena=storage(bytes(600));out=C.cast(arena,C.POINTER(Constructed))
        self.assertEqual(self.lib.action_family_44_construct(block,528,t,2,0,1,arena,600,out),OVERLAP)
        self.assertEqual(bytes(block),before)

if __name__=='__main__':unittest.main()
