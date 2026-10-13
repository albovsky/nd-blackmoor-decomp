#include "action_family28_surface.h"

#include <math.h>
#include <stdlib.h>
#include <string.h>

static int checked_mul_size(size_t left, size_t right, size_t *out)
{
    if (out == NULL || (right != 0u && left > SIZE_MAX / right)) {
        return 0;
    }
    *out = left * right;
    return 1;
}

static int checked_add_size(size_t left, size_t right, size_t *out)
{
    if (out == NULL || left > SIZE_MAX - right) {
        return 0;
    }
    *out = left + right;
    return 1;
}

static uint16_t read_u16_le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static void write_u16_le(uint8_t *bytes, uint16_t value)
{
    bytes[0] = (uint8_t)value;
    bytes[1] = (uint8_t)(value >> 8);
}

static uint32_t read_u32_le(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] |
           ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) |
           ((uint32_t)bytes[3] << 24);
}

static void write_u32_le(uint8_t *bytes, uint32_t value)
{
    bytes[0] = (uint8_t)value;
    bytes[1] = (uint8_t)(value >> 8);
    bytes[2] = (uint8_t)(value >> 16);
    bytes[3] = (uint8_t)(value >> 24);
}

static int byte_spans_overlap(const void *left,
                              size_t left_size,
                              const void *right,
                              size_t right_size,
                              int *out_overlap)
{
    uintptr_t left_begin;
    uintptr_t right_begin;
    uintptr_t left_end;
    uintptr_t right_end;

    if (out_overlap == NULL) {
        return 0;
    }
    *out_overlap = 0;
    if (left_size == 0u || right_size == 0u) {
        return 1;
    }
    if (left == NULL || right == NULL) {
        return 0;
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

static int checked_surface_region(const ActionFamily28PrimarySurface *surface,
                                  const ActionFamily28Rect *rect,
                                  int require_primary,
                                  size_t *out_x,
                                  size_t *out_y,
                                  size_t *out_width,
                                  size_t *out_height)
{
    size_t row_bytes;
    size_t last_row_offset;
    size_t required_bytes;
    int64_t surface_right;
    int64_t surface_bottom;
    int64_t rect_width;
    int64_t rect_height;
    int64_t x;
    int64_t y;
    uint64_t coordinate_width;
    uint64_t coordinate_height;

    if (surface == NULL || rect == NULL || out_x == NULL || out_y == NULL ||
        out_width == NULL || out_height == NULL) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    if (surface->pixels == NULL || surface->width == 0u ||
        surface->height == 0u) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    /* Rectangles use signed 32-bit coordinates. Bound each dimension by the
     * remaining coordinate span before converting size_t to int64_t. */
    coordinate_width = (uint64_t)((int64_t)INT32_MAX -
                                  (int64_t)surface->origin_x) + 1u;
    coordinate_height = (uint64_t)((int64_t)INT32_MAX -
                                   (int64_t)surface->origin_y) + 1u;
    if (surface->width > coordinate_width ||
        surface->height > coordinate_height) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    if (surface->storage_lifetime != ACTION_FAMILY28_STORAGE_CALLER_OWNED) {
        return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }
    if (surface->format != ACTION_FAMILY28_SURFACE_RGB565_LE ||
        surface->scope != ACTION_FAMILY28_SURFACE_DECODED_BACKGROUND_ONLY) {
        return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }
    if (require_primary && surface->primary_target == 0u) {
        return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }
    if (surface->channel_shifts[0] != 11u ||
        surface->channel_shifts[1] != 5u ||
        surface->channel_shifts[2] != 0u ||
        surface->channel_masks[0] != 31u ||
        surface->channel_masks[1] != 63u ||
        surface->channel_masks[2] != 31u) {
        return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }
    if (!checked_mul_size(surface->width, 2u, &row_bytes) ||
        surface->pitch_bytes < row_bytes ||
        !checked_mul_size(surface->height - 1u, surface->pitch_bytes,
                          &last_row_offset) ||
        !checked_add_size(last_row_offset, row_bytes, &required_bytes) ||
        required_bytes > surface->byte_length) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }

    surface_right = (int64_t)surface->origin_x + (int64_t)surface->width - 1;
    surface_bottom = (int64_t)surface->origin_y + (int64_t)surface->height - 1;
    if (surface_right > INT32_MAX || surface_bottom > INT32_MAX ||
        surface_right < INT32_MIN || surface_bottom < INT32_MIN) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    if (rect->right < rect->left || rect->bottom < rect->top ||
        rect->left < surface->origin_x || rect->top < surface->origin_y ||
        (int64_t)rect->right > surface_right ||
        (int64_t)rect->bottom > surface_bottom) {
        return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }

    x = (int64_t)rect->left - surface->origin_x;
    y = (int64_t)rect->top - surface->origin_y;
    rect_width = (int64_t)rect->right - rect->left + 1;
    rect_height = (int64_t)rect->bottom - rect->top + 1;
    if (x < 0 || y < 0 || rect_width <= 0 || rect_height <= 0 ||
        (uint64_t)x > SIZE_MAX || (uint64_t)y > SIZE_MAX ||
        (uint64_t)rect_width > SIZE_MAX || (uint64_t)rect_height > SIZE_MAX) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    *out_x = (size_t)x;
    *out_y = (size_t)y;
    *out_width = (size_t)rect_width;
    *out_height = (size_t)rect_height;
    return ACTION_FAMILY28_SURFACE_OK;
}

static int validate_capture(const ActionFamily28WordCapture *capture,
                            const ActionFamily28PrimarySurface *surface,
                            size_t rect_width,
                            size_t rect_height)
{
    size_t minimum_bytes;
    size_t right;
    size_t bottom;
    int status;

    if (capture == NULL || surface == NULL || capture->bytes == NULL ||
        capture->width == 0u || capture->height == 0u) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    if (capture->storage_lifetime != ACTION_FAMILY28_STORAGE_CALLER_OWNED) {
        return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }
    if (capture->width != surface->width ||
        capture->height != surface->height ||
        capture->stride_pixels < capture->width) {
        return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }
    if (!checked_add_size(capture->offset_x, rect_width, &right) ||
        !checked_add_size(capture->offset_y, rect_height, &bottom) ||
        right > capture->width || bottom > capture->height) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    status = action_family28_capture_required_bytes(capture->width,
        capture->height, capture->stride_pixels, &minimum_bytes);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }
    return capture->byte_length < minimum_bytes ?
        ACTION_FAMILY28_SURFACE_ERR_BOUNDS : ACTION_FAMILY28_SURFACE_OK;
}

