# Recompiled host: normal Quit cleanup

Continue the original human authorization for one reviewed native-port slice per squash PR. Root owns integration and publication. Base is PR283, 89fc8fd8. Original executable/data, function ledger and evidence remain unchanged.

## Defect and change

The genuine menu Exit Game → confirmation → MFC/CRT teardown stopped at unlifted 0x515d1e. Its derived-entry extent inherited the next entry at 0x515d30 and therefore included five int3 padding bytes. The committed byte-exact assembly `asm/FUN_00515d1e.s` distinguishes 13 code bytes ending at 0x515d2b from that padding. The bulk wrapper now uses that exact extent, guarded by the parent, span boundary and five padding-byte checks. The instruction lifter's global interior-int3 refusal is unchanged.

The generated callback executes the original push of [0x63cc50], SetUnhandledExceptionFilter import call and ret. It remains registered at its original address and executes through the original CRT cleanup table; no synthetic success, skipped cleanup or replacement function is introduced. The existing host filter shim returns 0; this slice does not claim general Windows exception-filter chaining or exception delivery.

## Acceptance

Two static tests pass in 22.428 seconds: the exact 13-byte body and registration are emitted, and a synthetic interior int3 remains rejected without execution. The baseline lacked the callback. The census changes only by +1 lifted/-1 refused (4,606/164); generated original code remains private. Generated output: `work/recomp-quit-lift-tests/lift-4_dd5xzm/`.

Actual native menu Quit from the game-generated m8 save in a fresh scratch game folder reaches `ExitProcess(0)` in 1.82 seconds. Inputs are ordinary move/click events at MENU75,448 → Exit275,425 → confirmation217,271. Log `work/recomp-playability-20261101/quit-cleanup-candidate/run.log` records critical-section/TLS/global cleanup, SetUnhandledExceptionFilter(0), then ExitProcess(0). Headless harness reports this guest exit as its existing RESULT stop reason; this is distinct from a requested host stop. Baseline log `thread-normal-quit-final/run.log` ends at unresolved 0x515d1e on the same path.

Pins: GAME.EXE `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`; native `c483fc474778f6f603c2f63b4f2de759a7866a92150df17fc64310b815ba8de6`; bulk wrapper `dbe43758f40b19c16bb5a663e00f64e99f482d7ae39b0a1f4e5ab209b2be98b4`; test `f16fc57d69c8d3f774f0229c1f4938fa5d080d3b96b61c3b3ad49d6aadb7804a`. Build/test logs: `quit-final-build.log`, `quit-final-tests.log`, `quit-final-app-build.log`. Independent Sonnet static review accepts frozen dd1f94cf with no P1 or blocking P2. ARM64 bundle build/signing passes without launch.

## Limits

This proves normal headless Quit from m8, not exceptional abort paths, active movie/worker Quit in the real-clock application, filter chaining, all CRT cleanup registrations, final background app playthrough or full campaign completion. No fault, sanitizer, mutation, oracle or audio-device test is used. Story objective remains Jane's telescope loan/jigsaw, then lens installation.

Review coverage limits: the exact census delta was observed in retained outputs, not asserted as a permanent total by the test. Parent/span/padding guards have no negative fixture; they are independently checked against immutable original bytes and audited extents. Keeping this one-entry correction local avoids a general boundary refactor. The final test path also honors BLACKMOOR_ORIGINAL_WORK for original input, as the reviewer suggested. Generalizing size extraction from xrefs is deferred; the existing explicit extent and padding guards suffice for this fixed executable.

The reviewed test-path follow-up passes both checks again in23.366 seconds; retained log `quit-reviewed-tests.log`.

Final Sonnet follow-up accepts frozen900d33fe with no P1 or blocking P2 (`quit-followup-review.txt`); production code is unchanged from the accepted initial review.
