/* Exact-size heap inputs expose even a one-byte overread to ASan. */
#include "action_family_94.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases;
static size_t rejected_cases;
static size_t pointer_checks;
static uint32_t random_state = UINT32_C(0x94b17e01);

static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}

static void check_case(size_t length, uint32_t word)
{
    size_t allocation = length == 0u ? 1u : length;
    uint8_t *raw = malloc(allocation);
    uint8_t *before = malloc(allocation);
    ActionFamily94Decoded d;
    ActionFamily94Decoded d_before;
    ActionFamily94Constructed c;
    ActionFamily94Constructed c_before;
    ActionFamily94Status expected;
    uint32_t offset = next_random();
    assert(raw != NULL && before != NULL);
    for (size_t i = 0u; i < length; ++i) {
        raw[i] = (uint8_t)next_random();
    }
    /* Four unaligned LE DWORDs with different bit patterns. */
    const uint32_t fields[4] = {word, (uint32_t)word ^ UINT32_MAX,
        (uint32_t)word ^ UINT32_C(0x12345678), (uint32_t)word ^ UINT32_C(0x87654321)};
    for (size_t field = 0u; field < 4u; ++field) {
        for (size_t byte = 0u; byte < 4u; ++byte) {
            size_t at = 33u + field * 4u + byte;
            if (at < length) { raw[at] = (uint8_t)(fields[field] >> (byte * 8u)); }
        }
    }
    if (length > 49u) { raw[49] = (uint8_t)word; }
    memcpy(before, raw, length);
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    expected = length < 50u ? ACTION_FAMILY_94_ERR_BODY :
        (length - 50u) % 16u != 0u ? ACTION_FAMILY_94_ERR_TAIL : ACTION_FAMILY_94_OK;
    assert(action_family_94_decode(raw, length, &d) == expected);
    assert(action_family_94_construct(raw, length, offset, UINT32_C(0x940001), &c) == expected);
    assert(memcmp(raw, before, length) == 0);
    if (expected == ACTION_FAMILY_94_OK) {
        assert(d.word_21 == word && d.word_25 == (word ^ UINT32_MAX) &&
               d.word_29 == (word ^ UINT32_C(0x12345678)) &&
               d.word_2d == (word ^ UINT32_C(0x87654321)));
        assert(d.body_bytes == 50u && d.available_body_bytes == length);
        assert(d.dependency_records == raw + 50u);
        assert(d.dependency_count == (length - 50u) / 16u);
        assert(d.dependency_bytes == length - 50u);
        assert(memcmp(c.object_bytes, raw, 50u) == 0);
        assert(c.body_bytes_consumed == 50u);
        assert(c.payload_offset_before == offset && c.payload_offset_after == offset + UINT32_C(50));
        assert(c.result_slot_handle == UINT32_C(0x940001));
        assert(c.allocation_bytes == 50u && c.available_body_bytes == length);
        assert(c.dependency_records == d.dependency_records && c.dependency_count == d.dependency_count);
        assert(c.dependency_bytes == d.dependency_bytes);
        assert(memcmp(d.option_00, raw, 33u) == 0 && d.option_31 == (uint8_t)word);
        assert(c.raw_type == 0x94u && c.runtime_type == 0x94u);
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
    uint8_t *raw = malloc(50u);
    ActionFamily94Decoded d, d_before;
    ActionFamily94Constructed c, c_before;
    assert(raw != NULL);
    raw[0] = 0x12u;
    raw[1] = 0x34u;
    memset(&d, 0xa5, sizeof(d));
    memset(&c, 0x5a, sizeof(c));
    memcpy(&d_before, &d, sizeof(d));
    memcpy(&c_before, &c, sizeof(c));
    assert(action_family_94_decode(NULL, 50u, &d) == ACTION_FAMILY_94_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_94_construct(NULL, 50u, 0u, 1u, &c) == ACTION_FAMILY_94_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_94_decode(raw, 50u, NULL) == ACTION_FAMILY_94_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_94_construct(raw, 50u, 0u, 1u, NULL) == ACTION_FAMILY_94_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_94_construct(raw, 50u, 0u, 0u, &c) == ACTION_FAMILY_94_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_94_decode((const uint8_t *)UINTPTR_MAX, 50u, &d) == ACTION_FAMILY_94_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_94_construct((const uint8_t *)UINTPTR_MAX, 50u, 0u, 1u, &c) == ACTION_FAMILY_94_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_94_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_94_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_94_construct(raw, SIZE_MAX, 0u, 1u, &c) == ACTION_FAMILY_94_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_94_decode(raw, 50u, (ActionFamily94Decoded *)UINTPTR_MAX) == ACTION_FAMILY_94_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_94_construct(raw, 50u, 0u, 1u, (ActionFamily94Constructed *)UINTPTR_MAX) == ACTION_FAMILY_94_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_94_decode((const uint8_t *)&d + 1u, 50u, &d) == ACTION_FAMILY_94_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_94_construct((const uint8_t *)&c + 1u, 50u, 0u, 1u, &c) == ACTION_FAMILY_94_ERR_OVERLAP); ++pointer_checks;
    assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
    assert(raw[0] == 0x12u && raw[1] == 0x34u);
    free(raw);
}

int main(void)
{
    /* Exhaust all low-16-bit patterns; test full DWORD endpoints below. */
    for (uint32_t word = 0u; word <= UINT16_MAX; ++word) {
        check_case(50u + (size_t)(word % 4u) * 16u, word);
    }
    for (size_t tail = 0u; tail <= 256u; ++tail) {
        check_case(50u + tail * 16u, UINT16_MAX);
    }
    for (size_t length = 0u; length <= 257u; ++length) {
        check_case(length, UINT16_C(0x8000));
    }
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t length = (size_t)(next_random() % 513u);
        uint32_t word = next_random();
        check_case(length, word);
    }
    check_case(50u + 4096u * 16u, UINT32_MAX);
    check_case(50u, UINT32_C(0x80000000));
    check_case(50u, UINT32_C(0x7fffffff));
    check_pointers();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"word_patterns\":65536,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
