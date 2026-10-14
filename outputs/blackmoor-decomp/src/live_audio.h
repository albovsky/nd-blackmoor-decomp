#ifndef BLACKMOOR_LIVE_AUDIO_H
#define BLACKMOOR_LIVE_AUDIO_H

/* RT-1: live audio channel provider.
 *
 * This is a native platform/codec adapter. It implements the load_sound,
 * play_sound, is_playing and unload_sound callbacks of ActionSoundBackend
 * (action_sound.h) on top of the reviewed host pieces: his_audio_decode_file
 * (HIS v2 to interleaved float PCM through FFmpeg) and the mac_audio_*
 * AVAudioEngine host. It is NOT a reconstruction of the original CSound /
 * CDirectSound stream protocol (slice S04-2.2 stays paused) and it claims no
 * original decoder, mixing, attenuation or timing parity. Everything that the
 * original decides from state this adapter does not model (DirectSound flags
 * derived from raw channel flags, the dB attenuation curve, looping, the
 * meaning of control_word) is reported as unverified rather than guessed.
 *
 * Threading: every function in this header runs on the main thread (the
 * mac_audio host requires it); calls from another thread are rejected.
 *
 * Ownership: the provider opens the audio host itself (LiveAudioConfig names
 * the mode) and closes it in live_audio_destroy. A caller-supplied host
 * handle is deliberately not supported. The provider owns one decoded PCM
 * buffer per loaded channel and frees it on reload, unload and destroy. */

#include <stddef.h>
#include <stdint.h>

#include "action_sound.h"
#include "macos_audio.h"
#include "sound_control.h"

