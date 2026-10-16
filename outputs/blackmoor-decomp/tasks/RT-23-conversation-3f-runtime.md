# RT-23: raw 0x3f conversation runtime (sound conversation)

Owner thread: Claude Sonnet (cloud). Parent plan: `plans/blackmoor-speed-review.md` step 2 (family sweep).

## Why this family

The 45 action types without a live handler were ranked by corpus scenes (`scripts/scene_action_coverage.py`). Raw `0x3f` is first: 411 of 2,078 scenes contain it (493 records), 402 of them with no other missing type. `0xd9` (Mouselight puzzle) is second, `0x3e` (cel-video conversation, same handler `0x420c17`) third. Today 951 scenes have a handler for every row.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

Read pseudocode with `python3 <scratchpad>/pc.py 0x420c17 0x4205c1 ...` (all 4,188 Ghidra functions; the scratchpad path is in your brief). Pseudocode is navigation, not source. Confirm anything load-bearing in the x86 (`llvm-objdump`/capstone on `work/original/GAME.EXE`).

* Dispatcher arm `0x427a50` `case 0x39,0x3a,0x3b,0x3c,0x3e,0x3f`: gate `0x423f57(deps, 0)`, then handler `0x420c17(row)` with ECX = conversation manager `0x6177e8`. Row phase dword is `[row*0x8d + 0x5bb632]`, completion byte `[... + 0x5bb625]`.
* Typed-body decoder and constructor already exist and are original-verified: `src/action_family_3f.[ch]` (A-3F.1). The constructed object image (0x7a5 bytes, `ActionFamily3f` constructor model with its arena) is what the handler reads. Fields: `+0x00` sound descriptor (33-byte name, `+0x21` channel word, `+0x23` control word, `+0x25` mode word, `+0x29` dword, `+0x2d/+0x2f` percent words, see `0x4fb77a`), `+0x747` second embedded descriptor (literal name `dummy`, used for the response sound on channel 0xd), `+0x779/+0x77a` hook indices (0x14 = none), `+0x77b` byte (1 = default transition enabled), `+0x77c` byte (1 = pop the scene stack via `0x42e493`), `+0x77d..+0x78d` default transition (scene word, three words, three dwords), `+0x793/+0x795` primary count/table (responses, stride 0x1d1, kind byte at +0x1b7: 0 add, 1 replace, 2 remove; scene fields at +0x1b8..+0x1c8, key string at +6, name at +0x196), `+0x799/+0x79b` intermediate (always empty for 0x3f), `+0x79f/+0x7a1` secondary table (stride 10: condition count, condition handle, kind byte at +6, id word at +7, value byte at +9).
* Handler phases (row phase dword): 0 init, 1 running, 2 finish. Running sub-state is the manager dword `this+0x6b6` (1 cel start, 4 running, 5 stop first sound, 6 response sound). For 0x3f the init arm sets sub-state 4 directly, loads the object as a sound (`0x4fb77a(object)`), plays it on channel 0xc (`0x4fb2e3(0xc)`) and polls `0x4f6334(0xc)`.
* The tier A flow, in this order: phase 0 requires `[0x5c39e9] == 0` and `[0x5c39ed] == 0` and engine mode `[0x583999] == 3`, else no effect; sets `[0x5c39e9] = [0x5c39ed] = 1`, resets the cursor/held-item state (`0x4e7d04` or `0x4eb96e` by `[0x583204]`, `0x4e7728(2)`, `0x4e7786(0)`, `0x4e8d96`), clears the response array `[0x5839b1..+0x1e]`, builds the response list `0x4205c1` (primary entries whose condition tree `0x420737` is true, then the two hook functions), loads the text-box surfaces only when responses exist or `[0x5bb202] != 0` (captions), loads and plays the sound, phase := 1. Phase 1: `[0x5bb1ca] := 1`; when channel 0xc stops (or Fast Convo `[0x58322a] != 0` and the skip key `[0x58321d]` is held) and no response is listed it goes to sub-state 5; with a response list it waits for `[0x5839b1 + i] == 1` (set by the pointer path `0x4e78c2`). Sub-state 5 stops the sound; if the chosen response has a non-empty sound name other than `NO SOUND` it plays it from `+0x747` on channel 0xd (sub-state 6, wait for `0x4f6334(0xd) == 0`), else phase := 2. Phase 2 (finish): stop sounds, free the lists, run the secondary table `0x4209e8` (kind 1: event flag `[0x585801 + id*4] := value`; kind 2: `0x4e9e84(id, 1)` when value 1, else `0x4ea06c(id)`, those are the inventory add/remove already modelled by `action_family_78/79_runtime`), pick the next scene from the chosen response entry, else from the intermediate table (empty), else the default transition when `+0x77b == 1` (`[0x5bb57b] := scene word` etc., `[0x583999] := 4`), else the scene stack pop `0x42e493` when `+0x77c == 1`; clear `[0x5c39e9]`, `[0x5c39ed]`, engine mode via `0x4e7757`, free the object (`0x41db40`), completion byte := 1, phase := 0 (direct completion, no dependency reset).

