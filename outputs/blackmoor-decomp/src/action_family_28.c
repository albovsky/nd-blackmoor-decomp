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

static ActionFamily28X87Value x87_value_from_double(double value)
{
    uint64_t bits;
    uint64_t fraction;
    unsigned exponent_field;
    ActionFamily28X87Value result;

    memcpy(&bits, &value, sizeof(bits));
    result.sign = (bits >> 63) != 0u ? -1 : 1;
    fraction = bits & UINT64_C(0x000fffffffffffff);
    exponent_field = (unsigned)((bits >> 52) & UINT64_C(0x7ff));
    if (exponent_field == 0u) {
        result.significand = (ActionFamily28UInt128)fraction;
        result.exponent = -1074;
    } else {
        result.significand = (ActionFamily28UInt128)(
            fraction | UINT64_C(0x0010000000000000));
        result.exponent = (int)exponent_field - 1023 - 52;
    }
    if (result.significand == 0u) {
        result.sign = 0;
        result.exponent = 0;
    }
    return result;
}

static ActionFamily28X87Value x87_value_from_i32(int32_t value)
{
    ActionFamily28X87Value result;

    result.sign = value < 0 ? -1 : (value == 0 ? 0 : 1);
    result.significand = (ActionFamily28UInt128)(
        value < 0 ? -(int64_t)value : value);
    result.exponent = 0;
    return result;
}

static ActionFamily28X87Value multiply_x87_values(
    ActionFamily28X87Value left,
    ActionFamily28X87Value right,
    unsigned precision)
{
    return round_x87_value(left.sign * right.sign,
        left.significand * right.significand,
        left.exponent + right.exponent, precision);
}

static ActionFamily28X87Value divide_x87_values(
    ActionFamily28X87Value numerator,
    ActionFamily28X87Value denominator,
    unsigned precision)
{
    ActionFamily28UInt128 scaled_numerator;
    ActionFamily28UInt128 scaled_denominator;
    ActionFamily28UInt128 quotient;
    ActionFamily28UInt128 remainder;
    unsigned numerator_bits;
    unsigned denominator_bits;
    int shift;
    int exponent_shift;
    int exponent;

    if (numerator.sign == 0 || denominator.sign == 0) {
        return round_x87_value(0, 0u, 0, precision);
    }
    numerator_bits = bit_length_u128(numerator.significand);
    denominator_bits = bit_length_u128(denominator.significand);
    shift = (int)precision - 1 + (int)denominator_bits -
            (int)numerator_bits;
    exponent_shift = shift;
    scaled_numerator = numerator.significand;
    scaled_denominator = denominator.significand;
    if (shift >= 0) {
        if ((unsigned)shift >= 128u ||
            numerator_bits + (unsigned)shift > 128u) {
            return round_x87_value(0, 0u, 0, precision);
        }
        scaled_numerator <<= (unsigned)shift;
    } else {
        unsigned denominator_shift = (unsigned)(-shift);
        if (denominator_shift >= 128u ||
            denominator_bits + denominator_shift > 128u) {
            return round_x87_value(0, 0u, 0, precision);
        }
        scaled_denominator <<= denominator_shift;
    }
    quotient = scaled_numerator / scaled_denominator;
    remainder = scaled_numerator % scaled_denominator;
    if (remainder > scaled_denominator - remainder ||
        (remainder == scaled_denominator - remainder &&
         (quotient & 1u) != 0u)) {
        quotient += 1u;
    }
    exponent = numerator.exponent - denominator.exponent - exponent_shift;
    if (quotient == ((ActionFamily28UInt128)1u << precision)) {
        quotient >>= 1;
        exponent += 1;
    }
    return round_x87_value(numerator.sign * denominator.sign, quotient,
                           exponent, precision);
}

static ActionFamily28X87Value subtract_x87_values(
    ActionFamily28X87Value left,
    ActionFamily28X87Value right,
    unsigned precision)
{
    right.sign = -right.sign;
    return add_x87_values(left, right, precision);
}

