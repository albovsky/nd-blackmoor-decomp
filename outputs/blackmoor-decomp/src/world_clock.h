#ifndef BLACKMOOR_WORLD_CLOCK_H
#define BLACKMOOR_WORLD_CLOCK_H

#include "world_init.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define WORLD_CLOCK_TIME_RECORD_COUNT WORLD_INIT_TIME_RECORD_COUNT
#define WORLD_CLOCK_TIME_RECORD_SIZE WORLD_INIT_TIME_RECORD_SIZE
#define WORLD_CLOCK_TIME_RECORD_BYTES WORLD_INIT_TIME_RECORD_BYTES
#define WORLD_CLOCK_CAPTION_LIMIT 0x9c40u
#define WORLD_CLOCK_CONTINUE_NORMAL_POST_CLOCK UINT32_C(0x43b13d)
#define WORLD_CLOCK_CONTINUE_OFFMODE_CLEANUP UINT32_C(0x43ab41)

typedef enum world_clock_status {
    WORLD_CLOCK_OK = 0,
    WORLD_CLOCK_ERR_ARGUMENT = 1,
    WORLD_CLOCK_ERR_BOUNDS = 2,
    WORLD_CLOCK_ERR_FORMAT = 3,
    WORLD_CLOCK_ERR_UNSUPPORTED_OPCODE = 4,
    WORLD_CLOCK_ERR_HOST_UNAVAILABLE = 5,
    WORLD_CLOCK_ERR_CAPTION_UNAVAILABLE = 6,
    WORLD_CLOCK_ERR_CAPTION_RESULT = 7,
    /* The arithmetic prefix completed; caller-owned cleanup begins here. */
    WORLD_CLOCK_ERR_CONTINUATION_REQUIRED = 8
} WorldClockStatus;

typedef enum world_clock_trigger {
    WORLD_CLOCK_TRIGGER_NONE = 0,
    WORLD_CLOCK_TRIGGER_SESSION = 1,
    WORLD_CLOCK_TRIGGER_RECORD_VIEW = 2,
    WORLD_CLOCK_TRIGGER_EVENT_FLAG = 3,
    WORLD_CLOCK_TRIGGER_SOUND_DESCRIPTOR = 4,
    WORLD_CLOCK_TRIGGER_SOUND_CHANNEL_PLAY = 5,
    WORLD_CLOCK_TRIGGER_CAPTION_LOOKUP = 6,
    WORLD_CLOCK_TRIGGER_CAPTION_PRESENT = 7,
    WORLD_CLOCK_TRIGGER_OFFMODE_CLEANUP = 8,
    WORLD_CLOCK_TRIGGER_POST_CLOCK_CONTINUATION = 9
} WorldClockTrigger;

typedef enum world_clock_effect_kind {
    WORLD_CLOCK_EFFECT_LOAD_SOUND_DESCRIPTOR = 1,
    WORLD_CLOCK_EFFECT_PLAY_SOUND_CHANNEL = 2,
    WORLD_CLOCK_EFFECT_SHOW_CAPTION = 3
} WorldClockEffectKind;

typedef enum world_clock_host_status {
    WORLD_CLOCK_HOST_OK = 0,
    /* The original caller does not inspect these call results. */
    WORLD_CLOCK_HOST_RETURNED_FAILURE_IGNORED = 1,
    /* Native port cannot provide this source-backed call boundary. */
    WORLD_CLOCK_HOST_UNAVAILABLE = 2
} WorldClockHostStatus;

typedef enum world_clock_caption_status {
    WORLD_CLOCK_CAPTION_FOUND = 0,
    WORLD_CLOCK_CAPTION_NOT_FOUND = 1,
    WORLD_CLOCK_CAPTION_UNAVAILABLE = 2
} WorldClockCaptionStatus;

typedef enum world_clock_caption_source {
    WORLD_CLOCK_CAPTION_FROM_RESOLVER = 1,
    WORLD_CLOCK_CAPTION_FROM_FALLBACK = 2
} WorldClockCaptionSource;

/* Distinct original globals not already represented by WorldInitState.
 * Clock elapsed values, civil clock, timer records, and event flags remain
 * borrowed from the existing state; they are not copied into this structure. */
typedef struct world_clock_session {
    WorldInitState *world;
    int16_t outside_window_flag_5bb20a;
    int16_t time_window_start_5b0284;
    int16_t time_window_end_5b0286;
    uint8_t captions_enabled_5bb202;
    uint8_t reserved[3];
} WorldClockSession;

typedef struct world_clock_effect {
    uint32_t kind;
    uint32_t record_index;
    uint32_t caption_source;
    uint16_t sound_channel;
    uint16_t reserved;
    /* Exact original 49-byte object passed to the sound descriptor loader. */
    uint8_t sound_descriptor[49];
    /* Borrowed only for the synchronous callback; copy it to retain it. */
    const char *text;
    size_t text_length;
} WorldClockEffect;

typedef WorldClockHostStatus (*WorldClockEmitFn)(
    void *context, const WorldClockEffect *effect);

/* Return FOUND with a borrowed text pointer, NOT_FOUND to take the record's
 * original fallback field, or UNAVAILABLE when this port boundary is absent.
 * The returned bytes need remain valid only until the next sink call. */
typedef WorldClockCaptionStatus (*WorldClockResolveCaptionFn)(
    void *context, const char *key, size_t key_length,
    const char **resolved_text, size_t *resolved_length);

typedef struct world_clock_effect_sink {
    void *context;
    WorldClockEmitFn emit;
    WorldClockResolveCaptionFn resolve_caption;
} WorldClockEffectSink;

typedef struct world_clock_result {
    int32_t status;
    int32_t trigger;
    uint32_t continuation_va;
    uint32_t delta_ms;
    uint16_t record_index;
    uint16_t pair_index;
    int32_t event_flag_id;
    uint32_t effects_attempted;
    uint32_t ignored_host_failures;
    uint8_t partial_state_committed;
    uint8_t reserved[3];
} WorldClockResult;

/* Apply the source-backed normal-path frame clock block using the tick already
 * sampled at 0x43a7ca. Mutations are written directly to the bounded borrowed
 * WorldInitState in original order. On error, result identifies the exact
 * trigger and already-committed prefix; this routine does not roll back.
 *
 * At success, continuation_va is 0x43b13d: the Boot/session owner must still
 * execute the post-clock controller callback path before scanning actions.
 */
int world_clock_update_normal(WorldClockSession *session,
                              uint32_t sampled_tick,
                              WorldClockEffectSink *sink,
                              WorldClockResult *result);

/* Apply the off-mode pause subtraction prefix after the caller's state/event
 * gates select it. The original then calls UI/audio cleanup helpers at
 * 0x43ab41; this isolated kernel stops there and returns
 * WORLD_CLOCK_ERR_CONTINUATION_REQUIRED with that exact continuation VA. */
int world_clock_update_offmode(WorldClockSession *session,
                               uint32_t sampled_tick,
                               int restoring,
                               WorldClockResult *result);

/* Live providers for scene dependency leaves. Opcode 3 stays explicitly
 * unsupported because its original indexed table has no proven extent or
 * producer. Output is unchanged on unsupported/error. */
int world_clock_condition_read(const WorldInitState *state,
                               uint16_t opcode,
                               int32_t *value_out);

const char *world_clock_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
