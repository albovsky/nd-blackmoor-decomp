#include "session_input.h"
#include "input_consume.h"
#include "input_latch.h"

#include <limits.h>
#include <string.h>

static int normal_mode(int32_t mode)
{
    return mode < 2 || mode > 5;
}

static int valid_rect(const SessionInputRect *rect)
{
    return rect->left <= rect->right && rect->top <= rect->bottom;
}

static int32_t wrapping_add(int32_t a, int32_t b)
{
    uint32_t raw = (uint32_t)a + (uint32_t)b;
    int32_t result;
    memcpy(&result, &raw, sizeof(result));
    return result;
}

static int32_t wrapping_sub(int32_t a, int32_t b)
{
    uint32_t raw = (uint32_t)a - (uint32_t)b;
    int32_t result;
    memcpy(&result, &raw, sizeof(result));
    return result;
}

/* 4f0062..4f0126 sprite/viewport overlap; 4f01ae..4f0288 transform.
 * Readiness is a native safety boundary, not a reconstructed original guard. */
static int project(const SessionInputContext *context,
                   SceneExecutorFrameInput *frame)
{
    frame->pointer_x = 0;
    frame->pointer_y = 0;
    frame->pointer_valid = 0;
    frame->cursor_context_allowed = 0;
    frame->modal_event_active = context->modal_event != 0;
    if (!normal_mode(context->cursor_mode) || context->producer_disabled != 0)
        return SESSION_INPUT_OK;
    if (context->geometry_ready == 0)
        return SESSION_INPUT_LIMIT_CURSOR_GEOMETRY;
    if (!valid_rect(&context->viewport))
        return SESSION_INPUT_INVALID_ARGUMENT;
    /* Original compares both endpoints; it does not validate cursor ordering.
     * In particular a right=left-1 sprite inside the viewport still projects. */
    if ((context->cursor.left < context->viewport.left &&
         context->cursor.right < context->viewport.left) ||
        (context->cursor.left > context->viewport.right &&
         context->cursor.right > context->viewport.right) ||
        (context->cursor.top < context->viewport.top &&
         context->cursor.bottom < context->viewport.top) ||
        (context->cursor.top > context->viewport.bottom &&
         context->cursor.bottom > context->viewport.bottom))
        return SESSION_INPUT_OK;
    if (context->priority_clear == 0)
        return SESSION_INPUT_LIMIT_PRIORITY_PATH;
    frame->pointer_x = wrapping_add(
        wrapping_sub(context->cursor.left, context->viewport.left), context->hot_x);
    frame->pointer_y = wrapping_add(wrapping_add(
        wrapping_sub(context->cursor.top, context->viewport.top), context->scroll_y),
        context->hot_y);
    frame->pointer_valid = 1;
    frame->cursor_context_allowed = 1;
    return SESSION_INPUT_OK;
}

int session_input_init(SessionInputState *state)
{
    if (state == NULL) return SESSION_INPUT_INVALID_ARGUMENT;
    memset(state, 0, sizeof(*state));
    state->candidate = -1;
    return SESSION_INPUT_OK;
}

int session_input_feed(SessionInputState *state, SessionInputEvent event,
                       uint32_t flags, int32_t logical_x, int32_t logical_y,
                       SessionInputMessageTail tail, void *tail_context)
{
    InputLatchStateView view;
    InputLatchStatus status;
    if (state == NULL || event < SESSION_INPUT_MOVE || event > SESSION_INPUT_PRIMARY_DBLCLK)
        return SESSION_INPUT_INVALID_ARGUMENT;
    view.bytes = state->latch;
    view.length = sizeof(state->latch);
    if (event == SESSION_INPUT_MOVE) {
        int32_t coordinates[2] = {logical_x, logical_y};
        InputLatchPointView point = {(const uint8_t *)coordinates, sizeof(coordinates)};
        status = input_latch_move(&view, flags, &point);
    } else if (event == SESSION_INPUT_PRIMARY_DOWN) {
        status = input_latch_down(&view, flags, 0);
    } else if (event == SESSION_INPUT_PRIMARY_UP) {
        status = input_latch_up(&view, flags, 0, (uint32_t)state->candidate);
    } else {
        /* 43ecc0 -> 4db04f: only +8 is set. UP leaves the entire latch alone
         * while inhibited; only a subsequent DOWN clears this field. */
        uint32_t inhibited = 1;
        memcpy(state->latch + 8, &inhibited, sizeof(inhibited));
        status = INPUT_LATCH_OK;
    }
    if (status != INPUT_LATCH_OK) return SESSION_INPUT_INVALID_ARGUMENT;
    if (tail != NULL) tail(tail_context, event, flags, logical_x, logical_y);
    return SESSION_INPUT_OK;
}

