#!/usr/bin/env python3
"""RT-20: original-x86 oracle for the raw 0x0c "multi-frame scene-change hotspot" runtime.

Runs the unmodified original under Unicorn and compares it, step by step, with the native
kernel/binding/session. It reuses the RT-16 harness (tests/action_family_0b_runtime_original_oracle.py:
Unicorn image, hooks, write classifier, native session rig) and adds the 0x0c specifics:

  A. the loader arm 0x40bafd itself (A-0C.1: size 10 + 18 * count narrowed to a signed word,
     allocation, verbatim copy, source and counter advance, reads inside the typed body) against
     the typed body the shared parser hands the native binding (bytes of the binding's copy), for
     all 43 corpus bodies and random/boundary bodies up to 1819 records;
  B. the dispatcher 0x427a50 itself (prologue skips, request clear, type switch via the real map
     0x42aba4 and jump table 0x42a9b4, arm 0x427c4e, the real dependency gate 0x423f57, the real
     handler 0x42b2e4, loop join, mode-4 loop exit) against the native SESSION (executor + pre-gate
     + binding + kernel) on multi-row scenes with decoy rows (done rows, raw 0x0b rows through the
     RT-16 binding, raw 0x17 rows through the RT-15 binding), over multi-pass sequences with
     selector changes, gate flips and accepted candidates (the 0x43bfb6 phase-2 store). The row
     objects of the original side come from the original loaders, not from the native code;
  C. the same dispatcher against the native KERNEL for phases 0, 1, 2 and the no-effect phases,
     both gate outcomes, random frame/selector/rectangle data;
  D. the generic row loop of the pointer cascade 0x4f0059 (0x4f1eb8..0x4f257b, which includes the
     type-0x0c hover case 0x4f2033): first hit, candidate, cursor index/variant/flag/table/surface
     against session_input_scan plus the native hover cursor;
  E. observations of unsafe original inputs (negative count, count past the object) that the
     native code rejects before any effect.

Hooks (every one is enumerated in the report; none replaces a decision the original makes except
the first two, which stand in for the host):

  replacement  0x423f57 dependency gate ONLY for rows the case declares false-gate: EAX=0, pop two
               arguments. True-gate rows run the real evaluator on an empty tree (it returns 1).
  replacement  0x51dc43 allocator (the CRT operator new) during the loader runs: EAX = a fresh
               object in a mapped test region; the requested size is recorded.
  observation  code entry of 0x427a50 / 0x423f57 (arguments) / 0x42ae73 / 0x42b07e / 0x42b2e4,
               every memory write of the address space (classified into the modeled cells, the
               gate bookkeeping, the loader's object/row pointer and the stack), reads of the row
               body objects (any read beyond an object is an error), register/stack state at the
               stop.
  stub         the return address (a single RET page) is the only code outside the executable.

Compared after every pass: the ORDERED stream of writes to the modeled cells (merged with the
dependency-gate calls and their mode argument), every row cell (completion, request, rectangle
words, phase), every world cell (0x5bb1ca, 0x583999 and the seven scene-change cells),
callee-saved registers and stack balance. The original's complete write footprint must stay inside
the modeled cells, the gate bookkeeping, the loader's outputs and the stack.

    work/tools/oracle-python/bin/python \\
      outputs/blackmoor-decomp/tests/action_family_0c_runtime_original_oracle.py
"""
import argparse
import ctypes as c
import hashlib
import json
from pathlib import Path
import random
import struct
import subprocess
import sys
import time

import action_family_0b_runtime_original_oracle as o0b
from cif_original_oracle import PEImage
import session_binding_support as session
import test_action_family_0b_runtime as t0b
import test_action_family_0c_runtime as native
import test_action_family_17_runtime as t17
import test_scene_session_pointer as pointer

ROOT = Path(__file__).resolve().parents[3]
REPORT = ROOT / 'work/analysis/slices/RT-20.oracle.json'
CORPUS_TEXT = ROOT / 'work/analysis/slices/RT-20.corpus.txt'
CORPUS = ROOT / 'work/analysis/slices/RT-20.corpus.json'
EXE_HASH = o0b.EXE_HASH
OracleError = o0b.OracleError
sha = o0b.sha

