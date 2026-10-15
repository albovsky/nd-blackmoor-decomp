#ifndef BLACKMOOR_SESSION_NAVIGATION_H
#define BLACKMOOR_SESSION_NAVIGATION_H

/* RT-17: the view-navigation producer of the original, a behavioural C11
 * reconstruction (no original source or compiler provenance is claimed).
 *
 * Two original pieces cooperate through the edge/arrow state 0x5a4c18:
 *
 *  - the pointer cascade 0x4f0059 decides, from the cursor hot point and the
 *    four band edges of the viewport, which arrow zone (if any) the pointer is
 *    in (0x4f18fa..0x4f1dba), stores the state, chooses the arrow cursor
 *    (0x4f1dc4..0x4f1e73) and, when a zone is hit, RETURNS before its generic
 *    row loop (0x4f1e78): no hotspot row is hit-tested and the candidate
 *    0x5c39e5 stays -1;
 *  - the next scene tick (0x43a7ca) acts on that state between its pointer
 *    consume (0x43b194) and the ACT dispatcher call (0x43cf2f): it gates on a
 *    rate-limit deadline 0x63a5c8 and moves the view selector 0x5bb50b (or the
 *    vertical scroll 0x5bb587/0x5bb58f) by one step (0x43c251..0x43c941). A
 *    tick that consumed a primary click skips this block entirely.
 *
 * Addresses in the comments are from GAME.EXE (SHA-256 afd337a2...5c45).
 * Every global the code reads is a field of NavGlobals; the producers of those
 * globals that this module does not reconstruct are named in
 * work/analysis/slices/RT-17.recovery.md. */

#include "session_input.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum SessionNavigationStatus {
    SESSION_NAVIGATION_OK = 0,
    SESSION_NAVIGATION_INVALID_ARGUMENT = 1
} SessionNavigationStatus;

/* The edge/arrow state 0x5a4c18 (0 = none). 1/2: horizontal bands (selector
 * +step / -step), 3/4: vertical scroll up/down, 5..8: corners (scroll up/down
 * plus selector +step / -step). Keys VK_LEFT/RIGHT/UP/DOWN (0x437774) store
 * 1/2/3/4 as well; this module does not model the key handler. */
enum {
    NAV_STATE_NONE = 0,
    NAV_STATE_SELECTOR_PLUS = 1,
    NAV_STATE_SELECTOR_MINUS = 2,
    NAV_STATE_SCROLL_UP = 3,
    NAV_STATE_SCROLL_DOWN = 4,
    NAV_STATE_UP_PLUS = 5,
    NAV_STATE_UP_MINUS = 6,
    NAV_STATE_DOWN_PLUS = 7,
    NAV_STATE_DOWN_MINUS = 8
};

/* Wrap modes of the selector 0x5bb2b6 (scene load default 1, never written
 * elsewhere): 1 wraps around, 2 and 0 clamp. Other values leave the selector
 * outside [min, max] untouched. */
typedef struct NavGlobals {
    int16_t selector;        /* 0x5bb50b */
    int16_t frame_min;       /* 0x5bb4e3 */
    int16_t frame_max;       /* 0x5bb4e5 */
    int16_t step;            /* 0x5bb2c6 (scene load default 1) */
    int16_t mode;            /* 0x5bb2b6 */
    int16_t arrow_width;     /* 0x5bb2ca (default 15; 0 hides the horizontal zones) */
    int16_t arrow_height;    /* 0x5bb2cc (default 15; 0 hides the vertical zones) */
    int16_t hover_delay;     /* 0x5bb2ce, ms (default 400); 0x14d disables hover stepping */
    int16_t key_delay;       /* 0x5bb2d0, ms (default 66); 0x4d selects the alternate arrows */
    int16_t scroll_step;     /* 0x5c39fd, from 0x5bb2c8 (default 10) */
    int32_t scroll;          /* 0x5bb587 */
    int32_t scroll_end;      /* 0x5bb58f */
    int32_t image_bottom;    /* 0x5bb4fd */
    int32_t nav_allowed;     /* 0x5a4c1c: nonzero enables the zone tests */
    int32_t auto_move;       /* 0x5bb206: Game.ini AutoMove (GetPrivateProfileInt default 1) */
    int32_t frames_cached;   /* 0x5a4c20 (read only by key-driven branches) */
    int32_t cursor_mode;     /* 0x583204 (modes 2..5 are UI modes: no step) */
    int32_t state;           /* 0x5a4c18 */
    uint32_t gate_deadline;  /* 0x63a5c8, GetTickCount-based rate limit */
} NavGlobals;

/* Band edges of the viewport (receiver 0x583182 + 0x34/0x38/0x3c/0x40, set at
 * 0x4371ac..0x4371f2 from the viewport and the Game words 0x5b0260/0x5b0262). */
