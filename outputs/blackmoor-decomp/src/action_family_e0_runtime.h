#ifndef BLACKMOOR_ACTION_FAMILY_E0_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_E0_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xd6 and raw 0xe0, the keypad puzzle (RT-51; entry label "KEYPAD PUZZLE OVERLAYS", surface label
 * "DF KeyPadPuzzle Surface"). One class (the singleton at 0x62387c) serves both raw types: the arm passes a flag, 0 for
 * 0xd6 and 1 for 0xe0.
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arms 0xd6 (0x42a2c0) and 0xe0 (0x42a2fc): gate 0x423f57(deps, 0), then thiscall
 *             0x471722(ECX = 0x62387c, row, flag), `ret 8`.
 *   0x41050b / 0x41053a  loader arms -> 0x470e8e(flag): malloc(0x6c5) and copy 1,733 bytes (0xd6), or malloc(0x126) and copy 294
 *             bytes (0xe0) into the row body; decoders src/action_family_d6.[ch] and src/action_family_e0.[ch].
 *   0x471722  the handler: a phase switch on the row phase dword (0x5bb632 + row * 0x8d). Phase 0 init (row phase := 1), phase
 *             1 a state machine on obj+0xd2c (states 0..4, anything above does nothing), phase 2 the finish (cell block,
 *             generic completion 0x42ba3a, cleanup 0x470ddc).
 *   0x470ffe  pointer hit test (cascade 0x4f0059 at 0x4f0e68, x = [ptr+0x5e], y = [ptr+0x5a], view relative), `ret 8`.
 *   0x4712bd  click (accepted-release chain 0x43b287 at 0x43b2d7), 0x470e31 slot invalidate (0x43d91f at 0x43d99c),
 *             0x470ddc cleanup (also 0x43dea0 at 0x43debb), 0x470e71 scene reset of the process words 0x5957b5 / 0x5957b7
 *             (0x438470 at 0x438494 and 0x4384e4), 0x472a5c the render callback of a generic Z entry of type 10.
 *
 * Typed body, offsets from the start of the body (1,733 bytes for 0xd6, 294 bytes for 0xe0; words and dwords signed; a "rect"
 * is four dwords left, top, right, bottom, view relative and inclusive; a "scene block" is: scene word (9999 none), three
 * words, three dwords, start-flag word, then an event flag word (-1 none) and a value byte):
 *   +0x00 name of the surface image (CIFTREE, NUL terminated within 0x21 bytes)
 *   +0x21 N (word, key count, 0..100; for 0xe0 phase 0 STORES cols * rows here)
 *   +0x23 byte ordered mode (nonzero: the typed code is the order of the clicks and a click on a lit key un-types it)
 *   +0x24 byte exit button present
 *   +0x25 rect: exit button pressed source (sheet)   +0x35 rect: exit button rectangle (hit rectangle and destination)
 *   +0x45 round record 0 (33 bytes): word K (code length), byte ordered, 30 code bytes
 *   +0x66 9-byte sound record A ("NO SOUND\0" = none): prepared at init, stopped at finish   +0x87 word click channel
 *   +0x97 "failed" scene block (scene +0x97, words +0x99 +0x9b +0x9d, dwords +0x9f +0xa3 +0xa7, start-flag word +0xab,
 *         event flag word +0xad, value byte +0xaf)
 *   +0xb0 word delay in seconds   +0xb2 9-byte sound record B (success sound)   +0xd3 word its channel
 *   +0xe3 "exit" scene block (scene +0xe3, words +0xe5 +0xe7 +0xe9, dwords +0xeb +0xef +0xf3, start-flag word +0xf7,
 *         event flag word +0xf9, value byte +0xfb)
 *   +0xfc left, +0x100 top, +0x104 right, +0x108 bottom: exit rectangle (dwords, candidate 0x27ad)
 *   +0x10c word R (rounds for 0xd6 / the scene of 0xe0)
 *   0xe0 only: +0x10e cols, +0x110 rows, +0x112 key width, +0x114 key height, +0x116 x0, +0x118 y0, +0x11a x gap,
 *              +0x11c y gap, +0x11e x0', +0x120 y0', +0x122 x gap', +0x124 y gap'  (words)
 *   0xd6 only: +0x10e + 16 i round light source rects (5), +0x15e + 16 i round light destination rects (5), +0x1ae + 16 i
 *              active light sources (5), +0x1fe + 16 i active light destinations (5), +0x24e byte blink enabled,
 *              +0x24f + 0x21 j round records 1..4, +0x2d3 + 5 s the accepted code sets (5 x 5 bytes),
 *              +0x2ec "all sets" scene block (+0x2ec .. +0x300 start flag, +0x302 event flag, +0x304 value),
 *              +0x305 30 key source rects (120 dwords), +0x4e5 30 key destination rects (120 dwords), +0x6c5 end.
 * The loaded 0xe0 allocation ends at +0x126; the handler also reads +0x24e and the round records +0x24f.. past it (heap
 * garbage in the original). The native body buffer is E0_BODY_CAPACITY bytes with the bytes after the loaded length ZERO;
 * that is the stated native choice, not an original value.
 *
 * Every engine call whose body lies outside this slice is a callback of E0Host in the original order. Nothing here claims
 * original source structure. */

