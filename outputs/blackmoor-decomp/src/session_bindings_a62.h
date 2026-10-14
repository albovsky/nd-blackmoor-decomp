#ifndef BLACKMOOR_SESSION_BINDINGS_A62_H
#define BLACKMOOR_SESSION_BINDINGS_A62_H

/* Session binding for raw action 0x62 ("Event Flags with Cursor and HS").
 *
 * Original handler: 0x42ea87, reached from case 0x62 of 0x427a50 after the
 * dependency gate 0x423f57(deps, 1). The reviewed reducer is
 * action_family_62_step; this module supplies the host state it deliberately
 * leaves open and applies its result to that state:
 *
 *   selector         DAT_005bb50b (word, read with movsx at 0x42ebb0)
 *   start flag       DAT_005bb1ca (dword, store at 0x42eb04 in phase 0)
 *   request          slot +0x43 (0x5bb626), dword, one per ACT row
 *   response words   slot +0x47/+0x49/+0x4b/+0x4d (0x5bb62a..0x5bb630)
 *   event flags      0x585801 + id*4 (dword, written at phase 2, 0x42ed24)
 *
 * The request is also cleared by the dispatcher itself before the type switch
 * (0x427a50 prologue); session_a62_pre_gate models that and must be
 * registered with scene_session_set_pre_gate for type 0x62.
 *
 * The binding keeps the per-row request/response table that the cursor scan
 * 0x4f0059 consumes, and exposes that scan through a narrow interface. It does
 * not produce pointer input: the transformed cursor coordinates, the reserved
 * action indices and the cursor command arrive from the pointer provider
 * (RT-2), and a candidate is accepted with the reviewed accept reducer
 * followed by scene_session_accept_action_candidate. */

#include "action_core.h"
#include "action_family_62_interaction.h"
#include "scene_executor.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A62_TYPE UINT8_C(0x62)

typedef struct SessionA62Binding SessionA62Binding;

typedef enum session_a62_status {
    SESSION_A62_OK = 0,
    SESSION_A62_ERR_ARGUMENT = 1,
    SESSION_A62_ERR_MEMORY = 2,
    SESSION_A62_ERR_ROW = 3
} SessionA62Status;

/* Why the last handler visit refused to run. Diagnostic only. */
typedef enum session_a62_failure {
    SESSION_A62_FAIL_NONE = 0,
    /* current_selector reported that DAT_005bb50b cannot be proven. */
    SESSION_A62_FAIL_SELECTOR_UNAVAILABLE = 1,
    SESSION_A62_FAIL_BODY = 2,
    /* A phase-2 event id lies outside the host's event-flag view. The
     * original indexes 0x585801 unchecked; native code rejects instead and
     * applies nothing. */
    SESSION_A62_FAIL_EVENT_ID_RANGE = 3,
    SESSION_A62_FAIL_ROW_RANGE = 4,
    SESSION_A62_FAIL_DISPOSITION_MISMATCH = 5,
    SESSION_A62_FAIL_ARGUMENT = 6
} SessionA62Failure;

/* Host providers. current_selector is required. It returns 0 and the signed
 * 16-bit DAT_005bb50b value only when the host can prove it for the current
 * scene; any other return makes the visit report UNSUPPORTED and change no
 * state. set_start_flag mirrors the shared process global DAT_005bb1ca and is
 * optional (the binding always keeps its own copy as well). */
typedef struct session_a62_host {
    void *context;
    int (*current_selector)(void *context, int16_t *selector);
    void (*set_start_flag)(void *context, int32_t value);
} SessionA62Host;

/* `world` is borrowed; its event_flags view bounds the phase-2 event writes. */
SessionA62Binding *session_a62_create(ActionCoreWorld *world,
                                      const SessionA62Host *host);
void session_a62_destroy(SessionA62Binding *binding);

/* Call after every scene replacement: sizes the request/response table to the
 * new scene's ACT row count and clears it (the original rebuilds its action
 * records per scene). action_count must not exceed SCENE_EXECUTOR_MAX_ACTIONS. */
int session_a62_begin_scene(SessionA62Binding *binding, size_t action_count);

/* SceneActionExternalHandler for type 0x62. `context` is the binding. */
int session_a62_handler(void *context,
                        size_t action_index,
                        const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before,
                        SceneActionHandlerResult *result);

/* SceneActionPreGateFn for type 0x62: the dispatcher's request clear. */
void session_a62_pre_gate(void *context,
                          size_t action_index,
                          const SceneActionInfo *action,
                          const SceneActionRuntimeState *state);

/* Row snapshot for tests and the pointer provider. */
int session_a62_get_target(const SessionA62Binding *binding,
                           size_t action_index,
                           ActionFamily62InteractionTarget *target);
int32_t session_a62_start_flag(const SessionA62Binding *binding);
SessionA62Failure session_a62_last_failure(const SessionA62Binding *binding);
const char *session_a62_failure_string(SessionA62Failure failure);

/* Pointer-side input for the cursor scan 0x4f0059. The two coordinates are
 * the already-transformed values the original compares at cursor-object
 * offsets +0x5a and +0x5e; the reserved indices and the cursor command are
 * the raw values the scan reads. None of them is produced here. */
typedef struct session_a62_scan_request {
    int32_t coordinate_a;
    int32_t coordinate_b;
    int32_t reserved_index_a;
    int32_t reserved_index_b;
    int32_t cursor_command;
} SessionA62ScanRequest;

int session_a62_scan_candidate(const SessionA62Binding *binding,
                               const SessionA62ScanRequest *request,
                               ActionFamily62InteractionScanResult *result);

#ifdef __cplusplus
}
#endif

#endif
