# S08-2: six complete thiscall accessors

## Goal and evidence classes

This slice combines two separate kinds of evidence for six small accessor functions. `matching_s08.c` and `matching_s08_2.cpp` preserve the recovered memory behavior as semantic source. `matching_s08_2_x86.s` is an explicitly human-reconstructed x86 assembly lowering that now matches the six complete original function ranges exactly. The assembly match does not establish the original C source, original compiler, or whole-executable rebuild.

## Ownership

- `outputs/blackmoor-decomp/src/matching_s08.c` is the pre-existing semantic C source and remains unchanged.
- `outputs/blackmoor-decomp/src/matching_s08_2.cpp` is the C++ member-method semantic candidate.
- `outputs/blackmoor-decomp/src/matching_s08_2_x86.s` is the human-reconstructed x86 lowering.
- `matches_s08_2.json`, `matches_s08_2_x86.json`, the S08-2 build/audit/bootstrap scripts, tests, and this packet are owned by this slice.
- Existing manifests, verifier, function index, central build, parser, app, and engine files remain read-only.
- Private reports are written only to `work/analysis/slices/S08-2.*`.

## Original bounds and ABI

The immutable original is pinned to SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (1,511,424 bytes). Each function's extent is the distance to the next Ghidra-indexed function start, and every interval decodes contiguously through its terminal `ret`.

| Function VA | Bytes | Recovered behavior | ABI evidence |
|---|---:|---|---|
| `0x4dae66` | 17 | Read `this + 0x18` | ECX receiver, EAX result, plain `ret` |
| `0x4dae77` | 17 | Read `this + 0x1c` | ECX receiver, EAX result, plain `ret` |
| `0x4daef1` | 17 | Read `this + 0x0c` | ECX receiver, EAX result, plain `ret` |
| `0x4daf02` | 22 | Write argument to `this + 0x0c` | ECX receiver, argument at `[ebp+8]`, `ret 4` |
| `0x4daf18` | 17 | Read `this + 0x10` | ECX receiver, EAX result, plain `ret` |
| `0x4daf29` | 22 | Write argument to `this + 0x10` | ECX receiver, argument at `[ebp+8]`, `ret 4` |

The complete extents total 112 bytes. The isolated x86 oracle confirms getter stack delta 4 bytes including the return address, setter stack delta 8 bytes including the return address and callee-cleaned argument, and restoration of EBP.

## Exact assembly result

The six assembly functions match all 112 original bytes: 6/6 exact ranges, zero mismatching offsets, zero rejected ranges. The audit checks the adjacent Ghidra extents, complete original and candidate disassembly, contiguous object symbol layout, no padding or extra code, terminal return instructions, and setter cleanup.

The source uses GNU assembler's `{load}` pseudo-prefix to select the load-form encoding for the register-to-register frame moves. Xcode LLVM's integrated assembler and Apple cctools `as` both rejected this prefix and emitted the other valid MOV encoding. GNU documents `{load}` as preferring the load-form instruction in its [i386 mnemonic documentation](https://www.sourceware.org/binutils/docs-2.35/as/i386-Mnemonics.html).

The pinned assembler is GNU Binutils 2.43.1, built privately for `i686-w64-mingw32` from the official sourceware release archive. The archive SHA-512 is `20977ad17729141a2c26d358628f44a0944b84dcfefdec2ba029c2d02f40dfc41cc91c0631044560d2bd6f9a51e1f15846b4b311befbe14f1239f14ff7d57824`. The bootstrap installs only `i686-w64-mingw32-as` beneath `work/tools`; it does not modify global packages or configuration.

To reproduce the private assembler build, place the official `binutils-2.43.1.tar.xz` at `work/tools/s08-binutils-2.43.1/binutils-2.43.1.tar.xz`, verify it with the pinned checksum, then run:

```sh
bash outputs/blackmoor-decomp/scripts/bootstrap_matching_s08_2_gas.sh
```

Then rebuild and audit the exact ranges:

```sh
bash outputs/blackmoor-decomp/scripts/build_matching_s08_2_x86.sh work/original/GAME.EXE
work/tools/oracle-python/bin/python outputs/blackmoor-decomp/tests/matching_s08_2_x86_oracle.py \
  --original work/original/GAME.EXE \
  --report work/analysis/slices/S08-2-x86-oracle.json
PYTHONDONTWRITEBYTECODE=1 python3 outputs/blackmoor-decomp/tests/test_matching_s08_2_x86.py -v
```

The x86 tests run the assembled COFF function bodies in Unicorn with real ECX receiver values, setter stack arguments, EAX return checks, EBP restoration, and stack-cleanup checks. They compare 42 candidate/original/native-C cases and show that an assembled wrong-field mutant and cdecl getter/setter mutants fail. Additional source mutants for missing or short functions, extra instructions, alignment, gaps, a missing terminal `ret`, and wrong setter cleanup are rejected by the object audit.

## Semantic source and compiler constraints

Apple Clang 21 at `i686-pc-windows-msvc -O0` builds the semantic C baseline but differs at 62 positions across all six complete ranges. C++ member methods differ at 66 positions. The 13-variant matrix covers C and C++ optimization modes, MS compatibility flags, and the GNU Windows target triple; none emits all six exact complete ranges. The report retains exact mismatch offsets, per-function hashes, toolchain identity, flags, and original-range disassembly, but no machine-byte values.

The six native ARM64 semantic-C functions agree with the original isolated x86 leaves across 18 cases. The separate assembled x86 oracle agrees with both original x86 and native semantic C across 42 cases. Wrong-field and cdecl mutants demonstrate that the fixtures distinguish field offsets and thiscall behavior rather than merely accepting any leaf body.

The earlier 14-byte `initial_functions` ranges remain range-only and completeness-unproven; this slice does not upgrade them. The PE reports linker version 6.0, but the Rich-header tuples have not been mapped to a compiler release. Original C source, source field/class names, original compiler version and flags, linker settings, CRT/import/thunk boundaries, globals, and whole-PE reconstruction remain unverified. The owner has no VC6 installer; do not ask for one.

This slice proves a bounded six-function assembly match, not original-toolchain-generated C and not whole-file x86 matching. It does not prove native gameplay completion.
