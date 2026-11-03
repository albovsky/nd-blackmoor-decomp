# Scripted routes on the native recompiled build

## Aeolus prizes

`route_tools/aeolus_live.py` continues genuine corrected Junior m60 through original Aeolus, UI m61 and independent fresh-save-only reload. Caller-pinned local data/source/atlas/profile are required; movement is selected from captured pixels while original code handles wind, retries and rewards. See `AEOLUS.md` and `campaigns/aeolus-earned.json`.

The new public invocation on9ae/fc passes156producer events/47captures and8reload events/two captures, native0/normal stop;31moves and one ordinary original retry. Actual1098–1101/1959/2052 rise, output206aba is safe3813/view0/held13/day3 17:23;236saved predicates/40inventory cells match,2163 stays1 and no forged15/2004 is granted. Historical privateb49/A43 and the9ae→1cf static-source comparison remain distinct. Other boards/Senior/full campaign/final Mac are outside this slice.

## Alchemy, laboratory and mould

From genuine m57, `alchemy-win --save m58` wins the original five-round trial and returns3054/held13 with1960=1. `lab-entry --save m59` reaches3804. `mould-shape --save m60` performs the original bar controls, including the missing legal2163 toggle at325,76, and collects actual10 while retaining held13. The saved24-positive/12-zero shape matches the installed loose3876 forge gate. Do not apply the older campaigns' later2163 correction to this already-correct shape.

All three current-source b49 producer/fresh-output-only reload pairs pass:78/9,33/9 and118/9 events, normal stop/exit0. Exact source/output/input/resource pins, logged scopes and full serialized-state contracts are in RECOMP-34 and its private packets. Later lab/mould logs use a focused scope because full inherited185 plus36bar fields exceed the fixed logger capacity; outer saved-state checks retain all inherited requirements. No Aeolus1959, forged15/2004 or later win is claimed by this chapter.

The checker's `alchemy_won` and `mould_prepared` result fields label the accepted route. The checker validates its scoped observations and selected phases; root's separate outer audit establishes actual item10 ownership, all236 saved predicates, inventory and source/input/native hashes. Extra same-scene observations are checked for valid state but are not rejected by count. The exact exercised input and complete capture accounting establish this run's five-round schedule.

## Optional Cake Mixing

`recomp/route_tools/cake_live.py` performs the original first-use Cake branch from pinned Junior m51 or Senior s57. Four normal right hovers verify3→2→1→0, then microwave/instruction/oven input enters3600. Original ingredient selection, phase2 finish, baking and pickup produce good-cake1. After normal room return/UI Save, a fresh output-only Load selects actualheld1. See `CAKE-LIVE.md` for guarded commands and original controls.

Both new public-client runs on b49 pass91/91 producer and14/14 reload steps with normal finish/exit0. Final save3520/view0/unheld owns1 and no bad-cake0; other39 inventory cells stay unchanged. Authored3554 resets1502/1503. Six-character names differ from historical private outputs; no old save is substituted. See campaigns/cake-optional.json and RECOMP-32. These optional branches do not grant other recipes, repeat sources, new hosts, whole-game or final Mac acceptance.

## Optional Memory

`recomp/route_tools/memory_live.py` reuses ordinary Session/PPM input and learns only exposed card faces. Explicit profiles under `memory_profiles/` verify the genuine save's hash, difficulty, clock and prerequisites without changing state. The included12-event body preserves the observed Jane game request and Memory selection; shared Load makes19 events. See `MEMORY.md` for probe/solve commands and bounded post-win Bye input.

Actual private Junior/Senior runs on b49 win in23/24 pairs, then save/reload safely at3510/view4/held-1 with new1345 and cleared1988/2072, unchanged inventory and natural clock progression. No item reward exists. The collected policy, nine IO helpers and producer/save/reload tail match those executed runs; the new public CLI/profile glue has two actual11-step entry probes and six finite check groups, but no new whole public solve. `campaigns/memory-optional.json` and RECOMP-31 preserve the exact distinction. These optional branches are not spliced into either story campaign.

## Earned ending

`python3 recomp/route_tools/earned_ending_route.py > work/ending-input.txt` emits the exact45 ordinary events from the only genuine pre-ending save in the Load list. Use `--without-load` for its38-event body or `--slot-y Y` for another observed save row. There is no save tail. Start at3844/view0/held15 with2004=1, using the game's own pre-ending UI save; the helper neither creates nor edits one. It preserves the S3909+200ms short escape and observed post-win Aeolus N1,N2,W2,W2 walk. Award continuation anchors6517 rather than assuming one difficulty's award.

Both Junior m77 and Senior s85 fresh-source replays pass on reviewed b49:45/45 steps, normal stop/exit0, actual story→closing→award6527/6529→teaser→6562/CREDITBK/CRED01. Two closed captures per run show different scrolling-credit positions. Native times are58.04/58.14s, virtual times338029/338031ms. Use MAX_IMPORTS=90000000, MAX_IDLE_POLLS=300000, SCRIPT_TAIL_MS=5000 and RC_FLAGS=1039-1040,1959,1973,1999,2004,2017. See RECOMP-30 and campaigns/ for exact save/build/input/log/frame metadata. These are ending-only b49 runs; historical complete campaigns retain their own build boundaries. The final Mac app run is separate and pending.

## Input format

Headless runs of `rc_headless` (see `rc_headless.c`) with the deterministic virtual clock. A route is the `INPUT` string:
`time:kind:args` steps separated by `;`, `kind` = `move`, `click` (args `x,y[,hold_ms]`), `key` (args: virtual-key code) or `shot` (a picture of the
primary surface, `frames/shotNNN.ppm`). `time` is virtual ms, or `FILE.EXT+ms`: that long after the game first opened that file. Steps that share an anchor
keep their spacing even when the game runs late; the game polls its input only between its own animations, so give a scene a few seconds of room.

```
GAME_EXE=work/original/GAME.EXE RC_GAMEDIR=<dir with Ciftree CDSound CDVideo Game.ini Nancy.cid display.drv> RC_OUT=<out> \
  MAX_IMPORTS=6000000 MAX_IDLE_POLLS=20000 INPUT="..." rc_headless
```

`MAX_IDLE_POLLS` counts every idle poll of the message loop over the whole run (5 virtual ms each); raise it for long scripts. Saves land in the
`Documents5` folder of the game dir: use a scratch copy of the game dir, not the owner's.

The native clock only counts calls, the Python oracle's `GetTickCount` also adds real elapsed time, so the two timelines differ by seconds. Use anchored
times on both and compare pictures taken at anchored moments, not numbered frames.

## Opening (native timeline, measured 2026-10-29)

```
MAIN.CIF+1400:click:290,46;MAIN.CIF+4400:move:450,262;MAIN.CIF+5400:click:450,262,1500;
S2010.CIF+16000:move:460,272;S2010.CIF+18000:click:460,272,2000;
S2009.CIF+4000:move:250,262;S2009.CIF+5000:click:250,262,400;
S2016.CIF+3000:move:335,322;S2016.CIF+4000:click:335,322,400
```

New Game, Junior Detective, the intro movies (S5900 to S4808), Nancy's room (S2010), turn to the suitcase (S2009), zoom (S2016), open it (S2017). On the
Python oracle use `S2010.CIF+4000` and `+5000` for the room click (it is ready sooner).

## After the suitcase (all coordinates are the 640x480 screen; `P` is `UICELLPOPUP_OVL.CIF`, `U` is `CUR_URLIMAGES_OVL.CIF`)

| Goal | Steps | Reaches |
| --- | --- | --- |
| Cell phone | `S2017.CIF+6000:move:428,448;S2017.CIF+7000:click:428,448,1500` | phone home screen (`UICELLPOPUP_OVL.CIF`) |
| Close the phone | `P+8000:move:613,24;P+9000:click:613,24,1000` | back in the suitcase |
| Phone, online options | `P+8000:move:500,236;P+9000:click:500,236,1000` | "Online options" (E-mail, Internet browser) |
| Phone, directory | `P+8000:move:555,236;P+9000:click:555,236,1000` | Home, Mrs. Petrov, Ned Nickerson |
| Internet browser | online options, then `P+12000:move:505,148;P+13000:click:505,148,1000` | "Internet access" page (`CUR_URLIMAGES_OVL.CIF`); single clicks on SEARCH did not react in two runs, a sweep of eight clicks along the top bar and below it (x 410 to 590, y 20 to 60, 3.5 s apart) ended on a "Blackmoor Manor" page, which of them did it is not known |
| Case journal | `P+16000:move:322,448;P+17000:click:322,448,1000` after closing the phone | journal text (fonts render) |
| Leave the suitcase | `P+14000:move:320,372;P+15000:click:320,372,1000` after closing the phone | S2021, then S2009 (room view) |
| Window seat | from S2009 `move:630,200`, click | S2018 (the seat with cushions) |
| Moon panel | in S2018 `move:300,300`, click | S2082 (moon-shaped panel); clicks on it play Nancy's lines; solving it needs items from later in the game |
| Game menu | `P+14000:move:75,448;P+15000:click:75,448,1000` | main menu; Continue Game is enabled |
| Game Setup | menu, `move:270,236`, click | volume sliders, Closed Captioning, Auto Move |
| Save | menu, `move:275,95`, click (Load & Save), `move:550,40`, click | `Curse.SAV` in the game dir |
| Load | Load & Save, click the slot at 300,105, LOAD at 553,248, YES at 217,271 | the suitcase scene again (state restored) |

