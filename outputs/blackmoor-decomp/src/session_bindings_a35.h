#ifndef BLACKMOOR_SESSION_BINDINGS_A35_H
#define BLACKMOOR_SESSION_BINDINGS_A35_H

#include "action_family_35_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A35_TYPE 0x35
typedef struct SessionA35Binding SessionA35Binding;
typedef struct SessionA35Host {
    A35Host movie;
    /* Current frame selector + viewport origin must be supplied, never zero
     * filled for an unknown scene. World refresh/commit share process globals
     * with input/caption and the other action bindings. */
    int (*input)(void *, A35Input *);
    void (*load_world)(void *, A35World *);
    void (*store_world)(void *, const A35World *);
    int (*transition)(void *, const A35Result *);
} SessionA35Host;

SessionA35Binding *session_a35_create(A35World *, const SessionA35Host *);
void session_a35_destroy(SessionA35Binding *);
int session_a35_begin_scene(SessionA35Binding *, const SceneResource *);
int session_a35_handler(void *, size_t, const SceneActionInfo *,
                         const SceneActionRuntimeState *, SceneActionHandlerResult *);
/* AVF hosts schedule one sequential reader iteration between action visits,
 * then acknowledge only after the render callback consumed that generation.
 * Native app AVF providers remain unbound (the installed 0x35 corpus is Bink). */
int session_a35_worker_poll(SessionA35Binding *, size_t row);
int session_a35_render_ack(SessionA35Binding *, size_t row, uint32_t generation,
                           int *blitted);
const char *session_a35_failure(const SessionA35Binding *);

#ifdef __cplusplus
}
#endif
#endif
