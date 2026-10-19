# FL-28 batch a (`fl28a`) handoff

Branch `fl28a` (worktree `/home/user/wt/fl28a`), based on `4a1d00d` (the FL-28 packet commit). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field, and root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited; `tasks/fl28a-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 11 entries; `blockers_reviewed` for the three functions with receipt blockers).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (11 of 12)

All in `src/original_methods_fl28a.c` / `.h` (symbols `m<va>_*`, world struct `Fl28aWorld` with the debug word `word_63a4cd`, host convention `Fl18Host` as in FL-18/26/27). Oracle lines are from `python3 tests/fl28a_original_oracle.py` (exit 0). The window hash is the SHA-256 of the original bytes `va..va+span`.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 |
|---|---|---|---|---|---|---|---|
| 0x4235fd | 55 | m4235fd_pop | 22/22 | 2/2 | 26 | f03877f67b00beda6eae35b7c92e46ce5ddfc999e61013c6f61c1cdab6d1079c | 8a6999419fee63910944336417e99db758d3eb9b03c751ce7fb8499bb1e84a1b |
| 0x4fc808 | 112 | m4fc808_clear_slot | 30/30 | 2/2 | 40 | 06356366406e565c2ded1e5e251c55d1787b441773bc210f8cbaa70a07261b5e | 8a3072a589d1e623c814e0665396ac69dc9eb0041c5c2bcc00423a69bd99f0f8 |
| 0x4237f7 | 127 | m4237f7_new_block | 41/41 | 4/4 | 34 | a563cd73c42b3218f8e922d301579b6e3c7958b614265ac87185a1614597fc26 | f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084 |
| 0x4236d6 | 127 | m4236d6_new_block | 41/41 | 4/4 | 34 | 32280be8dd5d21ae3d43358804398372d637d7114de8244cebfef2c61385e119 | d3e12ee43fdc94129c88d28e0a7b257960663e21e8779a3158cf51845492361a |
| 0x4f80d3 | 132 | m4f80d3_play_retry | 45/45 | 4/4 | 88 | 04f0acc376a6b7745f7d0e198129e3502c6bae8ef890f7da9662f0b29893c827 | dc16606f13f8788509f8bda97646320f50b3710e0f2010533e228f74e0d60621 |
| 0x42356d | 144 | m42356d_push | 43/43 | 4/4 | 60 | 756f66a6cd7c32d2584b0838590aaacc23b157ba4d08f184375b3a83ba819adf | a6dc33d7551652dc77db241a4b9d86dce0b508ed4deefc755006e966dde76506 |
| 0x4fb2e3 | 180 | m4fb2e3_start_slot | 48/48 | 6/6 | 240 | 7ed9414d60eaf91478f3778f8a4553301699efa38e558faf06b99895a4f010b9 | ed3fa0d31231e810539fda23128c0e4955d0a704ad0f126cb7101240fe04c9d3 |
| 0x423368 | 232 (218 code) | m423368_hash_name | 72/72 | 11/12 (one allowlisted) | 236 | 7e652b30ab5ecae42bd1873bfe67764fd8fa12b81985cd2083482fe667709a54 | 19a53a61d35b929875a6a20c79c8db0da4f9266dbf6b985c24d6912e9dda2f04 |
| 0x423142 | 279 | m423142_insert | 101/101 | 4/4 | 192 | a2c47c4ae4871c0f4ac616334e0fea7e300fbd0649e5255d9a58b0c501356675 | 6910fd42954f15d645d47b5092f2f8856dca626982d0c7e053a167083309f578 |
| 0x4fadc4 | 468 | m4fadc4_set_name | 121/121 | 6/6 | 768 | c9fcb960236b5387e00b50ae00828f0201d38150c4c3abc76b2a1b690f81d416 | 0576d48f541320ff06b1ff2f8753d013d9d9c0516f44f4cf475e6d02577f2afa |
| 0x4f356e | 558 | m4f356e_unload | 140/140 | 30/30 | 1032 | 1c1b1c69ce6626365b75cb3cd89b6f42471bbc6d29622f0a9f0b1eac9dee3452 | e36ab4c8e70a7625c53b6b06af62d83c5e40f00d812a94596afe555bf51b489f |

The window hashes of 0x4237f7, 0x4236d6 and 0x4f356e equal the ones the ledger already records. The first eight ports are one commit (they share the new infrastructure), then one commit each for 0x4f356e, 0x4fadc4 and 0x423142.

What each port is:

- **0x4235fd** (thiscall): the pop of a table of 12-byte entries at `self+8` with the count at `self+4`; returns NULL for count 0, else decrements and returns the address of the entry (32-bit wrap, as the `imul`/`lea`).
- **0x4fc808** / **0x4fb2e3** (thiscall, `ret 4`, slot argument by its low 16 bits): the debug traces (`0x50ca3e` / `0x44a2b7` when the debug word is non-zero), `0x4f356e` resp. `0x4f6059` (and, on a zero answer with the debug word set, `0x4fa2a8` and a second trace), and the word `[self + slot*0x5bb + 0x132]` = 0 resp. 1.
- **0x4237f7** / **0x4236d6**: allocate 0x4c / 0x1c bytes (`0x51dc43`); on failure the report, `0x52139c`, the optional `0x44a2b7` and the process exit `0x4c97b4`; otherwise the block is cleared (`rep stosd`) and its address returned.
- **0x4f80d3** (thiscall, `ret 8`): a vtable call (entry 0x30, stdcall with four arguments) whose result is stored at `self+0x3ca`; the DirectSound buffer-lost answer 0x88780096 triggers the entry 0x50 and the call again; returns 1 when the stored result is zero.
- **0x42356d** (thiscall, `ret 8`): the push of two dwords as a 12-byte entry (`self+8+12*n`, `self+0x10+12*n`) with the count at `self+4` (signed compare `jl 0x80`; a negative count is valid and reaches below `self`); a full table is the fatal report. With count -1 the second store lands on the count itself (tested).
- **0x423368** (thiscall, `ret 4`): the name hash (`atoi`-like `0x50cb1b` of `name+3`, then of the first suffix whose character `0x50d6cf` accepts, remainder idiom `& 0x800003ff`, signed 16-bit result, fallback the signed first byte).
- **0x423142** (thiscall, `ret 8`): the insert at the end of a hash chain: the cell index from `0x423368`, the walk over `cell = [node+0x25]`, the node (`0x51dc43(0x29)`, constructor `0x423000`), the value buffer and the two string copies; returns the value length + 1 (what `eax` holds at `ret`).
- **0x4fadc4** (thiscall, `ret 8`): the name copy into the slot record and the two scaled `__ftol` conversions (x87 in 53-bit precision), then `0x4f379c`.
- **0x4f356e** (thiscall, `ret 4`): the slot unload: the guarded counter decrement, `0x4f6334` / `0x4f61e7`, three COM-style Release calls through vtable entry +8, a `free` (`0x51dc6c`), `0x4fcef0`, `fclose` (`0x50cee4`), and the field clears; always returns 1 after the `0x4f709c` guard.

## Dropped (1 of 12)

- **0x4fc62d** (475 bytes): not creditable. At 0x4fc722 the function stores `mov dword ptr [ebp+0x10], 1` and the following `switch` (`cmp [ebp-0x118],1 / je`; `cmp 2 / je`; `jmp default`) therefore always takes the first arm. The instructions 0x4fc73b..0x4fc745 (the second compare and the jump to the default arm) and the whole default arm 0x4fc79a..0x4fc7e6 (the fatal report, `[0x63a58a] = 5`, `0x4c97b4`) sit behind this always-true guard and no legal fixture can reach them. Owner ruling: unreachable blocks behind always-true guards stay pending. No port was written.

## Files

- `src/original_methods_fl28a.h`, `src/original_methods_fl28a.c`.
- `tests/fl28a_direct_test.c`, `tests/test_fl28a_direct.py`: hand-derived direct tests (also run under ASan/UBSan) and a bounded sweep.
- `tests/fl28a_fixtures.py`, `tests/fl28a_differential_shim.c`, `tests/test_fl28a_differential.py`: Unicorn differential (original bytes against the native symbol on the same generated fixtures; ordered host calls with arguments, bytes behind probed memory, the memory of every area and the debug word are compared).
- `tests/fl28a_original_oracle.py`: coverage oracle (original bytes only, no native library); `tests/fl28a_mutation_check.py`; `tasks/fl28a-acceptances.json`.

## Commands (from `outputs/blackmoor-decomp`, after `export PATH=/tmp/claude-0/shim:$PATH`)

- Direct and differential, slice tests only: `python3 -m unittest tests.test_fl28a_direct tests.test_fl28a_differential` -> 24 tests, OK (11 direct cases, the run-all check, the sweep; 11 differential and the constants check).
- Oracle: `python3 tests/fl28a_original_oracle.py` (eleven lines as in the table, exit 0); also `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl28a_original_oracle.py` (same lines, exit 0, trace files written).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl28a_direct_test.c src/original_methods_fl28a.c -lm` -> all 12 cases PASS (11 functions + the bounded sweep of 300 scenarios), no report.
- Mutation: `python3 tests/fl28a_mutation_check.py [--only <va key>]`; the four review mutants: `python3 tests/fl28a_hand_mutants.py`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run); they pop their arguments (cdecl / stdcall / thiscall cleanup as in the original), return a scripted `eax`, and where a scenario needs it store scripted bytes or dwords at their n-th call. Listed per function:

