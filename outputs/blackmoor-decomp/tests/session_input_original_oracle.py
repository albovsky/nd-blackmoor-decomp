#!/usr/bin/env python3
"""RT-2: unmodified x86 message wrappers, latch, caller guards and full 4f0059.

Only GetSystemMetrics(SM_SWAPBUTTON) and the MFC default-message host tail are
hooked. All input and hit-test decisions execute original instructions. Caller
windows have explicit stop PCs; they do not claim a whole 43a7ca/4d3073 run.
The full 4f0059 is executed with bounded, initialized inactive priority paths.
No original bytes, resource dumps, or emulated memory dumps enter the report.
"""
from __future__ import annotations
import argparse
import ctypes as c
import hashlib
import json
from pathlib import Path
import random
import struct
import subprocess
import sys

from matching_s08_2_original_oracle import (
    X86Machine, RETURN_SENTINEL, STACK_BASE, STACK_SIZE, FIXTURE_BASE)
from test_session_input import State, Context, Rect, Frame, Hotspot, TAIL, context, load_api
from unicorn import UC_HOOK_CODE
from unicorn.x86_const import UC_X86_REG_EIP, UC_X86_REG_ESP, UC_X86_REG_EBP, UC_X86_REG_EAX, UC_X86_REG_ECX

PROJECT = Path(__file__).resolve().parents[1]
WORK = PROJECT.parents[1] / 'work'
PIN = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
LATCH, CANDIDATE, CURSOR = 0x5830a6, 0x5c39e5, 0x583182
WRAPPERS = {0: 0x43ed71, 1: 0x43ec85, 2: 0x43ec4a}
HOOKS = [
    {'address': '0x51ab4b', 'boundary': 'MFC default-message host tail',
     'replacement': 'record ordered event and post-latch snapshot; return to wrapper'},
    {'iat': '0x52a498', 'boundary': 'GetSystemMetrics(SM_SWAPBUTTON)',
     'replacement': 'return 0 (unswapped fixture); verify argument 0x17'},
]
WINDOWS = [
    (0x43b194, 0x43b1a6, 'primary caller consume; alternate endpoint 43c0d1'),
    (0x43b1a6, 0x43b1d7, 'caller mode switch; table endpoints for modes 2..5'),
    (0x43bfb6, 0x43bfe0, 'candidate range/modal guard; reject endpoint 43c09c'),
    (0x43d134, 0x43d162, 'producer-disabled guard and candidate clear'),
    (0x4d3081, 0x4d3095, 'cursor-pass reset before UI update'),
    (0x4d30a9, 0x4d30ca, 'cursor-pass mode switch; UI endpoints 4d30f5..4d3119'),
]


def digest(data):
    return hashlib.sha256(data).hexdigest()


def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)


