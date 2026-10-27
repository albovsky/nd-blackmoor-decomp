#ifndef BLACKMOOR_PUZZLE_SOUND_H
#define BLACKMOOR_PUZZLE_SOUND_H

#include "action_sound.h"

#ifdef __cplusplus
extern "C" {
#endif

#define PUZZLE_SOUND_RECORD_BYTES 0x31u
#define PUZZLE_SOUND_LOADER_FLAGS 2
#define PUZZLE_SOUND_LOOP_MODE 1

typedef enum puzzle_sound_status {
    PUZZLE_SOUND_OK = 0,
    PUZZLE_SOUND_NO_RESOURCE = 1,
    PUZZLE_SOUND_ERR_ARGUMENT = 2,
    PUZZLE_SOUND_ERR_DESCRIPTOR = 3,
    PUZZLE_SOUND_ERR_UNSUPPORTED = 4,
    PUZZLE_SOUND_ERR_BACKEND = 5
} PuzzleSoundStatus;

/* Bounded native adapter for the descriptor consumed at 0x4fb77a. This is
 * host integration; no original-code, DirectSound, decoder or hardware parity
 * is claimed.
 *
 * The backend is borrowed by value (its context remains caller-owned). A
 * successful prepare owns playback eligibility for that channel until a
 * replacement prepare or stop. The caller must serialize access. If another
 * owner shares these channels, refresh prepared[channel] (0/1) from the
 * provider's authoritative loaded state before play/busy: these four backend
 * callbacks cannot observe another owner's load/unload. Backend load_sound
 * owns replacement/release of any previous clip, as
 * live_audio_load_sound does. Reinitialization does not release resources;
 * stop active descriptors before reinitializing or destroying the backend. */
typedef struct puzzle_sound {
    ActionSoundBackend backend;
    uint8_t prepared[ACTION_SOUND_CHANNEL_COUNT];
} PuzzleSound;

/* Requires all four audio callbacks. Failure leaves sound untouched. */
int puzzle_sound_init(PuzzleSound *sound, const ActionSoundBackend *backend);

/* record must be exactly 0x31 bytes: name[33], u16 channel at +0x21,
 * s16 loader flags +0x23, s16 loop mode +0x25, unused word +0x27,
 * u32 control +0x29 and independent s16 gain percentages +0x2d/+0x2f.
 *
 * Accepts loader flags1/2 and loop mode1. Original4fc62d overwrites loader
 * arg3 with1 at4fc722, so these actual Memory/D1 flags converge. Other loader
 * values and the descriptor loop flag at channel+0x16a remain unsupported.
 * The unused +0x27 word is ignored, as at 0x4fb77a. Names must terminate in
 * the 33-byte field and must be asset stems without slash or backslash.
 * Empty stems are passed to load_sound, which decides resource availability.
 *
 * prepare calls load_sound only; playback is a separate original boundary.
 * NO_RESOURCE leaves the channel unprepared and suppresses later play calls.
 * Any backend load failure also invalidates previous playback eligibility.
 * Invalid/unsupported descriptors cause no callback or state change. */
int puzzle_sound_prepare(PuzzleSound *sound, const uint8_t *record, size_t length);

/* 0x4fba69 forwards the descriptor's channel to the unload boundary. This
 * bounded API validates the full descriptor before that effect. Even an
 * unprepared channel is forwarded. An attempted unload invalidates playback
 * eligibility, including when the backend reports a failure. */
int puzzle_sound_stop(PuzzleSound *sound, const uint8_t *record, size_t length);

/* Unprepared channels return NO_RESOURCE without calling play_sound. */
int puzzle_sound_play(PuzzleSound *sound, uint16_t channel);

/* Returns the original 0x4f6334 sense (0 idle, 1 playing). An unprepared
 * channel is idle without a backend call. Errors leave still_playing intact. */
int puzzle_sound_busy(PuzzleSound *sound, uint16_t channel, int *still_playing);

#ifdef __cplusplus
}
#endif
#endif
