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

The generator splits the span of every function (entry to next indexed start) into code, tables and padding by following the function's own control flow, reassembles all of it in one pass and compares every byte. Calls are interprocedural edges: a called helper inside the same span is not absorbed into its caller's extent. Code that the span split finds after a function's last reachable instruction and its tables (instructions only reached from other functions: import thunks, shared tails, unindexed library routines) becomes a *derived* function with its own symbol. Instruction-like alignment padding (`lea r, [r]`, `mov r, r`, `nop`, `int3`) is padding, not code.

| Region | Functions (derived) | Code bytes | Exact | Switch tables | Index tables | Padding | Unsplit |
|---|---:|---:|---:|---:|---:|---:|---:|
| game | 2,514 (7) | 1,023,548 | 1,023,548 | 5,236 | 1,934 | 1,202 | 0 |
| Vorbis/ogg | 203 (25) | 60,076 | 60,076 | 64 | 0 | 1,396 | 0 |
| CRT/MFC | 2,035 (532) | 116,524 | 116,524 | 316 | 0 | 1,080 | 1,642 |
| total | 4,752 (564) | 1,200,148 | 1,200,148 | 5,616 | 1,934 | 3,678 | 1,642 |

The figure in parentheses is the number of *derived* functions (code found by the span split, not in `function-index.json`). Of the 564, only 49 have a direct call or jump to them from a classified code part; the other 515 (17,742 code bytes) have no direct reference (they may be reached through vtables or other data pointers, or not at all). They are byte ranges that decode as terminated code after a function's last reachable instruction, reproduced exactly but not proven to be functions; the census code total includes them. Batch 001 contains none of them; batch 009 (below) holds 554 of the 564. The classified bytes plus the unsplit span add up to the `.text` virtual size 1,213,018. Mismatching bytes: 0. Relocations in the census object: 0. Hint counts: `{load}` 20,642, `.d8` 22,051, `.d32` 7,943, `.insn` 384, `{disp8}` 99, `{store}` 28, `{disp32}` 2. M0's linear-sweep figure (1,205,254 bytes) was a round-trip number, not a code total; the code total here is 1,200,148. That denominator excludes the 1,642 bytes of the two unsplit spans (their code share is still unclassified) and includes the 38 bytes of the seven fall-through fragments below, which the auditor currently refuses, so the auditable code total is 1,200,110.

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

## What the auditor does and does not prove

The auditor reassembles each file with the pinned assembler (pinned by its version line `GNU assembler (GNU Binutils) 2.43.1` plus a self-test: a fixed source that exercises every encoding hint must assemble to exactly the expected bytes, including the section alignment padding, so a build of the pinned binutils on any machine passes and a wrapper that merely prints the version does not), rejects any relocation, compares the code part and every data item with the original through `verify_matches.py`, requires the whole object `.text` to equal the original bytes over the entire span (nothing may be appended after the final `ret` or after a data item), and decodes the assembled code part with `llvm-objdump` to confirm it decodes contiguously to a terminal instruction. Lines must be a label, a whitelisted directive form, a `.insn` in one of the five spellings, or an instruction whose mnemonic occurs in the original's code; statement separators, `label: statement`, `.incbin`, macros and C-style comments are rejected. Every register-relative displacement (frame `[ebp±n]`, stack `[esp+n]`, object field `[reg+n]`) must be a named symbol, header fields must be filled, and every basic block needs a real comment. Jump and switch index tables, and only those, may be `.byte` lists, in an `IDXTAB_<va>` data item whose comment names the owning function and the address of the switch jump (the auditor compares that address with the one derived from the original). It does **not** prove that a name or comment is true (that is the independent review), and the span split itself is the generator's analysis, cross-checked by the decode test above rather than by a second analysis.

## Batch 002 (`batch-002.json`, `batch-002-report.json`)

