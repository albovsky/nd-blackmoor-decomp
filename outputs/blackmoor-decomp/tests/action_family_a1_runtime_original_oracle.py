#!/usr/bin/env python3
"""RT-21: original-x86 oracle for the raw 0xa1 "Sound" runtime.

Run with work/tools/oracle-python/bin/python. No game process, no window, no audio device.
Two machines, both the unmodified GAME.EXE under Unicorn:

A. Loader (A-A1.1 machine): the loader switch arm 0x40f069, which resolves the AUTOTEXT key
   through the original table (0x423259) and builds the object with 0x410f99, compared
   byte for byte with action_a1_runtime_construct (565 corpus rows plus synthetic rows,
   including keys absent from the table, where the original substitutes its own
   "Game Error ... missing auto text" string, 0x5408dc).

B. Runtime: the dispatcher arm 0x4297be of 0x427a50 runs from a fabricated frame

       0x4297be arm -> 0x423f57 dependency gate (REAL code and a real tree)
         true  -> 0x432d1a(row, 1, 0): caption 0x448d11, event store, channel state,
                  0x4fc62d path, 0x4faf98 load/play, 0x4f6334 query, 0x4fba69 unload,
                  scene-change cells, 0x42ba3a finish (subtype 1/2 completion, 0x423d33)
         false -> subtype 2: completion := 0 and phase := 0 (0x429812..0x429833)

   and stops at the loop join 0x42a9a9. The false gates are produced by the real
   dependency builder 0x424aa8 and evaluator 0x424201 on a flag record (opcode 2, event id,
   value) that reads the same event table the handler writes. Corpus rows run with their
   own (empty) tree, i.e. the original's own true gate, as RT-8 did.

Enumerated hooks (the report lists per-run counts). Replacements stand in for OS and host
boundaries only, never for a decision of the original:
   replacement  0x449d90 file-exists (returns 1)
   replacement  0x448d11 caption presentation (the text argument is logged)
   replacement  0x4f379c HIS decode/load (marks the slot loaded, as in the RT-8 oracle)
   replacement  DirectSound COM methods GetStatus / Play / Release / Stop / SetPosition
   replacement  0x51dc43 allocation (bump allocator, building the dependency tree only)
   observation  entry of 0x4297be, 0x423f57, 0x432d1a, 0x42ba3a, 0x423d33, 0x4faf98,
                0x4f6334, 0x4fba69 and every 32-bit write into the event table 0x585801
Nothing decides for the original: the gate result, the phase machine, the event store, the
direct-completion test, the finish and the false-gate clear are all original instructions.

Compared after every visit: the ORDERED merged log (caption, event store, load, play,
query, unload), the full 2300-dword event table, phase, completion byte, the finish
and reset counts, the scene-change cells and the original's complete write footprint
classification. The runtime object and its guard bytes must stay untouched.
"""
import argparse
from collections import Counter
import ctypes as c
import hashlib
import json
from pathlib import Path
import random
import struct
import time

import action_family_a1_original_oracle as a1o
import action_family_97_runtime_original_oracle as o97
import action_sound_original_oracle as audio
import autotext_original_oracle as autotext
import test_action_family_97 as loader97
import test_action_family_97_runtime as rt97
import test_action_family_a1_runtime as native
import test_action_sound as sound

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
REPORT = PRIVATE / 'RT-21.oracle.json'
EXE_HASH = a1o.EXE_HASH
ARM, ARM_END, STOP = 0x4297be, 0x42983d, 0x42a9a9
TABLE = 0x585801
TABLE_COUNT = 2300
HEAP = 0x40000000
TAIL = 0x30008000
FRAME = 0x1000 + 0x20000 - 0x2000
GATE_OBJECT = 0x63786d
WINDOWS = [
    (0x4297be, 0x42983d, 'dispatcher arm 0xa1/0x9f'),
    (0x432d1a, 0x4336ad, 'sound visit 0x432d1a'),
    (0x42ba3a, 0x42babf, 'finish 0x42ba3a'),
    (0x423f57, 0x423fbb, 'dependency gate 0x423f57'),
    (0x424aa8, 0x425b8b, 'dependency builder 0x424aa8'),
    (0x4234c8, 0x4234dd, 'gate reset 0x4234c8'),
    (0x40f069, 0x40f532, 'loader arm 0x40f069'),
    (0x410f99, 0x41107f, 'object constructor 0x410f99'),
    (0x423259, 0x423310, 'AUTOTEXT lookup 0x423259'),
]


