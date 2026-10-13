#include "action_sound.h"

#include <limits.h>
#include <string.h>

enum {
    ACTION_SOUND_FIXED_PREFIX_BYTES = 48u,
    ACTION_SOUND_AUTO_BODY_BYTES = 81u,
    ACTION_SOUND_PHASE_START = 0u,
    ACTION_SOUND_PHASE_WAIT = 1u,
    ACTION_SOUND_PHASE_FINISH = 2u,
    ACTION_SOUND_NO_TRANSITION = 9999
};

static const uint8_t missing_caption_fallback[] =
    "Missing closed captioning text string<h><n><o>";

static uint16_t read_u16le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static int16_t read_i16le(const uint8_t *bytes)
{
    uint16_t bits = read_u16le(bytes);
    int32_t value = (bits & UINT16_C(0x8000)) != 0u
                        ? (int32_t)bits - INT32_C(0x10000)
                        : (int32_t)bits;
    return (int16_t)value;
}

static uint32_t read_u32le(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] |
           ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) |
           ((uint32_t)bytes[3] << 24);
}

static size_t nul_length(const uint8_t *bytes, size_t capacity)
{
    size_t index;
    for (index = 0u; index < capacity; ++index) {
        if (bytes[index] == 0u) {
            return index;
        }
    }
    return capacity;
}

static float clamp_gain(int16_t percent)
{
    float gain = (float)percent / 100.0f;
    if (gain >= 1.0f) {
        return 1.0f;
    }
    if (gain <= 0.0f) {
        return 0.0f;
    }
    return gain;
}

static uint8_t volume_category_for_channel(uint16_t channel)
{
    static const uint8_t category_zero[] = {12u, 13u, 30u};
    static const uint8_t category_one[] = {0u, 1u, 2u, 26u, 27u, 29u, 19u};
    static const uint8_t category_two[] = {
        3u, 4u, 5u, 6u, 7u, 8u, 9u, 10u, 11u, 20u,
        24u, 25u, 23u, 22u, 21u, 31u, 18u, 17u
    };
    size_t index;

    /* 0x4faa03 initializes all 32 categories to 3 then applies these three
     * sentinel-terminated channel lists. */
    for (index = 0u; index < sizeof(category_zero); ++index) {
        if (channel == category_zero[index]) {
            return 0u;
        }
    }
    for (index = 0u; index < sizeof(category_one); ++index) {
        if (channel == category_one[index]) {
            return 1u;
        }
    }
    for (index = 0u; index < sizeof(category_two); ++index) {
        if (channel == category_two[index]) {
            return 2u;
        }
    }
    return 3u;
}

static int map_backend_status(ActionSoundBackendStatus backend_status)
{
    switch (backend_status) {
    case ACTION_SOUND_BACKEND_OK:
        return ACTION_SOUND_OK;
    case ACTION_SOUND_BACKEND_UNSUPPORTED:
        return ACTION_SOUND_ERR_UNSUPPORTED;
    case ACTION_SOUND_BACKEND_NO_RESOURCE:
    case ACTION_SOUND_BACKEND_ERROR:
    default:
        return ACTION_SOUND_ERR_BACKEND;
    }
}

static int decode_action(const ActionSoundAction *action,
                         ActionSoundAudioCommand *command,
                         uint16_t *caption_selector)
{
    const uint8_t *body;
    uint16_t selector;
    size_t expected_length;
    size_t stem_length;

    if (action == NULL || command == NULL || caption_selector == NULL ||
        action->body == NULL || action->body_length < ACTION_SOUND_FIXED_PREFIX_BYTES) {
        return ACTION_SOUND_ERR_BODY;
    }

    body = action->body;
    selector = read_u16le(body + 46u);
    if (selector == UINT16_MAX) {
        expected_length = ACTION_SOUND_AUTO_BODY_BYTES;
    } else {
        if (selector > ACTION_SOUND_MAX_LITERAL_BYTES) {
            return ACTION_SOUND_ERR_BODY;
        }
        expected_length = ACTION_SOUND_FIXED_PREFIX_BYTES + (size_t)selector;
    }
    if (action->body_length != expected_length) {
        return ACTION_SOUND_ERR_BODY;
    }

    stem_length = nul_length(body, ACTION_SOUND_STEM_BYTES);
    if (stem_length == ACTION_SOUND_STEM_BYTES) {
        /* The original path builder reads this field as a C string. Keep the
         * native read bounded instead of accepting an unterminated overread. */
        return ACTION_SOUND_ERR_UNSUPPORTED;
    }
    if ((size_t)read_u16le(body + 33u) >= ACTION_SOUND_CHANNEL_COUNT) {
        return ACTION_SOUND_ERR_UNSUPPORTED;
    }

    memset(command, 0, sizeof(*command));
    memcpy(command->asset_stem, body, stem_length);
    command->channel = read_u16le(body + 33u);
    command->volume_category = volume_category_for_channel(command->channel);
    command->control_word = read_u32le(body + 35u);
    command->first_percent = read_i16le(body + 39u);
    command->second_percent = read_i16le(body + 41u);
    command->first_gain = clamp_gain(command->first_percent);
    command->second_gain = clamp_gain(command->second_percent);
    command->mode = body[43u];
    command->transition_scene = read_i16le(body + 44u);
    *caption_selector = selector;
    return ACTION_SOUND_OK;
}

