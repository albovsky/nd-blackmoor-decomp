# FL-34 batch a (`fl34a`) handoff

> Collection note (root): one Sonnet slice-reviewer diff review found no P1; the acceptances' `reviewer` field was set to `Sonnet slice-reviewer, diff review, no P1 (FL-34)` and the batch was merged into `claude/project-thread-mokacw`. The branch and commit named below are the implementer's worktree.

Branch `worktree-agent-acae58f1e1083a036` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-acae58f1e1083a036`), based on `917c6ca5` (the FL-34 packet commit; the worktree was created at its parent `425d4bad` and fast-forwarded). Code commit `a81e350c`. Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl34a-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 21 entries; none of the rows has a receipt blocker in the packet, so there is no `blockers_reviewed`). `FL.test_area` (decomp-progress/function_ledger.py) resolves all 63 test ids and `FL.symbol_area`/`addresses_in` finds each row's address in its symbol's leading comment (checked by a scratch script, not committed).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (21 of 21, none dropped)

All in `src/original_methods_fl34a.c` / `.h` (symbols `m<va>_toggle_<base>`, world struct `Fl34aWorld`, host convention `Fl18Host` as in FL-18/26..32). Each row has its own symbol citing its own address (leading comment) and carrying its own table base as the literal `0x<base> - 0x5e60da`; the shared static helper `toggle_dword(self, table, delta)` holds the body (as the FL-32a `toggle_dword` did). The table base of every row was read from that row's own disassembly (not taken from the packet or from the neighbour): a scratch script disassembled all 21 and checked, per row, that the 20 instructions are identical to those of 0x402962 apart from the base (all four occurrences: the `cmp` and the two stores) and the relative call displacement, and that the call target is 0x40236a for all; the bases it read are exactly those the packet lists. The rows are contiguous 71-byte functions (0x402962 + 0x47 = 0x4029a9 and so on); the bases step by 4 except that 0x5e60da, 0x5e60de and 0x5e60e2 belong to the FL-32a rows 0x4029a9 / 0x4029f0 / 0x402a37 (not touched here).

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x402962 | 71 | m402962_toggle_5e60d6 | 20/20 | 2/2 | 108 | aba702585cfb6bdb454b1ea552e4c7f76b7a93cc53f78a202d6058d51fe454fc | d8ad5e220707a0e970580b29004f615c817e3584049af495ac41d0fcaf66a3d7 |
| 0x402a7e | 71 | m402a7e_toggle_5e60e6 | 20/20 | 2/2 | 108 | 0e8a43a10beb76011a5d39537953d65120a91c3d9150116e0cd02d6af687d890 | 7c42c670ca86574f608e70e2624136f65627872f650de40781c98cbac7160c03 |
| 0x402ac5 | 71 | m402ac5_toggle_5e60ea | 20/20 | 2/2 | 108 | 97891fa71c76ae944a1cb84f1381fb3f23e0d19dceb4aada36f1b61f39798bee | 972c8cde4f3e584da1369cdf3478cc15135109875389d703a33b7f1f5bab3870 |
| 0x402b0c | 71 | m402b0c_toggle_5e60ee | 20/20 | 2/2 | 108 | 6a5d9448df65cedbbd21e9bac9500239cafd04f46b272c2a9df4dff48625ef4a | 656c41ac8014d7498645960c3e293b0eec48194dcd68f8a8c933f701b740ba5d |
| 0x402b53 | 71 | m402b53_toggle_5e60f2 | 20/20 | 2/2 | 108 | 0eac1aeb74de00cedad6ae9aec36e4cf847cad2e9ff8cf12f3ae987cd013ae63 | d68a5335592c3545c4444c545e38faef3bbcc9e31ae4514c85bad378620a14a6 |
| 0x402b9a | 71 | m402b9a_toggle_5e60f6 | 20/20 | 2/2 | 108 | f1a9d5f9913546fc914bce35afc482180df4431d5665f576c363e1505c0828e2 | 3f5f85634844fbe2c5a241303185341acae714d30d103aef69d8217ecfe6f1fc |
| 0x402be1 | 71 | m402be1_toggle_5e60fa | 20/20 | 2/2 | 108 | 6da8d3c682ed257e309a53b42287d91513381b865a6f337d2ad049f0b918c01b | 42c7f757a988629903f8481889dc7313fe4df2f48a12578532183b48d35d8f77 |
| 0x402c28 | 71 | m402c28_toggle_5e60fe | 20/20 | 2/2 | 108 | c82e29833e65862fc78973203e9cef6b48b37d70d7e3e7d8626e3c96c22e62d5 | cb88eb3878333c9aeb3b261e15758a5c8da8770749bd64b2fda05f0d72e2c393 |
| 0x402c6f | 71 | m402c6f_toggle_5e6102 | 20/20 | 2/2 | 108 | 246997c6844cb98bdce80752cb05a4fe833bb8f5af448da5f0d45f50ebbf62af | 2c1b0a3bd20f58949fdb27ebbbf531b31d125a37bc7e9690fb69c9f87f3a3e8d |
| 0x402cb6 | 71 | m402cb6_toggle_5e6106 | 20/20 | 2/2 | 108 | 6155a922b0c34fe299fbaecb81b73c783d026496ceccb9af44da7b81cbdd20fa | d11b427c73b53bbe869b7d81a7fd190482de0dff4e26d1a640c25ef96bd13ca6 |
| 0x402cfd | 71 | m402cfd_toggle_5e610a | 20/20 | 2/2 | 108 | 92d1ffffc13856c73841c6e90a3ad675414922b3d748702813748d1095b0b35c | 9ca44573d600bd9caa97b345d818bd48f1ac6ad083f4d798905481931c56bda7 |
| 0x402d44 | 71 | m402d44_toggle_5e610e | 20/20 | 2/2 | 108 | 6eecbffee7279ca557af424220fcca0e4d724ad856df7a290275693ace16fc26 | 063522a62547046e62db56f439dfbcb569fed39a5ec13263cc72500350e2e28e |
| 0x402d8b | 71 | m402d8b_toggle_5e6112 | 20/20 | 2/2 | 108 | b465e7e0f972481496777ec2b3adf17b3880d91f85951587c89f20936dd5f822 | 3354ddf6694d96c185bca8b534164151d437d1afb119bfb627f831903c9a3ef6 |
| 0x402dd2 | 71 | m402dd2_toggle_5e6116 | 20/20 | 2/2 | 108 | 700764e5801023dfed74892b4d9b60f2ce289fa887f08ab6803f1d9f3a37ddd0 | 25b4db6eaa917d5d9b83afd9827959f47f882c449f135b0f52b87108bd993fa0 |
| 0x402e19 | 71 | m402e19_toggle_5e611a | 20/20 | 2/2 | 108 | 83a6160c5af7f6f7f20f370cc3cce02802c4ccf6998503fd143cbcbcf59e9fdf | db67f29ca588afce314e45f45f2ed4e3d4289661f3f6525c68e024fd4a88f14a |
| 0x402e60 | 71 | m402e60_toggle_5e611e | 20/20 | 2/2 | 108 | 9ce727c863c09f490401a782864aa371e702b0a9945ddfa01660b81fbc33b6d4 | b6b21ad2558028390549c51ec362e7bb8ba05bb7ecf16a101e50680060d82880 |
| 0x402ea7 | 71 | m402ea7_toggle_5e6122 | 20/20 | 2/2 | 108 | 0d15713ee55110afd9173abd7795f7d5c69d41b3493b53a6d7990b62662f4696 | beef5b01fb5ae801d99d3597867e99f70d1268a7d1751fb0cba873096021b1fa |
| 0x402eee | 71 | m402eee_toggle_5e6126 | 20/20 | 2/2 | 108 | 4dc79042d64bc0753693424bab1d2a698cdfa51cce14d976ace6ebdd9afcad5e | 36bd721d1d69ef2c6df4268dfde9e213eda8af0fe4946ac836ba1c648f760203 |
| 0x402f35 | 71 | m402f35_toggle_5e612a | 20/20 | 2/2 | 108 | 1e3acdf5d25ed6a20133fd8c261506e5b59f9fec170b87deee6a79f15c22eb0a | ac099cffb9d861cd2ee0fa30579a2c4c50c09ec8a64a1634765c5319f5e6d81d |
| 0x402f7c | 71 | m402f7c_toggle_5e612e | 20/20 | 2/2 | 108 | 193ef9a5c5dfdbdb6419504977d492c16d297939dc4ded3f340a2faa64a710f8 | df898ac74ef9d4e71c71604fd68ed3306438ebb8ce4af5ff00c2488f1ddc9bab |
| 0x402fc3 | 77 | m402fc3_toggle_5e6132 | 20/20 | 2/2 | 108 | 3d325b4d99efd7122a216e2bd67a72de5ffa3fe65d5a0da8a3ce28fa80957912 | f5fdb2fba7efdbc47986498977b96ae3f91f9ba635d5d790a5820167871cfc12 |

0x402fc3 has ledger span 77: 71 code bytes (20 instructions, ending at its `ret` 0x403009) followed by 6 `int3` (0x40300a..0x40300f); the oracle and the edge finder use the 71 code bytes (`code=71` in `SPECS`), as for `0x43ee69` in FL-32. Its window hash above is over the 77 bytes.

Untaken jump edges: none. `fl34a_fixtures.UNTAKEN_ALLOWED` is empty and every conditional jump of every function is taken both ways. Each function has one conditional jump (`jne`) plus one unconditional `jmp` over the else arm: 21 x 2 = 42 of 42 directions. None of the 21 has an unreachable block behind an always-true guard (the compare is against memory; both arms are reachable by setting the dword to 1 or not).

Per function (identical for the 21, from the disassembly; the header `original_methods_fl34a.h` has the byte-level contract): `i = dword [self+0x5c]`; when `dword [i*4 + base] == 1` (dword compare) it is set to 0, else to 1; then `0x40236a(this self)` (thiscall, no stack argument, plain `ret`). The index is read from `self` again for the store, as in the original. The index is a 32-bit register in the address computation, so the table address wraps in 32 bits; the port takes it as a signed index (fixtures use -1 and -3 with slack below the table).

## Dropped

None. The rows of `fl34b` and `fl34c` are not part of this batch and were not touched.

## Files

`src/original_methods_fl34a.h`, `src/original_methods_fl34a.c`; `tests/fl34a_direct_test.c`, `tests/test_fl34a_direct.py`; `tests/fl34a_fixtures.py`, `tests/fl34a_differential_shim.c`, `tests/test_fl34a_differential.py`; `tests/fl34a_original_oracle.py`; `tests/fl34a_mutation_check.py`, `tests/fl34a_hand_mutants.py`; `tasks/fl34a-acceptances.json`; this file. `fl34a_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (Unicorn runner `Original27` with the edge hook, stub constructor, call-log normaliser, conditional-jump finder) and the differential test imports `DiffBase` from `tests/test_fl_differential.py`; both are on main. The files were generated from the FL-32a files by a scratch script (not committed) and then reviewed. The first run of the slice tests passed, so the mutation checks below are what show that the tests are not vacuous.

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl34a_direct tests.test_fl34a_differential` -> 44 tests, OK (23 direct: 21 functions, the run-all check and the sweep; 21 differential).
- Oracle: `python3 tests/fl34a_original_oracle.py` (21 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl34a_direct_test.c src/original_methods_fl34a.c -lm` -> 22 PASS (21 functions + the bounded sweep of 300 random scenarios), no report. The sweep keeps the table index inside the fixture table (-12 .. 19 dwords; the largest row offset is 88 bytes).
- Mutation: `python3 tests/fl34a_mutation_check.py [--only <va key>]`, `python3 tests/fl34a_hand_mutants.py`.

