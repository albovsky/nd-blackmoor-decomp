#!/usr/bin/env python3
"""RT-22: original-x86 oracle for the inventory view (hover, click: pick up and put back).

The unmodified original runs under Unicorn from three entry points (the machines share
one memory image; nothing the original decides is replaced):

  H. hover   0x4e89eb  mode gate (view +0x764c in {2, 3}) -> 0x4ee2a9 cursor choice and
             frame controls -> cursor hot point added to the pointer -> per-tab hover
             0x4e22fd -> 0x4e8bb4 slot scan (hot item, event dword 0x5c39e5, highlight
             flags, cursor variant 0x5b44f4).
  C. click   0x4e8dc8  mode gate -> frame control 0x4ee517 and tab buttons 0x4e26fc ->
             0x4e8e78: read/examine condition, use condition, PICK UP (held := hot,
             remove 0x4ea06c with the real view rebuild 0x4e812f, sound 0x17, close 0x4e7d04
             when +0x7011), PUT BACK (add 0x4e9e84 with the real 0x4e0559 UI animation,
             held := -1, sound 0x14).
  R. rebuild 0x4e812f  the slot fill, entered alone (slots, page).

Enumerated hooks (the report lists the per-run counts):

  replacement  0x4fb2e3 sound manager request (host boundary; the caller's return address
               decides whether it is the view's own request or the add step's one)
  replacement  0x4ee517 frame control click, 0x4e26fc tab button click, 0x4e22fd frame/tab
               hover control, 0x4ef2d1 scroll control hover (host UI; the return value is
               the case's input, it becomes the native "frame_consumed")
  replacement  0x4edb97 view teardown, 0x4e1d34 panel teardown, 0x4d36ed screen close
               notification (host UI of the close 0x4e7d04)
  stop         0x4e8f0e (read/examine) and 0x4e8f6d (use): the native kernel recovers these
               branches as conditions only and returns UNMODELED; the oracle stops the
               original at the branch and compares that it was reached, nothing was written.
  observation  code entries and every memory write of the whole address space.

The rebuild 0x4e812f, the add 0x4e9e84, the remove 0x4ea06c, the UI animation 0x4e0559,
the cursor choice 0x4ee2a9 and the reset 0x4e7ba7 / 0x4e7bf3 run for real.
"""
import argparse
import ctypes as c
import hashlib
import json
from pathlib import Path
import random
import struct
import time

from cif_original_oracle import PEImage
import action_family_78_runtime_original_oracle as o78
import action_family_79_runtime_original_oracle as o79
import test_action_family_78_runtime as t78
import test_inventory_view_runtime as iv

ROOT = Path(__file__).resolve().parents[3]
REPORT = ROOT / 'work/analysis/slices/RT-22.oracle.json'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
CODE_WINDOWS = [
    (0x4e89eb, 0x4e8bb4, 'hover entry 0x4e89eb', 'd927adb53cfce7f4dc899bdc23cd5c9ee9ade4a9bd470d46a6e0034e8e0003ff'),
    (0x4e8bb4, 0x4e8d72, 'slot scan 0x4e8bb4', '297cedb2821f3c564f004101b600579be69434e6c1be9b3545333442962e30d6'),
    (0x4ee2a9, 0x4ee517, 'cursor choice 0x4ee2a9', '572e87495891dfe755240e8a24362c8eb9d0008bc31e06132941368fcf814c34'),
    (0x4e8dc8, 0x4e8e78, 'click gate 0x4e8dc8', 'f2866a0b62bc712f0e56fb52269899eb0289e03719f527243ef83d6898766cfe'),
    (0x4e8e78, 0x4e94a9, 'click 0x4e8e78', '6bf1f75ca5cb3d5d11d9633d02ef57915a87f2453f48253feda12440dc5c9c3a'),
    (0x4e7ba7, 0x4e7bf3, 'reset 0x4e7ba7', '69a3ab91d4020f7eabee71bf2ad325be550f70170fba08f94b0591770be1b07b'),
    (0x4e7bf3, 0x4e7c72, 'close reset 0x4e7bf3', '5fbce2fd569dcb623fc311abd29a4ff9f7de9b68b5829e3e4b53854f3b39ce67'),
    (0x4e7d04, 0x4e7d2e, 'close 0x4e7d04', 'f7cc1012916b165c716ecb86ae7d8f47938e8ed4668e7077833a054a4ae2d405'),
] + [w for w in o78.CODE_WINDOWS if w[0] in (0x4e9e84, 0x4ea06c, 0x4e812f, 0x4e0559, 0x4fb2e3,
                                             0x4ee69e, 0x50ce04)]

VIEW, VIEW_BYTES, STACK, FRAME = o79.VIEW, o79.VIEW_BYTES, o79.STACK, o79.FRAME
SENTINEL = 0x30004000
HELD, COUNT_WORD, LIST, PRESENCE = o79.HELD, o79.COUNT_WORD, o79.LIST, o79.PRESENCE
CAPACITY = 70
DERIVED_WORDS, DERIVED_LISTS = o79.DERIVED_WORDS, o79.DERIVED_LISTS
# view offsets (object 0x571442)
HOT, INDEX, SLOT0, SLOT_STRIDE = 0x6b1c, 0x822e, 0x7fae, 0x28
SLOT_LIT, SLOT_LEFT, SLOT_TOP, SLOT_RIGHT, SLOT_BOTTOM = 4, 0x18, 0x1c, 0x20, 0x24
PX, PY = 0x823a, 0x823e
MODE, SLOT_FLAG, CLOSE_FLAG, PANEL0, PANEL_STRIDE = 0x764c, 0x7010, 0x7011, 0x7012, 0xf7
TAB, TAB_APPLIED, SCROLL, PAGE = 0x8232, 0x8236, 0x8252, 0x825e
FRAME_MODE, FLAG_15F, FLAG_252 = 0x4af, 0x15f, 0x252
KIND0, KIND_STRIDE, TEXT_DELTA = 0x77e, 0x16d, 2
# globals
EVENT, CURSOR_OVERRIDE, CUR_IDX, CUR_VAR, CUR_HELD_FLAG = 0x5c39e5, 0x5c39e9, 0x5b44f0, 0x5b44f4, 0x5b44f8
SCREEN, MOUSE_X, MOUSE_Y = 0x583204, 0x583102, 0x583106
CURS_BASE, CURS_BYTES = 0x5b160c, 8580
AUX_A, AUX_B = 0x583ced, 0x583e05
EXTRA_FOOTPRINT = ((SCREEN, 4), (EVENT, 4), (CUR_IDX, 8), (0x5d162d, 4), (0x5d1631, 4), (0x5d1639, 4),
                   (0x5c3a5b, 8))
VIEW_WRITE_RANGES = {
    'hover': ((4, 0x18), (HOT, 4), (INDEX, 4), (PX, 4), (PY, 4), (0x8242, 4), (0x8246, 4), (0x824a, 4),
              (0x824e, 4), (SLOT0, SLOT_STRIDE * 16)),
    # 0x828a..0x831a: the remove step's staging buffer (70 words) and its counter +0x8316
    'click': ((INDEX, 4), (SLOT0, SLOT_STRIDE * 16), (MODE, 8), (TAB, 8), (SCROLL, 4), (0x825a, 4),
              (PAGE, 4), (0x8262, 4), (0x828a, 0x90)),
    'rebuild': ((INDEX, 4), (SLOT0, SLOT_STRIDE * 16), (SCROLL, 4), (0x825a, 4), (PAGE, 4), (0x8262, 4)),
}
READ_NAMES = {'read': 0x4e8f0e, 'use': 0x4e8f6d}


