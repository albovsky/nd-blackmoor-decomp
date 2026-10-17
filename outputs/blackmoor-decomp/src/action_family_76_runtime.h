#ifndef BLACKMOOR_ACTION_FAMILY_76_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_76_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x76, the PASSWORD puzzle (RT-58; the render blit label is "PASSWORD Puzzle Background pSrcSurface"). The player
 * types a word into one or two text fields with a blinking '-' cursor and presses Enter; the typed text is compared (upper case,
 * substring match) with up to five accepted words per field. A right answer leaves through the correct scene block (after the
 * success sound), a wrong one through the wrong block (after the wrong sound), a click on the cancel strip through the cancel block.
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0x76 (0x42902c): gate 0x423f57(deps, 0), then the cdecl handler 0x42fc70(row), one word argument.
 *   0x40dff4  loader arm: copies the 575-byte body into a fresh row allocation (pData at 0x5bb5e5 + row * 0x8d);
 *             src/action_family_76.[ch] decodes it.
 *   0x42fc70  the handler: a phase switch on the row phase dword (0x5bb632 + row * 0x8d). Phase 0 init, phase 1 an inner state
 *             machine on 0x5b61b4 (0..5), phase 2 finish (scene block, generic completion 0x42ba3a).
 *   0x430b9a  the blinking cursor ('-' appended / removed every body+2 milliseconds).
 *   0x437dcd  character message handler: while the puzzle is active and no key is pending it stores an accepted character (filter
 *             0x437ea1) in 0x5b616c and sets 0x5b616b. The other callees of 0x437dcd belong to other puzzles.
 *   0x4f04b6..0x4f05a3  pointer block inside the cascade 0x4f0059 (x = [event+0x5e], y = [event+0x5a], NOT view relative).
 *   0x43a7ca  click block (accepted-release chain, at 0x43beee): candidate 0x2724 while active and not yet correct cancels.
 *   0x43d7f0 / 0x43dbe3 / 0x435015  invalidate (entry flag := 1 while active), scene cleanup (active := 0, entry flag := 0),
 *             new game (active := 0).
 *   0x4d07e7  the render callback of the static generic z entry 22 (flag 0x5d1c01); text draw 0x4d2c20, blit 0x4c5377.
 *   0x4d3836  text width (src/caption_layout_internal.h caption_internal_text_width).
 *
 * Typed body (575 bytes; words and dwords signed little-endian; a rectangle is four dwords left, top, right, bottom):
 *   +0x000 word font index   +0x002 word cursor blink period in milliseconds
 *   +0x004 rectangle of text field 1   +0x014 rectangle of text field 2   +0x024 rectangle of the background restored
 *   +0x034 word count A (accepted words of field 1, 0..5)   +0x036 + 0x21*i accepted word i of field 1 (NUL-terminated)
 *   +0x0db word count B (accepted words of field 2, 0 = single field)   +0x0dd + 0x21*i accepted word i of field 2
 *   +0x182 correct scene block   +0x19b success sound record (name 0x21 bytes, "NO SOUND" none)   +0x1bc word success channel
 *   +0x1cc wrong scene block     +0x1e5 wrong sound record                                         +0x206 word wrong channel
 *   +0x216 cancel scene block    +0x22f cancel rectangle (not shifted by the view origin)
 * A scene block is: scene word (9999 none), words +2 +4 +6, dwords +8 +12 +16, start-flag word +20 (== 1 stores 0, anything else
 * stores 1), event flag index word +22 (-1 none), value byte +24.
 * Rectangles of fields and background are shifted by the view origin (0x583186 x, 0x58318a y) when phase 0 stores them.
 *
 * The process cells 0x5b616b..0x5b61f0 are kept as one byte image (PwdState) so that the oracle compares them byte for byte.
 * Every engine call whose body lies outside this slice is a callback of PwdHost in the original order. Nothing here claims original
 * source structure. The debug flag 0x63a4cd is taken as 0. The case conversion 0x50d0bc is taken in the C locale (0x63cb1c == 0:
 * 'a'..'z' to upper case, every other byte unchanged); the original switches to LCMapStringA after a setlocale call, which the
 * game never makes (not verified for every path). */

#define PWD_RUNTIME_TYPE UINT8_C(0x76)
#define PWD_BODY_BYTES 575u
#define PWD_STATE_BYTES 0x86u
#define PWD_TEXT_BYTES 0x21u
#define PWD_MAX_ACCEPTED 5
#define PWD_MAX_FONT 17
#define PWD_NO_SCENE 9999
#define PWD_NO_FLAG (-1)
#define PWD_CANDIDATE_CANCEL 0x2724 /* 0x4f0599: the pointer is on the cancel strip */
#define PWD_CURSOR_KIND_CANCEL 9    /* 0x5b44f0 */
#define PWD_MAX_OPS 3

