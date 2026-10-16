#include "sound_control.h"

#include <math.h>
#include <string.h>

enum {
    SOUND_CONTROL_ERROR_IDLE = 0x3E8,
    SOUND_CONTROL_ERROR_DEVICE_NOT_READY = 0x3EA,
    SOUND_CONTROL_ERROR_BUFFER_MISSING = 0x3EF,
    SOUND_CONTROL_ERROR_PLAY_FAILED = 0x403,
    SOUND_CONTROL_ERROR_VOLUME_FAILED = 0x408
};

static int32_t signed_bits(uint32_t value)
{
    int32_t result;
    memcpy(&result, &value, sizeof(result));
    return result;
}

static int32_t clamp_attenuation(int32_t value)
{
    if (value >= 0) return 0;
    if (value < SOUND_CONTROL_MIN_ATTENUATION)
        return SOUND_CONTROL_MIN_ATTENUATION;
    return value;
}

static void set_result_error(SoundControlState *state,
                             SoundControlResult *result,
                             uint32_t error)
{
    state->device_error = error;
    result->original_error = error;
}

int sound_control_initialize_categories(
    uint8_t categories[SOUND_CONTROL_CHANNEL_COUNT])
{
    static const uint8_t category0[] = {12u, 13u, 30u};
    static const uint8_t category1[] = {0u, 1u, 2u, 26u, 27u, 29u, 19u};
    static const uint8_t category2[] = {
        3u, 4u, 5u, 6u, 7u, 8u, 9u, 10u, 11u, 20u,
        24u, 25u, 23u, 22u, 21u, 31u, 18u, 17u
    };
    size_t index;

    if (categories == NULL) return SOUND_CONTROL_ERR_ARGUMENT;
    memset(categories, 3, SOUND_CONTROL_CHANNEL_COUNT);
    for (index = 0u; index < sizeof(category0); ++index)
        categories[category0[index]] = 0u;
    for (index = 0u; index < sizeof(category1); ++index)
        categories[category1[index]] = 1u;
    for (index = 0u; index < sizeof(category2); ++index)
        categories[category2[index]] = 2u;
    return SOUND_CONTROL_OK;
}

int sound_control_calculate_attenuation(float scalar, float master,
                                        uint16_t raw_x87_control_word,
                                        int32_t *attenuation)
{
    volatile double product1;
    volatile double product2;
    volatile double expression;

    if (attenuation == NULL || !isfinite(scalar) || !isfinite(master) ||
        scalar < 0.0f || scalar > 1.0f || master < 0.0f || master > 1.0f) {
        return SOUND_CONTROL_ERR_ARGUMENT;
    }
    /* Only the startup-observed x87 PC=53 / RC=nearest path is claimed.
     * Reserved CW bits (including bit 6) do not alter this arithmetic. */
    if ((raw_x87_control_word & UINT16_C(0x0F00)) != UINT16_C(0x0200)) {
        return SOUND_CONTROL_ERR_UNSUPPORTED;
    }

    product1 = (double)scalar * (double)master;
    product2 = product1 * 2857.142822265625;
    expression = product2 - 2857.142857142857;
    if (expression > 1.0 || expression < -2858.0) {
        return SOUND_CONTROL_ERR_ARGUMENT;
    }
    /* C's finite in-range signed conversion truncates toward zero, matching
     * the original __ftol helper after its temporary RC=truncate change. */
    *attenuation = (int32_t)expression;
    return SOUND_CONTROL_OK;
}

