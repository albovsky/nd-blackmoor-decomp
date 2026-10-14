#include "action_family_d1.h"

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

static ActionFamilyD1Status validate(const uint8_t *raw_body, size_t length,
                                    const void *out, size_t out_length)
{
    uintptr_t input_start, input_end, output_start, output_end;
    if (raw_body == NULL || out == NULL) {
        return ACTION_FAMILY_D1_ERR_ARGUMENT;
    }
    if (length < ACTION_FAMILY_D1_BODY_BYTES) {
        return ACTION_FAMILY_D1_ERR_BODY;
    }
    if (!address_span(raw_body, length, &input_start, &input_end) ||
        !address_span(out, out_length, &output_start, &output_end)) {
        return ACTION_FAMILY_D1_ERR_BOUNDS;
    }
    if (input_start < output_end && output_start < input_end) {
        return ACTION_FAMILY_D1_ERR_OVERLAP;
    }
    if ((length - ACTION_FAMILY_D1_BODY_BYTES) % ACTION_FAMILY_D1_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_D1_ERR_TAIL;
    }
    return ACTION_FAMILY_D1_OK;
}

static void decode_validated(const uint8_t *raw_body, size_t length,
                             ActionFamilyD1Decoded *decoded)
{
    memset(decoded, 0, sizeof(*decoded));
    for (size_t i = 0u; i < ACTION_FAMILY_D1_WORD_COUNT; ++i) {
        decoded->word_N[i] = (uint16_t)((uint16_t)raw_body[i * 2u] |
                                      ((uint16_t)raw_body[i * 2u + 1u] << 8));
    }
    decoded->option_39e = raw_body[926u];
    decoded->raw_type = ACTION_FAMILY_D1_RAW_TYPE;
    decoded->runtime_type = ACTION_FAMILY_D1_RUNTIME_TYPE;
    decoded->dependency_records = raw_body + ACTION_FAMILY_D1_BODY_BYTES;
    decoded->dependency_bytes = length - ACTION_FAMILY_D1_BODY_BYTES;
    decoded->dependency_count = decoded->dependency_bytes / ACTION_FAMILY_D1_DEPENDENCY_BYTES;
    decoded->available_body_bytes = length;
    decoded->body_bytes = ACTION_FAMILY_D1_BODY_BYTES;
}

ActionFamilyD1Status action_family_d1_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyD1Decoded *out)
{
    ActionFamilyD1Decoded decoded;
    ActionFamilyD1Status status = validate(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_D1_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_D1_OK;
}

ActionFamilyD1Status action_family_d1_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyD1Constructed *out)
{
    ActionFamilyD1Decoded decoded;
    ActionFamilyD1Constructed constructed;
    ActionFamilyD1Status status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_D1_ERR_ARGUMENT;
    }
    status = validate(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_D1_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&constructed, 0, sizeof(constructed));
    /* 0x4b5ccd..0x4b5cd6: 231 DWORDs, one word and one byte.
     * Every allocation byte is written; no defaults or owner writes occur. */
    for (size_t i = 0u; i < ACTION_FAMILY_D1_WORD_COUNT; ++i) {
        constructed.object_bytes[i * 2u] = (uint8_t)(decoded.word_N[i] & UINT16_C(0xff));
        constructed.object_bytes[i * 2u + 1u] = (uint8_t)(decoded.word_N[i] >> 8);
    }
    constructed.object_bytes[926u] = decoded.option_39e;
    constructed.raw_type = decoded.raw_type;
    constructed.runtime_type = decoded.runtime_type;
    constructed.dependency_records = decoded.dependency_records;
    constructed.dependency_count = decoded.dependency_count;
    constructed.dependency_bytes = decoded.dependency_bytes;
    constructed.available_body_bytes = decoded.available_body_bytes;
    constructed.body_bytes_consumed = ACTION_FAMILY_D1_BODY_BYTES;
    constructed.payload_offset_before = payload_offset_before;
    /* Offset store 0x4b5ce5 precedes source-cursor store 0x4b5cf5. */
    constructed.payload_offset_after = payload_offset_before + UINT32_C(927);
    constructed.output_handle = output_handle;
    constructed.result_slot_handle = output_handle;
    constructed.output_allocation_bytes = ACTION_FAMILY_D1_OBJECT_BYTES;
    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_D1_OK;
}