/* Offsets inside PwdState (add 0x5b616b for the original address). */
enum {
    PWD_S_KEY_PENDING = 0x00, /* byte 0x5b616b */
    PWD_S_KEY = 0x01,         /* byte 0x5b616c */
    PWD_S_FIELD1 = 0x02,      /* 0x21 bytes 0x5b616d */
    PWD_S_FIELD2 = 0x23,      /* 0x21 bytes 0x5b618e */
    PWD_S_ACTIVE = 0x44,      /* byte 0x5b61af */
    PWD_S_ROW = 0x45,         /* word 0x5b61b0 */
    PWD_S_CANCEL = 0x47,      /* byte 0x5b61b2: the cancel strip was taken */
    PWD_S_WRONG = 0x48,       /* byte 0x5b61b3: the answer was wrong */
    PWD_S_STATE = 0x49,       /* dword 0x5b61b4 */
    PWD_S_BLINK = 0x4d,       /* dword 0x5b61b8: 0 cursor to be shown, 1 to be hidden */
    PWD_S_CORRECT = 0x51,     /* byte 0x5b61bc */
    PWD_S_DEADLINE = 0x52,    /* dword 0x5b61bd: tick of the next cursor toggle */
    PWD_S_RECT_BG = 0x56,     /* 4 dwords 0x5b61c1 */
    PWD_S_RECT_F1 = 0x66,     /* 4 dwords 0x5b61d1 */
    PWD_S_RECT_F2 = 0x76      /* 4 dwords 0x5b61e1 */
};

enum {
    PWD_STATE_FIELD1 = 0,     /* typing into field 1 */
    PWD_STATE_FIELD2 = 1,     /* typing into field 2 */
    PWD_STATE_WRONG_SOUND = 2,/* start the wrong sound */
    PWD_STATE_SUCCESS_WAIT = 3,
    PWD_STATE_WRONG_WAIT = 4,
    PWD_STATE_SUCCESS_SOUND = 5
};

typedef struct PwdState {
    uint8_t b[PWD_STATE_BYTES];
} PwdState;

typedef enum PwdStatus {
    PWD_OK = 0,
    PWD_ERR_ARGUMENT = 1,
    PWD_ERR_BODY = 2,
    PWD_ERR_UNSUPPORTED = 3,
    PWD_ERR_HOST = 4,
    PWD_ERR_BOUNDS = 5
} PwdStatus;

typedef enum PwdEffect {
    PWD_FX_START_FLAG = 1,     /* 0x5bb1ca := a */
    PWD_FX_FONT_ACQUIRE = 2,   /* 0x4c924d(font a) */
    PWD_FX_FONT_RELEASE = 3,   /* 0x4c92c5(font a) */
    PWD_FX_ENTRY_VISIBLE = 4,  /* dword 0x5d1c01 := a */
    PWD_FX_TICK = 5,           /* GetTickCount returned a */
    PWD_FX_PHASE = 6,          /* row phase := a */
    PWD_FX_TEXT_WIDTH = 7,     /* 0x4d3836(field text, font tables) returned a */
    PWD_FX_SOUND_PREPARE = 8,  /* 0x4fb77a(body + a) */
    PWD_FX_SOUND_PLAY = 9,     /* 0x4fb2e3(channel a) */
    PWD_FX_SOUND_BUSY = 10,    /* 0x4f6334(channel a) returned b */
    PWD_FX_SOUND_STOP = 11,    /* 0x4fba69(body + a) */
    PWD_FX_XFER_5BB57B = 12,   /* dword := sign-extended scene word */
    PWD_FX_XFER_5BB599 = 13,   /* word */
    PWD_FX_XFER_5BB595 = 14,   /* word */
    PWD_FX_XFER_5C39FF = 15,   /* word */
    PWD_FX_XFER_5BB59B = 16,   /* dword */
    PWD_FX_XFER_5BB59F = 17,   /* dword */
    PWD_FX_XFER_5BB5A3 = 18,   /* dword */
    PWD_FX_ENGINE_MODE = 19,   /* 0x583999 := 4 */
    PWD_FX_EVENT_FLAG = 20,    /* dword [0x585801 + 4 * a] := b */
    PWD_FX_COMPLETE = 21       /* 0x42ba3a(row a) */
} PwdEffect;

/* The scene-change cells of a finish block (the same shape as the 0x2e arm). The start flag 0x5bb1ca is reported as an effect. */
typedef struct PwdTransition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} PwdTransition;

