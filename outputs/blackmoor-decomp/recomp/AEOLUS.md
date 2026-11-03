# Aeolus through ordinary captured-pixel input

`route_tools/aeolus_live.py` runs one bounded Junior Aeolus continuation from an earned cold-lab/mould save. It creates fresh APFS game-data clones, moves through the original UI, saves as `m61.SAV`, then independently reloads only that output. The original game owns wind, setup, collection, retries, timers and rewards. Movement choices use closed640×480 P6 captures and a caller-owned local atlas; no live board, score, RNG or handler state is read or written.

Supply local original data, native host, genuine source save, atlas and profile manifest with their explicit SHA256 pins. Nothing runs in the supplied data directory or edits the supplied save. The original GAME.EXE is data for recompilation/loading; the pinned host is a separate executable. Saves, atlas, resources and captured images are not distributed.

```sh
python3 outputs/blackmoor-decomp/recomp/route_tools/aeolus_live.py \
  --native "$NATIVE" --native-sha256 "$NATIVE_SHA256" \
  --game-exe "$GAME_EXE" --game-exe-sha256 "$GAME_EXE_SHA256" \
  --game-data "$GAME_DATA" \
  --source-save "$SOURCE_SAVE" --source-sha256 "$SOURCE_SHA256" \
  --profile-manifest "$PROFILE" --profile-manifest-sha256 "$PROFILE_SHA256" \
  --atlas "$ATLAS" --atlas-sha256 "$ATLAS_SHA256" \
  --output "$NEW_OUTPUT"
```

`NEW_OUTPUT` must not exist and must be outside the supplied original/data/source directories. The data seed must have no saves or symlinks. The caller's local profile uses `version: aeolus-profile-v1`, native/original/source/atlas hash fields, a nested `profile`, and relative `seed_pins` for GAME.EXE, Game.ini, Ciftree/CIFTREE.DAT and effective loose Ciftree/s3876.CIF. The tool checks the complete profile shape against the alchemy/mould contract; omitting fields is refused. The original hash is fixed at `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.

The exercised source is Junior m60, hash `f8aa72d41922ce213e4a5a49e4b97b0912422f09c6d5e7404cdd6039169808ae`:3803/view0/held13, day3 16:47, physical mould10 owned, no forged15, unfinished Aeolus, corrected24-positive/12-zero mould with2163=1. Its local profile pins236 saved predicates, all40 inventory cells, source clock and100 logged event predicates. Clock338–341 is diagnostic metadata. Other saves/boards/profiles and Senior have no runtime acceptance from this source-specific result.

The retained19-token navigation and nine-token start, arrow holds, settles and UI save/reload match the exercised client. Limits remain200 outer iterations,20 ordinary original retries, eight consecutive unready waits,256 FIFO requests,300 seconds per native session,90M imports and3.6M idle polls. Original3848 permits an ordinary lever retry; the controller cannot force a win. Unknown, incomplete, loss/budget or protocol errors refuse. Process0 or entry2052 alone is insufficient.

Success requires all four original prize flags1098–1101 and new1959, an authored win scene, safe3813/view0/held13 and original UI Save. Every contracted field except the six expected entry/win changes must remain fixed, including2163. All40 inventory cells must remain unchanged. A clean independent output-save-only reload and protected-file checks must pass before the accepted save is copied to the output root. There is no PUT/header normalization or later2163 correction.

The new public invocation on native `fc2575b1939e53ce9900a7bd7fb6a49b799e88727585358ae37c47af5a26f0dd` passes156/156 producer events,47 captures,36ACK/finish37 and31 pixel moves with one original retry. Fresh reload passes8/8 events and two captures; both sessions stop normally with native0. Output `206aba189238f7d7248d430003229a0b62305f59283eceb2869c38f2e08670ed` is safe3813/view0/held13, day3 17:23. All236 saved fields and40 inventory cells match the contract. See [the public evidence projection](campaigns/aeolus-earned.json).

The earlier private b49 result `a43e1e35…` is a distinct run. Twenty-six retained-core AST mappings, exact input-fragment equality and six CLI-guard checks are separate source/finite evidence. A separate9ae→1cf static report finds27 generated files,4606 bodies,40 host source files and compile tails equal; it grants no new binary or runtime identity. The accepted native remains its actual9ae/fc build. This continuation does not prove a whole fresh campaign, every random deal or final Mac acceptance.

After that run, a focused preflight fix rejects filesystem aliases of protected directories, including different capitalization on APFS. The regression fails before the fix and all seven CLI checks pass afterward; independent frozen review accepts the delta. Gameplay, input and completion checks are unchanged. The evidence projection preserves the executed controller hash. Error cleanup, inherited environment and optimized Python remain outside the runtime acceptance.