CODE_WINDOWS = [
    (0x40bafd, 0x40bbed, 'loader arm for raw 0x0c 0x40bafd',
     '08363cb53f8da289a2afd3849a14063e336cd67a094c506b4bb82474b9e47f0e'),
    (0x410a68, 0x410aaa, 'loader join 0x410a68',
     'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x427a50, 0x427b33, 'dispatcher prologue and type switch 0x427a50',
     '1c4502762e5132191098c486266e2643fc259cd7d9533ebea773a0662ca5d42e'),
    (0x427c4e, 0x427c87, 'dispatcher arm 0x0c (gate mode 0)',
     'fcd8c1dd020aef526882e2fc69da1bf267579471916d1ec3c5e03646b65355bb'),
    (0x427b33, 0x427b6b, 'dispatcher arm 0x0d (decoy rows)',
     '863e222bb5a1e1e286372ea4dae3d075bec118faa82e8dce63b724bed44842cf'),
    (0x427ba4, 0x427bdd, 'dispatcher arm 0x0b (decoy rows)',
     'd9ac9bad54ce70e3beab27fbd373ed0f0fa6e48a6b1906e3febbd562b84f3235'),
    (0x427bdd, 0x427c4e, 'dispatcher arms 0x16..0x19 (decoy rows)',
     '2018b68ba51bb564dd166deebbda630136d048309cc10655b3250fda61f125a6'),
    (0x42a9a9, 0x42a9b4, 'dispatcher loop join and epilogue',
     'c542a2c75f291cf8ee9d05f425537a3ffd1f9bc33d439b9ab2b4036a83a560a3'),
    (0x42b2e4, 0x42b510, 'handler 0x42b2e4',
     '42f18431421029a9cc80c950e85be0b860c58e13d5f34687e1e4b7599860e447'),
    (0x42ae73, 0x42b07e, 'handler 0x42ae73 (decoy rows)',
     '48d63750bd18989845fc3046817967c1cdc8f192d2590a803121d7bce5f374f6'),
    (0x42b07e, 0x42b2e4, 'handler 0x42b07e (decoy rows)',
     'b88ed7735c97e51ccc9c5d0354d8c3749cc1adcc4e3ca03ec39d4d7e92bf23f8'),
    (0x42a9b4, 0x42aba4, 'dispatcher jump table 0x42a9b4',
     '6339877da46c0c1a66738bb918087a2cd4c0ceab39811427da4dff64f5c8f8da'),
    (0x42aba4, 0x42ac91, 'dispatcher type map 0x42aba4',
     '7d726256e7d84d38c7d1677a579c09be3e2133becfbed78350302c683bec2d2e'),
    (0x423f57, 0x423fbb, 'dependency gate 0x423f57',
     '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x4234c8, 0x4234dd, 'gate reset 0x4234c8',
     'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4f1eb8, 0x4f257c, 'pointer cascade generic row loop 0x4f1eb8',
     '5d6cc6ee1cad1b8ab009d067c780861587598a2087191eca62fdc2d5b01e2395'),
    (0x4f257c, 0x4f25a0, 'cascade cursor jump table',
     'c48023991e29570ea72618c1f09e79e8af229aa91ea163182b0a83a1a25d7358'),
    (0x4f25a0, 0x4f2610, 'cascade cursor type map',
     'c19a7e454d4df17d72f993955310e08a7d8a7387b008cd80f0551c8e9d650088'),
    (0x40b7d4, 0x40b98f, 'loader arm for raw 0x0b 0x40b7d4 (decoy rows)',
     '0a5722b6c89bc4dd1b82dac573827fa6e0135b81f8816f306ed321bbae672900'),
]

BIG_SRC, BIG_SRC_SIZE = 0x34000000, 0x10000
LOADER_ARM, LOADER_JOIN, ALLOCATOR = 0x40bafd, 0x410a68, 0x51dc43
HANDLER = 0x42b2e4
ROW_BASE, ROW_STRIDE = o0b.ROW_BASE, o0b.ROW_STRIDE
WORLD_CELLS, ROW_CELLS, XFER = o0b.WORLD_CELLS, o0b.ROW_CELLS, o0b.XFER
row_va, obj_va, wrap_s16 = o0b.row_va, o0b.obj_va, o0b.wrap_s16
FRAME, STACK, STACK_SIZE = o0b.FRAME, o0b.STACK, o0b.STACK_SIZE
ALLOC_BASE, ALLOC_SIZE = o0b.ALLOC_BASE, o0b.ALLOC_SIZE
SELECTOR_CELL = o0b.SELECTOR_CELL


class Original(o0b.Original):
    """The RT-16 harness plus the 0x0c handler hook and the 0x0c loader arm."""

    def __init__(self, pe):
        from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ
        super().__init__(pe)
        self.uc.mem_map(BIG_SRC, BIG_SRC_SIZE)
        self.uc.hook_add(UC_HOOK_CODE, self.on_code, begin=HANDLER, end=HANDLER)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.on_read_big, begin=BIG_SRC,
                         end=BIG_SRC + BIG_SRC_SIZE - 1)
        self.big_length = 0
        self.big_reads_beyond = []
        self.requested_sizes = []

    def on_code(self, uc, address, size, user):
        if address == HANDLER:
            esp = uc.reg_read(self.regs['ESP'])
            self.count('observe 0x42b2e4 handler entry (raw 0x0c rows)')
            self.events.append(('handler', struct.unpack('<h', self.read(esp + 4, 2))[0]))
            return
        if address == ALLOCATOR:
            esp = uc.reg_read(self.regs['ESP'])
            self.requested_sizes.append(struct.unpack('<I', self.read(esp + 4, 4))[0])
        super().on_code(uc, address, size, user)

    def on_read_big(self, uc, access, address, size, value, user):
        if address + size > BIG_SRC + self.big_length:
            self.big_reads_beyond.append((address, size))

    # -- the loader arm 0x40bafd
    def run_loader_0c(self, body, row, rng):
        """Run the original loader arm for raw 0x0c on `body` for table row `row`. Returns the
        allocated object bytes, the requested size and the (counter, source) advance."""
        uc, r = self.uc, self.regs
        self.writes, self.events, self.reads_beyond, self.big_reads_beyond = [], [], [], []
        self.requested_sizes = []
        self.nrows = 0
        self.alloc_next = 0
        uc.mem_write(ALLOC_BASE, bytes([0xa5]) * ALLOC_SIZE)
        uc.mem_write(ROW_BASE, bytes(240 * ROW_STRIDE))
        self.put(o0b.COUNT_WORD, 2, row)
        uc.mem_write(BIG_SRC, bytes([0x5a]) * BIG_SRC_SIZE)
        uc.mem_write(BIG_SRC, body)
        self.big_length = len(body)
        uc.mem_write(STACK, bytes(STACK_SIZE))
        ebp = FRAME
        counter = rng.randrange(0x1000, 0x2000)
        self.put(ebp - 0x20, 4, BIG_SRC)
        self.put(ebp - 0xcc, 4, counter)
        for name in ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI'):
            uc.reg_write(r[name], rng.randrange(2 ** 32))
        uc.reg_write(r['EBP'], ebp)
        uc.reg_write(r['ESP'], ebp - 0x300)
        uc.reg_write(r['EFLAGS'], 0x202)
        uc.emu_start(LOADER_ARM, LOADER_JOIN, count=4000000)
        if uc.reg_read(r['EIP']) != LOADER_JOIN:
            raise OracleError('loader arm did not reach the loop join')
        pointer_cell = self.cell(row_va(row, 2), 4)
        if pointer_cell != ALLOC_BASE:
            raise OracleError(('loader stored an unexpected object pointer', hex(pointer_cell)))
        if len(self.requested_sizes) != 1:
            raise OracleError(('allocator called a wrong number of times', self.requested_sizes))
        size = self.requested_sizes[0]
        object_bytes = self.read(ALLOC_BASE, size)
        written = set()
        for address, wsize, _ in self.writes:
            if ALLOC_BASE <= address < ALLOC_BASE + size:
                if address + wsize > ALLOC_BASE + size:
                    raise OracleError('loader write beyond the allocated object')
                written.update(range(address - ALLOC_BASE, address - ALLOC_BASE + wsize))
            elif address == row_va(row, 2) and wsize == 4:
                pass
            elif STACK <= address and address + wsize <= STACK + STACK_SIZE:
                pass
            else:
                raise OracleError(f'loader write outside object/row pointer/stack: {address:#x}/{wsize}')
        if written != set(range(size)):
            raise OracleError(('loader did not write every object byte', sorted(set(range(size)) - written)[:8]))
        advance = (self.cell(ebp - 0xcc, 4) - counter, self.cell(ebp - 0x20, 4) - BIG_SRC)
        return object_bytes, size, advance, bool(self.big_reads_beyond)

    def run_dispatcher_unchecked(self, rng):
        """run_dispatcher for the unsafe observations: the caller inspects reads_beyond."""
        try:
            return self.run_dispatcher(rng), False
        except OracleError as error:
            if error.args and isinstance(error.args[0], tuple) and error.args[0][0] == \
                    'original read beyond a row body':
                return None, True
            raise


