#include "condition_extra.h"

#include <limits.h>
#include <string.h>

#define TIMER_STATUS_OFFSET 0x00u
#define TIMER_ELAPSED_OFFSET 0x04u
#define TIMER_ACTIVE 1
#define TIMER_PAUSED 5
#define TIMER_PENDING 6
#define MSVC_RAND_MAX 32767u

static int32_t bits_to_i32(uint32_t bits)
{
    if (bits <= (uint32_t)INT32_MAX) {
        return (int32_t)bits;
    }
    return (int32_t)((int64_t)bits - INT64_C(0x100000000));
}

static uint32_t load_u32_le(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] |
           ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) |
           ((uint32_t)bytes[3] << 24);
}

static int32_t load_i32_le(const uint8_t *bytes)
{
    return bits_to_i32(load_u32_le(bytes));
}

static void initialize_result(ConditionExtraResult *result)
{
    memset(result, 0, sizeof(*result));
}

static int finish(ConditionExtraResult *result,
                  ConditionExtraStatus status,
                  ConditionExtraTrigger trigger)
{
    result->status = (int32_t)status;
    result->trigger = (int32_t)trigger;
    return (int)status;
}

void condition_extra_node_initialize(ConditionExtraNodeRuntime *runtime)
{
    if (runtime == NULL) {
        return;
    }
    runtime->runtime_threshold_20 = 0;
    runtime->random_cache_valid_2c = 0u;
    runtime->random_sample_30 = 0;
}

void condition_extra_node_reset(ConditionExtraNodeRuntime *runtime)
{
    if (runtime != NULL) {
        /* 0x423da2 clears the random-valid flag at +0x2c, not the sample at
         * +0x30 or the separately retained runtime threshold at +0x20. */
        runtime->random_cache_valid_2c = 0u;
    }
}

static int evaluate_selected_leaf(const SceneDependencyInfo *record,
                                  const void *leaf_identity,
                                  ConditionExtraSession *session,
                                  int32_t *status_out,
                                  ConditionExtraResult *result)
{
    int16_t label = record->fields[1];
    int selected;

    if (session->condition_state == NULL ||
        session->selected_dependency_leaf == NULL ||
        leaf_identity == NULL) {
        return finish(result, CONDITION_EXTRA_ERR_ARGUMENT,
                      CONDITION_EXTRA_TRIGGER_SELECTED_LEAF);
    }

    if (session->evaluation_mode_614 != 0) {
        *status_out = 1;
        *session->selected_dependency_leaf = NULL;
        result->partial_state_committed = 1u;
        return finish(result, CONDITION_EXTRA_OK,
                      CONDITION_EXTRA_TRIGGER_SELECTED_LEAF);
    }

    selected = session->condition_state->selected_inventory_item == (int32_t)label;
    if (selected != 0) {
        *status_out = 1;
        *session->selected_dependency_leaf = leaf_identity;
        result->partial_state_committed = 1u;
    } else {
        *status_out = 0;
        if (*session->selected_dependency_leaf == leaf_identity) {
            *session->selected_dependency_leaf = NULL;
            result->partial_state_committed = 1u;
        }
    }
    return finish(result, CONDITION_EXTRA_OK,
                  CONDITION_EXTRA_TRIGGER_SELECTED_LEAF);
}

static int evaluate_outside_window(const SceneDependencyInfo *record,
                                   ConditionExtraSession *session,
                                   int32_t *status_out,
                                   ConditionExtraResult *result)
{
    if (session->clock == NULL) {
        return finish(result, CONDITION_EXTRA_ERR_ARGUMENT,
                      CONDITION_EXTRA_TRIGGER_OUTSIDE_WINDOW);
    }
    *status_out = ((int32_t)record->fields[1] ==
                   (int32_t)session->clock->outside_window_flag_5bb20a) ? 1 : 0;
    return finish(result, CONDITION_EXTRA_OK,
                  CONDITION_EXTRA_TRIGGER_OUTSIDE_WINDOW);
}

