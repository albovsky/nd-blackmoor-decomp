#include "session_bindings_conditions_audio.h"

#include "live_audio.h"

#include <string.h>

ConditionExtraHostStatus session_conditions_live_audio_channel_record(
    void *audio_context, uint16_t channel,
    SessionConditionsChannelRecord *record)
{
    LiveAudio *audio = (LiveAudio *)audio_context;
    LiveAudioChannelInfo info;
    int still_playing = 0;

    if (audio == NULL || record == NULL) {
        return CONDITION_EXTRA_HOST_UNAVAILABLE;
    }
    memset(&info, 0, sizeof(info));
    if (live_audio_get_channel_info(audio, channel, &info) != LIVE_AUDIO_OK) {
        return CONDITION_EXTRA_HOST_UNAVAILABLE;
    }
    memset(record, 0, sizeof(*record));
    record->device_ready_1a0 = 1u;
    if (info.loaded == 0u) {
        return CONDITION_EXTRA_HOST_OK;       /* +0x162 and +0x28f are clear */
    }
    if (live_audio_is_playing(audio, channel, &still_playing) !=
        ACTION_SOUND_BACKEND_OK) {
        return CONDITION_EXTRA_HOST_UNAVAILABLE;
    }
    if (still_playing == 0 && info.started != 0u && info.control_word == 0u) {
        /* Delayed-repeat/restart state of raw control 0 is not modelled. */
        return CONDITION_EXTRA_HOST_UNAVAILABLE;
    }
    record->resource_ready_162 = 1u;
    record->buffer_available_28f = 1u;
    record->get_status_hresult = 0;
    record->get_status_flags = still_playing != 0 ? 1u : 0u;
    return CONDITION_EXTRA_HOST_OK;
}
