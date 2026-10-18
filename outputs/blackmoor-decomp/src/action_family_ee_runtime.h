#ifndef BLACKMOOR_ACTION_FAMILY_EE_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_EE_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xee, the Memory puzzle (RT-60; scene S1206, resource 926 actions 1 and 2; the loader tags are "Memory Puzzle
 * Overlay Surface" and the z entry label "WHALESURVIVOR GAME PUZZLE OVERLAYS"). A grid of face-down tiles (one or more pages of
 * columns x rows tiles, switched with page tabs) hides pairs of pictures: the player flips two tiles, a pair stays up, a mismatch
 * turns back after a delay; enough pairs before the tries run out wins, running out of tries loses.
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly and the Ghidra pseudocode:
 *   0x427a50  dispatcher arm 0xee (0x42a5f9): gate 0x423f57(deps, 0), then 0x47c0f0(ECX = 0x61e398, row word), `ret 4`.
 *   0x47b3f0  loader arm (0x410785): copies the 5,826-byte typed body (src/action_family_ee.[ch] decodes it).
 *   0x47c0f0  the handler: a switch on the row phase dword (0x5bb632 + row * 0x8d). Phase 0 init (layout, z entry, overlay
 *             surface, deal 0x47bb56), phase 1 an inner state machine on obj+0x10 (0..4), phase 2 finish (scene block,
 *             generic completion 0x42ba3a, then the cleanup 0x47b321).
 *   0x47b4aa  pointer receiver (cascade 0x4f0059 at 0x4f0fb4, x = [event+0x5e], y = [event+0x5a]); candidates 0x2768 / 0x2769
 *             through 0x47b709 (cursor 0, flag 1, record [0x5d0377], image table 0x5b161c, flag 1).
 *   0x47b767  accepted-release chain (0x43b3a9): acts on the retained candidate [0x5c39e5].
 *   0x47b3bc  slot invalidate (0x43d96a). 0x47b321 clear (0x438bd0 new game, 0x43df8d scene cleanup, and inside the handler).
 *   0x47b200 / 0x47b23b  constructor (startup 0x426834) and object reset. 0x47d24e the render callback of the generic z entry
 *             (type 0xb, flag dword +0x14 of the entry).
 *   0x47ba79 flip-back timer, 0x47badf win / lose check, 0x47c049 pick a picture id, 0x47cd90 / 0x47ce6f / 0x47cf4e pick a
 *             sound record at random (match, wrong, win), 0x47d02d play a sound record (and its caption), 0x47d1c3 zeroed
 *             allocation.
 *   0x4db870  recenter the mouse cursor (ECX 0x5830ce; only when body+0x345 != 0): SetCursorPos(0, 0), cursor cells.
 *
 * The object is modelled as the raw image of the original storage (MpObject.b, 0x2c4 bytes), the body as the raw 5,826 bytes, so
 * every store of the original has a place to compare byte for byte. Two heap blocks of the original (the tile cells, 0xc bytes
 * per cell, and the picture-id table, 4 bytes per id) live in MpObject too; the image holds their guest addresses as the
 * constants MP_GUEST_CELLS and MP_GUEST_USED (+ cell * 0xc for the two flipped-cell pointers), so the oracle can make the
 * allocator hook return the same two values. Only offsets that the code reads or writes are named here; nothing claims original
 * source structure or field names.
 *
 * Object offsets: +0x00 vtable pointer (0x52d568), +0x04 z slot (i16, -1 none), +0x06 row (i16, -1 none), +0x08 overlay surface,
 * +0x0c body pointer, +0x10 state (0..4), +0x14 cell array, +0x18 picture-id table, +0x1c / +0x20 the first / second flipped cell
 * (guest pointers or 0), +0x24 active, +0x28 won, +0x2c lost, +0x30 redraw background, +0x34 flip-back pending, +0x38 flip-back
 * deadline (tick), +0x3c + 0x10 i tile rectangle i (left, top, right, bottom = body rect + view origin; 24 tiles), +0x1bc page-tab
 * target rectangle, +0x1cc + 0x30 p + 0x10 k hot rectangle k of page tab p (translated), +0x25c copy of the view rectangle,
 * +0x26c view rectangle (0x583186..0x583192), +0x27c tile or tab under the pointer, +0x280 tiles per page, +0x284 tiles, +0x288
 * picture slots (body +0x353 * +0x357), +0x28c page, +0x290 pairs found, +0x294 tries, +0x298 tiles / 2, +0x29c tiles per page / 2,
 * +0x2a0 pairs needed, +0x2a4 picture ids, +0x2a8 (cleared by reset), +0x2ac / +0x2b0 loop counters, +0x2b4 cell index
 * under work, +0x2b8 / +0x2bc / +0x2c0 picked match / wrong / win sound record.
 * Cell (0xc bytes): +0 picture id (-1 not dealt), +4 face up, +8 matched.
 *
 * Body offsets: +0x00 overlay image name (0x21 bytes), +0x21 + 0x10 id the picture rectangle of id (12 ids; left, top, right,
 * bottom dwords), +0xe1 + 0x10 page the page-tab source rectangle, +0x111 + 0x10 i the face-down tile rectangle of tile i (24),
 * +0x291 page-tab target rectangle, +0x2a1 + 0x30 p + 0x10 k hot rectangle k of page tab p, +0x331 flip-back delay (ms), +0x335
 * percentage of picture slots used as ids, +0x339 percentage of tiles / 2 needed (-1 uses +0x33d), +0x33d, +0x341 tries allowed,
 * +0x345 recenter-cursor byte, +0x346 shuffle over all pages byte (forced 0 for one page), +0x347 pages (1..3), +0x34b columns
 * (1..6), +0x34f rows (1..4), +0x353 / +0x357 picture slot columns (1..6) and rows (1..2), +0x35b page tabs byte, sound records
 * (0xb6 bytes: name 0x21, channel word +0x21, sound fields up to +0x31, caption key +0x31 (0x21), caption text +0x52 (0x64))
 * at +0x35c (first flip), +0x412 (second flip), +0x4c8 + 0xb6 i (5 match), +0x856 + 0xb6 i (10 wrong), +0xf72 + 0xb6 i (10 win),
 * +0x168e win scene block, +0x16a8 lose scene block (0x1a bytes: scene word, words +2 +4 +6, dwords +8 +12 +16, start-flag
 * word +0x14 (== 1 stores 0, anything else 1), event flag index word +0x16 (-1 none), value word +0x18).
 *
 * Known wrinkles preserved in the kernel (do not "fix"): the tab and tile hit tests use the body rectangles without the view
 * origin (the drawn tile rectangles include it); the tile hit test shrinks each rectangle by 3 pixels on every side; the
 * tab hit test returns before the tiles and does not look at the page; the first click on a face-down tile selects it with the
 * 0x2769 candidate without a sound check; a mismatch plays the "wrong" sound record at once (0x47ce6f) before the flip-back
 * delay; the pick-a-sound functions test for "NO SOUND" case-insensitively (0x516530) but the handler states test the pick with a
 * case-sensitive 9-byte compare; the finish releases the surface and cells (0x47b321) after the generic completion.
 * The deal draws with `_rand` and loops until a free partner cell is found (per page, or over all pages when body +0x346 != 0 and
 * pages > 1); with an odd cell count in the dealt range the original never ends, which the native body check refuses.
 * The float arithmetic of the deal (0x47bb56: int -> float32, / 100.0f, * float32(int), __ftol truncation) is evaluated in
 * double precision, as under the 0x027f x87 control word the Windows loader sets (the same assumption as the RT-47 oracle); the
 * ambient control word was not proven by the earlier slices either.
 *
 * Native-only refusals (the oracle must not run them against the original; test them natively): body validation
 * (`mp_validate_body`: unterminated name, caption key / text or sound name, pages, columns, rows or picture slots outside the
 * ranges above, an odd dealt cell count, an unrepresentable percentage), phase 1 / 2 without phase 0, a flipped-cell pointer that
 * is not a cell of the table, an event flag index the host refuses, a caption longer than the 104-byte local of 0x47d02d, a
 * random-pick loop that does not end within MP_PICK_LIMIT draws (the original would hang), an event whose cells are not in
 * the object. The fatal exits of the original (0x4c97b4 after the "CMemoryPuzzle::ProcessPuzzle" messages) are the body refusals.
 */

