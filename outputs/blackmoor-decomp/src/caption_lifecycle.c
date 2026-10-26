#include "caption_lifecycle.h"

#include <string.h>

/* TBOX offsets (relative to 0x5b0a12), as in caption_layout.c. */
#define TBOX_FRAME_VIEW_TOP 0x04     /* 0x5b0a16 */
#define TBOX_FRAME_VIEW_BOTTOM 0x0c  /* 0x5b0a1e */
#define TBOX_FRAME_LEFT 0x10         /* 0x5b0a22 */
#define TBOX_FRAME_TOP 0x14          /* 0x5b0a26 */
#define TBOX_FRAME_RIGHT 0x18        /* 0x5b0a2a */
#define TBOX_FRAME_BOTTOM 0x1c       /* 0x5b0a2e */
#define TBOX_CAPTION_VIEW 0x28       /* 0x5b0a3a: left, top, right, bottom */

#define POPUP_IMAGE_PURPOSE "UI Popup"
#define SLIDER_IMAGE_PURPOSE "UI Slider"
#define RESTORE_IMAGE_PURPOSE "UI Button restore"
#define NO_SOUND "NO SOUND"            /* compared with its NUL: 9 bytes */
#define SHARED_ART "Use Shared Art"    /* compared with its NUL: 15 bytes */

static int32_t rd32(const uint8_t *p, size_t o)
{
    return (int32_t)((uint32_t)p[o] | ((uint32_t)p[o + 1] << 8) |
                     ((uint32_t)p[o + 2] << 16) | ((uint32_t)p[o + 3] << 24));
}

static int16_t rd16(const uint8_t *p, size_t o)
{
    return (int16_t)(uint16_t)(p[o] | (p[o + 1] << 8));
}

/* Source arithmetic is performed in 32-bit x86 registers. Compute in a wider
 * type and fold once to the signed 32-bit range without signed overflow. */
static int32_t wrap_add32(int32_t a, int32_t b)
{
    int64_t value = (int64_t)a + (int64_t)b;

    if (value > INT32_MAX) {
        value -= INT64_C(4294967296);
    } else if (value < INT32_MIN) {
        value += INT64_C(4294967296);
    }
    return (int32_t)value;
}

static int32_t wrap_sub32(int32_t a, int32_t b)
{
    int64_t value = (int64_t)a - (int64_t)b;

    if (value > INT32_MAX) {
        value -= INT64_C(4294967296);
    } else if (value < INT32_MIN) {
        value += INT64_C(4294967296);
    }
    return (int32_t)value;
}

static int32_t wrap_mul32(int32_t a, int32_t b)
{
    int64_t value = ((int64_t)a * (int64_t)b) % INT64_C(4294967296);

    if (value > INT32_MAX) {
        value -= INT64_C(4294967296);
    } else if (value < INT32_MIN) {
        value += INT64_C(4294967296);
    }
    return (int32_t)value;
}

static int16_t wrap16(int32_t value)
{
    uint16_t bits = (uint16_t)(uint32_t)value;
    int32_t signed_value = bits <= INT16_MAX ? (int32_t)bits
                                               : (int32_t)bits - INT32_C(65536);

    return (int16_t)signed_value;
}

static void wr32(uint8_t *p, size_t o, int32_t v)
{
    uint32_t u = (uint32_t)v;
    p[o] = (uint8_t)u;
    p[o + 1] = (uint8_t)(u >> 8);
    p[o + 2] = (uint8_t)(u >> 16);
    p[o + 3] = (uint8_t)(u >> 24);
}

static float rdf(const uint8_t *p, size_t o)
{
    uint32_t u = (uint32_t)rd32(p, o);
    float f;
    memcpy(&f, &u, sizeof(f));
    return f;
}

static void wrf(uint8_t *p, size_t o, float f)
{
    uint32_t u;
    memcpy(&u, &f, sizeof(u));
    wr32(p, o, (int32_t)u);
}

/* __ftol (0x50ce04): truncating fistp to a 64-bit integer, low dword
 * returned. NaN and values outside the int64 range give the indefinite
 * 0x8000000000000000, whose low dword is 0. */
static int32_t ftol(double value)
{
    if (!(value > -9223372036854775808.0 && value < 9223372036854775808.0)) {
        return 0;
    }
    return (int32_t)(uint32_t)(uint64_t)(int64_t)value;
}

/* x87 fdiv: an invalid operation (0/0) yields the negative default NaN
 * 0xffc00000 ("real indefinite"); other results match IEEE division. */
static float x87_divide(float numerator, float denominator)
{
    double q = (double)numerator / (double)denominator;
    if (q != q && numerator == numerator && denominator == denominator) {
        uint32_t indefinite = 0xffc00000u;
        float f;
        memcpy(&f, &indefinite, sizeof(f));
        return f;
    }
    return (float)q;
}

static CaptionRect rect_at(const uint8_t *p, size_t o)
{
    CaptionRect r;
    r.left = rd32(p, o);
    r.top = rd32(p, o + 4);
    r.right = rd32(p, o + 8);
    r.bottom = rd32(p, o + 12);
    return r;
}

static int32_t tbox32(const CaptionLifecycle *life, size_t o)
{
    return rd32(life->geometry->tbox, o);
}

static int fatal(const CaptionLifecycleBackend *backend, const char *message)
{
    if (backend->fatal != NULL) {
        backend->fatal(backend->context, message);
    }
    return CAPTION_LIFECYCLE_ERR_FATAL;
}

static int blit(const CaptionLifecycleBackend *backend, CaptionBlitKind kind,
                uint32_t surface, CaptionRect src, CaptionRect dst, const char *label)
{
    CaptionBlit b;

    if (surface == 0u) {
        /* The original dereferences the null surface. */
        return fatal(backend, label);
    }
    if (backend->blit == NULL) {
        return CAPTION_LIFECYCLE_ERR_BACKEND;
    }
    b.kind = kind;
    b.surface = surface;
    b.src = src;
    b.dst = dst;
    b.label = label;
    return backend->blit(backend->context, &b) == CAPTION_LIFECYCLE_BACKEND_OK
               ? CAPTION_LIFECYCLE_OK
               : CAPTION_LIFECYCLE_ERR_BACKEND;
}

static int load_image(const CaptionLifecycleBackend *backend, const uint8_t *name_field,
                      const char *purpose, int32_t *handle)
{
    char name[34];
    uint32_t value;

    memcpy(name, name_field, 33);
    name[33] = '\0';
    /* 0x4c2790 truncates names longer than 0x18 characters. */
    if (strlen(name) > 0x18u) {
        name[0x18] = '\0';
    }
    if (backend->load_image == NULL) {
        return CAPTION_LIFECYCLE_ERR_BACKEND;
    }
    value = backend->load_image(backend->context, name, purpose);
    if (value == 0u) {
        /* 0x4c2790: report "CreateDFSurface" failure and quit. */
        return fatal(backend, "CDirectDraw::CreateDFSurface() failed");
    }
    *handle = (int32_t)value;
    return CAPTION_LIFECYCLE_OK;
}

/* ---- CUISlider (object at box + 0x4b7) --------------------------------- */

#define S(o) (CTB_SLIDER + (o))
#define SCTB_HAS_SLIDER (CTB_HAS_SLIDER - CTB_CONFIG)
#define SCTB_SLIDER_INIT_VISUAL \
    (CTB_SLIDER_CONFIG - CTB_CONFIG + SLD_INIT_VISUAL - SLD_CONFIG)

