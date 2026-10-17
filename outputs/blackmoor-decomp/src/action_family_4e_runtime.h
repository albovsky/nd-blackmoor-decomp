#ifndef BLACKMOOR_ACTION_FAMILY_4E_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_4E_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_core.h"
#include "action_family_4e.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x4e, "recompute a float value from percentages of other values" (RT-44).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x44b102  loader: 31-byte copy (action_family_4e.h): target byte, then ten (selector byte, signed amount word) triples.
 *   0x427a50  dispatcher arm 0x4280f9 (type 0x4e, gate mode 1): gate 0x423f57(deps, 1), then 0x44b3c8(ECX = 0x637fb1, row).
 *   0x44b3c8  target = body[0]; a target outside 30..39 (the ten float value slots) changes nothing (with the debug flag
 *             0x63a4cd set it would log and report through 0x52139c first). Otherwise float slot target = 0.0f, then for each of
 *             the ten triples (selector s, amount a), in order:
 *               s == 99    no term
 *               s <= 29    int16 slot s: 9999 (unset) gives term 0, else term = a / 100 * slot
 *               s <= 39    float slot s: bit-equal to 9999.0f (or NaN: the x87 compare is unordered) gives term 0, else
 *                          term = a / 100 * slot
 *               s == 100   term = a
 *               otherwise  report "AT_SET_VALUE_COMBO, index out of range for value to combine" through 0x52139c, term 0
 *             and float slot target = float(term + slot target). The x87 runs at 53-bit precision (control word 0x27f): a and
 *             the slot values are converted to float, a / 100 and the product are rounded to double, the term is stored as a
 *             float, and the sum is rounded to double and stored as a float. The slot is re-read for every triple, so a triple
 *             may name the target itself.
 *             Every path ends with the generic completion 0x42ba3a(row).
 * Nothing here claims original source structure. */

typedef struct ActionFamily4ERuntimeOutcome {
    uint8_t target_valid;     /* body[0] was in 30..39 */
    uint8_t terms_added;      /* triples that added a term (selector other than 99) */
    uint8_t unset_terms;      /* terms that were 0 because the named slot was unset (9999) */
    uint8_t reports;          /* out-of-range selectors reported through 0x52139c */
    uint8_t report_selector[ACTION_FAMILY_4E_ENTRY_COUNT];
} ActionFamily4ERuntimeOutcome;

#define ACTION_FAMILY_4E_FIRST_TARGET 30u
#define ACTION_FAMILY_4E_LAST_TARGET 39u
#define ACTION_FAMILY_4E_SELECTOR_SKIP 99u
#define ACTION_FAMILY_4E_SELECTOR_LITERAL 100u

/* One true-gate visit of 0x44b3c8 up to 0x42ba3a (which the executor performs). Only world->float_values[target - 30] can
 * change. Returns ACTION_FAMILY_4E_OK, or ACTION_FAMILY_4E_ERR_ARGUMENT for a null argument. */
ActionFamily4EStatus action_family_4e_runtime_visit(const ActionFamily4EDecoded *decoded, ActionCoreWorld *world,
                                                    ActionFamily4ERuntimeOutcome *outcome);

#ifdef __cplusplus
}
#endif
#endif
