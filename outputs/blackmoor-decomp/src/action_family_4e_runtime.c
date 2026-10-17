#include "action_family_4e_runtime.h"

#include <math.h>
#include <string.h>

#define PERCENT_DIVISOR 100.0
#define UNSET_SHORT 9999
#define UNSET_FLOAT 9999.0f

/* a / 100 * slot, with the x87 rounding of 0x44b4ef..0x44b534 (fdiv, fmul in 53 bits, then fstp to float). */
static float scaled(int16_t amount, double slot)
{
    return (float)(((double)(float)amount / PERCENT_DIVISOR) * slot);
}

ActionFamily4EStatus action_family_4e_runtime_visit(const ActionFamily4EDecoded *decoded, ActionCoreWorld *world,
                                                    ActionFamily4ERuntimeOutcome *outcome)
{
    ActionFamily4ERuntimeOutcome local;
    ActionFamily4ERuntimeOutcome *o = outcome != NULL ? outcome : &local;
    float *target;
    size_t i;

    memset(o, 0, sizeof(*o));
    if (decoded == NULL || world == NULL) {
        return ACTION_FAMILY_4E_ERR_ARGUMENT;
    }
    if (decoded->option_00 < ACTION_FAMILY_4E_FIRST_TARGET || decoded->option_00 > ACTION_FAMILY_4E_LAST_TARGET) {
        return ACTION_FAMILY_4E_OK;   /* 0x44b3eb..0x44b3fa; the debug report needs the flag 0x63a4cd, modelled as 0 */
    }
    o->target_valid = 1u;
    target = &world->float_values[decoded->option_00 - ACTION_FAMILY_4E_FIRST_TARGET];
    *target = 0.0f;
    for (i = 0u; i < ACTION_FAMILY_4E_ENTRY_COUNT; ++i) {
        const uint8_t selector = decoded->entries[i].option_00;
        const int16_t amount = (int16_t)decoded->entries[i].word_0;
        float term;

        if (selector == ACTION_FAMILY_4E_SELECTOR_SKIP) {
            continue;
        }
        if (selector < ACTION_CORE_SHORT_SLOT_COUNT) {
            const int16_t slot = world->short_values[selector];
            if (slot == UNSET_SHORT) {
                term = 0.0f;
                ++o->unset_terms;
            } else {
                term = scaled(amount, (double)(float)slot);
            }
        } else if (selector <= ACTION_FAMILY_4E_LAST_TARGET) {
            const float slot = world->float_values[selector - ACTION_CORE_SHORT_SLOT_COUNT];
            if (slot == UNSET_FLOAT || isnan(slot)) {
                term = 0.0f;
                ++o->unset_terms;
            } else {
                term = scaled(amount, (double)slot);
            }
        } else if (selector == ACTION_FAMILY_4E_SELECTOR_LITERAL) {
            term = (float)amount;
        } else {
            o->report_selector[o->reports++] = selector;
            term = 0.0f;
        }
        ++o->terms_added;
        *target = (float)((double)term + (double)*target);
    }
    return ACTION_FAMILY_4E_OK;
}
