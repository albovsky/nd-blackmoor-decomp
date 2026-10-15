#ifndef BLACKMOOR_SESSION_BINDINGS_AA1_H
#define BLACKMOOR_SESSION_BINDINGS_AA1_H

/* RT-21 session binding for raw action 0xa1 ("Sound", runtime type 0xa1).
 *
 * begin_scene models the loader arm 0x40f069: each raw-0xa1 row becomes its runtime object
 * once, in ACT order, with the AUTOTEXT key resolved at that point (before any dependency
 * is evaluated) and the object never rebuilt during the scene. The handler is the
 * dispatcher arm 0x4297be, i.e. 0x432d1a(row, 1, 0) after the mode-0 gate (the executor
 * owns the gate and the false-gate subtype-2 clear): the shared sound lifecycle
 * action_sound_object_step with the object's own event store (0x585801 + id*4 := byte).
 *
 * Providers follow session_bindings_a97.h. Not modeled here (UNVERIFIED, see the RT-8
 * notes, they apply unchanged): the ~22 constructor-default channel-state fields 0x432d1a
 * copies besides channel/control/gains, the sound manager's rand consumption, and the
 * debug trace gated by 0x63a4cd (zero in the pinned image). */

#include "action_family_a1_runtime.h"
#include "action_family_97_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AA1_TYPE ACTION_FAMILY_A1_RAW_TYPE

typedef struct SessionAa1Binding SessionAa1Binding;

typedef struct SessionAa1Host {
    ActionSoundBackend sound;
    /* AUTOTEXT table 0x619a6b. NULL makes every key-form row a named blocker. */
    ActionFamily97AutoTextLookup lookup;
    void *lookup_context;
    int (*captions_enabled)(void *, uint8_t *);
    int (*transition)(void *, const ActionSoundTransition *);
    /* The host's view of the event dword table 0x585801. Called only by a visit whose
     * event id is not -1. Returns 0 and fills the view, or non-zero. */
    int (*load_events)(void *, A97EventTable *);
    /* Optional observer, called after the store (row, id, value, previous value). */
    void (*event_stored)(void *, size_t row, int16_t id, int32_t value, int32_t previous);
} SessionAa1Host;

typedef struct SessionAa1Row {
    uint8_t present;
    char stem[34];
    uint16_t channel;
    int16_t event_id;
    uint8_t event_value;
    int16_t transition_scene;
    uint8_t mode;
    uint8_t key_missing;
} SessionAa1Row;

SessionAa1Binding *session_aa1_create(const SessionAa1Host *);
void session_aa1_destroy(SessionAa1Binding *);
/* Builds every raw-0xa1 object of the scene (replacing the previous scene's). Returns
 * ACTION_SOUND_OK, or an ACTION_SOUND_ERR_* status for a malformed row. A row whose
 * AUTOTEXT provider is unavailable stays unbuilt and its visits report UNSUPPORTED. */
int session_aa1_begin_scene(SessionAa1Binding *, const SceneResource *);
int session_aa1_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_aa1_failure(const SessionAa1Binding *);
/* 1 and the constructed fields for a built row, else 0 (not a 0xa1 row, or deferred). */
int session_aa1_row(const SessionAa1Binding *, size_t, SessionAa1Row *);

#ifdef __cplusplus
}
#endif
#endif
