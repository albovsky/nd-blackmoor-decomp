#ifndef BLACKMOOR_SESSION_BINDINGS_A2E_H
#define BLACKMOOR_SESSION_BINDINGS_A2E_H

#include <stddef.h>
#include <stdint.h>

#include "action_core.h"
#include "action_family_2e.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A2E_TYPE ACTION_FAMILY_2E_RAW_TYPE
/* Scene word that means "no scene change" in 0x4ced84 (0x270f). */
#define SESSION_A2E_NO_SCENE 9999
/* Event flag index word that means "no flag" (-1). */
#define SESSION_A2E_NO_FLAG (-1)

/* The fields of the random-movie object at 0x63821d that 0x4ced84 reads or writes (offsets from the object start). The
 * rest of the object belongs to raw 0x2d (0x4cd6ff), which is not bound yet, so `active` stays 0 in the running game. */
typedef struct session_a2e_movie {
    int32_t active;      /* +0x216: nonzero once a random-movie set is loaded (written 1 only by 0x4cd7f4 of raw 0x2d) */
    int32_t mode;        /* +0x23a: written with the signed body byte on every visit */
    int32_t row;         /* +0x242: written with the visited row (the completion byte at the end uses it) */
    int32_t state_1de;   /* +0x1de */
    int32_t flag_206;    /* +0x206 */
    int32_t pending_25a; /* +0x25a */
} SessionA2EMovie;

/* Ordered stores of one visit, reported right after the corresponding store of the original. */
typedef enum session_a2e_effect {
    SESSION_A2E_FX_ROW = 1,          /* +0x242 := row */
    SESSION_A2E_FX_MODE = 2,         /* +0x23a := signed body byte */
    SESSION_A2E_FX_EVENT_FLAG = 3,   /* dword [0x585801 + 4 * index] := value; `value` is the index, then the value follows */
    SESSION_A2E_FX_EVENT_VALUE = 4,
    SESSION_A2E_FX_XFER_5BB57B = 5,  /* dword := sign-extended scene word */
    SESSION_A2E_FX_XFER_5BB599 = 6,  /* word */
    SESSION_A2E_FX_XFER_5BB595 = 7,  /* word */
    SESSION_A2E_FX_XFER_5C39FF = 8,  /* word */
    SESSION_A2E_FX_XFER_5BB59B = 9,  /* dword := 0 */
    SESSION_A2E_FX_XFER_5BB59F = 10, /* dword := 0 */
    SESSION_A2E_FX_XFER_5BB5A3 = 11, /* dword := 1 */
    SESSION_A2E_FX_ENGINE_MODE = 12, /* 0x583999 := 4 */
    SESSION_A2E_FX_START_FLAG = 13,  /* 0x5bb1ca := (word 13 != 1) */
    SESSION_A2E_FX_STATE_1DE = 14,
    SESSION_A2E_FX_FLAG_206 = 15,
    SESSION_A2E_FX_PENDING_25A = 16,
    SESSION_A2E_FX_DONE = 17         /* completion byte of the row at +0x242 := 1 */
} SessionA2EEffect;

typedef struct SessionA2EBinding SessionA2EBinding;

typedef struct session_a2e_host {
    void *context;
    /* Needed only when the random-movie set is active (mode 1): receives the new value of DAT_005bb1ca (the start flag). */
    void (*set_start_flag)(void *context, int32_t value);
    /* Needed only when the set is active, mode 1 and the scene word is not 9999: the scene-change cells
     * 0x5bb57b/0x5bb599/0x5bb595/0x5c39ff/0x5bb59b/0x5bb59f/0x5bb5a3 and the engine mode 0x583999 := 4 as one request
     * (the same shape the 0x0a, 0x17 and 0x0c arms use). Nonzero: refused, the visit is an error. */
    int (*transition)(void *context, const SceneTransitionRequest *request);
    /* Optional ordered effect observer (SessionA2EEffect). */
    void (*observe)(void *context, size_t row, int effect, int32_t value);
} SessionA2EHost;

/* Raw 0x2e "random movie" control row (RT-33; dispatcher arm 0x427f62, gate mode 0, handler 0x4ced84 on the object
 * 0x63821d). The executor evaluates the gate; this handler runs for a true gate. It stores the row and the signed body
 * byte (the mode) in the object, and only if the object is active (+0x216 != 0) acts on the mode:
 *   0   0x4ceb3b stops the random movie (releases the movie set through 0x4cd218) and then the arm applies the same
 *       scene/variable/start-flag block as mode 1 below. NOT modelled: the visit is UNSUPPORTED before any effect;
 *   1   variable store, scene change, start flag, then state 1de := 2 and flag 206 := 0;
 *   2   state 1de := 0 (3 and pending 25a := 0 if 25a was set), flag 206 := 1;
 *   other values do nothing.
 * Every returning path then sets the completion byte of the row at +0x242 directly (0x4cf019): a visit returns
 * DIRECT_COMPLETED with the phase it was given (no 0x42ba3a, no dependency reset, whatever the subtype).
 * `world` is borrowed: event_flags[index] is the only write to it. */
SessionA2EBinding *session_a2e_create(const SessionA2EHost *host, ActionCoreWorld *world);
void session_a2e_destroy(SessionA2EBinding *);
int session_a2e_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a2e_failure(const SessionA2EBinding *);
/* The binding's copy of the object fields (raw 0x2d will share it); the setter lets a host or a test activate the object. */
const SessionA2EMovie *session_a2e_movie(const SessionA2EBinding *);
void session_a2e_set_movie(SessionA2EBinding *, const SessionA2EMovie *);
/* Completed visits (diagnostics). */
unsigned long session_a2e_visits(const SessionA2EBinding *);

#ifdef __cplusplus
}
#endif
#endif
