#ifndef BLACKMOOR_SESSION_BINDINGS_A79_H
#define BLACKMOOR_SESSION_BINDINGS_A79_H

#include "action_family_79_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A79_TYPE ACTION79_RAW_TYPE

typedef struct SessionA79Binding SessionA79Binding;

/* The model arrays are borrowed from the owning world and must outlive the
 * binding. begin_scene reads each raw-0x79 row's two-byte object (A-79.1
 * decoder; the original builds it at scene load, 0x4e9add). */
typedef struct SessionA79Host {
    Action79Model model;
    Action79Host view;
} SessionA79Host;

SessionA79Binding *session_a79_create(const SessionA79Host *);
void session_a79_destroy(SessionA79Binding *);
/* Replaces the per-row objects; a malformed 0x79 row fails the whole scene. */
int session_a79_begin_scene(SessionA79Binding *, const SceneResource *);

/* Executor handler for runtime type 0x79. It is called only after the
 * executor's dependency gate (mode 0, 0x423f57) was true and the row was not
 * completed. The subtype is ignored (0x4eac4c never reads it). A successful
 * visit returns DIRECT_COMPLETED with the phase unchanged (the original never
 * touches the phase word) and applies the model changes in place. */
int session_a79_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a79_failure(const SessionA79Binding *);
/* Diagnostic: the row's item word, or -1 for a row this binding does not own. */
int32_t session_a79_item_word(const SessionA79Binding *, size_t);

#ifdef __cplusplus
}
#endif
#endif
