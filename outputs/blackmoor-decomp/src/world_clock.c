#include "world_clock.h"

#include <limits.h>
#include <string.h>

#define RECORD_STATUS_OFFSET 0x00u
#define RECORD_ELAPSED_OFFSET 0x04u
#define RECORD_SECOND_DISPLAY_OFFSET 0x08u
#define RECORD_MINUTE_DISPLAY_OFFSET 0x0cu
#define RECORD_HOUR_DISPLAY_OFFSET 0x10u
#define RECORD_COMPLETED_OFFSET 0x14u
#define RECORD_TARGET_OFFSET 0x18u
#define RECORD_SOUND_OFFSET 0x28u
#define RECORD_SOUND_DESCRIPTOR_SIZE 49u
#define RECORD_SOUND_CHANNEL_OFFSET 0x49u
#define RECORD_CAPTION_KEY_OFFSET 0x59u
#define RECORD_CAPTION_FALLBACK_OFFSET 0x7au
#define RECORD_FLAG_PAIR_OFFSET 0xdeu
#define RECORD_FLAG_PAIR_COUNT 10u
#define ORIGINAL_NO_SOUND "NO SOUND"
#define ORIGINAL_CAPTION_SUFFIX "<n><e>"

static uint32_t load_u32_le(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] |
           ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) |
           ((uint32_t)bytes[3] << 24);
}

static int32_t bits_to_i32(uint32_t bits)
{
    if (bits <= (uint32_t)INT32_MAX) {
        return (int32_t)bits;
    }
    return (int32_t)((int64_t)bits - INT64_C(0x100000000));
}

static int16_t bits_to_i16(uint16_t bits)
{
    if (bits <= (uint16_t)INT16_MAX) {
        return (int16_t)bits;
    }
    return (int16_t)((int32_t)bits - INT32_C(65536));
}

static int32_t load_i32_le(const uint8_t *bytes)
{
    return bits_to_i32(load_u32_le(bytes));
}

static int16_t load_i16_le(const uint8_t *bytes)
{
    uint16_t bits = (uint16_t)bytes[0] | (uint16_t)((uint16_t)bytes[1] << 8);
    return bits_to_i16(bits);
}

static void store_u32_le(uint8_t *bytes, uint32_t value)
{
    bytes[0] = (uint8_t)value;
    bytes[1] = (uint8_t)(value >> 8);
    bytes[2] = (uint8_t)(value >> 16);
    bytes[3] = (uint8_t)(value >> 24);
}

static void store_i32_le(uint8_t *bytes, int32_t value)
{
    store_u32_le(bytes, (uint32_t)value);
}

static void store_i16_le(uint8_t *bytes, int16_t value)
{
    uint16_t bits = (uint16_t)value;
    bytes[0] = (uint8_t)bits;
    bytes[1] = (uint8_t)(bits >> 8);
}

static int16_t wrap_i16(int32_t value)
{
    uint16_t bits = (uint16_t)(uint32_t)value;
    return bits_to_i16(bits);
}

static void initialize_result(WorldClockResult *result)
{
    memset(result, 0, sizeof(*result));
    result->record_index = UINT16_MAX;
    result->pair_index = UINT16_MAX;
    result->event_flag_id = -1;
}

static int finish_result(WorldClockResult *result,
                         WorldClockStatus status,
                         WorldClockTrigger trigger)
{
    result->status = (int32_t)status;
    result->trigger = (int32_t)trigger;
    return (int)status;
}

static int validate_session(WorldClockSession *session,
                            WorldClockResult *result)
{
    if (session == NULL || session->world == NULL) {
        return finish_result(result, WORLD_CLOCK_ERR_ARGUMENT,
                             WORLD_CLOCK_TRIGGER_SESSION);
    }
    if (session->world->time_records_585d65 == NULL) {
        return finish_result(result, WORLD_CLOCK_ERR_ARGUMENT,
                             WORLD_CLOCK_TRIGGER_RECORD_VIEW);
    }
    if (session->world->time_records_size < WORLD_CLOCK_TIME_RECORD_BYTES) {
        return finish_result(result, WORLD_CLOCK_ERR_BOUNDS,
                             WORLD_CLOCK_TRIGGER_RECORD_VIEW);
    }
    return WORLD_CLOCK_OK;
}

