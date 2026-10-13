#include "scene_conditions.h"

#include <stdlib.h>
#include <string.h>

typedef enum scene_condition_node_kind {
    SCENE_CONDITION_BRANCH = 1,
    SCENE_CONDITION_LEAF = 2
} SceneConditionNodeKind;

typedef struct scene_condition_node {
    SceneConditionNodeKind kind;
    size_t parent;
    size_t first_child;
    size_t last_child;
    size_t next_sibling;
    size_t child_count;
    int16_t opcode;
    int16_t fields[8];
    int16_t or_after;
    int32_t status;
    int32_t time_value;
    int32_t time_end_value;
    size_t source_record;
} SceneConditionNode;

struct SceneConditionTree {
    SceneConditionNode *nodes;
    size_t node_count;
    size_t record_count;
    size_t root;
};

#define SCENE_CONDITION_NO_NODE SIZE_MAX

/* The original loader performs signed 32-bit arithmetic on x86. Express the
 * same modulo-2^32 operations with unsigned C, then decode two's-complement
 * without an out-of-range unsigned-to-signed conversion.
 */
static int32_t scene_condition_signed_from_bits(uint32_t value)
{
    if (value <= (uint32_t)INT32_MAX) {
        return (int32_t)value;
    }
    return -1 - (int32_t)(UINT32_MAX - value);
}

static uint32_t scene_condition_i16_bits(int16_t value)
{
    return (uint32_t)(int32_t)value;
}

static int32_t scene_condition_make_milliseconds(const int16_t fields[8])
{
    uint32_t value = scene_condition_i16_bits(fields[4]) * UINT32_C(3600000);
    value += scene_condition_i16_bits(fields[5]) * UINT32_C(60000);
    value += scene_condition_i16_bits(fields[6]) * UINT32_C(1000);
    value += scene_condition_i16_bits(fields[7]);
    return scene_condition_signed_from_bits(value);
}

static int32_t scene_condition_make_minutes(int16_t first, int16_t second)
{
    uint32_t value = scene_condition_i16_bits(first) * UINT32_C(60);
    value += scene_condition_i16_bits(second);
    return scene_condition_signed_from_bits(value);
}

static void scene_condition_init_node(SceneConditionNode *node,
                                     SceneConditionNodeKind kind,
                                     size_t parent,
                                     size_t source_record)
{
    memset(node, 0, sizeof(*node));
    node->kind = kind;
    node->parent = parent;
    node->first_child = SCENE_CONDITION_NO_NODE;
    node->last_child = SCENE_CONDITION_NO_NODE;
    node->next_sibling = SCENE_CONDITION_NO_NODE;
    node->source_record = source_record;
}

static void scene_condition_append_child(SceneConditionTree *tree,
                                         size_t parent_index,
                                         size_t child_index)
{
    SceneConditionNode *parent = &tree->nodes[parent_index];
    SceneConditionNode *child = &tree->nodes[child_index];
    child->parent = parent_index;
    if (parent->last_child == SCENE_CONDITION_NO_NODE) {
        parent->first_child = child_index;
    } else {
        tree->nodes[parent->last_child].next_sibling = child_index;
    }
    parent->last_child = child_index;
    ++parent->child_count;
}

