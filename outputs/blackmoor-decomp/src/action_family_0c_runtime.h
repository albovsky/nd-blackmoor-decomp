#ifndef BLACKMOOR_ACTION_FAMILY_0C_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_0C_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_17_runtime.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x0c "multi-frame scene-change hotspot" (RT-20, the first stop after the
 * phone-list rows: S2010 row 5; 43 corpus rows in 7 scenes, resources 1385, 1645, 2217, 2338,
 * 2493, 2645 and 2796).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x40bafd  loader arm for raw type 0x0c (A-0C.1): allocates 10 + 18 * count bytes and copies
 *             the typed body verbatim; the runtime type stays 0x0c
 *   0x427c4e  dispatcher arm for runtime type 0x0c (byte map 0x42aba4 index 2 -> jump table
 *             0x42a9b4): gate 0x423f57 mode 0, then the handler with the row index
 *   0x42b2e4  the handler
 *   0x4f0059  pointer cascade: the GENERIC row loop (0x4f1f16..) hits a row whose request dword
 *             (0x5bb626) is nonzero and whose rectangle words (0x5bb62a/2c/2e/30) contain the
 *             pointer; the cascade's type map 0x4f25a0 sends type 0x0c to its own hover case
 *             0x4f2033 (the same code as the type-0x0b case 0x4f221e)
 *
 * Typed body (the original object, offsets from the start): +0 word (hover cursor word, the
 * cascade reads it), +2 word target scene, +4 word (the selector value the target scene
 * starts with), +6 word (stored in 0x5c39ff), +8 signed count, +10 count 18-byte records
 * (word frame, four dwords left/top/right/bottom).
 *
 * Handler, by the row phase dword 0x5bb632 (same shape as the 0x42b07e handler of RT-15):
 *   0 (0x42b318): 0x5bb1ca := 1, phase := 1, then phase 1 in the same call;
 *   1 (0x42b336): request := 0, then the FIRST record whose frame word equals the selector
 *      0x5bb50b (both sign-extended) sets request := 1 and copies the low words of its four
 *      dwords into the row rectangle words (left, top, right, bottom); the scan stops there;
 *   2 (0x42b47d): completion byte := 1 (direct store: no 0x42ba3a, no dependency reset, phase
 *      stays 2), 0x5bb57b := sext(+2), 0x5bb599 := word +4, 0x5c39ff := word +6, 0x5bb595 := 0,
 *      0x5bb59b := 0, 0x5bb59f := 0, 0x5bb5a3 := 1 and the engine mode 0x583999 := 4 (the
 *      dispatcher loop exits). The selected record plays no part in the finish: every record of a
 *      row leads to the same target scene;
 *   other phases: no effect.
 *
 * The cells and effects are the RT-15 ones (action_family_17_runtime.h): the same dispatcher, the
 * same row slot and the same scene-change cells.
 *
 * Native safety rejection (reported separately from valid behaviour): the original trusts the
 * count; the kernel requires the typed body to be exactly 10 + 18 * count bytes with
 * 0 <= count <= 1819 (the domain in which the original's 16-bit loader size arithmetic does not
 * wrap, A-0C.1). A negative count is an empty list in the original; native rejects it because the
 * loader size would have wrapped. */

#define ACTION0C_RAW_TYPE UINT8_C(0x0c)
#define ACTION0C_PREFIX_BYTES 10u
#define ACTION0C_RECORD_BYTES 18u
#define ACTION0C_MAX_COUNT 1819

/* ACTION17_OK, ACTION17_ERR_ARGUMENT (null) or ACTION17_ERR_BOUNDS (not a complete object);
 * `failure` is optional and receives a static reason. */
int action0c_validate_body(const uint8_t *body, size_t body_length, const char **failure);

/* One true-gate visit of 0x42b2e4. The body is the row's typed body. Nothing is changed when a
 * status other than ACTION17_OK is returned. result->matched_record is the phase-1 hit or -1. */
int action0c_step(const uint8_t *body, size_t body_length, uint32_t phase,
                  Action17Slot *slot, Action17World *world, const Action17Host *host,
                  Action17Result *result, const char **failure);

/* Hover cursor of a hit on the row (cascade case 0x4f2033) while the held-item word 0x583a29 is
 * `held_item` (-1 none). The body must validate. */
int action0c_hover_cursor(const uint8_t *body, size_t body_length, int16_t held_item,
                          Action17Cursor *out);

#ifdef __cplusplus
}
#endif
#endif
