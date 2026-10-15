#include "action_family_7d.h"

#include <string.h>

static ActionFamily7dStatus validate_body(
    const uint8_t *raw, size_t length, const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)raw;
    uintptr_t b = (uintptr_t)out;
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_7D_ERR_ARGUMENT;
    }
    /* Validate arithmetic before either reading input or writing output.
     * This cannot establish mappedness of arbitrary caller addresses. */
    if (length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b) {
        return ACTION_FAMILY_7D_ERR_BOUNDS;
    }
    if (length != 0u && a < b + out_length && b < a + length) {
        return ACTION_FAMILY_7D_ERR_OVERLAP;
    }
    if (length < ACTION_FAMILY_7D_BODY_BYTES) {
        return ACTION_FAMILY_7D_ERR_BODY;
    }
    if ((length - ACTION_FAMILY_7D_BODY_BYTES) %
            ACTION_FAMILY_7D_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_7D_ERR_TAIL;
    }
    return ACTION_FAMILY_7D_OK;
}

static void decode_validated(const uint8_t *raw, size_t length,
                             ActionFamily7dDecoded *d)
{
    memset(d, 0, sizeof(*d));
    d->option_00 = raw[0u];
    d->dependency_records = raw + ACTION_FAMILY_7D_BODY_BYTES;
    d->dependency_bytes = length - ACTION_FAMILY_7D_BODY_BYTES;
    d->dependency_count = d->dependency_bytes / ACTION_FAMILY_7D_DEPENDENCY_BYTES;
    d->body_bytes = ACTION_FAMILY_7D_BODY_BYTES;
    d->available_body_bytes = length;
}

ActionFamily7dStatus action_family_7d_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily7dDecoded *out)
{
    ActionFamily7dDecoded decoded;
    ActionFamily7dStatus status = validate_body(raw_body, raw_body_length,
                                               out, sizeof(*out));
    if (status != ACTION_FAMILY_7D_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_7D_OK;
}

ActionFamily7dStatus action_family_7d_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out)
{
    const size_t body_bytes = ACTION_FAMILY_7D_BODY_BYTES;
    ActionFamily7dStatus status = validate_body(raw_body, raw_body_length,
                                               out, sizeof(*out));
    if (status != ACTION_FAMILY_7D_OK) {
        return status;
    }
    memcpy(out, &body_bytes, sizeof(body_bytes));
    return ACTION_FAMILY_7D_OK;
}

ActionFamily7dStatus action_family_7d_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily7dConstructed *out)
{
    ActionFamily7dDecoded decoded;
    ActionFamily7dConstructed result;
    ActionFamily7dStatus status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_7D_ERR_ARGUMENT;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_7D_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&result, 0, sizeof(result));
    /* MOV DL,[ECX]; MOV [EAX],DL at 0x40e6aa..0x40e6ac. */
    result.object_bytes[0u] = decoded.option_00;
    result.dependency_records = decoded.dependency_records;
    result.dependency_count = decoded.dependency_count;
    result.dependency_bytes = decoded.dependency_bytes;
    result.body_bytes_consumed = decoded.body_bytes;
    result.available_body_bytes = raw_body_length;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;
    result.result_slot_handle = output_handle;
    result.allocation_bytes = ACTION_FAMILY_7D_OBJECT_BYTES;
    result.raw_type = ACTION_FAMILY_7D_RAW_TYPE;
    result.runtime_type = ACTION_FAMILY_7D_RUNTIME_TYPE;
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_7D_OK;
}
