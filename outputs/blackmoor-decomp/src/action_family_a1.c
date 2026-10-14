#include "action_family_a1.h"

#include <string.h>

static uint16_t read_u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static uint32_t read_u32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static void write_u16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

static void write_u32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);
    p[3] = (uint8_t)(v >> 24);
}

static int valid_span(const void *p, size_t n)
{
    return p != NULL && (uintmax_t)n <=
        (uintmax_t)UINTPTR_MAX - (uintmax_t)(uintptr_t)p;
}

static int overlap(const void *a, size_t an, const void *b, size_t bn)
{
    return an != 0u && bn != 0u && (uintptr_t)a < (uintptr_t)b + bn &&
           (uintptr_t)b < (uintptr_t)a + an;
}

static size_t bounded_nul(const uint8_t *p, size_t n)
{
    size_t i;
    for (i = 0; i < n && p[i] != 0u; ++i) {
    }
    return i;
}

static ActionFamilyA1Status validate(const uint8_t *raw, size_t length,
                                    const void *out, size_t out_bytes,
                                    size_t *body_bytes, int16_t *selector)
{
    uint16_t bits;
    int32_t signed_word;
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_A1_ERR_ARGUMENT;
    }
    if (!valid_span(raw, length) || !valid_span(out, out_bytes)) {
        return ACTION_FAMILY_A1_ERR_BOUNDS;
    }
    if (overlap(raw, length, out, out_bytes)) {
        return ACTION_FAMILY_A1_ERR_OVERLAP;
    }
    if (length < ACTION_FAMILY_A1_PREFIX_BYTES) {
        return ACTION_FAMILY_A1_ERR_BODY;
    }
    bits = read_u16(raw + 0x31u);
    signed_word = bits <= INT16_MAX ? (int32_t)bits : (int32_t)bits - 65536;
    if (signed_word != -1 && (signed_word < 0 || signed_word > 9999)) {
        return ACTION_FAMILY_A1_ERR_COUNT;
    }
    *selector = (int16_t)signed_word;
    *body_bytes = signed_word == -1 ? ACTION_FAMILY_A1_KEY_BODY_BYTES :
        ACTION_FAMILY_A1_PREFIX_BYTES + (size_t)signed_word;
    if (length < *body_bytes) {
        return ACTION_FAMILY_A1_ERR_BODY;
    }
    if (bounded_nul(raw, 33u) == 33u ||
        (signed_word == -1 && bounded_nul(raw + 51u, 33u) == 33u)) {
        return ACTION_FAMILY_A1_ERR_NAME;
    }
    if ((length - *body_bytes) % 16u != 0u) {
        return ACTION_FAMILY_A1_ERR_TAIL;
    }
    return ACTION_FAMILY_A1_OK;
}

static void decode_valid(const uint8_t *raw, size_t length, size_t body_bytes,
                         int16_t selector, ActionFamilyA1Decoded *d)
{
    memset(d, 0, sizeof(*d));
    memcpy(d->name, raw, bounded_nul(raw, 33u) + 1u);
    d->option_21 = read_u16(raw + 0x21u);
    d->word_23 = read_u32(raw + 0x23u);
    d->option_27 = read_u16(raw + 0x27u);
    d->option_29 = read_u16(raw + 0x29u);
    d->option_2b = raw[0x2bu];
    d->option_2c = read_u16(raw + 0x2cu);
    d->option_2e = read_u16(raw + 0x2eu);
    d->option_30 = raw[0x30u];
    d->text_selector = selector;
    if (selector == -1) {
        memcpy(d->text_key, raw + 51u, bounded_nul(raw + 51u, 33u) + 1u);
    } else {
        d->inline_text = raw + 51u;
        d->inline_text_bytes = (size_t)selector;
    }
    d->dependency_records = raw + body_bytes;
    d->dependency_count = (length - body_bytes) / 16u;
    d->body_bytes = body_bytes;
    d->dependency_bytes = length - body_bytes;
    d->available_body_bytes = length;
}

