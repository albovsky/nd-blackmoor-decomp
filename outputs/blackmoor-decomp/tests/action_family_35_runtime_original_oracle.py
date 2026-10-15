#!/usr/bin/env python3
"""RT-7: original 0x4bf9bb/0x4c0205/0x4c04e3/0x4c0774 versus lifecycle C.

Executes session effects (UI stores, event table, geometry, scene request,
completion) unhooked. Bink DLL calls are controlled codec boundaries, not
original codec/pacing/audio evidence. Surface allocation/free and file probing
are host boundaries inherited from S03-2. No game process/device is opened.
"""
import argparse
from collections import Counter
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct

import avf_player_original_oracle as avf
import bink_player_original_oracle as bink
from test_action_family_35_runtime import Native, body, load_driver

ROOT = Path(__file__).resolve().parents[3]
OUT = ROOT / 'work/analysis/slices/RT-7.oracle.json'
OBJ = avf.MOVIE_OBJ
ROW = avf.SLOT
PHASE = avf.SLOT_STATE + ROW * avf.SLOT_STRIDE


class Original(avf.PlayerOriginal):
    def __init__(self):
        super().__init__(avf.DEFAULT_EXE)
        from unicorn import UC_HOOK_CODE
        self.bink = self.alloc(128)
        self.width, self.height, self.frames = 4, 3, 3
        self.due, self.decode_calls, self.next_calls = 1, 0, 0
        self.hooks = Counter()
        self.dll = {}
        imports = bink.find_import_slots(self.pe)
        for i, (name, pop) in enumerate((('BinkOpen', 8), ('BinkClose', 4),
                ('BinkGetSummary', 8), ('BinkGoto', 12), ('BinkNextFrame', 4),
                ('BinkWait', 4), ('BinkDoFrame', 4), ('BinkCopyToBuffer', 28))):
            slot = bink.require_bink_import(imports, name + '@' + str(pop))
            stub = avf.dec.STUBS + 0x400 + i * 0x10
            self.w(slot, struct.pack('<I', stub))
            self.dll[stub] = (name, pop)
            self.uc.hook_add(UC_HOOK_CODE, self._codec, begin=stub, end=stub)

    def _helper(self, uc, address, size, user):
        if address not in (0x449D90, 0x4C2C3A, 0x4C2DFB, 0x4497A0,
                           0x449BFF, 0x449A94, 0x4C5377, self.delete_stub,
                           avf.AFX_END_THREAD):
            # All other inherited helper entries are passive observations:
            # execute the original session/UI/geometry/codec-wrapper code.
            return
        self.hooks[f'0x{address:x}:{avf.HELPERS.get(address, ("thread-delete",))[0]}'] += 1
        if address == 0x449D90:
            self._return(1, 0)
            return
        super()._helper(uc, address, size, user)

    def _host(self, uc, address, size, user):
        self.hooks[f'0x{address:x}:allocation/CRT/OS'] += 1
        super()._host(uc, address, size, user)

    def _codec(self, uc, address, size, user):
        name, pop = self.dll[address]
        self.hooks[f'codec:{name}@{pop}'] += 1
        value = 0
        if name == 'BinkOpen':
            self.w(self.bink, struct.pack('<4I', self.width, self.height, self.frames, 1))
            value = self.bink
        elif name == 'BinkGetSummary':
            self.w(self.arg(1), struct.pack('<31I', self.width, self.height,
                    0, 0, 0, 0, 0, 0, self.frames, *([0] * 22)))
        elif name == 'BinkGoto':
            self.w(self.bink + 12, struct.pack('<I', self.arg(1)))
        elif name == 'BinkNextFrame':
            self.w(self.bink + 12, struct.pack('<I', self.u32(self.bink + 12) + 1))
            self.next_calls += 1
        elif name == 'BinkWait':
            value = int(not self.due)
        elif name == 'BinkDoFrame':
            self.decode_calls += 1
        self._return(value, pop)

    def setup(self, data):
        self.w(OBJ, bytes(0x260))
        self.rec = self.alloc(len(data))
        self.w(self.rec, data)
        self.w(avf.SLOT_TABLE + ROW * avf.SLOT_STRIDE, struct.pack('<I', self.rec))
        self.w(PHASE, struct.pack('<I', 0))
        self.w(0x5BB5E4 + ROW * avf.SLOT_STRIDE, b'\1')  # subtype
        self.w(0x5BB625 + ROW * avf.SLOT_STRIDE, b'\0')  # completion
        self.w(0x585801, bytes(3000 * 4))
        for addr, value in ((0x5C39F9, 0), (0x5839A9, 7), (0x5BB1CA, 0),
                (0x5D19FB, 0), (0x5831C8, 0), (0x5831C6, 0),
                (0x5D1639, 11), (0x5D16CD, 12), (0x5D1683, 13),
                (0x583186, 10), (0x58318A, 20)):
            self.w(addr, struct.pack('<i', value))
        self.opened, self.closed = 0, 0

    def step(self, phase, view=0, due=1, frame=None, more=None):
        self.w(PHASE, struct.pack('<I', phase))
        self.w(avf.CURRENT_VIEW, struct.pack('<h', view))
        self.due = due
        self.run(0x4BF9BB, [ROW], OBJ)

    def poll(self):
        self.run(0x4C0C7D, [self.u32(OBJ + 0x1D6) + 0x3E], 0, worker=True)

    def ack(self):
        self.run(0x4C0D3F, [], OBJ)

    def snapshot(self):
        i32 = lambda a: struct.unpack('<i', self.r(a, 4))[0]
        i16 = lambda a: struct.unpack('<h', self.r(a, 2))[0]
        n = i16(self.rec + 59)
        views = self.rec + 63 + n * 6
        return dict(phase=i32(PHASE), substate=i32(OBJ+0x1da),
            presented=i16(OBJ+0x244), dirty=i32(OBJ+0x216), shown=i32(OBJ+0x240),
            flag21a=i32(OBJ+0x21a), matched=i32(OBJ+0x246),
            record=-1 if self.u32(OBJ+0x24a) == 0 else (self.u32(OBJ+0x24a)-views)//34,
            active=i32(0x5c39f9), modal=i32(0x5839a9), start=i32(0x5bb1ca),
            visible=i32(0x5d19fb), redraw=i32(0x5831c8), cursor=i16(0x5831c6),
            layers0=i32(0x5d1639), layers1=i32(0x5d16cd), layers2=i32(0x5d1683),
            saved_modal=i32(OBJ+0x20e), decoded=self.decode_calls,
            source_l=i32(OBJ+0x1de),source_t=i32(OBJ+0x1e2),
            source_r=i32(OBJ+0x1e6),source_b=i32(OBJ+0x1ea),
            dest_l=i32(OBJ+0x1ee),dest_t=i32(OBJ+0x1f2),
            dest_r=i32(OBJ+0x1f6),dest_b=i32(OBJ+0x1fa))


