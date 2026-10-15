#ifndef BLACKMOOR_SESSION_BINDINGS_A0B_H
#define BLACKMOOR_SESSION_BINDINGS_A0B_H

#include "action_family_0b_runtime.h"
#include "scene_executor.h"
#include "session_bindings_a17.h"
#include "session_input.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime type served by this binding: raw 0x0b (the loader keeps the raw type
 * as the runtime type). The host is the RT-15 host (selector and start flag,
 * scene-change request, effect observer): handler 0x42ae73 and 0x42b07e work
 * on the same cells. */
#define SESSION_A0B_TYPE ACTION0B_RAW_TYPE

typedef struct SessionA0bBinding SessionA0bBinding;
typedef SessionA17Host SessionA0bHost;

SessionA0bBinding *session_a0b_create(const SessionA0bHost *);
void session_a0b_destroy(SessionA0bBinding *);

/* Replaces the per-row payloads and zeroes the row slots (scene load). A raw
 * 0x0b row whose typed body is not exactly 24 bytes fails the whole scene
 * (nonzero return). */
int session_a0b_begin_scene(SessionA0bBinding *, const SceneResource *);

/* Executor handler for runtime type 0x0b. Called only after the executor's
 * dependency gate (mode 1) was true and the row was not completed. Phase 0/1:
 * PENDING with the kernel's phase; phase 2: scene-change request, then
 * DIRECT_COMPLETED with phase 2. */
int session_a0b_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
/* 0x427a50 prologue: the request dword is cleared before the type switch and
 * the dependency gate (SceneActionPreGateFn). */
void session_a0b_pre_gate(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *);
const char *session_a0b_failure(const SessionA0bBinding *);

/* The row the generic scan of the pointer cascade (0x4f1f16) offers: 1 and a
 * SessionInputHotspot when the row's request dword is nonzero, else 0. */
int session_a0b_pointer_row(const SessionA0bBinding *, size_t index, SessionInputHotspot *row);
/* Hover cursor of a hit on the row (cascade case 0x4f221e). */
int session_a0b_hover_cursor(const SessionA0bBinding *, size_t index, int16_t held_item,
                             Action17Cursor *out);
/* Diagnostic copy of the row slot; nonzero for a row this binding does not own. */
int session_a0b_slot(const SessionA0bBinding *, size_t index, Action17Slot *out);
size_t session_a0b_row_count(const SessionA0bBinding *);
/* Diagnostic copy of a row's payload; nonzero for a row this binding does not own. */
int session_a0b_payload(const SessionA0bBinding *, size_t index, Action0bPayload *out);

#ifdef __cplusplus
}
#endif
#endif