static void update_display_words_u32(uint32_t ticks,
                                     uint16_t *seconds_word,
                                     uint16_t *minutes_word,
                                     uint16_t *hours_word)
{
    int32_t signed_seconds = bits_to_i32(ticks) / INT32_C(1000);
    int32_t second_remainder = signed_seconds % INT32_C(60);
    uint32_t elapsed_minutes = ticks / UINT32_C(60000);
    uint32_t elapsed_hours = ticks / UINT32_C(3600000);

    *seconds_word = (uint16_t)second_remainder;
    *minutes_word = (uint16_t)(elapsed_minutes % UINT32_C(60));
    *hours_word = (uint16_t)elapsed_hours;
}

static void update_record_display(uint8_t *record, uint32_t elapsed)
{
    int32_t signed_seconds = bits_to_i32(elapsed) / INT32_C(1000);
    int32_t second_remainder = signed_seconds % INT32_C(60);
    uint32_t elapsed_minutes = elapsed / UINT32_C(60000);
    uint32_t elapsed_hours = elapsed / UINT32_C(3600000);

    store_i32_le(record + RECORD_SECOND_DISPLAY_OFFSET, second_remainder);
    store_u32_le(record + RECORD_MINUTE_DISPLAY_OFFSET,
                  elapsed_minutes % UINT32_C(60));
    store_u32_le(record + RECORD_HOUR_DISPLAY_OFFSET, elapsed_hours);
}

static uint32_t subtract_and_clamp(uint32_t value, uint32_t delta)
{
    uint32_t candidate = value - delta;
    return bits_to_i32(candidate) < 0 ? 0u : candidate;
}

static int bounded_c_string(const uint8_t *bytes,
                            size_t capacity,
                            const char **text_out,
                            size_t *length_out)
{
    const uint8_t *terminator;

    terminator = (const uint8_t *)memchr(bytes, 0, capacity);
    if (terminator == NULL) {
        return 0;
    }
    *text_out = (const char *)bytes;
    *length_out = (size_t)(terminator - bytes);
    return 1;
}

static int emit_host_effect(WorldClockEffectSink *sink,
                            const WorldClockEffect *effect,
                            uint16_t record_index,
                            WorldClockTrigger trigger,
                            WorldClockResult *result)
{
    WorldClockHostStatus host_status;

    result->record_index = record_index;
    result->trigger = (int32_t)trigger;
    if (sink == NULL || sink->emit == NULL) {
        return finish_result(result, WORLD_CLOCK_ERR_HOST_UNAVAILABLE, trigger);
    }

    ++result->effects_attempted;
    host_status = sink->emit(sink->context, effect);
    if (host_status == WORLD_CLOCK_HOST_UNAVAILABLE) {
        return finish_result(result, WORLD_CLOCK_ERR_HOST_UNAVAILABLE, trigger);
    }
    if (host_status != WORLD_CLOCK_HOST_OK) {
        /* Original 0x43a7ca does not inspect these helper return values. */
        ++result->ignored_host_failures;
    }
    return WORLD_CLOCK_OK;
}

