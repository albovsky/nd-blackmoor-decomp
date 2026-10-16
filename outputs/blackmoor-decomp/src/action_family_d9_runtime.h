#ifndef BLACKMOOR_ACTION_FAMILY_D9_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_D9_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xd9, the Mouselight puzzle (RT-24).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the
 * disassembly:
 *   0x427a50  dispatcher arm 0xd9 (0x42a383): gate 0x423f57(deps, 0), then
 *             0x47d788(ECX = 0x6246dc, row). The object is one static singleton.
 *   0x47d682  loader (0x40b34a): copies the 0x23 typed body into a fresh row
 *             allocation (row pData at 0x5bb5e5 + row * 0x8d).
 *   0x47d788  the handler, a phase switch on the row phase dword
 *             (0x5bb632 + row * 0x8d): 0 init, 1 running. There is no phase 2:
 *             the row never completes, it is torn down by the scene clear.
 *   0x47d734  pointer-move receiver (0x4f0059 -> 0x4f0fdc), 0x47d640 slot
 *             invalidate (0x43d7f0), 0x47d59b cleanup (scene clear 0x4381f4 and
 *             0x43dbe3), 0x47d4f7 reset.
 *   0x47df57  the render callback of generic Z entry type 10 (slot 0x18..0x3f,
 *             stride 0x4a at 0x5d1591): one restore blit 0x4c5377 of the previous
 *             window, then 0x4c62f0 (alpha, mode byte != 0) or 0x4c6929 (mask).
 *
 * Typed body (0x23 bytes): +0x00 NUL-terminated name of the puzzle image
 * (CIFTREE, loaded through 0x4c2790 as "DF_MouselightPuzzle_Surface"), +0x21
 * radius byte, +0x22 mode byte (0 hard-edged mask, else a gaussian alpha map).
 *
 * The singleton is modelled by D9Object. Every engine call whose body lies
 * outside this slice is a callback of D9Host in the original order. The
 * allocations of 0x51dc43 are owned by the object; the original frees them in
 * 0x47d59b. Nothing here claims original source structure. */

#define D9_RUNTIME_TYPE UINT8_C(0xd9)
#define D9_BODY_BYTES 0x23u
#define D9_NAME_BYTES 0x21u
#define D9_NO_SLOT (-1)
#define D9_POINTER_INIT (-500) /* 0x47d4f7 stores 0xfe0c into +0x25/+0x27 */
#define D9_SLOT_FIRST 0x18     /* 0x4d39f9 searches 0x18..0x3f */
#define D9_SLOT_LAST 0x3f

typedef enum D9Status {
    D9_OK = 0,
    D9_ERR_ARGUMENT = 1,
    D9_ERR_BODY = 2,
    D9_ERR_UNSUPPORTED = 3,
    D9_ERR_HOST = 4,
    D9_ERR_MEMORY = 5,
    D9_ERR_BOUNDS = 6
} D9Status;

/* Window and scene rectangles the handler reads (all process globals). */
typedef struct D9View {
    int32_t origin_x; /* 0x583186 */
    int32_t origin_y; /* 0x58318a */
    int32_t bottom;   /* 0x583192 */
    int32_t max_x;    /* 0x5831ae: right edge of the third VIEW rectangle */
    int32_t max_y;    /* 0x5831b2: bottom edge of the third VIEW rectangle */
} D9View;

/* The process globals phase 0 writes. */
typedef struct D9World {
    int32_t start_flag_5bb1ca;
} D9World;

/* The singleton at 0x6246dc. Offsets are object offsets; +0x1c (active) is not
 * cleared by the reset 0x47d4f7, which is why it stays set after a cleanup. */
typedef struct D9Object {
    uint8_t active;       /* +0x1c */
    int16_t row;          /* +0x1d */
    uint32_t surface;     /* +0x1f puzzle image handle, 0 none */
    int16_t slot;         /* +0x23 generic Z entry */
    int16_t pointer_x;    /* +0x25 */
    int16_t pointer_y;    /* +0x27 */
    int32_t rect[4];      /* +0x29 left, +0x2d top, +0x31 right, +0x35 bottom */
    int32_t prev[4];      /* +0x39 left, +0x3d top, +0x41 right, +0x45 bottom */
    uint8_t *composite;   /* +0x49 allocated 16 * r * r bytes, never used afterwards */
    float *alpha;         /* +0x4d (2r)^2 floats */
    uint8_t *mask;        /* +0x51 (2r)^2 bytes */
    int16_t radius;       /* +0x55 */
    uint8_t tracking;     /* +0x57 */
} D9Object;

typedef enum D9Effect {
    D9_FX_TRACKING = 1,     /* +0x57 := 1 */
    D9_FX_START_FLAG = 2,   /* 0x5bb1ca := 1 */
    D9_FX_ALLOC = 3,        /* 0x51dc43(a bytes), b = buffer (0 composite, 1 alpha, 2 mask) */
    D9_FX_SLOT = 4,         /* 0x4d39f9 returned a */
    D9_FX_SLOT_REGISTER = 5,/* type 10, callback 0x47df57, flags 0/0/1/1, label */
    D9_FX_SURFACE_LOAD = 6, /* 0x4c2790 returned a */
    D9_FX_SLOT_SURFACE = 7, /* slot surface := a */
    D9_FX_PHASE = 8,        /* row phase := a */
    D9_FX_RELEASE_SURFACE = 9,
    D9_FX_RELEASE_SLOT = 10,
    D9_FX_FREE = 11         /* 0x51dc6c, b as D9_FX_ALLOC */
} D9Effect;

