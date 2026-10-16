#!/usr/bin/env python3
"""RT-31: original-x86 oracle for raw 0x38 rows running through the COverlay runtime.

Runs the unmodified original under Unicorn (same machine as the RT-14 and RT-18 oracles):

    0x40c404..0x40c441  the loader arm of raw 0x38: real constructor 0x48905b (allocation, the
                        0xac-byte clear, name, options, frame table, the one secondary record,
                        cursor/offset advance) and the type store 0x36 (0x40c43a), run through
                        the real arm
    0x428083  dispatcher arm 0x36 -> real dependency gate 0x423f57 (empty tree)
              -> 0x4899ca COverlay::Process (RT-14 harness, all callees real)
    0x4897cd  COverlay hit test, 0x48a3db render callback, 0x42ba3a finish helper

Every image the scenario families use is first built by the ORIGINAL loader arm. The constructor
leaves most of the 0xABA allocation to the allocator, so the arm is run twice per body, once with
an allocator that returns 0xCD bytes and once with zeros: the native binding image
(`session_a36_build_image`, raw 0x38) must equal the zero-filled image exactly, and the two original
images may differ only outside the ranges the constructor writes (the clear + options 0..0xac, the
frame table, the secondary record 0x6ec..0x712). The scenarios then feed the same bytes to the
original and to the RT-14 kernel (half of them on the 0xCD image, half on the native one), and the
RT-14 comparison machinery (ordered provider-call stream with state snapshots, ordered world
stores, full state after every operation) checks every step; the animation family also steps rows
through whole frame cycles.

Hooks (enumerated in the report; none replaces a decision the original makes):

  replacement  0x51dc43  allocator (cdecl): returns a scripted block pre-filled with the fill byte
  replacement  0x4c2790  CIFTREE surface load (ret 0x10)
  replacement  0x4fb77a 0x4fb2e3 0x4f6334 0x4fba69  sound record start/word/query/stop
                         (never reached by a 0x38 image: "NO SOUND")
  replacement  0x4c5377 / 0x4c5d4b  blits (ret 0x14)
  replacement  0x423d33  dependency tree reset (ret 4)
  replacement  IAT 0x52a23c GetTickCount
  fatal sinks  0x50ca3e 0x52139c 0x4c97b4 0x44a2b7 (stop; prove the native
               rejections of list / render / cache exhaustion)
  observation  every memory write, provider-call snapshots

    python3 outputs/blackmoor-decomp/tests/action_family_38_runtime_original_oracle.py
"""
import argparse
import ctypes as c
import json
import os
from pathlib import Path
import random
import shutil
import struct
import subprocess
import sys
import tempfile
import time

import action_family_36_runtime_original_oracle as rt14
import action_family_37_runtime_original_oracle as o37
from cif_original_oracle import PEImage
import test_action_family_36_runtime as native

ROOT = rt14.ROOT
REPORT = ROOT / 'work/analysis/slices/RT-31.oracle.json'
EXE_HASH = rt14.EXE_HASH
OracleError = rt14.OracleError
IMAGE_BYTES = native.IMAGE_BYTES
PROJECT = ROOT / 'outputs/blackmoor-decomp'
PREFIX = 71
FRAME = 16

CODE_WINDOWS = [
    (0x40c404, 0x40c446, 'raw 0x38 loader arm',
     '91d1793c0449a2b52c4c86258ffd406650621dfe2a8c832a91ecf3cd79fac220'),
    (0x48905b, 0x48945b, 'raw 0x38 constructor 0x48905b',
     'dec6ed30bb68f52ce12da80e7bbcc975b623c34f9481db1705dccfedaf4662b8'),
] + rt14.CODE_WINDOWS

LOADER_ENTRY, LOADER_EXIT = 0x40c404, 0x410a68
INDEX_CELL = o37.INDEX_CELL
BODY_VA = o37.BODY_VA
GUARD = o37.GUARD
STACK_FRAME_CLEAR = o37.STACK_FRAME_CLEAR