int action_family28_surface_from_rgba_rect(const BinkPlayerFrame *frame,
                                      size_t source_x,
                                      size_t source_y,
                                      size_t width,
                                      size_t height,
                                      uint8_t *rgb565,
                                      size_t output_capacity,
                                      int32_t origin_x,
                                      int32_t origin_y,
                                      ActionFamily28PrimarySurface *out_surface)
{
    ActionFamily28PrimarySurface surface;
    size_t rgba_row_bytes;
    size_t rgba_last_row;
    size_t rgba_required;
    size_t source_right;
    size_t source_bottom;
    size_t pixels;
    size_t output_bytes;
    int overlaps;
    int metadata_overlap;
    size_t y;

    if (frame == NULL || out_surface == NULL || frame->rgba == NULL ||
        rgb565 == NULL || frame->width == 0u || frame->height == 0u ||
        width == 0u || height == 0u) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    if (!checked_mul_size((size_t)frame->width, 4u, &rgba_row_bytes) ||
        frame->stride < rgba_row_bytes ||
        !checked_mul_size((size_t)(frame->height - 1u), frame->stride,
                          &rgba_last_row) ||
        !checked_add_size(rgba_last_row, rgba_row_bytes, &rgba_required) ||
        rgba_required > frame->rgba_bytes ||
        !checked_add_size(source_x, width, &source_right) ||
        !checked_add_size(source_y, height, &source_bottom) ||
        source_right > (size_t)frame->width ||
        source_bottom > (size_t)frame->height ||
        !checked_mul_size(width, height,
                          &pixels) ||
        !checked_mul_size(pixels, 2u, &output_bytes) ||
        output_capacity < output_bytes) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    if ((int64_t)origin_x + (int64_t)width - 1 > INT32_MAX ||
        (int64_t)origin_y + (int64_t)height - 1 > INT32_MAX) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    if (!byte_spans_overlap(frame->rgba, rgba_required, rgb565,
                            output_bytes, &overlaps) || overlaps) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    if (!byte_spans_overlap(frame, sizeof(*frame), rgb565, output_bytes,
                            &metadata_overlap) || metadata_overlap ||
        !byte_spans_overlap(out_surface, sizeof(*out_surface), rgb565,
                            output_bytes, &metadata_overlap) || metadata_overlap ||
        !byte_spans_overlap(frame, sizeof(*frame), out_surface,
                            sizeof(*out_surface), &metadata_overlap) || metadata_overlap ||
        !byte_spans_overlap(frame->rgba, rgba_required, out_surface,
                            sizeof(*out_surface), &metadata_overlap) || metadata_overlap) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }

    memset(&surface, 0, sizeof(surface));
    surface.pixels = rgb565;
    surface.byte_length = output_bytes;
    surface.width = width;
    surface.height = height;
    surface.pitch_bytes = width * 2u;
    surface.origin_x = origin_x;
    surface.origin_y = origin_y;
    surface.channel_shifts[0] = 11u;
    surface.channel_shifts[1] = 5u;
    surface.channel_shifts[2] = 0u;
    surface.channel_masks[0] = 31u;
    surface.channel_masks[1] = 63u;
    surface.channel_masks[2] = 31u;
    surface.format = ACTION_FAMILY28_SURFACE_RGB565_LE;
    surface.scope = ACTION_FAMILY28_SURFACE_DECODED_BACKGROUND_ONLY;
    surface.primary_target = 1u;
    surface.storage_lifetime = ACTION_FAMILY28_STORAGE_CALLER_OWNED;

    for (y = 0u; y < height; ++y) {
        const uint8_t *input = frame->rgba + (source_y + y) * frame->stride +
                               source_x * 4u;
        uint8_t *output = rgb565 + y * surface.pitch_bytes;
        size_t x;
        for (x = 0u; x < width; ++x) {
            uint16_t packed = (uint16_t)(((uint16_t)(input[x * 4u] >> 3) << 11) |
                ((uint16_t)(input[x * 4u + 1u] >> 2) << 5) |
                (uint16_t)(input[x * 4u + 2u] >> 3));
            write_u16_le(output + x * 2u, packed);
        }
    }
    *out_surface = surface;
    return ACTION_FAMILY28_SURFACE_OK;
}

