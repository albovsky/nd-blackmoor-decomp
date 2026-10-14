# M02: whole-file skeleton and image composer

Root assigns this child of S08 to a `slice-implementer` (Sonnet high) or Codex `gpt-6.1-sol` xhigh worker. State: READY, unclaimed. Baseline: the collected `main` at assignment time. Read `AGENTS.md` (Track M ruling), `PROJECT-SPEC.md`, `WORK-SLICES.md`, `M0-binary-census-report.md` and `scripts/verify_matches.py` first. Work in an isolated worktree with the canonical private `work/` linked; claim M02 before editing.

## Outcome

A reproducible composer builds a complete 1,511,424-byte PE image from structured source plus explicitly referenced ranges, reports every byte of the file by class, and proves the whole-file SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` when all code and data ranges are referenced. From then on each reviewed function or data item replaces a referenced range, and the composer's report is the single Track M progress number.

## Ownership

Own only new files: `outputs/blackmoor-decomp/image/` (layout, import, Rich, resource and data descriptions), `outputs/blackmoor-decomp/scripts/compose_image.py`, `outputs/blackmoor-decomp/scripts/report_image_coverage.py`, `outputs/blackmoor-decomp/tests/test_compose_image.py`, and private `work/analysis/slices/M02.*`. Existing matching sources, manifests, verifier, function index, engine and app files are read-only. Original bytes are never committed: referenced ranges are described by offset, length and SHA-256 and copied from the owner's local `GAME.EXE` at build time only. Resource payloads (icons, bitmaps, version info) are described structurally in `image/`; their binary payloads live privately under `work/` and are referenced by hash until reconstructed.

## Facts the skeleton must reproduce (verified 2026-10-14)

- PE32, machine 0x14c, four sections, section alignment 0x1000, file alignment 0x1000, image size 0x246000, headers 0x1000, entry point RVA 0x10e7e5, image base 0x400000, subsystem 2 (GUI), PE checksum field 0, linker version 6.0, OS and subsystem versions 4.0, link timestamp 1178138140 (2007-05-02 20:35:40 UTC).
- Sections: `.text` RVA 0x1000, virtual 0x12825a, raw 0x129000 at file 0x1000, flags 0x60000020; `.rdata` RVA 0x12a000, virtual 0xc5f4, raw 0xd000 at 0x12a000, flags 0x40000040; `.data` RVA 0x137000, virtual 0x10713c, raw 0x33000 at 0x137000, flags 0xc0000040; `.rsrc` RVA 0x23f000, virtual 0x66e0, raw 0x7000 at 0x16a000, flags 0x40000040.
- Data directories: import RVA 0x134910 size 0x118, IAT RVA 0x12a000 size 0x54c, resource RVA 0x23f000 size 0x66e0; no relocations, no debug directory.
- DOS stub text "This program cannot be run in DOS mode." with `DanS` at 0x80 and `Rich` at 0xf0; twelve Rich tuples as tabulated in the M0 report; the Rich XOR key equals the recomputed checksum, so the composer must compute it, not store it.
- Inside `.text`: 173 switch jump tables (about 8,707 bytes) and 2,205 bytes of `int 3` padding are data items, not code; code is partitioned by the 4,188 function extents of `function-index.json`.
- Import order, hint values and name strings must reproduce the original import directory and IAT exactly; the DLL set and symbol lists are in `work/analysis/m0/imports.json`.

## Range classes

Every byte of the image belongs to exactly one range with one class:

- `structured`: produced from `image/` descriptions (headers, section table, Rich header, import directory and IAT, resource directory tree, padding).
- `reconstructed`: assembled from reviewed `explicit_reconstructed_assembly_source` objects already in the repository (the 398-byte baseline) or from `tool_assisted_reconstructed_assembly` objects accepted through M03.
- `referenced`: copied from the local original at build time by offset, length and SHA-256. Reported, never counted as matched.
- `missing`: not yet described; the composer fails if any byte is missing.

## Steps

- [ ] Write the `image/` descriptions and the composer; build the file with every code and data range referenced and confirm the whole-file SHA-256.
- [ ] Replace the headers, section table, Rich header, import directory, IAT, resource directory tree, jump tables and `int 3` padding with `structured` generation one group at a time, re-confirming the hash after each group.
- [ ] Bind the existing reviewed matching objects (`matches*.json`, S08-2/3/4 x86 objects) as `reconstructed` ranges through `verify_matches.py` semantics; re-confirm the hash.
- [ ] Emit the coverage report: bytes and ranges per class, per section and per code region (game, Vorbis, CRT/MFC), plus the list of referenced ranges with hashes. The progress map (M01) consumes this report later; do not edit the map.
- [ ] Tests: header and Rich checksum regeneration, section table, import directory and IAT byte equality against the original (compared in memory from the local file, never stored), jump-table and padding placement, rejection of overlapping or missing ranges, rejection of a referenced range whose hash does not match, and a mutant that flips one byte of a structured item and must fail the whole-file hash.
- [ ] Hand off: commands, report, source and object hashes, the exact list of what is still `referenced`, and a request for independent review.

## Acceptance

`compose_image.py` reproduces the original SHA-256 from the committed `image/` sources plus the referenced-range list; all `structured` groups listed above are generated, not referenced; the coverage report states referenced bytes separately and claims no match for them; tests pass; no original bytes appear in tracked files. This packet does not finish Track M: it makes its remaining work countable.
