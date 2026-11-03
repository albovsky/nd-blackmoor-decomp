# RECOMP-47: Recognize the original Senior glyph-request path

The glyph-request verifier assumes Junior's instruction/return path. Original saved mode2 instead uses3571→3580 after3585, while mode0 uses3562/3513/3522. Select the exact path from the original signed16 saved difficulty at0x9034, accepting0/2 and rejecting unsupported modes. Preserve pending/win/reward flags, prerequisites, source clock, safe exit, requested/art agreement and required resource-open ordering. Do not normalize unrelated scenes or change game input, difficulty or puzzle rules.

## Acceptance

Start from main after PR #340, squash9a0f8e84e5c0177d420436c671eb5a77527774cb. Root owns integration, tests, native execution and publication. Modify only the route verifier, add a new focused test file and record actual source-specific gameplay. Existing indexed tests, host/lifter/app, original data/EXE, ledger/evidence and x86 track stay untouched.

Four focused fixture groups already fail before the fix: valid mode2 is rejected, mode2 accepts mode0's path, unsupported mode1 is accepted, and the Senior resource-open checks cannot be reached. The fixtures reuse the existing DragonLight fixture without duplicating its suite. Pending: collect the minimal code, run focused/existing route checks, independent Sonnet high frozen review, then actual current6041 Senior m27→m28 plus fresh output-only reload.

The genuine Senior source currently reaches Bul m24 `5b52a6a4e3cf66505462f683753feff85eecb032658e1298c5266a4277408cbc`, S3510/view4/unheld/day2 15:40/bag[11,12,6,19,20,17,21,7]. Public Bul wins its first original AI1 wager and verifies realheld7 in producer and fresh reload. A copied-config outer false refusal is corrected through a separate read-only audit reusing the independently reviewed exact-copy inventory helper; neither native session is replayed. Accepted receipt `c9b790843d6c3f234858446f57b651f674bf5e42a79f8511c68ce57c5dbb957c`. The next fixed slide-ball/Saturn/Dragon legs carry409 saved fields/full40/order and the established incidental1707 rule; no historical SAV is a runtime source.

Native source remains92bc2a69067eb4aa00f371d693d9198d6f67f121, headless SHA6041e31e9d486111f6a0b64a7ce9764d52c292f35339fa1a84f3be7c18d31de4, original EXE SHAafd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45. Exact effective-row/source/candidate pins are private under `senior-glyph-request-candidate-v1/`.

List unverified alternative dialogues/paths and timing variants after the bounded run. The fresh Junior chain has separately passed native Mac credits; Senior and whole-game completion remain unclaimed. Publication stays with root in original authorizing chat01a170c4-6fa4-7831-9a46-f076fbcfab37 under the existing independent-review/squash-merge authorization.
