# FL-28 batch c (`fl28c`) handoff

Branch `fl28c` (worktree `/home/user/wt/fl28c`), based on `4a1d00d` (the FL-28 packet commit). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field, and root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited; `tasks/fl28c-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 7 entries; two carry `blockers_reviewed`, see below). The acceptance windows are `[va, va+span)`; the oracle run record (`function-execution.json`) and the evidence regeneration are root's step (the oracle also runs with `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace`, exit 0, one trace file). With `extract_function_evidence.py --write --output <scratch>` the native sources and tests resolve for all seven rows; the only mechanical check left open in my scratch derivation was the oracle window, which exists once the run is recorded.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (7 of 8, one contiguous code range each, no data inside any span)

All in `src/original_methods_fl28c.c` / `.h` (symbols `m<va>_*`, world struct `Fl28cWorld`, host convention `Fl18Host` as in FL-18/26/27). Every one is a thiscall method of the action 0x2d runtime object (`self` = ecx), except where noted.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4cf026 | 131 | m4cf026_find_record | 42/42 | 8/8 | 75 | af828c367a4c9a47144e39c5c7431179e2f4a33055c336647e17917e08ddbec4 | 653b928813ebf80a73c13a45d6ff97a25d178043dbfb68b176d2b57ac70c4432 |
| 0x4cec6c | 139 | m4cec6c_bump_counter | 39/39 | 8/8 | 225 | b7ec19d85a7bcc7b7be51dfa30a199d097827b2fd51115f316b74bd28393f6db | 5c0551332384f5bce6d1ff1a9dfe1968838cd4e035c9882992de01d5c1e2f0f1 |
| 0x4cf1e4 | 146 | m4cf1e4_alloc_clear | 47/47 | 4/4 | 165 | 5888d7ecf9f7c0b0fa2c33a28843d0b073606cdbfd832bfea3024e9cf1efd317 | 57fc0c8e764630811d7505589b50b6507a779ee276fd3909722ded614a7be88e |
| 0x4ceb8c | 224 | m4ceb8c_load_rect | 60/60 | 6/6 | 81 | e01e1ee4d19da92cc7d4c091c28cd6c0c0a2b39693ec3f515de93b43337e56a6 | 44fb80510d553e1cdf123f23cd3233c79932517869fc7315240aaf9df249673b |
| 0x4ccef1 | 204 | m4ccef1_release_movie | 59/59 | 4/4 | 40 | 78ea85b957cd3ce3274da7c48a82db378010b1238eb729c23a2dab82dd5f42ac | de58e87a8abad8aaadf9480d8e594a0b88fdf356732b5c869f022986f9aece38 |
| 0x4ce8ea | 593 | m4ce8ea_scan_step | 154/154 | 20/20 | 174 | 771f23c753a080c0de028f22f68043ee70993e98ee43ff13bb040f925e80734f | 6a37c4f21041be9ea11ddeedd55c1f838c622fad3abafe1d90d6b97f2f43854f |
| 0x4cd243 | 1026 | m4cd243_read_tables | 302/302 | 16/16 | 234 | d51e13af12cb4ca64b8bb622e432f2f630f29cd4c482e2a476467e1be457413a | 5b186c92f48dc216b08e6bab3d683b068f4662942bf6f94f956acd4faa4659a3 |

No conditional-jump direction is left untaken (`UNTAKEN_ALLOWED` is empty). The window hashes of 0x4cf1e4 and 0x4cd243 equal the ledger's.

What each port is (the headers give the byte-level contract):

- **0x4cf026** (`ret 4`, returns eax): index of the first record (stride 0x35, table at the original address `[self+0x222]`'s sibling `[self+0x226]`) for which the cdecl compare 0x516530(key, record address) answers 0; -1 when either dword is zero, the signed word count `[[self+0x222]+0x23]` is exhausted (re-read every step) or negative.
- **0x4cec6c** (plain `ret`): 16-bit wrapping bump of `[self+0x1ca]`, replaced by the signed word `[rec+0x23]` when larger (guards: `[+0x222]`, `[+0x226]`, `[+0x246] == -1`). No callee.
- **0x4cf1e4** (`ret 8`, returns eax = 1/0; ecx is saved and never used, so the port has no `self`): `p = 0x51dc43(size)`, `*out = p`; p == 0: the report 0x50ca3e / 0x4264e8 / (debug word) 0x44a2b7 / 0x4c97b4 and return 0; else clear `size` bytes at p (dwords, then bytes) and return 1.
- **0x4ceb8c** (plain `ret`): the eight rectangle dwords from a 0x22-byte record with the x/y origin globals added (32-bit), in the original store order.
- **0x4ccef1** (plain `ret`): releases `[self+0x1d6]` (0x44c479, `[self+4]` = 2, 0x449a94, the virtual deleting destructor through `[[o]+0]` with the argument 1 on the re-read object, `[self+0x1d6]` = 0, 0x44c4ab, `[self+4]` = 0), then the three closing calls 0x415011, 0x41632b, 0x4bedfa.
- **0x4ce8ea** (plain `ret`): the two-arm scan state machine on `[self+0x1da]` (0 and 4; every other dword value returns at once): 0x4bef85 gate, 0x4befc8, the six-argument 0x4bf098 (two sign-extended words), `[self+0x232]` = 0x4bee2c - 1, 0x4ceb8c, 0x4bf10f, the compare of `[self+0x232]` (re-read) with the signed word `[rec+0x23]`, the state / `[+0x1de]` stores and the debug text.
- **0x4cd243** (`ret 0xc`, returns 1/0): the scene-table reader over three cursor cells (`dst`, `src`, `tail`, host pointers to dwords): busy guard, header (0x27 bytes), record table, per record 0x31 bytes plus a sub table of signed-word * 0x23 bytes, second table of signed-word * 0x22 bytes, cursor advances and the debug tail (0x4cf276, 0x44a2b7); four allocation failures each with a report pair.

## Dropped (stays pending)

- **0x4cdfd3** (1583): the default arm of the switch at 0x4ce2b0 (`xor eax, eax` at 0x4ce5a7 and the `jmp 0x4ce5f0` at 0x4ce5a9) cannot be reached by a legal fixture. The switch value is a copy of `[self+0x21a]`, which the function itself sets only to -1 (0x4ce03b), 1 (0x4ce080, 0x4ce0c7) or 0 (0x4ce119, 0x4ce166); after the `cmp [self+0x21a], -1` / `jne` at 0x4ce170 the value is therefore 0 or 1, and the only callee between that test and the switch is 0x44c4c1(self+8), which writes the record at self+8 (up to about self+0x1d8, per the FL-27c port), not self+0x21a. So 0x4ce5a7..0x4ce5a9 are never executed (owner ruling: unreachable blocks behind a guard that cannot fail stay pending). Not attempted beyond the disassembly review; if the owner wants it ported with the default arm as an allow-listed untaken block that needs a ruling.

## Files

- `src/original_methods_fl28c.h`, `src/original_methods_fl28c.c`.
- `tests/fl28c_direct_test.c`, `tests/test_fl28c_direct.py`: hand-derived direct tests and a bounded sweep (also run under ASan/UBSan).
- `tests/fl28c_fixtures.py`, `tests/fl28c_differential_shim.c`, `tests/test_fl28c_differential.py`: Unicorn differential (original bytes against the native symbol on the same generated fixtures; ordered host calls with arguments, the bytes behind probed memory, the globals and every fixture region are compared).
- `tests/fl28c_original_oracle.py` (original bytes only, no native library), `tests/fl28c_mutation_check.py`, `tasks/fl28c-acceptances.json`.

## Commands (from `outputs/blackmoor-decomp`, after `export PATH=/tmp/claude-0/shim:$PATH`)

- Direct and differential, slice tests only: `python3 -m unittest tests.test_fl28c_direct tests.test_fl28c_differential` -> 16 tests, OK (9 direct including the sweep and the run-all check, 7 differential).
- Oracle: `python3 tests/fl28c_original_oracle.py` (seven lines as in the table, exit 0); with `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` the same lines and exit 0.
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl28c_direct_test.c src/original_methods_fl28c.c -o <bin>` -> all 8 cases PASS (7 functions + the bounded sweep of 300 random scenarios per function), no report.
- Mutation: `python3 tests/fl28c_mutation_check.py [--only <va key>]`.

