#ifndef BLACKMOOR_ACTION_FAMILY_D0_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_D0_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xd0, the Piano Puzzle (RT-50; surface "Piano Puzzle Surface", z entry label "PIANO PUZZLE OVERLAYS":
 * up to 15 keys, each key plays a sound and shows a text, and the last L keys played are compared with the solution).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0xd0 (0x42a0ea): gate 0x423f57(deps, 0), then the thiscall handler 0x48d914(ECX = 0x61d345, row).
 *             The object (CPianoPuzzle, 0x5c bytes) is one static singleton.
 *   0x48d12d  loader (0x40b34a, 0x4103a3): copies the 1979-byte typed body into a fresh row allocation (pData at
 *             0x5bb5e5 + row * 0x8d); src/action_family_d0.[ch] decodes it.
 *   0x48d914  the handler: a phase switch on the row phase dword (0x5bb632 + row * 0x8d). Phase 0 init, phase 1 an inner
 *             state machine on obj+0x2b (0..4), phase 2 finish (generic completion 0x42ba3a, then the cleanup 0x48d09c).
 *   0x48d1e8  pointer hit test (the cascade 0x4f0059 at 0x4f0acf, x = [event+0x5e], y = [event+0x5a], view relative);
 *             0x48d3cb the cursor / candidate writer.
 *   0x48d5f4  click handler (the accepted-release chain, 0x43b273): key press, text, sound.
 *   0x48d89e  solved check (compares the last L keys with the solution).
 *   0x48ded7  the render callback of the dynamic generic z entry (type 10, label above): one opaque blit (0x4c5377).
 *   0x48d0e5  slot invalidate (0x43d910).  0x48d09c / 0x48d067  cleanup (0x438b5d, 0x43de52) and reset.
 *
 * Typed body, offsets from the start of the 1979-byte body (words signed, dwords signed, rectangles are left, top, right,
 * bottom dwords):
 *   +0x000 NUL-terminated name of the puzzle surface image (CIFTREE), 0x21 bytes; an empty name means "no surface"
 *   +0x021 N (word, key count, 0..15)
 *   +0x023 + 16*i  pressed-key source rectangle of key i on the puzzle surface
 *   +0x113 + 16*i  key rectangle of key i (screen destination, view relative; background source for the release blit)
 *   +0x203 + 16*i  hit rectangle of key i (inclusive)
 *   +0x2f3 word cursor kind A, +0x2f5 region A (left top right bottom); +0x305 word cursor kind B, +0x307 region B:
 *          the cursor kind of a key is A when its hit rectangle lies inside region A, else B when inside region B, else 0
 *   +0x317 L (word, solution length, 1..15 natively), +0x319 + 2*i solution word i (key index, compared signed)
 *   +0x337 + 0x42*k  key k: NUL-terminated sound record name (0x21 bytes), then +0x21 the text key (0x21 bytes)
 *   +0x715 sound record C (the key sound: filled from the pressed key's name, "NO SOUND\0" = none), +0x736 word channel C
 *   +0x746 solved scene block: scene word (9999 none) +0x746, words +0x748 +0x74a +0x74c, dwords +0x74e +0x752 +0x756,
 *          start-flag word +0x75a (== 1 stores 0, anything else stores 1), event flag index word +0x75c (-1 none),
 *          value byte +0x75e, word delay in seconds +0x75f
 *   +0x761 sound record W (win sound, "NO SOUND\0" none), +0x782 word win channel
 *   +0x792 exit scene block (same shape: scene, three words, three dwords, start-flag word +0x7a6, flag index word
 *          +0x7a8, value byte +0x7aa), +0x7ab left, +0x7af top, +0x7b3 right, +0x7b7 bottom: exit rectangle (inclusive)
 *
 * Every engine call whose body lies outside this slice is a callback of D0Host in the original order. Nothing here claims
 * original source structure. */

#define D0_RUNTIME_TYPE UINT8_C(0xd0)
#define D0_BODY_BYTES 1979u
#define D0_NAME_BYTES 0x21u
#define D0_MAX_KEYS 15
#define D0_NO_SLOT (-1)
#define D0_NO_SCENE 9999
#define D0_NO_FLAG (-1)
#define D0_CANDIDATE_KEY 0x2765  /* 0x48d3cb: a key is under the pointer */
#define D0_CANDIDATE_EXIT 0x2766 /* 0x48d3cb: the exit rectangle is under the pointer */
#define D0_CURSOR_EXIT 9
#define D0_TEXT_LIMIT 199u       /* longest text the original's 203-byte stack buffer holds with the 4-byte suffix */
#define D0_SOUND_RECORD_BYTES 0x21u
#define D0_TEXT_MAX 0x9c40u      /* 0x48d83c: longer texts are skipped by the original */

/* Body offsets of the sound records the host receives (the `record` arguments are pointers into the body). */
#define D0_OFFSET_KEY_SOUND 0x715u
#define D0_OFFSET_WIN_SOUND 0x761u

/* Handler states (obj+0x2b). */
enum {
    D0_STATE_RELEASE = 0, /* a key sound plays: wait for the deadline, then release the key */
    D0_STATE_IDLE = 1,    /* waiting for a key or the exit (the solved check runs in the render callback) */
    D0_STATE_START_WIN = 2,
    D0_STATE_WAIT_WIN = 3,
    D0_STATE_WIN_SOUND = 4
};

typedef enum D0Status {
    D0_OK = 0,
    D0_ERR_ARGUMENT = 1,
    D0_ERR_BODY = 2,
    D0_ERR_UNSUPPORTED = 3,
    D0_ERR_HOST = 4,
    D0_ERR_BOUNDS = 5
} D0Status;

/* The process global phase 0 and 2 write (0x5bb1ca). */
typedef struct D0World {
    int32_t start_flag_5bb1ca;
} D0World;

/* The singleton at 0x61d345. Offsets are object offsets. */
typedef struct D0Object {
    int16_t slot;       /* +0x1c generic z entry, -1 none */
    int16_t row;        /* +0x1e */
    uint32_t surface;   /* +0x20 puzzle image handle, 0 none */
    uint8_t dirty;      /* +0x24 redraw requested */
    uint8_t check;      /* +0x25 a key was released: restore the background and run the solved check */
    uint8_t pressed;    /* +0x26 a key is shown pressed */
    int16_t hover;      /* +0x27 key under the pointer (pressed key while `pressed`), -1 none */
    int16_t last;       /* +0x29 key played last */
    int32_t state;      /* +0x2b */
    int32_t has_surface;/* +0x2f 1 when the body names a surface */
    int32_t active;     /* +0x33 */
    uint8_t exit_taken; /* +0x37 */
    uint8_t solved;     /* +0x38 */
    uint32_t deadline;  /* +0x39 GetTickCount deadline */
    int16_t order[D0_MAX_KEYS]; /* +0x3d the last L keys played, oldest first */
} D0Object;

typedef enum D0Effect {
    D0_FX_ACTIVE = 1,        /* +0x33 := 1 */
    D0_FX_START_FLAG = 2,    /* 0x5bb1ca := a */
    D0_FX_CLEAR_ITEM = 3,    /* 0x4e8d96 */
    D0_FX_SLOT = 4,          /* 0x4d39f9 returned a */
    D0_FX_SLOT_REGISTER = 5, /* type 10, callback 0x48ded7, flags 0/0/1/1, label */
    D0_FX_SURFACE_LOAD = 6,  /* 0x4c2790 returned a */
    D0_FX_SLOT_SURFACE = 7,  /* slot surface := b (slot a) */
    D0_FX_PHASE = 8,         /* row phase := a */
    D0_FX_STATE = 9,         /* +0x2b := a */
    D0_FX_SOUND_PREPARE = 10,/* 0x4fb77a(body + a) */
    D0_FX_SOUND_STOP = 11,   /* 0x4fba69(body + a) */
    D0_FX_SOUND_PLAY = 12,   /* 0x4fb2e3(channel a) */
    D0_FX_SOUND_BUSY = 13,   /* 0x4f6334(channel a) returned b */
    D0_FX_TICK = 14,         /* GetTickCount returned a */
    D0_FX_XFER_5BB57B = 15,  /* dword := sign-extended scene word */
    D0_FX_XFER_5BB599 = 16,  /* word */
    D0_FX_XFER_5BB595 = 17,  /* word */
    D0_FX_XFER_5C39FF = 18,  /* word */
    D0_FX_XFER_5BB59B = 19,  /* dword */
    D0_FX_XFER_5BB59F = 20,  /* dword */
    D0_FX_XFER_5BB5A3 = 21,  /* dword */
    D0_FX_ENGINE_MODE = 22,  /* 0x583999 := 4 */
    D0_FX_EVENT_FLAG = 23,   /* dword [0x585801 + 4 * a] := b */
    D0_FX_COMPLETE = 24,     /* 0x42ba3a(row) */
    D0_FX_RELEASE_SURFACE = 25, /* 0x4c2dfb(&surface), the handle held was a */
    D0_FX_RELEASE_SLOT = 26, /* 0x4d3992(a) */
    D0_FX_TEXT_LOOKUP = 27,  /* 0x423259(text key of key a) returned a string (b = 1) or NULL (b = 0) */
    D0_FX_TEXT_SHOW = 28,    /* 0x448d11(text + suffix), a = strlen of the shown text */
    D0_FX_BLIT = 29,         /* 0x4c5377 for key a (b = 1 pressed key from the puzzle surface, b = 2 background restore) */
    D0_FX_SOLVED_CHECK = 30  /* entry of 0x48d89e (a = 0); a matching sequence is followed by the state and solved stores */
} D0Effect;

/* The scene-change cells of a finish block (the same shape as the 0x2e arm). */
typedef struct D0Transition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} D0Transition;

