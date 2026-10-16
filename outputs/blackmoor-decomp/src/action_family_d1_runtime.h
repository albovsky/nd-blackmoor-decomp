#ifndef BLACKMOOR_ACTION_FAMILY_D1_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_D1_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xd1, the Turning Puzzle (RT-35; the corpus is the six-wheel word lock "HID_WordLock02_OVL").
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0xd1 (0x42a175): gate 0x423f57(deps, 0), then 0x4b64a9(ECX = 0x61d449, row).
 *             The object (CTurningPuzzle, 0x278 bytes) is one static singleton.
 *   0x4b5c5c  loader (0x40b34a, 0x4103ee): copies the 927-byte typed body into a fresh row allocation (pData at
 *             0x5bb5e5 + row * 0x8d); src/action_family_d1.[ch] decodes it.
 *   0x4b64a9  the handler: a phase switch on the row phase dword (0x5bb632 + row * 0x8d). Phase 0 init, phase 1 an
 *             inner state machine on obj+0x274 (0..5), phase 2 finish. Phase 2 applies the scene change / variable
 *             store of the win block (body +0x32a) or the exit block (+0x376), calls 0x42ba3a (the generic
 *             completion) and cleans up with 0x4b5bc8.
 *   0x4b6355  tile geometry helper. 0x4b642d solved check. 0x4b5d17 pointer hit test (the cascade 0x4f0059 at
 *             0x4f0b1e, x = [ptr+0x5e], y = [ptr+0x5a], view relative). 0x4b6097 cursor / candidate writer.
 *             0x4b617a click handler (the accepted-release chain, 0x43b287). 0x4b5c11 slot invalidate (0x43d91f).
 *             0x4b5bc8 / 0x4b5b8a cleanup and reset. 0x4b7051 the render callback of generic Z entry type 10:
 *             one opaque blit (0x4c5377) per tile from the puzzle image.
 *
 * Typed body, offsets from the start of the 927-byte body (words are signed, dwords signed):
 *   +0x00 NUL-terminated name of the overlay image (CIFTREE, "Turning Puzzle Surface")
 *   +0x21 tile count N (word, 0..16 natively), +0x23 frames per tile F, +0x25 sub-steps S per frame
 *   +0x27 + 2*i initial frame of tile i
 *   +0x47 + 16*i  destination rectangle (left, top, right, bottom as dwords, view relative)
 *   +0x147 + 16*i hit rectangle (left, top, right, bottom, inclusive)
 *   +0x247 per-tile row flag, +0x248 / +0x24c source origin, +0x250 / +0x252 tile width / height
 *   +0x254 + 8*i  four linked tile numbers (1-based, 0 none) that turn with tile i
 *   +0x2d4 T, +0x2d6 flag, +0x2d7 M (animation pacing), +0x2d9 sound record 0 (turn sound, channel word at +0x2fa)
 *   +0x30a + 2*i  target frame of tile i
 *   +0x32a win block, +0x345 sound record 1 (channel word at +0x366), +0x376 exit block, +0x38f exit rectangle
 * A scene block is: scene word (9999 = none), three words, three dwords, start-flag word, event-flag index word
 * (-1 none) and a value byte.
 *
 * Every engine call whose body lies outside this slice is a callback of D1Host in the original order. Nothing here
 * claims original source structure. */

#define D1_RUNTIME_TYPE UINT8_C(0xd1)
#define D1_BODY_BYTES 927u
#define D1_NAME_BYTES 0x21u
#define D1_MAX_TILES 16
#define D1_NO_SLOT (-1)
#define D1_NO_SCENE 9999
#define D1_NO_FLAG (-1)
#define D1_CANDIDATE_TILE 0x276c /* 0x4b6097: a tile is under the pointer */
#define D1_CANDIDATE_EXIT 0x276d /* 0x4b6097: the exit rectangle is under the pointer */
#define D1_CURSOR_TILE 0x12
#define D1_CURSOR_EXIT 9
#define D1_SOUND_RECORD_BYTES 0x31u /* span of one embedded sound record (name 0x21 bytes, then its fields) */

/* Handler states (obj+0x274). */
enum {
    D1_STATE_IDLE = 0,       /* wait for the solved check, then for a click */
    D1_STATE_START_SOLVED = 1,
    D1_STATE_ANIMATE = 2,
    D1_STATE_WAIT = 3,
    D1_STATE_AUTO = 4,
    D1_STATE_WIN_SOUND = 5
};

