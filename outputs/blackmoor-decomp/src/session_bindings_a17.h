#ifndef BLACKMOOR_SESSION_BINDINGS_A17_H
#define BLACKMOOR_SESSION_BINDINGS_A17_H

#include "action_family_17_runtime.h"
#include "scene_executor.h"
#include "session_input.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime types served by this binding. The shared parser types raw 0x16 and
 * 0x17 (0x18/0x19 occur nowhere in the corpus and have no typed decoder);
 * the kernel itself serves all four (same handler 0x42b07e). */
#define SESSION_A17_TYPE ACTION17_RAW_TYPE
#define SESSION_A16_TYPE ACTION16_RAW_TYPE

typedef struct SessionA17Binding SessionA17Binding;

typedef struct SessionA17Host {
    void *context;
    /* Fill the process globals the handler reads: selector 0x5bb50b and
     * start flag 0x5bb1ca. Called before every kernel call; nonzero refuses
     * (the visit then blocks the session). */
    int (*load_world)(void *context, Action17World *world);
    /* Commit the globals the kernel wrote (the start flag). Optional. */
    void (*store_world)(void *context, const Action17World *world);
    /* The finish branch stores the 0x0a-shaped scene-change cells and mode 4;
     * the native stand-in is a transition request that ends the dispatcher
     * pass. NULL: a visit at phase 2 is UNSUPPORTED before any effect. */
    int (*transition)(void *context, const SceneTransitionRequest *request);
    /* Optional ordered effect observer (Action17Effect) with the owning row.
     * The prologue request clear of the pre-gate is reported too. */
    void (*observe)(void *context, size_t row, int effect, int32_t value);
} SessionA17Host;

SessionA17Binding *session_a17_create(const SessionA17Host *);
void session_a17_destroy(SessionA17Binding *);

/* Replaces the per-row bodies and zeroes the row slots (scene load). A row of
 * the family whose typed body is not a complete object fails the whole scene
 * (nonzero return). */
int session_a17_begin_scene(SessionA17Binding *, const SceneResource *);

/* Executor handler for runtime types 0x16/0x17. Called only after the
 * executor's dependency gate (mode 0 for 0x17, mode 1 for 0x16) was true and
 * the row was not completed. Phase 0/1: PENDING with the kernel's phase; phase
 * 2: scene-change request, then DIRECT_COMPLETED with phase 2. */
int session_a17_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
/* 0x427a50 prologue: the request dword is cleared before the type switch and
 * the dependency gate (SceneActionPreGateFn). Register for both types. */
void session_a17_pre_gate(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *);
const char *session_a17_failure(const SessionA17Binding *);

/* The row the generic scan of the pointer cascade (0x4f1f16) offers: 1 and a
 * SessionInputHotspot when the row's request dword is nonzero, else 0. */
int session_a17_pointer_row(const SessionA17Binding *, size_t index, SessionInputHotspot *row);
/* Hover cursor of a hit on the row (0x4f1ff3 / 0x4f22ef). */
int session_a17_hover_cursor(const SessionA17Binding *, size_t index, int16_t held_item,
                             Action17Cursor *out);
/* Diagnostic copy of the row slot; nonzero for a row this binding does not own. */
int session_a17_slot(const SessionA17Binding *, size_t index, Action17Slot *out);
size_t session_a17_row_count(const SessionA17Binding *);

#ifdef __cplusplus
}
#endif
#endif