def sha(data):
    return hashlib.sha256(data).hexdigest()


class OracleError(AssertionError):
    pass


def s16(value):
    return struct.unpack('<h', struct.pack('<H', value & 0xffff))[0]


def s32(value):
    return struct.unpack('<i', struct.pack('<I', value & 0xffffffff))[0]


def boot_chunk(tag):
    data = iv.BOOT.read_bytes()
    pos = 12
    while pos + 8 <= len(data):
        name, size = data[pos:pos + 4], int.from_bytes(data[pos + 4:pos + 8], 'big')
        if name == tag:
            return data[pos + 8:pos + 8 + size]
        pos += 8 + size + (size & 1)
    raise OracleError('boot chunk missing ' + repr(tag))


class ViewOriginal(o78.Original):
    """The RT-19 machine (memory image, add/remove/rebuild/UI observation, write capture)
    with the inventory view entry points and host-boundary replacements added."""

    def __init__(self, pe):
        super().__init__(pe)
        from unicorn import UC_HOOK_CODE
        self.curs = boot_chunk(b'CURS')
        if len(self.curs) != CURS_BYTES:
            raise OracleError('unexpected CURS chunk size')
        self.stop = None
        self.entered = set()
        self.consumed_seen = None
        self.case = None
        self.tab_clicks = 0
        for address in (0x4e89eb, 0x4e8a17, 0x4e8bb4, 0x4ee2a9, 0x4e8dc8, 0x4e8e78, 0x4e8f0e, 0x4e8f6d,
                        0x4e9411, 0x4e9474, 0x4e7d04, 0x4edb97, 0x4e1d34, 0x4d36ed, 0x4ee517,
                        0x4e26fc, 0x4e22fd, 0x4ef2d1):
            self.uc.hook_add(UC_HOOK_CODE, self.on_code, begin=address, end=address)

    # ---- replacement helper: pop the return address and nargs stack words
    def replace(self, uc, esp, eax, nargs):
        ret = struct.unpack('<I', self.read(esp, 4))[0]
        uc.reg_write(self.regs['EAX'], eax & 0xffffffff)
        uc.reg_write(self.regs['ESP'], esp + 4 + 4 * nargs)
        uc.reg_write(self.regs['EIP'], ret)

    def on_code(self, uc, address, size, user):
        esp = uc.reg_read(self.regs['ESP'])
        case = self.case
        if address == 0x4fb2e3:
            self.count('REPLACE 0x4fb2e3 sound manager request (host boundary)')
            ret, slot = struct.unpack('<II', self.read(esp, 8))
            slot &= 0xffff
            if 0x4e9e84 <= ret < 0x4ea06c:
                self.events += [('sound', slot), ('sound_call', slot)]
            elif 0x4e8e78 <= ret < 0x4e94a9:
                self.events += [('view_sound', slot), ('view_sound_call', slot)]
            else:
                raise OracleError('sound request from an unexpected caller %#x' % ret)
            self.replace(uc, esp, 0, 1)
        elif address == 0x4e89eb:
            self.count('observe 0x4e89eb hover entry (real code runs)')
            self.entered.add('hover')
        elif address == 0x4e8a17:
            self.consumed_seen = uc.reg_read(self.regs['EAX']) != 0
        elif address == 0x4e8bb4:
            self.count('observe 0x4e8bb4 slot scan entry (real code runs)')
            self.entered.add('scan')
        elif address == 0x4ee2a9:
            self.count('observe 0x4ee2a9 cursor choice entry (real code runs)')
            self.entered.add('cursor')
        elif address == 0x4e8dc8:
            self.count('observe 0x4e8dc8 click gate entry (real code runs)')
        elif address == 0x4e8e78:
            self.count('observe 0x4e8e78 click entry (real code runs)')
            self.entered.add('click')
        elif address in (0x4e8f0e, 0x4e8f6d):
            name = 'read' if address == 0x4e8f0e else 'use'
            self.count('STOP 0x%x %s branch (native: UNMODELED)' % (address, name))
            self.stop = name
            uc.emu_stop()
        elif address == 0x4e9411:
            self.count('observe 0x4e9411 pick up taken')
            self.events.append(('pick', s32(struct.unpack('<I', self.read(VIEW + HOT, 4))[0])))
        elif address == 0x4e9474:
            self.count('observe 0x4e9474 put back taken')
            self.events.append(('put', self.s16(HELD)))
        elif address == 0x4e7d04:
            self.count('observe 0x4e7d04 close entry (real code runs)')
            self.events.append(('close', 0))
        elif address == 0x4edb97:
            self.count('REPLACE 0x4edb97 view teardown (host UI)')
            self.events.append(('close_call',))
            self.replace(uc, esp, 0, 0)
        elif address == 0x4e1d34:
            self.count('REPLACE 0x4e1d34 panel teardown (host UI)')
            self.replace(uc, esp, 0, 0)
        elif address == 0x4d36ed:
            self.count('REPLACE 0x4d36ed screen close notification (host)')
            self.replace(uc, esp, 0, 0)
        elif address == 0x4ee517:
            self.count('REPLACE 0x4ee517 frame control click (host UI)')
            self.replace(uc, esp, case['r_ee517'], 0)
        elif address == 0x4e26fc:
            self.count('REPLACE 0x4e26fc tab button click (host UI)')
            panel = (uc.reg_read(self.regs['ECX']) - (VIEW + 0x7654)) // 0x18f
            self.tab_clicks += 1
            self.replace(uc, esp, case['r26fc'][panel] if 0 <= panel < 6 else 0, 0)
        elif address == 0x4e22fd:
            self.count('REPLACE 0x4e22fd frame/tab hover control (host UI)')
            self.replace(uc, esp, case['r22fd'], 2)
        elif address == 0x4ef2d1:
            self.count('REPLACE 0x4ef2d1 scroll control hover (host UI)')
            self.replace(uc, esp, case['r2d1'], 2)
        else:
            super().on_code(uc, address, size, user)

    # ---- memory image for one case
    def w32(self, address, value):
        self.uc.mem_write(address, struct.pack('<I', value & 0xffffffff))

    def prepare(self, case):
        uc = self.uc
        rng = random.Random(case['seed'])
        self.case = case
        self.events, self.writes, self.reads_beyond, self.ui_writes = [], [], [], []
        self.mode, self.row, self.last_id = 'add', 0, None
        self.stop, self.entered, self.consumed_seen, self.tab_clicks = None, set(), None, 0
        uc.mem_write(VIEW, bytes(rng.randrange(256) for _ in range(VIEW_BYTES)))
        for item in range(CAPACITY):
            base = VIEW + KIND0 + item * KIND_STRIDE
            uc.mem_write(base, struct.pack('<hh', case['kind'][item], case['text'][item]))
        self.w32(VIEW + FLAG_252, case['f252'])
        self.w32(VIEW + FRAME_MODE, case['frame_mode'])
        self.w32(VIEW + FLAG_15F, case['f15f'])
        self.w32(VIEW + TAB, case['tab'])
        self.w32(VIEW + TAB_APPLIED, case['tab_applied'])
        self.w32(VIEW + MODE, case['mode'])
        uc.mem_write(VIEW + SLOT_FLAG, bytes([case['slot_flag'] & 0xff]))
        uc.mem_write(VIEW + CLOSE_FLAG, bytes([case['close_flag'] & 0xff]))
        for i in range(6):
            self.w32(VIEW + PANEL0 + PANEL_STRIDE * i, case['panels'][i])
        self.w32(VIEW + HOT, case['hot'])
        for i in range(16):
            slot = VIEW + SLOT0 + SLOT_STRIDE * i
            self.w32(slot, case['slot_item'][i])
            self.w32(slot + SLOT_LIT, case['slot_lit'][i])
            left, top, right, bottom = case['rect'][i]
            self.w32(slot + SLOT_LEFT, left)
            self.w32(slot + SLOT_TOP, top)
            self.w32(slot + SLOT_RIGHT, right)
            self.w32(slot + SLOT_BOTTOM, bottom)
        self.w32(EVENT, case['event'])
        self.w32(CURSOR_OVERRIDE, case['override'])
        self.w32(CUR_HELD_FLAG, case['held_flag'])
        self.w32(CUR_IDX, case['pre_idx'])
        self.w32(CUR_VAR, case['pre_var'])
        self.w32(SCREEN, 3)
        self.w32(MOUSE_X, case['mouse'][0])
        self.w32(MOUSE_Y, case['mouse'][1])
        uc.mem_write(CURS_BASE, self.curs)
        uc.mem_write(AUX_A, struct.pack('<%dI' % CAPACITY, *case['aux_a']))
        uc.mem_write(AUX_B, struct.pack('<%dI' % CAPACITY, *case['aux_b']))
        uc.mem_write(DERIVED_WORDS[0], bytes(rng.randrange(256) for _ in range(4)))
        for address, size in DERIVED_LISTS:
            uc.mem_write(address, bytes(rng.randrange(256) for _ in range(size)))
        ensure_words(case)
        uc.mem_write(LIST, struct.pack('<%dH' % CAPACITY, *case['list_words']))
        uc.mem_write(COUNT_WORD, struct.pack('<h', case['count']))
        uc.mem_write(HELD, struct.pack('<h', case['held']))
        uc.mem_write(PRESENCE, struct.pack('<%di' % CAPACITY, *case['presence']))
        for cell in o78.UI_CELLS:
            self.w32(cell, 0xdeadbeef)
        uc.mem_write(STACK, bytes(0x10000))
        self.initial = dict(EAX=rng.randrange(2 ** 32), EBX=rng.randrange(2 ** 32),
                            EDX=rng.randrange(2 ** 32), ESI=rng.randrange(2 ** 32),
                            EDI=rng.randrange(2 ** 32), EBP=FRAME)
        self.view_before = self.read(VIEW, VIEW_BYTES)

    def invoke(self, entry, strict=True):
        uc, r = self.uc, self.regs
        for name, value in self.initial.items():
            uc.reg_write(r[name], value)
        uc.reg_write(r['ECX'], VIEW)
        esp0 = FRAME - 0x400
        uc.reg_write(r['ESP'], esp0 - 4)
        uc.mem_write(esp0 - 4, struct.pack('<I', SENTINEL))
        uc.reg_write(r['EFLAGS'], 0x202)
        self.writes.clear()
        uc.emu_start(entry, SENTINEL, count=3000000)
        finished = uc.reg_read(r['EIP']) == SENTINEL
        if self.stop is None:
            if not finished:
                raise OracleError('original did not return from %#x' % entry)
            if uc.reg_read(r['ESP']) != esp0:
                raise OracleError('stack unbalanced after %#x' % entry)
            for name in ('EBX', 'ESI', 'EDI', 'EBP'):
                if uc.reg_read(r[name]) != self.initial[name]:
                    raise OracleError(f'callee-saved {name} changed')
        return uc.reg_read(r['EAX']) & 0xffffffff

    def footprint_ok(self, machine, strict=True):
        """Every store must land in a known cell; view stores in the machine's expected
        field ranges (compared by value diff, so a store of the same value is invisible)."""
        classes = set()
        for address, size, _ in self.writes:
            name = self.footprint_class(address, size)
            if name is None:
                for start, length in EXTRA_FOOTPRINT:
                    if start <= address and address + size <= start + length:
                        name = 'machine cells (event, cursor, screen state, mouse copies)'
                if name is None:
                    if strict:
                        raise OracleError(f'original write outside the allowed footprint: {address:#x}/{size}')
                    name = 'OUTSIDE (unsafe original behaviour)'
            classes.add(name)
        after = self.read(VIEW, VIEW_BYTES)
        allowed = VIEW_WRITE_RANGES[machine]
        stray = sorted(o for o in range(VIEW_BYTES) if after[o] != self.view_before[o] and
                       not any(start <= o < start + length for start, length in allowed))
        if strict and stray:
            raise OracleError(('view bytes changed outside the expected fields', machine,
                               self.case['group'], [hex(o) for o in stray[:8]],
                               [(hex(a), s) for a, s, _ in self.writes if VIEW <= a < VIEW + VIEW_BYTES
                                and a - VIEW in stray][:6]))
        return classes

    def view_state(self):
        def d(offset):
            return s32(struct.unpack('<I', self.read(VIEW + offset, 4))[0])
        return dict(
            screen=s32(struct.unpack('<I', self.read(SCREEN, 4))[0]), mode=d(MODE), tab=d(TAB),
            tab_applied=d(TAB_APPLIED), hot=d(HOT), page=d(PAGE),
            event=s32(struct.unpack('<I', self.read(EVENT, 4))[0]),
            cursor_index=s32(struct.unpack('<I', self.read(CUR_IDX, 4))[0]),
            cursor_variant=s32(struct.unpack('<I', self.read(CUR_VAR, 4))[0]),
            cursor_rect=struct.unpack('<I', self.read(0x5d1631, 4))[0],
            slots=tuple(d(SLOT0 + SLOT_STRIDE * i) for i in range(16)),
            lit=tuple(d(SLOT0 + SLOT_STRIDE * i + SLOT_LIT) for i in range(16)),
            scroll_bits=struct.unpack('<I', self.read(VIEW + SCROLL, 4))[0],
            slot_scratch=d(INDEX))

    def run(self, machine, case, strict=True):
        self.prepare(case)
        entry = dict(hover=0x4e89eb, click=0x4e8dc8, rebuild=0x4e812f)[machine]
        eax = self.invoke(entry, strict)
        footprint = self.footprint_ok(machine, strict)
        ui_calls = [e for e in self.events if e[0] == 'ui_call']
        expected_ui = []
        for _ in ui_calls:
            expected_ui += [(o78.UI_CELLS[0], 4, 1), (o78.UI_CELLS[1], 4, 1)]
        if strict and self.ui_writes != expected_ui:
            raise OracleError(('UI animation stores differ from the modeled request', self.ui_writes))
        if strict and any(e[1:] != (1, 1, 0) for e in ui_calls):
            raise OracleError(('UI animation arguments differ from (1, 1, 0)', ui_calls))
        return dict(events=list(self.events), model=self.model_snapshot(), view=self.view_state(),
                    eax=eax, entered=set(self.entered), stop=self.stop,
                    consumed_seen=self.consumed_seen, footprint=footprint,
                    reads_beyond=list(self.reads_beyond), writes=list(self.writes))


