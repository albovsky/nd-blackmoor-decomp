#include "action_family_69.h"

#include <string.h>

static int address_span(const void *pointer, size_t length,
                        uintptr_t *start, uintptr_t *end)
{
    uintmax_t begin = (uintmax_t)(uintptr_t)pointer;
    if (pointer == NULL || (uintmax_t)length > (uintmax_t)UINTPTR_MAX - begin) {
        return 0;
    }
    *start = (uintptr_t)begin;
    *end = (uintptr_t)(begin + (uintmax_t)length);
    return 1;
}

static ActionFamily69Status validate(const uint8_t *raw_body, size_t length,
                                    const void *out, size_t out_length)
{
    uintptr_t input_start, input_end, output_start, output_end;
    if (raw_body == NULL || out == NULL) {
        return ACTION_FAMILY_69_ERR_ARGUMENT;
    }
    if (length < ACTION_FAMILY_69_BODY_BYTES) {
        return ACTION_FAMILY_69_ERR_BODY;
    }
    if (!address_span(raw_body, length, &input_start, &input_end) ||
        !address_span(out, out_length, &output_start, &output_end)) {
        return ACTION_FAMILY_69_ERR_BOUNDS;
    }
    if (input_start < output_end && output_start < input_end) {
        return ACTION_FAMILY_69_ERR_OVERLAP;
    }
    if ((length - ACTION_FAMILY_69_BODY_BYTES) % ACTION_FAMILY_69_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_69_ERR_TAIL;
    }
    return ACTION_FAMILY_69_OK;
}

static void decode_validated(const uint8_t *raw_body, size_t length,
                             ActionFamily69Decoded *decoded)
{
    memset(decoded, 0, sizeof(*decoded));
    decoded->option_00 = raw_body[0];
    decoded->dependency_records = raw_body + ACTION_FAMILY_69_BODY_BYTES;
    decoded->dependency_bytes = length - ACTION_FAMILY_69_BODY_BYTES;
    decoded->dependency_count = decoded->dependency_bytes / ACTION_FAMILY_69_DEPENDENCY_BYTES;
    decoded->available_body_bytes = length;
    decoded->body_bytes = ACTION_FAMILY_69_BODY_BYTES;
}

ActionFamily69Status action_family_69_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily69Decoded *out)
{
    ActionFamily69Decoded decoded;
    ActionFamily69Status status = validate(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_69_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_69_OK;
}

ActionFamily69Status action_family_69_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily69Constructed *out)
{
    ActionFamily69Decoded decoded;
    ActionFamily69Constructed constructed;
    ActionFamily69Status status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_69_ERR_ARGUMENT;
    }
    status = validate(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_69_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&constructed, 0, sizeof(constructed));
    /* 0x40d4b4..0x40d4b6: the entire one-byte allocation is written. */
    constructed.object_bytes[0] = decoded.option_00;
    constructed.dependency_records = decoded.dependency_records;
    constructed.dependency_count = decoded.dependency_count;
    constructed.dependency_bytes = decoded.dependency_bytes;
    constructed.available_body_bytes = decoded.available_body_bytes;
    constructed.body_bytes_consumed = ACTION_FAMILY_69_BODY_BYTES;
    constructed.payload_offset_before = payload_offset_before;
    /* 0x40d4c1 stores the offset before the cursor store at 0x40d4cd. */
    constructed.payload_offset_after = payload_offset_before + UINT32_C(1);
    constructed.output_handle = output_handle;
    constructed.result_slot_handle = output_handle;
    constructed.output_allocation_bytes = ACTION_FAMILY_69_OBJECT_BYTES;
    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_69_OK;
}

ActionFamily69Status action_family_69_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out)
{
    const size_t length = ACTION_FAMILY_69_BODY_BYTES;
    ActionFamily69Status status = validate(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_69_OK) {
        return status;
    }
    memcpy(out, &length, sizeof(length));
    return ACTION_FAMILY_69_OK;
}
