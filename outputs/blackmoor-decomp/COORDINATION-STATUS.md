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
| RT-6 wire the pointer module, single hotspot candidate | Reviewed (no P1), on this PR |
| A-35.1 / A-38.1 / A-3F.1 / A-97.1 / A-A1.1 opaque decoders | Reviewed, merged (typed 18,951 / opaque 661); runtimes still unimplemented |
| A-3E.1 / A-6E.1 / A-79.1 opaque decoders (Codex) | In progress; next largest opaque families |
| Track M (M02/M03 whole-file match) | Other threads; 398 exact bytes at last report |
| Whole game / whole-file rebuild | Incomplete |

Live headless run (`--inspect-live-session --live-click-row 34 --live-ticks 3000`): S0 narration plays, the click enters S5900, and the game's own transitions carry it through S5907 and S5901-S5906; S4700 now loads and ticks; it stops at the unimplemented 0x35 runtime (row 3).

GUI and hardware audio remain unverified.

## Handoff: opaque scene actions (2026-10-14 12:50 PDT)

Merged: raw 0x35, 0x38 and 0x3f body boundaries and isolated decoders (A-35.1, A-38.1, A-3F.1; one independent review each, no P1 findings). Typed 18,951 / opaque 661. S4700 now loads and ticks in the live path and blocks at the 0x35 runtime (row 3, A-35.2), then the 0x97 rows 11-13.
In progress (Codex gpt-6.1-sol xhigh): A-3E.1 (202), A-6E.1 (68), A-79.1 (38), branches `codex/A-3E.1`, `codex/A-6E.1`, `codex/A-79.1`.
Review follow-ups carried forward as unverified: A-3F.1 oracle does not run the 0x424aa8 tail-modulus loop or assert `body_length`; its text-lookup model is only valid for corpus-shaped keys (A-3F.2); 0x38 and 0x37 share runtime byte 0x36, so A-38.2 must discriminate by object contents.
Next: runtime handlers for 0x35 (A-35.2) and 0x97, then the next opaque families (0x6f, 0x45, 0x67, 0x44).
