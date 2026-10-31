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

`route_tools/story_route.py` writes the `INPUT` strings of four legs that chain through the game's own saves. Run a leg from the save it starts at (the Load & Save list
is ordered by the game, not by name, and a new save reshuffles it: `route_load.sh` takes the row's y, so look at the list, rows are 42.5 px apart from y = 105):

| Leg | From | Does | Ends (with `--save NAME`) |
| --- | --- | --- | --- |
| `stairs` | `m0` (bedroom right after the suitcase) | up to S3395 (see "Bedroom to the stair lock"), the piano, S3396/S3397, key 17 from S3398 | S3397, key 17 owned |
| `lock` | S3397 | down the hall to S3448, the key shows the lock is stuck, back to the bedroom, the intercom order, S3350/S4400 (delivery), the tray, butter 25, back to the lock | S3447 |
| `slider` | S3447 | the slider puzzle S3450 (105 moves), the compartment S3452/S3453 (item 6), S3455 cancel strip, S3457 | S3303 |
| `moon` | S3303 | the library nook S2011, the moon box S2038, its five dials, the lens | S2076 |

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

### After the moon box (S2074 to S2014), looked at on the native build only

From S2076 the lens is taken in S2074 (click its hotspot `326,177`; the S2075 scene around it takes bottom-strip clicks `310,352` to leave), then S2040, S2011, S2010.
Six right turns (`630,200`, hold 150) from the nook exit face the telescope table; `528,272` in the view with the tripod opens S2014 (the tripod, "Hmmm. A tripod.").
With the lens (toolbox slot 0, `62,100`) picked up, a click at `310,190` on the tripod head left a small cap on its left arm that the view did not show before
(pictures only; the scene's own flag was not read, so this is not claimed as the solved step). Not yet tried: the star chart S2015 and the telescope S2078.

## Debug switches of rc_headless

* `shot` steps write `frames/shotNNN.ppm` from 1; the numbered flip dumps stay `frameNNN.ppm`.
* `SCRIPT_TAIL_MS` (default 5000, 0 = never): stop that long after the last step, so a route does not run on to the idle limit.
* `RC_FLAGS="1000-1030,1716"`: at every shot, log the non-zero event flags in those ranges (the game's table at 0x585801 + 4 * n).
* `RC_TRACE_MS=from-to`: log every import call (name, arguments, result) in that range of virtual milliseconds.
* Long routes need `MAX_IDLE_POLLS` and `MAX_IMPORTS` raised (the 105-move slider run uses 900000 and 90000000).
