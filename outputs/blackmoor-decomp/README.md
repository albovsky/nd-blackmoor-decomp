# Blackmoor Manor: matching-decompilation investigation

**Status: incomplete. This is not a playable game or a full matching rebuild.**

The current collected integration rebuilt successfully and passed 330 of 332 tests, with two filesystem skips. It adds bounded world/clock/timed-background integration and reviewed A-28/A-51/A-62/A-64 kernels. See [COORDINATION-STATUS.md](COORDINATION-STATUS.md) for current owners and limits. The detailed diagnostic descriptions below retain the earlier baseline scope; they are not claims of current full-game playback.

The target is the original Windows `GAME.EXE` from the supplied GOG Mac bundle.
The ScummVM approach was abandoned at the owner's request. No ScummVM code or
runtime is used in this reconstruction project.

The offline [progress map](progress-map/index.html) provides filtering and an evidence inspector for all indexed starts. Tile sizes are estimated address spans; exact byte ranges and bounded oracle evidence have separate colours. Its selected report coverage and unknown extents are visible in the page.

## What has been done

- Inspected the original bundle and PE resources with REA 6.4.0.
- Built the Ghidra 12.1.4 decompiler for Apple Silicon and connected it to REA.
- Inventoried 4,534 procedures, including imports and thunks.
- Exported pseudocode for 4,188 non-external, non-thunk functions. All requested
  exports succeeded. This is coverage of the analyzer's function inventory,
  not proof that every executable instruction or runtime path was recovered.
- Reconstructed two small field-access functions as C and independently compiled
  them into an x86 Windows COFF object using Apple's Clang.
- Compared the two selected seven-byte ranges with the original: 14 unique bytes
  match exactly. Their semantic roles and owning classes remain unknown.
- Recovered the CIF archive lookup and decompression subsystem from the original
  executable and built it as native ARM64 C. The utility reads all 2,904 tree
  records, decodes all 2,886 non-marker payloads and all 63 standalone CIF files
  to their declared lengths. All 2,949 payload outputs and dictionary states
  matched the original x86 decoder, covering 149,360,874 decoded bytes.
  This is subsystem validation, not gameplay or a matching x86 compiler result.
- Recovered CHiff DATA/chunk parsing, BOOT records, actual CIF image metadata,
  external patch precedence, pixel conversion and dependency branch reduction.
  Compared all 2,267 data resources with the original parser and 720,896 pixel
  word cases with the original conversion. A native macOS framebuffer/input
  smoke test displayed the patched company logo and verified real input events.
- Compiled a native startup app that connects recovered logo/menu states to
  original asset loading. Its headless integration selects New Game, parses S0
  and decodes its first Bink background into the BOOT viewport. The app is a
  development preview: scene actions, audio and gameplay are not implemented.
- Compared 94 menu selector steps against the original x86 `0x4da430` routine,
  including button boundaries, shared arming, pressed-button locking and click
  feedback gates. All matched. The isolated oracle hooks platform/audio/draw
  calls and excludes menu initialization and downstream command execution.
- Recovered nested dependency construction and selected state-editing action
  handlers. Their original x86 comparisons cover 786 leaf evaluations and 145
  controlled action cases. The generic scheduler evaluates each row before its
  effect; missing handlers stop explicitly. These are bounded engine components.
- Recovered another 6,662 action body boundaries: 9,111 of 19,612 ACT records now
  expose typed bodies and dependency tails. The other 10,501 remain opaque.
- Built HIS audio decoding and a native AVAudioEngine adapter. The original S0
  music file decodes and renders through the app's offline diagnostic graph.
  Gameplay sound controls and original codec/volume equivalence remain incomplete.
- Compared original nested dependency loading, reduction and reset behavior:
  91 real action trees matched in construction; 315 supported evaluations and
  80 synthetic truth-table assignments matched. Corrected marker normalization
  and the original minimum group size. Unsupported leaf families remain explicit.
- Recovered phone/contact and generic control-range handlers. Thirteen isolated
  original-code cases matched. The 12 initial BOOT phone rows also match all
  492 bytes copied and sorted by the original initializer.
- Recovered the original float-to-8/16-bit PCM conversion. Eight original-code
  cases matched under the tested x87 rounding mode. This proves conversion of
  supplied floats, not equivalence of the original Vorbis decoder.

See `boot-scene-recovery.md` and `status.json` for exact coverage and remaining
engine work. These components are compiled; the complete game is not yet built.

