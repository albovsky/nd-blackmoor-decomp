# Scene action recovery priorities

**Update:** The ranking below predates the latest recovery. Types `0x0b`, `0x4f`, `0x78`, `0xd9`, `0x47`, `0x95` and `0x9f` now have recovered body boundaries. Current coverage is 9,111 typed and 10,501 opaque ACTs. Next layout candidates are `0x62`, `0x35`, `0x38` and `0xa1`; execution remains separate work.

Native parsing of all 2,078 SCEN records succeeded: 19,612 ACTs, 71 type values, 73 type/subtype pairs. The current parser has 2,449 typed records and 17,163 opaque records. The 15 largest opaque type values account for 16,528 records (96.30%).

Loader and executor addresses come from pseudocode of the original executable. Those files are marked unverified Ghidra output. Corpus checks below mean only that the candidate body end leaves a residual divisible into 16-byte records; they do not establish action semantics.

| Rank | Raw type/subtype | Opaque ACTs | 0x40b34a loader evidence | Body boundary candidate | 0x427a50 executor |
|---:|---|---:|---|---|---|
| 1 | 0x37 / 0x01 (4,308) | 4,308 | case 0x37 line 459 → 0x4895cc; runtime type→0x36 | Complex helper: consumes a 0x45-byte prefix plus a range-driven 16-byte record block. Do not split dependencies until helper range fields are safely mapped. | case 0x36 line 282 → 0x4899ca |
| 2 | 0x9f / 0x01 (3,554), 0x02 (16) | 3,570 | case 0x9f line 2273 | Variable. Selector is uint16 at body+46; source cursor advance is 0x51 when selector=0xffff, otherwise selector+0x30. | case 0x9f line 931 → 0x432d1a |
| 3 | 0x97 / 0x01 (1,958) | 1,958 | case 0x97 line 1686; runtime type→0x9f | Complex alternatives table; loader cursor advance is 0x2e + local_cc after count-driven alternatives. Loader rewrites the runtime type to 0x9f at line 1979. | case 0x9f line 931 → 0x432d1a |
| 4 | 0x62 / 0x01 (1,802) | 1,802 | case 0x62 line 1026 | 12 + 18*n bytes, n = signed LE int16 at body+10; 1802/1802 corpus candidates leave a multiple-of-16 tail. | case 0x62 line 575 → 0x42ea87 |
| 5 | 0x0b / 0x01 (1,275) | 1,275 | case 0x0b line 123 | 24 bytes consumed (local_d0 += 0x18); allocator size 0x28 is destination storage, not source-body length. 1275/1275 corpus candidates leave a multiple-of-16 tail. | case 0x0b line 135 → 0x42ae73 |
| 6 | 0x4f / 0x01 (815) | 815 | case 0x4f line 769 → 0x44b1b4 | 10 bytes fixed; helper advances the source cursor by 10. 815/815 corpus candidates leave a multiple-of-16 tail. | case 0x4f line 480 → 0x44b641 |
| 7 | 0xa1 / 0x01 (565) | 565 | case 0xa1 line 2274 → inline (shared 0x9f case) | Variable. Selector is uint16 at body+49; source cursor advance is 0x54 when selector=0xffff, otherwise selector+0x33. | case 0xa1 line 931 → 0x432d1a |
| 8 | 0x3f / 0x01 (493) | 493 | case 0x3f line 472 → 0x41c7f4 | Complex nested conversation layout with count-driven tables/strings; preserve opaque until each nested count is bounded. | case 0x3f line 293 → 0x420c17 |
| 9 | 0x78 / 0x01 (466) | 466 | case 0x78 line 1483 → 0x4e9c2f | 6 bytes fixed; helper advances the source cursor by 6. 466/466 corpus candidates leave a multiple-of-16 tail. | case 0x78 line 736 → 0x4eaadc |
| 10 | 0x38 / 0x01 (425) | 425 | case 0x38 line 463 → 0x48905b; runtime type→0x36 | 0x47 + 16*n bytes, n = LE_i16(body+0x35) - LE_i16(body+0x33) + 1; all 425/425 corpus candidates leave a multiple-of-16 tail. | case 0x36 line 282 → 0x4899ca |
| 11 | 0xd9 / 0x01 (274) | 274 | case 0xd9 line 2541 → 0x47d682 | 0x23 (35) bytes fixed; helper advances the source cursor by 0x23. 274/274 corpus candidates leave a multiple-of-16 tail. | case 0xd9 line 1045 → 0x47d788 |
| 12 | 0x3e / 0x01 (202) | 202 | case 0x3e line 471 → 0x41c7f4 | Complex nested conversation layout with count-driven tables/strings; preserve opaque until each nested count is bounded. | case 0x3e line 293 → 0x420c17 |
| 13 | 0x47 / 0x01 (139) | 139 | case 0x47 line 533 → 0x411a22 | 0x27 (39) bytes fixed; helper advances the source cursor by 0x27. 139/139 corpus candidates leave a multiple-of-16 tail. | case 0x47 line 437 → 0x412787 |
| 14 | 0x95 / 0x01 (123) | 123 | case 0x95 line 1643 | 3 bytes fixed; loader advances by 3. 123/123 corpus candidates leave a multiple-of-16 tail. | case 0x95 line 823 → 0x4fca60 then 0x42ba3a |
| 15 | 0x35 / 0x01 (113) | 113 | case 0x35 line 453 → 0x4bf8c2 | 0x3f + 6*n + 0x22*m; n = LE_i16(body+0x3b), m = LE_i16(body+0x3d+6*n). All 113/113 corpus candidates leave a multiple-of-16 tail. | case 0x35 line 276 → 0x4bf9bb |

## Suggested bounded next batch

Start with `0x0b`, `0x4f`, `0x78`, `0xd9`, `0x47`, and `0x95`: 3,092 opaque records. Their fixed body lengths are explicit in loader code, and every candidate body end leaves an integral 16-byte tail across the corpus. Then add formula-driven `0x62` (1,802 records) and `0x35` (113 records); their candidate formulas also passed all-record tail alignment.

Keep `0x37`, `0x97`, `0x3e`, and `0x3f` opaque during that batch. Their loaders use transformed or nested variable layouts. Types `0x37` and `0x38` normalize to executor type `0x36`, while `0x97` normalizes to `0x9f`. Candidate boundaries for `0x38`, `0x9f`, and `0xa1` align across the corpus, but their fields deserve separate review before runtime decoding.

## Dependency-tail rule

After the type-specific body has been consumed, the original loader calls `0x424aa8` (from `0x40b34a`, line 2637). That loader divides remaining ACT bytes into 16-byte records and rejects a residual that is not a multiple of 16. Decode dependency records only after the exact action-specific body end is known. For unknown layouts, preserve the entire body and report zero dependencies.

The full type/subtype census and per-type evidence are in [`action-recovery-priority.json`](action-recovery-priority.json).
