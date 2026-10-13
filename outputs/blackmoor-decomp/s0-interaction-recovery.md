# S0 interaction recovery: phone/control handlers and hotspot normalization

## Scope and evidence

This read-only static trace covers S0 resource 0800.bin and raw types 0x82, 0x1d, 0x6a, and 0x15. Original image: work/original/GAME.EXE, SHA-256 afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45. Evidence combines the existing parser and S0 bytes, unverified Ghidra pseudocode as a navigation aid, and static PE32 x86 disassembly. No source files were changed, no executable was launched, and no Unicorn execution was attempted here.

The existing parser retains raw type 0x15 and its 20-byte body. The current executor dispatches on raw type and has no runtime normalization step, so it reports the first eligible S0 action as unsupported type 0x82 before reaching these records.

## Correction to the older trace

The older description that the first 16-bit word of raw 0x15 is the runtime type is incorrect. The loader reads only body byte 0, writes that byte into the action slot type, passes it to 0x40b2d0, and stores that mapper result in constructed-payload word 0. In S0, body byte 0 is 0x0d, the runtime action type becomes 0x0d, and constructed-payload word 0 is 0. Body byte 1 is not used in this rewrite. Keep raw type 0x15 in the parser.

## Type 0x82: phone/contact configuration

S0 actions 0 and 1 are subtype 1, body length 41, and have no dependencies. Both are described as “Change cellphone info.”

- Action 0 body: 0a0001050203050505090700014d72732e20506574726f7600000000000000000040060100ffff0000; display name “Mrs. Petrov”.
- Action 1 body: 0a0001050203050505040305074e6564204e69636b6572736f6e00000000000000a4060100ffff0000; display name “Ned Nickerson”.

The body layout supported by the consumer is: bytes 0..1 opaque (S0 value 10); bytes 2..12 the 11-byte dedup key; bytes 13..32 the 20-byte NUL-padded display name; bytes 33..40 an opaque 8-byte tail. The loader allocates 0x29 bytes, copies 10 dwords plus one byte, and advances by 0x29 (disassembly 0x40e8c8..0x40e975).

Handler 0x4e7253 gets the slot payload and calls 0x4e45be with body+2 and length 11. Lookup compares exactly those 11 bytes to row offset +2. The global contact table begins at 0x5a1e62; its signed-word row count is at 0x5a1e5c and row stride is 0x29. A match replaces the entire 41-byte row; a miss appends the entire row and increments count. Both paths call 0x4e3ade to sort.

The sort key is the name at row/body offset 13. The sorter calls 0x50d0bc before comparing names. That helper uppercases ASCII a-z when global 0x63cb1c is zero; a nonzero value selects a locale/NLS path. Treat normalization mode as runtime-dependent if implementing compatibility beyond the ASCII branch.

After sorting, 0x4e7253 calls 0x4e0559(3,1,0). This sets group 3 availability at 0x5a17b4 + 3*0x1a4 to 1 and subflag 0 at 0x5a17b8 + 3*0x1a4 to 1. This belongs in caller-owned phone/UI state, separate from ActionCoreWorld. The dispatcher uses dependency mode 0 and directly writes completion byte slot+0x42 after handler return; it does not call 0x42ba3a. Machine-code anchors: dispatcher 0x4296be..0x4296ec, handler 0x4e7253..0x4e72f8, lookup 0x4e45be, UI helper 0x4e0559.

Native boundary: keep contacts in a caller-owned bounded table, upsert on exact bytes 2..12, copy all 41 bytes, apply the chosen name normalization/sort, set the group-3/subflag-0 bits, then complete. Original table capacity is not established, and the original handler has no visible capacity guard; native code should check capacity instead of reproducing an out-of-bounds write.

## Type 0x1d: control/UI range state

S0 actions 2, 3, and 4 are subtype 1, body length 8, and have no dependencies.

| Action | Group i16 +0 | Code u8 +2 | Mode u8 +3 | Start i16 +4 | End i16 +6 |
| --- | ---: | ---: | ---: | ---: | ---: |
| 2 | 3 | 13 | 1 | 0 | 0 |
| 3 | 1 | 13 | 1 | 0 | 0 |
| 4 | 2 | 13 | 1 | 0 | 0 |

Loader 0x40bc47..0x40bce6 allocates eight bytes and copies two dwords. Dispatcher 0x429324..0x429367 gates with dependency mode 0, invokes 0x4e13e4 with ECX=0x570508, and directly sets completion at slot+0x42.

Handler 0x4e13e4 reads group i16 at +0, code byte at +2, and mode byte at +3. Code byte 1 takes a separate UI-mode branch; S0 code is 13 and uses the generic path. For nonzero mode it scans 50 entries for a duplicate range pair and an empty sentinel. If the pair is absent, it stores start/end and the code byte widened to dword; if already present, it does not insert another. Mode zero has removal/control-command behavior and is not the S0 path.

Five control groups use 0x1a4-byte stride, based at 0x5a1620. Relative offsets: state dword +0x00; 50 signed-16 starts +0x04; 50 signed-16 ends +0x68; 50 dword codes +0xcc; availability dword +0x194; three dword flags +0x198, +0x19c, +0x1a0. Initializer 0x4e1a7e clears state/availability/flags, sets start/end entries to sentinel 9999, and initializes codes to 13. Thus S0 adds range [0,0] with code 13 to groups 3, 1, and 2 after standard initialization.

