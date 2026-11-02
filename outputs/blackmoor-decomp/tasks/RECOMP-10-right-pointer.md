# RECOMP-10: route right-button input to the recompiled game

The Mac frontend previously discarded every non-left callback. It now keeps a complete left/right mask and queues normal WM_RBUTTONDOWN/UP and motion messages, with signed logical coordinates and current Shift/Control bits. The left-only API preserves the right state. A host input mutex protects buttons, keys, timed holds and cursor reads; the only nested lock order is input then message queue, with no guest dispatch under either lock. The pure planner emits at most three messages and retains the existing hover-before-down behavior.

`pointer:x,y,mask` adds explicit complete button state to both script frontends; exactly three arguments and mask0..3 are required. Release requires mask0. Legacy timed click/key behavior remains intact, including overlapping key2/timed2 state. Physical right alone reports GetAsyncKeyState(2)=0x8000; the historical key/timed paths retain0x8001. This does not implement or claim Windows recent-press latch parity.

Root retains the original pasted request's implementation, review and squash-merge authority. Delegates supplied private candidates/tests only. Original game files, story state, RNG and clocks are not patched. This slice adds no function-port acceptance or x86-match claim.

## Acceptance, 2026-11-02, 03:41 Pacific

Four finite C tests pass:71 planner cases/122 exact messages; right press/move/release script delivery and six bad-mask/arity rejections; unchanged legacy mixed trace;19 actual-host async-state checks. An initial candidate suppressed legacy key2/timed2 state; its ordinary regression fails four checks, while the correction passes all19. No fault, sanitizer, mutation, oracle or guest execution is used by these fixtures. Root results: `work/recomp-playability-20261101/right-pointer-root-tests/`.

The opt-in actual-AppKit fixture calls ten hidden content-view methods in each separate fit/stretch process at960x480. Both pass four timer ticks/five presentations, all expected logical coordinates/buttons, zero visibility/key/activation observations and clean closure. The factory initially supplied button0 for right events; the fixture now sets the documented Quartz button field on a private event copy and verifies type, button, window and location before direct delivery. It never posts OS events. See `work/background-platform-test-results/native-djrfvsiv/` and the adjacent root log. This verifies platform-to-callback mapping, not physical mouse delivery or displayed pixels.

A fresh native headless run loads unchanged genuine m10, follows the ordinary Betty/Drake dialogue into seedlings2348, picks non-square type10, and sends right press/release at150,180. All158steps complete with the script's own stop, exit0 in25.53s. Actual captures show40x100 at142,143 becoming100x40 at112,173. A clockwise pixel comparison outside the cursor matches2321pixels with0mismatches; the two settled after frames are byte-identical. No drop/save occurs;2002/1160/1541 remain0. Private `right-pointer-rotation-run/` records input/native/original/save hashes, shots and `rotation-pixels.json`. The probe tests a rotation, not another puzzle victory.

Native headless SHA `0c5fc594069a23886c9357a9556c2715d1e3758a17aff04bc962211d15dd1245`; signed ARM64 app SHA `cbb2ef85b3953d8d41b9796c290426b4ea5b1a250e5d65833ca1ddd81511d51c`. Original GAME.EXE remains `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`, source m10 remains `70f0512d86c56569df3f70bbcc66a8eaf7f0a521c6de4582b5e5dfe12db64e77`. The app builds/signs without launch, reusing pinned lifted objects with the previously documented27.2-to27.0 deployment-floor warnings; no older-system portability claim.

## Remaining checks and limits

All twelve fresh New Game-to-m12 navigation runs pass on the new host, including the optional Memory entry. Every script completes through its own stop; preceding output/source/copied-save hashes match. Stable saves and verification are in `right-pointer-fresh-chain/verified-chain.json`. The final seedlings/repair runs take32.01/77.39s. Required generated records were refreshed in a clean5aa08ff3 checkout: all statuses/classes/counts/native lift fields equal current main5abba5b3, including its1763 tested-equivalent peer claims. Peer integration changes no compiled source. Receipt: `right-pointer-refresh-receipt.json`. Independent Sonnet review and final freshness checks are pending. The broad suite is intentionally not run under the owner's restriction on crash-producing tests; no existing test is weakened or removed.

Physical mouse events through the complete app bridge, multiple rotations/packing victory, simultaneous-button ordering against Windows, focus-loss releases, recent-press latches, displayed widescreen rendering, both full campaigns and final native credits remain unverified. This is a host-input slice; private story continuation has separately earned the ghost-hunt reward, Jane's key and the East Hall slide ball through m25, awaiting reviewed route promotion.

## Source pins

- `recomp/macos_recomp.mm`: `3ad559a58b1427bf2c60bd7fa3933d3b5ca1e5b506e455f7561ddccffae29388`
- `recomp/rc_win32.c`: `c1eb027701fc8626140632ce1aaf4999901d1274363117d5eb50e8e3469b524b`
- `recomp/rc_input_script.c`: `c3234872475165d827d002cec7477a47437db12747a68c917cd6c7be3c04726c`
- `recomp/rc_pointer_input.h`: `e578e393465ce04ab25d4bebadc3778798415f152df38f2636efcc7d58759cc4`

Apple documents the [Quartz button-number field](https://developer.apple.com/documentation/coregraphics/cgeventfield/mouseeventbuttonnumber) used only to construct the fixture's private events.
