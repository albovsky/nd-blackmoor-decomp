#ifndef BLACKMOOR_SESSION_BINDINGS_A7D_H
#define BLACKMOOR_SESSION_BINDINGS_A7D_H

#include "action_family_7d.h"
#include "action_family_7d_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A7D_TYPE ACTION_FAMILY_7D_RAW_TYPE

typedef struct SessionA7DBinding SessionA7DBinding;

typedef struct session_a7d_host {
    void *context;
    /* REQUIRED. Performs the scene change the pop asks for: `request` is the same scene-change request a 0x3f/0x36
     * transition carries (target = the saved scene, words 0x5bb599/0x5bb595/0x5c39ff, dwords 0x5bb59b/0x5bb59f/
     * 0x5bb5a3), `pop` holds the globals the original wrote (including the start flag 0x5bb1ca). Called at most once
     * per visit, before the saved record is cleared. Nonzero: the host refused; the visit is an ERROR and the saved
     * record is unchanged. */
    int (*apply)(void *context, const SceneStackPop *pop, const SceneTransitionRequest *request);
    /* REQUIRED when the view close flag is 0 (byte 0x583232 := 1: the inventory screen opens next tick). */
    int (*open_inventory)(void *context);
    /* REQUIRED when the selector 0x583f1d holds an item: the view rebuild 0x4e812f after the item is added back, and
     * the UI animation request 0x4e0559(index 1, enable 0, sub 0). */
    int (*rebuild_view)(void *context, int16_t item);
    int (*request_ui_animation)(void *context, int16_t index, int32_t enable, int16_t sub);
} SessionA7DHost;

/* Raw 0x7d (RT-41; dispatcher arm 0x42950b, gate mode 0). The executor evaluates the gate; this handler runs for a true
 * gate. The original calls 0x4eb5f2 (restore the second saved-scene record, re-add the item taken along, request the
 * inventory screen), stores -1 into 0x583f1d and sets the row's completion byte to 1 directly (0x42954f): a visit
 * returns DIRECT_COMPLETED with the phase it was given (neither 0x42ba3a nor a dependency reset runs, whatever the
 * subtype). The scene change puts the engine into mode 4, so no later row of the pass runs. The one body byte is never
 * read. An empty record is HANDLER_ERROR before any effect (the original would request scene 9999).
 * Everything the model points to is borrowed and must outlive the binding (the inventory model is read at every visit). */
SessionA7DBinding *session_a7d_create(const SessionA7DHost *host, SceneRestoreSlot *slot, int16_t *held_selector,
                                      const Action78Model *inventory, const uint8_t *view_close_flag);
void session_a7d_destroy(SessionA7DBinding *);
int session_a7d_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *,
                        SceneActionHandlerResult *);
const char *session_a7d_failure(const SessionA7DBinding *);
/* Result of the most recent successful visit (all zero before the first). */
Action7dResult session_a7d_last_result(const SessionA7DBinding *);
/* Completed visits (diagnostics). */
unsigned long session_a7d_visits(const SessionA7DBinding *);

#ifdef __cplusplus
}
#endif
#endif
