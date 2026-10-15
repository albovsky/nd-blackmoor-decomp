#include "action_family_65.h"

#include <string.h>

static ActionFamily65Status validate_body(
    const uint8_t *raw, size_t length, const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)raw;
    uintptr_t b = (uintptr_t)out;
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_65_ERR_ARGUMENT;
    }
    /* Validate arithmetic before either reading input or writing output.
     * This cannot establish mappedness of arbitrary caller addresses. */
    if (length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b) {
        return ACTION_FAMILY_65_ERR_BOUNDS;
    }
    if (length != 0u && a < b + out_length && b < a + length) {
        return ACTION_FAMILY_65_ERR_OVERLAP;
    }
    if (length < ACTION_FAMILY_65_BODY_BYTES) {
        return ACTION_FAMILY_65_ERR_BODY;
    }
    if ((length - ACTION_FAMILY_65_BODY_BYTES) %
            ACTION_FAMILY_65_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_65_ERR_TAIL;
    }
    return ACTION_FAMILY_65_OK;
}

static void decode_validated(const uint8_t *raw, size_t length,
                             ActionFamily65Decoded *d)
{
    memset(d, 0, sizeof(*d));
    d->option_00 = raw[0u];
    d->dependency_records = raw + ACTION_FAMILY_65_BODY_BYTES;
    d->dependency_bytes = length - ACTION_FAMILY_65_BODY_BYTES;
    d->dependency_count = d->dependency_bytes / ACTION_FAMILY_65_DEPENDENCY_BYTES;
    d->body_bytes = ACTION_FAMILY_65_BODY_BYTES;
    d->available_body_bytes = length;
}

ActionFamily65Status action_family_65_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily65Decoded *out)
{
    ActionFamily65Decoded decoded;
    ActionFamily65Status status = validate_body(raw_body, raw_body_length,
                                               out, sizeof(*out));
    if (status != ACTION_FAMILY_65_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_65_OK;
}

ActionFamily65Status action_family_65_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily65Constructed *out)
{
    ActionFamily65Decoded decoded;
    ActionFamily65Constructed result;
    ActionFamily65Status status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_65_ERR_ARGUMENT;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_65_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&result, 0, sizeof(result));
    /* MOV CL,[EAX]; MOV [EDX],CL at 0x40d1a1..0x40d1a3. */
    result.object_bytes[0u] = decoded.option_00;
    result.dependency_records = decoded.dependency_records;
    result.dependency_count = decoded.dependency_count;
    result.dependency_bytes = decoded.dependency_bytes;
    result.body_bytes_consumed = decoded.body_bytes;
    result.available_body_bytes = raw_body_length;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;
    result.result_slot_handle = output_handle;
    result.allocation_bytes = ACTION_FAMILY_65_OBJECT_BYTES;
    result.raw_type = ACTION_FAMILY_65_RAW_TYPE;
    result.runtime_type = ACTION_FAMILY_65_RUNTIME_TYPE;
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_65_OK;
}

ActionFamily65Status action_family_65_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out_body_length)
{
    const size_t typed_length = ACTION_FAMILY_65_BODY_BYTES;
    ActionFamily65Status status = validate_body(raw_body, raw_body_length,
                                               out_body_length, sizeof(*out_body_length));
    if (status != ACTION_FAMILY_65_OK) {
        return status;
    }
    memcpy(out_body_length, &typed_length, sizeof(typed_length));
    return ACTION_FAMILY_65_OK;
}
