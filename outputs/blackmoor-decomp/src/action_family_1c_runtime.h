#ifndef BLACKMOOR_ACTION_FAMILY_1C_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_1C_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_1c.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x1c, "interactive video" (RT-57; 2 corpus rows in scenes S2186 and S3420).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x40bc1a  loader arm -> 0x4caff5 (action_family_1c.c): 105 body bytes. The body starts with the NUL-terminated name of an
 *             ".IV" file (the arm 0x4cbba9 passes the body pointer as the name); the body word at +0x21 is nonzero when the row
 *             wants the hotspot render entry.
 *   0x427a50  dispatcher arm 0x427cc3 (type 0x1c, gate 0x423f57 mode 1) -> 0x4cb586(row) on the singleton CInteractiveVideo at
 *             0x63847b. Row state dword [0x5bb632 + row * 0x8d] (the executor's phase):
 *     phase 0 (first visits):  object+0x16 := body pointer. If object+0x1a (the loaded file) is 0: 0x4cbba9 loads the ".IV"
 *             file. The row waits (phase stays 0, nothing else) until the player at 0x637fcf is in state 2 (+0x240) and its
 *             current clip name (the string at pointer +0x22a) equals the file's 33-byte name byte for byte. Then: object+0xc
 *             := -1; if the body word at +0x21 is nonzero, 0x4d39f9 allocates a z entry (0x18..0x3f) and stores type 15,
 *             callback 0x4cc79a, 0, 0, 0, 1, 1, word 0 and the label "INTERACTIVE VIDEO DIAGS" there; object+0x152 := word
 *             [0x583a29]; +0x14a := -1; +8 := 0; +0x12 := 0; +0x154 := 0; +0x14e := 0; +0xe := 1; +0x15c := 0; state := 1;
 *             and the same visit continues with the phase 1 step.
 *     phase 1: +8 := 0, +0x12 := 0. Player state (+0x240) 2 or 3: with state 2 and the player's hotspot index (signed word at
 *             +0x244) not -1: 0x4cb944 finds the file entry whose id word equals the index (linear search, first match); +0x12
 *             := entry (or 0); if found and the index differs from +0x14a: 0x4cb9d1 adds the player's origin (dword +0x12 to
 *             the x fields at +4 and +0xc, dword +0x16 to the y fields at +8 and +0x10 of every 24-byte hotspot rectangle of
 *             the entry; the player's origin object is the pointer at +0x24a, no change when it is null; +0x15c := that
 *             pointer), +8 := 1, +0x14a := index. Any other player state: state := 2.
 *     phase 2: completion byte := 1, 0x4caf8a (free the file tables, release the z entry when object+0xc != -1, reset the
 *             object fields) and the generic completion 0x42ba3a(row).
 *     any other phase: nothing.
 *   0x4cbba9  LoadIVFile: an existing file is freed first (0x4cbb00). An empty name, an open failure or a short read prints a
 *             message and calls 0x4c97b4 (PostQuitMessage): the native module refuses instead. The path is built with sprintf
 *             (format [0x639dae], or [0x639da2] when [0x5bb1fa] is nonzero, then the directory string [0x639db1], the name
 *             and ".IV") and opened "rb"; the host owns that. Layout read: 33 bytes of name, a dword entry count N, then N
 *             entries of 13 bytes {id word, hotspot count word (signed), byte, word, word, pointer} each followed by count * 24
 *             bytes of hotspot rectangles (read as ONE fread of count * 24 bytes with element count 1, so a count of 0 fails
 *             in the CRT, which returns 0 for a zero size).
 *   0x4cc79a  render callback of the z entry: when object+8 is set, draws the rectangles of object+0x12 (each shifted by the
 *             view origin [0x583186] / [0x58318a]) with a color starting at 0x10 and growing by 0x400 per rectangle (16-bit
 *             wrap), then clears +8. The surface [0x5cf665] and the rectangle fill 0x4c7623 are the host's.
 * With the debug flag 0x63a4cd set the original logs; the native module models the flag as 0.
 * Nothing here claims original source structure. */

#define C1C_OK 0
#define C1C_ERR_ARGUMENT 1
#define C1C_ERR_HOST 2
/* Native-only refusals (the original would print a message and post a quit message, or run away). Nothing is kept. */
#define C1C_ERR_FILE 3      /* empty name, file unavailable, short read, entry count outside 0..C1C_MAX_ENTRIES,
                               rectangle count negative or above C1C_MAX_RECTS or zero (the CRT read of 0 bytes fails) */
#define C1C_ERR_BODY 4