class Original:
    def __init__(self, exe):
        self.machine = X86Machine(exe)
        self.uc = self.machine.uc
        self.stops = set()
        self.visited = set()
        self.effects = []
        self.event = None
        self.hit_test_addresses = None
        self.uc.hook_add(UC_HOOK_CODE, self.hook)
        # Imported host pointer is fixture data, never an instruction patch.
        self.put(0x52a498, RETURN_SENTINEL + 0x100)
        self.mode_targets = struct.unpack('<4I', self.uc.mem_read(0x43d1c3, 16))
        self.scan_targets = (0x4d30f5, 0x4d3101, 0x4d310d, 0x4d3119)

    def put(self, address, value):
        self.uc.mem_write(address, struct.pack('<I', value & 0xffffffff))

    def word(self, address):
        return struct.unpack('<I', self.uc.mem_read(address, 4))[0]

    def signed(self, address):
        return struct.unpack('<i', self.uc.mem_read(address, 4))[0]

    def ret(self, pop, value=0):
        sp = self.uc.reg_read(UC_X86_REG_ESP)
        self.uc.reg_write(UC_X86_REG_EAX, value)
        self.uc.reg_write(UC_X86_REG_ESP, sp + 4 + pop)
        self.uc.reg_write(UC_X86_REG_EIP, self.word(sp))

    def hook(self, uc, address, size, data):
        del size, data
        self.visited.add(address)
        if self.hit_test_addresses is not None:
            self.hit_test_addresses.add(address)
        if address in self.stops:
            uc.emu_stop()
        elif address == 0x51ab4b:
            require(self.event is not None, 'unexpected MFC host-tail call')
            self.effects.append(('tail', self.event, self.snapshot()))
            self.ret(0)
        elif address == RETURN_SENTINEL + 0x100:
            sp = uc.reg_read(UC_X86_REG_ESP)
            require(self.word(sp + 4) == 0x17, 'unexpected metric query')
            self.ret(4)

    def snapshot(self):
        return (bytes(self.uc.mem_read(LATCH, 32)), self.signed(CANDIDATE))

    def init(self):
        self.uc.mem_write(LATCH, bytes(0x28))
        self.machine.call(0x4dad60, LATCH, (RETURN_SENTINEL,), bytes(32))
        self.put(CANDIDATE, -1)
        # Special hotspot slots are independently supplied, never defaulted in native.
        for address in (0x5b4e89, 0x5b5100):
            self.uc.mem_write(address, struct.pack('<h', -1))

    def window(self, entry, stops):
        self.stops = set(stops)
        sp = STACK_BASE + STACK_SIZE // 2
        self.uc.reg_write(UC_X86_REG_ESP, sp)
        self.uc.reg_write(UC_X86_REG_EBP, sp + 0x1000)
        self.uc.emu_start(entry, RETURN_SENTINEL, timeout=1000000, count=50000)
        pc = self.uc.reg_read(UC_X86_REG_EIP)
        self.stops = set()
        require(pc in stops, f'window {entry:x} failed to reach endpoint: {pc:x}')
        return pc

    def feed(self, kind, x, y, flags=0):
        self.event = (kind, flags, x, y)
        _, delta, _ = self.machine.call(WRAPPERS[kind], FIXTURE_BASE + 0x700,
            (RETURN_SENTINEL, flags, x & 0xffffffff, y & 0xffffffff), bytes(32))
        require(delta == 16, 'wrapper did not restore ret-12 ABI')
        self.event = None

    def tick(self, ctx):
        self.put(0x583204, ctx.cursor_mode)
        self.put(0x5c39e9, ctx.modal_event)
        endpoint = self.window(0x43b194, (0x43b1a6, 0x43c0d1))
        consumed = endpoint == 0x43b1a6
        normal = False
        accepted = False
        if consumed:
            endpoint = self.window(0x43b1a6, (0x43b1d7, *self.mode_targets))
            normal = endpoint == 0x43b1d7
            if normal:
                accepted = self.window(0x43bfb6, (0x43bfe0, 0x43c09c)) == 0x43bfe0
        self.effects.append(('consume', int(consumed), int(accepted), self.snapshot()))
        return consumed, normal, accepted

    def setup_geometry(self, ctx, spots, selected=-1):
        for i, value in enumerate((ctx.viewport.left, ctx.viewport.top,
                                   ctx.viewport.right, ctx.viewport.bottom)):
            self.put(CURSOR + 4 + i * 4, value)
        for i, value in enumerate((ctx.cursor.left, ctx.cursor.top,
                                   ctx.cursor.right, ctx.cursor.bottom)):
            self.put(0x583102 + i * 4, value)
        self.put(0x5bb587, ctx.scroll_y)
        self.put(0x583204, ctx.cursor_mode)
        self.put(0x5c39e9, ctx.modal_event)
        self.put(0x5839a9, ctx.producer_disabled)
        self.uc.mem_write(0x583a29, struct.pack('<h', selected))
        cursor_index = 0 if selected == -1 else selected + 0x25
        self.put(0x5b30cc + cursor_index * 16, ctx.hot_x)
        self.put(0x5b30d0 + cursor_index * 16, ctx.hot_y)
        self.put(0x5b30cc + cursor_index * 16 + 8, ctx.hot_x)
        self.put(0x5b30d0 + cursor_index * 16 + 8, ctx.hot_y)
        self.uc.mem_write(0x5b4e89, struct.pack('<h', ctx.excluded_0))
        self.uc.mem_write(0x5b5100, struct.pack('<h', ctx.excluded_1))
        count = max((s.index + 1 for s in spots), default=0)
        self.uc.mem_write(0x5c39e3, struct.pack('<h', count))
        self.uc.mem_write(0x5bb5e3, bytes(0x8d * count))
        for spot in spots:
            base = 0x5bb5e3 + spot.index * 0x8d
            # Real 0x6a cursor selection; bounded zero payload for its cursor metadata.
            self.uc.mem_write(base, b'\x6a')
            self.put(base + 2, FIXTURE_BASE + 0x100)
            self.put(base + 0x43, spot.active)
            self.uc.mem_write(base + 0x47, struct.pack('<4h', spot.rectangle.left,
                spot.rectangle.top, spot.rectangle.right, spot.rectangle.bottom))
        # Neutral priority paths. The original predicates remain live and execute.
        # Excluded slots below are inactive in cases which exclude them.
        for address in (0x5b5158, 0x5b61af, 0x5b615e):
            self.uc.mem_write(address, b'\x00')

    def scan(self, ctx, spots, selected=-1, expect_generic=True):
        self.setup_geometry(ctx, spots, selected)
        disabled_end = self.window(0x43d134, (0x43d13d, 0x43d162))
        if disabled_end == 0x43d162:
            self.effects.append(('scan', -1, self.snapshot()))
            return None
        self.window(0x4d3081, (0x4d3095,))
        endpoint = self.window(0x4d30a9, (0x4d30ca, *self.scan_targets))
        point = None
        if endpoint == 0x4d30ca:
            # Complete original 4f0059; no decision hook and no forced generic-loop entry.
            self.put(0x5b44f8, 0)
            self.hit_test_addresses = set()
            eax, delta, _ = self.machine.call(0x4f0059, CURSOR,
                                             (RETURN_SENTINEL,), bytes(0x1000))
            require(delta == 4, 'hit test returned with wrong ABI')
            if eax:
                require(0x4f1eb8 in self.hit_test_addresses,
                        'fixture reached an unmodeled priority path')
                point = (self.signed(CURSOR + 0x5e), self.signed(CURSOR + 0x5a))
            # A generic hit must be produced by the real loop, not a special path.
            if self.signed(CANDIDATE) >= 0 and expect_generic:
                require(0x4f1fab in self.hit_test_addresses, f'candidate {self.signed(CANDIDATE)} did not come from generic scan; generic_entry={0x4f1eb8 in self.hit_test_addresses}')
            self.hit_test_addresses = None
        self.effects.append(('scan', self.signed(CANDIDATE), self.snapshot()))
        return point


