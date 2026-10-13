# M01: refresh the decompilation map from reviewed matching evidence

Owner: root will assign a GPT-6 Luna Max worker when a slot is free. State: unclaimed. Scope is the existing outputs/blackmoor-decomp/progress-map/ directory only plus unique private M01.* evidence. Root controls central status/registry. Use a separate worktree and JSON claim; do not edit engine files or worker reports.

## Outcome

Update the user's existing offline decomp.dev-style map to display the collected, reviewed S08-2 source-bound assembly matches. Preserve the distinction between complete exact assembly extents, selected incomplete exact ranges, compiler-generated C mismatches, bounded original-oracle comparisons and pseudocode. Keep the existing address treemap, filtering, keyboard inspector and offline operation.

Read progress-map/README.md, generate.py, app-template.html and test_progress_map.py. The current source-pinned integration is f7b57a0, with documentation on bc6f05b; obtain the actual assignment baseline from root. Do not edit the prior matching auditiors or manufacture validation receipts.

## Required evidence and invariants

The fresh accepted input is private S08-2-x86-report.json, with manifest matches_s08_2_x86.json, source src/matching_s08_2_x86.s and current object build/matching_s08_2_x86.obj. Root verified six complete functions, 112 bytes, zero differences, source SHA22de8caa942c3b26f278137158ae86cbe759f4309d143e811e9aac5e64b8c22a and object SHAca083f3fa44e665a22c0a1006b10cf1bb082c7904c855b0804a9eb6b920167e7. The accepted classification is explicit_reconstructed_assembly_source, with actual supplied-object comparison binding and reviewed-source/fresh-reassembly association. Inspect and validate the complete report schema, manifest/original/range/terminal-return bounds, row and aggregate counts and hashes. Current source/object files must match the report. Report presence alone grants no positive source claim.

Together with the older two incomplete 7-byte selected ranges, the root union receipt proves 126 unique exact bytes across eight selected extents; overlaps must be deduplicated. Six assembly extents have complete-function evidence, the two old ranges do not. C/C++ candidates still fail exact compilation (six C functions: 62 differing offsets; six C++ functions:66); retain that separate evidence and do not promote their source classification.

S08-3 input methods are being reconstructed independently. Display that family only after root accepts its immutable source/object association and reports; absence or in-progress claims contribute no exact bytes. Avoid a hardcoded success count that changes before verified inputs change.

Reject/quarantine stale sources, wrong objects, equivalent-but-unreviewed assembly, missing or failed reassembly, bad original/manifest hashes, malformed extents and inconsistent counts. Such reports remain visible in lineage with their reason and must not color/filter/count as positive matching or source evidence. Existing quarantine behaviour and partial-independent-range handling stay intact.

Complete exact assembly functions get a distinct readable map status and inspector label. A partial exact range retains its extent limitation. Estimated next-start tile area remains an estimate; no unsupported decompilation percentage or whole-file completion claim. Keep source HEAD, each report hash, source/object/manifest hashes and historical provenance limits separately visible. Current source reproducibility is not original C/compiler provenance.

## Verification and handoff

Extend generator tests with positive six-function data and meaningful mutant/report binding cases, overlapping ranges and mixed C mismatch/assembly exact evidence. Generate from a frozen source/evidence snapshot, validate local links and binding digests, and run headless desktop/mobile interaction checks for both new exact and quarantined states. Keep zero external requests; automated headless rendering is permitted while the Mac is locked. No CUA/hardware verification.

Return a clean committed map update with generator/test/browser commands, result counts, snapshot hash/source ref, lineage inputs, screenshot evidence and explicit coverage omissions. Request independent review and repair material findings. Do not edit engine status.json yourself; root updates its refresh flag after collection. Preserve generated resource/executable bytes outside tracked artifacts.