/* 0x4ee9bb. */
static void slider_reset(uint8_t *box)
{
    static const size_t zero[] = {
        SLD_DRAGGING, SLD_LOADED, SLD_POSITION, SLD_DIRTY, SLD_FRACTION, SLD_OFFSET,
        SLD_PRESS_Y, SLD_PRESS_X, SLD_CURSOR_Y, SLD_CURSOR_X, SLD_DELTA_Y, SLD_DELTA_X,
        SLD_HOVER, SLD_SHARED_ART, SLD_IMAGE, SLD_BACKGROUND, SLD_FILLS_W, SLD_FILLS_H,
    };
    size_t i;

    for (i = 0; i < sizeof(zero) / sizeof(zero[0]); ++i) {
        wr32(box, S(zero[i]), 0);
    }
    memset(box + S(SLD_CONFIG), 0, 0xc6u);
    memset(box + S(SLD_DRAG_THUMB), 0, 16u);
}

/* 0x4ef52a: thumb rectangle from the offset. */
static void slider_place(uint8_t *box)
{
    int32_t orientation = rd32(box, S(SLD_ORIENTATION));
    int32_t direction = rd32(box, S(SLD_DIRECTION));
    int32_t offset = rd32(box, S(SLD_OFFSET));

    if (orientation == 0) {
        if (direction == 0) {
            wr32(box, S(SLD_THUMB), wrap_add32(rd32(box, S(SLD_TRACK)), offset));
            wr32(box, S(SLD_THUMB + 8),
                 wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB)), 1), rd32(box, S(SLD_THUMB_W))));
        } else if (direction == 1) {
            wr32(box, S(SLD_THUMB + 8), wrap_sub32(rd32(box, S(SLD_TRACK + 8)), offset));
            wr32(box, S(SLD_THUMB),
                 wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB + 8)), rd32(box, S(SLD_THUMB_W))), 1));
        } else {
            return;
        }
        if (rd32(box, S(SLD_FILLS_H)) == 0) {
            wr32(box, S(SLD_THUMB + 4),
                 wrap_sub32(wrap_add32(rd32(box, S(SLD_TRACK + 4)),
                                             rd32(box, S(SLD_TRACK_H)) / 2),
                                  rd32(box, S(SLD_THUMB_H)) / 2));
            wr32(box, S(SLD_THUMB + 12),
                 wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB + 4)), 1), rd32(box, S(SLD_THUMB_H))));
        } else {
            wr32(box, S(SLD_THUMB + 4), rd32(box, S(SLD_TRACK + 4)));
            wr32(box, S(SLD_THUMB + 12), rd32(box, S(SLD_TRACK + 12)));
        }
    } else if (orientation == 1) {
        if (direction == 2) {
            wr32(box, S(SLD_THUMB + 4), wrap_add32(rd32(box, S(SLD_TRACK + 4)), offset));
            wr32(box, S(SLD_THUMB + 12),
                 wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB + 4)), 1), rd32(box, S(SLD_THUMB_H))));
        } else if (direction == 3) {
            wr32(box, S(SLD_THUMB + 12), wrap_sub32(rd32(box, S(SLD_TRACK + 12)), offset));
            wr32(box, S(SLD_THUMB + 4),
                 wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB + 12)), rd32(box, S(SLD_THUMB_H))), 1));
        } else {
            return;
        }
        if (rd32(box, S(SLD_FILLS_W)) == 0) {
            wr32(box, S(SLD_THUMB),
                 wrap_sub32(wrap_add32(rd32(box, S(SLD_TRACK)),
                                             rd32(box, S(SLD_TRACK_W)) / 2),
                                  rd32(box, S(SLD_THUMB_W)) / 2));
            wr32(box, S(SLD_THUMB + 8),
                 wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB)), 1), rd32(box, S(SLD_THUMB_W))));
        } else {
            wr32(box, S(SLD_THUMB), rd32(box, S(SLD_TRACK)));
            wr32(box, S(SLD_THUMB + 8), rd32(box, S(SLD_TRACK + 8)));
        }
    }
}

static void slider_reverse(uint8_t *box)
{
    wr32(box, S(SLD_OFFSET), wrap_sub32(rd32(box, S(SLD_RANGE)), rd32(box, S(SLD_OFFSET))));
    wrf(box, S(SLD_FRACTION), (float)(1.0 - (double)rdf(box, S(SLD_FRACTION))));
}

/* 0x4ef89b. */
static int slider_visual_valid(int32_t visual);

