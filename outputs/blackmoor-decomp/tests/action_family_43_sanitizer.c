/* Valid inputs and objects occupy exact heap extents: ASan sees any overread. */
#include "action_family_43.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases;
static size_t rejected_cases;
static size_t pointer_checks;
static uint32_t random_state = UINT32_C(0x43b17e01);

static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}

static void put_word(uint8_t *raw, size_t offset, uint16_t value)
{
    raw[offset] = (uint8_t)value;
    raw[offset + 1u] = (uint8_t)(value >> 8);
}

static void check_case(uint8_t *raw, size_t length, const uint8_t *text, size_t text_bytes)
{
    uint8_t *before = malloc(length == 0u ? 1u : length);
    ActionFamily43Decoded d, d_before;
    ActionFamily43Constructed c, c_before;
    ActionFamily43Status status;
    uint32_t offset = next_random();
    assert(before != NULL);
    memcpy(before, raw, length);
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    status = action_family_43_decode(raw, length, &d);
    if (status == ACTION_FAMILY_43_OK) {
        uint8_t *object;
        size_t allocation;
        if (d.option_109 == 0u) {
            text = NULL;
            text_bytes = 0u;
        }
        assert(action_family_43_construct(raw, length, text, text_bytes, offset, 1u, NULL, 0u, &c) == ACTION_FAMILY_43_OK);
        allocation = c.allocation_bytes;
        object = malloc(allocation);
        assert(object != NULL);
        memset(object, 0xcd, allocation);
        assert(action_family_43_construct(raw, length, text, text_bytes, offset, 1u, object, allocation, &c) == ACTION_FAMILY_43_OK);
        assert(d.available_body_bytes == length && d.dependency_records == raw + d.body_bytes);
        assert(d.dependency_bytes == length - d.body_bytes && d.dependency_count == d.dependency_bytes / 16u);
        assert(c.body_bytes_consumed == d.body_bytes && c.payload_offset_after == offset + (uint32_t)d.body_bytes);
        assert(c.raw_type == 0x43u && c.runtime_type == 0x43u && c.result_slot_handle == 1u);
        assert(c.dependency_records == d.dependency_records && c.dependency_bytes == d.dependency_bytes);
        assert(c.dependency_count == d.dependency_count && c.available_body_bytes == length);
        if (d.option_109 == 0u) {
            assert(allocation == d.body_bytes && memcmp(object, raw, allocation) == 0);
            assert(c.source_word_written == 1u && c.source_word_12b_after == d.inline_visible_length);
        } else {
            assert(allocation == 301u + text_bytes);
            assert(memcmp(object, raw, 299u) == 0);
            assert(object[299] == (uint8_t)(text_bytes - 1u) && object[300] == (uint8_t)((text_bytes - 1u) >> 8));
            assert(memcmp(object + 301u, text, text_bytes) == 0);
            assert(c.source_word_written == 0u && c.source_word_12b_after == d.word_12b);
        }
        /* Capacity errors cannot mutate either output. */
        memcpy(&c_before, &c, sizeof(c));
        assert(action_family_43_construct(raw, length, text, text_bytes, offset, 1u, object, allocation - 1u, &c) == ACTION_FAMILY_43_ERR_CAPACITY);
        assert(memcmp(&c, &c_before, sizeof(c)) == 0);
        free(object);
        ++valid_cases;
    } else {
        uint8_t *object = malloc(40302u);
        assert(object != NULL);
        memset(object, 0x91, 40302u);
        assert(action_family_43_construct(raw, length, text, text_bytes, offset, 1u, object, 40302u, &c) == status);
        assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
        for (size_t i = 0u; i < 40302u; ++i) {
            assert(object[i] == 0x91u);
        }
        free(object);
        ++rejected_cases;
    }
    assert(memcmp(raw, before, length) == 0);
    free(before);
}

static uint8_t *make_body(size_t inline_bytes, size_t tail, uint16_t word, uint8_t selector)
{
    size_t length = 301u + inline_bytes + tail;
    uint8_t *raw = malloc(length);
    assert(raw != NULL);
    for (size_t i = 0u; i < length; ++i) {
        raw[i] = (uint8_t)next_random();
    }
    put_word(raw, 2u, selector == 0u ? 2u : UINT16_MAX);
    raw[265] = selector;
    memset(raw + 266u, 'k', 33u);
    raw[298] = 0u;
    put_word(raw, 299u, word);
    if (inline_bytes != 0u) {
        memset(raw + 301u, 'x', inline_bytes);
        raw[301u + (size_t)next_random() % inline_bytes] = 0u;
    }
    return raw;
}

