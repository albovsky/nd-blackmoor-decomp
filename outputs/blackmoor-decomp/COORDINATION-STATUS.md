# Reconstruction coordination

Work has resumed under Claude Code as root (2026-10-13).
- **Root:** Claude Opus. It plans, writes packets, reviews and collects onto `main`.
- **Implementers:** Claude Sonnet (high) `slice-implementer` subagents, and Codex `gpt-6.1-sol` (xhigh).
- **Independent review:** the `slice-reviewer` subagent, with root acceptance.

The project root is `/Users/albovsky/Projects/nd-blackmoor-decomp`; the old `blackmoor-reconstruction` path is a compatibility symlink. `main` is published at https://github.com/albovsky/nd-blackmoor-decomp; `work/` evidence and the game stay local. The verified main code baseline is `3b858e6`: build passes, 497 tests pass and 2 skip.

| Work | State |
|---|---|
| S03-1 AVF decoder | `bb38ef6`: root review found one P2 (declared key-frame size vs conversion footprint); repair in progress |
| S03-2 AVF playback kernel | `9f27cf5` (on `bb38ef6`); independent review findings fixed; needs the S03-1 repair and root's API doc amendments, then collection |
| Caption transfers | Collected (`ae7a66a`); live audio is the next S0 blocker |
| A-37.2 constructor | Collected (`d458b03`/`65cc9ad`); parent runtime/drawing incomplete |
| S08-4 input consumers | Collected (`3b858e6`); 96 exact bytes; live integration incomplete |
| A-37.3 runtime discovery | Paused; static-only handoff |
| S04-2.2 stream kernel | Paused; untested header/C fixture drafts; next live blocker (S0 row 31 audio) |
| Whole game / whole-file rebuild | Incomplete (398 exact bytes) |

The main working tree has an uncommitted `progress-map/index.html` change that predates the takeover and is not root's. It looks like an older regeneration (exact-assembly tiles removed) and is left uncollected pending the owner's decision.

GUI and hardware audio remain unverified while the Mac is locked.
