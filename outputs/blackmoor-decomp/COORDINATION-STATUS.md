# Reconstruction coordination

Claude Code is root (2026-10-13). Implementers: Claude Sonnet (high) `slice-implementer` subagents and Codex `gpt-6.1-sol` (xhigh; the installed `codex` CLI rejects that model, run it through `npx @openai/codex@0.162.1`). Independent review: `slice-reviewer`. Findings are fixed before collection.

Goal of the current run: a playable native ARM64 build. The Mac is unlocked, so GUI and hardware-audio checks are allowed (none have been done yet).

| Work | State |
|---|---|
| RT-1 live audio channel provider | Reviewed, fixed, merged (PR 6) |
| RT-2 / RT-2.1 pointer producer module (Codex) | Reviewed, fixed, merged; wired into the live session by RT-6 |
| RT-3 0x62 / 0x51 session bindings | Reviewed, fixed, on PR 8 |
| RT-4 dependency opcodes 11-15/17/20/21 | Reviewed, fixed, on PR 8 |
| RT-5 scene exit handler + queued 0x28 effect | Reviewed, fixed, on PR 8 |
| RT-6 wire the pointer module, single hotspot candidate | Reviewed (no P1), merged (PR 10) |
| A-35.1 / A-38.1 / A-3F.1 / A-97.1 / A-A1.1 opaque decoders | Reviewed, merged; runtimes still unimplemented |
| A-3E.1 / A-6E.1 / A-79.1 / A-67.1 / A-6F.1 / A-43.1 opaque decoders (Codex) | Reviewed, merged (typed 19,324 / opaque 288) |
| Track M (M02/M03 whole-file match) | Other threads; 398 exact bytes at last report |
| Whole game / whole-file rebuild | Incomplete |

Live headless run (`--inspect-live-session --live-click-row 34 --live-ticks 3000`): S0 narration plays, the click enters S5900, and the game's own transitions carry it through S5907 and S5901-S5906; S4700 now loads and ticks; it stops at the unimplemented 0x35 runtime (row 3).

GUI and hardware audio remain unverified.

## Handoff: opaque scene actions (2026-10-14 12:50 PDT)

Merged: raw 0x35, 0x38 and 0x3f body boundaries and isolated decoders (A-35.1, A-38.1, A-3F.1; one independent review each, no P1 findings). Typed 18,951 / opaque 661. S4700 now loads and ticks in the live path and blocks at the 0x35 runtime (row 3, A-35.2), then the 0x97 rows 11-13.
Review follow-ups carried forward as unverified: A-3F.1 oracle does not run the 0x424aa8 tail-modulus loop or assert `body_length`; its text-lookup model is only valid for corpus-shaped keys (A-3F.2); 0x38 and 0x37 share runtime byte 0x36, so A-38.2 must discriminate by object contents.
Next: runtime handlers for 0x35 (A-35.2) and 0x97, then the next opaque families (0x6f, 0x45, 0x67, 0x44).

## Handoff: opaque scene actions, second batch (2026-10-14 13:05 PDT)

Merged: raw 0x3e, 0x6e and 0x79 body boundaries and isolated decoders (A-3E.1, A-6E.1, A-79.1; one independent review each, no P1 findings). Typed 19,259 / opaque 353. 0x3e is registered inline (a build-breaking helper call in Codex's proposal was caught by review) and rejects unterminated name and key fields like the decoder.
Review follow-ups carried as unverified for all six new decoders: the originals' oracles stop before 0x424aa8, so the dependency-tail modulus is checked by static reading and reviewer probes, not by the shipped oracle (the original logs and continues on a ragged tail, native rejects); the 0x3e/0x3f text-lookup model matches the original only for corpus-shaped keys; native dylib hashes are path-dependent.
Next: A-35.2 and A-97.x runtime handlers (S4700 rows 3 and 11-13), then oracle-coverage hardening for the tail path, then the remaining opaque families (0x45 32, 0x67 27, 0x44 27, 0x6f 25, 0x36 20; then a long tail).

## Handoff for the next session (runtime-path thread)

State: the live scripted run (`--inspect-live-session --live-click-row 34 --live-ticks 3000`) goes S0 -> S5900 -> S5907 -> S5901..S5906 -> S4700, then S4700 row 3 (type 0x35, typed body, no runtime handler) blocks as `provider=action-kernel`. Pointer input goes through the recovered `session_input` module with one shared hotspot candidate.

Working rules (Glib, 2026-10-14): Pacific time only; hand implementation to Codex (`npx @openai/codex@0.162.1 exec -m gpt-6.1-sol -c model_reasoning_effort=xhigh`; the installed CLI rejects the model) and keep Sonnet `slice-implementer` for the rest; one `slice-reviewer` per slice; two threads (this one plus the Codex action-decoding thread); merge PRs yourself when ready (fix Codex review threads first); after every merged slice regenerate the progress map (`decomp-progress/generate.py`, PROG-1 adds a Playable build panel) and show it to Glib.

Next slices, in order:
1. Drive the run past S4700 once the 0x35 runtime lands (Codex thread, A-35.2); bind it into the session like `session_bindings_a62` (executor extern handler) and read the next stop from the live log.
2. Recover the 0x4f0059 edge/arrow cascade (`[0x5a4c1c]`, `[0x5bb2ca/cc/b6]`, `[0x5b0260/62]`, `[0x5b51f6]`, `[0x5b51c6]`, `[0x5b51ab]`) so `priority_clear` and hover near viewport edges are proven rather than assumed (RT-6 review P2).
3. Settle whether the original keeps sounds across continuation transitions (the blanket `live_audio_unload_all` in `perform_session_transition` is an unverified choice; S5907 row 6 behaves differently with it).
4. Interactive pass on the real window (needs Glib or computer use): click through S0, listen to the narration, check the hover cursor and a double click. Nothing interactive has been verified yet.
5. Menus, save/load and the second difficulty (I04/I05) once the opening scenes run.

## Handoff: opaque scene actions, third batch (2026-10-14 15:00 PDT)

Merged: raw 0x67, 0x6f and 0x43 body boundaries and isolated decoders (A-67.1, A-6F.1, A-43.1; one independent review each, no P1 findings). Typed 19,324 / opaque 288. 0x67 and 0x6f are one-byte fixed bodies; 0x43 is registered inline with both its keyed and inline-text branches and its own unit test.
In progress (Codex gpt-6.1-sol xhigh): A-45.1 (32), A-44.1 (27), A-36.1 (20), branches `codex/A-45.1`, `codex/A-44.1`, `codex/A-36.1`. These packets require the oracle itself to run the original dependency loader 0x424aa8.
Open review follow-ups for every merged decoder (A-35.1 through A-43.1): the shipped oracles stop before 0x424aa8, so the tail modulus and count are verified by reviewer probes, not by the committed oracle; the original takes a fatal path on a ragged tail and on unpaired 0x12/0x13 dependency opcodes (native parser accepts the latter); dylib hashes are path-dependent. A hardening packet (A-TAIL.1) should add a shared 0x424aa8 oracle stage and tail mutants to all of them.
