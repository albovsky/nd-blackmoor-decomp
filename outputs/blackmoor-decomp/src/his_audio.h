#ifndef HIS_AUDIO_H
#define HIS_AUDIO_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum his_audio_status {
    HIS_AUDIO_OK = 0,
    HIS_AUDIO_ERR_ARGUMENT = 1,
    HIS_AUDIO_ERR_FILE = 2,
    HIS_AUDIO_ERR_FORMAT = 3,
    HIS_AUDIO_ERR_DECODE = 4,
    HIS_AUDIO_ERR_MEMORY = 5,
    HIS_AUDIO_ERR_BOUNDS = 6
} his_audio_status;

/* Interleaved float PCM owned by the adapter after a successful decode. */
typedef struct HisAudio {
    uint32_t sample_rate;
    uint32_t channels;
    uint64_t frame_count;
    float *interleaved_pcm;
} HisAudio;

/* Start with this zeroed value; destroy a prior output before reusing it. */
#define HIS_AUDIO_INIT { 0u, 0u, 0u, NULL }

/* Decode a local HIS v2 file or its in-memory bytes. The decoder supports the
 * supplied game's PCM and Ogg/Vorbis payloads, returning interleaved float PCM.
 * This is a native FFmpeg host adapter, not the game's original audio decoder. */
int his_audio_decode_file(const char *path,
                          HisAudio *audio,
                          char *error,
                          size_t error_capacity);
int his_audio_decode_memory(const uint8_t *bytes,
                            size_t length,
                            HisAudio *audio,
                            char *error,
                            size_t error_capacity);
void his_audio_destroy(HisAudio *audio);
const char *his_audio_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