Consumer 0x4e18e5 applies group state and inclusive range membership to a control value, then calls 0x4e2940(3) or 0x4e2940(0); the visible helper writes ECX+0x30. The user-facing meaning of code 13 is not established. Native boundary: keep these five groups and their range arrays in caller-owned UI/control state, not ActionCoreWorld. Keep the code and mode as separate bytes, and do not reset shared group state per callback.

## Type 0x6a: repeated frame-matched flag hotspots

S0 actions 34 and 35 are subtype 2, body length 60, and have no dependencies. Layout is ten (i16 flag id, i16 value) pairs at offsets 0..39, i16 count at +40, then count 18-byte records at +42. A record is i16 frame at +0 and four i32 coordinates at +2,+6,+10,+14. Loader length is 42 + count*18.

Row 34 writes flag 1000=1 and has frame-0 rectangle (388,225,492,284). Row 35 writes flag 1002=1 and has frame-0 rectangle (396,150,489,211). Dispatcher 0x428cd0..0x428d07 uses dependency mode 1 and invokes 0x42e844.

Phase 0 advances to phase 1 and continues into the frame search. Phase 1 clears hotspot-active and, on a current-frame match, re-arms it and exports the rectangle. The input path maps a hit rectangle to an action index and schedules phase 2 on a later tick; existing trace anchors are 0x43a7ca -> 0x4d3073 -> 0x4f0059, with inclusive rectangle bounds. A separate mouse-button condition is not proven in that rectangle loop.

At phase 2 the handler writes each non--1 id from the fixed ten-pair list, then calls 0x42ba3a. S0 subtype 2 resets completion, dependencies, and phase so the hotspot can repeat. A faithful callback needs current frame, exported hotspot state, and a real phase-2 interaction signal; it must not synthesize a click or complete on frame match.

## Raw 0x15 to runtime 0x0d scene-change hotspot

S0 action 32 is subtype 1, body length 20, no dependencies. Body bytes: 0d000019870100004b000000ea0100008a000000.

Loader 0x40b667..0x40b7c0 constructs a 40-byte internal payload: raw body +2 is copied to internal +2; raw body +4..+19 is copied to internal +0x18..+0x24. It initializes +4=0, +6=0, +8=1, +10=0, +14=0, +18=1, and frame +0x16=0. At 0x40b779..0x40b7b4 it reads raw body byte 0 into the slot runtime type, calls 0x40b2d0, and stores the return at internal word +0. The source cursor advances 20 bytes. Fixed parser length and trailing dependency boundary stay 20.

For S0, runtime type is 0x0d; target scene is signed i16 raw body+2 = 0x1900 (6400); frame is 0; rectangle dwords are [391,75,490,138]. Constructed payload: +0 mapped word 0; +2 target; +4/+6 words 0/0; +8 word 1; +10/+14/+18 dwords 0/0/1; +0x16 frame 0; +0x18/+0x1c/+0x20/+0x24 rectangle dwords.

Runtime type 0x0d calls 0x42ae73 after dependency mode 1. Phase 0 exports the rectangle and advances to phase 1; phase 1 arms only on current-frame match. Phase 2 directly completes, sets engine state to 4, and copies target/opaque payload fields into transition globals 0x5bb57b, 0x5bb595, 0x5bb599, 0x5bb59b, 0x5bb59f, 0x5bb5a3, and 0x5c39ff. It is not direct type 0x0a and does not call 0x42ba3a.

Native normalization contract: preserve raw type 0x15 and its original 20-byte body in the parser; derive a runtime view where type is body[0] and the payload is the exact 40-byte structure above. Retain the original action for diagnostics. Do not interpret body[0..1] as a u16, route this to 0x0a, or request transition before real phase 2. The existing executor lacks current-frame/hotspot input context and a delayed-transition disposition; add an explicit transition request path rather than an ordinary completed callback.

## Isolated original-code oracle candidate

The PE32 mapper in tests/cif_original_oracle.py and Unicorn harness pattern in tests/action_core_original_oracle.py are reusable. Unicorn 2.1.4 is installed at work/tools/oracle-python/bin/python. A bounded next test can seed one action slot, enter dispatcher 0x427a50 with a true return at dependency gate 0x423f57, and compare original global memory for one 0x82 or 0x1d row. Direct entries 0x4e7253 and 0x4e13e4 are narrower; initialize control groups through 0x4e1a7e. Useful phone cases are insertion, duplicate-key replacement, name ordering with 0x63cb1c=0, and UI availability; control cases are insertion and duplicate no-op. No oracle was run here; the existing action-core harness only covers 0x4d, 0x61, 0x6b, and 0x71.

## Limits

- Phone-table capacity and overflow behavior are unproven.
- Phone sorting has a global-dependent locale/NLS branch.
- The user-facing meaning of control code 13 is unresolved.
- The rectangle hit-test loop does not establish an independent mouse-button gate.
- Raw 0x15 transition-field meanings after they are copied remain opaque.

