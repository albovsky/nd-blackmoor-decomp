#ifndef BLACKMOOR_SESSION_BINDINGS_AE0_H
#define BLACKMOOR_SESSION_BINDINGS_AE0_H

#include "action_family_e0_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AE0_TYPE_D6 0xd6
#define SESSION_AE0_TYPE_E0 0xe0

typedef struct SessionAe0Binding SessionAe0Binding;

typedef struct SessionAe0Host {
    E0Host kernel;
    /* Optional: the current value of the process dword 0x5bb57b, read before phase 2 (the failed block tests a stale value).
     * NULL keeps the binding's own copy (initially 9999). */
    int32_t (*scene_cell)(void *context);
    /* Optional: receives the process cells the handler wrote (0x5bb1ca, 0x5bb57b, 0x5d1a8f) after a visit that wrote one. */
    void (*store_world)(void *context, const E0World *world);
} SessionAe0Host;

/* The binding owns the singleton (E0Object) and one zero-padded copy of each 1,733-byte (raw 0xd6) or 294-byte (raw 0xe0) loader
 * allocation per row of the loaded scene. Both raw types reach the same handler with flag 0 / 1. begin_scene runs the scene
 * clear (0x470ddc cleanup of the previous scene, then 0x470e71 round reset); destroy runs the cleanup. Dependencies stay in
 * the executor; only eligible rows reach the handler. Phase 2 reports the generic completion (0x42ba3a) as COMPLETED, so the
 * executor applies the subtype behaviour; phases 0 and 1 are PENDING with the phase the visit ended in. */
SessionAe0Binding *session_ae0_create(const SessionAe0Host *host);
void session_ae0_destroy(SessionAe0Binding *binding);
int session_ae0_begin_scene(SessionAe0Binding *binding, const SceneResource *scene);
int session_ae0_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x470ffe, fed with the view-relative cursor hot spot (x, y). `out` reports the candidate and the cursor index the original
 * writes (0x5c39e5, 0x5b44f0); the host publishes them with the cells 0x5b44f4 / 0x5d1639 := 1, 0x5d162d := [0x5d0377] and
 * 0x5d1631 = 0x5b160c + (cursor << 5) + 0x10. Nothing is claimed while the puzzle is inactive. */
int session_ae0_pointer_move(SessionAe0Binding *binding, int32_t x, int32_t y, E0PointerResult *out);
/* 0x4712bd, run when an accepted release has retained `candidate`. `row_phase` is the executor's phase of the puzzle's row
 * (session_ae0_state()->row). `*new_phase` is 2 when the click asked for the exit; the host then stores phase 2 with
 * scene_executor_accept_action_candidate(row). */
int session_ae0_click(SessionAe0Binding *binding, uint32_t row_phase, int32_t candidate, int32_t start_flag,
                      uint32_t *new_phase);
/* 0x470e31. */
int session_ae0_invalidate(SessionAe0Binding *binding);
/* The blits of one render callback 0x472a5c; plan->valid is 0 when nothing is drawn. */
int session_ae0_render_plan(SessionAe0Binding *binding, E0RenderPlan *plan);
/* Nonzero while the puzzle owns a generic entry. */
unsigned session_ae0_registered(const SessionAe0Binding *binding);
const E0Object *session_ae0_state(const SessionAe0Binding *binding);
const char *session_ae0_failure(const SessionAe0Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
