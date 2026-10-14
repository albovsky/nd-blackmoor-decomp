#!/usr/bin/env python3
"""RT-9 Bink controller oracle, with ordered SDK and callback observations.

Execute with work/tools/oracle-python/bin/python. The RT-7 Original and Native
harnesses are reused. All controller, trigger, rectangle, advance, UI and finish
instructions execute from the pinned local GAME.EXE. Code/memory observations
added here are passive; only the inherited OS/allocation/surface/file boundaries
and successful Bink DLL exports are substituted. No codec/audio equivalence,
real Bink clock policy, game process, window or output device is involved.
"""
import argparse
from collections import Counter
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import time

import action_family_35_runtime_original_oracle as base
from test_action_family_35_runtime import Native, body, load_driver

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / 'outputs/blackmoor-decomp'
PRIVATE = ROOT / 'work/analysis/slices'
EXE_SHA256 = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
FLAGS, FLAG_COUNT = 0x585801, 3000
CHECKPOINT_FIELDS = ('substate', 'presented', 'dirty', 'shown', 'flag21a',
    'matched', 'record', 'active', 'modal', 'start', 'visible', 'redraw', 'cursor',
    'layers0', 'layers1', 'layers2', 'saved_modal', 'source_l', 'source_t',
    'source_r', 'source_b', 'dest_l', 'dest_t', 'dest_r', 'dest_b')
OBSERVATIONS = {0x4bee2c: 'frame_query', 0x4c0ab1: 'triggers',
    0x4c09fa: 'rect', 0x4bf10f: 'next', 0x4c0774: 'finish',
    0x4d36ed: 'ui', 0x4bf773: 'stop', 0x42ba3a: 'generic_finish'}
WINDOWS = {'controller': (0x4bf9bb, 0x4c0205),
    'bink_update': (0x4c04e3, 0x4c0774), 'finish': (0x4c0774, 0x4c08d3),
    'rect': (0x4c08d3, 0x4c09fe), 'triggers': (0x4c0ab1, 0x4c0b97),
    'stop': (0x4bf773, 0x4bf8a6), 'bink_wrappers': (0x4bedb5, 0x4bf3b8)}
