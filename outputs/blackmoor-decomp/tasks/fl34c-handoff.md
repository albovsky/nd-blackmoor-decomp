# FL-34 batch c (`fl34c`) handoff

Branch `worktree-agent-a02505cddccfeb4fe` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-a02505cddccfeb4fe`), based on `917c6ca5` (the FL-34 packet commit, fast-forwarded in; the worktree started at `425d4bad`). Implementer: Claude Sonnet. No independent review has been done (every acceptance entry says so in its `reviewer` field); root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl34c-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 8 entries, no receipt blocker, so no `blockers_reviewed`; the oracle window of each is its ledger span `[va, va+span)`).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (8 of 8, none dropped)

All in `src/original_methods_fl34c.c` / `.h` (symbols `m<va>_*`, world struct `Fl34cWorld`, host convention `Fl18Host` as in FL-32b). Commit: the one that adds this file (its hash is in the report; a commit cannot name itself).

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4d0abc | 64 | m4d0abc_post_message | 17/17 | 0/0 | 12 | 355615a90dd5dac8cbee95cb6e1a6cbb11aa79db700c089fb1fb6ea13fd9d852 | fda39eb9290397494a87b9351aa976f176fb851a909b8356c1907c75a6080701 |
| 0x4d0c17 | 64 | m4d0c17_post_message | 17/17 | 0/0 | 12 | 2cf0762929e105193a30961712012ab7d7dcdb27491710a7ba13f6ffa162d7d1 | 8f85e3e936eede69ce7f537266189646a90d32ecfac77fd15d7f31d841e7a9f2 |
| 0x4e01fb | 64 | m4e01fb_post_message | 17/17 | 0/0 | 12 | 3e2e978bd2a6abe0298aefa20eb6ef12a591591c01a3430eef3602250b4c3ac7 | baf22ce0e8476d789170dceef78b8fe7cf3e9b82af1b4b90308efb86f364202a |
| 0x4cca9c | 51 | m4cca9c_fill_record | 20/20 | 0/0 | 36 | 63477b99872575b6b51fcdd63898100f7583dfac76e983890ca5778bfcbb3af4 | f682c8b11d7774cd67c1ed1212430377f213583442aee98ff0248f6544d89681 |
| 0x446f77 | 51 | m446f77_construct | 16/16 | 0/0 | 8 | 3216091fbc9f7aa760f406220fc1025930c9339d74b1b6d0d7b233065e572809 | 1c4fc69cc7a73c3c6fb82201431a99a6fa455405ba044d436a048904893c203c |
| 0x4fce5e | 50 (code 48) | m4fce5e_call_with_record_dword | 15/15 | 0/0 | 30 | 3b6eea9039f9d497c4f2e771c61078f6d958f978d84fc3c52735aa6dfc906a34 | 751a15a79b47d79cd2fe394d7404c8a074ff96bff71a1dd975a7834871f38648 |
| 0x4d3ffe | 69 | m4d3ffe_start_flag | 19/19 | 2/2 | 54 | 317060867321391abf99ae5687e73a930474317e19989c2ddd162f18a75d1ab6 | f7af5f83f20156758a5d5d86c3c24ac4d049c4eaec7921725c65f94053f8f275 |
| 0x47a3d9 | 61 | m47a3d9_set_flags | 18/18 | 2/2 | 54 | cb64b8c58f4ae8937e6c9f43d4fb6bd3b852cbb8f2e0ced7caecc21c9c0bb62a | eed94043665c0a3634b02829e4ec9607c06fede1e3fc802335bdc1153a428c69 |

Untaken jump edges: none (`fl34c_fixtures.UNTAKEN_ALLOWED` is empty). The only conditional jumps are the `jne` of 0x4d3ffe (0x4d4033, flag byte non-zero / zero) and the `je` of 0x47a3d9 (0x47a3ea, answer zero / non-zero), both taken both ways. No function has an unreachable block. 0x4fce5e: the ledger span 50 includes two `int3` after the `ret 4`; the oracle counts the 48 code bytes (`SPECS['4fce5e']['code']`), the acceptance window is the span.

## Constants verified per row (from each row's own disassembly)

- **0x4d0abc / 0x4d0c17 / 0x4e01fb**: one shared static helper in the source, one exported symbol each citing its own address. Pushes (first to last): the constant (0x55a05c / 0x55a0e8 / 0x55ba9c), dword g3 (0x5d2a27 / 0x5d2be3 / 0x5d2821), g2 (0x5d2a23 / 0x5d2bdf / 0x5d281d), dword [0x5cf665], g1 (0x5d2a1f / 0x5d2bdb / 0x5d2819); so `args[0]` = g1 .. `args[4]` = the constant. `ecx = 0x5cf659`. Then `word [0x5bb1c4] = 2` and `word [0x63a97c / 0x63a97e / 0x63a9d0] = 0`. **The packet says `0x4c5377` has 4 stack arguments; it has 5** (five pushes at each call site, and the callee's final `ret` at 0x4c5588 is `ret 0x14`); the stub pops 0x14 and the oracle's cleanup check would fail otherwise. The reads come before the call and the stores after it (`world` words are carried: the probe on the stub shows them unchanged at the call; the "mutate" scenarios make the callee rewrite all four read globals, so a read after the call would show). The port returns the callee's eax (the instructions after the call do not touch eax).
- **0x4cca9c** (`ret 0x10`, four stack arguments rec, a1, a2, a3): `0x4cc962` (thiscall, 1 argument, `ret 4`) with `ecx = self` and argument rec, then dword stores `[rec] = a1`, `[rec+0x14] = a2`, `[rec+0x28] = a3` (taken from `[ebp+0xc]`, `[ebp+0x10]`, `[ebp+0x14]`). The eax at `ret` is a3 (the last `mov eax,[ebp+0x14]`); the port returns it and the oracle compares it. rec is a host pointer in the port; fixtures put rec at five offsets of the 0x400-byte object, two of which alias `self` (0 and 0x14) and one unaligned (0x13), with and without a callee that clobbers the 0x2c bytes.
- **0x446f77**: `0x51d716` (thiscall, no arguments) with `ecx = self`, then `dword [self] = 0x52ca58` (vtable pointer), `dword [self+0x31] = 0`, `dword [self+0x35] = 0` (unaligned; the port uses `memcpy`), returns self (the original reloads `[ebp-4]`). Scenarios with a callee that dirties `[self]`, `[self+4]`, `+0x31`, `+0x35` show that the stores come after the call.
- **0x4fce5e** (`ret 4`): `eax = movsx word [ebp+8]`, `imul eax,eax,0x8d`, `ecx = dword [eax+0x5bb5e5]`, then `0x4f7e93` (thiscall, 1 argument, `ret 4`) with `ecx = 0x5cf1eb`. Returns its eax. Fixture indices are chosen so that every address is inside the image (positive up to 4000, negative down to -12000; -32768 would fault in the original and is not exercised), the stack argument has random garbage in its high half in half the scenarios.
- **0x4d3ffe**: `[self+0x440] = 1`; `0x4dad60` (thiscall, no arguments) with `ecx = 0x5830a6`; `[self+0x462] = 0`; `edx = 0; dl = byte [0x61c6ae]`; `test edx,edx; jne` skips `[self+0x1c] = 0`. The byte is read AFTER the call (scenarios where the callee clears or sets it), the neighbours of the flag are non-zero (a 16/32-bit read shows), and the value 0x80/0xff exclude a signed or masked test. eax at `ret`: self when the byte is 0, else the callee's eax.
- **0x47a3d9**: `0x4789d6` (thiscall, no arguments) with `ecx = self`; 32-bit `test eax,eax`; non-zero: `[self+0x1576] = 1`, `[self+0x24] = 1`, eax = self; zero: `[self+0x1576] = 0` only, eax = 0. Answers include 0x10000, 0x100, 0x80000000, 0xffff, 0xff000000 (a 16- or 8-bit test would take the wrong branch); scenarios with a callee that dirties both fields show that `+0x24` is untouched on the zero path.

## Dropped

None.

## Files

`src/original_methods_fl34c.h`, `src/original_methods_fl34c.c`; `tests/fl34c_direct_test.c`, `tests/test_fl34c_direct.py`; `tests/fl34c_fixtures.py`, `tests/fl34c_differential_shim.c`, `tests/test_fl34c_differential.py`; `tests/fl34c_original_oracle.py`; `tests/fl34c_mutation_check.py`, `tests/fl34c_hand_mutants.py`; `tasks/fl34c-acceptances.json`; this file. `fl34c_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (Unicorn runner `Original27` with the edge hook, stub constructor, call-log normaliser, conditional-jump finder), so the oracle needs that file present (it is on main).

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl34c_direct tests.test_fl34c_differential` -> 19 tests, OK (11 direct: 8 functions, the exact-size check, the sweep and the run-all check; 8 differential).
- Oracle: `python3 tests/fl34c_original_oracle.py` (8 lines as in the table, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl34c_direct_test.c src/original_methods_fl34c.c -lm` -> 10 PASS, no report (`test_exact_size_buffers` calls each port on heap buffers of exactly the highest offset + width the original touches: 0x39 for 0x446f77, 0x2c for the record of 0x4cca9c, 0x466 for 0x4d3ffe, 0x157a for 0x47a3d9).
- Mutation: `python3 tests/fl34c_mutation_check.py [--both]`, `python3 tests/fl34c_hand_mutants.py [--both]`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax` and log ecx, the stack arguments and, where named, probes. Shapes from the call sites and the callees' bytes: 0x4c5377 thiscall(5) (`ret 0x14`); 0x4cc962 thiscall(1) (`ret 4`, verified at 0x4cca0b); 0x51d716 thiscall(0) (first `ret` at 0x51d72f is plain); 0x4f7e93 thiscall(1) (only `ret` of a linear disassembly is `ret 4` at 0x4f80d0); 0x4dad60 thiscall(0) (first `ret` at 0x4dadfe plain); 0x4789d6 thiscall(0) (plain `ret` at 0x478a2b). The callee bodies are not recovered here; a path with a different `ret` than the first one found in a linear scan is not excluded for 0x4dad60 and 0x51d716, whose bodies were only scanned. Scripted callee writes: the four read globals (0x4d0abc family), the 0x2c bytes at rec (0x4cca9c), `[self]`, `+4`, `+0x31`, `+0x35` (0x446f77), `[self+0x440]`, `+0x462`, `+0x1c` and the flag byte (0x4d3ffe), `[self+0x1576]`, `+0x24` (0x47a3d9). Globals read by the functions (0x5d2a1f.., 0x5cf665, 0x61c6ae, the record table) are patched into the image per scenario and reach the port through `Fl18Host.resolve`; the words the functions write are `Fl34cWorld` fields (a copy of the original words, compared after each run). No Win32 import, no `rep` string move, no x87, no indirect jump. The oracle checks the number of bytes each function popped (0x10 for 0x4cca9c, 4 for 0x4fce5e, 0 for the rest) and that 0x446f77 returns this.

## Deliberate divergences and native rejections (not original behaviour)

- None for valid input. As in the original, nothing is bounds checked: the object must cover the highest offset stored (0x39 for 0x446f77, rec 0x2c bytes for 0x4cca9c, 0x466 for 0x4d3ffe, 0x157a for 0x47a3d9); `resolve` must return host memory for the read addresses (the differential shim returns a 0x5c-filled block for an address no fixture covers so that a port that reads the wrong place fails the compare instead of faulting).
- `m4cca9c_fill_record` takes `rec` as a host pointer (the original stack argument is an address). The differential converts the fixture address.

## Unverified

- The bodies of the callees 0x4c5377 (partly), 0x4cc962, 0x51d716, 0x4f7e93, 0x4dad60, 0x4789d6 are not recovered; only their stack pops (the `ret` found) are verified. Their side effects on globals the functions read again afterwards are exercised only by the scripted writes listed above; 0x4c5377 may change the object at 0x5cf659 (including 0x5cf665) in the real game, which the functions do not re-read.
- The meaning of the fields is a description of what the code does, not a recovered name; names are hints.
- 0x4fce5e: indices outside [-12990, 4027] address memory outside the image and fault in the original; they are not exercised and the port reads whatever `resolve` returns for them.
- No independent review; no claim that any family or pool is complete.

## Mutation check

`python3 tests/fl34c_mutation_check.py --both` (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd32` -> `rd16`):

