#include "session_bindings_conditions.h"

#include <stdlib.h>
#include <string.h>

/* The tree's per-node sidecar and the kernel's are the same three dwords. */
_Static_assert(sizeof(SceneConditionLeafRuntime) == sizeof(ConditionExtraNodeRuntime),
               "leaf sidecar layout must match condition_extra");
_Static_assert(offsetof(SceneConditionLeafRuntime, runtime_threshold_20) ==
                   offsetof(ConditionExtraNodeRuntime, runtime_threshold_20) &&
               offsetof(SceneConditionLeafRuntime, random_cache_valid_2c) ==
                   offsetof(ConditionExtraNodeRuntime, random_cache_valid_2c) &&
               offsetof(SceneConditionLeafRuntime, random_sample_30) ==
                   offsetof(ConditionExtraNodeRuntime, random_sample_30),
               "leaf sidecar fields must match condition_extra");

struct SessionConditions {
    WorldInitState *world;
    WorldClockSession *clock;
    SessionConditionsHost host;
    int32_t debug_enabled_63a4cd;
    /* Process global 0x5c3a47. */
    int32_t global_5c3a47;
    SessionConditionsSoundManager manager;
    SessionConditionsStats stats;
    SceneConditionExtension extension;
};

/* ---- original 0x4f6334 decision logic ---------------------------------- */

int session_conditions_query_channel_record(
    const SessionConditionsChannelRecord *record,
    SessionConditionsSoundManager *manager)
{
    if (record == NULL || manager == NULL) {
        return 0;
    }
    /* 0x4f6340 / 0x4f634d */
    manager->error_3c2 = 0x3e8u;
    manager->host_result_3ca = 0;
    if (record->device_ready_1a0 == 0u) {             /* 0x4f709c == 0 */
        manager->error_3c2 = 0x3eau;
        manager->state_3be = 0u;
        return 0;
    }
    if (record->resource_ready_162 == 0u ||           /* +0x162 */
        record->buffer_available_28f == 0u) {         /* +0x28f */
        manager->error_3c2 = 0x3efu;
        manager->state_3be = 0u;
        return 0;
    }
    if (record->repeat_marker_19e != 0u) {            /* +0x19e */
        return record->gate_172 == 0u && record->gate_16e == 0u ? 1 : 0;
    }
    manager->host_result_3ca = record->get_status_hresult;   /* GetStatus */
    if (record->get_status_hresult == 0) {
        return (record->get_status_flags & 1u) != 0u ? 1 : 0;
    }
    manager->error_3c2 = 0x40au;
    return 0;
}

static ConditionExtraHostStatus sound_query_shim(void *context, int16_t channel,
                                                  int32_t *available)
{
    SessionConditions *binding = (SessionConditions *)context;
    SessionConditionsChannelRecord record;
    ConditionExtraHostStatus host_status;

    if (binding == NULL || available == NULL || binding->host.channel_record == NULL ||
        channel < 0 || (uint32_t)channel >= SESSION_CONDITIONS_CHANNEL_COUNT) {
        /* The original indexes its 0x5bb-byte channel table unchecked; the
         * native port rejects indexes outside the 32 channels explicitly. */
        return CONDITION_EXTRA_HOST_UNAVAILABLE;
    }
    memset(&record, 0, sizeof(record));
    host_status = binding->host.channel_record(binding->host.context,
                                               (uint16_t)channel, &record);
    if (host_status != CONDITION_EXTRA_HOST_OK) {
        /* Nothing is committed on unavailability, including a failed prefix. */
        return host_status == CONDITION_EXTRA_HOST_PARTIAL_FAILURE
                   ? CONDITION_EXTRA_HOST_PARTIAL_FAILURE
                   : CONDITION_EXTRA_HOST_UNAVAILABLE;
    }
    ++binding->stats.sound_queries;
    *available = session_conditions_query_channel_record(&record, &binding->manager);
    return CONDITION_EXTRA_HOST_OK;
}

static ConditionExtraHostStatus random_shim(void *context, uint32_t *raw)
{
    SessionConditions *binding = (SessionConditions *)context;
    ConditionExtraHostStatus host_status;
    if (binding == NULL || raw == NULL || binding->host.next_random == NULL) {
        return CONDITION_EXTRA_HOST_UNAVAILABLE;
    }
    host_status = binding->host.next_random(binding->host.context, raw);
    if (host_status == CONDITION_EXTRA_HOST_OK) {
        ++binding->stats.random_draws;
    }
    return host_status;
}

