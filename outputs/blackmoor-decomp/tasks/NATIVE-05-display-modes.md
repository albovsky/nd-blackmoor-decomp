# NATIVE-05: proportional and stretched native display modes

Owner requested widescreen support and chose BOTH proportional and stretched modes in this original root chat. Preserve current logical 640x480 gameplay, original assets, and persistent game mute. This is native presentation work; Claude owns full decompilation/matching and reserved ledger/evidence files. Root alone publishes after tests and independent frozen review, one slice per PR. Never modify original game files/GAME.EXE/game-source, ledger/evidence/extract/build outputs, tests/fl40_* or tasks/flNN-handoff.md. Avoid the crash-popup tests entirely.

Depends on reviewed/merged NATIVE04. Root owns macos_platform.[h/mm], app option parsing and build integration. Codex gpt-6.1-sol xhigh worker owns only NEW src/native_display_geometry.[ch] and tests/test_native_display_geometry.py in its separate worktree. No worker publishes.

## Behavior

Default proportional mode preserves aspect ratio with letter/pillar boxes. Optional stretch-to-fill uses the entire view bounds. Both use one shared geometry result for rendering and inverse pointer mapping; logical coordinates stay 640x480, top-left origin. Preserve out-of-surface coordinates in proportional mode so clicks in bars cannot become valid game hits. Stretch uses separate x/y scale factors. Original framebuffers/resources never change.

Provide native View menu choices (Proportional / Stretch to Fill), persist the choice in this app's NSUserDefaults, redraw immediately on change, and allow ordinary arbitrary-aspect window resizing instead of the old fixed contentAspectRatio. Optional --display-mode fit|stretch launch selection may set the same saved preference after validation. Do not crop game controls or invent extra scene imagery. The explicit stretched option may distort proportions; the proportional option remains available.

## Geometry helper contract

Portable C host adapter with enum FIT=0/STRETCH=1, rectangle of doubles, layout(logical uint32 width/height, finite positive view width/height, mode, rectout), and map-point using that same rectangle to signed int32 logical x/y via floor. No AppKit/audio/assets or globals. Reject invalid/NaN/infinite/zero sizes/mode/pointers; leave outputs unchanged on refusal. Clamp finite points whose inverse conversion exceeds signed 32 so floating-to-integer conversion stays defined, preserving outside-range semantics. Origin is top-left; caller performs AppKit coordinate conversion. Do not clamp ordinary outside points into the game surface.

## Acceptance

Tests first: meaningful observable fit/stretch layout, pointer corner/center/inverse mapping, widescreen/ultrawide/tall windows, points in bars/outside view, invalid/fractional/tiny bounds and safe overflow behavior. Keep proportional to a small geometry function; normal nonzero failures, no abort/fault/sanitizer/mutation/Unicorn/audio-output tests.

Root uses helper in actual draw and pointer callbacks, verifies normal ARM64 build, and exercises the real View menu/persistence and both display modes with captures where CUA permits. Coordinate automation has intermittent noWindowsAvailable; do not describe captures alone as click-through proof. Record hashes, exact checks, independent review and unverified branches. Source/runtime logic, sound state and original asset bytes remain unchanged. Whole game remains incomplete.

## Root validation (2026-10-24)

Merged main e81575cb before this slice. Geometry commits 7e80a992 and 21a41c39; root integrated the native View menu, persistent BlackmoorDisplayStretch preference, --display-mode fit|stretch, arbitrary-aspect resizing, shared draw/input geometry, and both native build inventories.

- Focused normal geometry suite: 8 passed in 0.289s (`python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p test_native_display_geometry.py -v`). Worker confirmed failing stubs and the rounded multiplication overflow regression before correction.
- Normal ARM64 app and standalone platform dylib build passed with warnings as errors. Local build logs: work/playability-20261024/display-first-build.log and display-platform-build.log. git diff --check passed.
- Actual GUI: copied generated bundle under /private/tmp/blackmoor-display-check.TduX7A, changed ONLY its generated bundle ID to com.blackmoor.reconstruction.displaycheck and ad-hoc resigned to keep test preferences separate. Launched explicitly --mute --display-mode fit against unchanged owner-local GOG data; zoomed ordinary window to 3024x1748 capture. Proportional preserved centered 4:3 image with black side bars; View > Stretch to Fill immediately filled the content width. Actual coordinate clicks New Game then Junior Detective advanced through S5900/S5901; log records mapped logical 461,269 and candidate 34 consumed. Command-Option-1/2 switched modes and preferences 0/1.
- Quit/relaunch same private bundle WITHOUT mode override: log reports native_display_preference=stretch logical_surface=640x480 and native_audio_output_muted=1. Captured persisted stretched layout, returned test preference to fit, quit only this temporary instance. Main app mute preference remained 1; no system audio setting changed.
- Captures remain local (game resource imagery is not committed): work/playability-20261024/display-fit.png, display-stretch.png, display-fit-opening.png, display-relaunch-stretch.png. Runtime logs display-gui.log and display-relaunch.log.
- No broad discovery, sanitizer/mutation, original-x86/Unicorn or intentional fault tests run for this slice, per owner's explicit crash-popup restriction. Earlier full-suite failures remain unresolved; this is bounded display validation.

