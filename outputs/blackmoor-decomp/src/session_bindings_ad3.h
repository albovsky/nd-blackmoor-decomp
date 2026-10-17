#ifndef BLACKMOOR_SESSION_BINDINGS_AD3_H
#define BLACKMOOR_SESSION_BINDINGS_AD3_H

#include "action_family_d3_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AD3_TYPE 0xd3

typedef struct SessionAd3Binding SessionAd3Binding;

typedef struct SessionAd3Host {
    CpzHost kernel;
    /* Optional: receives the process global the handler wrote (start flag 0x5bb1ca) after a visit that wrote it (phase 0 and
     * phase 2). The persistent grid (0x594db3..) is owned by the binding and read through session_ad3_world(). */
    void (*store_world)(void *context, const CpzWorld *world);
} SessionAd3Host;

/* RT-53. The binding owns the singleton object (CCollisionPuzzle, 0x61d779), the process cells of the handler (CpzWorld: the
 * start flag 0x5bb1ca and the persistent grid 0x594db3 / 0x594db5, which survives scene changes like the original globals and
 * is cleared only by session_ad3_grid_reset or by phase 0 of a row whose body byte 0x21 is 0) and one copy of each 855-byte
 * loader allocation (0x461903) per row of the loaded scene. The scene clear (0x438b5d, 0x43de52 -> 0x461862) runs on begin_scene
 * and destroy; like the original it runs unconditionally and is harmless on an idle object. Dependencies stay in the executor;
 * only eligible rows reach the handler. Phase 2 reports the generic completion (0x42ba3a) as COMPLETED, so the executor applies
 * the subtype behaviour; phases 0 and 1 are PENDING with the phase the visit ended in. */
SessionAd3Binding *session_ad3_create(const SessionAd3Host *host);
void session_ad3_destroy(SessionAd3Binding *binding);
int session_ad3_begin_scene(SessionAd3Binding *binding, const SceneResource *scene);
int session_ad3_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x462c39, fed with the view-relative cursor hot spot (x, y); the binding adds the view origin the host reports (0x583186 /
 * 0x58318a) exactly where the original does. `out` reports the candidate and the cursor cells the original writes (0x5c39e5,
 * 0x5b44f0, 0x5b44f4); the host publishes them. Nothing happens while the puzzle is inactive or a piece slides. The hit test
 * also changes the object (piece, position, direction), as the original does. */
int session_ad3_pointer_move(SessionAd3Binding *binding, int32_t x, int32_t y, CpzPointerResult *out);
/* 0x4631d1, run when an accepted release has retained `candidate` (0x5c39e5) with the process flag `start_flag` (0x5bb1ca).
 * `row_phase` is the executor's phase of the puzzle's row (session_ad3_object()->row). `out->new_phase` is 2 when the click
 * asked for the cancel; the host then stores phase 2 with scene_executor_accept_action_candidate(row). `out` is filled
 * (new_phase == row_phase) even while the puzzle is inactive. */
int session_ad3_click(SessionAd3Binding *binding, uint32_t row_phase, int32_t candidate, int32_t start_flag,
                      CpzClickResult *out);
/* 0x4618ab, the redraw request of the 0x43d910 sweep. */
int session_ad3_invalidate(SessionAd3Binding *binding);
/* 0x4618df, the new-game reset (0x438471): clears the one-time setup flag and the whole grid. */
void session_ad3_grid_reset(SessionAd3Binding *binding);
/* One render callback 0x463b10: the kernel's CpzRenderResult in drawing order. valid is 0 when there is no render entry. A piece
 * number outside 1..10 is refused with CPZ_ERR_BOUNDS (native refusal, the original indexes past its table). */
int session_ad3_render(SessionAd3Binding *binding, CpzRenderResult *out);
/* Nonzero while the object owns a render entry. */
unsigned session_ad3_registered(const SessionAd3Binding *binding);
const CpzObject *session_ad3_object(const SessionAd3Binding *binding);
const CpzWorld *session_ad3_world(const SessionAd3Binding *binding);
const char *session_ad3_failure(const SessionAd3Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
