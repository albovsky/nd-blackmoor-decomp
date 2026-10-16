# M02 image coverage

Composed 1,511,424 bytes; whole-file SHA-256 match: **True** (`afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`).

Referenced ranges are copied from the local original at build time and are NOT counted as matched. Structured and reconstructed ranges are generated from committed sources. Structured generation does not claim original C++ or compiler provenance.

## Progress

- Generated (structured + reconstructed): 1,211,108 bytes (80.13%)
- Referenced from the local original (not matched): 300,316 bytes in 688 described ranges
- Missing: 0 bytes
- Code bytes: 1,203,014; reconstructed 1,179,608 (98.05%); still referenced 23,406
- Reconstructed functions bound (separate classes below): 4,176

## By class

Ranges below are maximal contiguous runs of one class; the referenced list in `ranges.json` is finer (one entry per function piece, data page or resource payload).

| Class | Bytes | Contiguous runs |
|---|---:|---:|
| structured | 31,500 | 560 |
| reconstructed | 1,179,608 | 911 |
| referenced | 300,316 | 612 |
| missing | 0 | 0 |

## Reconstructed by provenance class

| Class | Functions or ranges | Bytes |
|---|---:|---:|
| tool_assisted_reconstructed_assembly | 4,163 | 1,179,210 |
| explicit_reconstructed_assembly_source | 11 | 384 |
| incomplete_byte_range_not_a_complete_function | 2 | 14 |

## By section

| Section | structured | reconstructed | referenced |
|---|---:|---:|---:|
| <headers> | 4,096 | 0 | 0 |
| .text | 11,564 | 1,179,608 | 25,340 |
| .rdata | 11,324 | 0 | 41,924 |
| .data | 0 | 0 | 208,896 |
| .rsrc | 4,516 | 0 | 24,156 |

## By code region

| Region | reconstructed | referenced |
|---|---:|---:|
| game | 1,023,506 | 42 |
| vorbis | 53,028 | 8,444 |
| crt_mfc | 103,074 | 14,920 |

## By structured group

| Group | Bytes | Items |
|---|---:|---:|
| dos_header | 128 | 1 |
| rich_header | 144 | 1 |
| pe_headers | 248 | 1 |
| section_table | 160 | 1 |
| header_padding | 3,416 | 1 |
| reconstructed | 1,179,608 | 4,176 |
| int3_padding | 2,214 | 381 |
| jump_tables | 5,856 | 172 |
| referenced | 300,316 | 688 |
| section_padding | 8,502 | 24 |
| iat | 1,356 | 13 |
| import_directory | 7,396 | 357 |
| resource_tree | 2,080 | 87 |

## Reconstructed ranges

| Symbol | Offset | Length | Source kind | Status |
|---|---:|---:|---|---|
| `_FUN_004daf3f` | 0xdaf3f | 47 | assembly | bound |
| `_FUN_004daf6e` | 0xdaf6e | 49 | assembly | bound |
| `_FUN_004daf9f` | 0xdaf9f | 36 | assembly | bound |
| `_FUN_004dafc3` | 0xdafc3 | 61 | assembly | bound |
| `_FUN_004db000` | 0xdb000 | 79 | assembly | bound |
| `_FUN_004dae66` | 0xdae66 | 17 | assembly | bound |
| `_FUN_004dae77` | 0xdae77 | 17 | assembly | bound |
| `_FUN_004daef1` | 0xdaef1 | 17 | assembly | bound |
| `_FUN_004daf02` | 0xdaf02 | 22 | assembly | bound |
| `_FUN_004daf18` | 0xdaf18 | 17 | assembly | bound |
| `_FUN_004daf29` | 0xdaf29 | 22 | assembly | bound |
| `_FUN_0051cfd1` | 0x11cfd1 | 7 | c_incomplete_byte_range | bound |
| `_FUN_0052398b` | 0x12398b | 7 | c_incomplete_byte_range | bound |
| `asm/batch-001.json` (35 functions, 11 superseded by earlier bindings) | - | 12,138 | tool_assisted_assembly | bound |
| `asm/batch-002.json` (40 functions, 0 superseded by earlier bindings) | - | 20,790 | tool_assisted_assembly | bound |
| `asm/batch-003.json` (700 functions, 0 superseded by earlier bindings) | - | 285,792 | tool_assisted_assembly | bound |
| `asm/batch-004.json` (700 functions, 0 superseded by earlier bindings) | - | 281,442 | tool_assisted_assembly | bound |
| `asm/batch-005.json` (700 functions, 0 superseded by earlier bindings) | - | 306,703 | tool_assisted_assembly | bound |
| `asm/batch-006.json` (700 functions, 0 superseded by earlier bindings) | - | 189,707 | tool_assisted_assembly | bound |
| `asm/batch-007.json` (698 functions, 2 superseded by earlier bindings) | - | 72,430 | tool_assisted_assembly | bound |
| `asm/batch-008.json` (590 functions, 0 superseded by earlier bindings) | - | 10,208 | tool_assisted_assembly | bound |

The full referenced-range list (offset, length, SHA-256) is `ranges.json`; `build/image/coverage-report.json` embeds it.
