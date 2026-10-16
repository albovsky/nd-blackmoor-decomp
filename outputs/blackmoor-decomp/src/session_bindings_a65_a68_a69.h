#ifndef BLACKMOOR_SESSION_BINDINGS_A65_A68_A69_H
#define BLACKMOOR_SESSION_BINDINGS_A65_A68_A69_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_65.h"
#include "action_family_68.h"
#include "action_family_69.h"
#include "scene_executor.h"
#include "world_init.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A65_TYPE ACTION_FAMILY_65_RAW_TYPE
#define SESSION_A68_TYPE ACTION_FAMILY_68_RAW_TYPE
#define SESSION_A69_TYPE ACTION_FAMILY_69_RAW_TYPE
/* The name dispatcher arm 0x4285fd passes to the save routine 0x4d7a15 (string at 0x545630, without the trailing NUL). */
#define SESSION_A65_SAVE_NAME "SAVE CONTINUE"
/* The timer record table DAT_00585d65: records of WORLD_INIT_TIME_RECORD_SIZE (0x106) bytes, WORLD_INIT_TIME_RECORD_COUNT
 * (10) of them in this port (the original indexes a byte, 0..255, without a bound check). */
#define SESSION_TIMER_RECORD_BYTES WORLD_INIT_TIME_RECORD_SIZE
#define SESSION_TIMER_RECORD_COUNT WORLD_INIT_TIME_RECORD_COUNT
/* The dword at record+0 that raw 0x68 stores after the reset (0x428744 stores 1: the timer is running). */
#define SESSION_A68_STATE_RUNNING 1

typedef struct SessionA65Binding SessionA65Binding;

typedef struct session_a65_host {
    void *context;
    /* REQUIRED for raw 0x68 and 0x69. The authoritative timer record `index` (DAT_00585d65 + index * 0x106,
     * SESSION_TIMER_RECORD_BYTES writable bytes), or NULL when the host holds no such record (index >= 10 in this port: the
     * original would write past its 10-record table). Without it, or on NULL, the visit is UNSUPPORTED before any effect. */
    uint8_t *(*time_record)(void *context, unsigned index);
    /* REQUIRED for raw 0x65. The save routine 0x4d7a15 as arm 0x4285fd calls it: this = the game object 0x5e2e70,
     * name = SESSION_A65_SAVE_NAME, report_failure = 0 (its second argument: nonzero only makes a failed fopen log). The
     * arm ignores the routine's result and sets the completion byte either way, so there is nothing to return. Without the
     * hook the visit is UNSUPPORTED before any effect. */
    void (*save_game)(void *context, const char *name, int report_failure);
} SessionA65Host;

/* Raw 0x65 (SAVE_CONTINUE, RT-37; dispatcher arm 0x4285fd of 0x427a50, gate mode 0), raw 0x68 (arm 0x4286d8, timer start) and
 * raw 0x69 (arm 0x42875d, timer clear). The executor evaluates the gate; these handlers run for a true gate.
 *   0x65: 0x4d7a15(&0x5e2e70, "SAVE CONTINUE", 0), then the completion byte := 1 (0x42863f).
 *   0x68: the timer record n = (unsigned byte) body[0] is cleared by 0x433bd2, then its state dword := 1 (0x428744), then the
 *         completion byte := 1 (0x428751).
 *   0x69: the timer record n is cleared by 0x433bd2, then the completion byte := 1 (0x4287c0).
 * In all three the arm sets the completion byte itself: DIRECT_COMPLETED with the phase it was given, no generic completion
 * 0x42ba3a and no dependency reset, whatever the subtype. 0x433bd2 clears the 0x106 bytes, stores 0xffff in the ten event flag
 * pairs' index words (+0xde + 4k), and copies "NO SOUND" to +0x28. */
SessionA65Binding *session_a65_create(const SessionA65Host *host);
void session_a65_destroy(SessionA65Binding *);
int session_a65_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *, SceneActionHandlerResult *);
int session_a68_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *, SceneActionHandlerResult *);
int session_a69_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a65_failure(const SessionA65Binding *);
/* Completed visits per raw type (diagnostics). */
unsigned long session_a65_visits(const SessionA65Binding *);
unsigned long session_a68_visits(const SessionA65Binding *);
unsigned long session_a69_visits(const SessionA65Binding *);

/* The kernel of 0x433bd2 on one record: `record` must have SESSION_TIMER_RECORD_BYTES writable bytes. */
void session_timer_record_clear(uint8_t *record);

#ifdef __cplusplus
}
#endif
#endif
