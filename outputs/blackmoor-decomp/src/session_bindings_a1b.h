#ifndef BLACKMOOR_SESSION_BINDINGS_A1B_H
#define BLACKMOOR_SESSION_BINDINGS_A1B_H

/* Session binding for raw action 0x1b (RT-40): a two-table scene-change hotspot. Loader 0x414692 (A-1B.1, action_family_1b.c),
 * dispatcher arm 0x427c87 of 0x427a50 (gate mode 1) calling the object method 0x414947; the kernel is action_family_1b_runtime.c.
 * The host is the RT-15 host shape (world cells, scene-change request, effect observer) with the held-item word 0x583a29 added:
 * the method reads the selector 0x5bb50b in phase 1 and the held item in phase 2. */

#include "action_family_1b_runtime.h"
#include "scene_executor.h"
#include "session_input.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A1B_TYPE ACTION1B_RAW_TYPE

typedef struct SessionA1bBinding SessionA1bBinding;

typedef struct SessionA1bHost {
    void *context;
    /* Fill the cells the method reads (selector 0x5bb50b, held item 0x583a29) and the start flag 0x5bb1ca. Called before
     * every kernel call; nonzero refuses (the visit is then UNSUPPORTED). */
    int (*load_world)(void *context, Action1bWorld *world);
    /* Commit the cells the kernel wrote (the start flag). Optional. */
    void (*store_world)(void *context, const Action1bWorld *world);
    /* The finish branch stores the 0x0a-shaped scene-change cells and mode 4; the native stand-in is a transition request.
     * NULL: a visit at phase 2 is UNSUPPORTED before any effect. */
    int (*transition)(void *context, const SceneTransitionRequest *request);
    /* Optional ordered effect observer (Action17Effect) with the owning row. The pre-gate request clear is reported too. */
    void (*observe)(void *context, size_t row, int effect, int32_t value);
} SessionA1bHost;

SessionA1bBinding *session_a1b_create(const SessionA1bHost *host);
void session_a1b_destroy(SessionA1bBinding *binding);

/* Replaces the per-row bodies and zeroes the row slots (scene load). A raw 0x1b row whose body the A-1B.1 decoder rejects fails
 * the whole scene (nonzero return, reason in session_a1b_failure); a failing begin KEEPS the previous scene's rows. */
int session_a1b_begin_scene(SessionA1bBinding *binding, const SceneResource *scene);

/* Executor handler for runtime type 0x1b. Called only after the executor's dependency gate (mode 1) was true and the row was not
 * completed. Phase 0/1: PENDING with the kernel's phase; phase 2: scene-change request, then DIRECT_COMPLETED with phase 2. */
int session_a1b_handler(void *context, size_t action_index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before, SceneActionHandlerResult *result);
/* 0x427a50 prologue (0x427ad4): the request dword is cleared before the type switch and the dependency gate. */
void session_a1b_pre_gate(void *context, size_t action_index, const SceneActionInfo *action,
                          const SceneActionRuntimeState *state);
const char *session_a1b_failure(const SessionA1bBinding *binding);

/* The row the generic scan of the pointer cascade (0x4f1f16) offers: 1 and a SessionInputHotspot when the row's request dword
 * is nonzero, else 0. */
int session_a1b_pointer_row(const SessionA1bBinding *binding, size_t index, SessionInputHotspot *row);
/* Hover cursor of a hit on the row (cascade case 0x4f22ad). */
int session_a1b_hover_cursor(const SessionA1bBinding *binding, size_t index, int16_t held_item, Action17Cursor *out);
/* Diagnostic copy of the row slot; nonzero for a row this binding does not own. */
int session_a1b_slot(const SessionA1bBinding *binding, size_t index, Action17Slot *out);
size_t session_a1b_row_count(const SessionA1bBinding *binding);

#ifdef __cplusplus
}
#endif
#endif
