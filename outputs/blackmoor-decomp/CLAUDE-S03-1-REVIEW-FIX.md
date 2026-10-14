# Claude: final S03-1 decoder review repair

Root's independent review found one remaining P2 valid-input divergence at frozen bb38ef612bbc5ec28a9d400607c08851a7a1d8bd. This decoder snapshot is not yet accepted or collected. Keep S03 and full gameplay open. Root approves the separate S03-2 API decisions in CLAUDE-S03-2-API-DECISION.md; apply this decoder repair on its own branch, then propagate the accepted dependency into the playback branch.

## Reproduction and requested repair

In src/avf_decoder.c decode_key_frame around lines447–449, unpacked_bytes > frame_bytes is rejected unconditionally. That exceeds the actual original conversion footprint in these safe cases:

- 2×2 key frame, actual LZSS expansion8 bytes, declared16 bytes, RGB555 with conversion disabled: original single/double readers succeed while native returns CORRUPT. Fresh original execution reproduced6 replay mismatches.
- Same frame declared9 bytes: conversion touches only four16-bit words, so RGB555 and RGB565 original readers succeed while native rejects them. Fresh original execution reproduced12 replay mismatches.

Validate the conversion's actual touched extent only when conversion is enabled, retaining the separate actual LZSS output bound. Preserve the original call order and prefix on failure. Add both fixtures to native and original tests, including enabled/disabled conversion and all applicable reader/replay forms. Invalid expansion or conversion spans must still reject safely; do not simply remove bounds checks.

Stable private review evidence:

- work/analysis/slices/root-S03-1-review-bb38ef6-declared-over-frame-oracle.json
- work/analysis/slices/root-S03-1-review-bb38ef6-odd-declared-oracle.json

Otherwise the review passed29 fresh native tests including ASan/UBSan; six selected repaired/empty/delta fixtures produced226 original/native comparisons without differences. Source/header/library/fixture/oracle/report hashes match the handoff. Installed corpus32 files/245 frames uses type0; other branches remain synthetic evidence. Targets execute original decoder/expansion/conversion instructions, with host boundaries enumerated.

Return a frozen repair commit and updated source/native/oracle hashes, regression counts, both fresh original/native reports and unchanged explicit unsupported branches. Root re-reviews the repair before collection. Do not modify shared app/parser/executor, map or other workers' files.
