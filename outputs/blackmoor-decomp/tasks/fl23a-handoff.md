# FL-23 batch a handoff (11 of 11 ported, none dropped)

Branch `worktree-agent-ad0e64d4555f36bc5` (worktree `.claude/worktrees/agent-ad0e64d4555f36bc5`), reset to the packet commit `504e5607` of `claude/fl23-session-input-ez2f5f` before any work (the worktree's own initial HEAD was `main`). The tip is the final commit (see the worker report; the evidence copy with hashes is `work/analysis/slices/FL-23a.handoff.json`). No independent review has been done. The claim-file step was skipped on instruction.

## Ported symbols (`src/original_methods_fl23a.c/.h`, `Fl23aWorld`, `Fl18Host` convention)

All are `thiscall`, `ret 8`, two word arguments (x at `[ebp+8]`, y at `[ebp+0xc]`), return 0 or 1 exactly like the original.

| va | span | symbol | host callees (args[0] last pushed) | original instructions reached by the oracle |
|---|---|---|---|---|
| 0x47d734 | 73 | `m47d734_store_point(self, x, y)` | none | 24/24 |
| 0x4a1e16 | 125 | `m4a1e16_hit_test` | 0x4a1e93 (0x2760) | 39/39 |
| 0x4ba377 | 271 | `m4ba377_hit_test` | 0x4ba486 (word slot) | 69/69 |
| 0x459cc9 | 275 | `m459cc9_hit_test` | 0x459ddc (word item) | 74/74 |
| 0x487c92 | 317 | `m487c92_hit_test` | 0x487dcf (0x2789,0) / (0x2788,item) | 87/87 |
| 0x48a920 | 326 | `m48a920_hit_test` | 0x48aa66 (0x2756,item) / (0x2757,0) | 91/91 |
| 0x48e628 | 334 | `m48e628_hit_test` | 0x48e776 (0x27b9,0) / (0x27b8,item) | 85/85 |
| 0x479deb | 391 | `m479deb_hit_test` | 0x478396 (3 args), 0x479f72 (0x279c,item+1) / (0x279d,0) | 106/106 |
| 0x46ea16 | 423 | `m46ea16_hit_test` | 0x46ebbd (x, y, 16-byte structure by value = 6 dwords), writes globals | 105/105 |
| 0x4b7389 | 474 | `m4b7389_hit_test` | none, writes globals | 111/111 |
| 0x4ab528 | 478 | `m4ab528_hit_test` | 0x4ab706 (0x27cf/0x27ce/0x27d0, item) | 131/131 |

Dropped: none. Commits: one commit holds all eleven ports with their tests (the functions were developed and tested together over shared fixtures); a second commit holds the acceptance snippet, this note and fixture strengthening. This deviates from "commit after each function".

## Files

`src/original_methods_fl23a.c/.h`, `tests/fl23a_direct_test.c`, `tests/test_fl23a_direct.py`, `tests/fl23a_differential_shim.c`, `tests/test_fl23a_differential.py`, `tests/fl23a_fixtures.py` (the fixture generators and `run_original`, shared by the differential and the oracle), `tests/fl23a_original_oracle.py`, `tests/fl23a_mutation_check.py`, `tasks/fl23a-acceptances.json`, this note.

## Acceptance snippet

`tasks/fl23a-acceptances.json`: eleven `native_oracle_verified` entries; each oracle is `tests/fl23a_original_oracle.py` with window start..start+span from the ledger (identical to the windows the ledger already holds for `session_input_original_oracle.py`); `parts_accounted` empty. The ledger lists no receipt blocker for any of the eleven rows, so no `blockers_reviewed`. Root merges the snippet and records the oracle run; no ledger file was touched.

## Test commands and results

- `cd outputs/blackmoor-decomp && export PATH=/tmp/claude-0/shim:$PATH && python3 -m unittest tests.test_fl23a_direct tests.test_fl23a_differential`: 31 tests OK (11 hit-test + 8 negative-index direct, 1 all-cases check, 11 differential).
- `python3 tests/fl23a_original_oracle.py`: prints one `0x... instructions N/N scenarios 300 digest <sha256>` line per function (all 11 N/N), exit 0; identical output with `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace`. Output holds no original bytes. Digests after the review fix (fixtures changed: slack records below the table and negative index words, so the digests of the eight record-table functions and nothing else changed from the first run; 0x47d734, 0x4a1e16, 0x4ba377 keep their earlier values):
  - 0x47d734 24/24 `006cf487780427c562c9a34c09ad687cce88edcd8ca37bf89fe491447bf79f1c`
  - 0x4a1e16 39/39 `72eaf3e666b62265564a6650d2dd37a1a7725b03e6f7665479c1f9dae8bcba6e`
  - 0x4ba377 69/69 `2f2e51282026b6dec456386cea0c3c9f496573b4f14da9a289ec2818b35587ea`
  - 0x459cc9 74/74 `1d157852f5a2f2b9f76e8b85e4fd9abd02dfbc0b72adb13c5c34bd58b257a5e9`
  - 0x487c92 87/87 `baa56f01f88ce3d62d118818a9b853fafcea379f6d892d87d6588c19d10a7839`
  - 0x48a920 91/91 `2773d4c6027baf17eab97d4aaca8477a870c89cf6f9ca5ffd9293fbbba88e6da`
  - 0x48e628 85/85 `677d4540ada2bd034e6e37a43e1e7552d54802cecb968ce5f6eeb07eeaf16193`
  - 0x479deb 106/106 `87c0ab1fccb2f927d8da26d9416b39fdbada6896e1cb8ec0bbcc9e139e19182a`
  - 0x46ea16 105/105 `049b3a98fe82ee0e4e8d7785e0792667c38f3712a02df921e6f965709f3c4cea`
  - 0x4b7389 111/111 `4a18d3d1ac7bb4630afad89aafbcf745c7810bf79ab7969750492be21eb15bce`
  - 0x4ab528 131/131 `7a18683137ecbfe10249b42e436f05e3521066633b37052c2c4a4f477615021b`
- Differential: 11 x 300 = 3300 scenarios; per scenario it compares all memory the function can write (the self object, the object behind it, the record table, the world globals), the return value, the bytes popped (8), and the ordered host calls with ecx, arguments (word arguments masked to 16 bits) and call-time probes (for example the store of 0xffff to `+0x1b0` before the call in 0x48a920 and `+0x24 = 1` after the call in 0x487c92). Profiles cycle over every gate combination, hit index and rectangle mode (inside on an edge, outside by one, random, and for 0x479deb the 32-bit wrap of the +10/-10 margins), so the deep arms are reached.
- Direct test: expectations hand-derived from the disassembly: four edges of every rectangle, negative edges, the word limits and a zero-extended trap, every gate (dword gates also with only a high byte set, byte gates with the neighbouring byte set), loop counts (signed word -1/0, unsigned byte 0x80 in 0x48a920), the call arguments in order, call-time probes, and the globals of 0x46ea16 and 0x4b7389 including 32-bit formula checks.
- ASan/UBSan: the direct binary built with `-fsanitize=address,undefined -fno-sanitize-recover=undefined` at -O1 and -O2: all 11 cases clean. The Python differential cannot be sanitised; its fixtures are bounded by construction.
- Mutation check: `python3 tests/fl23a_mutation_check.py` (committed; one mechanical break per copy: hex literal +1, `==`/`!=` swapped, guard line deleted, rd16/rd32/rds16 width or sign slips; each copy is run against the direct test, and if that passes against the Unicorn differential of the function in a child process). The earlier "83 mutants" figure came from an uncommitted scratch script and is superseded by this one: 238 mutants, 223 detected by the direct test, 11 more by the differential only, 4 survivors, all equivalent: 0x4ba377 line 124 and 128 (the loop counter 0 or 1 read as a word or a dword), 0x48e628 `rds16 -> rd16` on the selected-item word (compared with an item index 0..3, a set sign bit never equals it either way), 0x479deb `rd16 -> rd32` on the first word argument of 0x478396 (the pushed upper half is leftover register content; word arguments compare by their low 16 bits, see the divergences). `python3 tests/fl23a_mutation_check.py --index-only` runs just the eight record-index reads (`rds16(self, 0x1c|0x1e|0x21) -> rd16`): direct=caught and differential=caught for all eight (0x459cc9, 0x487c92, 0x48a920, 0x48e628, 0x479deb, 0x46ea16, 0x4b7389, 0x4ab528). These mutants passed both suites before the review fix.

## Hooks (all are host boundaries; no decision of a function under test is replaced)

Recording stubs at the entry of the callees 0x4a1e93, 0x4ba486, 0x459ddc, 0x487dcf, 0x48aa66, 0x48e776, 0x478396, 0x479f72, 0x46ebbd and 0x4ab706 (cleanup 4, 4, 4, 8, 8, 8, 0xc, 8, 0x18, 8 as read from each callee's `ret`). They log ecx and the stack arguments, optionally the state at the call, and return a scripted eax. No OS import is called by these functions.

## Deliberate divergences and known limits

- 0x47d734: the original loads the record dword at `word(+0x1d) * 0x8d + 0x5bb5e5` into a local that is never read; the port skips that read (a wild index would only fault in the original; fixtures keep it within 0..5). It stores nothing else.
- No bounds checks, as in the original: item counts read from the objects, record indices and loop counters are the caller's contract (a count beyond the object reads past it; a 16-bit counter that never meets its bound would not terminate in the original either). No rejection was added.
- Word arguments pushed from a 16-bit register compare by their low 16 bits; the pushed upper halves are leftover register contents.
- 0x479deb: `rect + 10` and `rect - 10` are 32-bit wrapping operations compared signed, as in the original (a fixture with edges near the 32-bit limits covers this).

## Unverified branches

- Callees that change `self` or an object are not exercised by the differential (the stubs change no state). The ports re-read fields after each call where the original does: 0x46ea16 reads `[self+0x24]` again for every entry, 0x4ba377 reads `[self+0x310]` and `[self+0x18]` in every iteration; this is by inspection only.
- Counts and indices outside the fixtures (item counts above 4 except the unsigned byte count 0x80 in the direct test of 0x48a920, record indices outside 0..5) are not compared with the original.
- The dispatcher 0x4f0059 and the callees are not part of this slice. No independent review has been done.

## Review fixes (P2-1, P3-2, P2-2)

- P2-1, the record index word is sign-extended in the originals (`movsx ecx,[self+idx]; imul ecx,0x8d`). Fixtures now cover it. `tests/fl23a_fixtures.py`: the record table Area starts `NEG_SLACK` (6) records below 0x5bb5e5 in the image; every generator takes its index word from `index_word` (profile changes once per cycle of the generator's combinations: an index 0..5, a negative word in the slack 0xfffa..0xffff, 0x8000). For 0x8000 the record lives in the Area `far` (a page below the image, 0x153000) and for every negative word a `decoy` object exists; the Unicorn image therefore has the slack records and the far record the original really reads. Natively the table, the slack and `far` become one contiguous host buffer that reaches 65536 records above the table, whose record at the zero-extended word leads to the decoy, so a zero-extending port reads a different object and fails the comparison instead of faulting (the original never reads those records). `tests/fl23a_direct_test.c`: `wide_table()` and eight `test_m..._negative_index` cases (words 0xffff, 0xfffe, 0x8000, 0x8001; the record of the zero-extended word leads to an empty object).
- P3-2, `m48e628_hit_test` and `m4b7389_hit_test` resolved the record object before the gate test; they now resolve after the gate (the original loads the record dword early but dereferences it only later). The direct negative-index cases assert that no `host->resolve` happens when the gate is closed.
- Unrelated fixture fix found on the way: the by-value dwords of the 0x46ebbd structure are data, not pointers, so `normalize` no longer maps a value that happens to lie in the stack range to `LOCAL` for them (`VALUE_ARGS`); one random scenario had hit that range.
- P2-2, the mutation script is committed as `tests/fl23a_mutation_check.py` (see above).
