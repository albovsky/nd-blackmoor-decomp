# M0 binary census and compiler-matching experiments

Prepared 2026-10-14 on the owner's Mac against the local `GAME.EXE` (SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`, 1,511,424 bytes, re-hashed here). This report checks the binary facts in the phased plan of 2026-10-14, runs the plan's Phase M0 census (E1, E2, part of E3) and the cheap matching experiments it asked for, and lists the findings that change the plan. Scripts and full result tables are in the private evidence tree at `work/analysis/m0/fable-census/`; nothing here reproduces original bytes.

## 1. Plan facts checked against the binary

| Plan statement | Result |
|---|---|
| Executable hash and size | Confirmed. |
| PE linker version 6.0 | Confirmed. Image base 0x400000, entry 0x50e7e5 (in the CRT region), subsystem GUI, PE checksum field 0, link timestamp 2007-05-02 20:35:40 UTC. |
| Rich header carries build 8168 | Confirmed and sharpened. The Rich checksum recomputes to the stored key, so the header is unmodified and must be regenerated exactly in Phase M1. Full tuple list in section 2. |
| 4,188 functions in `function-index.json` | Confirmed as starts. The spans between consecutive starts sum to exactly the `.text` virtual size (1,213,018 bytes); a span is not a proven function end, since it also holds the function's switch tables and `int 3` padding (section 3 and 5 separate those). A fresh Ghidra 12.1.4 headless run finds 4,210 functions; the 22 extra are 6-byte stubs that fall inside existing extents. Every `push ebp; mov ebp, esp` start that follows a function terminator is already in the index. |
| 398 matched bytes, hand assembly only | Confirmed from `CURRENT-INTEGRATION.md` and the S08 reports. |
| "Do not rely on Ghidra Function ID, which does not cover VC6" | Confirmed empirically. The local install does ship `vsOlder_x86.fidbf`, but a full headless run with Function ID tagged only 86 of 4,210 functions, 83 of them in the CRT/MFC region (5,451 bytes, 5.2% of that region) and 3 false positives inside game code. Function ID cannot produce the library census; address regions and string references can. |
| Vorbis is a linked library | Confirmed. The middle region references the strings `vorbis` and `OggS`. |
| Docs drift (Luna Max, 330/332 and 216 test counts, stale census, dirty progress map) | Confirmed. `slice-registry.json` has `worker_model: gpt-6-luna`, `reasoning_effort: max`; 86 files under `outputs/blackmoor-decomp/` mention Luna; README line 5 says 330 of 332 and line 148 says 216; `action-census-current.json` says 10,501 opaque while `status.json` says 8,523. |
| 13-variant Clang matrix matched none of six getters | Confirmed from the S08-2 packet and manifests. |

## 2. E1: Rich header tuples

Twelve tuples, 870 objects in total. Product names use the community RichPE mapping and are inferences, not a recovered manifest.

| prodid | Tool | Build | Objects | Reading |
|---:|---|---:|---:|---|
| 10 | Utc12_C | 8168 | 161 | VC6 RTM C compiler (`cl` 12.00.8168): CRT and other C objects |
| 11 | Utc12_CPP | 8168 | 182 | VC6 RTM C++ compiler: game code and static MFC 4.2 objects |
| 10 | Utc12_C | 8966 | 21 | A later VC6 C compiler build. Count fits libvorbis plus libogg (about 23 source files), which is C and optimized; the game's own code is C++ and unoptimized |
| 14 | Masm613 | 7299 | 44 | MASM 6.13 objects, the CRT's assembly files |
| 1 | Import0 | 0 | 423 | Import-library members (Win32 SDK libraries) |
| 25 | Implib700 | 9466 / 9210 | 2 + 5 | Import-library members built with a VC7-era `lib.exe`, consistent with the `binkw32.lib` import library |
| 19 | Linker512 | 8034 | 16 | Objects that passed through a 5.12 linker, a shipped library |
| 12 | AliasObj60 | 7291 | 2 | `oldnames`-style alias objects |
| 29 | Utc13_CPP | 9178 | 1 | One pre-release VC7 C++ object from a shipped library |
| 6 | Cvtres500 | 1720 | 1 | The resource object |
| 0 | Unknown | 0 | 12 | Unattributed |

Reading: the Rich header counts objects; it does not place them in the address space, so it cannot prove per object which compiler produced which function. The strongest inference it supports is this: the game code is C++ (thiscall receivers, `push -1` exception frames), and the only C++ tuples are 182 Utc12_CPP 8168 objects and one Utc13_CPP 9178 object, with 12 further objects unattributed. At most 13 game objects could therefore come from anything other than `cl` 12.00.8168, and the unoptimized code style in section 4 is uniform across all 2,507 game functions. Treat "VC6 RTM `/Od`" as a working hypothesis that every later match test checks function by function, not as a recovered build manifest. There is no linker tuple; the PE header's 6.0 is the only linker evidence.