typedef struct NavBands {
    int32_t x1;  /* +0x34 = view left + [0x5b0260] - 1 */
    int32_t y1;  /* +0x38 = view top + [0x5b0262] - 1 */
    int32_t x2;  /* +0x3c = view right - [0x5b0260] + 1 */
    int32_t y2;  /* +0x40 = view bottom - [0x5b0262] + 1 */
} NavBands;

typedef struct NavZoneGeometry {
    SessionInputRect view; /* receiver +4/+8/+0xc/+0x10 = 0x583186/8a/8e/92 */
    NavBands bands;
    int32_t hot_x;         /* 0x58316e = sprite left + hot x */
    int32_t hot_y;         /* 0x58316a = sprite top + hot y */
} NavZoneGeometry;

/* 0x5b44f0 / 0x5b44f4: cursor table index and variant. */
typedef struct NavCursor {
    int32_t index;
    int32_t variant;
} NavCursor;

typedef struct NavZoneResult {
    int32_t state;            /* 0x5a4c18 after the zone tests */
    uint8_t claimed;          /* 0x4f1e73: the cascade returns 1 before its generic loop */
    uint8_t surface_default;  /* 0x5d162d := [0x5d0377] was stored (states 1 and 2) */
    NavCursor cursor;         /* 0x5b44f0/0x5b44f4 after */
    uint32_t table_offset;    /* 0x5d1631 - 0x5b160c = index*32 + variant*16 */
    uint8_t layer_flag;       /* 0x5d1639 := 1 */
} NavZoneResult;

/* 0x4f18fa..0x4f1e73 (and the state-0 tail 0x4f1e7d..0x4f1eae). globals->state
 * is the value of 0x5a4c18 on entry (0x4d3081 clears it right before the
 * cascade, so callers pass 0; a nonzero entry value is honoured as the
 * original does). Pure: nothing is written back. */
int session_navigation_zone(const NavGlobals *globals, const NavZoneGeometry *geometry,
                            const NavCursor *cursor, NavZoneResult *out);

/* Key-held flags the step reads (bytes 0x58321d, 0x58321e, 0x583215,
 * 0x583216, 0x583213, 0x583214, 0x583227, 0x583228, 0x583225, 0x583226). The
 * native app has no keyboard producer and passes all zero. */
typedef struct NavKeys {
    uint8_t f1d, f1e, f15, f16, f13, f14, f27, f28, f25, f26;
} NavKeys;

typedef struct NavStepResult {
    uint8_t entered;           /* 0x43c251 reached: the state switch ran */
    uint8_t view_dirty;        /* [ebp-0x14] at 0x43cc61 (scroll moved or selector clamped) */
    uint8_t selector_changed;  /* 0x5bb50b differs after the step */
    int16_t selector_before;
} NavStepResult;

/* 0x43c133..0x43c941. tick_time is the GetTickCount sample taken at the tick
 * start ([ebp-4]); now is the sample taken after the step (0x43c8c7 / 0x43c917
 * / 0x43c92d) used for the next deadline. Writes selector, scroll, scroll_end
 * and gate_deadline. Call only on a tick that did not consume a primary click
 * and whose secondary consumer 0x4daf6e returned 0 (the caller's boundary). */
int session_navigation_step(NavGlobals *globals, const NavKeys *keys, uint32_t tick_time,
                            uint32_t now, NavStepResult *out);

/* Result of the combined cascade scan. */
typedef struct NavScanResult {
    int32_t candidate;        /* 0x5c39e5 after the cascade */
    int32_t state;            /* 0x5a4c18 after the cascade */
    uint8_t claimed_by_zone;  /* returned at 0x4f1e78 before the generic loop */
    NavZoneResult zone;       /* valid when the zone tests ran (zone_evaluated) */
    uint8_t zone_evaluated;
} NavScanResult;

/* The pointer cascade 0x4f0059 as one pipeline, in the original's order:
 *   overlap guard 0x4f0062..0x4f0126 -> UI members (caller's priority_clear)
 *   -> priority rows (overlay hit test 0x4f104f) -> zone tests 0x4f18fa..
 *   -> generic row loop 0x4f1eb8.
 * input/context/priority/rows are session_input_scan_priority's arguments
 * (context->priority_clear carries the UI-member evidence). A mode 2..5 or
 * producer-disabled tick runs no cascade: state and candidate are cleared
 * (0x4d3081/0x4d308b, 0x43d14e/0x43d158). nav->state receives the new state.
 * Status values are session_input's (including its named limits). */
int session_navigation_scan(SessionInputState *input, const SessionInputContext *context,
                            NavGlobals *nav, const NavBands *bands, NavCursor *cursor,
                            const SessionInputHotspot *priority, size_t priority_count,
                            const SessionInputHotspot *rows, size_t row_count,
                            NavScanResult *out);

#ifdef __cplusplus
}
#endif
#endif