int action_family28_surface_from_rgba(const BinkPlayerFrame *frame,
                                      uint8_t *rgb565,
                                      size_t output_capacity,
                                      int32_t origin_x,
                                      int32_t origin_y,
                                      ActionFamily28PrimarySurface *out_surface)
{
    if (frame == NULL) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    return action_family28_surface_from_rgba_rect(frame, 0u, 0u,
        frame->width, frame->height, rgb565, output_capacity,
        origin_x, origin_y, out_surface);
}

int action_family28_capture_required_bytes(size_t width,
                                          size_t height,
                                          size_t stride_pixels,
                                          size_t *out_bytes)
{
    size_t row_bytes;
    size_t byte_count;

    if (out_bytes == NULL || width == 0u || height == 0u) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    if (stride_pixels < width ||
        !checked_mul_size(stride_pixels, ACTION_FAMILY28_CAPTURE_BYTES_PER_PIXEL,
                          &row_bytes) ||
        !checked_mul_size(height, row_bytes, &byte_count)) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    *out_bytes = byte_count;
    return ACTION_FAMILY28_SURFACE_OK;
}

int action_family28_surface_capture_words_at(
    const ActionFamily28PrimarySurface *surface,
    const ActionFamily28Rect *target_rect,
    size_t capture_offset_x,
    size_t capture_offset_y,
    ActionFamily28WordCapture *capture)
{
    ActionFamily28WordCapture capture_view;
    size_t rect_x;
    size_t rect_y;
    size_t rect_width;
    size_t rect_height;
    size_t required_bytes;
    size_t row;
    int overlaps;
    int metadata_overlap;
    int status;

    if (capture == NULL) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    status = checked_surface_region(surface, target_rect, 0, &rect_x, &rect_y,
                                    &rect_width, &rect_height);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }
    (void)rect_x;
    (void)rect_y;
    capture_view = *capture;
    capture_view.offset_x = capture_offset_x;
    capture_view.offset_y = capture_offset_y;
    status = validate_capture(&capture_view, surface, rect_width, rect_height);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }
    if (capture_offset_x > capture->width ||
        rect_width > capture->width - capture_offset_x ||
        capture_offset_y > capture->height ||
        rect_height > capture->height - capture_offset_y) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    status = action_family28_capture_required_bytes(capture->width,
        capture->height, capture->stride_pixels, &required_bytes);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }
    if (!byte_spans_overlap(surface->pixels, surface->byte_length,
                            capture->bytes, required_bytes, &overlaps) ||
        overlaps ||
        !byte_spans_overlap(capture->bytes, required_bytes, capture,
                            sizeof(*capture), &metadata_overlap) || metadata_overlap ||
        !byte_spans_overlap(capture->bytes, required_bytes, surface,
                            sizeof(*surface), &metadata_overlap) || metadata_overlap ||
        !byte_spans_overlap(capture->bytes, required_bytes, target_rect,
                            sizeof(*target_rect), &metadata_overlap) || metadata_overlap) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }

    /* The effect's destination rectangle and its source capture crop are
     * separate original fields. Commit the shared source origin only after
     * every input span has validated. */
    capture->offset_x = capture_offset_x;
    capture->offset_y = capture_offset_y;
    for (row = 0u; row < surface->height; ++row) {
        const uint8_t *input = surface->pixels + row * surface->pitch_bytes;
        size_t column;
        for (column = 0u; column < surface->width; ++column) {
            uint16_t packed = read_u16_le(input + column * 2u);
            size_t pixel_index = row * capture->stride_pixels + column;
            uint8_t *words = capture->bytes +
                pixel_index * ACTION_FAMILY28_CAPTURE_BYTES_PER_PIXEL;
            size_t channel;
            for (channel = 0u; channel < 3u; ++channel) {
                uint32_t value = (uint32_t)(packed >> surface->channel_shifts[channel]) &
                                 surface->channel_masks[channel];
                write_u32_le(words + channel * 4u, value);
            }
        }
    }
    return ACTION_FAMILY28_SURFACE_OK;
}