static int play_internal(SoundControlState *state, uint16_t channel,
                         SoundControlHost *host,
                         SoundControlResult *result)
{
    SoundControlChannel *slot = &state->channels[channel];
    SoundControlHostStatus host_status;
    uint32_t flags = 0u;
    int32_t host_result = 0;

    state->device_error = SOUND_CONTROL_ERROR_IDLE;
    state->device_state = 1u;
    if (state->device_ready == 0u) {
        state->device_state = 0u;
        set_result_error(state, result, SOUND_CONTROL_ERROR_DEVICE_NOT_READY);
        return SOUND_CONTROL_OK;
    }
    if (slot->resource_ready == 0u || slot->buffer_available == 0u) {
        state->device_state = 0u;
        set_result_error(state, result, SOUND_CONTROL_ERROR_BUFFER_MISSING);
        return SOUND_CONTROL_OK;
    }

    if ((slot->raw_control == 0u && (slot->raw_flags & 0x0001u) != 0u) ||
        slot->stream_state != 0u || (slot->raw_flags & 0x0100u) != 0u) {
        flags |= 1u;
    }
    slot->update_gate_287 = 0u;
    result->play_flags = flags;
    result->play_attempted = 1u;
    state->host_result = 0;
    if (host == NULL || host->play_buffer == NULL) {
        return SOUND_CONTROL_ERR_UNSUPPORTED;
    }

    host_status = host->play_buffer(host->context, channel, flags,
                                    &host_result);
    if (host_status == SOUND_CONTROL_HOST_UNSUPPORTED) {
        return SOUND_CONTROL_ERR_UNSUPPORTED;
    }
    if (host_status != SOUND_CONTROL_HOST_OK &&
        host_status != SOUND_CONTROL_HOST_ERROR) {
        return SOUND_CONTROL_ERR_UNSUPPORTED;
    }
    state->host_result = host_result;
    if (host_status == SOUND_CONTROL_HOST_ERROR || host_result != 0) {
        state->device_state = 0u;
        set_result_error(state, result, SOUND_CONTROL_ERROR_PLAY_FAILED);
        return SOUND_CONTROL_OK;
    }
    result->played = 1u;
    return SOUND_CONTROL_OK;
}

/* The Play wrapper, original 0x4f6059 (398 bytes): error words 1000/0x3ea/0x3ef,
 * the loop-flag rule, the 0x287 gate clear and the host Play call. Compared with
 * the original by tests/sound_control_original_oracle.py (original_play_trace). */
int sound_control_play(SoundControlState *state, uint16_t channel,
                       SoundControlHost *host, SoundControlResult *result)
{
    if (result == NULL) return SOUND_CONTROL_ERR_ARGUMENT;
    memset(result, 0, sizeof(*result));
    if (state == NULL || channel >= SOUND_CONTROL_CHANNEL_COUNT)
        return SOUND_CONTROL_ERR_ARGUMENT;
    return play_internal(state, channel, host, result);
}

/* The per-channel update, original 0x4f55d5: gate checks, the three fade stages,
 * the random repeat delay and the restart through the Play wrapper. Compared with
 * the original by tests/sound_control_original_oracle.py (original_update_trace). */
int sound_control_update(SoundControlState *state, uint16_t channel,
                         SoundControlHost *host, SoundControlResult *result)
{
    SoundControlChannel *slot;
    uint32_t range_bits;
    int32_t range;
    int status;

    if (result == NULL) return SOUND_CONTROL_ERR_ARGUMENT;
    memset(result, 0, sizeof(*result));
    if (state == NULL || channel >= SOUND_CONTROL_CHANNEL_COUNT)
        return SOUND_CONTROL_ERR_ARGUMENT;
    if (host == NULL || host->tick_count == NULL)
        return SOUND_CONTROL_ERR_UNSUPPORTED;

    slot = &state->channels[channel];
    result->tick = host->tick_count(host->context);
    state->device_error = SOUND_CONTROL_ERROR_IDLE;
    if (slot->update_gate_287 != 0u || slot->update_gate_16e != 0u ||
        slot->update_gate_172 != 0u || slot->stream_state != 0u) {
        return SOUND_CONTROL_OK;
    }

    if ((slot->raw_flags & 0x0020u) != 0u) {
        if (host->fade_stage_1 == NULL || host->fade_stage_2 == NULL ||
            host->fade_stage_3 == NULL) {
            return SOUND_CONTROL_ERR_UNSUPPORTED;
        }
        host->fade_stage_1(host->context, channel);
        host->fade_stage_2(host->context, channel);
        host->fade_stage_3(host->context, channel);
    }
    if (slot->raw_control != 0u) return SOUND_CONTROL_OK;

    if ((slot->raw_flags & 0x0010u) != 0u) {
        int32_t random_number;
        int32_t remainder;
        uint32_t delay_bits;

        slot->repeat_marker = 1u;
        range_bits = (uint32_t)slot->repeat_max - (uint32_t)slot->repeat_min;
        range = signed_bits(range_bits);
        if (range > 0) {
            if (host->random_value == NULL)
                return SOUND_CONTROL_ERR_UNSUPPORTED;
            random_number = signed_bits(host->random_value(host->context));
            remainder = random_number % range;
            delay_bits = (uint32_t)remainder + (uint32_t)slot->repeat_min;
        } else {
            delay_bits = 0u;
        }
        slot->repeat_delay = delay_bits;
        slot->repeat_due_tick = result->tick + delay_bits;
        result->repeat_delay = delay_bits;
        result->repeat_due_tick = slot->repeat_due_tick;
        result->update_kind = SOUND_CONTROL_UPDATE_RANDOM_REPEAT;
        return SOUND_CONTROL_OK;
    }

    result->update_kind = SOUND_CONTROL_UPDATE_RESTART;
    /* `result` was zero-initialized at entry. Pass it through directly so the
     * play wrapper fills every observable field, including when an injected
     * host boundary returns UNSUPPORTED after the original state mutations. */
    status = play_internal(state, channel, host, result);
    return status;
}

