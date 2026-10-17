#ifndef BLACKMOOR_SESSION_BINDINGS_A20_A70_A80_H
#define BLACKMOOR_SESSION_BINDINGS_A20_A70_A80_H

/* Session bindings for raw actions 0x20, 0x70 and 0x80 (RT-48): three small arms of the dispatcher 0x427a50 (arms 0x429373,
 * 0x4291f8 and 0x42960b, all gate mode 0) that store process cells and finish with a direct completion-byte store. The
 * kernels are action_family_20_runtime.c, action_family_70_runtime.c and action_family_80_runtime.c; the cells and the
 * erase/sound/transition effects are the hosts' (the app maps them onto its own state). The executor evaluates the gate; the
 * handlers run only for a true gate. */

#include "action_family_20_runtime.h"
#include "action_family_70_runtime.h"
#include "action_family_80_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A20_TYPE ACTION_FAMILY_20_RAW_TYPE
#define SESSION_A70_TYPE ACTION_FAMILY_70_RAW_TYPE
#define SESSION_A80_TYPE ACTION_FAMILY_80_RAW_TYPE

typedef struct SessionA20Binding SessionA20Binding;
typedef struct SessionA70Binding SessionA70Binding;
typedef struct SessionA80Binding SessionA80Binding;

/* ---- raw 0x20 ---------------------------------------------------------------------------------------------------------- */
typedef struct SessionA20Host {
    void *context;
    /* Fill the cells the arm reads (0x5bb57f) and carries (the others keep their last values). Nonzero refuses (UNSUPPORTED). */
    int (*load_world)(void *context, Action20World *world);
    /* Commit the cells the arm wrote. Optional. */
    void (*store_world)(void *context, const Action20World *world);
    /* REQUIRED: erase every loaded action row (0x43e96c + 0x43e8b8). Stores the number of rows erased. */
    int (*erase_rows)(void *context, uint32_t *rows_erased);
} SessionA20Host;

/* The row erases itself with the others: DIRECT_COMPLETED with phase 0. Without load_world or erase_rows the visit is UNSUPPORTED
 * before any effect. */
SessionA20Binding *session_a20_create(const SessionA20Host *host);
void session_a20_destroy(SessionA20Binding *binding);
int session_a20_handler(void *context, size_t action_index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before, SceneActionHandlerResult *result);
const char *session_a20_failure(const SessionA20Binding *binding);
const Action20Outcome *session_a20_last_outcome(const SessionA20Binding *binding);
unsigned long session_a20_visits(const SessionA20Binding *binding);

/* ---- raw 0x70 ---------------------------------------------------------------------------------------------------------- */
typedef struct SessionA70Host {
    void *context;
    /* Nonzero refuses (UNSUPPORTED). The arm writes every cell it owns without reading any, so this only fills the carried ones. */
    int (*load_world)(void *context, Action70World *world);
    void (*store_world)(void *context, const Action70World *world);
    /* REQUIRED: 0x4fb018 on the scene sound object 0x5c3a67 (MSND channel, then sound channels 0..13). */
    int (*unload_scene_sound)(void *context);
} SessionA70Host;

/* DIRECT_COMPLETED with the phase the row was given (0x429269 stores only the completion byte). */
SessionA70Binding *session_a70_create(const SessionA70Host *host);
void session_a70_destroy(SessionA70Binding *binding);
int session_a70_handler(void *context, size_t action_index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before, SceneActionHandlerResult *result);
const char *session_a70_failure(const SessionA70Binding *binding);
unsigned long session_a70_visits(const SessionA70Binding *binding);

/* ---- raw 0x80 ---------------------------------------------------------------------------------------------------------- */
typedef struct SessionA80Host {
    void *context;
    /* REQUIRED. Fill the object fields the method reads. uses_stored_scene is nonzero when the row's body word is 9999 (the
     * scene then comes from the object's stored return tuple). Nonzero refuses (UNSUPPORTED before any effect). */
    int (*load_object)(void *context, int uses_stored_scene, Action80Object *object);
    /* Fill the cells the method carries. Optional (zero cells). */
    int (*load_world)(void *context, Action80World *world);
    /* Commit the object fields and cells the method wrote. Optional. */
    void (*store_object)(void *context, const Action80Object *object);
    void (*store_world)(void *context, const Action80World *world);
    /* REQUIRED. The method's scene-change cells and mode 4 as a transition request (target 0x5bb57b, words 0x5bb599, 0x5bb595,
     * 0x5c39ff, dwords 0x5bb59b, 0x5bb59f, 0x5bb5a3). Nonzero = refused: the visit is an ERROR and nothing is committed. */
    int (*transition)(void *context, const SceneTransitionRequest *request);
} SessionA80Host;

/* DIRECT_COMPLETED with the phase the row was given (0x42964e stores only the completion byte). */
SessionA80Binding *session_a80_create(const SessionA80Host *host);
void session_a80_destroy(SessionA80Binding *binding);
int session_a80_handler(void *context, size_t action_index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before, SceneActionHandlerResult *result);
const char *session_a80_failure(const SessionA80Binding *binding);
const Action80World *session_a80_last_world(const SessionA80Binding *binding);
unsigned long session_a80_visits(const SessionA80Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