int action_family28_surface_capture_words(
    const ActionFamily28PrimarySurface *surface,
    const ActionFamily28Rect *target_rect,
    ActionFamily28WordCapture *capture)
{
    size_t rect_x;
    size_t rect_y;
    size_t rect_width;
    size_t rect_height;
    int status;

    status = checked_surface_region(surface, target_rect, 0, &rect_x, &rect_y,
                                    &rect_width, &rect_height);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }
    (void)rect_width;
    (void)rect_height;
    return action_family28_surface_capture_words_at(surface, target_rect,
        rect_x, rect_y, capture);
}

int action_family28_surface_blend_present_words(
    ActionFamily28PrimarySurface *surface,
    const ActionFamily28Rect *target_rect,
    const ActionFamily28WordCapture *source,
    const ActionFamily28WordCapture *target,
    double weight,
    uint16_t x87_control_word,
    uint8_t present_primary)
{
    uint8_t *source_rgb = NULL;
    uint8_t *target_rgb = NULL;
    uint16_t *output = NULL;
    size_t rect_x;
    size_t rect_y;
    size_t rect_width;
    size_t rect_height;
    size_t pixel_count;
    size_t rgb_bytes;
    size_t output_bytes;
    size_t capture_bytes;
    int source_target_overlap;
    int surface_source_overlap;
    int surface_target_overlap;
    int metadata_overlap;
    size_t row;
    int status;

    if (source == NULL || target == NULL || !isfinite(weight) ||
        weight < 0.0 || weight > 1.0) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    if (present_primary == 0u) {
        return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }
    status = checked_surface_region(surface, target_rect, 1, &rect_x, &rect_y,
                                    &rect_width, &rect_height);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }
    status = validate_capture(source, surface, rect_width, rect_height);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }
    status = validate_capture(target, surface, rect_width, rect_height);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }
    if (source->stride_pixels != target->stride_pixels) {
        return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }
    status = action_family28_capture_required_bytes(source->width,
        source->height, source->stride_pixels, &capture_bytes);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }
    if (!byte_spans_overlap(source->bytes, capture_bytes,
                            target->bytes, capture_bytes,
                            &source_target_overlap) || source_target_overlap ||
        !byte_spans_overlap(surface->pixels, surface->byte_length,
                            source->bytes, capture_bytes,
                            &surface_source_overlap) || surface_source_overlap ||
        !byte_spans_overlap(surface->pixels, surface->byte_length,
                            target->bytes, capture_bytes,
                            &surface_target_overlap) || surface_target_overlap) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    if (!byte_spans_overlap(surface->pixels, surface->byte_length,
                            surface, sizeof(*surface), &metadata_overlap) || metadata_overlap ||
        !byte_spans_overlap(surface->pixels, surface->byte_length,
                            target_rect, sizeof(*target_rect), &metadata_overlap) || metadata_overlap ||
        !byte_spans_overlap(surface->pixels, surface->byte_length,
                            source, sizeof(*source), &metadata_overlap) || metadata_overlap ||
        !byte_spans_overlap(surface->pixels, surface->byte_length,
                            target, sizeof(*target), &metadata_overlap) || metadata_overlap) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    if (!checked_mul_size(rect_width, rect_height, &pixel_count) ||
        !checked_mul_size(pixel_count, 3u, &rgb_bytes) ||
        !checked_mul_size(pixel_count, sizeof(*output), &output_bytes)) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }

    source_rgb = (uint8_t *)malloc(rgb_bytes);
    target_rgb = (uint8_t *)malloc(rgb_bytes);
    output = (uint16_t *)malloc(output_bytes);
    if (source_rgb == NULL || target_rgb == NULL || output == NULL) {
        free(source_rgb);
        free(target_rgb);
        free(output);
        return ACTION_FAMILY28_SURFACE_ERR_MEMORY;
    }

    for (row = 0u; row < rect_height; ++row) {
        size_t column;
        for (column = 0u; column < rect_width; ++column) {
            size_t capture_pixel =
                (source->offset_y + row) * source->stride_pixels +
                source->offset_x + column;
            const uint8_t *source_words = source->bytes +
                capture_pixel * ACTION_FAMILY28_CAPTURE_BYTES_PER_PIXEL;
            const uint8_t *target_words = target->bytes +
                capture_pixel * ACTION_FAMILY28_CAPTURE_BYTES_PER_PIXEL;
            size_t rgb_pixel = (row * rect_width + column) * 3u;
            size_t channel;
            for (channel = 0u; channel < 3u; ++channel) {
                uint32_t first = read_u32_le(source_words + channel * 4u);
                uint32_t second = read_u32_le(target_words + channel * 4u);
                uint32_t mask = surface->channel_masks[channel];
                if (first > mask || second > mask) {
                    free(source_rgb);
                    free(target_rgb);
                    free(output);
                    return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
                }
                source_rgb[rgb_pixel + channel] = (uint8_t)first;
                target_rgb[rgb_pixel + channel] = (uint8_t)second;
            }
        }
    }

    status = action_family28_blend_pixels_for_cw(source_rgb, target_rgb,
        pixel_count, weight, x87_control_word, surface->channel_shifts,
        output, pixel_count);
    free(source_rgb);
    free(target_rgb);
    if (status != ACTION_FAMILY28_OK) {
        free(output);
        return status == ACTION_FAMILY28_ERR_UNSUPPORTED ?
            ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED :
            status == ACTION_FAMILY28_ERR_MEMORY ? ACTION_FAMILY28_SURFACE_ERR_MEMORY :
            status == ACTION_FAMILY28_ERR_BOUNDS ? ACTION_FAMILY28_SURFACE_ERR_BOUNDS :
                                                   ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }

    for (row = 0u; row < rect_height; ++row) {
        uint8_t *surface_row = surface->pixels +
            (rect_y + row) * surface->pitch_bytes + rect_x * 2u;
        size_t column;
        for (column = 0u; column < rect_width; ++column) {
            write_u16_le(surface_row + column * 2u,
                output[row * rect_width + column]);
        }
    }
    free(output);
    return ACTION_FAMILY28_SURFACE_OK;
}

