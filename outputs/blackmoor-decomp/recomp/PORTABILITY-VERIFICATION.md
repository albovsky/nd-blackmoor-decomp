# Private macOS package verification — 2026-11-03

The local portable package is built and its quiet runtime proof passes. Signing
trust and the repository-wide suite are separate: this artifact is **ad hoc and
not notarized**, and a baseline legacy-engine overflow currently prevents a
green full-suite result. No complete-release or merged-PR claim is made here.

## Pinned local artifact

| Item | Value |
| --- | --- |
| App source commit | `8a4c38b4ef7f9b4e0dfbddc87f80995ba5ddd7ce` |
| Native executable SHA-256 | `dbfe26db6cc771009a66a039d5fbb7660e09cd1608173662c368a462a34eb65c` |
| Original GAME.EXE SHA-256 | `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` |
| DMG SHA-256 | `3e4f3de71a719281c7b68f590025b80b680d27de8d2e9f1ec22d38d014376783` |
| DMG bytes | `6246119` |
| Local folder | `outputs/blackmoor-decomp/build/private-release-8a4c38b4/` in the main checkout |
| DMG filename | `Blackmoor-Recompiled-0.1-arm64-ADHOC-UNNOTARIZED.dmg` |

The app and manifest both record the source commit. The runtime proof refuses a
DMG unless its hash, manifest, copied executable hash and source stamp agree.
Generated C, original files, saves and built artifacts remain outside git.

## Bundle and system floor

`script/package_macos.sh` ran end to end with the verified LGPL prefix. Its output:

```text
package: AD-HOC SIGNED, NOT NOTARIZED (Gatekeeper will warn; this is not a trust success)
SHA256: 3e4f3de71a719281c7b68f590025b80b680d27de8d2e9f1ec22d38d014376783
bytes: 6246119
```

`otool -L` was run on the executable and every bundled dylib. Every external load
is under `/System/Library` or `/usr/lib`; other loads are these bundled names:

```text
@rpath/libavformat.63.dylib
@rpath/libavcodec.63.dylib
@rpath/libavutil.61.dylib
@rpath/libswscale.10.dylib
@rpath/libswresample.7.dylib
```

The complete per-file output is retained privately as `otool-final.txt` in
`work/recomp-portable-20261103/`. No Homebrew or `/usr/local` load or rpath remains.
The parsed Mach-O output is:

```text
DEPLOYMENT BlackmoorRecompiled arch ['arm64'] minos (11, 0, 0) rpaths ['@executable_path/../Frameworks']
DEPLOYMENT libavcodec.63.dylib arch ['arm64'] minos (11, 0, 0) rpaths ['@loader_path']
DEPLOYMENT libavformat.63.dylib arch ['arm64'] minos (11, 0, 0) rpaths ['@loader_path']
DEPLOYMENT libavutil.61.dylib arch ['arm64'] minos (11, 0, 0) rpaths ['@loader_path']
DEPLOYMENT libswresample.7.dylib arch ['arm64'] minos (11, 0, 0) rpaths ['@loader_path']
DEPLOYMENT libswscale.10.dylib arch ['arm64'] minos (11, 0, 0) rpaths ['@loader_path']
```

macOS **11.0** is the ARM64 build floor. The app's Objective-C++ sources compile
at that target with unguarded availability treated as an error. The one macOS
27-only audio connection call now has an availability guard and the older API
fallback. Info.plist and all six Mach-O deployment targets agree. Actual runtime
testing is on **macOS 27.2 with Xcode's macOS 27.0 SDK**, not on macOS 11.

FFmpeg **9.0.1** is rebuilt from the official source tarball, SHA-256
`cf38e0e28c7e5605942c4a77755349b0145804a397af37eb1fb4c77cb237f635`.
All five loaded libraries report `LGPL version 2.1 or later`. Its only decoders
are `binkvideo`, `binkaudio_dct`, `binkaudio_rdft`; its demuxer is `bink`, and its
only protocol is `file`. GPL, nonfree, version3, network and automatic external
library detection are disabled. The exact configure command, version, source URL,
hash and license texts are in `Contents/Resources/licenses/FFmpeg/`.
Compiler/SDK/configuration fingerprints select separate FFmpeg object directories.
The source tarball's GPG signature was not independently checked.

## Quiet copied-app proof

The runtime checker mounted the DMG read-only, copied the app outside the repo,
set `com.apple.quarantine`, assessed it and verified its signature. Actual results:

```text
Blackmoor Recompiled.app: valid on disk
Blackmoor Recompiled.app: satisfies its Designated Requirement
Blackmoor Recompiled.app: rejected
```

