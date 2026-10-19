# Decomp progress view

A playable-build panel, a function-ledger panel and a decomp.dev-style view of how much of `GAME.EXE` is reconstructed: a code bar, a data bar and a treemap of units sized by bytes (green matched code, blue hatched matched data, grey not done). Open `index.html` in any browser; it is one offline file with no network access.

This is separate from `../progress-map/` (the older function-start map with oracle and quarantine panels). Nothing in that directory is read or changed.

## Files

| File | Role |
|---|---|
| `generate.py` | Builds everything below from committed evidence. Standard library only. |
| `playable.py` | Validates playable evidence and derives parser/live-handler coverage from committed source. |
| `../playable-status.json` | Schema-versioned, sanitized live-session evidence and committed test totals. |
| `../scripts/record_playable_status.py` | Refreshes live evidence using the native app; raw logs stay private. |
| `function_ledger.py` | Function-ledger derivation and strict validator (FL-1), loaded by `generate.py` like `playable.py`. |
| `../function-ledger.json` | Committed function ledger (`blackmoor-function-ledger/1`): one status per function; built by `../scripts/build_function_ledger.py --write`. |
| `layout.json` | Public structural facts: sections, code regions, data pieces. Sums to 1,511,424 bytes. |
| `template.html` | Page source (treemap, bars, table view, search, light and dark themes). |
| `progress.json` | Generated model (including the compact `function_ledger` panel when a ledger exists): totals, groups, units, per-function tuples `[va, span, matched_code, matched_data]`, provenance byte/function counts and pinned audit inputs. A complete audited function's code plus audited tables/padding must fill its indexed span; only code adds matched code bytes. |
| `REPORT.md` | Generated text report. |
| `index.html` | Generated page with the model embedded. |
| `preview.png` | Headless page export, refreshed with `--preview-browser`. |
| `test_progress.py` | `python3 -m unittest test_progress` from this directory. |

Refresh after any new reviewed match manifest, audited/reviewed M03 batch or ledger:

    python3 outputs/blackmoor-decomp/decomp-progress/generate.py

Always refresh `preview.png` with the rest (a stale screenshot contradicts the page): on this Mac `~/Library/Caches/ms-playwright/chromium_headless_shell-1243/chrome-headless-shell-mac-arm64/chrome-headless-shell` works, while headless Brave hangs. For a preview export, append `--preview-browser PATH/TO/CHROMIUM` (a Chromium or chrome-headless-shell executable). It renders a 1440 × 1200 light-theme PNG without opening a desktop window. The default generator needs only Python's standard library; the optional preview export needs an installed browser. While the owner's Mac is locked, export the artifact without computer-use or visual inspection.

## Playable build evidence

After merging runtime work, build and record the pinned scripted run:

    outputs/blackmoor-decomp/scripts/build_native_app.sh
    python3 outputs/blackmoor-decomp/scripts/record_playable_status.py
    python3 outputs/blackmoor-decomp/decomp-progress/generate.py

The recorder invokes `--inspect-live-session --live-click-row 34 --live-ticks 3000`, with the app's default read-only game location or an explicit `--game-dir`. This uses offline audio and opens no game window or output device. It refuses staged, unstaged or untracked changes under `outputs/blackmoor-decomp/src` or `scripts`, and checks the commit and registration inputs again after the run. Build immediately before recording: the JSON pins the executable SHA-256 and checkout commit, but the recorder does not prove that an arbitrary supplied executable was built from that commit. Raw process/session logs stay under `work/analysis/slices/PROG-1-live-*/`; public evidence includes only scene identifiers, row/type/provider identifiers, a bounded stop reason, counts and provenance hashes. No raw log lines, resource names, payloads or original bytes are copied.

`playable-status.json` has the pinned schema `blackmoor-playable-status/2`: `evidence` (kind, source commit, native hash, command, `registration_sources` path/SHA-256 pairs), `reached_scenes`, `stop`, `ticks`, `tests`, and `next_blocker`. Its strict validator rejects extra fields, invalid source paths/hashes and duplicate sources. Generation compares the recorded input list with fresh derivation and fails with `evidence stale; rerun record_playable_status.py` on a mismatch. It also rejects a stop whose action type is currently handled. There are no timestamps. `--seed` can reproduce the packet's committed integration snapshot when the game is unavailable; it marks evidence as seeded, records the current registration input hashes, leaves the native hash unavailable, and uses zero ticks to indicate no measured tick count. A failed or incomplete live run or failed public-file write leaves previous public evidence intact.

The log parser reads four events and rejects duplicate keys within each recognized event. Only `scene_transition_applied` adds a successful target. `scene_session_blocked` records a provider stop. `scene_transition_error` preserves the source scene and failed target, including the target's failing action row. `live_session_end` supplies the tick count and final status; its scene or stale action fields cannot replace a preceding transition failure. Reached scenes are unique, in first-visit order. Tests come from `status.json` `current_integration.full_suite` when present, otherwise `tests`; the generator rejects a stale copy of those totals. Their recorded integration source may differ from the live-run commit.

