# FL-38c handoff: five small shapes below 0x480000 (24 rows)

Branch `fl38c-work` (worktree `/home/user/wt-fl38c`). Every row's whole instruction stream was asserted against its shape (the generator, outside the repo, rebuilt the full expected stream from the row's constants and compared it to the disassembly, jump targets included; `Fl38cDifferential.test_whole_instruction_streams` re-asserts the masked equality from GAME.EXE).

## Ported (24, class `native_oracle_verified`)

| shape / symbol | bytes | rows |
| --- | --- | --- |
| `read_word_setting`: 0x51d5b2 (thiscall on this+off; args local, 0x13) reads a string into a local, 0x50cb1b (cdecl) converts it, low word to a word global, then a method of this is called | 59 | 40430e (+0x18c, [0x5e5686], 0x4033db), 404349 (+0x14c, [0x5e5684]), 40492f (+0x38c, [0x5ec33a]), 40496a (+0x3cc, [0x5ec284]), 4049a5 (+0x44c, [0x5ec288]), 4049e0 (+0x40c, [0x5ec286]), 40893f (+0x94c, [0x5ec2d4], last call 0x407ca7) |
| `read_time_setting`: same read, result stored into one of three fields of entry [0x5c3a63] (stride 0x106) of a table, then field0 = f(+0xc)*3600000 + f(+8)*60000 + f(+4)*1000, then 0x4033db | 164 | 4043b6 (+0x24c, base 0x5e569e, store +0xc), 40445a (+0x20c, +8), 4044fe (+0x28c, +4), 4045a2 (+0x30c, base 0x5e56b2, +0xc), 404646 (+0x2cc, +8), 4046ea (+0x34c, +4) |
| `shift_rect`: ret 8, dst +4/+0xc = src + [0x58318a], dst +0/+8 = src + [0x583186] | 83 | 454f29 457071 458137 46453b 466db1 479d98 (six identical copies, all constants equal) |
| `new_zeroed`: p = 0x51dc43(size) stored at *out; p == 0: 0x50ca3e(0x63888b, fmt), 0x4264e8, debug 0x44a2b7, 0x4c97b4; else size bytes zeroed (rep stosd/stosb); ret 8 | 139 | 4465fd (fmt 0x54824c), 4547bc (fmt 0x549e28) |
| `clamp_to_bounds`: signed clamp of two axes of a rectangle in `this` into four global bounds, keeping int16 extents | 207 | 454f7c (fields 0x4e/0x56 and 0x4a/0x52, extents +0x16c/+0x16a), 46458e (same fields, extents +0xd4/+0xd2) |
| same, wider displacements | 255 | 46b855 (fields 0x49f8/0x4a00 and 0x49f4/0x49fc, extents +0x816c/+0x816a); the packet said 207 bytes, the ledger and the disassembly say 255; the masked stream equals the 207-byte shape |

## Dropped

None. 4465fd and 4547bc and the three clamp rows were taken because their whole masked streams match their group and the oracle covers everything.

## Oracle (`python3 tests/fl38c_original_oracle.py`)

N/N instructions for every row (20/20, 39/39, 27/27, 45/45, 63/63) and both directions of every conditional jump: new_zeroed 4/4 (`jne` after the allocation, `je` on the debug word), clamp rows 8/8; the straight-line shapes have no jumps. Allowlist `UNTAKEN_ALLOWED` is empty. No x87, no indirect jump, no unreachable code.

## Models and divergences

- 0x4c97b4 (called by new_zeroed when the allocation failed) was read: it conditionally calls 0x43d7c4, then `PostQuitMessage([0x63a58a])` (import 0x52a48c) and RETURNS (plain `ret`). So it is a returning stub here, not a halting one, and the `jmp` after it (skipping the zeroing) is executed and covered. (The fl38b batch models the same callee as not returning; its path then copies into address 0, which is why it stops there.)
- Callee shapes read from the call sites and callee `ret` instructions: 0x51d5b2 thiscall `ret 8` (args: local pointer, 0x13), 0x50cb1b cdecl 1 argument, 0x4033db / 0x407ca7 / 0x4c97b4 thiscall no arguments, 0x4264e8 thiscall `ret 4`, 0x50ca3e cdecl 2 arguments, 0x44a2b7 cdecl 1 argument, 0x51dc43 cdecl 1 argument. 0x51d5b2 is a stub that writes a scripted 0x13-byte string through its first argument (the local of the function); 0x50cb1b logs the bytes it was given. The final callee of the two reading shapes logs the state (the word global, resp. the whole table) at its call, so the order "store, then call" is checked.
- The ports of the two reading shapes return the last callee's eax (the original's eax at `ret`); that value is compared. shift_rect, new_zeroed and clamp_to_bounds return nothing (their eax is garbage by design).
- The table of read_time_setting is addressed with a signed 32-bit offset (index * 0x106 wraps in 32 bits like the original; tested with index -1 with slack below the table); the index is re-read for every access. No bounds checks, as in the original. Direction flag assumed clear.
- shift_rect takes host pointers for src and dst (src and dst may overlap; the four stores are in the original order and each source field is read after the earlier stores; overlaps are tested). `this` (ecx) is stored and unused by the original and is not a parameter of the port. new_zeroed takes the out cell and the block as original addresses resolved with `host->resolve`.

## Tests and results (from outputs/blackmoor-decomp)

- `python3 -m unittest tests.test_fl38c_direct tests.test_fl38c_differential`: 51 tests OK (direct: 24 rows + exact-size buffers + every-case; differential: 24 rows + whole-instruction-streams).
- `python3 tests/fl38c_original_oracle.py`: 24 rows, all N/N, all branch directions.
- `python3 tests/fl38c_mutation_check.py`: 116 rounds (per-shape row constants, and one place at a time of the shared bodies) = 590 mutants over the rows, 0 survivors, no build failures (both the direct and the differential test of every affected row must fail).
- direct test built with gcc `-fsanitize=address,undefined`: clean (the clang sanitizer runtime is not installed here).

## Unverified / for the reviewer

- Acceptance `reviewer` is a placeholder ("Sonnet 5.5 implementer, self-checked, independent review pending (FL-38c)"); the root replaces it.
- Names (`read_word_setting`, `read_time_setting`, ...) are descriptive guesses from the arithmetic; the callees 0x51d5b2, 0x50cb1b, 0x4033db, 0x407ca7 were not read beyond their `ret` forms and calling shapes.
- Not exercised against a real callee: the ABI of 0x4264e8 (one argument, callee pops) is as read from the call site and its `ret 4`.
- Process note: one `mcp__hearthbot__no_reply_needed` call was made by mistake at the end of a wait (it carried no content and had no effect on the files).

Commit: see `git log -1` on `fl38c-work`.