#ifdef __cplusplus
extern "C" {
#endif

#define LIVE_AUDIO_CHANNEL_COUNT ACTION_SOUND_CHANNEL_COUNT
#define LIVE_AUDIO_CATEGORY_COUNT SOUND_CONTROL_CATEGORY_COUNT
/* The command's asset_stem field holds at most ACTION_SOUND_STEM_BYTES - 1
 * characters before its NUL (the 0x9f decoder rejects an unterminated field).
 * A longer stem cannot come from the kernel and is rejected as malformed. */
#define LIVE_AUDIO_MAX_STEM_CHARS (ACTION_SOUND_STEM_BYTES - 1u)
#define LIVE_AUDIO_SOUND_DIRECTORY "CDSound"
#define LIVE_AUDIO_DEFAULT_OFFLINE_SAMPLE_RATE 48000u
#define LIVE_AUDIO_DEFAULT_OFFLINE_CHANNELS 2u
/* Offline advances are split into host renders of at most this many frames. */
#define LIVE_AUDIO_RENDER_CHUNK_FRAMES 4096u

typedef enum live_audio_status {
    LIVE_AUDIO_OK = 0,
    LIVE_AUDIO_ERR_ARGUMENT = 1,
    LIVE_AUDIO_ERR_THREAD = 2,
    LIVE_AUDIO_ERR_MODE = 3,
    LIVE_AUDIO_ERR_HOST = 4,
    LIVE_AUDIO_ERR_MEMORY = 5
} LiveAudioStatus;

typedef enum live_audio_name_match {
    LIVE_AUDIO_MATCH_NONE = 0,
    LIVE_AUDIO_MATCH_ONE = 1,
    LIVE_AUDIO_MATCH_AMBIGUOUS = 2,
    /* Stem violates the length or path-form rules. */
    LIVE_AUDIO_MATCH_INVALID = 3
} LiveAudioNameMatch;

/* One complete diagnostic line, no trailing newline. The provider never
 * prints to stdout or stderr itself. */
typedef void (*LiveAudioLogFn)(void *context, const char *message);

/* The mac_audio_* entry points the provider calls, so tests can substitute
 * a host. live_audio_default_host_ops fills in the real adapter. */
typedef struct LiveAudioHostOps {
    int (*open)(MacAudioMode mode, uint32_t rate, uint32_t channels,
                MacAudioHost **host, char *error, size_t capacity);
    int (*close)(MacAudioHost *host, char *error, size_t capacity);
    int (*play)(MacAudioHost *host, uint32_t slot_id, const float *pcm,
                uint64_t frame_count, uint32_t channels, uint32_t sample_rate,
                float gain, int loop, char *error, size_t capacity);
    int (*stop)(MacAudioHost *host, uint32_t slot_id, char *error,
                size_t capacity);
    int (*set_gain)(MacAudioHost *host, uint32_t slot_id, float gain,
                    char *error, size_t capacity);
    int (*is_playing)(MacAudioHost *host, uint32_t slot_id, int *playing,
                      char *error, size_t capacity);
    int (*render_offline)(MacAudioHost *host, uint32_t frame_count,
                          MacAudioRender *render, char *error,
                          size_t capacity);
    void (*render_destroy)(MacAudioRender *render);
} LiveAudioHostOps;

typedef struct LiveAudioConfig {
    /* Directory that contains the CDSound directory. Copied. */
    const char *game_directory;
    MacAudioMode mode;
    /* Offline mode only. 0 selects the defaults above. */
    uint32_t offline_sample_rate;
    uint32_t offline_channels;
    LiveAudioLogFn log;
    void *log_context;
    /* NULL selects the real mac_audio host. Copied. */
    const LiveAudioHostOps *host_ops;
} LiveAudioConfig;

typedef struct LiveAudio LiveAudio;

typedef struct LiveAudioOfflineStats {
    uint64_t frames;            /* frames rendered by this call */
    uint64_t nonfinite_samples;
    uint64_t nonzero_samples;
    double peak;                /* max |sample| over finite samples */
    double sum_squares;
} LiveAudioOfflineStats;

typedef struct LiveAudioChannelInfo {
    uint8_t loaded;
    uint8_t started;            /* play_sound succeeded for this generation */
    uint8_t finished;           /* host reported natural completion */
    uint8_t volume_category;
    uint64_t generation;        /* bumped by every load, unload and stop */
    uint32_t host_slot;
    uint32_t control_word;      /* retained raw, never interpreted */
    uint8_t mode;               /* retained raw; looping is not implemented */
    int16_t first_percent;
    int16_t second_percent;
    float first_gain;
    float second_gain;
    float category_scalar;
    float final_gain;           /* first * second * category_scalar */
    uint32_t sample_rate;
    uint32_t channels;
    uint64_t frame_count;
    /* Informational only, never used for output: the recovered S04-1 curve
     * (sound_control_calculate_attenuation, x87 CW 0x027f) applied to
     * first_gain * category_scalar, in the original's hundredths of a dB.
     * The original hands only the first attenuation to SetVolume; this
     * adapter's product gain is the packet's contract, not original parity. */
    int32_t reference_first_attenuation;
    uint8_t reference_first_attenuation_valid;
} LiveAudioChannelInfo;

void live_audio_default_host_ops(LiveAudioHostOps *ops);

/* Case-insensitive (ASCII) selection of `stem` + ".his" among `names`.
 * Exposed so the ambiguity rule is testable on filesystems that cannot hold
 * two names differing only in case. An empty stem is NONE. A stem longer than
 * LIVE_AUDIO_MAX_STEM_CHARS or containing '/' or '\\' is INVALID. */
LiveAudioNameMatch live_audio_match_asset_name(const char *stem,
                                               const char *const *names,
                                               size_t name_count,
                                               size_t *match_index);

int live_audio_create(const LiveAudioConfig *config, LiveAudio **audio,
                      char *error, size_t error_capacity);
/* Stops every channel, frees every buffer and closes the host created by
 * live_audio_create. NULL is accepted. Returns the host close status. */
int live_audio_destroy(LiveAudio *audio);

/* Fills the four sound callbacks and the context of `backend`; the caption
 * callbacks are untouched so the integrator keeps its own. The context is
 * the LiveAudio, so the integrator must hand it the matching context. */
int live_audio_bind_backend(LiveAudio *audio, ActionSoundBackend *backend);

/* The callbacks themselves (context is the LiveAudio). load_sound returns
 * NO_RESOURCE for a missing asset, ERROR for ambiguous/invalid/undecodable
 * input or a host failure, OK otherwise; any load first replaces whatever the
 * channel held. play_sound is an ERROR for an unloaded channel. is_playing is
 * non-blocking and OK/0 for an unloaded or finished channel. unload_sound is
 * idempotent. */
ActionSoundBackendStatus live_audio_load_sound(
    void *context, const ActionSoundAudioCommand *command);
ActionSoundBackendStatus live_audio_play_sound(void *context,
                                               uint16_t channel);
ActionSoundBackendStatus live_audio_is_playing(void *context, uint16_t channel,
                                               int *still_playing);
ActionSoundBackendStatus live_audio_unload_sound(void *context,
                                                 uint16_t channel);

/* Unloads every loaded channel (scene clear). The original's treatment of
 * sounds that span scene changes is unverified; callers state that choice. */
int live_audio_unload_all(LiveAudio *audio);

/* RT-9 minimal PCM entry to the SAME mixer: Bink's independent soundtrack
 * bus does not consume/replace a recovered scene sound channel. Host slot
 * identities are adapter details, not original channel numbers. Unity gain,
 * no pan, no loop; original Bink SDK mixing is unverified. PCM is borrowed
 * until stop/destroy; the host copies it on play. Main thread only. */
int live_audio_movie_start(LiveAudio *, const float *pcm, uint64_t frames,
                          uint32_t channels, uint32_t sample_rate);
int live_audio_movie_stop(LiveAudio *);

/* Stops a channel's playback but keeps it loaded (a following play restarts
 * from the beginning). Bumps the generation. */
int live_audio_stop_channel(LiveAudio *audio, uint16_t channel);

/* Volume-category scalar table, default 1.0 for all four. Scalars must be
 * finite and within [0, 1]. Loaded channels in the category are re-gained,
 * and the host is updated for a channel that is playing. */
int live_audio_set_category_scalar(LiveAudio *audio, uint8_t category,
                                   float scalar);
int live_audio_get_category_scalar(const LiveAudio *audio, uint8_t category,
                                   float *scalar);

int live_audio_get_channel_info(const LiveAudio *audio, uint16_t channel,
                                LiveAudioChannelInfo *info);

/* Offline mode only: renders exactly `frames` frames into the host's
 * manual-render graph. `stats` and `capture` are optional; capture receives
 * up to capture_capacity_frames interleaved frames of the render format.
 * Completion callbacks arrive asynchronously after a render, so observe them
 * by polling is_playing across ticks; nothing here waits for them. */
int live_audio_advance_offline(LiveAudio *audio, uint64_t frames,
                               LiveAudioOfflineStats *stats, float *capture,
                               uint64_t capture_capacity_frames);
int live_audio_offline_format(const LiveAudio *audio, uint32_t *sample_rate,
                              uint32_t *channels);
uint64_t live_audio_offline_frames_rendered(const LiveAudio *audio);

const char *live_audio_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
