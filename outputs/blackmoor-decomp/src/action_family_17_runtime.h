#ifndef BLACKMOOR_ACTION_FAMILY_17_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_17_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of the raw 0x16..0x19 "multiframe scene hotspot" family (RT-15,
 * the tutorial's S6401 row 6, "MF HS scene - gallery -> main gallery").
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the
 * disassembly and by the original-x86 oracle:
 *   0x427bdd  dispatcher arm for runtime type 0x16: gate 0x423f57 mode 1
 *   0x427c15  dispatcher arm for runtime types 0x17, 0x18, 0x19: gate mode 0
 *   0x42b07e  the handler, called with the row index by both arms
 *   0x4f0059  pointer cascade: the GENERIC row loop (0x4f1f16..) hits a row
 *             whose request dword (0x5bb626) is nonzero and whose rectangle
 *             words (0x5bb62a/2c/2e/30) contain the pointer, sets the
 *             candidate 0x5c39e5 and, by row type, the hover cursor; types
 *             0x17..0x19 take case 0x4f1ff3 (cursor index 0x40b2d0(type)),
 *             type 0x16 the default case 0x4f22ef
 *   0x40b2d0  cursor index map by runtime type
 * The handler works on the row's typed body (the loader copies it verbatim,
 * A-17.1): a 20-byte scene-change prefix (identical in layout to the 0x0a
 * body), the signed record count at +0x14 and count 18-byte records at +0x16
 * (word frame, four dwords left/top/right/bottom). The selector is the word
 * 0x5bb50b.
 *
 * Phase 0 (0x42b0b2): 0x5bb1ca := 1, row phase := 1, then phase 1 in the same
 * call. Phase 1 (0x42b0d0): request := 0; the FIRST record whose frame word
 * equals the selector (both sign-extended) sets request := 1 and copies the
 * low words of its four dwords into the row rectangle words; the scan stops at
 * the hit. Phase 2 (0x42b217): completion byte := 1 (direct store, no 0x42ba3a,
 * no dependency reset, phase stays 2), the prefix is copied to the
 * scene-change cells exactly like the 0x0a arm and the engine mode
 * 0x583999 := 4. Any other phase has no effect.
 *
 * Native safety rejections (reported separately from valid behaviour): the
 * original trusts the count; the native kernel requires the typed body to be
 * exactly 22 + 18 * count bytes with 0 <= count <= 1819 (the domain in which
 * the original's 16-bit size arithmetic does not wrap, A-17.1). */

#define ACTION17_FIRST_TYPE 0x16u
#define ACTION17_LAST_TYPE 0x19u
#define ACTION17_PREFIX_BYTES 22u
#define ACTION17_RECORD_BYTES 18u
#define ACTION17_MAX_COUNT 1819

typedef enum {
    ACTION17_OK = 0,
    ACTION17_ERR_ARGUMENT = 1,
    /* A required host provider is absent; nothing was changed. */
    ACTION17_ERR_UNSUPPORTED = 2,
    /* The typed body is not a complete 0x17 object; nothing was changed. */
    ACTION17_ERR_BOUNDS = 3,
    /* A host provider failed (binding level). */
    ACTION17_ERR_HOST = 4
} Action17Status;

/* The row slot cells the handler writes (row base 0x5bb5e3 + row * 0x8d). */
typedef struct {
    int32_t request;  /* +0x43 (0x5bb626): hit-testable by the pointer cascade */
    int16_t left;     /* +0x47 (0x5bb62a) */
    int16_t top;      /* +0x49 (0x5bb62c) */
    int16_t right;    /* +0x4b (0x5bb62e) */
    int16_t bottom;   /* +0x4d (0x5bb630) */
    uint8_t done;     /* +0x42 (0x5bb625): completion byte */
} Action17Slot;

/* Process globals the handler reads or writes. */
typedef struct {
    int16_t selector;        /* 0x5bb50b, read */
    int16_t xfer_5bb599;     /* word, prefix +2 */
    int16_t xfer_5bb595;     /* word, prefix +4 */
    int16_t xfer_5c39ff;     /* word, prefix +6 */
    int32_t start_flag_5bb1ca;
    int32_t mode_583999;     /* 4 on finish */
    int32_t xfer_5bb57b;     /* dword, sign-extended prefix word +0 */
    int32_t xfer_5bb59b;     /* dword, prefix +8 */
    int32_t xfer_5bb59f;     /* dword, prefix +12 */
    int32_t xfer_5bb5a3;     /* dword, prefix +16 */
} Action17World;

/* Ordered effect markers for oracles and tests, reported right after the
 * corresponding store in the original's order. */
typedef enum {
    ACTION17_FX_START_FLAG = 1, /* 0x5bb1ca := value */
    ACTION17_FX_PHASE = 2,      /* row phase dword := value */
    ACTION17_FX_REQUEST = 3,    /* request dword := value */
    ACTION17_FX_LEFT = 4,       /* rectangle word stores */
    ACTION17_FX_TOP = 5,
    ACTION17_FX_RIGHT = 6,
    ACTION17_FX_BOTTOM = 7,
    ACTION17_FX_DONE = 8,       /* completion byte := 1 */
    ACTION17_FX_XFER_5BB57B = 9,
    ACTION17_FX_XFER_5BB599 = 10,
    ACTION17_FX_XFER_5BB595 = 11,
    ACTION17_FX_XFER_5C39FF = 12,
    ACTION17_FX_XFER_5BB59B = 13,
    ACTION17_FX_XFER_5BB59F = 14,
    ACTION17_FX_XFER_5BB5A3 = 15,
    ACTION17_FX_MODE = 16       /* 0x583999 := value */
} Action17Effect;

typedef struct {
    void *context;
    /* Optional diagnostic observer (production may leave it NULL). */
    void (*observe)(void *context, int effect, int32_t value);
} Action17Host;

typedef struct {
    uint32_t phase_after;   /* row phase dword after the call */
    int32_t matched_record; /* record index of the phase-1 hit, -1 none */
    uint8_t finished;       /* phase 2 ran: completion byte stored */
    uint8_t requested;      /* request dword is 1 after the call */
} Action17Result;

/* Native safety check of a typed body (see the rejections above); ACTION17_OK
 * or ACTION17_ERR_ARGUMENT / ACTION17_ERR_BOUNDS with a static reason. */
int action17_validate_body(const uint8_t *body, size_t body_length, const char **failure);

/* One true-gate visit of 0x42b07e. The body is the row's typed body. Nothing
 * is changed when a status other than ACTION17_OK is returned; `failure` is
 * optional and receives a static reason. */
int action17_step(const uint8_t *body, size_t body_length, uint32_t phase,
                  Action17Slot *slot, Action17World *world, const Action17Host *host,
                  Action17Result *result, const char **failure);

/* Hover cursor selected by the pointer cascade for a hit on a row of this
 * family. table_offset is the offset of the cursor record from 0x5b160c
 * (index * 32 + variant * 16, stored at 0x5d1631). surface: 0 unchanged, 1 the
 * default cursor surface 0x5d0377, 2 the held-item surface 0x571ad3. */
typedef enum {
    ACTION17_SURFACE_UNCHANGED = 0,
    ACTION17_SURFACE_DEFAULT = 1,
    ACTION17_SURFACE_HELD = 2
} Action17CursorSurface;

typedef struct {
    int32_t cursor_index;  /* 0x5b44f0 */
    int32_t variant;       /* 0x5b44f4 (always 1 after a hit) */
    int32_t table_offset;  /* 0x5d1631 - 0x5b160c */
    int32_t held_flag;     /* 0x5b44f8 */
    int32_t surface;       /* Action17CursorSurface, store to 0x5d162d */
} Action17Cursor;

/* 0x40b2d0: runtime type -> cursor index (0 outside 0x0e..0x19 map). */
uint8_t action17_cursor_index_for_type(uint8_t runtime_type);
/* Cursor of a generic-loop hit on a row of runtime type 0x16..0x19 while the
 * held-item word 0x583a29 is `held_item` (-1 none). ARGUMENT for other types. */
int action17_hover_cursor(uint8_t runtime_type, int16_t held_item, Action17Cursor *out);

#ifdef __cplusplus
}
#endif
#endif
