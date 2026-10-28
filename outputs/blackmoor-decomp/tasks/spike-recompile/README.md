# Static-recompilation spike (approved 2026-10-28)

Question the owner approved on 2026-10-28: can the ledger's lifted C run the whole of GAME.EXE as one program,
instead of one function at a time in the test harness? The two finish-line markers were the first `CreateWindow`
and the first scene-file read, starting from the PE entry point.

## Result

The booted program runs natively from the entry point (0x50e7e5) through the CRT start-up, MFC static
initialisation, `CWinApp::InitInstance`, the game's own INI loader (0x4348b0) and the save-folder set-up (0x435015),
and stops at the game's first data-file open:

```
CreateFileA("C:\GAME\Ciftree\CIFTREE.DAT")  ->  "Unable to open CAL or CIF TREE file ... Check the path in your .ini file"
```

That is the second marker. The first marker (`CreateWindowExA`) was not reached, because the game checks its data
before it creates its window. The run needs the GOG data folder (CIFTREE.DAT and the rest), which is not in the
repository; the stand-in folder `gamedir/` only holds a GAME.INI.

| Measure (last run, 2026-10-28) | Value |
| --- | --- |
| Ledger functions lifted to C | 4,169 of 4,188 (19 refused: four x87 integer ops, several jump-table bodies the lifter cannot bound, one `std`) |
| Native calls into lifted code | 3,695 |
| Calls that fell back to the Unicorn emulator | 79, of which 37 go to three CRT helpers the lifter refused (0x50fa90, 0x5130f0, 0x5129a0) |
| Win32 imports called | 1,211 calls over 76 distinct functions, all answered by the Python shim |
| Wall time to the first data-file open | under 0.1 s |

By call count the boot is 98% native; the emulator only covers the 19 refused bodies and a few mid-function
entry points.

## What the spike is made of

| File | Role |
| --- | --- |
| `lift_all.py` | Lifts every ledger entry with `scripts/lift_fl41.py` in bulk mode, rewrites tail jumps to `FL41_TAILJMP`, adds entry aliases for calls that land inside a function, writes `all_lifted.c/.h` and `lift_census.json`. |
| `spike_macros.h` | `FL41_TAILJMP`: a tail jump becomes a host call that then returns to the jumper's caller. |
| `fl57_helpers.h` | The x87 helper block the lifted code expects (copied from the FL57 translation unit). |
| `host.c` | Flat 32-bit address space in host memory (page table), the native call dispatcher over the lifted functions, fault and fallback hooks into Python, `host_run` with a long-jump abort. |
| `driver.py` | Loads GAME.EXE into that space, lays out stack, TIB, heap and import stubs, registers the lifted functions, plays Win32 imports (about 200 shims: heap, TLS, files on a stand-in folder, INI, resources, version info, GDI/USER stubs, DirectDraw and DirectSound flags), and falls back to Unicorn on the same memory for unlifted bodies. Prints a RESULT line and writes `run.log`. |
| `gamedir/GAME.INI` | Stand-in INI. Put the GOG data folder's files next to it to go further (Ciftree/, HDVideo/, HDSound/ ...). |
| `build.sh` | Lift, compile (about three minutes for the 400k-line C file), link and boot. |

The emulator is a scaffold for the refused bodies and an oracle, not the game's implementation; the owner's
no-VM rule stays in force. GAME.EXE is read, never written.

## What broke on the way, and what that says about the lifted code

- Tail jumps: the per-function lifter models `jmp target` as a call followed by a return, which is right in the
  test harness but wrong when the target is another function's middle. `FL41_TAILJMP` and entry aliases fix this.
- Mid-function entry points: the ledger's `derived_parts` are targets of direct calls; 6 of them are inside lifted
  bodies and got aliases. The rest are handled by the emulator.
- Import argument counts: the lifter only knows the stack clean-up for imports it saw called from lifted code;
  49 imports needed a hand table (`ARGS` in `driver.py`).
- Every other stop was a missing or too-simple Win32 answer, not a lifting error: the MFC hook must succeed,
  version resources must come from the PE, the Documents folder must be creatable, or the game's own path
  builder (`_makepath` with the output buffer doubling as the directory argument) loops forever. In every case
  the lifted code did what the x86 does.

## Next steps

1. Add the GOG data folder (owner's Mac) under `gamedir/` and re-run to the first `CreateWindowExA`, then to the
   first scene load. The DirectDraw and DirectSound COM objects need real shims at that point.
2. Replace the emulator for the 19 refused bodies by hand ports (they are small CRT helpers) so the boot is 100%
   native, then drop the Unicorn dependency.
3. Decide how this joins the Mac app: either the app links `all_lifted.c` behind the same host interface, or the
   lifted functions replace the app's hand-written modules one subsystem at a time with the harness as the oracle.

## How to run

```
cd outputs/blackmoor-decomp/tasks/spike-recompile
pip install pefile capstone unicorn
./build.sh            # lift + compile + link + boot; RESULT line at the end, details in run.log
```