static int slider_update(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    uint8_t *box = life->box;
    CaptionLifecycleGlobals *g = &life->g;
    int32_t loaded = rd32(box, S(SLD_LOADED));
    int status;

    if (loaded == 0) {
        if (rd32(box, S(SLD_SHARED_ART)) != 0) {
            wr32(box, S(SLD_IMAGE), (int32_t)g->default_cursor_surface);
        } else if (rd32(box, S(SLD_IMAGE)) == 0) {
            int32_t handle = 0;
            status = load_image(backend, box + S(SLD_CONFIG), SLIDER_IMAGE_PURPOSE, &handle);
            if (status != CAPTION_LIFECYCLE_OK) {
                return status;
            }
            wr32(box, S(SLD_IMAGE), handle);
        }
        if (rd32(box, S(SLD_BACKGROUND)) == 0) {
            int32_t handle = 0;
            status = load_image(backend, box + S(0x39), RESTORE_IMAGE_PURPOSE, &handle);
            if (status != CAPTION_LIFECYCLE_OK) {
                return status;
            }
            wr32(box, S(SLD_BACKGROUND), handle);
        }
        wr32(box, S(SLD_LOADED), 1);
        slider_place(box);
        return CAPTION_LIFECYCLE_OK;
    }
    if (loaded != 1) {
        slider_place(box);
        return CAPTION_LIFECYCLE_OK;
    }

    if (rd32(box, S(SLD_DIRTY)) != 0) {
        int32_t orientation;
        float fraction = (float)((double)(float)rd32(box, S(SLD_POSITION)) / 100.0);

        wrf(box, S(SLD_FRACTION), fraction);
        wr32(box, S(SLD_OFFSET),
             ftol((double)(float)rd32(box, S(SLD_RANGE)) * (double)fraction));
        orientation = rd32(box, S(SLD_ORIENTATION));
        if (orientation == 0 || orientation == 1) {
            /* 0x4ef9a3..0x4efa2f: horizontal checks direction 1, then both
             * orientations reach the direction 3 check. */
            if (orientation == 0 && rd32(box, S(SLD_DIRECTION)) == 1) {
                slider_reverse(box);
            }
            if (rd32(box, S(SLD_DIRECTION)) == 3) {
                slider_reverse(box);
            }
        }
        wr32(box, S(SLD_DIRTY), 0);
    }

    /* 0x4dadff on input object 0x5830a6, then 0x4daeb5 GetCursorPos. */
    if (backend->key_down == NULL || backend->cursor_pos == NULL) {
        return CAPTION_LIFECYCLE_ERR_BACKEND;
    }
    g->mouse_down[0] = (uint8_t)(backend->key_down(backend->context, g->mouse_vk[0]) != 0);
    g->mouse_down[1] = (uint8_t)(backend->key_down(backend->context, g->mouse_vk[1]) != 0);
    {
        int32_t x = 0;
        int32_t y = 0;
        backend->cursor_pos(backend->context, &x, &y);
        g->input_cursor[0] = x;
        g->input_cursor[1] = y;
        wr32(box, S(SLD_CURSOR_X), x);
        wr32(box, S(SLD_CURSOR_Y), y);
    }

    {
        int32_t visual = rd32(box, S(SLD_VISUAL));
        int32_t dragging = rd32(box, S(SLD_DRAGGING));
        int32_t hover = rd32(box, S(SLD_HOVER));
        int left = g->mouse_down[0] == 1;

        if ((visual == 0 || visual == 1) && dragging == 0 && hover != 0 && left) {
            wr32(box, S(SLD_DRAGGING), 1);
            wr32(box, S(SLD_PRESS_X), rd32(box, S(SLD_CURSOR_X)));
            wr32(box, S(SLD_PRESS_Y), rd32(box, S(SLD_CURSOR_Y)));
            memcpy(box + S(SLD_DRAG_THUMB), box + S(SLD_THUMB), 16u);
            if (rd32(box, S(SLD_DRAG_STATE)) != 0) {
                wr32(box, S(SLD_VISUAL), 2);
            }
        } else if (dragging == 1 && hover != 0 && left) {
            int32_t orientation = rd32(box, S(SLD_ORIENTATION));

            wr32(box, S(SLD_DELTA_X), wrap_sub32(rd32(box, S(SLD_CURSOR_X)), rd32(box, S(SLD_PRESS_X))));
            wr32(box, S(SLD_DELTA_Y), wrap_sub32(rd32(box, S(SLD_CURSOR_Y)), rd32(box, S(SLD_PRESS_Y))));
            if (orientation == 0 || orientation == 1) {
                size_t lo = orientation == 0 ? 0u : 4u;      /* left / top */
                size_t hi = orientation == 0 ? 8u : 12u;     /* right / bottom */
                size_t delta = orientation == 0 ? SLD_DELTA_X : SLD_DELTA_Y;
                size_t size = orientation == 0 ? SLD_THUMB_W : SLD_THUMB_H;
                int32_t reverse = orientation == 0 ? 1 : 3;
                float fraction;

                wr32(box, S(SLD_THUMB + lo), wrap_add32(rd32(box, S(SLD_DRAG_THUMB + lo)),
                                                  rd32(box, S(delta))));
                wr32(box, S(SLD_THUMB + hi), wrap_add32(rd32(box, S(SLD_DRAG_THUMB + hi)),
                                                  rd32(box, S(delta))));
                if (rd32(box, S(SLD_THUMB + lo)) < rd32(box, S(SLD_TRACK + lo))) {
                    wr32(box, S(SLD_THUMB + lo), rd32(box, S(SLD_TRACK + lo)));
                    wr32(box, S(SLD_THUMB + hi),
                         wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB + lo)), 1),
                                    rd32(box, S(size))));
                }
                if (rd32(box, S(SLD_TRACK + hi)) < rd32(box, S(SLD_THUMB + hi))) {
                    wr32(box, S(SLD_THUMB + hi), rd32(box, S(SLD_TRACK + hi)));
                    wr32(box, S(SLD_THUMB + lo),
                         wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB + hi)),
                                                       rd32(box, S(size))), 1));
                }
                wr32(box, S(SLD_OFFSET),
                     wrap_sub32(rd32(box, S(SLD_THUMB + lo)), rd32(box, S(SLD_TRACK + lo))));
                fraction = x87_divide((float)rd32(box, S(SLD_OFFSET)),
                                      (float)rd32(box, S(SLD_RANGE)));
                wrf(box, S(SLD_FRACTION), fraction);
                if (rd32(box, S(SLD_DIRECTION)) == reverse) {
                    slider_reverse(box);
                }
                wr32(box, S(SLD_POSITION),
                     ftol((double)rdf(box, S(SLD_FRACTION)) * 100.0));
            }
        } else if (dragging == 1 && (hover == 0 || !left)) {
            wr32(box, S(SLD_DRAGGING), 0);
            wr32(box, S(SLD_VISUAL), 0);
        } else {
            wr32(box, S(SLD_DRAGGING), 0);
        }
    }
    slider_place(box);
    return CAPTION_LIFECYCLE_OK;
}

