#!/usr/bin/env python3
"""RT-43: original-x86 oracle for the inventory examine step 0x4ea269 (src/inventory_examine_runtime.c).

The unmodified original runs under Unicorn on the RT-22 inventory-view machine (tests/inventory_view_runtime_original_oracle.py)
from two entry points; nothing the original decides is replaced:

  K. click    0x4e8dc8 (gate) -> 0x4e8e78: the read/examine condition (kind 3, text word not 0/0x270f, aux 0x583ced == 0) runs
              the REAL examine step 0x4ea269(hot, 1, 1) instead of stopping at 0x4e8f0e as the RT-22 oracle does.
  E. examine  0x4ea269(item, take, sound) entered directly (this = the view): every combination of the take word and the
              sound dword, as the second caller 0x4ead4d (action handler 0x4eaca8, sound 0) makes them.

The real add 0x4e9e84 (selector put back), saver 0x4eb70f, remove 0x4ea06c, rebuild 0x4e812f, UI animation 0x4e0559 and close
0x4e7d04 run for real. Host-boundary replacements (the same as RT-22): sound manager request 0x4fb2e3 (the caller's return
address says whether it is the add step's, the view's or the examine step's request), view teardown 0x4edb97, panel teardown
0x4e1d34, screen close notification 0x4d36ed, frame/tab controls.

Compared against the native kernel: one merged ORDERED event log (examine entry, put-back add with its sound/rebuild/UI,
saver, selector store, remove, sound request, scene words stored, close entry and teardown), the final inventory cells, the
view state, the 22-byte saved-scene record 0x5c3a1b, byte-for-byte windows of every global the step can write (selector
0x583f1d, the three records 0x5c3a05..0x5c3a5f, the scene request words 0x5bb57b.., 0x5c39ff, mode 0x583999) seeded with
random bytes, the 0x4e8e78 return value, write footprint, callee-saved registers and stack balance (ret 0xc).
"""
import argparse
import ctypes as c
import json
from pathlib import Path
import random
import struct
import time

from cif_original_oracle import PEImage
import action_family_78_runtime_original_oracle as o78
import inventory_view_runtime_original_oracle as rt
import test_action_family_78_runtime as t78
import test_inventory_view_runtime as iv
import test_inventory_examine_runtime as ex
from inventory_view_runtime_original_oracle import (CAPACITY, OracleError, VIEW, VIEW_BYTES, HELD, COUNT_WORD, LIST,
                                                    PRESENCE, KIND0, KIND_STRIDE, s16, s32, sha)

ROOT = rt.ROOT
REPORT = ROOT / 'work/analysis/slices/RT-43.oracle.json'
EXE_HASH = rt.EXE_HASH
CODE_WINDOWS = [
    (0x4ea269, 0x4ea361, 'examine 0x4ea269', '7058fd7b41efbdf39670dbb3e695c06a0aefc540390f13aa95bc12fa74d93e7a'),
    (0x4eb70f, 0x4eb77d, 'saver 0x4eb70f', 'd86463bff0ef936e8280f6fe2915253b072e6b3f063733a8849a233d6c4e24f5'),
] + rt.CODE_WINDOWS

SELECTOR = 0x583f1d
RECORDS = 0x5c3a05                  # three 22-byte records: 0x5c3a05, 0x5c3a1b, 0x5c3a31
RECORD2 = 0x5c3a1b
RECORD_BYTES = 0x16
RECORD_WINDOW = (RECORDS, 0x5c3a60 - RECORDS)
SCENE_WINDOW = (0x5bb500, 0x5bb5b3 - 0x5bb500)     # 0x5bb500..0x5bb5b2: the saver sources and the request dwords
START_WINDOW = (0x5c39ff - 8, 24)                  # word 0x5c39ff
MODE_WINDOW = (0x583999 - 8, 24)                   # dword 0x583999
SELECTOR_WINDOW = (SELECTOR - 8, 24)
WINDOWS = (RECORD_WINDOW, SCENE_WINDOW, START_WINDOW, MODE_WINDOW, SELECTOR_WINDOW)
W782 = 4                                           # word at item record +0x34 = view +0x782
EXTRA = ((SELECTOR, 2), (RECORD2, RECORD_BYTES), (0x5bb57b, 4), (0x5bb599, 2), (0x5bb595, 2), (0x5c39ff, 2),
         (0x5bb59b, 4), (0x5bb59f, 4), (0x5bb5a3, 4), (0x583999, 4))