int scene_conditions_build(const SceneDependencyInfo *records,
                           size_t record_count,
                           SceneConditionTree **tree_out)
{
    SceneConditionTree *tree;
    size_t parent_stack[SCENE_CONDITION_MAX_RECORDS + 1u];
    size_t stack_count = 1u;
    size_t record_index;

    if (tree_out == NULL) {
        return SCENE_CONDITION_ERR_ARGUMENT;
    }
    *tree_out = NULL;
    if (record_count > SCENE_CONDITION_MAX_RECORDS) {
        return SCENE_CONDITION_ERR_LIMIT;
    }
    if (record_count != 0u && records == NULL) {
        return SCENE_CONDITION_ERR_ARGUMENT;
    }

    tree = (SceneConditionTree *)calloc(1u, sizeof(*tree));
    if (tree == NULL) {
        return SCENE_CONDITION_ERR_MEMORY;
    }
    tree->nodes = (SceneConditionNode *)calloc(record_count + 1u,
                                                sizeof(*tree->nodes));
    if (tree->nodes == NULL) {
        free(tree);
        return SCENE_CONDITION_ERR_MEMORY;
    }
    tree->node_count = 1u;
    tree->record_count = record_count;
    tree->root = 0u;
    scene_condition_init_node(&tree->nodes[0], SCENE_CONDITION_BRANCH,
                              SCENE_CONDITION_NO_NODE, SCENE_CONDITION_NO_NODE);
    parent_stack[0] = tree->root;

    for (record_index = 0u; record_index < record_count; ++record_index) {
        const SceneDependencyInfo *record = &records[record_index];
        size_t parent_index = parent_stack[stack_count - 1u];
        size_t node_index;
        SceneConditionNode *node;

        if (record->or_after != record->fields[3]) {
            scene_conditions_destroy(tree);
            return SCENE_CONDITION_ERR_FORMAT;
        }
        if (record->opcode == 0x13u) {
            size_t opened_index;
            if (stack_count == 1u) {
                scene_conditions_destroy(tree);
                return SCENE_CONDITION_ERR_FORMAT;
            }
            opened_index = parent_stack[stack_count - 1u];
            node = &tree->nodes[opened_index];
            /* The original loader's preflight rejects a close marker at
             * opener+1 or opener+2: count source records, not tree children. */
            if ((record->or_after == 1) != node->or_after ||
                record_index <= node->source_record + 2u || node->child_count == 0u) {
                scene_conditions_destroy(tree);
                return SCENE_CONDITION_ERR_FORMAT;
            }
            --stack_count;
            continue;
        }

        if (record->opcode == 0x12u) {
            if (stack_count >= SCENE_CONDITION_MAX_RECORDS + 1u) {
                scene_conditions_destroy(tree);
                return SCENE_CONDITION_ERR_LIMIT;
            }
            node_index = tree->node_count++;
            node = &tree->nodes[node_index];
            scene_condition_init_node(node, SCENE_CONDITION_BRANCH,
                                      parent_index, record_index);
            node->opcode = (int16_t)record->opcode;
            /* 0x424aa8 normalizes parenthesis markers with == 1 before
             * matching the pair and storing the branch's OR marker. */
            node->or_after = (int16_t)(record->or_after == 1);
            memcpy(node->fields, record->fields, sizeof(node->fields));
            /* The loader initializes branch status to one. Evaluation replaces
             * it after the branch children have run.
             */
            node->status = 1;
            scene_condition_append_child(tree, parent_index, node_index);
            parent_stack[stack_count++] = node_index;
            continue;
        }

        node_index = tree->node_count++;
        node = &tree->nodes[node_index];
        scene_condition_init_node(node, SCENE_CONDITION_LEAF,
                                  parent_index, record_index);
        node->opcode = (int16_t)record->opcode;
        /* Leaf nodes use the same normalized OR marker as branch nodes;
         * fields[] still retains the original record words. */
        node->or_after = (int16_t)(record->or_after == 1);
        memcpy(node->fields, record->fields, sizeof(node->fields));
        if (node->opcode == 4 || node->opcode == 5) {
            node->time_value = scene_condition_make_milliseconds(node->fields);
        } else if (node->opcode == 6) {
            node->time_value = scene_condition_make_minutes(node->fields[4],
                                                            node->fields[5]);
            node->time_end_value = scene_condition_make_minutes(node->fields[6],
                                                                 node->fields[7]);
        }
        scene_condition_append_child(tree, parent_index, node_index);
    }

    if (stack_count != 1u) {
        scene_conditions_destroy(tree);
        return SCENE_CONDITION_ERR_FORMAT;
    }
    *tree_out = tree;
    return SCENE_CONDITION_OK;
}

void scene_conditions_destroy(SceneConditionTree *tree)
{
    if (tree != NULL) {
        free(tree->nodes);
        free(tree);
    }
}

void scene_conditions_reset(SceneConditionTree *tree)
{
    size_t index;
    if (tree == NULL) {
        return;
    }
    for (index = 0u; index < tree->node_count; ++index) {
        tree->nodes[index].status = 0;
    }
    if (tree->record_count == 0u) {
        tree->nodes[tree->root].status = 1;
    }
}

