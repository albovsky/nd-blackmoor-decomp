# FL-26 batch b (fl26b) handoff

Branch `worktree-agent-a0bfa476d2d9578f2`, based on `97fe35d8` (FL-26 packet, branch `claude/project-thread-cmhyad`; the worktree had been created from an older `main` and was reset onto that commit before any work). Implementer: Claude Sonnet. No independent review has been done; the acceptance entries say so.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (unmodified, read only).

## Ported (6 of 7)

All in `src/original_methods_fl26b.c` / `.h`. Conventions as FL-25: `Fl18Host` (`call`, `resolve`), world scalars and table pointers in `Fl26bWorld`. Pointers that objects and arguments keep are original addresses, resolved through `Fl18Host.resolve` (the const is cast away where the original writes).

| va | span | symbol | what |
|---|---|---|---|
| 0x423fbb | 62 | m423fbb_leaf_word | ret 4; leaf pointer [+0x1c]: zero -> [+0x20] = 0, returns -1; else [+0x20] = [leaf+0x40], returns the signed word [leaf+0x12] |
| 0x4eb107 | 125 | m4eb107_item_use_feedback | ret 4; item = signed word 0x583a29 compared as a dword with the argument; word at self + item*0x16d + 0x77e: 0 -> item = -1; 2 -> 0x4e9e84(self; ecx, 1) then item = -1; always 0x4d36ed. The pushed ecx is exact: item*0x16d with its low word replaced by the item (checked up to item 359, where the upper half is 1) |
| 0x42406d | 404 | m42406d_propagate | ret 4; flag [+4] propagation along the [+0x38] chain and the [+0x34] link, restart while a pass set a flag, count compared with [node+0x18], [node] and [[node+0xc]+4] set to 1 or 0 |
| 0x424201 | 325 | m424201_walk | ret 4; node walk, kinds 2 and 1, recursion and 0x4235fd answers, error path (0x50ca3e, 0x52139c, 0x44a2b7 on the signed word 0x63a4cd, 0x4c97b4 with this = 0x5cf659) |
| 0x42ea87 | 717 | m42ea87_record_state | cdecl, plain ret; record state machine (states 0, 1 share the list scan, state 2 the table stores and 0x42ba3a(index word), other states nothing) |
| 0x4eb184 | 1134 | m4eb184_use_feedback | ret 4; random row choice (0x50cd50), busy gate 0x4f6334, text announcement 0x4fb77a, translation 0x423259, display 0x448d11, final 0x4fb2e3 |

Acceptance entries: `tasks/fl26b-acceptances.json`, 6 entries, class `native_oracle_verified`, window = start to start + span. Blockers reviewed (id + rationale, after reading the located item and the disassembly): 0x423fbb `RT-4:f6ab4e757efaab2f`, 0x4eb107 and 0x4eb184 `RT-6:8b3f2cfb116d111c` (separate rationales), 0x424201 `A-2E.1:6cca21030ace49fd`. 0x4eb107 and 0x4eb184 also carry the divergence `RT-4:c5bf56d1da125e1b` (the accept-click candidate check does not model the item-use feedback calls): it is a divergence, not a blocker; these ports are the feedback calls themselves, the accept-click code that calls them stays outside.

## Dropped, with reason

- 0x424346 (1,890 bytes): not attempted. It is the largest row and the packet names it the most likely drop; the budget (about 120 tool calls) went into the other six. Returned to the pool unchanged; no claim file or partial code exists for it. Note for whoever takes it: 0x424201 calls it with (this = self, p) and the port stubs it as a host call; its disassembly begins `push ebp; mov ebp,esp; sub esp,0x3c`.

## Verification

Run from `outputs/blackmoor-decomp` with `export PATH=/tmp/claude-0/shim:$PATH` (xcrun wrapper of this environment).

- Slice tests: `python3 -m unittest tests.test_fl26b_direct tests.test_fl26b_differential` -> 8 direct tests (6 functions + `test_sweep_bounded` + the run-all check) and 7 differential tests (6 functions + one that shows the two rejected endless loops are real in the original), all OK.
- Original-bytes-only oracle: `python3 tests/fl26b_original_oracle.py` (exit 0). It prints one line per function (instructions executed/total, conditional-jump directions taken/total, scenarios, digest):

