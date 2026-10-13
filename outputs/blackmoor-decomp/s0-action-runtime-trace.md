# S0 action runtime trace (readonly)

This handoff traces original action loading, dependency evaluation, per-frame execution, hotspot arming, and completion for the first Scene 0 runtime slice. It uses only existing unverified Ghidra pseudocode and the checked-in native scene parser over the decoded resource corpus. The pseudocode is evidence for behavior, not original source. No production files were edited and no executable/oracle test was run.

## Runtime lifecycle

`4381f4` initializes the scene runtime and clears the 240 action slots. Each slot has a fixed `0x8d`-byte stride. The raw action type and subtype are bytes at slot offsets `+0/+1`; payload pointer is at `+2`; dependency-tree pointer is at `+6`. The one-byte completion latch is `+0x42` (`DAT_005bb625`), hotspot-active word is `+0x43` (`DAT_005bb626`), the click rectangle is four signed 16-bit coordinates at `+0x47,+0x49,+0x4b,+0x4d`, action phase/status is a 32-bit value at `+0x4f` (`DAT_005bb632`), and `+0x55` (`DAT_005bb638`) is the empty-slot marker. Scene init sets `+0x55=1`; successful `40b34a` loading sets it to `0`. Thus `+0x55==0` means occupied/eligible, not empty. `DAT_005c39e3` is the active high-water slot bound. Normal scenes reject counts above 120; special scene modes allow up to 240.

At each scene tick, `43a7ca` calls `427a50`. The dispatcher walks slots in ascending index order while the engine is in running state (`DAT_00583999==3`). It skips completed slots (`+0x42!=0`) and unloaded slots (`+0x55!=0`), clears hotspot-active scratch, evaluates that action's dependency tree, then executes the type-specific body. An action's dependency check therefore precedes its own side effect; however, an earlier slot's side effect is immediately visible to a later slot in the same dispatcher pass.

`423f57` resets dependency-evaluation context, stores an executor-supplied mode, returns ready immediately for an empty dependency tree, and otherwise runs the built tree. `424346` shows the indexed state reads: opcode 1 reads inventory presence (with the currently selected item considered present), opcode 2 compares event-flag value, opcode 3 compares label/value state, opcodes 4/5 compare elapsed and scene timers, opcode 6 checks the clock, and opcode 9 checks the scene visit counter. The dependency loader (`424aa8`) consumes raw 16-byte records; its reducer uses the fourth signed word as the `or_after` marker. Exposed dependencies from known action bodies contain 15,281 records in the scanned corpus.

For handlers that call `42ba3a`, subtype 1 latches completion (`+0x42=1`), while subtype 2 clears completion and resets the dependency tree via `423d33`, making the action eligible to run again. In both cases `42ba3a` clears the action phase/status at `+0x4f`; it does not remove the action slot. This is the generic repeated/one-shot rule, not a universal rule for every executor: type `0x71` sets the completion latch directly and ignores the helper/subtype behavior in its shown dispatch branch.

## Hotspot interaction is split across the input loop and executor

Hotspot executors expose clickable geometry; they do not themselves set phase 2. For type `0x0d` (including raw `0x15` records rewritten to runtime type `0x0d`), `42ae73` copies the payload rectangle into slot offsets `+0x47..+0x4d`, sets the slot active at `+0x43`, and enables the hotspot path only when the payload frame at `+0x16` equals current frame `DAT_005bb50b`. Type `0x6a` (`42e844`) starts phase 1, then searches its frame records; a frame match sets `+0x43=1` and exports the record rectangle. Its phase-2 branch writes the first ten `(i16 flag_id,i16 value)` pairs and then runs `42ba3a`.