class Original38(o37.Original37):
    """The RT-14 machine plus the allocator hook and the real raw 0x38 loader arm."""

    fill = 0xcd

    def on_alloc(self, uc, address, size, user):
        esp = uc.reg_read(self.regs['ESP'])
        requested = struct.unpack('<I', uc.mem_read(esp + 4, 4))[0]
        self.alloc_requests.append(requested)
        if requested != IMAGE_BYTES or self.alloc_to is None:
            raise OracleError(('unexpected allocation request', requested))
        uc.mem_write(self.alloc_to, bytes([self.fill]) * (IMAGE_BYTES + GUARD))
        self.count('REPLACE 0x51dc43 allocator (fill-byte block)')
        self.replace(0, self.alloc_to)       # cdecl: the caller pops the argument

    def loader_arm(self, row, body, rng, offset_in=0x1234, fill=0xcd):
        """Run the raw 0x38 loader arm 0x40c404..0x40c441 for `row` on `body` (typed body plus
        dependency records) with the allocator returning `fill` bytes."""
        self.fill = fill
        uc = self.uc
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
            guard_intact=guard == bytes([fill]) * GUARD,
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


# ---- bodies ---------------------------------------------------------------------------------

def body38(name=b'CON_GrennyANIM_OVL', *, options=(2, 1, 2, 10, 1, 2, 9999, 0xffff, 0), start=0,
           count=4, rect=(70, 80, 135, 149), frames=None, deps=()):
    """The raw 0x38 body (A-38.1): name[33], nine option words at 0x21..0x31, frame start and
    end, the fixed rectangle, then 16-byte frame records and 16-byte dependency records."""
    data = bytes(name) + b'\0' * (33 - len(name)) + struct.pack('<9H', *options) + \
        struct.pack('<hh4i', start, start + count - 1, *rect)
    assert len(data) == PREFIX
    if frames is None:
        frames = [struct.pack('<4i', 10 * i, 5 * i, 10 * i + 64, 5 * i + 68) for i in range(max(count, 0))]
    return data + b''.join(frames) + b''.join(deps)


def typed_length(body):
    start, end = struct.unpack_from('<hh', body, 0x33)
    return PREFIX + FRAME * (end - start + 1)


def native_image(lib, body):
    owner = (c.c_uint8 * len(body)).from_buffer_copy(bytes(body))
    out = (c.c_uint8 * IMAGE_BYTES)()
    status = lib.session_a36_build_image(0x38, owner, len(body), out)
    if status != 0:
        raise OracleError(('native refused a valid 0x38 body', status))
    return bytes(out)


def written_ranges(body):
    return [(0, 0xac), (0xac, 0xac + typed_length(body) - PREFIX), (0x6ec, 0x6ec + 38)]


def build_lib():
    path = native.build_library() if 'A36_RUNTIME_LIBRARY' not in __import__('os').environ \
        else native.library_path()
    lib = native.bind(path)
    lib.session_a36_build_image.argtypes = [c.c_uint8, c.POINTER(c.c_uint8), c.c_size_t,
                                            c.POINTER(c.c_uint8)]
    lib.session_a36_build_image.restype = c.c_int
    return lib


# ---- corpus ---------------------------------------------------------------------------------

def load_corpus():
    """Every raw 0x38 row of the decoded scene resources through the production parser
    (tests/action_family_38_runtime_corpus_dump.c). Returns {scene name: [(row, body+deps)]}."""
    resources = ROOT / 'work/analysis/hiff-resources'
    manifest = json.loads((ROOT / 'work/analysis/hiff-resources.json').read_text())
    names = {r['index']: r['name'] for r in manifest['resources']}
    compiler = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    with tempfile.TemporaryDirectory() as tmp:
        tool = Path(tmp) / 'corpus_dump'
        subprocess.run([compiler, '-std=c11', '-O2', '-I', str(PROJECT / 'src'),
                        str(PROJECT / 'tests/action_family_38_runtime_corpus_dump.c'),
                        str(PROJECT / 'src/scene_resource.c'), str(PROJECT / 'src/hiff.c'),
                        '-o', str(tool)], check=True, capture_output=True)
        files = sorted(str(p) for p in resources.glob('*.bin'))
        out = subprocess.run([str(tool)] + files, check=True, capture_output=True, text=True).stdout
    scenes = {}
    for line in out.splitlines():
        parts = line.split()
        resource = int(Path(parts[0]).stem)
        body = bytes.fromhex(parts[5]) + b''.join(bytes.fromhex(x) for x in parts[6:])
        scenes.setdefault(names[resource], []).append((int(parts[1]), body))
    return scenes


