#include "action_family_f6.h"

#include <string.h>

static ActionFamilyF6Status validate_body(
    const uint8_t *raw, size_t length, const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)raw;
    uintptr_t b = (uintptr_t)out;
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_F6_ERR_ARGUMENT;
    }
    /* Span checks cannot establish mappedness of arbitrary caller pointers. */
    if (length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b) {
        return ACTION_FAMILY_F6_ERR_BOUNDS;
    }
    if (length != 0u && a < b + out_length && b < a + length) {
        return ACTION_FAMILY_F6_ERR_OVERLAP;
    }
    if (length < ACTION_FAMILY_F6_BODY_BYTES) {
        return ACTION_FAMILY_F6_ERR_BODY;
    }
    if ((length - ACTION_FAMILY_F6_BODY_BYTES) %
            ACTION_FAMILY_F6_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_F6_ERR_TAIL;
    }
    return ACTION_FAMILY_F6_OK;
}

static void decode_validated(const uint8_t *raw, size_t length,
                             ActionFamilyF6Decoded *d)
{
    memset(d, 0, sizeof(*d));
    memcpy(d->body, raw, ACTION_FAMILY_F6_BODY_BYTES);
    d->dependency_records = raw + ACTION_FAMILY_F6_BODY_BYTES;
    d->dependency_bytes = length - ACTION_FAMILY_F6_BODY_BYTES;
    d->dependency_count = d->dependency_bytes / ACTION_FAMILY_F6_DEPENDENCY_BYTES;
    d->body_bytes = ACTION_FAMILY_F6_BODY_BYTES;
    d->available_body_bytes = length;
}

ActionFamilyF6Status action_family_f6_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyF6Decoded *out)
{
    ActionFamilyF6Status status = validate_body(raw_body, raw_body_length,
                                               out, sizeof(*out));
    if (status != ACTION_FAMILY_F6_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, out);
    return ACTION_FAMILY_F6_OK;
}

ActionFamilyF6Status action_family_f6_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes)
{
    ActionFamilyF6Status status = validate_body(raw_body, raw_body_length,
                                               body_bytes, sizeof(*body_bytes));
    if (status != ACTION_FAMILY_F6_OK) {
        return status;
    }
    *body_bytes = ACTION_FAMILY_F6_BODY_BYTES;
    return ACTION_FAMILY_F6_OK;
}

ActionFamilyF6Status action_family_f6_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyF6Constructed *out)
{
    ActionFamilyF6Status status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_F6_ERR_ARGUMENT;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_F6_OK) {
        return status;
    }
    memset(out, 0, sizeof(*out));
    /* The original writes the entire allocation at 0x45de46/0x45de48. */
    memcpy(out->object_bytes, raw_body, ACTION_FAMILY_F6_OBJECT_BYTES);
    out->dependency_records = raw_body + ACTION_FAMILY_F6_BODY_BYTES;
    out->dependency_bytes = raw_body_length - ACTION_FAMILY_F6_BODY_BYTES;
    out->dependency_count = out->dependency_bytes / ACTION_FAMILY_F6_DEPENDENCY_BYTES;
    out->body_bytes_consumed = ACTION_FAMILY_F6_BODY_BYTES;
    out->available_body_bytes = raw_body_length;
    out->payload_offset_before = payload_offset_before;
    out->payload_offset_after = payload_offset_before + UINT32_C(4934);
    out->result_slot_handle = output_handle;
    out->allocation_bytes = ACTION_FAMILY_F6_OBJECT_BYTES;
    out->raw_type = ACTION_FAMILY_F6_RAW_TYPE;
    out->runtime_type = ACTION_FAMILY_F6_RUNTIME_TYPE;
    return ACTION_FAMILY_F6_OK;
}