## Hooks (oracle and differential; nothing the original decides is replaced)

Exactly one callee, 0x40236a, a recording stub entered by address (the callee is not run): thiscall(0), pops nothing, returns 0, and logs ecx and probes the whole fixture table and `self` 0x40..0x80 at the call, so the store is proved to come before the call and no neighbouring dword is touched. The table is patched into the image at the original address 0x5e60da + lo*4 per scenario (lo = -8 dwords; 65 dwords, covering the highest index plus the largest row offset); `self` is a fixture region. The oracle checks the number of bytes the function popped (0) on every run. No `rep` string move, no x87, no indirect jump, no other call.

## Deliberate divergences and native rejections

- The table index is taken as a signed 32-bit value; the original's address arithmetic wraps in 32 bits, which agrees for every index that lands inside the table (including negative ones, and the base 0x5e60d6 = element -1). An index that lands outside the host table is caller-validated, as in FL-32a. Nothing is bounds checked, as in the original.
- The frame (`push ebp; mov ebp,esp; push ecx; mov [ebp-4],ecx`) and its unwinding are not modelled; they have no observable effect beyond the `ecx = self` passed to the callee, which the stub logs.

## Unverified

- 0x40236a is a thiscall with no stack argument by its call site and by the first `ret` of its body (as in FL-32a, found by linear scan); its meaning is not recovered. The names (`toggle_<base>`) are descriptions of what the code does, not recovered source names.
- Not exercised: a callee that changes `self` or the table (nothing is read after the call, so it cannot matter here).
- The tables overlap those of FL-32a (0x5e60da / de / e2 are elements 0 to 2 of the same array; 0x5e60d6 is element -1). The port takes one world pointer for the host memory of 0x5e60da, as the packet says; whether the other native code naming these addresses agrees is for the integration owner.
- The ports and fixtures were written in the order port, fixtures, direct test; the direct test's expected values were nevertheless derived from the disassembly and not from the port's output. No independent review; no claim that any family or pool is complete.

