/* Exact-size heap storage for every valid/short/ragged raw-body input (raw 0xaa, 763-byte body). */
#include "action_family_aa.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BODY 763u

static size_t valid_cases;
static size_t rejected_cases;
static size_t pointer_checks;
static uint32_t random_state = UINT32_C(0xaa2b7e01);

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
    ActionFamilyAADecoded d, d_before;
    ActionFamilyAAConstructed c, c_before;
    ActionFamilyAAStatus expected;
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
    expected = length < BODY ? ACTION_FAMILY_AA_ERR_BODY :
        (length - BODY) % 16u != 0u ? ACTION_FAMILY_AA_ERR_TAIL : ACTION_FAMILY_AA_OK;
    assert(action_family_aa_decode(raw, length, &d) == expected);
    assert(action_family_aa_body_length(raw, length, &typed) == expected);
    assert(action_family_aa_construct(raw, length, offset, UINT32_C(0xaa0001), &c) == expected);
    assert(memcmp(raw, before, length) == 0);
    if (expected == ACTION_FAMILY_AA_OK) {
        for (size_t i = 0u; i < 381u; ++i) {
            assert(d.word[i] == (uint16_t)((uint16_t)raw[2u * i] |
                                          ((uint16_t)raw[2u * i + 1u] << 8)));
        }
        assert(d.byte_762 == raw[762]);
        assert(typed == BODY && d.body_bytes == BODY && d.available_body_bytes == length);
        assert(d.dependency_records == raw + BODY);
        assert(d.dependency_count == (length - BODY) / 16u);
        assert(d.dependency_bytes == length - BODY);
        assert(memcmp(c.object_bytes, raw, BODY) == 0);
        assert(c.body_bytes_consumed == BODY);
        assert(c.payload_offset_before == offset && c.payload_offset_after == offset + UINT32_C(763));
        assert(c.result_slot_handle == UINT32_C(0xaa0001));
        assert(c.allocation_bytes == BODY && c.available_body_bytes == length);
        assert(c.raw_type == 0xaau && c.runtime_type == 0xaau);
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
    ActionFamilyAADecoded d, d_before;
    ActionFamilyAAConstructed c, c_before;
    size_t typed = SIZE_MAX;
    assert(raw != NULL);
    memset(raw, 0xaa, BODY);
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    assert(action_family_aa_decode(NULL, BODY, &d) == ACTION_FAMILY_AA_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_aa_construct(NULL, BODY, 0u, 1u, &c) == ACTION_FAMILY_AA_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_aa_body_length(NULL, BODY, &typed) == ACTION_FAMILY_AA_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_aa_decode(raw, BODY, NULL) == ACTION_FAMILY_AA_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_aa_construct(raw, BODY, 0u, 1u, NULL) == ACTION_FAMILY_AA_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_aa_body_length(raw, BODY, NULL) == ACTION_FAMILY_AA_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_aa_construct(raw, BODY, 0u, 0u, &c) == ACTION_FAMILY_AA_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_aa_decode((const uint8_t *)UINTPTR_MAX, BODY, &d) == ACTION_FAMILY_AA_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_aa_construct((const uint8_t *)UINTPTR_MAX, BODY, 0u, 1u, &c) == ACTION_FAMILY_AA_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_aa_body_length((const uint8_t *)UINTPTR_MAX, BODY, &typed) == ACTION_FAMILY_AA_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_aa_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_AA_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_aa_construct(raw, SIZE_MAX, 0u, 1u, &c) == ACTION_FAMILY_AA_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_aa_body_length(raw, SIZE_MAX, &typed) == ACTION_FAMILY_AA_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_aa_decode(raw, BODY, (ActionFamilyAADecoded *)UINTPTR_MAX) == ACTION_FAMILY_AA_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_aa_construct(raw, BODY, 0u, 1u, (ActionFamilyAAConstructed *)UINTPTR_MAX) == ACTION_FAMILY_AA_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_aa_body_length(raw, BODY, (size_t *)UINTPTR_MAX) == ACTION_FAMILY_AA_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_aa_decode((const uint8_t *)&d + 1u, BODY, &d) == ACTION_FAMILY_AA_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_aa_construct((const uint8_t *)&c + 1u, BODY, 0u, 1u, &c) == ACTION_FAMILY_AA_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_aa_body_length(raw, BODY, (size_t *)(void *)raw) == ACTION_FAMILY_AA_ERR_OVERLAP); ++pointer_checks;
    assert(typed == SIZE_MAX);
    assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
    for (size_t i = 0u; i < BODY; ++i) {
        assert(raw[i] == 0xaau);
    }
    free(raw);
}

int main(void)
{
    /* No count field exists: every first-word encoding is ordinary data. */
    for (uint32_t word = 0u; word <= UINT16_MAX; ++word) {
        check_case(BODY + (size_t)(word % 3u) * 16u, (uint16_t)word);
    }
    for (size_t tail = 0u; tail <= 256u; ++tail) {
        check_case(BODY + tail * 16u, UINT16_MAX);
    }
    check_case(BODY + 65536u * 16u, UINT16_C(0x8000));
    for (size_t length = 0u; length <= BODY + 40u; ++length) {
        check_case(length, UINT16_C(0x8000));
    }
    for (size_t tail = 1023u; tail <= 1025u; ++tail) {
        check_case(BODY + tail, UINT16_C(0x7fff));
    }
    for (size_t tail = 4079u; tail <= 4097u; ++tail) {
        check_case(BODY + tail, UINT16_C(0x7fff));
    }
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t length = (size_t)(next_random() % 1600u);
        uint16_t word = (uint16_t)next_random();
        check_case(length, word);
    }
    check_pointers();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"word_patterns\":65536,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
