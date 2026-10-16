#include "action_family_d9_runtime.h"

#include <math.h>
#include <stdlib.h>
#include <string.h>

#define BODY_RADIUS 0x21u /* typed body: radius byte */
#define BODY_MODE 0x22u   /* typed body: 0 mask, else alpha map */
#define LABEL "MOUSELIGHT PUZZLE BITMAP"

static void fx(const D9Host *host, int effect, int32_t a, int32_t b)
{
    if (host != NULL && host->observe != NULL) host->observe(host->context, effect, a, b);
}

void d9_object_reset(D9Object *object)
{
    if (object == NULL) return;
    memset(object, 0, sizeof(*object));
    object->row = -1;
    object->slot = D9_NO_SLOT;
    object->pointer_x = D9_POINTER_INIT;
    object->pointer_y = D9_POINTER_INIT;
}

int d9_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    if (body == NULL || length != D9_BODY_BYTES) why = "0xd9 typed body is not 0x23 bytes";
    else if (body[BODY_RADIUS] == 0u) why = "0xd9 radius is zero (native safety rejection)";
    else if (memchr(body, 0, D9_NAME_BYTES) == NULL) why = "0xd9 image name is not terminated";
    if (failure != NULL) *failure = why != NULL ? why : "none";
    return why == NULL ? D9_OK : D9_ERR_BODY;
}

float d9_alpha_at(int32_t radius, int32_t dx, int32_t dy)
{
    /* 0x47d9b5..0x47da9d: int32 products wrap like imul; the two conversions to
     * float are fild/fstp dword, the division runs in double precision. */
    const int32_t d2 = (int32_t)((uint32_t)dx * (uint32_t)dx + (uint32_t)dy * (uint32_t)dy);
    if (!(sqrt((double)d2) < (double)radius)) return 0.0f;
    const uint32_t u = (uint32_t)d2;
    const int32_t square = (int32_t)(u * u);
    const uint32_t r = (uint32_t)radius;
    const int32_t r4 = (int32_t)(r * r * r * r);
    const int32_t half = (int32_t)((r4 - (r4 >> 31)) >> 1);
    const float numerator = (float)square;
    const float denominator = (float)half;
    return (float)exp(-(double)numerator / (double)denominator);
}

static int fail(const char **failure, const char *why)
{
    if (failure != NULL) *failure = why;
    return D9_ERR_HOST;
}

