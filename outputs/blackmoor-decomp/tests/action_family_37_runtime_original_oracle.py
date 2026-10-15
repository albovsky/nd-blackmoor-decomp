#!/usr/bin/env python3
"""RT-18: original-x86 oracle for raw 0x37 rows running through the COverlay runtime.

Runs the unmodified original under Unicorn:

    0x40c446..0x40c482  the loader arm of raw 0x37: real constructor 0x4895cc over
                        0x48945b (allocation, zeroing, defaults, name, options,
                        primary record, cursor/offset advance) and the type store
                        0x36 (0x40c47b), driven through the real arm
    0x428083  dispatcher arm 0x36 -> real dependency gate 0x423f57 (empty tree)
              -> 0x4899ca COverlay::Process (RT-14 harness, all callees real)
    0x4897cd  COverlay hit test, 0x48a3db render callback, 0x42ba3a finish helper

Every image the scenario families use is first built by the ORIGINAL loader arm
and compared byte for byte with the native binding's image
(`session_a36_build_image`); the scenarios then feed the same bytes to the
original and to the RT-14 kernel, and the RT-14 comparison machinery (ordered
provider-call stream with state snapshots, ordered world stores, full state
after every operation) checks every step.

Hooks (enumerated in the report; none replaces a decision the original makes):

  replacement  0x51dc43  allocator (cdecl): returns a scripted block pre-filled
                         with 0xCD guard bytes (proves the original zeroes it)
  replacement  0x4c2790  CIFTREE surface load (ret 0x10)
  replacement  0x4fb77a 0x4fb2e3 0x4f6334 0x4fba69  sound record start/word/query/stop
                         (never reached by a 0x37 image: "NO SOUND")
  replacement  0x4c5377 / 0x4c5d4b  blits (ret 0x14)
  replacement  0x423d33  dependency tree reset (ret 4)
  replacement  IAT 0x52a23c GetTickCount
  fatal sinks  0x50ca3e 0x52139c 0x4c97b4 0x44a2b7 (stop; prove the native
               rejections of list / render / cache exhaustion)
  observation  every memory write, provider-call snapshots

    work/tools/oracle-python/bin/python \\
      outputs/blackmoor-decomp/tests/action_family_37_runtime_original_oracle.py
"""
import argparse
import ctypes as c
import json
from pathlib import Path
import random
import struct
import subprocess
import sys
import tempfile
import time

import action_family_36_runtime_original_oracle as rt14
from cif_original_oracle import PEImage
import test_action_family_36_runtime as native

ROOT = rt14.ROOT
REPORT = ROOT / 'work/analysis/slices/RT-18.oracle.json'
EXE_HASH = rt14.EXE_HASH
OracleError = rt14.OracleError
IMAGE_BYTES = native.IMAGE_BYTES
PROJECT = ROOT / 'outputs/blackmoor-decomp'

CODE_WINDOWS = [
    (0x40c446, 0x40c487, 'raw 0x37 loader arm', None),
    (0x48945b, 0x4895cc, 'overlay defaults 0x48945b', None),
    (0x4895cc, 0x489722, 'raw 0x37 constructor 0x4895cc', None),
] + rt14.CODE_WINDOWS

ALLOCATOR = 0x51dc43
LOADER_ENTRY, LOADER_EXIT = 0x40c446, 0x410a68
INDEX_CELL = 0x5c39e3            # word: the row index the loader arm reads
SCRATCH = rt14.OBJ_BASE + 0xA0000
BODY_VA = SCRATCH + 0x100
GUARD = 0x40


