/* Exact-size heap inputs expose even a one-byte overread to ASan. */
#include "action_family_4e.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases;
static size_t rejected_cases;
static size_t pointer_checks;
static uint32_t random_state = UINT32_C(0x4eb17e01);

static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}

static void check_case(size_t length, uint8_t option, uint16_t word)
{
    size_t allocation = length == 0u ? 1u : length;
    uint8_t *raw = malloc(allocation);
    uint8_t *before = malloc(allocation);
    ActionFamily4EDecoded d, d_before;
    ActionFamily4EConstructed c, c_before;
    ActionFamily4EStatus expected;
    size_t body_length = SIZE_MAX;
    uint32_t offset = next_random();
    assert(raw != NULL && before != NULL);
    for (size_t i = 0u; i < length; ++i) {
        raw[i] = (uint8_t)next_random();
    }
    if (length > 0u) {
        raw[0] = option;
    }
    for (size_t i = 0u; i < 10u; ++i) {
        size_t p = 1u + i * 3u;
        if (length > p) raw[p] = (uint8_t)(option + i);
        if (length > p + 1u) raw[p + 1u] = (uint8_t)word;
        if (length > p + 2u) raw[p + 2u] = (uint8_t)(word >> 8);
    }
    memcpy(before, raw, length);
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    expected = length < 31u ? ACTION_FAMILY_4E_ERR_BODY :
        (length - 31u) % 16u != 0u ? ACTION_FAMILY_4E_ERR_TAIL : ACTION_FAMILY_4E_OK;
    assert(action_family_4e_body_length(raw, length, &body_length) == expected);
    assert(action_family_4e_decode(raw, length, &d) == expected);
    assert(action_family_4e_construct(raw, length, offset, UINT32_C(0x4e0001), &c) == expected);
    assert(memcmp(raw, before, length) == 0);
    if (expected == ACTION_FAMILY_4E_OK) {
        assert(body_length == 31u && d.option_00 == option);
        for (size_t i = 0u; i < 10u; ++i) {
            assert(d.entries[i].option_00 == (uint8_t)(option + i));
            assert(d.entries[i].word_0 == word);
        }
        assert(d.body_bytes == 31u && d.available_body_bytes == length);
        assert(d.dependency_records == raw + 31u);
        assert(d.dependency_count == (length - 31u) / 16u);
        assert(d.dependency_bytes == length - 31u);
        assert(memcmp(c.object_bytes, raw, 31u) == 0);
        assert(c.body_bytes_consumed == 31u);
        assert(c.payload_offset_before == offset && c.payload_offset_after == offset + UINT32_C(31));
        assert(c.output_handle == UINT32_C(0x4e0001) && c.result_slot_handle == c.output_handle);
        assert(c.output_allocation_bytes == 31u && c.available_body_bytes == length);
        assert(c.dependency_records == d.dependency_records && c.dependency_count == d.dependency_count);
        assert(c.dependency_bytes == d.dependency_bytes);
        ++valid_cases;
    } else {
        assert(body_length == SIZE_MAX);
        assert(memcmp(&d, &d_before, sizeof(d)) == 0);
        assert(memcmp(&c, &c_before, sizeof(c)) == 0);
        ++rejected_cases;
    }
    free(before);
    free(raw);
}

static void check_pointers(void)
{
    uint8_t *raw = malloc(31u);
    ActionFamily4EDecoded d, d_before;
    ActionFamily4EConstructed c, c_before;
    size_t body_length = SIZE_MAX;
    assert(raw != NULL);
    memset(raw, 0x34, 31u);
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    assert(action_family_4e_decode(NULL, 31u, &d) == ACTION_FAMILY_4E_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_4e_construct(NULL, 31u, 0u, 1u, &c) == ACTION_FAMILY_4E_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_4e_body_length(NULL, 31u, &body_length) == ACTION_FAMILY_4E_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_4e_decode(raw, 31u, NULL) == ACTION_FAMILY_4E_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_4e_construct(raw, 31u, 0u, 1u, NULL) == ACTION_FAMILY_4E_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_4e_body_length(raw, 31u, NULL) == ACTION_FAMILY_4E_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_4e_construct(raw, 31u, 0u, 0u, &c) == ACTION_FAMILY_4E_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_4e_decode((const uint8_t *)UINTPTR_MAX, 31u, &d) == ACTION_FAMILY_4E_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_4e_construct((const uint8_t *)UINTPTR_MAX, 31u, 0u, 1u, &c) == ACTION_FAMILY_4E_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_4e_body_length((const uint8_t *)UINTPTR_MAX, 31u, &body_length) == ACTION_FAMILY_4E_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_4e_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_4E_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_4e_construct(raw, SIZE_MAX, 0u, 1u, &c) == ACTION_FAMILY_4E_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_4e_body_length(raw, SIZE_MAX, &body_length) == ACTION_FAMILY_4E_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_4e_decode(raw, 31u, (ActionFamily4EDecoded *)UINTPTR_MAX) == ACTION_FAMILY_4E_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_4e_construct(raw, 31u, 0u, 1u, (ActionFamily4EConstructed *)UINTPTR_MAX) == ACTION_FAMILY_4E_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_4e_body_length(raw, 31u, (size_t *)UINTPTR_MAX) == ACTION_FAMILY_4E_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_4e_decode((const uint8_t *)&d + 1u, 31u, &d) == ACTION_FAMILY_4E_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_4e_construct((const uint8_t *)&c + 1u, 31u, 0u, 1u, &c) == ACTION_FAMILY_4E_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_4e_body_length(raw, 31u, (size_t *)(void *)raw) == ACTION_FAMILY_4E_ERR_OVERLAP); ++pointer_checks;
    assert(body_length == SIZE_MAX);
    assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
    for (size_t i = 0u; i < 31u; ++i) assert(raw[i] == 0x34u);
    free(raw);
}

int main(void)
{
    for (uint32_t word = 0u; word <= UINT16_MAX; ++word) {
        check_case(31u + (size_t)(word % 4u) * 16u, (uint8_t)word, (uint16_t)word);
    }
    for (size_t tail = 0u; tail <= 256u; ++tail) {
        check_case(31u + tail * 16u, UINT8_MAX, UINT16_MAX);
    }
    check_case(31u + 65536u * 16u, 0x80u, UINT16_C(0x8000));
    for (size_t length = 0u; length <= 545u; ++length) {
        check_case(length, 0x80u, UINT16_C(0x8000));
    }
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t length = (size_t)(next_random() % 545u);
        uint8_t option = (uint8_t)next_random();
        uint16_t word = (uint16_t)next_random();
        check_case(length, option, word);
    }
    check_pointers();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"word_patterns\":65536,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
