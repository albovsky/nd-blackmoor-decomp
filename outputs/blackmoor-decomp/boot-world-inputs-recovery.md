# Original BOOT, New Game, clock, and phone input contract

Scope: a read-only recovery of the BOOT values and phone table needed to seed the original game's first scene. Instruction behavior below was checked against original x86 bytes in `work/original/GAME.EXE` (SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`). Resource values were read from `work/analysis/cif-boot-native.bin` (69,442 bytes; SHA-256 `167ca6479ac93f5e4465557549d663c46a1ad48cf376ca81a4e6e6248191f6ac`). Existing decompilation exports are navigation aids only. This adds to `world-init-recovery.md`; it does not infer global table capacities from adjacent globals or the native model.

## BOOT summary and runtime globals

At VA `0x435015`, the original loader selects `BSUM` by name (the `0x43569b` lookup) and copies the reported chunk length into `0x005b0113` (`0x4356df–0x4356fc`). For this BOOT resource the payload begins at file offset `0x14` and is 402 bytes, so `BSUM[k]` is available at `0x005b0113 + k`. The ordinary boot path then runs the initializer at `0x4381f4` through state-0 dispatch at `0x438150`.

| BSUM offset | File offset | Signed little-endian word | Loader global | Initializer/runtime use |
|---:|---:|---:|---:|---|
| 221 | `0x00f1` | 0 | `0x005b01f0` | Ordinary initial scene; copied to current scene words `0x005bb57b` and `0x005bb57f` when no alternate tuple or forced-scene override applies. |
| 223 | `0x00f3` | 0 | `0x005b01f2` | Ordinary start-coordinate word A; copied to `0x005bb597`. |
| 225 | `0x00f5` | 0 | `0x005b01f4` | Ordinary start-coordinate word B; copied to `0x005bb593`. |
| 227 | `0x00f7` | 18 | `0x005b01f6` | Initial hour, stored at `0x00585d51`. |
| 229 | `0x00f9` | 0 | `0x005b01f8` | Initial minute, stored at `0x00585d4f`. |
| 231 | `0x00fb` | 3 | `0x005b01fa` | Hour threshold for the timed event check, stored at `0x00585d59`. |
| 233 | `0x00fd` | 1668 | `0x005b01fc` | Timed event-flag ID, stored at `0x00585d5b`. `-1` disables the write; this BOOT value is 1668. |
| 235 | `0x00ff` | 8000 | `0x005b01fe` | Alternate scene; selected only when `0x005bb1de != 0`. |
| 237 | `0x0101` | 0 | `0x005b0200` | Alternate coordinate word A; copied to `0x005bb597` with the alternate scene. |
| 239 | `0x0103` | 0 | `0x005b0202` | Alternate coordinate word B; copied to `0x005bb593` with the alternate scene. |
| 365 | `0x0181` | 20000 | `0x005b0280` | Signed millisecond clock-update interval. The initializer schedules `GetTickCount() + interval` at `0x00585d55`; the clock loop reuses it. |

The ordinary boot tuple is therefore scene 0 with two zero-valued coordinate words. I retain “word A/B” because the traced copies prove the two signed 16-bit values and destinations, but do not by themselves establish their user-facing axis names or units. With the ordinary tuple, scene selection can still be replaced by the runtime forced-scene path: if either `0x0063a4d1` or `0x0063a4d5` is nonzero, the initializer uses `0x0063a4dd` for the scene and retains the ordinary coordinate words. If `0x005bb1de` is nonzero, the alternate scene and coordinate pair take priority.

At `0x438334–0x438363`, the initializer stores the BOOT minute/hour fields and computes `0x00585d4b = hour * 60 + minute`. Thus this resource starts at **18:00 (1080 minutes)**. It clears the day counter at `0x00585d53`. In the original clock loop (`0x43b0b6–0x43b0e7`), after the day counter reaches 1, hour reaches the configured threshold, and the event ID is not `-1`, the game sets `eventflags[event_id]` to 1. For this BOOT record that is flag 1668 at hour 3 on day counter 1. The 20,000 ms interval is a scheduling cadence, not the game-time unit.