# ---- families --------------------------------------------------------------------------------

def check_constructor(original, lib, body, rng, row, stats):
    """The real loader arm vs the native image. Returns (zero-filled image, 0xCD-filled image)."""
    offset_in = rng.choice((0x1234, 0, 0xfffffff0, 0x7fffffff))
    image_cd, details = original.loader_arm(row, body, rng, offset_in=offset_in, fill=0xcd)
    image_00, details_00 = original.loader_arm(row, body, rng, offset_in=offset_in, fill=0x00)
    expected = native_image(lib, body)
    if image_00 != expected:
        diff = [i for i in range(IMAGE_BYTES) if image_00[i] != expected[i]]
        raise OracleError(('constructor image mismatch', row, diff[:16]))
    typed = typed_length(body)
    ranges = written_ranges(body)
    for offset in range(IMAGE_BYTES):
        inside = any(a <= offset < b for a, b in ranges)
        if inside and image_cd[offset] != image_00[offset]:
            raise OracleError(('constructor-defined byte depends on the allocator fill', row, offset))
        if not inside and (image_cd[offset], image_00[offset]) != (0xcd, 0):
            raise OracleError(('constructor wrote outside the modeled ranges', row, offset))
    for d in (details, details_00):
        if (d['image_ptr'] != d['expected_ptr'] or d['row_type'] != 0x36 or
                d['cursor_after'] != BODY_VA + typed or
                d['offset_after'] != (offset_in + typed) & 0xffffffff or
                d['manager_slots'] != (d['image_ptr'],) * 2 or not d['guard_intact'] or
                not d['tail_intact'] or not d['body_intact']):
            raise OracleError(('loader arm effects', details, typed))
    stats['constructor_images'] += 1
    stats['constructor_bytes'] += IMAGE_BYTES
    return image_00, image_cd


def random_body(rng):
    length = rng.choice((0, 1, 5, 12, 31, 32, 32))
    name = bytes(rng.choice(b'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789 \x80\xff')
                 for _ in range(length))
    count = rng.choice((0, 1, 2, 3, 4, 4, 4, 16, 17, 99, 100))
    start = rng.choice((0, 0, 0, 1, -3, 7)) if count else rng.choice((0, 5))
    options = (rng.choice((2, 1, 0, -1, 32767)),           # 0x21 -> flag
               rng.choice((1, 1, 2, 0, -1, 32767, -32768)),  # 0x23 plain blit
               rng.choice((2, 2, 1, 0, 3)),                 # 0x25 scene-change option
               rng.choice((10, 11, 0, 5, 20, -1, 32767, -32768)),  # 0x27 layer
               rng.choice((1, 1, 2, 0, 3)),                 # 0x29 direction
               rng.choice((2, 2, 1, 0, 3)),                 # 0x2b loop
               rng.choice((9999, 0, 5, 300, -1)),            # 0x2d scene word
               rng.choice((0xffff, 0xffff, 0, 5, 77, 299)),  # 0x2f event index
               rng.choice((0, 1, 2, 7, -1)))                 # 0x31 value
    options = tuple(v & 0xffff for v in options)
    rect = tuple(rng.choice((rng.randrange(-100, 700), rng.randrange(-2 ** 31, 2 ** 31)))
                 for _ in range(4)) if rng.random() < 0.3 else \
        (rng.randrange(0, 300), rng.randrange(0, 200), rng.randrange(300, 640), rng.randrange(200, 480))
    frames = None
    if rng.random() < 0.3:
        frames = [bytes(rng.randrange(256) for _ in range(FRAME)) for _ in range(count)]
    deps = [bytes(rng.randrange(256) for _ in range(16)) for _ in range(rng.choice((0, 0, 1, 2)))]
    return body38(name, options=options, start=start, count=count, rect=rect, frames=frames, deps=deps)