static int emit_caption_effect(WorldClockEffectSink *sink,
                               const char *text,
                               size_t text_length,
                               uint32_t caption_source,
                               uint16_t record_index,
                               WorldClockResult *result)
{
    char display_text[104];
    const size_t suffix_length = sizeof(ORIGINAL_CAPTION_SUFFIX) - 1u;
    WorldClockEffect effect;
    int result_code;

    /* 0x43a7ca copies into local_c4[104] and overwrites the copied NUL with
     * DAT_00547214/1c, whose bytes are exactly "<n><e>\0\0". Keep the
     * original presentation boundary while refusing its stack-overflow cases. */
    if (text == NULL || text_length > sizeof(display_text) - suffix_length - 1u) {
        result->record_index = record_index;
        return finish_result(result, WORLD_CLOCK_ERR_BOUNDS,
                             WORLD_CLOCK_TRIGGER_CAPTION_PRESENT);
    }

    memcpy(display_text, text, text_length);
    memcpy(display_text + text_length, ORIGINAL_CAPTION_SUFFIX,
           suffix_length + 1u);
    memset(&effect, 0, sizeof(effect));
    effect.kind = WORLD_CLOCK_EFFECT_SHOW_CAPTION;
    effect.record_index = record_index;
    effect.caption_source = caption_source;
    effect.text = display_text;
    effect.text_length = text_length + suffix_length;
    result_code = emit_host_effect(sink, &effect, record_index,
                                   WORLD_CLOCK_TRIGGER_CAPTION_PRESENT,
                                   result);
    return result_code;
}

static int write_event_flag(WorldInitState *world,
                            int16_t flag_id,
                            int16_t flag_value,
                            uint16_t record_index,
                            uint16_t pair_index,
                            WorldClockResult *result)
{
    ActionCoreWorld *core = world->action_core;

    result->record_index = record_index;
    result->pair_index = pair_index;
    result->event_flag_id = flag_id;
    result->trigger = WORLD_CLOCK_TRIGGER_EVENT_FLAG;
    if (flag_id < 0 || core == NULL || core->event_flags == NULL ||
        (size_t)flag_id >= core->event_flag_count) {
        return finish_result(result, WORLD_CLOCK_ERR_BOUNDS,
                             WORLD_CLOCK_TRIGGER_EVENT_FLAG);
    }
    core->event_flags[flag_id] = (int32_t)flag_value;
    result->partial_state_committed = 1u;
    return WORLD_CLOCK_OK;
}

static void reset_completed_record(uint8_t *record)
{
    size_t pair_index;

    /* Runtime completion calls original 0x433bd2. Its byte pattern matches
     * the record initializer also used by world_init's New Game path. */
    memset(record, 0, WORLD_CLOCK_TIME_RECORD_SIZE);
    memcpy(record + RECORD_SOUND_OFFSET, ORIGINAL_NO_SOUND,
           sizeof(ORIGINAL_NO_SOUND));
    for (pair_index = 0u; pair_index < RECORD_FLAG_PAIR_COUNT; ++pair_index) {
        store_i16_le(record + RECORD_FLAG_PAIR_OFFSET + pair_index * 4u, -1);
    }
}

