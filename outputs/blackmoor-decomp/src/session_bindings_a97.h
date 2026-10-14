#ifndef BLACKMOOR_SESSION_BINDINGS_A97_H
#define BLACKMOOR_SESSION_BINDINGS_A97_H

#include "action_family_97_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A97_TYPE ACTION_FAMILY_97_RAW_TYPE
typedef struct SessionA97Binding SessionA97Binding;
typedef struct SessionA97Host {
    ActionSoundBackend sound;
    ActionFamily97AutoTextLookup lookup;
    void *lookup_context;
    /* Original CRT holdrand, shared with dependency opcode 20. NULL means
     * unknown, never seed zero. The loader consumes once per unmarked row,
     * in ACT order, even when its dependencies are false. */
    uint32_t *random_state;
    int (*captions_enabled)(void *, uint8_t *);
    int (*transition)(void *, const ActionSoundTransition *);
} SessionA97Host;

SessionA97Binding *session_a97_create(const SessionA97Host *);
void session_a97_destroy(SessionA97Binding *);
int session_a97_begin_scene(SessionA97Binding *, const SceneResource *);
int session_a97_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a97_failure(const SessionA97Binding *);
/* Diagnostics: -1 for a deferred/unowned row. */
int session_a97_selected(const SessionA97Binding *, size_t);

#ifdef __cplusplus
}
#endif
#endif
