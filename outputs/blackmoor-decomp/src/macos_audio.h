#ifndef MACOS_AUDIO_H
#define MACOS_AUDIO_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum mac_audio_status {
    MAC_AUDIO_OK = 0,
    MAC_AUDIO_ERR_ARGUMENT = 1,
    MAC_AUDIO_ERR_THREAD = 2,
    MAC_AUDIO_ERR_ENGINE = 3,
    MAC_AUDIO_ERR_FORMAT = 4,
    MAC_AUDIO_ERR_MEMORY = 5,
    MAC_AUDIO_ERR_MODE = 6,
    MAC_AUDIO_ERR_CLOSED = 7,
    MAC_AUDIO_ERR_STALE = 8
} MacAudioStatus;

typedef enum mac_audio_mode {
    MAC_AUDIO_MODE_OUTPUT = 0,
    MAC_AUDIO_MODE_OFFLINE = 1
} MacAudioMode;

typedef struct MacAudioHost MacAudioHost;

/* Independent cursor API; existing public layouts are unchanged. */
typedef struct MacAudioPlaybackCursor {
    uint64_t generation;
    uint64_t source_frames;
    uint64_t source_frame_count;
    uint32_t sample_rate;
    uint32_t channels;
    uint8_t started;
    uint8_t playing;
    uint8_t position_valid;
} MacAudioPlaybackCursor;

/* expected_generation=0 queries the current slot; a nonzero stale generation
 * refuses without changing cursor. All refusals leave cursor unchanged.
 * Frames count accepted offline renders since play at the source rate, or
 * AVAudioPlayerNode's native player timeline in output mode. No wall clock.
 * Position clamps to source_frame_count, including loops; playing retains the
 * existing DataRendered / DataPlayedBack lifetime. Stop/replay changes the
 * generation and resets position to zero. An output timeline not yet available
 * has position_valid=0; this must not be treated as successful progress. */
int mac_audio_get_playback_cursor(MacAudioHost *host, uint32_t slot_id,
                                  uint64_t expected_generation,
                                  MacAudioPlaybackCursor *cursor,
                                  char *error, size_t error_capacity);

typedef struct MacAudioRender {
    uint32_t sample_rate;
    uint32_t channels;
    uint64_t frame_count;
    float *interleaved_pcm;
} MacAudioRender;

#define MAC_AUDIO_RENDER_INIT { 0u, 0u, 0u, NULL }

/* All host calls except internal completion handling must run on the main
 * thread. Output mode starts the engine on the first play and clears natural
 * completion after AVAudioPlayerNode reports DataPlayedBack. Offline mode
 * takes an explicit render rate/channel count, opens no output device, and
 * observes completion at DataRendered. Successful close consumes the handle;
 * callers must not use it afterward. */
int mac_audio_host_open(MacAudioMode mode,
                        uint32_t offline_sample_rate,
                        uint32_t offline_channels,
                        MacAudioHost **host,
                        char *error,
                        size_t error_capacity);
int mac_audio_host_close(MacAudioHost *host,
                         char *error,
                         size_t error_capacity);
int mac_audio_play(MacAudioHost *host,
                   uint32_t slot_id,
                   const float *interleaved_pcm,
                   uint64_t frame_count,
                   uint32_t channels,
                   uint32_t sample_rate,
                   float gain,
                   int loop,
                   char *error,
                   size_t error_capacity);
int mac_audio_stop(MacAudioHost *host,
                   uint32_t slot_id,
                   char *error,
                   size_t error_capacity);
int mac_audio_set_gain(MacAudioHost *host,
                       uint32_t slot_id,
                       float gain,
                       char *error,
                       size_t error_capacity);
int mac_audio_is_playing(MacAudioHost *host,
                         uint32_t slot_id,
                         int *is_playing,
                         char *error,
                         size_t error_capacity);

/* Manual-render inspection is available only in OFFLINE mode and accepts
 * 1..65536 frames per call. A successful render owns interleaved float PCM
 * until mac_audio_render_destroy is called. */
int mac_audio_host_render_offline(MacAudioHost *host,
                                  uint32_t frame_count,
                                  MacAudioRender *render,
                                  char *error,
                                  size_t error_capacity);
void mac_audio_render_destroy(MacAudioRender *render);
const char *mac_audio_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
