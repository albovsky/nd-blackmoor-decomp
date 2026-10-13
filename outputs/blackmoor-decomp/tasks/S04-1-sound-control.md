# S04-1: Sound command and attenuation kernel

**Status:** Implemented and independently reviewed; integration pending. This child completes only the raw channel-control, restart/random-repeat, and master attenuation subset. Parent S04 remains open.

**Owner:** sound-control worker, branch `codex/blackmoor-s04-1-sound-control`, based on `02f1e767ffda707bb5baa01e883cbaa66ca50d0b`.

**Owned files:** `src/sound_control.[ch]`, `scripts/build_sound_control.sh`, `tests/test_sound_control.py`, `tests/sound_control_original_oracle.py`, this packet, and the private S04-1 evidence in `work/analysis/slices/`.

## Recovered behavior

The kernel retains raw channel control and flags separately. Original alias setup at `0x4f2710` stores `CSound+4` at `CDirectSound+0x3ce`; therefore slot `+0x12c` is the raw flags word and slot `+0x130` is the raw control word. `0x4f6059` selects Play flag 1 when `(control == 0 && flags & 1) || stream_state != 0 || flags & 0x100`; it clears slot `+0x287` before the DirectSound Play call. Device-not-ready, absent resource/buffer, and failed Play preserve original error values `0x3ea`, `0x3ef`, and `0x403`.

The `0x4f55d5` update calls GetTickCount first, then clears the device-error field to `0x3e8`. It returns at the original dependency gates. Flag `0x20` enters three ordered fade boundaries. Nonzero raw control returns without restart. With control zero, flag `0x10` sets the repeat marker and schedules `(rand() % signed(max-min)) + min` only for a positive signed range; due tick addition wraps as 32-bit unsigned. Otherwise it calls the Play wrapper. Control zero is therefore a conditional completed-channel restart/random-repeat command, not a generic infinite-loop setting.

The master setter uses the four category table initialized at `0x4faa03`, stores unsigned percent divided by 100 and clamps to `[0,1]`, then refreshes only matching channels whose update state equals 1. The two attenuation values are computed and retained independently. The observed DirectSound wrapper sends only the first value to SetVolume; the second value is preserved without assigning left/right roles. The x87 math claim is limited to startup precision 53 and round-to-nearest. Original startup CW is `0x023f`; semantic CW `0x027f` has the same relevant PC/RC fields. The independent A-28 report is `work/analysis/slices/x87-startup-a28-policy-20261013.md` (SHA-256 `aaeb0916b3619c8565e2b3d62e3d8fcc8770f7a1bdd68f2885e94421ee3232a6`).

## Public state-to-source mapping

All per-channel addresses below are `CSound + offset + channel*0x5bb`; slot-relative offsets use the alias established by `0x4f2710` (`slot = CSound + 4 + channel*0x5bb`).

| Public field | Original field/address | Meaning retained |
|---|---|---|
| `channel.volume_category` | `CSound+0x10c` | Four-way master category |
| `channel.volume_update_state` | `CSound+0x132` (`slot+0x12e`) | Refreshed only when exactly 1 |
| `channel.raw_flags` | `CSound+0x130` (`slot+0x12c`) | Original flag word |
| `channel.raw_control` | `CSound+0x134` (`slot+0x130`) | Raw 0x9f control word |
| `channel.first_scalar`, `second_scalar` | `CSound+0x138`, `+0x13c` | Independent scalar inputs |
| `channel.first_attenuation`, `second_attenuation` | `CSound+0x140`, `+0x144` (`slot+0x13c`, `+0x140`) | Independent computed values |
| `channel.resource_ready`, `stream_state` | `slot+0x162`, `slot+0x166` | Play/update gates |
| `channel.update_gate_287`, `update_gate_16e`, `update_gate_172` | `slot+0x287`, `+0x16e`, `+0x172` | Early update gates |
| `channel.buffer_available` | `slot+0x28f` | Loaded DirectSound buffer pointer present |
| repeat marker/min/max/delay/due | `slot+0x19e`, `+0x1aa`, `+0x1ae`, `+0x1a2`, `+0x1a6` | Original random-repeat state |
| `state.master[category]` | `CSound+0xb764+category*4` | Float master scalar |
| `state.device_ready` | `CDirectSound+0x1a0` | Device readiness gate |
| `state.device_state`, `device_error`, `host_result` | `CDirectSound+0x3be`, `+0x3c2`, `+0x3ca` | Original state/error/HRESULT fields |

The `SoundControlResult`, master result, and callback table are adapter-facing result data, not extra original memory fields. `SoundControlHost` separates injected tick, RNG, fade, Play, and SetVolume calls from the reconstructed state transitions.

## Scene evidence

