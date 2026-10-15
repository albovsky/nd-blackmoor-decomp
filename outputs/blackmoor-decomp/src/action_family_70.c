#include "action_family_70.h"

#include <string.h>

static ActionFamily70Status validate_body(
    const uint8_t *raw, size_t length, const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)raw;
    uintptr_t b = (uintptr_t)out;
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_70_ERR_ARGUMENT;
    }
    /* Span checks cannot establish mappedness of arbitrary caller pointers. */
    if (length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b) {
        return ACTION_FAMILY_70_ERR_BOUNDS;
    }
    if (length != 0u && a < b + out_length && b < a + length) {
        return ACTION_FAMILY_70_ERR_OVERLAP;
    }
    if (length < ACTION_FAMILY_70_BODY_BYTES) {
        return ACTION_FAMILY_70_ERR_BODY;
    }
    if ((length - ACTION_FAMILY_70_BODY_BYTES) %
            ACTION_FAMILY_70_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_70_ERR_TAIL;
    }
    return ACTION_FAMILY_70_OK;
}

static void decode_validated(const uint8_t *raw, size_t length,
                             ActionFamily70Decoded *d)
{
    memset(d, 0, sizeof(*d));
    d->byte_0 = raw[0];
    d->dependency_records = raw + ACTION_FAMILY_70_BODY_BYTES;
    d->dependency_bytes = length - ACTION_FAMILY_70_BODY_BYTES;
    d->dependency_count = d->dependency_bytes / ACTION_FAMILY_70_DEPENDENCY_BYTES;
    d->body_bytes = ACTION_FAMILY_70_BODY_BYTES;
    d->available_body_bytes = length;
}

ActionFamily70Status action_family_70_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily70Decoded *out)
{
    ActionFamily70Decoded decoded;
    ActionFamily70Status status = validate_body(raw_body, raw_body_length,
                                               out, sizeof(*out));
    if (status != ACTION_FAMILY_70_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_70_OK;
}

ActionFamily70Status action_family_70_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes)
{
    ActionFamily70Status status = validate_body(raw_body, raw_body_length,
                                               body_bytes, sizeof(*body_bytes));
    if (status != ACTION_FAMILY_70_OK) {
        return status;
    }
    *body_bytes = ACTION_FAMILY_70_BODY_BYTES;
    return ACTION_FAMILY_70_OK;
}

ActionFamily70Status action_family_70_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily70Constructed *out)
{
    ActionFamily70Decoded decoded;
    ActionFamily70Constructed result;
    ActionFamily70Status status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_70_ERR_ARGUMENT;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_70_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&result, 0, sizeof(result));
    /* The entire original allocation is the single byte written by the
     * MOV BYTE PTR [EAX], DL at 0x40e467. */
    result.object_bytes[0] = decoded.byte_0;
    result.dependency_records = decoded.dependency_records;
    result.dependency_count = decoded.dependency_count;
    result.dependency_bytes = decoded.dependency_bytes;
    result.body_bytes_consumed = decoded.body_bytes;
    result.available_body_bytes = raw_body_length;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + UINT32_C(1); /* ADD 1 at 0x40e46f, wraps */
    result.result_slot_handle = output_handle;
    result.allocation_bytes = ACTION_FAMILY_70_OBJECT_BYTES;
    result.raw_type = ACTION_FAMILY_70_RAW_TYPE;
    result.runtime_type = ACTION_FAMILY_70_RUNTIME_TYPE;
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_70_OK;
}