## 3. E2: code classes by bytes

Region boundaries come from prologue style, x87 density and referenced strings; they are exact to within a few hundred bytes.

| Class | Address range | Functions | Bytes (extents) | Share of `.text` |
|---|---|---:|---:|---:|
| Game code (C++, unoptimized) | 0x401000 to 0x4fcef0 | 2,507 | 1,031,920 | 85.1% |
| libvorbis and libogg (C, optimized) | 0x4fcef0 to 0x50bf50 | 178 | 61,536 | 5.1% |
| Static CRT and MFC 4.2 (`AfxWnd42s` class names, `Microsoft Visual C++ Runtime Library`, SEH and unwind helpers) | 0x50bf50 to 0x52925a | 1,503 | 119,562 | 9.9% |
| of which import thunks | | 22 | 126 | |
| Non-code inside `.text` | | | 2,205 bytes of `int 3` padding, 173 switch jump tables with about 8,707 bytes of table data | 0.9% |

The library share is about 15% of code. Decision 1(b) in the plan (reference library bytes instead of reconstructing them) therefore removes only 181 KB of a 1.21 MB problem. The cost of Track M is the 1.03 MB of game code.

Game code size distribution: median 108 bytes, mean 412. The largest 161 functions (1,490 bytes and up) hold 50% of game bytes; the largest 476 (506 bytes and up) hold 75%; 94 functions above 2,048 bytes hold 38.8%. 396 functions fall in the plan's 300 to 800 byte E3 range.

## 4. Compiler findings that change the plan

**The game code was compiled without optimization.** All 2,507 game functions open with `push ebp; mov ebp, esp`, followed by `push ecx` (1,149), `sub esp, imm8` (1,037), `sub esp, imm32` (94), `push -1` SEH frames (158), `push reg` (8) or another instruction (61). The receiver is always spilled to `[ebp-4]` and reloaded before every use; conditionals compile to the `jne +2; jmp target` pair; there is no register allocation across statements. No `/GZ` stack fills or `__chkesp` calls are present, so this is a release `/Od` build, not a debug build. The CRT and MFC objects are the optimized shipped libraries; Vorbis is optimized C. The 88 game functions that looked frame-less in the earlier linear-sweep census all disappear once disassembly restarts at each function start; they were desynchronization after jump tables.

