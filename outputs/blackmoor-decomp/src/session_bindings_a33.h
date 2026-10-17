#ifndef BLACKMOOR_SESSION_BINDINGS_A33_H
#define BLACKMOOR_SESSION_BINDINGS_A33_H

#include "action_family_33_runtime.h"
#include "scene_executor.h"
#include "scene_resource.h"
#include "session_input.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A33_TYPE A33_RUNTIME_TYPE

typedef struct SessionA33Binding SessionA33Binding;

/* Raw 0x33 "secondary video with hotspots" (RT-46; dispatcher arm of 0x427a50, gate mode 1, handler 0x42c221). The executor
 * evaluates the dependency gate; this handler runs for a true gate. Phase 0 and 1 return PENDING with the kernel's phase;
 * phase 2 with a flagged frame stores the scene-change cells, asks the host for the scene change and returns COMPLETED with
 * phase 0 (the original ends in 0x42ba3a(row)); phase 2 without a flagged frame stays PENDING. */
typedef struct SessionA33Host {
    A33Host kernel;
    /* Called before every kernel call: fills the process globals the host owns (selector 0x5bb50b, view origin, clip rectangle
     * 0x5bb583.., video rectangle 0x5b4de8.., word 0x5b016f, candidate 0x5c39e5, scene dword 0x5bb57b, start flag 0x5bb1ca)
     * and the reader-thread fields (ready word 0x5b4e0a, delay 0x5b4c5a, buffers 0x5b4db8 / 0x5b4dbc and their flag words).
     * Fields left alone keep the binding's copy. */
    void (*load_world)(void *context, A33State *state);
    /* Called after every kernel call that ran: the globals the kernel wrote. */
    void (*store_world)(void *context, const A33State *state);
    /* The scene-change request of the finish branch (the original stores the cells and sets the engine mode 4). Nonzero
     * refuses: the visit is then an error and the row stays open. */
    int (*transition)(void *context, const SceneTransitionRequest *request);
    /* Nonzero when the engine and media services the ops need exist (reader thread, surfaces, stream). A phase 0 visit with 0
     * or NULL is UNSUPPORTED before any effect. */
    int (*media_available)(void *context);
} SessionA33Host;

SessionA33Binding *session_a33_create(const SessionA33Host *host);
void session_a33_destroy(SessionA33Binding *binding);

/* Runs the 0x33 part of the scene clear (a33_scene_clear: latch 0x5c39f1, row/kind words, surfaces; the reader thread stays
 * for the next phase 0), then parses the new scene's raw 0x33 rows and drops the previous scene's tables. A body the parser
 * rejects fails the whole scene (nonzero return, reason in session_a33_failure) and leaves no 0x33 row owned. */
int session_a33_begin_scene(SessionA33Binding *binding, const SceneResource *scene);

int session_a33_handler(void *context, size_t row, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out);
/* 0x427a50 prologue (0x427ad4): the request dword of a registered row is cleared before the type switch and the gate. */
void session_a33_pre_gate(void *context, size_t row, const SceneActionInfo *action, const SceneActionRuntimeState *state);

/* The row the generic scan of the pointer cascade (0x4f1f16) offers: 1 and a SessionInputHotspot when the row's request dword
 * is nonzero, else 0. */
int session_a33_pointer_row(const SessionA33Binding *binding, size_t row, SessionInputHotspot *out);

const A33State *session_a33_state(const SessionA33Binding *binding);
const A33Row *session_a33_row(const SessionA33Binding *binding, size_t row);
size_t session_a33_row_count(const SessionA33Binding *binding);
const char *session_a33_failure(const SessionA33Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
