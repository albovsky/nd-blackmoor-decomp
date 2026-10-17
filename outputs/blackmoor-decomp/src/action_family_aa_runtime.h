#ifndef BLACKMOOR_ACTION_FAMILY_AA_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_AA_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xaa, the Alarm Clock (RT-52; surface "Alarm Clock Surface", z entry label "ALARM CLOCK OVERLAYS": a clock
 * face whose time mode shows the game time and whose alarm mode lets the player step the hour with two buttons and set it).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0xaa (0x42a66e): gate 0x423f57(deps, 0), then the thiscall handler 0x44da08(ECX = 0x624cbf, row).
 *             The object (CAlarmClock, 0x53 bytes) is one static singleton.
 *   0x44d1d1  loader (0x40b34a, 0x4107df): copies the 763-byte typed body into a fresh row allocation (pData at
 *             0x5bb5e5 + row * 0x8d); src/action_family_aa.[ch] decodes it.
 *   0x44da08  the handler: a phase switch on the row phase dword (0x5bb632 + row * 0x8d). Phase 0 init, phase 1 an inner
 *             state machine on obj+0x2d (0..8, jump table 0x44e001), phase 2 finish (generic completion 0x42ba3a, then
 *             the cleanup 0x44d154).
 *   0x44d711  time reader (phase 0): game hour word 0x585d51 and minute word 0x585d4f -> the displayed hour index,
 *             quarter and AM flag.   0x44d8ad  hour step (+1 / -1).   0x44d946  alarm writer (phase 2 on a set).
 *   0x44d28c  pointer hit test (the cascade 0x4f0059 at 0x4f1004, x = [event+0x5e], y = [event+0x5a], view relative);
 *             0x44d597 the button press writer (cursor cells, candidate, button).
 *   0x44d624  click method (called unconditionally on the accepted-release chain at 0x43b3bd; it guards itself).
 *   0x44e035  the render callback of the dynamic generic z entry (type 10, label above), with 0x44d9b5 (view offset).
 *   0x44d19d  slot invalidate (0x43d910 sweep, call at 0x43da64).  0x44d154 / 0x44d107  cleanup (0x438cac, 0x43dfb5) and reset.
 *
 * Typed body, offsets from the start of the 763-byte body (words and dwords signed; a rectangle is four dwords left, top,
 * right, bottom; the bounds of a hit test are inclusive):
 *   +0x000 NUL-terminated name of the clock surface image (CIFTREE), 0x21 bytes
 *   +0x021 minute-digit destination   +0x031 hour-digit destination   +0x041 AM/PM destination
 *   +0x051 time-mode button  +0x061 alarm-mode button  +0x071 set button  +0x081 cancel button
 *   +0x091 increase button   +0x0a1 decrease button    +0x0b1 mode-light destination
 *   +0x0c1 + 16*q  minute digit sources (4 quarters)   +0x101 + 16*h  hour digit sources (12 hours)
 *   +0x1c1 AM source  +0x1d1 PM source  +0x1e1 time-mode down  +0x1f1 alarm-mode down  +0x201 set down  +0x211 cancel down
 *   +0x221 increase down  +0x231 decrease down  +0x241 time-mode light  +0x251 alarm-mode light
 *   +0x261 word press delay in units of 100 ms   +0x263 word cursor kind of a button press
 *   +0x265 sound record B (button sound name, "NO SOUND\0" none), +0x286 word channel B
 *   +0x296 set scene block: scene word (9999 none) +0x296, words +0x298 +0x29a +0x29c, dwords +0x29e +0x2a2 +0x2a6,
 *          start-flag word +0x2aa (== 1 stores 0, anything else stores 1), event flag index word +0x2ac (-1 none),
 *          value byte +0x2ae
 *   +0x2af word delay in seconds before the final sound
 *   +0x2b1 sound record F (final sound, "NO SOUND\0" none), +0x2d2 word channel F
 *   +0x2e2 cancel scene block (same shape: scene, three words, three dwords, start-flag word +0x2f6, flag index word
 *          +0x2f8, value byte +0x2fa)
 *
 * Every engine call whose body lies outside this slice is a callback of AlcHost in the original order. Nothing here claims
 * original source structure. */