def make_case(seed, images, *, subtypes=None, selector=0, rng=None, tick=0, held=-1, item_flag=0):
    case = rt14.base_case(seed, [None] * len(images), subtypes=subtypes, selector=selector,
                          rng=rng or random.Random(seed), tick=tick, held=held, item_flag=item_flag)
    # rt14.base_case adds noise to the runtime bytes 0xaa2..0xaba; start from the exact loader
    # image and keep that noise only in the runtime window, like the other families
    noise = rt14.base_case(seed, [bytes(IMAGE_BYTES)] * len(images), subtypes=subtypes,
                           selector=selector, rng=random.Random(seed ^ 0x3838), tick=tick)
    for row, image in enumerate(images):
        if image is not None:
            data = bytearray(image)
            data[0xaa2:0xaba] = noise['images'][row][0xaa2:0xaba]
            case['images'][row] = bytes(data)
    return case


def account_factory(families, hook_counts):
    def family(name):
        families[name] = dict(scripts=0, steps=0, state_compares=0, events=0)
        return families[name]

    def account(f, pair):
        f['scripts'] += 1
        f['steps'] += pair.steps
        f['state_compares'] += pair.compares
        f['events'] += pair.events_compared
        for name, n in pair.original.hook_counts.items():
            hook_counts[name] = hook_counts.get(name, 0) + n
    return family, account


