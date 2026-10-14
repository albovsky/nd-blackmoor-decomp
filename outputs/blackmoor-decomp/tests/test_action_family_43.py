"""Fixtures for raw43 boundaries and successful constructor, not gameplay."""
import ctypes as C
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = PROJECT.parents[1] / 'work/analysis/slices'
OK, ARGUMENT, BODY, TAIL, BOUNDS, OVERLAP, COUNT, STRING, CAPACITY = range(9)

class Decoded(C.Structure):
    _fields_ = [('word_00', C.c_uint16), ('option_02', C.c_int16),
        ('option_109', C.c_uint8), ('key', C.c_char * 33), ('word_12b', C.c_uint16),
        ('prefix', C.POINTER(C.c_uint8)), ('inline_text', C.POINTER(C.c_uint8)),
        ('inline_visible_length', C.c_size_t), ('dependency_records', C.POINTER(C.c_uint8)),
        ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
        ('body_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t)]

class Constructed(C.Structure):
    _fields_ = [('dependency_records', C.POINTER(C.c_uint8)), ('dependency_count', C.c_size_t),
        ('dependency_bytes', C.c_size_t), ('body_bytes_consumed', C.c_size_t),
        ('available_body_bytes', C.c_size_t), ('allocation_bytes', C.c_size_t),
        ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
        ('result_slot_handle', C.c_uint32), ('source_word_12b_after', C.c_uint16),
        ('source_word_written', C.c_uint8), ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]

def storage(data):
    return (C.c_uint8 * len(data)).from_buffer_copy(data)

def pointer(value):
    return C.cast(value, C.c_void_p).value

def body_fixture(selector=1, inline=b'hello\0', tail=0, count=None, option=0, key=b'fixture'):
    body = bytearray((i * 19 + 7) & 255 for i in range(301))
    struct.pack_into('<h', body, 2, option)
    body[265] = selector
    body[266:299] = key + bytes(33-len(key))
    struct.pack_into('<H', body, 299, (len(inline) if not selector and count is None else (count or 0)) & 65535)
    if not selector:
        body += inline
    body += bytes((i*31+9)&255 for i in range(tail*16))
    return bytes(body)

def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_43_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_43_decode.restype = C.c_int
    lib.action_family_43_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
        C.POINTER(C.c_uint8), C.c_size_t, C.c_uint32, C.c_uint32,
        C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Constructed)]
    lib.action_family_43_construct.restype = C.c_int
    return lib