The refreshed live evidence reaches S0 → S5900 → S5907 → S5901–S5906 → S4700 and stops at S4700 row 3: typed `0x35`, provider `action-kernel`, without a native runtime handler. The generated panel/report carry the scene count, run hash and committed suite totals. This panel does not rerun that full suite.

Action coverage is derived by `playable.py`, rather than maintained as a handwritten handled list:

- Corpus scene and per-type record counts come from `action-census-current.json`. Apply the `known_body_length` cases in `src/scene_resource.c` to those per-type counts; see the generated panel/report for current typed and opaque family/record totals. This source-based projection assumes the corpus records satisfy each registered layout; it does not reparse original resources.
- Built-ins come from `scene_executor.c`: core type dispatch (cross-checked with `action_core.c`), dispatched scene/clock branches, and hotspot types with the raw `0x15` → runtime `0x0d` mapping. The dependency-only `0x9f` reset is excluded from built-in coverage.
- Session UI handlers come from the installed callback/present slots in `scene_session.c`. External handlers come from the binding array installed by `create_native_scene_session` in `blackmoor_app.mm`, resolving type constants through headers and confirming callback definitions in the app or `session_bindings_*.c`. Diagnostic-only app handlers and unwired modules are excluded.
- Live binding slots/counts and reserved types are cross-checked. Preprocessor conditionals inside scanned functions, registrations in conditional/nested scopes, and changed syntax that cannot be recognized fail generation. The generated panel/report list the handled and unsupported families and record totals; unsupported families (typed, no live handler) include `0x38`, `0x3f` and `0xa1`. One callback may serve several types (`0x16`/`0x17` share the A17 handler, `0x36`/`0x37` the A36 handler); registering one type twice fails generation as an invalid live action binding.

“Native handler” means a live dispatch path exists for the family. The handled record count is an upper bound: raw `0x15` is a hotspot only when `typed_body[0] == 0x0d`. Branches, providers, dependencies and media may still block individual records, including handled families. It is not a count of fully playable records. All registration inputs read during derivation (including searched headers and callback units), their hashes and the actual registration sets are included in `progress.json` and pinned in recorded evidence. Tests mutate scratch source/evidence copies and require stale or conditional claims to fail closed.

Run the public-only acceptance tests:

    python3 -m unittest discover -s outputs/blackmoor-decomp/decomp-progress -p test_progress.py
    python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p test_record_playable_status.py

## Function ledger panel

`index.html` shows a "Function ledger" panel between the playable-build panel and the x86 bars, and `REPORT.md` has a matching "Function ledger" section. It answers a different question from the x86 bars: not "which bytes match", but "which of the 4,188 functions has a recorded status": `ported` (a reviewed claim that native code or a test covers it), `not_needed` (a reviewed reason) or `pending`. Ported is never an x86 match and the two tracks are shown side by side in a cross-tab. The ledger is derived and validated by `function_ledger.py`; see [FL-0](../tasks/FL-0-function-ledger.md) for the rules. This is not the whole-file range ledger that `--ledger` reads.

What the panel shows: Ported (oracle-verified, tests-only, adapter), Not needed (by reason) and Pending (by subclass) counts; a stacked status bar per region; a cross-tab of x86-matched functions against native port status; and a table with status, region and class filters, address search (an address inside a function finds that function) and paging. Rows are `[va, span, region_i, status_i, class_i, ev_i]`; `ev_i` indexes a shared details table. Evidence links are relative (`../src/...`, `../tests/...`). Private receipts appear as a name plus sha256 only. Caveats are printed on the page and in the report.

How generation treats it (`generate.py`):

- If `function-ledger.json` is absent from `--evidence-dir` (or `--function-ledger-root`) the panel is hidden and everything else is generated as before.
- Otherwise the ledger must pass strict schema validation and equal a fresh derivation from the committed, hash-pinned inputs (`function-xrefs.json`, `function-evidence.json`, `function-ledger-overrides.json`, the function index, layout, census and x86 manifests). Any difference fails with `error: function ledger stale; rerun scripts/build_function_ledger.py --write`; an input the derivation rejects fails with `error: function ledger invalid: ...`.
- Only committed files are read. The generator never reads `work/` or the original executable for the ledger, so drift in private receipts is not detected here (`scripts/extract_function_evidence.py --check` does that). Committed `src/` and `tests/` files that the evidence cites are re-hashed: after changing one, run `scripts/extract_function_evidence.py --write` then `scripts/build_function_ledger.py --write` before regenerating the map, or generation stops with `error: function ledger invalid: ... pointer sha256 differs`.
- `--ledger-functions N` changes the pinned function count (default 4,188; the fixture tree uses 30). `--function-ledger-root DIR` reads the ledger and its inputs from another tree (the tests use `fixtures/function-ledger/`).
- The first publication has 0 ported and 0 not needed, so the panel says so plainly: it is the honest baseline, with more than 80% of functions pending. Pending subclasses are leads, not progress.

