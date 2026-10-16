#ifndef BLACKMOOR_ACTION_FAMILY_4F_H
#define BLACKMOOR_ACTION_FAMILY_4F_H

#include <stddef.h>
#include <stdint.h>

#include "action_core.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Raw action 0x4f, "compare a value, set an event flag" (RT-27).
 *
 * Loader 0x44b1b4 copies 10 bytes. Dispatcher arm 0x428133 of 0x427a50, after the dependency gate 0x423f57(deps, 1) is
 * true, calls 0x44b641(row) on the object at 0x637fb1, which ends in the generic completion 0x42ba3a(row) (the executor
 * performs that: COMPLETED, phase 0). 0x44b641 reads the action values the world initializer 0x44aff2 fills with 9999
 * (30 int16 at 0x58c959, then 10 float32 at 0x58c995) and, when its test holds, stores 1 in the event flag table
 * (dword at 0x585801 + 4 * flag):
 *
 *   body[0] attribute A   0..29 int16 slot, 30..39 float slot, anything above is skipped (no flag)
 *   body[1] mode          0 = A against any other float slot, 1 = A against any int16 slot, 2 = A against the slots
 *                         named by body[3..7], 3 = A against the literals body[3..7] (other modes: no flag)
 *   body[2] operator      0 ==, 1 <, 2 >, 3 >=, 4 <= ; modes 3 only: 5 ==, 6 >=, 7 <= against body[3] * body[4] / 100
 *   body[3..7]            operands (99 = unused in modes 2 and 3)
 *   body[8..9]            int16 event flag index, -1 = none
 *
 * A value equal to the 9999.0f sentinel bits (an unset slot) never takes part: if A itself is unset the row sets no
 * flag; unset comparison slots are skipped. Comparisons are x87 fcomp of float32 values (an unordered pair counts as
 * C0 and C3 set, so NaN satisfies ==, < and <=, never > or >=). The scan stops at the first match; the flag is only
 * ever set, never cleared.
 *
 * Differences from the original (all explicit, none reached by the 815 corpus rows, which are all mode 3, operators
 * 0 to 3):
 *  - modes 0 and 1 with operators 3/4 read the comparison literal at body[3 + slot index], which leaves the 10-byte
 *    body for slot 7 of mode 1 and for every slot of mode 0, and mode 2 with an operator up to 4 and an operand above 39
 *    (other than 99) reads past the value tables (a larger operator skips the compare, so it runs as the original does): those reads are refused (ERR_UNSUPPORTED) before any state change;
 *  - an event flag index below -1 or beyond the caller's table is refused (ERR_BOUNDS) before any state change (the
 *    original writes through the index unchecked);
 *  - with the debug flag 0x63a4cd set the original logs and aborts on an attribute above 39 or an unset attribute; the
 *    native kernel models the flag as 0 (the shipped default). */

#define ACTION_FAMILY_4F_RAW_TYPE UINT8_C(0x4f)
#define ACTION_FAMILY_4F_BODY_BYTES 10u
#define ACTION_FAMILY_4F_OPERAND_COUNT 5u

typedef enum {
    ACTION_FAMILY_4F_OK = 0,
    ACTION_FAMILY_4F_ERR_ARGUMENT = 1,
    ACTION_FAMILY_4F_ERR_BODY = 2,
    /* The test held but the event flag index is outside the caller's table; nothing was changed. */
    ACTION_FAMILY_4F_ERR_BOUNDS = 3,
    /* The original would read outside the body or the value tables; nothing was changed. */
    ACTION_FAMILY_4F_ERR_UNSUPPORTED = 4
} ActionFamily4FStatus;

typedef struct {
    uint8_t attribute;
    uint8_t mode;
    uint8_t op;
    uint8_t operand[ACTION_FAMILY_4F_OPERAND_COUNT];
    int16_t flag; /* -1 = none */
    uint8_t raw[ACTION_FAMILY_4F_BODY_BYTES];
} ActionFamily4FDecoded;

typedef struct {
    uint8_t evaluated; /* attribute in range and set, mode 0..3 */
    uint8_t found;     /* the test held */
    uint8_t flag_set;  /* an event flag was written */
} ActionFamily4FResult;

/* Reads the fixed 10-byte typed body (the dependency tail is not part of it). */
ActionFamily4FStatus action_family_4f_decode(const uint8_t *body, size_t length, ActionFamily4FDecoded *out);

/* One true-gate visit of 0x44b641 up to 0x42ba3a (which the executor performs). `world` supplies the 30 + 10 values
 * and the event flag table; only event_flags[flag] can change. */
ActionFamily4FStatus action_family_4f_visit(const ActionFamily4FDecoded *decoded, ActionCoreWorld *world,
                                            ActionFamily4FResult *result);

#ifdef __cplusplus
}
#endif
#endif