Forty game-region leaf functions (no direct calls) of 250 to 700 bytes, largest first, not already in batch 001: 20,790 code bytes in 40 functions, plus 6 data items (four switch tables of 16, 20, 24 and 16 bytes, one 61-byte index table and one 6-byte padding run, 143 bytes) for M02. The audit accepts all 40 (0 mismatching bytes, 0 relocations); no byte overlaps the 398-byte hand-written baseline, so all 20,790 are new. Three independent reviewers found no wrong claim about the bytes; their wording findings (callers, payload-pointer naming, cursor globals, hedged inferences) are applied. Almost none of these functions has a Track N counterpart: `track-n` is `host-adapter: none` except where a partial real counterpart is named, and every class or method name is an annotator label recorded as such under `unverified`.

Batch 001 and 002 together: 86 functions, 33,312 code bytes. Since the 2026-10-14 rulings every register-relative displacement (frame, stack, object field) is a named symbol, jump/index tables may be `.byte` lists only when labeled with their owning function and switch, and the assembler is pinned by version plus a self-test (see `AGENTS.md`).

## Batches 003 to 008: machine annotation of every remaining indexed function

Glib's ruling (2026-10-15, decision card on the planning thread): machine-generated names are valid Track M annotation, so bulk annotation can be scripted and a human renames later without touching the bytes. `scripts/annotate_machine.py annotate` fills the generator's annotation fields from the instruction bytes and `function-ledger.json`, and `scripts/annotate_machine.py manifests` writes the batch manifests (700 functions each, address order). Each file carries `# annotation:  machine`, and only then does `audit_tool_assisted.py` accept the generator's default symbol names (`arg_8`, `local_4`, `field_2c`, `stk_4`) and the function name `fn_<va>`; every other audit rule is unchanged (pinned assembler, no relocation, byte-exact code part and data items, named displacements, a meaningful comment per basic block, filled header fields).

What the script writes, and nothing else:

* `arguments`: the `[ebp+n]` slots referenced, the `ret n` pop size, and whether `ecx` is read in the entry block before it is written (hedged as a probable `this` pointer);
* `locals`, `fields`: the `[ebp-n]` slots and the register-relative displacements per base register (a base-less scaled index such as `[4*eax + 0x4]` is named too; absolute table bases stay numeric);
* `callees`: direct call and tail-jump targets as `FUN_<va>`, import-table calls as `DLL!Symbol` from `image/imports.json`, and a count of indirect transfers that are not resolved;
* `track-n`: the native symbol the ledger records, only for the ledger classes that claim a counterpart (`native_oracle_verified`, `native_tests_only`, `host_adapter_tested`, `candidate_port`), otherwise `host-adapter: none`; the audit checks that the file exists and the symbol is a whole word in it;
* `unverified`: the machine-only caveat with the instruction, conditional-branch and jump-table counts;
* one comment per basic block: how it is entered, call targets and how it ends.

No branch condition, argument meaning, field meaning or return value is interpreted. `annotate_machine.py check` regenerates every machine-annotated source from the original and requires identical text apart from the `track-n` line (which follows the ledger and is validated by the auditor instead, so a ledger refresh does not force a re-audit), so a machine header cannot hide a hand edit; the header is matched as loosely as the auditor matches it (a renamed, reviewed function drops the header and goes through the hand-annotation audit instead). `tests/test_audit_tool_assisted.py` covers the machine mode (accepted batch, wrong name, unnamed offset, default names without the header, empty block comment) and regenerates a sample of committed sources.

| Batch | Functions | Code bytes |
|---|---:|---:|
| 003 | 700 | 285,792 |
| 004 | 700 | 281,442 |
| 005 | 700 | 306,703 |
| 006 | 700 | 189,707 |
| 007 | 700 | 72,444 |
| 008 | 590 | 10,208 |
| total | 4,090 | 1,146,296 |