#define ALC_RUNTIME_TYPE UINT8_C(0xaa)
#define ALC_BODY_BYTES 763u
#define ALC_NAME_BYTES 0x21u
#define ALC_NO_SLOT (-1)
#define ALC_NO_SCENE 9999
#define ALC_NO_FLAG (-1)
#define ALC_CANDIDATE_BUTTON 0x276e /* 0x44d597: a button is under the pointer */
#define ALC_MAX_BLITS 10

/* Body offsets the host receives (the `record` arguments are pointers into the body). */
#define ALC_OFFSET_BUTTON_SOUND 0x265u
#define ALC_OFFSET_FINAL_SOUND 0x2b1u

/* Buttons (obj+0x31) and handler states (obj+0x2d) share their numbering: a press ends in the state of its button. */
enum {
    ALC_STATE_TIME = 0,      /* time mode: shows the game time; the alarm-mode button is live */
    ALC_STATE_ALARM = 1,     /* alarm mode: time, increase, decrease and set buttons are live */
    ALC_STATE_PRESSED = 2,   /* a button is shown pressed until the deadline, then the state becomes that button */
    ALC_STATE_INCREASE = 3,
    ALC_STATE_DECREASE = 4,
    ALC_STATE_WAIT_SET = 5,  /* waits for the delay in seconds, then plays the final sound */
    ALC_STATE_SET = 6,       /* the set button: starts the delay */
    ALC_STATE_FINAL_SOUND = 7,
    ALC_STATE_CANCEL = 8     /* the cancel button: leaves */
};

typedef enum AlcStatus {
    ALC_OK = 0,
    ALC_ERR_ARGUMENT = 1,
    ALC_ERR_BODY = 2,
    ALC_ERR_UNSUPPORTED = 3,
    ALC_ERR_HOST = 4,
    ALC_ERR_BOUNDS = 5
} AlcStatus;

/* The process globals the handler reads and writes: the start flag 0x5bb1ca, the game hour word 0x585d51 (0..24) and the
 * game minute word 0x585d4f (0..59). */
typedef struct AlcWorld {
    int32_t start_flag_5bb1ca;
    int16_t hour_585d51;
    int16_t minute_585d4f;
} AlcWorld;

/* The singleton at 0x624cbf. Offsets are object offsets. Hour indexes run 0..11 (digit sources), quarters 0..3. */
typedef struct AlcObject {
    int16_t slot;           /* +0x1c generic z entry, -1 none */
    int16_t row;            /* +0x1e */
    uint32_t surface;       /* +0x20 clock image handle, 0 none */
    uint8_t dirty;          /* +0x24 redraw requested */
    int32_t active;         /* +0x25 */
    int32_t over;           /* +0x29 the pointer is inside the clock's bounds */
    int32_t state;          /* +0x2d */
    int32_t button;         /* +0x31 button of the last press */
    int16_t time_hour;      /* +0x35 displayed time: hour index */
    int16_t time_quarter;   /* +0x37 quarter of the hour */
    int32_t time_am;        /* +0x39 nonzero AM, zero PM */
    int16_t alarm_hour;     /* +0x3d alarm being set: hour index */
    int16_t alarm_quarter;  /* +0x3f */
    int32_t alarm_am;       /* +0x41 */
    int32_t restore;        /* +0x45 the six button rectangles must be restored (up) */
    uint8_t canceled;       /* +0x49 cancel was taken */
    uint8_t set;            /* +0x4a set was taken */
    uint32_t press_deadline;/* +0x4b */
    uint32_t final_deadline;/* +0x4f */
} AlcObject;

