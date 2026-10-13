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
    SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE = 6
} SceneConditionStatus;

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
 * an action lifecycle requests a dependency reset.
 */
void scene_conditions_reset(SceneConditionTree *tree);

/* Evaluate supported opcodes 0 through 6 and 9 and reduce each branch independently.
 * A nonzero return identifies malformed input, out-of-range state indices, or
 * an unsupported leaf opcode. `unsupported_opcode` is optional and receives
 * the opcode when SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE is returned.
 */
int scene_conditions_evaluate(SceneConditionTree *tree,
                              const SceneConditionState *state,
                              int *satisfied,
                              uint16_t *unsupported_opcode);

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
