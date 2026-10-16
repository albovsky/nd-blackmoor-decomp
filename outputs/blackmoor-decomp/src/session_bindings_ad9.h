#ifndef BLACKMOOR_SESSION_BINDINGS_AD9_H
#define BLACKMOOR_SESSION_BINDINGS_AD9_H

#include "action_family_d9_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AD9_TYPE 0xd9

typedef struct SessionAd9Binding SessionAd9Binding;

typedef struct SessionAd9Host {
    D9Host kernel;
    /* Optional: receives the process globals phase 0 wrote (0x5bb1ca). */
    void (*store_world)(void *context, const D9World *world);
} SessionAd9Host;

/* The binding owns the singleton object (0x6246dc) and one copy of each
 * 0x23-byte loader allocation (0x47d682) per row of the loaded scene. The
 * scene clear (0x47d59b) runs on begin_scene and destroy. Dependencies stay in
 * the executor; only eligible rows reach the handler. The row never completes
 * (there is no phase 2 in 0x47d788). */
SessionAd9Binding *session_ad9_create(const SessionAd9Host *host);
void session_ad9_destroy(SessionAd9Binding *binding);
int session_ad9_begin_scene(SessionAd9Binding *binding, const SceneResource *scene);
int session_ad9_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x47d734, fed with the view-relative cursor hot spot (x, y). */
int session_ad9_pointer_move(SessionAd9Binding *binding, int16_t x, int16_t y);
/* 0x47d640, the redraw request of the 0x43d7f0 sweep. */
int session_ad9_invalidate(SessionAd9Binding *binding);
/* Geometry of one render callback 0x47df57; plan->valid is 0 when nothing is
 * drawn. ERR_ARGUMENT without a loaded row. */
int session_ad9_render_plan(SessionAd9Binding *binding, D9RenderPlan *plan);
/* Nonzero while the object owns a render entry (phase 0 ran, no cleanup yet). */
unsigned session_ad9_registered(const SessionAd9Binding *binding);
const D9Object *session_ad9_object(const SessionAd9Binding *binding);
const char *session_ad9_failure(const SessionAd9Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
