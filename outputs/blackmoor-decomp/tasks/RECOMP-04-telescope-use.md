# Recompiled telescope use and native reveal fix

Continue the human's original authorization: one independently reviewed squash PR per native-port slice; root integrates and publishes. Base is PR285/cc2a0610. Original game/executable, function ledger, evidence-hashed source and Track M remain unchanged.

## Actual blocker and fix

The original telescope path reached2081 and set1906, but the Mouselight reveal was black even after ordinary cursor movement. Guarded read-only observation showed the source image populated, pointer tracking active and the radius50 mask containing only149 nonzero cells instead of7825. This exactly matched testing squared distance against50 rather than its square root.

Generated entry0x50df94 stopped after its9-byte call-ending fragment. Its audited assembly expressly continues into0x50df9d; that157-byte body contains FSQRT at0x50dfbc. The bulk wrapper now lifts those contiguous original code ranges together for this one entry, guarded by their recorded extents.0x50df9d also remains separately registered. No math replacement, hand-authored mask, state injection or broad fall-through rewrite is introduced. The original mask builder and renderer execute unchanged.

The corrected native shows the red mural through a normal radius50 circular reveal. A private observer, called only at existing shot boundaries using guarded rc_ptr/memcpy reads, finds all10000 mask cells equal the expected circle:7825 nonzero,0 mismatches at three ordinary pointer positions. Baseline has149 and7676 mismatches. Observer diagnostics do not count as production gameplay; the unchanged production headless harness separately captures the visible mural and completes/saves the route.

## Original story route

`story_route.py telescope-use --save m10` reloads earned-loan m9/3510view4, exits3507/2037=1 and3305/2036=1, completes the real incoming Petrov call through1601/1602/1605, drags the original UICO thumb to Bye, and returns6310→3337→3308.6310 already closed the phone; an earlier extra613,24 click accidentally hit the hallway exit and the failed3321/m10 save is explicitly unaccepted.

From3308:532,161→3340;292,189→3341;292,162→2000/2005;353,173→2010view1. One short right turn reaches0. The route opens2014→2078, selects genuine lens12 through inventory and records held_item12 with1906=0. Original2079 removes the lens and sets1309;2081 sets1906. Back out normally, return to2010view19 and save m10. The original no-Ethel branch and first incoming Petrov call are required; alternatives stall at unseen anchors and are unclaimed.

## Verification

- Production native `f8b34e6d2c64d85c951aa336d6c05607d3199ea5aac1ccd11d18bd9b1142be58` runs the public INPUT from a fresh m9-only game clone, reaches2078/held12→2081/1309=1906=1, returns2010view19 and saves m10 in11.28s (`telescope-sqrt-public/`). Fresh m10-only clone reloads the durable completion state in1.23s (`telescope-sqrt-m10-reload/`). Earlier c483fc47 runs established flags but their black image is not a visual acceptance.
- One generated-native fixture checks0,1,2,4,50,100,625,2500,5000 against sqrt with one valid ST0 and CW0x27f. Old build fails7 of9 by ordinary exit1; fixed build passes9 of9. With13 route-result cases, the focused suite passes14 tests in0.388s. The game entry and original x86 are never executed by the fixture; no output device is used. `RECOMP_BUILD` selects existing generated objects, and inputs are hashed unchanged.
- The route checker requires ordered3507/1605/2078/2081/2010 observations, held lens12 and1906=0 before use,1309=1 in the filtered view, durable1906 and delivery/prerequisite flags at the final observations, a clean stop and matching save-open/length. It does not prove pixel rendering, write provenance or save contents; native image/mask and fresh-copy/reload evidence supply those checks. Five new cases fail before the new mode/guards, then pass; eight prior cases remain green.
- ARM64 headless and signed macOS bundle build pass (`telescope-sqrt-build.log`, `telescope-sqrt-app-build.log`), without app launch. Lifter census remains4606/164. No ledger credit is claimed.

Private evidence: `telescope-use-receipt.json`, `telescope-d9-before/`, `telescope-d9-corrected/`, corresponding observer source/build receipts, `telescope-sqrt-test-{baseline,fixed}.log`, and saved checkpoints. No generated code, game data, images or saves are committed. Original SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.

## Explicit limits

The focused arithmetic claim is finite nonnegative inputs with CW0x27f, the domain used by this mask. The lifter still does not propagate EFLAGS across the__fload call; finite classification has ZF0 as the generated frame does, but NaN/Inf classification, domain errors, errno/matherr, other control words and general CRT parity remain unverified. Other call-ending fragments are not changed. Senior/alternate story branches, real-clock app rendering/input/audio and the full campaign remain unverified. Next: background app verification and Betty's missing-crank/seedlings branch. Independent Sonnet static review accepts frozen634bc528 with no P1 or blocking P2.

recomp/lift_recomp.py SHA-256 `548e8d0869e151462f55cfcf26ba00644bff880f810a659cc4ba3cf6a2ae1264`.
recomp/route_tools/story_route.py SHA-256 `dfeea649f7232e7f384dab80a6d7cae2a07711d86f7399a8d6b0c40910c6cc8d`.
recomp/route_tools/check_route.py SHA-256 `febfea533941801f7946ca32f52af5c343593cd31c97f89488a54812adbe544c`.
tests/recomp_sqrt_fixture.c SHA-256 `5dbfd366239a6afd428aa7b5ba866b736b98cf2b63156cffc95a39a7453efde1`.
tests/test_recomp_sqrt.py SHA-256 `773d9993c858309a7b7906a1a1f039a1033e2bc87653a548d3ef64a988f3b75a`.
tests/test_recomp_route_check.py SHA-256 `68dd7fb3d0e4c6d2f731ddbc6a8071991a5e7b09ab36f73013521dfd58ecd5f7`.

Review follow-up: the finite fixture now requires exact equality to sqrt, as requested; all14 focused checks pass again (`telescope-reviewed-tests.log`). Its receipt pins the fixture-linked generated objects by build directory; the fixture executable is distinct from the production headless binary. Earlier game legs and the other sqrt callers0x44bed5/0x490598/0x4f7207/0x4f95a4/0x4f9d18 were not individually re-verified by the targeted telescope run. A fresh opening-to-m10 replay is running separately; no passing claim is made before its receipt finishes. General CRT/positional-audio parity remains unclaimed.
