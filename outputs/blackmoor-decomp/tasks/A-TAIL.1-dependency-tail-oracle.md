# A-TAIL.1: original-backed dependency-tail oracle for the opaque-family decoders

Root (Claude Code) assigns this packet to a Codex `gpt-6.1-sol` xhigh implementer. Independent reviews of A-35.1, A-38.1, A-3F.1, A-3E.1, A-6E.1, A-79.1, A-67.1, A-6F.1 and A-43.1 each found the same coverage gap: the committed original-x86 oracles stop at 0x410a68/0x410aa5 (before the generic dependency loader `0x424aa8`), so the `% 16` tail rule and the dependency count are compared only against the native module's own formula, and mutants that remove or weaken the modulus survive the oracle (they are caught only by native unit tests). The rule itself was confirmed correct by every reviewer's own probes.

## Goal

Add one shared, original-backed stage that runs the original `0x424aa8` for each family and asserts what the reviewers observed, and mutants proving it detects a weakened rule. Do not change any decoder's behaviour.

## Facts established by review (verify, do not trust)

- `0x424aa8` receives (action row, consumed offset, ACT length, cursor); dependency records start at ACT offset 50 + typed length (ECX = 0x63786d in reviewers' probes). Exits: empty tail `0x424c0d`, accepted tail `0x424c94` (count stored at `slot+0x36+0x34` = `tail >> 4`), ragged tail `0x424c5b`/`0x425b40` (logs via `0x50ca3e`, then the fatal-cleanup funnel `0x52139c`/`0x4c97b4`).
- Accepted tails are exactly the multiples of 16; the original logs and takes the fatal path otherwise. Native rejects those inputs.
- `0x424bd6` additionally tests `[row+0x3a] != 0` (prior slot reuse) and `0x424cf4..0x424e93` pairs opcodes 0x12/0x13; an unpaired one reaches the fatal funnel. The native parser does not model either; record them as unverified, do not implement them.
- Reviewer probe scripts to start from (read-only, scratch, not committed): `/private/tmp/review-a6f/tail_oracle.py`, `/private/tmp/review-a67/tail_final.py`, `/private/tmp/review-a43/dep_tail.py`, `/private/tmp/review-a79/tailcheck.py`, `/private/tmp/review-a3e/tailprobe.py`. Rebuild your own; they may be gone.

## Ownership

Work in your own git worktree. You own only: `outputs/blackmoor-decomp/tests/tail_oracle_common.py`, `tests/tail_oracle_mutation_check.py`, `tests/test_tail_oracle.py`, and unique private `work/analysis/slices/A-TAIL.1.*` evidence plus the claim file. Everything else, including every per-family `action_family_*` source, oracle, test and build script, `scene_resource.c`, status docs, is read-only. Claim first: `work/analysis/slices/A-TAIL.1-claim-codex-gpt61sol-20261014.json`.

## Required work

1. Build one shared Unicorn helper (use `work/tools/oracle-python/bin/python`) that, given a family's already-validated typed body length and payload, runs the original loader or `0x424aa8` directly and reports which exit it reached and the stored count. Hooks only for OS/allocation/logging boundaries; list every hook; never replace an original decision.
2. For every merged family (0x35, 0x38, 0x3f, 0x3e, 0x6e, 0x79, 0x67, 0x6f, 0x43; read each module's native `body_length`/`decode` through ctypes) assert, for all real corpus records and tails 0..48 bytes plus 63..65, 255..257, 1023/1024 and the overflow-sized tails 4080, 4096 and 4112 (counts 255, 256 and 257, which distinguish an 8-bit truncation of `dependency_count`): native accepts a tail exactly when the original reaches the accept or empty exits, and the native `dependency_count` equals the stored original count.
3. Mutants: for each family build compiled mutants of the native module that remove the modulus check, change it to `% 8`, drop the short-body check and truncate `dependency_count` to 8 bits, using unique build directories; the new stage must detect every non-equivalent mutant. A 16-bit truncation needs a tail of at least 1 MiB (count 65,536) and the whole corpus has only about 26,000 dependency records, so report that mutant as unreachable by corpus data and either cover it with one oversized synthetic tail or state why not; it is not required for acceptance. Report which mutants the old oracles missed.
4. Verification: unittest for the helper, the new stage on all families, mutation results, ASan/UBSan not needed (no native change). No GUI, no hardware audio.
5. Handoff: commit only owned files to `codex/A-TAIL.1` (no push), message ending `Co-Authored-By: Codex <noreply@openai.com>`; write `A-TAIL.1.handoff.json` and `.validation.json` with counts, hashes, hooks and unverified branches (including the two noted above).

**Acceptance:** the shared stage passes on all nine families against the original; every tail-rule mutant is detected; no decoder or oracle outside the owned files changes.
