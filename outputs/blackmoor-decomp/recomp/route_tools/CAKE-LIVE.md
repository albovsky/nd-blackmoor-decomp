# Optional Cake Mixing verification

`cake_live.py` attempts the original CakeMixing3600 branch once, then requires baking, physical good-cake item1, an original UI save, and a fresh output-only Load that selects actual held1. It imports `bul_live.Session`, PPM validation and FIFO delivery, plus `story_route.R` and the existing Load/Save helpers. It contains no puzzle implementation, guest handler calls, hidden ingredient/board/RNG reads, clock edits, resource templates or save serialization.

This candidate's gameplay body and producer/reload checks come from frozen private v3 SHA `54a13e4102ef4ffdb371e59b39dc122472a8a5458c5202720c39ff428d52e63b`. That controller produced separate accepted Senior and Junior optional branches on b49. Two new full public-client runs also pass on reviewed b49, one Junior and one Senior: original baking, physical item1, UI Save and fresh output-only actualheld1. Public evidence and the older private boundary are separate in `../campaigns/cake-optional.json` and RECOMP-32. Sonnet accepts frozen57584cee with no blocking finding.

## Supported inputs

Without `--source-profile`, the guard accepts only these exact genuine sources, with their original filenames. They are optional branches; they do not replace or splice into either earned story campaign.

| Profile | Source | Difficulty | Source room/art/view/held | Original clock | SHA-256 |
| --- | --- | --- | --- | --- | --- |
| senior | s57.SAV | 2 | 3510/3510/4/−1 | day3 14:36, total876 | `b0b49b4ca3692367e8da83c5a5b54957fed33a56e1aaaed68e3b26c01b0f9bb6` |
| junior | m51.SAV | 0 | 3510/3510/4/−1 | day3 14:57, total897 | `ca0793b073a6358da3e3d58b3cda6ed3ce99875a50988cdeca77c6b7db6a5678` |

Both begin without cake0/1 and with 1338/1502/1503=0,1567=1. The exact save hash preserves the other authored prerequisites. No other afternoon save is implicitly supported by historical mode. The controls/rules on the exercised effective path are source-identical for these profiles; the client does not alter difficulty.

The Senior source was earned on the earlier cc7 campaign host; its b49 boundary is the separately observed ordinary Load into this optional branch. The Junior source is the retained public b49 producer. Neither branch establishes whole-campaign equivalence across native builds.

Historical mode accepts only b49 SHA `b49eaa71885a02e9e096b9766f020576ef0a0381837cd036f0875bab49351e24`. The supplied GAME.EXE and seed copy must both have SHA `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`. CIFTREE.DAT must have SHA `1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161`; Game.ini must have SHA `f8f892e828eca6086f5a25720e5e8e0c2ebbb7d81f1bb90bb8b73ea244419c79`. Case-insensitive loose overrides for the 15 scoped scenes are refused. The seed must contain no Documents5 saves or symlinks.

`bul_live.py` remains pinned as a whole to `3a52e04b8bf642d90c3f00382fdc7b00c62791ad9f5a77fdf1cf6d81f933591d`. The four original-UI definitions in `STORY_API_SHA256` must retain exact source hashes; unrelated route additions may change the full story file. Receipts record full versions of story_route/check_route as well. This repeats the v3 helper-compatibility policy without shipping private helper copies or historical source paths. New native/data/helper versions need review and explicit proof; no cross-build equivalence is implied.

### Explicit source/native profile

`--source-profile FILE.json` opts into a new caller-reviewed source/native pair. `--profile junior|senior`, `--save-sha256` and `--native-sha256` remain required; the JSON name/hash must match the CLI. Its only fields are `name`, `difficulty`, `source_sha256` and `clock`. Names/difficulties are exactly junior/0 or senior/2, and the source hash is64 lowercase hexadecimal characters. `clock` has exactly integer `total_minutes`, `minute`, `hour`, `day`: day1–65535, hour0–23, minute0–59 and total_minutes=60*hour+minute. These are expected serialized source values, never clock controls.

The JSON cannot specify scene, hand, prerequisites, inventory or outcomes. The actual pinned source must still be3510/3510/view4/held−1, have no cake0/1, and1338/1502/1503=0,1567=1. New ordinary alphanumeric SAV basenames are accepted; continue/authored-auxiliary sources and output-name reuse are refused. Existing s57/m51 output-name reservations remain. The selected native must match its explicit hash and must differ from the original GAME.EXE hash. New profiles/builds require their own ordinary execution/review; parameterization does not inherit historical acceptance. The JSON bytes/hash are recorded and protected against changes through both sessions.

For a newly earned source, supply its own verified hash and exact clock in the JSON; do not reuse the historical saves or their hashes. The unchanged default silent/virtual clock, one-attempt input/hover/drop/finish/bake/pickup policy, asset/effective-scene guards and save/reload checks apply:

```sh
python3 -B outputs/blackmoor-decomp/recomp/route_tools/cake_live.py \
  --profile junior --source-profile "$SOURCE_PROFILE_JSON" \
  --native "$RECOMP_NATIVE" --native-sha256 "$REVIEWED_NATIVE_SHA256" \
  --game-exe "$GAME_EXE" --game-data "$GAME_DATA" \
  --source-save "$FRESH_SOURCE_SAVE" --save-sha256 "$FRESH_SOURCE_SHA256" \
  --save-name cakefc --output "$NEW_CAKE_OUTPUT"
```

