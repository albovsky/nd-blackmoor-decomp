# Decomp progress view

A playable-build panel followed by a decomp.dev-style view of how much of `GAME.EXE` is reconstructed: a code bar, a data bar and a treemap of units sized by bytes (green matched code, blue hatched matched data, grey not done). Open `index.html` in any browser; it is one offline file with no network access.

This is separate from `../progress-map/` (the older function-start map with oracle and quarantine panels). Nothing in that directory is read or changed.

## Files

| File | Role |
|---|---|
| `generate.py` | Builds everything below from committed evidence. Standard library only. |
| `playable.py` | Validates playable evidence and derives parser/live-handler coverage from committed source. |
| `../playable-status.json` | Schema-versioned, sanitized live-session evidence and committed test totals. |
| `../scripts/record_playable_status.py` | Refreshes live evidence using the native app; raw logs stay private. |
| `layout.json` | Public structural facts: sections, code regions, data pieces. Sums to 1,511,424 bytes. |
| `template.html` | Page source (treemap, bars, table view, search, light and dark themes). |
| `progress.json` | Generated model: totals, groups, units, per-function tuples `[va, span, matched_code, matched_data]` (matched total = the last two summed; a span can hold both when a ledger classifies jump tables or padding inside it). |
| `REPORT.md` | Generated text report. |
| `index.html` | Generated page with the model embedded. |
| `preview.png` | Headless page export, refreshed with `--preview-browser`. |
| `test_progress.py` | `python3 -m unittest test_progress` from this directory. |

Refresh after any new match manifest or ledger:

    python3 outputs/blackmoor-decomp/decomp-progress/generate.py

For a preview export, append `--preview-browser PATH/TO/CHROMIUM` (a Chromium or chrome-headless-shell executable). It renders a 1440 × 1200 light-theme PNG without opening a desktop window. The default generator needs only Python's standard library; the optional preview export needs an installed browser. While the owner's Mac is locked, export the artifact without computer-use or visual inspection.

## Playable build evidence

After merging runtime work, build and record the pinned scripted run:

    outputs/blackmoor-decomp/scripts/build_native_app.sh
    python3 outputs/blackmoor-decomp/scripts/record_playable_status.py
    python3 outputs/blackmoor-decomp/decomp-progress/generate.py

The recorder invokes `--inspect-live-session --live-click-row 34 --live-ticks 3000`, with the app's default read-only game location or an explicit `--game-dir`. This uses offline audio and opens no game window or output device. Build immediately before recording: the JSON pins the executable SHA-256 and checkout commit, but the recorder does not prove that an arbitrary supplied executable was built from that commit. Raw process/session logs stay under `work/analysis/slices/PROG-1-live-*/`; public evidence includes only scene identifiers, row/type/provider identifiers, a bounded stop reason, counts and provenance hashes. No raw log lines, resource names, payloads or original bytes are copied.

`playable-status.json` has the pinned schema `blackmoor-playable-status/1`: `evidence` (kind, source commit, native hash, command), `reached_scenes`, `stop`, `ticks`, `tests`, and `next_blocker`. Its strict validator rejects extra fields. There are no timestamps. `--seed` can reproduce the packet's committed integration snapshot when the game is unavailable; it marks evidence as seeded, leaves the native hash unavailable, and uses zero ticks to indicate no measured tick count. A failed or incomplete live run leaves previous public evidence intact.

The log parser reads four events. Only `scene_transition_applied` adds a successful target. `scene_session_blocked` records a provider stop. `scene_transition_error` preserves the source scene and failed target, including the target's failing action row. `live_session_end` supplies the tick count and final status; its scene or stale action fields cannot replace a preceding transition failure. Reached scenes are unique, in first-visit order. Tests come from `status.json` `current_integration.full_suite` when present, otherwise `tests`; the generator rejects a stale copy of those totals.

The committed live evidence reaches S0 → S5900 → S5907 → S5901–S5906 (9 / 2,078 scenes) and stops replacing S5906 with S4700: row 3, opaque `0x35`, provider `scene-resource`. The committed suite has 774 discovered, 769 passed and 5 skipped tests. This panel does not rerun that full suite.

Action coverage is derived by `playable.py`, rather than maintained as a handwritten handled list:

- Corpus scene and per-type record counts come from `action-census-current.json` (2,078 scenes, 19,612 records). Its stored 9,111 typed / 10,501 opaque split predates current parser registrations. Apply the `known_body_length` cases in `src/scene_resource.c` to those per-type counts: currently 23 typed families / 17,920 records and 48 opaque families / 1,692 records. This source-based projection assumes the corpus records satisfy each registered layout; it does not reparse original resources.
- Built-ins come from `scene_executor.c`: core type dispatch (cross-checked with `action_core.c`), dispatched scene/clock branches, and hotspot types with the raw `0x15` → runtime `0x0d` mapping. The dependency-only `0x9f` reset is excluded from built-in coverage.
- Session UI handlers come from the installed callback/present slots in `scene_session.c`. External handlers come from the binding array installed by `create_native_scene_session` in `blackmoor_app.mm`, resolving type constants through headers and confirming callback definitions in the app or `session_bindings_*.c`. Diagnostic-only app handlers and unwired modules are excluded.
- Live binding slots/counts and reserved types are cross-checked. Changed syntax that cannot be recognized fails generation. The union currently contains 14 families / 7,997 records. The other 9 typed families / 9,923 records are unsupported by the live session; these include `0x37`, `0x97` and `0xa1`. Typed `0x97` is no longer an opaque S4700 blocker.

“Native handler” means a live dispatch path exists for the family. Branches, providers, dependencies and media may still block individual records, including handled families. It is not a count of fully playable records. Input source hashes and the actual registration sets are included in `progress.json`. Tests compare the committed generated sets/hashes with fresh derivation and exercise changed registrations, missing slots and new parser layouts, so stale generated coverage fails verification.

Run the public-only acceptance tests:

    python3 -m unittest discover -s outputs/blackmoor-decomp/decomp-progress -p test_progress.py
    python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p test_record_playable_status.py

## Evidence and what counts as matched

Baseline mode (default) uses the manifests `matches.json`, `matches_s08_2_x86.json`, `matches_s08_3_x86.json` and `matches_s08_4_x86.json`, merged by byte range, and cross-checks the result against `status.json` `unique_matched_bytes`. `matches_s08.json` (C candidate, 62 differing bytes) and `matches_s08_2.json` (C++ comparison) are excluded on purpose. Each manifest is pinned by SHA-256 in `progress.json`.

By default the manifests are trusted, and the page and report say so. For a verified refresh pass `--verify-original PATH/TO/GAME.EXE`: the generator then runs `scripts/verify_matches.py` on every counted manifest and refuses to produce output unless each is exact. The object files live in the gitignored `build/`, so point `--verify-root` at the checkout that holds them (the manifests there must be byte-identical to the evidence copies). The committed outputs were generated this way. A verified run also checks that each assembly manifest's committed source and verified object hash to the reviewed values recorded in `status.json` (`source_sha256`, `object_sha256`), so an edited source or a swapped object is rejected; `matches.json` has no recorded hashes and is reported as unbound. A fresh reassembly with the pinned assembler is not rerun here; the slice audits (`scripts/audit_matching_s08_*_x86.py`) own that.

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

No claim of original C++ or compiler provenance, whole-file rebuild, complete native gameplay or hardware input/audio verification. Sub-function structure of data pieces is not recorded. No history over time.
