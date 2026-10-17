#ifndef BLACKMOOR_SESSION_BINDINGS_A2D_H
#define BLACKMOOR_SESSION_BINDINGS_A2D_H

#include "action_family_2d_runtime.h"
#include "scene_executor.h"
#include "scene_resource.h"
#include "session_bindings_a2e.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A2D_TYPE 0x2d

typedef struct SessionA2dBinding SessionA2dBinding;

typedef struct SessionA2dHost {
    D2Host kernel;
    /* Called before every kernel call: fills the process globals the original reads or owns (D2World, all fields the
     * host owns; a host that maps only some leaves the rest at their world-init values: the host keeps the 0x5bb1ca start flag, 0x5839a9 and the other globals and the inputs scene_key, view origin,
     * thread_arg, back_buffer). */
    void (*load_world)(void *context, D2World *world);
    /* Called after every kernel call that ran: the globals the kernel wrote. */
    void (*store_world)(void *context, const D2World *world);
    /* Called before every kernel call: the stream sub-object fields the decode thread owns (period_24, decoder_172,
     * buffers_182, bink_id_18e, buffer_192, rect_1b2.., ready_1d4). */
    void (*load_stream)(void *context, D2Object *object);
    /* Called after: the host reads what the kernel wrote back (ready_1d4 cleared, buffer_192 := 0). */
    void (*store_stream)(void *context, const D2Object *object);
    /* Nonzero when the engine and media services the ops need exist (the AVF decode thread, the Bink player, the file
     * probes). A phase 0 visit with 0 or NULL is UNSUPPORTED before any effect. */
    int (*media_available)(void *context);
} SessionA2dHost;

/* The binding owns the singleton object (0x63821d), the world copy and the parsed body of the scene's raw 0x2d row (the
 * object is a singleton, so a scene with two rows is refused). Raw 0x2e (RT-33) shares the object's fields through the
 * attached 0x2e binding: the movie fields are copied across before and after every kernel call. */
SessionA2dBinding *session_a2d_create(const SessionA2dHost *host);
void session_a2d_destroy(SessionA2dBinding *);
/* The raw 0x2e binding whose SessionA2EMovie mirrors the object (may be NULL; call once, right after creating both). */
void session_a2d_attach_a2e(SessionA2dBinding *, SessionA2EBinding *a2e);
/* Parses the new scene's raw 0x2d row (at most one: the object is a singleton) and drops the previous scene's tables. The
 * object is destroyed and its render entry registered once, by the creation (the original does both at world init 0x4381f4,
 * not at a scene load). A scene load while the movie is active is refused with D2_ERR_UNSUPPORTED before any effect (what the
 * original does to a live movie's tables is not recovered); a failed parse leaves the new rows unowned. */
int session_a2d_begin_scene(SessionA2dBinding *, const SceneResource *scene);
int session_a2d_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* The random-movie stop 0x4ceb3b for raw 0x2e mode 0 (SessionA2EHost.stop_movie). `retire_row` receives the erased raw
 * 0x2d row (SESSION_A2E_NO_ROW when none); the caller completes it in the executor. */
int session_a2d_stop(SessionA2dBinding *, int32_t *retire_row);
/* The blit of one render callback 0x4cf749; plan->valid is 0 when nothing is shown. */
int session_a2d_render_plan(SessionA2dBinding *, D2RenderPlan *plan);
const D2Object *session_a2d_object(const SessionA2dBinding *);
const D2World *session_a2d_world(const SessionA2dBinding *);
const char *session_a2d_failure(const SessionA2dBinding *);

#ifdef __cplusplus
}
#endif
#endif
