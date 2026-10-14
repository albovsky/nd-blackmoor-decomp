# Current integration evidence

Owner requested pause after finishing the collected slice. Verified code snapshot: `3b858e6727b263a49458001a132effe80570af3e`. Combined native build passes; 499 tests run, 497 pass and two case-insensitive filesystem fixtures skip. Original GAME.EXE hash remains unchanged. No GUI or hardware audio verification was performed.

Collected and independently reviewed:

- Caption integration `c190550` → `ae7a66a`: actual taskbar Frame restore then keyed caption transfer. Current S0 caption region has3,433 changed pixels of16,120. 34 focused tests and 50 original raster cases pass. Cached session results do not replay composition; failure prefix, injected reset and same-frame reseed checks pass. A genuine second session tick/replacement and full-scene parity remain open.
- A-37.2 `936fdc3` + `7eb18bd` → `d458b03` + `65cc9ad`: fixed 69-byte body decoder and exact 0xABA constructor image. 4,308 shipped + 2 synthetic records compare 11,835,260 bytes without differences. Owner pointers are separate from image/name bytes. Six tests and ASan/UBSan pass; three compiled source defects are detected. Shared parser/runtime/provider/render integration remains open.
- S08-4 `5483b78` → `3b858e6`: bounded field0/field4 input consumers and two complete exact x86 extents of 96 B. 13 focused tests, 100 original/native calls and 76 original/candidate machine calls pass. Live frame/cursor integration remains open.

Current matching coverage: 398 unique bytes across 13 extents/four merged ranges: eleven complete assembly functions (384 B) and two incomplete ranges (14 B). Original compiler/source provenance and whole-file rebuild remain unverified. The released progress map is a frozen source a864b11 snapshot with 302 bytes and has not been refreshed during the pause.

Actual persistent S0 execution applies rows 0–30, renders row 31 captions and stops at unavailable live audio. Separate offline FFmpeg/full-buffer playback of NSHT01 succeeds under required permissions but is a diagnostic, not original stream parity or a live provider.

S04-2.1 source recovery now proves ring/setup/refill/drain and logical-active query semantics. S04-2.2 implementation is paused with untested header/C fixture drafts; copies and hashes are saved privately. A-37.3 is paused with static evidence only. All Codex workers have stopped. Claude is external: the [pause brief](CLAUDE-PAUSE-BRIEF.md) is saved for relay; his session stop cannot be confirmed here.

See [finished-slice report](PAUSE-REPORT.md). Full native gameplay, input/audio, remaining action/media/UI work, save/load/endgame, both difficulty playthroughs, original codec equivalence and whole-file matching remain unfinished.