rt.EXTRA_FOOTPRINT = tuple(rt.EXTRA_FOOTPRINT) + EXTRA
rt.VIEW_WRITE_RANGES['examine'] = rt.VIEW_WRITE_RANGES['click']
S782 = {'seed': 0}


def u32(value):
    return value & 0xffffffff


class ExamineOriginal(rt.ViewOriginal):
    """The RT-22 machine with the examine entry points, the saved-scene record and the scene globals."""

    def __init__(self, pe):
        super().__init__(pe)
        from unicorn import UC_HOOK_CODE
        for address in (0x4ea269, 0x4ea2c3, 0x4ea353, 0x4eb70f, 0x4eb777, 0x4e8f0e):
            self.uc.hook_add(UC_HOOK_CODE, self.on_examine_code, begin=address, end=address)
        # the RT-22 hook for 0x4e8f0e stops the run: removed in favour of the observation below
        self.examine_entered = False

    def on_code(self, uc, address, size, user):
        if address == 0x4e8f0e:
            return          # on_examine_code observes it; the read branch runs for real
        if address == 0x4fb2e3:
            esp = uc.reg_read(self.regs['ESP'])
            ret, slot = struct.unpack('<II', self.read(esp, 8))
            if 0x4ea269 <= ret < 0x4ea361:
                self.count('REPLACE 0x4fb2e3 sound manager request from the examine step (host boundary)')
                slot &= 0xffff
                self.events += [('examine_sound', slot), ('view_sound_call', slot)]
                self.replace(uc, esp, 0, 1)
                return
        super().on_code(uc, address, size, user)

    def on_examine_code(self, uc, address, size, user):
        esp = uc.reg_read(self.regs['ESP'])
        if address == 0x4e8f0e:
            self.count('observe 0x4e8f0e read/examine branch taken (real code runs)')
        elif address == 0x4ea269:
            self.count('observe 0x4ea269 examine entry (real code runs)')
            self.examine_entered = True
            self.events.append(('examine', s16(struct.unpack('<I', self.read(esp + 4, 4))[0])))
        elif address == 0x4eb70f:
            self.count('observe 0x4eb70f saver entry (real code runs)')
        elif address == 0x4eb777:
            self.events.append(('examine_save', self.s16(RECORD2)))
        elif address == 0x4ea2c3:
            self.events.append(('examine_selector', self.s16(SELECTOR)))
        elif address == 0x4ea353:
            self.events.append(('examine_scene', s32(struct.unpack('<I', self.read(0x5bb57b, 4))[0])))

    def prepare(self, case):
        super().prepare(case)
        uc = self.uc
        rng = random.Random(case['seed'] ^ 0xe8a)
        for start, length in WINDOWS:
            uc.mem_write(start, bytes(rng.randrange(256) for _ in range(length)))
        for item in range(CAPACITY):
            uc.mem_write(VIEW + KIND0 + item * KIND_STRIDE + W782, struct.pack('<h', case['w782'][item]))
        uc.mem_write(SELECTOR, struct.pack('<h', case['selector']))
        self.view_before = self.read(VIEW, VIEW_BYTES)
        self.scene_before = {a: self.read(a, n) for a, n in WINDOWS}
        self.examine_entered = False
        return None

    def invoke_examine(self, case):
        uc, r = self.uc, self.regs
        for name, value in self.initial.items():
            uc.reg_write(r[name], value)
        uc.reg_write(r['ECX'], VIEW)
        esp0 = rt.FRAME - 0x400
        uc.mem_write(esp0, struct.pack('<III', u32((case['item_hi'] << 16) | (case['item'] & 0xffff)), u32(case['take']),
                                       u32(case['sound'])))      # the step reads words; the upper halves are noise
        uc.reg_write(r['ESP'], esp0 - 4)
        uc.mem_write(esp0 - 4, struct.pack('<I', rt.SENTINEL))
        uc.reg_write(r['EFLAGS'], 0x202)
        self.writes.clear()
        uc.emu_start(0x4ea269, rt.SENTINEL, count=3000000)
        if uc.reg_read(r['EIP']) != rt.SENTINEL:
            raise OracleError('original did not return from 0x4ea269')
        if uc.reg_read(r['ESP']) != esp0 + 12:
            raise OracleError('stack not balanced after ret 0xc')
        for name in ('EBX', 'ESI', 'EDI', 'EBP'):
            if uc.reg_read(r[name]) != self.initial[name]:
                raise OracleError(f'callee-saved {name} changed')
        return uc.reg_read(r['EAX']) & 0xffffffff

    def run(self, machine, case, strict=True):
        self.prepare(case)
        if machine == 'examine':
            eax = self.invoke_examine(case)
            footprint = self.footprint_ok('examine', strict)
        else:
            eax = self.invoke(0x4e8dc8, strict)
            footprint = self.footprint_ok('click', strict)
        ui_calls = [e for e in self.events if e[0] == 'ui_call']
        expected_ui = []
        for _ in ui_calls:
            expected_ui += [(o78.UI_CELLS[0], 4, 1), (o78.UI_CELLS[1], 4, 1)]
        if strict and self.ui_writes != expected_ui:
            raise OracleError(('UI animation stores differ from the modeled request', self.ui_writes))
        if strict and any(e[1:] != (1, 1, 0) for e in ui_calls):
            raise OracleError(('UI animation arguments differ from (1, 1, 0)', ui_calls))
        after = {a: self.read(a, n) for a, n in WINDOWS}
        return dict(events=list(self.events), model=self.model_snapshot(), view=self.view_state(), eax=eax,
                    entered=set(self.entered), stop=self.stop, footprint=footprint, writes=list(self.writes),
                    reads_beyond=list(self.reads_beyond), examined=self.examine_entered,
                    before=dict(self.scene_before), after=after)


