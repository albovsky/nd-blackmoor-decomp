# Native playability log

2026-10-24 — native ARM64 macOS, owner-local GOG data. **The game remains incomplete.**

- Live GUI baseline: New Game and Junior Detective clicks work in fullscreen; S0 captions, opening letter and the 24-scene opening sequence reach S2010. Widescreen preserves the 4:3 image with side bars. Local screenshots are in `work/playability-20261024/gui-S0.png` and `gui-S2010.png`. Mouse automation remains intermittent; room-hotspot and right-button GUI checks are unverified.
- Automated reach: S2010 row 5 enters S2008 (25 scenes), with no session error. S4808 action 0x83 row 6 is no longer a blocker. Opening movie: all 504 frames; 12 movie sequences complete on this path.
- [PR 178](https://github.com/albovsky/nd-blackmoor-decomp/pull/178), merged: turning-puzzle sound uses native channels. All 20 named clips, 11 solve and 11 exit lifecycles pass; the original D1 oracle passes 509 scenarios with zero mismatches.
- [NATIVE-02](tasks/NATIVE-02-d1-pointer-path.md), independently reviewed: turning-puzzle hover/release now reaches the app's D1 receiver before generic fallthrough. Nine focused checks pass, including exact linked-tile advancement, real-audio busy/completion gating, exit completion, retained-hover release, S4377 with its real 0x61 row, guards and explicit error/fallback paths. Final Sonnet review found no P1 or blocking P2; residual coverage limits are recorded in the slice packet.
- Validation limits: canonical suite rebuild fails on unrelated fixture/toolchain gaps; broad discovery was interrupted to stop legacy sanitizer mutation crash alerts. It is not green. Exact failed tests, commands, hashes and audio limits are preserved in [NATIVE-01 review response](tasks/NATIVE-01-review-response.md).
- Owner-requested game-only mute: `--mute` persists across launches and zeros the native master mixer; ordinary/movie PCM is silent while natural completion continues. Other Mac audio is unchanged. Independent review pending.
- Next blockers: pointer routing for other puzzle families, secondary-button rotation, popup/0x70 state integration and save/load. Hardware audibility, real-device completion/suspension, GUI D1 play and both complete difficulty campaigns remain unverified.

Original game files and reserved ledger/evidence outputs are unchanged. Neither whole-game playability nor whole-file x86 completion is claimed.
