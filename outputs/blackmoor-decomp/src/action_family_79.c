#include "action_family_79.h"

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

static ActionFamily79Status validate(const uint8_t *raw_body, size_t length,
                                    const void *out, size_t out_length)
{
    uintptr_t input_start, input_end, output_start, output_end;
    if (raw_body == NULL || out == NULL) {
        return ACTION_FAMILY_79_ERR_ARGUMENT;
    }
    if (length < ACTION_FAMILY_79_BODY_BYTES) {
        return ACTION_FAMILY_79_ERR_BODY;
    }
    if (!address_span(raw_body, length, &input_start, &input_end) ||
        !address_span(out, out_length, &output_start, &output_end)) {
        return ACTION_FAMILY_79_ERR_BOUNDS;
    }
    if (input_start < output_end && output_start < input_end) {
        return ACTION_FAMILY_79_ERR_OVERLAP;
    }
    if ((length - ACTION_FAMILY_79_BODY_BYTES) % ACTION_FAMILY_79_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_79_ERR_TAIL;
    }
    return ACTION_FAMILY_79_OK;
}

static void decode_validated(const uint8_t *raw_body, size_t length,
                             ActionFamily79Decoded *decoded)
{
    memset(decoded, 0, sizeof(*decoded));
    decoded->word_0 = (uint16_t)((uint16_t)raw_body[0] | ((uint16_t)raw_body[1] << 8));
    decoded->dependency_records = raw_body + ACTION_FAMILY_79_BODY_BYTES;
    decoded->dependency_bytes = length - ACTION_FAMILY_79_BODY_BYTES;
    decoded->dependency_count = decoded->dependency_bytes / ACTION_FAMILY_79_DEPENDENCY_BYTES;
    decoded->available_body_bytes = length;
    decoded->body_bytes = ACTION_FAMILY_79_BODY_BYTES;
}

ActionFamily79Status action_family_79_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily79Decoded *out)
{
    ActionFamily79Decoded decoded;
    ActionFamily79Status status = validate(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_79_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_79_OK;
}

ActionFamily79Status action_family_79_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily79Constructed *out)
{
    ActionFamily79Decoded decoded;
    ActionFamily79Constructed constructed;
    ActionFamily79Status status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_79_ERR_ARGUMENT;
    }
    status = validate(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_79_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&constructed, 0, sizeof(constructed));
    /* 0x4e9b49..0x4e9b4c: one complete word copy at object offset zero. */
    constructed.object_bytes[0] = (uint8_t)(decoded.word_0 & UINT16_C(0xff));
    constructed.object_bytes[1] = (uint8_t)(decoded.word_0 >> 8);
    constructed.dependency_records = decoded.dependency_records;
    constructed.dependency_count = decoded.dependency_count;
    constructed.dependency_bytes = decoded.dependency_bytes;
    constructed.available_body_bytes = decoded.available_body_bytes;
    constructed.body_bytes_consumed = ACTION_FAMILY_79_BODY_BYTES;
    constructed.payload_offset_before = payload_offset_before;
    /* 0x4e9b54 precedes the cursor update at 0x4e9b61. */
    constructed.payload_offset_after = payload_offset_before + UINT32_C(2);
    constructed.output_handle = output_handle;
    constructed.result_slot_handle = output_handle;
    constructed.output_allocation_bytes = ACTION_FAMILY_79_OBJECT_BYTES;
    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_79_OK;
}