class Original37(rt14.Original):
    """The RT-14 machine plus the allocator hook and the real loader arm."""

    def __init__(self, pe, fpcw=0x27f):
        super().__init__(pe, fpcw)
        from unicorn import UC_HOOK_CODE
        self.rows = 1
        self.snapshotter = None
        self.alloc_to = None
        self.alloc_requests = []
        self.uc.hook_add(UC_HOOK_CODE, self.on_alloc, begin=ALLOCATOR, end=ALLOCATOR)

    def on_alloc(self, uc, address, size, user):
        esp = uc.reg_read(self.regs['ESP'])
        requested = struct.unpack('<I', uc.mem_read(esp + 4, 4))[0]
        self.alloc_requests.append(requested)
        if requested != IMAGE_BYTES or self.alloc_to is None:
            raise OracleError(('unexpected allocation request', requested))
        uc.mem_write(self.alloc_to, b'\xcd' * (IMAGE_BYTES + GUARD))
        self.count('REPLACE 0x51dc43 allocator (guard-filled block)')
        self.replace(0, self.alloc_to)       # cdecl: the caller pops the argument

    def loader_arm(self, row, body, rng, offset_in=0x1234):
        """Run the raw 0x37 loader arm 0x40c446..0x40c482 for `row` on `body`
        (69-byte prefix + dependency records). Returns (image bytes, details)."""
        uc, r = self.uc, self.regs
        uc.mem_write(STACK_FRAME_CLEAR[0], bytes(STACK_FRAME_CLEAR[1]))
        self.alloc_to = rt14.obj_va(row)
        uc.mem_write(INDEX_CELL, struct.pack('<h', row))
        uc.mem_write(rt14.objptr_va(row), struct.pack('<I', 0xDEADBEEF))
        uc.mem_write(rt14.ROW_BASE + row * rt14.ROW_STRIDE, b'\x77')
        uc.mem_write(rt14.MGR + 0x1c, struct.pack('<II', 0x11111111, 0x22222222))
        uc.mem_write(BODY_VA, bytes(body) + b'\x5a' * 16)
        frame = rt14.FRAME
        uc.mem_write(frame - 0x20, struct.pack('<I', BODY_VA))        # source cursor local
        uc.mem_write(frame - 0xcc, struct.pack('<I', offset_in))      # payload offset local
        self.alloc_requests = []
        status = self.run(LOADER_ENTRY, LOADER_EXIT, frame - 0x400, frame, rng=rng)
        if status != 'ok':
            raise OracleError(('loader arm reached an error sink', self.fatal))
        if self.alloc_requests != [IMAGE_BYTES]:
            raise OracleError(('allocation requests', self.alloc_requests))
        image_ptr = self.r32(rt14.objptr_va(row))
        image = bytes(uc.mem_read(image_ptr, IMAGE_BYTES))
        guard = bytes(uc.mem_read(image_ptr + IMAGE_BYTES, GUARD))
        details = dict(
            image_ptr=image_ptr, expected_ptr=self.alloc_to,
            row_type=uc.mem_read(rt14.ROW_BASE + row * rt14.ROW_STRIDE, 1)[0],
            cursor_after=self.r32(frame - 0x20), offset_after=self.r32(frame - 0xcc),
            manager_slots=(self.r32(rt14.MGR + 0x1c), self.r32(rt14.MGR + 0x20)),
            guard_intact=guard == b'\xcd' * GUARD,
            tail_intact=bytes(uc.mem_read(BODY_VA + len(body), 16)) == b'\x5a' * 16,
            body_intact=bytes(uc.mem_read(BODY_VA, len(body))) == bytes(body))
        allowed = [(image_ptr, IMAGE_BYTES), (rt14.objptr_va(row), 4),
                   (rt14.ROW_BASE + row * rt14.ROW_STRIDE, 1), (rt14.MGR + 0x1c, 8),
                   (rt14.STACK, rt14.STACK_SIZE)]
        bad = [w for w in self.write_log if not any(
            a <= w[0] and w[0] + w[1] <= a + n for a, n in allowed)]
        if bad:
            raise OracleError(('loader arm wrote outside its footprint', bad[:4]))
        return image, details


STACK_FRAME_CLEAR = (rt14.STACK, rt14.STACK_SIZE)


def build_lib():
    path = native.build_library() if 'A36_RUNTIME_LIBRARY' not in __import__('os').environ \
        else native.library_path()
    lib = native.bind(path)
    lib.session_a36_build_image.argtypes = [c.c_uint8, c.POINTER(c.c_uint8), c.c_size_t,
                                            c.POINTER(c.c_uint8)]
    lib.session_a36_build_image.restype = c.c_int
    return lib


