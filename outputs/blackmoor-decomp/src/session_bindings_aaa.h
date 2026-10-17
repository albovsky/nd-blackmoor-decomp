#ifndef BLACKMOOR_SESSION_BINDINGS_AAA_H
#define BLACKMOOR_SESSION_BINDINGS_AAA_H

#include "action_family_aa_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AAA_TYPE 0xaa

typedef struct SessionAaaBinding SessionAaaBinding;

typedef struct SessionAaaHost {
    AlcHost kernel;
    /* Optional: fills the process cells the handler reads (start flag 0x5bb1ca, game hour word 0x585d51, game minute word
     * 0x585d4f) just before every visit and before every click. Without it the binding keeps its own copy, which only the
     * handler writes. */
    void (*load_world)(void *context, AlcWorld *world);
    /* Optional: receives the cells the handler wrote after a visit that wrote them (phase 0: start flag; phase 2: start flag and,
     * after a set, the game clock). */
    void (*store_world)(void *context, const AlcWorld *world);
} SessionAaaHost;

/* RT-52. The binding owns the singleton object (CAlarmClock, 0x624cbf), the process cells of phases 0 and 2 (AlcWorld) and
 * one MUTABLE copy of each 763-byte loader allocation per row of the loaded scene. The scene clear (0x438cac, 0x43dfb5 ->
 * 0x44d154) runs on begin_scene and destroy; like the original it runs unconditionally and is harmless on an idle object.
 * Dependencies stay in the executor; only eligible rows reach the handler. Phase 2 reports the generic completion (0x42ba3a)
 * as COMPLETED, so the executor applies the subtype behaviour; phases 0 and 1 are PENDING with the phase the visit ended in. */
SessionAaaBinding *session_aaa_create(const SessionAaaHost *host);
void session_aaa_destroy(SessionAaaBinding *binding);
int session_aaa_begin_scene(SessionAaaBinding *binding, const SceneResource *scene);
int session_aaa_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x44d28c, fed with the view-relative cursor hot spot (x, y). `out` reports the candidate and the cursor cells the original
 * writes (0x5c39e5, 0x5b44f0, 0x5b44f4); the host publishes them. Nothing happens while the clock is inactive. */
int session_aaa_pointer_move(SessionAaaBinding *binding, int32_t x, int32_t y, AlcPointerResult *out);
/* 0x44d624, which the original calls on every accepted release; it guards itself, so there is no candidate. `row_phase` is the
 * executor's phase of the clock's row (session_aaa_object()->row). `out` (optional) is filled even while the clock is inactive. */
int session_aaa_click(SessionAaaBinding *binding, uint32_t row_phase, AlcClickResult *out);
/* 0x44d19d, the redraw request of the 0x43d910 sweep. */
int session_aaa_invalidate(SessionAaaBinding *binding);
/* One render callback 0x44e035: the blits the host performs, in order. valid is 0 when there is no render entry. */
int session_aaa_render(SessionAaaBinding *binding, AlcRenderResult *out);
/* Nonzero while the object owns a render entry. */
unsigned session_aaa_registered(const SessionAaaBinding *binding);
const AlcObject *session_aaa_object(const SessionAaaBinding *binding);
const char *session_aaa_failure(const SessionAaaBinding *binding);

#ifdef __cplusplus
}
#endif
#endif
