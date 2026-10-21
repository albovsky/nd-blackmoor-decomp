# FL-36a handoff (implementer: Claude Sonnet FL-36a; reviewer string for the acceptances: Sonnet slice-reviewer, diff review, no P1 (FL-36); the review itself is root's to arrange, nothing was reviewed independently here)

Branch `worktree-agent-a5543413e22c3f586` (base 425d4bad, the FL-33 merge). Packet: `tasks/FL-33-pending-rows-4c-47d.md` (rules unchanged, `fl33<x>` read as `fl36a`, world `Fl36aWorld`). Both rows of the batch are ported; none dropped. Nothing here claims the parent slice or the game complete.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, unchanged).

## Ported rows

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4f379c | 1162 | m4f379c_open_entry | 297/297 | 44/44 | 184 | 3b2b930f79a3b863a9e9938dd7d7836c0f473bb32e9e5a185470c87116e2d61d | 73cf0d320d97645da5ea86ba7b25c8cb763ccf26fb4b42afbf075c04f982af59 |
| 0x4c36b2 | 1451 | m4c36b2_save_region | 314/314 | 37/38 (one edge flagged, see below) | 372 | 2786f6ffa7487986cf4fbe87ac5d64cdfd5903c40438c7f2fb75ae0a697605df | 3be3810a997ed70ad255cbc074570cf923de2644215f7569375f44d51619cdf1 |

Windows end exclusive: `[0x4f379c, 0x4f3c26)` and `[0x4c36b2, 0x4c3c5d)`. Acceptances: `tasks/fl36a-acceptances.json` (class `native_oracle_verified`, reviewer string `Sonnet slice-reviewer, diff review, no P1 (FL-36)`, date 2026-10-21; notes 217 and 226 characters). Each function has the comment `/* 0x<va> m<va>_<name> */` directly above it in `src/original_methods_fl36a.c`.

## The flagged untaken edge (0x4c36b2)

`UNTAKEN_ALLOWED['4c36b2'] = {(0x4c3baa, 'taken'): reason}` in `tests/fl36a_fixtures.py`; the oracle prints 37/38 and exits 0, the differential and the oracle fail if the edge ever becomes taken (stale-entry check). Disassembly reason: at 0x4c3b1b `fp = 0x50d0a9(...)` is stored at `[ebp-0xa4]`, `cmp [ebp-0xa4],0; jne 0x4c3b2f` (0x4c3b21/0x4c3b28) sends fp == 0 away via `jmp 0x4c3c46`; the only way to 0x4c3ba3 is through 0x4c3b2f, so `cmp [ebp-0xa4],0; je 0x4c3bbb` at 0x4c3ba3/0x4c3baa sees the same non-zero local again. Between them nothing writes that local (the three callees between get pointers to the header local at `[ebp-0x9c]` with 0x12 bytes and to heap buffers; none reaches `[ebp-0xa4]`). Not a case for the "unreachable block" drop rule: the block behind the `je` (0x4c3bac..0x4c3bb8, push fp; call 0x50cee4; add esp,4) is the fall-through and always runs (314/314 instructions executed); only the skip edge to 0x4c3bbb from this site is dead (0x4c3bbb is reached by 4 other jumps). I did not take the edge by making a stub scribble on the caller's frame. The native port calls 0x50cee4 whenever fp != 0, i.e. always on that path.

## Dropped rows

None. (The 0x4c36b2 `je` at 0x4c3baa was checked first as the brief asked: it guards no unreachable code, see above.)

## Hooks (all stand in for callees or host boundaries; none replaces a decision of the function itself)

Stubs are entered by address in the Unicorn oracle; they pop their arguments (cdecl: none; thiscall/stdcall callee-pop as the original), record the call (callee, ecx, stack arguments, a byte probe of self/objects/globals at the call, and the 0x12 or 0x20 bytes behind a pointer to a local where noted) and return a scripted eax; scripted stores through a pointer argument model callees that fill a buffer. The native side uses the same scripts through `Fl18Host.call`.