**Why this matters.** Unoptimized VC6-style output is a near-direct function of the source statement sequence, and any lowering built on it is validated byte by byte per function, so the exact compiler build matters less than the code-generation style, which is observed directly. 100 instruction shapes cover 94.7% of the 266,737 game instructions, 200 cover 98.7%. A compiler that reproduces this output does not exist on the Mac, and Clang at `-O0` lays out frames differently (the sibling session's experiment compiled 157 small functions from Ghidra pseudocode and got 3 normalized-instruction-stream matches with a mean sequence similarity of 0.50; the S08-2 and S08-3 matrices gave zero exact functions). But the regularity makes a project-owned lowering from reconstructed C++ to VC6-style `/Od` x86 a bounded engineering task rather than a research one, and it makes tool-assisted assembly recovery very reliable (next section).

## 5. E3 (mechanical half): GNU assembler round trip over the whole `.text`

Method: disassemble `.text` with Xcode's `llvm-objdump` resynchronized at every indexed function, re-emit each instruction as Intel-syntax GNU assembly pinned to its original offset, assemble with the project's pinned `i686-w64-mingw32-as` 2.43.1, and compare bytes. Two modes: naive (plain mnemonics) and hinted (encoding hints derived from the original: `{load}`/`{store}` for register-register forms, `.d8`/`.d32` branch sizes, `{disp8}`/`{disp32}`).

| Mode | Code bytes compared | Exact | Fully exact functions (game / vorbis / CRT-MFC) |
|---|---:|---:|---|
| Naive | 1,205,254 | 96.43% | 0 / 18 / 730 of 2,507 / 178 / 1,503 |
| Hinted, mnemonics only | 1,205,254 | 99.89% | 2,319 / 178 / 1,487 |
| Hinted plus `.insn` spellings | 1,205,254 | 100.000% | 2,507 / 178 / 1,500 |

Hints used in the final run: `{load}` 20,688 times (including `xchg` operand order), `.d8` 22,075, `.d32` 7,947, `{store}` 34, `{disp8}` 37, `{disp32}` 4, and `.insn` 376 times. The dominant naive failure is the compiler's load-form choice for `mov reg, reg` and ALU `reg, reg` (10,656 `mov ebp, esp` alone), which is exactly the `{load}` issue the S08-2 slice hit by hand.

With mnemonics and the four hint kinds alone, 1,300 bytes in 331 instructions remained, all encoding choices the compiler made that GNU as cannot be told to make with ordinary mnemonics. Each has a `.insn` spelling that reproduces the bytes (all tested against the assembler and then applied in the census):

| Class | Instructions | Spelling |
|---|---:|---|
| 16-bit accumulator immediates encoded as `66 05/0D/25/2D/3D imm16` where `as` picks the `83` sign-extended form | 290 | `.insn 0x66, 0x05, imm{:u16}` (and `0x0d`, `0x25`, `0x2d`, `0x3d`) |
| `add eax, 0` encoded as `05 imm32` where `as` picks `83 C0 00` | 1 | `.insn 0x05, imm{:u32}` |
| `fadd st(0), st` encoded with the `DC C0` form | 24 | `.insn 0xdc, 0xc0` |
| `81 /x` word operations with `imm16` where `as` picks `imm8` | 16 | `.insn 0x6681/7, dword ptr [ebp - 0x1a], imm{:s16}` or `.insn 0x6681/7, ecx, imm{:s16}` (the `0x66` prefix is written into the opcode value; a 16-bit register name would add a second prefix) |
| `xchg ah, al` register order | 1 | `{load} xchg ah, al` |

Four byte runs (11 bytes) could not be rendered by the disassembler at all; they decode to invalid opcodes inside function spans and are table data that the span heuristic did not catch, which is also why three CRT/MFC spans are not reported as fully exact.

Conclusion: with the pinned assembler, four hint kinds and the five `.insn` spellings above, every code byte of the executable is expressed as mnemonic assembly that reassembles exactly, with zero relocations in the object. The mechanical side of Track M is solved and measured, not assumed. The throughput question in the plan is therefore entirely about authoring policy, not tooling.

## 6. Findings that change the plan

1. **Reframe decision 1.** The plan's options were assembly-only, referenced library bytes, or obtaining VC6. The census shows the library share is only 15%, so option (b) barely helps, and the round trip shows hand-authored assembly is mechanically feasible for 100% of code but humanly infeasible at the demonstrated rate (398 bytes in four slices against 1,205,254 code bytes). Two options should be added and ruled on:
   - (d) **Tool-assisted assembly with review.** Generate the hinted assembly from the original per function, then require a human-readable annotated version (labels, structure, stack-frame symbols) and an independent review before the function counts. This conflicts with the current S08 packet rule against "automatic disassembly copying" and needs an explicit owner ruling. It is the only path that finishes Track M in bounded time.
   - (e) **Project-owned VC6 `/Od` lowering.** Reconstruct game functions as C++ (Track N already does this) and build a deterministic lowering that emits VC6-style unoptimized x86, validated function by function against the original. Section 4 shows the output is regular enough. This keeps "source reconstruction" meaningful and lets one C++ source serve both tracks. It is a real compiler-backend project; (d) can run first and provide the ground truth corpus for it.
   Owner ruling (2026-10-14, project thread): option (d) adopted; the mini-compiler (e) stays optional. Packets M02 and M03 implement it.
   The S08-2 Clang matrix should not be extended: no available compiler emits VC6 frame layout, and the question is settled.
2. **Fix the matching toolchain rules now.** Every M3 batch must use the pinned GNU as 2.43.1 with the four hint kinds and the five `.insn` spellings listed in section 5; no other byte directives are needed or allowed in code. The verifier should reject objects that rely on Xcode's integrated assembler, which cannot emit the load forms.
3. **M1 and M2 scope is now concrete.** The composer must place 173 switch jump tables (about 8,707 bytes) and 2,205 bytes of `int 3` padding as data, regenerate the Rich header with its checksum, set the 2007-05-02 timestamp, keep the PE checksum at zero, and reproduce the four sections (`.text` 0x1000/0x12825a, `.rdata` 0x12a000/0xc5f4, `.data` 0x137000/0x10713c with 1,077,564 virtual against 208,896 raw bytes, `.rsrc` 0x23f000/0x66e0). The import directory is 0x118 bytes at RVA 0x134910 with an IAT of 0x54c bytes.
4. **Function ID is out.** Keep the plan's instruction, with the evidence above. Library boundaries come from regions and strings.
5. **The sibling session's census files are sound but one label in them is misleading.** `work/analysis/m0/idiom_census.json` reports 88 frame-less game functions; all 88 are disassembly desync after jump tables, not optimized code. Its region boundaries and Rich tuples agree with this report.
6. **Track N gets a free asset.** Because game code is `/Od`, Ghidra pseudocode for it is unusually faithful to the original statement order and local-variable set. Reconstruction packets can state recovered source with higher confidence than for optimized code, and the per-function instruction count is a usable complexity estimate.

## 7. What was not done

- No human-authored reconstruction of a 300 to 800 byte function was timed; the mechanical round trip replaces that measurement for feasibility but not for the policy cost of hand authoring.
- No composer (E4) was built.
- Region boundaries were not refined to the byte; the three classes may each be off by a few functions at the seams.
- The exact `cl` build behind Rich tuple 8966 was not identified.
- No GUI or hardware audio check was run; the Mac remains treated as locked for that purpose.
