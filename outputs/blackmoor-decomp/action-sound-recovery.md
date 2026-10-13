# Original type `0x9f` sound-action recovery

This report records the evidence-backed part of the original sound action and
the bounded native C kernel in `outputs/blackmoor-decomp/src/action_sound.[ch]`.
It covers the first-scene family represented by S0 (`0800.bin`, sound stem
`NSHT01`) and the generic selector-defined body shape. It does not claim full
audio-engine or HIS-decoder compatibility.

## Executable and evidence quality

The source executable is `work/original/GAME.EXE`, SHA-256
`afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`. The
function pseudocode under `outputs/blackmoor-decomp/unverified-pseudocode`
comes from Ghidra and remains unverified. Addresses and field relationships
below were cross-checked against the x86 instructions in that executable. The
oracle in `outputs/blackmoor-decomp/tests/action_sound_original_oracle.py`
executes the original `0x410f99` runtime copier and `0x432d1a` phase handler
under Unicorn 2.1.4.

The oracle compares S0's phase lifecycle and the command data that reaches
the original sound loader. Its bounded hooks supply file lookup, a successful
already-decoded HIS buffer, the caption UI edge, and fake DirectSound COM
results. The phase handler, command conversion, gain attenuation, DirectSound
wrapper selection, playback query, unload dispatch, and completion routine
execute original machine code. There is no native Windows VM, UI, or audible
output.

## Body contract

The typed body is the body portion only; dependency records follow it and are
not part of the `0x9f` body. Little-endian fields are:

| Offset | Field | Interpretation |
|---:|---|---|
| `0x00` | 33 bytes | NUL-terminated asset stem |
| `0x21` | `u16` | sound channel |
| `0x23` | `u32` | retained raw control word |
| `0x27` | `i16` | first scalar percent |
| `0x29` | `i16` | second scalar percent |
| `0x2b` | `u8` | playback mode |
| `0x2c` | `i16` | transition scene; `9999` means none |
| `0x2e` | `u16` | literal byte count, or `0xffff` for an auto-text key |
| `0x30` | variable | literal bytes, or 33-byte NUL-terminated auto-text key |

The original `0x40b34a` loader reads the selector at body `+0x2e`. A selector
of `0xffff` consumes exactly `0x51` (81) bytes. Otherwise, values greater than
9999 are rejected and the body length is exactly `48 + selector`; selector 0
therefore consumes 48 bytes and carries no caption. The decoded resource
corpus contains 3,570 type-`0x9f` records: 3,289 selector-0 records of 48 bytes
and 281 selector-`0xffff` records of 81 bytes. There are no nonzero numeric
literal selectors in that corpus, although the loader's selector-length rule
defines that branch and the native parser validates it exactly.

The channel table is initialized for 32 channels by `0x4faa03`; the limit is
not 14. A native channel value outside `[0, 31]` is rejected before callbacks.
The initializer assigns category 3 to every channel, then category 0 to
channels `{12,13,30}`, category 1 to `{0,1,2,26,27,29,19}`, and category 2 to
`{3,4,5,6,7,8,9,10,11,20,24,25,23,22,21,31,18,17}`. This category selects
the global-volume table and is distinct from the body playback mode.

## Runtime command and playback values

`0x410f99` copies body fields into a zero-initialized runtime record. It maps
the raw control word to runtime `+0x27`, the two signed scalar words to
`+0x2b` and `+0x2d`, mode to `+0x90`, transition scene to `+0x91`, and auto-text
event flag id `-1` / value `1` to `+0xa5` / `+0xa7`. The body caption selector
is handled in the resource loader, before the phase handler receives this
runtime record.

At phase 0, `0x432d1a` copies the control word to CSound channel state `+0x134`
and converts each signed scalar independently to `clamp(percent / 100, 0, 1)`.
Both values are retained separately. `0x4fadc4` then uses the channel category
and its runtime global master scalar to compute two independent DirectSound
attenuations:

```
attenuation = __ftol(gain * master * 2857.142822265625f
                    - 2857.142857142857)
```

The original `__ftol` switches x87 rounding to truncate toward zero. Results
are written at CSound channel offsets `+0x140` and `+0x144`; the later volume
setter clamps its input no lower than `-2857`. The exact use of the second
attenuation outside this path is not established, so the API names remain
`first_*` and `second_*` rather than assigning left/right roles. In the S0
oracle fixture, channel 13 has category 0 and its configured master is
`0.85f`; both 75-percent scalar values produce `-1035` after original x87
conversion.

