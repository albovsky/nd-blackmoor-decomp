/* Every nonempty input is an exact-size heap allocation, including valid
 * maximum counts. Empty inputs allocate one byte but advertise zero. */
#include "action_family_1b.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases;
static size_t rejected_cases;
static size_t pointer_checks;
static uint32_t state = UINT32_C(0x1b147001);

static uint32_t random32(void)
{
    state = state * UINT32_C(1664525) + UINT32_C(1013904223);
    return state;
}

static unsigned word(const uint8_t *p)
{
    return (unsigned)p[0] + (unsigned)p[1] * 256u;
}

static void put16(uint8_t *p, unsigned value)
{
    p[0] = (uint8_t)value;
    p[1] = (uint8_t)(value >> 8);
}

static void put32(uint8_t *p, uint32_t value)
{
    for (size_t i = 0u; i < 4u; ++i) p[i] = (uint8_t)(value >> (i * 8u));
}

static void check(const uint8_t *data, size_t length)
{
    uint8_t *raw = malloc(length == 0u ? 1u : length);
    ActionFamily1bDecoded d, d_before;
    ActionFamily1bConstructed c, c_before;
    size_t n = SIZE_MAX;
    size_t typed = 0u;
    size_t primary = 0u;
    size_t secondary = 0u;
    ActionFamily1bStatus expected;
    uint32_t offset = random32();
    assert(raw != NULL);
    if (length != 0u) memcpy(raw, data, length);
    /* Independent fixture extent specification. */
    expected = ACTION_FAMILY_1B_ERR_BODY;
    if (length >= 2u) {
        primary = word(raw);
        if (primary >= 32768u) {
            expected = ACTION_FAMILY_1B_ERR_COUNT;
        } else if (length >= 26u + primary * 22u) {
            secondary = word(raw + 24u + primary * 22u);
            if (secondary >= 32768u) {
                expected = ACTION_FAMILY_1B_ERR_COUNT;
            } else {
                typed = 26u + primary * 22u + secondary * 18u;
                if (length >= typed) expected = (length - typed) % 16u == 0u ?
                    ACTION_FAMILY_1B_OK : ACTION_FAMILY_1B_ERR_TAIL;
            }
        }
    }
    memset(&d, 0xa5, sizeof(d)); memcpy(&d_before, &d, sizeof(d));
    memset(&c, 0x5a, sizeof(c)); memcpy(&c_before, &c, sizeof(c));
    assert(action_family_1b_decode(raw, length, &d) == expected);
    assert(action_family_1b_body_length(raw, length, &n) == expected);
    assert(action_family_1b_construct(raw, length, offset, UINT32_C(0x30005000),
        UINT32_C(0x31000000), UINT32_C(0x32000000), &c) == expected);
    assert(length == 0u || memcmp(raw, data, length) == 0);
    if (expected != ACTION_FAMILY_1B_OK) {
        assert(n == SIZE_MAX);
        assert(memcmp(&d, &d_before, sizeof(d)) == 0);
        assert(memcmp(&c, &c_before, sizeof(c)) == 0);
        ++rejected_cases;
    } else {
        uint8_t object[34]; /* Output expectation only; inputs are heap backed. */
        put16(object, (unsigned)primary); put32(object + 2u, UINT32_C(0x31000000));
        memcpy(object + 6u, raw + 2u + primary * 22u, 22u);
        put16(object + 28u, (unsigned)secondary); put32(object + 30u, UINT32_C(0x32000000));
        assert(d.raw_type == 0x1bu && d.runtime_type == 0x1bu);
        assert(d.primary_count == (int16_t)primary && d.secondary_count == (int16_t)secondary);
        for (size_t i = 0u; i < 5u; ++i) assert(d.fixed_words[i] == word(object + 6u + i * 2u));
        for (size_t i = 0u; i < 3u; ++i) {
            size_t at = 16u + i * 4u;
            assert(d.fixed_dwords[i] == (uint32_t)word(object + at) + ((uint32_t)word(object + at + 2u) << 16));
        }
        assert(d.primary_records == raw + 2u && d.primary_bytes == primary * 22u);
        assert(d.secondary_records == raw + 26u + primary * 22u && d.secondary_bytes == secondary * 18u);
        assert(d.body_bytes == typed && n == typed && d.available_body_bytes == length);
        assert(d.dependency_records == raw + typed && d.dependency_bytes == length - typed);
        assert(d.dependency_count == (length - typed) / 16u);
        assert(memcmp(c.object_bytes, object, 34u) == 0);
        assert(c.primary_records == d.primary_records && c.primary_bytes == d.primary_bytes);
        assert(c.secondary_records == d.secondary_records && c.secondary_bytes == d.secondary_bytes);
        assert(c.dependency_records == d.dependency_records && c.dependency_count == d.dependency_count);
        assert(c.dependency_bytes == d.dependency_bytes && c.available_body_bytes == length);
        assert(c.body_bytes_consumed == typed && c.payload_offset_before == offset);
        assert(c.payload_offset_after == offset + (uint32_t)typed);
        assert(c.result_slot_handle == UINT32_C(0x30005000) && c.owner_field_1c == c.result_slot_handle);
        assert(c.owner_field_20 == UINT32_C(0x31000000) && c.owner_field_24 == UINT32_C(0x32000000));
        assert(c.output_allocation_bytes == 34u && c.allocation_count == 3u);
        assert(c.primary_allocation_bytes == primary * 22u && c.secondary_allocation_bytes == secondary * 18u);
        ++valid_cases;
    }
    free(raw);
}