## Hooks (oracle and differential; nothing the original decides is replaced)

Every callee is a recording stub entered by address: it pops its arguments (cdecl 0 bytes, thiscall `4 * n`), returns a scripted `eax` and, where a scenario needs it, stores scripted dwords (call number, argument or absolute address, offset). No import slots, no `fs`, no x87. The debug word 0x63a4cd, the globals 0x583186, 0x58318a, 0x5c39e3, 0x5bb57b are patched into the image per scenario (the two bytes behind the debug word and behind 0x5c39e3 are random compared-out neighbours).

- 0x4cf026: 0x516530 (cdecl 2).
- 0x4cf1e4: 0x51dc43 (cdecl 1), 0x50ca3e (cdecl 2), 0x4264e8 (thiscall 1), 0x44a2b7 (cdecl 1), 0x4c97b4 (thiscall 0). The allocation result is the scripted `eax` (a fixture region address, 0, or an unresolvable value with size 0).
- 0x4ccef1: 0x44c479 (cdecl 1), 0x449a94 (thiscall 0; in the profile `cleared` it stores 0 into `[self+0x1d6]`), 0x44c4ab (cdecl 1), 0x415011, 0x41632b, 0x4bedfa (thiscall 1) and the vtable entry (stub at 0x7e000900, `[[player]+0]`, thiscall 1).
- 0x4ce8ea: 0x4bef85, 0x4befc8, 0x4bee2c, 0x4bf10f (thiscall 1), 0x4bf098 (thiscall 6), 0x4ceb8c (thiscall 0; in the profile `match` 2 it stores the equal value into `[self+0x232]`), 0x44a2b7 (cdecl 1).
- 0x4cd243: 0x4cf1e4 (thiscall 2; scripted answers per call number and the stores of the pointer cells: header buffer, table, one sub table per record, second table; a failing call stores 0), 0x50ca3e (cdecl 3 in the busy scenarios, cdecl 4 otherwise), 0x42639d (thiscall 2), 0x4c97b4 (thiscall 0), 0x44a2b7 (cdecl 1), 0x4cf276 (thiscall 0).

