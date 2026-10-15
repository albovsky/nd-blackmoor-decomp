#ifndef BLACKMOOR_SESSION_BINDINGS_A83_H
#define BLACKMOOR_SESSION_BINDINGS_A83_H

#include "action_family_83_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A83_TYPE 0x83
typedef struct SessionA83Binding SessionA83Binding;
typedef struct SessionA83Host {
    A83World *world;
    A83Backend backend;
} SessionA83Host;

/* Borrowed host world survives scene replacement. This binding owns a copy
 * of each 74-byte loader allocation, released on replace/destroy. That is
 * native ownership; original allocation disposal remains unverified.
 * Dependencies stay in the executor; only eligible rows reach the handler. */
SessionA83Binding *session_a83_create(const SessionA83Host *);
void session_a83_destroy(SessionA83Binding *);
int session_a83_begin_scene(SessionA83Binding *, const SceneResource *);
int session_a83_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a83_failure(const SessionA83Binding *);
/* Most recent successful visit (selection, insertion and list kind), for
 * host logging only. NULL before the first success. */
const A83Result *session_a83_last_result(const SessionA83Binding *);

#ifdef __cplusplus
}
#endif
#endif