int d9_step(D9Object *object, const uint8_t *body, size_t body_length, int16_t row,
            uint32_t phase, D9World *world, const D9Host *host, D9Result *result,
            const char **failure)
{
    const char *why = "none";
    int status;
    if (failure != NULL) *failure = "none";
    if (object == NULL || world == NULL || host == NULL || result == NULL) {
        if (failure != NULL) *failure = "0xd9 null argument";
        return D9_ERR_ARGUMENT;
    }
    status = d9_validate_body(body, body_length, &why);
    if (status != D9_OK) {
        if (failure != NULL) *failure = why;
        return status;
    }
    if (phase > 1u) {
        if (failure != NULL) *failure = "0xd9 has no phase above 1";
        return D9_ERR_ARGUMENT;
    }
    if (phase == 1u && host->view == NULL) {
        if (failure != NULL) *failure = "0xd9 view callback missing";
        return D9_ERR_UNSUPPORTED;
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (phase == 1u) {
        /* 0x47dd73: the window follows the pointer, clamped to the scene. */
        D9View view;
        const int32_t r = (int32_t)object->radius;
        const int32_t px = object->pointer_x;
        const int32_t py = object->pointer_y;
        if (host->view(host->context, &view) != 0) return fail(failure, "0xd9 view provider failed");
        memcpy(object->prev, object->rect, sizeof(object->prev));
        if ((int64_t)py > (int64_t)view.bottom - view.origin_y + 5) {
            memset(object->rect, 0, sizeof(object->rect));
            return D9_OK;
        }
        object->rect[0] = px - r < 0 ? 0 : px - r;
        if (px + r - 1 > view.max_x) object->rect[2] = view.max_x;
        else object->rect[2] = px + r - 1 < 0 ? 0 : px + r - 1;
        object->rect[1] = py - r < 0 ? 0 : py - r;
        if (py + r - 1 > view.max_y) object->rect[3] = view.max_y;
        else object->rect[3] = py + r - 1 < 0 ? 0 : py + r - 1;
        return D9_OK;
    }

    /* Phase 0 (0x47d7ff). Buffers first so a memory failure changes nothing. */
    {
        const uint8_t radius = body[BODY_RADIUS];
        const size_t cells = 4u * (size_t)radius * (size_t)radius;
        const int alpha_mode = body[BODY_MODE] != 0u;
        uint8_t *composite = (uint8_t *)malloc(4u * cells);
        float *alpha = alpha_mode ? (float *)calloc(cells, sizeof(float)) : NULL;
        uint8_t *mask = alpha_mode ? NULL : (uint8_t *)calloc(cells, 1u);
        char name[D9_NAME_BYTES];
        int16_t slot = D9_NO_SLOT;
        if (composite == NULL || (alpha_mode ? alpha == NULL : mask == NULL)) {
            free(composite);
            free(alpha);
            free(mask);
            if (failure != NULL) *failure = "0xd9 buffer allocation failed";
            return D9_ERR_MEMORY;
        }
        if (host->alloc_slot == NULL || host->register_slot == NULL || host->load_surface == NULL ||
            host->set_slot_surface == NULL) {
            free(composite);
            free(alpha);
            free(mask);
            if (failure != NULL) *failure = "0xd9 slot or surface callback missing";
            return D9_ERR_UNSUPPORTED;
        }
        memcpy(name, body, sizeof(name));

        object->tracking = 1u;
        fx(host, D9_FX_TRACKING, 1, 0);
        world->start_flag_5bb1ca = 1;
        fx(host, D9_FX_START_FLAG, 1, 0);
        object->row = row;
        object->active = 1u;
        object->radius = (int16_t)radius;
        /* The original overwrites +0x49 and only the pointer of the chosen mode; the other
         * mode's buffer from an earlier row stays in place (oracle D1). Same-mode buffers are
         * leaked there and freed here, which is not observable. */
        memset(object->rect, 0, sizeof(object->rect));
        free(object->composite);
        object->composite = composite;
        fx(host, D9_FX_ALLOC, (int32_t)(16u * radius * radius), 0);
        if (alpha_mode) {
            const int32_t r = (int32_t)radius;
            free(object->alpha);
            object->alpha = alpha;
            fx(host, D9_FX_ALLOC, (int32_t)(16u * radius * radius), 1);
            for (int32_t y = -r; y < r; ++y)
                for (int32_t x = -r; x < r; ++x)
                    alpha[(size_t)(r + x) + (size_t)(r + y) * (size_t)r * 2u] = d9_alpha_at(r, y, x);
        } else {
            const int32_t r = (int32_t)radius;
            free(object->mask);
            object->mask = mask;
            fx(host, D9_FX_ALLOC, (int32_t)(4u * radius * radius), 2);
            for (int32_t y = -r; y < r; ++y)
                for (int32_t x = -r; x < r; ++x)
                    mask[(size_t)(r + x) + (size_t)(r + y) * (size_t)r * 2u] =
                        sqrt((double)(y * y + x * x)) < (double)r ? 1u : 0u;
        }
        if (host->alloc_slot(host->context, &slot) != 0) return fail(failure, "0xd9 no free render entry");
        object->slot = slot;
        fx(host, D9_FX_SLOT, slot, 0);
        if (host->register_slot(host->context, slot, object->surface, LABEL) != 0)
            return fail(failure, "0xd9 render entry registration failed");
        fx(host, D9_FX_SLOT_REGISTER, slot, (int32_t)object->surface);
        if (object->surface == 0u) {
            uint32_t surface = 0u;
            if (host->load_surface(host->context, name, &surface) != 0 || surface == 0u)
                return fail(failure, "0xd9 puzzle image unavailable");
            object->surface = surface;
            fx(host, D9_FX_SURFACE_LOAD, (int32_t)surface, 0);
        }
        if (host->set_slot_surface(host->context, slot, object->surface) != 0)
            return fail(failure, "0xd9 render entry surface store failed");
        fx(host, D9_FX_SLOT_SURFACE, (int32_t)object->surface, 0);
        result->phase_after = 1u;
        result->initialized = 1u;
        fx(host, D9_FX_PHASE, 1, 0);
    }
    return D9_OK;
}

int d9_pointer_move(D9Object *object, int16_t x, int16_t y)
{
    if (object != NULL && object->tracking != 0u) {
        object->pointer_x = x;
        object->pointer_y = y;
    }
    return 0;
}

int d9_invalidate(D9Object *object, const D9Host *host)
{
    if (object == NULL || host == NULL) return D9_ERR_ARGUMENT;
    if (object->tracking != 0u && object->slot != D9_NO_SLOT) {
        if (host->mark_dirty == NULL || host->mark_dirty(host->context, object->slot) != 0)
            return D9_ERR_HOST;
    }
    return D9_OK;
}

int d9_cleanup(D9Object *object, const D9Host *host)
{
    int status = D9_OK;
    const uint8_t active = object != NULL ? object->active : 0u;
    const int16_t radius = object != NULL ? object->radius : 0;
    if (object == NULL || host == NULL) return D9_ERR_ARGUMENT;
    if (object->surface != 0u) {
        if (host->release_surface == NULL || host->release_surface(host->context, object->surface) != 0)
            status = D9_ERR_HOST;
        fx(host, D9_FX_RELEASE_SURFACE, (int32_t)object->surface, 0);
        object->surface = 0u;
    }
    if (object->composite != NULL) fx(host, D9_FX_FREE, 0, 0);
    free(object->composite);
    if (object->alpha != NULL) fx(host, D9_FX_FREE, 0, 1);
    free(object->alpha);
    if (object->mask != NULL) fx(host, D9_FX_FREE, 0, 2);
    free(object->mask);
    if (object->slot != D9_NO_SLOT) {
        if (host->release_slot == NULL || host->release_slot(host->context, object->slot) != 0)
            status = D9_ERR_HOST;
        fx(host, D9_FX_RELEASE_SLOT, object->slot, 0);
    }
    /* 0x47d4f7 resets the cursor, window and buffers, but not +0x1c, +0x1f and
     * +0x55. */
    {
        const uint32_t surface = object->surface;
        d9_object_reset(object);
        object->surface = surface;
        object->active = active;
        object->radius = radius;
    }
    return status;
}

int d9_render_plan(const D9Object *object, const uint8_t *body, size_t body_length,
                   const D9View *view, D9RenderPlan *plan)
{
    int32_t diameter, width, height;
    if (object == NULL || body == NULL || view == NULL || plan == NULL || body_length != D9_BODY_BYTES)
        return D9_ERR_ARGUMENT;
    memset(plan, 0, sizeof(*plan));
    if (object->active == 0u) return D9_OK;
    diameter = (int32_t)object->radius * 2;
    width = object->rect[2] - object->rect[0] + 1;
    height = object->rect[3] - object->rect[1] + 1;
    plan->valid = 1u;
    for (int i = 0; i < 4; ++i) {
        const int32_t ox = (i & 1) == 0 ? view->origin_x : view->origin_y;
        plan->restore_src[i] = object->prev[i];
        plan->restore_dst[i] = object->prev[i] + ox;
        plan->src[i] = object->rect[i];
        plan->dst[i] = object->rect[i] + ox;
    }
    plan->map[2] = diameter - 1;
    plan->map[3] = diameter - 1;
    if (width < diameter && object->rect[0] == 0) plan->map[0] = diameter - width;
    if (height < diameter && object->rect[1] == 0) plan->map[1] = diameter - height;
    plan->kind = body[BODY_MODE] == 0u ? D9_BLIT_MASK : D9_BLIT_ALPHA;
    plan->surface = object->surface;
    return D9_OK;
}

/* ---- pixel operations ---------------------------------------------------- */

static int rect_ok(const int32_t r[4])
{
    return r != NULL && r[0] >= 0 && r[1] >= 0 && r[2] >= r[0] && r[3] >= r[1];
}

static int surface_ok(const D9Surface *s, const int32_t r[4])
{
    if (s == NULL || s->pixels == NULL || s->pitch_bytes <= 0 || !rect_ok(r)) return 0;
    if ((size_t)(r[2] + 1) * 2u > (size_t)s->pitch_bytes) return 0;
    return ((size_t)r[3] * (size_t)s->pitch_bytes + (size_t)(r[2] + 1) * 2u) <= s->byte_length;
}

static int same_size(const int32_t a[4], const int32_t b[4])
{
    return a[2] - a[0] == b[2] - b[0] && a[3] - a[1] == b[3] - b[1];
}

static uint16_t load16(const uint8_t *p)
{
    return (uint16_t)(p[0] | (p[1] << 8));
}

static void store16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

int d9_blit_copy(const D9Surface *src, D9Surface *dst, const int32_t src_rect[4],
                 const int32_t dst_rect[4])
{
    if (!surface_ok(src, src_rect) || !surface_ok(dst, dst_rect) || !same_size(src_rect, dst_rect))
        return D9_ERR_BOUNDS;
    const size_t bytes = (size_t)(src_rect[2] - src_rect[0] + 1) * 2u;
    for (int32_t y = 0; y <= src_rect[3] - src_rect[1]; ++y)
        memmove(dst->pixels + (size_t)(dst_rect[1] + y) * (size_t)dst->pitch_bytes + (size_t)dst_rect[0] * 2u,
                src->pixels + (size_t)(src_rect[1] + y) * (size_t)src->pitch_bytes + (size_t)src_rect[0] * 2u,
                bytes);
    return D9_OK;
}

static int map_ok(const int32_t map[4], const int32_t width, const int32_t height, size_t count,
                  size_t *base, size_t *stride)
{
    if (!rect_ok(map)) return 0;
    *stride = (size_t)map[2] + 1u;
    *base = (size_t)map[1] * *stride + (size_t)map[0];
    if ((size_t)map[0] + (size_t)width > *stride) return 0;
    return *base + (size_t)(height - 1) * *stride + (size_t)width <= count;
}

int d9_blit_mask(const D9Surface *src, D9Surface *dst, const uint8_t *mask, size_t mask_bytes,
                 const int32_t src_rect[4], const int32_t dst_rect[4], const int32_t map_rect[4])
{
    size_t base, stride;
    if (mask == NULL || !surface_ok(src, src_rect) || !surface_ok(dst, dst_rect) ||
        !same_size(src_rect, dst_rect))
        return D9_ERR_BOUNDS;
    const int32_t width = src_rect[2] - src_rect[0] + 1;
    const int32_t height = src_rect[3] - src_rect[1] + 1;
    if (!map_ok(map_rect, width, height, mask_bytes, &base, &stride)) return D9_ERR_BOUNDS;
    for (int32_t y = 0; y < height; ++y) {
        const uint8_t *s = src->pixels + (size_t)(src_rect[1] + y) * (size_t)src->pitch_bytes +
                           (size_t)src_rect[0] * 2u;
        uint8_t *d = dst->pixels + (size_t)(dst_rect[1] + y) * (size_t)dst->pitch_bytes +
                     (size_t)dst_rect[0] * 2u;
        const uint8_t *m = mask + base + (size_t)y * stride;
        for (int32_t x = 0; x < width; ++x)
            if (m[x] != 0u) store16(d + x * 2, load16(s + x * 2));
    }
    return D9_OK;
}

/* fistp with the chop rounding mode, low 32 bits (0x50ce04). */
static uint32_t ftol_low(double value)
{
    if (!(value > -9.2e18 && value < 9.2e18)) return 0u; /* integer indefinite */
    return (uint32_t)(int64_t)value;
}

int d9_blit_alpha(const D9Surface *puzzle, const D9Surface *bg, D9Surface *dst, const float *alpha,
                  size_t alpha_count, const int32_t puzzle_rect[4], const int32_t bg_rect[4],
                  const int32_t dst_rect[4], const int32_t map_rect[4], const D9PixelFormat *format)
{
    size_t base, stride;
    if (alpha == NULL || format == NULL || !surface_ok(puzzle, puzzle_rect) || !surface_ok(bg, bg_rect) ||
        !surface_ok(dst, dst_rect) || !same_size(puzzle_rect, bg_rect) || !same_size(puzzle_rect, dst_rect))
        return D9_ERR_BOUNDS;
    const int32_t width = puzzle_rect[2] - puzzle_rect[0] + 1;
    const int32_t height = puzzle_rect[3] - puzzle_rect[1] + 1;
    if (!map_ok(map_rect, width, height, alpha_count, &base, &stride)) return D9_ERR_BOUNDS;
    for (int32_t y = 0; y < height; ++y) {
        const uint8_t *s = puzzle->pixels + (size_t)(puzzle_rect[1] + y) * (size_t)puzzle->pitch_bytes +
                           (size_t)puzzle_rect[0] * 2u;
        const uint8_t *b = bg->pixels + (size_t)(bg_rect[1] + y) * (size_t)bg->pitch_bytes +
                           (size_t)bg_rect[0] * 2u;
        uint8_t *d = dst->pixels + (size_t)(dst_rect[1] + y) * (size_t)dst->pitch_bytes +
                     (size_t)dst_rect[0] * 2u;
        const float *a = alpha + base + (size_t)y * stride;
        for (int32_t x = 0; x < width; ++x) {
            const uint16_t sp = load16(s + x * 2);
            const uint16_t bp = load16(b + x * 2);
            uint16_t out = 0u;
            for (int c = 0; c < 3; ++c) {
                const int sh = format->shift[c] & 0x1f;
                const int32_t sc = (int32_t)((sp >> sh) & format->mask[c]);
                const int32_t bc = (int32_t)((bp >> sh) & format->mask[c]);
                /* fild + fstp dword, fmul dword in extended precision (exact in
                 * double: 24 + 24 bits), fistp chop, and eax, 0xffff. */
                const double product = (double)(float)(sc - bc) * (double)a[x];
                const uint32_t term = ((uint32_t)bc + (ftol_low(product) & 0xffffu)) << sh;
                out = (uint16_t)(out | (uint16_t)term);
            }
            store16(d + x * 2, out);
        }
    }
    return D9_OK;
}
