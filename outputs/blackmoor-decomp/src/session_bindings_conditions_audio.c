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
    if (info.update_refused != 0u) {
        /* The channel completed and live_audio refused its 0x4f55d5 update
         * (fade stages or an unseeded repeat draw, neither reachable from
         * scene data): its state is not the original's, so the answer is
         * unavailable rather than a false idle. */
        return CONDITION_EXTRA_HOST_UNAVAILABLE;
    }
    if (live_audio_is_playing(audio, channel, &still_playing) !=
        ACTION_SOUND_BACKEND_OK) {
        return CONDITION_EXTRA_HOST_UNAVAILABLE;
    }
    record->resource_ready_162 = 1u;
    record->buffer_available_28f = 1u;
    /* +0x19e: an armed delayed repeat (flag 0x10) makes 0x4f6334 report busy
     * through its marker branch instead of GetStatus. */
    record->repeat_marker_19e = info.repeat_marker;
    record->get_status_hresult = 0;
    record->get_status_flags = still_playing != 0 ? 1u : 0u;
    return CONDITION_EXTRA_HOST_OK;
}