- 0x4fc808: 0x50ca3e (3 args), 0x44a2b7, 0x4f356e (batch function, host stub, not bound to the port).
- 0x4237f7, 0x4236d6: 0x51dc43, 0x50ca3e (2 args), 0x52139c, 0x44a2b7, 0x4c97b4. The stub of 0x4c97b4 is a halting stub: it stops the run (the process exit: the original does not return from it). The fatal scenarios therefore end at the call.
- 0x4f80d3: the vtable entries 0x7e000900 (entry +0x30) and 0x7e000a00 (entry +0x50) read from the object's vtable.
- 0x42356d: 0x50ca3e (2 args), 0x52139c, 0x44a2b7, 0x4c97b4 (halting).
- 0x4fb2e3: 0x50ca3e (3 args, then 4 args on the second call), 0x44a2b7, 0x4f6059, 0x4fa2a8.
- 0x423368: 0x50cb1b (`atoi`-like), 0x50d6cf (character class).
- 0x423142: 0x423368 (batch function, host stub), 0x51dc43 (twice), 0x423000. OS/CPU boundary: the thread information block behind `fs` (a GDT entry, selector 0x18, base 0x7d000000, `[0]` = a random chain head); the oracle asserts the chain at `fs:[0]` is restored on every return. Not hooked: the frame handler 0x5273db (it never runs: no callee throws). A mapped page at address 0 (an OS-level fixture region) lets the null-pointer paths run to the end like the original would with memory there.
- 0x4fadc4: 0x50ca3e (4 args, then 5), 0x44a2b7, 0x4f379c, 0x4fa2a8, 0x52139c. OS/CPU boundary: the x87 control word is set to 0x27f (the Windows process default). `__ftol` (0x50ce04) is NOT hooked: its original bytes run inside the oracle on the real FPU stack.
- 0x4f356e: 0x4f709c, 0x4f6334, 0x4f61e7, 0x51dc6c, 0x4fcef0, 0x50cee4 and the Release entry (0x7e000b00, vtable entry +8).
- The debug word 0x63a4cd is patched into the image per scenario; the two bytes behind it are random compared-out neighbours.