def native_image(lib, body):
    owner = (c.c_uint8 * len(body)).from_buffer_copy(bytes(body))
    out = (c.c_uint8 * IMAGE_BYTES)()
    status = lib.session_a36_build_image(0x37, owner, len(body), out)
    if status != 0:
        raise OracleError(('native refused a valid 0x37 body', status))
    return bytes(out)


def body37(name, plain, layer, rect, geometry, deps=()):
    data = bytes(name) + b'\0' * (33 - len(name)) + struct.pack('<hh', plain, layer) + \
        struct.pack('<4i', *rect) + struct.pack('<4i', *geometry)
    assert len(data) == 0x45
    return data + b''.join(deps)


# ---- corpus --------------------------------------------------------------------------

def load_corpus():
    """Every raw 0x37 row of the decoded scene resources through the production parser
    (tests/action_family_37_runtime_corpus_dump.c). Returns {scene name: [(row, body, deps)]}."""
    resources = ROOT / 'work/analysis/hiff-resources'
    manifest = json.loads((ROOT / 'work/analysis/hiff-resources.json').read_text())
    names = {r['index']: r['name'] for r in manifest['resources']}
    with tempfile.TemporaryDirectory() as tmp:
        tool = Path(tmp) / 'corpus_dump'
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-std=c11', '-O2', '-I', str(PROJECT / 'src'),
                        str(PROJECT / 'tests/action_family_37_runtime_corpus_dump.c'),
                        str(PROJECT / 'src/scene_resource.c'), str(PROJECT / 'src/hiff.c'),
                        '-o', str(tool)], check=True, capture_output=True)
        files = sorted(str(p) for p in resources.glob('*.bin'))
        out = subprocess.run([str(tool)] + files, check=True, capture_output=True, text=True).stdout
    scenes = {}
    for line in out.splitlines():
        parts = line.split()
        if int(parts[3], 16) != 0x37:
            continue
        resource = int(Path(parts[0]).stem)
        scenes.setdefault(names[resource], []).append(
            (int(parts[1]), bytes.fromhex(parts[6]), [bytes.fromhex(x) for x in parts[7:]]))
    return scenes


# ---- families --------------------------------------------------------------------------

def check_constructor(original, lib, body, rng, row, stats):
    image, details = original.loader_arm(row, body, rng)
    expected = native_image(lib, body)
    if image != expected:
        diff = [i for i in range(IMAGE_BYTES) if image[i] != expected[i]]
        raise OracleError(('constructor image mismatch', row, diff[:16]))
    if (details['image_ptr'] != details['expected_ptr'] or details['row_type'] != 0x36 or
            details['cursor_after'] != BODY_VA + 0x45 or details['offset_after'] != 0x1234 + 0x45 or
            details['manager_slots'] != (details['image_ptr'],) * 2 or not details['guard_intact'] or
            not details['tail_intact'] or not details['body_intact']):
        raise OracleError(('loader arm effects', details))
    stats['constructor_images'] += 1
    stats['constructor_bytes'] += IMAGE_BYTES
    return image


def random_body(rng):
    length = rng.choice((0, 1, 5, 12, 31, 32, 32))
    name = bytes(rng.choice(b'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789 \x80\xff')
                 for _ in range(length))
    rect = tuple(rng.choice((rng.randrange(-100, 700), rng.randrange(-2 ** 31, 2 ** 31)))
                 for _ in range(4))
    geometry = tuple(rng.choice((rng.randrange(-100, 700), rng.randrange(-2 ** 31, 2 ** 31)))
                     for _ in range(4))
    deps = [bytes(rng.randrange(256) for _ in range(16)) for _ in range(rng.choice((0, 0, 1, 2)))]
    return body37(name, rng.choice((1, 1, 2, 0, -1, 32767, -32768)),
                  rng.choice((10, 11, 0, 5, 20, -1, 32767, -32768)), rect, geometry, deps)


