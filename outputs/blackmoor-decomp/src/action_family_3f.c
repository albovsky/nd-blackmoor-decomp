#include "action_family_3f.h"
#include <limits.h>
#include <string.h>

static uint16_t u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | (uint16_t)((uint16_t)p[1] << 8));
}
static uint32_t u32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}
static void put16(uint8_t *p, uint16_t value)
{
    p[0] = (uint8_t)value; p[1] = (uint8_t)(value >> 8);
}
static void put32(uint8_t *p, uint32_t value)
{
    p[0] = (uint8_t)value; p[1] = (uint8_t)(value >> 8);
    p[2] = (uint8_t)(value >> 16); p[3] = (uint8_t)(value >> 24);
}
static int span_valid(const void *p, size_t n)
{
    return n <= UINTPTR_MAX - (uintptr_t)p;
}
static int overlaps(const void *a, size_t an, const void *b, size_t bn)
{
    return an != 0u && bn != 0u && (uintptr_t)a < (uintptr_t)b + bn &&
           (uintptr_t)b < (uintptr_t)a + an;
}
static size_t visible(const uint8_t *p, size_t n)
{
    const uint8_t *end = n != 0u ? memchr(p, 0, n) : NULL;
    return end != NULL ? (size_t)(end - p) : n;
}
static void copy_name(uint8_t *to, const uint8_t *from)
{
    memcpy(to, from, visible(from, 33u) + 1u);
}

ActionFamily3fStatus action_family_3f_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily3fDecoded *out)
{
    ActionFamily3fDecoded d;
    size_t cursor = ACTION_FAMILY_3F_PREFIX_BYTES;
    size_t i;
    uint16_t primary;
    uint8_t secondary;
    if (raw_body == NULL || out == NULL) return ACTION_FAMILY_3F_ERR_ARGUMENT;
    if (!span_valid(raw_body, raw_body_length) || !span_valid(out, sizeof(*out)))
        return ACTION_FAMILY_3F_ERR_BOUNDS;
    if (overlaps(raw_body, raw_body_length, out, sizeof(*out)))
        return ACTION_FAMILY_3F_ERR_OVERLAP;
    if (raw_body_length < cursor) return ACTION_FAMILY_3F_ERR_BODY;
    primary = u16(raw_body + 75u);
    if (primary > INT16_MAX) return ACTION_FAMILY_3F_ERR_COUNT;
    if (visible(raw_body, 33u) == 33u || visible(raw_body + 35u, 33u) == 33u)
        return ACTION_FAMILY_3F_ERR_NAME;
    memset(&d, 0, sizeof(d));
    d.raw_type = ACTION_FAMILY_3F_RAW_TYPE;
    d.runtime_type = ACTION_FAMILY_3F_RUNTIME_TYPE;
    copy_name(d.name, raw_body);
    copy_name(d.text_key, raw_body + 35u);
    d.option_21 = u16(raw_body + 33u);
    d.option_44 = raw_body[68u]; d.option_45 = raw_body[69u]; d.option_46 = raw_body[70u];
    d.word_47 = u16(raw_body + 71u); d.word_49 = u16(raw_body + 73u);
    d.primary_count = (int16_t)primary;
    d.primary_records = raw_body + cursor;
    for (i = 0u; i < primary; ++i) {
        size_t extent;
        uint8_t count;
        if (raw_body_length - cursor < 2u) return ACTION_FAMILY_3F_ERR_BODY;
        count = raw_body[cursor];
        if (count > INT8_MAX) return ACTION_FAMILY_3F_ERR_COUNT;
        extent = 2u + (size_t)count * 5u + 68u;
        if (extent > raw_body_length - cursor) return ACTION_FAMILY_3F_ERR_BODY;
        if (visible(raw_body + cursor + 2u + (size_t)count * 5u, 33u) == 33u ||
            visible(raw_body + cursor + 35u + (size_t)count * 5u, 33u) == 33u)
            return ACTION_FAMILY_3F_ERR_NAME;
        cursor += extent;
    }
    d.primary_bytes = cursor - ACTION_FAMILY_3F_PREFIX_BYTES;
    if (raw_body_length - cursor < 2u) return ACTION_FAMILY_3F_ERR_BODY;
    secondary = raw_body[cursor];
    if (secondary > INT8_MAX) return ACTION_FAMILY_3F_ERR_COUNT;
    d.secondary_count = (int16_t)secondary;
    cursor += 2u;
    d.secondary_records = raw_body + cursor;
    for (i = 0u; i < secondary; ++i) {
        size_t extent;
        uint8_t count;
        if (raw_body_length - cursor < 2u) return ACTION_FAMILY_3F_ERR_BODY;
        count = raw_body[cursor];
        if (count > INT8_MAX) return ACTION_FAMILY_3F_ERR_COUNT;
        extent = 2u + (size_t)count * 5u + 4u;
        if (extent > raw_body_length - cursor) return ACTION_FAMILY_3F_ERR_BODY;
        cursor += extent;
    }
    d.secondary_bytes = (size_t)((raw_body + cursor) - d.secondary_records);
    if ((raw_body_length - cursor) % ACTION_FAMILY_3F_DEPENDENCY_BYTES != 0u)
        return ACTION_FAMILY_3F_ERR_TAIL;
    d.body_bytes = cursor;
    d.available_body_bytes = raw_body_length;
    d.dependency_records = raw_body + cursor;
    d.dependency_bytes = raw_body_length - cursor;
    d.dependency_count = d.dependency_bytes / ACTION_FAMILY_3F_DEPENDENCY_BYTES;
    memcpy(out, &d, sizeof(d));
    return ACTION_FAMILY_3F_OK;
}

