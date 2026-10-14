# Tool-assisted reconstructed assembly (packet M03)

These `.s` files are Intel-syntax GNU assembly generated mechanically from the owner's local `GAME.EXE` by `scripts/gen_hinted_asm.py`, then annotated by an implementer (function, label and frame names, comments, field and callee notes, the Track N cross-reference, unverified branches). `scripts/audit_tool_assisted.py` reassembles each file with the pinned `i686-w64-mingw32-as` 2.43.1 and compares it with the original; an independent review then confirms that the names and comments describe what the bytes do. Only a function that passes both counts in the class `tool_assisted_reconstructed_assembly`, reported separately from `explicit_reconstructed_assembly_source`. Nothing here claims original C++ or compiler provenance, and no original code, data or resource bytes are committed (hashes and sizes only).

## Commands

```sh
# generate annotated-ready sources and the data-item description for M02
python3 outputs/blackmoor-decomp/scripts/gen_hinted_asm.py gen 0x4db000 --out outputs/blackmoor-decomp/asm
# census: reassemble every indexed function and report exceptions (private output)
python3 outputs/blackmoor-decomp/scripts/gen_hinted_asm.py census --out work/analysis/slices/M03-census
# build the batch manifest from annotated sources, then audit it
python3 outputs/blackmoor-decomp/scripts/gen_hinted_asm.py manifest <VAs...> --sources outputs/blackmoor-decomp/asm --batch 001 --description "..." --out outputs/blackmoor-decomp/asm/batch-001.json
python3 outputs/blackmoor-decomp/scripts/audit_tool_assisted.py outputs/blackmoor-decomp/asm/batch-001.json --report outputs/blackmoor-decomp/asm/batch-001-report.json
# tests (generator, auditor mutants, verifier)
cd outputs/blackmoor-decomp/tests && python3 -m unittest test_gen_hinted_asm test_audit_tool_assisted test_verify_matches
```

## What a generated file contains

* A header: VA, extent, SHA-256 of the original code extent, evidence id, region, frame kind, and the annotation fields (`name`, `arguments`, `locals`, `fields`, `callees`, `track-n`, `unverified`).
* `.org <va> - 0x401000`, the global symbol `FUN_<va>`, local labels at every branch target, `{load}`/`{store}`/`{disp8}`/`{disp32}` prefixes, `.d8`/`.d32` branch suffixes and `.insn` only in the five spellings of the M0 report (section 5). Every `[ebp±n]` offset is a named `.equ`.
* External call and jump targets are `.set FUN_<va>, .text + (<va> - 0x401000)`, so the object carries no relocation. Exception: GNU as cannot size a short branch (`eb`/`7x`) to such a symbol and falls back to rel32, so a short branch to another function is written `jmp.d8 . + (<disp>)  # -> FUN_...`.
* Switch tables, index tables and padding are separate data items after the code part (`SWTAB_<va>` with `.long <case label> - .text + 0x401000`, `IDXTAB_<va>` with `.byte` index values, `PAD_<va>` with `.fill n, 1, 0xcc|0x90` or nop-equivalent instructions). Data items are not part of the function symbol and are handed to M02 in the audit report (`data_items_for_m02`).

## Census of the whole `.text` (private run, summary in `census-summary.json`)

The generator splits the span of every function (entry to next indexed start) into code, tables and padding by following the function's own control flow, reassembles all of it in one pass and compares every byte. Code that the span split finds after a function's last reachable instruction and its tables (instructions only reached from other functions: import thunks, shared tails, unindexed library routines) becomes a *derived* function with its own symbol. Instruction-like alignment padding (`lea r, [r]`, `mov r, r`, `nop`, `int3`) is padding, not code.

| Region | Functions (derived) | Code bytes | Exact | Switch tables | Index tables | Padding | Unsplit |
|---|---:|---:|---:|---:|---:|---:|---:|
| game | 2,514 (7) | 1,023,548 | 1,023,548 | 5,236 | 1,934 | 1,202 | 0 |
| Vorbis/ogg | 203 | 60,076 | 60,076 | 64 | 0 | 1,396 | 0 |
| CRT/MFC | 2,014 | 116,524 | 116,524 | 316 | 0 | 1,080 | 1,642 |
| total | 4,731 (543 derived of 4,729 split) | 1,200,148 | 1,200,148 | 5,616 | 1,934 | 3,678 | 1,642 |

