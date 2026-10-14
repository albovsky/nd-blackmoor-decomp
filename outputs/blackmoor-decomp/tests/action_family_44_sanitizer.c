/* Exact-size heap input, text and object spans expose one-byte overreads. */
#include "action_family_44.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases, rejected_cases, pointer_checks;
static uint32_t state = UINT32_C(0x44b17e01);

static uint32_t next_random(void)
{
    state = state * UINT32_C(1664525) + UINT32_C(1013904223);
    return state;
}

static void put16(uint8_t *p, uint16_t word)
{
    p[0] = (uint8_t)word;
    p[1] = (uint8_t)(word >> 8);
}

static void check(const uint8_t *source, size_t length, ActionFamily44Status expected)
{
    uint8_t *raw = malloc(length == 0u ? 1u : length);
    uint8_t *text = malloc(4u);
    ActionFamily44Decoded decoded, d_before;
    ActionFamily44Constructed built, b_before;
    size_t body_bytes = SIZE_MAX;
    uint32_t offset = next_random();
    assert(raw != NULL && text != NULL);
    memcpy(raw, source, length);
    memcpy(text, "abc", 4u);
    memset(&decoded, 0xa5, sizeof(decoded));
    memset(&built, 0x5a, sizeof(built));
    memcpy(&d_before, &decoded, sizeof(decoded));
    memcpy(&b_before, &built, sizeof(built));
    assert(action_family_44_decode(raw, length, &decoded) == expected);
    assert(action_family_44_body_length(raw, length, &body_bytes) == expected);
    assert(action_family_44_construct(raw, length, text, 4u, offset, UINT32_C(0x440001),
                                     NULL, 0u, &built) == expected);
    if (expected == ACTION_FAMILY_44_OK) {
        size_t expected_body = raw[492u] == 0u ? 528u +
            (size_t)((uint16_t)raw[526u] | (uint16_t)((uint16_t)raw[527u] << 8)) : 528u;
        uint8_t *object = malloc(built.object_bytes);
        assert(object != NULL);
        memset(object, 0xcd, built.object_bytes);
        assert(body_bytes == expected_body && decoded.body_bytes == expected_body);
        assert(decoded.dependency_count == (length - expected_body) / 16u);
        assert(decoded.dependency_records == raw + expected_body);
        assert(action_family_44_construct(raw, length, text, 4u, offset, UINT32_C(0x440001),
                                         object, built.object_bytes, &built) == ACTION_FAMILY_44_OK);
        assert(built.payload_offset_after == offset + (uint32_t)expected_body);
        assert(built.result_slot_handle == UINT32_C(0x440001));
        if (raw[492u] == 0u) {
            assert(built.object_bytes == expected_body && memcmp(object, raw, expected_body) == 0);
            assert(built.source_word_20e_written == 1u);
        } else {
            assert(built.object_bytes == 532u && memcmp(object, raw, 526u) == 0);
            assert(object[526u] == 3u && object[527u] == 0u);
            assert(memcmp(object + 528u, text, 4u) == 0);
            assert(built.source_word_20e_written == 0u);
        }
        free(object);
        ++valid_cases;
    } else {
        assert(memcmp(&decoded, &d_before, sizeof(decoded)) == 0);
        assert(memcmp(&built, &b_before, sizeof(built)) == 0 && body_bytes == SIZE_MAX);
        ++rejected_cases;
    }
    assert(memcmp(raw, source, length) == 0);
    free(text);
    free(raw);
}

static void check_pointers(const uint8_t *source)
{
    uint8_t *raw = malloc(528u), *object = malloc(532u), *text = malloc(4u);
    ActionFamily44Decoded d, before_d;
    ActionFamily44Constructed c, before_c;
    size_t n = SIZE_MAX;
    assert(raw != NULL && object != NULL && text != NULL);
    memcpy(raw, source, 528u); memcpy(text, "abc", 4u);
    memset(&d, 0xa5, sizeof(d)); memset(&c, 0x5a, sizeof(c)); memset(object, 0xcd, 532u);
    memcpy(&before_d, &d, sizeof(d)); memcpy(&before_c, &c, sizeof(c));
    assert(action_family_44_decode(NULL, 528u, &d) == ACTION_FAMILY_44_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_44_decode(raw, 528u, NULL) == ACTION_FAMILY_44_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_44_body_length(raw, 528u, NULL) == ACTION_FAMILY_44_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_44_decode((const uint8_t *)UINTPTR_MAX, 528u, &d) == ACTION_FAMILY_44_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_44_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_44_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_44_decode(raw, 528u, (ActionFamily44Decoded *)UINTPTR_MAX) == ACTION_FAMILY_44_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_44_decode((const uint8_t *)&d, 528u, &d) == ACTION_FAMILY_44_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_44_construct(raw, 528u, text, 4u, 0u, 0u, object, 532u, &c) == ACTION_FAMILY_44_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_44_construct(raw, 528u, NULL, 0u, 0u, 1u, object, 532u, &c) == ACTION_FAMILY_44_ERR_TEXT); ++pointer_checks;
    assert(action_family_44_construct(raw, 528u, text, 3u, 0u, 1u, object, 532u, &c) == ACTION_FAMILY_44_ERR_TEXT); ++pointer_checks;
    assert(action_family_44_construct(raw, 528u, text, 4u, 0u, 1u, object, 531u, &c) == ACTION_FAMILY_44_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_44_construct(raw, 528u, text, 4u, 0u, 1u, raw, 528u, &c) == ACTION_FAMILY_44_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_44_construct(raw, 528u, text, 4u, 0u, 1u, (uint8_t *)&c, sizeof(c), &c) == ACTION_FAMILY_44_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_44_construct(raw, 528u, (const uint8_t *)UINTPTR_MAX, 4u, 0u, 1u, object, 532u, &c) == ACTION_FAMILY_44_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_44_construct(raw, 528u, text, 4u, 0u, 1u, (uint8_t *)UINTPTR_MAX, 532u, &c) == ACTION_FAMILY_44_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_44_body_length((const uint8_t *)&n, 528u, &n) == ACTION_FAMILY_44_ERR_OVERLAP); ++pointer_checks;
    assert(memcmp(&d, &before_d, sizeof(d)) == 0 && memcmp(&c, &before_c, sizeof(c)) == 0);
    for (size_t i = 0u; i < 532u; ++i) { assert(object[i] == 0xcdu); }
    assert(memcmp(raw, source, 528u) == 0 && n == SIZE_MAX);
    free(raw); free(object); free(text);
}