/* 0x4eeb23 (config at box + 0x256). */
static int slider_init(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    uint8_t *box = life->box;
    int32_t orientation;
    int32_t direction;

    slider_reset(box);
    memcpy(box + S(SLD_CONFIG), box + CTB_SLIDER_CONFIG, 0xc6u);
    wr32(box, S(SLD_SHARED_ART),
         memcmp(box + S(SLD_CONFIG), SHARED_ART, sizeof(SHARED_ART)) == 0 ? 1 : 0);
    if (rd32(box, S(SLD_SHARED_ART)) == 0) {
        memcpy(box + S(SLD_DRAW_SRC), box + S(SLD_SRC_RECTS), 64u);
    } else {
        /* 0x5afc3e..0x5afc7a: shared-art rectangles (BOOT, not modelled). */
        return CAPTION_LIFECYCLE_ERR_UNSUPPORTED;
    }
    if (rd32(box, S(SLD_RELATIVE)) == 0) {
        memcpy(box + S(SLD_TRACK), box + S(SLD_TRACK_RAW), 16u);
    } else {
        wr32(box, S(SLD_TRACK), wrap_add32(rd32(box, S(SLD_TRACK_RAW)), life->view_origin[0]));
        wr32(box, S(SLD_TRACK + 8), wrap_add32(rd32(box, S(SLD_TRACK_RAW + 8)), life->view_origin[0]));
        wr32(box, S(SLD_TRACK + 4), wrap_add32(rd32(box, S(SLD_TRACK_RAW + 4)), life->view_origin[1]));
        wr32(box, S(SLD_TRACK + 12), wrap_add32(rd32(box, S(SLD_TRACK_RAW + 12)), life->view_origin[1]));
    }
    wr32(box, S(SLD_TRACK_W), wrap_add32(wrap_sub32(rd32(box, S(SLD_TRACK + 8)),
                                  rd32(box, S(SLD_TRACK))), 1));
    wr32(box, S(SLD_TRACK_H), wrap_add32(wrap_sub32(rd32(box, S(SLD_TRACK + 12)),
                                  rd32(box, S(SLD_TRACK + 4))), 1));
    wr32(box, S(SLD_THUMB_W), wrap_add32(wrap_sub32(rd32(box, S(SLD_SRC_RECTS + 8)),
                                  rd32(box, S(SLD_SRC_RECTS))), 1));
    wr32(box, S(SLD_THUMB_H),
         wrap_add32(wrap_sub32(rd32(box, S(SLD_SRC_RECTS + 12)),
                                  rd32(box, S(SLD_SRC_RECTS + 4))), 1));
    wr32(box, S(SLD_FILLS_W), rd32(box, S(SLD_TRACK_W)) == rd32(box, S(SLD_THUMB_W)));
    wr32(box, S(SLD_FILLS_H), rd32(box, S(SLD_TRACK_H)) == rd32(box, S(SLD_THUMB_H)));
    if (wrap_add32(wrap_sub32(rd32(box, S(SLD_BG_SRC + 8)),
                                  rd32(box, S(SLD_BG_SRC))), 1) != rd32(box, S(SLD_TRACK_W)) ||
        wrap_add32(wrap_sub32(rd32(box, S(SLD_BG_SRC + 12)),
                                       rd32(box, S(SLD_BG_SRC + 4))), 1) !=
            rd32(box, S(SLD_TRACK_H))) {
        /* "CUISlider::CUISlider() - ID %d - Mismatched ..." then quit. */
        return fatal(backend, "CUISlider: background and track sizes differ");
    }
    wr32(box, S(SLD_VISUAL), rd32(box, S(SLD_INIT_VISUAL)));
    if (!slider_visual_valid(rd32(box, S(SLD_VISUAL)))) {
        return CAPTION_LIFECYCLE_ERR_FORMAT;
    }
    wr32(box, S(SLD_TRANSPARENT), rd32(box, S(SLD_INIT_TRANSPARENT)));
    orientation = rd32(box, S(SLD_ORIENTATION));
    direction = rd32(box, S(SLD_DIRECTION));
    if (orientation == 0) {
        wr32(box, S(SLD_RANGE), wrap_sub32(wrap_add32(wrap_sub32(rd32(box, S(SLD_TRACK + 8)),
                                                    rd32(box, S(SLD_TRACK))), 1),
                                   rd32(box, S(SLD_THUMB_W))));
        if (direction == 0) {
            wr32(box, S(SLD_THUMB), rd32(box, S(SLD_TRACK)));
            wr32(box, S(SLD_THUMB + 8), wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB)), 1), rd32(box, S(SLD_THUMB_W))));
        } else if (direction == 1) {
            wr32(box, S(SLD_THUMB + 8), rd32(box, S(SLD_TRACK + 8)));
            wr32(box, S(SLD_THUMB), wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB + 8)), rd32(box, S(SLD_THUMB_W))), 1));
        }
        if (direction == 0 || direction == 1) {
            if (rd32(box, S(SLD_FILLS_H)) == 0) {
                wr32(box, S(SLD_THUMB + 4),
                     wrap_sub32(wrap_add32(rd32(box, S(SLD_TRACK + 4)),
                                             rd32(box, S(SLD_TRACK_H)) / 2),
                                  rd32(box, S(SLD_THUMB_H)) / 2));
                wr32(box, S(SLD_THUMB + 12),
                     wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB + 4)), 1), rd32(box, S(SLD_THUMB_H))));
            } else {
                wr32(box, S(SLD_THUMB + 4), rd32(box, S(SLD_TRACK + 4)));
                wr32(box, S(SLD_THUMB + 12), rd32(box, S(SLD_TRACK + 12)));
            }
        }
    } else if (orientation == 1) {
        wr32(box, S(SLD_RANGE), wrap_sub32(wrap_add32(wrap_sub32(rd32(box, S(SLD_TRACK + 12)),
                                                    rd32(box, S(SLD_TRACK + 4))), 1),
                                   rd32(box, S(SLD_THUMB_H))));
        if (direction == 2) {
            wr32(box, S(SLD_THUMB + 4), rd32(box, S(SLD_TRACK + 4)));
            wr32(box, S(SLD_THUMB + 12),
                 wrap_add32(wrap_sub32(rd32(box, S(SLD_TRACK + 4)), 1),
                            rd32(box, S(SLD_THUMB_H))));
        } else if (direction == 3) {
            wr32(box, S(SLD_THUMB + 12), rd32(box, S(SLD_TRACK + 12)));
            wr32(box, S(SLD_THUMB + 4),
                 wrap_add32(wrap_sub32(rd32(box, S(SLD_TRACK + 12)),
                                       rd32(box, S(SLD_THUMB_H))), 1));
        }
        if (direction == 2 || direction == 3) {
            if (rd32(box, S(SLD_FILLS_W)) == 0) {
                wr32(box, S(SLD_THUMB),
                     wrap_sub32(wrap_add32(rd32(box, S(SLD_TRACK)),
                                             rd32(box, S(SLD_TRACK_W)) / 2),
                                  rd32(box, S(SLD_THUMB_W)) / 2));
                wr32(box, S(SLD_THUMB + 8),
                     wrap_add32(wrap_sub32(rd32(box, S(SLD_THUMB)), 1), rd32(box, S(SLD_THUMB_W))));
            } else {
                wr32(box, S(SLD_THUMB), rd32(box, S(SLD_TRACK)));
                wr32(box, S(SLD_THUMB + 8), rd32(box, S(SLD_TRACK + 8)));
            }
        }
    } else {
        /* "CUISlider::CUISlider() - ID %d - Invalid orientation" then quit. */
        return fatal(backend, "CUISlider: invalid orientation");
    }
    return slider_update(life, backend);
}

/* 0x4ef2d1(x, y). */
static int slider_hit(CaptionLifecycle *life, int16_t x, int16_t y)
{
    uint8_t *box = life->box;
    CaptionLifecycleGlobals *g = &life->g;
    int32_t visual = rd32(box, S(SLD_VISUAL));

    wr32(box, S(SLD_HOVER), 0);
    if (visual != 0 && visual != 1 && visual != 2) {
        return 0;
    }
    if ((int32_t)y >= wrap_add32(rd32(box, S(SLD_THUMB + 4)), 5) &&
        (int32_t)y <= wrap_add32(rd32(box, S(SLD_THUMB + 12)), 10) &&
        (int32_t)x >= wrap_add32(rd32(box, S(SLD_THUMB)), 5) &&
        (int32_t)x <= wrap_add32(rd32(box, S(SLD_THUMB + 8)), 5)) {
        wr32(box, S(SLD_HOVER), 1);
        if (rd32(box, S(SLD_VISUAL)) == 0 && rd32(box, S(SLD_HOVER_STATE)) != 0) {
            wr32(box, S(SLD_VISUAL), 1);
        }
        if (rd32(box, S(SLD_CURSOR_CHANGE)) != 0) {
            g->slider_cursor_scene = 0x27d9;
            g->cursor_variant = 1;
            g->cursor_src_index = wrap_add32(wrap_mul32(g->cursor_type, 8),
                                              wrap_mul32(g->cursor_variant, 4));
            g->cursor_layer_enabled = 1;
        }
        return 1;
    }
    wr32(box, S(SLD_VISUAL), 0);
    return 0;
}

/* 0x4eff03. */
static int slider_visual_valid(int32_t visual)
{
    return (visual >= 0 && visual <= 3) || visual == 4;
}

static int slider_draw(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    uint8_t *box = life->box;
    int32_t visual = rd32(box, S(SLD_VISUAL));
    int status;

    if (!slider_visual_valid(visual)) {
        return CAPTION_LIFECYCLE_ERR_FORMAT;
    }
    if (visual == 4) {
        return CAPTION_LIFECYCLE_OK;
    }
    status = blit(backend, CAPTION_BLIT_OPAQUE, (uint32_t)rd32(box, S(SLD_BACKGROUND)),
                  rect_at(box, S(SLD_BG_SRC)), rect_at(box, S(SLD_TRACK)),
                  "CUISlider background restore");
    if (status != CAPTION_LIFECYCLE_OK) {
        return status;
    }
    return blit(backend,
                rd32(box, S(SLD_TRANSPARENT)) == 1 ? CAPTION_BLIT_KEYED : CAPTION_BLIT_OPAQUE,
                (uint32_t)rd32(box, S(SLD_IMAGE)),
                rect_at(box, S(SLD_DRAW_SRC) + (size_t)visual * 16u),
                rect_at(box, S(SLD_THUMB)),
                rd32(box, S(SLD_TRANSPARENT)) == 1 ? "CUISlider transparent object"
                                                   : "CUISlider object");
}

