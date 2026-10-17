#ifndef BLACKMOOR_SESSION_BINDINGS_A76_H
#define BLACKMOOR_SESSION_BINDINGS_A76_H

#include "action_family_76_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A76_TYPE 0x76

typedef struct SessionA76Binding SessionA76Binding;

typedef struct SessionA76Host {
    PwdHost kernel;
    /* Optional: receives the process global the handler wrote (start flag 0x5bb1ca) after a visit that wrote it (phase 0 and
     * phase 2); the value is the one the visit ended with. */
    void (*store_world)(void *context, int32_t start_flag_5bb1ca);
} SessionA76Host;

/* RT-58. The binding owns the puzzle's process cells (the 0x86-byte state image 0x5b616b..0x5b61f0 and the static render entry
 * flag 0x5d1c01) and one copy of each 575-byte loader allocation per raw 0x76 row of the loaded scene. The render entry is the
 * static generic z entry 22 of the original, so the binding allocates no slot: the entry is drawn while its flag is set.
 * begin_scene validates every raw 0x76 row (pwd_validate_body) and runs the scene clear 0x43dbe3 (active := 0, entry flag := 0;
 * the font reference is not released, as in the original); destroy runs the same clear. Dependencies stay in the executor; only
 * eligible rows reach the handler. Phase 2 reports the generic completion (0x42ba3a) as COMPLETED, so the executor applies the
 * subtype behaviour; phases 0 and 1 are PENDING with the phase the visit ended in. Every host callback except `store_world` and
 * `kernel.observe` is required (create returns NULL otherwise). */
SessionA76Binding *session_a76_create(const SessionA76Host *host);
void session_a76_destroy(SessionA76Binding *binding);
int session_a76_begin_scene(SessionA76Binding *binding, const SceneResource *scene);
int session_a76_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x437dcd (the part that belongs to this puzzle): the typed character (a byte, as the character message handler passes it).
 * Returns 1 when the character was stored, 0 when refused or the puzzle is not active, PWD_ERR_ARGUMENT on a bad argument. */
int session_a76_key(SessionA76Binding *binding, int8_t ch);
/* 0x4f04b6..0x4f05a3 at the pointer position (x, y), not view relative, as the cascade 0x4f0059 passes it. `out` is zeroed with
 * candidate and cursor_kind -1 while the puzzle is inactive. The cursor cells are published by the host from `out`. */
int session_a76_pointer_move(SessionA76Binding *binding, int32_t x, int32_t y, PwdPointerResult *out);
/* 0x43a7ca, run on an accepted release that retained `candidate` (0x5c39e5). `out->fired` is set when the cancel strip was taken;
 * the host then stores phase 2 for `out->row` with scene_executor_accept_action_candidate(row). The click does not look at the
 * row phase. `out` is zeroed otherwise. */
int session_a76_click(SessionA76Binding *binding, int32_t candidate, PwdClickResult *out);
/* 0x43d7f0: while active the static entry flag 0x5d1c01 := 1. Returns 1 when it was stored, 0 otherwise. */
int session_a76_invalidate(SessionA76Binding *binding);
/* 0x43dbe3: active := 0 and the entry flag := 0 (also done by begin_scene and destroy). */
void session_a76_cleanup(SessionA76Binding *binding);
/* 0x435015: active := 0. */
void session_a76_new_game(SessionA76Binding *binding);
/* The render callback 0x4d07e7 of the static entry: out->count is 0 when the entry is not drawn (the original never calls the
 * callback then). PWD_ERR_ARGUMENT when the entry is set but the row is not one of this binding's. */
int session_a76_render(SessionA76Binding *binding, PwdRenderResult *out);
/* Nonzero while the static entry flag 0x5d1c01 is set. */
unsigned session_a76_registered(const SessionA76Binding *binding);
const PwdState *session_a76_state(const SessionA76Binding *binding);
/* The process cell 0x5bb1ca as the puzzle last wrote it. */
int32_t session_a76_start_flag(const SessionA76Binding *binding);
const char *session_a76_failure(const SessionA76Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
