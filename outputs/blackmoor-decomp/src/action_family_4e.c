#include "action_family_4e.h"

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

static ActionFamily4EStatus validate(const uint8_t *raw_body, size_t length,
                                    const void *out, size_t out_length)
{
    uintptr_t input_start, input_end, output_start, output_end;
    if (raw_body == NULL || out == NULL) {
        return ACTION_FAMILY_4E_ERR_ARGUMENT;
    }
    if (length < ACTION_FAMILY_4E_BODY_BYTES) {
        return ACTION_FAMILY_4E_ERR_BODY;
    }
    if (!address_span(raw_body, length, &input_start, &input_end) ||
        !address_span(out, out_length, &output_start, &output_end)) {
        return ACTION_FAMILY_4E_ERR_BOUNDS;
    }
    if (input_start < output_end && output_start < input_end) {
        return ACTION_FAMILY_4E_ERR_OVERLAP;
    }
    if ((length - ACTION_FAMILY_4E_BODY_BYTES) % ACTION_FAMILY_4E_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_4E_ERR_TAIL;
    }
    return ACTION_FAMILY_4E_OK;
}

static uint16_t load16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static void store16(uint8_t *p, uint16_t value)
{
    p[0] = (uint8_t)(value & UINT16_C(0xff));
    p[1] = (uint8_t)(value >> 8);
}

static void decode_validated(const uint8_t *raw_body, size_t length,
                             ActionFamily4EDecoded *decoded)
{
    memset(decoded, 0, sizeof(*decoded));
    decoded->option_00 = raw_body[0];
    for (size_t i = 0u; i < ACTION_FAMILY_4E_ENTRY_COUNT; ++i) {
        decoded->entries[i].option_00 = raw_body[1u + i * 3u];
        decoded->entries[i].word_0 = load16(raw_body + 2u + i * 3u);
    }
    decoded->dependency_records = raw_body + ACTION_FAMILY_4E_BODY_BYTES;
    decoded->dependency_bytes = length - ACTION_FAMILY_4E_BODY_BYTES;
    decoded->dependency_count = decoded->dependency_bytes / ACTION_FAMILY_4E_DEPENDENCY_BYTES;
    decoded->available_body_bytes = length;
    decoded->body_bytes = ACTION_FAMILY_4E_BODY_BYTES;
}

ActionFamily4EStatus action_family_4e_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out_body_length)
{
    ActionFamily4EStatus status = validate(raw_body, raw_body_length,
                                         out_body_length, sizeof(*out_body_length));
    if (status != ACTION_FAMILY_4E_OK) {
        return status;
    }
    *out_body_length = ACTION_FAMILY_4E_BODY_BYTES;
    return ACTION_FAMILY_4E_OK;
}

ActionFamily4EStatus action_family_4e_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily4EDecoded *out)
{
    ActionFamily4EDecoded decoded;
    ActionFamily4EStatus status = validate(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_4E_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_4E_OK;
}

ActionFamily4EStatus action_family_4e_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily4EConstructed *out)
{
    ActionFamily4EDecoded decoded;
    ActionFamily4EConstructed constructed;
    ActionFamily4EStatus status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_4E_ERR_ARGUMENT;
    }
    status = validate(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_4E_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&constructed, 0, sizeof(constructed));
    /* 0x44b170..0x44b179 copies all 31 input bytes, with no defaults. */
    constructed.object_bytes[0] = decoded.option_00;
    for (size_t i = 0u; i < ACTION_FAMILY_4E_ENTRY_COUNT; ++i) {
        constructed.object_bytes[1u + i * 3u] = decoded.entries[i].option_00;
        store16(constructed.object_bytes + 2u + i * 3u, decoded.entries[i].word_0);
    }
    constructed.dependency_records = decoded.dependency_records;
    constructed.dependency_count = decoded.dependency_count;
    constructed.dependency_bytes = decoded.dependency_bytes;
    constructed.available_body_bytes = decoded.available_body_bytes;
    constructed.body_bytes_consumed = ACTION_FAMILY_4E_BODY_BYTES;
    constructed.payload_offset_before = payload_offset_before;
    /* 0x44b17f offset addition precedes cursor addition at 0x44b18c. */
    constructed.payload_offset_after = payload_offset_before + UINT32_C(31);
    constructed.output_handle = output_handle;
    constructed.result_slot_handle = output_handle;
    constructed.output_allocation_bytes = ACTION_FAMILY_4E_OBJECT_BYTES;
    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_4E_OK;
}