Which callees are batch functions (all host-stubbed, none bound to the ports): 0x4f356e is called by 0x4fc808; 0x423368 is called by 0x423142. The integration step decides whether the host binds them to `m4f356e_unload` / `m423368_hash_name`; the host contract (flush the world before and resync after each call) is in the header.

## Deliberate divergences and native rejections (not original behaviour)

- Fatal paths (0x4237f7, 0x4236d6, 0x42356d): the original calls `0x4c97b4`, which ends the process; the port makes the same calls in the same order and then returns (0 / nothing). Where the original would continue (0x42356d would store out of range, 0x4237f7 / 0x4236d6 would loop between 0x42386f and 0x42383f) the port stops. The oracle halts at the call.
- 0x423142 rejections (return 0 after the effects that precede them): `resolve` gives NULL for an address the original reads or writes through (it would fault), the name needs more than 0x25 bytes (the original overruns the 0x29-byte node), the chain has more than 0x100000 nodes (a cycle). The valid paths including null `r` / `buf` with memory at address 0 are original behaviour and are compared. The exception frame (`fs:[0]`, trylevel stores) is not modelled; the oracle checks the chain is restored.
- 0x4fadc4: `__ftol` is inlined as "truncate toward zero, keep the low dword of the 64-bit result, NaN and out-of-range give 0" (same function as in FL-27c). The name copy is unbounded in the original (caller-validated). The float constants 2857.142822265625f (0x52e4e0) and -2857.142857142857 (0x52e4d8) are embedded in the port as their bit patterns.
- 0x423368: the string is scanned for its length without a bound (the original is the same, `repne scasb`); lengths above 0x7fff behave as the 16-bit counters do (tested at 0x8000, 0x10000, 0x10005).
- 0x4235fd / 0x42356d: the returned / computed addresses are host pointers computed in 32-bit arithmetic; a count that wraps gives a pointer that is returned but not dereferenced by the port.
- Callees that change `self` or a global the function re-reads are not exercised except where stated: 0x4f356e re-reads the record after the callees (fixtures script a callee clearing `[rec+0x28f]`); 0x4fb2e3 and 0x4fc808 re-read the debug word, which no stub changes.

