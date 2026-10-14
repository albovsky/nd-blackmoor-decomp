# Current integration evidence

Verified source snapshot: `43360868896b1adf6aac2eeb7ca84c42dbd4ab54`. The combined native build passes. The automated suite runs477 tests:475 pass and two case-insensitive filesystem fixtures are skipped. The separate progress-map suite passes23 tests. Full gameplay, GUI and hardware audio remain unverified.

Reviewed input latch, eight condition-extra leaves, caption software transfers and the actual app caption binding are collected. The input methods have421 original/native comparisons and421 original/candidate x86 calls with zero mismatches. Condition extras have390 original/native leaf comparisons; their shared whole-tree integration remains open. Caption compositor validation has50 original software-raster cases and eight native tests; no original raster logic is stubbed. Boot is now wiring these transfers into persistent app callbacks.

The verified app update applies S0 rows0–30, then invokes action9f at row31. It resolves AUTOTEXT (1258 session entries) and runs the accepted writer, stopping explicitly at unavailable RestoreCCTextBox pixel transfer. The Frame saved surface comes from TASK's CIFTREE name, not a scene capture. I01 remains open for real caption transfers, choices/help, audio, original cursor/input mapping and ordered S5900 execution.

Nine complete functions match exactly from reviewed, reproducibly assembled mnemonic x86 source: six accessors112 bytes and three input methods176 bytes. Together with two earlier incomplete7-byte ranges, coverage is302 unique exact bytes across11 extents/five merged address ranges. This establishes neither original compiler/source provenance nor a whole-file rebuild.

The refreshed [progress map](progress-map/index.html) is frozen to source `a864b11e6c154f6b2a3449e06fb1ef22da3e0f08` and was independently reviewed at79313a9. It displays4188 indexed starts, source-bound exact assembly extents, partial ranges and selected oracle-report evidence separately. Most tile areas are estimated spans to the next start; the final extent is unknown. It deliberately reports no overall decompilation percentage. Selected oracle coverage omits several major families, so grey tiles do not establish absent reconstruction work.

The parser still identifies11089 typed and8523 opaque bodies across19612 actions in2078 scenes. The approved A-37.2 worker is implementing the fixed69-byte raw37 decoder and separate owner/0xABA constructor output model for4308 records; runtime/provider/rendering remain later children. Typed boundaries do not establish playable actions.

Current ownership:

- Boot: sole shared runtime writer; bind accepted caption transfers before input/condition-tree follow-ons.
- Claude: S03-2 playback with [root API decisions](CLAUDE-S03-2-API-DECISION.md). Final S03-1 decoder snapshotbb38ef6 has one remaining size-guard divergence; [repair brief](CLAUDE-S03-1-REVIEW-FIX.md) issued, acceptance pending.
- Overlay worker: [A-37.2 bounded decoder/constructor](tasks/A-37.2-static-overlay-loader.md).
- Sound worker: isolated original stream producer/completion recovery; implementation waits for a proven boundary.
- Root: architecture, packets, independent review, sequential collection and combined verification.

Full native gameplay, save/load/endgame, both difficulty playthroughs, broader action/media/audio recovery, original codec equivalence, packaging and a byte-identical complete GAME.EXE rebuild remain unfinished. Original SHA-256: `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.
