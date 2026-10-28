# FL-77 packet: clearing a pending Mac-port row with hand-built scenarios

Goal for one row ROW (a function VA such as 0x452576): make every instruction and both directions of every conditional jump run on the ORIGINAL x86 bytes under Unicorn (scenario = seed + list of memory overrides), with the committed translation equal to the original on every scenario. Directions that are impossible by construction (for example `mov ecx,1; test ecx,ecx; je`) are NOT yours: note them and leave the row `partial`; the prover thread (FL-75) takes it.

Work from `/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp` (the original is already extracted at `/home/user/nd-blackmoor-decomp/work/original/GAME.EXE`). Scratch files go in the scratchpad directory you are given, final scenario files in `tasks/fl77/out/ROW.json`. Do NOT run git, do NOT edit anything outside `tasks/fl77/` and your scratchpad (tool fixes: copy the tool into `tasks/fl77/` first), never type rm, no chained commands, never `pkill -f`. Do not run the full test suite. Do not run `fl66_tested.py merge`.

## Loop

1. Baseline: `python3 tasks/fl76/un.py ROW OUT.json [more.json..]` prints `ROW instr_covered total dirs_taken dirs_total kept` and the untaken list (`41d34dT` = jump at 41d34d never taken, `F` = never fell through). Baselines for your rows are in `tasks/fl77/base/ROW.json` (scenario file) and `tasks/fl77/base/ROW.txt` (untaken list).
2. See what is missing: `python3 tasks/fl76/miss.py ROW files..` (missing instruction addresses). Read the code: `python3 tasks/fl73/tools/disx.py 0xADDR 0xLEN` (disassembly), `python3 tasks/fl74/ctx.py FUNC JUMP N` (N instructions before a jump). Find the gate that hides the missing code (a compare, a jump table index, a count > 0).
3. Craft the state that opens the gate with the tools below, always passing the previous best file so earlier coverage is kept. Each tool prints `new ...` lines when it adds coverage and writes a merged scenario file (`OUT`) of only the coverage adders.
4. When the coverage is full except impossible directions, or full: `FL66_EARLY=1 python3 scripts/fl66_tested.py check ROW --redo --prove --scen OUT.json` (prints `ROW tested_equivalent [i,i] [d,d]` on success). `partial` with only impossible directions left: report the row id, the file and the untaken list.

## Tools (all take ROW OUT first, then optional scenario files)

- `tasks/fl76/thiscombo.py ROW OUT 'EXPR' [files]`: set cells relative to a register at a pc. EXPR is a python list of combos, a combo is a list of `(path, size, value)`; path `[-0x9c, 0x793]` means `[[ebp-0x9c]+0x793]` (every offset but the last is dereferenced as a dword). Env `PC=0x..` hook that pc instead of the entry, `REG=ebp|ecx|edx|esp` (default ecx = `this` at entry), `ARG=n`. At the function entry `REG=esp` the n-th dword argument is `[0x4*n]` (return address at 0, first argument at 4, so `[ebp+0x14]` is `[0x10]`). Stack addresses are fixed per row, so cells on the stack work as overrides.
- `tasks/fl73/tools/gsweep.py ROW OUT 'ADDR:size:v1,v2;ADDR:size:v..' [files]`: every combination of the listed global cells (absolute addresses, size 1/2/4) on every scenario.
- `tasks/fl76/stubset.py ROW OUT "SPEC" [files]`: SPEC is a python list of steps: `('g', addr, size, val)` global cell; `('ret', callpc, slot, val)` the first hit of `call` at callpc returns val in slot 0=eax 1=ecx 2=edx; `('wr', callpc, target, val)` that callee also stores the dword val at target (target an int or `('ebp', -0x150)` = register + offset at the call); `('retn'/'wrn', callpc, nth, ...)` the nth hit. Env `KEEP=1` keeps scenarios' existing stub overrides (you nearly always want it), `ALL=1` keeps every scenario that ran the steps, `DEBUG=1`. A step whose call is not reached stops the remaining steps of that scenario.
- `tasks/fl76/cpset.py ROW OUT PC N [files]`: at a `repe cmpsb` at PC copy the N bytes at edi onto esi so the compare is equal (`SKIP=k` for the k-th hit).
- `tasks/fl76/pset.py`, `tasks/fl76/lastpc.py ROW SEED 'OVLIST'` (prints the fault and the last pcs), `tasks/fl76/dif.py`, `tasks/fl76/combo.py`, `tasks/fl73/tools/{craft,cmpeq,bigstr,grid,onehot,stubret,wrat,insp}.py`, `tasks/fl74/{rd,eqv,allret,fillptr,srcset,addscen,why}.py` (each file's first lines say what it does).

## Facts that cost time

- Every callee is a recording stub: its eax/ecx/edx are random per seed, and with probability 0.4 per pointer argument (first three) it writes 1..32 random bytes at that pointer. So a buffer filled by a callee (fread, strcpy) is random in its first 32 bytes; cells beyond that are plain memory and overrides on them hold. A stub result you need is set with `ret`/`wr` (stubset), not with a cell override.
- A cell the function writes itself before reading it cannot be set by an override; a cell read twice with a callee in between needs a callee store (`wr`) between the reads.
- A scenario that faults (unmapped pointer read, instruction limit) is DROPPED by every tool, silently. If a crafted state adds nothing, check `lastpc.py` for a fault: usually a pointer cell (a `[this+0x577]` table) must point to mapped memory. Mapped regions start at `this`-style addresses (0x20000000.. in the seeds), use a pointer value taken from a working scenario.
- `this` (ecx) differs by seed: always address fields relative to the register at a hook, never by absolute address. Global/data addresses (0x5xxxxx, 0x63a4cd) are absolute.
- A pointer that you set to an image address (>= 0x500000) breaks size>1 overrides there (original and translation then disagree): move such a table pointer into ordinary memory first (`pset.py`).
- Values: keep any single override under ~4,000 decimal digits (JSON int limit); a 40 KB string is 40 overrides of 1000 bytes.
- Switch statements: read the jump table from the image (`disx.rd(table + 4*i, 4)`), find which selector reaches which case, set the selector at its read pc.
- Check the result file is never empty before using it as the next input.
- Time box: if a row has had 45 minutes with no new coverage, stop and report what blocks it (gate address, what you tried). Do not run anything for more than ~10 minutes in the foreground (use background runs and read the output file).

Report back (short): per row `ROW status instr dirs`, the final scenario file path, and for unfinished rows the untaken list plus the blocker.
