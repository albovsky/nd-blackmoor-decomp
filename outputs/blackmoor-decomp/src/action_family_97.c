#include "action_family_97.h"

#include <limits.h>
#include <string.h>

static uint16_t u16le(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | (uint16_t)((uint16_t)p[1] << 8));
}

static int16_t i16le(const uint8_t *p)
{
    uint16_t value = u16le(p);
    /* Avoid implementation-defined unsigned-to-signed narrowing. */
    int32_t wide = value <= INT16_MAX ? (int32_t)value : (int32_t)value - 65536;
    return (int16_t)wide;
}

static uint32_t u32le(const uint8_t *p)
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

static int span_valid(const void *p, size_t length)
{
    return length <= UINTPTR_MAX - (uintptr_t)p;
}

static int overlaps(const void *a, size_t a_length, const void *b, size_t b_length)
{
    uintptr_t aa = (uintptr_t)a;
    uintptr_t bb = (uintptr_t)b;
    return a_length != 0u && b_length != 0u &&
           aa < bb + b_length && bb < aa + a_length;
}

static size_t visible_length(const uint8_t *p, size_t length)
{
    const uint8_t *end = memchr(p, 0, length);
    return end != NULL ? (size_t)(end - p) : length;
}

ActionFamily97Status action_family_97_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily97Decoded *out)
{
    ActionFamily97Decoded value;
    size_t fixed_offset;
    size_t cursor;
    size_t entry_sum = 0u;
    size_t i;
    int16_t count;

    if (raw_body == NULL || out == NULL) {
        return ACTION_FAMILY_97_ERR_ARGUMENT;
    }
    if (!span_valid(raw_body, raw_body_length) || !span_valid(out, sizeof(*out))) {
        return ACTION_FAMILY_97_ERR_BOUNDS;
    }
    if (overlaps(raw_body, raw_body_length, out, sizeof(*out))) {
        return ACTION_FAMILY_97_ERR_OVERLAP;
    }
    if (raw_body_length < 2u) {
        return ACTION_FAMILY_97_ERR_BODY;
    }
    count = i16le(raw_body);
    if (count < 1 || count > (int16_t)ACTION_FAMILY_97_MAX_COUNT) {
        return ACTION_FAMILY_97_ERR_COUNT;
    }
    fixed_offset = 2u + 33u * ((size_t)count - 1u);
    cursor = fixed_offset + 46u;
    if (cursor > raw_body_length) {
        return ACTION_FAMILY_97_ERR_BODY;
    }
    memset(&value, 0, sizeof(value));
    value.raw_type = ACTION_FAMILY_97_RAW_TYPE;
    value.runtime_type = ACTION_FAMILY_97_RUNTIME_TYPE;
    value.count = count;
    for (i = 0u; i < (size_t)count; ++i) {
        const uint8_t *name = raw_body + 2u + 33u * i;
        if (memchr(name, 0, 33u) == NULL) {
            return ACTION_FAMILY_97_ERR_NAME;
        }
        memcpy(value.names[i], name, 33u);
    }
    value.word_21 = u16le(raw_body + fixed_offset + 0x21u);
    value.word_23 = u32le(raw_body + fixed_offset + 0x23u);
    value.word_27 = u16le(raw_body + fixed_offset + 0x27u);
    value.word_29 = u16le(raw_body + fixed_offset + 0x29u);
    value.option_2b = raw_body[fixed_offset + 0x2bu];
    value.word_2c = u16le(raw_body + fixed_offset + 0x2cu);
    for (i = 0u; i < (size_t)count; ++i) {
        int16_t selector;
        size_t data_bytes;
        size_t extent;
        if (raw_body_length - cursor < 2u) {
            return ACTION_FAMILY_97_ERR_BODY;
        }
        selector = i16le(raw_body + cursor);
        if (selector < -1) {
            return ACTION_FAMILY_97_ERR_SELECTOR;
        }
        data_bytes = selector == -1 ? 33u : (size_t)selector;
        extent = 2u + data_bytes;
        if (extent > (size_t)INT16_MAX - entry_sum) {
            return ACTION_FAMILY_97_ERR_BOUNDS;
        }
        if (extent > raw_body_length - cursor) {
            return ACTION_FAMILY_97_ERR_BODY;
        }
        if (selector == -1 && memchr(raw_body + cursor + 2u, 0, 33u) == NULL) {
            return ACTION_FAMILY_97_ERR_NAME;
        }
        value.entries[i].selector = selector;
        value.entries[i].bytes = raw_body + cursor + 2u;
        value.entries[i].length = data_bytes;
        value.entries[i].body_offset = cursor;
        entry_sum += extent;
        cursor += extent;
    }
    if ((raw_body_length - cursor) % ACTION_FAMILY_97_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_97_ERR_TAIL;
    }
    value.body_bytes = cursor;
    value.available_body_bytes = raw_body_length;
    value.dependency_records = raw_body + cursor;
    value.dependency_bytes = raw_body_length - cursor;
    value.dependency_count = value.dependency_bytes / ACTION_FAMILY_97_DEPENDENCY_BYTES;
    memcpy(out, &value, sizeof(value));
    return ACTION_FAMILY_97_OK;
}

