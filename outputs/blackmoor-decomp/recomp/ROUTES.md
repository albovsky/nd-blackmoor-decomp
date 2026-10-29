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

Cursors in the room views: an up/down arrow is a move, a magnifying glass an examine, a small ring a hotspot with an action. Typing: the headless harness
sends `WM_KEYDOWN`/`WM_KEYUP` only (`TranslateMessage` makes no `WM_CHAR`), so a text field that waits for characters would not get them; typing into one has
not been exercised yet (the search box was not reached).

Compared with the Python oracle (same anchored script, 2026-10-29): the phone home screen, the online options screen and the browser's intro page are
pixel-identical (0 differing pixels each). The save, load, menu, journal, window-seat and moon-panel scenes were looked at on the native build only.

Not reached: the first puzzle chain (it needs items found beyond the room), the credits screen from the in-game menu.
