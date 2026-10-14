#include "action_family_38.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t random_state = UINT32_C(0x384731);
static uint32_t next_random(void)
{
    random_state ^= random_state << 13;
    random_state ^= random_state >> 17;
    random_state ^= random_state << 5;
    return random_state;
}
static void put16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}
static void make_body(uint8_t *raw, int32_t start, size_t count)
{
    size_t i;
    for (i = 0u; i < 4096u; ++i) {
        raw[i] = (uint8_t)next_random();
    }
    memset(raw, 'X', 33u);
    raw[next_random() % 33u] = 0u;
    put16(raw + 0x33u, (uint16_t)start);
    put16(raw + 0x35u, (uint16_t)(start + (int32_t)count - 1));
}
static void check(uint8_t *raw, size_t length, const uint8_t *seed, int valid)
{
    ActionFamily38Decoded decoded;
    ActionFamily38Constructed object;
    uint8_t decoded_before[sizeof(decoded)];
    uint8_t object_before[sizeof(object)];
    uint8_t raw_before[4096];
    ActionFamily38Status ds;
    ActionFamily38Status cs;
    memset(&decoded, 0xa6, sizeof(decoded));
    memset(&object, 0xa6, sizeof(object));
    memcpy(decoded_before, &decoded, sizeof(decoded));
    memcpy(object_before, &object, sizeof(object));
    assert(length <= sizeof(raw_before));
    memcpy(raw_before, raw, length);
    ds = action_family_38_decode(raw, length, &decoded);
    cs = action_family_38_construct(raw, length, seed, ACTION_FAMILY_38_OBJECT_BYTES,
                                    next_random(), 1u, &object);
    assert(memcmp(raw_before, raw, length) == 0);
    if (valid) {
        assert(ds == ACTION_FAMILY_38_OK && cs == ACTION_FAMILY_38_OK);
        assert(decoded.body_bytes == object.body_bytes_consumed);
        assert(object.payload_offset_after == object.payload_offset_before +
               (uint32_t)object.body_bytes_consumed);
        assert(object.dependency_records == raw + decoded.body_bytes);
    } else {
        assert(ds != ACTION_FAMILY_38_OK && cs != ACTION_FAMILY_38_OK);
        assert(memcmp(&decoded, decoded_before, sizeof(decoded)) == 0);
        assert(memcmp(&object, object_before, sizeof(object)) == 0);
    }
}
int main(void)
{
    uint8_t raw[4096];
    uint8_t seed[ACTION_FAMILY_38_OBJECT_BYTES];
    ActionFamily38Constructed object;
    uint8_t before[sizeof(object)];
    size_t valid = 0u;
    size_t rejected = 0u;
    size_t i;
    int32_t word;
    for (i = 0u; i < sizeof(seed); ++i) {
        seed[i] = (uint8_t)next_random();
    }
    for (i = 0u; i < 20001u; ++i) {
        size_t count = next_random() % 101u;
        size_t tail = next_random() % 9u;
        int32_t start = (int32_t)(next_random() % 65000u) - 32500;
        make_body(raw, start, count);
        check(raw, 71u + count * 16u + tail * 16u, seed, 1);
        ++valid;
    }
    /* Exhaust all 16-bit start encodings, including the signed cut and
     * negative/65536-like copy lengths. Keep enough input for every safe row. */
    for (word = -32768; word <= 32767; ++word) {
        int32_t count = 1 - word;
        int safe = count >= 0 && count <= 100;
        make_body(raw, 0, 100u);
        put16(raw + 0x33u, (uint16_t)word);
        put16(raw + 0x35u, 0u);
        check(raw, 1671u, seed, safe);
        if (safe) { ++valid; } else { ++rejected; }
    }
    make_body(raw, -32768, 100u);
    for (i = 0u; i < 1671u; ++i) {
        uint8_t *short_input = malloc(i == 0u ? 1u : i);
        assert(short_input != NULL);
        memcpy(short_input, raw, i);
        check(short_input, i, seed, 0);
        free(short_input);
        ++rejected;
    }
    for (i = 1u; i < 16u; ++i) {
        make_body(raw, 0, 4u);
        check(raw, 135u + i, seed, 0);
        ++rejected;
    }
    make_body(raw, 0, 4u);
    memset(raw, 'X', 33u);
    check(raw, 135u, seed, 0);
    ++rejected;
    memset(&object, 0xa6, sizeof(object));
    memcpy(before, &object, sizeof(object));
    assert(action_family_38_construct(NULL, 135u, seed, sizeof(seed), 50u, 1u,
                                     &object) == ACTION_FAMILY_38_ERR_ARGUMENT);
    assert(action_family_38_construct(raw, 135u, NULL, sizeof(seed), 50u, 1u,
                                     &object) == ACTION_FAMILY_38_ERR_ARGUMENT);
    assert(action_family_38_construct(raw, 135u, seed, sizeof(seed) - 1u, 50u, 1u,
                                     &object) == ACTION_FAMILY_38_ERR_ALLOCATION);
    assert(action_family_38_construct(raw, 135u, seed, sizeof(seed), 50u, 0u,
                                     &object) == ACTION_FAMILY_38_ERR_ARGUMENT);
    assert(action_family_38_construct((const uint8_t *)&object, 135u, seed,
                sizeof(seed), 50u, 1u, &object) == ACTION_FAMILY_38_ERR_OVERLAP);
    assert(action_family_38_construct(raw, 135u, (const uint8_t *)&object,
                sizeof(seed), 50u, 1u, &object) == ACTION_FAMILY_38_ERR_OVERLAP);
    assert(action_family_38_construct((const uint8_t *)(UINTPTR_MAX - 32u), 135u,
                seed, sizeof(seed), 50u, 1u, &object) == ACTION_FAMILY_38_ERR_BOUNDS);
    assert(memcmp(before, &object, sizeof(object)) == 0);
    printf("{\"valid_cases\":%zu,\"rejected_cases\":%zu,\"special_pointer_checks\":7}\n",
           valid, rejected);
    return 0;
}
