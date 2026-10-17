#ifndef BLACKMOOR_ACTION_FAMILY_EB_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_EB_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xeb, the Multibuild puzzle (RT-56; two scenes, resources 1600 and 2305, one row each).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly and the Ghidra pseudocode:
 *   0x427a50  dispatcher arm 0xeb (0x42a794): gate 0x423f57(deps, 0), then 0x480e02(ECX = 0x625ee8, row word). No
 *             0x42ba3a in the arm. The object (0x144d bytes, 0x625ee8..0x627335) is one static singleton.
 *   0x47e477  loader (0x40b34a arm 0x4108c0): copies the 2,612-byte typed body (src/action_family_eb.[ch] decodes it).
 *   0x480e02  the handler, a switch on the row phase dword (0x5bb632 + row * 0x8d): phase 0 init (0x47e582 per piece
 *             type), phase 1 an inner state machine on obj+0x13ca (0..6), phase 2 finish (scene block, 0x42ba3a, then
 *             the cleanup 0x47e2a5).
 *   0x47f421  pointer receiver (cascade 0x4f0059 at 0x4f0d90, x = [ptr+0x5e], y = [ptr+0x5a], rect = ptr+0x4a); it
 *             runs after the 0xea receiver 0x484f42 returned 0.
 *   0x47ff0e  accepted-release chain (0x43b331): acts on the retained candidate [0x5c39e5].
 *   0x47ef0f  second-button event (0x43c129, after the 0xea handler 0x484ac0): rotates a piece.
 *   0x47e440  slot invalidate (0x43d9f6). 0x47e2a5 clear (0x438c48, 0x43df1f). 0x47e3f7 power-on reset of the saved
 *             puzzle state (0x4384f8). 0x47e25a object reset.
 *   0x481cb9  the render callback of the generic Z entry (type 10).
 *
 * The object is modelled as the raw image of the original storage (EbObject.b, offsets below), the body as the raw
 * 2,612 bytes, so every store of the original has a place to compare byte for byte. Only offsets that the code reads
 * or writes are named here; nothing claims original source structure or field names.
 *
 * Object offsets: +0x1c slot (i16), +0x1e row (i16), +0x20 + 0x60 * t + 0x18 * k entry k (orientation) of piece type t
 * (20 types x 4 entries: surface dword +0, rect left, top, right, bottom dwords +4, width i16 +0x14, height i16
 * +0x16), +0x7a0 + t placed counter byte of type t (20 bytes, copied to the saved state), +0x7b4 + 0x25 * i piece
 * instance i (80 instances; z i16 +0, rect +2 = left, top, right, bottom dwords, rect2 +0x12 = rect plus the view
 * origin, orientation byte +0x22, type byte +0x23, "stamped" byte +0x24), +0x1344 drag flag, +0x1348 drop flag,
 * +0x134c lift flag, +0x1350 piece in hand (i16), +0x1352 previous moving rect, +0x1362 moving rect, +0x1372 previous
 * translated rect, +0x1382 translated rect, +0x1392 saved piece rect, +0x13a2 instance count (i16), +0x13a4 piece
 * source surface, +0x13a8 Multi_Piece surface, +0x13ac Multi_Anim surface, +0x13b0 has multi source, +0x13b1 multi
 * piece in hand, +0x13b2 animation on, +0x13b3 animation restore, +0x13b4 has animation, +0x13b5 animation source
 * rect, +0x13c5 active, +0x13c9 exit byte, +0x13ca state, +0x13ce done byte, +0x13cf pointer rect, +0x13df hit
 * flag, +0x13e3 / +0x13e5 hand width / height (i16), +0x13e7 / +0x13eb deadlines, +0x13ef list of pieces under the
 * pointer (20 words) with count +0x1417 (i16), +0x1419 list of rotate-zone pieces with count +0x1441 (i16), +0x1443
 * total (i16), +0x1445 / +0x1447 animation row / frame (i16), +0x1449 / +0x144b animation cell width / height (i16).
 *
 * Body offsets: +0x00 piece image name, +0x21 Multi_Piece image name, +0x42 persist byte, +0x43 piece type count
 * (i16), +0x45 target total (i16), +0x47 win-sound byte, +0x48 rotation allowed, +0x49 rotation locked, +0x4a / +0x4c
 * rotate zone height / width (i16), +0x4e area rect, +0x5e mode byte (0, 1, 2), +0x5f overlap-check byte, +0x60
 * animation image name, +0x81 animation area, +0x91 grid rows, +0x93 grid columns, +0x95 gap, +0x97 repeats (i16),
 * +0x99 + 0x53 * t piece type t (rects A, B, C, D, E of four dwords at +0x00, +0x10, +0x20, +0x30, +0x40; bytes
 * +0x50 "spawns copies", +0x51 required count, +0x52 forbidden), +0x715 / +0x746 / +0x777 / +0x7a8 sound records
 * (0x31 bytes: name, channel word at +0x21) for rotate, pick, good drop and bad drop, +0x7d9 bad-drop key, +0x7fa
 * bad-drop text (200 bytes), +0x8c2 / +0x8c4 / +0x8c6 cursor words, +0x8c8 win scene block, +0x8e1 win sound record,
 * +0x912 win key, +0x933 win text, +0x9fb exit scene block, +0xa14 / +0xa24 exit button rects. Scene blocks are
 * 0x19 bytes (scene word 9999 = none, three words, three dwords, start-flag word, event-flag index word (-1 none),
 * value byte); the win block's flag fields sit at +0x8de / +0x8e0 and the exit block's at +0xa11 / +0xa13 (the
 * "completion flag" pair that 0x480b34 writes). */