ActionFamilyA1Status action_family_a1_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyA1Decoded *out)
{
    size_t body_bytes;
    int16_t selector;
    ActionFamilyA1Decoded d;
    ActionFamilyA1Status status = validate(raw_body, raw_body_length, out,
                                          sizeof(*out), &body_bytes, &selector);
    if (status != ACTION_FAMILY_A1_OK) {
        return status;
    }
    decode_valid(raw_body, raw_body_length, body_bytes, selector, &d);
    memcpy(out, &d, sizeof(d));
    return ACTION_FAMILY_A1_OK;
}

ActionFamilyA1Status action_family_a1_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *resolved_text, size_t resolved_text_bytes,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyA1Constructed *out)
{
    ActionFamilyA1Decoded d;
    ActionFamilyA1Constructed result;
    size_t body_bytes;
    size_t text_bytes;
    const uint8_t *text;
    uint8_t *object;
    int16_t selector;
    ActionFamilyA1Status status = validate(raw_body, raw_body_length, out,
                                          sizeof(*out), &body_bytes, &selector);
    if (status != ACTION_FAMILY_A1_OK) {
        return status;
    }
    if (output_handle == 0u) {
        return ACTION_FAMILY_A1_ERR_ARGUMENT;
    }
    if (selector == -1) {
        if (resolved_text_bytes > ACTION_FAMILY_A1_MAX_RESOLVED_BYTES ||
            (resolved_text == NULL && resolved_text_bytes != 0u)) {
            return ACTION_FAMILY_A1_ERR_TEXT;
        }
        if (resolved_text != NULL) {
            if (!valid_span(resolved_text, resolved_text_bytes)) {
                return ACTION_FAMILY_A1_ERR_BOUNDS;
            }
            if (overlap(resolved_text, resolved_text_bytes, out, sizeof(*out))) {
                return ACTION_FAMILY_A1_ERR_OVERLAP;
            }
            if (bounded_nul(resolved_text, resolved_text_bytes) != resolved_text_bytes) {
                return ACTION_FAMILY_A1_ERR_TEXT;
            }
        }
        text = resolved_text;
        text_bytes = resolved_text_bytes;
    } else {
        if (resolved_text != NULL || resolved_text_bytes != 0u) {
            return ACTION_FAMILY_A1_ERR_ARGUMENT;
        }
        text = raw_body + 51u;
        text_bytes = (size_t)selector;
    }
    decode_valid(raw_body, raw_body_length, body_bytes, selector, &d);
    memset(&result, 0, sizeof(result));
    object = result.object_bytes;
    result.allocation_bytes = text_bytes + (selector == -1 ? 176u : 175u);
    memcpy(object, d.name, bounded_nul(d.name, 33u) + 1u);
    write_u16(object + 0x21u, d.option_21);
    write_u32(object + 0x27u, d.word_23);
    write_u16(object + 0x2bu, d.option_27);
    write_u16(object + 0x2du, d.option_29);
    object[0x90u] = d.option_2b;
    write_u16(object + 0x91u, d.option_2c);
    write_u16(object + 0xa5u, d.option_2e);
    object[0xa7u] = d.option_30;
    write_u32(object + 0x2fu, 500u);
    write_u32(object + 0x33u, 2000u);
    write_u32(object + 0x5bu, 1000u);
    write_u32(object + 0x5fu, 10u);
    object[0x87u] = 1u;
    write_u16(object + 0x97u, 1u);
    write_u16(object + 0xa8u, 2u);
    if (text_bytes != 0u) {
        memcpy(object + 0xacu, text, text_bytes);
    }
    if (selector == -1 || text_bytes != 0u) {
        memcpy(object + 0xacu + text_bytes, "<e>", 3u);
    }
    write_u16(object + 0xaau, (uint16_t)(text_bytes == 0u ? 0u : text_bytes + 3u));
    result.dependency_records = d.dependency_records;
    result.dependency_count = d.dependency_count;
    result.body_bytes_consumed = d.body_bytes;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + (uint32_t)d.body_bytes;
    result.result_slot_handle = output_handle;
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_A1_OK;
}
