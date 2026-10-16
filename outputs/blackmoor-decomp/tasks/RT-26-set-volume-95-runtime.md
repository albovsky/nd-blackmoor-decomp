# RT-26: raw 0x95 Set Volume runtime

Owner thread: Claude Sonnet (cloud). Follows RT-23/24/25. Raw 0x95 is the highest-ranked action type without a live handler in `scene-action-coverage.json` after those three: 64 scenes, 123 records, 55 scenes where it is the only missing type.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader, case 0x95 of `0x40b34a`: `0x51dc43(3)`, copies a 16-bit word and one byte from the row body, source advances by 3.
* Dispatcher arm `0x429e41` of `0x427a50`, after `0x423f57(deps, 0)`: `scalar = (float)((double)byte / 100.0)` (x87 `fild`, `fdiv qword [0x52c680]`, `fstp dword`), then `0x4fca60(ECX = CSound 0x5c3a67, int16 channel, scalar, scalar)`, then `0x42ba3a(row)`.
* `0x4fca60`: stores both scalars at CSound `+0x138/+0x13c + channel*0x5bb`, computes the first and second attenuation `ftol(scalar * master[category] * 2857.142822265625 - 2857.142857142857)` (category word at `+0x10c`, master table at `+0xb764`, `_ftol` 0x50ce04) into `+0x140/+0x144`, and calls `0x4f684a(channel)` on CDirectSound `0x5cf1eb`.
* `0x4f684a`: device-not-ready 0x3ea / missing buffer 0x3ef, clamps both attenuations to [-2857, 0], DirectSound `SetVolume` (vtable +0x3c) with the first attenuation, HRESULT failure 0x408.
* `0x42ba3a`: subtype 1 completes the row, subtype 2 clears it and resets the dependencies (`0x423d33`), every subtype clears the phase word.
* Corpus (decoded scene resources): 64 scenes, 123 rows, all subtype 1, channels 0, 4, 5, 6, 7, 11, 12, volume bytes 0 to 100 (14 distinct values), three rows carry a dependency tail.

## Native implementation

`src/action_family_95.[ch]` (decoder, visit, host contract), `src/session_bindings_a95.[ch]` (executor handler: always COMPLETED with phase 0, which the executor maps through `action_core_finish_action`), `sound_control_set_scalars` in `src/sound_control.[ch]` (0x4fca60 + 0x4f684a on the recovered `SoundControlState`), `live_audio_set_channel_scalars` in `src/live_audio.[ch]` (adapter), registration in `src/blackmoor_app.mm` (`bindings[19]`, count 20).

## Verification

* `tests/action_family_95_runtime_test.c`: 12 unit cases (ASan/UBSan clean), 13 source mutants all caught (`tests/test_action_family_95.py`).
* `tests/action_family_95_runtime_original_oracle.py` (+ `_oracle_driver.c`): the real dispatcher 0x427a50 runs 0x95 rows under Unicorn against the native binding and kernel; 101 scenarios, 1,727 row visits, 169,216 channel-field comparisons, 1,643 SetVolume calls compared, 0 mismatches; 8 of 8 native mutants caught.
* `tests/action_family_95_runtime_corpus.c`: all 123 corpus rows decode and run through the binding.

## Limits

* The macOS glue (`blackmoor_app.mm`, `live_audio_set_channel_scalars`) is not compiled or run in the cloud.
* Loudness in the app follows the live-audio adapter's product-gain model, not the original DirectSound dB curve (the original hands only the first attenuation to SetVolume).
* The oracle drives `session_a95_handler` and maps its disposition with a copy of the executor's switch (`a95o_visit`), not the real `scene_executor.c`; the mapping was read against `apply_external_handler` by hand.
* `live_audio_set_channel_scalars` has no fixture case (the live-audio fixture needs macOS); it is Mac-untested, as is the glue. A host gain failure is logged and does not fail the row, matching the original's record-and-continue.
* A channel outside 0..31 is refused natively; the original indexes the slot array unchecked (channel 32 aliases the master table). No corpus row has one.
