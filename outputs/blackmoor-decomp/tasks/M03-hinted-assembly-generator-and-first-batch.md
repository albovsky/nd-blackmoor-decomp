# M03: hinted assembly generator and first reviewed batch

Root assigns this child of S08 to a `slice-implementer` (Sonnet high) or Codex `gpt-6.1-sol` xhigh worker. State: READY, unclaimed; may run in parallel with M02. Read `AGENTS.md` (Track M ruling), `PROJECT-SPEC.md`, `WORK-SLICES.md`, `M0-binary-census-report.md`, the S08-2 packet (the `{load}` finding and pinned assembler) and `scripts/verify_matches.py`. Work in an isolated worktree with the canonical private `work/` linked; claim M03 before editing.

## Outcome

A project-owned generator turns any indexed original function into annotated-ready Intel-syntax GNU assembly that reassembles byte-exactly with the pinned `i686-w64-mingw32-as` 2.43.1, an auditor enforces the annotation and review contract, and a first batch of functions is produced, annotated, independently reviewed and classified `tool_assisted_reconstructed_assembly`.

## Ownership

Own only new files: `outputs/blackmoor-decomp/scripts/gen_hinted_asm.py`, `outputs/blackmoor-decomp/scripts/audit_tool_assisted.py`, `outputs/blackmoor-decomp/asm/` (one `.s` per function plus a batch manifest `asm/batch-001.json`), `outputs/blackmoor-decomp/tests/test_gen_hinted_asm.py`, `outputs/blackmoor-decomp/tests/test_audit_tool_assisted.py`, and private `work/analysis/slices/M03.*`. The function index, existing matching sources, verifier, engine and app files are read-only. The generator reads the owner's local `GAME.EXE` and `llvm-objdump`; its census output over all functions stays private under `work/`. Committed `.s` files contain mnemonics, labels, symbols and comments only; never raw byte lists except `.insn` operands for the four permitted residual classes.

## Generator contract

- Input: one or more function VAs from `function-index.json`; extent is the distance to the next indexed start, as the S08 packets define it.
- Output per function: `.intel_syntax noprefix`, `.code32`, a global symbol `FUN_<va>`, local labels at every branch target, branch targets outside the function expressed as `extern` symbols, and encoding hints derived from the original bytes: `{load}`/`{store}` for register-register forms, `.d8`/`.d32` branch suffixes, `{disp8}`/`{disp32}` displacement sizes, and `.insn` only for 16-bit accumulator immediates (`66 05/2D/0D/25/3D imm16`), the `DC C0` `fadd` form, `81 /x` word operations with `imm16`, and `xchg ah, al`. Trailing `int 3` padding and any switch table are emitted as data items with their own labels.
- Header comment: VA, extent, SHA-256 of the original extent (hash only), the evidence id from `function-index.json`, the code region (game, Vorbis, CRT/MFC), and empty fields the annotator must fill: function name, argument and local symbols (`.equ` for every `[ebp±n]` offset used), fields touched (`this+n`), callees by name, the Track N module and symbol the function corresponds to or `host-adapter: none`, and unverified branches.
- Census mode: run the generator over all 4,188 functions and reassemble; report bytes exact per region and list any instruction the generator cannot express. The M0 census reached 99.89% before `.insn`; this packet must reach 100% of code bytes or list the exceptions.

## Audit and review contract

`audit_tool_assisted.py` accepts a batch manifest and, for each function: reassembles the committed `.s` with the pinned assembler, compares the object bytes to the original extent (through `verify_matches.py` semantics), rejects raw byte lists outside permitted `.insn` forms, rejects missing or placeholder annotation fields, requires every `[ebp±n]` offset to be named, requires at least one comment per basic block, records source, object, assembler and original-extent hashes, and writes the report. Independent review (the `slice-reviewer` subagent) then checks that the names and comments describe what the bytes do, not what the pseudocode guesses, and that the Track N cross-reference is real. A function enters the `tool_assisted_reconstructed_assembly` class only after the audit passes and root accepts the review.

## First batch

Batch 001 is every function for which the project already holds reviewed Track N source or an accepted recovery report: the CIF decompressor, the dependency reducer, the boot initialization routines, the A-37 constructor, the S08-2/3/4 families (as a cross-check against the hand-written sources, which stay in their own class), the HIS audio decode and PCM quantization kernels, and the sound-control functions named in `action-sound-recovery.md`. Take addresses from `function-index.json` and the recovery reports; do not guess extents. Report batch bytes by region and the delta against the 398-byte baseline without double counting.

## Steps

- [ ] Generator, census mode over all functions, exceptions list.
- [ ] Auditor with mutant tests: a wrong hint, a dropped label, a raw `.byte` run, an unnamed frame offset, a stale hash, an object assembled with Xcode's assembler.
- [ ] Batch 001 generated, annotated, audited; request independent review; repair findings.
- [ ] Hand off: commands, census and batch reports, hashes, the list of functions that failed review and why.

## Acceptance

The generator reproduces 100% of code bytes for all indexed functions in census mode or lists each exception; the auditor rejects all mutants; batch 001 passes audit and independent review with zero mismatching bytes; the report states the batch as `tool_assisted_reconstructed_assembly`, separate from hand-authored source, and claims nothing about original C++ or compiler provenance. Batch 002 onward is scheduled by root from call-graph leaves and the largest-first list in the M0 report.
