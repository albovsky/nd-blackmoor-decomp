# Original CIF archive subsystem

This slice reconstructs resource lookup and decompression from the supplied
`GAME.EXE`. It is one engine subsystem, not a playable native game. Behavioral
comparisons do not add to the executable's byte-matching count.

## Evidence and boundaries

Original executable SHA-256:
`afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.

| Original address | Observed role |
| --- | --- |
| `0x419dab` | Opens a tree, reads its header, hash table and records |
| `0x418e52` | Uppercases a query, resolves a resource and reads its payload |
| `0x41a19c` | Computes a signed 16-bit character-sum hash |
| `0x41b6e2` | Decodes compressed resource bytes |
| `0x4c7314` | Optional image pixel conversion after decoding |

The loader functions' pseudocode is linked to REA evidence
`ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c`.
Focused decoder analysis is
`ev_ddda9611f2ec545d148bae3db03db4087528c9b5b890635694185af9c036d20c`.
Ghidra reports its complete contiguous body as `0x41b6e2` through `0x41b924`,
inclusive: 579 bytes. The hash and decoder were also checked against the original
x86 instructions. Pseudocode alone is not a runtime trace.

## Tree layout

All multibyte numbers are little-endian. The 32-byte header begins with the
20-byte identifier `CIF TREE WayneSikes` padded with zero bytes. Version words
at offsets 24 and 26 are 2 and 1; the record count is at offset 28.
The header is followed by 1,024 two-byte bucket heads, then fixed 94-byte records.
Bucket heads and links use `0xffff` as the end sentinel.

| Record offset | Meaning |
| --- | --- |
| 0 | 33-byte name field including terminator |
| 33 | Two-byte resource identifier |
| 35 | Four-byte payload file offset |
| 39 | Two-byte next record in the bucket chain |
| 80 | Compression metadata byte |
| 81 | Four-byte declared decoded size |
| 85 | Four-byte field with unresolved semantics |
| 89 | Four-byte compressed size |
| 93 | Resource kind: 2 image, 3 data, 4 marker in this archive |

`CIFTREE.DAT` contains 2,904 records: 619 images, 2,267 data resources and
18 empty markers. Its payloads reside in that same file. The reconstruction
does not infer a separate `.CAL` companion from an error message.

Standalone CIF files have an 81-byte header, the 20-byte identifier
`CIF FILE WayneSikes` padded with zero bytes, and version words 2 and 1 at
offsets 24 and 26. Compression metadata is at offset 67; decoded size at 68,
compressed size at 76, and resource kind at 80. Payload follows the header.

## Decoder behavior

Each consumed input byte is decoded by subtracting a running eight-bit counter,
which starts at zero and wraps. Control bits are processed least-significant
first: 1 denotes a literal; 0 denotes a two-byte dictionary reference. A pair
encodes a 12-bit dictionary offset and a length from 3 to 18. Dictionary indices
wrap at 4,096 bytes, and bytewise forward copying permits overlapping references.

Each call resets the first 4,078 dictionary bytes to spaces and starts its write
cursor at 4,078. The final 18 bytes retain the preceding call's state; they are
zero only in the initial zero-filled global storage. The native decoder keeps
that state in an explicit context.

The original routine ignores its declared output length and can silently stop
inside a token when input ends. The native implementation must bound output and
report malformed streams safely. Such rejected-input behavior is deliberately
different from the original's unchecked memory behavior.

The original hash accumulates signed characters in a signed 16-bit value and
returns a signed remainder modulo 1,024. Normalization occurs before hashing.
The native loader supports the archive's observed ASCII names and rejects
unsupported high-bit names instead of reproducing negative table indexing.

The recovered loader returns the decoded resource bytes before the optional
renderer-dependent image conversion at `0x4c7314`. Graphics, audio, scene logic,
script execution and gameplay remain separate recovery work.

## Validation approach

The test oracle executes only the original 579-byte x86 decoder with Unicorn,
using guarded buffers and bounded execution. It compares native decoded bytes
and the retained dictionary state with the original routine. This emulation is
a development test instrument; the compiled archive utility executes native C.
The full run passed all 2,949 payload comparisons: 2,886 tree resources and
63 standalone CIF files, totaling 149,360,874 decoded bytes. Each comparison
checked complete output bytes and all 4,096 dictionary bytes. Both sides kept
their context through tree record order and then sorted standalone-file order.
All 2,904 case-insensitive name queries resolved to the expected record indices;
the 18 markers were checked by lookup only. The run took 224 seconds.

`original-decoder-validation-summary.json` gives counts, input identities and
scope. `original-decoder-validation.json` retains per-resource output and state
hashes. The original archive lookup routines were traced statically; the
dynamic oracle executes the decoder only. The native side exercises the public
archive extraction and standalone CIF APIs.

All 18 native regression tests and 12 existing byte-range verifier tests pass.
The strict ARM64 build passes. AddressSanitizer and UndefinedBehaviorSanitizer
smoke checks found no issues in full archive listing and boot.CIF decoding.
Independent review found no remaining material findings in this subsystem or
its full comparison harness.
