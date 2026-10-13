#ifndef BLACKMOOR_ACTION_SOUND_H
#define BLACKMOOR_ACTION_SOUND_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_SOUND_TYPE UINT8_C(0x9f)
#define ACTION_SOUND_CHANNEL_COUNT 32u
#define ACTION_SOUND_STEM_BYTES 33u
#define ACTION_SOUND_AUTO_TEXT_KEY_BYTES 33u
#define ACTION_SOUND_MAX_LITERAL_BYTES 9999u
#define ACTION_SOUND_EXTENSION ".his"
#define ACTION_SOUND_CAPTION_TERMINATOR "<e>"

typedef enum action_sound_status {
    ACTION_SOUND_OK = 0,
    ACTION_SOUND_ERR_ARGUMENT = 1,
    ACTION_SOUND_ERR_BODY = 2,
    ACTION_SOUND_ERR_UNSUPPORTED = 3,
    ACTION_SOUND_ERR_BACKEND = 4
} ActionSoundStatus;

/* The original loader distinguishes an ordinary file/load failure from an
 * unsupported host operation. A failed load advances the original action to
 * phase 1 but does not issue PlaySound; later playback query determines when
 * it may complete. */
typedef enum action_sound_backend_status {
    ACTION_SOUND_BACKEND_OK = 0,
    ACTION_SOUND_BACKEND_NO_RESOURCE = 1,
    ACTION_SOUND_BACKEND_UNSUPPORTED = 2,
    ACTION_SOUND_BACKEND_ERROR = 3
} ActionSoundBackendStatus;

typedef enum action_sound_caption_kind {
    ACTION_SOUND_CAPTION_LITERAL = 0,
    ACTION_SOUND_CAPTION_RESOLVED_AUTO_TEXT = 1
} ActionSoundCaptionKind;

typedef struct action_sound_caption_request {
    ActionSoundCaptionKind kind;
    /* Exact literal or resolved text bytes; length excludes the final NUL.
     * The original loader appends "<e>" before the caption UI boundary. */
    const uint8_t *bytes;
    size_t length;
    const char *terminator;
    size_t terminator_length;
} ActionSoundCaptionRequest;

typedef struct action_sound_audio_command {
    char asset_stem[ACTION_SOUND_STEM_BYTES + 1u];
    uint16_t channel;
    /* Initialized by original CSound::InitSoundSystem (0x4faa03): channel
     * category used to index the independent global-volume table. This is
     * distinct from the body's playback mode below. */
    uint8_t volume_category;
    /* Raw body+0x23 value copied to channel state +0x134. The DirectSound
     * flag selection also reads this word; retain it raw until its semantics
     * are mapped in the platform adapter. */
    uint32_t control_word;
    int16_t first_percent;
    int16_t second_percent;
    /* Each raw signed short is divided by 100 and independently clamped to
     * [0, 1], as the original handler does before the loader call. */
    float first_gain;
    float second_gain;
    uint8_t mode;
    int16_t transition_scene;
} ActionSoundAudioCommand;

typedef struct action_sound_action {
    uint8_t type;
    uint8_t subtype;
    uint8_t eligible;
    uint8_t completed_before;
    uint32_t phase_before;
    /* Original 0x432d1a argument 2 gates caption presentation. */
    uint8_t scene_dispatch_argument;
    /* Mirrors original global DAT_005bb202. */
    uint8_t captions_enabled;
    /* Original typed body only, excluding dependency records. */
    const uint8_t *body;
    size_t body_length;
} ActionSoundAction;

typedef struct action_sound_transition {
    int16_t target_scene;
    /* 0x9f's original loader zero-allocates these transition payload fields. */
    int16_t opaque_words[3];
    int32_t opaque_dwords[3];
    /* The handler sets engine state to 4 and DAT_005bb1ca to (+0xa8 != 1).
     * The 0x9f loader writes +0xa8 = 2, so flag_value is 1. */
    uint8_t scene_flag_value;
    uint8_t engine_state_value;
} ActionSoundTransition;

typedef struct action_sound_step_result {
    uint8_t recognized;
    uint8_t applied;
    uint8_t completion_valid;
    uint8_t completed;
    uint8_t reset_dependencies;
    uint8_t stop_later_actions;
    uint8_t has_transition;
    uint8_t reserved;
    uint32_t phase;
    ActionSoundTransition transition;
} ActionSoundStepResult;

typedef struct action_sound_backend {
    void *context;
    /* Resolves the NUL-terminated 33-byte field after FFFF. Returned bytes
     * are borrowed through the following present_caption call, and exclude
     * NUL. NO_RESOURCE means the original exact missing-caption fallback is
     * used by the kernel. */
    ActionSoundBackendStatus (*resolve_auto_text)(
        void *context, const uint8_t *key, size_t key_length,
        const uint8_t **text, size_t *text_length);
    ActionSoundBackendStatus (*present_caption)(
        void *context, const ActionSoundCaptionRequest *request);
    /* Performs the original path/config/load portion: stem + ".his", channel,
     * original volume category, raw control word, and two independent gains.
     * The final DirectSound attenuation also depends on the runtime global
     * volume table and is deliberately not collapsed into one body gain.
     * NO_RESOURCE models original load failure and suppresses PlaySound while
     * phase advances. */
    ActionSoundBackendStatus (*load_sound)(
        void *context, const ActionSoundAudioCommand *command);
    /* Called only after load_sound returns OK; maps to original 0x4fb2e3. */
    ActionSoundBackendStatus (*play_sound)(void *context, uint16_t channel);
    /* Returns the original 0x4f6334 sense: 1 means still playing. */
    ActionSoundBackendStatus (*is_playing)(
        void *context, uint16_t channel, int *still_playing);
    /* Maps to original 0x4fba69 / 0x4fc808 unload on mode 0 completion. */
    ActionSoundBackendStatus (*unload_sound)(void *context, uint16_t channel);
} ActionSoundBackend;

/* One stateless action transition. `phase_before` and `completed_before` are
 * owned and retained by the caller/executor; asynchronous playback state is
 * owned by the backend's channel object. No completion is synthesized from
 * elapsed time. A false dependency gate reproduces the dispatcher subtype-2
 * clear (completed and phase only; no dependency-tree reset). */
int action_sound_step(const ActionSoundAction *action,
                      ActionSoundBackend *backend,
                      ActionSoundStepResult *result);

const char *action_sound_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
