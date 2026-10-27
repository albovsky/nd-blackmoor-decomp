#ifndef BLACKMOOR_NATIVE_PETROV_RESPONSES_H
#define BLACKMOOR_NATIVE_PETROV_RESPONSES_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define NATIVE_PETROV_MAX_ENTRIES 7u
#define NATIVE_PETROV_EVENT_COUNT 2015u
#define NATIVE_PETROV_HOOK 6u
#define NATIVE_PETROV_NO_HOOK 20u

typedef enum {
    NATIVE_PETROV_OK = 0,
    NATIVE_PETROV_ERR_ARGUMENT = 1,
    NATIVE_PETROV_ERR_BOUNDS = 2,
    NATIVE_PETROV_ERR_UNSUPPORTED = 3
} NativePetrovResponseStatus;

typedef enum {
    NATIVE_PETROV_ADD = 0,     /* 0x41fa11: guard capacity, deduplicate, append */
    NATIVE_PETROV_REPLACE = 1  /* 0x41fd08: remove first equal text, then append */
} NativePetrovResponseKind;

typedef struct {
    const int32_t *events; /* original dwords at 0x585801 + 4*i */
    size_t event_count;
} NativePetrovResponseWorld;

typedef struct {
    /* Borrowed immutable identifier, valid for the process lifetime. It is
     * both the CONVO lookup key and sound name, never resolved display text. */
    const char *key;
    int16_t scene;
    uint8_t kind; /* NativePetrovResponseKind */
} NativePetrovResponseEntry;

typedef struct {
    NativePetrovResponseEntry entries[NATIVE_PETROV_MAX_ENTRIES];
    size_t count;
} NativePetrovResponsePlan;

/* Pure plan for object+0x779 (hook_a) then object+0x77a (hook_b). Only index 6
 * and the original sentinel 20 are supported. The caller processes primary
 * entries first, then applies this plan in order through the original list
 * operations, resolving/copying each 400-byte text and its fixed metadata.
 * This module does not deduplicate by key, apply a list capacity limit, own
 * response text, mutate gameplay state, call a provider, or draw randomness.
 *
 * Hook A requires world and events, with at least the count above. Otherwise
 * world may be NULL. Hook B requires crt_return in 0..32767 from one draw of
 * the shared original CRT stream; when B is absent this value is ignored.
 * A preview caller must obtain that draw from a cloned stream.
 *
 * plan is required. Every failure leaves *plan unchanged. All counts are
 * validated before any array access. A successful plan contains at most six
 * additions followed by one replacement; the caller owns the plan value.
 * The original negative injected-rand default has uninitialized fields and
 * is outside this genuine-CRT contract. */
int native_petrov_responses_plan(const NativePetrovResponseWorld *world,
    uint8_t hook_a, uint8_t hook_b, int32_t crt_return,
    NativePetrovResponsePlan *plan);

#ifdef __cplusplus
}
#endif
#endif