#define E0_RUNTIME_TYPE_D6 UINT8_C(0xd6)
#define E0_RUNTIME_TYPE_E0 UINT8_C(0xe0)
#define E0_BODY_BYTES_D6 1733u
#define E0_BODY_BYTES_E0 294u
#define E0_BODY_CAPACITY 1733u
#define E0_MAX_KEYS 100
#define E0_MAX_CODE 30
#define E0_NO_SCENE 9999
#define E0_NO_FLAG (-1)
#define E0_NO_SLOT (-1)
#define E0_EXIT_KEY 0x28                /* d2a value of the exit button (not a key) */
#define E0_CANDIDATE_KEY 0x27a6         /* a key (or the exit button) is under the pointer */
#define E0_CANDIDATE_EXIT 0x27ad        /* the exit rectangle is under the pointer */
#define E0_CURSOR_EXIT 9
#define E0_CURSOR_PICK 0x16
#define E0_ROUND_BYTES 0x21u            /* one round record */
#define E0_IMAGE_BYTES 0xe0au           /* packed object image (offsets as in the original) */
#define E0_MAX_BLITS 112

typedef enum E0Status {
    E0_OK = 0,
    E0_ERR_ARGUMENT = 1,
    E0_ERR_BODY = 2,
    E0_ERR_UNSUPPORTED = 3,
    E0_ERR_HOST = 4,
    E0_ERR_BOUNDS = 5
} E0Status;

/* The process words and cells phase 0, phase 2 and the scene change write or read. */
typedef struct E0World {
    int32_t start_flag_5bb1ca;  /* written (phase 0, phase 2) */
    int32_t scene_cell_5bb57b;  /* dword: read by the failed block (stale value) and written by every block; the host seeds it */
    int32_t entry17_active_5d1a8f; /* phase 2 stores 0 here (a leftover of the copied Ordering Puzzle code) */
} E0World;

