#ifndef BLACKMOOR_SESSION_BINDINGS_AD0_H
#define BLACKMOOR_SESSION_BINDINGS_AD0_H

#include "action_family_d0_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AD0_TYPE 0xd0

typedef struct SessionAd0Binding SessionAd0Binding;

typedef struct SessionAd0Host {
    D0Host kernel;
    /* Optional: receives the process global the handler wrote (0x5bb1ca) after a visit that wrote it. */
    void (*store_world)(void *context, const D0World *world);
} SessionAd0Host;

/* RT-50. The binding owns the singleton object (CPianoPuzzle, 0x61d345), the process global of phases 0 and 2 (D0World)
 * and one MUTABLE copy of each 1979-byte loader allocation (0x48d12d) per row of the loaded scene: the key press block
 * writes the key's sound name into the row body at +0x715, so the copy is the live body the sound calls receive. The scene
 * clear (0x438b5d, 0x43de52 -> 0x48d09c) runs on begin_scene and destroy; like the original it runs unconditionally and is
 * harmless on an idle object. Dependencies stay in the executor; only eligible rows reach the handler. Phase 2 reports the
 * generic completion (0x42ba3a) as COMPLETED, so the executor applies the subtype behaviour; phases 0 and 1 are PENDING
 * with the phase the visit ended in. */
SessionAd0Binding *session_ad0_create(const SessionAd0Host *host);
void session_ad0_destroy(SessionAd0Binding *binding);
int session_ad0_begin_scene(SessionAd0Binding *binding, const SceneResource *scene);
int session_ad0_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x48d1e8, fed with the view-relative cursor hot spot (x, y). `out` reports the candidate and the cursor cells the original
 * writes (0x5c39e5, 0x5b44f0, 0x5b44f4); the host publishes them. Nothing happens while the puzzle is inactive. */
int session_ad0_pointer_move(SessionAd0Binding *binding, int32_t x, int32_t y, D0PointerResult *out);
/* 0x48d5f4, run when an accepted release has retained `candidate`. `row_phase` is the executor's phase of the puzzle's row
 * (session_ad0_object()->row). `out->new_phase` is 2 when the click asked for the exit; the host then stores phase 2 with
 * scene_executor_accept_action_candidate(row). `out` is filled (new_phase == row_phase) even while the puzzle is inactive. */
int session_ad0_click(SessionAd0Binding *binding, uint32_t row_phase, int32_t candidate, int32_t start_flag,
                      D0ClickResult *out);
/* 0x48d0e5, the redraw request of the 0x43d910 sweep. */
int session_ad0_invalidate(SessionAd0Binding *binding);
/* One render callback 0x48ded7: the kernel's D0RenderResult (blit 1 pressed key, blit 2 background restore). valid is 0 when
 * there is no render entry. */
int session_ad0_render(SessionAd0Binding *binding, D0RenderResult *out);
/* Nonzero while the object owns a render entry. */
unsigned session_ad0_registered(const SessionAd0Binding *binding);
const D0Object *session_ad0_object(const SessionAd0Binding *binding);
const char *session_ad0_failure(const SessionAd0Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
