#ifndef BLACKMOOR_ACTION_FAMILY_EA_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_EA_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xea, the Onebuild jigsaw puzzle (RT-45; the corpus is "JAN_JigsawPUZ_OV", 20 pieces, three scenes).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0xea (0x42a759): gate 0x423f57(deps, 0), then 0x4867bd(ECX = 0x6252ad, row). No
 *             0x42ba3a in the arm. The object (0xc3b bytes, 0x6252ad..0x625ee8) is one static singleton.
 *   0x484110  loader (0x40b34a arm 0x410893): copies the 3,847-byte typed body (src/action_family_ea.[ch] decodes it).
 *   0x4867bd  the handler, a switch on the row phase dword (0x5bb632 + row * 0x8d): phase 0 init (per-piece surface
 *             build 0x48421e), phase 1 an inner state machine on obj+0xbac (0..6), phase 2 finish (scene change or
 *             event flag, 0x42ba3a, then the cleanup 0x483fb5).
 *   0x484f42  pointer receiver (cascade 0x4f0059 at 0x4f0d61, x = [ptr+0x5e], y = [ptr+0x5a], rect = ptr+0x4a).
 *   0x48569e  accepted-release chain (0x43b327): acts on the retained candidate [0x5c39e5].
 *   0x484ac0  second-button event (0x43c11f, input flag 0x5830a6 consumed by 0x4daf6e): rotates a piece.
 *   0x4840d9  slot invalidate (0x43d9ec). 0x483fb5 clear (0x438c3e, 0x43df15). 0x483f6a power-on reset.
 *   0x4876ed  the render callback of the generic Z entry (type 10).
 *
 * The object is modelled as the raw image of the original storage (EaObject.b, offsets below), the body as the raw
 * 3,847 bytes, so every store of the original has a place to compare byte for byte. Only offsets that the handler
 * reads or writes are named here; nothing claims original source structure or field names.
 *
 * Object offsets: +0x1c slot (i16), +0x1e Multi_Anim surface, +0x22 DF_Piece_Source surface, +0x26 row (i16),
 * +0x28 + 0x85 * i piece i (z i16 +0; rect +2 = left, top, right, bottom dwords; rect2 +0x12 = rect plus the view
 * origin; orientation byte +0x22; flag byte +0x23 = placed; four entries of 0x18 bytes at +0x24: surface dword, rect
 * l, t, r, b, width i16 +0x14, height i16 +0x16; byte +0x84),
 * +0xa92 drag flag, +0xa96 drop flag, +0xa9a lift flag, +0xa9e piece in hand (i16), +0xaa0 previous moving rect,
 * +0xab0 moving rect, +0xac0 previous translated, +0xad0 translated, +0xae0 saved piece rect, +0xb21 / +0xb52 sound
 * buffers (0x31 bytes, channel word at +0x21), +0xb83 / +0xb87 / +0xb8b / +0xb8f / +0xb93 flags, +0xb97 animation
 * source rect, +0xba7 active, +0xbab exit byte, +0xbac state, +0xbb0 done byte, +0xbb1 pointer rect, +0xbc1 caption
 * shown, +0xbc5 / +0xbc7 piece width / height (i16), +0xbc9 / +0xbcd deadlines, +0xbd1 unplaced-under-pointer list
 * (20 words) with count +0xbf9, +0xbfb placed-under-pointer list with count +0xc23, +0xc25 placed counter,
 * +0xc27 exit-area flag, +0xc2b / +0xc2f flags, +0xc33 / +0xc35 animation counters, +0xc37 / +0xc39 animation cell
 * size.
 *
 * Body offsets: +0x00 image name, +0x21 piece count (i16), +0x24 rotation allowed, +0x25 rotation locked,
 * +0x26 / +0x28 rotate zone height / width, +0x2a tolerance enable, +0x2b tolerance, +0x2d ordered mode,
 * +0x2e order list, +0x56 / +0x57 layer table, +0x7f + 0x42 * i piece record (rects A, B, C, D of four dwords, byte
 * +0x40 orientation, byte +0x41 loose flag), +0x5a7 area rect, +0x5b7 drop area rect, +0x5c7 animation image name,
 * +0x5e8 animation area, +0x5f8 exit area, +0x608..+0x612 animation grid, +0x614 / +0x645 / +0x676 / +0x6a7 / +0x6d8 /
 * +0x74b / +0xa79 / +0xdc4 sound records (0x31 bytes), +0xda7 / +0xda9 cursor words, +0xdab win scene block,
 * +0xede exit scene block, +0xef7 exit button rect. Scene blocks are 0x19 bytes (scene word 9999 = none, three
 * words, three dwords, start-flag word, event-flag index word (-1 none), value byte). */

