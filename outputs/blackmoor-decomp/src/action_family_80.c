#include "action_family_80.h"

#include <string.h>

static ActionFamily80Status validate_body(
    const uint8_t *raw, size_t length, const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)raw;
    uintptr_t b = (uintptr_t)out;
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_80_ERR_ARGUMENT;
    }
    /* Span checks cannot establish mappedness of arbitrary caller pointers. */
    if (length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b) {
        return ACTION_FAMILY_80_ERR_BOUNDS;
    }
    if (length != 0u && a < b + out_length && b < a + length) {
        return ACTION_FAMILY_80_ERR_OVERLAP;
    }
    if (length < ACTION_FAMILY_80_BODY_BYTES) {
        return ACTION_FAMILY_80_ERR_BODY;
    }
    if ((length - ACTION_FAMILY_80_BODY_BYTES) %
            ACTION_FAMILY_80_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_80_ERR_TAIL;
    }
    return ACTION_FAMILY_80_OK;
}

static void decode_validated(const uint8_t *raw, size_t length,
                             ActionFamily80Decoded *d)
{
    memset(d, 0, sizeof(*d));
    d->word_0 = (uint16_t)((uint16_t)raw[0] | ((uint16_t)raw[1] << 8));
    d->dependency_records = raw + ACTION_FAMILY_80_BODY_BYTES;
    d->dependency_bytes = length - ACTION_FAMILY_80_BODY_BYTES;
    d->dependency_count = d->dependency_bytes / ACTION_FAMILY_80_DEPENDENCY_BYTES;
    d->body_bytes = ACTION_FAMILY_80_BODY_BYTES;
    d->available_body_bytes = length;
}

ActionFamily80Status action_family_80_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily80Decoded *out)
{
    ActionFamily80Decoded decoded;
    ActionFamily80Status status = validate_body(raw_body, raw_body_length,
                                               out, sizeof(*out));
    if (status != ACTION_FAMILY_80_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_80_OK;
}

ActionFamily80Status action_family_80_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes)
{
    ActionFamily80Status status = validate_body(raw_body, raw_body_length,
                                               body_bytes, sizeof(*body_bytes));
    if (status != ACTION_FAMILY_80_OK) {
        return status;
    }
    *body_bytes = ACTION_FAMILY_80_BODY_BYTES;
    return ACTION_FAMILY_80_OK;
}

ActionFamily80Status action_family_80_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily80Constructed *out)
{
    ActionFamily80Decoded decoded;
    ActionFamily80Constructed result;
    ActionFamily80Status status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_80_ERR_ARGUMENT;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_80_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&result, 0, sizeof(result));
    /* The original allocation is the 2-byte WORD copy at 0x40e7ca/0x40e7cd.
     * Serialize the decoded neutral word explicitly, independent of host endian. */
    result.object_bytes[0] = (uint8_t)decoded.word_0;
    result.object_bytes[1] = (uint8_t)(decoded.word_0 >> 8);
    result.dependency_records = decoded.dependency_records;
    result.dependency_count = decoded.dependency_count;
    result.dependency_bytes = decoded.dependency_bytes;
    result.body_bytes_consumed = decoded.body_bytes;
    result.available_body_bytes = raw_body_length;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + UINT32_C(2); /* ADD 2, wraps */
    result.result_slot_handle = output_handle;
    result.allocation_bytes = ACTION_FAMILY_80_OBJECT_BYTES;
    result.raw_type = ACTION_FAMILY_80_RAW_TYPE;
    result.runtime_type = ACTION_FAMILY_80_RUNTIME_TYPE;
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_80_OK;
}