The rejection is the expected **Gatekeeper** result for this ad-hoc build; it is
not a notarization success. A quarantined attempt stalled at the loader before
main and was stopped. The successful portability runs use a separate local copy
without imported extended attributes, preserving the quarantined copy and result.

The successful launches ran directly with `--background --mute --log` and
`--capture-audio`. A sandbox denied all file reads under `/opt/homebrew` and
`/usr/local`; empty DYLD library and fallback directories were also supplied.
`vmmap` observed all five FFmpeg dylibs under the copied app's Frameworks folder,
with no Homebrew mappings. The actual main-menu log includes:

```text
FILE open C:\GAME\Ciftree\MAIN.CIF  [virtual 10277 ms]
BACKGROUND stage=opened active=0 key=0 visible=0 activations=0
```

Both native runs exited 0. The normal game UI created `pkgcheck.SAV` under the
process's isolated Foundation home:

```text
Library/Application Support/Blackmoor Recompiled/Documents5/The Curse of Blackmoor Manor/pkgcheck.SAV
```

No macOS account was created. CFFIXED_USER_HOME isolated the Application Support
directories, and existing games and saves were left alone. Audio was inspected
only as captured PCM; no output device or foreground game window was used.

The exact picker validator accepted the owned GOG folder and refused four cases:

```text
GAME_FOLDER accepted=0 This folder is empty. Choose the folder where your GOG game is installed.
GAME_FOLDER accepted=0 This is not the game folder. Choose Nancy Drew: Curse of Blackmoor Manor, containing GAME.EXE, Ciftree, CDSound and CDVideo.
GAME_FOLDER accepted=0 Some game files are missing (Game.ini). Choose the complete installed game folder, or reinstall your GOG copy and try again.
GAME_FOLDER accepted=0 This game version is not supported. Choose the GOG version of Nancy Drew: Curse of Blackmoor Manor.
SEED_LISTING_BEFORE cfe9b29709a5c0ef432da9db1cbb66da438b13697087aaea3984a1e65229088a
SEED_LISTING_AFTER  cfe9b29709a5c0ef432da9db1cbb66da438b13697087aaea3984a1e65229088a
QUIET_RUNTIME_PROOF_PASS /private/tmp/blackmoor-fresh-proof-20261103-d
```

That inventory covers names, types, permissions, sizes, modification times and
file-content hashes. The remembered/known precedence, unsafe aliases, competing
clone publication, missing-source reuse and working-copy rejection also pass the
seven Foundation fixture groups. Interactive panel/menu clicking was not run.

## Checks and review

The 36 package checks, seven data-selection groups and six credentialed-workflow
checks pass. Signing-workflow tests use fake external services and never count as
real signing/notarization evidence. Independent review found no P1; its release
code P2 findings were fixed. The final runtime proof pins the rebuilt artifact,
superseding earlier failed/stale proofs A–C, which are retained privately.

The existing earned-ending headless runner passed on its unchanged pinned native
`6041e31e9d486111f6a0b64a7ce9764d52c292f35339fa1a84f3be7c18d31de4`:

```text
accepted True
returncode 0
input_steps 45
wall_seconds 65.051
protected_inputs_unchanged True
```

The initial headless attempt used a relative executable path while its runner
changed directories and failed before game startup. The successful fresh run used
absolute paths. Neither receipt was relabeled or overwritten.

The full `script/run_test_suite.sh` run is still collecting its final results.
Baseline harness problems and absent oracle NumPy/Capstone were diagnosed
separately; no production engine changes were made. After restoring usable
ASan/UBSan execution, an unchanged legacy test exposes signed overflow at
`src/action_family_e0_runtime.c:894`. The owner was asked how to reconcile this
with the explicit prohibition on engine changes. No test was weakened to hide it.

## Remaining limits

A Developer ID Application certificate is installed, but no notary profile has
been selected. No real Developer ID/notary/staple/accepted Gatekeeper result is
claimed. [SIGNING-SETUP.md](SIGNING-SETUP.md) gives Glib the keychain setup and two
environment variables. No credentials or profile contents were saved here.

Actual macOS 11 execution, trusted quarantined launch, second-Mac testing, manual
picker/menu interaction and hardware audio remain unverified. The top-level
missing-seed and invalid-preference cases have library fixture coverage, not a
separate end-to-end run. No all-random-branch gameplay or original C++ provenance
claim is added. Public distribution remains a question for Glib; this workflow
publishes source changes only and keeps all derived artifacts on his disk.
