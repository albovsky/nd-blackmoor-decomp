/* Behavioral reconstruction from original x86 loader 0x4bf8c2. This does not
 * claim original C++ provenance or an x86 byte-matching rebuild. */
#include "action_family_35.h"

#include <string.h>

static uint16_t read_u16_le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static int span_valid(const void *pointer, size_t length)
{
    return pointer != NULL && (uintmax_t)length <=
        (uintmax_t)UINTPTR_MAX - (uintmax_t)(uintptr_t)pointer;
}

/* Called only after validating both address spans. */
static int overlap(const void *a, size_t na, const void *b, size_t nb)
{
    uintptr_t aa = (uintptr_t)a;
    uintptr_t bb = (uintptr_t)b;
    return na != 0u && nb != 0u && aa < bb + nb && bb < aa + na;
}

static ActionFamily35Status validate_spans(
    const uint8_t *raw_body, size_t length, const void *out, size_t out_size)
{
    if (raw_body == NULL || out == NULL) {
        return ACTION_FAMILY_35_ERR_ARGUMENT;
    }
    if (!span_valid(raw_body, length) || !span_valid(out, out_size)) {
        return ACTION_FAMILY_35_ERR_BOUNDS;
    }
    if (overlap(raw_body, length, out, out_size)) {
        return ACTION_FAMILY_35_ERR_OVERLAP;
    }
    return ACTION_FAMILY_35_OK;
}

/* No output writes or reads precede full source bounds/count validation.
 * 0x4bf8d8 and 0x4bf8fa sign-extend the two words into 32-bit arithmetic;
 * neither count/size is narrowed again. Nonnegative int16 counts bound all
 * products below 1,310,744, on every supported size_t width. Original negative
 * counts can read backwards or request/copy huge allocations; reject them. */
static ActionFamily35Status parse_body(
    const uint8_t *raw_body, size_t length, ActionFamily35Decoded *decoded)
{
    uint16_t n;
    uint16_t m;
    size_t second_count_offset;
    size_t body_bytes;
    size_t i;

    if (length < ACTION_FAMILY_35_PREFIX_BYTES) {
        return ACTION_FAMILY_35_ERR_BODY;
    }
    n = read_u16_le(raw_body + 0x3bu);
    if (n > ACTION_FAMILY_35_MAX_COUNT) {
        return ACTION_FAMILY_35_ERR_COUNT;
    }
    second_count_offset = ACTION_FAMILY_35_PREFIX_BYTES +
        ACTION_FAMILY_35_RECORD6_BYTES * (size_t)n;
    if (length < second_count_offset + 2u) {
        return ACTION_FAMILY_35_ERR_BODY;
    }
    m = read_u16_le(raw_body + second_count_offset);
    if (m > ACTION_FAMILY_35_MAX_COUNT) {
        return ACTION_FAMILY_35_ERR_COUNT;
    }
    body_bytes = second_count_offset + 2u +
        ACTION_FAMILY_35_RECORD34_BYTES * (size_t)m;
    if (length < body_bytes) {
        return ACTION_FAMILY_35_ERR_BODY;
    }
    if ((length - body_bytes) % ACTION_FAMILY_35_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_35_ERR_TAIL;
    }

    memset(decoded, 0, sizeof(*decoded));
    memcpy(decoded->name, raw_body, sizeof(decoded->name));
    for (i = 0u; i < 13u; ++i) {
        decoded->words[i] = read_u16_le(raw_body + 0x21u + i * 2u);
    }
    decoded->count_6 = (int16_t)n;
    decoded->count_34 = (int16_t)m;
    decoded->records_6 = raw_body + ACTION_FAMILY_35_PREFIX_BYTES;
    decoded->records_34 = raw_body + second_count_offset + 2u;
    decoded->dependency_records = raw_body + body_bytes;
    decoded->dependency_count = (length - body_bytes) /
        ACTION_FAMILY_35_DEPENDENCY_BYTES;
    decoded->dependency_bytes = length - body_bytes;
    decoded->available_body_bytes = length;
    decoded->body_bytes = body_bytes;
    decoded->raw_type = ACTION_FAMILY_35_RAW_TYPE;
    decoded->runtime_type = ACTION_FAMILY_35_RUNTIME_TYPE;
    return ACTION_FAMILY_35_OK;
}

