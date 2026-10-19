# FL-23 batch b handoff (12 of 12 ported)

Branch `worktree-agent-ac2a937edae11e8a1` (worktree `.claude/worktrees/agent-ac2a937edae11e8a1`), reset to `claude/fl23-session-input-ez2f5f` at 504e5607 (the packet commit) before any work; the commits on top are listed in the final report (the tip is the final commit). An independent slice-reviewer pass has not been done. The ledger, override, evidence and execution files were not touched.

## Ported symbols (`src/original_methods_fl23b.c/.h`, `Fl18Host` convention, `Fl23bWorld`)

All twelve are thiscall (`ecx` = the session object `self`), plain `ret`, no stack argument; all return `void` (the original leaves garbage in eax). Each is a chain of guards on the object, then `dword [n * 0x8d + 0x5bb632] == 1` for the signed word `n` of the object, then the selector `0x5c39e5`; the arms are 1:1 with the disassembly (checked against `work/original/GAME.EXE`, not the ledger names).

| va | span | symbol | selectors | callees (host) | differential and oracle (224 scenarios) |
|---|---|---|---|---|---|
| 0x4a1efd | 92 | `m4a1efd_click_2760` | 2760 | none | 29/29 instructions |
| 0x4ba4f2 | 120 | `m4ba4f2_click_276a` | 276a | tick, 0x4fb2e3 | 32/32 |
| 0x46957d | 122 | `m46957d_click_272e` | 272e | none | 31/31 |
| 0x4b45ed | 137 | `m4b45ed_click_2739` | 2739 | none | 33/33 |
| 0x473ffc | 162 | `m473ffc_click_27a1` | 27a1 | 0x4e26fc | 44/44 |
| 0x48e851 | 237 | `m48e851_click_27b8_27b9` | 27b9, 27b8 | none | 61/61 |
| 0x45e587 | 246 | `m45e587_click_27ec_27ef` | 27ef, 27ec, 27ed | 0x45e6bd | 57/57 |
| 0x48ab49 | 329 | `m48ab49_click_2756_2757` | 2757, 2756 | tick, 0x4f6334, 0x4fb2e3 | 80/80 |
| 0x4ab899 | 353 | `m4ab899_click_27ce_27d0` | 27d0, 27ce, 27cf | tick, 0x4fb2e3 | 88/88 |
| 0x4574e4 | 358 | `m4574e4_click_27bc_27be` | 27bd, 27be, 27bc | tick, 0x4f6334, 0x4fb2e3 | 89/89 |
| 0x47a03c | 365 | `m47a03c_click_279c_279d` | 279d, 279c | tick, 0x4f6334, 0x4fb2e3 | 83/83 |
| 0x4b2a9e | 404 | `m4b2a9e_click_2792_2793` | 2793, 2792, any other | tick, 0x4fb77a, 0x4fb2e3 | 97/97 |

Dropped: none. Remaining: none.

## Files (all owned by this batch)

`src/original_methods_fl23b.c`, `src/original_methods_fl23b.h`, `tests/fl23b_direct_test.c`, `tests/test_fl23b_direct.py`, `tests/fl23b_differential_shim.c`, `tests/test_fl23b_differential.py`, `tests/fl23b_fixtures.py` (generator, original-run function, shared by the differential test and the oracle), `tests/fl23b_original_oracle.py`, `tests/fl23b_mutation_check.py`, `tasks/fl23b-acceptances.json`, this note.

## Commands and results

From `outputs/blackmoor-decomp` (the scratch machine has `clang`; `PATH` needs no `xcrun` shim for these tests):