/* ---- extension hooks ----------------------------------------------------- */

static int map_kernel_status(int kernel_status)
{
    switch (kernel_status) {
    case CONDITION_EXTRA_OK: return SCENE_CONDITION_OK;
    case CONDITION_EXTRA_ERR_BOUNDS: return SCENE_CONDITION_ERR_BOUNDS;
    case CONDITION_EXTRA_ERR_UNSUPPORTED_OPCODE:
        return SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE;
    case CONDITION_EXTRA_ERR_HOST_UNAVAILABLE:
        return SCENE_CONDITION_ERR_HOST_UNAVAILABLE;
    default: return SCENE_CONDITION_ERR_PROVIDER;
    }
}

static int evaluate_leaf(void *context, const SceneConditionLeafRequest *request,
                         int32_t *status_out, int *provider_status)
{
    SessionConditions *binding = (SessionConditions *)context;
    ConditionExtraSession session;
    ConditionExtraNodeRuntime runtime;
    ConditionExtraResult result;
    int kernel_status;

    if (provider_status != NULL) {
        *provider_status = 0;
    }
    if (binding == NULL || request == NULL || status_out == NULL ||
        request->runtime == NULL) {
        return SCENE_CONDITION_ERR_PROVIDER;
    }
    ++binding->stats.leaf_evaluations;
    memset(&session, 0, sizeof(session));
    session.context = binding;
    session.condition_state = request->state;
    session.world = binding->world;
    session.clock = binding->clock;
    session.evaluation_mode_614 = request->evaluation_mode;
    session.previous_global_5c3a47 = binding->global_5c3a47;
    session.debug_enabled_63a4cd = binding->debug_enabled_63a4cd;
    session.selected_dependency_leaf = request->selected_leaf_slot;
    session.sound_query = sound_query_shim;
    session.next_random = random_shim;

    if (request->record.opcode == 15u) {
        /* Opcode 15 compares the difficulty/context word 0x58c94f. */
        ConditionExtraHostStatus host_status = CONDITION_EXTRA_HOST_UNAVAILABLE;
        int16_t value = 0;
        if (binding->host.read_context_58c94f != NULL) {
            host_status = binding->host.read_context_58c94f(binding->host.context,
                                                            &value);
        }
        if (host_status != CONDITION_EXTRA_HOST_OK) {
            if (provider_status != NULL) {
                *provider_status = CONDITION_EXTRA_ERR_HOST_UNAVAILABLE;
            }
            return SCENE_CONDITION_ERR_HOST_UNAVAILABLE;
        }
        session.context_58c94f = value;
    }

    memcpy(&runtime, request->runtime, sizeof(runtime));
    kernel_status = condition_extra_evaluate_leaf(
        &request->record, request->leaf_identity, &runtime, &session,
        status_out, &result);
    /* The kernel writes the sample before a debug stop, so copy back even on
     * failure: effects already committed stay visible. */
    memcpy(request->runtime, &runtime, sizeof(runtime));
    if (kernel_status != CONDITION_EXTRA_OK && provider_status != NULL) {
        *provider_status = kernel_status;
    }
    return map_kernel_status(kernel_status);
}

static int read_variable_word(void *context, int16_t index, int16_t *value)
{
    SessionConditions *binding = (SessionConditions *)context;
    if (binding == NULL || value == NULL || binding->host.read_variable_word == NULL) {
        return 0;
    }
    return binding->host.read_variable_word(binding->host.context, index, value);
}

static void pass_started(void *context)
{
    SessionConditions *binding = (SessionConditions *)context;
    if (binding != NULL) {
        binding->global_5c3a47 = 1;                    /* 0x43cf25 */
        ++binding->stats.passes_started;
    }
}

static void tree_evaluated(void *context, int32_t root_status)
{
    SessionConditions *binding = (SessionConditions *)context;
    if (binding != NULL) {
        binding->global_5c3a47 = root_status == 0 ? 1 : 0;   /* 0x423f92 */
        ++binding->stats.trees_evaluated;
    }
}

/* ---- public API ------------------------------------------------------------ */

