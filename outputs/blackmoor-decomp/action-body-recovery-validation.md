# Scene action body boundary validation

This report recenses the native parser after adding the fixed body layouts from the first priority batch and the original variable 0x9f boundary. It scans decoded files under `work/analysis/hiff-resources` with the same native parser exposed by `libsceneresource.dylib`.

## Corpus counts

- Manifest resources: 2,267; decoded files: 2,267.
- SCEN resources opened: 2,078.
- ACT chunks: 19,612; distinct raw type bytes: 71; distinct raw type/subtype pairs: 73.
- Typed: 9,111; opaque: 10,501; total: 19,612.
- Dependency records exposed across typed actions: 15,281.
- Parse failures while opening SCEN resources or reading actions: 0.

## Newly recovered raw types

| Raw type | ACT records | Body length in records | Dependency records |
|---|---:|---|---:|
| `0x0b` | 1,275 | 24 B: 1275 | 418 |
| `0x47` | 139 | 39 B: 139 | 180 |
| `0x4f` | 815 | 10 B: 815 | 68 |
| `0x78` | 466 | 6 B: 466 | 548 |
| `0x95` | 123 | 3 B: 123 | 4 |
| `0x9f` | 3,570 | 48 B: 3289, 81 B: 281 | 10,445 |
| `0xd9` | 274 | 35 B: 274 | 442 |

The six fixed layouts account for 3,092 actions. Their original loader source cursor advances are 24 (`0x0b`, direct `local_d0 += 0x18`), 10 (`0x4f`, helper `0x44b1b4`), 6 (`0x78`, helper `0x4e9c2f`), 35 (`0xd9`, helper `0x47d682`), 39 (`0x47`, helper `0x411a22`), and 3 (`0x95`, direct `local_d0 += 3`). Each helper increments the source pointer and consumed offset together. The 0x4f helper allocates a 10-byte destination and copies/advances exactly 10 bytes; the 0x0b handler allocates 0x28 bytes but advances the source by 0x18, so storage size is not used as its body length.

For raw type `0x9f`, the original loader reads a little-endian selector at body offset 46. Selector `0xffff` consumes `0x51` (81) bytes; otherwise the source advance is selector + `0x30`, with values above 9999 rejected. In the corpus, 3,289 actions use numeric selector 0 and 281 use `0xffff`; the parser accepts only these verified cases, and the remaining bytes must form complete 16-byte dependency records. It retains the ACT header type byte unchanged; there is no runtime type normalization in this parser.

S0 (`0800.bin`) action `Sound` has raw type `0x9f`, selector `0xffff`, and 97 bytes after the 50-byte action header. The correct split is 81 body bytes plus one 16-byte dependency record. The body length is not 97 bytes; 97 includes the dependency tail.

Unknown types, including `0xa1`, remain wholly opaque. The JSON sidecar contains the complete actual-type census and dependency totals.