- `python3 -m unittest tests.test_fl23b_direct tests.test_fl23b_differential` : 25 tests OK (direct: 1 all-cases check + 12; differential: 12).
- `python3 tests/fl23b_original_oracle.py` : exit 0, 12 lines `0x... instructions N/N scenarios 224 digest ...` (all N/N, table above). Run as a plain script and under the recorder (`BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl23b_original_oracle.py`): both exit 0 with byte-identical output (the digests are deterministic; one trace file was written).
- Direct tests (`tests/fl23b_direct_test.c`, expectations hand-derived from the disassembly): per function (1) a guard matrix: every guard of the chain failing in turn (several fail values each, widths probed: a byte guard has 0xA5 neighbours, a dword guard fails on a value only in its high byte, a word guard has a junk upper half, the record-state guard fails with 0, 2, 3, 0xffffffff, 0x101, 0x10001 while every decoy record is in state 1) with every selector of the function and an unrelated one: object, record table and call log must be untouched; (2) each arm with the whole object, the record table and the record object compared with a hand-edited copy, the ordered host calls (callee, ecx, argument count, arguments with word masks) and the object and table as they are at each call (so a store before or after a callee is caught), GetTickCount as an ordered event with wraps (0xffffff40, 0xfffffff0, 0x7fffffff); (3) both with record index 2 and -1 (the index word is signed; the table has a slack record); the nine-byte compare with every differing byte position 0..8, an equal field, a difference only at byte 9 (not compared), with the 0x5bb1ca flag zero and non-zero (0x100); the 0x4f6334 answer zero and non-zero; negative and wrapping items (0x4574e4, 0x48e851) and indexes (0x4ba4f2, `n` = 0, 3, -1).
- Unicorn differential (`tests/test_fl23b_differential.py`, shim `tests/fl23b_differential_shim.c`, fixtures `tests/fl23b_fixtures.py`): original bytes vs native on the same generated fixtures, 224 per function (2688 total). The profile cycle fails each guard in turn (the record-state guard too) and passes each selector (and an unrelated one), with the flag, the nine-byte position and the scripted 0x4f6334 / 0x4e26fc answer varying by the pass number. Compared per scenario: all of the object, the record table, the record object, the globals, the ordered calls with ecx and arguments (pointers into a fixture as the original addresses they stand for, word arguments by their low 16 bits), the object and the record table at each call, and the tick events. Every instruction of every body was reached in the original (table above), so no branch edge is claimed beyond instruction reach, except as listed under "unverified".
- ASan/UBSan: the clang runtime library for ASan is not installed here, so the direct binary was built with `gcc -fsanitize=address,undefined -fno-sanitize-recover=undefined -fno-omit-frame-pointer` at -O0, -O1 and -O2 : all 13 cases clean, no sanitizer output. The direct binary includes a bounded random sweep (`sweep()`, 3000 random objects, record tables, selectors and guard states per function, the index words the original does not bound kept inside the fixture): it checks no value, only that nothing reads or writes outside the buffers. The Python differential cannot be sanitised (capstone/unicorn), as in FL-22.
- Mutation check: `python3 tests/fl23b_mutation_check.py` (committed; about 4 minutes): 398 mechanical mutants of the port (a hex literal +1, `==`/`!=` swapped, a guard line deleted, `rd16`/`rd32`/`rds16` swapped), 376 caught by the direct test, 4 more by the Unicorn differential, 18 survivors, all equivalent: 13 are `rd16 -> rd32` where the value goes straight into `wr16` (which truncates) or into a word-typed host-call argument (compared by its low 16 bits by the word-argument contract), and 5 are `rds16 -> rd16` on a compare with 0 or 0x64 (`movsx` and `movzx` agree there). The first run left 21 survivors; the three real misses were fixed in the fixtures (a copied word whose neighbour bytes were forced equal by the byte-gate fill, a gate `dword != 0xa` never tried with `0x1000a`, and the redundant second test of the word `[+0x1531]` in 0x4b2a9e, which needs the byte after the word to be zero).

## Hooks (all are OS or host boundaries; none replaces a decision of the original)

Recording stubs entered by address, popping the stack arguments of the callee, with a scripted `eax`: 0x4fb2e3 (this 0x5c3a67, one word argument, `ret 4`), 0x4f6334 (this 0x5cf1eb, one dword argument that is a sign-extended word, `ret 4`, returns 0 or non-zero), 0x4fb77a (this 0x5c3a67, one argument, `ret 4`), 0x4e26fc (this = self + 0x1a6, no argument, plain `ret`, returns 0 or non-zero), 0x45e6bd (this = self, three arguments, `ret 0xc`; the callee reads its third argument with `movsx word`), and GetTickCount (IAT slot 0x52a23c, an ordered `tick` event in both logs). The `repne scasb`, the `repe cmpsb` nine-byte compares, every `imul`, `movsx` and compare run as original code. The stubs log the state of the object and the record table at the call; none of them changes memory.

## Hashes