ActionFamily97Status action_family_97_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_length)
{
    ActionFamily97Decoded value;
    ActionFamily97Status status;
    if (raw_body == NULL || body_length == NULL) {
        return ACTION_FAMILY_97_ERR_ARGUMENT;
    }
    if (!span_valid(raw_body, raw_body_length) ||
        !span_valid(body_length, sizeof(*body_length))) {
        return ACTION_FAMILY_97_ERR_BOUNDS;
    }
    if (overlaps(raw_body, raw_body_length, body_length, sizeof(*body_length))) {
        return ACTION_FAMILY_97_ERR_OVERLAP;
    }
    status = action_family_97_decode(raw_body, raw_body_length, &value);
    if (status == ACTION_FAMILY_97_OK) {
        *body_length = value.body_bytes;
    }
    return status;
}

/* FUN_00410f99's writes, after original loader zeroes the allocation. The
 * name copy is overwritten by the selected 33-byte name immediately after
 * the helper, so only its final state is written here. */
static void defaults(uint8_t *p, const ActionFamily97Decoded *d)
{
    put16(p + 0x21u, d->word_21);
    put32(p + 0x27u, d->word_23);
    put16(p + 0x2bu, d->word_27);
    put16(p + 0x2du, d->word_29);
    p[0x90u] = d->option_2b;
    put16(p + 0x91u, d->word_2c);
    put16(p + 0xa5u, UINT16_MAX);
    p[0xa7u] = 1u;
    put32(p + 0x2fu, 500u);
    put32(p + 0x33u, 2000u);
    put32(p + 0x5bu, 1000u);
    put32(p + 0x5fu, 10u);
    p[0x87u] = 1u;
    put16(p + 0x97u, 1u);
    put16(p + 0xa8u, 2u);
}

