# FL-31 batch b (`fl31b`) handoff

Branch `worktree-agent-a92544c882ebdee97` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-a92544c882ebdee97`; the ports land in commit `a86e5ff0`, the handoff and acceptances in the commit after it), based on `6b8fe413` (the FL-31 packet commit, fast-forwarded onto the worktree branch). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl31b-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 9 entries; none of the nine rows has a receipt blocker in the packet, so there is no `blockers_reviewed`). `function_ledger.test_area` / `symbol_area` / `addresses_in` were run on all 27 test ids and on the 9 symbols and accept them (the full ledger build was not run).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (9 of 9, none dropped)

All in `src/original_methods_fl31b.c` / `.h` (symbols `m<va>_*`, world struct `Fl31bWorld`, host convention `Fl18Host` as in FL-18/26/27/28/29). Addresses that the original passes or stores (the destination cells of 0x4daeb5 and 0x47d1c3, the table of 0x420b9e) are 32-bit original addresses and go through `Fl18Host.resolve`; `self`, an address inside `self` (0x4c946b, 0x4ee673, 0x47d59b) and the local pair of 0x4daeb5 are host pointers.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4c946b | 36 | m4c946b_call_slot | 13/13 | 0/0 (no conditional jump) | 36 | 45a97a0041e5606ef1a61bf2d4d5455b7275577fd390004aca682e83937b9e89 | c885b7addfd0698e7365495d4d099c2d5a17d55f71aa7690a6c2c76f31140a49 |
| 0x4ee673 | 43 | m4ee673_forward_if_set | 15/15 | 2/2 | 36 | 6ca020dc7133a335719f073e9be35e3ce0b5a29feacedc6e6ce2ef89dc5ce662 | ae43cdb79497996bfc4d34f3cb51c416c9f0452731bfe2cc8c0dbff77dd9e6d6 |
| 0x4daeb5 | 60 | m4daeb5_read_cursor | 22/22 | 0/0 | 56 | c86cd2f83dd2455477810c0eaee8af46ebb3ba9387514136cb1a5e19ed1c800d | 326d41316d7ec99cb51918c1223f22d25c085b1b9fd2a076dc6fbd5b36c4036d |
| 0x4dadff | 103 | m4dadff_poll_keys | 29/29 | 4/4 | 200 | e5360f6ac0c4d7891320e40a26380a3dfa5a7ad7d86a43e5d47052c5d8985a0a | 544471b7b218e2aed1e198ed97871fbaefed650f64473a2f472d9d5ac03f45a2 |
| 0x420b9e | 121 | m420b9e_report_name | 32/32 | 2/2 | 144 | 223c56f0597d644e79e2cb6344892ac7bf54280999648aa01494098100d02f46 | 6a323858b8c714a58729ff1c74fe66f11f842730857d348ff765969bed8e5712 |
| 0x47d1c3 | 139 | m47d1c3_alloc_zeroed | 45/45 | 4/4 | 144 | 6230e0d081a2b737230b86a1dac9d02f97bb7e97343f51764eae506b0b18d21d | 807c78e7d97ff53be2eb26a32d391437a4a316c35421a19e3d3a31e90ed10485 |
| 0x4fc878 | 145 | m4fc878_activate_record | 38/38 | 4/4 | 350 | 3222fbee7001d5d9f9788ad256e51ebbd1949ff03f049358759abb16c2ea8208 | bfb3f1ddaa0d13aabe1898c6694f9e48c98cf9930c2b3e76d4297d96417b8cb9 |
| 0x47d4f7 | 164 | m47d4f7_reset_fields | 39/39 | 0/0 | 12 | c6aaedbbb9a54fbde49797dcac8ba9885599ce504d6149899f2f3b13fef06137 | 295bb44405bcc175b4ed581b988a811feccc35173d60bef91f7a1d2ddad68985 |
| 0x47d59b | 165 | m47d59b_release_fields | 56/56 | 10/10 | 96 | fff7090fa466a7e9d38d5181b8cb1e3b85ee88cb29ffe51d4dfd8533da93d66f | 69064fa7ea2d8f7db908498d2b9c653602941b79fa2e06cc62d1a968dafe287b |

Every span ends exactly at the function's final `ret`; all nine are pure code. No always-true guard and no unreachable block: every conditional jump of every function is taken both ways (the untaken-edge allowlist `fl31b_fixtures.UNTAKEN_ALLOWED` is empty). The two `rep stos` of 0x47d1c3 are single instructions (no jcc); both sizes (`size >> 2` dwords, then `size & 3` bytes) are exercised for sizes 0 to 0x5f.

Notes per function (the header `original_methods_fl31b.h` gives the byte-level contract):

- **0x4c946b** `call_slot`: `0x4c2dfb(this self, self + 0xc72 + (signed word)index * 4)`; the argument is a host pointer into `self` in the port (the differential maps it back to the original address). Fixtures use a 64 KiB self area with `ecx` at +0x8000 so indices from -0x2000 to 0x1800 (including the sign case 0xffff = -1 and garbage in the upper stack half) land inside it.
- **0x4ee673** `forward_if_set`: dword at +0x252 compared as a full dword (fixtures with a zero low word, a zero high word, and non-zero neighbours around a zero dword).
- **0x4daeb5** `read_cursor` (returns `out` in eax, compared in full): the import in slot 0x52a484 is called with the address of a local pair; x/y go to `self+0x18/+0x1c`, then through `out`. Fixtures put `out` inside `self` (shift 2, 4, -4, 0x14 ..) so that the order of the four stores is visible.
- **0x4dadff** `poll_keys`: `GetAsyncKeyState` results with garbage in the upper half of eax (0x18000, 0x10000, 0xffff8000 ..); the stub logs the two output bytes at each call, which shows that the first store precedes the second call.
- **0x420b9e** `report_name`: the 5-argument call `0x4c51a5` (`ret 0x14`, thiscall with ecx 0x5cf659); table index is a sign-extended word (-4 to 4 in the fixtures).
- **0x47d1c3** `alloc_zeroed`: the allocation result is stored before the test; the clear starts at the address re-read from the cell; null path reports through 0x50ca3e, 0x4264e8, optional 0x44a2b7 (signed word 0x63a4cd non-zero, two garbage bytes behind it), 0x4c97b4. Unlike 0x4895cc (FL-29a) nothing here dereferences null, so there is no native rejection.
- **0x4fc878** `activate_record`: the stack argument is masked to 16 bits (garbage in the upper half); record stride 0x5bb; the stub of 0x4f61e7 probes the state word at the call (still 1), the store of 2 follows the call.
- **0x47d4f7** `reset_fields`: no branches; whole-object compare on random, 0xff, 0x00 and 0xa5 fills, so a wrong width or offset is visible.
- **0x47d59b** `release_fields`: all 32 combinations of the five guards (dword +0x1f, dwords +0x49, +0x4d, +0x51, word +0x23 != -1) with several non-zero dword shapes and word values (0, 0x7fff, 0x8000, 0xfffe, ..). 0x47d4f7 is a host stub here (see below).

## Dropped

None. The spill row (0x4c7623) was not touched.

## Files

`src/original_methods_fl31b.h`, `src/original_methods_fl31b.c`; `tests/fl31b_direct_test.c`, `tests/test_fl31b_direct.py`; `tests/fl31b_fixtures.py`, `tests/fl31b_differential_shim.c`, `tests/test_fl31b_differential.py`; `tests/fl31b_original_oracle.py`; `tests/fl31b_mutation_check.py`; `tasks/fl31b-acceptances.json`; this file. `fl31b_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (the Unicorn runner `Original27`, the stub constructor, the call-log normaliser, the conditional-jump finder), so the oracle needs that file present (it is on main).

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang/gcc)