static int complete_timer_record(WorldClockSession *session,
                                 WorldClockEffectSink *sink,
                                 uint8_t *record,
                                 uint16_t record_index,
                                 int32_t status,
                                 WorldClockResult *result)
{
    const char *sound_name;
    size_t sound_length;
    size_t pair_index;
    int string_ok;
    int result_code;

    store_i32_le(record + RECORD_COMPLETED_OFFSET, 1);
    result->partial_state_committed = 1u;

    for (pair_index = 0u; pair_index < RECORD_FLAG_PAIR_COUNT; ++pair_index) {
        size_t offset = RECORD_FLAG_PAIR_OFFSET + pair_index * 4u;
        int16_t flag_id = load_i16_le(record + offset);
        int16_t flag_value = load_i16_le(record + offset + 2u);

        if (flag_id != -1) {
            result_code = write_event_flag(session->world, flag_id, flag_value,
                                           record_index, (uint16_t)pair_index,
                                           result);
            if (result_code != WORLD_CLOCK_OK) {
                return result_code;
            }
        }
    }

    for (pair_index = 0u; pair_index < RECORD_FLAG_PAIR_COUNT; ++pair_index) {
        store_i16_le(record + RECORD_FLAG_PAIR_OFFSET + pair_index * 4u, -1);
    }
    result->partial_state_committed = 1u;

    string_ok = bounded_c_string(record + RECORD_SOUND_OFFSET,
                                 WORLD_CLOCK_TIME_RECORD_SIZE -
                                     RECORD_SOUND_OFFSET,
                                 &sound_name, &sound_length);
    if (!string_ok) {
        result->record_index = record_index;
        return finish_result(result, WORLD_CLOCK_ERR_FORMAT,
                             WORLD_CLOCK_TRIGGER_SOUND_DESCRIPTOR);
    }
    if (!(sound_length == sizeof(ORIGINAL_NO_SOUND) - 1u &&
          memcmp(sound_name, ORIGINAL_NO_SOUND,
                 sizeof(ORIGINAL_NO_SOUND) - 1u) == 0)) {
        WorldClockEffect effect;
        memset(&effect, 0, sizeof(effect));
        effect.kind = WORLD_CLOCK_EFFECT_LOAD_SOUND_DESCRIPTOR;
        effect.record_index = record_index;
        effect.sound_channel = (uint16_t)record[RECORD_SOUND_CHANNEL_OFFSET] |
                               (uint16_t)((uint16_t)record[
                                   RECORD_SOUND_CHANNEL_OFFSET + 1u] << 8);
        memcpy(effect.sound_descriptor, record + RECORD_SOUND_OFFSET,
               RECORD_SOUND_DESCRIPTOR_SIZE);
        result_code = emit_host_effect(sink, &effect, record_index,
                                       WORLD_CLOCK_TRIGGER_SOUND_DESCRIPTOR,
                                       result);
        if (result_code != WORLD_CLOCK_OK) {
            return result_code;
        }

        memset(&effect, 0, sizeof(effect));
        effect.kind = WORLD_CLOCK_EFFECT_PLAY_SOUND_CHANNEL;
        effect.record_index = record_index;
        effect.sound_channel = (uint16_t)record[RECORD_SOUND_CHANNEL_OFFSET] |
                               (uint16_t)((uint16_t)record[
                                   RECORD_SOUND_CHANNEL_OFFSET + 1u] << 8);
        result_code = emit_host_effect(sink, &effect, record_index,
                                       WORLD_CLOCK_TRIGGER_SOUND_CHANNEL_PLAY,
                                       result);
        if (result_code != WORLD_CLOCK_OK) {
            return result_code;
        }
    }

    if (session->captions_enabled_5bb202 != 0u) {
        const char *caption_key;
        size_t caption_key_length;

        string_ok = bounded_c_string(
            record + RECORD_CAPTION_KEY_OFFSET,
            WORLD_CLOCK_TIME_RECORD_SIZE - RECORD_CAPTION_KEY_OFFSET,
            &caption_key, &caption_key_length);
        if (!string_ok) {
            result->record_index = record_index;
            return finish_result(result, WORLD_CLOCK_ERR_FORMAT,
                                 WORLD_CLOCK_TRIGGER_CAPTION_LOOKUP);
        }

        if (caption_key_length != 0u) {
            const char *resolved_text = NULL;
            size_t resolved_length = 0u;
            WorldClockCaptionStatus caption_status;

            result->record_index = record_index;
            result->trigger = WORLD_CLOCK_TRIGGER_CAPTION_LOOKUP;
            if (sink == NULL || sink->resolve_caption == NULL) {
                return finish_result(result,
                                     WORLD_CLOCK_ERR_CAPTION_UNAVAILABLE,
                                     WORLD_CLOCK_TRIGGER_CAPTION_LOOKUP);
            }
            caption_status = sink->resolve_caption(
                sink->context, caption_key, caption_key_length,
                &resolved_text, &resolved_length);
            if (caption_status == WORLD_CLOCK_CAPTION_UNAVAILABLE) {
                return finish_result(result,
                                     WORLD_CLOCK_ERR_CAPTION_UNAVAILABLE,
                                     WORLD_CLOCK_TRIGGER_CAPTION_LOOKUP);
            }
            if (caption_status == WORLD_CLOCK_CAPTION_FOUND &&
                resolved_text == NULL && resolved_length != 0u) {
                return finish_result(result, WORLD_CLOCK_ERR_CAPTION_RESULT,
                                     WORLD_CLOCK_TRIGGER_CAPTION_LOOKUP);
            }
            if (caption_status == WORLD_CLOCK_CAPTION_FOUND &&
                resolved_text != NULL &&
                resolved_length <= WORLD_CLOCK_CAPTION_LIMIT) {
                result_code = emit_caption_effect(
                    sink, resolved_text, resolved_length,
                    WORLD_CLOCK_CAPTION_FROM_RESOLVER, record_index, result);
                if (result_code != WORLD_CLOCK_OK) {
                    return result_code;
                }
                goto finish_completion;
            }
            /* A miss or overlength resolved string takes the original fallback. */
        }

        {
            const char *fallback;
            size_t fallback_length;

            string_ok = bounded_c_string(
                record + RECORD_CAPTION_FALLBACK_OFFSET,
                WORLD_CLOCK_TIME_RECORD_SIZE - RECORD_CAPTION_FALLBACK_OFFSET,
                &fallback, &fallback_length);
            if (!string_ok) {
                result->record_index = record_index;
                return finish_result(result, WORLD_CLOCK_ERR_FORMAT,
                                     WORLD_CLOCK_TRIGGER_CAPTION_LOOKUP);
            }
            if (fallback_length != 0u) {
                result_code = emit_caption_effect(
                    sink, fallback, fallback_length,
                    WORLD_CLOCK_CAPTION_FROM_FALLBACK, record_index, result);
                if (result_code != WORLD_CLOCK_OK) {
                    return result_code;
                }
            }
        }
    }

finish_completion:
    if (status == 5) {
        reset_completed_record(record);
    } else {
        store_i32_le(record + RECORD_STATUS_OFFSET, 1);
    }
    result->partial_state_committed = 1u;
    return WORLD_CLOCK_OK;
}

