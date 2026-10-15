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
 *   repeat marker +0x19e          the delayed-repeat marker live_audio_service
 *                                 arms (raw flag 0x10, never set by scene data).
 *   pause gates +0x16e/+0x172     0. live_audio has no pause gate.
 *
 * RT-11.1: a started channel with raw control word 0 is no longer refused.
 * live_audio_service models the original's completed-channel update
 * (0x4f55d5, S04-1): a non-stream channel is played again by the pump, and a
 * stream-class channel (decoded bytes > 0x56220) loops forever on the host,
 * so GetStatus reads "playing" for it exactly as the original ring does. In
 * the single pump gap between a buffer's end and its restart the original
 * also reads "stopped", which this adapter reports faithfully.
 *
 * What it still refuses to answer: a channel whose update live_audio refused
 * (raw flag 0x20 fade stages, or a flag-0x10 repeat without a random source).
 * Runtime-0x9f scene sounds carry flags 0, so those states are only reachable
 * through live_audio_set_channel_flags (runtime types 0x98/0x99 write other
 * flags and have no native producer yet; see live_audio.h).
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
