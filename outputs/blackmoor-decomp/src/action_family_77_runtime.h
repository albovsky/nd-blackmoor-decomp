#ifndef BLACKMOOR_ACTION_FAMILY_77_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_77_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x77, the Ordering Puzzle (RT-49; surface label "DF OrderingPuzzle Surface", up to 16 buttons the
 * player clicks in the right order).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0x77 (0x428f11): gate 0x423f57(deps, 0), then the cdecl handler 0x42ed54(row).
 *   0x42ed54  the handler: a phase switch on the row phase dword (0x5bb632 + row * 0x8d). Phase 0 init, phase 1 an
 *             inner state machine on the process dword 0x5b5162 (0..3), phase 2 finish (generic completion 0x42ba3a).
 *   0x43b3d6..0x43b5d3  the click block inlined in the frame loop: event 0x2719 toggles the hovered button, event
 *             0x271a asks for the exit (row phase := 2).
 *   0x4f0270..0x4f04b6  the pointer case of the cascade 0x4f0059 (button rectangles, then the exit rectangle).
 *   0x4d00f4  the render callback of the static generic Z entry 0x5d1a7b (type 10, boot setup 0x439500).
 *   0x437260 / 0x438a60 / 0x43dd40  scene clears: [0x5b5158] := 0, [0x5d1a8f] := 0, release of [0x5d03cf].
 *
 * Typed body, offsets from the start of the 731-byte body (words signed, dwords signed):
 *   +0x00 NUL-terminated name of the puzzle surface image (CIFTREE), 0x21 bytes
 *   +0x21 N (word, button count, 0..16)
 *   +0x23 + 16*i  selected-state source rectangle of button i (left, top, right, bottom dwords)
 *   +0x123 + 16*i button rectangle of button i (screen destination and hit rectangle, view relative, inclusive)
 *   +0x223 L (word, solution length, 0..16), +0x225 + i solution byte i (button index)
 *   +0x235 9-byte sound record A ("NO SOUND\0" = none): prepared at init, stopped at finish
 *   +0x256 word click sound channel
 *   +0x266 solved scene block: scene word (9999 none) +0x266, words +0x268 +0x26a +0x26c, dwords +0x26e +0x272 +0x276,
 *          start-flag word +0x27a (== 1 stores 0, anything else stores 1)
 *   +0x27c word event flag index (-1 none), +0x27e byte value, +0x27f word delay in seconds
 *   +0x281 9-byte sound record B (win sound, "NO SOUND\0" none), +0x2a2 word win sound channel
 *   +0x2b2 exit scene block (same shape: scene, three words, three dwords, start-flag word +0x2c6)
 *   +0x2c8 word exit event flag index (-1 none), +0x2ca byte value
 *   +0x2cb left, +0x2cf top, +0x2d3 right, +0x2d7 bottom: exit rectangle (dwords, inclusive)
 *
 * Every engine call whose body lies outside this slice is a callback of A77Host in the original order. Nothing here claims
 * original source structure. */

#define A77_RUNTIME_TYPE UINT8_C(0x77)
#define A77_BODY_BYTES 731u
#define A77_MAX_BUTTONS 16
#define A77_NO_SCENE 9999
#define A77_NO_FLAG (-1)
#define A77_CANDIDATE_BUTTON 0x2719 /* the hovered button is a candidate (0x5b515b names it) */
#define A77_CANDIDATE_EXIT 0x271a   /* the exit rectangle is a candidate */
#define A77_CURSOR_EXIT 9           /* [0x5b44f0] := 9 on the exit rectangle */

typedef enum A77Status {
    A77_OK = 0,
    A77_ERR_ARGUMENT = 1,
    A77_ERR_BODY = 2,
    A77_ERR_UNSUPPORTED = 3,
    A77_ERR_HOST = 4,
    A77_ERR_BOUNDS = 5
} A77Status;

