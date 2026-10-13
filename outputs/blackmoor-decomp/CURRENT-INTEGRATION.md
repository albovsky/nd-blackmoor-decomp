# Current integration evidence

Source snapshot: `2b9b41b504c58cdfb7129f215a6d0d4d762aece8`. The original GOG executable remains unchanged (SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`). The full game is incomplete.

The reviewed S04-1 sound-control kernel and A-28 controller/frame adapter are collected on main. Independent review found an uninitialized sound restart result and a crop-offset bug; both were repaired and re-reviewed before collection.

The combined native build succeeds. The complete automated suite runs 367 tests: 365 pass and two filesystem-representation cases are skipped. The integrated sound-control original-x86 oracle matches all 34 cases; the A-28 setup/capture/blend original-x86 fixture passes. The earlier controller comparison matches 72 constructor cases, 92 dispatcher cases, 196,608 LUT entries and 288 packed pixels. These are bounded original-code comparisons, not whole-game or live presentation proof. The controller's tested curve still has small numeric differences from the original CRT.

The parser now identifies 11,089 typed action bodies and 8,523 opaque bodies across 19,612 actions in 2,078 scenes. All 15 S5900 action boundaries are typed. Its live action pass remains unimplemented: the current diagnostic captures S0/S5900 decoded backgrounds, and its A-28 gate is a pre-dispatch snapshot. Earlier scene rows can change that gate. The live coordinate adapter is also under original-producer reconciliation: viewport/clipping bounds and cursor coordinates have distinct roles.

Active work is split by ownership:

- Boot: [I01-1 persistent scene session](tasks/I01-1-persistent-scene-session.md), shared app/executor integration and genuine per-tick input/audio/action state.
- Claude: [S03-1 AVF decoder brief](CLAUDE-S03-1-BRIEF.md), separate decoder/oracle work; prior caption handoffs still require root acceptance.
- Sound worker: [S05 review repairs](tasks/S05-review-repairs.md), fixing three writer and two lifecycle findings after completing the bounded S04-2 recovery.
- Condition worker: original clock producers and dependency state, with explicit unsupported opcode-3 state until established.
- Matching worker: six complete x86 source candidates and compiler constraints. Whole-file matching remains open; the baseline still has only 14 exact bytes across two ranges, without complete-function proof for those ranges.

Caption rendering/lifecycle, live gameplay, complete save/load and both playthroughs, original codec equivalence, packaging and the complete x86 rebuild remain unfinished. The Mac is locked, so GUI and hardware audio have not been verified. Automated work continues.
