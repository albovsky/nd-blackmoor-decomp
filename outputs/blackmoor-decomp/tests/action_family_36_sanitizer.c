/* Exact-size heap buffers expose prefix/table/tail overreads to ASan. */
#include "action_family_36.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases, rejected_cases, pointer_checks;
static uint32_t random_state = UINT32_C(0x36b17e01);

static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}

static void put_word(uint8_t *raw, size_t length, size_t offset, uint16_t bits)
{
    if (offset < length) raw[offset] = (uint8_t)bits;
    if (offset + 1u < length) raw[offset + 1u] = (uint8_t)(bits >> 8);
}

static int32_t signed_word(uint16_t bits)
{
    return bits <= 32767u ? (int32_t)bits : (int32_t)bits - 65536;
}

static void check_case(size_t length, uint16_t mode, uint16_t direct,
                       uint16_t start, uint16_t end, uint16_t second)
{
    size_t allocation = length == 0u ? 1u : length;
    uint8_t *raw = malloc(allocation), *before = malloc(allocation);
    uint8_t *seed = malloc(0xabau), *expected_image = malloc(0xabau);
    ActionFamily36Decoded d, d_before;
    ActionFamily36Constructed c, c_before;
    size_t typed = 123456u, body = 0u;
    int32_t p = signed_word(direct), s = signed_word(second);
    uint32_t offset = next_random();
    ActionFamily36Status expected;
    assert(raw != NULL && before != NULL && seed != NULL && expected_image != NULL);
    for (size_t i = 0u; i < length; ++i) raw[i] = (uint8_t)next_random();
    for (size_t i = 0u; i < 0xabau; ++i) seed[i] = (uint8_t)(i * 29u + 19u);
    put_word(raw, length, 0x29u, mode);
    put_word(raw, length, 0x2bu, direct);
    put_word(raw, length, 0x33u, start);
    put_word(raw, length, 0x35u, end);
    put_word(raw, length, 0xaau, second);
    memcpy(before, raw, length);
    memcpy(expected_image, seed, 0xabau);
    memset(&d, 0xa5, sizeof(d)); memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d)); memcpy(&c_before, &c, sizeof(c));
    if (mode == 2u) p = signed_word((uint16_t)(signed_word(end) - signed_word(start) + 1));
    expected = ACTION_FAMILY_36_OK;
    if (length < 172u) expected = ACTION_FAMILY_36_ERR_BODY;
    else if (p < 0 || p > 100 || s < 0 || s > 25) expected = ACTION_FAMILY_36_ERR_COUNT;
    else {
        body = 172u + (size_t)p * 16u + (size_t)s * 38u;
        if (length < body) expected = ACTION_FAMILY_36_ERR_BODY;
        else if ((length - body) % 16u != 0u) expected = ACTION_FAMILY_36_ERR_TAIL;
    }
    assert(action_family_36_decode(raw, length, &d) == expected);
    assert(action_family_36_body_length(raw, length, &typed) == expected);
    assert(action_family_36_construct(raw, length, seed, 0xabau, offset, 1u, &c) == expected);
    assert(memcmp(raw, before, length) == 0);
    for (size_t i = 0u; i < 0xabau; ++i) assert(seed[i] == (uint8_t)(i * 29u + 19u));
    if (expected == ACTION_FAMILY_36_OK) {
        assert(typed == body && d.body_bytes == body && c.body_bytes_consumed == body);
        assert(memcmp(d.prefix_bytes, raw, 172u) == 0);
        assert(d.option_29 == mode && d.word_2b == signed_word(direct));
        assert(d.word_33 == signed_word(start) && d.word_35 == signed_word(end) && d.word_aa == s);
        assert(d.primary_records == raw + 172u && d.primary_count == (size_t)p);
        assert(d.secondary_records == raw + 172u + (size_t)p * 16u && d.secondary_count == (size_t)s);
        assert(d.dependency_records == raw + body && d.dependency_count == (length - body) / 16u);
        assert(d.dependency_bytes == length - body && d.available_body_bytes == length);
        memcpy(expected_image, raw, 172u + (size_t)p * 16u);
        memcpy(expected_image + 0x6ecu, raw + 172u + (size_t)p * 16u, (size_t)s * 38u);
        assert(memcmp(c.object_bytes, expected_image, 0xabau) == 0);
        assert(c.payload_offset_before == offset && c.payload_offset_after == offset + (uint32_t)body);
        assert(c.dependency_records == d.dependency_records && c.dependency_count == d.dependency_count);
        assert(c.dependency_bytes == d.dependency_bytes && c.available_body_bytes == length);
        assert(c.owner_links.output_handle == 1u && c.owner_links.result_slot_handle == 1u);
        assert(c.owner_links.owner_slot_1c_handle == 1u && c.owner_links.owner_slot_20_handle == 1u);
        assert(c.owner_links.output_allocation_bytes == 0xabau);
        ++valid_cases;
    } else {
        assert(typed == 123456u);
        assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
        ++rejected_cases;
    }
    free(expected_image); free(seed); free(before); free(raw);
}