static int present_caption(ActionSoundBackend *backend,
                           const uint8_t *body,
                           uint16_t selector)
{
    ActionSoundCaptionRequest request;
    const uint8_t *caption_bytes;
    size_t caption_length;
    ActionSoundCaptionKind kind;
    ActionSoundBackendStatus status;

    if (selector == UINT16_MAX) {
        size_t key_length = nul_length(body + ACTION_SOUND_FIXED_PREFIX_BYTES,
                                       ACTION_SOUND_AUTO_TEXT_KEY_BYTES);
        const uint8_t *resolved_text = NULL;
        size_t resolved_length = 0u;

        if (key_length == ACTION_SOUND_AUTO_TEXT_KEY_BYTES ||
            backend == NULL || backend->resolve_auto_text == NULL) {
            return ACTION_SOUND_ERR_UNSUPPORTED;
        }
        status = backend->resolve_auto_text(
            backend->context, body + ACTION_SOUND_FIXED_PREFIX_BYTES,
            key_length, &resolved_text, &resolved_length);
        if (status == ACTION_SOUND_BACKEND_NO_RESOURCE) {
            /* 0x41c7f4's null lookup path copies the original embedded
             * fallback; the loader then applies its normal <e> suffix. */
            resolved_text = missing_caption_fallback;
            resolved_length = sizeof(missing_caption_fallback) - 1u;
        } else if (status != ACTION_SOUND_BACKEND_OK) {
            return map_backend_status(status);
        }
        if ((resolved_length != 0u && resolved_text == NULL) ||
            resolved_length > 40000u) {
            return ACTION_SOUND_ERR_UNSUPPORTED;
        }
        /* The original stores the resolved byte count in a 16-bit field and
         * the phase-0 handler tests it as a signed short before showing it. */
        if (resolved_length == 0u || resolved_length > (size_t)INT16_MAX) {
            return ACTION_SOUND_OK;
        }
        caption_bytes = resolved_text;
        caption_length = resolved_length;
        kind = ACTION_SOUND_CAPTION_RESOLVED_AUTO_TEXT;
    } else {
        if (selector == 0u) {
            return ACTION_SOUND_OK;
        }
        caption_bytes = body + ACTION_SOUND_FIXED_PREFIX_BYTES;
        caption_length = (size_t)selector;
        kind = ACTION_SOUND_CAPTION_LITERAL;
    }

    if (backend == NULL || backend->present_caption == NULL) {
        return ACTION_SOUND_ERR_UNSUPPORTED;
    }
    request.kind = kind;
    request.bytes = caption_bytes;
    request.length = caption_length;
    request.terminator = ACTION_SOUND_CAPTION_TERMINATOR;
    request.terminator_length = sizeof(ACTION_SOUND_CAPTION_TERMINATOR) - 1u;
    status = backend->present_caption(backend->context, &request);
    if (status == ACTION_SOUND_BACKEND_OK) {
        return ACTION_SOUND_OK;
    }
    if (status == ACTION_SOUND_BACKEND_NO_RESOURCE) {
        return ACTION_SOUND_ERR_UNSUPPORTED;
    }
    return map_backend_status(status);
}

static int finish_action(const ActionSoundAction *action,
                         ActionSoundStepResult *result)
{
    result->phase = 0u;
    if (action->subtype == 1u) {
        result->completion_valid = 1u;
        result->completed = 1u;
    } else if (action->subtype == 2u) {
        result->completion_valid = 1u;
        result->completed = 0u;
        result->reset_dependencies = 1u;
    }
    return ACTION_SOUND_OK;
}