Cursors in the room views: an up/down arrow is a move, a magnifying glass an examine, a small ring a hotspot with an action.

Compared with the Python oracle (same anchored script, 2026-10-29): the phone home screen, the online options screen and the browser's intro page are
pixel-identical (0 differing pixels each). The save, load, menu, journal, window-seat and moon-panel scenes were looked at on the native build only.

## Typing

`key:VK` presses and releases a key through the platform path (`rc_input_key`), so a printable key makes a `WM_CHAR`; `keydown:16` before a letter and
`keyup:16` after it give a capital; `keyhold:VK,ms` holds a key down for a game that polls the key state. Checked in the save-name box of Load & Save
(2026-10-29): `k:8` six times clears "Curse", then `keydown:16;key:78;keyup:16;key:65;key:78;key:67;key:89;key:49` shows "Nancy1" (a shifted N, lower-case
letters, a digit, the caret after it).

## Checkpoints with the game's own saves (fast route development)

The first 30 s of wall time of a route are the intro movies. Save once (menu, Load & Save, click the name box, type a name, SAVE) and start later routes
from the save: `route_tools/route_load.sh OUT SLOT_Y "steps"` loads it from the main menu (about 4 s of wall time to the room) and runs the steps with the
anchor `S2010.CIF`. The runs are deterministic, so a prefix of steps always gives the same state and a route can be extended one hop at a time. The
checkpoint used here is `m0`, saved in the bedroom's first view right after the suitcase (S2010, `UICELLPOPUP_OVL.CIF+23000` after the opening route
below with the phone closed and the two back-outs `move:320,372`/click and `move:190,355`/click).

`route_tools/` has the helpers used to find the clicks: `python3 route_tools/mkscenes.py` writes `scenes.txt` (the action rows of every decoded scene resource,
one block per scene id, through the production parser via `scenedump.c`; it reads the decoded resources under `work/analysis` and the file stays out of git),
`hot.py SCENE` prints a scene's exits with their rectangles (action 0x0b: one rectangle; 0x0c: one rectangle per view frame; 0x62: a hotspot),
`chain.py "S3301:5 S3302:11 S2010:8:10"` gives the click at the centre of each row's rectangle (`scene:row[:frame]`, the frame picks the rectangle of a 0x0c
row) and `rt.py` turns click tokens into `INPUT` steps. Run them in the folder that holds `scenes.txt`. A turn in a panorama (S2010 has 20 views) is a click in the left or right edge strip with a short hold (150 ms): one click is
one step of the view.

## Bedroom to the stair lock (from the `m0` save, anchor `S2010.CIF`)