static int apply_volume(SoundControlState *state, uint16_t channel,
                        SoundControlHost *host, uint32_t *original_error)
{
    SoundControlChannel *slot = &state->channels[channel];
    SoundControlHostStatus host_status;
    int32_t host_result = 0;

    state->device_error = SOUND_CONTROL_ERROR_IDLE;
    state->host_result = 0;
    if (state->device_ready == 0u) {
        state->device_state = 0u;
        state->device_error = SOUND_CONTROL_ERROR_DEVICE_NOT_READY;
        *original_error = state->device_error;
        return SOUND_CONTROL_OK;
    }
    if (slot->buffer_available == 0u) {
        state->device_state = 0u;
        state->device_error = SOUND_CONTROL_ERROR_BUFFER_MISSING;
        *original_error = state->device_error;
        return SOUND_CONTROL_OK;
    }

    slot->first_attenuation = clamp_attenuation(slot->first_attenuation);
    slot->second_attenuation = clamp_attenuation(slot->second_attenuation);
    if (host == NULL || host->set_first_attenuation == NULL)
        return SOUND_CONTROL_ERR_UNSUPPORTED;
    host_status = host->set_first_attenuation(
        host->context, channel, slot->first_attenuation, &host_result);
    if (host_status == SOUND_CONTROL_HOST_UNSUPPORTED)
        return SOUND_CONTROL_ERR_UNSUPPORTED;
    if (host_status != SOUND_CONTROL_HOST_OK &&
        host_status != SOUND_CONTROL_HOST_ERROR)
        return SOUND_CONTROL_ERR_UNSUPPORTED;
    state->host_result = host_result;
    if (host_status == SOUND_CONTROL_HOST_ERROR || host_result != 0) {
        state->device_state = 0u;
        state->device_error = SOUND_CONTROL_ERROR_VOLUME_FAILED;
        *original_error = state->device_error;
        return SOUND_CONTROL_OK;
    }
    return SOUND_CONTROL_OK;
}

