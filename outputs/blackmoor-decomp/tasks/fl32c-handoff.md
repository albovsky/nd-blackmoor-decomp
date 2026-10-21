# FL-32 batch c (`fl32c`) handoff

Branch `worktree-agent-a9f0600716e39ef26` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-a9f0600716e39ef26`), based on `df1a427d` (the FL-32 packet commit, fast-forwarded in). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl32c-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 9 entries; none of the nine rows has a receipt blocker, so there is no `blockers_reviewed`); the ledger's own `symbol_area`, `addresses_in` and `test_area` helpers were run on all nine symbols and 27 test ids and accept them.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (9 of 9, none dropped, spill rows not touched)

All in `src/original_methods_fl32c.c` / `.h` (symbols `m<va>_*`, world struct `Fl32cWorld`, host convention `Fl18Host` as in FL-18/26..31). The commit with the code and tests is `bf417eb8`; the acceptances and this file follow in the next commit (final hash in the report). The nine share all test files, so they are one commit rather than nine.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x44e78e | 73 | m44e78e_release_entry | 26/26 | 4/4 | 36 | 972dec55a1626a4cff6c7dd3f67230c2b86064b9378a42f4b53cbb5244d58818 | 85d97ab5863917ec06b3d062e64bd9dc14042884b44d685aabbaaf817bf12abf |
| 0x44e7d7 | 52 | m44e7d7_mark_entry | 18/18 | 4/4 | 48 | 3443616037100946cb0a43288ad06e017f5de010450812a780614339e2bbf9a5 | 6b5a2bf2dfb8c036502aef5af96325116fa3cf63e1415579be25bd228345c96d |
| 0x44e95b | 83 | m44e95b_offset_rect | 27/27 | 0/0 | 66 | 738035e01504f2c3556223a4e38b3a59a56be5b53d11d84097661317998ed721 | 30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57 |
| 0x43edac | 63 | m43edac_default_after_query | 23/23 | 0/0 | 40 | 01aec14e92fe41ef5159db14ffd4950bf4a6d71a080fa58d08549024dffca51c | 31421ae9cbd60c6f57f38d33932dab8ec4db7d404de30dfef11d7529cb270534 |
| 0x43ee69 | 103 (code 101) | m43ee69_filter_message | 34/34 | 8/8 | 81 | 4a51d6fdf84010e75b45800f770f66ea375adcb94a5f739918295e6ac1db5141 | 14d2e067dc35679414cab09b773597a3688b9c7e3359299c7901ce258ea29054 |
| 0x4db090 | 70 | m4db090_normalize_state | 21/21 | 6/6 | 120 | 9ef43a99478d2648e3236e764688a31e01404c32e0834dafeabb95cc36b4874e | ff778fa18523e7938c7ff0a59669c0a59712c43f4d5fdb7c31643255db3a79a3 |
| 0x4de53e | 70 | m4de53e_report | 23/23 | 2/2 | 35 | e0c18fde3ec653505faeda69a031f97c66cec8c1a5c1756529ce0fd818050ba6 | 2bb0c2bf9f3173f97ea279ef02a2e15f78f15e5c84353d7ec2464a6a7c4c80f4 |
| 0x4ea229 | 64 | m4ea229_clear_pending | 19/19 | 2/2 | 30 | c96cbef3a2ea6f11ed2a36befa2567e05c1a776ef3678454a72c23cb4febb7d7 | e2b3ffdabbb13608e8757d15e7f95591857b3ecfc2100b96fc710ee20e54c5c2 |
| 0x4fb2a6 | 61 | m4fb2a6_check_slot | 21/21 | 2/2 | 108 | 1d968b6fd4543d815c22d9b33af9eff67bd6fa9d3c9971f3a24f2af9df06f4ad | 65e719953fa348882d3b1f80d555dfd05b5057802cfeab9ae95630274bdce52d |

No jump direction is allowlisted: `fl32c_fixtures.UNTAKEN_ALLOWED` is empty and every conditional jump of every function is taken both ways (0x44e95b and 0x43edac have no conditional jump). **Untaken jump edges: none.** None of the nine has an unreachable block behind an always-true guard (checked from the disassembly).

0x43ee69: the ledger span is 103 and `body_size` 101; the last two bytes (0x43eece, 0x43eecf) are `int3` padding after the `ret 0xc`. The oracle and differential count instructions over the 101 code bytes (`SPECS['43ee69']['code']`); the acceptance window is `[0x43ee69, 0x43eed0)` (the span), as for every earlier acceptance whose span exceeds its body (for example 0x4cf749: 103 against 99).

Notes per function (the header `original_methods_fl32c.h` gives the byte-level contract of each):

- **0x44e78e** (`ret`): the field `[self+0x20]` is a dword compare (fixtures use 0x10000 and other values with zero low word / byte); `0x4c2dfb` gets `self + 0x20` as a host pointer to the field (compared as `region + 0x20`); the word `[self+0x1c]` is read again after that call, and in one scenario in three the first callee rewrites it (to 0xffff, to 0x1234) through a scripted write, in the oracle as in the native run. `0x4d3992` gets the word zero-extended; the original pushes `edx` whose upper half is the left-over of the `this` pointer, so only the low 16 bits are the argument (differential `WORD_ARGS`). The final callee is `0x44e767` (thiscall, no arguments; it resets the two words and the field `+0x6b`, which is why `0x44e7d7` tests them).
- **0x44e7d7**: the gate is the unaligned dword `[self+0x6b]` (fixtures put non-zero bytes around a zero gate); the index is the signed word `[self+0x1c]`, `-1` skips, `-2` and `-3` are indices; table `0x5d15a5 + i*0x4a` with slack below index 0.
- **0x44e95b** (`ret 8`, ecx unused): the stack arguments are two rectangle pointers (host pointers in the port). The stores are in the original order (`+4`, `+0xc`, `+0`, `+8`) and the source is read again for each, so overlapping rectangles give the original's result: the oracle and the differential run 11 (src, dst) offset pairs inside one buffer: apart, equal, dst at src+4, src+8, src+0xc, src+1 and src at dst+4, +8, +0xc, plus one more apart, with six origin pairs including 0xffffffff, 0x80000000 and equal values. The adds are 32-bit wrapping.
- **0x43edac** (`ret 0xc`): `0x437774(ecx 0x583208, &a8, &ac, &a10)` receives pointers to the three argument slots of the frame themselves; the port passes pointers to a local three-dword array laid out the same way (contiguous, in order), and the log compares the 12 bytes behind the first pointer at the call. In the `rewrite` scenarios the callee writes through all three pointers. Then the original copies `a10, ac, a8` into three locals that nothing reads and returns the result of `0x51ab4b(this)`. `0x51ab4b` is MFC's `CWnd::Default` by shape (it takes the message from the thread state via `0x525b0f`, not from this frame; read from the disassembly). The three stores are therefore dead. The oracle reads the frame back at the `0x51ab4b` entry and requires `this, a10', ac', a8'` (after the callee's writes) in every scenario; the native port keeps them in a `volatile` local array, which nothing can observe (see Unverified).
- **0x43ee69** (`ret 0xc`): `msg == 0x14` -> 1 (before wparam is looked at); `msg == 0x112` and `(wparam & 0xfff0)` in {0xf140, 0xf170} -> 0; anything else forwards `(msg, wparam, lparam)` to `0x51b461` (thiscall, three stack arguments pushed lparam first; the callee returns with `ret 0xc` on its first path) and returns its result. Dword compares (fixtures include 0x10014, 0x10112, 0x80000014 and 0x80000112); the `0xfff0` mask is shown with 0xf14f, 0x1f140, 0x1f171.
- **0x4db090** (`ret 8`): two stack dwords are popped and never read (the oracle checks that 8 bytes are popped; the fixtures put random dwords there). `[0x5c39e5]` is a dword compared with -1 (0xffff and 0x10000 are not -1).
- **0x4de53e**: `0x4ee630(this)` (it returns `[this+0x4ab]`); when non-zero `0x4c5377` gets `(p, dword [0x5cf665], self + 0x981, 0x5b0227, 0x55b8d0)`, `p` last pushed. The global is read after the first call; the stubs never change it in the oracle (a native direct test does: `change_global`).
- **0x4ea229**: `0x4c2dfb(self + 0x699)`, then `[0x5d1717] = 0`, then the signed word `[0x63a4cd]` decides `0x44a2b7(0x55cb10)` (cdecl). The stubs probe `[0x5d1717]` at each call, which proves the store comes after the first call and before the second. The two bytes behind the word hold random data in the oracle (a dword read of the debug word would see them).
- **0x4fb2a6** (`ret 8`): `idx = (b & 0xffff) * 0x5bb`; the word at `self + idx + 0x132` decides; the call gets `a` and the pushed `eax`, which is `idx` with its low word replaced by `b`'s low word. That is fully determined by the inputs, so the port passes it exactly (including the upper half: `b = 0x2d` gives `0x1002d`), no "word argument" convention is needed. Fixtures use `b` low words 0, 1, 2, 3, 0x2c, 0x2d with garbage in the high half, slot words 0, 1, 0x8000, 0xffff, 0x100, 0xff, and the words of the other candidate slots set the opposite way (an index mistake shows).

