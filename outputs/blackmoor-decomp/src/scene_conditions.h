#ifndef BLACKMOOR_SCENE_CONDITIONS_H
#define BLACKMOOR_SCENE_CONDITIONS_H

#include <stddef.h>
#include <stdint.h>

#include "scene_resource.h"

#ifdef __cplusplus
extern "C" {
#endif

/* The original loader uses 512-entry parenthesis-marker arrays. */
#define SCENE_CONDITION_MAX_RECORDS 512u

typedef struct SceneConditionTree SceneConditionTree;

/* Values read by original dependency leaf opcodes 1 through 6. */
typedef struct scene_condition_state {
    /* Opcode 1 reads one signed 32-bit presence slot per item index. */
    const int32_t *inventory_presence;
    size_t inventory_count;
    int32_t selected_inventory_item;

    /* Opcode 2 event/logic flags; opcode 3's exact table name is unknown. */
    const int32_t *event_flags;
    size_t event_flag_count;
    const int32_t *value_table;
    size_t value_count;
    const int16_t *scene_visit_counts;
    size_t scene_visit_count;

    int32_t timer_4_value;
    int32_t timer_5_value;
    int32_t time_of_day_minutes;
} SceneConditionState;

typedef enum scene_condition_status {
    SCENE_CONDITION_OK = 0,
    SCENE_CONDITION_ERR_ARGUMENT = 1,
    SCENE_CONDITION_ERR_MEMORY = 2,
    SCENE_CONDITION_ERR_FORMAT = 3,
    SCENE_CONDITION_ERR_LIMIT = 4,
    SCENE_CONDITION_ERR_BOUNDS = 5,
    SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE = 6,
    /* RT-4: an extension leaf needs a host object or provider that the native
     * port does not have. Distinct from an observed false. */
    SCENE_CONDITION_ERR_HOST_UNAVAILABLE = 7,
    /* RT-4: an extension leaf provider failed; the failure record carries its
     * own status in provider_status. */
    SCENE_CONDITION_ERR_PROVIDER = 8
} SceneConditionStatus;

/* RT-4 extension leaves (opcodes outside 0 through 6 and 9).
 *
 * Original dependency leaf nodes are 0x4c-byte objects whose dwords +0x20
 * (runtime threshold, read by opcodes 13/14), +0x2c (opcode 20 evaluated
 * flag) and +0x30 (opcode 20 cached sample) persist between evaluations. The
 * tree keeps one such sidecar per node, zero-filled like the original
 * allocator, so the extension never owns per-node storage. Reset 0x423da2
 * clears only the +0x2c flag.
 */
typedef struct scene_condition_leaf_runtime {
    int32_t runtime_threshold_20;
    uint32_t random_cache_valid_2c;
    int32_t random_sample_30;
} SceneConditionLeafRuntime;

/* One leaf evaluation, delivered in source order. `record` carries the eight
 * signed words (raw_bytes is NULL). `leaf_identity` is stable for the life of
 * the tree. `selected_leaf_slot` is the tree's slot for the owning-root +0x24
 * pointer of opcode 11. `evaluation_mode` is the value 0x423f57 stores into
 * executor+0x614 for this evaluation. */
typedef struct scene_condition_leaf_request {
    SceneDependencyInfo record;
    size_t record_index;
    const void *leaf_identity;
    SceneConditionLeafRuntime *runtime;
    const void **selected_leaf_slot;
    const SceneConditionState *state;
    int32_t evaluation_mode;
} SceneConditionLeafRequest;

/* Evaluate one extension leaf. `*status_out` is preset to the node's current
 * status, so a leaf that leaves it untouched (opcode 20 once evaluated)
 * retains it as the original does. Return a SceneConditionStatus; use
 * SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE for an opcode the extension does not
 * own. `provider_status` (optional) receives a provider-specific detail. */
typedef int (*SceneConditionLeafFn)(void *context,
                                    const SceneConditionLeafRequest *request,
                                    int32_t *status_out,
                                    int *provider_status);

typedef struct scene_condition_extension {
    void *context;
    SceneConditionLeafFn evaluate_leaf;
    /* Called once per dispatcher pass, immediately before 0x427a50 runs
     * (the `mov [0x5c3a47], 1` at 0x43cf25). Optional. */
    void (*pass_started)(void *context);
    /* Called after every tree reduction completes, including the empty-tree
     * path, with the root status (0x423f57 stores `root == 0` into
     * 0x5c3a47). Not called when an evaluation fails. Optional. */
    void (*tree_evaluated)(void *context, int32_t root_status);
    /* Word at 0x5adb81 + 2 * index, read by the loader (0x425777..0x4257cb)
     * when it builds an opcode 13/14 leaf whose fields[6] is >= 5000. Called
     * once per such leaf when the tree is first armed (see
     * scene_conditions_resolve_thresholds). Return 1 with *value set, or 0
     * when the native port cannot source that word; the leaf then reports
     * SCENE_CONDITION_ERR_HOST_UNAVAILABLE instead of using a default.
     * Optional. */
    int (*read_variable_word)(void *context, int16_t index, int16_t *value);
} SceneConditionExtension;

typedef struct scene_condition_failure {
    uint16_t opcode;
    uint16_t reserved;
    size_t record_index;
    int provider_status;
} SceneConditionFailure;

/* Build the nested sibling tree encoded by dependency records 0x12 (open)
 * and 0x13 (close). Ordinary records become leaf siblings. The close record
 * must match its opener after each OR marker is normalized with == 1, as in
 * original 0x424aa8. A group must enclose at least two source records (an inner
 * group contributes its markers too). The returned tree owns its copy.
 */
int scene_conditions_build(const SceneDependencyInfo *records,
                           size_t record_count,
                           SceneConditionTree **tree);
void scene_conditions_destroy(SceneConditionTree *tree);

/* Clear retained branch/leaf results as original 0x423d33/0x423da2 do when
 * an action lifecycle requests a dependency reset.  scene_conditions_reset is
 * the entry 0x423d33; scene_conditions_reset_traversal is 0x423da2, the walk
 * that zeroes every node state and each leaf's evaluated flag.
 */
void scene_conditions_reset(SceneConditionTree *tree);
void scene_conditions_reset_traversal(SceneConditionTree *tree);

/* Evaluate supported opcodes 0 through 6 and 9 and reduce each branch independently.
 * A nonzero return identifies malformed input, out-of-range state indices, or
 * an unsupported leaf opcode. `unsupported_opcode` is optional and receives
 * the opcode when SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE is returned.
 */
int scene_conditions_evaluate(SceneConditionTree *tree,
                              const SceneConditionState *state,
                              int *satisfied,
                              uint16_t *unsupported_opcode);

/* The original loader (0x4257d6..0x42582b, 0x425746..0x4257d4) stores a
 * millisecond threshold into every leaf (dword +0x20) except opcodes 6 and 9:
 *   fields[4]*3600000 + fields[5]*60000 + fields[6]*1000 + fields[7]
 * (32-bit wrapping), except that an opcode 13/14 leaf with fields[6] >= 5000
 * replaces the fields[6]*1000 term by the signed word at 0x5adb81 +
 * 2*fields[6] times 1000. Opcodes 13/14 compare timer elapsed time against
 * this value. scene_conditions_build bakes everything that needs no table;
 * the table-dependent ones are resolved here, before the tree's first
 * evaluation (idempotent; scene_conditions_evaluate_ex calls it too). A word
 * the extension cannot source marks the leaf unavailable. */
void scene_conditions_resolve_thresholds(SceneConditionTree *tree,
                                         const SceneConditionExtension *extension);

/* Like scene_conditions_evaluate, with the RT-4 extension. `extension` may be
 * NULL (extension opcodes are then unsupported). `evaluation_mode` is the
 * value 0x423f57 stores at executor+0x614 for this call (see
 * scene_conditions_gate_mode_for_type). `failure` is optional and is zeroed
 * on entry. Leaves run in source order; a failing leaf stops the evaluation
 * with no rollback of earlier leaves' effects. */
int scene_conditions_evaluate_ex(SceneConditionTree *tree,
                                 const SceneConditionState *state,
                                 const SceneConditionExtension *extension,
                                 int32_t evaluation_mode,
                                 int *satisfied,
                                 uint16_t *unsupported_opcode,
                                 SceneConditionFailure *failure);

/* Mode that the dispatcher 0x427a50 passes to wrapper 0x423f57 for an action
 * whose slot type byte is `runtime_type`: 1 for types 0x0b, 0x0d, 0x16, 0x1a,
 * 0x1b, 0x1c, 0x33, 0x34, 0x36, 0x4d, 0x4e, 0x4f, 0x62, 0x63, 0x6a, 0x7a and
 * 0x99 (16 call sites), 0 for every other gate call site. The hotspot
 * candidate check at 0x43c019 always uses 0. */
int32_t scene_conditions_gate_mode_for_type(uint8_t runtime_type);

/* The tree's opcode-11 slot (original owning-root +0x24). Returns 1 and the
 * leaf's signed fields[1] when a selected-item leaf currently owns the slot,
 * else 0 and -1 (the result of accessor 0x424035). */
int scene_conditions_selected_item_label(const SceneConditionTree *tree,
                                         int32_t *label);

/* The loader's opcode-11 chain (container +0x30 count, accessor 0x42405a;
 * head leaf label via accessor 0x423fbb). The count is the number of
 * selected-item leaves in the tree; the first label is the first such leaf's
 * signed fields[1] in source order (returns 1) or -1 (returns 0). */
size_t scene_conditions_item_leaf_count(const SceneConditionTree *tree);
int scene_conditions_first_item_label(const SceneConditionTree *tree,
                                      int32_t *label);

const char *scene_conditions_status_string(int status);

#ifdef SCENE_EXECUTOR_TEST_HOOKS
/* Test-only visibility into retained reducer results. This is compiled only
 * into the executor test library, never into the native application. */
int scene_conditions_test_node_status(const SceneConditionTree *tree,
                                      size_t node_index,
                                      int32_t *out_status);
#endif

#ifdef __cplusplus
}
#endif

#endif
