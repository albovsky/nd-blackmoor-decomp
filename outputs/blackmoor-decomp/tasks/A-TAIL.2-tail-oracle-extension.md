# A-TAIL.2: extend the shared dependency-tail oracle (later decoders and the pre-scan exits)

Root (Claude Code) assigns this packet to a Codex `gpt-6.1-sol` xhigh implementer. Follows A-TAIL.1 (merged: `tests/tail_oracle_common.py`, `tests/tail_oracle_mutation_check.py`, `tests/test_tail_oracle.py`, receipts `work/analysis/slices/A-TAIL.1.*`; its independent review is in the A-TAIL.1 handoff `unverified_branches` and the follow-ups below).

## Goal

1. Cover the six decoders merged after A-TAIL.1 with the same original-backed tail stage: raw 0x45 (`action_family_45`), 0x44 (`action_family_44`), 0x36 (`action_family_36`), 0x94 (`action_family_94`), 0xd1 (`action_family_d1`) and 0x2e (`action_family_2e`). Reuse the helper's structure; read each module's native `body_length`/`decode` through ctypes exactly as for the first nine.
2. Densify tail coverage: lengths 0..300 plus 1023..1025, 4079..4097 and the 65,536-row and 65,537-row tails (so 16-bit count truncation and a modulus enforced only below some size are detected). Add mutants for those two.
3. Model the dependency pre-scan exits the first stage stopped before: the original continues past the accept exit `0x424c94` into content checks (`0x424cb0..0x424e5d`, exit `0x424e98`) that fatal on unpaired 0x12/0x13 opcodes (log formats `0x544bd4`, `0x544c54`, `0x544cf0`, `0x544d94`), on the 0x0b pair rule (`0x424dee`) and on a count mismatch (`0x424e5d`). Run these in the original for synthetic tails (a 16-byte record with first word 0x12 or 0x13, a 0x12 followed by 0x13, paired and unpaired forms, 0x0b forms) and record, per family, whether the native parser accepts what the original fatals on. Do not change any native parser behaviour: report the divergences as a table with original addresses and exit labels so root can decide whether to model them in `scene_resource.c` (the corpus contains real 0x12/0x13 and 0x0b records; all of them pass the original pre-scan).
4. Slot-reuse precondition: also run `0x424bd6` (`[row+0x3a] != 0`) with a non-zero value and record its fatal exit; do not model it natively.

## Facts (verify, do not trust)

A-TAIL.1 verified: arguments to `0x424aa8` are (row, 50 + typed length, ACT length, cursor); exits empty `0x424c0d`/`0x424c31`, accept `0x424c94` (count at `slot+0x36+0x34` = row+0x6a = tail>>4), ragged `0x424c5b` (log `0x50ca3e`, then fatal funnel `0x52139c`/`0x4c97b4`). Hooks only at the OS/log boundary; fail closed on any unexpected exit.

## Ownership

Claim first (`work/analysis/slices/A-TAIL.2-claim-codex-gpt61sol-20261014.json`), own worktree. You own only: `outputs/blackmoor-decomp/tests/tail_oracle_common.py`, `tests/tail_oracle_mutation_check.py`, `tests/test_tail_oracle.py` (edit in place, keep the nine existing families passing), a new `tests/tail_oracle_prescan.py` and unique `work/analysis/slices/A-TAIL.2.*` evidence. Everything else is read-only. Use `work/tools/oracle-python/bin/python`; scripts write only to unique paths (also under `/private/tmp`, not canonical `work/analysis/slices`, for mutation builds).

## Verification and handoff

Run the extended stage on all fifteen families, the mutation check (new mutants detected; report any the old oracles missed), the pre-scan table, and the existing tests. Commit only owned files to `codex/A-TAIL.2` (no push), message ending `Co-Authored-By: Codex <noreply@openai.com>`; write `A-TAIL.2.handoff.json` and `.validation.json` with counts, hashes, hooks, the divergence table and unverified branches. No GUI, no hardware audio; never modify GAME.EXE.

**Acceptance:** the shared stage passes for all fifteen families against the original; the new mutants are detected; the pre-scan divergence table is complete with original addresses; no decoder source or other oracle changes.
