#!/usr/bin/env python3
"""RT-12: immutable x86 dispatcher 0x427a50 versus the C kernel and binding.

The unmodified GAME.EXE image is mapped under Unicorn. The real dispatcher
(0x427a50) runs one or several raw-0x83 rows: gate 0x423f57 and dependency
reducer 0x4234c8, handler 0x4e72fb, lookup 0x4e444d, refresh 0x4e0559 and the
completion byte store at 0x42973b are all original x86.

Hooks (complete inventory, nothing else is installed):
  * 0x51dc43 (malloc) is REPLACED by the base harness and is reached only
    while the original dependency loader 0x424aa8 builds each row's tree.
  * 0x425b8b and 0x425b40 (debug tree printer and malformed-tree stop) are
    reached only on malformed dependency input. They are replaced by RAISING
    guards here: reaching either fails the run, so no decision is stubbed.
  * UC_HOOK_CODE observer: reads registers and memory, never writes either.
  * UC_HOOK_MEM_WRITE observer: classifies every store; unclassified stores
    outside the stack/arena fail the run.
  * UC_HOOK_MEM_READ observer over the 74-byte body windows: any read past a
    body fails the run.
No Windows API, audio or GUI is started. Mutable inputs written by this
harness are original global storage (lists, counters, UI table, event flags,
action rows) exactly as the original loader/engine would have left them.
"""
import argparse
from collections import Counter
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import tempfile

import conditions_nested_original_oracle as deps
from cif_original_oracle import DEFAULT_EXE
import test_action_family_83_runtime as n

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
CORPUS_HASH = 'e45d78dd50efe45e8b53b781100e9fe17b8c513b797c0fd039a032b054891236'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
CODE = [
 (0x427a50, 0x42ac91, '8755d78473a6ad4fda0b1becb5b1d5204e32c733fc11f155acf1d8af1d0c7111'),
 (0x4e72fb, 0x4e7512, '3874a0680c241dc208291d7f7869de37e95da220eb99b5deb49558cfa0f3c379'),
 (0x4e444d, 0x4e45c1, 'f96ca89f96ce6e4e01262b15da3a353c0c41fc797a1bf457fbfb44ce3b27ab4d'),
 (0x4e0559, 0x4e0619, '3588d6413d5da5a05d2f2b95f48f83c09d778652ca01c5c4d85d9345377831b1'),
 (0x4e2e05, 0x4e2faa, '403e9dd3794e6b312cddbc0aabc5064fc7e5ad46ba84e3180fc34098e605ec25'),
 (0x4e4337, 0x4e4428, 'cc3f8179f7ac4fe258c213ae474393b32617ca8faa06331cdaff3a1a499299a3'),
 (0x4234c8, 0x425b8b, 'f5a72186599573e613a5f6fcfd8dd79dbc35a92d3fe88c998215921d3918bbc7'),
]
SLOT = 0x5bb5b3
ROW = 0x8d
MAIL, WEB = 0x5a2664, 0x5a434c
MAIL_COUNT, WEB_COUNT = 0x5a1e5e, 0x5a1e60
UI_TABLE = 0x5a1620  # five ActionUIControlGroup records
UI_BASE = 0x5a17b4  # group 0 availability (record +0x194); the three flags follow
UI_STRIDE = 0x1a4
INPUT = 0x20008000
BODY_STRIDE = 0x100
TAIL_BASE = 0x2000a000
PHONE = 0x57975c
REFRESH_THIS = 0x570508
PHASE = 0x7f
CAP = 8
EVENT_BASE = 0x585801
COMPLETE_OFFSET = 0x72
STACK = (0x10000000, 0x10010000)
ENGINE = deps.ENGINE_THIS