The classified bytes plus the unsplit span add up to the `.text` virtual size 1,213,018. Mismatching bytes: 0. Relocations in the census object: 0. Hint counts: `{load}` 20,642, `.d8` 22,051, `.d32` 7,943, `.insn` 384, `{disp8}` 99, `{store}` 28, `{disp32}` 2. M0's linear-sweep figure (1,205,254 bytes) was a round-trip number, not a code total; the code total here is 1,200,148.

**Exceptions (listed, not hidden).** Two spans are left unsplit: the CRT block copy routines `FUN_0050ed50` and `FUN_0050fa90` (1,642 bytes in all). Their jump tables sit between code blocks, and one table base lies four bytes before its first live entry, so the contract "code part, then tables, then padding" does not describe them. They need a multi-part code description and are left for a later batch. Seven derived fragments fall through into the next function instead of ending in `ret`/`jmp` (`0x00510a4b`, `0x00513843`, `0x0051aaf4`, `0x0051cb35`, `0x0051dfef`, `0x0051e24e`, `0x0051ebf2`): their bytes reassemble exactly, but the auditor refuses them until a rule for fall-through fragments is agreed. M0 estimated 173 jump tables; the split found 158 dword tables in split spans plus the tables inside the two unsplit spans.

## Batch 001 (`batch-001.json`, `batch-001-report.json`)

Forty-six functions, 12,522 code bytes (game 11,471 in 42 functions, Vorbis region 1,051 in 4 functions) plus 7 data items (one 20-byte switch table and six padding runs, 63 bytes) for M02. The audit accepts all 46: zero mismatching bytes, zero relocations, every basic block commented, every frame offset named.

| Group | Functions |
|---|---|
| S08-2/3/4 families (cross-check of the hand-written sources) | 0x4dae66 0x4dae77 0x4daef1 0x4daf02 0x4daf18 0x4daf29 0x4daf3f 0x4daf6e 0x4daf9f 0x4dafc3 0x4db000 |
| CIF archive and pixels | 0x419dab 0x41a19c 0x41b6e2 0x4c7314 |
| Dependency and condition reducers | 0x42406d 0x424201 0x423d33 0x423da2 |
| CHiff | 0x433c60 0x433eaa 0x434025 0x43423d 0x4343a2 0x4344bf 0x434630 0x434773 0x434814 |
| Boot and world init | 0x44aff2 0x43dbd5 0x433bd2 0x438150 |
| A-37 constructor | 0x48945b 0x4895cc |
| HIS PCM output path | 0x4fe2d0 0x4fe290 0x4ff9a0 0x4ffa00 0x4f5b50 |
| Sound control | 0x4f55d5 0x4f6059 0x4f684a 0x4faa03 0x4fadc4 0x4fcb5c 0x4fccf2 |

Delta against the 398-byte hand-written baseline, without double counting: 384 of the batch's code bytes overlap the baseline (the S08 functions, which stay in their own class), so 12,138 code bytes are new. The baseline's 398 bytes are not added a second time.

Deferred to batch 002 because of size or because they have no function-level Track N counterpart: 0x435015 (9,727 bytes), 0x4381f4 (5,629), 0x4181c6 (3,212), 0x418e52 (2,819), 0x424aa8 (4,323), 0x424346 (1,782), 0x4f2710, 0x4f379c, 0x4f3c26, 0x4f438f, 0x4fc341, 0x4fc62d.

## Things the annotation found that matter to later work

These are recorded per function under `unverified` and are not changes to the bytes:

* Several original routines report an error and then keep executing instead of returning (CHiff index functions, the A-37 allocator, CIF open). Track N rejects these; the native port must reject them explicitly.
* `0x4fadc4` is the whole `CSound::LoadDIGISound` routine, but Track N's `sound_control_calculate_attenuation` covers only its two attenuation expressions; Track N's "fade" labels for the three calls under flag 0x20 in `0x4f55d5` are unproven.
* `world-init-recovery.md` spells the default time-record string with an underscore; the original bytes at 0x545dd4 have a space.
* `0x4fe2d0` has the call shape of libvorbisfile's `ov_read`; Track N covers only its quantization loops.
