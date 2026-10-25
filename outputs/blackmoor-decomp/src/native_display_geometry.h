#ifndef BLACKMOOR_NATIVE_DISPLAY_GEOMETRY_H
#define BLACKMOOR_NATIVE_DISPLAY_GEOMETRY_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum native_display_mode {
    NATIVE_DISPLAY_FIT = 0,
    NATIVE_DISPLAY_STRETCH = 1
} NativeDisplayMode;

typedef struct native_display_rect {
    double x;
    double y;
    double width;
    double height;
} NativeDisplayRect;

/* Native presentation adapter; no original game coordinates/resources change.
 * Top-left view origin. FIT centers the full logical surface at one scale;
 * STRETCH fills the view with independent x/y scales. Returns 1 on success,
 * 0 on invalid arguments or an unrepresentable positive rectangle. Refusal
 * leaves out unchanged. Logical and view dimensions must be positive; view
 * dimensions must also be finite. */
int native_display_layout(uint32_t logical_width, uint32_t logical_height,
                          double view_width, double view_height,
                          NativeDisplayMode mode, NativeDisplayRect *out);

/* Inverse of the SAME rectangle used for drawing. The caller handles any
 * AppKit bottom-left to top-left conversion. Rectangle origins and points
 * must be finite, extents finite and positive, and logical dimensions nonzero.
 * Maps each span [origin, origin+extent) to [0, logical_dimension) via floor;
 * the far edge maps to logical_dimension and remains outside the surface.
 * Bars/outside points are preserved, never clamped into valid game pixels.
 * Values beyond int32 saturate at INT32_MIN/MAX before integer conversion.
 * Returns 1 on success, 0 on refusal with both outputs unchanged. Output
 * pointers must be nonnull, distinct and point to valid writable int32s. */
int native_display_map_point(uint32_t logical_width, uint32_t logical_height,
                             const NativeDisplayRect *rect,
                             double point_x, double point_y,
                             int32_t *out_x, int32_t *out_y);

#ifdef __cplusplus
}
#endif
#endif