#define MP_RUNTIME_TYPE UINT8_C(0xee)
#define MP_BODY_BYTES 5826u
#define MP_OBJECT_BYTES 0x2c4u
#define MP_MAX_PAGES 3
#define MP_MAX_TILES_PER_PAGE 24
#define MP_MAX_CELLS 72
#define MP_MAX_IDS 12
#define MP_CELL_BYTES 12u
#define MP_SOUND_RECORD_BYTES 0xb6u
#define MP_SOUND_HOST_BYTES 0x31u /* the part 0x4fb77a reads */
#define MP_NO_SLOT (-1)
#define MP_NO_SCENE 9999
#define MP_NO_FLAG (-1)
#define MP_PICK_LIMIT 100000
#define MP_MAX_BLITS 40
#define MP_GUEST_CELLS UINT32_C(0x30000000)
#define MP_GUEST_USED UINT32_C(0x30010000)
#define MP_VTABLE UINT32_C(0x0052d568)
#define MP_FLIP_CHANNEL 0x17 /* 0x47b767 plays channel 0x17 when a page tab is taken */

/* Candidates written by 0x47b709 into [0x5c39e5]. */
#define MP_CANDIDATE_TAB 0x2768
#define MP_CANDIDATE_TILE 0x2769

/* Handler states (obj+0x10). */
enum {
    MP_STATE_PLAY = 0,
    MP_STATE_WIN_PICK = 1,
    MP_STATE_LOSE_PICK = 2,
    MP_STATE_WIN_WAIT = 3,
    MP_STATE_LOSE_WAIT = 4
};