def compare_snapshot(o, n, operation):
    a, b = o.snapshot(), n.values()
    differences = {k: (v, b[k]) for k, v in a.items() if v != b[k]}
    assert not differences, (operation, differences)
    original_flags = struct.unpack('<3000i', o.r(0x585801, 3000*4))
    flag_differences = {i: (value, native) for i, value in enumerate(original_flags)
                        if value != (native := n.flag(i))}
    assert not flag_differences, (operation, 'event flags', flag_differences)
    return b


def compare(o, n, phase, view=0, due=1):
    frame = o.u32(o.bink + 12) - 1 if phase == 1 else 0
    o.step(phase, view, due)
    assert n.step(phase, view, due, frame, -1) == 0
    b = compare_snapshot(o, n, (phase, view, due))
    if phase == 2 and b['finish']:
        expected_transition = struct.unpack('<h', o.r(o.rec+0x25,2))[0] == 5
        assert b['transition'] == expected_transition
        assert o.r(0x5BB625 + ROW * avf.SLOT_STRIDE,1) == b'\1'
        if expected_transition:
            for key, addr, fmt in [('scene',0x5bb57b,'i'),('frame',0x5bb599,'h'),
                    ('vertical',0x5bb595,'h'),('word',0x5c39ff,'h'),
                    ('dword0',0x5bb59b,'i'),('dword1',0x5bb59f,'i'),
                    ('dword2',0x5bb5a3,'i'),('engine',0x583999,'i')]:
                assert struct.unpack('<'+fmt, o.r(addr,struct.calcsize(fmt)))[0] == b[key], key
    return b