# ----------------------------------------------------------------- native side

def action_bytes(spec, flag):
    if spec['type'] == 0x61:
        return session.action(0x61, 1, session.i16(15) + session.i16(1) + session.i16(-1) +
                              session.i16(0))
    return session.action(spec['type'], spec.get('subtype', 1), spec['body'],
                          (session.flag_gate(flag),))


class NativeSession:
    SLOT_FN = {0x0c: ('session_a0c_slot', 'binding_0c'), 0x0b: ('session_a0b_slot', 'binding_0b'),
               0x17: ('session_a17_slot', 'binding_17'), 0x16: ('session_a17_slot', 'binding_17')}

    def __init__(self, lib, rows, rng, world):
        self.lib, self.rows = lib, rows
        self.rig = t17.Rig17(selector=0)
        self.rig.start_flag = world['start_flag']
        self.rig.lib = lib
        self.scene, self.owner = session.open_scene(lib, [action_bytes(r, i + 1) for i, r in enumerate(rows)])
        self.flags, self.core, self.conditions = session.make_world()
        # One host serves all three bindings, so the effect stream keeps the dispatch order.
        self.binding_0c = lib.session_a0c_create(c.byref(self.rig.host))
        self.binding_0b = lib.session_a0b_create(c.byref(self.rig.host))
        self.binding_17 = lib.session_a17_create(c.byref(self.rig.host))
        if not self.binding_0c or not self.binding_0b or not self.binding_17 or \
                lib.session_a0c_begin_scene(self.binding_0c, self.scene) != 0 or \
                lib.session_a0b_begin_scene(self.binding_0b, self.scene) != 0 or \
                lib.session_a17_begin_scene(self.binding_17, self.scene) != 0:
            raise OracleError('native binding refused the scene')
        self.session = c.c_void_p()

        @session.PrepareFn
        def prepare(*_): return 0

        @session.MediaFn
        def media(*_): return 0

        handler_0c = session.ActionFn(('session_a0c_handler', lib))
        handler_0b = session.ActionFn(('session_a0b_handler', lib))
        handler_17 = session.ActionFn(('session_a17_handler', lib))
        self.bindings = (session.Binding * 4)(session.Binding(0x0c, 11, handler_0c, self.binding_0c),
                                              session.Binding(0x0b, 11, handler_0b, self.binding_0b),
                                              session.Binding(0x17, 11, handler_17, self.binding_17),
                                              session.Binding(0x16, 11, handler_17, self.binding_17))
        self.config = session.SessionConfig(scene=self.scene, scene_id=2010,
            action_core_world=c.pointer(self.core), conditions=c.pointer(self.conditions),
            action_bindings=self.bindings, action_binding_count=4, prepare_tick=prepare,
            advance_media_one=media)
        if lib.scene_session_create(c.byref(self.config), c.byref(self.session),
                                    c.byref(session.SceneSessionFailure())) != 0:
            raise OracleError('native session refused the scene')
        for runtime_type, fn, binding in ((0x0c, lib.session_a0c_pre_gate, self.binding_0c),
                                          (0x0b, lib.session_a0b_pre_gate, self.binding_0b),
                                          (0x17, lib.session_a17_pre_gate, self.binding_17),
                                          (0x16, lib.session_a17_pre_gate, self.binding_17)):
            if lib.scene_session_set_pre_gate(self.session, runtime_type, c.cast(fn, c.c_void_p),
                                              binding) != 0:
                raise OracleError('pre-gate registration failed')
        self.rig.session = self.session
        self.keep = (prepare, media, handler_0c, handler_0b, handler_17)
        self.transitioned = False

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a0c_destroy(self.binding_0c)
        self.lib.session_a0b_destroy(self.binding_0b)
        self.lib.session_a17_destroy(self.binding_17)
        self.lib.scene_resource_close(self.scene)

    def pass_(self, selector, gates, accept):
        lib = self.lib
        self.rig.selector = selector
        for row, ok in enumerate(gates):
            self.flags[row + 1] = 1 if ok else 0
        if accept is not None and lib.scene_session_accept_action_candidate(self.session, accept) != 0:
            raise OracleError('native refused the candidate')
        self.rig.effects.clear()
        out = session.SceneSessionTickResult()
        status = lib.scene_session_tick(self.session, c.byref(out))
        if status not in (session.SESSION_OK, session.SESSION_TRANSITION):
            raise OracleError(('native tick failed', status, out.failure.action_index))
        events, seen = [], set()
        world_names = {n for n, _ in WORLD_CELLS.values()}
        for row, name, value in self.rig.effects:
            events.append(('w', name, -1 if name in world_names else row, value))
            if row not in seen:
                seen.add(row)       # the first event of a visit is the prologue request clear
                runtime_type = self.rows[row]['type']
                events.append(('gate', row, lib.scene_conditions_gate_mode_for_type(runtime_type)))
        cells = []
        for row in range(len(self.rows)):
            state = session.RuntimeState()
            lib.scene_session_get_action_state(self.session, row, c.byref(state))
            if self.rows[row]['type'] == 0x61:
                cells.append(None)
                continue
            slot = native.Slot()
            fn_name, binding_name = self.SLOT_FN[self.rows[row]['type']]
            getattr(lib, fn_name)(getattr(self, binding_name), row, c.byref(slot))
            cells.append((state.completed, slot.request, slot.left, slot.top, slot.right, slot.bottom,
                          state.phase))
        world = {'start_flag': self.rig.start_flag, 'mode': 3}
        transition = None
        if status == session.SESSION_TRANSITION:
            pending = session.SceneTransitionRequest()
            if lib.scene_session_get_pending_transition(self.session, c.byref(pending)) != 1:
                raise OracleError('transition status without a pending request')
            transition = (pending.target_scene, *pending.opaque_words, *pending.opaque_dwords)
            world['mode'] = 4
            self.transitioned = True
        return events, cells, world, transition


