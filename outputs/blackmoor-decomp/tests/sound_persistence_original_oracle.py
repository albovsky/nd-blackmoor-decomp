#!/usr/bin/env python3
"""RT-11 bounded x86 evidence for state selection and fresh-entry channel reset.

Executes the unmodified 0x438173..0x438194 selector and full 0x4fb018,
0x4fc05d, 0x4fc808, 0x4f356e, 0x4f6334, 0x4f61e7. Only mixer COM
GetStatus/Stop/Release are replaced, via the RT-1 original-audio harness.
The selector stops before the loader; no scene-load hook or original session
is claimed. Continuation teardown evidence is separately static REA/objdump.
"""
import argparse
from collections import Counter
import ctypes as c
import json
import random
from pathlib import Path
import struct

import action_sound_original_oracle as audio
from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, sha256
import session_exit_support as native
from test_sound_persistence import Plan, configure

ROOT = Path(__file__).resolve().parents[3]
REPORT = ROOT / 'work/analysis/slices/RT-11.oracle.json'
BUFFER_BASE = audio.DATA_BASE + 0x10000
WINDOWS = [(0x438173, 0x438194), (0x4381b0, 0x4381df), (0x4fb018, 0x4fb071),
           (0x4fc05d, 0x4fc077), (0x4fc808, 0x4fc878), (0x4f356e, 0x4f379c),
           (0x4f61e7, 0x4f646c), (0x43dbe3, 0x43e44f), (0x439822, 0x43a7ca),
           (0x4363b7, 0x436425), (0x4730a6, 0x47314d), (0x4e1d34, 0x4e1dbc),
           (0x432d1a, 0x4336ad), (0x42ba3a, 0x42bf30), (0x4f5520, 0x4f5730)]


class Original(audio.OriginalSoundOracle):
    def __init__(self, pe):
        self.hooks, self.entries = Counter(), Counter()
        self.unloads = []
        self.active = [False] * 32
        super().__init__(pe)

    def _hook_code(self, machine, address, size, user):
        if address in (0x4fb018, 0x4fc05d, 0x4fc808, 0x4f356e, 0x4f6334, 0x4f61e7):
            self.entries[hex(address)] += 1
        if address == 0x4fc808:
            self.unloads.append(audio.read_u32(machine, machine.reg_read(self._esp) + 4) & 65535)
        labels = {audio.GET_STATUS_STUB: 'COM:GetStatus', audio.STOP_STUB: 'COM:Stop',
                  audio.RELEASE_STUB: 'COM:Release'}
        if address in labels:
            self.hooks[labels[address]] += 1
            ptr = audio.read_u32(machine, machine.reg_read(self._esp) + 4)
            ch = (ptr - BUFFER_BASE) // 0x100
            assert 0 <= ch < 32
            self.currently_playing = self.active[ch]
            if address != audio.GET_STATUS_STUB:
                self.active[ch] = False
        super()._hook_code(machine, address, size, user)

    def install(self, rng, variant):
        self.uc.mem_write(audio.CSOUND_VA + 4, bytes(32 * audio.SOUND_CHANNEL_STRIDE))
        self.uc.mem_write(audio.CDIRECTSOUND_VA + 0x1a0, struct.pack('<I', 1))
        self.uc.mem_write(audio.CDIRECTSOUND_VA + 0x3ce, struct.pack('<I', audio.CSOUND_VA + 4))
        self.uc.mem_write(audio.DEBUG_VA, bytes(2))
        for ch in range(32):
            base = audio.CSOUND_VA + 4 + ch * audio.SOUND_CHANNEL_STRIDE
            self.uc.mem_write(BUFFER_BASE + ch * 0x100, struct.pack('<I', audio.VTABLE_VA))
            # Loaded/not loaded, ordinary/streaming, playing/ended and flag
            # variation. Decoder/stream objects are absent, as documented.
            loaded = (variant == 0 or rng.randrange(2))
            self.active[ch] = bool(variant == 0 or rng.randrange(2))
            for off, val in [(0x162, int(loaded)), (0x28f, BUFFER_BASE + ch * 0x100 if loaded else 0),
                             (0x19e, int(variant == 2)), (0x16e, int(variant == 2 and not self.active[ch])),
                             (0x10c - 4, rng.randrange(4)), (0x12c, rng.randrange(65536))]:
                self.uc.mem_write(base + off, struct.pack('<I', val))
            self.uc.mem_write(audio.CSOUND_VA + 0x132 + ch * audio.SOUND_CHANNEL_STRIDE,
                              struct.pack('<H', rng.randrange(3)))
        self.unloads = []

    def selector(self, flag):
        esp = audio.STACK_BASE + audio.STACK_SIZE - 0x100
        self.uc.reg_write(self._esp, esp)
        self.uc.reg_write(self._ebp, esp + 4)
        self.uc.mem_write(0x5c39ff, struct.pack('<h', flag))
        self.uc.emu_start(0x438173, 0x438194, count=100)
        assert self.uc.reg_read(self._eip) == 0x438194
        return audio.read_u32(self.uc, 0x583999)

    def reset(self, special):
        self.uc.mem_write(0x5b451f, struct.pack('<H', special))
        esp = audio.STACK_BASE + audio.STACK_SIZE - 0x100
        self.uc.mem_write(esp, struct.pack('<I', audio.RETURN_SENTINEL))
        self.uc.reg_write(self._esp, esp)
        self.uc.reg_write(self._ecx, audio.CSOUND_VA)
        self.uc.emu_start(0x4fb018, audio.RETURN_SENTINEL, count=100000)
        assert self.uc.reg_read(self._eip) == audio.RETURN_SENTINEL

    def slots(self):
        return [bytes(self.uc.mem_read(audio.CSOUND_VA + 4 + ch * audio.SOUND_CHANNEL_STRIDE,
                                       audio.SOUND_CHANNEL_STRIDE)) for ch in range(32)]


