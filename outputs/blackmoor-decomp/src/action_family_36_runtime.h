#ifndef BLACKMOOR_ACTION_FAMILY_36_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_36_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of the 0x36 static overlay family (COverlay), RT-14.
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), all confirmed in the
 * disassembly:
 *   0x4280b4  dispatcher arm 0x36: gate 0x423f57 mode 1, then
 *             0x4899ca(ECX=0x619935 overlay manager, row)
 *   0x4899ca  COverlay::Process, ONE function with the phase switch on the row
 *             phase dword (0x5bb632 + row*0x8d): 0 init, 1 wait, 2 finish.
 *             Phase 0 falls through into phase 1 in the same call.
 *   0x48a3db  render callback, registered per overlay in the render table
 *   0x4897cd  COverlay hit test, called from the pointer cascade 0x4f0059 at
 *             0x4f104f BEFORE its generic row scan
 *   0x4d39f9  first free render slot in 24..63 (entry+0x18 == 0)
 *   0x4c948f  first free surface cache slot in 0..23
 *   0x42ba3a  finish helper (subtype 1: completion byte; subtype 2: clear it
 *             and reset the dependency tree; both: phase := 0)
 *
 * The kernel works on the row's 0xABA-byte image exactly as the original does
 * (same offsets, see the OV36_* constants), so registers/runtime fields can be
 * compared byte for byte against the original. Raw 0x37/0x38 share the same
 * function and image layout; only the raw 0x36 constructor (A-36.1) is bound
 * by RT-14. Nothing here claims original source structure. */

#define OVERLAY36_RAW_TYPE UINT8_C(0x36)
#define OVERLAY36_IMAGE_BYTES 0xABAu
#define OVERLAY36_MAX_ROWS 240u
#define OVERLAY36_LIST_LIMIT 40
#define OVERLAY36_SLOTS 64
#define OVERLAY36_FIRST_SLOT 24
#define OVERLAY36_CACHE_SLOTS 24
#define OVERLAY36_EVENT_PAIRS 10
#define OVERLAY36_NAME_BYTES 0x21u
#define OVERLAY36_TAG "OVERLAY ZRENDER"

/* Image field offsets (bytes). Words are little-endian; "s16" fields are read
 * with MOVSX. */
enum {
    OV36_NAME = 0x00,       /* 33 bytes, NUL terminated string */
    OV36_FLAG_21 = 0x21,    /* s16: 1 -> [0x5bb1ca] := 0 on finish, else 1 */
    OV36_PLAIN_23 = 0x23,   /* s16: 1 -> plain (opaque) blit */
    OV36_ACTION_25 = 0x25,  /* s16: 1 -> finish writes the scene-change words */
    OV36_LAYER = 0x27,      /* s16: render layer */
    OV36_MARKER = 0x29,     /* s16: 1 static, 2 animated */
    OV36_PRIMARY_COUNT = 0x2b,
    OV36_DIRECTION = 0x2d,  /* s16: 1 forward, 2 backward */
    OV36_LOOP = 0x2f,       /* s16: 1 stop at end, 2 wrap */
    OV36_FRAME_INIT = 0x31, /* s16 */
    OV36_FRAME_FIRST = 0x33,
    OV36_FRAME_LAST = 0x35,
    OV36_FPS = 0x37,        /* s16 */
    OV36_EVENT_INDEX = 0x39, /* s16, -1 none */
    OV36_EVENT_VALUE = 0x3b, /* s16 */
    OV36_XFER_3D = 0x3d,    /* s16 -> 0x5bb57b (dword) */
    OV36_XFER_3F = 0x3f,    /* s16 -> 0x5bb599 */
    OV36_XFER_41 = 0x41,    /* s16 -> 0x5bb595 */
    OV36_XFER_43 = 0x43,    /* s16 -> 0x5c39ff */
    OV36_XFER_45 = 0x45,    /* s32 -> 0x5bb59b */
    OV36_XFER_49 = 0x49,    /* s32 -> 0x5bb59f */
    OV36_XFER_4D = 0x4d,    /* s32 -> 0x5bb5a3 */
    OV36_EVENT_PAIRS = 0x51, /* 10 x (s16 index, s16 value) */
    OV36_SOUND = 0x79,      /* sound record; "NO SOUND\0" = none */
    OV36_SOUND_WORD = 0x9a, /* u16 */
    OV36_SECONDARY_COUNT = 0xaa,
    OV36_PRIMARY = 0xac,    /* 16 bytes each (left, top, right, bottom dwords) */
    OV36_SECONDARY = 0x6ec, /* 38 bytes each */
    /* runtime fields written by the process function */
    OV36_RT_SLOT = 0xaa2,     /* s16 render slot */
    OV36_RT_CACHE = 0xaa4,    /* s16 surface cache slot, -1 none */
    OV36_RT_INTERVAL = 0xaa6, /* u32 animation interval in ms */
    OV36_RT_NEXT = 0xaaa,     /* u32 next animation tick */
    OV36_RT_FRAME = 0xaae,    /* s16 current animation frame */
    OV36_RT_ROW = 0xab0,      /* s16 owning action row */
    OV36_RT_ENABLED = 0xab2,  /* u32 */
    OV36_RT_SURFACE = 0xab6   /* u32 surface handle */
};