def insert_handler_marks(events):
    """The original also logs handler entries; the session stream has none."""
    return [e for e in events if e[0] != 'handler']


# --------------------------------------------------------------------- corpus

def ensure_corpus():
    """The raw 0x0c rows of the corpus, produced through the production parser."""
    if not CORPUS.exists():
        tool = ROOT / 'work/analysis/slices/RT-20.corpus-dump'
        src = ROOT / 'outputs/blackmoor-decomp/src'
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-std=c11', '-O1', '-I', str(src),
                        str(Path(__file__).with_name('action_family_0c_corpus_dump.c')),
                        str(src / 'scene_resource.c'), str(src / 'hiff.c'), '-o', str(tool)],
                       check=True, capture_output=True)
        listing = subprocess.run([str(tool), *sorted(str(p) for p in
                                 (ROOT / 'work/analysis/hiff-resources').glob('*.bin'))],
                                 check=True, capture_output=True, text=True).stdout
        CORPUS_TEXT.write_text(listing)
        records = []
        for line in listing.splitlines():
            parts = line.split()
            path, row, rows, length, deps = parts[:5]
            title, hexbody = ' '.join(parts[5:-1]), parts[-1]
            records.append(dict(resource_index=int(Path(path).stem), action_index=int(row),
                                scene_rows=int(rows), typed_body_length=int(length),
                                dependency_count=int(deps), scene_title=title, body=hexbody,
                                body_sha256=sha(bytes.fromhex(hexbody))))
        CORPUS.write_text(json.dumps(dict(exe_sha256=EXE_HASH, raw_0x0c_rows=len(records),
                                          records=records), indent=1) + '\n')
    corpus = json.loads(CORPUS.read_text())
    return [bytes.fromhex(r['body']) for r in corpus['records']], corpus


FRAME_POOL = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 19, -1, 0x7fff, -32768, 0x4000)


def random_body(rng, count=None, frames=FRAME_POOL):
    word = lambda: rng.choice((0, 1, -1, 0x7fff, -32768, rng.randrange(-32768, 32768)))
    dword = lambda: rng.choice((0, 1, -1, 0x7fffffff, -2 ** 31, rng.randrange(0, 640),
                                rng.randrange(-70000, 70000), 0x8000, 0xffff, 0x12345))
    n = rng.choice((0, 1, 2, 3, 4, 5, 5, 6, 7, 20)) if count is None else count
    records = [(rng.choice(frames), dword(), dword(), dword(), dword()) for _ in range(n)]
    return native.body(cursor=rng.choice((0, 3, 4, 5, 8, 11, 0x1a, 0x1b, -1, 100, word())),
                       target=rng.choice((2008, 0, -1, word())), entry=word(),
                       word6=rng.choice((1, 0, word())), records=records)


def body_frames(body):
    count = struct.unpack_from('<h', body, 8)[0]
    return [struct.unpack_from('<h', body, 10 + 18 * i)[0] for i in range(count)]


# --------------------------------------------------------------------- cases

def run_loader_cases(lib, original, corpus, counters):
    """A. The loader arm against the typed body the native binding keeps."""
    cases = 0
    bodies = list(corpus)
    rng = random.Random(0x40bafd)
    for _ in range(1500):
        bodies.append(random_body(rng))
    for count in (0, 1, 2, 3, 100, 255, 256, 1000, 1818, 1819):
        bodies.append(random_body(rng, count=count))
    bodies.append(native.body(records=[]))
    for number, body in enumerate(bodies):
        rng = random.Random(number * 7919 + 1)
        row = rng.randrange(0, 200)
        # the original must receive the trailing dependency bytes too: the loader copies only
        # 10 + 18 * count and advances by that amount.
        padded = body + bytes(rng.randrange(256) for _ in range(rng.choice((0, 0, 16, 32))))
        obj, size, advance, beyond = original.run_loader_0c(padded, row, rng)
        if beyond:
            raise OracleError(('loader read beyond the typed body', number))
        if size != len(body) or advance != (size, size):
            raise OracleError(('loader size or advance mismatch', number, size, len(body), advance))
        if obj != body:
            raise OracleError(('loader object differs from the typed body', number))
        # native: the parser's typed body, copied by the binding at scene begin
        scene, owner = session.open_scene(lib, [session.action(0x0c, 1, padded[:len(body)])])
        rig = t17.Rig17()
        binding = lib.session_a0c_create(c.byref(rig.host))
        try:
            if lib.session_a0c_begin_scene(binding, scene) != 0:
                raise OracleError(('native binding refused a valid body', number))
            length = c.c_size_t()
            pointer_ = lib.session_a0c_body(binding, 0, c.byref(length))
            mine = c.string_at(pointer_, length.value)
        finally:
            lib.session_a0c_destroy(binding)
            lib.scene_resource_close(scene)
        if mine != obj:
            raise OracleError(('native body copy differs from the original object', number))
        cases += 1
    counters['loader_corpus_bodies'] = len(corpus)
    counters['loader_bytes_compared'] = counters.get('loader_bytes_compared', 0) + sum(map(len, bodies))
    return cases


