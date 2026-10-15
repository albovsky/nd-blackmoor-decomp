#!/usr/bin/env python3
"""RT-8: real raw-97 constructor followed by real 0x432d1a lifecycle.

No game process/device. Constructor hooks are A-97.1's malloc/Windows TLS
boundaries. Runtime hooks are file existence, caption UI, HIS decode and five
DirectSound COM methods (inherited from action_sound_original_oracle).
The phase handler, channel math, playback wrappers, finish and empty-tree
subtype reset execute as original x86. Dependencies are supplied true here;
the native session/executor tests cover false gates and populated resets.
"""
from collections import Counter
import argparse
import ctypes as c
import hashlib
import json
from pathlib import Path
import struct
import time

import action_family_97_original_oracle as ctor
import action_sound_original_oracle as audio
import test_action_family_97_runtime as native
import test_action_family_97 as loader
import test_action_sound as sound

ROOT = Path(__file__).resolve().parents[3]
REPORT = ROOT / 'work/analysis/slices/RT-8.oracle.json'
CATEGORIES = [1,1,1,2,2,2,2,2,2,2,2,2,0,0,3,3,3,2,2,1,2,2,2,2,2,2,1,1,3,1,0,2]


class Original(audio.OriginalSoundOracle):
    def __init__(self, pe):
        self.hooks, self.observed = Counter(), Counter()
        super().__init__(pe)

    def _hook_code(self, machine, address, size, user):
        # Intercepts, explicitly separated from original-code observations.
        labels = {audio.FILE_EXISTS_VA: 'file-exists', audio.CAPTION_UI_VA: 'caption-ui',
                  audio.HIS_LOAD_VA: 'HIS-decode', audio.GET_STATUS_STUB: 'COM:GetStatus',
                  audio.PLAY_STUB: 'COM:Play', audio.RELEASE_STUB: 'COM:Release',
                  audio.STOP_STUB: 'COM:Stop', audio.POSITION_STUB: 'COM:SetPosition'}
        if address in labels:
            self.hooks[f'{address:#x}:{labels[address]}'] += 1
        if address in (0x432d1a, 0x42ba3a, 0x423d33, 0x4faf98, 0x4f6334, 0x4fba69):
            self.observed[f'{address:#x}'] += 1
        # Project original execution onto the native host boundaries. Queries
        # internal to load/play are part of that provider, not lifecycle queries:
        # the latter is the 0x433564 call, with return address 0x433569.
        if address == audio.CAPTION_UI_VA:
            esp = machine.reg_read(self._esp)
            text = audio.read_c_string(machine, audio.read_u32(machine, esp + 8))
            self.events.append(('caption', text))
        elif address == audio.HIS_LOAD_VA:
            channel = audio.read_u32(machine, machine.reg_read(self._esp) + 4) & 0xffff
            self.events.append(('load', channel))
        elif address == audio.PLAY_STUB:
            self.events.append(('play', self.channel))
        elif address == 0x4f6334 and audio.read_u32(machine, machine.reg_read(self._esp)) == 0x433569:
            channel = audio.read_u32(machine, machine.reg_read(self._esp) + 4) & 0xffff
            self.events.append(('query', channel))
        elif address == audio.RELEASE_STUB:
            self.events.append(('unload', self.channel))
        super()._hook_code(machine, address, size, user)

    def install(self, payload, subtype, captions):
        self.events = []
        self.channel = struct.unpack_from('<H', payload, 0x21)[0]
        self.trace = {'file_paths': [], 'captions': [], 'loads': [],
                      'play_flags': [], 'queries': [], 'releases': 0, 'stops': 0}
        self.uc.mem_write(audio.CSOUND_VA + 4, bytes(32 * audio.SOUND_CHANNEL_STRIDE))
        self.initialize(sound.sound_body())
        self.uc.mem_write(audio.RUNTIME_VA, payload)
        self.uc.mem_write(audio.CAPTION_ENABLED_VA, bytes([captions]))
        self.uc.mem_write(audio.ACTION_TYPE_BASE_VA, bytes([0x9f, subtype]))
        self.uc.mem_write(audio.ACTION_DATA_BASE_VA + 4, bytes(60))  # empty dependency root
        for ch, category in enumerate(CATEGORIES):
            self.uc.mem_write(audio.CSOUND_VA + 0x10c + ch * audio.SOUND_CHANNEL_STRIDE,
                              struct.pack('<H', category))
        # Fixed category gains are host configuration, not the action's choice.
        self.uc.mem_write(audio.CSOUND_VA + 0xb764, struct.pack('<4f', .85, .85, .85, .85))
        for address in (0x5bb57b, 0x5bb1ca, 0x583999):
            self.uc.mem_write(address, bytes(4))