typedef struct D9Host {
    void *context;
    /* 0x4d39f9: first free generic Z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 10, callback 0x47df57, surface (the
     * object's current handle, 0 on a first visit), flags 0, 0, 1, 1, word 0
     * and the label "MOUSELIGHT PUZZLE BITMAP". */
    int (*register_slot)(void *, int16_t slot, uint32_t surface, const char *label);
    /* 0x4c2790("CIFTREE", name, 6, "DF_MouselightPuzzle_Surface"). */
    int (*load_surface)(void *, const char *name, uint32_t *surface);
    /* Entry surface store (0x5d1599). */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x47d640: entry +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* The engine rectangles named in D9View. */
    int (*view)(void *, D9View *out);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} D9Host;

typedef struct D9Result {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
} D9Result;

/* 0x47d4f7 plus the constructor state: slot -1, row -1, pointer -500, no
 * buffers, surface 0 (a power-on object). */
void d9_object_reset(D9Object *object);

/* Native safety check of a typed body. Not an original check: the original
 * trusts the loader. Radius 0 is rejected, everything else is accepted. */
int d9_validate_body(const uint8_t *body, size_t length, const char **failure);

/* The alpha value 0x47d788 stores for an offset: exp(-(d2^2) / (r^4 / 2)) as a
 * float with the original's int32 and float conversions, or 0 when the
 * distance is not below the radius. */
float d9_alpha_at(int32_t radius, int32_t dx, int32_t dy);

/* One true-gate visit of 0x47d788. Validation precedes the first effect; a
 * status other than D9_OK before the first effect leaves everything untouched.
 * A host failure after effects returns D9_ERR_HOST (the original has no
 * recovery); the session must stop. `failure` is optional. */
int d9_step(D9Object *object, const uint8_t *body, size_t body_length, int16_t row,
            uint32_t phase, D9World *world, const D9Host *host, D9Result *result,
            const char **failure);

/* 0x47d734. Returns 0 always, like the original. */
int d9_pointer_move(D9Object *object, int16_t x, int16_t y);

/* 0x47d640. */
int d9_invalidate(D9Object *object, const D9Host *host);

/* 0x47d59b: release surface, buffers and slot, then the 0x47d4f7 reset. */
int d9_cleanup(D9Object *object, const D9Host *host);

/* Geometry of one 0x47df57 call. `valid` is 0 when the object is not active
 * (no blit at all). Rectangles are left, top, right, bottom (inclusive). */
typedef enum D9BlitKind { D9_BLIT_MASK = 0, D9_BLIT_ALPHA = 1 } D9BlitKind;

typedef struct D9RenderPlan {
    uint8_t valid;
    int32_t restore_src[4]; /* previous window, view relative (0x4c5377 source) */
    int32_t restore_dst[4]; /* the same plus the view origin */
    D9BlitKind kind;
    uint32_t surface;       /* the entry surface (puzzle image) */
    int32_t src[4];         /* current window, view relative */
    int32_t dst[4];         /* current window plus the view origin */
    int32_t map[4];         /* mask or alpha rectangle (local_38..local_2c) */
} D9RenderPlan;

/* `body` is the typed body of object->row. */
int d9_render_plan(const D9Object *object, const uint8_t *body, size_t body_length,
                   const D9View *view, D9RenderPlan *plan);

/* ---- pixel operations (16 bits per pixel), mirrors of 0x4c5377, 0x4c6929 and
 * 0x4c62f0. The original runs them on locked DirectDraw surfaces; here a
 * surface is plain memory. All bounds are checked before the first write. */
typedef struct D9Surface {
    uint8_t *pixels;
    size_t byte_length;
    int32_t pitch_bytes;
} D9Surface;

/* 0x5d2f1b/1a/19 channel shifts and 0x5d2f1f/1e/1d channel masks. */
typedef struct D9PixelFormat {
    uint8_t shift[3];
    uint8_t mask[3];
} D9PixelFormat;

/* 0x4c5377 DFBltNoTrans: opaque copy of equally sized rectangles. */
int d9_blit_copy(const D9Surface *src, D9Surface *dst, const int32_t src_rect[4],
                 const int32_t dst_rect[4]);

/* 0x4c6929 DFBltMaskTransPlain: copy the pixels whose mask byte is nonzero.
 * The mask is addressed as map_rect.top * (map_rect.right + 1) + map_rect.left
 * with a row stride of map_rect.right + 1. */
int d9_blit_mask(const D9Surface *src, D9Surface *dst, const uint8_t *mask,
                 size_t mask_bytes, const int32_t src_rect[4], const int32_t dst_rect[4],
                 const int32_t map_rect[4]);

/* 0x4c62f0 DFBltAlpha: dst = bg + trunc((puzzle - bg) * alpha) per channel,
 * combined as the original does (16-bit wrap, OR of shifted channels). */
int d9_blit_alpha(const D9Surface *puzzle, const D9Surface *bg, D9Surface *dst,
                  const float *alpha, size_t alpha_count, const int32_t puzzle_rect[4],
                  const int32_t bg_rect[4], const int32_t dst_rect[4],
                  const int32_t map_rect[4], const D9PixelFormat *format);

#ifdef __cplusplus
}
#endif
#endif
