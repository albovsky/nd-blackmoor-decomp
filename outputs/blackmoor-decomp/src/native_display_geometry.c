#include "native_display_geometry.h"

#include <math.h>
#include <stddef.h>

int native_display_layout(uint32_t logical_width, uint32_t logical_height,
                          double view_width, double view_height,
                          NativeDisplayMode mode, NativeDisplayRect *out)
{
    NativeDisplayRect built;
    if (out == NULL || logical_width == 0 || logical_height == 0 ||
        !isfinite(view_width) || !isfinite(view_height) ||
        view_width <= 0.0 || view_height <= 0.0 ||
        (mode != NATIVE_DISPLAY_FIT && mode != NATIVE_DISPLAY_STRETCH))
        return 0;

    built.x = 0.0;
    built.y = 0.0;
    built.width = view_width;
    built.height = view_height;
    if (mode == NATIVE_DISPLAY_FIT) {
        const double aspect = (double)logical_width / (double)logical_height;
        if (view_width / view_height <= aspect) {
            built.height = fmin(view_height,
                                view_width * ((double)logical_height / (double)logical_width));
        } else {
            built.width = fmin(view_width, view_height * aspect);
        }
        /* Ratios are formed before multiplying to avoid underflowing an
         * otherwise representable tiny rectangle through a scale factor. */
        if (!isfinite(built.width) || !isfinite(built.height) ||
            built.width <= 0.0 || built.height <= 0.0)
            return 0;
        built.x = (view_width - built.width) * 0.5;
        built.y = (view_height - built.height) * 0.5;
    }
    *out = built;
    return 1;
}

static int32_t inverse_coordinate(double point, double origin, double extent,
                                   uint32_t logical_dimension)
{
    const double delta = point - origin;
    const double logical = (double)logical_dimension;
    double scaled;
    if (isfinite(delta)) {
        /* Multiply first when the product is finite: this retains small
         * deltas and avoids needless rounding near pixel boundaries. A
         * precomputed MAX/logical threshold can itself round upward. */
        const double product = delta * logical;
        scaled = isfinite(product) ? product / extent : (delta / extent) * logical;
    } else {
        /* Finite, opposite-sign coordinates can overflow the subtraction
         * even when the normalized result fits: MAX - (-MAX), extent MAX. */
        scaled = (point / extent - origin / extent) * logical;
    }
    if (scaled >= (double)INT32_MAX) return INT32_MAX;
    if (scaled <= (double)INT32_MIN) return INT32_MIN;
    /* A negative nonzero value can underflow to -0.0 before floor. It is
     * still outside the surface and must not turn into valid pixel zero. */
    if (scaled == 0.0 && point < origin) return -1;
    return (int32_t)floor(scaled);
}

int native_display_map_point(uint32_t logical_width, uint32_t logical_height,
                             const NativeDisplayRect *rect,
                             double point_x, double point_y,
                             int32_t *out_x, int32_t *out_y)
{
    int32_t x, y;
    if (rect == NULL || out_x == NULL || out_y == NULL || out_x == out_y ||
        logical_width == 0 || logical_height == 0 ||
        !isfinite(rect->x) || !isfinite(rect->y) ||
        !isfinite(rect->width) || !isfinite(rect->height) ||
        rect->width <= 0.0 || rect->height <= 0.0 ||
        !isfinite(point_x) || !isfinite(point_y))
        return 0;

    x = inverse_coordinate(point_x, rect->x, rect->width, logical_width);
    y = inverse_coordinate(point_y, rect->y, rect->height, logical_height);
    *out_x = x;
    *out_y = y;
    return 1;
}
