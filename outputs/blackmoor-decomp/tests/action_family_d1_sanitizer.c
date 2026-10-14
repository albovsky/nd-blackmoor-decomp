/* Exact-size heap inputs expose even a one-byte overread to ASan. */
#include "action_family_d1.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases;
static size_t rejected_cases;
static size_t pointer_checks;
static uint32_t random_state = UINT32_C(0xd1b17e01);

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
    ActionFamilyD1Decoded d;
    ActionFamilyD1Decoded d_before;
    ActionFamilyD1Constructed c;
    ActionFamilyD1Constructed c_before;
    ActionFamilyD1Status expected;
    uint32_t offset = next_random();
    assert(raw != NULL && before != NULL);
    for (size_t i = 0u; i < length; ++i) {
        raw[i] = (uint8_t)next_random();
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
    expected = length < 927u ? ACTION_FAMILY_D1_ERR_BODY :
        (length - 927u) % 16u != 0u ? ACTION_FAMILY_D1_ERR_TAIL : ACTION_FAMILY_D1_OK;
    assert(action_family_d1_decode(raw, length, &d) == expected);
    assert(action_family_d1_construct(raw, length, offset, UINT32_C(0xd10001), &c) == expected);
    assert(memcmp(raw, before, length) == 0);
    if (expected == ACTION_FAMILY_D1_OK) {
        assert(d.word_N[0] == word);
        for (size_t i = 0u; i < 463u; ++i) {
            assert(d.word_N[i] == (uint16_t)((uint16_t)raw[2u*i] | ((uint16_t)raw[2u*i+1u] << 8)));
        }
        assert(d.option_39e == raw[926u]);
        assert(d.raw_type == 0xd1u && d.runtime_type == 0xd1u);
        assert(c.raw_type == 0xd1u && c.runtime_type == 0xd1u);
        assert(d.body_bytes == 927u && d.available_body_bytes == length);
        assert(d.dependency_records == raw + 927u);
        assert(d.dependency_count == (length - 927u) / 16u);
        assert(d.dependency_bytes == length - 927u);
        assert(memcmp(c.object_bytes, raw, 927u) == 0);
        assert(c.body_bytes_consumed == 927u);
        assert(c.payload_offset_before == offset && c.payload_offset_after == offset + UINT32_C(927));
        assert(c.output_handle == UINT32_C(0xd10001) && c.result_slot_handle == c.output_handle);
        assert(c.output_allocation_bytes == 927u && c.available_body_bytes == length);
        assert(c.dependency_records == d.dependency_records && c.dependency_count == d.dependency_count);
        assert(c.dependency_bytes == d.dependency_bytes);
        ++valid_cases;
    } else {
        assert(memcmp(&d, &d_before, sizeof(d)) == 0);
        assert(memcmp(&c, &c_before, sizeof(c)) == 0);
        ++rejected_cases;
    }
    free(before);
    free(raw);
}

static void check_pointers(void)
{
    uint8_t *raw = malloc(927u);
    ActionFamilyD1Decoded d, d_before;
    ActionFamilyD1Constructed c, c_before;
    assert(raw != NULL);
    memset(raw, 0, 927u);
    raw[0] = 0x12u;
    raw[1] = 0x34u;
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    assert(action_family_d1_decode(NULL, 927u, &d) == ACTION_FAMILY_D1_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_d1_construct(NULL, 927u, 0u, 1u, &c) == ACTION_FAMILY_D1_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_d1_decode(raw, 927u, NULL) == ACTION_FAMILY_D1_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_d1_construct(raw, 927u, 0u, 1u, NULL) == ACTION_FAMILY_D1_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_d1_construct(raw, 927u, 0u, 0u, &c) == ACTION_FAMILY_D1_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_d1_decode((const uint8_t *)UINTPTR_MAX, 927u, &d) == ACTION_FAMILY_D1_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_d1_construct((const uint8_t *)UINTPTR_MAX, 927u, 0u, 1u, &c) == ACTION_FAMILY_D1_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_d1_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_D1_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_d1_construct(raw, SIZE_MAX, 0u, 1u, &c) == ACTION_FAMILY_D1_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_d1_decode(raw, 927u, (ActionFamilyD1Decoded *)UINTPTR_MAX) == ACTION_FAMILY_D1_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_d1_construct(raw, 927u, 0u, 1u, (ActionFamilyD1Constructed *)UINTPTR_MAX) == ACTION_FAMILY_D1_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_d1_decode((const uint8_t *)&d + 1u, 927u, &d) == ACTION_FAMILY_D1_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_d1_construct((const uint8_t *)&c + 1u, 927u, 0u, 1u, &c) == ACTION_FAMILY_D1_ERR_OVERLAP); ++pointer_checks;
    assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
    assert(raw[0] == 0x12u && raw[1] == 0x34u);
    free(raw);
}

int main(void)
{
    /* Full bit-pattern domain, including signed-looking and maximum values. */
    for (uint32_t word = 0u; word <= UINT16_MAX; ++word) {
        check_case(927u + (size_t)(word % 4u) * 16u, (uint16_t)word);
    }
    for (size_t tail = 0u; tail <= 256u; ++tail) {
        check_case(927u + tail * 16u, UINT16_MAX);
    }
    for (size_t length = 0u; length <= 1183u; ++length) {
        check_case(length, UINT16_C(0x8000));
    }
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t length = (size_t)(next_random() % 1537u);
        uint16_t word = (uint16_t)next_random();
        check_case(length, word);
    }
    check_pointers();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"word_patterns\":65536,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