## Notes for root

- `function-evidence.json`, `function-execution.json` and `function-ledger.json` are untouched; root must regenerate them (and the ledger) for the new oracle runs and merge `tasks/fl28a-acceptances.json` into `function-ledger-overrides.json`.
- Review status: no independent review of the first commits was done by me; the later review found no P1 and its fixes are in the last commit (see Mutation check). Acceptance `reviewer` fields should be updated by root after collection.
- RT-14 (blocker of 0x4fb2e3) is the weakest rationale: the function executes no sound provider, the item is about the missing provider in the native app. The rationale now says exactly what the oracle reaches (the debug traces, the stubbed answers of `0x4f6059` and `0x4fa2a8`, the word store) and that the provider stays open.
- 0x4fadc4 depends on the x87 control word being 0x27f (53-bit precision, round to nearest) at entry, the Windows process default. The oracle sets it; the port computes in IEEE double and does not read or set it. Under 0x37f (64-bit precision) the original could round differently in the products; the fixtures do not discriminate the two (tried once by hand in FL-27c, not repeated here).
- The `rep movs` copy of 0x4fadc4 is reproduced as dwords then bytes, forward, with each dword read before it is written; a direct case with the name two bytes before the destination checks this overlap behaviour (hand-derived, not run on the original).
- All host calls in the ports go through the NULL-guarded helpers (`vcall`, `release_field` and the five-argument call use `callv`), as the header contract says.

## Unverified

- Import / callee names and the meaning of the callees are not claimed: only the call shapes (argument count, `this`, cleanup) and the order are verified. `0x50cb1b` / `0x50d6cf` are named by their use (conversion, character class), `0x4c97b4` by the import it reaches (the process exit).
- The vtable entries of 0x4f80d3 and 0x4f356e are called with the shapes seen in the disassembly (stdcall, object as first argument); which COM methods they are is not claimed (0x88780096 looks like a lost-buffer status, `+8` like Release, `+0x50` like Restore).
- x87 precision: the oracle runs with 0x27f and the port uses IEEE doubles; the intermediate magnitudes of 0x4fadc4 (products of up to three floats) cannot leave the double range, so exponent-range differences cannot occur.
- 0x423368: the `jne 0x423437` at 0x42342a is never taken (the word is zero there; the target runs through 0x4233be): allowlisted in `fl28a_fixtures.UNTAKEN_ALLOWED`.
- No independent review; no claim that FL-28 or any action family is complete.

## Mutation check