/* The process globals 0x5b5128..0x5b516a, 0x5d03cf and the generic Z entry 0x5d1a7b (surface +8, active +0x14). */
typedef struct A77State {
    uint8_t selected[A77_MAX_BUTTONS];  /* 0x5b5128 */
    int16_t order[A77_MAX_BUTTONS];     /* 0x5b5138, -1 = empty */
    uint8_t active;                     /* 0x5b5158 */
    int16_t row;                        /* 0x5b5159 (word) */
    int16_t hover;                      /* 0x5b515b (word): button under the pointer */
    uint8_t exit_requested;             /* 0x5b515d */
    uint32_t deadline;                  /* 0x5b515e (GetTickCount deadline) */
    uint32_t step;                      /* 0x5b5162 (0..3) */
    int16_t count;                      /* 0x5b5166 entries in `order` */
    int16_t limit;                      /* 0x5b5168 */
    uint8_t solved;                     /* 0x5b516a */
    uint32_t surface;                   /* 0x5d03cf puzzle surface handle, 0 none */
    uint32_t overlay_surface;           /* 0x5d1a83 (entry 17 surface; keeps a stale copy after the release) */
    uint32_t overlay_active;            /* 0x5d1a8f */
    uint8_t initialized;                /* native only: phase 0 ran for `row` */
} A77State;

/* Process cells the handler writes besides the globals above. */
typedef struct A77World {
    int32_t start_flag_5bb1ca;
} A77World;

typedef enum A77Effect {
    A77_FX_ACTIVE = 1,           /* 0x5b5158 := a */
    A77_FX_START_FLAG = 2,       /* 0x5bb1ca := a */
    A77_FX_RANDOM = 3,           /* 0x50cd50 returned a */
    A77_FX_RELEASE_SURFACE = 4,  /* 0x4c2dfb(&0x5d03cf), the handle held was a */
    A77_FX_SURFACE_LOAD = 5,     /* 0x4c2790 returned a */
    A77_FX_OVERLAY_SURFACE = 6,  /* 0x5d1a83 := a */
    A77_FX_OVERLAY_ACTIVE = 7,   /* 0x5d1a8f := a */
    A77_FX_SOUND_PREPARE = 8,    /* 0x4fb77a(body + a) */
    A77_FX_SOUND_STOP = 9,       /* 0x4fba69(body + a) */
    A77_FX_SOUND_PLAY = 10,      /* 0x4fb2e3(channel a) */
    A77_FX_SOUND_BUSY = 11,      /* 0x4f6334(channel a) returned b */
    A77_FX_TICK = 12,            /* GetTickCount returned a */
    A77_FX_STEP = 13,            /* 0x5b5162 := a */
    A77_FX_PHASE = 14,           /* row phase := a */
    A77_FX_EVENT_FLAG = 15,      /* dword [0x585801 + 4 * a] := b */
    A77_FX_XFER_5BB57B = 16,     /* dword := sign-extended scene word */
    A77_FX_XFER_5BB599 = 17,     /* word */
    A77_FX_XFER_5BB595 = 18,     /* word */
    A77_FX_XFER_5C39FF = 19,     /* word */
    A77_FX_XFER_5BB59B = 20,     /* dword */
    A77_FX_XFER_5BB59F = 21,     /* dword */
    A77_FX_XFER_5BB5A3 = 22,     /* dword */
    A77_FX_ENGINE_MODE = 23,     /* 0x583999 := 4 */
    A77_FX_COMPLETE = 24         /* 0x42ba3a(row) */
} A77Effect;

typedef struct A77Transition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} A77Transition;