/* ---- CUIPopup ------------------------------------------------------------ */

/* 0x4edae5. */
static void popup_reset(CaptionLifecycle *life)
{
    uint8_t *box = life->box;

    wr32(box, CTB_STATE, 0);
    wr32(box, CTB_REQUESTED, 0);
    wr32(box, CTB_POPUP_IMAGE, 0);
    wr32(box, CTB_SOUND_LOADED, 0);
    wr32(box, CTB_SOUND_LOADED + 4, 0);
    wr32(box, CTB_SOUND_LOADED + 8, 0);
    wr32(box, CTB_SOUND_LOADED + 12, 0);
    wr32(box, CTB_PRESSED, 0);
    life->g.popup_gate = 1;
    life->g.popup_aux = 0;
    wr32(box, CTB_RESTORE_CURSOR, 0);
    wr32(box, CTB_RESTORE_CURSOR + 4, 0);
    memset(box + CTB_CONFIG, 0, 0xbcu * 4u);
}

/* 0x4edb97 (popup release) and 0x4eead0 (slider release) are reached for
 * this object only from the button close path 0x4ee843; the shipped SCTB
 * has no button, so they are not ported. */

/* 0x4edcb1(config, modal). */
static int popup_init(CaptionLifecycle *life, const CaptionLifecycleBackend *backend,
                      const uint8_t *config, int modal)
{
    uint8_t *box = life->box;
    size_t i;
    uint8_t copy[0xbcu * 4u];

    memcpy(copy, config, sizeof(copy));
    /* Reject malformed selector data before popup setup can invoke resource
     * callbacks. slider_init validates again after those callbacks so live
     * host mutations cannot reach the selector table unchecked. */
    if (rd32(copy, SCTB_HAS_SLIDER) != 0 &&
        !slider_visual_valid(rd32(copy, SCTB_SLIDER_INIT_VISUAL))) {
        return CAPTION_LIFECYCLE_ERR_FORMAT;
    }
    popup_reset(life);
    memcpy(box + CTB_CONFIG, copy, sizeof(copy));
    if (rd32(box, CTB_RELATIVE) == 0) {
        memcpy(box + CTB_NORMAL_DST, box + CTB_NORMAL_DST_RAW, 16u);
        memcpy(box + CTB_MAX_DST, box + CTB_MAX_DST_RAW, 16u);
    } else {
        int32_t dx = life->view_origin[0];
        int32_t dy = life->view_origin[1];
        wr32(box, CTB_NORMAL_DST, wrap_add32(rd32(box, CTB_NORMAL_DST_RAW), dx));
        wr32(box, CTB_NORMAL_DST + 8, wrap_add32(rd32(box, CTB_NORMAL_DST_RAW + 8), dx));
        wr32(box, CTB_NORMAL_DST + 4, wrap_add32(rd32(box, CTB_NORMAL_DST_RAW + 4), dy));
        wr32(box, CTB_NORMAL_DST + 12, wrap_add32(rd32(box, CTB_NORMAL_DST_RAW + 12), dy));
        wr32(box, CTB_MAX_DST, wrap_add32(rd32(box, CTB_MAX_DST_RAW), dx));
        wr32(box, CTB_MAX_DST + 8, wrap_add32(rd32(box, CTB_MAX_DST_RAW + 8), dx));
        wr32(box, CTB_MAX_DST + 4, wrap_add32(rd32(box, CTB_MAX_DST_RAW + 4), dy));
        wr32(box, CTB_MAX_DST + 12, wrap_add32(rd32(box, CTB_MAX_DST_RAW + 12), dy));
    }
    for (i = 0; i < 4u; ++i) {
        const uint8_t *descriptor = box + CTB_SOUND0 + i * CTB_SOUND_STRIDE;

        if (memcmp(descriptor, NO_SOUND, sizeof(NO_SOUND)) == 0) {
            wr32(box, CTB_SOUND_LOADED + i * 4u, 0);
        } else {
            if (backend->load_sound == NULL ||
                backend->load_sound(backend->context, descriptor) !=
                    CAPTION_LIFECYCLE_BACKEND_OK) {
                return CAPTION_LIFECYCLE_ERR_BACKEND;
            }
            wr32(box, CTB_SOUND_LOADED + i * 4u, 1);
        }
    }
    if (rd32(box, CTB_HAS_BUTTON) != 0) {
        return CAPTION_LIFECYCLE_ERR_UNSUPPORTED; /* 0x4e1db3 not ported */
    }
    if (rd32(box, CTB_HAS_SLIDER) != 0) {
        int status = slider_init(life, backend);
        if (status != CAPTION_LIFECYCLE_OK) {
            return status;
        }
    }
    if (rd16(box, CTB_SCENE) != 9999) {
        life->g.scene_request = rd16(box, CTB_SCENE);
        life->g.scene_request_flag = 1;
        life->g.engine_state = 4;
        life->g.popup_gate = 0;
    }
    if (modal) {
        life->g.modal_input = 1;
    }
    return CAPTION_LIFECYCLE_OK;
}

/* 0x4ee6c7(param): returns 1, or 0 when the popup closed itself. */
static int popup_poll(CaptionLifecycle *life, const CaptionLifecycleBackend *backend,
                      int *still_open, int restore_cursor,
                      void (*warp)(void *, int32_t, int32_t))
{
    uint8_t *box = life->box;
    int32_t state = rd32(box, CTB_STATE);
    int status;

    *still_open = 1;
    switch (state) {
    case 0:
        if (rd32(box, CTB_POPUP_IMAGE) == 0) {
            int32_t handle = 0;
            status = load_image(backend, box + CTB_IMAGE_NAME, POPUP_IMAGE_PURPOSE, &handle);
            if (status != CAPTION_LIFECYCLE_OK) {
                return status;
            }
            wr32(box, CTB_POPUP_IMAGE, handle);
        }
        wr32(box, CTB_STATE, life->g.popup_gate == 0 ? 4 : 5);
        return CAPTION_LIFECYCLE_OK;
    case 4:
        if (life->g.popup_gate != 0) {
            wr32(box, CTB_STATE, 5);
        }
        return CAPTION_LIFECYCLE_OK;
    case 5:
        wr32(box, CTB_STATE, rd32(box, CTB_REQUESTED));
        state = rd32(box, CTB_STATE);
        if (state > 1 && state < 4 && rd32(box, CTB_SOUND_LOADED) != 0) {
            if (backend->play_sound == NULL ||
                backend->play_sound(backend->context, rd16(box, CTB_SOUND0_CHANNEL)) !=
                    CAPTION_LIFECYCLE_BACKEND_OK) {
                return CAPTION_LIFECYCLE_ERR_BACKEND;
            }
        }
        /* 0x4ee6c7(1), used by CUIConvo, restores the saved cursor and
         * releases the popup's input gate before updating its controls.
         * The native adapter may omit the OS cursor warp explicitly. */
        if (restore_cursor) {
            if (warp) warp(backend->context, rd32(box, CTB_RESTORE_CURSOR), rd32(box, CTB_RESTORE_CURSOR + 4));
            life->g.modal_input = 0;
        }
        /* fall through */
    case 2:
    case 3:
        if (rd32(box, CTB_HAS_BUTTON) != 0) {
            return CAPTION_LIFECYCLE_ERR_UNSUPPORTED; /* 0x4e29ec / 0x4e2913 */
        }
        if (rd32(box, CTB_HAS_SLIDER) != 0) {
            status = slider_update(life, backend);
            if (status != CAPTION_LIFECYCLE_OK) {
                return status;
            }
        }
        /* The close test needs a button (0x4ee819..0x4ee843). */
        return CAPTION_LIFECYCLE_OK;
    default:
        return CAPTION_LIFECYCLE_OK;
    }
}