By region: game 2,425 functions (991,245 bytes), Vorbis 174 (51,977), CRT/MFC 1,491 (103,074); 42,301 basic blocks; the data items handed to M02 are 151 switch tables (5,472 bytes), 18 index tables (1,873) and 406 padding runs (2,583). With batches 001 and 002 that is 4,176 functions and 1,179,608 code bytes, 78.05% of the 1,511,424-byte file; the rest is `.data`, `.rdata`, resources, headers and the exceptions below. Reassembly is exact for all of it (0 mismatching bytes, 0 relocations, assembler self-test passed).

Exceptions, not hidden (12 indexed functions, left for a later rule; the two unsplit spans alone are 1,642 bytes): `0x0050ed50` and `0x0050fa90` (CRT block copies, jump tables inside the code, unsplit span), `0x00513843` (falls through into the next function), and nine CRT funclets whose code part ends in a `call` with no data after it (`0x0050c5ee`, `0x0050df94`, `0x0050e054`, `0x0050e104`, `0x0050e284`, `0x00516650`, `0x0051b7b1`, `0x0051f8b3`, `0x00521014`); the auditor requires a terminal `ret`/`jmp` or a call followed by data, and a call that never returns is not provable from the bytes. The derived code ranges are not functions in the index; batch 009 holds 554 of the 564 (the other 10 wait with the 12 for a rule).

Rerun: the commands above, `python3 scripts/annotate_machine.py annotate --out <dir> --region game --lo 0x401000 --hi 0x440000` (and the other regions), `manifests --dir <dir>`, then the audit per batch. Not claimed: original C++ or compiler provenance, and that any name is meaningful.

## Batch 009: derived entries (Track M slice 3)

The span split of the census found 564 code ranges that `function-index.json` does not list ("derived" entries: import thunks, shared tails, unindexed library routines, code reached only from another function). 554 of them are now annotated by `annotate_machine.py annotate --derived --exclude-manifests --batch-size 700 --first-batch 9` and audited as `batch-009.json` (554 functions, 20,323 code bytes, 0 mismatching bytes, 0 relocations). A derived entry has no Ghidra function, so its `evidence` header and the manifest `evidence_id` read `derived-entry: found by the span split, not in function-index.json; inside the span of FUN_<parent> (+0x<offset>)`; the auditor computes that string itself (`audit_tool_assisted.derived_evidence`) and rejects any other. Everything else (machine annotation rules, the `check` regeneration, the pinned assembler) is unchanged. A derived entry is code that the span split reproduces exactly; it is not proven to be a function (515 of the 564 have no direct call or jump to them), and nothing here claims original C++ or compiler provenance.

Ten derived entries stay out for the same reason as the 12 excluded indexed functions: four end in a `call` with no data after it (`0x0050e8e2 0x0050f459 0x0050f724 0x0050ff75`, 40 bytes) and six fall through into the next range (`0x00510a4b 0x0051aaf4 0x0051cb35 0x0051dfef 0x0051e24e 0x0051ebf2`, 31 bytes). They waited with the 12 for an owner rule (given 2026-10-16, bound by batch 010 below). Together that was 22 referenced code ranges, 1,619 bytes.

Data items of audited functions are bound by the composer, no longer left referenced: the 19 index tables (1,934 bytes, `IDXTAB_<va>` byte lists under the 2026-10-14 ruling) and 201 alignment-padding runs (1,464 bytes of nop-equivalent instructions or `.fill`, which the structured `int3_padding` group does not generate). Both are reported as their own classes (`tool_assisted_reconstructed_index_table`, `tool_assisted_reconstructed_padding`), never as functions or code bytes.

## Batch 010: the last 22 code fragments (Track M slice 4)

Owner ruling of 2026-10-16 (decision card "Count the last 22 code fragments as matched when they reassemble byte for byte?", recorded in `AGENTS.md`): a fragment counts as matched when it reassembles byte for byte with the pinned assembler, either as a function ending in a never-returning call or bound together with the range it falls through into. `annotate_machine.py annotate --fragments --batch-size 700 --first-batch 10` annotates every entry that batches 001 to 009 do not hold: **56 entries, 1,557 code bytes plus 62 bytes of alignment padding (1,619 bytes), audit 56/56, 0 mismatching bytes, 0 relocations**. After binding, all 1,201,488 code bytes are reconstructed and none is referenced; the whole-file SHA-256 still equals the original. `.data`, `.rdata` and `.rsrc` are still referenced.

