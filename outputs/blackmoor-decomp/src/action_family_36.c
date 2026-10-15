#include "action_family_36.h"

#include <limits.h>
#include <string.h>

static uint16_t read_u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static int16_t signed_word(uint16_t bits)
{
    return bits <= INT16_MAX ? (int16_t)bits :
        (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static int16_t read_i16(const uint8_t *p)
{
    return signed_word(read_u16(p));
}

/* Checks arithmetic and overlap, not arbitrary-address mappedness. */
static ActionFamily36Status check_spans(const void *input, size_t length,
                                       const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)input;
    uintptr_t b = (uintptr_t)out;
    if (input == NULL || out == NULL) {
        return ACTION_FAMILY_36_ERR_ARGUMENT;
    }
    if (length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b) {
        return ACTION_FAMILY_36_ERR_BOUNDS;
    }
    if (length != 0u && a < b + out_length && b < a + length) {
        return ACTION_FAMILY_36_ERR_OVERLAP;
    }
    return ACTION_FAMILY_36_OK;
}

static ActionFamily36Status validate_body(const uint8_t *raw, size_t length,
                                         const void *out, size_t out_length,
                                         size_t *body, size_t *primary, size_t *secondary)
{
    int16_t p, s;
    ActionFamily36Status status = check_spans(raw, length, out, out_length);
    if (status != ACTION_FAMILY_36_OK) {
        return status;
    }
    if (length < ACTION_FAMILY_36_PREFIX_BYTES) {
        return ACTION_FAMILY_36_ERR_BODY;
    }
    /* MOVSX/SUB/ADD then MOV word at 0x488f52..0x488f84; subsequent
     * MOVSX/SHL feeds REP MOVSD. The narrowing is essential at wrap edges. */
    if (read_u16(raw + 0x29u) == 2u) {
        int32_t difference = (int32_t)read_i16(raw + 0x35u) -
                            (int32_t)read_i16(raw + 0x33u) + 1;
        p = signed_word((uint16_t)difference);
    } else {
        p = read_i16(raw + 0x2bu);
    }
    s = read_i16(raw + 0xaau); /* MOVSX/IMUL 38 at 0x488fda. */
    if (p < 0 || p > (int16_t)ACTION_FAMILY_36_MAX_PRIMARY ||
        s < 0 || s > (int16_t)ACTION_FAMILY_36_MAX_SECONDARY) {
        return ACTION_FAMILY_36_ERR_COUNT;
    }
    *primary = (size_t)p;
    *secondary = (size_t)s;
    *body = ACTION_FAMILY_36_PREFIX_BYTES +
        *primary * ACTION_FAMILY_36_PRIMARY_BYTES +
        *secondary * ACTION_FAMILY_36_SECONDARY_BYTES;
    if (length < *body) {
        return ACTION_FAMILY_36_ERR_BODY;
    }
    if ((length - *body) % ACTION_FAMILY_36_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_36_ERR_TAIL;
    }
    return ACTION_FAMILY_36_OK;
}

static void decode_validated(const uint8_t *raw, size_t length,
                             size_t body, size_t primary, size_t secondary,
                             ActionFamily36Decoded *d)
{
    memset(d, 0, sizeof(*d));
    memcpy(d->prefix_bytes, raw, ACTION_FAMILY_36_PREFIX_BYTES);
    d->option_29 = read_u16(raw + 0x29u);
    d->word_2b = read_i16(raw + 0x2bu);
    d->word_33 = read_i16(raw + 0x33u);
    d->word_35 = read_i16(raw + 0x35u);
    d->word_aa = read_i16(raw + 0xaau);
    d->primary_records = raw + ACTION_FAMILY_36_PREFIX_BYTES;
    d->primary_count = primary;
    d->secondary_records = d->primary_records + primary * ACTION_FAMILY_36_PRIMARY_BYTES;
    d->secondary_count = secondary;
    d->dependency_records = raw + body;
    d->dependency_bytes = length - body;
    d->dependency_count = d->dependency_bytes / ACTION_FAMILY_36_DEPENDENCY_BYTES;
    d->available_body_bytes = length;
    d->body_bytes = body;
}

ActionFamily36Status action_family_36_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily36Decoded *out)
{
    ActionFamily36Decoded decoded;
    size_t body, primary, secondary;
    ActionFamily36Status status = validate_body(raw_body, raw_body_length,
        out, sizeof(*out), &body, &primary, &secondary);
    if (status != ACTION_FAMILY_36_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, body, primary, secondary, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_36_OK;
}

ActionFamily36Status action_family_36_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_length)
{
    size_t body, primary, secondary;
    ActionFamily36Status status = validate_body(raw_body, raw_body_length,
        body_length, sizeof(*body_length), &body, &primary, &secondary);
    if (status == ACTION_FAMILY_36_OK) {
        *body_length = body;
    }
    return status;
}

ActionFamily36Status action_family_36_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *allocation_before, size_t allocation_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily36Constructed *out)
{
    ActionFamily36Decoded d;
    ActionFamily36Constructed result;
    size_t body, primary, secondary;
    ActionFamily36Status status;
    if (raw_body == NULL || allocation_before == NULL || out == NULL || output_handle == 0u) {
        return ACTION_FAMILY_36_ERR_ARGUMENT;
    }
    if (allocation_length != ACTION_FAMILY_36_OBJECT_BYTES) {
        return ACTION_FAMILY_36_ERR_ALLOCATION;
    }
    status = check_spans(allocation_before, allocation_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_36_OK) {
        return status;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out), &body, &primary, &secondary);
    if (status != ACTION_FAMILY_36_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, body, primary, secondary, &d);
    memset(&result, 0, sizeof(result));
    memcpy(result.object_bytes, allocation_before, ACTION_FAMILY_36_OBJECT_BYTES);
    /* 0x488f2a, 0x488fa5/0x488fac, 0x488ffa/0x489001, in original order.
     * No clear, field synthesis or string copy occurs in this constructor. */
    memcpy(result.object_bytes, d.prefix_bytes, ACTION_FAMILY_36_PREFIX_BYTES);
    memcpy(result.object_bytes + ACTION_FAMILY_36_PREFIX_BYTES,
           d.primary_records, primary * ACTION_FAMILY_36_PRIMARY_BYTES);
    memcpy(result.object_bytes + ACTION_FAMILY_36_SECONDARY_OFFSET,
           d.secondary_records, secondary * ACTION_FAMILY_36_SECONDARY_BYTES);
    result.dependency_records = d.dependency_records;
    result.dependency_count = d.dependency_count;
    result.dependency_bytes = d.dependency_bytes;
    result.available_body_bytes = raw_body_length;
    result.body_bytes_consumed = body;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + (uint32_t)body;
    result.owner_links.output_handle = output_handle;
    result.owner_links.result_slot_handle = output_handle;
    result.owner_links.owner_slot_1c_handle = output_handle;
    result.owner_links.owner_slot_20_handle = output_handle;
    result.owner_links.output_allocation_bytes = ACTION_FAMILY_36_OBJECT_BYTES;
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_36_OK;
}