# ------------------------------------------------------------------ native side
Current, Slot, Request, ExamineResult = ex.Current, ex.Slot, ex.Request, ex.ExamineResult
LoadFn, SceneFn, ExamineHost, Examine = ex.LoadFn, ex.SceneFn, ex.ExamineHost, ex.Examine
bind = ex.bind


def record_bytes(slot):
    return struct.pack('<hhhhh', slot.marker_5c3a1b, slot.scene_5c3a1d, slot.word_5c3a1f, slot.word_5c3a21,
                       slot.word_5c3a23) + struct.pack('<iii', slot.dword_5c3a25, slot.dword_5c3a29,
                                                       slot.dword_5c3a2d)


def slot_from_bytes(data):
    marker, scene, w1f, w21, w23 = struct.unpack_from('<hhhhh', data, 0)
    d25, d29, d2d = struct.unpack_from('<iii', data, 10)
    return Slot(marker, scene, w1f, w21, w23, d25, d29, d2d)


def native_examine_world(lib, case, before):
    """The RT-22 native world plus the examine configuration seeded from the original's memory image."""
    fx = rt.native_world(lib, case)
    fx.examine_log = []
    fx.world.model.view.mode = case['mode']          # the direct entry passes the live view fields, as the click does
    fx.world.model.view.slot_flag = case['slot_flag'] & 0xff
    rec = before[RECORD_WINDOW[0]]
    fx.slot = slot_from_bytes(rec[RECORD2 - RECORD_WINDOW[0]:RECORD2 - RECORD_WINDOW[0] + RECORD_BYTES])
    scene = before[SCENE_WINDOW[0]]

    def w(address, fmt):
        return struct.unpack_from(fmt, scene, address - SCENE_WINDOW[0])[0]

    # the saver reads WORDS of 0x5bb57b / 0x5bb57f; the app hands the dwords it holds (the low word is what is stored)
    fx.current = Current(w(0x5bb57b, '<i'), w(0x5bb57f, '<i'), w(0x5bb50b, '<h'), w(0x5bb593, '<h'),
                         w(0x5bb5a7, '<i'), w(0x5bb5ab, '<i'), w(0x5bb5af, '<i'))
    fx.selector = c.c_int16(case['selector'])
    fx.flags = (c.c_int16 * CAPACITY)(*case['w782'])
    fx.requests = []
    fx.load_status = case.get('load_status', 0)
    fx.scene_status = case.get('scene_status', 0)

    @LoadFn
    def load_current(_ctx, out):
        fx.examine_log.append(('load_current',))
        out[0] = fx.current
        return fx.load_status

    @SceneFn
    def scene_change(_ctx, request):
        fx.examine_log.append(('examine_scene_call',))
        fx.requests.append(Request.from_buffer_copy(request[0]))
        return fx.scene_status

    fx.keep = fx.keep + (load_current, scene_change)
    fx.examine = Examine(c.pointer(fx.selector), c.pointer(fx.slot), c.cast(fx.flags, c.POINTER(c.c_int16)),
                         ExamineHost(None, load_current, scene_change))
    fx.host.examine = c.cast(c.pointer(fx.examine), c.c_void_p)
    return fx