The input side is `43a7ca -> 4d3073 -> 4f0059`. `4d3073` clears the pending event index to `-1`; in normal UI mode it invokes the cursor/input hit-test. `4f0059` examines the active hotspot rectangle with inclusive bounds: pointer Y (`in_ECX+0x5a`) against slot `+0x49..+0x4d`, and pointer X (`in_ECX+0x5e`) against `+0x47..+0x4b`. A hit stores the slot index in `DAT_005c39e5`; it excludes two special pointer slots. On the next tick, `43a7ca` accepts only an index in `[0,240)`, with no modal event active, and gates it through the action/dependency helpers. If eligible, it writes phase 2 at `+0x4f`; the regular dispatcher then invokes the executor. If blocked by dependencies, it routes to the unresolved-dependency UI path. The pseudocode proves the rectangle-to-index-to-phase-2 sequence. It does not expose a separate mouse-button condition in that rectangle loop, so an implementation should preserve the engine's input-event contract rather than assume that the executor owns click detection.

For type `0x6a`, the `0x12`-byte record has frame at record `+0`, rectangle `(left,top,right,bottom)` at `+2,+6,+10,+14` as signed shorts, with the remaining record bytes preserved by the parser. `42e844` compares the frame against the current frame and exports the four rectangle shorts.

## Core atomic action contracts

These are suitable first generic runtime executors. They depend on dependency readiness and slot order, but do not require scene-specific IDs or story progression.

| Runtime type | Body layout and effect | Completion behavior |
| --- | --- | --- |
| `0x4d` set value | 4 bytes: `u8 index, u8 mode, i16 value`. For index `0..29`, accesses 30 signed 16-bit values at `DAT_0058c959`; `30..39` accesses 10 floats at `DAT_0058c91d`. Mode 0 adds unless current value is sentinel 9999; other modes assign. Invalid indices are logged, then completion helper still runs. | Dependency mode 1; calls `42ba3a` (subtype 1 latch / subtype 2 repeat). |
| `0x61` event flags | 8 bytes: two `(i16 id,i16 value)` pairs; skips id `-1`; writes sign-extended value into event flags. | Dependency mode 0; calls `42ba3a`. |
| `0x6b` event flags | 40 bytes: ten `(i16 id,i16 value)` pairs; same write/skip behavior as `0x61`. | Dependency mode 0; calls `42ba3a`. |
| `0x71` difficulty | 6 bytes: `(i16 difficulty,i16 optional_flag_id,i16 flag_value)`. Always writes `DAT_0058c94f`; if optional id is not `-1`, writes that event flag. | Dependency mode 0; directly sets completion to 1. |

Suggested bounded x86-oracle call paths, if a later isolated test harness is approved/available:

- `0x4d`: original `44b26a` with fixed globals/payload, then `42ba3a`; stub only the subtype-2 dependency reset (`423d33`) when the test is focused on completion semantics.
- `0x61/0x6b`: the bounded case block in `427a50` (dependency-ready stubbed true), then original `42ba3a`; restrict slots to one action and omit the rest of the engine frame.
- `0x71`: the bounded case block in `427a50` (dependency-ready stubbed true); this branch writes difficulty/optional flag and completion directly.

No such native/x86 execution was attempted here because prior work reports the available native JVM/Unicorn route is sandbox-sensitive. These are candidates, not validated oracle results.

## Scene 0 (`0800.bin`) contents

The parser opens S0 as 38 action records. Type/subtype counts are: `0x82` 2, `0x1d` 3, `0x6b` 2, `0x4d` 23, `0x61` 1, `0x9f` 1, raw `0x15` 1, `0x71` 2, `0x6a` 2, and `0x0a` 1. All are subtype 1 except the two `0x6a` hotspot actions, which are subtype 2.

The 23 `0x4d` rows assign zero (mode 1) to indices `0..15` and `19..24`, with index 4 repeated. The `0x61` row sets flags 2201 and 2200 to zero. The two `0x6b` rows set `(1490,1),(1672,1),(1514,1)` and `(1549,1),(1510,1)`; remaining IDs are `-1` and skipped. The two `0x6a` subtype-2 rows arm one frame-0 hotspot each and, on interaction, write flag 1000 or 1002 to 1. Their rectangles are respectively `(388,225,492,284)` and `(396,150,489,211)`. The two `0x71` rows set difficulty 0 or 2 and have one dependency each on flag 1000 or 1002 being 1. The final `0x0a` scene change has two OR-linked opcode-2 dependencies on those flags. This is an observed S0 program sequence; a generic runtime should take records and state from the resource, never bake these IDs or transitions into code.

