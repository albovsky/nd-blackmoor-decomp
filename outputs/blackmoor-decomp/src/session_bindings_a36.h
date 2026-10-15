#ifndef BLACKMOOR_SESSION_BINDINGS_A36_H
#define BLACKMOOR_SESSION_BINDINGS_A36_H

#include "action_family_36_runtime.h"
#include "scene_executor.h"
#include "session_input.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A36_TYPE OVERLAY36_RAW_TYPE
/* RT-18: raw 0x37 ("Static overlay") rows. The loader arm 0x40c446 builds the
 * image with the constructor 0x4895cc (A-37.2) and then stores the RUNTIME
 * type 0x36 (0x40c47b), so the same dispatcher arm, gate (mode 1) and
 * COverlay::Process serve them. The executor still sees the raw type, so the
 * session registers the same handler for 0x37. Raw 0x38 (arm 0x40c404,
 * constructor 0x48905b, also runtime 0x36) is NOT bound here. */
#define SESSION_A37_TYPE UINT8_C(0x37)

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

/* The loader-time image of one row: the A-36.1 constructor (0x488e9c) for raw
 * 0x36 (bytes it does not write start as zero, the original leaves them
 * uninitialised) or the A-37.2 constructor (0x4895cc over 0x48945b, which
 * zeroes the whole allocation first) for raw 0x37. Any other raw type, a
 * malformed body or a NULL argument returns an Overlay36Status other than
 * OVERLAY36_OK and leaves `image` unchanged. */
int session_a36_build_image(uint8_t raw_type, const uint8_t *raw_body, size_t raw_body_length,
                            uint8_t image[OVERLAY36_IMAGE_BYTES]);

/* Replaces the per-row overlay images (see session_a36_build_image for raw
 * 0x36 and raw 0x37 rows; raw 0x38 rows get none) and resets the overlay
 * manager (scene clear 0x488e54 / 0x4d3992). A malformed 0x36 or 0x37 row
 * fails the whole scene. Returns OVERLAY36_OK or an Overlay36Status. */
int session_a36_begin_scene(SessionA36Binding *, const SceneResource *);

/* Executor handler for rows whose runtime type is 0x36 (raw 0x36 and raw
 * 0x37; the action's raw type must be the one the row's image was built
 * from). Called only after the executor's
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
/* The raw type (0x36 or 0x37) the row's image was built from, 0 for none. */
uint8_t session_a36_row_raw_type(const SessionA36Binding *, size_t row);
const Overlay36Manager *session_a36_manager(const SessionA36Binding *);

#ifdef __cplusplus
}
#endif
#endif
