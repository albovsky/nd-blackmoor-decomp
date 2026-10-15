#include "action_family_ee.h"

#include <string.h>

static ActionFamilyEEStatus validate_body(
    const uint8_t *raw, size_t length, const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)raw;
    uintptr_t b = (uintptr_t)out;
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_EE_ERR_ARGUMENT;
    }
    /* Span checks cannot establish mappedness of arbitrary caller pointers. */
    if (length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b) {
        return ACTION_FAMILY_EE_ERR_BOUNDS;
    }
    if (length != 0u && a < b + out_length && b < a + length) {
        return ACTION_FAMILY_EE_ERR_OVERLAP;
    }
    if (length < ACTION_FAMILY_EE_BODY_BYTES) {
        return ACTION_FAMILY_EE_ERR_BODY;
    }
    if ((length - ACTION_FAMILY_EE_BODY_BYTES) %
            ACTION_FAMILY_EE_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_EE_ERR_TAIL;
    }
    return ACTION_FAMILY_EE_OK;
}

static void decode_validated(const uint8_t *raw, size_t length,
                             ActionFamilyEEDecoded *d)
{
    memset(d, 0, sizeof(*d));
    for (size_t i = 0u; i < ACTION_FAMILY_EE_WORD_COUNT; ++i) {
        d->word[i] = (uint16_t)((uint16_t)raw[2u * i] |
                              ((uint16_t)raw[2u * i + 1u] << 8));
    }
    d->dependency_records = raw + ACTION_FAMILY_EE_BODY_BYTES;
    d->dependency_bytes = length - ACTION_FAMILY_EE_BODY_BYTES;
    d->dependency_count = d->dependency_bytes / ACTION_FAMILY_EE_DEPENDENCY_BYTES;
    d->body_bytes = ACTION_FAMILY_EE_BODY_BYTES;
    d->available_body_bytes = length;
}

ActionFamilyEEStatus action_family_ee_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyEEDecoded *out)
{
    ActionFamilyEEDecoded decoded;
    ActionFamilyEEStatus status = validate_body(raw_body, raw_body_length,
                                               out, sizeof(*out));
    if (status != ACTION_FAMILY_EE_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_EE_OK;
}

ActionFamilyEEStatus action_family_ee_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes)
{
    ActionFamilyEEStatus status = validate_body(raw_body, raw_body_length,
                                               body_bytes, sizeof(*body_bytes));
    if (status != ACTION_FAMILY_EE_OK) {
        return status;
    }
    *body_bytes = ACTION_FAMILY_EE_BODY_BYTES;
    return ACTION_FAMILY_EE_OK;
}

ActionFamilyEEStatus action_family_ee_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyEEConstructed *out)
{
    ActionFamilyEEDecoded decoded;
    ActionFamilyEEConstructed result;
    ActionFamilyEEStatus status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_EE_ERR_ARGUMENT;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_EE_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&result, 0, sizeof(result));
    /* Entire original allocation is written by REP MOVSD/MOVSW at 0x47b466/0x47b468.
     * Serialize decoded neutral words explicitly, independent of host endian. */
    for (size_t i = 0u; i < ACTION_FAMILY_EE_WORD_COUNT; ++i) {
        result.object_bytes[2u * i] = (uint8_t)decoded.word[i];
        result.object_bytes[2u * i + 1u] = (uint8_t)(decoded.word[i] >> 8);
    }
    result.dependency_records = decoded.dependency_records;
    result.dependency_count = decoded.dependency_count;
    result.dependency_bytes = decoded.dependency_bytes;
    result.body_bytes_consumed = decoded.body_bytes;
    result.available_body_bytes = raw_body_length;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + UINT32_C(5826); /* ADD 0x16c2, wraps */
    result.result_slot_handle = output_handle;
    result.allocation_bytes = ACTION_FAMILY_EE_OBJECT_BYTES;
    result.raw_type = ACTION_FAMILY_EE_RAW_TYPE;
    result.runtime_type = ACTION_FAMILY_EE_RUNTIME_TYPE;
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_EE_OK;
}