int sound_control_set_master_absolute(SoundControlState *state,
                                      uint16_t category, uint16_t percent,
                                      uint16_t raw_x87_control_word,
                                      SoundControlHost *host,
                                      SoundControlMasterResult *result)
{
    volatile double percent_value;
    uint16_t channel;

    if (result == NULL) return SOUND_CONTROL_ERR_ARGUMENT;
    memset(result, 0, sizeof(*result));
    if (state == NULL || category >= SOUND_CONTROL_CATEGORY_COUNT)
        return SOUND_CONTROL_ERR_ARGUMENT;
    if ((raw_x87_control_word & UINT16_C(0x0F00)) != UINT16_C(0x0200))
        return SOUND_CONTROL_ERR_UNSUPPORTED;

    percent_value = (double)percent / 100.0;
    state->master[category] = (float)percent_value;
    if (!isfinite(state->master[category]) || state->master[category] < 0.0f)
        state->master[category] = 0.0f;
    if (state->master[category] > 1.0f)
        state->master[category] = 1.0f;

    for (channel = 0u; channel < SOUND_CONTROL_CHANNEL_COUNT; ++channel) {
        SoundControlChannel *slot = &state->channels[channel];
        int32_t first;
        int32_t second;
        int status;
        uint32_t channel_error = 0u;

        if (slot->volume_category != category ||
            slot->volume_update_state != 1u) {
            continue;
        }
        status = sound_control_calculate_attenuation(
            slot->first_scalar, state->master[category],
            raw_x87_control_word, &first);
        if (status != SOUND_CONTROL_OK) return status;
        status = sound_control_calculate_attenuation(
            slot->second_scalar, state->master[category],
            raw_x87_control_word, &second);
        if (status != SOUND_CONTROL_OK) return status;
        slot->first_attenuation = first;
        slot->second_attenuation = second;
        ++result->updated_channels;

        status = apply_volume(state, channel, host, &channel_error);
        if (status != SOUND_CONTROL_OK) return status;
        if (host != NULL && host->set_first_attenuation != NULL &&
            state->device_ready != 0u && slot->buffer_available != 0u) {
            /* The observed 0x4f684a boundary passes the first stored value to
             * DirectSound SetVolume. The second remains separately stored. */
            ++result->volume_calls;
        }
        if (channel_error != 0u) {
            result->has_failed_channel = 1u;
            result->failed_channel = channel;
            result->original_error = channel_error;
        }
    }
    return SOUND_CONTROL_OK;
}

static int32_t attenuation_unchecked(float scalar, float master)
{
    volatile double product1;
    volatile double product2;
    volatile double expression;

    product1 = (double)scalar * (double)master;
    product2 = product1 * 2857.142822265625;
    expression = product2 - 2857.142857142857;
    return (int32_t)expression;
}

int sound_control_set_scalars(SoundControlState *state, uint16_t channel,
                              float first_scalar, float second_scalar,
                              uint16_t raw_x87_control_word,
                              SoundControlHost *host,
                              SoundControlMasterResult *result)
{
    SoundControlChannel *slot;
    float master;
    uint32_t channel_error = 0u;
    int status;

    if (result == NULL) return SOUND_CONTROL_ERR_ARGUMENT;
    memset(result, 0, sizeof(*result));
    if (state == NULL || channel >= SOUND_CONTROL_CHANNEL_COUNT ||
        !isfinite(first_scalar) || first_scalar < 0.0f || first_scalar > 100.0f ||
        !isfinite(second_scalar) || second_scalar < 0.0f || second_scalar > 100.0f) {
        return SOUND_CONTROL_ERR_ARGUMENT;
    }
    slot = &state->channels[channel];
    if (slot->volume_category >= SOUND_CONTROL_CATEGORY_COUNT)
        return SOUND_CONTROL_ERR_ARGUMENT;
    master = state->master[slot->volume_category];
    if (!isfinite(master) || master < 0.0f || master > 1.0f)
        return SOUND_CONTROL_ERR_ARGUMENT;
    if ((raw_x87_control_word & UINT16_C(0x0F00)) != UINT16_C(0x0200))
        return SOUND_CONTROL_ERR_UNSUPPORTED;

    slot->first_scalar = first_scalar;
    slot->second_scalar = second_scalar;
    slot->first_attenuation = attenuation_unchecked(first_scalar, master);
    slot->second_attenuation = attenuation_unchecked(second_scalar, master);
    status = apply_volume(state, channel, host, &channel_error);
    if (status != SOUND_CONTROL_OK) return status;
    if (host != NULL && host->set_first_attenuation != NULL &&
        state->device_ready != 0u && slot->buffer_available != 0u) {
        ++result->volume_calls;
    }
    result->updated_channels = 1u;
    if (channel_error != 0u) {
        result->has_failed_channel = 1u;
        result->failed_channel = channel;
        result->original_error = channel_error;
    }
    return SOUND_CONTROL_OK;
}
