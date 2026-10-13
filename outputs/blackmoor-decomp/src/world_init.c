#include "world_init.h"

#include <string.h>

static int validate_new_game_spans(const WorldInitState *state)
{
    const WorldInitInventory *inventory = &state->inventory;
    const ActionCoreWorld *core = state->action_core;

    if (core->event_flags == NULL) {
        return WORLD_INIT_ERR_ARGUMENT;
    }
    if (core->event_flag_count <
        WORLD_INIT_EVENT_NEW_GAME_FIRST_ID + WORLD_INIT_EVENT_NEW_GAME_COUNT) {
        return WORLD_INIT_ERR_BOUNDS;
    }
    if (state->opaque_state_dwords_5839b1.values == NULL ||
        state->scene_visit_counts_587b2d.values == NULL ||
        inventory->selector_words_583a2b.values == NULL ||
        inventory->presence_583bd5.values == NULL ||
        inventory->item_ids_583a31.values == NULL ||
        inventory->item_ids_583abd.values == NULL ||
        inventory->item_ids_583b49.values == NULL ||
        inventory->auxiliary_583ced.values == NULL ||
        inventory->auxiliary_583e05.values == NULL ||
        state->time_records_585d65 == NULL ||
        inventory->selected_item_candidate == NULL ||
        inventory->opaque_selector_583f1d == NULL) {
        return WORLD_INIT_ERR_ARGUMENT;
    }
    if (state->opaque_state_dwords_5839b1.count <
            WORLD_INIT_STATE_DWORD_COUNT ||
        state->scene_visit_counts_587b2d.count <
            WORLD_INIT_VISIT_RESET_COUNT ||
        inventory->selector_words_583a2b.count < 3u ||
        inventory->presence_583bd5.count < WORLD_INIT_INVENTORY_ENTRY_COUNT ||
        inventory->item_ids_583a31.count < WORLD_INIT_INVENTORY_ENTRY_COUNT ||
        inventory->item_ids_583abd.count < WORLD_INIT_INVENTORY_ENTRY_COUNT ||
        inventory->item_ids_583b49.count < WORLD_INIT_INVENTORY_ENTRY_COUNT ||
        inventory->auxiliary_583ced.count < WORLD_INIT_INVENTORY_ENTRY_COUNT ||
        inventory->auxiliary_583e05.count < WORLD_INIT_INVENTORY_ENTRY_COUNT ||
        state->time_records_size < WORLD_INIT_TIME_RECORD_BYTES) {
        return WORLD_INIT_ERR_BOUNDS;
    }
    return WORLD_INIT_OK;
}

static uint32_t tick_plus_interval(uint32_t now_tick, int16_t interval_ms)
{
    return now_tick + (uint32_t)(int32_t)interval_ms;
}

static void store_u32_le(uint8_t *destination, uint32_t value)
{
    destination[0] = (uint8_t)value;
    destination[1] = (uint8_t)(value >> 8);
    destination[2] = (uint8_t)(value >> 16);
    destination[3] = (uint8_t)(value >> 24);
}

static void initialize_time_record(uint8_t *record)
{
    static const uint8_t no_sound[9] = {
        'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0
    };
    size_t index;

    memset(record, 0, WORLD_INIT_TIME_RECORD_SIZE);
    memcpy(record + 0x28u, no_sound, sizeof(no_sound));
    for (index = 0; index < 10u; ++index) {
        const size_t offset = 0xdeu + index * 4u;
        record[offset] = 0xffu;
        record[offset + 1u] = 0xffu;
    }
}

int world_init_cold_zero_event_flags(ActionCoreWorld *action_core)
{
    size_t index;

    if (action_core == NULL) {
        return WORLD_INIT_ERR_ARGUMENT;
    }
    if (action_core->event_flag_count != 0u &&
        action_core->event_flags == NULL) {
        return WORLD_INIT_ERR_ARGUMENT;
    }
    for (index = 0; index < action_core->event_flag_count; ++index) {
        action_core->event_flags[index] = 0;
    }
    return WORLD_INIT_OK;
}