static void check_text_limits(const uint8_t *source)
{
    const size_t lengths[] = {0u, 1u, 32767u, 32768u, 40000u, 40001u};
    uint8_t *raw = malloc(528u);
    assert(raw != NULL);
    memcpy(raw, source, 528u);
    for (size_t i = 0u; i < sizeof(lengths) / sizeof(lengths[0]); ++i) {
        size_t n = lengths[i];
        uint8_t *text = malloc(n + 1u);
        ActionFamily44Constructed c, before;
        assert(text != NULL);
        memset(text, 'x', n); text[n] = 0u;
        memset(&c, 0xa5, sizeof(c)); memcpy(&before, &c, sizeof(c));
        if (n > 40000u) {
            assert(action_family_44_construct(raw, 528u, text, n + 1u, 0u, 1u,
                                              NULL, 0u, &c) == ACTION_FAMILY_44_ERR_TEXT);
            assert(memcmp(&c, &before, sizeof(c)) == 0);
            ++rejected_cases;
        } else {
            uint8_t *object = malloc(529u + n);
            assert(object != NULL);
            assert(action_family_44_construct(raw, 528u, text, n + 1u, 0u, 1u,
                                              object, 529u + n, &c) == ACTION_FAMILY_44_OK);
            assert(c.object_bytes == 529u + n && c.word_20e_after == (uint16_t)n);
            assert(memcmp(object + 528u, text, n + 1u) == 0);
            ++valid_cases;
            free(object);
        }
        free(text);
    }
    memset(raw + 493u, 'k', 33u);
    check(raw, 528u, ACTION_FAMILY_44_ERR_TEXT);
    raw[492u] = 0u; put16(raw + 526u, 0u);
    check(raw, 528u, ACTION_FAMILY_44_ERR_TEXT);
    uint8_t *inline_body = malloc(532u);
    assert(inline_body != NULL);
    memcpy(inline_body, raw, 528u); put16(inline_body + 526u, 4u);
    memset(inline_body + 528u, 'x', 4u);
    check(inline_body, 532u, ACTION_FAMILY_44_ERR_TEXT);
    free(inline_body);
    free(raw);
}

int main(void)
{
    uint8_t *source = malloc(528u + 32767u + 64u);
    assert(source != NULL);
    memset(source, 0, 528u + 32767u + 64u);
    source[492u] = 1u;
    memcpy(source + 493u, "KEY", 4u);
    for (uint32_t word = 0u; word <= UINT16_MAX; ++word) {
        put16(source + 2u, (uint16_t)word);
        put16(source + 526u, (uint16_t)word);
        check(source, 528u + (size_t)(word % 3u) * 16u, ACTION_FAMILY_44_OK);
    }
    /* Every nonnegative signed16 inline extent, at its exact heap size. */
    source[492u] = 0u; put16(source + 2u, 2u);
    for (uint32_t n = 1u; n <= INT16_MAX; ++n) {
        put16(source + 526u, (uint16_t)n);
        check(source, 528u + n, ACTION_FAMILY_44_OK);
    }
    put16(source + 526u, 0u); check(source, 528u, ACTION_FAMILY_44_ERR_TEXT);
    put16(source + 526u, UINT16_C(0x8000)); check(source, 532u, ACTION_FAMILY_44_ERR_BODY);
    put16(source + 526u, UINT16_MAX); check(source, 532u, ACTION_FAMILY_44_ERR_BODY);
    put16(source + 526u, 4u); check(source, 531u, ACTION_FAMILY_44_ERR_BODY);
    source[492u] = 1u;
    for (size_t n = 0u; n < 528u; ++n) { check(source, n, ACTION_FAMILY_44_ERR_BODY); }
    for (size_t n = 1u; n <= 40u; ++n) {
        check(source, 528u + n, n % 16u == 0u ? ACTION_FAMILY_44_OK : ACTION_FAMILY_44_ERR_TAIL);
    }
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t n = (size_t)(next_random() % 600u);
        check(source, n, n < 528u ? ACTION_FAMILY_44_ERR_BODY :
            (n - 528u) % 16u != 0u ? ACTION_FAMILY_44_ERR_TAIL : ACTION_FAMILY_44_OK);
    }
    check_pointers(source);
    check_text_limits(source);
    free(source);
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"inline_count_patterns\":32767,"
           "\"keyed_word_patterns\":65536,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
