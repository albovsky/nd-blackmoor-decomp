#ifndef BLACKMOOR_SESSION_BINDINGS_A78_H
#define BLACKMOOR_SESSION_BINDINGS_A78_H

#include "action_family_78_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A78_TYPE ACTION78_RAW_TYPE

typedef struct SessionA78Binding SessionA78Binding;

/* The model arrays are borrowed from the owning world and must outlive the
 * binding (the same arrays RT-13's raw 0x79 binding uses). begin_scene reads
 * each raw-0x78 row's six-byte object (the original builds it at scene load,
 * 0x4e9c2f). */
typedef struct SessionA78Host {
    Action78Model model;
    Action78Host view;
} SessionA78Host;

SessionA78Binding *session_a78_create(const SessionA78Host *);
void session_a78_destroy(SessionA78Binding *);
/* Replaces the per-row objects; a malformed 0x78 row (fewer than six body bytes
 * or a fractional dependency record) fails the whole scene and keeps the
 * previous rows. */
int session_a78_begin_scene(SessionA78Binding *, const SceneResource *);

/* Executor handler for runtime type 0x78. It is called only after the
 * executor's dependency gate (mode 0, 0x423f57) was true and the row was not
 * completed. The subtype is ignored (0x4eaadc never reads it). A successful
 * visit returns DIRECT_COMPLETED with the phase unchanged (the original never
 * touches the phase word) and applies the model changes in place. */
int session_a78_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a78_failure(const SessionA78Binding *);
/* Diagnostic: copies the row's object; returns 1, or 0 for a row this binding
 * does not own. */
int session_a78_object(const SessionA78Binding *, size_t, Action78Object *);
/* Result of the most recent successful visit (all zero before the first). */
Action78Result session_a78_last_result(const SessionA78Binding *);

#ifdef __cplusplus
}
#endif
#endif
