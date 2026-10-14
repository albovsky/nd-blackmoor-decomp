#include "session_bindings_a51.h"

#include "action_core.h"

#include <stdlib.h>
#include <string.h>

typedef struct SessionA51Row {
    SessionA51RowState state;
    uint8_t *payload;
    size_t payload_length;
    int deferred_status;
} SessionA51Row;

struct SessionA51Binding {
    SessionA51Host host;
    ActionFamily51World world;
    SessionA51Row *rows;
    size_t row_count;
    int last_kernel_status;
};

SessionA51Binding *session_a51_create(const SessionA51Host *host)
{
    SessionA51Binding *binding;
    if (host == NULL) {
        return NULL;
    }
    binding = (SessionA51Binding *)calloc(1u, sizeof(*binding));
    if (binding == NULL) {
        return NULL;
    }
    binding->host = *host;
    return binding;
}

static void release_rows(SessionA51Binding *binding)
{
    size_t index;
    for (index = 0u; index < binding->row_count; ++index) {
        free(binding->rows[index].payload);
    }
    free(binding->rows);
    binding->rows = NULL;
    binding->row_count = 0u;
}

void session_a51_destroy(SessionA51Binding *binding)
{
    if (binding == NULL) {
        return;
    }
    release_rows(binding);
    free(binding);
}

int session_a51_begin_scene(SessionA51Binding *binding,
                            const SceneResource *scene,
                            size_t *failed_row,
                            int *kernel_status)
{
    SessionA51Row *rows = NULL;
    uint8_t *scratch = NULL;
    size_t count;
    size_t index;

    if (failed_row != NULL) {
        *failed_row = SIZE_MAX;
    }
    if (kernel_status != NULL) {
        *kernel_status = ACTION_FAMILY_51_OK;
    }
    if (binding == NULL || scene == NULL) {
        return SESSION_A51_ERR_ARGUMENT;
    }
    count = scene_resource_action_count(scene);
    if (count != 0u) {
        rows = (SessionA51Row *)calloc(count, sizeof(*rows));
        if (rows == NULL) {
            return SESSION_A51_ERR_MEMORY;
        }
    }
    scratch = (uint8_t *)malloc(ACTION_FAMILY_51_MAX_PAYLOAD_BYTES);
    if (scratch == NULL) {
        free(rows);
        return SESSION_A51_ERR_MEMORY;
    }

    for (index = 0u; index < count; ++index) {
        SceneActionInfo info;
        ActionFamily51Decoded decoded;
        int status;

        if (scene_resource_action_at(scene, index, &info) != SCENE_RESOURCE_OK) {
            status = ACTION_FAMILY_51_ERR_BODY;
        } else if (info.type != SESSION_A51_TYPE) {
            continue;
        } else if (info.typed_body == NULL) {
            status = ACTION_FAMILY_51_ERR_BODY;
        } else {
            /* Loader construction (0x40caac..0x40cf87), once per scene. */
            status = action_family_51_decode(
                info.typed_body, info.typed_body_length, binding->host.lookup,
                binding->host.lookup_context, scratch,
                ACTION_FAMILY_51_MAX_PAYLOAD_BYTES, &decoded);
        }
        if (status == ACTION_FAMILY_51_OK) {
            rows[index].payload = (uint8_t *)malloc(decoded.payload_length);
            if (rows[index].payload == NULL) {
                goto memory_failure;
            }
            memcpy(rows[index].payload, scratch, decoded.payload_length);
            rows[index].payload_length = decoded.payload_length;
            rows[index].state = SESSION_A51_ROW_READY;
        } else if (status == ACTION_FAMILY_51_ERR_UNSUPPORTED) {
            /* No AUTOTEXT provider: a named blocker if the row is visited. */
            rows[index].state = SESSION_A51_ROW_UNSUPPORTED;
            rows[index].deferred_status = status;
        } else {
            size_t other;
            for (other = 0u; other < count; ++other) {
                free(rows[other].payload);
            }
            free(rows);
            free(scratch);
            release_rows(binding);
            if (failed_row != NULL) {
                *failed_row = index;
            }
            if (kernel_status != NULL) {
                *kernel_status = status;
            }
            return SESSION_A51_ERR_SCENE;
        }
    }
    free(scratch);
    release_rows(binding);
    binding->rows = rows;
    binding->row_count = count;
    /* The world mirrors process globals (0x5bb226, 0x5b1606, 0x5b1602) that
     * persist across scenes, so it is zeroed only at creation. */
    binding->last_kernel_status = ACTION_FAMILY_51_OK;
    return SESSION_A51_OK;

memory_failure:
    for (index = 0u; index < count; ++index) {
        free(rows[index].payload);
    }
    free(rows);
    free(scratch);
    return SESSION_A51_ERR_MEMORY;
}