/* Secondary record (0x26 bytes) field offsets. */
enum {
    OV36_SEC_FRAME = 0x00,   /* s16 compared with the selector 0x5bb50b */
    OV36_SEC_PRIMARY = 0x02, /* s16 primary record used unless marker == 2 */
    OV36_SEC_HOT = 0x04,     /* s16 1 = hit-testable */
    OV36_SEC_SRC_LEFT = 0x06,   /* s32 offsets added to the primary record */
    OV36_SEC_SRC_TOP = 0x0a,
    OV36_SEC_SRC_RIGHT = 0x0e,
    OV36_SEC_SRC_BOTTOM = 0x12,
    OV36_SEC_DST_LEFT = 0x16,   /* s32 destination (viewport relative) */
    OV36_SEC_DST_TOP = 0x1a,
    OV36_SEC_DST_RIGHT = 0x1e,
    OV36_SEC_DST_BOTTOM = 0x22
};

typedef enum {
    OVERLAY36_OK = 0,
    OVERLAY36_ERR_ARGUMENT = 1,
    /* A required host provider is absent. Nothing was changed. */
    OVERLAY36_ERR_UNSUPPORTED = 2,
    /* Unsafe original behaviour refused (unterminated name, record or event
     * index outside the modeled arrays, list/slot exhaustion that the original
     * handles with an error report and teardown). Nothing was changed. */
    OVERLAY36_ERR_BOUNDS = 3,
    /* A provider failed after earlier effects were already committed (the
     * original has no recovery either). The session must stop. */
    OVERLAY36_ERR_HOST = 4
} Overlay36Status;

/* One entry of the render table 0x5d1591 (stride 0x4a). Only the fields the
 * overlay family reads or writes are kept. */
typedef struct {
    int32_t layer;       /* +0x00 */
    int32_t callback;    /* +0x04 nonzero: the overlay render callback */
    uint32_t surface;    /* +0x08 */
    int32_t field_0c;    /* +0x0c */
    int32_t field_10;    /* +0x10 */
    int32_t visible;     /* +0x14 */
    int32_t active;      /* +0x18 */
    int32_t row;         /* +0x1e image pointer, as the owning row; -1 none */
    char tag[16];        /* +0x22 */
} Overlay36Render;

/* The overlay manager (0x619935) plus the shared tables it uses. */
typedef struct {
    int32_t count;                     /* +0xcc */
    int32_t list[OVERLAY36_LIST_LIMIT]; /* +0x2c, owning rows in registration order */
    int32_t current_row;               /* +0x1c / +0x20, -1 none */
    int32_t current_record;            /* +0x24, secondary index or -1 */
    uint32_t tick;                     /* +0x28 */
    uint32_t cache[OVERLAY36_CACHE_SLOTS]; /* 0x5d02cb surface cache, 0 free */
    Overlay36Render render[OVERLAY36_SLOTS];
} Overlay36Manager;