#define EB_RUNTIME_TYPE UINT8_C(0xeb)
#define EB_BODY_BYTES 2612u
#define EB_OBJECT_BYTES 0x144du
#define EB_MAX_TYPES 20
#define EB_MAX_INSTANCES 80
#define EB_PIECE_STRIDE 0x25u
#define EB_NO_SLOT (-1)
#define EB_NO_SCENE 9999
#define EB_NO_FLAG (-1)
#define EB_SOUND_RECORD_BYTES 0x31u
#define EB_MAX_BLITS 100

/* Candidates written by 0x47fd65 into [0x5c39e5]. */
#define EB_CANDIDATE_PICK 0x278d   /* an unplaced piece is under the pointer */
#define EB_CANDIDATE_ROTATE 0x278e /* a rotate zone is under the pointer */
#define EB_CANDIDATE_EXIT_A 0x278f /* first exit button rect */
#define EB_CANDIDATE_EXIT_B 0x2790 /* second exit button rect */
#define EB_CANDIDATE_DROP 0x2791   /* dragging */

/* Handler states (obj+0x13ca). */
enum {
    EB_STATE_IDLE = 0,
    EB_STATE_WAIT = 1,
    EB_STATE_UNUSED = 2,
    EB_STATE_WIN_WAIT = 3,
    EB_STATE_ANIM = 4,
    EB_STATE_ANIM_DELAY = 5,
    EB_STATE_WIN_SOUND = 6
};

typedef enum EbStatus {
    EB_OK = 0,
    EB_ERR_ARGUMENT = 1,
    EB_ERR_BODY = 2,
    EB_ERR_UNSUPPORTED = 3,
    EB_ERR_HOST = 4,
    EB_ERR_MEMORY = 5,
    EB_ERR_BOUNDS = 6
} EbStatus;

/* The process globals the code touches: the start flag 0x5bb1ca, the current scene 0x5bb57b (read for the saved
 * state compare, written by a finish block) and the saved puzzle state that survives the row (0x5a055d flag,
 * 0x5a0561 scene word, 0x5a0563 twenty counter bytes, 0x5a0577 the 80 piece instances, 0x5a1107 count, 0x5a1109
 * total). 0x47e3f7 is eb_world_reset. */
typedef struct EbWorld {
    int32_t start_flag_5bb1ca;
    int32_t scene_5bb57b;
    uint32_t saved_flag;
    int16_t saved_scene;
    uint8_t saved_counts[EB_MAX_TYPES];
    uint8_t saved_pieces[EB_MAX_INSTANCES * EB_PIECE_STRIDE];
    int16_t saved_count;
    int16_t saved_total;
} EbWorld;

/* The singleton at 0x625ee8, as its raw image. */
typedef struct EbObject {
    uint8_t b[EB_OBJECT_BYTES];
} EbObject;

/* 0x583186 / 0x58318a view origin, 0x583196..0x5831a2 clamp rect (left, top, right, bottom). */
typedef struct EbView {
    int32_t origin_x, origin_y;
    int32_t clip[4];
} EbView;

/* The scene-change cells of a finish block. */
typedef struct EbTransition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} EbTransition;

/* Sound record ids passed to the sound callbacks: the body offset of the 0x31-byte record. */
typedef struct EbHost {
    void *context;
    /* 0x583186 / 0x58318a / 0x583196..0x5831a2. */
    int (*view)(void *, EbView *view);
    /* 0x4d39f9: first free generic Z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 10, callback 0x481cb9, surface 0, flags 0, 0, 1, 1, word 0 and the label
     * "MULTIBUILD PUZZLE OVERLAYS". */
    int (*register_slot)(void *, int16_t slot, const char *label);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x47e440: entry +0x14 := 1 (redraw request). */
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
    /* 0x4fb77a / 0x4fba69(record): the 0x31-byte sound record at body offset `id`. */
    int (*sound_prepare)(void *, uint32_t id, const uint8_t *record);
    int (*sound_stop)(void *, uint32_t id, const uint8_t *record);
    /* 0x4fb2e3(channel). */
    int (*sound_play)(void *, int16_t channel);
    /* 0x4f6334(channel): the raw return value. */
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* [0x5bb202]: captions enabled. */
    int (*captions_enabled)(void *, int32_t *enabled);
    /* 0x423259(key): the AUTOTEXT text or NULL (key not found). */
    int (*autotext_lookup)(void *, const char *key, const char **text);
    /* 0x448d11(*0x5d03b3, text, -1, 0). */
    int (*caption_show)(void *, const char *text);
    /* Pure query for the flag stores: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request. */
    int (*transition)(void *, const EbTransition *request);
    /* [0x585801 + 4 * index] := value. */
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    /* 0x42ba3a(row): the generic completion. */
    int (*complete)(void *, int16_t row);
} EbHost;