SHA-256 pins:

| Artifact | SHA-256 |
|---|---|
| Original GAME.EXE (unchanged) | afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45 |
| native_display_geometry.c | 09e67a37f976d8c436e3598051dd2aec5062178b39a164446f7df6b41fadc28d |
| native_display_geometry.h | 73fe4b7ca5effd11ea37620de1758aa9e263e8ef5bc88d7115275b66d1c9d4a3 |
| macos_platform.mm | 6fb0bfbaa5c66225e76f1922320ecdc18fbf920b2179dbf69494285bc1d06fa2 |
| blackmoor_app.mm | 5a0c80a00b77fffee31254f7d10e81856f621f5c38d52c05a3fb2bc0741be4ab |
| Normal ARM64 executable before private-bundle resign | bd051b6ed28365063d1c08507cc357aff89296ed9cab0b3c2c3fcd88afb064d9 |

Unverified: manual drag-resizing through every aspect ratio, external displays/Retina scale changes, actual puzzle clicks in both modes, fullscreen switching under every macOS Space arrangement, malformed AppKit geometry, multi-window concurrent platforms. Portable tests cover wide/ultrawide/tall/fractional/tiny/invalid/overflow layouts and points outside bars. No added scene imagery, controls cropping or whole-game playability claim. Initial frozen independent Sonnet review of bb416c6f found no P1 or hard blocker. Root accepted and fixed both P2 findings before collection: outside-surface taskbar presses could reuse stale hover, and unchanged input-limit statuses could flood logs. P3 extreme-aspect overflow/16-bit cursor conversion, stale external test objects, and concurrent platforms remain explicitly unverified; no general extreme-coordinate app-safety claim is made.

## Review corrections

Outside taskbar DOWN/double-click now refuses coordinates outside 640x480 before using retained hover, including the inventory right-click fallback. UP still clears a release owned by the bar. Added actual-app receiver fixture with six outside coordinates including signed 32 extremes and six owned releases. It builds fresh production objects, links the real app source, creates no window/audio device and uses normal CHECK failures. Regression failed before the fix (exit 1, six stale-hover failures; 21.447s) and passed after (1 test in 21.731s). Logs: display-app-red.log / display-app-green.log. Input-consume logging now reports status transitions and every edge rather than repeating unchanged limits every tick.

Final code pins supersede the initial GUI-build pins for changed files: blackmoor_app.mm: 03a3988457879cbf002035e5305d19389fc4fb3eba040a2af79d980af785f33d; normal ARM64 executable: 8c9fc9fb98ab24a789ed3a1a242268ecae092f7aaebf1be524ed2f0682ef8d3c. Geometry/platform sources are unchanged from initial pins. The final small input guard/log correction does not change the GUI mode code previously captured.

An additional rerun of the two existing NATIVE04 checks initially failed the route before gameplay because sandbox AVFAudio refused offline manual rendering (caught error, normal exit 1); ownership check passed. Same narrow offline checks rerun on host: 2 passed in 39.168s, real cradle flag and dependent S2188 transition confirmed; final scene 2186 after animation returns, status 0. Host log display-iv-regression-host.log. Final independent Sonnet review of frozen 7926946d accepted for collection: no P1 or blocking P2. Root accepts both reviews. Only documentation changed after this freeze. Private reports: independent-display-review.txt and independent-display-final-review.txt. P3 coverage limits: fixture labels use a fixed six-case count; double-click, button-1 fallback and a positive in-surface taskbar press are correct by static review but were not exercised by this fixture. Extreme app coordinate/16-bit conversion safety remains unverified; supported real window geometry was checked.
