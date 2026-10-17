#ifndef BLACKMOOR_SESSION_BINDINGS_AF6_H
#define BLACKMOOR_SESSION_BINDINGS_AF6_H

#include "action_family_f6_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AF6_TYPE 0xf6

typedef struct SessionAf6Binding SessionAf6Binding;

typedef struct SessionAf6Host {
    F6Host kernel;
    /* Optional: receives the process global the finish wrote (0x5bb1ca) after a visit that wrote it. */
    void (*store_world)(void *context, const F6World *world);
} SessionAf6Host;

/* The binding owns the singleton object (0x61f4b1) and one copy of each 4,934-byte loader allocation (0x45ddd0) per row
 * of the loaded scene. The scene clear (0x45dd4d) runs on begin_scene and destroy. Dependencies stay in the executor;
 * only eligible rows reach the handler. Phase 2 reports the generic completion (0x42ba3a) as COMPLETED, so the
 * executor applies the subtype behaviour. */
SessionAf6Binding *session_af6_create(const SessionAf6Host *host);
void session_af6_destroy(SessionAf6Binding *binding);
int session_af6_begin_scene(SessionAf6Binding *binding, const SceneResource *scene);
int session_af6_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x45e1ca, fed with the view-relative cursor hot spot (x, y). `out` reports the cursor index and the candidate the
 * original writes (0x5b44f0, 0x5c39e5); the host publishes them. */
int session_af6_pointer_move(SessionAf6Binding *binding, int16_t x, int16_t y, F6PointerResult *out);
/* 0x45e587, run when an accepted release has retained `candidate`. `row_phase` is the executor's phase of the object's
 * row (session_af6_object()->row). `*new_phase` is 2 when the click asked for the finish; the host then stores phase 2
 * with scene_executor_accept_action_candidate(row). */
int session_af6_click(SessionAf6Binding *binding, uint32_t row_phase, int32_t candidate, uint32_t *new_phase);
/* 0x45dd96, the redraw request of the 0x43d7f0 sweep. */
int session_af6_invalidate(SessionAf6Binding *binding);
/* The blits of one render callback 0x460f26; plan->valid is 0 when there is no render entry. */
int session_af6_render_plan(SessionAf6Binding *binding, F6RenderPlan *plan);
/* Nonzero while the object owns a render entry. */
unsigned session_af6_registered(const SessionAf6Binding *binding);
const F6Object *session_af6_object(const SessionAf6Binding *binding);
const char *session_af6_failure(const SessionAf6Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
