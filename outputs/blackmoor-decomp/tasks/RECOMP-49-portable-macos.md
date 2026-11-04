# RECOMP-49: portable private ARM64 macOS package

Authorization: the owner's 2026-11-03 Codex chat requests a local self-contained
package, game-folder chooser, signing/notarization when credentials exist,
independent Sonnet review, and a source-only PR squash-merged by this chat.
Only this authorizing chat publishes repository changes. No game bytes, lifted C,
apps, DMGs, saves or resource dumps may be committed or uploaded publicly.
Apple notarization is authorized when credentials exist. No credentials in logs.

Root owns shared `recomp/build_macos.sh`, `macos_recomp.mm`, game-data modules,
tests, INSTALL/HANDOFF and final integration. Story, engine, ledger and original
files are out of scope. Preserve explicit scratch overrides and background quiet
behavior; no foreground launches or audible playback. No deletion command, shell
command chains or pipelines. Every variable assignment occupies its own line.

Packaging worker owns only new `script/package_macos.sh`,
`script/build_ffmpeg_macos.sh`, `script/macos_bundle.py` and focused packaging
tests. Use its own worktree. Build pinned official FFmpeg with LGPL-only minimal
Bink decoding, shared ARM64 libraries and macOS 11.0 deployment floor. Record
download SHA256, version, configure command, LGPL text and source availability
inside bundle licenses. Recursively copy non-system dependencies, rewrite load
commands/rpaths and reject unbundled dependencies. Root makes build_macos honor
FFMPEG_PREFIX, MIN_MACOS=11.0, and BLACKMOOR_BUNDLE_PATH. Packaging should use
project pinned Python, choose working Xcode via DEVELOPER_DIR if needed, validate
GAME_EXE hash before any build, create a fresh local output directory, sign nested
binaries inside-out with hardened runtime and no added entitlements. Environment
BLACKMOOR_SIGN_IDENTITY and BLACKMOOR_NOTARY_PROFILE select credentials; absent
credentials produce a clearly labeled ad-hoc DMG, never a trust success. Submit
with notarytool --wait, require Accepted, staple app before DMG and then notarize
and staple DMG, verify codesign/stapler/spctl. No public upload of any artifact.
Print local DMG path, SHA256 and bytes. Include app, Applications link and short
README. Reject bundle contents that include game resources/executable/lifted C.

Acceptance: every bundled Mach-O has only system or bundled load paths and no
Homebrew rpaths; actual quarantined copied app reaches main menu background/mute
with empty Homebrew fallback directory; seed validation covers valid, empty,
missing-file/wrong-game and wrong-version folders; original listing hashes equal
before/after; default saves remain in Application Support. Run full existing suite
and earned-ending headless run. Independent reviewer examines frozen commit,
root resolves findings, merges current main before PR, squash-merges clean PR.

Unverified branches must be recorded, particularly real Developer ID/notary
path when identities are absent, actual macOS 11 execution, interactive picker
UI, second Mac and hardware audio. No new complete-game/ledger claim.