typedef enum D1Status {
    D1_OK = 0,
    D1_ERR_ARGUMENT = 1,
    D1_ERR_BODY = 2,
    D1_ERR_UNSUPPORTED = 3,
    D1_ERR_HOST = 4,
    D1_ERR_MEMORY = 5,
    D1_ERR_BOUNDS = 6
} D1Status;

/* The process global phase 0 and 2 write (0x5bb1ca). */
typedef struct D1World {
    int32_t start_flag_5bb1ca;
} D1World;

/* The singleton at 0x61d449. Offsets are object offsets. `src` and `dst` keep the rectangles as the original does
 * (left, top, right, bottom). */
typedef struct D1Object {
    int16_t slot;            /* +0x1c generic Z entry, -1 none */
    int16_t row;             /* +0x1e */
    uint32_t surface;        /* +0x20 puzzle image handle, 0 none */
    int32_t src[D1_MAX_TILES][4]; /* +0x24 */
    int32_t dst[D1_MAX_TILES][4]; /* +0x124 */
    uint8_t dirty;           /* +0x224 */
    int32_t active;          /* +0x225 */
    uint8_t exit_taken;      /* +0x229 */
    uint8_t solved;          /* +0x22a */
    uint8_t counter;         /* +0x22b */
    int16_t step;            /* +0x22c */
    uint32_t deadline;       /* +0x22e GetTickCount deadline */
    int16_t moving[D1_MAX_TILES]; /* +0x232 */
    int16_t last_tile;       /* +0x252 */
    int16_t frame[D1_MAX_TILES];  /* +0x254 */
    int32_t state;           /* +0x274 */
} D1Object;

typedef enum D1Effect {
    D1_FX_ACTIVE = 1,       /* +0x225 := 1 */
    D1_FX_START_FLAG = 2,   /* 0x5bb1ca := a */
    D1_FX_CLEAR_ITEM = 3,   /* 0x4e8d96 */
    D1_FX_SLOT = 4,         /* 0x4d39f9 returned a */
    D1_FX_SLOT_REGISTER = 5,/* type 10, callback 0x4b7051, flags 0/0/1/1, label */
    D1_FX_SURFACE_LOAD = 6, /* 0x4c2790 returned a */
    D1_FX_SLOT_SURFACE = 7, /* slot surface := a */
    D1_FX_SOUND_PREPARE = 8,/* 0x4fb77a(record a) */
    D1_FX_PHASE = 9,        /* row phase := a */
    D1_FX_SOUND_BUSY = 10,  /* 0x4f6334(channel a) returned b */
    D1_FX_SOUND_PLAY = 11,  /* 0x4fb2e3(channel a) */
    D1_FX_SOUND_STOP = 12,  /* 0x4fba69(record a) */
    D1_FX_TICK = 13,        /* GetTickCount returned a */
    D1_FX_STATE = 14,       /* +0x274 := a */
    D1_FX_XFER_5BB57B = 15, /* dword := sign-extended scene word */
    D1_FX_XFER_5BB599 = 16, /* word */
    D1_FX_XFER_5BB595 = 17, /* word */
    D1_FX_XFER_5C39FF = 18, /* word */
    D1_FX_XFER_5BB59B = 19, /* dword */
    D1_FX_XFER_5BB59F = 20, /* dword */
    D1_FX_XFER_5BB5A3 = 21, /* dword */
    D1_FX_ENGINE_MODE = 22, /* 0x583999 := 4 */
    D1_FX_EVENT_FLAG = 23,  /* dword [0x585801 + 4 * a] := b */
    D1_FX_COMPLETE = 24,    /* 0x42ba3a(row) */
    D1_FX_RELEASE_SURFACE = 25, /* 0x4c2dfb(&surface) */
    D1_FX_RELEASE_SLOT = 26     /* 0x4d3992(a) */
} D1Effect;

/* The scene-change cells of a finish block (the same shape as the 0x2e arm). */
typedef struct D1Transition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} D1Transition;

