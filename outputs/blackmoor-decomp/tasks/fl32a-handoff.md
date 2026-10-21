# FL-32 batch a (`fl32a`) handoff

Branch `worktree-agent-ad2327167966db547` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-ad2327167966db547`), based on `df1a427d` (the FL-32 packet commit, fast-forwarded in because the worktree had been created at `6f8d3d56`). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl32a-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 9 entries; none of the nine rows has a receipt blocker in the packet, so there is no `blockers_reviewed`). `FL.test_area` (decomp-progress/function_ledger.py) resolves all 27 test ids and `FL.symbol_area`/`addresses_in` finds each row's address in its symbol's body or leading comment.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (9 of 9, none dropped)

All in `src/original_methods_fl32a.c` / `.h` (symbols `m<va>_*`, world struct `Fl32aWorld`, host convention `Fl18Host` as in FL-18/26/27/28/29/31). Each row has its own symbol citing its own address and carrying its own constants; the three text handlers share the static helper `read_text_word` (field offset passed in) and the three table toggles share `toggle_dword` (table base passed in), as the FL-31 `pick_variant` rows did. The three flag toggles are written out separately.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x40425d | 59 | m40425d_read_text_cc | 20/20 | 0/0 | 44 | a1c527f9421b5385294ad59a38db54a0d7ba64ff14e6af591a0382fbf2d45470 | cfc14f42f433645b9c52e9548402ef00349916271a1711f5147d148690cc5725 |
| 0x404298 | 59 | m404298_read_text_10c | 20/20 | 0/0 | 44 | 73f3b27fb24342441370de97dfb353678d4ee6144bc177452a9810ef0ed7304f | 9751a1622a11ef6caf78592a491d60a9f09d9a614fca41e6f9ec5ca654372d5a |
| 0x4042d3 | 59 | m4042d3_read_text_1cc | 20/20 | 0/0 | 44 | f13bf518aab470c3c9f654adbf7efc1e0f7b8f5c9ada946f5dc226aa3ec8bb56 | 436c11b5a79c0cc59c2f5612b10fa84e94fc38c6f1ea8a61fa54c269f283807b |
| 0x4029a9 | 71 | m4029a9_toggle_5e60da | 20/20 | 2/2 | 108 | 15b781abc1b2875471a9293cfa0a06bb727142eb38219be48449b3ff66657ccb | 8f3aa04d0aa1511bcd05e016729987270d0e164c47d727069f62a1ccdfc2a8e1 |
| 0x4029f0 | 71 | m4029f0_toggle_5e60de | 20/20 | 2/2 | 108 | 99b8ce3f6db6b2d3e1518c3edf542de9744b31eed46b587840331ec6ba7c50be | 522e22c947013b78901fbf0997024ebf5bf16c28df1022f497022a8476992f32 |
| 0x402a37 | 71 | m402a37_toggle_5e60e2 | 20/20 | 2/2 | 108 | 1d6c624f3e000c73e097c98d1a991d8f0c7f01b186db9e9a718d81454332fd0c | f3c944f1af7780f092a4d9085e4312a9bfd7c96df7f6a4a0e04ae4e39ac20db7 |
| 0x4067eb | 71 | m4067eb_toggle_5e350e | 18/18 | 4/4 | 120 | 0710fec669ce048bb421d3a812862b2b178f83f9893e41251fcc87b3e11eee08 | c4834236247b443370b247ba307fc6cb0946695f838663c9c4479e7bcb872677 |
| 0x406832 | 71 | m406832_toggle_5e3512 | 18/18 | 4/4 | 120 | d713315eccdffe82f6b26d7e68be55b0e91a441bce8f2897d11bdbe0bdc878fa | c42ce8fafb9e81356c3950395e875d2d020c945e73016348512c7badea70c96f |
| 0x406879 | 71 | m406879_toggle_5e3516 | 18/18 | 4/4 | 120 | 737b135e228d29c566d5ccc366605d8873e2c3b4290ba1e8fad288988be88db6 | 22d31a1d8e1af6a190fb649f240988be85eb980d28537b568279b669ecc596cf |

Untaken jump edges: none. `fl32a_fixtures.UNTAKEN_ALLOWED` is empty and every conditional jump of every function is taken both ways (the three text handlers have no conditional jump, the three table toggles one `jne` each, the three flag toggles two each: 0 + 0 + 0 + 2 + 2 + 2 + 4 + 4 + 4 = 18 of 18 directions). None of the nine has an unreachable block behind an always-true guard (checked from the disassembly: the compares are against memory, the flag stores come after the compare, nothing is guarded by a loaded constant).

Per function (from the disassembly; the header `original_methods_fl32a.h` has the byte-level contract):

- **0x40425d / 0x404298 / 0x4042d3** (`push ebp; sub esp,0x18`, plain `ret`): `0x51d5b2(this = self + 0xcc / 0x10c / 0x1cc, local buffer at ebp-0x14, 0x13)` (thiscall, `ret 8` in the callee, so the callee pops its two stack arguments; the buffer pointer is the last one pushed), `r = 0x50cb1b(buffer)` (cdecl, the caller pops 4), word `[0x5ec33e / 0x5ec340 / 0x5e5688]` = low 16 bits of `r` (a `mov word ptr`), then `0x4033db(this self)` (thiscall, plain `ret`). The constants are checked per row (the three differ in the field offset and the destination word only; the call addresses and 0x13 are common).
- **0x4029a9 / 0x4029f0 / 0x402a37**: `i = dword [self+0x5c]`; when `dword [i*4 + base] == 1` (dword compare) it is set to 0, else to 1, `base` = 0x5e60da / 0x5e60de / 0x5e60e2; then `0x40236a(this self)` (plain `ret`). The index is read from `self` again for the store, as in the original. The index is a 32-bit register in the address computation, so the table address wraps in 32 bits; the port takes it as a signed index (fixtures use -1 and -3 with slack below the table).
- **0x4067eb / 0x406832 / 0x406879**: when `dword [flag] == 1` it is set to 0 and nothing else is stored; otherwise it is set to 1 and, when `movsx word [0x5e335e] == k` (k = 1 / 2 / 3), the word is set to 0xffff; then `0x404be1(this self)` (plain `ret`). Flags 0x5e350e / 0x5e3512 / 0x5e3516.

## Dropped

None. The spill rows of the packet are not part of batch `fl32a` and were not touched.

## Files

`src/original_methods_fl32a.h`, `src/original_methods_fl32a.c`; `tests/fl32a_direct_test.c`, `tests/test_fl32a_direct.py`; `tests/fl32a_fixtures.py`, `tests/fl32a_differential_shim.c`, `tests/test_fl32a_differential.py`; `tests/fl32a_original_oracle.py`; `tests/fl32a_mutation_check.py`, `tests/fl32a_hand_mutants.py`; `tasks/fl32a-acceptances.json`; this file. `fl32a_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (the Unicorn runner `Original27` with the edge hook, the stub constructor with scripted writes and derefs, the call-log normaliser, the conditional-jump finder) and the differential test imports `DiffBase` from `tests/test_fl_differential.py`; both are on main.

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl32a_direct tests.test_fl32a_differential` -> 20 tests, OK (11 direct: 9 functions, the run-all check and the sweep; 9 differential).
- Oracle: `python3 tests/fl32a_original_oracle.py` (9 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl32a_direct_test.c src/original_methods_fl32a.c -lm` -> 10 PASS (9 functions + the bounded sweep of 300 random scenarios), no report. The sweep keeps table indices inside the fixture table. (The first sweep range overran the 0x100-byte fixture table by a few bytes at the top index; ASan reported it and the range was narrowed. That was a test bug, not a port bug: the port, like the original, does not bounds check the index.)
- Mutation: `python3 tests/fl32a_mutation_check.py [--only <va key>]`, `python3 tests/fl32a_hand_mutants.py`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax` and log ecx, the stack arguments and, where named, probes of fixture memory and of the globals at the call. Shapes from the call sites: 0x51d5b2 thiscall(2) (callee `ret 8`; entered with ecx = self + field; it carries a scripted WRITE of 0x13 bytes of text into the buffer behind its first argument, the one thing the real callee does that the function reads back; probes `self` 0..0x20 and the three words); 0x50cb1b cdecl(1) (log shows the 0x13 bytes behind its argument as they are at the call, and the three words, so the store is proved to come after); 0x4033db thiscall(0) (probes the three words and `self`, proving the store comes before the call); 0x40236a thiscall(0) (probes the whole fixture table and `self` 0x40..0x80); 0x404be1 thiscall(0) (probes the three flags and the word). Globals and the table are patched into the image per scenario; every global of `Fl32aWorld` is set to a random value in every scenario and read back, so a store to a neighbour or with the wrong width shows. The oracle checks the number of bytes the function popped (0) on every run. No `rep` string move, no x87, no indirect jump in this batch.

## Deliberate divergences and native rejections

- The 0x14-byte local buffer of the three text handlers is uninitialised in the original (the harness fills the stack with 0x71 before a run; a real run has whatever the stack held); the port zero-fills it, as the FL-24 rule says. Nothing the function does depends on it: the callee writes the text (modelled by the stub's scripted write of all 0x13 bytes) before 0x50cb1b reads it, and the tests compare only those 0x13 bytes. A callee that left the buffer unterminated would let 0x50cb1b read stack garbage in the original and zeros in the port; the fixtures do not model that.
- The table index of the three toggles is taken as a signed 32-bit value; the original's address arithmetic wraps in 32 bits, which agrees for every index that lands inside the table (including negative ones). An index that lands outside the host table is caller-validated, as in FL-31.
- Nothing is bounds checked, as in the original.

## Unverified

- Callee conventions are read from the call sites and callee epilogues: 0x51d5b2 ends in `ret 8`, 0x50cb1b in a plain `ret` after being called with the caller's `add esp,4`, 0x4033db / 0x40236a / 0x404be1 end in a plain `ret` (first `ret` of their bodies, found by linear scan) and are called with no stack argument. The names (MFC `GetWindowText`, CRT `atoi`) are shape hints only (0x51d5b2 reads `[ecx+0x38]` and forwards to the import `0x52a408` or a vtable slot; 0x50cb1b forwards to 0x50ca90), not recovered names.
- Not exercised: a callee that changes `self` or a global the function reads again afterwards (for example 0x40236a changing `[self+0x5c]` is irrelevant here because nothing is read after the call; 0x4033db or 0x404be1 changing the globals is likewise after the last read), so the ports re-read like the original but the stubs never change anything.
- The tables at 0x5e60da/de/e2 overlap (element i of one is element i+1 of the next); the port and the fixtures treat them as one dword array at 0x5e60da with the three offsets 0, 4, 8, exactly as the addresses say. The meaning of the fields is a description of what the code does, not recovered source names.
- The tests/fixtures and the port were written in the order port, fixtures, direct test; the direct test's expected values were nevertheless derived from the disassembly and not from the port's output, and the mutation checks below show the tests fail on broken rules. No independent review; no claim that any family or pool is complete.

## Mutation check

`python3 tests/fl32a_mutation_check.py` over the whole file (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap):

```
mutants 32: caught by the direct test 31, by the differential test only 0, survivors 1
  survivor: line 55 (0x40425d) literal 0x14 -> 0x15
