#include "cif_pixels.h"

#include <limits.h>

static uint16_t read_u16_le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static void write_u16_le(uint8_t *bytes, uint16_t value)
{
    bytes[0] = (uint8_t)value;
    bytes[1] = (uint8_t)(value >> 8);
}

void cif_pixels_convert_555(uint8_t *pixels,
                            uint32_t byte_count,
                            const cif_pixel_format *format)
{
    uint32_t pixel_count;
    uint32_t index;

    if (pixels == NULL || format == NULL || format->enabled == 0) {
        return;
    }

    pixel_count = byte_count >> 1;
    for (index = 0; index < pixel_count; ++index) {
        uint8_t *word_bytes = pixels + ((size_t)index * 2U);
        uint16_t source = read_u16_le(word_bytes);
        uint8_t red = (uint8_t)((source >> 10) & 0x1fU);
        uint8_t green = (uint8_t)((source >> 5) & 0x1fU);
        uint8_t blue = (uint8_t)(source & 0x1fU);
        uint32_t packed;

        /* Preserve the original nested if/else priority exactly. */
        if (format->channel_bits[2] == 5) {
            if (format->channel_bits[1] == 5) {
                if (format->channel_bits[0] != 5) {
                    blue = (uint8_t)(blue << 1);
                }
            } else {
                green = (uint8_t)(green << 1);
            }
        } else {
            red = (uint8_t)(red << 1);
        }

        /* x86 masks shift counts to five bits; unsigned arithmetic avoids C UB. */
        packed = ((uint32_t)red << (format->shifts[2] & 0x1fU)) |
                 ((uint32_t)green << (format->shifts[1] & 0x1fU)) |
                 ((uint32_t)blue << (format->shifts[0] & 0x1fU));
        write_u16_le(word_bytes, (uint16_t)packed);
    }
}

int cif_pixels_rgb555_to_rgba(const uint8_t *pixels,
                              size_t byte_count,
                              uint8_t *rgba,
                              size_t rgba_capacity)
{
    size_t pixel_count = byte_count / 2U;
    size_t index;

    if (pixel_count > SIZE_MAX / 4U || rgba_capacity < pixel_count * 4U) {
        return 0;
    }
    if (pixel_count != 0 && (pixels == NULL || rgba == NULL)) {
        return 0;
    }

    for (index = 0; index < pixel_count; ++index) {
        uint16_t source = read_u16_le(pixels + index * 2U);
        uint8_t red5 = (uint8_t)((source >> 10) & 0x1fU);
        uint8_t green5 = (uint8_t)((source >> 5) & 0x1fU);
        uint8_t blue5 = (uint8_t)(source & 0x1fU);
        size_t output = index * 4U;

        rgba[output] = (uint8_t)((red5 << 3) | (red5 >> 2));
        rgba[output + 1U] = (uint8_t)((green5 << 3) | (green5 >> 2));
        rgba[output + 2U] = (uint8_t)((blue5 << 3) | (blue5 >> 2));
        rgba[output + 3U] = UINT8_MAX;
    }

    return 1;
}