static int evaluate_timer_record(const SceneDependencyInfo *record,
                                 ConditionExtraNodeRuntime *runtime,
                                 ConditionExtraSession *session,
                                 int is_elapsed_after,
                                 int32_t *status_out,
                                 ConditionExtraResult *result)
{
    int16_t index = record->fields[1];
    size_t required_size;
    const uint8_t *raw_record;
    int32_t record_status;
    int32_t elapsed;
    int32_t threshold;

    if (runtime == NULL || session->world == NULL ||
        session->world->time_records_585d65 == NULL) {
        return finish(result, CONDITION_EXTRA_ERR_ARGUMENT,
                      CONDITION_EXTRA_TRIGGER_TIMER_RECORD);
    }
    if (index < 0 || (size_t)index >= CONDITION_EXTRA_TIME_RECORD_COUNT) {
        return finish(result, CONDITION_EXTRA_ERR_BOUNDS,
                      CONDITION_EXTRA_TRIGGER_TIMER_RECORD);
    }
    required_size = (size_t)index * CONDITION_EXTRA_TIME_RECORD_SIZE +
                    TIMER_ELAPSED_OFFSET + sizeof(uint32_t);
    if (session->world->time_records_size < required_size) {
        return finish(result, CONDITION_EXTRA_ERR_BOUNDS,
                      CONDITION_EXTRA_TRIGGER_TIMER_RECORD);
    }

    raw_record = session->world->time_records_585d65 +
                 (size_t)index * CONDITION_EXTRA_TIME_RECORD_SIZE;
    record_status = load_i32_le(raw_record + TIMER_STATUS_OFFSET);
    elapsed = load_i32_le(raw_record + TIMER_ELAPSED_OFFSET);
    threshold = runtime->runtime_threshold_20;
    if (record_status != TIMER_ACTIVE && record_status != TIMER_PAUSED &&
        record_status != TIMER_PENDING) {
        *status_out = 0;
    } else if (is_elapsed_after != 0) {
        *status_out = elapsed > threshold ? 1 : 0;
    } else {
        *status_out = elapsed <= threshold ? 1 : 0;
    }
    return finish(result, CONDITION_EXTRA_OK,
                  CONDITION_EXTRA_TRIGGER_TIMER_RECORD);
}

static int evaluate_context(const SceneDependencyInfo *record,
                            ConditionExtraSession *session,
                            int32_t *status_out,
                            ConditionExtraResult *result)
{
    *status_out = session->context_58c94f == record->fields[2] ? 1 : 0;
    return finish(result, CONDITION_EXTRA_OK,
                  CONDITION_EXTRA_TRIGGER_CONTEXT_58C94F);
}

static int evaluate_sound(const SceneDependencyInfo *record,
                          ConditionExtraSession *session,
                          int32_t *status_out,
                          ConditionExtraResult *result)
{
    int16_t channel = record->fields[1];
    int32_t observed_available = 0;
    ConditionExtraHostStatus host_status;

    if (channel < 0) {
        return finish(result, CONDITION_EXTRA_ERR_BOUNDS,
                      CONDITION_EXTRA_TRIGGER_SOUND_QUERY);
    }
    if (session->sound_query == NULL) {
        return finish(result, CONDITION_EXTRA_ERR_HOST_UNAVAILABLE,
                      CONDITION_EXTRA_TRIGGER_SOUND_QUERY);
    }

    ++result->host_calls;
    host_status = session->sound_query(session->context, channel,
                                       &observed_available);
    if (host_status == CONDITION_EXTRA_HOST_UNAVAILABLE) {
        return finish(result, CONDITION_EXTRA_ERR_HOST_UNAVAILABLE,
                      CONDITION_EXTRA_TRIGGER_SOUND_QUERY);
    }
    if (host_status == CONDITION_EXTRA_HOST_PARTIAL_FAILURE) {
        result->partial_state_committed = 1u;
        return finish(result, CONDITION_EXTRA_ERR_HOST_FAILURE,
                      CONDITION_EXTRA_TRIGGER_SOUND_QUERY);
    }
    if (host_status != CONDITION_EXTRA_HOST_OK) {
        return finish(result, CONDITION_EXTRA_ERR_HOST_FAILURE,
                      CONDITION_EXTRA_TRIGGER_SOUND_QUERY);
    }

    if (record->fields[2] == 1) {
        *status_out = observed_available != 0 ? 1 : 0;
    } else if (record->fields[2] == 0) {
        *status_out = observed_available == 0 ? 1 : 0;
    } else {
        *status_out = 0;
    }
    return finish(result, CONDITION_EXTRA_OK,
                  CONDITION_EXTRA_TRIGGER_SOUND_QUERY);
}