static int scene_condition_evaluate_leaf(SceneConditionNode *node,
                                         const SceneConditionState *state,
                                         uint16_t *unsupported_opcode)
{
    int16_t index = node->fields[1];
    int16_t expected = node->fields[2];

    switch (node->opcode) {
    case 0:
        node->status = 1;
        return SCENE_CONDITION_OK;
    case 1:
        if (index < 0 || (size_t)index >= state->inventory_count ||
            state->inventory_presence == NULL) {
            return SCENE_CONDITION_ERR_BOUNDS;
        }
        if ((expected == 1 &&
             (state->inventory_presence[index] == 1 ||
              state->selected_inventory_item == index)) ||
            (expected == 0 &&
             (state->inventory_presence[index] == 0 &&
              state->selected_inventory_item != index))) {
            node->status = 1;
        } else {
            node->status = 0;
        }
        return SCENE_CONDITION_OK;
    case 2:
        if (index < 0 || (size_t)index >= state->event_flag_count ||
            state->event_flags == NULL) {
            return SCENE_CONDITION_ERR_BOUNDS;
        }
        node->status = state->event_flags[index] == expected ? 1 : 0;
        return SCENE_CONDITION_OK;
    case 3:
        if (index < 0 || (size_t)index >= state->value_count ||
            state->value_table == NULL) {
            return SCENE_CONDITION_ERR_BOUNDS;
        }
        node->status = state->value_table[index] == expected ? 1 : 0;
        return SCENE_CONDITION_OK;
    case 4:
        node->status = state->timer_4_value >= node->time_value ? 1 : 0;
        return SCENE_CONDITION_OK;
    case 5:
        node->status = state->timer_5_value >= node->time_value ? 1 : 0;
        return SCENE_CONDITION_OK;
    case 6:
        switch (expected) {
        case 0:
            node->status = state->time_of_day_minutes >= node->time_value ? 1 : 0;
            return SCENE_CONDITION_OK;
        case 1:
            node->status = state->time_of_day_minutes <= node->time_value ? 1 : 0;
            return SCENE_CONDITION_OK;
        case 2:
            node->status = state->time_of_day_minutes == node->time_value ? 1 : 0;
            return SCENE_CONDITION_OK;
        case 3:
            if (node->time_end_value < node->time_value) {
                node->status = !((state->time_of_day_minutes < node->time_value ||
                                  state->time_of_day_minutes > 0x59f) &&
                                 (state->time_of_day_minutes < 0 ||
                                  node->time_end_value < state->time_of_day_minutes));
            } else {
                node->status = !(state->time_of_day_minutes < node->time_value ||
                                 node->time_end_value < state->time_of_day_minutes);
            }
            node->status = node->status != 0 ? 1 : 0;
            return SCENE_CONDITION_OK;
        default:
            return SCENE_CONDITION_ERR_FORMAT;
        }
    case 9: {
        int16_t visit_index = node->fields[4];
        int16_t visit_limit = node->fields[5];
        int16_t comparison = node->fields[7];
        int16_t visit_count;
        if (visit_index < 0 || (size_t)visit_index >= state->scene_visit_count ||
            state->scene_visit_counts == NULL) {
            return SCENE_CONDITION_ERR_BOUNDS;
        }
        visit_count = state->scene_visit_counts[visit_index];
        if (comparison == 1) {
            node->status = visit_count < visit_limit ? 1 : 0;
        } else if (comparison == 2) {
            node->status = visit_limit < visit_count ? 1 : 0;
        } else if (comparison == 3) {
            node->status = visit_count == visit_limit ? 1 : 0;
        } else {
            return SCENE_CONDITION_ERR_FORMAT;
        }
        return SCENE_CONDITION_OK;
    }
    default:
        if (unsupported_opcode != NULL) {
            *unsupported_opcode = (uint16_t)node->opcode;
        }
        return SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE;
    }
}

