/* ASan/UBSan fixture for the RT-4 dependency-leaf path: scene_conditions
 * (tree build, thresholds, sidecars, extension dispatch, reset), the
 * condition_extra kernel and the session-conditions binding.
 *
 * Bounded malformed input only: random and boundary dependency records
 * (unknown opcodes, unmatched or empty groups, extreme fields, over-limit
 * counts), undersized or missing world/clock/timer storage, NULL or hostile
 * host callbacks (unavailable, partial failure, out-of-range random values,
 * missing optional hooks), hostile condition states, interleaved resets and
 * repeated evaluation under every mode. Exits nonzero on any harness check
 * failure; the sanitizers abort on any memory or undefined-behaviour report. */
#include "../src/condition_extra.h"
#include "../src/scene_conditions.h"
#include "../src/session_bindings_conditions.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t rng_state = UINT32_C(0x52543434);

static uint32_t next_random(void)
{
    uint32_t value = rng_state;
    value ^= value << 13;
    value ^= value >> 17;
    value ^= value << 5;
    rng_state = value;
    return value;
}

static uint32_t pick(uint32_t limit) { return next_random() % limit; }

static const int16_t edge_words[] = {0, 1, -1, 2, 3, 4, 9, 10, 11, 31, 32, 33, 100, 101,
                                     4999, 5000, 5001, 5003, 5004, 32767, -32768, 255, 256};
static const uint16_t opcode_pool[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                                       16, 17, 20, 21, 22, 23, 100, 255, 0xffff,
                                       11, 17, 20, 13, 14, 15, 21, 12};

static int16_t edge(void) { return edge_words[pick(sizeof(edge_words) / sizeof(edge_words[0]))]; }

/* ---- hostile hosts ---------------------------------------------------- */
static unsigned host_mode;

static ConditionExtraHostStatus channel_fn(void *ctx, uint16_t channel,
                                           SessionConditionsChannelRecord *record)
{
    (void)ctx; (void)channel;
    switch (host_mode % 4u) {
    case 0: return CONDITION_EXTRA_HOST_UNAVAILABLE;
    case 1: return CONDITION_EXTRA_HOST_PARTIAL_FAILURE;
    default:
        record->device_ready_1a0 = pick(3);
        record->resource_ready_162 = pick(2);
        record->buffer_available_28f = pick(2);
        record->repeat_marker_19e = pick(3);
        record->gate_16e = pick(3);
        record->gate_172 = pick(3);
        record->get_status_hresult = pick(4) == 0 ? (int32_t)next_random() : 0;
        record->get_status_flags = next_random();
        return CONDITION_EXTRA_HOST_OK;
    }
}

static ConditionExtraHostStatus random_fn(void *ctx, uint32_t *raw)
{
    (void)ctx;
    switch (pick(6)) {
    case 0: return CONDITION_EXTRA_HOST_UNAVAILABLE;
    case 1: return CONDITION_EXTRA_HOST_PARTIAL_FAILURE;
    case 2: *raw = next_random(); return CONDITION_EXTRA_HOST_OK;       /* often > 32767 */
    default: *raw = pick(32768); return CONDITION_EXTRA_HOST_OK;
    }
}

static ConditionExtraHostStatus context_fn(void *ctx, int16_t *value)
{
    (void)ctx;
    if (pick(5) == 0) return CONDITION_EXTRA_HOST_UNAVAILABLE;
    *value = edge();
    return CONDITION_EXTRA_HOST_OK;
}

static uint8_t bsum_bytes[402];
static size_t bsum_size = sizeof(bsum_bytes);

static int variable_fn(void *ctx, int16_t index, int16_t *value)
{
    (void)ctx;
    /* the real mapping over hostile sizes and indexes, plus random answers */
    if (pick(2) == 0) {
        return session_conditions_bsum_variable_word(pick(8) == 0 ? NULL : bsum_bytes,
                                                     bsum_size, pick(3) == 0 ? edge() : index,
                                                     pick(16) == 0 ? NULL : value);
    }
    if (pick(4) == 0) return 0;
    *value = edge();
    return 1;
}

/* ---- main fixture ----------------------------------------------------- */
typedef struct { unsigned built, rejected, evaluated; unsigned status[16]; } Counters;

static SceneDependencyInfo make_record(uint16_t opcode)
{
    SceneDependencyInfo record;
    int i;
    memset(&record, 0, sizeof(record));
    record.opcode = opcode;
    record.fields[0] = (int16_t)opcode;
    for (i = 1; i < 8; ++i) record.fields[i] = pick(3) == 0 ? edge() : (int16_t)pick(4);
    record.fields[3] = (int16_t)(pick(4) == 0 ? edge() : (int16_t)pick(2));
    record.or_after = record.fields[3];
    return record;
}

