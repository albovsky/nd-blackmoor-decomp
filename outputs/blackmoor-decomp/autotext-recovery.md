# AUTOTEXT caption lookup recovery

## Recovered resource and loader

The shipped `GAME.EXE` (SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`) loads the decoded `AUTOTEXT` resource through its `TEXT` DATA record and `CVTX` chunk. The original resource is `work/analysis/hiff-resources/0001.bin` (SHA-256 `9c3d5cabe39edc21603e06e1ee933837cd080650762df4d2a8d107eebcfca441`). `FUN_00411215` selects `CVTX`, reads a little-endian 16-bit record count, and loops over records. For each record it copies the 33-byte key field, reads a little-endian 16-bit value length at key offset `0x21`, copies exactly that many value bytes from offset `0x23`, and inserts the pair through `FUN_00423142`. Its cursor advances by `0x23 + value_length`.

The decoded `CVTX` payload therefore has this layout:

```text
uint16_le record_count
repeat record_count times:
    uint8 key[33]          # NUL-terminated in supported inputs
    uint16_le value_length
    uint8 value[value_length]
```

The native loader selects `TEXT` and `CVTX` with the existing HIFF parser and verifies the selected chunk belongs to that DATA record. It keeps the HIFF-owned byte copy alive until `autotext_close`, so lookup results remain valid for the `AutoText` lifetime even if the caller changes its original input buffer.

## Lookup and value behavior

`FUN_00423097` clears a 1,024-bucket table. `FUN_00423142` inserts at the end of the chosen bucket chain. `FUN_00423259` returns the first matching node's value pointer or null. It chooses the bucket with `FUN_00423368`: decimal parsing starts at key byte 3, then a zero result falls back to the first digit in the key, or to the signed first byte if there is no digit. The key is not uppercased before hashing. The lookup compares case-folded keys only inside the selected bucket, so ASCII case variants such as `NSHT01`/`nsht01` match, while some all-alpha keys can hash to different buckets under a case change.

When the original uppercase-mode global `DAT_0063cb1c` is zero, `FUN_0050d0bc` uppercases ASCII `a` through `z`. A nonzero value takes a Windows NLS path. The portable API requires the caller to pass the mode explicitly and returns `AUTOTEXT_ERR_UNSUPPORTED` for nonzero mode; it does not claim NLS equivalence.

The original loader zeroes a 40,000-byte temporary value buffer, copies the declared CVTX bytes into it, then `FUN_00423142` copies the value as a C string using `strlen`. Thus an embedded NUL ends the caption string even though later declared bytes remain part of the resource payload. `autotext_lookup` returns the borrowed raw payload pointer, its declared `raw_value_length`, and a separate `caption_length` ending at the first NUL. The pointer itself is not promised to have a NUL after the CVTX bytes; callers must use the explicit lengths. Bytes remain raw single-byte text and are not decoded as UTF-8.

On a miss, `FUN_00423259` returns null. In `FUN_0041c7f4`'s closed-caption action branch, the caller substitutes the ASCII literal `Missing closed captioning text string<h><n><o>`: 46 bytes followed by NUL. The source literal is at `0x00543310` (the same bytes also occur at `0x00543340`, `0x005433b4`, and `0x005433e4`). That caller copies 47 bytes, including the terminator. The lookup API reports `AUTOTEXT_ERR_NOT_FOUND`; fallback selection remains a caller decision.

## Bounds and compatibility limits

The original loops trust their count, offsets, 33-byte key fields, and 16-bit value lengths. A key with no NUL in its field can make the original `strlen` read beyond the field, and a value length of 40,000 or more can remove the zeroed temporary buffer's terminator or overrun it. The portable parser rejects unterminated keys, truncated records, trailing CVTX bytes, and values at or above 40,000 bytes. Its maximum accepted value is 39,999 bytes, which leaves room for the original zero-filled C-string terminator. It also rejects a computed bucket outside the original 1,024-entry table instead of attempting an out-of-bounds access.

## Original-code validation

`tests/autotext_original_oracle.py` executes the shipped x86 table initializer (`0x423097`), insertion (`0x423142`), and lookup (`0x423259`) in Unicorn. It reads records from the actual AUTOTEXT/TEXT/CVTX fixture and supplies them to the original insertion routine in file order. The only code hook is the bounded allocator at `0x51dc43`; the oracle does not launch the game or call file, window, audio, or rendering APIs. This validates actual original table insertion/lookup semantics, not whole-game behavior or a rendered caption.

The oracle confirms 1,257 records in 154,240 CVTX bytes. `NSHT01` and its ASCII lowercase variant return the same 185 bytes as the fixture. One ASCII-folded duplicate exists (`JPM60X`, records 184 and 566), and the original lookup returns record 184's value. A missing-key probe returns null. The original binary includes the missing-caption literal described above. `tests/test_autotext.py` additionally checks native fixture lookup, source-copy lifetime, duplicate behavior, embedded-NUL lengths, NLS rejection, and malformed input bounds.
