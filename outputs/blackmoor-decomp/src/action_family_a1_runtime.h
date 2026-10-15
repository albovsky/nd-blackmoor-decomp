#ifndef BLACKMOOR_ACTION_FAMILY_A1_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_A1_RUNTIME_H

/* RT-21: raw 0xa1 "Sound" runtime.
 *
 * Raw 0xa1 shares the loader arm 0x40f069 and the dispatcher arm 0x4297be (then
 * 0x432d1a(row, 1, 0)) with raw 0x9f, but the loader keeps runtime type 0xa1 and builds
 * its object (0x410f99) from a longer body: the event word body+0x2e -> object +0xa5 and
 * the value byte body+0x30 -> object +0xa7 are real fields, where the raw-0x9f object has
 * the constructor defaults (-1, 0). The lifecycle is the shared sound visit
 * (action_family_97_runtime.h: action_sound_object_step); this module builds the object
 * once per scene from the A-A1.1 constructor and resolves its AUTOTEXT the way the loader
 * does (0x40f0f9 -> 0x423259; a missing key is replaced by the original
 * "Game Error ... missing auto text: <key><n>" string, 0x5408dc). */

#include "action_family_97.h"
#include "action_family_a1.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    ACTION_A1_RT_OK = 0,
    ACTION_A1_RT_ERR_ARGUMENT = 1,
    ACTION_A1_RT_ERR_BODY = 2,
    /* The key form needs the AUTOTEXT provider and it is absent or failed. The row is not
     * built and no alternate text is invented. */
    ACTION_A1_RT_ERR_LOOKUP = 3,
    ACTION_A1_RT_ERR_TEXT = 4
} ActionA1RuntimeStatus;

typedef struct ActionA1Object {
    /* Exact initialized allocation image of 0x40f282 (allocation_bytes of
     * action_family_a1_construct); the rest of the array is zero. */
    uint8_t bytes[ACTION_FAMILY_A1_MAX_OBJECT_BYTES];
    size_t length;
    /* 1 when the key was absent from the table and the original fallback text was used. */
    uint8_t key_missing;
} ActionA1Object;

/* typed_body is SceneActionInfo.typed_body of a raw 0xa1 row (84 bytes in key form,
 * 51 + n inline; dependency records excluded). lookup resolves a key to its visible text
 * (case-insensitive, without NUL) with the ActionFamily97 status values. On any failure
 * *out is left unchanged. */
int action_a1_runtime_construct(const uint8_t *typed_body, size_t typed_body_length,
                                ActionFamily97AutoTextLookup lookup, void *lookup_context,
                                ActionA1Object *out);

#ifdef __cplusplus
}
#endif
#endif
