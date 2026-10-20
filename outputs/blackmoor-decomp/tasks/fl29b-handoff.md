# FL-29 batch b (`fl29b`) handoff

Branch `fl29b` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-adad94f9ed80e0868`), created from `62c9934` (the FL-29 packet commit). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl29b-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 9 entries; none of the rows has a receipt blocker, so there is no `blockers_reviewed`). **0x4e45be is ported and fully executed by the oracle but is deliberately NOT in the acceptances (stays pending), see "Not credited" below.** The Python test ids were checked with `function_ledger.test_area`.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only; checked by the oracle's loader on every run). Source hashes at the time of writing: `src/original_methods_fl29b.c` 2168c98f65f61389503325b1d8366b6094d211582f4d8dd829212b7c6a29d864, `.h` 0116cade8bd411a3f293bc3b54f2e335f7d01fbff0ba6bcfe49a607ea0b1389d, `tests/fl29b_original_oracle.py` 764b38cb6acb5e3ada6650e55de9bd8c4e39093f1210f67232306a90aac98109.

## Ported (10 of 10 ported; 9 proposed for credit, 0x4e45be not credited)

All in `src/original_methods_fl29b.c` / `.h` (symbols `m<va>_*`, world struct `Fl29bWorld`, host convention `Fl18Host` as in FL-18/26/27/28). The spans equal the ledger spans (the window is `va .. va+span`).

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes) |
|---|---|---|---|---|---|---|---|
| 0x4ee69e | 41 | m4ee69e_forward_if_set | 15/15 | 2/2 | 48 | d215ef33d880b0c3b892e0f39a5d6125eeaa0dcf0208c9a0107b5ded99d1695f | 7c9511b3156daf3837dc3a783867b87177457cf68cd55b62727fd095c8551641 |
| 0x423aae | 67 | m423aae_chain_end | 26/26 | 6/6 | 32 | 09479fbfca29f4606053ba7bb0ac06f62b7c271ee4a2549653dfe2c1a83485a5 | a84843a2eb2124a83a5d3693b27690db5339bd49929982c7f67978ac57be50b5 |
| 0x4fccf2 | 91 | m4fccf2_store_percent | 27/27 | 2/2 | 496 | 1fa66a8a3776d23643d7e251f407188ff93ae00561994b18a8d089237015e251 | 076b72ed4cb5aa88182dda67619a38e3aaadaf0462696a5b8f357e375f5a3cfc |
| 0x423a30 | 126 | m423a30_free_cell | 39/39 | 4/4 | 45 | 4dd4d4e2e39659a723c3ecf28efe3a5748f2e01fa7f2538287bcdcbe1f8f93f6 | 252b82f254028899a115f8a39228636412d30bdcdc1ebb54ec3929f9ff90077b |
| 0x42e72c | 140 | m42e72c_toggle_state | 36/36 | 8/8 | 159 | b4dee299a4ca3badb00b9e3ed6c6aab43feb89ffa69900d9a5c95c040e53c6cf | 12413d5e0afa20a4f02e4c57cd50897b89999c0824ac418368dd2c10c38cca91 |
| 0x4e9c2f | 176 | m4e9c2f_copy_six | 54/54 | 4/4 | 45 | dfe0a1cfbf54829f42e568cab7f796ba3beddffc61330981ea37705b7b321448 | b4fe565c0bd41b0405be18cf2bf0665cf880c627fc85a66ed6fb38839d1bac41 |
| 0x4e45be | 193 | m4e45be_find_row | 59/59 | 10/10 | 184 | f0488364eb98df9d0edfa5448a346f46e2916e1771008a62bbc70a3043e4b311 | 666ee5d2803bd9d84b7e290d5cb2dc1824a702df473f216f71894b640fbc8ab8 |
| 0x437dcd | 212 | m437dcd_note_key | 68/68 | 18/18 | 4080 | 1bf4c4576ef6beba996bf84d408d65686ffad0eb4472efc7c69f1390219e3368 | dc0a96cc685c34f58fb28837f441765ce700432baa6ce916a1e50456423d5f17 |
| 0x4e4337 | 241 | m4e4337_load_blocks | 73/73 | 2/2 | 108 | 251189f7aef519a826206cfc00a1175800cda75bf7eb1f6c06babcd3da6e6057 | cc3f8179f7ac4fe258c213ae474393b32617ca8faa06331cdaff3a1a499299a3 |
| 0x411a22 | 244 | m411a22_alloc_copy | 75/75 | 6/6 | 104 | 76c968f11027f2f8e3d0bd3fbca25495a3b41e140e4cf90f73fb5c273d783076 | c9e641c18f0fd3663697c2c7bc3f23a193c4040e79d336047f53c5534dcb53ba |

Every conditional jump of every function is taken both ways by the oracle (the untaken-edge allowlist `fl29b_fixtures.UNTAKEN_ALLOWED` is empty). No function has an instruction behind an always-true guard; the spill rows (0x4f61e7, 0x44b26a) were not needed and were not touched.

Notes per function (the headers of `original_methods_fl29b.h` give the byte-level contract):

- **0x4ee69e**: forwards to 0x4ef516 (thiscall(0), this = self + 0x4b7) when the dword [+0x252] is non-zero, returns its eax; else 0.
- **0x423aae**: link walk `[arg+4]`, then `[q+0x38]` until 0; the addresses are originals resolved through the host.
- **0x4fccf2**: `fild` of the masked word, float store, `fdiv` by the float constant 100.0 at 0x52cbec (read from the image), `fstp dword` at `[self + index*4 + 0xb764]`, then 0x4fcb5c; the oracle runs the x87 code with control word 0x27f, the port uses `(float)((double)f / 100.0)`.
- **0x423a30 / 0x4e9c2f / 0x411a22**: the report paths (0x50ca3e cdecl, 0x52139c stdcall, 0x42639d thiscall(2), 0x4264e8 thiscall(1), 0x4c97b4 thiscall(0)) are host calls that return, and the function continues after them exactly as the original does.
- **0x42e72c**: cdecl without arguments; word toggle by `movsx`/`test`; mode compare with the sign-extended word; the store goes to the address in [0x5d03bf] read after the toggle.
- **0x4e45be**: nested signed-word loops over 0x29-byte rows; unsigned byte compares; `sete` result.
- **0x437dcd**: two latch blocks calling 0x437ea1 (it reads only `movsx byte [ebp+8]`, checked to the end of the function at 0x438117), then three calls with the sign-extended character.
- **0x4e4337**: `rep movsd`/`movsb` copies (forward, element by element, ported as `rep_movs`), size word read from the object after the second copy (it lies inside the second copy), signed limit compare.
- **0x411a22**: both arms of the `cmp word, 10` give 0x27 (the compare is unobservable; both directions are taken by the oracle).

## Not credited

- **0x4e45be** (`m4e45be_find_row`, kept with its tests, removed from `tasks/fl29b-acceptances.json`). With a row count `[0x5a1e5c] <= 0` the loop is never entered and the original returns `sete` of the uninitialised local `[ebp-0xc]` (the stack content decides; `[ecx]=0` is stored first). This is a reachable valid-input path, not a fault: the caller 0x4e7253 (phone insert, `function-xrefs.json` lists 0x4e4cb6 and 0x4e7253 as callers) calls 0x4e45be before appending a row, and the first insert into an empty table has count 0 (a "found" answer would update row 0 instead of appending). The port returns 0 there (documented-unspecified, not original behaviour), so the row cannot be claimed as an exact port and stays pending. The oracle still executes 59/59 instructions and 10/10 directions on legal counts.

## Dropped

None.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments (shapes verified by the callee's `ret N`: 0x4ef516 thiscall(0); 0x44a2b7, 0x44c479, 0x44c4ab, 0x51dc6c, 0x51dc43 cdecl(1); 0x50ca3e cdecl(2) at 0x423a30 and cdecl(4) at the other callers; 0x52139c stdcall(3); 0x4c97b4 thiscall(0); 0x4fcb5c, 0x4264e8, 0x437ea1, 0x4a1f59, 0x48e93e, 0x4b8193 thiscall(1); 0x42639d thiscall(2)), return a scripted `eax` and log ecx, the stack arguments and probes of the memory the function can have changed. None of the callees is a function of this batch; all are host-stubbed. Globals and tables are patched into the image per scenario (the world scalars; the 0x29-byte rows at 0x5a1e64; the records at 0x5bb5e5). x87 control word 0x27f is set for 0x4fccf2 (the Windows default). The oracle checks the bytes popped on every run (`ret 4/8/0xc/0x10`).

One scripted write: in the `fail` profiles of 0x4e9c2f the stub for 0x4c97b4 stores a valid destination in the out cell (the report "leaves" a defined cell, so the copy that follows is defined). This exercises the original's re-read of `*out` after the report and is the only place where a callee changes memory the function reads again; other callees are not given effects on `self` or on globals the function re-reads (not exercised).

## Deliberate divergences and native rejections (not original behaviour)

Valid-input behaviour matches the original; the following are native rejections of inputs on which the original faults, overruns or never ends (each is tested directly, and under ASan/UBSan, apart from the oracle):

- 0x423aae: an unresolvable link, or more than `FL29B_CHAIN_LIMIT` (0x100000) links (a cyclic chain: the original loops for ever), returns 0.
- 0x4e9c2f, 0x411a22: an address in a cell that the host cannot resolve ends the function at that point (for 0x4e9c2f after a failed allocation whose report did not repair the cell, the original writes to address 0).
- 0x42e72c: an unresolvable destination address is not written.
- 0x4e4337: a negative size word (`(int16)(word * 0x29)` < 0; the original would `rep movsd` about 2^30 dwords) returns after the second copy, without the limit check.
- 0x4e45be: a non-positive row count: the original returns `sete` of an uninitialised stack local (a reachable case, see "Not credited"); the port returns 0 (the fixtures keep the count positive; the stack in the oracle is filled with 0x71, so no claim is made).
- 0x437dcd: the first `0x437ea1` call pushes `ecx` = `(self & 0xffffff00) | c` in the original; the port passes `c`. The callee reads only the low byte, so the comparison masks that argument with 0xff (`WORD_ARGS[0x437ea1] = {0: 0xff}`).
- Word arguments (0x4fccf2 `a`, 0x4e45be `len`) are taken from the low 16 bits of the stack dword (the fixtures put garbage in the upper half on every second pass).
- Nothing else is bounds checked, as in the original (table rows and record indices are caller-validated; the fixtures keep them inside their buffers).

## Unverified

- Callee effects on `self`/globals that the functions read again are not exercised (except the 0x4c97b4 repair above).
- 0x4fccf2 x87 precision (closed by the reviewer): all 65536 values of `a`, `(float)(a/100.0)` evaluated in 53-bit precision and in 64-bit extended precision and rounded to float, both equal the correctly rounded quotient, so the control word cannot change the result.
- Import/callee names are hints from call shapes only; the meaning of the tables is a description of what the code does.
- No independent review; no claim that any family is complete.

## Files

`src/original_methods_fl29b.h`, `src/original_methods_fl29b.c`; `tests/fl29b_direct_test.c`, `tests/test_fl29b_direct.py`; `tests/fl29b_fixtures.py`, `tests/fl29b_differential_shim.c`, `tests/test_fl29b_differential.py`; `tests/fl29b_original_oracle.py`; `tests/fl29b_mutation_check.py`; `tasks/fl29b-acceptances.json`; this file.

## Commands (from `outputs/blackmoor-decomp`)

- Slice tests: `python3 -m unittest tests.test_fl29b_direct tests.test_fl29b_differential` -> 22 tests, OK (12 direct: 10 functions, the run-all check and the sweep; 10 differential).
- Oracle: `python3 tests/fl29b_original_oracle.py` (10 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl29b_direct_test.c src/original_methods_fl29b.c -lm` -> 11 PASS (10 functions including every rejection path + the bounded sweep of 300 random scenarios), no report.
- 0x437dcd review fix: the scripted results of both 0x437ea1 calls now include 0x10000 and 0x80000000 (the oracle stays 68/68, 18/18; 4080 scenarios); the mutants `(uint16_t)call1(...) != 0` on the first and on the second call are both caught by the differential test (checked by hand).
- Mutation: `python3 tests/fl29b_mutation_check.py [--only <va key>]`: 150 mutants, 135 caught by the direct test, 4 by the differential test only, 11 survivors in the first run; after one added direct case (unresolvable destination of 0x411a22) the guard mutant at 0x411a22 is caught (re-run with `--only 411a22`: 30 mutants, 4 survivors), leaving 10 survivors, all equivalent:
  - 0x423aae `if (arg == 0)` and `if (q == 0)` guard deletions: address 0 is unresolvable, so the rejection path returns 0 anyway; `++steps > LIMIT` -> `>=` moves only the native cap by one link.
  - 0x4e9c2f `rd16` -> `rd32` for the word that is stored through `wr16` (truncated to the same 16 bits).
  - 0x4e4337 `0xbc` -> `0xbd` (the extra dword is overwritten by the second block, which starts at the next byte) and `rds16` -> `rd16` (the low 16 bits of the product are the same).
  - 0x411a22 line 284 (`0x23`, `0xa`, `>=`, `rds16`): both arms of the compare store the length 0x27, so the compare has no observable effect in the original either; the oracle still takes both directions.

## Branch and commit

Branch `fl29b`, based on `62c9934`; the commit hash is in the report that accompanies this file.
