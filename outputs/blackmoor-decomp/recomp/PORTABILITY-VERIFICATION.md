# Private macOS package verification — 2026-11-03

The local portable package is built and its quiet runtime proof passes. This
artifact is **ad hoc and not notarized**. The full regression suite is running
on frozen source `d2e37b22`; no passing-suite or merged-PR claim is made yet.

## Pinned local artifact

| Item | Value |
| --- | --- |
| App source commit | `8a4c38b4ef7f9b4e0dfbddc87f80995ba5ddd7ce` |
| Native executable SHA-256 | `dbfe26db6cc771009a66a039d5fbb7660e09cd1608173662c368a462a34eb65c` |
| Original GAME.EXE SHA-256 | `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` |
| DMG SHA-256 | `472c08b388e23674fdc79b8e5a885c1b375156a678da4f56dceaa24c55b9400f` |
| DMG bytes | `6246206` |
| Local folder | `outputs/blackmoor-decomp/build/private-release-8a4c38b4-final/` in the main checkout |
| DMG filename | `Blackmoor-Recompiled-0.1-arm64-ADHOC-UNNOTARIZED.dmg` |

The app and manifest both record the source commit. The runtime proof refuses a
DMG unless its hash, manifest, copied executable hash and source stamp agree.
Generated C, original files, saves and built artifacts remain outside git.

## Bundle and system floor

`script/package_macos.sh` ran end to end with the verified LGPL prefix. Its output:

```text
package: AD-HOC SIGNED, NOT NOTARIZED (Gatekeeper will warn; this is not a trust success)
SHA256: 472c08b388e23674fdc79b8e5a885c1b375156a678da4f56dceaa24c55b9400f
bytes: 6246206
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

An additional offline check compiled the existing Bink adapter against this LGPL
prefix. The first decoded frames of `diff`, `OPEN_A` and `toast` were byte-identical
to the existing FFmpeg 9.0.1 CLI reference (all 620×375 RGBA). No window or audio
output was used; this is three first-frame comparisons, not full-movie parity.

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
FILE open C:\GAME\Ciftree\MAIN.CIF  [virtual 9373 ms]
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
QUIET_RUNTIME_PROOF_PASS /private/tmp/blackmoor-fresh-proof-20261103-e
```

That inventory covers names, types, permissions, sizes, modification times and
file-content hashes. The remembered/known precedence, unsafe aliases, competing
clone publication, missing-source reuse and working-copy rejection also pass the
seven Foundation fixture groups. Interactive panel/menu clicking was not run.

## Checks and review

The 36 package checks, seven data-selection groups and six credentialed-workflow
checks also pass together: `Ran 49 tests in 23.162s / OK`. Signing-workflow tests use fake external services and never count as
real signing/notarization evidence. Independent review found no P1; its release
code P2 findings were fixed. The final runtime proof pins the rebuilt artifact,
superseding earlier failed/stale proofs A–C, which are retained privately. Proof
D also passed on the same native executable. Final proof E repeats it after the
DMG README was clarified to state the derived-code/private-distribution limit.

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

The owner explicitly authorized bounded, independently reviewed fixes for
confirmed baseline suite blockers. These cover two overflowing E0 height-zero
predicates, the FL19 name-buffer frame size (72 to the original 76 bytes), and
the original x87 invalid-operation NaN sign in FL30a. New regression cases fail
before the fixes and pass afterward. E0 also passes 40 original-executable
scenarios and 6,505 state comparisons with zero failures. Independent Sonnet
reviews accepted the bounded production changes. These legacy modules are not
linked into the Recompiled app; its executable and DMG above are unchanged.

Test-only repairs retain the existing mutants and assertions, correct an
undersized FL28a fixture, model the exact generated whole-file build outputs,
restore missing oracle dependencies, and replace unsupported macOS LeakSanitizer
execution with checked `leaks --atExit` controls. ASan and UBSan remain enabled.
Unexpected checker failures fail the tests. E4's inherited generic mutation
generator has no explicit free-removal mutant; no broader leak-coverage claim is
made. The NaN fix does not establish both-NaN payload priority or repair the
separate legacy `action_family_4e_runtime.c` arithmetic path.

The owner also explicitly approved the generated evidence/ledger refresh.
An independent comparison finds every one of the 4,188 `(status, class)` pairs
and every count unchanged: 2,210 ported, 128 not needed, 1,850 pending. No
acceptance override, story content or coverage grant is changed. The ten
unfinished functions remain unfinished.

The final canonical command is `script/run_test_suite.sh -v`, including its
normal rebuild. Discovery selects 7,899 tests: 7,027 native checks and 872
original-x86 reference checks. Final results are pending. Failed and interrupted
diagnostic runs remain private and are not counted as passes.

### Original-x86 reference test host

The existing FL40-and-later reference model explicitly needs Intel 80-bit
`long double` and x87 instructions. Its ARM fallback is not bit-exact. The
canonical runner executes those unchanged reference tests under existing
Rosetta support, with a private x86 Python, an explicit x86 compiler and an
isolated cache; native port and gameplay tests remain ARM64. Every discovered
test ID and duplicate is preserved. A child must report the exact completed
count and success, in addition to exiting zero. A real mixed native/reference
run passes, and a zero-exit child that executes no tests is rejected.

For a developer running the entire suite on Apple Silicon, the private test
environment used here is CPython 3.13.14 x86_64 with Unicorn 2.1.4, Capstone
5.0.7, pefile 2024.8.26 and z3-solver 4.15.4.0. The runner defaults to
`work/tools/oracle-x87-python313/bin/python3`; `BLACKMOOR_X87_PYTHON` may select
another x86 Python 3.10+ with those dependencies. Missing or unusable reference
support fails visibly. This is isolated original-x86 oracle testing, not an
Intel player build. Players and the package build do not need this environment.

## Remaining limits

A Developer ID Application certificate is installed, but no notary profile has
been selected. A names-only, noninteractive query found no matching profile in
the file-based or data-protection keychain; no password data was requested. No real Developer ID/notary/staple/accepted Gatekeeper result is
claimed. [SIGNING-SETUP.md](SIGNING-SETUP.md) gives Glib the keychain setup and two
environment variables. No credentials or profile contents were saved here.

Actual macOS 11 execution, trusted quarantined launch, second-Mac testing, manual
picker/menu interaction and hardware audio remain unverified. The top-level
missing-seed and invalid-preference cases have library fixture coverage, not a
separate end-to-end run. No all-random-branch gameplay or original C++ provenance
claim is added. Public distribution remains a question for Glib; this workflow
publishes source changes only and keeps all derived artifacts on his disk.