The immutable private scene corpus scan parsed 2,078 of 2,267 extracted files, with 189 parser rejections, and found 3,570 type-`0x9f` commands in 900 scenes. Counts by `(raw control, mode)` were `0:0=343`, `0:1=1`, `1:0=3142`, `1:1=84`; categories were `0=343`, `1=45`, `2=3182`; all 3,570 scene commands had equal scalar percentages (13 distinct equal pairs). S0 (`0800.bin`) action 31 is channel 13, category 0, control 1, mode 0, and 75/75 percent. This is why both raw control modes and independent scalars are represented even though no unequal pair appeared in the scanned scene records. Parser source hashes and the private corpus digest are recorded in `work/analysis/slices/S04-1-original-oracle.json`; resource bytes and dumps are not included.

## Validation

- Native: `python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_sound_control.py'` — 10 tests pass.
- Original x86: `work/tools/oracle-python/bin/python outputs/blackmoor-decomp/tests/sound_control_original_oracle.py` — 9 Play, 10 Update, 10 attenuation/CW, and 5 master-volume cases agree with the native kernel (34 comparisons total). The oracle executes original PE code under Unicorn and hooks only the listed host boundaries.
- The test-first baseline was attempted before `sound_control.c` existed: the build failed for the missing implementation and no sound-control unittest cases were discovered yet. The machine-readable note is `work/analysis/slices/S04-1-test-first.json`.
- Independent review: Astra reviewed the source/API, original oracle, hooks, and state/error paths. Initial P2 found an uninitialized temporary result on restart; the implementation now passes the update's initialized result directly to Play. A narrow rereview cleared the fix and found no new issues.
- Native artifact: arm64 Mach-O `build/libsoundcontrol.dylib`, SHA-256 `6015428694aaec0c87e7889435a72b322c8c8fd8a15a4bbfe73e6cb134c2f534`.
- Final source/oracle hashes: `sound_control.c` `4c08268581172a0030e1d1405cecba0795be04ab9540803223df7f54adfd8495`; `sound_control.h` `ae4cac4e7bcfd4c0c9c327c786b51eaa52a150b5b18aaa028e9ff4d632ddecb4`; unit tests `effa1e28eb2122c9fe45fe2588ac6970709461204c75f862ff2688ca1b2e088e`; original oracle script `81f86d1a5ea3f27bd97f35f58d8b53764ef3cfe87064e500c253dd9af6ddd842`; machine report JSON `906a5f4b1955df8a3874085c699982fd6b9cdc5788b0a42592eb3745ee78e962`.
- Pinned source: `work/original/GAME.EXE`, SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.
- Oracle source-window hashes and lengths are in the JSON report; all windows are selected from immutable `GAME.EXE`.

## Hook list and limits

The oracle injects GetTickCount at IAT `0x52a23c`, the original CRT `rand` return at `0x50cd50`, HIS loader/resource success at `0x4f379c`, DirectSound vtable Play `+0x30`, SetVolume `+0x3c`, and fade routine entries `0x4f9f92`, `0x4f8f94`, `0x4f9040`. It does not emulate DirectSound or produce output.

Not established here: mode-1 action lifecycle (85 corpus commands: 84 control-1, 1 control-0) and real stream completion/unload; bodies of fade calls `0x4f9f92`, `0x4f8f94`, `0x4f9040` (only their order under flag `0x20` is checked); pan and the second attenuation's consumer role (the scanned corpus has 0 unequal scalar pairs); HIS decoding and PCM conversion parity; other x87 precision/rounding modes (only PC=53/RN is supported); raw flag branches or combinations outside tested bits `0x1`, `0x10`, `0x20`, `0x100` and the stream-state gate. Device creation, audible playback, and real stream status are not exercised. See open children S04-2 through S04-5. These remain separate from this kernel's passing bounded cases.

## Integration proposal

Keep the parser, dispatcher, `action_sound`, and platform audio files under the integrator's ownership. After a type-`0x9f` command is accepted and its asset is loaded, map its channel, raw `control_word`, and independent `first_gain`/`second_gain` into a `SoundControlChannel`; source raw flags and gate fields from the runtime channel state because the type-`0x9f` body does not contain them. Supply the current category master from runtime settings. Let the platform adapter implement the typed Play and first-attenuation callbacks, and inject tick/RNG using the existing runtime sources. Use `sound_control_update` only at the recovered completion/update boundary; preserve the action's independent mode field in the existing scene-action lifecycle. Route category master changes through `sound_control_set_master_absolute`. Do not normalize mode into raw control or name the scalar pair left/right. The integrator should add this module to shared build registration only after review and should connect real stream-status policy only when S04-2 supplies that evidence.

## Original source windows

The machine-readable report has seven SHA-256-addressed windows: category initialization `0x4faa03`, update `0x4f55d5`, Play `0x4f6059`, attenuation `0x4fadc4`, master setter `0x4fccf2`, master channel refresh `0x4fcb5c`, and SetVolume wrapper `0x4f684a`. Exact exclusive end VAs, byte lengths, and hashes are in `work/analysis/slices/S04-1-original-oracle.json`.