static uint8_t *fixture(unsigned p, unsigned s, size_t tail, size_t *size)
{
    uint8_t *raw;
    *size = 26u + (size_t)p * 22u + (size_t)s * 18u + tail;
    raw = malloc(*size);
    assert(raw != NULL);
    for (size_t i = 0u; i < *size; ++i) raw[i] = (uint8_t)(random32() >> 24);
    put16(raw, p); put16(raw + 24u + (size_t)p * 22u, s);
    return raw;
}

static void pointers(void)
{
    size_t length, n = SIZE_MAX;
    uint8_t *raw = fixture(1u, 1u, 0u, &length);
    ActionFamily1bDecoded d, before;
    ActionFamily1bConstructed c, cbefore;
    memset(&d, 0xa5, sizeof(d)); memcpy(&before, &d, sizeof(d));
    memset(&c, 0xa5, sizeof(c)); memcpy(&cbefore, &c, sizeof(c));
#define CHECK(expr, status) do { assert((expr) == (status)); ++pointer_checks; } while (0)
    CHECK(action_family_1b_decode(NULL, length, &d), ACTION_FAMILY_1B_ERR_ARGUMENT);
    CHECK(action_family_1b_decode(raw, length, NULL), ACTION_FAMILY_1B_ERR_ARGUMENT);
    CHECK(action_family_1b_body_length(NULL, length, &n), ACTION_FAMILY_1B_ERR_ARGUMENT);
    CHECK(action_family_1b_body_length(raw, length, NULL), ACTION_FAMILY_1B_ERR_ARGUMENT);
    CHECK(action_family_1b_construct(NULL, length, 50u, 1u, 2u, 3u, &c), ACTION_FAMILY_1B_ERR_ARGUMENT);
    CHECK(action_family_1b_construct(raw, length, 50u, 1u, 2u, 3u, NULL), ACTION_FAMILY_1B_ERR_ARGUMENT);
    for (unsigned i = 0u; i < 3u; ++i) {
        uint32_t h[3] = {1u, 2u, 3u}; h[i] = 0u;
        CHECK(action_family_1b_construct(raw, length, 50u, h[0], h[1], h[2], &c), ACTION_FAMILY_1B_ERR_ARGUMENT);
        h[i] = UINT32_MAX;
        CHECK(action_family_1b_construct(raw, length, 50u, h[0], h[1], h[2], &c), ACTION_FAMILY_1B_ERR_BOUNDS);
    }
    CHECK(action_family_1b_decode(raw, SIZE_MAX, &d), ACTION_FAMILY_1B_ERR_BOUNDS);
    CHECK(action_family_1b_body_length(raw, SIZE_MAX, &n), ACTION_FAMILY_1B_ERR_BOUNDS);
    CHECK(action_family_1b_construct(raw, SIZE_MAX, 50u, 1u, 2u, 3u, &c), ACTION_FAMILY_1B_ERR_BOUNDS);
    CHECK(action_family_1b_decode((const uint8_t *)UINTPTR_MAX, length, &d), ACTION_FAMILY_1B_ERR_BOUNDS);
    CHECK(action_family_1b_body_length((const uint8_t *)UINTPTR_MAX, length, &n), ACTION_FAMILY_1B_ERR_BOUNDS);
    CHECK(action_family_1b_construct((const uint8_t *)UINTPTR_MAX, length, 50u, 1u, 2u, 3u, &c), ACTION_FAMILY_1B_ERR_BOUNDS);
    CHECK(action_family_1b_decode(raw, length, (ActionFamily1bDecoded *)UINTPTR_MAX), ACTION_FAMILY_1B_ERR_BOUNDS);
    CHECK(action_family_1b_body_length(raw, length, (size_t *)UINTPTR_MAX), ACTION_FAMILY_1B_ERR_BOUNDS);
    CHECK(action_family_1b_construct(raw, length, 50u, 1u, 2u, 3u, (ActionFamily1bConstructed *)UINTPTR_MAX), ACTION_FAMILY_1B_ERR_BOUNDS);
    CHECK(action_family_1b_decode((const uint8_t *)&d, 26u, &d), ACTION_FAMILY_1B_ERR_OVERLAP);
    CHECK(action_family_1b_body_length((const uint8_t *)&n, sizeof(n), &n), ACTION_FAMILY_1B_ERR_OVERLAP);
    CHECK(action_family_1b_construct((const uint8_t *)&c, 26u, 50u, 1u, 2u, 3u, &c), ACTION_FAMILY_1B_ERR_OVERLAP);
    assert(memcmp(&d, &before, sizeof(d)) == 0 && memcmp(&c, &cbefore, sizeof(c)) == 0 && n == SIZE_MAX);
#undef CHECK
    free(raw);
}