int session_input_tick(SessionInputState *state, const SessionInputContext *context,
                       SceneExecutorFrameInput *frame)
{
    SessionInputContext snapshot;
    SceneExecutorFrameInput projected = {0};
    InputLatchStateView view;
    uint32_t consumed;
    uintptr_t state_start, frame_start;
    int status;
    if (state == NULL || context == NULL || frame == NULL)
        return SESSION_INPUT_INVALID_ARGUMENT;
    state_start = (uintptr_t)state;
    frame_start = (uintptr_t)frame;
    if (state_start > UINTPTR_MAX - sizeof(*state) ||
        frame_start > UINTPTR_MAX - sizeof(*frame) ||
        (state_start < frame_start + sizeof(*frame) &&
         frame_start < state_start + sizeof(*state)))
        return SESSION_INPUT_INVALID_ARGUMENT;
    snapshot = *context;
    view.bytes = state->latch;
    view.length = sizeof(state->latch);
    if (input_consume_field0(&view, &consumed) != INPUT_CONSUME_OK)
        return SESSION_INPUT_INVALID_ARGUMENT;
    /* Projection readiness is an adapter limit, never a reason to retain an
     * edge after execution has reached the original unconditional consumer. */
    status = project(&snapshot, &projected);
    if (status != SESSION_INPUT_OK) return status;
    /* 43b199 consume precedes 43b1a6 mode switch and 43bfb6 range/modal gate.
     * producer_disabled suppresses only the subsequent scan, not this event. */
    projected.hotspot_activation_event = consumed != 0 &&
        normal_mode(snapshot.cursor_mode) && state->candidate >= 0 && state->candidate < 240;
    frame->pointer_x = projected.pointer_x;
    frame->pointer_y = projected.pointer_y;
    frame->pointer_valid = projected.pointer_valid;
    frame->cursor_context_allowed = projected.cursor_context_allowed;
    frame->modal_event_active = projected.modal_event_active;
    frame->hotspot_activation_event = projected.hotspot_activation_event;
    return SESSION_INPUT_OK;
}

int session_input_scan(SessionInputState *state, const SessionInputContext *context,
                       const SessionInputHotspot *hotspots, size_t count)
{
    SessionInputContext snapshot;
    SceneExecutorFrameInput projected = {0};
    int32_t candidate = -1;
    int32_t previous = -1;
    size_t i;
    int status;
    if (state == NULL || context == NULL || count > 240 || (count != 0 && hotspots == NULL))
        return SESSION_INPUT_INVALID_ARGUMENT;
    snapshot = *context;
    if (snapshot.excluded_0 < -1 || snapshot.excluded_0 >= 240 ||
        snapshot.excluded_1 < -1 || snapshot.excluded_1 >= 240)
        return SESSION_INPUT_INVALID_ARGUMENT;
    for (i = 0; i < count; ++i) {
        const SessionInputHotspot *spot = &hotspots[i];
        if (spot->index <= previous || spot->index >= 240 ||
            spot->rectangle.left < INT16_MIN || spot->rectangle.left > INT16_MAX ||
            spot->rectangle.top < INT16_MIN || spot->rectangle.top > INT16_MAX ||
            spot->rectangle.right < INT16_MIN || spot->rectangle.right > INT16_MAX ||
            spot->rectangle.bottom < INT16_MIN || spot->rectangle.bottom > INT16_MAX)
            return SESSION_INPUT_INVALID_ARGUMENT;
        previous = spot->index;
    }
    status = project(&snapshot, &projected);
    if (status != SESSION_INPUT_OK) return status;
    if (projected.pointer_valid && projected.cursor_context_allowed) {
        for (i = 0; i < count; ++i) {
            const SessionInputHotspot *spot = &hotspots[i];
            if (spot->active != 0 &&
                spot->rectangle.left <= projected.pointer_x &&
                projected.pointer_x <= spot->rectangle.right &&
                spot->rectangle.top <= projected.pointer_y &&
                projected.pointer_y <= spot->rectangle.bottom) {
                /* The same original loop routes these hits to specialized
                 * handlers at 4f2395, before advancing to the next row. */
                if (spot->index == snapshot.excluded_0 || spot->index == snapshot.excluded_1)
                    return SESSION_INPUT_LIMIT_PRIORITY_PATH;
                candidate = spot->index;
                break; /* 4f2305..4f2390 returns on the FIRST generic hit. */
            }
        }
    }
    state->candidate = candidate;
    return SESSION_INPUT_OK;
}

int session_input_publish_candidate(SessionInputState *state, int32_t candidate)
{
    if (state == NULL) return SESSION_INPUT_INVALID_ARGUMENT;
    state->candidate = candidate;
    return SESSION_INPUT_OK;
}