int main(void)
{
    Counters counters;
    unsigned iteration;
    memset(&counters, 0, sizeof(counters));
    for (iteration = 0; iteration < 12000u; ++iteration) {
        size_t count = pick(40);
        SceneDependencyInfo *records;
        SceneConditionTree *tree = NULL;
        size_t i;
        int status;
        unsigned round;
        uint8_t *time_bytes;
        size_t time_size;
        WorldInitState world;
        WorldClockSession clock;
        SessionConditionsConfig config;
        SessionConditions *binding;
        int create_status = -1;
        int32_t flags[4] = {0, 1, 0, 1};
        SceneConditionState state;

        if (iteration % 997u == 0u) count = 510u + pick(5);   /* around the 512 limit */
        records = (SceneDependencyInfo *)calloc(count ? count : 1u, sizeof(*records));
        if (records == NULL) return 1;
        for (i = 0; i < count; ++i) {
            records[i] = make_record(opcode_pool[pick(sizeof(opcode_pool) / sizeof(opcode_pool[0]))]);
            if (pick(8) == 0 && i + 3 < count) {                /* mostly well-formed groups */
                records[i] = make_record(0x12);
                records[i + 3] = make_record(0x13);
                records[i + 3].fields[3] = records[i].fields[3];
                records[i + 3].or_after = records[i].or_after;
            }
        }
        status = scene_conditions_build(records, count, &tree);
        free(records);
        if (status != SCENE_CONDITION_OK) {
            if (tree != NULL) { fprintf(stderr, "tree returned with error status\n"); return 1; }
            ++counters.rejected;
            continue;
        }
        ++counters.built;

        time_size = pick(4) == 0 ? (size_t)pick(0x400) : (size_t)0x106 * 10u;
        time_bytes = (uint8_t *)calloc(time_size ? time_size : 1u, 1u);
        for (i = 0; i < time_size; ++i) time_bytes[i] = (uint8_t)next_random();
        memset(&world, 0, sizeof(world));
        world.time_records_585d65 = pick(8) == 0 ? NULL : time_bytes;
        world.time_records_size = time_size;
        memset(&clock, 0, sizeof(clock));
        clock.outside_window_flag_5bb20a = edge();
        memset(&config, 0, sizeof(config));
        config.world = pick(8) == 0 ? NULL : &world;
        config.clock = pick(8) == 0 ? NULL : &clock;
        host_mode = pick(8);
        config.host.channel_record = pick(8) == 0 ? NULL : channel_fn;
        config.host.next_random = pick(8) == 0 ? NULL : random_fn;
        config.host.read_context_58c94f = pick(8) == 0 ? NULL : context_fn;
        config.host.read_variable_word = pick(8) == 0 ? NULL : variable_fn;
        config.debug_enabled_63a4cd = (int32_t)pick(2);
        binding = session_conditions_create(&config, &create_status);
        if (binding == NULL || create_status != SESSION_CONDITIONS_OK) return 1;

        for (i = 0; i < sizeof(bsum_bytes); ++i) bsum_bytes[i] = (uint8_t)next_random();
        bsum_size = pick(4) == 0 ? (size_t)pick(sizeof(bsum_bytes) + 1u) : sizeof(bsum_bytes);
        memset(&state, 0, sizeof(state));
        state.selected_inventory_item = edge();
        state.event_flags = flags;
        state.event_flag_count = pick(5);
        if (state.event_flag_count > 4u) state.event_flag_count = 4u;
        for (round = 0; round < 6u; ++round) {
            int satisfied = -7;
            uint16_t unsupported = 0;
            SceneConditionFailure failure;
            int32_t label = 0;
            int evaluated;
            if (pick(4) == 0) scene_conditions_reset(tree);
            if (pick(5) == 0) {
                const SceneConditionExtension *extension = session_conditions_extension(binding);
                if (extension->pass_started != NULL) extension->pass_started(extension->context);
            }
            evaluated = scene_conditions_evaluate_ex(
                tree, pick(16) == 0 ? NULL : &state,
                pick(12) == 0 ? NULL : session_conditions_extension(binding),
                (int32_t)pick(3) - 1, &satisfied, pick(2) ? &unsupported : NULL,
                pick(2) ? &failure : NULL);
            if ((unsigned)evaluated < 16u) ++counters.status[evaluated];
            if (evaluated == SCENE_CONDITION_OK && (satisfied != 0 && satisfied != 1)) {
                fprintf(stderr, "satisfied out of range\n");
                return 1;
            }
            ++counters.evaluated;
            (void)scene_conditions_selected_item_label(tree, &label);
            (void)scene_conditions_item_leaf_count(tree);
            (void)scene_conditions_first_item_label(tree, &label);
            (void)scene_conditions_first_item_label(tree, NULL);
            if (pick(5) == 0) scene_conditions_resolve_thresholds(tree, session_conditions_extension(binding));
        }
        scene_conditions_destroy(tree);
        session_conditions_destroy(binding);
        free(time_bytes);
    }
    printf("sanitizer cases=%u built=%u rejected=%u evaluations=%u "
           "ok=%u arg=%u bounds=%u unsupported=%u host_unavailable=%u provider=%u format=%u limit=%u\n",
           12000u, counters.built, counters.rejected, counters.evaluated,
           counters.status[SCENE_CONDITION_OK], counters.status[SCENE_CONDITION_ERR_ARGUMENT],
           counters.status[SCENE_CONDITION_ERR_BOUNDS],
           counters.status[SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE],
           counters.status[SCENE_CONDITION_ERR_HOST_UNAVAILABLE],
           counters.status[SCENE_CONDITION_ERR_PROVIDER],
           counters.status[SCENE_CONDITION_ERR_FORMAT], counters.status[SCENE_CONDITION_ERR_LIMIT]);
    if (counters.built == 0 || counters.rejected == 0 ||
        counters.status[SCENE_CONDITION_OK] == 0 ||
        counters.status[SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE] == 0 ||
        counters.status[SCENE_CONDITION_ERR_HOST_UNAVAILABLE] == 0 ||
        counters.status[SCENE_CONDITION_ERR_BOUNDS] == 0 ||
        counters.status[SCENE_CONDITION_ERR_PROVIDER] == 0) {
        fprintf(stderr, "sanitizer fixture did not reach every status class\n");
        return 1;
    }
    return 0;
}
