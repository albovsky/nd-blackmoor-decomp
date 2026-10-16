#ifndef BLACKMOOR_SESSION_BINDINGS_A95_H
#define BLACKMOOR_SESSION_BINDINGS_A95_H

#include "action_family_95.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A95_TYPE ACTION_FAMILY_95_RAW_TYPE

typedef struct SessionA95Binding SessionA95Binding;

/* Raw 0x95 "Set Volume" (RT-26; dispatcher arm 0x429e41, gate mode 0).
 * The executor evaluates the dependency gate; this handler runs only for a
 * true gate. A successful visit returns COMPLETED with phase 0: the original
 * calls 0x42ba3a(row) right after 0x4fca60, which completes a subtype-1 row,
 * resets the dependencies of a subtype-2 row and clears the phase word for
 * every subtype. The executor's COMPLETED disposition is exactly that helper
 * (a subtype other than 1 or 2 leaves the completion byte and clears the phase,
 * so the row is revisited on the next tick like the original). */
SessionA95Binding *session_a95_create(const ActionFamily95Host *host);
void session_a95_destroy(SessionA95Binding *);
int session_a95_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a95_failure(const SessionA95Binding *);
/* Count of visits that reached the host (diagnostic). */
unsigned long session_a95_visits(const SessionA95Binding *);

#ifdef __cplusplus
}
#endif
#endif
