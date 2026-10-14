#ifndef BLACKMOOR_SESSION_INPUT_H
#define BLACKMOOR_SESSION_INPUT_H

#include "scene_executor.h"
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum SessionInputStatus {
    SESSION_INPUT_OK = 0,
    SESSION_INPUT_INVALID_ARGUMENT = 1,
    SESSION_INPUT_LIMIT_CURSOR_GEOMETRY = 2,
    SESSION_INPUT_LIMIT_PRIORITY_PATH = 3
} SessionInputStatus;

typedef enum SessionInputEvent {
    SESSION_INPUT_MOVE = 0,
    SESSION_INPUT_PRIMARY_DOWN = 1,
    SESSION_INPUT_PRIMARY_UP = 2
} SessionInputEvent;

typedef struct SessionInputRect {
    int32_t left, top, right, bottom;
} SessionInputRect;

typedef struct SessionInputState {
    /* Reviewed 0x4daf9f/0x4dafc3/0x4db000/0x4daf3f layout. */
    uint8_t latch[0x20];
    /* Raw retained 0x5c39e5; -1 means no candidate. Not a down latch. */
    int32_t candidate;
} SessionInputState;

typedef struct SessionInputContext {
    /* Original comparison rectangle at 0x583182+4 and composed cursor
     * rectangle at 0x583102. Both inclusive, in the same logical space.
     * cursor is a displayed sprite rectangle, NOT a WM_MOUSEMOVE point. */
    SessionInputRect viewport;
    SessionInputRect cursor;
    /* Selected 0x5b30cc/0x5b30d0 pair AFTER 4f0059's inventory selection. */
    int32_t hot_x, hot_y;
    int32_t scroll_y;           /* 0x5bb587. No horizontal scroll add here. */
    int32_t cursor_mode;        /* 0x583204 at the consumer/scan. */
    uint32_t modal_event;       /* 0x5c39e9. Zero/nonzero, not a bool enum. */
    uint32_t producer_disabled; /* 0x5839a9: clears candidate at scan only. */
    /* Required evidence/readiness declarations for a needed generic scan.
     * Missing evidence returns a named limit,
     * without changing the latch, candidate or frame. No permissive defaults.
     * geometry_ready includes the original screen-to-logical adapter, cursor
     * polling/warp/size/clamp/render lifecycle and selected hot-point source.
     * priority_clear means 4f0059's earlier UI/puzzle/navigation paths are
     * proved to fall through to its generic action scan for THIS tick. */
    uint32_t geometry_ready;
    uint32_t priority_clear;
    int32_t excluded_0, excluded_1; /* 0x5b4e89 / 0x5b5100; -1 or 0..239. */
} SessionInputContext;

typedef struct SessionInputHotspot {
    int32_t index;
    SessionInputRect rectangle; /* Recovered signed-short rectangle domain. */
    uint32_t active;
} SessionInputHotspot;

/* Optional native stand-in for the shared 0x51ab4b MFC default-message tail.
 * Called synchronously AFTER the latch stores; must not recurse/mutate state.
 * flags and button-event coordinates are ignored by the original latch. */
typedef void (*SessionInputMessageTail)(void *context, SessionInputEvent event,
                                       uint32_t flags, int32_t x, int32_t y);

int session_input_init(SessionInputState *state);
int session_input_feed(SessionInputState *state, SessionInputEvent event,
                       uint32_t flags, int32_t logical_x, int32_t logical_y,
                       SessionInputMessageTail tail, void *tail_context);

/* Call once when execution reaches 43b194's primary consumer, before ACT
 * dispatch. This executes the reviewed 4daf3f consume, including clearing
 * +0/+0x0c even if mode/modal/range guards subsequently reject activation.
 * Only the six pointer/event members are written; current_frame is preserved.
 * A release needs candidate != -1 at MESSAGE time, not a preceding down.
 * Activation uses the retained candidate at CONSUMER time. It is independent
 * of this tick's pointer validity and modal bit (the executor checks modal).
 * Do not call on preparation/media failure before the consumer is reached.
 * frame must not overlap state. Context is snapshotted before any mutation. */
int session_input_tick(SessionInputState *state, const SessionInputContext *context,
                       SceneExecutorFrameInput *frame);

/* Call after ACT dispatch only when the normal cursor scan is reached.
 * Implements the bounded generic 4f0059 action scan with first-hit selection
 * and inclusive bounds. A hit on an excluded special slot returns the priority
 * limit: the original loop invokes that slot's specialized handler.
 * Validates all rows before mutation; rows must be strictly ascending indices 0..239, count <= 240.
 * A mode 2..5 or producer-disabled scan clears the candidate. A missing
 * geometry/priority provider returns a named limit and preserves it.
 * No priority-path decision is fabricated by this function. */
int session_input_scan(SessionInputState *state, const SessionInputContext *context,
                       const SessionInputHotspot *hotspots, size_t count);

/* Alternative to scan when an independently recovered cursor/UI provider
 * supplies the exact raw global (including special event IDs). Never publish
 * a freshly re-hit-tested release position here: WM_LBUTTONUP ignores it. */
int session_input_publish_candidate(SessionInputState *state, int32_t candidate);

#ifdef __cplusplus
}
#endif
#endif
