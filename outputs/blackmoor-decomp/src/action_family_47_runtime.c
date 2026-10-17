#include "action_family_47_runtime.h"

#include <string.h>

static int16_t le16(const uint8_t *bytes)
{
    return (int16_t)(uint16_t)(bytes[0] | ((unsigned)bytes[1] << 8));
}

int a47_decode(const uint8_t *raw, size_t raw_bytes, A47Body *out)
{
    if (raw == NULL || out == NULL) {
        return A47_ERR_ARGUMENT;
    }
    if (raw_bytes < A47_BODY_BYTES || memchr(raw + 2, 0, A47_NAME_BYTES) == NULL) {
        return A47_ERR_BODY;
    }
    out->kind = le16(raw);
    memcpy(out->name, raw + 2, A47_NAME_BYTES);
    out->code = le16(raw + 0x23);
    out->value = le16(raw + 0x25);
    return A47_OK;
}

int a47_step(A47Tables *tables, const A47Body *body, A47KeyLookup lookup, void *context, A47Outcome *outcome)
{
    A47Outcome local;
    size_t table, name_bytes;
    int16_t count, entry;
    A47Outcome *o = outcome != NULL ? outcome : &local;

    memset(o, 0, sizeof(*o));
    o->flag_slot = -1;
    o->table = -1;
    o->index = -1;
    if (tables == NULL || body == NULL) {
        return A47_ERR_ARGUMENT;
    }
    if (body->kind < A47_FIRST_KIND || body->kind >= A47_FIRST_KIND + (int)A47_TABLES) {
        return A47_ERR_KIND;
    }
    if (memchr(body->name, 0, sizeof(body->name)) == NULL) {
        return A47_ERR_BODY;
    }
    table = (size_t)(body->kind - A47_FIRST_KIND);
    o->table = (int16_t)table;
    count = tables->count[table];
    if (count < 0 || count > (int16_t)A47_MAX_ENTRIES) {
        return A47_ERR_STATE;
    }
    name_bytes = strlen((const char *)body->name);
    /* 0x4127ba..0x41287a: the loop. An entry with the same name ends the visit; for every other entry the (loop-invariant)
     * AUTOTEXT lookup of the new name runs again, and a miss ends the visit too. */
    for (entry = 0; entry < count; ++entry) {
        int found;
        if (strcmp((const char *)tables->name[table][entry], (const char *)body->name) == 0) {
            o->duplicate = 1;
            return A47_OK;
        }
        if (lookup == NULL) {
            return A47_ERR_UNBOUND;
        }
        found = lookup(context, body->name, name_bytes);
        if (found < 0) {
            return A47_ERR_LOOKUP;
        }
        ++o->lookups;
        if (found == 0) {
            o->lookup_miss = 1;
            return A47_OK;
        }
    }
    if (count == (int16_t)A47_MAX_ENTRIES) {
        return A47_ERR_FULL;
    }
    /* 0x4128ac..: strcpy (the NUL included, the rest of the 33-byte entry keeps what it held), the code word, the link value. */
    memcpy(tables->name[table][count], body->name, name_bytes + 1u);
    tables->code[table][count] = body->code;
    tables->link_value[table][count] = (body->code >= 10 || body->code == 7) ? body->value : (int16_t)A47_NO_LINK;
    o->appended = 1;
    o->index = count;
    tables->count[table] = (int16_t)(count + 1);
    /* 0x412993..0x4129c0: kind 4 -> 0x4e0559(2, 1, 0), kind 3 -> 0x4e0559(2, 1, 1). */
    if (body->kind == 4 || body->kind == 3) {
        const size_t slot = body->kind == 4 ? 0u : 1u;
        tables->page2_any = 1u;
        tables->page2_slot[slot] = 1u;
        o->flag_call = 1;
        o->flag_slot = (int8_t)slot;
    }
    return A47_OK;
}
