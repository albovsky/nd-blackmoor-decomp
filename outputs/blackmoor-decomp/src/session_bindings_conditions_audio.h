#ifndef BLACKMOOR_SESSION_BINDINGS_CONDITIONS_AUDIO_H
#define BLACKMOOR_SESSION_BINDINGS_CONDITIONS_AUDIO_H

/* RT-4: opcode-17 channel record for the RT-1 live audio provider.
 *
 * Maps what live_audio can observe onto the values original 0x4f6334 reads
 * (see SessionConditionsChannelRecord):
 *
 *   device ready (+0x1a0)         1: a LiveAudio exists, so its host opened.
 *   resource ready / buffer       1 when the channel is loaded, else 0 (the
 *                                 original clears +0x162 and +0x28f on unload).
 *   GetStatus bit 0               live_audio_is_playing for the channel.
 *   repeat marker +0x19e, gates   0. live_audio never arms a delayed repeat or
 *                                 a pause gate.
 *
 * What it refuses to answer: a channel that was started, is no longer playing
 * and carries raw control word 0. The original's channel update (0x4f55d5,
 * S04-1) restarts such a channel or arms the delayed-repeat marker, after
 * which 0x4f6334 reports the marker branch; live_audio does neither, so the
 * adapter reports HOST_UNAVAILABLE rather than a false idle. Sounds with raw
 * control 1 (the corpus majority: 3,142 + 84 of 3,570) are exact.
 *
 * `audio_context` is the LiveAudio*. Main thread only (live_audio's rule). */

#include "session_bindings_conditions.h"

#ifdef __cplusplus
extern "C" {
#endif

ConditionExtraHostStatus session_conditions_live_audio_channel_record(
    void *audio_context, uint16_t channel,
    SessionConditionsChannelRecord *record);

#ifdef __cplusplus
}
#endif

#endif