def compare(exe, library):
    original = Original(exe)
    api = load_api(library)
    counts = {'sequences': 0, 'events': 0, 'ticks': 0, 'scans': 0, 'state_comparisons': 0,
              'ordered_effect_comparisons': 0}
    spots = [Hotspot(34, Rect(388, 225, 492, 284), 1),
             Hotspot(35, Rect(396, 150, 489, 211), 1)]
    sequences = [
        [('scan',), ('event', 0, 440, 255), ('tick',)],
        [('scan',), ('event', 1, 440, 255), ('tick',)],
        [('event', 2, 440, 255), ('tick',), ('scan',), ('event', 2, 0, 0), ('tick',)],
        [('scan',), ('event', 1, 440, 255), ('event', 2, 0, 0),
         ('event', 2, -32768, 32767), ('tick',), ('tick',)],
        [('scan',), ('event', 2, 440, 255), ('event', 1, 440, 255), ('tick',)],
        [('scan',), ('inhibit', 1), ('event', 2, 440, 255), ('tick',)],
        [('scan',), ('event', 1, 440, 255), ('event', 0, 0, 0),
         ('event', 2, 0, 0), ('cursor', 0, 0), ('tick',), ('scan',),
         ('event', 2, 0, 0), ('tick',)],
    ]
    for mode in (0, 1, 2, 3, 4, 5, 6, -1, -2147483648, 2147483647):
        sequences.append([('scan',), ('event', 2, 440, 255), ('mode', mode),
                          ('tick',), ('scan',), ('tick',)])
    for modal in (0, 1, 0xffffffff):
        sequences.append([('scan',), ('event', 2, 440, 255), ('modal', modal),
                          ('tick',), ('tick',)])
    sequences.append([('scan',), ('event', 2, 440, 255), ('disabled', 1),
                      ('tick',), ('scan',), ('event', 2, 0, 0), ('tick',)])
    for x, y in [(-6, 10), (-5, 10), (630, 10), (629, 384), (10, -6),
                 (10, -5), (10, 385), (10, 384), (388+10, 225+10),
                 (492+10, 284+10), (493+10, 285+10)]:
        sequences.append([('cursor', x, y), ('scan',), ('event', 2, x, y), ('tick',)])
    for raw in (-2147483648, -2, -1, 0, 239, 240, 10000, 2147483647):
        sequences.append([('candidate', raw), ('event', 2, 0, 0), ('tick',), ('tick',)])
    # Every generated event sequence is compared independently, including repeated edges.
    rng = random.Random(0x525432)
    for _ in range(80):
        sequence = [('scan',)]
        for _ in range(30):
            operation = rng.randrange(7)
            if operation < 3:
                sequence.append(('event', operation, rng.randrange(-32768,32768),
                                  rng.randrange(-32768,32768)))
            elif operation == 3:
                sequence.append(('tick',))
            elif operation == 4:
                sequence.extend([('cursor', rng.randrange(-20,660), rng.randrange(-20,420)),
                                 ('scan',)])
            elif operation == 5:
                sequence.extend([('mode', rng.randrange(7)), ('tick',)])
            else:
                sequence.extend([('modal', rng.randrange(2)), ('tick',)])
        sequences.append(sequence)
    for seq_id, sequence in enumerate(sequences):
        original.init()
        state = State()
        require(api.session_input_init(c.byref(state)) == 0, 'native init failed')
        ctx = context()
        # Exercise selected hot point + scroll, as well as viewport origin itself.
        if seq_id % 3 == 1:
            ctx.hot_x, ctx.hot_y, ctx.scroll_y = 3, -2, 17
        selected = -1 if seq_id % 2 else 0
        native_effects = []
        tail = TAIL(lambda _, k, flags, x, y: native_effects.append(
            ('tail', (k,flags,x,y), (bytes(state.latch), state.candidate))))
        original.effects = []
        counts['sequences'] += 1
        for step_id, operation in enumerate(sequence):
            label = f'sequence {seq_id} step {step_id} {operation[0]}'
            kind = operation[0]
            if kind == 'event':
                _, event, x, y = operation
                original.feed(event,x,y)
                require(api.session_input_feed(c.byref(state),event,0,x,y,tail,None)==0,
                        label + ': native feed failed')
                counts['events'] += 1
            elif kind == 'tick':
                _consumed, _normal, accepted = original.tick(ctx)
                native_consumed = int.from_bytes(bytes(state.latch[:4]), 'little') != 0
                frame = Frame(71,0,0,0,0,0,0)
                require(api.session_input_tick(c.byref(state),c.byref(ctx),c.byref(frame))==0,
                        label + ': native tick failed')
                require(bool(frame.hotspot_activation_event and not frame.modal_event_active)==accepted,
                        label + ': candidate acceptance differs')
                require(frame.current_frame==71, label + ': current_frame overwritten')
                native_effects.append(('consume', int(native_consumed), int(
                    bool(frame.hotspot_activation_event and not frame.modal_event_active)),
                    (bytes(state.latch),state.candidate)))
                # Compare pointer production by executing the original transform prefix,
                # with the original selection and outside-viewport decision intact.
                if ctx.cursor_mode not in (2,3,4,5) and not ctx.producer_disabled:
                    original.setup_geometry(ctx, [], selected)
                    # setup_geometry never changes candidate or input latch.
                    original.uc.reg_write(UC_X86_REG_ECX, CURSOR)
                    original.window(0x4f0059, (0x4f0288,0x4f2576))
                    valid = original.uc.reg_read(UC_X86_REG_EIP)==0x4f0288
                    require(frame.pointer_valid==valid, label + ': sprite overlap differs')
                    if valid:
                        require((frame.pointer_x,frame.pointer_y)==(
                            original.signed(CURSOR+0x5e),original.signed(CURSOR+0x5a)),
                            label + ': coordinate transform differs')
                require(frame.cursor_context_allowed==int(bool(frame.pointer_valid) and
                    ctx.cursor_mode not in (2,3,4,5) and not ctx.producer_disabled),
                    label + ': cursor guard differs')
                counts['ticks'] += 1
            elif kind == 'scan':
                # Two active S0 spots, and full original priority fallthrough.
                try:
                    point = original.scan(ctx,spots,selected)
                except RuntimeError as exc:
                    raise RuntimeError(label + ': ' + str(exc)) from exc
                rows=(Hotspot*len(spots))(*spots)
                require(api.session_input_scan(c.byref(state),c.byref(ctx),rows,len(rows))==0,
                        label + ': native scan failed')
                native_effects.append(('scan', state.candidate,(bytes(state.latch),state.candidate)))
                counts['scans'] += 1
                del point
            elif kind == 'candidate':
                original.put(CANDIDATE,operation[1])
                require(api.session_input_publish_candidate(c.byref(state),operation[1])==0,
                        label + ': native publication failed')
            elif kind == 'inhibit':
                original.put(LATCH+8,operation[1]); state.latch[8]=operation[1]
            elif kind == 'cursor':
                x,y=operation[1:]; ctx.cursor=Rect(x,y,x+15,y+15)
            elif kind == 'mode': ctx.cursor_mode=operation[1]
            elif kind == 'modal': ctx.modal_event=operation[1]
            elif kind == 'disabled': ctx.producer_disabled=operation[1]
            else: raise RuntimeError('invalid operation')
            require(original.snapshot()==(bytes(state.latch),state.candidate),
                    label + f': native/original state differs; candidate={original.signed(CANDIDATE)}/{state.candidate}; latch offsets=' + str([i for i,(a,b) in enumerate(zip(original.snapshot()[0],bytes(state.latch))) if a!=b]))
            require(original.effects==native_effects,label + ': ordered effects differ')
            counts['state_comparisons'] += 1
            counts['ordered_effect_comparisons'] += 1
    # Overlapping rectangles prove first-hit selection, without a hooked predicate.
    original.init(); state=State(); api.session_input_init(c.byref(state)); ctx=context()
    overlap=[Hotspot(3,Rect(0,0,600,300),1),Hotspot(5,Rect(0,0,600,300),1)]
    original.scan(ctx,overlap)
    rows=(Hotspot*2)(*overlap)
    require(api.session_input_scan(c.byref(state),c.byref(ctx),rows,2)==0,'overlap native error')
    require(state.candidate==3==original.signed(CANDIDATE),'first-hit selection differs')
    counts['scans'] += 1; counts['state_comparisons'] += 1
    for field in ('excluded_0', 'excluded_1'):
        setattr(ctx, field, 3)
        original.scan(ctx, overlap, expect_generic=False)
        before = bytes(state)
        require(api.session_input_scan(c.byref(state), c.byref(ctx), rows, 2)==3,
                'active special-slot hit must return priority limit')
        require(bytes(state)==before, 'special-slot limit mutated native state')
        require(original.signed(CANDIDATE)==3, 'original special slot did not win')
        overlap[0].active = 0
        rows=(Hotspot*2)(*overlap)
        original.scan(ctx, overlap)
        require(api.session_input_scan(c.byref(state), c.byref(ctx), rows, 2)==0,
                'inactive special-slot native error')
        require(state.candidate==5==original.signed(CANDIDATE), 'inactive special-slot selection differs')
        overlap[0].active = 1
        rows=(Hotspot*2)(*overlap)
        setattr(ctx, field, -1)
        counts['scans'] += 1; counts['state_comparisons'] += 1
    counts['original_special_hit_native_limit_cases'] = 2
    return counts, original.visited