#define C1C_NAME_BYTES 33
#define C1C_MAX_ENTRIES 4096
#define C1C_MAX_RECTS 4096
#define C1C_RECT_BYTES 24
#define C1C_BODY_BYTES ACTION_FAMILY_1C_BODY_BYTES
#define C1C_BODY_RENDER_WORD 0x21u /* byte offset of the "wants the render entry" word */
#define C1C_LABEL "INTERACTIVE VIDEO DIAGS"
#define C1C_COLOR_FIRST 0x10
#define C1C_COLOR_STEP 0x400

typedef struct {
    int32_t d[6]; /* +0 and +0x14 untouched; +4 x1, +8 y1, +0xc x2, +0x10 y2 */
} C1cRect;

typedef struct {
    int16_t id;
    int16_t count;
    uint8_t byte_4;
    int16_t word_5;
    int16_t word_7;
    C1cRect *rects; /* count entries */
} C1cEntry;

typedef struct {
    uint8_t name[C1C_NAME_BYTES];
    int32_t count;
    C1cEntry *entries;
} C1cIv;

/* The fields of the singleton at 0x63847b that the handler keeps between visits (scratch fields +0x122..+0x136 and the stale
 * FILE pointer +0x12a are not modelled). */
typedef struct {
    const uint8_t *body;     /* +0x16 */
    C1cIv *iv;               /* +0x1a (0 = nothing loaded) */
    int16_t slot;            /* +0xc (-1 = no z entry) */
    int32_t armed;           /* +0xe */
    int32_t changed;         /* +8 */
    const C1cEntry *record;  /* +0x12 (0 = none) */
    int16_t word_152;        /* +0x152 */
    int32_t last_index;      /* +0x14a */
    int32_t dword_14e;       /* +0x14e */
    int32_t dword_154;       /* +0x154 */
    int32_t dword_158;       /* +0x158 */
    int32_t origin_present;  /* +0x15c (nonzero = the player's origin object pointer was kept) */
} C1cObject;

typedef struct {
    void *context;
    /* The player at 0x637fcf. */
    int (*player_state)(void *context, int32_t *state);                       /* +0x240 */
    int (*player_name)(void *context, uint8_t name[C1C_NAME_BYTES]);          /* string at pointer +0x22a (33 bytes, NUL padded) */
    int (*player_hotspot)(void *context, int16_t *index);                     /* signed word +0x244 */
    int (*player_origin)(void *context, int *present, int32_t *dx, int32_t *dy); /* object at pointer +0x24a: dwords +0x12, +0x16 */
    /* The file. open_iv builds the path and opens it "rb"; read copies exactly `size` bytes and returns the count read (a
     * short return = the CRT fread did not return 1). close is fclose. */
    int (*open_iv)(void *context, const char *name, void **file);
    size_t (*read)(void *context, void *file, void *buffer, size_t size);
    void (*close)(void *context, void *file);
    /* z entry. */
    int (*alloc_slot)(void *context, int16_t *slot);                          /* 0x4d39f9 */
    int (*register_slot)(void *context, int16_t slot, const char *label);     /* the stores listed above */
    int (*release_slot)(void *context, int16_t slot);                         /* 0x4d3992 */
    /* The word cell [0x583a29] copied into object+0x152. */
    int (*cell_583a29)(void *context, int16_t *value);
} C1cHost;

typedef struct {
    uint32_t phase;                                 /* phase to store */
    SceneActionHandlerDisposition disposition;      /* PENDING or COMPLETED (generic completion applies) */
} C1cOutcome;

/* One hotspot fill of the render callback: the rectangle in screen coordinates and the 16-bit color. */
typedef struct {
    int32_t left, top, right, bottom;
    uint16_t color;
} C1cFill;

/* A power-on object: the state the constructor 0x4caed0 leaves through 0x4caf03 (slot -1, last index -1, everything else 0). */
void c1c_object_reset(C1cObject *object);
/* Free the loaded file, if any (0x4cbb00). */
void c1c_free_iv(C1cObject *object);

/* One true-gate visit (0x4cb586). `body` must stay valid until the row completes (the object keeps it). */
int c1c_visit(C1cObject *object, const uint8_t body[C1C_BODY_BYTES], uint32_t phase, const C1cHost *host, C1cOutcome *outcome);

/* The render callback 0x4cc79a. Writes up to `capacity` fills, stores the count in *count (all of them are counted even when the
 * capacity is smaller) and clears object->changed when it was set. view_x / view_y are [0x583186] and [0x58318a]. */
int c1c_render(C1cObject *object, int32_t view_x, int32_t view_y, C1cFill *fills, size_t capacity, size_t *count);

#ifdef __cplusplus
}
#endif
#endif
