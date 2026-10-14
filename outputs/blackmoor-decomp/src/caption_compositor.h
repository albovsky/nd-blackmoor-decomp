#ifndef BLACKMOOR_CAPTION_COMPOSITOR_H
#define BLACKMOOR_CAPTION_COMPOSITOR_H

/* Bounded software transfer kernel for the caption-related back-buffer path.
 * Original entry points: 0x4c5377 (opaque) and 0x4c5d4b (colour keyed).
 * The 16-bit direct-back-buffer path is recovered; DirectDraw COM lock paths
 * and other pixel widths remain outside this interface. */

#include <stddef.h>
#include <stdint.h>

#include "caption_lifecycle.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum caption_compositor_format {
    CAPTION_COMPOSITOR_RGB555_LE = 1,
    CAPTION_COMPOSITOR_RGB565_LE = 2
} CaptionCompositorFormat;

typedef enum caption_compositor_status {
    CAPTION_COMPOSITOR_OK = 0,
    CAPTION_COMPOSITOR_ERR_ARGUMENT = 1,
    CAPTION_COMPOSITOR_ERR_FORMAT = 2,
    CAPTION_COMPOSITOR_ERR_BOUNDS = 3,
    CAPTION_COMPOSITOR_ERR_UNSUPPORTED = 4
} CaptionCompositorStatus;

/* The view origin is pixels[0,0]. Capacity counts readable/writable bytes
 * from that pointer; pitch is a positive signed byte stride. The original
 * source pitch is signed, but negative-pitch views are not produced by the
 * caption/frame resources covered here and are rejected by this adapter.
 * Words are raw little-endian pixels in the declared matching display format. */
typedef struct caption_compositor_view {
    uint8_t *pixels;
    size_t byte_capacity;
    int32_t width;
    int32_t height;
    int32_t pitch_bytes;
    CaptionCompositorFormat format;
} CaptionCompositorView;

/* Recognizes the two recovered 16-bit packed formats from the shared S05-1
 * pixel metadata. `pixel_format` retains the exact channel shifts, widths,
 * and transparent key calculated from the original DirectDraw masks. */
int caption_compositor_format_from_pixel_format(const CaptionPixelFormat *pixel_format,
                                                CaptionCompositorFormat *format);

/* Apply one inclusive surface-local transfer immediately. The original
 * release path uses source extents and the destination rectangle's left/top;
 * its right/bottom equality check exists only behind the original debug flag.
 * The actual copied span must fit both full views; no clipping is performed.
 * For valid aliases, copying follows the original forward traversal (opaque
 * four-byte chunks then byte tail; keyed 16-bit words). */
int caption_compositor_blit(const CaptionCompositorView *source,
                            CaptionCompositorView *destination,
                            CaptionBlitKind kind,
                            const CaptionRect *source_rect,
                            const CaptionRect *destination_rect,
                            uint16_t raw_color_key);

const char *caption_compositor_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
