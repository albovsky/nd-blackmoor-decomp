# Ordinary-input Memory verification

The pixel policy, input helpers and producer-to-win/save/reload flow are compared with actual Junior and Senior win/save/fresh-reload runs. The new public CLI/profile integration also passes one11-step entry probe per genuine source, ending at the unsolved Jane dialogue list. Its complete solve glue has not been replayed publicly; finite and read-only saved-field checks cover the parameterized guards. Evidence scope and exact pins are in RECOMP-31 and `../campaigns/memory-optional.json`.

## Files and dependencies

Place `memory_live.py`, `memory_pixels.py`, `memory_profile.py` and `test_memory_live.py` beside existing `bul_live.py`, `story_route.py` and `check_route.py` in `recomp/route_tools`. The two example JSON profiles and `first-memory-body.txt` are under `memory_profiles`. The controller imports the existing Session/FIFO/ACK/PPM implementation; no transport/parser/game engine is copied. It ships no asset images, card templates, save files or resource payloads.

A source profile contains only `name` (`junior` or `senior`), saved difficulty (0 or2), expected source SHA-256, and exact expected original clock (`day`, `hour`, `minute`, `total_minutes`). It verifies those fields; it never sets them. The supplied profiles describe the two accepted source saves, not distributable saves. Another genuine source needs its own explicit hash/clock profile and observed entry; passing source guards alone does not establish a valid dialogue route or new gameplay coverage.

The source must already be S3510/view4/held-1, with the exercised story prerequisites, unplayed Memory1335/1345/1988/2072, item2/4 present and no5/13. Read-only item-presence fields are retained so the output must preserve all40. Only supported Junior/Senior profiles are accepted. Original EXE/data/configuration hashes and scoped loose-before-embedded precedence remain pinned to the exercised installation; these are intentional resource guards. Paths and native/source pins are explicit caller inputs, without private project-directory or helper-body hash locks.

## Probe and solve

Set paths to local legally owned originals, an immutable seed without Documents5, a genuine source save, an explicit profile and a fresh output directory. `--native-sha256` is the expected digest of the selected reviewed build; supplying a digest does not itself certify a new host version. The public probe command has been exercised for both supplied profiles; the solve example uses core logic from the separately pinned complete private runs.

```sh
python3 memory_live.py --mode probe --native "$NATIVE" --native-sha256 "$NATIVE_SHA256" --game-exe "$GAME_EXE" --game-data "$GAME_DATA" --source-save "$SOURCE_SAVE" --source-profile "$SOURCE_PROFILE" --output "$NEW_PROBE_DIR"
```

Probe makes one independent APFS clone with only the source save, uses7 ordinary Load steps plus4 actor/capture steps, and stops at Jane1200 before any reply. It is not a puzzle acceptance. Inspect the actual current reply list. The accepted sources showed the game request at150,452, then the constellation reply at150,433 in1994. Those observations are evidence for those sources, not a response-index-to-Y rule.

Solve requires a separately pinned **body** INPUT file beginning from loaded3510; do not include the7-step Load prefix, which the controller adds. The included `first-memory-body.txt` is the exact accepted12-step body: actor/capture, observed game request/capture, observed Memory request and original1206 board capture (SHA `84c90b5f12338db69e826bae852ee46120a458e9e06150c18b8d0de3b619f471`). The current shared Load prefix produces the exact accepted19-step full entry SHA `3fde243f5481fac3116136b0ae93f78ce0e4c0e12d9e3b3dffb796c01695ada0`. Freeze its SHA only after actual dialogue observation.

```sh
python3 memory_live.py --mode solve --native "$NATIVE" --native-sha256 "$NATIVE_SHA256" --game-exe "$GAME_EXE" --game-data "$GAME_DATA" --source-save "$SOURCE_SAVE" --source-profile "$SOURCE_PROFILE" --entry-input "$OBSERVED_BODY_INPUT" --entry-sha256 "$BODY_SHA256" --save-name mem1 --output "$NEW_SOLVE_DIR"
```

Use a TTY. After an actual new1345, the process prints the closed capture and waits for bounded JSON commands on stdin. Submit only ordinary `move`, `click`, `pointer`, `key`, `shot` events selected from actual pixels, for example `{"batch":"1:move:635,385;1001:shot:0,0"}`. Observe/scroll the post-win list and select its actual Bye. Send `{"save":true}` only after safe3510/view4/held-1; the controller then uses original Load & Save UI and independently reloads only the new output. Save names must be new, lower-case letters/digits,1..10 characters and not `continue`; use `mems1` for a separate Senior output. No hardcoded post-win Bye coordinate is automated.

## Preserved rules and limits

The original alone deals, shuffles, scores, counts attempts, decides outcome and serializes saves. Captured exposed-face fingerprints choose ordinary clicks. No live hidden IDs/deck/RNG reads, handlers, guest-state/clock/save writes, pause or time-scale. `memory_pixels.py` is byte-identical to the accepted policy:6x4 tiles,12 discovery pairs, then at most12 remembered pairs, at most24 submitted pairs. Input centers and rendered crops intentionally differ by original cursor/viewport geometry. Each80ms click has prior movement, cursor parking and same-batch251/451ms captures before600ms mismatch flip-back; the next pair waits strictly beyond600ms. Hidden, unstable, third-identical or missed captures refuse continuation. Exact crop equality is a heuristic exercised on one authentic deal per difficulty, not an all-deal guarantee.

Junior permits40 completed attempts; Senior25. Senior also supplies an authored wrong-answer caption key that Junior leaves empty; geometry, sound fields, flip-back and outcomes match. No pixel/timing policy changed for Senior. A real win requires original1207 with transient1988=1, then new durable1345 and1208 clearing1988/2072. Memory grants no inventory item;1335 alone is introduction, not victory. Natural loss/unknown/I/O failure is refused with evidence; no automatic retry or abandonment checkpoint.

The unchanged shared Session uses fresh APFS clones, ordinary sequential FIFO batches and strict ACK/explicit-finish validation. Bounds remain96 requests including finish,24 pairs,16 post-win batches of at most32events, and at most producer+reload processes, each300seconds with90M-import/1.8M-idle guards. Guest scheduling and default accelerated clock continue during pixel inspection. Accepted saved clocks naturally advanced to Junior day4 03:17 and Senior day3 23:20; clock338..341 observations are overlap diagnostics, not story flags. Output clock must be valid and no earlier than its exact pinned source clock, not a fixed finishing time.

## Finite checks and evidence boundary

```sh
python3 -B test_memory_live.py
```

Six adapted finite groups use artificial opaque colors, validate geometry/flip capture timing, refuse hidden/ambiguous captures, exercise a24-pair discovery/recall case, require original durable result and ordinary INPUT, reuse complete PPM parsing, and check profile validation. Optional `--verified-case PROFILE SOURCE OUTPUT` arguments read genuine source/output fields only; they never alter saves or run the game.

Complete runtime evidence used native SHA `b49eaa71885a02e9e096b9766f020576ef0a0381837cd036f0875bab49351e24`. Junior used23 pairs and Senior24; both earned actual1207/1988→1345, normal Bye, original UI save and fresh-only reload. Senior's genuine source was produced on cc7 and loaded normally into b49; it is not an all-b49 campaign. RECOMP-31 links the private pin table and structural comparison, and distinguishes those full runs from the new public entry-only probes. Cake, Skull, other coverage and final Mac/full-game acceptance are outside this controller's claim.
