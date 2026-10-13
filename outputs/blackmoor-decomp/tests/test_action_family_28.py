"""Bounded A-28 dispatcher and original RGB blend regressions."""
import ctypes as c
import math
from pathlib import Path
import struct
import unittest

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libactionfamily28.dylib"
OK, ARGUMENT, BODY, UNSUPPORTED, BOUNDS = range(5)
class Rect(c.Structure):
    _fields_ = [(x, c.c_int32) for x in ("left", "top", "right", "bottom")]
class Decoded(c.Structure):
    _fields_ = [("effect_type",c.c_uint8),("sequence_budget_ms",c.c_int16),
        ("pause_ms",c.c_int16),("rect",Rect),("source_bytes",c.c_uint8*21)]
class World(c.Structure):
    _fields_ = [("busy",c.c_uint8),("full_canvas",Rect),("current_rect",Rect),
        ("sequence_counter",c.c_uint32),("active_payload",c.c_uint8*21)]
class Input(c.Structure):
    _fields_ = [("type",c.c_uint8),("subtype",c.c_uint8),("eligible",c.c_uint8),
        ("completed_before",c.c_uint8),("phase_before",c.c_uint32),
        ("body",c.POINTER(c.c_uint8)),("body_length",c.c_size_t)]
class Result(c.Structure):
    _fields_ = [(x,c.c_uint8) for x in ("recognized","applied","job_started",
        "completion_valid","completed","reset_dependencies")]+[("phase",c.c_uint32),("world",World)]
def payload(kind=2,budget=500,pause=2000,rect=(0,0,0,0)):
    return struct.pack("<Bhh4i",kind,budget,pause,*rect)
def buffer(data): return (c.c_uint8*len(data)).from_buffer_copy(data)
def world_value(w):
    return (w.busy,tuple(getattr(w.full_canvas,x) for x in ("left","top","right","bottom")),
        tuple(getattr(w.current_rect,x) for x in ("left","top","right","bottom")),
        w.sequence_counter,bytes(w.active_payload))
def configure(lib):
    lib.action_family28_decode.argtypes=[c.POINTER(c.c_uint8),c.c_size_t,c.POINTER(Decoded),c.POINTER(c.c_size_t)]
    lib.action_family28_step.argtypes=[c.POINTER(Input),c.POINTER(World),c.POINTER(Result)]
    lib.action_family28_blend_table.argtypes=[c.c_double,c.POINTER(c.c_int32),c.c_size_t]
    lib.action_family28_blend_table_for_cw.argtypes=[c.c_double,c.c_uint16,c.POINTER(c.c_int32),c.c_size_t]
    lib.action_family28_blend_pixels.argtypes=[c.POINTER(c.c_uint8),c.POINTER(c.c_uint8),c.c_size_t,c.c_double,c.POINTER(c.c_uint8),c.POINTER(c.c_uint16),c.c_size_t]
    lib.action_family28_blend_pixels_for_cw.argtypes=[c.POINTER(c.c_uint8),c.POINTER(c.c_uint8),c.c_size_t,c.c_double,c.c_uint16,c.POINTER(c.c_uint8),c.POINTER(c.c_uint16),c.c_size_t]
    return lib