## Dropped

None.

## Files

`src/original_methods_fl32c.h`, `src/original_methods_fl32c.c`; `tests/fl32c_direct_test.c`, `tests/test_fl32c_direct.py`; `tests/fl32c_fixtures.py`, `tests/fl32c_differential_shim.c`, `tests/test_fl32c_differential.py`; `tests/fl32c_original_oracle.py`; `tests/fl32c_mutation_check.py`, `tests/fl32c_hand_mutants.py`; `tasks/fl32c-acceptances.json`; this file. `fl32c_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (the Unicorn runner `Original27` with the edge hook, the stub constructor, the call-log normaliser, the conditional-jump finder, `debug_areas`), so the oracle needs that file present (it is on main).

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl32c_direct tests.test_fl32c_differential` -> 20 tests, OK (11 direct: 9 functions, the run-all check and the sweep; 9 differential).
- Oracle: `python3 tests/fl32c_original_oracle.py` (9 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl32c_direct_test.c src/original_methods_fl32c.c -lm` -> 10 PASS (9 functions + the bounded sweep of 300 random scenarios), no report. The sweep keeps indices and pointers inside the fixture buffers (the unbounded inputs are the documented caller-validated ones below).
- Mutation: `python3 tests/fl32c_mutation_check.py [--only <va key>]`, `python3 tests/fl32c_hand_mutants.py`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax` and log ecx, the stack arguments and, where named, probes of fixture memory and globals at the call. Callee shapes taken from the call sites and the callees' `ret` instructions: 0x4c2dfb thiscall(1) (`ret 4`); 0x4d3992 cdecl(1) (`add esp,4` at the call site); 0x44e767 thiscall(0) (`ret`); 0x437774 thiscall(3) (`ret 0xc`); 0x51ab4b thiscall(0) (`ret`); 0x51b461 thiscall(3) (`ret 0xc` on the path the call site needs); 0x4ee630 thiscall(0) (`ret`); 0x4c5377 thiscall(5) (`ret 0x14`); 0x44a2b7 cdecl(1) (`add esp,4` at the call site); 0x4faf98 thiscall(2) (`ret 8`). Scripted writes: 0x4c2dfb (the word `self+0x1c`, for 0x44e78e) and 0x437774 (the three argument slots, for 0x43edac). Globals and tables are patched into the image per scenario (`0x5d15a5` records, `0x583186`, `0x58318a`, `0x5c39e5`, `0x5cf665`, `0x5d1717`, `0x63a4cd`). No Win32 import, no `rep` string move, no x87, no indirect jump in this batch. The oracle checks the number of bytes the function popped on every run (8 for 0x44e95b, 0x4db090 and 0x4fb2a6; 12 for 0x43edac and 0x43ee69; 0 for the rest).

## Deliberate divergences and native rejections (not original behaviour)

- Nothing is bounds checked, as in the original, and nothing here is turned into a rejection: the signed word index of 0x44e7d7 (a word outside the table writes outside it), the slot index of 0x4fb2a6 (`(b & 0xffff) * 0x5bb + 0x132` can reach 96 MB past `self`), and the pointers of 0x44e95b are caller-validated; the fixtures keep them inside their buffers. This is the same stance as FL-31a; if root wants an explicit native rejection for them, it needs a bound that the original does not have, which would be invented behaviour.
- Word argument of 0x4d3992 in 0x44e78e: taken from the low 16 bits (see above). 0x4fb2a6 passes the exact pushed dword.
- 0x43edac: the three dead locals are kept as `volatile` stores, the argument slots as a local array; `this` of the port is `self`, a host pointer.

## Unverified

- Callee calling conventions are read from the call sites and the callees' first `ret` instructions only; callee-pop counts are fixed for the stubs from those. `0x51ab4b` = `CWnd::Default` and `0x51b461` = a `WindowProc` by shape only (hints, not recovered names). The meaning of the fields is a description of what the code does.
- Not exercised: a callee that changes a global the function reads again afterwards through the Unicorn stubs (0x4de53e reads `[0x5cf665]` after `0x4ee630`; the native direct test covers the order, the oracle's stubs cannot write a global); the callee `0x44e767` changing `self` before the return (nothing is read afterwards).
- The dead stores of 0x43edac cannot be observed from the port: the oracle proves them on the original; a mutant that deletes them in the port survives by construction.
- No independent review; no claim that any family or pool is complete.

## Mutation check

`python3 tests/fl32c_mutation_check.py` over the whole file (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap):

```
mutants 75: caught by the direct test 72, by the differential test only 2, survivors 1
  survivor: line 152 (0x4fb2a6) literal 0xffff0000 -> 0xffff0001
```

The one survivor is an equivalent mutant: `idx = (b & 0xffff) * 0x5bb` and 0x5bb is odd, so bit 0 of `idx` equals bit 0 of `b & 0xffff`, and the OR with `b & 0xffff` absorbs it; `(idx & 0xffff0001) | (b & 0xffff)` is the same value for every input.

Hand-written mutants (`python3 tests/fl32c_hand_mutants.py`, all CAUGHT; 26 of 26): the word of 0x44e78e read once before the first call; sign-extended word argument; narrower dword compare of the field gate; `self` instead of `self + 0x20`; 16-bit unsigned table index and byte gate (0x44e7d7); x and y origins swapped, and the order of the stores changed (caught by the differential only for the `+0` / `+8` pair, which the direct overlap case at `dst = src + 8` now also catches) (0x44e95b); wrong return value, reversed pointer arguments and swapped slot copies (0x43edac); 16-bit message compares, a 16-bit command mask and reversed forwarded arguments (0x43ee69); 16-bit selector compare, the final clear dropped, `>=` for `== 1` (0x4db090); the global read before the call and swapped constants (0x4de53e); the store before the call and a byte test of the debug word (0x4ea229); the upper half of the pushed eax dropped, a wider mask on `b`, a byte test of the slot word (0x4fb2a6).

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand, loop-bound expressions and double edits are not modelled (the hand mutants cover the shapes that matter here).

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve` / `tick` (only `call` is used here); `Fl32cWorld.table_5d15a5` must point to host memory that mirrors the record table at 0x5d15a5 with slack for a negative index; the six globals (`0x583186`, `0x58318a`, `0x5c39e5`, `0x5cf665`, `0x5d1717`, `0x63a4cd`) are read and written through the world (the host copies them back to its own storage or points the world at it).
- `m43edac_default_after_query` and `m43ee69_filter_message` return the callee's eax (or 1 / 0); a host that binds the original's `ret 0xc` message handlers calls them with the three stack dwords. `m44e95b_offset_rect` takes host pointers to the two rectangles.
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, at the commit that holds the code)

| file | sha256 |
|---|---|
| src/original_methods_fl32c.c | 689dd9feafa926082fe81f2c5a95ca5a16bdae2acd418647bf56e8e731e3fe12 |
| src/original_methods_fl32c.h | 85c875a8d2e45089c742a5a2b247e60e331098404968c0c8c34da3709f6dd54e |
| tests/fl32c_original_oracle.py | 05beb591c1cb260a76753baf535b8aa4792a1113168e276fcbb31e90142df399 |
| tests/fl32c_fixtures.py | 21acdf0efa27b31f4eed5343aaa7d15d664f1a8aa60a198684b91133b225910e |
| tests/fl32c_direct_test.c | 8366ef30a1b220f924d4db08577c9d106dcf79bfe55491b7f8ceda1a463dee66 |
| tests/fl32c_differential_shim.c | f1da66597e66eb7f718c375d0b32758c8b69266fab9392024b95ed1e2b95bcfe |
| tests/test_fl32c_differential.py | ebaa38b058367e3f13aab30a149c831e3a0218d5ac0f56e5d50d85b1ac8037e9 |
| tests/test_fl32c_direct.py | 533467502235b2ae9846d8af8b60c5872b336386cee5b12af6ae0c6b4b3e0c52 |
| tests/fl32c_mutation_check.py | 59ef1bef85de3b7151f423b7b582769329d934d285b65209eac0bbc88bde7698 |
| tests/fl32c_hand_mutants.py | 180234af5943cba615dd55b1faa7a9d515498e2926b5273939e8ea293203ad0f |

Native library: the differential builds `tests/fl32c_differential_shim.c` + `src/original_methods_fl32c.c` into a throwaway shared object per run (no committed binary).
