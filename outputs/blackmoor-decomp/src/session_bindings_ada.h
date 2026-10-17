#ifndef BLACKMOOR_SESSION_BINDINGS_ADA_H
#define BLACKMOOR_SESSION_BINDINGS_ADA_H

#include "action_family_da_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_ADA_TYPE 0xda

typedef struct SessionAdaBinding SessionAdaBinding;

typedef struct SessionAdaHost {
    BulHost kernel;
    /* Optional: receives the process cell the handler wrote (start flag 0x5bb1ca) after a visit that wrote it (phase 0 and
     * phase 2). The click may also write nothing of the cell; it only reads it. */
    void (*store_world)(void *context, const BulWorld *world);
} SessionAdaHost;

/* RT-59. The binding owns the singleton object (CBulPuzzle, 0x624734), the process cell of the handler (BulWorld: the start
 * flag 0x5bb1ca, which survives scene changes like the original global) and one copy of each 2,958-byte loader allocation
 * (0x45b4ae) per row of the loaded scene. The scene clear (0x438bfd, 0x43ded9 -> 0x45b42e + 0x45b3ea) runs on begin_scene and
 * destroy; like the original it runs unconditionally on an idle object (no host call then). Dependencies stay in the
 * executor; only eligible rows reach the handler. Phase 2 reports the generic completion (0x42ba3a) as COMPLETED, so the
 * executor applies the subtype behaviour; phases 0 and 1 are PENDING with the phase the visit ended in. */
SessionAdaBinding *session_ada_create(const SessionAdaHost *host);
void session_ada_destroy(SessionAdaBinding *binding);
int session_ada_begin_scene(SessionAdaBinding *binding, const SceneResource *scene);
int session_ada_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x45b5bb (with 0x45b7a8), fed with the pointer position (x, y) as the cascade 0x4f0059 does. Nothing happens while the
 * puzzle is inactive. A button hit also stores the pending button kind in the object (obj+0x172). */
int session_ada_pointer_move(SessionAdaBinding *binding, int32_t x, int32_t y, BulPointerResult *out);
/* 0x45b872, run on an accepted release that retained `candidate` (0x5c39e5). `row_phase` is the executor's phase of the puzzle
 * row (session_ada_object()->row). out->new_phase is 2 when the click ended the game (the host then stores phase 2 with
 * scene_executor_accept_action_candidate(row)); it equals row_phase otherwise, also while the puzzle is inactive. out->handled
 * is 1 when the click was accepted. Returns BUL_OK, a kernel status, or BUL_ERR_ARGUMENT on a bad argument. */
int session_ada_click(SessionAdaBinding *binding, uint32_t row_phase, int32_t candidate, BulClickResult *out);
/* 0x45b477, the redraw request of the 0x43d9ba sweep. */
int session_ada_invalidate(SessionAdaBinding *binding);
/* The render callback 0x45d2c6 of the z entry. valid is 0 when the entry is not registered (the original never calls the
 * callback then). Besides the blits it changes the object like the original (erase rectangles, button animation flag). */
int session_ada_render(SessionAdaBinding *binding, BulRenderResult *out);
/* Nonzero while the object owns the z entry. */
unsigned session_ada_registered(const SessionAdaBinding *binding);
const BulObject *session_ada_object(const SessionAdaBinding *binding);
const BulWorld *session_ada_world(const SessionAdaBinding *binding);
const char *session_ada_failure(const SessionAdaBinding *binding);

#ifdef __cplusplus
}
#endif
#endif
