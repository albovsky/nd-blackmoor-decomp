#ifndef BLACKMOOR_SOUND_CONTROL_H
#define BLACKMOOR_SOUND_CONTROL_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SOUND_CONTROL_CHANNEL_COUNT 32u
#define SOUND_CONTROL_CATEGORY_COUNT 4u
#define SOUND_CONTROL_MIN_ATTENUATION (-2857)

typedef enum sound_control_status {
    SOUND_CONTROL_OK = 0,
    SOUND_CONTROL_ERR_ARGUMENT = 1,
    SOUND_CONTROL_ERR_UNSUPPORTED = 2
} SoundControlStatus;

typedef enum sound_control_host_status {
    SOUND_CONTROL_HOST_OK = 0,
    SOUND_CONTROL_HOST_ERROR = 1,
    SOUND_CONTROL_HOST_UNSUPPORTED = 2
} SoundControlHostStatus;

typedef enum sound_control_update_kind {
    SOUND_CONTROL_UPDATE_NONE = 0,
    SOUND_CONTROL_UPDATE_RESTART = 1,
    SOUND_CONTROL_UPDATE_RANDOM_REPEAT = 2
} SoundControlUpdateKind;

/* Fields are per CDirectSound channel slot (the array addressed through
 * CDirectSound+0x3ce). They deliberately retain original names/roles. */
typedef struct sound_control_channel {
    uint16_t volume_category;       /* CSound+0x10c + channel*0x5bb */
    uint16_t volume_update_state;   /* slot+0x12e; setter acts only at == 1 */
    uint16_t raw_flags;             /* slot+0x12c; low 16 bits */
    uint16_t reserved;
    uint32_t raw_control;           /* slot+0x130; kept unnormalized */
    float first_scalar;             /* CSound+0x138; no left/right claim */
    float second_scalar;            /* CSound+0x13c; no left/right claim */
    int32_t first_attenuation;      /* slot+0x13c; original SetVolume input */
    int32_t second_attenuation;     /* slot+0x140; stored independently */
    uint32_t resource_ready;        /* slot+0x162 */
    uint32_t stream_state;          /* slot+0x166 */
    uint32_t update_gate_287;       /* slot+0x287 */
    uint32_t update_gate_16e;       /* slot+0x16e */
    uint32_t update_gate_172;       /* slot+0x172 */
    uint32_t buffer_available;      /* slot+0x28f */
    uint32_t repeat_marker;         /* slot+0x19e */
    int32_t repeat_min;             /* slot+0x1aa */
    int32_t repeat_max;             /* slot+0x1ae */
    uint32_t repeat_delay;          /* slot+0x1a2 */
    uint32_t repeat_due_tick;       /* slot+0x1a6 */
} SoundControlChannel;

typedef struct sound_control_state {
    SoundControlChannel channels[SOUND_CONTROL_CHANNEL_COUNT];
    float master[SOUND_CONTROL_CATEGORY_COUNT];
    uint32_t device_ready;          /* CDirectSound+0x1a0 */
    uint32_t device_state;          /* CDirectSound+0x3be */
    uint32_t device_error;          /* CDirectSound+0x3c2 */
    int32_t host_result;            /* CDirectSound+0x3ca */
} SoundControlState;

typedef struct sound_control_result {
    uint32_t original_error;
    uint32_t play_flags;
    uint32_t tick;
    uint32_t repeat_delay;
    uint32_t repeat_due_tick;
    uint32_t play_attempted;
    uint32_t played;
    SoundControlUpdateKind update_kind;
} SoundControlResult;

typedef struct sound_control_master_result {
    uint32_t updated_channels;
    uint32_t volume_calls;
    uint16_t failed_channel;
    uint16_t has_failed_channel;
    uint32_t original_error;
} SoundControlMasterResult;

typedef struct sound_control_host {
    void *context;
    /* HRESULT-like result is written exactly to CDirectSound+0x3ca. */
    SoundControlHostStatus (*play_buffer)(void *context, uint16_t channel,
                                          uint32_t flags, int32_t *host_result);
    SoundControlHostStatus (*set_first_attenuation)(
        void *context, uint16_t channel, int32_t attenuation,
        int32_t *host_result);
    /* Original GetTickCount and _rand call boundaries; rand values must be
     * the nonnegative signed values returned by the original CRT. */
    uint32_t (*tick_count)(void *context);
    uint32_t (*random_value)(void *context);
    /* Ordered calls at 0x4f9f92, 0x4f8f94, 0x4f9040; their bodies are outside
     * this kernel and remain explicit host boundaries. */
    void (*fade_stage_1)(void *context, uint16_t channel);
    void (*fade_stage_2)(void *context, uint16_t channel);
    void (*fade_stage_3)(void *context, uint16_t channel);
} SoundControlHost;

/* Recovered 0x4faa03 table only: initializes the independent four categories
 * for the 32 channel indices. Does not initialize unrelated channel state. */
int sound_control_initialize_categories(uint8_t categories[SOUND_CONTROL_CHANNEL_COUNT]);

/* The recovered x87 startup policy is precision=53, round-to-nearest. Raw
 * startup CW 0x023f and semantic CW 0x027f have the same supported fields. */
int sound_control_calculate_attenuation(float scalar, float master,
                                        uint16_t raw_x87_control_word,
                                        int32_t *attenuation);

/* Original 0x4f6059 command selector/wrapper. Nonzero host HRESULT maps to
 * original error 0x403; absence maps to 0x3ea; missing resource/buffer 0x3ef. */
int sound_control_play(SoundControlState *state, uint16_t channel,
                       SoundControlHost *host, SoundControlResult *result);

/* Original 0x4f55d5 channel update. Tick is always sampled first. Fade
 * internals are injectable in their original order. Raw control zero either
 * restarts through sound_control_play or schedules the original random delay. */
int sound_control_update(SoundControlState *state, uint16_t channel,
                         SoundControlHost *host, SoundControlResult *result);

/* Original 0x4fccf2 / 0x4fcb5c / 0x4f684a path. `percent` is the original
 * unsigned 16-bit input; active channels retain both attenuation scalars,
 * while the observed DirectSound boundary receives the first attenuation. */
int sound_control_set_master_absolute(SoundControlState *state,
                                      uint16_t category, uint16_t percent,
                                      uint16_t raw_x87_control_word,
                                      SoundControlHost *host,
                                      SoundControlMasterResult *result);

/* Original 0x4fca60 followed by 0x4f684a (raw action 0x95, "set volume").
 * Order as in the original: both scalars are stored, the first and then the
 * second attenuation are computed from the channel's category master
 * (scalar * master * 2857.142822265625 - 2857.142857142857, truncated), stored,
 * and the DirectSound volume setter runs (clamp, then SetVolume with the first
 * attenuation only; device-not-ready 0x3ea / missing buffer 0x3ef / HRESULT
 * failure 0x408 are recorded exactly as sound_control_set_master_absolute
 * does). Scalars are not limited to 1.0 (the byte/100 argument reaches 2.55);
 * they must be finite, nonnegative and at most 100. The channel's category
 * must be below SOUND_CONTROL_CATEGORY_COUNT (the original would index the
 * master table out of bounds); nothing is mutated on an argument error. */
int sound_control_set_scalars(SoundControlState *state, uint16_t channel,
                              float first_scalar, float second_scalar,
                              uint16_t raw_x87_control_word,
                              SoundControlHost *host,
                              SoundControlMasterResult *result);

#ifdef __cplusplus
}
#endif

#endif