# ------------------------------------------------------------------ cases
def base_case(seed, **kw):
    rng = random.Random(seed ^ 0x2222)
    case = dict(
        seed=seed, items=[], count=0, held=-1,
        presence=[rng.choice((0, 1, 1, 2, 7, -1, 0x7fffffff)) for _ in range(CAPACITY)],
        mode=2, tab=-1, tab_applied=-1, slot_flag=1, close_flag=1,
        panels=[1, 1, 1, 0, 0, 0], frame_mode=0, f15f=0, f252=0,
        r22fd=0, r2d1=0, r_ee517=0, r26fc=[0] * 6,
        slot_item=[-1] * 16, slot_lit=[0] * 16, rect=[[0, 0, 0, 0] for _ in range(16)],
        hot=-1, event=-1, override=0, held_flag=0, pre_idx=rng.randrange(107), pre_var=0, mouse=(0, 0),
        kind=[rng.choice((0, 1, 2, 3, 3, 7)) for _ in range(CAPACITY)],
        text=[rng.choice((0, 5, 0x270f, 0x270e, -1, 1)) for _ in range(CAPACITY)],
        aux_a=[0] * CAPACITY, aux_b=[0] * CAPACITY, group='')
    case.update(kw)
    return case


def ensure_words(case):
    """The 70 list words: the case's items, then stale noise (compared as well)."""
    if 'list_words' not in case:
        rng = random.Random(case['seed'] ^ 0x5eed)
        words = [w & 0xffff for w in case['items']]
        words += [rng.randrange(65536) for _ in range(CAPACITY - len(words))]
        case['list_words'] = words[:CAPACITY]
    return case['list_words']