int main(void)
{
    size_t size;
    uint8_t *raw;
    /* All 65,536 count bit patterns in BOTH slots, bounded missing arrays. */
    for (unsigned bits = 0u; bits <= UINT16_MAX; ++bits) {
        raw = fixture(0u, 0u, 0u, &size);
        put16(raw, bits); check(raw, size); put16(raw, 0u);
        put16(raw + 24u, bits); check(raw, size);
        free(raw);
    }
    for (unsigned p = 0u; p <= 8u; ++p) for (unsigned s = 0u; s <= 8u; ++s) {
        raw = fixture(p, s, 0u, &size);
        for (size_t n = 0u; n <= size; ++n) check(raw, n);
        free(raw);
        for (size_t tail = 0u; tail <= 40u; ++tail) {
            raw = fixture(p, s, tail, &size); check(raw, size); free(raw);
        }
    }
    for (unsigned i = 0u; i < 3u; ++i) {
        raw = fixture(i == 1u ? 0u : 32767u, i == 0u ? 0u : 32767u, 32u, &size);
        check(raw, size); free(raw);
    }
    for (size_t i = 0u; i < 10000u; ++i) {
        unsigned p = random32() % 33u, s = random32() % 33u;
        raw = fixture(p, s, (random32() % 5u) * 16u, &size);
        check(raw, size);
        size_t index = random32() % size; raw[index] ^= (uint8_t)(1u << (random32() % 8u));
        check(raw, size); free(raw);
    }
    for (size_t i = 0u; i < 30000u; ++i) {
        size = random32() % 1025u; raw = malloc(size == 0u ? 1u : size); assert(raw != NULL);
        for (size_t n = 0u; n < size; ++n) raw[n] = (uint8_t)(random32() >> 24);
        check(raw, size); free(raw);
    }
    pointers();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"count_slot_patterns\":131072,\"bounded_mutations\":40000,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