typedef struct PwdHost {
    void *context;
    /* The view origin: 0x583186 (x) and 0x58318a (y). */
    int (*view_origin)(void *, int32_t *x, int32_t *y);
    /* 0x4c924d / 0x4c92c5: take / drop one reference of the font image. */
    int (*font_acquire)(void *, int16_t font);
    int (*font_release)(void *, int16_t font);
    /* 0x4d3836(text, font tables): the advance width as a signed word. */
    int (*text_width)(void *, int16_t font, const char *text, int16_t *width);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* 0x4fb77a / 0x4fba69 on the sound record embedded in the body. */
    int (*sound_prepare)(void *, const uint8_t *record);
    int (*sound_stop)(void *, const uint8_t *record);
    /* 0x4fb2e3(channel). */
    int (*sound_play)(void *, int16_t channel);
    /* 0x4f6334(channel): the raw return value (0 or nonzero). */
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* Pure query for the finish block: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request, then the event flag store. */
    int (*transition)(void *, const PwdTransition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} PwdHost;

typedef struct PwdResult {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} PwdResult;

/* A power-on state: all zero (inactive). */
void pwd_state_reset(PwdState *state);

/* 0x435015 (new game): active := 0. */
void pwd_new_game(PwdState *state);

/* Native safety check of a typed body. Not an original check: the original trusts the loader. Rejects a short or long body, a
 * font index outside 0..17, a count outside 0..5, an accepted word that is not NUL-terminated within its 0x21 bytes, a sound
 * record name without NUL, and a text field rectangle so narrow that no character could ever be typed is NOT rejected (the
 * original accepts it). `failure` is optional. */
int pwd_validate_body(const uint8_t *body, size_t length, const char **failure);

/* One true-gate visit of 0x42fc70. Validation precedes the first effect. A host failure after effects returns PWD_ERR_HOST (the
 * original has no recovery); the session must stop. Phase 1 or 2 on a state that phase 0 did not initialise for `row` returns
 * PWD_ERR_UNSUPPORTED before any effect, so does an event flag the host refuses. `failure` is optional. */
int pwd_step(PwdState *state, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, const PwdHost *host,
             PwdResult *result, const char **failure);

/* 0x437ea1: nonzero when the character is accepted by the puzzle. */
int pwd_char_accepted(int8_t ch);

/* 0x437dcd, the part that belongs to this puzzle: while active and no key pending, an accepted character is stored. Returns 1
 * when the character was stored. */
int pwd_key(PwdState *state, int8_t ch);

typedef struct PwdPointerResult {
    uint8_t hit;        /* the pointer block returned 1 (the cascade stops here) */
    int32_t candidate;  /* 0x5c39e5 written, -1 when nothing was written */
    int32_t cursor_kind;/* 0x5b44f0 written (9), -1 when nothing was written */
} PwdPointerResult;

/* 0x4f04b6..0x4f05a3 at the event coordinates (x = [event+0x5e], y = [event+0x5a]), signed dwords. Nothing happens unless active.
 * The cursor table cells (0x5d162d, 0x5d1631, 0x5d1639) are written by the host from `cursor_kind` as the original does. */
int pwd_pointer(const PwdState *state, const uint8_t *body, size_t body_length, int32_t x, int32_t y, PwdPointerResult *out);

typedef struct PwdClickResult {
    uint8_t fired;      /* the cancel strip was taken */
    int16_t row;        /* the row whose phase is set */
    uint32_t phase;     /* the row phase stored when fired (2) */
} PwdClickResult;

/* 0x43a7ca on an accepted release with the candidate 0x5c39e5: active, not correct and candidate 0x2724 cancel. */
int pwd_click(PwdState *state, int32_t candidate, PwdClickResult *out);

/* 0x43d7f0: while active the static entry flag 0x5d1c01 := 1. Returns 1 when it must be stored. */
int pwd_invalidate(const PwdState *state);

/* 0x43dbe3: active := 0 and the entry flag 0x5d1c01 := 0 (the font reference is not released, as in the original). */
void pwd_cleanup(PwdState *state);

typedef enum PwdOpKind {
    PWD_OP_BLIT = 1, /* 0x4c5377: the background restore */
    PWD_OP_TEXT = 2  /* 0x4d2c20 */
} PwdOpKind;

typedef struct PwdOp {
    int32_t kind;      /* PwdOpKind */
    int32_t src[4];    /* blit source rectangle contents (raw body +0x24, not shifted) */
    int32_t dst[4];    /* blit destination rectangle contents (0x5b61c1, the view origin already added) */
    char text[PWD_TEXT_BYTES + 1];
    int16_t font;
    int16_t x;         /* rect.left of the field, truncated to a word */
    int16_t y;         /* rect.bottom of the field, truncated to a word */
    uint8_t field;     /* 1 or 2 */
} PwdOp;

typedef struct PwdRenderResult {
    uint16_t count;
    PwdOp op[PWD_MAX_OPS];
} PwdRenderResult;

/* 0x4d07e7: the background restore, the text of field 1 and (only when it is not empty) the text of field 2, in this order. The
 * state is not changed. */
int pwd_render(const PwdState *state, const uint8_t *body, size_t body_length, PwdRenderResult *out);

static inline int16_t pwd_rd16(const uint8_t *p, size_t off)
{
    return (int16_t)(uint16_t)(p[off] | (p[off + 1] << 8));
}

static inline int32_t pwd_rd32(const uint8_t *p, size_t off)
{
    return (int32_t)((uint32_t)p[off] | ((uint32_t)p[off + 1] << 8) | ((uint32_t)p[off + 2] << 16) | ((uint32_t)p[off + 3] << 24));
}

#ifdef __cplusplus
}
#endif
#endif
