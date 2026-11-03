# RECOMP-44: Original Senior jigsaw route

The route tool previously supplied only the unrotated Junior solution. Add a distinct `jane-jigsaw-senior` generator and checker for the original mode 2, twenty-piece layout with 29 ordinary right-click press/release pairs. The existing Junior function remains byte-identical. No engine or clock change is made.

## Acceptance

- Frozen code: `44c3a783d6c41afab4e8368c707c14320111e535`; native source freeze remains `92bc2a69067eb4aa00f371d693d9198d6f67f121`, headless SHA `6041e31e9d486111f6a0b64a7ce9764d52c292f35339fa1a84f3be7c18d31de4`. Original GAME.EXE SHA remains `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.
- Actual zero-source Senior New Game selects the original 450,180 menu option and produces signed16 difficulty 2 at SAV+0x9034. Opening m0 and all six original pairs through m8 pass on the current build. Their accepted receipts are `e830eeff4ef5b94b7be48ab4850c9bde0c67606045b537724cd379b036668239` and `7f51c2c71f386d70c0bca9d1f416de4043c6a9670248d5c7107ddddc93be2c1f`.
- Source m8: `6d6e1fe7ddbea72860361ed2fbcafec3a9411204e3f0724828a763a1728bd1aa`, S4408/unheld, day 0 20:35, bag [12,6,17]. No historical save is a runtime source.
- The original 260-event `s9` body, including its newline, matches exercised SHA `119bc9451a1c84d459e8134f3e4b63b256c0060d30d2b0e120827111caf2648a`. The actual new `m9` producer adds the normal seven-event load prefix and changes only the typed save name: 267 events, native exit 0. The fresh m9-only reload completes 8 events and exits 0.
- Earned m9: `2e594565a5e9418f2e98119d2985a73cbcfda422a05457b230498bd56a3716a7`, S3510/view4/unheld, difficulty 2, saved day 0 21:06. Full 396 saved fields, all 40 presence cells, bag order, effective resources and protected inputs pass. Only 1424/1567/1980 rise; bag [12,6,17] is retained. Combined accepted receipt SHA `2f16a14a72ff89f51875a5441a1e7c9b36efb21f05b45ba91b1e3e91557fefea`, private `release92bc-senior-jigsaw-v1/receipt.json`.
- The checker requires instruction1237, unsolved3575, original3578 open, stable1234/art1234 with1980=1 and two safe3510/view4/unheld captures. Raw pending1234/art3578/1980=0 stays unmodified and cannot substitute for the win. Saved difficulty and prerequisite/loan flags are also checked; write provenance remains with the outer source/output/reload proof.
- Five new device-free checks fail before the feature and pass afterward (0.021 seconds). All 117 existing route checks pass (0.944 seconds). Independent root source comparison confirms the Junior function is unchanged. Original indexed tests and all ledger/evidence files remain untouched.
- Independent Sonnet high review of 44c3a783: ACCEPT, no P1/P2 (`/private/tmp/blackmoor-senior-jigsaw-review.txt`). Root accepts the findings and the actual combined native run.

## Limits and continuation

One observed Senior layout is covered. Other layouts, seeds, EA rows and shot-timing variants are unverified; an unrecognized art transition fails closed. The public checker does not establish source/write provenance by itself. Extra fail-closed branches have not all received separate fixtures. No complete Senior campaign or whole-game completion is claimed.

The fresh current-build Junior campaign has now reached earned credits headlessly, including Memory, Skull and Cake. Its generated Award.BMP is an original authored output, separately classified without changing any of 3,560 seed assets; details and derived audit hash are in PLAYABILITY-LOG.md. Its final background Mac endpoint still awaits desktop unlock. Next Senior work is telescope, seedlings and crank, then the remaining campaign.

Publication remains with root in authorizing chat `01a170c4-6fa4-7831-9a46-f076fbcfab37`. Original HOW TO WORK 5 authorizes independent review then self-merge squash; request SHA `fdcf9db82c9fb1e422abf03c5eca7439f80f41742c553ea62df24aa40d6acabb`. Delegates prepared private candidates only. The original data, GAME.EXE, ledger/evidence and whole-file x86 track are unchanged.
