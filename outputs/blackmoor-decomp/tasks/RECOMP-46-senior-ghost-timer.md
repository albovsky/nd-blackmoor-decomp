# RECOMP-46: Check the original Senior ghost-hunt timer

The route verifier assumes Junior's active flag2039 and permanently rejects2040. Original difficulty2 instead starts timer2/180 seconds and flag2040; difficulty0 starts timer1/300 seconds and2039. Read the original signed16 saved mode at0x9034, accept only0/2, and check the matching active flag while requiring the other to stay0. Preserve the original start/reward-clear interval, thirteen ghosts, prerequisites, night clock, held item, stop and save checks. Do not change game timers, inputs or difficulty.

## Scope and acceptance

Start from main after PR #339, squash `e836041137a64bee8184d6694ccf55148a4667b1`. Root alone integrates/executes/publishes. Modify only the route verifier, add a new finite test file and document the actual result. Indexed tests, original game/EXE, host/lifter/app, ledger/evidence and whole-file x86 track remain untouched.

Four focused regressions already reproduce the missing behavior: a valid Senior hunt is rejected, invalid saved modes1/−1 are accepted, and Senior can incorrectly use Junior's flag. Fixtures also retain start/clear/scope/all-thirteen-ghost guards. Pending: collect the small candidate after the fixed-column chapter's helper pins no longer need the old verifier; run focused and existing route checks, independent Sonnet high review of frozen code, then actual current-build Senior progression through the hunt with original UI saves and fresh reloads.

Native source remains92bc2a69067eb4aa00f371d693d9198d6f67f121, headless SHA `6041e31e9d486111f6a0b64a7ce9764d52c292f35339fa1a84f3be7c18d31de4`, original GAME.EXE SHA `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`. Bind only the newly earned Senior campaign. Senior Betty m13 `35f26d85…` is accepted with full404/40/bag and a fresh reload; the fixed Venus/Jupiter/Moon-key/Moon-column chapter carries405 including1196. No historical success SAV is a runtime source.

Private source/candidate pins are in `senior-ghost-checker-candidate-v1/` and `release92bc-senior-columns-static-prep-v1/`. An old source note mistranscribed S4176 row0: it clears1192 and1976, not1958; row1 clears2039/2040. Earned1958 remains1. The mode-only code leaves that existing completion logic unchanged. Keep this correction explicit in review.

Junior's fresh current-build New Game chain already passes the native Mac credits endpoint. Senior and whole-game completion remain unclaimed. Publication stays in original authorizing chat `01a170c4-6fa4-7831-9a46-f076fbcfab37`; original HOW TO WORK 5 authorizes independent review then squash self-merge.
