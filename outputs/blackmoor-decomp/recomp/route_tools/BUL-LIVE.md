# Bul wager route tool

`story_route.py afternoon-door --save m22` and `linda-passage --save m23`
retain the exercised ordinary input routes. `bul-start` ends at the wagered
S1261 board and rejects `--save`: starting the puzzle proves no win or reward.
The historical fixed100-roll policy lost on the fresh root chain.

`bul_live.py` makes one bounded actual attempt from an uncompleted
m23-equivalent at S4408. It supports original Junior0 and Senior2 saves. It
reads closed headless PPM marker/PASS pixels, chooses ordinary roll/pass
clicks through RC_CONTROL_FIFO, and lets the original game execute the rules,
AI, randomness, dialogue, inventory and saves. It refuses a natural loss,
ambiguous initial board, incomplete input, missing win/reward or failed reload.
There is no automatic retry and no all-deal/optimal-policy guarantee.

Example (substitute your reviewed binary/data/save paths and their pins):

```sh
python3 bul_live.py --native "$NATIVE" --native-sha256 "$NATIVE_SHA256" --game-exe "$GAME_EXE" --game-data "$CLEAN_DATA" --source-save "$M23" --save-sha256 "$M23_SHA256" --save-name m24 --output "$NEW_EVIDENCE_DIR"
```

Use Python3.11+ on macOS with APFS clone support (`cp -cR`). The data seed must
contain GAME.EXE, Game.ini and Ciftree/CIFTREE.DAT, no Documents5 saves and no
symlinks. Supplied files are read-only inputs. The CLI creates fresh producer
and reload data clones, runs only in those clones and never overwrites an
existing output directory or supplied save. Default output is a newly created,
retained temporary directory. Every generated capture, input stream, decision,
log and receipt remains there; proprietary captures/data are local runtime
artifacts and must not be committed or published.

Acceptance requires the observed authored3635→1258→1259 win/reward chain,
durable1405, real held7, original UI save, the clean FIFO finish and a fresh
save-only reload that selects actual7 then ends with two clear3510/view4
observations. Transient1969 may clear during1258; it is not the durable reward.
`check_route.py --route bul-key` checks an actual result, not a static solve
promise. Clock338–341 are diagnostics; required story/failure/timer flags are
scoped separately. Only the combined outer receipt can set `accepted=true`.

The source save must have1404/1435/1405 unset. Output naming uses1–10 lowercase
letters/digits and a different name from the supplied save. Limits are one
160-observation play loop,192 FIFO requests per session,90M imports,1.8M idle
polls and at most300seconds per session. Any failure returns1 and retains the
evidence. No board, RNG, clock, handler or serialized save state is written by
the tool; pixel geometry and the Senior-derived gap heuristic are input tooling,
not a replacement puzzle implementation.

The first-board marker calibration replaces the private prototype's external
image template; center parking avoids its post-save panorama turn. The exact
client has passed observed Junior and Senior win/save/fresh-reload runs on the
reviewed host; RECOMP-16 records pins and evidence. Synthetic checks alone do
not establish this result. Other deals and starting states remain unverified.
