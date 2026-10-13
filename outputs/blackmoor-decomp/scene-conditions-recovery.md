# Scene dependency conditions

`src/scene_conditions.[ch]` builds an ordered tree from the dependency records
used by the scene loader and evaluates the leaf opcodes verified so far. The
caller supplies live state, so the evaluator contains no scene-specific flag
values or S0 shortcuts.

## Record tree

Original loader `0x424aa8` treats record `0x12` as an opening parenthesis: it
adds a branch node to the current branch and descends into that node. Record
`0x13` checks the closing marker against the opener after normalizing both with
`== 1`, assigns that normalized marker to the
branch node, and resumes at the parent. Ordinary records are appended as
ordered children of the current branch. `0x42406d` then reduces only those
siblings, so OR links never cross a nested group boundary. The native builder
rejects unmatched markers and groups enclosing fewer than two source records
before evaluation, matching the original loader's preflight. A nested group
counts its own markers as source records in its parent group.

## Leaf conditions

| Opcode | Recovered behavior |
| --- | --- |
| 0 | Always true. |
| 1 | For inventory index `fields[1]`, condition 1 is true when the int32 presence slot equals 1 or that index is selected; condition 0 is true when the slot equals 0 and the index is not selected. Other condition values are false. |
| 2 | `event_flags[fields[1]] == fields[2]`. |
| 3 | `value_table[fields[1]] == fields[2]`. The table's game-facing name is not established yet. |
| 4 | `timer_4_value >= fields[4..7]` converted to signed milliseconds. |
| 5 | `timer_5_value >= fields[4..7]` converted to signed milliseconds. |
| 6 | Compares `time_of_day_minutes` to the minute value in fields 4–5: condition 0 means greater/equal, 1 less/equal, 2 equal. Condition 3 checks the inclusive interval in fields 4–5 through 6–7, including a midnight crossing. |
| 9 | Reads signed `scene_visit_counts[fields[4]]` and compares it to signed `fields[5]`: `fields[7]` 1 means `<`, 2 means `>`, and 3 means `==`. |

The comparison at `0x424346` reads opcode 1's presence state as int32 slots at
`0x00583bd5 + index * 4`. It also compares the selected item at `0x00583a29`.
Opcode 2 reads int32 values from `0x00585801`; opcode 3 reads int32 values
from `0x00581a71`. Scene visits for opcode 9 are signed 16-bit entries at
`0x00587b2d + scene_index * 2`. Opcode 9 is why S0's Sound9f dependency is
satisfied at zero visits: its record compares visits for scene 6400 against 1
using `<`.

Timer threshold arithmetic uses explicit modulo-2^32 operations followed by
signed interpretation, matching x86 signed 32-bit time comparisons without C
signed-overflow undefined behavior. For opcodes 0–6 and 9, `0x424201` calls
the evaluator for every leaf on each nonempty gate pass. The OR reducer may
temporarily raise zero leaf statuses to one; a later pass reevaluates those
leaves from current state. `scene_conditions_reset` also exposes the separate
reset path traced through `0x423d33` and `0x423da2`.

## Validation and limits

`tests/test_scene_conditions.py` covers all supported opcodes, signed time
boundaries, nested groups, record errors, explicit unsupported-opcode errors,
and the S0 Sound9f record shape. `tests/conditions_original_oracle.py` invokes
the original integer-only leaf function at `0x424346` in Unicorn. It compared
786 inputs for opcodes 0–6 and 9 with no mismatches; details are in
`conditions-original-validation.json`. The separate nested oracle executes the
original loader, tree evaluation, reduction and reset: 91 real nested actions
matched in construction, 63 supported actions matched across 315 evaluations,
and 80 synthetic truth-table assignments matched. The other 28 real actions
contain unsupported leaves and were construction-tested only. See
`conditions-nested-validation.md` for the hooks, scope and deliberate raw-field
retention difference. Neither oracle executes the full action runtime. Opcodes
outside 0–6 and 9 return an explicit unsupported-opcode status.

Build and run the native tests with:

```sh
outputs/blackmoor-decomp/scripts/build_scene_conditions.sh
python3 -m unittest outputs.blackmoor-decomp.tests.test_scene_conditions -v
```
