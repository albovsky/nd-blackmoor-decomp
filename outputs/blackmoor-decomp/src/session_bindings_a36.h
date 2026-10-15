#ifndef BLACKMOOR_SESSION_BINDINGS_A36_H
#define BLACKMOOR_SESSION_BINDINGS_A36_H

#include "action_family_36_runtime.h"
#include "scene_executor.h"
#include "session_input.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A36_TYPE OVERLAY36_RAW_TYPE

typedef struct SessionA36Binding SessionA36Binding;

/* Host providers. kernel.context is handed to every kernel provider and to
 * load_world/store_world/transition. */
typedef struct SessionA36Host {
    Overlay36Host kernel;
    /* Fill the process globals the family reads (event array pointer/count,
     * selector 0x5bb50b, held item, view origin, ...). Called before every
     * kernel call; return nonzero to refuse (the visit then fails). */
    int (*load_world)(void *context, Overlay36World *world);
    /* Commit the globals the kernel wrote. Called after a successful call. */
    void (*store_world)(void *context, const Overlay36World *world);
    /* The overlay's finish branch with option +0x25 == 1 stores the
     * scene-change words (0x5bb57b.., mode 0x583999 := 4) exactly like the
     * dispatcher's 0x0a arm; the native stand-in is a transition request that
     * ends the dispatcher pass. May be NULL when no row uses the branch;
     * such a row is then UNSUPPORTED before any effect. */
    int (*transition)(void *context, const SceneTransitionRequest *request);
} SessionA36Host;

SessionA36Binding *session_a36_create(const SessionA36Host *);
void session_a36_destroy(SessionA36Binding *);

/* Replaces the per-row overlay images (the A-36.1 constructor builds the
 * 0xABA-byte image from each raw 0x36 row; bytes the constructor does not
 * write start as zero, the original leaves them uninitialised) and resets the
 * overlay manager (scene clear 0x488e54 / 0x4d3992). A malformed 0x36 row
 * fails the whole scene. Returns OVERLAY36_OK or an Overlay36Status. */
int session_a36_begin_scene(SessionA36Binding *, const SceneResource *);

/* Executor handler for runtime type 0x36. Called only after the executor's
 * mode-1 dependency gate (0x423f57) was true and the row was not completed.
 * Phase 0 registers and continues into phase 1 in the same call (PENDING,
 * phase 1 or 2); a visit at phase 2 returns COMPLETED with phase 0 (the
 * original's 0x42ba3a); other phases are visited with no effect. */
int session_a36_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a36_failure(const SessionA36Binding *);

/* Hot rectangles (viewport relative, inclusive) the pointer cascade tests
 * BEFORE its generic row scan (0x4f104f -> 0x4897cd), in overlay-list order.
 * Rows come back as SessionInputHotspot with index = owning action row. */
int session_a36_priority_rows(SessionA36Binding *, SessionInputHotspot *rows,
                              size_t capacity, size_t *count);

/* Direct hit test (0x4897cd) with logical pointer coordinates; performs the
 * kernel's cursor/candidate stores into the world. */
int session_a36_hit_test(SessionA36Binding *, int16_t x, int16_t y, int *hit, int32_t *row);

/* The overlay part of the render pass 0x4cf9f4: layers lo..hi inclusive. */
int session_a36_render(SessionA36Binding *, int32_t layer_lo, int32_t layer_hi, size_t *drawn);

/* Diagnostics. */
size_t session_a36_registered(const SessionA36Binding *);
const char *session_a36_row_name(const SessionA36Binding *, size_t row);
const uint8_t *session_a36_image(const SessionA36Binding *, size_t row);
const Overlay36Manager *session_a36_manager(const SessionA36Binding *);

#ifdef __cplusplus
}
#endif
#endif