typedef struct EbResult {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} EbResult;

/* 0x47e3f7: the saved puzzle state of the world (flag 0, scene 9999, counters and instances zero). The start flag, the
 * current scene and the saved count and total words are not touched (the original does not write them). */
void eb_world_reset(EbWorld *world);

/* A power-on object: zeroed storage plus 0x47e25a (row -1, slot -1, inactive). */
void eb_object_reset(EbObject *object);

/* Native safety check of a typed body. Not an original check: the original trusts the loader. Rejects a short body,
 * a piece type count outside 0..20, a type whose source surface would not be 1..4096 square, an unterminated name,
 * sound record, key or text field and an animation with a zero column count. */
int eb_validate_body(const uint8_t *body, size_t length, const char **failure);

/* One true-gate visit of 0x480e02. The body is the row's allocation and is read only. Validation precedes the first
 * effect. A host failure after effects returns EB_ERR_HOST (the original has no recovery); the session must stop.
 * `failure` is optional. */
int eb_step(EbObject *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, EbWorld *world,
            const EbHost *host, EbResult *result, const char **failure);

typedef struct EbPointerResult {
    uint8_t hit;           /* 0x47f421 return value */
    int32_t candidate;     /* [0x5c39e5] written by 0x47fd65, -1 when nothing was written */
    uint8_t wrote_cursor;  /* 0x47fd65 ran */
    int32_t cursor;        /* [0x5b44f0] */
    uint8_t cursor_flag;   /* [0x5b44f4] */
    uint32_t cursor_record;/* [0x5d1631]: VA of the cursor record */
} EbPointerResult;

/* 0x47f421 with the 0x47fd65 writes reported in `out`. `rect` is the 16-byte hot rectangle (left, top, right,
 * bottom). The object must be active (otherwise the original returns 0 without touching anything). */
int eb_pointer_move(EbObject *object, const uint8_t *body, size_t body_length, int16_t x, int16_t y,
                    const int32_t rect[4], const EbHost *host, EbPointerResult *out);

/* 0x47ff0e, run on an accepted release with the retained [0x5c39e5] `candidate`. `row_phase` is the executor's phase
 * of the object's row; `*new_phase` receives it afterwards (2 when an exit button was released). */
int eb_click(EbObject *object, const uint8_t *body, size_t body_length, EbWorld *world, uint32_t row_phase,
             int32_t candidate, const EbHost *host, uint32_t *new_phase);

/* 0x47ef0f, run when the input flag 0x5830a6 is consumed outside the screen states 2..5. */
int eb_rotate_key(EbObject *object, const uint8_t *body, size_t body_length, uint32_t row_phase, const EbHost *host);

/* 0x47e440. */
int eb_invalidate(EbObject *object, const EbHost *host);

/* 0x47e2a5: release the surfaces and the slot, then 0x47e25a. */
int eb_cleanup(EbObject *object, const EbHost *host);

/* One blit of the render callback 0x481cb9. kind 0 is the opaque copy 0x4c5377, kind 1 the colour-keyed copy
 * 0x4c5d4b, both onto the back buffer 0x5cf665. src_kind: 0 the saved background 0x5d15e3, 1 the Multi_Anim surface
 * (+0x13ac), 2 the piece source surface (+0x13a4), 3 the Multi_Piece surface (+0x13a8), 4 a piece entry surface. */
typedef struct EbBlit {
    uint8_t kind;
    uint8_t src_kind;
    uint32_t src_surface;
    int32_t src[4];
    int32_t dst[4];
} EbBlit;

typedef struct EbRenderPlan {
    uint8_t valid;
    int32_t count;
    EbBlit blit[EB_MAX_BLITS];
} EbRenderPlan;

/* 0x481cb9. It writes the object (the drop, lift and animation-restore flags are consumed), so call it once per
 * render pass. `valid` is 0 when there is no render entry. */
int eb_render_plan(EbObject *object, const uint8_t *body, size_t body_length, const EbHost *host,
                   EbRenderPlan *plan);

/* Read-only accessors for the host. */
int16_t eb_object_slot(const EbObject *object);
int16_t eb_object_row(const EbObject *object);
int eb_object_active(const EbObject *object);
uint32_t eb_object_state(const EbObject *object);

#ifdef __cplusplus
}
#endif
#endif