Other S0 actions delimit the implementation boundary: `0x82` is a 41-byte phone-configuration subsystem; `0x1d` is an 8-byte control/UI-range subsystem; `0x9f` is asynchronous sound; raw `0x15` has a 20-byte source body whose first 16-bit word rewrites the runtime type to `0x0d`, a frame-matched hotspot scene-change executor. `0x0a` performs scene transition side effects. These should not be mistaken for simple flag/value setters.

## State-array evidence and limits

- Inventory presence (`DAT_00583bd5`) is indexed as signed 32-bit values with a four-byte stride, confirmed by the original opcode-1 disassembly and leaf oracle. The initial pseudocode-based byte-index claim was incorrect. Inventory init `4e7e15`, called by scene/static initialization `4381f4`, clears indices `0..69` to zero: disassembly at `0x4e7e7b..0x4e7e8e` compares the index with `0x46` and writes a DWORD at `0x583bd5 + index*4`. The corpus's exposed opcode-1 dependencies reach index 28. The 70-entry reset span is not a separate allocation-capacity claim.
- Event flags (`DAT_00585801`) are 32-bit values. The scanned scene corpus references/writes IDs through 2242, so a corpus-compatible model needs at least 2,243 entries. The pseudocode does not provide a safe upper bound or an explicit initialization loop for this array in `4381f4`/`43dbe3`; do not equate the nearest named global with its capacity.
- Label/value state (`DAT_00581a71`) is read by dependency opcode 3 as 32-bit values. No opcode-3 dependencies appear among the parser-exposed corpus records, and no writer/initializer for this address was found in the action/runtime pseudocode reviewed. Capacity and initial values remain unknown.
- `0x4d` value state is exactly split into 30 integer entries and 10 float entries by executor bounds (`index < 30`, then `index < 40`).
- Timers: `DAT_00585d37` accumulates elapsed milliseconds for the run and is cleared by full `4381f4` initialization; `DAT_00585d41` is the scene timer and increments alongside it. Normal scene-clear `43dbe3` resets `5d41` and its display fields when not restoring (`DAT_005e32b5==0`), while it does not reset `5d37`. Dependency opcodes 4 and 5 compare against these respective counters.

## Evidence files

All locations below are in `outputs/blackmoor-decomp/unverified-pseudocode/`:

- `4381f4.c.txt`: full scene initialization, action slot reset, inventory init call.
- `439822.c.txt`: scene loader and 120/240 action-count guard; invokes scene clear before normal SCEN loading.
- `40b34a.c.txt`: ACT action loading, raw `0x15` rewrite, slot eligibility marker and dependency loading.
- `427a50.c.txt`: action dispatcher and `0x4d/0x61/0x6b/0x71/0x6a` case dispatch.
- `423f57.c.txt`, `424201.c.txt`, `424346.c.txt`, `424aa8.c.txt`: dependency gate, evaluation, opcodes and raw record conversion.
- `42ba3a.c.txt`, `423d33.c.txt`: completion/repeat semantics and dependency reset.
- `42ae73.c.txt`, `42e844.c.txt`: hotspot rect export and phase-2 effects.
- `43a7ca.c.txt`, `4d3073.c.txt`, `4f0059.c.txt`: scene tick, event index to phase-2 path, and pointer hit test.
- `43dbe3.c.txt`: scene-clear timer reset.
- `44b26a.c.txt`: value setter.
- `4e13e4.c.txt`, `4e7253.c.txt`, `4e7e15.c.txt`: UI control, phone configuration, and inventory initialization.

Corpus scan used `outputs/blackmoor-decomp/build/libsceneresource.dylib` read-only over `work/analysis/hiff-resources/*.bin`; it opened 2,078 SCEN resources and 19,612 ACT records with no parser failures. No changes were made to that parser or to production code.