def mutations(exe, directory):
    source=(PROJECT/'src/session_input.c').read_text()
    variants={
        'wrong_offset': ('wrapping_sub(context->cursor.left, context->viewport.left)',
                         'wrapping_add(context->cursor.left, context->viewport.left)'),
        'unconditional_release_without_candidate': ('(uint32_t)state->candidate);', '0);'),
        'require_down_for_release': ('status = input_latch_up(&view, flags, 0, (uint32_t)state->candidate);',
            'status = input_latch_up(&view, flags, 0, state->latch[12] == 1 ? (uint32_t)state->candidate : UINT32_MAX);'),
        'edge_never_cleared': ('/* 43b199 consume precedes',
            'if (consumed) state->latch[0] = 1;\n    /* 43b199 consume precedes'),
    }
    results=[]
    directory.mkdir(parents=True,exist_ok=True)
    for name,(old,new) in variants.items():
        require(source.count(old)==1,f'ambiguous mutant {name}')
        path=directory/(name+'.c'); path.write_text(source.replace(old,new))
        library=directory/('lib'+name+'.dylib')
        subprocess.run(['xcrun','clang','-std=c11','-O2','-Wall','-Wextra','-Wpedantic','-Werror',
            '-dynamiclib','-I',str(PROJECT/'src'),str(path),str(PROJECT/'src/input_latch.c'),
            str(PROJECT/'src/input_consume.c'),'-o',str(library)],check=True,capture_output=True)
        try:
            compare(exe,library)
        except RuntimeError as exc:
            results.append({'mutation':name,'detected':True,'first_failure':str(exc),
                            'native_sha256':digest(library.read_bytes())})
        else:
            raise RuntimeError(f'oracle failed to detect {name}')
    return results


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--original',type=Path,default=WORK/'original/GAME.EXE')
    parser.add_argument('--library',type=Path,default=PROJECT/'build/libsession_input.dylib')
    parser.add_argument('--report',type=Path,default=WORK/'analysis/slices/RT-2.original-oracle.json')
    parser.add_argument('--mutations',action='store_true')
    args=parser.parse_args()
    require(digest(args.original.read_bytes())==PIN,'original executable pin mismatch')
    # Assert message map from immutable file bytes, including WM_MOUSEMOVE.
    image=args.original.read_bytes()
    for row,message,address in ((0,0x202,WRAPPERS[2]),(1,0x201,WRAPPERS[1]),(2,0x200,WRAPPERS[0])):
        record=struct.unpack_from('<6I',image,0x12c810+24*row)
        require(record[0]==message and record[5]==address,'original message-map mismatch')
    counts,visited=compare(args.original,args.library)
    index=json.loads((PROJECT/'function-index.json').read_text())
    starts=sorted(int(row['address'],16) for row in index['functions'])
    functions=[]
    for address in [*WRAPPERS.values(),0x4dad60,0x4daf9f,0x4dafc3,0x4db000,0x4daf3f,0x4f0059]:
        end=starts[starts.index(address)+1]
        functions.append({'va':hex(address),'indexed_end_exclusive':hex(end),
                          'sha256':digest(image[address-0x400000:end-0x400000])})
    report={'slice':'RT-2','status':'bounded_original_native_comparison_passed',
        'original_sha256':PIN,'native_sha256':digest(args.library.read_bytes()),
        'counts':counts,'mismatches':0,'hooks':HOOKS,'code_functions':functions,
        'caller_windows':[{'start':hex(a),'end':hex(b),'scope':s,
                           'sha256':digest(image[a-0x400000:b-0x400000])} for a,b,s in WINDOWS],
        'full_4f0059_executed':True,'decision_hooks':[],
        'unique_executed_instruction_addresses':len(visited),
        'mutations':mutations(args.original,WORK/'analysis/slices/RT-2.mutants') if args.mutations else [],
        'packet_correction':'Original accepts release without down when candidate != -1. The unconditional-release mutant removes the candidate guard; the converse require-down mutant is also detected.',
        'unverified':['Entire 43a7ca tick and 4d3073 cursor/OS/render lifecycle',
                      'Live composed cursor geometry, OS polling/warping and hot-point resource provider',
                      'Active UI/puzzle/navigation priority paths and special event handlers',
                      'Dependency/modal producers and primary/right-button polling beyond the tested caller gates',
                      'MFC default-message processing beyond its enumerated host boundary',
                      'Native app integration, independent review and full gameplay'],
        'contains_original_byte_values':False}
    args.report.parent.mkdir(parents=True,exist_ok=True)
    args.report.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'report':str(args.report),'counts':counts,'mismatches':0,
                      'mutants_detected':len(report['mutations'])}))
    return 0

if __name__=='__main__':
    try:
        raise SystemExit(main())
    except (RuntimeError,OSError,ValueError,subprocess.CalledProcessError) as exc:
        print(f'RT-2 original oracle failed: {exc}',file=sys.stderr)
        raise SystemExit(1)