Callees that are batch or ledger functions are all host-stubbed, none bound to the ports: 0x4cf1e4 (called by 0x4cd243, a port of this batch), 0x4ceb8c (called by 0x4ce8ea, a port of this batch), 0x44c479 (fl27a), 0x449a94 (fl27b). The integration step decides whether the host binds them to `m<va>_*`; the host contract (flush the world before and resync after each call) is in the header.

## Deliberate divergences and native rejections (not original behaviour)

- 0x4cd243: a negative sub-table size (signed word `[rec+0x2f]` below zero, times 0x23) or a negative second-table size, after the allocation succeeded, returns 0 before the copy and before any later store; the original would run `rep movsd` with a count of about 2^30 dwords. When the allocation fails the negative size is passed on as a dword and the original failure path runs (both tested). The rejection is covered by the direct test only (the oracle cannot run it).
- 0x4cd243: the `dst` / `src` / `tail` stack arguments are host pointers to dwords; the header buffer, the tables, the sub tables and the stream are original addresses resolved through `Fl18Host.resolve` (called unchecked, but not for a size of 0).
- 0x4cf1e4: no `self` parameter (the original never uses ecx); `resolve` is not called for a size of 0 (the original touches nothing then).
- Return values: 0x4cf026 returns eax as `int32_t`; the void methods leave eax stale in the original (not compared).

## Unverified branches / what the fixtures do not pin

- A callee that changes `self` or a global the function re-reads is exercised only where named: 0x4ccef1 (0x449a94 clears `[self+0x1d6]`), 0x4ce8ea (0x4ceb8c stores `[self+0x232]`), 0x4cd243 (the header word count lowered after the first record's allocation, direct test only). Everywhere else the callees leave `self` alone (0x4cf026's compare callee, the movie calls of 0x4ccef1).
- The scripted allocation answers of 0x4cd243 model only the pointer stores of 0x4cf1e4; its own body (a separate port) is not run inside 0x4cd243. A negative record count (word 0x8000, -1) with a scripted successful table allocation of a negative size is synthetic (a real allocation of that size fails); it is there for the signedness of the loop compare.
- 0x4cd243 and 0x4cf1e4 receipt blockers (`A-2D.1:2351c9c937e38a7d`, `A-2E.1:98d39096d37b0362`) are cleared through `blockers_reviewed` only for the located branches (the debug-word branches at 0x4cd25a/0x4cd289/0x4cd618/0x4cd635 and the allocation-failure path at 0x4cf20b..0x4cf250); the bodies of 0x4cf276, the 0x40b43e logging and the fatal-logging internals are separate functions and stay open.
- The callee names and the meaning of the fields are hints from the argument shapes; only the call shapes, the order, the widths and the effects are verified.
- No independent review; no claim that FL-28 or the action 0x2d family is complete.