`unverified-pseudocode/` contains analysis output, not original source, compilable
C, or verified behavior. `src/initial_functions.c` contains the two actual C
reconstructions. `matching-report.json` reports only the selected byte ranges.
`src/cif_archive.c` and `src/ciftool.c` are buildable native reconstructions of
the archive subsystem. `src/startup_menu.c`, `src/scene_resource.c` and
`src/blackmoor_app.mm` provide the current startup integration. No complete
game-engine build or playable native ARM64 game has been produced.

## Build the native startup preview

The current Bink port adapter uses the installed ARM64 FFmpeg development
libraries under `/opt/homebrew`; this dependency set requires macOS 27.0.
`FFMPEG_PREFIX` may select a different compatible installation. The app does not
bundle these libraries or original game assets. It reads the supplied GOG bundle
at runtime and honors its `ExternalCifFileChecking` setting.

```sh
./scripts/build_native_app.sh
preview_dir="$(mktemp -d /private/tmp/blackmoor-preview.XXXXXX)"
unzip "./Blackmoor Reconstruction.app.zip" -d "$preview_dir"
open -n "$preview_dir/Blackmoor Reconstruction.app"
```

In the original Codex workspace, `./script/build_and_run.sh` is the single
build/run entrypoint and the Codex Run action uses it. It launches a clean local
copy because the workspace's File Provider attaches Finder metadata to app
packages after signing. The build also emits a signed app archive without that
metadata. Escape exits the preview.
New Game is wired to a static scene preview; scene interactions and audio are
still absent. Other menu commands expose an unimplemented-screen status.

For an automated integration check without creating a window:

```sh
"./Blackmoor Reconstruction.app/Contents/MacOS/BlackmoorNative" \
  --inspect-startup --log "/new/path/to/startup.log"
```

Optional arguments are `--game-dir "/original/game/directory"` and
`--stop-after-ms 20000` for a bounded window run. Log files must not already
exist. Current graphical startup reached the menu and exited through its timer;
the latest window and scene preview have not been visually inspected because
the Mac was locked. Prior framebuffer/input smoke validation remains separate.

Three additional headless diagnostics are available. `--inspect-actions` runs the actual
S0 ACT table through the compiled scheduler, applies 31 initial actions and
returns a failure at its deliberately unregistered `0x9f` callback. The sound
handler is now implemented and used by the newer scene diagnostic. Value/control resets are
recovered; the remaining world state is explicitly analysis-only. The original
empty-phone-table path, complete New Game reset and UI behavior remain unverified.
`--inspect-audio` decodes S0's `ndsig.his` and renders 4,096 frames through the
native offline audio graph, without speaker output. Its unity gain is diagnostic.
`--inspect-scene-runtime` uses the recovered BOOT clock and 12 phone rows,
looks up the actual S0 caption, renders the real `NSHT01.his` to completion
through the silent offline graph, then selects the first active challenge
hotspot in resource order. It verifies the transition to S5900 and decodes its
first background frame. Captions go to a diagnostic recorder; the caption
renderer, complete world initializer, live scene loop and timed media remain
unimplemented. The selected one-shot sound path is supported; other control
modes fail explicitly.

AVFAudio's component registrar is unavailable in the restricted agent sandbox;
the scoped local check outside that sandbox passed. These modes are integration diagnostics; the GUI remains a static preview.

The Bink adapter uses FFmpeg as a native codec boundary for the original
external Bink DLL calls. Three first frames match the installed FFmpeg CLI;
equivalence with the original DLL is unverified. It supports no cinematic or
audio playback yet. See `media-recovery.md`, `scene-resource-recovery.md` and
`native-startup-validation.json` for coverage.
`action-recovery-priority.md` ranks the remaining action families and identifies
the next fixed-layout batch. Those boundaries are candidates supported by
original loader analysis and corpus alignment; their runtime semantics still
need recovery and verification.
See `scene-conditions-recovery.md`, `action-core-validation.json`,
`scene-executor-validation.json`, `his-audio-recovery.md` and
`macos-audio-validation.md` for the engine and audio evidence. Additional proof
is in `conditions-nested-validation.md`, `action-ui-validation.md`,
`action-values-init-validation.md` and `his-pcm-quantization-validation.md`.
The new slice evidence is in `hotspot-runtime-validation.md`,
`action-sound-recovery.md`, `autotext-recovery.md`,
`boot-world-inputs-recovery.md` and `phone-init-validation.json`.
The latest full suite ran 216 tests: 214 passed and two filesystem fixtures
were skipped. See `WORK-SLICES.md` and `tasks/` for the parallel handoff.
The quantizer is recovered for the tested rounding mode; original Vorbis decode,
panning, fade, loop and volume behavior still require reconstruction and
verification before faithful gameplay playback.