| va | instr | branch directions | scenarios | digest |
|---|---|---|---|---|
| 0x423fbb | 22/22 | 2/2 | 100 | 0bd7f9c8d099d00ae96d804b6846ceb4a7c6b0f59829d8acd5824124a185e9a5 |
| 0x4eb107 | 31/31 | 6/6 | 224 | e8c96836da9bf2dfbf68bc3355b99e18f405fa1c8793b0cd32d781ad36b04cc1 |
| 0x42406d | 125/125 | 36/36 | 600 | ca0c20da7842ccd34e8bb8fa2629627b5fd352a04a1690da50f8ced6ae2f0783 |
| 0x424201 | 98/98 | 13/14 | 324 | c06977de9f4c344fc79c1d394814d13c9e2ba803ea1251902e17aaa1e8bde6ee |
| 0x42ea87 | 163/163 | 22/22 | 552 | df2d1cff3786529c897636af0bd1f015de5b0a62c27fc7fe4580ab55f8f5fad3 |
| 0x4eb184 | 329/329 | 36/36 | 480 | 41057125b0b30bd3b2e102d6b58a82bb5ae3059cc4bc7d834ff654d37e5e0ea7 |

  The one untaken direction is `jne 0x424305` at 0x424271 in 0x424201 (allowlisted in `fl26b_fixtures.UNTAKEN_ALLOWED`): it is taken on a node whose kind is neither 2 nor 1 and loops back to 0x42421a with p, done and the node unchanged, so the original never returns from it. `Fl26bDifferential.test_unsafe_loops_never_return_in_the_original` runs the original bytes on such a fixture (and on a cycle of the [+0x38] chain of 0x42406d) and requires the instruction limit to be hit. The Unicorn differential requires the same instruction and direction coverage as the oracle for every function and compares the whole memory, the globals, the return value, the bytes popped, and the ordered calls with the call-time state of the object windows.
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl26b_direct_test.c src/original_methods_fl26b.c`: all 7 cases PASS (6 functions + bounded random sweep of 3000 rounds, including malformed inputs: unresolved addresses, unknown kinds, chain cycles, overlong strings), no report. (clang here has no ASan runtime.)
- Mutation (`python3 tests/fl26b_mutation_check.py`, full run): 222 mutants, 193 caught by the direct test, 17 more only by the Unicorn differential, 12 survivors (line numbers of `src/original_methods_fl26b.c`), all equivalent by reading:
  143 and 145 (`rds16` -> `rd16` in `== 0` / `== 2`: the same result for either reading), 146 (`0xffff0000` -> `0xffff0001`: 0x16d is odd, so bit 0 of the product equals bit 0 of the item that replaces the low word), 166 and 236 (`>` -> `>=` on the 0x100000 pass limit: only the exact limit pass moves), 173, 184 and 292 (`g16s` -> `g16` where the word is compared with 1 or cast with `(int16_t)` straight after), 311 to 314 (`g16` -> `g16s` feeding `wr16`, which truncates to 16 bits).
  Six survivors of the first run were closed by new cases: 216 and 219 (0x42406d, `g32` -> `g16` on the aux pointer test: the fixtures now put the aux object at a place whose address has a zero low word, 0x20020000), 240 (0x424201, kind read as a word: direct cases with the kinds 0x10002, 0x10001, 0x80000002, which the original does not accept either, and the differential test requires the original to hit the instruction limit on them), 237 (0x424201, the pass-limit rejection: a kind-2 node whose next is itself, direct test; the differential test requires the original to hit the limit on it), 342 (0x4eb184, structure size: direct cases with a string of 0x33 characters, accepted, and 0x34, rejected), 431 (0x4eb184, the unresolved translation on the flag-byte-0 arm: direct case). Earlier the `0x16d` -> `0x16e` survivor of 0x4eb107 was killed by item 359.
  Known gap of the tool: mutants are single textual edits (one literal, one operator, one one-line `if (...) return;` guard, one width); multi-line guard deletion, `if (1)`, a dropped `||` operand and double edits are not modelled.

## Hooks (Unicorn differential and oracle)

Only host boundaries are stubbed (recording stubs by entry address; they pop their arguments and return scripted `eax`): 0x4e9e84, 0x4d36ed, 0x424346, 0x42406d, 0x42356d, 0x424201 (the recursive call: the stub at the function's own entry is skipped for the outermost entry only, `Original20._stub_hook` in `tests/fl26b_fixtures.py`), 0x4235fd, 0x50ca3e, 0x52139c (stdcall, pops 12), 0x44a2b7, 0x4c97b4, 0x42ba3a, 0x50cd50, 0x4f6334, 0x4fb77a, 0x423259, 0x448d11 (pops 0x10), 0x4fb2e3. No decision of a function under test is replaced. Call logs include the pointer-argument bytes where the callee reads them (0x4fb77a: the 0x34-byte structure; 0x448d11: the 0x3c-byte buffer).

## Divergences and unverified branches

- Native rejections (no counterpart in the original, `int32_t *reject`, tested in the direct test and the sweep; the original has no such branch): `FL26B_REJECT_UNRESOLVED` (an address that `Fl18Host.resolve` cannot resolve, including a zero head pointer); `FL26B_REJECT_ENDLESS` (0x424201: a node of kind other than 1 and 2, which the original loops on forever; 0x42406d: a chain cycle, stopped after 0x100000 passes); `FL26B_REJECT_OVERRUN` (0x4eb184: a string that does not fit the original's 60-byte buffer or 52-byte structure, or an append that does not fit; the original would write over its own locals).
- 0x4eb184, a deliberate narrowing: a translated text of exactly 0x3c characters passes the original's `ja` guard and overruns the 60-byte buffer by one byte (into a dead local); the port rejects it as an overrun instead of reproducing the byte write. A record text of 0x39..0x3b characters is copied by the original and its dword append then overruns; the port rejects at the append.
- 0x4eb184: locals (buffer, structure) are zero-initialised natively; the original's are stack garbage. The fixtures never read bytes beyond the NUL; the harness maps the stack fill 0x71 of the original to 0 when it compares the pointer-argument bytes (fixture strings contain no 0x71).
- A callee that changes `self`, a node, the record table or a global that the function re-reads is not exercised (callees are stubs). The recursion of 0x424201 goes through `Fl18Host.call` (0x424201), not a direct native call.
- 0x42ea87: the index word is used as a signed word; indices -1..4 are exercised. The table at 0x585801 is indexed by a signed word (stores below the pointer are exercised down to -8).
- 0x4eb107 and 0x4eb184: the accept-click code that calls them, and the callees, are outside this slice (blockers `RT-6:8b3f2cfb116d111c`, divergence `RT-4:c5bf56d1da125e1b`).
- Fixture limits: 0x4eb184 uses record indices 0..3 and strings of at most 0x38 characters; 0x4eb107 items -5..359 (the self buffer is 0x40000 bytes).
- Integration note (P3): in 0x4eb184 the arguments of 0x4fb77a (a host pointer to the local structure on one arm, an original address on the other), 0x423259 (a host pointer into `self`) and 0x448d11 (a host pointer to the buffer) mix host pointers and original addresses, as in FL-25; the host adapter must say which side translates.
- No independent review; no claim that the batch or FL-26 is complete.

## Hashes

Code windows (sha256 of the original bytes, va to va + span):

| va | span | sha256 |
|---|---|---|
| 0x423fbb | 62 | eb8d7af48e1956312150518fd2a9baaad3c21b5ca69678ac4b18e875e04e78f8 |
| 0x4eb107 | 125 | a5aab32286035918e586e32b4e828757ad67295856d835e72c28011cc64eed5f |
| 0x42406d | 404 | 9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07 |
| 0x424201 | 325 | b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394 |
| 0x42ea87 | 717 | 74b38c90c9d5fe73789787cc53eea5f40094e33abac5cae243cb69da9b7b0b20 |
| 0x4eb184 | 1134 | 9697ef900ada7709606181748cb34899040fc5e8a7802c6cf8eb432318d20187 |

All six windows are pure code (no data inside). Port sha256: `src/original_methods_fl26b.c` a9098b565a3c1c06b198b1768eeb748a97fdfa2c459b277f46ab996a49238585, `src/original_methods_fl26b.h` 495d61f8b5b17a82415ece9848a91276eb0dd37b821ec89aa01592a00b06d910; fixtures `tests/fl26b_fixtures.py` see git (changed by the survivor closing).

## Last commit

see git log