- Original GAME.EXE: afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45 (unmodified; the ledger oracle window hashes equal the hashes of these windows).
- Code windows (sha256 of the original bytes from the start of the function for `span` bytes; each equals the `window_sha256` of the existing ledger oracle entry for the same window):
  - 0x4a1efd..0x4a1f59 c4c19b2830215f189f9c423872456c4c3081c369e4be2ca7aae4a33adb86e38b
  - 0x4ba4f2..0x4ba56a af72397b3c79d1f50f815fa4052421b5c7cb17ba76b3692f7631f45bf46ce6a3
  - 0x46957d..0x4695f7 80b7f56dc174e7c01be3ac228f175a926654df090098a76be286918639e9805e
  - 0x4b45ed..0x4b4676 cdcd926c8596d2ac7759765cd0e1813ebd35172a4e6a7a7ff6d6f30fbda7fc9a
  - 0x473ffc..0x47409e 7b9efe3cd9a0f47be555142f86e3ef25c49e1b99ee7df21719949299f6b36300
  - 0x48e851..0x48e93e 6cfc40b56e91d0ad63aea3f570a56afdb5b27386d4738b0276607df56b0864d1
  - 0x45e587..0x45e67d 7b649a2256937de9f6c08eef7db6c69ec34b146fdc587f18c55bf2dbaf24e6e7
  - 0x48ab49..0x48ac92 35eb42fc1dced8cbe514a122e33d1fb946c9e98e787f561111f93de1a11534d0
  - 0x4ab899..0x4ab9fa b8bca82e2a683874ce0dc476da69240f7d48db523c23b41c1ca1f0b17b836a48
  - 0x4574e4..0x45764a 0225ab2aa7114245eed06245911867bb28fece8e4fef1e1e0ddf3e2bf34a83a7
  - 0x47a03c..0x47a1a9 b9bdb49708ab5294f09473f5dc4f7e14d20a417cde5818726c8f91c4bb28563e
  - 0x4b2a9e..0x4b2c32 fd8b4da13e9aea0341c81505f4fac7c14e23640ce3e11a20d1039ff455c886ce
- Source and test hashes: `sha256sum` of the owned files at the final commit (run `git show --stat HEAD`, then `sha256sum` the paths under "Files"); the oracle's per-function digests are in the oracle output.
- Oracle digests (sha256 over the ordered call logs and the memory read back of all 224 scenarios, deterministic, identical plain and under the recorder; prefixes, the full values are printed by `python3 tests/fl23b_original_oracle.py`): 0x4a1efd 9ba6a92e48c3ca2a, 0x4ba4f2 63e9e976e1e8de99, 0x46957d eb2dd613bb587894, 0x4b45ed aa22f28d06169b91, 0x473ffc db54da65e79ea688, 0x48e851 8cc5bbb0fe5a1f7a, 0x45e587 10148f62d425a5fd, 0x48ab49 1b4b83d4adbacf79, 0x4ab899 7f227b145c6a6d15, 0x4574e4 d3203b3e423d1861, 0x47a03c 9d4c781806c64712, 0x4b2a9e 88aedec6cd96f823.

## Deliberate divergences and known limits

- Return value: `void` (the original leaves garbage in eax).
- 0x48e851: the original scans the 17-byte string with `repne scasb` and clears it when `strlen != 0`. The native port tests the first byte, which is the same condition without reading past the object when the string has no terminator. Equivalent for every input the original handles; the original's unbounded scan on an unterminated string is not reproduced (it would read past the object).
- No bounds checks (as the original, as in FL-22): the record index word (`n * 0x8d` into the 0x5bb5e5 table), `[+0x2d4]` of 0x4ba4f2 (a signed dword here; the original adds it to the object address in 32 bits and stores at `+0x24 + 8n` and `+0x28 + 8n`), the item word `[+0x3fe]` of 0x48e851 (`+0x200 + 0x11 * item`) and the item word `[+0x42]` of 0x4574e4 (`record + 0x31 * item + 0x197 / 0x1b8`) all index unchecked. Callers and loaders must keep them inside the object, the table and the record object.
- Word arguments to 0x4fb2e3 and the third argument of 0x45e6bd compare by their low 16 bits; the original pushes `dx` / `cx` with leftover upper halves.
- Uninitialised locals: none are read. The record object address is read at entry where the original stores it in `[ebp-4]` and the object is re-resolved through `Fl18Host.resolve` at every use, as the original re-reads memory after each call.
- 0x4b2a9e: the original tests the word `[+0x1531]` a second time (0x4b2bd6) with nothing between that can change it, so the taken edge of the `je` at 0x4b2bdf cannot occur; the instruction is reached, the edge is not (and cannot be fixtured without a callee that changes the word, and there is no call in between).

## Unverified branches

- Callees that change `self`, the record table or the record object (for example 0x4f6334 or 0x4fb77a modifying a field that the function reads again afterwards): the stubs change nothing, so those re-reads are by inspection only (the port re-resolves the record object and re-reads `self` after each call, in the original order).
- The unbounded indexes above are not compared with the original outside the fixture ranges (record index -1..4, `[+0x2d4]` -1..6, items -1..5).
- The callers (0x43a7ca) and the callees listed under hooks are not part of this slice. No independent review has been done.