def compare_avf(lib, hooks):
    """Exercise the lifecycle's actual AVF config and ready-gated finish.

    A five-frame file with bounds 1..3 distinguishes both configured bounds
    from physical endpoints. Poll/ack run original worker/render code, with
    only the inherited thread/surface/OS boundaries controlled. Every poll,
    ack and handler visit compares lifecycle/world state and all event flags.
    """
    from test_avf_decoder import build_avf
    media = build_avf(4, 3, [(0, bytes([i, 0] * 12), None) for i in range(5)])
    cases, steps = 0, 0
    for mode in (0, 1, 2):
        for direction in (1, 2):
            data = body(branch=0, mode=mode, direction=direction, first=1, last=3,
                        events=((1,1001,-3),(1,1001,7),(3,1002,9)), final=(1007,-9))
            o, n = Original(), Native(lib, data)
            try:
                o.setup(data)
                o.open_view(media)
                o.slot_fields = (OBJ + 0x182, OBJ + 0x186)
                storage = C.create_string_buffer(media)
                assert lib.rt35_avf(n.handle, storage, len(media)) == 0
                compare(o, n, 0)
                steps += 1
                # Ready starts at zero: phase 2 must leave the clip active,
                # with no final flag, scene request, close or completion.
                assert avf.i16(o, OBJ + 0x1D4) == 0
                v = compare(o, n, 2)
                assert (v['phase'], v['finish'], v['active'], v['closed'],
                        v['transition'], n.flag(1007)) == (2, 0, 1, 0, 0, 0)
                steps += 1
                frames = (1, 2, 3) if direction == 1 else (3, 2, 1)
                for i, frame in enumerate(frames):
                    o.now = (i + 1) * 1000
                    lib.rt35_now(n.handle, o.now)
                    o.poll()
                    assert lib.rt35_poll(n.handle) == 0
                    compare_snapshot(o, n, 'poll')
                    v = compare(o, n, 1)
                    assert v['presented'] == frame, (mode, direction, frame, v)
                    o.ack()
                    assert lib.rt35_ack(n.handle) == 0
                    compare_snapshot(o, n, 'ack')
                    steps += 3
                    if i == 0:
                        compare(o, n, 1, view=99)
                        compare(o, n, 1)  # back before the next decode/deadline
                        steps += 2
                o.now = 4000
                lib.rt35_now(n.handle, o.now)
                assert compare(o, n, 1)['phase'] == 2
                # The final render ack retains ready when done is set.
                assert avf.i16(o, OBJ + 0x1D4) == 1
                v = compare(o, n, 2)
                assert (v['phase'], v['finish'], v['active'], v['closed'],
                        n.flag(1007)) == (0, 1, 0, 1, -9)
                steps += 2
                cases += 1
            except Exception as e:
                raise RuntimeError(f'AVF mode={mode} direction={direction}') from e
            finally:
                hooks.update(o.hooks)
                n.close()
    return dict(cases=cases, steps=steps, bounds=[1, 3], physical_frames=5,
                modes=[0, 1, 2], directions=[1, 2], ready_gate=[0, 1], mismatches=0)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--native', type=Path)
    parser.add_argument('--report', type=Path, default=OUT)
    args = parser.parse_args()
    lib = load_driver(args.native)
    cases = [(f'synthetic-{mode}-{direction}-{views}-{effect}-{policy}',
              body(mode=mode, direction=direction, views=views, effect=effect,
                   policy=policy, events=((0,1001,1),(1,-1,7),(2,1001,-3)), final=(1007,-9)))
             for mode in (0,1,2) for direction in (1,2) for views in ((0,),(1,),(0,0))
             for effect in (5,6) for policy in (1,2)]
    cases.extend([
        ('same-frame-two-events', body(events=((0,1001,-3),(0,1002,7)))),
        ('same-frame-duplicate-id', body(events=((0,1001,-3),(0,1001,7)))),
    ])
    corpus = json.loads((ROOT/'work/analysis/slices/A-35.1.corpus.json').read_text())
    for r in corpus['records']:
        p = ROOT / f"work/analysis/hiff-resources/{r['resource_index']:04d}.bin"
        d = p.read_bytes()[r['raw_body_offset']:r['raw_body_offset']+r['raw_body_length']]
        assert hashlib.sha256(d).hexdigest() == r['body_sha256']
        cases.append((f"resource-{r['resource_index']}-row-{r['action_index']}",d))
    steps = 0
    hooks = Counter()
    for name, data in cases:
        o, n = Original(), Native(lib, data)
        try:
            o.setup(data)
            for phase, view, due in [(0,0,1), (1,0,1), (1,99,1), (1,0,0),
                                     (1,0,1), (1,0,1), (1,0,1), (2,0,1), (0,0,1)]:
                # Force finish in a synthetic fixture whose view never matches;
                # the completion branch itself has no view dependency.
                compare(o,n,phase,view,due)
                steps += 1
        except Exception as e:
            raise RuntimeError(name) from e
        finally:
            hooks.update(o.hooks)
            n.close()
    avf_result = compare_avf(lib, hooks)
    pe = avf.PEImage.parse_and_map(avf.DEFAULT_EXE)
    windows = {'controller':(0x4bf9bb,0x4c0205),'avf_update':(0x4c0205,0x4c04e3),
        'bink_update':(0x4c04e3,0x4c0774),'finish':(0x4c0774,0x4c08d3),
        'rect':(0x4c08d3,0x4c09fe),'triggers':(0x4c0ab1,0x4c0b97)}
    report = dict(cases=len(cases) + avf_result['cases'],
        steps=steps + avf_result['steps'], mismatches=0,
        bink=dict(cases=len(cases), steps=steps), avf=avf_result,
        original_exe_sha256=hashlib.sha256(pe.data).hexdigest(),
        code_sha256={k:hashlib.sha256(pe.image[a-pe.image_base:b-pe.image_base]).hexdigest()
                     for k,(a,b) in windows.items()},
        hooks=dict(sorted(hooks.items())),
        unverified=['Bink DLL pixels/audio/wait policy','real threading','fatal/debug paths'],
        session_effects_hooked=False)
    args.report.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report))


if __name__ == '__main__':
    main()
