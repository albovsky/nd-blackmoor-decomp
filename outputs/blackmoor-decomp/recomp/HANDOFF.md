# Handoff: recompiled GAME.EXE, state and next steps

For the Codex agent that finishes the native port. Written 2026-11-02. Main is at PR 278 (`deb83f82`); this note is the only change of its PR.

## Current continuation (2026-11-01, Pacific)

The resumed recompiled-host run rebuilt current main and replayed the opening and all four story legs from fresh scratch folders, chained through the game's own saves. New `story_route.py telescope-prep --save m7` collects lens 12, inspects the empty tripod, reads all chart pages through S2026 and returns to S2010 view 2. Run it through `route_load.sh`, then use `route_tools/check_route.py` on its log and m7 save. See the current ROUTES.md section and private `work/recomp-playability-20261101/` evidence. Telescope flags 1309/1906 remain 0; Jane's loan is a prerequisite, not a host defect to bypass.

Guest worker threads now execute the original CRT/MFC startup, real CAL/CEL work and cleanup under a serialized native scheduler. The new `linda --save m8` leg sets flag 1570 and saves in S4408; `jane-intro` follows from m8 through Jane's conversation to S1206 Memory. Both pass in a fresh current-build chain from New Game through all earlier saves. `jane-intro` ends inside the puzzle and rejects `--save`; complete Memory before saving its continuation. Next story work is Memory/Jane's telescope request and timed jigsaw. The alternative first-conversation choices and telescope loan are still unverified; do not confuse a driver miss with a runtime blocker.

Four focused thread tests and the ARM64 headless/macOS builds pass. Actual Jane animation, natural worker exit 0 and process-stop cleanup are checked headlessly. Real-clock/app callback behavior and other worker families remain unverified. Independent frozen review is pending. See `tasks/RECOMP-01-guest-threads.md`, ROUTES.md and private `thread-contract.md`.

The original handoff below describes the earlier baseline. Its telescope-first step is superseded by the loan prerequisite and verified m7 preparation above. The macOS app and final full playthrough remain incomplete.

## State

* The game is lifted from the owner's GAME.EXE to C (`lift_recomp.py`: 4,605 functions lifted, 165 refused, see below) and runs on the native host (`rc_core.c`, `rc_win32.c`, `rc_ddraw.c`, `rc_dsound.c`, `rc_bink.c`, `rc_main.c`). Lifted C is a build output, never committed.
* **What runs (headless, `rc_headless`, deterministic virtual clock):** New Game, the intro movies, Nancy's room, the suitcase and phone, Load & Save, the credits, and the story routes of `route_tools/story_route.py` through four legs: the stair lock piano, the key and grease, the S3450 slider puzzle, and the moon box (S2038) to the telescope lens (S2076). All were run end to end from a fresh game directory on 2026-10-31.
* **Furthest scene reached:** S2076/S2074 (lens taken), then S2040, S2011, S2010; S2014 (tripod) opened and looked at. The telescope step is not finished: tripod S2014, star chart S2015, telescope S2078 are untried or unconfirmed (`ROUTES.md`, "After the moon box"). Confirm progress with `RC_FLAGS` (the scene script flags), not only pictures.
* **Mac app** (`macos_recomp.mm` + `build_macos.sh`): builds clean to `outputs/blackmoor-decomp/Blackmoor Recompiled.app` (ad-hoc signed, min macOS 27.0). I launched it once against `work/gamedata` with a scratch `--save-dir`: the window opened, the game thread ran, mouse moves reached the game's WndProc, and the run ended on a stop request (the window was closed). **Nothing else about the app is verified:** window size and widescreen fit, click/typing in the app, Bink video in the window, real audio timing and crackle, where saves land, clean quit. That launch was not muted (before the no-sound rule below); no audio problem was checked.
* **Not done:** the telescope step, a `--capture-audio` option, making the recompiled app the default launch (the old hand-written scenes build is still the default), the story after the moon box.

## Known defects and open points

* Internet browser page in the suitcase phone: single clicks on SEARCH did not react in two runs (ROUTES.md).
* The `GetAsyncKeyState(VK_LBUTTON)` loops (credits) need short clicks (hold 40 ms).
* Click accuracy: a click counts only after the pointer moved onto the hotspot first (route helpers emit a move 1 s before each click). The app's `on_pointer` forwards moves and button state; check the same holds for real mouse events.
* `save_dir` is used only for paths under `Documents*` (`rc_win32.c:130`); the app default is `~/Library/Application Support/Blackmoor Recompiled`. Check that saves and Game.ini writes land there and never in the game folder.
* Python-oracle and native timelines differ by seconds (the native clock counts calls); compare anchored pictures.

## Hand-ported bodies and unlifted functions

`rc_unlifted.c` registers hand ports at the original addresses: strspn 0x515da0, strcspn 0x515de0, strpbrk 0x515d30, pow body 0x50f462, exp 0x50de00 and 0x50de0a, memmove 0x50ed50 and 0x50fa90, strrchr 0x50db50, strcmp 0x5130f0, `__crtLCMapStringA` 0x5129a0, `__crtGetStringTypeA` 0x515e1e. libm stands in for the x87 pow/exp (no extended precision on the host).

