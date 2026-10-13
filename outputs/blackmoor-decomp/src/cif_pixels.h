#ifndef CIF_PIXELS_H
#define CIF_PIXELS_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Parameters recovered from the original renderer object used by FUN004c7314.
 * Channel arrays follow the original object offsets, in blue/green/red order:
 *   shifts[0..2]      -> object +0x38c0..+0x38c2
 *   channel_bits[0..2]-> object +0x38c8..+0x38ca
 * channel_bits are signed because the original compares signed `char` values
 * with 5. The conversion itself reads and writes little-endian 16-bit words.
 */
typedef struct cif_pixel_format {
    uint32_t enabled;
    uint8_t shifts[3];
    int8_t channel_bits[3];
} cif_pixel_format;

/* Reproduce FUN004c7314 on byte_count / 2 RGB555 words in place. */
void cif_pixels_convert_555(uint8_t *pixels,
                            uint32_t byte_count,
                            const cif_pixel_format *format);

/*
 * Host-rendering adapter: expand little-endian RGB555 words to RGBA8 using
 * bit replication and opaque alpha. This is a presentation choice, separate
 * from the recovered in-place renderer conversion above.
 *
 * Returns 1 on success and 0 if a pointer/capacity is invalid. An odd trailing
 * input byte is ignored, matching the word count convention of the original.
 */
int cif_pixels_rgb555_to_rgba(const uint8_t *pixels,
                              size_t byte_count,
                              uint8_t *rgba,
                              size_t rgba_capacity);

#ifdef __cplusplus
}
#endif

#endif
