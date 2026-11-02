# Scripted routes on the native recompiled build

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

Audio review follow-up: normal Cmd-Q is now routed back through main's producer/capture cleanup, and a5-second watchdog reports stuck shutdown as failure5. Capture-start failure is3, capture-finalization failure4. Actual app/Cmd-Q checks still await background mode; the unverified filesystem/streaming branches are listed in RECOMP-05.