static ActionFamily35Status validate_and_parse(
    const uint8_t *body, size_t length, const void *out, size_t out_size,
    ActionFamily35Decoded *decoded)
{
    ActionFamily35Status status = validate_spans(body, length, out, out_size);
    if (status != ACTION_FAMILY_35_OK) {
        return status;
    }
    return parse_body(body, length, decoded);
}

ActionFamily35Status action_family_35_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily35Decoded *out)
{
    ActionFamily35Decoded decoded;
    ActionFamily35Status status = validate_and_parse(
        raw_body, raw_body_length, out, sizeof(*out), &decoded);
    if (status == ACTION_FAMILY_35_OK) {
        memcpy(out, &decoded, sizeof(decoded));
    }
    return status;
}

ActionFamily35Status action_family_35_record6_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t index,
    ActionFamily35Record6 *out)
{
    ActionFamily35Decoded decoded;
    ActionFamily35Record6 record;
    size_t i;
    ActionFamily35Status status = validate_and_parse(
        raw_body, raw_body_length, out, sizeof(*out), &decoded);
    if (status != ACTION_FAMILY_35_OK) {
        return status;
    }
    if (index >= (size_t)decoded.count_6) {
        return ACTION_FAMILY_35_ERR_INDEX;
    }
    for (i = 0u; i < 3u; ++i) {
        record.words[i] = read_u16_le(
            decoded.records_6 + index * ACTION_FAMILY_35_RECORD6_BYTES + i * 2u);
    }
    memcpy(out, &record, sizeof(record));
    return ACTION_FAMILY_35_OK;
}

ActionFamily35Status action_family_35_record34_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t index,
    ActionFamily35Record34 *out)
{
    ActionFamily35Decoded decoded;
    ActionFamily35Record34 record;
    size_t i;
    ActionFamily35Status status = validate_and_parse(
        raw_body, raw_body_length, out, sizeof(*out), &decoded);
    if (status != ACTION_FAMILY_35_OK) {
        return status;
    }
    if (index >= (size_t)decoded.count_34) {
        return ACTION_FAMILY_35_ERR_INDEX;
    }
    for (i = 0u; i < 17u; ++i) {
        record.words[i] = read_u16_le(
            decoded.records_34 + index * ACTION_FAMILY_35_RECORD34_BYTES + i * 2u);
    }
    memcpy(out, &record, sizeof(record));
    return ACTION_FAMILY_35_OK;
}

ActionFamily35Status action_family_35_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object_bytes, size_t object_capacity,
    ActionFamily35Constructed *out)
{
    ActionFamily35Decoded decoded;
    ActionFamily35Constructed constructed;
    ActionFamily35Status status;

    if (output_handle == 0u || object_bytes == NULL) {
        return ACTION_FAMILY_35_ERR_ARGUMENT;
    }
    status = validate_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_35_OK) {
        return status;
    }
    if (!span_valid(object_bytes, object_capacity)) {
        return ACTION_FAMILY_35_ERR_BOUNDS;
    }
    if (overlap(raw_body, raw_body_length, object_bytes, object_capacity) ||
        overlap(out, sizeof(*out), object_bytes, object_capacity)) {
        return ACTION_FAMILY_35_ERR_OVERLAP;
    }
    status = parse_body(raw_body, raw_body_length, &decoded);
    if (status != ACTION_FAMILY_35_OK) {
        return status;
    }
    if (object_capacity < decoded.body_bytes) {
        return ACTION_FAMILY_35_ERR_CAPACITY;
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
    /* Original rep movsd/movsb copies every byte, without a string scan. */
    memcpy(object_bytes, raw_body, decoded.body_bytes);
    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_35_OK;
}
