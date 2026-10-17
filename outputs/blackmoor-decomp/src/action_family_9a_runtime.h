#ifndef BLACKMOOR_ACTION_FAMILY_9A_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_9A_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_9a.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x9a, "stop sound channels, then leave for a scene" (RT-57; 1 corpus row, scene S6301).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x40fee2  loader arm (action_family_9a.c): 27 body bytes, shared with raw 0x9b.
 *   0x427a50  dispatcher arm 0x429d34 (type 0x9a, gate 0x423f57 mode 0): for a true gate calls 0x4336ad(row, 0). The arm for
 *             raw 0x9b (0x429d6f, not in the corpus, not registered) calls the same function with 1 and also unloads.
 *   0x4336ad  the handler. Row state dword [0x5bb632 + row * 0x8d] (the executor's phase):
 *               0  -> state := 2, nothing else (the row stays pending);
 *               2  -> the work below, then the completion byte [0x5bb625 + row * 0x8d] := 1 directly (0x4338b0): no generic
 *                     completion, no dependency reset, the phase word is not written;
 *               anything else -> nothing happens (the row stays pending with its phase).
 *             The work, in this order, on the 27-byte object (word indexes are byte offsets / 2):
 *               1. sound stop: word 0 (signed). 0x14 stops channels 0..13 and 0x15 stops channels 1..13 (a signed 16-bit counter
 *                  below 14), every other value stops that one channel; each stop is 0x4fc878 on the scene sound object 0x5c3a67
 *                  (a channel whose state word is 1 is stopped through 0x4f61e7 and its state set to 2).
 *               2. unload: only when the second argument is nonzero (raw 0x9b): the same loop with 0x4fc808. Not used here.
 *               3. word 1 != 9999 (signed): [0x5bb57b] := signed word 1, words [0x5bb599] := word 2, [0x5bb595] := word 3,
 *                  [0x5c39ff] := word 4, dwords [0x5bb59b] := bytes 10..13, [0x5bb59f] := bytes 14..17, [0x5bb5a3] := bytes
 *                  18..21, start flag [0x5bb1ca] := (signed word at bytes 25..26 != 1), engine mode [0x583999] := 4. The same
 *                  cells as the 0x0a scene-change arm; the app turns them into one transition request.
 *               4. word 11 (signed, bytes 22..23) != -1: dword [0x585801 + 4 * word 11] := byte 24 (zero-extended).
 *             With the debug flag 0x63a4cd set 0x4fc878 first logs (0x44a2b7); the native module models the flag as 0.
 * Nothing here claims original source structure. */

#define ACTION_FAMILY_9A_RUNTIME_OK 0
#define ACTION_FAMILY_9A_RUNTIME_ERR_ARGUMENT 1
#define ACTION_FAMILY_9A_RUNTIME_ERR_HOST 2
/* Native-only refusal: the event flag index is outside the host's window; nothing happened. */
#define ACTION_FAMILY_9A_RUNTIME_ERR_FLAG 3

#define ACTION_FAMILY_9A_SCENE_NONE 9999

/* The cells the transition part writes. start_flag is the process-wide start flag (the other row handlers write it too). */
typedef struct {
    int32_t scene_5bb57b;
    int16_t word_5bb599;
    int16_t word_5bb595;
    int16_t word_5c39ff;
    int32_t dword_5bb59b;
    int32_t dword_5bb59f;
    int32_t dword_5bb5a3;
    int32_t start_flag_5bb1ca;
    int32_t engine_mode_583999;
} Action9AWorld;

typedef struct {
    void *context;
    /* REQUIRED. 0x4fc878(channel) on 0x5c3a67 (channel is the low 16 bits pushed by the arm, 0..13 for the loops). Nonzero
     * return = failure (the visit stops there; nothing after it ran). */
    int (*stop_channel)(void *context, uint16_t channel);
    /* REQUIRED. Pure query: nonzero when `index` is not a valid event flag (native safety, not an original check). */
    int (*event_flag_invalid)(void *context, int16_t index);
    /* REQUIRED. dword [0x585801 + 4 * index] := value (a zero-extended byte). Nonzero return = failure. */
    int (*store_event_flag)(void *context, int16_t index, uint32_t value);
} Action9AHost;

typedef struct {
    uint32_t phase;                                  /* phase to store */
    SceneActionHandlerDisposition disposition;       /* PENDING (phase 0 -> 2, other phases unchanged) or DIRECT_COMPLETED */
    uint8_t worked;                                  /* the work ran (state 2) */
    uint8_t transition;                              /* word 1 != 9999: the cells in *world are a scene change */
} Action9AOutcome;

/* One true-gate visit with the row's phase. ACTION_FAMILY_9A_RUNTIME_OK; _ERR_ARGUMENT on a null pointer; _ERR_FLAG when the
 * event flag index is invalid (refused before any effect); _ERR_HOST when a stop failed (earlier stops already ran, *world is
 * untouched). *world changes only when the work completed. */
int action_family_9a_runtime_visit(const ActionFamily9ADecoded *decoded, uint32_t phase, Action9AWorld *world,
                                   const Action9AHost *host, Action9AOutcome *outcome);

#ifdef __cplusplus
}
#endif
#endif
