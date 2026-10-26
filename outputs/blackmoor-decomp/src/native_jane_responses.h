#ifndef BLACKMOOR_NATIVE_JANE_RESPONSES_H
#define BLACKMOOR_NATIVE_JANE_RESPONSES_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define NATIVE_JANE_MAX_ENTRIES 23u
#define NATIVE_JANE_EVENT_COUNT 2070u
#define NATIVE_JANE_PRESENCE_COUNT 22u
#define NATIVE_JANE_HOOK 1u
#define NATIVE_JANE_NO_HOOK 20u

typedef enum {
    NATIVE_JANE_OK = 0,
    NATIVE_JANE_ERR_ARGUMENT = 1,
    NATIVE_JANE_ERR_BOUNDS = 2,
    NATIVE_JANE_ERR_UNSUPPORTED = 3
} NativeJaneResponseStatus;

typedef enum {
    NATIVE_JANE_ADD = 0,     /* 0x41fa11: guard capacity, deduplicate, append */
    NATIVE_JANE_REPLACE = 1  /* 0x41fd08: remove first equal text, then append */
} NativeJaneResponseKind;

typedef struct {
    const int32_t *events;    /* original dwords at 0x585801 + 4*i */
    size_t event_count;
    const int32_t *presence;  /* original dwords at 0x583bd5 + 4*i */
    size_t presence_count;
} NativeJaneResponseWorld;

typedef struct {
    /* Borrowed immutable identifier, valid for the process lifetime. It is
     * both the CONVO lookup key and sound name, never the resolved display text. */
    const char *key;
    int16_t scene;
    uint8_t kind; /* NativeJaneResponseKind */
} NativeJaneResponseEntry;

typedef struct {
    NativeJaneResponseEntry entries[NATIVE_JANE_MAX_ENTRIES];
    size_t count;
} NativeJaneResponsePlan;

/* Pure plan for object+0x779 (hook_a) then object+0x77a (hook_b). Only index 1
 * and the original sentinel 20 are supported. The caller processes primary
 * entries first, then applies this plan in order through the original list
 * operations, resolving/copying each 400-byte text and its fixed metadata.
 * This module does not deduplicate by key, apply a list capacity limit, own
 * response text, mutate gameplay state, call a provider, or draw randomness.
 *
 * Hook A requires world and both arrays, with at least the counts above.
 * Otherwise world may be NULL. Hook B requires crt_return in 0..32767 from
 * one draw of the shared original CRT stream; when B is absent this value is
 * ignored. A preview caller must obtain that draw from a cloned stream.
 *
 * plan is required. Every failure leaves *plan unchanged. All counts are
 * validated before any array access. A successful plan contains at most 22
 * additions followed by one replacement; the caller owns the plan value. */
int native_jane_responses_plan(const NativeJaneResponseWorld *world,
    uint8_t hook_a, uint8_t hook_b, int32_t crt_return,
    NativeJaneResponsePlan *plan);

#ifdef __cplusplus
}
#endif
#endif