```

The one survivor is an equivalent mutant: it changes the size of the zero-filled local buffer in `read_text_word` from 0x14 to 0x15 bytes, and the callee is only ever given a pointer and the length 0x13, so no byte beyond the first 0x13 is observable at any host boundary. Hand-written mutants (`python3 tests/fl32a_hand_mutants.py`, all CAUGHT by the direct test, 30 of 30, 0 survivors): swapped and wrong arguments of 0x51d5b2 (order, `this`, the 0x13 length), `this` of 0x50cb1b, call order (0x4033db / 0x40236a before the store), a dword instead of a word store into the neighbouring word, a shifted result, wrong field offsets and wrong destination words (0x404298 / 0x4042d3), `== 1` replaced by `!= 0` / a 16-bit compare / `& 1` / `!= 0` for the dword compares, a 16-bit instead of 32-bit signed table index at the read and at the store, a wrong stored value, wrong table deltas (0x4029f0, 0x402a37), a wrong `this` for the callee, wrong word constants (0x4067eb, 0x406832), a byte instead of word compare of 0x5e335e, a wrong stored word (0 and 0x7fff instead of 0xffff), the word check also done in the "flag was 1" arm, a store to the wrong flag. Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand and double edits are not modelled.

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; `Fl32aWorld.table_5e60da` must point to host memory that mirrors the dword array at the original address 0x5e60da (all three toggles use it with the offsets 0, 4, 8) with slack for a negative index; the seven globals (three words, one word, three flags) are read and written through the world (the host copies them back to its own storage or points the world at it).
- `m40425d_read_text_cc` and its two siblings pass the host pointer of a local 0x14-byte buffer as the first argument of the host call 0x51d5b2 and again to 0x50cb1b: the host binding of the first must fill the buffer with a NUL-terminated string of at most 0x12 characters and the second must read it as the CRT `atoi` (the port does not interpret it). `this` of 0x51d5b2 is the host pointer of the field (`self + 0xcc / 0x10c / 0x1cc`).
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, of the files in the code commit; this handoff is added in the next commit)

| file | sha256 |
|---|---|
| src/original_methods_fl32a.c | 8c381245959823a092f26dae873e9bf82a06192edc4058a124cd4550fa9abcf1 |
| src/original_methods_fl32a.h | 585b1c2ccae32cacbc43d00bb235d6b9311564ea96065d446c5ee1e5aed6f8b0 |
| tests/fl32a_original_oracle.py | 194c96e4ad1580f20d5e948e31dd579f0bcdc28f80c620b71a2aa5cacfcb73cc |
| tests/fl32a_fixtures.py | 539978d9170e4f19c6dcac95441ee95c752ee3d987fa673f726dcede5dc5f695 |
| tests/fl32a_direct_test.c | 496b4bf8d9a794f68842afacc498c7450888423df08abf839ba83f60fcd69983 |
| tests/fl32a_differential_shim.c | 8c790f217830217d76a146f8ba53a1f4adf03c4ee916caf7e570cf38920c5392 |
| tests/test_fl32a_differential.py | d9900ed73cf762e8174ffa65776871ae9c8deb88f7a0d707cef532721427decd |
| tests/test_fl32a_direct.py | 48d914988ba2f192c891a4e56bc26a1d46eb2e486e81f1f21ce4eca1ff3ecb8a |
| tests/fl32a_mutation_check.py | b0c3ec7fba0dfa85f449ed5652f4b60ab6a7a1a312288d8fda9a0bc8e85caf78 |
| tests/fl32a_hand_mutants.py | 9fcb1efac2dca81dc7b03bb23cfd8dcddf4c94aee8f33d253ae256d1e6e743ee |
| tasks/fl32a-acceptances.json | cdc9969958749f0a9fa7b0c32c13f191fc260d3802db1401b10aba999eff4a6d |

Native library: the differential builds `tests/fl32a_differential_shim.c` + `src/original_methods_fl32a.c` into a throwaway shared object per run (no committed binary).