static int update_normal_records(WorldClockSession *session,
                                 uint32_t delta,
                                 WorldClockEffectSink *sink,
                                 WorldClockResult *result)
{
    size_t record_index;

    for (record_index = 0u; record_index < WORLD_CLOCK_TIME_RECORD_COUNT;
         ++record_index) {
        uint8_t *record = session->world->time_records_585d65 +
                          record_index * WORLD_CLOCK_TIME_RECORD_SIZE;
        int32_t status = load_i32_le(record + RECORD_STATUS_OFFSET);
        uint32_t elapsed;

        if (status != 1 && status != 5 && status != 6) {
            continue;
        }

        elapsed = load_u32_le(record + RECORD_ELAPSED_OFFSET) + delta;
        store_u32_le(record + RECORD_ELAPSED_OFFSET, elapsed);
        update_record_display(record, elapsed);
        result->partial_state_committed = 1u;

        if (status == 5 || status == 6) {
            int32_t target = load_i32_le(record + RECORD_TARGET_OFFSET);
            int32_t completed = load_i32_le(record + RECORD_COMPLETED_OFFSET);
            if (target > 0 && completed == 0 &&
                target <= bits_to_i32(elapsed)) {
                int result_code;
                result->record_index = (uint16_t)record_index;
                result_code = complete_timer_record(
                    session, sink, record, (uint16_t)record_index, status,
                    result);
                if (result_code != WORLD_CLOCK_OK) {
                    return result_code;
                }
            }
        }
    }
    return WORLD_CLOCK_OK;
}

static int update_first_day_event(WorldClockSession *session,
                                  WorldClockResult *result)
{
    WorldInitClock *clock = &session->world->clock;

    if (clock->day_counter == 1 &&
        clock->configured_hour >= clock->first_day_event_hour &&
        clock->first_day_event_flag_id != -1) {
        return write_event_flag(session->world,
                                clock->first_day_event_flag_id, 1,
                                UINT16_MAX, UINT16_MAX, result);
    }
    return WORLD_CLOCK_OK;
}