typedef enum AlcEffect {
    ALC_FX_START_FLAG = 1,     /* 0x5bb1ca := a */
    ALC_FX_SLOT = 2,           /* 0x4d39f9 returned a */
    ALC_FX_SLOT_REGISTER = 3,  /* type 10, callback 0x44e035, flags 0/0/1/1, label */
    ALC_FX_SURFACE_LOAD = 4,   /* 0x4c2790 returned a */
    ALC_FX_SLOT_SURFACE = 5,   /* slot surface := b (slot a) */
    ALC_FX_PHASE = 6,          /* row phase := a */
    ALC_FX_SOUND_PREPARE = 7,  /* 0x4fb77a(body + a) */
    ALC_FX_SOUND_STOP = 8,     /* 0x4fba69(body + a) */
    ALC_FX_SOUND_PLAY = 9,     /* 0x4fb2e3(channel a) */
    ALC_FX_SOUND_BUSY = 10,    /* 0x4f6334(channel a) returned b */
    ALC_FX_TICK = 11,          /* GetTickCount returned a */
    ALC_FX_XFER_5BB57B = 12,   /* dword := sign-extended scene word */
    ALC_FX_XFER_5BB599 = 13,   /* word */
    ALC_FX_XFER_5BB595 = 14,   /* word */
    ALC_FX_XFER_5C39FF = 15,   /* word */
    ALC_FX_XFER_5BB59B = 16,   /* dword */
    ALC_FX_XFER_5BB59F = 17,   /* dword */
    ALC_FX_XFER_5BB5A3 = 18,   /* dword */
    ALC_FX_ENGINE_MODE = 19,   /* 0x583999 := 4 */
    ALC_FX_EVENT_FLAG = 20,    /* dword [0x585801 + 4 * a] := b */
    ALC_FX_COMPLETE = 21,      /* 0x42ba3a(row) */
    ALC_FX_RELEASE_SURFACE = 22, /* 0x4c2dfb(&surface), the handle held was a */
    ALC_FX_RELEASE_SLOT = 23,  /* 0x4d3992(a) */
    ALC_FX_IDLE_TIMER = 24,    /* 0x44d107 -> 0x4d3c31 / 0x4d3d20 on the object at 0x61c387 */
    ALC_FX_HOUR_STORE = 25,    /* word [0x585d51] := a (0x44d946) */
    ALC_FX_MINUTE_STORE = 26,  /* word [0x585d4f] := a (0x44d946) */
    ALC_FX_BLIT = 27           /* 0x4c5377, blit kind a (AlcBlitKind) */
} AlcEffect;

/* The scene-change cells of a finish block (the same shape as the 0x2e arm). */
typedef struct AlcTransition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} AlcTransition;