class Action28Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls): cls.lib=configure(c.CDLL(str(LIBRARY)))
    def world(self):
        w=World(0,Rect(10,20,629,384),Rect(100,200,300,400),123)
        w.active_payload[:]=b"z"*21
        return w
    def step(self,raw=None,phase=0,busy=0,subtype=1,eligible=1,completed=0):
        raw=payload() if raw is None else raw
        buf=buffer(raw); action=Input(0x28,subtype,eligible,completed,phase,buf,len(raw))
        w=self.world();w.busy=busy; before=bytes(w);out=Result()
        self.assertEqual(self.lib.action_family28_step(c.byref(action),c.byref(w),c.byref(out)),OK)
        self.assertEqual(bytes(w),before)
        return out
    def test_actual_body_and_dependency_boundary(self):
        raw=payload()+bytes.fromhex("0200e803010000000000000000000000")
        d=Decoded();n=c.c_size_t()
        self.assertEqual(self.lib.action_family28_decode(buffer(raw),len(raw),c.byref(d),c.byref(n)),OK)
        self.assertEqual((n.value,d.effect_type,d.sequence_budget_ms,d.pause_ms),(21,2,500,2000))
        self.assertEqual(bytes(d.source_bytes),raw[:21])
    def test_truncated_decode_is_atomic(self):
        for n in range(21):
            d=Decoded();c.memset(c.byref(d),0x5a,c.sizeof(d));before=bytes(d);consumed=c.c_size_t(777)
            self.assertEqual(self.lib.action_family28_decode(buffer(payload()),n,c.byref(d),c.byref(consumed)),BODY)
            self.assertEqual((bytes(d),consumed.value),(before,777))
    def test_full_canvas_when_either_dimension_degenerate(self):
        for rect in [(0,0,0,0),(2,3,2,9),(2,3,8,3)]:
            r=self.step(payload(rect=rect))
            self.assertEqual((r.applied,r.job_started,r.phase,r.world.busy,r.world.sequence_counter),(1,1,2,1,0))
            self.assertEqual(bytes(r.world.current_rect),bytes(r.world.full_canvas))
            self.assertEqual(bytes(r.world.active_payload),payload(rect=rect))
            self.assertEqual(r.completion_valid,0)
    def test_relative_rect_uses_current_left_top_and_global_right_bottom(self):
        r=self.step(payload(rect=(2,3,8,9)))
        self.assertEqual(tuple(getattr(r.world.current_rect,x) for x in ("left","top","right","bottom")),(102,203,18,29))
    def test_rect_additions_wrap_like_x86(self):
        raw=buffer(payload(rect=(0x7fffffff,0x7fffffff,0x7ffffffe,0x7ffffffd)))
        a=Input(0x28,1,1,0,0,raw,21);w=self.world();r=Result()
        self.assertEqual(self.lib.action_family28_step(c.byref(a),c.byref(w),c.byref(r)),OK)
        self.assertEqual((r.world.current_rect.left,r.world.current_rect.top,r.world.current_rect.right,r.world.current_rect.bottom),(-2147483549,-2147483449,-2147483640,-2147483631))
    def test_busy_false_gate_and_other_phases_preserve_state(self):
        for kw in [dict(busy=1),dict(eligible=0),dict(phase=1),dict(phase=3)]:
            r=self.step(**kw);w=self.world();w.busy=kw.get("busy",0)
            self.assertEqual(world_value(r.world),world_value(w));self.assertEqual(r.applied,0)
    def test_phase_two_subtype_completion_and_reset(self):
        # The dispatcher skips an action whose completion byte is already set;
        # these cases enter the original completion helper with it clear.
        for sub,completed,reset in [(1,1,0),(2,0,1),(0,0,0),(7,0,0)]:
            r=self.step(phase=2,subtype=sub,completed=0,busy=1)
            self.assertEqual((r.phase,r.completion_valid,r.completed,r.reset_dependencies,r.job_started),(0,1,completed,reset,0))
            self.assertEqual(r.world.busy,1)
    def test_phase_two_false_gate_and_already_completed_skip(self):
        for eligible,completed_before in [(0,0),(1,1)]:
            r=self.step(phase=2,busy=1,eligible=eligible,completed=completed_before)
            self.assertEqual((r.phase,r.applied,r.job_started,r.completion_valid),(2,0,0,0))
            expected=self.world();expected.busy=1
            self.assertEqual(world_value(r.world),world_value(expected))
    def test_invalid_start_and_wrong_type_are_atomic(self):
        short=buffer(payload()[:20]);a=Input(0x28,1,1,0,0,short,20)
        w=self.world();r=Result();c.memset(c.byref(r),0x55,c.sizeof(r));before=bytes(r)
        self.assertEqual(self.lib.action_family28_step(c.byref(a),c.byref(w),c.byref(r)),BODY)
        self.assertEqual(bytes(r),before)
        raw=buffer(payload());a=Input(0x29,1,1,0,0,raw,21)
        self.assertEqual(self.lib.action_family28_step(c.byref(a),c.byref(w),c.byref(r)),UNSUPPORTED)
        self.assertEqual(bytes(r),before)
    def test_phase_two_does_not_read_payload(self):
        a=Input(0x28,1,1,0,2,None,0);w=self.world();r=Result()
        self.assertEqual(self.lib.action_family28_step(c.byref(a),c.byref(w),c.byref(r)),OK)
        self.assertEqual((r.completed,r.phase),(1,0))
    def test_invalid_step_preserves_result(self):
        a=Input(0x28,1,1,0,0,None,21);w=self.world();r=Result();c.memset(c.byref(r),0x55,c.sizeof(r));before=bytes(r)
        self.assertEqual(self.lib.action_family28_step(c.byref(a),c.byref(w),c.byref(r)),ARGUMENT)
        self.assertEqual(bytes(r),before)
    def test_literal_rgb565_blends(self):
        shifts=buffer(bytes([11,5,0]));out=(c.c_uint16*1)()
        for first,second,weight,want in [(bytes([31,63,31]),bytes(3),.5,0x8410),(bytes([31,0,31]),bytes([0,63,0]),.25,0x45e8),(bytes([31,0,31]),bytes([0,63,0]),0,0x07e0),(bytes([31,0,31]),bytes([0,63,0]),1,0xf81f)]:
            self.assertEqual(self.lib.action_family28_blend_pixels(buffer(first),buffer(second),1,weight,shifts,out,1),OK)
            self.assertEqual(out[0],want)
    def test_invalid_blends_preserve_output(self):
        out=(c.c_uint16*1)(0x5555);shifts=buffer(bytes([11,5,0]));rgb=buffer(bytes([0,0,0]))
        for w in [math.nan,math.inf,-.1,1.1]:
            self.assertEqual(self.lib.action_family28_blend_pixels(rgb,rgb,1,w,shifts,out,1),ARGUMENT)
            self.assertEqual(out[0],0x5555)
        self.assertEqual(self.lib.action_family28_blend_pixels(buffer(bytes([64,0,0])),rgb,1,.5,shifts,out,1),BOUNDS)
        self.assertEqual(out[0],0x5555)
        self.assertEqual(self.lib.action_family28_blend_pixels(rgb,rgb,1,.5,shifts,out,0),BOUNDS)
        self.assertEqual(out[0],0x5555)
    def test_blend_rejects_wrapping_pointer_spans_before_dereference(self):
        shifts=buffer(bytes([11,5,0]));rgb=buffer(bytes([0,0,0]))
        out=(c.c_uint16*1)(0x5555)
        address_bits=c.sizeof(c.c_void_p)*8
        top=(1<<address_bits)-1
        invalid_source=c.cast(c.c_void_p(top-1),c.POINTER(c.c_uint8))
        self.assertEqual(self.lib.action_family28_blend_pixels(
            invalid_source,rgb,1,.5,shifts,out,1),BOUNDS)
        self.assertEqual(out[0],0x5555)
        invalid_output=c.cast(c.c_void_p(top-1),c.POINTER(c.c_uint16))
        self.assertEqual(self.lib.action_family28_blend_pixels(
            rgb,rgb,1,.5,shifts,invalid_output,1),BOUNDS)
        self.assertEqual(out[0],0x5555)
    def test_table_cap_and_rounding(self):
        table=(c.c_int32*4096)(*([777]*4096))
        self.assertEqual(self.lib.action_family28_blend_table(.5,table,4095),BOUNDS)
        self.assertEqual(table[0],777)
        self.assertEqual(self.lib.action_family28_blend_table(.5,table,4096),OK)
        self.assertEqual((table[31*64],table[63],table[31*64+63]),(16,32,47))
    def test_explicit_x87_precision_modes_and_unsupported_control_word(self):
        weight=math.nextafter(.5,0)
        double_precision=(c.c_int32*4096)()
        extended_precision=(c.c_int32*4096)()
        self.assertEqual(self.lib.action_family28_blend_table_for_cw(
            weight,0x027f,double_precision,4096),OK)
        self.assertEqual(self.lib.action_family28_blend_table_for_cw(
            weight,0x037f,extended_precision,4096),OK)
        self.assertEqual((double_precision[64],extended_precision[64]),(1,0))
        before=bytes(double_precision)
        self.assertEqual(self.lib.action_family28_blend_table_for_cw(
            weight,0x017f,double_precision,4096),UNSUPPORTED)
        self.assertEqual(bytes(double_precision),before)
if __name__=="__main__": unittest.main()