def animate(pair, rows, images, stats, seen, ticks):
    """Registers every row, then steps them through `ticks` (a time series), drawing after every
    tick; records the animation frames the original actually visited."""
    for row in rows:
        pair.step(row, ticks=[ticks[0]], query=0)
        stats['registrations'] += 1
    for t in ticks[1:]:
        for row in rows:
            if pair.native_phases.get(row) == 1:
                pair.step(row, ticks=[t], query=0)
                stats['visits'] += 1
        for slot in range(24, 64):
            e = pair.rig.manager.render[slot]
            if e.active and e.callback and e.row >= 0 and rt14.draw_in_domain(pair, slot):
                pair.draw(slot)
                stats['draws'] += 1
        for row in rows:
            seen.setdefault(row, set()).add(native.image_s16(bytes(pair.rig.buffers[row]), 0xaae))


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
    families, hook_counts = {}, {}
    family, account = account_factory(families, hook_counts)

    ctor_machine = Original38(pe)
    ctor_machine.load(rt14.base_case(0, [None] * 4))
    rng = random.Random(0x38)

    # F0: the real loader arm vs the native image, every corpus row
    corpus = load_corpus()
    total_rows = sum(len(v) for v in corpus.values())
    f = family('constructor-corpus')
    images_by_scene = {}
    for scene, rows in sorted(corpus.items()):
        built = []
        for index, (action, body) in enumerate(rows):
            zero, noisy = check_constructor(ctor_machine, lib, body, rng, row=index % 100, stats=stats)
            built.append((action, zero, noisy))
            f['steps'] += 1
        images_by_scene[scene] = built
    f['scripts'] = len(corpus)
    # F0b: random valid bodies, any option / rectangle / frame range / frame record value
    f = family('constructor-random')
    for index in range(150 if quick else 600 if mutation else 2500):
        r = random.Random(index * 104729 + 38)
        check_constructor(ctor_machine, lib, random_body(r), r, row=index % 100, stats=stats)
        f['steps'] += 1
    f['scripts'] = 1
    for name, n in ctor_machine.hook_counts.items():
        hook_counts[name] = hook_counts.get(name, 0) + n

    # F1: random scenes of 0x38 rows (+ random 0x36 rows in some)
    f = family('random-0x38-overlays')
    for seed in range(8 if quick else 50 if mutation else 140):
        r = random.Random(seed * 7919 + 38)
        count = r.choice((1, 2, 3, 5, 8))
        images = []
        for _ in range(count):
            if r.random() < 0.2:
                images.append(bytes(rt14.random_image(r, marker=1, force=dict(sound=b'NO SOUND', fps=15))))
            else:
                zero, noisy = check_constructor(ctor_machine, lib, random_body(r), r,
                                                row=len(images), stats=stats)
                images.append(noisy if r.random() < 0.5 else zero)
        case = make_case(10000 + seed, images, selector=r.choice((0, 0, 1, 2)), rng=r,
                         tick=r.randrange(2 ** 32), held=r.choice((-1, 4)),
                         item_flag=r.choice((0, 1)))
        if r.random() < 0.4:
            rt14.occupy_foreign(case, r, render_slots=r.sample(range(24, 64), r.randrange(1, 12)),
                                cache_slots=r.sample(range(24), r.randrange(0, 8)))
        account(f, rt14.run_registration_script(pe, lib, case, r, stats))

    # F2: every scene of the corpus with raw 0x38 rows (the real overlays), per selector, on the
    # native image (zero fill) and on the original's own 0xCD-filled image
    f = family('corpus-scenes')
    scene_names = sorted(images_by_scene)
    if quick:
        scene_names = scene_names[:2]
    elif mutation:
        scene_names = scene_names[::4]
    for scene in scene_names:
        rows = images_by_scene[scene]
        size = max(a for a, _, _ in rows) + 1
        for fill_index in (0, 1):
            images = [None] * size
            for action, zero, noisy in rows:
                images[action] = (zero, noisy)[fill_index]
            for selector in ((0, 3) if mutation or quick else (0, 1, 3, 16)):
                seed = 20000 + int(scene[1:]) * 10 + selector + fill_index * 7
                r = random.Random(seed)
                case = make_case(seed, images, selector=selector, rng=r, tick=r.randrange(2 ** 32))
                account(f, rt14.run_registration_script(pe, lib, case, r, stats))
    families['corpus-scenes']['scene_count'] = len(scene_names)

    # F3: animation. Every row of the scene registers and is then stepped through a time series
    # that covers several full frame cycles at 15 frames per second (interval 66 ms), the draw
    # callback runs after every tick. The wrap loop (option 0x2b = 2) must visit every frame.
    f = family('animation-cycles')
    seen_frames = {}
    anim_scenes = scene_names[:3] if quick or mutation else scene_names
    for scene in anim_scenes:
        rows = images_by_scene[scene]
        size = max(a for a, _, _ in rows) + 1
        images = [None] * size
        for action, zero, noisy in rows:
            images[action] = zero
        order = [a for a, _, _ in rows][:12]
        r = random.Random(30000 + int(scene[1:]))
        base = r.randrange(0, 2 ** 31)
        case = make_case(30000 + int(scene[1:]), images, rng=r, tick=base)
        pair = rt14.Pair(pe, lib, case)
        pair.start()
        seen = {}
        animate(pair, order, images, stats, seen, [base] + [base + 20 * k for k in range(1, 90 if quick else 160)])
        for row in order:
            frames = native.image_s16(images[row], 0x35) - native.image_s16(images[row], 0x33) + 1
            seen_frames[(scene, row)] = (frames, len(seen.get(row, ())))
            if frames > 0 and len(seen.get(row, ())) < min(frames, 4):
                raise OracleError(('animation did not cycle', scene, row, frames, sorted(seen.get(row, ()))))
        account(f, pair)
    # the longest corpus loops (16 and 100 frames) and every direction / loop option combination
    f = family('animation-options')
    r = random.Random(0x3839)
    for direction in (1, 2, 3):
        for loop in (1, 2, 3):
            for start_frame in (0, 2):
                options = (2, 1, 2, 10, direction, loop, 9999, 0xffff, start_frame)
                zero, noisy = check_constructor(ctor_machine, lib,
                                                body38(b'DIR%d_LOOP%d' % (direction, loop),
                                                       options=options, count=5), r, row=3, stats=stats)
                case = make_case(31000 + direction * 10 + loop + start_frame, [zero],
                                 rng=r, tick=r.randrange(2 ** 31))
                pair = rt14.Pair(pe, lib, case)
                pair.start()
                animate(pair, [0], [zero], stats, {}, [1000] + [1000 + 33 * k for k in range(1, 60)])
                account(f, pair)

    # F4: driving a registered row to its finish (event pair, scene-change option 1)
    f = family('finish')
    for index, (option25, pair_index, pair_value) in enumerate(
            ((1, 0xffff, 0), (1, 12, 3), (2, 12, 3), (0, 40, -1 & 0xffff), (1, 40, 5))):
        r = random.Random(32000 + index)
        options = (2, 1, option25, 10, 1, 2, 9999 if index < 3 else 41, pair_index, pair_value)
        zero, _ = check_constructor(ctor_machine, lib, body38(b'FINISH_OVL', options=options, count=3),
                                    r, row=1, stats=stats)
        case = make_case(32000 + index, [zero], rng=r, tick=5000)
        pair = rt14.Pair(pe, lib, case)
        pair.start()
        pair.step(0, ticks=[5000], query=0)
        pair.mutate(phases={0: 2})
        pair.step(0, ticks=[5100], query=0)
        stats['finishes'] += 1
        account(f, pair)

    # F5: unsafe original behaviour with a 0x38 image -> native rejection, proven by the sinks
    unsafe = {}
    r = random.Random(0xbad38)
    image, _ = check_constructor(ctor_machine, lib, body38(b'SINK_OVL'), r, row=0, stats=stats)
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

    divergences = dict(
        frame_count_over_100='the original copies count * 16 bytes into a 100-row table without a bound '
                             '(0x48905b); native refuses a frame range of more than 100 records before any '
                             'effect (no corpus row, A-38.1)',
        frame_start_not_zero='with a nonzero start frame the animation indexes primary records the '
                             'constructor never wrote; the original reads allocator bytes there, native '
                             'rejects the draw (outside the valid-input domain; no corpus row)',
        autotext_surface_missing='as for raw 0x37: a USE_AUTOTEXT1..3 name needs the host surface globals '
                                  '(no corpus row)')

    totals = dict(scripts=sum(f['scripts'] for f in families.values()),
                  steps=sum(f['steps'] for f in families.values()),
                  state_compares=sum(f['state_compares'] for f in families.values()),
                  ordered_events=sum(f['events'] for f in families.values()))
    report = dict(
        exe_sha256=EXE_HASH, code_windows=windows, families=families, totals=totals, stats=stats,
        corpus=dict(raw_0x38_rows=total_rows, scenes=len(corpus)),
        animation_frames_seen={f'{s}:{r_}': v for (s, r_), v in sorted(seen_frames.items())},
        unsafe_original_behaviour=unsafe, deliberate_divergences=divergences, hook_counts=hook_counts,
        hooks=['REPLACE 0x51dc43 allocator (fill byte 0xCD or 0x00, scripted address)',
               'REPLACE 0x4c2790 CIFTREE surface load (ret 0x10)',
               'REPLACE 0x4fb77a / 0x4fb2e3 sound record start + word (ret 4 each; unreachable for 0x38)',
               'REPLACE 0x4f6334 sound query (ret 4)', 'REPLACE 0x4fba69 sound stop (ret 4)',
               'REPLACE 0x4c5377 / 0x4c5d4b blits (ret 0x14)', 'REPLACE 0x423d33 dependency reset (ret 4)',
               'REPLACE IAT 0x52a23c GetTickCount (scripted)',
               'FATAL SINKS 0x50ca3e 0x52139c 0x4c97b4 0x44a2b7 (stop; only the unsafe-domain cases may reach them)',
               'OBSERVE memory writes (classified) and provider-call state snapshots'],
        real_code=['0x40c404..0x40c441 raw 0x38 loader arm incl. type store 0x36',
                   '0x48905b constructor', '0x428083 dispatcher arm with real gate 0x423f57',
                   '0x4899ca Process with real 0x50d0bc, 0x4c948f, 0x4d39f9, 0x4d36ed, 0x42ba3a',
                   '0x4897cd hit test', '0x48a3db render callback'],
        unmodeled=['sound manager and surface manager internals', 'foreign users of the render table and '
                   'surface cache (occupancy only)', 'dependency tree contents (the gate runs on an empty tree; '
                   'dependencies are covered by the executor/session unit tests)'],
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