The native boot parser independently reads `BSUM + 221` as a signed little-endian 16-bit `initial_scene` (`engine_boot.c`, `read_les16(bsum + 221u)`). The current app's `Game.ini` parser reads only `ExternalCifFileChecking`; in the original `Game.ini` from the path named by `game-source.json`, `[Nancy Data]` has `ExternalCifFileChecking=1`, `TestingModeEnabled=0`, `DebugOutput=0`, and `RunInWindowedMode=0` (file SHA-256 `f8f892e828eca6086f5a25720e5e8e0c2ebbb7d81f1bb90bb8b73ea244419c79`). No scene, coordinate, clock, or phone defaults are supplied by those INI keys.

## Cold event flags and same-process New Game

The PE `.data` section has RVA `0x137000`, virtual size `0x10713c`, and raw size `0x33000`; with image base `0x400000`, it maps at VA `0x537000`. The event-flag base is `0x00585801`, at section offset `0x4e801`: inside the virtual section but past its raw bytes. A normal PE image load zero-fills this virtual tail, so event IDs 0–999 start at zero on a cold process start.

The menu's New Game case at `0x4daa24` sets `0x005bb1e2=1`. When `0x005e32b9==0`, it sets game state `0x00583981=14`, substate `0x00583999=0`, clears 33 bytes beginning at `0x0063a565`, and schedules work through `0x43dbd5`; state-0 dispatch at `0x438150` then calls the full initializer at `0x4381f4`. In the other branch (`0x005e32b9!=0`) it selects state 17 and clears `0x00616783` and `0x005e32b9`, rather than taking this state-14 full-init route.

The full initializer explicitly clears 1,251 dwords at `0x005867a1 + 4*i`, `i=0..1250` (`0x438233–0x43825c`, bound `0x4e3`). Relative to event base `0x00585801`, this is IDs **1000 through 2250**. It does not include IDs 0–999. In the original New Game initializer/callee path, no direct lower-table clear was found; consequently, lower IDs are zero for a cold process and **are not reset by the observed New Game clear loop**. Their values therefore persist across a same-process New Game unless another path changes them. This is a statement about the traced initializer and direct table accesses, not a proof that no unrelated alias-based write exists anywhere in the executable. The cleared span is not a claim about the event table's allocation or maximum ID.

The clock's timed event ID 1668 is in the explicitly cleared upper segment, so the New Game path clears it before the new clock run. The source code also contains gameplay stores to indexed event IDs, but no lower-segment clear in the full initializer.

## Phone/contact table loaded before the first S0 action

The original BOOT loader selects `UICL` at `0x43697f`; its success path (`0x4369c3–0x4369d6`) calls `0x4e4337` with `ECX=0x0057975c` and the UICL payload pointer/size. The current UICL payload starts at file offset `0xbb64`, is 3,981 bytes, and has SHA-256 `0e11c99406701eea7bb1ab5ab530e295fa8056ea4e6e884718ffb8a47b1f680c`.

Original loader `0x4e4337` copies the fixed prefix and configuration blocks, reads a signed short count at source-object `this+0x1471` (absolute `0x0057abcd`, UICL payload offset `0xd9f`), then copies `count * 0x29` bytes from payload offset `0xda1` to source object `this+0x457b` (absolute `0x0057dcd7`). Its count-dependent size comparison is `0xda1 + count*41 <= payload_size`; the comparison occurs after the copies. This payload contains count 12 (`0c 00`), exactly 492 row bytes, and ends exactly at payload byte 3981.

Each row is 41 bytes: 2-byte little-endian kind, 11-byte key, 20-byte NUL-padded display name, and 8 opaque bytes. The rows below are in UICL source order; row offsets are absolute offsets in the decoded BOOT file.