typedef struct D1Host {
    void *context;
    /* 0x4d39f9: first free generic Z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 10, callback 0x4b7051, surface (0 on a first visit), flags 0, 0, 1, 1,
     * word 0 and the label "TURNING PUZZLE OVERLAYS". */
    int (*register_slot)(void *, int16_t slot, const char *label);
    /* 0x4c2790("CIFTREE", name, 6, "Turning Puzzle Surface"). */
    int (*load_surface)(void *, const char *name, uint32_t *surface);
    /* Entry surface store (0x5d1599). */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x4b5c11: entry +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* The view origin 0x583186 (x) / 0x58318a (y). */
    int (*view_origin)(void *, int32_t *x, int32_t *y);
    /* 0x4e8d96: commits the pending inventory item (phase 0 only). */
    int (*clear_pending_item)(void *);
    /* 0x4fb77a(record): prepares the sound record embedded in the body (record 0 at +0x2d9, record 1 at +0x345). */
    int (*sound_prepare)(void *, int record, const uint8_t *record_bytes);
    /* 0x4fba69(record): stops the record's channel. */
    int (*sound_stop)(void *, int record, const uint8_t *record_bytes);
    /* 0x4fb2e3(channel). */
    int (*sound_play)(void *, int16_t channel);
    /* 0x4f6334(channel): the raw return value (0 or 1 on the paths the handler reaches). */
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* Pure query for the finish block: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request, then the event flag store. */
    int (*transition)(void *, const D1Transition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} D1Host;

typedef struct D1Result {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} D1Result;

/* A power-on object: 0x4b5b8a (slot -1, row -1, inactive) over zeroed storage. */
void d1_object_reset(D1Object *object);

/* Native safety check of a typed body. Not an original check: the original trusts the loader. Rejects a short body,
 * a tile count outside 0..16, S == 0 (the original divides by it) and link numbers outside 0..16. */
int d1_validate_body(const uint8_t *body, size_t length, const char **failure);

/* 0x4b6355: the source rectangle of tile `tile` at `frame` and sub-step `step`, with the original's int32 wrap. */
void d1_geometry(const uint8_t *body, int16_t tile, int16_t frame, int16_t step, int32_t out[4]);

/* One true-gate visit of 0x4b64a9. Validation precedes the first effect. A host failure after effects returns
 * D1_ERR_HOST (the original has no recovery); the session must stop. `failure` is optional. */
int d1_step(D1Object *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, D1World *world,
            const D1Host *host, D1Result *result, const char **failure);

typedef struct D1PointerResult {
    uint8_t hit;        /* 0x4b5d17 return value */
    int32_t candidate;  /* 0x5c39e5 written by 0x4b6097, -1 when nothing was written */
    uint8_t cursor;     /* 0x5b44f0 written by 0x4b6097 (0x12 tile, 9 exit), 0 when nothing was written */
} D1PointerResult;

/* 0x4b5d17 with the 0x4b6097 cursor writes reported in `out`. The object must be active (otherwise the original
 * returns 0 without touching anything). */
int d1_pointer_move(D1Object *object, const uint8_t *body, size_t body_length, int16_t x, int16_t y,
                    D1PointerResult *out);

/* 0x4b617a, run on an accepted release. `row_phase` is the row phase dword, `candidate` the retained 0x5c39e5 and
 * `start_flag` the current 0x5bb1ca. Returns D1_ERR_BOUNDS (before any effect) when a tile click names no tile.
 * `new_phase` receives the row phase afterwards. */
int d1_click(D1Object *object, const uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
             int32_t start_flag, const D1Host *host, uint32_t *new_phase);

/* 0x4b5c11. */
int d1_invalidate(D1Object *object, const D1Host *host);

/* 0x4b5bc8: release the surface and the slot, then the 0x4b5b8a reset. */
int d1_cleanup(D1Object *object, const D1Host *host);

/* 0x4b7051: the blits of one render callback. `valid` is 0 when there is no render entry. */
typedef struct D1RenderPlan {
    uint8_t valid;
    uint32_t surface;
    int32_t count;
    int32_t src[D1_MAX_TILES][4]; /* view relative, left top right bottom */
    int32_t dst[D1_MAX_TILES][4]; /* view origin applied */
} D1RenderPlan;

int d1_render_plan(const D1Object *object, const uint8_t *body, size_t body_length, D1RenderPlan *plan);

#ifdef __cplusplus
}
#endif
#endif