ActionFamily3fStatus action_family_3f_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_length)
{
    ActionFamily3fDecoded d;
    ActionFamily3fStatus status;
    if (raw_body == NULL || body_length == NULL) return ACTION_FAMILY_3F_ERR_ARGUMENT;
    if (!span_valid(raw_body, raw_body_length) || !span_valid(body_length, sizeof(*body_length)))
        return ACTION_FAMILY_3F_ERR_BOUNDS;
    if (overlaps(raw_body, raw_body_length, body_length, sizeof(*body_length)))
        return ACTION_FAMILY_3F_ERR_OVERLAP;
    status = action_family_3f_decode(raw_body, raw_body_length, &d);
    if (status == ACTION_FAMILY_3F_OK) *body_length = d.body_bytes;
    return status;
}

/* All counts are bounded by their original signed widths. The largest possible
 * layout is below 2^32 (32767 primary records, 127 conditions per record), so
 * this alignment/addition cannot overflow size_t on the ARM64 target. */
static size_t allocate_offset(size_t *cursor, size_t size)
{
    size_t offset = (*cursor + 3u) & ~(size_t)3u;
    *cursor = offset + size;
    return offset;
}
static void copy_text(uint8_t *to, const ActionFamily3fText *text)
{
    size_t n = visible(text->bytes, text->length);
    if (n != 0u) memcpy(to, text->bytes, n);
    to[n] = 0u;
}