| Kind | Entries | What it is |
|---|---:|---|
| `# ending:  call-end` | 13 | the code part's last instruction is a `call` with no data after it: nine indexed CRT funclets (`0x0050c5ee 0x0050df94 0x0050e054 0x0050e104 0x0050e284 0x00516650 0x0051b7b1 0x0051f8b3 0x00521014`) and four derived entries (`0x0050e8e2 0x0050f459 0x0050f724 0x0050ff75`) |
| `# ending:  fall-through into <va>` | 7 | `0x00513843` (indexed) and the derived `0x00510a4b 0x0051aaf4 0x0051cb35 0x0051dfef 0x0051e24e 0x0051ebf2` |
| ordinary terminal ending | 36 | the code runs of the two CRT block-copy routines `0x0050ed50` and `0x0050fa90` (see below), 18 each |

**Why both endings use the second option of the ruling.** A callee that never returns cannot be proven from the bytes, and six of the thirteen call-end entries (`0x0050df94 0x0050e054 0x0050e104 0x0050e284 0x0050f459 0x0050f724`) call `FUN_00513c65` (`__fload_withFB`), which loads a double and returns, so control continues in the range that follows. The other seven call `__CxxThrowException` (`FUN_0050f997`, four entries) or `__exit` (`FUN_0050d7f4`, three entries); both contain a `ret`, and whether they return is a property of their callees that this slice does not prove. So no entry is claimed as a never-returning function: each call-end and each fall-through entry is counted only bound together with the range that follows it. The header carries the ending (`# ending:  call-end ...` or `# ending:  fall-through into 0x<va> ...`), the manifest an `ending` key, and `audit_tool_assisted.py` derives the ending from the original and requires both to agree (a header without it, an ending the original does not have, a swapped ending and a manifest that disagrees are rejected). `compose_image.py` refuses a call-end or fall-through entry unless the range that follows it is bound as code too (padding and tables do not count), and reports `call_end_fragments` and `fall_through_fragments` per batch.

**The two block copies.** `0x0050ed50` and `0x0050fa90` (the CRT `memmove` and a second copy, 821 bytes each) keep their jump tables between code runs, which is not the "code part, tables, padding" shape of the census. `image/text_data.json` already lists the 14 dword tables inside them (the composer's `jump_tables` group generates those bytes, they are not bound again). `scripts/gen_fragments.py` cuts each span at those tables and analyzes every code run as its own entry (seven runs per span become 18 entries per span, because the span split also separates the code after each `ret`/`jmp`): the first run is the indexed function, the others are derived entries named by their own address, with the nop padding before each table as a padding data item. A `jmp [reg*4 + table]` inside such a span is an indirect jump whose absolute table base stays numeric (one base lies four bytes before its first live entry and one is indexed backwards from the end of its table; neither needs the generator to size a switch). The function ledger still lists the two as incomplete (`census_unsplit_span`), because `function-xrefs.json` and the census are derived with the unextended generator.

**Why a separate module.** `gen_hinted_asm.py` is hash-pinned by `function-xrefs.json`, which `function-execution.json` and the ledger in turn pin; changing it would invalidate the recorded execution evidence, which only the Mac can renew. `gen_fragments.py` therefore wraps a loaded generator at run time (`gen_fragments.extend`), and only `annotate_machine.py` and `audit_tool_assisted.py` use it. `annotate_machine.py check` regenerates all 4,700 machine-annotated sources identically (it now also ignores the ledger-class clause of the `unverified` line, which names the class the ledger had at annotation time: three older sources named `partial_native` after the ledger refresh to `candidate_port`).

Not claimed: that any name is meaningful, original C++ or compiler provenance, that a call-end callee returns or does not, and an x86 match of `.data`, `.rdata`, resources or headers.