static int evaluate_random(const SceneDependencyInfo *record,
                           ConditionExtraNodeRuntime *runtime,
                           ConditionExtraSession *session,
                           int32_t *status_out,
                           ConditionExtraResult *result)
{
    uint32_t raw_value = 0u;
    uint32_t sample;
    ConditionExtraHostStatus host_status;

    if (runtime == NULL) {
        return finish(result, CONDITION_EXTRA_ERR_ARGUMENT,
                      CONDITION_EXTRA_TRIGGER_RANDOM);
    }

    if (runtime->random_cache_valid_2c != 0u) {
        /* 0x424346 deliberately leaves the previous status untouched once
         * +0x2c says the random value has been evaluated. The outer tree
         * reducer owns any intervening status change. */
        return finish(result, CONDITION_EXTRA_OK,
                      CONDITION_EXTRA_TRIGGER_RANDOM);
    }

    if (session->next_random == NULL) {
        return finish(result, CONDITION_EXTRA_ERR_HOST_UNAVAILABLE,
                      CONDITION_EXTRA_TRIGGER_RANDOM);
    }
    ++result->host_calls;
    host_status = session->next_random(session->context, &raw_value);
    if (host_status == CONDITION_EXTRA_HOST_UNAVAILABLE) {
        return finish(result, CONDITION_EXTRA_ERR_HOST_UNAVAILABLE,
                      CONDITION_EXTRA_TRIGGER_RANDOM);
    }
    if (host_status == CONDITION_EXTRA_HOST_PARTIAL_FAILURE) {
        result->random_calls = 1u;
        result->partial_state_committed = 1u;
        return finish(result, CONDITION_EXTRA_ERR_HOST_FAILURE,
                      CONDITION_EXTRA_TRIGGER_RANDOM);
    }
    if (host_status != CONDITION_EXTRA_HOST_OK) {
        return finish(result, CONDITION_EXTRA_ERR_HOST_FAILURE,
                      CONDITION_EXTRA_TRIGGER_RANDOM);
    }
    result->random_calls = 1u;
    result->random_raw_value = raw_value;
    if (raw_value > MSVC_RAND_MAX) {
        result->partial_state_committed = 1u;
        return finish(result, CONDITION_EXTRA_ERR_HOST_FAILURE,
                      CONDITION_EXTRA_TRIGGER_RANDOM);
    }

    sample = raw_value % 100u;
    runtime->random_sample_30 = (int32_t)sample;
    result->partial_state_committed = 1u;

    if (session->debug_enabled_63a4cd != 0 &&
        (record->fields[2] < 1 || record->fields[2] > 100)) {
        /* Original writes +0x30 before its debug fatal, and only writes
         * +0x2c after that fatal call returns. */
        return finish(result, CONDITION_EXTRA_ERR_DEBUG_FATAL,
                      CONDITION_EXTRA_TRIGGER_RANDOM);
    }
    runtime->random_cache_valid_2c = 1u;
    *status_out = runtime->random_sample_30 < (int32_t)record->fields[2] ? 1 : 0;
    return finish(result, CONDITION_EXTRA_OK,
                  CONDITION_EXTRA_TRIGGER_RANDOM);
}

int condition_extra_evaluate_leaf(
    const SceneDependencyInfo *record,
    const void *leaf_identity,
    ConditionExtraNodeRuntime *runtime,
    ConditionExtraSession *session,
    int32_t *status_out,
    ConditionExtraResult *result)
{
    if (result == NULL) {
        return CONDITION_EXTRA_ERR_ARGUMENT;
    }
    initialize_result(result);
    if (record == NULL || session == NULL || status_out == NULL) {
        return finish(result, CONDITION_EXTRA_ERR_ARGUMENT,
                      CONDITION_EXTRA_TRIGGER_NONE);
    }

    switch (record->opcode) {
    case 11:
        return evaluate_selected_leaf(record, leaf_identity, session,
                                      status_out, result);
    case 12:
        return evaluate_outside_window(record, session, status_out, result);
    case 13:
        return evaluate_timer_record(record, runtime, session, 0,
                                     status_out, result);
    case 14:
        return evaluate_timer_record(record, runtime, session, 1,
                                     status_out, result);
    case 15:
        return evaluate_context(record, session, status_out, result);
    case 17:
        return evaluate_sound(record, session, status_out, result);
    case 20:
        return evaluate_random(record, runtime, session, status_out, result);
    case 21:
        *status_out = session->previous_global_5c3a47 != 0 ? 1 : 0;
        return finish(result, CONDITION_EXTRA_OK,
                      CONDITION_EXTRA_TRIGGER_PRIOR_GATE);
    default:
        return finish(result, CONDITION_EXTRA_ERR_UNSUPPORTED_OPCODE,
                      CONDITION_EXTRA_TRIGGER_NONE);
    }
}

const char *condition_extra_status_string(int status)
{
    switch (status) {
    case CONDITION_EXTRA_OK:
        return "ok";
    case CONDITION_EXTRA_ERR_ARGUMENT:
        return "invalid condition-extra argument";
    case CONDITION_EXTRA_ERR_BOUNDS:
        return "condition-extra state index is out of bounds";
    case CONDITION_EXTRA_ERR_UNSUPPORTED_OPCODE:
        return "unsupported dependency leaf opcode";
    case CONDITION_EXTRA_ERR_HOST_UNAVAILABLE:
        return "required sound or random host boundary is unavailable";
    case CONDITION_EXTRA_ERR_HOST_FAILURE:
        return "condition-extra host provider failed";
    case CONDITION_EXTRA_ERR_DEBUG_FATAL:
        return "original debug path would terminate on an invalid random condition";
    default:
        return "unknown condition-extra status";
    }
}
