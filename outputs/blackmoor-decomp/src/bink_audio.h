#ifndef BINK_AUDIO_H
#define BINK_AUDIO_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum bink_audio_status {
    BINK_AUDIO_OK = 0,
    BINK_AUDIO_NO_SOUNDTRACK = 1,
    BINK_AUDIO_ERR_ARGUMENT = -1,
    BINK_AUDIO_ERR_FILE = -2,
    BINK_AUDIO_ERR_FORMAT = -3,
    BINK_AUDIO_ERR_DECODE = -4,
    BINK_AUDIO_ERR_MEMORY = -5,
    BINK_AUDIO_ERR_BOUNDS = -6,
    BINK_AUDIO_ERR_UNSUPPORTED = -7
} bink_audio_status;

typedef struct BinkAudio {
    float *pcm;
    uint64_t frame_count;
    uint32_t sample_rate;
    uint32_t channels;
} BinkAudio;

#define BINK_AUDIO_INIT { NULL, 0u, 0u, 0u }

/* Native FFmpeg host adapter, not a reconstruction of the original Bink SDK.
 * Decode the sole embedded Bink soundtrack to owned, interleaved float PCM,
 * without trimming, gain changes, resampling, or channel mixing. Only mono or
 * stereo at 1..192000 Hz is supported; multiple tracks are explicitly rejected.
 * The input and the retained PCM allocation each have a 256 MiB limit. FFmpeg's
 * own bounded packet/decoder allocations are additional to the PCM allocation.
 * This function never opens an output device.
 *
 * Initialize audio with BINK_AUDIO_INIT and destroy it before reuse. A nonempty
 * output is rejected without changing its ownership. Other errors and the
 * no-soundtrack result leave an empty output. A valid silent Bink returns 1;
 * decoded audio returns 0; failures return negative bink_audio_status values.
 * error may be NULL; a nonempty error buffer is always NUL-terminated. */
int bink_audio_decode_file(const char *path, BinkAudio *audio,
                           char *error, size_t error_capacity);
void bink_audio_destroy(BinkAudio *audio);

#ifdef __cplusplus
}
#endif

#endif
