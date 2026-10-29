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

After the postcard the game waits for the narration sound to finish. The silent DirectSound shim never signals the notify events
(`IDirectSoundNotify_SetNotificationPositions` stores them), so the scene does not advance and the harness ends at "message loop idle".

## Next steps

1. Signal the stored notify events as the virtual clock passes each buffer position (or end of buffer), so narration finishes and the game
   moves on to the next scene. Then script the first puzzle route to check scene changes.
2. Hand-port the 19 refused CRT helpers (`lift_census.json`) to drop Unicorn (about 600 fallback calls per run, almost all `memcpy`/`strcmp`).
3. Decide how the lifted body joins the Mac app: link `all_lifted.c` behind a host interface (memory, DirectDraw/DirectSound/Bink on the app's
   renderer and audio) and replace the hand-written modules subsystem by subsystem, or ship the lifted program as the game core.

Rules that still hold: never write GAME.EXE; no rm; Unicorn is scaffold and oracle only; game data stays out of git.
