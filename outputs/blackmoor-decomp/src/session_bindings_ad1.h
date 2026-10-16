#ifndef BLACKMOOR_SESSION_BINDINGS_AD1_H
#define BLACKMOOR_SESSION_BINDINGS_AD1_H

#include "action_family_d1_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AD1_TYPE 0xd1

typedef struct SessionAd1Binding SessionAd1Binding;

typedef struct SessionAd1Host {
    D1Host kernel;
    /* Optional: receives the process global the finish wrote (0x5bb1ca) after a visit that wrote it. */
    void (*store_world)(void *context, const D1World *world);
} SessionAd1Host;

/* The binding owns the singleton object (0x61d449) and one copy of each 927-byte loader allocation (0x4b5c5c) per row
 * of the loaded scene. The scene clear (0x4b5bc8) runs on begin_scene and destroy. Dependencies stay in the executor;
 * only eligible rows reach the handler. Phase 2 reports the generic completion (0x42ba3a) as COMPLETED, so the
 * executor applies the subtype behaviour. */
SessionAd1Binding *session_ad1_create(const SessionAd1Host *host);
void session_ad1_destroy(SessionAd1Binding *binding);
int session_ad1_begin_scene(SessionAd1Binding *binding, const SceneResource *scene);
int session_ad1_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x4b5d17, fed with the view-relative cursor hot spot (x, y). `out` reports the cursor index and the candidate the
 * original writes (0x5b44f0, 0x5c39e5); the host publishes them. */
int session_ad1_pointer_move(SessionAd1Binding *binding, int16_t x, int16_t y, D1PointerResult *out);
/* 0x4b617a, run when an accepted release has retained `candidate`. `row_phase` is the executor's phase of the
 * object's row (session_ad1_object()->row). `*new_phase` is 2 when the click asked for the finish; the host then
 * stores phase 2 with scene_executor_accept_action_candidate(row). */
int session_ad1_click(SessionAd1Binding *binding, uint32_t row_phase, int32_t candidate, int32_t start_flag,
                      uint32_t *new_phase);
/* 0x4b5c11, the redraw request of the 0x43d7f0 sweep. */
int session_ad1_invalidate(SessionAd1Binding *binding);
/* The blits of one render callback 0x4b7051; plan->valid is 0 when there is no render entry. */
int session_ad1_render_plan(SessionAd1Binding *binding, D1RenderPlan *plan);
/* Nonzero while the object owns a render entry. */
unsigned session_ad1_registered(const SessionAd1Binding *binding);
const D1Object *session_ad1_object(const SessionAd1Binding *binding);
const char *session_ad1_failure(const SessionAd1Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