static void check_pointers(void)
{
    uint8_t *raw = calloc(172u, 1u), *seed = calloc(0xabau, 1u);
    ActionFamily36Decoded d, before_d;
    ActionFamily36Constructed c, before_c;
    size_t n = 12345u;
    assert(raw != NULL && seed != NULL);
    memset(&d, 0xa5, sizeof(d)); memset(&c, 0x5a, sizeof(c));
    memcpy(&before_d, &d, sizeof(d)); memcpy(&before_c, &c, sizeof(c));
#define CHECK(expression, status) do { assert((expression) == (status)); ++pointer_checks; } while (0)
    CHECK(action_family_36_decode(NULL, 172u, &d), ACTION_FAMILY_36_ERR_ARGUMENT);
    CHECK(action_family_36_body_length(NULL, 172u, &n), ACTION_FAMILY_36_ERR_ARGUMENT);
    CHECK(action_family_36_construct(NULL, 172u, seed, 0xabau, 0u, 1u, &c), ACTION_FAMILY_36_ERR_ARGUMENT);
    CHECK(action_family_36_decode(raw, 172u, NULL), ACTION_FAMILY_36_ERR_ARGUMENT);
    CHECK(action_family_36_body_length(raw, 172u, NULL), ACTION_FAMILY_36_ERR_ARGUMENT);
    CHECK(action_family_36_construct(raw, 172u, seed, 0xabau, 0u, 1u, NULL), ACTION_FAMILY_36_ERR_ARGUMENT);
    CHECK(action_family_36_construct(raw, 172u, NULL, 0xabau, 0u, 1u, &c), ACTION_FAMILY_36_ERR_ARGUMENT);
    CHECK(action_family_36_construct(raw, 172u, seed, 0xabau, 0u, 0u, &c), ACTION_FAMILY_36_ERR_ARGUMENT);
    CHECK(action_family_36_construct(raw, 172u, seed, 0xab9u, 0u, 1u, &c), ACTION_FAMILY_36_ERR_ALLOCATION);
    CHECK(action_family_36_decode((const uint8_t *)UINTPTR_MAX, 172u, &d), ACTION_FAMILY_36_ERR_BOUNDS);
    CHECK(action_family_36_body_length((const uint8_t *)UINTPTR_MAX, 172u, &n), ACTION_FAMILY_36_ERR_BOUNDS);
    CHECK(action_family_36_construct((const uint8_t *)UINTPTR_MAX, 172u, seed, 0xabau, 0u, 1u, &c), ACTION_FAMILY_36_ERR_BOUNDS);
    CHECK(action_family_36_decode(raw, SIZE_MAX, &d), ACTION_FAMILY_36_ERR_BOUNDS);
    CHECK(action_family_36_body_length(raw, SIZE_MAX, &n), ACTION_FAMILY_36_ERR_BOUNDS);
    CHECK(action_family_36_construct(raw, SIZE_MAX, seed, 0xabau, 0u, 1u, &c), ACTION_FAMILY_36_ERR_BOUNDS);
    CHECK(action_family_36_decode(raw, 172u, (ActionFamily36Decoded *)UINTPTR_MAX), ACTION_FAMILY_36_ERR_BOUNDS);
    CHECK(action_family_36_body_length(raw, 172u, (size_t *)UINTPTR_MAX), ACTION_FAMILY_36_ERR_BOUNDS);
    CHECK(action_family_36_construct(raw, 172u, seed, 0xabau, 0u, 1u, (ActionFamily36Constructed *)UINTPTR_MAX), ACTION_FAMILY_36_ERR_BOUNDS);
    CHECK(action_family_36_construct(raw, 172u, (const uint8_t *)UINTPTR_MAX, 0xabau, 0u, 1u, &c), ACTION_FAMILY_36_ERR_BOUNDS);
    CHECK(action_family_36_decode((const uint8_t *)&d, 172u, &d), ACTION_FAMILY_36_ERR_OVERLAP);
    CHECK(action_family_36_body_length((const uint8_t *)&n, 172u, &n), ACTION_FAMILY_36_ERR_OVERLAP);
    CHECK(action_family_36_construct((const uint8_t *)&c, 172u, seed, 0xabau, 0u, 1u, &c), ACTION_FAMILY_36_ERR_OVERLAP);
    CHECK(action_family_36_construct(raw, 172u, (const uint8_t *)&c, 0xabau, 0u, 1u, &c), ACTION_FAMILY_36_ERR_OVERLAP);
#undef CHECK
    assert(n == 12345u && memcmp(&d, &before_d, sizeof(d)) == 0 && memcmp(&c, &before_c, sizeof(c)) == 0);
    free(seed); free(raw);
}

int main(void)
{
    for (uint32_t bits = 0u; bits <= UINT16_MAX; ++bits) {
        check_case(172u, 1u, (uint16_t)bits, 0u, 0u, 0u);
        check_case(172u, 1u, 0u, 0u, 0u, (uint16_t)bits);
    }
    for (uint32_t p = 0u; p <= 100u; ++p) {
        for (uint32_t s = 0u; s <= 25u; ++s) {
            size_t n = 172u + (size_t)p * 16u + (size_t)s * 38u;
            check_case(n, 1u, (uint16_t)p, 0u, 0u, (uint16_t)s);
            check_case(n + 32u, 2u, UINT16_MAX, 0u, (uint16_t)(p - 1u), (uint16_t)s);
            check_case(n - 1u, 1u, (uint16_t)p, 0u, 0u, (uint16_t)s);
        }
    }
    check_case(172u, 2u, 0u, UINT16_C(0x8000), UINT16_C(0x7fff), 0u);
    check_case(204u, 2u, 0u, UINT16_C(0x7fff), UINT16_C(0x8000), 0u);
    for (size_t n = 0u; n <= 256u; ++n) check_case(n, 1u, 0u, 0u, 0u, 0u);
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t n = (size_t)(next_random() % 3073u);
        uint16_t mode = (uint16_t)(next_random() % 4u);
        uint16_t p = (uint16_t)(next_random() % 105u), s = (uint16_t)(next_random() % 28u);
        check_case(n, mode, p, 0u, (uint16_t)(p - 1u), s);
    }
    check_pointers();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"count_patterns\":131072,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
