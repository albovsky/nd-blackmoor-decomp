# Boot, scene containers and native graphics recovery

The full game goal remains active. These are recovered engine components and a
verified macOS host adapter. A complete game executable, action runtime,
audio/video integration, save/load and gameplay validation are still missing.
The original x86 byte-matching ledger remains two selected ranges, 14 bytes.

## Original-code provenance

| Original address | Recovered role |
| --- | --- |
| `0x433c60` | CHiff constructor and CIF extraction |
| `0x433eaa` | Bytewise DATA indexing; scan resumes at marker plus 16 |
| `0x434025` | Flat chunk indexing, even padding and nested DATA handling |
| `0x43423d` | Select DATA by case-sensitive short-NUL four-byte name |
| `0x4343a2` | Select chunk without changing independent DATA selection |
| `0x4344bf`, `0x434630` | First/next selection with persistent used flags |
| `0x435015` | Boot chunk selection and copies into original engine globals |
| `0x4181c6` | Image loading, actual metadata and external-CIF precedence |
| `0x4c7314` | Original in-place RGB555 surface-format conversion |
| `0x42406d` | Dependency branch reduction and OR-group propagation |

REA evidence for the main CHiff methods:
`ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd`.
Constructor/DATA index evidence:
`ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b`.
Image-loader evidence:
`ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c`.
Pixel-conversion evidence:
`ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e`.
Dependency-reducer evidence:
`ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1`.

## CHiff behavior and proof

DATA records have a four-byte marker, big-endian length and four-byte type.
Ordinary chunk headers contain a four-byte ID and big-endian payload length;
odd payloads receive one padding byte. The original scans DATA markers bytewise,
then builds a flat chunk list across all indexed containers. It retains
independent selected DATA and chunk records, and failed selection preserves the
corresponding previous record.

The native implementation preserves a non-obvious original behavior: after
skipping one nested DATA record, the original falls through without rechecking
the next header. With two adjacent nested containers, that next DATA header can
appear in the ordinary flat chunk list. Independent x86 execution confirmed the
exact native order and offsets for this case. Bounds checks safely reject
malformed/truncated inputs instead of reproducing unchecked original reads.

All 2,267 decoded archive data resources were compared against the original
x86 index routines: 2,083 DATA entries and 21,733 ordered chunks, zero exclusions
or table mismatches. Selection behavior was separately compared on boot,
AUTOTEXT, duplicate/nested fixtures and an 11-resource sample. Chunk ownership
metadata is native traversal information; the original stores chunk pointers,
not an independently observable owner index.

## BOOT and patched resources

The supplied `Game.ini` enables `ExternalCifFileChecking=1`. Its standalone
`boot.CIF` decodes to 69,442 bytes, while embedded `BOOT` has 69,410 bytes.
`Logo.CIF` is also an external override. The native resource manager prefers
present external CIFs, compares filenames with ASCII case folding, and reports
a malformed present patch as an error instead of falling back silently.

The 402-byte BSUM yields verified fields: logo count at byte 242, object count
at 243, signed little-endian initial scene at 221 and font count at 337. LG/OB
descriptors use 33-byte filenames and nominal dimensions. Actual image metadata
comes from the CIF header. For example, the BOOT object descriptor declares
1000×800 while `UIShared_OVL` is actually 447×660; the MENU descriptor declares
640×727 while its `MAIN` sheet is 640×743. These differences are preserved.

The original visible startup path uses `HER_LOGO_SPLASH`, `LOGO`, and `MAIN`.
The shipped partner-logo configuration selects static graphics and `NO SOUND`;
both logo controllers use unsigned millisecond elapsed time greater than 4000,
or a click, before leaving their display state. Full boot still initializes
audio, and the menu has a separate start-sound path, so a static logo test does
not prove complete boot execution.

All 619 original archive images decode with their actual width/pitch/height and
single-byte depth metadata. The original format conversion matched all 65,536
word values across 11 parameter sets: 720,896 word comparisons, zero mismatches,
with an odd trailing byte preserved in each set. RGB555-to-RGBA8 is a separately
documented host display adapter, not claimed original code.

## macOS host validation

`macos_platform.mm` is native AppKit/CoreGraphics code for framebuffer copying,
logical pointer coordinates, stable physical-key-to-VK mapping, modifiers and a
monotonic 32-bit millisecond clock. A bounded ARM64 test app displayed the
supplied patched company logo upright in a real window. Computer-use interaction
and its native callback log verified pointer down/up and comma, bracket, Shift
and shifted-number press/release identities. The timer completed 3,602 ticks in
the bounded run. This verifies the host bridge, not the game state machine.

The first test process blocked opening an owned test file under Documents;
a sampled live stack established the blocked file-open call. Staging the test
input/log in a temporary directory allowed the test to complete. No privacy
settings or original game files were changed.

## Scene/action boundary

Original state 14 loads `S0`, whose TSUM title is `Player Challenge Screen`.
It references `diff` media and `ndsig` audio. The difficulty-screen scene change
can target `S5900`, followed by an opening cinematic path involving `S4700` and
`EXT_OpnCin_ANIM`. These scene/action consumers still need implementation.

The two difficulty dependencies are **OR**, not AND. Original `0x42406d`
propagates satisfied states across links whose operator is exactly one. The
native reducer matched mutated conditions and branch results on 738 original
x86 cases, including mixed links, noncanonical states and 512-leaf propagation.
Empty-branch handling is separately attributed to the original loader's
no-dependencies path. Full dependency-tree construction, typed leaf evaluation,
action execution and media playback are not covered by this reducer proof.

## Apple Game Porting Toolkit

The owner authorized GPTK where useful. Apple's toolkit offers an optional
reference-execution path for unmodified Windows games, not source recovery.
Apple's formula includes a Win32-on-64 loader build, but no inspected Apple
document specifically guarantees this PE32 game's DirectDraw/DirectSound path.
The host meets the current toolkit prerequisites. Official downloads currently
require Apple sign-in; no toolkit installation or agreement acceptance occurred.
Native reconstruction remains the delivered-engine objective.

Primary sources: [Apple GPTK](https://developer.apple.com/games/game-porting-toolkit/),
[Apple toolkit repository](https://github.com/apple/game-porting-toolkit),
[Apple evaluation formula](https://github.com/apple/homebrew-apple/blob/main/Formula/game-porting-toolkit.rb).