static int scene_condition_reduce_branch(SceneConditionTree *tree,
                                         size_t branch_index)
{
    SceneConditionNode *branch = &tree->nodes[branch_index];
    size_t index;
    size_t changed;
    size_t satisfied_count = 0u;

    if (branch->child_count == 0u) {
        branch->status = branch_index == tree->root ? 1 : 0;
        return SCENE_CONDITION_OK;
    }

    do {
        changed = 0u;
        index = branch->first_child;
        {
            size_t previous = SCENE_CONDITION_NO_NODE;
        while (index != SCENE_CONDITION_NO_NODE) {
            SceneConditionNode *node = &tree->nodes[index];
            if (node->parent != branch_index) {
                return SCENE_CONDITION_ERR_FORMAT;
            }
            if (previous != SCENE_CONDITION_NO_NODE &&
                tree->nodes[previous].or_after == 1) {
                SceneConditionNode *previous_node = &tree->nodes[previous];
                if (node->status == 0 && previous_node->status != 0) {
                    node->status = 1;
                    ++changed;
                } else if (node->status != 0 && previous_node->status == 0) {
                    previous_node->status = 1;
                    ++changed;
                }
            }
            if (node->next_sibling != SCENE_CONDITION_NO_NODE && node->or_after == 1) {
                SceneConditionNode *next_node = &tree->nodes[node->next_sibling];
                if (node->status == 0 && next_node->status != 0) {
                    node->status = 1;
                    ++changed;
                } else if (node->status != 0 && next_node->status == 0) {
                    next_node->status = 1;
                    ++changed;
                }
            }
            previous = index;
            index = node->next_sibling;
        }
        }
    } while (changed != 0u);

    index = branch->first_child;
    while (index != SCENE_CONDITION_NO_NODE) {
        if (tree->nodes[index].status != 0) {
            ++satisfied_count;
        }
        index = tree->nodes[index].next_sibling;
    }
    branch->status = satisfied_count == branch->child_count ? 1 : 0;
    return SCENE_CONDITION_OK;
}

static int scene_condition_evaluate_branch(SceneConditionTree *tree,
                                          size_t branch_index,
                                          const SceneConditionState *state,
                                          uint16_t *unsupported_opcode,
                                          size_t depth)
{
    SceneConditionNode *branch;
    size_t index;
    int status;

    if (depth > SCENE_CONDITION_MAX_RECORDS) {
        return SCENE_CONDITION_ERR_LIMIT;
    }
    branch = &tree->nodes[branch_index];
    index = branch->first_child;
    while (index != SCENE_CONDITION_NO_NODE) {
        SceneConditionNode *node = &tree->nodes[index];
        if (node->kind == SCENE_CONDITION_BRANCH) {
            status = scene_condition_evaluate_branch(tree, index, state,
                                                     unsupported_opcode,
                                                     depth + 1u);
        } else {
            status = scene_condition_evaluate_leaf(node, state,
                                                   unsupported_opcode);
        }
        if (status != SCENE_CONDITION_OK) {
            return status;
        }
        index = node->next_sibling;
    }
    return scene_condition_reduce_branch(tree, branch_index);
}

int scene_conditions_evaluate(SceneConditionTree *tree,
                              const SceneConditionState *state,
                              int *satisfied,
                              uint16_t *unsupported_opcode)
{
    int status;
    if (satisfied == NULL || tree == NULL) {
        return SCENE_CONDITION_ERR_ARGUMENT;
    }
    *satisfied = 0;
    if (unsupported_opcode != NULL) {
        *unsupported_opcode = 0u;
    }
    if (tree->record_count == 0u) {
        *satisfied = 1;
        tree->nodes[tree->root].status = 1;
        return SCENE_CONDITION_OK;
    }
    if (state == NULL) {
        return SCENE_CONDITION_ERR_ARGUMENT;
    }
    if ((state->inventory_count != 0u && state->inventory_presence == NULL) ||
        (state->event_flag_count != 0u && state->event_flags == NULL) ||
        (state->value_count != 0u && state->value_table == NULL) ||
        (state->scene_visit_count != 0u && state->scene_visit_counts == NULL)) {
        return SCENE_CONDITION_ERR_ARGUMENT;
    }
    status = scene_condition_evaluate_branch(tree, tree->root, state,
                                             unsupported_opcode, 0u);
    if (status != SCENE_CONDITION_OK) {
        return status;
    }
    *satisfied = tree->nodes[tree->root].status != 0 ? 1 : 0;
    return SCENE_CONDITION_OK;
}

const char *scene_conditions_status_string(int status)
{
    switch (status) {
    case SCENE_CONDITION_OK: return "ok";
    case SCENE_CONDITION_ERR_ARGUMENT: return "invalid argument";
    case SCENE_CONDITION_ERR_MEMORY: return "out of memory";
    case SCENE_CONDITION_ERR_FORMAT: return "invalid dependency record tree";
    case SCENE_CONDITION_ERR_LIMIT: return "dependency tree limit exceeded";
    case SCENE_CONDITION_ERR_BOUNDS: return "dependency state index out of bounds";
    case SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE: return "unsupported dependency opcode";
    default: return "unknown scene condition status";
    }
}
