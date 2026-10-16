#include "action_family_4f.h"

#include <string.h>

#define SENTINEL_BITS UINT32_C(0x461c3c00) /* 9999.0f, the unset value */
#define ATTRIBUTE_COUNT 40u                /* 30 int16 + 10 float32 */
#define LAST_SHORT_SLOT 29u

static int is_sentinel(float value)
{
    uint32_t bits;
    memcpy(&bits, &value, sizeof bits);
    return bits == SENTINEL_BITS;
}

static float slot_value(const ActionCoreWorld *world, unsigned slot)
{
    if (slot <= LAST_SHORT_SLOT) {
        return (float)world->short_values[slot];
    }
    return world->float_values[slot - ACTION_CORE_SHORT_SLOT_COUNT];
}

/* x87 fcomp of st0 = left against right: C0 for left < right, C3 for equal, both for unordered. */
static int compare_holds(unsigned op, float left, float right)
{
    int c0, c3;
    if (left != left || right != right) {
        c0 = 1;
        c3 = 1;
    } else {
        c0 = left < right;
        c3 = left == right;
    }
    switch (op) {
    case 0: case 5: return c3;
    case 1: return c0;
    case 2: return !(c0 || c3);
    case 3: case 6: return !c0;
    default: return c0 || c3; /* 4, 7 */
    }
}

ActionFamily4FStatus action_family_4f_decode(const uint8_t *body, size_t length, ActionFamily4FDecoded *out)
{
    unsigned k;
    if (body == NULL || out == NULL) {
        return ACTION_FAMILY_4F_ERR_ARGUMENT;
    }
    if (length < ACTION_FAMILY_4F_BODY_BYTES) {
        return ACTION_FAMILY_4F_ERR_BODY;
    }
    memcpy(out->raw, body, ACTION_FAMILY_4F_BODY_BYTES);
    out->attribute = body[0];
    out->mode = body[1];
    out->op = body[2];
    for (k = 0; k < ACTION_FAMILY_4F_OPERAND_COUNT; ++k) {
        out->operand[k] = body[3u + k];
    }
    out->flag = (int16_t)((uint16_t)body[8] | ((uint16_t)body[9] << 8));
    return ACTION_FAMILY_4F_OK;
}

/* Modes 0 and 1: scan slots first..last (the attribute's own slot and unset slots are skipped); operators 3 and 4
 * compare against the byte body[3 + slot], which leaves the body from index 10. */
static ActionFamily4FStatus scan_slots(const ActionFamily4FDecoded *d, const ActionCoreWorld *world, float current,
                                       unsigned first, unsigned last, int *found)
{
    unsigned slot;
    for (slot = first; slot <= last && !*found; ++slot) {
        float other = slot_value(world, slot);
        if (is_sentinel(other) || slot == d->attribute) {
            continue;
        }
        if (d->op > 4u) {
            continue;
        }
        if (d->op >= 3u) {
            unsigned offset = 3u + slot;
            if (offset >= ACTION_FAMILY_4F_BODY_BYTES) {
                return ACTION_FAMILY_4F_ERR_UNSUPPORTED;
            }
            other = (float)d->raw[offset];
        }
        if (compare_holds(d->op, current, other)) {
            *found = 1;
        }
    }
    return ACTION_FAMILY_4F_OK;
}

ActionFamily4FStatus action_family_4f_visit(const ActionFamily4FDecoded *decoded, ActionCoreWorld *world,
                                            ActionFamily4FResult *result)
{
    ActionFamily4FStatus status = ACTION_FAMILY_4F_OK;
    ActionFamily4FResult local;
    float current;
    int found = 0;
    unsigned i;

    if (decoded == NULL || world == NULL) {
        return ACTION_FAMILY_4F_ERR_ARGUMENT;
    }
    memset(&local, 0, sizeof local);
    if (result != NULL) {
        memset(result, 0, sizeof *result);
    }
    if (decoded->attribute >= ATTRIBUTE_COUNT) {
        return ACTION_FAMILY_4F_OK;
    }
    current = slot_value(world, decoded->attribute);
    if (is_sentinel(current)) {
        return ACTION_FAMILY_4F_OK;
    }
    switch (decoded->mode) {
    case 0:
        local.evaluated = 1;
        status = scan_slots(decoded, world, current, ACTION_CORE_SHORT_SLOT_COUNT, ATTRIBUTE_COUNT - 1u, &found);
        break;
    case 1:
        local.evaluated = 1;
        status = scan_slots(decoded, world, current, 0u, LAST_SHORT_SLOT, &found);
        break;
    case 2:
        local.evaluated = 1;
        for (i = 0; i < ACTION_FAMILY_4F_OPERAND_COUNT && !found; ++i) {
            unsigned slot = decoded->operand[i];
            float other;
            if (slot == 99u) {
                continue;
            }
            if (decoded->op > 4u) {
                continue; /* the original loads the value, then skips the compare */
            }
            if (slot >= ATTRIBUTE_COUNT) {
                status = ACTION_FAMILY_4F_ERR_UNSUPPORTED;
                break;
            }
            other = slot_value(world, slot);
            if (is_sentinel(other)) {
                continue;
            }
            found = compare_holds(decoded->op, current, other);
        }
        break;
    case 3:
        local.evaluated = 1;
        for (i = 0; i < ACTION_FAMILY_4F_OPERAND_COUNT && !found; ++i) {
            if (decoded->operand[i] == 99u || decoded->op > 7u) {
                continue;
            }
            if (decoded->op <= 4u) {
                found = compare_holds(decoded->op, current, (float)decoded->operand[i]);
            } else if (i == 0u) {
                /* fld b3, fmul b4, fdiv 100.0f (53-bit precision control), fstp float; the scan ends here. */
                volatile double quotient = ((double)decoded->operand[0] * (double)decoded->operand[1]) / 100.0;
                found = compare_holds(decoded->op, current, (float)quotient);
                break;
            }
        }
        break;
    default:
        break;
    }
    if (status != ACTION_FAMILY_4F_OK) {
        return status;
    }
    if (found && decoded->flag != -1) {
        if (decoded->flag < 0 || world->event_flags == NULL || (size_t)decoded->flag >= world->event_flag_count) {
            return ACTION_FAMILY_4F_ERR_BOUNDS;
        }
        world->event_flags[decoded->flag] = 1;
        local.flag_set = 1;
    }
    local.found = (uint8_t)(found != 0);
    if (result != NULL) {
        *result = local;
    }
    return ACTION_FAMILY_4F_OK;
}
