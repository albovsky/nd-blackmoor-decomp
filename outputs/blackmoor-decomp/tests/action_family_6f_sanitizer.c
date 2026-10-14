#include "action_family_6f.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t random_state = UINT32_C(0x6f1471);
static uint32_t next_random(void)
{
    random_state ^= random_state << 13;
    random_state ^= random_state >> 17;
    random_state ^= random_state << 5;
    return random_state;
}

/* Every nonempty input is a separate exact-size allocation, for valid and
 * malformed cases alike. ASan can therefore detect even one extra byte read.
 * malloc(1) for the empty span provides a nonnull pointer, not readable input. */
static void check(size_t length, int valid)
{
    uint8_t *raw = malloc(length == 0u ? 1u : length);
    uint8_t *before = malloc(length == 0u ? 1u : length);
    ActionFamily6fDecoded decoded;
    ActionFamily6fConstructed object;
    uint8_t decoded_before[sizeof(decoded)];
    uint8_t object_before[sizeof(object)];
    uint32_t offset = next_random();
    ActionFamily6fStatus ds;
    ActionFamily6fStatus cs;
    size_t i;
    assert(raw != NULL && before != NULL);
    for (i = 0u; i < length; ++i) {
        raw[i] = (uint8_t)next_random();
    }
    memcpy(before, raw, length);
    memset(&decoded, 0xa6, sizeof(decoded));
    memset(&object, 0xa6, sizeof(object));
    memcpy(decoded_before, &decoded, sizeof(decoded));
    memcpy(object_before, &object, sizeof(object));
    ds = action_family_6f_decode(raw, length, &decoded);
    cs = action_family_6f_construct(raw, length, offset, 1u, &object);
    assert(memcmp(raw, before, length) == 0);
    if (valid) {
        assert(ds == ACTION_FAMILY_6F_OK && cs == ACTION_FAMILY_6F_OK);
        assert(decoded.option_00 == raw[0] && object.object_bytes[0] == raw[0]);
        assert(decoded.body_bytes == 1u && object.body_bytes_consumed == 1u);
        assert(decoded.dependency_records == raw + 1u);
        assert(object.dependency_records == raw + 1u);
        assert(decoded.dependency_count == (length - 1u) / 16u);
        assert(object.dependency_count == decoded.dependency_count);
        assert(decoded.dependency_bytes == length - 1u);
        assert(object.dependency_bytes == length - 1u);
        assert(decoded.available_body_bytes == length && object.available_body_bytes == length);
        assert(object.payload_offset_before == offset);
        assert(object.payload_offset_after == offset + UINT32_C(1));
        assert(object.result_slot_handle == 1u && object.allocation_bytes == 1u);
        assert(object.raw_type == 0x6fu && object.runtime_type == 0x6fu);
    } else {
        assert(ds != ACTION_FAMILY_6F_OK && cs != ACTION_FAMILY_6F_OK);
        assert(memcmp(&decoded, decoded_before, sizeof(decoded)) == 0);
        assert(memcmp(&object, object_before, sizeof(object)) == 0);
    }
    free(before);
    free(raw);
}

int main(void)
{
    size_t valid = 0u;
    size_t rejected = 0u;
    size_t i;
    size_t residue;
    uint8_t *raw = malloc(17u);
    ActionFamily6fDecoded decoded;
    ActionFamily6fConstructed object;
    uint8_t decoded_before[sizeof(decoded)];
    uint8_t object_before[sizeof(object)];
    assert(raw != NULL);
    memset(raw, 0x81, 17u);
    for (i = 0u; i < 20001u; ++i) {
        check(1u + 16u * (next_random() % 1025u), 1);
        ++valid;
    }
    check(65537u, 1); /* large accepted dependency count, not a body count */
    ++valid;
    check(0u, 0);
    ++rejected;
    for (i = 0u; i < 257u; ++i) {
        for (residue = 1u; residue < 16u; ++residue) {
            check(1u + 16u * i + residue, 0);
            ++rejected;
        }
    }
    for (i = 0u; i < 30000u; ++i) {
        size_t length = next_random() % 4098u;
        int safe = length >= 1u && (length - 1u) % 16u == 0u;
        check(length, safe);
        if (safe) { ++valid; } else { ++rejected; }
    }
    memset(&decoded, 0xa6, sizeof(decoded));
    memset(&object, 0xa6, sizeof(object));
    memcpy(decoded_before, &decoded, sizeof(decoded));
    memcpy(object_before, &object, sizeof(object));
    assert(action_family_6f_decode(NULL, 17u, &decoded) == ACTION_FAMILY_6F_ERR_ARGUMENT);
    assert(action_family_6f_decode(raw, 17u, NULL) == ACTION_FAMILY_6F_ERR_ARGUMENT);
    assert(action_family_6f_construct(NULL, 17u, 50u, 1u, &object) == ACTION_FAMILY_6F_ERR_ARGUMENT);
    assert(action_family_6f_construct(raw, 17u, 50u, 1u, NULL) == ACTION_FAMILY_6F_ERR_ARGUMENT);
    assert(action_family_6f_construct(raw, 17u, 50u, 0u, &object) == ACTION_FAMILY_6F_ERR_ARGUMENT);
    assert(action_family_6f_decode((const uint8_t *)(UINTPTR_MAX - 3u), 17u,
                                  &decoded) == ACTION_FAMILY_6F_ERR_BOUNDS);
    assert(action_family_6f_construct((const uint8_t *)(UINTPTR_MAX - 3u), 17u,
                50u, 1u, &object) == ACTION_FAMILY_6F_ERR_BOUNDS);
    assert(action_family_6f_decode(raw, 17u, (ActionFamily6fDecoded *)(UINTPTR_MAX - 3u)) ==
           ACTION_FAMILY_6F_ERR_BOUNDS);
    assert(action_family_6f_construct(raw, 17u, 50u, 1u,
                (ActionFamily6fConstructed *)(UINTPTR_MAX - 3u)) == ACTION_FAMILY_6F_ERR_BOUNDS);
    assert(action_family_6f_decode(raw, SIZE_MAX, &decoded) == ACTION_FAMILY_6F_ERR_BOUNDS);
    assert(action_family_6f_construct(raw, SIZE_MAX, 50u, 1u, &object) == ACTION_FAMILY_6F_ERR_BOUNDS);
    assert(action_family_6f_decode((const uint8_t *)&decoded, 17u, &decoded) == ACTION_FAMILY_6F_ERR_OVERLAP);
    assert(action_family_6f_construct((const uint8_t *)&object, 17u, 50u, 1u,
                                      &object) == ACTION_FAMILY_6F_ERR_OVERLAP);
    assert(memcmp(&decoded, decoded_before, sizeof(decoded)) == 0);
    assert(memcmp(&object, object_before, sizeof(object)) == 0);
    free(raw);
    printf("{\"valid_cases\":%zu,\"rejected_cases\":%zu,\"special_pointer_checks\":13,"
           "\"random_cases\":30000,\"exact_size_heap_inputs\":true}\n", valid, rejected);
    return 0;
}