## Build and use the native archive utility

```sh
./scripts/build_ciftool.sh
./build/ciftool list "/absolute/path/to/CIFTREE.DAT"
./build/ciftool extract "/absolute/path/to/CIFTREE.DAT" AUTOTEXT "/new/output/file.bin"
./build/ciftool decode-cif "/absolute/path/to/boot.CIF" "/new/output/boot.bin"
```

The build produces an ARM64 executable and a shared library without a VM or
runtime dependency. Output paths must be explicit and must not already exist.
The utility returns decoded bytes before renderer-dependent image conversion.
See `archive-recovery.md` for original-code addresses, format details and
deliberate bounds checks that differ from the original's unchecked behavior.

After building, run the native regression tests and byte-range verifier tests:

```sh
python3 -m unittest discover -s tests -p 'test_*.py'
```

The original-decoder oracle requires Python with Unicorn 2.1.4. It executes
only the original decoder for testing; the native archive utility does not use
Unicorn. To reproduce the full resource comparison with your original files:

```sh
python3 tests/cif_original_oracle.py \
  --exe "/absolute/path/to/GAME.EXE" \
  --game-dir "/absolute/path/to/Nancy Drew - Curse of Blackmoor Manor" \
  --report "/new/path/to/oracle-report.json" \
  full-compare --native-library ./build/libcifarchive.dylib
```

## Original identity

- File size: 1,511,424 bytes.
- SHA-256: `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.
- Format: Windows PE32, Intel x86; image base `0x400000`.
- Entrypoint RVA: `0x10e7e5`.
- Linker version fields: 6.0.
- `.text`: RVA `0x1000`; 1,213,018 virtual bytes, 1,216,512 file-backed bytes.
- No COFF symbol table is present.

Rich-header C and C++ records with build 8168 suggest the Visual C++ 6 RTM-era
toolchain. This is a community-mapping inference, not a recovered build manifest.
Other records show mixed object/library provenance. Exact compiler flags,
library versions, link ordering and post-link changes remain unknown.

## Reproduce the initial comparison

An Apple Silicon Mac with Xcode command-line tools and Python 3 is sufficient for
this limited check:

```sh
./scripts/build_matches.sh "/absolute/path/to/the/original/GAME.EXE"
```

The script compiles the recovered C for Windows x86 and compares its bytes with
the original. It does not run or modify the original executable. A passing
report proves equality only for the selected ranges, not for the entire game.
The verifier rejects relocated candidates, malformed inputs, wrong architecture,
wrong original hash and overlapping range claims.

## Remaining work

1. Establish the original or an equivalent compiler/linker/library toolchain and
   reconstruct build settings. The owner currently has only the GOG game.
2. Recover C++ class layouts, types, globals, virtual tables, calling conventions
   and exception behavior; turn the pseudocode into buildable source.
   The immediate runtime path is S0 scene/action construction, full dependency
   evaluation, action execution, remaining media paths and original startup
   initialization beyond the current menu/scene preview.
3. Recompile and verify every required code range, then reconstruct the PE layout,
   resources, imports and other metadata for whole-file comparison.
4. Port the recovered engine's Windows graphics, audio, input and file APIs to
   macOS, then compile and test an ARM64 game.

The x86 matching build and ARM64 port are separate milestones. An ARM64 executable
cannot have the same machine-code bytes as the original x86 executable.

## Evidence

`function-index.json` links each pseudocode export to a REA evidence ID. The
full REA evidence bundle and immutable snapshot are retained under the workspace's
`work/analysis/` directory. The GOG application was not modified.

Native overview: `ev_76954871084a91107058458d42c7020613a767aea99a803754e8ff20ae2f4bc9`.

Tools: [REA](https://github.com/morluto/rea),
[Ghidra](https://github.com/NationalSecurityAgency/ghidra).
Compiler provenance mapping: [RichPE](https://github.com/RichHeaderResearch/RichPE/blob/master/rich.py).