int world_clock_update_normal(WorldClockSession *session,
                              uint32_t sampled_tick,
                              WorldClockEffectSink *sink,
                              WorldClockResult *result)
{
    WorldInitClock *clock;
    uint32_t delta = 0u;
    int status;

    if (result == NULL) {
        return WORLD_CLOCK_ERR_ARGUMENT;
    }
    initialize_result(result);
    status = validate_session(session, result);
    if (status != WORLD_CLOCK_OK) {
        return status;
    }

    clock = &session->world->clock;
    if (clock->run_start_tick < sampled_tick) {
        delta = sampled_tick - clock->run_start_tick;
        clock->run_start_tick = sampled_tick;
        result->partial_state_committed = 1u;
    }
    result->delta_ms = delta;

    clock->run_elapsed_ticks += delta;
    update_display_words_u32(clock->run_elapsed_ticks,
                             &clock->run_display_word_0,
                             &clock->run_display_word_1,
                             &clock->run_display_word_2);
    result->partial_state_committed = 1u;

    status = update_normal_records(session, delta, sink, result);
    if (status != WORLD_CLOCK_OK) {
        return status;
    }

    clock->scene_elapsed_ticks += delta;
    update_display_words_u32(clock->scene_elapsed_ticks,
                             &clock->scene_display_word_0,
                             &clock->scene_display_word_1,
                             &clock->scene_display_word_2);
    result->partial_state_committed = 1u;

    if (sampled_tick >= clock->next_update_tick) {
        clock->next_update_tick = sampled_tick +
            (uint32_t)(int32_t)clock->update_interval_ms;
        clock->configured_minute =
            wrap_i16((int32_t)clock->configured_minute + 1);
        result->partial_state_committed = 1u;
    }

    if (clock->configured_minute >= 60) {
        int16_t carry = (int16_t)(clock->configured_minute / 60);
        clock->configured_hour =
            wrap_i16((int32_t)clock->configured_hour + carry);
        clock->configured_minute =
            wrap_i16((int32_t)clock->configured_minute -
                     (int32_t)carry * 60);
        result->partial_state_committed = 1u;
    } else if (clock->configured_minute < 0) {
        clock->configured_hour =
            wrap_i16((int32_t)clock->configured_hour - 1);
        clock->configured_minute =
            wrap_i16((int32_t)clock->configured_minute + 60);
        result->partial_state_committed = 1u;
    }

    {
        int skip_day_event = 0;
        if (clock->configured_hour >= 24) {
            clock->configured_hour =
                wrap_i16((int32_t)clock->configured_hour - 24);
            clock->day_counter = wrap_i16((int32_t)clock->day_counter + 1);
            skip_day_event = 1;
            result->partial_state_committed = 1u;
        } else if (clock->configured_hour < 0) {
            clock->configured_hour =
                wrap_i16((int32_t)clock->configured_hour + 24);
            if (clock->day_counter > 0) {
                clock->day_counter =
                    wrap_i16((int32_t)clock->day_counter - 1);
            }
            skip_day_event = 1;
            result->partial_state_committed = 1u;
        }

        if (skip_day_event == 0) {
            status = update_first_day_event(session, result);
            if (status != WORLD_CLOCK_OK) {
                return status;
            }
        }
    }

    clock->total_minutes =
        (int32_t)clock->configured_hour * INT32_C(60) +
        (int32_t)clock->configured_minute;
    if (clock->total_minutes < session->time_window_start_5b0284 ||
        clock->total_minutes > session->time_window_end_5b0286) {
        session->outside_window_flag_5bb20a = 1;
    } else {
        session->outside_window_flag_5bb20a = 0;
    }
    result->partial_state_committed = 1u;
    result->continuation_va = WORLD_CLOCK_CONTINUE_NORMAL_POST_CLOCK;
    return finish_result(result, WORLD_CLOCK_OK,
                         WORLD_CLOCK_TRIGGER_POST_CLOCK_CONTINUATION);
}

