# Blackmoor Recompiled for Mac

You need an Apple Silicon Mac and your own installed GOG copy of **Nancy Drew:
Curse of Blackmoor Manor**. The app does not include the original game files.
Intel Macs, Windows and the App Store are outside this package's scope.

## Install and first launch

Open the DMG, drag **Blackmoor Recompiled.app** to Applications, and open the app.
It first checks your remembered game folder, then the usual GOG Mac and copied
Windows installation locations under Applications, GOG Games and Games. If it
cannot find a supported copy, a folder chooser opens. Select your installed GOG
Mac app, or the copied Windows folder containing GAME.EXE, Game.ini, Ciftree,
CDSound and CDVideo. An installer download alone is not an installed game.

The app checks the game version before using it. If a folder is empty, belongs
to another game, is incomplete or has an unsupported GAME.EXE, the message tells
you what is wrong and lets you try again. Cancel exits without starting the game.

Your original folder stays unchanged. The app makes its own working copy in:

`~/Library/Application Support/Blackmoor Recompiled Data/DataClone-v1/game`

After setup, the completed working copy also works while the original installation
is unavailable. It does not import old saves. New saves live in:

`~/Library/Application Support/Blackmoor Recompiled`

In Finder, choose **Go > Go to Folder**, then paste either path to find it.
Keep the complete data folder; the app checks its completion receipt at startup.

## Choose another game folder

Use **Blackmoor Recompiled > Choose Game Folder...**, select a supported installed
copy. It will be checked on the next launch. Your saves stay where they are. A completed
working copy of the same supported version is reused; choosing a folder does not
replace your saved games or import files from an older save folder.
The chooser refuses the app's own working-data and save folders.

## If macOS warns

A Developer ID signed and notarized package should pass Gatekeeper. If macOS
still refuses it, check that Glib supplied that exact package and ask him for the
current notarized build. Do not disable Gatekeeper for the whole Mac.

A package labeled **AD-HOC** is a local development build: Apple has not accepted
it for distribution and a warning is expected on another Mac. Glib must finish
the signing setup in [SIGNING-SETUP.md](SIGNING-SETUP.md) to produce the trusted
package. A signature verification alone does not mean notarization succeeded.

## Build from your own GAME.EXE

Install Xcode (including its command-line tools), Python 3, and the pinned build
Python with `script/setup_recomp_python.sh` once. From the repository root:

```sh
export GAME_EXE="/absolute/path/to/your/GAME.EXE"
script/package_macos.sh
```

The script refuses an unsupported executable. It downloads and builds a pinned
LGPL-only FFmpeg, generates the game code locally, bundles all required libraries,
signs, optionally notarizes, and creates a local DMG. Homebrew is not needed on
the player's Mac. Signing credentials are selected by the two environment
variables documented in SIGNING-SETUP.md. Nothing is uploaded publicly by the
script; when configured, notarization sends the private package to Apple.

The bundle contains FFmpeg's version, configure command, source details and LGPL
license in `Contents/Resources/licenses`. The game folder and GAME.EXE remain on
your own disk, outside the app. Generated C, app bundles and DMGs must never be
committed or attached to public releases. Glib must decide any public-distribution
question separately; this build path supplies no distribution permission.

The build targets macOS 11.0 or later on ARM64. Compiler availability checks and
every bundled binary's deployment target are checked. Actual launch testing here
uses macOS 27.2; running on macOS 11 and on another Mac remains unverified.

For automated local checks, the existing `--game-dir` and `BLACKMOOR_GAME_DIR`
overrides still mean an independent writable scratch copy. They take priority
over the chooser. `--save-dir` chooses a separate save root. Quiet checks use
`--background --mute --log /absolute/path/to/log`; `--capture-audio` records PCM
without playing it when muted. The normal game view keeps 640×480 logical input
coordinates and proportional widescreen fit.