static void check_pointers(void)
{
    uint8_t *raw = make_body(0u, 0u, 0u, 1u);
    uint8_t *text = malloc(1u);
    ActionFamily43Decoded d, db;
    ActionFamily43Constructed c, cb;
    assert(text != NULL);
    text[0] = 0u;
    memset(&d, 0xa5, sizeof(d)); memset(&c, 0x5a, sizeof(c));
    memcpy(&db, &d, sizeof(d)); memcpy(&cb, &c, sizeof(c));
    assert(action_family_43_decode(NULL, 301u, &d) == ACTION_FAMILY_43_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_43_decode(raw, 301u, NULL) == ACTION_FAMILY_43_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_43_construct(raw, 301u, text, 1u, 0u, 0u, NULL, 0u, &c) == ACTION_FAMILY_43_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_43_construct(NULL, 301u, text, 1u, 0u, 1u, NULL, 0u, &c) == ACTION_FAMILY_43_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_43_construct(raw, 301u, text, 1u, 0u, 1u, NULL, 0u, NULL) == ACTION_FAMILY_43_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_43_decode((const uint8_t *)UINTPTR_MAX, 301u, &d) == ACTION_FAMILY_43_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_43_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_43_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_43_decode(raw, 301u, (ActionFamily43Decoded *)UINTPTR_MAX) == ACTION_FAMILY_43_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_43_construct(raw, 301u, (const uint8_t *)UINTPTR_MAX, 1u, 0u, 1u, NULL, 0u, &c) == ACTION_FAMILY_43_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_43_construct(raw, 301u, text, 1u, 0u, 1u, (uint8_t *)UINTPTR_MAX, 302u, &c) == ACTION_FAMILY_43_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_43_construct(raw, 301u, text, 1u, 0u, 1u, NULL, 0u, (ActionFamily43Constructed *)UINTPTR_MAX) == ACTION_FAMILY_43_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_43_decode(raw, 301u, (ActionFamily43Decoded *)(void *)raw) == ACTION_FAMILY_43_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_43_construct(raw, 301u, text, 1u, 0u, 1u, raw, 301u, &c) == ACTION_FAMILY_43_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_43_construct(raw, 301u, text, 1u, 0u, 1u, text, 302u, &c) == ACTION_FAMILY_43_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_43_construct(raw, 301u, text, 1u, 0u, 1u, NULL, 0u, (ActionFamily43Constructed *)(void *)raw) == ACTION_FAMILY_43_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_43_construct(raw, 301u, text, 1u, 0u, 1u, (uint8_t *)(void *)&c, 302u, &c) == ACTION_FAMILY_43_ERR_OVERLAP); ++pointer_checks;
    assert(memcmp(&d, &db, sizeof(d)) == 0 && memcmp(&c, &cb, sizeof(c)) == 0);
    free(text); free(raw);
}

int main(void)
{
    uint8_t *text = malloc(40001u);
    assert(text != NULL);
    memset(text, 't', 40000u); text[40000] = 0u;
    /* All keyed word patterns are data, including signed-looking values. */
    for (uint32_t word = 0u; word <= UINT16_MAX; ++word) {
        size_t tail = (size_t)(word % 4u) * 16u;
        uint8_t *raw = make_body(0u, tail, (uint16_t)word, (uint8_t)(1u + word % 255u));
        check_case(raw, 301u + tail, text, 40001u);
        free(raw);
    }
    for (size_t i = 0u; i < 10000u; ++i) {
        size_t n = i == 0u ? 32767u : 1u + (size_t)next_random() % 1024u;
        size_t tail = (size_t)(next_random() % 10u) * 16u;
        uint8_t *raw = make_body(n, tail, (uint16_t)n, 0u);
        check_case(raw, 301u + n + tail, NULL, 0u);
        free(raw);
    }
    /* Every truncation before the fixed prefix, on exact heap extents. */
    for (size_t n = 0u; n < 301u; ++n) {
        uint8_t *raw = malloc(n == 0u ? 1u : n);
        assert(raw != NULL); memset(raw, 0, n);
        check_case(raw, n, text, 40001u); free(raw);
    }
    for (size_t n = 1u; n < 64u; ++n) {
        if (n % 16u != 0u) {
            uint8_t *raw = make_body(0u, n, 0u, 1u);
            check_case(raw, 301u+n, text, 40001u); free(raw);
        }
    }
    /* Missing inline extent and all negative count patterns. */
    for (uint32_t bits = 0u; bits <= UINT16_MAX; ++bits) {
        uint8_t *raw = make_body(0u, 0u, (uint16_t)bits, 0u);
        check_case(raw, 301u, NULL, 0u); free(raw);
    }
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t n = (size_t)(next_random() % 1024u);
        uint8_t *raw = malloc(n == 0u ? 1u : n);
        assert(raw != NULL);
        for (size_t k = 0u; k < n; ++k) { raw[k] = (uint8_t)next_random(); }
        check_case(raw, n, text, 40001u); free(raw);
    }
    check_pointers(); free(text);
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"keyed_word_patterns\":65536,"
           "\"inline_count_patterns\":65536,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