#define EA_RUNTIME_TYPE UINT8_C(0xea)
#define EA_BODY_BYTES 3847u
#define EA_OBJECT_BYTES 0xc3bu
#define EA_MAX_PIECES 20
#define EA_PIECE_STRIDE 0x85u
#define EA_NO_SLOT (-1)
#define EA_NO_SCENE 9999
#define EA_NO_FLAG (-1)
#define EA_SOUND_RECORD_BYTES 0x31u
#define EA_MAX_BLITS 40

/* Candidates written by 0x4854fb into [0x5c39e5]. */
#define EA_CANDIDATE_PICK 0x2777   /* an unplaced piece is under the pointer */
#define EA_CANDIDATE_ROTATE 0x2778 /* a placed piece's rotate zone is under the pointer */
#define EA_CANDIDATE_EXIT 0x2779   /* the exit button rect */
#define EA_CANDIDATE_DROP_BAD 0x277a
#define EA_CANDIDATE_DROP_GOOD 0x277b
#define EA_CANDIDATE_ANIM 0x277c   /* the animation / exit area */

/* Handler states (obj+0xbac). */
enum {
    EA_STATE_IDLE = 0,
    EA_STATE_DROP_WAIT = 1,
    EA_STATE_FEEDBACK = 2,
    EA_STATE_ANIM_STEP = 3,
    EA_STATE_WAIT = 4,
    EA_STATE_WIN_SOUND = 5,
    EA_STATE_DONE = 6
};

typedef enum EaStatus {
    EA_OK = 0,
    EA_ERR_ARGUMENT = 1,
    EA_ERR_BODY = 2,
    EA_ERR_UNSUPPORTED = 3,
    EA_ERR_HOST = 4,
    EA_ERR_MEMORY = 5,
    EA_ERR_BOUNDS = 6
} EaStatus;

/* The process global the visits write (0x5bb1ca). */
typedef struct EaWorld {
    int32_t start_flag_5bb1ca;
} EaWorld;

/* The singleton at 0x6252ad, as its raw image. */
typedef struct EaObject {
    uint8_t b[EA_OBJECT_BYTES];
} EaObject;

/* 0x583186 / 0x58318a view origin, 0x583196..0x5831a2 clamp rect (left, top, right, bottom). */
typedef struct EaView {
    int32_t origin_x, origin_y;
    int32_t clip[4];
} EaView;

/* The scene-change cells of a finish block (the same shape as the 0xd1 and 0x2e arms). */
typedef struct EaTransition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} EaTransition;

/* Sound buffer ids passed to the sound callbacks: body offset for a record that lives in the body, 0x10000 + object
 * offset for a buffer in the object (0xb21, 0xb52). */
#define EA_SOUND_OBJECT_ID 0x10000u