SessionConditions *session_conditions_create(
    const SessionConditionsConfig *config, int *status)
{
    SessionConditions *binding;
    if (status != NULL) {
        *status = SESSION_CONDITIONS_ERR_ARGUMENT;
    }
    if (config == NULL) {
        return NULL;
    }
    binding = (SessionConditions *)calloc(1u, sizeof(*binding));
    if (binding == NULL) {
        if (status != NULL) {
            *status = SESSION_CONDITIONS_ERR_MEMORY;
        }
        return NULL;
    }
    binding->world = config->world;
    binding->clock = config->clock;
    binding->host = config->host;
    binding->debug_enabled_63a4cd = config->debug_enabled_63a4cd;
    binding->extension.context = binding;
    binding->extension.evaluate_leaf = evaluate_leaf;
    binding->extension.pass_started = pass_started;
    binding->extension.tree_evaluated = tree_evaluated;
    binding->extension.read_variable_word = read_variable_word;
    if (status != NULL) {
        *status = SESSION_CONDITIONS_OK;
    }
    return binding;
}

void session_conditions_destroy(SessionConditions *binding)
{
    free(binding);
}

const SceneConditionExtension *session_conditions_extension(
    const SessionConditions *binding)
{
    return binding == NULL ? NULL : &binding->extension;
}

int32_t session_conditions_global_5c3a47(const SessionConditions *binding)
{
    return binding == NULL ? 0 : binding->global_5c3a47;
}

void session_conditions_set_global_5c3a47(SessionConditions *binding,
                                          int32_t value)
{
    if (binding != NULL) {
        binding->global_5c3a47 = value;
    }
}

int session_conditions_get_sound_manager(const SessionConditions *binding,
                                         SessionConditionsSoundManager *state)
{
    if (binding == NULL || state == NULL) {
        return SESSION_CONDITIONS_ERR_ARGUMENT;
    }
    *state = binding->manager;
    return SESSION_CONDITIONS_OK;
}

int session_conditions_get_stats(const SessionConditions *binding,
                                 SessionConditionsStats *stats)
{
    if (binding == NULL || stats == NULL) {
        return SESSION_CONDITIONS_ERR_ARGUMENT;
    }
    *stats = binding->stats;
    return SESSION_CONDITIONS_OK;
}

int session_conditions_bsum_variable_word(const uint8_t *bsum, size_t bsum_size,
                                          int16_t index, int16_t *value)
{
    int32_t offset;
    if (bsum == NULL || value == NULL) {
        return 0;
    }
    offset = 2 * (int32_t)index - 9618;
    if (offset < 0 || (size_t)offset + 2u > bsum_size) {
        return 0;
    }
    *value = (int16_t)(uint16_t)((uint16_t)bsum[offset] |
                                 ((uint16_t)bsum[offset + 1] << 8));
    return 1;
}

void session_conditions_crt_rand_init(SessionConditionsCrtRand *generator)
{
    if (generator != NULL) {
        generator->holdrand = 1u;
    }
}

void session_conditions_crt_srand(SessionConditionsCrtRand *generator,
                                  uint32_t seed)
{
    if (generator != NULL) {
        generator->holdrand = seed;                    /* 0x50cd43 */
    }
}

uint32_t session_conditions_crt_rand(SessionConditionsCrtRand *generator)
{
    if (generator == NULL) {
        return 0u;
    }
    /* 0x50cd50: imul 0x343fd, add 0x269ec3, shr 16, and 0x7fff (modulo 2^32). */
    generator->holdrand = generator->holdrand * UINT32_C(0x343fd) +
                          UINT32_C(0x269ec3);
    return (generator->holdrand >> 16) & UINT32_C(0x7fff);
}

ConditionExtraHostStatus session_conditions_crt_rand_host(
    void *generator_context, uint32_t *raw_rand_value)
{
    if (generator_context == NULL || raw_rand_value == NULL) {
        return CONDITION_EXTRA_HOST_UNAVAILABLE;
    }
    *raw_rand_value = session_conditions_crt_rand(
        (SessionConditionsCrtRand *)generator_context);
    return CONDITION_EXTRA_HOST_OK;
}

const char *session_conditions_status_string(int status)
{
    switch (status) {
    case SESSION_CONDITIONS_OK: return "ok";
    case SESSION_CONDITIONS_ERR_ARGUMENT: return "invalid session-conditions argument";
    case SESSION_CONDITIONS_ERR_MEMORY: return "session-conditions allocation failed";
    default: return "unknown session-conditions status";
    }
}