def native_log(fx):
    return [e for e in rt.normalise_log(fx.world.log) if e[0] not in ('examine_scene_call', 'load_current')]


def loads(fx):
    return sum(1 for e in fx.examine_log if e[0] == 'load_current')


# ------------------------------------------------------------------ independent decision model
def classify(case, machine):
    """(leaf, unsafe_reason). Independent of the native code: replays the add and remove steps on Python lists."""
    ensure = rt.ensure_words(case)
    item = case['item'] if machine == 'examine' else case['hot']
    if machine == 'click':
        mode = case['mode']
        if mode not in (2, 3):
            return 'closed-mode', None
        if rt.expected_click_consumed(case):
            return 'closed-consumed', None
    if not 0 <= item < CAPACITY:
        return 'unsafe', 'examined item outside the 70 item records'
    items = [w for w in ensure]
    count, sel = case['count'], case['selector']
    layout_last = case['slot_flag'] != 0 and case['mode'] == 2
    if sel != -1:
        if count > CAPACITY:
            return 'unsafe', 'add scans past the item array'
        if not any(s16(items[i]) == sel for i in range(max(count, 0))):
            if count < -1:
                return 'unsafe', 'negative length copy'
            if count + 1 > CAPACITY:
                return 'unsafe', 'list write past the item array'
            if not 0 <= sel < CAPACITY:
                return 'unsafe', 'presence write outside the array'
            head = [s16(items[i]) for i in range(max(count, 0))]
            new = head + [sel] if layout_last else [sel] + head
            items[:len(new)] = [w & 0xffff for w in new]
            count += 1
    if count > CAPACITY:
        return 'unsafe', 'remove scans past the item array'
    return ('examine-put-back' if sel != -1 else 'examine-save'), None


def make_case(rng, seed, machine, **kw):
    """One scenario around the examined `item` on a random inventory."""
    item = kw.pop('item', rng.randrange(CAPACITY))
    selector = kw.pop('selector', rng.choice((-1, -1, -1, rng.randrange(CAPACITY))))
    held = kw.pop('held', rng.choice((-1, -1, rng.randrange(CAPACITY))))
    pos = kw.pop('pos', rng.choice(('absent', 'first', 'middle', 'last', 'dup', 'alone', 'full', 'full69', 'beyond')))
    n = kw.pop('n', rng.choice((3, 5, 16, 17, 33)))
    items, count = rt.make_list(rng, item if pos != 'alone' else item, pos, n)
    if kw.pop('selector_listed', rng.random() < 0.3) and selector >= 0 and count > 0:
        items = list(items)
        items[rng.randrange(len(items))] = selector
    mode, slot_flag, close_flag = kw.pop('env', rng.choice(((2, 1, 1), (2, 0, 1), (3, 1, 0), (3, 0, 2), (2, 1, 0xff),
                                                           (2, 1, 0), (2, 0, 0))))
    kind = [rng.choice((0, 1, 2, 3)) for _ in range(CAPACITY)]
    text = [rng.choice((0, 5, 0x270f, 0x270e, -1, 1, 300, -300)) for _ in range(CAPACITY)]
    aux_a = [rng.choice((0, 0, 1, 2)) for _ in range(CAPACITY)]
    aux_b = [rng.choice((0, 1, 1)) for _ in range(CAPACITY)]
    w782 = [rng.choice((0, 1, 2, -1, 0x7fff, -0x8000, 5)) for _ in range(CAPACITY)]
    if 0 <= item < CAPACITY:
        kind[item], aux_a[item] = 3, 0
        text[item] = kw.pop('text', rng.choice((5, 1, 300, -300, -1, 0x270e, 7)))
    case = rt.base_case(seed, group=kw.pop('group', machine), held=held, hot=item if machine == 'click' else -1,
                        mode=mode, slot_flag=slot_flag, close_flag=close_flag, kind=kind, text=text, aux_a=aux_a,
                        aux_b=aux_b, event=rng.choice((0x2717, 0x2718, -1, 0)), tab=rng.choice((-1, 0x64)),
                        panels=[rng.choice((0, 1)) for _ in range(6)])
    case['tab_applied'] = rng.choice((case['tab'], -1, 0x64))
    rt.set_list(case, items, count)
    if rng.random() < 0.25:
        case['slot_item'] = [rng.choice((-1, 0, 5, 40)) for _ in range(16)]
    case['slot_lit'] = [rng.choice((0, 1)) for _ in range(16)]
    case.update(item=item, item_hi=rng.choice((0, 0, 0xffff, 0x1234)), selector=selector, w782=w782, take=kw.pop('take', 1),
                sound=kw.pop('sound', 1), machine=machine)
    case.update(kw)
    return case


