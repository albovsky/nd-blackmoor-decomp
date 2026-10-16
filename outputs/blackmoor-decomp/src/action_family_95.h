#ifndef BLACKMOOR_ACTION_FAMILY_95_H
#define BLACKMOOR_ACTION_FAMILY_95_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Raw action 0x95, "Set Volume" (RT-26).
 *
 * Loader (case 0x95 of 0x40b34a): allocates 3 bytes, copies a 16-bit word and
 * one byte from the row's body, advances the source by 3. Dispatcher arm
 * 0x429e41 of 0x427a50, after the dependency gate 0x423f57(deps, 0) is true:
 *
 *   scalar = (float)((double)byte / 100.0)          (double divide, float store)
 *   0x4fca60(ECX = CSound 0x5c3a67, channel = (int16)word, scalar, scalar)
 *   0x42ba3a(row)                                   (completion / reset / phase 0)
 *
 * 0x4fca60 is sound_control_set_scalars (S04): both scalars into the channel
 * slot, attenuations from the channel's category master, DirectSound
 * SetVolume with the first attenuation. The row's completion is the generic
 * 0x42ba3a, so the executor re-derives it from the subtype and the phase
 * returns to 0. A volume byte above 100 is accepted by the original (scalar up
 * to 2.55); the attenuation clamp 0x4f684a then pins it at 0.
 *
 * The channel is a signed 16-bit index into 32 slots; the original indexes the
 * slot array unchecked, so a channel outside 0..31 is refused here before any
 * effect (no corpus row has one: the 123 rows use channels 0, 4, 5, 6, 7, 11
 * and 12). */

#define ACTION_FAMILY_95_RAW_TYPE UINT8_C(0x95)
#define ACTION_FAMILY_95_BODY_BYTES 3u
#define ACTION_FAMILY_95_CHANNEL_COUNT 32u

typedef enum {
    ACTION_FAMILY_95_OK = 0,
    ACTION_FAMILY_95_ERR_ARGUMENT = 1,
    ACTION_FAMILY_95_ERR_BODY = 2,
    /* Channel outside the 32 recovered slots; nothing was changed. */
    ACTION_FAMILY_95_ERR_BOUNDS = 3,
    /* The host has no volume provider; nothing was changed. */
    ACTION_FAMILY_95_ERR_UNSUPPORTED = 4,
    /* The host provider failed. */
    ACTION_FAMILY_95_ERR_HOST = 5
} ActionFamily95Status;

typedef struct {
    int16_t channel;        /* word at body+0 (movsx in 0x4fca60) */
    uint8_t volume_percent; /* byte at body+2, divided by 100.0 */
    float scalar;           /* stored as both the first and the second scalar */
} ActionFamily95Decoded;

typedef struct {
    void *context;
    /* 0x4fca60 + 0x4f684a for one channel. Returns 0 when the volume was
     * stored (including the original's recorded-but-harmless device-not-ready,
     * missing-buffer and SetVolume-failure states), nonzero on a host failure. */
    int (*set_channel_scalars)(void *context, uint16_t channel,
                               float first_scalar, float second_scalar);
} ActionFamily95Host;

/* Reads the fixed 3-byte typed body (the dependency tail is not part of it).
 * Rejects a null argument or a short body before any read. */
ActionFamily95Status action_family_95_decode(const uint8_t *body, size_t length,
                                             ActionFamily95Decoded *out);

/* One true-gate visit of the dispatcher arm up to 0x42ba3a (which the executor
 * performs). Validates before the host call: channel in 0..31. */
ActionFamily95Status action_family_95_visit(const ActionFamily95Decoded *decoded,
                                            const ActionFamily95Host *host);

#ifdef __cplusplus
}
#endif
#endif