def build_sequence(rng, corpus):
    nfamily = rng.choice((1, 1, 2, 2, 3, 4))
    rows = []
    for _ in range(nfamily):
        roll = rng.random()
        if roll < 0.15:      # a decoy raw 0x0b row in the same scene
            rows.append(dict(type=0x0b, body=t0b.body(frame=rng.choice((0, 0, 4, -1)),
                                                      rect=(1, 2, 300, 200)), done=False,
                             subtype=rng.choice((1, 1, 0, 2))))
        elif roll < 0.3:     # a decoy raw 0x17 row
            rows.append(dict(type=0x17, body=t17.body(target=rng.choice((6402, 6451)), words=(0, 0, 1),
                                                      records=[(f, 1, 2, 30, 40) for f in
                                                               rng.sample(range(-3, 8), rng.randrange(1, 4))]),
                             done=False, subtype=rng.choice((1, 1, 0, 2))))
        else:
            body = rng.choice(corpus) if rng.random() < 0.4 else random_body(rng)
            rows.append(dict(type=0x0c, body=body, done=False,
                             subtype=rng.choice((1, 1, 1, 0, 2, 3, 255))))
    if not any(r['type'] == 0x0c for r in rows):
        rows[0] = dict(type=0x0c, body=rng.choice(corpus), done=False, subtype=1)
    if rng.random() < 0.4:
        rows.insert(rng.randrange(len(rows) + 1), dict(type=0x61, body=b'', done=True))
    pool = [0, 0, 0]
    for r in rows:
        if r['type'] == 0x0c:
            pool += body_frames(r['body'])
        elif r['type'] == 0x17:
            pool += [struct.unpack_from('<h', r['body'], 22 + 18 * i)[0]
                     for i in range(struct.unpack_from('<h', r['body'], 20)[0])]
    decoys = [f ^ 0x100 for f in pool] + [f + 1 for f in pool] + [-5, 100, 0x4000]
    steps = []
    for _ in range(rng.randrange(1, 7)):
        steps.append(dict(selector=wrap_s16(rng.choice(pool + pool + decoys)),
                          gates=[rng.random() < 0.7 for _ in rows], accept_mode=rng.random()))
    world = dict(start_flag=rng.choice((0, -1, 0x7a7a7a7a, 12345)), mode=3,
                 **{n: rng.randrange(-2 ** 31, 2 ** 31) if sz == 4 else rng.randrange(-32768, 32768)
                    for n, sz in ((n, WORLD_CELLS[a][1]) for a, (n, _) in WORLD_CELLS.items()
                                  if n.startswith('xfer'))})
    return rows, steps, world


def original_objects(original, rows, rng):
    """The row objects the original loaders would have produced."""
    for number, spec in enumerate(rows):
        if spec['type'] == 0x0c:
            spec['obj'], _, _, _ = original.run_loader_0c(spec['body'], number, rng)
        elif spec['type'] == 0x0b:
            spec['obj'], _, _ = original.run_loader(spec['body'], number, rng)
        else:
            spec['obj'] = spec['body']


def compare_pass(lib, original, nat, rng, rows, step, accept, label, counters):
    original.false_rows = {row for row, ok in enumerate(step['gates']) if not ok}
    original.put(SELECTOR_CELL, 2, step['selector'])
    if accept is not None:
        original.put(row_va(accept, 0x4f), 4, 2)
    got = original.run_dispatcher(rng)
    events, cells, world, transition = nat.pass_(step['selector'], step['gates'], accept)
    expected = insert_handler_marks(got['events'])
    if events != expected:
        raise OracleError(('ordered effect stream mismatch', label, events, expected))
    counters['events_compared'] = counters.get('events_compared', 0) + len(events)
    for row, spec in enumerate(rows):
        if spec['type'] == 0x61:
            continue
        done, request, left, top, right, bottom, phase = cells[row]
        o = dict(zip([n for _, (n, _) in sorted(ROW_CELLS.items())], got['rows'][row]))
        if (o['done'], o['request'], o['left'], o['top'], o['right'], o['bottom'], o['phase']) != \
                (done, request, left, top, right, bottom, phase):
            raise OracleError(('row cell mismatch', label, row, cells[row], got['rows'][row]))
        counters['row_cells_compared'] = counters.get('row_cells_compared', 0) + 7
    for name, value in world.items():
        if got['world'][name] != value:
            raise OracleError(('world cell mismatch', label, name, value, got['world'][name]))
        counters['world_cells_compared'] = counters.get('world_cells_compared', 0) + 1
    if transition is not None:
        for name, value in zip(XFER, transition):
            if got['world'][name] != value:
                raise OracleError(('scene-change cell mismatch', label, name, value, got['world'][name]))
            counters['world_cells_compared'] = counters.get('world_cells_compared', 0) + 1
    for name in got['classes']:
        counters['footprint'][name] = counters['footprint'].get(name, 0) + 1
    for e in got['events']:
        key = e[1] if e[0] == 'w' else e[0]
        counters['sequence'][key] = counters['sequence'].get(key, 0) + 1
    return got, cells, transition


