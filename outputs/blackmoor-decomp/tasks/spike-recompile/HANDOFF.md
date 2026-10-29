# Handoff: recompiled GAME.EXE on the real game data (2026-10-28, 9:30 PM PDT)

Written by the Fable thread when Glib asked it to stop hands-on work. A Sonnet thread continues from here.

## Where things stand

The lifted program (see README.md) now runs against the GOG data and has passed both spike markers:

- First data-file read: `Ciftree\CIFTREE.DAT`, then PROMOTREE.DAT, BOOT.CIF, the six .CAL files, FONT.CIF, NANCY.CID,
  display.drv, FRAME.CIF, UISHARED_OVL.CIF, UICONVOPOPUP_OVL.CIF, HER_LOGO_SPLASH.CIF, HDSound\ndsig.his, Click01.his.
- First window: `CreateWindowExA("Nancy Drew: The Curse of Blackmoor Manor", 1024x768)`, then the game goes
  full-screen through DirectDraw (`SetCooperativeLevel`, `SetDisplayMode 640x480x16`), creates the primary surface and a
  system-memory work surface, decodes the UI images (about 250 million memory reads in 3 s) and starts loading sounds.

Last stop (`run.log`): `call to 0x00000000` in 0x4f5f69 (sound buffer creation) called from 0x4f3c26 / 0x4f379c /
0x4fadc4 / 0x4fc62d (HDSound path) / 0x4fc077 / 0x4dc182 / 0x426148 / 0x4272b2. The null pointer is the game's
IDirectSound object at `this+0x194`: the game calls `DirectSoundEnumerateA` (DSOUND ordinal 2) and the shim answers
with one device, but it never calls `DirectSoundCreate` (ordinal 1) afterwards, so the object stays null. Most likely
the enumeration callback (0x4fa8d2) wants a non-null GUID, or the device must be picked through a second path. Read
0x4fa8d2 and the caller of 0x4f5f69 (unverified-pseudocode/4f5f69.c.txt) and make the shim satisfy them. The
IDirectSound / IDirectSoundBuffer shims in driver.py are already written (silent device, lockable buffers, play cursor
on the virtual clock).

Numbers of the last run: 114,041 native calls, 79 emulated calls (19 refused bodies), 2,600 import calls, 3.5 s.

## How to run it

```
# game data: Glib copied the GOG folder to ~/Projects/nd-blackmoor-decomp/work/gamedata on the Mac (gitignored);
# in the cloud, the staged bundles were unpacked into gamedir/ (Ciftree, CDSound, Game.ini, Nancy.cid, display.drv).
# CDVideo (318 MB of .bik) did not transfer yet; Bink is a binary DLL anyway, so video is shimmed, not decoded.
cd outputs/blackmoor-decomp/tasks/spike-recompile
pip install pefile capstone unicorn
./build.sh                 # lift (3 min compile) + boot; or: python3 -I driver.py  once libspike.so exists
```

GAME.EXE must be at `work/original/GAME.EXE` (from /mnt/project-files/private-inputs/work-private.tar.gz) or `$GAME_EXE`.
`run.log` has every import, file open, window message and COM call; the `RESULT` line at the end is the summary.
`frames/frameNNN.ppm` will hold screenshots once the game calls `Flip` (frame_dump in driver.py).

## Shim inventory (driver.py)

- Win32: heap, TLS, critical sections, files on `gamedir/` (case-insensitive, writes allowed), INI, PE resources and
  version info, CBT hook so MFC attaches and subclasses its windows, window table with GWL_* longs, message queue with
  PostMessage / Peek / Get / Dispatch, timers on a virtual clock (+5 ms per empty poll; `GetTickCount` adds it), rect
  helpers, cursor counter.
- DirectDraw 7: enumeration, one device, display modes, surfaces as 16-bit RGB565 buffers in host memory
  (`SURF_BASE`), Lock/Unlock, Blt (color fill, color-key, stretch), BltFast, Flip (swaps buffers and dumps a frame),
  SetSurfaceDesc (client memory), clipper and palette stubs.
- DirectSound: silent device (see above). Bink: `_BinkDDSurfaceType` says 565; `_BinkOpen` is not shimmed yet.

## Next steps, in order

1. Make DirectSound creation happen (above), rerun, chase the next stop. Expect Bink next: shim `_BinkOpen@8` to
   return 0 and check how the game handles a failed movie (HER_LOGO_SPLASH is a static image, LOGO may be a .bik).
2. Get to the first `Flip`: that produces `frames/frame001.ppm`, the first real screenshot of the recompiled game.
   Convert with `python3 -c "from PIL import Image; Image.open('frames/frame001.ppm').save('frame001.png')"`.
3. Then the message loop: feed a mouse click (`WM_LBUTTONDOWN` / `WM_LBUTTONUP` at 320,240) after the logo timer so
   the menu appears; the logo controllers leave after 4,000 ms of virtual time or a click.
4. Only after frames appear: hand-port the 19 refused CRT helpers (lift_census.json `refused`) to drop Unicorn, and
   decide how the lifted body replaces the hand-written Mac app's modules.

Rules that still hold: never write GAME.EXE; no rm; Unicorn is scaffold and oracle only; game data stays out of git.
