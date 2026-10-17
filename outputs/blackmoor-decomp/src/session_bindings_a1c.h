#ifndef BLACKMOOR_SESSION_BINDINGS_A1C_H
#define BLACKMOOR_SESSION_BINDINGS_A1C_H

/* Session binding for raw action 0x1c, the interactive video (RT-57): dispatcher arm 0x427cc3 (gate mode 1) -> 0x4cb586 on the
 * singleton 0x63847b. The kernel is action_family_1c_runtime.c (the handler with the ".IV" loader, and the z entry render
 * callback); the movie player, the file and the z entry are the host's (C1cHost). The executor evaluates the gate; the handler
 * runs only for a true gate. */

#include "action_family_1c_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A1C_TYPE ACTION_FAMILY_1C_RAW_TYPE

typedef struct SessionA1cBinding SessionA1cBinding;

/* The host is the kernel's (every callback REQUIRED; a missing one makes the visit UNSUPPORTED before any effect). The binding
 * owns the singleton object; it keeps a copy of the row's body for the object's body pointer. */
SessionA1cBinding *session_a1c_create(const C1cHost *host);
void session_a1c_destroy(SessionA1cBinding *binding);
/* Phase 0 and 1 PENDING with the phase from the kernel; phase 2 COMPLETED (the generic completion 0x42ba3a). */
int session_a1c_handler(void *context, size_t action_index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before, SceneActionHandlerResult *result);
/* The z entry render callback 0x4cc79a (see c1c_render). */
int session_a1c_render(SessionA1cBinding *binding, int32_t view_x, int32_t view_y, C1cFill *fills, size_t capacity,
                       size_t *count);
const C1cObject *session_a1c_object(const SessionA1cBinding *binding);
const char *session_a1c_failure(const SessionA1cBinding *binding);
unsigned long session_a1c_visits(const SessionA1cBinding *binding);

#ifdef __cplusplus
}
#endif
#endif