HOOK_SEMANTICS = {
    '0x449d90:fopen_probe': 'Successful file-probe boundary, returns 1; no filesystem/device access.',
    '0x4c2c3a:surface_create2': 'Allocate synthetic surface descriptor and guarded local pixels via inherited host heap.',
    '0x4c2dfb:surface_free': 'Successful surface-release boundary; does not perform scene decisions.',
    'codec:BinkOpen@8': 'Return synthetic 4x3 Bink descriptor with selected physical frame count and initial frame 1.',
    'codec:BinkClose@4': 'Successful SDK close; original CBink reset and handle clear execute unmodified.',
    'codec:BinkGetSummary@8': 'Fill controlled width/height/frame-count summary.',
    'codec:BinkGoto@12': 'Store requested one-based frame; assert flags 0 and physical bounds.',
    'codec:BinkNextFrame@4': 'Increment one-based current frame; original wrapper decides whether call is allowed.',
    'codec:BinkWait@4': 'Return inverse of scripted due input; original wrapper interprets result.',
    'codec:BinkDoFrame@4': 'Successful codec decode boundary only; no pixels/audio synthesized.',
    'codec:BinkCopyToBuffer@28': 'Successful codec copy boundary only; assert exact original handle/surface/pitch/height/x/y/flags arguments.',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def records(data):
    count = struct.unpack_from('<h', data, 59)[0]
    events = [struct.unpack_from('<3h', data, 61 + 6 * i) for i in range(count)]
    start = 61 + 6 * count
    views = [struct.unpack_from('<h', data, start + 2 + 34 * i)[0]
             for i in range(struct.unpack_from('<h', data, start)[0])]
    return events, views


class Original(base.Original):
    def __init__(self, frames):
        self.ordered, self.checkpoints, self.sdk = [], [], []
        super().__init__()
        self.frames = frames
        from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_WRITE
        for address in OBSERVATIONS:
            self.uc.hook_add(UC_HOOK_CODE, self._observe, begin=address, end=address)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self._write,
                         begin=FLAGS, end=FLAGS + FLAG_COUNT * 4 - 1)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self._phase_write,
                         begin=base.PHASE, end=base.PHASE + 3)

    def checkpoint(self, kind):
        state = self.snapshot()
        self.checkpoints.append((kind, tuple(state[k] for k in CHECKPOINT_FIELDS),
                                 sha(bytes(self.r(FLAGS, FLAG_COUNT * 4)))))

    def _observe(self, uc, address, size, user):
        kind = OBSERVATIONS[address]
        self.ordered.append((kind,))
        if kind in ('rect', 'next'):
            self.checkpoint(kind)

    def _helper(self, uc, address, size, user):
        if address == 0x4c2dfb:
            self.ordered.append(('surface_free',))
        super()._helper(uc, address, size, user)

    def _write(self, uc, access, address, size, value, user):
        assert size == 4 and (address - FLAGS) % 4 == 0
        signed = C.c_int32(value).value
        self.ordered.append(('event', (address - FLAGS) // 4, signed))

    def _phase_write(self, uc, access, address, size, value, user):
        assert address == base.PHASE and size == 4
        # Generic completion also writes phase 0; only tick completion is part
        # of the per-frame expected trace below.
        if 0x4c04e3 <= self.reg('EIP') < 0x4c0774:
            self.ordered.append(('phase', value))

    def _codec(self, uc, address, size, user):
        name, pop = self.dll[address]
        arguments = tuple(self.arg(i) for i in range(pop // 4))
        self.sdk.append((name, arguments))
        self.ordered.append((name,))
        if name in ('BinkWait', 'BinkDoFrame', 'BinkClose'):
            self.checkpoint({'BinkWait': 'due', 'BinkDoFrame': 'decode',
                             'BinkClose': 'close'}[name])
        if name == 'BinkGoto':
            assert arguments[0] == self.bink and arguments[2] == 0
            assert 1 <= arguments[1] <= self.frames
        elif name in ('BinkWait', 'BinkDoFrame', 'BinkNextFrame', 'BinkClose'):
            assert arguments == (self.bink,)
        elif name == 'BinkCopyToBuffer':
            surface = self.u32(base.OBJ + 0x222)
            assert arguments == (self.bink, self.u32(surface),
                struct.unpack('<h', self.r(surface + 0x2f, 2))[0],
                struct.unpack('<h', self.r(surface + 0x2d, 2))[0], 0, 0, 0)
        super()._codec(uc, address, size, user)

    def visit(self, phase, view, due):
        self.ordered, self.checkpoints, self.sdk = [], [], []
        self.step(phase, view, due)


class Rect(C.Structure):
    _fields_ = [(k, C.c_int32) for k in ('left', 'top', 'right', 'bottom')]


class Snapshot(C.Structure):
    _fields_ = [(k, C.c_int32) for k in ('substate', 'presented', 'dirty',
        'shown', 'flag21a', 'matched', 'record', 'saved_modal')]
    _fields_ += [('source', Rect), ('destination', Rect)]


class World(C.Structure):
    _fields_ = [('event_flags', C.POINTER(C.c_int32)), ('event_flag_count', C.c_size_t)]
    _fields_ += [(k, C.c_int32) for k in ('active', 'modal', 'start', 'visible',
                                       'redraw', 'cursor')]
    _fields_ += [('layers', C.c_int32 * 3)]


class Input(C.Structure):
    _fields_ = [('selector', C.c_int16), ('origin_x', C.c_int32), ('origin_y', C.c_int32)]


class Result(C.Structure):
    _fields_ = [('phase', C.c_uint32), ('finish', C.c_int32), ('transition', C.c_int32)]
    _fields_ += [(k, C.c_int16) for k in ('scene', 'frame', 'vertical', 'word')]
    _fields_ += [('dwords', C.c_int32 * 3), ('engine', C.c_int32)]


Open = C.CFUNCTYPE(C.c_int, C.c_void_p, C.c_void_p, C.c_void_p)
Close = C.CFUNCTYPE(None, C.c_void_p)
Due = C.CFUNCTYPE(C.c_int, C.c_void_p, C.POINTER(C.c_int))
Decode = C.CFUNCTYPE(C.c_int, C.c_void_p, C.POINTER(C.c_int16))
Next = C.CFUNCTYPE(C.c_int, C.c_void_p, C.POINTER(C.c_int))
Rectangle = C.CFUNCTYPE(C.c_int, C.c_void_p, C.POINTER(Rect), C.POINTER(Rect))


class Host(C.Structure):
    _fields_ = [('context', C.c_void_p), ('open', Open), ('close', Close),
        ('bink_due', Due), ('bink_decode', Decode), ('bink_next', Next),
        ('rect', Rectangle), ('avf', C.c_void_p * 5)]


class CallbackNative:
    """Same production kernel with Python host callbacks observing call time.

    The existing Native fixture remains an additional state comparison for its
    three-frame descriptor. This observer allows one-frame and real 504-frame
    descriptors without altering that fixture or production source.
    """
    def __init__(self, lib, data, frames):
        self.lib, self.data, self.frames = lib, data, frames
        self.flags = (C.c_int32 * FLAG_COUNT)()
        self.world = World(self.flags, FLAG_COUNT, 0, 7, 0, 0, 0, 0,
                           (C.c_int32 * 3)(11, 12, 13))
        self.result = Result()
        self.checkpoints = []
        self.current = frames - 1 if struct.unpack_from('<h', data, 0x29)[0] == 2 else 0
        self.direction = -1 if struct.unpack_from('<h', data, 0x29)[0] == 2 else 1
        self.due = 1
        self.handle = None
        self.opened = self.closed = self.decoded = self.rects = self.next_calls = 0
        self.callbacks = (Open(self._open), Close(self._close), Due(self._due),
                          Decode(self._decode), Next(self._next), Rectangle(self._rect))
        self.host = Host(None, *self.callbacks)
        lib.action35_runtime_create.argtypes = [C.POINTER(World), C.POINTER(Host)]
        lib.action35_runtime_create.restype = C.c_void_p
        lib.action35_runtime_step.argtypes = [C.c_void_p, C.c_void_p, C.c_size_t,
                                             C.c_uint32, C.POINTER(Input), C.POINTER(Result)]
        lib.action35_runtime_snapshot.argtypes = [C.c_void_p, C.POINTER(Snapshot)]
        lib.action35_runtime_destroy.argtypes = [C.c_void_p]
        self.handle = lib.action35_runtime_create(C.byref(self.world), C.byref(self.host))
        assert self.handle
        self.storage = C.create_string_buffer(data)

    def checkpoint(self, kind):
        state = self.values()
        self.checkpoints.append((kind, tuple(state[k] for k in CHECKPOINT_FIELDS), sha(bytes(self.flags))))

    def _open(self, context, decoded, stream):
        self.opened += 1
        self.current = self.frames - 1 if self.direction == -1 else 0
        return 0

    def _close(self, context):
        self.checkpoint('close')
        self.closed += 1

    def _due(self, context, due):
        self.checkpoint('due')
        due[0] = self.due
        return 0

    def _decode(self, context, frame):
        self.checkpoint('decode')
        self.decoded += 1
        frame[0] = self.current
        return 0

    def _next(self, context, more):
        self.checkpoint('next')
        self.next_calls += 1
        more[0] = 0 <= self.current + self.direction < self.frames
        if more[0]:
            self.current += self.direction
        return 0

    def _rect(self, context, source, destination):
        self.checkpoint('rect')
        self.rects += 1
        return 0

    def step(self, phase, view, due):
        self.checkpoints = []
        self.due = due
        return self.lib.action35_runtime_step(self.handle, self.storage, len(self.data),
            phase, C.byref(Input(view, 10, 20)), C.byref(self.result))

    def values(self):
        s = Snapshot()
        assert self.lib.action35_runtime_snapshot(self.handle, C.byref(s)) == 0
        v = {k: getattr(s, k) for k, _ in s._fields_ if k not in ('source', 'destination')}
        v.update({k: getattr(self.world, k) for k, _ in self.world._fields_
                  if k not in ('event_flags', 'event_flag_count', 'layers')})
        v.update({f'layers{i}': x for i, x in enumerate(self.world.layers)})
        v.update({k: getattr(self.result, k) for k, _ in self.result._fields_ if k != 'dwords'})
        v.update({f'dword{i}': x for i, x in enumerate(self.result.dwords)})
        for prefix, r in (('source', s.source), ('dest', s.destination)):
            v.update({f'{prefix}_{short}': getattr(r, long)
                      for short, long in zip('ltrb', ('left', 'top', 'right', 'bottom'))})
        v.update(opened=self.opened, closed=self.closed, rects=self.rects,
                 decoded=self.decoded, next_calls=self.next_calls, status=0)
        return v

    def close(self):
        if self.handle:
            self.lib.action35_runtime_destroy(self.handle)
            self.handle = None


def expected_tick(data, frame, frames, view, due, substate):
    events, views = records(data)
    direction = -1 if struct.unpack_from('<h', data, 0x29)[0] == 2 else 1
    trace = []
    for selector in views:
        if selector != view or substate not in (0, 4):
            continue
        trace.append(('BinkWait',))
        if not due:
            continue
        trace.extend((name,) for name in ('BinkDoFrame', 'BinkCopyToBuffer', 'frame_query', 'triggers'))
        trace.extend(('event', flag, value) for when, flag, value in events if when == frame and flag != -1)
        trace.extend([('rect',), ('next',)])
        if 0 <= frame + direction < frames:
            trace.append(('BinkGoto' if direction == -1 else 'BinkNextFrame',))
            frame += direction
            substate = 4
        else:
            trace.append(('phase', 2))
    return trace


def compare(o, n, legacy, data, phase, view, due):
    previous = o.snapshot()
    frame = o.u32(o.bink + 12) - 1 if phase == 1 else 0
    o.visit(phase, view, due)
    assert n.step(phase, view, due) == 0
    a, b = o.snapshot(), n.values()
    assert not {k: (v, b[k]) for k, v in a.items() if v != b[k]}, (phase, view, due, a, b)
    assert bytes(o.r(FLAGS, FLAG_COUNT * 4)) == bytes(n.flags), 'event table'
    if legacy is not None:
        assert legacy.step(phase, view, due, frame, -1) == 0
        c = legacy.values()
        assert not {k: (v, c[k]) for k, v in b.items() if v != c[k]}, ('legacy fixture', b, c)
        assert bytes(n.flags) == struct.pack('<3000i', *(legacy.flag(i) for i in range(FLAG_COUNT)))
    if phase == 1:
        assert o.ordered == expected_tick(data, frame, o.frames, view, due, previous['substate']), ('SDK/event order', o.ordered)
        assert o.checkpoints == n.checkpoints, ('callback order/state', o.checkpoints, n.checkpoints)
    elif phase == 2:
        event, value = struct.unpack_from('<2h', data, 0x37)
        expected = [('finish',)] + ([('event', event, value)] if event != -1 else [])
        expected += [('ui',), ('stop',), ('surface_free',), ('BinkClose',), ('generic_finish',)]
        assert o.ordered == expected, ('completion order', o.ordered)
        assert o.checkpoints == n.checkpoints, ('completion callback state', o.checkpoints, n.checkpoints)
        assert b['finish'] == 1 and o.r(0x5bb625 + base.ROW * base.avf.SLOT_STRIDE, 1) == b'\1'
        transition = struct.unpack_from('<h', data, 0x25)[0] == 5
        assert b['transition'] == transition
        if transition:
            for key, addr, fmt in [('scene', 0x5bb57b, 'i'), ('frame', 0x5bb599, 'h'),
                    ('vertical', 0x5bb595, 'h'), ('word', 0x5c39ff, 'h'),
                    ('dword0', 0x5bb59b, 'i'), ('dword1', 0x5bb59f, 'i'),
                    ('dword2', 0x5bb5a3, 'i'), ('engine', 0x583999, 'i')]:
                assert struct.unpack('<' + fmt, o.r(addr, struct.calcsize(fmt)))[0] == b[key], key
    else:
        assert [name for name, _ in o.sdk] == ['BinkOpen', 'BinkGetSummary', 'BinkGoto']
        assert o.sdk[0][1][1] == 0, 'BinkOpen flags'
        assert o.sdk[-1][1] == (o.bink, o.frames if n.direction == -1 else 1, 0)
    return b


def cases():
    duplicate_events = ((0, 1001, 1), (0, 1002, -3), (0, 1001, 8),
        (0, -1, 91), (1, 1003, -7), (2, 1001, 22), (2, 1002, 13),
        (2, 1001, -19), (-1, 1004, 77), (300, 1004, 99))
    result = []
    for mode in (0, 1, 2):
        for direction in (1, 2):
            for views in ((0,), (0, 0), (1, 0, 1, 0)):
                for frames in (1, 3):
                    name = f'synthetic-mode{mode}-direction{direction}-views{views}-frames{frames}'
                    data = body(mode=mode, direction=direction, views=views,
                        events=duplicate_events, final=(-1 if mode == 1 else 1001, -9),
                        effect=5 if mode != 1 else 6, policy=1 if mode == 0 else 2)
                    result.append((name, data, frames, 0))
    # The actual S4700 body has nine events and a frame-503 event. Use its
    # real physical frame count while keeping only SDK/surface data synthetic.
    corpus = json.loads((PRIVATE / 'A-35.1.corpus.json').read_text())
    row = next(r for r in corpus['records'] if r['resource_index'] == 2648 and r['action_index'] == 3)
    resource = ROOT / f"work/analysis/hiff-resources/{row['resource_index']:04d}.bin"
    data = resource.read_bytes()[row['raw_body_offset']:row['raw_body_offset'] + row['raw_body_length']]
    assert sha(data) == row['body_sha256']
    assert len(records(data)[0]) == 9
    result.append(('S4700-row3-physical-504', data, 504, records(data)[1][0]))
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--native', type=Path)
    parser.add_argument('--report', type=Path, default=PRIVATE / 'RT-9.bink-original-oracle.json')
    args = parser.parse_args()
    started = time.monotonic()
    lib = load_driver(args.native)
    native = args.native or PROJECT / 'build/libactionfamily35_runtime_test.dylib'
    pe = base.avf.PEImage.parse_and_map(base.avf.DEFAULT_EXE)
    assert sha(pe.data) == EXE_SHA256
    results, hooks, sdk_counts, observation_counts = [], Counter(), Counter(), Counter()
    total_visits = 0
    for name, data, frames, view in cases():
        o, n = Original(frames), CallbackNative(lib, data, frames)
        legacy = Native(lib, data) if frames == 3 else None
        visits, trace_digest = 0, hashlib.sha256()
        schedule = [(0, view, 1), (1, view, 0), (1, view, 1)]
        try:
            o.setup(data)
            # The two phase-1 visits after the first frame deliberately exercise
            # hidden-after-presentation and not-due-after-presentation states.
            for phase, selected, due in schedule:
                compare(o, n, legacy, data, phase, selected, due)
                visits += 1
                trace_digest.update(repr((o.ordered, o.checkpoints)).encode())
                sdk_counts.update(name for name, _ in o.sdk)
                observation_counts.update(x[0] for x in o.ordered)
            if o.snapshot()['phase'] == 1:
                for selected, due in ((99, 1), (view, 0)):
                    compare(o, n, legacy, data, 1, selected, due)
                    visits += 1
                    trace_digest.update(repr((o.ordered, o.checkpoints)).encode())
                    sdk_counts.update(name for name, _ in o.sdk)
                    observation_counts.update(x[0] for x in o.ordered)
            while o.snapshot()['phase'] == 1:
                compare(o, n, legacy, data, 1, view, 1)
                visits += 1
                assert visits < frames + 10, 'no natural completion'
                trace_digest.update(repr((o.ordered, o.checkpoints)).encode())
                sdk_counts.update(name for name, _ in o.sdk)
                observation_counts.update(x[0] for x in o.ordered)
            assert o.snapshot()['phase'] == 2
            compare(o, n, legacy, data, 2, view, 1)
            visits += 1
            trace_digest.update(repr((o.ordered, o.checkpoints)).encode())
            sdk_counts.update(name for name, _ in o.sdk)
            observation_counts.update(x[0] for x in o.ordered)
            results.append(dict(name=name, body_sha256=sha(data), frames=frames,
                visits=visits, decoded=n.decoded, next_callbacks=n.next_calls,
                rectangles=n.rects, trace_sha256=trace_digest.hexdigest(), mismatches=0))
        except Exception as error:
            raise RuntimeError(name) from error
        finally:
            hooks.update(o.hooks)
            n.close()
            if legacy is not None:
                legacy.close()
        total_visits += visits
    report = dict(status='pass', cases=len(results), visits=total_visits, mismatches=0,
        original_exe_sha256=EXE_SHA256, native_sha256=sha(native.read_bytes()),
        oracle_sha256=sha(Path(__file__).read_bytes()),
        source_sha256=sha((PROJECT / 'src/action_family_35_runtime.c').read_bytes()),
        code_sha256={k: sha(pe.image[a-pe.image_base:b-pe.image_base]) for k, (a, b) in WINDOWS.items()},
        code_windows={k: dict(start=hex(a), end_exclusive=hex(b),
            sha256=sha(pe.image[a-pe.image_base:b-pe.image_base])) for k, (a, b) in WINDOWS.items()},
        executed_replacement_hooks=dict(sorted(hooks.items())),
        hook_semantics={k: HOOK_SEMANTICS[k] for k in sorted(hooks)},
        inherited_harness_sha256=sha(Path(base.__file__).read_bytes()),
        inherited_avf_harness_sha256=sha(Path(base.avf.__file__).read_bytes()),
        sdk_calls=dict(sorted(sdk_counts.items())), observations=dict(sorted(observation_counts.items())),
        passive_code_observations={hex(k): v for k, v in OBSERVATIONS.items()},
        passive_memory_observations=['all 3000 event-table stores', 'row phase stores in Bink update'],
        native_observations='production-kernel host callback order and state; legacy RT-7 Native fixture additionally checked for all three-frame cases',
        session_effects_hooked=False,
        unverified=['proprietary Bink decoding/pixels/audio and BinkWait clock policy',
            'original OS/device/surface allocation behavior', 'real thread scheduling',
            'nonzero debug/fatal/error paths', 'original phase-0 callback-time global order (native transactional allocation)',
            'original event writes within one trigger call are observed in body order; native compared at callback checkpoints and final state'],
        rows=results, seconds=round(time.monotonic()-started, 3))
    args.report.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: report[k] for k in ('status', 'cases', 'visits', 'mismatches',
                                           'sdk_calls', 'observations', 'seconds')}))


if __name__ == '__main__':
    main()
