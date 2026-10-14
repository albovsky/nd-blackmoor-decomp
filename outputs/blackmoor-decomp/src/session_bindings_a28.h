#ifndef BLACKMOOR_SESSION_BINDINGS_A28_H
#define BLACKMOOR_SESSION_BINDINGS_A28_H

/* Session binding for raw action 0x28 (special effect, CSpecialEffect leaf).
 *
 * Original leaf: 0x44727a, reached from case 0x28 of 0x427a50 after the
 * dependency gate 0x423f57(deps, 0) with the row index as the word argument
 * and the effect object 0x6198d7 as `this`:
 *   phase 0, object idle   busy := 1, copy the 21 payload bytes to +0x49, expand
 *                          or offset the rectangle into +0x1d..+0x29, stage
 *                          (+0x2d) := 0 (0x4473a9), row phase := 2
 *   phase 0, object busy   nothing (the row retries on a later tick)
 *   phase 2                0x42ba3a (subtype 1 completes the row, subtype 2
 *                          resets the dependencies, any other subtype only
 *                          clears the phase)
 * The leaf does not run the effect. The effect runs from the exit handler and
 * the render pass (session_exit.h); a queued effect whose scene is replaced
 * before the row's phase-2 visit never completes the row, exactly as the
 * ClearSceneData row-table reset discards it in the original.
 *
 * The reviewed kernel is action_family28_step. The binding applies its world
 * result to the SessionExit effect object and maps the result onto the
 * executor's dispositions. */

#include "action_family_28.h"
#include "scene_executor.h"
#include "session_exit.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A28_TYPE ACTION_FAMILY_28_TYPE

typedef struct SessionA28Binding SessionA28Binding;

typedef enum session_a28_failure {
    SESSION_A28_FAIL_NONE = 0,
    SESSION_A28_FAIL_ARGUMENT = 1,
    SESSION_A28_FAIL_BODY = 2,
    SESSION_A28_FAIL_DISPOSITION_MISMATCH = 3
} SessionA28Failure;

/* `exit_state` is borrowed and must outlive the binding. */
SessionA28Binding *session_a28_create(SessionExit *exit_state);
void session_a28_destroy(SessionA28Binding *binding);

/* SceneActionExternalHandler for type 0x28. `context` is the binding. */
int session_a28_handler(void *context,
                        size_t action_index,
                        const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before,
                        SceneActionHandlerResult *result);

SessionA28Failure session_a28_last_failure(const SessionA28Binding *binding);
const char *session_a28_failure_string(SessionA28Failure failure);

#ifdef __cplusplus
}
#endif

#endif
