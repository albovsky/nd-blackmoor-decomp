#ifndef BLACKMOOR_SESSION_BINDINGS_A0C_H
#define BLACKMOOR_SESSION_BINDINGS_A0C_H

#include "action_family_0c_runtime.h"
#include "scene_executor.h"
#include "session_bindings_a17.h"
#include "session_input.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime type served by this binding: raw 0x0c (the loader keeps the raw type as the runtime
 * type). The host is the RT-15 host (selector and start flag, scene-change request, effect
 * observer): handler 0x42b2e4 works on the same cells as 0x42b07e and 0x42ae73. */
#define SESSION_A0C_TYPE ACTION0C_RAW_TYPE

typedef struct SessionA0cBinding SessionA0cBinding;
typedef SessionA17Host SessionA0cHost;

/* Diagnostic copy of the fixed part of a row's typed body (original object offsets +0..+8). */
typedef struct {
    int16_t cursor_word;  /* +0: hover cursor word */
    int16_t target;       /* +2: target scene */
    int16_t entry_word;   /* +4: the selector word the target scene starts with (0x5bb599) */
    int16_t word_06;      /* +6: stored in 0x5c39ff */
    int16_t count;        /* +8: record count */
} SessionA0cRowInfo;

SessionA0cBinding *session_a0c_create(const SessionA0cHost *);
void session_a0c_destroy(SessionA0cBinding *);

/* Replaces the per-row typed bodies and zeroes the row slots (scene load). A raw 0x0c row whose
 * typed body is not a complete object fails the whole scene (nonzero return, reason in
 * session_a0c_failure). A failing begin KEEPS the previous scene's rows (bodies, slots, count)
 * untouched; only a successful begin replaces them. The shared parser never produces such a scene,
 * so the path is exercised with a stub scene resource (tests/session_bindings_a0c_stub_scene.c). */
int session_a0c_begin_scene(SessionA0cBinding *, const SceneResource *);

/* Executor handler for runtime type 0x0c. Called only after the executor's dependency gate
 * (mode 0) was true and the row was not completed. Phase 0/1: PENDING with the kernel's phase;
 * phase 2: scene-change request, then DIRECT_COMPLETED with phase 2. An unbound world or
 * transition provider is UNSUPPORTED before any effect; a refused request is a handler error with
 * nothing committed. */
int session_a0c_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
/* 0x427a50 prologue: the request dword is cleared before the type switch and the dependency gate
 * (SceneActionPreGateFn). */
void session_a0c_pre_gate(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *);
const char *session_a0c_failure(const SessionA0cBinding *);

/* The row the generic scan of the pointer cascade (0x4f1f16) offers: 1 and a SessionInputHotspot
 * when the row's request dword is nonzero, else 0. */
int session_a0c_pointer_row(const SessionA0cBinding *, size_t index, SessionInputHotspot *row);
/* Hover cursor of a hit on the row (cascade case 0x4f2033). */
int session_a0c_hover_cursor(const SessionA0cBinding *, size_t index, int16_t held_item,
                             Action17Cursor *out);
/* Diagnostic copy of the row slot; nonzero for an index out of range. */
int session_a0c_slot(const SessionA0cBinding *, size_t index, Action17Slot *out);
size_t session_a0c_row_count(const SessionA0cBinding *);
/* Diagnostics for a row this binding owns (nonzero / NULL otherwise). The body view stays valid
 * until the next begin_scene or destroy. */
int session_a0c_row_info(const SessionA0cBinding *, size_t index, SessionA0cRowInfo *out);
const uint8_t *session_a0c_body(const SessionA0cBinding *, size_t index, size_t *length);

#ifdef __cplusplus
}
#endif
#endif
