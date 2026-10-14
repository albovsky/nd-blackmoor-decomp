#include "scene_session.h"

#include "action_family_28.h"
#include "action_family_51.h"
#include "action_family_62.h"
#include "action_sound.h"

#include <limits.h>
#include <stdlib.h>
#include <string.h>

#define SCENE_SESSION_MAX_BINDINGS 254u

enum {
    ACTION_TYPE_CONTROL = 0x1d,
    ACTION_TYPE_A28 = 0x28,
    ACTION_TYPE_A51 = 0x51,
    ACTION_TYPE_A62 = 0x62,
    ACTION_TYPE_PHONE = 0x82
};

typedef struct SceneSessionPreGateSlot {
    uint8_t type;
    SceneActionPreGateFn callback;
    void *context;
} SceneSessionPreGateSlot;

typedef struct SceneSessionBindingSlot {
    uint8_t present;
    SceneSessionProvider provider;
    SceneActionExternalHandler callback;
    void *context;
} SceneSessionBindingSlot;

struct SceneSession {
    SceneActionExecutor *executor;
    const SceneResource *scene;
    int32_t scene_id;
    ActionCoreWorld *action_core_world;
    SceneConditionState *conditions;
    ActionFamily64World *action64_world;
    ActionFamily64Backend *action64_backend;
    uint8_t (*phone_rows)[ACTION_UI_PHONE_RECORD_SIZE];
    size_t phone_capacity;
    ActionUIWorld action_ui;
    SceneSessionPrepareFn prepare_tick;
    SceneSessionMediaStepFn advance_media_one;
    void *provider_context;
    SceneAction64WorldCommitFn action64_world_commit_observer;
    void *action64_world_commit_context;
    SceneSessionBindingSlot bindings[256];
    SceneActionHandler executor_handlers[256];
    size_t executor_handler_count;
    SceneSessionPreGateSlot pre_gates[SCENE_EXECUTOR_MAX_PRE_GATES];
    size_t pre_gate_count;
    uint64_t tick_count;
    uint64_t scene_generation;
    int transition_pending;
    SceneTransitionRequest transition;
    int frozen;
    const SceneConditionExtension *condition_extension;
    SceneConditionFailure condition_failure;
    SceneSessionTickResult last_result;
    int last_ui_status;
    SceneSessionPointerHost pointer;
    int pointer_bound;
    SceneSessionPointerResult pointer_result;
};

static void clear_failure(SceneSessionFailure *failure)
{
    if (failure == NULL) return;
    memset(failure, 0, sizeof(*failure));
    failure->action_index = SIZE_MAX;
}

static SceneSessionProvider provider_for_type(uint8_t type)
{
    switch (type) {
    case ACTION_TYPE_A28: return SCENE_SESSION_PROVIDER_A28;
    case ACTION_TYPE_A51: return SCENE_SESSION_PROVIDER_CAPTION;
    case ACTION_TYPE_A62: return SCENE_SESSION_PROVIDER_A62;
    case ACTION_SOUND_TYPE: return SCENE_SESSION_PROVIDER_ACTION_SOUND;
    case ACTION_TYPE_PHONE:
    case ACTION_TYPE_CONTROL: return SCENE_SESSION_PROVIDER_ACTION_UI;
    case ACTION_FAMILY_64_TYPE: return SCENE_SESSION_PROVIDER_WORLD_CLOCK;
    default: return SCENE_SESSION_PROVIDER_ACTION_KERNEL;
    }
}

static SceneSessionCallbackStatus block_missing(
    SceneSessionFailure *failure,
    SceneSessionStage stage,
    SceneSessionProvider provider,
    int detail)
{
    if (failure != NULL) {
        clear_failure(failure);
        failure->stage = stage;
        failure->provider = provider;
        failure->detail_status = detail;
    }
    return SCENE_SESSION_CALLBACK_BLOCKED;
}

static int ui_action_handler(void *context,
                             size_t action_index,
                             const SceneActionInfo *action,
                             const SceneActionRuntimeState *before,
                             SceneActionHandlerResult *result)
{
    SceneSession *session = (SceneSession *)context;
    ActionUIActionResult ui_result;
    (void)action_index;
    if (session == NULL || action == NULL || before == NULL || result == NULL) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    session->last_ui_status = action_ui_dispatch(
        &session->action_ui, action->type, action->subtype,
        action->typed_body, action->typed_body_length, before->phase,
        &ui_result);
    if (session->last_ui_status != ACTION_UI_OK) {
        return session->last_ui_status == ACTION_UI_ERR_UNSUPPORTED
                   ? SCENE_ACTION_HANDLER_UNSUPPORTED
                   : SCENE_ACTION_HANDLER_ERROR;
    }
    result->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
    result->phase = ui_result.phase;
    return SCENE_ACTION_HANDLER_OK;
}

