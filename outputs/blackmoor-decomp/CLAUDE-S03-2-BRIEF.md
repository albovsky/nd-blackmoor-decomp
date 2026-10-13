# Claude next task: S03-2 AVF playback kernel

Recover the original AVF playback scheduler and frame handoff as a portable C module. The decoder answers how a frame is decoded; this slice answers when it is requested, which buffer can be presented, and how playback stops or restarts.

Read [the S03-2 packet](tasks/S03-2-avf-playback.md) for ownership, source anchors and acceptance checks. Use a separate worktree. Boot retains sole ownership of shared app, parser, executor, platform and central build files; supply an integration proposal.

Before switching, preserve and commit the final S03-1 decoder changes and write its handoff with hashes and exact comparison counts. Root observed committed `fdc3ab68ec77baf4343fe69901c9ec94f39e1188` plus four modified decoder/test files on 2026-10-13; none were reset or collected. Record the actual final commit. Root will review it separately. S03-2 source recovery can proceed while that review runs; bind its native decoder dependency to the final reviewed snapshot before acceptance.

Return an original-backed timing/state/ownership specification, public header, implemented kernel, deterministic native/original trace comparisons, real-corpus playback checks, sanitizer results, a frozen commit and receipt. Parent S03 remains open until Boot integrates and verifies playback through the game.
