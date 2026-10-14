#include "session_exit.h"

#include <string.h>

#define PAYLOAD_TYPE 0u      /* object +0x49 */
#define PAYLOAD_BUDGET 1u    /* object +0x4a (int16) */
#define PAYLOAD_PAUSE 3u     /* object +0x4c (int16) */

#define TBOX_VIEW_TOP 0x04u     /* 0x5b0a16 */
#define TBOX_VIEW_BOTTOM 0x0cu  /* 0x5b0a1e */

static int16_t read_i16(const uint8_t *bytes)
{
    const uint16_t bits = (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
    return bits <= INT16_MAX ? (int16_t)bits : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static int32_t read_i32(const uint8_t *bytes)
{
    const uint32_t bits = (uint32_t)bytes[0] | ((uint32_t)bytes[1] << 8) |
                          ((uint32_t)bytes[2] << 16) | ((uint32_t)bytes[3] << 24);
    return bits <= INT32_MAX ? (int32_t)bits : -1 - (int32_t)(UINT32_MAX - bits);
}

static int32_t sub_i32(int32_t a, int32_t b)
{
    const uint32_t bits = (uint32_t)a - (uint32_t)b;
    return bits <= INT32_MAX ? (int32_t)bits : -1 - (int32_t)(UINT32_MAX - bits);
}

static int32_t add_i32(int32_t a, int32_t b)
{
    const uint32_t bits = (uint32_t)a + (uint32_t)b;
    return bits <= INT32_MAX ? (int32_t)bits : -1 - (int32_t)(UINT32_MAX - bits);
}

static int16_t low_i16(int32_t value)
{
    const uint16_t bits = (uint16_t)((uint32_t)value & 0xFFFFu);
    return bits <= INT16_MAX ? (int16_t)bits : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static void reset_info(SessionExitStepInfo *info)
{
    if (info != NULL) {
        memset(info, 0, sizeof(*info));
    }
}

static int host_failure(SessionExitStepInfo *info, SessionExitBoundary boundary)
{
    if (info != NULL) {
        info->failed_boundary = boundary;
    }
    return SESSION_EXIT_ERR_HOST;
}

int session_exit_init(SessionExit *exit_state, const ActionFamily28Rect *view)
{
    if (exit_state == NULL || view == NULL) {
        return SESSION_EXIT_ERR_ARGUMENT;
    }
    memset(exit_state, 0, sizeof(*exit_state));
    exit_state->g.game_state = SESSION_EXIT_STATE_RUN;
    exit_state->g.popup_flag = 1; /* .data image value at 0x55cd94 */
    exit_state->effect.full_canvas = *view;
    return SESSION_EXIT_OK;
}

int session_exit_request_transition(SessionExit *exit_state,
                                    const SceneTransitionRequest *request)
{
    if (exit_state == NULL || request == NULL) {
        return SESSION_EXIT_ERR_ARGUMENT;
    }
    exit_state->g.scene_request = request->target_scene;           /* 0x427d3a */
    exit_state->g.scene_request_flag = request->opaque_words[2];   /* 0x427d93 */
    exit_state->g.game_state = SESSION_EXIT_STATE_EXIT;            /* 0x427dee */
    return SESSION_EXIT_OK;
}

/* 0x447418: stage 0. */
static int controller_setup(SessionExit *x, const SessionExitHost *host,
                            SessionExitStepInfo *info)
{
    uint8_t *payload = x->effect.active_payload;

    x->g.modal_input = 1;                              /* 0x447422 */
    x->g.redraw_request = 1;                           /* 0x4d36f0 (call 0x4d36ed) */
    x->g.redraw_counter = 0;                           /* 0x4d36fa */
    x->g.first_render_level = 1;                       /* 0x43dbd8 (call 0x43dbd5) */
    x->g.game_state = SESSION_EXIT_STATE_RUN;          /* 0x447436 */
    if (host->nested_scene_tick == NULL ||
        host->nested_scene_tick(host->context) != 0) {
        return host_failure(info, SESSION_EXIT_BOUNDARY_NESTED_TICK);
    }
    x->g.game_state = SESSION_EXIT_STATE_EXIT;         /* 0x447445 */
    if (host->capture == NULL ||
        host->capture(host->context, SESSION_EXIT_CAPTURE_SOURCE) != 0) {
        return host_failure(info, SESSION_EXIT_BOUNDARY_CAPTURE_SOURCE);
    }
    switch (payload[PAYLOAD_TYPE]) {                   /* 0x447465 */
    case 1u:
    case 3u:
        if (host->clear_destination_capture == NULL ||
            host->clear_destination_capture(host->context) != 0) {
            return host_failure(info, SESSION_EXIT_BOUNDARY_CLEAR_DESTINATION);
        }
        x->effect.sequence_counter = 2u;               /* 0x4474a4 */
        break;
    case 2u:
        x->effect.sequence_counter = 1u;               /* 0x4474b0 */
        if (x->g.game_state == SESSION_EXIT_STATE_EXIT) {
            x->g.game_state = SESSION_EXIT_STATE_LOAD; /* 0x4474c0 */
        }
        break;
    default:
        break;
    }
    return SESSION_EXIT_OK;
}

/* 0x4474cf: the destination capture of stage 1. */
static int controller_capture_destination(SessionExit *x, const SessionExitHost *host,
                                          SessionExitStepInfo *info)
{
    uint8_t *payload = x->effect.active_payload;
    const uint8_t type = payload[PAYLOAD_TYPE];

    if (type != 2u && type != 3u) {
        return SESSION_EXIT_OK;
    }
    if (type == 3u) {
        payload[PAYLOAD_TYPE] = 2u;                    /* 0x447514 */
    }
    if (host->capture == NULL ||
        host->capture(host->context, SESSION_EXIT_CAPTURE_DESTINATION) != 0) {
        return host_failure(info, SESSION_EXIT_BOUNDARY_CAPTURE_DESTINATION);
    }
    x->effect.sequence_counter = 2u;                   /* 0x44750f / 0x447530 */
    return SESSION_EXIT_OK;
}

/* 0x44753b through the reviewed A-28 kernel. */
static int controller_sequence(SessionExit *x, const SessionExitHost *host,
                               SessionExitStepInfo *info)
{
    ActionFamily28SequenceState state;
    const uint8_t *payload = x->effect.active_payload;

    memset(&state, 0, sizeof(state));
    state.subtype = payload[PAYLOAD_TYPE];
    state.busy = x->effect.busy;
    state.render_guard = (uint8_t)x->g.modal_input;
    state.redraw_flag = (uint8_t)x->g.cursor_layer;
    state.sequence_budget_ms = read_i16(payload + PAYLOAD_BUDGET);
    state.pause_ms = read_i16(payload + PAYLOAD_PAUSE);
    state.target_rect = x->effect.current_rect;
    state.stage = x->effect.sequence_counter;
    state.scene_state = x->g.game_state;
    state.finalizer_global_5831c8 = (uint32_t)x->g.redraw_request;
    state.finalizer_global_5831c6 = x->g.redraw_counter;
    if (host->run_sequence == NULL ||
        host->run_sequence(host->context, &state) != 0) {
        return host_failure(info, SESSION_EXIT_BOUNDARY_RUN_SEQUENCE);
    }
    x->effect.busy = state.busy;
    x->g.modal_input = state.render_guard;
    x->g.cursor_layer = state.redraw_flag;
    x->effect.sequence_counter = state.stage;
    x->g.game_state = state.scene_state;
    x->g.redraw_request = (int32_t)state.finalizer_global_5831c8;
    x->g.redraw_counter = state.finalizer_global_5831c6;
    return SESSION_EXIT_OK;
}

int session_exit_controller(SessionExit *exit_state,
                            const SessionExitHost *host,
                            SessionExitStepInfo *info)
{
    int status = SESSION_EXIT_OK;

    if (exit_state == NULL || host == NULL) {
        return SESSION_EXIT_ERR_ARGUMENT;
    }
    if (info != NULL) {
        info->stage_before = exit_state->effect.sequence_counter;
    }
    switch (exit_state->effect.sequence_counter) {     /* 0x4473ca, ja 3 -> end */
    case 0u:
        status = controller_setup(exit_state, host, info);
        break;
    case 1u:
        status = controller_capture_destination(exit_state, host, info);
        if (status == SESSION_EXIT_OK) {
            status = controller_sequence(exit_state, host, info);
        }
        break;
    case 2u:
        status = controller_sequence(exit_state, host, info);
        break;
    case 3u:
        exit_state->effect.busy = 0u;                  /* 0x4477be */
        break;
    default:
        break;
    }
    return status;
}

int session_exit_effect_gate(SessionExit *exit_state,
                             const SessionExitHost *host,
                             SessionExitStepInfo *info)
{
    uint8_t should_run = 0u;
    int status;

    reset_info(info);
    if (exit_state == NULL || host == NULL) {
        return SESSION_EXIT_ERR_ARGUMENT;
    }
    if (action_family28_render_gate(exit_state->effect.busy,
                                    exit_state->effect.active_payload[PAYLOAD_TYPE],
                                    exit_state->g.game_state,
                                    exit_state->effect.sequence_counter,
                                    &should_run) != ACTION_FAMILY28_OK) {
        return SESSION_EXIT_ERR_ARGUMENT;
    }
    if (should_run == 0u) {
        return SESSION_EXIT_OK;
    }
    status = session_exit_controller(exit_state, host, info);
    if (status == SESSION_EXIT_OK && info != NULL) {
        info->controller_ran = 1u;
    }
    return status;
}

int session_exit_state4(SessionExit *exit_state,
                        const SessionExitHost *host,
                        SessionExitStepInfo *info)
{
    int status;

    reset_info(info);
    if (exit_state == NULL || host == NULL) {
        return SESSION_EXIT_ERR_ARGUMENT;
    }
    if (exit_state->g.load_game_flag != 0) {
        if (info != NULL) {
            info->unsupported = SESSION_EXIT_UNSUPPORTED_LOAD_GAME;
        }
        return SESSION_EXIT_ERR_UNSUPPORTED;
    }
    if (exit_state->g.popup_flag == 0) {               /* 0x43d26d, call 0x4ee5cd */
        if (info != NULL) {
            info->unsupported = SESSION_EXIT_UNSUPPORTED_SCENE_SUMMARY_CHECK;
        }
        return SESSION_EXIT_ERR_UNSUPPORTED;
    }
    {
        /* Use a local record when the caller omits diagnostics, so the gate's
         * controller result still decides the next state. */
        SessionExitStepInfo local;
        SessionExitStepInfo *effective = info != NULL ? info : &local;
        if (info == NULL) reset_info(&local);
        status = session_exit_effect_gate(exit_state, host, effective);  /* 0x43d69b */
        if (status != SESSION_EXIT_OK) {
            return status;
        }
        if (effective->controller_ran == 0u) {
            exit_state->g.game_state = SESSION_EXIT_STATE_LOAD;     /* 0x43d6a4 */
        }
        return SESSION_EXIT_OK;
    }
}

int session_exit_render_pass(SessionExit *exit_state,
                             const SessionExitHost *host,
                             SessionExitStepInfo *info)
{
    return session_exit_effect_gate(exit_state, host, info);        /* 0x4d00ae */
}

int session_exit_begin_load(SessionExit *exit_state)
{
    if (exit_state == NULL) {
        return SESSION_EXIT_ERR_ARGUMENT;
    }
    exit_state->g.game_state = exit_state->g.scene_request_flag == 0
                                   ? SESSION_EXIT_STATE_INTRO       /* 0x43817e */
                                   : SESSION_EXIT_STATE_RUN;        /* 0x43818a */
    return SESSION_EXIT_OK;
}

int session_exit_finish_intro(SessionExit *exit_state)
{
    if (exit_state == NULL) {
        return SESSION_EXIT_ERR_ARGUMENT;
    }
    exit_state->g.game_state = SESSION_EXIT_STATE_RUN;              /* 0x4381c4 */
    return SESSION_EXIT_OK;
}

int session_exit_clear_latches(SessionExit *exit_state)
{
    if (exit_state == NULL) {
        return SESSION_EXIT_ERR_ARGUMENT;
    }
    exit_state->g.scene_request_flag = 0;     /* 0x43e3d5 */
    exit_state->g.cursor_override = 0;        /* 0x43e3de */
    exit_state->g.latch_5c39ed = 0;           /* 0x43e3e8 */
    exit_state->g.latch_5c39f1 = 0;           /* 0x43e3f2 */
    exit_state->g.latch_5c39f5 = 0;           /* 0x43e3fc */
    exit_state->g.latch_5c39f9 = 0;           /* 0x43e406 */
    exit_state->g.input_latch = -1;           /* 0x43e410 */
    exit_state->g.first_render_level = 1;     /* 0x43e41a, call 0x43dbd5 */
    exit_state->g.exit_hold_63a5c0 = 0;       /* 0x43e41f */
    exit_state->g.exit_hold_63a5c4 = 0;       /* 0x43e429 */
    return SESSION_EXIT_OK;
}

int session_exit_clear_caption(SessionExit *exit_state,
                               CaptionLifecycle *life,
                               const CaptionLifecycleBackend *backend)
{
    int32_t view_top;
    int32_t view_bottom;
    int32_t view_rows;

    if (exit_state == NULL || life == NULL || backend == NULL ||
        life->shared == NULL || life->geometry == NULL) {
        return SESSION_EXIT_ERR_ARGUMENT;
    }
    if (caption_ctb_close(life, backend) != CAPTION_LIFECYCLE_OK) { /* 0x43e1c2 */
        return SESSION_EXIT_ERR_CAPTION;
    }
    view_top = read_i32(life->geometry->tbox + TBOX_VIEW_TOP);
    view_bottom = read_i32(life->geometry->tbox + TBOX_VIEW_BOTTOM);
    view_rows = add_i32(sub_i32(view_bottom, view_top), 1);
    /* 0x43e1c7: movsx word 0x5b0a76 minus the view rows, stored as a word. */
    life->shared->framed_scroll_lines = low_i16(
        sub_i32((int32_t)life->geometry->framed_surface_height, view_rows));
    life->g.framed_clear_request = 0;         /* 0x43e1e5: 0x5b15c8 */
    life->shared->framed_ready = 0;           /* 0x43e1ef: 0x5b15d6 */
    exit_state->g.framed_flag_5b15da = 0;     /* 0x43e1f9 */
    life->shared->caption_finish_flag = 0;    /* 0x43e203: 0x5b1602 */
    life->shared->caption_visible_flag = 0;   /* 0x43e20d: 0x5b1606 */
    exit_state->g.saved_flag_5bb1da = 0;      /* 0x43e217 */
    exit_state->g.redraw_request = 0;         /* 0x43e221: 0x5831c8 */
    return SESSION_EXIT_OK;
}

const char *session_exit_status_string(int status)
{
    switch (status) {
    case SESSION_EXIT_OK: return "ok";
    case SESSION_EXIT_ERR_ARGUMENT: return "invalid argument";
    case SESSION_EXIT_ERR_UNSUPPORTED: return "original branch not reproduced";
    case SESSION_EXIT_ERR_HOST: return "host boundary failed";
    case SESSION_EXIT_ERR_CAPTION: return "caption lifecycle failed";
    default: return "unknown status";
    }
}

const char *session_exit_unsupported_string(SessionExitUnsupported reason)
{
    switch (reason) {
    case SESSION_EXIT_UNSUPPORTED_NONE: return "none";
    case SESSION_EXIT_UNSUPPORTED_LOAD_GAME:
        return "DAT_005bb22a != 0 (load-game exit handler)";
    case SESSION_EXIT_UNSUPPORTED_SCENE_SUMMARY_CHECK:
        return "DAT_0055cd94 == 0 (next-scene summary check 0x43d2f4..0x43d5d2)";
    default: return "unknown";
    }
}