| Hop | Click | Reaches |
| --- | --- | --- |
| turn left three times | `10,200` with hold 150, 6 s apart | the view with the carved door in the middle |
| the bookcase beside the door | `303,170` | S2011, the library nook (Newton's cradle S2019, moon box S2038, book S2027 are exits of it) |
| left edge strip | `20,170` | S2006, the closed door |
| the door | `317,167` | S2007, door open |
| through it | `277,175` | S3301, the upstairs hall |
| hall and stairs | S3301 row 5, S3302 row 11, S3370 row 1, S3371 to S3379 row 2, S3380 row 3 | S3395, the stair-lock puzzle (centres of the rectangles: `317,162` `67,161` `307,161` `406,160` then `393,161` nine times, `357,188`) |

The whole step list as `INPUT` steps (anchor `S2010.CIF`, after the load steps of `route_load.sh`):

```
S2010.CIF+8000:move:10,200;S2010.CIF+9000:click:10,200,150;S2010.CIF+14000:move:10,200;S2010.CIF+15000:click:10,200,150;
S2010.CIF+20000:move:10,200;S2010.CIF+21000:click:10,200,150;S2010.CIF+26000:move:303,170;S2010.CIF+27000:click:303,170,600;
S2010.CIF+32000:move:20,170;S2010.CIF+33000:click:20,170,600;S2010.CIF+38000:move:317,167;S2010.CIF+39000:click:317,167,600;
S2010.CIF+44000:move:277,175;S2010.CIF+45000:click:277,175,600;S2010.CIF+50000:move:317,162;S2010.CIF+51000:click:317,162,600;
S2010.CIF+56000:move:67,161;S2010.CIF+57000:click:67,161,600;S2010.CIF+62000:move:307,161;S2010.CIF+63000:click:307,161,600;
S2010.CIF+68000:move:406,160;S2010.CIF+69000:click:406,160,600;  then, 6 s apart each (+74000 to +117000), move and click 393,161 nine times;
S2010.CIF+122000:move:357,188;S2010.CIF+123000:click:357,188,600;S2010.CIF+133000:shot:0,0
```

At S3395 the seven levers A to G react: a hand cursor over a lever and a sound caption ("** WHOOP **", "** BLA-DING **", "** BANG **") when it is clicked.
The puzzle is the piano of the next section. The `.AVF` puzzle video needs `CreateFileMappingA`/`MapViewOfFile`, which the host now provides (read-only copies).

## The moon box and the library nook (same start, `S2011` hops)

`T:10,200` three times, `c:303,170` (S2011), then the hops S2011 row 4 (`338,272`) to S2038 (the cube on the chair: it turns when its edges are clicked), S2038
rows 3, 6, 9, 12, 15 (`528,165`, `106,169`, `255,223`, `376,221`, `322,65`: turns and the dragon face, S2041; the lock plate with a half moon, S2042 and S2047),
row 18 (`310,354`) back to S2011, S2011 row 5 (`121,222`) to Newton's cradle S2019 and S2019 row 3 (`327,183`) to S2186. All of it renders and reacts.


## Credits

Menu (`75,448`), Credits (`275,283`) opens CREDITBK.CIF/CRED01.CIF and the scrolling list of names plays with Brigitte.his (checked 2026-10-31 at S3303 and from the bedroom).
The click must be short: the credits loop polls `GetAsyncKeyState(VK_LBUTTON)` once it starts and leaves at once when the button is still down, so a click with a hold
of 800 ms (the default of the other steps) bounces straight back to the menu. Use `275,283,40`.

## Story routes: the stair lock to the moon box (2026-10-31)

`route_tools/story_route.py` writes the `INPUT` strings of five legs that chain through the game's own saves. Run a leg from the save it starts at (the Load & Save list
is ordered by the game, not by name, and a new save reshuffles it: `route_load.sh` takes the row's y, so look at the list, rows are 42.5 px apart from y = 105):

| Leg | From | Does | Ends (with `--save NAME`) |
| --- | --- | --- | --- |
| `stairs` | `m0` (bedroom right after the suitcase) | up to S3395 (see "Bedroom to the stair lock"), the piano, S3396/S3397, key 17 from S3398 | S3397, key 17 owned |
| `lock` | S3397 | down the hall to S3448, the key shows the lock is stuck, back to the bedroom, the intercom order, S3350/S4400 (delivery), the tray, butter 25, back to the lock | S3447 |
| `slider` | S3447 | the slider puzzle S3450 (105 moves), the compartment S3452/S3453 (item 6), S3455 cancel strip, S3457 | S3303 |
| `moon` | S3303 | the library nook S2011, the moon box S2038, its five dials, the lens diagram | S2076 |
| `telescope-prep` | m6 / S2076 | collect lens 12, inspect tripod, read all chart pages | m7 / S2010 view 2 |

```
python3 route_tools/story_route.py stairs --save m1        > leg1.txt     # then:  route_load.sh OUT ROW_Y_OF_m0 "$(cat leg1.txt)"
python3 route_tools/story_route.py lock   --save m4        > leg2.txt     #        route_load.sh OUT ROW_Y_OF_m1 ...
python3 route_tools/story_route.py slider --save m5        > leg3.txt     # needs MAX_IDLE_POLLS=900000 MAX_IMPORTS=90000000
python3 route_tools/story_route.py moon   --save m6        > leg4.txt     # needs MAX_IDLE_POLLS=300000
python3 route_tools/story_route.py slider-verify                        # the recorded slider moves solve the puzzle rules
```

A leg is 4 to 35 s of wall time. Each was run end to end from a fresh game directory (one save `m0`) the day it was written.

### The hops

| Where | Click | Reaches |
| --- | --- | --- |
| S3395, the piano | keys 1,0,3,2,0,3,4,4 of seven at y 250 (x 47 131 222 319 414 509 592), 5 s apart, hold 300 | S3396 movie, S3397 (the lock open, a key in its slot) |
| S3397 | `314,108`, then `284,204` in S3398 | key 17 (the toolbox icon shows a badge) |
| S3397 down to S3448 | bottom strip `309,352` twice, then `322,172` eight times, `267,163`, `361,162`, `138,160`, `166,209`, `583,221` | S3380, S3381 to S3389, S3390, S3391, S3302, S3345, S3448 |
| S3448, the lock | `328,214`, toolbox `212,448`, key (slot 0 at `67,113`), `328,214` | "The key fits, but it won't turn. I need to put some kind of grease in there first." (flag 1800) |
| back to the bedroom | `309,352`, `45,188`, `294,162`, `304,162`, `532,161`, `292,189`, `292,162`, `353,173` | S3345, S3306, S3307, S3308, S3340, S3341, S2000/S2005, S2010 |
| the intercom (view of the nightstand: 4 turns left from the arrival view) | phone `405,262`, `405,199`, `201,208`, `307,100`; S1807 choice at `150,433`, S1820 choice at `100,421` | S2013, S2020, S2098, S1800, S1810, S1802 to S1807, S1809, S1820, S1825, S1821, S2098 (bread and butter ordered) |
| out and past S3350/S4400 | turn 6 left, `303,170` (door), `317,167`, `277,175`, then `317,162` `336,162` `317,162` `473,161` `128,162`, wait 10 s, `292,189`, `292,162` | S2006, S2007, S3301, S3302, S3303, S3304, S3311, S3350, S3351, S4400 (the delivery flag 1161), S4405 |
| back to the tray | `310,354`, `312,163`, `415,163`, `325,161` twice, `219,163`, `298,162`, `294,162`, `304,162`, `532,161`, `292,189`, `292,162`; then `310,239`, `461,215` (12 s later again), `309,310` | S4406, S4407, S3322 to S3324, S3305 to S3308, S3340, S3341, S2105 to S2108, S2113, S2131: butter 25 |
| tray exit, door, lock | `316,209`, `310,347`, `310,354` twice, turn 6 left, `303,170`, `317,167`, `277,175`, `317,162`, `176,219`, `593,231` | S2132, S2133, S2012, S2010, S2006, S2007, S3301, S3302, S3345, S3448 |
| the grease | toolbox, butter (slot 0 `62,100`), hover over `320,205` and click, again `318,204` | S3445 (flag 2094 greased), back in S3448 |
| the key | toolbox, `62,100` (puts the butter back), `62,100` (takes the key), hover, click twice | S3449 movie, S3447 (the stairs behind the lock) |
| S3447 | `241,166` | S3450, the sliding-piece door |
| S3450 | 105 moves, see below | S3451 movie, S3452 |
| S3452 | `310,216` (the compartment), `318,191` (S3453: item 6), then `310,352`, again at S3455 | S3453, S3452, S3455, S3457 (stairs movie), S3303 |
| S3303 back to the bedroom | `309,352`, `294,162`, `304,162`, `532,161`, `292,189`, `292,162`, `353,173`, 1 turn left, `518,180` (the bookcase side of the nook view), `338,272`, `255,223`, `314,172` | S3306, S3307, S3308, S3340, S3341, S2005, S2010, S2011, S2038, S2042, S2047 |

### What the first runs taught

* A click on a hotspot only counts when the cursor was moved onto it first (a hover the game saw). Every click in these routes has its move 1 s earlier. The butter and the
  key on the lock needed the pointer to move inside the hotspot before the click, twice.
* The bedroom panorama turns by an amount that depends on how long the pointer stays in the edge strip. After each turn click, move the pointer out (`mv:320,60`) and give
  the turn 3.5 s. With that, `4` left turns from the arrival view face the telephone, `6` face the carved door.
* The native port's recorded clicks (`work/playability-20261024/native-grease-combined-probe-doorfix.mm`, `native21-room-solve.log`) are in its frame with the view origin at
  (10, 10); the game itself takes the coordinates 10 less. The 105 slider moves in `route_tools/slider3450_moves.txt` are stored in the native frame and `story_route.py`
  subtracts 10. The moves are timing independent, the final arrangement is the same with 5 s and 10 s between moves.
* Saves are ordered by the game, not by name (rows y = 105, 148, 190, 233, 275, 318; after `m0` to `m5` the order was m2 m1 m0 m5 m4 m3).
* Route starts anchored on a scene file (`S3397.CIF+...`) count from the first time the game opened that file in the run, so a leg must not anchor on a scene it passed
  earlier in the same run.

### The slider puzzle (S3450)

Five rows by six columns, ten pieces on the cross of the edge cells, one cell type per piece that it must rest on; a click on the piece (top half: up, right quarter: right,
bottom half: down, left quarter: left) slides it until a barrier, an edge arrow or another piece stops it (`src/action_family_d3_runtime.c`). The scene has two rows with
different start layouts that alternate; the one used here starts with piece 3 at (2, 0). `story_route.py slider-verify` runs the 105 recorded moves on those rules and
checks that every piece ends on its own cell.

### The moon box (S2038)

Five faces, each a dial: the lever at the right (`436,150`) steps the colour (blue, red, green, blue ...), the knob at the top left (`182,70`) the phase (first quarter,
waxing gibbous, full, waning gibbous, last quarter, waning crescent, new, waxing crescent). The scene scripts store `colour * 8 + phase` (phase 0 new, 1 waxing crescent,
2 first quarter ... 7 waning crescent) and open the box when the five variables read 12 (DRACO: red full), 18 (LEPUS: green first quarter), 13 (LEO: red waning gibbous),
3 (PISCES: blue waxing gibbous) and 0, 8 or 16 (LYNX: a new moon). The faces start at blue first quarter (DRACO), blue waxing gibbous (LYNX), red full (LEO), red first
quarter (LEPUS), green waning gibbous (PISCES). The scene script flags 1025 to 1029 show which dials are right (`RC_FLAGS`, below). Inside: a telescope lens (S2075, S2076:
"This lens is supposed to go into a telescope that sits on a tripod").

### Earlier moon-box continuation (superseded by the verified route below)

The earlier continuation was picture-only and did not prove a telescope solve. Use `telescope-prep` below; the old six-click panorama recipe has been replaced by measured single-frame turns.

## Debug switches of rc_headless

* `shot` steps write `frames/shotNNN.ppm` from 1; the numbered flip dumps stay `frameNNN.ppm`.
* `SCRIPT_TAIL_MS` (default 5000, 0 = never): stop that long after the last step, so a route does not run on to the idle limit.
* `RC_FLAGS="1000-1030,1716"`: at every shot, log the non-zero event flags in those ranges (the game's table at 0x585801 + 4 * n).
* `RC_TRACE_MS=from-to`: log every import call (name, arguments, result) in that range of virtual milliseconds.
* Long routes need `MAX_IDLE_POLLS` and `MAX_IMPORTS` raised (the 105-move slider run uses 900000 and 90000000).

## Telescope preparation, verified 2026-11-01, 19:38 PST

Generate the next leg, then pass its steps to `route_load.sh` with the row of m6. Verify the resulting log and game-generated save:

```sh
python3 route_tools/story_route.py telescope-prep --save m7 > leg5.txt
```

The loader invocation uses the documented `RC_HEADLESS`, `GAME_EXE` and scratch `RC_GAMEDIR` environment. For a folder containing only m6, its row is 105. Set `RC_FLAGS="1309,1834,1843,1905-1906,1949,1953,1980,1993,2036-2037"` before the run. Afterward:

```sh
python3 route_tools/check_route.py OUT/run.log "SCRATCH/Documents5/The Curse of Blackmoor Manor/m7.SAV"
```

The leg leaves S2076, collects lens 12 in S2074, backs out through S2075/S2040/S2011, inspects S2014 and reads S2015→S2022→S2023→S2024→S2025→S2026. It returns to S2010, view 2, and saves m7. The checker requires the ordered pre-turn/tripod/chart/return observations, the complete flag observation range, expected flag values, a clean requested stop and the checkpoint file. It rejects a process that merely exits successfully after missing the route.

The original chart flags 1953, 1949, 1834 and 1843 are all 1 at S2026 and after the return. Lens-knowledge 1905 and moon-solved 1993 are also 1. The final log records that it observes 1980, 2037, 2036, 1309 and 1906; all remain 0. This is telescope **preparation**, not completion. Jane must lend the telescope after her timed jigsaw, followed by delivery scenes. Installing the lens then sets 1309; looking through it sets 1906. Those later interactions are statically mapped, not verified here.

New virtual-clock routes use `R.turns('right', n)` / `R.turns('left', n)` with the default AutoMove=1. A 100 ms edge hover followed by a move inside is shorter than the 400 ms repeat gate. The old click helper spends a second hovering before its click and advances multiple frames. Actual m6 return enters view 8; eight short right turns reach view 0, checked before clicking the tripod. The tripod's return selects view 19, where the chart hotspot is 48,157; the chart's return selects view 2. These timings are not validated under `RC_REAL` or the macOS app.

Every `shot` logs original `STATE requested_scene=... art_scene=... view=... held_item=...` cells and the exact `RC_FLAGS` range used. The requested scene can be a pending transition; the art scene remains the background owner in retained-art scenes. These observations never write game state.

Private evidence under `work/recomp-playability-20261101/` records a fresh opening and save chain through stairs, lock, slider and moon. Each leg used a fresh data copy and only its preceding game-generated save. `telescope-prep-final/` records the initial candidate, `telescope-prep-reviewed/` the checked review follow-up (7.89 seconds). Its native headless SHA-256 is `7f95700f202b7b2d1518545bc8a83dd8193c61d917ec1d20281053ef143e8d91`. Four small checker tests also pass. `lens-owned-reviewed/run.log` proves item 12 through normal inventory selection after loading the exact reviewed m7 with that same binary. Earlier `pan-short/` and `lens-owned/` observations used binary `72e3ba3c…`, before the extra flag-scope log line. The checker verifies navigation, chart flags and save presence; fresh-folder setup and the separate inventory check establish save provenance and lens ownership. Both frozen Sonnet reviews accept the slice with no P1 or blocking P2. Complete story, telescope completion and the final background app playthrough remain unverified.


## Linda and Jane, verified 2026-11-01, 20:13 PST

The thread-enabled host passes a fresh New Game chain through m6, then `telescope-prep --save m7`, `linda --save m8` and `jane-intro`. Each run starts with an independent data copy and only the prior game-generated save. The earlier piano/lock/slider/moon legs remain green after the TLS, Sleep and wait changes.

`linda` starts in bedroom S2010 view 2. Six short left turns reach the door view; the route follows S2006/S2007, the upstairs hall and S4405 to Linda. Original dialogue completes S1137→S1101…S1136→S1106→S1107→S4408, with flag 1570=1, then saves m8. The fresh final run takes 10.10 seconds.

`jane-intro` starts at S4408, leaves via S4412/S4410, turns from view 2 to view 10, and follows S4406/S4407/S3322…S3305/S3345/S3346/S3500/S3505 to S3510. The original secondary-video worker now starts instead of raising the CThread constructor error. Jane's S1200 animation and dialogue play; reply at 150,446 selects playing a game and reaches S1202→S1203→S1204→S1205→S1206. It ends at Memory ready for input, not solved, and has no save tail. The fresh final run takes 5.24 seconds, with three original CRT/MFC workers ending naturally with code 0. UI response positions depend on wrapping:150,446 selects the first response here; an earlier driver incorrectly called it the second.

The native host uses a separate pthread continuation and guest stack/TIB/TLS/x87/abort state per guest thread, while a single execution token serializes lifted code. Event waits and Sleep yield to real producers; recursive critical sections, suspended startup, exit codes and handle lifetime are covered by nine device-free tests. No successful dummy handle or substitute decoded-frame path is used. A separate live-worker stop test ends cleanly; two S1200 snapshots show 14,721 changing character pixels, not oracle/full-frame parity. Real-clock/app-thread behavior and other original worker families remain unverified.

Evidence: `work/recomp-playability-20261101/thread-regressions/`, `thread-final-chain.log`, `thread-fresh-{prep,linda,jane}/`, `jane-animation-final/`, `thread-animation-evidence.json` and `thread-focused-tests.log`. Native headless SHA-256: `c5ffc6d8549776b1ff3eb081faefe95e01e8b1d5e1c813dfd36e407b2b82ba1c`. Next: finish Memory and Jane's telescope-loan/jigsaw path, then install the lens and verify 1309/1906. Full gameplay and the final background app campaign are incomplete.


Thread review follow-up: idle message waits now schedule workers, real-clock sleeps release the guest token, and seven thread tests plus four route-checker tests pass. The final Jane continuation still reaches S1206 with clean worker completion; follow-up native SHA-256 `f7caabaf18f4bc4100279e8d4534e981846145f27953e3dfda72332321d3b136`. Earlier c5ffc6… logs remain labeled as the initial candidate. Normal Exit Game is at275,425 on the menu (330 is Help,379 is More Nancy Drew); it reaches teardown but stops at unlifted CRT0x515d1e. That is a real next host blocker, not a completed Quit check. The original fixed-pair Memory replay did not prove a win; different deals or input interpretation require further observation before recording a solve.

Final scheduler correction (2026-11-01, 20:58 PST): yield-only polling releases the mutex for a sleeping worker to wake, and suspended sleepers cannot acquire an empty token before ResumeThread. Sleeping guests are ineligible until they wake, except during shutdown; shutdown waits for a platform sleep callback to return. Two regressions reproduce the rejected predecessor's defects with ordinary CHECK failures. Final narrow suite: 9 thread + 4 route checks pass. Native `e576b924f49dad2ef4b69e17322408cc5260cab01fe80fd595f978c7af2f6c5c` reaches S1206 again (virtual clock, 5.63 seconds) and separately stops an active Jane worker cleanly (4.51 seconds); see `jane-race-verified/` and `jane-race-live-stop/`. ARM64 app build/signing passes without launch. Actual real-clock application timing remains unverified; only the deterministic real-clock callback regressions cover the two specific scheduler races. Final Sonnet review accepts frozen 9a1a8a83 with no P1 or blocking P2; the possible 1 ms per-yield real-clock performance cost remains unmeasured.

## Normal Quit, verified 2026-11-01, 21:05 PST

From loaded m8/S4408, use MENU75,448 → Exit Game275,425 → confirmation217,271, with move before click. The recompiled native now executes CRT cleanup callback0x515d1e and reaches ExitProcess(0), rather than an unresolved-function stop. The wrapper trims only the five proven padding bytes after its13-byte body, with local guards; global interior-int3 refusal stays intact. Native c483fc474778f6f603c2f63b4f2de759a7866a92150df17fc64310b815ba8de6; private evidence `quit-cleanup-candidate/` and `quit-final-tests.log` (2 static tests pass). This is a virtual-clock headless check from a fresh data clone and the genuine m8 save. Real-clock app Quit with active media and exceptional cleanup remain unverified; general exception-filter chaining is unchanged. See `tasks/RECOMP-02-quit-cleanup.md`.

## Jane's telescope-loan jigsaw, verified 2026-11-01, 22:21 Pacific

`story_route.py jane-jigsaw --save m9` follows m8 through the normal alternative greeting replies1200→1222→1225→1228→1289, re-talks to Jane and chooses her telescope request.1424=1 opens Junior1273→3575. The20 recorded pick/drop pairs solve the original timed jigsaw and reach3578→1234 with1980=1. Drop coordinates include the10,10 viewport origin; omitting it moved all pieces but failed the6-pixel snap tolerance. This is the first Junior layout, with no rotations; Senior and retry layouts are unverified.

After the win, the list includes another story topic and Bye is below the visible text. Drag the original left thumb (22,405, hold6000ms;5px moves down to456) before choosing150,430. The public route performs that drag, finishes Bye, returns to3510 view4 and saves m9. Final native run `jane-jigsaw-save-scroll/` takes18.33s; generated public INPUT is byte-identical to that exercised script. Fresh m9-only reload verifies the earned loan and original3507 delivery progress2037. Memory is a separate optional branch and remains unsolved.

Check the leg with `check_route.py OUT/run.log PATH/m9.SAV --route jane-jigsaw`. It requires observed3575 before the win,1234 with1980=1,3510 view4, correct prerequisites, explicit zero telescope/delivery flags, clean stop, a matching checkpoint-open line and save size. Fresh-copy and reload evidence separately establishes checkpoint provenance. Eight checker tests pass. Native c483fc474778f6f603c2f63b4f2de759a7866a92150df17fc64310b815ba8de6; private input/save hashes in `jane-jigsaw-public-receipt.json`. See RECOMP-03 for failed proposals, original-coordinate evidence and validation limits. Next: finish delivery2036, the incoming Petrov call and lens use through1906. Telescope completion and whole-game playability are not yet claimed.

Independent Sonnet review accepts frozen001555fd with no P1 or blocking P2. The checker infers the win from observed1980 changing0→1 at1234; it does not require a separate3578 shot. The public-generator/header and handoff wording corrections leave all exercised inputs unchanged.

## Telescope delivery and use, verified 2026-11-01, 22:49 Pacific

`story_route.py telescope-use --save m10` continues m9 through3507/2037 and3305/2036, the incoming Petrov call, bedroom2010→tripod2014→2078. The original phone already closes when6310 restores3308: omit any extra X click. Drag the Petrov list thumb for Bye as on Jane's list. Inventory selection records held_item12; original2079 installs it,2081 records1309=1906=1, and normal backing returns2010view19 for m10. Required no-Ethel/first-call conditions and all exact clicks are in the generator; other branches are unverified.

The first view was black despite1906=1. Correcting the lifter's9-byte sqrt entry to include its actual157-byte continuation restores the radius50 reveal and visible mural. Original source/renderer is unchanged. A read-only live-mask comparison changes149 nonzero cells to the correct7825, with0/10000 mismatches; production captures separately show the reveal. `check_route.py OUT/run.log PATH/m10.SAV --route telescope-use` checks recorded progression/held lens/install flags and checkpoint-open/size, not pixels or write provenance.

Final native f8b34e6d… public route passes in11.28s; exact m10 reload passes in1.23s.14 focused checks pass (13 route results +1 generated sqrt fixture over9 finite values); old sqrt fails7/9. Signed ARM64 app build passes without launch. Private receipt `telescope-use-receipt.json`; details and arithmetic limitations in RECOMP-04. Telescope use is now verified headlessly; the full game and final background app campaign remain incomplete. Next story target: Betty's crank, Drake and seedlings2348.

Telescope review accepts634bc528 with no P1 or blocking P2. The targeted f8b34e6d run does not individually re-verify earlier legs or the other sqrt callers44bed5/490598/4f7207/4f95a4/4f9d18. The completed broader replay now passes all10 New Game-to-m10 runs on f8b34e6d, with every source-save hash matching its preceding output (`sqrt-fresh-chain/verified-chain.json`); those other callers are not individually instrumented. the native finite-math fixture now uses exact equality.

Final Sonnet follow-up accepts1bb45b8d. The fresh chain includes the optional Jane-to-Memory entry but does not solve Memory or finish the campaign.

## App audio diagnostics, 2026-11-01, 23:29 Pacific

The recompiled frontend now builds with `--capture-audio FILE.wav`, tapping PCM16 before playback suppression so a future `--mute` background run can be inspected offline. The queue's writer drains/finalizes WAV at shutdown; overflow is an explicit capture failure. Six device-free synthetic tests pass, including the reproduced/fixed last-frame drain race. The signed app builds, but actual app capture has not run because its foreground activation must first be removed for background checks. See RECOMP-05; gameplay checkpoint remains m10, with full campaign/app verification incomplete.

Audio review follow-up: normal Cmd-Q is now routed back through main's producer/capture cleanup, and a5-second watchdog ends stuck shutdown with exit status5. Capture-start failure is3, capture-finalization failure4. Actual app/Cmd-Q checks still await background mode; the unverified filesystem/streaming branches are listed in RECOMP-05.

Audio follow-up review accepts17d2fdda with no P1 or blocking P2. Runtime Cmd-Q/background acceptance, filesystem failures, continuous streaming and system-logout coordination remain unverified; see RECOMP-05.

## Background Mac startup, 2026-11-02, 00:25 Pacific

The signed recompiled app now supports `--background --mute --stop-after-ms 5000 --snapshot FILE.ppm --capture-audio FILE.wav`, with scratch `--game-dir` and `--save-dir`. Actual native startup reaches the title splash, remains inactive/hidden with0activation notifications and exits0 through the normal Quit delegate. Logical framebuffer and nonempty finalized mixer WAV are private under `background-app-20261102/`; this is not a displayed-window screenshot or a synchronization pass. The5.49s process captured3.73s PCM; startup/cadence timing remains unverified. An opt-in actual-AppKit fixture passes4ticks/5presentations without visibility/activation. See RECOMP-06 for pins and limits. Native app room input, movies and save/load are next; headless fresh chain through m10 remains the campaign evidence.

Background review follow-up: abnormal diagnostic guest stops now fail6. Final corrected app repeat again reports exactly one Quit request/controlled stop, exits0 and retains the same title-frame hash. Run binary directly; LaunchServices activation is untested. Fresh output directories/log checks are mandatory because failed snapshots can be partial/stale. Required platform evidence/ledger hash refresh preserves all function statuses/counts; see RECOMP-06.

## Drake seedlings and Betty repair, 2026-11-02, 00:50 Pacific

Two original-save legs complete the related Betty-repair objective. `seedlings --save m11` starts from m10, follows Betty/Drake dialogue and automatically enters2348 through2347, then packs14pieces with ordinary zero-rotation placements.2002=1; save safe2347/view0/held-1. The retained306,194 click occurs after automatic entry and is unnecessary. Public234-step input is the exercised input; no timing cleanup is assumed.

`crank-repair --save m12` waits through the original night clock, refreshes daytime Drake via2399, drags the caption slider for reward150,418 then Bye150,430, and receives real item20/1541. At Betty, select crank through toolbox212,448→62,100;2711 held20→311,127→2713 held-1/1160=1. Exit310,40, visit keypad312,270→2702/1782=1, back135,354 and original-UI save2701. Card reward1963 remains0. The10,000,000virtual-ms wait is an offline driver choice; clock cells338–341 are diagnostics, not story flags.

Root fresh m10→m11→m12 replay passes32.00/76.59s with each leg in a separate clone and only the preceding UI-produced save; exact source/copy hashes match. m11-only reload passes. Use RC_FLAGS `1160,1535,1541,1782,1838-1839,1906,1963,1968,1980,1993,2002,2036-2037,2080`; MAX_IMPORTS90000000, MAX_IDLE_POLLS300000 seedlings/1800000 crank. Run check_route.py with `--route seedlings` or `--route crank-repair`. See RECOMP-07 for pins, accepted review, successful reloads and exact checkpoint identities.

## Native app input, 2026-11-02, 01:29 Pacific

Mac `--input-file FILE` uses the shared headless route driver. Quiet runs need explicit `--background --mute --stop-after-ms 300000`; the background default remains5s. Actual fresh New Game/Junior/intro reaches2010/view5/held-1, all5steps complete, own stop and exit0. Logical frame shows the bedroom. Actual load/keyboard/save writes app12 with32steps complete; fresh app12-only reload also passes with retained flags. Pass `--save-dir` a prefix above Documents5. See RECOMP-08 for native/source pins and limits.

New headless66028983… passes all12 fresh New Game→m12 runs with complete delivery and save-chain identity (`scripted-fresh-chain/verified-chain.json`). Strict invalid-input refusal is intentional; valid public routes pass. Native opening captures156.05s PCM during210.31s process runtime: muted-clock timing is a separate unresolved defect, not a sync pass.

## Muted native clock correction, 2026-11-02, 02:33 Pacific

Fixed deadlines replace render-then-10ms-sleep. Same15s probes improve active rate32928.319→44098.620frames/s against44100, PCM11.21→15.01s. Full actual native intro repeats to2010/view5/held-1 at44098.884fps with0rebases,5steps complete and identical bedroom frame. No historical catch-up or guest clock change. RECOMP-09 records pins/limits/review. The earlier large process/PCM gap is resolved for these observed active periods; general media synchronization and long stalls remain unverified.

## Right-release puzzle rotation, 2026-11-02, 03:41 Pacific

The Mac frontend now forwards right-button state to the guest queue. Scripts accept `pointer:x,y,mask`, complete left/right mask0..3; right-only release uses0 and nothing auto-releases. This is ordinary input, not puzzle-state injection. Do not mix script-held state with physical input or an unexpired legacy click hold when testing rotation. Existing timed inputs keep their behavior; real left input additionally carries modifiers and preserves held right state.

Fresh genuine m10→Betty/Drake→2348 probe picks type10 at331,286, moves150,180, presses mask2 and releases mask0 one second later. Actual native captures show40x100→100x40 clockwise,2321 cursor-excluded pixels match exactly, two settled frames agree. All158steps complete; no drop/save/win is claimed. Native0c5fc594… and evidence `right-pointer-rotation-run/`; see RECOMP-10. Four finite input checks and ten hidden AppKit callbacks in each960x480 fit/stretch mode pass. Physical mouse/full-app rotation and full campaigns remain unverified.

All12 fresh New Game→m12 runs pass on0c5fc594 with complete scripts and checkpoint hash identity (`right-pointer-fresh-chain/verified-chain.json`). Sonnet review accepts e8b6aac6 with no P1/blocking P2; both static generated-record checks pass. Nonblocking mixed-live-HWND/frontend-bridge/concurrency coverage limits remain in RECOMP-10.

## Betty's Venus key, 2026-11-02, 03:54 Pacific

`story_route.py betty-key --save m13` continues m12. At2702, ordinary keypad columns4,2,7,3,8 and RED SUBMIT enter the prize game.160 normal name requests cycle4,7,8,3,2,5,0,6,1,9 at20000ms spacing; the original scripts ignore unavailable requests. This bounded policy wins the observed deal, with1963 changing0→1 at2711. Pick up the real reward19, verify it selected in inventory, PUT, closeX360,20, return2700 and save. Different deals/difficulties may lose; require the checker, never synthesize reward state.

`venus-column --save m14` moves through2605/view16 to2649, selects real19 at the observed inventory slot62,170, then clicks278,187.2686 records1892/2000/2015=1 and no held key. Return310,354 and save safe2633/view0/held-1.1961/1999/2070 remain0: other columns/armor are unfinished. The save auto-closes; no extra close click is exercised.

Run through `route_load.sh` with the single prior save at row105, MAX_IMPORTS90000000/MAX_IDLE_POLLS1800000, RC_FLAGS `1160,1541,1782,1892,1906,1961,1963,1999,2000,2002,2015,2070`; check with `check_route.py --route betty-key` or `--route venus-column`. Root's new0c5fc594 chain extends its12fresh runs fromm12 to m13/m14 in52.69/5.38s; both save-only reloads pass, including actual held19. Exact hashes and limitations are in RECOMP-11 and private `venus-public-root-replay-0c/`.29finite checker tests and both static freshness checks pass; Sonnet review accepts38937184 with no P1/P2. Next public target: Jupiter use, Moon key and Moon column.

## Jupiter and Moon columns, 2026-11-02 Pacific

`jupiter-column --save m15` keeps source anchor2633, turns Great Hall view8→5, selects real6 at the observed fourth inventory slot, uses273,111 and returns2631.1436/1981 change0→1. `moon-key --save m16` keeps source anchor2631, waits through3305/3348 and exits3345 normally, selects lens12, installs it at2082, opens2085, then performs all12zodiac clicks through2090→2087/2092/2019. Take11 through2088, PUT/close inventory, recover12 and save2010/view3.1259/1996/2077 also become1. `moon-column --save m17` selects actual11 at134,170, uses311,171, observes2684/1597/1994 and returns2626. No armor orientation click or extra post-save close click is exercised.

Run each via `route_load.sh`, single prior save row105, MAX_IMPORTS90000000/MAX_IDLE_POLLS1800000. Root used RC_FLAGS1000-2250; the checker requires the exact prior/new/unmet sets in RECOMP-12 and refuses missing scope. Use `check_route.py --route jupiter-column|moon-key|moon-column`. The new0c root chain takes4.75/19.39/7.16s, all scripts complete, with three genuine UI saves and independent save-only reloads selecting actual6/11/12 as appropriate.1961/1999/2070 remain0.35finite checks and both static freshness checks pass. Sonnet acceptsf0ee6a90 with no P1/blocking P2; remaining limits are in RECOMP-12 and `columns-public-root-replay-0c/`. The combined private `native-chain-through-m17/verified-chain.json` ties17runs/16saves back to New Game.

## Live input for changing puzzle boards, 2026-11-02 Pacific

Headless `RC_CONTROL_FIFO` accepts consecutive LF requests `1 <INPUT batch>`, then2etc, and explicit `N finish`. Unset INPUT; create a private FIFO and fresh RC_OUT. Wait for `CONTROL ACK id=N` before relying on global `total_shots`/shotNNN.ppm. Numeric batches such as `1:move:x,y;501:click:x,y,250;3001:shot:0,0` retain their spacing despite a late first delivery. Named anchors remain first-seen process anchors. The game continues during image analysis; capture/ACK never means a puzzle action or win has completed. Finish must report complete1/failed0/all steps delivered and normal exit. See RECOMP-13 for bounds/error semantics.

Actual m28→glyph3588 live input scores real matches, and attempt04 reaches1299/2001 plus the glowstick handoff1945/1357.250ms holds/500ms cell spacing are reliable in the observed probe;40ms missed original polling. The first completed session times out at300points and is explicitly a failed solve. Later ordinary caption-scroll Bye150,438 returns3510/view4; actual bag pixels show4 first,60,100 selects held4, then PUT/X and original UI save m29.240steps/33captures complete, explicit finish26/25ACKs, exit0. Fresh m29-only reload selects actual4 and retains the earned flags in safe3510/view4; root raw-log/save-hash audit passes. RECOMP-13 has exact save/native pins. Existing static-input New Game and Moon-column regressions pass on the newcc7ce16f host.

Sonnet high accepts the frozen live-input slice3a44a658 with no P1/blocking P2; both static freshness checks pass. Requested shots/live log are strict; automatic frames/stdout retain inherited unchecked I/O. Main failure wiring and full unterminated-buffer refusal remain nonblocking coverage limits in RECOMP-13.

## Nigel's ghost hunt, 2026-11-02 Pacific

Public `nigel-computer --save m18` continues m17 to4111 through Nigel's original introduction, permission and PURGAMENTUM prompt, declining the hunt. `night-wait --save m19` uses original idle progression to day2/hour0..4. `goggles --save m20` handles the night interruption, earns1893/1788 and actually selects21 before PUT/X. `ghost-hunt --save m21` captures all13 original closeups, wins1958, returns to4178/1947 reward and clears1192/2039;2040 stays0.1961/1999/2070 remain0. Return/save safe4111/view0/held-1.

Run each via `route_load.sh`, only its prior save at row105, MAX_IMPORTS90000000/MAX_IDLE_POLLS1800000. Use the compact required RC_FLAGS scope in `ghost-public-root-chain-0c/HANDOFF.md`, including338–341 clock diagnostics; check with the corresponding named `check_route.py --route`. The four exact public legs and four fresh save-only reloads pass on0c5fc594 from root's new m17 with source/copy identity.44finite Python checks and both static freshness checks pass; Sonnet acceptse9cd1812 with no P1/blocking P2. RECOMP-14 records exact inputs/checkpoints and remaining fixture/clock-interpretation limits. Senior's shorter180-second hunt is separate evidence, not this route's guarantee.

Supplementary actual Mac app check from genuine private m29 reaches2910/held4 with visible green glowstick pixels in its logical primary capture,102steps complete/exit0/hidden inactive.279.12s offline PCM,1deadline rebase,0clipped samples; no general A/V-sync claim. See RECOMP-14 and `native-lit-passage-app/verified-native.json`.

## Widescreen cached rendering, 2026-11-02 Pacific

RECOMP-15 adds8 fixed production-view cache pixel checks in each960x480 fit/stretch mode, preserving10 direct-view pointer checks and quiet-window guards. Both modes pass on measured2x backing. The profile-aware oracle compares independent literal sRGB colors in the actual cache ICC profile, retaining2/255 tolerance; initial GenericRGB interpretation failures and the diagnosis remain recorded. No renderer or game logic changes. See RECOMP-15 for exact pins/evidence and physical-display/other-profile limits. This fixture advances desktop verification, not the story frontier.

## Passage wager and key7, 2026-11-02 Pacific

`afternoon-door --save m22` and `linda-passage --save m23` continue the public ghost chain through2058 and Linda1494/1496/1498/2156, with fresh producer/reload proof. `bul-start` reaches the original wagered1261 board and rejects saving; the fixed100-roll candidate lost naturally. Use `route_tools/bul_live.py` with the supplied reviewed-native/source pins and a new output directory for one bounded pixels-only attempt. See BUL-LIVE.md for exact arguments. `check_route.py --route bul-key` validates an earned result, not a solve promise.

The exact public client wins observed Junior and Senior games, original3635→1258→1259/1405, actual7, safe3510/view4 UI save and fresh-only actual7 reload. Junior239steps/25decisions; Senior335steps/49decisions;61finite fixtures pass. RECOMP-16 pins both independent lineages and retains the initial normal PPM-parser refusal. Every move is ordinary UI; the original game owns the puzzle. Other deals/starting states remain unverified; no optimal/all-deal guarantee or full-campaign claim.

## East Hall, ball3 and Saturn16, 2026-11-02 Pacific

`slide-ball --save m25` handles first Ethel1400/1401, actual7 at3360, door1971, first slide1575/1844 and ball3/2050 before returning safe3215/view0. `saturn-column --save m26` follows from actual owned3: original HAL_SLIDE_ANIM.BIK+835move/+850click40ms wins3421→3426→2677/1970, grants16, then real16 at2620 earns2685/1820/2005 and returns safe2620/view0.1005 is not an invented win condition;2050 remains pickup history after ball consumption. Fresh reload of returned16 uses FIRST bag slot60,100; its earlier producer selection uses the recorded different slot.

Both public fragments exactly match accepted prior UI inputs, including all waits/holds and save tails. Root's final four full-scope producer/reload runs pass from genuine public m24, checking actual3/16 and two final safe frames. Reloads preserve the original prefix plus a documented center move/settled second shot. Use complete compact scopes in `root-fullscope-slide-saturn/scopes.json`, not a broad flag range that can truncate logging.61finite route tests pass; RECOMP-17 records source/save pins, review status and bounded Junior timing/start assumptions. No host/game logic change.

Post-key collection review: Sonnet accepts634c1963, both static freshness checks pass. Ball3 uses60,100 in its producer and60,243 in reload; returned16 uses the reverse recorded slots. RECOMP-17 records exact reload input hashes and nonblocking fixture/subsequence limits; no post-review code change.

## Dragon passage and pending glyph request, 2026-11-02 Pacific

`dragon-passage --save m27` uses the recorded11lever clicks, distinct early2078 then1997 win,3343/1925/1865 entry, darkness3417 and ordinary retreat to3326. `glyph-request --save m28` asks Jane via the scrolled150,418 reply, enters original3585 rules and exits unsolved to3510/view4.1408 starts0 and rises at rules;2001/1357/1804 remain0. This is a request, not a glyph solve/light reward.

Both exact public fragments plus separate fresh save-only reloads pass with complete compact scopes from final public m26;68finite route fixtures pass. Packet RECOMP-18 and private `root-fullscope-dragon-light/verified-public-chain.json` pin sources, checkpoints and reload deltas. Every route uses normal original UI/saves; no host/game change. Alternate starts/Senior variants/full campaigns remain unverified by this slice.

Dragon/light-request review: Sonnet acceptse5491478, both static freshness checks pass;1793peer records preserved. Lever positions are a source-derived solution, not directly logged state; runtime win is1997/3342 plus ordered opens. RECOMP-18 records bounded clock/subsequence/fixture limits and producer/reload input hashes. No post-review code change.

## Real-clock headless menu completion, 2026-11-02 Pacific

Real-clock headless previously had no `rc_audio_render` consumer, so original Load's click-sound gate never finished despite delivered pointer messages. RECOMP-20 supplies a44100Hz/441-frame per10ms silent consumer, fixed deadlines and joined shutdown. The exact failed7-step input now loads genuine m46/reaches4120 with clean finish/exit0; default virtual passes the same bytes without a consumer. No original gate/status is bypassed. Candidate native74229ec8, unchanged24lifted objects, no Macapp change. Packet/root acceptance pin exact source/input and14real-run rebases; broader sync/media/failure branches remain unverified.


## First-time glyph win and glowstick, 2026-11-02 Pacific

Run `route_tools/glyph_live.py` with required native/source/atlas SHA pins; see GLYPH-LIVE.md. Source is final public PR307m28 f4ed2561 at3510/view4/held-1, Junior0, pending1418=1 and2001/1357=0. The client uses actual closed captures and17 observed pixel plans with250ms holds,500ms endpoint spacing and200ms swap gaps. Original1299 open/2001 win leads through1294/1295; click287,176 earns the glowstick at1945,1357=1 and1418=0. Preserve the six-second caption thumb scroll, Bye150,438, bag, actual4 at60,100, PUT/X and original UI save. The source clock gate is checked at entry; solving may legitimately advance beyond19:00.

Root actual full-scope run `glyph-public-root-fullscope-v1` yields m29 SHA8e78b53b96edc328391abb3fba92103889408c7f8fd261fc1d6f0f3d7da94678:234steps/34shots/finish27 in6.827s. Fresh clone starts with only m29, selects actual4 at134,243, PUT/X, two safe final observations:22steps/5shots/finish2 in2.382s. Both normal exits/failed0 and all protected inputs unchanged; maximum FLAGS line579bytes. Reload preserves the accepted prefix plus explicit center73000/shot76000. No generated continue-save appeared in this run; any authored continue output remains noncanonical. Junior first-time only; other boards/repeat/Senior and failure-I/O paths are unverified by this client. No ending claim.

## Lit word clue and Loulou prerequisites, 2026-11-02 Pacific

From public m29, use `story_route.py lit-word-clue --save m30`, `loulou-barber --save m31`, `loulou-morning --save m32`, `drake-magic --save m34`, then `loulou-answer --save m35`. Each run starts in a fresh data clone with only the preceding genuine UI save. Source-specific clock gates follow this chain, not a general NPC timetable. Use `route_load.sh` and the corresponding `check_route.py --route NAME`; the candidate handoff's compact scope is required, plus1514 for Drake/answer. Long morning idle needs MAX_IDLE_POLLS6000000/MAX_IMPORTS90000000; it advances original time normally.

Actual public save clocks are m31 at17:23 and m32 at08:23 (nearby logged frames17:24 and08:22..08:24);18M ordinary milliseconds (earlier13M shape shifted+5M after its first two tokens) reaches day3/08:23. Exact daytime replies150,421 earn1569 and1467; no separate m33 request. Drake scroll/replies earn1525/1526 and return through actual1092 to2332. Loulou1556→1557→1558 gives1465/1476/1774. All five UI saves reload successfully, including authored held4 at4389 and safe empty hands thereafter. No word-lock win is claimed. RECOMP-21 pins the five output hashes and all10run timings/steps; source/data/original remain unchanged. Original HICONTINUECHEAT is output only. Different clocks/dialogue variants and later puzzle completions are unverified by these narrow routes.

For these exact five routes, set RC_FLAGS to the following compact scope for the first three legs, then append`,1514` for Drake/answer. A different-clock m29 requires a different source gate and wait, rather than assuming this hour16 route is universal.

```sh
export RC_FLAGS='338-341,1160,1162-1174,1192,1259,1349,1357,1361,1388,1404-1405,1408,1418,1435-1436,1465,1467,1476,1494,1496,1498,1525-1526,1541,1562,1569,1573,1575,1597,1677,1682,1692,1701,1774,1782,1788,1791,1804,1818,1820,1823,1836,1844,1865,1892-1893,1906,1922,1925,1947,1958,1960-1961,1963,1966-1967,1969-1971,1977,1979-1981,1984-1985,1993-1994,1996-1997,1999-2002,2005,2015,2018-2019,2036-2037,2039-2042,2050,2058,2063,2069-2070,2077-2078,2092,2154,2156,2232'
```


## Replacement light and five word-lock stages, 2026-11-02 Pacific

From current public m35 use `story_route.py light-depletion --save m36`, then `paid-light-request --save m37`. The original light expires through3180/3181;1809rises first at3175,2041thenfalls,2042is transient. Used5 is physically selected before the paid request. Newsource day3/09:22 needs6Mordinarywait before the preserved first-paid150,418 topic; savedpending source is14:38,1418=1 with2001already1. Different source clocks/lists require new timing evidence.

`repeat_glyph_live.py` takes the same explicit native/source/atlas path+SHA arguments as glyph_live.py, with save-name m38 and a300second session bound. It refuses first-time/Senior/later-shape sources; the private atlas remains caller input. The new actual1299 open after3588, continuation1295,1949reward and original used5→fresh4 prove this round. Exact first-paid caption/Bye/inventory/save inputs are preserved. Root actual18plans/248steps and fresh22-stepreload both pass, source m38saved14:50. See packet/private scopes for complete RC_FLAGS; the CLI selects its exact union automatically.

Then `story_route.py word-lock --save m39`:87ordinaryleft wheel clicks solveLEECH*,BOOK**,BONNET,GLASS*,HILL**, producing original4376..4380→4387 and all1984/1967/1966/1977/2018/1979. New1972is deliberately unmet.372deliveredsteps and independentfreshreload pass; all public body strings match native runs exactly, no state/save/RNG writes. All4producer/reloadpairs and saved item4/5/13 fields are independently checked. First-paid Junior/current source only; natural failure, other boards/timings/inventory and later fire/endgame remain outside this slice.

For `light-depletion` and `paid-light-request`, use this complete scope; append`,1972` for `word-lock`. The repeat client sets its own exact scope.

```sh
export RC_FLAGS='338-341,1160,1162-1174,1192,1259,1349,1357,1361,1388,1404-1405,1408,1418,1435-1436,1465,1467,1476,1494,1496,1498,1525-1526,1541,1562,1569,1573,1575,1597,1677,1682,1692,1701,1774,1782,1788,1791,1804,1818,1820,1823,1836,1844,1865,1892-1893,1906,1922,1925,1947,1958,1960-1961,1963,1966-1967,1969-1971,1977,1979-1981,1984-1985,1993-1994,1996-1997,1999-2002,2005,2015,2018-2019,2036-2037,2039-2042,2050,2058,2063,2069-2070,2077-2078,2092,2154,2156,2232,1514,1809'
```

The6M wait is pinned to the observed09:22 save. Other09:xx sources can arrive in hour15 and be refused by the repeat client's hour14 gate; derive another ordinary wait for such sources.


## Right fire partial and crest prerequisites, 2026-11-02 Pacific

From public m39, run `story_route.py right-fire-panel --save m40`. This opens the right cover and uses the exercised three clicks; original3155→3126 additionally sets1150. Final1150/1154/1156/1157/1158 are1, remaining fire bits are0. It is a partial result, not1972/fullfire.

`ethel_live.py` takes the same native/game/source path and SHA arguments as the other input clients, no atlas, default save m41 and300second session bound. `ethel-start` exposes the111-event anchored body and rejects `--save`; the client sends the exact118-event load/prefix, curiosity150,421, visibleBye150,459 and originalUI save as four separate relative batches. Expected1406→1407→3428 is checked before collection. Actual automatic save is15:42; manual inspection had advanced a separate diagnostic fork into day4. No guessed absolute joining or clock setter is used. The client also runs a fresh save-only reload.

Then `story_route.py linda-curse --save m42` and `gargoyle-inspect --save m43`. Linda's1190/1191/1192 Bye set is original rand()%3, all returning4408.1492 is new,1925 retained,2154 clears legitimately. Gargoyle inspection earns1786/1783, returns3410 and leaves2014/1974 unearned. These source gates are day3/hour15 (actual source15:58 for gargoyle), not universal NPC schedules. The three static bodies match native runs exactly; each UI output passes an independent fresh reload. No key grant, unlock or ending claim.

Complete `right-fire-panel` scope:

```sh
export RC_FLAGS='338-341,1148-1160,1162-1174,1192,1259,1349,1357,1361,1388,1404-1405,1408,1418,1435-1436,1465,1467,1476,1492,1494,1496,1498,1514,1525-1526,1541,1562,1569,1573,1575,1597,1677,1682,1692,1701,1774,1782-1783,1786,1788,1791,1804,1808-1809,1818,1820,1823,1836,1844,1865,1892-1893,1906,1922,1925,1947,1958,1960-1961,1963,1966-1967,1969-1972,1974,1977,1979-1981,1984-1985,1993-1994,1996-1997,1999-2002,2005,2015,2018-2019,2036-2037,2039-2042,2050,2058-2060,2063,2069-2070,2077-2078,2092,2154,2156,2232'
```

Complete `linda-curse` scope:

```sh
export RC_FLAGS='338-341,1148-1160,1162-1174,1192,1259,1349,1357,1361,1388,1404-1405,1408,1418,1435-1436,1465,1467,1476,1492,1494,1496,1498,1514,1525-1526,1541,1562,1569,1573,1575,1597,1677,1682,1692,1701,1774,1782-1783,1786,1788,1791,1804,1808-1809,1818,1820,1823,1836,1844,1865,1892-1893,1906,1922,1925,1947,1958,1960-1961,1963,1966-1967,1969-1972,1974,1977,1979-1981,1984-1985,1993-1994,1996-1997,1999-2002,2005,2015,2018-2019,2036-2037,2039-2042,2050,2058-2060,2063,2069-2070,2077-2078,2092,2154,2156,2232'
```

Complete `gargoyle-inspect` scope:

```sh
export RC_FLAGS='338-341,1148-1160,1162-1174,1192,1259,1349,1357,1361,1388,1404-1405,1408,1418,1435-1436,1465,1467,1476,1492,1494,1496,1498,1514,1525-1526,1541,1562,1569,1573,1575,1597,1677,1682,1692,1701,1774,1782-1783,1786,1788,1791,1804,1808-1809,1818,1820,1823,1836,1844,1865,1892-1893,1906,1922,1925,1947,1958,1960-1961,1963,1966-1967,1969-1972,1974,1977,1979-1981,1984-1985,1993-1994,1996-1997,1999-2002,2005,2014-2015,2018-2019,2036-2037,2039-2042,2050,2058-2060,2063,2069-2070,2077-2078,2092,2154,2156,2232'
```

The Ethel client computes its complete scope automatically; it equals the right-fire/Linda scope above. The public clock contract is source day/hour plus valid monotone observations within each run, without source-to-first/reload minute equality. The packet records the exact saved and observed clocks for this proof.


## Corbin portrait and first-time typing crest, 2026-11-02 Pacific

`story_route.py corbin-portrait --save m45` goes directly from m43 through the first36library-walk events and unchanged49-event portrait/save body. No already-known family dialogue or intermediate m44 is needed. Actual1863 rises at2741,1935 is retained;92steps and fresh reload pass. Source is savedday3/16:14.

`typing_live.py` takes native/game/source path+SHA arguments and required caller geometry, OCR executable and eng.traineddata paths+SHA pins; see private candidate usage and RECOMP25. `typing-start` preserves the exact first-entry48-event prefix and rejects a save tail. It enters1340 with2088new1 and1687/2014still0, then reads captured pixels and sends ordinary120ms letterVKs. The original game owns score/timer/win. Actual12OCRplans/70keys earn2014 with an ordered1343 file open on first attempt, no abortX/m46.

Original4138 raw64 resets same-day03:15 after the win and clears1672; only that boundary is exempted from normal monotone clocks. Pick up2, examine through6200 and close to4114 without a PUT or held2 assumption. Actual m47saved03:17, crest2owned1,1687still0;203producersteps and19freshreloadsteps pass. Native b49 is a fresh peer314 build; portrait was on742. The2changed CRT helper bodies and unchanged4604body/registration proof are explicit in RECOMP26. Other layouts/fonts/Senior/retries and error paths remain unverified by this client.

Complete `corbin-portrait` scope:

```sh
export RC_FLAGS='338-341,1148-1160,1162-1174,1192,1259,1349,1357,1361,1388,1404-1405,1408,1418,1435-1436,1465,1467,1476,1492,1494,1496,1498,1514,1525-1526,1541,1562,1569,1573,1575,1597,1677,1682,1687,1692,1701,1774,1782-1783,1786,1788,1791,1804,1808-1809,1818,1820,1823,1836,1844,1863,1865,1892-1893,1906,1922,1925,1947,1958,1960-1961,1963,1966-1967,1969-1972,1974,1977,1979-1981,1984-1985,1993-1994,1996-1997,1999-2002,2005,2014-2015,2018-2019,2036-2037,2039-2042,2050,2058-2060,2063,2069-2070,2077-2078,2088,2092,2154,2156,2232'
```

The typing client computes its complete scoped union automatically. Geometry/OCR training assets are caller-owned local inputs and are never bundled.


## Oil, real crest gargoyle and rune passage, 2026-11-02 Pacific

`story_route.py oil-gargoyle --save m48` preserves the actual95event body from the first-time typing source, with1944earned only through1900/1902/1903/1904 and actual crest2 allowing R,R,L,R,L,L,R gargoyle turns. Final3416/held-1 has1974/1877;2062already belonged to source. Original UI m48/freshreload pass102/9steps. No held2 or PUT is invented.

`story_route.py rune-passage --save m49` preserves the59event body, actualheld4, six ordinary rune clicks and3194/3195win→3050. Source1809=0 rises on original3175raw-a1 flicker before3176changes2041/2042;1864/2081then2003are observed. The corrected checker retains this strict phase rather than removing the flag. Actual m49/freshreload pass66/9steps, safe3050/held4,day3/03:42. No replacement/Alchemy/fire win is claimed. Both full scopes, actual source/output hashes and clock/held-item readback are in RECOMP27.


## Post-rune used light and paid replacement, 2026-11-02 Pacific

`story_route.py rune-light-wait --save m50` preserves the old61event passage-exit/used5 prefix, then adds the source-correct12.9M ordinary wait and safe originalUI save. Current03:42 source reaches day3/14:36 at3335/held5. S3312 clears1514 during the earlier night traversal;3335waiting leaves it0. EffectiveBOOTBSUM+365still20,000ms despite its loose full-payload difference; Jane's effective3345gate is unchanged.91producer/9reloadsteps pass.

`repeat_glyph_live.py --context rune-passage --save-name m51` starts from genuine m50 and enters the paid board directly, with no abandoned pending game. Glyph/IO policy and default first-paid mode remain unchanged. Its exact sourcebagguard supports the later11item inventory: selectfresh4, reopenbag, empty134,310PUT/X. Reload uses206,243selection then134,310PUT. Actual17plans/new1299/1949/fresh4 win,287producer/22reloadsteps pass. UI m51safe3510/view4/held-1/day3/14:57,4owned1 and5/13zero. Source/input/output/atlas/scopes and accepted limits are in RECOMP28.

Long-wait replay settings: `MAX_IDLE_POLLS=4000000`, `MAX_IMPORTS=90000000`, and the complete `rune-light-wait` RC_FLAGS scope in RECOMP-28. Verify the static save with `check_route.py RUN_LOG M50.SAV --route rune-light-wait`; the completed client producer uses `--route rune-light-replacement` for M51.SAV and verifies its fresh reload separately.


## Fire to alchemy entrance, 2026-11-02 Pacific

The six named routes `fire-phosphorus`, `moving-room-entry`, `alchemy-snake-clue`, `nigel-library`, `nigel-snake`, `alchemy-return` continue actualm51throughgenuinem52..m57. Fullfire/real13, correct moving-room orientations,1922clue and actualNigel1371/1694 pass originalUI saves and independentfreshreloads. Newsource has no fire3312visit, so1514 stays0 until actualdaytimelibrarywalk; room2137 legitimately pulses within4300..4305 and clearsbeforeexit. Effective3036adds1875.

`nigel-library` removes only the old11Mwait, preserving othernavigation; currentUI m55saved15:46. `nigel-snake` uses the exercised source-matched Seniorquestion150,459/caption-scroll/Bye150,438 timing, with prechoice1300/new1371 verified. The oldJunior150,421 selects another currenttopic and is retained as a refused run. Final m57safe3046/held13/day3 16:20 has1694; noAlchemywin claimed. Use MAX_IMPORTS=90000000/MAX_IDLE_POLLS=300000, full one/zero union fromcheck_route.fire_alchemy_configuration plus338–341, --save m52..m57 and matching --route verifier. Exact source/output/input/scopes and bounded limits are in RECOMP29.
