#ifndef BLACKMOOR_SESSION_BINDINGS_A6F_H
#define BLACKMOOR_SESSION_BINDINGS_A6F_H

#include "action_family_6f.h"
#include "scene_executor.h"
#include "scene_stack.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A6F_TYPE ACTION_FAMILY_6F_RAW_TYPE

typedef struct SessionA6FBinding SessionA6FBinding;

typedef struct session_a6f_host {
    void *context;
    /* REQUIRED. Performs the scene change the pop asks for: `request` is the same scene-change request a 0x3f/0x36
     * transition carries (target = the saved scene, words 0x5bb599/0x5bb595/0x5c39ff, dwords 0x5bb59b/0x5bb59f/
     * 0x5bb5a3), `pop` holds the globals the original wrote (including the start flag 0x5bb1ca). Called at most once
     * per visit, before the saved record is cleared. Nonzero: the host refused; the visit is an ERROR and the saved
     * record is unchanged. */
    int (*apply)(void *context, const SceneStackPop *pop, const SceneTransitionRequest *request);
} SessionA6FHost;

/* Raw 0x6f "return to the saved scene" (RT-29; dispatcher arm 0x4291b6, gate mode 0). The executor evaluates the gate;
 * this handler runs for a true gate. The original calls the pop 0x42e493 (no arguments), sets the row's completion byte to
 * 1 directly (0x4291ec) and leaves the phase word alone (neither 0x42ba3a nor a dependency reset runs, whatever the
 * subtype), so a visit returns DIRECT_COMPLETED with the phase it was given. The pop puts the engine into mode 4, so the
 * dispatcher visits no further row (its loop head needs mode 3, 0x427a8e): the host's transition request makes the
 * executor stop the pass the same way. The body byte is never read. An empty record (0x5c3a05 == 9999) is a fatal error
 * in the original; here it is HANDLER_ERROR before any effect (a 0x6e must run first).
 * `slot` is borrowed and shared with the 0x6e push. */
SessionA6FBinding *session_a6f_create(const SessionA6FHost *host, SceneStackSlot *slot);
void session_a6f_destroy(SessionA6FBinding *);
int session_a6f_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *,
                        SceneActionHandlerResult *);
const char *session_a6f_failure(const SessionA6FBinding *);
/* Completed visits (diagnostics). */
unsigned long session_a6f_pops(const SessionA6FBinding *);

#ifdef __cplusplus
}
#endif
#endif
