#ifndef BLACKMOOR_SESSION_BINDINGS_A45_H
#define BLACKMOOR_SESSION_BINDINGS_A45_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_45.h"
#include "scene_executor.h"
#include "session_bindings_a65_a68_a69.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A45_TYPE ACTION_FAMILY_45_RAW_TYPE

/* Body fields the dispatcher arm 0x4287cc reads (the typed body is the raw scene body, little endian). */
#define SESSION_A45_BODY_RECORD 0x00u        /* signed word: timer record n, 0x585d65 + n * 0x106 */
#define SESSION_A45_BODY_MODE 0x02u          /* signed word: the sub-case 0..6 of the switch at 0x428842 */
#define SESSION_A45_BODY_HOURS 0x04u         /* signed word */
#define SESSION_A45_BODY_MINUTES 0x06u       /* signed word */
#define SESSION_A45_BODY_SECONDS 0x08u       /* signed word; >= SESSION_A45_VARIABLE_BASE selects a loader table word */
#define SESSION_A45_BODY_NAME 0x0cu          /* 49 bytes copied to record+0x28 by modes 5 and 6 */
#define SESSION_A45_BODY_TEXT 0x3du          /* 33 bytes copied to record+0x59 */
#define SESSION_A45_BODY_PAYLOAD 0x5eu       /* 100 bytes copied to record+0x7a */
#define SESSION_A45_BODY_COUNT 0xc2u         /* signed word: entries copied to the event flag pairs (record+0xde+4k) */
#define SESSION_A45_BODY_ENTRIES 0xc4u
/* A seconds word at or above this (signed compare, 0x428928) is an index into the loader word table at 0x5adb81. */
#define SESSION_A45_VARIABLE_BASE 0x1388
#define SESSION_A45_MODE_COUNT 7u

/* Timer record fields (record = 0x585d65 + n * 0x106). */
#define SESSION_TIMER_STATE 0x00u            /* dword: 0 idle, 1 running (raw 0x68), 2, 5 and 6 are set by modes 2, 5, 6 */
#define SESSION_TIMER_ELAPSED_MS 0x04u       /* dword: hours * 3600000 + minutes * 60000 + seconds * 1000 */
#define SESSION_TIMER_SECONDS 0x08u
#define SESSION_TIMER_MINUTES 0x0cu
#define SESSION_TIMER_HOURS 0x10u
#define SESSION_TIMER_RESERVED_14 0x14u      /* dword, zeroed by modes 5 and 6 */
#define SESSION_TIMER_LIMIT_MS 0x18u         /* dword: the same sum for the values modes 5 and 6 store */
#define SESSION_TIMER_LIMIT_SECONDS 0x1cu
#define SESSION_TIMER_LIMIT_MINUTES 0x20u
#define SESSION_TIMER_LIMIT_HOURS 0x24u

typedef struct SessionA45Binding SessionA45Binding;

typedef struct session_a45_host {
    void *context;
    /* REQUIRED. The authoritative timer record `index` (DAT_00585d65 + index * 0x106, SESSION_TIMER_RECORD_BYTES writable
     * bytes), or NULL when the host holds no such record (index < 0 or >= 10 in this port: the original indexes with a signed
     * word and writes wherever that lands). NULL is UNSUPPORTED before any effect. */
    uint8_t *(*time_record)(void *context, unsigned index);
    /* The loader word table at 0x5adb81 + 2 * index (modes 3, 4, 5 and 6 when the seconds word is >= 5000). Return 1 with
     * *value, or 0 when the host cannot source that word: the visit is then UNSUPPORTED before any effect. Optional while
     * no row uses such a value. */
    int (*variable_word)(void *context, int16_t index, int16_t *value);
} SessionA45Host;

/* Raw 0x45 (RT-38; dispatcher arm 0x4287cc of 0x427a50, gate mode 0). The executor evaluates the gate; the handler runs for a
 * true gate. With r the timer record of body word 0 and mode the signed word at body+2:
 *   0: 0x433bd2 clears r, completion byte := 1.            1: r.state := 1, completion.      2: r.state := 2, completion.
 *   3: if r.state is 1, 2, 5 or 6: hours, minutes and seconds of r are increased by the body words (a seconds word >= 5000
 *      adds the table word instead), elapsed ms := h * 3600000 + m * 60000 + s * 1000 (32-bit wrapping), completion.
 *   4: the same with a subtraction and each of hours, minutes, seconds clamped at 0 afterwards.
 *   5, 6: if r.state is 1: limit fields (+0x18..+0x24) from the body values, 49 + 33 + 100 body bytes copied to +0x28, +0x59,
 *      +0x7a, the ten event pair index words (+0xde + 4k) set to 0xffff, `count` four-byte entries copied over the first
 *      pairs, r+0x14 := 0, r.state := mode, completion.
 * Any other mode, or a state the mode does not accept, changes nothing and leaves the row pending (PENDING, phase unchanged);
 * the completion byte is set by the arm itself (DIRECT_COMPLETED, phase unchanged), no generic completion 0x42ba3a and no
 * dependency reset. */
SessionA45Binding *session_a45_create(const SessionA45Host *host);
void session_a45_destroy(SessionA45Binding *);
int session_a45_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a45_failure(const SessionA45Binding *);
/* Visits that completed the row / left it pending (diagnostics). */
unsigned long session_a45_completed(const SessionA45Binding *);
unsigned long session_a45_pending(const SessionA45Binding *);

#ifdef __cplusplus
}
#endif
#endif
