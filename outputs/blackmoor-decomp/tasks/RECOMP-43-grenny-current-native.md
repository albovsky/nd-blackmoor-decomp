# RECOMP-43: Grenny on caller-pinned native builds

The private crossing controller was tied to an older cc7 build. The public `grenny_live.py` now uses the existing ordinary-input Session with explicit native/source pins and a source profile. The original crossing, pickup and exit actions retain their 20/24/12 bounds. Inventory SELECT/PUT coordinates come from genuine saved bag order, so Cake item 1 and all prior items survive the Mars key reward. This changes the controller, not the game engine or clock.

## Acceptance

- Code freeze: `f432d7bf8d5abc1c7011d2387a269102c81778a5`; native source/build freeze remains `92bc2a69067eb4aa00f371d693d9198d6f67f121`.
- Headless ARM64 SHA-256: `6041e31e9d486111f6a0b64a7ce9764d52c292f35339fa1a84f3be7c18d31de4`. Original GAME.EXE: `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.
- Actual fresh source m64: `54d0e639be5625bdc23f417e4b058947cf806571a2dd195d4e1808eb6a513179`, S2460/unheld, day 4 10:26. Accepted source receipt: `e48235670f8a44b4babbd09c5358eec22a876b13d7889227474f0e88968563f0`.
- Caller profile: `71792419d524347d7d2b3296710217195cbf7654052cc2d6ad6d97a689e807ad`; 339 saved fields, all 40 inventory cells, ordered bag, clock and 3,560 file hashes. Complete seed/clone inventories are checked, excluding only the clone's runtime Documents5 tree.
- Actual first crossing succeeds: m65 `f52c6f1e9784033bda32a2bef9e0bd8969bb4366a3ad8cfa3acf11ef89340a11`, S2460/unheld, day 4 10:37. Flag 1978 proves the crossing win; 2064/2226 are accompanying entry bookkeeping. Only these three saved fields and physical item 8 change. All 14 source items, including Cake, remain in order, followed by 8.
- Producer: 129 events, 11 ACKs, 20 closed shots, exit 0. Fresh output-only reload: 23 events, 6 ACKs, 7 closed shots, exit 0. Real held item 8 is observed in both. All assets and protected inputs remain unchanged. Receipt: `e850d9c56268563903113a65757c15b78fd4b2350cc9f2049f7b43e6ca59743c` under `work/recomp-playability-20261101/release92bc-grenny-first-v1/`.
- Six device-free test groups pass (0.008 seconds). Synthetic saves exercise the real parser/source/output guards and reject missing Cake, reordered bag, absent key, held key and an altered prior event. Asset tests reject omitted/changed INI data. The live-latch regression failed before the fix and passes after it. No synthetic save is passed to a game process.
- Independent Sonnet high review of 27dfff accepted the policy and found two P2 gaps. They were fixed with saved-reward fixtures and complete asset checks. Independent delta review of f432d7 accepts with no P1/P2. Root accepts the findings and the real combined run. Review artifacts: `/private/tmp/blackmoor-grenny-review.txt` and `/private/tmp/blackmoor-grenny-delta-review.txt`.

Flag 2127 is an internal readiness/overlay latch. It is absent from live logs and remains checked only in completed saves; it is never used to steer play. The bounded original-scene note is private at `release92bc-grenny-binding-v3/2127-source-note.json`. Original v4 action payloads match the exercised reference; no hidden board, RNG or score reads are used.

Acceptance belongs to the combined outer receipt. Per-process receipts retain `accepted:false` by Session design; their exit codes, complete protocol and source/copy checks are required by the outer verifier. All clocks quoted above are serialized save clocks; later live observations may be a minute later.

## Limits and next work

Junior only. Many-loss runs, the 20-attempt exhaustion path and a 15-item source becoming a full 16-item bag are not verified by this native run. Arbitrary caller profiles are not claimed to have the recorded 339-field coverage. PUT/save/reload audit paths are covered by this real run rather than isolated fixtures; flag 2127 staying 0 across many losses remains unverified. The Aeolus result is one actual full solve, not an all-board guarantee. The existing public Session has a stricter 1.8M idle-poll bound than the legacy controller; the independent review found adequate margin for the unchanged policy. Senior gameplay, remaining columns/bell/forge and the final fresh earned Mac credits remain pending. This slice adds no function-ledger or x86-match claim.

Publication authority stays in chat `01a170c4-6fa4-7831-9a46-f076fbcfab37`, publisher root. Original pasted HOW TO WORK 5 authorizes independent review then self-merge squash; request SHA `fdcf9db82c9fb1e422abf03c5eca7439f80f41742c553ea62df24aa40d6acabb`. The native executor and publisher are root; delegates prepared private candidates and metadata only.
