# Handoff: recompiled GAME.EXE on the real game data (updated 2026-10-28, 10:35 PM PDT)

The lifted program (README.md) now runs the real game: main menu, the Player Challenge screen, and the first scene
(the Nancy Drew intro postcard with its narration text). Screenshots were attached to the Blackmoor project thread; game
art stays out of git.

## How to run it

```
cd outputs/blackmoor-decomp/tasks/spike-recompile
pip install pefile capstone unicorn pillow           # and ffmpeg/ffprobe on PATH (Bink movies)
# GAME.EXE at work/original/GAME.EXE (or $GAME_EXE); GOG data under gamedir/ (Ciftree, CDSound, CDVideo, Game.ini, Nancy.cid, display.drv)
./build.sh                                           # lift + compile (3 min) + boot; later runs: python3 -I driver.py
INPUT="9000:click:290,46;12000:move:450,262;13000:click:450,262,1500" MAX_IMPORTS=1500000 python3 -I driver.py
```

`INPUT` is `virtual_ms:move|click|key:x,y[,hold_ms]` separated by `;` (key takes a virtual-key code). Virtual time advances 5 ms per
empty message poll and 1 ms per `GetTickCount`. `run.log` has every import, file open and window message; `frames/frameNNN.ppm` are
primary-surface pictures after the 1st, 300th, 3000th ... blit and `frame001.ppm` is the last picture at the end of the run.
Debug switches: `FORCE_UC=va,lo-hi` runs those lifted functions on the emulator instead (bisecting a lifter bug), `WATCH_VA=hex`
prints calls and returns (with x87 top), `WATCH_EAX=hex` prints which functions return a value, `WATCH_ADDR=hex` prints writes,
`DUMP=addr:words` dumps memory after the run.

## What was fixed on the way (all runtime issues, not game bugs)

- Calls through a register or pointer (qsort comparators, Vorbis function tables): the lifter guessed that the callee pops what the caller
  pushed; the spike takes the callee's own `ret N` from its final esp (`FL41_ICALL`).
- The x87 stack is one machine-wide state: a callee reads the caller's operands (`__ftol`, `pow`) and leaves its result on the stack; the
  lifter's per-call `fpush(fret)`/`fpop` is removed and the stack is handed to and from the emulator for refused bodies.
- `fiadd/fisub/fimul/fidiv` are lifted in the spike script (four more functions); a derived part that runs into its jump table is cut where the table starts.
- DirectSound: enumeration needs a non-null GUID device; 3D buffer, 3D listener and notify interfaces have their own vtables; events and waits work.
- Bink: `ffmpeg` decodes the .bik files to RGB565; `BinkOpen/DoFrame/CopyToBuffer/Goto/GetSummary` are shimmed. No Bink audio.
- The game polls `GetAsyncKeyState(VK_LBUTTON)` and `GetCursorPos` as well as taking messages; scripted clicks do both.

## Where it stops now

The route below runs the whole opening on the recompiled game: menu, New Game, Junior Detective, the intro cutscenes (about 36 Bink
movies, scenes S5900 to S4808 and the narration), Nancy's guest room (S2010), turn to the suitcase (S2009), zoom in (S2016) and open the
latch (S2017: the suitcase opens). That takes about 190 s of wall time and 109 s of virtual time.

```
INPUT="9000:click:290,46;12000:move:450,262;13000:click:450,262,1500;S2010.CIF+4000:move:460,272;S2010.CIF+5000:click:460,272,400;S2009.CIF+4000:move:250,262;S2009.CIF+5000:click:250,262,400;S2016.CIF+3000:move:335,322;S2016.CIF+4000:click:335,322,400;S2016.CIF+9000:shot:0,0" MAX_IMPORTS=3000000 python3 -I driver.py
```

Input times are virtual ms, or `FILE.EXT+ms` (that long after the game first opened that file); `shot` writes `frames/frame1NN.ppm`.
Fixes in this round: DirectSound notify events are signalled on the virtual clock (narration ends, scenes advance), and the heap
frees and reuses blocks (the long run used to exhaust it).

## Next steps

1. Script more of the first puzzle chain (phone message, notebook, items in the suitcase) and look for scenes that crash.
2. Hand-port the 19 refused CRT helpers (`lift_census.json`) to drop Unicorn (about 700 fallback calls per run).
3. Speed: about 190 s wall for 109 s of virtual time; the 36 M native calls are dominated by the game's own image decode and busy-wait loops.
4. Decide how the lifted body joins the Mac app: link `all_lifted.c` behind a host interface (memory, DirectDraw/DirectSound/Bink on the app's
   renderer and audio) and replace the hand-written modules subsystem by subsystem, or ship the lifted program as the game core.

Rules that still hold: never write GAME.EXE; no rm; Unicorn is scaffold and oracle only; game data stays out of git.