`python3 tests/fl28a_mutation_check.py` (full run on the final source): 296 single-edit mutants (hex and decimal literal +1, `==`/`!=` swap, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32` width swap, one integer or floating cast removed), 238 caught by the direct test, 12 more only by the Unicorn differential, 46 survivors. All 46 were read and are equivalent or native-only. History: an earlier run (212 mutants, before the decimal and cast kinds existed) had 20 survivors, nine of them fixture gaps that were closed (object pointers of 0x4f356e at addresses with a zero low half, at +0x41 and at 0x24; unresolvable-address cases of 0x423142; the constants test of 0x4fadc4). The review then found four mutants that test a 32-bit callee answer through its low 16 bits; the fixtures now answer 0x10000 and 0x80000000 (0x4fb2e3: `0x4f6059`; 0x4f356e: `0x4f709c`, `0x4f6334`) and 0x96 / 0x12340096 as the first answer of 0x4f80d3, and `python3 tests/fl28a_hand_mutants.py` shows all four die (caught by the Unicorn differential; the hand-derived direct test does not use those values).

Survivors by reason:

- Casts that change nothing on an LP64 host: `(ptrdiff_t)` and `(uintptr_t)` on offsets that are already 32-bit values, `(int16_t)` on assignments to `int16_t` variables, `(double)` on floats that promote anyway, `(uint32_t)` on `strlen` and on `uint32_t` arithmetic, `(int32_t)` / `(uint32_t)` on a non-negative index (lines 101, 115, 153, 190, 191, 210, 230 to 239, 332, 335 to 337, 346, 357, 390, 404, 411).
- `(uint32_t)(int64_t)value` of `ftol_low_dword` (line 314: removing either cast): the conversion of a negative double to `uint32_t` is undefined in C and happens to give the same low dword on x86-64; the cast chain is what makes it defined elsewhere. A host-dependent equivalence, as in FL-27c.
- Array dimensions and index literals: 0x4f80d3 `args[4]`, `one[1]`, and `args[1] = 0; args[2] = 0;` (re-stores zeros the array already holds), 0x4f356e `args[1]`, 0x4fadc4 `args[5]`.
- 0x4f356e line 278 (three: `0x166` +1, `==`/`!=` swap, `rd32` -> `rd16`): both arms of the test of `[rec + 0x166]` make the identical call to 0x51dc6c in the original, so the condition has no observable effect.
- 0x4fadc4 lines 312 and 313 (four: the NaN guard deleted, the range guard deleted, the two boundary moves at exactly +-2^63): the guards are required for a saturating float-to-int conversion (ARM64) and are equivalent to the x86 conversion on this host (the indefinite value has a zero low dword); +-2^63 are unreachable by the fixtures. Line 329 (last mantissa bit of the double constant -2857.142857142857): a one-ulp change flips the truncation only for a result within 4.5e-13 of an integer, which no fixture produces; the constant is compared with the bytes of the original in `test_embedded_constants_match_the_original`. Line 332 (`rd16` -> `rd32` of the table index): the `int16_t` cast that follows discards the upper half.
- 0x423142 lines 383 and 395 (the chain-length limit +1 and `>` -> `>=`): the limit of the native-only cycle rejection; the fixture is a cycle, which stops at the limit either way.

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand and double edits are not modelled (the same list as in the FL-26 / FL-27 handoffs).

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; a host binding must say which side translates addresses: stack-argument pointers to the records (`self`, locals) are host pointers, addresses stored inside the records (`[self+0x3ce]`, `[rec+0x293]`, node chains, the strings) are original addresses that `resolve` turns into memory.
- Bind 0x4f356e and 0x423368 to their `m<va>_*` symbols (or the real code) in the host when wiring 0x4fc808 / 0x423142.
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Hashes

GAME.EXE `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`. Window hashes: see the table. Source and test hashes (sha256, at the last port commit):

| file | sha256 |
|---|---|
| src/original_methods_fl28a.c | 1438b3860ebd9ded6380cea1f897558edb00051a8b142f51b66c7b96878a7789 |
| src/original_methods_fl28a.h | c38460cc09cdfcf8e2eca6a4c7436f234ca36739bfccc61fc02b5d10701eb090 |
| tests/fl28a_original_oracle.py | 8b8f117cc531b314dda906d6d227d986f0fb2c69e181a1e3f60aeaac299d73a0 |
| tests/fl28a_fixtures.py | 54894bd58cb727e526c41145563924a19509935a07160c2088778964724d24d4 |
| tests/fl28a_direct_test.c | fa070ed95b200965285c5d1b1faf61399e3d6449b371fcc66914f99435fb906b |
| tests/fl28a_differential_shim.c | 01c3bfbe6d964894c475c795c18d7663b4976553d6fcf9f66290fb57d6f9b71a |
| tests/test_fl28a_differential.py | 281b1371c24076d2ae090c20ea008930aa1c01d35ecc8da0c6b80ef61e784d04 |
| tests/test_fl28a_direct.py | ca612cb3c1d6c00462725abc92718dec20a6ece46b4601303e393a296162db77 |
| tests/fl28a_mutation_check.py | a2bc6e305ef55d7464bb146929dee9bcd4232a6da62d7edec5eb6a1be12385d8 |
| tests/fl28a_hand_mutants.py | 2f0377b1c3e4310d87f00c2edd9f659ec7bb6dbe8ccbd6bb2048759a5c5e5773 |

Native library: the differential builds `tests/fl28a_differential_shim.c` + `src/original_methods_fl28a.c` into a throwaway shared object per run (no committed binary).

## Branch and commit

Branch `fl28a`; port commits `e0b9e53` (eight functions plus the infrastructure), `38d25fd` (0x4f356e), `ff063fa` (0x4fadc4), `f8ea804` (0x423142); the final commit adds this handoff and the acceptances (see git log).
