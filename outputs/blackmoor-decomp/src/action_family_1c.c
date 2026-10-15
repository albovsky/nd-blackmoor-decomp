#include "action_family_1c.h"

#include <string.h>

static ActionFamily1cStatus validate_body(
    const uint8_t *raw, size_t length, const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)raw;
    uintptr_t b = (uintptr_t)out;
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_1C_ERR_ARGUMENT;
    }
    /* Span checks cannot establish mappedness of arbitrary caller pointers. */
    if (length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b) {
        return ACTION_FAMILY_1C_ERR_BOUNDS;
    }
    if (length != 0u && a < b + out_length && b < a + length) {
        return ACTION_FAMILY_1C_ERR_OVERLAP;
    }
    if (length < ACTION_FAMILY_1C_BODY_BYTES) {
        return ACTION_FAMILY_1C_ERR_BODY;
    }
    if ((length - ACTION_FAMILY_1C_BODY_BYTES) %
            ACTION_FAMILY_1C_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_1C_ERR_TAIL;
    }
    return ACTION_FAMILY_1C_OK;
}

static void decode_validated(const uint8_t *raw, size_t length,
                             ActionFamily1cDecoded *d)
{
    memset(d, 0, sizeof(*d));
    for (size_t i = 0u; i < ACTION_FAMILY_1C_WORD_COUNT; ++i) {
        d->word[i] = (uint16_t)((uint16_t)raw[2u * i] |
                              ((uint16_t)raw[2u * i + 1u] << 8));
    }
    d->byte_104 = raw[2u * ACTION_FAMILY_1C_WORD_COUNT];
    d->dependency_records = raw + ACTION_FAMILY_1C_BODY_BYTES;
    d->dependency_bytes = length - ACTION_FAMILY_1C_BODY_BYTES;
    d->dependency_count = d->dependency_bytes / ACTION_FAMILY_1C_DEPENDENCY_BYTES;
    d->body_bytes = ACTION_FAMILY_1C_BODY_BYTES;
    d->available_body_bytes = length;
}

ActionFamily1cStatus action_family_1c_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily1cDecoded *out)
{
    ActionFamily1cDecoded decoded;
    ActionFamily1cStatus status = validate_body(raw_body, raw_body_length,
                                               out, sizeof(*out));
    if (status != ACTION_FAMILY_1C_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_1C_OK;
}

ActionFamily1cStatus action_family_1c_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes)
{
    ActionFamily1cStatus status = validate_body(raw_body, raw_body_length,
                                               body_bytes, sizeof(*body_bytes));
    if (status != ACTION_FAMILY_1C_OK) {
        return status;
    }
    *body_bytes = ACTION_FAMILY_1C_BODY_BYTES;
    return ACTION_FAMILY_1C_OK;
}

ActionFamily1cStatus action_family_1c_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily1cConstructed *out)
{
    ActionFamily1cDecoded decoded;
    ActionFamily1cConstructed result;
    ActionFamily1cStatus status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_1C_ERR_ARGUMENT;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_1C_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&result, 0, sizeof(result));
    /* FUN_004cc70f zero-fills the 0x69-byte block (REP STOSD x26 + STOSB at
     * 0x4cc78a/0x4cc791), then REP MOVSD x26 + MOVSB at 0x4cb01b/0x4cb01d
     * overwrite all 105 bytes. Serialize decoded neutral words explicitly,
     * independent of host endian. */
    for (size_t i = 0u; i < ACTION_FAMILY_1C_WORD_COUNT; ++i) {
        result.object_bytes[2u * i] = (uint8_t)decoded.word[i];
        result.object_bytes[2u * i + 1u] = (uint8_t)(decoded.word[i] >> 8);
    }
    result.object_bytes[2u * ACTION_FAMILY_1C_WORD_COUNT] = decoded.byte_104;
    result.dependency_records = decoded.dependency_records;
    result.dependency_count = decoded.dependency_count;
    result.dependency_bytes = decoded.dependency_bytes;
    result.body_bytes_consumed = decoded.body_bytes;
    result.available_body_bytes = raw_body_length;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + UINT32_C(105); /* ADD 0x69, wraps */
    result.result_slot_handle = output_handle;
    result.allocation_bytes = ACTION_FAMILY_1C_OBJECT_BYTES;
    result.raw_type = ACTION_FAMILY_1C_RAW_TYPE;
    result.runtime_type = ACTION_FAMILY_1C_RUNTIME_TYPE;
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_1C_OK;
}