/* 0x4ee2a9 cursor selection and slider hover. */
static int popup_hover(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    uint8_t *box = life->box;
    CaptionLifecycleGlobals *g = &life->g;
    CaptionCursorGeometry geometry;
    int32_t state;

    if (g->cursor_override == 0) {
        if (g->held_item == -1) {
            g->cursor_type = 4;
            g->cursor_variant = 0;
            g->cursor_surface = g->default_cursor_surface;
        } else if (g->cursor_alt == 0) {
            g->cursor_type = wrap_add32(g->held_item, 0x25);
            g->cursor_variant = 0;
            g->cursor_surface = g->item_cursor_surface;
        } else {
            g->cursor_type = 9;
            g->cursor_variant = 0;
            g->cursor_surface = g->default_cursor_surface;
        }
    } else {
        g->cursor_type = 4;
        g->cursor_variant = 0;
        g->cursor_surface = g->default_cursor_surface;
    }
    g->cursor_src_index = wrap_add32(wrap_mul32(g->cursor_type, 8),
                                              wrap_mul32(g->cursor_variant, 4));
    g->cursor_layer_enabled = 1;
    if (backend->cursor_geometry == NULL ||
        backend->cursor_geometry(backend->context, g->cursor_type, g->cursor_variant,
                                 &geometry) != CAPTION_LIFECYCLE_BACKEND_OK) {
        return CAPTION_LIFECYCLE_ERR_BACKEND;
    }
    wr32(box, CTB_HOT_X, wrap_add32(g->cursor_rect.left, geometry.hot_dx));
    wr32(box, CTB_HOT_Y, wrap_add32(g->cursor_rect.top, geometry.hot_dy));
    g->cursor_hot[0] = rd32(box, CTB_HOT_X);
    g->cursor_hot[1] = rd32(box, CTB_HOT_Y);
    wr32(box, CTB_CURSOR_RECT, wrap_add32(g->cursor_rect.left, geometry.rect_dx));
    wr32(box, CTB_CURSOR_RECT + 8, wrap_add32(wrap_sub32(rd32(box, CTB_CURSOR_RECT), 1), geometry.width));
    wr32(box, CTB_CURSOR_RECT + 4, wrap_add32(g->cursor_rect.top, geometry.rect_dy));
    wr32(box, CTB_CURSOR_RECT + 12, wrap_add32(wrap_sub32(rd32(box, CTB_CURSOR_RECT + 4), 1), geometry.height));
    state = rd32(box, CTB_STATE);
    if (state == 2 || state == 3) {
        if (rd32(box, CTB_HAS_BUTTON) != 0) {
            return CAPTION_LIFECYCLE_ERR_UNSUPPORTED; /* 0x4e22fd */
        }
        if (rd32(box, CTB_HAS_SLIDER) != 0) {
            (void)slider_hit(life, (int16_t)rd32(box, CTB_HOT_X),
                             (int16_t)rd32(box, CTB_HOT_Y));
        }
    }
    return CAPTION_LIFECYCLE_OK;
}

/* ---- CScrollTextBox ------------------------------------------------------- */

static int valid(const CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    return life != NULL && backend != NULL && life->shared != NULL && life->geometry != NULL;
}

static int active_mode(const CaptionLifecycle *life)
{
    int32_t mode = rd32(life->box, CTB_MODE);
    return mode != 0 && mode != 1;
}

int caption_ctb_load_chunk(CaptionLifecycle *life, const CaptionLifecycleBackend *backend,
                           const uint8_t *sctb, size_t length)
{
    if (!valid(life, backend) || sctb == NULL) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    /* 0x4de394 copies 0x300 bytes, then reports a shorter chunk and quits;
     * native does not read past the supplied chunk. */
    if (length < CTB_SCTB_BYTES) {
        return fatal(backend, "CScrollTextBox::LoadChunk() - Too small");
    }
    memcpy(life->box + CTB_SCTB, sctb, CTB_SCTB_BYTES);
    return CAPTION_LIFECYCLE_OK;
}

int caption_ctb_init(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    int status;
    int open = 1;

    if (!valid(life, backend)) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    status = popup_init(life, backend, life->box + CTB_SCTB, 1);
    if (status != CAPTION_LIFECYCLE_OK) {
        return status;
    }
    return popup_poll(life, backend, &open, 0, NULL);
}

int caption_ctb_open(CaptionLifecycle *life, const CaptionLifecycleBackend *backend,
                     int32_t mode, uint8_t *text, size_t capacity)
{
    if (!valid(life, backend) || text == NULL || memchr(text, 0, capacity) == NULL) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    if (text[0] != '\0') {
        if (backend->write_framed_text == NULL) {
            return CAPTION_LIFECYCLE_ERR_BACKEND;
        }
        if (backend->write_framed_text(backend->context, text, capacity) !=
            CAPTION_LIFECYCLE_BACKEND_OK) {
            /* The writer's own failures are fatal in the original. */
            return CAPTION_LIFECYCLE_ERR_FATAL;
        }
    }
    life->shared->framed_ready = 1;
    life->g.framed_layer_enabled = 1;
    life->shared->frame_open = 1u;
    life->g.first_render_level = 1;            /* 0x43dbd5 */
    if (rd32(life->box, CTB_HAS_SLIDER) != 0) {  /* 0x4ee673(0) -> 0x4ef4f0 */
        wr32(life->box, S(SLD_POSITION), 0);
        wr32(life->box, S(SLD_DIRTY), 1);
    }
    wr32(life->box, CTB_MODE, mode);
    wr32(life->box, CTB_REQUESTED, mode);      /* 0x4edf96 */
    life->g.taskbar_mode = 2;                  /* 0x4e053f(2) */
    return CAPTION_LIFECYCLE_OK;
}

int caption_ctb_close(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    int status;

    if (!valid(life, backend)) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    wr32(life->box, CTB_MODE, 1);
    life->g.taskbar_mode = 1;                  /* 0x4e053f(1) */
    status = caption_taskbar_restore_area(life, backend); /* 0x4e1113 */
    if (status != CAPTION_LIFECYCLE_OK) {
        return status;
    }
    life->shared->framed_ready = 0;
    life->g.framed_layer_enabled = 0;
    wr32(life->box, CTB_MODE, 0);              /* 0x4de214 -> 0x4de1f5 */
    life->shared->frame_open = 0u;
    return CAPTION_LIFECYCLE_OK;
}

/* 0x4de440. */
static void scroll(CaptionLifecycle *life)
{
    int32_t position = rd32(life->box, CTB_HAS_SLIDER) != 0
                           ? rd32(life->box, S(SLD_POSITION))
                           : 0;
    int32_t view = wrap_sub32(tbox32(life, TBOX_FRAME_VIEW_BOTTOM),
                              tbox32(life, TBOX_FRAME_VIEW_TOP));
    float fraction = (float)((double)(float)position / 100.0);
    int32_t top;

    life->g.scroll_fraction = fraction;
    top = ftol((double)fraction * (double)(float)life->shared->framed_scroll_lines);
    if (top < tbox32(life, TBOX_FRAME_TOP)) {
        top = tbox32(life, TBOX_FRAME_TOP);
    } else if (wrap_add32(top, view) > tbox32(life, TBOX_FRAME_BOTTOM)) {
        top = wrap_sub32(tbox32(life, TBOX_FRAME_BOTTOM), view);
    }
    life->g.scroll_src.top = top;
    life->g.scroll_src.bottom = wrap_add32(top, view);
}

