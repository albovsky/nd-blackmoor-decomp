/* Exact-size heap spans expose prefix, counted suffix and tail overreads. */
#include "action_family_45.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases, rejected_cases, pointer_checks;
static uint32_t random_state = UINT32_C(0x45b17e01);

static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}

static uint16_t read_word(const uint8_t *raw)
{
    return (uint16_t)((uint16_t)raw[0] | ((uint16_t)raw[1] << 8));
}

static void check_case(size_t length, uint16_t count)
{
    size_t allocation = length == 0u ? 1u : length;
    uint8_t *raw = malloc(allocation);
    uint8_t *before = malloc(allocation);
    ActionFamily45Decoded d, d_before;
    ActionFamily45Constructed c, c_before;
    ActionFamily45Status expected;
    size_t typed = 196u + (size_t)count * 4u;
    uint32_t offset = next_random();
    assert(raw != NULL && before != NULL);
    for (size_t i = 0u; i < length; ++i) {
        raw[i] = (uint8_t)next_random();
    }
    if (length >= 196u) {
        raw[194] = (uint8_t)count;
        raw[195] = (uint8_t)(count >> 8);
    }
    memcpy(before, raw, length);
    memset(&d, 0xa5, sizeof(d)); memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d)); memcpy(&c_before, &c, sizeof(c));
    expected = length < 196u ? ACTION_FAMILY_45_ERR_BODY :
        count > 10u ? ACTION_FAMILY_45_ERR_COUNT :
        length < typed ? ACTION_FAMILY_45_ERR_BODY :
        (length - typed) % 16u != 0u ? ACTION_FAMILY_45_ERR_TAIL : ACTION_FAMILY_45_OK;
    assert(action_family_45_decode(raw, length, &d) == expected);
    assert(action_family_45_construct(raw, length, offset, UINT32_C(0x450001), &c) == expected);
    assert(memcmp(raw, before, length) == 0);
    if (expected == ACTION_FAMILY_45_OK) {
        assert(d.raw_type == 0x45u && d.runtime_type == 0x45u && d.entry_count == count);
        for (size_t i = 0u; i < 97u; ++i) {
            assert(d.words[i] == read_word(raw + i * 2u));
        }
        for (size_t i = 0u; i < 10u; ++i) {
            assert(d.entries[i].word_0 == (i < count ? read_word(raw + 196u + i * 4u) : 0u));
            assert(d.entries[i].word_1 == (i < count ? read_word(raw + 198u + i * 4u) : 0u));
        }
        assert(d.body_bytes == typed && d.available_body_bytes == length);
        assert(d.dependency_records == raw + typed && d.dependency_bytes == length - typed);
        assert(d.dependency_count == (length - typed) / 16u);
        assert(memcmp(c.object_bytes, raw, typed) == 0);
        for (size_t i = typed; i < 236u; ++i) { assert(c.object_bytes[i] == 0u); }
        assert(c.body_bytes_consumed == typed && c.output_allocation_bytes == typed);
        assert(c.payload_offset_before == offset && c.payload_offset_after == offset + (uint32_t)typed);
        assert(c.output_handle == UINT32_C(0x450001) && c.result_slot_handle == c.output_handle);
        assert(c.dependency_records == d.dependency_records && c.dependency_count == d.dependency_count);
        assert(c.dependency_bytes == d.dependency_bytes && c.available_body_bytes == length);
        ++valid_cases;
    } else {
        assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
        ++rejected_cases;
    }
    free(before); free(raw);
}

static void check_pointers(void)
{
    uint8_t *raw = calloc(196u, 1u);
    ActionFamily45Decoded d, d_before;
    ActionFamily45Constructed c, c_before;
    assert(raw != NULL);
    memset(&d, 0xa5, sizeof(d)); memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d)); memcpy(&c_before, &c, sizeof(c));
    assert(action_family_45_decode(NULL, 196u, &d) == ACTION_FAMILY_45_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_45_construct(NULL, 196u, 0u, 1u, &c) == ACTION_FAMILY_45_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_45_decode(raw, 196u, NULL) == ACTION_FAMILY_45_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_45_construct(raw, 196u, 0u, 1u, NULL) == ACTION_FAMILY_45_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_45_construct(raw, 196u, 0u, 0u, &c) == ACTION_FAMILY_45_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_45_decode((const uint8_t *)UINTPTR_MAX, 196u, &d) == ACTION_FAMILY_45_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_45_construct((const uint8_t *)UINTPTR_MAX, 196u, 0u, 1u, &c) == ACTION_FAMILY_45_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_45_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_45_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_45_construct(raw, SIZE_MAX, 0u, 1u, &c) == ACTION_FAMILY_45_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_45_decode(raw, 196u, (ActionFamily45Decoded *)UINTPTR_MAX) == ACTION_FAMILY_45_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_45_construct(raw, 196u, 0u, 1u, (ActionFamily45Constructed *)UINTPTR_MAX) == ACTION_FAMILY_45_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_45_decode((const uint8_t *)&d + 1u, 196u, &d) == ACTION_FAMILY_45_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_45_construct((const uint8_t *)&c + 1u, 196u, 0u, 1u, &c) == ACTION_FAMILY_45_ERR_OVERLAP); ++pointer_checks;
    assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
    free(raw);
}

int main(void)
{
    /* Complete encoded count domain: negative patterns and both narrowing
     * overflow boundaries included. Only 0..10 can reach a suffix read. */
    for (uint32_t count = 0u; count <= UINT16_MAX; ++count) {
        check_case(196u + (count <= 10u ? (size_t)count * 4u : 0u), (uint16_t)count);
    }
    for (uint16_t count = 0u; count <= 10u; ++count) {
        for (size_t tail = 0u; tail <= 256u; ++tail) {
            check_case(196u + (size_t)count * 4u + tail * 16u, count);
        }
        for (size_t length = 0u; length <= 300u; ++length) { check_case(length, count); }
    }
    check_case(236u + 65536u, 10u);
    for (size_t i = 0u; i < 20000u; ++i) {
        uint16_t count = (uint16_t)(next_random() % 11u);
        check_case(196u + (size_t)count * 4u + (size_t)(next_random() % 64u) * 16u, count);
    }
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t length = (size_t)(next_random() % 513u);
        uint16_t count = (uint16_t)next_random();
        check_case(length, count);
    }
    check_pointers();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"count_patterns\":65536,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
