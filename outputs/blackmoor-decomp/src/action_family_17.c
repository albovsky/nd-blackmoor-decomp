/* Behavioral reconstructed C from immutable original x86 loader instructions;
 * no original C++ provenance or x86 matching claim. */
#include "action_family_17.h"

#include <string.h>

static uint16_t read_u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static void write_u16(uint8_t *p, uint16_t value)
{
    p[0] = (uint8_t)value;
    p[1] = (uint8_t)(value >> 8);
}

static int span_valid(const void *p, size_t n)
{
    return p != NULL && (uintmax_t)n <=
        (uintmax_t)UINTPTR_MAX - (uintmax_t)(uintptr_t)p;
}

/* Only called after both integer address spans have been checked. */
static int overlap(const void *a, size_t na, const void *b, size_t nb)
{
    uintptr_t aa = (uintptr_t)a;
    uintptr_t bb = (uintptr_t)b;
    return na != 0u && nb != 0u && aa < bb + nb && bb < aa + na;
}

static ActionFamily17Status check_spans(
    const uint8_t *raw, size_t length, const void *out, size_t out_size)
{
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_17_ERR_ARGUMENT;
    }
    if (!span_valid(raw, length) || !span_valid(out, out_size)) {
        return ACTION_FAMILY_17_ERR_BOUNDS;
    }
    if (overlap(raw, length, out, out_size)) {
        return ACTION_FAMILY_17_ERR_OVERLAP;
    }
    return ACTION_FAMILY_17_OK;
}

static ActionFamily17Status parse_body(
    const uint8_t *raw, size_t length, ActionFamily17Decoded *decoded)
{
    uint16_t count;
    size_t typed;
    size_t i;
    if (length < ACTION_FAMILY_17_PREFIX_BYTES) {
        return ACTION_FAMILY_17_ERR_BODY;
    }
    /* MOVSX body+0x14, IMUL 18, ADD 22, MOV cx then MOVSX at 0x40b998..
     * 0x40b9a9. Reject negative counts and narrowing before dependent reads. */
    count = read_u16(raw + 0x14u);
    if (count > ACTION_FAMILY_17_MAX_COUNT) {
        return ACTION_FAMILY_17_ERR_COUNT;
    }
    typed = ACTION_FAMILY_17_PREFIX_BYTES +
        ACTION_FAMILY_17_RECORD_BYTES * (size_t)count;
    if (length < typed) {
        return ACTION_FAMILY_17_ERR_BODY;
    }
    if ((length - typed) % ACTION_FAMILY_17_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_17_ERR_TAIL;
    }
    memset(decoded, 0, sizeof(*decoded));
    for (i = 0u; i < 10u; ++i) {
        decoded->words[i] = read_u16(raw + i * 2u);
    }
    decoded->count = (int16_t)count;
    decoded->records = raw + ACTION_FAMILY_17_PREFIX_BYTES;
    decoded->dependency_records = raw + typed;
    decoded->dependency_count = (length - typed) / ACTION_FAMILY_17_DEPENDENCY_BYTES;
    decoded->dependency_bytes = length - typed;
    decoded->available_body_bytes = length;
    decoded->body_bytes = typed;
    decoded->raw_type = ACTION_FAMILY_17_RAW_TYPE;
    decoded->runtime_type = ACTION_FAMILY_17_RUNTIME_TYPE;
    return ACTION_FAMILY_17_OK;
}

ActionFamily17Status action_family_17_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily17Decoded *out)
{
    ActionFamily17Decoded decoded;
    ActionFamily17Status status = check_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status == ACTION_FAMILY_17_OK) {
        status = parse_body(raw_body, raw_body_length, &decoded);
    }
    if (status == ACTION_FAMILY_17_OK) {
        memcpy(out, &decoded, sizeof(decoded));
    }
    return status;
}

ActionFamily17Status action_family_17_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out)
{
    ActionFamily17Decoded decoded;
    ActionFamily17Status status = check_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status == ACTION_FAMILY_17_OK) {
        status = parse_body(raw_body, raw_body_length, &decoded);
    }
    if (status == ACTION_FAMILY_17_OK) {
        memcpy(out, &decoded.body_bytes, sizeof(*out));
    }
    return status;
}

ActionFamily17Status action_family_17_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object_bytes, size_t object_capacity, ActionFamily17Constructed *out)
{
    ActionFamily17Decoded decoded;
    ActionFamily17Constructed result;
    ActionFamily17Status status;
    size_t i;
    if (object_bytes == NULL || output_handle == 0u) {
        return ACTION_FAMILY_17_ERR_ARGUMENT;
    }
    status = check_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_17_OK) {
        return status;
    }
    if (!span_valid(object_bytes, object_capacity)) {
        return ACTION_FAMILY_17_ERR_BOUNDS;
    }
    if (overlap(raw_body, raw_body_length, object_bytes, object_capacity) ||
        overlap(out, sizeof(*out), object_bytes, object_capacity)) {
        return ACTION_FAMILY_17_ERR_OVERLAP;
    }
    status = parse_body(raw_body, raw_body_length, &decoded);
    if (status != ACTION_FAMILY_17_OK) {
        return status;
    }
    if (object_capacity < decoded.body_bytes) {
        return ACTION_FAMILY_17_ERR_CAPACITY;
    }
    memset(&result, 0, sizeof(result));
    result.dependency_records = decoded.dependency_records;
    result.dependency_count = decoded.dependency_count;
    result.dependency_bytes = decoded.dependency_bytes;
    result.available_body_bytes = raw_body_length;
    result.body_bytes_consumed = decoded.body_bytes;
    result.allocation_bytes = decoded.body_bytes;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;
    result.result_slot_handle = output_handle;
    result.raw_type = decoded.raw_type;
    result.runtime_type = decoded.runtime_type;
    /* Serialize the binary prefix explicitly; all fields retain their bits.
     * Together with the record copy this is the original whole-body REP copy. */
    for (i = 0u; i < 10u; ++i) {
        write_u16(object_bytes + i * 2u, decoded.words[i]);
    }
    write_u16(object_bytes + 0x14u, (uint16_t)decoded.count);
    memcpy(object_bytes + ACTION_FAMILY_17_PREFIX_BYTES, decoded.records,
        decoded.body_bytes - ACTION_FAMILY_17_PREFIX_BYTES);
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_17_OK;
}