def make_case(seed, images, *, subtypes=None, selector=0, rng=None, tick=0, held=-1, item_flag=0):
    """RT-14 base_case with the exact loader images (the 0x37 constructor zeroes the whole
    allocation, so no uninitialised-memory noise is added)."""
    rng = rng or random.Random(seed)
    case = rt14.base_case(seed, [None] * len(images), subtypes=subtypes, selector=selector,
                          rng=rng, tick=tick, held=held, item_flag=item_flag)
    for row, image in enumerate(images):
        if image is not None:
            case['images'][row] = bytes(image)
    return case


def name_of(image):
    return bytes(image[:image.index(0)])


def main(*, report_path=REPORT, quick=False, mutation=False):
    started = time.monotonic()
    lib = build_lib()
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    if rt14.sha(pe.data) != EXE_HASH:
        raise OracleError('executable mismatch')
    windows = []
    for start, end, label, digest in CODE_WINDOWS:
        actual = rt14.sha(pe.image[start - pe.image_base:end - pe.image_base])
        if digest is not None and actual != digest:
            raise OracleError('code window mismatch: ' + label)
        windows.append(dict(start=hex(start), end=hex(end), label=label, sha256=actual))
    stats = dict(constructor_images=0, constructor_bytes=0, registrations=0, visits=0, hits=0,
                 draws=0, finishes=0, events=0, draw_skipped_out_of_domain=0)
    families = {}
    pairs = []

    def family(name):
        families[name] = dict(scripts=0, steps=0, state_compares=0, events=0)
        return families[name]

    def account(f, pair):
        f['scripts'] += 1
        f['steps'] += pair.steps
        f['state_compares'] += pair.compares
        f['events'] += pair.events_compared
        pairs.append(pair)

    ctor_machine = Original37(pe)
    ctor_machine.load(rt14.base_case(0, [None] * 4))
    rng = random.Random(0x37)

    # F0: the real loader arm vs the native image, every corpus row
    corpus = load_corpus()
    total_rows = sum(len(v) for v in corpus.values())
    f = family('constructor-corpus')
    images_by_scene = {}
    for scene, rows in sorted(corpus.items()):
        built = []
        for index, (action, body, deps) in enumerate(rows):
            raw = body + b''.join(deps)
            image = check_constructor(ctor_machine, lib, raw, rng, row=index % 100, stats=stats)
            built.append((action, image))
            f['steps'] += 1
        images_by_scene[scene] = built
    f['scripts'] = len(corpus)
    # F0b: random valid bodies, any option / rectangle / geometry value, with dependency tails
    f = family('constructor-random')
    for index in range(150 if quick else 600 if mutation else 2500):
        r = random.Random(index * 104729 + 7)
        check_constructor(ctor_machine, lib, random_body(r), r, row=index % 100, stats=stats)
        f['steps'] += 1
    f['scripts'] = 1
    hook_counts = dict(ctor_machine.hook_counts)

    # F1: random scenes of 0x37 rows (+ random 0x36 rows in some)
    f = family('random-0x37-overlays')
    for seed in range(8 if quick else 50 if mutation else 140):
        r = random.Random(seed * 7919 + 37)
        count = r.choice((1, 2, 3, 5, 8))
        images = []
        for _ in range(count):
            if r.random() < 0.25:
                images.append(bytes(rt14.random_image(r, marker=1, force=dict(sound=b'NO SOUND', fps=15))))
            else:
                raw = random_body(r)
                images.append(check_constructor(ctor_machine, lib, raw, r, row=len(images), stats=stats))
        # a 0x37 body may carry a rectangle the draw cannot take; the kernel rejects such a
        # blit, so use well-formed geometry on half of the scenes
        case = make_case(10000 + seed, images, selector=r.choice((0, 0, 1, 2)), rng=r,
                         tick=r.randrange(2 ** 32), held=r.choice((-1, 4)),
                         item_flag=r.choice((0, 1)))
        if r.random() < 0.4:
            rt14.occupy_foreign(case, r, render_slots=r.sample(range(24, 64), r.randrange(1, 12)),
                                cache_slots=r.sample(range(24), r.randrange(0, 8)))
        account(f, rt14.run_registration_script(pe, lib, case, r, stats))

    # F2: every scene of the corpus with raw 0x37 rows (the real overlays), per selector
    f = family('corpus-scenes')
    tutorial_scenes = ('S6452', 'S6405', 'S6453', 'S6406', 'S6407', 'S6408', 'S6409')
    scene_names = sorted(images_by_scene)
    if quick:
        scene_names = [s for s in scene_names if s in tutorial_scenes][:2]
    for scene in scene_names:
        rows = images_by_scene[scene]
        size = max(a for a, _ in rows) + 1
        images = [None] * size
        for action, image in rows:
            images[action] = image
        selectors = (0, 3) if mutation or scene not in tutorial_scenes else (0, 1, 3, 16)
        for selector in selectors:
            seed = 20000 + int(scene[1:]) * 10 + selector
            r = random.Random(seed)
            case = make_case(seed, images, selector=selector, rng=r, tick=r.randrange(2 ** 32))
            account(f, rt14.run_registration_script(pe, lib, case, r, stats))
    families['corpus-scenes']['scene_count'] = len(scene_names)
    f = family('tutorial-scenes')
    for scene in tutorial_scenes:
        if scene not in images_by_scene:
            continue
        rows = images_by_scene[scene]
        size = max(a for a, _ in rows) + 1
        images = [None] * size
        for action, image in rows:
            images[action] = image
        for selector in (0, 2):
            r = random.Random(30000 + int(scene[1:]) + selector)
            case = make_case(30000 + int(scene[1:]) + selector, images, selector=selector, rng=r,
                             tick=r.randrange(2 ** 32))
            pair = rt14.Pair(pe, lib, case)
            pair.start()
            for row in range(size):
                if images[row] is not None:
                    pair.step(row, ticks=[1000])
            for x, y in ((0, 0), (300, 200), (320, 220), (400, 300)):
                pair.hit(x, y)
            for slot in range(24, 64):
                e = pair.rig.manager.render[slot]
                if e.active and e.callback and e.row >= 0 and rt14.draw_in_domain(pair, slot):
                    pair.draw(slot)
            for tick in range(5):                       # revisits never change a 0x37 row
                for row in range(size):
                    if images[row] is not None and pair.native_phases.get(row) == 1:
                        pair.step(row, ticks=[2000 + tick])
            for row in range(size):
                if images[row] is not None and pair.native_phases.get(row) != 1:
                    raise OracleError(('0x37 row did not wait in phase 1', scene, row))
            account(f, pair)
            stats['events'] += pair.events_compared

    # F3: AUTOTEXT names (surface globals): parity with provided globals
    f = family('autotext-names')
    for k in (1, 2, 3):
        raw = body37(b'USE_AUTOTEXT%d' % k, 1, 10, (5, 6, 60, 70), (1, 2, 40, 50))
        image = check_constructor(ctor_machine, lib, raw, rng, row=k, stats=stats)
        r = random.Random(40000 + k)
        case = make_case(40000 + k, [image], rng=r)
        pair = rt14.Pair(pe, lib, case)
        pair.start()
        pair.step(0, ticks=[0])
        for slot in range(24, 64):
            e = pair.rig.manager.render[slot]
            if e.active and e.callback and e.row >= 0 and rt14.draw_in_domain(pair, slot):
                pair.draw(slot)
        account(f, pair)

    # F4: unsafe original behaviour with a 0x37 image -> native rejection, proven by the sinks
    unsafe = {}
    r = random.Random(0xbad37)
    image = check_constructor(ctor_machine, lib, body37(b'SINK_OVL', 1, 10, (10, 20, 29, 39),
                                                       (5, 6, 24, 25)), r, row=0, stats=stats)
    case = make_case(900, [image], rng=r)
    case['manager']['count'] = 40
    pair = rt14.Pair(pe, lib, case)
    pair.start()
    unsafe['list_full_40'] = pair.step(0, ticks=[0], expect_fatal=True)[1]
    case = make_case(901, [image], rng=r)
    rt14.occupy_foreign(case, r, render_slots=range(24, 64))
    pair = rt14.Pair(pe, lib, case)
    pair.start()
    unsafe['render_table_full'] = pair.step(0, ticks=[0], expect_fatal=True)[1]
    case = make_case(902, [image], rng=r)
    rt14.occupy_foreign(case, r, cache_slots=range(24))
    pair = rt14.Pair(pe, lib, case)
    pair.start()
    unsafe['surface_cache_full'] = pair.step(0, ticks=[0], expect_fatal=True)[1]
    families['unsafe-domain'] = dict(scripts=3, steps=3, state_compares=0, events=0)

    # F5: the original's behaviour for the shape the native app cannot serve (reported, not compared)
    divergences = dict(
        autotext_surface_missing='native refuses a USE_AUTOTEXT1..3 row when the host provides no '
                                  'surface global (0x5d0397/9b/9f = 0); the original proceeds with '
                                  'whatever the AUTOTEXT subsystem stored there')

    totals = dict(scripts=sum(f['scripts'] for f in families.values()),
                  steps=sum(f['steps'] for f in families.values()),
                  state_compares=sum(f['state_compares'] for f in families.values()),
                  ordered_events=sum(f['events'] for f in families.values()))
    for pair in pairs:
        for name, n in pair.original.hook_counts.items():
            hook_counts[name] = hook_counts.get(name, 0) + n
    report = dict(
        exe_sha256=EXE_HASH, code_windows=windows, families=families, totals=totals, stats=stats,
        corpus=dict(raw_0x37_rows=total_rows, scenes=len(corpus)),
        unsafe_original_behaviour=unsafe, deliberate_divergences=divergences, hook_counts=hook_counts,
        hooks=['REPLACE 0x51dc43 allocator (guard-filled, scripted address)',
               'REPLACE 0x4c2790 CIFTREE surface load (ret 0x10)',
               'REPLACE 0x4fb77a / 0x4fb2e3 sound record start + word (ret 4 each; unreachable for 0x37)',
               'REPLACE 0x4f6334 sound query (ret 4)', 'REPLACE 0x4fba69 sound stop (ret 4)',
               'REPLACE 0x4c5377 / 0x4c5d4b blits (ret 0x14)', 'REPLACE 0x423d33 dependency reset (ret 4)',
               'REPLACE IAT 0x52a23c GetTickCount (scripted)',
               'FATAL SINKS 0x50ca3e 0x52139c 0x4c97b4 0x44a2b7 (stop; only the unsafe-domain cases may reach them)',
               'OBSERVE memory writes (classified) and provider-call state snapshots'],
        real_code=['0x40c446..0x40c482 raw 0x37 loader arm incl. type store 0x36',
                   '0x4895cc constructor and 0x48945b defaults', '0x428083 dispatcher arm with real gate 0x423f57',
                   '0x4899ca Process with real 0x50d0bc, 0x4c948f, 0x4d39f9, 0x4d36ed, 0x42ba3a',
                   '0x4897cd hit test', '0x48a3db render callback'],
        unmodeled=['sound manager and surface manager internals', 'foreign users of the render table and '
                   'surface cache (occupancy only)', 'dependency tree contents (the gate runs on an empty tree; '
                   'dependencies are covered by the executor/session unit tests)',
                   'raw 0x38 loader arm (0x40c404, constructor 0x48905b): out of scope'],
        elapsed_seconds=round(time.monotonic() - started, 1))
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2, sort_keys=True) + '\n')
    print(json.dumps(dict(totals=totals, stats=stats, unsafe=unsafe, corpus=report['corpus'],
                          elapsed=report['elapsed_seconds']), indent=2))
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--quick', action='store_true')
    parser.add_argument('--mutation', action='store_true', help='reduced but meaningful run for mutation checks')
    parser.add_argument('--report', default=str(REPORT))
    args = parser.parse_args()
    main(quick=args.quick, mutation=args.mutation, report_path=Path(args.report))
