#include "action_family_2e.h"

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

static ActionFamily2eStatus validate(const uint8_t *raw_body, size_t length,
                                    const void *out, size_t out_length)
{
    uintptr_t input_start, input_end, output_start, output_end;
    if (raw_body == NULL || out == NULL) {
        return ACTION_FAMILY_2E_ERR_ARGUMENT;
    }
    if (length < ACTION_FAMILY_2E_BODY_BYTES) {
        return ACTION_FAMILY_2E_ERR_BODY;
    }
    if (!address_span(raw_body, length, &input_start, &input_end) ||
        !address_span(out, out_length, &output_start, &output_end)) {
        return ACTION_FAMILY_2E_ERR_BOUNDS;
    }
    if (input_start < output_end && output_start < input_end) {
        return ACTION_FAMILY_2E_ERR_OVERLAP;
    }
    if ((length - ACTION_FAMILY_2E_BODY_BYTES) % ACTION_FAMILY_2E_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_2E_ERR_TAIL;
    }
    return ACTION_FAMILY_2E_OK;
}

static void decode_validated(const uint8_t *raw_body, size_t length,
                             ActionFamily2eDecoded *decoded)
{
    memset(decoded, 0, sizeof(*decoded));
    decoded->option_00 = raw_body[0u];
    for (size_t i = 0u; i < 7u; ++i) {
        decoded->word[i] = (uint16_t)((uint16_t)raw_body[1u + i * 2u] |
            ((uint16_t)raw_body[2u + i * 2u] << 8));
    }
    decoded->dependency_records = raw_body + ACTION_FAMILY_2E_BODY_BYTES;
    decoded->dependency_bytes = length - ACTION_FAMILY_2E_BODY_BYTES;
    decoded->dependency_count = decoded->dependency_bytes / ACTION_FAMILY_2E_DEPENDENCY_BYTES;
    decoded->available_body_bytes = length;
    decoded->body_bytes = ACTION_FAMILY_2E_BODY_BYTES;
}

ActionFamily2eStatus action_family_2e_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily2eDecoded *out)
{
    ActionFamily2eDecoded decoded;
    ActionFamily2eStatus status = validate(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_2E_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_2E_OK;
}

ActionFamily2eStatus action_family_2e_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily2eConstructed *out)
{
    ActionFamily2eDecoded decoded;
    ActionFamily2eConstructed constructed;
    ActionFamily2eStatus status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_2E_ERR_ARGUMENT;
    }
    status = validate(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_2E_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&constructed, 0, sizeof(constructed));
    /* Original helper zeroes malloc(15), then 0x4cd6a9..0x4cd6c4
     * overwrites all 15 bytes. Preserve each neutral word's LE bits. */
    constructed.object_bytes[0u] = decoded.option_00;
    for (size_t i = 0u; i < 7u; ++i) {
        constructed.object_bytes[1u + i * 2u] = (uint8_t)(decoded.word[i] & UINT16_C(0xff));
        constructed.object_bytes[2u + i * 2u] = (uint8_t)(decoded.word[i] >> 8);
    }
    constructed.dependency_records = decoded.dependency_records;
    constructed.dependency_count = decoded.dependency_count;
    constructed.dependency_bytes = decoded.dependency_bytes;
    constructed.available_body_bytes = decoded.available_body_bytes;
    constructed.body_bytes_consumed = ACTION_FAMILY_2E_BODY_BYTES;
    constructed.payload_offset_before = payload_offset_before;
    /* 0x4cd6d2 stores the offset before 0x4cd6df stores the cursor. */
    constructed.payload_offset_after = payload_offset_before + UINT32_C(15);
    constructed.output_handle = output_handle;
    constructed.result_slot_handle = output_handle;
    constructed.output_allocation_bytes = ACTION_FAMILY_2E_OBJECT_BYTES;
    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_2E_OK;
}
