#include "action_family_1b.h"

#include <limits.h>
#include <string.h>

static uint16_t u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static uint32_t u32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static void put16(uint8_t *p, uint16_t value)
{
    p[0] = (uint8_t)value;
    p[1] = (uint8_t)(value >> 8);
}

static void put32(uint8_t *p, uint32_t value)
{
    p[0] = (uint8_t)value;
    p[1] = (uint8_t)(value >> 8);
    p[2] = (uint8_t)(value >> 16);
    p[3] = (uint8_t)(value >> 24);
}

static ActionFamily1bStatus validate_spans(
    const uint8_t *raw, size_t length, const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)raw;
    uintptr_t b = (uintptr_t)out;
    if (raw == NULL || out == NULL) return ACTION_FAMILY_1B_ERR_ARGUMENT;
    if (length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b)
        return ACTION_FAMILY_1B_ERR_BOUNDS;
    if (length != 0u && a < b + out_length && b < a + length)
        return ACTION_FAMILY_1B_ERR_OVERLAP;
    return ACTION_FAMILY_1B_OK;
}

/* Counts are bounded BEFORE multiplication; maximum typed size is 1,310,706
 * bytes. Subtraction checks precede every input read and pointer advance. */
static ActionFamily1bStatus decode_body(
    const uint8_t *raw, size_t length, ActionFamily1bDecoded *out)
{
    ActionFamily1bDecoded d;
    uint16_t primary;
    uint16_t secondary;
    size_t first_bytes;
    size_t last_bytes;
    size_t cursor;
    if (length < 2u) return ACTION_FAMILY_1B_ERR_BODY;
    primary = u16(raw);
    /* MOVSX WORD at 0x414732: no original nonnegative guard. */
    if (primary > INT16_MAX) return ACTION_FAMILY_1B_ERR_COUNT;
    first_bytes = (size_t)primary * ACTION_FAMILY_1B_PRIMARY_BYTES;
    if (first_bytes > length - 2u) return ACTION_FAMILY_1B_ERR_BODY;
    cursor = 2u + first_bytes;
    if (length - cursor < 24u) return ACTION_FAMILY_1B_ERR_BODY;
    secondary = u16(raw + cursor + 22u);
    /* MOVSX WORD at 0x41485c, including the HIGH byte of the count. */
    if (secondary > INT16_MAX) return ACTION_FAMILY_1B_ERR_COUNT;
    last_bytes = (size_t)secondary * ACTION_FAMILY_1B_SECONDARY_BYTES;
    if (last_bytes > length - cursor - 24u) return ACTION_FAMILY_1B_ERR_BODY;
    memset(&d, 0, sizeof(d));
    d.raw_type = ACTION_FAMILY_1B_RAW_TYPE;
    d.runtime_type = ACTION_FAMILY_1B_RUNTIME_TYPE;
    d.primary_count = (int16_t)primary;
    d.secondary_count = (int16_t)secondary;
    for (size_t i = 0u; i < 5u; ++i) d.fixed_words[i] = u16(raw + cursor + i * 2u);
    for (size_t i = 0u; i < 3u; ++i) d.fixed_dwords[i] = u32(raw + cursor + 10u + i * 4u);
    d.primary_records = raw + 2u;
    d.primary_bytes = first_bytes;
    cursor += 24u;
    d.secondary_records = raw + cursor;
    d.secondary_bytes = last_bytes;
    cursor += last_bytes;
    if ((length - cursor) % ACTION_FAMILY_1B_DEPENDENCY_BYTES != 0u)
        return ACTION_FAMILY_1B_ERR_TAIL;
    d.body_bytes = cursor;
    d.dependency_records = raw + cursor;
    d.dependency_bytes = length - cursor;
    d.dependency_count = d.dependency_bytes / ACTION_FAMILY_1B_DEPENDENCY_BYTES;
    d.available_body_bytes = length;
    memcpy(out, &d, sizeof(d));
    return ACTION_FAMILY_1B_OK;
}

ActionFamily1bStatus action_family_1b_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily1bDecoded *out)
{
    ActionFamily1bStatus status = validate_spans(raw_body, raw_body_length, out, sizeof(*out));
    return status == ACTION_FAMILY_1B_OK ? decode_body(raw_body, raw_body_length, out) : status;
}

ActionFamily1bStatus action_family_1b_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_length)
{
    ActionFamily1bDecoded d;
    ActionFamily1bStatus status = validate_spans(raw_body, raw_body_length, body_length, sizeof(*body_length));
    if (status != ACTION_FAMILY_1B_OK) return status;
    status = decode_body(raw_body, raw_body_length, &d);
    if (status == ACTION_FAMILY_1B_OK) *body_length = d.body_bytes;
    return status;
}

ActionFamily1bStatus action_family_1b_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint32_t primary_handle, uint32_t secondary_handle,
    ActionFamily1bConstructed *out)
{
    ActionFamily1bDecoded d;
    ActionFamily1bConstructed c;
    ActionFamily1bStatus status;
    if (output_handle == 0u || primary_handle == 0u || secondary_handle == 0u)
        return ACTION_FAMILY_1B_ERR_ARGUMENT;
    status = validate_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_1B_OK) return status;
    status = decode_body(raw_body, raw_body_length, &d);
    if (status != ACTION_FAMILY_1B_OK) return status;
    if (ACTION_FAMILY_1B_OBJECT_BYTES > UINT32_MAX - output_handle ||
        d.primary_bytes > UINT32_MAX - primary_handle ||
        d.secondary_bytes > UINT32_MAX - secondary_handle) return ACTION_FAMILY_1B_ERR_BOUNDS;
    memset(&c, 0, sizeof(c));
    /* 0x41470c, 0x41474d, 0x41480c/0e, 0x414838, 0x414878. */
    put16(c.object_bytes, (uint16_t)d.primary_count);
    put32(c.object_bytes + 2u, primary_handle);
    for (size_t i = 0u; i < 5u; ++i) put16(c.object_bytes + 6u + i * 2u, d.fixed_words[i]);
    for (size_t i = 0u; i < 3u; ++i) put32(c.object_bytes + 16u + i * 4u, d.fixed_dwords[i]);
    put16(c.object_bytes + 28u, (uint16_t)d.secondary_count);
    put32(c.object_bytes + 30u, secondary_handle);
    c.primary_records = d.primary_records;
    c.primary_bytes = d.primary_bytes;
    c.secondary_records = d.secondary_records;
    c.secondary_bytes = d.secondary_bytes;
    c.dependency_records = d.dependency_records;
    c.dependency_count = d.dependency_count;
    c.dependency_bytes = d.dependency_bytes;
    c.body_bytes_consumed = d.body_bytes;
    c.available_body_bytes = raw_body_length;
    c.payload_offset_before = payload_offset_before;
    c.payload_offset_after = payload_offset_before + (uint32_t)d.body_bytes;
    c.result_slot_handle = output_handle;
    c.owner_field_1c = output_handle;
    c.owner_field_20 = primary_handle;
    c.owner_field_24 = secondary_handle;
    c.output_allocation_bytes = ACTION_FAMILY_1B_OBJECT_BYTES;
    c.primary_allocation_bytes = (uint32_t)d.primary_bytes;
    c.secondary_allocation_bytes = (uint32_t)d.secondary_bytes;
    c.allocation_count = 3u;
    memcpy(out, &c, sizeof(c));
    return ACTION_FAMILY_1B_OK;
}
