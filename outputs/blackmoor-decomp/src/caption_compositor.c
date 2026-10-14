#include "caption_compositor.h"

#include <limits.h>
#include <string.h>

static int view_span(const CaptionCompositorView *view, size_t *span_out)
{
    size_t row_bytes;
    size_t preceding_rows;
    size_t span;

    if (view == NULL || span_out == NULL || view->pixels == NULL ||
        view->width <= 0 || view->height <= 0 || view->pitch_bytes == 0) {
        return CAPTION_COMPOSITOR_ERR_ARGUMENT;
    }
    if (view->pitch_bytes < 0) {
        return CAPTION_COMPOSITOR_ERR_UNSUPPORTED;
    }
    if (view->format != CAPTION_COMPOSITOR_RGB555_LE &&
        view->format != CAPTION_COMPOSITOR_RGB565_LE) {
        return CAPTION_COMPOSITOR_ERR_UNSUPPORTED;
    }
    if ((size_t)view->width > SIZE_MAX / 2u) {
        return CAPTION_COMPOSITOR_ERR_BOUNDS;
    }
    row_bytes = (size_t)view->width * 2u;
    if ((size_t)view->pitch_bytes < row_bytes) {
        return CAPTION_COMPOSITOR_ERR_BOUNDS;
    }
    if ((size_t)(view->height - 1) > SIZE_MAX / (size_t)view->pitch_bytes) {
        return CAPTION_COMPOSITOR_ERR_BOUNDS;
    }
    preceding_rows = (size_t)(view->height - 1) * (size_t)view->pitch_bytes;
    if (preceding_rows > SIZE_MAX - row_bytes) {
        return CAPTION_COMPOSITOR_ERR_BOUNDS;
    }
    span = preceding_rows + row_bytes;
    if (span > view->byte_capacity) {
        return CAPTION_COMPOSITOR_ERR_BOUNDS;
    }
    *span_out = span;
    return CAPTION_COMPOSITOR_OK;
}

static int validate_rect(const CaptionCompositorView *view,
                         const CaptionRect *rect,
                         size_t *row_bytes_out,
                         size_t *column_bytes_out)
{
    int64_t width;
    int64_t height;
    size_t row_bytes;
    size_t column_bytes;

    if (rect == NULL) {
        return CAPTION_COMPOSITOR_ERR_ARGUMENT;
    }
    width = (int64_t)rect->right - (int64_t)rect->left + 1;
    height = (int64_t)rect->bottom - (int64_t)rect->top + 1;
    if (width <= 0 || height <= 0 || rect->left < 0 || rect->top < 0 ||
        rect->right >= view->width || rect->bottom >= view->height) {
        return CAPTION_COMPOSITOR_ERR_BOUNDS;
    }
    if ((uint64_t)width > SIZE_MAX / 2u || (uint64_t)rect->left > SIZE_MAX / 2u) {
        return CAPTION_COMPOSITOR_ERR_BOUNDS;
    }
    row_bytes = (size_t)width * 2u;
    column_bytes = (size_t)rect->left * 2u;
    *row_bytes_out = row_bytes;
    *column_bytes_out = column_bytes;
    return CAPTION_COMPOSITOR_OK;
}

int caption_compositor_format_from_pixel_format(const CaptionPixelFormat *pixel_format,
                                                CaptionCompositorFormat *format)
{
    if (pixel_format == NULL || format == NULL) {
        return CAPTION_COMPOSITOR_ERR_ARGUMENT;
    }
    if (pixel_format->shifts[0] == 0 && pixel_format->shifts[1] == 5 &&
        pixel_format->shifts[2] == 10 && pixel_format->channel_bits[0] == 5 &&
        pixel_format->channel_bits[1] == 5 && pixel_format->channel_bits[2] == 5 &&
        pixel_format->masks[0] == 31 && pixel_format->masks[1] == 31 &&
        pixel_format->masks[2] == 31) {
        *format = CAPTION_COMPOSITOR_RGB555_LE;
        return CAPTION_COMPOSITOR_OK;
    }
    if (pixel_format->shifts[0] == 0 && pixel_format->shifts[1] == 5 &&
        pixel_format->shifts[2] == 11 && pixel_format->channel_bits[0] == 5 &&
        pixel_format->channel_bits[1] == 6 && pixel_format->channel_bits[2] == 5 &&
        pixel_format->masks[0] == 31 && pixel_format->masks[1] == 63 &&
        pixel_format->masks[2] == 31) {
        *format = CAPTION_COMPOSITOR_RGB565_LE;
        return CAPTION_COMPOSITOR_OK;
    }
    return CAPTION_COMPOSITOR_ERR_UNSUPPORTED;
}

