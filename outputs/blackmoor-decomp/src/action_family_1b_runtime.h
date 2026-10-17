#ifndef BLACKMOOR_ACTION_FAMILY_1B_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_1B_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_1b.h"
#include "action_family_17_runtime.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x1b, a two-table scene-change hotspot (RT-40; 4 corpus rows).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly and by the original-x86 oracle:
 *   0x414692  loader constructor (A-1B.1, src/action_family_1b.c): the 34-byte row object
 *   0x427c87  dispatcher arm for runtime type 0x1b (gate 0x423f57 mode 1): for a true gate the arm calls the object method
 *             0x414947 on the static object 0x6385db with the row index. Nothing else: the method itself stores the row's
 *             completion byte, so the arm never calls the generic completion 0x42ba3a
 *   0x414947  the method (806 bytes, no calls): the row object, its primary array and its secondary array go to the object's
 *             fields +0x1c, +0x24 and +0x20 first (scratch cells; no other code reads them), then the row phase dword
 *             (0x5bb632) picks
 *   0x4f1f16  the GENERIC row loop of the pointer cascade 0x4f0059 hits a row whose request dword (0x5bb626) is nonzero and
 *             whose rectangle words (0x5bb62a/2c/2e/30) contain the pointer
 *   0x4f22ad  its type-0x1b case: the hover cursor
 *
 * Object (A-1B.1): +0 primary count, +2 primary array (22-byte records), +6 five fixed words, +0x10 three fixed dwords, +0x1c
 * secondary count, +0x1e secondary array (18-byte records: word selector, four dwords left/top/right/bottom).
 *
 * Phase 0 (0x4149b2): 0x5bb1ca := 1, row phase := 1, then phase 1 in the same call.
 * Phase 1 (0x4149d0): request := 0; the FIRST secondary record whose selector word equals the world selector 0x5bb50b (both
 *   sign-extended) sets request := 1 and copies the low words of its four dwords into the row rectangle words; the scan stops
 *   at the hit (0x414ad5).
 * Phase 2 (0x414ada): completion byte := 1 (direct store: no 0x42ba3a, no dependency reset, the phase stays 2); the FIRST
 *   primary record whose key word equals the held-item word 0x583a29 (both sign-extended) supplies the scene-change cells, and
 *   with no hit the five fixed words / three fixed dwords of the object do (target 0x5bb57b sign-extended from a word,
 *   0x5bb599, 0x5bb595, 0x5c39ff, 0x5bb59b, 0x5bb59f, 0x5bb5a3); then the engine mode 0x583999 := 4.
 * Any other phase has no effect.
 *
 * Native safety: the shared decoder (action_family_1b_decode) rejects a body whose counts are negative or whose spans overrun;
 * nothing is changed then. The kernel never reads beyond the decoded views. */

#define ACTION1B_RAW_TYPE ACTION_FAMILY_1B_RAW_TYPE

/* Process globals the method reads or writes. */
typedef struct {
    int16_t selector;        /* 0x5bb50b, read in phase 1 */
    int16_t held_item;       /* 0x583a29, read in phase 2 (-1: none) */
    int16_t xfer_5bb599;
    int16_t xfer_5bb595;
    int16_t xfer_5c39ff;
    int32_t start_flag_5bb1ca;
    int32_t mode_583999;     /* 4 on finish */
    int32_t xfer_5bb57b;     /* sign-extended word */
    int32_t xfer_5bb59b;
    int32_t xfer_5bb59f;
    int32_t xfer_5bb5a3;
} Action1bWorld;

/* One true-gate visit of 0x414947 on a decoded row (phase = the row phase dword). ACTION17_OK; ACTION17_ERR_ARGUMENT on a null
 * pointer. Nothing is changed unless ACTION17_OK is returned. result->matched_record is the phase-1 secondary hit or the
 * phase-2 primary hit (-1 none, or the fixed block). */
int action1b_step(const ActionFamily1bDecoded *decoded, uint32_t phase, Action17Slot *slot, Action1bWorld *world,
                  const Action17Host *host, Action17Result *result);

/* Hover cursor of a hit on the row (cascade case 0x4f22ad) while the held-item word 0x583a29 is `held_item` (-1 none). */
int action1b_hover_cursor(const ActionFamily1bDecoded *decoded, int16_t held_item, Action17Cursor *out);

#ifdef __cplusplus
}
#endif
#endif