int world_clock_update_offmode(WorldClockSession *session,
                               uint32_t sampled_tick,
                               int restoring,
                               WorldClockResult *result)
{
    WorldInitClock *clock;
    uint32_t pause_delta = 0u;
    size_t record_index;
    int status;

    if (result == NULL) {
        return WORLD_CLOCK_ERR_ARGUMENT;
    }
    initialize_result(result);
    status = validate_session(session, result);
    if (status != WORLD_CLOCK_OK) {
        return status;
    }

    clock = &session->world->clock;
    clock->previous_tick_61 = sampled_tick;
    result->partial_state_committed = 1u;

    if (restoring == 0 && clock->previous_tick_5d < sampled_tick) {
        pause_delta = sampled_tick - clock->previous_tick_5d;
        clock->run_elapsed_ticks =
            subtract_and_clamp(clock->run_elapsed_ticks, pause_delta);
        clock->scene_elapsed_ticks =
            subtract_and_clamp(clock->scene_elapsed_ticks, pause_delta);
        for (record_index = 0u;
             record_index < WORLD_CLOCK_TIME_RECORD_COUNT; ++record_index) {
            uint8_t *record = session->world->time_records_585d65 +
                              record_index * WORLD_CLOCK_TIME_RECORD_SIZE;
            int32_t record_status = load_i32_le(record + RECORD_STATUS_OFFSET);
            if (record_status == 1 || record_status == 5 || record_status == 6) {
                uint32_t elapsed = load_u32_le(record + RECORD_ELAPSED_OFFSET);
                store_u32_le(record + RECORD_ELAPSED_OFFSET,
                             subtract_and_clamp(elapsed, pause_delta));
                result->partial_state_committed = 1u;
            }
        }
    }
    result->delta_ms = pause_delta;
    result->continuation_va = WORLD_CLOCK_CONTINUE_OFFMODE_CLEANUP;
    return finish_result(result, WORLD_CLOCK_ERR_CONTINUATION_REQUIRED,
                         WORLD_CLOCK_TRIGGER_OFFMODE_CLEANUP);
}

int world_clock_condition_read(const WorldInitState *state,
                               uint16_t opcode,
                               int32_t *value_out)
{
    int32_t value;

    if (state == NULL || value_out == NULL) {
        return WORLD_CLOCK_ERR_ARGUMENT;
    }
    switch (opcode) {
    case 4:
        value = bits_to_i32(state->clock.run_elapsed_ticks);
        break;
    case 5:
        value = bits_to_i32(state->clock.scene_elapsed_ticks);
        break;
    case 6:
        value = state->clock.total_minutes;
        break;
    default:
        return WORLD_CLOCK_ERR_UNSUPPORTED_OPCODE;
    }
    *value_out = value;
    return WORLD_CLOCK_OK;
}

const char *world_clock_status_string(int status)
{
    switch (status) {
    case WORLD_CLOCK_OK:
        return "ok";
    case WORLD_CLOCK_ERR_ARGUMENT:
        return "invalid world-clock argument";
    case WORLD_CLOCK_ERR_BOUNDS:
        return "world-clock view is out of bounds";
    case WORLD_CLOCK_ERR_FORMAT:
        return "unterminated timer-record string";
    case WORLD_CLOCK_ERR_UNSUPPORTED_OPCODE:
        return "unsupported live clock condition opcode";
    case WORLD_CLOCK_ERR_HOST_UNAVAILABLE:
        return "required sound or caption host boundary is unavailable";
    case WORLD_CLOCK_ERR_CAPTION_UNAVAILABLE:
        return "caption lookup host boundary is unavailable";
    case WORLD_CLOCK_ERR_CAPTION_RESULT:
        return "invalid caption resolver result";
    case WORLD_CLOCK_ERR_CONTINUATION_REQUIRED:
        return "source-backed clock prefix requires caller continuation";
    default:
        return "unknown world-clock status";
    }
}