static double x87_value_to_double(ActionFamily28X87Value value)
{
    ActionFamily28X87Value binary64 = round_x87_value(
        value.sign, value.significand, value.exponent, 53u);
    double converted = ldexp((double)binary64.significand,
                             binary64.exponent);

    return binary64.sign < 0 ? -converted : converted;
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

static int32_t sequence_frame_count_raw(int16_t sequence_budget_ms,
                                        uint32_t first_frame_elapsed_ms)
{
    int32_t elapsed = signed_i32(first_frame_elapsed_ms);
    int32_t configured_count;

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
    return configured_count;
}

int action_family28_sequence_frame_count(int16_t sequence_budget_ms,
                                         uint32_t first_frame_elapsed_ms,
                                         uint32_t *out_frame_count)
{
    int32_t configured_count;

    if (out_frame_count == NULL) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    configured_count = sequence_frame_count_raw(sequence_budget_ms,
                                                 first_frame_elapsed_ms);
    /* The original is a do/while loop, so even a zero or negative configured
     * count still runs the first blend and pump iteration. */
    *out_frame_count = configured_count > 1 ? (uint32_t)configured_count : 1u;
    return ACTION_FAMILY28_OK;
}

static unsigned sequence_precision_for_cw(uint16_t control_word)
{
    if (control_word == ACTION_FAMILY28_X87_CW_DOUBLE) {
        return 53u;
    }
    if (control_word == ACTION_FAMILY28_X87_CW_EXTENDED) {
        return 64u;
    }
    return 0u;
}

static ActionFamily28X87Value store_x87_double(ActionFamily28X87Value value)
{
    return round_x87_value(value.sign, value.significand, value.exponent, 53u);
}

int action_family28_sequence_weight_for_cw(uint32_t frame_index,
                                           uint32_t selected_frame_count,
                                           uint16_t control_word,
                                           double *out_weight)
{
    unsigned precision;
    ActionFamily28X87Value frame;
    ActionFamily28X87Value count;
    ActionFamily28X87Value center;
    ActionFamily28X87Value radius;
    ActionFamily28X87Value offset;
    ActionFamily28X87Value offset_squared;
    ActionFamily28X87Value offset_cubed;
    ActionFamily28X87Value offset_fourth;
    ActionFamily28X87Value radius_squared;
    ActionFamily28X87Value radius_cubed;
    ActionFamily28X87Value radius_fourth;
    ActionFamily28X87Value eight;
    ActionFamily28X87Value exponent;
    ActionFamily28X87Value one;
    ActionFamily28X87Value exp_result;
    ActionFamily28X87Value weight;
    double exponent_as_double;
    double exp_as_double;
    double result;

    if (out_weight == NULL || selected_frame_count == 0u ||
        selected_frame_count > INT32_MAX || frame_index > INT32_MAX ||
        frame_index >= selected_frame_count) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    precision = sequence_precision_for_cw(control_word);
    if (precision == 0u) {
        return ACTION_FAMILY28_ERR_UNSUPPORTED;
    }
    if (frame_index == 0u) {
        *out_weight = 1.0;
        return ACTION_FAMILY28_OK;
    }

    /* 0x44753b stores the scaled center and radius as binary64 before doing
     * their powers in x87 registers. Preserve that order while selecting the
     * original 53- or 64-bit significand precision explicitly. */
    frame = x87_value_from_i32((int32_t)frame_index);
    count = x87_value_from_i32((int32_t)selected_frame_count);
    center = multiply_x87_values(x87_value_from_double(0x1.4cccccccccccdp+0),
                                 count, precision);
    center = x87_value_from_double(x87_value_to_double(
        store_x87_double(center)));
    offset = subtract_x87_values(frame, center, precision);
    offset = x87_value_from_double(x87_value_to_double(
        store_x87_double(offset)));

    radius = multiply_x87_values(x87_value_from_double(0x1.8p+0), count,
                                 precision);
    radius = x87_value_from_double(x87_value_to_double(
        store_x87_double(radius)));

    offset_squared = multiply_x87_values(offset, offset, precision);
    offset_cubed = multiply_x87_values(offset_squared, offset, precision);
    offset_fourth = multiply_x87_values(offset_cubed, offset, precision);
    offset_fourth.sign = -offset_fourth.sign;

    radius_squared = multiply_x87_values(radius, radius, precision);
    radius_cubed = multiply_x87_values(radius_squared, radius, precision);
    radius_fourth = multiply_x87_values(radius_cubed, radius, precision);
    eight = x87_value_from_double(0x1p+3);
    radius_fourth = divide_x87_values(radius_fourth, eight, precision);
    exponent = divide_x87_values(offset_fourth, radius_fourth, precision);
    exponent_as_double = x87_value_to_double(store_x87_double(exponent));
    exp_as_double = exp(exponent_as_double);
    if (!isfinite(exp_as_double)) {
        return ACTION_FAMILY28_ERR_UNSUPPORTED;
    }

    one = x87_value_from_double(1.0);
    exp_result = x87_value_from_double(exp_as_double);
    weight = subtract_x87_values(one, exp_result, precision);
    result = x87_value_to_double(store_x87_double(weight));
    if (!isfinite(result) || result < 0.0 || result > 1.0) {
        return ACTION_FAMILY28_ERR_UNSUPPORTED;
    }
    *out_weight = result;
    return ACTION_FAMILY28_OK;
}

static int sequence_capture_span(const ActionFamily28SequenceState *state,
                                 const ActionFamily28Capture *capture,
                                 size_t *out_required_bytes)
{
    int64_t signed_width = (int64_t)state->target_rect.right -
                           (int64_t)state->target_rect.left + 1;
    int64_t signed_height = (int64_t)state->target_rect.bottom -
                            (int64_t)state->target_rect.top + 1;
    size_t width;
    size_t height;
    size_t last_row;
    size_t pixel_end;
    size_t required_bytes;
    size_t full_capture_pixels;
    size_t full_capture_bytes;
    uintptr_t address;

    if (signed_width <= 0 || signed_height <= 0 ||
        state->capture_width_pixels == 0u ||
        state->capture_height_pixels == 0u ||
        state->capture_stride_pixels != state->capture_width_pixels) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    if (state->capture_width_pixels >
        SIZE_MAX / state->capture_height_pixels) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    full_capture_pixels = state->capture_width_pixels *
                          state->capture_height_pixels;
    if (full_capture_pixels > SIZE_MAX / 12u) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    full_capture_bytes = full_capture_pixels * 12u;
#if SIZE_MAX < UINT64_MAX
    if ((uint64_t)signed_width > (uint64_t)SIZE_MAX ||
        (uint64_t)signed_height > (uint64_t)SIZE_MAX) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
#endif
    width = (size_t)signed_width;
    height = (size_t)signed_height;
    if (state->capture_offset_x_pixels > state->capture_width_pixels ||
        width > state->capture_width_pixels - state->capture_offset_x_pixels ||
        state->capture_offset_y_pixels > state->capture_height_pixels ||
        height > state->capture_height_pixels - state->capture_offset_y_pixels) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    if (state->capture_offset_y_pixels >
        SIZE_MAX - (height - 1u)) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    last_row = state->capture_offset_y_pixels + height - 1u;
    if (last_row > SIZE_MAX / state->capture_stride_pixels) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    pixel_end = last_row * state->capture_stride_pixels;
    if (pixel_end > SIZE_MAX - state->capture_offset_x_pixels ||
        pixel_end + state->capture_offset_x_pixels > SIZE_MAX - width) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    pixel_end += state->capture_offset_x_pixels + width;
    if (pixel_end > SIZE_MAX / 12u) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    required_bytes = pixel_end * 12u;
    if (capture->data == NULL || required_bytes > full_capture_bytes ||
        full_capture_bytes > capture->byte_length) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    address = (uintptr_t)capture->data;
    if (capture->byte_length > UINTPTR_MAX - address) {
        return ACTION_FAMILY28_ERR_BOUNDS;
    }
    /* The source object allocates full_canvas_width*full_canvas_height*12.
     * Use that full immutable capture span for alias checks, even when the
     * current rectangle addresses only a subregion. */
    *out_required_bytes = full_capture_bytes;
    return ACTION_FAMILY28_OK;
}

static int sequence_get_tick(const ActionFamily28SequenceCallbacks *callbacks,
                             ActionFamily28SequenceReport *report,
                             uint32_t *out_tick,
                             uint32_t associated_frame)
{
    int status;

    report->get_tick_calls += 1u;
    status = callbacks->get_tick_count(callbacks->context, out_tick);
    if (status != 0) {
        report->failed_callback = ACTION_FAMILY28_SEQUENCE_CALLBACK_TICK;
        report->failed_frame_index = associated_frame;
        report->callback_status = (int32_t)status;
        return ACTION_FAMILY28_ERR_CALLBACK;
    }
    return ACTION_FAMILY28_OK;
}

static int sequence_blend_present(
    const ActionFamily28SequenceState *state,
    const ActionFamily28SequenceCallbacks *callbacks,
    ActionFamily28SequenceReport *report,
    uint32_t frame_index,
    double weight,
    uint16_t control_word)
{
    ActionFamily28SequenceFrame frame;
    int status;

    memset(&frame, 0, sizeof(frame));
    frame.frame_index = frame_index;
    frame.weight = weight;
    frame.x87_control_word = control_word;
    frame.target_rect = state->target_rect;
    frame.source_capture = state->source_capture;
    frame.destination_capture = state->destination_capture;
    frame.capture_width_pixels = state->capture_width_pixels;
    frame.capture_height_pixels = state->capture_height_pixels;
    frame.capture_stride_pixels = state->capture_stride_pixels;
    frame.capture_offset_x_pixels = state->capture_offset_x_pixels;
    frame.capture_offset_y_pixels = state->capture_offset_y_pixels;
    frame.primary_target = state->primary_target;

    report->blend_present_calls += 1u;
    status = callbacks->blend_present(callbacks->context, &frame);
    if (status != 0) {
        report->failed_callback = ACTION_FAMILY28_SEQUENCE_CALLBACK_BLEND_PRESENT;
        report->failed_frame_index = frame_index;
        report->callback_status = (int32_t)status;
        return ACTION_FAMILY28_ERR_CALLBACK;
    }
    report->completed_frame_count += 1u;
    return ACTION_FAMILY28_OK;
}

static int sequence_system_audio_pump(
    const ActionFamily28SequenceCallbacks *callbacks,
    ActionFamily28SequenceReport *report,
    uint32_t associated_frame)
{
    int status;

    report->system_audio_pump_calls += 1u;
    status = callbacks->system_audio_pump(callbacks->context);
    if (status != 0) {
        report->failed_callback =
            ACTION_FAMILY28_SEQUENCE_CALLBACK_SYSTEM_AUDIO_PUMP;
        report->failed_frame_index = associated_frame;
        report->callback_status = (int32_t)status;
        return ACTION_FAMILY28_ERR_CALLBACK;
    }
    return ACTION_FAMILY28_OK;
}

int action_family28_run_sequence(ActionFamily28SequenceState *state,
    const ActionFamily28SequenceCallbacks *callbacks,
    uint16_t x87_control_word, ActionFamily28SequenceReport *out_report)
{
    ActionFamily28SequenceReport report;
    size_t required_source_bytes;
    size_t required_destination_bytes;
    uint32_t first_tick;
    uint32_t second_tick;
    uint32_t deadline;
    uint32_t now;
    int32_t selected_count;
    uint32_t executed_count;
    uint32_t frame_index;
    unsigned precision;
    int status;

    if (state == NULL || callbacks == NULL || out_report == NULL ||
        callbacks->get_tick_count == NULL || callbacks->blend_present == NULL ||
        callbacks->system_audio_pump == NULL || state->primary_target > 1u) {
        return ACTION_FAMILY28_ERR_ARGUMENT;
    }
    {
        int overlaps;
        if (!ranges_overlap(state, sizeof(*state), out_report,
                            sizeof(*out_report), &overlaps)) {
            return ACTION_FAMILY28_ERR_BOUNDS;
        }
        if (overlaps != 0) {
            return ACTION_FAMILY28_ERR_ARGUMENT;
        }
    }
    precision = sequence_precision_for_cw(x87_control_word);
    if (precision == 0u) {
        return ACTION_FAMILY28_ERR_UNSUPPORTED;
    }
    (void)precision;
    status = sequence_capture_span(state, &state->source_capture,
                                   &required_source_bytes);
    if (status != ACTION_FAMILY28_OK) {
        return status;
    }
    status = sequence_capture_span(state, &state->destination_capture,
                                   &required_destination_bytes);
    if (status != ACTION_FAMILY28_OK) {
        return status;
    }
    {
        int overlaps;
        if (!ranges_overlap(state, sizeof(*state), state->source_capture.data,
                            required_source_bytes, &overlaps) || overlaps != 0 ||
            !ranges_overlap(state, sizeof(*state), state->destination_capture.data,
                            required_destination_bytes, &overlaps) || overlaps != 0 ||
            !ranges_overlap(out_report, sizeof(*out_report), state->source_capture.data,
                            required_source_bytes, &overlaps) || overlaps != 0 ||
            !ranges_overlap(out_report, sizeof(*out_report),
                            state->destination_capture.data,
                            required_destination_bytes, &overlaps) || overlaps != 0) {
            return ACTION_FAMILY28_ERR_ARGUMENT;
        }
    }
    (void)required_source_bytes;
    (void)required_destination_bytes;

    memset(&report, 0, sizeof(report));
    report.failed_frame_index = UINT32_MAX;
    status = sequence_get_tick(callbacks, &report, &first_tick, UINT32_MAX);
    if (status != ACTION_FAMILY28_OK) {
        *out_report = report;
        return status;
    }
    /* The stack double starts zeroed; only subtypes 1..3 assign the first
     * frame's explicit unit weight at 0x447590. Other subtypes branch over
     * that assignment and retain 0.0 for every frame. */
    status = sequence_blend_present(state, callbacks, &report, 0u,
                                    (state->subtype >= 1u &&
                                     state->subtype <= 3u) ? 1.0 : 0.0,
                                    x87_control_word);
    if (status != ACTION_FAMILY28_OK) {
        *out_report = report;
        return status;
    }
    status = sequence_get_tick(callbacks, &report, &second_tick, 0u);
    if (status != ACTION_FAMILY28_OK) {
        *out_report = report;
        return status;
    }
    report.first_frame_elapsed_ms = second_tick - first_tick;
    selected_count = sequence_frame_count_raw(state->sequence_budget_ms,
                                               report.first_frame_elapsed_ms);
    executed_count = selected_count > 1 ? (uint32_t)selected_count : 1u;
    report.selected_frame_count = selected_count;
    report.planned_frame_count = executed_count;
    status = sequence_system_audio_pump(callbacks, &report, 0u);
    if (status != ACTION_FAMILY28_OK) {
        *out_report = report;
        return status;
    }

    for (frame_index = 1u; frame_index < executed_count; ++frame_index) {
        double weight;
        if (state->subtype >= 1u && state->subtype <= 3u) {
            status = action_family28_sequence_weight_for_cw(frame_index,
                executed_count, x87_control_word, &weight);
            if (status != ACTION_FAMILY28_OK) {
                *out_report = report;
                return status;
            }
        } else {
            /* 0x44753b skips the curve branch outside subtypes 1..3, leaving
             * the stack-initialized weight 0.0 in place for later frames. */
            weight = 0.0;
        }
        status = sequence_blend_present(state, callbacks, &report, frame_index,
                                        weight, x87_control_word);
        if (status != ACTION_FAMILY28_OK) {
            *out_report = report;
            return status;
        }
        status = sequence_system_audio_pump(callbacks, &report, frame_index);
        if (status != ACTION_FAMILY28_OK) {
            *out_report = report;
            return status;
        }
    }

    if (state->subtype == 1u || state->subtype == 3u) {
        status = sequence_get_tick(callbacks, &report, &now, UINT32_MAX);
        if (status != ACTION_FAMILY28_OK) {
            *out_report = report;
            return status;
        }
        deadline = now + (uint32_t)(int32_t)state->pause_ms;
        for (;;) {
            status = sequence_get_tick(callbacks, &report, &now, UINT32_MAX);
            if (status != ACTION_FAMILY28_OK) {
                *out_report = report;
                return status;
            }
            if (now >= deadline) {
                break;
            }
            status = sequence_system_audio_pump(callbacks, &report, UINT32_MAX);
            if (status != ACTION_FAMILY28_OK) {
                *out_report = report;
                return status;
            }
        }
    }

    /* The original completion helper stores both globals before the subtype
     * branch, then writes the branch-specific object/world state. */
    state->finalizer_global_5831c8 = 1u;
    state->finalizer_global_5831c6 = 0u;
    if (state->subtype == 3u) {
        ActionFamily28Capture temporary = state->source_capture;
        state->source_capture = state->destination_capture;
        state->destination_capture = temporary;
        state->stage = 1u;
        if (state->scene_state == 4u) {
            state->scene_state = 1u;
        }
    } else {
        state->busy = 0u;
        state->render_guard = 0u;
        state->redraw_flag = 1u;
    }
    report.completion_committed = 1u;
    *out_report = report;
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
