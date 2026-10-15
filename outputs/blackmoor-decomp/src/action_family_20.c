#include "action_family_20.h"

#include <string.h>

static ActionFamily20Status validate_body(
    const uint8_t *raw, size_t length, const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)raw;
    uintptr_t b = (uintptr_t)out;
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_20_ERR_ARGUMENT;
    }
    /* Span checks cannot establish mappedness of arbitrary caller pointers. */
    if (length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b) {
        return ACTION_FAMILY_20_ERR_BOUNDS;
    }
    if (length != 0u && a < b + out_length && b < a + length) {
        return ACTION_FAMILY_20_ERR_OVERLAP;
    }
    if (length < ACTION_FAMILY_20_BODY_BYTES) {
        return ACTION_FAMILY_20_ERR_BODY;
    }
    if ((length - ACTION_FAMILY_20_BODY_BYTES) %
            ACTION_FAMILY_20_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_20_ERR_TAIL;
    }
    return ACTION_FAMILY_20_OK;
}

static uint32_t read_le32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static void decode_validated(const uint8_t *raw, size_t length,
                             ActionFamily20Decoded *d)
{
    memset(d, 0, sizeof(*d));
    d->dword_0 = read_le32(raw);
    d->dword_4 = read_le32(raw + 4);
    d->dependency_records = raw + ACTION_FAMILY_20_BODY_BYTES;
    d->dependency_bytes = length - ACTION_FAMILY_20_BODY_BYTES;
    d->dependency_count = d->dependency_bytes / ACTION_FAMILY_20_DEPENDENCY_BYTES;
    d->body_bytes = ACTION_FAMILY_20_BODY_BYTES;
    d->available_body_bytes = length;
}

ActionFamily20Status action_family_20_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily20Decoded *out)
{
    ActionFamily20Decoded decoded;
    ActionFamily20Status status = validate_body(raw_body, raw_body_length,
                                               out, sizeof(*out));
    if (status != ACTION_FAMILY_20_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_20_OK;
}

ActionFamily20Status action_family_20_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes)
{
    ActionFamily20Status status = validate_body(raw_body, raw_body_length,
                                               body_bytes, sizeof(*body_bytes));
    if (status != ACTION_FAMILY_20_OK) {
        return status;
    }
    *body_bytes = ACTION_FAMILY_20_BODY_BYTES;
    return ACTION_FAMILY_20_OK;
}

ActionFamily20Status action_family_20_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily20Constructed *out)
{
    ActionFamily20Decoded decoded;
    ActionFamily20Constructed result;
    ActionFamily20Status status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_20_ERR_ARGUMENT;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_20_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&result, 0, sizeof(result));
    /* The original allocation is two DWORD copies at 0x40bda0 (offset 0) and
     * 0x40bda5 (offset 4). Serialize the decoded neutral DWORDs explicitly,
     * independent of host endian. */
    result.object_bytes[0] = (uint8_t)decoded.dword_0;
    result.object_bytes[1] = (uint8_t)(decoded.dword_0 >> 8);
    result.object_bytes[2] = (uint8_t)(decoded.dword_0 >> 16);
    result.object_bytes[3] = (uint8_t)(decoded.dword_0 >> 24);
    result.object_bytes[4] = (uint8_t)decoded.dword_4;
    result.object_bytes[5] = (uint8_t)(decoded.dword_4 >> 8);
    result.object_bytes[6] = (uint8_t)(decoded.dword_4 >> 16);
    result.object_bytes[7] = (uint8_t)(decoded.dword_4 >> 24);
    result.dependency_records = decoded.dependency_records;
    result.dependency_count = decoded.dependency_count;
    result.dependency_bytes = decoded.dependency_bytes;
    result.body_bytes_consumed = decoded.body_bytes;
    result.available_body_bytes = raw_body_length;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + UINT32_C(8); /* ADD 8, wraps */
    result.result_slot_handle = output_handle;
    result.allocation_bytes = ACTION_FAMILY_20_OBJECT_BYTES;
    result.raw_type = ACTION_FAMILY_20_RAW_TYPE;
    result.runtime_type = ACTION_FAMILY_20_RUNTIME_TYPE;
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_20_OK;
}