## Mutation check

`python3 tests/fl28c_mutation_check.py` (full run on the final source): 290 single-edit mutants (hex literal +1, `==`/`!=` swap, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap), 260 caught by the direct test, 18 more only by the Unicorn differential, 12 survivors. All 12 were read and are equivalent or unreachable:

- 0x4cec6c lines 114 and 115 (`rd16` -> `rd32` in the counter and in the clamp value): the 32-bit read is truncated by the 16-bit store; line 115 `>` -> `>=`: at equality the clamp stores the value it already has.
- 0x4cf1e4 line 136 and 0x4cd243 line 232 (`i + 4 <= n` -> `<`): the byte loop does the last dword's work; the result is identical.
- 0x4cd243 line 277 (copy of 0x22 bytes instead of 0x21): the extra byte is the first byte of the word at +0x21, which is stored next from the same source. Lines 279, 281, 287, 289 (`rd16` -> `rd32` under a 16-bit store): truncated. Lines 299 and 310 (`rds16` -> `rd16` in the running offset and in the second cursor advance): differ only for a negative word, which the native rejection has already returned on after the same allocation.
- One real gap was closed during the work: 0x4cf026's first guard (`[self+0x222]` read at +0x223) survived while the table address had a zero low byte; the fixtures now use table addresses with a non-zero low byte.

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand and double edits are not modelled (the same list as in the FL-26 / FL-27 handoffs).

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; a host binding must say which side translates addresses: `dst` / `src` / `tail` of 0x4cd243 and the `out` cell of 0x4cf1e4 are host pointers; everything stored inside the records and `self` is an original address resolved through `resolve`; `self+n` passed to callees is a host pointer into the object.
- Bind 0x4cf1e4 (in 0x4cd243) and 0x4ceb8c (in 0x4ce8ea) to their `m<va>_*` symbols when wiring the callers, flushing and resyncing the world around each call.
- The new ports are standalone; no shared parser, dispatcher or app file was edited.

## Hashes

GAME.EXE `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`. Window hashes: see the table; the dropped function's window (0x4cdfd3..+1583) is `b1030236e3d5715d75aec2f7b8acdd13dbe1ae948d70ef9330b86f2e8e9729bc`. Source and test hashes (sha256, at the last code commit `4448776`):

| file | sha256 |
|---|---|
| src/original_methods_fl28c.c | 75c6d75d4c4ef5e7be4d3de620e5a5af2ce112dde65550dff6825e584ae9b752 |
| src/original_methods_fl28c.h | c17fab0d55c18a53b207924f08ffc507e5fb1c86794b5a0d8309e64be18f0067 |
| tests/fl28c_original_oracle.py | 0f4223d7d2ec197e8664ce76e33704e6e9222023868c4504d464738c4708ff89 |
| tests/fl28c_fixtures.py | 4ec5e9c5a8642e9072d46d1b4a728e8263e0cb58a0cd0a337f2077cf95f22f1e |
| tests/fl28c_direct_test.c | 4d4fa6cfeae9bdfc7abeba1dcc6d9e7803ad8c23aca06540dfe0324261e1ed10 |
| tests/fl28c_differential_shim.c | 2b2444865ee9f6667cf8ca2e767ee03b33850b653ffac431d2a46534394ba4c6 |
| tests/test_fl28c_differential.py | 80b054fad6f5a75827b00ffa7692e98077e744c9b655d4b16e83f9df71324e43 |
| tests/test_fl28c_direct.py | 9e1a42a16f673a68b40894494e6ad9bbc5ce147fdffded656bb983e0daf4974c |
| tests/fl28c_mutation_check.py | 7d974d7e62c29746dd21e39cdf61c35e07130df4d5a9a6547da73588261f5402 |
| tasks/fl28c-acceptances.json | e4ab50e56defb4ac9590a07cbc5b05bf3be05e134fda38695a8df2574cf4740c |

Native library: the differential builds `tests/fl28c_differential_shim.c` + `src/original_methods_fl28c.c` into a throwaway shared object per run (no committed binary).

## Branch and commits

Branch `fl28c`; commits `584e5cb` (0x4cf026, 0x4cec6c, 0x4cf1e4, 0x4ceb8c), `7116aa3` (0x4ccef1, 0x4ce8ea), `4448776` (0x4cd243 and the acceptances draft); the final commit adds this handoff.