/* The singleton at 0x62387c. Members carry their object offsets; bytes not listed are not modelled. */
typedef struct E0Object {
    int32_t rect_a[E0_MAX_KEYS][4];     /* +0x1c + 16 i  key source rect (sheet) */
    int32_t rect_b[E0_MAX_KEYS][4];     /* +0x65c + 16 i key destination / hit rect */
    uint8_t lit[E0_MAX_KEYS];           /* +0xc9c  key selected */
    uint8_t tiles_visible;              /* +0xd00 */
    int16_t code_len;                   /* +0xd01 K of the current round record */
    uint8_t code_ordered;               /* +0xd03 */
    uint8_t code[E0_MAX_CODE];          /* +0xd04 */
    int16_t rounds;                     /* +0xd22 */
    uint32_t surface;                   /* +0xd24 sheet handle, 0 none */
    int16_t row;                        /* +0xd28 (-1 none) */
    int16_t hover;                      /* +0xd2a key under the pointer (0x28 exit button, -1 none) */
    int32_t state;                      /* +0xd2c */
    int16_t recorded;                   /* +0xd30 entries in `record` */
    int16_t typed;                      /* +0xd32 entries typed */
    int16_t slot;                       /* +0xd38 generic Z entry, -1 none */
    uint8_t exit_pending;               /* +0xd3a exit button pressed */
    uint8_t waiting;                    /* +0xd3b */
    uint8_t blink;                      /* +0xd3c */
    uint8_t flag;                       /* +0xd3d 0 for raw 0xd6, 1 for raw 0xe0 */
    uint8_t active;                     /* +0xd3e */
    uint8_t exit_asked;                 /* +0xd3f */
    uint32_t blink_deadline;            /* +0xd40 */
    uint32_t show_deadline;             /* +0xd44 */
    int16_t pad_d48;                    /* +0xd48 word the unordered click shift writes when the code length is 0 */
    int16_t player[E0_MAX_CODE];        /* +0xd4a typed keys (-1 = empty) */
    int16_t scratch[E0_MAX_CODE];       /* +0xd86 copy used by the unordered compare */
    int16_t record[E0_MAX_CODE];        /* +0xdc2 recorded clicks for the code sets */
    uint8_t solved;                     /* +0xdfe */
    uint8_t solved_sets;                /* +0xdff */
    uint32_t wait_deadline;             /* +0xe00 */
    int16_t set_count;                  /* +0xe06 */
    int16_t scene;                      /* +0xe08 */
    int16_t round;                      /* process word 0x5957b7 (round index) */
    int16_t word_5957b5;                /* process word 0x5957b5 (only reset) */
    uint8_t initialized;                /* native only: phase 0 ran */
} E0Object;

typedef enum E0Effect {
    E0_FX_START_FLAG = 1,       /* 0x5bb1ca := a */
    E0_FX_SLOT = 2,             /* 0x4d39f9 returned a */
    E0_FX_SLOT_REGISTER = 3,    /* entry a: type 10, callback 0x472a5c, surface b, flags 0/0/1/1, label "KEYPAD PUZZLE OVERLAYS" */
    E0_FX_SURFACE_LOAD = 4,     /* 0x4c2790 returned a */
    E0_FX_SLOT_SURFACE = 5,     /* slot a surface := b */
    E0_FX_SOUND_PREPARE = 6,    /* 0x4fb77a(body + a) */
    E0_FX_SOUND_STOP = 7,       /* 0x4fba69(body + a) */
    E0_FX_SOUND_PLAY = 8,       /* 0x4fb2e3(channel a) */
    E0_FX_SOUND_BUSY = 9,       /* 0x4f6334(channel a) returned b */
    E0_FX_TICK = 10,            /* GetTickCount returned a */
    E0_FX_PHASE = 11,           /* row phase := a */
    E0_FX_EVENT_FLAG = 13,      /* dword [0x585801 + 4 * a] := b */
    E0_FX_XFER_5BB57B = 14,     /* dword := sign-extended scene word */
    E0_FX_XFER_5BB599 = 15,     /* word */
    E0_FX_XFER_5BB595 = 16,     /* word */
    E0_FX_XFER_5C39FF = 17,     /* word */
    E0_FX_XFER_5BB59B = 18,     /* dword */
    E0_FX_XFER_5BB59F = 19,     /* dword */
    E0_FX_XFER_5BB5A3 = 20,     /* dword */
    E0_FX_ENGINE_MODE = 21,     /* 0x583999 := 4 */
    E0_FX_ENTRY17_ACTIVE = 22,  /* 0x5d1a8f := a */
    E0_FX_COMPLETE = 23,        /* 0x42ba3a(row) */
    E0_FX_RELEASE_SURFACE = 24, /* 0x4c2dfb(&surface), the handle held was a */
    E0_FX_RELEASE_SLOT = 25,    /* 0x4d3992(a) */
    E0_FX_MARK_DIRTY = 26       /* 0x5d15a5 := 1 on slot a */
} E0Effect;