def verify_case(lib, original_loader, original, lookup, act, seed, subtype=1, captions=1):
    got = original_loader.run(act, seed)
    payload, selected = native.construct(lib, act[50:], seed, lookup)
    assert bytes(payload) == got['payload'], 'constructor payload mismatch'
    assert selected.random_state_after == got['seed'], 'RNG state mismatch'
    assert selected.selected_index == got['selected'], 'selection mismatch'
    assert got['runtime_type'] == 0x9f, 'normalised type mismatch'
    original.install(got['payload'], subtype, captions)
    recorder = native.Recorder()
    steps = 0
    for phase, playing, completed in [(0, 1, 0), (1, 1, 0), (1, 0, 0), (2, 0, 0), (7, 0, 1)]:
        original.uc.mem_write(audio.ACTION_DONE_BASE_VA, bytes([completed]))
        original.currently_playing = bool(playing)
        recorder.still_playing = playing
        status, out, why, _ = native.step(lib, payload, phase, subtype, completed, captions, recorder)
        assert status == 0, (status, why)
        finish_before = original.observed['0x42ba3a']
        original_phase, original_done = original.step(phase, bool(playing))
        assert recorder.events == original.events, (
            'effect order mismatch', phase, recorder.events, original.events)
        assert (out.phase, out.completed) == (original_phase, original_done), 'phase/completion mismatch'
        assert out.finish == original.observed['0x42ba3a'] - finish_before, 'finish helper mismatch'
        if out.transition:
            def word(a): return struct.unpack('<h', original.uc.mem_read(a, 2))[0]
            def dword(a): return struct.unpack('<i', original.uc.mem_read(a, 4))[0]
            assert out.request.target_scene == dword(0x5bb57b)
            assert list(out.request.opaque_words) == [word(a) for a in (0x5bb599, 0x5bb595, 0x5c39ff)]
            assert list(out.request.opaque_dwords) == [dword(a) for a in (0x5bb59b, 0x5bb59f, 0x5bb5a3)]
            assert (out.request.scene_flag_value, out.request.engine_state_value) == (dword(0x5bb1ca), dword(0x583999))
        steps += 1
    assert len(recorder.commands) == len(original.trace['loads']) == 1
    command, observed = recorder.commands[0], original.trace['loads'][0]
    assert observed['path'] == b'CDSound\\' + command[0] + b'.his', 'selected asset path mismatch'
    assert (command[1], command[2], command[3], command[6], command[7]) == (
        observed['channel'], observed['volume_category'], observed['control_word'],
        observed['first_gain'], observed['second_gain']), 'channel fields mismatch'
    assert len(recorder.plays) == len(original.trace['play_flags'])
    assert len(recorder.unloads) == original.trace['releases']
    assert [text + suffix for _, text, suffix in recorder.captions] == original.trace['captions'], (
        'caption mismatch', recorder.captions, original.trace['captions'], bytes(payload[0xaa:]))
    return steps, selected


