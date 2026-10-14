# Reconstruction coordination

Claude Code is root (2026-10-13). Implementers: Claude Sonnet (high) `slice-implementer` subagents and Codex `gpt-6.1-sol` (xhigh; the installed `codex` CLI rejects that model, run it through `npx @openai/codex@0.162.1`). Independent review: `slice-reviewer`. Findings are fixed before collection.

Goal of the current run: a playable native ARM64 build. The Mac is unlocked, so GUI and hardware-audio checks are allowed (none have been done yet).

| Work | State |
|---|---|
| RT-1 live audio channel provider | Reviewed, fixed, merged (PR 6) |
| RT-2 / RT-2.1 pointer producer module (Codex) | Reviewed, fixed, on PR 8; not yet wired into the app |
| RT-3 0x62 / 0x51 session bindings | Reviewed, fixed, on PR 8 |
| RT-4 dependency opcodes 11-15/17/20/21 | Reviewed, fixed, on PR 8 |
| RT-5 scene exit handler + queued 0x28 effect | Reviewed, fixed, on PR 8 |
| RT-6 wire the pointer module, single hotspot candidate | In progress |
| A-35.1 / A-97.1 / A-A1.1 opaque decoders | Other thread (Codex); S4700 waits on 0x35 and 0x97 |
| Track M (M02/M03 whole-file match) | Other threads; 398 exact bytes at last report |
| Whole game / whole-file rebuild | Incomplete |

Live headless run (`--inspect-live-session --live-click-row 34 --live-ticks 3000`): S0 narration plays, the click enters S5900, and the game's own transitions carry it through S5907 and S5901-S5906; it then stops loading S4700 on an opaque 0x35 row.

GUI and hardware audio remain unverified.