int session_a51_handler(void *context,
                        size_t action_index,
                        const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before,
                        SceneActionHandlerResult *result)
{
    SessionA51Binding *binding = (SessionA51Binding *)context;
    SessionA51Row *row;
    ActionFamily51Input input;
    ActionFamily51Result step;
    ActionCoreActionResult finish;
    int status;

    if (binding == NULL || action == NULL || state_before == NULL ||
        result == NULL || action->type != SESSION_A51_TYPE ||
        action_index >= binding->row_count) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    row = &binding->rows[action_index];
    if (row->state == SESSION_A51_ROW_UNSUPPORTED) {
        binding->last_kernel_status = row->deferred_status;
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (row->state != SESSION_A51_ROW_READY) {
        binding->last_kernel_status = ACTION_FAMILY_51_ERR_BODY;
        return SCENE_ACTION_HANDLER_ERROR;
    }

    memset(&input, 0, sizeof(input));
    input.type = action->type;
    input.subtype = action->subtype;
    input.eligible = 1u;
    input.completed_before = state_before->completed;
    input.phase_before = state_before->phase;
    input.payload = row->payload;
    input.payload_length = row->payload_length;

    if (binding->host.load_world != NULL) {
        binding->host.load_world(binding->host.world_context, &binding->world);
    }
    {
        /* The host backends (caption writer, close) mutate the shared caption
         * flags directly while the kernel runs on this private copy. Commit
         * only the fields the kernel itself changed, on top of the host's
         * post-step state, so backend side effects are not undone. */
        const ActionFamily51World before = binding->world;
        status = action_family_51_step(&input, &binding->world,
                                       &binding->host.backend, &step);
        if (binding->host.store_world != NULL) {
            ActionFamily51World merged = before;
            if (binding->host.load_world != NULL) {
                binding->host.load_world(binding->host.world_context, &merged);
            }
            if (binding->world.timer_deadline != before.timer_deadline)
                merged.timer_deadline = binding->world.timer_deadline;
            if (binding->world.frame_text_flag != before.frame_text_flag)
                merged.frame_text_flag = binding->world.frame_text_flag;
            if (binding->world.caption_finish_flag != before.caption_finish_flag)
                merged.caption_finish_flag = binding->world.caption_finish_flag;
            binding->host.store_world(binding->host.world_context, &merged);
            binding->world = merged;
        }
    }
    binding->last_kernel_status = status;
    if (status == ACTION_FAMILY_51_ERR_UNSUPPORTED) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (status != ACTION_FAMILY_51_OK || step.recognized == 0u) {
        return SCENE_ACTION_HANDLER_ERROR;
    }

    if (step.completion_called != 0u) {
        /* 0x42ba3a: the executor derives completion and the dependency reset
         * from the subtype; it must agree with the kernel. */
        memset(&finish, 0, sizeof(finish));
        if (action_core_finish_action(action->subtype, state_before->completed,
                                      &finish) != ACTION_CORE_OK ||
            finish.completed != step.completed ||
            (finish.reset_dependencies != 0u) !=
                (step.reset_dependencies != 0u)) {
            return SCENE_ACTION_HANDLER_ERROR;
        }
        result->disposition = SCENE_ACTION_HANDLER_COMPLETED;
        result->phase = 0u;
    } else {
        result->disposition = SCENE_ACTION_HANDLER_PENDING;
        result->phase = step.phase;
    }
    return SCENE_ACTION_HANDLER_OK;
}

int session_a51_last_kernel_status(const SessionA51Binding *binding)
{
    return binding == NULL ? ACTION_FAMILY_51_ERR_ARGUMENT
                           : binding->last_kernel_status;
}

SessionA51RowState session_a51_row_state(const SessionA51Binding *binding,
                                         size_t action_index)
{
    if (binding == NULL || action_index >= binding->row_count) {
        return SESSION_A51_ROW_NOT_A51;
    }
    return binding->rows[action_index].state;
}

int session_a51_record_renderer(const SessionA51Binding *binding,
                                size_t action_index)
{
    const SessionA51Row *row;
    if (binding == NULL || action_index >= binding->row_count) {
        return -1;
    }
    row = &binding->rows[action_index];
    if (row->state != SESSION_A51_ROW_READY || row->payload == NULL ||
        row->payload_length < 2u) {
        return -1;
    }
    return (int16_t)((uint16_t)row->payload[0] |
                     ((uint16_t)row->payload[1] << 8));
}

const ActionFamily51World *session_a51_world(const SessionA51Binding *binding)
{
    return binding == NULL ? NULL : &binding->world;
}
