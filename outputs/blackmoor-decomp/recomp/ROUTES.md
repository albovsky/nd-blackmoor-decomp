# Scripted routes on the native recompiled build

Headless runs of `rc_headless` (see `rc_headless.c`) with the deterministic virtual clock. A route is the `INPUT` string:
`time:kind:args` steps separated by `;`, `kind` = `move`, `click` (args `x,y[,hold_ms]`), `key` (args: virtual-key code) or `shot` (a picture of the
primary surface, `frames/frame1NN.ppm`). `time` is virtual ms, or `FILE.EXT+ms`: that long after the game first opened that file. Steps that share an anchor
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
The puzzle itself was not solved. The `.AVF` puzzle video needs `CreateFileMappingA`/`MapViewOfFile`, which the host now provides (read-only copies).

## The moon box and the library nook (same start, `S2011` hops)

`T:10,200` three times, `c:303,170` (S2011), then the hops S2011 row 4 (`338,272`) to S2038 (the cube on the chair: it turns when its edges are clicked), S2038
rows 3, 6, 9, 12, 15 (`528,165`, `106,169`, `255,223`, `376,221`, `322,65`: turns and the dragon face, S2041; the lock plate with a half moon, S2042 and S2047),
row 18 (`310,354`) back to S2011, S2011 row 5 (`121,222`) to Newton's cradle S2019 and S2019 row 3 (`327,183`) to S2186. All of it renders and reacts.

Not reached: the solution of the stair lock or the moon box (both need a combination that has to be found in the story), the credits screen from the in-game menu.
