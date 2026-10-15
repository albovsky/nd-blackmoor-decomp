/* Exact-size heap storage for every valid/short/ragged raw-body input. */
#include "action_family_f6.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BODY 4934u

static size_t valid_cases;
static size_t rejected_cases;
static size_t pointer_checks;
static uint32_t random_state = UINT32_C(0xf6b17e01);

static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}

static void check_case(size_t length, int pin_ends, uint8_t first, uint8_t last)
{
    size_t allocation = length == 0u ? 1u : length;
    uint8_t *raw = malloc(allocation);
    uint8_t *before = malloc(allocation);
    ActionFamilyF6Decoded d, d_before;
    ActionFamilyF6Constructed c, c_before;
    ActionFamilyF6Status expected;
    uint32_t offset = next_random();
    size_t typed = SIZE_MAX;
    assert(raw != NULL && before != NULL);
    for (size_t i = 0u; i < length; ++i) {
        raw[i] = (uint8_t)(next_random() >> 16);
    }
    if (pin_ends && length >= BODY) {
        raw[0] = first;
        raw[BODY - 1u] = last;
    }
    memcpy(before, raw, length);
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    expected = length < BODY ? ACTION_FAMILY_F6_ERR_BODY :
        (length - BODY) % 16u != 0u ? ACTION_FAMILY_F6_ERR_TAIL : ACTION_FAMILY_F6_OK;
    assert(action_family_f6_decode(raw, length, &d) == expected);
    assert(action_family_f6_body_length(raw, length, &typed) == expected);
    assert(action_family_f6_construct(raw, length, offset, UINT32_C(0xf60001), &c) == expected);
    assert(memcmp(raw, before, length) == 0);
    if (expected == ACTION_FAMILY_F6_OK) {
        assert(memcmp(d.body, raw, BODY) == 0);
        assert(typed == BODY && d.body_bytes == BODY && d.available_body_bytes == length);
        assert(d.dependency_records == raw + BODY);
        assert(d.dependency_count == (length - BODY) / 16u);
        assert(d.dependency_bytes == length - BODY);
        assert(memcmp(c.object_bytes, raw, BODY) == 0);
        assert(c.body_bytes_consumed == BODY);
        assert(c.payload_offset_before == offset && c.payload_offset_after == offset + UINT32_C(4934));
        assert(c.result_slot_handle == UINT32_C(0xf60001));
        assert(c.allocation_bytes == BODY && c.available_body_bytes == length);
        assert(c.raw_type == 0xf6u && c.runtime_type == 0xf6u);
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
    uint8_t *raw = malloc(BODY);
    ActionFamilyF6Decoded d, d_before;
    ActionFamilyF6Constructed c, c_before;
    size_t typed = SIZE_MAX;
    assert(raw != NULL);
    memset(raw, 0xf6, BODY);
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    assert(action_family_f6_decode(NULL, BODY, &d) == ACTION_FAMILY_F6_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_f6_construct(NULL, BODY, 0u, 1u, &c) == ACTION_FAMILY_F6_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_f6_body_length(NULL, BODY, &typed) == ACTION_FAMILY_F6_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_f6_decode(raw, BODY, NULL) == ACTION_FAMILY_F6_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_f6_construct(raw, BODY, 0u, 1u, NULL) == ACTION_FAMILY_F6_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_f6_body_length(raw, BODY, NULL) == ACTION_FAMILY_F6_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_f6_construct(raw, BODY, 0u, 0u, &c) == ACTION_FAMILY_F6_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_f6_decode((const uint8_t *)UINTPTR_MAX, BODY, &d) == ACTION_FAMILY_F6_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_f6_construct((const uint8_t *)UINTPTR_MAX, BODY, 0u, 1u, &c) == ACTION_FAMILY_F6_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_f6_body_length((const uint8_t *)UINTPTR_MAX, BODY, &typed) == ACTION_FAMILY_F6_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_f6_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_F6_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_f6_construct(raw, SIZE_MAX, 0u, 1u, &c) == ACTION_FAMILY_F6_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_f6_body_length(raw, SIZE_MAX, &typed) == ACTION_FAMILY_F6_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_f6_decode(raw, BODY, (ActionFamilyF6Decoded *)UINTPTR_MAX) == ACTION_FAMILY_F6_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_f6_construct(raw, BODY, 0u, 1u, (ActionFamilyF6Constructed *)UINTPTR_MAX) == ACTION_FAMILY_F6_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_f6_body_length(raw, BODY, (size_t *)UINTPTR_MAX) == ACTION_FAMILY_F6_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_f6_decode((const uint8_t *)&d + 1u, BODY, &d) == ACTION_FAMILY_F6_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_f6_construct((const uint8_t *)&c + 1u, BODY, 0u, 1u, &c) == ACTION_FAMILY_F6_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_f6_body_length(raw, BODY, (size_t *)(void *)raw) == ACTION_FAMILY_F6_ERR_OVERLAP); ++pointer_checks;
    assert(typed == SIZE_MAX);
    assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
    for (size_t i = 0u; i < BODY; ++i) {
        assert(raw[i] == 0xf6u);
    }
    free(raw);
}

int main(void)
{
    /* No count field exists: every first/last body byte value is ordinary data. */
    for (uint32_t value = 0u; value <= UINT8_MAX; ++value) {
        for (size_t rows = 0u; rows < 4u; ++rows) {
            check_case(BODY + rows * 16u, 1, (uint8_t)value, (uint8_t)(255u - value));
            check_case(BODY + rows * 16u, 1, (uint8_t)(255u - value), (uint8_t)value);
        }
    }
    for (size_t tail = 0u; tail <= 300u; ++tail) {
        check_case(BODY + tail * 16u, 0, 0u, 0u);
    }
    check_case(BODY + 65535u * 16u, 0, 0u, 0u);
    check_case(BODY + 65536u * 16u, 1, 0x80u, 0x80u);
    check_case(BODY + 65537u * 16u, 0, 0u, 0u);
    for (size_t length = 0u; length <= BODY + 300u; ++length) {
        check_case(length, 0, 0u, 0u);
    }
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t length = (size_t)(next_random() % 5401u);
        check_case(length, 0, 0u, 0u);
    }
    check_pointers();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"edge_byte_patterns\":2048,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
