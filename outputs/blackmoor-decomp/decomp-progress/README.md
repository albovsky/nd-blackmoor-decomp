# Decomp progress view

A decomp.dev-style view of how much of `GAME.EXE` is reconstructed: a code bar, a data bar and a treemap of units sized by bytes (green matched code, blue hatched matched data, grey not done). Open `index.html` in any browser; it is one offline file with no network access.

This is separate from `../progress-map/` (the older function-start map with oracle and quarantine panels). Nothing in that directory is read or changed.

## Files

| File | Role |
|---|---|
| `generate.py` | Builds everything below from committed evidence. Standard library only. |
| `layout.json` | Public structural facts: sections, code regions, data pieces. Sums to 1,511,424 bytes. |
| `template.html` | Page source (treemap, bars, table view, search, light and dark themes). |
| `progress.json` | Generated model: totals, groups, units, per-function `[va, span, matched]`. |
| `REPORT.md` | Generated text report. |
| `index.html` | Generated page with the model embedded. |
| `preview.png` | Screenshot of the page at the time of generation. |
| `test_progress.py` | `python3 -m unittest test_progress` from this directory. |

Refresh after any new match manifest or ledger:

    python3 outputs/blackmoor-decomp/decomp-progress/generate.py

## Evidence and what counts as matched

Baseline mode (default) uses the manifests `matches.json`, `matches_s08_2_x86.json`, `matches_s08_3_x86.json` and `matches_s08_4_x86.json`, merged by byte range, and cross-checks the result against `status.json` `unique_matched_bytes`. `matches_s08.json` (C candidate, 62 differing bytes) and `matches_s08_2.json` (C++ comparison) are excluded on purpose. Each manifest is pinned by SHA-256 in `progress.json`.

By default the manifests are trusted, and the page and report say so. For a verified refresh pass `--verify-original PATH/TO/GAME.EXE`: the generator then runs `scripts/verify_matches.py` on every counted manifest and refuses to produce output unless each is exact. The object files live in the gitignored `build/`, so point `--verify-root` at the checkout that holds them (the manifests there must be byte-identical to the evidence copies). The committed outputs were generated this way.

Today that gives 398 matched code bytes (11 whole functions plus two 7-byte partial ranges), 0 matched data bytes, and 398 of 1,511,424 file bytes.

Denominators in baseline mode: code is the sum of indexed function spans (start to next start, last span to the end of `.text`), which also contains jump tables and `int 3` padding (about 10.9 KB, M0 report section 3). Data is every other file byte. Both are approximations until the ledger below exists.

Units: code units are 16 KiB address bands inside the three M0 regions (game, Vorbis and Ogg, CRT and MFC); data units are the image pieces in `layout.json`. They stand in for translation units. `--band-kib` changes the band size.

## Range ledger contract (for the M02 composer)

M02 had not landed when this was written, and its coverage report format is not fixed. `generate.py --ledger FILE` therefore consumes this small neutral format, which M02's `report_image_coverage.py` can emit directly or through a short adapter:

    {
      "schema": "blackmoor-range-ledger/1",
      "original_sha256": "afd337a2...5c45",
      "file_size": 1511424,
      "ranges": [
        {"offset": 0,    "size": 4096, "kind": "data", "class": "structured", "provenance": "image_structure"},
        {"offset": 4096, "size": 17,   "kind": "code", "class": "reconstructed", "provenance": "explicit_reconstructed_assembly_source"},
        {"offset": 4113, "size": 99,   "kind": "code", "class": "referenced"}
      ]
    }

Offsets are file offsets. `kind` is `code` or `data` (jump tables and `int 3` padding inside `.text` are `data`). `class` is `structured`, `reconstructed` or `referenced`, the packet's three classes. Every `structured` or `reconstructed` range must carry a `provenance` (lowercase identifier such as `explicit_reconstructed_assembly_source`, `tool_assisted_reconstructed_assembly` or `image_structure`); the page and report count matched bytes per provenance and the tool rejects a matched range without one. The ledger must tile the whole file without overlap; a `missing` range is rejected, and a gap is rejected unless `--allow-partial-ledger` is given (the gap is then reported as unclassified).

A ledger is a claim, not proof. Pass `--verify-image COMPOSED.EXE` (the composer's output image): the run fails unless its SHA-256 equals the pinned `GAME.EXE` hash, and the report and page say whether that check ran. Without it the output states that the ledger was not tied to a composed image. A partial ledger keeps every unit's full extent; bytes it does not cover render as not done and are counted as unclassified.

Accounting: `reconstructed` and `structured` bytes are matched, in the bar for their `kind`; `referenced` bytes are not done. Totals and unit denominators then come from the ledger itself, so code and data denominators become exact and the matched-data bar starts moving. Units stay the same bands and pieces, so the treemap does not change shape.

## Not covered

No claim of original C++ or compiler provenance. No whole-file rebuild or gameplay result. Sub-function structure of data pieces is not recorded. No history over time.