int action_sound_step(const ActionSoundAction *action,
                      ActionSoundBackend *backend,
                      ActionSoundStepResult *result)
{
    ActionSoundAudioCommand command;
    uint16_t caption_selector;
    int status;

    if (result == NULL) {
        return ACTION_SOUND_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    if (action == NULL) {
        return ACTION_SOUND_ERR_ARGUMENT;
    }
    result->phase = action->phase_before;
    result->completed = action->completed_before;
    if (action->type != ACTION_SOUND_TYPE) {
        return ACTION_SOUND_ERR_UNSUPPORTED;
    }
    result->recognized = 1u;

    if (action->eligible == 0u) {
        if (action->subtype == 2u) {
            result->applied = 1u;
            result->completion_valid = 1u;
            result->completed = 0u;
            result->phase = 0u;
        }
        return ACTION_SOUND_OK;
    }

    if (action->phase_before > ACTION_SOUND_PHASE_FINISH) {
        return ACTION_SOUND_OK;
    }
    status = decode_action(action, &command, &caption_selector);
    if (status != ACTION_SOUND_OK) {
        return status;
    }
    result->applied = 1u;

    if (action->phase_before == ACTION_SOUND_PHASE_START) {
        ActionSoundBackendStatus backend_status;

        if (backend == NULL || backend->load_sound == NULL ||
            backend->play_sound == NULL) {
            return ACTION_SOUND_ERR_UNSUPPORTED;
        }
        if (action->captions_enabled != 0u &&
            action->scene_dispatch_argument != 0u &&
            (caption_selector == UINT16_MAX || caption_selector != 0u)) {
            status = present_caption(backend, action->body,
                                     caption_selector);
            if (status != ACTION_SOUND_OK) {
                return status;
            }
        }

        backend_status = backend->load_sound(backend->context, &command);
        if (backend_status == ACTION_SOUND_BACKEND_UNSUPPORTED ||
            backend_status == ACTION_SOUND_BACKEND_ERROR) {
            return map_backend_status(backend_status);
        }
        if (backend_status == ACTION_SOUND_BACKEND_OK) {
            backend_status = backend->play_sound(backend->context,
                                                 command.channel);
            if (backend_status == ACTION_SOUND_BACKEND_UNSUPPORTED ||
                backend_status == ACTION_SOUND_BACKEND_ERROR) {
                return map_backend_status(backend_status);
            }
            /* The original play wrapper logs a device failure but still marks
             * the channel active. A backend NO_RESOURCE therefore advances;
             * the later authoritative query decides whether it has finished. */
        }

        if (command.transition_scene == ACTION_SOUND_NO_TRANSITION &&
            command.control_word == 0u) {
            /* 0x9f's loader always passes event flag id -1, so this is the
             * handler's exact direct-completion predicate. */
            result->completion_valid = 1u;
            result->completed = 1u;
            result->phase = 0u;
        } else {
            result->phase = ACTION_SOUND_PHASE_WAIT;
        }
        return ACTION_SOUND_OK;
    }

    if (action->phase_before == ACTION_SOUND_PHASE_WAIT) {
        if (command.mode == 1u) {
            result->phase = ACTION_SOUND_PHASE_FINISH;
            return ACTION_SOUND_OK;
        }
        if (backend == NULL || backend->is_playing == NULL) {
            return ACTION_SOUND_ERR_UNSUPPORTED;
        }
        {
            int still_playing = 0;
            ActionSoundBackendStatus backend_status = backend->is_playing(
                backend->context, command.channel, &still_playing);
            if (backend_status == ACTION_SOUND_BACKEND_NO_RESOURCE) {
                still_playing = 0;
            } else if (backend_status != ACTION_SOUND_BACKEND_OK) {
                return map_backend_status(backend_status);
            }
            if (still_playing != 0 && still_playing != 1) {
                return ACTION_SOUND_ERR_BACKEND;
            }
            if (still_playing == 0) {
                result->phase = ACTION_SOUND_PHASE_FINISH;
            }
        }
        return ACTION_SOUND_OK;
    }

    if (command.transition_scene != ACTION_SOUND_NO_TRANSITION) {
        result->has_transition = 1u;
        result->stop_later_actions = 1u;
        result->transition.target_scene = command.transition_scene;
        result->transition.scene_flag_value = 1u;
        result->transition.engine_state_value = 4u;
    }
    if (command.mode == 0u) {
        ActionSoundBackendStatus backend_status;
        if (backend == NULL || backend->unload_sound == NULL) {
            return ACTION_SOUND_ERR_UNSUPPORTED;
        }
        backend_status = backend->unload_sound(backend->context,
                                               command.channel);
        if (backend_status == ACTION_SOUND_BACKEND_NO_RESOURCE) {
            /* The original unload operation is void and is harmless when the
             * channel has already disappeared. */
        } else if (backend_status != ACTION_SOUND_BACKEND_OK) {
            return map_backend_status(backend_status);
        }
    }
    return finish_action(action, result);
}

const char *action_sound_status_string(int status)
{
    switch (status) {
    case ACTION_SOUND_OK: return "ok";
    case ACTION_SOUND_ERR_ARGUMENT: return "invalid argument";
    case ACTION_SOUND_ERR_BODY: return "invalid 0x9f body";
    case ACTION_SOUND_ERR_UNSUPPORTED: return "unsupported 0x9f behavior";
    case ACTION_SOUND_ERR_BACKEND: return "sound backend failure";
    default: return "unknown action sound status";
    }
}