All40 raw saved inventory cells are now compared by the client: source cake0/1 must be0, output item1 must become1, and all other39 cells must match exactly. The receipt records this fixed delta and full source/output inventories; profiles cannot alter it. A successful original-UI save and fresh output-only actualheld1 reload remain mandatory.

## Historical invocation

Run on macOS with a fresh APFS-clone-capable output location. Set the paths to your own reviewed host, legally owned data and genuine source. No executable, resource or save bytes are distributed here. The following invocation intentionally launches a headless original-game branch; it uses the default silent/virtual clock, without an output device or OS input.

```sh
python3 -B outputs/blackmoor-decomp/recomp/route_tools/cake_live.py \
  --profile senior \
  --native "$RECOMP_NATIVE" \
  --native-sha256 b49eaa71885a02e9e096b9766f020576ef0a0381837cd036f0875bab49351e24 \
  --game-exe "$GAME_EXE" \
  --game-data "$GAME_DATA" \
  --source-save "$SENIOR_SOURCE_DIR/s57.SAV" \
  --save-sha256 b0b49b4ca3692367e8da83c5a5b54957fed33a56e1aaaed68e3b26c01b0f9bb6 \
  --save-name cakes32 \
  --output "$WORK/cake-senior-new"
```

For Junior use profile `junior`, genuine `m51.SAV` and the table's Junior hash, with a different new output directory/save name. Output must not exist or overlap supplied data/source directories. Names are 1–10 lowercase letters/digits; `s57` and `m51` are reserved. A failure retains evidence and exits1; it does not retry. Successful return requires both native sessions to finish with complete delivery, their own explicit finish, unchanged input copies and exit0.

## Preserved ordinary flow and acceptance

Each of four right turns sends `1:move:620,200;101:move:320,60;2501:shot:0,0`; actual room/art/view/held must be 3510/3510/3/−1, then 2,1,0. The earlier Senior01 left-hover refusal remains separate evidence: left moves incremented to8. No state is forced to correct that refusal.

From view0, normal nook/microwave/oven clicks reach the first-use instruction and puzzle. The client selects type0 at54,88, selects its large display at310,170, then repeats MOVE269,299 at1/1001ms before the ordinary2001ms drop click. Two moves preserve the original previous/current rectangle behavior. Eligibility flags1502/1503 must become1, but these are not completion: original checker480b34 writes them before its phase2 finish gate (480de8). The oven click512,276 must continue through3602/3604/3605; start581,277 must finish baking3606; pan485,263 must reveal3607; physical pickup334,187 must return3554. The original return resets1502/1503 to0.

The ordered original file-open subsequence, closed PPMs and stage observations are retained. Final UI save must be 3520/3520/0/−1 with unchanged difficulty, real good-cake1 owned, bad-cake0 absent and 1338=1,1502=0,1503=0,1567=1. A second fresh clone receives **only this output save**. After normal Load and bag opening, first-slot selection62,100 must produce actual held1. The original UI output, reload source/copy and accepted copy must have identical SHA-256. No checkpoint copy is accepted before that reload.

The imported Session creates fresh save directories with `exist_ok=False` and copies only the supplied input before launch. After execution, the only optional extra save allowed is the exact original-authored name `HICONTINUECHEAT.SAV`. Its hash/size are recorded even on refusal; it is never loaded, required, copied as canonical output or treated as a checkpoint. Unknown extras, missing required files or copy hash differences refuse acceptance. Neither accepted Cake profile actually produced this auxiliary.

## Retained proof and remaining limits

Private proof `work/recomp-playability-20261101/optional-cake/verified-cake-both-native.json` SHA `aebc931cee5def48d1ee304b66e22d1d506fdb7af9f1666d20adca4580cb7368` binds the original data, frozen v3, effective source, input/log/capture/save and source-only reload records. Senior02 and Junior01 each delivered92/92 producer steps/24 captures and14/14 reload steps/4 captures, all native exit0. Their accepted optional UI saves were:

| Profile | Save | SHA-256 |
| --- | --- | --- |
| senior | cakes32.SAV | `4f57e705544aa0d7ad6e1ce13ee1930f2d1d3758a904f20f4fbf465452e0dc18` |
| junior | cakej32.SAV | `8193c87dde8af6ca486c918092c5ce874808ed49bef015715d6c4dd11403513d` |

Those historical hashes are evidence, not future output expectations: original game timing remains in charge. The frozen v3 native proof covers one allowed ingredient and first-use oven flow on each profile. Forbidden ingredients/bad cake, alternate recipes, repeat-use sources, other original installs, Mac frontend input and other builds remain unverified. This client does not mark the game complete or publish protected proof/data. New public runs use six-character names pcakej/pcakes:91 producer steps rather than the private seven-character names'92, still24 captures and14-step/four-capture fresh reloads. Junior output SHA2422bc63e59d2c44d26eeddfe46316ff36bf503a895767d343d275e96183ce06; Senior e7a4d6f5729da0f6576a097d3012134450255554b0c8e569998d885fed4cb25e. These are independently earned outputs, not copies of historical saves.

Finite checks (no game/assets/process) after applying the candidate:

```sh
python3 -B outputs/blackmoor-decomp/tests/test_recomp_cake_live.py
```

The historical frozen client enforced inventory0/1 itself; its other39-cell result remains the separately pinned external root audit in cake-optional.json. The parameterized client additionally enforces the fixed full40 raw-cell contract described above. New source/native results remain pending their own actual runs and review. Only an error-free receipt with accepted:true grants checkpoint acceptance. A copied file beside a failed/partial receipt is retained diagnostic output and must not be consumed as a canonical checkpoint.