- Slice tests: `python3 -m unittest tests.test_fl31b_direct tests.test_fl31b_differential` -> 20 tests, OK (11 direct: 9 functions, the run-all check and the sweep; 9 differential).
- Oracle: `python3 tests/fl31b_original_oracle.py` (9 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl31b_direct_test.c src/original_methods_fl31b.c -lm` -> 10 PASS (9 functions + the bounded sweep of 300 random scenarios), no report. The sweep keeps indices, sizes and cells inside the fixture buffers.
- Mutation: `python3 tests/fl31b_mutation_check.py [--only <va key>]`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax`, and log ecx, the stack arguments and, where named, probes of fixture memory or of the two output bytes at the call. Callee shapes taken from the call sites and the callees' `ret N`: 0x4c2dfb thiscall(1) (`ret 4`); 0x4ef4f0 thiscall(1) (`ret 4`); 0x4c51a5 thiscall(5) (`ret 0x14`); 0x51dc43 cdecl(1); 0x50ca3e cdecl(2 in 0x47d1c3, 3 in 0x4fc878); 0x4264e8 thiscall(1) (`ret 4`); 0x44a2b7 cdecl(1); 0x4c97b4 thiscall(0); 0x4f61e7 thiscall(1) (`ret 4`); 0x51dc6c cdecl(1); 0x4d3992 cdecl(1); 0x47d4f7 thiscall(0); import slot 0x52a484 (GetCursorPos) stdcall(1) with two scripted writes (x, y) through its pointer argument, slot 0x52a4b4 (GetAsyncKeyState) stdcall(1) with scripted results. Globals and the table are patched into the image per scenario (`0x5b15da`, `0x5d03af`, `0x58321d`, `0x58321e`, `0x63a4cd`, `0x5d02cb` table). The oracle checks the number of bytes each function popped on every run (4, 4, 4, 0, 0, 8, 4, 0, 0).

## Deliberate divergences and native rejections

None: no branch of the nine originals faults or overruns for the inputs the callers can give. As in the original nothing is bounds checked: the clear size of 0x47d1c3 (an oversized `size` overruns the buffer), the record index of 0x4fc878 (`index * 0x5bb` must stay inside the object), the table index of 0x420b9e and the destination pointers are caller-validated; the fixtures keep them inside their buffers.

- Word arguments are taken from the low 16 bits of the stack dword (the fixtures put garbage in the upper half). The word pushed by 0x47d59b to 0x4d3992 is `mov dx, word; push edx`: the original's upper half is the stale upper half of edx (the high bits of the object pointer); the callee reads only a word, and the oracle/differential compare the low 16 bits (`WORD_ARGS`), the port passes the zero-extended word.
- 0x4daeb5 stores the 8 bytes the import writes through a host-pointer local; its return value is the full `out` dword.

## Unverified

- Callee calling conventions are read from the call sites and, for 0x4c51a5, 0x4c2dfb, 0x4ef4f0, 0x4264e8 and 0x4f61e7, from the callee's own `ret N`; the cleanup counts of the stubs equal those.
- Import names (GetCursorPos for slot 0x52a484, GetAsyncKeyState for 0x52a4b4, GetSystemMetrics for 0x52a498 not used here) are taken from the executable's import table; the meaning of the object fields is a description of what the code does, not recovered source names.
- Not exercised: a callee that changes `self`, an object or a global that the function reads again afterwards (for example 0x4c2dfb or 0x51dc6c changing `self+0x49..0x51` before 0x47d59b reads the next field, or 0x4f61e7 changing the state word before 0x4fc878 stores 2, or a GetAsyncKeyState that changes `self+0x24`). The ports re-read like the original, but the stubs never change them.
- 0x47d59b calls 0x47d4f7 (in this batch) as a host call, not natively: the stub does not run the callee, so the oracle for 0x47d59b does not execute 0x47d4f7's body; 0x47d4f7 is covered by its own oracle (39/39). A host that binds 0x47d4f7 to `m47d4f7_reset_fields` says so itself.
- The `OS` side of GetCursorPos is a scripted write through the pointer; the real import can fail and leave the pair untouched (the original then copies uninitialised stack; the port copies zeros). That failure path is not part of the fixtures.
- No independent review; no claim that any family or pool is complete.

## Mutation check

`python3 tests/fl31b_mutation_check.py` over the whole file (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap):

```
mutants 109: caught by the direct test 102, by the differential test only 4, survivors 3
```

All three survivors were read and are equivalent on every reachable input:

- 0x420b9e lines `m = (int16_t)rd16(self, 0xf75)` and `... 0xf73` read as `rd32`: the `(int16_t)` cast takes the low 16 bits of the dword, the same value.
- 0x47d59b `call1(host, 0x4d3992, 0, rd16(self, 0x23))` read as `rd32`: the stack argument is a word compared by its low 16 bits (the original's upper half is stale), so only the low half is observable.

Mutants applied by hand (the direct test and the differential test are both run on each; all CAUGHT by both): in 0x4daeb5 the stores into `self` moved after the stores through `out`, and `y` written as 0; in 0x4dadff the first store moved after the second call, and the whole eax tested instead of bit 15 of ax; in 0x4fc878 the state store moved before the call, and the index not masked to 16 bits; in 0x47d1c3 the clear one byte short, and the cell store skipped on the non-null path; in 0x47d59b the two frees swapped, and an unsigned word test; in 0x420b9e and 0x4c946b a zero-extended instead of sign-extended word; in 0x4ee673 the guard removed; in 0x47d4f7 a dword store at +0x57 and a changed constant. (The "unsigned word test" mutant of 0x47d59b does not build under `-Werror` for the direct test, which counts as caught; the differential test also catches it.)

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand, loop-bound expressions and double edits are not modelled.

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; `Fl31bWorld.table_5d02cb` must point to host memory that mirrors the dwords at 0x5d02cb with slack for a negative signed-word index; the byte fields 0x58321d / 0x58321e are written by `m4dadff_poll_keys` through the world struct, so the host must map them to the real globals (and `dword_5b15da`, `dword_5d03af`, `word_63a4cd` are read from it).
- `m4daeb5_read_cursor` needs the host to supply the import in slot 0x52a484 as `Fl18Host.call(0x52a484, 0, {pointer to 8 writable bytes})` writing x then y; `m4dadff_poll_keys` calls slot 0x52a4b4 with the key code and uses bit 15 of the low word of the return.
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, at the last commit)

| file | sha256 |
|---|---|
| src/original_methods_fl31b.c | eb16d0b7a94185a4c2272635597043fb040537b763dcc0313ce19564418a0add |
| src/original_methods_fl31b.h | d101bad1f3c9190b275fab8bf4e0aea69d8afdca7a14f261714bc149b886af44 |
| tests/fl31b_original_oracle.py | 870b30d98aff6968db009246ccff7ec5f360d4085b4317d8a335c634c871b6d4 |
| tests/fl31b_fixtures.py | 44b6de8eb075c0e06b766b74fb046e71a8c0bae95ce21b4ac3209b23190394db |
| tests/fl31b_direct_test.c | 84d5b20d2f791a25407ea224a9c7fbfaddcf7d9861733e63674e1ed9b8d3bd65 |
| tests/fl31b_differential_shim.c | e6bf1160020b660b0953998971ffb77b6dc0070e5e8043fcc6699ae0541f10ec |
| tests/test_fl31b_differential.py | 717a42eb0e4cb24bc21f364441907e3d433b4f3bbeec38e255f275aa5f3ad1e8 |
| tests/test_fl31b_direct.py | 9c20ed846482b9fad16faef934ed817b5d17c6d11d39a5da1a3d8e165de801f7 |
| tests/fl31b_mutation_check.py | 1185e047a8737275875cc53205e4ffd264584042f9280d5a2d72e0812cdcdf53 |

Native library: the differential builds `tests/fl31b_differential_shim.c` + `src/original_methods_fl31b.c` into a throwaway shared object per run (no committed binary).
