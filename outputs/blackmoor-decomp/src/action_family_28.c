#include "action_family_28.h"

#include <math.h>
#include <stdlib.h>
#include <string.h>

#define ACTION_FAMILY28_LUT_ENTRIES (64u * 64u)

_Static_assert(sizeof(double) == sizeof(uint64_t),
               "A-28 LUT requires the original binary64 weight format");

__extension__ typedef unsigned __int128 ActionFamily28UInt128;
__extension__ typedef __int128 ActionFamily28Int128;

static uint16_t read_u16_le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static uint32_t read_u32_le(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] |
           ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) |
           ((uint32_t)bytes[3] << 24);
}

static int16_t signed_i16(uint16_t bits)
{
    if (bits <= INT16_MAX) {
        return (int16_t)bits;
    }
    return (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static int32_t signed_i32(uint32_t bits)
{
    if (bits <= INT32_MAX) {
        return (int32_t)bits;
    }
    return -1 - (int32_t)(UINT32_MAX - bits);
}

static int32_t add_i32_wrapping(int32_t left, int32_t right)
{
    return signed_i32((uint32_t)left + (uint32_t)right);
}

static int ranges_overlap(const void *left,
                          size_t left_size,
                          const void *right,
                          size_t right_size,
                          int *out_overlap)
{
    uintptr_t left_begin;
    uintptr_t right_begin;
    uintptr_t left_end;
    uintptr_t right_end;

    *out_overlap = 0;
    if (left_size == 0u || right_size == 0u) {
        return 1;
    }
    left_begin = (uintptr_t)left;
    right_begin = (uintptr_t)right;
    if (left_size > UINTPTR_MAX - left_begin ||
        right_size > UINTPTR_MAX - right_begin) {
        return 0;
    }
    left_end = left_begin + left_size;
    right_end = right_begin + right_size;
    *out_overlap = left_begin < right_end && right_begin < left_end;
    return 1;
}

typedef struct {
    int sign;
    ActionFamily28UInt128 significand;
    int exponent;
} ActionFamily28X87Value;

static unsigned bit_length_u128(ActionFamily28UInt128 value)
{
    unsigned bits = 0u;
    while (value != 0u) {
        bits += 1u;
        value >>= 1;
    }
    return bits;
}

static ActionFamily28X87Value round_x87_value(int sign,
                                               ActionFamily28UInt128 significand,
                                               int exponent,
                                               unsigned precision)
{
    ActionFamily28X87Value result;
    unsigned bits = bit_length_u128(significand);

    result.sign = sign;
    result.significand = significand;
    result.exponent = exponent;
    if (significand == 0u) {
        result.sign = 0;
        result.exponent = 0;
        return result;
    }
    if (bits > precision) {
        unsigned discarded = bits - precision;
        ActionFamily28UInt128 mask =
            ((ActionFamily28UInt128)1u << discarded) - 1u;
        ActionFamily28UInt128 remainder = significand & mask;
        ActionFamily28UInt128 halfway =
            (ActionFamily28UInt128)1u << (discarded - 1u);

        result.significand = significand >> discarded;
        if (remainder > halfway ||
            (remainder == halfway && (result.significand & 1u) != 0u)) {
            result.significand += 1u;
        }
        result.exponent += (int)discarded;
        if (result.significand == ((ActionFamily28UInt128)1u << precision)) {
            result.significand >>= 1;
            result.exponent += 1;
        }
    }
    return result;
}

static ActionFamily28X87Value add_x87_values(ActionFamily28X87Value left,
                                              ActionFamily28X87Value right,
                                              unsigned precision)
{
    ActionFamily28UInt128 left_magnitude;
    ActionFamily28UInt128 right_magnitude;
    ActionFamily28UInt128 magnitude;
    int exponent;
    int sign;
    unsigned left_shift;
    unsigned right_shift;

    if (left.sign == 0) {
        return right;
    }
    if (right.sign == 0) {
        return left;
    }
    exponent = left.exponent < right.exponent ? left.exponent : right.exponent;
    left_shift = (unsigned)(left.exponent - exponent);
    right_shift = (unsigned)(right.exponent - exponent);
    /* For the bounded RGB/weight domain the largest aligned sum is <2^66. */
    left_magnitude = left.significand << left_shift;
    right_magnitude = right.significand << right_shift;
    if (left.sign == right.sign) {
        sign = left.sign;
        magnitude = left_magnitude + right_magnitude;
    } else if (left_magnitude > right_magnitude) {
        sign = left.sign;
        magnitude = left_magnitude - right_magnitude;
    } else if (right_magnitude > left_magnitude) {
        sign = right.sign;
        magnitude = right_magnitude - left_magnitude;
    } else {
        return round_x87_value(0, 0u, 0, precision);
    }
    return round_x87_value(sign, magnitude, exponent, precision);
}

static int32_t blend_value_x87(int first,
                               int second,
                               double weight,
                               unsigned precision)
{
    uint64_t weight_bits;
    uint64_t fraction;
    uint64_t significand;
    unsigned exponent_field;
    int exponent;
    int difference = first - second;
    ActionFamily28X87Value product;
    ActionFamily28X87Value half;
    ActionFamily28X87Value base;
    ActionFamily28X87Value sum;
    ActionFamily28UInt128 integer;

    memcpy(&weight_bits, &weight, sizeof(weight_bits));
    exponent_field = (unsigned)((weight_bits >> 52) & UINT64_C(0x7ff));
    fraction = weight_bits & UINT64_C(0x000fffffffffffff);
    if (exponent_field == 0u) {
        significand = fraction;
        exponent = -1074;
    } else {
        significand = fraction | UINT64_C(0x0010000000000000);
        exponent = (int)exponent_field - 1023 - 52;
    }

    /* With |difference*weight| < 0.5, adding the original half and base
     * truncates to base for either supported precision. This also handles
     * binary64 subnormals without forming an oversized fixed-point shift. */
    if (exponent <= -60 || difference == 0) {
        return (int32_t)second;
    }

    product = round_x87_value(difference < 0 ? -1 : 1,
        (ActionFamily28UInt128)(difference < 0 ? -difference : difference) *
            (ActionFamily28UInt128)significand,
        exponent, precision);
    half = round_x87_value(1, 1u, -1, precision);
    base = round_x87_value(second == 0 ? 0 : 1,
                           (ActionFamily28UInt128)second, 0, precision);
    sum = add_x87_values(add_x87_values(product, half, precision), base, precision);
    integer = sum.exponent >= 0 ?
        sum.significand << (unsigned)sum.exponent :
        sum.significand >> (unsigned)(-sum.exponent);
    if (sum.sign < 0) {
        return -(int32_t)integer;
    }
    return (int32_t)integer;
}

int action_family28_decode(const uint8_t *body,
                           size_t body_length,
                           ActionFamily28Decoded *out_decoded,
                           size_t *out_consumed)
{
    ActionFamily28Decoded decoded;

    if (body == NULL || out_decoded == NULL || out_consumed == NULL) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    if (body_length < ACTION_FAMILY_28_BODY_BYTES) {
        return ACTION_FAMILY28_ERR_BODY;
    }

    decoded.effect_type = body[0];
    decoded.sequence_budget_ms = signed_i16(read_u16_le(body + 1u));
    decoded.pause_ms = signed_i16(read_u16_le(body + 3u));
    decoded.rect.left = signed_i32(read_u32_le(body + 5u));
    decoded.rect.top = signed_i32(read_u32_le(body + 9u));
    decoded.rect.right = signed_i32(read_u32_le(body + 13u));
    decoded.rect.bottom = signed_i32(read_u32_le(body + 17u));
    memcpy(decoded.source_bytes, body, ACTION_FAMILY_28_BODY_BYTES);
    *out_decoded = decoded;
    *out_consumed = ACTION_FAMILY_28_BODY_BYTES;
    return ACTION_FAMILY28_OK;
}

int action_family28_step(const ActionFamily28Input *input,
                         const ActionFamily28World *world,
                         ActionFamily28Result *out_result)
{
    ActionFamily28Result result;

    if (input == NULL || world == NULL || out_result == NULL) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    if (input->type != ACTION_FAMILY_28_TYPE) {
        return ACTION_FAMILY28_ERR_UNSUPPORTED;
    }

    memset(&result, 0, sizeof(result));
    result.recognized = 1u;
    result.phase = input->phase_before;
    result.world = *world;

    /* The dispatcher skips completed slots and false dependency gates. */
    if (!input->eligible || input->completed_before) {
        *out_result = result;
        return ACTION_FAMILY28_OK;
    }

    if (input->phase_before == 0u) {
        ActionFamily28Decoded decoded;
        size_t consumed;
        int status;

        if (world->busy) {
            *out_result = result;
            return ACTION_FAMILY28_OK;
        }
        status = action_family28_decode(input->body, input->body_length,
                                        &decoded, &consumed);
        if (status != ACTION_FAMILY28_OK) {
            return status;
        }
        (void)consumed;
        result.applied = 1u;
        result.job_started = 1u;
        result.phase = 2u;
        result.world.busy = 1u;
        result.world.sequence_counter = 0u;
        memcpy(result.world.active_payload, decoded.source_bytes,
               ACTION_FAMILY_28_BODY_BYTES);
        if (decoded.rect.right == decoded.rect.left ||
            decoded.rect.bottom == decoded.rect.top) {
            result.world.current_rect = result.world.full_canvas;
        } else {
            result.world.current_rect.left = add_i32_wrapping(
                world->current_rect.left, decoded.rect.left);
            result.world.current_rect.top = add_i32_wrapping(
                world->current_rect.top, decoded.rect.top);
            result.world.current_rect.right = add_i32_wrapping(
                world->full_canvas.left, decoded.rect.right);
            result.world.current_rect.bottom = add_i32_wrapping(
                world->full_canvas.top, decoded.rect.bottom);
        }
    } else if (input->phase_before == 2u) {
        result.applied = 1u;
        result.completion_valid = 1u;
        result.phase = 0u;
        if (input->subtype == 1u) {
            result.completed = 1u;
        } else if (input->subtype == 2u) {
            result.completed = 0u;
            result.reset_dependencies = 1u;
        } else {
            result.completed = input->completed_before;
        }
    }

    *out_result = result;
    return ACTION_FAMILY28_OK;
}

int action_family28_render_gate(uint8_t busy,
                                uint8_t subtype,
                                uint32_t scene_state,
                                uint32_t stage,
                                uint8_t *out_should_run)
{
    uint8_t should_run = 0u;

    if (out_should_run == NULL) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    if (busy != 0u) {
        if (subtype == 1u) {
            should_run = (uint8_t)(scene_state == 4u);
        } else if (subtype == 2u || subtype == 3u) {
            should_run = (uint8_t)((scene_state == 4u && stage == 0u) ||
                                   (scene_state == 3u &&
                                    (stage == 1u || stage == 2u)));
        }
    }
    *out_should_run = should_run;
    return ACTION_FAMILY28_OK;
}

int action_family28_sequence_frame_count(int16_t sequence_budget_ms,
                                         uint32_t first_frame_elapsed_ms,
                                         uint32_t *out_frame_count)
{
    int32_t elapsed = signed_i32(first_frame_elapsed_ms);
    int32_t configured_count;

    if (out_frame_count == NULL) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    if (elapsed == 0) {
        configured_count = 30;
    } else {
        int32_t doubled_elapsed = signed_i32((uint32_t)elapsed * 2u);
        if (doubled_elapsed < sequence_budget_ms) {
            configured_count = (int32_t)sequence_budget_ms / elapsed;
        } else {
            configured_count = 2;
        }
    }
    /* The original is a do/while loop, so even a zero or negative configured
     * count still runs the first blend and pump iteration. */
    *out_frame_count = configured_count > 1 ? (uint32_t)configured_count : 1u;
    return ACTION_FAMILY28_OK;
}

int action_family28_unpack_rgb16(const uint8_t *surface,
                                 size_t surface_length,
                                 size_t surface_width,
                                 size_t surface_height,
                                 size_t source_pitch_bytes,
                                 size_t left,
                                 size_t top,
                                 size_t width,
                                 size_t height,
                                 const uint8_t shifts[3],
                                 const uint8_t masks[3],
                                 uint8_t *rgb,
                                 size_t output_capacity)
{
    size_t row_bytes;
    size_t pixels;
    size_t output_bytes;
    size_t last_row;
    size_t source_offset;
    size_t source_end;
    size_t source_span;
    uintptr_t source_address;
    const uint8_t *source_region;
    uint8_t local_shifts[3];
    uint8_t local_masks[3];
    int overlaps;
    size_t row;
    size_t column;

    if (shifts == NULL || masks == NULL) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    memcpy(local_shifts, shifts, sizeof(local_shifts));
    memcpy(local_masks, masks, sizeof(local_masks));
    if (surface_width > SIZE_MAX / 2u ||
        (height != 0u && width > SIZE_MAX / height) ||
        (height != 0u && width * height > SIZE_MAX / 3u)) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    row_bytes = surface_width * 2u;
    if (source_pitch_bytes < row_bytes || left > surface_width ||
        width > surface_width - left || top > surface_height ||
        height > surface_height - top) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    pixels = width * height;
    output_bytes = pixels * 3u;
    if (output_capacity < output_bytes) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    if (output_bytes == 0u) {
        return ACTION_FAMILY28_OK;
    }
    if (surface == NULL || rgb == NULL) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    if (local_masks[0] > 63u || local_masks[1] > 63u || local_masks[2] > 63u) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    if (top > SIZE_MAX / source_pitch_bytes) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    source_offset = top * source_pitch_bytes;
    if (left > SIZE_MAX / 2u || source_offset > SIZE_MAX - left * 2u) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    source_offset += left * 2u;
    if (top + height - 1u > SIZE_MAX / source_pitch_bytes) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    last_row = (top + height - 1u) * source_pitch_bytes;
    if (left + width > SIZE_MAX / 2u ||
        last_row > SIZE_MAX - (left + width) * 2u) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    source_end = last_row + (left + width) * 2u;
    if (source_end > surface_length) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    source_span = source_end - source_offset;
    source_address = (uintptr_t)surface;
    if (source_offset > UINTPTR_MAX - source_address) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    source_region = (const uint8_t *)(source_address + source_offset);
    if (!ranges_overlap(source_region, source_span, rgb, output_bytes,
                        &overlaps) || overlaps) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }

    for (row = 0u; row < height; ++row) {
        size_t input_row = (top + row) * source_pitch_bytes + left * 2u;
        for (column = 0u; column < width; ++column) {
            uint16_t packed = read_u16_le(surface + input_row + column * 2u);
            size_t output_index = (row * width + column) * 3u;
            size_t channel;
            for (channel = 0u; channel < 3u; ++channel) {
                rgb[output_index + channel] = (uint8_t)(
                    (packed >> (local_shifts[channel] & 31u)) & local_masks[channel]);
            }
        }
    }
    return ACTION_FAMILY28_OK;
}

int action_family28_blend_table_for_cw(double weight,
                                      uint16_t control_word,
                                      int32_t *table,
                                      size_t capacity)
{
    int32_t values[ACTION_FAMILY28_LUT_ENTRIES];
    int first;
    int second;
    unsigned precision;

    if (table == NULL || !isfinite(weight) || weight < 0.0 || weight > 1.0) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    if (control_word == ACTION_FAMILY28_X87_CW_DOUBLE) {
        precision = 53u;
    } else if (control_word == ACTION_FAMILY28_X87_CW_EXTENDED) {
        precision = 64u;
    } else {
        return ACTION_FAMILY28_ERR_UNSUPPORTED;
    }
    if (capacity < ACTION_FAMILY28_LUT_ENTRIES) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }

    for (first = 0; first < 64; ++first) {
        for (second = 0; second < 64; ++second) {
            size_t index = (size_t)first * 64u + (size_t)second;
            values[index] = blend_value_x87(first, second, weight, precision);
        }
    }
    memcpy(table, values, sizeof(values));
    return ACTION_FAMILY28_OK;
}