| Row | BOOT file offset | Kind | 11-byte key hex | Display name | Opaque tail hex |
|---:|---:|---:|---|---|---|
| 0 | `0xc905` | `0x000a` | `0105020305050509070001` | Mrs. Petrov | `40060100ffff0000` |
| 1 | `0xc92e` | `0x000b` | `0005020305050509070001` | Mrs. Petrov | `40060100ffff0000` |
| 2 | `0xc957` | `0x000b` | `0000000005050509070001` | Mrs. Petrov | `40060100ffff0000` |
| 3 | `0xc980` | `0x000a` | `0105020305050503070309` | Home | `3c190100ffff0000` |
| 4 | `0xc9a9` | `0x000b` | `0502030505050307030900` | Home | `3c190100ffff0000` |
| 5 | `0xc9d2` | `0x000b` | `0505050307030900000000` | Home | `3c190100ffff0000` |
| 6 | `0xc9fb` | `0x000a` | `0105020305050504030507` | Ned Nickerson | `a4060100ffff0000` |
| 7 | `0xca24` | `0x000b` | `0005020305050504030507` | Ned Nickerson | `a4060100ffff0000` |
| 8 | `0xca4d` | `0x000b` | `0000000005050504030507` | Ned Nickerson | `dc050100ffff0000` |
| 9 | `0xca76` | `0x000b` | `0105020305050509040008` | Paliki Vadas | `a4060100ffff0000` |
| 10 | `0xca9f` | `0x000b` | `0005020305050509040008` | Paliki Vadas | `b2070100ffff0000` |
| 11 | `0xcac8` | `0x000b` | `0000000005050509040008` | Paliki Vadas | `b2070100ffff0000` |

Before the first scene actions, New Game's `0x4381f4` calls `0x4e2e05` with the source object. That routine copies all 12 rows into runtime list `0x005a1e62`, writes the count to `0x005a1e5c`, and calls sort routine `0x4e3ade`. Thus the ordinary S0 baseline is a **nonempty 12-row table**, sorted by the original code before action `0x82` can update or append rows. A New Game reinitializes this runtime list from the startup-loaded UICL source object, so prior runtime phone-action edits are replaced by the BOOT rows.

No original global phone-table capacity is proved. The loader's count-dependent payload bound describes how many rows fit in a particular UICL resource; it does not establish the destination object's maximum. The observed `0x4e7253` action handler appends a 41-byte row and increments the count without an explicit maximum check in that handler. Neither the native analysis buffer size nor neighboring memory supplies an original capacity. The empty-table case in lookup `0x4e45be` is also not the fresh-BOOT baseline: its comparison-status local is only initialized inside the row loop, while this UICL starts with 12 rows.

## Remaining limits

- The signed coordinate words and their runtime destination addresses are proven; their axis names and scale are not established here.
- The alternate tuple and forced-scene override gates are mapped, but all possible pre-initializer writers to those gates are outside this bounded report.
- Event-table and phone-table global capacities remain unknown. The 1,251-entry event clear, 12-row BOOT phone table, 41-byte phone stride, and loader payload bound are observed spans or formats, not capacity declarations.
- The exact tie ordering among equal phone display names is not needed to recover the complete pre-S0 row contents and is not asserted here.

## Bounded native extraction API

`engine_boot.h` exposes `EngineBootStartupSettings` and `engine_boot_get_startup_settings()` as a separate projection of the recovered BSUM words; the existing `EngineBootSummary` definition and layout remain unchanged. The settings accessor preserves each field as a signed 16-bit value and keeps the two coordinate pairs opaque.

`engine_boot_get_phone_count()` and `engine_boot_phone_row_at()` read `UICL` only from the DATA record selected as `BOOT` when the `EngineBoot` object is opened. They validate that the chunk is at least `0xda1` bytes, that the signed count is nonnegative, and that `0xda1 + count*41` fits in the chunk before reporting a count or copying any row. A row accessor returns the complete 41 bytes in UICL source order. Missing/foreign UICL returns not-found, a negative count returns format error, and truncated or overrun data returns bounds error. These accessors do not sort or infer a global destination capacity; the caller that models original runtime behavior owns sorting separately.

Focused tests exercise the actual 18:00 / scene-0 defaults and all 12 source rows, signed field decoding, malformed/truncated UICL, and a UICL that exists only in a foreign DATA record.