def run_sequences(lib, original, corpus, count, counters, seed=0x0c):
    passes = transitions = 0
    for index in range(count):
        rng = random.Random(seed * 100003 + index)
        rows, steps, world = build_sequence(rng, corpus)
        original_objects(original, rows, rng)
        original.load_scene(rows, rng, world)
        nat = NativeSession(lib, rows, rng, world)
        nat.last_cells = [None] * len(rows)
        try:
            for number, step in enumerate(steps):
                accept = None
                if number > 0 and step['accept_mode'] < 0.6:
                    candidates = [i for i, cell in enumerate(nat.last_cells) if cell is not None
                                  and not cell[0] and (cell[1] != 0 or step['accept_mode'] < 0.1)]
                    if candidates:
                        accept = candidates[0] if step['accept_mode'] < 0.5 else candidates[-1]
                _, cells, transition = compare_pass(lib, original, nat, rng, rows, step, accept,
                                                    (index, number), counters)
                nat.last_cells = cells
                passes += 1
                if transition is not None:
                    transitions += 1
                    for spec_row, cell in zip(rows, cells):
                        if spec_row['type'] == 0x0c and cell is not None and cell[0]:
                            counters['finish_0c'] = counters.get('finish_0c', 0) + 1
                    break
        finally:
            nat.close()
    return passes, transitions


def run_kernel_cases(lib, original, corpus, counters):
    """C. Dispatcher against the kernel directly."""
    cases = 0
    mode = lib.scene_conditions_gate_mode_for_type(0x0c)
    for index in range(180):
        rng = random.Random(0x42b2e4 + index)
        body = rng.choice(corpus) if index % 3 == 0 else random_body(rng)
        obj, _, _, _ = original.run_loader_0c(body, 0, rng)
        frames = body_frames(body)
        for phase in (0, 1, 2, 3, 5, 0x10000):
            for gate in (True, False):
                selector = wrap_s16(rng.choice(frames + frames + [0, 1, -1, 0x100, 0x4000,
                                                                    5, 5 ^ 0x8000]))
                world = dict(start_flag=rng.choice((0, 0x5a5a5a5a)), mode=3,
                             **{n: 1000 + i for i, n in enumerate(XFER)})
                rows = [dict(type=0x0c, obj=obj, done=False, subtype=rng.choice((0, 1, 2, 3, 255)))]
                original.load_scene(rows, rng, world)
                original.false_rows = set() if gate else {0}
                original.put(SELECTOR_CELL, 2, selector)
                original.put(row_va(0, 0x4f), 4, phase)
                seed_cells = [rng.randrange(-30000, 30000) for _ in range(4)]
                for off, value in zip((0x47, 0x49, 0x4b, 0x4d), seed_cells):
                    original.put(row_va(0, off), 2, value)
                original.put(row_va(0, 0x43), 4, rng.choice((0, 1, 7)))
                got = original.run_dispatcher(rng)
                log = [('w', 'request', 0, 0), ('gate', 0, mode)]
                slot = native.Slot(request=0, left=seed_cells[0], top=seed_cells[1],
                                   right=seed_cells[2], bottom=seed_cells[3], done=0)
                w = native.World(selector=selector, start_flag_5bb1ca=world['start_flag'],
                                 mode_583999=3, **{k: world[k] for k in XFER})
                case = native.Case(lib, body, phase & 0xffffffff, slot=slot, world=w)
                if gate:
                    status, result, why = case.run()
                    if status != native.OK:
                        raise OracleError(('native kernel rejected a parity case', status, why))
                    world_names = {n for n, _ in WORLD_CELLS.values()}
                    log += [('w', n, -1 if n in world_names else 0, v) for n, v in case.log]
                expected = insert_handler_marks(got['events'])
                if log != expected:
                    raise OracleError(('kernel stream mismatch', phase, gate, log, expected))
                counters['events_compared'] = counters.get('events_compared', 0) + len(log)
                o = dict(zip([n for _, (n, _) in sorted(ROW_CELLS.items())], got['rows'][0]))
                nat_state = case.state()
                if gate and ((o['request'], o['left'], o['top'], o['right'], o['bottom'], o['done']) !=
                             nat_state[0]):
                    raise OracleError(('kernel cell mismatch', phase, nat_state, o))
                if not gate and o['request'] != 0:
                    raise OracleError('false gate left the request set')
                if got['world']['start_flag'] != (case.world.start_flag_5bb1ca if gate else world['start_flag']):
                    raise OracleError(('start flag mismatch', phase))
                if gate and got['world']['mode'] != case.world.mode_583999:
                    raise OracleError(('mode mismatch', phase))
                if gate and phase == 2:
                    for name, native_value in zip(XFER, nat_state[1][2:]):
                        if got['world'][name] != native_value:
                            raise OracleError(('scene-change cell mismatch', name))
                if gate and phase in (0, 1):
                    counters['kernel_hits'] = counters.get('kernel_hits', 0) + (1 if result.requested else 0)
                cases += 1
                for name in got['classes']:
                    counters['footprint'][name] = counters['footprint'].get(name, 0) + 1
    return cases


