#ifndef BLACKMOOR_ACTION_FAMILY_97_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_97_RUNTIME_H

#include "action_family_97.h"
#include "action_sound.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct A97Input {
    uint32_t phase;
    uint8_t subtype;
    uint8_t completed;
    uint8_t captions;
} A97Input;

typedef struct A97Result {
    uint32_t phase;
    uint8_t completed;
    uint8_t direct;
    uint8_t finish;
    uint8_t reset;
    uint8_t transition;
    ActionSoundTransition request;
} A97Result;

/* One visit of 0x432d1a(row,1,0), reached by the runtime-0x9f arm of
 * 0x427a50. Input is the owned, once-constructed 0x40f532/0x410f99 allocation,
 * NOT a raw 0x97 body. It is read-only: selection never repeats at runtime.
 * Only event=-1 is accepted. Full constructor-default channel-state parity
 * remains UNVERIFIED: 0x432d1a copies word +0x25 and about 22 fields from
 * +0x2f..+0x8c into channel state; ActionSoundAudioCommand does not carry them
 * and the RT-8 oracle does not compare them. The sound manager at
 * 0x4f5651..0x4f56d8 reads chan+0x1aa/+0x1ae and calls rand; those effects
 * and their RNG consumption are also unverified.
 * Caption text already contains <e>; the backend receives an empty suffix.
 * Status values are ACTION_SOUND_*. Missing callbacks are checked before any
 * effect on that visit. Host errors can follow earlier committed effects.
 * Dependencies/false-gate subtype-2 clearing remain with the executor.
 * No clock or event store occurs for these constructor defaults. */
int action97_runtime_step(const uint8_t *payload, size_t payload_length,
                          const A97Input *, ActionSoundBackend *, A97Result *,
                          const char **failure);

#ifdef __cplusplus
}
#endif
#endif