def run(library, report):
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    assert sha256(pe.data) == EXPECTED_EXE_SHA256
    lib = native.load_library(library)
    configure(lib)
    original, rng, cases = Original(pe), random.Random(11), 0
    for flag in (0, 1, 2, -1, -32768, 32767):
        for special in range(32):
            for variant in range(3):
                original.install(rng, variant)
                before = original.slots()
                state = original.selector(flag)
                x = native.new_exit(lib, state=1)
                x.g.scene_request_flag = flag
                assert lib.session_exit_begin_load(c.byref(x)) == 0
                assert x.g.game_state == state
                plan = Plan()
                assert lib.session_exit_plan_audio(c.byref(x), special, c.byref(plan)) == 0
                if state == 2:
                    original.reset(special)
                assert list(plan.channels)[:plan.count] == original.unloads, (
                    flag, special, list(plan.channels)[:plan.count], original.unloads)
                after = original.slots()
                for ch in range(32):
                    if ch in original.unloads:
                        assert audio.read_u32(original.uc, audio.CSOUND_VA + 4 +
                                              ch * audio.SOUND_CHANNEL_STRIDE + 0x28f) == 0
                    else:
                        assert before[ch] == after[ch], (flag, special, variant, ch)
                cases += 1
    windows = []
    for start, end in WINDOWS:
        offset = pe.va_to_file_offset(start, end - start)
        windows.append({'start': hex(start), 'end_exclusive': hex(end),
                        'sha256': sha256(pe.data[offset:offset + end - start])})
    result = {'cases': cases, 'mismatches': 0, 'original_sha256': sha256(pe.data),
              'native_library_sha256': sha256(library.read_bytes()), 'code_windows': windows,
              'executed_entries': dict(original.entries), 'replacement_hooks': dict(original.hooks),
              'scope': 'Original selector window and full fresh-reset routines; continuation clear is static evidence',
              'unverified': ['Whole original session/teardown execution', 'Vorbis objects and buffer worker teardown',
                             'OS/mixer failures', 'PCM/loop/timing/attenuation parity',
                             'Scene-header start and dialogue-object bindings']}
    report.parent.mkdir(parents=True, exist_ok=True)
    report.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({k: result[k] for k in ('cases', 'mismatches', 'replacement_hooks')}))
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--library', type=Path, default=native.DEFAULT_LIBRARY)
    parser.add_argument('--report', type=Path, default=REPORT)
    args = parser.parse_args()
    run(args.library, args.report)