ActionFamily97Status action_family_97_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t random_state_before, uint32_t payload_offset_before,
    ActionFamily97AutoTextLookup lookup, void *lookup_context,
    uint8_t *payload, size_t payload_capacity, ActionFamily97Constructed *out)
{
    static const char missing_prefix[] =
        "Game Error (please contact Tech Support) missing auto text: ";
    static const char missing_suffix[] = "<n>";
    ActionFamily97Decoded decoded;
    ActionFamily97Constructed value;
    ActionFamily97Status status;
    const ActionFamily97Entry *entry;
    const uint8_t *text = NULL;
    size_t text_length = 0u;
    size_t allocation;
    size_t i;
    int selected = -1;
    uint8_t missing[sizeof(missing_prefix) + 32u + sizeof(missing_suffix)];
    int auto_text;
    int append_marker;

    if (out == NULL || raw_body == NULL || (payload == NULL && payload_capacity != 0u)) {
        return ACTION_FAMILY_97_ERR_ARGUMENT;
    }
    if (!span_valid(raw_body, raw_body_length) || !span_valid(out, sizeof(*out)) ||
        !span_valid(payload, payload_capacity)) {
        return ACTION_FAMILY_97_ERR_BOUNDS;
    }
    if (overlaps(raw_body, raw_body_length, out, sizeof(*out)) ||
        overlaps(raw_body, raw_body_length, payload, payload_capacity) ||
        overlaps(payload, payload_capacity, out, sizeof(*out))) {
        return ACTION_FAMILY_97_ERR_OVERLAP;
    }
    status = action_family_97_decode(raw_body, raw_body_length, &decoded);
    if (status != ACTION_FAMILY_97_OK) {
        return status;
    }
    memset(&value, 0, sizeof(value));
    memcpy(value.names_after, decoded.names, sizeof(value.names_after));
    value.random_state_before = random_state_before;
    value.random_state_after = random_state_before;
    for (i = 0u; i < (size_t)decoded.count; ++i) {
        uint8_t *name = value.names_after[i];
        if (name[0] == (uint8_t)'*') {
            size_t length = visible_length(name, 33u);
            memmove(name, name + 1u, length); /* Includes the shifted NUL. */
            selected = (int)i;
        }
    }
    if (selected < 0) {
        uint32_t next = random_state_before * UINT32_C(214013) + UINT32_C(2531011);
        selected = (int)(((next >> 16) & UINT32_C(32767)) % (uint32_t)decoded.count);
        value.random_state_after = next;
        value.random_advanced = 1u;
    }
    entry = &decoded.entries[(size_t)selected];
    auto_text = entry->selector == -1;
    append_marker = auto_text || entry->selector > 0;
    if (auto_text) {
        ActionFamily97LookupStatus lookup_status;
        size_t key_length = visible_length(entry->bytes, 33u);
        if (lookup == NULL) {
            return ACTION_FAMILY_97_ERR_LOOKUP;
        }
        lookup_status = lookup(lookup_context, entry->bytes, key_length, &text, &text_length);
        if (lookup_status == ACTION_FAMILY_97_LOOKUP_MISSING) {
            size_t prefix_length = sizeof(missing_prefix) - 1u;
            memcpy(missing, missing_prefix, prefix_length);
            memcpy(missing + prefix_length, entry->bytes, key_length);
            memcpy(missing + prefix_length + key_length, missing_suffix, sizeof(missing_suffix));
            text = missing;
            text_length = prefix_length + key_length + sizeof(missing_suffix) - 1u;
        } else if (lookup_status != ACTION_FAMILY_97_LOOKUP_FOUND ||
                   (text == NULL && text_length != 0u)) {
            return ACTION_FAMILY_97_ERR_LOOKUP;
        } else {
            if (!span_valid(text, text_length)) {
                return ACTION_FAMILY_97_ERR_BOUNDS;
            }
            if (overlaps(text, text_length, out, sizeof(*out)) ||
                overlaps(text, text_length, payload, payload_capacity)) {
                return ACTION_FAMILY_97_ERR_OVERLAP;
            }
            if (text_length != 0u) {
                text_length = visible_length(text, text_length);
            }
        }
    } else {
        text = entry->bytes;
        text_length = entry->length;
    }
    /* Both the allocation and text offset use signed 16-bit widening in the
     * original. Reject every wrapped/negative allocation before mutation. */
    if (text_length > ACTION_FAMILY_97_MAX_ALLOCATION - 172u -
                      (auto_text ? 1u : 0u) - (append_marker ? 3u : 0u)) {
        return ACTION_FAMILY_97_ERR_BOUNDS;
    }
    allocation = 172u + text_length + (auto_text ? 1u : 0u) + (append_marker ? 3u : 0u);
    if (payload != NULL && payload_capacity < allocation) {
        return ACTION_FAMILY_97_ERR_CAPACITY;
    }
    value.selected_index = (uint16_t)selected;
    value.selector = entry->selector;
    value.raw_type = decoded.raw_type;
    value.runtime_type = decoded.runtime_type;
    value.payload_offset_before = payload_offset_before;
    value.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;
    value.allocation_bytes = allocation;
    value.body_bytes_consumed = decoded.body_bytes;
    value.dependency_records = decoded.dependency_records;
    value.dependency_count = decoded.dependency_count;
    value.dependency_bytes = decoded.dependency_bytes;
    if (payload != NULL) {
        memset(payload, 0, allocation);
        defaults(payload, &decoded);
        memcpy(payload, value.names_after[(size_t)selected], 33u);
        put16(payload + 0xaau, (uint16_t)(text_length + (append_marker ? 3u : 0u)));
        if (text_length != 0u) {
            memcpy(payload + 0xacu, text, text_length);
        }
        if (append_marker) {
            memcpy(payload + 0xacu + text_length, "<e>", 3u);
        }
    }
    memcpy(out, &value, sizeof(value));
    return ACTION_FAMILY_97_OK;
}
