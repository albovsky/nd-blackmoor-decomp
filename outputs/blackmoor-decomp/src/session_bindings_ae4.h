#ifndef BLACKMOOR_SESSION_BINDINGS_AE4_H
#define BLACKMOOR_SESSION_BINDINGS_AE4_H

#include "action_family_e4_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AE4_TYPE 0xe4

typedef struct SessionAe4Binding SessionAe4Binding;

typedef struct SessionAe4Host {
    E4rHost kernel;
    /* Optional: receives the process cells the handler wrote (the start flag 0x5bb1ca; the high score table stays in the binding)
     * after a visit that initialised or completed the puzzle. */
    void (*store_world)(void *context, const E4rWorld *world);
} SessionAe4Host;

/* RT-54. The binding owns the singleton (CMatchPuzzle, 0x622fa2), the process cells of the handler (E4rWorld: the start flag and
 * the high score table 0x5a0545 / 0x5a0549) and one copy of each 2034-byte loader allocation per row of the loaded scene.
 * begin_scene validates every raw 0xe4 row, runs the scene clear (0x475885 cleanup of the previous scene) and the scene reset of
 * the high score table (0x47591f, 0x4384a8); destroy runs the cleanup. Dependencies stay in the executor; only eligible rows
 * reach the handler. Phase 2 reports the generic completion (0x42ba3a) as COMPLETED, so the executor applies the subtype
 * behaviour; phases 0 and 1 are PENDING with the phase the visit ended in. */
SessionAe4Binding *session_ae4_create(const SessionAe4Host *host);
void session_ae4_destroy(SessionAe4Binding *binding);
int session_ae4_begin_scene(SessionAe4Binding *binding, const SceneResource *scene);
int session_ae4_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x475da4, fed with the view-relative cursor hot spot (x, y). `out` reports the candidate and the cursor cells the original
 * writes (0x5c39e5, 0x5b44f0, 0x5b44f4); the host publishes them. Nothing happens while the puzzle is inactive. */
int session_ae4_pointer_move(SessionAe4Binding *binding, int32_t x, int32_t y, E4rPointerResult *out);
/* 0x47608e, run on an accepted release with `candidate`, the value the pointer binding stored in 0x5c39e5. `row_phase` is the
 * executor's phase of the puzzle's row (session_ae4_state() row, E4R_O_ROW). `out->phase_changed` is set when the exit button was
 * taken; the host then stores phase 2 with scene_executor_accept_action_candidate(row). `out` is zeroed while inactive. */
int session_ae4_click(SessionAe4Binding *binding, uint32_t row_phase, int32_t candidate, E4rClickResult *out);
/* 0x4758e8. */
int session_ae4_invalidate(SessionAe4Binding *binding);
/* One render callback 0x4778df: the blits and texts the host performs, in order; out->valid is 0 when nothing is drawn. */
int session_ae4_render(SessionAe4Binding *binding, E4rRenderResult *out);
/* Nonzero while the puzzle owns a generic entry. */
unsigned session_ae4_registered(const SessionAe4Binding *binding);
const E4rObject *session_ae4_state(const SessionAe4Binding *binding);
const E4rWorld *session_ae4_world(const SessionAe4Binding *binding);
const char *session_ae4_failure(const SessionAe4Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