- 0x4f379c: 0x4f356e (thiscall, 1), 0x50d0a9 (cdecl, 2), 0x50cf61 (cdecl, 4), 0x50ca3e (cdecl, variadic: stub reads 5 words, see below; 32 bytes behind the frame-area pointer logged), 0x52139c (stdcall, 3), 0x44a2b7 (cdecl, 1), 0x4f438f and 0x4f3c26 (thiscall, 1; the result and an optional store to `[self+0x3be]` are scripted).
- 0x4c36b2: 0x4d36ed (thiscall with ecx = the object, 0 stack args), 0x42ba3a (cdecl, 1), 0x51dc43 (cdecl, 1; two scripted results = the two buffers, or 0), 0x44a2b7, 0x4c4067 (thiscall, 5; stores two dwords through the desc pointer), 0x43f04b (thiscall, this 0x5d2f2d, 5), 0x4c4202 (thiscall, 3), 0x4c334f (thiscall, 4), 0x50cd72 (cdecl, 5), 0x50d0a9, 0x50e493 (cdecl, 4; the 0x12-byte header local is logged at the first call), 0x4c7481 (thiscall, 2), 0x50cee4 (cdecl, 1), 0x51dc6c (cdecl, 1).
- Arity of 0x50ca3e in 0x4f379c (hazard from the FL-33c handoff): the function calls it with 3 (0x4f3af5), 5 (0x4f3b8c) and 4 (0x4f3beb) arguments. The oracle stub (`CDECL(5)`) reads 5 stack words at every site; `fl36a_fixtures.ARITY_BY_SITE` (keyed by the return address 0x4f3afa / 0x4f3b91 / 0x4f3bf0, remembered by `Original36a._stub_hook`) drops the words behind the real arity of the site before the log is compared, so the extra words (caller stack garbage) never reach the comparison. The native side logs exactly the arguments it passes.
- WORD_ARGS `{0x4f438f: (0,), 0x4f3c26: (0,)}`: the original pushes the id with `mov cx/ax, word [ebp+8]; push ecx/eax` (stale upper half); both sides compare the low 16 bits. The id pushed to 0x4f356e and 0x50ca3e is `and 0xffff` (zero extended) and compared whole.
- The word 0x63aa14 is `Fl36aWorld.word_63aa14` (patched into the image for the oracle); the debug word 0x63a4cd is `word_63a4cd`. 0x4c36b2 also uses `word_63988b`, `word_63988d`, `word_639895`, `byte_639893` and `value_5839a9` (dword written 1 / 0).
- Data read through `Fl18Host.resolve` in the native code: the magic at 0x55dab4, the string at 0x55dafc (both patched into the image by the fixtures; their real content is `HIS\0` and ` compressed\0`), the record table at 0x5bb5e5 (+ index * 0x8d, patched for indexes -1..2).

## Deliberate divergences and native rejections