def main(*, library=None, report_path=REPORT):
    begin = time.monotonic()
    if library is None:
        native.build_library()
    corpus, resources = ctor.inputs()  # Pins manifest, archive, every resource.
    original_loader = ctor.Original97(ROOT / 'work/original/GAME.EXE')
    assert ctor.sha(original_loader.pe.data) == ctor.EXE_HASH
    for va, size, digest in ctor.CODE_WINDOWS:
        assert ctor.sha(original_loader.pe.image[va - original_loader.pe.image_base:va - original_loader.pe.image_base + size]) == digest
    entries = ctor.parse_entries(ctor._read_cvtx_payload(resources[1]))
    extras = {b'RT8': b'caption', b'RT8EMPTY': b'', b'RT8NUL': b'a\0ignored'}
    original_loader.install_table(entries, extras)
    lookup = loader.DictionaryLookup({**{e['key_field'].split(b'\0', 1)[0]: e['raw_value'] for e in entries}, **extras})
    original = Original(original_loader.pe)
    lib = library if library is not None else native.bind()
    distributions = {k: Counter() for k in ('subtype', 'count', 'text_kind', 'dependencies', 'control', 'mode', 'channel')}
    s4700, steps, cases = [], 0, 0
    body_hash = hashlib.sha256()
    for ordinal, row in enumerate(corpus['records']):
        start, length = row['act_payload_offset'], row['act_payload_length']
        act = resources[row['resource_index']][start:start + length]
        assert act[48:50] == bytes([0x97, row['subtype']]) and ctor.sha(act[50:]) == row['body_sha256']
        ctor.verify_decode(lib, act[50:], row)
        body_hash.update(act[50:])
        nsteps, selected = verify_case(lib, original_loader, original, lookup, act,
                                       ordinal + 1, row['subtype'], 1)
        steps += nsteps; cases += 1
        distributions['subtype'][row['subtype']] += 1
        distributions['count'][row['count']] += 1
        distributions['dependencies'][row['dependency_tail_records']] += 1
        for selector in row['entry_lengths']:
            distributions['text_kind']['AUTOTEXT' if selector == -1 else 'inline-positive' if selector > 0 else 'inline-empty'] += 1
        channel, control, _, _, mode, _ = row['fixed13_words']
        for key, value in [('channel', channel), ('control', control), ('mode', mode)]:
            distributions[key][value] += 1
        if row['resource_index'] == 2648:
            s4700.append(dict(row=row['action_index'], selected=selected.selected_index,
                              selectors=row['entry_lengths'], dependencies=row['dependency_tail_records'],
                              fields=row['fixed13_words']))
    synthetic = []
    for subtype in (0, 1, 2, 3):
        for control in (0, 1, 2):
            for mode in (0, 1, 2):
                for scene in (9999, 42):
                    for captions in (0, 1):
                        raw = loader.body((b'a', b'*b'), (b'', (b'RT8',)),
                                          words=(13, control, 0, 150, mode, scene))
                        act = bytes(48) + bytes([0x97, subtype]) + raw
                        nsteps, _ = verify_case(lib, original_loader, original, lookup, act, 0x89abcdef, subtype, captions)
                        steps += nsteps
                        synthetic.append((subtype, control, mode, scene, captions))
    # Positive inline captions need a NUL inside their allocation for the
    # original C-string UI boundary. Without one it overreads malloc; native
    # bounds that case and it is explicitly outside the parity claim.
    for value in (b'', b'a\0b', b'abc\0', (b'RT8EMPTY',), (b'RT8NUL',), (b'RT8MISSING',)):
        raw = loader.body((b'*a',), (value,), words=(31, 1, -50 & 65535, 50, 0, 9999))
        act = bytes(48) + b'\x97\x01' + raw
        nsteps, _ = verify_case(lib, original_loader, original, lookup, act, 1)
        steps += nsteps; synthetic.append(('caption-case',))
    windows = {'runtime': (0x432d1a, 0x4336ad), 'finish': (0x42ba3a, 0x42babf),
               'dispatcher_arm': (0x4297be, 0x42983d), 'constructor': (0x410f99, 0x41107f)}
    hashes = {name: dict(start=hex(a), end=hex(b), sha256=ctor.sha(original_loader.pe.image[a-original_loader.pe.image_base:b-original_loader.pe.image_base]))
              for name, (a,b) in windows.items()}
    report = dict(slice='RT-8', corpus_records=cases, synthetic_cases=len(synthetic),
                  visits=steps, mismatches=0, distributions=distributions, s4700=s4700,
                  effect_order_compared_visits=steps,
                  effect_order_scope='Merged caption/load/play/lifecycle-query/unload events per visit; provider-internal queries excluded',
                  runtime_hooks=original.hooks, executed_function_entries=original.observed,
                  constructor_os_hooks=original_loader.os_calls,
                  constructor_allocator_calls=original_loader._allocator_calls,
                  original_sha256=ctor.EXE_HASH, original_code=hashes,
                  native_sha256=ctor.sha(Path(lib._name).read_bytes()),
                  manifest_sha256=ctor.MANIFEST_HASH, raw_bodies_sha256=body_hash.hexdigest(),
                  seconds=round(time.monotonic()-begin, 2),
                  scope='Controlled true-gate handler visits; file/decoder/caption/COM boundaries hooked; no original session or PCM parity')
    report_path.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: report[k] for k in ('corpus_records','synthetic_cases','visits','mismatches','seconds')}))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--report', type=Path, default=REPORT)
    main(report_path=parser.parse_args().report)