typedef struct action_family28_surface_sequence_bridge {
    ActionFamily28PrimarySurface *surface;
    const ActionFamily28SurfaceSequenceCallbacks *callbacks;
    ActionFamily28SurfaceSequenceReport *report;
} ActionFamily28SurfaceSequenceBridge;

static int surface_sequence_tick(void *context, uint32_t *out_tick_count)
{
    ActionFamily28SurfaceSequenceBridge *bridge =
        (ActionFamily28SurfaceSequenceBridge *)context;
    int status;

    if (bridge == NULL || bridge->callbacks == NULL ||
        bridge->callbacks->get_tick_count == NULL) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    status = bridge->callbacks->get_tick_count(bridge->callbacks->context,
                                                out_tick_count);
    if (status != 0) {
        bridge->report->failed_operation =
            ACTION_FAMILY28_SURFACE_SEQUENCE_OP_TICK;
        bridge->report->callback_status = status;
    }
    return status;
}

static int surface_sequence_blend_present(
    void *context, const ActionFamily28SequenceFrame *frame)
{
    ActionFamily28SurfaceSequenceBridge *bridge =
        (ActionFamily28SurfaceSequenceBridge *)context;
    ActionFamily28WordCapture source;
    ActionFamily28WordCapture destination;
    int status;

    if (bridge == NULL || bridge->surface == NULL || bridge->callbacks == NULL ||
        bridge->report == NULL || frame == NULL) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    bridge->report->blend_attempts += 1u;
    memset(&source, 0, sizeof(source));
    source.bytes = (uint8_t *)(uintptr_t)frame->source_capture.data;
    source.byte_length = frame->source_capture.byte_length;
    source.width = frame->capture_width_pixels;
    source.height = frame->capture_height_pixels;
    source.stride_pixels = frame->capture_stride_pixels;
    source.offset_x = frame->capture_offset_x_pixels;
    source.offset_y = frame->capture_offset_y_pixels;
    source.storage_lifetime = ACTION_FAMILY28_STORAGE_CALLER_OWNED;
    memset(&destination, 0, sizeof(destination));
    destination.bytes = (uint8_t *)(uintptr_t)frame->destination_capture.data;
    destination.byte_length = frame->destination_capture.byte_length;
    destination.width = frame->capture_width_pixels;
    destination.height = frame->capture_height_pixels;
    destination.stride_pixels = frame->capture_stride_pixels;
    destination.offset_x = frame->capture_offset_x_pixels;
    destination.offset_y = frame->capture_offset_y_pixels;
    destination.storage_lifetime = ACTION_FAMILY28_STORAGE_CALLER_OWNED;

    status = action_family28_surface_blend_present_words(bridge->surface,
        &frame->target_rect, &source, &destination, frame->weight,
        frame->x87_control_word, frame->primary_target);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        bridge->report->failed_operation =
            ACTION_FAMILY28_SURFACE_SEQUENCE_OP_BLEND;
        bridge->report->callback_status = status;
        return status;
    }
    bridge->report->blend_successes += 1u;

    if (frame->primary_target != 0u) {
        bridge->report->present_attempts += 1u;
        status = bridge->callbacks->present_primary(bridge->callbacks->context,
            bridge->surface, frame->frame_index);
        if (status != 0) {
            bridge->report->failed_operation =
                ACTION_FAMILY28_SURFACE_SEQUENCE_OP_PRESENT;
            bridge->report->callback_status = status;
            return status;
        }
        bridge->report->present_successes += 1u;
    }

    bridge->report->graphics_tail_pump_attempts += 1u;
    status = bridge->callbacks->graphics_tail_pump(
        bridge->callbacks->context, frame->frame_index);
    if (status != 0) {
        bridge->report->failed_operation =
            ACTION_FAMILY28_SURFACE_SEQUENCE_OP_GRAPHICS_TAIL_PUMP;
        bridge->report->callback_status = status;
        return status;
    }
    bridge->report->graphics_tail_pump_successes += 1u;
    return 0;
}

