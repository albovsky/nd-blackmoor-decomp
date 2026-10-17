#ifndef BLACKMOOR_SESSION_BINDINGS_AF5_H
#define BLACKMOOR_SESSION_BINDINGS_AF5_H

#include "action_family_f5_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_AF5_TYPE 0xf5

typedef struct SessionAf5Binding SessionAf5Binding;

typedef struct SessionAf5Host {
    TqzHost kernel;
    /* Optional: receives the process globals the handler wrote (start flag 0x5bb1ca) after a visit that wrote it (phase 0 and
     * phase 2). The other cells (0x5a4c0a, 0x5a4c0e, the score / time widget at 0x638603) stay in the binding and are read
     * through session_af5_world(). */
    void (*store_world)(void *context, const TqzWorld *world);
} SessionAf5Host;

/* RT-55. The binding owns the singleton object (CTypingQuiz, 0x61ee6e), the process cells of the handler and the widget
 * (TqzWorld: the start flag 0x5bb1ca, 0x5a4c0a, 0x5a4c0e and the score / time display 0x638603, which survive scene changes
 * like the original globals) and one copy of each 1390-byte loader allocation (0x4b80d9) per row of the loaded scene. The
 * scene clear (0x438c75, 0x43df60 -> 0x4b7ff4 + 0x4b7f3b) runs on begin_scene and destroy; like the original it runs
 * unconditionally, so on an idle object it still issues the font release 0x4c92c5(10) (the host's font surface count must
 * tolerate it). Dependencies stay in the executor; only eligible rows reach the handler. Phase 2 reports the generic
 * completion (0x42ba3a) as COMPLETED, so the executor applies the subtype behaviour; phases 0 and 1 are PENDING with the
 * phase the visit ended in. */
SessionAf5Binding *session_af5_create(const SessionAf5Host *host);
void session_af5_destroy(SessionAf5Binding *binding);
int session_af5_begin_scene(SessionAf5Binding *binding, const SceneResource *scene);
int session_af5_handler(void *context, size_t row, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out);
/* 0x4b81ff, fed with the pointer position (x, y) as the cascade 0x4f0059 does. Nothing happens while the quiz is inactive. */
int session_af5_pointer_move(SessionAf5Binding *binding, int32_t x, int32_t y, TqzPointerResult *out);
/* 0x4b82cd, run on an accepted release that retained `candidate` (0x5c39e5). `row_phase` is the executor's phase of the
 * quiz row (session_af5_object()->row). *new_phase is 2 when the click ended the quiz (the host then stores phase 2 with
 * scene_executor_accept_action_candidate(row)); it equals row_phase otherwise, also while the quiz is inactive. Returns 1
 * when the click was accepted, 0 when not, TQZ_ERR_ARGUMENT on a bad argument. */
int session_af5_click(SessionAf5Binding *binding, uint32_t row_phase, int32_t candidate, uint32_t *new_phase);
/* 0x4b8193 after the character filter 0x437ea1: the typed character (a byte, as the character message handler passes it).
 * `row_phase` is the executor's phase of the quiz row. Returns 1 when the character was stored, 0 when refused (or the quiz
 * is not active), TQZ_ERR_ARGUMENT on a bad argument. */
int session_af5_key(SessionAf5Binding *binding, uint32_t row_phase, int8_t ch);
/* 0x4b80a5, the redraw request of the 0x43da2e sweep. */
int session_af5_invalidate(SessionAf5Binding *binding);
/* 0x4b8087, the new-game reset (0x43851c): clears 0x5a4c0a and 0x5a4c0e. */
void session_af5_new_game(SessionAf5Binding *binding);
/* The render callbacks of the three z entries: the quiz 0x4b9a88, the score half 0x446688 and the clock half 0x4468fe.
 * valid is 0 when the entry is not registered (the original never calls the callback then). A string in the widget that
 * holds a non-digit is refused with TQZ_ERR_BOUNDS (the original indexes past its table). */
int session_af5_render(SessionAf5Binding *binding, TqzRenderResult *out);
int session_af5_render_score(SessionAf5Binding *binding, TqzRenderResult *out);
int session_af5_render_clock(SessionAf5Binding *binding, TqzRenderResult *out);
/* Nonzero while the object owns the quiz render entry. */
unsigned session_af5_registered(const SessionAf5Binding *binding);
const TqzObject *session_af5_object(const SessionAf5Binding *binding);
const TqzWorld *session_af5_world(const SessionAf5Binding *binding);
const char *session_af5_failure(const SessionAf5Binding *binding);

#ifdef __cplusplus
}
#endif
#endif