def cases(rng, quick):
    out, seed = [], 700000

    def add(machine, **kw):
        nonlocal seed
        seed += 1
        case = make_case(rng, seed, machine, **kw)
        out.append(case)
        return case

    positions = ('absent', 'first', 'middle', 'last', 'dup', 'alone', 'full', 'full69', 'beyond')
    envs = ((2, 1, 1), (2, 0, 1), (3, 1, 0), (3, 0, 2), (2, 1, 0xff), (2, 1, 0), (2, 0, 0), (3, 1, 1))
    # K: the click path (take 1, sound 1) across list positions, selectors (none / pending / listed), layouts, close flags
    for _ in range(4 if not quick else 1):
        for pos in positions:
            for selector in (-1, 'pending', 'listed'):
                for env in envs[:5] if quick else envs:
                    sel = -1 if selector == -1 else rng.randrange(CAPACITY)
                    add('click', pos=pos, selector=sel, selector_listed=selector == 'listed', env=env)
    # closed gates and the decoys beside the read branch
    for env in ((0, 0, 1), (1, 1, 1), (4, 1, 1), (5, 0, 0), (-1, 1, 1), (0x102, 1, 1)):
        for _ in range(2 if quick else 5):
            add('click', env=env, group='click closed gate')
    for _ in range(6 if quick else 40):
        case = add('click', group='click decoys')
        item = case['hot']
        which = rng.choice(('kind', 'text0', 'text270f', 'aux'))
        if which == 'kind':
            case['kind'][item] = rng.choice((0, 1, 2, 0x103))
        elif which == 'text0':
            case['text'][item] = 0
        elif which == 'text270f':
            case['text'][item] = 0x270f
        else:
            case['aux_a'][item] = rng.choice((1, 2, 0xffffffff))
            case['aux_b'][item] = rng.choice((0, 1))
    # E: the direct entry, every take word and sound dword the second caller can make
    takes = (1, 0, 2, -1, 0x7fff, -0x8000, 0x10001, 0x20001, 0x1ffff)
    sounds = (1, 0, 2, 0x100, 0x7fffffff, -1, -0x80000000)
    for _ in range(3 if not quick else 1):
        for pos in positions:
            for take in takes:
                for sound in (sounds if not quick else (1, 0, -1)):
                    add('examine', pos=pos, take=take, sound=sound, group='direct entry',
                        env=rng.choice(envs))
    # unsafe states: the original reads or writes outside its arrays; the native step must refuse before any effect
    for item in (70, 100, -1, -2, 0x7fff, -0x8000):
        for sel in (-1, 5):
            add('examine', item=item, selector=sel, group='unsafe item')
    for count in (71, 75, 200):
        for sel in (-1, 5):
            case = add('examine', pos='absent', selector=sel, group='unsafe count')
            case['count'] = count
    for sel in (70, 100, 300, -2, -100):
        add('examine', pos='absent', selector=sel, selector_listed=False, group='unsafe selector')
        add('examine', pos='full', selector=sel, selector_listed=False, group='unsafe selector full list')
    return out