int caption_ctb_poll(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    int open = 1;
    int status;

    if (!valid(life, backend)) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    {
        int32_t mode = rd32(life->box, CTB_MODE);
        if (mode < 2 || mode > 3) {
            return CAPTION_LIFECYCLE_OK;
        }
    }
    if (rd32(life->box, CTB_HAS_SLIDER) != 0 &&
        !slider_visual_valid(rd32(life->box, S(SLD_VISUAL)))) {
        return CAPTION_LIFECYCLE_ERR_FORMAT;
    }
    status = popup_poll(life, backend, &open, 0, NULL);
    if (status != CAPTION_LIFECYCLE_OK) {
        return status;
    }
    if (!open) {
        status = caption_ctb_close(life, backend);
        if (status != CAPTION_LIFECYCLE_OK) {
            return status;
        }
    }
    scroll(life);
    return CAPTION_LIFECYCLE_OK;
}

int caption_ctb_hover(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    CaptionRect popup;
    const CaptionRect *c;

    if (!valid(life, backend)) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    if (!active_mode(life)) {
        return CAPTION_LIFECYCLE_OK;
    }
    if (rd32(life->box, CTB_HAS_SLIDER) != 0 &&
        !slider_visual_valid(rd32(life->box, S(SLD_VISUAL)))) {
        return CAPTION_LIFECYCLE_ERR_FORMAT;
    }
    popup = rect_at(life->box, CTB_NORMAL_DST);              /* 0x4ee644 */
    c = &life->g.cursor_rect;
    /* 0x4d57e8(cursor rect 0x583102, popup): cursor rect inside popup. */
    if (life->g.modal_input == 0 &&
        !(c->left < popup.left || popup.right < c->right || c->top < popup.top ||
          popup.bottom < c->bottom)) {
        return popup_hover(life, backend);
    }
    return CAPTION_LIFECYCLE_OK;
}

int caption_ctb_click(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    int32_t state;

    if (!valid(life, backend)) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    if (!active_mode(life)) {
        return CAPTION_LIFECYCLE_OK;
    }
    state = rd32(life->box, CTB_STATE);
    if ((state == 2 || state == 3) && rd32(life->box, CTB_HAS_BUTTON) != 0) {
        return CAPTION_LIFECYCLE_ERR_UNSUPPORTED; /* 0x4e26fc */
    }
    return CAPTION_LIFECYCLE_OK;
}

int caption_ctb_draw(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    uint8_t *box;
    int32_t state;
    int status;

    if (!valid(life, backend)) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    if (!active_mode(life)) {
        return CAPTION_LIFECYCLE_OK;
    }
    box = life->box;
    state = rd32(box, CTB_STATE);
    if (state != 2 && state != 3) {
        return CAPTION_LIFECYCLE_OK;
    }
    if (rd32(box, CTB_HAS_SLIDER) != 0 &&
        !slider_visual_valid(rd32(box, S(SLD_VISUAL)))) {
        return CAPTION_LIFECYCLE_ERR_FORMAT;
    }
    if (state == 2) {
        status = blit(backend, CAPTION_BLIT_OPAQUE, (uint32_t)rd32(box, CTB_POPUP_IMAGE),
                      rect_at(box, CTB_NORMAL_SRC), rect_at(box, CTB_NORMAL_DST),
                      "CUIPopup normal size object");
    } else {
        status = blit(backend, CAPTION_BLIT_OPAQUE, (uint32_t)rd32(box, CTB_POPUP_IMAGE),
                      rect_at(box, CTB_MAX_SRC), rect_at(box, CTB_MAX_DST),
                      "CUIPopup maximized object");
    }
    if (status != CAPTION_LIFECYCLE_OK) {
        return status;
    }
    if (rd32(box, CTB_HAS_BUTTON) != 0) {
        return CAPTION_LIFECYCLE_ERR_UNSUPPORTED; /* 0x4e2b99 */
    }
    if (rd32(box, CTB_HAS_SLIDER) != 0) {
        return slider_draw(life, backend);
    }
    return CAPTION_LIFECYCLE_OK;
}

/* Public common CUIPopup/CUISlider operations for CUIConvo. These avoid
 * CScrollTextBox's different outer hover gate, frame_open and close effects. */
int caption_popup_initialize(CaptionLifecycle *life, const CaptionLifecycleBackend *backend,
    const uint8_t *config, size_t length, int modal)
{
    if (!valid(life, backend) || !config || length < 0x2f0u) return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    return popup_init(life, backend, config, modal);
}
int caption_popup_poll(CaptionLifecycle *life, const CaptionLifecycleBackend *backend,
    int restore_cursor, void (*warp)(void *, int32_t, int32_t))
{
    if (!valid(life, backend)) return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    if (rd32(life->box, CTB_HAS_SLIDER) != 0 &&
        !slider_visual_valid(rd32(life->box, S(SLD_VISUAL)))) return CAPTION_LIFECYCLE_ERR_FORMAT;
    int open = 1;
    return popup_poll(life, backend, &open, restore_cursor, warp);
}
int caption_popup_slider_hover(CaptionLifecycle *life, int16_t x, int16_t y)
{
    if (!life) return 0;
    if (rd32(life->box, CTB_HAS_SLIDER) == 0) return 0;
    return slider_hit(life, x, y);
}
void caption_popup_scroll(CaptionLifecycle *life)
{
    if (life && life->geometry && life->shared) scroll(life);
}

/* ---- caption clear, timer, presentation ----------------------------------- */

void caption_clear_step(CaptionLifecycle *life)
{
    CaptionLifecycleGlobals *g = &life->g;

    g->caption_clear_counter = wrap16((int32_t)g->caption_clear_counter + 1);
    if (g->caption_clear_counter >= 0 && g->caption_clear_counter < 1) {
        g->caption_layer_enabled = 0;
        g->caption_restore_layer = 1;
        life->shared->caption_visible_flag = 0;
    } else {
        g->caption_restore_layer = 0;
        g->caption_clear_counter = -1;
        life->shared->caption_finish_flag = 0;
    }
}

int caption_clear_slot_step(CaptionLifecycle *life, int16_t slot, int *slot_done)
{
    CaptionLifecycleGlobals *g = &life->g;

    (void)slot;
    *slot_done = 0;
    g->caption_clear_counter = wrap16((int32_t)g->caption_clear_counter + 1);
    if (g->caption_clear_counter >= 0 && g->caption_clear_counter < 1) {
        g->caption_layer_enabled = 0;
        g->caption_restore_layer = 1;
        life->shared->caption_visible_flag = 0;
    } else {
        g->caption_restore_layer = 0;
        g->caption_clear_counter = -1;
        life->shared->caption_finish_flag = 0;
        *slot_done = 1; /* 0x42ae01: slot +0x42 (0x5bb625) = 1 */
    }
    return CAPTION_LIFECYCLE_OK;
}