typedef struct A77Host {
    void *context;
    /* 0x50cd50: the CRT rand(), 0..32767. */
    int32_t (*random)(void *);
    /* 0x4c2790("CIFTREE", name, 6, "DF OrderingPuzzle Surface"). Zero on success; the handle may be 0. */
    int (*load_surface)(void *, const char *name, uint32_t *surface);
    /* 0x4c2dfb(&0x5d03cf): the host drops the handle (the kernel zeroes its copy). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4fb77a / 0x4fba69 on the 9-byte record at body + offset (0x235 or 0x281), 0x4fb2e3(channel), 0x4f6334(channel). */
    int (*sound_prepare)(void *, const uint8_t *record);
    int (*sound_stop)(void *, const uint8_t *record);
    int (*sound_play)(void *, int16_t channel);
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* Pure query: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request, then the event flag store. */
    int (*transition)(void *, const A77Transition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    /* The view origin 0x583186 (x) / 0x58318a (y), for the render plan. */
    int (*view_origin)(void *, int32_t *x, int32_t *y);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} A77Host;

typedef struct A77Result {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} A77Result;

/* A power-on state (all globals zero, solution/order arrays empty = -1 is NOT assumed: 0x5b5138 starts as the loader left it,
 * zero; phase 0 writes -1). */
void a77_state_reset(A77State *state);

/* Native safety check of a typed body. Not an original check: the original trusts the loader. Rejects a short body,
 * N or L outside 0..16. `failure` is optional. */
int a77_validate_body(const uint8_t *body, size_t length, const char **failure);

/* One true-gate visit of 0x42ed54. Validation precedes the first effect. A host failure after effects returns A77_ERR_HOST
 * (the original has no recovery); the session must stop. Phase 1 or 2 on a state that phase 0 did not initialise for `row`
 * returns A77_ERR_UNSUPPORTED before any effect. */
int a77_step(A77State *state, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, A77World *world,
             const A77Host *host, A77Result *result, const char **failure);

typedef struct A77PointerResult {
    uint8_t hit;          /* 1 = a case of the cascade claimed the pointer (the original returns 1 there) */
    int32_t candidate;    /* 0x5c39e5 written (0x2719 button, 0x271a exit), -1 when nothing was written */
    int16_t hover;        /* 0x5b515b written (the button index), -1 when nothing was written */
    uint8_t cursor_kind;  /* 0x5b44f0 written (9 on the exit rectangle), 0 when nothing was written */
    uint8_t cursor_sub;   /* 0x5b44f4 written (1 on a button), 0 when nothing was written */
} A77PointerResult;

/* 0x4f0270..0x4f04b6: pointer at view-relative (x, y) = ([event+0x5e], [event+0x5a]). While `active` is 0 nothing is
 * claimed. Buttons 0..N-1 are tested in order, then the exit rectangle; inclusive bounds. */
int a77_pointer(A77State *state, const uint8_t *body, size_t body_length, int32_t x, int32_t y, A77PointerResult *out);

typedef struct A77ClickResult {
    uint8_t toggled;        /* a button was toggled (candidate 0x2719) */
    uint8_t exit_asked;     /* candidate 0x271a: exit_requested := 1 and the row phase becomes 2 */
    uint32_t new_phase;     /* the row phase afterwards (== row_phase unless exit_asked) */
    uint8_t click_sound;    /* 0x4fb2e3(body+0x256) was issued */
} A77ClickResult;

/* 0x43b3d6..0x43b5d3, run on an accepted release with the retained candidate 0x5c39e5 and the process flag 0x5bb1ca
 * (`start_flag`). Nothing happens unless active && !solved. A hovered button outside 0..N-1 returns A77_ERR_BOUNDS before
 * any effect. */
int a77_click(A77State *state, const uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
              int32_t start_flag, const A77Host *host, A77ClickResult *out);

/* The scene clear (0x437260, 0x438a60, 0x43dd40): [0x5b5158] := 0, [0x5d1a8f] := 0 and the release of [0x5d03cf] when it is
 * not zero. */
int a77_clear(A77State *state, const A77Host *host);

/* 0x4d00f4: the blits of one render callback. */
typedef struct A77RenderBlit {
    uint8_t selected;   /* 1: from the puzzle surface (overlay_surface) with the selected-state rectangle,
                           0: from the scene background (generic entry 1 surface, 0x5d15e3) with the button rectangle */
    int32_t src[4];     /* left top right bottom, as stored in the body */
    int32_t dst[4];     /* the button rectangle with the view origin added */
} A77RenderBlit;

typedef struct A77RenderPlan {
    uint8_t valid;      /* 0 when the generic entry 0x5d1a7b is not drawn (overlay_active == 0): the callback itself does not test
                           0x5b5158 */
    uint32_t surface;   /* 0x5d1a83 */
    int32_t count;      /* N */
    A77RenderBlit blit[A77_MAX_BUTTONS];
} A77RenderPlan;

int a77_render_plan(const A77State *state, const uint8_t *body, size_t body_length, const A77Host *host, A77RenderPlan *plan);

#ifdef __cplusplus
}
#endif
#endif