def set_list(case, ids, count=None):
    case['items'] = list(ids)
    case['count'] = len(ids) if count is None else count
    case['slot_item'] = [s16(ids[i]) if i < len(ids) and i < case['count'] else -1 for i in range(16)]


def real_rects():
    layout = iv.Layout()
    lib = iv.bind()
    lib.inventory_view_layout_from_uiiv(iv.uiiv_chunk(), 2860, 10, 10, c.byref(layout))
    return [list(layout.rect[i]) for i in range(16)], layout.close_flag, layout.slot_flag


def hit_window(rect):
    left, top, right, bottom = rect
    return left + 11, right, top + 10, bottom - 10


def cursor_index(held, override, held_flag):
    """Independent model of 0x4ee2a9's index choice (the native function is the object under test)."""
    if override != 0 or held == -1:
        return 4
    return 9 if held_flag != 0 else held + 0x25


def hotspot(curs, index, variant):
    return struct.unpack_from('<ii', curs, 0x1ac0 + index * 16 + variant * 8)


def expected_hover_consumed(case):
    if case['mode'] not in (2, 3):
        return None
    if case['frame_mode'] in (2, 3):
        if case['f15f'] != 0 and case['r22fd'] != 0:
            return True
        if case['f252'] != 0 and case['r2d1'] != 0:
            return True
    return False


def expected_click_consumed(case):
    if case['mode'] not in (2, 3):
        return None
    if case['r_ee517'] != 0:
        return True
    return any(case['panels'][i] != 0 and case['r26fc'][i] != 0 for i in range(6))