def compare_case(lib, original, case, counters):
    machine = case['machine']
    if machine == 'click':
        rt_leaf, _ = rt.classify_click(case)
        if rt_leaf != 'read':
            # decoys beside the read branch and the closed gates: RT-22's comparison (pick up, put back, use stop)
            counters['rt22'] = counters.get('rt22', 0) + 1
            return rt.compare_click(lib, original, case, counters['rt22_counters'])
    leaf, unsafe = classify(case, machine)
    case['leaf'] = leaf
    if leaf == 'unsafe':
        return compare_unsafe(lib, original, case, unsafe, counters)
    try:
        got = original.run(machine, case, strict=True)
    except OracleError:
        raise
    except Exception as error:      # Unicorn fault inside the real rebuild (item type outside the table)
        counters['faulted'][type(error).__name__] = counters['faulted'].get(type(error).__name__, 0) + 1
        return None
    return compare_native(lib, original, case, got, leaf, counters)


def compare_native(lib, original, case, got, leaf, counters):
    machine = case['machine']
    fx = native_examine_world(lib, case, got['before'])
    before_model = fx.world.snapshot()
    consumed = bool(rt.expected_click_consumed(case)) if machine == 'click' else False
    if machine == 'click':
        status, result, failure = fx.click(frame_consumed=int(consumed))
        examined = leaf.startswith('examine')
    else:
        ex_result, failure_p = ExamineResult(), c.c_char_p()
        status = lib.inventory_examine(c.byref(fx.view), c.byref(fx.data), c.byref(fx.world.model), c.byref(fx.host),
                                       c.byref(fx.examine), case['item'], s16(case['take']), s32(case['sound']),
                                       c.byref(ex_result), c.byref(failure_p))
        result, failure = None, failure_p.value
        examined = True
    log = native_log(fx)
    if not fx.world.guards_intact():
        raise OracleError(('native wrote outside the arrays', case))
    if got['examined'] != examined:
        raise OracleError(('0x4ea269 reached differs from the model', leaf, machine, case))
    if not examined:
        # a closed gate or a decoy: the examine step must not run in either; the pick-up / put-back paths are RT-22's
        if got['stop'] is not None:
            raise OracleError(('unexpected stop', got['stop'], case))
        if any(e[0].startswith('examine') for e in log):
            raise OracleError(('native examined on a non-examine click', case))
        if log != got['events']:
            raise OracleError(('event order differs on a non-examine click', log, got['events'], case))
        if fx.world.snapshot() != got['model']:
            raise OracleError(('model differs on a non-examine click', case))
        counters['leaf'][leaf] = counters['leaf'].get(leaf, 0) + 1
        return got
    if status != t78.OK:
        raise OracleError(('native rejected a parity case', status, failure, leaf, case))
    if log != got['events']:
        raise OracleError(('effect order mismatch', leaf, case['group'], case['seed'], 'native', [e[:2] for e in log], 'original', [e[:2] for e in got['events']]))
    if fx.world.snapshot() != got['model']:
        raise OracleError(('model state mismatch', leaf, case, fx.world.snapshot(), got['model']))
    mine_view, orig = rt.native_view_state(fx.view), got['view']
    rt.compare_dicts('examine', mine_view, orig, ('screen', 'mode', 'tab', 'tab_applied'), case)
    if orig['screen'] != 0 or orig['mode'] != 0 or orig['tab'] != -1 or orig['tab_applied'] != -1 or orig['scroll_bits']:
        raise OracleError(('the original did not close the view', orig, case))
    # the byte windows: expected = the seeded image with the modeled stores applied
    for start, length in WINDOWS:
        expected = bytearray(got['before'][start])
        if start == RECORD_WINDOW[0]:
            off = RECORD2 - start
            expected[off:off + RECORD_BYTES] = record_bytes(fx.slot)
        if start == SCENE_WINDOW[0] and fx.requests:
            req = fx.requests[0]
            struct.pack_into('<i', expected, 0x5bb57b - start, req.scene_5bb57b)
            struct.pack_into('<h', expected, 0x5bb599 - start, req.word_5bb599)
            struct.pack_into('<h', expected, 0x5bb595 - start, req.word_5bb595)
            struct.pack_into('<i', expected, 0x5bb59b - start, req.dword_5bb59b)
            struct.pack_into('<i', expected, 0x5bb59f - start, req.dword_5bb59f)
            struct.pack_into('<i', expected, 0x5bb5a3 - start, req.dword_5bb5a3)
        if start == START_WINDOW[0] and fx.requests:
            struct.pack_into('<h', expected, 0x5c39ff - start, fx.requests[0].word_5c39ff)
        if start == MODE_WINDOW[0] and fx.requests:
            struct.pack_into('<i', expected, 0x583999 - start, fx.requests[0].mode_583999)
        if start == SELECTOR_WINDOW[0]:
            struct.pack_into('<h', expected, SELECTOR - start, fx.selector.value)
        if bytes(expected) != got['after'][start]:
            diff = [hex(start + i) for i in range(length) if expected[i] != got['after'][start][i]]
            raise OracleError(('memory window differs from the native stores', hex(start), diff[:8], case))
    if len(fx.requests) != 1 or fx.requests[0].mode_583999 != 4:
        raise OracleError(('native did not make exactly one mode-4 request', case))
    if machine == 'click':
        flags = result.tuple()
        names = [e[0] for e in got['events']]
        expected_flags = (1, 1, 0, 0, 1, names.count('view_sound'), names.count('presence79'), names.count('presence'))
        # RT-22 flag order: gate_open, handled, picked, put_back, closed, sound_requests, removed, added
        removed = int(any(e[0] == 'presence79' for e in got['events']))
        added = int(any(e[0] == 'presence' for e in got['events']))
        sounds = names.count('view_sound') + names.count('examine_sound')
        expected_flags = (1, 1, 0, 0, 1, sounds, removed, added)
        if flags != expected_flags:
            raise OracleError(('result flags differ from the original', flags, expected_flags, leaf, case))
        if got['eax'] != 1:
            raise OracleError(('0x4e8e78 return value', got['eax'], case))
    # the saved-scene decision
    saves = [e for e in got['events'] if e[0] == 'examine_save']
    if (case['selector'] == -1) != bool(saves):
        raise OracleError(('saver ran differently from the selector rule', case))
    if loads(fx) != len(saves):
        raise OracleError(('the running-scene words were requested differently from the saver', case))
    counters['leaf'][leaf] = counters['leaf'].get(leaf, 0) + 1
    return got


