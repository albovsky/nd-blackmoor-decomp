#ifndef BLACKMOOR_SESSION_BINDINGS_A77_H
#define BLACKMOOR_SESSION_BINDINGS_A77_H

#include "action_family_77_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A77_TYPE 0x77

typedef struct SessionA77Binding SessionA77Binding;

typedef struct SessionA77Host {
    A77Host kernel;
    /* Optional: receives the process global the handler wrote (0x5bb1ca) after a visit that wrote it. */
    void (*store_world)(void *context, const A77World *world);
} SessionA77Host;

/* The binding owns the process globals of the puzzle (A77State) and one copy of each 731-byte loader allocation per row of
 * the loaded scene. The scene clear (0x437260, 0x438a60, 0x43dd40) runs on begin_scene and destroy. Dependencies stay in
 * the executor; only eligible rows reach the handler. Phase 2 reports the generic completion (0x42ba3a) as COMPLETED, so
 * the executor applies the subtype behaviour; phases 0 and 1 are PENDING with the phase the visit ended in. */
SessionA77Binding *session_a77_create(const SessionA77Host *host);
void session_a77_destroy(SessionA77Binding *binding);
int session_a77_begin_scene(SessionA77Binding *binding, const SceneResource *scene);
int session_a77_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x4f0270..0x4f04b6, fed with the view-relative cursor hot spot (x, y). `out` reports the candidate and the cursor cells the
 * original writes (0x5c39e5, 0x5b44f0, 0x5b44f4); the host publishes them. Nothing is claimed while the puzzle is inactive. */
int session_a77_pointer_move(SessionA77Binding *binding, int32_t x, int32_t y, A77PointerResult *out);
/* 0x43b3d6..0x43b5d3, run when an accepted release has retained `candidate`. `row_phase` is the executor's phase of the
 * puzzle's row (session_a77_state()->row). `*new_phase` is 2 when the click asked for the exit; the host then stores
 * phase 2 with scene_executor_accept_action_candidate(row). */
int session_a77_click(SessionA77Binding *binding, uint32_t row_phase, int32_t candidate, int32_t start_flag,
                      uint32_t *new_phase);
/* The blits of one render callback 0x4d00f4; plan->valid is 0 when the generic entry 0x5d1a7b is not drawn. */
int session_a77_render_plan(SessionA77Binding *binding, A77RenderPlan *plan);
/* Nonzero while the puzzle owns the generic entry (0x5d1a8f != 0). */
unsigned session_a77_registered(const SessionA77Binding *binding);
const A77State *session_a77_state(const SessionA77Binding *binding);
const char *session_a77_failure(const SessionA77Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