void caption_timed_dismiss(CaptionLifecycle *life)
{
    CaptionLifecycleGlobals *g = &life->g;

    /* 0x4ea361: unsigned "deadline < clock". */
    if (g->timed_armed != 0 && g->timed_deadline < g->game_clock) {
        g->timed_armed = 0;
        life->shared->caption_finish_flag = 1;
    }
}

void caption_timed_arm(CaptionLifecycle *life, int16_t delay)
{
    life->g.timed_armed = 1;
    life->g.timed_deadline = life->g.game_clock + (uint32_t)(int32_t)delay;
}

void caption_framed_clear_step(CaptionLifecycle *life)
{
    CaptionLifecycleGlobals *g = &life->g;

    g->framed_clear_counter = wrap16((int32_t)g->framed_clear_counter + 1);
    if (g->framed_clear_counter >= 0 && g->framed_clear_counter < 1) {
        g->framed_layer_enabled = 0;
        g->convo_restore_layer = 1;
        life->shared->framed_ready = 0;
    } else {
        g->convo_restore_layer = 0;
        g->framed_clear_counter = -1;
        g->framed_clear_request = 0;
    }
}

int caption_main_loop_flags(CaptionLifecycle *life)
{
    CaptionLifecycleGlobals *g;

    if (life == NULL || life->shared == NULL) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    g = &life->g;
    /* 0x43d0b4..0x43d125. */
    g->framed_layer_enabled = (g->framed_clear_request == 0 && life->shared->framed_ready != 0);
    if (g->framed_clear_request != 0) {
        caption_framed_clear_step(life);
    }
    g->caption_layer_enabled = (life->shared->caption_finish_flag == 0 &&
                                life->shared->caption_visible_flag != 0);
    if (life->shared->caption_finish_flag != 0) {
        caption_clear_step(life);
    }
    caption_timed_dismiss(life);
    return CAPTION_LIFECYCLE_OK;
}

int caption_scene_reset(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    CaptionLifecycleGlobals *g;
    int status;

    if (!valid(life, backend)) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    g = &life->g;
    status = caption_ctb_close(life, backend);              /* 0x438da7 */
    if (status != CAPTION_LIFECYCLE_OK) {
        return status;
    }
    g->framed_clear_request = 0;                            /* 0x438db6 */
    g->framed_clear_counter = -1;                           /* 0x438dd2 */
    g->scroll_fraction = 0.0f;                              /* 0x438de4 */
    life->shared->framed_ready = 0;                         /* 0x438df7 */
    /* 0x438e58: scroll lines = framed height - view height. */
    life->shared->framed_scroll_lines = wrap16(wrap_sub32(
        wrap_add32(wrap_sub32(tbox32(life, TBOX_FRAME_BOTTOM),
                               tbox32(life, TBOX_FRAME_TOP)), 1),
        wrap_add32(wrap_sub32(tbox32(life, TBOX_FRAME_VIEW_BOTTOM),
                              tbox32(life, TBOX_FRAME_VIEW_TOP)), 1)));
    g->scroll_src.top = ftol((double)g->scroll_fraction *
                             (double)(float)life->shared->framed_scroll_lines);
    g->scroll_src.bottom = wrap_add32(
        g->scroll_src.top,
        wrap_sub32(tbox32(life, TBOX_FRAME_VIEW_BOTTOM),
                   tbox32(life, TBOX_FRAME_VIEW_TOP)));
    g->scroll_src.left = tbox32(life, TBOX_FRAME_LEFT);
    g->scroll_src.right = tbox32(life, TBOX_FRAME_RIGHT);
    life->shared->caption_finish_flag = 0;                  /* 0x438f08 */
    g->caption_clear_counter = -1;                          /* 0x438f12 */
    life->shared->caption_visible_flag = 0;                 /* 0x438f1b */
    return CAPTION_LIFECYCLE_OK;
}

int caption_taskbar_restore_cc(CaptionLifecycle *life, const CaptionLifecycleBackend *backend)
{
    if (!valid(life, backend)) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    if (life->taskbar.saved_surface == 0u) {
        return CAPTION_LIFECYCLE_OK;
    }
    return blit(backend, CAPTION_BLIT_OPAQUE, life->taskbar.saved_surface,
                life->taskbar.cc_rect, life->taskbar.cc_rect,
                "CUITaskBar::RestoreCCTextBox");
}

int caption_taskbar_restore_area(CaptionLifecycle *life,
                                 const CaptionLifecycleBackend *backend)
{
    if (!valid(life, backend)) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    if (life->taskbar.saved_surface == 0u) {
        return CAPTION_LIFECYCLE_OK;
    }
    return blit(backend, CAPTION_BLIT_OPAQUE, life->taskbar.saved_surface,
                life->taskbar.area_src, life->taskbar.area_dst,
                "CUITaskBar::RestoreTaskbarArea()");
}

int caption_present_layers(CaptionLifecycle *life, const CaptionLifecycleBackend *backend,
                           uint32_t caption_surface, uint32_t framed_surface,
                           const CaptionRect *framed_dst)
{
    int status;

    if (!valid(life, backend) || framed_dst == NULL) {
        return CAPTION_LIFECYCLE_ERR_ARGUMENT;
    }
    /* z 0x11: layer 9 (0x4d3705 -> 0x4e79ca), then layer 11 (0x4d3714 ->
     * 0x4e1157). */
    if (life->g.convo_restore_layer != 0) {
        if (backend->convo_restore == NULL) {
            return CAPTION_LIFECYCLE_ERR_UNSUPPORTED;
        }
        if (backend->convo_restore(backend->context) != CAPTION_LIFECYCLE_BACKEND_OK) {
            return CAPTION_LIFECYCLE_ERR_BACKEND;
        }
    }
    if (life->g.caption_restore_layer != 0) {
        status = caption_taskbar_restore_cc(life, backend);
        if (status != CAPTION_LIFECYCLE_OK) {
            return status;
        }
    }
    /* z 0x12 in table order: layer 8 (framed, opaque), layer 10 (caption,
     * keyed). */
    if (life->g.framed_layer_enabled != 0) {
        CaptionRect src = life->g.scroll_src;
        status = blit(backend, CAPTION_BLIT_OPAQUE, framed_surface, src, *framed_dst,
                      "RenderMainDisplay() ZRENDER layer 8");
        if (status != CAPTION_LIFECYCLE_OK) {
            return status;
        }
    }
    if (life->g.caption_layer_enabled != 0) {
        CaptionRect src = rect_at(life->geometry->tbox, TBOX_CAPTION_VIEW);
        status = blit(backend, CAPTION_BLIT_KEYED, caption_surface, src,
                      life->taskbar.cc_rect, "RenderMainDisplay() ZRENDER layer 10");
        if (status != CAPTION_LIFECYCLE_OK) {
            return status;
        }
    }
    return CAPTION_LIFECYCLE_OK;
}

const char *caption_lifecycle_status_string(int status)
{
    switch (status) {
    case CAPTION_LIFECYCLE_OK: return "ok";
    case CAPTION_LIFECYCLE_ERR_ARGUMENT: return "invalid argument";
    case CAPTION_LIFECYCLE_ERR_FORMAT: return "malformed lifecycle data";
    case CAPTION_LIFECYCLE_ERR_UNSUPPORTED: return "branch not ported (unreachable with shipped data)";
    case CAPTION_LIFECYCLE_ERR_FATAL: return "original fatal path";
    case CAPTION_LIFECYCLE_ERR_BACKEND: return "lifecycle backend failure";
    default: return "unknown lifecycle status";
    }
}