typedef struct E0Transition {
    int32_t scene;  /* the dword cell 0x5bb57b: the sign-extended scene word, or its stale value when the failed block did not assign it */
    int16_t word[3];
    int32_t dword[3];
} E0Transition;

typedef struct E0Host {
    void *context;
    /* 0x4d39f9: first free generic Z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 10, callback 0x472a5c, surface (the object's current handle, 0 on a first
     * visit), flags 0, 0, 1, 1, word 0 and the label "KEYPAD PUZZLE OVERLAYS". */
    int (*register_slot)(void *, int16_t slot, const char *label, uint32_t surface);
    /* 0x4c2790("CIFTREE", name, 6, "DF KeyPadPuzzle Surface"). */
    int (*load_surface)(void *, const char *name, uint32_t *surface);
    /* Entry surface store (0x5d1599). */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x470e31 / 0x5d15a5: entry +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* The view origin 0x583186 (x) / 0x58318a (y). */
    int (*view_origin)(void *, int32_t *x, int32_t *y);
    /* 0x4fb77a / 0x4fba69 on the 9-byte record at body + offset (0x66 or 0xb2), 0x4fb2e3(channel), 0x4f6334(channel). */
    int (*sound_prepare)(void *, const uint8_t *record);
    int (*sound_stop)(void *, const uint8_t *record);
    int (*sound_play)(void *, int16_t channel);
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request. */
    int (*transition)(void *, const E0Transition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    /* Pure query for the finish block: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} E0Host;

typedef struct E0Result {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} E0Result;

/* A power-on object: static storage zero, then the engine's boot values (row, slot -1). */
void e0_object_reset(E0Object *object);

/* Native safety check of a typed body, `flag` 0 for raw 0xd6 and 1 for raw 0xe0. `body` is E0_BODY_CAPACITY bytes of which
 * `length` are the loaded body (1733 or 294) and the rest ZERO. Not an original check. Rejects: a wrong length, a name
 * without NUL, N outside 0..100 (for 0xe0 the computed (int16)(cols * rows)), cols == 0 with keys, a round record whose
 * code length is outside 0..30, ordered mode with N > 30, 0xd6 code sets that are not a prefix (the original then reads an
 * uninitialised local) and 0xd6 with code sets and N > 29. */
int e0_validate_body(int flag, const uint8_t *body, size_t length, const char **failure);

/* Writes the object into `image` (E0_IMAGE_BYTES, the original offsets) and the modelled-byte mask (1 per byte written). */
void e0_object_pack(const E0Object *object, uint8_t image[E0_IMAGE_BYTES], uint8_t mask[E0_IMAGE_BYTES]);

/* One true-gate visit of 0x471722. `body` is writable: phase 0 of raw 0xe0 stores N at +0x21. Validation precedes the first
 * effect. A host failure after effects returns E0_ERR_HOST (the original has no recovery); the session must stop. Phase 1
 * or 2 on an object that phase 0 did not initialise for `row` returns E0_ERR_UNSUPPORTED before any effect. */
int e0_step(E0Object *object, uint8_t *body, size_t body_length, int flag, int16_t row, uint32_t phase, E0World *world,
            const E0Host *host, E0Result *result, const char **failure);

typedef struct E0PointerResult {
    uint8_t hit;          /* 0x470ffe return value */
    int32_t candidate;    /* 0x5c39e5 written (0x27a6 key / exit button, 0x27ad exit rectangle), -1 when nothing was written */
    uint8_t cursor;       /* 0x5b44f0 written (9 exit rectangle, 0x16 key or exit button), 0 when nothing was written */
} E0PointerResult;

/* 0x470ffe at view-relative (x, y) = ([event+0x5e], [event+0x5a]); the cells 0x5b44f4 := 1, 0x5d1639 := 1 and
 * 0x5d162d := [0x5d0377] accompany every hit, 0x5d1631 = 0x5b160c + (cursor << 5) + 0x10. While the object is not active
 * nothing is claimed (hover := -1 is still stored, as in the original). */
int e0_pointer_move(E0Object *object, const uint8_t *body, size_t body_length, int32_t x, int32_t y, E0PointerResult *out);

/* 0x4712bd, run on an accepted release. `row_phase` is the row phase dword, `candidate` the retained 0x5c39e5, `start_flag`
 * the process cell 0x5bb1ca. `new_phase` receives the row phase afterwards (2 when the exit rectangle was clicked). A key
 * click whose hover index is outside 0..99 returns E0_ERR_BOUNDS before any effect. */
int e0_click(E0Object *object, const uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
             int32_t start_flag, const E0Host *host, uint32_t *new_phase);

/* 0x470e31. */
int e0_invalidate(E0Object *object, const E0Host *host);

/* 0x470ddc: release the surface and the slot, then the 0x470d7a reset. */
int e0_cleanup(E0Object *object, const E0Host *host);

/* 0x470e71, the scene reset: 0x5957b5 := 0, 0x5957b7 := 0. */
void e0_scene_reset(E0Object *object);

/* 0x472a5c: the blits of one render callback. The callback sets `waiting` when it draws the pressed exit button, so the
 * object is not const. `valid` is 0 when the callback draws nothing (tiles_visible == 0). */
typedef enum E0BlitKind {
    E0_BLIT_BG_OPAQUE = 0,    /* 0x4c5377 from the background surface (Z entry 1, 0x5d15e3) */
    E0_BLIT_SHEET_KEYED = 1,  /* 0x4c5d4b (transparent colour) from the sheet (slot surface) */
    E0_BLIT_BG_KEYED = 2      /* 0x4c5d4b from the background surface */
} E0BlitKind;

typedef enum E0BlitRole {
    E0_ROLE_KEY_DOWN = 0,      /* "Keypad buttons down" 0x54c4f4: lit key from the sheet */
    E0_ROLE_KEY_UP = 1,        /* "Keypad buttons up refresh" 0x54c508: unlit key restored from the background */
    E0_ROLE_ROUND_LIGHT = 2,   /* "Keypad buttons down" 0x54c524: round light i (0xd6 only) */
    E0_ROLE_ACTIVE_ERASE = 3,  /* "Keypad buttons down" 0x54c538: current round light, blink phase on (from the background) */
    E0_ROLE_ACTIVE_LIGHT = 4,  /* "Keypad buttons down" 0x54c54c: current round light, blink phase off (from the sheet) */
    E0_ROLE_EXIT_DOWN = 5,     /* "Ordering puzzle pSrcSurface" 0x54c560: exit button pressed */
    E0_ROLE_EXIT_UP = 6        /* "Ordering puzzle pSrcSurface" 0x54c57c: exit button restored */
} E0BlitRole;

typedef struct E0Blit {
    uint8_t kind;
    uint8_t role;
    int32_t src[4]; /* as stored in the object / body (view relative) */
    int32_t dst[4]; /* view origin applied */
} E0Blit;

typedef struct E0RenderPlan {
    uint8_t valid;
    uint32_t surface;   /* the slot surface (object surface) */
    int32_t count;
    E0Blit blit[E0_MAX_BLITS];
} E0RenderPlan;

int e0_render_plan(E0Object *object, const uint8_t *body, size_t body_length, const E0Host *host, E0RenderPlan *plan);

#ifdef __cplusplus
}
#endif
#endif