/* Process globals the family reads or writes. The host copies them in and out
 * around a call. */
typedef struct {
    int32_t *events;          /* 0x585801 dword array (event flags) */
    size_t event_count;
    int16_t selector;         /* 0x5bb50b */
    int16_t held_item;        /* 0x583a29, -1 none */
    int32_t start_flag_5bb1ca;
    int32_t mode_583999;
    int32_t xfer_5bb57b;
    int16_t xfer_5bb599, xfer_5bb595, xfer_5c39ff;
    int32_t xfer_5bb59b, xfer_5bb59f, xfer_5bb5a3;
    int32_t redraw_5831c8;
    int16_t redraw_5831c6;
    /* drawing */
    int32_t view_x_583186, view_y_58318a;
    uint32_t background_surface_5d15e3;
    uint32_t autotext_surface[3];       /* 0x5d0397, 0x5d039b, 0x5d039f */
    /* hit test */
    int32_t item_flag_5b44f8;
    int32_t cursor_index_5b44f0, cursor_variant_5b44f4;
    int32_t cursor_surface_5d162d, cursor_table_5d1631, cursor_layer_5d1639;
    int32_t cursor_surface_default_5d0377, cursor_surface_held_571ad3;
    int32_t candidate_5c39e5;
} Overlay36World;

typedef struct {
    int kind;            /* OVERLAY36_BLIT_* */
    int row;
    int slot;
    uint32_t source_surface;
    uint32_t destination_marker; /* 0x5cf665 is the host back buffer */
    int32_t src[4];      /* left, top, right, bottom */
    int32_t dst[4];
    const char *label;
} Overlay36Blit;

enum { OVERLAY36_BLIT_PLAIN = 1, OVERLAY36_BLIT_TRANSPARENT = 2 };

/* Ordered effect markers for oracles and tests. a/b are the values noted. */
enum {
    OV36_FX_BEGIN = 1,        /* a = row, b = phase before */
    OV36_FX_IMAGE_INIT,       /* a = row (runtime fields initialised) */
    OV36_FX_LIST_PUSH,        /* a = list index, b = row */
    OV36_FX_SOUND_START,      /* a = row, b = sound word */
    OV36_FX_START_FLAG,       /* a = value */
    OV36_FX_REDRAW,           /* a = 0x5831c8, b = 0x5831c6 */
    OV36_FX_REQUEST_CLEAR,    /* a = row */
    OV36_FX_CACHE_REUSE,      /* a = cache slot, b = surface */
    OV36_FX_AUTOTEXT,         /* a = 1..3, b = surface */
    OV36_FX_SURFACE_LOAD,     /* a = cache slot, b = surface */
    OV36_FX_SLOT,             /* a = render slot */
    OV36_FX_RENDER_STORE,     /* a = render slot, b = layer */
    OV36_FX_ANIM_INIT,        /* a = interval, b = next tick */
    OV36_FX_PHASE,            /* a = new phase */
    OV36_FX_ANIM_STEP,        /* a = frame, b = next tick */
    OV36_FX_SOUND_STOP,       /* a = row */
    OV36_FX_EVENT_WRITE,      /* a = index, b = value */
    OV36_FX_TRANSFER,         /* a = target scene word (+0x3d) */
    OV36_FX_FINISH,           /* a = row (0x42ba3a) */
    OV36_FX_HIT,              /* a = row, b = record */
    OV36_FX_CURSOR,           /* a = cursor index, b = variant */
    OV36_FX_BLIT              /* a = slot, b = kind */
};

