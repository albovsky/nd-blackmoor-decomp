#include "his_pcm_quantize.h"

#include <limits.h>
#include <math.h>
#include <stdint.h>

static double round_nearest_even(double value)
{
    double lower = floor(value);
    double fraction = value - lower;

    if (fraction < 0.5) {
        return lower;
    }
    if (fraction > 0.5) {
        return lower + 1.0;
    }
    return fmod(fabs(lower), 2.0) == 0.0 ? lower : lower + 1.0;
}

static int32_t quantize_sample(float sample,
                               double scale,
                               int32_t minimum,
                               int32_t maximum)
{
    double scaled;
    double rounded;

    if (!isfinite(sample)) {
        /* With the original x87 invalid-operation exception masked, FISTP
         * stores the integer-indefinite value INT32_MIN; the following
         * saturation clamps it to the output minimum. */
        return minimum;
    }

    scaled = (double)sample * scale;
    if (!isfinite(scaled) || scaled <= (double)minimum) {
        return minimum;
    }

    /* The original first converts to signed 32-bit with FISTP. Positive
     * overflow stores INT32_MIN in the tested masked x87 environment, so its
     * later output clamp also selects the minimum. Keep that edge distinct
     * from ordinary positive output saturation. */
    if (scaled >= (double)INT32_MAX + 0.5) {
        return minimum;
    }

    rounded = round_nearest_even(scaled);
    if (rounded <= (double)minimum) {
        return minimum;
    }
    if (rounded >= (double)maximum) {
        return maximum;
    }
    return (int32_t)rounded;
}

int his_pcm_quantize_planar(const float *const *source_planes,
                            uint32_t channels,
                            uint64_t frame_count,
                            uint32_t bits_per_sample,
                            uint8_t *output,
                            size_t output_capacity,
                            uint64_t *frames_written)
{
    uint32_t bytes_per_sample;
    size_t bytes_per_frame;
    uint64_t frames_to_write;
    double scale;
    int32_t minimum;
    int32_t maximum;

    if (frames_written != NULL) {
        *frames_written = 0;
    }
    if (source_planes == NULL || output == NULL || frames_written == NULL ||
        channels < 1u || channels > 2u || frame_count == 0u) {
        return HIS_PCM_QUANTIZE_ERR_ARGUMENT;
    }
    if (bits_per_sample == 8u) {
        bytes_per_sample = 1u;
        scale = 128.0;
        minimum = -128;
        maximum = 127;
    } else if (bits_per_sample == 16u) {
        bytes_per_sample = 2u;
        scale = 32768.0;
        minimum = -32768;
        maximum = 32767;
    } else {
        return HIS_PCM_QUANTIZE_ERR_ARGUMENT;
    }
    for (uint32_t channel = 0; channel < channels; ++channel) {
        if (source_planes[channel] == NULL) {
            return HIS_PCM_QUANTIZE_ERR_ARGUMENT;
        }
    }

    bytes_per_frame = (size_t)channels * bytes_per_sample;
    frames_to_write = (uint64_t)(output_capacity / bytes_per_frame);
    if (frames_to_write > frame_count) {
        frames_to_write = frame_count;
    }
    if (frames_to_write == 0u) {
        return HIS_PCM_QUANTIZE_ERR_CAPACITY;
    }
    if (frames_to_write > (uint64_t)(SIZE_MAX / sizeof(float))) {
        return HIS_PCM_QUANTIZE_ERR_BOUNDS;
    }

    for (uint64_t frame = 0; frame < frames_to_write; ++frame) {
        for (uint32_t channel = 0; channel < channels; ++channel) {
            int32_t value = quantize_sample(source_planes[channel][frame],
                                            scale, minimum, maximum);
            size_t output_index = (size_t)frame * bytes_per_frame +
                                  (size_t)channel * bytes_per_sample;
            if (bits_per_sample == 8u) {
                output[output_index] = (uint8_t)(value + 128);
            } else {
                uint16_t encoded = (uint16_t)(int16_t)value;
                output[output_index] = (uint8_t)(encoded & 0xffu);
                output[output_index + 1u] = (uint8_t)(encoded >> 8);
            }
        }
    }

    *frames_written = frames_to_write;
    return HIS_PCM_QUANTIZE_OK;
}

const char *his_pcm_quantize_status_string(int status)
{
    switch (status) {
        case HIS_PCM_QUANTIZE_OK: return "ok";
        case HIS_PCM_QUANTIZE_ERR_ARGUMENT: return "invalid argument";
        case HIS_PCM_QUANTIZE_ERR_CAPACITY: return "output capacity is too small";
        case HIS_PCM_QUANTIZE_ERR_BOUNDS: return "sample range exceeds addressable memory";
        default: return "unknown HIS PCM quantizer status";
    }
}
