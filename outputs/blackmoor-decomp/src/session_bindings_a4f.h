#ifndef BLACKMOOR_SESSION_BINDINGS_A4F_H
#define BLACKMOOR_SESSION_BINDINGS_A4F_H

#include "action_family_4f.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A4F_TYPE ACTION_FAMILY_4F_RAW_TYPE

typedef struct SessionA4FBinding SessionA4FBinding;

/* Raw 0x4f "compare a value, set an event flag" (RT-27; dispatcher arm 0x428133, gate mode 1).
 * The executor evaluates the dependency gate; this handler runs only for a true gate. A visit returns COMPLETED with
 * phase 0: the original calls 0x42ba3a(row) at the end of 0x44b641 on every path that does not abort, which
 * completes a subtype-1 row, resets the dependencies of a subtype-2 row and clears the phase word. The world is
 * borrowed (its value slots are read, event_flags[flag] is the only write). */
SessionA4FBinding *session_a4f_create(ActionCoreWorld *world);
void session_a4f_destroy(SessionA4FBinding *);
int session_a4f_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *,
                        SceneActionHandlerResult *);
const char *session_a4f_failure(const SessionA4FBinding *);
/* Visits that evaluated the test / that set a flag (diagnostics). */
unsigned long session_a4f_visits(const SessionA4FBinding *);
unsigned long session_a4f_flags_set(const SessionA4FBinding *);

#ifdef __cplusplus
}
#endif
#endif