typedef struct AlcHost {
    void *context;
    /* 0x4d39f9: first free generic z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 10, callback 0x44e035, surface 0, flags 0, 0, 1, 1, word 0 and the label
     * "ALARM CLOCK OVERLAYS". */
    int (*register_slot)(void *, int16_t slot, const char *label);
    /* 0x4c2790("CIFTREE", name, 6, "Alarm Clock Surface"). */
    int (*load_surface)(void *, const char *name, uint32_t *surface);
    /* Entry surface store (0x5d1599). */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x44d19d: entry +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* The view origin 0x583186 (x) / 0x58318a (y). */
    int (*view_origin)(void *, int32_t *x, int32_t *y);
    /* 0x4fb77a / 0x4fba69 on the sound record embedded in the body (offset 0x265 or 0x2b1). */
    int (*sound_prepare)(void *, const uint8_t *record);
    int (*sound_stop)(void *, const uint8_t *record);
    /* 0x4fb2e3(channel). */
    int (*sound_play)(void *, int16_t channel);
    /* 0x4f6334(channel): the raw return value (0 or 1 on the paths the handler reaches). */
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* The reset 0x44d107 asks the object at 0x61c387 (0x4d3c31 reads its word +0x1c; when nonzero 0x4d3d20 stores
     * GetTickCount() - 5 in its +0x456): the host performs both. */
    int (*touch_idle_timer)(void *);
    /* Pure query for the finish block: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request, then the event flag store. */
    int (*transition)(void *, const AlcTransition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} AlcHost;

typedef struct AlcResult {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} AlcResult;

/* A power-on object: zeroed storage with the 0x44d107 stores (slot -1, row -1, inactive). The host timer touch of 0x44d107
 * is not issued here. */
void alc_object_reset(AlcObject *object);

/* Native safety check of a typed body. Not an original check: the original trusts the loader. Rejects a short body and a
 * name, button sound name or final sound name without NUL in its 0x21 bytes. `failure` is optional. */
int alc_validate_body(const uint8_t *body, size_t length, const char **failure);

/* One true-gate visit of 0x44da08. Validation precedes the first effect. A host failure after effects returns ALC_ERR_HOST
 * (the original has no recovery); the session must stop. Phase 1 or 2 on an object that phase 0 did not initialise for `row`
 * returns ALC_ERR_UNSUPPORTED before any effect. `failure` is optional. */
int alc_step(AlcObject *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, AlcWorld *world,
             const AlcHost *host, AlcResult *result, const char **failure);

typedef struct AlcPointerResult {
    uint8_t hit;          /* 0x44d28c return value (1 = the cascade stops here) */
    int32_t candidate;    /* 0x5c39e5 written by 0x44d597 (0x276e), -1 when nothing was written */
    uint8_t cursor_written; /* 0x44d597 wrote the cursor cells */
    int32_t cursor_kind;  /* 0x5b44f0 (word +0x263) */
    int32_t cursor_sub;   /* 0x5b44f4 (1) */
} AlcPointerResult;

/* 0x44d28c at view-relative (x, y), both taken as signed 16-bit words. While `active` is 0 only the redraw request is cleared.
 * Inclusive bounds; see the source for the hit order. */
int alc_pointer(AlcObject *object, const uint8_t *body, size_t body_length, int32_t x, int32_t y, AlcPointerResult *out);

typedef struct AlcClickResult {
    uint8_t fired;        /* the guard held: state became PRESSED */
    uint8_t sound_played; /* 0x4fb2e3 was issued */
} AlcClickResult;

/* 0x44d624, run on an accepted release with the row phase and the process flag 0x5bb1ca (`world->start_flag_5bb1ca`).
 * Nothing happens unless active && !canceled && over && row_phase == 1. */
int alc_click(AlcObject *object, const uint8_t *body, size_t body_length, uint32_t row_phase, const AlcWorld *world,
              const AlcHost *host, AlcClickResult *out);

/* 0x44d19d. */
int alc_invalidate(AlcObject *object, const AlcHost *host);

/* 0x44d154: release the surface and the slot, then the 0x44d107 reset (with the idle timer touch). */
int alc_cleanup(AlcObject *object, const AlcHost *host);

/* 0x44e035: one render callback. It changes the object (restore, dirty) as the original does and reports the blits the host
 * must perform, in order. */
typedef enum AlcBlitKind {
    ALC_BLIT_AM = 1,         /* "AM Overlay" */
    ALC_BLIT_PM = 2,         /* "PM Overlay" */
    ALC_BLIT_LIGHT_TIME = 3, /* "Time Mode Light Overlay" */
    ALC_BLIT_LIGHT_ALARM = 4,/* "Alarm Mode Light Overlay" */
    ALC_BLIT_HOUR = 5,       /* "Clock Hour Digits Overlays" */
    ALC_BLIT_MINUTE = 6,     /* "Clock Minute Digits Overlays" */
    ALC_BLIT_DOWN_TIME = 7,  /* "Clock Time Mode Down" */
    ALC_BLIT_DOWN_ALARM = 8, /* "Clock Alarm Mode Down" */
    ALC_BLIT_DOWN_SET = 9,   /* "Clock Alarm Set Down" */
    ALC_BLIT_DOWN_INCREASE = 10, /* "Clock Alarm Increase Down" */
    ALC_BLIT_DOWN_DECREASE = 11, /* "Clock Alarm Decrease Down" */
    ALC_BLIT_DOWN_CANCEL = 12,   /* "Clock Cancel Down" */
    ALC_BLIT_UP_CANCEL = 13,     /* "Cancel up" */
    ALC_BLIT_UP_ALARM = 14,      /* "Alarm button up" */
    ALC_BLIT_UP_TIME = 15,       /* "Time button up" */
    ALC_BLIT_UP_SET = 16,        /* "Set button up" */
    ALC_BLIT_UP_INCREASE = 17,   /* "Increase button up" */
    ALC_BLIT_UP_DECREASE = 18    /* "Decrease button up" */
} AlcBlitKind;

typedef struct AlcBlit {
    int32_t kind;         /* AlcBlitKind */
    uint32_t src_surface; /* the clock surface (kinds 1..12) or 0 = the host's generic entry 1 surface (0x5d15e3, kinds 13..18) */
    int32_t src[4];       /* left top right bottom as stored in the body */
    int32_t dst[4];       /* the destination rectangle with the view origin added */
} AlcBlit;

typedef struct AlcRenderResult {
    uint8_t valid;        /* 0 when the callback is never called (no slot) */
    uint8_t count;
    AlcBlit blit[ALC_MAX_BLITS];
} AlcRenderResult;

/* An hour index outside 0..11 or a quarter outside 0..3 (the original indexes past the body) returns ALC_ERR_BOUNDS before
 * any change. */
int alc_render(AlcObject *object, const uint8_t *body, size_t body_length, const AlcHost *host, AlcRenderResult *out);

#ifdef __cplusplus
}
#endif
#endif