```
mutants 43: caught by the direct test 43, by the differential test only 0, survivors 0
mutants the direct test caught but the differential (original-x86 oracle) did not: 0
```

So the original-x86 oracle (differential) also catches all 43. Hand-written mutants (`python3 tests/fl34c_hand_mutants.py --both`, 49 of 49 caught by the direct test AND by the differential, 0 survivors; the mutants that failed to build are not counted as caught: all build): the stores of the 0x4d0abc family before the call, a word-wide or wrong-valued 0x5bb1c4 store, a store into another row's word, another row's text, globals or word, a wrong-offset or word-wide read of a global, swapped globals, a wrong return value; 0x4cca9c word store, swapped a2/a3, wrong rec / this, stores before the call, wrong return; 0x446f77 stores before the call, narrowed stores at 0, +0x31, +0x35, `return NULL`; 0x4fce5e zero-extension instead of `movsx`, 16-bit product, stride 0x8c, word read, dropped return value, wrong argument count; 0x4d3ffe stores before/after the call in the wrong place, 8/16/32-bit and masked and signed tests of the flag, narrowed stores, the two returns swapped; 0x47a3d9 16-bit and signed tests of the answer, narrowed stores, an extra store on the zero path, wrong return values.

Known gap of the tool: mutants are single textual edits; reorderings that are not observable (the stores of 0x4cca9c and the zero stores of 0x446f77 hit disjoint bytes, so their relative order cannot be shown; only the order against the call is observable and is mutated).

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; `resolve` must serve the globals above from the host's copy of the image/world; `Fl34cWorld` holds the host's copies of the words 0x5bb1c4 (and neighbours 0x5bb1c2/6), 0x63a97c, 0x63a97e, 0x63a9d0 (and neighbours).
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, at the commit that adds this file)

