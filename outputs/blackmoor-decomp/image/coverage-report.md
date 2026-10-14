# M02 image coverage

Composed 1,511,424 bytes; whole-file SHA-256 match: **True** (`afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`).

Referenced ranges are copied from the local original at build time and are NOT counted as matched. Structured and reconstructed ranges are generated from committed sources. Structured generation does not claim original C++ or compiler provenance.

## Progress

- Generated (structured + reconstructed): 33,832 bytes (2.24%)
- Referenced from the local original (not matched): 1,477,592 bytes in 4,293 described ranges
- Missing: 0 bytes
- Code bytes: 1,203,014; reconstructed 398; still referenced 1,202,616

## By class

Ranges below are maximal contiguous runs of one class; the referenced list in `ranges.json` is finer (one entry per function piece, data page or resource payload).

| Class | Bytes | Contiguous runs |
|---|---:|---:|
| structured | 33,434 | 555 |
| reconstructed | 398 | 4 |
| referenced | 1,477,592 | 542 |
| missing | 0 | 0 |

## By section

| Section | structured | reconstructed | referenced |
|---|---:|---:|---:|
| <headers> | 4,096 | 0 | 0 |
| .text | 13,498 | 398 | 1,202,616 |
| .rdata | 11,324 | 0 | 41,924 |
| .data | 0 | 0 | 208,896 |
| .rsrc | 4,516 | 0 | 24,156 |

## By code region

| Region | reconstructed | referenced |
|---|---:|---:|
| game | 384 | 1,023,164 |
| vorbis | 0 | 61,472 |
| crt_mfc | 14 | 117,980 |

## By structured group

| Group | Bytes | Items |
|---|---:|---:|
| dos_header | 128 | 1 |
| rich_header | 144 | 1 |
| pe_headers | 248 | 1 |
| section_table | 160 | 1 |
| header_padding | 3,416 | 1 |
| referenced | 1,477,592 | 4,293 |
| int3_padding | 2,214 | 381 |
| jump_tables | 7,790 | 191 |
| reconstructed | 398 | 13 |
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

The full referenced-range list (offset, length, SHA-256) is `ranges.json`; `build/image/coverage-report.json` embeds it.
