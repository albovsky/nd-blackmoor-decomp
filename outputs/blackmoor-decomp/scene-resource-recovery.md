# Scene resource parser evidence

This parser reads one decoded `SCEN` DATA record through the validated HIFF
indexer. It copies the `TSUM` summary and builds action metadata while keeping
the original action bytes owned by the `SceneResource`. It does not execute
actions or evaluate dependency trees.

## Recovered layout

In original scene loader `0x439822`, the selected `TSUM` payload is copied as a
title starting at byte 0, a background stem starting at byte `0x32` (50), and an
audio stem starting at byte `0x53` (83). The loader reads additional 16-bit and
32-bit values at offsets `0x74` through `0x7d`; this parser keeps the ten bytes
at offsets 116–125 verbatim until their meanings are established. The supplied
scene corpus uses a 126-byte `TSUM` payload.

Original action loader `0x40b34a` copies the NUL-terminated description from an
action record, reads the type and subtype bytes at offsets `0x30` and `0x31`,
and starts type data at offset `0x32`. Its recovered body widths include:

| Type | Original body width |
| --- | ---: |
| `0x0a` scene change | 20 bytes |
| `0x0b` | 24 bytes (`local_d0 += 0x18`) |
| `0x15` remapped action | 20 bytes |
| `0x1d` control | 8 bytes |
| `0x47` | 39 bytes (`0x411a22` advances the source by `0x27`) |
| `0x4d` set value | 4 bytes |
| `0x4f` | 10 bytes (`0x44b1b4` advances the source by 10) |
| `0x61` event flags | 8 bytes |
| `0x6a` event flags with hotspots | 42 + 18 × signed count at body offset 40 |
| `0x6b` event flags | 40 bytes |
| `0x71` difficulty | 6 bytes |
| `0x78` | 6 bytes (`0x4e9c2f` advances the source by 6) |
| `0x82` cellphone number | 41 bytes |
| `0x95` | 3 bytes (`local_d0 += 3`) |
| `0x9f` sound | 81 bytes for selector `0xffff`; otherwise selector + 48 |
| `0xd9` | 35 bytes (`0x47d682` advances the source by `0x23`) |

For `0x9f`, the original loader reads a little-endian selector at body offset
46. Selector `0xffff` consumes 81 bytes; otherwise the body width is selector
+ 48, with selectors above 9999 rejected by the loader. These are source
cursor advances, not destination allocation sizes. The parser marks this
payload `SCENE_ACTION_PAYLOAD_VARIABLE`, preserves the raw type byte, and only
exposes a dependency tail when the remaining byte count is divisible by 16.
Type `0xa1` uses a related branch with a selector at body offset 49; it remains
opaque until that distinct boundary is recovered.

For `0x6a`, the count is a signed 16-bit value, matching the original
`local_24[0x14] * 0x12 + 0x2a` calculation. Negative counts, short headers,
overflow and body lengths that exceed the ACT chunk are rejected.

After each known type body, original `0x40b34a` passes the current action-data
offset, ACT payload length and current data pointer to `0x424aa8`. That loader
computes the residual dependency count in 16-byte units and reads those records
from the current data pointer. The parser therefore exposes a dependency tail
only for known body layouts and only when the residual length is divisible by
16. Each record is available as raw bytes and as all eight signed little-endian
16-bit words. The first word is `opcode`; the original branch reducer checks
the fourth word (`or_after`) for exactly one to join adjacent leaves with OR.

The `0x15` handler changes the runtime action type to the first byte of that
action's 20-byte body before passing it through another mapper. It does not
unconditionally map `0x15` to `0x0d`. This parser retains the original `0x15`
type and body bytes without applying a runtime rewrite.

Unknown action types keep all bytes after the 50-byte action header in
`raw_body`; the parser does not infer a typed body or dependency tail for them.

## Corpus validation

The decoded archive manifest has 2,267 resources. The parser opened all 2,078
resources whose first indexed DATA record is `SCEN`, with no failures. Those
scene resources contain 19,612 ACT chunks. The supported typed layouts account
for 9,111 action records; the other 10,501 remain opaque. The recognized
layouts expose 15,281 dependency records. Raw action type bytes remain intact;
this census does not merge types that the original loader rewrites for runtime
dispatch.
The largest scene has 119 ACT chunks (`S3801`). The public 999-action limit is
the existing HIFF chunk-table limit; it is not the original scene loader's
runtime limit (120 or 240, depending on scene mode).

Recovered S0 (`0800.bin`) parses to title `Player Challenge Screen`, background
`diff`, audio `ndsig`, and 38 ACT chunks. Its `->start map` action has type
`0x0a`, a 20-byte typed body, and two dependency records. Both have opcode 2
and `or_after == 1`, matching the two difficulty alternatives. Its `Sound`
action has raw type `0x9f`, selector `0xffff`, and 97 bytes after the action
header: 81 bytes of body followed by one 16-byte dependency record. The 97-byte
chunk remainder therefore includes the dependency tail. Malformed short TSUM
bodies, truncated newly supported action bodies, invalid 0x9f selectors and
non-integral dependency tails are rejected by tests.

The full post-recovery census is in
[`work/analysis/action-body-recovery-validation.md`](../../work/analysis/action-body-recovery-validation.md),
with machine-readable counts in the adjacent JSON file.

Validation command:

```sh
outputs/blackmoor-decomp/scripts/build_scene_resource.sh
python3 -m unittest outputs/blackmoor-decomp/tests/test_scene_resource.py -v
```