int action_family28_blend_table(double weight,
                                int32_t *table,
                                size_t capacity)
{
    return action_family28_blend_table_for_cw(weight,
        ACTION_FAMILY28_X87_CW_EXTENDED, table, capacity);
}

int action_family28_blend_pixels_for_cw(const uint8_t *first_rgb,
                                        const uint8_t *second_rgb,
                                        size_t pixels,
                                        double weight,
                                        uint16_t control_word,
                                        const uint8_t shifts[3],
                                        uint16_t *output,
                                        size_t output_capacity)
{
    int32_t table[ACTION_FAMILY28_LUT_ENTRIES];
    uint8_t local_shifts[3];
    uint16_t *temporary = NULL;
    uint16_t *target = output;
    size_t input_bytes;
    size_t output_bytes;
    size_t pixel;
    int overlap_first;
    int overlap_second;
    int status;

    if (shifts == NULL || !isfinite(weight) || weight < 0.0 || weight > 1.0) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    if (control_word != ACTION_FAMILY28_X87_CW_DOUBLE &&
        control_word != ACTION_FAMILY28_X87_CW_EXTENDED) {
        return ACTION_FAMILY28_ERR_UNSUPPORTED;
    }
    if (pixels > SIZE_MAX / 3u || pixels > SIZE_MAX / sizeof(*output) ||
        output_capacity < pixels) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    if (pixels != 0u &&
        (first_rgb == NULL || second_rgb == NULL || output == NULL)) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    memcpy(local_shifts, shifts, sizeof(local_shifts));
    input_bytes = pixels * 3u;
    output_bytes = pixels * sizeof(*output);

    /* Validate caller-controlled address spans before reading either source.
     * The overlap result is also reused to choose atomic scratch output. */
    if (!ranges_overlap(first_rgb, input_bytes, output, output_bytes,
                        &overlap_first) ||
        !ranges_overlap(second_rgb, input_bytes, output, output_bytes,
                        &overlap_second)) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }

    for (pixel = 0u; pixel < input_bytes; ++pixel) {
        if (first_rgb[pixel] > 63u || second_rgb[pixel] > 63u) {
            return ACTION_FAMILY28_ERR_BOUNDS;
        }
    }
    status = action_family28_blend_table_for_cw(weight, control_word, table,
                                                ACTION_FAMILY28_LUT_ENTRIES);
    if (status != ACTION_FAMILY28_OK) {
        return status;
    }
    if (overlap_first || overlap_second) {
        temporary = (uint16_t *)malloc(output_bytes);
        if (temporary == NULL) {
            return ACTION_FAMILY28_ERR_MEMORY;
        }
        target = temporary;
    }

    for (pixel = 0u; pixel < pixels; ++pixel) {
        uint32_t packed = 0u;
        size_t channel;

        for (channel = 0u; channel < 3u; ++channel) {
            size_t offset = pixel * 3u + channel;
            size_t table_index = (size_t)first_rgb[offset] * 64u +
                                 (size_t)second_rgb[offset];
            uint32_t shifted = (uint32_t)table[table_index] <<
                               (local_shifts[channel] & 31u);
            packed |= shifted & UINT32_C(0xffff);
        }
        target[pixel] = (uint16_t)packed;
    }
    if (temporary != NULL) {
        memcpy(output, temporary, output_bytes);
        free(temporary);
    }
    return ACTION_FAMILY28_OK;
}

int action_family28_blend_pixels(const uint8_t *first_rgb,
                                 const uint8_t *second_rgb,
                                 size_t pixels,
                                 double weight,
                                 const uint8_t shifts[3],
                                 uint16_t *output,
                                 size_t output_capacity)
{
    return action_family28_blend_pixels_for_cw(first_rgb, second_rgb, pixels,
        weight, ACTION_FAMILY28_X87_CW_EXTENDED, shifts, output, output_capacity);
}