ActionFamily3fStatus action_family_3f_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const ActionFamily3fText *resolved_text, size_t resolved_text_count,
    uint32_t payload_offset_before, uint32_t arena_handle,
    uint8_t *arena, size_t arena_capacity, ActionFamily3fConstructed *out)
{
    ActionFamily3fDecoded d;
    ActionFamily3fConstructed value;
    ActionFamily3fStatus status;
    size_t cursor = ACTION_FAMILY_3F_OBJECT_BYTES;
    size_t allocation_count = 1u;
    size_t primary_offset = SIZE_MAX;
    size_t secondary_offset = SIZE_MAX;
    size_t i;
    size_t text_bytes;
    const uint8_t *record;
    if (raw_body == NULL || out == NULL || resolved_text == NULL || arena_handle == 0u ||
        (arena == NULL && arena_capacity != 0u)) return ACTION_FAMILY_3F_ERR_ARGUMENT;
    if (resolved_text_count > SIZE_MAX / sizeof(*resolved_text)) return ACTION_FAMILY_3F_ERR_BOUNDS;
    text_bytes = resolved_text_count * sizeof(*resolved_text);
    if (!span_valid(raw_body, raw_body_length) || !span_valid(out, sizeof(*out)) ||
        !span_valid(resolved_text, text_bytes) || !span_valid(arena, arena_capacity))
        return ACTION_FAMILY_3F_ERR_BOUNDS;
    if (overlaps(raw_body, raw_body_length, out, sizeof(*out)) ||
        overlaps(raw_body, raw_body_length, arena, arena_capacity) ||
        overlaps(resolved_text, text_bytes, out, sizeof(*out)) ||
        overlaps(resolved_text, text_bytes, arena, arena_capacity) ||
        overlaps(out, sizeof(*out), arena, arena_capacity)) return ACTION_FAMILY_3F_ERR_OVERLAP;
    status = action_family_3f_decode(raw_body, raw_body_length, &d);
    if (status != ACTION_FAMILY_3F_OK) return status;
    if (resolved_text_count != (size_t)d.primary_count + 1u) return ACTION_FAMILY_3F_ERR_TEXT;
    for (i = 0u; i < resolved_text_count; ++i) {
        const ActionFamily3fText *t = resolved_text + i;
        if (t->bytes == NULL && t->length != 0u) return ACTION_FAMILY_3F_ERR_ARGUMENT;
        if (!span_valid(t->bytes, t->length)) return ACTION_FAMILY_3F_ERR_BOUNDS;
        if (overlaps(t->bytes, t->length, out, sizeof(*out)) ||
            overlaps(t->bytes, t->length, arena, arena_capacity)) return ACTION_FAMILY_3F_ERR_OVERLAP;
        if (visible(t->bytes, t->length) > (i == 0u ? 1499u : 399u)) return ACTION_FAMILY_3F_ERR_TEXT;
    }
    if (d.primary_count != 0) {
        primary_offset = allocate_offset(&cursor, (size_t)d.primary_count * ACTION_FAMILY_3F_PRIMARY_OBJECT_BYTES);
        ++allocation_count;
    }
    record = d.primary_records;
    for (i = 0u; i < (size_t)d.primary_count; ++i) {
        size_t n = (size_t)record[0] * 5u;
        if (n != 0u) { (void)allocate_offset(&cursor, n); ++allocation_count; }
        record += 70u + n;
    }
    if (d.secondary_count != 0) {
        secondary_offset = allocate_offset(&cursor, (size_t)d.secondary_count * 10u);
        ++allocation_count;
    }
    record = d.secondary_records;
    for (i = 0u; i < (size_t)d.secondary_count; ++i) {
        size_t n = (size_t)record[0] * 5u;
        if (n != 0u) { (void)allocate_offset(&cursor, n); ++allocation_count; }
        record += 6u + n;
    }
    if (cursor > UINT32_MAX - arena_handle) return ACTION_FAMILY_3F_ERR_BOUNDS;
    if (arena != NULL && arena_capacity < cursor) return ACTION_FAMILY_3F_ERR_CAPACITY;
    memset(&value, 0, sizeof(value));
    value.arena_bytes = cursor; value.allocation_count = allocation_count;
    value.primary_offset = primary_offset; value.secondary_offset = secondary_offset;
    value.dependency_records = d.dependency_records; value.dependency_count = d.dependency_count;
    value.body_bytes_consumed = d.body_bytes;
    value.payload_offset_before = payload_offset_before;
    value.payload_offset_after = payload_offset_before + (uint32_t)d.body_bytes;
    value.result_slot_handle = arena_handle;
    if (arena != NULL) {
        copy_name(arena, d.name);
        put16(arena + 0x21u, 12u); put16(arena + 0x23u, 2u);
        put16(arena + 0x25u, 1u); put16(arena + 0x27u, 1u); put32(arena + 0x29u, 1u);
        put16(arena + 0x2du, d.option_21); put16(arena + 0x2fu, d.option_21);
        put16(arena + 0x774u, d.option_21); put16(arena + 0x776u, d.option_21);
        memcpy(arena + 0x747u, "dummy", 6u);
        put16(arena + 0x768u, 13u); put16(arena + 0x76au, 2u);
        put16(arena + 0x76cu, 1u); put16(arena + 0x76eu, 1u); put32(arena + 0x770u, 1u);
        arena[0x778u] = 0u; arena[0x77cu] = 2u;
        put16(arena + 0x781u, 0u); put16(arena + 0x783u, 1u);
        put32(arena + 0x785u, 0u); put32(arena + 0x789u, 0u); put32(arena + 0x78du, 1u);
        put16(arena + 0x791u, 2u);
        arena[0x779u] = d.option_44; arena[0x77au] = d.option_45; arena[0x77bu] = d.option_46;
        put16(arena + 0x77du, d.word_47); put16(arena + 0x77fu, d.word_49);
        copy_text(arena + 0x16bu, resolved_text);
        put16(arena + 0x793u, (uint16_t)d.primary_count);
        put32(arena + 0x795u, primary_offset == SIZE_MAX ? 0u : arena_handle + (uint32_t)primary_offset);
        put16(arena + 0x799u, 0u); put32(arena + 0x79bu, 0u);
        put16(arena + 0x79fu, (uint16_t)d.secondary_count);
        put32(arena + 0x7a1u, secondary_offset == SIZE_MAX ? 0u : arena_handle + (uint32_t)secondary_offset);
        cursor = ACTION_FAMILY_3F_OBJECT_BYTES;
        if (d.primary_count != 0) (void)allocate_offset(&cursor, (size_t)d.primary_count * ACTION_FAMILY_3F_PRIMARY_OBJECT_BYTES);
        record = d.primary_records;
        for (i = 0u; i < (size_t)d.primary_count; ++i) {
            uint8_t *p = arena + primary_offset + i * ACTION_FAMILY_3F_PRIMARY_OBJECT_BYTES;
            size_t n = (size_t)record[0] * 5u;
            size_t cond = n != 0u ? allocate_offset(&cursor, n) : SIZE_MAX;
            const uint8_t *key = record + 2u + n;
            put16(p, record[0]); put32(p + 2u, cond == SIZE_MAX ? 0u : arena_handle + (uint32_t)cond);
            if (n != 0u) memcpy(arena + cond, record + 2u, n);
            p[0x1b7u] = 0u; put16(p + 0x1bau, 0u); put16(p + 0x1bcu, 0u);
            put16(p + 0x1beu, 1u); put32(p + 0x1c0u, 0u); put32(p + 0x1c4u, 0u);
            put32(p + 0x1c8u, 1u); put16(p + 0x1ccu, UINT16_MAX);
            p[0x1ceu] = 1u; put16(p + 0x1cfu, 2u);
            copy_text(p + 6u, resolved_text + i + 1u);
            copy_name(p + 0x196u, key + 33u); put16(p + 0x1b8u, u16(key + 66u));
            record += 70u + n;
        }
        if (d.secondary_count != 0) (void)allocate_offset(&cursor, (size_t)d.secondary_count * 10u);
        record = d.secondary_records;
        for (i = 0u; i < (size_t)d.secondary_count; ++i) {
            uint8_t *p = arena + secondary_offset + i * 10u;
            size_t n = (size_t)record[0] * 5u;
            size_t cond = n != 0u ? allocate_offset(&cursor, n) : SIZE_MAX;
            put16(p, record[0]); put32(p + 2u, cond == SIZE_MAX ? 0u : arena_handle + (uint32_t)cond);
            if (n != 0u) memcpy(arena + cond, record + 2u, n);
            put32(p + 6u, u32(record + 2u + n));
            record += 6u + n;
        }
    }
    memcpy(out, &value, sizeof(value));
    return ACTION_FAMILY_3F_OK;
}
