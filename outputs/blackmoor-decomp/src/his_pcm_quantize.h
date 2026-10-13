#ifndef HIS_PCM_QUANTIZE_H
#define HIS_PCM_QUANTIZE_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum his_pcm_quantize_status {
    HIS_PCM_QUANTIZE_OK = 0,
    HIS_PCM_QUANTIZE_ERR_ARGUMENT = 1,
    HIS_PCM_QUANTIZE_ERR_CAPACITY = 2,
    HIS_PCM_QUANTIZE_ERR_BOUNDS = 3
} HisPcmQuantizeStatus;

/* Reproduce the supplied game's 0x4f5b50 -> 0x4fe2d0 PCM output path for
 * float samples arranged as one planar array per channel:
 *
 *   8-bit: unsigned offset-binary bytes, rounded from sample * 128 and
 *          saturated to signed [-128, 127] before adding 128.
 *   16-bit: signed little-endian words, rounded from sample * 32768 and
 *           saturated to [-32768, 32767].
 *
 * Ties use round-to-nearest-even, matching the x87 FISTP conversion when its
 * control word is the tested 0x037f. NaN, infinity, and values that
 * overflow FISTP's signed 32-bit destination produce the output minimum in
 * that environment. The original conversion reads the ambient x87 rounding
 * mode; this portable routine fixes the behavior to nearest-even.
 *
 * Samples are interleaved by frame in the output. If output_capacity cannot
 * hold all frames, the routine writes the largest whole-frame prefix and
 * returns its count. Source planes and destination must not overlap. This
 * function models only float-to-PCM conversion; it does not decode Vorbis.
 */
int his_pcm_quantize_planar(const float *const *source_planes,
                            uint32_t channels,
                            uint64_t frame_count,
                            uint32_t bits_per_sample,
                            uint8_t *output,
                            size_t output_capacity,
                            uint64_t *frames_written);

const char *his_pcm_quantize_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