def compare_unsafe(lib, original, case, reason, counters):
    """Unsafe original behaviour is observed, never a parity target; the native step must refuse before any effect."""
    observed = 'not run'
    try:
        got = original.run(case['machine'], case, strict=False)
        observed = 'completed'
    except Exception as error:
        observed = type(error).__name__
    fx = native_examine_world(lib, case, original.scene_before)
    before, rec_before = fx.world.snapshot(), record_bytes(fx.slot)
    if case['machine'] == 'click':
        status, _, _ = fx.click(frame_consumed=0)
    else:
        ex_result, failure_p = ExamineResult(), c.c_char_p()
        status = lib.inventory_examine(c.byref(fx.view), c.byref(fx.data), c.byref(fx.world.model), c.byref(fx.host),
                                       c.byref(fx.examine), case['item'], s16(case['take']), s32(case['sound']),
                                       c.byref(ex_result), c.byref(failure_p))
    if status not in (t78.BOUNDS, t78.ARGUMENT):
        raise OracleError(('native accepted an unsafe case', reason, status, case))
    if (fx.world.snapshot() != before or record_bytes(fx.slot) != rec_before or fx.selector.value != case['selector']
            or fx.requests or not fx.world.guards_intact()):
        raise OracleError(('native changed state before refusing', reason, case))
    if any(e[0].endswith('_call') for e in fx.world.log):
        raise OracleError(('native called the host before refusing', fx.world.log, case))
    counters['unsafe'][reason] = counters['unsafe'].get(reason, 0) + 1
    counters['unsafe_observed'][observed] = counters['unsafe_observed'].get(observed, 0) + 1
    return None