def run_cascade_cases(lib, original, count):
    cases = hits = family_hits = misses = 0
    shapes = {}
    for index in range(count):
        rng = random.Random(0x4f2033 + index)
        nrows = rng.randrange(1, 7)
        rows = []
        for _ in range(nrows):
            left, top = rng.randrange(0, 600), rng.randrange(0, 440)
            runtime_type = rng.choice((0x0c, 0x0c, 0x0c, 0x0b, 0x17, 0x6a, 0x0d, 0x16))
            spec = dict(type=runtime_type,
                        request=rng.choice((0, 1, 1, 7, -1)),
                        rect=(left, top, left + rng.randrange(0, 90), top + rng.randrange(0, 70)))
            if runtime_type in (0x0c, 0x0b):
                cursor = rng.choice((0, 1, 2, 3, 4, 5, 8, 11, 0x1a, 0x1b, 0x1c, -1, 100, -32768, 0x7fff,
                                     rng.randrange(-40, 60)))
                spec['cursor'] = cursor
                spec['payload'] = struct.pack('<h', cursor) + bytes(rng.randrange(256) for _ in range(0x26))
            rows.append(spec)
        pick = rng.choice(rows)
        l, t, r, b = pick['rect']
        if rng.random() < 0.75:
            x = rng.choice((l, r, l - 1, r + 1, (l + r) // 2, l + (r - l) // 3))
            y = rng.choice((t, b, t - 1, b + 1, (t + b) // 2, t + (b - t) // 3))
        else:
            x, y = rng.randrange(0, 640), rng.randrange(0, 480)
        x, y = min(max(x, 0), 639), min(max(y, 0), 479)
        held = rng.choice((-1, -1, 0, 5, 40, -2, 1000))
        case = dict(rows=rows, x=x, y=y,
                    initial={'cursor_index': 0x1111, 'cursor_variant': 0x2222, 'item_flag': 0x3333,
                             'cursor_surface': 0x4444, 'cursor_table': 0x5555, 'cursor_layer': 0x6666,
                             'candidate': -77},
                    inputs={'held_item': held, 'surface_default': 0xd0377, 'surface_held': 0x571ad3a,
                            'excluded_0': -1, 'excluded_1': -1})
        got, written = original.run_cascade(case, rng)
        spots = (pointer.InputHotspot * max(len(rows), 1))()
        n = 0
        for i, spec in enumerate(rows):
            if spec['request'] != 0:
                spots[n].index = i
                spots[n].rectangle = pointer.Rect(*spec['rect'])
                spots[n].active = 1
                n += 1
        state = pointer.InputState()
        lib.session_input_init(c.byref(state))
        ctx = pointer.InputContext(pointer.Rect(0, 0, 639, 479), pointer.Rect(x, y, x, y),
                                   0, 0, 0, 0, 0, 0, 1, 1, -1, -1)
        lib.session_input_publish_candidate(c.byref(state), -1)
        status = lib.session_input_scan(c.byref(state), c.byref(ctx), spots, n)
        if status != 0:
            raise OracleError(('session_input_scan failed', status))
        candidate = state.candidate
        original_candidate = got['candidate'] if 'candidate' in written else -1
        if candidate != original_candidate:
            raise OracleError(('candidate mismatch', index, candidate, original_candidate, case))
        cases += 1
        if candidate < 0:
            misses += 1
            if written - {'item_flag'} or got['return'] != 1 or got['item_flag'] != 0:
                raise OracleError(('a miss wrote cursor cells', index, written))
            continue
        hits += 1
        spec = rows[candidate]
        if spec['type'] != 0x0c:
            continue
        family_hits += 1
        data = native.body(cursor=spec['cursor'])
        cursor = native.Cursor()
        if lib.action0c_hover_cursor(data, len(data), held, c.byref(cursor)) != 0:
            raise OracleError('native hover rejected a family row')
        expected = {'cursor_index': cursor.cursor_index, 'cursor_variant': cursor.variant,
                    'item_flag': cursor.held_flag,
                    'cursor_table': o0b.CURSOR_TABLE_BASE + cursor.table_offset, 'cursor_layer': 1}
        expected['cursor_surface'] = {0: case['initial']['cursor_surface'],
                                      1: case['inputs']['surface_default'],
                                      2: case['inputs']['surface_held']}[cursor.surface]
        for name, value in expected.items():
            if got[name] != value:
                raise OracleError(('cursor cell mismatch', name, got[name], value, spec['cursor'], held))
        if got['return'] != 1:
            raise OracleError('cascade fragment did not return 1')
        in_range = 3 < spec['cursor'] < 0x1b
        key = f"held={'none' if held == -1 else 'item'} word={'in 4..0x1a' if in_range else 'outside'}"
        shapes[key] = shapes.get(key, 0) + 1
    return dict(cases=cases, hits=hits, family_hits=family_hits, misses=misses,
                family_hit_shapes=dict(sorted(shapes.items())))


def unsafe_observations(lib, original):
    out = []
    rng = random.Random(0x0c0c)
    good = native.body()

    def dispatch(obj, length, selector):
        rows = [dict(type=0x0c, obj=obj, done=False, subtype=1)]
        world = dict(start_flag=0, mode=3, **{n: 1000 + i for i, n in enumerate(XFER)})
        original.load_scene(rows, rng, world)
        original.body_lengths[0] = length
        original.false_rows = set()
        original.put(SELECTOR_CELL, 2, selector)
        original.put(row_va(0, 0x4f), 4, 1)
        return original.run_dispatcher_unchecked(rng)

    # A negative count: the loop `i < count` is false at once, the original sees an empty list.
    negative = native.body(records=[], count=-1)
    got, beyond = dispatch(negative, len(negative), 5)
    status = lib.action0c_validate_body(negative, len(negative), None)
    if beyond or got is None or status != native.BOUNDS or got['rows'][0][1] != 0:
        raise OracleError('negative-count observation did not hold')
    out.append(dict(label='count word -1 (object of 10 bytes)',
                    original='the loop bound is the signed count: no record is read, the visit stores '
                             'request 0 and nothing else (an empty list); the loader (A-0C.1) would '
                             'have allocated a wrapped, negative size for this count',
                    native='ACTION17_ERR_BOUNDS before any effect'))
    # A count that exceeds the object: the original reads the records beyond it.
    short = native.body(records=native.S2010_ROW5_RECORDS[:2], count=5)
    got, beyond = dispatch(short, len(short), 9)      # no frame 9: the scan walks past the data
    status = lib.action0c_validate_body(short, len(short), None)
    if not beyond or status != native.BOUNDS:
        raise OracleError('count-past-object observation did not hold')
    out.append(dict(label='count 5 over an object holding two records',
                    original='the scan reads three record slots beyond the allocated object',
                    native='ACTION17_ERR_BOUNDS before any effect'))
    # A count of 1820: the loader size wraps; the handler would walk 1820 records.
    big = native.body(records=[], count=1820) + bytes(18 * 1820)
    status = lib.action0c_validate_body(big, len(big), None)
    if status != native.BOUNDS:
        raise OracleError('count 1820 was accepted')
    out.append(dict(label='count 1820',
                    original='10 + 18 * 1820 = 32770 narrows to a negative WORD in the loader '
                             '(A-0C.1): the allocation and the copy size are wrong',
                    native='ACTION17_ERR_BOUNDS before any effect'))
    return out


def main(*, library=None, report_path=REPORT, sequences=1500, cascade_cases=1500):
    started = time.monotonic()
    library_path = native.build_library() if library is None else native.library_path()
    lib = session.load_library(library_path)
    native.configure(lib)
    native_kernel = native.bind(library_path)
    for name in ('action0c_step', 'action0c_validate_body', 'action0c_hover_cursor'):
        setattr(lib, name, getattr(native_kernel, name))
    lib.scene_conditions_gate_mode_for_type.argtypes = [c.c_uint8]
    lib.scene_conditions_gate_mode_for_type.restype = c.c_int32
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    if sha(pe.data) != EXE_HASH:
        raise OracleError('executable mismatch')
    windows = []
    for start, end, label, digest in CODE_WINDOWS:
        actual = sha(pe.image[start - pe.image_base:end - pe.image_base])
        if digest is not None and actual != digest:
            raise OracleError(f'code window mismatch: {label}')
        windows.append(dict(start=hex(start), end=hex(end), label=label, sha256=actual))
    original = Original(pe)
    corpus, corpus_doc = ensure_corpus()
    counters = dict(footprint={}, sequence={})
    loader_cases = run_loader_cases(lib, original, corpus, counters)
    passes, finished = run_sequences(lib, original, corpus, sequences, counters)
    kernel_cases = run_kernel_cases(lib, original, corpus, counters)
    cascade = run_cascade_cases(lib, original, cascade_cases)
    unsafe = unsafe_observations(lib, original)
    report = dict(
        slice='RT-20',
        scope='loader arm 0x40bafd; dispatcher 0x427a50 (prologue, type switch, arm 0x427c4e, real gate, '
              'real handler 0x42b2e4, loop join); generic row loop of the pointer cascade '
              '0x4f1eb8..0x4f257b including the type-0x0c hover case 0x4f2033',
        original_sha256=EXE_HASH, code_windows=windows,
        native_sha256=sha(Path(library_path).read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        corpus_file_sha256=sha(CORPUS.read_bytes()), corpus_bodies=len(corpus),
        loader_cases=loader_cases,
        loader_bytes_compared=counters.get('loader_bytes_compared', 0),
        session_sequences=sequences, session_passes=passes, session_scene_changes=finished,
        session_0c_scene_changes=counters.get('finish_0c', 0),
        kernel_dispatcher_cases=kernel_cases, kernel_visits_with_a_frame_hit=counters.get('kernel_hits', 0),
        events_compared=counters.get('events_compared', 0),
        row_cells_compared=counters.get('row_cells_compared', 0),
        world_cells_compared=counters.get('world_cells_compared', 0),
        cascade=cascade,
        mismatches=0,
        write_stream_names=dict(sorted(counters['sequence'].items())),
        write_footprint_classes=dict(sorted(counters['footprint'].items())),
        hooks=dict(sorted(original.hook_counts.items())),
        original_decisions_replaced='only 0x423f57 for rows declared false-gate; true-gate rows run the real '
                                    'evaluator on an empty tree. 0x51dc43 (allocator) is a host stand-in '
                                    'during the loader runs only',
        compared='loader: every object byte, the row pointer cell, requested size, source and counter '
                 'advance, byte coverage, reads inside the typed body; dispatcher: ordered write stream '
                 'merged with gate calls and their mode; every row cell; every world cell; the seven '
                 'scene-change cells; callee-saved registers and stack balance; write footprint; cascade '
                 'candidate and the six cursor cells',
        unsafe_original_observations=unsafe,
        unverified=['non-empty dependency tree evaluation (shared kernel; native session tests)',
                    'the action-active dword (+0x55) skip: the executor has no producer for it',
                    'the loader allocation-failure branch (error print and exit) is not run',
                    'the pointer transform before the generic row loop (session_input oracles)',
                    'excluded rows 0x5b4e89/0x5b5100 and the other cursor cases of 0x4f0059',
                    'who else writes the selector 0x5bb50b (navigation, RT-17) and the row phase dword'],
        seconds=round(time.monotonic() - started, 2))
    report_path.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: report[k] for k in ('loader_cases', 'session_sequences', 'session_passes',
                                             'session_scene_changes', 'session_0c_scene_changes',
                                             'kernel_dispatcher_cases', 'events_compared',
                                             'row_cells_compared', 'world_cells_compared', 'mismatches',
                                             'seconds')}))
    print(json.dumps(report['cascade']))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--report', type=Path, default=REPORT)
    parser.add_argument('--mutation', action='store_true',
                        help='smaller run for mutation checks (library from A0C_RUNTIME_LIBRARY)')
    arguments = parser.parse_args()
    if arguments.mutation:
        main(library=True, report_path=arguments.report, sequences=250, cascade_cases=300)
    else:
        main(report_path=arguments.report)