static int surface_sequence_audio_pump(void *context)
{
    ActionFamily28SurfaceSequenceBridge *bridge =
        (ActionFamily28SurfaceSequenceBridge *)context;
    int status;

    if (bridge == NULL || bridge->callbacks == NULL || bridge->report == NULL ||
        bridge->callbacks->system_audio_pump == NULL) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    bridge->report->system_audio_pump_attempts += 1u;
    status = bridge->callbacks->system_audio_pump(bridge->callbacks->context);
    if (status != 0) {
        bridge->report->failed_operation =
            ACTION_FAMILY28_SURFACE_SEQUENCE_OP_SYSTEM_AUDIO_PUMP;
        bridge->report->callback_status = status;
        return status;
    }
    bridge->report->system_audio_pump_successes += 1u;
    return 0;
}

static int disjoint_spans(const void *first, size_t first_size,
                          const void *second, size_t second_size)
{
    int overlaps;
    return byte_spans_overlap(first, first_size, second, second_size,
                               &overlaps) && !overlaps;
}

static int map_controller_status(int status)
{
    switch (status) {
    case ACTION_FAMILY28_OK: return ACTION_FAMILY28_SURFACE_OK;
    case ACTION_FAMILY28_ERR_ARGUMENT: return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    case ACTION_FAMILY28_ERR_BOUNDS: return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    case ACTION_FAMILY28_ERR_MEMORY: return ACTION_FAMILY28_SURFACE_ERR_MEMORY;
    case ACTION_FAMILY28_ERR_CALLBACK: return ACTION_FAMILY28_SURFACE_ERR_CALLBACK;
    default: return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }
}