typedef struct D0Host {
    void *context;
    /* 0x4d39f9: first free generic z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 10, callback 0x48ded7, surface 0, flags 0, 0, 1, 1, word 0 and the label
     * "PIANO PUZZLE OVERLAYS". */
    int (*register_slot)(void *, int16_t slot, const char *label);
    /* 0x4c2790("CIFTREE", name, 6, "Piano Puzzle Surface"). */
    int (*load_surface)(void *, const char *name, uint32_t *surface);
    /* Entry surface store (0x5d1599). */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x48d0e5: entry +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* The view origin 0x583186 (x) / 0x58318a (y). */
    int (*view_origin)(void *, int32_t *x, int32_t *y);
    /* 0x4e8d96: commits the pending inventory item (phase 0 only). */
    int (*clear_pending_item)(void *);
    /* 0x4fb77a / 0x4fba69 on the sound record embedded in the body (offset 0x715 or 0x761). */
    int (*sound_prepare)(void *, const uint8_t *record);
    int (*sound_stop)(void *, const uint8_t *record);
    /* 0x4fb2e3(channel). */
    int (*sound_play)(void *, int16_t channel);
    /* 0x4f6334(channel): the raw return value (0 or 1 on the paths the handler reaches). */
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* 0x423259(0x619a6b, key): the text of a key, NULL when there is none. The string stays valid until the next call. */
    int (*text_lookup)(void *, const char *key, const char **text);
    /* 0x448d11(0x619a05, [0x5d03b3], text, -1, 0): `text` is the looked-up text with the 4-byte suffix "<e>\0" written over
     * its terminator. */
    int (*text_show)(void *, const char *text);
    /* Pure query for the finish block: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request, then the event flag store. */
    int (*transition)(void *, const D0Transition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} D0Host;

typedef struct D0Result {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} D0Result;

/* A power-on object: 0x48d067 (slot -1, row -1, inactive) over zeroed storage. */
void d0_object_reset(D0Object *object);

/* Native safety check of a typed body. Not an original check: the original trusts the loader. Rejects a short body, a name
 * without NUL in its 0x21 bytes, N outside 0..15, L outside 1..15 (L == 0 makes the original store into the deadline),
 * and for keys 0..N-1 a sound name or text key without NUL in its 0x21 bytes. `failure` is optional. */
int d0_validate_body(const uint8_t *body, size_t length, const char **failure);

/* One true-gate visit of 0x48d914. Validation precedes the first effect. A host failure after effects returns D0_ERR_HOST
 * (the original has no recovery); the session must stop. Phase 1 or 2 on an object that phase 0 did not initialise for `row`
 * returns D0_ERR_UNSUPPORTED before any effect. `failure` is optional. */
int d0_step(D0Object *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, D0World *world,
            const D0Host *host, D0Result *result, const char **failure);

typedef struct D0PointerResult {
    uint8_t hit;          /* 0x48d1e8 return value (1 = the cascade stops here) */
    int32_t candidate;    /* 0x5c39e5 written by 0x48d3cb (0x2765 key, 0x2766 exit), -1 when nothing was written */
    uint8_t cursor_written; /* 0x48d3cb wrote the cursor cells */
    int32_t cursor_kind;  /* 0x5b44f0 (9 on the exit rectangle, else the region kind: word +0x2f3, word +0x305 or 0) */
    int32_t cursor_sub;   /* 0x5b44f4 (1) */
} D0PointerResult;

/* 0x48d1e8 at view-relative (x, y). While `active` is 0 nothing happens. Exit rectangle (only while no key is pressed), then
 * keys 0..N-1 by hit rectangle (a hit claims the pointer), then, while a key is pressed, the key rectangles redraw the
 * pressed key (returns 0). Inclusive bounds. */
int d0_pointer(D0Object *object, const uint8_t *body, size_t body_length, int32_t x, int32_t y, D0PointerResult *out);

typedef struct D0ClickResult {
    uint8_t exit_asked;   /* candidate 0x2766: exit_taken := 1 and the row phase becomes 2 */
    uint8_t key_pressed;  /* candidate 0x2765 ran the press block */
    uint8_t sound_played; /* 0x4fb2e3 was issued */
    uint8_t text_shown;   /* 0x448d11 was issued */
    uint32_t new_phase;   /* the row phase afterwards (== row_phase unless exit_asked) */
} D0ClickResult;

/* 0x48d5f4, run on an accepted release with the retained candidate 0x5c39e5 and the process flag 0x5bb1ca (`start_flag`).
 * Nothing happens unless active && state == IDLE && row_phase == 1. A key press whose hover index is outside 0..N-1 returns
 * D0_ERR_BOUNDS before any effect. The press block copies the key's sound name over the sound record C of `body` (0x715), so
 * `body` is the live row body. A looked-up text longer than D0_TEXT_LIMIT (up to D0_TEXT_MAX; the original overflows its stack
 * buffer there) returns D0_ERR_BOUNDS after the sound effects, with nothing shown; longer than D0_TEXT_MAX is skipped as in the
 * original. */
int d0_click(D0Object *object, uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
             int32_t start_flag, const D0Host *host, D0ClickResult *out);

/* 0x48d0e5. */
int d0_invalidate(D0Object *object, const D0Host *host);

/* 0x48d09c: release the surface and the slot, then the 0x48d067 reset. */
int d0_cleanup(D0Object *object, const D0Host *host);

/* 0x48ded7: one render callback. It changes the object (dirty, check, state, solved) as the original does and reports the
 * blit the host must perform. */
typedef struct D0RenderResult {
    uint8_t valid;       /* 0 when the callback does nothing (no slot, no redraw request, no surface) */
    uint8_t blit;        /* 0 none, 1 pressed key from the puzzle surface, 2 background restore */
    int16_t key;
    uint32_t src_surface; /* the puzzle surface (blit 1) or the background (blit 2: the host's generic entry 1 surface) */
    int32_t src[4];       /* left top right bottom as stored in the body */
    int32_t dst[4];       /* the key rectangle with the view origin added */
    uint8_t solved_check; /* 0x48d89e ran */
} D0RenderResult;

int d0_render(D0Object *object, const uint8_t *body, size_t body_length, const D0Host *host, D0RenderResult *out);

#ifdef __cplusplus
}
#endif
#endif