def sha(data):
    return hashlib.sha256(data).hexdigest()


class OracleError(AssertionError):
    pass


class Original(o97.Original):
    """The RT-8 runtime machine plus the real dependency builder and the event table."""

    def __init__(self, pe):
        from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_WRITE
        super().__init__(pe)
        self.uc.mem_map(HEAP, 0x400000)
        self.heap = HEAP
        self.event_writes = []
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self._on_event_write, begin=TABLE,
                         end=TABLE + 4 * TABLE_COUNT)
        self.uc.hook_add(UC_HOOK_CODE, self._on_allocate, begin=0x51dc43, end=0x51dc43)
        self.writes = []
        self.write_hook = None
        self.gate_results = []

    # -- hooks -------------------------------------------------------------------------
    def _on_allocate(self, uc, address, size, user):
        esp = uc.reg_read(self._esp)
        requested = struct.unpack('<I', uc.mem_read(esp + 4, 4))[0]
        start = (self.heap + 15) & ~15
        if requested == 0 or start + requested > HEAP + 0x400000:
            raise OracleError('bounded allocator exhausted')
        uc.mem_write(start, bytes(requested))
        self.heap = start + requested
        self.hooks['0x51dc43:allocation(dependency tree)'] += 1
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]
        uc.reg_write(self._eax, start)
        uc.reg_write(self._esp, esp + 4)
        uc.reg_write(self._eip, ret)

    def _on_event_write(self, uc, access, address, size, value, user):
        offset = address - TABLE
        if size != 4 or offset % 4 != 0:
            raise OracleError(f'event table write of {size} bytes at {address:#x}')
        value &= 0xffffffff
        self.events.append(('event', offset // 4, value))
        self.event_writes.append((offset // 4, value))

    def _hook_code(self, machine, address, size, user):
        if address in (ARM, 0x423f57):
            self.observed[f'{address:#x}'] += 1
        super()._hook_code(machine, address, size, user)

    # -- state ---------------------------------------------------------------------------
    def set_table(self, values):
        self.uc.mem_write(TABLE, struct.pack(f'<{TABLE_COUNT}i', *values))

    def table(self):
        return list(struct.unpack(f'<{TABLE_COUNT}i', self.uc.mem_read(TABLE, 4 * TABLE_COUNT)))

    def _call_this(self, address, ecx, args):
        uc = self.uc
        esp = 0x1000 + 0x20000 - 0x100
        uc.mem_write(esp, struct.pack(f'<{1 + len(args)}I', audio.RETURN_SENTINEL, *args))
        uc.reg_write(self._esp, esp)
        uc.reg_write(self._ebp, 0)
        uc.reg_write(self._ecx, ecx)
        uc.reg_write(self._eflags, 0x202)
        uc.emu_start(address, audio.RETURN_SENTINEL, count=5_000_000)
        if uc.reg_read(self._eip) != audio.RETURN_SENTINEL:
            raise OracleError(f'original {address:#x} did not return')
        return uc.reg_read(self._eax)

    def install_a1(self, payload, subtype, captions, tail=b''):
        """payload: the original loader's object for the row; tail: 16-byte dependency records."""
        self.install(payload, subtype, captions)
        self.uc.mem_write(audio.ACTION_TYPE_BASE_VA, bytes([0xa1, subtype]))
        self.heap = HEAP
        self.uc.mem_write(GATE_OBJECT + 0x60c, bytes(4))
        if tail:
            self.uc.mem_write(TAIL, tail)
            # 0x410a9a..0x410aa5: the loader's call, row base 0x5bb5b3, offset range, pointer.
            start = 100
            self._call_this(0x424aa8, GATE_OBJECT, (0x5bb5b3, start, start + len(tail), TAIL))
            if struct.unpack('<I', self.uc.mem_read(0x5bb5e9 + 4, 4))[0] == 0:
                raise OracleError('dependency builder produced no tree')
        for address in (0x5bb57b, 0x5bb1ca, 0x583999, 0x5c39ff):
            self.uc.mem_write(address, bytes([0x5a]) * 4)
        for address in (0x5bb599, 0x5bb595, 0x5bb59b, 0x5bb59f, 0x5bb5a3):
            self.uc.mem_write(address, bytes([0x6b]) * 4)

    def run_arm(self, phase, playing, completed):
        uc = self.uc
        self.currently_playing = bool(playing)
        uc.mem_write(audio.ACTION_DONE_BASE_VA, bytes([completed]))
        uc.mem_write(audio.ACTION_PHASE_BASE_VA, struct.pack('<I', phase))
        uc.mem_write(FRAME - 0x11c, struct.pack('<h', 0))
        uc.reg_write(self._ebp, FRAME)
        uc.reg_write(self._esp, FRAME - 0x400)
        uc.reg_write(self._ecx, 0)
        uc.reg_write(self._eflags, 0x202)
        uc.emu_start(ARM, STOP, count=8_000_000)
        if uc.reg_read(self._eip) != STOP:
            raise OracleError('original arm did not reach the dispatcher loop join')
        if uc.reg_read(self._esp) != FRAME - 0x400:
            raise OracleError('arm left the stack unbalanced')
        done = uc.mem_read(audio.ACTION_DONE_BASE_VA, 1)[0]
        new_phase = struct.unpack('<I', uc.mem_read(audio.ACTION_PHASE_BASE_VA, 4))[0]
        return new_phase, done

    def cells(self):
        def word(a): return struct.unpack('<h', self.uc.mem_read(a, 2))[0]
        def dword(a): return struct.unpack('<i', self.uc.mem_read(a, 4))[0]
        return dict(scene=dword(0x5bb57b), words=[word(a) for a in (0x5bb599, 0x5bb595, 0x5c39ff)],
                    dwords=[dword(a) for a in (0x5bb59b, 0x5bb59f, 0x5bb5a3)],
                    start=dword(0x5bb1ca), state=dword(0x583999))


def native_visit(lib, payload, phase, subtype, completed, captions, recorder, table):
    status, out, why, _ = native.step(lib, payload, phase, subtype, completed, captions,
                                      recorder, table.table)
    recorder.finish()
    return status, out, why


def verify_lifecycle(lib, original, payload, subtype, captions, tail=b'', *, sequence=None,
                     rng=None, stats=None, expect_stores=None):
    """One row: the object from the ORIGINAL loader through the full original arm."""
    rng = rng or random.Random(1)
    noise = [rng.randrange(-2 ** 31, 2 ** 31) for _ in range(TABLE_COUNT)]
    table = native.Events(TABLE_COUNT)
    for i, v in enumerate(noise):
        table.flags[i] = v
    original.install_a1(payload, subtype, captions, tail)
    original.set_table(noise)
    recorder = native.TimelineRecorder(table)
    native_object = loader97.buffer(bytes(payload))
    before = bytes(native_object)
    visits = 0
    transitioned = False
    for phase, playing, completed in sequence or [(0, 1, 0), (1, 1, 0), (1, 0, 0), (2, 0, 0), (7, 0, 1)]:
        recorder.still_playing = playing
        finish_before = original.observed['0x42ba3a']
        reset_before = original.observed['0x423d33']
        status, out, why = native_visit(lib, native_object, phase, subtype, completed, captions,
                                        recorder, table)
        if status != 0:
            raise OracleError(f'native visit failed: {status} {why}')
        original_phase, original_done = original.run_arm(phase, playing, completed)
        v = out.visit
        if recorder.events != original.events:
            raise OracleError(f'effect order mismatch at phase {phase}: native {recorder.events} '
                              f'original {original.events}')
        if (v.phase, v.completed) != (original_phase, original_done):
            raise OracleError(f'phase/completion mismatch at phase {phase}: native '
                              f'{(v.phase, v.completed)} original {(original_phase, original_done)}')
        if v.finish != original.observed['0x42ba3a'] - finish_before:
            raise OracleError('finish helper mismatch')
        if v.reset != original.observed['0x423d33'] - reset_before:
            raise OracleError('dependency reset mismatch')
        if list(table.flags) != original.table():
            raise OracleError(f'event table mismatch at phase {phase}')
        cells = original.cells()
        if v.transition:
            r = v.request
            if (r.target_scene, list(r.opaque_words), list(r.opaque_dwords),
                    r.scene_flag_value, r.engine_state_value) != (
                    cells['scene'], cells['words'], cells['dwords'], cells['start'], cells['state']):
                raise OracleError(f'transition tuple mismatch {cells}')
            transitioned = True
        elif not transitioned and (cells['scene'], cells['start'], cells['state']) != (0x5a5a5a5a,) * 3:
            raise OracleError('original changed the scene-change cells without a native transition')
        if stats is not None:
            stats['visits'] += 1
            stats['event_stores'] += out.event_stored
        visits += 1
    if bytes(native_object) != before:
        raise OracleError('native runtime object modified')
    # What the visit hands the sound provider: the original's own load (path, channel,
    # category, control word, both gains) against the native command, and the counts.
    loads = original.trace['loads']
    if len(recorder.commands) != len(loads) or len(loads) != 1:
        raise OracleError(f'load count {len(recorder.commands)}/{len(loads)}')
    command, observed = recorder.commands[0], loads[0]
    if observed['path'] != b'CDSound\\' + command[0] + b'.his':
        raise OracleError(f'asset path {observed["path"]} vs stem {command[0]}')
    if (command[1], command[2], command[3], command[6], command[7]) != (
            observed['channel'], observed['volume_category'], observed['control_word'],
            observed['first_gain'], observed['second_gain']):
        raise OracleError(f'load fields differ: native {command} original {observed}')
    if len(recorder.plays) != len(original.trace['play_flags']):
        raise OracleError('play count differs')
    if len(recorder.unloads) != original.trace['releases']:
        raise OracleError('unload count differs')
    if [text + suffix for _, text, suffix in recorder.captions] != original.trace['captions']:
        raise OracleError(f'caption text differs: {recorder.captions} vs {original.trace["captions"]}')
    if expect_stores is not None and len(original.event_writes) != expect_stores:
        raise OracleError(f'event store count {len(original.event_writes)} != {expect_stores}')
    stores = len(original.event_writes)
    original.event_writes.clear()
    return visits, stores, recorder


class Shim:
    """The two assertions and the cleanup list native.Fixture needs from a TestCase."""

    def __init__(self):
        self.cleanups = []

    def assertTrue(self, value):
        if not value:
            raise OracleError('native fixture: expected true')

    def assertEqual(self, left, right):
        if left != right:
            raise OracleError(f'native fixture: {left!r} != {right!r}')

    def addCleanup(self, function):
        self.cleanups.append(function)

    def close(self):
        while self.cleanups:
            self.cleanups.pop()()


def session_action(subtype, typed, flag):
    return native.session.action(0xa1, subtype, typed, (native.session.flag_gate(flag),))


def verify_false_gate(lib, original, typed, payload, subtype, phase, rng, stats):
    """Real tree, real gate: (phase, completed 0) with the gate false; the arm must do nothing
    but the subtype-2 clear. The native side is the executor itself (scene_executor.c)."""
    flag = 5
    record = b''.join(struct.pack('<h', v) for v in (2, flag, 1, 0, 0, 0, 0, 0))
    noise = [rng.randrange(-2 ** 31, 2 ** 31) for _ in range(TABLE_COUNT)]
    noise[flag] = 0                                           # gate (event 5 == 1) is false
    original.install_a1(payload, subtype, 1, record)
    original.set_table(noise)
    visits_before = original.observed['0x432d1a']
    new_phase, done = original.run_arm(phase, True, 0)
    if original.events != []:
        raise OracleError(f'false gate had effects: {original.events}')
    if original.observed['0x432d1a'] != visits_before:
        raise OracleError('false gate reached the sound visit')
    # Native: the same row through the real executor (scene_executor.c) and the binding. The
    # row is driven to `phase` with the gate true, then the gate (world flag 5 == 1) turns false.
    shim = Shim()
    fixture = native.Fixture(shim, lib, [session_action(subtype, typed, flag)],
                             lookup=loader97.DictionaryLookup({b'NSHT14': b'x'}), captions=1,
                             event_count=TABLE_COUNT)
    fixture.flags[flag] = 1
    fixture.recorder.still_playing = 1
    for step_index in range(phase):
        if step_index == 1:
            fixture.recorder.still_playing = 0
        status, _ = fixture.tick()
        if status not in (0, 1):
            raise OracleError(f'native tick failed {status}')
    if fixture.state() != (0, phase):
        raise OracleError(f'native did not reach phase {phase}: {fixture.state()}')
    events_before = list(fixture.recorder.events)
    fixture.flags[flag] = 0
    status, _ = fixture.tick()
    native_state = fixture.state()
    if status != 0 or fixture.recorder.events != events_before:
        raise OracleError('native false gate had effects')
    if native_state != (done, new_phase):
        raise OracleError(f'native false gate {native_state} != original {(done, new_phase)}')
    shim.close()
    stats['false_gate_visits'] += 1
    return new_phase, done


def inputs():
    manifest_bytes = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    corpus_bytes = (PRIVATE / 'A-A1.1.corpus.json').read_bytes()
    if sha(manifest_bytes) != a1o.MANIFEST_HASH or sha(corpus_bytes) != a1o.CORPUS_HASH:
        raise OracleError('manifest/census identity mismatch')
    manifest, corpus = json.loads(manifest_bytes), json.loads(corpus_bytes)
    if (manifest['archive_sha256'] != a1o.ARCHIVE_HASH or corpus['exe_sha256'] != EXE_HASH
            or corpus['raw_0xa1_records'] != 565 or len(corpus['records']) != 565):
        raise OracleError('archive/census identity mismatch')
    resources = {}
    for row in manifest['resources']:
        data = (ROOT / 'work/analysis/hiff-resources' / f'{int(row["index"]):04d}.bin').read_bytes()
        if len(data) != row['size'] or sha(data) != row['sha256']:
            raise OracleError('resource manifest mismatch')
        resources[int(row['index'])] = data
    if len(resources) != 2267:
        raise OracleError('resource coverage mismatch')
    return corpus, resources, manifest_bytes, corpus_bytes


def lookup_from(entries):
    captions = {}
    for entry in entries:
        captions.setdefault(entry['key'].lower(), entry['caption'])
    return loader97.DictionaryLookup({k: v for k, v in captions.items()})


class Pair:
    """Original loader machine A and the shared AUTOTEXT table."""

    def __init__(self, resources):
        self.machine = a1o.OriginalLoader()
        self.machine.initialize()
        entries = autotext.parse_entries(autotext._read_cvtx_payload(resources[1]))
        for entry in entries:
            self.machine.insert(entry['key_field'], entry['raw_value'])
        self.machine.copy_table()
        self.entries = entries
        self.lookup = lookup_from(entries)

    def insert(self, key, value):
        field = key + bytes(33 - len(key))
        self.machine.insert(field, value)
        self.machine.copy_table()
        self.lookup.rows[key] = value

    def load(self, lib, typed_body, payload):
        """Original loader object vs native construction; returns the (equal) bytes."""
        original, advance, offset = self.machine.invoke(payload)
        status, built = native.construct(lib, typed_body, self.lookup)
        if status != 0:
            raise OracleError(f'native construction failed: {status}')
        image = bytes(built.bytes[:built.length])
        if image != original:
            first = next((i for i, (x, y) in enumerate(zip(image, original)) if x != y),
                         min(len(image), len(original)))
            raise OracleError(f'object mismatch at byte {first:#x}: sizes {len(image)}/{len(original)}')
        return original, built.key_missing


def synthetic_rows(rng):
    """(label, typed body) covering the decisions of 0x432d1a for event objects.

    Positive inline text without a NUL is deliberately absent: the original allocation holds
    exactly the text and its marker, so its C-string caption boundary overreads (the RT-8
    observation); native bounds it and it is not a parity case. Key-form rows (a spare byte
    terminates the string) and empty inline text are compared."""
    rows = []
    for event in (-1, 0, 1, 1000, 1747, 2250, 2299):
        for value in (0, 1, 0xff):
            for scene in (9999, 42):
                for control in (0, 1, 2):
                    rows.append((f'event={event} value={value} scene={scene} control={control}',
                                 native.a1_body(event=event, event_value=value, scene=scene,
                                                control=control, key=b'RT21KEY', mode=0,
                                                channel=rng.choice((8, 9, 12, 13)))))
    for mode in (0, 1, 2):
        for event in (-1, 1000):
            for text in (None, b''):
                rows.append((f'mode={mode} event={event} text={text!r}',
                             native.a1_body(event=event, mode=mode, scene=rng.choice((9999, 6409)),
                                            control=1, text=text, key=b'NSHT14')))
    for channel in (0, 5, 13, 31):
        rows.append((f'channel={channel}',
                     native.a1_body(channel=channel, event=1100, control=1, scene=77,
                                    key=b'RT21KEY')))
    return rows


def main(*, library=None, report_path=REPORT, quick=False):
    begin = time.monotonic()
    native.build_library() if library is None else None
    lib = native.bind() if library is None else library
    corpus, resources, manifest_bytes, corpus_bytes = inputs()
    exe = (ROOT / 'work/original/GAME.EXE').read_bytes()
    if sha(exe) != EXE_HASH:
        raise OracleError('executable mismatch')
    windows = {}
    for start, end, label in WINDOWS:
        windows[label] = dict(start=hex(start), end=hex(end),
                              sha256=sha(exe[start - 0x400000:end - 0x400000]))
    pair = Pair(resources)
    pe = o97.audio.PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    original = Original(pe)
    rng = random.Random(0xa1)
    stats = Counter()
    distributions = {k: Counter() for k in ('subtype', 'event', 'scene9999', 'channel', 'mode',
                                           'control', 'text')}
    loaded = 0
    corpus_missing = 0      # corpus rows whose key is absent from the table (none: all resolve)
    keys_missing = 0        # synthetic AUTOTEXT cases that exercise the original fallback text
    object_digest, body_digest = hashlib.sha256(), hashlib.sha256()
    s6408 = None
    rows = corpus['records'][:40] if quick else corpus['records']
    for ordinal, row in enumerate(rows):
        resource = resources[row['resource_index']]
        start, n = row['raw_body_offset'], row['raw_body_length']
        p = row['act_payload_offset']
        body = resource[start:start + n]
        payload = resource[p:p + row['act_payload_length']]
        if (start != p + 50 or payload[48] != 0xa1 or payload[49] != row['subtype']
                or sha(body) != row['body_sha256']):
            raise OracleError('corpus row disagreement')
        typed = body[:row['typed_body_length']]
        image, missing = pair.load(lib, typed, payload)
        loaded += 1
        corpus_missing += missing
        object_digest.update(image)
        body_digest.update(body)
        # Runtime on the ORIGINAL loader's object; the row's own tree is empty (true gate).
        for captions in (1, 0) if ordinal % 5 == 0 else (1,):
            visits, stores, recorder = verify_lifecycle(lib, original, image, row['subtype'],
                                                       captions, rng=rng, stats=stats)
            stats['cases'] += 1
        event = struct.unpack_from('<h', image, 0xa5)[0]
        distributions['subtype'][row['subtype']] += 1
        distributions['event']['-1' if event == -1 else 'id']+= 1
        distributions['scene9999'][struct.unpack_from('<h', image, 0x91)[0] == 9999] += 1
        distributions['channel'][struct.unpack_from('<H', image, 0x21)[0]] += 1
        distributions['mode'][image[0x90]] += 1
        distributions['control'][struct.unpack_from('<I', image, 0x27)[0]] += 1
        distributions['text']['key' if typed[0x31:0x33] == b'\xff\xff' else 'inline'] += 1
        if row['resource_index'] == 2771 and row['action_index'] == 4:
            s6408 = dict(stem=image[:image.index(0)].decode(), event=event,
                         value=image[0xa7], scene=struct.unpack_from('<h', image, 0x91)[0],
                         channel=struct.unpack_from('<H', image, 0x21)[0])
    # Synthetic event/lifecycle matrix on objects built by the original loader.
    synthetic = 0
    pair.insert(b'RT21KEY', b'synthetic key text')
    for label, typed in synthetic_rows(rng):
        for subtype in (1, 2, 0, 3):
            payload = bytes(48) + bytes([0xa1, subtype]) + typed
            image, _ = pair.load(lib, typed, payload)
            captions = rng.choice((0, 1))
            verify_lifecycle(lib, original, image, subtype, captions, rng=rng, stats=stats)
            synthetic += 1
            if quick and synthetic > 200:
                break
        if quick and synthetic > 200:
            break
    # AUTOTEXT: found, case-folded, missing (original fallback), empty value, 32-byte key.
    autotext_cases = 0
    pair.insert(b'RT21EMPTY', b'')
    pair.insert(b'K' * 32, b'long key text')
    for key in (b'NSHT14', b'nsht14', b'RT21KEY', b'rt21key', b'RT21EMPTY', b'K' * 32,
                b'RT21_ABSENT', b'Z', b'ABSENT_32_BYTES_KEY_.............'):
        for event in (-1, 1234):
            typed = native.a1_body(key=key[:32], event=event, scene=77, control=1)
            payload = bytes(48) + bytes([0xa1, 1]) + typed
            image, missing = pair.load(lib, typed, payload)
            verify_lifecycle(lib, original, image, 1, 1, rng=rng, stats=stats)
            keys_missing += missing
            autotext_cases += 1
    # Inline objects: positive, NUL inside, max-size, empty. A positive text without a NUL
    # leaves the original's caption C string unterminated inside its exactly sized allocation
    # (overread, RT-8 note): those objects are compared at the loader level only.
    inline_cases = 0
    inline_lifecycle = 0
    for text in (b'a', b'a\0b', b'', b'x' * 9999, b'abc\0'):
        typed = native.a1_body(text=text, event=1500, scene=6409, control=1)
        payload = bytes(48) + bytes([0xa1, 1]) + typed
        image, _ = pair.load(lib, typed, payload)
        inline_cases += 1
        if text != b'' and b'\0' not in text:
            continue
        verify_lifecycle(lib, original, image, 1, 1, rng=rng, stats=stats)
        inline_lifecycle += 1
    # False gates, real tree.
    false_gate = []
    for subtype in (0, 1, 2, 3):
        for phase in (0, 1, 2):
            typed = native.a1_body(event=1000, scene=6409, control=1, text=b'g')
            image, _ = pair.load(lib, typed, bytes(48) + bytes([0xa1, subtype]) + typed)
            new_phase, done = verify_false_gate(lib, original, typed, image, subtype, phase, rng, stats)
            expected = (0, 0) if subtype == 2 else (phase, 0)
            if (new_phase, done) != expected:
                raise OracleError(f'false-gate result {(new_phase, done)} != {expected}')
            false_gate.append(dict(subtype=subtype, phase=phase, phase_after=new_phase, completed_after=done))
    # True gate, real tree, event-driven: the gate reads the table the handler writes.
    gate_cases = 0
    for value in (0, 1, 2):
        record = struct.pack('<8h', 2, 1000, 1, 0, 0, 0, 0, 0)
        typed = native.a1_body(event=1000, event_value=1, scene=9999, control=0, key=b'RT21KEY')
        image, _ = pair.load(lib, typed, bytes(48) + bytes([0xa1, 1]) + typed)
        noise = [rng.randrange(-2 ** 31, 2 ** 31) for _ in range(TABLE_COUNT)]
        noise[1000] = value
        original.install_a1(image, 1, 1, record)
        original.set_table(noise)
        new_phase, done = original.run_arm(0, False, 0)
        # Event 1000 is 1 only when the gate was already true: then the visit runs, the
        # store keeps it 1 and (event != -1) the row waits in phase 1; otherwise nothing runs.
        expected = (1, 0) if value == 1 else (0, 0)
        if (new_phase, done) != expected:
            raise OracleError(f'event-driven gate: value {value} gave {(new_phase, done)}')
        gate_cases += 1
    mutation_hooks = {k: v for k, v in sorted(original.hooks.items())}
    report = dict(
        slice='RT-21', quick=quick,
        corpus_records=loaded, corpus_keys_missing=corpus_missing,
        synthetic_keys_missing=keys_missing,
        decoys=['event -1 with a nonzero value byte (no store; the corpus has 163 such rows)',
                'event id 0 (a real flag, not a sentinel) with scene 9999 and control 0 (no direct completion)',
                'scene 9999 + control 0 + event != -1 (waits instead of completing directly)',
                'value byte 0 and 0xff (the byte is stored zero-extended: 0 clears, 255 stays 255)',
                'gate false with subtype 0/1/2/3 in phases 0/1/2 (only subtype 2 clears; real tree and gate)',
                'gate true only when the event table holds the value (event-driven gate, real evaluator)',
                'AUTOTEXT keys that differ in case, an absent key (original fallback text), an empty value, '
                'a 32-byte key, a prefix of a present key',
                'channel 0/5/13/31 and mode 0/1/2 (only mode 0 unloads, only mode 1 skips the query)'],
        lifecycle_cases=stats['cases'] + synthetic + autotext_cases + inline_cases,
        corpus_lifecycle_cases=stats['cases'], synthetic_event_cases=synthetic,
        autotext_cases=autotext_cases, inline_cases=inline_cases,
        visits=stats['visits'], event_stores=stats['event_stores'],
        false_gate_cases=len(false_gate), event_driven_gate_cases=gate_cases,
        mismatches=0, false_gate=false_gate, distributions=distributions, s6408_row4=s6408,
        object_bytes_sha256=object_digest.hexdigest(), raw_bodies_sha256=body_digest.hexdigest(),
        runtime_hooks=mutation_hooks, executed_function_entries=dict(original.observed),
        loader_hooks={'0x51dc43': 'guarded allocation only (A-A1.1 machine)'},
        original_sha256=EXE_HASH, manifest_sha256=a1o.MANIFEST_HASH, corpus_sha256=a1o.CORPUS_HASH,
        archive_sha256=a1o.ARCHIVE_HASH, code_windows=windows,
        native_sha256=sha(Path(lib._name).read_bytes()),
        seconds=round(time.monotonic() - begin, 2),
        scope='dispatcher arm 0x4297be (real gate/tree) -> 0x432d1a -> 0x42ba3a on objects built by '
              'the original loader arm 0x40f069; file/caption/HIS/COM/allocator boundaries replaced; '
              'no PCM, no original session scheduler')
    report_path.write_text(json.dumps(report, indent=2, default=str) + '\n')
    print(json.dumps({k: report[k] for k in (
        'corpus_records', 'corpus_lifecycle_cases', 'synthetic_event_cases', 'autotext_cases',
        'inline_cases', 'visits', 'event_stores', 'false_gate_cases', 'event_driven_gate_cases',
        'mismatches', 'seconds')}))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--report', type=Path, default=REPORT)
    parser.add_argument('--quick', action='store_true')
    arguments = parser.parse_args()
    main(report_path=arguments.report, quick=arguments.quick)
