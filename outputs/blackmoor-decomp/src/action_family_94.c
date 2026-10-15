#include "action_family_94.h"

#include <string.h>

static ActionFamily94Status validate_body(
    const uint8_t *raw, size_t length, const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)raw;
    uintptr_t b = (uintptr_t)out;
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_94_ERR_ARGUMENT;
    }
    if ((uintmax_t)length > (uintmax_t)UINTPTR_MAX - a ||
        (uintmax_t)out_length > (uintmax_t)UINTPTR_MAX - b) {
        return ACTION_FAMILY_94_ERR_BOUNDS;
    }
    if (length != 0u && a < b + out_length && b < a + length) {
        return ACTION_FAMILY_94_ERR_OVERLAP;
    }
    if (length < ACTION_FAMILY_94_BODY_BYTES) {
        return ACTION_FAMILY_94_ERR_BODY;
    }
    if ((length - ACTION_FAMILY_94_BODY_BYTES) %
            ACTION_FAMILY_94_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_94_ERR_TAIL;
    }
    return ACTION_FAMILY_94_OK;
}

static uint32_t read_le32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static void write_le32(uint8_t *p, uint32_t value)
{
    p[0] = (uint8_t)value;
    p[1] = (uint8_t)(value >> 8);
    p[2] = (uint8_t)(value >> 16);
    p[3] = (uint8_t)(value >> 24);
}

static void decode_validated(const uint8_t *raw, size_t length,
                             ActionFamily94Decoded *d)
{
    memset(d, 0, sizeof(*d));
    memcpy(d->option_00, raw, sizeof(d->option_00));
    d->word_21 = read_le32(raw + 0x21u);
    d->word_25 = read_le32(raw + 0x25u);
    d->word_29 = read_le32(raw + 0x29u);
    d->word_2d = read_le32(raw + 0x2du);
    d->option_31 = raw[0x31u];
    d->dependency_records = raw + ACTION_FAMILY_94_BODY_BYTES;
    d->dependency_bytes = length - ACTION_FAMILY_94_BODY_BYTES;
    d->dependency_count = d->dependency_bytes / ACTION_FAMILY_94_DEPENDENCY_BYTES;
    d->body_bytes = ACTION_FAMILY_94_BODY_BYTES;
    d->available_body_bytes = length;
}

ActionFamily94Status action_family_94_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily94Decoded *out)
{
    ActionFamily94Decoded decoded;
    ActionFamily94Status status = validate_body(raw_body, raw_body_length,
                                               out, sizeof(*out));
    if (status != ACTION_FAMILY_94_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_94_OK;
}

ActionFamily94Status action_family_94_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily94Constructed *out)
{
    ActionFamily94Decoded decoded;
    ActionFamily94Constructed result;
    ActionFamily94Status status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_94_ERR_ARGUMENT;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_94_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memset(&result, 0, sizeof(result));
    /* 0x40eaef/0x40eaf1 copy 12 DWORDs and one WORD: all 50 bytes.
     * Re-encode explicitly so native padding/alignment never enters layout. */
    memcpy(result.object_bytes, decoded.option_00, sizeof(decoded.option_00));
    write_le32(result.object_bytes + 0x21u, decoded.word_21);
    write_le32(result.object_bytes + 0x25u, decoded.word_25);
    write_le32(result.object_bytes + 0x29u, decoded.word_29);
    write_le32(result.object_bytes + 0x2du, decoded.word_2d);
    result.object_bytes[0x31u] = decoded.option_31;
    result.dependency_records = decoded.dependency_records;
    result.dependency_count = decoded.dependency_count;
    result.dependency_bytes = decoded.dependency_bytes;
    result.body_bytes_consumed = decoded.body_bytes;
    result.available_body_bytes = raw_body_length;
    result.payload_offset_before = payload_offset_before;
    /* 0x40eaf9..0x40eb08: offset update precedes cursor update. */
    result.payload_offset_after = payload_offset_before + UINT32_C(50);
    result.result_slot_handle = output_handle;
    result.allocation_bytes = ACTION_FAMILY_94_OBJECT_BYTES;
    result.raw_type = ACTION_FAMILY_94_RAW_TYPE;
    result.runtime_type = ACTION_FAMILY_94_RUNTIME_TYPE;
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_94_OK;
}