static int build_executor(SceneSession *session,
                          const SceneResource *scene,
                          SceneActionExecutor **out_executor,
                          SceneSessionFailure *failure)
{
    size_t failed_index = SIZE_MAX;
    int status = scene_executor_create(scene, session->action_core_world, 0u,
                                       out_executor, &failed_index);
    if (status != SCENE_EXECUTOR_OK) {
        if (failure != NULL) {
            clear_failure(failure);
            failure->stage = SCENE_SESSION_STAGE_SCENE_REPLACE;
            failure->provider = status == SCENE_EXECUTOR_ERR_MEMORY
                                   ? SCENE_SESSION_PROVIDER_HOST
                                   : SCENE_SESSION_PROVIDER_SCENE_RESOURCE;
            failure->action_index = failed_index;
            failure->detail_status = status;
            if (failed_index != SIZE_MAX) {
                SceneActionInfo action;
                if (scene_resource_action_at(scene, failed_index, &action) ==
                    SCENE_RESOURCE_OK) {
                    failure->action_type = action.type;
                }
            }
        }
        return status;
    }
    if ((session->action64_world == NULL) !=
        (session->action64_backend == NULL)) {
        scene_executor_destroy(*out_executor);
        *out_executor = NULL;
        if (failure != NULL) {
            clear_failure(failure);
            failure->stage = SCENE_SESSION_STAGE_SCENE_REPLACE;
            failure->provider = SCENE_SESSION_PROVIDER_WORLD_CLOCK;
            failure->detail_status = SCENE_EXECUTOR_ERR_ARGUMENT;
        }
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    if (session->action64_world != NULL) {
        status = scene_executor_bind_action64_runtime(*out_executor,
            session->action64_world, session->action64_backend);
        if (status != SCENE_EXECUTOR_OK) {
            scene_executor_destroy(*out_executor);
            *out_executor = NULL;
            if (failure != NULL) {
                clear_failure(failure);
                failure->stage = SCENE_SESSION_STAGE_SCENE_REPLACE;
                failure->provider = SCENE_SESSION_PROVIDER_WORLD_CLOCK;
                failure->detail_status = status;
            }
            return status;
        }
    }
    {
        size_t gate;
        for (gate = 0u; gate < session->pre_gate_count; ++gate) {
            status = scene_executor_set_pre_gate(*out_executor,
                session->pre_gates[gate].type,
                session->pre_gates[gate].callback,
                session->pre_gates[gate].context);
            if (status != SCENE_EXECUTOR_OK) {
                scene_executor_destroy(*out_executor);
                *out_executor = NULL;
                if (failure != NULL) {
                    clear_failure(failure);
                    failure->stage = SCENE_SESSION_STAGE_SCENE_REPLACE;
                    failure->provider = SCENE_SESSION_PROVIDER_HOST;
                    failure->detail_status = status;
                }
                return status;
            }
        }
    }
    status = scene_executor_set_condition_extension(
        *out_executor, session->condition_extension);
    if (status != SCENE_EXECUTOR_OK) {
        scene_executor_destroy(*out_executor);
        *out_executor = NULL;
        if (failure != NULL) {
            clear_failure(failure);
            failure->stage = SCENE_SESSION_STAGE_SCENE_REPLACE;
            failure->provider = SCENE_SESSION_PROVIDER_DEPENDENCY;
            failure->detail_status = status;
        }
        return status;
    }
    if (session->action64_world_commit_observer != NULL) {
        status = scene_executor_set_action64_world_commit_observer(*out_executor,
            session->action64_world_commit_observer,
            session->action64_world_commit_context);
        if (status != SCENE_EXECUTOR_OK) {
            scene_executor_destroy(*out_executor);
            *out_executor = NULL;
            if (failure != NULL) {
                clear_failure(failure);
                failure->stage = SCENE_SESSION_STAGE_SCENE_REPLACE;
                failure->provider = SCENE_SESSION_PROVIDER_WORLD_CLOCK;
                failure->detail_status = status;
            }
            return status;
        }
    }
    return SCENE_EXECUTOR_OK;
}

static int reserve_phone_rows(SceneSession *session, size_t required)
{
    uint8_t (*replacement)[ACTION_UI_PHONE_RECORD_SIZE];
    if (required <= session->phone_capacity) return 1;
    if (required > SIZE_MAX / ACTION_UI_PHONE_RECORD_SIZE) return 0;
    replacement = (uint8_t (*)[ACTION_UI_PHONE_RECORD_SIZE])realloc(
        session->phone_rows, required * ACTION_UI_PHONE_RECORD_SIZE);
    if (replacement == NULL) return 0;
    session->phone_rows = replacement;
    session->phone_capacity = required;
    session->action_ui.phone_records = replacement;
    session->action_ui.phone_capacity = required;
    return 1;
}

int scene_session_create(const SceneSessionConfig *config,
                         SceneSession **out_session,
                         SceneSessionFailure *failure)
{
    SceneSession *session;
    size_t scene_actions;
    size_t required_phone_capacity;
    size_t index;
    int status;
    if (out_session != NULL) *out_session = NULL;
    clear_failure(failure);
    if (config == NULL || out_session == NULL || config->scene == NULL ||
        config->action_core_world == NULL || config->conditions == NULL ||
        (config->action_core_world->event_flag_count != 0u &&
         config->action_core_world->event_flags == NULL) ||
        config->conditions->event_flags != config->action_core_world->event_flags ||
        config->conditions->event_flag_count !=
            config->action_core_world->event_flag_count ||
        (config->initial_phone_count != 0u &&
         config->initial_phone_rows == NULL) ||
        (config->action_binding_count != 0u &&
         config->action_bindings == NULL) ||
        (config->action64_world_commit_observer != NULL &&
         (config->action64_world == NULL ||
          config->action64_backend == NULL)) ||
        config->action_binding_count > SCENE_SESSION_MAX_BINDINGS) {
        return SCENE_SESSION_ERR_ARGUMENT;
    }
    scene_actions = scene_resource_action_count(config->scene);
    if (config->initial_phone_count > SIZE_MAX - scene_actions) {
        return SCENE_SESSION_ERR_ARGUMENT;
    }
    required_phone_capacity = config->initial_phone_count + scene_actions;
    session = (SceneSession *)calloc(1u, sizeof(*session));
    if (session == NULL) return SCENE_SESSION_ERR_MEMORY;
    session->scene = config->scene;
    session->scene_id = config->scene_id;
    session->action_core_world = config->action_core_world;
    session->conditions = config->conditions;
    session->action64_world = config->action64_world;
    session->action64_backend = config->action64_backend;
    session->prepare_tick = config->prepare_tick;
    session->advance_media_one = config->advance_media_one;
    session->provider_context = config->provider_context;
    session->action64_world_commit_observer =
        config->action64_world_commit_observer;
    session->action64_world_commit_context =
        config->action64_world_commit_context;
    session->scene_generation = 1u;
    session->action_ui.phone_records = NULL;
    session->action_ui.phone_capacity = 0u;
    if (!reserve_phone_rows(session, required_phone_capacity)) {
        free(session);
        return SCENE_SESSION_ERR_MEMORY;
    }
    session->action_ui.phone_records = session->phone_rows;
    session->action_ui.phone_capacity = session->phone_capacity;
    status = action_ui_initialize_controls(&session->action_ui);
    if (status != ACTION_UI_OK) {
        free(session->phone_rows);
        free(session);
        return SCENE_SESSION_ERR_STATE;
    }
    status = action_ui_initialize_phone(&session->action_ui,
        config->initial_phone_rows, config->initial_phone_count);
    if (status != ACTION_UI_OK) {
        free(session->phone_rows);
        free(session);
        if (failure != NULL) {
            failure->stage = SCENE_SESSION_STAGE_SCENE_REPLACE;
            failure->provider = SCENE_SESSION_PROVIDER_ACTION_UI;
            failure->detail_status = status;
        }
        return status == ACTION_UI_ERR_PHONE_CAPACITY
                   ? SCENE_SESSION_ERR_MEMORY : SCENE_SESSION_ERR_ARGUMENT;
    }
    session->bindings[ACTION_TYPE_PHONE].present = 1u;
    session->bindings[ACTION_TYPE_PHONE].provider = SCENE_SESSION_PROVIDER_ACTION_UI;
    session->bindings[ACTION_TYPE_PHONE].callback = ui_action_handler;
    session->bindings[ACTION_TYPE_PHONE].context = session;
    session->bindings[ACTION_TYPE_CONTROL].present = 1u;
    session->bindings[ACTION_TYPE_CONTROL].provider = SCENE_SESSION_PROVIDER_ACTION_UI;
    session->bindings[ACTION_TYPE_CONTROL].callback = ui_action_handler;
    session->bindings[ACTION_TYPE_CONTROL].context = session;
    for (index = 0u; index < config->action_binding_count; ++index) {
        const SceneSessionActionBinding *binding = &config->action_bindings[index];
        if (binding->callback == NULL || binding->type == ACTION_TYPE_PHONE ||
            binding->type == ACTION_TYPE_CONTROL || binding->type == 0x0au ||
            binding->type == 0x4du || binding->type == 0x61u ||
            binding->type == 0x64u || binding->type == 0x6au ||
            binding->type == 0x6bu || binding->type == 0x71u ||
            binding->type == 0x15u ||
            session->bindings[binding->type].present) {
            free(session->phone_rows);
            free(session);
            return SCENE_SESSION_ERR_ARGUMENT;
        }
        session->bindings[binding->type].present = 1u;
        session->bindings[binding->type].provider = binding->provider;
        session->bindings[binding->type].callback = binding->callback;
        session->bindings[binding->type].context = binding->context;
    }
    for (index = 0u; index < 256u; ++index) {
        if (session->bindings[index].present) {
            SceneActionHandler *handler =
                &session->executor_handlers[session->executor_handler_count++];
            handler->type = (uint8_t)index;
            handler->callback = session->bindings[index].callback;
            handler->context = session->bindings[index].context;
        }
    }
    status = build_executor(session, config->scene, &session->executor, failure);
    if (status != SCENE_EXECUTOR_OK) {
        free(session->phone_rows);
        free(session);
        return status == SCENE_EXECUTOR_ERR_MEMORY
                   ? SCENE_SESSION_ERR_MEMORY : SCENE_SESSION_ERR_EXECUTOR;
    }
    *out_session = session;
    return SCENE_SESSION_OK;
}

void scene_session_destroy(SceneSession *session)
{
    if (session == NULL) return;
    /* Executor borrows the current scene, world, clock/backend and callback
     * contexts. Release it before the session's owned UI table. */
    scene_executor_destroy(session->executor);
    session->executor = NULL;
    free(session->phone_rows);
    session->phone_rows = NULL;
    free(session);
}

static void freeze_result(SceneSession *session,
                          SceneSessionTickResult *result,
                          SceneSessionStatus status,
                          const SceneSessionFailure *failure)
{
    result->status = status;
    if (failure != NULL) result->failure = *failure;
    session->frozen = 1;
    session->last_result = *result;
}

/* 4d3073 -> 4f0059: offer every hit-testable row, ascending, to the host. */
static int pointer_scan(SceneSession *session)
{
    SessionInputHotspot rows[SCENE_EXECUTOR_MAX_ACTIONS];
    size_t count = 0u;
    size_t actions = scene_resource_action_count(session->scene);
    size_t index;
    int32_t candidate = -1;
    int status;
    if (actions > SCENE_EXECUTOR_MAX_ACTIONS) actions = SCENE_EXECUTOR_MAX_ACTIONS;
    for (index = 0u; index < actions; ++index) {
        SceneExecutorHotspotState hotspot;
        SessionInputHotspot row;
        memset(&row, 0, sizeof(row));
        if (scene_executor_get_hotspot_state(session->executor, index, &hotspot) ==
                SCENE_EXECUTOR_OK && hotspot.active && hotspot.rectangle_valid) {
            row.index = (int32_t)index;
            row.rectangle.left = hotspot.left;
            row.rectangle.top = hotspot.top;
            row.rectangle.right = hotspot.right;
            row.rectangle.bottom = hotspot.bottom;
            row.active = 1u;
            rows[count++] = row;
        } else if (session->pointer.external_row != NULL &&
                   session->pointer.external_row(session->pointer.context, index, &row) == 1) {
            row.index = (int32_t)index;
            rows[count++] = row;
        }
    }
    status = session->pointer.scan(session->pointer.context, rows, count, &candidate);
    session->pointer_result.scan_status = status;
    session->pointer_result.scan_rows = (uint32_t)count;
    session->pointer_result.candidate_after_scan = status == SESSION_INPUT_OK ? candidate : -1;
    return status;
}

int scene_session_tick(SceneSession *session,
                       SceneSessionTickResult *result)
{
    SceneSessionTickResult local;
    SceneExecutorFrameInput frame_input;
    SceneSessionFailure failure;
    SceneSessionCallbackStatus callback_status;
    int executor_status;
    if (session == NULL || result == NULL) return SCENE_SESSION_ERR_ARGUMENT;
    if (session->frozen || session->transition_pending) {
        *result = session->last_result;
        return result->status;
    }
    if (session->tick_count == UINT64_MAX) return SCENE_SESSION_ERR_STATE;
    memset(&local, 0, sizeof(local));
    clear_failure(&local.failure);
    clear_failure(&failure);
    memset(&frame_input, 0, sizeof(frame_input));
    local.tick_index = ++session->tick_count;
    local.scene_generation = session->scene_generation;
    memset(&session->pointer_result, 0, sizeof(session->pointer_result));
    session->pointer_result.tick_index = local.tick_index;
    session->pointer_result.consume_status = -1;
    session->pointer_result.scan_status = -1;
    session->pointer_result.candidate_at_consume = -1;
    session->pointer_result.candidate_after_scan = -1;

    local.prepare_attempted = 1u;
    if (session->prepare_tick == NULL) {
        callback_status = block_missing(&failure, SCENE_SESSION_STAGE_PREPARE,
            SCENE_SESSION_PROVIDER_WORLD_CLOCK, SCENE_SESSION_ERR_STATE);
    } else {
        callback_status = session->prepare_tick(session->provider_context,
            session->conditions, &frame_input, &failure);
    }
    if (callback_status != SCENE_SESSION_CALLBACK_OK) {
        if (failure.provider == SCENE_SESSION_PROVIDER_NONE) {
            failure.stage = SCENE_SESSION_STAGE_PREPARE;
            failure.provider = SCENE_SESSION_PROVIDER_HOST;
            failure.action_index = SIZE_MAX;
        }
        freeze_result(session, &local,
            callback_status == SCENE_SESSION_CALLBACK_BLOCKED
                ? SCENE_SESSION_BLOCKED : SCENE_SESSION_ERR_STATE,
            &failure);
        *result = session->last_result;
        return result->status;
    }
    if (session->conditions->event_flags !=
            session->action_core_world->event_flags ||
        session->conditions->event_flag_count !=
            session->action_core_world->event_flag_count ||
        (session->conditions->event_flag_count != 0u &&
         session->conditions->event_flags == NULL)) {
        block_missing(&failure, SCENE_SESSION_STAGE_PREPARE,
            SCENE_SESSION_PROVIDER_HOST, SCENE_SESSION_ERR_ARGUMENT);
        freeze_result(session, &local, SCENE_SESSION_BLOCKED, &failure);
        *result = session->last_result;
        return result->status;
    }
    local.prepare_succeeded = 1u;

    local.media_attempted = 1u;
    if (session->advance_media_one == NULL) {
        callback_status = block_missing(&failure, SCENE_SESSION_STAGE_MEDIA,
            SCENE_SESSION_PROVIDER_MEDIA, SCENE_SESSION_ERR_STATE);
    } else {
        callback_status = session->advance_media_one(session->provider_context,
            &frame_input, &failure);
    }
    if (callback_status != SCENE_SESSION_CALLBACK_OK) {
        if (failure.provider == SCENE_SESSION_PROVIDER_NONE) {
            failure.stage = SCENE_SESSION_STAGE_MEDIA;
            failure.provider = SCENE_SESSION_PROVIDER_HOST;
            failure.action_index = SIZE_MAX;
        }
        freeze_result(session, &local,
            callback_status == SCENE_SESSION_CALLBACK_BLOCKED
                ? SCENE_SESSION_BLOCKED : SCENE_SESSION_ERR_STATE,
            &failure);
        *result = session->last_result;
        return result->status;
    }
    local.media_succeeded = 1u;

    if (session->pointer_bound) {
        int32_t candidate = -1;
        int pointer_status;
        /* The input module owns these members while it is bound. */
        frame_input.pointer_x = 0;
        frame_input.pointer_y = 0;
        frame_input.pointer_valid = 0u;
        frame_input.cursor_context_allowed = 0u;
        frame_input.modal_event_active = 0u;
        frame_input.hotspot_activation_event = 0u;
        frame_input.activation_candidate_valid = 0u;
        frame_input.activation_candidate = 0;
        session->pointer_result.consume_status =
            pointer_status = session->pointer.consume(session->pointer.context,
                                                      &frame_input, &candidate);
        if (pointer_status != SESSION_INPUT_OK &&
            pointer_status != SESSION_INPUT_LIMIT_CURSOR_GEOMETRY &&
            pointer_status != SESSION_INPUT_LIMIT_PRIORITY_PATH) {
            block_missing(&failure, SCENE_SESSION_STAGE_POINTER,
                SCENE_SESSION_PROVIDER_POINTER_INPUT, pointer_status);
            freeze_result(session, &local, SCENE_SESSION_BLOCKED, &failure);
            *result = session->last_result;
            return result->status;
        }
        session->pointer_result.candidate_at_consume = candidate;
        if (pointer_status != SESSION_INPUT_OK) {
            /* A projection limit consumed the edge; nothing may activate. */
            frame_input.hotspot_activation_event = 0u;
        }
        if (candidate >= 0) {
            frame_input.activation_candidate_valid = 1u;
            frame_input.activation_candidate = candidate;
        }
        session->pointer_result.activation_event = frame_input.hotspot_activation_event;
        session->pointer_result.activation_candidate_valid =
            frame_input.activation_candidate_valid;
    }

    local.dispatch_attempted = 1u;
    executor_status = scene_executor_step_frame(session->executor,
        session->conditions, session->executor_handlers,
        session->executor_handler_count, &frame_input, &local.executor);
    if (executor_status != SCENE_EXECUTOR_OK) {
        clear_failure(&failure);
        failure.stage = SCENE_SESSION_STAGE_DISPATCH;
        failure.action_index = local.executor.failed_action_index;
        failure.action_type = local.executor.failed_action_type;
        failure.detail_status = local.executor.detail_status;
        failure.provider = provider_for_type(local.executor.failed_action_type);
        /* The executor zeroes this record on every successful evaluation, so
         * it is nonzero only when the freeze came from a dependency leaf. */
        (void)scene_executor_get_condition_failure(session->executor,
                                                   &session->condition_failure);
        if (session->condition_failure.opcode != 0u &&
            (executor_status == SCENE_EXECUTOR_ERR_UNSUPPORTED ||
             executor_status == SCENE_EXECUTOR_ERR_CONDITION)) {
            /* A dependency leaf stopped the evaluation (the record is only
             * nonzero then); detail_status stays the SceneConditionStatus. */
            failure.provider = SCENE_SESSION_PROVIDER_DEPENDENCY;
        } else if (local.executor.failed_action_type == ACTION_TYPE_PHONE ||
                   local.executor.failed_action_type == ACTION_TYPE_CONTROL) {
            failure.provider = SCENE_SESSION_PROVIDER_ACTION_UI;
        } else if (session->bindings[local.executor.failed_action_type].present) {
            failure.provider = session->bindings[local.executor.failed_action_type].provider;
        }
        if (local.executor.failed_action_type == ACTION_TYPE_PHONE ||
            local.executor.failed_action_type == ACTION_TYPE_CONTROL) {
            failure.detail_status = session->last_ui_status;
        }
        freeze_result(session, &local,
            executor_status == SCENE_EXECUTOR_ERR_UNSUPPORTED
                ? SCENE_SESSION_BLOCKED : SCENE_SESSION_ERR_EXECUTOR,
            &failure);
        *result = session->last_result;
        return result->status;
    }
    local.dispatch_succeeded = 1u;
    if (local.executor.kind == SCENE_EXECUTOR_STEP_TRANSITION) {
        session->transition_pending = 1;
        session->transition = local.executor.transition;
        local.status = SCENE_SESSION_TRANSITION_PENDING;
        local.failure.provider = SCENE_SESSION_PROVIDER_NONE;
        session->last_result = local;
        *result = local;
        return local.status;
    }
    if (session->pointer_bound) {
        int scan_status = pointer_scan(session);
        if (scan_status != SESSION_INPUT_OK &&
            scan_status != SESSION_INPUT_LIMIT_CURSOR_GEOMETRY &&
            scan_status != SESSION_INPUT_LIMIT_PRIORITY_PATH) {
            block_missing(&failure, SCENE_SESSION_STAGE_POINTER,
                SCENE_SESSION_PROVIDER_POINTER_INPUT, scan_status);
            freeze_result(session, &local, SCENE_SESSION_BLOCKED, &failure);
            *result = session->last_result;
            return result->status;
        }
    }
    local.status = SCENE_SESSION_OK;
    session->last_result = local;
    *result = local;
    return local.status;
}

int scene_session_replace_scene(SceneSession *session,
                                const SceneResource *scene,
                                int32_t scene_id,
                                SceneSessionFailure *failure)
{
    SceneActionExecutor *candidate = NULL;
    SceneActionExecutor *old_executor;
    size_t phone_need;
    size_t action_count;
    int status;
    clear_failure(failure);
    if (session == NULL || scene == NULL || session->frozen ||
        session->scene_generation == UINT64_MAX) {
        return SCENE_SESSION_ERR_STATE;
    }
    if (session->transition_pending &&
        scene_id != (int32_t)session->transition.target_scene) {
        if (failure != NULL) {
            failure->stage = SCENE_SESSION_STAGE_SCENE_REPLACE;
            failure->provider = SCENE_SESSION_PROVIDER_SCENE_RESOURCE;
            failure->action_index = SIZE_MAX;
            failure->detail_status = SCENE_SESSION_ERR_ARGUMENT;
        }
        return SCENE_SESSION_ERR_ARGUMENT;
    }
    action_count = scene_resource_action_count(scene);
    if (session->action_ui.phone_count > SIZE_MAX - action_count) {
        if (failure != NULL) {
            failure->stage = SCENE_SESSION_STAGE_SCENE_REPLACE;
            failure->provider = SCENE_SESSION_PROVIDER_HOST;
            failure->detail_status = SCENE_SESSION_ERR_MEMORY;
        }
        return SCENE_SESSION_ERR_MEMORY;
    }
    phone_need = session->action_ui.phone_count + action_count;
    if (!reserve_phone_rows(session, phone_need)) {
        if (failure != NULL) {
            failure->stage = SCENE_SESSION_STAGE_SCENE_REPLACE;
            failure->provider = SCENE_SESSION_PROVIDER_HOST;
            failure->detail_status = SCENE_SESSION_ERR_MEMORY;
        }
        return SCENE_SESSION_ERR_MEMORY;
    }
    status = build_executor(session, scene, &candidate, failure);
    if (status != SCENE_EXECUTOR_OK) {
        return status == SCENE_EXECUTOR_ERR_MEMORY
                   ? SCENE_SESSION_ERR_MEMORY : SCENE_SESSION_ERR_EXECUTOR;
    }
    /* Latch constructor 0x4dad60 + candidate -1 (the loaders 0x435015,
     * 0x4381f4 and 0x43dbe3 all run it). The candidate executor is complete,
     * so a failing reset can still refuse the replacement unchanged. */
    if (session->pointer_bound &&
        session->pointer.reset(session->pointer.context) != SESSION_INPUT_OK) {
        scene_executor_destroy(candidate);
        if (failure != NULL) {
            failure->stage = SCENE_SESSION_STAGE_POINTER;
            failure->provider = SCENE_SESSION_PROVIDER_POINTER_INPUT;
            failure->action_index = SIZE_MAX;
            failure->detail_status = SESSION_INPUT_INVALID_ARGUMENT;
        }
        return SCENE_SESSION_ERR_STATE;
    }
    old_executor = session->executor;
    session->executor = candidate;
    session->scene = scene;
    session->scene_id = scene_id;
    session->scene_generation++;
    session->transition_pending = 0;
    memset(&session->transition, 0, sizeof(session->transition));
    memset(&session->last_result, 0, sizeof(session->last_result));
    session->last_result.status = SCENE_SESSION_OK;
    session->last_result.scene_generation = session->scene_generation;
    memset(&session->pointer_result, 0, sizeof(session->pointer_result));
    session->pointer_result.consume_status = -1;
    session->pointer_result.scan_status = -1;
    session->pointer_result.candidate_at_consume = -1;
    session->pointer_result.candidate_after_scan = -1;
    scene_executor_destroy(old_executor);
    return SCENE_SESSION_OK;
}

int scene_session_set_pre_gate(SceneSession *session,
                               uint8_t type,
                               SceneActionPreGateFn callback,
                               void *context)
{
    size_t index;
    int status;
    if (session == NULL || session->executor == NULL || callback == NULL ||
        session->pre_gate_count >= SCENE_EXECUTOR_MAX_PRE_GATES) {
        return SCENE_SESSION_ERR_ARGUMENT;
    }
    for (index = 0u; index < session->pre_gate_count; ++index) {
        if (session->pre_gates[index].type == type) {
            return SCENE_SESSION_ERR_ARGUMENT;
        }
    }
    status = scene_executor_set_pre_gate(session->executor, type, callback,
                                         context);
    if (status != SCENE_EXECUTOR_OK) return SCENE_SESSION_ERR_EXECUTOR;
    session->pre_gates[session->pre_gate_count].type = type;
    session->pre_gates[session->pre_gate_count].callback = callback;
    session->pre_gates[session->pre_gate_count].context = context;
    ++session->pre_gate_count;
    return SCENE_SESSION_OK;
}

int scene_session_set_condition_extension(
    SceneSession *session, const SceneConditionExtension *extension)
{
    if (session == NULL || session->executor == NULL) {
        return SCENE_SESSION_ERR_ARGUMENT;
    }
    session->condition_extension = extension;
    return scene_executor_set_condition_extension(session->executor, extension) ==
                   SCENE_EXECUTOR_OK
               ? SCENE_SESSION_OK
               : SCENE_SESSION_ERR_EXECUTOR;
}

int scene_session_get_condition_failure(const SceneSession *session,
                                        SceneConditionFailure *failure)
{
    if (session == NULL || failure == NULL) {
        return SCENE_SESSION_ERR_ARGUMENT;
    }
    *failure = session->condition_failure;
    return SCENE_SESSION_OK;
}

int scene_session_bind_pointer(SceneSession *session,
                               const SceneSessionPointerHost *host)
{
    if (session == NULL || host == NULL || host->consume == NULL ||
        host->scan == NULL || host->reset == NULL) {
        return SCENE_SESSION_ERR_ARGUMENT;
    }
    if (host->reset(host->context) != SESSION_INPUT_OK) {
        return SCENE_SESSION_ERR_ARGUMENT;
    }
    session->pointer = *host;
    session->pointer_bound = 1;
    return SCENE_SESSION_OK;
}

int scene_session_get_pointer_result(const SceneSession *session,
                                     SceneSessionPointerResult *result)
{
    if (session == NULL || result == NULL) return SCENE_SESSION_ERR_ARGUMENT;
    *result = session->pointer_result;
    return SCENE_SESSION_OK;
}

int scene_session_accept_action_candidate(SceneSession *session,
                                          size_t action_index)
{
    if (session == NULL || session->executor == NULL) {
        return SCENE_SESSION_ERR_ARGUMENT;
    }
    return scene_executor_accept_action_candidate(session->executor,
                                                  action_index) ==
                   SCENE_EXECUTOR_OK
               ? SCENE_SESSION_OK : SCENE_SESSION_ERR_ARGUMENT;
}

int scene_session_get_action_state(const SceneSession *session,
                                   size_t action_index,
                                   SceneActionRuntimeState *state)
{
    if (session == NULL) return SCENE_EXECUTOR_ERR_ARGUMENT;
    return scene_executor_get_action_state(session->executor, action_index, state);
}

int scene_session_get_hotspot_state(const SceneSession *session,
                                    size_t action_index,
                                    SceneExecutorHotspotState *state)
{
    if (session == NULL) return SCENE_EXECUTOR_ERR_ARGUMENT;
    return scene_executor_get_hotspot_state(session->executor, action_index, state);
}

const ActionUIWorld *scene_session_get_action_ui(const SceneSession *session)
{
    return session == NULL ? NULL : &session->action_ui;
}

int scene_session_get_pending_transition(const SceneSession *session,
                                         SceneTransitionRequest *transition)
{
    if (session == NULL || transition == NULL || !session->transition_pending) {
        return 0;
    }
    *transition = session->transition;
    return 1;
}

int scene_session_get_last_result(const SceneSession *session,
                                  SceneSessionTickResult *result)
{
    if (session == NULL || result == NULL) return SCENE_SESSION_ERR_ARGUMENT;
    *result = session->last_result;
    return SCENE_SESSION_OK;
}

uint64_t scene_session_tick_count(const SceneSession *session)
{
    return session == NULL ? 0u : session->tick_count;
}

uint64_t scene_session_scene_generation(const SceneSession *session)
{
    return session == NULL ? 0u : session->scene_generation;
}

int32_t scene_session_scene_id(const SceneSession *session)
{
    return session == NULL ? 0 : session->scene_id;
}

const char *scene_session_status_string(int status)
{
    switch (status) {
    case SCENE_SESSION_OK: return "ok";
    case SCENE_SESSION_TRANSITION_PENDING: return "transition pending";
    case SCENE_SESSION_BLOCKED: return "blocked at unresolved provider";
    case SCENE_SESSION_ERR_ARGUMENT: return "invalid argument";
    case SCENE_SESSION_ERR_MEMORY: return "allocation failed";
    case SCENE_SESSION_ERR_EXECUTOR: return "scene executor failed";
    case SCENE_SESSION_ERR_STATE: return "invalid or frozen session state";
    default: return "unknown scene session status";
    }
}

const char *scene_session_provider_string(SceneSessionProvider provider)
{
    switch (provider) {
    case SCENE_SESSION_PROVIDER_NONE: return "none";
    case SCENE_SESSION_PROVIDER_WORLD_CLOCK: return "world-clock";
    case SCENE_SESSION_PROVIDER_TIMER_EFFECTS: return "timer-effects";
    case SCENE_SESSION_PROVIDER_POST_CLOCK: return "post-clock-controller";
    case SCENE_SESSION_PROVIDER_MEDIA: return "scene-media";
    case SCENE_SESSION_PROVIDER_POINTER_INPUT: return "pointer-input-transform";
    case SCENE_SESSION_PROVIDER_ACTION_UI: return "action-ui";
    case SCENE_SESSION_PROVIDER_ACTION_SOUND: return "action-sound";
    case SCENE_SESSION_PROVIDER_CAPTION: return "caption";
    case SCENE_SESSION_PROVIDER_A28: return "action-family-28";
    case SCENE_SESSION_PROVIDER_A62: return "action-family-62";
    case SCENE_SESSION_PROVIDER_ACTION_KERNEL: return "action-kernel";
    case SCENE_SESSION_PROVIDER_DEPENDENCY: return "dependency-provider";
    case SCENE_SESSION_PROVIDER_SCENE_RESOURCE: return "scene-resource";
    case SCENE_SESSION_PROVIDER_HOST: return "host-adapter";
    default: return "unknown-provider";
    }
}

int scene_session_request_transition(SceneSession *session,
                                     const SceneTransitionRequest *request)
{
    if (session == NULL || request == NULL || session->executor == NULL) {
        return SCENE_SESSION_ERR_ARGUMENT;
    }
    return scene_executor_request_transition(session->executor, request) ==
                   SCENE_EXECUTOR_OK
               ? SCENE_SESSION_OK
               : SCENE_SESSION_ERR_STATE;
}