typedef enum MpStatus {
    MP_OK = 0,
    MP_ERR_ARGUMENT = 1,
    MP_ERR_BODY = 2,
    MP_ERR_UNSUPPORTED = 3,
    MP_ERR_HOST = 4,
    MP_ERR_BOUNDS = 5,
    MP_ERR_STUCK = 6
} MpStatus;

/* The singleton at 0x61e398 (0x2c4 bytes) plus the two heap blocks the original allocates for a visit. */
typedef struct MpObject {
    uint8_t b[MP_OBJECT_BYTES];
    uint8_t cells[MP_MAX_CELLS * MP_CELL_BYTES];
    uint8_t used[MP_MAX_IDS * 4u];
} MpObject;

/* 0x583186..0x583192 view rectangle (left, top, right, bottom) and 0x583196..0x5831a2 clip rectangle; the origin is its first
 * two dwords. */
typedef struct MpView {
    int32_t view[4];
    int32_t clip[4];
} MpView;

/* The scene-change cells of a finish block. */
typedef struct MpTransition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
    int32_t start_flag; /* [0x5bb1ca] := (word at +0x14 != 1) */
} MpTransition;

typedef struct MpHost {
    void *context;
    /* 0x583186.. view rectangle and 0x583196.. clip rectangle. */
    int (*view)(void *, MpView *view);
    /* [0x5bb1ca] := value (phase 0 stores 1). */
    int (*set_start_flag)(void *, int32_t value);
    /* 0x4e8d96 on ECX 0x571442: commits the pending inventory item (phase 0). */
    int (*clear_pending_item)(void *);
    /* 0x4db870 on ECX 0x5830ce (phase 0 when body +0x345 != 0): SetCursorPos(0, 0) and the cursor cells. */
    int (*recenter_cursor)(void *);
    /* 0x4d39f9: first free generic Z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 0xb, callback 0x47d24e, surface 0, flags 0, 0, then +0x14 := 1, +0x18 := 1, word 0 and
     * the label (33 bytes copied). */
    int (*register_slot)(void *, int16_t slot, const char *label);
    /* [0x5d1599 + slot * 0x4a] := surface. */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x47b3bc: entry +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* 0x4c2790("CIFTREE", name, 6, tag). */
    int (*load_surface)(void *, const char *name, const char *tag, uint32_t *surface);
    /* 0x4c2dfb(&surface): releases the image; the kernel zeroes the field. */
    int (*release_surface)(void *, uint32_t surface);
    /* _rand (0x50cd50): 0..32767. */
    int32_t (*random)(void *);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* 0x4fb77a(record): the first 0x31 bytes of the 0xb6-byte sound record at body offset `id`. */
    int (*sound_prepare)(void *, uint32_t id, const uint8_t *record);
    /* 0x4fb2e3(channel). */
    int (*sound_play)(void *, int16_t channel);
    /* 0x4f6334(channel): the raw return value. */
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* [0x5bb202]: captions enabled. */
    int (*captions_enabled)(void *, int32_t *enabled);
    /* 0x423259(key): the AUTOTEXT text or NULL (key not found). */
    int (*autotext_lookup)(void *, const char *key, const char **text);
    /* 0x448d11(*0x5d03b3, text, -1, 0); `text` already ends with "<n><e>". */
    int (*caption_show)(void *, const char *text);
    /* Pure query for the flag stores: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request. */
    int (*transition)(void *, const MpTransition *request);
    /* [0x585801 + 4 * index] := value. */
    int (*store_event_flag)(void *, int16_t index, int32_t value);
    /* 0x42ba3a(row): the generic completion. */
    int (*complete)(void *, int16_t row);
} MpHost;