## Mutation check

`python3 tests/fl34a_mutation_check.py` over the whole file (single textual edits: hex literal +1, `==`/`!=`, boundary, one-line guard deleted, `rd16`/`rd32` width swap; the literals include each row's table base, the shared `0x5e60da`, the call address 0x40236a and the offset 0x5c):

```
mutants 70: caught by the direct test 70, by the differential test only 0, survivors 0
```

Hand-written mutants (`python3 tests/fl34a_hand_mutants.py`, 35 of 35 CAUGHT by the direct test, 0 survivors): `!= 0`, 16-bit compare, `& 1`, 16-bit unsigned index at the read and at the store, wrong stored values (2, 0xffffffff), a store to the next dword, index scaled by 2, store and call swapped, a wrong `this` of the call (0 and self+1), a wrong callee (0x404be1), and, for each of the 21 rows, the table base of the neighbouring row in place of its own (21 mutants). Known gap of the tool: mutants are single textual edits; multi-line guards and double edits are not modelled. The differential test was not needed to catch any mutant (the direct test is strict enough); it runs for any mutant the direct test lets through.

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; `Fl34aWorld.table_5e60da` must point to host memory that mirrors the dword array at the original address 0x5e60da (the 21 toggles use the offsets -4 and 12 .. 88 from it) with slack for a negative index and room up to 0x5e6132 + 4 * the highest index. The host binding of 0x40236a is called with ecx = the host pointer of `self`, no arguments.
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, of the files in the code commit `a81e350c`; this handoff is added in the next commit)