static uint16_t load_le16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | (uint16_t)((uint16_t)p[1] << 8));
}

static void store_le16(uint8_t *p, uint16_t word)
{
    p[0] = (uint8_t)word;
    p[1] = (uint8_t)(word >> 8);
}

int caption_compositor_blit(const CaptionCompositorView *source,
                            CaptionCompositorView *destination,
                            CaptionBlitKind kind,
                            const CaptionRect *source_rect,
                            const CaptionRect *destination_rect,
                            uint16_t raw_color_key)
{
    size_t source_span;
    size_t destination_span;
    size_t source_row_bytes;
    size_t source_column_bytes;
    int64_t source_height;
    int64_t copy_right;
    int64_t copy_bottom;
    int status;

    if (source == NULL || destination == NULL || source_rect == NULL ||
        destination_rect == NULL) {
        return CAPTION_COMPOSITOR_ERR_ARGUMENT;
    }
    if (kind != CAPTION_BLIT_OPAQUE && kind != CAPTION_BLIT_KEYED) {
        return CAPTION_COMPOSITOR_ERR_UNSUPPORTED;
    }
    status = view_span(source, &source_span);
    if (status != CAPTION_COMPOSITOR_OK) {
        return status;
    }
    status = view_span(destination, &destination_span);
    if (status != CAPTION_COMPOSITOR_OK) {
        return status;
    }
    (void)source_span;
    (void)destination_span;
    if (source->format != destination->format) {
        return CAPTION_COMPOSITOR_ERR_FORMAT;
    }
    status = validate_rect(source, source_rect, &source_row_bytes,
                           &source_column_bytes);
    if (status != CAPTION_COMPOSITOR_OK) {
        return status;
    }
    /* Release builds use only destination left/top. Its right/bottom are
     * consumed by a diagnostic equality gate in debug builds, not by the
     * transfer loop, so bounds-check the actual source-sized destination span. */
    if (destination_rect->left < 0 || destination_rect->top < 0) {
        return CAPTION_COMPOSITOR_ERR_BOUNDS;
    }
    source_height = (int64_t)source_rect->bottom - source_rect->top + 1;
    copy_right = (int64_t)destination_rect->left +
                 (int64_t)(source_row_bytes / 2u) - 1;
    copy_bottom = (int64_t)destination_rect->top + source_height - 1;
    if (copy_right >= destination->width || copy_bottom >= destination->height) {
        return CAPTION_COMPOSITOR_ERR_BOUNDS;
    }

    for (int64_t row = 0; row < source_height; ++row) {
        size_t src_offset = (size_t)(source_rect->top + row) *
                            (size_t)source->pitch_bytes + source_column_bytes;
        size_t dst_offset = (size_t)((int64_t)destination_rect->top + row) *
                            (size_t)destination->pitch_bytes +
                            (size_t)destination_rect->left * 2u;
        const uint8_t *src = source->pixels + src_offset;
        uint8_t *dst = destination->pixels + dst_offset;

        if (kind == CAPTION_BLIT_OPAQUE) {
            size_t offset = 0;
            while (source_row_bytes - offset >= 4u) {
                uint8_t chunk[4];
                memcpy(chunk, src + offset, sizeof(chunk));
                memcpy(dst + offset, chunk, sizeof(chunk));
                offset += sizeof(chunk);
            }
            for (size_t tail = source_row_bytes & 3u; tail != 0u; --tail) {
                uint8_t tail_byte = src[offset];
                dst[offset] = tail_byte;
                ++offset;
            }
        } else {
            for (size_t offset = 0; offset < source_row_bytes; offset += 2u) {
                uint16_t word = load_le16(src + offset);
                if (word != raw_color_key) {
                    store_le16(dst + offset, word);
                }
            }
        }
    }
    return CAPTION_COMPOSITOR_OK;
}

const char *caption_compositor_status_string(int status)
{
    switch (status) {
    case CAPTION_COMPOSITOR_OK: return "ok";
    case CAPTION_COMPOSITOR_ERR_ARGUMENT: return "invalid argument";
    case CAPTION_COMPOSITOR_ERR_FORMAT: return "pixel formats differ";
    case CAPTION_COMPOSITOR_ERR_BOUNDS: return "surface span or rectangle out of bounds";
    case CAPTION_COMPOSITOR_ERR_UNSUPPORTED: return "unsupported format or blit kind";
    default: return "unknown caption compositor status";
    }
}
