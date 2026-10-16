#ifndef BLACKMOOR_SESSION_BINDINGS_A44_H
#define BLACKMOOR_SESSION_BINDINGS_A44_H

#include "action_core.h"
#include "action_family_44.h"
#include "action_family_44_runtime.h"
#include "action_family_d8_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A44_TYPE ACTION_FAMILY_44_RAW_TYPE

typedef struct SessionA44Binding SessionA44Binding;

/* The binding owns the peephole singleton (0x624686) and one object per raw 0x44 row of the loaded scene (the
 * 0x41166e allocation). The first true-gate visit of a row runs 0x4121b8: the text writer, the generic completion
 * and the replacement of the row by a 0xd8 record (0x411b16); later visits are 0x48c1c0 on that record. The scene
 * clear (0x48bb86) runs on begin_scene and destroy. */
typedef struct SessionA44Host {
    void *context;
    /* AUTOTEXT lookup of the 33-byte key at header + 0x1ed. The returned bytes hold a NUL; they are borrowed. */
    int (*resolve_text)(void *, const uint8_t key[33], const uint8_t **text, size_t *bytes);
    /* 0x413187(object, object + 0x210, 0, 0) after [0x619a41 + 0x102a] := 0: renders the text and reports what
     * 0x411b16 reads afterwards. Nonzero: the visit fails before any change to the row. */
    int (*write_text)(void *, const uint8_t *object, size_t object_bytes, A44TextResult *out);
    /* The scene-change cells and the engine mode (a visit that finishes with a scene change). */
    int (*transition)(void *, const SceneTransitionRequest *request);
    /* 0x5bb1ca := value. */
    int (*set_start_flag)(void *, int32_t value);
    /* Render entries, surfaces, text surface table, tick: see D8Host. Its scene_change, set_start_flag and
     * set_event_flag members are ignored (the binding supplies them); its context is replaced by `context`. */
    D8Host kernel;
} SessionA44Host;

SessionA44Binding *session_a44_create(const SessionA44Host *host, ActionCoreWorld *world);
void session_a44_destroy(SessionA44Binding *binding);
int session_a44_begin_scene(SessionA44Binding *binding, const SceneResource *scene);
int session_a44_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x48bd91 for the pointer cascade (x = [ptr+0x5e], y = [ptr+0x5a]); `input` carries the globals it reads. */
int session_a44_hit_test(SessionA44Binding *binding, int16_t x, int16_t y, const D8HitInput *input,
                         D8HitOutput *out);
/* 0x48c0ac with the candidate 0x5c39e5; on success the row phase to store is in out->phase when
 * out->phase_written (the executor's row phase is the caller's to write). */
int session_a44_click(SessionA44Binding *binding, int32_t candidate, D8ClickOutput *out);
/* 0x48c148 with the phase of the object's row. */
int session_a44_press(SessionA44Binding *binding, uint32_t row_phase, int32_t candidate);
/* 0x48bc38. */
int session_a44_invalidate(SessionA44Binding *binding);
/* Geometry of one render callback 0x48cc70. */
int session_a44_render_plan(SessionA44Binding *binding, const D8View *view, D8RenderPlan *plan);
/* The row index the peephole object is bound to, or -1. */
int session_a44_active_row(const SessionA44Binding *binding);
const D8Object *session_a44_object(const SessionA44Binding *binding);
const char *session_a44_failure(const SessionA44Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