| file | sha256 |
|---|---|
| src/original_methods_fl34a.c | 219c90ef822b0440f9a170b3b763e0fe58f9a9467e2a1f83022222270bfa15c8 |
| src/original_methods_fl34a.h | c737cfcf05a0e60a898645911698a62a0ad6783c1099b866969fa9b0f766110c |
| tests/fl34a_original_oracle.py | ce83aa8f6ef992f9cb6419fc2ef12537211702b5b1d2d111a05cd5760e175a63 |
| tests/fl34a_fixtures.py | 7e67fc08fd19754a0cceede3d40fba1cad745abb0d2f93aa325cb48a06363ebd |
| tests/fl34a_direct_test.c | 6507cfd0dee4cfda60b20bacf8021f8aa0d2879b33c4ce6994fe1c82c59dc54a |
| tests/fl34a_differential_shim.c | 4fdb0f1cb88e452a4dd9a92c34d14d8d2c6716d33c72fc6109749d20fefdf7ae |
| tests/test_fl34a_differential.py | c47e22f05473b1e7b90b0f78de4b8d42dfee888267ae8c34d0fefd5771236165 |
| tests/test_fl34a_direct.py | b13f4aae221f6e6ea486d73a2b31e5253831e9ac33eebbf0837caf2855405a12 |
| tests/fl34a_mutation_check.py | 6a7c3e140bae00df66c9635925a3aa3f496514ff9859c468bf7a960a38342b1d |
| tests/fl34a_hand_mutants.py | 1a4b6df2f4b350015d8e7956efaeca3316a6faa250b42efce36eaadfd86449c1 |
| tasks/fl34a-acceptances.json | 78c7742b00815cd378bab667ddef392c744969faffd0e8d2a058b7d89deb6d95 |

Native library: the differential builds `tests/fl34a_differential_shim.c` + `src/original_methods_fl34a.c` into a throwaway shared object per run (no committed binary).