int world_init_reset_inventory_object_data(uint8_t *object_view,
                                           size_t object_view_size)
{
    size_t index;

    if (object_view == NULL) {
        return WORLD_INIT_ERR_ARGUMENT;
    }
    if (object_view_size < WORLD_INIT_INVENTORY_OBJECT_VIEW_MIN_BYTES) {
        return WORLD_INIT_ERR_BOUNDS;
    }

    /* Original 0x4e7f19 loop: 16 records with 0x28-byte stride. The dword
     * stores are intentionally bytewise because their original offsets are
     * unaligned (0x7fae and 0x7fb2). */
    for (index = 0; index < WORLD_INIT_INVENTORY_OBJECT_SLOT_COUNT; ++index) {
        const size_t slot_offset = index * 0x28u;
        store_u32_le(object_view + 0x7faeu + slot_offset, UINT32_MAX);
        store_u32_le(object_view + 0x7fb2u + slot_offset, 0u);
    }

    store_u32_le(object_view + 0x825eu, 0u);
    store_u32_le(object_view + 0x6b1cu, UINT32_MAX);
    store_u32_le(object_view + 0x8256u, 0u);
    store_u32_le(object_view + 0x8286u, 0u);
    store_u32_le(object_view + 0x825au, 0u);
    store_u32_le(object_view + 0x8262u, 0u);
    return WORLD_INIT_OK;
}

int world_init_apply_new_game(WorldInitState *state,
                              const EngineBootStartupSettings *settings,
                              const WorldInitStartupOverrides *overrides,
                              uint32_t now_tick)
{
    WorldInitStartTuple selected;
    WorldInitInventory *inventory;
    size_t index;
    int status;

    if (state == NULL || settings == NULL || overrides == NULL ||
        state->action_core == NULL) {
        return WORLD_INIT_ERR_ARGUMENT;
    }
    if (overrides->test_mode_enabled != 0) {
        return WORLD_INIT_ERR_UNSUPPORTED_TEST_MODE;
    }
    status = validate_new_game_spans(state);
    if (status != WORLD_INIT_OK) {
        return status;
    }

    if (overrides->alternate_tuple_active != 0) {
        selected.scene_id = (int32_t)settings->alternate_initial_scene;
        selected.coordinate_word_a = settings->alternate_coordinate_word_a;
        selected.coordinate_word_b = settings->alternate_coordinate_word_b;
        selected.source = WORLD_INIT_START_ALTERNATE;
    } else if (overrides->forced_scene_gate_a != 0 ||
               overrides->forced_scene_gate_b != 0) {
        selected.scene_id = overrides->forced_scene_id;
        selected.coordinate_word_a = settings->ordinary_coordinate_word_a;
        selected.coordinate_word_b = settings->ordinary_coordinate_word_b;
        selected.source = WORLD_INIT_START_FORCED_SCENE;
    } else {
        selected.scene_id = (int32_t)settings->ordinary_initial_scene;
        selected.coordinate_word_a = settings->ordinary_coordinate_word_a;
        selected.coordinate_word_b = settings->ordinary_coordinate_word_b;
        selected.source = WORLD_INIT_START_ORDINARY;
    }

    /* All required spans are valid, so the shared sentinel initializer cannot
     * fail after mutation begins. It writes only the short/float value tables. */
    if (action_core_initialize_values(state->action_core) != ACTION_CORE_OK) {
        return WORLD_INIT_ERR_CORE;
    }

    for (index = WORLD_INIT_EVENT_NEW_GAME_FIRST_ID;
         index < WORLD_INIT_EVENT_NEW_GAME_FIRST_ID +
                    WORLD_INIT_EVENT_NEW_GAME_COUNT;
         ++index) {
        state->action_core->event_flags[index] = 0;
    }
    for (index = 0; index < WORLD_INIT_VISIT_RESET_COUNT; ++index) {
        state->scene_visit_counts_587b2d.values[index] = 0;
    }
    for (index = 0; index < WORLD_INIT_STATE_DWORD_COUNT; ++index) {
        state->opaque_state_dwords_5839b1.values[index] = 0;
    }

    inventory = &state->inventory;
    *inventory->selected_item_candidate = -1;
    *inventory->opaque_selector_583f1d = -1;
    for (index = 0; index < 3u; ++index) {
        inventory->selector_words_583a2b.values[index] = 0;
    }
    for (index = 0; index < WORLD_INIT_INVENTORY_ENTRY_COUNT; ++index) {
        inventory->presence_583bd5.values[index] = 0;
        inventory->item_ids_583a31.values[index] = UINT16_MAX;
        inventory->item_ids_583abd.values[index] = UINT16_MAX;
        inventory->item_ids_583b49.values[index] = UINT16_MAX;
        inventory->auxiliary_583ced.values[index] = 0;
        inventory->auxiliary_583e05.values[index] = 0;
    }
    for (index = 0; index < WORLD_INIT_TIME_RECORD_COUNT; ++index) {
        initialize_time_record(state->time_records_585d65 +
                               index * WORLD_INIT_TIME_RECORD_SIZE);
    }

    state->action_core->difficulty = 0;
    state->clock.run_start_tick = now_tick;
    state->clock.run_elapsed_ticks = 0;
    state->clock.run_display_word_0 = 0;
    state->clock.run_display_word_1 = 0;
    state->clock.run_display_word_2 = 0;
    state->clock.scene_elapsed_ticks = 0;
    state->clock.scene_display_word_0 = 0;
    state->clock.scene_display_word_1 = 0;
    state->clock.scene_display_word_2 = 0;
    state->clock.configured_minute = settings->initial_minute;
    state->clock.configured_hour = settings->initial_hour;
    state->clock.total_minutes =
        (int32_t)settings->initial_hour * 60 +
        (int32_t)settings->initial_minute;
    state->clock.next_update_tick =
        tick_plus_interval(now_tick, settings->clock_update_interval_ms);
    state->clock.first_day_event_hour = settings->first_day_event_hour;
    state->clock.first_day_event_flag_id = settings->first_day_event_flag_id;
    state->clock.day_counter = 0;
    state->clock.previous_tick_5d = now_tick;
    state->clock.previous_tick_61 = now_tick;
    state->clock.update_interval_ms = settings->clock_update_interval_ms;

    if (selected.source == WORLD_INIT_START_FORCED_SCENE) {
        state->forced_scene_mirror_63a4ed = selected.scene_id;
    }
    state->start_tuple = selected;
    return WORLD_INIT_OK;
}