typedef struct MpResult {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} MpResult;

/* A power-on object: zeroed storage, the vtable pointer, then 0x47b23b (row -1, slot -1, inactive). */
void mp_object_reset(MpObject *object);

/* Native safety check of a typed body (see the header comment). Not an original check: the original trusts the loader and
 * ends in a fatal exit or a hang for the bodies refused here. */
int mp_validate_body(const uint8_t *body, size_t length, const char **failure);

/* One true-gate visit of 0x47c0f0. `body_handle` is the guest value of the row's pData pointer (opaque, stored in obj+0xc).
 * The body is the row's allocation and is read only (the original writes body +0x346 := 0 for one page; the kernel uses the
 * forced value instead and never reads the byte again). Validation precedes the first effect. A host failure after effects
 * returns MP_ERR_HOST (the original has no recovery); the session must stop. `failure` is optional. */
int mp_step(MpObject *object, const uint8_t *body, size_t body_length, uint32_t body_handle, int16_t row, uint32_t phase,
            const MpHost *host, MpResult *result, const char **failure);

typedef struct MpPointerResult {
    uint8_t hit;           /* 0x47b4aa return value */
    int32_t candidate;     /* [0x5c39e5] written by 0x47b709, -1 when nothing was written */
    uint8_t wrote_cursor;  /* 0x47b709 ran */
    int32_t cursor;        /* [0x5b44f0] */
    uint8_t cursor_flag;   /* [0x5b44f4] */
} MpPointerResult;

/* 0x47b4aa with the 0x47b709 writes reported in `out`. Returns 0 without touching anything unless active and neither won nor
 * lost. */
int mp_pointer(MpObject *object, const uint8_t *body, size_t body_length, int16_t x, int16_t y, MpPointerResult *out);

/* 0x47b767, run on every accepted release with the retained [0x5c39e5] `candidate`. `row_phase` is the executor's phase of the
 * object's row (read through the object's row; pass 0 when the object is inactive); `body_handle` is pData[obj row] (stored in
 * obj+0xc first, as the original does even when inactive). The body may be NULL when the object is inactive. */
int mp_click(MpObject *object, const uint8_t *body, size_t body_length, uint32_t body_handle, uint32_t row_phase,
             int32_t candidate, const MpHost *host);

/* 0x47b3bc. */
int mp_invalidate(MpObject *object, const MpHost *host);

/* 0x47b321: release the surface, cells and slot, then 0x47b23b. */
int mp_cleanup(MpObject *object, const MpHost *host);

/* One blit of the render callback 0x47d24e (opaque copy 0x4c5377 onto the back buffer 0x5cf665). src_kind: 0 the saved
 * background 0x5d15e3, 1 the overlay surface (the z entry's surface). */
typedef enum MpBlitLabel {
    MP_LABEL_BACKGROUND = 0,
    MP_LABEL_TAB = 1,
    MP_LABEL_VISIBLE = 2,
    MP_LABEL_HIDDEN = 3
} MpBlitLabel;

typedef struct MpBlit {
    uint8_t src_kind;
    uint8_t label;
    int32_t src[4];
    int32_t dst[4];
} MpBlit;

typedef struct MpRenderPlan {
    uint8_t valid;
    int32_t count;
    MpBlit blit[MP_MAX_BLITS];
} MpRenderPlan;

/* 0x47d24e. It clears the redraw flag (obj+0x30) when the background restore is emitted, so call it once per render pass.
 * `valid` is 0 when the object is inactive. */
int mp_render_plan(MpObject *object, const uint8_t *body, size_t body_length, const MpHost *host, MpRenderPlan *plan);

/* Read-only accessors for the host. */
int16_t mp_object_slot(const MpObject *object);
int16_t mp_object_row(const MpObject *object);
int mp_object_active(const MpObject *object);
uint32_t mp_object_state(const MpObject *object);

#ifdef __cplusplus
}
#endif
#endif