Run the panel tests (they also cover the generator): `python3 -m unittest test_progress.FunctionLedgerTests` from this directory. A test that renders the page needs a headless Chromium (`BLACKMOOR_PREVIEW_BROWSER` or the default Playwright path) and is skipped without one.

## Evidence and what counts as matched

Baseline mode (default) combines the legacy manifests `matches.json`, `matches_s08_2_x86.json`, `matches_s08_3_x86.json` and `matches_s08_4_x86.json` with automatically discovered `asm/batch-<number>.json` M03 manifests and `asm_data/data-<number>.json` data sources (packet M-C; each is validated against its audit report like an M03 batch, and its ranges count as matched data in the class `tool_assisted_reconstructed_data`). `batch-*-report.json` files and the unreviewed whole-code census are not match manifests. `matches_s08.json` (C candidate, 62 differing bytes) and `matches_s08_2.json` (C++ comparison) are excluded. The `status.json` `unique_matched_bytes` cross-check applies to the **legacy 398-byte baseline only**; audited code is an additional figure, so stale legacy status cannot erase it or create a false disagreement. Every counted manifest, audit report and audited source is pinned by SHA-256 in `progress.json`.

For each M03 batch the generator requires its matching audit report, pinned original identity, `tool_assisted_reconstructed_assembly` class, audit manifest hash, all-accepted result and error-free per-function records. It checks the pinned GNU assembler 2.43.1 version/binary hash, matching VA/RVA/symbol/code and data extents, zero relocations, comparison sizes, and source hashes against the current `.s` files. A stale manifest/source, rejected function, missing report, contradictory duplicate extent or function crossing its indexed span fails generation. Only each function's `code` extent adds matched code; `data_items` (tables/padding handed to M02) do not. Object/code hashes are retained in the pinned audit reports; no object, assembler binary or original executable is read for this check.

Publishing a batch in this evidence set requires root to have accepted its independent annotation review, as required by [M03](../tasks/M03-hinted-assembly-generator-and-first-batch.md) and [AGENTS.md](../../../AGENTS.md). The supplied batch's review acceptance is trusted from root's collection, not proven by the audit. `all_accepted` is the auditor's result; it alone does not establish independent review. This report does not rerun assembly, byte comparison or annotation review.

Byte accounting merges all ranges. Existing legacy classes keep their overlapping bytes; M03 is credited only with the remainder. `explicit_reconstructed_assembly_source` and `tool_assisted_reconstructed_assembly` remain separate. Repeated or partly overlapping M03 claims cannot inflate totals. `functions_by_provenance` counts distinct complete-function claims per class: the same function can have both explicit and tool-assisted source, so these class counts are not additive. `functions_complete` counts each complete function once. M03 completeness requires code size plus the sum of audited data-item sizes to equal the indexed start-to-next-start span; otherwise the claim stays partial. Range rows preserve all supporting manifests/classes.

Legacy byte claims are trusted by default. For a verified legacy refresh pass `--verify-original PATH/TO/GAME.EXE`: the generator runs `scripts/verify_matches.py` on the four legacy manifests and refuses output unless each is exact. Their object files live in the gitignored `build/`, so point `--verify-root` at the checkout that holds them (its manifests must be byte-identical to the evidence copies). This optional mode reads the original through the existing verifier; it does not re-audit M03. A verified legacy run also checks assembly source/object hashes against `status.json`'s reviewed `source_sha256`/`object_sha256`; `matches.json` has no recorded hashes and is reported as unbound. Fresh legacy reassembly remains the responsibility of `scripts/audit_matching_s08_*_x86.py`.

The generated report lists collected batches, excluded data bytes, unique matched code bytes, complete functions and per-class totals. Regression checks pin batches 001 and 002 at 86 functions / 33,312 code bytes and combined coverage at 33,326 unique matched code bytes / 86 complete functions. The refresh uses metadata/source hashes only; byte verification is recorded as prior evidence.

Denominators in baseline mode: code is the sum of indexed function spans (start to next start, last span to the end of `.text`), which also contains jump tables and `int 3` padding (about 10.9 KB, M0 report section 3). Data is every other file byte. Both are approximations until the ledger below exists.

Units: code units are 16 KiB address bands inside the three M0 regions (game, Vorbis and Ogg, CRT and MFC); data units are the image pieces in `layout.json`. They stand in for translation units. `--band-kib` changes the band size.

## Range ledger contract (for the M02 composer)

`generate.py --ledger FILE` consumes this neutral range format. The M02 composer's own coverage report needs an adapter to this schema:

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

An explicitly supplied ledger remains authoritative; M03 manifests are not overlaid onto it. This follow-up changes only `decomp-progress/`: `compose_image.py` and `report_image_coverage.py` still describe the sources actually composed by M02 and are unchanged. Since the Track M slice 2 binding they report the audited M03 batches as reconstructed code as well (reported by provenance class); this report's coverage figures are computed from the ledger and are separate.

## Not covered

No claim of original C++ or compiler provenance, whole-file rebuild, complete native gameplay or hardware input/audio verification. Sub-function structure of data pieces is not recorded. No history over time.
