/* Exact-size heap storage for every valid/short/ragged raw-body input. */
#include "action_family_83.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases;
static size_t rejected_cases;
static size_t pointer_checks;
static uint32_t random_state = UINT32_C(0x83b17e01);

static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}

static void check_case(size_t length, uint16_t word)
{
    size_t allocation = length == 0u ? 1u : length;
    uint8_t *raw = malloc(allocation);
    uint8_t *before = malloc(allocation);
    ActionFamily83Decoded d, d_before;
    ActionFamily83Constructed c, c_before;
    ActionFamily83Status expected;
    uint32_t offset = next_random();
    size_t typed = SIZE_MAX;
    assert(raw != NULL && before != NULL);
    for (size_t i = 0u; i < length; ++i) {
        raw[i] = (uint8_t)(next_random() >> 16);
    }
    if (length > 0u) {
        raw[0] = (uint8_t)word;
    }
    if (length > 1u) {
        raw[1] = (uint8_t)(word >> 8);
    }
    memcpy(before, raw, length);
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    expected = length < 74u ? ACTION_FAMILY_83_ERR_BODY :
        (length - 74u) % 16u != 0u ? ACTION_FAMILY_83_ERR_TAIL : ACTION_FAMILY_83_OK;
    assert(action_family_83_decode(raw, length, &d) == expected);
    assert(action_family_83_body_length(raw, length, &typed) == expected);
    assert(action_family_83_construct(raw, length, offset, UINT32_C(0x830001), &c) == expected);
    assert(memcmp(raw, before, length) == 0);
    if (expected == ACTION_FAMILY_83_OK) {
        for (size_t i = 0u; i < 37u; ++i) {
            assert(d.word[i] == (uint16_t)((uint16_t)raw[2u * i] |
                                          ((uint16_t)raw[2u * i + 1u] << 8)));
        }
        assert(typed == 74u && d.body_bytes == 74u && d.available_body_bytes == length);
        assert(d.dependency_records == raw + 74u);
        assert(d.dependency_count == (length - 74u) / 16u);
        assert(d.dependency_bytes == length - 74u);
        assert(memcmp(c.object_bytes, raw, 74u) == 0);
        assert(c.body_bytes_consumed == 74u);
        assert(c.payload_offset_before == offset && c.payload_offset_after == offset + UINT32_C(74));
        assert(c.result_slot_handle == UINT32_C(0x830001));
        assert(c.allocation_bytes == 74u && c.available_body_bytes == length);
        assert(c.raw_type == 0x83u && c.runtime_type == 0x83u);
        assert(c.dependency_records == d.dependency_records && c.dependency_count == d.dependency_count);
        assert(c.dependency_bytes == d.dependency_bytes);
        ++valid_cases;
    } else {
        assert(typed == SIZE_MAX);
        assert(memcmp(&d, &d_before, sizeof(d)) == 0);
        assert(memcmp(&c, &c_before, sizeof(c)) == 0);
        ++rejected_cases;
    }
    free(before);
    free(raw);
}

static void check_pointers(void)
{
    uint8_t *raw = malloc(74u);
    ActionFamily83Decoded d, d_before;
    ActionFamily83Constructed c, c_before;
    size_t typed = SIZE_MAX;
    assert(raw != NULL);
    memset(raw, 0x83, 74u);
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    assert(action_family_83_decode(NULL, 74u, &d) == ACTION_FAMILY_83_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_83_construct(NULL, 74u, 0u, 1u, &c) == ACTION_FAMILY_83_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_83_body_length(NULL, 74u, &typed) == ACTION_FAMILY_83_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_83_decode(raw, 74u, NULL) == ACTION_FAMILY_83_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_83_construct(raw, 74u, 0u, 1u, NULL) == ACTION_FAMILY_83_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_83_body_length(raw, 74u, NULL) == ACTION_FAMILY_83_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_83_construct(raw, 74u, 0u, 0u, &c) == ACTION_FAMILY_83_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_83_decode((const uint8_t *)UINTPTR_MAX, 74u, &d) == ACTION_FAMILY_83_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_83_construct((const uint8_t *)UINTPTR_MAX, 74u, 0u, 1u, &c) == ACTION_FAMILY_83_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_83_body_length((const uint8_t *)UINTPTR_MAX, 74u, &typed) == ACTION_FAMILY_83_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_83_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_83_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_83_construct(raw, SIZE_MAX, 0u, 1u, &c) == ACTION_FAMILY_83_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_83_body_length(raw, SIZE_MAX, &typed) == ACTION_FAMILY_83_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_83_decode(raw, 74u, (ActionFamily83Decoded *)UINTPTR_MAX) == ACTION_FAMILY_83_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_83_construct(raw, 74u, 0u, 1u, (ActionFamily83Constructed *)UINTPTR_MAX) == ACTION_FAMILY_83_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_83_body_length(raw, 74u, (size_t *)UINTPTR_MAX) == ACTION_FAMILY_83_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_83_decode((const uint8_t *)&d + 1u, 74u, &d) == ACTION_FAMILY_83_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_83_construct((const uint8_t *)&c + 1u, 74u, 0u, 1u, &c) == ACTION_FAMILY_83_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_83_body_length(raw, 74u, (size_t *)(void *)raw) == ACTION_FAMILY_83_ERR_OVERLAP); ++pointer_checks;
    assert(typed == SIZE_MAX);
    assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
    for (size_t i = 0u; i < 74u; ++i) {
        assert(raw[i] == 0x83u);
    }
    free(raw);
}

int main(void)
{
    /* No count field exists: every first-word encoding is ordinary data. */
    for (uint32_t word = 0u; word <= UINT16_MAX; ++word) {
        check_case(74u + (size_t)(word % 4u) * 16u, (uint16_t)word);
    }
    for (size_t tail = 0u; tail <= 256u; ++tail) {
        check_case(74u + tail * 16u, UINT16_MAX);
    }
    check_case(74u + 65536u * 16u, UINT16_C(0x8000));
    for (size_t length = 0u; length <= 257u; ++length) {
        check_case(length, UINT16_C(0x8000));
    }
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t length = (size_t)(next_random() % 1025u);
        uint16_t word = (uint16_t)next_random();
        check_case(length, word);
    }
    check_pointers();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"word_patterns\":65536,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
