/* Exact-size heap inputs expose even a one-byte overread to ASan. */
#include "action_family_69.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases;
static size_t rejected_cases;
static size_t pointer_checks;
static uint32_t random_state = UINT32_C(0x69b17e01);

static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}

static void check_case(size_t length, uint8_t option)
{
    size_t allocation = length == 0u ? 1u : length;
    uint8_t *raw = malloc(allocation);
    uint8_t *before = malloc(allocation);
    ActionFamily69Decoded d;
    ActionFamily69Decoded d_before;
    ActionFamily69Constructed c;
    ActionFamily69Constructed c_before;
    ActionFamily69Status expected;
    size_t body_length = SIZE_MAX;
    uint32_t offset = next_random();
    assert(raw != NULL && before != NULL);
    for (size_t i = 0u; i < length; ++i) {
        raw[i] = (uint8_t)next_random();
    }
    if (length > 0u) {
        raw[0] = (uint8_t)option;
    }
    memcpy(before, raw, length);
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    expected = length < 1u ? ACTION_FAMILY_69_ERR_BODY :
        (length - 1u) % 16u != 0u ? ACTION_FAMILY_69_ERR_TAIL : ACTION_FAMILY_69_OK;
    assert(action_family_69_body_length(raw, length, &body_length) == expected);
    assert(body_length == (expected == ACTION_FAMILY_69_OK ? 1u : SIZE_MAX));
    assert(action_family_69_decode(raw, length, &d) == expected);
    assert(action_family_69_construct(raw, length, offset, UINT32_C(0x690001), &c) == expected);
    assert(memcmp(raw, before, length) == 0);
    if (expected == ACTION_FAMILY_69_OK) {
        assert(d.option_00 == option);
        assert(d.body_bytes == 1u && d.available_body_bytes == length);
        assert(d.dependency_records == raw + 1u);
        assert(d.dependency_count == (length - 1u) / 16u);
        assert(d.dependency_bytes == length - 1u);
        assert(memcmp(c.object_bytes, raw, 1u) == 0);
        assert(c.body_bytes_consumed == 1u);
        assert(c.payload_offset_before == offset && c.payload_offset_after == offset + UINT32_C(1));
        assert(c.output_handle == UINT32_C(0x690001) && c.result_slot_handle == c.output_handle);
        assert(c.output_allocation_bytes == 1u && c.available_body_bytes == length);
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
    uint8_t *raw = malloc(1u);
    ActionFamily69Decoded d, d_before;
    ActionFamily69Constructed c, c_before;
    assert(raw != NULL);
    raw[0] = 0x11u;
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    assert(action_family_69_decode(NULL, 1u, &d) == ACTION_FAMILY_69_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_69_construct(NULL, 1u, 0u, 1u, &c) == ACTION_FAMILY_69_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_69_decode(raw, 1u, NULL) == ACTION_FAMILY_69_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_69_construct(raw, 1u, 0u, 1u, NULL) == ACTION_FAMILY_69_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_69_construct(raw, 1u, 0u, 0u, &c) == ACTION_FAMILY_69_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_69_decode((const uint8_t *)UINTPTR_MAX, 1u, &d) == ACTION_FAMILY_69_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_69_construct((const uint8_t *)UINTPTR_MAX, 1u, 0u, 1u, &c) == ACTION_FAMILY_69_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_69_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_69_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_69_construct(raw, SIZE_MAX, 0u, 1u, &c) == ACTION_FAMILY_69_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_69_decode(raw, 1u, (ActionFamily69Decoded *)UINTPTR_MAX) == ACTION_FAMILY_69_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_69_construct(raw, 1u, 0u, 1u, (ActionFamily69Constructed *)UINTPTR_MAX) == ACTION_FAMILY_69_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_69_decode((const uint8_t *)&d + 1u, 1u, &d) == ACTION_FAMILY_69_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_69_construct((const uint8_t *)&c + 1u, 1u, 0u, 1u, &c) == ACTION_FAMILY_69_ERR_OVERLAP); ++pointer_checks;
    assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
    assert(raw[0] == 0x11u);
    free(raw);
}

int main(void)
{
    /* Full bit-pattern domain, including signed-looking and maximum values. */
    for (uint32_t option = 0u; option <= UINT8_MAX; ++option) {
        check_case(1u + (size_t)(option % 4u) * 16u, (uint8_t)option);
    }
    for (size_t tail = 0u; tail <= 256u; ++tail) {
        check_case(1u + tail * 16u, UINT8_MAX);
    }
    for (size_t length = 0u; length <= 257u; ++length) {
        check_case(length, UINT8_C(0x80));
    }
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t length = (size_t)(next_random() % 513u);
        uint8_t option = (uint8_t)next_random();
        check_case(length, option);
    }
    check_pointers();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"option_patterns\":256,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
