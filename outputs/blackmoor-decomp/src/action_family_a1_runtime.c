#include "action_family_a1_runtime.h"

#include <string.h>

/* 0x5408dc, the format the loader hands to sprintf (0x50ca3e) when 0x423259 finds no key;
 * the key is the NUL-terminated copy of the 33-byte field at body+0x33. The loader's
 * ordinary end marker "<e>" is appended afterwards (0x40f253). */
#define MISSING_PREFIX "Game Error (please contact Tech Support) missing auto text: "
#define MISSING_SUFFIX "<n>"

static size_t visible_length(const uint8_t *text, size_t bytes)
{
    size_t i;
    for (i = 0u; i < bytes && text[i] != 0u; ++i) {
    }
    return i;
}

int action_a1_runtime_construct(const uint8_t *typed_body, size_t typed_body_length,
                                ActionFamily97AutoTextLookup lookup, void *lookup_context,
                                ActionA1Object *out)
{
    ActionFamilyA1Decoded decoded;
    ActionFamilyA1Constructed built;
    uint8_t fallback[sizeof(MISSING_PREFIX) + ACTION_FAMILY_A1_PREFIX_BYTES + sizeof(MISSING_SUFFIX)];
    const uint8_t *resolved = NULL;
    size_t resolved_bytes = 0u;
    int missing = 0;
    int status;

    if (typed_body == NULL || out == NULL) {
        return ACTION_A1_RT_ERR_ARGUMENT;
    }
    if (action_family_a1_decode(typed_body, typed_body_length, &decoded) != ACTION_FAMILY_A1_OK ||
        decoded.dependency_bytes != 0u) {
        return ACTION_A1_RT_ERR_BODY;
    }
    if (decoded.text_selector == -1) {
        size_t key_bytes = visible_length(decoded.text_key, sizeof(decoded.text_key));
        const uint8_t *text = NULL;
        size_t text_bytes = 0u;
        ActionFamily97LookupStatus found;

        if (lookup == NULL) {
            return ACTION_A1_RT_ERR_LOOKUP;
        }
        found = lookup(lookup_context, decoded.text_key, key_bytes, &text, &text_bytes);
        if (found == ACTION_FAMILY_97_LOOKUP_FOUND) {
            if (text == NULL && text_bytes != 0u) {
                return ACTION_A1_RT_ERR_LOOKUP;
            }
            resolved = text;
            resolved_bytes = text_bytes == 0u ? 0u : visible_length(text, text_bytes);
        } else if (found == ACTION_FAMILY_97_LOOKUP_MISSING) {
            size_t prefix = sizeof(MISSING_PREFIX) - 1u;
            memcpy(fallback, MISSING_PREFIX, prefix);
            memcpy(fallback + prefix, decoded.text_key, key_bytes);
            memcpy(fallback + prefix + key_bytes, MISSING_SUFFIX, sizeof(MISSING_SUFFIX) - 1u);
            resolved = fallback;
            resolved_bytes = prefix + key_bytes + sizeof(MISSING_SUFFIX) - 1u;
            missing = 1;
        } else {
            return ACTION_A1_RT_ERR_LOOKUP;
        }
    }
    status = (int)action_family_a1_construct(typed_body, typed_body_length, resolved,
                                             resolved_bytes, 50u, 1u, &built);
    if (status != ACTION_FAMILY_A1_OK) {
        return status == ACTION_FAMILY_A1_ERR_TEXT ? ACTION_A1_RT_ERR_TEXT
                                                   : ACTION_A1_RT_ERR_BODY;
    }
    memset(out, 0, sizeof(*out));
    memcpy(out->bytes, built.object_bytes, built.allocation_bytes);
    out->length = built.allocation_bytes;
    out->key_missing = (uint8_t)missing;
    return ACTION_A1_RT_OK;
}
