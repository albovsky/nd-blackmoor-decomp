# S06-2: Remaining dependency leaf providers

Status: **implementation complete, awaiting independent review**. This packet
covers the isolated `condition_extra` evaluator only. It does not register the
module in the shared scene tree or claim complete game behavior.

## Source-backed behavior

The original leaf switch is `GAME.EXE` `0x00424346..0x00424aa8`. It reads the
opcode as a signed word at node+`0x10`, `fields[1]` at +`0x12`, and
`fields[2]` at +`0x14`. The complete 1,890-byte code window is pinned in the
private recovery JSON. The module implements the eight observed unsupported
leaf opcodes below; opcodes 0–6/9 remain with `scene_conditions`, and tree
markers 0x12/0x13 remain loader/executor concerns.

| Opcode | Original predicate and effects | Live provider / native boundary |
| --- | --- | --- |
| 11 | If executor+0x614 is nonzero, set status=1 and clear tree-root+0x24. Otherwise status is `selected_item == fields[1]`; on hit store this leaf pointer in root+0x24, on miss clear it only if it points to this leaf. | Current `SceneConditionState.selected_inventory_item`; action-owned borrowed pointer slot. |
| 12 | Signed-word `fields[1] == word(0x005bb20a)`. | `WorldClockSession.outside_window_flag_5bb20a`, read on each evaluation. |
| 13 | Timer record status is 1, 5, or 6 **and** signed elapsed dword at record+4 is `<=` signed node dword+0x20. | Current `WorldInitState.time_records_585d65[index * 0x106]`. New-node constructor `0x4237f7` clears all 0x4c bytes, so threshold starts at zero. Raw fields[4..7] remain separate and are not a threshold. |
| 14 | Same active-status gate, with signed elapsed `>` signed node+0x20. | Same live record and node runtime sidecar as 13. |
| 15 | Signed `fields[2] == signed word(0x0058c94f)`. | Current `ConditionExtraSession.context_58c94f`. |
| 17 | Call original helper `0x4f6334(fields[1])`. For `fields[2]==1`, status is helper-result nonzero; for `==0`, status is helper-result zero; all other field values set status=0. | `sound_query(context, channel, result)`. The callback owns source-equivalent sound-manager mutations before returning. `UNAVAILABLE` is different from observed false; `PARTIAL_FAILURE` reports a committed host prefix. |
| 20 | If node+0x2c is already nonzero, leave status untouched and return. Otherwise call MSVC `rand`, save `raw % 100` at +0x30, perform the debug-only invalid-condition check (condition outside 1..100) after that store, then set status to `sample < fields[2]` and +0x2c=1. | `next_random` returns the raw CRT value 0..32767 and reports call consumption before modulo. No portable RNG substitute. Reset `0x423da2` clears the validity dword only; cached sample remains. |
| 21 | Status is `dword(0x005c3a47) != 0`; this leaf does not write it. | Read-only `previous_global_5c3a47`. The original wrapper `0x423f57` writes the global after the full tree result; Boot/tree owner retains that responsibility. |

The tree leaf constructor at `0x4237f7` allocates and zeroes 0x4c bytes. The
reset traversal at `0x423da2` clears leaf status and random-valid state. A
selected-leaf pointer is borrowed only for the owning action/scene lifetime;
scene/action teardown must destroy or clear that slot before its tree storage
is released. The module never retains parser-record, world, timer-record, or
runtime pointers beyond the synchronous leaf call. `condition_extra_node_reset`
only mirrors the source-owned random-valid clear; surrounding tree status and
pointer reset remains in the existing tree owner.

## Parser and corpus evidence

The current source-matched parser was rebuilt from source commit
`0ddd1c9b3a73ddeb358d4535953c970a474ad931`. Its four source-file hashes and
library hash are recorded in
`work/analysis/slices/S06-2-nested-fixture-manifest-20261013.json`. The
original resource inputs match all 2,267 pinned hashes. The parser read 2,078
SCEN resources (189 non-SCEN inputs), 19,612 actions, 11,089 typed actions,
8,523 opaque actions, and 17,050 typed dependency records. Every typed body
ends at its dependency stream; every dependency is 16 bytes and its eight
signed words match the raw parser bytes.

This current parser build reports 124 nested actions, including 58 that the
old tree evaluator marks unsupported. All 58 are present in the fixture
manifest with resource/action/description keys and opcode/record positions.
Their S06-2 leaves are 11:1, 13:66, 15:1 and 17:23. The older
`conditions-nested-validation.json` report remains unchanged and is labeled
historical: it pins a different parser library and reports 91 nested actions,
63 supported, and 28 excluded. S06-2 uses the source-matched current build and
does not overwrite that report.

## Build and verification

```sh
sh outputs/blackmoor-decomp/scripts/build_condition_extra.sh
python3 -m unittest outputs.blackmoor-decomp.tests.test_condition_extra -v
work/tools/oracle-python/bin/python -B \
  outputs/blackmoor-decomp/tests/condition_extra_original_oracle.py \
  --exe work/original/GAME.EXE \
  --native-library outputs/blackmoor-decomp/build/libconditionextra.dylib \
  --scene-library outputs/blackmoor-decomp/build/libsceneresource.dylib \
  --report work/analysis/slices/S06-2-condition-extra-original-oracle.json \
  --fixture-manifest work/analysis/slices/S06-2-nested-fixture-manifest-20261013.json
```

The 14 native tests pass. The oracle passes 390 direct original-vs-native leaf
comparisons, including 316 comparisons on raw leaves from the 58 real nested
actions; zero mismatches. Separately, the original x86 loader and evaluator
execute all 58 real nested actions. Those are original execution fixtures, not
native whole-tree parity comparisons: this slice does not own the tree
dispatcher. The direct leaf oracle maps the pinned PE and executes the
original leaf switch and sound helper. Only MSVC `rand` and the DirectSound
`GetStatus` vtable boundary are controlled; the sound helper body itself is
not stubbed. The nested-action oracle uses the existing bounded allocator and
diagnostic hooks.

The initial original comparison found one real mismatch: a cached opcode-20
leaf must leave the incoming status unchanged. The kernel and regression now
preserve that behavior. The private oracle report and test-first receipt record
the final native and evidence hashes.

## Explicit limits

- The shared tree evaluator still rejects these leaves until Boot/integration
  registers this module. No shared file was changed here.
- Opcode 3 remains unsupported; its indexed table extent and a live native
  producer are not established. No observed corpus record used opcode 3.
- The runtime threshold at node+0x20 is zero on the traced constructor/load
  path. Later writes outside the recovered constructor, load, reset and leaf
  windows remain an open cross-program question.
- Invalid native timer/channel indices are rejected to avoid original
  unchecked out-of-range reads; this is an intentional safety boundary, not
  original error behavior.
- Sound and CRT providers must be supplied by the owning runtime. Their
  platform implementation and whole-app state integration are not established
  by these isolated tests.
- The game loop, full nested tree dispatcher, post-tree global write, resource
  lifetime, and native gameplay are outside this slice.
