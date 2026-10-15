#include "action_family_45.h"

#include <string.h>

static uint16_t read_le16(const uint8_t *source)
{
    return (uint16_t)((uint16_t)source[0] | ((uint16_t)source[1] << 8));
}

static void write_le16(uint8_t *destination, uint16_t value)
{
    destination[0] = (uint8_t)(value & UINT16_C(0xff));
    destination[1] = (uint8_t)(value >> 8);
}

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

static ActionFamily45Status validate(const uint8_t *raw_body, size_t length,
                                    const void *out, size_t out_length,
                                    size_t *body_bytes, uint16_t *entry_count)
{
    uintptr_t input_start, input_end, output_start, output_end;
    uint16_t count;
    size_t typed;
    if (raw_body == NULL || out == NULL) {
        return ACTION_FAMILY_45_ERR_ARGUMENT;
    }
    if (length < ACTION_FAMILY_45_PREFIX_BYTES) {
        return ACTION_FAMILY_45_ERR_BODY;
    }
    if (!address_span(raw_body, length, &input_start, &input_end) ||
        !address_span(out, out_length, &output_start, &output_end)) {
        return ACTION_FAMILY_45_ERR_BOUNDS;
    }
    if (input_start < output_end && output_start < input_end) {
        return ACTION_FAMILY_45_ERR_OVERLAP;
    }
    count = read_le16(raw_body + 194u);
    /* Unsigned >10 also rejects every negative signed-16 pattern. No signed
     * conversion, narrowed multiply or allocation occurs before this guard. */
    if (count > ACTION_FAMILY_45_MAX_ENTRIES) {
        return ACTION_FAMILY_45_ERR_COUNT;
    }
    typed = ACTION_FAMILY_45_PREFIX_BYTES + (size_t)count * ACTION_FAMILY_45_ENTRY_BYTES;
    if (length < typed) {
        return ACTION_FAMILY_45_ERR_BODY;
    }
    if ((length - typed) % ACTION_FAMILY_45_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_45_ERR_TAIL;
    }
    *body_bytes = typed;
    *entry_count = count;
    return ACTION_FAMILY_45_OK;
}

static void decode_validated(const uint8_t *raw_body, size_t length,
                             size_t body_bytes, uint16_t entry_count,
                             ActionFamily45Decoded *decoded)
{
    memset(decoded, 0, sizeof(*decoded));
    decoded->raw_type = ACTION_FAMILY_45_RAW_TYPE;
    decoded->runtime_type = ACTION_FAMILY_45_RUNTIME_TYPE;
    for (size_t i = 0u; i < ACTION_FAMILY_45_PREFIX_WORDS; ++i) {
        decoded->words[i] = read_le16(raw_body + i * 2u);
    }
    decoded->entry_count = entry_count;
    for (size_t i = 0u; i < entry_count; ++i) {
        const uint8_t *entry = raw_body + ACTION_FAMILY_45_PREFIX_BYTES + i * ACTION_FAMILY_45_ENTRY_BYTES;
        decoded->entries[i].word_0 = read_le16(entry);
        decoded->entries[i].word_1 = read_le16(entry + 2u);
    }
    decoded->dependency_records = raw_body + body_bytes;
    decoded->dependency_bytes = length - body_bytes;
    decoded->dependency_count = decoded->dependency_bytes / ACTION_FAMILY_45_DEPENDENCY_BYTES;
    decoded->available_body_bytes = length;
    decoded->body_bytes = body_bytes;
}

ActionFamily45Status action_family_45_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily45Decoded *out)
{
    size_t body_bytes;
    uint16_t count;
    ActionFamily45Decoded decoded;
    ActionFamily45Status status = validate(raw_body, raw_body_length, out, sizeof(*out), &body_bytes, &count);
    if (status != ACTION_FAMILY_45_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, body_bytes, count, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_45_OK;
}

ActionFamily45Status action_family_45_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily45Constructed *out)
{
    size_t body_bytes;
    uint16_t count;
    ActionFamily45Decoded decoded;
    ActionFamily45Constructed constructed;
    ActionFamily45Status status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_45_ERR_ARGUMENT;
    }
    status = validate(raw_body, raw_body_length, out, sizeof(*out), &body_bytes, &count);
    if (status != ACTION_FAMILY_45_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, body_bytes, count, &decoded);
    memset(&constructed, 0, sizeof(constructed));
    /* Original 0x40d619 copies 49 DWORDs, including the count word. */
    for (size_t i = 0u; i < ACTION_FAMILY_45_PREFIX_WORDS; ++i) {
        write_le16(constructed.object_bytes + i * 2u, decoded.words[i]);
    }
    write_le16(constructed.object_bytes + 194u, decoded.entry_count);
    /* 0x40d660 copies the signed-16 narrowed count*4 suffix. For the bounded
     * 0..10 domain both original narrowings preserve the value exactly. */
    for (size_t i = 0u; i < decoded.entry_count; ++i) {
        uint8_t *entry = constructed.object_bytes + ACTION_FAMILY_45_PREFIX_BYTES + i * ACTION_FAMILY_45_ENTRY_BYTES;
        write_le16(entry, decoded.entries[i].word_0);
        write_le16(entry + 2u, decoded.entries[i].word_1);
    }
    constructed.dependency_records = decoded.dependency_records;
    constructed.dependency_count = decoded.dependency_count;
    constructed.dependency_bytes = decoded.dependency_bytes;
    constructed.available_body_bytes = decoded.available_body_bytes;
    constructed.body_bytes_consumed = decoded.body_bytes;
    constructed.payload_offset_before = payload_offset_before;
    constructed.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;
    constructed.output_handle = output_handle;
    constructed.result_slot_handle = output_handle;
    constructed.output_allocation_bytes = (uint32_t)decoded.body_bytes;
    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_45_OK;
}
