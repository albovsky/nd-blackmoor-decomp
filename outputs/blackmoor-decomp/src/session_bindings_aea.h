#ifndef BLACKMOOR_SESSION_BINDINGS_AEA_H
#define BLACKMOOR_SESSION_BINDINGS_AEA_H

#include "action_family_ea_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AEA_TYPE 0xea

typedef struct SessionAeaBinding SessionAeaBinding;

typedef struct SessionAeaHost {
    EaHost kernel;
    /* Optional: receives the process global the finish wrote (0x5bb1ca) after a visit that wrote it. */
    void (*store_world)(void *context, const EaWorld *world);
} SessionAeaHost;

/* The binding owns the singleton object (0x6252ad) and one copy of each 3,847-byte loader allocation (0x484110) per
 * row of the loaded scene (the copy is written by 0x484f42, as the original writes its allocation). Dependencies stay
 * in the executor; only eligible rows reach the handler. The scene clear (0x483fb5) runs on begin_scene and destroy.
 * Phase 2 reports the generic completion (0x42ba3a) as COMPLETED, so the executor applies the subtype behaviour. */
SessionAeaBinding *session_aea_create(const SessionAeaHost *host);
void session_aea_destroy(SessionAeaBinding *binding);
int session_aea_begin_scene(SessionAeaBinding *binding, const SceneResource *scene);
int session_aea_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x484f42, fed with the view-relative cursor hot spot (x, y) and the hot rectangle (left, top, right, bottom). `out`
 * reports the candidate and cursor the original writes; the host publishes them. */
int session_aea_pointer_move(SessionAeaBinding *binding, int16_t x, int16_t y, const int32_t rect[4],
                             EaPointerResult *out);
/* 0x48569e, run when an accepted release has retained `candidate`. `row_phase` is the executor's phase of the object's
 * row (session_aea_object row). `*new_phase` is 2 when the click asked for the finish; the host then stores phase 2
 * with scene_executor_accept_action_candidate(row). */
int session_aea_click(SessionAeaBinding *binding, uint32_t row_phase, int32_t candidate, uint32_t *new_phase);
/* 0x484ac0, the second-button event outside the screen states 2..5. */
int session_aea_rotate_key(SessionAeaBinding *binding, uint32_t row_phase);
/* 0x4840d9, the redraw request of the 0x43d7f0 sweep. */
int session_aea_invalidate(SessionAeaBinding *binding);
/* The blits of one render callback 0x4876ed (consumes the object's draw flags); plan->valid is 0 without a render
 * entry. */
int session_aea_render_plan(SessionAeaBinding *binding, EaRenderPlan *plan);
/* Nonzero while the object owns a render entry. */
unsigned session_aea_registered(const SessionAeaBinding *binding);
const EaObject *session_aea_object(const SessionAeaBinding *binding);
const char *session_aea_failure(const SessionAeaBinding *binding);

#ifdef __cplusplus
}
#endif
#endif