## Scope (three tiers; one slice, one PR)

Corpus split by the hook bytes (`option_44`/`option_45` = `+0x779/+0x77a`) and primary count (from `work/analysis/slices/A-3F.1.corpus.json`):

| Tier | Records | Meaning | Scenes it completes |
|---|---:|---|---:|
| A | 277 | hooks 0x14/0x14, no primary entries: sound line, secondary flags, transition | +204 (951 -> 1,155) |
| B | 66 | hooks none, primary entries (player responses) | +62 |
| C | 150 | a hook index 0..9 (one of 20 flag-dependent response builders at `0x43f31a`..`0x44499c` via the tables at `0x41c068`/`0x41c0cc`) | +136 |

Deliver tier A completely and oracle-verified. Deliver the tier B logic (response list build, kinds 0/1/2, selection input, response sound, chosen-response transition, secondary flags) behind backend callbacks; the host UI (text-box layout `0x41e3c0`/`0x41e647`, hit testing `0x4d341d`) stays outside, and a missing UI callback must return an explicit unsupported result (never hang, never silently skip). Tier C rows (hook index != 0x14) and captions enabled without a caption callback return explicit unsupported with a named reason. Do not guess hook behaviour or flag meanings; record every unknown in the handoff.

## Files (new, owned by this slice)

`src/action_family_3f_runtime.[ch]`, `src/session_bindings_a3f.[ch]`, `scripts/build_action_family_3f_runtime.sh`, `tests/test_action_family_3f_runtime.py` (plus any C driver/sanitizer helper it needs), `tests/action_family_3f_runtime_original_oracle.py`. Shared files (`scene_resource.c` registration, `blackmoor_app.mm`, `build_native_app.sh`, `scene_session.*`) belong to root, who integrates. Propose the registration in a short `work/analysis/slices/RT-23.registration.md`.

Mirror the conventions of `src/action_family_36_runtime.*`, `action_family_0b_runtime.*`, `action_family_79_runtime.*` and `session_bindings_a83.*` (module + backend + world view, binding that owns the per-scene object images, disposition `SCENE_ACTION_HANDLER_DIRECT_COMPLETED` on finish, executor `scene_executor_request_transition` for the scene change). Reuse `ActionSoundBackend` (load/play/is_playing/unload) for the sound calls: the object's first 0x2d bytes are the same descriptor `0x4fb77a` reads for raw 0x9f.

## Acceptance

1. Unit tests: every tier A branch (sound ends, Fast Convo with and without the skip key, gate false, `[0x5c39e9]` already set, secondary kinds 1 and 2, default transition, scene stack pop, load failure path), tier B (list build with false/true condition trees including the 0x420737 chain rules, kinds 0/1/2, 30-entry overflow, selection, response sound, chosen transition), explicit unsupported for tier C and captions. Narrowest run: `python3 -m unittest tests/test_action_family_3f_runtime.py`.
2. Original-x86 oracle (`tests/action_family_3f_runtime_original_oracle.py`, Unicorn, real `0x427a50` dispatcher and handler `0x420c17`, with a complete hook inventory as in `tests/action_family_83_runtime_original_oracle.py`): compare the native effect sequence with the original for every tier A corpus row and a synthetic matrix for tier B. Report scenario, step and effect counts and mismatches.
3. Corpus check: all 277 tier A and 66 tier B rows run through the native kernel without error.
4. An explicit list of unverified branches in `work/analysis/slices/RT-23.handoff.json` (and a short markdown summary for root).

## Rules

Edit/Write tools for source; shell only for builds and tests. Batch reads. No sleep polling. Stop and report at about 120 tool calls with what is done. Do not commit, push, merge or touch the shared files; root commits. Do not call any `mcp__hearthbot__` tool. Do not print or commit original resource/executable bytes or decoded strings; derived counts and hashes are fine. Use the xcrun shim already on PATH in this container for the existing build scripts (it maps macOS clang flags to Linux clang); new code must stay portable C11 that also builds on macOS ARM64 with `-Wall -Wextra -Wpedantic -Werror`.
