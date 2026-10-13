# Nested dependency original oracle

Status: **pass**

GAME.EXE SHA-256: `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`
Native library SHA-256: `25ee97a3dd1efff7b984d61b59d624f7d74cc5d672f894fe495b9c95af7206c9`

The original loader accepted and built all 91 parsed nested actions. Native and original normalized topology matched for 91. Of those, 63 used only supported leaves and were evaluated across 315 state comparisons, including re-evaluation without reset and evaluation after both reset paths.

Synthetic marker and arity outcomes: 10 cases; constructor acceptance mismatches: 0. Nested truth tables: 80 assignments; mismatches: 0.
Synthetic constructor/truth-table topology mismatches: 0.
Leaf marker storage differences are recorded separately: 0 actual and 2 synthetic. The original stores `marker == 1` in its tree slot; native `fields[3]` retains the raw source marker while native `or_after` stores the effective boolean. The oracle makes no private object byte/layout parity claim.

Original code windows and byte hashes:

| Window | VA range (end exclusive) | Bytes | SHA-256 |
| --- | --- | ---: | --- |
| reset_entry | `0x00423d33..0x00423da2` | 111 | `b9d41f8f47db076f8a2c7eb1d5cc5e9bb66c8f1ba46e523063ad29f8f201f29e` |
| reset_traversal_window | `0x00423da2..0x00423f57` | 437 | `10997b2179aee62e2f79f3530559b786410d092428fb6f394a856d77af1d2160` |
| evaluate_wrapper_window | `0x00423f57..0x0042406d` | 278 | `9ce0473a9e37f26c1e586b5520b722fd5ed453b9acc113bbbe2528b777705c4b` |
| branch_reducer_window | `0x0042406d..0x00424201` | 404 | `9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07` |
| recursive_evaluator_window | `0x00424201..0x00424346` | 325 | `b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394` |
| leaf_evaluator_window | `0x00424346..0x00424aa8` | 1890 | `5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01` |
| dependency_loader_window | `0x00424aa8..0x00425b8b` | 4323 | `e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8` |

The original code executed in Unicorn includes loader `0x424aa8`, branch reducer `0x42406d`, leaf/tree evaluation `0x423f57`/`0x424201`/`0x424346`, and reset `0x423d33`/`0x423da2`. Only allocator `0x51dc43` and debug printer `0x425b8b` are skipped on accepted inputs. The malformed-tree hook stops at `0x425b40` only for constructor rejection cases.

One-leaf groups are explicitly included: the original loader rejects a close at opener offset +2, while an outer branch with one nested branch child is accepted when its enclosed source-record sequence extends beyond that preflight window.

Detailed hashes, counts, exclusions, and mismatch records are in `conditions-nested-validation.json`.