| file | sha256 |
|---|---|
| src/original_methods_fl34c.c | 3bd555c52eeba0b4378845789aadc04d37ca550f04910a006fce321f805e184d |
| src/original_methods_fl34c.h | 4921786a54826d1da43f199262905e1be8b79c2b81a539aa8338540c911d50f5 |
| tests/fl34c_original_oracle.py | 60fefa9afe11cd5d1dbdea958a3bcbcf478a4253234b9e17d5fce68ba95388f6 |
| tests/fl34c_fixtures.py | 684e14a7d59ffc1f74d10bf48db1add6c14a562bc1d6ce52b3aec51e3c1a6e93 |
| tests/fl34c_direct_test.c | 1bbc0ab6f54e2f3b0558903984622a0471a0144c9fdcd686b96279839a446ba2 |
| tests/fl34c_differential_shim.c | 9018088f0eaf10b6f31967cd731475899f558c9d8b6106f99810e206b1da0589 |
| tests/test_fl34c_differential.py | dd5585b0ad70a239a0be600bc647804481ebbe1ce873aeaae08d806a71ba0d63 |
| tests/test_fl34c_direct.py | c7ac9086c670a4df73821d1a0309a88694fc197d29d89562bf1d175d57addfd6 |

Native library: the differential builds `tests/fl34c_differential_shim.c` + `src/original_methods_fl34c.c` into a throwaway shared object per run (no committed binary).
