#ifndef BLACKMOOR_SESSION_BINDINGS_AEB_H
#define BLACKMOOR_SESSION_BINDINGS_AEB_H

#include "action_family_eb_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AEB_TYPE 0xeb

typedef struct SessionAebBinding SessionAebBinding;

typedef struct SessionAebHost {
    EbHost kernel;
    /* Optional: the process dword 0x5bb57b as the app holds it (the running scene). Read before every visit, because the
     * saved-state compare of the piece builder and the finish block's store go through it. Without it the binding keeps its
     * own copy, which only the finish block writes. */
    int32_t (*scene_cell)(void *context);
    /* Optional: receives the process cells the visit wrote (the start flag 0x5bb1ca and the saved puzzle state) after a visit
     * that initialised or completed the puzzle. */
    void (*store_world)(void *context, const EbWorld *world);
} SessionAebHost;

/* RT-56. The binding owns the singleton object (0x625ee8), the process cells of the puzzle (EbWorld: the start flag, the
 * running scene and the saved puzzle state 0x5a055d..0x5a1109, which survives every row and scene change) and one copy of each
 * 2,612-byte loader allocation (0x47e477) per row of the loaded scene. begin_scene validates every raw 0xeb row and runs the
 * scene clear (0x47e2a5) of the previous scene; destroy runs it too. The saved puzzle state is reset only by
 * session_aeb_world_reset (the new-game reset 0x4384f8 -> 0x47e3f7). Dependencies stay in the executor; only eligible rows
 * reach the handler. Phase 2 reports the generic completion (0x42ba3a) as COMPLETED, so the executor applies the subtype
 * behaviour. */
SessionAebBinding *session_aeb_create(const SessionAebHost *host);
void session_aeb_destroy(SessionAebBinding *binding);
int session_aeb_begin_scene(SessionAebBinding *binding, const SceneResource *scene);
int session_aeb_handler(void *context, size_t row, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out);
/* The new-game reset of the saved puzzle state (0x47e3f7). */
void session_aeb_world_reset(SessionAebBinding *binding);
/* 0x47f421, fed with the view-relative cursor hot spot (x, y) and the hot rectangle (left, top, right, bottom). `out` reports the
 * candidate and cursor the original writes; the host publishes them. Nothing happens while the puzzle is inactive. */
int session_aeb_pointer_move(SessionAebBinding *binding, int16_t x, int16_t y, const int32_t rect[4], EbPointerResult *out);
/* 0x47ff0e, run on an accepted release with the retained `candidate`. `row_phase` is the executor's phase of the object's row.
 * `*new_phase` is 2 when an exit button was released; the host then stores phase 2 with
 * scene_executor_accept_action_candidate(row). */
int session_aeb_click(SessionAebBinding *binding, uint32_t row_phase, int32_t candidate, uint32_t *new_phase);
/* 0x47ef0f, the second-button event outside the screen states 2..5. */
int session_aeb_rotate_key(SessionAebBinding *binding, uint32_t row_phase);
/* 0x47e440, the redraw request of the slot sweep. */
int session_aeb_invalidate(SessionAebBinding *binding);
/* The blits of one render callback 0x481cb9 (consumes the object's draw flags); plan->valid is 0 without a render entry. */
int session_aeb_render_plan(SessionAebBinding *binding, EbRenderPlan *plan);
/* Nonzero while the object owns a render entry. */
unsigned session_aeb_registered(const SessionAebBinding *binding);
const EbObject *session_aeb_object(const SessionAebBinding *binding);
const EbWorld *session_aeb_world(const SessionAebBinding *binding);
const char *session_aeb_failure(const SessionAebBinding *binding);

#ifdef __cplusplus
}
#endif
#endif
