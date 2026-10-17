#ifndef BLACKMOOR_SESSION_BINDINGS_A4E_H
#define BLACKMOOR_SESSION_BINDINGS_A4E_H

#include "action_family_4e_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A4E_TYPE ACTION_FAMILY_4E_RAW_TYPE

typedef struct SessionA4EBinding SessionA4EBinding;

/* Raw 0x4e "recompute a float value" (RT-44; dispatcher arm 0x4280f9, gate mode 1).
 * The executor evaluates the dependency gate; this handler runs only for a true gate. Every visit returns COMPLETED with phase 0:
 * the original calls 0x42ba3a(row) at the end of 0x44b3c8 on every path (an out-of-range target included, when the debug flag
 * is 0), which completes a subtype-1 row, resets the dependencies of a subtype-2 row and clears the phase word. The world is
 * borrowed: its 30 short and 10 float value slots are read, float_values[target - 30] is the only write. */
SessionA4EBinding *session_a4e_create(ActionCoreWorld *world);
void session_a4e_destroy(SessionA4EBinding *);
int session_a4e_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a4e_failure(const SessionA4EBinding *);
const ActionFamily4ERuntimeOutcome *session_a4e_last_outcome(const SessionA4EBinding *);
/* Visits that wrote a float slot / out-of-range selectors reported (diagnostics). */
unsigned long session_a4e_visits(const SessionA4EBinding *);
unsigned long session_a4e_reports(const SessionA4EBinding *);

#ifdef __cplusplus
}
#endif
#endif
