#ifndef BLACKMOOR_SESSION_BINDINGS_AEE_H
#define BLACKMOOR_SESSION_BINDINGS_AEE_H

#include "action_family_ee_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AEE_TYPE 0xee

typedef struct SessionAeeBinding SessionAeeBinding;

typedef struct SessionAeeHost {
    MpHost kernel;
} SessionAeeHost;

/* RT-60. The binding owns the singleton object (0x61e398, with the cell array and the picture-id table of the visit) and one
 * copy of each 5,826-byte loader allocation (0x47b3f0) per raw 0xee row of the loaded scene. begin_scene validates every raw
 * 0xee row (mp_validate_body) and runs the scene clear (0x43df8d -> 0x47b321) of the previous scene; destroy runs it too. The
 * new-game reset (0x438bd0 -> 0x47b321) is the same clear: session_aee_cleanup. Dependencies stay in the executor; only
 * eligible rows reach the handler. Phase 2 reports the generic completion (0x42ba3a) as COMPLETED, so the executor applies the
 * subtype behaviour; phases 0 and 1 are PENDING with the phase the visit ended in. Every callback of `kernel` is required
 * (create returns NULL otherwise). */
SessionAeeBinding *session_aee_create(const SessionAeeHost *host);
void session_aee_destroy(SessionAeeBinding *binding);
int session_aee_begin_scene(SessionAeeBinding *binding, const SceneResource *scene);
int session_aee_handler(void *context, size_t row, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out);
/* 0x47b4aa at the pointer position (x, y), as the cascade 0x4f0059 passes it. `out` is zeroed with candidate -1 while the puzzle
 * is inactive (or won or lost). The cursor cells (`out->cursor`, `out->cursor_flag`) are published by the host. */
int session_aee_pointer_move(SessionAeeBinding *binding, int16_t x, int16_t y, MpPointerResult *out);
/* 0x47b767, run on every accepted release with the retained candidate (0x5c39e5). `row_phase` is the executor's phase of the
 * object's row. The click never changes the row phase (a won or lost game leaves through the handler). Nothing happens while
 * the puzzle is inactive. */
int session_aee_click(SessionAeeBinding *binding, uint32_t row_phase, int32_t candidate);
/* 0x47b3bc, the redraw request of the slot sweep. */
int session_aee_invalidate(SessionAeeBinding *binding);
/* 0x47b321: the scene clear (0x43df8d) and the new-game reset (0x438bd0) release the surface, cells and slot. */
int session_aee_cleanup(SessionAeeBinding *binding);
/* The blits of one render callback 0x47d24e (clears the redraw flag); plan->valid is 0 without a render entry. */
int session_aee_render_plan(SessionAeeBinding *binding, MpRenderPlan *plan);
/* Nonzero while the object owns a render entry. */
unsigned session_aee_registered(const SessionAeeBinding *binding);
const MpObject *session_aee_object(const SessionAeeBinding *binding);
const char *session_aee_failure(const SessionAeeBinding *binding);

#ifdef __cplusplus
}
#endif
#endif
