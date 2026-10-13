# Claude: repair S05-1 review findings before S05-2 integration

## Current repair owner

Root has assigned the combined writer/lifecycle repairs to Codex worker /root/sound_control_luna6 in [S05-review-repairs](tasks/S05-review-repairs.md). Claude continues the independent S03-1 AVF assignment. This document remains the original writer finding record; preserve the frozen caption checkouts.


Reviewed snapshot: db638f3f1ca2347f7e286969fd0ba24f0b0e82e0. Independent Astra review found three issues. The writer remains unaccepted by root until these are fixed and re-reviewed. Continue as Claude; keep the S05-2 lifecycle work queued behind this small repair.

1. **P1 — Restore callback sees stale pixels/state.** `caption_layout.c` near 959 invokes `restore_caption_box` while drawing is in private staged `e->canvas`; the caller target is copied only near 1099 after `run()` returns. The callback receives context only. Reviewer reproduced a valid write where restoration sees the old 0xa5a5 target and the successful return exposes different pixels. The original restores the rendered surface. Supply the staged rendered surface and relevant authoritative state to the backend, or revise commit/presentation ordering with explicit source-order and failure semantics. Review callback-visible globals as well. Add assertions inside the callback that check pixels/flags at call time, not only post-return pixels or event names. Preserve backend flag side effects rather than overwriting them with a stale snapshot. Do not manufacture atomic rollback after a visible host effect.

2. **P2 — Missing release callback leaks sheets.** `release_font()` near 419 zeroes its handle even when `release_font_sheet` is null. A valid loader plus null release returns OK and leaks held font 9. Reject the unsupported ownership contract before any load, or establish a correct explicit ownership policy. Cover normal and error cleanup; verify no lost handle or stale reference count.

3. **P2 — Signed geometry overflow before bounds checks.** FONT glyph width/height near 148/150, TBOX geometry near 178..185, and draw/colour rectangle calculations near 480..483 use signed 32-bit arithmetic before validation. A structurally valid FONT with left=INT_MIN/right=INT_MAX trips UBSan. Use checked wider arithmetic, or explicit original wrap where required followed by safe rejection. Audit neighboring coordinate differences/additions and add extreme-coordinate regressions plus a focused UBSan run. Unsafe input must fail before host calls/out-of-range access.

The reviewer independently built a fresh library and ran all 20 existing tests. An original sample ran 63 cases: 53 exact successful cases and 10 separately classified exceptional outcomes, with no mismatches. The restore oracle hook records the event only, so it does not establish callback-time surface visibility; strengthen that coverage. The full original corpus was not independently repeated in this review.

Own only your S05-1 caption_layout.[ch], its tests/oracle/build script if needed, and its evidence/receipt. Do not edit shared app/executor/platform/audio or A-51 files. Boot remains sole shared integrator. Coordinate any backend signature change in a public-header proposal and updated S05.integration-proposal.md. Keep original assets immutable, no GUI/hardware audio while locked.

Return a separate fix commit, new source/native/report hashes, affected original comparisons, callback/cleanup/overflow regressions and revised limitations. Root will arrange narrow re-review. Then proceed with CLAUDE-S05-2-BRIEF.md from the corrected writer commit. S05 parent and the complete game remain open.
