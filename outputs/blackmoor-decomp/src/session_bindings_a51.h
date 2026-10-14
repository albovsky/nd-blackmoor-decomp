#ifndef BLACKMOOR_SESSION_BINDINGS_A51_H
#define BLACKMOOR_SESSION_BINDINGS_A51_H

/* Session binding for raw action 0x51 (AT_MULTI_TEXTBOX_WRITE).
 *
 * Loader: case 0x51 of 0x40b34a builds one runtime record per row at scene
 * load. Runtime: case 0x51 of 0x427a50 (0x4281d3..0x42842c), after the
 * dependency gate 0x423f57(deps, 0). The reviewed kernel is
 * action_family_51_decode / action_family_51_step; this module owns what the
 * kernel leaves to the integrator:
 *
 *  - the per-scene record buffers (the runtime rewrites record word 0, so the
 *    buffers must live as long as the scene and must not be rebuilt per tick);
 *  - the shared ActionFamily51World (0x5bb226, 0x5b1606, 0x5b1602);
 *  - the mapping of ActionFamily51Result onto the executor's disposition.
 *
 * Renderer, sound and clock effects stay host callbacks (ActionFamily51Backend)
 * and AUTOTEXT stays a host lookup. The kernel only calls the callbacks the
 * visit actually reaches, so a host may leave unused ones NULL: a visit that
 * needs a missing callback reports UNSUPPORTED before any effect, which makes
 * the unbound renderer an explicit, named blocker. */

#include "action_family_51.h"
#include "scene_executor.h"
#include "scene_resource.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A51_TYPE ACTION_FAMILY_51_TYPE

typedef struct SessionA51Binding SessionA51Binding;

typedef enum session_a51_status {
    SESSION_A51_OK = 0,
    SESSION_A51_ERR_ARGUMENT = 1,
    SESSION_A51_ERR_MEMORY = 2,
    /* A row's loader construction was fatal in the original (0x4c97b4): bad
     * body or size limit. The scene must not run. */
    SESSION_A51_ERR_SCENE = 3
} SessionA51Status;

typedef enum session_a51_row_state {
    SESSION_A51_ROW_NOT_A51 = 0,
    SESSION_A51_ROW_READY = 1,
    /* The loader could not run for this row because a host provider was
     * missing (no AUTOTEXT lookup). The row reports UNSUPPORTED if visited. */
    SESSION_A51_ROW_UNSUPPORTED = 2
} SessionA51RowState;

/* Hooks around each kernel step, for hosts whose caption renderer keeps the
 * shared process globals (0x5b1602, 0x5b1606) in its own structure: load_world
 * copies them in before the step, store_world copies the result back after it
 * (also after a failed step, which keeps partial state). Both optional. */
typedef struct session_a51_host {
    ActionFamily51Backend backend;
    ActionFamily51AutoTextLookup lookup;
    void *lookup_context;
    void *world_context;
    void (*load_world)(void *context, ActionFamily51World *world);
    void (*store_world)(void *context, const ActionFamily51World *world);
} SessionA51Host;

SessionA51Binding *session_a51_create(const SessionA51Host *host);
void session_a51_destroy(SessionA51Binding *binding);

/* Run the loader construction for every 0x51 row of `scene`, replacing the
 * previous scene's records. On SESSION_A51_ERR_SCENE, *failed_row and
 * *kernel_status (ACTION_FAMILY_51_ERR_*) name the first fatal row and the
 * binding keeps no records. failed_row / kernel_status may be NULL. */
int session_a51_begin_scene(SessionA51Binding *binding,
                            const SceneResource *scene,
                            size_t *failed_row,
                            int *kernel_status);

/* SceneActionExternalHandler for type 0x51. `context` is the binding. */
int session_a51_handler(void *context,
                        size_t action_index,
                        const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before,
                        SceneActionHandlerResult *result);

/* Diagnostics. last_kernel_status is the ACTION_FAMILY_51_* status of the last
 * handler visit (or the deferred loader status of the row it refused). */
int session_a51_last_kernel_status(const SessionA51Binding *binding);
SessionA51RowState session_a51_row_state(const SessionA51Binding *binding,
                                         size_t action_index);
/* Current runtime record word 0 (renderer); -1 if the row has no record. */
int session_a51_record_renderer(const SessionA51Binding *binding,
                                size_t action_index);
const ActionFamily51World *session_a51_world(const SessionA51Binding *binding);

#ifdef __cplusplus
}
#endif

#endif