def hover_cases(rng, quick):
    out = []
    curs = boot_chunk(b'CURS')
    real, _, _ = real_rects()
    layouts = [('real UIIV', real)]
    for k in range(4 if not quick else 2):
        rects = []
        for i in range(16):
            left = rng.randrange(-20, 400)
            top = rng.randrange(-20, 300)
            rects.append([left, top, left + rng.choice((0, 5, 21, 22, 40, 61)), top + rng.choice((0, 15, 20, 21, 59))])
        if k == 1:                                  # overlapping rectangles: first hit wins
            for i in range(1, 16, 2):
                rects[i] = list(rects[i - 1])
        layouts.append((f'synthetic {k}', rects))
    seed = 0
    holds = [-1, -1, 0, 5, 23, 69]
    pointer_budget = 25 if not quick else 6
    for name, rects in layouts:
        for slot in range(16):
            for _ in range(pointer_budget):
                seed += 1
                held = rng.choice(holds)
                mode = rng.choice((2, 2, 2, 3))
                mask = rng.choice(('random', 'all', 'one', 'none', 'random'))
                if mask == 'all':
                    occupied = [True] * 16
                elif mask == 'none':
                    occupied = [False] * 16
                elif mask == 'one':
                    occupied = [i == slot for i in range(16)]
                else:
                    occupied = [rng.random() < 0.5 for _ in range(16)]
                items = [rng.choice((0, 1, 23, 69, 70, 0xffff, 0x7fffffff, -2)) if occ else -1 for occ in occupied]
                x0, x1, y0, y1 = hit_window(rects[slot])
                px = rng.choice((x0 - 1, x0, x0 + 1, (x0 + x1) // 2, x1 - 1, x1, x1 + 1, rng.randrange(-30, 420)))
                py = rng.choice((y0 - 1, y0, y0 + 1, (y0 + y1) // 2, y1 - 1, y1, y1 + 1, rng.randrange(-30, 320)))
                override = rng.choice((0, 0, 0, 1, 0x100))
                held_flag = rng.choice((0, 0, 1, 0x10000))
                index = cursor_index(held, override, held_flag)
                dx, dy = hotspot(curs, index, 0)
                out.append(base_case(
                    seed, group='hover ' + name, mode=mode, held=held, slot_item=items,
                    slot_lit=[rng.choice((0, 1, 7)) for _ in range(16)], rect=[list(r) for r in rects],
                    hot=rng.choice((-1, 3, 40)), event=rng.choice((-1, 0, 0x2717, 0x2718, 0x1234)),
                    override=override, held_flag=held_flag, pre_var=rng.choice((0, 1)),
                    mouse=(px - dx, py - dy), frame_mode=rng.choice((0, 2, 3, 1, 0x102)),
                    f15f=rng.choice((0, 1, 0x100)), r22fd=rng.choice((0, 0, 1, 0x10000)),
                    f252=rng.choice((0, 0, 1)), r2d1=rng.choice((0, 1)), tab=rng.choice((-1, 0x64)),
                    panels=[rng.choice((0, 1)) for _ in range(6)]))
    # mode gate and frame consumption matrix on the real layout, pointer in the first slot
    x0, x1, y0, y1 = hit_window(real[0])
    for mode in (0, 1, 2, 3, 4, 5, 6, -1, 0x102, 0x10002):
        for frame_mode in (0, 2, 3, 5, 0x102):
            for f15f, r22fd, f252, r2d1 in ((0, 0, 0, 0), (1, 1, 0, 0), (1, 0, 0, 0), (0, 1, 0, 0),
                                            (1, 0x10000, 0, 0), (0, 0, 1, 1), (0, 0, 1, 0), (1, 0, 1, 1)):
                seed += 1
                held = rng.choice(holds)
                index = cursor_index(held, 0, 0)
                dx, dy = hotspot(curs, index, 0)
                out.append(base_case(
                    seed, group='hover gate matrix', mode=mode, held=held,
                    slot_item=[5 + i for i in range(16)], slot_lit=[1] * 16, rect=[list(r) for r in real],
                    hot=9, event=0x1234, mouse=(x0 + 3 - dx, y0 + 3 - dy), frame_mode=frame_mode,
                    f15f=f15f, r22fd=r22fd, f252=f252, r2d1=r2d1, pre_var=1))
    # empty first slot under the pointer, occupied overlapping second slot
    rects = [list(real[0])] + [list(real[0])] + [list(real[i]) for i in range(2, 16)]
    for held in (-1, 7):
        for k in range(4):
            seed += 1
            items = [-1, 9, 4, -1] + [-1] * 12
            items[k] = 1 if k > 1 else items[k]
            index = cursor_index(held, 0, 0)
            dx, dy = hotspot(curs, index, 0)
            x0, x1, y0, y1 = hit_window(real[0])
            out.append(base_case(seed, group='hover decoys', held=held, slot_item=items,
                                 slot_lit=[1] * 16, rect=rects, hot=3, event=0x2718,
                                 mouse=(x0 - dx, y0 - dy)))
    return out


def make_list(rng, hot, pos, n):
    ids = [v for v in range(CAPACITY) if v != hot]
    rng.shuffle(ids)
    items = ids[:n]
    if hot < 0 or pos == 'absent':
        return items, len(items)
    if pos == 'alone':
        return [hot], 1
    if pos == 'first':
        items[0] = hot
    elif pos == 'middle':
        items[len(items) // 2] = hot
    elif pos == 'last':
        items[-1] = hot
    elif pos == 'dup':
        items[1], items[len(items) - 1] = hot, hot
    elif pos == 'beyond':
        return items + [hot], len(items)
    elif pos == 'full':
        items = [v for v in range(CAPACITY) if v != hot]
        rng.shuffle(items)
        items.insert(rng.randrange(CAPACITY), hot)
        return items, CAPACITY
    elif pos == 'full69':
        items = ids[:69]
        return items, 69
    return items, len(items)


def classify_click(case):
    """Independent decision tree of 0x4e8dc8/0x4e8e78. Returns (leaf, unsafe_reason)."""
    mode = case['mode']
    ensure_words(case)
    if mode not in (2, 3):
        return 'closed-mode', None
    if expected_click_consumed(case):
        return 'closed-consumed', None
    hot, held, event, count = case['hot'], case['held'], case['event'], case['count']
    items = case['list_words']
    if hot != -1:
        if not 0 <= hot < CAPACITY:
            return 'unsafe', 'hot item outside the item and auxiliary tables'
        if (case['kind'][hot] == 3 and case['text'][hot] != 0 and case['text'][hot] != 0x270f and
                case['aux_a'][hot] == 0):
            return 'read', None
        if case['aux_a'][hot] == 1 and case['aux_b'][hot] == 1:
            return 'use', None
    close = case['close_flag'] & 0xff
    if event == 0x2717 and hot != -1 and case['aux_a'][hot] == 0 and held == -1:
        if count > CAPACITY:
            return 'unsafe', 'remove scans past the item array'
        return ('pick-close' if close else 'pick'), None
    if event == 0x2718 and held != -1:
        if count > CAPACITY:
            return 'unsafe', 'add scans past the item array'
        if any(s16(items[i]) == held for i in range(max(count, 0))):
            return 'put-duplicate', None
        if count < -1:
            return 'unsafe', 'negative length copy'
        if count + 1 > CAPACITY:
            return 'unsafe', 'list write past the item array'
        if not 0 <= held < CAPACITY:
            return 'unsafe', 'presence write outside the array'
        return 'put', None
    return 'none', None


def click_cases(rng, quick):
    out = []
    seed = 100000
    holds = (-1, 3, 23, 0)
    hots = (-1, 0, 3, 23, 69, 40)
    events = (0x2717, 0x2718, 0, 0x2719, 0x12717, 0x12718, -1)
    positions = ('absent', 'first', 'middle', 'last', 'dup', 'beyond', 'alone', 'full', 'full69')
    aux_pairs = ((0, 0), (0, 1), (1, 0), (1, 1), (2, 1), (0xffffffff, 0), (0x100, 1), (0, 0x100))
    kind_text = ((0, 0), (3, 0), (3, 0x270f), (3, 5), (3, -1), (2, 5), (0x103, 5), (3, 0x270e))
    envs = ((2, 1, 1), (2, 0, 1), (3, 1, 0), (3, 0, 2), (2, 1, 0xff), (2, 1, 0x80), (0, 0, 1), (1, 1, 1),
            (4, 1, 1), (5, 0, 0), (0x102, 1, 1), (-1, 1, 1))
    tabs = (-1, 0x64, 0x6a, 0)

    def one(**kw):
        nonlocal seed
        seed += 1
        hot = kw.pop('hot', -1)
        pos = kw.pop('pos', 'absent')
        n = kw.pop('n', rng.choice((3, 5, 16, 17, 33)))
        held = kw.pop('held', -1)
        items, count = make_list(rng, hot if hot >= 0 else held, pos, n)
        env = kw.pop('env', None)
        if env is None:                       # mostly the open view; the closed gates stay covered
            env = rng.choice(envs[:6]) if rng.random() < 0.7 else rng.choice(envs)
        mode, slot_flag, close_flag = env
        aux_a = [rng.choice((0, 0, 0, 1, 2)) for _ in range(CAPACITY)]
        aux_b = [rng.choice((0, 1, 1)) for _ in range(CAPACITY)]
        kind = [rng.choice((0, 1, 2, 3)) for _ in range(CAPACITY)]
        text = [rng.choice((0, 5, 0x270f, 0x270e, -1, 1)) for _ in range(CAPACITY)]
        a, b = kw.pop('aux', rng.choice(aux_pairs))
        kt, tt = kw.pop('kt', rng.choice(kind_text))
        if 0 <= hot < CAPACITY:
            aux_a[hot], aux_b[hot], kind[hot], text[hot] = a, b, kt, tt
        case = base_case(seed, group='click', held=held, hot=hot, mode=mode, slot_flag=slot_flag,
                         close_flag=close_flag, event=kw.pop('event', rng.choice(events)),
                         tab=rng.choice(tabs), aux_a=aux_a, aux_b=aux_b, kind=kind, text=text,
                         panels=[rng.choice((0, 1)) for _ in range(6)], **kw)
        case['tab_applied'] = rng.choice((case['tab'], -1, 0x64))
        set_list(case, items, count)
        if rng.random() < 0.25:                   # stale slots
            case['slot_item'] = [rng.choice((-1, 0, 5, 40)) for _ in range(16)]
        case['slot_lit'] = [rng.choice((0, 1)) for _ in range(16)]
        if rng.random() < 0.3:
            case['r_ee517'] = rng.choice((0, 0, 1, 0x10000))
            case['r26fc'] = [rng.choice((0, 0, 1)) for _ in range(6)]
        out.append(case)
        return case

    # leaf scenarios: every decision branch with the decoys beside it
    reps = 1
    for _ in range(reps):
        for held in holds:
            for hot in hots:
                for event in events:
                    for pos in (positions if hot >= 0 else ('absent',)):
                        if quick and rng.random() > 0.35:
                            continue
                        one(held=held, hot=hot, event=event, pos=pos)
    # the pick up / put back paths with the aux and read decoys, close flag variants
    for _ in range(5 if not quick else 1):
        for aux in aux_pairs:
            for kt in kind_text:
                one(held=-1, hot=rng.choice((0, 3, 23, 69)), event=0x2717, aux=aux, kt=kt,
                    pos=rng.choice(positions[:7]), env=(2, 1, rng.choice((0, 1, 0xff))))
    for _ in range(5 if not quick else 1):
        for aux in aux_pairs:
            one(held=rng.choice((3, 23, 0)), hot=rng.choice((-1, 7, 23)), event=0x2718, aux=aux,
                kt=rng.choice(kind_text), pos=rng.choice(positions), env=rng.choice(envs[:4]))
    # clean pick up and put back paths (no read/use decoy in the way): every list position,
    # both item-last layouts, close flag variants, every tab the native rebuild models
    benign = ((0, 0), (2, 5), (3, 0), (3, 0x270f), (1, 1))
    for _ in range(40 if not quick else 6):
        for pos in positions:
            one(held=-1, hot=rng.choice((0, 1, 3, 23, 40, 69)), event=0x2717, aux=(0, 0),
                kt=rng.choice(benign), pos=pos,
                env=(rng.choice((2, 3)), rng.choice((0, 1)), rng.choice((0, 1, 0xff, 0x80))))
            one(held=rng.choice((0, 1, 3, 23, 40, 69)), hot=rng.choice((-1, -1, 5, 17)), event=0x2718,
                aux=(0, 0), kt=rng.choice(benign), pos=pos,
                env=(rng.choice((2, 3)), rng.choice((0, 1)), rng.choice((0, 1, 0xff))))
    return out


def rebuild_cases(rng, quick):
    out = []
    seed = 200000
    counts = (-1, 0, 1, 2, 15, 16, 17, 31, 32, 33, 47, 48, 49, 69, 70)
    for count in counts:
        for tab in (-1, 0x64, 0x6a, 0, 0x65, 0x66, 0x67, 0x68, 0x69, 0x63, -2, 0x100):
            for _ in range(1 if quick else 3):
                seed += 1
                ids = list(range(CAPACITY))
                rng.shuffle(ids)
                case = base_case(seed, group='rebuild', tab=tab, tab_applied=rng.choice((-1, tab)),
                                 slot_item=[rng.choice((-1, 5, 0x77)) for _ in range(16)],
                                 slot_lit=[rng.choice((0, 1)) for _ in range(16)])
                case['items'] = ids[:max(count, 0)]
                case['count'] = count
                out.append(case)
    return out


# ------------------------------------------------------------------ native side
def native_view(lib, case, screen_state=3):
    view = iv.View()
    lib.inventory_view_init(c.byref(view))
    view.screen_state = screen_state
    view.mode = case['mode']
    view.tab, view.tab_applied, view.page = case['tab'], case['tab_applied'], 0
    view.hot, view.event, view.cursor_variant = case['hot'], case['event'], case['pre_var']
    for i in range(16):
        view.slot_item[i] = case['slot_item'][i]
        view.slot_lit[i] = case['slot_lit'][i]
    return view


def native_layout(case):
    layout = iv.Layout()
    layout.relative = 1
    layout.slot_flag = case['slot_flag'] & 0xff
    layout.close_flag = case['close_flag'] & 0xff
    layout.first_tab = 0x64
    for i in range(16):
        for j in range(4):
            layout.rect[i][j] = case['rect'][i][j]
    return layout


def native_world(lib, case):
    fx = iv.Fixture(lib, items=[], held=case['held'], kind=case['kind'], text=case['text'],
                    aux_a=[v & 0xffffffff for v in case['aux_a']], aux_b=[v & 0xffffffff for v in case['aux_b']])
    world = fx.world
    world.count.value = case['count']
    for i in range(CAPACITY):
        world.items[i] = case['list_words'][i]
        world.presence[i] = case['presence'][i]
    fx.layout = native_layout(case)
    fx.view = native_view(lib, case)

    @t78.RebuildFn
    def rebuild(_ctx, item):
        world.log.append(('rebuild_call', item, world.snapshot()))
        failure = c.c_char_p()
        return lib.inventory_view_rebuild(c.byref(fx.view), c.byref(world.model.inventory), c.byref(failure))

    fx.keep = fx.keep + (rebuild,)
    fx.host.inventory.inventory.rebuild_view = rebuild
    return fx


def normalise_log(log):
    events = []
    for entry in log:
        events.append(('rebuild_snapshot', entry[2]) if entry[0] == 'rebuild_call' else entry)
    return events


def native_view_state(view):
    return dict(screen=view.screen_state, mode=view.mode, tab=view.tab, tab_applied=view.tab_applied,
                hot=view.hot, event=view.event, slots=tuple(view.slot_item), lit=tuple(view.slot_lit))


def compare_dicts(label, native, original, keys, case):
    for key in keys:
        if native[key] != original[key]:
            raise OracleError((label, key, 'native', native[key], 'original', original[key], case))


def run_hover(lib, original, case):
    got = original.run('hover', case)
    consumed = expected_hover_consumed(case)
    names = got['entered']
    if (consumed is None) != ('cursor' not in names):
        raise OracleError(('mode gate disagrees with the original', case))
    if consumed is not None and got['consumed_seen'] != consumed:
        raise OracleError(('frame consumption disagrees with the independent model', case))
    ran_expected = consumed is False
    if ran_expected != ('scan' in names):
        raise OracleError(('slot scan reached disagrees', case))
    if got['events']:
        raise OracleError(('hover must not produce ordered effects', got['events']))
    if got['model'] != (case['held'], case['count'], tuple(case['list_words']), tuple(case['presence'])):
        raise OracleError(('hover changed the inventory model', case))
    # native, composed exactly as the app does (cursor choice -> hot point -> hover)
    view = native_view(lib, case)
    layout = native_layout(case)
    px, py = case['mouse']
    cursor_index_n, cursor_variant_n = case['pre_idx'], case['pre_var']
    ran = c.c_int(0)
    if case['mode'] in (2, 3):
        idx, var = c.c_int32(), c.c_int32()
        lib.inventory_view_cursor_choice(case['held'], case['override'], case['held_flag'],
                                         c.byref(idx), c.byref(var))
        cursor_index_n, cursor_variant_n = idx.value, var.value
        dx, dy = c.c_int32(), c.c_int32()
        if lib.inventory_view_cursor_hotspot(original.curs, len(original.curs), idx.value, var.value,
                                             c.byref(dx), c.byref(dy)) != 0:
            raise OracleError(('native refused a cursor hot point the original used', case))
        px, py = px + dx.value, py + dy.value
    status = lib.inventory_view_hover(c.byref(view), c.byref(layout), px, py, case['held'],
                                      int(bool(consumed)), c.byref(ran))
    if status != 0:
        raise OracleError(('native hover failed', status, case))
    # the variant is the native view's own cell (0x5b44f4): written by the hover on a hit
    mine = native_view_state(view)
    mine.update(cursor_index=cursor_index_n, cursor_variant=view.cursor_variant)
    cursor_variant_n = view.cursor_variant
    if bool(ran.value) != ran_expected:
        raise OracleError(('hover_ran disagrees', ran.value, ran_expected, case))
    orig = got['view']
    compare_dicts('hover', mine, orig, ('hot', 'event', 'slots', 'lit', 'mode', 'cursor_index', 'cursor_variant'),
                  case)
    if ran_expected:
        # 0x5d1631 := 0x5b160c + (index << 5) + (variant << 4), written by 0x4ee2a9 and again on a hit
        expected_rect = 0x5b160c + (cursor_index_n << 5) + (cursor_variant_n << 4)
        if orig['cursor_rect'] != expected_rect:
            raise OracleError(('cursor rectangle pointer differs', hex(orig['cursor_rect']), hex(expected_rect), case))
    if orig['screen'] != 3:
        raise OracleError('hover changed the screen state')
    hit = [i for i in range(16) if orig['lit'][i] == 1 and orig['slots'][i] != -1 and
           orig['hot'] == orig['slots'][i]]
    return got, ran_expected, bool(hit) and ran_expected and orig['cursor_variant'] == 1


def run_click(lib, original, case):
    """One click through 0x4e8dc8. Returns (original result, leaf, flags) or raises."""
    leaf, unsafe = classify_click(case)
    got = original.run('click', case, strict=True)
    fx = native_world(lib, case)
    consumed = bool(expected_click_consumed(case))
    before_model = fx.world.snapshot()
    status, result, failure = fx.click(frame_consumed=int(consumed))
    log = normalise_log(fx.world.log)
    if not fx.world.guards_intact():
        raise OracleError(('native wrote outside the arrays', case))
    mine_model, mine_view = fx.world.snapshot(), native_view_state(fx.view)
    orig = got['view']
    entered_click = 'click' in got['entered']
    return got, leaf, status, result, log, mine_model, mine_view, orig, before_model, entered_click, fx


def compare_click(lib, original, case, counters):
    leaf, unsafe = classify_click(case)
    case['leaf'] = leaf
    if leaf == 'unsafe':
        return compare_unsafe(lib, original, case, unsafe, counters)
    try:
        got, leaf, status, result, log, mine_model, mine_view, orig, before_model, entered_click, fx = \
            run_click(lib, original, case)
    except OracleError:
        raise
    except Exception as error:      # Unicorn fault inside the original's real rebuild
        counters['faulted'][type(error).__name__] = counters['faulted'].get(type(error).__name__, 0) + 1
        return None
    expect_entered = leaf not in ('closed-mode', 'closed-consumed')
    if entered_click != expect_entered and not (got['stop'] and leaf in ('read', 'use')):
        raise OracleError(('0x4e8e78 reached differs from the model', leaf, case))
    if leaf in ('read', 'use'):
        if got['stop'] != leaf:
            raise OracleError(('the original did not stop at the ' + leaf + ' branch', got['stop'], case))
        if status != iv.UNMODELED or log or mine_model != before_model:
            raise OracleError(('native must report UNMODELED without effect', status, log, case))
        if got['events'] or got['model'] != before_model:
            raise OracleError(('the original wrote before the ' + leaf + ' branch', case))
        compare_dicts('click', mine_view, orig, ('hot', 'event', 'slots', 'lit', 'mode', 'tab', 'tab_applied'), case)
        counters['leaf'][leaf] = counters['leaf'].get(leaf, 0) + 1
        return got
    if got['stop'] is not None:
        raise OracleError(('the original stopped at an unmodeled branch the native kernel ran', got['stop'], case))
    if status != t78.OK:
        raise OracleError(('native rejected a parity case', status, leaf, case))
    if log != got['events']:
        raise OracleError(('effect order mismatch', leaf, case, log, got['events']))
    if mine_model != got['model']:
        raise OracleError(('model state mismatch', leaf, case, mine_model, got['model']))
    compare_dicts('click', mine_view, orig, ('screen', 'hot', 'event', 'slots', 'lit', 'mode', 'tab', 'tab_applied'),
                  case)
    names = [e[0] for e in got['events']]
    flags = result.tuple()
    expected_flags = (int(expect_entered), int(leaf not in ('closed-mode', 'closed-consumed', 'none')),
                      int(leaf in ('pick', 'pick-close')), int(leaf in ('put', 'put-duplicate')),
                      int(leaf == 'pick-close'), names.count('view_sound'),
                      names.count('presence79'), names.count('presence'))
    if flags != expected_flags:
        raise OracleError(('result flags differ from the original', flags, expected_flags, leaf, case))
    if entered_click:
        handled = int(leaf not in ('none',))
        if got['eax'] != handled:
            raise OracleError(('0x4e8e78 return value differs', got['eax'], handled, leaf, case))
    if leaf in ('pick', 'pick-close', 'put', 'put-duplicate'):
        # 0x4e812f skips the page computation when the count is 0 or negative (0x4e831a, 0x4e8352)
        rebuilt_counts = [e[1][1] for e in got['events'] if e[0] == 'rebuild_snapshot']
        if any(n >= 1 for n in rebuilt_counts) and orig['page'] != 0:
            raise OracleError(('rebuild produced a nonzero page; native assumes page 0', orig['page'], case))
    if leaf == 'pick-close':
        if orig['screen'] != 0 or orig['mode'] != 0 or orig['tab'] != -1 or orig['tab_applied'] != -1:
            raise OracleError(('close state differs from the reset', orig, case))
        if orig['scroll_bits'] != 0:
            raise OracleError('close did not clear the scroll value +0x8252')
    counters['leaf'][leaf] = counters['leaf'].get(leaf, 0) + 1
    return got


def compare_unsafe(lib, original, case, reason, counters):
    """Unsafe original behaviour is observed, never a parity target; the native kernel
    must refuse before any persistent effect."""
    observed = 'not run'
    try:
        got = original.run('click', case, strict=False)
        observed = 'completed'
        if got['reads_beyond']:
            observed = 'completed, reads past the item array'
    except Exception as error:      # unmapped access
        observed = type(error).__name__
    fx = native_world(lib, case)
    before = fx.world.snapshot()
    status, result, failure = fx.click(frame_consumed=0)
    log = fx.world.log
    if status != t78.BOUNDS:
        raise OracleError(('native accepted an unsafe case', reason, status, case))
    if fx.world.snapshot() != before or fx.view.hot != case['hot'] or not fx.world.guards_intact():
        raise OracleError(('native changed state before refusing', reason, case))
    host_calls = [e[0] for e in log if e[0].endswith('_call')]
    if host_calls:
        raise OracleError(('native called the host before refusing', host_calls, case))
    counters['unsafe'][reason] = counters['unsafe'].get(reason, 0) + 1
    counters['unsafe_observed'][observed] = counters['unsafe_observed'].get(observed, 0) + 1
    return None


def compare_rebuild(lib, original, case, counters):
    got = original.run('rebuild', case)
    view = native_view(lib, case)
    world = native_world(lib, case)
    failure = c.c_char_p()
    status = lib.inventory_view_rebuild(c.byref(view), c.byref(world.world.model.inventory), c.byref(failure))
    tab = case['tab']
    orig = got['view']
    if 0x65 <= tab <= 0x69:
        if status != iv.TAB:
            raise OracleError(('native must refuse the derived tab lists', tab, status))
        counters['tab_refused'] += 1
        return False
    if status != 0:
        raise OracleError(('native rebuild failed', status, case))
    if tuple(view.slot_item) != orig['slots']:
        raise OracleError(('rebuild slots differ', case, tuple(view.slot_item), orig['slots']))
    if case['count'] >= 1 and orig['page'] != 0:
        raise OracleError(('original page is not 0', orig['page'], case))
    if got['model'] != (case['held'], case['count'], tuple(case['list_words']), tuple(case['presence'])):
        raise OracleError(('rebuild changed the inventory model', case))
    return True


# ------------------------------------------------------------------ observed unsafe originals
def observe_unsafe_original(lib, original):
    """The original on states outside its safe domain: observed and reported only."""
    rows = []

    def attempt(label, event=0x2717, **kw):
        kw.setdefault('kind', [0] * CAPACITY)
        case = base_case(900000 + len(rows), group='unsafe', event=event, **kw)
        reason = classify_click(case)
        if reason[0] != 'unsafe':
            raise OracleError(('unsafe observation is not classified unsafe', label, reason))
        try:
            got = original.run('click', case, strict=False)
            result = 'completed'
            events = [e[0] for e in got['events']]
            stray = len(got['reads_beyond'])
        except Exception as error:
            result, events, stray = type(error).__name__ + ': ' + str(error), [], 0
        fx = native_world(lib, case)
        before = fx.world.snapshot()
        status, _, why = fx.click(frame_consumed=0)
        if status != t78.BOUNDS or fx.world.snapshot() != before:
            raise OracleError(('native did not refuse an unsafe state', label, status))
        rows.append(dict(label=label, classified=reason[1], original=result, original_events=events,
                         original_reads_past_item_array=stray, native_status='INVVIEW_ERR_BOUNDS',
                         native_reason=(why or b'').decode()))

    attempt('pick up with a hot item above the tables', hot=70, held=-1, items=[1, 2], count=2)
    attempt('pick up with a negative hot item', hot=-2, held=-1, items=[1, 2], count=2)
    attempt('pick up with a count above the item array', hot=5, held=-1, items=[1, 2], count=75)
    full_without_nine = [i for i in range(CAPACITY) if i != 9] + [0x100]
    attempt('put back into a full list', event=0x2718, held=9, items=full_without_nine, count=70)
    attempt('put back of an id above the presence array', event=0x2718, held=100, items=[1, 2], count=2)
    attempt('put back with a count above the item array', event=0x2718, held=9, items=[1, 2], count=75)
    return rows


# ------------------------------------------------------------------ main
def main(*, library=None, report_path=REPORT, quick=False):
    started = time.monotonic()
    library_path = iv.build_library() if library is None else Path(library)
    lib = iv.bind(library_path)
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    if sha(pe.data) != EXE_HASH:
        raise OracleError('executable mismatch')
    windows = []
    for start, end, label, digest in CODE_WINDOWS:
        actual = sha(pe.image[start - pe.image_base:end - pe.image_base])
        if digest is not None and actual != digest:
            raise OracleError(f'code window mismatch: {label}')
        windows.append(dict(start=hex(start), end=hex(end), label=label, sha256=actual))
    original = ViewOriginal(pe)
    rng = random.Random(0x2022)

    hover = dict(cases=0, scan_ran=0, scan_hit=0, gate_closed=0, frame_consumed=0, by_group={})
    footprints = {}
    for case in hover_cases(rng, quick):
        got, ran, hit = run_hover(lib, original, case)
        hover['cases'] += 1
        hover['scan_ran'] += ran
        hover['scan_hit'] += hit
        hover['gate_closed'] += case['mode'] not in (2, 3)
        hover['frame_consumed'] += expected_hover_consumed(case) is True
        hover['by_group'][case['group']] = hover['by_group'].get(case['group'], 0) + 1
        for name in got['footprint']:
            footprints[name] = footprints.get(name, 0) + 1

    counters = dict(leaf={}, faulted={}, unsafe={}, unsafe_observed={}, tab_refused=0)
    click = dict(cases=0, parity=0)
    sequences = {}
    for case in click_cases(rng, quick):
        click['cases'] += 1
        got = compare_click(lib, original, case, counters)
        if got is not None:
            click['parity'] += 1
            key = ','.join(e[0] for e in got['events'])
            sequences[key] = sequences.get(key, 0) + 1
            for name in got['footprint']:
                footprints[name] = footprints.get(name, 0) + 1

    rebuild = dict(cases=0, parity=0)
    for case in rebuild_cases(rng, quick):
        rebuild['cases'] += 1
        rebuild['parity'] += compare_rebuild(lib, original, case, counters)

    unsafe = observe_unsafe_original(lib, original)
    parity_hooks = dict(sorted(original.hook_counts.items()))
    report = dict(
        slice='RT-22',
        scope='hover 0x4e89eb (0x4ee2a9, 0x4e8bb4), click 0x4e8dc8 -> 0x4e8e78 (pick up 0x4e93da with the real '
              'remove 0x4ea06c / rebuild 0x4e812f / close 0x4e7d04, put back 0x4e945c with the real add '
              '0x4e9e84 / UI animation 0x4e0559) and the rebuild 0x4e812f alone',
        original_sha256=EXE_HASH, code_windows=windows,
        native_sha256=sha(Path(library_path).read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        cases=hover['cases'] + click['parity'] + rebuild['parity'] + sum(counters['unsafe'].values()),
        hover=hover, click=dict(click, leaves=dict(sorted(counters['leaf'].items())),
                                original_faulted_no_parity=counters['faulted'],
                                native_rejected_unsafe=counters['unsafe'],
                                original_on_unsafe=counters['unsafe_observed'],
                                event_sequences=dict(sorted(sequences.items()))),
        rebuild=dict(rebuild, derived_tabs_refused_by_native=counters['tab_refused']),
        mismatches=0,
        write_footprint_classes=dict(sorted(footprints.items())),
        hooks=parity_hooks,
        original_decisions_replaced='none; host-boundary replacements and stops only (listed in hooks)',
        compared='hover: hot item, event dword, highlight flags of all 16 slots, slot items, cursor index and '
                 'variant, cursor rectangle pointer 0x5d1631, mode gate, frame-control consumption, scan '
                 'reached; click: ordered merged event log (pick/put markers, held store, remove entry and '
                 'stores, rebuild entry with the modeled snapshot, add entry, duplicate exit, UI request, '
                 'view sound and add sound requests with their slot, close entry and teardown), the final '
                 'inventory cells (held, count, 70 list words, 70 presence dwords), view slots, hot, event, '
                 'highlight flags, mode, tab, applied tab, screen state 0x583204, scroll value after close, '
                 'result flags (handled, picked, put back, closed, sound requests, removed, added), the '
                 '0x4e8e78 return value, the read/use branches reached without any prior store, write '
                 'footprint, callee-saved registers and stack balance; rebuild: the 16 slot dwords and page',
        not_compared=['view setup from the UIIV chunk (0x4e8622, 0x4e86ea): rectangles are written into '
                      'the original from the same layout, not derived by the original',
                      'screen-state dispatch 0x4d3106 / 0x43a7ca (the 0x583204 == 3 gate and the open transition)',
                      'what the replaced host functions do (sound manager, view/panel teardown, frame and tab '
                      'controls, 0x4d36ed)',
                      'read/examine 0x4ea269 and use 0x4e8f6d effects (stopped at the branch)',
                      'derived tab lists 0x65..0x69 and rebuild with a nonzero scroll value (+0x252 != 0, '
                      '0x4ef516): native returns INVVIEW_ERR_TAB or assumes page 0',
                      'rebuild of the first pass derived lists 0x583abd/0x583b49 and counters 0x583a2d/2f',
                      'view dword +0x7650 and loop scratch +0x822e (written by the original, not modeled)',
                      'cursor rectangle details written by 0x4ee2a9 into view +4..+0x14 and 0x5d162d/0x5d1639',
                      'page 0x825e after close (the original leaves it; the native close sets page 0)',
                      'items whose id is outside 0..69 inside the rebuilt window (the real 0x4e812f reads the '
                      'item type table out of range: attempted, a Unicorn fault is reported, not failed)'],
        unsafe_original_observations=unsafe,
        seconds=round(time.monotonic() - started, 2))
    report_path.write_text(json.dumps(report, indent=2, default=lambda o: sorted(o) if isinstance(o, set) else str(o)) + '\n')
    print(json.dumps({k: report[k] for k in ('cases', 'mismatches', 'seconds')}))
    print(json.dumps(dict(hover=hover['cases'], click_parity=click['parity'], click_total=click['cases'],
                          rebuild=rebuild['parity'], leaves=report['click']['leaves'])))
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--report', default=str(REPORT))
    parser.add_argument('--library')
    parser.add_argument('--quick', action='store_true')
    args = parser.parse_args()
    main(library=args.library, report_path=Path(args.report), quick=args.quick)
