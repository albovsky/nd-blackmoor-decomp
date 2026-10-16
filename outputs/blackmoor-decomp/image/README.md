# image/: structured description of GAME.EXE

Sources for the M02 whole-file composer (`scripts/compose_image.py`). Nothing here is an original code, data or resource byte dump: the files hold PE field values, import names and hints, resource tree shape, switch-table targets and hashes. The only literal bytes are the 14-byte standard Microsoft linker DOS stub in `layout.json` (boilerplate in every LINK-produced PE).

| File | Content | Class produced |
|---|---|---|
| `layout.json` | DOS header, Rich tuples (key recomputed, not stored), PE/optional header, data directories, section table, code regions, zero fill | structured: `dos_header`, `rich_header`, `pe_headers`, `section_table`, `header_padding`, `section_padding` |
| `imports.json` | 13 DLLs, 326 symbols with hints and RVAs | structured: `import_directory`, `iat` |
| `resources.json` | ID-only resource directory tree (38 leaves), leaf RVA/size/codepage, zero fill | structured: `resource_tree`; leaf payloads are `referenced` |
| `text_data.json` | switch jump tables (code addresses), 0xCC span padding; byte index tables by extent only | structured: `jump_tables`, `int3_padding`; index table bytes are bound from the audited `.s` data items (reconstructed data) |
| `reconstructed.json` | reviewed matching manifests (`bindings`) and the audited tool-assisted assembly batches of M03 (`asm_batches`) bound as reconstructed ranges | reconstructed (provenance classes reported separately) |
| `ranges.json` | every remaining range: offset, length, SHA-256, kind, region, name | referenced |
| `coverage-report.{json,md}` | snapshot of the composer's report | |

`ranges.json`, `text_data.json`, `layout.json`, `imports.json` and `resources.json` are produced by `compose_image.py derive` from the local original and `function-index.json`; `reconstructed.json` is hand-written; `ranges.json` is re-derived after any change to it. A test re-runs `derive` and requires byte-identical output.

## Commands

```bash
python3 outputs/blackmoor-decomp/scripts/compose_image.py build     # compose, require the whole-file SHA-256
python3 outputs/blackmoor-decomp/scripts/compose_image.py stages    # enable structured groups one at a time, re-check the hash
python3 outputs/blackmoor-decomp/scripts/report_image_coverage.py   # the Track M progress number
python3 -m unittest outputs/blackmoor-decomp/tests/test_compose_image.py
```

The composed file and the full report are written under `outputs/blackmoor-decomp/build/image/` (git-ignored).

## Tool-assisted assembly batches (`asm_batches`)

Each entry names an `asm/batch-NNN.json` manifest and its audit report. At build time the composer requires the report to be all-accepted for exactly that manifest (hash match), reassembles every function's `.s` with the pinned `i686-w64-mingw32-as` 2.43.1 (version line plus the self-test of `audit_tool_assisted.py`), requires zero relocations, and requires the symbol's bytes to hash to the code SHA-256 the manifest records for the original code part. The bytes placed in the image are the assembled bytes. Bindings listed under `bindings` win on overlap, so the 11 S08 functions and the 2 incomplete C ranges stay in their own classes and are reported as superseded. Data items of these functions: switch tables and `int 3` padding are already `structured` and skipped; the audited index tables (`IDXTAB_<va>`) and the alignment padding that no structured group generates are bound as reconstructed data in their own provenance classes (`tool_assisted_reconstructed_index_table`, `tool_assisted_reconstructed_padding`), reassembled and hash-checked like the code, never counted as functions or code bytes (the 1,464 padding bytes were typed code in `ranges.json` before, so the code total fell from 1,203,014 to 1,201,550 bytes and about 0.12 points of the rise in the reconstructed code fraction are the smaller denominator, not new coverage; the "functions" count includes the 554 derived entries, which are exactly reproduced code, not proven functions). `asm/batch-009.json` holds the derived entries (code the span split found that `function-index.json` does not list). The 12 functions the audit excludes (CRT block copies, fall-through, noreturn funclets) and 10 derived entries of the same two kinds stay `referenced` (22 code ranges, 1,619 bytes).

## Replacing a referenced range

1. Add the reviewed object (M03 `tool_assisted_reconstructed_assembly` or a hand-reviewed `explicit_reconstructed_assembly_source`) and bind its manifest in `reconstructed.json`.
2. Remove the covered bytes from `ranges.json` (re-run `derive`, which carves bound ranges out of the referenced list).
3. `compose_image.py build` must still print the original SHA-256; `report_image_coverage.py` shows the new generated/referenced split.

The composer rejects overlapping ranges (a function and a data item claiming one byte), missing bytes, and a referenced range whose SHA-256 differs from the description.