typedef struct {
    void *context;
    /* 0x4c2790(ECX=0x5cf659, "CIFTREE", name, 6, ...): load the named
     * resource image as a surface handle (nonzero). Nonzero return = failure. */
    int (*load_surface)(void *context, const char *name, uint32_t *surface);
    /* 0x4fb77a(sound record) then 0x4fb2e3(word): start the clip. */
    int (*sound_start)(void *context, const uint8_t *record, uint16_t word);
    /* 0x4f6334(word): nonzero while the clip is still playing. */
    int (*sound_is_playing)(void *context, uint16_t word, int *playing);
    /* 0x4fba69(sound record). */
    int (*sound_stop)(void *context, const uint8_t *record);
    /* GetTickCount (IAT 0x52a23c). */
    int (*tick_count)(void *context, uint32_t *ticks);
    /* Phase dword of an action row (0x5bb632 + row*0x8d). */
    int (*row_phase)(void *context, int32_t row, uint32_t *phase);
    /* 0x4c5377 / 0x4c5d4b with the back buffer 0x5cf665 as destination. */
    int (*blit)(void *context, const Overlay36Blit *op);
    /* Optional ordered observer (NULL in production). */
    void (*observe)(void *context, int effect, int32_t a, int32_t b);
} Overlay36Host;

/* Per-row images, indexed by action row. A NULL entry is not an overlay row. */
typedef struct {
    uint8_t *const *images;
    size_t count;
} Overlay36Rows;

typedef struct {
    uint32_t phase_after;
    uint8_t registered;  /* phase 0 ran */
    uint8_t finished;    /* phase 2 ran 0x42ba3a */
} Overlay36StepResult;

void overlay36_manager_reset(Overlay36Manager *manager);

/* COverlay::Process for one visit of a row (dispatcher arm 0x4280b4), after
 * the dependency gate was true. `phase` is the row's phase dword at entry.
 * Phase 0 registers the overlay and continues into phase 1 in the same call. */
int overlay36_step(Overlay36Manager *manager, const Overlay36Rows *rows, int32_t row,
                   uint32_t phase, Overlay36World *world, const Overlay36Host *host,
                   Overlay36StepResult *result, const char **why);

/* COverlay hit test (0x4897cd). x, y are the logical pointer coordinates the
 * cascade passes (0x5e, 0x5a). On a hit it also performs the cursor stores of
 * 0x4897cd and sets 0x5c39e5. Returns OVERLAY36_OK; *hit is 0/1 and *row the
 * hit row. */
int overlay36_hit_test(Overlay36Manager *manager, const Overlay36Rows *rows,
                       int16_t x, int16_t y, Overlay36World *world,
                       const Overlay36Host *host, int *hit, int32_t *row,
                       const char **why);

/* Read-only variant used to export the hot rectangles to a first-containing
 * scan: EVERY secondary record (hot word 1, frame == selector) of every
 * enabled overlay whose owning row is at phase 1, in list order and record
 * order inside an overlay. Scanning the result for the first rectangle that
 * contains the point gives the row overlay36_hit_test would pick. No
 * manager/world mutation; the hit test's cursor stores are not part of it.
 * *count is the number found even when it exceeds capacity (then
 * OVERLAY36_ERR_BOUNDS is returned and only `capacity` entries are filled). */
typedef struct {
    int32_t row;
    int32_t record;
    int32_t left, top, right, bottom;
} Overlay36HotRect;
int overlay36_hot_rects(const Overlay36Manager *manager, const Overlay36Rows *rows,
                        int16_t selector, const Overlay36Host *host,
                        Overlay36HotRect *out, size_t capacity, size_t *count);

/* 0x48a3db for one render slot. */
int overlay36_draw_slot(Overlay36Manager *manager, const Overlay36Rows *rows, int slot,
                        const Overlay36World *world, const Overlay36Host *host,
                        const char **why);

/* The render pass 0x4cf9f4 restricted to the overlay table: layers lo..hi
 * inclusive, slot order inside a layer, only visible+active entries with the
 * overlay callback. */
int overlay36_render_layers(Overlay36Manager *manager, const Overlay36Rows *rows,
                            int32_t layer_lo, int32_t layer_hi, const Overlay36World *world,
                            const Overlay36Host *host, size_t *drawn, const char **why);

#ifdef __cplusplus
}
#endif
#endif