The raw control word must stay raw. `0x4faa03` passes `CSound + 4` to
`0x4f2710`; `0x4f2710` stores that exact pointer at `CDirectSound + 0x3ce`.
Consequently, per-slot `CDirectSound + 0x130` aliases `CSound + 0x134`, and
`CDirectSound + 0x12c` aliases `CSound + 0x130`. `0x4f6059` uses the raw control
word and flag bits to choose DirectSound `Play` flags, then calls the buffer's
vtable method at `+0x30`. The S0 value 1 yields Play flags 0 in the oracle.

The separate `0x4f55d5` channel-update path restarts a completed channel when
the raw control word is zero, unless its random-repeat flag path is selected.
The native kernel does not model that restart or random-delay behavior. It
passes the control word unchanged to the platform callback, so a host adapter
must return explicit `UNSUPPORTED` for control values or flag combinations it
has not implemented. This keeps the phase kernel from inventing loop or repeat
semantics.

## Caption behavior

The original type-`0x9f` auto-text loader calls `0x423259`. If lookup returns
null, `0x41c7f4` copies the embedded bytes
`Missing closed captioning text string<h><n><o>` (46 bytes plus NUL). The
loader then appends the executable's `<e>` terminator. The phase handler calls
the caption UI boundary at `0x448d11` only when the global caption flag is
enabled, its dispatch argument is nonzero, and the resolved runtime caption
length is positive. The current game configuration has captions enabled, so
the C kernel requires a typed `present_caption` callback whenever a caption
should appear; it does not silently drop the request. A resolver result of
`NO_RESOURCE` selects the exact embedded fallback in the C kernel.

## Lifecycle and result contract

The executor retains each action's `phase` and completion byte. The kernel is
stateless across calls; the platform backend retains the asynchronous channel
state and answers whether playback is active. This avoids replacing the
original query with an elapsed-time guess.

| Caller phase | Original behavior represented by the kernel |
|---:|---|
| `0` | Optional caption, load/path command, and play after successful load. Direct completion occurs only for transition `9999`, event id `-1`, and raw control word 0; otherwise phase becomes 1. |
| `1` | Mode 1 advances directly to phase 2. Other modes query the channel; only a stopped result advances to phase 2. |
| `2` | A non-`9999` transition returns a typed request with the target scene, zero loader payload, engine state 4 and the original scene flag value 1. Mode 0 unloads. The phase then returns to 0 and subtype 1 completes, subtype 2 clears completion and requests dependency reset. |

The transition is explicit result data and stops later action rows for that
dispatch. The kernel does not synthesize a completed byte for unrelated
subtypes. On an ineligible subtype-2 pass, it clears phase and completion but
does not reset the dependency tree; the executor owns that dispatcher rule.

## Original-code comparison

The oracle executes S0's phase 0, a still-playing phase-1 poll, a stopped
phase-1 poll, and phase 2. Native and original results both are
`[(1,0),(1,0),(2,0),(0,1)]` as `(phase, completed)`. Original platform-edge
trace: path `CDSound\\NSHT01.his`, channel 13, category 0, raw control 1, two
0.75 gains, two `-1035` attenuation outputs, Play flags 0, caption fallback
plus `<e>`, and one buffer release. The original has three GetStatus calls
(two action polls plus one inside unload); the native backend interface groups
unload into its own callback and therefore exposes only the two action polls.

The machine-readable output is `work/analysis/action-sound-validation.json`.
The oracle uses the approved isolated Unicorn 2.1.4 Python environment and
does not add Unicorn to the native build or runtime dependencies.

## Limits

- The Ghidra pseudocode is unverified; disassembly and the bounded execution
  are the stronger evidence used here.
- The oracle supplies the fallback caption text as prepared runtime data. It
  does not run the whole scene action-resource loader or successful auto-text
  lookup; those resource operations are independently handled by the
  autotext worker.
- `0x4f379c` (HIS load/decode) and DirectSound COM calls are boundary hooks.
  HIS decode, stream conversion, device creation, real playback, and audible
  output are not validated by this work.
- The oracle seeds S0's category-0 global volume to `0.85f`; it does not cover
  other game volume settings.
- Control-word restart/random-repeat behavior, other audio flag combinations,
  streaming, unsupported playback modes, and success-path captions remain
  outside this native kernel's claimed execution subset.
- The corpus establishes numeric selector 0 and auto-text selector `0xffff`;
  nonzero literal captions are accepted by the format rule but do not have
  corpus coverage. Other embedded-string edge cases are not claimed.

The reported DirectSound Play flags 0 are for the oracle's explicitly non-streaming loaded-buffer fixture. They do not establish the actual HIS loader's streaming choice or the logical end/restart behavior of a real stream. The native S0 diagnostic decodes the whole clip and uses one-shot host completion; stream-buffer equivalence remains unverified.