class ActionFamily43Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-43.1.tests-', dir=PRIVATE)
        lib = Path(cls.directory.name) / 'native.dylib'
        run = subprocess.run(['xcrun','--sdk','macosx','clang','-arch','arm64','-std=c11',
            '-Wall','-Wextra','-Wpedantic','-Werror','-O2','-fPIC','-dynamiclib',
            str(PROJECT/'src/action_family_43.c'),'-o',str(lib)],capture_output=True,text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: '+run.stderr)
        cls.lib = load_native(lib)
    @classmethod
    def tearDownClass(cls): cls.directory.cleanup()

    def rejected(self, body, status, text=None):
        raw = storage(body); txt = storage(text) if text is not None else None
        d, c = Decoded(), Constructed(); arena = storage(bytes([0x91])*40302)
        for out in (d,c): C.memset(C.byref(out),0xa5,C.sizeof(out))
        before_d,before_c,before_arena = bytes(d),bytes(c),bytes(arena)
        self.assertEqual(self.lib.action_family_43_decode(raw,len(raw),C.byref(d)),status)
        self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),txt,len(text or b''),
            50,0x430001,arena,len(arena),C.byref(c)),status)
        self.assertEqual((bytes(d),bytes(c),bytes(arena),bytes(raw)),
            (before_d,before_c,before_arena,body))

    def test_keyed_body_and_borrowed_tail(self):
        for selector in (1,2,255):
            for count in (0,1,9,1000):
                raw = storage(body_fixture(selector=selector,tail=count,count=0xffff,option=32767))
                d=Decoded()
                self.assertEqual(self.lib.action_family_43_decode(raw,len(raw),C.byref(d)),OK)
                self.assertEqual((d.option_109,d.word_12b,d.option_02,d.key),(selector,65535,32767,b'fixture'))
                self.assertEqual((d.body_bytes,d.dependency_count,d.dependency_bytes),(301,count,count*16))
                self.assertEqual(pointer(d.prefix),C.addressof(raw))
                self.assertEqual(pointer(d.dependency_records),C.addressof(raw)+301)
                self.assertFalse(d.inline_text)
                if count:
                    raw[301]^=255
                    self.assertEqual(d.dependency_records[0],raw[301])

    def test_inline_minimum_and_maximum_counts(self):
        for n in (1,2,32767):
            text=b'x'*(n-1)+b'\0';raw=storage(body_fixture(selector=0,inline=text,tail=2))
            d=Decoded()
            self.assertEqual(self.lib.action_family_43_decode(raw,len(raw),C.byref(d)),OK)
            self.assertEqual((d.word_12b,d.inline_visible_length,d.body_bytes),(n,n-1,301+n))
            self.assertEqual(pointer(d.inline_text),C.addressof(raw)+301)
            self.assertEqual(pointer(d.dependency_records),C.addressof(raw)+301+n)

    def test_inline_length_is_not_visible_length(self):
        raw=storage(body_fixture(selector=0,inline=b'a\0xyz',tail=1));d=Decoded()
        self.assertEqual(self.lib.action_family_43_decode(raw,len(raw),C.byref(d)),OK)
        self.assertEqual((d.inline_visible_length,d.body_bytes,d.dependency_count),(1,306,1))

    def test_inline_option_signed_comparison(self):
        for value in (-32768,-1,0,1,2):
            raw=storage(body_fixture(selector=0,option=value));d=Decoded()
            self.assertEqual(self.lib.action_family_43_decode(raw,len(raw),C.byref(d)),OK)
            self.assertEqual(d.option_02,value)
        self.rejected(body_fixture(selector=0,option=3),COUNT)

    def test_short_bodies_atomic(self):
        for n in range(301): self.rejected(bytes(n),BODY)
        self.rejected(body_fixture(selector=0,inline=b'\0',count=2),BODY)

    def test_negative_and_zero_inline_counts_atomic(self):
        for n in (-32768,-1): self.rejected(body_fixture(selector=0,count=n),COUNT)
        self.rejected(body_fixture(selector=0,inline=b'',count=0),STRING)

    def test_fractional_tails_atomic(self):
        for n in range(1,32):
            if n%16:
                self.rejected(body_fixture()+bytes(n),TAIL)
                self.rejected(body_fixture(selector=0)+bytes(n),TAIL)

    def test_unterminated_strings_atomic(self):
        self.rejected(body_fixture(key=b'x'*33),STRING)
        self.rejected(body_fixture(selector=0,inline=b'abc'),STRING)

    def construct(self,body,text,offset=50):
        raw=storage(body);txt=storage(text) if text is not None else None
        c=Constructed()
        self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),txt,len(text or b''),
            offset,0x430001,None,0,C.byref(c)),OK)
        arena=storage(bytes([0xcd])*c.allocation_bytes)
        self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),txt,len(text or b''),
            offset,0x430001,arena,len(arena),C.byref(c)),OK)
        self.assertEqual(bytes(raw),body)
        return bytes(arena),c

    def test_keyed_constructor_whole_object_and_limits(self):
        for n in (0,1,32767,40000):
            body=body_fixture(count=65535,tail=1,option=32767);text=b'x'*n+b'\0'
            obj,c=self.construct(body,text)
            expected=bytearray(body[:301]);struct.pack_into('<H',expected,299,n);expected+=text
            self.assertEqual(obj,expected)
            self.assertEqual((c.allocation_bytes,c.body_bytes_consumed,c.source_word_written,c.source_word_12b_after),
                (302+n,301,0,65535))
            self.assertEqual((c.result_slot_handle,c.raw_type,c.runtime_type),(0x430001,0x43,0x43))

    def test_inline_constructor_copy_and_source_write_effect(self):
        body=body_fixture(selector=0,inline=b'a\0xyz',tail=1)
        obj,c=self.construct(body,None)
        self.assertEqual(obj,body[:306])
        self.assertEqual((c.allocation_bytes,c.body_bytes_consumed,c.source_word_written,c.source_word_12b_after),
            (306,306,1,1))

    def test_cursor_wrap(self):
        for selector in (0,1):
            for offset in (0,50,0xfffffffe,0xffffffff):
                _,c=self.construct(body_fixture(selector=selector),b'\0' if selector else None,offset)
                self.assertEqual(c.payload_offset_after,(offset+c.body_bytes_consumed)&0xffffffff)

    def test_bad_resolved_text_atomic(self):
        raw=storage(body_fixture());arena=storage(bytes(40302));c=Constructed()
        for text,status in ((None,ARGUMENT),(b'',STRING),(b'abc',STRING),(b'a\0x',STRING),
                            (b'x'*40001+b'\0',COUNT)):
            C.memset(C.byref(c),0xa5,C.sizeof(c));before=bytes(c);old=bytes(arena)
            t=storage(text) if text is not None else None
            self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),t,len(text or b''),
                50,1,arena,len(arena),C.byref(c)),status)
            self.assertEqual((bytes(c),bytes(arena)),(before,old))

    def test_capacity_and_handle_atomic(self):
        raw=storage(body_fixture());txt=storage(b'abc\0');arena=storage(bytes(304));c=Constructed()
        for target,cap,handle,status in ((arena,len(arena),1,CAPACITY),(None,1,1,ARGUMENT),(arena,304,0,ARGUMENT)):
            C.memset(C.byref(c),0xa5,C.sizeof(c));before=bytes(c);old=bytes(arena)
            self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),txt,len(txt),50,handle,
                target,cap,C.byref(c)),status)
            self.assertEqual((bytes(c),bytes(arena)),(before,old))

    def test_pointer_null_wrap_overlap_atomic(self):
        raw=storage(body_fixture());txt=storage(b'abc\0');d=Decoded();c=Constructed()
        maxaddr=C.c_void_p(-1).value; bad=C.cast(maxaddr,C.POINTER(C.c_uint8))
        C.memset(C.byref(d),0xa5,C.sizeof(d));C.memset(C.byref(c),0xa5,C.sizeof(c))
        bd,bc=bytes(d),bytes(c)
        for p,n,status in ((None,301,ARGUMENT),(bad,301,BOUNDS),(raw,C.c_size_t(-1).value,BOUNDS)):
            self.assertEqual(self.lib.action_family_43_decode(p,n,C.byref(d)),status)
            self.assertEqual(self.lib.action_family_43_construct(p,n,txt,4,0,1,None,0,C.byref(c)),status)
        self.assertEqual(self.lib.action_family_43_decode(raw,len(raw),None),ARGUMENT)
        self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),txt,4,0,1,None,0,None),ARGUMENT)
        self.assertEqual(self.lib.action_family_43_decode(raw,len(raw),C.cast(bad,C.POINTER(Decoded))),BOUNDS)
        self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),bad,4,0,1,None,0,C.byref(c)),BOUNDS)
        self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),txt,4,0,1,bad,305,C.byref(c)),BOUNDS)
        self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),txt,4,0,1,None,0,
            C.cast(bad,C.POINTER(Constructed))),BOUNDS)
        self.assertEqual((bytes(d),bytes(c)),(bd,bc))
        block=storage(bytes([0xa5])*1024);before=bytes(block)
        p=C.cast(block,C.POINTER(C.c_uint8))
        self.assertEqual(self.lib.action_family_43_decode(p,301,C.cast(p,C.POINTER(Decoded))),OVERLAP)
        self.assertEqual(self.lib.action_family_43_construct(p,301,txt,4,0,1,None,0,
            C.cast(p,C.POINTER(Constructed))),OVERLAP)
        self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),txt,4,0,1,raw,len(raw),C.byref(c)),OVERLAP)
        self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),txt,4,0,1,txt,305,C.byref(c)),OVERLAP)
        self.assertEqual(self.lib.action_family_43_construct(raw,len(raw),txt,4,0,1,
            C.cast(C.byref(c),C.POINTER(C.c_uint8)),305,C.byref(c)),OVERLAP)
        self.assertEqual(bytes(block),before)
        self.assertEqual((bytes(d),bytes(c)),(bd,bc))

if __name__ == '__main__': unittest.main()