int action_family28_surface_run_sequence(
    ActionFamily28PrimarySurface *surface,
    ActionFamily28SequenceState *state,
    const ActionFamily28SurfaceSequenceCallbacks *callbacks,
    uint16_t x87_control_word,
    ActionFamily28SurfaceSequenceReport *out_report)
{
    ActionFamily28SurfaceSequenceReport report;
    ActionFamily28SequenceCallbacks controller_callbacks;
    ActionFamily28SurfaceSequenceBridge bridge;
    ActionFamily28WordCapture source;
    ActionFamily28WordCapture destination;
    size_t rect_x;
    size_t rect_y;
    size_t rect_width;
    size_t rect_height;
    size_t capture_bytes;
    int controller_status;
    int status;

    if (surface == NULL || state == NULL || callbacks == NULL || out_report == NULL ||
        callbacks->get_tick_count == NULL || callbacks->present_primary == NULL ||
        callbacks->graphics_tail_pump == NULL ||
        callbacks->system_audio_pump == NULL) {
        return ACTION_FAMILY28_SURFACE_ERR_ARGUMENT;
    }
    if (state->primary_target != 1u) {
        return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }
    status = checked_surface_region(surface, &state->target_rect, 1,
                                    &rect_x, &rect_y,
                                    &rect_width, &rect_height);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }
    if (state->capture_width_pixels != surface->width ||
        state->capture_height_pixels != surface->height ||
        state->capture_stride_pixels != surface->width) {
        return ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED;
    }
    if (!checked_mul_size(surface->width, surface->height, &capture_bytes) ||
        !checked_mul_size(capture_bytes,
                          ACTION_FAMILY28_CAPTURE_BYTES_PER_PIXEL,
                          &capture_bytes)) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }
    memset(&source, 0, sizeof(source));
    source.bytes = (uint8_t *)(uintptr_t)state->source_capture.data;
    source.byte_length = state->source_capture.byte_length;
    source.width = state->capture_width_pixels;
    source.height = state->capture_height_pixels;
    source.stride_pixels = state->capture_stride_pixels;
    source.offset_x = state->capture_offset_x_pixels;
    source.offset_y = state->capture_offset_y_pixels;
    source.storage_lifetime = ACTION_FAMILY28_STORAGE_CALLER_OWNED;
    memset(&destination, 0, sizeof(destination));
    destination.bytes = (uint8_t *)(uintptr_t)state->destination_capture.data;
    destination.byte_length = state->destination_capture.byte_length;
    destination.width = state->capture_width_pixels;
    destination.height = state->capture_height_pixels;
    destination.stride_pixels = state->capture_stride_pixels;
    destination.offset_x = state->capture_offset_x_pixels;
    destination.offset_y = state->capture_offset_y_pixels;
    destination.storage_lifetime = ACTION_FAMILY28_STORAGE_CALLER_OWNED;
    status = validate_capture(&source, surface, rect_width, rect_height);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }
    status = validate_capture(&destination, surface, rect_width, rect_height);
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        return status;
    }

    /* Reject aliasing before the first tick or surface write. The controller
     * also validates capture spans, but this adapter adds the primary surface
     * and its own descriptors to that atomic preflight. */
    if (!disjoint_spans(surface->pixels, surface->byte_length, surface,
                        sizeof(*surface)) ||
        !disjoint_spans(surface->pixels, surface->byte_length, state,
                        sizeof(*state)) ||
        !disjoint_spans(surface->pixels, surface->byte_length, callbacks,
                        sizeof(*callbacks)) ||
        !disjoint_spans(surface->pixels, surface->byte_length, out_report,
                        sizeof(*out_report)) ||
        !disjoint_spans(surface->pixels, surface->byte_length,
                        state->source_capture.data, capture_bytes) ||
        !disjoint_spans(surface->pixels, surface->byte_length,
                        state->destination_capture.data, capture_bytes) ||
        !disjoint_spans(state->source_capture.data, capture_bytes,
                        state->destination_capture.data, capture_bytes) ||
        !disjoint_spans(state->source_capture.data, capture_bytes, state,
                        sizeof(*state)) ||
        !disjoint_spans(state->destination_capture.data, capture_bytes, state,
                        sizeof(*state)) ||
        !disjoint_spans(state->source_capture.data, capture_bytes, surface,
                        sizeof(*surface)) ||
        !disjoint_spans(state->destination_capture.data, capture_bytes, surface,
                        sizeof(*surface)) ||
        !disjoint_spans(state->source_capture.data, capture_bytes, out_report,
                        sizeof(*out_report)) ||
        !disjoint_spans(state->destination_capture.data, capture_bytes,
                        out_report, sizeof(*out_report)) ||
        !disjoint_spans(state, sizeof(*state), out_report, sizeof(*out_report)) ||
        !disjoint_spans(surface, sizeof(*surface), out_report,
                        sizeof(*out_report)) ||
        !disjoint_spans(surface, sizeof(*surface), state, sizeof(*state)) ||
        !disjoint_spans(surface, sizeof(*surface), callbacks,
                        sizeof(*callbacks)) ||
        !disjoint_spans(state, sizeof(*state), callbacks,
                        sizeof(*callbacks)) ||
        !disjoint_spans(callbacks, sizeof(*callbacks), out_report,
                        sizeof(*out_report))) {
        return ACTION_FAMILY28_SURFACE_ERR_BOUNDS;
    }

    memset(&report, 0, sizeof(report));
    bridge.surface = surface;
    bridge.callbacks = callbacks;
    bridge.report = &report;
    controller_callbacks.context = &bridge;
    controller_callbacks.get_tick_count = surface_sequence_tick;
    controller_callbacks.blend_present = surface_sequence_blend_present;
    controller_callbacks.system_audio_pump = surface_sequence_audio_pump;
    controller_status = action_family28_run_sequence(state,
        &controller_callbacks, x87_control_word, &report.controller);
    report.controller_status = controller_status;
    if (controller_status != ACTION_FAMILY28_OK &&
        report.failed_operation == ACTION_FAMILY28_SURFACE_SEQUENCE_OP_NONE) {
        report.failed_operation = ACTION_FAMILY28_SURFACE_SEQUENCE_OP_CONTROLLER;
        report.callback_status = controller_status;
    }
    if (report.controller.get_tick_calls != 0u ||
        report.controller.blend_present_calls != 0u ||
        report.controller.system_audio_pump_calls != 0u) {
        *out_report = report;
    }
    if (controller_status == ACTION_FAMILY28_OK) {
        return ACTION_FAMILY28_SURFACE_OK;
    }
    return map_controller_status(controller_status);
}

const char *action_family28_surface_status_string(int status)
{
    switch (status) {
    case ACTION_FAMILY28_SURFACE_OK: return "ok";
    case ACTION_FAMILY28_SURFACE_ERR_ARGUMENT: return "invalid surface adapter argument";
    case ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED: return "unsupported surface geometry or scope";
    case ACTION_FAMILY28_SURFACE_ERR_BOUNDS: return "surface adapter span is out of bounds";
    case ACTION_FAMILY28_SURFACE_ERR_MEMORY: return "surface adapter allocation failed";
    case ACTION_FAMILY28_SURFACE_ERR_CALLBACK: return "surface adapter callback failed";
    default: return "unknown surface adapter status";
    }
}