- 0x4f379c, `m4f379c_open_entry(self, id, uint32_t *result, world, host)` returns an int status and stores the eax at `*result`. Status 1 (documented in the header): the NUL-terminated string at 0x55dafc is copied into the 0x24-byte frame area at `[ebp-0x24]` (the 0x20 bytes of the local plus the 4-byte temporary below it); a string of 0x24 bytes or more including its NUL would run over the saved ebp and return address of the original (undefined), so the port returns 1 at that point (everything before has happened, `*result` unset). Tested directly (`test_m4f379c_open_entry`: 35 characters fits, 36 are rejected; calls and entry untouched except the effects before the copy). Not run through the original: the Unicorn scenarios use strings of 0..35 characters only (35 + NUL fills the temporary exactly, and does run in the original). In the real game the string is 11 characters.
- 0x4c36b2, `m4c36b2_save_region(self, index, world, host)` returns status 0 or 1 (no value; the original's eax at return is not meaningful). Status 1: when the first allocation 0x51dc43 returns 0 the original reports (0x44a2b7(0x554120) if the debug word is set), jumps to the cleanup and tests `[ebp-0xb8]` (the second buffer) BEFORE it was initialised (`mov [ebp-0xb8],0` is at 0x4c37de, later), then calls 0x51dc6c on that stack garbage if it is non-zero, sets 0x5839a9 = 0 and the state to 3. The port stops after the report (status 1, state 2 and the global unchanged). The Unicorn oracle still runs this path (stack filled with 0x71, so the original calls free(0x71717171)); this is needed for 0x4c3c50/0x4c37d9 to count as executed. The differential checks the port's prefix (1 or 2 calls) and that every byte of every area and every global is unchanged (the `partial` mechanism). A host must not rely on anything after a 1.
- 0x4c36b2: the 0x80-byte `desc` local is uninitialised stack in the original and zero-filled in the port; only the two dwords the callee 0x4c4067 stores (+0x10, +0x24) are read. The dead store `[ebp-4] = bpp * [obj+0x21]` is not ported (nothing reads it).
- 0x4c36b2: the effect order on a 0x4c334f result of 0 is: copy, 0x4c334f, report (debug only), cleanup; same as the original.
- Callee conventions are inferred from the call sites and the stubs, not from the callee bodies. In particular 0x4d36ed is called with ecx = the object pointer and no stack arguments (the stub is thiscall(0) and logs ecx).

## Unverified branches and assumptions

- Callees that change `self`, the object, the record or the globals the function reads again afterwards are only exercised where scripted: 0x4f438f / 0x4f3c26 may store `[self+0x3be]` (scripted in the fixtures for 0x4f379c, the return value is the re-read dword), nothing else.
- Negative `w2` with non-zero `bpp` (x1 < x0) makes the original rep-copy a huge count; not run. With bpp zero or h2 <= 0 such geometries run and are covered (`R_GEOMS` entries with h2 < 0, H < 0, w2 == W with x0 < 0, h2 == H with y0 < 0).
- `rec` index range: the record table area covers the indexes -1..2 in the fixtures; the port computes `0x5bb5e5 + idx * 0x8d` for any signed word.

## Mutation results

- Mechanical (`tests/fl36a_mutation_check.py --only 4f379c` and `--only 4c36b2`): 0x4f379c 132 mutants, 126 caught (111 by the direct test, 15 by the differential only), 6 survivors, all equivalent: `rd32 -> rd16` of the zero value returned by `fail_4f379c` (line 80); `rds16 -> rd16` at the compares of `[entry+0x10e] != 2` (line 109) and `[entry+0x126] == 2` (line 153); `>` -> `>=` in the three swap guards (swapping equal values changes nothing). 0x4c36b2 88 mutants, 85 caught by the direct test, 3 survivors, all equivalent: deleting `if (count == 0) return;` of `rep_movs`, and the host scratch sizes `desc[0x80]` -> 0x81 and `hdr[0x12]` -> 0x13.
- Hand mutants (`tests/fl36a_hand_mutants.py`): 53 mutants (21 for 0x4f379c, 32 for 0x4c36b2), survivors 0. Two further hand mutants of 0x4f379c were equivalent and are recorded as comments there (`(int32_t)size > 0x56220` vs unsigned after the size < 0 return; `rds16 != 2` vs `rd16 != 2`). Mutants that survived earlier and led to new scenarios: `fp` with a zero low word (0x4f379c, dword compare), `h2 < 0`, `H < 0 with w2 < 0`, `w2 == W with x0 < 0`, `h2 == H with y0 < 0` (0x4c36b2: signed compares and the full-copy test).

## Commands (from `outputs/blackmoor-decomp`)

- Slice tests: `python3 -m unittest tests.test_fl36a_direct tests.test_fl36a_differential` -> 6 tests OK (direct: 2 functions + sweep + all-cases test; differential: 2).
- Oracle: `python3 tests/fl36a_original_oracle.py` (prints the table above, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl36a_direct_test.c src/original_methods_fl36a.c` -> 3 PASS (2 functions + bounded sweep), no report; also builds under `-Wall -Wextra -Wpedantic -Werror -O2` (the direct test does it).
- Mutants: `python3 tests/fl36a_mutation_check.py --only 4f379c`, `--only 4c36b2`, `python3 tests/fl36a_hand_mutants.py`.
- Not run by me (root's): `record_function_execution.py`, `extract_function_evidence.py`, `build_function_ledger.py` (`--write`), the full suite.

## Process notes

No `rm`, no `/dev`, no hearthbot calls, no push. The `work` symlink at the worktree root (untracked) points at `/home/user/nd-blackmoor-decomp/work`. Test-side first bug found by the direct test and fixed: the fixture byte `[obj+0x30]` is the top byte of the dword at `[obj+0x2d]` (it had corrupted `y1`); the neighbours of the byte at `[obj+0x31]` that a wider read would see are now `+0x32` and `+0x33`.

## File hashes (first 16 hex of sha256, at the time of writing)

src/original_methods_fl36a.c 6aee23835f02adb6; src/original_methods_fl36a.h ebc3d9482711ab9b; tests/fl36a_fixtures.py 57ad95376454bad9; tests/fl36a_direct_test.c 2c692c2a21649608; tests/fl36a_differential_shim.c 80c207366b67c04b; tests/fl36a_original_oracle.py 2197525ac97db3c0; tests/fl36a_mutation_check.py ff8ab03b80844de1; tests/test_fl36a_direct.py 27ae5baf322d7e87; tests/test_fl36a_differential.py 0a47670667392ec9; tests/fl36a_hand_mutants.py a6ab8f51d1cf92a2.

Commits: 863b0ef0 (0x4f379c), 5771835c (0x4c36b2), then the commit with this handoff and the acceptances is the branch head.
