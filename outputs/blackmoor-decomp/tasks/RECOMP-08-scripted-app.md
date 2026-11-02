# RECOMP-08: shared input and native Mac gameplay

The Mac app accepts `--input-file FILE` through the same parser/scheduler as headless INPUT. It queues ordinary game mouse/key events on the guest main thread; observations are read under its execution token. It posts no OS input or story/clock/inventory/RNG writes. Interactive launch has no script hook. Root retains original-chat authorization to review and squash-merge; delegates prepared private candidates only.

Valid route pacing, late-anchor spacing, holds, default5000ms tail and existing trace formats are preserved. Invalid/unknown/truncated inputs now fail atomically rather than silently skipping/truncating. Limits:512steps/65536bytes,63-byte anchor,7-byte kind,four integer args. Empty headless INPUT still means no script; an empty explicit file is an error. Legacy RC_FLAGS/SCRIPT_TAIL_MS syntax remains. Workers consume no steps. Missing-window delivery, failed shots, missing anchors, early exits or external deadlines cannot pass Mac completion: all steps plus the script's own stop and the existing normal-guest classifier are required; failure exits6.

## Acceptance at 2026-11-02, 01:29 Pacific

- Signed ARM64 app SHA `68e4bf0e1b7e2e6bfa7c4b4a24b81ac994c78ef1295b5a26dfd92e87ff6b41af`: fresh New Game/Junior/intro reaches S2010/view5/held-1 after S0/view0/held-1. Five steps and two observations complete, own tail-stop, exit0 in210.31s. Open/stop stay inactive/nonkey/nonvisible with zero activation notifications. The logical frame shows Nancy's bedroom. Ordered authored scene opens and504-frame Bink metadata progress into later scenes without movie-skip input; per-frame decoder parity/display synchronization is unverified.
- Offline PCM capture:44100Hz stereo16-bit,6881805frames/156.05s,peak31864,no clipped samples. Never played. The54.264s process/PCM gap remains a real timing issue; render-then-sleep adds cadence bias, but setup/render/locking/cleanup durations are not separately measured. A separate clock fix is queued; no audio-quality/sync pass.
- Four finite device-free C cases pass against actual module source: mixed event trace/late anchors/tail, completion guards, parser bounds and file parsing. No guest, worker threads, faults, oracle or device executes. Root evidence: `scripted-input-root-tests-20261102/` and its adjacent log.
- New native headless SHA660289832b7e6e728109f5f19f895956da6f7720f79c0f26e7c4416656841455 passes all12 fresh New Game→m12 runs, each with only its preceding UI-produced save in a separate clone. Every script delivers fully and requests its own stop; public route checks and producer/copy hash identity pass. `scripted-fresh-chain/verified-chain.json` and stable checkpoints preserve this partial-campaign regression.
- Actual Mac load and keyboard filename entry produce genuine app12.SAV in77.34s, all32steps complete, safe2701/view0/held-1. Save length170770, SHA70ac3afa81955629b3c1ee60a1abad59937fccc042f1ae0b646b49e0a508ea71. It loads the new headless chain's m12, preserving that source. A separate fresh app12-only native reload passes in40.77s with all8steps complete, byte-identical copied save, unchanged scene/held item and required flags1160/1541/1782/1906/2002=1,1963=0. Both runs remain hidden/inactive; see scripted-app-save-verified.json and scripted-app-save-reload-20261102/.

Private evidence is under `work/recomp-playability-20261101/`: `scripted-app-opening-first-20261102/` contains receipt/verified-opening/log/frame/WAV; `scripted-app-save-20261102/` contains the original-UI save and receipt. `--save-dir` is a prefix ABOVE Documents5; the mapped suffix still includes Documents5/game subfolder. All data/user prefixes are private scratch copies. Original GAME.EXE remains afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45.

## Limits and review

Queued game input differs from physical AppKit events. Physical input/right rotation, displayed widescreen pixels, synchronization, full campaigns/both difficulties and final background credits remain incomplete. Shot callbacks log observations only; the image is post-join logical framebuffer evidence. Prior capture/platform checks are not claimed as rerun. Isolated app linking reuses lifted objects with deployment-floor warnings; only this Mac is validated. Game host, lifter and capture implementation are unchanged.

New registered fixture hashes are regenerated in a clean frozen checkout, excluding parked files. Coverage counts, every function status and lifter fields match the parent (`scripted-refresh-receipt-20261102.json`); no new port credit or acceptance change. Independent Sonnet review is pending against the final candidate.

## Source pins

- `recomp/rc_input_script.c`: `c5e6196fdf430c7f0779203830e82ac9ff55e4ee3641042c3f16e2e78cc9f3ea`
- `recomp/rc_input_script.h`: `8bdcf5fce2e5fc36180800b4a249d87fa0bd42728526d159e3c8564335d160d0`
- `recomp/rc_headless.c`: `29899f5524245a334ce781d7d5b92e620a1550270b7d50a8f60bdd1ccd823b25`
- `recomp/macos_recomp.mm`: `d33404c79bbd113802955a891f5ac3fddd664eba64b8364d0c88ddd64f32bb1b`
- `recomp/build_linux.sh`: `d8e0abe345090edbddcf4cb4fb753221e8f6f8ff59d2166db4535a533deaf26f`
- `recomp/build_macos.sh`: `42480f0075864cd80836edb5f2cb14d6bf5a85361539d64dd94b50f36edbbd11`
- `tests/recomp_input_script_fixture.c`: `8706c635956416e7ce9f9070b3bf6060871b628d61c4bba7b9dec21811f622fe`
- `tests/test_recomp_input_script.py`: `73e0786701c8f2a4b580462a3a0f9ed84ef5ac4c45d51a1d3a7d77486417f5b9`

Independent Sonnet high review accepts frozen bafb6b3d with no P1 or blocking P2 (`scripted-app-review.txt`). Both static freshness checks finish successfully. `scripted-reviewed-pins.json` confirms that final committed evidence hashes match the clean455097c8 derivation receipt;455097c8 identifies the code snapshot, while bafb6b3d adds those records and reports. No broad mutation or intentional guest-fault runs were added; remaining missing-path/null-shot/differential cases are nonblocking coverage gaps.

Whitespace compatibility: leading/trailing whole-text/file whitespace is accepted; whitespace-only INPUT, whitespace-only segments or trailing spaces inside fields reject rather than silently stall/skip. Only unset/empty headless INPUT means no script. Legacy huge/malformed tail handling and the unreachable-at-boot zero-time sentinel remain unchanged. Final post-review changes clarify documentation only.
