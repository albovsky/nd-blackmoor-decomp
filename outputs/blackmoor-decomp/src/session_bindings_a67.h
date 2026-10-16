#ifndef BLACKMOOR_SESSION_BINDINGS_A67_H
#define BLACKMOOR_SESSION_BINDINGS_A67_H

#include <stdint.h>

#include "action_family_67.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A67_TYPE ACTION_FAMILY_67_RAW_TYPE
/* The value dispatcher arm 0x428692 stores in the process-wide start flag DAT_005bb1ca (0x4286b5). */
#define SESSION_A67_START_FLAG_VALUE 1

typedef struct SessionA67Binding SessionA67Binding;

typedef struct session_a67_host {
    void *context;
    /* REQUIRED. Receives the new value of DAT_005bb1ca, the start flag the other row handlers (0x0b, 0x0c, 0x17, 0x3f, 0x62)
     * also write and the frame step reads. Without it the visit is UNSUPPORTED before any effect. */
    void (*set_start_flag)(void *context, int32_t value);
} SessionA67Host;

/* Raw 0x67 (RT-30; dispatcher arm 0x428692, gate mode 0). The executor evaluates the gate; this handler runs for a true
 * gate. The original stores 1 in DAT_005bb1ca (0x4286b5) and then sets the row's completion byte to 1 directly (0x4286cc),
 * so a visit returns DIRECT_COMPLETED with the phase it was given: neither the generic completion 0x42ba3a nor a
 * dependency reset runs, whatever the subtype. The loader's one body byte is never read. */
SessionA67Binding *session_a67_create(const SessionA67Host *host);
void session_a67_destroy(SessionA67Binding *);
int session_a67_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *,
                        SceneActionHandlerResult *);
const char *session_a67_failure(const SessionA67Binding *);
/* The binding's own copy of DAT_005bb1ca as this handler last wrote it (0 until the first visit; diagnostics). */
int32_t session_a67_start_flag(const SessionA67Binding *);
/* Completed visits (diagnostics). */
unsigned long session_a67_visits(const SessionA67Binding *);

#ifdef __cplusplus
}
#endif
#endif