`work/build/recomp/lift_census.json` (written by the lifter) lists the 165 refused entries with reasons. Counts by reason: 11 hand-ported (above); the rest are `part of <va>` pieces with `int3` (0x528b6c, 0x528bc4, 0x528c48, 0x528d38, 0x528fa0, 0x529058, 0x529128: CRT/SEH tails), `ftst` (parts of 0x513546), `fnstenv` and an unresolved callee (parts of 0x51779c), and one function with `int3` inside the code. If a route hits an unlifted body the run stops with an unresolved-address message: hand-port it in `rc_unlifted.c`, add its `put(va, fn)` and a test of the port against the original behaviour where one exists, and rerun `lift_recomp.py` (the hand-ported list is read by the lifter, `lift_recomp.py:35`).

## Next steps, in order

1. Finish the telescope step: from S2076 take the lens, S2014 tripod, star chart S2015, telescope S2078. Add a `telescope` leg to `route_tools/story_route.py`, confirm flags with `RC_FLAGS`, verify from a fresh directory, save as the next checkpoint (`m7`).
2. Script the remaining story legs to the ending credits, chained through the game's own saves. Sources: `PLAYABILITY-LOG.md`, `work/playability-20261024` logs and probe scripts (`after-*.py`), scene scripts via `route_tools/mkscenes.py`/`hot.py`/`chain.py`. Fix host defects and hand-port unlifted bodies as they show up.
3. App work: window size and 640x480 mapping with widescreen fit (`native_display_geometry`), mouse and keyboard, video, a `--capture-audio FILE.wav` option (write what `rc_audio_render` produces, then inspect for clicks, gaps and timing against the video), save location, clean quit, then make the recompiled app the default launch (a flag or a clear name) while keeping the scenes build working.
4. Only when the whole game plays to the credits natively and the whole-file x86 match still holds, update the status documents (`AGENTS.md` rule: never call the game complete before both pass).

## How to build and run

* Linux/other: `GAME_EXE=work/original/GAME.EXE recomp/build_linux.sh [builddir]`. Mac app: `GAME_EXE=... BUILD_DIR=<dir> recomp/build_macos.sh` (needs Xcode tools, Homebrew FFmpeg, python3 with pefile and capstone; `RELIFT=1` regenerates the lifted C). In a git worktree `work/` is not present: symlink the main checkout's `work` into the worktree (the symlink is not tracked).
* Headless: `GAME_EXE=work/original/GAME.EXE RC_GAMEDIR=<dir> RC_OUT=<out> MAX_IMPORTS=6000000 MAX_IDLE_POLLS=20000 INPUT="..." rc_headless`. `RC_GAMEDIR` is a **scratch copy** of the game folder (Ciftree, CDSound, CDVideo, Game.ini, Nancy.cid, display.drv): saves go to its `Documents5`. Other variables: `RC_FLAGS="1000-1030"`, `RC_TRACE_MS=from-to`, `SCRIPT_TAIL_MS`, `RC_REAL`. Long legs need `MAX_IDLE_POLLS=900000 MAX_IMPORTS=90000000` (slider) or `300000` (moon).
* Routes: `route_tools/route_load.sh OUT SLOT_Y "steps"` loads a save from the main menu and runs the steps (anchor `S2010.CIF`); `python3 route_tools/story_route.py {stairs,lock,slider,moon} --save NAME` prints a leg's `INPUT`. Save chain: `m0` (bedroom after the suitcase) then `m1`, `m4`, `m5`, `m6` (the legs write them). The Load & Save list order is the game's, not by name: read the row y before each load (rows 42.5 px apart from y = 105).
* App: `BlackmoorRecompiled --game-dir DIR --save-dir DIR --mute --log FILE` (`BLACKMOOR_GAME_DIR`, `GAME_EXE` also read).

## Rules that apply

* Never modify GAME.EXE, `work/gamedata` or `work/original`. Game data and the lifted C are not in git.
* No sound and no focus-stealing windows on Glib's Mac: always `--mute`, launch in the background (`open -g -j` or offscreen), prefer headless runs, verify audio by capturing samples to a WAV. Do not bring the game window to the front.
* No `rm` of any kind, one command per line, nothing chained. Reusing a branch that has merged history: merge the remote branch with `-s ours`, never force-push.
* Codex review before merge; squash-merge your own PRs when it is clean. Slice completion, ledger and ownership rules are in `AGENTS.md`; the Track M finish line there is the x86 match, which already holds.
* Report outcomes plainly: what was run, what was only looked at, what is unverified.

## Where the notes live

`recomp/ROUTES.md` (routes, hops, puzzle rules, debug switches), `outputs/blackmoor-decomp/PLAYABILITY-LOG.md`, `AGENTS.md`, `outputs/blackmoor-decomp/COORDINATION-STATUS.md`, `WORK-SLICES.md`, `PROJECT-SPEC.md`, `work/playability-20261024/` (native-port logs and probe scripts, not in git).