int world_init_apply_scene_clear(WorldInitState *state,
                                 int restoring,
                                 uint32_t now_tick)
{
    size_t index;

    if (state == NULL || state->action_core == NULL) {
        return WORLD_INIT_ERR_ARGUMENT;
    }
    if (state->action_core->event_flags == NULL) {
        return WORLD_INIT_ERR_ARGUMENT;
    }
    if (state->action_core->event_flag_count <
        WORLD_INIT_EVENT_NEW_GAME_FIRST_ID + WORLD_INIT_EVENT_SCENE_CLEAR_COUNT) {
        return WORLD_INIT_ERR_BOUNDS;
    }

    for (index = WORLD_INIT_EVENT_NEW_GAME_FIRST_ID;
         index < WORLD_INIT_EVENT_NEW_GAME_FIRST_ID +
                    WORLD_INIT_EVENT_SCENE_CLEAR_COUNT;
         ++index) {
        state->action_core->event_flags[index] = 0;
    }
    if (restoring == 0) {
        state->clock.scene_elapsed_ticks = 0;
        state->clock.scene_display_word_0 = 0;
        state->clock.scene_display_word_1 = 0;
        state->clock.scene_display_word_2 = 0;
    } else {
        state->clock.next_update_tick =
            tick_plus_interval(now_tick, state->clock.update_interval_ms);
        state->clock.run_start_tick = now_tick;
        state->clock.previous_tick_5d = now_tick;
    }
    return WORLD_INIT_OK;
}

int world_init_record_successful_scene_load(WorldInitState *state,
                                            int32_t scene_id,
                                            int restoring)
{
    if (state == NULL) {
        return WORLD_INIT_ERR_ARGUMENT;
    }
    if (scene_id < 0 || scene_id >= WORLD_INIT_SCENE_ID_LIMIT) {
        return WORLD_INIT_ERR_SCENE_ID;
    }
    if (restoring != 0) {
        return WORLD_INIT_OK;
    }
    if (state->scene_visit_counts_587b2d.values == NULL) {
        return WORLD_INIT_ERR_ARGUMENT;
    }
    if ((size_t)scene_id >= state->scene_visit_counts_587b2d.count) {
        return WORLD_INIT_ERR_BOUNDS;
    }
    state->scene_visit_counts_587b2d.values[scene_id] =
        (uint16_t)(state->scene_visit_counts_587b2d.values[scene_id] + 1u);
    return WORLD_INIT_OK;
}

const char *world_init_status_string(int status)
{
    switch (status) {
    case WORLD_INIT_OK:
        return "ok";
    case WORLD_INIT_ERR_ARGUMENT:
        return "invalid argument";
    case WORLD_INIT_ERR_BOUNDS:
        return "caller-owned state span is too short";
    case WORLD_INIT_ERR_UNSUPPORTED_TEST_MODE:
        return "test-mode startup side effects are not modeled";
    case WORLD_INIT_ERR_SCENE_ID:
        return "scene ID is outside the bounded loader range";
    case WORLD_INIT_ERR_CORE:
        return "shared action-core initializer failed";
    default:
        return "unknown world-init status";
    }
}
