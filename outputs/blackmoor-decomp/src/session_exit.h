#ifndef BLACKMOOR_SESSION_EXIT_H
#define BLACKMOOR_SESSION_EXIT_H

/* RT-5: the scene-exit path of the original main loop.
 *
 * Original state machine (global DAT_00583999, switch at 0x438150):
 *   1  load      LoadNewSceneData 0x439822; the case first sets the next state
 *                to 2 when the word DAT_005c39ff is zero, otherwise 3
 *                (0x43815c..0x43818a), then calls the loader, whose
 *                ClearSceneData call is 0x439cba -> 0x43dbe3
 *   2  intro     0x4381b0..0x4381c4: two scene-sound calls on object 0x5c3a67
 *                (0x4fb018, 0x4fc341), then state := 3
 *   3  run       0x43a7ca (dispatcher 0x427a50, render pass 0x4cf9f4)
 *   4  exit      0x43d227 (the "EndScene" handler)
 * The scene-change row (dispatcher case 0x0a, 0x427d31..0x427dee) stores the
 * target scene, the three tuple words and state := 4; the dispatcher loop
 * header (0x427a8e) re-tests state == 3 for every row, so the pass ends there.
 *
 * What this module reproduces from original bytes
 *   0x43d227  the exit handler, for the one path the native app can reach
 *             (DAT_005bb22a == 0 and DAT_0055cd94 != 0: no scene-file check)
 *   0x447c36  CSpecialEffect gate (called from 0x43d69b and, in state 3, from
 *             the render pass at 0x4d00ae)
 *   0x4473be  the controller stage switch, 0x447418 (stage 0), 0x4474cf and
 *             0x4477b2; the frame loop 0x44753b is the reviewed A-28 kernel
 *             and runs through the host's run_sequence boundary
 *   0x43e1bd..0x43e221 and 0x43e3d5..0x43e433  the caption/frame-text and
 *             input-latch blocks of ClearSceneData
 *
 * Everything the original does through DirectDraw, DirectSound, the nested
 * state-3 tick or the scene file is a host boundary (SessionExitHost). A
 * failed boundary stops the routine with the state written so far; there is no
 * synthetic cleanup, matching the original's fatal paths. */

#include "action_family_28.h"
#include "caption_lifecycle.h"
#include "scene_executor.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_EXIT_STATE_LOAD 1u
#define SESSION_EXIT_STATE_INTRO 2u
#define SESSION_EXIT_STATE_RUN 3u
#define SESSION_EXIT_STATE_EXIT 4u

typedef enum session_exit_status {
    SESSION_EXIT_OK = 0,
    SESSION_EXIT_ERR_ARGUMENT = 1,
    /* An original branch that is not reproduced; see SessionExitStepInfo. */
    SESSION_EXIT_ERR_UNSUPPORTED = 2,
    /* A host boundary reported failure; see SessionExitStepInfo. */
    SESSION_EXIT_ERR_HOST = 3,
    SESSION_EXIT_ERR_CAPTION = 4
} SessionExitStatus;

typedef enum session_exit_unsupported {
    SESSION_EXIT_UNSUPPORTED_NONE = 0,
    /* DAT_005bb22a != 0: the load-game variant of the exit handler. */
    SESSION_EXIT_UNSUPPORTED_LOAD_GAME = 1,
    /* DAT_0055cd94 == 0: the handler first opens the next scene's summary
     * chunk (0x43d2f4..0x43d5d2) and may return to state 3 without a load. */
    SESSION_EXIT_UNSUPPORTED_SCENE_SUMMARY_CHECK = 2
} SessionExitUnsupported;

typedef enum session_exit_boundary {
    SESSION_EXIT_BOUNDARY_NONE = 0,
    SESSION_EXIT_BOUNDARY_NESTED_TICK = 1,
    SESSION_EXIT_BOUNDARY_CAPTURE_SOURCE = 2,
    SESSION_EXIT_BOUNDARY_CAPTURE_DESTINATION = 3,
    SESSION_EXIT_BOUNDARY_CLEAR_DESTINATION = 4,
    SESSION_EXIT_BOUNDARY_RUN_SEQUENCE = 5
} SessionExitBoundary;

typedef enum session_exit_capture {
    /* Captured into object +0x31 (0x447ac7 with the source buffer). */
    SESSION_EXIT_CAPTURE_SOURCE = 0,
    /* Captured into object +0x35. */
    SESSION_EXIT_CAPTURE_DESTINATION = 1
} SessionExitCapture;

/* Process globals the exit path reads or writes, with their original
 * addresses. Widths follow the instruction that touches them. */
typedef struct session_exit_globals {
    uint32_t game_state;            /* 0x583999 */
    int32_t load_game_flag;         /* 0x5bb22a */
    int32_t popup_flag;             /* 0x55cd94 (image value 1) */
    int32_t modal_input;            /* 0x5839a9 */
    int16_t first_render_level;     /* 0x5bb1c4 (word) */
    int32_t cursor_layer;           /* 0x5d1639 */
    int32_t redraw_request;         /* 0x5831c8 */
    uint16_t redraw_counter;        /* 0x5831c6 (word) */
    int32_t scene_request;          /* 0x5bb57b */
    int16_t scene_request_flag;     /* 0x5c39ff (word) */
    int32_t cursor_override;        /* 0x5c39e9 */
    int32_t input_latch;            /* 0x5c39e5 */
    int32_t latch_5c39ed;           /* 0x5c39ed */
    int32_t latch_5c39f1;           /* 0x5c39f1 */
    int32_t latch_5c39f5;           /* 0x5c39f5 */
    int32_t latch_5c39f9;           /* 0x5c39f9 */
    int32_t exit_hold_63a5c0;       /* 0x63a5c0 */
    int32_t exit_hold_63a5c4;       /* 0x63a5c4 */
    int32_t framed_flag_5b15da;     /* 0x5b15da */
    int32_t saved_flag_5bb1da;      /* 0x5bb1da */
} SessionExitGlobals;