def main(*, library=None, report_path=REPORT, quick=False):
    started = time.monotonic()
    library_path = iv.build_library() if library is None else Path(library)
    lib = bind(library_path)
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    if sha(pe.data) != EXE_HASH:
        raise OracleError('executable mismatch')
    windows = []
    for start, end, label, digest in CODE_WINDOWS:
        actual = sha(pe.image[start - pe.image_base:end - pe.image_base])
        if digest is not None and actual != digest:
            raise OracleError(f'code window mismatch: {label}')
        windows.append(dict(start=hex(start), end=hex(end), label=label, sha256=actual))
    original = ExamineOriginal(pe)
    rng = random.Random(0x4ea269)
    counters = dict(leaf={}, faulted={}, unsafe={}, unsafe_observed={},
                    rt22_counters=dict(leaf={}, faulted={}, unsafe={}, unsafe_observed={}, tab_refused=0))
    totals = dict(cases=0, parity=0, by_group={})
    sequences, footprints = {}, {}
    for case in cases(rng, quick):
        totals['cases'] += 1
        got = compare_case(lib, original, case, counters)
        if got is not None:
            totals['parity'] += 1
            totals['by_group'][case['group']] = totals['by_group'].get(case['group'], 0) + 1
            key = ','.join(e[0] for e in got['events'])
            sequences[key] = sequences.get(key, 0) + 1
            for name in got['footprint']:
                footprints[name] = footprints.get(name, 0) + 1
    report = dict(
        slice='RT-43',
        scope='inventory examine step 0x4ea269 through the click 0x4e8dc8 -> 0x4e8e78 -> 0x4e8f0e and entered directly '
              '(take word and sound dword variants), with the real add 0x4e9e84, saver 0x4eb70f, remove 0x4ea06c, '
              'rebuild 0x4e812f, UI animation 0x4e0559 and close 0x4e7d04',
        original_sha256=EXE_HASH, code_windows=windows, native_sha256=sha(Path(library_path).read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        cases=totals['cases'], parity_cases=totals['parity'], by_group=dict(sorted(totals['by_group'].items())),
        leaves=dict(sorted(counters['leaf'].items())), rt22_leaves=dict(sorted(counters['rt22_counters']['leaf'].items())),
        rt22_cases=counters.get('rt22', 0), native_rejected_unsafe=counters['unsafe'],
        original_on_unsafe=counters['unsafe_observed'], original_faulted_no_parity=counters['faulted'],
        event_sequences=dict(sorted(sequences.items())), mismatches=0,
        write_footprint_classes=dict(sorted(footprints.items())), hooks=dict(sorted(original.hook_counts.items())),
        original_decisions_replaced='none; host-boundary replacements only (listed in hooks)',
        compared='ordered event log (examine entry, put-back add with sound/rebuild/UI, saver with the stored marker, '
                 'selector store, remove, sound request, scene words, close entry and teardown), final inventory cells, '
                 'view state (screen state, mode, tab, scroll), byte-for-byte windows of the selector, the three '
                 'saved-scene records, the scene request words, 0x5c39ff and 0x583999 (seeded with random bytes), '
                 '0x4e8e78 return value and result flags, write footprint, callee-saved registers, stack balance',
        not_compared=['what the replaced host functions do (sound manager, view/panel teardown, 0x4d36ed)',
                      'the loader consumption of the scene request words and the engine-mode dispatcher',
                      'the use branch 0x4e8f6d (still UNMODELED)',
                      'items whose id is outside 0..69 and inventory states the original would overflow: observed '
                      'only, the native step refuses them before any effect'],
        seconds=round(time.monotonic() - started, 2))
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2, default=lambda o: sorted(o) if isinstance(o, set) else str(o)) + '\n')
    print(json.dumps({k: report[k] for k in ('cases', 'parity_cases', 'mismatches', 'seconds')}))
    print(json.dumps(dict(leaves=report['leaves'], groups=report['by_group'])))
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--report', default=str(REPORT))
    parser.add_argument('--library')
    parser.add_argument('--quick', action='store_true')
    args = parser.parse_args()
    main(library=args.library, report_path=Path(args.report), quick=args.quick)