# Stores the dispatcher performs outside the phone state, with their meaning.
# Anything else in the image data range fails the run.
EXPECTED_OTHER = {
    0x5c3a47: (4, 'gate 0x423f57 stores (dependency count == 0) into this global'),
    0x63786d: (0x620, 'dependency evaluator state inside the engine object: 0x4234c8 resets the counter at +4, '
                      'the reducer pushes 12-byte entries, 0x423f57 stores the dependency pointer at +0x614'),
}
EXPECTED_ROW_FIELDS = {
    0x36: 'dependency evaluation result stored by 0x424201 (executor/dependency-provider state)',
    0x72: 'completion byte 0x42973b',
    0x73: 'dispatcher resets this DWORD before every visit of an incomplete row (0x427ad4)',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def require(ok, why):
    if not ok:
        raise AssertionError(why)


def seed_keys(branch, count):
    mail = [b'older', b'subject', b'subject', b'KEY', b'key', b'', b'x' * 32, b'CMLH02']
    web = [b'older', b'KEY', b'key', b'subject', b'subject', b'', b'x' * 32, b'CURL02']
    return (web if branch else mail)[:count]


class Original(deps.OriginalMachine):
    def __init__(self):
        super().__init__(DEFAULT_EXE)
        from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_WRITE, UC_HOOK_MEM_READ
        self.events = []
        self.entries = Counter()
        self.active = False
        self.rows = 0
        self.coverage = Counter()
        self.other_writes = Counter()
        self.row_writes = Counter()
        self.selected = []
        self.write_order = []
        self.machine.hook_add(UC_HOOK_CODE, self.observe)
        self.machine.hook_add(UC_HOOK_MEM_WRITE, self.observe_write)
        self.machine.hook_add(UC_HOOK_MEM_READ, self.observe_read)
        for start, end, digest in CODE:
            require(sha(self.pe.image[start - self.pe.image_base:end - self.pe.image_base]) == digest,
                    'code pin mismatch %#x' % start)

    def _on_code(self, uc, address, size, user):
        # The base class replaces the diagnostic printer; here it may never run.
        if address != deps.ORIGINAL_ALLOCATOR:
            raise AssertionError('unexpected diagnostic/fatal path %#x' % address)
        super()._on_code(uc, address, size, user)

    # -- observers (read only) -------------------------------------------
    def observe_read(self, uc, access, address, size, value, user):
        if not self.active:
            return
        for i in range(self.rows):
            base = INPUT + i * BODY_STRIDE
            if base <= address < base + BODY_STRIDE:
                require(address + size <= base + 74, 'out of body read %#x' % address)

    def observe_write(self, uc, access, address, size, value, user):
        if not self.active:
            return
        if STACK[0] <= address < STACK[1] or address >= deps.ARENA_START:
            return
        for i in range(self.rows):
            base = INPUT + i * BODY_STRIDE
            require(not (base <= address < base + BODY_STRIDE), 'body input write')
        if UI_TABLE <= address < UI_TABLE + 5 * UI_STRIDE:
            group, rest = divmod(address - UI_TABLE, UI_STRIDE)
            require(rest in (0x194, 0x198, 0x19c, 0x1a0) and size == 4, 'unexpected UI-table store %#x' % address)
            self.write_order.append(('available', group, None, value) if rest == 0x194
                                    else ('flag', group, (rest - 0x198) // 4, value))
        elif SLOT <= address < SLOT + self.rows * ROW:
            row, offset = divmod(address - SLOT, ROW)
            require(offset in EXPECTED_ROW_FIELDS, 'unexpected row store +%#x' % offset)
            self.row_writes[offset] += 1
            if offset == COMPLETE_OFFSET:
                self.write_order.append(('complete', row, value))
        elif address in (MAIL_COUNT, WEB_COUNT) or MAIL <= address < MAIL + CAP * 74 or WEB <= address < WEB + CAP * 41:
            self.write_order.append(('list', address))
        elif MAIL <= address < MAIL + 7400 or WEB <= address < WEB + 4100:
            raise AssertionError('store beyond harness list guard %#x' % address)
        else:
            hit = [a for a, (extent, _) in EXPECTED_OTHER.items() if a <= address < a + extent]
            require(hit, 'unclassified original store %#x' % address)
            self.other_writes[hit[0]] += 1

    def observe(self, uc, address, size, user):
        if not self.active:
            return
        if address in (0x427a50, 0x423f57, 0x4234c8, 0x4e444d, 0x4e72fb, 0x4e0559):
            self.entries[hex(address)] += 1
        if address in (0x4e739e, 0x4e7488):
            from unicorn.x86_const import UC_X86_REG_EBP
            frame = uc.reg_read(UC_X86_REG_EBP)
            self.selected.append(struct.unpack('<h', uc.mem_read(frame - 8, 2))[0])
        if address in (0x4e7340, 0x4e739e, 0x4e746b, 0x4e7488):
            self.coverage[hex(address)] += 1
        if address == 0x4e0559:
            sp = uc.reg_read(self._reg_esp)
            args = struct.unpack('<3I', uc.mem_read(sp + 4, 12))
            # Group and child are signed words; active is a DWORD.
            self.events.append(('refresh', C.c_int16(args[0]).value, args[1], C.c_int16(args[2]).value,
                                self.snapshot(), self.completed_vector()))
        elif address == 0x4e750a:  # epilogue of 0x4e72fb: refresh has returned
            self.events.append(('ui', self.ui_state()))

    # -- machine state helpers --------------------------------------------
    def write(self, address, data):
        self.machine.mem_write(address, bytes(data))

    def snapshot(self):
        return (struct.unpack('<h', self.machine.mem_read(MAIL_COUNT, 2))[0], bytes(self.machine.mem_read(MAIL, CAP * 74)),
                struct.unpack('<h', self.machine.mem_read(WEB_COUNT, 2))[0], bytes(self.machine.mem_read(WEB, CAP * 41)))

    def ui_state(self):
        out = []
        for g in range(5):
            out.extend(struct.unpack('<4i', self.machine.mem_read(UI_BASE + g * UI_STRIDE, 16)))
        return tuple(out)

    def completed_vector(self):
        return tuple(self.machine.mem_read(SLOT + i * ROW + COMPLETE_OFFSET, 1)[0] for i in range(self.rows))

    def phase_vector(self):
        return tuple(struct.unpack('<I', self.machine.mem_read(SLOT + i * ROW + PHASE, 4))[0] for i in range(self.rows))

    def poison_ui(self):
        for g in range(5):
            self.write(UI_BASE + g * UI_STRIDE,
                       struct.pack('<4i', 0x11110000 + g, 0x22220000 + 3 * g, 0x22220001 + 3 * g, 0x22220002 + 3 * g))

    def seed_world(self, native):
        self.write(MAIL, bytes(native.mail)[:CAP * 74])
        self.write(WEB, bytes(native.web)[:CAP * 41])
        self.write(MAIL_COUNT, struct.pack('<hh', native.world.mail_count, native.world.web_count))
        self.poison_ui()

    def setup(self, rows, flags=None):
        """rows: list of dict(data, tail, subtype, completed, phase)."""
        self.active = False
        self.rows = len(rows)
        self.events = []
        self.selected = []
        self.write_order = []
        self.write(SLOT, bytes(ROW * len(rows)))
        self.arena_cursor = deps.ARENA_START
        self.write(0x63a4cd, bytes(2))  # diagnostics flag: logging disabled as in the original default
        for i, row in enumerate(rows):
            base = SLOT + i * ROW
            self.write(INPUT + i * BODY_STRIDE, row['data'])
            self.write(base + 0x30, bytes([0x83, row.get('subtype', 1)]) + struct.pack('<I', INPUT + i * BODY_STRIDE))
            tail = row.get('tail', b'')
            storage = TAIL_BASE + i * 0x80
            self.write(storage, tail or bytes(16))
            _, ok = self.call(0x424aa8, [base, 124, 124 + len(tail), storage], ENGINE)
            require(ok, 'original dependency construction failed')
            self.write(base + COMPLETE_OFFSET, bytes([row.get('completed', 0)]))
            self.write(base + PHASE, struct.pack('<I', row.get('phase', 0)))
        self.write(0x5c39e3, struct.pack('<h', len(rows)))
        self.write(0x583999, struct.pack('<I', 3))
        self.write(EVENT_BASE, bytes(3000 * 4))
        for flag, value in (flags or {}).items():
            self.write(EVENT_BASE + flag * 4, struct.pack('<i', value))

    def dispatch(self):
        self.active = True
        self.events = []
        self.selected = []
        self.write_order = []
        self.write(0x5c3a47, bytes(4))
        _, ok = self.call(0x427a50, [], 0)
        self.active = False
        require(ok, 'original dispatcher failed')
        # Order contract of the original, independent of any native model:
        # a row's refresh -> its two UI stores -> completion of that row.
        pending = None
        for item in self.write_order:
            if item[0] == 'available':
                require(pending is None, 'availability store while a refresh is pending')
                pending = [item]
            elif item[0] == 'flag':
                require(pending is not None and len(pending) == 1, 'flag store before availability store')
                pending.append(item)
                require(item[3] == 1 and pending[0][3] == 1 and pending[0][1] == item[1] == 3, 'unexpected UI store values')
            elif item[0] == 'complete':
                require(pending is not None and len(pending) == 2, 'completion without preceding UI refresh stores')
                require(item[2] == 1, 'completion byte value')
                pending = None
        require(pending is None, 'refresh stores without completion')
        return self.completed_vector(), self.phase_vector()

    def refresh_call(self, group, active, child):
        self.active = False
        _, ok = self.call(0x4e0559, [group, active, child], REFRESH_THIS)
        require(ok, 'original refresh did not return')
        return self.ui_state()

    def init_lists(self, uicl):
        self.active = False
        source = 0x20009000
        self.write(source, uicl)
        _, ok = self.call(0x4e4337, [source, len(uicl)], PHONE)
        require(ok, 'UICL copy failed')
        # Enter the initializer block AFTER the unrelated contact sorting
        # call. This is explicitly a basic-block entry (not a full startup).
        from unicorn import x86_const as r
        frame = deps.STACK_TOP
        self.write(frame, struct.pack('<II', 0, deps.RETURN_SENTINEL))
        self.write(frame - 4, struct.pack('<I', PHONE))
        self.machine.reg_write(r.UC_X86_REG_EBP, frame)
        self.machine.reg_write(r.UC_X86_REG_ESP, frame - 0x20)
        self.machine.reg_write(r.UC_X86_REG_EFLAGS, 0x202)
        self.machine.emu_start(0x4e2e64, deps.RETURN_SENTINEL, count=1000000)
        require(self.machine.reg_read(r.UC_X86_REG_EIP) == deps.RETURN_SENTINEL, 'initializer block did not return')


class Native(n.Native):
    """Native side. Every logged event is read from real library state."""
    def __init__(self, lib, fill=0xA7):
        super().__init__(lib, CAP, fill)


def seeded_native(lib, mail_count, web_count, fill=0xA7):
    native = Native(lib, fill)
    for branch, count in ((0, mail_count), (1, web_count)):
        rows = native.web if branch else native.mail
        for i, key in enumerate(seed_keys(branch, count)):
            rows[i][:len(key) + 1] = key + b'\0'
    native.world.mail_count, native.world.web_count = mail_count, web_count
    return native


def corpus():
    source = PRIVATE / 'A-83.1.corpus.json'
    require(sha(source.read_bytes()) == CORPUS_HASH, 'corpus pin')
    manifest = ROOT / 'work/analysis/hiff-resources.json'
    require(sha(manifest.read_bytes()) == MANIFEST_HASH, 'manifest pin')
    inventory = {int(x['index']): x for x in json.loads(manifest.read_text())['resources']}
    result = []
    for row in json.loads(source.read_text())['records']:
        blob = (ROOT / f"work/analysis/hiff-resources/{row['resource_index']:04d}.bin").read_bytes()
        require(sha(blob) == inventory[row['resource_index']]['sha256'], 'resource pin')
        b = blob[row['raw_body_offset']:row['raw_body_offset'] + row['raw_body_length']]
        require(sha(b) == row['body_sha256'], 'body pin')
        result.append((row, b))
    boot_index = [i for i, x in inventory.items() if x['name'] == 'BOOT']
    require(len(boot_index) == 1, 'ambiguous BOOT resource')
    boot_index = boot_index[0]
    boot = (ROOT / f'work/analysis/hiff-resources/{boot_index:04d}.bin').read_bytes()
    require(sha(boot) == inventory[boot_index]['sha256'], 'BOOT pin')
    require(boot.count(b'UICL') == 1, 'ambiguous UICL')
    pos = boot.index(b'UICL')
    length = int.from_bytes(boot[pos + 4:pos + 8], 'big')
    uicl = boot[pos + 8:pos + 8 + length]
    require(len(uicl) == length and length >= 0xda1, 'UICL extent')
    return result, uicl


def refresh_only(events):
    """Kernel-only runs have no session: compare refresh calls, lists and arguments."""
    return [e[:5] for e in events if e[0] == 'refresh']


def compare_runtime(lib, o, data, tail, event, phase, subtype, index, completed, mail_count, web_count):
    """Kernel only (no session): lists, refresh arguments/ordering, completion."""
    native = seeded_native(lib, mail_count, web_count)
    o.seed_world(native)
    rows = [dict(data=bytes(74), subtype=1, completed=1) for _ in range(index)]
    rows.append(dict(data=data, tail=tail, subtype=subtype, completed=completed, phase=phase))
    o.setup(rows, {2075: event})
    before = o.snapshot()
    done, phases = o.dispatch()
    gate_true = (not tail) or event == 1
    applied = any(e[0] == 'ui' for e in o.events)
    require(applied == (gate_true and not completed), 'original gate/completed decision mismatch')
    status, out, failure = native.step(data, phase, subtype, completed, int(gate_true))
    require(status == 0, f'native runtime failed {failure}')
    require((out.completed, out.phase) == (done[index], phases[index]), 'runtime completion/phase mismatch')
    require(o.snapshot() == native.snapshot(), 'runtime list/selection mismatch')
    require(refresh_only(o.events) == refresh_only(native.events), 'runtime refresh order/argument mismatch')
    if applied:
        require(len(o.selected) == 1 and out.selected == o.selected[0], 'runtime selected index mismatch')
        require(out.list == (1 if int.from_bytes(data[:2], 'little') else 0), 'runtime list kind mismatch')
    else:
        require(o.snapshot() == before, 'gate-false/completed state changed')
        require(not native.events and not o.selected, 'effect without gate')
    require(bytes(o.machine.mem_read(INPUT + index * BODY_STRIDE, 74)) == data, 'original body mutation')
    return len(o.events), int(applied)


class SessionFixture:
    """Real scene executor + session + binding; all rows are 0x83."""
    def __init__(self, lib, native, rows, flags):
        self.lib = lib
        self.native = native
        host = n.Host(C.pointer(native.world), native.backend)
        self.binding = lib.session_a83_create(C.byref(host))
        require(self.binding, 'binding allocation')
        self.host = host
        actions = [n.s.action(0x83, r.get('subtype', 1), r['data'] + r.get('tail', b'')) for r in rows]
        self.scene, self.owner = n.s.open_scene(lib, actions)
        require(lib.session_a83_begin_scene(self.binding, self.scene) == 0, 'binding loader failed')
        self.flags, self.world, self.conditions = n.s.make_world(3000)
        for flag, value in (flags or {}).items():
            self.flags[flag] = value
        self.bindings = (n.s.Binding * 1)(n.s.Binding(0x83, 16, C.cast(lib.session_a83_handler, n.s.ActionFn), self.binding))
        cfg = n.s.SessionConfig()
        cfg.scene = self.scene
        cfg.scene_id = 4808
        cfg.action_core_world = C.pointer(self.world)
        cfg.conditions = C.pointer(self.conditions)
        cfg.action_bindings = self.bindings
        cfg.action_binding_count = 1
        self.prepare = n.s.PrepareFn(lambda *_: 0)
        self.media = n.s.MediaFn(lambda *_: 0)
        cfg.prepare_tick = self.prepare
        cfg.advance_media_one = self.media
        self.cfg = cfg
        self.session = C.c_void_p()
        failure = n.s.SceneSessionFailure()
        require(lib.scene_session_create(C.byref(cfg), C.byref(self.session), C.byref(failure)) == 0, 'session create')
        native.session = self.session
        native.rows = len(rows)
        self.poison_ui()

    def poison_ui(self):
        ui = self.lib.scene_session_get_action_ui(self.session).contents
        for g in range(5):
            ui.controls[g].availability = 0x11110000 + g
            for k in range(3):
                ui.controls[g].flags[k] = 0x22220000 + 3 * g + k

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.scene_resource_close(self.scene)
        self.lib.session_a83_destroy(self.binding)

    def tick(self):
        out = n.s.SceneSessionTickResult()
        require(self.lib.scene_session_tick(self.session, C.byref(out)) == 0, 'binding tick failed')
        states = []
        for i in range(self.native.rows):
            state = n.s.RuntimeState()
            require(self.lib.scene_session_get_action_state(self.session, i, C.byref(state)) == 0, 'state read')
            states.append((state.completed, state.phase))
        return states


def compare_binding(lib, o, rows, flag_updates, mail_count, web_count):
    """Real executor/binding versus the original dispatcher, visit by visit."""
    native = seeded_native(lib, mail_count, web_count)
    o.seed_world(native)
    flags = {2075: 0}
    fixture = SessionFixture(lib, native, rows, flags)
    visits = 0
    try:
        o.setup(rows, flags)
        for visit in range(len(flag_updates) + 2):
            native.events = []
            done, phases = o.dispatch()
            states = fixture.tick()
            require(native.pad_intact(), 'binding overran the list guard rows')
            require([s[0] for s in states] == list(done), 'binding completion/gate mismatch')
            require([s[1] for s in states] == list(phases), 'binding phase mismatch')
            require(native.snapshot() == o.snapshot(), 'binding list/selection mismatch')
            require(native.events == o.events, 'binding merged effect order mismatch')
            require(native.ui_state() == o.ui_state(), 'shared UI table mismatch')
            visits += 1
            if visit < len(flag_updates):
                flag, value = flag_updates[visit]
                fixture.flags[flag] = value
                o.write(EVENT_BASE + flag * 4, struct.pack('<i', value))
    finally:
        fixture.close()
    return visits


def compare_refresh(lib, o, count):
    """0x4e0559 (active=1) versus scene_session_mark_ui_dirty for every pair."""
    native = seeded_native(lib, 0, 0)
    fixture = SessionFixture(lib, native, [dict(data=n.raw())], {})
    try:
        for group in range(5):
            for child in range(3):
                o.poison_ui()
                fixture.poison_ui()
                expected = o.refresh_call(group, 1, child)
                require(lib.scene_session_mark_ui_dirty(fixture.session, group, child) == 0, 'mark failed')
                require(native.ui_state() == expected, 'refresh table mismatch %d,%d' % (group, child))
                count['refresh_pairs'] += 1
    finally:
        fixture.close()


def run(args):
    lib = n.bind(args.library) if args.library else n.build()
    o = Original()
    records, uicl = corpus()
    counts = Counter()
    branches = Counter()
    # Startup list initialisation: real BOOT UICL plus opposite/empty/one-sided.
    synthetic = bytearray(0xda1)
    synthetic[0xccb:0xccb + 70] = b'subject\0'.ljust(33, b'X') + b'body\0'.ljust(33, b'Y') + struct.pack('<hh', -7, 9)
    synthetic[0xd11:0xd11 + 39] = b'web\0'.ljust(33, b'Z') + struct.pack('<hhh', -32768, -1, 12)
    mail_only = bytearray(synthetic)
    mail_only[0xd11] = 0
    web_only = bytearray(synthetic)
    web_only[0xccb] = 0
    for init in (uicl, bytes(synthetic), bytes(mail_only), bytes(web_only), bytes(0xda1)):
        native = Native(lib, 0xA7)
        o.seed_world(native)
        o.init_lists(init)
        require(lib.action83_initialize(C.byref(native.world), n.storage(init), len(init)) == 0, 'native init')
        require(o.snapshot() == native.snapshot(), 'initial UICL list mismatch')
        counts['initializer_cases'] += 1

    cases = []  # (data, tail, subtype, action index, synthetic)
    for row, data in records:
        branches['web' if int.from_bytes(data[:2], 'little') else 'mail'] += 1
        cases.append((data[:74], data[74:], row['subtype'], row['action_index'], False))
    for branch in (0, 1, -1, -32768, 32767):
        for key in (b'subject', b'KEY', b'key', b'', b'x' * 32, b'\x80\xff', b'older', b'CMLH01', b'CMLH02', b'CURL02'):
            for field in (-32768, -1, 0, 32767):
                cases.append((n.raw(branch, key, text=b'T' * 32, field=field, word_a=-32768, word_b=32767), b'', 2, 2, True))
    for data, tail, subtype, index, synthetic_case in cases:
        branch = 1 if int.from_bytes(data[:2], 'little') else 0
        key = data[2:35].split(b'\0')[0]
        for event in ((0, 1) if tail else (0,)):
            for completed, phase in ((0, 0), (1, 2), (0, 0xFEDCBA98)):
                variants = [(3, 3)]
                if synthetic_case and not completed and phase == 0:
                    variants += [(0, 0), (1, 1), (7, 7), (CAP, CAP)]
                for mail_count, web_count in variants:
                    full = (mail_count, web_count) == (CAP, CAP)
                    if full and key not in seed_keys(branch, CAP):
                        # Original would store past the 8-slot harness guard; native refuses before any effect.
                        native = seeded_native(lib, mail_count, web_count)
                        before = native.snapshot()
                        status, _, why = native.step(data, 0, subtype, 0, 1)
                        require(status == n.CAPACITY and why == b'0x83-list-capacity', 'capacity rejection')
                        require(native.snapshot() == before and not native.events, 'capacity rejection effects')
                        counts['capacity_rejections'] += 1
                        continue
                    events, applied = compare_runtime(lib, o, data, tail, event, phase, subtype, index,
                                                      completed, mail_count, web_count)
                    counts['runtime_visits'] += 1
                    counts['applied_visits'] += applied
                    counts['original_events'] += events
    for subtype in range(256):
        compare_runtime(lib, o, n.raw(), b'', 0, 0, subtype, 0, 0, 3, 3)
        counts['runtime_visits'] += 1
        counts['subtype_visits'] += 1

    # Real executor + binding versus original dispatcher, multi-row and gated.
    tail = bytes.fromhex('02001b08010000000000000000000000')
    scenarios = []
    for row, data in records:
        scenarios.append(([dict(data=data[:74], tail=data[74:], subtype=row['subtype'])], [(2075, 1)] if data[74:] else []))
    mail_a, mail_b = n.raw(0, b'one', b'ONE'), n.raw(0, b'two', b'TWO')
    web_a = n.raw(1, b'link', field=-5, word_a=3, word_b=4)
    scenarios += [
        ([dict(data=mail_a), dict(data=web_a), dict(data=mail_b), dict(data=n.raw(0, b'one', b'again'))], []),
        ([dict(data=mail_a, tail=tail), dict(data=web_a), dict(data=mail_b, tail=tail)], [(2075, 1)]),
        ([dict(data=web_a, tail=tail), dict(data=web_a)], [(2075, 1)]),
        ([dict(data=n.raw(0, b'older')), dict(data=n.raw(1, b'KEY')), dict(data=n.raw(0, b'older', b'x'), subtype=0)], []),
    ]
    for rows, updates in scenarios:
        for mail_count, web_count in ((3, 3), (0, 0), (5, 2)):
            counts['binding_visits'] += compare_binding(lib, o, rows, updates, mail_count, web_count)
            counts['binding_scenarios'] += 1
    compare_refresh(lib, o, counts)

    require(o.debug_printer_calls == o.bad_tree_stops == 0, 'diagnostic hooks unexpectedly used')
    for entry in ('0x427a50', '0x423f57', '0x4e72fb', '0x4e444d', '0x4e0559'):
        require(o.entries[entry] > 0, 'entry never executed ' + entry)
    for label, address in (('mail-shift-insert', '0x4e7340'), ('mail-join', '0x4e739e'),
                           ('web-append', '0x4e746b'), ('web-join', '0x4e7488')):
        require(o.coverage[address] > 0, 'branch never reached ' + label)
    report = {
        'scope': 'Track N C kernel and the actual session/executor binding versus the original x86 dispatcher 0x427a50 '
                 'running raw-0x83 rows; no original phone renderer, saved game or gameplay parity',
        'executable_sha256': o.executable_sha256, 'corpus_rows': len(records),
        'corpus_word0_branches': dict(branches), 'counts': dict(counts), 'mismatches': 0,
        'code_windows': [{'start': hex(a), 'end': hex(b), 'sha256': h} for a, b, h in CODE],
        'executed_entries': dict(o.entries), 'runtime_branch_observations': dict(o.coverage),
        'other_original_stores': {hex(k): EXPECTED_OTHER[k][1] for k in o.other_writes},
        'row_field_stores': {hex(k): EXPECTED_ROW_FIELDS.get(k, 'dispatcher row field') for k in o.row_writes},
        'replacement_hooks': {'0x51dc43': {'kind': 'allocation only (dependency tree construction by 0x424aa8)',
                                            'calls': o.allocator_calls}},
        'raising_guards': ['0x425b8b debug tree printer', '0x425b40 malformed tree stop'],
        'observer_hooks': {
            'code:all': 'entry counters; selected index at 0x4e739e/0x4e7488; 0x4e0559 entry arguments, list snapshot and '
                        'completion vector; 0x4e750a UI table; no register/IP/memory writes',
            'write:all': 'store classification and ordering (UI availability, flag, completion byte); unclassified stores fail',
            'read:all': 'each 74-byte body window; any read beyond it fails'},
        'initializer_entry': '0x4e4337 full UICL load then basic block 0x4e2e64 after unrelated contacts sorting',
        'native_library_sha256': sha(Path(lib._name).read_bytes()), 'oracle_sha256': sha(Path(__file__).read_bytes()),
        'unverified': [
            'phone email/browser rendering and click consumers, including 0x4e3cd7/0x4e7512',
            'original unchecked malformed strings/negative counts/capacity overflow; native rejects before effects',
            'original allocation release function and saved-game persistence of the lists',
            '0x4e0559 active=0 branch; this family always passes active=1',
            'contact sorting is outside the initializer basic-block comparison',
            'whole native gameplay, both difficulties and whole-file x86 match']}
    path = args.report
    if path is None:
        folder = Path(tempfile.mkdtemp(prefix='RT-12.oracle-', dir=PRIVATE))
        path = folder / 'report.json'
    path.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({'report': str(path), 'corpus_rows': len(records), 'counts': dict(counts), 'mismatches': 0}))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--library', type=Path)
    parser.add_argument('--report', type=Path)
    run(parser.parse_args())
