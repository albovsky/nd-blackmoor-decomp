#ifndef BLACKMOOR_SESSION_BINDINGS_A6E_H
#define BLACKMOOR_SESSION_BINDINGS_A6E_H

#include "action_family_6e.h"
#include "scene_executor.h"
#include "scene_stack.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A6E_TYPE ACTION_FAMILY_6E_RAW_TYPE
/* The argument 0x6e passes to 0x42e560 (dispatcher 0x429193: push 2). */
#define SESSION_A6E_PUSH_ARGUMENT 2

typedef struct SessionA6EBinding SessionA6EBinding;

typedef struct session_a6e_host {
    void *context;
    /* REQUIRED. Fills the running scene's words (see SceneStackCurrent). Nonzero: the host has no such state, and
     * the visit is UNSUPPORTED before any effect. */
    int (*load_current)(void *context, SceneStackCurrent *current);
} SessionA6EHost;

/* Raw 0x6e "save the running scene" (RT-28; dispatcher arm 0x42916f, gate mode 0). The executor evaluates the gate;
 * this handler runs for a true gate. The original calls 0x42e560(2), sets the row's completion byte to 1 directly
 * (0x4291aa) and leaves the phase word alone (neither 0x42ba3a nor a dependency reset runs, whatever the subtype),
 * so a visit returns DIRECT_COMPLETED with the phase it was given. The body byte is never read.
 * `slot` is borrowed and shared with the future 0x6f pop. */
SessionA6EBinding *session_a6e_create(const SessionA6EHost *host, SceneStackSlot *slot);
void session_a6e_destroy(SessionA6EBinding *);
int session_a6e_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *,
                        SceneActionHandlerResult *);
const char *session_a6e_failure(const SessionA6EBinding *);
/* Completed visits (diagnostics). */
unsigned long session_a6e_pushes(const SessionA6EBinding *);

#ifdef __cplusplus
}
#endif
#endif