/* The CSpecialEffect object at 0x6198d7 plus the globals around it. The
 * object lives in ActionFamily28World: busy +0x1c, rect +0x1d..+0x29, stage
 * +0x2d (sequence_counter), payload +0x49..+0x5d; full_canvas is the VIEW
 * rectangle 0x583186..0x583192. */
typedef struct session_exit {
    SessionExitGlobals g;
    ActionFamily28World effect;
} SessionExit;

/* Host boundaries. Every callback returns 0 on success. */
typedef struct session_exit_host {
    void *context;
    /* 0x447440: call 0x43a7ca (one full state-3 tick of the outgoing scene)
     * with the state temporarily 3. */
    int (*nested_scene_tick)(void *context);
    /* 0x447ac7: copy the back buffer into the source (+0x31) or destination
     * (+0x35) capture buffer. */
    int (*capture)(void *context, SessionExitCapture which);
    /* 0x447498: memset(+0x35, 0, +0x39*12). */
    int (*clear_destination_capture)(void *context);
    /* 0x44753b: the host fills the capture spans, geometry and primary-target
     * fields of `state` and runs action_family28_run_sequence (or its surface
     * wrapper). The fields this module filled are read back afterwards. */
    int (*run_sequence)(void *context, ActionFamily28SequenceState *state);
} SessionExitHost;

typedef struct session_exit_step_info {
    SessionExitUnsupported unsupported;
    SessionExitBoundary failed_boundary;
    /* 0x447c36 return value: nonzero when the controller ran. */
    uint8_t controller_ran;
    /* Stage (+0x2d) the controller entered with. */
    uint32_t stage_before;
} SessionExitStepInfo;

/* Cold state: state 3, load-game flag 0, popup flag 1 (the image value of
 * DAT_0055cd94), effect idle with stage 0 and the given VIEW rectangle. */
int session_exit_init(SessionExit *exit_state, const ActionFamily28Rect *view);

/* Dispatcher case 0x0a (0x427d31..0x427dee): scene request, tuple word 2 into
 * DAT_005c39ff and state := 4. The remaining tuple words stay with the
 * session's SceneTransitionRequest. */
int session_exit_request_transition(SessionExit *exit_state,
                                    const SceneTransitionRequest *request);

/* 0x447c36. `info->controller_ran` mirrors the return value. */
int session_exit_effect_gate(SessionExit *exit_state,
                             const SessionExitHost *host,
                             SessionExitStepInfo *info);

/* 0x4473be: the stage switch. Called by the gate; exposed for tests. */
int session_exit_controller(SessionExit *exit_state,
                            const SessionExitHost *host,
                            SessionExitStepInfo *info);

/* 0x43d227 on its supported path: gate, then state := 1 when the controller
 * did not run. Returns SESSION_EXIT_ERR_UNSUPPORTED (state untouched) for the
 * two branches that are not reproduced. */
int session_exit_state4(SessionExit *exit_state,
                        const SessionExitHost *host,
                        SessionExitStepInfo *info);

/* Render-pass call of the gate in state 3 (0x4d00ae). */
int session_exit_render_pass(SessionExit *exit_state,
                             const SessionExitHost *host,
                             SessionExitStepInfo *info);

/* State-1 case of 0x438150 before the loader runs: state := 2 when
 * DAT_005c39ff is zero, otherwise 3 (0x43815c..0x43818a). */
int session_exit_begin_load(SessionExit *exit_state);

/* RT-11: 0x438173 selects INTRO only for a zero transition word. No general
 * sound reset occurs in LoadNewSceneData/ClearSceneData. In INTRO,
 * 0x4381b5 -> 0x4fb018 unloads the MSND channel (BOOT MSND+0x21, global
 * 0x5b451f) first, then 0..13. Other channels survive, regardless of volume
 * category or playback flags. The duplicate is intentional when MSND < 14.
 * Call after begin_load; apply only in INTRO, after the successor is loaded.
 * Dialogue-object cleanup (0x4730a6 -> 0x4e1d34) and scene-header playback
 * (0x4fc341) are separate paths, not represented by this plan. */
typedef struct session_exit_audio_plan {
    uint16_t channels[15];
    size_t count;
} SessionExitAudioPlan;

int session_exit_plan_audio(const SessionExit *exit_state,
                             uint16_t menu_sound_channel,
                             SessionExitAudioPlan *plan);

/* End of the state-2 case (0x4381c4): state := 3. */
int session_exit_finish_intro(SessionExit *exit_state);

/* ClearSceneData 0x43dbe3, input-latch block 0x43e3d5..0x43e433 (the row
 * count at 0x43e3cc belongs to the action table and is not touched). */
int session_exit_clear_latches(SessionExit *exit_state);

/* ClearSceneData caption block 0x43e1bd..0x43e221, in the original order:
 * close the frame text box (0x4de2d8), recompute DAT_005b0a7c, clear
 * 0x5b15c8, 0x5b15d6, 0x5b15da, 0x5b1602, 0x5b1606, 0x5bb1da, 0x5831c8.
 * Unlike InitStaticSceneData (caption_scene_reset) it leaves the clear
 * counters, the scroll fraction and the scroll source untouched. */
int session_exit_clear_caption(SessionExit *exit_state,
                               CaptionLifecycle *life,
                               const CaptionLifecycleBackend *backend);

const char *session_exit_status_string(int status);
const char *session_exit_unsupported_string(SessionExitUnsupported reason);

#ifdef __cplusplus
}
#endif

#endif