typedef struct EaHost {
    void *context;
    /* 0x583186 / 0x58318a / 0x583196..0x5831a2. */
    int (*view)(void *, EaView *view);
    /* 0x4d39f9: first free generic Z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 10, callback 0x4876ed, surface 0, flags 0, 0, 1, 1, word 0 and the label
     * "ONEBUILD_PUZZLE_OVERLAYS". */
    int (*register_slot)(void *, int16_t slot, const char *label);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x4840d9: entry +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* 0x4c2790("CIFTREE", name, 6, tag). */
    int (*load_surface)(void *, const char *name, const char *tag, uint32_t *surface);
    /* 0x4c2a8d(w, h, 6, tag). */
    int (*create_surface)(void *, int16_t w, int16_t h, const char *tag, uint32_t *surface);
    /* 0x4c51a5(src, dst, src rect, dst rect, tag): rects are left, top, right, bottom. */
    int (*blit)(void *, uint32_t src, uint32_t dst, const int32_t src_rect[4], const int32_t dst_rect[4]);
    /* The inline pixel copy between the two surfaces of a rotated entry (size = source size). */
    int (*copy_surface)(void *, uint32_t dst, uint32_t src);
    /* 0x4c7070: rotate in place; the new width and height. */
    int (*rotate_surface)(void *, uint32_t surface, int16_t *w, int16_t *h);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4e8d96: commits the pending inventory item (phase 0 only). */
    int (*clear_pending_item)(void *);
    /* 0x4fb77a / 0x4fba69(record): the 0x31-byte sound record. */
    int (*sound_prepare)(void *, uint32_t id, const uint8_t *record);
    int (*sound_stop)(void *, uint32_t id, const uint8_t *record);
    /* 0x4fb2e3(channel). */
    int (*sound_play)(void *, int16_t channel);
    /* 0x4f6334(channel): the raw return value. */
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* _rand: the raw nonnegative return value. */
    int (*rand_value)(void *, int32_t *value);
    /* [0x5bb202]: captions enabled. */
    int (*captions_enabled)(void *, int32_t *enabled);
    /* 0x423259(key): the AUTOTEXT text or NULL (key not found). */
    int (*autotext_lookup)(void *, const char *key, const char **text);
    /* 0x448d11(*0x5d03b3, text, -1, 0). */
    int (*caption_show)(void *, const char *text);
    /* Pure query for the finish block: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request. */
    int (*transition)(void *, const EaTransition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    /* 0x42ba3a(row): the generic completion. */
    int (*complete)(void *, int16_t row);
} EaHost;

typedef struct EaResult {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} EaResult;

/* A power-on object: zeroed storage plus 0x483f6a (row -1, slot -1, inactive). */
void ea_object_reset(EaObject *object);

/* Native safety check of a typed body. Not an original check: the original trusts the loader. Rejects a short body,
 * a piece count outside 0..20, a piece surface that would not be 1..4096 square, an unterminated name or text field
 * and an animation grid with a zero column count. */
int ea_validate_body(const uint8_t *body, size_t length, const char **failure);

/* One true-gate visit of 0x4867bd. The body is the row's allocation and is written (0x484f42 clears the tolerance
 * word). Validation precedes the first effect. A host failure after effects returns EA_ERR_HOST (the original has no
 * recovery); the session must stop. `failure` is optional. */
int ea_step(EaObject *object, uint8_t *body, size_t body_length, int16_t row, uint32_t phase, EaWorld *world,
            const EaHost *host, EaResult *result, const char **failure);

typedef struct EaPointerResult {
    uint8_t hit;           /* 0x484f42 return value */
    int32_t candidate;     /* [0x5c39e5] written by 0x4854fb, -1 when nothing was written */
    uint8_t wrote_cursor;  /* 0x4854fb ran */
    int32_t cursor;        /* [0x5b44f0] */
    uint8_t cursor_flag;   /* [0x5b44f4] */
    uint32_t cursor_record;/* [0x5d1631]: VA of the cursor record */
} EaPointerResult;

/* 0x484f42 with the 0x4854fb writes reported in `out`. `rect` is the 16-byte hot rectangle (left, top, right,
 * bottom). The object must be active (otherwise the original returns 0 without touching anything). */
int ea_pointer_move(EaObject *object, uint8_t *body, size_t body_length, int16_t x, int16_t y, const int32_t rect[4],
                    const EaHost *host, EaPointerResult *out);

/* 0x48569e, run on an accepted release with the retained [0x5c39e5] `candidate`. `row_phase` is the executor's phase
 * of the object's row; `*new_phase` receives it afterwards (2 when the exit button was released). */
int ea_click(EaObject *object, uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
             const EaHost *host, uint32_t *new_phase);

/* 0x484ac0, run when the input flag 0x5830a6 is consumed outside the screen states 2..5. */
int ea_rotate_key(EaObject *object, uint8_t *body, size_t body_length, uint32_t row_phase, const EaHost *host);

/* 0x4840d9. */
int ea_invalidate(EaObject *object, const EaHost *host);

/* 0x483fb5 followed by the 0x483f6a reset: release the surfaces and the slot. */
int ea_cleanup(EaObject *object, const EaHost *host);

/* One blit of the render callback 0x4876ed. kind 0 is the opaque copy 0x4c5377, kind 1 the colour-keyed copy
 * 0x4c5d4b, both onto the back buffer 0x5cf665. src_kind: 0 the saved background 0x5d15e3, 1 the Multi_Anim surface,
 * 2 the DF_Piece_Source surface, 3 a piece entry surface. */
typedef struct EaBlit {
    uint8_t kind;
    uint8_t src_kind;
    uint32_t src_surface;
    int32_t src[4];
    int32_t dst[4];
} EaBlit;

typedef struct EaRenderPlan {
    uint8_t valid;
    int32_t count;
    EaBlit blit[EA_MAX_BLITS];
} EaRenderPlan;

/* 0x4876ed. It writes the object (the drop, lift and animation-restore flags are consumed), so call it once per
 * render pass. `valid` is 0 when there is no render entry. */
int ea_render_plan(EaObject *object, uint8_t *body, size_t body_length, const EaHost *host, EaRenderPlan *plan);

/* Read-only accessors for the host. */
int16_t ea_object_slot(const EaObject *object);
int16_t ea_object_row(const EaObject *object);
int ea_object_active(const EaObject *object);
uint32_t ea_object_state(const EaObject *object);

#ifdef __cplusplus
}
#endif
#endif
