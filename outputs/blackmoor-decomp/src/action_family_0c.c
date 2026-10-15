/* Behavioral reconstruction from immutable original x86 loader 0x40b34a,
 * raw 0x0c arm 0x40bafd. No original C++/compiler or byte-match claim. */
#include "action_family_0c.h"

#include <string.h>

static uint16_t read_u16_le(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static int span_valid(const void *p, size_t length)
{
    return p != NULL && (uintmax_t)length <=
        (uintmax_t)UINTPTR_MAX - (uintmax_t)(uintptr_t)p;
}

/* Both address extents are validated before this arithmetic. */
static int overlap(const void *a, size_t na, const void *b, size_t nb)
{
    uintptr_t aa = (uintptr_t)a, bb = (uintptr_t)b;
    return na != 0u && nb != 0u && aa < bb + nb && bb < aa + na;
}

static ActionFamily0cStatus validate_spans(
    const uint8_t *raw, size_t length, const void *out, size_t out_size)
{
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_0C_ERR_ARGUMENT;
    }
    if (!span_valid(raw, length) || !span_valid(out, out_size)) {
        return ACTION_FAMILY_0C_ERR_BOUNDS;
    }
    if (overlap(raw, length, out, out_size)) {
        return ACTION_FAMILY_0C_ERR_OVERLAP;
    }
    return ACTION_FAMILY_0C_OK;
}

static ActionFamily0cStatus parse_body(
    const uint8_t *raw_body, size_t length, ActionFamily0cDecoded *decoded)
{
    uint16_t count;
    size_t typed, i;
    if (length < ACTION_FAMILY_0C_PREFIX_BYTES) {
        return ACTION_FAMILY_0C_ERR_BODY;
    }
    count = read_u16_le(raw_body + 8u);
    /* MOVSX count at 0x40bb0c; IMUL/ADD, WORD store at 0x40bb16,
     * MOVSX size at 0x40bb1d. Original has no validation. This bound keeps
     * the signed WORD size positive and the full declared table available. */
    if (count > ACTION_FAMILY_0C_MAX_COUNT) {
        return ACTION_FAMILY_0C_ERR_COUNT;
    }
    typed = ACTION_FAMILY_0C_PREFIX_BYTES + ACTION_FAMILY_0C_RECORD18_BYTES * (size_t)count;
    if (length < typed) {
        return ACTION_FAMILY_0C_ERR_BODY;
    }
    if ((length - typed) % ACTION_FAMILY_0C_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_0C_ERR_TAIL;
    }
    memset(decoded, 0, sizeof(*decoded));
    for (i = 0u; i < 4u; ++i) {
        decoded->words[i] = read_u16_le(raw_body + i * 2u);
    }
    decoded->count_18 = (int16_t)count;
    decoded->records_18 = raw_body + ACTION_FAMILY_0C_PREFIX_BYTES;
    decoded->dependency_records = raw_body + typed;
    decoded->dependency_count = (length - typed) / ACTION_FAMILY_0C_DEPENDENCY_BYTES;
    decoded->dependency_bytes = length - typed;
    decoded->available_body_bytes = length;
    decoded->body_bytes = typed;
    decoded->raw_type = ACTION_FAMILY_0C_RAW_TYPE;
    decoded->runtime_type = ACTION_FAMILY_0C_RUNTIME_TYPE;
    return ACTION_FAMILY_0C_OK;
}

static ActionFamily0cStatus validate_and_parse(
    const uint8_t *raw, size_t length, const void *out, size_t out_size,
    ActionFamily0cDecoded *decoded)
{
    ActionFamily0cStatus status = validate_spans(raw, length, out, out_size);
    return status == ACTION_FAMILY_0C_OK ? parse_body(raw, length, decoded) : status;
}

ActionFamily0cStatus action_family_0c_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out)
{
    ActionFamily0cDecoded decoded;
    ActionFamily0cStatus status = validate_and_parse(raw_body, raw_body_length, out, sizeof(*out), &decoded);
    if (status == ACTION_FAMILY_0C_OK) {
        memcpy(out, &decoded.body_bytes, sizeof(*out));
    }
    return status;
}

ActionFamily0cStatus action_family_0c_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily0cDecoded *out)
{
    ActionFamily0cDecoded decoded;
    ActionFamily0cStatus status = validate_and_parse(raw_body, raw_body_length, out, sizeof(*out), &decoded);
    if (status == ACTION_FAMILY_0C_OK) {
        memcpy(out, &decoded, sizeof(decoded));
    }
    return status;
}

ActionFamily0cStatus action_family_0c_record18_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t index,
    ActionFamily0cRecord18 *out)
{
    ActionFamily0cDecoded decoded;
    ActionFamily0cRecord18 record;
    size_t i;
    ActionFamily0cStatus status = validate_and_parse(raw_body, raw_body_length, out, sizeof(*out), &decoded);
    if (status != ACTION_FAMILY_0C_OK) {
        return status;
    }
    if (index >= (size_t)decoded.count_18) {
        return ACTION_FAMILY_0C_ERR_INDEX;
    }
    for (i = 0u; i < 9u; ++i) {
        record.words[i] = read_u16_le(decoded.records_18 + index * ACTION_FAMILY_0C_RECORD18_BYTES + i * 2u);
    }
    memcpy(out, &record, sizeof(record));
    return ACTION_FAMILY_0C_OK;
}

ActionFamily0cStatus action_family_0c_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object_bytes, size_t object_capacity,
    ActionFamily0cConstructed *out)
{
    ActionFamily0cDecoded decoded;
    ActionFamily0cConstructed constructed;
    ActionFamily0cStatus status;
    if (object_bytes == NULL || output_handle == 0u) {
        return ACTION_FAMILY_0C_ERR_ARGUMENT;
    }
    status = validate_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_0C_OK) {
        return status;
    }
    if (!span_valid(object_bytes, object_capacity)) {
        return ACTION_FAMILY_0C_ERR_BOUNDS;
    }
    if (overlap(raw_body, raw_body_length, object_bytes, object_capacity) ||
        overlap(out, sizeof(*out), object_bytes, object_capacity)) {
        return ACTION_FAMILY_0C_ERR_OVERLAP;
    }
    status = parse_body(raw_body, raw_body_length, &decoded);
    if (status != ACTION_FAMILY_0C_OK) {
        return status;
    }
    if (object_capacity < decoded.body_bytes) {
        return ACTION_FAMILY_0C_ERR_CAPACITY;
    }
    memset(&constructed, 0, sizeof(constructed));
    constructed.dependency_records = decoded.dependency_records;
    constructed.dependency_count = decoded.dependency_count;
    constructed.dependency_bytes = decoded.dependency_bytes;
    constructed.available_body_bytes = decoded.available_body_bytes;
    constructed.body_bytes_consumed = decoded.body_bytes;
    constructed.allocation_bytes = decoded.body_bytes;
    constructed.payload_offset_before = payload_offset_before;
    constructed.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;
    constructed.result_slot_handle = output_handle;
    constructed.raw_type = decoded.raw_type;
    constructed.runtime_type = decoded.runtime_type;
    /* REP MOVSD/MOVSB at 0x40bbbb/0x40bbc2. No constructor field writes. */
    memcpy(object_bytes, raw_body, decoded.body_bytes);
    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_0C_OK;
}
